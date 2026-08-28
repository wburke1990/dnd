"""Tests for the prose-critic pre-commit gate."""

from __future__ import annotations

import json
import os
import subprocess
from datetime import UTC, datetime, timedelta
from pathlib import Path

import pytest

from dnd_tools import critic_gate


def _write_transcript(tdir: Path, name: str, records: list[dict[str, object]]) -> Path:
    tdir.mkdir(parents=True, exist_ok=True)
    path = tdir / name
    path.write_text("\n".join(json.dumps(r) for r in records) + "\n")
    return path


def _critic_record(stamp: str, prompt: str) -> dict[str, object]:
    return {
        "timestamp": stamp,
        "message": {
            "content": [
                {
                    "type": "tool_use",
                    "name": "Agent",
                    "input": {"subagent_type": "prose-critic", "prompt": prompt},
                }
            ]
        },
    }


def _git_repo(root: Path) -> None:
    subprocess.run(["git", "init", "-q", str(root)], check=True)
    subprocess.run(["git", "-C", str(root), "config", "user.email", "t@example.com"], check=True)
    subprocess.run(["git", "-C", str(root), "config", "user.name", "T"], check=True)


# --- staged file selection --------------------------------------------------


def test_staged_content_files_lists_staged_markdown(tmp_path: Path) -> None:
    _git_repo(tmp_path)
    (tmp_path / "world").mkdir()
    (tmp_path / "world" / "aar.md").write_text("prose\n")
    subprocess.run(["git", "-C", str(tmp_path), "add", "world/aar.md"], check=True)

    assert critic_gate.staged_content_files(tmp_path) == ["world/aar.md"]


def test_staged_content_files_skips_generated_and_non_content(tmp_path: Path) -> None:
    _git_repo(tmp_path)
    (tmp_path / "world").mkdir()
    (tmp_path / "scripts").mkdir()
    (tmp_path / "world" / "README.md").write_text("generated\n")
    (tmp_path / "INDEX.md").write_text("generated\n")
    (tmp_path / "world" / "notes.txt").write_text("not markdown\n")
    (tmp_path / "scripts" / "thing.md").write_text("not content\n")
    subprocess.run(["git", "-C", str(tmp_path), "add", "-A"], check=True)

    assert critic_gate.staged_content_files(tmp_path) == []


# --- transcript scanning ----------------------------------------------------


def test_critic_prompts_finds_recent_runs(tmp_path: Path) -> None:
    since = datetime(2026, 8, 28, 12, 0, tzinfo=UTC)
    _write_transcript(
        tmp_path,
        "session.jsonl",
        [_critic_record("2026-08-28T13:00:00.000Z", "Review /repo/world/aar.md for style")],
    )

    assert critic_gate.critic_prompts(tmp_path, since) == ["Review /repo/world/aar.md for style"]


def test_critic_prompts_ignores_runs_before_the_last_commit(tmp_path: Path) -> None:
    since = datetime(2026, 8, 28, 12, 0, tzinfo=UTC)
    _write_transcript(
        tmp_path,
        "session.jsonl",
        [_critic_record("2026-08-28T09:00:00.000Z", "Review /repo/world/aar.md")],
    )

    assert critic_gate.critic_prompts(tmp_path, since) == []


def test_critic_prompts_ignores_other_subagents(tmp_path: Path) -> None:
    since = datetime(2026, 8, 28, 12, 0, tzinfo=UTC)
    record: dict[str, object] = {
        "timestamp": "2026-08-28T13:00:00.000Z",
        "message": {
            "content": [
                {
                    "type": "tool_use",
                    "name": "Agent",
                    "input": {
                        "subagent_type": "Explore",
                        # The word appears in the prompt but no critic ran.
                        "prompt": "find the prose-critic config for /repo/world/aar.md",
                    },
                }
            ]
        },
    }
    _write_transcript(tmp_path, "session.jsonl", [record])

    assert critic_gate.critic_prompts(tmp_path, since) == []


def test_critic_prompts_survives_malformed_lines(tmp_path: Path) -> None:
    since = datetime(2026, 8, 28, 12, 0, tzinfo=UTC)
    tmp_path.mkdir(parents=True, exist_ok=True)
    good = json.dumps(_critic_record("2026-08-28T13:00:00.000Z", "Review /repo/world/aar.md"))
    (tmp_path / "session.jsonl").write_text(f"not json but mentions prose-critic\n{good}\n[]\n")

    assert critic_gate.critic_prompts(tmp_path, since) == ["Review /repo/world/aar.md"]


def test_critic_prompts_skips_transcripts_older_than_the_commit(tmp_path: Path) -> None:
    path = _write_transcript(
        tmp_path,
        "session.jsonl",
        [_critic_record("2099-01-01T00:00:00.000Z", "Review /repo/world/aar.md")],
    )
    old = (datetime.now(tz=UTC) - timedelta(days=30)).timestamp()
    os.utime(path, (old, old))

    since = datetime.now(tz=UTC) - timedelta(days=1)
    assert critic_gate.critic_prompts(tmp_path, since) == []


# --- coverage matching ------------------------------------------------------


def test_uncritiqued_matches_absolute_paths_in_prompts() -> None:
    files = ["world/aar.md", "characters/bear.md"]
    prompts = ["Review /Users/wcb/personal/dnd/world/aar.md for house-style violations"]

    assert critic_gate.uncritiqued(files, prompts) == ["characters/bear.md"]


def test_uncritiqued_is_empty_when_all_covered() -> None:
    files = ["world/aar.md"]
    prompts = ["Review lines 1-110 of world/aar.md"]

    assert critic_gate.uncritiqued(files, prompts) == []


def test_uncritiqued_returns_everything_when_nothing_ran() -> None:
    files = ["world/aar.md", "sessions/session-12.md"]

    assert critic_gate.uncritiqued(files, []) == files


# --- transcript directory ---------------------------------------------------


def test_transcript_dir_slugs_the_repo_path(tmp_path: Path) -> None:
    result = critic_gate.transcript_dir(Path("/Users/wcb/personal/dnd"), home=tmp_path)

    assert result == tmp_path / ".claude" / "projects" / "-Users-wcb-personal-dnd"


def test_has_transcripts_is_false_for_missing_dir(tmp_path: Path) -> None:
    assert critic_gate.has_transcripts(tmp_path / "nope") is False


def test_has_transcripts_is_false_for_empty_dir(tmp_path: Path) -> None:
    assert critic_gate.has_transcripts(tmp_path) is False


def test_has_transcripts_is_true_when_a_session_exists(tmp_path: Path) -> None:
    _write_transcript(tmp_path, "session.jsonl", [])

    assert critic_gate.has_transcripts(tmp_path) is True


# --- head commit time -------------------------------------------------------


def test_head_commit_time_is_epoch_without_a_commit(tmp_path: Path) -> None:
    _git_repo(tmp_path)

    assert critic_gate.head_commit_time(tmp_path) == datetime.fromtimestamp(0, tz=UTC)


def test_head_commit_time_reads_the_last_commit(tmp_path: Path) -> None:
    _git_repo(tmp_path)
    (tmp_path / "a.txt").write_text("x\n")
    subprocess.run(["git", "-C", str(tmp_path), "add", "a.txt"], check=True)
    subprocess.run(["git", "-C", str(tmp_path), "commit", "-qm", "first"], check=True)

    stamp = critic_gate.head_commit_time(tmp_path)

    assert stamp > datetime.fromtimestamp(0, tz=UTC)


# --- main -------------------------------------------------------------------


@pytest.fixture
def staged_repo(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    """A repo with one commit and a staged content file, cwd set inside it."""
    repo = tmp_path / "repo"
    repo.mkdir()
    _git_repo(repo)
    (repo / "seed.txt").write_text("x\n")
    subprocess.run(["git", "-C", str(repo), "add", "seed.txt"], check=True)
    subprocess.run(["git", "-C", str(repo), "commit", "-qm", "seed"], check=True)

    (repo / "world").mkdir()
    (repo / "world" / "aar.md").write_text("prose\n")
    subprocess.run(["git", "-C", str(repo), "add", "world/aar.md"], check=True)

    monkeypatch.chdir(repo)
    monkeypatch.delenv(critic_gate.BYPASS_ENV, raising=False)
    return repo


def test_main_passes_when_nothing_is_staged(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    repo = tmp_path / "repo"
    repo.mkdir()
    _git_repo(repo)
    monkeypatch.chdir(repo)

    assert critic_gate.main() == 0


def test_main_passes_when_no_transcripts_exist(
    staged_repo: Path, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: tmp_path / "empty-home"))

    assert critic_gate.main() == 0


def test_main_blocks_when_a_transcript_shows_no_critic_run(
    staged_repo: Path, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    home = tmp_path / "home"
    tdir = home / ".claude" / "projects" / str(staged_repo).replace("/", "-")
    _write_transcript(
        tdir,
        "session.jsonl",
        [_critic_record("2099-01-01T00:00:00.000Z", "Review some/other/file.md")],
    )
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: home))

    assert critic_gate.main() == 1


def test_main_passes_when_the_critic_covered_the_file(
    staged_repo: Path, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    home = tmp_path / "home"
    tdir = home / ".claude" / "projects" / str(staged_repo).replace("/", "-")
    _write_transcript(
        tdir,
        "session.jsonl",
        [_critic_record("2099-01-01T00:00:00.000Z", f"Review {staged_repo}/world/aar.md")],
    )
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: home))

    assert critic_gate.main() == 0


def test_main_bypass_env_lets_the_commit_through(
    staged_repo: Path, tmp_path: Path, monkeypatch: pytest.MonkeyPatch
) -> None:
    home = tmp_path / "home"
    tdir = home / ".claude" / "projects" / str(staged_repo).replace("/", "-")
    _write_transcript(tdir, "session.jsonl", [])
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: home))
    monkeypatch.setenv(critic_gate.BYPASS_ENV, "1")

    assert critic_gate.main() == 0


def test_main_bypass_names_the_skipped_files(
    staged_repo: Path,
    tmp_path: Path,
    monkeypatch: pytest.MonkeyPatch,
    capsys: pytest.CaptureFixture[str],
) -> None:
    monkeypatch.setenv(critic_gate.BYPASS_ENV, "1")

    critic_gate.main()

    assert "world/aar.md" in capsys.readouterr().err
