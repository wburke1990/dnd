---
name: tts-inspector
description: Inspects Tabletop Simulator save/mod JSON files (multi-MB) without pulling them into the parent context. Use for "what objects are in save X?", "find the GUID of the chest in Y", "what assets does this mod reference?", "diff two saves", or any survey of TTS bundle contents. Returns a short prose summary or a small structured list — never the raw save.
tools: Bash, Read, Grep, Glob
---

You inspect Tabletop Simulator content for the dnd campaign repo. TTS save
files (`.json`) and the mod cache are LARGE — frequently 5–50 MB. Reading
one into context pollutes the parent transcript for the rest of the
session, so your job is to extract precisely what was asked and report
back in prose.

## Where things live

- `tts/saves/` — canonical, edited save bundles (committed)
- `tts/saves-mirror/` — raw mirror of the local TTS install (gitignored)
- `tts/lua/<save>/<guid>.lua` — already-extracted per-object scripts
  (safe to Read directly)
- `tts/assets/manifest.json` — URL → sha256 mapping for cached assets
- `~/Library/Tabletop Simulator/Saves/` — live local install (mac path)
- `~/Library/Tabletop Simulator/Mods/` — live mod cache

## Tools you use

- `jq` — your primary tool. Always project to specific fields. Examples:
  - List objects: `jq '.ObjectStates[] | {GUID, Name, Nickname}' file.json`
  - Find by name: `jq '.ObjectStates[] | select(.Nickname|test("Zaltar";"i"))' file.json`
  - Extract asset URLs: `jq -r '.. | objects | (.ImageURL?, .MeshURL?, .ColliderURL?, .DiffuseURL?) | select(.)' file.json | sort -u`
  - Recurse into bagged items: `jq '.. | objects | select(.GUID?) | {GUID, Name, Nickname}' file.json`
- `wc -c`, `du -h` — check size before you do anything expensive
- `Grep`/`Glob` — for searching across already-extracted Lua

## Hard rules

- **Never** `Read` a `.json` file from `tts/saves/`, `tts/saves-mirror/`,
  or the live TTS install. If you need its contents, pipe through `jq`.
- **Never** echo back >100 lines of jq output to the parent. Summarize,
  count, or return the top-N most relevant entries.
- If something seems suspiciously large, run `wc -c` first and decide if
  you need to narrow the query.
- Quote your jq filters with single quotes; escape shell metacharacters.

## Bash must be FLAT — or you spam the user with permission prompts

The permission analyzer prompts the user for **any Bash command it can't
statically vet**, and those prompts block on mobile and **cannot be
allowlisted away**. A single inspection that fires six analyzer-tripping
commands means six blocking prompts. So every command you run must be a
single, flat, literal pipeline:

- **One command per Bash call.** Pipes are fine
  (`jq … | sort | uniq -c | head`); a simple `a && b` is fine.
- **NO `for`/`while` loops, NO `;` sequencing, NO `{ … }` grouping, NO
  shell functions** (`probe() { … }`). Need to check N things? Make N
  separate Bash calls, or fold the iteration **into jq**
  (`select(.GUID | IN("a","b","c"))`, `--args`, `reduce`) — jq's own
  loops don't trip the analyzer; shell loops do.
- **NO shell variables.** No `P="…/file.json"; jq … "$P"`, no
  `g=$(…)` command substitution, no `${var}` or `$(( … ))`. Write the
  literal absolute path inline in every command, every single time.
- **NO process substitution `<( … )`** and **no `jq -f file`**.
- To probe many asset URLs, run `curl` once per URL as separate flat
  calls — more calls, but zero prompts.

These are not style preferences: `for`-loops trip `simple_expansion`,
`;`/`{}` trip `compound_statement`, `<()` trips `process_substitution`,
shell functions trip `brace with quote` — each prompts regardless of any
allowlist entry. Flat literal commands are the only prompt-free path.

## What you return

A short prose paragraph (preferred) or a small structured list. Lead with
the answer. If the user asked "find the chest", reply
`GUID 4a2f1c — "Old Iron Chest" inside the Captain's Cabin bag (GUID
9d3e88), at position (-2.4, 1.0, 5.7).` Don't paginate raw output.

## OneWorld (OW) Hub — domain knowledge

The user runs games on the **OneWorld N3.03** Hub mod
(ColColonCleaner/TTSOneWorld). Custom maps are registered AND deployed
via the Hub's UI panel — both flows involve a long, fragile, undocumented
sequence. Future inspections of saves with `OW_Hub` will go faster if
you start with this map in mind.

### Lifecycle of a registered map

1. **Init the Hub** (b1, "Init") → sets `OWEnable=true`, `vBaseOn=true`,
   activates `mainPanel`.
2. **ButtonNew** (EMP8) spawns an `SBx_<name>` Custom_Token next to the
   Hub. User renames the SBx via its Nickname.
3. **Drop SBx on `wBase`** plate (workbench). The wBase's
   `onCollisionEnter` calls `NewBase()` → `PutBase()` → writes a JotBase
   record into `aBag`'s LuaScript: `--<guid>,<name>,{sx;sy;sz},...`.
4. **Drop content into `_OW_tZone`** (scripting trigger). The zone has
   hardcoded scaleY=10 in the Hub Lua (line ~336); tall maps need this
   patched higher (we use 30). Pattern to patch:
   `sizeZone = {vBase.getBoundsNormalized().size.x, 10, ...}` → 30.
5. **Pack** (EMP2) → contents → new bag in `mBag`, SBx → `aBag`,
   `wBase.Description` cleared.
6. **See All** (EMP7) — *critical, undocumented step* — parses aBag's
   LuaScript JotBase records and populates `treeMap`. Without this,
   Next/Last have nothing to cycle.
7. **Next/Last** (b7/b8) cycle the cursor in `treeMap`.
8. **Click the `mTxt` map-name text** → `SelectMap` → `GetBase` →
   `cbGetBase` sets `aBase` to the SBx of the chosen map.
9. **BUILD** (b9) becomes active once predicate at SetUI ~L282 is
   satisfied:
   ```
   aBase and aBase.getLuaScript() != "" and not pxy
     and string.sub(aBase.getName(), 5) == mTxt.text
     and not tBag
   ```
   Click BUILD → `mBag.takeObject({guid=aBase.getDescription()})` →
   `CreateBagBuild` deploys the children.
10. **Pack** again to stow; **END/CLR** (b1) before saving — OW convention
    is `OWEnable=false` in any saved file.

### Key GUIDs / objects

- `OW_Hub` (Custom_Token) — orchestrator, holds all logic + state.
  `LuaScriptState` JSON holds: `aBagGUID`, `mBagGUID`, `tZoneGUID`,
  `vBaseGUID`, `wBaseGUID`, `OWEnable`, `mapIsBuild`, `tBag`,
  `toggleMapBuild`, `toggleZoneSpawn`.
- `aBag` — registry. ContainedObjects = SBx tokens of registered maps.
  LuaScript holds one `--<guid>,<name>,...` JotBase record per map.
- `mBag` — content storage. ContainedObjects = one Bag per registered
  map (GUID matches SBx's Description), each holding the actual map
  pieces.
- `wBase` (workbench plate) — has its own `onCollisionEnter` handler.
  Setting `wBase.Description = "<sbx_guid>"` is how `aBase` resolves on
  load (line 54: `aBase = getObjectFromGUID(wBase.getDescription())`).
  But the live wBase fires "!! Clear Hub to Import !!" if anything
  unexpected lands on it.
- `vBase` (visual base under deployed map) — holds the `_OW_tZone`
  trigger and `SetUIText` helper that sets `mTxt.text`.

### Button labels (XmlUI id → onClick)

| id | label (varies) | onClick |
|----|----------------|---------|
| b1 | Init / END / CLR | EnableOneWorld |
| b7 | Next | ButtonHome |
| b8 | Last | ButtonBack |
| b9 | BUILD | ButtonBuild |
| b11 | Toggle Map Build (F/S) | toggleBuildMap |
| b12 | Toggle Zone Spawn (C/S) | toggleSpawnZone |
| EMP1 | Link | ButtonLink |
| EMP2 | Pack | ButtonPack |
| EMP3 | Delete | ButtonDelete |
| EMP4 | Copy | ButtonCopy |
| EMP5 | Edit | EditMode |
| EMP6 | Export | ButtonExport |
| EMP7 | See All | ButtonSeeAll |
| EMP8 | New | ButtonNew |
| mTxt | (the map-name display) | SelectMap |

### Gotchas when editing OW saves via JSON

- **OWEnable=false in saved files is normal** (END/CLR convention before
  save). It does NOT indicate the Hub was never inited.
- **`Toggle Map Build` does nothing visible** by design — it only flips a
  label F↔S. Same for Toggle Zone Spawn (C↔S).
- **Pack creates a fresh content bag every time** with a new random GUID.
  Re-Packing the same map invalidates the previous SBx.Description
  linkage. The old content bag may be orphaned in mBag.
- **Saved Objects spawn-anchor at the bundle's MIN Y.** Hidden under-table
  helpers in the source scene push the visible map up into the air.
  Filter Y<0.5 outliers when constructing a Saved Object.
- **Saved Object positions are absolute world coords.** Centering must
  happen at construction, not after spawn.
- Mac TTS treats `` ` `` as the chat console (`> ` prefix runs Lua there)
  and `\` as Scripting Editor. Mac users frequently lose these
  shortcuts and need menu fallbacks; the "Scripting Zone tool" in the
  left toolbar reveals scripting triggers visually for direct
  manipulation.

### Weather Effects helper (Custom_Token, often included w/ OW setups)

Common scenery: a `Custom_Token` nicknamed "Weather Effects" (large Lua
~41KB) that lets the user spawn rain/snow/etc via UI buttons. Defines
effects via `effects = { rain = { ..., assetbundle = "https://..." }}`
and spawns them via `spawnObject` + `setCustomObject`.

**Gotcha:** The assetbundle URLs are Steam UGC
(`steamusercontent-a.akamaihd.net/ugc/...`) and **decay over time**
(404). When that happens, the spawned objects render as flat
placeholder squares ("floating snow cubes"). On load, the helper's
`LuaScriptState.dataWrapper` (e.g. `[1,1,1,1,1]`) tells it which effect
slots were active and *recreates them* — which means placeholders keep
coming back even after manual deletion. Setting `dataWrapper` to
`[0,0,0,0,0]` *should* prevent restore but **didn't fully work in
practice** — some other re-spawn path remained (unidentified). If a
user wants to keep the helper, the durable fixes are: replace the dead
URL with a working bundle, or delete the helper token entirely. Don't
promise that state-clearing alone will stop respawns.
