"""Generate the campaign's indexes from per-file frontmatter.

Every content file carries two frontmatter fields, ``summary`` and ``status``.
Its region and kind are read off its path, not stored, so they cannot drift
from where the file actually sits. This walks the tree and writes:

* ``INDEX.md`` at the repo root — every region, every file, one line each.
* ``world/<region>/README.md`` — that region's files grouped by kind.
* a generated block inside ``characters/``, ``handouts/`` and ``sessions/``
  READMEs, leaving the hand-written prose in those files alone.

``--check`` writes nothing and exits non-zero when an index is stale or a
content file is missing frontmatter, which is how the pre-commit hook keeps
the index honest as files are added.
"""

from __future__ import annotations

import os.path
import sys
from dataclasses import dataclass
from pathlib import Path

import click

REPO_ROOT = Path(__file__).resolve().parents[2]

BEGIN = "<!-- BEGIN GENERATED INDEX -->"
END = "<!-- END GENERATED INDEX -->"

# What a file is to the table, in the order the tables list them: what is
# live first, what is unfinished next, what is behind us last.
#
# Two of these mean "done" and are not interchangeable. ``played`` is a table
# fact — this scene was run. ``completed`` is a writing fact — this file is
# finished and no more work is planned on it, as against ``reference``, which
# is durable material that may still grow. A region whose lore is ``reference``
# rather than ``completed`` is one that still needs writing before you get
# there.
STATUSES = ("next", "ready", "draft", "idea", "played", "completed", "reference")

# Directory name -> heading used for that group of files.
KINDS = {
    "lore": "Lore",
    "encounters": "Encounters",
    "bestiary": "Bestiary",
    "prompts": "Image prompts",
}

# The flat directories, which are not keyed to a place.
FLAT = ("characters", "handouts", "sessions", "references")

# Region -> the one-line orientation printed above its table. Regions not
# listed here still index; they just get no gloss.
REGION_NOTES = {
    "suartleheim-eet": "The SE landmass, and the campaign's home ground.",
    "suartleheim-eet/maalm": "The conquest-city and the Valley of the Kings. Played out.",
    "suartleheim-eet/brauron": (
        "The peach town, the game preserve and the hell-tree. Off the map, "
        "on the coast north of Raand."
    ),
    "suartleheim-eet/raand-copaa": "Raand, Copaa, Aar and the Haals mines.",
    "musleheim": "The fire island: the Muspel empire and the orc wars.",
    "kuru": "The NE landmass, the Order of Sunne and the phoenix.",
    "lonka": "Jotunheim, the dragonborn origin and the Bleeding Star.",
    "kalikhat": "The north coast strip, and the gates of the underworld.",
    "the-sea": "Sailing, weather, fleets and what lives in the water.",
    "nila": "The world itself: cosmology, history, rules, and the powers that span regions.",
}


@dataclass(frozen=True)
class Doc:
    """One content file, and what the index needs to know about it."""

    path: Path
    summary: str
    status: str

    @property
    def rel(self) -> str:
        return self.path.relative_to(REPO_ROOT).as_posix()

    @property
    def title(self) -> str:
        return self.path.stem.replace("-", " ")


def _display(path: Path) -> str:
    """A path for messages, repo-relative when it sits under the repo."""
    try:
        return path.relative_to(REPO_ROOT).as_posix()
    except ValueError:
        return path.as_posix()


class MissingFrontmatter(Exception):
    """Raised when a content file has no usable frontmatter."""

    def __init__(self, path: Path, reason: str) -> None:
        super().__init__(f"{_display(path)}: {reason}")


def parse_frontmatter(text: str) -> dict[str, str]:
    """Read ``key: value`` pairs from a leading ``---`` fenced block."""
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---", 4)
    if end == -1:
        return {}
    fields: dict[str, str] = {}
    for line in text[4:end].splitlines():
        key, sep, value = line.partition(":")
        if sep and not key.startswith(" "):
            fields[key.strip()] = value.strip().strip('"').strip("'")
    return fields


def read_doc(path: Path) -> Doc:
    fields = parse_frontmatter(path.read_text())
    summary = fields.get("summary", "")
    status = fields.get("status", "")
    if not summary:
        raise MissingFrontmatter(path, "no summary in frontmatter")
    if status not in STATUSES:
        raise MissingFrontmatter(path, f"status {status!r} not one of {', '.join(STATUSES)}")
    return Doc(path=path, summary=summary, status=status)


def content_files() -> list[Path]:
    """Every markdown file the index covers, READMEs excluded."""
    found: list[Path] = []
    for kind in KINDS:
        found += sorted((REPO_ROOT / "world").rglob(f"{kind}/*.md"))
    for flat in FLAT:
        found += sorted((REPO_ROOT / flat).glob("*.md"))
    return [p for p in found if p.name != "README.md"]


def regions() -> list[str]:
    """Region directories, deepest-qualified first within their landmass."""
    world = REPO_ROOT / "world"
    names = {
        p.parent.parent.relative_to(world).as_posix()
        for kind in KINDS
        for p in world.rglob(f"{kind}/*.md")
        if p.name != "README.md"
    }
    return sorted(names)


def table(docs: list[Doc], base: Path) -> list[str]:
    """A markdown table of docs, links written relative to ``base``."""
    if not docs:
        return []
    order = {s: i for i, s in enumerate(STATUSES)}
    rows = ["| File | Status | What it is |", "|---|---|---|"]
    for doc in sorted(docs, key=lambda d: (order[d.status], d.path.name)):
        rel = _relative(doc.path, base)
        rows.append(f"| [{doc.title}]({rel}) | `{doc.status}` | {doc.summary} |")
    return rows


def _relative(target: Path, base: Path) -> str:
    return os.path.relpath(target, base).replace("\\", "/")


def region_block(region: str, docs: list[Doc], base: Path) -> list[str]:
    lines: list[str] = []
    note = REGION_NOTES.get(region)
    if note:
        lines += [note, ""]
    for kind, heading in KINDS.items():
        of_kind = [d for d in docs if d.path.parent.name == kind]
        if not of_kind:
            continue
        lines += [f"### {heading}", ""]
        lines += table(of_kind, base)
        lines += [""]
    return lines


def build_root_index(by_region: dict[str, list[Doc]], flat: dict[str, list[Doc]]) -> str:
    base = REPO_ROOT
    lines = [
        "# Campaign index",
        "",
        "Generated by `build-index` from each file's frontmatter — edit the files, not this.",
        "Run `uv --directory scripts run build-index` to refresh.",
        "",
        "Start with [the campaign overview](world/nila/lore/campaign-overview.md) for the",
        "design doc, and [the atlas](world/nila/lore/nila-atlas.md) for where places are.",
        "",
        "## Regions",
        "",
        "| Region | Files | What it is |",
        "|---|---|---|",
    ]
    for region in sorted(by_region):
        note = REGION_NOTES.get(region, "")
        link = _relative(REPO_ROOT / "world" / region / "README.md", base)
        lines.append(f"| [{region}]({link}) | {len(by_region[region])} | {note} |")
    lines.append("")

    for region in sorted(by_region):
        lines += [f"## {region}", ""]
        lines += region_block(region, by_region[region], base)

    for name in FLAT:
        docs = flat.get(name, [])
        if not docs:
            continue
        lines += [f"## {name}", ""]
        lines += table(docs, base)
        lines += [""]

    return "\n".join(lines).rstrip() + "\n"


def inject(path: Path, block: str) -> str:
    """Put ``block`` between the generated markers, preserving the rest."""
    existing = path.read_text() if path.exists() else ""
    wrapped = f"{BEGIN}\n\n{block.rstrip()}\n\n{END}"
    if BEGIN in existing and END in existing:
        head, _, rest = existing.partition(BEGIN)
        _, _, tail = rest.partition(END)
        return f"{head}{wrapped}{tail}"
    if existing.strip():
        return f"{existing.rstrip()}\n\n{wrapped}\n"
    title = path.parent.name
    return f"# {title}\n\n{wrapped}\n"


def render() -> dict[Path, str]:
    """Every file the generator owns, mapped to its intended contents."""
    docs = [read_doc(p) for p in content_files()]
    world = REPO_ROOT / "world"

    by_region: dict[str, list[Doc]] = {}
    flat: dict[str, list[Doc]] = {}
    for doc in docs:
        if doc.path.is_relative_to(world):
            region = doc.path.parent.parent.relative_to(world).as_posix()
            by_region.setdefault(region, []).append(doc)
        else:
            top = doc.path.relative_to(REPO_ROOT).parts[0]
            flat.setdefault(top, []).append(doc)

    out: dict[Path, str] = {REPO_ROOT / "INDEX.md": build_root_index(by_region, flat)}

    for region in regions():
        readme = world / region / "README.md"
        body = "\n".join(region_block(region, by_region.get(region, []), readme.parent))
        heading = f"# {region}"
        block = f"{heading}\n\n{body}"
        out[readme] = inject(readme, block).rstrip() + "\n"

    for name in FLAT:
        if name not in flat:
            continue
        readme = REPO_ROOT / name / "README.md"
        body = "\n".join(table(flat[name], readme.parent))
        out[readme] = inject(readme, body).rstrip() + "\n"

    return out


@click.command()
@click.option("--check", is_flag=True, help="Report staleness instead of writing.")
def main(check: bool) -> None:
    """Regenerate INDEX.md and the per-directory README index tables."""
    try:
        wanted = render()
    except MissingFrontmatter as exc:
        click.echo(f"build-index: {exc}", err=True)
        sys.exit(1)

    stale = [p for p, text in wanted.items() if not p.exists() or p.read_text() != text]
    if check:
        if stale:
            for path in stale:
                click.echo(f"build-index: stale {path.relative_to(REPO_ROOT).as_posix()}", err=True)
            click.echo("build-index: run `uv --directory scripts run build-index`", err=True)
            sys.exit(1)
        return

    for path, text in wanted.items():
        path.write_text(text)
    click.echo(f"build-index: wrote {len(stale)} of {len(wanted)} files")


if __name__ == "__main__":
    main()
