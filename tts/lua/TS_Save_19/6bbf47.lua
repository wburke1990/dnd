disableSave = false
--Remember to set this to false once you are done making changes
--Then, after you save & apply it, save your game too

--Color information for button text (r,g,b, values of 0-1)
buttonFontColor = {0,0,0, 100}
buttonFontColorTitle = {0.4,0.15,0.1, 100}
buttonColorWhite = {1,1,1,100}
buttonColorRed = {1,0,0,100}
buttonColorGreen = {0.2,0.8,0.5,100}
--Color information for button background
buttonColor = {1,1,1, 0.01}
--Change scale of button (Avoid changing if possible)
buttonScale = {0.1,0.1,0.1}

--This is the button placement information
defaultButtonData = {
    checkbox = {
        --[[
        pos   = the position (pasted from the helper tool)
        size  = height/width/font_size for checkbox
        state = default starting value for checkbox (true=checked, false=not)
        ]]
        --Acid checkbox
        {
            pos   = {-0.913,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Cold checkbox
        {
            pos   = {-0.702,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Fire checkbox
        {
            pos   = {-0.5,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Force checkbox
        {
            pos   = {-0.284,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Electric checkbox
        {
            pos   = {-0.069,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Necrotic checkbox
        {
            pos   = {0.146,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Poison checkbox
        {
            pos   = {0.362,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Psychic checkbox
        {
            pos   = {0.578,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Radiant checkbox
        {
            pos   = {0.79,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Thunder checkbox
        {
            pos   = {0.999,0.4,0.062},
            size  = 425,
            value = 0,
            state = false
        },
        --Bludgeoning checkbox
        {
            pos   = {-0.913,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --Piercing checkbox
        {
            pos   = {-0.702,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --Slashing checkbox
        {
            pos   = {-0.5,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --Non-Silver checkbox
        {
            pos   = {-0.284,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --NM Bludgeoning checkbox
        {
            pos   = {-0.069,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --NM Piercing checkbox
        {
            pos   = {0.146,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --NM Slashing checkbox
        {
            pos   = {0.362,0.4,0.173},
            size  = 425,
            value = 0,
            state = false
        },
        --End of checkboxes
    },
    checkboxcondition = {
        --Blinded checkbox
        {
            pos   = {-0.915,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Charmed checkbox
        {
            pos   = {-0.708,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Deafend checkbox
        {
            pos   = {-0.5,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Dying checkbox
        {
            pos   = {-0.284,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Frightened checkbox
        {
            pos   = {-0.069,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Grappled checkbox
        {
            pos   = {0.146,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Incapacitated checkbox
        {
            pos   = {0.362,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Invisible checkbox
        {
            pos   = {0.578,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Paralyzed checkbox
        {
            pos   = {0.79,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Petrified checkbox
        {
            pos   = {0.999,0.4,-0.25},
            size  = 425,
            value = 0,
            state = false
        },
        --Poisoned checkbox
        {
            pos   = {-0.913,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Prone checkbox
        {
            pos   = {-0.702,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Restrained checkbox
        {
            pos   = {-0.5,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Slowed checkbox
        {
            pos   = {-0.284,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Stunned checkbox
        {
            pos   = {-0.069,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Unconcious checkbox
        {
            pos   = {0.146,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --Exhaustion checkbox
        {
            pos   = {0.362,0.4,-0.142},
            size  = 425,
            value = 0,
            state = false
        },
        --End of checkboxes
    },
    --Add counters that have a + and - button
    counter = {
        --[[
        pos    = the position (pasted from the helper tool)
        size   = height/width/font_size for counter
        value  = default starting value for counter
        hideBG = if background of counter is hidden (true=hidden, false=not)
        ]]
        --AC counter
        {
            pos    = {-0.905,0.4,-1.04},
            size   = 650,
            value  = 10,
            hideBG = true
        },
        --End of counters
    },
    --Add checkboxes
    checkboxlock = {
        {
            pos   = {0.955,0.4,-1.28},
            size  = 250,
            state = true
        },
        --End of checkboxes
    },
    counterhp = {
    --Max HP counter

        {
            pos    = {-0.907,0.4,-0.663},
            size   = 650,
            value  = 0,
            color = buttonFontColor,
            hideBG = true
        },
        --Base Speed
        {
            pos    = {0.934,0.4,-1.117},
            size   = 500,
            value  = 0,
            color = buttonFontColor,
            hideBG = true
        },
        --Custom Speed 1
        {
            pos    = {0.934,0.4,-0.914},
            size   = 500,
            value  = 0,
            color = buttonFontColor,
            hideBG = true
        },
        --Custom Speed 2
        {
            pos    = {0.934,0.4,-0.71},
            size   = 500,
            value  = 0,
            color = buttonFontColor,
            hideBG = true
        },
        --Custom Speed 3
        {
            pos    = {0.934,0.4,-0.51},
            size   = 500,
            value  = 0,
            color = buttonFontColor,
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
        --Custom Speed 1
        {
            pos       = {0.936,0.4,-0.982},
            rows      = 1,
            width     = 1200,
            font_size = 200,
            label     = "Custom",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --Custom Speed 2
        {
            pos       = {0.937,0.4,-0.78},
            rows      = 1,
            width     = 1200,
            font_size = 200,
            label     = "Custom",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --Custom Speed 3
        {
            pos       = {0.937,0.4,-0.578},
            rows      = 1,
            width     = 1200,
            font_size = 200,
            label     = "Custom",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --XP Text
        {
            pos       = {-0.943,0.4,-1.253},
            rows      = 1,
            width     = 1200,
            font_size = 275,
            label     = "(-) XP",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --AC Text
        {
            pos       = {-0.907,0.4,-0.842},
            rows      = 1,
            width     = 1600,
            font_size = 200,
            label     = "Armor Type",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --HP Text
        {
            pos       = {-0.907,0.4,-0.464},
            rows      = 1,
            width     = 1600,
            font_size = 200,
            label     = "Hit Die",
            value     = "",
            alignment = 3,
            color = buttonFontColor
        },
        --Alignment Text
        {
            pos       = {0.02,0.4,-1.287},
            rows      = 1,
            width     = 7900,
            font_size = 275,
            label     = "Size, Monster Type, Alignment                         Proficency Bonus + X",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --Stats Text
        {
            pos       = {0.028,0.4,-0.979},
            rows      = 8,
            width     = 7500,
            font_size = 300,
            label     = "Description",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --Passive Text
        {
            pos       = {0.002,0.4,0.44},
            rows      = 6,
            width     = 10000,
            font_size = 300,
            label     = "Description",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --Actions Title
        {
            pos       = {0.002,0.4,0.66},
            rows      = 1,
            width     = 10000,
            font_size = 325,
            label     = "Actions",
            value     = "",
            alignment = 2,
            color = buttonFontColorTitle
        },
        --Main Actions Text
        {
            pos       = {0.002,0.4,0.93},
            rows      = 7,
            width     = 10000,
            font_size = 300,
            label     = "Description",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --Bonus Title
        {
            pos       = {0.002,0.4,1.19},
            rows      = 1,
            width     = 10000,
            font_size = 325,
            label     = "Bonus Actions / Reactions",
            value     = "",
            alignment = 2,
            color = buttonFontColorTitle
        },
        --Bonus Actions Text
        {
            pos       = {0.002,0.4,1.38},
            rows      = 4,
            width     = 10000,
            font_size = 300,
            label     = "Descripton",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --Title
        {
            pos       = {-0.965,0.4,-1.41},
            rows      = 1,
            width     = 800,
            font_size = 450,
            label     = "CR",
            value     = "",
            alignment = 2,
            color = buttonFontColor
        },
        --CR
        {
            pos       = {-0.345,0.4,-1.406},
            rows      = 1,
            width     = 5300,
            font_size = 400,
            label     = "Title",
            value     = "",
            alignment = 2,
            color = buttonFontColorTitle
        },
        --Homebrew Class
        {
            pos       = {0.64,0.4,-1.407},
            rows      = 1,
            width     = 3800,
            font_size = 400,
            label     = "Homebrew Origin",
            value     = "",
            alignment = 3,
            color = buttonColorWhite
        },

        --End of textboxes
    },
     --THE CHILDREN OF THE RULER
        strcounterscore = {
            --STR Score counter
            {
                pos    = {-0.607,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            },   
        },
        dexcounterscore = {
            --DEX Score counter
            {
                pos    = {-0.349,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            }, 
        },

        concounterscore = {
            --CON Score counter
            {
                pos    = {-0.094,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            },
        },

        intcounterscore = {
            --INT Score counter
            {
                pos    = {0.163,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            },
        },

        wiscounterscore = {
            --WIS Score counter
            {           
                pos    = {0.423,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            },
        },

        chacounterscore = {
            --CHA Score counter
            {
                pos    = {0.682,0.4,-0.425},
                size   = 400,
                value  = 10,
                hideBG = true
            },
        }
}

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
    createCheckbox()
    createCheckboxCondition()
    createCounter()
    createCheckboxLock()
    createTextbox()
    createCounterHP()
        createStrScoreCounter()
        createDexScoreCounter()
        createConScoreCounter()
        createIntScoreCounter()
        createWisScoreCounter()
        createChaScoreCounter()
end



--Click functions for buttons

--Applies value to given counter display
function click_counter(tableIndex, buttonIndex, amount)
    if ref_buttonData.checkboxlock[1].state then
        ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount
        self.editButton({index=buttonIndex, label=ref_buttonData.counter[tableIndex].value})
        updateSave()
    end
end

--Creates checkbox for damage types
function click_checkbox(tableIndex, buttonIndex, amount)
    if ref_buttonData.checkboxlock[1].state then
        if ref_buttonData.checkbox[tableIndex].state == true and ref_buttonData.checkbox[tableIndex].value == 3 then
                ref_buttonData.checkbox[tableIndex].state = false
                ref_buttonData.checkbox[tableIndex].value = 0
                    self.editButton({index=buttonIndex, label=""})
        
        elseif ref_buttonData.checkbox[tableIndex].state == true and ref_buttonData.checkbox[tableIndex].value == 2 then
                ref_buttonData.checkbox[tableIndex].state = true
                ref_buttonData.checkbox[tableIndex].value = 3
                    self.editButton({index=buttonIndex, label=string.char(86)})
        
        elseif ref_buttonData.checkbox[tableIndex].state == true and ref_buttonData.checkbox[tableIndex].value == 1 then
                ref_buttonData.checkbox[tableIndex].state = true
                ref_buttonData.checkbox[tableIndex].value = 2
                    self.editButton({index=buttonIndex, label=string.char(82)})
        
        else 
                ref_buttonData.checkbox[tableIndex].value = 1
                    ref_buttonData.checkbox[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(73)})
        end      
    updateSave()
    end
end

--Creates checkbox for condition immunities
function click_checkbox_condition(tableIndex, buttonIndex, amount)
    if ref_buttonData.checkboxlock[1].state then
        if ref_buttonData.checkboxcondition[tableIndex].state == true and ref_buttonData.checkboxcondition[tableIndex].value == 1 then
                ref_buttonData.checkboxcondition[tableIndex].state = false
                ref_buttonData.checkboxcondition[tableIndex].value = 0
                    self.editButton({index=buttonIndex, label=""})
        else 
                ref_buttonData.checkboxcondition[tableIndex].value = 1
                    ref_buttonData.checkboxcondition[tableIndex].state = true
                    self.editButton({index=buttonIndex, label=string.char(73)})
        end      
    updateSave()
    end
end

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

--Applies value to given counterhp display
function click_counterhp(tableIndex, buttonIndex, amount)
    ref_buttonData.counterhp[tableIndex].value = ref_buttonData.counterhp[tableIndex].value + amount
        self.editButton({index=buttonIndex, label=ref_buttonData.counterhp[tableIndex].value})
        updateSave()
end

--Dud function for if you have a background on a counter
function click_none() end

function printOut(col)    
    broadcastToColor("Unable to edit, Card is Locked", col, "Red")
end

    --============================
    --Ability Counters
    --============================
        --Strength Ability Counter
            function click_strcounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.strcounterscore[tableIndex].value = ref_buttonData.strcounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.strcounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.strcounterscore[tableIndex].value

                    ref_buttonData.strcounterscore[tableIndex].value = math.floor(((ref_buttonData.strcounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.strcounterscore[tableIndex].value })

                    ref_buttonData.strcounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end

        --Dexterity Ability Counter
            function click_dexcounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.dexcounterscore[tableIndex].value = ref_buttonData.dexcounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.dexcounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.dexcounterscore[tableIndex].value

                    ref_buttonData.dexcounterscore[tableIndex].value = math.floor(((ref_buttonData.dexcounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.dexcounterscore[tableIndex].value })

                    ref_buttonData.dexcounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end

        --Constitution Ability Counter
            function click_concounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.concounterscore[tableIndex].value = ref_buttonData.concounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.concounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.concounterscore[tableIndex].value

                    ref_buttonData.concounterscore[tableIndex].value = math.floor(((ref_buttonData.concounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.concounterscore[tableIndex].value })

                    ref_buttonData.concounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end

        --Intelligence Ability Counter
            function click_intcounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.intcounterscore[tableIndex].value = ref_buttonData.intcounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.intcounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.intcounterscore[tableIndex].value

                    ref_buttonData.intcounterscore[tableIndex].value = math.floor(((ref_buttonData.intcounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.intcounterscore[tableIndex].value })

                    ref_buttonData.intcounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end

        --Wisdom Ability Counter
            function click_wiscounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.wiscounterscore[tableIndex].value = ref_buttonData.wiscounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.wiscounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.wiscounterscore[tableIndex].value

                    ref_buttonData.wiscounterscore[tableIndex].value = math.floor(((ref_buttonData.wiscounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.wiscounterscore[tableIndex].value })

                    ref_buttonData.wiscounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end

        --Charisma Ability Counter
            function click_chacounterscore(tableIndex, buttonIndex, buttonIndex2, amount)
                if ref_buttonData.checkboxlock[1].state then
                    ref_buttonData.chacounterscore[tableIndex].value = ref_buttonData.chacounterscore[tableIndex].value + amount
                    self.editButton({index=buttonIndex, label=ref_buttonData.chacounterscore[tableIndex].value})

                    local saveScore = ref_buttonData.chacounterscore[tableIndex].value

                    ref_buttonData.chacounterscore[tableIndex].value = math.floor(((ref_buttonData.chacounterscore[tableIndex].value - 10) / 2))

                    self.editButton({index=buttonIndex2, label=ref_buttonData.chacounterscore[tableIndex].value })

                    ref_buttonData.chacounterscore[tableIndex].value = saveScore

                    updateSave()
                end
            end



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
        if data.state==true and data.value == 1 then label=string.char(73)
        elseif  data.state==true and data.value == 2 then label=string.char(82)
        elseif  data.state==true and data.value == 3 then label=string.char(86)
        else    label="" end
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=data.pos, height=data.size, width=data.size,
            font_size=data.size, scale=buttonScale,
            color=buttonFontColor, font_color=buttonColorWhite
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Makes checkboxes
function createCheckboxCondition()
    for i, data in ipairs(ref_buttonData.checkboxcondition) do
        --Sets up reference function
        local buttonNumber = spawnedButtonCount
        local funcName = "checkboxcondition"..i
        local func = function() click_checkbox_condition(i, buttonNumber) end
        self.setVar(funcName, func)
        --Sets up label
        local label = ""
        if data.state==true and data.value == 1 then label=string.char(73)
        else    label="" end
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=data.pos, height=data.size, width=data.size,
            font_size=data.size, scale=buttonScale,
            color=buttonFontColor, font_color=buttonColorWhite
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Makes counters
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
            color=buttonColor, font_color=buttonFontColor
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up add 1
        local funcName = "counterAdd"..i
        local func = function() click_counter(i, displayNumber, 1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Sets up position
        local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.002)
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

--Makes checkboxes
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
            color          = buttonColor,
            font_color     = data.color,
            value          = data.value,
        })
    end
end

function createCounterHP()
            for i, data in ipairs(ref_buttonData.counterhp) do
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
                    color=buttonColor, font_color=data.color
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "counterhpAdd"..i
                local func = function() click_counterhp(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+1"
                --Sets up size
                local size = data.size / 2
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1] + 0.07, data.pos[2], data.pos[3]- offsetDistance * 0.5}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 1
                local funcName = "counterhpSub"..i
                local func = function() click_counterhp(i, displayNumber, -1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-1"
                --Set up position
                local pos = {data.pos[1] - 0.07, data.pos[2], data.pos[3]- offsetDistance * 0.5}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
                
                --Sets up add 5 
                local funcName = "counterhpAdd5"..i
                local func = function() click_counterhp(i, displayNumber, 5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+5"
                --Set up position
                local pos = {data.pos[1] + 0.07, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 5
                local funcName = "counterhpSub5"..i
                local func = function() click_counterhp(i, displayNumber, -5) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-5"
                --Set up position
                local pos = {data.pos[1] - 0.07, data.pos[2], data.pos[3]}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 10
                local funcName = "counterhpAdd10"..i
                local func = function() click_counterhp(i, displayNumber, 10) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+10"
                --Sets up position
                local pos = {data.pos[1] + 0.07, data.pos[2], data.pos[3] + offsetDistance * 0.5}

                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up subtract 10
                local funcName = "counterhpSub10"..i
                local func = function() click_counterhp(i, displayNumber, -10) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-10"
                --Sets up position
                local pos = {data.pos[1] - 0.07, data.pos[2], data.pos[3] + offsetDistance * 0.5}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
            end
        end

        --Score modifier counters
        function createStrScoreCounter()
            for i, data in ipairs(ref_buttonData.strcounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))

                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "strcounterscoreAdd"..i
                local func = function() click_strcounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "strcounterscoreSub"..i
                local func = function() click_strcounterscore(i, displayNumber, displayNumber2, -1) end
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

        function createDexScoreCounter()
            for i, data in ipairs(ref_buttonData.dexcounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))

                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "dexcounterscoreAdd"..i
                local func = function() click_dexcounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "dexcounterscoreSub"..i
                local func = function() click_dexcounterscore(i, displayNumber, displayNumber2, -1) end
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

        function createConScoreCounter()
            for i, data in ipairs(ref_buttonData.concounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))

                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "concounterscoreAdd"..i
                local func = function() click_concounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "concounterscoreSub"..i
                local func = function() click_concounterscore(i, displayNumber, displayNumber2, -1) end
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

        function createIntScoreCounter()
            for i, data in ipairs(ref_buttonData.intcounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))

                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "intcounterscoreAdd"..i
                local func = function() click_intcounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "intcounterscoreSub"..i
                local func = function() click_intcounterscore(i, displayNumber, displayNumber2, -1) end
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

        function createWisScoreCounter()
            for i, data in ipairs(ref_buttonData.wiscounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))

                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up add 1
                local funcName = "wiscounterscoreAdd"..i
                local func = function() click_wiscounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "wiscounterscoreSub"..i
                local func = function() click_wiscounterscore(i, displayNumber, displayNumber2, -1) end
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

        function createChaScoreCounter()
            for i, data in ipairs(ref_buttonData.chacounterscore) do
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
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                local displayNumber2 = spawnedButtonCount
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/7) * (buttonScale[1] * 0.0024)
                --Sets up label
                local label = math.floor(((data.value - 10) / 2))
                self.createButton({
                    label=label, click_function="click_none", function_owner=self,
                    position={data.pos[1] + 0.002, data.pos[2], data.pos[3] - offsetDistance*2.2}, 
                    height=size, width=size,
                    font_size=data.size*1.5, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up add 1
                local funcName = "chacounterscoreAdd"..i
                local func = function() click_chacounterscore(i, displayNumber, displayNumber2, 1) end
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
                local funcName = "chacounterscoreSub"..i
                local func = function() click_chacounterscore(i, displayNumber, displayNumber2, -1) end
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