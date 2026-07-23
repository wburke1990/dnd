"""Tests for the prose-lint CLI."""

from __future__ import annotations

from pathlib import Path

from click.testing import CliRunner

from dnd_tools.prose_lint import (
    RULES,
    iter_findings,
    lint_file,
    main,
    parse_diff_added_lines,
)


def _rules(text: str) -> set[str]:
    return {f.rule for f in iter_findings("t.md", text.splitlines())}


def test_flags_spine() -> None:
    assert "spine" in _rules("This is the spine of the plan.")


def test_flags_significance() -> None:
    assert "significance-flag" in _rules("That confrontation is the payoff of the arc.")
    assert "significance-flag" in _rules("This is the heart of it.")
    assert "significance-flag" in _rules("This is a centerpiece, not a subplot.")
    assert "significance-flag" in _rules("The reveal, not a reunion, is the point.")
    assert "significance-flag" in _rules("the whole point is that he catches himself")
    assert "significance-flag" in _rules("the single most important reaction Mul gives")


def test_flags_not_just() -> None:
    assert "not-just" in _rules("It is not just a battle.")
    assert "not-just" in _rules("more than just a fight")
    assert "not-just" in _rules("these aren't just preferences")


def test_flags_coined_labels() -> None:
    assert "coined-label" in _rules("the reform-loop is immediate")
    assert "coined-label" in _rules("the warning ladder tells them")
    assert "coined-label" in _rules("the perverse engine of promotion")
    assert "coined-label" in _rules("the engine of the cataclysm")
    assert "coined-label" in _rules("turned the cycle into a land-factory")
    assert "coined-label" in _rules("a transformation engine in its own right")


def test_flags_simile_and_made_literal() -> None:
    assert "simile" in _rules("it moved as if alive")
    assert "made-literal" in _rules("his old fear made literal")


def test_flags_feeling_and_adverb() -> None:
    assert "feeling-word" in _rules("an ominous door")
    assert "feeling-word" in _rules("the reconquest is bitterly ironic")
    assert "feeling-word" in _rules("left ominously open at the table")
    assert "editorial-adverb" in _rules("utterly broken")
    assert "editorial-adverb" in _rules("their culture is genuinely noble")


def test_flags_emotion_dictation() -> None:
    assert "emotion-dictation" in _rules("the party gets to feel clever")


def test_emotion_rule_ignores_physical_perception() -> None:
    # "feels the wind" is perception, not dictated emotion.
    assert "emotion-dictation" not in _rules("when the party feels the wind")


def test_feel_tone_lines_keep_feeling_words() -> None:
    # A line that exists to declare the intended register may name a feeling.
    assert "feeling-word" not in _rules("*Tone: Eerie, orienting*")
    assert "feeling-word" not in _rules("- **Feel (resolved):** it is meant to be horrifying")
    assert "emotion-dictation" not in _rules("Feel: the party should feel clever here")


def test_feeling_word_still_flagged_in_ordinary_prose() -> None:
    assert "feeling-word" in _rules("The corridor is eerie and cold.")


def test_feel_line_still_flags_non_feeling_rules() -> None:
    # Only the feeling/emotion rules relax on a Feel:/Tone: line; others still fire.
    assert "spine" in _rules("Tone: the spine of the dungeon.")


def test_clean_prose_has_no_findings() -> None:
    text = "The fleet becalms the hulls, then the fast craft board them."
    assert _rules(text) == set()


def test_code_fences_are_skipped() -> None:
    text = "before\n```\nthis is the spine of the poem\n```\nafter"
    assert _rules(text) == set()


def test_only_lines_restricts_reporting() -> None:
    text = "the payoff here\nthe spine here"
    lines = text.splitlines()
    all_findings = list(iter_findings("t.md", lines))
    assert len(all_findings) >= 2
    second_only = list(iter_findings("t.md", lines, only_lines={2}))
    assert {f.line for f in second_only} == {2}


def test_column_is_one_based() -> None:
    findings = list(iter_findings("t.md", ["  spine"]))
    assert findings[0].col == 3  # 1-based index of "spine"
    assert findings[0].match == "spine"


def test_every_rule_has_a_message() -> None:
    for rule in RULES:
        assert rule.message
        assert rule.name


def test_parse_diff_added_lines() -> None:
    diff = (
        "diff --git a/lore/x.md b/lore/x.md\n"
        "--- a/lore/x.md\n"
        "+++ b/lore/x.md\n"
        "@@ -1,0 +2,2 @@\n"
        "+the payoff of the arc\n"
        "+plain second line\n"
        "@@ -10,1 +12,1 @@\n"
        "-old line\n"
        "+the reform-loop\n"
    )
    added = parse_diff_added_lines(diff)
    assert added == {"lore/x.md": {2, 3, 12}}


def test_parse_diff_handles_new_file() -> None:
    diff = (
        "diff --git a/lore/new.md b/lore/new.md\n"
        "--- /dev/null\n"
        "+++ b/lore/new.md\n"
        "@@ -0,0 +1,1 @@\n"
        "+the centerpiece line\n"
    )
    assert parse_diff_added_lines(diff) == {"lore/new.md": {1}}


def test_lint_file_reads_and_skips_fences(tmp_path: Path) -> None:
    f = tmp_path / "sample.md"
    f.write_text("the payoff is here\n```\nthe spine in code\n```\n", encoding="utf-8")
    rules = {finding.rule for finding in lint_file(f)}
    assert rules == {"significance-flag"}


def test_cli_explicit_path_reports(tmp_path: Path) -> None:
    f = tmp_path / "sample.md"
    f.write_text("This is the payoff of the whole arc.\n", encoding="utf-8")
    result = CliRunner().invoke(main, [str(f)])
    assert result.exit_code == 0
    assert "significance-flag" in result.output
    assert "1 issue(s)" in result.output


def test_cli_clean_file(tmp_path: Path) -> None:
    f = tmp_path / "clean.md"
    f.write_text("The fleet takes the hulls and sails them away.\n", encoding="utf-8")
    result = CliRunner().invoke(main, [str(f)])
    assert result.exit_code == 0
    assert "clean" in result.output


def test_cli_exit_code_flag(tmp_path: Path) -> None:
    f = tmp_path / "bad.md"
    f.write_text("the spine of it\n", encoding="utf-8")
    result = CliRunner().invoke(main, [str(f), "--exit-code"])
    assert result.exit_code == 1
