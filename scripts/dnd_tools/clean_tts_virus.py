"""Strip the TTS "Spawning object" Lua virus from save and object JSON files.

The virus appends itself to the end of an object's Lua script: 400 spaces, then
``--[[Object base code]]`` through ``--[[Spawning object]]`` and a couple of
newlines. Once loaded it copies itself into every object that spawns and asks a
web address for more code to run. It arrived here in the Workshop minis pack
3618998883 and spread through the saves and Saved Objects (found 9/23/2026).

The payload is cut from the raw file text, so every other byte stays as it was.
Before writing, the result is checked: the cleaned file, parsed, must equal the
original parsed with the payload removed from each string, and no trace of the
virus may remain. A file that fails the check is reported and left alone.

Without ``--write`` it only reports. Back the files up first, and clean every
infected file in the same pass with TTS closed, or an infected object spawned
later puts it back.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

RAW = re.compile(rb" *--\[\[Object base code\]\].*?--\[\[Spawning object\]\](?:\\r|\\n)*")
DECODED = re.compile(r" *--\[\[Object base code\]\].*?--\[\[Spawning object\]\][\r\n]*")
TRACES = (b"gninwapS", b"glitch.me", b"Object base code", b"Spawning object")


def strip_decoded(value: Any) -> Any:
    """Remove the payload from every string inside a parsed JSON value."""
    if isinstance(value, str):
        return DECODED.sub("", value)
    if isinstance(value, list):
        return [strip_decoded(v) for v in value]
    if isinstance(value, dict):
        return {k: strip_decoded(v) for k, v in value.items()}
    return value


def clean_bytes(raw: bytes) -> tuple[bytes, int, list[str], bool]:
    """Return the cleaned text, payloads removed, traces left, and whether it checks out."""
    cleaned, removed = RAW.subn(b"", raw)
    left = [t.decode() for t in TRACES if t in cleaned]
    same = bool(json.loads(cleaned) == strip_decoded(json.loads(raw)))
    return cleaned, removed, left, same


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="+", type=Path, help="Save or object JSON files")
    parser.add_argument("--write", action="store_true", help="Write cleaned files in place")
    args = parser.parse_args(argv)

    failed = False
    for path in args.paths:
        raw = path.read_bytes()
        cleaned, removed, left, same = clean_bytes(raw)
        ok = same and not left
        failed = failed or not ok
        note = ""
        if left:
            note += f"  traces left: {left}"
        if not same:
            note += "  content mismatch"
        print(f"{'ok  ' if ok else 'FAIL'} {removed:5d} removed  {path}{note}")
        if args.write and ok and removed:
            path.write_bytes(cleaned)
    return 1 if failed else 0


if __name__ == "__main__":  # pragma: no cover
    sys.exit(main())
