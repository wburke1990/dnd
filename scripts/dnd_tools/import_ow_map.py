"""Import a OneWorld map from a donor save into a target save.

A "OneWorld map" is the combination of:

* an ``OWx_<Name>`` Bag holding the packed map content,
* an ``SBx_<Name>`` Custom_Token sitting inside the target's ``aBag``
  (the clickable icon in the Hub map list), whose ``Description`` field
  links to the OWx bag's GUID,
* a comment line in ``aBag.LuaScript`` (the JotBase registry) telling
  the Hub the map exists.

The Hub has no auto-discovery path: dropping a foreign OWx bag in by
itself does nothing. This script wires up all three pieces atomically.

The donor save's ``_OW_wBase`` Custom_Token carries the "floor image"
that gets painted under the map at load time. By default the new SBx
inherits that same image URL, so the imported map looks the way it did
in the donor world.

GUID-collision safety
---------------------

TTS requires GUIDs to be globally unique across the entire ObjectStates
tree (top-level plus every recursive ``ContainedObjects``). The script
walks the donor's OWx subtree and the target save, finds intersecting
GUIDs, and remaps each colliding GUID inside the OWx subtree to a fresh
one. The remap is applied to:

* the ``GUID`` field on each object,
* every ``Description`` field (handles both bare-GUID and
  ``<guid>,0,0,2,0`` JotBase-style descriptions),
* every ``LuaScript`` / ``LuaScriptState`` / ``XmlUI`` string,

with a word-boundary regex so 6-hex GUIDs embedded inside longer hex
strings don't get clobbered. The new SBx token's GUID is also minted
to be unique against the post-remap world.

Run via::

    uv --directory scripts run python -m dnd_tools.import_ow_map \\
        ~/Library/Tabletop\\ Simulator/Saves/TS_Save_23.json \\
        ~/Library/Tabletop\\ Simulator/Saves/TS_Save_19.json \\
        ~/Library/Tabletop\\ Simulator/Saves/TS_Save_19_with_dockside.json
"""

from __future__ import annotations

import argparse
import json
import re
import secrets
import sys
from copy import deepcopy
from pathlib import Path
from typing import Any

from dnd_tools.fix_oneworld import ABAG_GUID, find_object

# Nila staging's `mBag` — the master content-bag container the Hub's
# ButtonBuild calls `mBag.takeObject({guid = SBx.Description})` against.
# OWx content bags MUST live inside mBag.ContainedObjects or Build
# fails with `<ButtonBuild>: Value cannot be null`. Nickname is "Tra";
# the canonical marker is `Description == "_OW_mBaG"`.
MBAG_GUID = "c30535"

# JotBase line format from the live registry in
# tts/lua/TS_Save_19/966e1c.lua. The trailing comma with no linked
# entries is correct for an unlinked map.
JOTBASE_TEMPLATE = "--{guid},{name},{{1.85;1;1.85}},{{25.00;1;25.00}},0,0,2,0,"

# Match a 6-hex-char GUID with word boundaries on each side. Used to
# rewrite GUID references inside Lua/XML/Description strings without
# touching identifiers that happen to contain the substring.
_GUID_RE_TEMPLATE = r"\b{}\b"

# Default face state appended to each SBx manifest line. The Hub's build
# path reads `1` as face-up; flipped tokens would be `0`. We don't have
# packed face state per-object (the bag's Transform is the only source
# of pose info, and rotZ encodes flip for some object types but not
# reliably), so default everyone to face-up. A user can correct the
# handful of objects that need it after Build.
DEFAULT_FACE_STATE = "1"


class ImportError_(RuntimeError):
    """Raised when the import preconditions are not met."""


def _walk_subtree(obj: dict[str, Any]) -> list[dict[str, Any]]:
    """Return a flat list of obj plus every recursively contained object."""
    out = [obj]
    for child in obj.get("ContainedObjects") or []:
        if isinstance(child, dict):
            out.extend(_walk_subtree(child))
    return out


def collect_subtree_guids(obj: dict[str, Any]) -> set[str]:
    """Every GUID under (and including) `obj`."""
    return {o["GUID"] for o in _walk_subtree(obj) if isinstance(o.get("GUID"), str)}


def collect_save_guids(save: dict[str, Any]) -> set[str]:
    """Every GUID in a save's ObjectStates tree."""
    guids: set[str] = set()
    for top in save.get("ObjectStates") or []:
        if isinstance(top, dict):
            guids |= collect_subtree_guids(top)
    return guids


def mint_guid(used: set[str]) -> str:
    """Return a 6-hex-char GUID not in `used`, and add it to `used`."""
    while True:
        candidate = secrets.token_hex(3)
        if candidate not in used:
            used.add(candidate)
            return candidate


def remap_guids_in_subtree(obj: dict[str, Any], mapping: dict[str, str]) -> None:
    """In-place GUID rewrite throughout an object subtree.

    Rewrites:
    * The ``GUID`` field on every object.
    * Every ``Description`` / ``LuaScript`` / ``LuaScriptState`` / ``XmlUI``
      string, using a word-boundary regex so adjacent identifiers aren't
      touched.

    The Description field handles both the bare-GUID case
    (``"abc123"``) and the JotBase-fragment case (``"abc123,0,0,2,0"``)
    because both have a non-word character (end-of-string or comma)
    after the GUID, satisfying ``\\b``.
    """
    if not mapping:
        return
    # Pre-compile one regex that matches any of the old GUIDs.
    pattern = re.compile(_GUID_RE_TEMPLATE.format("|".join(re.escape(g) for g in mapping)))

    def sub(s: str) -> str:
        return pattern.sub(lambda m: mapping[m.group(0)], s)

    for o in _walk_subtree(obj):
        guid = o.get("GUID")
        if isinstance(guid, str) and guid in mapping:
            o["GUID"] = mapping[guid]
        for field in ("Description", "LuaScript", "LuaScriptState", "XmlUI"):
            v = o.get(field)
            if isinstance(v, str) and v:
                o[field] = sub(v)


def build_sbx_token(
    sbx_guid: str,
    map_name: str,
    image_url: str,
    owx_guid: str,
) -> dict[str, Any]:
    """A Custom_Token shaped like the live SBx tokens in aBag.

    ``Description`` carries the linked OWx bag's GUID — that's what
    ``cbGetBase`` reads to find the content bag when the icon is clicked.
    """
    return {
        "Name": "Custom_Token",
        "Nickname": f"SBx_{map_name}",
        "Description": owx_guid,
        "GUID": sbx_guid,
        "Transform": {
            "posX": 0.0,
            "posY": 5.0,
            "posZ": 0.0,
            "rotX": 0.0,
            "rotY": 0.0,
            "rotZ": 0.0,
            "scaleX": 0.5,
            "scaleY": 1.0,
            "scaleZ": 0.5,
        },
        "ColorDiffuse": {"r": 1.0, "g": 1.0, "b": 1.0},
        "Locked": True,
        "Grid": True,
        "Snap": True,
        "Autoraise": True,
        "Sticky": True,
        "Tooltip": True,
        "GMNotes": "",
        "Tags": ["imported-ow-map"],
        "LuaScript": "",
        "LuaScriptState": "",
        "XmlUI": "",
        "CustomImage": {
            "ImageURL": image_url,
            "ImageSecondaryURL": "",
            "ImageScalar": 1.0,
            "WidthScale": 0.0,
            "CustomToken": {
                "Thickness": 0.1,
                "MergeDistancePixels": 15.0,
                "StandUp": False,
                "Stackable": False,
            },
        },
    }


def jotbase_line(sbx_guid: str, map_name: str) -> str:
    return JOTBASE_TEMPLATE.format(guid=sbx_guid, name=map_name)


def _fmt_float(v: float) -> str:
    """Format a float WITHOUT scientific notation.

    `repr()` round-trips precision but produces "1.25e-06" for very small
    values — the live SBx scripts and the Hub's parser both use plain
    decimal everywhere, so we force fixed-point and trim trailing zeros.
    Width 20 keeps round-trip precision (~17 significant digits is the
    double-precision ceiling).
    """
    r = repr(v)
    if "e" not in r and "E" not in r:
        return r
    s = f"{v:.20f}".rstrip("0")
    if s.endswith("."):
        s += "0"  # always keep one digit past the decimal point
    return s


def build_sbx_manifest(bag: dict[str, Any]) -> str:
    """Generate the SBx LuaScript: one --<guid>,pos,rot,face line per child.

    Format matches what the Hub's build path expects (verified against
    live SBx_Wizards_Tower):

        --<guid>,posX,posY,posZ,rotX,rotY,rotZ,<face_state>\\n

    Scale is intentionally NOT included — the canonical scale lives on
    the bag's `ContainedObjects[i].Transform.scaleX/Y/Z` and is restored
    from there when the Hub spawns the object. Face state defaults to
    "1" (face-up) since the bag's Transform doesn't expose pack-time
    face state separately.

    The manifest is built AFTER GUID remapping has been applied to the
    bag, so any remapped child GUID appears here with its new value —
    keeping the manifest internally consistent.
    """
    lines: list[str] = []
    for child in bag.get("ContainedObjects") or []:
        if not isinstance(child, dict):
            continue
        guid = child.get("GUID")
        t = child.get("Transform") or {}
        if not isinstance(guid, str) or not isinstance(t, dict):
            continue
        fields = [
            guid,
            _fmt_float(float(t.get("posX", 0.0))),
            _fmt_float(float(t.get("posY", 0.0))),
            _fmt_float(float(t.get("posZ", 0.0))),
            _fmt_float(float(t.get("rotX", 0.0))),
            _fmt_float(float(t.get("rotY", 0.0))),
            _fmt_float(float(t.get("rotZ", 0.0))),
            DEFAULT_FACE_STATE,
        ]
        lines.append("--" + ",".join(fields))
    return "\n".join(lines) + ("\n" if lines else "")


def find_owx_bag(save: dict[str, Any], owx_guid: str | None) -> dict[str, Any]:
    """Find the OWx_* bag to import — explicit GUID wins; else require exactly one."""
    states = save.get("ObjectStates") or []
    if owx_guid:
        match = find_object(states, owx_guid)
        if match is None:
            raise ImportError_(f"OWx bag {owx_guid!r} not found in donor save")
        return match
    candidates = [
        o
        for o in states
        if isinstance(o, dict)
        and o.get("Name") == "Bag"
        and isinstance(o.get("Nickname"), str)
        and o["Nickname"].startswith("OWx_")
    ]
    if not candidates:
        raise ImportError_("no OWx_* bag found at top level of donor save")
    if len(candidates) > 1:
        names = ", ".join(c["Nickname"] for c in candidates)
        raise ImportError_(f"multiple OWx_* bags in donor save ({names}); pass --owx-guid")
    return candidates[0]


def find_wbase_image(save: dict[str, Any]) -> str | None:
    """Pull the CustomImage URL from the donor's _OW_wBase, if present."""
    for o in save.get("ObjectStates") or []:
        if isinstance(o, dict) and o.get("Nickname") == "_OW_wBase":
            ci = o.get("CustomImage") or {}
            url = ci.get("ImageURL")
            if isinstance(url, str) and url:
                return url
    return None


def map_already_imported(
    target: dict[str, Any], map_name: str, abag_guid: str, mbag_guid: str
) -> bool:
    """True if target already has an OWx_<name> bag in mBag AND a JotBase line."""
    mbag = find_object(target.get("ObjectStates") or [], mbag_guid)
    if mbag is None:
        return False
    has_bag = any(
        isinstance(o, dict) and o.get("Name") == "Bag" and o.get("Nickname") == f"OWx_{map_name}"
        for o in mbag.get("ContainedObjects") or []
    )
    if not has_bag:
        return False
    abag = find_object(target.get("ObjectStates") or [], abag_guid)
    if abag is None:
        return False
    lua = abag.get("LuaScript") or ""
    return f",{map_name}," in lua


def import_ow_map(
    source: dict[str, Any],
    target: dict[str, Any],
    *,
    owx_guid: str | None = None,
    map_name: str | None = None,
    sbx_image_url: str | None = None,
    abag_guid: str = ABAG_GUID,
    mbag_guid: str = MBAG_GUID,
) -> dict[str, Any]:
    """Mutate `target` in place to register a new OW map from `source`.

    Returns a summary dict (counts, chosen GUIDs).
    """
    owx_bag = find_owx_bag(source, owx_guid)
    nickname = owx_bag.get("Nickname") or ""
    if not isinstance(nickname, str) or not nickname.startswith("OWx_"):
        raise ImportError_(f"donor bag has unexpected nickname: {nickname!r}")
    inferred_name = nickname[len("OWx_") :]
    final_name = map_name or inferred_name
    if not final_name:
        raise ImportError_("could not determine map name")

    if sbx_image_url is None:
        sbx_image_url = find_wbase_image(source)
    if not sbx_image_url:
        raise ImportError_(
            "no SBx image URL given and donor save has no _OW_wBase with a "
            "CustomImage.ImageURL; pass --sbx-image-url"
        )

    if map_already_imported(target, final_name, abag_guid, mbag_guid):
        return {
            "status": "noop",
            "reason": f"map {final_name!r} already present in target",
        }

    abag = find_object(target.get("ObjectStates") or [], abag_guid)
    if abag is None:
        raise ImportError_(f"target aBag {abag_guid!r} not found")
    if not isinstance(abag.get("LuaScript"), str):
        raise ImportError_("target aBag.LuaScript missing or not a string")

    mbag = find_object(target.get("ObjectStates") or [], mbag_guid)
    if mbag is None:
        raise ImportError_(
            f"target mBag {mbag_guid!r} not found — the Hub's ButtonBuild "
            "needs the OWx bag to live inside mBag.ContainedObjects"
        )

    # Deep-copy the donor subtree so source isn't mutated by remapping.
    bag_copy = deepcopy(owx_bag)

    subtree_guids = collect_subtree_guids(bag_copy)
    target_guids = collect_save_guids(target)
    collisions = subtree_guids & target_guids
    used = subtree_guids | target_guids
    mapping: dict[str, str] = {}
    for g in sorted(collisions):
        new = mint_guid(used)
        mapping[g] = new
    if mapping:
        remap_guids_in_subtree(bag_copy, mapping)

    # `used` now contains the post-remap subtree + target. Mint the SBx
    # GUID against that combined set so nothing collides.
    sbx_guid = mint_guid(used)
    # Working OW content bags (e.g. Wizards_Tower's `1cfa04`) carry an
    # empty Description — the Hub doesn't read OWx Description for map
    # linkage. The original donor Description here was a JotBase-style
    # fragment from some other tool; clearing it matches convention and
    # avoids the Hub treating it as a stale GUID pointer.
    bag_copy["Description"] = ""

    sbx = build_sbx_token(sbx_guid, final_name, sbx_image_url, bag_copy["GUID"])
    # The Hub's Build button is gated by `aBase.getLuaScript() != ""` —
    # without this manifest the SBx is registered but the map can't be
    # spawned. Build AFTER remap so any rewritten child GUIDs are used.
    sbx["LuaScript"] = build_sbx_manifest(bag_copy)

    # Inject OWx bag into mBag.ContainedObjects — the Hub's ButtonBuild
    # calls `mBag.takeObject({guid = SBx.Description})` to spawn it.
    # Top-level placement would crash with "Value cannot be null".
    mbag.setdefault("ContainedObjects", []).append(bag_copy)

    # Add SBx to aBag.ContainedObjects.
    abag.setdefault("ContainedObjects", []).append(sbx)

    # Append JotBase line in aBag's CRLF/LF convention.
    lua = abag["LuaScript"]
    new_line = jotbase_line(sbx_guid, final_name)
    uses_crlf = "\r\n" in lua
    sep = "\r\n" if uses_crlf else "\n"
    if lua and not lua.endswith(sep):
        lua = lua + sep
    abag["LuaScript"] = lua + new_line + sep

    return {
        "status": "imported",
        "map_name": final_name,
        "owx_guid": bag_copy["GUID"],
        "sbx_guid": sbx_guid,
        "sbx_image_url": sbx_image_url,
        "collisions_remapped": len(mapping),
        "remapped_guids": mapping,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Donor save (e.g. docks)")
    parser.add_argument("target", type=Path, help="Target save (e.g. nila)")
    parser.add_argument("output", type=Path, help="Where to write the merged save")
    parser.add_argument(
        "--owx-guid",
        help="GUID of the OWx_* bag in the donor save (auto-detected if omitted)",
    )
    parser.add_argument(
        "--map-name",
        help="Override map name (default: strip 'OWx_' prefix from bag nickname)",
    )
    parser.add_argument(
        "--sbx-image-url",
        help="Image URL for the new SBx token (default: donor _OW_wBase.CustomImage)",
    )
    parser.add_argument(
        "--abag-guid",
        default=ABAG_GUID,
        help=f"Target save's aBag GUID (default {ABAG_GUID})",
    )
    parser.add_argument(
        "--mbag-guid",
        default=MBAG_GUID,
        help=f"Target save's mBag GUID (default {MBAG_GUID})",
    )
    args = parser.parse_args(argv)

    for p in (args.source, args.target):
        if not p.exists():
            print(f"error: {p} does not exist", file=sys.stderr)
            return 1
    if args.output.exists() and args.output.resolve() == args.target.resolve():
        print("error: refusing to overwrite the target save in place", file=sys.stderr)
        return 1

    source = json.loads(args.source.read_text())
    target = json.loads(args.target.read_text())

    try:
        result = import_ow_map(
            source,
            target,
            owx_guid=args.owx_guid,
            map_name=args.map_name,
            sbx_image_url=args.sbx_image_url,
            abag_guid=args.abag_guid,
            mbag_guid=args.mbag_guid,
        )
    except ImportError_ as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    args.output.write_text(json.dumps(target))

    if result["status"] == "noop":
        print(f"noop: {result['reason']}")
    else:
        print(f"Imported map: {result['map_name']}")
        print(f"  OWx bag GUID: {result['owx_guid']}")
        print(f"  New SBx GUID: {result['sbx_guid']}")
        print(f"  SBx image:    {result['sbx_image_url']}")
        print(f"  Collisions:   {result['collisions_remapped']} GUID(s) remapped")
        if result["remapped_guids"]:
            for old, new in result["remapped_guids"].items():
                print(f"    {old} -> {new}")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
