"""Rich-based formatters for the `dnd` CLI.

Stat-block / panel layout matches the preview the user picked when
choosing the SQLite + CLI option — boxed sections with a heading bar,
two-column key/value rows for stats, and a notes line at the bottom.
"""

from __future__ import annotations

import sqlite3

from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.text import Text

console = Console()


def _kv(label: str, value: object) -> str:
    """Format a key/value pair for the inline stat strip."""
    if value is None or value == "":
        return f"[dim]{label}:[/dim] [dim]—[/dim]"
    return f"[bold]{label}:[/bold] {value}"


def _stats_line(row: sqlite3.Row) -> str:
    """Compact ability-score line."""
    parts = [
        f"STR {row['str'] or '—'}",
        f"DEX {row['dex'] or '—'}",
        f"CON {row['con'] or '—'}",
        f"INT {row['int'] or '—'}",
        f"WIS {row['wis'] or '—'}",
        f"CHA {row['cha'] or '—'}",
    ]
    return "  ".join(parts)


def render_npc(row: sqlite3.Row, location_name: str | None, faction_name: str | None) -> Panel:
    body = Text()
    body.append(f"Race:    {row['race'] or '—'}\n")
    body.append(f"Class:   {row['class'] or '—'}")
    if row["level"]:
        body.append(f"  (lvl {row['level']})")
    body.append("\n")
    hp = (
        f"{row['hp']}/{row['hp_max']}"
        if row["hp"] is not None and row["hp_max"] is not None
        else (str(row["hp"] or row["hp_max"]) if (row["hp"] or row["hp_max"]) else "—")
    )
    body.append(f"HP: {hp}   AC: {row['ac'] or '—'}   Loc: {location_name or '—'}\n")
    body.append(f"Faction: {faction_name or '—'}\n")
    body.append(f"Status:  {row['status']}\n")
    body.append(f"Stats:   {_stats_line(row)}\n")
    if row["description"]:
        body.append(f"\n{row['description']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(body, title=f"[bold]{row['name']}[/bold]", border_style="cyan", expand=False)


def render_pc(row: sqlite3.Row) -> Panel:
    body = Text()
    body.append(f"Player:  {row['player_name'] or '—'}\n")
    body.append(f"Race:    {row['race'] or '—'}\n")
    body.append(f"Class:   {row['class'] or '—'}")
    if row["level"]:
        body.append(f"  (lvl {row['level']})")
    body.append("\n")
    body.append(f"HP max:  {row['hp_max'] or '—'}   AC: {row['ac'] or '—'}\n")
    body.append(f"Stats:   {_stats_line(row)}\n")
    if row["backstory"]:
        body.append(f"\n{row['backstory']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(
        body, title=f"[bold]{row['character_name']}[/bold]", border_style="green", expand=False
    )


def render_location(row: sqlite3.Row, parent_name: str | None) -> Panel:
    body = Text()
    body.append(f"Kind:    {row['kind'] or '—'}\n")
    body.append(f"Region:  {row['region'] or '—'}\n")
    body.append(f"Within:  {parent_name or '—'}\n")
    if row["description"]:
        body.append(f"\n{row['description']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(body, title=f"[bold]{row['name']}[/bold]", border_style="yellow", expand=False)


def render_faction(row: sqlite3.Row) -> Panel:
    body = Text()
    body.append(f"Alignment: {row['alignment'] or '—'}\n")
    if row["description"]:
        body.append(f"\n{row['description']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(body, title=f"[bold]{row['name']}[/bold]", border_style="magenta", expand=False)


def render_item(row: sqlite3.Row, owner_name: str | None, location_name: str | None) -> Panel:
    body = Text()
    body.append(f"Kind:       {row['kind'] or '—'}\n")
    body.append(f"Rarity:     {row['rarity'] or '—'}\n")
    body.append(f"Attunement: {'yes' if row['attunement'] else 'no'}\n")
    body.append(f"Owner:      {owner_name or '—'}\n")
    body.append(f"Location:   {location_name or '—'}\n")
    if row["description"]:
        body.append(f"\n{row['description']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(body, title=f"[bold]{row['name']}[/bold]", border_style="blue", expand=False)


def render_session(
    row: sqlite3.Row,
    npcs: list[sqlite3.Row],
    pcs: list[sqlite3.Row],
    encounters: list[sqlite3.Row],
) -> Panel:
    body = Text()
    body.append(f"Date:    {row['played_on'] or '—'}\n")
    body.append(f"Title:   {row['title'] or '—'}\n")
    body.append(f"XP:      {row['xp_awarded'] or '—'}\n")
    if pcs:
        body.append(f"\nParty:   {', '.join(p['character_name'] for p in pcs)}\n")
    if npcs:
        body.append(f"NPCs:    {', '.join(n['name'] for n in npcs)}\n")
    if encounters:
        body.append("\nEncounters:\n")
        for enc in encounters:
            body.append(f"  • {enc['name'] or '(untitled)'} — {enc['outcome'] or 'outcome ?'}\n")
    if row["recap"]:
        body.append(f"\n{row['recap']}\n")
    if row["notes"]:
        body.append(f"\n[Notes] {row['notes']}")
    return Panel(
        body,
        title=f"[bold]Session {row['number']}[/bold]",
        border_style="red",
        expand=False,
    )


def render_search_results(rows: list[tuple[str, int, str, str]]) -> Table:
    """Compact table for `dnd search`. Rows: (kind, id, name, snippet)."""
    table = Table(show_header=True, header_style="bold")
    table.add_column("Kind", style="dim", width=10)
    table.add_column("Name")
    table.add_column("Match", overflow="fold")
    for kind, _id, name, snippet in rows:
        table.add_row(kind, name, snippet)
    return table


def not_found(kind: str, query: str) -> None:
    console.print(f"[dim]No {kind} found matching[/dim] [bold]{query}[/bold]")
