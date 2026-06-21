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
buttonScale = {0.06,0.1,0.1}

--This is the button placement information
defaultButtonData = {
    --Add checkboxes
    checkboxlock = {
        {
            pos   = {0.86,0.929,1.361},
            size  = 600,
            state = true,
            color = buttonColorGreen
        },
        --End of checkboxes
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
        --Title textbox
            {
                pos       = {-0.585,0.929,-1.408},
                rows      = 1,
                width     = 6500,
                font_size = 550,
                label     = "Title",
                value     = "",
                alignment = 2
            },
        --Description textbox
            {
                pos       = {-0.54,0.929,0.1},
                rows      = 24,
                width     = 8000,
                font_size = 550,
                label     = "Empty",
                value     = "",
                alignment = 2
            },
        --Description textbox 2
            {
                pos       = {0.535,0.929,-0.1},
                rows      = 24,
                width     = 8500,
                font_size = 550,
                label     = "Empty",
                value     = "",
                alignment = 2
            },

        --End of textboxes
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
    createCheckboxLock()
    createTextbox()
end



--Click functions for buttons



--Checks or unchecks the given box
function click_checkbox(tableIndex, buttonIndex)
    if ref_buttonData.checkboxlock[1].state then
        if ref_buttonData.checkbox[tableIndex].state == true then
            ref_buttonData.checkbox[tableIndex].state = false
            self.editButton({index=buttonIndex, label=""})
        else
            ref_buttonData.checkbox[tableIndex].state = true
            self.editButton({index=buttonIndex, label=string.char(10008)})
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

--Dud function for if you have a background on a counter
function click_none() end

function printOut(col)    
    broadcastToColor("Unable to edit, Card is Locked", col, "Red")
end


--Button creation



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
            font_color     = buttonFontColor,
            value          = data.value,
        })
    end
end