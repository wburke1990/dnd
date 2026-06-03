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
    w, h = pad_to_aspect(src, dst, 1600, 945)
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
    w, h = pad_to_aspect(src, dst, 1600, 945)
    assert (w, h) == (1600, 945)
    out = Image.open(dst).convert("RGB")
    assert out.getpixel((0, 0)) == (0, 0, 0)
    assert out.getpixel((w // 2, h // 2)) == (255, 0, 0)


def test_pad_matching_source_unchanged_size(tmp_path: Path) -> None:
    src = tmp_path / "exact.png"
    dst = tmp_path / "padded.png"
    _solid(src, 1600, 945)
    w, h = pad_to_aspect(src, dst, 1600, 945)
    assert (w, h) == (1600, 945)


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
    assert Image.open(out_dir / "a.png").size == (1600, 945)
    assert Image.open(out_dir / "b.png").size == (1600, 945)


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
    assert Image.open(out_dir / "a.png").size == (round(100 * 16 / 9), 100)


def test_cli_empty_input_dir(tmp_path: Path) -> None:
    src_dir = tmp_path / "maps"
    out_dir = tmp_path / "padded"
    src_dir.mkdir()

    runner = CliRunner()
    result = runner.invoke(main, ["--input", str(src_dir), "--output", str(out_dir)])
    assert result.exit_code == 0
    assert "No images found" in result.output
