--How long it takes to transition from 1 light effect to the next
time_transLength = 2
--How long you have to make a second click when deleting
doubleClickDelay = 0.5

--End of variables to edit, lua knowledge required beyond this point

function onSave()
    saved_data = JSON.encode({sll=savedLightList})
    return saved_data
end

function onload(saved_data)
    --Loads the tracking for if the game has started yet
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        savedLightList = loaded_data.sll
    else
        savedLightList = {}
    end

    doubleClick = {}

    createLoadButtons()
    createSaveButton()
end

--When you click a light name button
function click_load(tableIndex)
    setLightingTable(tableIndex)
    broadcastToAll(savedLightList[tableIndex].name, {1,1,1})
    refreshButtons()
end

--Clicking (and double clicking) then X to delete
function click_delete(tableIndex)
    if doubleClick[tostring(tableIndex)] ~= nil then
        table.remove(savedLightList, tableIndex)
        broadcastToAll("Lighting Preset Deleted", {0.25, 0.25, 0.25})
        refreshButtons()
    else
        doubleClick[tostring(tableIndex)] = true
        Timer.create({
            identifier=self.getGUID().."_for_"..tableIndex,
            function_name = "timer_doubleClick", delay=doubleClickDelay,
            function_owner=self, parameters={tostring(tableIndex)}
        })
    end
end

function timer_doubleClick(p)
    doubleClick[p[1]] = nil
end

--Clicking the save button
function click_save()
    local name = self.getName()
    if name ~= "" then
        --Add to savedLightList
        local saveName = string.sub(self.getName(), 1, 26)
        if savedLightList[saveName] == nil then
            --Records lighting settings
            for key, value in pairs(getTableLighting(saveName)) do
                print(key, "  ", value)
            end
            table.insert(savedLightList, getTableLighting(saveName))
            refreshButtons()
            broadcastToAll("Lighting Preset Saved", {0.25, 0.75, 0.25})
        else
            --Error if a save with this name is already there
            broadcastToAll("A save with this [ffffff]Name[-] already exists.", {0.75, 0.25, 0.25})
        end
        self.setName("")
    else
        broadcastToAll("Add a [ffffff]Name[-] for this save to the tool's [ffffff]Context Menu[-].", {0.75, 0.25, 0.25})
    end
end

--Assembles a table of light info
function getTableLighting(name)
    --Removes mixed key types from these entries (issue with onSave)
    local l1 = Lighting.getAmbientEquatorColor()
    l1 = {r=l1.r, g=l1.g, b=l1.b}
    local l2 = Lighting.getAmbientGroundColor()
    l2 = {r=l2.r, g=l2.g, b=l2.b}
    local l3 = Lighting.getAmbientSkyColor()
    l3 = {r=l3.r, g=l3.g, b=l3.b}
    local l4 = Lighting.getLightColor()
    l4 = {r=l4.r, g=l4.g, b=l4.b}
    --Writes light info to a table
    local lightTable = {
        name = name,
        l1 = l1,
        l2 = l2,
        l3 = l3,
        l4 = l4,
        l5 = Lighting.ambient_type,
        l6 = Lighting.ambient_intensity,
        l7 = Lighting.light_intensity,
        l8 = Lighting.reflection_intensity,
    }
    return lightTable
end

--Applies saved light table
function setLightingTable(i)
    local savedLight = savedLightList[i]
    local currentLight = getTableLighting("na")
    function coroutine_setLightingTable()
        --Application of transitional values (fading effect)
        local time_start = os.time()
        while os.time() <= time_start + time_transLength do
            if time_transLength > 0 then
                local time_percent = (os.time()-time_start) / time_transLength

                local steppedLight = getStepedLighting(currentLight, savedLight, time_percent)

                Lighting.setAmbientEquatorColor(steppedLight.l1)
                Lighting.setAmbientGroundColor(steppedLight.l2)
                Lighting.setAmbientSkyColor(steppedLight.l3)
                Lighting.setLightColor(steppedLight.l4)
                Lighting.ambient_type = steppedLight.l5
                Lighting.ambient_intensity = steppedLight.l6
                Lighting.light_intensity = steppedLight.l7
                Lighting.reflection_intensity = steppedLight.l8
                Lighting.apply()
                coroutine.yield(0)
            end
        end

        --Application of final values
        local time_percent = (os.time()-time_start) / time_transLength
        Lighting.setAmbientEquatorColor(savedLight.l1)
        Lighting.setAmbientGroundColor(savedLight.l2)
        Lighting.setAmbientSkyColor(savedLight.l3)
        Lighting.setLightColor(savedLight.l4)
        Lighting.ambient_type = savedLight.l5
        Lighting.ambient_intensity = savedLight.l6
        Lighting.light_intensity = savedLight.l7
        Lighting.reflection_intensity = savedLight.l8
        Lighting.apply()
        coroutine.yield(0)

        return 1
    end
    startLuaCoroutine(self, "coroutine_setLightingTable")
end

function getStepedLighting(lightA, lightB, time_percent)
    local lightTable = {
        l1 = {
            r=lightA.l1.r - ((lightA.l1.r-lightB.l1.r) * time_percent),
            g=lightA.l1.g - ((lightA.l1.g-lightB.l1.g) * time_percent),
            b=lightA.l1.b - ((lightA.l1.b-lightB.l1.b) * time_percent),
        },
        l2 = {
            r=lightA.l2.r - ((lightA.l2.r-lightB.l2.r) * time_percent),
            g=lightA.l2.g - ((lightA.l2.g-lightB.l2.g) * time_percent),
            b=lightA.l2.b - ((lightA.l2.b-lightB.l2.b) * time_percent),
        },
        l3 = {
            r=lightA.l3.r - ((lightA.l3.r-lightB.l3.r) * time_percent),
            g=lightA.l3.g - ((lightA.l3.g-lightB.l3.g) * time_percent),
            b=lightA.l3.b - ((lightA.l3.b-lightB.l3.b) * time_percent),
        },
        l4 = {
            r=lightA.l4.r - ((lightA.l4.r-lightB.l4.r) * time_percent),
            g=lightA.l4.g - ((lightA.l4.g-lightB.l4.g) * time_percent),
            b=lightA.l4.b - ((lightA.l4.b-lightB.l4.b) * time_percent),
        },
        l5 = lightA.l5 - ((lightA.l5-lightB.l5) * time_percent),
        l6 = lightA.l6 - ((lightA.l6-lightB.l6) * time_percent),
        l7 = lightA.l7 - ((lightA.l7-lightB.l7) * time_percent),
        l8 = lightA.l8 - ((lightA.l8-lightB.l8) * time_percent)
    }
    return lightTable
end

--Button handling

function createLoadButtons()
    for i, entry in ipairs(savedLightList) do
        local funcName = "saveFile"..i
        local func = function() click_load(i) end
        self.setVar(funcName, func)
        self.createButton({
            label = entry.name, click_function=funcName, function_owner=self,
            position={-0.2,0,0.6+i*0.35}, height=180, width=1600, font_size=120, color={0,0,0}, font_color={1,1,1}
        })

        funcName = "deleteFile"..i
        local func = function() click_delete(i) end
        self.setVar(funcName, func)
        self.createButton({
            label = "X", click_function=funcName, function_owner=self,
            position={1.7,0,0.6+i*0.35}, height=180, width=180, font_size=120, color={0,0,0}, font_color={1,1,1}
        })
    end
end

function createSaveButton()
    self.createButton({
        click_function="click_save", function_owner=self,
        position={0,0.1,0.14}, height=340, width=1600, color={0,0,0,0}
    })
end

function refreshButtons()
    self.clearButtons()
    createLoadButtons()
    createSaveButton()
end