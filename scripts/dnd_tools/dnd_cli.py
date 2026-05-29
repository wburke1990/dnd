"""`dnd` CLI — campaign database queries.

Phase 1 stub. Real subcommands (npc/location/session/add/...) land in
Phase 2 once the SQLite schema is in place.
"""

from __future__ import annotations

import click


@click.group()
@click.version_option()
def main() -> None:
    """Query and edit the dnd campaign database."""


@main.command()
def ping() -> None:
    """Smoke test — prints 'pong'."""
    click.echo("pong")


if __name__ == "__main__":
    main()
