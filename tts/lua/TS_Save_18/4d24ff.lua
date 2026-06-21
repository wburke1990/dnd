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
    buttonColorBlue = {0,0.5,0.75, 100}

--Change scale of button (Avoid changing if possible)
buttonScale = {1,1,1}

--This is the button placement information
defaultButtonData = {
    --Add Lockable Checkbox
        checkboxlock = {
            {   pos   = {1.27,0.06,-0.8},
                size  = 80,
                state = true    },  },
    --Add Refresh Button       
        longrest = {
        {   pos   = {1.27,0.06,-1.58},
            size  = 80,
            state = true    },  },
        shortrest = {
        {   pos   = {1.27,0.06,-1.2},
            size  = 80,
            state = true    },  },
    --Short Rest Checkbox
        checkboxsr= {
            --Upper Left
            {   pos   = {-1.26,0.06,-1.601},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {-0.962,0.06,-1.591},
                value = 0 },
            --Upper Middle
            {   pos   = {0.01,0.06,-1.601},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {0.308,0.06,-1.591},
                value = 0 },
            --Middle Left
            {   pos   = {-1.26,0.06,-0.434},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {-0.962,0.06,-0.424},
                value = 0 },
            --Center Middle
            {   pos   = {0.01,0.06,-0.434},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {0.308,0.06,-0.424},
                value = 0 },
            --Middle Right
            {   pos   = {1.28,0.06,-0.434},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {1.578,0.06,-0.424},
                value = 0 },
            --Lower Left
            {   pos   = {-1.26,0.06,0.733},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {-0.962,0.06,0.743},
                value = 0 },
            --Lower Middle
            {   pos   = {0.01,0.06,0.733},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {0.308,0.06,0.743},
                value = 0 },
            --Lower Right
            {   pos   = {1.28,0.06,0.733},
                size  = 150,
                state = false,
                srlabel="No SR",
                srLabelPos  = {1.578,0.06,0.743},
                value = 0 },},
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
        --Resource Name textbox
            --Resource 1: Upper Left
            {   pos = {-1.27,0.06,-1.38},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 }, 
            --Resource 2: Upper Middle
            {   pos = {0,0.06,-1.38},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 3: Middle Left
            {   pos = {-1.27,0.06,-0.213},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 4: Center Middle
            {   pos = {0,0.06,-0.213},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 5: Middle Right
            {   pos = {1.27,0.06,-0.213},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 6: Lower Left
            {   pos = {-1.27,0.06,0.954},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 7: Lower Middle
            {   pos = {0,0.06,0.954},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },
            --Resource 8: Lower Right
            {   pos = {1.27,0.06,0.954},
                rows      = 1,
                width     = 525,
                font_size = 70,
                label     = "Name",
                value     = "",
                alignment = 3 },},
    --Total Resource
        numbox = {
            --Resource 1: Upper Left
                {   
                    pos       = {-1.563,0.06,-1}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 2: Upper Middle
                {   
                    pos       = {-0.293,0.06,-1}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 3: Middle Left
                {   
                    pos       = {-1.563,0.06,0.167}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 4: Center Middle
                {   
                    pos       = {-0.293,0.06,0.167}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 5: Middle Right
                {   
                    pos       = {0.977,0.06,0.167}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 6: Lower Left
                {   
                    pos       = {-1.563,0.06,1.334}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 7: Lower Middle
                {   
                    pos       = {-0.293,0.06,1.334}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            --Resource 8: Lower Right
                {   
                    pos       = {0.977,0.06,1.334}, 
                    rows      = 1,
                    width     = 140,
                    font_size = 120,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3 
                },
            },
    --Expendable Resource
        numbox2 = {
            --Resource 1: Upper Left
                {   pos         = {-0.984,0.06,-1},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 2: Upper Middle
                {   pos         = {0.286,0.06,-1},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 3: Middle Left
                {   pos         = {-0.984,0.06,0.167},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 4: Center Middle
                {   pos         = {0.286,0.06,0.167},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 5: Middle Right
                {   pos         = {1.556,0.06,0.167},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 6: Lower Left
                {   pos         = {-0.984,0.06,1.334},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 7: Lower Middle
                {   pos         = {0.286,0.06,1.334},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
                    label       = "",
                    value       = 0,
                    font_color  = buttonColorBlack,
                    alignment   = 3 },
            --Resource 8: Lower Right
                {   pos         = {1.556,0.06,1.334},
                    rows        = 1,
                    width       = 140,
                    font_size   = 120,
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
    createShortRest()
    createCheckboxSR()
    createNumbox()
    createNumbox2()
    createTextbox()
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
            self.editInput({index=i+7, value=ref_buttonData.numbox2[i].value})
        end

        updateSave()
    end
--Button for Short Rests
    function click_shortrest(tableIndex, color)
        broadcastToColor("You've Short Rested.", color, buttonColorBlue)

        for i, num in ipairs(ref_buttonData.numbox2) do
            --Full Restore
            if ref_buttonData.checkboxsr[i].state == true and ref_buttonData.checkboxsr[i].value == 2 then
                ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                self.editInput({index=i+7, value=ref_buttonData.numbox2[i].value})

            --Restore +1
            elseif ref_buttonData.checkboxsr[i].state == true and ref_buttonData.checkboxsr[i].value == 1 then
                ref_buttonData.numbox2[i].value = ref_buttonData.numbox2[i].value + 1
            if tonumber(ref_buttonData.numbox2[i].value) >= tonumber(ref_buttonData.numbox[i].value) then
                ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value end
            self.editInput({index=i+7, value=ref_buttonData.numbox2[i].value})

            --Nothing
            elseif ref_buttonData.checkboxsr[i].state == false then
                return
            end
        end

        updateSave()
    end

--Checkbox for Short Rest Checkbox
    function click_checkboxsr(tableIndex, buttonIndex)
        if ref_buttonData.checkboxlock[1].state then

            --Expertise Check (Short Rest Full Restore)
            if ref_buttonData.checkboxsr[tableIndex].state == true and ref_buttonData.checkboxsr[tableIndex].value == 1 then
                ref_buttonData.checkboxsr[tableIndex].state = true
                ref_buttonData.checkboxsr[tableIndex].value = 2
                ref_buttonData.checkboxsr[tableIndex].srlabel="Full SR"
                self.editButton({index=buttonIndex+1, label="Full SR"})
                self.editButton({index=buttonIndex, font_color=buttonColorRed, label=string.char(9679), value=2})

            --Prof Check (Short Rest +1 Resource)
            elseif ref_buttonData.checkboxsr[tableIndex].state == false then
                ref_buttonData.checkboxsr[tableIndex].state = true
                ref_buttonData.checkboxsr[tableIndex].value = 1
                ref_buttonData.checkboxsr[tableIndex].srlabel="+1/SR"
                self.editButton({index=buttonIndex+1, label="+1/SR"})
                self.editButton({index=buttonIndex, font_color=buttonColorBlack, label=string.char(9679), value=1})

            --Nothing
            elseif ref_buttonData.checkboxsr[tableIndex].state == true and ref_buttonData.checkboxsr[tableIndex].value == 2 then
                ref_buttonData.checkboxsr[tableIndex].state = false
                ref_buttonData.checkboxsr[tableIndex].value = 0
                ref_buttonData.checkboxsr[tableIndex].srlabel="No SR"
                self.editButton({index=buttonIndex+1, label="No SR"})
                self.editButton({index=buttonIndex, font_color=buttonColorBlack, label="", value=0})
            end

            
            updateSave()
        end
    end

--Updates saved value for Total Resources (Numbox 1)
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
                if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                    ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                    self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
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
                if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                    ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                    self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
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

--Updates saved value for Expendable Resources (Numbox 2)
    function click_numbox2(i, color, value, selected, amount)
        if amount ~= 0 then
            if amount == -1 and tonumber(ref_buttonData.numbox2[i].value) < 1 then
                if color == nil then
                    --Prevent no player found error message
                    self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
                    updateSave()
                else
                    broadcastToColor("Value can't be negative.", color, "Red")
                    self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
                    updateSave()
                end
            else
                if amount == 1 and tonumber(ref_buttonData.numbox2[i].value) >= tonumber(ref_buttonData.numbox[i].value) then
                    if color == nil then
                        --Prevent no player found error message
                        self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
                        updateSave()
                    end
                else
                    ref_buttonData.numbox2[i].value = ref_buttonData.numbox2[i].value + amount
                    self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value})
                    updateSave()
                end
            end
        end

        if selected == false or selected == true  then
            if tonumber(value) ~= nil and (tonumber(value) < 1000 and tonumber(value) > -1) then
                --Current Resource set to Max Resource
                if tonumber(ref_buttonData.numbox2[i].value) > tonumber(ref_buttonData.numbox[i].value) then
                    broadcastToColor("Number can't be higher than " .. tonumber(ref_buttonData.numbox[i].value) , color, "Red")
                    if color == nil then end --Prevent no player found error message 
                    ref_buttonData.numbox2[i].value = ref_buttonData.numbox[i].value
                    Wait.time(function() self.editInput({index=i+7,value=tonumber(ref_buttonData.numbox2[i].value)}) end,0.1)
                else
                    ref_buttonData.numbox2[i].value = value
                end
            else
                broadcastToColor("Enter a valid number.", color, "Red")
                Wait.time(function() self.editInput({index=i+7,value=ref_buttonData.numbox2[i].value}) end,0.1)
            end
            updateSave()
        end

    end

--Print Statement for Lock Checkbox
    function printOut(col)    
        broadcastToColor("Unable to edit, Sheet is Locked", col, "Red")
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
                    Wait.time(function() self.editInput({index=i+15,value=ref_buttonData.textbox[i].value}) end,0.12)
                end
            end
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
--Create Short Rest Button 
    function createShortRest()
        for i, data in ipairs(ref_buttonData.shortrest) do
            --Sets up display
            local displayNumber = spawnedButtonCount
            --Sets up label
            local label = string.char(9832) .. " Short Rest "
            --Sets height/width for display
            local size = data.size
            if data.hideBG == true then size = 0 end
            --Creates button and counts it
            self.createButton({
                label=label, click_function="click_shortrest", function_owner=self,
                position=data.pos, height=data.size*1.5, width=data.size*6.5,
                font_size=data.size, scale=buttonScale,
                color=buttonColorBlue, font_color=buttonColorWhite
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end
--Makes Short Rest Checkbox
    function createCheckboxSR()
        for i, data in ipairs(ref_buttonData.checkboxsr) do
            --Sets up reference function
            local buttonNumber = spawnedButtonCount
            local funcName = "checkboxsr"..i
            local func = function() click_checkboxsr(i, buttonNumber) end
            self.setVar(funcName, func)
            --Sets up label
            local label = ""
            local fontColor=buttonColorBlack
            if ref_buttonData.checkboxsr[i].value == 2 then
                fontColor=buttonColorRed
            end
            if data.state==true then label=string.char(9679) end
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=data.pos, height=data.size, width=data.size,
                font_size=data.size, scale=buttonScale,
                color=buttonColorWhite, font_color=fontColor
            })
            spawnedButtonCount = spawnedButtonCount + 1

        --Sets up Short Rest Label
        local buttonNumber2 = spawnedButtonCount
            --Creates button and counts it
            self.createButton({
                label=data.srlabel, click_function="click_none", function_owner=self,
                position=data.srLabelPos, height=0, width=0,
                font_size=70, scale=buttonScale,
                color=buttonColorWhite, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end
--Create Resource Total (Numbox 1)
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
            spawnedButtonCount = spawnedButtonCount + 1

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
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end
--Create Resource Uses (Numbox 2)
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
            spawnedButtonCount = spawnedButtonCount + 1

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
                    color          = {0,0,0,0},
                    font_color     = buttonColorBlack,
                    value          = data.value,
                })
            end
        end
