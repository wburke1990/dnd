"""Smoke tests proving the CLI entry points are wired up.

End-to-end coverage of `dnd` lives in test_campaign_db.py;
TTS-save logic in test_tts_save.py and test_tts_assets.py.
This file just confirms `--help` works for each top-level CLI.
"""

from __future__ import annotations

from click.testing import CliRunner

from dnd_tools.dnd_cli import main as dnd_main
from dnd_tools.tts_cli import main as tts_main


def test_dnd_help() -> None:
    result = CliRunner().invoke(dnd_main, ["--help"])
    assert result.exit_code == 0
    assert "Query and edit the dnd campaign database" in result.output


def test_tts_help() -> None:
    result = CliRunner().invoke(tts_main, ["--help"])
    assert result.exit_code == 0
    assert "Tabletop Simulator" in result.output


def test_tts_list_subcommands() -> None:
    """Confirm every Phase 3 top-level subcommand registered."""
    result = CliRunner().invoke(tts_main, ["--help"])
    assert result.exit_code == 0
    for name in ("pull-saves", "unpack", "pack", "combine", "list", "assets"):
        assert name in result.output


def test_dnd_list_subcommands() -> None:
    result = CliRunner().invoke(dnd_main, ["--help"])
    assert result.exit_code == 0
    for name in ("npc", "pc", "location", "faction", "item", "session", "search", "add", "link"):
        assert name in result.output
