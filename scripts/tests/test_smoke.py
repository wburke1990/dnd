"""Smoke tests proving the CLI entry points are wired up.

TTS-save logic is covered in test_tts_save.py and test_tts_assets.py.
This file just confirms `--help` works for each top-level CLI.
"""

from __future__ import annotations

from click.testing import CliRunner

from dnd_tools.tts_cli import main as tts_main


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
