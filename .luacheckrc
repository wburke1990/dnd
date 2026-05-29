-- luacheck config for Tabletop Simulator scripts.
-- TTS injects a large set of globals into every object's Lua environment;
-- without declaring them, luacheck would flag virtually every line.
-- Reference: https://api.tabletopsimulator.com/

std = "lua53"
max_line_length = 140

-- TTS globals available in every script.
read_globals = {
    -- Object-scope self-reference (only present in object scripts).
    "self",

    -- Singletons / managers.
    "Global", "Wait", "Player", "Turns", "Lighting", "Notes", "Hands",
    "Clock", "Color", "Vector", "JSON", "RPGFigurine", "Music", "Grid",
    "PhysicsInfo", "WebRequest", "UI", "Backgrounds", "Counter", "Decals",
    "TextTool", "Time", "GameObject", "RGB", "Info",

    -- Object lifecycle / event handlers TTS invokes by name.
    "onLoad", "onSave", "onUpdate", "onFixedUpdate", "onPlayerChangeColor",
    "onPlayerConnect", "onPlayerDisconnect", "onPlayerTurn", "onObjectDrop",
    "onObjectPickUp", "onObjectEnterContainer", "onObjectLeaveContainer",
    "onObjectSearchStart", "onObjectSearchEnd", "onObjectSpawn",
    "onObjectDestroy", "onObjectCollisionEnter", "onObjectCollisionExit",
    "onObjectCollisionStay", "onObjectNumberTyped", "onObjectPageChange",
    "onObjectRotate", "onScriptingButtonDown", "onScriptingButtonUp",
    "onChat", "onExternalMessage", "onScriptingMessage",

    -- Utility functions.
    "getObjectFromGUID", "getAllObjects", "getObjects", "getSeatedPlayers",
    "spawnObject", "spawnObjectData", "spawnObjectJSON", "destroyObject",
    "copy", "paste", "group", "ungroup", "printToAll", "printToColor",
    "broadcastToAll", "broadcastToColor", "log", "logString", "logStyle",
    "startLuaCoroutine", "stopLuaCoroutine", "coroutine", "tostring",
    "tonumber", "type", "ipairs", "pairs", "select", "math", "string",
    "table", "os", "bit32",
}

-- Globals scripts may legitimately define for cross-object access.
globals = { "MOD_VERSION" }

-- Allow uppercase-leading variable names (TTS guidance encourages them).
ignore = {
    "611",  -- line contains only whitespace
    "612",  -- line contains trailing whitespace
    "631",  -- line is too long (handled by max_line_length)
}

-- Extracted Lua files are organized as tts/lua/<save>/<guid>.lua —
-- treat each as an independent script.
files["tts/lua/**/*.lua"] = {}
