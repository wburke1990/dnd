--[[    Character Sheet Template    by: MrStump ]]
--[[    Written Code                by: NightStorm ]]

--Set to true when editing
    disableSave = false
--Remember to set this to false once you are done making changes
--Then, after you save & apply it, save your game too

--Button Colors (r,g,b, values of 0-1)
    buttonColorRed = {0.94,0.125,0.121, 100}
    buttonColorYellow = {1,0.65,0, 100}
    buttonColorGreen = {0,0.75,0.33, 100}
    buttonColorBlue = {0.2,0.59,1, 100}
    buttonColorWhite = {1,1,1, 0.01}
    --buttonColorLight = {0,0,0, 100}
    buttonColorBlack = {1,1,1, 95}

--Change scale of button (Avoid changing if possible)
    buttonScale = {0.11,0.11,0.11}

--This is the button placement information
defaultButtonData = {
--Add Checkbox
    checkbox = {
    --[[    CHECKBOX INFORMATION
            pos   = the position (pasted from the helper tool)
            size  = height/width/font_size for checkbox
            state = default starting value for checkbox (true=checked, false=not) ]]
            {   pos   = {-0.524,0.1,-0.724},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,-0.515},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,-0.332},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,-0.146},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,0.164},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,0.518},
                size  = 400,
                state = false },
            {   pos   = {-0.524,0.1,0.78},
                size  = 400,
                state = false },
    }
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

--Call Functions
    spawnedButtonCount = 0
    --Checkbox
        createCheckbox()
    end

--============================
--Click functions for buttons
--============================
    
--Click function for Checkboxes
    function click_checkbox(tableIndex, buttonIndex)
            if ref_buttonData.checkbox[tableIndex].state == true then
                ref_buttonData.checkbox[tableIndex].state = false
                self.editButton({index=buttonIndex, label=""})
            else
                ref_buttonData.checkbox[tableIndex].state = true
                self.editButton({index=buttonIndex, label=string.char(10004)})
            end
        updateSave()
    end

    --Dud function for background on a counter
        function click_none() end

--Button creation
    --Default Checkboxes
        --Makes Checkboxes
            function createCheckbox()
                for i, data in ipairs(ref_buttonData.checkbox) do
                    --Sets up reference function
                    local buttonNumber = spawnedButtonCount
                    local funcName = "checkbox"..i
                    local func = function() click_checkbox(i, buttonNumber) end
                    self.setVar(funcName, func)
                    --Sets up label
                    local label = ""
                    if data.state==true then label=string.char(10004) end
                    --Creates button and counts it
                    self.createButton({
                        label=label, click_function=funcName, function_owner=self,
                        position=data.pos, height=data.size, width=data.size,
                        font_size=data.size, scale=buttonScale,
                        color=buttonColorWhite, font_color=buttonColorGreen
                    })
                    spawnedButtonCount = spawnedButtonCount + 1
                end
            end