"""Flag house-style violations in the campaign's content markdown.

A lightweight prose linter for the writing rules in CLAUDE.md. It reports
coined labels, significance-flags, similes, editorializing adverbs, and the
other fixed offenders as ``path:line:col`` lines, the way ruff reports code.
It catches the *fixed* patterns only; a brand-new coined label it has never
seen still needs the eye and the test in CLAUDE.md.

It never edits anything. By default it lints only the lines you have changed
(``git diff`` vs HEAD), so the back-catalog's existing hits stay quiet. Pass
``--files`` to lint whole changed files, or name files explicitly.
"""

from __future__ import annotations

import subprocess
import sys
from collections.abc import Iterable, Iterator
from dataclasses import dataclass
from pathlib import Path
from re import IGNORECASE, Pattern, compile

import click

REPO_ROOT = Path(__file__).resolve().parents[2]

# Directories whose markdown is prose held to the house style.
CONTENT_DIRS = (
    "lore",
    "encounters",
    "characters",
    "sessions",
    "bestiary",
    "handouts",
    "prompts",
    "docs",
)


@dataclass(frozen=True)
class Rule:
    """A named regex and the message printed when it matches."""

    name: str
    pattern: Pattern[str]
    message: str


@dataclass(frozen=True)
class Finding:
    """One rule match at a location."""

    path: str
    line: int
    col: int
    rule: str
    message: str
    match: str


def _rule(name: str, pattern: str, message: str) -> Rule:
    return Rule(name=name, pattern=compile(pattern, IGNORECASE), message=message)


# Curated, high-precision patterns for the fixed offenders in the house style.
# Expect occasional false positives (a literal "spine", "feels the wind"); this
# is an assist, not a gate, so the human reads the list and judges.
RULES: tuple[Rule, ...] = (
    _rule(
        "not-just",
        r"\bnot (just|only|merely)\b|\bit'?s not (just|only|merely)\b"
        r"|\bmore than just\b|\b\w+n't (just|only|merely)\b",
        "'not just/only/merely X' construction; say the plain thing (#3)",
    ),
    _rule(
        "significance-flag",
        r"\b(payoff|centerpieces?|heart of it|gut-punch|key moment|whole point|most important)\b"
        r"|\bthe picture the whole\b|\bthis is the (heart|key|point)\b|\bis the point\b",
        "significance-flag; let the world stand (#8)",
    ),
    _rule(
        "coined-label",
        r"\b(the|a|an) \w+[- ](engine|loop|ladder|machine|churn)\b"
        r"|\bthe engine (of|underneath|behind|dressed)\b"
        r"|\b\w+-(engine|loop|ladder|machine|churn|factory)\b",
        "coined label; name the thing plainly (#12)",
    ),
    _rule(
        "spine",
        r"\bspine\b",
        "'spine' is banned as a metaphor (#1); cut it unless literal",
    ),
    _rule(
        "made-literal",
        r"\bmade (literal|real)\b",
        "figure of speech (#2)",
    ),
    _rule(
        "simile",
        r"\bas if\b|\bas though\b",
        "simile or hedge; describe literally (#2)",
    ),
    _rule(
        "feeling-word",
        r"\b(horrifying|unsettling|chilling|eerie|hauntingly)\b"
        r"|\b(ominous(?:ly)?|tragic|ironic(?:ally)?)\b",
        "telling the reader how to feel (#6)",
    ),
    _rule(
        "editorial-adverb",
        r"\b(truly|utterly|impossibly|genuinely)\b",
        "editorializing adverb (#4)",
    ),
    _rule(
        "emotion-dictation",
        r"\bthe party (gets to|will feel|should feel|is meant to feel)\b",
        "dictating PC reaction (#7)",
    ),
)


# A "Feel:" / "Tone:" / "Mood:" note exists to DECLARE the intended emotional
# register, so it legitimately names a feeling ("Tone: Eerie"). The feeling and
# emotion-dictation rules invert on such a line, so suppress just those two here;
# every other rule still fires. Matches the label after any list bullet / emphasis
# / blockquote marker, allowing a short parenthetical before the colon.
FEEL_TONE_MARKER: Pattern[str] = compile(r"^[\s>*_-]*(?:feel|tone|mood)\b[^:]{0,24}:", IGNORECASE)
FEELING_RULES: frozenset[str] = frozenset({"feeling-word", "emotion-dictation"})


def _relpath(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def iter_findings(
    path: str,
    lines: Iterable[str],
    only_lines: set[int] | None = None,
) -> Iterator[Finding]:
    """Yield findings for ``lines``, skipping fenced code blocks.

    ``only_lines`` (1-based) restricts *reporting* to those line numbers; the
    fence state is still tracked over every line, so a changed line inside a
    ``` block is correctly left alone.
    """
    in_fence = False
    for lineno, raw in enumerate(lines, start=1):
        stripped = raw.lstrip()
        if stripped.startswith(("```", "~~~")):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        if only_lines is not None and lineno not in only_lines:
            continue
        feel_line = bool(FEEL_TONE_MARKER.match(raw))
        for rule in RULES:
            if feel_line and rule.name in FEELING_RULES:
                continue
            for m in rule.pattern.finditer(raw):
                yield Finding(
                    path=path,
                    line=lineno,
                    col=m.start() + 1,
                    rule=rule.name,
                    message=rule.message,
                    match=m.group(0),
                )


def lint_file(path: Path, only_lines: set[int] | None = None) -> list[Finding]:
    """Lint one file, skipping code fences; optionally only given line numbers."""
    text = path.read_text(encoding="utf-8")
    return list(iter_findings(_relpath(path), text.splitlines(), only_lines))


def parse_diff_added_lines(diff: str) -> dict[str, set[int]]:
    """Map file path to the set of added line numbers (new-file numbering).

    Reads a unified diff (``git diff``). Deleted lines do not advance the
    new-file counter; context and added lines do.
    """
    result: dict[str, set[int]] = {}
    current: str | None = None
    new_lineno = 0
    hunk = compile(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@")
    for line in diff.splitlines():
        if line.startswith("diff "):
            current = None
        elif line.startswith("--- "):
            continue
        elif line.startswith("+++ "):
            target = line[4:].strip()
            target = target[2:] if target.startswith("b/") else target
            current = None if target == "/dev/null" else target
        elif line.startswith("@@"):
            m = hunk.match(line)
            if m:
                new_lineno = int(m.group(1))
        elif current is None:
            continue
        elif line.startswith("+"):
            result.setdefault(current, set()).add(new_lineno)
            new_lineno += 1
        elif line.startswith("-"):
            continue
        else:
            new_lineno += 1
    return result


def _git(args: list[str]) -> str:
    cmd = ["git", "-C", str(REPO_ROOT), *args, "--", *(f"{d}/" for d in CONTENT_DIRS)]
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    return proc.stdout


def _diff(base: str, staged: bool) -> str:
    args = ["diff", "--unified=0", "--no-color", *(["--cached"] if staged else []), base]
    return _git(args)


def _changed_files(base: str, staged: bool) -> list[str]:
    args = ["diff", "--name-only", "--no-color", *(["--cached"] if staged else []), base]
    return [ln for ln in _git(args).splitlines() if ln.strip()]


@click.command()
@click.argument(
    "paths",
    type=click.Path(exists=True, dir_okay=False, path_type=Path),
    nargs=-1,
)
@click.option(
    "--files", "whole_files", is_flag=True, help="Lint whole changed files, not only changed lines."
)
@click.option(
    "--staged",
    is_flag=True,
    help="Use staged changes (git diff --cached), e.g. for a pre-commit hook.",
)
@click.option("--base", default="HEAD", show_default=True, help="Git ref to diff against.")
@click.option(
    "--exit-code", is_flag=True, help="Exit 1 if any findings (for CI or an advisory hook)."
)
def main(
    paths: tuple[Path, ...],
    whole_files: bool,
    staged: bool,
    base: str,
    exit_code: bool,
) -> None:
    """Flag house-style issues in content markdown.

    With no PATHS, lints only the lines you have changed against --base
    (default HEAD). With --files, lints whole changed files. With explicit
    PATHS, lints those files in full. Never edits anything; report only.
    """
    findings: list[Finding] = []
    if paths:
        for p in paths:
            findings.extend(lint_file(p))
    elif whole_files:
        for rel in _changed_files(base, staged):
            p = REPO_ROOT / rel
            if p.suffix == ".md" and p.exists():
                findings.extend(lint_file(p))
    else:
        for rel, linenos in parse_diff_added_lines(_diff(base, staged)).items():
            p = REPO_ROOT / rel
            if p.suffix == ".md" and p.exists():
                findings.extend(lint_file(p, only_lines=linenos))

    findings.sort(key=lambda f: (f.path, f.line, f.col))
    for f in findings:
        click.echo(f"{f.path}:{f.line}:{f.col}: {f.message} [{f.rule}] -> {f.match!r}")

    n = len(findings)
    files = len({f.path for f in findings})
    if n:
        click.echo(f"\n{n} issue(s) in {files} file(s).")
    else:
        click.echo("clean - no house-style issues found.")
    if exit_code and n:
        sys.exit(1)


if __name__ == "__main__":
    main()
