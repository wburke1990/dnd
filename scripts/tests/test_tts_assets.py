"""Tests for tts_assets: URL extraction, manifest, and rehost rewriting.

Network-touching paths (`download_one`, `backup_save`, `check_save`) are
not exercised here — they're thin wrappers around httpx. The risk
surface is URL extraction (do we find every URL the save references)
and rehosting (do we rewrite them losslessly).
"""

from __future__ import annotations

import json
from pathlib import Path

from dnd_tools import tts_assets


def _write_save(path: Path, data: dict[str, object]) -> None:
    path.write_text(json.dumps(data, indent=2))


def test_iter_urls_finds_every_field_kind(tmp_path: Path) -> None:
    save = {
        "ObjectStates": [
            {
                "GUID": "1",
                "ImageURL": "https://example.com/a.png",
                "MeshURL": "https://example.com/b.obj",
                "CustomDeck": {
                    "1": {
                        "FaceURL": "https://example.com/face.png",
                        "BackURL": "https://example.com/back.png",
                    }
                },
                "ContainedObjects": [
                    {
                        "GUID": "2",
                        "DiffuseURL": "https://example.com/diff.jpg",
                    }
                ],
                "States": {
                    "2": {
                        "GUID": "1b",
                        "ImageURL": "https://example.com/state.png",
                    }
                },
            }
        ],
        "DecalPallet": [
            {"ImageURL": "https://example.com/decal.png"},
        ],
        "CustomUIAssets": [
            {"URL": "https://example.com/ui.png"},
        ],
    }
    urls = {url for _o, _f, url in tts_assets.iter_urls(save)}
    assert urls == {
        "https://example.com/a.png",
        "https://example.com/b.obj",
        "https://example.com/face.png",
        "https://example.com/back.png",
        "https://example.com/diff.jpg",
        "https://example.com/state.png",
        "https://example.com/decal.png",
        "https://example.com/ui.png",
    }


def test_iter_urls_skips_non_http_strings() -> None:
    save = {"ObjectStates": [{"GUID": "1", "ImageURL": "", "MeshURL": "file:///local/thing.obj"}]}
    urls = list(tts_assets.iter_urls(save))
    assert urls == []


def test_manifest_round_trip(tmp_path: Path) -> None:
    path = tmp_path / "manifest.json"
    m = tts_assets.Manifest(path)
    assert not m.has("https://example.com/x.png")
    m.add("https://example.com/x.png", "abc" * 21 + "de", ".png", 4096)
    m.save()

    m2 = tts_assets.Manifest(path)
    assert m2.has("https://example.com/x.png")
    entry = m2.entries["https://example.com/x.png"]
    assert entry["sha256"] == "abc" * 21 + "de"
    assert entry["ext"] == ".png"
    assert entry["size"] == 4096
    assert "fetched_at" in entry


def test_rehost_rewrites_urls_using_manifest_sha(tmp_path: Path) -> None:
    save_path = tmp_path / "save.json"
    out_path = tmp_path / "rehosted.json"
    manifest_path = tmp_path / "manifest.json"

    _write_save(
        save_path,
        {
            "ObjectStates": [
                {
                    "GUID": "1",
                    "ImageURL": "https://example.com/a.png",
                    "MeshURL": "https://example.com/missing.obj",
                }
            ]
        },
    )

    m = tts_assets.Manifest(manifest_path)
    m.add("https://example.com/a.png", "ab" + "0" * 62, ".png", 1)
    m.save()

    counts = tts_assets.rehost_save(save_path, out_path, manifest_path, "https://cdn.test")
    assert counts == {"rewritten": 1, "missing": 1}

    rehosted = json.loads(out_path.read_text())
    image_url = rehosted["ObjectStates"][0]["ImageURL"]
    assert image_url == f"https://cdn.test/ab/{'ab' + '0' * 62}.png"
    # Missing URL was left as-is, not blanked.
    assert rehosted["ObjectStates"][0]["MeshURL"] == "https://example.com/missing.obj"


def test_guess_ext_from_url_query_string() -> None:
    # `_guess_ext` is private but its correctness shapes cache filenames; test
    # via the public download path's behavior would require network. Inline OK.
    assert tts_assets._guess_ext("https://x.com/a.png?cb=1", None) == ".png"
    assert tts_assets._guess_ext("https://x.com/raw", "image/jpeg") == ".jpg"
    assert tts_assets._guess_ext("https://x.com/raw", None) == ".bin"
