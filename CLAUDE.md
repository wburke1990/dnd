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
- **Never rewrite what a player wrote about their own character.** The
  individual **PC sheets** — `characters/blackacre.md` (Sam),
  `aniess.md` (Greg), `sarric.md` (Jeremy), `jasper.md` (Doug),
  `pax.md` (Andrew) — and the player-submitted concepts in
  `party-roster.md` are the **players'**: their backstory, personality, and
  choices belong to them, not to us. You may add clearly-marked DM notes and
  lean on their characters in encounter/lore prep, but do **not** rewrite,
  reinterpret, or "improve" the player-written parts. When prep needs a PC's
  psychology, describe how the **world or an NPC** plays off what the player
  established — don't put new motives in the PC's head. (NPC files in
  `characters/` — Preem, Mul, the al Qahtani, Lucrecia, and the like — are
  DM-written and fair game.) **Keep our notes in a companion file, not the
  player sheet.** DM-facing prep about a PC — connections, how the world
  plays off them, our readings of their backstory — lives in
  `characters/<pc>-dm-notes.md` (e.g. `jasper-dm-notes.md`), so the sheet
  stays the player's and the boundary is a file boundary, not a matter of
  remembering. The player sheet links to its companion at the top; the
  companion links back. Migrate existing DM sections out of a sheet the
  next time you touch it.
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

**One test, run on every sentence before it is committed:** cross out each word
doing a job other than stating what literally happens, or what is literally there.
If the crossing-out kills a coined label (*the warning ladder*, *the reform-loop*),
a significance-flag (*this is the heart of it*, *the centerpiece*, *the picture the
whole set-piece is built around*), an attributed feeling (*the party gets to feel
clever*), or a figure of speech (*another shell*, *the roof of the dungeon*), it was
ornament — keep the literal remainder. The numbered list below spells out the
recurring ways prose fails this test; the test itself is the part to remember. (All
the example phrases here are real, cut 7/22.)

**Design notes fail this test in their own way.** Descriptive prose reaches for
poetry; prep and design notes reach for labels and salesmanship — giving a sequence,
a mechanic, or a scene a coined name, flagging how much it matters, or predicting how
the table will react. In a design note: name the sequence, state the mechanic,
describe the moment, and stop. Do not sell it to yourself.

**Two checks help, and they split the work.** The regex linter **`prose-lint`**
(see the CLI quick reference) flags the *fixed* offenders below on your changed
lines — it's cheap, deterministic, and already wired into the pre-commit hook as a
non-blocking advisory, so it runs on every commit. But it only catches patterns
someone has encoded; a coined label it has never seen (a fresh "Underdark cradle")
sails past. So for **new or edited prose, also run the `prose-critic` subagent** on
the changed file before committing (see *Prefer subagents*). It reads only that one
file — never the lore — so its ear stays naive and it catches the novel coinages
and flourishes the regex can't. When the critic keeps catching the same new
coinage, add a regex for it to `prose-lint` so the cheap gate absorbs it. Neither
is the test; the test is the cross-out above.

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
13. **Oblique constructions.** Clipped, gnomic phrasing that gestures at a
    thing instead of stating it — "it is there to be seen", "the way in that
    is not a fight", "sources run together". They read as unfinished. Name
    what is there and what happens. (The linter's `gnomic-passive` rule
    catches the "there to be X" form; the rest need the eye. Cut 7/28, when
    a whole doc came out "almost unreadable" this way.)

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

**This applies to search *subagents* too — they are the usual culprit.** An
`Explore`/`general-purpose` agent left to its own devices will often reach for
a raw `grep … | while read f; do … done` loop, and that compound statement
prompts on mobile *regardless* of the allowlist (the pipe-into-`while`-`do`-`done`
shape can't be statically vetted — same bucket as heredocs). The subagent's
prompt surfaces to the user just like the parent's would. It is **not only the
`grep|while` shape** — a `for f in …; do test -f …; done` existence check, or any
`&&`/`||` chain, trips the same `compound_statement` gate and prompts too. So when
you spawn an agent to search, **tell it in the prompt to avoid shell control flow
entirely:** use `rg` (piping to `xargs` for per-file follow-up), use the `Glob`/`Read`
tools or a single `ls`/`rg` to check what exists — **no loops, no `test -f`, no
`&&`/`||` chains.** Any loop or compound statement a search agent emits prompts the
user, even a harmless file-existence check.

**Roll dice with `python3 -c`, never `$((RANDOM))`.** Arithmetic
expansion of a non-literal variable (`echo $(( (RANDOM % 20) + 1 ))`) is
a construct the permission analyzer can't statically vet — same bucket as
heredocs — so it prompts and hangs a mobile session. `jot` exists on
macOS but isn't allowlisted, so it prompts too. `python`/`python3` *are*
allowlisted, and a literal `-c` string has nothing for the analyzer to
choke on:
`python3 -c "import random; print(random.randint(1,20))"` (adjust bounds
per die). Use it for any roll — encounters, attacks, saves. **But keep
inline `-c` strings free of `#` comments** — a newline followed by `#`
inside a quoted argument trips the analyzer's path-validation check and
prompts (same bucket). Put no comments in inline Python; for anything
beyond a one-liner, write a scratchpad `.py` file and run it with
`uv --directory …/scripts run python <file>` instead.

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

**Don't ask permission to commit — just commit and push, then keep
going.** "Want me to commit now or keep going?" is the wrong move: the
answer is always both. Commit each working change as you finish it,
push it, and carry on — even mid-brainstorm, even when more edits to the
same files are likely. Small, frequent commits are the house default.

**Never bypass the pre-commit hook with `--no-verify`.** If a check fails,
fix the underlying issue.

**Author commits as the repo owner, not as Claude.** Commits here are
authored **`William Burke <williamconroyburke@gmail.com>`** (his
GitHub-verified email), with Claude kept as a
`Co-Authored-By: Claude … <noreply@anthropic.com>` trailer in the message
body. The SessionStart hook (`.claude/hooks/session-start.sh`) sets this
local git identity on every device, so you normally don't touch it — just
keep writing the co-author trailer. **Do not** re-author commits to
`Claude <noreply@anthropic.com>` to "match older history": much of the
existing log predates this decision, and new commits are authored as
William. Leave already-pushed commits as-is (rewriting shared history
needs a force-push — last resort).

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
- **`luacheck` pre-commit block — fixed, 8/5.** This used to abort container
  commits: `luacheck` is installed there, it linted the *entire* `tts/lua/`
  tree, and tens of thousands of pre-existing warnings in files you hadn't
  touched would fail a markdown-only commit. It now lints only *staged* Lua, so
  a commit that touches no Lua doesn't run it at all. If you meet this again,
  the fix is a real one — the **no-`--no-verify` rule still stands**.
- **"Unverified" commits.** A stop-hook may flag commits as Unverified because
  they aren't signed and the author email isn't `noreply@anthropic.com`. That's
  expected — commits here are authored as **William** (see *Author commits as
  the repo owner* above); the badge is a harness artifact, not a problem.
  **Do not** "fix" it by re-authoring to `noreply@anthropic.com`.

### Prefer subagents — heavily, and aggressively

Session cost scales **quadratically** with transcript length, so push work
into subagents via `Agent` to keep the parent short. The default answer
to "should I delegate this?" is **yes**.

**Project-specific subagents** (defined under `.claude/agents/`):

- `tts-inspector` — for **any** question about TTS save/mod JSON.
  Saves are multi-MB and will wreck your context if you `Read` or `cat`
  them. Use for "what's in this save", "find this object's GUID",
  "what assets does mod X reference", "diff two saves".
- `prose-critic` — the house-style critic for **content prose**. Hand it a
  content-markdown file (or a line range) before committing new or edited prose;
  it returns flagged spans with plain rewrites. It reads **only** the file you give
  it — never the lore — on purpose, so it stays the naive ear that hears the
  coinages a marinated writer stops noticing. Style only; it never judges lore or
  accuracy. The regex `prose-lint` is the cheap gate; this is the smart pass — the
  two are complements, not substitutes.

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

**gitleaks is required, and its absence aborts the commit** (`brew install
gitleaks`). The security checks fail closed on purpose: they used to skip
silently when the binary was missing, and the skip notice only printed to a
TTY — so on a machine without gitleaks, every agent-driven commit went
unscanned and looked exactly like a clean one. `pip-audit` still tolerates an
unreachable pypi.org, since that's transient rather than a misconfiguration,
but now says so whether or not anyone is watching.

**`shellcheck` is required too** (`brew install shellcheck`), and it lints
`.claude/hooks/*.sh` as well as `.githooks/*` — `session-start.sh` downloads a
binary and installs it as root, so it shouldn't be the one unlinted script in
the repo. **`luacheck` lints only *staged* Lua**, not the whole tree, and stays
optional. `uv lock --check` fails the commit when `scripts/pyproject.toml` has
drifted from `uv.lock`, which is how an unpinned, unscanned dependency would
otherwise slip in.

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
- `scripts/` — uv-managed Python: the `tts`, `pad-maps`, and `prose-lint` CLIs
  + tests
- `.githooks/pre-commit` — silent-on-success quality + security checks

## CLI quick reference

**Always invoke the CLIs through uv — there is nothing to install.** `tts`,
`pad-maps`, and `prose-lint` are entry points of the `scripts/` package, not
binaries on PATH. Calling them bare exits 127 on every machine. Run them as:

```
uv --directory /Users/wcb/personal/dnd/scripts run <cmd> [args]
```

This is deliberate, and it is the *only* supported form — local and cloud alike.
It resolves the command inside `scripts/.venv`, the environment pinned by
`scripts/uv.lock` and used by the pre-commit hook, so what you run by hand and
what the hook runs are the same program. `uv tool install` would work, but it
builds a *second*, unlocked venv that silently drifts from the locked one; we
tried it and the two disagreed on a dependency version within a day. Don't.

`uv` itself is broadly allowlisted, so the prefixed form never prompts.

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

prose-lint                # house-style linter for content markdown; flags
                          # coined labels, significance-flags, similes, etc.
                          # (the CLAUDE.md rules). Default: only your changed
                          # lines vs HEAD; --files = whole changed files;
                          # PATHS = those files. Report-only, never edits.
```

## Applying & debugging a live-save Lua fix

Two lessons from a long initiative-tracker debugging session, to skip the
repeat:

- **To apply an edited object script, pack only that object.** Copy the one
  edited `tts/lua/<save>/<guid>.lua` into a scratch dir and
  `tts pack <save> --from <scratch-dir> --out "<live install save>"` (back the
  save up first). Packing the whole `tts/lua/<save>/` dir would re-inject every
  object; the single-file `--from` dir touches only that GUID (`Injected 1 Lua`).

- **TTS must be fully quit and relaunched to load an injected Lua change.** A
  mid-session reload — and a Resume/autosave load — silently keeps the *old*
  script in memory, so a correct fix looks like it failed. This was the actual
  cause of a multi-hour loop where each new "fix" appeared not to work; the code
  had been right for a while and the session was stale. When a packed fix seems
  to do nothing, rule this out *first*: fully quit TTS, relaunch, Load the named
  save (not autosave).

- **When a TTS Lua fix "doesn't work," don't trust a mock-based test.** A harness
  built on hand-written mocks encodes your assumptions and passes while the game
  fails. Load the *real* object scripts with their *real* `LuaScriptState` and run
  the actual code offline — see `scripts/tests/lua/real_reset_runtime.lua`
  (loads real `DNDMiniInjector_Mini` fixtures + the injector, runs the real
  reset). Extract an object's script/state from the save with a small Python
  walker over `GUID` (a mini can appear several times — a table copy plus bagged
  and stale copies; the table copy is the live one).

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
