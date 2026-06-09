"""Pad map images with black bars to match the OneWorld TTS aspect ratio.

OneWorld map images render natively at 1600x945 (or the 2x variant
3200x1890). Source maps from other tools rarely match that ratio. This
command letterboxes/pillarboxes them onto an OW-shaped canvas so they
drop into the Hub without stretching.
"""

from __future__ import annotations

from pathlib import Path

import click
from PIL import Image, ImageOps

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INPUT = REPO_ROOT / "maps"
DEFAULT_OUTPUT = REPO_ROOT / "maps" / "padded"
DEFAULT_RATIO = (1600, 945)
SUPPORTED_SUFFIXES = {".jpg", ".jpeg", ".png", ".webp"}
# Fraction of black border to guarantee on every side of the canvas.
# OneWorld's table model clips the short edges of the displayed token; baking
# this inset in keeps user content out of the clipped strip regardless of
# orientation. Applied uniformly so source aspect is preserved. Bumped from
# 5% to 10% after 5% still let the short edges get clipped in play.
SAFE_MARGIN_FRAC = 0.10


def parse_ratio(text: str) -> tuple[int, int]:
    """Parse a 'W:H' or 'WxH' ratio string into a (w, h) tuple."""
    for sep in (":", "x", "X"):
        if sep in text:
            w_str, h_str = text.split(sep, 1)
            try:
                w, h = int(w_str), int(h_str)
            except ValueError as exc:
                raise click.BadParameter(f"ratio must be integers, got {text!r}") from exc
            if w <= 0 or h <= 0:
                raise click.BadParameter(f"ratio components must be positive, got {text!r}")
            return w, h
    raise click.BadParameter(f"ratio must look like '1600:945', got {text!r}")


def pad_to_aspect(
    src: Path,
    dst: Path,
    target_w: int,
    target_h: int,
    safe_margin: float = SAFE_MARGIN_FRAC,
) -> tuple[int, int]:
    """Pad ``src`` so its canvas matches ``target_w:target_h`` with a safe margin.

    Honors EXIF orientation so phone photos land right-side-up. Source
    pixels are preserved at native resolution; only the canvas grows. The
    canvas is sized so at least ``safe_margin`` of each side is black —
    when the source already matches the target aspect, this still produces
    a uniform border. Returns the ``(width, height)`` of the written image.
    """
    with Image.open(src) as raw:
        img = ImageOps.exif_transpose(raw)
        if img is None:
            img = raw
        img = img.convert("RGB")
    src_w, src_h = img.size
    target_ratio = target_w / target_h

    inner = 1.0 - 2.0 * safe_margin
    safe_w = src_w / inner
    safe_h = src_h / inner
    canvas_w_f = max(safe_w, safe_h * target_ratio)
    canvas_h_f = canvas_w_f / target_ratio
    new_w, new_h = round(canvas_w_f), round(canvas_h_f)

    canvas = Image.new("RGB", (new_w, new_h), (0, 0, 0))
    offset = ((new_w - src_w) // 2, (new_h - src_h) // 2)
    canvas.paste(img, offset)
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.suffix.lower() in {".jpg", ".jpeg"}:
        canvas.save(dst, quality=95, subsampling=0)
    else:
        canvas.save(dst)
    return canvas.size


def _discover(input_dir: Path, output_dir: Path) -> list[Path]:
    if not input_dir.exists():
        return []
    resolved_out = output_dir.resolve()
    found: list[Path] = []
    for p in input_dir.iterdir():
        if not p.is_file() or p.suffix.lower() not in SUPPORTED_SUFFIXES:
            continue
        # Skip anything already inside the output directory.
        if resolved_out in p.resolve().parents:
            continue
        found.append(p)
    return sorted(found)


@click.command()
@click.argument(
    "paths",
    type=click.Path(exists=True, dir_okay=False, path_type=Path),
    nargs=-1,
)
@click.option(
    "--input",
    "input_dir",
    type=click.Path(file_okay=False, path_type=Path),
    default=DEFAULT_INPUT,
    show_default=True,
    help="Directory to scan when no PATHS are given.",
)
@click.option(
    "--output",
    "output_dir",
    type=click.Path(file_okay=False, path_type=Path),
    default=DEFAULT_OUTPUT,
    show_default=True,
    help="Directory to write padded copies into.",
)
@click.option(
    "--ratio",
    "ratio_str",
    default=f"{DEFAULT_RATIO[0]}:{DEFAULT_RATIO[1]}",
    show_default=True,
    help="Target aspect ratio as W:H (OneWorld native: 1600:945).",
)
@click.option(
    "--force/--no-force",
    default=False,
    help="Overwrite existing padded outputs.",
)
@click.option(
    "--auto-orient/--no-auto-orient",
    default=True,
    show_default=True,
    help="Flip the target ratio for portrait sources so they stay portrait.",
)
def main(
    paths: tuple[Path, ...],
    input_dir: Path,
    output_dir: Path,
    ratio_str: str,
    force: bool,
    auto_orient: bool,
) -> None:
    """Pad images with black bars to match the OneWorld aspect ratio.

    With no PATHS, scans --input (defaults to ``maps/``) for jpg/png/webp
    images and writes padded copies to --output (defaults to
    ``maps/padded/``). Source files are never modified.

    By default, portrait sources are padded to the inverted (portrait)
    target ratio so they don't get pillarboxed into landscape. Pass
    --no-auto-orient to force every output into the literal --ratio.
    """
    target_w, target_h = parse_ratio(ratio_str)
    targets = list(paths) if paths else _discover(input_dir, output_dir)
    if not targets:
        click.echo(f"No images found under {input_dir}.")
        return

    for src in targets:
        dst = output_dir / src.name
        if dst.exists() and not force:
            click.echo(f"skip   {src.name} (already padded; pass --force to overwrite)")
            continue
        with Image.open(src) as raw:
            oriented = ImageOps.exif_transpose(raw) or raw
            src_w, src_h = oriented.size
        if auto_orient and src_h > src_w:
            tw, th = target_h, target_w
        else:
            tw, th = target_w, target_h
        w, h = pad_to_aspect(src, dst, tw, th)
        click.echo(f"padded {src.name} -> {dst} ({w}x{h})")


if __name__ == "__main__":
    main()
