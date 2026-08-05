"""Provide a Lua >= 5.2 interpreter for the real-script test harness.

`tests/lua/real_reset_runtime.lua` loads the actual TTS object scripts, whose
nested long-bracket comments require Lua 5.2+ semantics -- the version Tabletop
Simulator itself runs. Most dev machines already have such an interpreter (for
example Homebrew's ``lua``); some container images ship only Lua 5.1, which
rejects that syntax at parse time.

Rather than skip the check on those images, `ensure_lua` builds Lua 5.4 once and
caches it. The source is the ``lupa`` sdist on PyPI -- the only package registry
reachable under the sandbox's network policy -- which vendors the pristine Lua
5.4 C sources, including the standalone interpreter (``lua.c``). The sdist is
pinned by content-addressed URL and SHA-256, extracted and compiled in a
throwaway temp dir, and only the finished binary is kept, under a gitignored
cache dir.
"""

from __future__ import annotations

import hashlib
import re
import shutil
import subprocess
import tarfile
import tempfile
from pathlib import Path

MIN_VERSION = (5, 2)

# Pinned lupa source distribution: content-addressed URL + SHA-256. lupa vendors
# the pristine Lua 5.4 C sources (third-party/lua54), including lua.c. To move to
# a newer Lua, bump the URL, the checksum, and _LUA_SUBDIR together.
_LUPA_URL = (
    "https://files.pythonhosted.org/packages/c3/a6/"
    "0f869fbb07c393f15473b1eefefb7b5bec162fb7481803d040ed4dc46002/lupa-2.8.tar.gz"
)
_LUPA_SHA256 = "d8022641b9ec8ecf2c5ecbe9f47e5a70e0b87c4b5ae921b92cb02a638e0acd08"
_LUA_SUBDIR = "lupa-2.8/third-party/lua54"
# lua.c is the interpreter's main. onelua.c is an amalgam that redefines main and
# luaL_openlibs; ltests.c is Lua's internal test hook. Compile everything else.
_EXCLUDE_C = {"onelua.c", "ltests.c"}

_CACHE_DIR = Path(__file__).resolve().parents[1] / ".lua-build"
_CACHED_BIN = _CACHE_DIR / "lua"


def _version_of(binary: str) -> tuple[int, int] | None:
    try:
        proc = subprocess.run([binary, "-v"], capture_output=True, text=True, timeout=10)
    except (OSError, subprocess.SubprocessError):
        return None
    match = re.search(r"\bLua (\d+)\.(\d+)", proc.stdout + proc.stderr)
    if match is None:
        return None
    return (int(match.group(1)), int(match.group(2)))


def _find_installed() -> str | None:
    for name in ("lua", "lua5.4", "lua5.3", "lua5.2", "lua54", "lua53", "lua52"):
        found = shutil.which(name)
        if found is None:
            continue
        version = _version_of(found)
        if version is not None and version >= MIN_VERSION:
            return found
    return None


def _c_compiler() -> str | None:
    for name in ("cc", "gcc", "clang"):
        found = shutil.which(name)
        if found is not None:
            return found
    return None


def _download(dest: Path) -> bool:
    if shutil.which("curl") is None:
        return False
    result = subprocess.run(
        ["curl", "-sSL", "--retry", "3", "-o", str(dest), _LUPA_URL],
        capture_output=True,
        text=True,
        timeout=180,
    )
    if result.returncode != 0 or not dest.exists():
        return False
    return hashlib.sha256(dest.read_bytes()).hexdigest() == _LUPA_SHA256


def _build() -> str | None:
    compiler = _c_compiler()
    if compiler is None:
        return None
    with tempfile.TemporaryDirectory(prefix="dnd-lua-") as tmp:
        work = Path(tmp)
        tarball = work / "lupa.tar.gz"
        if not _download(tarball):
            return None
        with tarfile.open(tarball) as archive:
            archive.extractall(work, filter="data")
        lua_src = work / _LUA_SUBDIR
        sources = sorted(str(path) for path in lua_src.glob("*.c") if path.name not in _EXCLUDE_C)
        if not sources:
            return None
        _CACHE_DIR.mkdir(parents=True, exist_ok=True)
        proc = subprocess.run(
            [compiler, "-O2", "-DLUA_USE_POSIX", "-o", str(_CACHED_BIN), *sources, "-lm"],
            capture_output=True,
            text=True,
            timeout=300,
        )
    if proc.returncode != 0 or not _CACHED_BIN.exists():
        return None
    version = _version_of(str(_CACHED_BIN))
    if version is None or version < MIN_VERSION:
        return None
    return str(_CACHED_BIN)


def ensure_lua() -> str | None:
    """Return the path to a Lua >= 5.2 interpreter, building one if needed.

    Returns None only when no suitable interpreter is installed and none can be
    built (no C compiler, or the pinned source cannot be fetched); the caller
    then skips the real-script test.
    """
    installed = _find_installed()
    if installed is not None:
        return installed
    if _CACHED_BIN.exists():
        version = _version_of(str(_CACHED_BIN))
        if version is not None and version >= MIN_VERSION:
            return str(_CACHED_BIN)
    return _build()
