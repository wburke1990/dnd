"""Tests for tts_save: unpack/pack round-trip and combine semantics.

All tests use small synthetic saves under tmp_path — no real TTS files
are touched, no network calls, no large fixtures committed.
"""

from __future__ import annotations

import json
from pathlib import Path

from dnd_tools import tts_save


def _write_save(path: Path, data: dict[str, object]) -> None:
    path.write_text(json.dumps(data, indent=2))


def _basic_save() -> dict[str, object]:
    return {
        "SaveName": "Test",
        "LuaScript": "-- global\nprint('hi')",
        "LuaScriptState": "",
        "XmlUI": "",
        "ObjectStates": [
            {
                "GUID": "aaa111",
                "Name": "Chest",
                "Nickname": "Loot Chest",
                "LuaScript": "function onLoad() end",
                "XmlUI": "",
                "ContainedObjects": [
                    {
                        "GUID": "bbb222",
                        "Name": "Coin",
                        "Nickname": "Gold",
                        "LuaScript": "",
                        "XmlUI": "<Panel/>",
                    }
                ],
            },
            {
                "GUID": "ccc333",
                "Name": "Token",
                "LuaScript": "",
                "XmlUI": "",
            },
        ],
    }


def test_walk_objects_includes_global_and_recurses(tmp_path: Path) -> None:
    save = _basic_save()
    guids = [str(o.get("GUID")) for o in tts_save.walk_objects(save)]
    # Global pseudo-object + 3 real objects (1 top + 1 bagged + 1 top).
    assert guids == ["__global__", "aaa111", "bbb222", "ccc333"]


def test_unpack_pack_round_trip(tmp_path: Path) -> None:
    save_path = tmp_path / "save.json"
    _write_save(save_path, _basic_save())

    unpack_dir = tmp_path / "lua"
    counts = tts_save.unpack_save(save_path, unpack_dir)
    # global has Lua; aaa111 has Lua; bbb222 has XmlUI only; ccc333 has nothing.
    assert counts["lua"] == 2
    assert counts["xml"] == 1
    assert counts["objects"] == 4
    assert (unpack_dir / "__global__.lua").read_text().startswith("-- global")
    assert (unpack_dir / "aaa111.lua").read_text().startswith("function onLoad")
    assert (unpack_dir / "bbb222.xml").read_text() == "<Panel/>"
    assert (unpack_dir / "_manifest.json").exists()

    # Modify one script and pack back.
    (unpack_dir / "aaa111.lua").write_text("function onLoad() print('edited') end")
    out_path = tmp_path / "packed.json"
    tts_save.pack_save(save_path, unpack_dir, out_path)

    packed = json.loads(out_path.read_text())
    chest = packed["ObjectStates"][0]
    assert chest["GUID"] == "aaa111"
    assert chest["LuaScript"] == "function onLoad() print('edited') end"
    # Untouched script is preserved.
    assert packed["LuaScript"].startswith("-- global")
    # XmlUI on nested object preserved.
    assert chest["ContainedObjects"][0]["XmlUI"] == "<Panel/>"


def test_combine_appends_objects_and_renames_collisions(tmp_path: Path) -> None:
    base_path = tmp_path / "base.json"
    overlay_path = tmp_path / "overlay.json"
    _write_save(base_path, _basic_save())
    overlay: dict[str, object] = {
        "SaveName": "Overlay",
        "LuaScript": "",
        "ObjectStates": [
            {"GUID": "ccc333", "Name": "Colliding Token"},  # collides with base
            {"GUID": "ddd444", "Name": "New Mini"},
        ],
    }
    _write_save(overlay_path, overlay)

    out_path = tmp_path / "merged.json"
    counts = tts_save.combine_saves(base_path, overlay_path, out_path)
    assert counts["added"] == 2
    assert counts["renamed"] == 1

    merged = json.loads(out_path.read_text())
    guids = [o["GUID"] for o in merged["ObjectStates"]]
    # Original 2 top-level + 2 from overlay = 4 total.
    assert len(guids) == 4
    # ccc333 still present (the base's), the overlay's clone got a fresh GUID.
    assert guids.count("ccc333") == 1
    assert "ddd444" in guids


def test_combine_with_guid_selection(tmp_path: Path) -> None:
    base_path = tmp_path / "base.json"
    overlay_path = tmp_path / "overlay.json"
    _write_save(base_path, _basic_save())
    _write_save(
        overlay_path,
        {
            "SaveName": "Overlay",
            "ObjectStates": [
                {"GUID": "ddd444", "Name": "Wanted"},
                {"GUID": "eee555", "Name": "Skipped"},
            ],
        },
    )
    out_path = tmp_path / "merged.json"
    counts = tts_save.combine_saves(base_path, overlay_path, out_path, select_guids={"ddd444"})
    assert counts["added"] == 1
    merged = json.loads(out_path.read_text())
    guids = [o["GUID"] for o in merged["ObjectStates"]]
    assert "ddd444" in guids
    assert "eee555" not in guids
