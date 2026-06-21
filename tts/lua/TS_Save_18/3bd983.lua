-- Made by Repulsion
-- Edited by NightStorm
-- Card binder

-- CAN CHANGE VARIABLES BELOW
array_x = 4 -- number of cards spanning left-right
array_z = 4 -- number of cards spanning up-down

spacing_x = 4.2 -- space between the centers of each card spanning left-right
spacing_z = 3.2  -- space between the centers of each card spanning up-down

height_y = 0.08 -- height from center of binder to attach cards at

buttonScale = {0.1,0.1,0.1}

-- CANNOT CHANGE ANYTHING BELOW
num_filled = 0
last_obj = {}
allow_modify = false
state = self.getStateId()
stateSize = self.getStates()

    if stateSize == nil then
        stateSize = 0
    else
        maxState = #stateSize + 1
    end

function onLoad()
    if self.getAttachments() == nil then
        isFull = false
    else
        for _,attachment in pairs(self.getAttachments()) do
            num_filled = num_filled+1
        end
        if num_filled >= array_x*array_z then
            isFull = true
        else
            isFull = false
        end
    end

    --Right Arrow -Button 0
    self.createButton({
        label=string.char(8594), click_function="next", function_owner=self, color= {1,1,1},
        position={0.378,1.05,0.456}, rotation={0,0,0}, height=150, width=300, font_size=150, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })
    --Left Arrow -Button 1
    self.createButton({
        label=string.char(8592), click_function="back", function_owner=self, color= {1,1,1}, 
        position={-0.378,1.05,0.456}, rotation={0,0,0}, height=150, width=300, font_size=150, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })
    --Page Number -Button 2
    self.createButton({
        label=state, click_function="nilFunction", function_owner=self, color= {1,1,1}, 
        position={-0.2,1.05,0.456}, rotation={0,0,0}, height=200 , width=200, font_size=100, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })

    --Max Page Number -Button 3
    self.createButton({
        label=maxState, click_function="nilFunction", function_owner=self, color= {1,1,1}, 
        position={0.2,1.05,0.456}, rotation={0,0,0}, height=200 , width=200, font_size=100, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })

    --Locked Label -Button 4
        local params = {
            click_function = "tryModify",
            function_owner = self, 
            label = "LOCKED", 
            position = {0,1.05,0.46}, 
            scale = buttonScale, 
            width = 750, height = 225, font_size = 130, color = {0.94,0.125,0.121}, font_color = {1,1,1}}
        self.createButton(params)
end

function test() 
    self.setLock(not self.getLock())
            Wait.frames(function() self.setLock(not self.getLock()) end, 1)
end

--Go to right object state
function next()
    if state == -1 then
        print("There is only 1 page.")
    else
            if state >= maxState then
                state = 1
            else
                state = state + 1
            end
        self.setState(state)
    end
end

--Go to left object state
function back()
    if state == -1 then
        print("There is only 1 page.")
    else
            if state == 1 then
                state = maxState
            else
                state = state - 1
            end
        self.setState(state)
    end
end

function nilFunction() end

function onCollisionEnter(collision_info)
    if allow_modify and not isFull then
        local obj = collision_info.collision_object
        if obj.type == "Card" and last_obj ~= obj then
            if obj.interactable and not obj.locked then
                last_obj = obj
                tryBindingCard(obj)
            end
        end
    end
end

function tryModify(player_color)
    local scale = self.getScale()
    local text_sc = 3
    allow_modify = true
    self.removeButton(2) --Page Number
    self.removeButton(3) --Max Page Number
    self.removeButton(4) --Lock

--Unlocked Label
    local params = {
        click_function = "tryLock", 
        function_owner = self, 
        label = "UNLOCKED", 
        position = {-0.171,1.05,0.46}, 
        scale = buttonScale, 
        width = 750, height = 225, font_size = 130, color = {0,0.75,0.33}, font_color = {1,1,1}}
    self.createButton(params)

--Modification Status Label
    local params = {
        click_function = "tryUnbind", 
        function_owner = self, 
        label = "Unbind last card added.", 
        position = {0.11,1.05,0.46}, 
        scale = buttonScale, 
        width = 1600, height = 225, font_size = 130, color = {1,1,1}}
    self.createButton(params)
    
    local unbindPos = {-(array_x-1)/2*spacing_x/scale.x, 0, (array_z+2)/2*spacing_z/scale.z}
    
--Unbind card position
    local params = {click_function = "nilFunction", 
        function_owner = self, 
        label = "◎", 
        position = {-0.355,0.05,0.65}, 
        scale = buttonScale, 
        width = 0, height = 0, font_size = 700, color = {0,0,0}}
    self.createButton(params)
end

function tryLock()
    allow_modify = false
    self.removeButton(2) --Unlock
    self.removeButton(3) --Placeholder
    self.removeButton(4) --Unbind

    --Page Number -Button 2
    self.createButton({
        label=state, click_function="nilFunction", function_owner=self, color= {1,1,1}, 
        position={-0.2,1.05,0.456}, rotation={0,0,0}, height=200 , width=200, font_size=100, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })

    --Max Page Number -Button 3
    self.createButton({
        label=(maxState), click_function="nilFunction", function_owner=self, color= {1,1,1}, 
        position={0.2,1.05,0.456}, rotation={0,0,0}, height=200 , width=200, font_size=100, font_color={0,0,0}, scale={0.2,0.2,0.2},
    })

    --Lock -Button 4
    local params = {
            click_function = "tryModify",
            function_owner = self, 
            label = "LOCKED", 
            position = {0,1.05,0.46}, 
            scale = buttonScale, 
            width = 750, height = 225, font_size = 130, color = {0.94,0.125,0.121}, font_color = {1,1,1}}
        self.createButton(params)

end

function tryBindingCard(obj)
    local locx = spacing_x*(array_x-1)/2-spacing_x*((num_filled)%array_x)
    local locz = (-spacing_z*(array_z-1)/2+spacing_z*math.floor((num_filled)/array_x)) - 0.5
    
    local scale = self.getScale()
    local pos = self.positionToWorld(Vector(locx/scale.x,height_y/scale.y,locz/scale.z))
    local rot = self.getRotation()
    local obj_rot = obj.getRotation()
    
    rot.y = math.floor((obj_rot.y-rot.y)/90+0.5)*90+rot.y
    
    if obj.is_face_down then
        rot.z = rot.z+180
    end
    
    obj.setPosition(pos)
    obj.setRotation(rot)
    
    self.addAttachment(obj)

    num_filled = num_filled+1
    if num_filled >= array_x*array_z then
        isFull = true
    end
end

function tryUnbind(player_color)
    local attachments = self.getAttachments()
    if #attachments ~= 0 then
        local removed = self.removeAttachment(#attachments-1)
    
        local scale = self.getScale()
        local unbindPos = {(array_x-1)/2*spacing_x/scale.x, 3/scale.y, (array_z+2)/2*spacing_z/scale.z}
        removed.setPosition(self.positionToWorld(unbindPos))
        num_filled = num_filled-1
        if num_filled < array_x*array_z then
            isFull = false
        end
    end
end

