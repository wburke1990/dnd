"""`tts` CLI — Tabletop Simulator save/mod tooling.

Subcommand groups:
  pull-saves          rsync ~/Library/Tabletop Simulator/Saves into the repo
  unpack <save>       extract per-object Lua/XmlUI from a save JSON
  pack   <save>       re-inject Lua/XmlUI back into a save
  combine A B -o OUT  splice ObjectStates from B into A
  list                show saves visible to the tooling
  assets backup       download every referenced URL into the local cache
  assets check        HEAD-check every URL, list dead ones
  assets list         summarise what's cached
  assets rehost       rewrite a save's URLs to point at the local cache
                      (or any base URL) using sha256 paths
"""

from __future__ import annotations

import shutil
import sys
from pathlib import Path

import click
from rich.console import Console
from rich.table import Table

from . import tts_assets, tts_save

console = Console()

REPO_ROOT = Path(__file__).resolve().parents[2]
SAVES_TRACKED = REPO_ROOT / "tts" / "saves"
SAVES_MIRROR = REPO_ROOT / "tts" / "saves-mirror"
LUA_DIR = REPO_ROOT / "tts" / "lua"
CACHE_DIR = REPO_ROOT / "tts" / "assets" / "cache"
MANIFEST = REPO_ROOT / "tts" / "assets" / "manifest.json"

LOCAL_TTS_SAVES = Path.home() / "Library" / "Tabletop Simulator" / "Saves"
LOCAL_TTS_MODS = Path.home() / "Library" / "Tabletop Simulator" / "Mods"


def _resolve_save(name: str) -> Path:
    """Find a save by exact filename, basename, or substring across known dirs."""
    candidates: list[Path] = []
    for root in (SAVES_TRACKED, SAVES_MIRROR, LOCAL_TTS_SAVES):
        if not root.exists():
            continue
        # Exact match.
        if (root / name).is_file():
            return root / name
        if (root / f"{name}.json").is_file():
            return root / f"{name}.json"
        # Substring search.
        candidates.extend(p for p in root.glob("*.json") if name.lower() in p.name.lower())
    if not candidates:
        raise click.ClickException(f"no save matching {name!r}")
    if len(candidates) > 1:
        names = ", ".join(p.name for p in candidates[:5])
        raise click.ClickException(
            f"ambiguous save match for {name!r}: {names}" + (" …" if len(candidates) > 5 else "")
        )
    return candidates[0]


# =============================================================================
# Top-level group
# =============================================================================


@click.group()
@click.version_option()
def main() -> None:
    """Sync, edit, merge, and back up Tabletop Simulator content."""


# =============================================================================
# Sync
# =============================================================================


@main.command("pull-saves")
@click.option(
    "--src",
    type=click.Path(path_type=Path, exists=True),
    default=LOCAL_TTS_SAVES,
    help="Source directory (default: ~/Library/Tabletop Simulator/Saves).",
)
@click.option(
    "--dest",
    type=click.Path(path_type=Path),
    default=SAVES_MIRROR,
    help="Destination directory (default: tts/saves-mirror).",
)
def pull_saves(src: Path, dest: Path) -> None:
    """rsync the local TTS Saves directory into the repo mirror."""
    if not shutil.which("rsync"):
        raise click.ClickException("rsync is not installed")
    dest.mkdir(parents=True, exist_ok=True)
    import subprocess

    cmd = ["rsync", "-a", "--delete", f"{src.as_posix()}/", f"{dest.as_posix()}/"]
    result = subprocess.run(cmd, check=False)
    if result.returncode != 0:
        raise click.ClickException(f"rsync failed (exit {result.returncode})")
    count = sum(1 for _ in dest.glob("*.json"))
    console.print(f"[green]Synced[/green] {count} save file(s) into {dest}")


@main.command("list")
def list_saves() -> None:
    """Show every save visible to the tooling, with size and source."""
    table = Table(show_header=True, header_style="bold")
    table.add_column("Source", style="dim")
    table.add_column("Filename")
    table.add_column("Size", justify="right")
    seen = set()
    for label, root in (
        ("tracked", SAVES_TRACKED),
        ("mirror", SAVES_MIRROR),
        ("local", LOCAL_TTS_SAVES),
    ):
        if not root.exists():
            continue
        for path in sorted(root.glob("*.json")):
            if path.name in seen:
                continue
            seen.add(path.name)
            size_mb = path.stat().st_size / (1024 * 1024)
            table.add_row(label, path.name, f"{size_mb:.1f} MB")
    console.print(table)


# =============================================================================
# Unpack / Pack
# =============================================================================


@main.command()
@click.argument("save_name")
@click.option(
    "--out",
    type=click.Path(path_type=Path),
    default=None,
    help="Output directory (default: tts/lua/<save-stem>/).",
)
def unpack(save_name: str, out: Path | None) -> None:
    """Extract per-object Lua + XmlUI from a save into a flat directory."""
    save_path = _resolve_save(save_name)
    out_dir = out or LUA_DIR / save_path.stem
    counts = tts_save.unpack_save(save_path, out_dir)
    console.print(
        f"[green]Unpacked[/green] {save_path.name} → {out_dir}\n"
        f"  {counts['objects']} objects, {counts['lua']} Lua, {counts['xml']} XmlUI"
    )


@main.command()
@click.argument("save_name")
@click.option(
    "--from",
    "lua_dir",
    type=click.Path(path_type=Path, exists=True),
    default=None,
    help="Lua directory (default: tts/lua/<save-stem>/).",
)
@click.option(
    "--out",
    type=click.Path(path_type=Path),
    default=None,
    help="Output save path (default: tts/saves/<save-name>).",
)
def pack(save_name: str, lua_dir: Path | None, out: Path | None) -> None:
    """Re-inject edited Lua/XmlUI files back into a save."""
    save_path = _resolve_save(save_name)
    src_lua = lua_dir or LUA_DIR / save_path.stem
    if not src_lua.exists():
        raise click.ClickException(f"no unpacked Lua dir at {src_lua}")
    out_path = out or SAVES_TRACKED / save_path.name
    counts = tts_save.pack_save(save_path, src_lua, out_path)
    console.print(
        f"[green]Packed[/green] {src_lua} → {out_path}\n"
        f"  Injected {counts['lua']} Lua, {counts['xml']} XmlUI"
    )


# =============================================================================
# Combine
# =============================================================================


@main.command()
@click.argument("base")
@click.argument("overlay")
@click.option(
    "--out",
    "-o",
    type=click.Path(path_type=Path),
    required=True,
    help="Output save path.",
)
@click.option(
    "--guids",
    help="Comma-separated GUIDs from overlay to include (default: all top-level objects).",
)
def combine(base: str, overlay: str, out: Path, guids: str | None) -> None:
    """Append objects from one save into another, regenerating colliding GUIDs."""
    base_path = _resolve_save(base)
    overlay_path = _resolve_save(overlay)
    select = {g.strip() for g in guids.split(",")} if guids else None
    counts = tts_save.combine_saves(base_path, overlay_path, out, select_guids=select)
    console.print(
        f"[green]Combined[/green] {base_path.name} + {overlay_path.name} → {out}\n"
        f"  Added {counts['added']} object(s), regenerated {counts['renamed']} colliding GUID(s)"
    )


# =============================================================================
# Assets
# =============================================================================


@main.group()
def assets() -> None:
    """Back up and rehost external assets a save depends on."""


@assets.command("backup")
@click.argument("save_name")
@click.option("--force", is_flag=True, help="Re-fetch even URLs already in the manifest.")
def assets_backup(save_name: str, force: bool) -> None:
    """Download every external URL referenced by a save into the local cache."""
    save_path = _resolve_save(save_name)
    counts = tts_assets.backup_save(save_path, CACHE_DIR, MANIFEST, skip_cached=not force)
    console.print(
        f"[green]Backup[/green] {save_path.name}: "
        f"{counts['urls']} URLs, {counts['downloaded']} new, "
        f"{counts['skipped']} already cached, {counts['failed']} failed"
    )
    if counts["failed"]:
        sys.exit(1)


@assets.command("check")
@click.argument("save_name")
def assets_check(save_name: str) -> None:
    """HEAD every URL in a save and report which ones have already gone dead."""
    save_path = _resolve_save(save_name)
    result = tts_assets.check_save(save_path)
    alive, dead = result["alive"], result["dead"]
    total = len(alive) + len(dead)
    console.print(
        f"[bold]{save_path.name}[/bold]: {total} URLs — "
        f"[green]{len(alive)} alive[/green], [red]{len(dead)} dead[/red]"
    )
    for url in dead:
        console.print(f"  [red]✗[/red] {url}")
    if dead:
        sys.exit(1)


@assets.command("list")
def assets_list() -> None:
    """Summarise the local asset cache."""
    manifest = tts_assets.Manifest(MANIFEST)
    total_size = sum(int(e.get("size", 0)) for e in manifest.entries.values())
    console.print(
        f"[bold]Cache:[/bold] {len(manifest.entries)} assets, {total_size / (1024 * 1024):.1f} MB"
    )


@assets.command("rehost")
@click.argument("save_name")
@click.option(
    "--out",
    type=click.Path(path_type=Path),
    required=True,
    help="Output save path.",
)
@click.option(
    "--base",
    required=True,
    help="Base URL where the cache contents will be served (e.g. https://my.cdn/tts).",
)
def assets_rehost(save_name: str, out: Path, base: str) -> None:
    """Rewrite asset URLs in a save to point at <base>/<aa>/<sha256>.<ext>."""
    save_path = _resolve_save(save_name)
    counts = tts_assets.rehost_save(save_path, out, MANIFEST, base)
    console.print(
        f"[green]Rehosted[/green] {save_path.name} → {out}\n"
        f"  Rewrote {counts['rewritten']} URL(s), {counts['missing']} not in manifest"
    )


if __name__ == "__main__":
    main()
