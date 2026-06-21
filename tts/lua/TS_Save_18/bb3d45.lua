--  Better Notecards
--  Original Author: Bada
--  Modified by: NightStorm
--  Updated: 1-14-2024

NOTECARD = {}

-- Load and Save data

function onLoad(saved_data)
    if saved_data ~= "" then 
        NOTECARD = JSON.decode(saved_data)
        if NOTECARD.description == nil then
            defaults()
        end
    else
        defaults()
    end
    createFields()
    loadData()
end

function updateSave()
    saved_data = JSON.encode(NOTECARD)
    self.script_state = saved_data
end

function onSave()
    return JSON.encode(NOTECARD)
end

function defaults()
    NOTECARD = {
        description = { "" },
        fontsize = { 375 },
        pagenumber = 1,
        maxpagenumber = 1,
        locked = false,
        input_description = 0,
        input_pagenumber = 1,
        button_lock = 0,
        button_incfont = 1,
        button_decfont = 2,
        button_pageup = 3,
        button_pagedown = 4
    }
end


-- Populate fields

function createFields()
    local buttonScale = {1, 1, 1}
    local lock_label = "Unlocked"
    local lock_color = {0,0.8, 0.4, 100}
        if NOTECARD.locked == true then 
            lock_label = "Locked" 
            lock_color={1,0,0, 100} 
        end
        if NOTECARD.locked == false then 
            lock_label= "Unlocked" 
            lock_color={0,0.8, 0.4, 100} 
        end

    --Main Text
    self.createInput({input_function = "inputDescription", function_owner = self, 
        label = " 1. You can type in this text field \n 2. Click Arrows to change page number\n 4. You can Lock or Unlock the Notepad\n 5. [b]BBCode[/b] also [u]works[/u][FF0000]![-]\n\n\n\n", 
        position = {0.032, 1.45, 0.85}, rotation = {0, 0, 0}, scale = {1, 1, 1},
        font_color = {-1,-1,-1, 15}, color = {1,1,1,0.1}, width = 6800, height = 8300, tab = 3,
        font_size = 375, tooltip = "Type Here", alignment = 2})
    --Page Number
    self.createInput({input_function = "inputPageNumber", function_owner = self, 
        label = "Page Number", 
        position ={-4.401,1.45,10.139}, rotation = {0, 0, 0}, 
        scale = buttonScale, width = 1500, height = 310, 
        font_size = 285, font_color = {0,0,0, 100}, 
        color = {0,0,0,0}, tooltip = "Page Number", 
        alignment = 3, value = "Page Number"})

    --self.editInput({NOTECARD.input_description, rotation = {0, 0, 180}, scale = {-1, 1, 1}})

    self.createButton({click_function = "clickLockUnlock", 
        function_owner = self, label = lock_label, 
        position = {5.37,1.45,10.135}, rotation = {0, 0, 0}, 
        scale = buttonScale, width = 1500, height = 500, 
        color = lock_color, font_color = {1,1,1}, 
        font_size = 300, tooltip = "Lock / Unlock"})

    self.createButton({click_function = "clickPrevPage", function_owner = self, 
        label = "◀", position = {-6.508,1.45,10.129}, 
        rotation = {0, 0, 0}, scale = buttonScale, color = {0,0,0,0}, font_color = {0,0,0, 100}, 
        width = 340, height = 500, font_size = 300, tooltip = "Previous Page"})

    self.createButton({click_function = "clickNextPage", function_owner = self, 
        label = "▶", position = {-2.271,1.45,10.131}, 
        rotation = {0, 0, 0}, scale = buttonScale, color = {0,0,0,0}, font_color = {0,0,0, 100},
        width = 340, height = 500, font_size = 300, tooltip = "Next Page"})

end

function loadData()
    local pageNum = NOTECARD.pagenumber
    if NOTECARD.description[pageNum] ~= nil then
        modifyInput(NOTECARD.input_description, NOTECARD.description[pageNum])
        modifyInput(NOTECARD.input_description, NOTECARD.fontsize[pageNum], "font_size")
    else
        addPage()
        loadData(pageNum)
    end
    updatePage()
end


-- Helpers

function modifyInput(i, v, n)
    if n then
        self.editInput({index = i, [n] = v})
    else
        self.editInput({index = i, value = v})
    end
end

function modifyButton(i, v, n)
    if n then
        self.editButton({index = i, [n] = v})
    else
        self.editButton({index = i, label = v})
    end
    if v == "Locked" then
        self.editButton({index = i, color={1,0,0, 100} })
    elseif v == "Unlocked" then
        self.editButton({index=i, color={0,0.8, 0.4, 100} })
    end
end


-- Page Functions

function addPage()
    NOTECARD.maxpagenumber = NOTECARD.maxpagenumber + 1
    NOTECARD.description[NOTECARD.maxpagenumber] = ""
    NOTECARD.fontsize[NOTECARD.maxpagenumber] = 375
    updateSave()
end

function removePage()
    NOTECARD.description[NOTECARD.maxpagenumber] = nil
    NOTECARD.fontsize[NOTECARD.maxpagenumber] = nil
    NOTECARD.maxpagenumber = NOTECARD.maxpagenumber - 1
    updateSave()
end

function getPageNum()
    return "" .. NOTECARD.pagenumber .. "    /    " .. NOTECARD.maxpagenumber .. ""
end

function updatePage()
    modifyInput(NOTECARD.input_pagenumber, getPageNum())
end


-- Click events

function clickLockUnlock(btn, colw)
    local pageNum = NOTECARD.pagenumber

    NOTECARD.locked = not NOTECARD.locked
    if NOTECARD.locked then
        modifyButton(NOTECARD.button_lock, "Locked")
        modifyInput(NOTECARD.input_description, NOTECARD.description[pageNum])
        modifyInput(NOTECARD.input_description, NOTECARD.fontsize[pageNum], "font_size")
        modifyInput(NOTECARD.input_description, {0,0,180},"rotation")
        modifyInput(NOTECARD.input_description, {-1,1,1},"scale")
    else
        modifyButton(NOTECARD.button_lock, "Unlocked")
        modifyInput(NOTECARD.input_description, NOTECARD.description[pageNum])
        modifyInput(NOTECARD.input_description, NOTECARD.fontsize[pageNum], "font_size")
        modifyInput(NOTECARD.input_description, {0,0,0},"rotation")
        modifyInput(NOTECARD.input_description, {1,1,1},"scale")
    end
    updateSave()
end

function clickPrevPage(btn, col)
    if NOTECARD.description[NOTECARD.maxpagenumber] == "" and #NOTECARD.description > 1 then
        removePage()
    end
    if NOTECARD.pagenumber > 1 then
        NOTECARD.pagenumber = NOTECARD.pagenumber - 1
        loadData()
    end
end

function clickNextPage(btn, col) 
    if NOTECARD.pagenumber == NOTECARD.maxpagenumber then
        addPage()
    end
    NOTECARD.pagenumber = NOTECARD.pagenumber + 1
    loadData()
end

-- Input events

function inputDescription(btn, col, val, sel)
    if NOTECARD.locked then
        alertLocked(col)
        return NOTECARD.description[NOTECARD.pagenumber]
    end
    NOTECARD.description[NOTECARD.pagenumber] = val
    updateSave()
end

function inputPageNumber(btn, col, val, sel) 
    return getPageNum()
end


-- Misc

function alertLocked(col)
    broadcastToColor("Unable to edit. Notepad is locked.", col, {1,0,0})
end