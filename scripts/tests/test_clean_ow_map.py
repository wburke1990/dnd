"""Tests for the OneWorld map remover / dead-asset pruner."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools.clean_ow_map import (
    CleanError,
    collect_map_urls,
    iter_own_assets,
    main,
    plan_prune,
    prune_dead_assets,
    prune_map,
    remove_ow_map,
)
from dnd_tools.fix_oneworld import ABAG_GUID, find_object
from dnd_tools.import_ow_map import MBAG_GUID

DEAD_MESH = "https://dead.example/mesh404"
DEAD_TEX = "https://dead.example/tex404"
LIVE_MESH = "https://live.example/mesh"
LIVE_TEX = "https://live.example/tex"


def _model(guid: str, mesh: str, diffuse: str, collider: str = "") -> dict[str, Any]:
    """A Custom_Model piece — asset URLs live under CustomMesh, as in TTS."""
    return {
        "Name": "Custom_Model",
        "GUID": guid,
        "Transform": {"posX": 1.0, "posY": 0.0, "posZ": 2.0},
        "CustomMesh": {
            "MeshURL": mesh,
            "DiffuseURL": diffuse,
            "ColliderURL": collider,
            "NormalURL": "",
        },
    }


def _manifest(*guids: str) -> str:
    return "".join(f"--{g},1,0,2,0,0,0,1\n" for g in guids)


def _sbx(owx_guid: str, name: str, manifest: str) -> dict[str, Any]:
    return {
        "Name": "Custom_Token",
        "Nickname": f"SBx_{name}",
        "GUID": "5b0001",
        "Description": owx_guid,
        "LuaScript": manifest,
        "CustomImage": {"ImageURL": "https://live.example/floor.jpg"},
    }


def _owx(name: str, guid: str, pieces: list[dict[str, Any]]) -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": f"OWx_{name}",
        "GUID": guid,
        "Description": "",
        "ContainedObjects": pieces,
    }


def _abag(lua: str = "", contained: list[dict[str, Any]] | None = None) -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": "aBag",
        "GUID": ABAG_GUID,
        "Description": "_OW_aBaG_xxxxxx",
        "LuaScript": lua,
        "ContainedObjects": contained or [],
    }


def _mbag(contained: list[dict[str, Any]] | None = None) -> dict[str, Any]:
    return {
        "Name": "Bag",
        "Nickname": "Tra",
        "GUID": MBAG_GUID,
        "Description": "_OW_mBaG",
        "LuaScript": "",
        "ContainedObjects": contained or [],
    }


def _save(states: list[dict[str, Any]]) -> dict[str, Any]:
    return {"SaveName": "t", "ObjectStates": states}


def _get(save: dict[str, Any], guid: str) -> dict[str, Any]:
    """find_object that asserts a hit — keeps the strict type checker happy."""
    obj = find_object(save["ObjectStates"], guid)
    assert obj is not None
    return obj


def _fixture() -> dict[str, Any]:
    """A save with one map 'Cliffs' (owx c00001): a live piece, a dead-mesh
    piece, and a live-mesh-but-dead-texture piece."""
    pieces = [
        _model("aa0001", LIVE_MESH, LIVE_TEX),  # fully alive — untouched
        _model("bb0002", DEAD_MESH, LIVE_TEX),  # dead mesh — remove
        _model("cc0003", LIVE_MESH, DEAD_TEX),  # dead texture only — blank
    ]
    owx = _owx("Cliffs", "c00001", pieces)
    sbx = _sbx("c00001", "Cliffs", _manifest("aa0001", "bb0002", "cc0003"))
    abag = _abag(lua="--5b0001,Cliffs,{1.85;1;1.85},{25.00;1;25.00},0,0,2,0,\n", contained=[sbx])
    mbag = _mbag(contained=[owx])
    return _save([abag, mbag])


# ---------------------------------------------------------------------------
# Walkers
# ---------------------------------------------------------------------------
def test_iter_own_assets_finds_nested_and_stops_at_contained() -> None:
    piece = _model("p1", LIVE_MESH, DEAD_TEX)
    piece["ContainedObjects"] = [_model("child", DEAD_MESH, DEAD_MESH)]
    urls = {url for _c, _f, url in iter_own_assets(piece)}
    # own CustomMesh urls present; the contained child's are NOT attributed here
    assert LIVE_MESH in urls
    assert DEAD_TEX in urls
    assert DEAD_MESH not in urls


def test_collect_map_urls_maps_url_to_object_and_field() -> None:
    bag = _owx("M", "c1", [_model("p1", LIVE_MESH, DEAD_TEX)])
    urls = collect_map_urls(bag)
    assert urls[DEAD_TEX] == [("p1", "DiffuseURL")]
    assert ("p1", "MeshURL") in urls[LIVE_MESH]


# ---------------------------------------------------------------------------
# plan_prune categorization
# ---------------------------------------------------------------------------
def test_plan_prune_splits_dead_mesh_from_dead_texture() -> None:
    bag = _fixture()["ObjectStates"][1]["ContainedObjects"][0]
    remove, blanks = plan_prune(bag, {DEAD_MESH, DEAD_TEX})
    assert remove == {"bb0002"}
    # only the dead-texture piece's DiffuseURL is blanked
    assert len(blanks) == 1
    container, field = blanks[0]
    assert field == "DiffuseURL"
    assert container["DiffuseURL"] == DEAD_TEX  # not yet mutated by plan


def test_plan_prune_dead_mesh_piece_is_not_also_blanked() -> None:
    # a piece with BOTH dead mesh and dead texture -> removed, not blanked
    bag = _owx("M", "c1", [_model("p1", DEAD_MESH, DEAD_TEX)])
    remove, blanks = plan_prune(bag, {DEAD_MESH, DEAD_TEX})
    assert remove == {"p1"}
    assert blanks == []


# ---------------------------------------------------------------------------
# prune_dead_assets application
# ---------------------------------------------------------------------------
def test_prune_removes_dead_mesh_blanks_texture_and_strips_manifest() -> None:
    save = _fixture()
    result = prune_dead_assets(save, "c00001", {DEAD_MESH, DEAD_TEX})
    assert result["objects_removed"] == 1
    assert result["fields_blanked"] == 1
    assert result["manifest_lines_stripped"] == 1

    owx = _get(save, "c00001")
    guids = [p["GUID"] for p in owx["ContainedObjects"]]
    assert guids == ["aa0001", "cc0003"]  # dead-mesh bb0002 gone
    # cc0003 kept but its dead texture blanked
    p3 = next(p for p in owx["ContainedObjects"] if p["GUID"] == "cc0003")
    assert p3["CustomMesh"]["DiffuseURL"] == ""
    # aa0001 untouched
    p1 = next(p for p in owx["ContainedObjects"] if p["GUID"] == "aa0001")
    assert p1["CustomMesh"]["DiffuseURL"] == LIVE_TEX

    sbx = _get(save, "5b0001")
    assert "bb0002" not in sbx["LuaScript"]
    assert "aa0001" in sbx["LuaScript"] and "cc0003" in sbx["LuaScript"]


def test_prune_no_dead_urls_is_noop() -> None:
    save = _fixture()
    result = prune_dead_assets(save, "c00001", set())
    assert result["status"] == "noop"


def test_prune_missing_bag_raises() -> None:
    with pytest.raises(CleanError):
        prune_dead_assets(_fixture(), "nope99", {DEAD_MESH})


def test_prune_map_probes_then_prunes() -> None:
    save = _fixture()

    def fake_probe(urls: list[str]) -> set[str]:
        return {u for u in urls if u in {DEAD_MESH, DEAD_TEX}}

    result = prune_map(save, "c00001", probe=fake_probe)
    assert result["objects_removed"] == 1
    assert result["fields_blanked"] == 1
    assert result["urls_probed"] >= 2


# ---------------------------------------------------------------------------
# remove_ow_map
# ---------------------------------------------------------------------------
def test_remove_by_owx_guid_deletes_all_three_pieces() -> None:
    save = _fixture()
    result = remove_ow_map(save, owx_guid="c00001")
    assert result["status"] == "removed"
    assert result["map_name"] == "Cliffs"
    assert result["owx_bags_removed"] == 1
    assert result["sbx_tokens_removed"] == 1
    assert result["jotbase_lines_removed"] == 1
    assert find_object(save["ObjectStates"], "c00001") is None
    assert find_object(save["ObjectStates"], "5b0001") is None
    abag = _get(save, ABAG_GUID)
    assert "Cliffs" not in abag["LuaScript"]


def test_remove_by_sbx_guid() -> None:
    save = _fixture()
    result = remove_ow_map(save, sbx_guid="5b0001")
    assert result["status"] == "removed"
    assert result["owx_guid"] == "c00001"
    assert find_object(save["ObjectStates"], "c00001") is None


def test_remove_is_idempotent() -> None:
    save = _fixture()
    remove_ow_map(save, owx_guid="c00001")
    again = remove_ow_map(save, owx_guid="c00001")
    assert again["status"] == "noop"


def test_remove_requires_a_guid() -> None:
    with pytest.raises(CleanError):
        remove_ow_map(_fixture())


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
def test_cli_remove_writes_output(tmp_path: Path) -> None:
    src = tmp_path / "in.json"
    out = tmp_path / "out.json"
    src.write_text(json.dumps(_fixture()))
    rc = main(["remove", str(src), str(out), "--owx-guid", "c00001"])
    assert rc == 0
    written = json.loads(out.read_text())
    assert find_object(written["ObjectStates"], "c00001") is None


def test_cli_prune_with_explicit_dead_urls(tmp_path: Path) -> None:
    src = tmp_path / "in.json"
    out = tmp_path / "out.json"
    src.write_text(json.dumps(_fixture()))
    rc = main(["prune", str(src), str(out), "--owx-guid", "c00001", "--dead-url", DEAD_MESH])
    assert rc == 0
    written = json.loads(out.read_text())
    owx = _get(written, "c00001")
    assert [p["GUID"] for p in owx["ContainedObjects"]] == ["aa0001", "cc0003"]


def test_cli_refuses_in_place_overwrite(tmp_path: Path) -> None:
    src = tmp_path / "in.json"
    src.write_text(json.dumps(_fixture()))
    rc = main(["remove", str(src), str(src), "--owx-guid", "c00001"])
    assert rc == 1
