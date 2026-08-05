"""Runs the Lua initiative-tracker harness against the real injector script.

The harness (`tests/lua/init_tracker_harness.lua`) loads the actual
`tts/lua/TS_Save_19/f211ac.lua` with the Tabletop Simulator API mocked and
drives three consecutive combats, asserting that typed initiatives override a
mini's own roll, that the value/mod/name sort is correct, and that Reset clears
every override so minis re-roll next fight. This test just shells out to `lua`
and fails if the harness reports any failed check. Skipped when no Lua
interpreter is installed (e.g. a bare local Mac).
"""

from __future__ import annotations

import shutil
import subprocess
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parents[2]
HARNESS = REPO_ROOT / "scripts" / "tests" / "lua" / "init_tracker_harness.lua"
REAL_HARNESS = REPO_ROOT / "scripts" / "tests" / "lua" / "real_reset_runtime.lua"
FIXTURES = REPO_ROOT / "scripts" / "tests" / "lua" / "fixtures"
INJECTOR = REPO_ROOT / "tts" / "lua" / "TS_Save_19" / "f211ac.lua"


def _lua_binary() -> str | None:
    for name in ("lua", "lua5.4", "lua5.3", "luajit"):
        found = shutil.which(name)
        if found:
            return found
    return None


def test_initiative_tracker_three_combats() -> None:
    lua = _lua_binary()
    if lua is None:
        pytest.skip("no lua interpreter installed")
    if not INJECTOR.exists():
        pytest.skip(f"injector script not present: {INJECTOR}")

    result = subprocess.run(
        [lua, str(HARNESS), str(INJECTOR)],
        capture_output=True,
        text=True,
        timeout=30,
    )
    combined = result.stdout + result.stderr
    assert result.returncode == 0, f"harness failed:\n{combined}"
    assert "ALL CHECKS PASSED" in result.stdout, combined


def test_real_reset_against_real_scripts() -> None:
    """Run the real injector reset against the real mini scripts + saved state.

    Unlike the mock harness, this loads the actual DNDMiniInjector_Mini scripts
    (fixtures pulled from the save) so the minis' own reset runs for real -- it
    catches script-logic regressions the mocks would miss.
    """
    lua = _lua_binary()
    if lua is None:
        pytest.skip("no lua interpreter installed")
    if not INJECTOR.exists():
        pytest.skip(f"injector script not present: {INJECTOR}")

    result = subprocess.run(
        [lua, str(REAL_HARNESS), str(INJECTOR), str(FIXTURES)],
        capture_output=True,
        text=True,
        timeout=30,
    )
    combined = result.stdout + result.stderr
    if result.returncode != 0 and "nesting of [[...]] is deprecated" in combined:
        pytest.skip(
            "interpreter is Lua 5.1, which rejects the TTS scripts' nested "
            "long-bracket syntax; the real scripts run under Lua 5.2+ (as TTS "
            "does), so this real-script harness only runs on a 5.2+ interpreter"
        )
    assert result.returncode == 0, f"real-script harness failed:\n{combined}"
    assert "ALL CHECKS PASSED" in result.stdout, combined
