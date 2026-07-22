# One World maps — import inventory

Inventory of the **"22 - One world maps"** TTS save (`TS_Save_22.json`,
saved 2026-06-25, ~254 MB). The save is a flat OneWorld **map library**:
**272 map bags loose at the top level** of `ObjectStates`, each nicknamed
`OWx_<MapName>`. There is no packed Hub / `mBag` here, so every map is
directly importable into Nila.

Use this to pick maps to import. When you choose, the import workflow is
in [`../docs/oneworld.md`](../docs/oneworld.md) (`import_ow_map`). Each
map is fully self-contained: its tiles **and** its `SBx_` token live
inside its own `ContainedObjects`, and the bag↔token GUID reference pair
stays entirely within that one bag — there is no master registry or
cross-map reference. So importing one map means pulling just that one
`OWx_` bag.

> **⚠️ Opened vs. unopened — read this first.** Of the 272 maps, only the
> **~14 in the [Opened maps](#opened-maps--the-only-ones-weve-actually-inspected)
> table below** have actually been opened and inspected in TTS. **Every other
> entry in this file is name + GUID only — never opened, and its *nickname is
> not evidence of its contents*** (nicknames here are routinely wrong). Do not
> describe, recommend, or reason about an unopened map as if its contents are
> known — say "unopened, name only," and import it to staging to *look* before
> trusting it. The Opened table is the single source of truth for what's been
> seen.
>
> **Opened set (exhaustive — add to it the moment you open one):** `dfd079`
> `e47bca` `55ed53` `432502` `ed6b26` `6b9aab` `811e42` `06363d` `abc718`
> `a7d428` `56d9e9` `c3aa13` `6d9e46` `bc9404`

> **Maintenance (2026-06-25):** the save was cleaned up after this
> inventory was first built — the 17 duplicate copies were deleted
> (289 → 272 bags) and the malformed `OWllakovich Manor Attic` nickname
> was corrected in-save to `OWx_Vallakovich Manor Attic`. See the
> Duplicates section below for the record.

Source file (not in the repo): `~/Library/Tabletop Simulator/Saves/TS_Save_22.json`

**Legend:** `GUID` is the 6-char TTS GUID of the `OWx_` bag. The two
non-map prop/figure bags in the save (`Stack of Crates (Large)` e95f09,
`Knight of the Morningstar` 282d8d) are excluded.

---

## Opened maps — the only ones we've actually inspected

**This table is exhaustive** — it is the single source of truth for which maps
have been opened in TTS. A running log of maps we've actually loaded and judged,
so we don't re-import a known dud, forget a good one, or mistake an unopened
map's *nickname* for knowledge of what's in it. **If a map is not in this table,
we have not opened it** — treat its contents as unknown. Status key: **✅ good** ·
**⚠️ usable with work** · **❌ not usable** · **🔖 reserved** (good, saved
for a specific future use) · **🔀 mislabeled** (recategorized above).

> **✅ The floor offset is SOLVED — fit the floor to the map's own plate.**
> The Hub paints the floor at one uniform vBase scale; the old importer default
> (25) ran ~40% too big → the floor overhung the built surface. The fix, now
> **automatic in `import_ow_map`** (see [oneworld.md](../docs/oneworld.md) →
> *Floor-plate fitting*): every OW battle map ships its **own floor plate** —
> the largest *flat* tile (~18) — so set the vBase scale to that tile and
> **recenter the pieces on it**. Result: painted floor exactly flush with the
> built surface, uniform, no distortion. This retired the earlier dead ends
> (object-bbox sizing skewed by prop clouds; the "needs a non-square/
> aspect-matched plate" theory). Maps tested *before* the fix may still carry a
> stale vBase — retrofit per oneworld.md.

| Map | GUID | Status | Notes |
|-----|------|--------|-------|
| **Desert Cave** | dfd079 | ✅ **winner — akhekh lair** | Flush via plate-fit (vBase ~18.2). Natural **Akhekh nest** area; red desert palette; serves tunnels + nest in one. |
| **Rocky Path** | e47bca | ✅ perfect (fitted) | Flush via plate-fit (vBase 17.99). Clean assets. Good akhekh **stairs / approach**. |
| **Canyon Cave** | 55ed53 | ✅ perfect (fitted, cleaned) | Flush via plate-fit (vBase 17.99) — the map that proved the strategy. Akhekh **tunnels**. The 9 "figurine import errors" turned out to be 9 **blank placeholder `Figurine_Custom`** objects (empty image URL — not a throttling/rehost issue); removed, so it loads clean. |
| Cave Altar | 432502 | 🔖 reserved | Works at **full floor 25 — do NOT shrink** (shrinking cuts its surroundings → black). Underground **tomb with a huge central statue**; pavilion needs a new texture. Future. |
| The Sinkhole | ed6b26 | ❌ not usable | Offset both ways; small footprint over-zooms (~1.8×) if grown. Skip. |
| Larders of Ill Omen | 6b9aab | 🔖 reserved | Great nest/lair; only 5 tiny props dropped in cleanup. **Ships with fog-of-war tiles** — pre-placed FoW coverage baked into the map (no need for the `04638a` spawner). Not this quest — banked. |
| CAVE Boss | 811e42 | 🔖 reserved | "Amazing", clean. Set aside for a future scene, not the akhekh. |
| Dwarven cliffs with houses | 06363d | ❌ not usable | Core terrain meshes dead (Steam 404); cleanup left only floating houses/stones. |
| Cave Entrance | abc718 | ❌ not usable | Too many trees for the akhekh; geyser-steam assets dead (`infinitebucket.com`). |
| Spiraling Pass | a7d428 | 🔀 mislabeled | Actually tropical islands, not a mountain pass — moved to Docks/coast. Useful later, not for the akhekh. |
| **The Foundry** | 56d9e9 | ✅ **winner — the mill (under-city)** | Loaded perfectly; plate-fit (vBase 18.06). Underground: skeletons strewn across one room's floor, a large circular stone that reads as a **millstone**, an abyss in an adjoining room. Used as **the mill** — running in the top layer of the tunnels below Maalm, tying the under-city / "faithful survived underground" thread (Session 6). 34 dead-link pieces pruned; still looks great. |
| **Valience Farmhouse** | c3aa13 | 🔖 reserved — too rural | A primitive rural farmhouse — too rural for the mill. **Removed from staging** after eyeballing; banked for a later rural scene. Floor looked great despite "no plate detected → default vBase 25" (the default fit fine here). 22 dead-link pieces pruned — the **cleaned bag is stashed** at `~/Library/Tabletop Simulator/map-stash/farmhouse_clean_c3aa13.json`, so re-import from *there* (donor `c3aa13`) to skip re-pruning. |
| **River Straight** | 6d9e46 | 🔖 reserved — river scene, not a mill | Beautiful: trees along both banks, a boat floating mid-river. Clean import (0 dead assets), floor plate-fit (vBase 18.14). Not a mill — **dropped from staging** to keep it lean; banked for a **river / boat / travel** scene. Clean donor, so re-import straight from `TS_Save_22` (`6d9e46`), no prune needed. |
| **BlackSmiths House** | bc9404 | ❌ not usable — mislabeled | Not a smithy: an outdoor **forest** scene with 2 houses, some minis, and trees (floor image is `base_forest.jpg`). Floor URL dead (Google Sites) → black/white placeholder floor, and Build threw **20+ custom-token URL approval prompts**. Removed. |
| **High Rise Market** | b00f40 | 🔖 **reserved — epic dwarf city** | Monolithic dwarf statues guarding the approach to a huge city built into cliffs; 60+ minis in the city. **Not a coffeehouse** — pulled from the V. coffeehouse shortlist. Reserved for **West Suartleheim** or another epic dwarf-city scene. Imported+pruned into staging (plate-fit vBase 10.3); 13 dead URLs, **48 pieces removed** in cleanup — eyeball that the statues/minis survived (they were rendering pre-prune, so should be the live ones kept). Steam-UGC floor image (decay-prone). |
| The Coins | 4b489d | ⚠️ opened — coffeehouse candidate | Imported+pruned into staging as a V.-coffeehouse candidate (plate-fit vBase 13.27); 17 dead URLs, 7 pieces removed. Awaiting the user's read on whether it plays as a coffeehouse / Company house. |
| Merc Hall | dc9743 | ⚠️ opened — heavily pruned | Imported+pruned into staging as a V.-coffeehouse candidate (no floor plate detected → default vBase 25). 25 dead URLs and **85 pieces removed** — likely sparse now; eyeball before using. Awaiting the user's read. |

---

## The rest — UNOPENED (name + GUID only)

Everything below is the full donor library, grouped by theme for browsing.
**These are bag labels, not inspections** — none have been opened in TTS, so a
name is a *guess* about contents, not a fact. Import one to staging and move it
up to the Opened table before treating its contents as known. The label itself
is often wrong: *BlackSmiths House* turned out to be a forest, *Spiraling Pass*
tropical islands — both caught only by opening them.

## Curse of Strahd / Barovia (17)

```
Barovia Mansion                   085ed7
Berez                             be644b
Court of the Count                f4eb85
Death House                       650e39
Gates Of Barovia                  228270
Krezk                             ab370e
Ravenloft CrossRoad               f59e1f
St Andral's                       194e0e
Svalich Road                      f1f484
Tser Encampment                   1b6462
Tser Falls                        7472b6
Vallakovich Manor                 ebef42
Vallakovich Manor 2               d5092b
Vallakovich Manor Attic           36c6b1
Village of Barovia                814114
Vistani Camp                      030ba2
Yester Hill                       0dc834
```

## Sharn / Eberron (3)

```
Precipice Quarter                 76fee7
Sharn Streets                     502d16
The Promenade                     8499b0
```

## Dark Sun / Desert (5)

```
Altaruk                           0e869d
Desert Cave                       dfd079
Dry City                          4bc694
Mekillot Cart                     f2dc89
Under Tyr                         e20b2b
```

## Dragons & dragon lairs (8)

```
Coldarra 1                        f29870
Coldarra 2                        f572dc
Coldarra 3                        b0930b
Dragon fight                      16441a
Dragon Pond                       7a6229
Emerald Dragon Shrine             ffdc86
Malygos Encounter                 fdb2a6
White Dragons                     a62cfb
```

## Giants / Storm King's Thunder (10)

```
Fire Giants 2                     fc9f1b
Fire Giants 3                     2039e3
Fire Giants Hall                  6a60ac
Frost Giant 1                     0597a0
Frost Giant 1.0                   cb4140
Frost Giants 2                    c2574c
Frost Giants 2.0                  820086
Hill Giants 2                     217c49
Path to Kurth 1                   ba7836
Stonetooth                        14192f
```

## Valience siege set (7)

```
Valience Farmhouse                c3aa13
Valience Interior                 a16b59
Valience Invasion A               359048
Valience invasion B               f7dd7c
Valience Invasion C               32c843
Valience Keep 1                   0121fd
Valience Keep Sewer               fc155f
```

## Feywild (5)

```
Fey River                         f855cc
Feywild - Foliage                 0de9e9
Feywild - Paths                   865361
Feywild - Pond                    346f81
Feywild Alt. Trail                bd7ac3
```

## Underwater & the Abyssal Shelf (9)

```
Aboleth's Lair                    612d91
Bottem of the sea                 02cf72
Sea Elf                           c18f8e
Slarkrethel                       b752b5
Submerged Ruin                    356b1d
The Abyssal Shelf - 5             d6c26e
The Abyssal Shelf - 6             922757
The Abyssal Shelf - 7             5dc1a3
The Abyssal Shelf - 8             b38d49
```

## Cities & large towns (15)

```
Casle town                        de1c46
Castle Town                       ec8490
Fountain Park                     6d5362
Gladiator Stadium                 af2ecf
Inner Hearthglen                  d545b6
Lindos                            36afeb
New Hearthglen                    4dc821
Petal District                    7ddb73
Rat City                          e0559d
Small casle town                  f540f6
Small City 2                      2db056
Small City Lvl 1                  3695ec
Town Square                       ea2860
Westgate                          aef9dc
Yartar                            00c35d
```

## Villages & small settlements (10)

```
Close up Village                  48343b
Goldnose Outpost                  df6dd9
Lake Village                      8acab7
Nightstone                        11c05e
Our town                          338487
Outpost 19                        dd414a
Piper Downs                       ca7a72
Small town                        189d29
Tiny town                         8d5e31
Village                           615732
```

## Inns, taverns, shops & interiors (14)

```
BlackSmiths House                 bc9404
Brick bar                         b03586
BlueWater Inn                     1fd7e3
BlueWater Inn 2                   9dd436
Demon Bar                         3de142
FH Building Interior              d3e410
Hill town tavern                  d18d1c
Jeny's Cottage Inside             b0e3ea
Library Basement                  6f00b8
Nonspecific Inn                   b2a074
Snowy Tavern                      2b0984
The Lion's Mane                   0353c3
The Mumbling Rat                  90bd67
Tori Dojo                         9a1fff
```

## Castles, keeps, citadels & forts (10)

```
Casle on a hill                   083992
Castle Dorter - Canal             d6969c
Citadel 1                         0fab72
Citadel 2A                        2c01c3
Citadel Entrance                  93055e
Citadel grove level               63b162
Citadel Hall                      d1eff3
Fort Uuta                         fdcf68
Kings hall                        032a0f
Westguard Keep                    c57710
```

## Estates & manors (5)

```
Lord's Manor                      1f9e8a
Mansion Quests                    3ff3ec
Mayor's Residence                 1033e1
Moonveil Manor                    b160ea
Mountaincloak Estate              80521c
```

## Temples, shrines & ruins (19)

```
BL Temple Alter                   5541e6
Buried Structure                  1fef9b
Cultist Ruins 1                   015b34
Cultist Ruins 2                   4dfd51
Demetria's Ruined Temple          9d0639
Grassy Temple Ruins               2bbd1b
Jungle Temple 2                   a69cb1
Monastery Chapel                  12f427
Naga Ruins Graveyard              868e07
Naga Ruins Icering                caf57a
Ruin Basement                     53e2f6
Ruins of Old Lionel               626c66
Ruins of Prim                     cad91f
Sanctuary                         d4494b
Small Temple                      e52618
South Naga Ruins                  8dc113
Swamp Ruin                        b6b1a0
Temple Sea Wall                   8270d4
Under Sydon's Temple              08a539
```

## Graveyards, tombs & crypts (13)

```
Big Grave yard                    d28d59
Boneyard                          6050b5
Cave Tomb                         12ccdd
Cript keep                        39dc0f
Graveyard Encounter 1             5f1f00
Hillside Crypt                    eea45b
Interior - TOTF                   88d84c
Red King Enter                    36dade
Red King Tomb                     b5340c
Spoopy Graveyard                  425c5e
The cript fight                   02e635
Tomb of the Forgotten             83848c
Tomb of Xander                    98d1c2
```

## Caves, sewers & underdark (19)

```
Bugbear Cave                      a0a5d5
Canyon Cave                       55ed53
Cave Altar                        432502
CAVE Boss                         811e42
Cave Entrance                     abc718
CAVE Hallway                      b7cb50
Cave of death                     ca122c
City sewer                        37022f
Fungus cave                       b9f76f
Glitterhame                       a1a086
Hammerhead Pass Cave              6c8261
Larders of Ill Omen               6b9aab
Neverlight Grove                  57fbb4
Sewer                             0c24c3
Source Below                      6cef6c
The Sinkhole                      ed6b26
Tri - Lair                        74d998
Underdark                         b69a1f
Underdark more                    6a421e
```

## Dwarven halls & mines (5)

```
Dwarven Cavern                    ff391e
Dwarven cliffs                    bfc177
Dwarven cliffs with houses        06363d
Middle Dwarf Town                 e57584
Mithral Mine                      fdc25b
```

## Dungeons, mazes & puzzle rooms (5)

```
Harrington's Labrynth             869fed
Magic Trap                        4ae6eb
Maze                              c8db8a
Puzzle Room                       dd1317
The laberinth                     c02c77
```

## Mage towers & magic (7)

```
Khazan's Tower                    d38c51
Kirin Tor Base                    7dfd14
Kobald Tower                      d1021a
Loken's Tower Level 5             ae9514
Mage Campus                       dcf5a1
Mage Tower Interior               577023
Tower                             845093
```

## Forests, groves & wilderness (17)

```
Avani Druid Rings                 f1e8df
Camp in the woods                 03acad
Dark woods                        236231
Druid's Circle                    f0152d
Forest Clearing                   456036
Forest Encounter 3                e0e923
Forest Path 3                     28e589
Forest Road                       00ad94
Gariland Hills Road               4f1803
Grandfather Tree                  9fcef4
Jungle                            1df8ec
Phandelver Wilderness             a185f1
Red Forest                        184b89
Road to Farm                      4d870f
Siberian Forest                   0c540d
Wolf din                          d51e6d
Woods ring                        dbb991
```

## Mountains, hills, cliffs & canyons (14)

```
Box Canyons                       481be4
Brae                              8634af
Canyon                            401c9a
Floating Hills 1                  f39ac6
Herringbone Rock                  25bf82
High Foothills                    416d81
Hills road                        d800f4
Layered Mountain                  b29b9e
Low Hill                          6e9f87
Mountain Raod                     d6136c
Mountain Side Grove               1bd86c
Moutain Door                      032cd9
Rocky Path                        e47bca
The Chasm                         518a87
```

## Snow & ice (6)

```
Icesplitter Wreck                 4639f3
Icy Path                          751985
On Thin Ice                       782fdf
Snowy Forest Path                 0730e6
Winter Battle field 0             b72d2e
Winter Battle field 1             4fdeb5
```

## Docks, ships & coast (18)

```
Blue Corsairs                     69f445
Brigantine                        82222c
DG Dockside                       839e65
Dock                              d98622
Dock Encounter 1                  e79b41
Docks Combat                      b45eac
Dorter Slums - Docks              9e7345
High Seas                         5bb5be
K island                          6e6aab
Loading Docks                     d8cc23
N.Point Sm Dock                   6e1ce4
Ocean Cliffs                      ca14be
Odnarb Point                      d2b323
Port city                         85ff11
Small ship town                   e5838c
Spiraling Pass (tropical islands) a7d428
The Docks                         824863
Westguard Cove                    50f76c
```

## Lakes & rivers (7)

```
Black Lake                        d95910
High Flow                         de396f
Low Flow                          47b895
River Gorge                       e24ab3
River Ivlis                       c16f1b
River Straight                    6d9e46
Twin Falls Encounter              441b2a
```

## Encounters & misc scenes (19)

```
Affluent Tree                     195d88
Bridge from GH to ZD              a5a20d
Gigantic Carrage                  ac6927
Goblin ambush                     fd63d9
Goblin Camp 2                     b6349d
Goblin War Camp                   ba3ddb
Hammerhead                        333174
Meteorite Encounter               12de79
Old Final Battle                  9e791a
Reclaim                           4a591f
SLooBLUDoP                        ec0a7f
SoR Map 9                         3c6c3a
SoR Map 10                        8ccc73
Sqell                             f4cfb0
Telemok                           338f26
The Foundry                       56d9e9
The Furnace                       73a4a3
The Nexus Entrance                368b11
Valemoor                          20f923
```

## Utility / skip — not battle maps (2)

```
BagoDice                          15ccde
Name of Zone                      dcd648   [empty placeholder template]
```

---

## Setting / adventure clusters

Cross-cutting source tags (these maps live in the environment groups
above; listed here so you can pull a whole adventure at once):

- **Curse of Strahd / Barovia** — its own group above, plus loosely
  *Wolf din* (wolf den).
- **Storm King's Thunder** — the Giants group, plus *Nightstone*
  (village) and *Yartar* (city).
- **Final Fantasy Tactics (Ivalice)** — *Castle Dorter - Canal*,
  *Dorter Slums - Docks*, *Gariland Hills Road*, *River Ivlis*,
  *Ruins of Old Lionel*.
- **World of Warcraft** — *Coldarra 1/2/3* + *Malygos Encounter*
  (Borean Tundra), *Kirin Tor Base*, *Inner/New Hearthglen*,
  *Loken's Tower Level 5* (Ulduar).
- **Out of the Abyss (Underdark)** — *Neverlight Grove*.
- **Lost Mine of Phandelver** — *Phandelver Wilderness*, *Glitterhame*.

## Duplicates — removed 2026-06-25

The save originally shipped 17 names twice. Each pair was the same map
art, but each copy was an independent self-contained instance (its own
`OWx_` bag GUID and its own nested `SBx_` token GUID; two of the pairs —
Black Lake and Tomb of the Forgotten — were verified byte-identical in
their image URLs and child-object counts). The redundant copy of each
pair (the second GUID below) was deleted from the save; the first GUID is
the surviving map listed in the groups above.

```
                          kept     removed
Black Lake                d95910   25a6ce
Tomb of the Forgotten     83848c   50aab7
Canyon                    401c9a   6dd8d7
Canyon Cave               55ed53   68dfe5
Castle Dorter - Canal     d6969c   9a62be
Demetria's Ruined Temple  9d0639   10d58b
Desert Cave               dfd079   fc5046
Dwarven Cavern            ff391e   3138d8
Feywild - Foliage         0de9e9   5dd64a
Feywild - Paths           865361   2c3ec7
Forest Path 3             28e589   42e913
Fountain Park             6d5362   df4356
Harrington's Labrynth     869fed   4bf727
Ocean Cliffs              ca14be   344585
Puzzle Room               dd1317   8cc1f3
Sharn Streets             502d16   b3d0a2
Snowy Forest Path         0730e6   388b97
```

## Note: the typo'd bag (fixed)

Bag **36c6b1** was nicknamed `OWllakovich Manor Attic` — missing the
`x_Va`, so the OW prefix was malformed. It is **Vallakovich Manor Attic**
(companion to *Vallakovich Manor* ebef42 and *Vallakovich Manor 2*
d5092b). Its nickname was corrected in-save to
`OWx_Vallakovich Manor Attic` on 2026-06-25.
