#!/usr/bin/env bash
# SessionStart hook — runs once per Claude session.
#
# Always: wires up core.hooksPath so the project's pre-commit hook fires, and
# fast-forwards local `main` to origin so a session that starts behind another
# device's pushes doesn't work off stale files (this repo is driven from several
# machines).
#
# Cloud sessions only: also installs the system binaries the pre-commit hook
# expects (gitleaks for secret scanning, shellcheck for hook linting, luacheck
# for TTS Lua linting) and pre-warms the uv venv. On local machines, install
# these yourself — `brew install gitleaks shellcheck luarocks && luarocks
# install luacheck`.
#
# Idempotent: skips installs that have already succeeded in this container.
# Tolerant of failure at the *session* level — a failed install warns and lets
# the session start. But gitleaks is required at *commit* time, so if its
# install fails here, commits will be refused until it is fixed rather than
# proceeding unscanned. That is deliberate.

set -u

# Always-on: hook path wiring. Cheap and required for commits to be guarded.
git config core.hooksPath .githooks 2>/dev/null || true

# Always-on: author identity. Commits here should credit the repo owner on
# GitHub (the contribution graph keys off the author email), with Claude kept
# as a Co-Authored-By trailer in the message. Set locally (this repo only) on
# every device so a fresh clone/new machine doesn't fall back to a hostname
# default like "wcb@host.lan" (which credits nobody) or to "Claude
# <noreply@anthropic.com>" (which credits nobody either). Only credits the
# graph if this email is a verified address on the owner's GitHub account.
git config user.name "William Burke" 2>/dev/null || true
git config user.email "williamconroyburke@gmail.com" 2>/dev/null || true

# Always-on: fast-forward main to origin so a session starting behind another
# device's pushes doesn't read stale files. Safe by construction:
#   - only when on `main` (this repo is main-only; never touch a feature branch)
#   - only a fast-forward — never creates a merge commit; a diverged or offline
#     checkout just no-ops, and the normal fetch/rebase push path handles it.
# The http low-speed guard caps a stalled fetch so an unreachable origin can't
# hang session startup.
if [[ "$(git symbolic-ref --short HEAD 2>/dev/null)" == "main" ]]; then
    if git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=10 \
        fetch --quiet origin main 2>/dev/null; then
        git merge --ff-only --quiet origin/main 2>/dev/null \
            || echo "session-start: local main has diverged from origin; not fast-forwarding (continuing)" >&2
    fi
fi

# Skip the rest on local machines — apt-get and the Linux gitleaks tarball
# won't work outside the cloud sandbox.
if [[ "${CLAUDE_CODE_REMOTE:-}" != "true" ]]; then
    exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Pinned to the version installed on the owner's Mac, so both machines run the
# same scanner and the same rule set. Checksums are the official ones published
# with the release (gitleaks_<ver>_checksums.txt); update both together when
# bumping the version, and take the new values from that file, not from the
# downloaded artifact — a hash computed from what you just downloaded proves
# nothing.
GITLEAKS_VERSION="8.30.1"
GITLEAKS_SHA256_x64="551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb"
GITLEAKS_SHA256_arm64="e4a487ee7ccd7d3a7f7ec08657610aa3606637dab924210b3aee62570fb4b080"

# Downloads the release tarball and verifies it against the pinned checksum
# before anything from it is executed. A version pin alone only asserts which
# artifact was requested; it says nothing about what the endpoint actually
# served. This binary gates every commit (the pre-commit hook refuses to run
# without it), so it is worth verifying rather than trusting.
install_gitleaks() {
    if command -v gitleaks >/dev/null 2>&1; then
        return 0
    fi

    local arch expected
    case "$(uname -m)" in
        x86_64 | amd64) arch="x64" expected="$GITLEAKS_SHA256_x64" ;;
        aarch64 | arm64) arch="arm64" expected="$GITLEAKS_SHA256_arm64" ;;
        *)
            echo "session-start: unsupported arch $(uname -m) for gitleaks" >&2
            return 1
            ;;
    esac

    local tarball=/tmp/gitleaks.tgz
    if ! curl -sfL --max-time 30 \
        "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_${arch}.tar.gz" \
        -o "$tarball"; then
        rm -f "$tarball"
        return 1
    fi

    local actual
    actual="$(sha256sum "$tarball" 2>/dev/null | cut -d' ' -f1)"
    if [[ -z "$actual" ]]; then
        actual="$(shasum -a 256 "$tarball" 2>/dev/null | cut -d' ' -f1)"
    fi

    if [[ "$actual" != "$expected" ]]; then
        echo "session-start: gitleaks checksum mismatch — expected $expected, got ${actual:-<none>}; refusing to install" >&2
        rm -f "$tarball"
        return 1
    fi

    if tar -xzf "$tarball" -C /tmp gitleaks \
        && mv /tmp/gitleaks /usr/local/bin/gitleaks; then
        rm -f "$tarball"
        return 0
    fi
    rm -f "$tarball"
    return 1
}

install_shellcheck() {
    if command -v shellcheck >/dev/null 2>&1; then
        return 0
    fi
    apt-get install -y -qq shellcheck >/dev/null 2>&1
}

install_luacheck() {
    if command -v luacheck >/dev/null 2>&1; then
        return 0
    fi
    apt-get install -y -qq lua-check >/dev/null 2>&1 \
        || apt-get install -y -qq luarocks >/dev/null 2>&1 \
            && luarocks install luacheck >/dev/null 2>&1
}

# Pre-warm the uv venv so the pre-commit hook doesn't pay sync cost on the
# first commit of the session.
warm_uv() {
    uv --directory "$PROJECT_DIR/scripts" sync --quiet
}

install_gitleaks  || echo "session-start: gitleaks install failed (continuing)" >&2
install_shellcheck || echo "session-start: shellcheck install failed (continuing)" >&2
install_luacheck  || echo "session-start: luacheck install failed (continuing)" >&2
warm_uv           || echo "session-start: uv sync failed (continuing)" >&2

exit 0
