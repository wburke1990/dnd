-- Harness that loads the REAL DND Mini Injector script (f211ac.lua) with the
-- Tabletop Simulator API mocked, then drives its initiative tracker through
-- three consecutive combats to prove:
--   * a number typed into a tracker row (setInitEntry) overrides that mini's
--     own initiative and is used for sorting,
--   * the value/mod/name tie-break sort is correct,
--   * Reset clears every typed override AND every mini re-rolls next combat
--     (i.e. nobody is left stuck on last fight's number).
--
-- Run:  lua init_tracker_harness.lua <path-to-f211ac.lua>
-- Exits non-zero on the first failed assertion.

local target = arg[1] or error("usage: lua init_tracker_harness.lua <f211ac.lua>")

------------------------------------------------------------------- assertions
local failures = 0
local function check(cond, msg)
    if not cond then
        failures = failures + 1
        io.stderr:write("FAIL: " .. msg .. "\n")
    end
end
local function order_of()
    -- return { {name=, value=}, ... } in current sorted initFigures order
    local out = {}
    for _, f in ipairs(env_initFigures()) do
        out[#out + 1] = { name = f.name, value = f.initValue, mod = f.initMod }
    end
    return out
end

------------------------------------------------------------------ mock minis
-- Each mock mini mirrors the real per-mini initiative logic (getInitiative /
-- calculateInitiative / resetInitiative from the injected template) so that
-- reset->reroll behaviour is exercised for real. Rolls are a fixed sequence
-- per mini instead of math.random, so results are deterministic.
local function makeMini(spec)
    local opt = {
        initSettingsIncluded = spec.included ~= false,
        initSettingsMod = spec.mod or 0,
        initSettingsRolling = spec.rolling and true or false,
        initSettingsValue = spec.fixedValue or 100,
        initRealActive = false,
        initRealValue = 0,
        initMockActive = false,
        initMockValue = 0,
    }
    local rollIdx = 0
    local function calc()
        if opt.initSettingsRolling then
            rollIdx = rollIdx + 1
            local r = spec.rolls[rollIdx]
            if r == nil then error(spec.name .. " ran out of scripted rolls") end
            return r + opt.initSettingsMod
        end
        return opt.initSettingsValue
    end
    local function getInitiative(inputActive)
        if opt.initRealActive == true then return opt.initRealValue end
        if inputActive == true then
            opt.initRealActive = true
            if opt.initMockActive == true then
                opt.initRealValue = opt.initMockValue
            else
                opt.initRealValue = calc()
            end
            return opt.initRealValue
        end
        if opt.initMockActive == true then return opt.initMockValue end
        opt.initMockActive = true
        opt.initMockValue = calc()
        return opt.initMockValue
    end
    local function resetInitiative()
        if spec.brokenReset then return end -- simulate a mini whose own reset no-ops
        opt.initSettingsValue = 100
        opt.initRealActive = false
        opt.initRealValue = 0
        opt.initMockActive = false
        opt.initMockValue = 0
    end
    local o = {}
    o._attached = spec.attached == true
    o.getGUID = function() return spec.guid end
    o.getName = function() return spec.name end
    o.getVar = function(k)
        if k == "className" then return "DNDMiniInjector_Mini" end
        if k == "player" then return spec.player and true or false end
        if k == "miniHighlight" then return "highlightNone" end
        return nil
    end
    o.getColorTint = function() return { 1, 1, 1, r = 1, g = 1, b = 1 } end
    o.getTable = function(name)
        if name == "options" then return opt end
        if name == "health" then return spec.health end
        return nil
    end
    o.UI = { getAttribute = function() return "" end }
    o.call = function(fn, arg)
        if fn == "getInitiative" then return getInitiative(arg) end
        if fn == "resetInitiative" then return resetInitiative() end
        error("mini.call unexpected: " .. tostring(fn))
    end
    o.setTable = function(name, t)
        if name == "options" then opt = t end
    end
    return o
end

----------------------------------------------------------------- TTS API mocks
-- An object that matches the mini className filter but has no working
-- resetInitiative (like a plain measurement ruler). Calling it throws.
local function makeBadToken(guid)
    local o = {}
    o.getGUID = function() return guid end
    o.getName = function() return "Ruler" end
    o.getVar = function(k)
        if k == "className" then return "MeasurementToken" end
        return nil
    end
    o.call = function(fn) error("no such function on this object: " .. tostring(fn)) end
    return o
end

local MINIS = {}
local MINI_LIST = {}
local function registerMinis(list)
    MINIS = {}
    MINI_LIST = {}
    for _, m in ipairs(list) do
        MINIS[m.getGUID()] = m
        MINI_LIST[#MINI_LIST + 1] = m
    end
end

local env = setmetatable({}, { __index = _G })
env.JSON = {
    encode = function() return "" end,
    decode = function() return nil end,
}
env.self = {
    UI = {
        setAttribute = function() end,
        getAttribute = function() return "" end,
        getXmlTable = function() return { {}, { children = {} } } end,
        setXmlTable = function() end,
    },
    setVar = function() end,
    getVar = function() return nil end,
    setName = function() end,
    getName = function() return "Injector" end,
}
env.broadcastToAll = function() end
env.print = function() end
env.setNotes = function() end
env.getNotes = function() return "" end
env.addHotkey = function() end
env.Wait = { frames = function() end, time = function() end }
env.Physics = { cast = function() return {} end }
env.Grid = { sizeX = 1 }
env.Color = setmetatable(
    { White = { 1, 1, 1, r = 1, g = 1, b = 1 } },
    { __index = function() return { 1, 1, 1, r = 1, g = 1, b = 1 } end }
)
env.getObjectFromGUID = function(g) return MINIS[g] end
env.getAllObjects = function()
    -- Insertion order, so a "bad object first" scenario is deterministic. Minis
    -- flagged attached are hidden here (getAllObjects cannot see attached
    -- objects), though a Physics cast still finds them.
    local t = {}
    for _, m in ipairs(MINI_LIST) do
        if not m._attached then t[#t + 1] = m end
    end
    return t
end
env.getMapBounds = function() return { x = 100, y = 40, z = 100 } end
env.os = os
env.math = math

----------------------------------------------------------- load the real code
-- Read the injector source and drop its two long-bracket COMMENT blocks: the
-- mini Lua template (--[[LUAStart .. LUAStop--lua]]) and the XML UI template
-- (--[[XMLStart .. XMLStop--xml]]). Both are inert here -- the tracker code the
-- harness drives lives after them, and the per-mini template functions inside
-- them are stood in for by the mock minis above. Both blocks nest --[[ .. ]],
-- which PUC Lua 5.1 rejects ("nesting of [[...]] is deprecated"); stripping
-- them lets the harness run under 5.1 as well as 5.2+/LuaJIT, leaving the
-- executable injector code untouched.
local srcFile = assert(io.open(target, "r"))
local src = srcFile:read("*a")
srcFile:close()
src = src:gsub("%-%-%[%[LUAStart.-LUAStop%-%-lua%]%]", "")
src = src:gsub("%-%-%[%[XMLStart.-XMLStop%-%-xml%]%]", "")

local chunk
if setfenv then -- Lua 5.1 / LuaJIT: load() takes no env arg; sandbox via setfenv.
    chunk = assert(loadstring(src, "@" .. target))
    setfenv(chunk, env)
else -- Lua 5.2+: pass the sandbox as the _ENV upvalue.
    chunk = assert(load(src, "@" .. target, "t", env))
end
chunk()
env.initTableOnly = false -- use getAllObjects() path, not Physics.cast

function env_initFigures() return env.initFigures end

-- Fallbacks in case the injector relied on a helper only in the mini template.
if type(env.tintToHex) ~= "function" then
    env.tintToHex = function() return "FFFFFF" end
end

------------------------------------------------------------------ the scenario
-- Two players (initiative typed in each combat) and two rolling monsters.
local party = {
    aniess = { guid = "aa0001", name = "Aniess", player = true, mod = 1,
        health = { value = 15, max = 15 } },
    sarric = { guid = "bb0002", name = "Sarric", player = true, mod = 3,
        health = { value = 20, max = 20 } },
}
local monsters = {
    gobA = { guid = "cc0003", name = "GoblinA", player = false, rolling = true,
        mod = 2, rolls = { 15, 3, 11 }, health = { value = 7, max = 7 } },
    gobB = { guid = "dd0004", name = "GoblinB", player = false, rolling = true,
        mod = 0, rolls = { 9, 14, 14 }, health = { value = 7, max = 7 } },
}

-- Typed player initiatives per combat, and the order we expect afterwards.
local combats = {
    { entries = { aniess = 17, sarric = 12 },
      expect = { "GoblinA", "Aniess", "Sarric", "GoblinB" },   -- 17(+2),17(+1),12,9
      values = { GoblinA = 17, Aniess = 17, Sarric = 12, GoblinB = 9 } },
    { entries = { aniess = 8, sarric = 19 },
      expect = { "Sarric", "GoblinB", "Aniess", "GoblinA" },   -- 19,14,8,5
      values = { Sarric = 19, GoblinB = 14, Aniess = 8, GoblinA = 5 } },
    { entries = { aniess = 20, sarric = 5 },
      expect = { "Aniess", "GoblinB", "GoblinA", "Sarric" },   -- 20,14,13,5
      values = { Aniess = 20, GoblinB = 14, GoblinA = 13, Sarric = 5 } },
}

-- Build minis fresh once; they persist across combats (as on the real table),
-- so the reset->reroll path is what makes monsters advance their roll sequence.
local minis = {
    makeMini(party.aniess), makeMini(party.sarric),
    makeMini(monsters.gobA), makeMini(monsters.gobB),
}
registerMinis(minis)
local guidOf = { Aniess = "aa0001", Sarric = "bb0002", GoblinA = "cc0003", GoblinB = "dd0004" }

for i, combat in ipairs(combats) do
    -- 1. Players call out their rolls; DM types them into the tracker rows.
    for who, val in pairs(combat.entries) do
        env.setInitEntry(nil, tostring(val), party[who].guid .. "_init_entry")
    end
    -- 2. DM opens the panel (refresh) and hits Roll.
    env.refreshInitiative(nil)
    env.rollInitiative(nil)

    -- 3. Order and values must match.
    local got = order_of()
    check(#got == 4, ("combat %d: expected 4 figures, got %d"):format(i, #got))
    for pos, name in ipairs(combat.expect) do
        local g = got[pos]
        check(g and g.name == name,
            ("combat %d pos %d: expected %s, got %s"):format(i, pos, name, g and g.name or "nil"))
        if g then
            check(g.value == combat.values[name],
                ("combat %d %s: expected init %d, got %s"):format(
                    i, name, combat.values[name], tostring(g.value)))
        end
    end
    -- The roll must actually have started (players were all set -> not blocked).
    check(env.options.initActive == true, ("combat %d: initActive should be true"):format(i))

    io.write(("Combat %d: "):format(i))
    for _, g in ipairs(got) do io.write(("%s=%d  "):format(g.name, g.value)) end
    io.write("\n")

    -- 4. End of combat: Reset.
    env.resetInitiative()

    -- 5. Reset must wipe every typed override and clear combat state.
    check(next(env.options.manualInits) == nil,
        ("combat %d: manualInits not cleared by reset"):format(i))
    check(env.options.initActive == false,
        ("combat %d: initActive should be false after reset"):format(i))
end

------------------------------------------------- focused: reset reverts a mini
-- Type an override, reset, then recompute: the figure must no longer show the
-- typed number (it reverts to the mini's own initiative), proving reset does
-- not leave a creature pinned to last fight's value.
do
    registerMinis({ makeMini(monsters.gobA) }) -- fresh goblin, rolls {15,...}
    env.setInitEntry(nil, "99", "cc0003_init_entry")
    env.getInitiativeFigures()
    check(env.initFigures[1].initValue == 99, "override should apply before reset")
    env.resetInitiative()
    env.getInitiativeFigures()
    check(env.initFigures[1].initValue ~= 99,
        "after reset the mini must not still read the typed 99")
end

------------------------------------- focused: reset scrubs even off-list minis
-- A mini that has dropped out of the initiative list (initSettingsIncluded =
-- false, e.g. 0 HP or include toggled off) with a leftover value must STILL be
-- cleared by Reset (the whole point of the clean-slate reset), and its roll/
-- fixed flag must survive so auto-rolled vs player-entered stays distinct. With
-- the old reset (which only touched minis in the list) the off-list value would
-- persist -- this asserts it no longer does.
do
    local stalePlayer = makeMini({
        guid = "ee0005", name = "StalePC", player = true, rolling = false,
        fixedValue = 13, included = false, health = { value = 5, max = 5 },
    })
    local staleMonster = makeMini({
        guid = "ff0006", name = "StaleGob", player = false, rolling = true, mod = 2,
        rolls = { 10 }, included = false, health = { value = 0, max = 7 },
    })
    registerMinis({ stalePlayer, staleMonster })
    -- Leftover combat state, as if a fight had happened before the reset.
    stalePlayer.getTable("options").initRealActive = true
    stalePlayer.getTable("options").initRealValue = 13
    staleMonster.getTable("options").initRealActive = true
    staleMonster.getTable("options").initRealValue = 12

    env.resetInitiative()

    local p = stalePlayer.getTable("options")
    local m = staleMonster.getTable("options")
    check(p.initSettingsValue == 100, "off-list player value must scrub to 100 on reset")
    check(p.initRealActive == false, "off-list player cached roll must clear on reset")
    check(p.initSettingsRolling == false, "player stays fixed/player-rolled after reset")
    check(m.initSettingsValue == 100, "off-list monster value must scrub to 100 on reset")
    check(m.initRealActive == false, "off-list monster cached roll must clear on reset")
    check(m.initSettingsRolling == true, "monster stays auto-rolled after reset")
end

------------------------------ focused: a bad object can't abort the reset sweep
-- Regression for the four PC minis (Pax/Blackacre/Jasper) that stayed stale: an
-- object matching the mini className but with no resetInitiative (a plain
-- measurement token) was aborting the sweep, so every mini after it in the
-- iteration kept last fight's value. The bad token is placed FIRST here, so an
-- unguarded sweep would throw before ever reaching the minis.
do
    local pax = makeMini({
        guid = "d33651", name = "Pax", player = true, rolling = false,
        health = { value = 10, max = 10 },
    })
    local blackacre = makeMini({
        guid = "0fcdd5", name = "Blackacre", player = true, rolling = false,
        health = { value = 10, max = 10 },
    })
    registerMinis({ makeBadToken("bad001"), pax, blackacre })
    -- Leftover on-table state, like Pax=24 / Blackacre=18 before the reset.
    pax.getTable("options").initRealActive = true
    pax.getTable("options").initRealValue = 24
    blackacre.getTable("options").initRealActive = true
    blackacre.getTable("options").initRealValue = 18

    env.resetInitiative()

    check(pax.getTable("options").initRealActive == false,
        "Pax must reset even though a bad token comes first in the sweep")
    check(pax.getTable("options").initSettingsValue == 100, "Pax value must scrub to 100")
    check(blackacre.getTable("options").initRealActive == false,
        "Blackacre must reset even though a bad token comes first in the sweep")
end

------------------------- focused: reset reaches attached minis (Physics path)
-- The real save runs initTableOnly=true, so minis are found by a Physics cast,
-- not getAllObjects. A mini attached to another object is invisible to
-- getAllObjects but the cast still finds it -- this is what left Pax, Blackacre,
-- and Jasper stuck (the tracker showed them via the cast, but the old reset
-- swept getAllObjects and never reached them). Reset must use the same
-- cast-based discovery and clear it.
do
    env.initTableOnly = true
    env.Physics = { cast = function()
        local h = {}
        for _, m in ipairs(MINI_LIST) do h[#h + 1] = { hit_object = m } end
        return h
    end }
    local pax = makeMini({
        guid = "d33651", name = "Pax", player = true, rolling = true, mod = 0,
        rolls = { 5 }, attached = true, health = { value = 10, max = 10 },
    })
    pax.getTable("options").initRealActive = true
    pax.getTable("options").initRealValue = 24
    registerMinis({ pax })
    check(#env.getAllObjects() == 0, "attached mini is invisible to getAllObjects (sim)")
    env.resetInitiative()
    check(pax.getTable("options").initRealActive == false,
        "attached mini found via Physics cast must reset")
    check(pax.getTable("options").initRealValue == 0, "attached mini cached value must clear")
    check(pax.getTable("options").initSettingsValue == 100, "attached mini value scrubs to 100")
    env.initTableOnly = false
    env.Physics = { cast = function() return {} end }
end

------------------------ focused: reset clears a mini whose own reset is broken
-- The stuck PC minis reset their banner (initSettingsValue -> 100) but left
-- initRealActive/initRealValue set, so the tracker list kept showing last
-- fight's number. Reset now zeroes that cache directly (getTable/setTable),
-- not trusting the mini's own reset. Simulate a mini whose resetInitiative
-- no-ops and assert the cache is cleared anyway.
do
    local pax = makeMini({
        guid = "d33651", name = "Pax", player = true, rolling = true, mod = 0,
        rolls = { 5 }, brokenReset = true, health = { value = 10, max = 10 },
    })
    pax.getTable("options").initRealActive = true
    pax.getTable("options").initRealValue = 24
    registerMinis({ pax })
    env.resetInitiative()
    check(pax.getTable("options").initRealActive == false,
        "broken-reset mini: cache active flag cleared directly")
    check(pax.getTable("options").initRealValue == 0,
        "broken-reset mini: cached value (24) zeroed directly")
end

--------------------------------------------------- focused: empty clears entry
do
    registerMinis({ makeMini(monsters.gobB) })
    env.setInitEntry(nil, "42", "dd0004_init_entry")
    check(env.options.manualInits["dd0004"] == 42, "entry should store 42")
    env.setInitEntry(nil, "", "dd0004_init_entry")
    check(env.options.manualInits["dd0004"] == nil, "empty string should clear the entry")
end

if failures == 0 then
    print("ALL CHECKS PASSED")
    os.exit(0)
else
    io.stderr:write(("\n%d CHECK(S) FAILED\n"):format(failures))
    os.exit(1)
end
