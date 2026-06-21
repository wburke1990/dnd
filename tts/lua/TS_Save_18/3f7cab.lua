function onLoad()
	grid = {
		about = [[
			3D Gridlines
			--
			This tool was written by stom, also known as Me, I'm Counting. More 
			information about it may be available on the authors website at 
			www.stom66.co.uk
			--
			This tool was inspired by Searanger and his wonderful RPG maps which 
			feature some lovely Unity Terrain assets. Thanks to him for the idea 
			for this as well as testing and feedback.
			--
			You are free to use and redistribute this tool for any means compatible with 
			the informal policy of "don't be a dick". If you make something particularly 
			cool, interesting or profitable then please let me know.
			--
			Problems can be reported in the comments section of the Steam Workshop page.
		]],
		heights_loading  = false,
		is_clear = true,
		origin = {
			x = 0,
			y = 1,
			z = 0
		},
		scales = {
			0.5, 0.75, 
			1, 1.25, 1.5, 
			2, 2.5, 
			3, 4, 5, 6
		},
		settings = {
			stroke           = 0.05,
			max_height       = 20,
			color            = 12,
			vertical_padding = 0.1,
			yield            = 0.1,
		},
		colors = {
			{"Brown",       0.443,  0.231,  0.09   },
			{"Red",         0.856,  0.1,    0.094  },
			{"Orange",      0.956,  0.392,  0.113  },
			{"Yellow",      0.905,  0.898,  0.172  },
			{"Green",       0.192,  0.701,  0.168  },
			{"Teal",        0.129,  0.694,  0.607  },
			{"Blue",        0.118,  0.53,   1.0    },
			{"Purple",      0.627,  0.125,  0.941  },
			{"Pink",        0.96,   0.439,  0.807  },
			{"White",       1.0,    1.0,    1.0    },
			{"Light Grey",  0.66,   0.66,   0.66   },
			{"Grey",        0.33,   0.33,   0.33   },
			{"Dark Grey",   0.15,   0.15,   0.15   },
			{"Black",       0.05,   0.05,   0.05   },
		},
		strokes = {
			0.01, 0.025, 0.05, 0.075, 
			0.1, 0.15, 0.175,
			0.25, 0.5, 0.75, 1
		},
		size = {
			x = 88,
			z = 52,
			scale = 1,
		},
		assets = {
			{
				name = "trash",
				url  = "https://i.imgur.com/rpiWvSf.png"
			},
			{
				name = "arrow-right",
				url  = "https://i.imgur.com/XybSMrR.png"
			},
			{
				name = "arrow-left",
				url  = "https://i.imgur.com/aADOK53.png"
			},
			
		}
	}
	UI.setCustomAssets(grid.assets) --apply custom assets
	Wait.frames(xml_updateData, 1) --trigger an update for the UI to apply default values
end

function getIndexOfValue(t, c)
	--cludge to get the key of a value within a table, used by XML UI
	for k,v in pairs(t) do
		if v == c then return k end
	end
end
function rgbToColorblock(i)
	local rgb = grid.colors[i]
	local s = "rgb("..rgb[2]..","..rgb[3]..","..rgb[4]..")"
	return s.."|"..s.."|"..s.."|"..s
end

function xml_updateData(player, value, id)
	--typically triggerd by a playing changing one the xml UIs, but is also 
	--called by some functions
	if player and value and id then
		--check if update was triggered by a player changing a settings
		log("xml_updateData("..player.color..", "..value..", "..id..")")

		--extract param from input name (size x/y, scale or stroke) from input name 
		local axis = string.gsub(id, "xml_input_slider_", "")
		if axis == "stroke" then
			grid.settings.stroke = grid.strokes[tonumber(value)]
		elseif axis == "scale" then
			grid.size.scale = grid.scales[tonumber(value)]
		else
			grid.size[axis] = value
		end
	end

	--work out max possible sizes based on current params
	local max_x, max_z = math.floor(88/grid.size.scale), math.floor(52/grid.size.scale)
	grid.size.x = math.min(grid.size.x, max_x)
	grid.size.z = math.min(grid.size.z, max_z)

	--update x axis slider
	self.UI.setAttribute("xml_text_x", "text", grid.size.x)
	self.UI.setAttribute("xml_input_slider_x", "maxValue", max_x)
	self.UI.setValue("xml_input_slider_x", grid.size.x)
	
	--update z axis slider
	self.UI.setAttribute("xml_text_z", "text", grid.size.z)
	self.UI.setAttribute("xml_input_slider_z", "maxValue", max_z)
	self.UI.setValue("xml_input_slider_z", grid.size.z)

	--update grid scale slider
	self.UI.setAttribute("xml_text_scale", "text", grid.size.scale)
	self.UI.setAttribute("xml_input_slider_scale", "maxValue", #grid.scales)
	self.UI.setAttribute("xml_input_slider_scale", "value", getIndexOfValue(grid.scales, grid.size.scale))

	--update stroke slider
	self.UI.setAttribute("xml_text_stroke", "text", grid.settings.stroke)
	self.UI.setAttribute("xml_input_slider_stroke", "maxValue", #grid.strokes)
	self.UI.setAttribute("xml_input_slider_stroke", "value", getIndexOfValue(grid.strokes, grid.settings.stroke))

	--update grid color button
	self.UI.setAttribute("xml_text_color", "text", grid.colors[grid.settings.color][1])
	self.UI.setAttribute("xml_text_color", "colors", rgbToColorblock(grid.settings.color))

	--update main button with appropriate text
	if grid.is_clear then
		self.UI.setAttribute("xml_updateGrid", "text", "Draw Grid")
	else
		self.UI.setAttribute("xml_updateGrid", "text", "Update Grid")
	end		
end

function btn_changeColor(player, value)
	log("btn_changeColor("..player.color..", "..value..")")
	--called when the player changes the current color. 
	--cycles through the table of colors and loops at ends
	value = tonumber(value)
	grid.settings.color = grid.settings.color + value
	if grid.settings.color < 1 then
		grid.settings.color = #grid.colors
	elseif grid.settings.color > #grid.colors then
		grid.settings.color = 1
	end
	--trigger update of XML UI
	xml_updateData()
end
function xml_updateGrid()
	--triggered when a user clicks the update/draw grid button
	if grid.heights_loading then 
		--previous heightmap calcs are still running, abort
		broadcastToAll("Still calculating heightmap...", "Orange")
		return false
	else
		--set loading flag and trigger coroutine
		grid.heights_loading = true
		startLuaCoroutine(self, "getHeights")
	end
end

function clearGrid(player, value)
	--triggered by a player clicking the trash can
	Global.setVectorLines()
	grid.is_clear = true
	if tonumber(value) == 0-2 then
		--if it was a right click reset the values to their defaults
		grid.size.x          = 88
		grid.size.z          = 52
		grid.size.scale      = 1
		grid.settings.stroke = 0.1
	end
	Wait.frames(xml_updateData, 5)
end


function getHeights()
	local t_s = os.time()

	--work out basic grid params for reference and localise some values
	local start_x = grid.origin.x - (grid.size.x * grid.size.scale) / 2
	local start_z = grid.origin.z - (grid.size.z * grid.size.scale) / 2
	local vpad = grid.settings.vertical_padding

	local t = {} --blank table for node heightmaps
	local cast_p = { --basic cast params for each node
		origin       = {0, grid.origin.y+grid.settings.max_height, 0},
		direction    = {0,grid.settings.max_height*-1,0},
		type         = 1,
		max_distance = grid.settings.max_height,
	}

	--actually pretty simple here. we loop through each row (r) and make a table for it and 
	--each of its child cells (c) in the result table (t). 
	--we then update the cast_p with the current position and trigger a simple line cast. 
	--loop thorugh the returned intersected objects and return the point.y for the first
	--object we encounter with grid_projection enabled
	for r=0,grid.size.x do
		t[r]             = {}
		cast_p.origin[1] = start_x + (r*grid.size.scale)
		for c=0,grid.size.z do
			t[r][c]          = grid.origin.y+grid.settings.vertical_padding --give it default value in case no object found
			cast_p.origin[3] = start_z+(c*grid.size.scale)
			local cast       = Physics.cast(cast_p)			
			if #cast > 0 then
				for _,v in ipairs(cast) do
					if v.hit_object.grid_projection == true then
						t[r][c] = v.point.y+vpad
						break
					end
				end
			end
		end
		if os.difftime(os.time()-t_s) > grid.settings.yield then coroutine.yield(0) end
		if r % 10 == 0 then coroutine.yield(0) end
	end
	--done with our casts. save the heighmap
	grid.heights = t

	do
		local t_d = os.difftime(os.time()-t_s)
		local tot = grid.size.x*grid.size.z
		local av = math.floor(tot/t_d)
		log("Heightmap generated in "..t_d)
		log(grid.size.x.."x"..grid.size.z.."="..tot.." casts averaging "..av.."/second")
	end

	--trigger the drawing of the grid
	startLuaCoroutine(self, "drawGrid")
	return 1
end

function drawGrid()
	--grid drawing function, triggered after getHeights()
	local function blankVline()
		--local function to simplify making a single contour line
		return {
			points    = {},
			color     = {
				grid.colors[grid.settings.color][2],
				grid.colors[grid.settings.color][3],
				grid.colors[grid.settings.color][4]
			},
			thickness = grid.settings.stroke,
			rotation  = {0,0,0},
		}
	end
	--setup some basic params and localise some values
	local t_s    = os.time()
	local vlines = {}
	local scale  = grid.size.scale
	local size_x, size_z = grid.size.x, grid.size.z

	--work out grid start pos
	local start_x = grid.origin.x - (size_x * scale) / 2
	local start_z = grid.origin.z - (size_z * scale) / 2

	--loop through x axis (rows) making a new countour line for each with heights 
	--for each z intersect taken from heightmap
	for r=0,size_x do
		local x = start_x + (r*scale)
		local v = blankVline()
		for c=0,size_z do
			table.insert(v.points, {x, grid.heights[r][c], start_z + (c*scale)})
		end
		table.insert(vlines, v)
	end

	--as above, this time for z-axis (cols)
	for c=0,size_z do
		local z = start_z + (c*scale)
		local v = blankVline()
		for r=0,size_x do
			table.insert(v.points, {start_x + (r*scale), grid.heights[r][c], z})
		end
		table.insert(vlines, v)
	end

	--draw our vector lines, clear flags, and trigger an xml ui update
	Global.setVectorLines(vlines)
	log("Grid was drawn in "..os.difftime(os.time()-t_s))
	grid.is_clear        = false
	grid.heights_loading = false
	xml_updateData()
	return 1
end