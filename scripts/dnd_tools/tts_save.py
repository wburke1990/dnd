"""Tabletop Simulator save-file I/O.

A TTS save is a single (often very large) JSON document with this top-
level shape:

    { "SaveName": "...", "LuaScript": "...", "LuaScriptState": "...",
      "ObjectStates": [ <object>, <object>, ... ], ... }

Each object has a `GUID`, a `Name`, often a `Nickname`, and may carry
`LuaScript`, `XmlUI`, `CustomImage`, `CustomMesh`, etc. Bagged objects
nest under a `ContainedObjects` field that recurses with the same shape.

Auto-saves can be 100MB+, so this module:
  * never returns the parsed dict into user-facing CLI text
  * extracts per-object Lua/XML to disk for clean editing & linting
  * round-trips losslessly (unpack then pack ⇒ byte-identical content
    after `json.dumps(..., indent=2)` since TTS itself pretty-prints)
"""

from __future__ import annotations

import json
from collections.abc import Iterator
from pathlib import Path
from typing import Any

# Aliases for clarity — these JSON blobs are nested dicts of `Any`.
Save = dict[str, Any]
TTSObject = dict[str, Any]


def load_save(path: Path) -> Save:
    """Parse a save JSON from disk. Caller is responsible for not echoing it."""
    with path.open() as f:
        data: Save = json.load(f)
    return data


def write_save(path: Path, save: Save) -> None:
    """Pretty-print a save back to disk in TTS's native indent-2 style."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w") as f:
        json.dump(save, f, indent=2, ensure_ascii=False)
        f.write("\n")


def walk_objects(save: Save) -> Iterator[TTSObject]:
    """Yield every object in the save, recursing into ContainedObjects bags.

    Yields the top-level Global pseudo-object too (synthesised) so callers
    that want to handle the save-level LuaScript can use the same loop.
    """
    # Synthesise a pseudo-object for the global script so unpack/pack can
    # treat it uniformly with object-level scripts.
    yield {
        "GUID": "__global__",
        "Name": "Global",
        "Nickname": "Global",
        "LuaScript": save.get("LuaScript", ""),
        "XmlUI": save.get("XmlUI", ""),
        "LuaScriptState": save.get("LuaScriptState", ""),
        "_is_global": True,
    }
    for obj in save.get("ObjectStates", []) or []:
        yield from _walk(obj)


def _walk(obj: TTSObject) -> Iterator[TTSObject]:
    yield obj
    for child in obj.get("ContainedObjects", []) or []:
        yield from _walk(child)


# =============================================================================
# Unpack: save → tts/lua/<save>/<guid>.{lua,xml}
# =============================================================================


def unpack_save(save_path: Path, out_dir: Path) -> dict[str, int]:
    """Extract every non-empty LuaScript/XmlUI into per-object files.

    Returns counts: {"lua": N, "xml": M, "objects": K}. The output layout is
    flat with `<guid>.lua` / `<guid>.xml`; the Global script lands at
    `__global__.lua`. A `_manifest.json` records the object name/nickname
    per GUID so a later `pack` knows where to inject — and so a human can
    open `<guid>.lua` and tell what they're editing.
    """
    save = load_save(save_path)
    out_dir.mkdir(parents=True, exist_ok=True)
    manifest: dict[str, dict[str, str]] = {}
    counts = {"lua": 0, "xml": 0, "objects": 0}

    for obj in walk_objects(save):
        guid = str(obj.get("GUID") or "")
        if not guid:
            continue
        counts["objects"] += 1
        manifest[guid] = {
            "name": str(obj.get("Name", "")),
            "nickname": str(obj.get("Nickname", "")),
        }
        lua = str(obj.get("LuaScript") or "")
        xml = str(obj.get("XmlUI") or "")
        if lua.strip():
            (out_dir / f"{guid}.lua").write_text(lua)
            counts["lua"] += 1
        if xml.strip():
            (out_dir / f"{guid}.xml").write_text(xml)
            counts["xml"] += 1

    (out_dir / "_manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n"
    )
    return counts


# =============================================================================
# Pack: tts/lua/<save>/*.{lua,xml} → save (mutates in place)
# =============================================================================


def pack_save(save_path: Path, lua_dir: Path, out_path: Path) -> dict[str, int]:
    """Re-inject Lua/XML from `lua_dir` back into the save, writing to out_path.

    Objects whose GUID has no corresponding `<guid>.lua`/`<guid>.xml` keep
    whatever script they already had. Missing files do NOT erase scripts —
    use `<guid>.lua` containing an empty file to deliberately clear one.
    """
    save = load_save(save_path)
    counts = {"lua": 0, "xml": 0}

    available_lua = {p.stem for p in lua_dir.glob("*.lua")}
    available_xml = {p.stem for p in lua_dir.glob("*.xml")}

    if "__global__" in available_lua:
        save["LuaScript"] = (lua_dir / "__global__.lua").read_text()
        counts["lua"] += 1
    if "__global__" in available_xml:
        save["XmlUI"] = (lua_dir / "__global__.xml").read_text()
        counts["xml"] += 1

    def _inject(obj: TTSObject) -> None:
        guid = str(obj.get("GUID") or "")
        if not guid:
            return
        if guid in available_lua:
            obj["LuaScript"] = (lua_dir / f"{guid}.lua").read_text()
            counts["lua"] += 1
        if guid in available_xml:
            obj["XmlUI"] = (lua_dir / f"{guid}.xml").read_text()
            counts["xml"] += 1
        for child in obj.get("ContainedObjects", []) or []:
            _inject(child)

    for obj in save.get("ObjectStates", []) or []:
        _inject(obj)

    write_save(out_path, save)
    return counts


# =============================================================================
# Combine: splice ObjectStates from save B into save A
# =============================================================================


def combine_saves(
    base_path: Path,
    overlay_path: Path,
    out_path: Path,
    *,
    select_guids: set[str] | None = None,
) -> dict[str, int]:
    """Append every top-level object from overlay into base.

    If `select_guids` is given, only those GUIDs are copied. GUIDs that
    collide with existing objects in `base` get a new random GUID via
    Python's secrets module to satisfy TTS's uniqueness requirement.
    """
    import secrets

    base = load_save(base_path)
    overlay = load_save(overlay_path)
    base_states = base.setdefault("ObjectStates", [])
    existing_guids = {str(o.get("GUID")) for o in walk_objects(base) if o.get("GUID")}

    added = 0
    renamed = 0
    for obj in overlay.get("ObjectStates", []) or []:
        guid = str(obj.get("GUID") or "")
        if select_guids is not None and guid not in select_guids:
            continue
        if guid and guid in existing_guids:
            new_guid = secrets.token_hex(3)  # TTS uses 6-char hex
            obj["GUID"] = new_guid
            existing_guids.add(new_guid)
            renamed += 1
        elif guid:
            existing_guids.add(guid)
        base_states.append(obj)
        added += 1

    write_save(out_path, base)
    return {"added": added, "renamed": renamed}
