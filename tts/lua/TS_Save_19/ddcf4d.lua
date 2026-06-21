--[[    Character Sheet Template    by: MrStump ]]

--Set to true when editing
disableSave = false

--Color information for button text (r,g,b, values of 0-1)
    buttonFontColor = {0,0,0, 95}
    --buttonFontColorDark = {1,1,1, 95}
    buttonFontColorRed = {1,0,0, 15}
    buttonFontColorYellow = {0.9,0.7,0.16, 15}
    buttonFontColorGreen = {0,0.8, 0.4, 15}
    buttonFontColorBlue = {0.2,0.59,1, 15}
    buttonFontColorPurple = {0.7,0,1, 15}
    
--Color information for button background
    buttonColor = {1,1,1, 0.2}
    buttonColorBlack = {0,0,0}

--Change scale of button (Avoid changing if possible)
buttonScale = {1.1,1.1,1.1}

--This is the button placement information
defaultButtonData = {
    --Add checkboxes
        checkbox = {
            --[[
                pos   = the position (pasted from the helper tool)
                size  = height/width/font_size for checkbox
                state = default starting value for checkbox (true=checked, false=not)
            ]]
                --Blinded
                    {
                        pos   = {-0.519,0.1,-0.589},
                        size  = 400,
                        state = false
                    },
                --Charmed
                    {
                        pos   = {-0.517,0.1,-0.052},
                        size  = 400,
                        state = false
                    },
                --Deafened
                    {
                        pos   = {-0.513,0.1,0.491},
                        size  = 400,
                        state = false
                    },
                --Frightened
                    {
                        pos   = {1.306,0.1,-0.599},
                        size  = 400,
                        state = false
                    },
                --Grappled
                    {
                        pos   = {1.301,0.1,-0.056},
                        size  = 400,
                        state = false
                    },
                --Incapacitated
                    {
                        pos   = {1.305,0.1,0.487},
                        size  = 400,
                        state = false
                    },
                --Invisible
                    {
                        pos   = {3.323,0.1,-0.595},
                        size  = 400,
                        state = false
                    },
                --Paralyzed
                    {
                        pos   = {3.318,0.1,-0.043},
                        size  = 400,
                        state = false
                    },
                --Petrified
                    {
                        pos   = {3.322,0.1,0.491},
                        size  = 400,
                        state = false
                    },
                --Poisoned
                    {
                        pos   = {5.082,0.1,-0.598},
                        size  = 400,
                        state = false
                    },
                --Empty
                    {
                        pos   = {-2.399,0.1,0.441},
                        size  = 400,
                        state = false
                    },
                --Restrained
                    {
                        pos   = {5.086,0.1,-0.055},
                        size  = 400,
                        state = false
                    },
                --Stunned
                    {
                        pos   = {5.08,0.1,0.487},
                        size  = 400,
                        state = false
                    },
                },

    --Inspiration Checkbox
        checkbox1 = {
                {
                    pos    = {-3.932,0.1,0.444},
                    size   = 200,
                    value  = 10,
                    hideBG = false
                },
            },

    --Passive Perception counter
        counter = {
                {
                    pos    = {-3.939,0.1,-0.487},
                    size   = 200,
                    value  = 10,
                    hideBG = false
                },
            },

    --Add hp counters
        numbox = {
            --Max HP
                {
                    pos       = {-5.39,0.1,-0.145}, 
                    rows      = 1,
                    width     = 430,
                    font_size = 245,
                    label     = "",
                    value     = 0,
                    font_color=buttonFontColorRed,
                    alignment = 3
                },
            },

    --Add armor class counters
        counterac = {
            --Armor Class counter
                {
                     pos    = {-7.114,0.1,-0.132},
                    size   = 300,
                    value  = 10,
                    hideBG = true
                },
            },

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
                --Character Name textbox
                    {
                        pos       = {-9.63,0.1,-0.15},
                        rows      = 1,
                        width     = 1300,
                        font_size = 120,
                        label     = "Character Name",
                        value     = "",
                        alignment = 3
                    },
                    --Notes textbox
                    {
                        pos       = {9,0.1,-0.03},
                        rows      = 6,
                        width     = 1850,
                        font_size = 100,
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
        createCheckbox()
        CreateCounter()
        createCounterAC()

        createInspirationCheckbox()
   
        createTextbox()
        createNumbox()
    end

--Click functions for buttons

    --Checks or unchecks the given box
        function click_checkbox(tableIndex, buttonIndex)
            if ref_buttonData.checkbox[tableIndex].state == true then
                ref_buttonData.checkbox[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(9679)})
            end
            updateSave()
        end

    --Checks or unchecks the given inspiration box
        function click_checkbox1(tableIndex, buttonIndex)
            if ref_buttonData.checkbox1[tableIndex].state == true then
                ref_buttonData.checkbox1[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox1[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(10004)})
            end
            updateSave()
        end

    --Applies value to given counter display
        function click_counter(tableIndex, buttonIndex, amount)
            ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
            self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
            updateSave()
        end

    --Applies value to given counterac display
        function click_counterac(tableIndex, buttonIndex, amount)
            ref_buttonData.counterac[tableIndex].value = ref_buttonData.counterac[tableIndex].value + amount
            self.editButton({index=buttonIndex, label=ref_buttonData.counterac[tableIndex].value})
            updateSave()
        end

    --Updates saved value for given text box
        function click_textbox(i, value, selected)
            if selected == false then
                ref_buttonData.textbox[i].value = value
                updateSave()
            end
        end

    --Updates saved value for numbox (numbers only)
        function click_numbox(i, color, value, selected, amount)
            if amount ~= 0 then
                if amount == -1 and tonumber(ref_buttonData.numbox[i].value) < 1 then
                    broadcastToColor("Value can't be negative.", color, "Red")
                    self.editInput({index=i+1,value=ref_buttonData.numbox[i].value})
                else 
                    ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                    self.editInput({index=i+1,value=ref_buttonData.numbox[i].value})
                end
            end
            if selected == false then
                if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                    ref_buttonData.numbox[i].value = value
                else
                    broadcastToColor("Enter a valid number.", color, "Red")
                    Wait.time(function() self.editInput({index=i+1,value=ref_buttonData.numbox[i].value}) end,0.1)
                end
            end
            updateSave()
        end

    --Dud function for if you have a background on a counter
    function click_none() end

--Button creation

    --Makes checkboxes
        function createCheckbox()
            for i, data in ipairs(ref_buttonData.checkbox) do
                --Sets up reference function
                local buttonNumber = spawnedButtonCount
                local funcName = "checkbox"..i
                local func = function() click_checkbox(i, buttonNumber) end
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

    --Makes inspiration checkboxes
        function createInspirationCheckbox()
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

    --Makes basic counters
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

    --Makes counters
        function createCounterAC()
            for i, data in ipairs(ref_buttonData.counterac) do
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
                    color=buttonColor, font_color=buttonFontColorBlue
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counteracAdd"..i
                local func = function() click_counterac(i, displayNumber, 1) end
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
                local funcName = "counteracSub"..i
                local func = function() click_counterac(i, displayNumber, -1) end
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

    --Create Initiative Counter
        function createcounterInti()
            for i, data in ipairs(ref_buttonData.counterinti) do
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
                    color=buttonColor, font_color=buttonFontColorGreen
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterintiAdd"..i
                local func = function() click_counterinti(i, displayNumber, 1) end
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
                local funcName = "counterintiSub"..i
                local func = function() click_counterinti(i, displayNumber, -1) end
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

    --Creates Textboxes
        function createTextbox()
            for i, data in ipairs(ref_buttonData.textbox) do
                --Sets up reference function
                local funcName = "textbox"..i
                local func = function(_,_,val,sel) click_textbox(i,val,sel) end
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

    --Create Hit Point Box
        function createNumbox()
            for i, data in ipairs(ref_buttonData.numbox) do
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
                    scale          = buttonScale,
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
                local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)
                local pos = {data.pos[1]+0.55, data.pos[2], data.pos[3]}
                --Sets up size
                local size = (data.font_size / 1.4)
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })

                --Sets up subtract 1
                local funcName = "numboxSub"..i
                local func = function() click_numbox(i,col,val,sel,-1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-"
                --Set up position
                local pos = {data.pos[1]-0.55, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=data.font_size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
            end
        end
