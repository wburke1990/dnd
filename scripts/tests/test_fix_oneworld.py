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
    HUB_GUID,
    ORPHAN_STUBS,
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
            {"GUID": ORPHAN_STUBS[0]["guid"], "Name": "Custom_Token"},
        ],
    }
    added, skipped = inject_stubs(abag, ORPHAN_STUBS)
    assert skipped == 1
    assert added == len(ORPHAN_STUBS) - 1
    # All declared orphan GUIDs should now be present.
    guids = {o["GUID"] for o in abag["ContainedObjects"]}
    for s in ORPHAN_STUBS:
        assert s["guid"] in guids


def test_inject_stubs_idempotent() -> None:
    abag: dict[str, Any] = {"GUID": "abc123", "ContainedObjects": []}
    added1, _ = inject_stubs(abag, ORPHAN_STUBS)
    assert added1 == len(ORPHAN_STUBS)
    added2, skipped2 = inject_stubs(abag, ORPHAN_STUBS)
    assert added2 == 0
    assert skipped2 == len(ORPHAN_STUBS)


def test_find_object_nested() -> None:
    states = [
        {"GUID": "111", "ContainedObjects": [{"GUID": "222"}]},
    ]
    assert find_object(states, "222") == {"GUID": "222"}
    assert find_object(states, "999") is None


def test_patch_save_end_to_end(tmp_path: Path) -> None:
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
                "ContainedObjects": [],
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
    assert len(abag["ContainedObjects"]) == len(ORPHAN_STUBS)
