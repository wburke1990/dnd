-- ====================
-- System
-- ====================

isFromTTT = true
moduleName = "Effects"
tttVersion = "1.3"


-- ====================
-- Local 
-- ====================

-- --------------------
-- Constants
-- --------------------

ASSETBUNDLE_SOUND = 1
ASSETBUNDLE_MUTE  = 2


-- API Constants (don't touch)
TYPE_GENERIC       = 0
MATERIAL_CARDBOARD = 3
AMBIENT_TYPE_BACKGROUND = 1


-- --------------------
-- General
-- --------------------

-- Saved data
tableType     = "default"
scaleSaved    = {x = 1, y = 1, z = 1}
positionSaved = {x = 0, y = 0, z = 0}


-- Values to control where buttons appear on the control panel
buttonInfo = {
    header     = {
        width  = 1050,
        height = 265,
        offset = { x = 0.0, y = 0.0, z = -0.68 },
    },
    main        = {
        size    = 615,
        spacing = 1.35,
        offset  = { x = 0.0, y = 0.0, z = 0.37 }
    },
    effectMain = {           -- UI info for the main effect buttons (i.e., the ones with the effects' names)
        spacing     = 0.85,
        height      = 400,
        width       = 1550,
        brightness  = 0.25,  -- Multiplier for controlling how bright the button colors are (decrease for darker buttons)
        color       = { r = 0, g = 0, b = 0 },
        font_size   = 210,
        font_color  = { r = 1, g = 1, b = 1 },
        offset      = { x = 0.0, y = 0.0, z = 1.92 },
    },
    effectSide  = {      -- UI info for the side buttons
        width   = 450,   -- The width of the buttons (no height specified because these buttons should line up with the loading buttons, and so use their height)
        offsetX = -2.05, -- X-offset for the buttons (no Y and Z specified because these buttons should line up with the loading buttons, and so use their offsets)
    },
}

-- Info about the effects models we have to work with and how they should work in-game
-- varName should match the effect's name in the table
-- loopNumbers should list the various intensities for the effect, with the first being off and the last being max (as appearing in TTS, though in-script indices start at 0 instead of 1)
effects = {

    rain = {

        -- Constants
        name           = "Rain",
        varName        = "rain",
        assetbundle    = "https://steamusercontent-a.akamaihd.net/ugc/1815522464569374225/3339166B2A4A682CBD1534C358D397771B00D77B/",
        loopNumbers    = { 1, 2, 3, 4, 5 },
        position       = {
            default    = { -54.3, 0, -7 },
            kraken     = { -49.1, 0, -8 },
        },
        rotation       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        scale          = {
            default    = { 0.8,  1, 1 },
            kraken     = { 0.63, 1, 0.6 },
        },

        -- Variables
        guid           = nil,
        loopIndex      = nil,
    },

    rainSound = {

        -- Constants
        name           = "Rain (Audible)",
        varName        = "rainSound",
        assetbundle    = "https://steamusercontent-a.akamaihd.net/ugc/1815522464569374285/EB757346CDA3E0DE70A9957FE3A38E989C4C35D5/",
        loopNumbers    = { 1, 2, 3, 4, 5 },
        position       = {
            default    = { -54.3, 0, -7 },
            kraken     = { -49.1, 0, -8 },
        },
        rotation       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        scale          = {
            default    = { 0.8,  1, 1 },
            kraken     = { 0.63, 1, 0.6 },
        },


        -- Variables
        guid           = nil,
        loopIndex      = nil,
    },

    snow = {

        -- Constants
        name           = "Snow",
        varName        = "snow",
        assetbundle    = "https://steamusercontent-a.akamaihd.net/ugc/1815522464569374433/D2A0855C45DE266F29EAE9443CFBE836B643E297/",
        loopNumbers    = { 1, 2 },
        position       = {
            default    = { 0, -0.5, 0 },
            kraken     = { 0, -0.5, 0 },
        },
        rotation       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        scale          = {
            default    = { 0.5, 0.8, 0.5 },
            kraken     = { 0.5, 0.8, 0.5 },
        },


        -- Variables
        guid           = nil,
        loopIndex      = nil,
    },

    snowFast = {

        -- Constants
        name           = "Snow (Fast)",
        varName        = "snowFast",
        assetbundle    = "https://steamusercontent-a.akamaihd.net/ugc/1815522464569374225/3339166B2A4A682CBD1534C358D397771B00D77B/",
        loopNumbers    = { 1, 7, 8, 9, 10 },
        position       = {
            default    = { -54.3,  0, -10  },
            kraken     = { -52.37, 0, -9.9 },
        },
        rotation       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        scale          = {
            default    = { 0.8,  1, 1 },
            kraken     = { 0.58, 1, 0.48 },
        },


        -- Variables
        guid           = nil,
        loopIndex      = nil,
    },

    fog = {

        -- Constants
        name           = "Fog",
        varName        = "fog",
        assetbundle    = "https://steamusercontent-a.akamaihd.net/ugc/1815522464569374169/08ED0E0B839DA7A6F3F0203AE65B0B474402E1A6/",
        loopNumbers    = { 1, 2 },
        position       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        rotation       = {
            default    = { 0, 0, 0 },
            kraken     = { 0, 0, 0 },
        },
        scale          = {
            default    = { 0.5, 0.5, 0.5 },
            kraken     = { 0.5, 0.5, 0.5 },
        },


        -- Variables
        guid           = nil,
        loopIndex      = nil,
    },

}


-- lightning = {
--     duration = 0.1,
--     saved    = nil,
--     strike   = {
--         ambientEquatorColor = {0, 0, 0},
--         ambientGroundColor  = {0, 0, 0},
--         ambientSkyColor     = {0, 0, 0},
--         lightColor          = Lighting.getLightColor(),
--         ambientType         = AMBIENT_TYPE_BACKGROUND,
--         ambientIntensity    = 0,
--         lightIntensity      = 4,
--         reflectionIntensity = 1,
--     },
-- 
-- }


-- ====================
-- Object Callbacks
-- ====================

function onLoad(saveData)

    InitializeModule()


    -- Default data
    tableType = "default"

    LoadJson({ jsonString = saveData })


    -- Table type
    local settingsModule = GetModule("Settings")
    if settingsModule != nil then
        local tableTypeString = settingsModule.call("GetTableTypeStringExternal", nil)
        if tableTypeString != tableType then
            tableType = tableTypeString
        end
    end
    if tableType == nil or tableType == "" then tableType = "default" end


    -- Other initialization
    DestroyEffectObjectOrphans()
    DestroyEffectObjects()
    CreateEffectObjects()

end


function onSave()

    return GetJson()

end


-- ====================
-- Button Callbacks
-- ====================

function OnClickClear(ownerObject, playerColor, isAltClick)

    -- Help
    if isAltClick then
        PrintHelp(playerColor, "CLEAR", {
            "Halts all effects",
        })
        do return end
    end

    ClearEffects()

end


function OnClickHeader(ownerObject, playerColor, isAltClick)

    PrintHelp(playerColor, "EFFECTS (v" .. tttVersion .. ")", {
        "Controls ambient effects, such as rain or fog",
    })

end


function OnClickEffect(ownerObject, playerColor, isAltClick, effect)

    PrintHelp(playerColor, string.upper(effect.name), {
        "The + and - buttons to the side control the " .. string.lower(effect.name) .. " effect on the table.",
    })
    do return end

end


function OnClickEffectAdjustButton(ownerObject, playerColor, isAltClick, delta, effect)

    -- Help
    if isAltClick then

        -- Figure out the name
        local deltaAbsolute = math.abs(delta)
        local name = string.upper(effect.name)
        if delta < 0 then
            name =        tostring(delta) .. " " .. name
        else
            name = "+" .. tostring(delta) .. " " .. name
        end

        -- Figure out the verb for what this delta is doing
        local deltaVerb = ""
        if delta < 0 then deltaVerb = "Decrease" else deltaVerb = "Increase" end


        -- Print the help message
        PrintHelp(playerColor, name, {
            deltaVerb .. " " .. string.lower(effect.name) .. " by " .. tostring(deltaAbsolute) .. ".",
        })
        do return end
    end


    -- Update
    local oldLoopIndex = effect.loopIndex
    effect.loopIndex = math.min(math.max(effect.loopIndex + delta, 1), #effect.loopNumbers)
    if oldLoopIndex != effect.loopIndex then
        UpdateEffect(effect)
        UpdateButtons()
    end

end


-- function OnClickEffectLightning(ownerObject, playerColor, isAltClick)
-- 
--     PrintHelp(playerColor, string.upper("Lightning"), {
--         "Press the ! button for a lightning strike.",
--     })
-- 
-- end


-- function OnClickEffectLightningStrike(ownerObject, playerColor, isAltClick)
-- 
--     LightningStrikeStart()
-- 
-- end


function OnClickPosition(ownerObject, playerColor, isAltClick)

    -- Help
    if isAltClick then
        PrintHelp(playerColor, "POSITION", {
            "Positions all effects.",
            "Add position info to the Description of this control panel, then click Position.  This info must be three different values, separated by commas (for x, y, and z position).  Clicking Position when nothing is in the description resets all effects to their original positions.  Examples:",
            "- \"1.5\": make all effects 1.5 times as large on all axes\n" ..
            "- \"2, -3, 0.5\": offset the effects by 2, -3, and 0.5 on the x, y, and z-axis (respectively)\n"
        })
        do return end
    end

    StoreVectorFromDescription(playerColor, "Position", false, {x = 0, y = 0, z = 0}, positionSaved)

end


function OnClickScale(ownerObject, playerColor, isAltClick)

    -- Help
    if isAltClick then
        PrintHelp(playerColor, "SCALE", {
            "Scales all effects.",
            "Add scaling info to the Description of this control panel, then click Scale.  This info can be a single value (to scale the effects uniformly on all three axes) or three different values separated by commas (to scale the effects on each axis individually).  Clicking Scale when nothing is in the description resets all effects to their original sizes.  Examples:",
            "- \"1.5\": make all effects 1.5 times as large on all axes\n" ..
            "- \"2, 3, 0.5\": make all effects 2x, 3x, and 0.5x as large on the x, y, and z-axis (respectively)\n"
        })
        do return end
    end

    StoreVectorFromDescription(playerColor, "Scaling", true, {x = 1, y = 1, z = 1}, scaleSaved)

end


-- ====================
-- Object Creation Callbacks
-- ====================

function OnEffectObjectCreate(thisEffectObject)

    if thisEffectObject == nil then do return end end

    thisEffectObject.lock()
    thisEffectObject.tooltip         = false
    thisEffectObject.interactable    = false
    thisEffectObject.drag_selectable = false

    local name = thisEffectObject.getName()
    if name == "" then do return end end

    local storedEffect = effects[name]
    if storedEffect == nil then do return end end 

    storedEffect.guid = thisEffectObject.getGUID()
    thisEffectObject.setName("")

    UpdateEffectInternal(thisEffectObject, storedEffect)

end


-- ====================
-- Helpers
-- ====================

function ClearEffects()

    for effectKey, effect in pairs(effects) do
        effect.loopIndex = 1
        UpdateEffect(effect)
    end

    UpdateButtons()

end


function CreateButtonMain(clickFunction, indexFromCenter, tooltip)

    local buttonParams = {}
    buttonParams.function_owner = self
    buttonParams.width          = buttonInfo.main.size
    buttonParams.height         = buttonInfo.main.size
    buttonParams.click_function = clickFunction
    buttonParams.position       = { buttonInfo.main.offset.x + (indexFromCenter * buttonInfo.main.spacing), buttonInfo.main.offset.y, buttonInfo.main.offset.z }
    buttonParams.tooltip        = tooltip
    self.createButton(buttonParams)

end


function CreateButtonHeader()

    local buttonParams = {}
    buttonParams.function_owner = self
    buttonParams.width          = buttonInfo.header.width
    buttonParams.height         = buttonInfo.header.height
    buttonParams.click_function = "OnClickHeader"
    buttonParams.position       = { buttonInfo.header.offset.x, buttonInfo.header.offset.y, buttonInfo.header.offset.z }
    buttonParams.tooltip        = "Effects (Help)"
    self.createButton(buttonParams)

end


function CreateButtonsEffects()

    local minIndex = 1
    local i = 1

    for effectKey, effect in pairs(effects) do

        local maxIndex = #(effect.loopNumbers)

        -- Help
        local funcName = "effectHelp" .. i
        local func = function(ownerObject, playerColor, isAltClick) OnClickEffect(ownerObject, playerColor, isAltClick, effect) end
        self.setVar(funcName, func)
        self.createButton({
            label          = effect.name,
            click_function = funcName,
            function_owner = self,
            position       = { buttonInfo.effectMain.offset.x, buttonInfo.effectMain.offset.y, buttonInfo.effectMain.offset.z + (i - 1) * buttonInfo.effectMain.spacing },
            height         = buttonInfo.effectMain.height,
            width          = buttonInfo.effectMain.width,
            color          = buttonInfo.effectMain.color,
            font_color     = buttonInfo.effectMain.font_color,
            font_size      = buttonInfo.effectMain.font_size,
            tooltip        = effect.name
        })


        -- Minus
        if effect.loopIndex > minIndex then
            funcName = "effectMinus" .. i
            local func = function(ownerObject, playerColor, isAltClick) OnClickEffectAdjustButton(ownerObject, playerColor, isAltClick, -1, effect) end
            self.setVar(funcName, func)
            self.createButton({
                label          = "-",
                click_function = funcName,
                function_owner = self,
                position       = { buttonInfo.effectSide.offsetX, buttonInfo.effectMain.offset.y, buttonInfo.effectMain.offset.z + (i - 1) * buttonInfo.effectMain.spacing },
                height         = buttonInfo.effectMain.height,
                width          = buttonInfo.effectSide.width,
                color          = buttonInfo.effectMain.color,
                font_color     = buttonInfo.effectMain.font_color,
                font_size      = buttonInfo.effectMain.font_size,
                tooltip        = "- " .. effect.name
            })
        end


        -- Plus
        if effect.loopIndex < maxIndex then
            funcName = "effectPlus" .. i
            local func = function(ownerObject, playerColor, isAltClick) OnClickEffectAdjustButton(ownerObject, playerColor, isAltClick, 1, effect) end
            self.setVar(funcName, func)
            self.createButton({
                label          = "+",
                click_function = funcName,
                function_owner = self,
                position       = { -buttonInfo.effectSide.offsetX, buttonInfo.effectMain.offset.y, buttonInfo.effectMain.offset.z + (i - 1) * buttonInfo.effectMain.spacing },
                height         = buttonInfo.effectMain.height,
                width          = buttonInfo.effectSide.width,
                color          = buttonInfo.effectMain.color,
                font_color     = buttonInfo.effectMain.font_color,
                font_size      = buttonInfo.effectMain.font_size,
                tooltip        = "+ " .. effect.name,
            })
        end

        i = i + 1

    end


    -- -- Lightning
    -- local funcName = "effectHelp" .. i
    -- local func = function(ownerObject, playerColor, isAltClick) OnClickEffectLightning(ownerObject, playerColor, isAltClick, effect) end
    -- self.setVar(funcName, func)
    -- self.createButton({
    --     label          = "Lightning",
    --     click_function = funcName,
    --     function_owner = self,
    --     position       = { buttonInfo.effectMain.offset.x, buttonInfo.effectMain.offset.y, buttonInfo.effectMain.offset.z + (i - 1) * buttonInfo.effectMain.spacing },
    --     height         = buttonInfo.effectMain.height,
    --     width          = buttonInfo.effectMain.width,
    --     color          = buttonInfo.effectMain.color,
    --     font_color     = buttonInfo.effectMain.font_color,
    --     font_size      = buttonInfo.effectMain.font_size,
    --     tooltip        = "Lightning"
    -- })

    -- funcName = "effectTrigger" .. i
    -- local func = function(ownerObject, playerColor, isAltClick) OnClickEffectLightningStrike(ownerObject, playerColor, isAltClick) end
    -- self.setVar(funcName, func)
    -- self.createButton({
    --     label          = "!",
    --     click_function = funcName,
    --     function_owner = self,
    --     position       = { -buttonInfo.effectSide.offsetX, buttonInfo.effectMain.offset.y, buttonInfo.effectMain.offset.z + (i - 1) * buttonInfo.effectMain.spacing },
    --     height         = buttonInfo.effectMain.height,
    --     width          = buttonInfo.effectSide.width,
    --     color          = buttonInfo.effectMain.color,
    --     font_color     = buttonInfo.effectMain.font_color,
    --     font_size      = buttonInfo.effectMain.font_size,
    --     tooltip        = "Lightning strike",
    -- })

end


function CreateEffectObjects()

    for effectKey, effect in pairs(effects) do
        UpdateEffect(effect)
    end

end


function DestroyEffectObjects()

    for effectKey, effect in pairs(effects) do
        local allObjects = getAllObjects()
        local index = 0
        local currentObject = nil
        for index, currentObject in ipairs(allObjects) do
            if IsEffectObject(currentObject, effect) then
                currentObject.destruct()
            end
        end
    end

end


function DestroyEffectObjectOrphans()

    for effectKey, effect in pairs(effects) do
        local allObjects = getAllObjects()
        local index = 0
        local currentObject = nil
        for index, currentObject in ipairs(allObjects) do
            if IsEffectObject(currentObject, effect) then
                currentObject.destruct()
            end
        end
    end

end


function IsEffectObjectOrphan(object)

    if object == nil then return false end
    local customParams = object.getCustomObject()
    if customParams == nil or customParams.assetBundle == nil then return false end

    for effectKey, effect in pairs(effects) do
        local pathOrphan = effect.assetBundle:gsub("cloud3.steamusercontent", "cloud-3.steamusercontent")
        if customParams.assetBundle == pathOrphan then return true end
    end

    return false

end


function FindEffectObject(effect)

    -- If it's cached, we're done
    if effect.guid != nil then
        local effectObject = getObjectFromGUID(effect.guid)
        if IsEffectObject(effectObject, effect) then
            return effectObject
        else
            effect.guid = nil
        end
    end


    -- Try to find the object (and clear out any duplicates)
    local foundObject = nil
    local allObjects = getAllObjects()
    local index = 0
    local currentObject = nil
    for index, currentObject in ipairs(allObjects) do
        if IsEffectObject(currentObject, effect) then
            if foundObject == nil then
                foundObject = currentObject
            else
                currentObject.destruct()
            end
        end
    end

    if foundObject then
        effect.guid = foundObject.getGUID()
        return foundObject
    end


    -- If we couldn't find it, make a new one
    local params          = {}
    params.type           = "Custom_AssetBundle"
    params.position       = effect.position[tableType]
    params.rotation       = effect.rotation[tableType]
    params.scale          = effect.scale[tableType]
    params.callback       = "OnEffectObjectCreate"
    params.callback_owner = self
    params.sound          = false

    local customParams = {}
    customParams.type        = TYPE_GENERIC
    customParams.material    = MATERIAL_CARDBOARD
    customParams.assetbundle = effect.assetbundle

    local effectObject = spawnObject(params)
    effectObject.setCustomObject(customParams)
    effectObject.setName(effect.varName)
    effectObject.setColorTint({r = 0, g = 0, b = 0, a = 0})

    effectObject.setLuaScript(
        "isFromTTT = true\n" ..
        "tttEffectLabel = '" .. effect.varName .. "'\n\n"
    )

    InitializeChildObject(effectObject, self)

end


function GetJson()

    -- Build the data to save
    local saveData = {}


    -- Shared info
    saveData.tableType     = tableType
    saveData.scaleSaved    = scaleSaved
    saveData.positionSaved = positionSaved


    -- Entries
    saveData.dataWrapper = {}  -- Use a wrapper to fix JSON errors
    local i = 1
    for effectKey, effect in pairs(effects) do
        saveData.dataWrapper[i] = effect.loopIndex
        i = i + 1
    end


    -- Encode and we're done
    return JSON.encode(saveData)

end


-- function LightingRestore()
-- 
--     if lightning.saved == nil then do return end end
-- 
--     Lighting.setAmbientEquatorColor(lightning.saved.ambientEquatorColor)
--     Lighting.setAmbientGroundColor(lightning.saved.ambientGroundColor)
--     Lighting.setAmbientSkyColor(lightning.saved.ambientSkyColor)
--     Lighting.setLightColor(lightning.saved.lightColor)
--     Lighting.ambient_type = lightning.saved.ambientType
--     Lighting.ambient_intensity = lightning.saved.ambientIntensity
--     Lighting.light_intensity = lightning.saved.lightIntensity
--     Lighting.reflection_intensity = lightning.saved.reflectionIntensity
--     Lighting.apply()
-- 
--     lightning.saved = nil
-- 
-- end


-- function LightingSave()
-- 
--     if lightning.saved != nil then do return end end
-- 
--     lightning.saved = {}
--     lightning.saved.ambientEquatorColor = Lighting.getAmbientEquatorColor()
--     lightning.saved.ambientGroundColor  = Lighting.getAmbientGroundColor()
--     lightning.saved.ambientSkyColor     = Lighting.getAmbientSkyColor()
--     lightning.saved.lightColor          = Lighting.getLightColor()
--     lightning.saved.ambientType         = Lighting.ambient_type
--     lightning.saved.ambientIntensity    = Lighting.ambient_intensity
--     lightning.saved.lightIntensity      = Lighting.light_intensity
--     lightning.saved.reflectionIntensity = Lighting.reflection_intensity
-- 
-- end


-- function LightningStrikeEnd()
-- 
--     LightingRestore()
-- 
-- end


-- function LightningStrikeStart()
-- 
--     LightingSave()
-- 
--     Lighting.setAmbientEquatorColor(lightning.strike.ambientEquatorColor)
--     Lighting.setAmbientGroundColor(lightning.strike.ambientGroundColor)
--     Lighting.setAmbientSkyColor(lightning.strike.ambientSkyColor)
--     Lighting.setLightColor(lightning.strike.lightColor)
--     Lighting.ambient_type = lightning.strike.ambientType
--     Lighting.ambient_intensity = lightning.strike.ambientIntensity
--     Lighting.light_intensity = lightning.strike.lightIntensity
--     Lighting.reflection_intensity = lightning.strike.reflectionIntensity
--     Lighting.apply()
-- 
--     Wait.time(LightningStrikeEnd, lightning.duration, 1)
-- 
-- end


function IsEffectObject(object, effect)

    return object != nil and effect != nil and effect.varName != nil and object.getVar("tttEffectLabel") == effect.varName

end


function LoadJson(params)

    -- Clear out data
    tableType     = ""
    scaleSaved    = {x = 1.0, y = 1.0, z = 1.0}
    positionSaved = {x = 0.0, y = 0.0, z = 0.0}
    for effectKey, effect in pairs(effects) do
        effect.loopIndex = 1
        effect.guid      = nil
    end


    -- Load saved data
    if params != nil and params.jsonString != nil and params.jsonString != "" then
        local loadedData = JSON.decode(params.jsonString)
        if loadedData != nil then

            if loadedData.tableType != nil then tableType = loadedData.tableType end
            if loadedData.scaleSaved     != nil then
                if loadedData.scaleSaved.x != nil then scaleSaved.x = loadedData.scaleSaved.x end
                if loadedData.scaleSaved.y != nil then scaleSaved.y = loadedData.scaleSaved.y end
                if loadedData.scaleSaved.z != nil then scaleSaved.z = loadedData.scaleSaved.z end
            end
            if loadedData.positionSaved     != nil then
                if loadedData.positionSaved.x != nil then positionSaved.x = loadedData.positionSaved.x end
                if loadedData.positionSaved.y != nil then positionSaved.y = loadedData.positionSaved.y end
                if loadedData.positionSaved.z != nil then positionSaved.z = loadedData.positionSaved.z end
            end

            if loadedData.dataWrapper != nil then
                local i = 1
                for effectKey, effect in pairs(effects) do
                    if loadedData.dataWrapper[i] != nil then
                        effect.loopIndex = loadedData.dataWrapper[i]
                    end
                    i = i + 1
                end
            end
        end
    end


    -- Update
    UpdateButtons()

end


function OnUpdateTableType(params)

    if tableType != params.tableTypeString then
        tableType = params.tableTypeString
        UpdateEffects()
    end

end


function StoreVectorFromDescription(playerColor, label, canDoSingle, default, destVector)

    -- Setup
    local vectorOld = CopyTable(destVector)

    ClearTable(destVector)
    destVector.x = default.x
    destVector.y = default.y
    destVector.z = default.z


    -- Grab description
    local description = self.getDescription()
    if description == nil then do return end end
    description = Trim(description)
    if description == "" then
        printToColor("Effects: " .. string.lower(label) .. " reset to original values.", playerColor)
        if vectorOld.x != destVector.x or vectorOld.y != destVector.y or vectorOld.z != destVector.z then
            UpdateEffects()
        end
        do return end
    end
    local vectorStringSplit = Split(description, ",")
    local vectorStringSplitCount = #vectorStringSplit


    -- Single value specified
    if vectorStringSplitCount == 1 and canDoSingle then
        local value = tonumber(vectorStringSplit[1])
        if value == nil then
            PrintError(label .. " Error", "Value in Description was not a number.", playerColor)
            do return end
        end
        destVector.x = value
        destVector.y = value
        destVector.z = value


    -- All three axes specified
    elseif vectorStringSplitCount == 3 then
        local x = tonumber(Trim(vectorStringSplit[1]))
        if x == nil then
            PrintError(label .. " Error", "Value in Description for x-axis not a number.", playerColor)
            do return end
        end

        local y = tonumber(Trim(vectorStringSplit[2]))
        if y == nil then
            PrintError(label .. " Error", "Value in Description for y-axis not a number.", playerColor)
            do return end
        end

        local z = tonumber(Trim(vectorStringSplit[3]))
        if z == nil then
            PrintError(label .. " Error", "Value in Description for z-axis not a number.", playerColor)
            do return end
        end

        destVector.x = x
        destVector.y = y
        destVector.z = z

    -- Invalid number of values specified: just return
    else
        if canDoSingle then
            PrintError(label .. " Error", "Description must give either 1 value (to apply uniformly) or 3 values separated by commas (to apply to axes individually).", playerColor)
        else
            PrintError(label .. " Error", "Description must give 3 values separated by commas.", playerColor)
        end
        do return end
    end


    -- Clear the data
    self.setDescription("")


    -- Update if necessary
    if vectorOld.x != destVector.x or vectorOld.y != destVector.y or vectorOld.z != destVector.z then
        UpdateEffects()
    end
    printToColor("Effects: " .. string.lower(label) .. " set to " .. destVector.x .. ", " .. destVector.y .. ", " .. destVector.z .. ".", playerColor)

end


function UpdateButtons()

    self.clearButtons()
    CreateButtonHeader()
    CreateButtonMain("OnClickScale",   -1, "Scale")
    CreateButtonMain("OnClickPosition", 0, "Position")
    CreateButtonMain("OnClickClear",    1, "Clear")
    CreateButtonsEffects()

end


function UpdateEffect(effect)

    local effectObject = FindEffectObject(effect)
    if effectObject then UpdateEffectInternal(effectObject, effect) end

end


function UpdateEffectInternal(effectObject, effect)

    if effectObject == nil or effect == nil then do return end end
    local loopIndex = effect.loopNumbers[effect.loopIndex]
    if loopIndex == nil then do return end end

    effectObject.AssetBundle.playLoopingEffect(loopIndex - 1) -- -1 because the indices as they appear in TTS start at 1, but under the hood start at 0 (and the data above starts at 1)

    local scaleFinal    = {x = scaleSaved.x,    y = scaleSaved.y,    z = scaleSaved.z}
    local positionFinal = {x = positionSaved.x, y = positionSaved.y, z = positionSaved.z}

    if tableType != nil then

        local scaleEffect = effect.scale[tableType]
        if scaleEffect != nil then
            if scaleEffect[1] != nil then scaleFinal.x = scaleFinal.x * scaleEffect[1] end
            if scaleEffect[2] != nil then scaleFinal.y = scaleFinal.y * scaleEffect[2] end
            if scaleEffect[3] != nil then scaleFinal.z = scaleFinal.z * scaleEffect[3] end
        end

        local positionEffect = effect.position[tableType]
        if positionEffect != nil then
            if positionEffect[1] != nil then positionFinal.x = positionFinal.x + positionEffect[1] end
            if positionEffect[2] != nil then positionFinal.y = positionFinal.y + positionEffect[2] end
            if positionEffect[3] != nil then positionFinal.z = positionFinal.z + positionEffect[3] end
        end

        local rotation = effect.rotation[tableType]
        if rotation != nil then effectObject.setRotation(rotation) end

    end

    effectObject.setScale(scaleFinal)
    effectObject.setPosition(positionFinal)

end


function UpdateEffects(effect)

    for effectKey, effect in pairs(effects) do
        UpdateEffect(effect)
    end

end


-- ====================
-- Engine
-- ====================

-- Constants
EPSILON_POSITION = { x = 0.1,  y = 0.1,  z = 0.1  }
EPSILON_SCALE    = { x = 0.01, y = 0.01, z = 0.01 }


-- Functions
function AdjustAngle(angle)

    if angle == nil or tonumber(angle) == nil then return nil
    if angle > 360 then
        return angle - Round(angle / 360) * 360
    elseif angle < -360 then
        return angle + Round(angle / 360) * 360
    else
        return angle
    end

end


function CallInModules(functionNameString, params, skipSelf)

    local modulesTable = Global.getTable("_TTT_modules")
    if modulesTable == nil then do return end end
    local guidToSkip = (skipSelf == true and self.getGUID() or nil)

    for key, moduleSubTable in pairs(modulesTable) do
        for index, guid in ipairs(moduleSubTable) do
            if guid != guidToSkip then
                local moduleObject = getObjectFromGUID(guid)
                if moduleObject != nil then
                    moduleObject.call(functionNameString, params)
                end
            end
        end
    end

end


function ClearTable(tableToClear)

    if tableToClear == nil then
        do return end
    end

    for key in pairs(tableToClear) do
        tableToClear[key] = nil
    end

end


function CopyTable(tableToCopy)

    local orig_type = type(tableToCopy)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, tableToCopy, nil do
            copy[CopyTable(orig_key)] = CopyTable(orig_value)
        end
        setmetatable(copy, CopyTable(getmetatable(tableToCopy)))
    else -- number, string, boolean, etc
        copy = tableToCopy
    end
    return copy

end


function CountTable(tableToCount)

    if tableToCount == nil then return 0 end

    local count = 0
    for key in pairs(tableToCount) do
        count = count + 1
    end

    return count

end


function DestroyObjects(Predicate)

    local index = 0
    local currentObject = nil
    for index, currentObject in ipairs(getAllObjects()) do
        if Predicate(currentObject) == true then
            currentObject.destroy()
        end
    end

end


function GetModule(moduleName)

    local moduleGuid = Global.getVar("_TTT_" .. moduleName)
    if moduleGuid != nil then return getObjectFromGUID(moduleGuid) end
    return nil

end


function GetPlayer(playerColor)

    local index = 0
    for index, player in ipairs(Player.getPlayers()) do
        if player.color == playerColor then return player end
    end

    return nil

end


function GetTagInfo(object, prefix, patternPrefix, patternSuffix, separator, destTagInfo)

    if destTagInfo == nil then do return end end

    destTagInfo.key   = nil
    destTagInfo.value = 1

    if object == nil then do return end end
    local gmNotes = object.getGMNotes()
    if gmNotes == nil then do return end end
    local gmNotesLength = string.len(gmNotes)
    if gmNotesLength == 0 then do return end end

    local stringStart = string.find(gmNotes, patternPrefix)
    if stringStart == nil or stringStart > gmNotesLength then do return end end
    local stringEnd = string.find(gmNotes, patternSuffix, stringStart + 1)
    if stringEnd == nil or stringEnd > gmNotesLength then do return end end

    local comboString = Trim(string.sub(gmNotes, stringStart + string.len(prefix), stringEnd - 1))
    if string.len(comboString) == 0 then do return end end
    local comboStringSplit = Split(comboString, ((gmNotesInfo == nil or gmNotesInfo.eventSeparator == nil) and " " or gmNotesInfo.eventSeparator))
    local comboStringSplitCount = #comboStringSplit

    if comboStringSplitCount >= 1 then destTagInfo.key   = comboStringSplit[1] end
    if comboStringSplitCount >= 2 then destTagInfo.value = comboStringSplit[2] end

    if destTagInfo.value != nil then destTagInfo.value = tonumber(destTagInfo.value) end
    if destTagInfo.value == nil then destTagInfo.value = 1 end

end


function HasTag(object, tagPattern)

    if object == nil or tagPattern == nil then return false end
    local gmNotes = object.getGMNotes()
    return gmNotes != nil and string.find(gmNotes, tagPattern) != nil

end


function InitializeChildObject(child, parent)

    if child == nil or parent == nil then do return end end

    local childScript = 
        child.getLuaScript() ..
        "parentGuidString = \"" .. parent.getGUID() .. "\"\n\n" ..
        "function onObjectDestroy(object)\n" ..
        "    if self != nil and object != nil and object.getGUID() != nil and (\"\" .. object.getGUID()) == parentGuidString then self.destruct() end\n" ..
        "end\n\n"

    child.setLuaScript(childScript)

end


function InitializeModule()

    local selfGuid = self.getGUID()
    Global.setVar("_TTT_" .. moduleName, selfGuid)

    local modulesTable = Global.getTable("_TTT_modules")
    if modulesTable == nil then
        modulesTable = {}
    end

    if modulesTable[moduleName] == nil then
        modulesTable[moduleName] = {}
    end

    table.insert(modulesTable[moduleName], 1, selfGuid)
    Global.setTable("_TTT_modules", modulesTable)

end


function IsCloseEnough(vectorA, vectorB, epsilon)

    return
        math.abs(vectorA.x - vectorB.x) < epsilon.x and
        math.abs(vectorA.y - vectorB.y) < epsilon.y and
        math.abs(vectorA.z - vectorB.z) < epsilon.z

end


function IsTableEmpty(tableToCheck)

    if tableToCheck == nil then
        return true
    end

    for key in pairs(tableToCheck) do
        return false
    end

    return true

end


function ObjectIsFromTTT(object)

    if object == nil then return false end
    return object != nil and object.getVar("isFromTTT") == true

end


function PrintHelp(playerColor, name, messageTable)

    printToColor("\n******** " .. name .. " ********\n", playerColor)
    for index, currentLine in ipairs(messageTable) do
        printToColor(currentLine .. "\n", playerColor)
    end
    printToColor("****************\n", playerColor)

end


function PrintError(label, message, playerColor)

    printToColor("[ff0000]" .. label .. "[-]: " .. message .. "\n", playerColor)

end


function PrintTable(tableToPrint, buffer)

    if buffer == nil then buffer = "" end

    if tableToPrint == nil then
        print(buffer .. "Table is nil")
        do return end
    end

    local key = nil
    local value = nil

    for key, value in pairs(tableToPrint) do
        local message = buffer .. key .. " (" .. type(key) .. "): "

        if value == nil then
            print(message .. "nil")
        elseif type(value) == "table" then
            print(message .. "table")
            PrintTable(value, buffer .. "    ")
        elseif type(value) == "userdata" then
            print(message .. "userdata" .. (value.getGUID == nil and "" or " (" .. value.getGUID() .. ")"))
        else
            print(message .. value)
        end
    end

end


function ReParentChildObject(child, parent)

    if child == nil or parent == nil then do return end end

    local childScript = child.getLuaScript()

    local prefix = "parentGuidString = \""
    local suffix = "\""

    local stringStart = string.find(childScript, prefix)
    if stringStart == nil then
        InitializeChildObject(child, parent)
        do return end
    end
    local stringEnd = string.find(childScript, suffix, stringStart + string.len(prefix) + 1)

    childScript = string.sub(childScript, 1, stringStart + string.len(prefix) - 1) .. parent.getGUID() .. string.sub(childScript, stringEnd, -1)
    child.setLuaScript(childScript)

end


function Round(number)

    if number == nil or tonumber(number) == nil then return nil end
    return number + (2^52 + 2^51) - (2^52 + 2^51)

end


function Split(splitString, separator)

   if separator == nil then
      separator = "%s"
   end

   local result = {}
   for token in string.gmatch(splitString, "([^" .. separator .. "]+)") do
      table.insert(result, token)
   end

   return result

end


function ToHex(color)

    local alpha = 1
    if color.a != nil then alpha = color.a end
    return "#" .. string.format("%02x%02x%02x%02x", Round(color.r * 255), Round(color.g * 255), Round(color.b * 255), Round(alpha * 255))

end


function ToNumber(numberString)

    if numberString == nil then return 0 end
    if type(numberString) == "number" then return numberString end

    numberString = Trim(numberString):gsub("%+", "")
    return tonumber(numberString)

end


function Trim(trimString)

    if trimString == nil then return nil end
    return trimString:match'^()%s*$' and '' or trimString:match'^%s*(.*%S)'

end


function TrimEnds(trimString)

    if trimString == nil then return nil end

    local foundEnd = false

    local frontIndex = 1
    local length = string.len(trimString)
    foundEnd = false
    while not foundEnd and frontIndex <= length do
        if string.sub(trimString, frontIndex, frontIndex) != " " then foundEnd = true
        else frontIndex = frontIndex + 1
        end
    end

    if frontIndex > length then return "" end

    local backIndex = length
    foundEnd = false
    while not foundEnd and backIndex > frontIndex do
        if string.sub(trimString, backIndex, backIndex) != " " then foundEnd = true
        else backIndex = backIndex - 1
        end
    end

    if backIndex < frontIndex then return "" end

    return string.sub(trimString, frontIndex, backIndex)

end