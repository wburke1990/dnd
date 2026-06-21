local x = Grid.sizeX
local z = Grid.sizeY
local isGridIndicatorSet = 0

function onSave()
    	DatatoSave = {Data1 = ShapeSize, Data2 = ShapeHeight}
    	saved_data = JSON.encode(DatatoSave)
    	return saved_data
end

function onLoad(saved_data)
    	self.addContextMenuItem("Settings",settingsMenu)
    	if saved_data ~= "" then
        		local loaded_data = JSON.decode(saved_data)
        		ShapeSize = loaded_data.Data1
        		ShapeHeight = loaded_data.Data2
    	else
        		ShapeSize = 5
        		ShapeHeight = Grid.sizeX
    	end
    	Wait.time(function() setup() end, 0.05)
end

function setup()
    	self.UI.setAttribute("AreaInput", "placeholder", ShapeSize.." ft.")

end

function setMedium()
    x = Grid.sizeX
    z = Grid.sizeY
    self.setScale(vector(x, self.getScale().y, z))
end

function setLarge()
    x = Grid.sizeX * 2
    z = Grid.sizeY * 2
    self.setScale(vector(x, self.getScale().y, z))
end

function setHuge()
    x = Grid.sizeX * 3
    z = Grid.sizeY * 3
    self.setScale(vector(x, self.getScale().y, z))
end

function adjustHeight(ply, Int)
    	if Int ~= "" and Int ~= nil then
        		ShapeSize = Int
        y = Grid.sizeX * (ShapeSize / 5)
        coords = vector(x, y, z)
        		self.setScale(coords)
        self.setName(ShapeSize.." ft. Flight Base")
        self.UI.setAttribute("AreaButtons", "position", "0 0 " .. tostring(-self.getBounds().size.y + (self.getScale().y + 2)))
        self.UI.setAttribute("LocationIndicator", "position", "0 0 " .. tostring(-self.getBounds().size.y + (self.getScale().y + 2)))
    end
end
			

function settingsMenu(Ply)
    	self.UI.setAttribute("AreaButtons", "active", true)
    	self.removeFromPlayerSelection(Ply)
end

function setGridIndicator()
    if isGridIndicatorSet == 0 then
        self.UI.setAttribute("LocationIndicator", "active", true)
        isGridIndicatorSet = 1
    else
        self.UI.setAttribute("LocationIndicator", "active", false)
        isGridIndicatorSet = 0
    end
end


	function uiClose()
    Wait.time(function()
 		self.UI.setAttribute("AreaButtons", "active", false) 
end, 0.6
) 
	end