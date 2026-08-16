# dnd

A personal D&D campaign repo with two jobs:

1. **Campaign content in markdown** — worldbuilding, NPCs/bestiary,
   encounters, lore, quotes, and AI image prompts. Content is filed by
   place under `world/<region>/`; `characters/`, `handouts/`, `sessions/`
   and `references/` stay flat. Plain markdown so the whole campaign
   stays diffable and can be republished (e.g. to Tabletop Simulator)
   word-for-word.
2. **Tabletop Simulator pipeline** — sync the local TTS install, edit
   Lua scripts with proper linting, splice mods together, and back up
   Steam Workshop assets so links can never break the world.

**[`INDEX.md`](INDEX.md) is the way in** — every region and every file
with a one-line summary and whether it has been played. It is generated
from each file's frontmatter and rebuilt by the pre-commit hook.

See [`CLAUDE.md`](CLAUDE.md) for the collaboration model, repo layout,
and CLI quick reference.
