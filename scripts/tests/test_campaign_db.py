"""End-to-end tests for the `dnd` CLI: add → query → search → link.

Each test gets a fresh on-disk SQLite DB under tmp_path so migrations
run against a clean slate. The point isn't unit coverage of every
helper — it's proving the user-visible CLI flows produce sane output
and round-trip data correctly.
"""

from __future__ import annotations

from pathlib import Path

from click.testing import CliRunner

from dnd_tools.dnd_cli import main


def _run(db_path: Path, *args: str) -> tuple[int, str]:
    result = CliRunner().invoke(main, ["--db", str(db_path), *args])
    return result.exit_code, result.output


def test_migrate_creates_schema(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    code, out = _run(db_path, "migrate")
    assert code == 0
    # Second migrate is a no-op.
    code, out = _run(db_path, "migrate")
    assert code == 0
    assert "No migrations" in out


def test_add_and_query_npc(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    code, _ = _run(
        db_path,
        "add",
        "npc",
        "Zaltar the Bound",
        "--race",
        "Tiefling",
        "--class",
        "Wizard (Diviner)",
        "--level",
        "8",
        "--hp",
        "52",
        "--ac",
        "14",
        "--str",
        "8",
        "--dex",
        "14",
        "--con",
        "12",
        "--int",
        "18",
        "--wis",
        "13",
        "--cha",
        "11",
        "--notes",
        "Owes the party a favor",
    )
    assert code == 0

    code, out = _run(db_path, "npc", "Zaltar")
    assert code == 0
    assert "Zaltar the Bound" in out
    assert "Tiefling" in out
    assert "Wizard" in out
    assert "52" in out
    assert "Owes the party a favor" in out


def test_npc_fuzzy_disambiguation(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "npc", "Aldous")
    _run(db_path, "add", "npc", "Aldebaran")

    code, out = _run(db_path, "npc", "Ald")
    # Ambiguous: exit non-zero, both candidates listed.
    assert code == 1
    assert "Aldous" in out
    assert "Aldebaran" in out


def test_npc_exact_match_wins_over_substring(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "npc", "Bran")
    _run(db_path, "add", "npc", "Brandt")

    code, out = _run(db_path, "npc", "Bran")
    assert code == 0
    assert "Bran" in out
    # The full Brandt block shouldn't be rendered.
    assert "Brandt" not in out


def test_session_links_npcs_and_pcs(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "npc", "Captain Vex")
    _run(db_path, "add", "pc", "Mira Stoneblade", "--player", "Alex")
    _run(
        db_path,
        "add",
        "session",
        "7",
        "--title",
        "The Sundered Vault",
        "--date",
        "2026-05-15",
        "--xp",
        "1200",
    )
    _run(db_path, "link", "npc-session", "Captain Vex", "7", "--role", "fought")
    _run(db_path, "link", "pc-session", "Mira Stoneblade", "7")

    code, out = _run(db_path, "session", "7")
    assert code == 0
    assert "Session 7" in out
    assert "The Sundered Vault" in out
    assert "Captain Vex" in out
    assert "Mira Stoneblade" in out


def test_search_across_entity_kinds(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "npc", "Theodric", "--notes", "guards the whispered pact")
    _run(db_path, "add", "faction", "Whispered Pact", "--description", "Cult of forgotten oaths")
    _run(
        db_path,
        "add",
        "lore",
        "The Whispered Oath",
        "--body",
        "Forbidden pact between the Pact and the Devourer",
    )

    code, out = _run(db_path, "search", "whisper")
    assert code == 0
    # All three kinds should appear.
    assert "Theodric" in out
    assert "Whispered Pact" in out
    assert "The Whispered Oath" in out


def test_item_resolves_owner_and_location(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "location", "Vault of Kelemvor", "--kind", "dungeon")
    _run(db_path, "add", "pc", "Mira Stoneblade")
    _run(
        db_path,
        "add",
        "item",
        "Skullsplitter",
        "--kind",
        "weapon",
        "--rarity",
        "rare",
        "--owner-pc",
        "Mira Stoneblade",
        "--location",
        "Vault of Kelemvor",
    )

    code, out = _run(db_path, "item", "Skullsplitter")
    assert code == 0
    assert "Skullsplitter" in out
    assert "Mira Stoneblade" in out
    assert "Vault of Kelemvor" in out


def test_not_found_exits_nonzero(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    code, out = _run(db_path, "npc", "Nobody")
    assert code == 1
    assert "No npc" in out


def test_export_dumps_sql(tmp_path: Path) -> None:
    db_path = tmp_path / "campaign.db"
    _run(db_path, "add", "npc", "Quill")
    out_file = tmp_path / "dump.sql"
    code, _ = _run(db_path, "export", "--out", str(out_file))
    assert code == 0
    contents = out_file.read_text()
    assert "INSERT INTO" in contents.upper() or "INSERT" in contents
    assert "Quill" in contents
