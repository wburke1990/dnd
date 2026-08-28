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
            "scaleX": 1.0,
            "scaleY": 1.0,
            "scaleZ": 1.0,
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


# --- packing ----------------------------------------------------------------


def test_pack_builds_a_named_owx_bag() -> None:
    save = _save([_obj("aaa111"), _obj("bbb222", x=4.0)])

    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")

    bag = donor["ObjectStates"][0]
    assert bag["Name"] == "Bag"
    assert bag["Nickname"] == "OWx_Haagen"
    assert len(bag["ContainedObjects"]) == 2
    assert summary["pieces"] == 2


def test_pack_reports_the_span_and_a_vbase_suggestion() -> None:
    save = _save([_obj("aaa111", x=0.0, z=0.0), _obj("bbb222", x=40.0, z=20.0)])

    _donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")

    assert summary["span_x"] == 40.0
    assert summary["span_z"] == 20.0
    assert summary["suggested_vbase"] == 40.0


def test_pack_does_not_mutate_the_source_save() -> None:
    save = _save([_obj("aaa111", x=10.0), _obj("bbb222", x=30.0)])

    pack_ow_map.pack_ow_map(save, "Haagen")

    assert save["ObjectStates"][0]["Transform"]["posX"] == 10.0


def test_pack_can_skip_recentering() -> None:
    save = _save([_obj("aaa111", x=10.0), _obj("bbb222", x=30.0)])

    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen", do_recenter=False)

    bag = donor["ObjectStates"][0]
    assert bag["ContainedObjects"][0]["Transform"]["posX"] == 10.0
    assert summary["recentered_by"] == (0.0, 0.0)


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
    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")
    target = _ow_target()

    result = iom.import_ow_map(
        donor, target, owx_guid=summary["owx_guid"], sbx_image_url="http://example/floor.png"
    )

    assert result["status"] == "imported"
    assert result["map_name"] == "Haagen"
    abag = target["ObjectStates"][0]
    assert ",Haagen," in abag["LuaScript"]
    assert abag["ContainedObjects"][0]["Nickname"] == "SBx_Haagen"


def test_vbase_override_sets_the_jotbase_scale() -> None:
    save = _save([_obj("aaa111", x=0.0), _obj("bbb222", x=40.0)])
    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")
    target = _ow_target()

    result = iom.import_ow_map(
        donor,
        target,
        owx_guid=summary["owx_guid"],
        sbx_image_url="http://example/floor.png",
        vbase=42.0,
    )

    assert result["vbase_scale"] == 42.0
    assert result["vbase_overridden"] is True
    assert "{42.00;1;42.00}" in target["ObjectStates"][0]["LuaScript"]


def test_without_an_override_a_plateless_map_keeps_the_default_vbase() -> None:
    save = _save([_obj("aaa111", x=0.0), _obj("bbb222", x=40.0)])
    donor, summary = pack_ow_map.pack_ow_map(save, "Haagen")
    target = _ow_target()

    result = iom.import_ow_map(
        donor, target, owx_guid=summary["owx_guid"], sbx_image_url="http://example/floor.png"
    )

    assert result["vbase_scale"] == iom.DEFAULT_VBASE
    assert result["vbase_overridden"] is False


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


def test_cli_reports_a_missing_source(tmp_path: Path) -> None:
    rc = pack_ow_map.main([str(tmp_path / "nope.json"), str(tmp_path / "out.json"), "--name", "X"])

    assert rc == 1
