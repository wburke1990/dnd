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


def test_flags_war_cliche() -> None:
    assert "war-cliche" in _rules("its people put to the sword")
    assert "war-cliche" in _rules("a trading power that bled the land dry")
    assert "war-cliche" in _rules("his ancestors butchered twice")
    assert "war-cliche" in _rules("held it to the last man")


def test_flags_repetition_flourish() -> None:
    assert "repetition-flourish" in _rules("the party finds aftermath on aftermath")
    assert "repetition-flourish" in _rules("crime on crime")


def test_flags_meta_jargon() -> None:
    assert "meta-jargon" in _rules("the one city that survived the whole timeline")


def test_flags_history_metaphor() -> None:
    assert "history-metaphor" in _rules("the gnomes' first fall replayed now")
    assert "history-metaphor" in _rules("the Company hollowed them out")
    assert "history-metaphor" in _rules("a famine-hollowed kingdom")
    assert "history-metaphor" in _rules("the cold lights the southern wars")


def test_flags_new_coined_labels() -> None:
    assert "coined-label" in _rules("undone in the Bengal beat")
    assert "coined-label" in _rules("the full Book-of-Invasions stack")
    assert "coined-label" in _rules("the Kalikhat Underdark cradle")


def test_flags_geis_jargon() -> None:
    assert "geis-jargon" in _rules("the world's name-hold on mortals")
    assert "geis-jargon" in _rules("the sworn-charge register, not the true-name hold")
    assert "geis-jargon" in _rules("a sworn prohibition worded in the old cadence")
    assert "geis-jargon" in _rules("Run it in the old register.")
    assert "geis-jargon" in _rules("word the charge in the myths' own cadence")


def test_geis_jargon_leaves_plain_true_name() -> None:
    # "true name" is a pervasive, legitimate campaign concept; only the coined
    # compounds and the "... register / cadence" labels are flagged.
    assert "geis-jargon" not in _rules("bound by its true name, forced to obey")
    assert "geis-jargon" not in _rules("he still holds her true name")
    assert "geis-jargon" not in _rules("she rang the register at the store")


def test_new_rules_leave_plain_prose() -> None:
    assert _rules("The ore comes down the river to the landing at Copaa.") == set()
    assert _rules("He stacked the crates and bled the brakes.") == set()


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


def test_flags_gnomic_passive() -> None:
    assert "gnomic-passive" in _rules("No one explains it; it is there to be seen.")
    assert "gnomic-passive" in _rules("The evidence is there to be found.")
    assert "gnomic-passive" in _rules("the tree's own words, there to be heard")


def test_quotations_are_exempt_from_the_style_pass() -> None:
    # Scripture, poems, NPC dialogue and a player's own words are off limits.
    assert "editorial-adverb" not in _rules('Mul shrugs. "Dull work, truly."')
    assert "not-just" not in _rules('he burned "not only men"')
    assert "editorial-adverb" in _rules("The work was truly dull.")


def test_quotation_blanking_keeps_columns() -> None:
    line = '"Truly," she said, and the room was utterly still.'
    findings = iter_findings("t.md", line.splitlines())
    (finding,) = [f for f in findings if f.rule == "editorial-adverb"]
    assert line[finding.col - 1 :].startswith("utterly")


def test_blanked_quotation_does_not_bridge_words_on_either_side() -> None:
    # A space filler would let "\s+" join "the" and "on the" across the quote.
    assert "repetition-flourish" not in _rules('the "so it goes" on the wall')


def test_beat_rule_leaves_stage_directions_and_the_verb() -> None:
    assert "coined-label" not in _rules("*(a beat too long)* he answers")
    assert "coined-label" not in _rules("a deadline Preem is racing to beat")
    assert "coined-label" in _rules("the reveal-beat lands in the third room")


def test_flags_headless_relative() -> None:
    assert "headless-relative" in _rules("What is weighed is what he did.")
    assert "headless-relative" in _rules("it does not change what is weighed")
    assert "headless-relative" in _rules("What was remembered stayed in the stone.")


def test_headless_relative_leaves_plain_prose() -> None:
    # A named actor doing the weighing is the rewrite the rule asks for.
    assert "headless-relative" not in _rules("Anubis weighs the fire, not the reasons.")
    assert "headless-relative" not in _rules("She asked what is still standing.")


def test_flags_negated_antithesis() -> None:
    assert "negated-antithesis" in _rules(
        "The scales don't weigh whether you've sinned. They weigh whether you know yourself."
    )
    assert "negated-antithesis" in _rules(
        "The mountain does not sleep. It sleeps only when the digging stops."
    )


def test_negated_antithesis_leaves_plain_prose() -> None:
    # A negation followed by an unrelated sentence is not the antithesis shape.
    assert "negated-antithesis" not in _rules(
        "The scales don't weigh sinlessness. Ammit waits beside them."
    )
    assert "negated-antithesis" not in _rules("He does not answer. They walk on.")


def test_gnomic_passive_leaves_plain_prose() -> None:
    # A plain "there" or an infinitive that states an action is fine.
    assert "gnomic-passive" not in _rules("A stair is there, going down.")
    assert "gnomic-passive" not in _rules("They go there to read the verses.")


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
