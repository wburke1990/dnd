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
buttonScale = {0.1,0.1,0.1}

--This is the button placement information
defaultButtonData = {
    --Add hp counters
        counterhp = {
            --Creature Space L1 #1
                {
                    pos    = {-0.98,0.1,-0.874},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #2
                {
                    pos    = {-0.779,0.1,-0.871},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #3
                {
                    pos    = {-0.573,0.1,-0.873},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #4
                {
                    pos    = {-0.98,0.1,-0.663},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #5
                {
                    pos    = {-0.776,0.1,-0.664},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #6
                {
                    pos    = {-0.572,0.1,-0.665},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #7
                {
                    pos    = {-0.977,0.1,-0.451},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #8
                {
                    pos    = {-0.774,0.1,-0.453},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L1 #9
                {
                    pos    = {-0.57,0.1,-0.453},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
            --Creature Space L2 #1
                {
                    pos    = {-0.981,0.1,-0.213},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #2
                {
                    pos    = {-0.776,0.1,-0.214},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #3
                {
                    pos    = {-0.57,0.1,-0.212},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #4
                {
                    pos    = {-0.98,0.1,-0.007},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #5
                {
                    pos    = {-0.776,0.1,-0.005},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #6
                {
                    pos    = {-0.57,0.1,-0.006},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #7
                {
                    pos    = {-0.978,0.1,0.206},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #8
                {
                    pos    = {-0.774,0.1,0.204},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L2 #9
                {
                    pos    = {-0.569,0.1,0.205},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
            --Creature Space L3 #1
                {
                    pos    = {-0.982,0.1,0.447},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #2
                {
                    pos    = {-0.777,0.1,0.447},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #3
                {
                    pos    = {-0.571,0.1,0.446},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #4
                {
                    pos    = {-0.98,0.1,0.654},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #5
                {
                    pos    = {-0.778,0.1,0.653},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #6
                {
                    pos    = {-0.571,0.1,0.655},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #7
                {
                    pos    = {-0.979,0.1,0.868},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #8
                {
                    pos    = {-0.775,0.1,0.868},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space L3 #9
                {
                    pos    = {-0.568,0.1,0.868},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
            --Creature Space M1 #1
                {
                    pos    = {0.159,0.1,-0.872},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M1 #2
                {
                    pos    = {0.376,0.1,-0.874},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M1 #3
                {
                    pos    = {0.159,0.1,-0.667},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M1 #4
                {
                    pos    = {0.377,0.1,-0.667},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M1 #5
                {
                    pos    = {0.16,0.1,-0.454},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M1 #6
                {
                    pos    = {0.381,0.1,-0.454},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
            --Creature Space M2 #1
                {
                    pos    = {0.159,0.1,-0.213},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M2 #2
                {
                    pos    = {0.378,0.1,-0.213},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M2 #3
                {
                    pos    = {0.159,0.1,-0.008},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M2 #4
                {
                    pos    = {0.379,0.1,-0.009},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M2 #5
                {
                    pos    = {0.162,0.1,0.207},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M2 #6
                {
                    pos    = {0.381,0.1,0.207},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #1
                {
                    pos    = {0.157,0.1,0.447},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #2
                {
                    pos    = {0.379,0.1,0.445},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #3
                {
                    pos    = {0.159,0.1,0.654},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #4
                {
                    pos    = {0.379,0.1,0.652},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #5
                {
                    pos    = {0.16,0.1,0.867},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space M3 #6
                {
                    pos    = {0.38,0.1,0.865},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
            --Creature Space R1 #1
                {
                    pos    = {1.512,0.1,-0.868},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R1 #2
                {
                    pos    = {1.512,0.1,-0.664},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R1 #3
                {
                    pos    = {1.512,0.1,-0.449},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R2 #1
                {
                    pos    = {1.511,0.1,-0.212},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R2 #2
                {
                    pos    = {1.511,0.1,-0.004},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R2 #3
                {
                    pos    = {1.513,0.1,0.209},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R3 #1
                {
                    pos    = {1.511,0.1,0.449},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R3 #2
                {
                    pos    = {1.51,0.1,0.657},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
                --Creature Space R3 #3
                {
                    pos    = {1.514,0.1,0.87},
                    size   = 300,
                    value  = 0,
                    color = buttonFontColorRed,
                    hideBG = true
                },
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
        createCounterHP()
    end

--Click functions for buttons


    --Applies value to given counterhp display
        function click_counterhp(tableIndex, buttonIndex, amount)
            ref_buttonData.counterhp[tableIndex].value = ref_buttonData.counterhp[tableIndex].value + amount
            if amount == 0 then
                ref_buttonData.counterhp[tableIndex].value = 0
            end
            self.editButton({index=buttonIndex, label=ref_buttonData.counterhp[tableIndex].value})
            updateSave()
        end

    --Dud function for if you have a background on a counter
    function click_none() end

--Button creation

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
                    position=data.pos, height=350, width=400,
                    font_size=data.size, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorRed
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up add 1
                local funcName = "counterhpAdd"..i
                local func = function() click_counterhp(i, displayNumber, 1) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+1"
                --Sets up position
                local offsetDistance = (data.size/2 + data.size/4) * (buttonScale[1] * 0.002)
                local pos = {data.pos[1]-0.045, data.pos[2], data.pos[3]+0.07}
                --Sets up size
                local size = data.size / 1.25
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
                local pos = {data.pos[1]-0.045, data.pos[2], data.pos[3]+0.1}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1
                
            --Sets up add 5 
                local funcName = "counterhpAdd10"..i
                local func = function() click_counterhp(i, displayNumber, 10) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+10"
                --Set up position
                local pos = {data.pos[1], data.pos[2], data.pos[3]+0.07}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up subtract 5
                local funcName = "counterhpSub10"..i
                local func = function() click_counterhp(i, displayNumber, -10) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-10"
                --Set up position
                local pos = {data.pos[1], data.pos[2], data.pos[3]+0.1}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up add 10
                local funcName = "counterhpAdd100"..i
                local func = function() click_counterhp(i, displayNumber, 100) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "+100"
                --Sets up position
                local pos = {data.pos[1]+0.045, data.pos[2], data.pos[3]+0.07}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

            --Sets up subtract 10
                local funcName = "counterhpSub100"..i
                local func = function() click_counterhp(i, displayNumber, -100) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "-100"
                --Sets up position
                local pos = {data.pos[1]+0.045, data.pos[2], data.pos[3]+0.1}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColor
                })
                spawnedButtonCount = spawnedButtonCount + 1

                --Sets up clear button
                local funcName = "counterhpClear"..i
                local func = function() click_counterhp(i, displayNumber, 0) end
                self.setVar(funcName, func)
                --Sets up label
                local label = "Clear"
                --Sets up position
                local pos = {data.pos[1], data.pos[2], data.pos[3]-0.07}
                --Creates button and counts it
                self.createButton({
                    label=label, click_function=funcName, function_owner=self,
                    position=pos, height=size, width=size,
                    font_size=size/2, scale=buttonScale,
                    color=buttonColor, font_color=buttonFontColorYellow
                })
                spawnedButtonCount = spawnedButtonCount + 1
                
            end
        end

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
