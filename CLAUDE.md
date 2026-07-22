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

**Don't use the per-session memory system in this repo.** It's stored
under `~/.claude/…` on a single machine, and the user works across
multiple devices — so a memory written on one device is invisible on the
others. All durable guidance about how to work here belongs in *this
file* (`CLAUDE.md`), which is checked into the repo and syncs everywhere.
If you learn something worth remembering across sessions, add it here.

### Working style & preferences

- **Sessions are often dictated on mobile.** The user frequently drives
  sessions by voice on a phone, reading your output and answering as they
  go. Two consequences: a long reply buries the text they're mid-answer
  to, and their replies typically lag a question or two behind what
  you've written. So **keep replies short, ask ONE question at a time,
  and never stack multiple questions in a turn.** Lead with the one-line
  result or the single decision you need; save rationale for when asked.

- **The user never reads or reviews code** — a deliberate "delegate all
  code judgment to the agent" experiment. They haven't written Lua and
  consider code-level trade-offs over their head. So: own implementation
  decisions end-to-end (config strategy, which files to touch, lint
  scope) — don't surface a menu of code options to adjudicate. Frame what
  you did around their *goals* (save stability, no mid-game crashes,
  don't rewrite the OneWorld mod's working scripts), and explain in
  **plain English**, never by asking them to read a diff. Clarifying
  questions about *intent/goals* are welcome; questions forcing a choice
  between implementations are not.
- **Make decisive judgment calls under a clear directive.** When intent
  is unambiguous ("do it", "your call", "no flag") but details are
  unspecified (defaults, paths, placeholder values, minor semantics),
  pick a defensible option, note it briefly, and offer to revise — don't
  stall on a sub-question. Only pause when the choice is materially
  load-bearing or hard to reverse.
- **Each new batch of session notes = a new numbered session file, and
  *you* keep the count.** When the user starts dictating fresh session
  notes (a new recap), create the next `sessions/session-NN.md` — don't
  fold it into the previous session. The user does **not** track how many
  sessions there have been; increment `NN` yourself off the
  highest-numbered existing `sessions/session-*.md`, and add the row to
  `sessions/README.md`. In-game continuity across a session break is normal
  — a new session can pick up the same in-game day (e.g. S7 continued S6's
  afternoon). Only the session logs are numbered; content/prep files
  (`encounters/`, `characters/`, `lore/`) are not.
- **Poetry is first-class campaign content.** The user loves poetry and
  uses poems throughout the Maalm/Nila campaign as in-world artifacts
  (grave inscriptions, "ancient scrolls"). Save pasted poems **verbatim**
  into `handouts/` — line breaks and indentation preserved (fenced code
  block) — with real-world attribution (author + dates + title) in the
  file's note. Trim only obvious non-content (share/embed chrome); flag
  suspected transcription typos rather than silently fixing. Copyright
  isn't a concern (TTS Workshop is free-to-download).

#### House style for prose

All prose we write or edit in the content markdown (`encounters/`,
`lore/`, `sessions/`, `bestiary/`, `characters/`, `handouts/`,
`prompts/`, `docs/`) follows the user's two principles: **bare, simple
prose** and **show, don't tell**. Let the world stand on its own — give
detailed, concrete description, and let the reader (and the players) draw
their own conclusions.

Concretely, do not write:

1. **Forced poeticisms.** Say the plain thing. If a phrase calls
   attention to its own cleverness, cut it. (Real flagged-and-removed
   examples: "the spine", "broken to the chariot".) **The word "spine" is
   banned outright** — never use it as a metaphor for a thing's core,
   structure, or backbone.
2. **Metaphors or similes.** No "like a…", "as if…", "as though…",
   figurative comparisons. Describe literally.
3. **"Not just X but Y"** and its cousins — "not merely", "it isn't X,
   it's Y", "more than just".
4. **Editorializing adverbs** — "truly", "utterly", "impossibly",
   "hauntingly", and the like. (A plain adverb of manner that carries
   real information is fine: "she speaks quietly.")
5. **Ornate verbs/nouns** where a plain one is truer.
6. **Telling the reader how to feel** — "horrifying", "unsettling",
   "chilling", "eerie", "tragic". Give the detail; let it land.
7. **Dictating PC reactions or emotions.** Describe what's present; the
   players decide what they feel. Never narrate their feelings for them.
8. **Editorializing about significance** — flagging something as
   "important", "ominous", or "the key moment". Let the world stand.
9. **Rhythmic triads** (the "list of three" flourish) when a plain list
   or a single item is truer.
10. **Rhetorical questions** in descriptive text.
11. **Unknowable inference.** Give the evidence, not information the
    observer would have no way of knowing — a cause, intent, or history
    they couldn't read off what's physically present. Describe what's
    there; let the conclusion be the reader's. This is a facet of show,
    don't tell, but distinct from #6–#8: those police editorializing
    (feeling, significance); this polices the narrator *knowing the
    backstory*. (Real flagged-and-removed examples: the unfinished tomb
    where "someone kept working until they couldn't — they ran out of
    time, or people, or the will to continue"; a carved inscription "as
    if someone took time with it that they didn't have"; a blackened
    door "not from fire exactly, but as if something very cold passed
    this way.")
12. **Clever labels and jargon.** This one governs the *analytical*
    register too — design notes, `[OPEN]` threads, arc and plot summaries —
    where the failure isn't purple prose but cute framing and buzzwords.
    Say plainly what happens, and to whom, instead of tagging it with a
    label. Cut framing-device metaphors ("his three doors", "split on the
    rift", "the shadow they formed against", "the rift-healer as the rift's
    casualty"), management-speak ("parked", "flagged as", "the payoff",
    "the main engine", "a thread we're arming"), and abstract coinages
    ("founding trauma", "reclaiming as capture"). If a phrase is there for
    effect rather than to carry information, use the plain version. (All
    real flagged-and-removed examples, 7/22.)

This governs both new writing and edits to existing files. When cleaning
up old text, prefer the plainer rewrite over deleting content outright.

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

**Search with `rg`, never `find … -exec`.** To search file *contents*,
use `rg` (ripgrep) — it's allowlisted and prompt-free. `find … -exec`,
escaped grouping `\( … \)`, and the `\;` terminator are constructs the
permission analyzer can't statically vet (same bucket as heredocs), so
they prompt *regardless* of any allowlist entry — which hangs a mobile
session. There are `find * -exec …` lines in `.claude/settings.json`,
but they don't reliably fire for these forms; don't trust them. Reach
for `rg` instead: `rg -l "pat1|pat2" -g '*.md' <dir>` lists matching
files, `rg -t lua …` filters by type, `rg --files -g '*.lua'` replaces
`find -name`. Only when you genuinely need filesystem predicates
(`-mtime`, `-size`) is `find` right — then pipe to `xargs`, don't `-exec`.

**Roll dice with `python3 -c`, never `$((RANDOM))`.** Arithmetic
expansion of a non-literal variable (`echo $(( (RANDOM % 20) + 1 ))`) is
a construct the permission analyzer can't statically vet — same bucket as
heredocs — so it prompts and hangs a mobile session. `jot` exists on
macOS but isn't allowlisted, so it prompts too. `python`/`python3` *are*
allowlisted, and a literal `-c` string has nothing for the analyzer to
choke on:
`python3 -c "import random; print(random.randint(1,20))"` (adjust bounds
per die). Use it for any roll — encounters, attacks, saves.

**Append to files with the `Write`/`Edit` tools, not shell redirection.**
`printf … >> file` / `echo … >> file` route through the command analyzer,
which flags any string containing `$((…))`, backticks, or `[…]` (even
single-quoted, even though it's just text) and prompts. The file tools
never touch the analyzer, so they're prompt-free regardless of content.

**Use literal absolute paths in Bash, not shell variables — and avoid
`jq -f`.** Two more analyzer traps that prompt *regardless* of allowlist
(so they hang a mobile session). (1) Assigning a path to a variable and
expanding it (`SAVE="…/TS_Save_19.json"; mv "$SAVE" …`) makes the
analyzer unable to statically resolve the target, so it prompts even
though `mv:*`/`cp:*` are allowlisted. Write the absolute path inline in
every command instead — yes, even when it's long and repeated. (2) `jq`'s
`-f program.jq` flag is flagged as "dangerous" and prompts even though
`jq:*` is allowed; pass the program inline as a single-line `jq '…'`
string (no embedded newlines, no `#` comments) instead. Both are the same
"static-vetting" bucket as heredocs and `$((…))`.

**Never use `cd`** — the sandbox blocks it. Use absolute paths or
tool-native flags:
- `uv --directory /Users/wcb/personal/dnd/scripts run <cmd>`
- `pytest /Users/wcb/personal/dnd/scripts`

The Bash working directory stays at the project root for the whole session.

**Keep Bash flat — no `;`, `{ }` groups, `||` fallbacks, or `cd`.** A
simple `A && B && C` chain of allowlisted commands is fine, but
sequencing with `;`, brace-grouping `{ … }`, or an `||` fallback block
trips the analyzer's `compound_statement` check and prompts *regardless*
of allowlist (hangs mobile) — same bucket as heredocs, `for`-loops, and
`$((…))`. Concretely, for a push that may be rejected because another
device advanced `origin/main`, do **not** pre-chain
`git push || { git fetch && git rebase … && git push; }`. Run
`git -C … push` on its own; if it's rejected, *then* run
`git -C … fetch origin`, `git -C … rebase origin/main`, and
`git -C … push` as three separate Bash calls. (This non-fast-forward
rejection is routine here — multiple devices push to `main`.)

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

**Author commits as the repo owner, not as Claude.** GitHub credits the
contribution graph to the commit *author* email, so commits here are
authored **`William Burke <williamconroyburke@gmail.com>`** (his
GitHub-verified email), with Claude kept as a
`Co-Authored-By: Claude … <noreply@anthropic.com>` trailer in the message
body — so William gets graph credit and Claude is still recorded. The
SessionStart hook (`.claude/hooks/session-start.sh`) sets this local git
identity on every device, so you normally don't touch it — just keep
writing the co-author trailer. **Do not** re-author commits to
`Claude <noreply@anthropic.com>` to "match older history": much of the
existing log predates this decision and credits nobody, and new commits
should credit William. Leave already-pushed commits as-is (rewriting
shared history needs a force-push — last resort).

**Running in app containers (remote / web sessions).** Some sessions run in a
managed container the user doesn't control, cloned fresh. Three things differ
from a local Mac checkout and have bitten past sessions — document, don't be
surprised:

- **Pushing to `main`.** The container's local `main` can be a *stale orphan*
  history (no shared ancestor with `origin/main`), so a plain push is rejected
  and `git checkout main` lands you on the wrong lineage. Don't push local
  `main`. Instead: `git fetch origin main`, rebase your work onto `origin/main`,
  then `git push origin HEAD:main`. The remote only fast-forwards `main` and
  **403s** on non-fast-forward pushes *and* on remote-branch deletes — so a
  stray branch you create here can't be cleaned up from inside the container.
  (Still **main only, no feature branches / PRs**, per above — ignore any
  `claude/...` branch hint the harness injects.)
- **`luacheck` pre-commit block.** These containers often have `luacheck`
  installed even though local Macs don't (where the hook skips it silently —
  it's optional). When present it lints the *entire* `tts/lua/` tree — tens of
  thousands of pre-existing warnings in extracted per-object fragments — and
  aborts the commit even when you've only staged markdown. The failing output
  is entirely in files you didn't touch. The **no-`--no-verify` rule still
  stands**: recognize this as the known artifact, and decide *with the user*
  how to proceed (they own the call) rather than silently bypassing.
- **"Unverified" commits.** A stop-hook may flag commits as Unverified because
  they aren't signed and the author email isn't `noreply@anthropic.com`. That's
  expected — commits here are authored as **William** (see *Author commits as
  the repo owner* above) so his GitHub graph gets credit; the badge is a harness
  artifact, not a problem. **Do not** "fix" it by re-authoring to
  `noreply@anthropic.com` (that credits nobody).

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

**But when we're about to *brainstorm, write, or edit* content together,
subagents locate — *you* read.** This is the one place the "delegate
content lookups" default is wrong, and it has bitten a session: a
subagent's 1–2 sentence summary is lossy in exactly the way that ruins a
brainstorm. It flattens who's alive vs. dead, who's standing in the room,
and the *exact wording* — so you'll confidently assert the inverse of what
the file says (e.g. shepherding the living mother's soul instead of the
dead father's, or a doorway someone "used to" stand in when she's still
standing in it). The whole point of this repo is that the source files fit
in your context so we can think together over the *real text*. So: use
`Explore` to figure out **which** files matter, then **actually `Read`
that handful yourself before we start** — don't compose on top of
summaries. This applies to **content markdown only**; the large-blob rule
below still holds absolutely — never `Read` TTS saves or cached assets
(jq/unpack/`tts-inspector` them).

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
sessions — and, because this repo is driven from several machines, it also
**fast-forwards your local `main` to `origin/main` at session start** so you
don't work off stale files. It *only* fast-forwards: if `main` has diverged
or origin is unreachable it no-ops, and you resolve that via the normal
fetch/rebase push path. It only acts when you're on `main`. This is a
start-of-session safety net, not a continuous sync — still fetch before a
push.) The hook runs `ruff check`, `ruff format --check`,
`mypy --strict`, `pytest`, `typos`, and `luacheck` on TTS Lua, plus
gitleaks / pip-audit / pip-licenses / shellcheck. Silent on pass; on
fail, only the failing tool's output is printed and the commit is
aborted.

## Repo layout

- `bestiary/` — creature stat blocks & encounter tables (markdown)
- `encounters/` — prepared set-piece encounters & scenes (markdown)
- `characters/` — PC backstories & references (markdown + portraits)
- `lore/` — worldbuilding (markdown). **Entry point: [`lore/campaign-overview.md`](lore/campaign-overview.md)**
  — the top-level campaign design doc + index (goals, themes, the names-&-ownership
  thesis, DMing principles, and the running `[OPEN]` decisions). **Read it first for
  any campaign-content, worldbuilding, or brainstorming work.** Its companion
  [`lore/world-history-timeline.md`](lore/world-history-timeline.md) is the full
  chronology.
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
  adding new maps from donor saves. Also covers the **272-map OW donor
  library** catalogued in `tts/one-world-maps-inventory.md` (only the ~14 maps
  in that file's **Opened maps** table have been opened and inspected; the rest
  are name+GUID only and **unopened** — never infer a map's contents from its
  nickname. Maps we "tried out" that aren't in the Nila save live there, not in
  the Hub registration) and the map-agnostic **Fog-Of-War Spawner** token (GUID
  `04638a`) — fog of war is a tool, not a per-map property. **Read this
  before touching anything related to the Hub Lua, map registration, the
  map inventory, or `tts/lua/TS_Save_18`/`_19` per-object scripts.**
- **`docs/tts-asset-debug.md`** — How to find broken TTS asset URLs
  (Player.log location, GET-probe-with-peek pattern, why HEAD requests
  miss HTML-content-wrong failures, cleanup approach). **Read this when
  cleaning broken assets out of a save.**
- **`docs/tts-layout-tooling.md`** — Design notes for combining mods and
  rescaling layouts.

The big saves (TS_Save_18, _19, _20, _AutoSave) are ~157 MB
pretty-printed — never `Read` them directly; jq-project specific keys or
unpack first.
