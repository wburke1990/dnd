--[[ ===== TABLETOP SIMULATOR EVENTS ===== --]]

--[[
    Occurs when the bag is loaded.
--]]
function onLoad(save_state)
    printDebug("Debug mode is active!")

    -- Create User-Interface.
    createUserInterface()

    -- Load previous bag state.
    if save_state == nil or save_state == "" then
        script_state = {
            tracked_objects = {}, -- The GUID's, and saved states of each object (Key = GUID, Value = Saved State).
        }
    else
        script_state = JSON.decode(save_state)
    end

    printDebug("Bag State")
    printDebug(JSON.encode_pretty(script_state))
end

function onSave()
    saved_data = JSON.encode(script_state)
    return saved_data
end


function onObjectLeaveContainer(container, leave_object)
    if container ~= self then 
        return -- Ignore it if it isn't this container.
    end

    local old_guid = leave_object.guid -- Get the old guid before it is updated.

    if script_state.tracked_objects[old_guid] == nil then
        return  -- If it the object isn't tracked, then ignore it.
    end

    printDebug("Tracked object left this container!")
    --[[
        This is where the magic happens. Pay close attention.

        When the item is first removed, it still has whatever GUID it had
        whenever it was placed in the bag. 'old_guid'

        However, shortly after it is removed, the GUID might change if it
        is already on the table!!!! You might think "No! It cannot be!", but
        unfortunately it can if the bag was copy-pasted or if it was saved
        to custom objects with objects in it.
        
        The documentation says it takes 1 frame to change the GUID. 
        However, I found that 1 frame is not enough. Instead, you must wait 
        a minimum of 2 frames. Hopefully, this doesn't change in the future.

        If I am dead or I have forgotten about this, then the next poor soul
        should attempt to increase the amount of frames waited just in case
        this has changed in some future TTS update.

        So much for unique ID's, eh?
    --]]
    Wait.frames(
        function() 
            if old_guid ~= leave_object.guid then
                printDebug("Item changed GUID!")
                swapGUID(old_guid, leave_object.guid)
            end
        end, 2)
end


--[[ ===== USER INTERFACE ====== --]]

--[[
    Creates four buttons next to the bag. [Track, Reset, Place, Collect]
    See core functions below for the description of each button.
--]]
function createUserInterface()
    self.createButton({
        label="Track", click_function="onTrackClick", function_owner=self,
        position={1.2,0.3,-2.0}, rotation={0,180,0}, height=350, width=850,
        font_size=250, color={1,1,1}, font_color={0,0,0}
    })

    self.createButton({
        label="Reset", click_function="onResetClick", function_owner=self,
        position={1.2,0.3,-2.7}, rotation={0,180,0}, height=350, width=850,
        font_size=250, color={1,1,1}, font_color={0,0,0}
    })

    self.createButton({
        label="Place", click_function="onPlaceClick", function_owner=self,
        position={-1.2,0.3,-2.0}, rotation={0,180,0}, height=350, width=850,
        font_size=250, color={1,1,1}, font_color={0,0,0}
    })

    self.createButton({
        label="Collect", click_function="onCollectClick", function_owner=self,
        position={-1.2,0.3,-2.7}, rotation={0,180,0}, height=350, width=850,
        font_size=250, color={1,1,1}, font_color={0,0,0}
    })
end


--[[ ===== CORE FUNCTIONS ===== --]]

--[[
    Saves the GUID of each object which is selected so it knows which objects to
    track. If the object is already tracked, it ignores it.
--]]
function onTrackClick(click_object, player_clicker_color, alt_click)
    selected_objects = Player[player_clicker_color].getSelectedObjects()


    -- Highlight currently tracked items magenta.
    for guid,_ in pairs(script_state.tracked_objects) do
        local obj = getObjectFromGUID(guid)
        if obj ~= nil then
            obj.highlightOn({1.0, 0.0, 1.0}, 1.0)
        end 
    end

    if tableIsEmpty(selected_objects) then
        printToColor( "[Cleanup Bag] No objects are selected!", player_clicker_color )
        return
    end

    additional_objects_tracked = 0
    for _,obj in ipairs(selected_objects) do
        if script_state.tracked_objects[obj.guid] == nil and obj.guid ~= self.guid then -- New object.
            script_state.tracked_objects[obj.guid] = {
                position = obj.getPosition(),
                rotation = obj.getRotation(),
                lock = obj.getLock()
            }

            additional_objects_tracked = additional_objects_tracked + 1
            obj.highlightOn({1.0, 0.0, 0.0}, 1.0) -- Highlight new tracked item red.
        end
    end

    if count == 0 then
        printToColor( "[Cleanup Bag] No new items to track!", player_clicker_color )
    else
        printToColor( string.format("[Cleanup Bag] Tracked items added: %d", additional_objects_tracked ), player_clicker_color)
    end
    
    updateSave()
end

--[[
    Removes all tracked items from being tracked.
--]]
function onResetClick(click_object, player_clicker_color, alt_click)
    script_state.tracked_objects = {}
    printToColor( "[Cleanup Bag] Reset!", player_clicker_color )

    updateSave()
end

--[[ 
    Places the saved items back onto the table.
--]]
function onPlaceClick(click_object, player_clicker_color, alt_click)
    local objects_in_bag = self.getObjects();

    if tableIsEmpty(objects_in_bag) then -- No objects in bag.
        printToColor( "[Cleanup Bag] No objects are in the bag.", player_clicker_color )
        return
    end

    if tableIsEmpty(script_state.tracked_objects) then -- No objects tracked ever.
        printToColor( "[Cleanup Bag] No objects have been tracked. Place items into the bag and press 'Track' to track objects.", player_clicker_color )
        return;
    end

    for index,obj in ipairs(objects_in_bag) do
        local object_state = script_state.tracked_objects[obj.guid]

        if object_state == nil then -- Object not tracked.
            printToColor( string.format("[Cleanup Bag] Object with GUID '%s' has never been tracked.", obj.guid), player_clicker_color )
        else

            local old_guid = obj.guid
            local take_params = {
                guid = old_guid,
                position = object_state.position,
                rotation = object_state.rotation,
                smooth = true,
                callback_function = function(placed_obj)
                    
                    printDebug(placed_obj.tag)

                    placed_obj.setLock(object_state.lock)
       
                end
            }
    
            new_obj = self.takeObject(take_params) -- Put object back on table.
        end
    end
end

--[[ 
    Collects tracked objects into the bag.
--]]
function onCollectClick(click_object, player_clicker_color, alt_click)
    if tableIsEmpty(script_state.tracked_objects) then -- No objects tracked ever.
        printToColor( "[Cleanup Bag] No items have been tracked!", player_clicker_color )
        return
    end

    for guid,_ in pairs(script_state.tracked_objects) do

        obj = getObjectFromGUID(guid) -- Find tracked object.

        -- If 'obj' is 'nil' then the object in question is not on the table.

        if obj ~= nil then -- Object is on the table.
            script_state.tracked_objects[guid] = {
                position = obj.getPosition(),
                rotation = obj.getRotation(),
                lock = obj.getLock()
            }

            self.putObject(obj) -- Put the object into the bag.

        else -- Object is not on the table.
            if not guidInBag(guid) then

                -- Object is also not in the bag!
                -- Just remove this object from tracking since it is gone.
                script_state.tracked_objects[guid] = nil
            end
        end
    end

    updateSave()
end


--[[ ===== UTILITY FUNCTIONS ===== --]]

--[[
    Returns true if the desired GUID is in this bag.
--]]
function guidInBag(guid)
    for _,obj in ipairs(self.getObjects()) do
        if obj.guid == guid then
            return true
        end
    end

    return false
end

--[[
    Returns true if the table is empty.
--]]
function tableIsEmpty(tab)
    return tab == nil or next(tab) == nil
end

--[[
    Swaps GUID key in tracked objects with new GUID.
    Unfortunately this is needed becuase of side-effects with TTS.
--]]
function swapGUID(old_guid, new_guid)
    old_state = script_state.tracked_objects[old_guid]

    script_state.tracked_objects[new_guid] = {
        position = old_state.position,
        rotation = old_state.rotation
    }

    script_state.tracked_objects[old_guid] = nil

    updateSave()
end

--[[
    Prints a message only if debug mode is active at the top of the script.
--]]
function printDebug(message)
    if DEBUG_MODE then
        printToAll( string.format("[Cleanup Bag] %s", message), {0.0,1.0,0.0} )
    end
end

--[[
    Updates the current state. Useful for copy-pasting and saving custom objects.
--]]
function updateSave()
    self.script_state = JSON.encode(script_state)
end


--[[ 
    Gets the length of a table. 
--]]
function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

--[[ 
    Returns a new list with the keys for a table. 
--]]
function get_keys(t)
    local u = { }
    for k, _ in pairs(t) do table.insert(u, k) end
    return u
end