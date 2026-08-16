"""Tests for the campaign index generator."""

from __future__ import annotations

from pathlib import Path

import pytest

from dnd_tools import build_index
from dnd_tools.build_index import (
    BEGIN,
    END,
    Doc,
    MissingFrontmatter,
    inject,
    parse_frontmatter,
    read_doc,
    table,
)


def write(path: Path, summary: str = "A thing", status: str = "reference") -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(f"---\nsummary: {summary}\nstatus: {status}\n---\n\n# Title\n\nBody.\n")
    return path


class TestParseFrontmatter:
    def test_reads_fields(self) -> None:
        text = "---\nsummary: The four tombs\nstatus: played\n---\n\n# Tombs\n"
        assert parse_frontmatter(text) == {"summary": "The four tombs", "status": "played"}

    def test_no_frontmatter_is_empty(self) -> None:
        assert parse_frontmatter("# Just a heading\n") == {}

    def test_unterminated_block_is_empty(self) -> None:
        assert parse_frontmatter("---\nsummary: x\n") == {}

    def test_strips_surrounding_quotes(self) -> None:
        assert parse_frontmatter('---\nsummary: "quoted"\nstatus: idea\n---\n')["summary"] == (
            "quoted"
        )

    def test_colon_in_value_survives(self) -> None:
        text = "---\nsummary: Tennyson: Ulysses\nstatus: reference\n---\n"
        assert parse_frontmatter(text)["summary"] == "Tennyson: Ulysses"

    def test_horizontal_rule_in_body_is_not_a_fence(self) -> None:
        """A file opening with a rule rather than frontmatter yields nothing."""
        assert parse_frontmatter("# Title\n\n---\n\nBody\n") == {}


class TestReadDoc:
    def test_reads_a_complete_file(self, tmp_path: Path) -> None:
        doc = read_doc(write(tmp_path / "a.md", "The four tombs", "played"))
        assert doc.summary == "The four tombs"
        assert doc.status == "played"

    def test_missing_summary_raises(self, tmp_path: Path) -> None:
        path = tmp_path / "b.md"
        path.write_text("---\nstatus: played\n---\n\n# B\n")
        with pytest.raises(MissingFrontmatter, match="no summary"):
            read_doc(path)

    def test_unknown_status_raises(self, tmp_path: Path) -> None:
        path = tmp_path / "c.md"
        path.write_text("---\nsummary: x\nstatus: wibble\n---\n\n# C\n")
        with pytest.raises(MissingFrontmatter, match="not one of"):
            read_doc(path)

    def test_no_frontmatter_at_all_raises(self, tmp_path: Path) -> None:
        path = tmp_path / "d.md"
        path.write_text("# D\n\nBody.\n")
        with pytest.raises(MissingFrontmatter):
            read_doc(path)


class TestTable:
    def _doc(self, name: str, status: str, root: Path) -> Doc:
        return Doc(path=root / f"{name}.md", summary="S", status=status)

    def test_orders_by_status_then_name(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        docs = [
            self._doc("zebra", "next", tmp_path),
            self._doc("apple", "played", tmp_path),
            self._doc("beta", "next", tmp_path),
        ]
        rows = table(docs, tmp_path)
        assert "zebra" in rows[3] and "beta" in rows[2]
        assert "apple" in rows[4]

    def test_empty_docs_render_nothing(self, tmp_path: Path) -> None:
        assert table([], tmp_path) == []

    def test_title_humanises_the_stem(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        rows = table([self._doc("valley-of-the-kings", "played", tmp_path)], tmp_path)
        assert "[valley of the kings]" in rows[2]


class TestInject:
    def test_creates_a_file_when_absent(self, tmp_path: Path) -> None:
        out = inject(tmp_path / "handouts" / "README.md", "TABLE")
        assert BEGIN in out and END in out and "TABLE" in out

    def test_appends_below_hand_written_prose(self, tmp_path: Path) -> None:
        path = tmp_path / "README.md"
        path.write_text("# Sessions\n\nHand-written notes worth keeping.\n")
        out = inject(path, "TABLE")
        assert "Hand-written notes worth keeping." in out
        assert out.index("Hand-written") < out.index(BEGIN)

    def test_replaces_only_the_generated_block(self, tmp_path: Path) -> None:
        path = tmp_path / "README.md"
        path.write_text(f"Top matter.\n\n{BEGIN}\n\nOLD\n\n{END}\n\nRunning threads.\n")
        out = inject(path, "NEW")
        assert "OLD" not in out
        assert "NEW" in out
        assert "Top matter." in out
        assert "Running threads." in out

    def test_round_trips(self, tmp_path: Path) -> None:
        """Injecting twice is stable, so --check does not thrash."""
        path = tmp_path / "README.md"
        path.write_text("Preamble.\n")
        once = inject(path, "TABLE")
        path.write_text(once)
        assert inject(path, "TABLE") == once


class TestRender:
    def test_indexes_a_small_tree(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        write(tmp_path / "world" / "maalm" / "lore" / "founding.md", "How it was founded")
        write(tmp_path / "world" / "maalm" / "encounters" / "tombs.md", "Four tombs", "played")
        write(tmp_path / "characters" / "preem.md", "The wizard")

        out = build_index.render()
        index = out[tmp_path / "INDEX.md"]
        assert "How it was founded" in index
        assert "Four tombs" in index
        assert "The wizard" in index
        assert (tmp_path / "world" / "maalm" / "README.md") in out
        assert (tmp_path / "characters" / "README.md") in out

    def test_region_readme_covers_only_its_own_region(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        write(tmp_path / "world" / "maalm" / "lore" / "a.md", "Maalm thing")
        write(tmp_path / "world" / "lonka" / "lore" / "b.md", "Lonka thing")

        out = build_index.render()
        maalm = out[tmp_path / "world" / "maalm" / "README.md"]
        assert "Maalm thing" in maalm
        assert "Lonka thing" not in maalm

    def test_nested_locality_is_its_own_region(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        write(tmp_path / "world" / "suartleheim-eet" / "maalm" / "lore" / "a.md", "In Maalm")
        write(tmp_path / "world" / "suartleheim-eet" / "brauron" / "encounters" / "b.md", "In town")

        out = build_index.render()
        assert (tmp_path / "world" / "suartleheim-eet" / "maalm" / "README.md") in out
        assert (tmp_path / "world" / "suartleheim-eet" / "brauron" / "README.md") in out
        maalm = out[tmp_path / "world" / "suartleheim-eet" / "maalm" / "README.md"]
        assert "In town" not in maalm

    def test_readmes_are_not_themselves_indexed(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        write(tmp_path / "world" / "maalm" / "lore" / "a.md", "Real content")
        write(tmp_path / "world" / "maalm" / "lore" / "README.md", "Should be skipped")

        assert "Should be skipped" not in build_index.render()[tmp_path / "INDEX.md"]

    def test_generated_output_is_stable(self, tmp_path: Path, monkeypatch) -> None:  # type: ignore[no-untyped-def]
        """Two renders agree, so --check cannot report spurious staleness."""
        monkeypatch.setattr(build_index, "REPO_ROOT", tmp_path)
        write(tmp_path / "world" / "maalm" / "lore" / "a.md", "A thing")
        first = build_index.render()
        for path, text in first.items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text)
        assert build_index.render() == first
