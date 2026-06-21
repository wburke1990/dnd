self.setName("DM_Screen")


backgroundURL_0 = ''
dm_Screen = getObjectFromGUID("0adb08")
buttonScale = {0.045,1,0.185}

entries = {
    {textPos = {-0.325,-0.12,0.75}, buttonPos = {-0.55,-0.12,0.75}},
}

-- Startup procedure
function onload(saved_data)
    spawnedInputCount = 0
    spawnedButtonCount = 0

    createTextboxes()
    self.interactable = false
end

function createTextboxes()
    fontSize = 200
    rows = 1

    for index, data in ipairs(entries) do

        -- Sets up input reference function
        local inputNumber = spawnedInputCount
        local inputFuncName = "input" .. index
        local inputFunc = function(obj, player_clicker_color, input_value, selected)
            input_function(obj, player_clicker_color, input_value, selected, inputNumber)
        end
        self.setVar(inputFuncName, inputFunc)

        self.createInput({
            input_function = inputFuncName,
            function_owner = self,
            label = "Enter/Paste URL (DM Screen)",
            value = "",
            position = entries[index].textPos,
            rotation = {0,0,180},
            width = fontSize*20,
            height = (fontSize*rows)+24,
            font_size = fontSize,
            scale=buttonScale,
            tab = 2
        })

        spawnedInputCount = spawnedInputCount + 1

        -- Sets up input reference function
        local buttonNumber = spawnedButtonCount
        local buttonFuncName = "button" .. index
        local buttonFunc = function(obj, player_clicker_color, alt_click)
            button_function(obj, player_clicker_color, alt_click, buttonNumber)
        end
        self.setVar(buttonFuncName, buttonFunc)

        self.createButton({
            label = "Update",
            click_function = buttonFuncName,
            function_owner = self,
            position = entries[index].buttonPos,
            rotation = {0,0,180},
            width = fontSize*3,
            height = fontSize*1.5,
            font_size = fontSize*0.75,
            scale=buttonScale,
            color = {0, 1, 0},
            font_color = {1, 1, 1}
        })

        spawnedButtonCount = spawnedButtonCount + 1
    end
end

function button_function(obj, player_clicker_color, alt_click, buttonNumber)
    if (player_clicker_color == 'Black') then
        -- Do nothing with empty fields
        if (backgroundURL_0 == '') then return end

        if (buttonNumber == 0) then
            self.setCustomObject({image = backgroundURL_0})
        end
        self.reload()
    else
        broadcastToAll("Only the DM (Black) can update the DM screen")
    end
end

function input_function(obj, player_clicker_color, input_value, selected, inputNumber)
    if not selected then
        if (inputNumber == 0) then backgroundURL_0 = input_value end
    end
end

