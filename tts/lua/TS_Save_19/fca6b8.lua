--[[    Character Sheet Template    by: MrStump

Begin editing below:    ]]

--Set this to true while editing and false when you have finished
disableSave = false

    buttonColorBlack = {0,0,0, 100}
    buttonColorWhite = {1,1,1, 0.01}
    buttonColor = {1,1,1, 0.01}
    buttonColorRed = {0.94,0.125,0.121, 100}
    buttonColorGreen = {0,0.75,0.33, 100}

--Change scale of button (Avoid changing if possible)
    buttonScale = {0.5,0.5,0.5}

--This is the button placement information
defaultButtonData = {

    --Add counter for proficiency bonus
        profbonus = {
        {   pos    = {-0.643,0.12,-0.038},
            size   = 250,
            value  = 0,
            hideBG = true }, },

    --Add spellcasting counters
        spellcounter = {
        --Spell spellcounter
        {   
            size    = 250,
            value   = 0,
            hideBG = true,
            
            --Spellcasting Modifier
            pos1    = {-0.586,0.12,0.608},
            
            --Spellattack Bonus
            pos2    = {0,0.12,0.608},
            
            --Spell Save DC
            pos3    = {0.597,0.12,0.608}, 
        }, 
    },
  
    --Add counters that have a + and - button
        counter = {
        --Create Cantrips Known Counter
        {   
            pos    = {0,0.12,-0.045},
            size   = 250,
            value  = 0,
            hideBG = true,
            color = buttonColor 
        },
        --Create Spell Prepared Counter
        {   
            pos    = {0.652,0.12,-0.039},
            size   = 250,
            value  = 0,
            hideBG = true,
            color = buttonColor 
        }, 
    },

    --Add Lockable Checkbox
        checkboxlock = {
            {   
                pos   = {0.77,0.12,-0.858},
                size  = 110,
                state = true    
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
            --Spellcasting Ability Name
            {   pos       = {0,0.12,-0.557},
                rows      = 1,
                width     = 1700,
                font_size = 120,
                label     = "Spell Ablity Name",
                value     = "",
                alignment = 3 
            }, }
}

--======================
--Lua beyond this point
--======================

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
    createSpellCounter()
    createProfBonus()
    createCounter()
    createCheckboxLock()
    createTextbox()
end

--============================
--Click functions for buttons
--============================

--Updates saved value for Proficiency Bonus
    function click_profbonus(tableIndex, buttonIndex, amount)
        if ref_buttonData.checkboxlock[1].state then
            ref_buttonData.profbonus[tableIndex].value = ref_buttonData.profbonus[tableIndex].value + amount
            self.editButton({index=buttonIndex, label=ref_buttonData.profbonus[tableIndex].value})
            
            local prof_bonus = ref_buttonData.profbonus[tableIndex].value
            self.editButton({index=1, 
                value= math.floor(((ref_buttonData.spellcounter[tableIndex].value) + prof_bonus)),
                label= math.floor(((ref_buttonData.spellcounter[tableIndex].value) + prof_bonus))})
            self.editButton({index=2, 
                value= math.floor(((ref_buttonData.spellcounter[tableIndex].value + 8) + prof_bonus)),
                label= math.floor(((ref_buttonData.spellcounter[tableIndex].value + 8) + prof_bonus))})
            updateSave()
        else

            updateSave()
        end
    end

--Updates saved value for Spellcasting (Spellcasting Modifier, Spell Attack Bonus, Spell Save DC)
    function click_spellcounter(tableIndex, buttonIndex, buttonIndex2, buttonIndex3, amount)
        if ref_buttonData.checkboxlock[1].state then
            ref_buttonData.spellcounter[tableIndex].value = ref_buttonData.spellcounter[tableIndex].value + amount
            local prof_bonus = ref_buttonData.profbonus[tableIndex].value
            self.editButton({index=0, label= ref_buttonData.spellcounter[tableIndex].value})
            self.editButton({index=1, 
                value= math.floor(((ref_buttonData.spellcounter[tableIndex].value) + prof_bonus)),
                label= math.floor(((ref_buttonData.spellcounter[tableIndex].value) + prof_bonus))})
            self.editButton({index=2, 
                value= math.floor(((ref_buttonData.spellcounter[tableIndex].value + 8) + prof_bonus)),
                label= math.floor(((ref_buttonData.spellcounter[tableIndex].value + 8) + prof_bonus))})
            updateSave()
        else
            updateSave()
        end
    end

--Applies value to Basic Counter display (Cantrips Known + Spells Prepared)
    function click_counter(tableIndex, buttonIndex, amount)
        if ref_buttonData.checkboxlock[1].state then
            ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
            self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
            updateSave()
        else
            updateSave()
        end
    end

--Lockable Checkbox (to lock other controls)
    function click_checkboxlock(tableIndex, buttonIndex)
        if ref_buttonData.checkboxlock[1].state then
            ref_buttonData.checkboxlock[tableIndex].state = false
            self.editButton({index=buttonIndex, color=buttonColorRed, font_color=buttonColorWhite, label="Locked"})
        else
            ref_buttonData.checkboxlock[tableIndex].state = true
            self.editButton({index=buttonIndex, color=buttonColorGreen, font_color=buttonColorWhite, label="Unlocked"})
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

--Message that Sheet is Locked
    function printOut(col)    
        broadcastToColor("Unable to edit, Sheet is Locked", col, "Red")
    end

--Dud function for if you have a background on a spellcounter
    function click_none() end

--===============
--Button creation
--===============

--Create Proficiency Bonus Counter
    function createProfBonus()
        for i, data in ipairs(ref_buttonData.profbonus) do
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
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1

        --Sets up add 1
            local funcName = "profbonusAdd"..i
            local func = function() click_profbonus(i, displayNumber, 1) end
            self.setVar(funcName, func)

            --Sets up label
            local label = "+"

            --Sets up position
            local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0018)
            local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}

            --Sets up size
            local size = data.size / 2

            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=size, scale=buttonScale,
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1

        --Sets up subtract 1
            local funcName = "profbonusSub"..i
            local func = function() click_profbonus(i, displayNumber, -1) end
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
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end

--Create Spellcasting Counters
    function createSpellCounter()
        for i, data in ipairs(ref_buttonData.spellcounter) do
            --Sets up display
            local displayNumber = spawnedButtonCount

            if data.hideBG == true then size = 0 end

            --Creates button Spellcasting Ability
            self.createButton({
                label=data.value, click_function="click_none", function_owner=self,
                position=data.pos1, 
                height=data.size, width=data.size,
                font_size=data.size, scale=buttonScale,
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1

            local displayNumber2 = spawnedButtonCount
            
            --Sets up label
            local label = (data.value + ref_buttonData.profbonus[1].value)

            --Spell Attack Bonus
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos2, 
                    height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

            local displayNumber3 = spawnedButtonCount

            --Sets up label
            local label = ((data.value + 8 ) + ref_buttonData.profbonus[1].value)

            --Spell Save DC
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position=data.pos3, 
                    height=size, width=size,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonColorBlack
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up add 1
            local funcName = "spellcounterAdd"..i
            local func = function() click_spellcounter(i, displayNumber, displayNumber2, displayNumber3, 1) end
            self.setVar(funcName, func)

            --Sets up position
            local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0018)
            local pos = {data.pos1[1] + offsetDistance, data.pos1[2], data.pos1[3]}

            --Sets up size
            local size = data.size / 2

            --Creates button and counts it
            self.createButton({
                label="+", click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=size, scale=buttonScale,
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1

            --Sets up subtract 1
            local funcName = "spellcounterSub"..i
            local func = function() click_spellcounter(i, displayNumber, displayNumber2, displayNumber3, -1) end
            self.setVar(funcName, func)

            --Set up position
            local pos = {data.pos1[1] - offsetDistance, data.pos1[2], data.pos1[3]}
            --Creates button and counts it
            self.createButton({
                label="-", click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=size, scale=buttonScale,
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end

--Create Counters
    function createCounter()
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
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1

            --Sets up add 1
            local funcName = "counterAdd"..i
            local func = function() click_counter(i, displayNumber, 1) end
            self.setVar(funcName, func)
            --Sets up label
            local label = "+"
            --Sets up position
            local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.0018)
            local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
            --Sets up size
            local size = data.size / 2
            --Creates button and counts it
            self.createButton({
                label=label, click_function=funcName, function_owner=self,
                position=pos, height=size, width=size,
                font_size=size, scale=buttonScale,
                color=buttonColor, font_color=buttonColorBlack
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
                color=buttonColor, font_color=buttonColorBlack
            })
            spawnedButtonCount = spawnedButtonCount + 1
        end
    end

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
                position=data.pos, height=data.size*1.5, width=data.size*4.5,
                font_size=data.size, scale=buttonScale,
                color=color, font_color=buttonColorWhite
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
