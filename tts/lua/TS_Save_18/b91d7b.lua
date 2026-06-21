--[[    Character Sheet Template    by: MrStump ]]

--Set to true when editing
disableSave = false

--Color information for button text (r,g,b, values of 0-1)
    buttonFontColor = {0,0,0, 100}
    buttonFontColorWhite = {1,1,1, 0.01}
    buttonFontColorRed = {0.94,0.125,0.121, 100}
    buttonFontColorGreen = {0,0.75,0.33, 100}
    buttonFontColorYellow = {1,0.65,0, 100}
    buttonFontColorOrange = {0.97,0.54,0.13, 100}
    buttonFontColorPink = {0.91,0.23,0.63, 100}
    buttonFontColorBlue = {0,0.58,0.9, 100}
    
--Color information for button background
    buttonColor = {1,1,1, 0.01}
    buttonColorBlack = {0,0,0, 0.01}

--Change scale of button (Avoid changing if possible)
buttonScale = {0.6,0.6,0.6}

--This is the button placement information
defaultButtonData = {

    --Speed Counter
        counterspeed = {
            --Base
                {
                    pos    = {-2.988,0.1,0.425},
                    size   = 300,
                    value  = 30,
                    hideBG = true,
                    color = buttonFontColor
                },
            --Expendable
                {
                    pos    = {-1.962,0.1,0.435},
                    size   = 300,
                    value  = 30,
                    hideBG = false,
                    color = buttonFontColor
                },
            },

    --Add checkboxes
        checkboxdash = {
            --Dash
                {
                    pos   = {-3.332,0.1,-0.207},
                    size  = 300,
                    state = false
                },
            },

        checkboxprone = {
                --Prone
                {
                    pos   = {-2.295,0.1,-0.209},
                    size  = 300,
                    state = false
                },
            },

    --Actions Checkbox
        --Action
            checkbox1 = {
                {
                    pos    = {-5.653,0.1,-0.663},
                    size   = 375,
                    value  = 10,
                    state = true },   },
        --Movement
            checkbox2 = {
                {
                    pos    = {-3.224,0.1,-0.683},
                    size   = 325,
                    value  = 10,
                    state = true },   },
        --BonusAction
            checkbox3 = {
                {
                    pos    = {-1.107,0.1,-0.663},
                    size   = 225,
                    value  = 10,
                    state = true },   },
        --Reaction
            checkbox4 = {  
                {
                    pos    = {1.325,0.1,-0.626},
                    size   = 300,
                    value  = 10,
                    state = true },   },
        --Interaction
            checkbox5 = {
                {
                    pos    = {3.814,0.1,-0.616},
                    size   = 400,
                    value  = 10,
                    state = true },   },

    --Add Lockable Button
        checkboxlock = {
            {   pos   = {4.09,0.1,0.769},
                size  = 150,
                state = true    },  },

    --Add Reset Button
        checkboxreset = {
            {   pos   = {5.4,0.1,0.769},
                size  = 150,
                state = true    },  },

    --Add editable text boxes
        textbox = {
            --[[
                        pos       = the position (pasted from the helper tool)
                        rows      = how many lines of text you want for this box
                        width     = how wide the text box is
                        font_size = size of text. This and "rows" effect overall height
                        label     = what is shown when there is no text. "" = nothing
                        value     = text entered into box. "" = nothing
                        alignment = Number to indicate how you want text aligned
                                    (1=Automatic, 2=Left, 3=Center, 4=Right, 5=Justified)
                        ]]
            --Action textbox
                {
                    pos       = {-4.73,0.1,0.286},
                    rows      = 7,
                    width     = 1580,
                    font_size = 130,
                    label     = "Notes",
                    value     = "",
                    alignment = 2
                },
            --Bonus Action textbox
                {
                    pos       = {-0.177,0.1,0.286},
                    rows      = 7,
                    width     = 1580,
                    font_size = 130,
                    label     = "Notes",
                    value     = "",
                    alignment = 2
                },
            --Reaction textbox
                {
                    pos       = {2.254,0.1,0.286},
                    rows      = 7,
                    width     = 1580,
                    font_size = 130,
                    label     = "Notes",
                    value     = "",
                    alignment = 2
                },
            --Interaction textbox
                {
                    pos       = {4.743,0.1,0.123},
                    rows      = 5,
                    width     = 1580,
                    font_size = 130,
                    label     = "Notes",
                    value     = "",
                    alignment = 2
                }
            }
    }

--Lua beyond this point

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

    --Call Functions
        spawnedButtonCount = 0
        createCounterSpeed()
        createCheckboxDash()
        createCheckboxProne()
        createActionCheckbox()
        createMovementCheckbox()
        createBonusActionCheckbox()
        createReactionCheckbox()
        createInteractionCheckbox()
        
        createCheckboxLock()
        createCheckboxReset()
   
        createTextbox()
    end

--Click functions for buttons

    --Checks or unchecks the dash box
        function click_checkboxdash(tableIndex, buttonIndex)
            --Expendable Speed Value (Index 2)
            local base = ref_buttonData.counterspeed[2].value
            if ref_buttonData.checkboxprone[tableIndex].state == true then
                base = (math.floor((ref_buttonData.counterspeed[2].value / 5) /2) * 5)
            end

            --Dash Speed Value (Index 1 (Base) + Index 2 (Expendable))
            local dash = ref_buttonData.counterspeed[2].value + ref_buttonData.counterspeed[1].value
            if ref_buttonData.checkboxprone[tableIndex].state == true then
                dash = ((math.floor((ref_buttonData.counterspeed[2].value / 5) /2) * 5) + ref_buttonData.counterspeed[1].value)
            end
                if ref_buttonData.checkboxdash[tableIndex].state == true then
                    
                    --When Unchecked set expendable value to base
                    ref_buttonData.checkboxdash[tableIndex].state = false

                    self.editButton({index=buttonIndex, label=""})                    
                    self.editButton({index=3, label=base})
                else
                    --When Checked add dash value to expendable
                    ref_buttonData.checkboxdash[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(9679)})
                    self.editButton({index=3, label=dash})
                end
            updateSave()
        end

    --Checks or unchecks the prone box
        function click_checkboxprone(tableIndex, buttonIndex)
            --Expendable Speed Value (Index 2)
            local base = ref_buttonData.counterspeed[2].value
            if ref_buttonData.checkboxdash[tableIndex].state == true then
                base = ref_buttonData.counterspeed[2].value + ref_buttonData.counterspeed[1].value
            end
            
            --Formula for rounding down when prone
            local prone = (math.floor((ref_buttonData.counterspeed[2].value / 5) /2) * 5)

            if ref_buttonData.checkboxdash[tableIndex].state == true then
                prone = prone + ref_buttonData.counterspeed[1].value
            end

                if ref_buttonData.checkboxprone[tableIndex].state == true then
                    ref_buttonData.checkboxprone[tableIndex].state = false
                    self.editButton({index=buttonIndex, label=""})
                    self.editButton({index=3, label=base})
                else
                    ref_buttonData.checkboxprone[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(9679)})
                    self.editButton({index=3, label=prone})
                end
            updateSave()
        end

    --Checks or unchecks the Action box
        function click_checkbox1(tableIndex, buttonIndex)
            if ref_buttonData.checkbox1[tableIndex].state == true then
                ref_buttonData.checkbox1[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox1[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(9679)})
            end
            updateSave()
        end

    --Checks or unchecks the Movement box
        function click_checkbox2(tableIndex, buttonIndex)
            if ref_buttonData.checkbox2[tableIndex].state == true then
                ref_buttonData.checkbox2[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox2[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(9632)})
            end
            updateSave()
        end

    --Checks or unchecks the Bonus Action box
        function click_checkbox3(tableIndex, buttonIndex)
            if ref_buttonData.checkbox3[tableIndex].state == true then
                ref_buttonData.checkbox3[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox3[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(9650)})
            end
            updateSave()
        end

    --Checks or unchecks the Reaction box
        function click_checkbox4(tableIndex, buttonIndex)
            if ref_buttonData.checkbox4[tableIndex].state == true then
                ref_buttonData.checkbox4[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox4[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(10022)})
            end
            updateSave()
        end

    --Checks or unchecks the Interaction box
        function click_checkbox5(tableIndex, buttonIndex)
            if ref_buttonData.checkbox5[tableIndex].state == true then
                ref_buttonData.checkbox5[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox5[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(9670)})
            end
            updateSave()
        end

    --Applies value to given counter display
        function click_counter(tableIndex, buttonIndex, amount)
            ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
            self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
            updateSave()
        end

    --Applies value to Speed Counter display
        function click_counterspeed(tableIndex, buttonIndex, amount)
            ref_buttonData.counterspeed[tableIndex].value = ref_buttonData.counterspeed[tableIndex].value + amount
            ref_buttonData.counterspeed[2].value = ref_buttonData.counterspeed[tableIndex].value
            local speed = ref_buttonData.counterspeed[2].value

            --If Base speed changes, so does expendable speed
            if buttonIndex == 0 then
                self.editButton({index=0, label=speed})
            elseif buttonIndex == 3 then
                --Both Dash and Prone are Checked
                    if ref_buttonData.checkboxdash[1].state == true and ref_buttonData.checkboxprone[1].state == true then
                        speed = ((math.floor((ref_buttonData.counterspeed[2].value / 5) /2) * 5) + ref_buttonData.counterspeed[1].value)
                        self.editButton({index=3, label=speed})
                --Only Dash is Checked
                    elseif ref_buttonData.checkboxdash[1].state == true then
                        speed = ref_buttonData.counterspeed[2].value + ref_buttonData.counterspeed[1].value
                        self.editButton({index=3, label=speed})
                --Only Prone is Checked
                    elseif ref_buttonData.checkboxprone[1].state == true then
                        speed = (math.floor((ref_buttonData.counterspeed[2].value / 5) /2) * 5)
                        self.editButton({index=3, label=speed})
                --Neither Dash and Prone are Checked
                    else
                        self.editButton({index=3, label=speed})
                    end
            end
            updateSave()
        end

    --Predefined special checkbox (to lock other controls)
        function click_checkboxlock(tableIndex, buttonIndex)
            if ref_buttonData.checkboxlock[tableIndex].state == true then
                ref_buttonData.checkboxlock[tableIndex].state = false
                self.editButton({index=buttonIndex, color=buttonFontColorRed, font_color=buttonFontColorWhite, label="Locked"})
            else
                ref_buttonData.checkboxlock[tableIndex].state = true
                self.editButton({index=buttonIndex, color=buttonFontColorGreen, font_color=buttonFontColorWhite, label="Unlocked"})
                for i, text in ipairs(ref_buttonData.textbox) do
                    self.editInput({index=i-1, value=ref_buttonData.textbox[i].value})
                end
            end
            updateSave()
        end

    --Predefined special checkbox (to reset all checkboxes)
        function click_checkboxreset(tableIndex, buttonIndex)
            --self.editButton({index=3, label=ref_buttonData.counterspeed[tableIndex].value})
            click_reset()
            --Dash and Prone
                if ref_buttonData.checkboxdash[tableIndex].state == true then
                    ref_buttonData.checkboxdash[tableIndex].state = false
                    self.editButton({index=6, label=""})
                end
                if ref_buttonData.checkboxprone[tableIndex].state == true then
                    ref_buttonData.checkboxprone[tableIndex].state = false
                    self.editButton({index=7, label=""})
                end
            --Actions
                if ref_buttonData.checkbox1[tableIndex].state == false then
                    ref_buttonData.checkbox1[tableIndex].state = true
                    self.editButton({index=8, label=string.char(9679)})
                end
                if ref_buttonData.checkbox2[tableIndex].state == false then
                    ref_buttonData.checkbox2[tableIndex].state = true
                    self.editButton({index=9, label=string.char(9632)})
                end
                if ref_buttonData.checkbox3[tableIndex].state == false then
                    ref_buttonData.checkbox3[tableIndex].state = true
                    self.editButton({index=10, label=string.char(9650)})
                end
                if ref_buttonData.checkbox4[tableIndex].state == false then
                    ref_buttonData.checkbox4[tableIndex].state = true
                    self.editButton({index=11, label=string.char(10022)})
                end
                if ref_buttonData.checkbox5[tableIndex].state == false then
                    ref_buttonData.checkbox5[tableIndex].state = true
                    self.editButton({index=12, label=string.char(9670)})
                end
            updateSave()
        end

    --Updates saved value for given text box
        function click_textbox(i, color, value, selected)
            if ref_buttonData.checkboxlock[1].state then
                if selected == false then
                    ref_buttonData.textbox[i].value = value
                    updateSave()
                end
            else
                if selected == true then
                    printOut(color)
                    Wait.time(function() self.editInput({index=i-1,value=ref_buttonData.textbox[i].value}) end,0.1)
                end
            end
        end

    --Print Statement for Lock Checkbox
        function printOut(col)    
            broadcastToColor("Unable to edit, Card is Locked", col, "Red")
        end

    --Dud function for if you have a background on a counter
        function click_none() end

    --Dud function for if you have a background on a counter
        function click_reset() 
            ref_buttonData.counterspeed[2].value = ref_buttonData.counterspeed[1].value
            local speed = ref_buttonData.counterspeed[2].value
            self.editButton({index=3, label=speed})
        end

--Button creation

    --Makes checkboxes
        function createCheckboxDash()
            for i, data in ipairs(ref_buttonData.checkboxdash) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkboxdash"..i
                local func = function() click_checkboxdash(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9679) end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes checkboxes
        function createCheckboxProne()
            for i, data in ipairs(ref_buttonData.checkboxprone) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkboxprone"..i
                local func = function() click_checkboxprone(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9679) end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Action Checkbox
        function createActionCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox1) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox1"..i
                local func = function() click_checkbox1(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9679) end

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorGreen
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Movement Checkbox
        function createMovementCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox2) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox2"..i
                local func = function() click_checkbox2(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9632) end

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorYellow
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Bonus Action Checkbox
        function createBonusActionCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox3) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox3"..i
                local func = function() click_checkbox3(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9650) end

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorOrange
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Reaction Checkbox
        function createReactionCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox4) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox4"..i
                local func = function() click_checkbox4(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(10022) end

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorPink
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Interaction Checkbox
        function createInteractionCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox5) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox5"..i
                local func = function() click_checkbox5(i, buttonNumber) end
                self.setVar(funcName, func)
                --Sets up label
                local label = ""
                if data.state==true then label=string.char(9670) end

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size, width=data.size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorBlue
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Basic counters
        function CreateCounter()
            for i, data in ipairs(ref_buttonData.counter) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorPurple
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterAdd"..i
                local func = function() click_counter(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
                --Sets up size
                local size = data.size / 2
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterSub"..i
                local func = function() click_counter(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Create Speed Counter
        function createCounterSpeed()
            for i, data in ipairs(ref_buttonData.counterspeed) do
                --Sets up display
                local displayNumber = spawnedButtonCount
                --Sets up label
                local label = data.value
                --Sets height/width for display
                local size = data.size
                if data.hideBG == true then size = 0 end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function="click_reset", function_owner=self,
                    position=data.pos, height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterspeedAdd5"..i
                local func = function() click_counterspeed(i, displayNumber, 5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+5"
                --Sets up position
                local pos = {data.pos[1] + 0.3, data.pos[2], data.pos[3]}
                --Sets up size
                local size = 100
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterspeedSub5"..i
                local func = function() click_counterspeed(i, displayNumber, -5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-5"
                --Set up position
                local pos = {data.pos[1] - 0.3, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Create Textboxes
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
                    color          = buttonColor,
                    font_color     = buttonFontColor,
                    value          = data.value,
                })
            end
        end

    --Makes Rest Counter
        function createCheckboxReset()
            for i, data in ipairs(ref_buttonData.checkboxreset) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkboxreset"..i
                local func = function() click_checkboxreset(i, buttonNumber) end
                self.setVar(funcName, func)

                --Creates button and counts it
                self.createButton({
                    label="Reset", click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size*1.5, width=data.size*5,
                    font_size=data.size, scale=buttonScale,
                    color=buttonFontColorRed, font_color=buttonFontColorWhite
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

    --Makes Lock Checkbox
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
                if data.state==false then label="Locked" color=buttonFontColorRed end
                if data.state==true then label="Unlocked" color=buttonFontColorGreen end
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=data.pos, height=data.size*1.5, width=data.size*5,
                    font_size=data.size, scale=buttonScale,
                    color=color, font_color=buttonFontColorWhite
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end