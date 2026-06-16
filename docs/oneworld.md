# OneWorld Hub — State Model & Map Import

The OneWorld (OW) Hub is a custom in-save TTS system used in both Nila
(`TS_Save_18`) and staging (`TS_Save_19`) to register, switch between,
and spawn/pack named "maps" (e.g. *Nila*, *Wizards_Tower*, *Maalm*,
*Dockside City*). Map state lives in the **save JSON Description
fields**, not in `LuaScriptState`.

This doc covers:
1. The stable GUIDs and three-piece registration model.
2. The script that imports a new map from a donor save.
3. The Hub-fork edits that diverge from upstream Borbold OW.

## Stable GUIDs

Hold across both Nila and staging:

- **Hub**  `55c90c` (Custom_Token, nickname `OW_Hub`)
- **aBag** `966e1c` (Bag — registered `SBx_<Name>` icon tokens live in
  `ContainedObjects`, JotBase registry lives in its `LuaScript`)
- **mBag** `c30535` (Bag, nickname `Tra`, description `_OW_mBaG` —
  holds the `OWx_<Name>` content bags)
- **wBase** `1053f5` (Custom_Token, nickname `_OW_wBase`)
- **vBase** `7722b8` (Custom_Token)

Registered map GUIDs (in `aBag.LuaScript` JotBase lines):
Nila `afb258`, Wizards_Tower `811bc1`, Maalm `e36d30`,
Tomb_2 `ec9fd3`, Suartleheim_E `ae806c`, Nila_Labelled `6a8217`,
Valley_Kings `14c578`, Desert `43c681`, Tomb_0/1/3 `fb0696`/`01d3f9`/`e6834b`.

**Known broken pointer (as of 2026-06):** `SBx_Wizards_Tower` points
at OWx GUID `1cfa04`, which doesn't exist anywhere in `TS_Save_19.json`.
Its Build would crash with `<ButtonBuild>: Value cannot be null` —
pre-existing issue, unrelated to imports.

## Three-piece map registration

Adding a new map means wiring all three pieces or the Hub
crashes / hides the Build button:

1. **`OWx_<Name>` Bag inside `mBag.ContainedObjects`** — the packed
   content. `ButtonBuild` calls
   `mBag.takeObject({guid = SBx.Description})`, so a content bag stored
   anywhere else (top-level, in some other bag) crashes Build with
   `<ButtonBuild>: Value cannot be null`. The OWx bag's own
   `Description` should be **empty** — working examples like
   Wizards_Tower's `1cfa04` have it empty, and the Hub doesn't read it
   for linkage.

2. **`SBx_<Name>` Custom_Token inside `aBag.ContainedObjects`** with:
   - `Description = <OWx bag GUID>` — the linkage `cbGetBase` reads
   - `CustomImage.ImageURL = <floor image>` — painted onto wBase on click
   - non-empty `LuaScript` containing per-child position manifest lines
     `--<child_guid>,posX,posY,posZ,rotX,rotY,rotZ,1\n`. The Build button
     is **gated by `aBase.getLuaScript() != ""`** (`SetUI` predicate
     around L295). Floats MUST avoid scientific notation; manifest scale
     lives on each child's `Transform.scaleX/Y/Z` in the OWx bag itself,
     NOT in the manifest.

3. **JotBase line in `aBag.LuaScript`** matching format
   `--<sbx_guid>,<map_name>,{1.85;1;1.85},{25.00;1;25.00},0,0,2,0,`
   (followed by `(x;z)(w;h)@<linked_guid>,` per cross-link if linked).

## Three load-bearing Description pointers

- **`aBag.Description = "_OW_aBaG_<guid>"`** — the **home** map
  (`treeMap[1]`). After the Hub-fork Init/Home/Back fixes, this is the
  one true source for "what map should Init land on". Strip the 9-char
  prefix with `string.sub(desc, 10)` to get the bare GUID.
- **`wBase.Description = "<guid>"`** — the **currently selected** SBx.
  `cbGetBase` updates this on each map switch. `onLoad` seeds `aBase`
  via `getObjectFromGUID(wBase.getDescription())` — which returns nil
  if the SBx is stowed in aBag, hence the Hub-fork workaround using
  `homeGuid`.
- **`Hub.LuaScriptState.OWEnable`** — if true, `onLoad` auto-runs
  `ContinueUnit` and resumes. Set to false to land on the Init screen.

## Hub-fork edits (diverge from upstream Borbold OW)

Both `tts/lua/TS_Save_18/55c90c.lua` (Nila) and
`tts/lua/TS_Save_19/55c90c.lua` (staging) carry four local edits:

1. `ButtonNew` spawns Custom_Token with a hard-coded URL
   (`raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg`)
   instead of `CONFIG.IMAGE_ASSETS.NEW_MAP_TOKEN`.
2. `TogleEnable`'s first-activate branch (`not vBaseOn`) pulls the home
   SBx out of `aBag` via `GetBase(homeGuid)` if PutVariable left
   `aBase` nil. Fixes the upstream bug where Init lands in "no map"
   view when the home SBx is stowed.
3. `ButtonHome` no-aBase branch defaults to `GetBase(homeGuid)`
   instead of `treeMap[2]` (which is just the first line of
   `aBag.LuaScript` — Tomb_2).
4. `ButtonBack` no-aBase branch likewise defaults to home instead of
   the last `treeMap` entry.

`homeGuid` in all four post-fix branches is derived from
`aBag.Description` (format `_OW_aBaG_<guid>`):
`local homeGuid = string.sub(aBag.getDescription(), 10)`.

If a future task asks to update the Hub Lua, edit the per-save file
directly. The two save forks are kept in sync by copying staging → Nila
after verification. **Don't re-derive a "clean" Hub from upstream** —
you'll lose these four fixes.

## Importing a new OW map

`scripts/dnd_tools/import_ow_map.py` registers an `OWx_<Name>` content
bag from a donor save (e.g. `docks` / `TS_Save_23.json`) into a target
save so the Hub can build it. It wires up all three pieces atomically,
handles GUID collisions, and is idempotent.

```
uv --directory /Users/wcb/personal/dnd/scripts run python -m dnd_tools.import_ow_map \
    "<donor save path>" "<target save path>" "<output save path>"
```

CLI flags `--owx-guid`, `--map-name`, `--sbx-image-url`, `--abag-guid`,
`--mbag-guid` override autodetection. Output goes to a new file
(refuses to overwrite the target in place). Re-running on an
already-imported target is a noop.

**Donor saves often carry dead asset URLs** that travel into the
import. See [tts-asset-debug.md](tts-asset-debug.md) for the cleanup
pattern.

## Edit workflow for the Hub or aBag Lua

```
# 1. Unpack — extracts per-object Lua + manifest to tts/lua/<save>/
uv --directory /Users/wcb/personal/dnd/scripts run tts unpack TS_Save_19

# 2. Edit tts/lua/TS_Save_19/55c90c.lua (or whichever object)

# 3. Pack directly into the live TTS install — don't write to tts/saves/,
#    which is uncommittable until the LFS-vs-gitignore call (CLAUDE.md).
uv --directory /Users/wcb/personal/dnd/scripts run tts pack TS_Save_19 \
  --out "/Users/wcb/Library/Tabletop Simulator/Saves/TS_Save_19.json"

# 4. (If editing non-Lua state) walk ObjectStates + ContainedObjects in
#    Python and patch Description / LuaScriptState fields. jq can read
#    them but mutating a 156 MB file in jq is awkward.

# 5. Commit only the changed Lua file. The save itself stays untracked.
```

The big saves (`TS_Save_18`, `_19`, `_20`, `_AutoSave`) are ~157 MB
pretty-printed — **never `Read` them**. Always `jq`-project specific
keys or unpack first.
