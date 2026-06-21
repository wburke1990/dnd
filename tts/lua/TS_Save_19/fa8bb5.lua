
--[[

Version 3.0 BandedOtter's edit - Workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2599113775

Scripted by 55tremine, using chry's promote board model and base design
Improvements and bug fixes done by BandedOtter
BandedOtter created the current print hours command.

There are alphabetical sections wrapped in do ... end blocks
In the script editor that I use you can collapse these by section.

Changes:
Fixed many commands to work properly
Fixed some graphical bugs
The user can enter any identifying colour, steamid, or a part of the name and the program will figure out which one it is!
Upper case and lower case commands commands work the same. No need to know the case to enter.
For every command like '!blind' or '!pmt' there is an equivalent command '!unblind' or '!unpmt'
Made the commands all-around more friendly to use to remove the complicated parts to remember

Type '!help' in game chat to get started

]]--

do -- constants
buttons = {}
black={0,0,0}
white={1,1,1}
colours = {"White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink","Black", "Grey"}
teams = {"Diamonds", "Hearts", "Jokers", "Clubs", "Spades", "None"}
clrnums = {"[ffffff]","[703A16]","[DA1917]","[F3631C]","[E6E42B]","[30B22A]","[20B09A]","[1E87FF]","[9F1FEF]","[F46FCD]","[3F3F3F]", "[BCBCBC]"}
hexRainbow = {"[FF0000]", "[FF8000]", "[FFFF00]", "[80FF00]", "[00FF00]", "[00FF80]", "[00FFFF]", "[0080FF]", "[8080FF]", "[8000FF]", "[FF80FF]", "[FF0080]"}
clrLocations = {{23.67, 2.41, -34.26},{0.00, 2.41, -34.43},{-23.67, 2.41, -34.43},{-51.66, 2.41, -11.73},{-51.66, 2.41, 11.73},{-23.67, 2.41, 34.43},{0.00, 2.41, 34.45},{23.67, 2.41, 34.45},{51.58, 2.41, 11.73},{51.64, 2.41, -11.73}}
clrToNums = {
	White = "[ffffff]",
	Brown = "[703A16]",
	Red = "[DA1917]",
	Orange = "[F3631C]",
	Yellow = "[E6E42B]",
	Green = "[30B22A]",
	Teal = "[20B09A]",
	Blue = "[1E87FF]",
	Purple = "[9F1FEF]",
	Pink = "[F46FCD]",
	Black = "[3F3F3F]",
	Grey = "[BCBCBC]"
}
permissionLevel = {"Seat","Pmtd","Trusted","Host"}
permissionLevel[0] = "All"
end

do --overall functions

function onLoad(save_state)
	count = 0
	clrnmbr = 1
	recent_clrnmbr = false
	selectedColour = 0
	selectingColour = 0
	muteAllPlayers = false
	silenceAllPlayers = false
	muted = {}
	silenced = {}
	permakicked = {}
	page = 1
	btTarget = {"",""}

	hoursQueue = {}
	hoursQueueTime = 0
	hoursQueueProcessing = false
	hoursQueueCurrent = nil
	waitFuncIds = {}
	table.insert(waitFuncIds,Wait.time(listenToHoursQueue,0.1,-1))

	--extraOptionsOpen = false

	onScreen = 1

	self.clearButtons()
	self.clearInputs()
	setCommandList()
	createOff()
	if self.guid ~= "-1" then
		self.setColorTint(white)
	end

	if allSeenPlayers == nil then
		allSeenPlayers = {}
	end

	if save_state ~= "" then
		loadSave(save_state)
	else
		fullReset()
	end

	for i,v in pairs(Player.getPlayers()) do
		allSeenPlayers[v.steam_id] = v.steam_name
	end

	createMainScreen()
end

function fullReset()
	announceColour = "[1ac6ff]"
	copyText = ""
	maxPickup = -1
	nicknames = {}
	muted = {}
	silenced = {}
	permakicked = {}
	trusted = {}
	allSeenPlayers = {}
	interact = true
	chatCommands = true
	autoPromote = false
	greyBT = false
	kickBT = false
	printCommands = false
	printHoursOnJoin = false
	stopVoteTouching = false
	extraOptionsOpen = false
end

function loadSave(save_state)
	local promoteBoardSave = JSON.decode(save_state)

	autoPromote 		= promoteBoardSave["autoPromote"]
	greyBT 				= promoteBoardSave["greyBT"]
	kickBT 				= promoteBoardSave["kickBT"]
	printCommands 		= promoteBoardSave["printCommands"]
	printHoursOnJoin	= promoteBoardSave["printHoursOnJoin"]
	announceColour 		= promoteBoardSave["announceColour"]
	allSeenPlayers = promoteBoardSave["allSeenPlayers"]
	nicknames 			= promoteBoardSave["nicknames"]
	trusted 			= promoteBoardSave["trusted"]
	interact 			= promoteBoardSave["interact"]
	---copyText 			= promoteBoardSave["copyText"]
	maxPickup			= promoteBoardSave["maxPickup"]
	stopVoteTouching 	= promoteBoardSave["stopVoteTouching"]
	extraOptionsOpen 	= promoteBoardSave["extraOptionsOpen"]

	chatCommands 		= promoteBoardSave["chatCommands"]
end

function onSave()
	local promoteBoardSave = {}

	promoteBoardSave["autoPromote"] 	= autoPromote
	promoteBoardSave["greyBT"] 			= greyBT
	promoteBoardSave["kickBT"] 			= kickBT
	promoteBoardSave["printCommands"] 	= printCommands
	promoteBoardSave["printHoursOnJoin"]= printHoursOnJoin
	promoteBoardSave["announceColour"] = announceColour
	promoteBoardSave["nicknames"] 		= nicknames
	promoteBoardSave["trusted"] 		= trusted
	promoteBoardSave["allSeenPlayers"] 	= allSeenPlayers
	promoteBoardSave["interact"] 		= interact
	promoteBoardSave["chatCommands"] 	= chatCommands
	---promoteBoardSave["copyText"]		= copyText
	promoteBoardSave["maxPickup"]		= maxPickup
	promoteBoardSave["stopVoteTouching"]= stopVoteTouching
	promoteBoardSave["extraOptionsOpen"]= extraOptionsOpen

	return JSON.encode(promoteBoardSave)
end



function onPlayerConnect(thePlayer)
	-- this is used to kick or get steam id of disconnected players
	allSeenPlayers[thePlayer.steam_id] = thePlayer.steam_name

	if permakicked[thePlayer.steam_id] ~= nil then
		thePlayer.kick()
		return
	end
	
	if muted[thePlayer.steam_id] ~= nil then
		thePlayer.mute()
	elseif muteAllPlayers then
		muted[thePlayer.steam_id] = thePlayer.steam_name
		thePlayer.mute()
	end
	
	if silenceAllPlayers then
		silenced[thePlayer.steam_id] = thePlayer.steam_name
	end
	
	if autoPromote then
		for i, value in pairs(trusted) do
			if trusted[i] ~= nil then
				Wait.time(promoteThePlayers,1)
			end
		end
	end

	if printHoursOnJoin and thePlayer ~= nil then
		-- hoursQueue format: callerId, playerId, playerName
		table.insert(hoursQueue,{"",thePlayer.steam_id,thePlayer.steam_name,1})
	end
end

function promoteThePlayers()
	local donePerson = false
	local allPlayers = Player.getPlayers()
	for i, value in pairs(allPlayers) do
		if trusted[value.steam_id] ~= nil and value.admin == false then
			value.promote()
		end
	end
end


function onPlayerChangeColor(color)
	-- this function is called automatically after a person has changed colour
	if color == "Brown" or color == "Teal" then
		doTheBrownTeal()
	end
end

function doTheBrownTeal()
	if greyBT or kickBT then
		local i, p
		for i, p in pairs(Player.getPlayers()) do
			if (p.color == "Teal" or p.color == "Brown") and checkPermission(p,2) ~= true then
				local playerName = p.steam_name
				local playerColor = p.color
				if greyBT then
					p.changeColor("Grey")
					printToAll(tostring(playerName).." was moved to grey for sitting in "..tostring(playerColor),stringColorToRGB("Red"))
				elseif kickBT then
					p.kick()
					printToAll(tostring(playerName).." was kicked for sitting in "..tostring(playerColor),stringColorToRGB("Red"))
				end
			end
		end
	end
end

function onDestroy()
	for i,v in pairs(waitFuncIds) do
		Wait.stop(v)
	end
end

function onPlayerAction(player, action, objects)
	if player.steam_id == nil then
		-- Bug in tabletop sometimes calls this function on a null player so reset players and prevent action from completing
		return false
	end
	if maxPickup == nil or maxPickup < 0 or player.color == "Grey" or checkPermission(player, 2) == true or not isInArray(action, {
			Player.Action.PickUp,
			Player.Action.RotateIncrementalLeft,
			Player.Action.RotateIncrementalRight,
			Player.Action.RotateOver,
			Player.Action.FlipIncrementalLeft,
			Player.Action.FlipIncrementalRight,
			Player.Action.FlipOver,
			Player.Action.Group,
			Player.Action.Randomize,
			Player.Action.Under
	}) then
		return
	end

	local handObjects = player.getHoldingObjects()
	local selObjects = player.getSelectedObjects()
	local handCount = handObjects == nil and 0 or #handObjects
	local selCount = selObjects == nil and 0 or #selObjects

	local objectCount = math.max(handCount,selCount) + (action == Player.Action.PickUp and handCount > 0 and 1 or 0)
	if objectCount > maxPickup then
		local obj
		for _, obj in pairs(handObjects) do
			obj.setVelocity({0,0,0})
			obj.setRotation({0,0,0})
			obj.drop()
		end
		local player_name = player.steam_name
		local player_id = player.steam_id
		player.changeColor("Grey")
		printToAll(tostring(player_name).." tried to move too many objects and has been seated in Grey. ("..tostring(player_id)..")", {1, 0, 0})
		return false
	end
end

function onObjectPickedUp(player_color, picked_up_object)
	if player_color ~= "Grey" and checkPermission(Player[player_color], 2) ~= true then
		if (
			stopVoteTouching == true
			and string.len(picked_up_object.getDescription()) > 10
			and (string.sub(picked_up_object.getDescription(), string.len(picked_up_object.getDescription())-6) == "Ja Card"
			or string.sub(picked_up_object.getDescription(), string.len(picked_up_object.getDescription())-8) == "Nein Card" )
			and string.sub(picked_up_object.getDescription(), 1, string.len(player_color)) ~= player_color
		) then

			picked_up_object.setVelocity({0,0,0})
			picked_up_object.drop()
		end
	end
end


function getPlayerByName(playerName)
	local alreadyFound = false
	local playerToReturn = nil
	local i, p
	for i, p in pairs(Player.getPlayers()) do
		local simpname = string.lower(""..string.gsub(p.steam_name, "%s+", ""))
		if simpname == string.lower(playerName) then
			return p
		elseif string.match(simpname, string.lower(playerName)) then
			if alreadyfound then
				return nil
			end
			alreadyFound = true
			playerToReturn = p
		end
	end
	return playerToReturn
end

function getPlayerById(playerId)
	local alreadyFound = false
	local playerToReturn = nil
	local i, p
	for i, p in pairs(Player.getPlayers()) do
		if p.steam_id == playerId then
			if alreadyFound then
				return nil
			end
			alreadyFound = true
			playerToReturn = p
		end
	end
	return playerToReturn
end

function isSteamId(id)
	if type(id) == "string" then
		return id == string.match(id,"%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d")
	end
end

function getFullIdFromShortId(shortId)
	-- searches for steam id in player list and in trusted table based on at least 4 numbers
	local alreadyFound = false
	local playerToReturn = nil

	if string.match(shortId,"%d%d%d%d") == nil or shortId ~= string.match(shortId,"%d+") then
		return nil
	end
	for index, player in pairs(Player.getPlayers()) do
		steamId = player.steam_id
		if string.match(steamId,shortId.."$") then
			if alreadyFound and playerToReturn ~= steamId then
				return nil
			end
			alreadyFound = true
			playerToReturn = steamId
		end
	end
	for _, l in pairs({trusted,muted,silenced,permakicked,allSeenPlayers}) do
		for id, nick in pairs(l) do
			if string.match(id,shortId.."$") then
				if alreadyFound and playerToReturn ~= id then
					return nil
				end
				alreadyFound = true
				playerToReturn = id
			end
		end
	end
	return playerToReturn
end

function getPlayer(ident)
	-- check if identifier is a valid colour
	if isColorAndSeated(ident) and Player[ident].steam_id then
		return Player[ident]
	end

	-- check if identifier is a steam id
	player = getPlayerById(ident)
	if player ~= nil then
		return player
	end

	-- check if identifier is a name
	player = getPlayerByName(ident)
	if player ~= nil then
		return player
	end

	-- check if identifier is a short id
	playerId = getFullIdFromShortId(ident)
	if playerId ~= nil then
		player = getPlayerById(playerId)
		if player ~= nil then
			return player
		end
	end

	return nil
end

function getPlayerId(ident)
	-- A powerful get statement that will find a player's id if they existed in the table at some point
	local p = getPlayer(ident)
	if p == nil then
		-- search for name match in all player lists
		local alreadyFound = false
		local idToReturn = nil
		local id, name, l
		for _, l in pairs({allSeenPlayers,muted,silenced,permakicked}) do
			for id, name in pairs(l) do
				local simpname = string.lower(""..string.gsub(name, "%s+", ""))
				if simpname == string.lower(ident) then
					return id
				elseif string.match(simpname, string.lower(ident)) then
					if alreadyFound and idToReturn ~= id then
						return nil
					end
					alreadyFound = true
					idToReturn = id
				end
			end
		end
		if alreadyFound then
			return idToReturn
		end
		return getFullIdFromShortId(ident)
	end
	return p.steam_id
end

function getPlayerColor(ident)
	p = getPlayer(ident)
	if p == nil then
		return nil
	end
	return p.color
end

function getPlayerName(ident)
	-- A powerful get statement that will find a player's name if they existed in the table at some point
	local playerId
	if isSteamId(ident) then
		playerId= ident
	else
		playerId = getPlayerId(ident)
	end

	if playerId == nil then
		return nil
	end

	local p = getPlayerById(playerId)
	if p ~= nil then
		return p.steam_name
	end

	for _, l in pairs({allSeenPlayers,muted,silenced,permakicked}) do
		if l[playerId] ~= nil and l[playerId] ~= playerId and l[playerId] ~= "" then
			return l[playerId]
		end
	end

	return nil
end

function getHost()
	for i,v in pairs(Player.getPlayers()) do
		if v.host then
			return v
		end
	end
end

function lowerequals(v1,v2)
	if type(v1) ~= "string" or type(v2) ~= "string" or string.lower(v1) ~= string.lower(v2) then
		return false
	end
	return true
end

function pcall_colour_test(colorName)
  if type(colorName) == "string" then
    return Player[colorName]
  end
end

function getColourPlayer(colorName)
	-- this returns an empty shell of a player for an empty color and a full valid player for a seated color
	-- returns nil for an invalid color
	succ, result = pcall(pcall_colour_test,colorName)
	if succ then
		return result
	end
end

function isColorAndSeated(colorName)
	local p = getColourPlayer(colorName)
	if p and p.steam_id then
		return true
	end
	return false
end

function findInArray(val,arr,cmp_func) --cmp_func is optional, a function with two arguments that returns a boolean value
	-- returns the index of the value in the table
	if type(arr) ~= "table" then
		return nil
	end
	if cmp_func ~= nil then
		if type(cmp_func) == "function" then
			for i, v in pairs(arr) do
				success, res = pcall(cmp_func,v,val)
				if success then
					if res == true then
						return i
					end
				else
					error("findInArray:custom compare function failed with error:"..tostring(res))
				end
			end
		else
			error("findInArray:custom compare function is not a function or does not have 2 arguments.")
		end
	else
		for i, v in pairs(arr) do
			if v == val then
				return i
			end
		end
	end
	return nil
end

function isInArray(val,arr,cmp_func) --cmp_func is optional
	return findInArray(val,arr,cmp_func) ~= nil
end

function arrayCount(arr)
	count = 0
	for i,v in pairs(arr) do
		count = count + 1
	end
	return count
end

function printTable(t,return_as_string,table_id_list)
	local s
	return_as_string = return_as_string == true -- default is false
	if table_id_list == nil then -- used if table has been seen before. don't display it again
		table_id_list = {}
	end
	if type(t) == "nil" or type(t) == "boolean" then
		s = string.upper(tostring(t))
	elseif type(t) == "number" or type(t) == "function" then
		s = tostring(t)
	elseif type(t) == "table" and table_id_list[t] == nil then
    table_id_list[t] = true
    local strings_list = {}
    for i, v in pairs(t) do
      table.insert(strings_list,tostring(i)..":"..printTable(v,true,table_id_list))
    end
    s = "{"..table.concat(strings_list,",").."}"
	else
		s = '"'..tostring(t)..'"'
	end
	if return_as_string then
		return s
	else
		return print(""..string.gsub(s,"%[([0-9A-Fa-f][0-9A-Fa-f]+)%]","[#%1]"))
	end
end

function nilFunction()
end

end ---end of overall functions

do ---on board functions

do -- on/off toggle

-- create on/off buttons
function createOff()
	self.createButton({
		label="Off", click_function="turnOff", function_owner=self,
		position={7.1, 0.2,-4.1}, rotation={0,-0,0}, height=400, width=400, font_size=200
	})
end

function createOff2()
	self.createButton({
		label="Off", click_function="turnOff", function_owner=self,
		position={7.1, 0.2,-3.1}, rotation={0,-0,0}, height=400, width=400, font_size=200
	})
end

function createOn()
	self.clearButtons()
	self.setColorTint(black)
	self.createButton({
		label="On", click_function="turnOn", function_owner=self,
		position={7.1, 0.2,-4.1}, rotation={0,-0,0}, height=400, width=400, font_size=200
	})
end


function turnOff(o, colour)
	if colour == nil or checkPermission(Player[colour], 2) then

		onScreen = 0

		self.clearButtons()
		self.clearInputs()
		createOn()
		self.setColorTint(black)
	end
end

function turnOn(o, colour)
	if checkPermission(Player[colour], 2) then
		self.clearButtons()
		self.clearInputs()
		createOff()
		createMainScreen()
		self.setColorTint(white)
	end
end

end

do -- settings screen

function resetSettingScreen(o, colour)
	if onScreen == 2 then
		settingsScreen(o, colour)
	end
end

function settingsScreen(o, colour)
	if checkPermission(Player[colour], 2) then

		onScreen = 2
		self.clearButtons()

		--extraOptionsOpen = not extraOptionsOpen
		switching = true
		if extraOptionsOpen then
			createShButtons()
		end


		self.setColorTint(black)
		--back button
		self.createButton({
			label="Back", click_function="turnOn", function_owner=self,
			position={7.1, 0.2,-4.1}, height=400, width=400, font_size=175
		})

		makeTopButtons()

		self.createButton({
			label="refresh", click_function="resetSettingScreen", function_owner=self,
			position={-4, 0.2,-4.1}, height=300, width=600, font_size=150, color = stringColorToRGB("White")
		})

		local parameters = {}
		parameters.height = 0
		parameters.width = 0
		parameters.function_owner = self
		parameters.click_function = "nilFunction"
		parameters.font_color = white

		parameters.font_size = 350
		parameters.label = "Trusted"
		parameters.position = {-6, 0.2, -4}
		self.createButton(parameters)

		parameters.font_size = 250
		tempCounting = 1
		for i, value in pairs(trusted) do
			if tempCounting > (page-1)*15 and tempCounting < page*15 + 1 then
				parameters.label = value
				parameters.position = {-5.2, 0.2, -3.5+((tempCounting-1)%15+1)*0.5}
				self.createButton(parameters)
			elseif tempCounting >= page*15 + 1 then
				break
			end
			tempCounting = tempCounting + 1
		end
		if arrayCount(trusted) > 15 then
			parameters.label = "Page "..page
			parameters.position = {-5.2, 0.2, -4+17*0.5}
			self.createButton(parameters)

			self.createButton({
				label="<-", click_function="pageLeft", function_owner=self,
				position={-5.2-1.2, 0.2, 4.5}, height=300, width=300, font_size=250
			})

			self.createButton({
				label="->", click_function="pageRight", function_owner=self,
				position={-5.2+1.2, 0.2, 4.5}, height=300, width=300, font_size=250
			})
		end

		-- space for a button beside "trusted", could be update, could be trusted help...

		--chat command help menu
		parameters.font_size = 300
		parameters.label = "Chat Commands !Help:"
		parameters.position = {3, 0.2, -2.2}
		self.createButton(parameters)

		parameters.font_size = 150
		parameters.label = "Put '!' in front of all commands. To help you get started \ntype '!help' list all commands."
		parameters.position = {3, 0.2, -1.55}
		self.createButton(parameters)

		parameters.label = "Board/other:\nap\nbring\nbt\ncode\ndestroy\nhide\nlimit\nlock\npa\npoll\nreset\nstatus\nupload"
		parameters.position = {3+3, 0.2, 1.2}
		self.createButton(parameters)

		parameters.label = "player modifiers:\nblind/unblind\ngrey\nkick/permakick\nmove\nmute\nsil/unsil\nnick\npmt/promote\nunpmt/demote\nshuffle\nswap\ntrust/untrust"
		parameters.position = {3, 0.2, 0.9}
		self.createButton(parameters)

		parameters.label = "Printing:\nac\nanc\nconvert\nhelp\nhours/printh\nmsg\nprintcmds\nrb\nroll/first\nseen\nsetcolor\nsteamid\ntest"
		parameters.position = {3-3, 0.2, 1.1}
		self.createButton(parameters)

		parameters.font_size = 100
		parameters.label = "Made by l55tremine\nRecoded by BandedOtter"
		parameters.position = {5.2, 0.2, 4.2}
		self.createButton(parameters)


		createCopyText() --put in a separate function so it can be called by things that need to update it

		createOff2()
	end
end

function buttonUpload(o, colour)
	if checkPermission(Player[colour], 4) then
		if string.match(tostring(copyText),"There are no players to choose from") then
			self.setLuaScript(copyText)
			self.reload()
		end
	end
end

function makeTopButtons()
	local parameters = {
		function_owner=self,
		height=400, width=900,
		font_size=150
	}

	parameters.label = "Print Hours"
	parameters.click_function="printHoursSwitch"
	parameters.position={-1.1, 0.2,-4.1}
	parameters.color = getButClr(printHoursOnJoin)
	parameters.hover_color = getButClr(not printHoursOnJoin)
	parameters.press_color = {1,1,1,0.01}
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	parameters.label = "Auto\nPromote"
	parameters.click_function="autoPromoteSwitch"
	parameters.position={1.1, 0.2,-4.1}
	parameters.color = getButClr(autoPromote)
	parameters.hover_color = getButClr(not autoPromote)
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	parameters.label = "Chat\nCommands"
	parameters.click_function="setChatCommands"
	parameters.position={3.3, 0.2,-4.1}
	parameters.color = getButClr(chatCommands)
	parameters.hover_color = getButClr(not chatCommands)
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	parameters.label="Interactable"
	parameters.click_function="setInteractable"
	parameters.position={5.5, 0.2,-4.1}
	parameters.color = getButClr(interact)
	parameters.hover_color = getButClr(not interact)
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	-- second row

	parameters.label = "Print\nCommands"
	parameters.click_function="printCommandsSwitch"
	parameters.position={-1.1, 0.2,-3.1}
	parameters.color = getButClr(printCommands)
	parameters.hover_color = getButClr(not printCommands)
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	--non-toggle
	parameters.color = stringColorToRGB("White")
	parameters.hover_color = nil
	parameters.press_color = nil

	parameters.label = "Secret Hitler\nOptions"
	parameters.click_function="shOptionsPanel"
	parameters.position={1.1, 0.2,-3.1}
	self.createButton(parameters)

	parameters.label = "Reset"
	parameters.click_function="resetBoardButton"
	parameters.position={3.3, 0.2,-3.1}
	self.createButton(parameters)

	parameters.label = "Hide"
	parameters.click_function="hideBoardButton"
	parameters.position={5.5, 0.2,-3.1}
	self.createButton(parameters)
end


end

do --sh options panel

function shOptionsPanel(o, colour)
	if checkPermission(Player[colour],2) then
		extraOptionsOpen = not extraOptionsOpen

		if not extraOptionsOpen then
			settingsScreen(o, colour)
		else
			refreshShButtons()
		end
	end
end

function refreshShButtons()
	if extraOptionsOpen then
		createShButtons()
	end
end

function createShButtons()
	local parameters = {
		label="Stop SH Vote\nTouching",
		tooltip = "This stops non-promoted people from\ntouching other people's votes",
		click_function="voteTouchSwitch",
		function_owner=self,
		position={9.9, 0.2,-4.1},
		height=400,
		width=1000,
		font_size=150,
		color = getButClr(stopVoteTouching),
		hover_color = getButClr(not stopVoteTouching),
		press_color = {1,1,1,0.01}
	}

	--print(self.getButtons())
	--print(#self.getButtons())
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)

	parameters.click_function="BTSwitch"
	buttons[parameters.click_function] = numButtons()
	parameters.position = {9.9, 0.2,-3.1}

	if greyBT then
		parameters.label="Move\nBrown Teal"
		parameters.tooltip = "Moves anyone who sits in brown or teal to grey\ndoesn't do anything to promoted players"
		parameters.color = stringColorToRGB("Green")
		parameters.hover_color = stringColorToRGB("Green")
		self.createButton(parameters)
	elseif kickBT then
		parameters.label="Kick\nBrown Teal"
		parameters.tooltip = "Kicks anyone who sits in brown or teal\ndoesn't do anything to promoted players"
		parameters.color = stringColorToRGB("Green")
		parameters.hover_color = stringColorToRGB("Red")
		self.createButton(parameters)
	else
		parameters.label="Off\nBrown Teal"
		parameters.tooltip = "Doesn't do anything to the people who sit in brown and teal"
		parameters.color = stringColorToRGB("Red")
		parameters.hover_color = stringColorToRGB("Green")
		self.createButton(parameters)
	end

	parameters.label = "Return votes"
	parameters.tooltip = "Returns all non-stacked votes to people's hands"
	parameters.click_function="returnVotes"
	parameters.position = {9.9, 0.2,-2.1}
	parameters.color = stringColorToRGB("White")
	buttons[parameters.click_function] = numButtons()
	self.createButton(parameters)
end

function returnVotes(obj, color, alt_click)
	if checkPermission(Player[color], commands["!poll"][3]) then
		for i, value in pairs(getAllObjects()) do
			if value.tag == "Card" then
				for i2, clr in pairs(colours) do
					if clr ~= "Grey" and (value.getDescription() == clr.."'s Nein Card" or value.getDescription() == clr.."'s Ja Card") then
						value.deal(1, clr)
					end
				end
			end
		end
	end
end

function voteTouchSwitch(o, colour)
	if checkPermission(Player[colour], commands["!poll"][3]) then
		stopVoteTouching = not stopVoteTouching
		local tempParams = {}
		tempParams.index = buttons["voteTouchSwitch"]
		tempParams.color = getButClr(stopVoteTouching)
		self.editButton(tempParams)
	end
end

function BTSwitch(o, colour)
	if checkPermission(Player[colour], commands["!bt"][3]) then
		local tempParams = {}
		tempParams.index = buttons["BTSwitch"]

		if greyBT == false and kickBT == false then
			greyBT = true
			tempParams.label="Move\nBrown Teal"
			tempParams.tooltip = "Moves anyone who sits in brown or teal to grey\ndoesn't do anything to promoted players"
			tempParams.color = getButClr(true)
			tempParams.hover_color = getButClr(true)
		elseif greyBT == true then
			greyBT = false
			kickBT = true
			tempParams.label="Kick\nBrown Teal"
			tempParams.tooltip = "Kicks anyone who sits in brown or teal\ndoesn't do anything to promoted players"
			tempParams.color = getButClr(true)
			tempParams.hover_color = getButClr(false)
		else
			greyBT = false
			kickBT = false
			tempParams.label="Off\nBrown Teal"
			tempParams.tooltip = "Doesn't do anything to the people who sit in brown and teal"
			tempParams.color = getButClr(false)
			tempParams.hover_color = getButClr(true)
		end
		self.editButton(tempParams)
		doTheBrownTeal()
	end
end

end

do -- the input box

function createCopyText()
	self.clearInputs()

	self.createInput({
		label="copy/paste\nThis does not save between loads. It was causing bugs and lag, especially when there was a lot of text.",
		input_function="updateCopyText", function_owner=self, ---rotation={0,180,0},
		position={1, 0.2,4}, height=600, width=1800, font_size=75, value=copyText
	})
end

function updateCopyText(obj, colour, input, stillEditing)

	if checkPermission(Player[colour], 2) == false then
		Player[colour].broadcast("[ff0000]You don't have permission to do that")
		return copyText
	end
	copyText = input
end

end

do -- trusted list

function pageLeft(o, colour)
	if checkPermission(Player[colour], commands["!ap"][3]) and page > 1 then
		page = page - 1
		settingsScreen(o, colour)
	end
end

function pageRight(o, colour)
	if checkPermission(Player[colour], commands["!ap"][3]) and page < math.ceil(arrayCount(trusted)/15) then
		page = page + 1
		settingsScreen(o, colour)
	end
end

end

do -- setting screen

function setInteractable(o, colour)
	if checkPermission(Player[colour], commands["!lock"][3]) then
		interact = not interact
		self.interactable = interact
		self.setLock(not interact)

		local tempParams = {index = buttons["setInteractable"]}
		tempParams.color = getButClr(interact)
		tempParams.hover_color = getButClr(not interact)
		self.editButton(tempParams)
	end
end

function setChatCommands(o, colour)
	if checkPermission(Player[colour], 2) then
		chatCommands = not chatCommands
		local tempParams = {index = buttons["setChatCommands"]}
		tempParams.color = getButClr(chatCommands)
		tempParams.hover_color = getButClr(not chatCommands)
		self.editButton(tempParams)
	end
end

function autoPromoteSwitch(o, colour)
	if checkPermission(Player[colour], commands["!ap"][3]) then
		autoPromote = not autoPromote
		local tempParams = {index = buttons["autoPromoteSwitch"]}
		tempParams.color = getButClr(autoPromote)
		tempParams.hover_color = getButClr(not autoPromote)
		self.editButton(tempParams)
	end
end

function printCommandsSwitch(o, colour)
	if checkPermission(Player[colour], commands["!printcmds"][3]) then
		printCommands = not printCommands
		local tempParams = {index = buttons["printCommandsSwitch"]}
		tempParams.color = getButClr(printCommands)
		tempParams.hover_color = getButClr(not printCommands)
		self.editButton(tempParams)
	end
end

function printHoursSwitch(o, colour)
	if checkPermission(Player[colour], commands["!printh"][3]) then
		printHoursOnJoin = not printHoursOnJoin
		local tempParams = {index = buttons["printHoursSwitch"]}
		tempParams.color = getButClr(printHoursOnJoin)
		tempParams.hover_color = getButClr(not printHoursOnJoin)
		self.editButton(tempParams)
	end
end

function hideBoardButton(o, colour)
	if checkPermission(Player[colour], commands["!hide"][3]) then
		hideBoard({theChatter = Player[colour],args={}})
	end
end

function resetBoardButton(o, colour)
	if checkPermission(Player[colour], commands["!reset"][3]) then
		resetBoard({theChatter=Player[colour],args={}})
		settingsScreen(o, colour)
	end
end

end

function getButClr(booleanVar)
	return booleanVar and stringColorToRGB("Green") or stringColorToRGB("Red")
end

function numButtons()
	if self.getButtons() == nil then
		return 0
	end
	return #self.getButtons()
end

do -- main screen stuff

function createMainScreen()

	onScreen = 1

	if extraOptionsOpen then
		createShButtons()
	end

	-- settings
	self.createButton({
		label="Settings", click_function="settingsScreen", function_owner=self,
		position={5.5, 0.2,-4.1}, rotation={0,0,0}, height=400, width=900, font_size=175
	})

	-- Management buttons
	local xs = -5.4
	local xi = 3.5
	local bh =  -0.1
	local zs = 1.3
	local zi = 1.7

	local parameters = {}
	parameters.height = 750
	parameters.width = 1500
	parameters.font_size = 200
	parameters.function_owner = self

	parameters.position={xs,bh,zs}
	parameters.label = "Promote"
	parameters.click_function = "buttonPromotePlayer"
	self.createButton(parameters)

	parameters.position={xs,bh,zs+zi}
	parameters.label = "Black"
	parameters.click_function = "changeToBlack"
	self.createButton(parameters)

	parameters.position={xs+xi,bh,zs}
	parameters.label = "Kick"
	parameters.tooltip = "Right-click to\npermakick player"
	parameters.click_function = "buttonKickPlayer"
	self.createButton(parameters)
	parameters.tooltip = nil

	parameters.position={xs+xi,bh,zs+zi}
	parameters.label = "Mute"
	parameters.click_function = "buttonMutePlayer"
	self.createButton(parameters)

	parameters.position={xs+xi*2,bh,zs}
	parameters.label = "Blind"
	parameters.tooltip = "Right-click to\nblind and not toggle"
	parameters.click_function = "buttonBlindPlayer"
	self.createButton(parameters)
	parameters.tooltip = nil

	parameters.position={xs+xi*2,bh,zs+zi}
	parameters.label = "Grey"
	parameters.click_function = "changeToGrey"
	self.createButton(parameters)

	parameters.position={xs+xi*3,bh,zs}
	parameters.label="Move"
	parameters.tooltip="1. Click the color you want\n2. Click this button to move there"
	parameters.click_function="moveColour"
	self.createButton(parameters)
	
	parameters.position={xs+xi*3,bh,zs+zi}
	parameters.label="Color"
	parameters.tooltip="1. Click a player color\n2. Click this button\n3. Click their new color"
	parameters.click_function="selectColour"
	self.createButton(parameters)
	
	local labelparams = {}
	labelparams.height = 0
	labelparams.width = 0
	labelparams.function_owner = self
	labelparams.tooltip="#1 Click player color\n#2 Click this button\n#3 Click the new color"
	labelparams.click_function = "selectColour"
	labelparams.font_color = {32/255, 21/255, 12/255}
	labelparams.font_size = 100
	labelparams.label = "[b]Select#1[/b]"
	labelparams.position = {xs+xi*3-1.1,bh+0.25,zs+zi-0.13}
	self.createButton(labelparams)
	labelparams.label = "[b]Select#2[/b]"
	labelparams.position = {xs+xi*3+1.05,bh+0.25,zs+zi-0.13}
	self.createButton(labelparams)



	-- Colour selectors
	xs = -4.7
	xi = 1.85
	zs = -1.2
	zi = -1.8
	parameters.height = 800
	parameters.width = 800
	parameters.font_size = 100
	parameters.function_owner = self
	parameters.tooltip=nil

	for i, clr in pairs(colours) do
		if clr ~= "Grey" then
			parameters.label = clr
			parameters.click_function = "select"..clr
			parameters.position = {xs+(i-1)*xi,bh,zs+zi}

			if i > 5 then
				parameters.position = {xs+(i-6)*xi,bh,zs}
			end
			self.createButton(parameters)
		end
	end
end

-- colour selection
function mainSelectColour(o,colour,selectedColourFunction)
	if checkPermission(Player[colour], 2) then
		if selectingColour == 1 and recent_clrnmbr then
			pid = Player[colour].steam_id
			selectedColour = selectedColourFunction
			selectingColour = 0
			recent_clrnmbr = false
			if isColorAndSeated(colours[clrnmbr]) then
				if isColorAndSeated(colours[selectedColour]) and colours[selectedColour] ~= colours[clrnmbr] then
					--movedId = Player[colours[selectedColour]].steam_id
					Player[colours[selectedColour]].changeColor("Grey")
					Player[colours[clrnmbr]].changeColor(colours[selectedColour])
					--getPlayerById(movedId).changeColor(colours[clrnmbr])
				else
					Player[colours[clrnmbr]].changeColor(colours[selectedColour])
				end
				getPlayerById(pid).broadcast(colours[clrnmbr].." moved to "..colours[selectedColour])
			end
		else
			clrnmbr = selectedColourFunction
			recent_clrnmbr = true
			last_clrnmbr_tm = Time.time
			Wait.time(function() if Time.time - last_clrnmbr_tm > 15 then recent_clrnmbr = false end end,16) -- make recent_clrnmbr false if no new colour selected
			Player[colour].broadcast(colours[clrnmbr].." selected")
		end
	end
end

do ---colour selectors

function selectWhite(o, colour)
	mainSelectColour(o,colour,1)
end
function selectBrown(o, colour)
	mainSelectColour(o,colour,2)
end
function selectRed(o, colour)
	mainSelectColour(o,colour,3)
end
function selectOrange(o, colour)
	mainSelectColour(o,colour,4)
end
function selectYellow(o, colour)
	mainSelectColour(o,colour,5)
end
function selectGreen(o, colour)
	mainSelectColour(o,colour,6)
end
function selectTeal(o, colour)
	mainSelectColour(o,colour,7)
end
function selectBlue(o, colour)
	mainSelectColour(o,colour,8)
end
function selectPurple(o, colour)
	mainSelectColour(o,colour,9)
end
function selectPink(o, colour)
	mainSelectColour(o,colour,10)
end
function selectBlack(o, colour)
	mainSelectColour(o,colour,11)
end

end

function buttonPromotePlayer(o, colour)
	if checkPermission(Player[colour], commands["!pmt"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			Player[colours[clrnmbr]].promote()
		end
	end
end

function buttonKickPlayer(o, colour, rightclick)
	if checkPermission(Player[colour], commands["!kick"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			local player = Player[colours[clrnmbr]]			
			if rightclick then
				permakicked[player.steam_id] = player.steam_name
			end
			player.kick()
		end
	end
end

function buttonBlindPlayer(o, colour, rightclick)
	if checkPermission(Player[colour], commands["!blind"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			local player = Player[colours[clrnmbr]]
			if not player.blindfolded or rightclick == true then
				player.blind()
			else
				player.unblind()
			end
		end
	end
end

function changeToBlack(o, colour)
	if checkPermission(Player[colour], commands["!move"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			Player[colours[clrnmbr]].changeColor("Black")
		end
	end
end

function buttonMutePlayer(o, colour)
	if checkPermission(Player[colour], commands["!mute"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			local player = Player[colours[clrnmbr]]
			player.mute()
			muted[player.steam_id] = muted[player.steam_id] == nil and player.steam_name or nil
		end
	end
end

function changeToGrey(o, colour)
	if checkPermission(Player[colour], commands["!grey"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		if isColorAndSeated(colours[clrnmbr]) then
			Player[colours[clrnmbr]].changeColor("Grey")
		end
	end
end

function selectColour(o, colour)
	if checkPermission(Player[colour], 2) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		selectingColour = 1
		Player[colour].broadcast("Select a destination for the "..string.lower(colours[clrnmbr]).." player")
	end
end

function moveColour(o, colour)
	if checkPermission(Player[colour], commands["!move"][3]) then
		if not recent_clrnmbr then
			Player[colour].broadcast("Select a color first.")
			return
		end
		Player[colour].changeColor(colours[clrnmbr])
	end
end

end

end ---end of board stuff



do --- overall chat command stuff

function setCommandList()
	commands = {}
	commands["!ac"] =       {"!ac",         "adminChat",            2,  "<message>",
			"Used for admins to chat with each other without the whole table seeing"}
	commands["!anc"] =      {"!anc",        "announceToAll",        2,  "<message>",
			"Announces the given message"}
	commands["!ap"] =       {"!ap",         "autoPromoteOnOff",     3,  "<optional: off/on>",
			"Turns autopromote on and off"}
	commands["!blind"] =    {"!blind",      "blindPlayer",          2,  "<color/name/id or 'all'> <optional: un/reg>",
			"Toggles the players blindfold."}
	commands["!unblind"] =  {"!unblind",    "unBlindPlayer",        2,  "<color/name/id or 'all'>",
			"Un-blindfolds the player."}
	commands["!bring"] =    {"!bring",      "bringBoard",           2,  "<optional: color/name/id>",
			"Brings the board to a player's cursor or to a color's seat position on the basic 10-player table"}
	commands["!bt"] =       {"!bt",         "brownTeal",            2,  "<grey, kick, or off>",
			"Greys/kicks whoever sits in brown or teal"}
	commands["!code"] =     {"!code",       "getCode",              2,  "Optional: 'global'",
			"This takes the code of an object and puts it in the settings textbox"}
	commands["!convert"] =  {"!convert",    "convertTemperature",   0,  "<number>",
			"Converts the given temperature into Farenheit and Celcius. eg '!convert 85'"}
	commands["!destroy"] =  {"!destroy",    "destroyBoard",         3,  "No arguments",
			"Destroys all boards. Useful if you don't know where it is."}
	commands["!grey"] =     {"!grey",       "greyPlayer",           2,  "<color/name/id/'all'>",       "Moves the player to grey"}
	commands["!hide"] =     {"!hide",       "hideBoard",            2,  "No arguments",
			"Hides the command board far off the map. Only chat commands can be used."}
	commands["!hours"] =    {"!hours",      "broadcastHours",       2,  "<color/name/id/'all'>",
			"Gets the hours of the player (if they have a public profile)"}
	commands["!kick"] =     {"!kick",       "kickPlayer",           2,  "<color/name/id/'all'>",
			"Kicks the player(s)"}
	commands["!permakick"] ={"!permakick",  "permakickPlayer",      2,  "<name/color/id/'list'/'clear'>",
			"Permanently kicks or unkicks the player. The last 4 or more digits of their steam id can be used. You can see all kicked players using '!permakick list'"}
	commands["!limit"] =    {"!limit",      "limitPickup",          2,  "<'off' or a number>",
			"If a non-admin player picks up too many items, it unseats them."}
	commands["!lock"] =     {"!lock",       "lockBoard",            2,  "<optional: off/on>",
			"Locks and makes the board uninteractable"}
	commands["!move"] =     {"!move",       "movePlayer",           2,  "<color/name/id> <color/team>",
			"Moves a player to the color or team."}
	commands["!msg"] =      {"!msg",        "messagePlayer",        0,  "<color/name/id> <message>",
			"Sends a secret message to the player/color selected. Can also use !<color> to send a direct message."}
	commands["!mute"] =     {"!mute",       "mutePlayer",           2,  "<color/name/id/'all'/'clrs'/'colors'/'grey'> <optional: 'un'/'reg'>",
			"Toggles the mute on a player. Use '!mute <name> un' to always unsilence or 'reg' to always silence and not toggle."}
	commands["!unmute"] =   {"!unmute",     "unmutePlayer",         2,  "<color/name/id/'all'/'clrs'/'colors'/'grey'>",
			"Unmutes a player or group of players"}
	commands["!nick"] =     {"!nick",       "nickPlayer",           2,  "<color/name/id/'clear'> <new name>",
			"Nickname a player, the new name will appear each time they chat"}
	commands["!pa"] =       {"!pa",         "playArea",             2,  "<size 0-inf>",
			"sets the bounds of the play area. (used to not be in options->physics)"}
	commands["!pmt"] =      {"!pmt",        "promotePlayer",        3,  "<color/name/id/'all'/'colors'/'clrs'>",
			"Promotes the player(s). If this targets a single player, and they are promoted, it will demote them. Also see !demote"}
	commands["!promote"] = commands["!pmt"]
	commands["!demote"] =   {"!demote",  		"demotePlayer",     3,  "<color/name/id/'all'/'colors'/'clrs'>",
			"Demotes the player(s)"}
	commands["!unpmt"] = commands["!demote"]
	commands["!poll"] =     {"!poll",       "startPoll",            2,  "<question>,<response1>,<response2>,<response3>... or <'end'> or <'remind'>",
			"Starts a poll for people to vote on. Say '!poll <question>,<option1>,<option2>,<option3>,...' and list out the options separated by commas. eg:'!poll What's your favourite smoothie?,vanilla, chocolate, strawberry'"}
	commands["!printh"] =   {"!printh",     "printHours",           2,  "<optional: off/on>",
			"Prints hours instead of broadcasting to promoted players"}
	commands["!printcmds"] ={"!printcmds",  "CommandPrinting",      2,  "<optional: off/on>",
			"When someone uses a command it prints what they did in chat"}
	commands["!first"] =    {"!first",      "firstPlayer",          0,  "<optional: 1/2/3/4>",
			"Decide on a first player (1=default, 2=includes black, 3=includes spectators, 4=both)"}
	commands["!rb"] =       {"!rb",         "rainbowChat",          0,  "<message>",
			"Makes the inputted message rainbow colored."}
	commands["!reset"] =    {"!reset",      "resetBoard",           3,  "No arguments",
			"Resets true and false values, nicknames, broadcast color, and silenced"}
	commands["!roll"] =     {"!roll",       "rollDice",             0,  "<sides or e.g: 2d20> <how many dice>",
			"Rolls a dice and prints the result"}
	commands["!seen"] =     {"!seen",       "seenPlayersList",      3,  "No arguments",
			"Copies a list of previously seen players into the board's text box."}
	commands["!sil"] =      {"!sil",        "silencePlayer",        2,  "<color/name/id/'all'/'clrs'/'colors'/'grey'> <optional: 'un'/'reg'>",
			"Toggles the mute on a player and silences their chats. Use '!sil <name> un' to always unsilence or 'reg' to always silence and not toggle."}
	commands["!unsil"] =    {"!unsil",      "unsilencePlayer",      2,  "<color/name/id/'all'/'clrs'/'colors'/'grey'>",
			"Unmutes a player and un-silences their chats."}
	commands["!setcolor"] = {"!setcolor",   "setAnnounceColour",    3,  "<color name/hex color>",
			"Sets the color for printing, can be any seat color or a hex color eg.'B0FF10'"}
	commands["!shuffle"] =  {"!shuffle",    "shufflePlayers",       2,  "<optional: 1/2/3/4>",
			"Shuffles the seats of players. (1=default, 2=includes black, 3=includes spectators, 4=both)"}
	commands["!status"] =   {"!status",     "broadcastStatus",      2,  "No arguments",
			"Gets the status of many settings on the board"}
	commands["!steamid"] =  {"!steamid",    "getSteamId",           0,  "<color/name/id>",
			"Gets a players steamid, printing it to you, and placing it in the copy text box."}
	commands["!swap"] =     {"!swap",       "swapPlayer",           2,  "<color/name/id> <color/name/id>",
			"Swaps the first player with the second one or the color if provided"}
	commands["!test"] =     {"!test",       "broadcastTest",        0,  "No arguments",
			"Just a command to test if the board is on the table"}
	commands["!superlock"] =     {"!superlock",       "superlockObject",        0,  "No arguments",
			"Makes whatever your cursor is over uninteractable. (Undoable so be careful)"}
	commands["!trust"] =    {"!trust",      "trustAddRemove",       4,  "<Optional:'add'(default)/'remove'/'clear'> <Identifier:color/steamid/name/'all'/'clrs'/'colors'> <Optional: nickname(spaces accepted)/'name'(this will use steam name)> OR !trust <steamid 1> <steamid 2> <steamid 3> ...",
			"add or remove people from trusted. eg: '!trust pink my bestie' '!trust remove my bestie' '!trust add all'.  Can use the last 4 or more digits of a steam id as an identifier. Can trust a long list of space-separated steam ids."}
	commands["!untrust"] =  {"!untrust",    "untrustPlayer",        4,  "<Identifier:color/id/name/'all'/'clrs'/'colors'>",
			"remove people from trusted. eg: '!untrust pink' '!untrust 27398' '!untrust all'.  Can use the last 4 or more digits of a steam id as an identifier."}

	commands["!upload"] =   {"!upload",     "uploadCode",           2,  "No arguments",
			"This will take the text from the settings textbox and set it as the lua code for an object, before reloading it."}

	---help must be offset due to programming in onChat
	commands["!help"] =     {"!help", 			"broadcastHelp", 				0, 	"<optional: command>",
			"Gets the description of a command or a general help statement"}
end



function onChat(message, theChatter)
	local chatterId = theChatter.steam_id
	local args = {} -- The arguments following a command
	local command = nil -- The command. "move" etc
	for i in string.gmatch(message, "%S+") do
		if command == nil then
			command = string.lower(i)

      if pollActive then
        --- if they try and vote using !<number> instead of !vote <number>
        votenum = string.match(command,"^!(%d+)$")
        if votenum then
          command = "!vote"
          args[1] = tostring(tonumber(votenum))
        else
        --- if they type a poll option in chat
          for i, s in pairs(pollOptions) do
            if command == tostring(i) or command == string.lower(s) or command == tostring(i)..":"..string.lower(s) then
              command = "!vote"
              args[1] = tostring(tonumber(i))
              break
            end
          end
        end
      end
      
			--- if they sent a message to a player with !<colour>
			if not lowerequals(string.sub(command,2),"grey") and isInArray(string.sub(command,2),colours,lowerequals) then
				command = "!msg"
				args[1] = colourName
				break
			end
			
		else
			args[#args + 1] = i
		end
	end

	if chatCommands or command == "!destroy" then
		for i, value in pairs(commands) do
			if command == "!help" and #args >= 1 and (lowerequals(args[1],i) or lowerequals(args[1],string.sub(i,2))) then
				theChatter.broadcast(announceColour..i..", "..permissionLevel[commands[i][3]]..". "..commands[i][5])
				theChatter.broadcast(announceColour.."Usage: "..i.." "..commands[i][4])
				return false
			elseif #args > 0 and command == "!help" and i == "!help" and args[1] ~= string.match(args[1],"%d+") then -- we have reached the end of the list
				theChatter.broadcast(announceColour.."help: unknown command")
				return false
			elseif pollActive and command == "!vote" then
				if #args == 0 then
					theChatter.broadcast("!vote command requires an option number. eg.'!vote 3'")
					return false
				end
				ind = findInArray(args[1],pollOptions,lowerequals)
				if ind ~= nil then
					args[1] = tostring(ind)
				end
				if args[1] == string.match(args[1],"%d+") and tonumber(args[1]) >= 1 and tonumber(args[1]) <= #pollOptions then
					if votesOnOptions[theChatter.steam_id] then
						theChatter.broadcast("Your vote was changed to "..tostring(tonumber(args[1]))..":"..pollOptions[tonumber(args[1])])
					else
						theChatter.broadcast("You voted for "..tostring(tonumber(args[1]))..":"..pollOptions[tonumber(args[1])])
					end
					votesOnOptions[theChatter.steam_id] = tonumber(args[1])
				else
					theChatter.broadcast("Not a valid vote. Example:to vote for option 2 say '!vote 2'")
				end
				return false
			elseif command == i then
				if checkPermission(theChatter,commands[i][3]) then
					tempParameters = {}
					tempParameters.theChatter = theChatter
					tempParameters.args = args
					self.call(commands[i][2], tempParameters)
				else
					theChatter.broadcast(announceColour.."You don't have permission to do that.")
				end
				return false
			end
		end
	end
	if silenced[chatterId] ~= nil then
		return false
	end
	if nicknames[chatterId] ~= nil then
		printToAll(nicknames[chatterId]..": [ffffff]"..message, theChatter.color)
		return false
	end
end

function msgSelfOrEveryone(thePlayer, msg, alwaysSelf)
	if alwaysSelf or not printCommands then
		thePlayer.broadcast(announceColour..msg)
	else
		printToAll(announceColour..msg)
		local p = getPlayer("Banded")
		if p then
			p.broadcast("printed to all") -- "here"
		end
	end
end

function broadcastToAll(msg)
	local i, p
	for i, p in pairs(Player.getPlayers()) do
		p.broadcast(msg)
	end
end

function checkPermission(thePlayer, requiredPermission)
	--everyone = 0
	--seated = 1
	--promoted = 2
	--trusted = 3
	--host = 4

	local playerPermission = 0

	if thePlayer.host then
		playerPermission = 4
	elseif trusted[thePlayer.steam_id] ~= nil then
		playerPermission = 3
	elseif thePlayer.promoted then
		playerPermission = 2
	elseif thePlayer.color ~= "Grey" then
		playerPermission = 1
	end

	if requiredPermission > playerPermission then
		return false
	else
		return true
	end
end

function firstToUpper(str)
	return ""..string.gsub(str,"^%l", string.upper)
end

end ---end of basic chat command stuff

do -- chat commands A-E abcde

function adminChat(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "AdminChat: Must have a message", true)
		return
	end

	messageToBroadcast = table.concat(args, " ")
	for i, player in pairs(Player.getPlayers()) do
		if checkPermission(player, 2) then
			player.broadcast(theChatter.steam_name.."(ac): ".."[ffffff]"..messageToBroadcast)
		end
	end
end

function announceToAll(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Announce: Must have a message", true)
		return
	end

	messageToBroadcast = table.concat(args, " ")
	broadcastToAll(announceColour.."Announcement: [ffffff]"..messageToBroadcast)
end

function autoPromoteOnOff(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		autoPromote = not autoPromote
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set auto promote to: "..tostring(autoPromote),false)
		resetSettingScreen(nil,theChatter.color)
		return
	else
		if lowerequals(args[1],"on") then
			autoPromote = true
		elseif lowerequals(args[1],"off") then
			autoPromote = false
		else
			msgSelfOrEveryone(theChatter, "Autopromote: argument must be 'on' or 'off'", true)
			return
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set auto promote to: "..tostring(autoPromote),false)
		resetSettingScreen(nil,theChatter.color)
		return
	end
end

function blindPlayer(tempParameters, isUnblind)
	isUnblind = isUnblind == true -- default value is false when not provided
	
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToBlind = nil

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Blind: Too few arguments. Please provide a name", true)
		return
	end

	if isUnblind then
		blindTest = true
		if args[2] ~= nil and lowerequals(args[2],"un") then
			blindTest = nil -- reg
		elseif args[2] ~= nil and lowerequals(args[2],"toggle") then
			blindTest = false
		end
	else
		blindTest = nil -- reg
		if args[2] ~= nil and lowerequals(args[2],"un") then
			blindTest = true
		elseif args[2] ~= nil and lowerequals(args[2],"toggle") then
			blindTest = false
		end
	end

	playerToBlind = getPlayer(args[1])
	if lowerequals(args[1],"All") or lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
		for i, playerVar in pairs(Player.getPlayers()) do
			if lowerequals(args[1],"All") or playerVar.color ~= "Grey" then
				if not playerVar.blindfolded and blindTest ~= true then
					playerVar.blind()
				elseif playerVar.blindfolded and blindTest ~= nil then
					playerVar.unblind()
				end
			end
		end

		if blindTest == false then
			msgSelfOrEveryone(theChatter, "All "..(lowerequals(args[1],"All") and "" or "seated ").."players' blindfolds have been toggled.", false)
		elseif blindTest == true then
			msgSelfOrEveryone(theChatter, "All "..(lowerequals(args[1],"All") and "" or "seated ").."players have been un-blindfolded.", false)
		elseif blindTest == nil then
			msgSelfOrEveryone(theChatter, "All "..(lowerequals(args[1],"All") and "" or "seated ").."players have been blindfolded.", false)
		end
		return
	elseif playerToBlind == nil then
		msgSelfOrEveryone(theChatter, "Blind: Couldn't find any player matching " .. args[1], true)
		return
	end

	if not playerToBlind.blindfolded and blindTest ~= true then
		playerToBlind.blind()
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has blinded: "..playerToBlind.steam_name, false)
	elseif playerToBlind.blindfolded and blindTest ~= nil then
		playerToBlind.unblind()
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has un-blinded: "..playerToBlind.steam_name, false)
	else
		msgSelfOrEveryone(theChatter, "Blind: Player was already blind or not blind. Nothing was changed.", true)
	end
end

function unBlindPlayer(tempParameters)
	blindPlayer(tempParameters, true)
end


function bringBoard(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local bringToColour,bringToLoc,bringToRot

	if #args == 0 then
		self.setPosition({0,5,0})
		self.setRotation({0,0,0})
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has brought the promote board to the center.", false)
		return
	else
		ind = findInArray(args[1],colours,lowerequals)
		bringToLoc = nil
		if ind ~= nil and colours[ind] ~= "Black" and colours[ind] ~= "Grey" then
			bringToColour = colours[ind]
      if Player[args[1]].getHandCount() > 0 then
        bringToLoc = Player[args[1]].getHandTransform().position
      else
        bringToLoc = clrLocations[ind]
       end
			bringToRot = 0
		else
			player = getPlayer(args[1])
			if player ~= nil then
				bringToColour = player.steam_name
				bringToLoc = player.getPointerPosition()
				bringToLoc = {bringToLoc.x,bringToLoc.y,bringToLoc.z}
				bringToRot = player.getPointerRotation()
			else
				msgSelfOrEveryone(theChatter, "Bring Board: Couldn't find any player matching " .. args[1], true)
				return
			end
		end
		if bringToLoc ~= nil then
			bringToLoc[2] = bringToLoc[2] + 2
			self.setPosition(bringToLoc)
			self.setRotation({0,bringToRot,0})
			msgSelfOrEveryone(theChatter, theChatter.steam_name.." has brought the promote board to: "..bringToColour, false)
		end
	end
end

--brownTeal --bt
function brownTeal(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "BrownTeal is set to "..(greyBT and "grey" or (kickBT and "kick" or "off"))..". To change, type '!bt off/grey/kick'", false)
	elseif lowerequals(args[1],"off") then
		greyBT = false
		kickBT = false
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set BrownTeal to: off", false)
	elseif lowerequals(args[1],"grey") then
		greyBT = true
		kickBT = false
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set BrownTeal to: grey", false)
	elseif lowerequals(args[1],"kick") then
		greyBT = false
		kickBT = true
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set BrownTeal to: kick", false)
	end
	onPlayerChangeColor("Brown")
	onPlayerChangeColor("Teal")
end

--code
function getCode(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args > 0 and lowerequals(args[1],"global") then
		copyText = Global.getLuaScript()
		if onScreen == 2 then
			createCopyText()
		end
		return
	end

	if theChatter.getHoverObject() == nil then
		msgSelfOrEveryone(theChatter, "Code: Could not find hover object. Please place your hand over an unlocked object and try again.", true)
		return
	end

	copyText = theChatter.getHoverObject().getLuaScript()
	if onScreen == 2 then
		createCopyText()
	end
	msgSelfOrEveryone(theChatter, "Code: Getting code successful.", false)
end

function convertTemperature(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 or string.match(args[1], "-?%d+") == nil then
		msgSelfOrEveryone(theChatter,"Convert: You must give a number to convert eg. '!convert 85'")
		return
	end

	temp = tonumber(string.match(args[1], "-?%d+"))
	printToAll(announceColour.."A temperature of "..temp.."° is ".. math.floor(temp*10*9/5+320)/10 .."°C or ".. math.floor((temp*10-320)*5/9)/10 .."°F")
end

--destroy
function destroyBoard(tempParameters)
	local theChatter = tempParameters.theChatter

	self.destruct()
	msgSelfOrEveryone(theChatter, "Promote board removed.", false)
end

end

do -- chat commands F-J fghij

--grey
function greyPlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToMove = nil

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Grey: Too few arguments. Please provide a color/name/id or 'all' or 'clrs'", true)
		return
	end

	playerToMove = getPlayer(args[1])
	if not lowerequals(args[1],"All") and playerToMove == nil and not lowerequals(args[1],"clrs") and not lowerequals(args[1],"colors") then
		msgSelfOrEveryone(theChatter, "Grey: Couldn't find any player matching " .. args[1], true)
		return
	elseif lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") or lowerequals(args[1],"All") then
		for i, clr in pairs(colours) do
			if clr ~= "Grey" then
				Player[clr].changeColor("Grey")
			end
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set everyone to grey.", false)
		return
	elseif playerToMove.color ~= "Grey" then
		playerToMoveName = playerToMove.steam_name
		playerToMove.changeColor("Grey")
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set "..playerToMoveName.." to grey.", false)
	end
end

--help
function broadcastHelp(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local helpMessage = ""

	local MAX_LINES = 20
	local count = 0
	local printedcount = 0
	local max_pages
	for i, value in pairs(commands) do
		if checkPermission(theChatter, value[3]) then
			count = count + 1
		end
	end

	max_pages = math.floor(count / MAX_LINES) + 1
	page_num = 1
	if count > MAX_LINES then
    if #args == 0 then
      page_num = 1
		elseif #args > 0 and args[1] == string.match(args[1],"%d+") then
			page_num = math.min(tonumber(args[1]),max_pages)
		else
			msgSelfOrEveryone(theChatter, "Help: To see available commands in pages type '!help <n>' where <n> is the page number. eg: '!help 0'\n[dddddd]To find help for a specific command, type !help <command>", true)
			return
		end
	end

	count = 0
	for i, value in pairs(commands) do
		if checkPermission(theChatter, value[3]) then ---value[3] is premission required
			section = announceColour..value[1].."[dddddd]".." "..permissionLevel[value[3]]..": "..value[5]
			if page_num == 0 then
				helpMessage = helpMessage..(helpMessage == "" and "Commands: "..announceColour or ", ")..value[1]
			else
				helpMessage = helpMessage..(helpMessage == "" and "" or "\n")..section
			end
			if page_num == math.floor(count / MAX_LINES) + 1 then
				theChatter.print(section)
				printedcount = printedcount + 1
			end
			count = count + 1
		end
	end
	if page_num == 0 then
		theChatter.print(helpMessage)
		helpMessage = helpMessage.."\n[dddddd]"
	end
	section = "To find the help for a specific command type !help <command>."
	theChatter.print(section)
	helpMessage = helpMessage..section

	if page_num == 0 then
	elseif count ~= printedcount then
		section = "This is page "..tostring(page_num).." of "..tostring(max_pages).."." .. (page_num == max_pages and " Type '!help 0' to see a short list of commands." or " Type '!help "..tostring(page_num+1).."' to see the next page.")
		theChatter.print(section)
		helpMessage = helpMessage..section
	end

	if checkPermission(theChatter, 2) then
		copyText = helpMessage
		if onScreen == 2 then
			createCopyText()
		end
	end
end

--hide
function hideBoard(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	useOnTable = false
	self.lock()
	local tempPos = self.getPosition()
	tempPos[2] = tempPos[2]+100
	self.setPosition(tempPos)
	self.interactable = false
	self.setColorTint({0,0,0})
	self.setRotation({0,0,0})
	interact = false
	turnOff()
	Wait.frames(doHide, 10)
	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has hidden the promote board.", false)

end

--hide function
function doHide()
	self.setPosition({1000,1000,1000})
end

--hours
function broadcastHours(tempParameters) --- add colour
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Hours: Too few arguments. Please provide a color,name,id or 'all'.", true)
		return
	end

	if lowerequals(args[1],"all") and theChatter.host then
		local tmp = {}
		for i, v in pairs(Player.getPlayers()) do
			table.insert(tmp,{theChatter.steam_id, v.steam_id, v.steam_name, 1})
		end
		hoursQueue = tmp
		theChatter.print("Getting hours.")
		return
	end
	playerIdToGetHours = isSteamId(args[1]) and args[1] or getPlayerId(args[1])
	if playerIdToGetHours == nil then
		msgSelfOrEveryone(theChatter, "Hours: Couldn't find any player matching "..args[1], true)
		return
	end
	playerToGetHours = getPlayerById(playerIdToGetHours)
	table.insert(hoursQueue,{theChatter.steam_id,playerIdToGetHours,playerToGetHours == nil and "" or playerToGetHours.steam_name,1})
	theChatter.print("Getting hours.")
end

function listenToHoursQueue()
	-- this function repeats infinitely until the object is destroyed
	-- if the line "hoursQueueProcessing = true" does not run within 0.1 seconds of the function being called then there could be several race conditions
	-- currently this function gets hours and waits 2 seconds after the process finishes before requesting more hours.  It will always send another hours request after 15 seconds even if the previous request has not finished
	-- typical request time is 0.7 seconds
	if (not hoursQueueProcessing and Time.time > hoursQueueTime + 2 or Time.time > hoursQueueTime + 15) and next(hoursQueue) ~= nil then
		hoursQueueProcessing = true
		hoursQueueTime = Time.time
		hoursQueueCurrent = table.remove(hoursQueue,1)
		local callerId, playerId, playerName, methodInd = table.unpack(hoursQueueCurrent)

		-- we send a web request and process the output in the function "printTimePlayed"
		-- "printTimePlayed" will update hoursQueueTime and hoursQueueProcessing before exiting
		WebRequest.get("https://steamcommunity.com/profiles/"..playerId.."/games/?tab=recent", self,'printTimePlayed')

	end

end

function printTimePlayed(req)
	-- this function must terminate cleanly without errors so ensure nothing goes wrong
	local JsonRes = nil
	local timePlayed = -1
	local achievementText = ""
	local error_msg = ""
	local json_text,succ,stat,msg
	local callerId, playerId, playerName, methodInd = table.unpack(hoursQueueCurrent)
	if callerId == nil or playerId == nil or playerName == nil or methodInd == nil then
		getHost().broadcast(tostring(announceColour).."'hoursQueue' has been corrupted and has nil values: {"..tostring(callerId)..", "..tostring(playerId)..", "..tostring(playerName).." "..tostring(methodInd).."}")
		--print("Request done in "..tostring((Time.time-hoursQueueTime)).." seconds")
		hoursQueueTime = Time.time
		hoursQueueProcessing = false
		return
	end

	if req.is_done == true then
		if req.is_error ~= true then
			if playerName == "" then
				playerName = string.match(req.text,"persona_name\">([^\t\n\r]*)</span>")
				if playerName == nil then
					playerName = string.match(req.text,"personaName *= *\"([^\t\n\r]*)\";")
					if playerName == nil then
						playerName = string.match(req.text,"<title>Steam Community :: ([^\t\n\r]*) :: Games</title>")
						if playerName == nil then
							playerName = "<unknown>"
						end
					end
				end
			end
			if methodInd == 1 and string.match(req.text, "\"Tabletop Simulator\"") then
				json_text = string.match(req.text,"var rgGames *= *(%[[^\t\n\r]*%]);")
				succ, JsonRes = pcall(JSON.decode,json_text)
				if succ then
					if type(JsonRes) == "table" then
						timePlayed = nil
						for _,stat in pairs(JsonRes) do
							if stat.appid == 286160 then
								timePlayed = stat.hours_forever
								if stat.ach_completion ~= nil and stat.ach_completion.closed ~= nil and stat.ach_completion.total ~= nil and stat.ach_completion.closed > 0 and stat.ach_completion.recent_achievements ~= nil and #(stat.ach_completion.recent_achievements) > 0 and stat.ach_completion.recent_achievements[1].ach_name ~= nil then
									achievementText = " The latest of their "..tostring(stat.ach_completion.closed).."/"..tostring(stat.ach_completion.total).." achievements is "..stat.ach_completion.recent_achievements[1].ach_name.."."
								end
								break
							end
						end
						if timePlayed ~= nil then
							local msg = announceColour..tostring(playerName).." has "..tostring(timePlayed).." hours in Tabletop Simulator."..achievementText
							if callerId ~= "" then
								getPlayerById(callerId).broadcast(msg)
							elseif printHoursOnJoin then
								printToAll(msg)
							else
								print(msg)
							end
							-- print("Request done in "..tostring((Time.time-hoursQueueTime)).." seconds")
							hoursQueueTime = Time.time
							hoursQueueProcessing = false
							return
						else
							error_msg = "Hours: No 'hours_forever' attribute for Tabletop Simulator found."
						end
					else
						error_msg = "Hours: Result is not a valid table."
					end
				else
					error_msg = "Hours: Could not parse json text."
				end
			elseif methodInd == 2 and string.match(req.text, "app/286160") then
				timePlayed = string.match(req.text,"/286160/[^\t\n\r]*</div>%s+<div class=\"hours\">%s+(%S+) hrs on record")
				if timePlayed ~= nil then
					local msg = announceColour..tostring(playerName).." has "..tostring(timePlayed).." hours in Tabletop Simulator."
					if callerId ~= "" then
						getPlayerById(callerId).broadcast(msg)
					elseif printHoursOnJoin then
						printToAll(msg)
					else
						print(msg)
					end
					-- print("Request done in "..tostring((Time.time-hoursQueueTime)).." seconds")
					hoursQueueTime = Time.time
					hoursQueueProcessing = false
					return
				else
					error_msg = "Hours: No 'hours_forever' attribute for Tabletop Simulator found."
				end
			else
				error_msg = "Hours: "..tostring(playerName).." probably has a private steam account and doesn't display TTS hours!"
			end
		else
			error_msg = "Hours: Error reading user's stats from Steam"
		end
	else
		error_msg = "Hours: Request for user's stats from Steam failed to finish."
	end
	if methodInd == 1 then
		hoursQueueCurrent[4] = 2
		WebRequest.get("https://steamcommunity.com/profiles/"..playerId.."/reviews/", self,'printTimePlayed')
		return
	end

	local msg = announceColour..tostring(playerName).." has an unknown number of hours in Tabletop Simulator."
	if callerId == "" then
		printToAll(msg)
	else
		local p = getPlayerById(callerId)
		if p ~= nil then
			p.broadcast(msg)
		end
		p = getPlayer("Banded")
		if p then
			p.print(error_msg)
		end
	end
	--print("Request done in "..tostring((Time.time-hoursQueueTime)).." seconds")
	hoursQueueTime = Time.time
	hoursQueueProcessing = false
end

end

do -- chat commands K-O klmno

function kickPlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToKick = nil

	if #args == 0 then
			msgSelfOrEveryone(theChatter, "Kick: Too few arguments. Please provide a name or 'all'", true)
			return
	end

	playerToKick = getPlayer(args[1])
	if lowerequals(args[1],"All") then
		for i, playerVar in pairs(Player.getPlayers()) do
			playerVar.kick()
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has kicked everyone.", false)
	elseif lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
		for i, clr in pairs(colours) do
			if clr ~= "Grey" then
				Player[clr].kick()
			end
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has kicked everyone who was seated", false)
	elseif playerToKick ~= nil then
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has kicked "..tostring(playerToKick.steam_name), false)
		playerToKick.kick()
	else
		msgSelfOrEveryone(theChatter, "Kick: Couldn't find any player matching " .. args[1], true)
	end
end

function lockBoard(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 and interact == true or #args > 0 and lowerequals(args[1],"on") then
		self.interactable = false
		self.setLock(true)
		interact = false
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has locked the promote board.", false)
	else
		self.interactable = true
		self.setLock(false)
		interact = true
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has unlocked the promote board.", false)
	end
	resetSettingScreen(nil,theChatter.color)
end

function limitPickup(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args > 0 and lowerequals(args[1],"off") then
		maxPickup = -1
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has turned off pickup limit.", false)
	elseif #args > 0 and args[1] == string.match(args[1],"%d+") then
		maxPickup = tonumber(args[1])
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set the pickup limit to: "..tostring(maxPickup), false)
	else
		msgSelfOrEveryone(theChatter, "Limit: Please input a number or 'off'. eg. '!limit 8'", true)
	end
end

function movePlayer(tempParameters) ---<player> <colour/team>
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local selectedPlayer = nil
	local location = firstToUpper(args[2])

	if #args < 2 then
		theChatter.broadcast("Move: Too few arguments. Please provide a name and a color/team")
		return
	end

	selectedPlayer = getPlayer(args[1])
	if selectedPlayer == nil then
		msgSelfOrEveryone(theChatter, "Move: Couldn't find any player matching " .. args[1], true)
		return
	end

	name = selectedPlayer.steam_name
	if isInArray(location,colours) then
		if selectedPlayer.color ~= location and location ~= "Grey" then
			Player[location].changeColor("Grey")
		end
		selectedPlayer.changeColor(location)
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has moved "..name.." to "..location..".", false)
	elseif isInArray(location,teams) then
		selectedPlayer.changeTeam(location)
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has moved "..name.." to "..location..".", false)
	else
		msgSelfOrEveryone(theChatter, "Move: Unrecignized color/team. Please provide a player followed by a color/team", true)
	end

end

function messagePlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToMessage = nil
	--local works = nil

	if #args < 2 then
		msgSelfOrEveryone(theChatter, "Message: Too few arguments. Please provide a name/color and a message", true)
		return
	end

	playerToMessage = getPlayer(args[1])
	if playerToMessage == nil then
		msgSelfOrEveryone(theChatter, "Message: Couldn't find any player matching "..args[1], true)
		return
	end

	table.remove(args, 1)
	local messageToBroadcast = table.concat(args, " ")
	playerToMessage.broadcast(clrToNums[theChatter.color]..theChatter.steam_name..announceColour.."->"..clrToNums[playerToMessage.color]..playerToMessage.steam_name..": [ffffff]"..messageToBroadcast)
	theChatter.broadcast(clrToNums[theChatter.color]..theChatter.steam_name..announceColour.."->"..clrToNums[playerToMessage.color]..playerToMessage.steam_name..": [ffffff]"..messageToBroadcast)
end

function unmutePlayer(tempParameters)
	mutePlayer(tempParameters, true)
end

mutePlayer_cache = nil
function mutePlayer(tempParameters, unmute)
	unmute = unmute == true -- default when not provided is false
  	
	-- no way to tell if a player is muted or not, so try and keep track of it ourselves
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Mute: Too few arguments. Please provide a color/id/name or 'all' or 'colors' or 'grey'.", true)
		return
	end
	
	local people = nil
	if lowerequals(args[1],"All") then
		people = "all"
		muteAllPlayers = true
	elseif lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
		people = "colors"
	elseif lowerequals(args[1],"Grey") then
		people = "grey"
	end

	if unmute then
		todo = "undo"
	else
		if args[2] ~= nil and lowerequals(args[2],"un") then
			todo = "undo"
		elseif args[2] ~= nil and lowerequals(args[2],"reg") then
			todo = "do"
		else
			todo = "tog"
			if people == "all" then
				muteAllPlayers = true
			end
		end
	end
		
	local playerIdToMute = getPlayerId(args[1])
	if people ~= nil then
		for i, playerVar in pairs(Player.getPlayers()) do
			if people == "all" or people == "grey" and playerVar.color == "Grey" or playerVar.color ~= "Grey" then
				local chatterId = playerVar.steam_id
				if todo == "do" then
					if muted[chatterId] == nil then
						muted[chatterId] = playerVar.steam_name
						playerVar.mute()
					end
				elseif todo == "undo" then
					if muted[chatterId] != nil then
						muted[chatterId] = nil
						playerVar.mute()
					end
					muteAllPlayers = false
				else -- toggle
					muted[chatterId] = muted[chatterId] == nil and playerVar.steam_name or nil
					playerVar.mute()
					if muted[chatterId] == nil then
						muteAllPlayers = false
					end
				end
			end
		end
		if people == "all" and todo == "undo" then
			muted = {}
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(todo == "tog" and "toggled mute for" or (todo == "undo" and "un-muted" or "muted")).." all players.", false)
	elseif playerIdToMute ~= nil then
		local playerNameToMute = getPlayerName(playerIdToMute) or playerIdToMute
		local playerToMute = getPlayer(playerIdToMute)
		
		local prevState = muted[playerIdToMute]
		
		if todo == "do" then
			if muted[playerIdToMute] == nil then
				muted[playerIdToMute] = playerNameToMute
				if playerToMute then
					playerToMute.mute()
				end
			end
		elseif todo == "undo" then
			if muted[playerIdToMute] ~= nil then
				muted[playerIdToMute] = nil
				if playerToMute then
					playerToMute.mute()
				end
			end
			muteAllPlayers = false
		else -- toggle
			muted[playerIdToMute] = muted[playerIdToMute] == nil and playerNameToMute or nil
			if playerToMute then
				playerToMute.mute()
			end
			if muted[playerIdToMute] == nil then
				muteAllPlayers = false
			end
		end
		if prevState == muted[playerIdToMute] then
			theChatter.broadcast("Player "..tostring(playerNameToMute).." was already "..(muted[playerIdToMute] == nil and "un-" or "").."muted and nothing changed.", false)
		else
			msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(muted[playerIdToMute] == nil and "un-" or "").."muted "..tostring(playerNameToMute)..".", false)
		end
	else
		msgSelfOrEveryone(theChatter, "Mute: Couldn't find any player matching " .. args[1], true)
	end

  if mutePlayer_cache ~= nil then
    local last_cmd, last_tm = table.unpack(mutePlayer_cache)
    if last_cmd == printTable(args,true) and Time.time - last_tm < 5 then
      theChatter.broadcast("Manually muting someone desyncs the game from the board's mute state. To resync a person, manually change their mute status.")
      theChatter.broadcast("Disclaimer: Mute status is undetectable.")
    end
  end

  mutePlayer_cache = {printTable(args,true),Time.time}
end

end

do --- chat commands N-Z

function nickPlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerIdToNick = nil
	local newName = nil

	if #args > 1 then

		playerIdToNick = getPlayerId(args[1])
		if playerIdToNick == nil then
			msgSelfOrEveryone(theChatter, "Nick: Couldn't find any player matching " .. args[1], true)
			return
		end
		playerNameToNick = getPlayerName(playerIdToNick) or playerIdToNick

		table.remove(args, 1)
		newName = table.concat(args, " ")
		nicknames[playerIdToNick] = newName
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has nicknamed "..tostring(playerNameToNick).." to "..newName, false)

	elseif #args == 1 then

		if lowerequals(args[1],"Clear") then
			nicknames = {}
			msgSelfOrEveryone(theChatter, theChatter.steam_name.." has cleared all nicknames.", false)
			return
		else
			playerIdToNick = getPlayerId(args[1])
			if playerIdToNick == nil then
				msgSelfOrEveryone(theChatter, "Nick: Couldn't find any player matching " .. args[1], true)
				return
			end
			playerNameToNick = getPlayerName(playerIdToNick) or playerIdToNick
			if nicknames[playerIdToNick] ~= nil then
				nicknames[playerIdToNick] = nil
				msgSelfOrEveryone(theChatter, theChatter.steam_name.." has removed the nickname for "..tostring(playerNameToNick)..".", false)
			else
				msgSelfOrEveryone(theChatter, "Nick: The player "..tostring(playerNameToNick).." has no nickname to remove.", true)
			end
		end

	else
		msgSelfOrEveryone(theChatter, "Nick: Too few arguments. Please provide a color,name or id.", true)
		return
	end
end



end

do -- chat commands P-T pqrst

function permakickPlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToPermakick = nil
	local permakickId = nil
	local permakickName = nil

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Permakick: Too few arguments. Please provide a name,color,id or 'list' or 'clear'.", true)
		return
	end

	if #args > 0 and lowerequals(args[1],"Clear") then
		permakicked = {}
		msgSelfOrEveryone(theChatter, "Permakick list has been cleared.", false)
		return
	end

	if #args > 0 and lowerequals(args[1],"list") then
		s = "Permakicked List:"
		for id,nick in pairs(permakicked) do
			s = s.."\n"..id.."("..nick..")"
		end
		msgSelfOrEveryone(theChatter, s, true)
		copyText = s
		if onScreen == 2 then
			createCopyText()
		end
		return
	end

	permakickId = getPlayerId(args[1])
	if permakickId == nil then
		msgSelfOrEveryone(theChatter, "Permakick: Could not find any player matching "..args[1], true)
		return
	end

	permakickName = getPlayerName(permakickId)
	if permakicked[permakickId] == nil then
		permakicked[permakickId] = permakickName ~= nil and permakickName or permakickId
		p = getPlayerById(permakickId)
		if p ~= nil then
			p.kick()
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has permakicked "..tostring(permakicked[permakickId])..".", false)
	else
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has removed permakick from "..tostring(permakicked[permakickId])..".", false)
		permakicked[permakickId] = nil
	end
end

function playArea(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		Physics.play_area = 0.5
		msgSelfOrEveryone(theChatter, "play area: games play area has now been set to 0.5", false)
	elseif tonumber(args[1]) ~= nil then
		Physics.play_area = tonumber(args[1])
		msgSelfOrEveryone(theChatter, "play area: games play area has now been set to "..tostring(tonumber(args[1])), false)
	else
		msgSelfOrEveryone(theChatter, "play area: could not recognize "..args[1].." as a number", true)
	end
end

function demotePlayer(tempParameters)
	promotePlayer(tempParameters,true)
end

function promotePlayer(tempParameters,isDemote)
	isDemote = isDemote == true -- default is false
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local playerToPromote = nil

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Promote: Too few arguments. Please provide a color,name,id or 'all'", true)
		return
	end
	if isInArray("un",args,lowerequals) or isInArray("reg",args,lowerequals) then
		msgSelfOrEveryone(theChatter, "Promote: 'un' and 'reg' were removed. See '!demote' or '!help promote'.", true)
	end

	playerToPromote = getPlayer(args[1])
	local isAll = lowerequals(args[1],"All")
	if isAll or lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
		for i, playerVar in pairs(Player.getPlayers()) do
			if not playerVar.host and playerVar.promoted == isDemote and (isAll or playerVar.color ~= "Grey") then
				playerVar.promote()
			end
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(isDemote and "de" or "pro").."moted all "..(isAll and "" or "seated ").."players.", false)
	elseif playerToPromote == nil then
		msgSelfOrEveryone(theChatter, "Promote: Couldn't find any player matching "..args[1], true)
	else
		-- if isDemote then only ever demote the player, otherwise toggle
		if isDemote and playerToPromote.promoted or not playerToPromote.host then
			playerToPromote.promote()
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(playerToPromote.promoted and "pro" or "de").."moted "..playerToPromote.steam_name, false)
	end
end

pollActive = false
function startPoll(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local i, v
	
	if #args > 0 and lowerequals(args[1],"remind") then
		if not pollActive then
			theChatter.broadcast("No poll has been started.")
			return
		end
		local optionText = ""

		for i, v in pairs(pollOptions) do
			optionText = optionText..(optionText == "" and "" or "   ") .. tostring(i) .. ":" .. v
		end

		broadcastToAll(announceColour.."Poll: "..pollQuestion.."See chat for options.")
		printToAll("Type your vote in chat\n"..optionText)

		votesOnOptions = {}
		pollActive = true
		return
	elseif #args > 0 and lowerequals(args[1],"end") then
		if not pollActive then
			theChatter.broadcast("No poll has been started.")
			return
		end
		voteCounts = {}
		for i, v in pairs(pollOptions) do
			voteCounts[i] = {0,v}
		end

		--tally votes and sort by most votes
		for i, v in pairs(votesOnOptions) do
			voteCounts[v][1] = voteCounts[v][1] + 1
		end
		table.sort(voteCounts,function(v1,v2) return v1[1] > v2[1] end)
		tallyText = ""
		for i, v in pairs(voteCounts) do
			if (i == 1 or v[1] == voteCounts[1][1]) and v[1] > 0 then
				tallyText = tallyText..(tallyText == "" and "" or " ")..announceColour.."The winner is [dddddd]"..v[2]..announceColour.." with "..tostring(v[1]).." vote"..(v[1] == 1 and "" or "s").."!"
			else
				tallyText = tallyText..(tallyText == "" and "" or "   ").."[dddddd]"..v[2]..announceColour.." has "..tostring(v[1]).." vote"..(v[1] == 1 and "" or "s").."."
			end
		end

		broadcastToAll(tallyText)
		pollActive = false
	elseif #args >= 2 then
		if pollActive then
			theChatter.broadcast("Poll already started. Say '!poll end' or '!poll remind' to view the poll.")
			return
		end

    local pollMessage = table.concat(args," ")
    pollQuestion = nil
    pollOptions = {}
		votesOnOptions = {}
    for s in string.gmatch(pollMessage, "[^,]+") do
      s = s:gsub("^%s*(.*%S+)%s*$", "%1"):gsub("^%s+$","")
      if pollQuestion == nil then
        pollQuestion = s
      else
        table.insert(pollOptions,s)
      end
    end    
    
		local optionText = ""

		for i, v in pairs(pollOptions) do
			optionText = optionText..(optionText == "" and "" or "   ") .. tostring(i) .. ":" .. v
		end

		broadcastToAll(announceColour..theChatter.steam_name.." started a poll \""..pollQuestion.."\"  See chat for options.")
    printToAll("Type your vote in chat\n"..optionText)
		pollActive = true
		return
	else
    if pollActive == true then
      theChatter.broadcast("Poll already started. Say '!poll end' or '!poll remind' to view the poll.")
    else
      msgSelfOrEveryone(theChatter, "Poll: To start a poll say '!poll <question>,<option1>,<option2>,<option3>,...' and list out the options separated by commas. eg:'!poll What's your favourite smoothie?,vanilla, chocolate, strawberry' You can also say '!poll end' or '!poll remind'", true)
    end
	end

end

function printHours(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	printHoursOnJoin = not printHoursOnJoin

	resetSettingScreen(nil,theChatter.color)
	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has set print hours on join to: "..(printHoursOnJoin and "on" or "off"), false)
end

function CommandPrinting(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	printCommands = not printCommands

	resetSettingScreen(nil,theChatter.color)
	printToAll(announceColour..theChatter.steam_name.." has set print commands to: "..tostring(printCommands), white)
end

function resetBoard(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	announceColour = "[1ac6ff]"
	nicknames = {}
	silenced = {}
	permakicked = {}
	chatCommands = true
	autoPromote = false
	greyBT = false
	kickBT = false
	self.interactable = true
	self.setLock(false)
	interact = true
	printCommands = false
	printHoursOnJoin = false

	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has reset the promote board.", false)
end

function rainbowChat(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	-- credit for this idea goes to King Psychospud7 on steam.
	--This isnt exactly copied from him, but it's made to be basically the same.

	local rainbowColourrgb = {}
	rainbowColourrgb[math.random(1,3)] = 255

	local emptySlots = {0,0}
	for i = 1, 3 do
		if rainbowColourrgb[i] == nil and emptySlots[1] == 0 then
			emptySlots[1] = i
		elseif rainbowColourrgb[i] == nil then
			emptySlots[2] = i
			rainbowColourrgb[emptySlots[math.random(1,2)]] = math.random(0,255)
			if rainbowColourrgb[i] ~= nil then
				rainbowColourrgb[emptySlots[1]] = 0
				onSection = i*2-1
			else
				rainbowColourrgb[i] = 0
				onSection = emptySlots[1]*2-1
			end
		end
	end

	--[[

	1 = 1
	2 = 3
	3 = 5

	]]--


	local rainbowMessage = ""
	local message = table.concat(args, " ")
	local incriment = 40
	local extraInc = 0

	for i = 1, #message do

		if onSection == 3 then
			rainbowColourrgb = {255, rainbowColourrgb[2] + incriment+extraInc, 0}

		elseif onSection == 4 then
			rainbowColourrgb = {rainbowColourrgb[1] - incriment-extraInc, 255, 0}


		elseif onSection == 5 then
			rainbowColourrgb = {0, 255, rainbowColourrgb[3] + incriment+extraInc}

		elseif onSection == 6 then
			rainbowColourrgb = {0, rainbowColourrgb[2] - incriment-extraInc, 255}

		elseif onSection == 1 then
			rainbowColourrgb = {rainbowColourrgb[1] + incriment+extraInc, 0, 255}

		elseif onSection == 2 then
			rainbowColourrgb = {255, 0, rainbowColourrgb[3] - incriment-extraInc}
		end

		for i = 1, 3 do
			if rainbowColourrgb[i] > 255 then
				extraInc = rainbowColourrgb[i]-255
				rainbowColourrgb[i] = 255
				onSection = onSection + 1
			elseif rainbowColourrgb[i] < 0 then
				extraInc = math.abs(rainbowColourrgb[i])
				rainbowColourrgb[i] = 0
				onSection = onSection + 1
			end
		end

		if onSection == 7 then
			onSection = 1
		end

		local colourString = "["
		for index = 1, #rainbowColourrgb do
			colourString = colourString .. string.format("%.2x", rainbowColourrgb[index])
		end
		colourString = colourString .. "]"


		rainbowMessage = rainbowMessage .. colourString .. string.sub(message, i, i) .. "[-]"
	end

	copyText = ""..string.gsub(rainbowMessage,"%[([0-9A-Fa-f][0-9A-Fa-f]+)%]","[#%1]")
	if onScreen == 2 then createCopyText() end
	if nicknames[theChatter.steam_id] ~= nil then
		printToAll(nicknames[theChatter.steam_id]..": [ffffff]"..rainbowMessage, theChatter.color)
		return
	end
	printToAll(theChatter.steam_name..": [ffffff]"..rainbowMessage, theChatter.color)
end

function firstPlayer()
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local includeBlack = false
	local includeSpecs = false

	if #args > 0 and args[1] == "2" then
		includeBlack = true
	elseif #args > 0 and args[1] == "3" then
		includeSpecs = true
	elseif #args > 0 and args[1] == "4" then
		includeBlack = true
		includeSpecs = true
	elseif #args > 0 and args[1] ~= "1" then
		msgSelfOrEveryone(theChatter, "First player: invalid mode. Type '!help first' for help.", true)
		return
	end

	local shufflePlayers = {}

	for i, value in pairs(Player.getPlayers()) do
		if value ~= nil and (value.color ~= "Grey" or includeSpecs) and (value.color ~= "Black" or includeBlack) then
			table.insert(shufflePlayers, {n = value.steam_name, c = value.color})
		end
	end
	if #shufflePlayers > 0 then
		local tempRandInt = math.random(#shufflePlayers)
		randp = shufflePlayers[tempRandInt]
		printToAll(announceColour..theChatter.steam_name.." rolled for a random first player"..(#args > 0 and " mode:seated"..(includeSpecs and "+spectators" or "")..(includeBlack and "+black" or "") or "").." and got: "..clrToNums[randp.c]..randp.n,white)
	else
		msgSelfOrEveryone(theChatter, "First player: There are no players to choose from.", true)
	end
end

function rollDice(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local sides = nil
	local numberOfDice = nil
	local rolledTotal = nil

	aggregatedArgs = table.concat(args," ")
	local parts = {}
	for s in string.gmatch(aggregatedArgs, "%d+") do
		parts[#parts+1] = s
		if #parts >= 2 then
			break
		end
	end

	if #parts == 0 then
		numberOfDice = 1
		sides = 6
	elseif #parts == 1 then
		numberOfDice = 1
		sides = tonumber(parts[1])
	else
		numberOfDice = tonumber(parts[1])
		sides = tonumber(parts[2])
	end

	if numberOfDice > 10000 then
		msgSelfOrEveryone(theChatter, "Roll: "..numberOfDice.." dice is too many dice.", true)
		return
	elseif sides > 2e9 then
		msgSelfOrEveryone(theChatter, "Roll: "..sides.." sides is too many sides.", true)
		return
	end

	local total = 0
	if numberOfDice > 0 and sides > 0 then
		for i=1, numberOfDice do
			total = total + math.random(1,sides)
		end
	end

	printToAll(announceColour..theChatter.steam_name.." has rolled "..numberOfDice.." d"..sides..(numberOfDice == 1 and "" or "s").." and rolled a: "..total,white)
end

function seenPlayersList(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local text = ""

	for id, nick in pairs(allSeenPlayers) do
		text = text .. (text == "" and "" or "\n") .. tostring(id) .. " : " .. tostring(nick)
	end
	copyText = text
	if onScreen == 2 then
		createCopyText()
	end
	msgSelfOrEveryone(theChatter,theChatter.steam_name .. " has copied seen players to the text box.",false)
end

function unsilencePlayer(tempParameters)
	silencePlayer(tempParameters, true)
end

function silencePlayer(tempParameters, unsilence)
	unsilence = unsilence == true -- default when not provided is false
	
	-- no way to tell if a player is muted or not, so try and keep track of it ourselves
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Silence: Too few arguments. Please provide a color/id/name or 'all' or 'colors' or 'grey'.", true)
		return
	end
	
	local people = nil
	if lowerequals(args[1],"All") then
		people = "all"
		muteAllPlayers = true
		silenceAllPlayers = true
	elseif lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
		people = "colors"
	elseif lowerequals(args[1],"Grey") then
		people = "grey"
	end

	if unsilence then
		todo = "undo"
	else
		if args[2] ~= nil and lowerequals(args[2],"un") then
			todo = "undo"
		elseif args[2] ~= nil and lowerequals(args[2],"reg") then
			todo = "do"
		else
			todo = "tog"
			if people == "all" then
				muteAllPlayers = true
				silenceAllPlayers = true
			end
		end
	end
		
	local playerIdToSil = getPlayerId(args[1])
	if people ~= nil then
		for i, playerVar in pairs(Player.getPlayers()) do
			if people == "all" or people == "grey" and playerVar.color == "Grey" or playerVar.color ~= "Grey" then
				local chatterId = playerVar.steam_id
				if todo == "do" then
					silenced[chatterId] = playerVar.steam_name
					if muted[chatterId] == nil then
						muted[chatterId] = playerVar.steam_name
						playerVar.mute()
					end
				elseif todo == "undo" then
					silenced[chatterId] = nil
					if muted[chatterId] != nil then
						muted[chatterId] = nil
						playerVar.mute()
					end
					silenceAllPlayers = false
					muteAllPlayers = false
				else -- toggle
					silenced[chatterId] = silenced[chatterId] == nil and playerVar.steam_name or nil
					if (muted[chatterId] == nil) ~= (silenced[chatterId] == nil) then
						muted[chatterId] = silenced[chatterId]
						playerVar.mute()
					end
					if silenced[chatterId] == nil then
						silenceAllPlayers = false
					end
					if muted[chatterId] == nil then
						muteAllPlayers = false
					end
				end
			end
		end
		if people == "all" and todo == "undo" then
			silenced = {}
			muted = {}
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(todo == "tog" and "toggled silence for" or (todo == "undo" and "un-silenced" or "silenced")).." all players.", false)
	elseif playerIdToSil ~= nil then
		local playerNameToSil = getPlayerName(playerIdToSil) or playerIdToSil
		local playerToSil = getPlayer(playerIdToSil)
		
		local prevState = silenced[playerIdToSil]
		
		if todo == "do" then
			silenced[playerIdToSil] = playerNameToSil
			if muted[playerIdToSil] == nil then
				muted[playerIdToSil] = playerNameToSil
				if playerToSil then
					playerToSil.mute()
				end
			end
		elseif todo == "undo" then
			silenced[playerIdToSil] = nil
			if muted[playerIdToSil] ~= nil then
				muted[playerIdToSil] = nil
				if playerToSil then
					playerToSil.mute()
				end
			end
			silenceAllPlayers = false
			muteAllPlayers = false
		else -- toggle
			silenced[playerIdToSil] = silenced[playerIdToSil] == nil and playerNameToSil or nil
			if (muted[playerIdToSil] == nil) ~= (silenced[playerIdToSil] == nil) then
				muted[playerIdToSil] = silenced[playerIdToSil]
				if playerToSil then
					playerToSil.mute()
				end
			end
			if silenced[playerIdToSil] == nil then
				silenceAllPlayers = false
			end
			if muted[playerIdToSil] == nil then
				muteAllPlayers = false
			end			
		end
		if prevState == silenced[playerIdToSil] then
			theChatter.broadcast("Player "..tostring(playerNameToSil).." was already "..(silenced[playerIdToSil] == nil and "un-" or "").."silenced and nothing changed.", false)
		else
			msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(silenced[playerIdToSil] == nil and "un-" or "").."silenced "..tostring(playerNameToSil)..".", false)
		end
	else
		msgSelfOrEveryone(theChatter, "Silence: Couldn't find any player matching " .. args[1], true)
	end
end

function setAnnounceColour(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		announceColour = "[1ac6ff]"
		theChatter.broadcast(announceColour.."Announce Color: this is the new announce color.")
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has changed the announce color", false)
		return
	end

	ind = findInArray(firstToUpper(args[1]),colours)
	if ind ~= nil then
		announceColour = clrnums[ind]
		theChatter.broadcast(announceColour.."Announce Color: this is the new announce color.")
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has changed the announce color to "..colours[ind], false)
		return
	end
	if args[1] ~= string.match(args[1],"[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]") then
		theChatter.broadcast("Announce Color: The argument must be a RGB hex code (eg. 0f8fe1) or the name of a color.")
		return
	end
	announceColour = "["..args[1].."]"
	theChatter.broadcast(announceColour.."Announce Color: this is the new announce color.")
	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has changed the announce color to #"..string.sub(announceColour,2,#announceColour - 1), false)
end

function broadcastStatus(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local stringsToPrint = {}

	table.insert(stringsToPrint,"autoPromote: "..tostring(autoPromote))
	table.insert(stringsToPrint,"greyBT: "..tostring(greyBT))
	table.insert(stringsToPrint,"kickBT: "..tostring(kickBT))
	table.insert(stringsToPrint,"interact: "..tostring(interact))
	table.insert(stringsToPrint,"limit: "..tostring(maxPickup))
	table.insert(stringsToPrint,"printCommands: "..tostring(printCommands))
	table.insert(stringsToPrint,"printHoursOnJoin: "..tostring(printHoursOnJoin))

	if next(permakicked) ~= nil then
		table.insert(stringsToPrint,"")
		table.insert(stringsToPrint,"permakicked:")
		for i, value in pairs(permakicked) do ---i is the name of the section of the dictionary
			if getPlayerById(i) ~= nil then
				table.insert(stringsToPrint,i.." ("..getPlayerById(i).steam_name..") - "..tostring(value))
			else
				table.insert(stringsToPrint,i.." - "..tostring(value))
			end
		end
	end

	if next(nicknames) ~= nil then
		table.insert(stringsToPrint,"")
		table.insert(stringsToPrint,"Nicknames:")
		for i, value in pairs(nicknames) do ---i is the name of the section of the dictionary
			if getPlayerById(i) ~= nil then
				table.insert(stringsToPrint,i.." ("..getPlayerById(i).steam_name..") - "..tostring(value))
			else
				table.insert(stringsToPrint,i.." - "..tostring(value))
			end
		end
	end

	if next(silenced) ~= nil then
		table.insert(stringsToPrint,"")
		table.insert(stringsToPrint,"silenced:")
		for i, value in pairs(silenced) do
			table.insert(stringsToPrint,tostring(i).." ("..tostring(value)..")")
		end
	end

	if next(trusted) ~= nil then
		table.insert(stringsToPrint,"")
		table.insert(stringsToPrint,"trusted:")
		for i, value in pairs(trusted) do
			if getPlayerById(i) ~= nil then
				table.insert(stringsToPrint,i.." ("..getPlayerById(i).steam_name..") - "..tostring(value))
			else
				table.insert(stringsToPrint,i.." - "..tostring(value))
			end
		end
	end

	local MAX_LINES = 30
	local page_num = 1
	local max_pages = math.floor(#stringsToPrint / MAX_LINES) + 1
  if #args == 0 then
    page_num = 1
  elseif #args > 0 and args[1] == string.match(args[1],"%d+") then
    page_num = math.min(tonumber(args[1]),max_pages)
  end
  msgSelfOrEveryone(theChatter,"Status:",true)
  for i,v in pairs(stringsToPrint) do
    if math.floor((i-1) / MAX_LINES) + 1 == page_num then
      msgSelfOrEveryone(theChatter,v,true)
    end
  end
  if max_pages > 1 then
    theChatter.broadcast("This is page "..tostring(page_num).." of "..tostring(max_pages).."."..(page_num == max_pages and "" or " Type '!status "..tostring(page_num+1).."' to see the next page."))
  end

	copyText = table.concat(stringsToPrint,"\n")
	if onScreen == 2 then
		createCopyText()
	end

end

function getSteamId(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Steam ID: Please input an argument. (color/name/id or 'all', 'clrs')", true)
		return
	end

	if string.lower(args[1]) == "all" or string.lower(args[1]) == "clrs" or string.lower(args[1]) == "colors" then
		copyText = ""
		for i, playerVar in pairs(Player.getPlayers()) do
			if playerVar.color ~= "Grey" or string.lower(args[1]) == "all" then
				msgSelfOrEveryone(theChatter, playerVar.steam_name.."'s steam id: "..playerVar.steam_id, true)
				copyText = copyText..playerVar.steam_id.."\n"
			end
		end
		if onScreen == 2 then
			createCopyText()
		end
		return
	end

	local playerId = getPlayerId(args[1])
	if playerId ~= nil then
		local playerName = getPlayerName(playerId) or playerId
		msgSelfOrEveryone(theChatter, tostring(playerName).."'s steam id: "..playerId, true)
		copyText = playerId
		if onScreen == 2 then
			createCopyText()
		end
	else
		msgSelfOrEveryone(theChatter, "Steam ID: No players found under set conditions.", true)
	end

end

function shufflePlayers(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local includeBlack = false
	local includeSpecs = false

	if #args > 0 and args[1] == "2" then
		includeBlack = true
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has shuffled the players (including black)", false)
	elseif #args > 0 and args[1] == "3" then
		includeSpecs = true
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has shuffled the players (including spectators)", false)
	elseif #args > 0 and args[1] == "4" then
		includeBlack = true
		includeSpecs = true
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has shuffled the players (including black and spectators)", false)
	else
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has shuffled the seated players", false)
	end

	local shufflePlayers = {}
	local playerColours = {}

	for i, value in pairs(Player.getPlayers()) do
		if value ~= nil and value.steam_id ~= nil and value.color ~= "Grey" and (value.color ~= "Black" or includeBlack) then
			table.insert(playerColours, value.color)
			table.insert(shufflePlayers, value)
			--value.changeColor("Grey")
		elseif value ~= nil and value.steam_id ~= nil and value.color == "Grey" and includeSpecs then
			table.insert(shufflePlayers, value)
		end
	end

	for i, value in pairs(playerColours) do
		if #shufflePlayers > 1 then
			local tempRandInt = math.random(#shufflePlayers)
			if Player[playerColours[i]] ~= nil and Player[playerColours[i]].steam_id ~= nil then
				Player[playerColours[i]].changeColor("Grey")
			end
			shufflePlayers[tempRandInt].changeColor(playerColours[i])
			table.remove(shufflePlayers, tempRandInt)
		else
			shufflePlayers[1].changeColor(playerColours[i])
		end
	end
end

function superlockObject(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if theChatter.getSelectedObjects() == nil or #theChatter.getSelectedObjects() == 0 then
		msgSelfOrEveryone(theChatter, "Superlock: Could not find a selected object. Please select an unlocked object or right click a locked object and try again.", true)
		return
	end
  
  local name_text = ""
  for _, o in pairs(theChatter.getSelectedObjects()) do
    o.interactable = false
    name_text = name_text .. (name_text == "" and "" or ", ") .. o.name .. "("..o.guid..")"
  end

	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has made the following object(s) uniteractable: "..name_text, false)
end

function swapPlayer(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args
	local player1ToSwap = nil
	local player2ToSwap = nil

	if #args < 2 then
		msgSelfOrEveryone(theChatter, "Swap: Too few arguments. Please provide two names or two colors", true)
		return
	end

	player1 = getPlayer(args[1])
	if player1 == nil then
		ind = findInArray(args[1],colours,lowerequals)
		if ind == nil then
			msgSelfOrEveryone(theChatter, "Swap: Couldn't find any player matching " .. args[1], true)
			return
		end
		player1Id = nil
		player1Color = colours[ind]
	else
		player1Id = player1.steam_id
		player1Color = player1.color
	end

	player2 = getPlayer(args[2])
	if player2 == nil then
		ind = findInArray(args[2],colours,lowerequals)
		if ind == nil then
			msgSelfOrEveryone(theChatter, "Swap: Couldn't find any player matching " .. args[2], true)
			return
		end
		player2Id = nil
		player2Color = colours[ind]
	else
		player2Id = player2.steam_id
		player2Color = player2.color
	end

	if player1Color ~= player2Color then
		if player1Id ~= nil then
			getPlayerById(player1Id).changeColor("Grey")
		end
		if player2Id ~= nil then
			getPlayerById(player2Id).changeColor(player1Color)
		end
		if player1Id ~= nil then
			getPlayerById(player1Id).changeColor(player2Color)
		end
	end

	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has swapped "..player1Color.." with "..player2Color..".", false)
end

function broadcastTest(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	msgSelfOrEveryone(theChatter, "Promote Board currently on the table.", false)
end

function untrustPlayer(tempParameters)
	table.insert(tempParameters.args,1,"remove")
	trustAddRemove(tempParameters)
end

function trustAddRemove (tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if #args == 1 and lowerequals(args[1],"clear") or #args == 2 and lowerequals(args[1],"remove") and lowerequals(args[2],"all") then
		trusted = {}
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has cleared the trusted list.", false)
		resetSettingScreen("unused", theChatter.color)
		return
	end

	local playerId = nil
	local whatToDo = "one"
	local isItAdd = true

	--- <Optional:'add'(default)/'remove'/'clear'> <colour/id/name/'all'/'clrs'/'colours'> <Optional: nickname(spaces accepted)/'name'(uses steam name)>

	-- determine whether to add or remove, add by default
	if #args >= 1 and (lowerequals(args[1],"add") or lowerequals(args[1],"remove")) then
		if lowerequals(args[1],"remove") then
			isItAdd = false
		end
		table.remove(args, 1)
	end

	nickname = nil
	-- concatenate all final arguments if more than 1
	if isItAdd and #args >= 2 then
    -- check if is list of steam ids
    hasAllSteamIds = true
    for i,v in pairs(args) do
      if not isSteamId(v) then
        hasAllSteamIds = false
        break
      end
    end
    if hasAllSteamIds then
      whatToDo = "steamIdList"
    else
      nickname = table.concat({table.unpack(args,2)}," ")
      args = {args[1]}
    end
	elseif not isItAdd and #args >= 1 then
		args = {table.concat(args," ")}
	end
	if #args == 0 then
		msgSelfOrEveryone(theChatter, "Trust: Please at least provide a name/id/colur of a person on the table to add.", true)
		return
	else
		if lowerequals(args[1],"all") then
			whatToDo = "all"
		elseif lowerequals(args[1],"Clrs") or lowerequals(args[1],"Colors") then
			whatToDo = "colors"
		else
			if isSteamId(args[1]) then
				playerId = args[1]
			else
				playerId = getPlayerId(args[1])
			end
			if playerId == nil then -- search for an id suffix in trusted table and in players
				playerId = getFullIdFromShortId(args[1])
			end
			if playerId == nil then -- try and find the value in trusted nicknames
				playerId = findInArray(args[1],trusted,lowerequals)
			end
		end
	end
	if whatToDo == "one" then
		if playerId == nil then
			msgSelfOrEveryone(theChatter, "Trust: No player could be found that matches "..args[1], true)
			return
		else
			if trusted[playerId] ~= nil and isItAdd and nickname == nil then
				msgSelfOrEveryone(theChatter, "Trust: This player is already trusted under nickname "..trusted[playerId]..(trusted[playerId] == playerId and "" or "("..playerId..")"), true)
				return
			elseif trusted[playerId] == nil and not isItAdd then
				msgSelfOrEveryone(theChatter, "Trust: "..args[1].." player was not found in trusted list.", true)
				return
			end
		end
		player = getPlayerById(playerId)
		if player then
			printedname = player.steam_name
		else
			printedname = getPlayerName(playerId) or playerId
		end
			

		posted_message = theChatter.steam_name.." has "..(isItAdd and "added" or "removed").." "..printedname.." "..(isItAdd and "to" or "from").." auto promote. ("..playerId..")"
		if isItAdd then
			if nickname == nil or lowerequals(nickname,"name") and player == nil then
				trusted[playerId] = playerId
			else
				if trusted[playerId] ~= nil then
					posted_message = theChatter.steam_name.." has changed "..printedname.."'s label in the auto promote list. ("..playerId..")"
				end
				if lowerequals(nickname,"name") then
					trusted[playerId] = player.steam_name
				else
					trusted[playerId] = nickname
				end
			end
		else
			trusted[playerId] = nil
			player = getPlayerById(playerId)
		end
		msgSelfOrEveryone(theChatter, posted_message, false)
  elseif whatToDo == "steamIdList" then
    for i,v in pairs(args) do
			trusted[v] = isItAdd and v or nil
    end
	else
		for i, playerVar in pairs(Player.getPlayers()) do
			if whatToDo == "all" or isColorAndSeated(playerVar.color) then
				if isItAdd and trusted[playerVar.steam_id] == nil then
					if isInArray(playerVar.steam_name,trusted,lowerequals) then
						trusted[playerVar.steam_id] = playerVar.steam_id
					else
						trusted[playerVar.steam_id] = playerVar.steam_name
					end
				elseif not isItAdd then
					trusted[playerVar.steam_id] = nil
				end
			end
		end
		msgSelfOrEveryone(theChatter, theChatter.steam_name.." has "..(isItAdd and "added" or "removed").." all "..(whatToDo == "all" and "players" or "colors").." "..(isItAdd and "to" or "from").." auto promote.", false)
	end
	resetSettingScreen("unused", theChatter.color)
	promoteThePlayers()
end

end

do -- chat commands U-Z uvwxyz

function uploadCode(tempParameters)
	local theChatter = tempParameters.theChatter
	local args = tempParameters.args

	if lowerequals(args[1],"global") then
		Global.setLuaScript(copyText)
		return
	end

	if theChatter.getHoverObject() == nil then
		msgSelfOrEveryone(theChatter, "Upload: Could not find hover object. Please place your hand over an unlocked object and try again.", true)
		return
	end

	theChatter.getHoverObject().setLuaScript(copyText)
	theChatter.getHoverObject().reload()

	msgSelfOrEveryone(theChatter, theChatter.steam_name.." has uploaded the code from the copy text box to the object: "..(theChatter.getHoverObject().name).." ("..(theChatter.getHoverObject().guid)..")", false)
end

end