--[[    Character Sheet Template    by: MrStump ]]
--[[    Written Code                by: NightStorm ]]

--Set this to true while editing and false when you have finished
disableSave = false

    --buttonFontColorLight = {0,0,0, 100}
    buttonFontColor = {1,1,1, 100}
    buttonColorWhite = {1,1,1,100}
    buttonColorRed = {0.94,0.1125,0.1121, 100}
    buttonColorGreen = {0,0.75,0.33, 100}
    buttonColor = {1,1,1, 0.01}

--Change scale of button (Avoid changing if possible)
buttonScale = {0.11,0.11,0.11}

--This is the button placement information
defaultButtonData = {
    --Number only Textboxes
        numbox = {
            --Bastion Level
                {
                    pos       = {0.397,0.11,-0.861},
                    rows      = 1,
                    width     = 350,
                    font_size = 280,
                    label     = "",
                    value     = 0,
                    font_color=buttonFontColor,
                    alignment = 3
                },
            --Total Hirelings
                {
                    pos       = {0.621,0.11,-0.861},
                    rows      = 1,
                    width     = 350,
                    font_size = 280,
                    label     = "",
                    value     = 0,
                    font_color=buttonFontColor,
                    alignment = 3
                },
            --Bastion Defenders
                {
                    pos       = {0.844,0.11,-0.861},
                    rows      = 1,
                    width     = 350,
                    font_size = 280,
                    label     = "",
                    value     = 0,
                    font_color=buttonFontColor,
                    alignment = 3
                },
            },
    --Add checkboxes
        checkboxlock = {
            {
                pos   = {-0.411,0.1,-0.934},
                size  = 200,
                state = true
            },
            --End of checkboxes
        },
    --Add editable text boxes
        textbox = {
            --[[    TEXTBOX INFORMATION
                pos       = the position (pasted from the helper tool)
                rows      = how many lines of text you want for this box
                width     = how wide the text box is
                font_size = size of text. This and "rows" effect overall height
                label     = what is shown when there is no text. "" = nothing
                value     = text entered into box. "" = nothing
                alignment = Number to indicate how you want text aligned
                            (1=Automatic, 2=Left, 3=Center, 4=Right, 5=Justified)   ]]
            --Header Textboxes
                --Bastion Name textbox
                    {   
                        pos       = {-0.64,0.1,-0.806},
                        rows      = 1,
                        width     = 3000,
                        font_size = 220,
                        label     = "Bastion Name",
                        value     = "", 
                        alignment = 3   
                    },
              --Character Name textbox
                    {   
                        pos       = {-0.018,0.1,-0.89},
                        rows      = 1,
                        width     = 2100,
                        font_size = 140,
                        label     = "Character Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Location textbox
                    {   
                        pos       = {-0.018,0.1,-0.8},
                        rows      = 1,
                        width     = 2100,
                        font_size = 140,
                        label     = "Location",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 1 textbox
                    {   
                        pos       = {-0.5,0.1,0.187},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 2 textbox
                    {   
                        pos       = {0.2,0.1,0.187},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 3 textbox
                    {   
                        pos       = {0.9,0.1,0.187},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 4 textbox
                    {   
                        pos       = {-0.5,0.1,0.72},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 5 textbox
                    {   
                        pos       = {0.2,0.1,0.72},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Notes 6 textbox
                    {   
                        pos       = {0.9,0.1,0.72},
                        rows      = 16,
                        width     = 850,
                        font_size = 120,
                        label     = "Notes",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 1 textbox
                    {   
                        pos       = {-0.875,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 1 textbox
                    {   
                        pos       = {-0.875,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 2 textbox
                    {   
                        pos       = {-0.875,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 2 textbox
                    {   
                        pos       = {-0.875,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 3 textbox
                    {   
                        pos       = {-0.524,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 3 textbox
                    {   
                        pos       = {-0.524,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 4 textbox
                    {   
                        pos       = {-0.524,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 4 textbox
                    {   
                        pos       = {-0.524,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 5 textbox
                    {   
                        pos       = {-0.173,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 5 textbox
                    {   
                        pos       = {-0.173,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 6 textbox
                    {   
                        pos       = {-0.173,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 6 textbox
                    {   
                        pos       = {-0.173,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 7 textbox
                    {   
                        pos       = {0.178,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 7 textbox
                    {   
                        pos       = {0.178,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 8 textbox
                    {   
                        pos       = {0.178,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 8 textbox
                    {   
                        pos       = {0.178,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 9 textbox
                    {   
                        pos       = {0.524,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 9 textbox
                    {   
                        pos       = {0.524,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 10 textbox
                    {   
                        pos       = {0.524,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 10 textbox
                    {   
                        pos       = {0.524,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 11 textbox
                    {   
                        pos       = {0.875,0.1,-0.499},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 11 textbox
                    {   
                        pos       = {0.875,0.1,-0.423},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Name 12 textbox
                    {   
                        pos       = {0.875,0.1,-0.297},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Name",
                        value     = "", 
                        alignment = 1   
                    },
              --Basic Space 12 textbox
                    {   
                        pos       = {0.875,0.1,-0.221},
                        rows      = 1,
                        width     = 1200,
                        font_size = 120,
                        label     = "Space",
                        value     = "", 
                        alignment = 1   
                    },
            }
}


--Lua beyond this point, I recommend doing something more fun with your life


--Save function
function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave==true then saved_data="" end
    self.script_state = saved_data
end

--Startup procedure
function onload(saved_data)
    if disableSave==true then saved_data="" end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        ref_buttonData = loaded_data
    else
        ref_buttonData = defaultButtonData
    end

    spawnedButtonCount = 0
    createCheckboxLock()
    createTextbox()
    createNumbox()
    
end


--Click functions for buttons

--Predefined special checkbox (to lock other controls)
    function click_checkboxlock(tableIndex, buttonIndex)
        if ref_buttonData.checkboxlock[tableIndex].state == true then
            ref_buttonData.checkboxlock[tableIndex].state = false
            self.editButton({index=buttonIndex, color=buttonColorRed, font_color=buttonFontColorWhite, label="Locked"})
        else
            ref_buttonData.checkboxlock[tableIndex].state = true
            self.editButton({index=buttonIndex, color=buttonColorGreen, font_color=buttonFontColorWhite, label="Unlocked"})
            for i, text in ipairs(ref_buttonData.textbox) do
                self.editInput({index=i-1, value=ref_buttonData.textbox[i].value})
            end
        end
        updateSave()
    end

--Updates saved value for text box
        function click_textbox(i, color, value, selected)
            if ref_buttonData.checkboxlock[1].state then
                if selected == false then
                    ref_buttonData.textbox[i].value = value
                    updateSave()
                end
            else
                if selected == true then
                    printOut(color)
                    Wait.time(function() self.editInput({index=i-1,value=ref_buttonData.textbox[i].value}) end,0.12)
                end
            end
        end

    --Updates saved value for numbox (numbers only)
        function click_numbox(i, color, value, selected, amount)
            if ref_buttonData.checkboxlock[1].state then
                if amount ~= 0 then
                    if amount == -1 and tonumber(ref_buttonData.numbox[i].value) < 1 then
                        --broadcastToColor("Value can't be negative.", color, "Red")
                        self.editInput({index=i+32,value=ref_buttonData.numbox[i].value})
                    elseif tonumber(ref_buttonData.numbox[i].value) >= 99 then
                        ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) - 1
                        self.editInput({index=i+32,value=ref_buttonData.numbox[i].value})
                    else 
                        ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                        self.editInput({index=i+32,value=ref_buttonData.numbox[i].value})
                    end
                end
                if selected == false then
                    if tonumber(value) ~= nil and (tonumber(value) < 100 and tonumber(value) > -1) then
                        ref_buttonData.numbox[i].value = value
                    else
                        broadcastToColor("Enter a valid number.", color, "Red")
                        Wait.time(function() self.editInput({index=i+32,value=ref_buttonData.numbox[i].value}) end,0.12)
                    end
                end
                updateSave()
            else
                if selected == true then
                    printOut(color)
                    Wait.time(function() self.editInput({index=i-1,value=ref_buttonData.textbox[i].value}) end,0.12)
                end
            end
        end

--Dud function for if you have a background on a counter
function click_none() end

function printOut(col)    
    broadcastToColor("Unable to edit, Card is Locked", col, "Red")
end



--Button creation

function createCheckboxLock()
    for i, data in ipairs(ref_buttonData.checkboxlock) do
        --Sets up reference function
        local buttonNumber = spawnedButtonCount
        local funcName = "checkboxlock"..i
        local func
        if i == 1 then
            func = function() click_checkboxlock(i, buttonNumber) end
        else
            func = function() click_checkbox(i, buttonNumber) end
        end
        self.setVar(funcName, func)
        --Sets up label
        if data.state==false then label="Locked" color=buttonColorRed end
        if data.state==true then label="Unlocked" color=buttonColorGreen end
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=data.pos, height=data.size*1.5, width=data.size*4.5,
            font_size=data.size, scale=buttonScale,
            color=color, font_color=buttonColorWhite
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

        function createTextbox()
            for i, data in ipairs(ref_buttonData.textbox) do
                --Sets up reference function
                local funcName = "textbox"..i
                local func = function(_,col,val,sel) click_textbox(i,col,val,sel) end
                self.setVar(funcName, func)

                self.createInput({
                    input_function = funcName,
                    function_owner = self,
                    label          = data.label,
                    alignment      = data.alignment,
                    position       = data.pos,
                    scale          = buttonScale,
                    width          = data.width,
                    height         = (data.font_size*data.rows)+24,
                    font_size      = data.font_size,
                    color          = {0,0,0,0},
                    font_color     = buttonFontColor,
                    value          = data.value,
                })
            end
        end

function createNumbox()
    for i, data in ipairs(ref_buttonData.numbox) do
        --Sets up display
        local btn = spawnedButtonCount
        --Sets up reference function
        local funcName = "numbox"..i
        local func = function(_,col,val,sel,amt) click_numbox(i,col,val,sel,0) end
        self.setVar(funcName, func)

        local widthSize = (data.font_size*1.7)
        self.createInput({
            input_function = funcName,
            function_owner = self,
            label          = data.label,
            alignment      = data.alignment,
            position       = data.pos,
            scale          = {0.115,0.115,0.115},
            width          = data.width,
            height         = data.font_size*1.2,
            font_size      = data.font_size,
            color          = buttonColor,
            font_color     = data.font_color,
            value          = data.value,
        })

        --Sets up add 1
        local funcName = "numboxAdd"..i
        local func = function() click_numbox(i,col,val,sel,1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Sets up position
        local pos = {data.pos[1] + 0.07, data.pos[2], data.pos[3]}
        --Sets up size
        local size = (data.font_size / 1.3)
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.font_size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up subtract 1
        local funcName = "numboxSub"..i
        local func = function() click_numbox(i,col,val,sel,-1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "-"
        --Set up position
        local pos = {data.pos[1] - 0.07, data.pos[2], data.pos[3]}
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.font_size, scale=buttonScale,
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end