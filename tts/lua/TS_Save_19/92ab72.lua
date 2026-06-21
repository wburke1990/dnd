--[[    Character Sheet Template    by: MrStump ]]
--[[    Written Code                by: NightStorm ]]

--Set this to true while editing and false when you have finished
disableSave = false

--Button Colors (r,g,b, values of 0-1)
    buttonColorRed = {0.94,0.125,0.121, 100}
    buttonColorYellow = {1,0.65,0, 100}
    buttonColorGreen = {0,0.75,0.33, 100}
    buttonColorBlue = {0.2,0.59,1, 100}
    buttonColorWhite = {1,1,1, 0.01}
    buttonColorBlack = {0,0,0, 100}
    --buttonFontColorDark = {1,1,1, 95}

--Button Color for Coins
    buttonColorCopper = {0.65,0.47,0.16, 100}
    buttonColorSilver = {0.65,0.59,0.571, 100}
    buttonColorGold = {0.886,0.69,0.356, 100}
    buttonColorElectrum = {0.48,0.55,0.59, 100}
    buttonColorPlatinum = {0.75,0.68,0.72, 100}

--Change scale of button (Avoid changing if possible)
    buttonScale = {0.1,0.1,0.1}

--This is the button placement information
defaultButtonData = {
    --Number only Textboxes
        numbox = {
            --Consumable 1
                {
                    pos       = {0.135,0.1,0.009},
                    rows      = 1,
                    width     = 350,
                    font_size = 250,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3
                },
            --Consumable 2
                {
                    pos       = {0.135,0.1,0.288},
                    rows      = 1,
                    width     = 350,
                    font_size = 250,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3
                },
            --Consumable 3
                {
                    pos       = {0.135,0.1,0.569},
                    rows      = 1,
                    width     = 350,
                    font_size = 250,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3
                },
            --Consumable 4
                {
                    pos       = {0.135,0.1,0.847},
                    rows      = 1,
                    width     = 350,
                    font_size = 250,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3
                },
            },

        coinbox = {
            --Copper
                {
                    pos       = {0.535,0.1,-0.644},
                    rows      = 1,
                    width     = 400,
                    font_size = 180,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorCopper,
                    alignment = 3
                },
            --Silver
                {
                    pos       = {0.535,0.1,-0.563},
                    rows      = 1,
                    width     = 400,
                    font_size = 180,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorSilver,
                    alignment = 3
                },
             --Electrum
                {
                    pos       = {0.535,0.1,-0.482},
                    rows      = 1,
                    width     = 400,
                    font_size = 180,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorElectrum,
                    alignment = 3
                },
            --Gold
                {
                    pos       = {0.535,0.1,-0.4},
                    rows      = 1,
                    width     = 400,
                    font_size = 180,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorGold,
                    alignment = 3
                },
            --Platinum
                {
                    pos       = {0.535,0.1,-0.318},
                    rows      = 1,
                    width     = 400,
                    font_size = 180,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorPlatinum,
                    alignment = 3
                },
            },

        weightbox = {
            --Number box for Weight carried counter
                {
                    pos       = {0.428,0.1,-0.849},
                    rows      = 1,
                    width     = 450,
                    font_size = 200,
                    label     = "",
                    value     = 0,
                    font_color=buttonColorBlack,
                    alignment = 3
                },
            },
    
    --Carry Capacity / Push, Drag, Life counter
        counter = {
            {
                pos = {0.647,0.1,-0.849},
                size   = 280,
                value  = 150,
                hideBG = true
            },
        },
    --Add checkboxes
        checkboxlock = {
            {
                pos   = {-0.416,0.1,-0.93},
                size  = 200,
                state = true
            },
            --End of checkboxes
        },

    --Total Gold Coin counter
        countertgp = {
            {   
                pos    = {0.565,0.1,-0.201},
                size   = 300,
                value  = 0,
                hideBG = false  
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
                    pos       = {-0.66,0.1,-0.801},
                    rows      = 1,
                    width     = 3400,
                    font_size = 250,
                    label     = "Character Name",
                    value     = "",
                    alignment = 3
                },
            --Gender textbox
                {
                    pos       = {-0.198,0.1,-0.875},
                    rows      = 1,
                    width     = 700,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Eyes textbox
                {
                    pos       = {-0.05,0.1,-0.875},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Age textbox
                {
                    pos       = {0.091,0.1,-0.875},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Height textbox
                {
                    pos       = {0.23,0.1,-0.875},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Faith textbox
                {
                    pos       = {-0.198,0.1,-0.785},
                    rows      = 1,
                    width     = 700,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Hair textbox
                {
                    pos       = {-0.05,0.1,-0.785},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Skin textbox
                {
                    pos       = {0.091,0.1,-0.785},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Weight textbox
                {
                    pos       = {0.23,0.1,-0.785},
                    rows      = 1,
                    width     = 600,
                    font_size = 130,
                    label     = "N/A",
                    value     = "",
                    alignment = 1
                },
            --Backstory & Personality textbox
                {
                    pos       = {-0.09,0.1,-0.43},
                    rows      = 17,
                    width     = 4150,
                    font_size = 130,
                    label     = "Empty",
                    value     = "",
                    alignment = 1
                },
            --Valuables textbox
                {
                    pos       = {0.877,0.1,-0.435},
                    rows      = 16,
                    width     = 1360,
                    font_size = 130,
                    label     = "Valuables",
                    value     = "",
                    alignment = 2   
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
    createCounter()
    createCounterTGP()
    createTextbox()
    createNumbox()
    createWeightbox()
    createCoinbox()
    
end


--Click functions for buttons

--Updates values for Counters
    function click_counter(tableIndex, buttonIndex, buttonIndex2, amount)
        if ref_buttonData.checkboxlock[1].state then
            ref_buttonData.counter[tableIndex].value = ref_buttonData.counter[tableIndex].value + amount

            self.editButton({index=buttonIndex, label= ((ref_buttonData.counter[tableIndex].value))})

            self.editButton({index=buttonIndex2, label= ((ref_buttonData.counter[tableIndex].value) * 2)})

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

--Updates saved value for numbox (numbers only)
    function click_numbox(i, color, value, selected, amount)
        if amount ~= 0 then
            if amount == -1 and tonumber(ref_buttonData.numbox[i].value) < 1 then
                --broadcastToColor("Value can't be negative.", color, "Red")
                self.editInput({index=i+10,value=ref_buttonData.numbox[i].value})
            else 
                ref_buttonData.numbox[i].value = tonumber(ref_buttonData.numbox[i].value) + amount
                self.editInput({index=i+10,value=ref_buttonData.numbox[i].value})
            end
        end
        if selected == false then
            if tonumber(value) ~= nil and (tonumber(value) < 100 and tonumber(value) > -1) then
                ref_buttonData.numbox[i].value = value
            else
                broadcastToColor("Enter a valid number.", color, "Red")
                Wait.time(function() self.editInput({index=i+10,value=ref_buttonData.numbox[i].value}) end,0.1)
            end
        end
        updateSave()
    end

--Updates saved value for weightbox (numbers only)
    function click_weightbox(i, color, value, selected, amount)
        if amount ~= 0 then
            --Amount can't be negative
            if amount == -1 and tonumber(ref_buttonData.weightbox[i].value) < 1 then
                self.editInput({index=i+14,value=ref_buttonData.weightbox[i].value})
            --Can't be over 1000
            elseif amount == 1 and tonumber(ref_buttonData.weightbox[i].value) >= 9999 then   
                self.editInput({index=i+14,value=ref_buttonData.weightbox[i].value})
            --Add or sub amount to value
            else     
                ref_buttonData.weightbox[i].value = tonumber(ref_buttonData.weightbox[i].value) + amount
                self.editInput({index=i+14,value=ref_buttonData.weightbox[i].value})
            end
        end
        if selected == false then
            --If over 1000 set to previous value
            if tonumber(ref_buttonData.weightbox[i].value) > 9999 then   
                self.editInput({index=i+14,value=ref_buttonData.weightbox[i].value})
            --Set Amount equal to what was typed
            elseif tonumber(value) ~= nil and (tonumber(value) <= 9999 and tonumber(value) > -1) then
                ref_buttonData.weightbox[i].value = value
            else
            --Value can't be letters, negative, or over 1000
                broadcastToColor("Enter a valid number.", color, "Red")
                Wait.time(function() self.editInput({index=i+14,value=ref_buttonData.weightbox[i].value}) end,0.1)
            end
        end
        updateSave()
    end

--Applies value to total total gold coin counter display
    function view_countertgp(tableIndex, buttonIndex)
                
        ref_buttonData.countertgp[tableIndex].value = math.floor( 
        (ref_buttonData.coinbox[1].value * 0.01 ) + 
        (ref_buttonData.coinbox[2].value * 0.12 ) +
        (ref_buttonData.coinbox[3].value * 0.5 ) +
        (ref_buttonData.coinbox[4].value ) +
        (ref_buttonData.coinbox[5].value * 10 ))

        self.editButton({index=buttonIndex, label=ref_buttonData.countertgp[tableIndex].value})

        updateSave()
    end

--Updates saved value for coinbox (numbers only)
    function click_coinbox(i, color, value, selected, amount)
        if amount ~= 0 then
            if amount == -1 and tonumber(ref_buttonData.coinbox[i].value) < 1 then
                broadcastToColor("Value can't be negative.", color, "Red")
                self.editInput({index=i+15,value=ref_buttonData.coinbox[i].value})
            else 
                ref_buttonData.coinbox[i].value = tonumber(ref_buttonData.coinbox[i].value) + amount
                self.editInput({index=i+15,value=ref_buttonData.coinbox[i].value})
            end
        end
        if selected == false then
            if tonumber(value) ~= nil and (tonumber(value) < 10000 and tonumber(value) > -1) then
                ref_buttonData.coinbox[i].value = value
            else
                broadcastToColor("Enter a valid number.", color, "Red")
                Wait.time(function() self.editInput({index=i+15,value=ref_buttonData.coinbox[i].value}) end,0.12)
            end
        end
        updateSave()
    end

--Dud function for if you have a background on a counter
function click_none() end

function printOut(col)    
    broadcastToColor("Unable to edit, Card is Locked", col, "Red")
end



--Button creation

--Carryoin Capacity ounters
function createCounter()
    for i, data in ipairs(ref_buttonData.counter) do
        --Sets up display
        local displayNumber = spawnedButtonCount

        --Sets up label
        local label = data.value


        --Sets height/width for display
        local size = data.size
        if data.hideBG == true then size = 0 end

        --Creates button Carrying Weight
        self.createButton({
            label=label, click_function="click_none", function_owner=self,
            position=data.pos, 
            height=size, width=size,
            font_size=data.size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
        spawnedButtonCount = spawnedButtonCount + 1

        local displayNumber2 = spawnedButtonCount
        --Sets up label
        local label = (data.value * 2)

        local pos = {data.pos[1] + 0.22, data.pos[2], data.pos[3]}
        --Spell Attack Bonus
        self.createButton({
            label=label, click_function="click_none", function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up position
        local pos = {data.pos[1], data.pos[2], data.pos[3] - 0.018}
        --Sets up size
        local size = data.size / 1.25

                
    --Sets up add 10
        local funcName = "counterAdd15"..i
        local func = function() click_counter(i, displayNumber, displayNumber2, 15) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Set up position
        local pos = {data.pos[1] + 0.075, data.pos[2], data.pos[3]}
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size/2, width=size/2,
            font_size=size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
        spawnedButtonCount = spawnedButtonCount + 1

    --Sets up subtract 10
        local funcName = "counterSub15"..i
        local func = function() click_counter(i, displayNumber, displayNumber2, -15) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "-"
        --Set up position
        local pos = {data.pos[1] - 0.075, data.pos[2], data.pos[3]}
            --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size/2, width=size/2,
            font_size=size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Lock Button
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
            color          = buttonColorWhite,
            font_color     = buttonColorBlack,
            value          = data.value,
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Consumable Counters
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
            scale          = {0.15,0.15,0.15},
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
        --Sets up position
        local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)/1.8
        local pos = {data.pos[1] + 0.025, data.pos[2], data.pos[3] + (offsetDistance)}
        --Sets up size
        local size = (data.font_size / 1.3)
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
        local pos = {data.pos[1] - 0.025, data.pos[2], data.pos[3] + (offsetDistance)}
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

--Create Coin Counters
function createCounterTGP()
    for i, data in ipairs(ref_buttonData.countertgp) do
        --Sets up display
        local displayNumber = spawnedButtonCount

        --Sets up to add total
        local funcName = "countertgpAdd"..i
        local func = function() view_countertgp(i, displayNumber) end
        self.setVar(funcName, func)
        
        --Sets up label
        local label = data.value

        --Sets height/width for display
        local size = data.size
        if data.hideBG == true then size = 0 end
        
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=data.pos, height=380, width=700,
            font_size=data.size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorGold
        })
        spawnedButtonCount = spawnedButtonCount + 1
    end
end

--Coin Currency Counters
function createCoinbox()
    for i, data in ipairs(ref_buttonData.coinbox) do
        --Sets up reference function
        local funcName = "coinbox"..i
        local func = function(_,col,val,sel,amt) click_coinbox(i,col,val,sel,0) end
        self.setVar(funcName, func)

        local widthSize = (data.font_size*1.7)
        self.createInput({
            input_function = funcName,
            function_owner = self,
            label          = data.label,
            alignment      = data.alignment,
            position       = data.pos,
            scale          = {0.15,0.15,0.15},
            width          = data.width,
            height         = data.font_size*1.2,
            font_size      = data.font_size,
            color          = buttonColorWhite,
            font_color     = data.font_color,
            value          = data.value,
        })
        --Sets up add 1
        local funcName = "coinboxAdd"..i
        local func = function() click_coinbox(i,col,val,sel,1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Sets up position
        local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)
        local pos = {data.pos[1] + 0.155, data.pos[2], data.pos[3]}
        --Sets up size
        local size = (data.font_size / 1.3)
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.font_size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })

        --Sets up subtract 1
        local funcName = "coinboxSub"..i
        local func = function() click_coinbox(i,col,val,sel,-1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "-"
        --Set up position
        local pos = {data.pos[1] + 0.115, data.pos[2], data.pos[3]}
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.font_size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
    end
end

--Weight Carried Counter
function createWeightbox()
    for i, data in ipairs(ref_buttonData.weightbox) do
        --Sets up display
        local btn = spawnedButtonCount
        --Sets up reference function
        local funcName = "weightbox"..i
        local func = function(_,col,val,sel,amt) click_weightbox(i,col,val,sel,0) end
        self.setVar(funcName, func)

        local widthSize = (data.font_size*1.7)
        self.createInput({
            input_function = funcName,
            function_owner = self,
            label          = data.label,
            alignment      = data.alignment,
            position       = data.pos,
            scale          = {0.15,0.15,0.15},
            width          = data.width,
            height         = data.font_size*1.2,
            font_size      = data.font_size,
            color          = buttonColorWhite,
            font_color     = data.font_color,
            value          = data.value,
        })

        --Sets up add 1
        local funcName = "weightboxAdd"..i
        local func = function() click_weightbox(i,col,val,sel,1) end
        self.setVar(funcName, func)
        --Sets up label
        local label = "+"
        --Sets up position
        local offsetDistance = (widthSize/2 + widthSize/4) * (buttonScale[1] * 0.003)
        local pos = {data.pos[1] + offsetDistance, data.pos[2], data.pos[3]}
        --Sets up size
        local size = (data.font_size / 1.3)
        --Creates button and counts it
        self.createButton({
            label=label, click_function=funcName, function_owner=self,
            position=pos, height=size, width=size,
            font_size=data.font_size, scale=buttonScale,
            color=buttonColorWhite, font_color=buttonColorBlack
        })
        spawnedButtonCount = spawnedButtonCount + 1

        --Sets up subtract 1
        local funcName = "weightboxSub"..i
        local func = function() click_weightbox(i,col,val,sel,-1) end
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
