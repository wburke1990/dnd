"""Asset backup + rehosting for TTS saves.

Why this exists: Steam Workshop assets vanish all the time — the original
uploader removes a mod, the CDN expires a file, content gets DMCAed.
When that happens, opening the save shows blank cards, missing minis,
and broken textures. The user wanted insurance: keep a local copy of
every asset our saves depend on, and be able to rewrite the save's URLs
to point somewhere we control.

Cache layout (`tts/assets/cache/`, gitignored):
    cache/<aa>/<sha256>.<ext>            # aa = first 2 hex of sha256

Manifest (`tts/assets/manifest.json`, committed):
    {"version": 1,
     "entries": {
        "<url>": {"sha256": "...", "ext": ".png", "size": 12345,
                  "fetched_at": "2026-05-29T13:00:00Z"}}}

The manifest is the durable record of what we *have*; the cache is the
binaries themselves and is intentionally not committed (often gigs).
"""

from __future__ import annotations

import hashlib
import json
import re
import time
from collections.abc import Iterator
from datetime import UTC, datetime
from pathlib import Path
from typing import Any

import httpx

from .tts_save import Save, TTSObject, load_save, write_save

# Fields in a TTS object that hold an external asset URL.
ASSET_FIELDS = (
    "ImageURL",
    "ImageSecondaryURL",
    "MeshURL",
    "ColliderURL",
    "DiffuseURL",
    "NormalURL",
    "FaceURL",
    "BackURL",
    "AssetbundleURL",
    "AssetbundleSecondaryURL",
    "URL",
)

_DEFAULT_HEADERS = {"User-Agent": "dnd-tts-assets/0.1 (+https://github.com/wburke1990/dnd)"}


# =============================================================================
# Manifest
# =============================================================================


class Manifest:
    """File-backed cache index. Reads on construction, writes on save()."""

    def __init__(self, path: Path) -> None:
        self.path = path
        self.entries: dict[str, dict[str, Any]] = {}
        if path.exists():
            data = json.loads(path.read_text())
            self.entries = data.get("entries", {})

    def has(self, url: str) -> bool:
        return url in self.entries

    def add(self, url: str, sha256: str, ext: str, size: int) -> None:
        self.entries[url] = {
            "sha256": sha256,
            "ext": ext,
            "size": size,
            "fetched_at": datetime.now(UTC).isoformat(timespec="seconds"),
        }

    def cache_path_for(self, root: Path, url: str) -> Path | None:
        entry = self.entries.get(url)
        if not entry:
            return None
        sha = str(entry["sha256"])
        ext = str(entry["ext"])
        return root / sha[:2] / f"{sha}{ext}"

    def save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        payload = {"version": 1, "entries": self.entries}
        self.path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


# =============================================================================
# URL extraction
# =============================================================================


def iter_urls(save: Save) -> Iterator[tuple[TTSObject, str, str]]:
    """Yield (containing_object, field_name, url) for every asset URL."""

    def _walk(obj: TTSObject) -> Iterator[tuple[TTSObject, str, str]]:
        for field in ASSET_FIELDS:
            value = obj.get(field)
            if isinstance(value, str) and value.startswith(("http://", "https://")):
                yield obj, field, value
        # Recurse into nested structures: ContainedObjects, States, Decals,
        # CustomDeck (dict of int → object), CustomUIAssets, etc.
        for child in obj.get("ContainedObjects", []) or []:
            yield from _walk(child)
        for state in (obj.get("States") or {}).values():
            if isinstance(state, dict):
                yield from _walk(state)
        for deck in (obj.get("CustomDeck") or {}).values():
            if isinstance(deck, dict):
                for field in ASSET_FIELDS:
                    value = deck.get(field)
                    if isinstance(value, str) and value.startswith(("http://", "https://")):
                        yield deck, field, value
        for decal in obj.get("Decals", []) or []:
            yield from _walk(decal)

    # Top-level structures that aren't strictly "objects".
    for asset in save.get("CustomUIAssets", []) or []:
        if isinstance(asset, dict):
            url = asset.get("URL")
            if isinstance(url, str) and url.startswith(("http://", "https://")):
                yield asset, "URL", url
    for decal in save.get("DecalPallet") or []:
        if isinstance(decal, dict):
            for field in ("ImageURL", "URL"):
                value = decal.get(field)
                if isinstance(value, str) and value.startswith(("http://", "https://")):
                    yield decal, field, value

    for obj in save.get("ObjectStates", []) or []:
        yield from _walk(obj)


def list_urls(save_path: Path) -> list[str]:
    """All unique asset URLs referenced by a save."""
    save = load_save(save_path)
    return sorted({url for _obj, _field, url in iter_urls(save)})


# =============================================================================
# Download
# =============================================================================


_EXT_RE = re.compile(r"\.([a-zA-Z0-9]{2,5})($|\?)")


def _guess_ext(url: str, content_type: str | None) -> str:
    """Pick a file extension from URL path or HTTP content-type."""
    match = _EXT_RE.search(url)
    if match:
        return f".{match.group(1).lower()}"
    if content_type:
        ct = content_type.split(";")[0].strip().lower()
        return {
            "image/png": ".png",
            "image/jpeg": ".jpg",
            "image/jpg": ".jpg",
            "image/webp": ".webp",
            "image/gif": ".gif",
            "model/obj": ".obj",
            "application/octet-stream": ".bin",
        }.get(ct, ".bin")
    return ".bin"


def download_one(url: str, cache_root: Path, client: httpx.Client) -> tuple[str, str, int] | None:
    """Download a single URL into the cache. Returns (sha256, ext, size) or None."""
    try:
        resp = client.get(url, follow_redirects=True, timeout=30.0)
        resp.raise_for_status()
    except httpx.HTTPError:
        return None
    body = resp.content
    sha = hashlib.sha256(body).hexdigest()
    ext = _guess_ext(url, resp.headers.get("content-type"))
    dest = cache_root / sha[:2] / f"{sha}{ext}"
    dest.parent.mkdir(parents=True, exist_ok=True)
    if not dest.exists():
        dest.write_bytes(body)
    return sha, ext, len(body)


def backup_save(
    save_path: Path,
    cache_root: Path,
    manifest_path: Path,
    *,
    skip_cached: bool = True,
    rate_limit_s: float = 0.1,
) -> dict[str, int]:
    """Download every asset URL in the save to the cache. Updates manifest.

    Returns counts: {"urls": N, "downloaded": M, "skipped": S, "failed": F}.
    """
    save = load_save(save_path)
    manifest = Manifest(manifest_path)
    urls = sorted({url for _o, _f, url in iter_urls(save)})

    counts = {"urls": len(urls), "downloaded": 0, "skipped": 0, "failed": 0}
    with httpx.Client(headers=_DEFAULT_HEADERS) as client:
        for url in urls:
            if skip_cached and manifest.has(url):
                counts["skipped"] += 1
                continue
            result = download_one(url, cache_root, client)
            if result is None:
                counts["failed"] += 1
                continue
            sha, ext, size = result
            manifest.add(url, sha, ext, size)
            counts["downloaded"] += 1
            time.sleep(rate_limit_s)  # be polite to Steam's CDN

    manifest.save()
    return counts


# =============================================================================
# Rehost: rewrite save URLs to point at locally-served versions
# =============================================================================


def rehost_save(
    save_path: Path,
    out_path: Path,
    manifest_path: Path,
    base_url: str,
) -> dict[str, int]:
    """Rewrite every URL in the save to <base_url>/<sha>/<sha>.<ext>.

    Only URLs already in the manifest (i.e. previously backed up) are
    rewritten. Returns counts: {"rewritten": N, "missing": M}.
    """
    manifest = Manifest(manifest_path)
    save = load_save(save_path)
    base = base_url.rstrip("/")
    counts = {"rewritten": 0, "missing": 0}

    for container, field, url in iter_urls(save):
        entry = manifest.entries.get(url)
        if not entry:
            counts["missing"] += 1
            continue
        sha = entry["sha256"]
        new_url = f"{base}/{sha[:2]}/{sha}{entry['ext']}"
        container[field] = new_url
        counts["rewritten"] += 1

    write_save(out_path, save)
    return counts


# =============================================================================
# Health check
# =============================================================================


def check_save(save_path: Path) -> dict[str, list[str]]:
    """HEAD every URL in the save and bucket results into alive/dead."""
    save = load_save(save_path)
    urls = sorted({url for _o, _f, url in iter_urls(save)})
    alive: list[str] = []
    dead: list[str] = []
    with httpx.Client(headers=_DEFAULT_HEADERS, timeout=10.0) as client:
        for url in urls:
            try:
                resp = client.head(url, follow_redirects=True)
                (alive if resp.status_code < 400 else dead).append(url)
            except httpx.HTTPError:
                dead.append(url)
    return {"alive": alive, "dead": dead}
