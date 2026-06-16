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
