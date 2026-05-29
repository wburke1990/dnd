"""Smoke test for the `tts` CLI entry point.

The `dnd` CLI is exercised end-to-end in test_campaign_db.py.
"""

from __future__ import annotations

from click.testing import CliRunner

from dnd_tools.tts_cli import main as tts_main


def test_tts_ping() -> None:
    result = CliRunner().invoke(tts_main, ["ping"])
    assert result.exit_code == 0
    assert result.output.strip() == "pong"
