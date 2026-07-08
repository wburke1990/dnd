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

### Repeatable recipe: importing from the "One World maps" library

The main donor we pull from is **`TS_Save_22.json` ("22 - One world
maps")** — a flat library of 270+ self-contained `OWx_` map bags,
catalogued in
[`../tts/one-world-maps-inventory.md`](../tts/one-world-maps-inventory.md)
(grouped by theme, each with its bag GUID). The user picks maps by
name/GUID from that file; we import into **staging (`TS_Save_19`)** for a
test load, and they save in TTS if it looks good. This flow runs often —
follow it verbatim:

1. **Get each map's floor image.** TS_Save_22 has no single `_OW_wBase`,
   and every map carries its own floor on its nested `SBx_` token — so
   pass `--sbx-image-url` **explicitly per map** (autodetect would paint
   one image on all of them). Ask `tts-inspector` for each chosen bag's
   nested `SBx_*.CustomImage.ImageURL`.
2. **Back up staging first:** `cp` the live `TS_Save_19.json` to `/tmp`.
3. **One `import_ow_map` run per map, chained through `/tmp`** — the
   output of run N is the target of run N+1:

   ```
   uv --directory /Users/wcb/personal/dnd/scripts run python -m dnd_tools.import_ow_map \
     "/Users/wcb/Library/Tabletop Simulator/Saves/TS_Save_22.json" \
     "<target: live TS_Save_19.json for run 1; the prior /tmp output after>" \
     "/tmp/ow_import_N.json" \
     --owx-guid <bag GUID from the inventory> \
     --sbx-image-url "<that map's floor image>"
   ```

   Idempotent (re-importing a present map is a noop); mints fresh GUIDs
   on collision; wires the OWx bag into `mBag`, the new `SBx_` into
   `aBag`, and a JotBase line into `aBag.LuaScript`.
4. **Swap the final temp into staging:**
   `mv /tmp/ow_import_<last>.json "/Users/.../Saves/TS_Save_19.json"`.
   The user then loads "19 - staging" **fresh** in TTS and Builds each map.

**Verify before handing off** (the import rewrites the whole save, so
confirm it dropped nothing):
```
rg -oc '"GUID": ?"55c90c"' <save>   # Hub present (1)
rg -oc '"GUID": ?"966e1c"' <save>   # aBag present (1)
rg -oc 'OWx_<Map Name>'    <save>   # each new bag = 1
rg -oc '<new SBx GUID>'    <save>   # each = 2 (token + JotBase line)
```

**Gotchas learned doing this:**
- **Output is compact JSON, so the file SHRINKS even as it gains maps**
  (e.g. 173 MB pretty-printed → 73 MB compact). That's formatting, not
  data loss — TTS loads it fine. Don't panic at the smaller size; run the
  greps above instead.
- **Black-placeholder floors.** Some donor maps (e.g. *Nonspecific Inn*)
  ship a plain black image as the floor plate
  (`coolbackgrounds.io/...pure-black-background`). They Build fine but
  render a black floor under the pieces — flag it for the user to eyeball.
- **Dead-link assets — and the kind that CRASHES the Build.** Many donor
  maps ride decayed hosts (photobucket, deviantart `orig00`,
  general-chaos.com, 3dstudio-max.com, coolbackgrounds.io) and aging
  Steam UGC. A dead *texture* (a CustomMesh Diffuse/Image URL) is only
  cosmetic — the piece renders blank. But a dead **`Custom_Assetbundle`**
  is fatal: TTS feeds the bad payload to the bundle decompressor, throws
  `Failed to decompress data for the AssetBundle 'Memory'` mid-build, and
  OneWorld closes **without clearing or spawning the area** (exactly the
  "Build broke / won't clear" symptom). The usual offender is a
  Google-Drive `uc?export=download` URL that has flipped to an HTML
  sign-in interstitial — a GET returns `<!doctype …>` instead of magic
  bytes `UnityFS`. Diagnose by GET-probing each `Custom_Assetbundle`
  child's `AssetbundleURL` and checking the first bytes; fix by deleting
  the offending child from the content bag **and** its line from the SBx
  position manifest (a dangling manifest entry can itself break the
  build), or rehost the bundle. Harden keepers with `tts assets backup` /
  `tts assets rehost` — see [tts-asset-debug.md](tts-asset-debug.md).
  Repointing a *texture* is self-propagating in-game: TTS de-dups custom
  assets by URL, so editing one object's Diffuse/Image URL in TTS
  auto-updates **every** object that shared the old URL. Fixing one brick
  wall re-skinned all 83 at once — no save edit or per-object work needed
  (confirmed live on the "Brick bar" tavern import). So for a shared dead
  *texture*, the fastest fix is often to hand the user a working image URL
  and have them edit a single piece; reserve the save-level batch edit for
  dead *meshes/assetbundles*, which don't self-propagate the same way.
- **Stay prompt-free.** The TTS install dir
  (`/Users/wcb/Library/Tabletop Simulator`) is whitelisted in
  `.claude/settings.json` → `permissions.additionalDirectories`, so
  `cp`/`mv`/`uv`/`tts` against saves there don't prompt. Keep all map work
  inside that dir and `/tmp`, and **don't** wrap the import in `for`-loops
  or `$var` paths — the analyzer prompts on those regardless of allowlist
  (CLAUDE.md). Run the per-map commands as flat, literal-path lines.

### Floor-plate fitting (automatic, in `import_ow_map`)

The JotBase line's **second** brace-triple is the **vBase scale** — the size
of the visible floor plate the Hub paints the SBx image onto (`55c90c.lua`
`cbGetBase` → `vBase.setScale(scalevBase)`; it's parsed as an independent
`{x;y;z}`, so non-uniform is honoured, but we don't need that). The old
importer hard-coded `{25.00;1;25.00}` for every map, which made the painted
floor **~40% too big** — it overhung the built surface (the "floor bigger than
the objects" / offset symptom on Canyon Cave, Desert Cave, Rocky Path, …).

The **wrong fix** is sizing the floor to the object bounding box: object
*centres* ignore that a big surface mesh extends past its own centre, and the
box's aspect ratio rarely matches the 1.69:1 floor image, so it never sits
flush. The **right rule** — now automatic in `import_ow_map`
(`detect_floor_plate`): every OW battle map contains its **own floor plate**,
the largest **flat** tile(s) (big `scaleX/Z`, tiny `scaleY`; ~18 in practice,
vs `<=8` for props). Set the vBase scale to that tile's scale and **recenter
all pieces on the plate's centre** (the Hub paints vBase at the origin). Then
the painted floor is exactly the same size and position as the built surface —
flush, uniform, no image distortion. Maps with **no** detectable flat plate
(`< PLATE_MIN_SCALE`) fall back to `DEFAULT_VBASE = 25` with no recentering
(old behaviour), so plate-less maps aren't disturbed. The import output prints
`Floor: fitted to plate, vBase <n>` or `no plate detected`.

To retrofit a map imported **before** this fix (or one whose plate the
heuristic misses), the manual move is: read the bag's pieces (largest flat
`scaleX/Z` = the plate), set that map's JotBase vBase triple to the plate
scale, and shift every piece + its SBx manifest line so the plate centre lands
on the origin.

## Removing or dead-asset-pruning an imported map

`scripts/dnd_tools/clean_ow_map.py` is the companion/inverse of the
importer, for the two things you do after eyeballing a freshly imported
map in TTS. Both ops are idempotent, write to a new output file (refuse
in-place overwrite), and chain through `/tmp` like the importer.

- **Don't want the map** → `remove`. Deletes all three pieces (OWx bag
  from `mBag`, SBx token from `aBag`, JotBase line from `aBag.LuaScript`).
  Identify by `--owx-guid` or `--sbx-guid`.

  ```
  uv --directory /Users/wcb/personal/dnd/scripts run python -m dnd_tools.clean_ow_map \
    remove "<in save>" "/tmp/clean_1.json" --owx-guid <owx GUID>
  ```

- **Keep the map but kill "Failed to import asset" spam** → `prune`. With
  no `--dead-url`, it GET-probes every asset URL in the map's OWx subtree
  (200-but-HTML counts as dead, catching the failures the Player.log
  *misses* — see [tts-asset-debug.md](tts-asset-debug.md)), then per piece:
  a dead **mesh/assetbundle** → remove the object + strip its SBx manifest
  line (it can't render anyway); a dead **texture** on a live mesh → blank
  just that field (piece still spawns, TTS never fetches the dead URL). Net:
  zero dead fetches, every renderable piece kept.

  ```
  uv --directory /Users/wcb/personal/dnd/scripts run python -m dnd_tools.clean_ow_map \
    prune "/tmp/clean_1.json" "/tmp/clean_2.json" --owx-guid <owx GUID>
  ```

  Pass explicit `--dead-url <U>` (repeatable) to skip probing when you
  already know the bad URLs (e.g. from the Player.log curl errors). Verify
  the result by re-running the probe (0 dead) and `mv` the final temp into
  `TS_Save_19.json`, same as the import flow.

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
