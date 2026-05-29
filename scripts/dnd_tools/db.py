"""SQLite connection + migrations for the campaign database.

The DB file at `campaign/campaign.db` is committed to the repo and is the
source of truth for campaign content. Migrations live at
`campaign/migrations/NNNN_*.sql` and are applied in lexical order; each
filename is recorded in the `_migrations` table so re-applying is a
no-op.

Schema changes ship as a new migration file — never hand-edit the .db.
"""

from __future__ import annotations

import sqlite3
from collections.abc import Iterator
from contextlib import contextmanager
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_DB_PATH = REPO_ROOT / "campaign" / "campaign.db"
MIGRATIONS_DIR = REPO_ROOT / "campaign" / "migrations"


def connect(db_path: Path | str | None = None) -> sqlite3.Connection:
    """Open the campaign DB, ensuring schema is up to date."""
    path = Path(db_path) if db_path is not None else DEFAULT_DB_PATH
    path.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    apply_migrations(conn)
    return conn


def apply_migrations(conn: sqlite3.Connection) -> list[str]:
    """Apply every un-applied migration in lexical order. Returns names applied."""
    conn.execute(
        "CREATE TABLE IF NOT EXISTS _migrations ("
        "filename TEXT PRIMARY KEY, "
        "applied_at TEXT NOT NULL DEFAULT (datetime('now')))"
    )
    applied = {row[0] for row in conn.execute("SELECT filename FROM _migrations").fetchall()}
    newly_applied: list[str] = []
    for sql_file in sorted(MIGRATIONS_DIR.glob("*.sql")):
        if sql_file.name in applied:
            continue
        with conn:
            conn.executescript(sql_file.read_text())
            conn.execute(
                "INSERT OR IGNORE INTO _migrations(filename) VALUES (?)",
                (sql_file.name,),
            )
        newly_applied.append(sql_file.name)
    return newly_applied


@contextmanager
def transaction(conn: sqlite3.Connection) -> Iterator[sqlite3.Connection]:
    """Transactional context manager. Rolls back on exception."""
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
