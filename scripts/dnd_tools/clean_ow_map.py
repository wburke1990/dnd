"""Remove or dead-asset-prune OneWorld maps in a save.

The inverse/companion of :mod:`dnd_tools.import_ow_map`. Two operations,
both mutate a save in place and both are idempotent:

``remove_ow_map``
    Fully un-register a map: delete its ``OWx_<Name>`` bag from ``mBag``,
    its ``SBx_<Name>`` token from ``aBag``, and its JotBase line from
    ``aBag.LuaScript``. Use when a map was imported but isn't wanted.

``prune_dead_assets``
    Keep the map but silence "Failed to import asset" spam. Given a set
    of dead URLs (probe them with :func:`probe_urls`, or pass known-dead
    ones), it walks the map's ``OWx`` subtree and, per piece:

    * if the piece's **mesh** (``MeshURL`` / ``AssetbundleURL``) is dead,
      the piece can't render at all — **remove the object** and strip its
      line from the SBx position manifest;

    * if the piece is **image-defined** (a ``Custom_Token`` / ``Custom_Tile``
      / ``Figurine_Custom`` — no mesh of its own) and its defining
      ``ImageURL`` is dead — **remove the object** too. Its image *is* the
      object, so blanking the field to ``""`` doesn't silence the failure:
      TTS then throws its own "failed to import" error on the empty URL
      (the blank-placeholder-figurine failure mode). This is the
      Custom_Token import error the plain texture-blank missed; and

    * otherwise (a live mesh but a dead **texture** — ``DiffuseURL`` /
      ``NormalURL`` / ``ColliderURL`` / a secondary image field) — **blank
      just that field**, so the piece still spawns (untextured) and TTS
      never fetches the dead URL.

    Net effect: every dead-URL fetch is eliminated, so the load is quiet,
    while every piece that can still render is kept.

Asset URLs live in nested sub-dicts (``CustomMesh``, ``CustomImage``,
``CustomDeck`` entries, ``States`` …), never as top-level object keys, so
the walkers descend into a piece's own structure but stop at
``ContainedObjects`` boundaries — a bag-in-bag child is a separate piece,
categorized on its own.
"""

from __future__ import annotations

import argparse
import concurrent.futures
import json
import sys
import urllib.request
from collections.abc import Callable, Iterator
from pathlib import Path
from typing import Any

from dnd_tools.fix_oneworld import ABAG_GUID, delete_contained, delete_jotbase_lines, find_object
from dnd_tools.import_ow_map import MBAG_GUID

# Same canonical asset-URL field set the asset tooling uses
# (``ASSET_FIELDS`` in tts_assets.py). These are the only fields whose
# values TTS fetches at load; Description/LuaScript may mention URLs
# without depending on them, so they are intentionally excluded.
ASSET_FIELDS = (
    "ImageURL",
    "ImageSecondaryURL",
    "MeshURL",
    "ColliderURL",
    "DiffuseURL",
    "NormalURL",
    "FaceURL",
    "BackURL",
    "AssetbundleURL",
    "AssetbundleSecondaryURL",
    "URL",
)

# A dead value in one of these fields means the piece cannot render at
# all (no geometry) — the object is removed rather than blanked.
FATAL_FIELDS = frozenset({"MeshURL", "AssetbundleURL"})

# The defining image of an image-only object (Custom_Token, Custom_Tile,
# Figurine_Custom): it has no mesh, so this URL *is* the object. If it is
# dead the object must be removed, not blanked — a token left with an empty
# ImageURL makes TTS throw its own import error on the empty string. Only
# fatal when the piece carries no geometry of its own (on a Custom_Model an
# ImageURL would just be a texture, safe to blank).
IMAGE_DEFINING_FIELD = "ImageURL"


class CleanError(RuntimeError):
    """Raised when a clean/remove precondition is not met."""


# --------------------------------------------------------------------------
# Subtree walkers
# --------------------------------------------------------------------------
def iter_objects(obj: dict[str, Any]) -> Iterator[dict[str, Any]]:
    """Yield ``obj`` then every recursively contained object (pieces)."""
    yield obj
    for child in obj.get("ContainedObjects") or []:
        if isinstance(child, dict):
            yield from iter_objects(child)


def iter_own_assets(obj: dict[str, Any]) -> Iterator[tuple[dict[str, Any], str, str]]:
    """Yield ``(container, field, url)`` for one piece's OWN asset fields.

    Descends into the piece's sub-dicts (``CustomMesh``, ``CustomImage``,
    ``States`` …) but NOT into ``ContainedObjects`` — a contained child is
    a separate piece whose assets belong to it, not to this one. So each
    asset URL is attributed to exactly the object that owns it.
    """

    def walk(node: Any) -> Iterator[tuple[dict[str, Any], str, str]]:
        if isinstance(node, dict):
            for f in ASSET_FIELDS:
                v = node.get(f)
                if isinstance(v, str) and v.strip():
                    yield (node, f, v.strip())
            for k, v in node.items():
                if k == "ContainedObjects":
                    continue
                yield from walk(v)
        elif isinstance(node, list):
            for v in node:
                yield from walk(v)

    yield from walk(obj)


def collect_map_urls(bag: dict[str, Any]) -> dict[str, list[tuple[str, str]]]:
    """Every asset URL in the OWx subtree → list of (object_guid, field)."""
    urls: dict[str, list[tuple[str, str]]] = {}
    for piece in iter_objects(bag):
        gid = piece.get("GUID", "")
        for _container, field, url in iter_own_assets(piece):
            urls.setdefault(url, []).append((gid, field))
    return urls


# --------------------------------------------------------------------------
# Dead-URL probing (network) — injectable for tests
# --------------------------------------------------------------------------
def _probe_one(url: str, timeout: float = 8.0) -> bool:
    """True if the URL is dead: non-200, or 200-but-HTML (wrong content)."""
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=timeout) as r:
            body = r.read(500).lower()
            if r.getcode() != 200:
                return True
            return b"<html" in body or b"<!doctype" in body
    except Exception:  # any fetch failure means dead-for-TTS
        return True


def probe_urls(urls: list[str], *, max_workers: int = 12) -> set[str]:
    """GET-probe each URL concurrently; return the set found dead."""
    dead: set[str] = set()
    if not urls:
        return dead
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as ex:
        for url, is_dead in zip(urls, ex.map(_probe_one, urls), strict=False):
            if is_dead:
                dead.add(url)
    return dead


# --------------------------------------------------------------------------
# Prune planning + application (pure, no network)
# --------------------------------------------------------------------------
def plan_prune(
    bag: dict[str, Any], dead_urls: set[str]
) -> tuple[set[str], list[tuple[dict[str, Any], str]]]:
    """Decide, per piece, what to remove vs. what field to blank.

    Returns ``(remove_guids, blank_ops)`` where ``blank_ops`` is a list of
    ``(container_dict, field_name)`` to set to ``""``.
    """
    remove_guids: set[str] = set()
    blank_ops: list[tuple[dict[str, Any], str]] = []
    for piece in iter_objects(bag):
        own = list(iter_own_assets(piece))
        dead_here = [(container, field) for container, field, url in own if url in dead_urls]
        if not dead_here:
            continue
        # A piece with its own mesh/assetbundle is geometry-defined: its
        # ImageURL/DiffuseURL are textures ON that geometry, safe to blank.
        # A piece with no geometry is image-defined (token/tile/figurine):
        # its dead ImageURL is fatal — see IMAGE_DEFINING_FIELD.
        has_geometry = any(field in FATAL_FIELDS for _container, field, _url in own)
        fatal = any(
            field in FATAL_FIELDS or (field == IMAGE_DEFINING_FIELD and not has_geometry)
            for _container, field in dead_here
        )
        if fatal:
            guid = piece.get("GUID")
            if isinstance(guid, str):
                remove_guids.add(guid)
            # object is going away wholesale — no point blanking its fields
            continue
        blank_ops.extend(dead_here)
    return remove_guids, blank_ops


def _remove_guids_recursive(obj: dict[str, Any], guids: set[str]) -> int:
    """Drop contained objects whose GUID is in ``guids``, at any depth."""
    removed = 0
    contained = obj.get("ContainedObjects")
    if isinstance(contained, list):
        kept = [c for c in contained if not (isinstance(c, dict) and c.get("GUID") in guids)]
        removed += len(contained) - len(kept)
        obj["ContainedObjects"] = kept
        for c in kept:
            if isinstance(c, dict):
                removed += _remove_guids_recursive(c, guids)
    return removed


def find_sbx_by_owx(abag: dict[str, Any], owx_guid: str) -> dict[str, Any] | None:
    """The SBx token in aBag whose Description links to this OWx bag."""
    for o in abag.get("ContainedObjects") or []:
        if isinstance(o, dict) and o.get("Description") == owx_guid:
            return o
    return None


def prune_dead_assets(
    save: dict[str, Any],
    owx_guid: str,
    dead_urls: set[str],
    *,
    abag_guid: str = ABAG_GUID,
) -> dict[str, Any]:
    """Remove dead-mesh pieces and blank dead textures in one OWx map."""
    states = save.get("ObjectStates") or []
    bag = find_object(states, owx_guid)
    if bag is None:
        raise CleanError(f"OWx bag {owx_guid!r} not found in save")
    if not dead_urls:
        return {"status": "noop", "reason": "no dead URLs given"}

    remove_guids, blank_ops = plan_prune(bag, dead_urls)

    # Blank first (operate on live dict refs), then remove whole pieces.
    for container, field in blank_ops:
        container[field] = ""
    removed = _remove_guids_recursive(bag, remove_guids)

    # Strip removed pieces from the SBx position manifest so a future
    # Build doesn't try to spawn GUIDs that no longer exist.
    manifest_stripped = 0
    abag = find_object(states, abag_guid)
    if abag is not None and remove_guids:
        sbx = find_sbx_by_owx(abag, owx_guid)
        if sbx is not None and isinstance(sbx.get("LuaScript"), str):
            new_lua, manifest_stripped = delete_jotbase_lines(
                sbx["LuaScript"], frozenset(remove_guids)
            )
            sbx["LuaScript"] = new_lua

    return {
        "status": "pruned",
        "owx_guid": owx_guid,
        "dead_urls": len(dead_urls),
        "objects_removed": removed,
        "fields_blanked": len(blank_ops),
        "manifest_lines_stripped": manifest_stripped,
    }


def prune_map(
    save: dict[str, Any],
    owx_guid: str,
    *,
    abag_guid: str = ABAG_GUID,
    probe: Callable[[list[str]], set[str]] = probe_urls,
) -> dict[str, Any]:
    """Collect the map's URLs, probe for dead ones, then prune."""
    states = save.get("ObjectStates") or []
    bag = find_object(states, owx_guid)
    if bag is None:
        raise CleanError(f"OWx bag {owx_guid!r} not found in save")
    urls = collect_map_urls(bag)
    dead = probe(list(urls))
    result = prune_dead_assets(save, owx_guid, dead, abag_guid=abag_guid)
    result["urls_probed"] = len(urls)
    return result


# --------------------------------------------------------------------------
# Whole-map removal (pure, no network)
# --------------------------------------------------------------------------
def remove_ow_map(
    save: dict[str, Any],
    *,
    sbx_guid: str | None = None,
    owx_guid: str | None = None,
    abag_guid: str = ABAG_GUID,
    mbag_guid: str = MBAG_GUID,
) -> dict[str, Any]:
    """Un-register a map: delete its OWx bag, SBx token, and JotBase line.

    Identify the map by either its SBx token GUID or its OWx bag GUID
    (one is required). Idempotent: a second run reports ``noop``.
    """
    if not sbx_guid and not owx_guid:
        raise CleanError("pass sbx_guid or owx_guid")
    states = save.get("ObjectStates") or []
    abag = find_object(states, abag_guid)
    if abag is None:
        raise CleanError(f"aBag {abag_guid!r} not found")
    mbag = find_object(states, mbag_guid)
    if mbag is None:
        raise CleanError(f"mBag {mbag_guid!r} not found")

    # Resolve the SBx token and its linked OWx bag GUID.
    if sbx_guid:
        sbx = next(
            (o for o in abag.get("ContainedObjects") or [] if o.get("GUID") == sbx_guid),
            None,
        )
        if sbx is not None and owx_guid is None:
            owx_guid = sbx.get("Description")
    else:
        sbx = find_sbx_by_owx(abag, owx_guid or "")
        if sbx is not None:
            sbx_guid = sbx.get("GUID")

    name = ""
    if sbx is not None and isinstance(sbx.get("Nickname"), str):
        name = sbx["Nickname"].removeprefix("SBx_")

    n_owx = delete_contained(mbag, frozenset({owx_guid})) if owx_guid else 0
    n_sbx = delete_contained(abag, frozenset({sbx_guid})) if sbx_guid else 0
    n_jot = 0
    if sbx_guid and isinstance(abag.get("LuaScript"), str):
        abag["LuaScript"], n_jot = delete_jotbase_lines(abag["LuaScript"], frozenset({sbx_guid}))

    if not (n_owx or n_sbx or n_jot):
        return {"status": "noop", "reason": "map not present"}
    return {
        "status": "removed",
        "map_name": name,
        "sbx_guid": sbx_guid,
        "owx_guid": owx_guid,
        "owx_bags_removed": n_owx,
        "sbx_tokens_removed": n_sbx,
        "jotbase_lines_removed": n_jot,
    }


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------
def _load(p: Path) -> dict[str, Any]:
    data: dict[str, Any] = json.loads(p.read_text())
    return data


def _write(save: dict[str, Any], out: Path, target: Path) -> int:
    if out.resolve() == target.resolve():
        print("error: refusing to overwrite the input save in place", file=sys.stderr)
        return 1
    out.write_text(json.dumps(save))
    print(f"Wrote {out}")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="cmd", required=True)

    r = sub.add_parser("remove", help="Un-register a whole map")
    r.add_argument("save", type=Path)
    r.add_argument("output", type=Path)
    r.add_argument("--sbx-guid")
    r.add_argument("--owx-guid")

    p = sub.add_parser("prune", help="Silence dead-asset load errors in a map")
    p.add_argument("save", type=Path)
    p.add_argument("output", type=Path)
    p.add_argument("--owx-guid", required=True)
    p.add_argument(
        "--dead-url",
        action="append",
        default=[],
        help="Known dead URL (repeatable). If omitted, every asset URL in "
        "the map is GET-probed and dead ones are auto-detected.",
    )

    args = parser.parse_args(argv)
    if not args.save.exists():
        print(f"error: {args.save} does not exist", file=sys.stderr)
        return 1
    save = _load(args.save)

    try:
        if args.cmd == "remove":
            result = remove_ow_map(save, sbx_guid=args.sbx_guid, owx_guid=args.owx_guid)
        else:
            if args.dead_url:
                result = prune_dead_assets(save, args.owx_guid, set(args.dead_url))
            else:
                result = prune_map(save, args.owx_guid)
    except CleanError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    for k, v in result.items():
        print(f"  {k}: {v}")
    if result.get("status") in ("noop",):
        # still write, so an output file always exists for chaining
        pass
    return _write(save, args.output, args.save)


if __name__ == "__main__":
    raise SystemExit(main())
