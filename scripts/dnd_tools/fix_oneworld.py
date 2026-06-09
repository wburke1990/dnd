"""One-shot fix for the OneWorld Hub in the Nila_WT_staging save.

Does two things to a save file:

1. Patches the Hub's `ButtonHome` so the "Next" button advances from the
   Show-All view. The shipped code shares a guard between two failure
   modes (only-one-map AND no-current-map), then bails. ButtonBack
   handles the no-current-map case via a separate branch — this patch
   adds the missing parallel branch to ButtonHome.

2. Injects stub SBx Custom_Tokens into aBag.ContainedObjects so the 9
   orphan JotBase entries (records whose SBx tokens were deleted) can be
   loaded again without a nil deref in cbGetBase. cbGetBase reads only
   `getGUID()`, `getName():sub(5)`, and `getCustomObject().image` from
   the SBx, so a minimal token with GUID + Nickname + CustomImage.ImageURL
   is enough to keep things from crashing.

   5 of 9 orphan images were recovered from a sibling autosave; 4 use a
   generic placeholder URL.

Run via:

    uv --directory scripts run python -m dnd_tools.fix_oneworld \
        ~/Library/Tabletop\\ Simulator/Saves/TS_Save_19.json \
        ~/Library/Tabletop\\ Simulator/Saves/TS_Save_19_fixed.json

The new save is loadable as a fresh entry in TTS; the original is left
untouched so you can compare side-by-side.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

HUB_GUID = "55c90c"
ABAG_GUID = "966e1c"

# Generic Steam URL the existing Base/Name-of-Map entries already point at;
# repurposed here as the "image missing" placeholder for unrecoverable maps.
PLACEHOLDER_URL = (
    "https://steamusercontent-a.akamaihd.net/ugc/1841411912945018031/"
    "973A9796374893C1BA557B320203F3B88727C93C/"
)

# Orphan SBx tokens to stub back in with their recovered Steam URLs. Only
# entries whose recovered art is actually useful — the recovered images for
# Base, Name of Map, 1Main, Garden Temple, Test map, and Castle turned out
# to be text-only placeholders, so those get deleted (see ORPHAN_DELETE_GUIDS)
# rather than stubbed.
ORPHAN_STUBS_KEEP: list[dict[str, str]] = [
    {
        "guid": "01d3f9",
        "map": "Tomb_1",
        "image": (
            "https://steamusercontent-a.akamaihd.net/ugc/13421535259753450544/"
            "BC1D993A8B32ECE0128CD957F283D787D0805FFD/"
        ),
    },
    {
        "guid": "ec9fd3",
        "map": "Tomb_2",
        "image": (
            "https://steamusercontent-a.akamaihd.net/ugc/10655823602926839126/"
            "8071088F9C3F8A0E085BE9C7475F3DFBEF605E19/"
        ),
    },
    {
        "guid": "e6834b",
        "map": "Tomb_3",
        "image": (
            "https://steamusercontent-a.akamaihd.net/ugc/15293889201153755729/"
            "BECF6E329C2A81C8076C542EB8D56B056F401E07/"
        ),
    },
]

# JotBase entries to delete entirely: their recovered art (or stubbed
# placeholder) had no usable content. Matched by SBx GUID against both
# `aBag.LuaScript` JotBase lines and `aBag.ContainedObjects` so any
# previously-injected stubs get cleaned up too. The `Base` GUID appears
# twice in JotBase (a Hub bug); both lines come out.
ORPHAN_DELETE_GUIDS: frozenset[str] = frozenset(
    {
        "d8b5f5",  # Base (x2)
        "206dd9",  # Name of Map
        "a8acde",  # 1Main
        "8fbcf1",  # Garden Temple
        "dd03a9",  # Test map
        "ffb7da",  # Castle
    }
)

# Matches a JotBase line: `--<6-hex-guid>,...`. Tolerates leading whitespace
# from indented Lua but the Hub writes them at column 0.
_JOTBASE_LINE_RE = re.compile(r"^\s*--([0-9a-f]{6}),")

BUTTON_HOME_OLD = """    if treeMap[0] < 2 or not aBase then
        if treeMap[1] then
            GetBase(treeMap[1])
        end
        return
    end
    treeMap[-1] = treeMap[-1] + 1
    mvPoint()"""

BUTTON_HOME_NEW = """    if treeMap[0] < 2 then
        if treeMap[1] then
            GetBase(treeMap[1])
        end
        return
    end
    if not aBase then
        -- Show-All cleared aBase; advance to the second registered map
        -- (treeMap[1] is "home", treeMap[2] is the first real entry).
        if treeMap[2] then GetBase(treeMap[2]) end
        return
    end
    treeMap[-1] = treeMap[-1] + 1
    mvPoint()"""


def stub_sbx(guid: str, map_name: str, image_url: str) -> dict[str, Any]:
    """Build a minimal Custom_Token sufficient for cbGetBase to not nil-crash."""
    return {
        "Name": "Custom_Token",
        "Nickname": f"SBx_{map_name}",
        "Description": "",
        "GUID": guid,
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
        "Tags": ["orphan-stub"],
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


def find_object(states: list[dict[str, Any]], guid: str) -> dict[str, Any] | None:
    """Depth-first search of ObjectStates for the first match by GUID."""
    for obj in states:
        if obj.get("GUID") == guid:
            return obj
        contained = obj.get("ContainedObjects") or []
        match = find_object(contained, guid)
        if match is not None:
            return match
    return None


def patch_button_home(lua: str) -> tuple[str, bool]:
    """Return (new_lua, did_change). Idempotent: noop if already patched.

    Normalizes line endings to ``\n`` for matching, then re-applies the
    source file's original convention (CRLF for live TTS saves) on output.
    """
    uses_crlf = "\r\n" in lua
    normalized = lua.replace("\r\n", "\n")
    if BUTTON_HOME_NEW in normalized:
        return lua, False
    if BUTTON_HOME_OLD not in normalized:
        raise RuntimeError(
            "ButtonHome source block not found verbatim — Hub Lua may have been "
            "edited or the patch needs updating."
        )
    patched = normalized.replace(BUTTON_HOME_OLD, BUTTON_HOME_NEW, 1)
    if uses_crlf:
        patched = patched.replace("\n", "\r\n")
    return patched, True


def inject_stubs(
    abag: dict[str, Any],
    stubs: list[dict[str, str]],
) -> tuple[int, int]:
    """Add missing SBx stub tokens to abag.ContainedObjects.

    Returns (added, skipped). Skipped means a token with that GUID is
    already present (idempotent re-run).
    """
    contained = abag.setdefault("ContainedObjects", [])
    existing_guids = {o.get("GUID") for o in contained if isinstance(o, dict)}
    added = 0
    skipped = 0
    for s in stubs:
        if s["guid"] in existing_guids:
            skipped += 1
            continue
        contained.append(stub_sbx(s["guid"], s["map"], s["image"]))
        added += 1
    return added, skipped


def delete_jotbase_lines(lua: str, guids: frozenset[str]) -> tuple[str, int]:
    """Strip JotBase comment lines whose SBx GUID is in the delete set.

    Preserves the source file's CRLF/LF line-ending convention.
    """
    if not guids:
        return lua, 0
    uses_crlf = "\r\n" in lua
    lines = lua.replace("\r\n", "\n").split("\n")
    kept: list[str] = []
    removed = 0
    for line in lines:
        m = _JOTBASE_LINE_RE.match(line)
        if m and m.group(1) in guids:
            removed += 1
            continue
        kept.append(line)
    out = "\n".join(kept)
    if uses_crlf:
        out = out.replace("\n", "\r\n")
    return out, removed


def delete_contained(abag: dict[str, Any], guids: frozenset[str]) -> int:
    """Remove ContainedObjects whose GUID is in the delete set. Returns count."""
    contained = abag.get("ContainedObjects") or []
    before = len(contained)
    abag["ContainedObjects"] = [
        o for o in contained if not (isinstance(o, dict) and o.get("GUID") in guids)
    ]
    return before - len(abag["ContainedObjects"])


def patch_save(in_path: Path, out_path: Path) -> None:
    raw = in_path.read_text()
    save = json.loads(raw)
    states = save.get("ObjectStates") or []
    hub = find_object(states, HUB_GUID)
    if hub is None:
        raise RuntimeError(f"Hub object {HUB_GUID!r} not found in {in_path}")
    abag = find_object(states, ABAG_GUID)
    if abag is None:
        raise RuntimeError(f"aBag object {ABAG_GUID!r} not found in {in_path}")

    hub_lua = hub.get("LuaScript")
    if not isinstance(hub_lua, str):
        raise RuntimeError("Hub.LuaScript is missing or not a string")
    new_lua, lua_changed = patch_button_home(hub_lua)
    hub["LuaScript"] = new_lua

    abag_lua = abag.get("LuaScript")
    if not isinstance(abag_lua, str):
        raise RuntimeError("aBag.LuaScript is missing or not a string")
    new_abag_lua, jotbase_removed = delete_jotbase_lines(abag_lua, ORPHAN_DELETE_GUIDS)
    abag["LuaScript"] = new_abag_lua

    tokens_removed = delete_contained(abag, ORPHAN_DELETE_GUIDS)
    added, skipped = inject_stubs(abag, ORPHAN_STUBS_KEEP)

    # Bump SaveName so it shows up distinctly in the TTS save browser.
    current_name = save.get("SaveName", "")
    if current_name and "_fixed" not in current_name:
        save["SaveName"] = f"{current_name}_fixed"

    out_path.write_text(json.dumps(save))

    print(f"Hub ButtonHome: {'patched' if lua_changed else 'already patched (noop)'}")
    print(f"JotBase: {jotbase_removed} orphan line(s) removed")
    print(f"aBag stubs: {added} added, {skipped} skipped, {tokens_removed} deleted")
    print(f"Wrote {out_path}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("in_path", type=Path, help="Source save file")
    parser.add_argument("out_path", type=Path, help="Destination save file")
    args = parser.parse_args(argv)
    if not args.in_path.exists():
        print(f"error: {args.in_path} does not exist", file=sys.stderr)
        return 1
    if args.out_path.exists() and args.out_path.resolve() == args.in_path.resolve():
        print("error: refusing to overwrite the input save in place", file=sys.stderr)
        return 1
    patch_save(args.in_path, args.out_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
