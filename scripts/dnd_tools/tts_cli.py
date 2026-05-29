"""`tts` CLI — Tabletop Simulator save/mod tooling.

Phase 1 stub. Real subcommands (pull-saves/unpack/pack/combine/assets)
land in Phase 3.
"""

from __future__ import annotations

import click


@click.group()
@click.version_option()
def main() -> None:
    """Sync, edit, merge, and back up Tabletop Simulator content."""


@main.command()
def ping() -> None:
    """Smoke test — prints 'pong'."""
    click.echo("pong")


if __name__ == "__main__":
    main()
