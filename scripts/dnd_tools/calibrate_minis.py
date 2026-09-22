"""Calibrate every injected mini on the table to the save's grid.

The DND Mini Injector's mini script can resize a mini whenever the grid size
changes, but only after the mini has been calibrated: its "Calibrate Scale"
menu item stores the mini's scale divided by ``Grid.sizeX`` and marks it
calibrated. From then on the mini keeps that size relative to a grid square.

This does the same thing for every mini on the table at once, by writing those
values into each mini's ``LuaScriptState`` in the save file. Load the save
fresh in TTS afterwards (fully quit and relaunch) for it to take effect.

Only objects on the table are touched, not minis inside bags. A mini already
calibrated is left alone unless ``--recalibrate`` is given, which re-records
its current size. The injector object carries a copy of the mini script and is
skipped.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

MINI_CLASS = 'className = "DNDMiniInjector_Mini"'
INJECTOR_CLASS = 'className = "MiniInjector"'


def is_mini(obj: dict[str, Any]) -> bool:
    script = obj.get("LuaScript") or ""
    return MINI_CLASS in script and INJECTOR_CLASS not in script


def calibrate_minis(save: dict[str, Any], *, recalibrate: bool = False) -> dict[str, Any]:
    """Mark each mini on the table calibrated to the save's grid width.

    Returns the grid size used and the names of the minis changed and skipped.
    """
    grid = float(save["Grid"]["xSize"])
    changed: list[str] = []
    skipped: list[str] = []
    for obj in save.get("ObjectStates", []):
        if not is_mini(obj):
            continue
        name = f"{obj.get('GUID')} {obj.get('Nickname') or obj.get('Name')}"
        raw = obj.get("LuaScriptState") or ""
        state = json.loads(raw) if raw else {}
        if state.get("calibrated_once") and not recalibrate:
            skipped.append(name)
            continue
        transform = obj["Transform"]
        state["scale_multiplier_x"] = transform["scaleX"] / grid
        state["scale_multiplier_y"] = transform["scaleY"] / grid
        state["scale_multiplier_z"] = transform["scaleZ"] / grid
        state["calibrated_once"] = True
        obj["LuaScriptState"] = json.dumps(state)
        changed.append(name)
    return {"grid": grid, "changed": changed, "skipped": skipped}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Save holding the minis")
    parser.add_argument("output", type=Path, help="Where to write the calibrated save")
    parser.add_argument(
        "--recalibrate",
        action="store_true",
        help="Also re-record minis that are already calibrated",
    )
    args = parser.parse_args(argv)

    if not args.source.exists():
        print(f"error: {args.source} does not exist", file=sys.stderr)
        return 1
    if args.output.resolve() == args.source.resolve():
        print("error: refusing to overwrite the input save in place", file=sys.stderr)
        return 1

    save = json.loads(args.source.read_text())
    result = calibrate_minis(save, recalibrate=args.recalibrate)
    args.output.write_text(json.dumps(save))
    print(f"Grid size: {result['grid']}")
    for name in result["changed"]:
        print(f"  calibrated       {name}")
    for name in result["skipped"]:
        print(f"  already, skipped {name}")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
