"""Package loose objects from a raw workshop save into a OneWorld donor bag.

``import_ow_map`` needs a donor save that already holds an ``OWx_<Name>`` bag.
The One World library (``TS_Save_22``) is full of them, but a map found on the
Workshop is not: it loads as loose objects on a table, and there is no bag to
import. This turns one into the other.

**What it selects.** A workshop mod's pieces sit at different heights. The map
is on the table at ``posY`` a little above zero; the furniture — the table
model, its cabinets and extensions — sits far below at a large negative
``posY``, and hand zones and player boards sit above. So the default selection
is a Y band around the table surface, with name and nickname exclusions for the
game pieces that share it.

**What it does to them: one uniform scale, then centre.** The map is sized to
the table, and the Hub's floor is left at its default. Every piece's position
and its own scale are multiplied by the same factor, so nothing changes size
relative to anything else, and then the selection is shifted to sit centred on
the origin, which is where the Hub places its floor.

This is the second design. The first sized the *floor* to the *map* — it fed a
per-map number to an ``import_ow_map --vbase`` flag — and it does not work:
every value traded a floor overhanging the table against buildings hanging off
the floor, because a Workshop map arrives at whatever size its designer used and
the table is a fixed size. Scaling the map is the operation that has a right
answer. Both attempts to compute the floor number from the map's span were also
artifacts of a small sample; there is no such formula, which is a second reason
not to go back to it.

The scale factor is a judgement about how much of the table the map should fill,
so it is an argument, not something inferred. Because the transform is uniform,
correcting it is one multiply: a map that comes out a third too big goes back
through at ``--scale`` divided by 1.33.
"""

from __future__ import annotations

import argparse
import json
import secrets
import sys
from copy import deepcopy
from pathlib import Path
from typing import Any

# A workshop table model and its furniture sit far below the play surface
# (-42 in the save that prompted this); hand zones and player aids float above
# it. This band is "on the table".
DEFAULT_MIN_Y = 0.0
DEFAULT_MAX_Y = 2.0

BAG_TEMPLATE: dict[str, Any] = {
    "Name": "Bag",
    "Transform": {
        "posX": 0.0,
        "posY": 1.0,
        "posZ": 0.0,
        "rotX": 0.0,
        "rotY": 0.0,
        "rotZ": 0.0,
        "scaleX": 1.0,
        "scaleY": 1.0,
        "scaleZ": 1.0,
    },
    "Description": "",
    "GMNotes": "",
    "AltLookAngle": {"x": 0.0, "y": 0.0, "z": 0.0},
    "ColorDiffuse": {"r": 0.705882251, "g": 0.366520882, "b": 0.0},
    "LayoutGroupSortIndex": 0,
    "Value": 0,
    "Locked": False,
    "Grid": True,
    "Snap": True,
    "IgnoreFoW": False,
    "MeasureMovement": False,
    "DragSelectable": True,
    "Autoraise": True,
    "Sticky": True,
    "Tooltip": True,
    "GridProjection": False,
    "HideWhenFaceDown": False,
    "Hands": False,
    "MaterialIndex": -1,
    "MeshIndex": -1,
    "Bag": {"Order": 0},
    "LuaScript": "",
    "LuaScriptState": "",
    "XmlUI": "",
}


class PackError(RuntimeError):
    """Raised when a save yields no packable map."""


def _pos(obj: dict[str, Any], axis: str) -> float:
    transform = obj.get("Transform")
    if not isinstance(transform, dict):
        return 0.0
    try:
        return float(transform.get(f"pos{axis}", 0.0) or 0.0)
    except (TypeError, ValueError):
        return 0.0


def _scale(obj: dict[str, Any], axis: str) -> float:
    transform = obj.get("Transform")
    if not isinstance(transform, dict):
        return 1.0
    try:
        return float(transform.get(f"scale{axis}", 1.0) or 1.0)
    except (TypeError, ValueError):
        return 1.0


def select_pieces(
    save: dict[str, Any],
    *,
    min_y: float = DEFAULT_MIN_Y,
    max_y: float = DEFAULT_MAX_Y,
    exclude_names: frozenset[str] = frozenset(),
    exclude_nickname_prefixes: tuple[str, ...] = (),
) -> list[dict[str, Any]]:
    """Top-level objects sitting on the table, minus the excluded game pieces."""
    picked: list[dict[str, Any]] = []
    for obj in save.get("ObjectStates") or []:
        if not isinstance(obj, dict):
            continue
        name = obj.get("Name")
        if isinstance(name, str) and name in exclude_names:
            continue
        nickname = obj.get("Nickname")
        if isinstance(nickname, str) and any(
            nickname.startswith(p) for p in exclude_nickname_prefixes
        ):
            continue
        if not min_y <= _pos(obj, "Y") <= max_y:
            continue
        picked.append(obj)
    return picked


def bounds(pieces: list[dict[str, Any]]) -> tuple[float, float, float, float]:
    """``(min_x, max_x, min_z, max_z)`` over the pieces' positions."""
    xs = [_pos(p, "X") for p in pieces]
    zs = [_pos(p, "Z") for p in pieces]
    return min(xs), max(xs), min(zs), max(zs)


def recenter(pieces: list[dict[str, Any]]) -> tuple[float, float]:
    """Shift pieces so their bounding box centres on the origin. Returns the shift."""
    min_x, max_x, min_z, max_z = bounds(pieces)
    cx = (min_x + max_x) / 2
    cz = (min_z + max_z) / 2
    for piece in pieces:
        transform = piece.get("Transform")
        if isinstance(transform, dict):
            transform["posX"] = _pos(piece, "X") - cx
            transform["posZ"] = _pos(piece, "Z") - cz
    return cx, cz


def scale_pieces(pieces: list[dict[str, Any]], factor: float) -> None:
    """Multiply every piece's position and size by ``factor``.

    Positions scale about the origin on X and Z — so call this after
    ``recenter`` — and about the floor plane on Y, since a piece that doubles in
    size has to sit twice as far above the floor to keep its feet on it.

    Every axis of every piece takes the same factor, which is the point: the map
    changes size without anything inside it changing shape or moving relative to
    its neighbours.
    """
    for piece in pieces:
        transform = piece.get("Transform")
        if not isinstance(transform, dict):
            continue
        for axis in ("X", "Y", "Z"):
            transform[f"pos{axis}"] = _pos(piece, axis) * factor
            transform[f"scale{axis}"] = _scale(piece, axis) * factor


def pack_ow_map(
    save: dict[str, Any],
    map_name: str,
    *,
    scale: float = 1.0,
    min_y: float = DEFAULT_MIN_Y,
    max_y: float = DEFAULT_MAX_Y,
    exclude_names: frozenset[str] = frozenset(),
    exclude_nickname_prefixes: tuple[str, ...] = (),
) -> tuple[dict[str, Any], dict[str, Any]]:
    """Build a donor save holding one ``OWx_<map_name>`` bag.

    Returns ``(donor_save, summary)``.
    """
    if scale <= 0:
        raise PackError(f"scale must be positive, got {scale}")

    pieces = deepcopy(
        select_pieces(
            save,
            min_y=min_y,
            max_y=max_y,
            exclude_names=exclude_names,
            exclude_nickname_prefixes=exclude_nickname_prefixes,
        )
    )
    if not pieces:
        raise PackError(f"no objects found between posY {min_y} and {max_y}")

    shift = recenter(pieces)
    min_x, max_x, min_z, max_z = bounds(pieces)
    span_before = (round(max_x - min_x, 2), round(max_z - min_z, 2))

    scale_pieces(pieces, scale)
    min_x, max_x, min_z, max_z = bounds(pieces)

    used = {o.get("GUID") for o in save.get("ObjectStates") or [] if isinstance(o.get("GUID"), str)}
    bag_guid = secrets.token_hex(3)
    while bag_guid in used:
        bag_guid = secrets.token_hex(3)

    bag = deepcopy(BAG_TEMPLATE)
    bag["GUID"] = bag_guid
    bag["Nickname"] = f"OWx_{map_name}"
    bag["ContainedObjects"] = pieces

    donor = {"SaveName": f"{map_name} (OW donor)", "ObjectStates": [bag]}
    summary = {
        "map_name": map_name,
        "owx_guid": bag_guid,
        "pieces": len(pieces),
        "scale": scale,
        "span_before": span_before,
        "span_after": (round(max_x - min_x, 2), round(max_z - min_z, 2)),
        "recentered_by": (round(shift[0], 2), round(shift[1], 2)),
    }
    return donor, summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Raw workshop save to pack")
    parser.add_argument("output", type=Path, help="Where to write the donor save")
    parser.add_argument("--name", required=True, help="Map name (becomes OWx_<name>)")
    parser.add_argument(
        "--scale",
        type=float,
        default=1.0,
        help=(
            "Uniform factor on every piece's position and size, so the map fills "
            "more or less of the table without anything inside it changing shape. "
            "Correcting it is one multiply."
        ),
    )
    parser.add_argument("--min-y", type=float, default=DEFAULT_MIN_Y)
    parser.add_argument("--max-y", type=float, default=DEFAULT_MAX_Y)
    parser.add_argument(
        "--exclude-name",
        action="append",
        default=[],
        help="Object Name to drop (repeatable), e.g. Chip_10",
    )
    parser.add_argument(
        "--exclude-nickname",
        action="append",
        default=[],
        help="Nickname prefix to drop (repeatable), e.g. 'Commenditaire'",
    )
    args = parser.parse_args(argv)

    if not args.source.exists():
        print(f"error: {args.source} does not exist", file=sys.stderr)
        return 1

    save = json.loads(args.source.read_text())
    try:
        donor, summary = pack_ow_map(
            save,
            args.name,
            scale=args.scale,
            min_y=args.min_y,
            max_y=args.max_y,
            exclude_names=frozenset(args.exclude_name),
            exclude_nickname_prefixes=tuple(args.exclude_nickname),
        )
    except PackError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    args.output.write_text(json.dumps(donor))

    print(f"Packed map: {summary['map_name']}")
    print(f"  OWx bag GUID: {summary['owx_guid']}")
    print(f"  Pieces:       {summary['pieces']}")
    print(f"  Recentered:   {summary['recentered_by']}")
    print(f"  Scale:        x{summary['scale']}")
    print(f"  Span:         {summary['span_before']} -> {summary['span_after']}")
    print(f"Wrote {args.output}")
    print(
        "\nNEXT — import it, leaving the Hub floor at its default:\n"
        f"  python -m dnd_tools.import_ow_map <donor> <target> <out> "
        f"--owx-guid {summary['owx_guid']} --sbx-image-url <floor image>\n"
        "\n"
        "Then Build it and look at the map against the floor. If it is too big or\n"
        "too small, re-pack with --scale multiplied by the same amount and import\n"
        "again. Do not resize the floor to match. See docs/oneworld.md."
    )
    return 0


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
