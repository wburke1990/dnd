"""Tests for calibrating table minis to the grid."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools import calibrate_minis

MINI_SCRIPT = 'className = "DNDMiniInjector_Mini"\nfunction onLoad() end\n'
INJECTOR_SCRIPT = 'className = "DNDMiniInjector_Mini"\nclassName = "MiniInjector"\n'


def _obj(guid: str, script: str, *, scale: float = 0.5, state: str = "") -> dict[str, Any]:
    return {
        "GUID": guid,
        "Name": "Figurine_Custom",
        "Nickname": guid,
        "LuaScript": script,
        "LuaScriptState": state,
        "Transform": {"scaleX": scale, "scaleY": scale * 2, "scaleZ": scale},
    }


def _save(*objs: dict[str, Any]) -> dict[str, Any]:
    return {"Grid": {"xSize": 2.0, "ySize": 3.0}, "ObjectStates": list(objs)}


def _state(obj: dict[str, Any]) -> dict[str, Any]:
    result: dict[str, Any] = json.loads(obj["LuaScriptState"])
    return result


def test_calibrates_mini_against_grid_width() -> None:
    save = _save(_obj("aaa", MINI_SCRIPT, scale=0.5))
    calibrate_minis.calibrate_minis(save)
    state = _state(save["ObjectStates"][0])
    assert state["calibrated_once"] is True
    assert state["scale_multiplier_x"] == pytest.approx(0.25)
    assert state["scale_multiplier_y"] == pytest.approx(0.5)
    assert state["scale_multiplier_z"] == pytest.approx(0.25)


def test_keeps_other_state_fields() -> None:
    old = json.dumps({"health": {"value": 3, "max": 10}, "saveVersion": 7})
    save = _save(_obj("aaa", MINI_SCRIPT, state=old))
    calibrate_minis.calibrate_minis(save)
    state = _state(save["ObjectStates"][0])
    assert state["health"] == {"value": 3, "max": 10}
    assert state["saveVersion"] == 7


def test_skips_injector_and_plain_objects() -> None:
    save = _save(_obj("inj", INJECTOR_SCRIPT), _obj("box", "print(1)"))
    result = calibrate_minis.calibrate_minis(save)
    assert result["changed"] == []
    assert all(o["LuaScriptState"] == "" for o in save["ObjectStates"])


def test_leaves_calibrated_mini_unless_recalibrate() -> None:
    old = json.dumps({"calibrated_once": True, "scale_multiplier_x": 9.0})
    save = _save(_obj("aaa", MINI_SCRIPT, state=old))
    calibrate_minis.calibrate_minis(save)
    assert _state(save["ObjectStates"][0])["scale_multiplier_x"] == 9.0
    calibrate_minis.calibrate_minis(save, recalibrate=True)
    assert _state(save["ObjectStates"][0])["scale_multiplier_x"] == pytest.approx(0.25)


def test_ignores_minis_in_bags() -> None:
    inner = _obj("aaa", MINI_SCRIPT)
    save = _save({"GUID": "bag", "Name": "Bag", "ContainedObjects": [inner]})
    calibrate_minis.calibrate_minis(save)
    assert inner["LuaScriptState"] == ""


def test_main_writes_output_and_refuses_in_place(tmp_path: Path) -> None:
    src = tmp_path / "in.json"
    out = tmp_path / "out.json"
    src.write_text(json.dumps(_save(_obj("aaa", MINI_SCRIPT))))
    assert calibrate_minis.main([str(src), str(src)]) == 1
    assert calibrate_minis.main([str(src), str(out)]) == 0
    written = json.loads(out.read_text())
    assert _state(written["ObjectStates"][0])["calibrated_once"] is True
