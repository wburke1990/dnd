"""Tests for the pad-maps CLI."""

from __future__ import annotations

from pathlib import Path

import pytest
from click.testing import CliRunner
from PIL import Image

from dnd_tools.pad_maps import main, pad_to_aspect, parse_ratio


def _solid(path: Path, w: int, h: int, color: tuple[int, int, int] = (255, 0, 0)) -> None:
    Image.new("RGB", (w, h), color).save(path)


def test_parse_ratio_colon() -> None:
    assert parse_ratio("1600:945") == (1600, 945)


def test_parse_ratio_x() -> None:
    assert parse_ratio("16x9") == (16, 9)


def test_parse_ratio_rejects_garbage() -> None:
    import click

    with pytest.raises(click.BadParameter):
        parse_ratio("not-a-ratio")


def test_parse_ratio_rejects_zero() -> None:
    import click

    with pytest.raises(click.BadParameter):
        parse_ratio("0:945")


def test_pad_taller_source_adds_horizontal_bars(tmp_path: Path) -> None:
    src = tmp_path / "tall.png"
    dst = tmp_path / "padded.png"
    # Source is taller than 1600:945 -> needs horizontal padding.
    _solid(src, 945, 945)
    w, h = pad_to_aspect(src, dst, 1600, 945, safe_margin=0.0)
    assert (w, h) == (1600, 945)
    out = Image.open(dst).convert("RGB")
    # Corners should be black (padding), center should be source color.
    assert out.getpixel((0, 0)) == (0, 0, 0)
    assert out.getpixel((w - 1, h - 1)) == (0, 0, 0)
    assert out.getpixel((w // 2, h // 2)) == (255, 0, 0)


def test_pad_wider_source_adds_vertical_bars(tmp_path: Path) -> None:
    src = tmp_path / "wide.png"
    dst = tmp_path / "padded.png"
    # Source is wider than 1600:945 -> needs vertical padding.
    _solid(src, 1600, 400)
    w, h = pad_to_aspect(src, dst, 1600, 945, safe_margin=0.0)
    assert (w, h) == (1600, 945)
    out = Image.open(dst).convert("RGB")
    assert out.getpixel((0, 0)) == (0, 0, 0)
    assert out.getpixel((w // 2, h // 2)) == (255, 0, 0)


def test_pad_matching_source_unchanged_size(tmp_path: Path) -> None:
    src = tmp_path / "exact.png"
    dst = tmp_path / "padded.png"
    _solid(src, 1600, 945)
    w, h = pad_to_aspect(src, dst, 1600, 945, safe_margin=0.0)
    assert (w, h) == (1600, 945)


def test_safe_margin_inflates_canvas_uniformly(tmp_path: Path) -> None:
    """With safe_margin > 0, a source already at target ratio still gets bars."""
    src = tmp_path / "exact.png"
    dst = tmp_path / "padded.png"
    _solid(src, 1600, 945)
    w, h = pad_to_aspect(src, dst, 1600, 945, safe_margin=0.05)
    # Canvas should be source / (1 - 2*0.05) = source / 0.9 on each axis.
    assert (w, h) == (round(1600 / 0.9), round(945 / 0.9))
    # Aspect ratio preserved within rounding.
    assert abs(w / h - 1600 / 945) < 0.01
    out = Image.open(dst).convert("RGB")
    # Edges are black, center is source color.
    assert out.getpixel((0, 0)) == (0, 0, 0)
    assert out.getpixel((w // 2, h // 2)) == (255, 0, 0)


def test_safe_margin_landscape_source(tmp_path: Path) -> None:
    """Wide source: short axis still gets ≥5% margin; long axis may have more."""
    src = tmp_path / "wide.png"
    dst = tmp_path / "padded.png"
    _solid(src, 3760, 2895)  # ratio 1.299, narrower than 1.693
    w, h = pad_to_aspect(src, dst, 1600, 945, safe_margin=0.05)
    # Short axis (height): margin on top/bottom should be ~5% of canvas height.
    top_margin = (h - 2895) // 2
    assert top_margin >= round(0.05 * h) - 1
    # Aspect ratio preserved.
    assert abs(w / h - 1600 / 945) < 0.01


def test_safe_margin_default_baked_in(tmp_path: Path) -> None:
    """The CLI without flags should always leave a border, even on exact-ratio sources."""
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "exact.png", 1600, 945)

    runner = CliRunner()
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert result.exit_code == 0, result.output
    w, h = Image.open(out_dir / "exact.png").size
    assert w > 1600 and h > 945, f"expected safe-margin inflation, got {w}x{h}"


def test_cli_processes_directory(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "a.png", 945, 945)
    _solid(src_dir / "b.png", 1600, 400)
    # Non-image file should be ignored.
    (src_dir / "notes.txt").write_text("ignore me")

    runner = CliRunner()
    result = runner.invoke(
        main,
        ["--input", str(src_dir), "--output", str(out_dir)],
    )
    assert result.exit_code == 0, result.output
    assert (out_dir / "a.png").exists()
    assert (out_dir / "b.png").exists()
    # Default safe margin inflates beyond the bare 1600x945 frame.
    aw, ah = Image.open(out_dir / "a.png").size
    bw, bh = Image.open(out_dir / "b.png").size
    assert abs(aw / ah - 1600 / 945) < 0.01
    assert abs(bw / bh - 1600 / 945) < 0.01
    assert aw > 1600 and bw > 1600


def test_cli_skips_existing_without_force(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "a.png", 945, 945)

    runner = CliRunner()
    first = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert first.exit_code == 0
    mtime = (out_dir / "a.png").stat().st_mtime_ns

    second = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert second.exit_code == 0
    assert "skip" in second.output
    assert (out_dir / "a.png").stat().st_mtime_ns == mtime


def test_cli_force_overwrites(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "a.png", 945, 945)

    runner = CliRunner()
    runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir), "--force"])
    assert result.exit_code == 0
    assert "padded" in result.output


def test_cli_explicit_paths(tmp_path: Path) -> None:
    src = tmp_path / "one.png"
    out_dir = tmp_path / "padded"
    _solid(src, 945, 945)

    runner = CliRunner()
    result = runner.invoke(main, [str(src), "--output", str(out_dir)])
    assert result.exit_code == 0
    assert (out_dir / "one.png").exists()


def test_cli_custom_ratio(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "a.png", 100, 100)

    runner = CliRunner()
    result = runner.invoke(
        main,
        ["--input", str(src_dir), "--output", str(out_dir), "--ratio", "16:9"],
    )
    assert result.exit_code == 0
    w, h = Image.open(out_dir / "a.png").size
    # Aspect should be 16:9 within rounding; safe margin inflates beyond source.
    assert abs(w / h - 16 / 9) < 0.01
    assert h >= 100 and w > 100


def test_cli_auto_orient_keeps_portrait_portrait(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    # Portrait source (1024x1536, ratio 0.667). Target is 1600:945 landscape;
    # auto-orient should flip to 945:1600 portrait. Safe margin inflates both axes.
    _solid(src_dir / "tall.png", 1024, 1536)

    runner = CliRunner()
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert result.exit_code == 0, result.output
    out_w, out_h = Image.open(out_dir / "tall.png").size
    assert out_h > out_w, f"expected portrait, got {out_w}x{out_h}"
    # Canvas aspect is 945:1600 (portrait inverse of OneWorld).
    assert abs(out_w / out_h - 945 / 1600) < 0.01
    # Both axes inflated past the source by the safe margin.
    assert out_w > 1024 and out_h > 1536


def test_cli_no_auto_orient_forces_landscape(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "tall.png", 1024, 1536)

    runner = CliRunner()
    result = runner.invoke(
        main,
        ["--input", str(src_dir), "--output", str(out_dir), "--no-auto-orient"],
    )
    assert result.exit_code == 0, result.output
    out_w, out_h = Image.open(out_dir / "tall.png").size
    assert out_w > out_h, f"expected landscape with --no-auto-orient, got {out_w}x{out_h}"


def test_cli_auto_orient_leaves_landscape_alone(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()
    _solid(src_dir / "wide.png", 1600, 400)

    runner = CliRunner()
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert result.exit_code == 0, result.output
    w, h = Image.open(out_dir / "wide.png").size
    # Landscape aspect preserved; safe margin inflates beyond bare 1600x945.
    assert abs(w / h - 1600 / 945) < 0.01
    assert w > h


def test_cli_empty_input_dir(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()

    runner = CliRunner()
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert result.exit_code == 0
    assert "No images found" in result.output
