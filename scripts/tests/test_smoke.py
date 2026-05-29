"""Smoke tests proving the CLI entry points are wired up."""

from __future__ import annotations

from click.testing import CliRunner

from dnd_tools.dnd_cli import main as dnd_main
from dnd_tools.tts_cli import main as tts_main


def test_dnd_ping() -> None:
    result = CliRunner().invoke(dnd_main, ["ping"])
    assert result.exit_code == 0
    assert result.output.strip() == "pong"


def test_tts_ping() -> None:
    result = CliRunner().invoke(tts_main, ["ping"])
    assert result.exit_code == 0
    assert result.output.strip() == "pong"
