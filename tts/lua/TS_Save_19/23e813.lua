--This method is called BEFORE any object is spawned on table by BagExplorer.
--You can change any spawn parameters in this method.
--playerColor - https://api.tabletopsimulator.com/player/colors/
--spawnParameters - https://api.tabletopsimulator.com/base/#spawnobjectdata-spawn-parameters
--spawnByDrag - true if object is going to be spawned by dragging related button from BagExplorer to Table, false if button was clicked.
function onBeforeObjectSpawnByBagExplorer(playerColor, spawnParameters, spawnByDrag)
    --example:
    --spawnParameters.rotation = Vector(0, math.random(-180, 180), 0)
end

--This method is called AFTER any object was spawned on table by BagExplorer.
--You can do something with the object in this method.
--playerColor - https://api.tabletopsimulator.com/player/colors/
--spawnedObject - https://api.tabletopsimulator.com/object/
--spawnByDrag - true if object is going to be spawned by dragging related button from BagExplorer to Table, false if button was clicked.
function onAfterObjectSpawnByBagExplorer(playerColor, spawnedObject, spawnByDrag)
    --example:
    --spawnedObject.setPositionSmooth(spawnedObject.getPosition() + Vector(0, 5, 0), false, false)
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--Credits:
--Magnifying glass 3D model created by Peter A https://jolly_swagman.artstation.com
--Icons created by Phoenix Group, Zesan, Bingge Liu - Flaticon https://www.flaticon.com
--Code is written by George Aleksandrov https://d1ke.bitbucket.io

local MAX_RESULTS_PER_PAGE = 21
local MAX_SEARCH_RESULTS = 93

local g_savedState
local g_needRemoveContextMenu = false

local g_tabletObject
local g_benchmarkClock
local g_initSettingsTogglesHandle

local TYPE_BAG = 1
local TYPE_ITEM = 2
local TYPE_EXCEEDED_SEARCH_MAX_RESULTS = 3

local MATCH_TYPE_NAME = 1
local MATCH_TYPE_TAGS = 2
local MATCH_TYPE_GM_NOTES = 3
local MATCH_TYPE_DESCRIPTION = 4

local NAME_MODE_USE_NAME = 1
local NAME_MODE_PREFER_NAME = 2
local NAME_MODE_PREFER_DESCRIPTION = 3
local NAME_MODE_USE_DESCRIPTION = 4

local RESULT_BUTTON_ID_PREFIX_LENGTH = string.len('bagex_ResultButton') + 1
local TAG = 'bagex_BagExplorer'

local g_themes = {
    Light = {
        windowColor = '#EBEBEB',
        textColor = '#000000',
        inputColors = '#FFFFFF|#1C97FF|#FFFFFF|#B5B2AF',
        inputPlaceholderColor = '#CECCCA',
        buttonColors = '#FFFFFF|#1C97FF|#FFFFFF|#B5B2AF',
        bagButtonColors = '#54CDFF|#1C97FF|#54CDFF|#B5B2AF',
        folderUpButtonColors = '##4BB7E4|#1C97FF|#4BB7E4|#B5B2AF',
        tooManySearchResultsButtonColors = '#ffb4b4|#ffb4b4|#ffb4b4|#B5B2AF',
        linkButtonColors = '#FFFFFF|#1C97FF|#FFFFFF|#B5B2AF',
        iconColor = '#000000',
    },
    Dark = {
        windowColor = '#1E1E1E',
        textColor = '#F0F0F0',
        inputColors = '#71706F|#E18D15|#71706F|#5B5855',
        inputPlaceholderColor = '#CECCCA',
        buttonColors = '#282828|#E18D15|#282828|#71706F',
        bagButtonColors = '#9D6212|#E18D15|#9D6212|#71706F',
        folderUpButtonColors = '#5C3600|#E18D15|#5C3600|#71706F',
        tooManySearchResultsButtonColors = '#9A4D4D|#9A4D4D|#9A4D4D|#71706F',
        linkButtonColors = '#505050|#E18D15|#505050|#71706F',
        iconColor = '#F0F0F0',
    }
}

local g_colorToPlayerContext = {}

------------------------------------------------------------------------------------------------------------------------
PlayerContext = {}
PlayerContext.__index = PlayerContext

function PlayerContext:create(playerColor, savedState)
    local playerContext = {}
    setmetatable(playerContext, PlayerContext)

    playerContext.playerColor = playerColor
    playerContext.savedState = savedState
    playerContext.parsedObjects = {}
    playerContext.rootBag = {}
    playerContext.results = {}
    playerContext.queryString = ''
    playerContext.queryStringGeneration = 0
    playerContext.currentBagIndex = 0
    playerContext.currentPageIndex = 1
    playerContext.isMouseOverSearchPanel = false

    log('[Bag Explorer] created PlayerContext for '..playerColor)
    return playerContext
end

function PlayerContext:getCurrentTheme()
    return g_themes[self.savedState.settings.theme]
end

function PlayerContext:parseBag(bagObject)
    self.parsedObjects = {}
    self.rootBag = bagObject
    local rootBagData = bagObject.getData()
    benchmark('getJSON of `'.. bagObject.getName()..'`')
    parseObjectRecursively(self.parsedObjects, self.savedState.settings.nameMode, rootBagData, 1, 0,0, 1, {}, '')
    benchmark('parsing of `'.. bagObject.getName()..'`')
end

function PlayerContext:getUiId(id)
    return id..self.playerColor
end

function PlayerContext:showUi(id)
    UI.show(self:getUiId(id))
end

function PlayerContext:hideUi(id)
    UI.hide(self:getUiId(id))
end

function PlayerContext:getUiAttribute(id, attributeName)
    return UI.getAttribute(self:getUiId(id), attributeName)
end

function PlayerContext:setUiAttribute(id, attributeName, attributeValue)
    UI.setAttribute(self:getUiId(id), attributeName, attributeValue)
end

function PlayerContext:setQueryString(queryString, needUpdateResults)
    self.queryString = queryString
    self:setUiAttribute('bagex_SearchInputField', 'text', queryString)

    local theme = self:getCurrentTheme()
    self:setUiAttribute('bagex_SearchInputField', 'textColor', queryString == '' and theme.inputPlaceholderColor or theme.textColor)

    self.queryStringGeneration = self.queryStringGeneration + 1
    local capturedGeneration = self.queryStringGeneration

    if not needUpdateResults then
        return
    end

    Wait.time(
            function()
                if capturedGeneration == self.queryStringGeneration then
                    self:updateResults(self.queryString)
                end
            end,
            0.2
    )
end

function PlayerContext:setCurrentBag(newCurrentBagIndex)
    self.currentBagIndex = newCurrentBagIndex
    local currentBag = self.parsedObjects[self.currentBagIndex]
    local currentBagPath = currentBag.Depth == 1 and currentBag.Name or table.concat(currentBag.ParentsNames, '/')..'/'..currentBag.Name
    self:setUiAttribute('bagex_CurrentPathLabel', 'text', currentBagPath..'/')
    self:setUiAttribute('bagex_SearchInputField', 'placeholder', 'Type here to search inside "'..currentBag.Name..'" bag')
    self:updateResults(self.queryString)
end

function PlayerContext:updateResults(queryString)
    local currentBag = self.parsedObjects[self.currentBagIndex]
    local canFolderUp = currentBag.ParentIndex > 0

    self.results = queryString ~= '' and searchInBag(self, currentBag, self.parsedObjects, queryString) or showBagContent(currentBag, self.parsedObjects)

    if self.savedState.settings.sortByName then
        table.sort(self.results, self.savedState.settings.foldersOnTop and compareByNameFoldersOnTop or compareByName)
    else
        table.sort(self.results, self.savedState.settings.foldersOnTop and compareByOrderFoldersOnTop or compareByOrder)
    end

    if canFolderUp then
        self:setUiAttribute('bagex_FolderUpButton', 'active', true)
        self:setUiAttribute('bagex_FolderUpButtonLabel', 'text', '<b>..</b> back to "'..currentBag.Name..'" bag')
    else
        self:setUiAttribute('bagex_FolderUpButton', 'active', false)
    end

    self:setPage(1, self.results)
end

function PlayerContext:toggleSettingsVisibility()
    local isActive = self:getUiAttribute('bagex_SettingsPanel', 'active')
    self:setSettingsVisibility(isActive ~= 'True')
end

function PlayerContext:setSettingsVisibility(isVisible)
    self:setUiAttribute('bagex_SettingsPanel', 'active', isVisible)
end

function PlayerContext:folderUp()
    self:setCurrentBag(self.parsedObjects[self.currentBagIndex].ParentIndex)
end

function PlayerContext:onResultClick(id)
    local resultIndex = tonumber(id:sub(RESULT_BUTTON_ID_PREFIX_LENGTH + self.playerColor:len(), #id))
    local object = self.results[self:getVisibleResultsIndices() + resultIndex]

    if object.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return
    end

    if object.Type == TYPE_BAG then
        self:setCurrentBag(object.Index)
    else
        local bounds = self.rootBag.getBounds()
        local spawnParameters =
        {
            data = object.Data,
            position = bounds.center + Vector(0, bounds.size.y * 0.75, 0)
        }

        onBeforeObjectSpawnByBagExplorer(self.playerColor, spawnParameters)

        spawnParameters.callback_function = function(spawnedObject)
            local force = Vector(math.random() - math.random(), 0, math.random() - math.random())
            force:normalize()
            force:scale(math.max(bounds.size.x, bounds.size.z) * 0.75)
            force.y = 5
            spawnedObject.setPositionSmooth(spawnedObject.getPosition() + force, false, false)
            onAfterObjectSpawnByBagExplorer(self.playerColor, spawnedObject, false)
        end

        self:spawnObject(object, spawnParameters)
    end
end

function PlayerContext:onResultEndDrag(id, pointerPosition)
    local resultIndex = tonumber(id:sub(RESULT_BUTTON_ID_PREFIX_LENGTH + self.playerColor:len(), #id))
    local object = self.results[self:getVisibleResultsIndices() + resultIndex]

    if object.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return
    end

    local spawnParameters =
    {
        data = object.Data,
        position = pointerPosition
    }

    onBeforeObjectSpawnByBagExplorer(self.playerColor, spawnParameters)

    spawnParameters.callback_function = function(spawnedObject)
        onAfterObjectSpawnByBagExplorer(self.playerColor, spawnedObject, true)
    end

    self:spawnObject(object, spawnParameters)
end

function PlayerContext:spawnObject(object, spawnParameters)
    spawnObjectData(spawnParameters)

    if not self.savedState.settings.keepItemsInBag then
        local pageIndex = self.currentPageIndex
        self:removeObjectFromBag(object)
        self:refreshResults(self.queryString)
        self:setPage(pageIndex)
    end
end

function PlayerContext:removeObjectFromBag(objectToRemove)
    local firstDeletedIndex = objectToRemove.Index
    local lastDeletedIndex = objectToRemove.NextSiblingIndex - 1
    local deletedObjectsCount = lastDeletedIndex - firstDeletedIndex + 1

    -- remove object in Data.ContainedObjects
    local parentIndex = objectToRemove.ParentIndex
    local parent = self.parsedObjects[parentIndex]
    arrayRemoveRange(parent.Data.ContainedObjects, objectToRemove.SiblingIndex, objectToRemove.SiblingIndex)

    -- fix parents' NextSibling indices
    local p = parent
    while true do
        p.NextSiblingIndex = p.NextSiblingIndex - deletedObjectsCount

        if p.Index == 1 then
            break
        end

        p = self.parsedObjects[p.ParentIndex]
    end

    -- remove from parsedObjects
    arrayRemoveRange(self.parsedObjects, firstDeletedIndex, lastDeletedIndex)

    -- fix parsedObjects indices
    local newParsedObjectsCount = #self.parsedObjects
    for i = firstDeletedIndex, newParsedObjectsCount do
        local object = self.parsedObjects[i]
        object.Index = object.Index - deletedObjectsCount
        object.NextSiblingIndex = object.NextSiblingIndex - deletedObjectsCount

        if object.ParentIndex == parentIndex then
            object.SiblingIndex = object.SiblingIndex - 1
        end

        if object.ParentIndex >= firstDeletedIndex then
            object.ParentIndex = object.ParentIndex - deletedObjectsCount
        end
    end

    -- replace bag
    local bagSpawnParameters =
    {
        data = self.parsedObjects[1].Data,
        position = self.rootBag.getPosition(),
        rotation = self.rootBag.getRotation(),
        scale = self.rootBag.getScale(),
        callback_function = function(newBag)
            self.rootBag = newBag
        end
    }

    local oldRootBag = self.rootBag
    self.rootBag = nil
    oldRootBag.destruct()

    spawnObjectData(bagSpawnParameters)
end

function arrayRemoveRange(array, firstDeletedIndex, lastDeletedIndex)
    local arrayLength = #array

    local lastIndex = firstDeletedIndex
    for i = lastDeletedIndex + 1, arrayLength do
        array[lastIndex] = array[i]
        lastIndex = lastIndex + 1
    end

    for i = lastIndex, arrayLength do
        array[i] = nil
    end

    return array
end

function PlayerContext:getVisibleResultsIndices()
    local resultsPerPage = self:getResultsPerPage()
    local startIndex = (self.currentPageIndex - 1) * resultsPerPage
    local endIndex = math.min(#self.results, startIndex + resultsPerPage)
    return startIndex, endIndex
end

function PlayerContext:getLastPageIndex()
    local resultsPerPage = self:getResultsPerPage()
    return math.max(1, math.ceil(#self.results / resultsPerPage))
end

function PlayerContext:getResultsPerPage()
    local currentBag = self.parsedObjects[self.currentBagIndex]
    local canFolderUp = currentBag.ParentIndex > 0
    return canFolderUp and MAX_RESULTS_PER_PAGE - 1 or MAX_RESULTS_PER_PAGE
end

function PlayerContext:setPage(pageIndex)
    local lastPageIndex = self:getLastPageIndex()
    self.currentPageIndex = math.min(math.max(1, pageIndex), lastPageIndex)
    local theme = self:getCurrentTheme()

    local startIndex, endIndex = self:getVisibleResultsIndices()
    local visibleResultsCount = endIndex - startIndex

    for i = 1, visibleResultsCount do
        local stringIndex = tostring(i)
        local object = self.results[startIndex + i]

        local nameId = self:getUiId('bagex_ResultName')..stringIndex
        local iconId = self:getUiId('bagex_ResultIcon')..stringIndex
        local pathId = self:getUiId('bagex_ResultPath')..stringIndex
        local matchTypePanelId = self:getUiId('bagex_ResultMatchTypePanel')..stringIndex
        local matchTypeTextId = self:getUiId('bagex_ResultMatchTypeText')..stringIndex
        local buttonId = self:getUiId('bagex_ResultButton')..stringIndex

        UI.setAttribute(nameId, 'text', object.ShownName)
        UI.setAttribute(pathId, 'text', object.ShownPath)

        if object.MatchType == MATCH_TYPE_TAGS then
            UI.setAttribute(matchTypeTextId, 'text', "Match by\nTAGS")
            UI.setAttribute(matchTypePanelId, 'active', true)
        elseif object.MatchType == MATCH_TYPE_GM_NOTES then
            UI.setAttribute(matchTypeTextId, 'text', "Match by\nGM NOTES")
            UI.setAttribute(matchTypePanelId, 'active', true)
        elseif object.MatchType == MATCH_TYPE_DESCRIPTION then
            UI.setAttribute(matchTypeTextId, 'text', "Match by\nDESCR")
            UI.setAttribute(matchTypePanelId, 'active', true)
        else
            UI.setAttribute(matchTypePanelId, 'active', false)
        end

        if object.Type == TYPE_BAG then
            UI.setAttribute(iconId, 'image', 'bagex_iconBagWhite')
            UI.setAttribute(iconId, 'active', true)
            UI.setAttribute(buttonId, 'bagex_colors', 'bagButtonColors')
            self:setButtonAttributes(buttonId, true, true, nil, theme.bagButtonColors)
        elseif object.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
            UI.setAttribute(buttonId, 'bagex_colors', 'tooManySearchResultsButtonColors')
            self:setButtonAttributes(buttonId, true, true, nil, theme.tooManySearchResultsButtonColors)
            UI.setAttribute(iconId, 'active', false)
        else
            UI.setAttribute(iconId, 'active', false)
            UI.setAttribute(buttonId, 'bagex_colors', 'buttonColors')
            self:setButtonAttributes(buttonId, true, true, nil, theme.buttonColors)
        end
    end

    for i = visibleResultsCount + 1, MAX_RESULTS_PER_PAGE do
        UI.setAttribute(self:getUiId('bagex_ResultButton')..tostring(i), 'active', false)
    end

    self:updatePagesPanel()
end

function PlayerContext:updatePagesPanel()
    local lastPageIndex = self:getLastPageIndex()
    local itemsInLayout = 3

    if lastPageIndex == 1 then
        itemsInLayout = 0

        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), false)
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), false)
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), false)
    elseif lastPageIndex == 2 then
        itemsInLayout = 2

        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), true, self.currentPageIndex ~= 1, '1')
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), true, self.currentPageIndex ~= 2, '2')
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), false)
    elseif lastPageIndex == 3 then
        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), true, self.currentPageIndex ~= 1, '1')
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), true, self.currentPageIndex ~= 2, '2')
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), true, self.currentPageIndex ~= 3, '3')
    elseif self.currentPageIndex == 1 then
        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), true, false, '1')
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), true, true, '2')
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), true, true, '3')
    elseif self.currentPageIndex == lastPageIndex then
        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), true, true, tostring(lastPageIndex - 2))
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), true, true, tostring(lastPageIndex - 1))
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), true, false, tostring(lastPageIndex))
    else
        self:setButtonAttributes(self:getUiId('bagex_LeftPageButton'), true, true, tostring(self.currentPageIndex - 1))
        self:setButtonAttributes(self:getUiId('bagex_MiddlePageButton'), true, false, tostring(self.currentPageIndex))
        self:setButtonAttributes(self:getUiId('bagex_RightPageButton'), true, true, tostring(self.currentPageIndex + 1))
    end

    self:setButtonAttributes(self:getUiId('bagex_PrevPageButton'), lastPageIndex > 1, self.currentPageIndex > 1)
    self:setButtonAttributes(self:getUiId('bagex_NextPageButton'), lastPageIndex > 1, self.currentPageIndex < lastPageIndex)

    self:setButtonAttributes(self:getUiId('bagex_FirstPageSeparator'), lastPageIndex > 3 and self.currentPageIndex > 3)
    self:setButtonAttributes(self:getUiId('bagex_FirstPageButton'), lastPageIndex > 3 and self.currentPageIndex > 2)
    self:setButtonAttributes(self:getUiId('bagex_LastPageSeparator'), lastPageIndex > 3 and lastPageIndex - self.currentPageIndex > 2)
    self:setButtonAttributes(self:getUiId('bagex_LastPageButton'), lastPageIndex > 3 and lastPageIndex - self.currentPageIndex > 1, true, tostring(lastPageIndex))

    --- For some reason items inside HorizontalLayout ignore their width and height.
    --- So here is a workaround to set their size via HorizontalLayout :(
    self:setUiAttribute('bagex_PagesLayout', 'width', 32 * itemsInLayout)
end

function PlayerContext:updateSettingsToggles()
    self:setButtonAttributes(self:getUiId('bagex_SettingThemeButton'), true, true, self.savedState.settings.theme)
    self:setButtonAttributes(self:getUiId('bagex_SettingFoldersAtTopButton'), true, true, self.savedState.settings.foldersOnTop and 'Yes' or 'No')
    self:setButtonAttributes(self:getUiId('bagex_SettingSortingOrderButton'), true, true, self.savedState.settings.sortByName and 'By name' or 'Same as items appear in a bag')

    if self.savedState.settings.nameMode == NAME_MODE_PREFER_NAME then
        self:setButtonAttributes(self:getUiId('bagex_SettingNameModeButton'), true, true, 'Prefer name, if empty use description')
    elseif self.savedState.settings.nameMode == NAME_MODE_PREFER_DESCRIPTION then
        self:setButtonAttributes(self:getUiId('bagex_SettingNameModeButton'), true, true, 'Prefer description, if empty use name')
    elseif self.savedState.settings.nameMode == NAME_MODE_USE_DESCRIPTION then
        self:setButtonAttributes(self:getUiId('bagex_SettingNameModeButton'), true, true, 'Always use description')
    else
        self:setButtonAttributes(self:getUiId('bagex_SettingNameModeButton'), true, true, 'Always use name')
    end

    self:setButtonAttributes(self:getUiId('bagex_SettingKeepItemInBag'), true, true, self.savedState.settings.keepItemsInBag and 'Yes' or 'No')

    UI.setAttribute(self:getUiId('bagex_SettingSearchInTags'), 'isOn', self.savedState.settings.searchInTags)
    UI.setAttribute(self:getUiId('bagex_SettingSearchInNotes'), 'isOn', self.savedState.settings.searchInNotes)
    UI.setAttribute(self:getUiId('bagex_SettingSearchInDescr'), 'isOn', self.savedState.settings.searchInDescr)
end

function PlayerContext:setButtonAttributes(id, active, interactable, text, colors)
    UI.setAttribute(id, 'active', active)

    if interactable ~= nil then
        UI.setAttribute(id, 'interactable', interactable)
    end

    if text ~= nil then
        UI.setAttribute(id, 'text', text)
    end

    if colors ~= nil then
        UI.setAttribute(id, 'colors', colors)
    end

    if active then
        -- You have to reset textColor after changing active or interactable or text =(
        UI.setAttribute(id, 'textColor', self:getCurrentTheme().textColor)
    end
end

function PlayerContext:refreshResults(queryString)
    self:setQueryString(queryString, false)
    self:setCurrentBag(self.parsedObjects[self.currentBagIndex].Index)
end

function PlayerContext:applyCurrentTheme()
    resetBenchmark()

    local theme = self:getCurrentTheme()

    function applyThemeRecursive(object)
        if object.tag == 'Button' then
            object.attributes.textColor = theme.textColor
            object.attributes.iconColor = theme.iconColor

            if object.attributes.bagex_colors then
                object.attributes.colors = theme[object.attributes.bagex_colors]
            else
                object.attributes.colors = theme.buttonColors
            end
        elseif object.tag == 'Panel' then
            object.attributes.color = theme.windowColor
        elseif object.tag == 'Text' then
            object.attributes.color = theme.textColor
        elseif object.tag == 'Image' then
            object.attributes.color = theme.iconColor
        elseif object.tag == 'InputField' then
            object.attributes.colors = theme.inputColors
            object.attributes.textColor = object.attributes.text == '' and theme.inputPlaceholderColor or theme.textColor
        elseif object.tag == 'Toggle' then
            object.attributes.textColor = theme.textColor
            object.attributes.iconColor = theme.iconColor
        end

        for _, child in ipairs(object.children) do
            applyThemeRecursive(child)
        end
    end

    local ui = UI.getXmlTable()
    for _, object in ipairs(ui) do
        if object.attributes.class == 'bagex_PanelVisibilityWorkaround' and object.attributes.id:find(self.playerColor) ~= nil then
            for _, child in ipairs(object.children) do
                applyThemeRecursive(child)
            end
        end
    end

    UI.setXmlTable(ui)
    benchmark('applyCurrentTheme')
end
------------------------------------------------------------------------------------------------------------------------


function onLoad(stateJson)
    self.addTag(TAG)

    g_savedState = JSON.decode(stateJson or '')
    g_savedState.settings = g_savedState.settings or {}

    if g_savedState.settings.theme == nil then
        g_savedState.settings.theme = 'Light'
    end

    if g_savedState.settings.sortByName == nil then
        g_savedState.settings.sortByName = true
    end

    if g_savedState.settings.foldersOnTop == nil then
        g_savedState.settings.foldersOnTop = true
    end

    if g_savedState.settings.nameMode == nil then
        g_savedState.settings.nameMode = NAME_MODE_USE_NAME
    end

    if g_savedState.settings.keepItemsInBag == nil then
        g_savedState.settings.keepItemsInBag = true
    end

    if g_savedState.settings.searchInTags == nil then
        g_savedState.settings.searchInTags = true
    end

    if g_savedState.settings.searchInNotes == nil then
        g_savedState.settings.searchInNotes = true
    end

    if g_savedState.settings.searchInDescr == nil then
        g_savedState.settings.searchInDescr = false
    end

    waitForUiLoaded(function() finishLoad() end)
end

function finishLoad()
    local existingBagExplorers = getObjectsWithTag(TAG)
    if #existingBagExplorers > 1 and existingBagExplorers[1].getGUID() ~= self.getGUID() then
        self.setColorTint('Red')
        self.setName('Non working Bag Explorer')
        self.setDescription('When this instance spawned, some other Bag Explorer instance already existed on the table.\nThis instance will not work, better to delete it.')
        print('Another instance of Bag Explorer already exists on the table.\nThis instance will not work, better to delete it.')
        return
    end

    g_needRemoveContextMenu = true
    for _, object in ipairs(getObjects()) do
        tryAddContextMenu(object)
    end
end

function onSave()
    if g_needRemoveContextMenu then
        return JSON.encode(g_savedState)
    end
end

function onDestroy()
    if g_needRemoveContextMenu then
        for _, object in ipairs(getObjects()) do
            if object.type == 'Bag' then
                object.clearContextMenu('Bag Explorer')
            end
        end

        safeWaitStop(g_initSettingsTogglesHandle)
    end
end

function onObjectSpawn(object)
    if g_needRemoveContextMenu then
        tryAddContextMenu(object)
    end
end

function onObjectEnterContainer(container, object)
    local containerGuid = container.getGUID()

    for playerColor, context in pairs(g_colorToPlayerContext) do
        if context.rootBag ~= nil and containerGuid == context.rootBag.getGUID() then
            local isActive = context:getUiAttribute('bagex_SearchPanel', 'active') == 'true'
            if isActive then
                context:parseBag(container)
                context:refreshResults('')
            else
                context.rootBag = nil --make bag re-parsed on next open
            end
        end
    end
end

function onObjectDestroy(object)
    local objectGuid = object.getGUID()

    for playerColor, context in pairs(g_colorToPlayerContext) do
        if context.rootBag ~= nil and objectGuid == context.rootBag.getGUID() then
            context.rootBag = nil

            local isActive = context:getUiAttribute('bagex_SearchPanel', 'active') == 'true'
            if isActive then
                context:hideUi('bagex_SearchPanel')
            end
        end
    end
end

function tryAddContextMenu(object)
    if object.type == 'Bag' then
        object.addContextMenuItem('Bag Explorer', onBagExplorerContextClick)
    end
end

function onBagExplorerContextClick(playerColor, position, object)
    local context = g_colorToPlayerContext[playerColor]
    if context == nil then
        context = PlayerContext:create(playerColor, g_savedState)
        g_colorToPlayerContext[playerColor] = context
    end

    injectUiForPlayer(context, function()
        resetBenchmark()

        if context.rootBag ~= object then
            context:parseBag(object)
        end

        context.currentPageIndex = 1
        context.currentBagIndex = 1
        context:refreshResults('')
        context:showUi('bagex_SearchPanel')
    end)
end

function onQueryStringChanged(player, queryString, id)
    local context = g_colorToPlayerContext[player.color]
    context:setQueryString(queryString, true)
end

function onShowSettingsClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:toggleSettingsVisibility()
end

function onCloseSettingsClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:setSettingsVisibility(false)
end

function onCloseSearchPanelClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:hideUi('bagex_SearchPanel')
end

function parseObjectRecursively(parsedObjects, nameMode, data, index, siblingIndex, parentIndex, depth, parentsNames, pathLowercase)
    local name = parseObjectName(nameMode, data)
    local tags = parseObjectTags(data)

    local object =
    {
        Data = data,
        Index = index,
        SiblingIndex = siblingIndex,
        ParentIndex = parentIndex,
        Depth = depth,
        Name = name,
        ParentsNames = parentsNames,
        Tags = tags,
        GMNotes = string.lower(data.GMNotes),
        Description = string.lower(data.Description),
        PathLowercase = pathLowercase..'/'..string.lower(name)
    }

    parsedObjects[index] = object

    if (data.ContainedObjects ~= nil) then
        object.Type = TYPE_BAG

        local nestedParentsNames = { table.unpack(parentsNames) }
        table.insert(nestedParentsNames, name)

        for i, nestedData in ipairs(data.ContainedObjects) do
            index = parseObjectRecursively(parsedObjects, nameMode, nestedData, index + 1, i, object.Index, depth + 1, nestedParentsNames, object.PathLowercase)
        end
    else
        object.Type = TYPE_ITEM
    end

    object.NextSiblingIndex = index + 1
    return index
end

function parseObjectName(nameMode, data)
    if nameMode == NAME_MODE_PREFER_NAME then
        if data.Nickname ~= '' then
            return data.Nickname
        end

        if data.Description ~= '' then
            return data.Description
        end

        return 'Unnamed and no description'
    end

    if nameMode == NAME_MODE_PREFER_DESCRIPTION then
        if data.Description ~= '' then
            return data.Description
        end

        if data.Nickname ~= '' then
            return data.Nickname
        end

        return 'Unnamed and no description'
    end

    if nameMode == NAME_MODE_USE_DESCRIPTION then
        if data.Description ~= '' then
            return data.Description
        end

        return 'No description'
    end

    if data.Nickname ~= '' then
        return data.Nickname
    end

    return 'Unnamed'
end

function parseObjectTags(data)
    if data.Tags == nil then
        return nil
    end

    local tags = { table.unpack(data.Tags) }

    for i = 1, #tags do
        tags[i] = string.lower(tags[i])
    end

    return tags
end

function compareByNameFoldersOnTop(x, y)
    if x.Type == y.Type then
        return x.Data.Nickname < y.Data.Nickname
    end

    return x.Type < y.Type
end

function compareByName(x, y)
    if x.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return false
    end

    if y.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return true
    end

    return x.Data.Nickname < y.Data.Nickname
end

function compareByOrderFoldersOnTop(x, y)
    if x.Type == y.Type then
        return x.Index > y.Index
    end

    return x.Type < y.Type
end

function compareByOrder(x, y)
    if x.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return false
    end

    if y.Type == TYPE_EXCEEDED_SEARCH_MAX_RESULTS then
        return true
    end

    return x.Index > y.Index
end

function searchInBag(context, bag, parsedObjects, queryString)
    resetBenchmark()

    local settings = context.savedState.settings

    queryString = string.lower(queryString)
    local queryWords = splitToQueryWords(queryString)
    local wordsCount = #queryWords

    local matchedIndices = {}
    local wordsLengths = {}
    local sortedIndices = {}

    for i = 1, wordsCount do
        sortedIndices[i] = i
        wordsLengths[i] = queryWords[i]:len()
    end

    local startSearchIndex = #bag.PathLowercase + 2

    local results = {}
    local resultIndex = 1

    for i = bag.Index + 1, bag.NextSiblingIndex - 1 do
        local object = parsedObjects[i]

        -- Search in object path
        if findAllWordsInStr(object.PathLowercase, queryWords, startSearchIndex, matchedIndices) then

            table.sort(sortedIndices, function(a, b)
                return matchedIndices[a] < matchedIndices[b]
            end)

            object.MatchType = MATCH_TYPE_NAME
            object.ShownName = object.Name
            object.ShownPath = table.concat(object.ParentsNames, '/', bag.Depth + 1)

            local shownPathLength = object.ShownPath:len()
            if shownPathLength > 0 then
                shownPathLength = shownPathLength + 1 -- slash
            end

            local pathLengthIncrement = 0
            local pathLengthIncrementSum = 0
            local oldEndMatchIndex = 0

            for j = 1, wordsCount do
                local wordIndex = sortedIndices[j]
                local startMatchIndex = matchedIndices[wordIndex] + pathLengthIncrementSum
                local endMatchIndex = startMatchIndex + wordsLengths[wordIndex] - 1

                if endMatchIndex > oldEndMatchIndex then
                    if startMatchIndex < oldEndMatchIndex then
                        startMatchIndex = oldEndMatchIndex
                    end

                    if startMatchIndex >= shownPathLength then
                        object.ShownName, pathLengthIncrement = markStringPart(object.ShownName, startMatchIndex - shownPathLength, endMatchIndex - shownPathLength)
                    elseif endMatchIndex > shownPathLength then
                        object.ShownPath, pathLengthIncrement = markStringPart(object.ShownPath, startMatchIndex, shownPathLength)
                        object.ShownName, pathLengthIncrement = markStringPart(object.ShownName, 1, endMatchIndex - shownPathLength)
                        shownPathLength = shownPathLength + pathLengthIncrement
                    else
                        object.ShownPath, pathLengthIncrement = markStringPart(object.ShownPath, startMatchIndex, endMatchIndex)
                        shownPathLength = shownPathLength + pathLengthIncrement
                    end

                    pathLengthIncrementSum = pathLengthIncrementSum + pathLengthIncrement
                    endMatchIndex = endMatchIndex + pathLengthIncrement
                end

                oldEndMatchIndex = endMatchIndex
            end

            if shownPathLength > 0 then
                object.ShownPath = './'..object.ShownPath..'/'
            end

            results[resultIndex] = object
            resultIndex = resultIndex + 1

        elseif settings.searchInTags and containsAllWordsInArr(object.Tags, queryWords) then

            object.MatchType = MATCH_TYPE_TAGS
            object.ShownName = object.Name
            object.ShownPath = table.concat(object.ParentsNames, '/', bag.Depth + 1)

            results[resultIndex] = object
            resultIndex = resultIndex + 1

        elseif settings.searchInNotes and context.playerColor == "Black" and findAllWordsInStr(object.GMNotes, queryWords, 1, {}) then

            object.MatchType = MATCH_TYPE_GM_NOTES
            object.ShownName = object.Name
            object.ShownPath = table.concat(object.ParentsNames, '/', bag.Depth + 1)

            results[resultIndex] = object
            resultIndex = resultIndex + 1

        elseif settings.searchInDescr and findAllWordsInStr(object.Description, queryWords, 1, {}) then

            object.MatchType = MATCH_TYPE_DESCRIPTION
            object.ShownName = object.Name
            object.ShownPath = table.concat(object.ParentsNames, '/', bag.Depth + 1)

            results[resultIndex] = object
            resultIndex = resultIndex + 1

        end

        if resultIndex > MAX_SEARCH_RESULTS then
            results[resultIndex] = { Type = TYPE_EXCEEDED_SEARCH_MAX_RESULTS, ShownName = 'Too many matched items', ShownPath = 'Please enter a more precise search query' }
            resultIndex = resultIndex + 1
            break
        end
    end

    benchmark('search for `'..queryString..'`')
    return results
end

function showBagContent(bag, parsedObjects)
    local results = {}
    local resultIndex = 1

    local i = bag.Index + 1
    while (i < bag.NextSiblingIndex) do
        local object = parsedObjects[i]
        object.ShownName = object.Name
        object.ShownPath = object.Type == TYPE_BAG and tostring(object.NextSiblingIndex - object.Index - 1)..' items inside' or ''

        results[resultIndex] = object
        resultIndex = resultIndex + 1

        i = object.NextSiblingIndex
    end

    return results
end

function splitToQueryWords(queryString)
    local splitByQuotes = {}
    local words = {}

    local startIndex = 1
    while true do
        local openQuoteIndex = queryString:find('"', startIndex)
        if openQuoteIndex == nil then
            table.insert(splitByQuotes, queryString:sub(startIndex, -1))
            break
        end

        local closeQuoteIndex = queryString:find('"', openQuoteIndex + 1)
        if closeQuoteIndex == nil then
            table.insert(splitByQuotes, queryString:sub(startIndex, -1))
            break
        end

        table.insert(splitByQuotes, queryString:sub(startIndex, openQuoteIndex - 1))
        table.insert(splitByQuotes, queryString:sub(openQuoteIndex + 1, closeQuoteIndex - 1))
        startIndex = closeQuoteIndex + 1
    end

    for i, v in ipairs(splitByQuotes) do
        if i % 2 == 0 then
            table.insert(words, v)
        else
            for word in v:gmatch('%S+') do
                table.insert(words, word)
            end
        end
    end

    return words
end

function findAllWordsInStr(str, queryWords, startSearchIndex, matchedIndices)
    for i = 1, #queryWords do
        local startIndex = str:find(queryWords[i], startSearchIndex)
        if startIndex == nil then
            return false
        end

        matchedIndices[i] = startIndex - startSearchIndex + 1
    end

    return true
end

function containsAllWordsInArr(strArray, queryWords)
    if strArray == nil then
        return false
    end

    for i = 1, #queryWords do
        local startIndex = nil
        local word = queryWords[i]

        for j = 1, #strArray do
            startIndex = strArray[j]:find(word)

            if startIndex ~= nil then
                break
            end
        end

        if startIndex == nil then
            return false
        end
    end

    return true
end

function onMouseEnter(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.isMouseOverSearchPanel = true
end

function onMouseExit(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.isMouseOverSearchPanel = false
end

function onFolderUpClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:folderUp()
end

function onResultClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:onResultClick(id)
end

function onResultEndDrag(player, value, id)
    local context = g_colorToPlayerContext[player.color]

    if context.isMouseOverSearchPanel then
        return
    end

    context:onResultEndDrag(id, player.getPointerPosition())
end

function onEraseSearchClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:refreshResults('')
end

function onToggleTheme(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.theme =  context.savedState.settings.theme == 'Light' and 'Dark' or 'Light'
    context:applyCurrentTheme()
    context:updateSettingsToggles()
end

function onToggleFoldersAtTop(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.foldersOnTop = not context.savedState.settings.foldersOnTop
    context:updateSettingsToggles()
    context:refreshResults(context.queryString)
end

function onToggleSortOrder(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.sortByName = not context.savedState.settings.sortByName
    context:updateSettingsToggles()
    context:refreshResults(context.queryString)
end

function onToggleNameMode(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.nameMode = context.savedState.settings.nameMode == NAME_MODE_USE_DESCRIPTION and NAME_MODE_USE_NAME or context.savedState.settings.nameMode + 1
    context:updateSettingsToggles()
    context:parseBag(context.rootBag)
    context:refreshResults(context.queryString)
end

function onToggleKeepItemInBag(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.keepItemsInBag = not context.savedState.settings.keepItemsInBag
    context:updateSettingsToggles()
end

function onToggleSearchInTags(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.searchInTags = not context.savedState.settings.searchInTags
    context:updateSettingsToggles()
    context:refreshResults(context.queryString)
end

function onToggleSearchInNotes(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.searchInNotes = not context.savedState.settings.searchInNotes
    context:updateSettingsToggles()
    context:refreshResults(context.queryString)
end

function onToggleSearchInDescr(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context.savedState.settings.searchInDescr = not context.savedState.settings.searchInDescr
    context:updateSettingsToggles()
    context:refreshResults(context.queryString)
end

function showUrlOnTablet(player, url)
    if g_tabletObject ~= nil and not g_tabletObject.isDestroyed() then
        g_tabletObject.Browser.url = url
        return
    end

    local spawnData =
    {
        type = 'Tablet',
        position = player.getPointerPosition(),
        rotation = Vector(0, player.getPointerRotation(), 0),
        callback_function = function(spawnedObject)
            spawnedObject.Browser.url = url
        end
    }

    g_tabletObject = spawnObject(spawnData)
end

function onPeterLink(player, value, id)
    showUrlOnTablet(player, 'https://jolly_swagman.artstation.com')
end

function onFlaticonLink(player, value, id)
    showUrlOnTablet(player, 'https://www.flaticon.com')
end

function onGeorgeLink(player, value, id)
    showUrlOnTablet(player, 'https://d1ke.bitbucket.io')
end

function onPrevPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:setPage(context.currentPageIndex - 1)
end

function onNextPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:setPage(context.currentPageIndex + 1)
end

function onFirstPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:setPage(1)
end

function onLeftPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]

    local lastPageIndex = context:getLastPageIndex()

    if lastPageIndex <= 3 then
        context:setPage(1)
    elseif context.currentPageIndex == lastPageIndex then
        context:setPage(context.currentPageIndex - 2)
    else
        context:setPage(context.currentPageIndex - 1)
    end
end

function onMiddlePageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]

    local lastPageIndex = context:getLastPageIndex()

    if (context.currentPageIndex == 1) then
        context:setPage(2)
    elseif context.currentPageIndex == lastPageIndex then
        context:setPage(g_currentPageIndex - 1)
    end
end

function onRightPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]

    if context.currentPageIndex == 1 then
        context:setPage(3)
    else
        context:setPage(context.currentPageIndex + 1)
    end
end

function onLastPageClick(player, value, id)
    local context = g_colorToPlayerContext[player.color]
    context:setPage(context:getLastPageIndex())
end

function markStringPart(str, startIndex, endIndex)
    local newStr = str:sub(1, startIndex - 1)..'<b>'..str:sub(startIndex, endIndex)..'</b>'..str:sub(endIndex + 1, #str)
    local strLengthIncrement = 7
    return newStr, strLengthIncrement
end

function waitForUiLoaded(callback)
    if UI.loading == false then
        callback()
        return nil
    end

    return Wait.condition(
            function() -- Executed after our condition is met
                callback()
            end,
            function() -- Condition function
                return UI.loading == false
            end
    )
end

function safeWaitStop(handle)
    if handle ~= nil then
        Wait.stop(handle)
    end
end

function resetBenchmark()
    g_benchmarkClock = os.clock()
end

function benchmark(msg)
    local oldClock = g_benchmarkClock
    g_benchmarkClock = os.clock()
    log(string.format('[Bag Explorer] %s took %.3f sec', msg, g_benchmarkClock - oldClock))
end

function dump(o)
    if o == nil then
        return 'nil'
    end

    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. k..' = ' .. dump(v) .. ','
        end
        return s .. '} '
    end

    return tostring(o)
end

function injectUiForPlayer(context, onFinishCallback)
    local existingXml = UI.getXml()

    local playerColor = context.playerColor

    if existingXml:find(context:getUiId('bagex_SearchPanel')) ~= nil then
        log('[Bag Explorer] UI for color '..playerColor..' already injected, skipping')
        onFinishCallback()
        return
    end

    injectUiAssetsIfNeeded()

    if injectUiDefaultsIfNeeded() then
        waitForUiLoaded(function() injectUiForPlayer(context, onFinishCallback) end)
        return
    end

    log('[Bag Explorer] Injecting UI for color '..playerColor)

    local bagExplorerUiXml = [[
    <Panel class="bagex_PanelVisibilityWorkaround" id="bagex_SearchPanel{playerColor}"
        active="false"
        showAnimation="SlideIn_Right"
        hideAnimation="SlideOut_Right"
        animationDuration="0.15"
        rectAlignment="MiddleRight"
        offsetXY="-5 -50"
        width="448"
        height="810">
        <Panel class="bagex_Window"
            visibility="{playerColor}"
            width="100%"
            height="100%"
            onMouseEnter="{objectId}/onMouseEnter"
            onMouseExit="{objectId}/onMouseExit">
            <Text rectAlignment="UpperCenter"
                text="Bag Explorer"
                width="100%"
                height="30"
                fontSize="18"/>
            <Button
                rectAlignment="UpperRight"
                offsetXY="-32 -2"
                width="28"
                height="28"
                icon="bagex_iconSettingsWhite"
                onClick="{objectId}/onShowSettingsClick"/>
            <Button class="bagex_CloseButton"
                onClick="{objectId}/onCloseSearchPanelClick"/>
            <Text id="bagex_CurrentPathLabel{playerColor}"
                rectAlignment="UpperCenter"
                offsetXY="0 -30"
                width="444"
                height="30"
                alignment="MiddleLeft"
                text="Root bag name/nested bag1/nested bag 2/nested bag 3"
                resizeTextForBestFit="true"
                resizeTextMinSize="4"
                resizeTextMaxSize="14"/>
            <InputField class="bagex_SearchInputField" id="bagex_SearchInputField{playerColor}"
                rectAlignment="UpperCenter"
                offsetXY="0 -60"
                width="442"
                height="33"
                fontSize="14"
                placeholder="Type to search inside 'BagName1'"
                onValueChanged="{objectId}/onQueryStringChanged">
                <Button
                    rectAlignment="MiddleRight"
                    offsetXY="-1 0"
                    width="30" height="30"
                    sprite="bagex_transparent"
                    icon="bagex_iconClearWhite"
                    onClick="{objectId}/onEraseSearchClick"/>
            </InputField>
            <VerticalLayout
                childForceExpandHeight="false"
                rectAlignment="UpperCenter"
                offsetXY="0 -100"
                width="398"
                height="700"
                spacing="-2">
                <Button class="bagex_FolderUpButton" id="bagex_FolderUpButton{playerColor}"
                    bagex_colors="folderUpButtonColors">
                    <Image class="bagex_ResultIcon" image="bagex_iconBagWhite"/>
                    <Text class="bagex_ResultName" id="bagex_FolderUpButtonLabel{playerColor}" text="Go back to 'BagName1' bag"/>
                </Button>
                {resultButtons}
            </VerticalLayout>
            <Button class="bagex_BigPageButton" id="bagex_PrevPageButton{playerColor}"
                rectAlignment="LowerLeft"
                offsetXY="2 2"
                text="P r  e v  -  p a g e"
                onClick="{objectId}/onPrevPageClick"/>
            <Button class="bagex_BigPageButton" id="bagex_NextPageButton{playerColor}"
                rectAlignment="LowerRight"
                offsetXY="-2 2"
                text="N e x t  -  p a g e"
                onClick="{objectId}/onNextPageClick"/>
            <Button class="bagex_PageButton" id="bagex_FirstPageButton{playerColor}" onClick="{objectId}/onFirstPageClick" offsetXY="-80 2" text="1"/>
            <Text class="bagex_LastPageSeparator" id="bagex_FirstPageSeparator{playerColor}" offsetXY="-56 4"/>
            <HorizontalLayout id="bagex_PagesLayout{playerColor}"
                rectAlignment="LowerCenter"
                offsetXY="0 2"
                width="96"
                height="32"
                childAlignment="MiddleCenter"
                childForceExpandHeight="true"
                childForceExpandWidth="true">
                <Button class="bagex_PageButton" id="bagex_LeftPageButton{playerColor}" onClick="{objectId}/onLeftPageClick" text="55"/>
                <Button class="bagex_PageButton" id="bagex_MiddlePageButton{playerColor}" onClick="{objectId}/onMiddlePageClick" text="56"/>
                <Button class="bagex_PageButton" id="bagex_RightPageButton{playerColor}" onClick="{objectId}/onRightPageClick" text="57"/>
            </HorizontalLayout>
            <Text class="bagex_LastPageSeparator" id="bagex_LastPageSeparator{playerColor}" offsetXY="56 4"/>
            <Button class="bagex_PageButton" id="bagex_LastPageButton{playerColor}" onClick="{objectId}/onLastPageClick" offsetXY="80 2" text="99"/>
        </Panel>
    </Panel>


    <Panel class="bagex_PanelVisibilityWorkaround" id="bagex_SettingsPanel{playerColor}"
        active="false"
        width="350"
        height="490">
        <Panel class="bagex_Window"
            width="100%"
            height="100%"
            visibility="{playerColor}">
            <Text
                rectAlignment="UpperCenter"
                text="Settings"
                width="100%"
                height="30"
                fontSize="18"/>
            <Button class="bagex_CloseButton"
                onClick="{objectId}/onCloseSettingsClick"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -35"
                text="Theme:"/>
            <Button class="bagex_SettingButton" id="bagex_SettingThemeButton{playerColor}"
                offsetXY="-1 -35"
                onClick="{objectId}/onToggleTheme"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -70"
                text="Show bags always first:"/>
            <Button class="bagex_SettingButton" id="bagex_SettingFoldersAtTopButton{playerColor}"
                offsetXY="-1 -70"
                onClick="{objectId}/onToggleFoldersAtTop"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -105"
                text="Sorting order:"/>
            <Button class="bagex_SettingButton" id="bagex_SettingSortingOrderButton{playerColor}"
                offsetXY="-1 -105"
                onClick="{objectId}/onToggleSortOrder"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -140"
                text="Use descriptions instead of names:"/>
            <Button class="bagex_SettingButton" id="bagex_SettingNameModeButton{playerColor}"
                offsetXY="-1 -140"
                onClick="{objectId}/onToggleNameMode"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -175"
                text="Keep spawned item in bag:"/>
            <Button class="bagex_SettingButton" id="bagex_SettingKeepItemInBag{playerColor}"
                offsetXY="-1 -175"
                onClick="{objectId}/onToggleKeepItemInBag"/>

            <Text class="bagex_SettingLabel"
                offsetXY="1 -210"
                text="Search also in:"/>
            <Toggle class="bagex_SettingToggle" id="bagex_SettingSearchInTags{playerColor}"
                offsetXY="-1 -210"
                onClick="{objectId}/onToggleSearchInTags">Tags</Toggle>
            <Toggle class="bagex_SettingToggle" id="bagex_SettingSearchInNotes{playerColor}"
                offsetXY="-1 -240"
                onClick="{objectId}/onToggleSearchInNotes">
                <Text text="GM Notes&#10;(works only for GM)"/>
            </Toggle>
            <Toggle class="bagex_SettingToggle" id="bagex_SettingSearchInDescr{playerColor}"
                offsetXY="-1 -270"
                onClick="{objectId}/onToggleSearchInDescr">Description</Toggle>

            <Text offsetXY="0 -310"
                width="85%"
                height="150"
                fontSize="12"
                fontStyle="Bold"
                horizontalOverflow="Wrap"
                rectAlignment="UpperCenter"
                alignment="UpperCenter"
                text="If this tool appeared to be helpful for you, please like it at Bag Explorer Steam page, so more people know that navigating in bags hierarchy can be much less painful :)"/>

            <Text class="bagex_CreditsLabel"
                offsetXY="0 117"
                text="Magnifying glass 3D model created by"/>
            <Text class="bagex_CreditsLabel"
                offsetXY="0 107"
                text="Peter A"/>
            <Button class="bagex_CreditsLink"
                offsetXY="0 95"
                width="168"
                bagex_colors="linkButtonColors"
                text="https://jolly_swagman.artstation.com"
                onClick="{objectId}/onPeterLink"/>

            <Text class="bagex_CreditsLabel"
                offsetXY="0 72"
                text="Icons created by"/>
            <Text class="bagex_CreditsLabel"
                offsetXY="0 62"
                text="Phoenix Group, Zesan, Bingge Liu - Flaticon"/>
            <Button class="bagex_CreditsLink"
                offsetXY="0 50"
                width="116"
                bagex_colors="linkButtonColors"
                text="https://www.flaticon.com"
                onClick="{objectId}/onFlaticonLink"/>

            <Text class="bagex_CreditsLabel"
                offsetXY="0 27"
                text="Code is written by"/>
            <Text class="bagex_CreditsLabel"
                offsetXY="0 17"
                text="George Aleksandrov"/>
            <Button class="bagex_CreditsLink"
                offsetXY="0 5"
                width="114"
                bagex_colors="linkButtonColors"
                text="https://d1ke.bitbucket.io"
                onClick="{objectId}/onGeorgeLink"/>
        </Panel>
    </Panel>
]]

    local resultButtons = {}
    for i = 1, MAX_RESULTS_PER_PAGE do
        local resultId = tostring(i)
        table.insert(resultButtons, '<Button class="bagex_ResultButton" id="bagex_ResultButton{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"><Image class="bagex_ResultIcon" id="bagex_ResultIcon{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"/><Text class="bagex_ResultName" id="bagex_ResultName{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"/><Text class="bagex_ResultPath" id="bagex_ResultPath{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"/><Panel class="bagex_ResultMatchTypePanel" id="bagex_ResultMatchTypePanel{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"><Text class="bagex_ResultMatchTypeText" id="bagex_ResultMatchTypeText{playerColor}')
        table.insert(resultButtons, resultId)
        table.insert(resultButtons, '"/></Panel>')
        table.insert(resultButtons, '</Button>')
    end

    bagExplorerUiXml = bagExplorerUiXml:gsub('{objectId}', self.getGUID())
    bagExplorerUiXml = bagExplorerUiXml:gsub('{resultButtons}', table.concat(resultButtons))
    bagExplorerUiXml = bagExplorerUiXml:gsub('{playerColor}', context.playerColor)

    UI.setXml(existingXml..bagExplorerUiXml)

    g_initSettingsTogglesHandle = waitForUiLoaded(
            function()
                onFinishCallback()
                context:updateSettingsToggles()
                context:applyCurrentTheme()
            end
    )
end

function injectUiAssetsIfNeeded()
    local uiAssets = UI.getCustomAssets()

    for _, v in ipairs(uiAssets) do
        if v.name == 'bagex_iconBagWhite' then
            log('[Bag Explorer] UI assets already injected, skipping')
            return -- already injected
        end
    end

    log('[Bag Explorer] Injecting UI assets')

    table.insert(uiAssets, { name = 'bagex_transparent', url = 'https://steamusercontent-a.akamaihd.net/ugc/2023848099966391721/426D957B869B634ECDFAB65FC82E8959D84C6481/' })
    table.insert(uiAssets, { name = 'bagex_iconBagWhite', url = 'https://steamusercontent-a.akamaihd.net/ugc/2023848099966269812/1E28612629F0A96595559F34649E04BB6E5F91BF/' })
    table.insert(uiAssets, { name = 'bagex_iconCloseWhite', url = 'https://steamusercontent-a.akamaihd.net/ugc/2023848099966273244/F04D903B14930A6A0E855FE7F8CCCC7B0398EC3A/' })
    table.insert(uiAssets, { name = 'bagex_iconSettingsWhite', url = 'https://steamusercontent-a.akamaihd.net/ugc/2023848099966273902/0FA1FBD7B89F50267CD9E6EB499EC9DCD04CAB86/' })
    table.insert(uiAssets, { name = 'bagex_iconClearWhite', url = 'https://steamusercontent-a.akamaihd.net/ugc/2023848099966272474/A8E9055804022B7D59CF68FB6A2C2AD973B903C1/' })
    UI.setCustomAssets(uiAssets)
end

function injectUiDefaultsIfNeeded()
    local existingXml = UI.getXml()

    if existingXml:find('bagex_UiDefaults') ~= nil then
        log('[Bag Explorer] UI Defaults already injected, skipping')
        return false -- already injected
    end

    log('[Bag Explorer] Injecting UI Defaults')

    local uiDefaults = [[
    <Defaults id="bagex_UiDefaults">
        <Panel class="bagex_PanelVisibilityWorkaround"
            color="#00000000"
            raycastTarget="true"
            allowDragging="true"
            returnToOriginalPositionWhenReleased="false"/>

        <Panel class="bagex_Window"
            outline="#000000"/>

        <Button class="bagex_CloseButton"
            rectAlignment="UpperRight"
            offsetXY="-2 -2"
            width="28"
            height="28"
            icon="bagex_iconCloseWhite"/>

        <Button class="bagex_FolderUpButton"
            minHeight="34"
            onClick="{objectId}/onFolderUpClick"/>

        <Button class="bagex_ResultButton"
            minHeight="34"
            iconAlignment="Left"
            allowDragging="true"
            restrictDraggingToParentBounds="false"
            returnToOriginalPositionWhenReleased="true"
            onClick="{objectId}/onResultClick"
            onEndDrag="{objectId}/onResultEndDrag"/>

        <Image class="bagex_ResultIcon"
            rectAlignment="MiddleLeft"
            offsetXY="4 0"
            width="22"
            height="22"
            preserveAspect="true"/>

        <Text class="bagex_ResultName"
            rectAlignment="UpperLeft"
            alignment="UpperLeft"
            offsetXY="28 -3"
            resizeTextForBestFit="true"
            resizeTextMinSize="10"
            resizeTextMaxSize="16"/>

        <Text class="bagex_ResultPath"
            rectAlignment="UpperLeft"
            alignment="UpperLeft"
            height="10"
            offsetXY="28 -20"
            resizeTextForBestFit="true"
            resizeTextMinSize="6"
            resizeTextMaxSize="10"/>

        <Panel class="bagex_ResultMatchTypePanel"
            rectAlignment="MiddleRight"
            alignment="MiddleRight"
            width="46"
            height="24"
            offsetXY="-5 0"
            textAlignment="MiddleCenter"
            outline="#000000"
            outlineSize="1"/>

        <Text class="bagex_ResultMatchTypeText"
            width="100%"
            height="100%"
            alignment="MiddleCenter"
            fontSize="8"/>

        <Button class="bagex_BigPageButton"
            width="22"
            height="708"/>

        <Button class="bagex_PageButton"
            rectAlignment="LowerCenter"
            width="32"
            height="32"/>

        <Text class="bagex_LastPageSeparator"
            rectAlignment="LowerCenter"
            width="32"
            height="32"
            alignment="MiddleCenter"
            text="..."/>

        <Text class="bagex_SettingLabel"
            rectAlignment="UpperLeft"
            width="40%"
            height="32"
            fontSize="12"
            alignment="MiddleRight"/>

        <Button class="bagex_SettingButton"
            rectAlignment="UpperRight"
            width="58%"
            height="32"
            fontSize="12"/>

        <Toggle class="bagex_SettingToggle"
            rectAlignment="UpperRight"
            width="58%"
            height="32"
            toggleWidth="24"
            toggleHeight="24"
            fontSize="12"/>

        <Text class="bagex_CreditsLabel"
            rectAlignment="LowerCenter"
            alignment="LowerCenter"
            fontSize="10"/>

        <Button class="bagex_CreditsLink"
            rectAlignment="LowerCenter"
            height="12"
            fontSize="10"
            textAlignment="MiddleCenter"/>
    </Defaults>
]]

    uiDefaults = uiDefaults:gsub('{objectId}', self.getGUID())
    UI.setXml(existingXml..uiDefaults)
    return true
end