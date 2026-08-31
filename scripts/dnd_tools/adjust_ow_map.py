"""Rotate or resize a OneWorld map that is already registered in a save.

``pack_ow_map`` scales a map on the way in, but a map imported from the One
World library arrives at whatever size and orientation its author left it, and
the mismatch only shows up after a Build. Removing and re-importing to fix that
throws away the prune and the floor image, so this adjusts the map in place.

**Both halves have to move together.** A registered map keeps its geometry in
two places: the ``Transform`` on each piece inside the ``OWx`` bag, and the
position manifest in the ``SBx`` token's ``LuaScript``, which is what the Hub
reads when it spawns the pieces. Editing the bag alone changes nothing on the
table. So each operation rewrites the pieces and then regenerates the manifest
from them.

**Rotation turns the map, not the floor.** The Hub's painted floor cannot be
rotated without editing and rehosting the image, which needs TTS itself; the
map can be turned under it with arithmetic. A floor that comes out 180° off is
therefore fixed by rotating the map 180°.

**Scaling is uniform**, on the same terms as ``pack_ow_map``: position and size
by one factor, so nothing changes size relative to anything else, and Y with
them so a piece that grows keeps its feet on the floor.
"""

from __future__ import annotations

import argparse
import json
import math
import sys
from pathlib import Path
from typing import Any

from dnd_tools.fix_oneworld import ABAG_GUID, find_object
from dnd_tools.import_ow_map import build_sbx_manifest


class AdjustError(RuntimeError):
    """Raised when the map or its SBx token cannot be found."""


def _num(transform: dict[str, Any], key: str, default: float) -> float:
    try:
        return float(transform.get(key, default) or default)
    except (TypeError, ValueError):
        return default


def rotate_pieces(pieces: list[dict[str, Any]], degrees: float) -> None:
    """Turn every piece around the origin by ``degrees`` on the horizontal plane.

    Positions rotate about the map's centre — which is the origin, since maps are
    centred there — and each piece's own ``rotY`` turns by the same amount, so a
    building ends up facing the way it faced relative to its neighbours.
    """
    radians = math.radians(degrees)
    cos_t = math.cos(radians)
    sin_t = math.sin(radians)
    for piece in pieces:
        transform = piece.get("Transform")
        if not isinstance(transform, dict):
            continue
        x = _num(transform, "posX", 0.0)
        z = _num(transform, "posZ", 0.0)
        transform["posX"] = x * cos_t + z * sin_t
        transform["posZ"] = -x * sin_t + z * cos_t
        transform["rotY"] = (_num(transform, "rotY", 0.0) + degrees) % 360.0


def scale_pieces(pieces: list[dict[str, Any]], factor: float) -> None:
    """Multiply every piece's position and size by ``factor``."""
    for piece in pieces:
        transform = piece.get("Transform")
        if not isinstance(transform, dict):
            continue
        for axis in ("X", "Y", "Z"):
            transform[f"pos{axis}"] = _num(transform, f"pos{axis}", 0.0) * factor
            transform[f"scale{axis}"] = _num(transform, f"scale{axis}", 1.0) * factor


def find_sbx_for(save: dict[str, Any], owx_guid: str, abag_guid: str = ABAG_GUID) -> dict[str, Any]:
    """The SBx token in aBag whose Description links to this OWx bag."""
    abag = find_object(save.get("ObjectStates") or [], abag_guid)
    if abag is None:
        raise AdjustError(f"aBag {abag_guid!r} not found in save")
    for child in abag.get("ContainedObjects") or []:
        if isinstance(child, dict) and child.get("Description") == owx_guid:
            return child
    raise AdjustError(f"no SBx token in aBag links to OWx bag {owx_guid!r}")


def adjust_ow_map(
    save: dict[str, Any],
    owx_guid: str,
    *,
    rotate: float = 0.0,
    scale: float = 1.0,
    abag_guid: str = ABAG_GUID,
) -> dict[str, Any]:
    """Rotate and/or scale one registered map, in place. Returns a summary."""
    if scale <= 0:
        raise AdjustError(f"scale must be positive, got {scale}")

    bag = find_object(save.get("ObjectStates") or [], owx_guid)
    if bag is None:
        raise AdjustError(f"OWx bag {owx_guid!r} not found in save")
    pieces = [c for c in bag.get("ContainedObjects") or [] if isinstance(c, dict)]
    if not pieces:
        raise AdjustError(f"OWx bag {owx_guid!r} holds no pieces")

    sbx = find_sbx_for(save, owx_guid, abag_guid)

    if rotate:
        rotate_pieces(pieces, rotate)
    if scale != 1.0:
        scale_pieces(pieces, scale)

    # The manifest is what the Hub actually spawns from; regenerate it so it
    # matches the transforms we just rewrote.
    sbx["LuaScript"] = build_sbx_manifest(bag)

    xs = [_num(p.get("Transform") or {}, "posX", 0.0) for p in pieces]
    zs = [_num(p.get("Transform") or {}, "posZ", 0.0) for p in pieces]
    return {
        "status": "adjusted",
        "owx_guid": owx_guid,
        "map_name": (bag.get("Nickname") or "").removeprefix("OWx_"),
        "sbx_guid": sbx.get("GUID"),
        "pieces": len(pieces),
        "rotated_degrees": rotate,
        "scaled_by": scale,
        "span": (round(max(xs) - min(xs), 2), round(max(zs) - min(zs), 2)),
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Save holding the registered map")
    parser.add_argument("output", type=Path, help="Where to write the adjusted save")
    parser.add_argument("--owx-guid", required=True, help="GUID of the map's OWx bag")
    parser.add_argument(
        "--rotate",
        type=float,
        default=0.0,
        help="Degrees to turn the map on the horizontal plane (e.g. 180)",
    )
    parser.add_argument(
        "--scale",
        type=float,
        default=1.0,
        help="Uniform factor on every piece's position and size",
    )
    parser.add_argument("--abag-guid", default=ABAG_GUID)
    args = parser.parse_args(argv)

    if not args.source.exists():
        print(f"error: {args.source} does not exist", file=sys.stderr)
        return 1
    if args.output.resolve() == args.source.resolve():
        print("error: refusing to overwrite the input save in place", file=sys.stderr)
        return 1

    save = json.loads(args.source.read_text())
    try:
        result = adjust_ow_map(
            save,
            args.owx_guid,
            rotate=args.rotate,
            scale=args.scale,
            abag_guid=args.abag_guid,
        )
    except AdjustError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    args.output.write_text(json.dumps(save))
    print(f"Adjusted map: {result['map_name']}")
    print(f"  OWx bag GUID: {result['owx_guid']}")
    print(f"  SBx GUID:     {result['sbx_guid']}")
    print(f"  Pieces:       {result['pieces']}")
    print(f"  Rotated:      {result['rotated_degrees']} degrees")
    print(f"  Scaled:       x{result['scaled_by']}")
    print(f"  Span now:     {result['span']}")
    print(f"Wrote {args.output}")
    return 0


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
