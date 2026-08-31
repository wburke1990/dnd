"""Tests for rotating and resizing a registered OneWorld map."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools import adjust_ow_map
from dnd_tools.fix_oneworld import ABAG_GUID


def _piece(
    guid: str,
    *,
    x: float = 0.0,
    y: float = 0.9,
    z: float = 0.0,
    rot_y: float = 0.0,
    scale: float = 1.0,
) -> dict[str, Any]:
    return {
        "GUID": guid,
        "Name": "Custom_Assetbundle",
        "Transform": {
            "posX": x,
            "posY": y,
            "posZ": z,
            "rotX": 0.0,
            "rotY": rot_y,
            "rotZ": 0.0,
            "scaleX": scale,
            "scaleY": scale,
            "scaleZ": scale,
        },
    }


def _save(pieces: list[dict[str, Any]], *, owx_guid: str = "bbb111") -> dict[str, Any]:
    return {
        "ObjectStates": [
            {
                "GUID": ABAG_GUID,
                "Name": "Bag",
                "Nickname": "aBag",
                "LuaScript": "",
                "ContainedObjects": [
                    {
                        "GUID": "sbx001",
                        "Name": "Custom_Token",
                        "Nickname": "SBx_Test",
                        "Description": owx_guid,
                        "LuaScript": "stale manifest\n",
                    }
                ],
            },
            {
                "GUID": owx_guid,
                "Name": "Bag",
                "Nickname": "OWx_Test",
                "ContainedObjects": pieces,
            },
        ]
    }


# --- rotation ---------------------------------------------------------------


def test_rotate_180_flips_position_across_the_origin() -> None:
    pieces = [_piece("aaa111", x=10.0, z=4.0)]

    adjust_ow_map.rotate_pieces(pieces, 180.0)

    t = pieces[0]["Transform"]
    assert t["posX"] == pytest.approx(-10.0)
    assert t["posZ"] == pytest.approx(-4.0)


def test_rotate_180_turns_each_piece_to_match() -> None:
    pieces = [_piece("aaa111", rot_y=30.0)]

    adjust_ow_map.rotate_pieces(pieces, 180.0)

    assert pieces[0]["Transform"]["rotY"] == pytest.approx(210.0)


def test_rotate_wraps_past_a_full_turn() -> None:
    pieces = [_piece("aaa111", rot_y=270.0)]

    adjust_ow_map.rotate_pieces(pieces, 180.0)

    assert pieces[0]["Transform"]["rotY"] == pytest.approx(90.0)


def test_rotate_leaves_height_alone() -> None:
    pieces = [_piece("aaa111", x=10.0, y=0.9)]

    adjust_ow_map.rotate_pieces(pieces, 180.0)

    assert pieces[0]["Transform"]["posY"] == 0.9


def test_rotate_preserves_distances_between_pieces() -> None:
    pieces = [_piece("aaa111", x=0.0, z=0.0), _piece("bbb222", x=3.0, z=4.0)]

    adjust_ow_map.rotate_pieces(pieces, 37.0)

    a, b = (p["Transform"] for p in pieces)
    dist = ((b["posX"] - a["posX"]) ** 2 + (b["posZ"] - a["posZ"]) ** 2) ** 0.5
    assert dist == pytest.approx(5.0)


def test_two_rotations_of_180_return_to_the_start() -> None:
    pieces = [_piece("aaa111", x=7.0, z=-2.0, rot_y=45.0)]

    adjust_ow_map.rotate_pieces(pieces, 180.0)
    adjust_ow_map.rotate_pieces(pieces, 180.0)

    t = pieces[0]["Transform"]
    assert t["posX"] == pytest.approx(7.0)
    assert t["posZ"] == pytest.approx(-2.0)
    assert t["rotY"] == pytest.approx(45.0)


# --- scaling ----------------------------------------------------------------


def test_scale_multiplies_position_and_size() -> None:
    pieces = [_piece("aaa111", x=10.0, y=0.9, z=-4.0, scale=2.0)]

    adjust_ow_map.scale_pieces(pieces, 1.5)

    t = pieces[0]["Transform"]
    assert t["posX"] == pytest.approx(15.0)
    assert t["posY"] == pytest.approx(1.35)
    assert t["posZ"] == pytest.approx(-6.0)
    assert t["scaleX"] == pytest.approx(3.0)


def test_scale_preserves_relative_size() -> None:
    pieces = [_piece("aaa111", scale=1.0), _piece("bbb222", scale=4.0)]

    adjust_ow_map.scale_pieces(pieces, 1.7)

    a, b = (p["Transform"]["scaleX"] for p in pieces)
    assert b / a == pytest.approx(4.0)


# --- the manifest -----------------------------------------------------------


def test_adjust_regenerates_the_sbx_manifest() -> None:
    save = _save([_piece("aaa111", x=10.0, z=4.0)])

    adjust_ow_map.adjust_ow_map(save, "bbb111", rotate=180.0)

    manifest = save["ObjectStates"][0]["ContainedObjects"][0]["LuaScript"]
    assert "stale manifest" not in manifest
    assert manifest.startswith("--aaa111,")


def test_the_manifest_carries_the_rotated_positions() -> None:
    save = _save([_piece("aaa111", x=10.0, z=4.0)])

    adjust_ow_map.adjust_ow_map(save, "bbb111", rotate=180.0)

    manifest = save["ObjectStates"][0]["ContainedObjects"][0]["LuaScript"]
    fields = manifest.strip().removeprefix("--").split(",")
    assert float(fields[1]) == pytest.approx(-10.0)
    assert float(fields[3]) == pytest.approx(-4.0)


def test_the_manifest_carries_the_scaled_positions() -> None:
    save = _save([_piece("aaa111", x=10.0, z=4.0)])

    adjust_ow_map.adjust_ow_map(save, "bbb111", scale=2.0)

    manifest = save["ObjectStates"][0]["ContainedObjects"][0]["LuaScript"]
    fields = manifest.strip().removeprefix("--").split(",")
    assert float(fields[1]) == pytest.approx(20.0)


# --- errors -----------------------------------------------------------------


def test_adjust_reports_a_missing_bag() -> None:
    save = _save([_piece("aaa111")])

    with pytest.raises(adjust_ow_map.AdjustError):
        adjust_ow_map.adjust_ow_map(save, "nope00", rotate=180.0)


def test_adjust_reports_an_unlinked_sbx() -> None:
    save = _save([_piece("aaa111")])
    save["ObjectStates"][0]["ContainedObjects"][0]["Description"] = "other0"

    with pytest.raises(adjust_ow_map.AdjustError):
        adjust_ow_map.adjust_ow_map(save, "bbb111", rotate=180.0)


def test_adjust_reports_an_empty_bag() -> None:
    save = _save([])

    with pytest.raises(adjust_ow_map.AdjustError):
        adjust_ow_map.adjust_ow_map(save, "bbb111", rotate=180.0)


def test_adjust_rejects_a_non_positive_scale() -> None:
    save = _save([_piece("aaa111")])

    with pytest.raises(adjust_ow_map.AdjustError):
        adjust_ow_map.adjust_ow_map(save, "bbb111", scale=-1.0)


# --- summary and CLI --------------------------------------------------------


def test_adjust_reports_the_resulting_span() -> None:
    save = _save([_piece("aaa111", x=-10.0), _piece("bbb222", x=10.0, z=5.0)])

    result = adjust_ow_map.adjust_ow_map(save, "bbb111", scale=2.0)

    assert result["span"] == (40.0, 10.0)
    assert result["map_name"] == "Test"


def test_cli_writes_an_adjusted_save(tmp_path: Path) -> None:
    source = tmp_path / "in.json"
    source.write_text(json.dumps(_save([_piece("aaa111", x=10.0)])))
    out = tmp_path / "out.json"

    rc = adjust_ow_map.main([str(source), str(out), "--owx-guid", "bbb111", "--rotate", "180"])

    assert rc == 0
    save = json.loads(out.read_text())
    piece = save["ObjectStates"][1]["ContainedObjects"][0]
    assert piece["Transform"]["posX"] == pytest.approx(-10.0)


def test_cli_refuses_to_overwrite_its_input(tmp_path: Path) -> None:
    source = tmp_path / "in.json"
    source.write_text(json.dumps(_save([_piece("aaa111")])))

    rc = adjust_ow_map.main([str(source), str(source), "--owx-guid", "bbb111"])

    assert rc == 1
