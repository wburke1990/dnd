--Dice Clicker Strip by MrStump
--You may edit the below variables to change some of the tool's functionality
 
--By default, this tool can roll 6 different dice types (d4-d20)
--If you put a url into the quotes, you can replace a die with a custom_dice
--If you put a name into the quotes, you can replace the default naming
--Changing the number of sides will make the tool's images not match (obviously)
--Only supports custom_dice, not custom models or asset bundles
ref_diceCustom = {
    {url="", name="", sides=4},  --Default: d4
    {url="", name="", sides=6},  --Default: d6
    {url="", name="", sides=8},  --Default: d8
    {url="", name="", sides=10}, --Default: d10
    {url="", name="", sides=12}, --Default: d12
    {url="", name="", sides=20}, --Default: d20
}
--Note: Names on dice will overrite default die naming "d4, d6, d8, etc"
 
--Chooses what color dice that are rolled are. Options:
    --"default" = dice are default tint (recommended)
    --"player" = dice are tinted to match the color of player who clicked
    --"tool" = dice are tinted to match the color of this tool
dieColor = "default"
 
--Time before dice disappear. -1 means they do not (until next roll)
removalDelay = 4
 
--If results print on 1 line or multiple lines (true or false)
announce_singleLine = true
--If last player to click button before roll happens gets their name announced
announce_playerName = true
--If last player to click button before roll is used to color name/total/commas
announce_playerColor = false
--If individual results are displayed (true or false)
announce_each = true
--If dice are added together for announcement (true or false)
announce_total = true
--Choose what color the print results are Options:
    --"default" = All text is white
    --"player" = All text is color-coded to player that clicked roll last
    --"die" = Results are colored to match the die color
announce_color = "die"
 
--Distance dice are placed from the tool's center
distanceOffset = 4
--Length of line dice will be spawned in
widthMaximum = 8
--Distance die gets moved up off the table when spawned
heightOffset = 2.5
--Die scale, default of 1 (2 is twice the size, 0.5 is half the size)
diceScale = {
    1, --d4
    1, --d6
    1, --d8
    1, --d10
    1, --d12
    1, --d20
}
 
--How long to wait before rolling the spawned dice after a click
waitBeforeRoll = 1.5
 
--How many dice can be spawned. 0 is infinite
dieLimit = 4
 
--END OF VARIABLES TO EDIT WITHOUT SCRIPTING KNOWLEDGE
 
 
 
--Startup
 
 
 
--Save to track currently active dice for disposal on load
function onSave()
    if #currentDice > 0 then
        local currentDiceGUIDs = {}
        for _, obj in ipairs(currentDice) do
            if obj ~= nil then
                table.insert(currentDiceGUIDs, obj.getGUID())
            end
        end
        saved_data = JSON.encode(currentDiceGUIDs)
    else
        saved_data = ""
    end
    saved_data = ""
    return saved_data
end
 
function onload(saved_data)
    --Loads the save of any active dice and deletes them
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        for _, guid in ipairs(loaded_data) do
            local obj = getObjectFromGUID(guid)
            if obj ~= nil then
                destroyObject(obj)
            end
        end
        currentDice = {}
    else
        currentDice = {}
    end
 
    cleanupDice()
    spawnRollButtons()
    currentDice = {}
 
    --The roll button
    self.createButton({
        label="Roll", click_function="rollDice", function_owner=self,
        position={0,0,1}, height=200, width=1000, font_size=200,
        color={0,0,0}, font_color={1,1,1}
    })
end
 
 
 
--Button clicked to start rolling process (or add to it)
 
 
 
--Activated by click
function click_roll(color, dieIndex)
    --Dice spam protection, can be disabled up at top of script
    local diceCount = 0
    for _ in pairs(currentDice) do
        diceCount = diceCount + 1
    end
    local denyRoll = false
    if dieLimit > 0 and diceCount >= dieLimit then
        denyRoll = true
    end
    --Check for if click is allowed
    if rollInProgress == nil and denyRoll == false then
        --Find dice positions, moving previously spawned dice if needed
        local angleStep = 360 / (#currentDice+1)
        for i, die in ipairs(currentDice) do
            die.setPositionSmooth(getPositionInLine(i), false, true)
        end
 
        --Determines type of die to spawn (custom or not, number of sides)
        local spawn_type = "Custom_Dice"
        local spawn_sides = ref_diceCustom[dieIndex].sides
        local spawn_scale = diceScale[dieIndex]
        if ref_diceCustom[dieIndex].url == "" then
            spawn_type = ref_defaultDieSides[dieIndex]
        end
 
        --Spawns that die
        local spawn_pos = getPositionInLine(#currentDice+1)
        local spawnedDie = spawnObject({
            type=spawn_type,
            position = spawn_pos,
            rotation = randomRotation(),
            scale={spawn_scale,spawn_scale,spawn_scale}
        })
        if spawn_type == "Custom_Dice" then
            spawnedDie.setCustomObject({
                image = ref_diceCustom[dieIndex].url,
                type = ref_customDieSides[tostring(spawn_sides)]
            })
        end
 
        --After die is spawned, actions to take on it
        table.insert(currentDice, spawnedDie)
        spawnedDie.setLock(true)
        if ref_diceCustom[dieIndex].name ~= "" then
            spawnedDie.setName(ref_diceCustom[dieIndex].name)
        end
 
        --[[Timer starting
        Timer.destroy("clickRoller_"..self.getGUID())
        Timer.create({
            identifier="clickRoller_"..self.getGUID(), delay=waitBeforeRoll,
            function_name="rollDice", function_owner=self,
            parameters = {color = color}
        })
        ]]
        lastClickColor = color
    elseif rollInProgress == false then
        cleanupDice()
        click_roll(color, dieIndex)
    else
        Player[color].broadcast("Roll in progress.", {0.8, 0.2, 0.2})
    end
end
 
 
 
--Die rolling
 
 
 
--Rolls all the dice and then launches monitoring
function rollDice()
    rollInProgress = true
    function coroutine_rollDice()
        for _, die in ipairs(currentDice) do
            die.setLock(false)
            die.randomize()
            wait(0.1)
        end
 
        monitorDice(lastClickColor)
 
        return 1
    end
    startLuaCoroutine(self, "coroutine_rollDice")
end
 
--Monitors dice to come to rest
function monitorDice(color)
    function coroutine_monitorDice()
        repeat
            local allRest = true
            for _, die in ipairs(currentDice) do
                if die ~= nil and die.resting == false then
                    allRest = false
                end
            end
            coroutine.yield(0)
        until allRest == true
 
        --Announcement
        if announce_total==true or announce_each==true then
            displayResults(color)
        end
 
        wait(0.1)
        rollInProgress = false
 
        --Auto die removal
        if removalDelay ~= -1 then
            --Timer starting
            Timer.destroy("clickRoller_cleanup_"..self.getGUID())
            Timer.create({
                identifier="clickRoller_cleanup_"..self.getGUID(),
                function_name="cleanupDice", function_owner=self,
                delay=removalDelay,
            })
        end
 
        return 1
    end
    startLuaCoroutine(self, "coroutine_monitorDice")
end
 
 
 
--After roll broadcasting
 
 
 
function displayResults(color)
    local total = 0
    local resultTable = {}
 
    --Tally result info
    for _, die in ipairs(currentDice) do
        if die ~= nil then
            --Tally value info
            local value = die.getValue()
            total = total + value
            --Tally color info
            local textColor = {1,1,1}
            if announce_color == "player" then
                textColor = stringColorToRGB(color)
            elseif announce_color == "die" then
                textColor = die.getColorTint()
            end
            --Get die type
            local dSides = ""
            local dieCustomInfo = die.getCustomObject()
            if next(dieCustomInfo) then
                dSides = ref_customDieSides_rev[dieCustomInfo.type+1]
            else
                dSides = tonumber(string.match(tostring(die),"%d+"))
            end
            --Add to table
            table.insert(resultTable, {value=value, color=textColor, sides=dSides})
        end
    end
 
    --Sort result table into order
    local sort_func = function(a,b) return a.value < b.value end
    table.sort(resultTable, sort_func)
 
    --String assembly
 
    if announce_singleLine == true then
        --THIS IF STATEMENT IS FOR SINGLE LINE
        local s = ""
        local s_color = {1,1,1}
        if announce_playerColor == true then
            s_color = stringColorToRGB(color)
        end
 
        if announce_each == true then
            for i, v in ipairs(resultTable) do
                local hex = RGBToHex(v.color)
                s = s .. hex .. v.value .. "[-]"
                if i ~= #resultTable then
                    s = s .. ", "
                end
            end
        end
        if announce_total == true then
            if s ~= "" then
                s = s .. "     |     "
            end
            s = s .. "[b]" ..  total .. "[/b]"
        end
        if announce_playerName == true then
            s = Player[color].steam_name .. "     |     " .. s
        end
 
        broadcastToColor(s, "Black", s_color)
    else
        --THIS IF STATEMENT IS FOR MULTI LINE
        local s_color = {1,1,1}
        if announce_playerColor == true then
            s_color = stringColorToRGB(color)
        end
 
        if announce_playerName == true then
            broadcastToColor(Player[color].steam_name .. " has rolled:", "Black", s_color)
        end
 
        local s = ""
        local dSides = 0
        if announce_each == true then
            for _, refSides in ipairs(ref_customDieSides_rev) do
                for i, v in ipairs(resultTable) do
                    if v.sides == refSides then
                        local hex = RGBToHex(v.color)
                        if dSides ~= 0 then
                            s = s .. ", "
                        end
                        s = s .. hex .. v.value .. "[-]"
                        dSides = v.sides
                    end
                end
                if s ~= "" then
                    s = "d".. dSides .. ")  " .. s
                    broadcastToColor(s, "Black", s_color)
                    s = ""
                    dSides = 0
                end
            end
        end
 
        if announce_total == true then
            broadcastToColor("[b]Total )  [/b]"..total, "Black", s_color)
        end
    end
end
 
 
 
--Die cleanup
 
 
 
function cleanupDice()
    for _, die in ipairs(currentDice) do
        if die ~= nil then
            destroyObject(die)
        end
    end
 
    Timer.destroy("clickRoller_cleanup_"..self.getGUID())
    rollInProgress = nil
    currentDice = {}
end
 
 
 
--Utility functions
 
 
 
--Return a position based on relative position on a line
function getPositionInLine(i)
    local totalDice = #currentDice + 3
    local totalWidth = widthMaximum
    --Change total width here maybe
    local widthStep = widthMaximum / (totalDice-1)
    local x = -widthStep * i + (widthMaximum/2)
    local y = heightOffset
    local z = -distanceOffset
    return self.positionToWorld({x,y,z})
end
 
--Gets a random rotation vector
function randomRotation()
    --Credit for this function goes to Revinor (forums)
    --Get 3 random numbers
    local u1 = math.random();
    local u2 = math.random();
    local u3 = math.random();
    --Convert them into quats to avoid gimbal lock
    local u1sqrt = math.sqrt(u1);
    local u1m1sqrt = math.sqrt(1-u1);
    local qx = u1m1sqrt *math.sin(2*math.pi*u2);
    local qy = u1m1sqrt *math.cos(2*math.pi*u2);
    local qz = u1sqrt *math.sin(2*math.pi*u3);
    local qw = u1sqrt *math.cos(2*math.pi*u3);
    --Apply rotation
    local ysqr = qy * qy;
    local t0 = -2.0 * (ysqr + qz * qz) + 1.0;
    local t1 = 2.0 * (qx * qy - qw * qz);
    local t2 = -2.0 * (qx * qz + qw * qy);
    local t3 = 2.0 * (qy * qz - qw * qx);
    local t4 = -2.0 * (qx * qx + ysqr) + 1.0;
    --Correct
    if t2 > 1.0 then t2 = 1.0 end
    if t2 < -1.0 then ts = -1.0 end
    --Convert back to X/Y/Z
    local xr = math.asin(t2);
    local yr = math.atan2(t3, t4);
    local zr = math.atan2(t1, t0);
    --Return result
    return {math.deg(xr),math.deg(yr),math.deg(zr)}
end
 
--Coroutine delay, in seconds
function wait(time)
    local start = os.time()
    repeat coroutine.yield(0) until os.time() > start + time
end
 
--Turns an RGB table into hex
function RGBToHex(rgb)
    if rgb ~= nil then
        return "[" .. string.format("%02x%02x%02x", rgb[1]*255,rgb[2]*255,rgb[3]*255) .. "]"
    else
        return ""
    end
end
 
 
 
--Button creation
 
 
 
function spawnRollButtons()
    for i, entry in ipairs(ref_diceCustom) do
        local funcName = "button_"..i
        local func = function(_, c) click_roll(c, i) end
        self.setVar(funcName, func)
        self.createButton({
            click_function=funcName, function_owner=self, color={1,1,1,0},
            position={-2.5+(i-1)*1,0.05,0}, height=330, width=330
        })
    end
end
 
 
 
--Data tables
 
 
 
ref_customDieSides = {["4"]=0, ["6"]=1, ["8"]=2, ["10"]=3, ["12"]=4, ["20"]=5}
 
ref_customDieSides_rev = {4,6,8,10,12,20}
 
ref_defaultDieSides = {"Die_4", "Die_6", "Die_8", "Die_10", "Die_12", "Die_20"}