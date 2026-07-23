# TTS Mod Combination & Layout Tooling — Design

Status: **scoping / not yet implemented**
Last updated: 2026-05-30

## Goal

Combine two Tabletop Simulator mods — a **D&D table** (with per-player
drawers + DM screen/area) and a **highly detailed castle** — into one
playable save, then fix the things a naive additive load can't:

1. **Recenter the castle.** Additive load drops it off-center on the
   board. It's hundreds of *locked* pieces, so unlocking/grouping by hand
   is impractical.
2. **Resize the minis.** Player minis are the wrong scale relative to the
   castle assets. (Same operation we want anyway for Enlarge/Reduce.)
3. **Slide adjacent areas to make room.** Player drawers + DM area are
   independent floating objects; they must translate outward — *with the
   objects resting on them* — so the bigger castle fits.

The castle is already loaded at the **right size**, so resizing the castle
itself is out of scope; we only recenter it.

## Key research findings (2026-05-30, cited)

Confidence: ✅ verified across sources · ⚠️ single source / tested in the running game.

### Coordinate system & transforms
- ✅ **Y-up, left-handed (Unity).** Floor plane is **X–Z**; Y is height.
  `{0,0,0}` is the **center of the table/room**.
  (kb.tabletopsimulator.com/game-tools/gizmo-tool/)
- ✅ `Transform` = `posX/Y/Z`, `rotX/Y/Z` (**Euler degrees**),
  `scaleX/Y/Z` (**default 1.0**).
  (kb.tabletopsimulator.com/custom-content/save-file-format/,
  api.tabletopsimulator.com/object/)
- ⚠️ No universal real-world unit (depends on mesh export). Table-surface
  Y is not an official constant (empirically posY ≈ 1.0–1.3).
- ⚠️ Euler application order is undocumented by Berserk (Unity uses
  Z→X→Y; inferred). Irrelevant to recenter/scale since we don't rotate.

### Scale & the footprint problem (load-bearing)
- ✅ **`scale` is a unitless multiplier** on the mesh's native size
  (`{2,2,2}` = 2× default, not 2 units). (api.../object/ `getScale`)
- ✅ **No bounding box / size / dimensions are stored anywhere in the save
  JSON.** Only size-adjacent stored field is `CustomImage.WidthScale`
  (tiles/tokens only). (matanlurey/tts-save-format schemas)
- ✅ **True world dimensions exist only at runtime**: `getBounds()` (AABB
  in global axes, rotation-aware) and **`getBoundsNormalized()`** (size as
  if un-rotated — the stable footprint). Both account for scale.
  (api.../object/)
- ➡️ **Consequence:** an accurate footprint cannot be computed from JSON
  alone without downloading & parsing meshes. Runtime
  `getBoundsNormalized()` gives it for free. **This kills the earlier
  offline `--mesh` measurement idea.**

### Object relationships
- ✅ **No CAD-style constraints / parent graph.** Objects are independent
  rigidbodies. (tts-community.github.io/api/object/)
- ✅ **Snap points** guide placement only; don't bind. Stored top-level
  (`SnapPoints`) and per-object (`AttachedSnapPoints`).
- ✅ **Joints** (`jointTo`, Fixed/Hinge/Spring) physically link objects;
  unreliable inside bags. **Attachments** (`addAttachment`) re-create the
  child as a true child GameObject that **moves *and* scales as one unit**
  and survives bagging. (api.../object/, patch notes v12.3)
- ✅ **The table surface is NOT an object in `ObjectStates`.** `Table` is a
  top-level **string** (built-in type, e.g. `"Table_Octagon"`); a custom
  table mesh is the separate **`TableURL`** string. The drawers/DM
  props, however, *are* normal objects. (matanlurey SaveState schema)

### Do objects resting on a surface follow it when it moves?
| Move method | Carries objects on top? |
|---|---|
| Hand-drag in-game | **Only if base `Sticky=true`** (a stored per-object field) |
| Scripted `setPosition` | **No** — target only |
| `setPositionSmooth` | No — may *shove* via collision, unreliable |
| Offline JSON edit | **No** — only that Transform changes |

- ✅ Reliable ways to keep a drawer + contents together: `addAttachment`
  (true child), or **detect contents and move them by the same offset**.
- ✅ Detection at runtime via **`Physics.cast` type=3 (Box)** sized to the
  drawer footprint, cast upward → returns every `hit_object` resting on
  it. (api.../physics/)
- ⚠️ `Sticky` is documented for *player* pickup only — not confirmed to
  trigger on scripted moves (evidence suggests it does not).

### Scripting / automation
- ✅ `getObjects`, `getObjectFromGUID`, `getObjectsWithTag`;
  `getBounds`/`getBoundsNormalized`; `Physics.cast`; `setPosition`/
  `setScale`; `addAttachment`/`jointTo`; `group()` (only G-groupable
  types — cards/chips, **not** arbitrary models).
- ✅ **Locking does NOT block scripted `setPosition`** (verified: 2 of 3
  sources; a third claim to the contrary was refuted). Locking blocks
  physics/hand-dragging only. ⚠️ `setPositionSmooth` on locked objects
  has mixed reports — prefer instant `setPosition`, or test.
- ✅ Global **XML UI `<Slider onValueChanged="fn"/>`** fires continuously
  during drag → call `setPosition` live. ⚠️ Callback value may arrive as
  a **string** — `tonumber()` it. (api.../ui/inputelements/)

### Ecosystem
- ✅ **No mature "merge two saves" tool exists** — this repo's
  `tts combine` is already ahead of the field. Hand-editing `ObjectStates`
  is the norm.
- Editors: Atom plugin is **dead**; live successors are VS Code
  `rolandostar/tabletopsimulator-lua` and `sebaestschjin/tts-editor`, both
  over the **External Editor API (TCP 39999)** — pushes/pulls **Lua + XML
  UI only** (no direct transform API), but `executeLuaCode` runs arbitrary
  Lua in Global, so transforms can be driven live. Port opens only once a
  game is loaded.
- Schema to borrow: `matanlurey/tts-save-format` (Draft-07 JSON Schemas;
  ⚠️ ~v12-era — missing object `Tags`, snap-point `Tags`). Other libs:
  `ikegami/tts_save`, `dkhex/TTSutil`.
- Single movable build: right-click model → Custom → Bag → Import (models
  only), or in-game Stage + Saved Object.

## Architecture decision: hybrid, leaning runtime Lua

Because **true footprints and "what's resting on this drawer" only exist
at runtime**, the *spatial* work belongs in injected Lua, not offline JSON
math. Split by what each side is good at:

### Offline (the repo's `tts` CLI — repeatable, version-controlled)
1. **Identify castle GUIDs by diff.** We have the original castle/table
   saves → castle pieces = objects in combined but not in the original
   table save. Emit a GUID list (and/or stamp them with a `Tags` entry).
2. **`tts rescale`** — multiply `Transform.scale` for a `--guids` set by a
   `--factor` (e.g. minis). Single objects, no resting-contents issue.
   Doubles as the Enlarge (×2) / Reduce (×0.5) utility. Offline-safe.
3. **Global Lua/XmlUI injector** — inject the layout-helper script + the
   slider UI via existing `pack` (already round-trips global `LuaScript`/
   `XmlUI`). **Requires a ~5-line fix:** `pack_save()` extracts global
   `LuaScriptState` but does not re-inject it (tts_save.py ~135-140) —
   mirror the LuaScript write so slider/helper state persists.
4. **Assets** — `tts assets backup` + `rehost` on the combined result.

### Runtime (injected Lua, driven live in-game)
5. **Recenter the castle** — union `getBoundsNormalized()` over the castle
   set → compute X/Z offset to table center → `setPosition` all (works on
   locked pieces; no unlock needed). No mesh parsing.
6. **Slide player areas** — per drawer/area anchor: `Physics.cast` a box
   upward sized to its footprint to grab its contents, then move the
   anchor + contents by the same delta. Wire to **two symmetric X/Z
   sliders** (one spreads the ±X pair, one the ±Z pair) so the layout
   stays centered. This structurally prevents the slide-off problem.

**Non-obvious win:** `getBoundsNormalized` + `Physics.cast` replace all
mesh downloading/parsing. Drop the offline `--mesh` measurement path
entirely.

## Grouping model (rectangular table)

- ✅ Decision: **four edge groups** (±X, ±Z), driven by **two symmetric
  sliders**. Radial spread is rejected — it distorts a rectangle and walks
  centers outward, risking slide-off.
- Group membership for the slide: anchor object (drawer) + whatever
  `Physics.cast` finds resting on it. No hand-tagging required.
- If the player areas turn out to be true **containers** (contents *inside*
  the drawer, in `ContainedObjects`), contents move for free and the
  Physics.cast step is unnecessary — verify per-mod.

## Open questions (resolve against the real saves)

- Are the player areas flat surfaces with separate objects on top
  (needs Physics.cast) or containers (contents move for free)?
- Is the D&D "table" the built-in `Table`/`TableURL`, or built from
  Custom_Model objects? Affects what "table center" means for recenter.
- Mini identification: by object `Name` type (`Figurine`/`Custom_Model`),
  by `Nickname` matching characters, or an explicit GUID list?
- Desired mini scale factor vs. castle (eyeball + iterate, or a measured
  ratio via runtime bounds).
- Whether to also wrap the castle as a single movable unit (bag/attach)
  for future hand-repositioning, or leave pieces individually placed.

## Testing strategy

- Offline: synthetic save fixtures (known positions/scales) → assert
  `rescale` factor math, GUID-diff identification, global Lua/XmlUI +
  `LuaScriptState` round-trip through `pack`/`unpack`. Match the existing
  `scripts/tests/test_tts_save.py` style.
- Runtime Lua: validated in the running game (the External Editor API on 39999 +
  `executeLuaCode` enables a fast edit/run loop without full save cycles).

## Decisions log

- ✅ Hybrid offline-CLI + runtime-Lua; spatial work goes runtime.
- ✅ Recenter via runtime `getBoundsNormalized`, not offline mesh parsing.
- ✅ Castle GUIDs via diff against retained originals.
- ✅ Two symmetric X/Z sliders over four edge groups (not radial).
- ✅ Minis resize stays offline (`tts rescale`, repeatable; = Enlarge/
  Reduce).
- ✅ Castle resize out of scope (already correct size).
- ⏸️ Implementation deferred (this doc is the scope).

## Sources

- https://kb.tabletopsimulator.com/game-tools/gizmo-tool/
- https://kb.tabletopsimulator.com/custom-content/save-file-format/
- https://api.tabletopsimulator.com/object/
- https://api.tabletopsimulator.com/physics/
- https://api.tabletopsimulator.com/ui/inputelements/
- https://api.tabletopsimulator.com/externaleditorapi/
- https://github.com/matanlurey/tts-save-format
- https://kb.tabletopsimulator.com/game-tools/snap-point-tool/
- https://kb.tabletopsimulator.com/game-tools/joint-tool/
- https://github.com/rolandostar/tabletopsimulator-lua-vscode
- https://marketplace.visualstudio.com/items?itemName=sebaestschjin.tts-editor
