"""`dnd` CLI — campaign database queries and edits.

Subcommand groups:
  query: `dnd npc <name>`, `dnd location ...`, `dnd session <#>`, ...
  add:   `dnd add npc <name> [--race ... --class ... ...]`
  link:  `dnd link npc-session <npc-name> <session-#>`
  util:  `dnd search <text>`, `dnd export`, `dnd migrate`

Name lookups are fuzzy (case-insensitive substring match). For ambiguity,
the CLI lists the candidates and exits non-zero so scripts can pipe.
"""

from __future__ import annotations

import sqlite3
import sys
from pathlib import Path
from typing import Any

import click

from . import db
from . import formatters as fmt
from .formatters import console

# =============================================================================
# Helpers
# =============================================================================


def _fuzzy_find(
    conn: sqlite3.Connection, table: str, name_col: str, query: str
) -> list[sqlite3.Row]:
    """Case-insensitive substring match on a single name column."""
    sql = (
        f"SELECT * FROM {table} WHERE {name_col} LIKE ? COLLATE NOCASE ORDER BY length({name_col})"
    )
    return conn.execute(sql, (f"%{query}%",)).fetchall()


def _resolve_one(
    conn: sqlite3.Connection, table: str, name_col: str, query: str, kind: str
) -> sqlite3.Row | None:
    """Return the single matching row, or print disambiguation and return None."""
    rows = _fuzzy_find(conn, table, name_col, query)
    if not rows:
        fmt.not_found(kind, query)
        return None
    if len(rows) == 1:
        return rows[0]
    # Exact (case-insensitive) match wins if present.
    exact = [r for r in rows if r[name_col].lower() == query.lower()]
    if len(exact) == 1:
        return exact[0]
    console.print(f"[yellow]{len(rows)} {kind}s match[/yellow] [bold]{query}[/bold]:")
    for r in rows[:20]:
        console.print(f"  • {r[name_col]}")
    if len(rows) > 20:
        console.print(f"  [dim]... and {len(rows) - 20} more[/dim]")
    return None


def _name_or_none(
    conn: sqlite3.Connection, table: str, name_col: str, row_id: int | None
) -> str | None:
    if row_id is None:
        return None
    row = conn.execute(f"SELECT {name_col} FROM {table} WHERE id = ?", (row_id,)).fetchone()
    return row[name_col] if row else None


# =============================================================================
# Top-level group
# =============================================================================


@click.group()
@click.option(
    "--db",
    "db_path",
    type=click.Path(path_type=Path),
    default=None,
    help="Override path to campaign.db (defaults to campaign/campaign.db).",
)
@click.version_option()
@click.pass_context
def main(ctx: click.Context, db_path: Path | None) -> None:
    """Query and edit the dnd campaign database."""
    ctx.ensure_object(dict)
    ctx.obj["conn"] = db.connect(db_path)


# =============================================================================
# Query commands
# =============================================================================


@main.command()
@click.argument("query")
@click.pass_context
def npc(ctx: click.Context, query: str) -> None:
    """Look up an NPC by name fragment."""
    conn = ctx.obj["conn"]
    row = _resolve_one(conn, "npcs", "name", query, "npc")
    if not row:
        sys.exit(1)
    loc = _name_or_none(conn, "locations", "name", row["location_id"])
    fac = _name_or_none(conn, "factions", "name", row["faction_id"])
    console.print(fmt.render_npc(row, loc, fac))


@main.command()
@click.argument("query")
@click.pass_context
def pc(ctx: click.Context, query: str) -> None:
    """Look up a PC by character name fragment."""
    conn = ctx.obj["conn"]
    row = _resolve_one(conn, "pcs", "character_name", query, "pc")
    if not row:
        sys.exit(1)
    console.print(fmt.render_pc(row))


@main.command()
@click.argument("query")
@click.pass_context
def location(ctx: click.Context, query: str) -> None:
    """Look up a location by name fragment."""
    conn = ctx.obj["conn"]
    row = _resolve_one(conn, "locations", "name", query, "location")
    if not row:
        sys.exit(1)
    parent = _name_or_none(conn, "locations", "name", row["parent_id"])
    console.print(fmt.render_location(row, parent))


@main.command()
@click.argument("query")
@click.pass_context
def faction(ctx: click.Context, query: str) -> None:
    """Look up a faction by name fragment."""
    conn = ctx.obj["conn"]
    row = _resolve_one(conn, "factions", "name", query, "faction")
    if not row:
        sys.exit(1)
    console.print(fmt.render_faction(row))


@main.command()
@click.argument("query")
@click.pass_context
def item(ctx: click.Context, query: str) -> None:
    """Look up an item by name fragment."""
    conn = ctx.obj["conn"]
    row = _resolve_one(conn, "items", "name", query, "item")
    if not row:
        sys.exit(1)
    owner = _name_or_none(conn, "npcs", "name", row["owner_npc_id"]) or _name_or_none(
        conn, "pcs", "character_name", row["owner_pc_id"]
    )
    loc = _name_or_none(conn, "locations", "name", row["location_id"])
    console.print(fmt.render_item(row, owner, loc))


@main.command()
@click.argument("number", type=int)
@click.pass_context
def session(ctx: click.Context, number: int) -> None:
    """Look up a session by number, with linked NPCs/PCs/encounters."""
    conn = ctx.obj["conn"]
    row = conn.execute("SELECT * FROM sessions WHERE number = ?", (number,)).fetchone()
    if not row:
        fmt.not_found("session", str(number))
        sys.exit(1)
    npcs = conn.execute(
        "SELECT n.* FROM npcs n JOIN session_npcs sn ON sn.npc_id = n.id "
        "WHERE sn.session_id = ? ORDER BY n.name",
        (row["id"],),
    ).fetchall()
    pcs = conn.execute(
        "SELECT p.* FROM pcs p JOIN session_pcs sp ON sp.pc_id = p.id "
        "WHERE sp.session_id = ? AND sp.present = 1 ORDER BY p.character_name",
        (row["id"],),
    ).fetchall()
    encs = conn.execute(
        "SELECT * FROM encounters WHERE session_id = ? ORDER BY id",
        (row["id"],),
    ).fetchall()
    console.print(fmt.render_session(row, list(npcs), list(pcs), list(encs)))


@main.command()
@click.argument("query")
@click.pass_context
def search(ctx: click.Context, query: str) -> None:
    """Full-text search across NPCs, PCs, locations, factions, items, lore."""
    conn = ctx.obj["conn"]
    like = f"%{query}%"
    rows: list[tuple[str, int, str, str]] = []
    specs = [
        ("npc", "npcs", "name", ("name", "description", "notes")),
        ("pc", "pcs", "character_name", ("character_name", "backstory", "notes")),
        ("location", "locations", "name", ("name", "description", "notes")),
        ("faction", "factions", "name", ("name", "description", "notes")),
        ("item", "items", "name", ("name", "description", "notes")),
        ("lore", "lore", "title", ("title", "body", "tags")),
    ]
    for kind, table, name_col, search_cols in specs:
        clause = " OR ".join(f"{c} LIKE ? COLLATE NOCASE" for c in search_cols)
        sql = f"SELECT id, {name_col} AS name FROM {table} WHERE {clause}"
        for r in conn.execute(sql, (like,) * len(search_cols)).fetchall():
            snippet = _snippet_for(conn, table, r["id"], search_cols, query)
            rows.append((kind, r["id"], r["name"], snippet))
    if not rows:
        fmt.not_found("entity", query)
        sys.exit(1)
    console.print(fmt.render_search_results(rows))


def _snippet_for(
    conn: sqlite3.Connection,
    table: str,
    row_id: int,
    cols: tuple[str, ...],
    query: str,
) -> str:
    """Find the first column that contains query and return ~80 chars around it."""
    quoted_cols = ", ".join(f'"{c}"' for c in cols)
    row = conn.execute(f"SELECT {quoted_cols} FROM {table} WHERE id = ?", (row_id,)).fetchone()
    if row is None:
        return ""
    for col in cols:
        value = row[col]
        if value and query.lower() in value.lower():
            i = value.lower().index(query.lower())
            start = max(0, i - 30)
            end = min(len(value), i + len(query) + 50)
            prefix = "…" if start > 0 else ""
            suffix = "…" if end < len(value) else ""
            return f"{col}: {prefix}{value[start:end]}{suffix}"
    return ""


# =============================================================================
# Add commands
# =============================================================================


@main.group("add")
def add_group() -> None:
    """Add a new entity to the campaign."""


def _insert(conn: sqlite3.Connection, table: str, fields: dict[str, Any]) -> int:
    clean = {k: v for k, v in fields.items() if v is not None}
    cols = ", ".join(f'"{k}"' for k in clean)
    placeholders = ", ".join("?" for _ in clean)
    with db.transaction(conn):
        cur = conn.execute(
            f"INSERT INTO {table} ({cols}) VALUES ({placeholders})",
            tuple(clean.values()),
        )
    return int(cur.lastrowid or 0)


@add_group.command("npc")
@click.argument("name")
@click.option("--race")
@click.option("--class", "class_")
@click.option("--level", type=int)
@click.option("--alignment")
@click.option("--hp", type=int)
@click.option("--hp-max", type=int)
@click.option("--ac", type=int)
@click.option("--str", "str_", type=int)
@click.option("--dex", type=int)
@click.option("--con", type=int)
@click.option("--int", "int_", type=int)
@click.option("--wis", type=int)
@click.option("--cha", type=int)
@click.option("--status", default="alive")
@click.option("--location")
@click.option("--faction")
@click.option("--description")
@click.option("--notes")
@click.pass_context
def add_npc(
    ctx: click.Context,
    name: str,
    race: str | None,
    class_: str | None,
    level: int | None,
    alignment: str | None,
    hp: int | None,
    hp_max: int | None,
    ac: int | None,
    str_: int | None,
    dex: int | None,
    con: int | None,
    int_: int | None,
    wis: int | None,
    cha: int | None,
    status: str,
    location: str | None,
    faction: str | None,
    description: str | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    location_id = _lookup_id(conn, "locations", "name", location) if location else None
    faction_id = _lookup_id(conn, "factions", "name", faction) if faction else None
    new_id = _insert(
        conn,
        "npcs",
        {
            "name": name,
            "race": race,
            "class": class_,
            "level": level,
            "alignment": alignment,
            "hp": hp,
            "hp_max": hp_max,
            "ac": ac,
            "str": str_,
            "dex": dex,
            "con": con,
            "int": int_,
            "wis": wis,
            "cha": cha,
            "status": status,
            "location_id": location_id,
            "faction_id": faction_id,
            "description": description,
            "notes": notes,
        },
    )
    console.print(f"[green]Added NPC[/green] [bold]{name}[/bold] (id={new_id})")


@add_group.command("pc")
@click.argument("character_name")
@click.option("--player")
@click.option("--race")
@click.option("--class", "class_")
@click.option("--level", type=int)
@click.option("--alignment")
@click.option("--hp-max", type=int)
@click.option("--ac", type=int)
@click.option("--str", "str_", type=int)
@click.option("--dex", type=int)
@click.option("--con", type=int)
@click.option("--int", "int_", type=int)
@click.option("--wis", type=int)
@click.option("--cha", type=int)
@click.option("--backstory")
@click.option("--notes")
@click.pass_context
def add_pc(
    ctx: click.Context,
    character_name: str,
    player: str | None,
    race: str | None,
    class_: str | None,
    level: int | None,
    alignment: str | None,
    hp_max: int | None,
    ac: int | None,
    str_: int | None,
    dex: int | None,
    con: int | None,
    int_: int | None,
    wis: int | None,
    cha: int | None,
    backstory: str | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    new_id = _insert(
        conn,
        "pcs",
        {
            "character_name": character_name,
            "player_name": player,
            "race": race,
            "class": class_,
            "level": level,
            "alignment": alignment,
            "hp_max": hp_max,
            "ac": ac,
            "str": str_,
            "dex": dex,
            "con": con,
            "int": int_,
            "wis": wis,
            "cha": cha,
            "backstory": backstory,
            "notes": notes,
        },
    )
    console.print(f"[green]Added PC[/green] [bold]{character_name}[/bold] (id={new_id})")


@add_group.command("location")
@click.argument("name")
@click.option("--kind")
@click.option("--parent")
@click.option("--region")
@click.option("--description")
@click.option("--notes")
@click.pass_context
def add_location(
    ctx: click.Context,
    name: str,
    kind: str | None,
    parent: str | None,
    region: str | None,
    description: str | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    parent_id = _lookup_id(conn, "locations", "name", parent) if parent else None
    new_id = _insert(
        conn,
        "locations",
        {
            "name": name,
            "kind": kind,
            "parent_id": parent_id,
            "region": region,
            "description": description,
            "notes": notes,
        },
    )
    console.print(f"[green]Added location[/green] [bold]{name}[/bold] (id={new_id})")


@add_group.command("faction")
@click.argument("name")
@click.option("--alignment")
@click.option("--description")
@click.option("--notes")
@click.pass_context
def add_faction(
    ctx: click.Context,
    name: str,
    alignment: str | None,
    description: str | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    new_id = _insert(
        conn,
        "factions",
        {
            "name": name,
            "alignment": alignment,
            "description": description,
            "notes": notes,
        },
    )
    console.print(f"[green]Added faction[/green] [bold]{name}[/bold] (id={new_id})")


@add_group.command("item")
@click.argument("name")
@click.option("--kind")
@click.option("--rarity")
@click.option("--attunement", is_flag=True)
@click.option("--owner-npc")
@click.option("--owner-pc")
@click.option("--location")
@click.option("--description")
@click.option("--notes")
@click.pass_context
def add_item(
    ctx: click.Context,
    name: str,
    kind: str | None,
    rarity: str | None,
    attunement: bool,
    owner_npc: str | None,
    owner_pc: str | None,
    location: str | None,
    description: str | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    owner_npc_id = _lookup_id(conn, "npcs", "name", owner_npc) if owner_npc else None
    owner_pc_id = _lookup_id(conn, "pcs", "character_name", owner_pc) if owner_pc else None
    location_id = _lookup_id(conn, "locations", "name", location) if location else None
    new_id = _insert(
        conn,
        "items",
        {
            "name": name,
            "kind": kind,
            "rarity": rarity,
            "attunement": 1 if attunement else 0,
            "owner_npc_id": owner_npc_id,
            "owner_pc_id": owner_pc_id,
            "location_id": location_id,
            "description": description,
            "notes": notes,
        },
    )
    console.print(f"[green]Added item[/green] [bold]{name}[/bold] (id={new_id})")


@add_group.command("session")
@click.argument("number", type=int)
@click.option("--date", "played_on")
@click.option("--title")
@click.option("--recap")
@click.option("--xp", "xp_awarded", type=int)
@click.option("--notes")
@click.pass_context
def add_session(
    ctx: click.Context,
    number: int,
    played_on: str | None,
    title: str | None,
    recap: str | None,
    xp_awarded: int | None,
    notes: str | None,
) -> None:
    conn = ctx.obj["conn"]
    new_id = _insert(
        conn,
        "sessions",
        {
            "number": number,
            "played_on": played_on,
            "title": title,
            "recap": recap,
            "xp_awarded": xp_awarded,
            "notes": notes,
        },
    )
    console.print(f"[green]Added session[/green] [bold]#{number}[/bold] (id={new_id})")


@add_group.command("lore")
@click.argument("title")
@click.option("--body")
@click.option("--tags", help="Comma-separated.")
@click.pass_context
def add_lore(
    ctx: click.Context,
    title: str,
    body: str | None,
    tags: str | None,
) -> None:
    conn = ctx.obj["conn"]
    new_id = _insert(conn, "lore", {"title": title, "body": body, "tags": tags})
    console.print(f"[green]Added lore[/green] [bold]{title}[/bold] (id={new_id})")


# =============================================================================
# Link / Util
# =============================================================================


def _lookup_id(conn: sqlite3.Connection, table: str, name_col: str, query: str) -> int:
    """Strict lookup by name — raises a click error if ambiguous or missing."""
    rows = _fuzzy_find(conn, table, name_col, query)
    if not rows:
        raise click.ClickException(f"no {table} matching {query!r}")
    if len(rows) > 1:
        exact = [r for r in rows if r[name_col].lower() == query.lower()]
        if len(exact) == 1:
            return int(exact[0]["id"])
        names = ", ".join(r[name_col] for r in rows[:5])
        raise click.ClickException(
            f"ambiguous {table} match for {query!r}: {names}" + (" …" if len(rows) > 5 else "")
        )
    return int(rows[0]["id"])


@main.group("link")
def link_group() -> None:
    """Create a relationship between two entities."""


@link_group.command("npc-session")
@click.argument("npc_name")
@click.argument("session_number", type=int)
@click.option("--role", default="encountered")
@click.pass_context
def link_npc_session(ctx: click.Context, npc_name: str, session_number: int, role: str) -> None:
    conn = ctx.obj["conn"]
    npc_id = _lookup_id(conn, "npcs", "name", npc_name)
    session_row = conn.execute(
        "SELECT id FROM sessions WHERE number = ?", (session_number,)
    ).fetchone()
    if not session_row:
        raise click.ClickException(f"no session #{session_number}")
    with db.transaction(conn):
        conn.execute(
            "INSERT OR REPLACE INTO session_npcs(session_id, npc_id, role) VALUES (?, ?, ?)",
            (session_row["id"], npc_id, role),
        )
    console.print(f"[green]Linked[/green] {npc_name} → session {session_number} ({role})")


@link_group.command("pc-session")
@click.argument("pc_name")
@click.argument("session_number", type=int)
@click.option("--absent", is_flag=True, help="Mark the PC as absent (default present).")
@click.pass_context
def link_pc_session(ctx: click.Context, pc_name: str, session_number: int, absent: bool) -> None:
    conn = ctx.obj["conn"]
    pc_id = _lookup_id(conn, "pcs", "character_name", pc_name)
    session_row = conn.execute(
        "SELECT id FROM sessions WHERE number = ?", (session_number,)
    ).fetchone()
    if not session_row:
        raise click.ClickException(f"no session #{session_number}")
    with db.transaction(conn):
        conn.execute(
            "INSERT OR REPLACE INTO session_pcs(session_id, pc_id, present) VALUES (?, ?, ?)",
            (session_row["id"], pc_id, 0 if absent else 1),
        )
    console.print(
        f"[green]Linked[/green] {pc_name} → session {session_number} "
        f"({'absent' if absent else 'present'})"
    )


@main.command()
@click.pass_context
def migrate(ctx: click.Context) -> None:
    """Apply any pending schema migrations."""
    conn = ctx.obj["conn"]
    applied = db.apply_migrations(conn)
    if applied:
        console.print(f"[green]Applied {len(applied)} migration(s):[/green] " + ", ".join(applied))
    else:
        console.print("[dim]No migrations to apply.[/dim]")


@main.command()
@click.option(
    "--out",
    type=click.Path(path_type=Path),
    default=None,
    help="Output file (default: stdout).",
)
@click.pass_context
def export(ctx: click.Context, out: Path | None) -> None:
    """Dump the DB as human-readable SQL (good for diffing)."""
    conn = ctx.obj["conn"]
    lines = list(conn.iterdump())
    payload = "\n".join(lines)
    if out:
        out.write_text(payload)
        console.print(f"[green]Wrote[/green] {out} ({len(lines)} lines)")
    else:
        click.echo(payload)


if __name__ == "__main__":
    main()
