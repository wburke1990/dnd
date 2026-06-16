"""Tests for the OneWorld map importer."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools.fix_oneworld import ABAG_GUID
from dnd_tools.import_ow_map import (
    MBAG_GUID,
    ImportError_,
    build_sbx_manifest,
    build_sbx_token,
    collect_save_guids,
    collect_subtree_guids,
    import_ow_map,
    jotbase_line,
    main,
    map_already_imported,
    mint_guid,
    remap_guids_in_subtree,
)


def _wbase(image_url: str = "https://example.com/water.jpg") -> dict[str, Any]:
    return {
        "Name": "Custom_Token",
        "Nickname": "_OW_wBase",
        "GUID": "aaaaaa",
        "Description": "",
        "CustomImage": {"ImageURL": image_url},
    }


def _abag(guid: str = ABAG_GUID, lua: str = "") -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": "aBag",
        "GUID": guid,
        "Description": "_OW_aBaG_xxxxxx",
        "LuaScript": lua,
        "ContainedObjects": [],
    }


def _mbag(guid: str = MBAG_GUID) -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": "Tra",
        "GUID": guid,
        "Description": "_OW_mBaG",
        "LuaScript": "",
        "ContainedObjects": [],
    }


def _owx_bag(
    map_name: str = "Test Map",
    guid: str = "bbbbbb",
    contained: list[dict[str, Any]] | None = None,
) -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": f"OWx_{map_name}",
        "GUID": guid,
        "Description": "d64bdb,0,0,2,0",
        "LuaScript": "",
        "ContainedObjects": contained or [],
    }


def _save(states: list[dict[str, Any]]) -> dict[str, Any]:
    return {"SaveName": "test", "ObjectStates": states}


# -----------------------------------------------------------------------------
# Pure helpers
# -----------------------------------------------------------------------------


def test_collect_subtree_guids_recurses() -> None:
    bag = _owx_bag(
        contained=[
            {"GUID": "aaa111", "ContainedObjects": [{"GUID": "bbb222"}]},
            {"GUID": "ccc333"},
        ]
    )
    assert collect_subtree_guids(bag) == {"bbbbbb", "aaa111", "bbb222", "ccc333"}


def test_collect_save_guids_includes_nested() -> None:
    save = _save(
        [
            {"GUID": "top111", "ContainedObjects": [{"GUID": "nest11"}]},
            {"GUID": "top222"},
        ]
    )
    assert collect_save_guids(save) == {"top111", "nest11", "top222"}


def test_mint_guid_avoids_used() -> None:
    used = {"abc123"}
    new = mint_guid(used)
    assert new != "abc123"
    assert new in used  # added to used
    assert len(new) == 6
    assert all(c in "0123456789abcdef" for c in new)


def test_jotbase_line_matches_live_format() -> None:
    # Compare against the format observed in tts/lua/TS_Save_19/966e1c.lua.
    line = jotbase_line("01d3f9", "Tomb_1")
    assert line == "--01d3f9,Tomb_1,{1.85;1;1.85},{25.00;1;25.00},0,0,2,0,"


def test_build_sbx_token_links_to_owx() -> None:
    tok = build_sbx_token("aaaaaa", "Dockside City", "https://img", "bbbbbb")
    assert tok["Name"] == "Custom_Token"
    assert tok["GUID"] == "aaaaaa"
    assert tok["Nickname"] == "SBx_Dockside City"
    assert tok["Description"] == "bbbbbb"  # the linkage cbGetBase reads
    assert tok["CustomImage"]["ImageURL"] == "https://img"


def test_manifest_never_uses_scientific_notation() -> None:
    """Live SBx scripts use plain decimal everywhere; sci notation may
    confuse the Hub parser. Test rotation values close to zero (where
    Python's repr() switches to sci) come out as decimals.
    """
    bag = _owx_bag(
        contained=[
            {
                "GUID": "tiny01",
                "Transform": {
                    "rotX": -1.25868939e-06,  # repr() yields '-1.25868939e-06'
                    "rotZ": 6.190606e-05,
                },
            },
        ],
    )
    manifest = build_sbx_manifest(bag)
    assert "e-" not in manifest
    assert "e+" not in manifest
    assert "E-" not in manifest
    assert "-0.00000125868939" in manifest
    assert "0.0000619060" in manifest  # at least 4 digits past the leading zeros


def test_build_sbx_manifest_format_matches_live_sbx() -> None:
    """Format matches a verbatim line from live SBx_Wizards_Tower:
    --<guid>,posX,posY,posZ,rotX,rotY,rotZ,1
    """
    bag = _owx_bag(
        contained=[
            {
                "GUID": "901d81",
                "Transform": {
                    "posX": -15.5,
                    "posY": 2.0,
                    "posZ": -28.0,
                    "rotX": 0.0,
                    "rotY": 359.0,
                    "rotZ": 0.0,
                    "scaleX": 0.5,
                },
            },
        ],
    )
    manifest = build_sbx_manifest(bag)
    assert manifest == "--901d81,-15.5,2.0,-28.0,0.0,359.0,0.0,1\n"


def test_build_sbx_manifest_one_line_per_child() -> None:
    bag = _owx_bag(
        contained=[
            {"GUID": "aaa111", "Transform": {"posX": 1.0, "posY": 2.0, "posZ": 3.0}},
            {"GUID": "bbb222", "Transform": {"posX": 4.0, "posY": 5.0, "posZ": 6.0}},
            {"GUID": "ccc333", "Transform": {"posX": 7.0, "posY": 8.0, "posZ": 9.0}},
        ],
    )
    manifest = build_sbx_manifest(bag)
    assert manifest.count("\n") == 3
    assert manifest.count("--") == 3
    assert "--aaa111," in manifest
    assert "--bbb222," in manifest
    assert "--ccc333," in manifest


def test_build_sbx_manifest_skips_malformed_children() -> None:
    bag = _owx_bag(
        contained=[
            {"GUID": "aaa111", "Transform": {"posX": 1.0}},
            "not-a-dict",  # type: ignore[list-item]
            {"NoGUID": True, "Transform": {}},
            {"GUID": "bbb222", "Transform": "not-a-dict"},
            {"GUID": "ccc333", "Transform": {"posX": 2.0}},
        ],
    )
    manifest = build_sbx_manifest(bag)
    assert "--aaa111," in manifest
    assert "--ccc333," in manifest
    assert "--bbb222," not in manifest


def test_build_sbx_manifest_empty_bag_returns_empty_string() -> None:
    bag = _owx_bag(contained=[])
    assert build_sbx_manifest(bag) == ""


def test_build_sbx_manifest_uses_post_remap_guids() -> None:
    """Manifest must reflect any GUID remapping done before generation."""
    bag = _owx_bag(
        guid="bagid1",
        contained=[{"GUID": "old111", "Transform": {"posX": 0.0}}],
    )
    remap_guids_in_subtree(bag, {"old111": "new111"})
    manifest = build_sbx_manifest(bag)
    assert "--new111," in manifest
    assert "old111" not in manifest


# -----------------------------------------------------------------------------
# GUID remap correctness
# -----------------------------------------------------------------------------


def test_remap_rewrites_guid_field() -> None:
    bag = _owx_bag(guid="abc123", contained=[{"GUID": "def456"}])
    remap_guids_in_subtree(bag, {"abc123": "999999", "def456": "888888"})
    assert bag["GUID"] == "999999"
    assert bag["ContainedObjects"][0]["GUID"] == "888888"


def test_remap_rewrites_description_jotbase_fragment() -> None:
    bag = _owx_bag()
    bag["Description"] = "abc123,0,0,2,0"
    remap_guids_in_subtree(bag, {"abc123": "999999"})
    assert bag["Description"] == "999999,0,0,2,0"


def test_remap_rewrites_lua_references() -> None:
    bag = _owx_bag()
    bag["LuaScript"] = 'local x = getObjectFromGUID("abc123")\n-- @abc123'
    remap_guids_in_subtree(bag, {"abc123": "999999"})
    assert bag["LuaScript"] == 'local x = getObjectFromGUID("999999")\n-- @999999'


def test_remap_does_not_touch_substring_inside_longer_hex() -> None:
    bag = _owx_bag()
    # "abc123" appears inside "abc1234d" — must NOT be rewritten.
    bag["LuaScript"] = "-- token abc1234d should survive\n-- standalone abc123 should not"
    remap_guids_in_subtree(bag, {"abc123": "999999"})
    assert "abc1234d" in bag["LuaScript"]
    assert "standalone 999999 should not" in bag["LuaScript"]


def test_remap_empty_mapping_is_noop() -> None:
    bag = _owx_bag()
    original = json.dumps(bag, sort_keys=True)
    remap_guids_in_subtree(bag, {})
    assert json.dumps(bag, sort_keys=True) == original


# -----------------------------------------------------------------------------
# Full import flow
# -----------------------------------------------------------------------------


def test_import_basic_no_collisions() -> None:
    source = _save(
        [
            _wbase("https://example.com/water.jpg"),
            _owx_bag(
                "Dockside City",
                guid="bbbbbb",
                contained=[
                    {
                        "GUID": "child1",
                        "Transform": {
                            "posX": 1.0,
                            "posY": 2.0,
                            "posZ": 3.0,
                            "rotX": 0.0,
                            "rotY": 0.0,
                            "rotZ": 0.0,
                        },
                    },
                ],
            ),
        ]
    )
    target = _save([_abag(lua="--existing01,Wizards_Tower,...\n"), _mbag()])

    result = import_ow_map(source, target)
    assert result["status"] == "imported"
    assert result["map_name"] == "Dockside City"
    assert result["owx_guid"] == "bbbbbb"  # no collision, original kept
    assert result["collisions_remapped"] == 0

    # OWx bag injected INSIDE mBag (Hub's ButtonBuild requires this).
    mbag = next(o for o in target["ObjectStates"] if o.get("GUID") == MBAG_GUID)
    bag = next(o for o in mbag["ContainedObjects"] if o.get("Nickname") == "OWx_Dockside City")
    # NOT at top level.
    assert not any(o.get("Nickname") == "OWx_Dockside City" for o in target["ObjectStates"])
    # Description cleared to match the convention of live working content
    # bags (e.g. Wizards_Tower's), which have empty Description.
    assert bag["Description"] == ""

    # SBx token added to aBag with link to OWx bag.
    abag = next(o for o in target["ObjectStates"] if o.get("GUID") == ABAG_GUID)
    sbx = next(o for o in abag["ContainedObjects"] if o.get("Nickname") == "SBx_Dockside City")
    assert sbx["GUID"] == result["sbx_guid"]
    assert sbx["Description"] == "bbbbbb"
    assert sbx["CustomImage"]["ImageURL"] == "https://example.com/water.jpg"

    # JotBase line appended in correct format.
    assert (
        f"--{result['sbx_guid']},Dockside City,{{1.85;1;1.85}},{{25.00;1;25.00}},0,0,2,0,"
        in abag["LuaScript"]
    )

    # SBx LuaScript carries the per-child manifest that gates the Build button.
    assert sbx["LuaScript"] != ""
    assert "--child1,1.0,2.0,3.0,0.0,0.0,0.0,1" in sbx["LuaScript"]


def test_import_remaps_colliding_top_level_guid() -> None:
    # OWx bag GUID `bbbbbb` collides with an existing target object.
    source = _save(
        [
            _wbase(),
            _owx_bag(
                "Dockside City",
                guid="bbbbbb",
                contained=[{"GUID": "child1", "LuaScript": "-- self ref bbbbbb"}],
            ),
        ]
    )
    target = _save(
        [
            _abag(),
            _mbag(),
            {"GUID": "bbbbbb", "Name": "Custom_Token", "Nickname": "preexisting"},
        ]
    )

    result = import_ow_map(source, target)
    assert result["collisions_remapped"] == 1
    remapped = result["remapped_guids"]["bbbbbb"]
    assert remapped != "bbbbbb"

    # New OWx bag uses the remapped GUID — and lives inside mBag.
    mbag = next(o for o in target["ObjectStates"] if o.get("GUID") == MBAG_GUID)
    new_bag = next(o for o in mbag["ContainedObjects"] if o.get("Nickname") == "OWx_Dockside City")
    assert new_bag["GUID"] == remapped
    # Self-reference inside Lua was rewritten too.
    assert remapped in new_bag["ContainedObjects"][0]["LuaScript"]
    assert "bbbbbb" not in new_bag["ContainedObjects"][0]["LuaScript"]
    # SBx Description links to the remapped OWx GUID.
    abag = next(o for o in target["ObjectStates"] if o.get("GUID") == ABAG_GUID)
    sbx = next(o for o in abag["ContainedObjects"] if o.get("Nickname") == "SBx_Dockside City")
    assert sbx["Description"] == remapped


def test_import_remaps_colliding_nested_guid() -> None:
    # Collision is on a deeply nested child, not the top-level OWx bag.
    source = _save(
        [
            _wbase(),
            _owx_bag(
                "Foo",
                guid="bbbbbb",
                contained=[{"GUID": "child1", "ContainedObjects": [{"GUID": "deep11"}]}],
            ),
        ]
    )
    target = _save(
        [
            _abag(),
            _mbag(),
            {"GUID": "deep11", "Name": "Custom_Token", "Nickname": "pre"},
        ]
    )

    result = import_ow_map(source, target)
    assert result["collisions_remapped"] == 1
    remapped = result["remapped_guids"]["deep11"]
    mbag = next(o for o in target["ObjectStates"] if o.get("GUID") == MBAG_GUID)
    new_bag = next(o for o in mbag["ContainedObjects"] if o.get("Nickname") == "OWx_Foo")
    deep = new_bag["ContainedObjects"][0]["ContainedObjects"][0]
    assert deep["GUID"] == remapped


def test_import_is_idempotent() -> None:
    source = _save([_wbase(), _owx_bag("Dockside City")])
    target = _save([_abag(), _mbag()])

    import_ow_map(source, target)
    second = import_ow_map(source, target)
    assert second["status"] == "noop"

    mbag = next(o for o in target["ObjectStates"] if o.get("GUID") == MBAG_GUID)
    bags = [o for o in mbag["ContainedObjects"] if o.get("Nickname") == "OWx_Dockside City"]
    assert len(bags) == 1
    abag = next(o for o in target["ObjectStates"] if o.get("GUID") == ABAG_GUID)
    sbx_tokens = [o for o in abag["ContainedObjects"] if o.get("Nickname") == "SBx_Dockside City"]
    assert len(sbx_tokens) == 1
    # JotBase line appears exactly once.
    assert abag["LuaScript"].count(",Dockside City,") == 1


def test_import_preserves_crlf_in_abag_lua() -> None:
    source = _save([_wbase(), _owx_bag("Dockside City")])
    # Mimic a live save's CRLF line endings.
    target = _save([_abag(lua="--existing01,Existing,...\r\n"), _mbag()])

    import_ow_map(source, target)
    abag = next(o for o in target["ObjectStates"] if o.get("GUID") == ABAG_GUID)
    assert "\r\n" in abag["LuaScript"]
    assert abag["LuaScript"].endswith("\r\n")


def test_import_uses_explicit_image_when_no_wbase() -> None:
    source = _save([_owx_bag("Dockside City")])  # no wBase
    target = _save([_abag(), _mbag()])

    result = import_ow_map(source, target, sbx_image_url="https://override")
    assert result["sbx_image_url"] == "https://override"


def test_import_raises_when_no_image_available() -> None:
    source = _save([_owx_bag("Foo")])  # no wBase, no override
    target = _save([_abag(), _mbag()])
    with pytest.raises(ImportError_, match="no SBx image URL"):
        import_ow_map(source, target)


def test_import_raises_when_target_has_no_abag() -> None:
    source = _save([_wbase(), _owx_bag("Foo")])
    target = _save([_mbag()])  # no aBag
    with pytest.raises(ImportError_, match="aBag"):
        import_ow_map(source, target)


def test_import_raises_when_target_has_no_mbag() -> None:
    source = _save([_wbase(), _owx_bag("Foo")])
    target = _save([_abag()])  # no mBag
    with pytest.raises(ImportError_, match="mBag"):
        import_ow_map(source, target)


def test_import_raises_when_no_owx_bag_in_source() -> None:
    source = _save([_wbase()])  # no OWx bag
    target = _save([_abag(), _mbag()])
    with pytest.raises(ImportError_, match="no OWx"):
        import_ow_map(source, target)


def test_import_raises_when_multiple_owx_bags_and_no_guid_hint() -> None:
    source = _save(
        [
            _wbase(),
            _owx_bag("Foo", guid="111111"),
            _owx_bag("Bar", guid="222222"),
        ]
    )
    target = _save([_abag(), _mbag()])
    with pytest.raises(ImportError_, match="multiple OWx"):
        import_ow_map(source, target)


def test_import_with_explicit_owx_guid_picks_the_right_one() -> None:
    source = _save(
        [
            _wbase(),
            _owx_bag("Foo", guid="111111"),
            _owx_bag("Bar", guid="222222"),
        ]
    )
    target = _save([_abag(), _mbag()])
    result = import_ow_map(source, target, owx_guid="222222")
    assert result["map_name"] == "Bar"


def test_map_already_imported_detects_via_jotbase() -> None:
    mbag = _mbag()
    mbag["ContainedObjects"] = [
        {"Name": "Bag", "Nickname": "OWx_Dockside City", "GUID": "ccc"},
    ]
    target = _save(
        [
            _abag(lua="--xxxxxx,Dockside City,{1.85;1;1.85},...\n"),
            mbag,
        ]
    )
    assert map_already_imported(target, "Dockside City", ABAG_GUID, MBAG_GUID)
    assert not map_already_imported(target, "Other", ABAG_GUID, MBAG_GUID)


def test_import_does_not_mutate_source() -> None:
    source = _save([_wbase(), _owx_bag("Foo", guid="bbbbbb")])
    target = _save(
        [
            _abag(),
            _mbag(),
            {"GUID": "bbbbbb", "Name": "Custom_Token", "Nickname": "collider"},
        ]
    )
    before = json.dumps(source, sort_keys=True)
    import_ow_map(source, target)
    assert json.dumps(source, sort_keys=True) == before


# -----------------------------------------------------------------------------
# CLI
# -----------------------------------------------------------------------------


def test_main_writes_output(tmp_path: Path) -> None:
    source = _save([_wbase("https://water"), _owx_bag("Dockside City")])
    target = _save([_abag(), _mbag()])
    src_path = tmp_path / "src.json"
    tgt_path = tmp_path / "tgt.json"
    out_path = tmp_path / "out.json"
    src_path.write_text(json.dumps(source))
    tgt_path.write_text(json.dumps(target))

    rc = main([str(src_path), str(tgt_path), str(out_path)])
    assert rc == 0
    assert out_path.exists()
    merged = json.loads(out_path.read_text())
    mbag = next(o for o in merged["ObjectStates"] if o.get("GUID") == MBAG_GUID)
    assert any(o.get("Nickname") == "OWx_Dockside City" for o in mbag["ContainedObjects"])


def test_main_refuses_to_overwrite_target(tmp_path: Path) -> None:
    src_path = tmp_path / "src.json"
    tgt_path = tmp_path / "tgt.json"
    src_path.write_text(json.dumps(_save([_wbase(), _owx_bag("Foo")])))
    tgt_path.write_text(json.dumps(_save([_abag(), _mbag()])))
    rc = main([str(src_path), str(tgt_path), str(tgt_path)])
    assert rc == 1
