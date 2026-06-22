-- luacheck config for Tabletop Simulator scripts.
--
-- Every .lua file in this repo is a machine-exported per-object script,
-- unpacked from a TTS save via `tts unpack` -- almost all of it the
-- OneWorld mod (by Borbold) plus the campaign objects built on top of it.
-- We don't hand-author these scripts; even our OneWorld Hub change is a
-- surgical edit inside an existing mod object. So luacheck here is NOT a
-- style linter -- it is a crash-tripwire gate: it ignores all of the mod's
-- stylistic noise (unused vars, its cross-object global soup, shadowing,
-- whitespace) and fails ONLY on a genuine syntax error that would break a
-- script in-game. Reference: https://api.tabletopsimulator.com/
--
-- Two deliberate consequences:
--   * Every warning family (1xx-6xx) is ignored; only hard syntax errors
--     (E0xx) can fail the run. Re-enable families selectively below if this
--     repo ever gains hand-authored Lua worth style-checking.
--   * Files using MoonSharp-only syntax are auto-excluded: the `!=`
--     not-equal operator (our Hub object itself uses it and runs fine) and
--     `||`-style lambdas (e.g. `Wait.time(|| foo(), 0.1)`). Both are valid
--     in TTS but standard-Lua luacheck can't parse them, so they would
--     otherwise report false-positive syntax errors on working game code.
--     Neither token is legal standard Lua, so their presence reliably marks
--     a MoonSharp file. These files can't be linted without rewriting them,
--     which we won't do -- it would diverge the committed mirror from the
--     live save.

std = "lua53"
max_line_length = 140

-- Ignore every warning family; keep only hard syntax errors (E0xx). The
-- entries are luacheck code patterns: "1.." matches any 1xx code, etc.
ignore = { "1..", "2..", "3..", "4..", "5..", "6.." }

-- Auto-exclude files using MoonSharp-only syntax (`!=`, `||` lambdas).
-- Scanning the tree (rather than hardcoding a 120+ file list) keeps this
-- correct as new maps are imported. Paths are emitted in both repo-relative
-- and absolute form so the exclusion matches whether luacheck is invoked as
-- `luacheck tts/lua` from the repo root (the documented form) or with an
-- absolute path (the git pre-commit hook). Run from the repo root.
local MOONSHARP_TOKENS = { "!=", "||" }

local function uses_moonsharp_syntax(body)
    for _, token in ipairs(MOONSHARP_TOKENS) do
        if body:find(token, 1, true) then
            return true
        end
    end
    return false
end

local function files_using_moonsharp(root)
    local ok_lfs, lfs = pcall(require, "lfs")
    if not ok_lfs then
        return {}
    end
    local cwd = lfs.currentdir()
    local hits = {}
    local function walk(dir)
        for entry in lfs.dir(dir) do
            if entry ~= "." and entry ~= ".." then
                local path = dir .. "/" .. entry
                local attr = lfs.attributes(path)
                if attr and attr.mode == "directory" then
                    walk(path)
                elseif entry:sub(-4) == ".lua" then
                    local fh = io.open(path, "r")
                    if fh then
                        local body = fh:read("*a")
                        fh:close()
                        if body and uses_moonsharp_syntax(body) then
                            hits[#hits + 1] = path
                            if cwd then
                                hits[#hits + 1] = cwd .. "/" .. path
                            end
                        end
                    end
                end
            end
        end
    end
    pcall(walk, root)
    return hits
end

exclude_files = files_using_moonsharp("tts/lua")
