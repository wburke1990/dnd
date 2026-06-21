disableSave = false
buttonFontColor = {0,0,0}
buttonColor = {0.91,0.84,0.84}
buttonScale = {0.4,0.4,0.4}
defaultButtonData = {
    textbox = {
        --Year
        {
            pos       = {-0.59,0.2,-0.761},
            rows      = 1,
            width     = 500,
            font_size = 125,
            label     = "Year",
            value     = "",
            alignment = 3,
        },
        --Temperature Low
        {
            pos       = {0.588,0.2,-0.726},
            rows      = 1,
            width     = 180,
            font_size = 125,
            label     = "00",
            value     = "",
            alignment = 3,
        },
        --Temperature High
        {
            pos       = {0.762,0.2,-0.726},
            rows      = 1,
            width     = 180,
            font_size = 125,
            label     = "00",
            value     = "",
            alignment = 3,
        },
        --Wind Speed
        {
            pos       = {0.76,0.2,0.306},
            rows      = 1,
            width     = 180,
            font_size = 125,
            label     = "00",
            value     = "",
            alignment = 3,
        },
    }
}
function updateSave()
    saved_data = JSON.encode(ref_buttonData)
    if disableSave==true then saved_data="" end
    self.script_state = saved_data
end
function onload(saved_data)
    if disableSave==true then saved_data="" end
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        ref_buttonData = loaded_data
    else
        ref_buttonData = defaultButtonData
    end

    spawnedButtonCount = 0
    createTextbox()
end
function click_textbox(i, value, selected)
    if selected == false then
        ref_buttonData.textbox[i].value = value
        updateSave()
    end
end
function click_none() end
function createTextbox()
    for i, data in ipairs(ref_buttonData.textbox) do
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
            color          = buttonColor,
            font_color     = buttonFontColor,
            value          = data.value,
        })
    end
end
