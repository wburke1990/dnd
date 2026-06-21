--[[    Character Sheet Template    by: MrStump ]]

--Set to true when editing
disableSave = false

--Color information for button text (r,g,b, values of 0-1)
    buttonFontColor = {0,0,0, 100}
    
--Color information for button background
    buttonColor = {1,1,1, 0.01}
    buttonColorWhite = {1,1,1, 0.01}
    buttonColorBlack = {1,1,1, 95}
    buttonColorRed = {0.94,0.125,0.121, 100}
    buttonColorYellow = {1,0.65,0, 100}
    buttonColorGreen = {0,0.75,0.33, 100}

--Change scale of button (Avoid changing if possible)
buttonScale = {1,1,1}

--This is the button placement information
defaultButtonData = {
    --Add Lockable Checkbox
        checkboxlock = {
            {   pos   = {0.999,0.05,1.572},
                size  = 105,
                state = true    },  },
    --Add Refresh Button       
        longrest = {
        {   pos   = {0.999,0.05,-1.541},
            size  = 105,
            state = true    },  },
    --Total Spell Slots
        numbox = {
            --Spell Level 1
                {   
                    pos       = {-1.165,0.05,-1.212}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 2
                {   
                    pos       = {-1.165,0.05,-0.535}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 3
                {   
                    pos       = {-1.165,0.05,0.14}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 4
                {   
                    pos       = {-1.165,0.05,0.815}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                }, 
            --Spell Level 5
                {   
                    pos       = {-1.165,0.05,1.485}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 6
                {   
                    pos       = {0.69,0.05,-1.04}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 7
                {   
                    pos       = {0.69,0.05,-0.32}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Spell Level 8
                {   
                    pos       = {0.69,0.05,0.399}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                }, 
            --Spell Level 9
                {   
                    pos       = {0.69,0.05,1.116}, 
                    rows      = 1,
                    width     = 150,
                    font_size = 150,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            },
    --Expendable Spell Slots
        numbox2 = {
            --Spell Level 1
                {   pos         = {-0.46,0.05,-1.212},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 2
                {   pos         = {-0.46,0.05,-0.535},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 3
                {   pos         = {-0.46,0.05,0.14},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 4
                {   pos         = {-0.46,0.05,0.815},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 5
                {   pos         = {-0.46,0.05,1.485},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 6
                {   pos         = {1.4,0.05,-1.04},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 7
                {   pos         = {1.4,0.05,-0.32},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 8
                {   pos         = {1.4,0.05,0.399},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Spell Level 9
                {   pos         = {1.4,0.05,1.116},
                    rows        = 1,
                    width       = 150,
                    font_size   = 150,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
        },
    }
--=====================
--Lua beyond this point
--=====================

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
    createCheckboxLock()
    createLongRest()
    createNumbox()
    createNumbox2()
    end

--===========================
--Click functions for buttons
--===========================
--Lockable Checkbox (to lock other controls)
        function click_checkboxlock(tableIndex, buttonIndex)
            if ref_buttonData.checkboxlock[tableIndex].state == true then
                ref_buttonData.checkboxlock[tableIndex].state = false
                self.editButton({index=buttonIndex, color=buttonColorRed, font_color=buttonColorWhite, label="Locked"})
            else
                ref_buttonData.checkboxlock[tableIndex].state = true
                self.editButton({index=buttonIndex, color=buttonColorGreen, font_color=buttonColorWhite, label="Unlocked"})
            end
            updateSave()
        end
--Button for Long Rests
    function click_longrest(tableIndex, color)
        broadcastToColor("You've Long Rested.", color, buttonColorYellow)
        
        --Sets all depentable values equal to their parent values
        for i, num in ipairs(ref_buttonData.numbox2) do
            ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
            self.editInput({index=i+8, value=ref_buttonData.numbox2[i].value})
        end

        updateSave()
    end

    --Updates saved value for Total Spell Slots
        function click_numbox(i, color, value, selected, amount)
            if ref_buttonData.checkboxlock[1].state then
                if amount ~= 0 then
                    if amount == -1 and tonumber(ref_buttonData.numbox[i].value) < 1 then
                        if color == nil then
                            --Prevent no player found error message
                            self.editInput({index=i-1,value=0})
                        else
                            broadcastToColor("Value can't be negative.", color, "Red")
                            self.editInput({index=i-1,value=ref_buttonData.numbox[i].value})
                        end
                    else
                            ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                            self.editInput({index=i-1,value=ref_buttonData.numbox[i].value})
                    end
                    updateSave()
                end
                if selected == false then
                    if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                            ref_buttonData.numbox[i].value = value
                            updateSave()
                        else
                            broadcastToColor("Enter a valid number.", color, "Red")
                            Wait.time(function() self.editInput({index=i-1,value=ref_buttonData.numbox[i].value})end,0.1)
                    end
                end
            else
                if selected == true then
                        printOut(color)
                    Wait.time(
                        function() self.editInput({index=i-1,value=ref_buttonData.numbox[i].value})end,0.1)
                end
            end
            updateSave()
        end
    
    --Updates saved value for Expendable Spell Slots
        function click_numbox2(i, color, value, selected, amount)
            if amount ~= 0 then
                if amount == -1 and tonumber(ref_buttonData.numbox2[i].value) < 1 then
                    if color == nil then
                        --Prevent no player found error message
                        self.editInput({index=i+8,value=ref_buttonData.numbox2[i].value})
                    else
                        broadcastToColor("Value can't be negative.", color, "Red")
                        self.editInput({index=i+8,value=ref_buttonData.numbox2[i].value})
                    end
                else
                    if amount == 1 and tonumber(ref_buttonData.numbox2[i].value) >= tonumber(ref_buttonData.numbox[i].value) then
                        if color == nil then
                            --Prevent no player found error message
                            self.editInput({index=i+8,value=ref_buttonData.numbox2[i].value})
                        end
                    else
                        ref_buttonData.numbox2[i].value = ref_buttonData.numbox2[i].value + amount
                        self.editInput({index=i+8,value=ref_buttonData.numbox2[i].value})
                    end
                end
            end
            if selected == false then
                if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                    if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                        updateSave()
                    else
                        ref_buttonData.numbox2[i].value = value
                        updateSave()
                    end
                else
                     broadcastToColor("Enter a valid number.", color, "Red")
                    Wait.time(function() self.editInput({index=i+8,value=ref_buttonData.numbox2[i].value}) end,0.1)
                end
            end
        end

    --Print Statement for Lock Checkbox
        function printOut(col)    
            broadcastToColor("Unable to edit, Card is Locked", col, "Red")
        end

    --Dud function for if you have a background on a counter
        function click_none() end

--===============
--Button creation
--===============
--Create Checkbox Lock
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
                position=data.pos, height=data.size*1.5, width=data.size*5.5,
                font_size=data.size, scale=buttonScale,
                color=color, font_color=buttonColorWhite
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end
--Create Long Rest Button 
    function createLongRest()
        for i, data in ipairs(ref_buttonData.longrest) do
            --Sets up display
            local displayNumber = spawnedButtonCount
            --Sets up label
            local label = string.char(9728) .. " Long Rest "
            --Sets height/width for display
            local size = data.size
            if data.hideBG == true then size = 0 end
            --Creates button and counts it
            self.createButton({
                label=label, click_function="click_longrest", function_owner=self,
                position=data.pos, height=data.size*1.5, width=data.size*6.5,
                font_size=data.size, scale=buttonScale,
                color=buttonColorYellow, font_color=buttonColorWhite
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end
--Create Total Spell Slots
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
                color          = buttonColorWhite,
                font_color     = data.font_color,
                value          = data.value,
            })
            --Sets up add 1
            local funcName = "numboxAdd"..i
            local func = function() click_numbox(i,col,val,sel,1) end
            self.setVar(funcName, func)
            --Sets up label
            local label = "+"
            --Sets up size
            local size = (data.font_size / 1.3)
            --Sets up position
            local offsetDistance = (size/2 + size/4) * (buttonScale[1] * 0.0025)
            local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=data.font_size, scale=buttonScale,
                color=buttonColorWhite, font_color=buttonColorBlack
            })

            --Sets up subtract 1
            local funcName = "numboxSub"..i
            local func = function() click_numbox(i,col,val,sel,-1) end
            self.setVar(funcName, func)
            --Sets up label
            local label = "-"
            --Set up position
            local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=data.font_size, scale=buttonScale,
                color=buttonColorWhite, font_color=buttonColorBlack
            })
        end
    end
--Create Expendable Spell Slots
    function createNumbox2()
        for i, data in ipairs(ref_buttonData.numbox2) do
            --Sets up reference function
            local funcName = "numbox2"..i
            local func = function(_,col,val,sel,amt) click_numbox2(i,col,val,sel,0) end
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
                color          = buttonColorWhite,
                font_color     = data.font_color,
                value          = data.value,
            })
            --Sets up add 1
            local funcName = "numbox2Add"..i
            local func = function() click_numbox2(i,col,val,sel,1) end
            self.setVar(funcName, func)
            --Sets up label
            local label = "+"   
            --Sets up size
            local size = (data.font_size / 1.3)
            local offsetDistance = (size/2 + size/4) * (buttonScale[1] * 0.0025)
            --Sets up position
            local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=data.font_size, scale=buttonScale,
                color=buttonColorWhite, font_color=buttonColorBlack
            })

            --Sets up subtract 1
            local funcName = "numbox2Sub"..i
            local func = function() click_numbox2(i,col,val,sel,-1) end
            self.setVar(funcName, func)
            --Sets up label
            local label = "-"
            --Set up position
            local pos = {data.pos[1] - offsetDistance, data.pos[2], data.pos[3]}
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=data.font_size, scale=buttonScale,
                color=buttonColorWhite, font_color=buttonColorBlack
            })
        end
    end