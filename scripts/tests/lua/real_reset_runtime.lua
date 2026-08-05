-- Integration test: run the REAL initiative reset against REAL mini scripts and
-- REAL saved state, not hand-written mocks.
--
-- Why this exists: for a long debugging session the mock-based harness kept
-- passing while the game kept failing, because the mocks encoded assumptions
-- about how the minis behave. This loads the actual DNDMiniInjector_Mini scripts
-- (fixtures pulled from the save) with their actual LuaScriptState, wires the
-- cross-object API the way TTS does (getVar/getTable/setTable/call across
-- objects), and runs the actual injector resetInitiative -- so the mini's own
-- resetInitiative/getInitiative run for real. It catches script-logic
-- regressions in reset/discovery. (It can NOT catch environmental failures like
-- TTS running a stale copy of the injector -- that one needs a real relaunch.)
--
-- Run: lua real_reset_runtime.lua <injector-f211ac.lua> <fixtures-dir>

local injectorPath = arg[1] or error("usage: lua real_reset_runtime.lua <injector.lua> <fixtures-dir>")
local FIX = arg[2] or error("need fixtures dir")

local failures = 0
local function check(cond, msg)
    if not cond then failures = failures + 1; io.stderr:write("FAIL: " .. msg .. "\n") end
end

local function readFile(path)
    local f = assert(io.open(path, "r")); local s = f:read("*a"); f:close(); return s
end
local function deepcopy(t)
    if type(t) ~= "table" then return t end
    local c = {}; for k, v in pairs(t) do c[k] = deepcopy(v) end; return c
end

-- minimal JSON decode (objects/arrays/strings/numbers/bool/null)
local function jsonDecode(s)
    local i = 1
    local function skip() while i <= #s and s:sub(i, i):match("%s") do i = i + 1 end end
    local parseValue
    local function parseString()
        i = i + 1; local buf = {}
        while i <= #s do
            local c = s:sub(i, i)
            if c == '"' then i = i + 1; return table.concat(buf) end
            if c == '\\' then
                local n = s:sub(i + 1, i + 1)
                local map = { ['"'] = '"', ['\\'] = '\\', ['/'] = '/', b = '\b', f = '\f', n = '\n', r = '\r', t = '\t' }
                if n == 'u' then buf[#buf + 1] = '?'; i = i + 6 else buf[#buf + 1] = map[n] or n; i = i + 2 end
            else buf[#buf + 1] = c; i = i + 1 end
        end
        error("unterminated string")
    end
    local function parseNumber()
        local j = i
        while i <= #s and s:sub(i, i):match("[%d%.eE%+%-]") do i = i + 1 end
        return tonumber(s:sub(j, i - 1))
    end
    local function parseObject()
        i = i + 1; local o = {}; skip()
        if s:sub(i, i) == '}' then i = i + 1; return o end
        while true do
            skip(); local k = parseString(); skip(); i = i + 1; skip()
            o[k] = parseValue(); skip()
            local c = s:sub(i, i); i = i + 1
            if c == '}' then return o end
        end
    end
    local function parseArray()
        i = i + 1; local a = {}; skip()
        if s:sub(i, i) == ']' then i = i + 1; return a end
        while true do
            skip(); a[#a + 1] = parseValue(); skip()
            local c = s:sub(i, i); i = i + 1
            if c == ']' then return a end
        end
    end
    parseValue = function()
        skip(); local c = s:sub(i, i)
        if c == '{' then return parseObject() end
        if c == '[' then return parseArray() end
        if c == '"' then return parseString() end
        if c == 't' then i = i + 4; return true end
        if c == 'f' then i = i + 5; return false end
        if c == 'n' then i = i + 4; return nil end
        return parseNumber()
    end
    return parseValue()
end

-- permissive stub: callable + indexable, always returns itself, so any TTS API
-- we don't care about (self.UI.x(...), Wait.frames(...)) is a harmless no-op.
local Stub = {}
setmetatable(Stub, { __index = function() return Stub end, __call = function() return Stub end })

local OBJECTS = {}
local function makeHandle(guid, env)
    local h = {}
    h.getGUID = function() return guid end
    h.getName = function() return env.__nick or guid end
    h.getVar = function(k) return env[k] end
    h.setVar = function(k, v) env[k] = v end
    h.getTable = function(k) return deepcopy(env[k]) end
    h.setTable = function(k, t) env[k] = deepcopy(t) end
    h.call = function(fn, a)
        local f = rawget(env, fn)
        if type(f) ~= "function" then error(guid .. " has no function " .. tostring(fn)) end
        return f(a)
    end
    h.UI = Stub
    return h
end

local STD = { "string", "table", "math", "os", "ipairs", "pairs", "next", "tostring",
    "tonumber", "type", "select", "error", "assert", "pcall", "xpcall", "setmetatable",
    "getmetatable", "rawget", "rawset", "rawequal", "print", "unpack", "coroutine" }

local function loadObject(guid, nick, scriptPath, statePath, extra)
    local env = {}
    for _, n in ipairs(STD) do env[n] = _G[n] end
    env.table.unpack = table.unpack
    env._G = env
    env.JSON = { decode = jsonDecode, encode = function() return "" end }
    env.getObjectFromGUID = function(g) local o = OBJECTS[g]; return o and o.handle or nil end
    env.getAllObjects = function()
        local t = {}; for _, o in pairs(OBJECTS) do t[#t + 1] = o.handle end; return t
    end
    env.getMapBounds = function() return { x = 100, y = 40, z = 100 } end
    env.__nick = nick
    setmetatable(env, { __index = function() return Stub end })

    local handle = makeHandle(guid, env)
    env.self = handle
    OBJECTS[guid] = { handle = handle, env = env }

    assert(loadfile(scriptPath, "t", env))()
    if statePath then
        local st = jsonDecode(readFile(statePath))
        if type(st) == "table" then
            if st.options then env.options = st.options end
            if st.player ~= nil then env.player = st.player end
            if st.health then env.health = st.health end
        end
    end
    if extra then for k, v in pairs(extra) do env[k] = v end end
    return handle, env
end

------------------------------------------------------------- scenario
local jasper = loadObject("d2e736", "Mr. Big Sword", FIX .. "/d2e736.script.lua", FIX .. "/d2e736.state.json")
local aniess = loadObject("74df20", "Aniess", FIX .. "/74df20.script.lua", FIX .. "/74df20.state.json")
local _, injEnv = loadObject("f211ac", "Injector", injectorPath, FIX .. "/f211ac.state.json")
injEnv.initTableOnly = true -- the real save's mode: Physics-cast discovery
injEnv.Physics = { cast = function() return { { hit_object = jasper }, { hit_object = aniess } } end }

-- Sanity: the fixtures really are the stuck / cached state we debugged.
check(OBJECTS["d2e736"].env.className == "DNDMiniInjector_Mini", "Jasper className is DNDMiniInjector_Mini")
check(OBJECTS["d2e736"].env.options.initRealActive == true, "fixture: Jasper starts with a live cached roll")
check(OBJECTS["d2e736"].env.options.initRealValue ~= 0, "fixture: Jasper cached value is non-zero")

injEnv.resetInitiative()

for _, g in ipairs({ "d2e736", "74df20" }) do
    local o = OBJECTS[g].env.options
    check(o.initRealActive == false, g .. ": initRealActive cleared by injector reset")
    check(o.initRealValue == 0, g .. ": initRealValue zeroed by injector reset")
end

-- Isolation: a mini's OWN resetInitiative also clears (the obj.call path).
local jFresh = loadObject("d2e736c", "JasperFresh", FIX .. "/d2e736.script.lua", FIX .. "/d2e736.state.json")
check(OBJECTS["d2e736c"].env.options.initRealActive == true, "fresh Jasper starts cached")
jFresh.call("resetInitiative")
check(OBJECTS["d2e736c"].env.options.initRealActive == false, "mini's own resetInitiative clears the cache")

if failures == 0 then
    print("ALL CHECKS PASSED")
    os.exit(0)
else
    io.stderr:write(("\n%d CHECK(S) FAILED\n"):format(failures))
    os.exit(1)
end
