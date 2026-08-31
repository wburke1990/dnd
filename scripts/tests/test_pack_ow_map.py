"""Tests for packing a raw workshop save into a OneWorld donor bag."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools import import_ow_map as iom
from dnd_tools import pack_ow_map
from dnd_tools.fix_oneworld import ABAG_GUID


def _obj(
    guid: str,
    *,
    name: str = "Custom_Assetbundle",
    nickname: str = "",
    x: float = 0.0,
    y: float = 0.9,
    z: float = 0.0,
    scale: float = 1.0,
) -> dict[str, Any]:
    return {
        "GUID": guid,
        "Name": name,
        "Nickname": nickname,
        "Transform": {
            "posX": x,
            "posY": y,
            "posZ": z,
            "rotX": 0.0,
            "rotY": 0.0,
            "rotZ": 0.0,
            "scaleX": scale,
            "scaleY": scale,
            "scaleZ": scale,
        },
    }


def _save(objects: list[dict[str, Any]]) -> dict[str, Any]:
    return {"SaveName": "raw", "ObjectStates": objects}


# --- selection --------------------------------------------------------------


def test_select_pieces_keeps_the_table_surface() -> None:
    save = _save([_obj("aaa111", x=1.0), _obj("bbb222", x=2.0)])

    picked = pack_ow_map.select_pieces(save)

    assert [p["GUID"] for p in picked] == ["aaa111", "bbb222"]


def test_select_pieces_drops_furniture_below_the_table() -> None:
    save = _save([_obj("aaa111"), _obj("tbl001", nickname="The Kraken Table", y=-42.0)])

    picked = pack_ow_map.select_pieces(save)

    assert [p["GUID"] for p in picked] == ["aaa111"]


def test_select_pieces_drops_hand_zones_above_the_table() -> None:
    save = _save([_obj("aaa111"), _obj("hnd001", name="HandTrigger", y=10.0)])

    picked = pack_ow_map.select_pieces(save)

    assert [p["GUID"] for p in picked] == ["aaa111"]


def test_select_pieces_honours_name_exclusions() -> None:
    save = _save([_obj("aaa111"), _obj("chp001", name="Chip_10")])

    picked = pack_ow_map.select_pieces(save, exclude_names=frozenset({"Chip_10"}))

    assert [p["GUID"] for p in picked] == ["aaa111"]


def test_select_pieces_honours_nickname_prefix_exclusions() -> None:
    save = _save([_obj("aaa111"), _obj("cmd001", nickname="Commenditaire du Joueur A")])

    picked = pack_ow_map.select_pieces(save, exclude_nickname_prefixes=("Commenditaire",))

    assert [p["GUID"] for p in picked] == ["aaa111"]


# --- recentering ------------------------------------------------------------


def test_recenter_moves_the_bounding_box_to_the_origin() -> None:
    pieces = [_obj("aaa111", x=10.0, z=-4.0), _obj("bbb222", x=30.0, z=6.0)]

    pack_ow_map.recenter(pieces)

    assert pieces[0]["Transform"]["posX"] == -10.0
    assert pieces[1]["Transform"]["posX"] == 10.0
    assert pieces[0]["Transform"]["posZ"] == -5.0
    assert pieces[1]["Transform"]["posZ"] == 5.0


def test_recenter_returns_the_shift_applied() -> None:
    pieces = [_obj("aaa111", x=10.0, z=-4.0), _obj("bbb222", x=30.0, z=6.0)]

    assert pack_ow_map.recenter(pieces) == (20.0, 1.0)


def test_recenter_leaves_height_alone() -> None:
    pieces = [_obj("aaa111", x=10.0, y=0.9), _obj("bbb222", x=30.0, y=0.9)]

    pack_ow_map.recenter(pieces)

    assert pieces[0]["Transform"]["posY"] == 0.9


# --- scaling ----------------------------------------------------------------


def test_scale_multiplies_position_and_size_by_the_same_factor() -> None:
    pieces = [_obj("aaa111", x=10.0, y=0.9, z=-4.0, scale=2.0)]

    pack_ow_map.scale_pieces(pieces, 1.5)

    t = pieces[0]["Transform"]
    assert t["posX"] == 15.0
    assert t["posZ"] == -6.0
    assert t["scaleX"] == 3.0
    assert t["scaleY"] == 3.0
    assert t["scaleZ"] == 3.0


def test_scale_lifts_pieces_so_they_keep_their_feet_on_the_floor() -> None:
    pieces = [_obj("aaa111", y=0.9)]

    pack_ow_map.scale_pieces(pieces, 2.0)

    assert pieces[0]["Transform"]["posY"] == 1.8


def test_scale_preserves_relative_size_between_pieces() -> None:
    pieces = [_obj("aaa111", scale=1.0), _obj("bbb222", scale=4.0)]

    pack_ow_map.scale_pieces(pieces, 1.7)

    ratio = pieces[1]["Transform"]["scaleX"] / pieces[0]["Transform"]["scaleX"]
    assert ratio == pytest.approx(4.0)


def test_scale_preserves_relative_spacing_between_pieces() -> None:
    pieces = [_obj("aaa111", x=-10.0), _obj("bbb222", x=0.0), _obj("ccc333", x=30.0)]

    pack_ow_map.scale_pieces(pieces, 1.7)

    xs = [p["Transform"]["posX"] for p in pieces]
    assert (xs[2] - xs[1]) / (xs[1] - xs[0]) == pytest.approx(3.0)


def test_scale_of_one_changes_nothing() -> None:
    pieces = [_obj("aaa111", x=10.0, y=0.9, z=-4.0, scale=2.0)]

    pack_ow_map.scale_pieces(pieces, 1.0)

    t = pieces[0]["Transform"]
    assert (t["posX"], t["posY"], t["posZ"], t["scaleX"]) == (10.0, 0.9, -4.0, 2.0)


# --- packing ----------------------------------------------------------------


def test_pack_builds_a_named_owx_bag() -> None:
    save = _save([_obj("aaa111"), _obj("bbb222", x=4.0)])

    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")

    bag = donor["ObjectStates"][0]
    assert bag["Name"] == "Bag"
    assert bag["Nickname"] == "OWx_Haagen"
    assert len(bag["ContainedObjects"]) == 2
    assert summary["pieces"] == 2


def test_pack_scales_the_span_by_the_factor() -> None:
    save = _save([_obj("aaa111", x=0.0, z=0.0), _obj("bbb222", x=40.0, z=20.0)])

    _donor, summary = pack_ow_map.pack_ow_map(save, "Haagen", scale=1.5)

    assert summary["span_before"] == (40.0, 20.0)
    assert summary["span_after"] == (60.0, 30.0)


def test_pack_centres_the_map_after_scaling() -> None:
    save = _save([_obj("aaa111", x=10.0, z=0.0), _obj("bbb222", x=30.0, z=0.0)])

    donor, _summary = pack_ow_map.pack_ow_map(save, "Haagen", scale=2.0)

    xs = [c["Transform"]["posX"] for c in donor["ObjectStates"][0]["ContainedObjects"]]
    assert sum(xs) == pytest.approx(0.0)
    assert xs == [-20.0, 20.0]


def test_pack_defaults_to_no_scaling() -> None:
    save = _save([_obj("aaa111", x=0.0), _obj("bbb222", x=40.0)])

    _donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")

    assert summary["span_before"] == summary["span_after"]


def test_pack_rejects_a_non_positive_scale() -> None:
    save = _save([_obj("aaa111")])

    with pytest.raises(pack_ow_map.PackError):
        pack_ow_map.pack_ow_map(save, "Haagen", scale=0.0)


def test_pack_does_not_mutate_the_source_save() -> None:
    save = _save([_obj("aaa111", x=10.0), _obj("bbb222", x=30.0)])

    pack_ow_map.pack_ow_map(save, "Haagen", scale=3.0)

    assert save["ObjectStates"][0]["Transform"]["posX"] == 10.0


def test_pack_mints_a_bag_guid_that_does_not_collide() -> None:
    save = _save([_obj("aaa111")])

    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")

    assert summary["owx_guid"] != "aaa111"
    assert donor["ObjectStates"][0]["GUID"] == summary["owx_guid"]


def test_pack_raises_when_nothing_is_on_the_table() -> None:
    save = _save([_obj("tbl001", y=-42.0)])

    with pytest.raises(pack_ow_map.PackError):
        pack_ow_map.pack_ow_map(save, "Haagen")


# --- the packed bag is importable ------------------------------------------


def _ow_target() -> dict[str, Any]:
    """A minimal target save with the aBag and mBag the importer requires."""
    return {
        "ObjectStates": [
            {
                "GUID": ABAG_GUID,
                "Name": "Bag",
                "Nickname": "aBag",
                "LuaScript": "",
                "ContainedObjects": [],
            },
            {
                "GUID": iom.MBAG_GUID,
                "Name": "Bag",
                "Nickname": "Tra",
                "Description": "_OW_mBaG",
                "ContainedObjects": [],
            },
        ]
    }


def test_packed_bag_imports_into_a_target_save() -> None:
    save = _save([_obj("aaa111", x=0.0), _obj("bbb222", x=40.0)])
    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen", scale=1.5)
    target = _ow_target()

    result = iom.import_ow_map(
        donor, target, owx_guid=summary["owx_guid"], sbx_image_url="http://example/floor.png"
    )

    assert result["status"] == "imported"
    assert result["map_name"] == "Haagen"
    abag = target["ObjectStates"][0]
    assert ",Haagen," in abag["LuaScript"]
    assert abag["ContainedObjects"][0]["Nickname"] == "SBx_Haagen"


def test_a_packed_map_keeps_the_hub_floor_at_its_default() -> None:
    """The map is sized to the table; the floor is left alone."""
    save = _save([_obj("aaa111", x=0.0), _obj("bbb222", x=40.0)])
    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen", scale=1.5)
    target = _ow_target()

    result = iom.import_ow_map(
        donor, target, owx_guid=summary["owx_guid"], sbx_image_url="http://example/floor.png"
    )

    assert result["vbase_scale"] == iom.DEFAULT_VBASE


# --- CLI --------------------------------------------------------------------


def test_cli_writes_a_donor_save(tmp_path: Path) -> None:
    source = tmp_path / "raw.json"
    source.write_text(json.dumps(_save([_obj("aaa111"), _obj("chp001", name="Chip_10")])))
    out = tmp_path / "donor.json"

    rc = pack_ow_map.main([str(source), str(out), "--name", "Haagen", "--exclude-name", "Chip_10"])

    assert rc == 0
    donor = json.loads(out.read_text())
    assert donor["ObjectStates"][0]["Nickname"] == "OWx_Haagen"
    assert len(donor["ObjectStates"][0]["ContainedObjects"]) == 1


def test_cli_applies_the_scale_flag(tmp_path: Path) -> None:
    source = tmp_path / "raw.json"
    source.write_text(json.dumps(_save([_obj("aaa111", x=0.0), _obj("bbb222", x=10.0)])))
    out = tmp_path / "donor.json"

    pack_ow_map.main([str(source), str(out), "--name", "Haagen", "--scale", "2"])

    donor = json.loads(out.read_text())
    xs = [c["Transform"]["posX"] for c in donor["ObjectStates"][0]["ContainedObjects"]]
    assert max(xs) - min(xs) == 20.0


def test_cli_reports_a_missing_source(tmp_path: Path) -> None:
    rc = pack_ow_map.main([str(tmp_path / "nope.json"), str(tmp_path / "out.json"), "--name", "X"])

    assert rc == 1
