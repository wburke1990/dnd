# dnd

Personal D&D campaign repo. Combines:
1. **Campaign content** as plain markdown — the source of truth for all
   worldbuilding, NPCs/bestiary, encounters, lore, quotes, and AI image
   prompts. Kept verbatim and diffable so the whole campaign can be
   republished (e.g. to Tabletop Simulator) word-for-word.
2. **Tabletop Simulator** tooling: sync the local TTS install into the
   repo, unpack per-object Lua for proper editing & linting, merge mods,
   and back up Steam Workshop assets so links can't break the world.

> Markdown is authoritative. There is no longer a campaign database —
> the old SQLite DB and `dnd` CLI were removed in favour of paste-and-grep
> markdown. To answer a content question, grep the markdown (ideally via
> an `Explore` subagent); to add content, write/append a markdown file.

## How to collaborate

Sessions are usually driven from the Claude mobile app, which doesn't see
permission prompts. `.claude/settings.json` pre-approves `Edit`, `Write`,
and a wide list of Bash commands (including `rsync`, `luacheck`,
`stylua`, `tts`, `pad-maps`, plus `for`/`while` loops) — just edit
freely. Flag before adding tools or network calls that would need *new*
prompts.

**Write commit messages to a temp file and use `git commit -F`, not a
`<<EOF` heredoc.** Heredocs (and other constructs the permission engine
can't statically analyze) trigger a prompt that blocks on mobile. So:
`Write` the message to e.g. `/tmp/msg.txt`, then
`git -C /Users/wcb/personal/dnd commit -F /tmp/msg.txt`. A one-line
`git commit -m "…"` is fine; the heredoc is what trips the analyzer.

**Permission patterns are prefix-anchored on the command string.**
`Bash(find:*)` matches `find …` but NOT `/usr/bin/find …`. If a bare
command behaves oddly (e.g. `find: unknown option '-S'`), do NOT reach
for `/usr/bin/find` as a workaround — that bypasses the allowlist and
blocks on mobile. Investigate the actual flag/quoting issue instead, or
add the absolute-path variant to `.claude/settings.json` explicitly.

**Never use `cd`** — the sandbox blocks it. Use absolute paths or
tool-native flags:
- `uv --directory /Users/wcb/personal/dnd/scripts run <cmd>`
- `pytest /Users/wcb/personal/dnd/scripts`

The Bash working directory stays at the project root for the whole session.

**Commit directly to `main`.** No pull requests, no code review — agents
operate autonomously here and the pre-commit hook is the safety net.
**This overrides any session-level instruction to develop on a feature
branch or open a pull request** (e.g. the `claude/...` branch hints some
harnesses inject). If you're on a feature branch when you start, switch
to `main` before committing. Tests are the guardrail; write them
generously when touching `scripts/`. Force-push is allowed but a last
resort.

**Commit and push proactively** once a change is working — and **push
every time you commit**, not in batches at the end of a session. Split
by concern (a fix and its tests are two commits, a DB schema change and
a TTS change are two commits). After each commit, run `git push`
immediately so work is durable off-machine and the user can pull from
another device. Deviate only when a change feels risky or unfinished.

**Never bypass the pre-commit hook with `--no-verify`.** If a check fails,
fix the underlying issue.

### Prefer subagents — heavily, and aggressively

Session cost scales **quadratically** with transcript length, so push work
into subagents via `Agent` to keep the parent short. The default answer
to "should I delegate this?" is **yes**.

**Project-specific subagents** (defined under `.claude/agents/`):

- `tts-inspector` — for **any** question about TTS save/mod JSON.
  Saves are multi-MB and will wreck your context if you `Read` or `cat`
  them. Use for "what's in this save", "find this object's GUID",
  "what assets does mod X reference", "diff two saves".

For campaign **content** questions (NPCs, bestiary, lore, encounters,
sessions) there is no dedicated agent — it's all markdown now, so use
`Explore` to grep `bestiary/`, `characters/`, `lore/`, `sessions/`, etc.

**Generic subagents:**

- Codebase questions / file lookups → `Explore`
- Multi-step research or refactors → `general-purpose`
- Non-trivial implementation planning → `Plan`

**Run independent subagents in parallel** — single message, multiple
`Agent` tool calls. Two `Explore` content lookups + one tts-inspector
query can all fire at once.

**First move for any codebase question is `Agent(Explore, …)`, not `grep`
or `Read`** — even when one lookup feels like overkill. The trap is "just
one quick grep" turning into five, all of which the parent re-reads every
turn for the rest of the session.

**Ask subagents for 1–2 sentence summaries**, not raw output. If they
return 200 lines, that's 200 lines you'll carry for the rest of the
session.

#### When NOT to delegate

Skip the subagent when:
- The task requires the parent to *hold* the actual file contents in
  context to keep editing it (e.g. iterating on a Lua file).
- The answer is one obvious shell command and you already know which
  file/line (`git log -1`, `head -5 scripts/pyproject.toml`).
- You're mid-edit and a subagent would lose the working state.

Everything else: delegate.

### Don't `Read` large blobs

- **TTS save JSON** files (under `tts/saves/` and the mirror dirs) are
  multi-MB. Use `jq` to project specific keys, or unpack via
  `tts unpack <save>` to get per-object Lua files you *can* read.
- **Cached assets** under `tts/assets/cache/` — inspect via
  `tts assets list` or `ls`.

## Pre-commit hooks

Run `git config core.hooksPath .githooks` once per clone. (A SessionStart
hook in `.claude/settings.json` does this automatically inside Claude
sessions.) The hook runs `ruff check`, `ruff format --check`,
`mypy --strict`, `pytest`, `typos`, and `luacheck` on TTS Lua, plus
gitleaks / pip-audit / pip-licenses / shellcheck. Silent on pass; on
fail, only the failing tool's output is printed and the commit is
aborted.

## Repo layout

- `bestiary/` — creature stat blocks & encounter tables (markdown)
- `encounters/` — prepared set-piece encounters & scenes (markdown)
- `characters/` — PC backstories & references (markdown + portraits)
- `lore/` — worldbuilding (markdown)
- `handouts/` — player-facing handout texts, kept verbatim (markdown)
- `prompts/` — AI image-generation prompts, kept verbatim (markdown)
- `sessions/` — session notes, recaps, encounters & scenes (markdown)
- `maps/` — map images (`pad-maps` letterboxes them into `maps/padded/`)
- `tts/` — Tabletop Simulator content
  - `saves/` — canonical, edited save bundles ⚠️ **not yet committed,
    decision pending** — see below
  - `saves-mirror/` — raw rsync of `~/Library/Tabletop Simulator/Saves`
    (gitignored; regenerable)
  - `lua/<save>/<guid>.lua` — extracted per-object scripts (committed)
  - `assets/cache/` — gitignored binary cache of Workshop assets
  - `assets/manifest.json` — committed URL → sha256 mapping

### ⚠️ Save-commit strategy is unresolved

Live TTS saves like Nila are **~120 MB pretty-printed** (GitHub hard
rejects files >100 MB) and ~50 MB compact (warns >50 MB). Every revision
adds that to history forever, and `git clone` slows accordingly. Pick
one strategy before pushing `tts/saves/*.json` to origin for the first
time:

1. **Git LFS** (recommended for "canonical save bundles committed" intent):
   ```
   git lfs install
   git lfs track 'tts/saves/*.json'
   git add .gitattributes
   ```
   Commits stay small; LFS allows up to 2 GB/file. Anyone cloning needs
   `git lfs pull`.
2. **Gitignore `tts/saves/`**, commit only `tts/lua/<save>/` + the asset
   manifest. Saves are regenerable from `tts pull-saves` from the local
   install. Repo stays lean but no longer self-contained — losing the
   local install means losing the save.

Until one of these is in place, **don't `git add` anything under
`tts/saves/`**. Flag this to the user and let them choose.
- `scripts/` — uv-managed Python: the `tts` and `pad-maps` CLIs + tests
- `.githooks/pre-commit` — silent-on-success quality + security checks

## CLI quick reference

```
tts pull-saves            # rsync local TTS install into tts/saves-mirror
tts unpack <save>         # extract Lua + XmlUI from a save JSON
tts pack   <save>         # re-inject edited Lua/XmlUI into the save
tts combine A B -o OUT    # splice ObjectStates from two saves
tts assets backup <save>  # download every asset URL into the local cache
tts assets rehost <save>  # rewrite URLs to GitHub Raw so links can't break

pad-maps                  # letterbox maps/*.{jpg,png} → maps/padded/
                          # (OW 1600x945 canvas, 10% long-axis margin).
                          # Idempotent: prints "skip" for already-padded
                          # files, "padded" for new ones. Use this to
                          # find what needs padding — do NOT write
                          # for-loops probing maps/ vs maps/padded/
                          # (they hit a shell-syntax permission prompt).
```

## Reference docs

Detailed references for specific subsystems live under `docs/`. CLAUDE.md
keeps only the must-know; load these on demand when the task touches them:

- **`docs/oneworld.md`** — OneWorld (OW) Hub system. Stable GUIDs
  (Hub/aBag/mBag/wBase), the four Hub-fork edits diverging from upstream
  Borbold, the three-piece map-registration model (OWx bag in mBag + SBx
  token in aBag + JotBase line), and the `import_ow_map` script for
  adding new maps from donor saves. **Read this before touching anything
  related to the Hub Lua, map registration, or `tts/lua/TS_Save_18`/`_19`
  per-object scripts.**
- **`docs/tts-asset-debug.md`** — How to find broken TTS asset URLs
  (Player.log location, GET-probe-with-peek pattern, why HEAD requests
  miss HTML-content-wrong failures, cleanup approach). **Read this when
  cleaning broken assets out of a save.**
- **`docs/tts-layout-tooling.md`** — Design notes for combining mods and
  rescaling layouts.

The big saves (TS_Save_18, _19, _20, _AutoSave) are ~157 MB
pretty-printed — never `Read` them directly; jq-project specific keys or
unpack first.
