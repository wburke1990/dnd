"""Tests for the OneWorld save patcher."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import pytest

from dnd_tools.fix_oneworld import (
    ABAG_GUID,
    BUTTON_HOME_NEW,
    BUTTON_HOME_OLD,
    DEFAULT_SELECTED_SBX,
    HUB_GUID,
    ORPHAN_DELETE_GUIDS,
    ORPHAN_STUBS_KEEP,
    WBASE_GUID,
    delete_contained,
    delete_jotbase_lines,
    ensure_wbase_default,
    find_object,
    inject_stubs,
    patch_button_home,
    patch_save,
    stub_sbx,
)


def test_patch_button_home_idempotent() -> None:
    lua = f"prefix\n{BUTTON_HOME_OLD}\nsuffix"
    once, changed1 = patch_button_home(lua)
    assert changed1
    assert BUTTON_HOME_NEW in once
    assert BUTTON_HOME_OLD not in once

    twice, changed2 = patch_button_home(once)
    assert not changed2
    assert twice == once


def test_patch_button_home_preserves_crlf() -> None:
    """Live TTS saves use CRLF inside Lua strings; the output should match."""
    crlf_old = BUTTON_HOME_OLD.replace("\n", "\r\n")
    lua = f"prefix\r\n{crlf_old}\r\nsuffix"
    out, changed = patch_button_home(lua)
    assert changed
    assert "\r\n" in out
    assert BUTTON_HOME_NEW.replace("\n", "\r\n") in out


def test_patch_button_home_missing_block_raises() -> None:
    with pytest.raises(RuntimeError, match="not found"):
        patch_button_home("function ButtonHome() end")


def test_stub_sbx_minimum_fields() -> None:
    s = stub_sbx("abcdef", "Test Map", "https://example.com/img.png")
    assert s["GUID"] == "abcdef"
    assert s["Nickname"] == "SBx_Test Map"
    assert s["Name"] == "Custom_Token"
    assert s["CustomImage"]["ImageURL"] == "https://example.com/img.png"


def test_inject_stubs_skips_existing() -> None:
    abag: dict[str, Any] = {
        "GUID": "abc123",
        "ContainedObjects": [
            {"GUID": ORPHAN_STUBS_KEEP[0]["guid"], "Name": "Custom_Token"},
        ],
    }
    added, skipped = inject_stubs(abag, ORPHAN_STUBS_KEEP)
    assert skipped == 1
    assert added == len(ORPHAN_STUBS_KEEP) - 1
    # All declared orphan GUIDs should now be present.
    guids = {o["GUID"] for o in abag["ContainedObjects"]}
    for s in ORPHAN_STUBS_KEEP:
        assert s["guid"] in guids


def test_inject_stubs_idempotent() -> None:
    abag: dict[str, Any] = {"GUID": "abc123", "ContainedObjects": []}
    added1, _ = inject_stubs(abag, ORPHAN_STUBS_KEEP)
    assert added1 == len(ORPHAN_STUBS_KEEP)
    added2, skipped2 = inject_stubs(abag, ORPHAN_STUBS_KEEP)
    assert added2 == 0
    assert skipped2 == len(ORPHAN_STUBS_KEEP)


def test_find_object_nested() -> None:
    states = [
        {"GUID": "111", "ContainedObjects": [{"GUID": "222"}]},
    ]
    assert find_object(states, "222") == {"GUID": "222"}
    assert find_object(states, "999") is None


def test_delete_jotbase_lines_removes_target_guids() -> None:
    jotbase = (
        "--d8b5f5,Base,scale,size,0,0,0,1,\n"
        "--811bc1,Wizards_Tower,scale,size,0,0,0,1,\n"
        "--d8b5f5,Base,scale,size,0,0,0,1,\n"  # duplicate
        "--01d3f9,Tomb_1,scale,size,0,0,0,1,\n"
    )
    out, removed = delete_jotbase_lines(jotbase, frozenset({"d8b5f5"}))
    assert removed == 2
    assert "Wizards_Tower" in out
    assert "Tomb_1" in out
    assert "Base" not in out


def test_delete_jotbase_lines_preserves_crlf() -> None:
    jotbase = "--d8b5f5,Base,a,b,0,0,0,1,\r\n--811bc1,Wizards_Tower,a,b,0,0,0,1,\r\n"
    out, removed = delete_jotbase_lines(jotbase, frozenset({"d8b5f5"}))
    assert removed == 1
    assert "\r\n" in out
    assert "Wizards_Tower" in out


def test_delete_jotbase_lines_empty_set_is_noop() -> None:
    text = "--d8b5f5,Base,a,b,0,0,0,1,\n"
    out, removed = delete_jotbase_lines(text, frozenset())
    assert removed == 0
    assert out == text


def test_ensure_wbase_default_seeds_empty() -> None:
    wbase: dict[str, Any] = {"Description": ""}
    changed = ensure_wbase_default(wbase, "abcdef")
    assert changed
    assert wbase["Description"] == "abcdef"


def test_ensure_wbase_default_preserves_existing() -> None:
    wbase: dict[str, Any] = {"Description": "feedfa"}
    changed = ensure_wbase_default(wbase, "abcdef")
    assert not changed
    assert wbase["Description"] == "feedfa"


def test_delete_contained_filters_by_guid() -> None:
    abag: dict[str, Any] = {
        "ContainedObjects": [
            {"GUID": "d8b5f5"},
            {"GUID": "811bc1"},
            {"GUID": "d8b5f5"},
        ],
    }
    removed = delete_contained(abag, frozenset({"d8b5f5"}))
    assert removed == 2
    assert abag["ContainedObjects"] == [{"GUID": "811bc1"}]


def test_patch_save_end_to_end(tmp_path: Path) -> None:
    jotbase_lua = (
        "".join(f"--{guid},DeadMap,a,b,0,0,0,1,\n" for guid in ORPHAN_DELETE_GUIDS)
        + "--811bc1,Wizards_Tower,a,b,0,0,0,1,\n"
    )
    save = {
        "SaveName": "MyTest",
        "ObjectStates": [
            {
                "GUID": HUB_GUID,
                "Name": "Custom_Token",
                "LuaScript": f"-- header\n{BUTTON_HOME_OLD}\n-- tail",
            },
            {
                "GUID": ABAG_GUID,
                "Name": "Custom_Model_Bag",
                "LuaScript": jotbase_lua,
                "ContainedObjects": [
                    # Pre-existing stub that should be deleted by the run.
                    {"GUID": "d8b5f5", "Name": "Custom_Token"},
                ],
            },
            {
                "GUID": WBASE_GUID,
                "Name": "Custom_Token",
                "Description": "",
            },
        ],
    }
    in_path = tmp_path / "in.json"
    out_path = tmp_path / "out.json"
    in_path.write_text(json.dumps(save))

    patch_save(in_path, out_path)

    written = json.loads(out_path.read_text())
    assert written["SaveName"] == "MyTest_fixed"
    hub = next(o for o in written["ObjectStates"] if o["GUID"] == HUB_GUID)
    assert BUTTON_HOME_NEW in hub["LuaScript"]
    abag = next(o for o in written["ObjectStates"] if o["GUID"] == ABAG_GUID)
    # Stale stub deleted, KEEP stubs added.
    guids = {o["GUID"] for o in abag["ContainedObjects"]}
    assert "d8b5f5" not in guids
    for s in ORPHAN_STUBS_KEEP:
        assert s["guid"] in guids
    # JotBase lines for deleted GUIDs are gone; Wizards_Tower stays.
    assert "Wizards_Tower" in abag["LuaScript"]
    for guid in ORPHAN_DELETE_GUIDS:
        assert f"--{guid}," not in abag["LuaScript"]
    # wBase seeded so ContinueUnit's `aBase.getGUID()` won't nil-deref.
    wbase = next(o for o in written["ObjectStates"] if o["GUID"] == WBASE_GUID)
    assert wbase["Description"] == DEFAULT_SELECTED_SBX
