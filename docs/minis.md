# Minis that resize with the grid

The DND Mini Injector (GUID `f211ac`, in both Nila and staging) gives every mini
a script. About once a second that script compares the table grid's width with
the width it last saw, and when they differ it resizes the mini. It does this
only for a mini that has been **calibrated**: calibrating stores the mini's
current size divided by the grid width, and the mini keeps that ratio from then
on. An uncalibrated mini ignores grid changes.

The script reads only the grid's width (`Grid.sizeX`), so a grid with
rectangular cells sizes minis by the width.

## Calibrating by hand, in TTS

- Right-click a mini → **Calibrate Scale**. The item shows `[X]` once done.
- Right-click → **Reset Scale** puts a calibrated mini back to its calibrated
  size for the current grid.
- The injector's **Auto-Calibrate** toggle calibrates minis as they are
  injected.

## Calibrating every mini on the table at once

`calibrate-minis` writes the calibration into the save file for every mini on
the table, so no clicking is needed. Minis inside bags are not touched.

1. Size the minis and the grid the way you want them, and save in TTS.
2. Back up the save, then run it with a separate output file (it will not
   overwrite its input):

   ```
   cp "/Users/wcb/Library/Tabletop Simulator/Saves/TS_Save_19.json" /tmp/TS_Save_19.bak.json
   uv --directory /Users/wcb/personal/dnd/scripts run calibrate-minis \
     /tmp/TS_Save_19.bak.json "/Users/wcb/Library/Tabletop Simulator/Saves/TS_Save_19.json"
   ```

   It prints each mini it calibrated. A mini that is already calibrated is
   skipped; `--recalibrate` records its current size again.
3. **Do not save in TTS between steps 2 and 4.** A save from TTS writes the old
   state over the edited file.
4. Fully quit TTS, relaunch, and load the save by name (not the autosave).
   Change the grid size to check: the minis resize within about a second.

First run 9/22 on staging: Blackacre, Sarric, Jasper, Pax, the Thinker, and
both copies of Aniess.
