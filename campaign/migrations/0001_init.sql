-- Initial schema for the dnd campaign database.
--
-- Source of truth for the campaign. Edit via the `dnd` CLI (which uses
-- parameterized inserts) or, for bulk imports, by adding a new migration
-- file 0002_*.sql alongside this one — never hand-edit campaign.db.
--
-- Naming conventions:
--   * Tables: plural snake_case (`npcs`, `session_npcs`)
--   * IDs: `id` PK, `<table>_id` FK
--   * Optional fields: NULL, not empty string
--   * Free-form notes: a `notes` column on every entity table
--   * Timestamps: ISO 8601 strings via DEFAULT (datetime('now'))

PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

-- =============================================================================
-- Entities
-- =============================================================================

CREATE TABLE IF NOT EXISTS factions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT NOT NULL UNIQUE,
    alignment    TEXT,                   -- e.g. "Lawful Evil"
    description  TEXT,
    notes        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS locations (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT NOT NULL,
    kind         TEXT,                   -- city|town|dungeon|region|plane|landmark|other
    parent_id    INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    region       TEXT,
    description  TEXT,
    notes        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (name, parent_id)
);

CREATE TABLE IF NOT EXISTS npcs (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT NOT NULL UNIQUE,
    race         TEXT,
    class        TEXT,                   -- free-form: "Wizard (Diviner) 8"
    level        INTEGER,
    alignment    TEXT,
    hp           INTEGER,
    hp_max       INTEGER,
    ac           INTEGER,
    str          INTEGER,
    dex          INTEGER,
    con          INTEGER,
    "int"        INTEGER,                -- quoted: SQL reserved word
    wis          INTEGER,
    cha          INTEGER,
    status       TEXT NOT NULL DEFAULT 'alive',  -- alive|dead|missing|unknown
    location_id  INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    faction_id   INTEGER REFERENCES factions(id)  ON DELETE SET NULL,
    description  TEXT,
    notes        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS pcs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    character_name  TEXT NOT NULL UNIQUE,
    player_name     TEXT,
    race            TEXT,
    class           TEXT,
    level           INTEGER,
    alignment       TEXT,
    hp_max          INTEGER,
    ac              INTEGER,
    str             INTEGER,
    dex             INTEGER,
    con             INTEGER,
    "int"           INTEGER,
    wis             INTEGER,
    cha             INTEGER,
    backstory       TEXT,
    notes           TEXT,
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS items (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT NOT NULL,
    kind          TEXT,                  -- weapon|armor|wondrous|consumable|key|scroll|other
    rarity        TEXT,                  -- common|uncommon|rare|very rare|legendary|artifact
    attunement    INTEGER NOT NULL DEFAULT 0,  -- 0|1
    owner_npc_id  INTEGER REFERENCES npcs(id)      ON DELETE SET NULL,
    owner_pc_id   INTEGER REFERENCES pcs(id)       ON DELETE SET NULL,
    location_id   INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    description   TEXT,
    notes         TEXT,
    created_at    TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS sessions (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    number       INTEGER NOT NULL UNIQUE,
    played_on    TEXT,                   -- ISO date, e.g. "2026-05-15"
    title        TEXT,
    recap        TEXT,                   -- markdown
    xp_awarded   INTEGER,
    notes        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS encounters (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id   INTEGER REFERENCES sessions(id)  ON DELETE SET NULL,
    location_id  INTEGER REFERENCES locations(id) ON DELETE SET NULL,
    name         TEXT,
    summary      TEXT,
    outcome      TEXT,                   -- victory|defeat|fled|negotiated|other
    notes        TEXT,
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS lore (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    title        TEXT NOT NULL UNIQUE,
    body         TEXT,
    tags         TEXT,                   -- comma-separated
    created_at   TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at   TEXT NOT NULL DEFAULT (datetime('now'))
);

-- =============================================================================
-- Many-to-many joins
-- =============================================================================

CREATE TABLE IF NOT EXISTS session_npcs (
    session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    npc_id     INTEGER NOT NULL REFERENCES npcs(id)     ON DELETE CASCADE,
    role       TEXT,                     -- encountered|spoke_with|fought|allied|other
    PRIMARY KEY (session_id, npc_id)
);

CREATE TABLE IF NOT EXISTS session_pcs (
    session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    pc_id      INTEGER NOT NULL REFERENCES pcs(id)      ON DELETE CASCADE,
    present    INTEGER NOT NULL DEFAULT 1,  -- 0|1
    PRIMARY KEY (session_id, pc_id)
);

CREATE TABLE IF NOT EXISTS encounter_npcs (
    encounter_id INTEGER NOT NULL REFERENCES encounters(id) ON DELETE CASCADE,
    npc_id       INTEGER NOT NULL REFERENCES npcs(id)       ON DELETE CASCADE,
    PRIMARY KEY (encounter_id, npc_id)
);

-- =============================================================================
-- Search indexes
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_npcs_name      ON npcs(name);
CREATE INDEX IF NOT EXISTS idx_locations_name ON locations(name);
CREATE INDEX IF NOT EXISTS idx_items_name     ON items(name);
CREATE INDEX IF NOT EXISTS idx_factions_name  ON factions(name);
CREATE INDEX IF NOT EXISTS idx_pcs_name       ON pcs(character_name);

-- Migration bookkeeping. db.py reads this and skips already-applied files.
CREATE TABLE IF NOT EXISTS _migrations (
    filename   TEXT PRIMARY KEY,
    applied_at TEXT NOT NULL DEFAULT (datetime('now'))
);
