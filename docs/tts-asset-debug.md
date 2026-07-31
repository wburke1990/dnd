# TTS Asset-Failure Debugging

When a TTS save shows "Failed to import asset" dialogs on load, two
places to look — they catch **different failure modes**:

## 1. TTS Player log

```
~/Library/Logs/Berserk Games/Tabletop Simulator/Player.log
```

Unity's player log. Only **curl-level errors** land here:

- `Curl error 6: Could not resolve host: <domain>` — DNS dead
- `Curl error 28: Failed to connect ... port 80 ...` — port closed / timeout

The log does **NOT** show "URL returns 200 but content is wrong"
failures — those surface as in-game dialogs only, never in the log.

## 2. GET-probe with content peek

`tts assets check` uses HEAD requests, which return 200 for many
silently-broken URLs:

- **Pastebin URLs without `/raw/`** (e.g. `pastebin.com/mcLzrDTv`)
  always return the HTML viewer page, never raw asset content.
  Categorically broken for use as a TTS asset URL.
- **Deleted hosting** (e.g. `john-moeller.de`) — domain serves a
  generic HTML landing page for missing files, HEAD returns 200.
- **Deleted pastebin pastes** under `/raw/` — return 0-byte responses
  or HTML error pages with status 200.

Pattern that works (one-off probe of suspect URLs):

```python
import urllib.request

def probe(url):  # GET, peek 500 bytes, classify
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=10) as r:
        body = r.read(500)
        is_html = b'<html' in body.lower() or b'<!doctype' in body.lower()
        return r.getcode(), is_html, body[:80]
```

Treat as dead: `status != 200` OR `is_html` OR (pastebin URL without
`/raw/`).

## Cleanup pattern

**Don't aggressively domain-blacklist** — false positives delete legit
content. Either:

1. Get the failing URLs from the user (they show in the dismissed
   dialogs) and remove by exact URL match, OR
2. Probe + classify per above, then remove by exact URL set.

When removing objects from a save, check each object's **asset-URL
fields only** — not `LuaScript` or `Description`, since those may
legitimately mention URLs without depending on them at load time. The
canonical list is `URL_FIELDS` in
`scripts/dnd_tools/tts_assets.py`:

```
ImageURL, ImageSecondaryURL, MeshURL, ColliderURL,
DiffuseURL, NormalURL, FaceURL, BackURL,
AssetbundleURL, AssetbundleSecondaryURL, URL
```

After removing objects, also strip their GUIDs from every
`SBx_*.LuaScript` manifest line in `aBag` (`966e1c`) — otherwise a
future Hub Build attempts to spawn missing GUIDs. See
[oneworld.md](oneworld.md).

## Hosting a replacement asset for a shared save

When you swap in your own asset — an edited floor image, a rehosted
mesh — every player's TTS fetches that URL over the network at load.
So the URL has to be reachable from **their** machines, and it must not
live in this git repo:

- A **local `file://` path or a `localhost` link works only on the
  machine that made it** — it loads for you and is a broken/blank asset
  for every player. Never paste a local path into a shared save.
- **Don't host campaign images in the git repo.** GitHub Raw *serves* a
  committed file while the repo is public, but images don't scale into
  git: the full OW map set alone is ~1.5 GB of floor images, and every
  one bloats clone history forever — the same reason the big saves
  aren't committed (see [oneworld.md](oneworld.md), "script a new OW map
  from a padded image"). A weekly campaign's images extrapolate well
  past what the repo should carry, so **GitHub is not the image host.**
- **For a one-off manual swap, use TTS Cloud.** Upload the image through
  TTS's in-client **Cloud Manager**; it mints a
  `steamusercontent-a.akamaihd.net/ugc/…` URL via Steam Remote Storage.
  Paste that into the object's asset field. This is **manual only** —
  Steam Cloud has no external push API, so it can't be scripted (again
  see [oneworld.md](oneworld.md)); an automated host for the whole fleet
  (Cloudflare R2) is planned but deferred.
- Steam UGC and imgur work for players but you can't guarantee they stay
  up (the whole reason the asset tooling exists). For anything the game
  must not lose, back it up with `tts assets backup`.
