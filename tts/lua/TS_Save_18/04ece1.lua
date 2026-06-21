local savedData = {};
savedData['name'] = "Toggle Hidden Zones";
savedData['isHidden'] = false;
savedData['zones'] = {};
function onLoad(script_state)
    if script_state != "" then
        savedData = JSON.decode(script_state);
    end

    local button = {click_function = "toggleHidden", function_owner = self, label = "Toggle\nHidden Zones", position = {0, 0.4, 0}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 2400, height = 900, font_size = 400}
    self.createButton(button);
end

function toggleHidden()
    savedData['isHidden'] = not savedData['isHidden'];
    if not savedData['isHidden'] then
        --Unhide all zones by scaling them to their original scale
        for guid, data in pairs(savedData['zones']) do
            local zone = getObjectFromGUID(guid);
            zone.setScale(data['scale']);
        end
    else 
        --Hide all zones by assuming all zones are currently unhidden and how they would look normally
        savedData['zones'] = {}; --Lets reset all zone data since they are all unhidden, which adds new zones to the list from description
        --Split Description and add all zone GUIDs to savedData

        local lines = {
            "f72583", --Red
            "1bfd64", --White
            "27df09", --Blue
            "83f87c", --Brown
            "5e5df3", --Purple
            "957f5d", --Yellow
            "344f7f", --Teal
            "edce4b", --Orange
            "201673", --Pink
            "a11922", --Green
        }

        for i, line in ipairs(lines) do
            local zone = getObjectFromGUID(line);
            savedData['zones'][line] = {scale = zone.getScale()};
        end
        --Once all zones are added, hide them by scaling them to 0
        for guid, data in pairs(savedData['zones']) do
            local zone = getObjectFromGUID(guid);
            zone.setScale({0, 0, 0});
        end
    end
end

function onSave()
    return JSON.encode(savedData);
end