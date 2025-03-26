local openedLicense = false
local waitForResponse = false
local lastOpenSanta = 0
local screenX, screenY = guiGetScreenSize()

local panelState = false

local panelWidth = (defaultSettings.slotBoxWidth + 5) * defaultSettings.width + 5
local panelHeight = (defaultSettings.slotBoxHeight + 5) * math.floor(defaultSettings.slotLimit / defaultSettings.width) + 5 + 40 + 5

local panelPosX = screenX / 2
local panelPosY = screenY / 2

local stackGUI = false
local stackAmount = 0

local moveDifferenceX = 0
local moveDifferenceY = 0
local panelIsMoving = false

local Roboto = dxCreateFont("files/fonts/Roboto.ttf", 22, false, "antialiased")
local BebasNeueRegular15 = dxCreateFont(":seal_gui/fonts/BebasNeueRegular.otf", 15)
local Ubuntu11 = dxCreateFont(":seal_gui/fonts/Ubuntu-R.ttf", 11)
local Raleway = dxCreateFont(":seal_gui/fonts/Ubuntu-R.ttf", respc(25))

local inventoryFont = dxCreateFont(":seal_gui/fonts/BebasNeueBold.otf", 15)
local tooltipFont = dxCreateFont(":seal_gui/fonts/BebasNeueLight.otf", 14)

grayItemPictures = {}
itemsTableState = "player"
itemsTable = {}
itemsTable.player = {}
itemsTable.vehicle = {}
itemsTable.object = {}
currentInventoryElement = localPlayer

haveMoving = false
local movedSlotId = false
local lastHoverSlotId = false

local currentTab = "main"
local hoverTab = false

local itemPictures = {}
local perishableTimer = false
local grayItemPictures = {}
local rottenEffect = false

local overheatWeapons = {
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[30] = true,
	[31] = true,
	[32] = true,
	[33] = true,
	[34] = true,

	[306] = true, 
	[307] = true, 
	[308] = true,
	[309] = true,
	[310] = true,
	[311] = true,
	[312] = true,
	[313] = true,
	[314] = true, 
	[315] = true,
	[316] = true,
	[317] = true,
	[318] = true,
	[319] = true,
	[320] = true,
	[321] = true, 
	[322] = true,
	[323] = true, 
	[324] = true, 
	[325] = true, 
	[326] = true,
	[327] = true,
	[331] = true,
}

function deepcopy(t)
	local copy
	if type(t) == "table" then
		copy = {}
		for k, v in next, t, nil do
			copy[deepcopy(k)] = deepcopy(v)
		end
		setmetatable(copy, deepcopy(getmetatable(t)))
	else
		copy = t
	end
	return copy
end

local currentCraftingPosition = false
local craftingColshapes = {}
--[[
	 2556.37109375, -1293.3695068359, 1045.3607177734
Rotation: -0, 0, 88.171516418457
Int
]]
local craftingPositions = {
	{2556.37109375, -1293.3695068359, 1045.3607177734, 2, 7, 5},
	{2543.05078125, -1293.4079589844, 1046.4619140625, 2, 7, 5},
}

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end

for y = 0, 1 do -- gyártósori összerelő
	for x = 0, 5 do
		local x, y = rotateAround(270, -1.5 + y * -4, 0.85 + x * -4, -1986.4, -2463.3)

		table.insert(craftingPositions, {x, y, 12.04, 1.75, 1, 3})
	end
end

local craftRecipes = deepcopy(availableRecipes)
local craftList = {}
local collapsedCategories = {}
local lastCraftCategory = 0

local hoverRecipeCategory = false
local hoverRecipe = false
local selectedRecipe = false

local appliedRecipeItems = {}
local requiredRecipeItems = {}

local craftListOffset = 0
local canCraftTheRecipe = false
local hoverCraftButton = false
local craftingProcess = false
local craftStartTime = false

local currentJob = 0
local playerRecipes = {}
local defaultRecipes = {
	[1] = true,
	[2] = true
}
for i = 1, 100 do
	defaultRecipes[i] = true
end

do
	for i = 1, #craftRecipes do
		if not craftRecipes[i] then
			craftRecipes[i] = {"null"}
			craftRecipes[i].category = "null"
		end

		craftRecipes[i].id = i
		craftRecipes[i].items = nil
		craftRecipes[i].finalItem = nil
		craftRecipes[i].requiredPermission = nil
		craftRecipes[i].suitableColShapes = nil
		craftRecipes[i].requiredJob = nil
	end

	table.sort(craftRecipes, function (a, b)
		if not a then
			return false
		end

		if not b then
			return false
		end

		return a.category < b.category or a.category == b.category and a.name < b.name
	end)

	for i = 1, #craftRecipes do
		if craftRecipes[i].name ~= "null" then
			local category = craftRecipes[i].category

			if not craftList[category] then
				craftList[category] = true
				collapsedCategories[category] = false

				table.insert(craftList, {"category", category, collapsedCategories[category]})

				lastCraftCategory = #craftList
			end

			if craftList[lastCraftCategory][3] then
				table.insert(craftList, {"recipe", craftRecipes[i].id})
			end
		end
	end
end

local renameProcess = false
local renameDetails = false

local notepadState = false
local notepadFont = false
local notepadText = false
local notepadCursorState = false
local notepadCursorChange = 0
local noteText = false
local noteIsCopy = false
local noteState = false

local wallNotes = {}
local wallNoteRadius = 80
local wallNoteCol = {}
local nearbyWallNotes = {}
local hoverWallNote = false

local myCharacterId = getElementData(localPlayer, "char.ID")
local myAdminLevel = getElementData(localPlayer, "acc.adminLevel")

local oldSlotLimit = 50
local oldObject = 60

addEvent("loadItems", true)
addEventHandler("loadItems", getRootElement(),
	function (items, ownerType, element, reopen)
		if items and type(items) == "table" then
			itemsTable[ownerType] = {}

			for k, v in pairs(items) do
				addItem(tostring(ownerType), v.dbID, v.slot, v.itemId, v.amount, v.data1, v.data2, v.data3, v.nameTag, v.serial)
			end

			if reopen then
				toggleInventory(false)

				if ownerType == "object" then
					defaultSettings.weightLimit.object = oldObject
					defaultSettings.slotLimit = oldSlotLimit

					local safeSize = tonumber(getElementData(element, "safeSize")) or 1
					
					if safeSize == 1 then
						defaultSettings.weightLimit.object = safeSettings.small.weightLimit
						defaultSettings.slotLimit = safeSettings.small.slotLimit
					elseif safeSize == 2 then
						defaultSettings.weightLimit.object = safeSettings.mid.weightLimit
						defaultSettings.slotLimit = safeSettings.mid.slotLimit
					elseif safeSize == 3 then
						defaultSettings.weightLimit.object = safeSettings.big.weightLimit
						defaultSettings.slotLimit = safeSettings.big.slotLimit
					end

					panelHeight = (defaultSettings.slotBoxHeight + 5) * math.floor(defaultSettings.slotLimit / defaultSettings.width) + 5 + 40 + 5
				end

				currentInventoryElement = element
				itemsTableState = ownerType
				toggleInventory(true)
			end

			triggerEvent("movedItemInInv", localPlayer)
		end
	end)

addEvent("addItem", true)
addEventHandler("addItem", getRootElement(),
	function (ownerType, item)
		if itemsTable[ownerType] and item and type(item) == "table" then
			addItem(ownerType, item.dbID, item.slot, item.itemId, item.amount, item.data1, item.data2, item.data3, item.nameTag, item.serial)
		end
	end)

addEvent("deleteItem", true)
addEventHandler("deleteItem", getRootElement(),
	function (ownerType, items)
		if itemsTable[ownerType] and items and type(items) == "table" then
			for k, v in pairs(items) do
				for i = 0, defaultSettings.slotLimit * 3 - 1 do
					if itemsTable[ownerType][i] and itemsTable[ownerType][i].dbID == v then
						itemsTable[ownerType][i] = nil

						if movedSlotId == i then
							movedSlotId = false
						end
					end
				end
			end
		end
	end)

addEvent("updateAmount", true)
addEventHandler("updateAmount", getRootElement(),
	function (ownerType, itemId, newAmount)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			newAmount = tonumber(newAmount)

			if itemId and newAmount then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].amount = newAmount
					end
				end
			end
		end
	end)

addEvent("updateItemID", true)
addEventHandler("updateItemID", getRootElement(),
	function (ownerType, itemId, newId)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			newId = tonumber(newId)

			if itemId and newId then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].itemId = newId
					end
				end
			end
		end
	end)

addEvent("unuseAmmo", true)
addEventHandler("unuseAmmo", getRootElement(),
	function ()
		exports.seal_chat:sendLocalDoC(source, "Tönkrement a fegyere")
		exports.seal_hud:showInfobox("e", "Tönkrement a fegyvered, ezért eldobtad!")

		for k, v in pairs(itemsTable.player) do
			if v.inUse and (isWeaponItem(v.itemId) or isAmmoItem(v.itemId)) then
				itemsTable.player[v.slot].inUse = false
			end
		end
	end)

addEvent("updateData1", true)
addEventHandler("updateData1", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			newData = tonumber(newData) or newData

			if itemId and newData then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].data1 = newData
					end
				end
			end
		end
	end)

addEvent("updateData2", true)
addEventHandler("updateData2", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)

			if itemId and newData then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].data2 = newData
						triggerServerEvent("updateData2", localPlayer, localPlayer, itemId, newData)
					end
				end
			end
		end
	end)

addEvent("updateData2Ex", true)
addEventHandler("updateData2Ex", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)

			if itemId and newData then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].data2 = newData
					end
				end
			end
		end
	end)

addEvent("updateData3", true)
addEventHandler("updateData3", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)

			if itemId and newData then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].data3 = newData
						triggerServerEvent("updateData3", localPlayer, localPlayer, itemId, newData)
					end
				end
			end
		end
	end)

addEvent("updateData3Ex", true)
addEventHandler("updateData3Ex", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			iprint(ownerType, itemId, newData)
			if itemId and newData then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].data3 = newData
					end
				end
			end
		end
	end)
	
addEvent("updateNameTag", true)
addEventHandler("updateNameTag", getRootElement(),
	function (itemId, text)
		if itemsTable.player then
			itemId = tonumber(itemId)

			if itemId and text then
				for k, v in pairs(itemsTable.player) do
					if v.dbID == itemId then
						itemsTable.player[v.slot].nameTag = text
					end
				end
			end
		end
	end)

addEvent("updateInUse", true)
addEventHandler("updateInUse", getRootElement(),
	function (ownerType, itemId, inuse)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)

			if itemId then
				for k, v in pairs(itemsTable[ownerType]) do
					if v.dbID == itemId then
						itemsTable[ownerType][v.slot].inUse = inuse
					end
				end
			end
		end
	end)

addEvent("unLockItem", true)
addEventHandler("unLockItem", getRootElement(),
	function (ownerType, slot)
		if itemsTable[ownerType] and itemsTable[ownerType][slot] and itemsTable[ownerType][slot].locked then
			itemsTable[ownerType][slot].locked = false
		end
	end)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "loggedIn" then
			if getElementData(source, dataName) then
				triggerServerEvent("requestWallNotes", localPlayer)

				if isTimer(perishableTimer) then
					killTimer(perishableTimer)
				end

				perishableTimer = setTimer(processPerishableItems, 60000, 0)
			end
		end

		if dataName == "playerRecipes" then
			playerRecipes = getElementData(localPlayer, "playerRecipes") or {}
		end

		if dataName == "char.Job" then
			currentJob = getElementData(localPlayer, "char.Job") or 0
		end

		if dataName == "char.ID" then
			myCharacterId = getElementData(localPlayer, "char.ID")
		end

		if dataName == "acc.adminLevel" then
			myAdminLevel = getElementData(localPlayer, "acc.adminLevel")
		end
	end)

function addItem(ownerType, dbID, slot, itemId, amount, data1, data2, data3, nameTag, serial)
	if dbID and slot and itemId and amount and not itemsTable[ownerType][slot] then
		itemsTable[ownerType][slot] = {}
		itemsTable[ownerType][slot].dbID = dbID
		itemsTable[ownerType][slot].slot = slot
		itemsTable[ownerType][slot].itemId = itemId
		itemsTable[ownerType][slot].amount = amount
		itemsTable[ownerType][slot].data1 = data1
		itemsTable[ownerType][slot].data2 = data2
		itemsTable[ownerType][slot].data3 = data3
		itemsTable[ownerType][slot].inUse = false
		itemsTable[ownerType][slot].locked = false
		itemsTable[ownerType][slot].nameTag = nameTag
		itemsTable[ownerType][slot].serial = serial
	end
end

function findEmptySlot(ownerType)
	local emptySlot = false

	for i = 0, defaultSettings.slotLimit - 1 do
		if not itemsTable[ownerType][i] then
			emptySlot = i
			break
		end
	end

	return emptySlot
end

function findEmptySlotOfKeys(ownerType)
	local emptySlot = false

	for i = defaultSettings.slotLimit, defaultSettings.slotLimit * 2 - 1 do
		if not itemsTable[ownerType][i] then
			emptySlot = i
			break
		end
	end

	return emptySlot
end

function findEmptySlotOfPapers(ownerType)
	local emptySlot = false

	for i = defaultSettings.slotLimit * 2, defaultSettings.slotLimit * 3 - 1 do
		if not itemsTable[ownerType][i] then
			emptySlot = i
			break
		end
	end

	return emptySlot
end

function processPerishableItems()
	for k, v in pairs(itemsTable.player) do
		local itemId = v.itemId

		if perishableItems[itemId] then
			local value = (tonumber(v.data3) or 0) + 1

			if value - 1 > perishableItems[itemId] then
				triggerEvent("updateData3", localPlayer, "player", v.dbID, perishableItems[itemId])
			end

			if value <= perishableItems[itemId] then
				triggerEvent("updateData3", localPlayer, "player", v.dbID, value)
			elseif perishableEvent[itemId] then
				triggerServerEvent(perishableEvent[itemId], localPlayer, v.dbID)
			end
		end
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "loggedIn") then
			setTimer(triggerServerEvent, 5000, 1, "requestCache", localPlayer)

			if isTimer(perishableTimer) then
				killTimer(perishableTimer)
			end

			perishableTimer = setTimer(processPerishableItems, 60000, 0)
		end

		for k, v in pairs(availableItems) do
			if fileExists("files/items/" .. k - 1 .. ".png") then
				itemPictures[k] = dxCreateTexture("files/items/" .. k - 1 .. ".png")
			else
				itemPictures[k] = dxCreateTexture("files/items/nopic.png")
			end
		end

		for k, v in pairs(perishableItems) do
			if itemPictures[k] then
				grayItemPictures[k] = dxCreateShader("files/monochrome.fx")

				dxSetShaderValue(grayItemPictures[k], "screenSource", itemPictures[k])
			end
		end

		for k, v in pairs(copyableItems) do
			if itemPictures[k] then
				grayItemPictures[k] = dxCreateShader("files/monochrome.fx")

				dxSetShaderValue(grayItemPictures[k], "screenSource", itemPictures[k])
			end
		end

		for k, v in pairs(craftingPositions) do
			if k <= 2 then
				craftingColshapes[k] = createColSphere(v[1], v[2], v[3], v[6])

				if isElement(craftingColshapes[k]) then
					setElementInterior(craftingColshapes[k], v[4])
					setElementDimension(craftingColshapes[k], v[5])
					setElementData(craftingColshapes[k], "craftingPosition", k, false)
				end
			else
				craftingColshapes[k] = createColCuboid(v[1], v[2], v[3], v[4], v[5], v[6])

				if isElement(craftingColshapes[k]) then
					setElementData(craftingColshapes[k], "craftingPosition", k, false)
				end
			end
		end

		playerRecipes = getElementData(localPlayer, "playerRecipes") or {}
		currentJob = getElementData(localPlayer, "char.Job") or 0

		drunkLevel = 0
		drunkEffectDuration = 0
		setCameraDrunkLevel(0) -- Reset camera effects
		if drunkEffectTimer then
			killTimer(drunkEffectTimer) -- Stop any running timers
			drunkEffectTimer = nil
		end
	end)

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (element, matchdim)
		if element == localPlayer then
			if getElementData(source, "craftingPosition") then
				currentCraftingPosition = getElementData(source, "craftingPosition")
				setElementData(localPlayer, "currentCraftingPosition", currentCraftingPosition)
			end
		end
	end)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (element)
		if element == localPlayer then
			if getElementData(source, "craftingPosition") then
				currentCraftingPosition = false
				setElementData(localPlayer, "currentCraftingPosition", currentCraftingPosition)
			end
		end
	end)

bindKey("i", "down",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			toggleInventory(not panelState)

			itemsTableState = "player"
			currentInventoryElement = localPlayer

			panelIsMoving = false

			if renameProcess then
				itemsTable.player[renameProcess].inUse = false
				renameProcess = false
				renameDetails = false
				setCursorAlpha(255)
			end
		end
	end)

local backpackIcon = false
local keyIcon = false
local walletIcon = false
local craftIcon = false 

local faTicks = {}

addEventHandler("refreshFaTicks", getRootElement(), function()
	faTicks = exports.seal_gui:getFaTicks()
end)

local guiRefreshColors = function()
	local res = getResourceFromName("seal_gui")
	if res and getResourceState(res) == "running" then
		backpackIcon = exports.seal_gui:getFaIconFilename("backpack", 36)
		keyIcon = exports.seal_gui:getFaIconFilename("key", 36)
		walletIcon = exports.seal_gui:getFaIconFilename("wallet", 36)
		craftIcon = exports.seal_gui:getFaIconFilename("hammer", 36)

		faTicks = exports.seal_gui:getFaTicks()
	end
end
addEventHandler("onGuiRefreshColors", getRootElement(), guiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), guiRefreshColors)

function toggleInventory(state)
	setElementData(localPlayer, "inventoryUsingLocalPlayer", state)
	if panelState ~= state then
		if state then
			checkRecipeHaveItem()

			if exports.seal_gui:isGuiElementValid(stackGUI) then
				exports.seal_gui:deleteGuiElement(stackGUI)
			end

			stackGUI = exports.seal_gui:createGuiElement("input", panelPosX + panelWidth - 65 - 10, panelPosY, 65, 25)
			exports.seal_gui:setInputMaxLength(stackGUI, 3)
			exports.seal_gui:setInputPlaceholder(stackGUI, "")
			exports.seal_gui:setInputPasteDisabled(stackGUI, true)
			exports.seal_gui:setInputNumberOnly(stackGUI, true)
			exports.seal_gui:setInputIcon(stackGUI, "cubes")
			exports.seal_gui:setInputFont(stackGUI, "10/Ubuntu-R.ttf")

			addEventHandler("onClientRender", getRootElement(), onRender, true, "low-998")
			panelState = true
		else
			if itemsTableState == "vehicle" or itemsTableState == "object" then
				triggerServerEvent("closeInventory", localPlayer, currentInventoryElement, getElementsByType("player", getRootElement(), true))
			end

			if itemsTableState == "object" then
				defaultSettings.weightLimit.object = oldObject
				defaultSettings.slotLimit = oldSlotLimit

				panelHeight = (defaultSettings.slotBoxHeight + 5) * math.floor(defaultSettings.slotLimit / defaultSettings.width) + 5 + 40 + 5
			end
			
			removeEventHandler("onClientRender", getRootElement(), onRender)

			panelState = false

			if exports.seal_gui:isGuiElementValid(stackGUI) then
				exports.seal_gui:deleteGuiElement(stackGUI)
			end

			stackGUI = nil
		end
	end
end

function applyRecipe(items)
	appliedRecipeItems = items
	requiredRecipeItems = {}

	if items then
		checkRecipeHaveItem()
	end
end

function checkRecipeHaveItem()
	if currentTab == "crafting" and appliedRecipeItems then
		local items = {}

		for k, v in pairs(itemsTable.player) do
			items[v.itemId] = true
		end

		for y = 0, 3 do
			requiredRecipeItems[y] = {}

			if appliedRecipeItems[y] then
				for x = 0, 3 do
					if appliedRecipeItems[y][x] then
						requiredRecipeItems[y][x] = {appliedRecipeItems[y][x], items[appliedRecipeItems[y][x]]}
					end
				end
			end
		end
	end
end

addEvent("requestCrafting", true)
addEventHandler("requestCrafting", getRootElement(),
	function (recipe, state)
		if recipe and availableRecipes[recipe] then
			if state then
				craftStartTime = getTickCount()
				setTimer(craftDone, 10000, 1, availableRecipes[recipe].finalItem)
			end

			craftingProcess = false
		end
	end)

function craftDone(item)
	if item[1] and item[2] then
		outputChatBox("#4adfbf[SealMTA]: #FFFFFFSikeresen elkészítetted a kiválasztott receptet! #32b3ef(" .. getItemName(item[1]) .. ")", 255, 255, 255, true)
		exports.seal_hud:showInfobox("success", "Sikeresen elkészítetted a kiválasztott receptet! (" .. getItemName(item[1]) .. ")")
	end
end

local craftingSounds = {}

addEvent("crafting3dSound", true)
addEventHandler("crafting3dSound", getRootElement(),
	function (typ)
		if isElement(craftingSounds[source]) then
			destroyElement(craftingSounds[source])
		end

		if typ then
			craftingSounds[source] = playSound3D("files/sounds/" .. typ .. ".mp3", getElementPosition(source))
			setElementInterior(craftingSounds[source], getElementInterior(source))
			setElementDimension(craftingSounds[source], getElementDimension(source))
			attachElements(craftingSounds[source], source)
			setTimer(
				function (sourceElement)
					craftingSounds[sourceElement] = nil
				end,
			10000, 1, source)
		end
	end)

addEvent("toggleVehicleTrunk", true)
addEventHandler("toggleVehicleTrunk", getRootElement(),
	function (state, vehicle)
		if isElement(vehicle) then
			local soundPath = false

			if state == "open" then
				soundPath = exports.seal_vehiclepanel:getDoorOpenSound(getElementModel(vehicle))
			elseif state == "close" then
				soundPath = exports.seal_vehiclepanel:getDoorCloseSound(getElementModel(vehicle))
			end

			if soundPath then
				local x, y, z = getElementPosition(vehicle)
				local int = getElementInterior(vehicle)
				local dim = getElementDimension(vehicle)
				local sound = playSound3D(soundPath, x, y, z)

				if isElement(sound) then
					setElementInterior(sound, int)
					setElementDimension(sound, dim)
				end
			end
		end
	end)

function processNotepadText()
	local chunks = {}

	noteText = {}

	for chunk in utf8.gmatch(notepadText .. "\n", "([^\n]*)\n") do
		table.insert(chunks, chunk)
	end

	for i = 1, #chunks do
		local t2 = {}

		for word in utf8.gmatch(chunks[i], "([^ ]*)") do
			table.insert(t2, word .. " ")
		end

		local str = ""

		for j = 1, #t2 do
			str = str .. t2[j]
			t2[j] = utf8.gsub(t2[j], "\n", "")

			if dxGetTextWidth(str, 1, notepadFont) + 70 > 395 then
				table.insert(noteText, "")
				str = str .. " "
			end
		end

		table.insert(noteText, str)
	end
end

function processNotepadTextEx(text, font)
	local chunks = {}
	local textlines = {}

	for chunk in utf8.gmatch(text .. "\n", "([^\n]*)\n") do
		table.insert(chunks, chunk)
	end

	for i = 1, #chunks do
		local t2 = {}

		for word in utf8.gmatch(chunks[i], "([^ ]*)") do
			table.insert(t2, word .. " ")
		end

		local str = ""

		for j = 1, #t2 do
			str = str .. t2[j]
			t2[j] = utf8.gsub(t2[j], "\n", "")

			if dxGetTextWidth(str, 1, font) + 70 > 395 then
				table.insert(textlines, "")
				str = str .. " "
			end
		end

		table.insert(textlines, str)
	end

	return textlines
end

function canWriteToNotepad()
	if #noteText >= 22 then
		return dxGetTextWidth(noteText[#noteText], 1, notepadFont) < 320
	elseif not utf8.find(noteText[#noteText], " ") then
		return dxGetTextWidth(noteText[#noteText], 1, notepadFont) <= 325
	end

	return true
end

addEventHandler("onClientCharacter", getRootElement(),
	function (char)
		if panelState then
			if renameDetails and utf8.len(renameDetails.text) < 16 then
				renameDetails.text = renameDetails.text .. char
			end
		end

		if notepadState then
			if canWriteToNotepad() then
				notepadText = notepadText .. char
				processNotepadText()
			end
		end
	end, true, "low-99999")

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if panelState then
			if renameDetails then
				cancelEvent()

				if key == "backspace" and press then
					renameDetails.text = utf8.sub(renameDetails.text, 1, utf8.len(renameDetails.text) - 1)
				end
			end

			if currentTab == "crafting" then
				if key == "mouse_wheel_up" then
					if craftListOffset > 0 then
						craftListOffset = craftListOffset - 1
					end
				elseif key == "mouse_wheel_down" then
					if craftListOffset < #craftList - 8 then
						craftListOffset = craftListOffset + 1
					end
				end
			end
		end

		if notepadState then
			cancelEvent()

			if key == "backspace" and press then
				notepadText = utf8.sub(notepadText, 1, utf8.len(notepadText) - 1)

				if 1 > utf8.len(notepadText) then
					noteText = {""}
				else
					processNotepadText()
				end
			end

			if key == "enter" and press then
				if #noteText < 22 then
					notepadText = notepadText .. "\n"
					processNotepadText()
				end
			end
		end
	end)

local deactivateDisabled = false

function disableDeactivateForDriveby()
	deactivateDisabled = true
end

addEventHandler("onClientPlayerWeaponSwitch", getRootElement(),
	function (prev, current)
		if getPedWeapon(localPlayer, current) == 0 then
			if deactivateDisabled then
				deactivateDisabled = false
				return
			end

			deactivateWeapon()
		end
	end)

function deactivateWeapon()
	local weaponInUse = false
	local ammoInUse = false

	for k, v in pairs(itemsTable.player) do
		if v.inUse then
			if isWeaponItem(v.itemId) and not weaponInUse then
				weaponInUse = weaponInUse or v
			elseif isAmmoItem(v.itemId) and not ammoInUse then
				ammoInUse = v
			end
		end
	end

	if weaponInUse then
		local slotId = weaponInUse.slot
		local itemId = itemsTable.player[slotId].itemId

		itemsTable.player[slotId].inUse = false

		triggerServerEvent("takeWeapon", localPlayer)

		if availableItems[itemId] then
			if itemId == 99 then
				exports.seal_chat:localActionC(localPlayer, "elrakott egy Nikon D600-as kamer\195\161t.")
			elseif itemId == 15 then
				if getElementData(localPlayer, "tazerReloadNeeded") then
					exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
					setElementData(localPlayer, "tazerReloadNeeded", false)
				end

				exports.seal_chat:localActionC(localPlayer, "elrakott egy sokkoló pisztolyt.")

				setElementData(localPlayer, "tazerState", false)
			else
				local itemName = getItemName(itemId)

				if getLaserColor(weaponInUse.data2) then
					itemName = itemName .. getLaserColor(weaponInUse.data2) .. " (Lézer)#C2A2DA"
				end

				if itemId == 225 then
					triggerServerEvent("equipPortalGun", resourceRoot, false)
				end

				if itemsTable.player[slotId].nameTag then
					itemName = itemName .. " (" .. itemsTable.player[slotId].nameTag .. ")"
				end

				exports.seal_chat:localActionC(localPlayer, "elrakott egy fegyvert. (" .. itemName .. ")")

				setElementData(localPlayer, "currentWeaponPaintjob", false)

				triggerEvent("movedItemInInv", localPlayer)
			end
		end

		enableWeaponFire(true)

		if ammoInUse then
			itemsTable.player[ammoInUse.slot].inUse = false
		end
	end
end

local fireworkStartTime = false
local fireworkCount = 1

addEvent("playFireworkSound", true)
addEventHandler("playFireworkSound", getRootElement(),
	function (typ)
		local x, y, z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		local sound = playSound3D("files/sounds/" .. typ .. "firework.mp3", x, y, z)

		if isElement(sound) then
			setElementInterior(sound, int)
			setElementDimension(sound, dim)
			setSoundMaxDistance(sound, 50)
		end
	end)

local lastDiceUsage = 0

addEvent("playCardSound", true)
addEventHandler("playCardSound", getRootElement(),
	function ()
		local x, y, z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)

		local sound = playSound3D("files/sounds/card.mp3", x, y, z)

		if isElement(sound) then
			setElementInterior(sound, int)
			setElementDimension(sound, dim)
		end
	end)

addEvent("playDiceSound", true)
addEventHandler("playDiceSound", getRootElement(),
	function ()
		local x, y, z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)

		local sound = playSound3D("files/sounds/dice.mp3", x, y, z)

		if isElement(sound) then
			setElementInterior(sound, int)
			setElementDimension(sound, dim)
		end
	end)

local licenseWidth = 0
local licenseHeight = 0
local licensePosX = 0
local licensePosY = 0
local licenseState = false
local licenseData = {}
local licenseRobotoL = false
local licenseLunabar = false
local licenseLunabar2 = false
local licenseType = "identityCard"
local licenseRT = false
local licenseTexture = false
local Fixedsys500c = dxCreateFont("files/fonts/Fixedsys500c.ttf", 16, false, "antialiased")
local hoverRenewLicense = false
local licensePrices = {
	identityCard = 0,--100
	fishingLicense = 200,
	carLicense = 300,
	weaponLicense = 750
}

local rottenEffect = false

addEvent("rottenEffect", true)
addEventHandler("rottenEffect", getRootElement(),
	function (damage)
		rottenEffect = {getTickCount(), damage}
	end)

local lastSpecialItemUse = 0
local lastSpecialItemUse2 = 0
currentItemInUse = false
currentItemRemainUses = false

local drunkLevel = 0
local drunkEffectDuration = 0
local drunkEffectTimer = nil

function useSpecialItem()
	if currentItemInUse then
		if getTickCount() - lastSpecialItemUse >= 5000 then
			local specialItem = specialItems[currentItemInUse.itemId]

			if specialItem then
				if specialItem[1] == "pizza" or specialItem[1] == "kebab" or specialItem[1] == "hamburger" then
					exports.seal_chat:localActionC(localPlayer, "evett valamit.")
				elseif specialItem[1] == "beer" or specialItem[1] == "wine" or specialItem[1] == "drink" or specialItem[1] == "alcohol" then
					exports.seal_chat:localActionC(localPlayer, "ivott valamit.")

					if specialItem[1] == "alcohol" then
						drunkLevel = drunkLevel + 10
						
						drunkEffectDuration = drunkEffectDuration + 10 -- Add 10 seconds per sip
						
						setCameraDrunkLevel(drunkLevel)
						
						resetDrunkEffectTimer(drunkEffectDuration)
						
						print("Drunk level is now: " .. drunkLevel)
						print("Drunk effect will last for: " .. drunkEffectDuration .. " seconds")
					end
				elseif specialItems[currentItemInUse.itemId][1] == "cigarette" or specialItems[currentItemInUse.itemId][1] == "cigarette2" then
					exports.seal_chat:localActionC(localPlayer, "szívott egy slukkot.")
				end
			end

			lastSpecialItemUse = getTickCount()
			currentItemRemainUses = currentItemRemainUses - 1

			if currentItemRemainUses >= 0 then
				itemsTable.player[currentItemInUse.slot].data1 = (tonumber(itemsTable.player[currentItemInUse.slot].data1) or 0) + 1
				triggerServerEvent("useSpecialItem", localPlayer, currentItemInUse, itemsTable.player[currentItemInUse.slot].data1)
			end

			if currentItemRemainUses == 0 then
				triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", currentItemInUse.dbID)
				triggerServerEvent("detachObject", localPlayer)
				itemsTable.player[currentItemInUse.slot].inUse = false
				currentItemInUse = false
				currentItemRemainUses = false
			end
		else
			outputChatBox("#DC143C[SealMTA]: #FFFFFFCsak 5 másodpercenként használhatod a tárgyat!", 255, 255, 255, true)
		end
	end
end

function resetDrunkEffectTimer(duration)
    if drunkEffectTimer then
        killTimer(drunkEffectTimer)
    end

    drunkEffectTimer = setTimer(function()
        drunkLevel = math.max(0, drunkLevel - 10)
        setCameraDrunkLevel(drunkLevel)

        print("Drunk effect expired, current drunk level: " .. drunkLevel)

        if drunkLevel > 0 then
            resetDrunkEffectTimer(10)
        else
            -- Csak egyszer írjuk ki, hogy vége az effektnek
            if drunkEffectTimer then
                print("Drunk effect fully worn off.")
                drunkEffectTimer = nil
            end
        end
    end, duration * 1000, 1)
end

function giveArmor(thePlayer, give)
	if give then
		if getPedArmor(thePlayer) + give <= 100 then
			triggerServerEvent("giveArmor", thePlayer, getPedArmor(thePlayer) + give)
			return true
		elseif getPedArmor(thePlayer) + give > 100 then
			triggerServerEvent("giveArmor", thePlayer, 100)
			return true
		end 
	end 
end

function useItem(itemId)
	if not itemId then
		return
	end

	if (getElementData(localPlayer, "acc.adminJail") or 0) ~= 0 then
		return
	end

	if getElementData(localPlayer, "cuffed") then
		return
	end

	local slotId = false

	itemId = tonumber(itemId)

	for k, v in pairs(itemsTable.player) do
		if v.dbID == itemId then
			slotId = k
			break
		end
	end

	if not (itemsTable.player[slotId] and itemsTable.player[slotId].amount > 0 and itemsTable.player[slotId].itemId) then
		return
	end

	local item = itemsTable.player[slotId]
	local realItemId = tonumber(item.itemId)

	-- ** Sorsjegyek
	if scratchItems[realItemId] then
		if exports.seal_lottery:isScratchTicketOpen() then
			item.inUse = false
		else
			item.inUse = true
		end

		exports.seal_lottery:showScratch(realItemId, item.dbID, item.data1, item.data2, item.data3, item.inUse)
	-- ** Lottó nyugta
	elseif realItemId == 433 then
		exports.seal_chat:localActionC(localPlayer, "kinyitja a locsolásért kapott bónusztojást.")
		exports.seal_bunny:tryToStartBunnyOpening(item.dbID)
	elseif realItemId == 436 then
		exports.seal_chest:openChest(realItemId, item.dbID)
		exports.seal_chat:localActionC(localPlayer, "kinyit egy Treasure Chestet.")
	elseif realItemId == 437 then
		exports.seal_chest:openChest(realItemId, item.dbID)
		exports.seal_chat:localActionC(localPlayer, "kinyit egy Mystery Chestet.")
	elseif realItemId == 442 then
		exports.seal_chest:openChest(realItemId, item.dbID)
		exports.seal_chat:localActionC(localPlayer, "kinyit egy Fishing Chestet.")
	elseif realItemId == 443 then
		exports.seal_chest:openChest(realItemId, item.dbID)
		exports.seal_chat:localActionC(localPlayer, "kinyit egy Pirate Chestet.")
	elseif realItemId == 295 then
		if exports.seal_lottery:isLotteryInUse() then
			item.inUse = false
		else
			item.inUse = true
		end

		exports.seal_lottery:checkLotteryTicket(item.dbID, item.inUse, item.data1, item.data2, item.data3)
	elseif realItemId == 5 then
		if not item.data1 then
			item.data1 = math.random(111111, 999999)
			triggerServerEvent("updatePhoneNumber", localPlayer, item.dbID, item.data1)
		end
		triggerEvent("openPhone", localPlayer, item.data1)
	elseif realItemId == 376 then
		local detectorState = getElementData(localPlayer, "usingMetalDetector")

		if detectorState then
		    -- Hívás a másik szkriptből
		    exports.seal_metaldetector:tryToUnUseDetector()
		else
		    -- Hívás a másik szkriptből
		    exports.seal_metaldetector:tryToUseDetector()
		end
	elseif realItemId == 289 then

		if activatedLicense == itemsTable.player[slotId].dbID or not activatedLicense then
			exports.seal_trafficlicense:openUpTheLicense(itemsTable.player[slotId].data1, itemsTable.player[slotId].dbID)

			if itemsTable.player[slotId].inUse then
				activatedLicense = false
				itemsTable.player[slotId].inUse = false
			else
				activatedLicense = itemsTable.player[slotId].dbID
				itemsTable.player[slotId].inUse = true
			end
		end
	-- ** Lottószelvény
	elseif realItemId == 294 then
		if exports.seal_lottery:isLotteryInUse() then
			item.inUse = false
		else
			item.inUse = true
		end

		exports.seal_lottery:openLotteryTicket(item.dbID, item.inUse, item.data2)
	-- ** Útlevél
	elseif realItemId == 67 then
		exports.seal_borders:togglePassport(item.dbID, item.data1, item.data2, item.data3)
	-- ** Faltörőkos
	elseif realItemId == 122 then
		if item.inUse then 
			item.inUse = false
		else
			item.inUse = true
		end
		exports.seal_dashboard:showProductLetter(item.data1, item.inUse)
	elseif realItemId == 147 then
		if exports.seal_groups:isPlayerHavePermission(localPlayer, "doorRammer") then
			exports.seal_interiors:useDoorRammer()
		else
			outputChatBox("#d75959[SealMTA]: #ffffffNem használhatod a faltörő kost.", 255, 255, 255, true)
		end
	-- ** Villogó
	-- ** Hi-Fi
	elseif realItemId == 150 then
		local nearbyHifi = false
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		for k, v in pairs(getElementsByType("object", getRootElement(), true)) do
			if getElementModel(v) == 2103 then
				local objPosX, objPosY, objPosZ = getElementPosition(v)
				if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, objPosX, objPosY, objPosZ) <= 10 then
					nearbyHifi = true
					break
				end
			end
		end

		if not nearbyHifi then
			triggerServerEvent("useItem", localPlayer, item, false, false)
		else
			outputChatBox("#d75959[SealMTA]: #ffffffMár van egy rádió a közeledben!", 255, 255, 255, true)
		end
	elseif realItemId == 123 then
		-- isElementWithinColShape
		if exports.seal_groups:isPlayerHavePermission(localPlayer, "bulletExamine") then
			local datas = split(item.data1, ";")
			local text = "Ismeretlen"

			if #datas == 3 then
				text = getWeaponNameFromIDNew(tonumber(datas[1])):gsub("^%l", string.upper) .. " - #d75959" .. datas[3] .. "#8e8e8e"
			end

			triggerEvent("updateData2", localPlayer, "player", item.dbID, text)
		end
	-- ** Ételek/Italok stb
	elseif specialItems[realItemId] then
		if not currentItemInUse then
			if getTickCount() - lastSpecialItemUse2 >= 5000 then
				lastSpecialItemUse2 = getTickCount()
				item.inUse = true

				currentItemInUse = item
				currentItemRemainUses = specialItems[realItemId][2] - (tonumber(item.data1) or 0)

				triggerServerEvent("useItem", localPlayer, item, true, specialItems[realItemId][1])
			else
				outputChatBox("#DC143C[SealMTA]: #FFFFFFCsak 5 másodpercenként használhatod a tárgyat!", 255, 255, 255, true)
			end
		else
			itemsTable.player[currentItemInUse.slot].inUse = false
			triggerServerEvent("detachObject", localPlayer)
			currentItemInUse = false
			currentItemRemainUses = false
		end	-- ** Okmányok
	elseif realItemId == 65 or realItemId == 68 or realItemId == 66 or realItemId == 74 or realItemId == 75 then
		local reopen = true

		if openedLicense ~= item then
			for k, v in pairs(itemsTable.player) do
				if (v.itemId == 65 or v.itemId == 68 or v.itemId == 308 or v.itemId == 66 or v.itemId == 74 or v.itemId == 75) and v.inUse then
					itemsTable.player[v.slot].inUse = false

					if v.itemId == 65 then
						exports.seal_license:hideLicense("id")
					elseif v.itemId == 68 then
						exports.seal_license:hideLicense("dl")
					elseif v.itemId == 75 then
						exports.seal_license:hideLicense("wp")
					elseif v.itemId == 66 then
						exports.seal_license:hideLicense("fs")
					end
				end
			end

			openedLicense = false
		else
			if item.itemId == 65 then
				exports.seal_license:hideLicense("id")
			elseif item.itemId == 68 then
				exports.seal_license:hideLicense("dl")
			elseif item.itemId == 75 then
				exports.seal_license:hideLicense("wp")
			elseif item.itemId == 66 then
				exports.seal_license:hideLicense("fs")
			end

			item.inUse = false
			openedLicense = false
			reopen = false
		end

		if not openedLicense and reopen then
			item.inUse = true
			openedLicense = item

			if realItemId == 65 then
				exports.seal_license:showLicense("id", item.data1, item.data2, item.data3)
			elseif realItemId == 68 then
				exports.seal_license:showLicense("dl", item.data1, item.data2, item.data3)
			elseif realItemId == 75 then
				exports.seal_license:showLicense("wp", item.data1, item.data2, item.data3)
			elseif realItemId == 66 then
				exports.seal_license:showLicense("fs", item.data1, item.data2, item.data3)
			end
		end
	-- ** Jegyzet
	elseif realItemId == 72 then
		if not notepadState then
			if not noteState then
				noteState = slotId
				item.inUse = true

				showCursor(true)

				notepadFont = dxCreateFont("files/fonts/hand.ttf", 16, false, "proof")
				notepadText = item.data1

				noteIsCopy = tonumber(item.data3) == 1
				noteText = {""}

				if utf8.len(notepadText) > 0 then
					processNotepadText()
				end

				exports.seal_chat:localActionC(localPlayer, "elővesz egy jegyzetet.")
			elseif noteState == slotId then
				showCursor(false)

				item.inUse = false
				notepadState = false
				notepadText = false
				noteText = false
				noteState = false

				exports.seal_chat:localActionC(localPlayer, "elrak egy jegyzetet.")

				if isElement(notepadFont) then
					destroyElement(notepadFont)
				end

				notepadFont = nil
			end
		end
	-- ** Jegyzetfüzet
	elseif realItemId == 71 then
		if not isHavePen() then
			exports.seal_hud:showInfobox("e", "Nincs tollad!")
			return
		end

		if not noteState then
			if not notepadState then
				notepadState = slotId
				item.inUse = true

				showCursor(true)

				notepadFont = dxCreateFont("files/fonts/hand.ttf", 16, false, "proof")
				notepadText = ""

				noteIsCopy = false
				noteText = {""}

				exports.seal_chat:localActionC(localPlayer, "elővesz egy jegyzetfüzetet.")
			elseif notepadState == slotId then
				showCursor(false)

				item.inUse = false
				notepadState = false
				notepadText = false
				noteText = false
				noteState = false

				exports.seal_chat:localActionC(localPlayer, "elrak egy jegyzetfüzetet.")

				if isElement(notepadFont) then
					destroyElement(notepadFont)
				end

				notepadFont = nil
			end
		end
	-- ** Blueprint
	elseif realItemId == 64 then
		if getElementData(localPlayer, "player.isBank") then
			exports.seal_bank:setCardDataByItem(item, item.slot)
		end
	elseif realItemId == 136 then
		exports.seal_groupscripting:openTheTicket(item.dbID, item.data1)
	elseif realItemId == 135 then
		exports.seal_groupscripting:openTheTicketBook()
	elseif realItemId == 299 then
		if item.data1 then
			if not availableRecipes[tonumber(item.data1)] then
				item.data1 = 1
			end

			triggerServerEvent("useItem", localPlayer, item, false, false)
		end
	-- ** Petárda
	--[[elseif realItemId == 165 or realItemId == 166 then
		if fireworkStartTime then
			if getRealTime().timestamp - fireworkStartTime < 20 then
				exports.seal_hud:showInfobox("error", "Csak fél percenként használhatod a petárdákat.")
				return
			end
		end

		triggerServerEvent("useItem", localPlayer, item, false, getElementsByType("player", getRootElement(), true))

		fireworkStartTime = getRealTime().timestamp
		fireworkCount = 1

		setTimer(
			function ()
				if fireworkCount == 1 then
					exports.seal_chat:localActionC(localPlayer, "elővesz egy petárdát.")
				elseif fireworkCount == 2 then
					exports.seal_chat:localActionC(localPlayer, "meggyújtja a petárdát")
				elseif fireworkCount == 3 then
					exports.seal_chat:localActionC(localPlayer, "eldobja a petárdát kicsit messzebb tőle.")
				elseif fireworkCount == 4 then
					exports.seal_chat:sendLocalDoC(localPlayer, "Petárda sistergés.")
				elseif fireworkCount == 5 then
					exports.seal_chat:sendLocalDoC(localPlayer, "Petárda robbanás")
				end

				fireworkCount = fireworkCount + 1
			end,
		600, 5)]]
	-- ** Item átnevezés
	elseif realItemId == 350 then
		if not renameProcess then
			renameProcess = slotId
			itemsTable.player[slotId].inUse = true
		end
	elseif realItemId == 205 then
		exports.seal_trafficlicense:useTheOBD()
	-- ** Dobókocka & Kártyapakli
	elseif realItemId == 204 then
		if getTickCount() - lastDiceUsage >= 5000 then
			lastDiceUsage = getTickCount()
			triggerServerEvent("useItem", localPlayer, item, false, getElementsByType("player", root, true))
		else
			outputChatBox("#DC143C[SealMTA]: #FFFFFFCsak 5 másodpercenként használhatod a tárgyat!", 255, 255, 255, true)
		end
	-- ** Fegyverek & töltények
	elseif realItemId == 300 then
		if (getTickCount() - lastOpenSanta) >= 48000 then
			lastOpenSanta = getTickCount()
			triggerServerEvent("openSanta", resourceRoot, itemsTable.player[slotId])
			exports.seal_chat:localActionC(localPlayer, "kinyitja az ajándékba kapott őszi falevelet.")
		end
	elseif realItemId == 301 then
		if (getTickCount() - lastOpenSanta) >= 48000 then
			lastOpenSanta = getTickCount()
			triggerServerEvent("openSanta2", resourceRoot, itemsTable.player[slotId])
			exports.seal_chat:localActionC(localPlayer, "kinyitja az ajándékát.")
		end
	elseif realItemId == 337 then
		if (getTickCount() - lastOpenSanta) >= 48000 then
			lastOpenSanta = getTickCount()
			triggerServerEvent("openPumpkin", resourceRoot, itemsTable.player[slotId])
			exports.seal_chat:localActionC(localPlayer, "kinyit egy tököt.")
		end
	elseif realItemId == 421 then
		if (getTickCount() - lastOpenSanta) >= 48000 then
			lastOpenSanta = getTickCount()
			triggerServerEvent("openVehicleCase", resourceRoot, itemsTable.player[slotId])
			exports.seal_chat:localActionC(localPlayer, "kinyit egy ládát.")
		end
	elseif realItemId == 156 then
		if (getTickCount() - lastOpenSanta) >= 48000 then
			lastOpenSanta = getTickCount()
			triggerServerEvent("openSanta12", resourceRoot, itemsTable.player[slotId])
			exports.seal_chat:localActionC(localPlayer, "kinyit egy ajándékot.")
		end
	elseif isWeaponItem(realItemId) or isAmmoItem(realItemId) then
		local weaponInUse = false
		local ammoInUse = false

		for k, v in pairs(itemsTable.player) do
			if v.inUse then
				if isWeaponItem(v.itemId) and not weaponInUse then
					weaponInUse = v
				elseif isAmmoItem(v.itemId) and not ammoInUse then
					ammoInUse = v
				end
			end
		end

		if isWeaponItem(realItemId) then
			local pedtask = getPedSimplestTask(localPlayer)

			--[[if pedtask ~= "TASK_SIMPLE_PLAYER_ON_FOOT" and pedtask ~= "TASK_SIMPLE_CAR_DRIVE" then
				return
			end]]

			if getPedControlState(localPlayer, "fire") then
				outputChatBox("#4adfbf[SealMTA]: #ffffffAmíg nyomva tartod a lövés gombot, nem veheted elő a fegyvert.", 255, 255, 255, true)
				return
			end

			if not weaponInUse then
				item.inUse = true
				weaponInUse = item

				local haveAmmo = false

				if getItemAmmoID(weaponInUse.itemId) > 0 then
					for k, v in pairs(itemsTable.player) do
						if isAmmoItem(v.itemId) and not v.inUse and getItemAmmoID(weaponInUse.itemId) == v.itemId then
							ammoInUse = v
							v.inUse = true
							haveAmmo = true
							break
						end
					end
				end

				if (not haveAmmo and getItemAmmoID(weaponInUse.itemId) == weaponInUse.itemId) or getItemAmmoID(weaponInUse.itemId) == -1 then
					ammoInUse = weaponInUse
					haveAmmo = true
				end
				iprint(haveAmmo)

				local weaponId = getItemWeaponID(weaponInUse.itemId)

				if haveAmmo then
					if weaponInUse.itemId == 15 then
						triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, weaponId, 99999, weaponInUse)
					elseif weaponInUse.itemId == ammoInUse.itemId then
						triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, weaponId, ammoInUse.amount, weaponInUse)
					else
						triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, weaponId, ammoInUse.amount + 1, weaponInUse)
					end
				else
					triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, weaponId, 1, weaponInUse)
					enableWeaponFire(false)
				end

				if availableItems[weaponInUse.itemId] then
					if weaponInUse.itemId == 99 then
						exports.seal_chat:localActionC(localPlayer, "elővett egy fényképezőgépet.")
					elseif weaponInUse.itemId == 15 then
						exports.seal_chat:localActionC(localPlayer, "elővett egy sokkoló pisztolyt.")
						setElementData(localPlayer, "tazerState", true)
					elseif weaponInUse.itemId == 225 then
						local itemName = ""

						if availableItems[weaponInUse.itemId] then
							itemName = getItemName(weaponInUse.itemId)

							if getLaserColor(weaponInUse.data2) then
								itemName = itemName .. getLaserColor(weaponInUse.data2) .. " (Lézer)#C2A2DA"
							end

							if weaponInUse.nameTag then
								itemName = " (" .. itemName .. " (" .. weaponInUse.nameTag .. "))"
							else
								itemName = " (" .. itemName .. ")"
							end
						end

						
						if itemId >= 30 and itemId <= 32 then
							setElementData(localPlayer, "canGrenade", true)
						end

						exports.seal_chat:localActionC(localPlayer, "elővett egy fegyvert." .. itemName)
						triggerServerEvent("equipPortalGun", resourceRoot, true)
					else
						local itemName = ""

						if availableItems[weaponInUse.itemId] then
							itemName = getItemName(weaponInUse.itemId)

							if getLaserColor(weaponInUse.data2) then
								itemName = itemName .. getLaserColor(weaponInUse.data2) .. " (Lézer)#C2A2DA"
							end

							if weaponInUse.nameTag then
								itemName = " (" .. itemName .. " (" .. weaponInUse.nameTag .. "))"
							else
								itemName = " (" .. itemName .. ")"
							end
						end
						
						if itemId >= 30 and itemId <= 32 then
							setElementData(localPlayer, "canGrenade", true)
						end

						exports.seal_chat:localActionC(localPlayer, "elővett egy fegyvert." .. itemName)

						setElementData(localPlayer, "currentWeaponDbID", {weaponInUse.dbID, weaponId}, false)
						setElementData(localPlayer, "currentWeaponSerial", "W" .. (tonumber(weaponInUse.serial) or 0) .. (serialItems[weaponInUse.itemId] or "-"))

						if weaponSkins[weaponInUse.itemId] then
							setElementData(localPlayer, "currentWeaponPaintjob", {weaponSkins[weaponInUse.itemId], weaponId})
						end

						triggerEvent("movedItemInInv", localPlayer)
					end
				end
			else
				if weaponInUse.dbID == itemId then
					deactivateWeapon()
				end
			end
		elseif isAmmoItem(realItemId) then
			if weaponInUse then
				if not ammoInUse then
					if getItemAmmoID(weaponInUse.itemId) == realItemId then
						enableWeaponFire(true)

						triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, getItemWeaponID(weaponInUse.itemId), item.amount + 1, weaponInUse)

						item.inUse = true
					end
				else
					if getItemWeaponID(weaponInUse.itemId) and ammoInUse.dbID == itemId then
						enableWeaponFire(false)

						triggerServerEvent("giveWeapon", localPlayer, weaponInUse.itemId, getItemWeaponID(weaponInUse.itemId), 1, weaponInUse)

						item.inUse = false
					end
				end
			end
		end
	else
		triggerServerEvent("useItem", localPlayer, item, false, false)
	end
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if rottenEffect then
			local now = getTickCount()
			local elapsedTime = now - rottenEffect[1]
			local progress = elapsedTime / 750

			local alpha = interpolateBetween(
				0, 0, 0,
				150 * rottenEffect[2] + 55, 0, 0,
				progress, "InQuad")

			if progress - 1 > 0 then
				alpha = interpolateBetween(
					150 * rottenEffect[2] + 55, 0, 0,
					0, 0, 0,
					progress - 1, "OutQuad")
			end

			if progress > 2 then
				rottenEffect = false
			end

			dxDrawImage(0, 0, screenX, screenY, "files/vin.png", 0, 0, 0, tocolor(20, 100, 40, alpha))
		end

		if notepadState or noteState then
			local cx, cy = getCursorPosition()

			if cx and cy then
				cx, cy = cx * screenX, cy * screenY
			else
				cx, cy = -1, -1
			end

			local sx, sy = 399, 527
			local x, y = math.floor(screenX / 2 - sx / 2), math.floor(screenY / 2 - sy / 2)

			if noteIsCopy then
				dxDrawImage(x, y, sx, sy, "files/pagecopy.png")
			else
				dxDrawImage(x, y, sx, sy, "files/page.png")
			end

			if notepadState then
				dxDrawRectangle(x, y + 535, 150, 32, tocolor(0, 0, 0, 150))
				dxDrawRectangle(x + 4, y + 535 + 4, 142, 24, tocolor(215, 89, 89, 160))

				dxDrawRectangle(x + sx - 150, y + 535, 150, 32, tocolor(0, 0, 0, 150))
				dxDrawRectangle(x + sx - 150 + 4, y + 535 + 4, 142, 24, tocolor(74, 223, 191, 160))

				if cx >= x and cx <= x + 150 and cy >= y + 535 and cy <= y + 535 + 32 then
					dxDrawRectangle(x + 4, y + 535 + 4, 142, 24, tocolor(215, 89, 89, 160))

					if getKeyState("mouse1") then
						showCursor(false)

						itemsTable.player[notepadState].inUse = false
						notepadState = false
						notepadText = false
						noteText = false
						noteState = false

						exports.seal_chat:localActionC(localPlayer, "elrak egy jegyzetfüzetet.")

						if isElement(notepadFont) then
							destroyElement(notepadFont)
						end

						notepadFont = nil

						return
					end
				elseif cx >= x + sx - 150 and cx <= x + sx and cy >= y + 535 and cy <= y + 535 + 32 then
					dxDrawRectangle(x + sx - 150 + 4, y + 535 + 4, 142, 24, tocolor(74, 223, 191, 160))

					if getKeyState("mouse1") then
						showCursor(false)

						itemsTable.player[notepadState].inUse = false
						notepadState = false
						noteText = false
						noteState = false

						if isHavePen() then
							exports.seal_chat:localActionC(localPlayer, "megír egy jegyzetet.")

							penSetData()
							notepadSetData()

							local str = split(notepadText:gsub("\n", " "), " ")

							triggerServerEvent("addItem", localPlayer, localPlayer, 367, 1, false, notepadText, utf8.sub((str[1] or "") .. " " .. (str[2] or "") .. " " .. (str[3] or ""), 1, 20) .. "...")
						else
							exports.seal_hud:showInfobox("e", "Nincs tollad!")
						end

						notepadText = false

						if isElement(notepadFont) then
							destroyElement(notepadFont)
						end

						notepadFont = nil

						return
					end
				end

				dxDrawText("Mégsem", x, y + 535, x + 150, y + 535 + 32, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")
				dxDrawText("Megírás", x + sx - 150, y + 535, x + sx, y + 535 + 32, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")
			else
				dxDrawRectangle(x, y + 535, sx, 32, tocolor(0, 0, 0, 150))
				dxDrawRectangle(x + 4, y + 535 + 4, sx - 8, 24, tocolor(215, 89, 89, 160))

				if cx >= x and cx <= x + sx and cy >= y + 535 and cy <= y + 535 + 32 then
					dxDrawRectangle(x + 4, y + 535 + 4, sx - 8, 24, tocolor(215, 89, 89, 160))

					if getKeyState("mouse1") then
						showCursor(false)

						itemsTable.player[noteState].inUse = false
						notepadState = false
						notepadText = false
						noteText = false
						noteState = false

						exports.seal_chat:localActionC(localPlayer, "elrak egy jegyzetet.")

						if isElement(notepadFont) then
							destroyElement(notepadFont)
						end

						notepadFont = nil

						return
					end
				end

				dxDrawText("Bezárás", x, y + 535, x + sx, y + 535 + 32, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")
			end

			if notepadState and getTickCount() - notepadCursorChange > 500 then
				notepadCursorChange = getTickCount()
				notepadCursorState = not notepadCursorState
			end

			for i = 1, 23 do
				local y2 = y + 40

				if noteIsCopy then
					dxDrawLine(x + 67, y2 + 22 * (i - 2) - 1, x + sx, y2 + 22 * (i - 2) - 1, tocolor(110, 110, 110))
				else
					dxDrawLine(x + 67, y2 + 22 * (i - 2) - 1, x + sx, y2 + 22 * (i - 2) - 1, tocolor(0, 15, 200, 185))
				end

				if noteText[i] then
					if noteIsCopy then
						dxDrawText(noteText[i], x + 70, 0, x + sx, y2 + 22 * (i - 1) + 5, tocolor(77, 77, 77), 1, notepadFont, "left", "bottom", true)
					else
						dxDrawText(noteText[i], x + 70, 0, x + sx, y2 + 22 * (i - 1) + 5, tocolor(0, 15, 85, 185), 1, notepadFont, "left", "bottom", true)
					end

					if notepadState and i == #noteText and notepadCursorState then
						local textWidth = dxGetTextWidth(noteText[i], 1, notepadFont) - 2.5

						dxDrawLine(x + 70 + textWidth, y2 + 22 * (i - 2) - 1 + 3, x + 70 + textWidth, y2 + 22 * (i - 1) - 1 - 1, tocolor(0, 15, 85), 2)
					end
				end
			end
		end

		if licenseState then
			local theX = screenX / 2
			local theY = screenY / 2

			if licenseData.iscopy then
				dxSetRenderTarget(licenseRT, true)
				theX, theY = 280 / 2, 372 / 2
			end

			local namePosX = licensePosX + 50 + 128
			local namePosY = licensePosY + 78
			local addressPosX = licensePosX + 65 + 126
			local addressPosY = licensePosY + 76 + 36 + 2
			local idPosX = licensePosX + 80 + 126
			local idPosY = addressPosY + 23
			local expirePosX = licensePosX + 100 + 126
			local expirePosY = idPosY + 13
			local signaturePosX = licensePosX + 15
			local signaturePosY = licensePosY + 180
			local renewButtonY = licenseHeight

			if licenseType == "identityCard" then
				if licenseData then
					dxDrawImage(licensePosX, licensePosY, licenseWidth, licenseHeight, ":seal_regoffice/files/bg.png")
					dxDrawText(licenseData.characterName:gsub("_", " "), namePosX, namePosY, 0, 0, tocolor(200, 200, 200, 200), 0.5, Raleway)
					dxDrawText("San Andreas", addressPosX, addressPosY, 0, 0, tocolor(200, 200, 200, 200), 0.5, Raleway)
					--dxDrawText(" " .. licenseData.itemId, idPosX, idPosY, 0, 0, tocolor(255, 255, 255), 0.5, licenseRobotoL)
					dxDrawText(licenseData.expireDate, expirePosX, expirePosY, 0, 0, tocolor(200, 200, 200, 200), 0.5, Raleway)
					dxDrawText(licenseData.characterName:gsub("_", " "), signaturePosX, signaturePosY, 0, 0, tocolor(200, 200, 200, 200), 0.5, licenseLunabar)

					if fileExists(":seal_binco/files/skins/" .. licenseData.skinId .. ".png") then
						dxDrawRectangle(licensePosX + 35, licensePosY + 80, 92, 92, tocolor(200, 200, 200))
						dxDrawImage(licensePosX + 35, licensePosY + 80, 92, 92, ":seal_binco/files/skins/" .. licenseData.skinId .. ".png")
					end
				end
			elseif licenseType == "carLicense" then
				if licenseData then
					dxDrawImage(licensePosX, licensePosY, licenseWidth, licenseHeight, ":seal_regoffice/files/car.png")
					dxDrawText(licenseData.characterName:gsub("_", " "), licensePosX + 295, licensePosY + 186, licensePosX + 378, licensePosY + 220, tocolor(0, 0, 0, 225), 0.5, licenseLunabar, "center", "center")

					local str = "Név: " .. licenseData.characterName:gsub("_", " ") .. "\n"
					str = str .. "Lakhely: Los Santos\n"
					str = str .. "Azonosító: "  .. licenseData.itemId .. "\n"
					str = str .. "Érvényesség: " .. licenseData.expireDate .. "\n"

					dxDrawText(str, licensePosX + 132, licensePosY + 69, 0, licensePosY + 69 + 101, tocolor(0, 0, 0), 0.5, Roboto, "left", "center")

					if fileExists(":seal_binco/files/skins/" .. licenseData.skinId .. ".png") then
						dxDrawRectangle(licensePosX + 17, licensePosY + 69, 101, 101, tocolor(200, 200, 200))
						dxDrawImage(licensePosX + 17, licensePosY + 69, 101, 101, ":seal_binco/files/skins/" .. licenseData.skinId .. ".png")
					end
				end
			elseif licenseType == "weaponLicense" then
				if licenseData then
					dxDrawImage(licensePosX, licensePosY, licenseWidth, licenseHeight, ":seal_regoffice/files/weapon.png")
					dxDrawText(licenseData.characterName:gsub("_", " "), licensePosX + 295, licensePosY + 186, licensePosX + 378, licensePosY + 220, tocolor(0, 0, 0, 225), 0.5, licenseLunabar, "center", "center")

					local str = "Név: " .. licenseData.characterName:gsub("_", " ") .. "\n"
					str = str .. "Lakhely: Los Santos\n"
					str = str .. "Azonosító: "  .. licenseData.itemId .. "\n"
					str = str .. "Érvényesség: " .. licenseData.expireDate .. "\n"

					dxDrawText(str, licensePosX + 132, licensePosY + 69, 0, licensePosY + 69 + 101, tocolor(0, 0, 0), 0.5, Roboto, "left", "center")

					if fileExists(":seal_binco/files/skins/" .. licenseData.skinId .. ".png") then
						dxDrawRectangle(licensePosX + 17, licensePosY + 69, 101, 101, tocolor(200, 200, 200))
						dxDrawImage(licensePosX + 17, licensePosY + 69, 101, 101, ":seal_binco/files/skins/" .. licenseData.skinId .. ".png")
					end
				end
			elseif licenseType == "fishingLicense" then
				if licenseData then
					local x = theX - 140
					local y = theY - 186

					dxDrawImage(x, y, 280, 373, ":seal_regoffice/files/fishing.png")
					dxDrawText("Név: " .. licenseData.characterName:gsub("_", " "), x + 22, y + 204, 0, y + 241, tocolor(0, 0, 0, 225), 0.5, Fixedsys500c, "left", "center")
					dxDrawText("Terület: " .. licenseData.skinId, x + 22, y + 242, 0, y + 273, tocolor(0, 0, 0, 225), 0.5, Fixedsys500c, "left", "center")
					dxDrawText("Érvényesség: " .. licenseData.expireDate, x + 22, y + 274, 0, y + 306, tocolor(0, 0, 0, 225), 0.5, Fixedsys500c, "left", "center")
					dxDrawText(licenseData.characterName:gsub("_", " "), x + 80, y + 358, x + 268, y + 370, tocolor(20, 100, 200, 225), 0.75, licenseLunabar2, "center", "bottom")

					renewButtonY = 340
				end
			end

			hoverRenewLicense = false

			if licenseData.iscopy then
				dxSetRenderTarget()

				local x = screenX / 2 - 400
				local y = screenY / 2 - 250

				dxDrawRectangle(x, y, 800, 500, tocolor(255, 255, 255))
				dxDrawImage(x + licenseData.iscopypos[1], y + licenseData.iscopypos[2], 410, 410, licenseTexture, -licenseData.iscopypos[3], 210, 210)
				dxDrawImage(x, y, 800, 500, "files/paper.png")
			else
				local px, py, pz = getElementPosition(localPlayer)
				local dist = getDistanceBetweenPoints3D(356.296875, 178.0537109375, 1008.3762207031, px, py, pz)

				if dist <= 2.5 and getElementInterior(localPlayer) == 3 and getElementDimension(localPlayer) == 13 then
					local cx, cy = getCursorPosition()

					if cx and cy then
						cx, cy = cx * screenX, cy * screenY
					end

					local x = theX - 74
					local y = licensePosY + renewButtonY

					dxDrawRectangle(x, y, 150, 32, tocolor(0, 0, 0, 200))

					if cx and cx >= x and cx <= x + 150 and cy >= y and cy <= y + 32 then
						hoverRenewLicense = true
					end

					if hoverRenewLicense then
						dxDrawRectangle(x + 4, y + 4, 142, 24, tocolor(74, 223, 191, 255))
					else
						dxDrawRectangle(x + 4, y + 4, 142, 24, tocolor(74, 223, 191, 175))
					end

					dxDrawText("Megújítás (" .. math.floor(licensePrices[licenseType] * 0.75) .. " $)", x, y, x + 150, y + 32, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")
				end
			end
		end
	end)

addEvent("failedToMoveItem", true)
addEventHandler("failedToMoveItem", getRootElement(),
	function (movedSlot, hoverSlot, amount)
		local stackAmount = exports.seal_gui:getInputValue(stackGUI)

		if not stackAmount then
			stackAmount = 0
		end
		stackAmount = tonumber(stackAmount)

		if movedSlot then
			itemsTable[itemsTableState][movedSlot] = itemsTable[itemsTableState][hoverSlot]
			itemsTable[itemsTableState][movedSlot].slot = movedSlot
			itemsTable[itemsTableState][hoverSlot] = nil
		elseif stackAmount > 0 then
			itemsTable[itemsTableState][movedSlot].amount = amount
		end
	end)

local showItemTick = 0
local lastPlaceNote = 0
local copierEffect = {}

function getPositionFromElementOffset(element, x, y, z)
	local m = getElementMatrix(element)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		   x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		   x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end

addEvent("copierEffect", true)
addEventHandler("copierEffect", getRootElement(),
	function ()
		local x, y, z = getElementPosition(source)
		local x2, y2, z2 = getPositionFromElementOffset(source, 0.2, -0.25, 0)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)

		copierEffect[source] = {}
		copierEffect[source][1] = playSound3D("files/sounds/copy.mp3", x, y, z)
		copierEffect[source][2] = createObject(1215, x2, y2, z2 + 0.8)

		setElementInterior(copierEffect[source][1], int)
		setElementDimension(copierEffect[source][1], dim)

		setElementInterior(copierEffect[source][2], int)
		setElementDimension(copierEffect[source][2], dim)
		setObjectScale(copierEffect[source][2], 0)

		x2, y2, z2 = getPositionFromElementOffset(source, 0.9, -0.25, 0)

		moveObject(copierEffect[source][2], 3080, x2, y2, z2 + 0.8)

		setTimer(
			function (sourceElement)
				if isElement(copierEffect[sourceElement][2]) then
					destroyElement(copierEffect[sourceElement][2])
				end
			end,
		3080, 1, source)

		setTimer(
			function (sourceElement)
				copierEffect[sourceElement] = nil
			end,
		7100, 1, source)
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absX, absY, worldX, worldY, worldZ, hitElement)
		-- ** Okmány megújítás
		if hoverRenewLicense then
			if button == "left" and state == "up" then
				triggerServerEvent("tryToRenewLicense", localPlayer, licenseData.itemId, math.floor(licensePrices[licenseType] * 0.75), licenseData.realItemId)

				licenseState = false
				licenseData = {}

				if isElement(licenseRT) then
					destroyElement(licenseRT)
				end

				if isElement(licenseTexture) then
					destroyElement(licenseTexture)
				end

				licenseRT = nil
				licenseTexture = nil

				for k, v in pairs(itemsTable.player) do
					if (v.itemId == 207 or v.itemId == 208 or v.itemId == 308 or v.itemId == 310) and v.inUse then
						itemsTable.player[v.slot].inUse = false

						if v.itemId == 207 then
							exports.seal_chat:localActionC(localPlayer, "elrakta a személyigazolványt.")
						elseif v.itemId == 208 then
							exports.seal_chat:localActionC(localPlayer, "elrakta a jogosítványt.")
						elseif v.itemId == 308 then
							exports.seal_chat:localActionC(localPlayer, "elrakta a fegyverengedélyt.")
						elseif v.itemId == 310 then
							exports.seal_chat:localActionC(localPlayer, "elrakta a horgászengdélyt.")
						end
					end
				end

				if isElement(Roboto) then
					destroyElement(Roboto)
				end

				if isElement(licenseLunabar) then
					destroyElement(licenseLunabar)
				end

				if isElement(licenseLunabar2) then
					destroyElement(licenseLunabar2)
				end

				Roboto = nil
				licenseLunabar = nil
				licenseLunabar2 = nil
			end
		end

		-- ** Item átnevezés
		if renameDetails and renameProcess then
			if renameDetails.activeButton and state == "up" then
				if renameDetails.activeButton == "ok" then
					if renameDetails.text == renameDetails.currentNametag then
						exports.seal_hud:showInfobox("e", "Nem lehet ugyan az a név, mint volt!")
						return
					end

					if utf8.len(renameDetails.text) >= 1 then
						triggerServerEvent("tryToRenameItem", localPlayer, renameDetails.text, renameDetails.renameItemId, itemsTable.player[renameProcess].dbID)
						renameProcess = false
						setCursorAlpha(255)
					else
						exports.seal_hud:showInfobox("e", "Nem lehet üres a név!")
						return
					end
				end

				renameDetails = false
			end

			return
		end

		if renameProcess and panelState then
			if state == "up" then
				local hoverSlotId, slotPosX, slotPosY = findSlot(absX, absY)

				if hoverSlotId and itemsTable.player[hoverSlotId] then
					local item = itemsTable.player[hoverSlotId]

					if item.amount ~= 1 then
						exports.seal_hud:showInfobox("e", "Stackelt itemet nem lehet elnevezni.")
						return
					end

					if item.data3 == "duty" then
						exports.seal_hud:showInfobox("e", "Duty itemet nem lehet elnevezni.")
						return
					end

					if item.itemId == 61 or item.itemId == 62 or item.itemId == 63 or item.itemId == 150 then
						exports.seal_hud:showInfobox("e", "Ezt az itemet nem lehet elnevezni.")
						return
					end

					if item.itemId ~= 350 then
						renameDetails = {
							x = absX,
							y = absY,
							text = item.nameTag or "",
							cursorChange = getTickCount(),
							cursorState = true,
							activeButton = false,
							renameItemId = item.dbID,
							currentNametag = item.nameTag or ""
						}
					else
						itemsTable.player[renameProcess].inUse = false
						renameProcess = false
						renameDetails = false
						setCursorAlpha(255)
					end
				elseif hoverTab and hoverTab ~= currentTab then
					if hoverTab ~= "crafting" and not renameDetails then
						currentTab = hoverTab
						playSound("files/sounds/tab.mp3")
					end
				else
					itemsTable.player[renameProcess].inUse = false
					renameProcess = false
					renameDetails = false
					setCursorAlpha(255)
				end
			end

			return
		end

		-- ** Inventory
		if button == "left" then
			if not panelState then
				return
			end

			-- ** Inventory mozgatás
			if panelIsMoving and state == "up" then
				panelIsMoving = false
				moveDifferenceX, moveDifferenceY = 0, 0
			end

			if state == "down" then
				-- ** Tabok
				if itemsTableState == "player" then
					if hoverTab and hoverTab ~= currentTab then
						currentTab = hoverTab
				
						playSound("files/sounds/tab.mp3")
				
						if currentTab == "crafting" then
							checkRecipeHaveItem()
						end
					end
				end

				-- ** Inventory mozgatás
				if absX >= panelPosX and absX <= panelPosX + panelWidth - 80 and absY >= panelPosY and absY <= panelPosY + 25 then
					moveDifferenceX = absX - panelPosX
					moveDifferenceY = absY - panelPosY
					panelIsMoving = true
					return
				end

				-- ** Craftolás
				if currentTab == "crafting" and hoverCraftButton and not craftingProcess then
					playSound("files/sounds/craftstart.mp3")

					if not playerRecipes[selectedRecipe] and not defaultRecipes[selectedRecipe] then
						if not availableRecipes[selectedRecipe].requiredJob then
							outputChatBox("#DC143C[SealMTA]: #FFFFFFEzt a receptet még nem tanultad meg!", 255, 255, 255, true)
							return
						end
					end

					if availableRecipes[selectedRecipe].requiredJob then
						if availableRecipes[selectedRecipe].requiredJob ~= currentJob then
							exports.seal_hud:showInfobox("e", "Csak '" .. exports.seal_jobhandler:getJobName(availableRecipes[selectedRecipe].requiredJob) .. "' munkával készítheted el ezt a receptet!")
							return
						end
					end

					if availableRecipes[selectedRecipe].requiredPermission then
						if not exports.seal_groups:isPlayerHavePermission(localPlayer, availableRecipes[selectedRecipe].requiredPermission) then
							exports.seal_hud:showInfobox("e", "Csak a megfelelő csoport tagjaként készítheted el ezt a receptet!")
							return
						end
					end

					if availableRecipes[selectedRecipe].suitableColShapes then
						local colshape = false

						for k, v in pairs(availableRecipes[selectedRecipe].suitableColShapes) do
							if currentCraftingPosition and currentCraftingPosition == k then
								colshape = true
								break
							end
						end

						if not colshape then
							exports.seal_hud:showInfobox("e", "Csak a megfelelő helyszínen készítheted el ezt a receptet!")
							return
						end
					end

					if not canCraftTheRecipe then
						return
					end

					local takeItems = {}

					for y = 1, 3 do
						for k, v in pairs(availableRecipes[selectedRecipe].items[y]) do
							if v then
								table.insert(takeItems, v)
							end
						end
					end

					craftingProcess = true
					triggerServerEvent("requestCrafting", localPlayer, selectedRecipe, takeItems, getElementsByType("player", getRootElement(), true))
					exports.seal_chat:localActionC(localPlayer, "barkácsol egy " .. availableRecipes[selectedRecipe].name .. "-t.")
				end

				-- ** Craft kategória választás
				if currentTab == "crafting" and hoverRecipeCategory then
					collapsedCategories[hoverRecipeCategory] = not collapsedCategories[hoverRecipeCategory]
					craftList = {}

					for i = 1, #craftRecipes do
						if craftRecipes[i].name ~= "null" then
							local category = craftRecipes[i].category

							if not craftList[category] then
								craftList[category] = true

								table.insert(craftList, {"category", category, collapsedCategories[category]})

								lastCraftCategory = #craftList
							end

							if craftList[lastCraftCategory][3] then
								table.insert(craftList, {"recipe", craftRecipes[i].id})
							else
								if selectedRecipe == craftRecipes[i].id then
									selectedRecipe = false
									applyRecipe(false)
								end
							end
						end
					end

					if #craftList > 8 then
						if craftListOffset > #craftList - 8 then
							craftListOffset = #craftList - 8
						end
					else
						craftListOffset = 0
					end
				end

				-- ** Craft recept választás
				if currentTab == "crafting" and hoverRecipe and hoverRecipe ~= selectedRecipe and not craftingProcess and not craftStartTime then
					selectedRecipe = hoverRecipe
					applyRecipe(availableRecipes[selectedRecipe].items)
					playSound("files/sounds/select.mp3")
				end

				-- ** Item mozgatás
				local hoverSlotId, slotPosX, slotPosY = findSlot(absX, absY)

				if hoverSlotId and itemsTable[itemsTableState][hoverSlotId] then
					if currentTab == "crafting" and itemsTableState ~= "vehicle" and itemsTableState ~= "object" then
						return
					end

					if not itemsTable[itemsTableState][hoverSlotId].inUse then
						haveMoving = true
						movedSlotId = hoverSlotId
						moveDifferenceX = absX - slotPosX
						moveDifferenceY = absY - slotPosY
						playSound("files/sounds/select.mp3")
					else
						outputChatBox("#DC143C[SealMTA]: #FFFFFFHasználatban lévő itemet nem mozgathatsz!", 255, 255, 255, true)
					end
				end

				return
			end

			if not movedSlotId then
				movedSlotId, haveMoving = false, false
				return
			end

			local hoverSlotId = findSlot(absX, absY)
			local movedItem = itemsTable[itemsTableState][movedSlotId]

			if absX >= panelPosX + panelWidth / 2 - 32 and absY >= panelPosY - 5 - 64 and absX <= panelPosX + panelWidth / 2 + 32 and absY <= panelPosY - 5 then
				if getTickCount() - showItemTick > 5500 then
					showItemTick = getTickCount()

					triggerServerEvent("showTheItem", localPlayer, movedItem, getElementsByType("player", getRootElement(), true))

					if availableItems[movedItem.itemId] then
						exports.seal_chat:localActionC(localPlayer, "felmutat egy tárgyat: " .. getItemName(movedItem.itemId) .. ".")
					else
						exports.seal_chat:localActionC(localPlayer, "felmutat egy tárgyat.")
					end
				end

				movedSlotId, haveMoving = false, false
				return
			end

			if not hoverSlotId then
				if isPointOnActionBar(absX, absY) then
					if itemsTableState == "player" then
						hoverSlotId = findActionBarSlot(absX, absY)

						if hoverSlotId then
							if movedItem.itemId == 350 then
								exports.seal_hud:showInfobox("e", "Névcédulát nem helyezhetsz az actionbarra.")
							else
								putOnActionBar(hoverSlotId, itemsTable[itemsTableState][movedSlotId])
								playSound("files/sounds/move.mp3")
							end
						end
					end
				end

				if not movedItem.locked and not movedItem.inUse then
					if not isPointOnActionBar(absX, absY) and not isPointOnInventory(absX, absY) then
						local px, py, pz = getElementPosition(localPlayer)

						if not isElement(hitElement) then
							local dist = getDistanceBetweenPoints3D(px, py, pz, worldX, worldY, worldZ)

							if dist <= 5 then
								-- füzetlap kitűzése falra
								if movedItem.itemId == 367 and itemsTableState == "player" then
									local cx, cy, cz = getCameraMatrix()
									local tx = cx + (worldX - cx) * 10
									local ty = cy + (worldY - cy) * 10
									local tz = cz + (worldZ - cz) * 10

									local hit, hitX, hitY, hitZ, _, nx, ny, nz, _, _, piece = processLineOfSight(
										cx, cy, cz,
										tx, ty, tz,
										true, false, false, true,
										false, false, false, false)

									if hit and piece == 0 then
										dist = getDistanceBetweenPoints3D(px, py, pz, hitX, hitY, hitZ)

										if dist < 5 then
											tx = cx + ((worldX + nx * 0.15) - cx) * 10
											ty = cy + ((worldY + ny * 0.15) - cy) * 10

											local _, _, _, _, _, nx2, ny2, nz2 = processLineOfSight(
												cx, cy, cz,
												tx, ty, tz,
												true, false, false, true,
												false, false, false, false)

											tx = cx + ((worldX - nx2 * 0.15) - cx) * 10
											ty = cy + ((worldY - ny2 * 0.15) - cy) * 10

											local _, _, _, _, _, nx3, ny3, nz3 = processLineOfSight(
												cx, cy, cz,
												tx, ty, tz,
												true, false, false, true,
												false, false, false, false)

											if nx == nx2 and nx2 == nx3 and ny == ny2 and ny2 == ny3 and nz == nz2 and nz2 == nz3 then
												local interior = getElementInterior(localPlayer)
												local dimension = getElementDimension(localPlayer)
												local canPlaceNote = true

												if getTickCount() > lastPlaceNote + 15000 then
													for id in pairs(nearbyWallNotes) do
														local note = wallNotes[id]

														if note and note[8] == dimension then
															if getDistanceBetweenPoints2D(note[4], note[5], worldX, worldY) <= 0.6 then
																if math.abs(note[6] - worldZ) <= 0.65 then
																	exports.seal_hud:showInfobox("e", "Túl közel van egy meglévő jegyzethez!")
																	canPlaceNote = false
																	break
																end
															end
														end
													end

													if canPlaceNote then
														lastPlaceNote = getTickCount()

														local iscopy = tonumber(movedItem.data3) == 1
														local pixels = render3DNote(movedItem.data1, iscopy)
														local str = ""

														if iscopy then
															str = "\n(másolat)"
														end

														triggerServerEvent("putNoteOnWall", localPlayer, pixels, worldX + nx * 0.02, worldY + ny * 0.02, worldZ, interior, dimension, nx, ny, movedItem.dbID, movedItem.data2 .. str)
													end
												else
													exports.seal_hud:showInfobox("e", "Várj még egy kicsit.")
												end
											else
												exports.seal_hud:showInfobox("e", "Csak egyenes falfelületre helyezheted fel!")
											end
										end
									end
								-- tárgy eldobása
								elseif isItemDroppable(movedItem.itemId) and not movedItem.dropped then
									local model, rx, ry, rz, offZ = getItemDropDetails(movedItem.itemId)
									local data = {}

									data.model = model or 1271
									data.posX, data.posY, data.posZ = worldX, worldY, worldZ + (offZ or 0)
									data.rotX, data.rotY, data.rotZ = rx or 0, ry or 0, rz or 0
									data.interior = getElementInterior(localPlayer)
									data.dimension = getElementDimension(localPlayer)

									triggerServerEvent("dropItem", localPlayer, movedItem, data)

									movedItem.dropped = true

									if movedItem.nameTag then
										exports.seal_chat:localActionC(localPlayer, "eldobott egy tárgyat a földre. (" .. getItemName(movedItem.itemId) .. " (" .. movedItem.nameTag .. "))")
									else
										exports.seal_chat:localActionC(localPlayer, "eldobott egy tárgyat a földre. (" .. getItemName(movedItem.itemId) .. ")")
									end
								else
									outputChatBox("#DC143C[SealMTA]: #FFFFFFEzt a tárgyat nem lehet eldobni!", 255, 255, 255, true)
									playSound("files/sounds/select.mp3")
								end
							else
								outputChatBox("#DC143C[SealMTA]: #FFFFFFIlyen messze nem dobhatsz el tárgyat!", 255, 255, 255, true)
								playSound("files/sounds/select.mp3")
							end

							movedSlotId, haveMoving = false, false
							return
						end

						local tx, ty, tz = getElementPosition(hitElement)
						local elementType = getElementType(hitElement)
						local elementModel = getElementModel(hitElement)

						if elementType == "ped" then
							if itemsTableState == "player" then
                                if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 4 then
                                    if getElementData(hitElement, "isLottery") then
                                        if movedItem.itemId == 294 then
                                            triggerServerEvent("tryToConvertLottery", localPlayer, movedItem.dbID)
                                        elseif movedItem.itemId == 295 then
                                            triggerServerEvent("checkLotteryWin", localPlayer, movedItem.dbID)
                                        end
                                    elseif getElementData(hitElement, "isScratchPed") then
                                        if scratchItems[movedItem.itemId] then
                                            exports.seal_lottery:verifyScratch(movedItem.itemId, movedItem.dbID, movedItem.data2, movedItem.data3)
                                        end
									elseif getElementData(hitElement, "csovesElement") then
                                        local csovesIdentity = getElementData(hitElement, "csovesIdentity")

                                        if csovesIdentity then
                                            triggerServerEvent("csovesCheckReceivedItems", localPlayer, csovesIdentity, movedItem)
                                        end
                                    end
                                end
                            end
						elseif elementType == "object" and elementModel == 2186 then
							if itemsTableState == "player" then
								if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 4 then
									if copierEffect[hitElement] then
										exports.seal_hud:showInfobox("e", "Ez a fénymásoló jelenleg használatban van.")
									else
										if copyableItems[movedItem.itemId] then
											triggerServerEvent("tryToCopyNote", localPlayer, movedItem, hitElement)
										end
									end
								end
							end
						elseif elementType == "object" and isTrashModel(elementModel) then
							if not getElementAttachedTo(hitElement) then
								if itemsTableState == "player" then
									if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 4 then
										if movedItem.itemId == 136 then
											exports.seal_hud:showInfobox("e", "Ezt az itemet nem lehet kidobni.")
											movedSlotId, haveMoving = false, false
											return
										end
										if availableItems[movedItem.itemId] then
											local itemName = getItemName(movedItem.itemId)

											if getLaserColor(movedItem.data2) then
												itemName = itemName .. getLaserColor(movedItem.data2) .. " (Lézer)#C2A2DA"
											end

											if movedItem.nameTag then
												itemName = itemName .. " (" .. movedItem.nameTag .. ")"
											end

											exports.seal_chat:localActionC(localPlayer, "kidobott egy tárgyat a szemetesbe. (" .. itemName .. ")")
											triggerServerEvent("playTrashSound", localPlayer)
											-- soundType, x, y, z, interior, dimension
										else
											exports.seal_chat:localActionC(localPlayer, "kidobott egy tárgyat a szemetesbe.")
										end

										local stackAmount = exports.seal_gui:getInputValue(stackGUI)

										if not stackAmount then
											stackAmount = 0
										end
										stackAmount = tonumber(stackAmount)

										if stackAmount > 0 and stackAmount < movedItem.amount then
											triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", movedItem.dbID, stackAmount)
										else
											triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", movedItem.dbID)
										end
									end
								end
							end
						else
							if movedItem.itemId == 136 then
								exports.seal_hud:showInfobox("e", "Ezt az itemet nem lehet átadni.")
								movedSlotId, haveMoving = false, false
								return
							end
							
							if movedItem.data3 == "duty" then
								outputChatBox("#DC143C[SealMTA]: #FFFFFFSzolgálati eszközzel ezt nem teheted meg!", 255, 255, 255, true)
								movedSlotId, haveMoving = false, false
								playSound("files/sounds/select.mp3")
								return
							end

							if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) > 5 then
								movedSlotId, haveMoving = false, false
								return
							end

							if elementType == "player" and hitElement == localPlayer and itemsTableState == "player" then
								outputChatBox("#DC143C[SealMTA]: #FFFFFFSaját inventoryból magadra nem húzhatsz itemet!", 255, 255, 255, true)
								movedSlotId, haveMoving = false, false
								playSound("files/sounds/select.mp3")
								return
							end

							if (itemsTableState == "vehicle" or itemsTableState == "object") and (elementType ~= "player" or hitElement ~= localPlayer) then
								outputChatBox("#DC143C[SealMTA]: #FFFFFFJárműből / széfből csak a saját inventorydba pakolhatsz!", 255, 255, 255, true)
								movedSlotId, haveMoving = false, false
								playSound("files/sounds/select.mp3")
								return
							end

							local elementId = false

							if elementType == "player" then
								elementId = getElementData(hitElement, defaultSettings.characterId)
							elseif elementType == "vehicle" then
								elementId = getElementData(hitElement, defaultSettings.vehicleId)
							elseif elementType == "object" then
								elementId = getElementData(hitElement, defaultSettings.objectId)
							end

							if tonumber(elementId) then
								itemsTable[itemsTableState][movedSlotId].locked = true

								local stackAmount = exports.seal_gui:getInputValue(stackGUI)

								if not stackAmount then
									stackAmount = 0
								end
								stackAmount = tonumber(stackAmount)

								triggerServerEvent("moveItem", localPlayer, movedItem.dbID, movedItem.itemId, movedSlotId, false, stackAmount, currentInventoryElement, hitElement)
							else
								outputChatBox("#DC143C[SealMTA]: #FFFFFFA kiválasztott elem nem rendelkezik önálló tárterülettel!", 255, 255, 255, true)
								playSound("files/sounds/select.mp3")
							end
						end
					end
				end

				movedSlotId, haveMoving = false, false
				return
			end

			if itemsTableState == "player" and isKeyItem(movedItem.itemId) and hoverSlotId < defaultSettings.slotLimit then
				hoverSlotId = findEmptySlotOfKeys("player")

				if not hoverSlotId then
					movedSlotId, haveMoving = false, false
					return
				end

				outputChatBox("#DC143C[SealMTA]: #FFFFFFEz az item átkerült a kulcsokhoz!", 255, 255, 255, true)
			end

			if itemsTableState == "player" and isPaperItem(movedItem.itemId) and hoverSlotId < defaultSettings.slotLimit then
				hoverSlotId = findEmptySlotOfPapers("player")

				if not hoverSlotId then
					movedSlotId, haveMoving = false, false
					return
				end

				outputChatBox("#DC143C[SealMTA]: #FFFFFFEz az item átkerült az iratokhoz!", 255, 255, 255, true)
			end

			if movedSlotId == hoverSlotId or not movedItem then
				movedSlotId, haveMoving = false, false
				return
			end

			if hoverSlotId >= defaultSettings.slotLimit * 2 then
				if not isPaperItem(movedItem.itemId) then
					if isKeyItem(movedItem.itemId) then
						hoverSlotId = findEmptySlotOfKeys("player")
						outputChatBox("#DC143C[SealMTA]: #FFFFFFEz az item átkerült a kulcsokhoz!", 255, 255, 255, true)
					else
						hoverSlotId = findEmptySlot("player")
						outputChatBox("#DC143C[SealMTA]: #FFFFFFEz nem irat!", 255, 255, 255, true)
					end
				end
			end

			if hoverSlotId >= defaultSettings.slotLimit and hoverSlotId < defaultSettings.slotLimit * 2 then
				if not isKeyItem(movedItem.itemId) then
					if isPaperItem(movedItem.itemId) then
						hoverSlotId = findEmptySlotOfPapers("player")
						outputChatBox("#DC143C[SealMTA]: #FFFFFFEz az item átkerült az iratokhoz!", 255, 255, 255, true)
					else
						hoverSlotId = findEmptySlot("player")
						outputChatBox("#DC143C[SealMTA]: #FFFFFFEz nem kulcs item!", 255, 255, 255, true)
					end
				end
			end

			if not movedItem.inUse and not movedItem.locked then
				local hoverItem = itemsTable[itemsTableState][hoverSlotId]

				if not hoverItem then
					local stackAmount = exports.seal_gui:getInputValue(stackGUI)

					if not stackAmount then
						stackAmount = 0
					end
					stackAmount = tonumber(stackAmount)

					triggerServerEvent("moveItem", localPlayer, movedItem.dbID, movedItem.itemId, movedSlotId, hoverSlotId, stackAmount, currentInventoryElement, currentInventoryElement)

					if stackAmount >= 0 then
						if stackAmount >= movedItem.amount or stackAmount <= 0 then
							itemsTable[itemsTableState][hoverSlotId] = itemsTable[itemsTableState][movedSlotId]
							itemsTable[itemsTableState][hoverSlotId].slot = hoverSlotId
							itemsTable[itemsTableState][movedSlotId] = nil
						elseif stackAmount > 0 then
							itemsTable[itemsTableState][movedSlotId].amount = itemsTable[itemsTableState][movedSlotId].amount - stackAmount
						end
					end

					playSound("files/sounds/move.mp3")

					movedSlotId, haveMoving = false, false
					return
				end

				local movedItemId = movedItem.itemId
				local hoverItemId = hoverItem.itemId

				if fishingLines[movedItemId] then
					if itemsTableState ~= "player" then
						exports.seal_gui:showInfobox("e", "Nem használhatod széfben/járműben.")
					elseif fishingRods[hoverItemId] then
						triggerServerEvent("useFishingLine", localPlayer, movedItem.dbID, hoverItem.dbID)
					else
						exports.seal_gui:showInfobox("e", "A damilt csak horgászbotra szerelheted fel.")
					end
				elseif fishingFloaters[movedItemId] then
					if itemsTableState ~= "player" then
						exports.seal_gui:showInfobox("e", "Nem használhatod széfben/járműben.")
					elseif fishingRods[hoverItemId] then
						triggerServerEvent("useFishingFloater", localPlayer, movedItem.dbID, hoverItem.dbID)
					else
						exports.seal_gui:showInfobox("e", "Az úszót csak horgászbotra szerelheted fel.")
					end
				end

				if movedItem.itemId == hoverItem.itemId and isItemStackable(hoverItem.itemId) then
					local stackAmount = exports.seal_gui:getInputValue(stackGUI)

					if not stackAmount then
						stackAmount = 0
					end
					stackAmount = tonumber(stackAmount)

					if stackAmount >= 0 then
						if movedItem.nameTag or hoverItem.nameTag then
							exports.seal_hud:showInfobox("e", "Elnevezett itemet nem lehet stackelni.")
						elseif (movedItem.data3 == "duty" or hoverItem.data3 == "duty") and (movedItem.data3 ~= "duty" or hoverItem.data3 ~= "duty") then
							outputChatBox("#DC143C[SealMTA]: #FFFFFFSzolgálati eszközzel ezt nem teheted meg!", 255, 255, 255, true)
						else
							if getElementData(localPlayer, "movedItemID") ~= movedItem.dbID then
								setElementData(localPlayer, "movedItemID", movedItem.dbID)
								local amount = stackAmount

								if amount <= 0 or amount >= movedItem.amount then
									amount = movedItem.amount
								end

								if waitForResponse then
									return
								end
								waitForResponse = true

								if movedItem.amount - amount > 0 then
									triggerServerEvent("stackItem", localPlayer, currentInventoryElement, movedItem.dbID, hoverItem.dbID, amount)
								else
									triggerServerEvent("stackItem", localPlayer, currentInventoryElement, movedItem.dbID, hoverItem.dbID, movedItem.amount)
								end
								triggerServerEvent("waitForResponse", resourceRoot)

								playSound("files/sounds/move.mp3")
							end
						end
					end
				end
			end

			movedSlotId, haveMoving = false, false
			return
		end

		if button == "right" then
			if state == "up" then
				local hoverSlotId = findSlot(absX, absY)

				if panelState then
					if hoverSlotId then
						if itemsTable[itemsTableState][hoverSlotId] then
							useItem(itemsTable[itemsTableState][hoverSlotId].dbID)
							movedSlotId, haveMoving = false, false
						end
					end
				end

				if not hoverSlotId and isElement(hitElement) and hitElement ~= localPlayer and hitElement ~= currentInventoryElement then
					if isPointOnInventory(absX, absY) or isPointOnActionBar(absX, absY) then
						return
					end

					local px, py, pz = getElementPosition(localPlayer)
					local tx, ty, tz = getElementPosition(hitElement)
					local elementType = getElementType(hitElement)
					local elementModel = getElementModel(hitElement)
					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

					if dist > 5 then
						return
					end

					local elementId = false

					if elementType == "vehicle" then
						elementId = tonumber(getElementData(hitElement, defaultSettings.vehicleId))

						if elementModel == 448 then
							return
						end

						if elementModel == 498 then
							return
						end

						if getPedOccupiedVehicle(localPlayer) then
							--outputChatBox("#DC143C[SealMTA]: #FFFFFFJárműben ülve nem nézhetsz bele a csomagtartóba!", 255, 255, 255, true)
							return
						end

						if not bootCheck(hitElement) then
							exports.seal_hud:showInfobox("error", "Csak a jármű csomagtartójánál állva nézhetsz bele a csomagterébe!")
							return
						end
					elseif elementType == "object" then
						elementId = tonumber(getElementData(hitElement, defaultSettings.objectId))
					end

					if elementId then
						triggerServerEvent("requestItems", localPlayer, hitElement, elementId, elementType, getElementsByType("player", root, true))
					elseif dist < 1.75 then
						local worldItemId = tonumber(getElementData(hitElement, "worldItem"))

						if worldItemId then
							triggerServerEvent("pickUpItem", localPlayer, worldItemId)
						end
					end
				end
			end
		end
	end)

local bootlessModel = {
	[409] = true,
	[416] = true,
	[433] = true,
	[427] = true,
	[490] = true,
	[528] = true,
	[407] = true,
	[544] = true,
	[523] = true,
	[470] = true,
	[596] = true,
	[598] = true,
	[599] = true,
	[597] = true,
	[432] = true,
	[601] = true,
	[428] = true,
	[431] = true,
	[420] = true,
	[525] = true,
	[408] = true,
	[552] = true,
	[499] = true,
	[609] = true,
	[498] = true,
	[524] = true,
	[532] = true,
	[578] = true,
	[486] = true,
	[406] = true,
	[573] = true,
	[455] = true,
	[588] = true,
	[403] = true,
	[423] = true,
	[414] = true,
	[443] = true,
	[515] = true,
	[514] = true,
	[531] = true,
	[456] = true,
	[459] = true,
	[422] = true,
	[482] = true,
	[605] = true,
	[530] = true,
	[418] = true,
	[572] = true,
	[582] = true,
	[413] = true,
	[440] = true,
	[543] = true,
	[583] = true,
	[478] = true,
	[554] = true
}

function bootCheck(veh)
	local cx, cy, cz = getVehicleComponentPosition(veh, "boot_dummy", "world")

	if not cx or not cy or getVehicleType(veh) ~= "Automobile" or bootlessModel[getElementModel(veh)] then
		return true
	end

	local px, py, pz = getElementPosition(localPlayer)
	local vx, vy, vz = getElementPosition(veh)
	local vrx, vry, vrz = getElementRotation(veh)
	local angle = math.rad(270 + vrz)

	cx = cx + math.cos(angle) * 1.5
	cy = cy + math.sin(angle) * 1.5

	if getDistanceBetweenPoints3D(px, py, pz, cx, cy, cz) < 1 then
		return true
	end

	return false
end

function findSlot(x, y)
	if panelState then
		local slotId = false
		local slotPosX, slotPosY = false, false

		for i = 0, defaultSettings.slotLimit - 1 do
			local x2 = panelPosX + (defaultSettings.slotBoxWidth + 5) * (i % defaultSettings.width)
			local y2 = panelPosY + 35 + (defaultSettings.slotBoxHeight + 5) * math.floor(i / defaultSettings.width)

			if x >= x2 and x <= x2 + defaultSettings.slotBoxWidth and y >= y2 and y <= y2 + defaultSettings.slotBoxHeight then
				slotId = tonumber(i)
				slotPosX, slotPosY = x2, y2
				break
			end
		end

		if slotId then
			if itemsTableState == "player" and currentTab == "keys" then
				slotId = slotId + defaultSettings.slotLimit
			elseif itemsTableState == "player" and currentTab == "papers" then
				slotId = slotId + defaultSettings.slotLimit * 2
			end

			return slotId, slotPosX, slotPosY
		else
			return false
		end
	else
		return false
	end
end

function isPointOnInventory(x, y)
	if panelState then
		if x >= panelPosX and x <= panelPosX + panelWidth and y >= panelPosY and y <= panelPosY + panelHeight then
			return true
		else
			return false
		end
	else
		return false
	end
end

function getLocalPlayerItems()
	return itemsTable.player
end

local showedItems = {}
local showItemHandler = false

addEvent("showTheItem", true)
addEventHandler("showTheItem", getRootElement(),
	function (item)
		table.insert(showedItems, {
			source, getTickCount(), item,
			dxCreateRenderTarget(256, 96 + defaultSettings.slotBoxHeight, true)
		})

		processShowItem()
	end)

function processShowItem(hide)
	if #showedItems > 0 then
		if not showItemHandler then
			addEventHandler("onClientRender", getRootElement(), renderShowItem)
			addEventHandler("onClientRestore", getRootElement(), processShowItem)
			showItemHandler = true
		end

		if not hide and showedItems then
			local sx = defaultSettings.slotBoxWidth * 1.1
			local sy = defaultSettings.slotBoxHeight * 1.1

			for i = 1, #showedItems do
				local v = showedItems[i]

				if v then
					local item = v[3]

					dxSetRenderTarget(v[4], true)
					dxSetBlendMode("modulate_add")

					local x, y = math.floor(128 - sx / 2), 0

					drawItemPicture(item, x, y, sx, sy)
					dxDrawText(item.amount, x + sx - 6, y + sy - 15, x + sx, y + sy - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")

					if availableItems[item.itemId] then
						processTooltip(128, defaultSettings.slotBoxHeight + 16, getItemName(item.itemId), item.itemId, item, true)
					end
				end
			end

			dxSetBlendMode("blend")
			dxSetRenderTarget()
		end
	elseif showItemHandler then
		removeEventHandler("onClientRender", getRootElement(), renderShowItem)
		removeEventHandler("onClientRestore", getRootElement(), processShowItem)

		showItemHandler = false
	end
end

function renderShowItem()
	local now = getTickCount()
	local cx, cy, cz = getCameraMatrix()
	local px, py, pz = getElementPosition(localPlayer)

	if showedItems then
		for i = 1, #showedItems do
			local v = showedItems[i]

			if v then
				local elapsedTime = now - v[2]
				local progress = 255

				if elapsedTime < 500 then
					progress = 255 * elapsedTime / 500
				end

				if elapsedTime > 5000 then
					progress = 255 - (255 * (elapsedTime - 5000) / 500)

					if progress < 0 then
						progress = 0
					end

					if elapsedTime > 5500 then
						showedItems[i] = nil
						processShowItem(true)
					end
				end

				if v then
					local source = v[1]

					if isElement(source) then
						local tx, ty, tz = getElementPosition(source)
						local dist = getDistanceBetweenPoints3D(tx, ty, tz, px, py, pz)

						if dist < 10 and isLineOfSightClear(cx, cy, cz, tx, ty, tz, true, false, false, true, false, true, false) then
							local scale = 1

							if dist > 7.5 then
								scale = 1 - (dist - 7.5) / 2.5
							end

							local x, y, z = getPedBonePosition(source, 5)

							if x and y and z then
								x, y = getScreenFromWorldPosition(x, y, z + 0.55)

								if x and y then
									x = math.floor(x - 128)
									y = math.floor(y - (96 + defaultSettings.slotBoxHeight) / 2)

									dxDrawImage(x, y + (255 - progress) / 4, 256, 96 + defaultSettings.slotBoxHeight, v[4], 0, 0, 0, tocolor(255, 255, 255, progress * 0.9 * scale))
								end
							end
						end
					end
				end
			end
		end
	end
end

function onRender()
	local cx, cy = getCursorPosition()

	if tonumber(cx) then
		cx = cx * screenX
		cy = cy * screenY

		if panelIsMoving then
			panelPosX = cx - moveDifferenceX
			panelPosY = cy - moveDifferenceY

			exports.seal_gui:setGuiPosition(stackGUI, panelPosX + panelWidth - 65 - 10, panelPosY + 2.5)
		end
	else
		cx, cy = -1, -1
	end

	if currentInventoryElement ~= localPlayer and isElement(currentInventoryElement) then
		local px, py, pz = getElementPosition(localPlayer)
		local tx, ty, tz = getElementPosition(currentInventoryElement)

		if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) >= 5 then
			toggleInventory(false)
			return
		end
	end

	dxDrawRectangle(panelPosX - 5, panelPosY - 5, panelWidth, panelHeight, tocolor(33, 35, 36)) -- background
	dxDrawRectangle(panelPosX - 5, panelPosY - 5, panelWidth, 36, tocolor(23, 25, 24, 100)) -- title

	-- ** Item mennyiség @ Súly
	local weightLimit = getWeightLimit(itemsTableState, currentInventoryElement)
	local weight = 0
	local items = 0

	for k, v in pairs(itemsTable[itemsTableState]) do
		if availableItems[v.itemId] then
			weight = weight + getItemWeight(v.itemId) * v.amount
		end

		if itemsTableState == "player" then
			if currentTab == "keys" then
				if v.slot >= 50 and v.slot < 100 then
					items = items + 1
				end
			elseif currentTab == "papers" then
				if v.slot >= 100 then
					items = items + 1
				end
			elseif v.slot < 50 then
				items = items + 1
			end
		else
			items = items + 1
		end
	end

	if weightLimit < weight then
		weight = weightLimit
	end

	dxDrawRectangle(panelPosX, panelPosY + panelHeight - 15, panelWidth - 10, 5, tocolor(23, 25, 24))
	dxDrawRectangle(panelPosX, panelPosY + panelHeight - 15, (panelWidth - 10) * (weight / weightLimit), 5, tocolor(74, 223, 191))

	if cx >= panelPosX and cx <= panelPosX + panelWidth - 10 and cy >= panelPosY + panelHeight - 15 and cy <= panelPosY + panelHeight - 15 + 5 then
		hoverTab = "weightTool"
	end

	if hoverTab == "weightTool" then
		local tooltipW = dxGetTextWidth(math.ceil(weight) .. "/" .. weightLimit .. "kg", 1, Ubuntu11) + 10
		local tooltipH = dxGetFontHeight(1, Ubuntu11) + 10

		local x, y = cx + 10, cy + 10
		dxDrawRectangle(x, y, tooltipW, tooltipH, tocolor(0, 0, 0, 160))
		dxDrawText(math.ceil(weight) .. "/" .. weightLimit .. "kg", x, y, x + tooltipW, y + tooltipH, tocolor(233, 233, 233), 1, tooltipFont, "center", "center")
	end
	
	if itemsTableState == "player" then
		if hoverTab ==  "main" or hoverTab ==  "keys" or hoverTab ==  "papers" or hoverTab == "crafting" then
			if hoverTab == "main" then
				hoverText = "Tárgyak"
			elseif hoverTab == "keys" then
				hoverText = "Kulcsok"
			elseif hoverTab == "papers" then
				hoverText = "Iratok"
			elseif hoverTab == "crafting" then
				hoverText = "Craft"
			end

			if hoverText then
				local tooltipW = dxGetTextWidth(hoverText, 1, Ubuntu11) + 10
				local tooltipH = dxGetFontHeight(1, Ubuntu11) + 10
		
				local x, y = cx + 10, cy + 10
				dxDrawRectangle(x, y, tooltipW, tooltipH, tocolor(0, 0, 0, 160), true)
				dxDrawText(hoverText, x, y, x + tooltipW, y + tooltipH, tocolor(233, 233, 233), 1, Ubuntu11, "center", "center", false, false, true)
			end
		end
	end

	-- ** Cím
	local invTypText = "TÁRGYAK "

	if itemsTableState == "vehicle" then
		invTypText = "CSOMAGTARTÓ "
	elseif itemsTableState == "object" then
		invTypText = "SZÉF "
	elseif currentTab == "keys" then
		invTypText = "KULCSOK "
	elseif currentTab == "papers" then
		invTypText = "IRATOK "
	elseif currentTab == "crafting" then
		invTypText = "CRAFT"
	end

	if currentTab == "crafting" then
		if selectedRecipe then
			craftTabText = invTypText .. ": #4adfbf" .. availableRecipes[selectedRecipe].name
		else
			craftTabText = invTypText .. "#4adfbf"
		end

		dxDrawText(craftTabText, panelPosX, panelPosY - 5, panelPosX + panelWidth, panelPosY - 5 + 34, tocolor(255, 255, 255, 255), 1, inventoryFont, "center", "center", false, false, false, true)
	else
		dxDrawText(invTypText .. "#4adfbf" .. items .. "#ffffff / " .. defaultSettings.slotLimit, panelPosX, panelPosY - 5, panelPosX + panelWidth, panelPosY - 5 + 34, tocolor(255, 255, 255, 255), 1, inventoryFont, "center", "center", false, false, false, true)
	end

	-- ** Kategóriák
	local sizeForTabs = (panelHeight - 20 - 10) / 4
	local tabStartX = panelPosX - 5
	local tabStartY = panelPosY - 5

	hoverTab = false

	if cx >= tabStartX and cx <= tabStartX + 30 and cy >= tabStartY + 3 and cy <= tabStartY + 3 + 30 then
		hoverTab = "main"
	elseif cx >= tabStartX + 30 and cx <= tabStartX + 30 + 30 and cy >= tabStartY + 3 and cy <= tabStartY + 3 + 30 then
		hoverTab = "keys"
	elseif cx >= tabStartX + 60 and cx <= tabStartX + 60 + 30 and cy >= tabStartY + 3 and cy <= tabStartY + 3 + 30 then
		hoverTab = "papers"
	elseif cx >= tabStartX + 90 and cx <= tabStartX + 90 + 30 and cy >= tabStartY + 3 and cy <= tabStartY + 3 + 30 then
		hoverTab = "crafting"
	end

	if itemsTableState == "player" then 
		if currentTab == "main" then
			dxDrawImage(tabStartX, tabStartY + 3, 30, 30, ":seal_gui/" .. backpackIcon .. faTicks[backpackIcon], 0, 0, 0, tocolor(74, 223, 191))
		elseif hoverTab == "main" then
			dxDrawImage(tabStartX, tabStartY + 3, 30, 30, ":seal_gui/" .. backpackIcon .. faTicks[backpackIcon], 0, 0, 0, tocolor(138, 139, 141, 200))
		else
			dxDrawImage(tabStartX, tabStartY + 3, 30, 30, ":seal_gui/" .. backpackIcon .. faTicks[backpackIcon], 0, 0, 0, tocolor(138, 139, 141, 150))
		end

		if currentTab == "keys" then
			dxDrawImage(tabStartX + 30, tabStartY + 3, 30, 30, ":seal_gui/" .. keyIcon .. faTicks[keyIcon], 0, 0, 0, tocolor(74, 223, 191))
		elseif hoverTab == "keys" then
			dxDrawImage(tabStartX + 30, tabStartY + 3, 30, 30, ":seal_gui/" .. keyIcon .. faTicks[keyIcon], 0, 0, 0, tocolor(138, 139, 141, 200))
		else
			dxDrawImage(tabStartX + 30, tabStartY + 3, 30, 30, ":seal_gui/" .. keyIcon .. faTicks[keyIcon], 0, 0, 0, tocolor(138, 139, 141, 150))
		end

		if currentTab == "papers" then
			dxDrawImage(tabStartX + 60, tabStartY + 3, 30, 30, ":seal_gui/" .. walletIcon .. faTicks[walletIcon], 0, 0, 0, tocolor(74, 223, 191))
		elseif hoverTab == "papers" then
			dxDrawImage(tabStartX + 60, tabStartY + 3, 30, 30, ":seal_gui/" .. walletIcon .. faTicks[walletIcon], 0, 0, 0, tocolor(138, 139, 141, 200))
		else
			dxDrawImage(tabStartX + 60, tabStartY + 3, 30, 30, ":seal_gui/" .. walletIcon .. faTicks[walletIcon], 0, 0, 0, tocolor(138, 139, 141, 150))
		end

		if currentTab == "crafting" then
			dxDrawImage(tabStartX + 90, tabStartY + 3, 30, 30, ":seal_gui/" .. craftIcon .. faTicks[craftIcon], 0, 0, 0, tocolor(74, 223, 191))
		elseif hoverTab == "crafting" then
			dxDrawImage(tabStartX + 90, tabStartY + 3, 30, 30, ":seal_gui/" .. craftIcon .. faTicks[craftIcon], 0, 0, 0, tocolor(138, 139, 141, 200))
		else
			dxDrawImage(tabStartX + 90, tabStartY + 3, 30, 30, ":seal_gui/" .. craftIcon .. faTicks[craftIcon], 0, 0, 0, tocolor(138, 139, 141, 150))
		end
	end

	-- ** Craft
	if currentTab == "crafting" and itemsTableState ~= "vehicle" and itemsTableState ~= "object" then
		local requiredCount = 0
		local availableCount = 0

		for i = 0, 24 do
			local x = i % 5
			local y = math.floor(i / 5)

			local x2 = panelPosX + (defaultSettings.slotBoxWidth + 5) * x
			local y2 = panelPosY + 35 + (defaultSettings.slotBoxHeight + 5) * y

			if requiredRecipeItems and requiredRecipeItems[y] and requiredRecipeItems[y][x] then
				local recipe = requiredRecipeItems[y][x]
				local state = ""

				if recipe[2] then
					dxDrawRectangle(x2, y2, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, tocolor(74, 223, 191, 200))
					availableCount = availableCount + 1
				else
					dxDrawRectangle(x2, y2, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, tocolor(215, 89, 89, 200))
					state = "2"
				end

				dxDrawImage(x2, y2, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, "files/items/" .. recipe[1] - 1 .. ".png")
				dxDrawImage(x2 - 3, y2 - 3, 42, 42, "files/used" .. state .. ".png", 0, 0, 0, tocolor(255, 255, 255, 150))

				if cx >= x2 and cx <= x2 + defaultSettings.slotBoxWidth and cy >= y2 and cy <= y2 + defaultSettings.slotBoxHeight then
					if craftDoNotTakeItems[recipe[1]] then
						showTooltip(cx, cy, availableItems[recipe[1]][1], "Szükséges a recepthez, többször használatos")
					else
						showTooltip(cx, cy, availableItems[recipe[1]][1], "Szükséges a recepthez")
					end
				end

				requiredCount = requiredCount + 1
			else
				dxDrawRectangle(x2, y2, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, tocolor(23, 25, 24, 150))
				dxDrawImage(x2, y2, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, ":seal_hud/files/images/shadow2.png", 0, 0, 0, tocolor(23, 25, 24))
			end
		end
		

		local x = panelPosX + (defaultSettings.slotBoxWidth + 5) * 5 + 8
		local y = panelPosY + 13

		local sx = panelPosX + panelWidth - 16 - x
		local sy = (panelHeight + 15 - 45 - 5) / 10 + 0.2

		local hasAllRecipeItems = false

		if requiredCount == availableCount then
			hasAllRecipeItems = true
		end

		y = y + sy

		for i = 1, 8 do
			local y2 = y + (i - 1) * sy
			local rowalpha = 100

			if i % 2 ~= craftListOffset % 2 then
				rowalpha = 125
			end

			local craft = craftList[i + craftListOffset]

			if craft then
				local textcolor = tocolor(255, 255, 255)

				if craft[1] == "category" then
					rowalpha = 150

					if not craftingProcess and cx >= x and cx <= x + sx and cy >= y2 and cy <= y2 + sy then
						textcolor = tocolor(74, 223, 191)
						rowalpha = 170

						if hoverRecipeCategory ~= craft[2] then
							hoverRecipeCategory = craft[2]
							playSound("files/sounds/hover.mp3")
						end
					elseif hoverRecipeCategory == craft[2] then
						hoverRecipeCategory = false
					end

					local color = craft[3] and tocolor(74, 223, 191) or textcolor

					--dxDrawRectangle(x, y2, sx, sy, tocolor(50, 55, 68, 100))
					dxDrawImageSection(math.floor(x) + 5, math.floor(y2) + 4, sy - 8, sy - 8, craft[3] and 32 or 0, 0, 32, 32, "files/arrows.png", 0, 0, 0, color)
					dxDrawText(craft[2], x + 5 + sy - 4, y2, x + sx, y2 + sy, color, 0.9, Ubuntu11, "left", "center", true)
				else
					if craft[1] == "recipe" and craft[2] then
						local id = craft[2]
						local recipe = availableRecipes[id]

						if recipe then
							if selectedRecipe == id then
								rowalpha = 200
							end

							if not craftingProcess and selectedRecipe ~= id and cx >= x and cx <= x + sx and cy >= y2 and cy <= y2 + sy then
								textcolor = tocolor(74, 223, 191)
								rowalpha = 200

								if hoverRecipe ~= id then
									hoverRecipe = id
									playSound("files/sounds/hover.mp3")
								end

								if recipe.requiredJob then
									if recipe.suitableColShapes then
										showTooltip(cx, cy, "#ffffffMunka: #d75959Szükséges", "Pozíció: #d75959Szükséges")
									else
										showTooltip(cx, cy, "#ffffffMunka: #d75959Szükséges", "Pozíció: #4adfbfNem szükséges")
									end
								elseif recipe.requiredPermission then
									if recipe.suitableColShapes then
										showTooltip(cx, cy, "#ffffffCsoport: #d75959Szükséges", "Pozíció: #d75959Szükséges")
									else
										showTooltip(cx, cy, "#ffffffCsoport: #d75959Szükséges", "Pozíció: #4adfbfNem szükséges")
									end
								elseif recipe.suitableColShapes then
									showTooltip(cx, cy, "Pozíció: #d75959Szükséges")
								end
							elseif hoverRecipe == id then
								hoverRecipe = false
							end
						else
							hoverRecipe = false
						end

						if i % 2 == 0 then
							dxDrawRectangle(x, y2, sx, sy, tocolor(33, 35, 36))
						else
							dxDrawRectangle(x, y2, sx, sy, tocolor(49, 52, 53))
						end

						if recipe then
							textcolor = tocolor(150, 150, 150, 150)

							if playerRecipes[id] or defaultRecipes[id] or (availableRecipes[id].requiredJob and availableRecipes[id].requiredJob == currentJob) then
								textcolor = tocolor(255, 255, 255)

								if hoverRecipe == id or selectedRecipe == id then
									textcolor = tocolor(74, 223, 191)
								end
							elseif hoverRecipe == id or selectedRecipe == id then
								textcolor = tocolor(74, 223, 191, 175)
							end

							dxDrawText(recipe.name, x + 15, y2, x + sx, y2 + sy, textcolor, 0.9, Ubuntu11, "left", "center", true)
						end
					else
						dxDrawRectangle(x, y2, sx, sy, tocolor(82, 87, 89))
					end
				end
			else
				dxDrawRectangle(x, y2, sx, sy, tocolor(23, 25, 24, 100))
			end
		end

		local listHeight = sy * 8

		if #craftList > 8 then
			dxDrawRectangle(x + sx - 5, y, 5, listHeight, tocolor(23, 25, 24, 100))
			dxDrawRectangle(x + sx - 5, y + craftListOffset * (listHeight / (#craftList - 8 + 1)), 5, listHeight / (#craftList - 8 + 1), tocolor(74, 223, 191, 170))
		end

		hoverCraftButton = false
		canCraftTheRecipe = false

		if selectedRecipe then
			local r, g, b, a = 74, 223, 191, 170

			if cx >= x and cx <= x + sx and cy >= y + listHeight + 4 and cy <= y + listHeight + 4 + sy - 4 then
				if not craftingProcess and not craftStartTime then
					hoverCraftButton = true
				end

				a = 255
			end

			if not hasAllRecipeItems or craftStartTime then
				r, g, b = 215, 89, 89, 170
			end

			if not hasAllRecipeItems or craftStartTime or not playerRecipes[selectedRecipe] and not defaultRecipes[selectedRecipe] and (not availableRecipes[selectedRecipe].requiredJob or availableRecipes[selectedRecipe].requiredJob ~= currentJob) then
				canCraftTheRecipe = false
			elseif a > 200 then
				canCraftTheRecipe = true
			else
				canCraftTheRecipe = false
			end

			dxDrawRectangle(x, y + listHeight + 4, sx, sy - 4, tocolor(r, g, b, a))

			if craftStartTime then
				local now = getTickCount()

				if now >= craftStartTime then
					local progress = (now - craftStartTime) / 10000

					if progress > 1 then
						progress = 1
						craftStartTime = false
					end

					dxDrawRectangle(x, y + listHeight + 4, sx * progress, sy - 4, tocolor(74, 223, 191, 170))
				end
			end

			if playerRecipes[selectedRecipe] or defaultRecipes[selectedRecipe] or (availableRecipes[selectedRecipe].requiredJob and availableRecipes[selectedRecipe].requiredJob == currentJob) then
				dxDrawText("Elkészít", x, y + listHeight + 4, x + sx, y + listHeight + 4 + sy - 4, tocolor(255, 255, 255), 0.9, Ubuntu11, "center", "center")
			elseif availableRecipes[selectedRecipe].requiredJob then
				dxDrawText("Nincs felvéve a munka!", x, y + listHeight + 4, x + sx, y + listHeight + 4 + sy - 4, tocolor(255, 255, 255), 0.9, Ubuntu11, "center", "center")
			else
				dxDrawText("Nincs elsajátítva a recept!", x, y + listHeight + 4, x + sx, y + listHeight + 4 + sy - 4, tocolor(255, 255, 255), 0.9, Ubuntu11, "center", "center")
			end
		else
			dxDrawRectangle(x, y + listHeight + 4, sx, sy - 4, tocolor(215, 89, 89, 175))
			dxDrawText("Válassz egy receptet!", x, y + listHeight + 4, x + sx, y + listHeight + 4 + sy - 4, tocolor(255, 255, 255), 0.9, Ubuntu11, "center", "center")
		end
	-- ** Item slotok @ Itemek
	else
		for i = 0, defaultSettings.slotLimit - 1 do
			local slot = i
			local x = panelPosX + (defaultSettings.slotBoxWidth + 5) * (slot % defaultSettings.width)
			local y = panelPosY + 35 + (defaultSettings.slotBoxHeight + 5) * math.floor(slot / defaultSettings.width)

			if itemsTableState == "player" and currentTab == "keys" then
				i = i + defaultSettings.slotLimit
			elseif itemsTableState == "player" and currentTab == "papers" then
				i = i + defaultSettings.slotLimit * 2
			end

			local item = itemsTable[itemsTableState]

			if item then
				item = itemsTable[itemsTableState][i]

				if item and not availableItems[item.itemId] then
					item = false
				end
			end

			local slotColor = tocolor(23, 25, 24, 150)
			local slotColor2 = tocolor(23, 25, 24)

			if item and item.inUse then
				slotColor = tocolor(50, 178, 238)
			end

			if cx >= x and cx <= x + defaultSettings.slotBoxWidth and cy >= y and cy <= y + defaultSettings.slotBoxHeight and not renameDetails then
				slotColor = tocolor(50, 178, 238, 150)
				slotColor2 = tocolor(50, 178, 238)

				if item and not movedSlotId then
					if not renameProcess then
						processTooltip(cx, cy, getItemName(item.itemId), item.itemId, item, false)
					else
						slotColor = tocolor(50, 178, 238, 150)
						slotColor2 = tocolor(50, 178, 238)
					end

					if lastHoverSlotId ~= i then
						lastHoverSlotId = i
						playSound("files/sounds/hover.mp3")
					end
				end
			elseif lastHoverSlotId == i then
				lastHoverSlotId = false
			end

			dxDrawRectangle(x, y, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, slotColor)
			dxDrawImage(x, y, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, ":seal_hud/files/images/shadow2.png", 0, 0, 0, slotColor2)

			local stackAmount = exports.seal_gui:getInputValue(stackGUI)

			if not stackAmount then
				stackAmount = 0
			end
			stackAmount = tonumber(stackAmount)

			if item and (movedSlotId ~= i or movedSlotId == i and stackAmount > 0 and stackAmount < item.amount) then
				drawItemPicture(item, x, y)
				dxDrawText(item.amount, x + defaultSettings.slotBoxWidth - 6, y + defaultSettings.slotBoxHeight - 15, x + defaultSettings.slotBoxWidth, y + defaultSettings.slotBoxHeight - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")
			end
		end

		-- ** Mozgatott item
		if movedSlotId then
			dxDrawImage(panelPosX + panelWidth / 2 - 32, panelPosY - 5 - 64, 64, 64, "files/eye.png", 0, 0, 0, tocolor(255, 255, 255, 125))

			if cx >= panelPosX + panelWidth / 2 - 32 and cy >= panelPosY - 5 - 64 and cx <= panelPosX + panelWidth / 2 + 32 and cy <= panelPosY - 5 then
				if getTickCount() - showItemTick > 5500 then
					dxDrawImage(panelPosX + panelWidth / 2 - 32, panelPosY - 5 - 64, 64, 64, "files/eye.png", 0, 0, 0, tocolor(255, 255, 255, 200))
				end
			end

			local x = cx - moveDifferenceX
			local y = cy - moveDifferenceY

			drawItemPicture(itemsTable[itemsTableState][movedSlotId], x, y)

			local stackAmount = exports.seal_gui:getInputValue(stackGUI)

			if not stackAmount then
				stackAmount = 0
			end
			stackAmount = tonumber(stackAmount)

			if stackAmount < itemsTable[itemsTableState][movedSlotId].amount then
				if stackAmount > 0 then
					dxDrawText(stackAmount, x + defaultSettings.slotBoxWidth - 6, y + defaultSettings.slotBoxHeight - 15, x + defaultSettings.slotBoxWidth, y + defaultSettings.slotBoxHeight - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")
				else
					dxDrawText(itemsTable[itemsTableState][movedSlotId].amount, x + defaultSettings.slotBoxWidth - 6, y + defaultSettings.slotBoxHeight - 15, x + defaultSettings.slotBoxWidth, y + defaultSettings.slotBoxHeight - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")
				end
			else
				dxDrawText(itemsTable[itemsTableState][movedSlotId].amount, x + defaultSettings.slotBoxWidth - 6, y + defaultSettings.slotBoxHeight - 15, x + defaultSettings.slotBoxWidth, y + defaultSettings.slotBoxHeight - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")
			end
		end

		-- ** Item átnevezés
		if not renameDetails then
			if isCursorShowing() then
				if renameProcess then
					dxDrawImage(cx, cy, 32, 32, "files/nametag.png")
					setCursorAlpha(0)
				end
			elseif renameProcess then
				renameProcess = false
				setCursorAlpha(255)
			end
		elseif isCursorShowing() then
			setCursorAlpha(255)
		end

		if renameDetails then
			if getTickCount() - renameDetails.cursorChange >= 750 then
				renameDetails.cursorChange = getTickCount()
				renameDetails.cursorState = not renameDetails.cursorState
			end

			renameDetails.activeButton = false

			-- Háttér
			dxDrawRectangle(renameDetails.x, renameDetails.y, 200, 24, tocolor(0, 0, 0, 200))

			-- Mégsem
			local closeAlpha = 225

			if cx >= renameDetails.x + 200 - 32 and cy >= renameDetails.y + 3 and cx <= renameDetails.x + 200 - 32 + 28 and cy <= renameDetails.y + 3 + 18 then
				renameDetails.activeButton = "close"
				closeAlpha = 255
			end

			dxDrawRectangle(renameDetails.x + 200 - 32 + 1, renameDetails.y + 3, 28, 18, tocolor(215, 89, 89, closeAlpha))
			dxDrawText("X", renameDetails.x + 200 - 32, renameDetails.y + 3, renameDetails.x + 200 - 32 + 28, renameDetails.y + 3 + 18, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")

			-- Alkalmaz
			local okayAlpha = 225

			if cx >= renameDetails.x + 200 - 64 and cy >= renameDetails.y + 3 and cx <= renameDetails.x + 200 - 64 + 28 and cy <= renameDetails.y + 3 + 18 then
				renameDetails.activeButton = "ok"
				okayAlpha = 255
			end

			dxDrawRectangle(renameDetails.x + 200 - 64, renameDetails.y + 3, 28, 18, tocolor(74, 223, 191, okayAlpha))
			dxDrawText("Ok", renameDetails.x + 200 - 64, renameDetails.y + 3, renameDetails.x + 200 - 64 + 28, renameDetails.y + 3 + 18, tocolor(0, 0, 0), 0.5, Roboto, "center", "center")

			-- Szöveg
			if renameDetails.cursorState then
				dxDrawText(renameDetails.text .. "|", renameDetails.x + 2, renameDetails.y, 0, renameDetails.y + 24, tocolor(255, 255, 255), 0.5, Roboto, "left", "center")
			else
				dxDrawText(renameDetails.text, renameDetails.x + 2, renameDetails.y, 0, renameDetails.y + 24, tocolor(255, 255, 255), 0.5, Roboto, "left", "center")
			end
		end
	end
end

local searchState = false
local searchWidth = (defaultSettings.slotBoxWidth + 5) * defaultSettings.width + 5
local searchHeight = (defaultSettings.slotBoxHeight + 5) * math.floor(defaultSettings.slotLimit / defaultSettings.width) + 5 + 35
local searchPosX = screenX / 2
local searchPosY = screenY / 2
local searchDragging = false
local currentSearchTab = "main"
local hoverSearchTab = false
local bodyItems = {}
local bodyMoney = 0
local bodyName = ""
local gtaFont = false

addEvent("bodySearchGetDatas", true)
addEventHandler("bodySearchGetDatas", getRootElement(),
	function (items, name, cash)
		bodyItems = {}

		for k, v in pairs(items) do
			bodyItems[v.slot] = {
				itemId = v.itemId,
				amount = v.amount,
				data1 = v.data1,
				data2 = v.data2,
				data3 = v.data3,
				nameTag = v.nameTag,
				serial = v.serial
			}
		end

		bodyName = name
		bodyMoney = cash

		if not searchState then
			searchState = true
			gtaFont = dxCreateFont("files/fonts/gtaFont.ttf", 30, false, "antialiased")
			addEventHandler("onClientRender", getRootElement(), bodySearchRender)
			addEventHandler("onClientClick", getRootElement(), bodySearchClick)
		end
	end)

function bodySearchClick(button, state, cx, cy)
	if button == "left" and state == "up" then
		if hoverSearchTab then
			if hoverSearchTab and hoverSearchTab ~= currentSearchTab then
				currentSearchTab = hoverSearchTab
				playSound("files/sounds/tab.mp3")
			end
		elseif cx >= searchPosX + searchWidth - 35 and cx <= searchPosX + searchWidth - 5 and cy >= searchPosY and cy <= searchPosY + 30 then
			removeEventHandler("onClientRender", getRootElement(), bodySearchRender)
			removeEventHandler("onClientClick", getRootElement(), bodySearchClick)

			bodyItems = {}
			searchState = false

			if isElement(gtaFont) then
				destroyElement(gtaFont)
			end

			gtaFont = nil
		end
	end
end

function bodySearchRender()
	local cx, cy = getCursorPosition()

	if isCursorShowing() then
		cx = cx * screenX
		cy = cy * screenY

		if not searchDragging then
			if getKeyState("mouse1") and cx >= searchPosX and cx <= searchPosX + searchWidth - 30 and cy >= searchPosY and cy <= searchPosY + 30 then
				searchDragging = {cx, cy, searchPosX, searchPosY}
			end
		elseif getKeyState("mouse1") then
			searchPosX = cx - searchDragging[1] + searchDragging[3]
			searchPosY = cy - searchDragging[2] + searchDragging[4]
		else
			searchDragging = false
		end
	else
		cx, cy = -1, -1
	end

	-- ** Háttér
	dxDrawRectangle(searchPosX - 5, searchPosY - 5, searchWidth, searchHeight, tocolor(35, 36, 42)) -- background
	dxDrawRectangle(searchPosX - 5, searchPosY - 5, searchWidth, 34, tocolor(40, 41, 47)) -- title
	dxDrawRectangle(searchPosX - 5, searchPosY - 5 + 34 + 1, searchWidth, 1, tocolor(45, 46, 52)) -- line

	local currentMoney = bodyMoney
	local moneyForDraw = ""
	local moneyTextWidth = 0

	if tonumber(bodyMoney) < 0 then
		moneyTextWidth = dxGetTextWidth("- " .. bodyMoney .. " $", 0.5, gtaFont)
	else
		moneyTextWidth = dxGetTextWidth(bodyMoney .. " $", 0.5, gtaFont)
	end

	for i = 1, 15 - utfLen(currentMoney) do
		moneyForDraw = moneyForDraw .. "0"
	end

	if tonumber(currentMoney) < 0 then
		currentMoney = "#d75959" .. math.abs(currentMoney)
	elseif tonumber(currentMoney) > 0 then
		currentMoney = "#4adfbf" .. math.abs(currentMoney)
	else
		currentMoney = 0
	end

	moneyForDraw = moneyForDraw .. currentMoney

	if tonumber(bodyMoney) < 0 then
		moneyForDraw = "- " .. moneyForDraw
	end

	dxDrawText("Motozás:#4adfbf " .. bodyName .. "#ffffff | " .. moneyForDraw .. " #eaeaea$", searchPosX, searchPosY - 5, searchPosX + searchWidth, searchPosY - 5 + 34, tocolor(255, 255, 255), 1, BebasNeueRegular15, "left", "center", false, false, false, true)

	-- Bezárás
	if cx >= searchPosX + searchWidth - 35 and cx <= searchPosX + searchWidth - 5 and cy >= searchPosY and cy <= searchPosY + 30 then
		dxDrawText("X", searchPosX + searchWidth - 35, searchPosY, searchPosX + searchWidth - 5, searchPosY + 30, tocolor(215, 89, 89), 0.6, Roboto, "center", "center")
	else
		dxDrawText("X", searchPosX + searchWidth - 35, searchPosY, searchPosX + searchWidth - 5, searchPosY + 30, tocolor(255, 255, 255), 0.6, Roboto, "center", "center")
	end

	-- ** Kategóriák
	local sizeForTabs = (searchHeight - 20 - 10) / 4
	local tabStartX = math.floor(searchPosX + panelWidth - 65 - 10 - 30)
	local tabStartY = math.floor(searchPosY) + 2.5


	hoverSearchTab = false

	if cx >= tabStartX + sizeForTabs - 56 and cx <= tabStartX + sizeForTabs - 56 + 18 and cy >= tabStartY and cy <= tabStartY + 22 then
		hoverSearchTab = "main"
	elseif cx >= tabStartX + sizeForTabs - 28 and cx <= tabStartX + sizeForTabs - 28 + 18 and cy >= tabStartY and cy <= tabStartY + 22 then
		hoverSearchTab = "keys"
	elseif cx >= tabStartX + sizeForTabs and cx <= tabStartX + sizeForTabs + 18 and cy >= tabStartY and cy <= tabStartY + 22 then
		hoverSearchTab = "papers"
	end

	if currentSearchTab == "main" then
		dxDrawImage(tabStartX + sizeForTabs - 56, tabStartY, 18, 22, "files/tabs/bag.png", 0, 0, 0, tocolor(194, 194, 194, 200))
	elseif hoverSearchTab == "main" then
		dxDrawImage(tabStartX + sizeForTabs - 56, tabStartY, 18, 22, "files/tabs/bag.png", 0, 0, 0, tocolor(194, 194, 194, 150))
	else
		dxDrawImage(tabStartX + sizeForTabs - 56, tabStartY, 18, 22, "files/tabs/bag.png", 0, 0, 0, tocolor(194, 194, 194, 75))
	end

	if currentSearchTab == "keys" then
		dxDrawImage(tabStartX + sizeForTabs - 28, tabStartY, 18, 22, "files/tabs/key.png", 0, 0, 0, tocolor(194, 194, 194, 200))
	elseif hoverSearchTab == "keys" then
		dxDrawImage(tabStartX + sizeForTabs - 28, tabStartY, 18, 22, "files/tabs/key.png", 0, 0, 0, tocolor(194, 194, 194, 150))
	else
		dxDrawImage(tabStartX + sizeForTabs - 28, tabStartY, 18, 22, "files/tabs/key.png", 0, 0, 0, tocolor(194, 194, 194, 75))
	end

	if currentSearchTab == "papers" then
		dxDrawImage(tabStartX + sizeForTabs, tabStartY, 18, 22, "files/tabs/wallet.png", 0, 0, 0, tocolor(74, 223, 191))
	elseif hoverSearchTab == "papers" then
		dxDrawImage(tabStartX + sizeForTabs, tabStartY, 18, 22, "files/tabs/wallet.png", 0, 0, 0, tocolor(138, 139, 141, 200))
	else
		dxDrawImage(tabStartX + sizeForTabs, tabStartY, 18, 22, "files/tabs/wallet.png", 0, 0, 0, tocolor(138, 139, 141, 150))
	end

	-- ** Itemek
	for i = 0, defaultSettings.slotLimit - 1 do
		local slot = i
		local x = searchPosX + (defaultSettings.slotBoxWidth + 5) * (slot % defaultSettings.width)
		local y = searchPosY + 35 + (defaultSettings.slotBoxHeight + 5) * math.floor(slot / defaultSettings.width)

		if currentSearchTab == "keys" then
			i = i + defaultSettings.slotLimit
		elseif currentSearchTab == "papers" then
			i = i + defaultSettings.slotLimit * 2
		end

		local item = bodyItems[i]

		if cx >= x and cx <= x + defaultSettings.slotBoxWidth and cy >= y and cy <= y + defaultSettings.slotBoxHeight then
			if item then
				processTooltip(cx, cy, getItemName(item.itemId), item.itemId, item, false)
			end
		end

		dxDrawRectangle(x, y, defaultSettings.slotBoxWidth, defaultSettings.slotBoxHeight, tocolor(25, 25, 30))

		if item then
			drawItemPicture(item, x, y)
			dxDrawText(item.amount, x + defaultSettings.slotBoxWidth - 6, y + defaultSettings.slotBoxHeight - 15, x + defaultSettings.slotBoxWidth, y + defaultSettings.slotBoxHeight - 15 + 5, tocolor(255, 255, 255), 0.375, Roboto, "right")
		end
	end
end

function isTheItemCopy(item)
	if item.itemId == 309 or item.itemId == 367 then
		return tonumber(item.data3) == 1
	end

	if item.itemId == 264 then
		return item.data3 and utf8.len(item.data3) > 0
	end

	if item.itemId == 289 then
		return (item.data3 and utf8.find(item.data3, "iscopy"))
	end

	return false
end

function processTooltip(x, y, text, itemId, item, showItem)
	if tonumber(item.serial) and item.serial > 0 then
		text = text .. " #8e8e8e[W" .. item.serial .. serialItems[item.itemId] .. "]"
	end

	if getLaserColor(item.data2) then
		text = text .. getLaserColor(item.data2) .. " (Lézer)#C2A2DA"
	end

	if item.nameTag then
		text = text .. " #d75959(" .. item.nameTag .. ")"
	end

	if itemId == 365 then
		text = text .. " #8e8e8e[" .. item.data2 .. "]"
	end

	if itemId == 314 then
		if ticketGroups[item.data1] then
			showTooltip(x, y, text, ticketGroups[item.data1][1], showItem)
		end
	elseif fishItems[itemId] then
		local data1 = tonumber(item.data2) or 0
		local data3 = tonumber(item.data3) or 0
        local percentage = math.floor(100 - data3 / perishableItems[itemId] * 100)
        local color = "#f35a5a"
        if percentage <= 100 and 65 < percentage then
            color = "#3cb882"
        elseif percentage <= 65 and 20 < percentage then
            color = "#ff9514"
        end
        showTooltip(x, y, text, "Súly: " .. "#319ad7" .. math.floor(data1 * 10) / 10 .. [[
 kg
  #ffffffHossz: ]] .. "#319ad7" .. exports.seal_fishing:calculateFishLength(fishItems[itemId], data1) .. " cm\n#ffffffÁllapot: " .. color .. percentage .. "%", showItem)
	elseif fishingRods[itemId] then
		local redHex = "#f35a5a"
		local blueHex = "#319ad7"
        local data1 = tonumber(item.data1) or 0
        local data2 = tonumber(item.data2) or 0
        local data3 = tonumber(item.data3) or 0
        local line = false
        local col = exports.seal_fishing:getFishingLineColor(data1)
        if col then
            line = exports.seal_gui:getColorCodeHex({col[1], col[2], col[3]}) .. col[4]
        end
        local floater = redHex .. "nincs"
        if exports.seal_fishing:isFloatSkinValid(data3) then
            floater = blueHex .. data3
        end
        showTooltip(x, y, text, "Damil: " .. (line and line .. "\n#ffffffDamil állapota: " .. blueHex .. math.floor(100 - data2) .. "%" or redHex .. "nincs") .. "#ffffff\nÚszó: " .. floater, showItem)
	elseif itemId == 420 then
		showTooltip(x, y, text, "#8e8e8e" .. item.data2 .. "$", showItem)
	elseif itemId == 370 then
		showTooltip(x, y, text, "Sorszám: " .. item.data1, showItem)
	elseif false then
		showTooltip(x, y, text, "Hátralévő idő a befizetésig: " .. perishableItems[itemId] - item.data3 .. " perc", showTooltip)
	elseif itemId == 366 then
		showTooltip(x, y, text, "Lapok száma: " .. 20 - (tonumber(item.data1) or 0) .. " db", showItem)
	elseif itemId == 367 then
		if tonumber(item.data3) == 1 then
			showTooltip(x, y, text, "#8e8e8e[" .. item.data2 .. "] (másolat)", showItem)
		else
			showTooltip(x, y, text, "#8e8e8e[" .. item.data2 .. "]", showItem)
		end
	elseif perishableItems[itemId] or specialItems[itemId] then
		local health = 0
		local color = ""
		local text2 = ""

		if perishableItems[itemId] then
			health = math.floor(100 - (tonumber(item.data3) or 0) / perishableItems[itemId] * 100)
			color = "#d75959"

			if health > 65 and health <= 100 then
				color = "#4adfbf"
			elseif health > 20 and health <= 65 then
				color = "#FF9600"
			end

			text2 = text2 .. "Állapot: " .. color .. health .. "%"

			if specialItems[itemId] then
				text2 = text2 .. "\n"
			end
		end

		if specialItems[itemId] then
			health = math.floor((tonumber(item.data1) or 0) / specialItems[itemId][2] * 100)
			color = "#4adfbf"

			if health > 65 and health <= 100 then
				color = "#d75959"
			elseif health > 20 and health <= 65 then
				color = "#FF9600"
			end

			text2 = text2 .. "#ffffffElfogyasztva: " .. color .. health .. "%"
		end

		showTooltip(x, y, text, text2, showItem)
	elseif itemId == 312 then
		local health = math.floor(100 - (tonumber(item.data1) or 0) / 100 * 100)
		local color = "#d75959"

		if health > 65 and health <= 100 then
			color = "#4adfbf"
		elseif health > 20 and health <= 65 then
			color = "#FF9600"
		end

		showTooltip(x, y, text, "Állapot: " .. color .. health .. "%", showItem)
	elseif isKeyItem(itemId) then
		local additional = ""

		-- if itemId == 1 and itemsTableState == "player" and isPedInVehicle(localPlayer) and not showItem then
		-- 	local pedveh = getPedOccupiedVehicle(localPlayer)

		-- 	if isElement(pedveh) and getVehicleController(pedveh) == localPlayer then
		-- 		if (tonumber(item.data1) or 0) == getElementData(pedveh, defaultSettings.vehicleId) then
		-- 			additional = "\n#ff9600(( Jelenlegi jármű ))"
		-- 		end
		-- 	end
		-- end

		if itemId == 1 then
			local targetVehicle = false

			if not targetVehicle then
				for k, v in pairs(getElementsByType("vehicle")) do
					local vehicleId = getElementData(v, "vehicle.dbID") or 0

					if tonumber(vehicleId) == tonumber(item.data1) then
						targetVehicle = v
						break
					end
				end
			end

			local vehicleModel = getElementModel(targetVehicle)
			local vehicleName = exports.seal_vehiclenames:getCustomVehicleName(vehicleModel) or ""

			local text2 = "#32b2ee(" .. vehicleName .. ")\n"
			text2 = text2 .. "#ffffffAzonosító: " .. item.data1 .. additional
			showTooltip(x, y, text, text2, showItem)
		else
			showTooltip(x, y, text, "Azonosító: " .. item.data1 .. additional, showItem)
		end
	elseif false then
		if tonumber(item.data3) == 0 then
			showTooltip(x, y, text, "Eredeti példány, rendszám: #4adfbf" .. item.data2, showItem)
		else
			showTooltip(x, y, text, "Másolat, rendszám: #4adfbf" .. item.data2, showItem)
		end
	elseif itemId == 206 then
		showTooltip(x, y, text, "#DCA300( " .. item.data1 .. " )", showItem)
	elseif itemId == 432 then
		showTooltip(x, y, text, "#32b2ee( " .. item.data1 .. " )", showItem)
	elseif itemId == 289 or itemId == 288 then
		local licenseTable = fromJSON(item.data1)

		if isTheItemCopy(item) then
			showTooltip(x, y, text, "Rendszám: " .. licenseTable.plate .. " (másolat)", showItem)
		else
			showTooltip(x, y, text, "Rendszám: " .. licenseTable.plate, showItem)
		end
	elseif itemId == 299 then
		local recipe = tonumber(item.data1) or 1

		if not availableRecipes[recipe] then
			recipe = 1
		end

		showTooltip(x, y, text, availableRecipes[recipe].name, showItem)
	elseif availableItems[item.itemId][6] ~= -1 and availableItems[item.itemId][5] ~= -1 and tonumber(item.serial) and item.serial > 0 then
		local health = 100 - (tonumber(item.data1) or 0)
		local color = "#d75959"

		if health > 65 and health <= 100 then
			color = "#4adfbf"
		elseif health > 20 and health <= 65 then
			color = "#FF9600"
		end

		local warns = tonumber(item.data2) or 0
		local color2 = "#4adfbf"

		if warns >= 3 then
			color2 = "#d75959"
		elseif warns > 0 then
			color2 = "#FF9600"
		end

		showTooltip(x, y, text, "Állapot: " .. color .. health .. "%\n#ffffffFigyelmeztetések: " .. color2 .. warns .. "\n#ffffffSúly: #32b3ef" .. getItemWeight(itemId) * item.amount .. " kg", showItem)
	elseif itemId == 61 or itemId == 62 or itemId == 63 then
		showTooltip(x, y, availableItems[itemId][2], "Súly: #32b3ef" .. getItemWeight(itemId) * item.amount .. " kg", showItem)
	elseif itemId == 207 or itemId == 208 then
		if isTheItemCopy(item) then
			showTooltip(x, y, text, "Fénymásolt példány", showItem)
		else
			showTooltip(x, y, text, "Lejárat: #32b3ef" .. (item.data3 or "N/A"), showItem)
		end
	elseif itemId == 264 then
		if isTheItemCopy(item) then
			showTooltip(x, y, text, "Fénymásolt példány", showItem)
		else
			showTooltip(x, y, text, "Eredeti példány", showItem)
		end
	-- elseif availableItems[itemId][2] and availableItems[itemId][1] ~= availableItems[itemId][2] then
	-- 	showTooltip(x, y, text, availableItems[itemId][2] .. "\nSúly: #32b3ef" .. getItemWeight(itemId) * item.amount .. " kg", showItem)
	else
		showTooltip(x, y, text, "Súly: #32b3ef" .. getItemWeight(itemId) * item.amount .. " kg", showItem)
	end
end

function drawItemPicture(item, x, y, sx, sy)
	sx = sx or defaultSettings.slotBoxWidth
	sy = sy or defaultSettings.slotBoxHeight

	if not item then
		dxDrawImage(x, y, sx, sy, "files/noitem.png")
	else
		local itemId = item.itemId
		local itemPictureId = itemId - 1
		local itemPicture = false
		local perishableItem = false
		local pictureAlpha = 255

		if itemPictures[itemId] then
			itemPicture = itemPictures[itemId]
		else
			itemPicture = "files/items/" .. itemPictureId .. ".png"
		end

		if grayItemPictures[itemId] then
			if perishableItems[itemId] then
				pictureAlpha = 255 * (1 - (item.data3 or 0) / perishableItems[itemId])
				perishableItem = grayItemPictures[itemId]
			end
		end

		if perishableItem then
			dxDrawImage(x, y, sx, sy, perishableItem)
		end

		if itemId == 295 then
			if item.data2 == "empty" then
				itemPicture = "files/items/" .. itemPictureId .. "_monochrome.png"
			end
		else
			if itemId == 350 and renameProcess == item.slot and item.inUse then
				itemPicture = "files/items/314_2.png"
			elseif isTheItemCopy(item) then
				if grayItemPictures[itemId] then
					itemPicture = grayItemPictures[itemId]
				end
			elseif scratchItems[itemId] then
				if item.data3 == "empty" then
					itemPicture = "files/items/" .. itemPictureId .. "_monochrome.png"
				end
			end
		end

		if pictureAlpha > 0 then
			dxDrawImage(x, y, sx, sy, itemPicture, 0, 0, 0, tocolor(255, 255, 255, pictureAlpha))
		end
	end
end

function getCurrentWeight()
	local weight = 0

	for k, v in pairs(itemsTable.player) do
		if availableItems[v.itemId] then
			weight = weight + getItemWeight(v.itemId) * v.amount
		end
	end

	return weight
end

function isHavePen()
	for k, v in pairs(itemsTable.player) do
		if v.itemId == 312 then
			return true
		end
	end

	return false
end

function playerHasItem(itemId)
	for k, v in pairs(itemsTable.player) do
		if v.itemId == itemId then
			return v
		end
	end

	return false
end

function playerHasItemWithAmount(itemId, amount)
	local amount = 0
	for k, v in pairs(itemsTable.player) do
		if v.itemId == itemId then
			amount = amount + v.amount
		end
	end

	if amount >= amount then
		return amount
	end

	return false
end



function playerHasItemWithData(itemId, data, dataType)
	data = tonumber(data) or data
	dataType = dataType or "data1"

	
	for k, v in pairs(itemsTable.player) do
		if v.itemId == itemId and (tonumber(v[dataType]) or v[dataType]) == data then
			return v
		end
	end

	return false
end

function penSetData()
	for k, v in pairs(itemsTable.player) do
		if v.itemId == 312 then
			local damage = tonumber(v.data1 or 0) + 1

			if damage >= 100 then
				triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", v.dbID)
				exports.seal_accounts:showInfo("e", "Kifogyott a tollad, ezért eldobtad.")
				break
			end

			triggerServerEvent("damagePen", localPlayer, v.dbID, damage)
			break
		end
	end

	return false
end

function notepadSetData()
	for k, v in pairs(itemsTable.player) do
		if v.itemId == 366 then
			local usedpages = tonumber(v.data1 or 0) + 1

			if usedpages >= 20 then
				triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", v.dbID)
				exports.seal_accounts:showInfo("e", "Kifogyott a jegyzetfüzetedből a lap, ezért eldobtad.")
				break
			end

			triggerServerEvent("damagePen", localPlayer, v.dbID, usedpages) -- ugyan azt csinálja, ezért ugyan az az event név
			break
		end
	end

	return false
end

function unuseItem(dbID)
	if dbID then
		dbID = tonumber(dbID)

		for k, v in pairs(itemsTable.player) do
			if v.dbID == dbID then
				itemsTable.player[v.slot].inUse = false
				break
			end
		end
	end
end

local weaponFireCount = 0

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weaponId)
		if weaponId == 43 then
			return
		end
		
		local weaponInUse = false
		local ammoInUse = false

		for k, v in pairs(itemsTable.player) do
			if v.inUse then
				if isWeaponItem(v.itemId) then
					weaponInUse = v
				elseif isAmmoItem(v.itemId) then
					ammoInUse = v
				end
			end
		end

		if weaponInUse.itemId == 15 then return end

		local itemAmmoId = getItemAmmoID(weaponInUse.itemId)

		if weaponInUse and not ammoInUse and itemAmmoId and (itemAmmoId <= 0 or itemAmmoId == weaponInUse.itemId) then
			ammoInUse = weaponInUse
		end

		if weaponInUse and ammoInUse and ammoInUse.amount and weaponInUse.itemId ~= 155 and weaponInUse.itemId ~= 99 then
			if weaponInUse.itemId ~= ammoInUse.itemId and getPedTotalAmmo(localPlayer) > ammoInUse.amount - 1 and ammoInUse.amount - 1 == 0 then
				enableWeaponFire(false)
			end

			if ammoInUse.amount - 1 > 0 then
				if itemsTable.player[ammoInUse.slot].amount then
					weaponFireCount = weaponFireCount + 1

					itemsTable.player[ammoInUse.slot].amount = itemsTable.player[ammoInUse.slot].amount - 1




					if weaponId == 76 or weaponId == 77 or weaponId == 78 or weaponId == 79 then
						triggerServerEvent("takeAmountFrom", localPlayer, ammoInUse.dbID, 1)
						weaponFireCount = 0
					elseif weaponId == 80 or weaponId == 81 or weaponId == 82 or weaponId == 83 or weaponId == 84 or weaponId == 85 or weaponId == 86 or weaponId == 87 or weaponId == 88 then
						triggerServerEvent("takeAmountFrom", localPlayer, ammoInUse.dbID, 1)
						weaponFireCount = 0
					elseif weaponFireCount == 4 then
						triggerServerEvent("takeAmountFrom", localPlayer, ammoInUse.dbID, 4)
						weaponFireCount = 0
					end

					triggerEvent("movedItemInInv", localPlayer, true)
				end
			else
				triggerServerEvent("takeItem", localPlayer, localPlayer, "dbID", itemsTable.player[ammoInUse.slot].dbID)
				itemsTable.player[ammoInUse.slot] = nil
			end
		end
	end)

local playerNoAmmo = false

function enableWeaponFire(state)
	if state then
		if playerNoAmmo then
			exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
			playerNoAmmo = false
		end
	else
		if not playerNoAmmo then
			exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, false)
			playerNoAmmo = true
		end
	end
end

local itemlistState = false
local itemlistWidth = 800
local itemlistHeight = 600
local itemlistPosX = screenX / 2 - itemlistWidth / 2
local itemlistPosY = screenY / 2 - itemlistHeight / 2
local itemlistDragging = false
local itemlistTable = false
local itemlistOffset = 0
local itemlistText = ""

addCommandHandler("itemlist",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			itemlistState = not itemlistState

			if itemlistState then
				if not itemlistTable then
					itemlistTable = {}

					for i = 1, #availableItems do
						table.insert(itemlistTable, i)
					end
				end

				addEventHandler("onClientRender", getRootElement(), itemlistRender, true, "low-1000")
				addEventHandler("onClientCharacter", getRootElement(), itemlistCharacter)
				addEventHandler("onClientKey", getRootElement(), itemlistKey)
				showCursor(true)
			else
				removeEventHandler("onClientRender", getRootElement(), itemlistRender)
				removeEventHandler("onClientCharacter", getRootElement(), itemlistCharacter)
				removeEventHandler("onClientKey", getRootElement(), itemlistKey)
				showCursor(false)
			end
		end
	end)

function itemlistKey(key, press)
	if isCursorShowing() then
		cancelEvent()

		if key == "mouse_wheel_up" then
			if itemlistOffset > 0 then
				itemlistOffset = itemlistOffset - 1
			end
		end

		if key == "mouse_wheel_down" then
			if itemlistOffset < #itemlistTable - 14 then
				itemlistOffset = itemlistOffset + 1
			end
		end

		if press and key == "backspace" then
			itemlistText = utf8.sub(itemlistText, 1, utf8.len(itemlistText) - 1)
			searchItems()
		end
	end
end

function itemlistCharacter(character)
	if isCursorShowing() then
		itemlistText = itemlistText .. character
		searchItems()
	end
end

function searchItems()
	itemlistTable = {}

	if utf8.len(itemlistText) < 1 then
		for i = 1, #availableItems do
			table.insert(itemlistTable, i)
		end
	elseif tonumber(itemlistText) then
		local id = tonumber(itemlistText)

		if availableItems[id] then
			table.insert(itemlistTable, id)
		end
	else
		for i = 1, #availableItems do
			if utf8.find(utf8.lower(availableItems[i][1]), utf8.lower(itemlistText)) then
				table.insert(itemlistTable, i)
			end
		end
	end

	itemlistOffset = 0
end

function itemlistRender()
	local exitButtonAlpha = 200

	if isCursorShowing() then
		local cx, cy = getCursorPosition()

		cx = cx * screenX
		cy = cy * screenY

		if cx >= itemlistPosX + itemlistWidth - 100 and cx <= itemlistPosX + itemlistWidth - 10 and cy >= itemlistPosY + itemlistHeight - 30 and cy <= itemlistPosY + itemlistHeight - 10 then
			exitButtonAlpha = 255

			if getKeyState("mouse1") then
				itemlistState = false
				removeEventHandler("onClientRender", getRootElement(), itemlistRender)
				removeEventHandler("onClientCharacter", getRootElement(), itemlistCharacter)
				removeEventHandler("onClientKey", getRootElement(), itemlistKey)
				showCursor(false)
				return
			end
		end

		if not itemlistDragging then
			if getKeyState("mouse1") and cx >= itemlistPosX and cx <= itemlistPosX + itemlistWidth and cy >= itemlistPosY and cy <= itemlistPosY + itemlistHeight then
				itemlistDragging = {cx, cy, itemlistPosX, itemlistPosY}
			end
		elseif getKeyState("mouse1") then
			itemlistPosX = cx - itemlistDragging[1] + itemlistDragging[3]
			itemlistPosY = cy - itemlistDragging[2] + itemlistDragging[4]
		else
			itemlistDragging = false
		end
	end

	dxDrawRectangle(itemlistPosX, itemlistPosY, itemlistWidth, itemlistHeight, tocolor(0, 0, 0, 150))
	dxDrawRectangle(itemlistPosX + 8, itemlistPosY + 8, itemlistWidth - 16, 30, tocolor(0, 0, 0, 00))
	dxDrawText(itemlistText, itemlistPosX + 16, itemlistPosY + 8, 0, itemlistPosY + 38, tocolor(255, 255, 255), 0.6, Roboto, "left", "center")

	local oneSize = defaultSettings.slotBoxHeight / 0.915

	for i = 1, 14 do
		local y = itemlistPosY + 46 + (i - 1) * oneSize

		if i % 2 == 0 then
			dxDrawRectangle(itemlistPosX, y, itemlistWidth, oneSize, tocolor(0, 0, 0, 75))
		else
			dxDrawRectangle(itemlistPosX, y, itemlistWidth, oneSize, tocolor(0, 0, 0, 00))
		end

		local item = itemlistTable[i + itemlistOffset]

		if item then
			if fileExists("files/items/" .. item - 1 .. ".png") then
				dxDrawImage(itemlistPosX + 4, y + 4, oneSize - 8, oneSize - 8, "files/items/" .. item - 1 .. ".png")
			else
				dxDrawImage(itemlistPosX + 4, y + 4, oneSize - 8, oneSize - 8, "files/items/nopic.png")
			end

			dxDrawText("[" .. item .. "] " .. availableItems[item][1], itemlistPosX + oneSize, y, 0, y + oneSize / 2 + 3, tocolor(255, 255, 255), 0.5, Roboto, "left", "center")
			dxDrawText(availableItems[item][2], itemlistPosX + oneSize, y + oneSize / 2 - 3, 0, y + oneSize, tocolor(200, 200, 200), 0.45, Roboto, "left", "center")
		end
	end

	if #itemlistTable > 14 then
		dxDrawRectangle(itemlistPosX + itemlistWidth - 5, itemlistPosY + 46, 5, 504, tocolor(0, 0, 0, 00))
		dxDrawRectangle(itemlistPosX + itemlistWidth - 5, itemlistPosY + 46 + (504 / #itemlistTable) * itemlistOffset, 5, (504 / #itemlistTable) * 14, tocolor(74, 223, 191, 150))
	end

	dxDrawRectangle(itemlistPosX + itemlistWidth - 100, itemlistPosY + itemlistHeight - 30, 90, 20, tocolor(215, 89, 89, exitButtonAlpha))
	dxDrawText("Bezárás", itemlistPosX + itemlistWidth - 100, itemlistPosY + itemlistHeight - 30, itemlistPosX + itemlistWidth - 10, itemlistPosY + itemlistHeight - 10, tocolor(0, 0, 0), 0.45, Roboto, "center", "center")
end

function render3DNote(text, iscopy)
	local rt = dxCreateRenderTarget(399, 527, true)
	local font = dxCreateFont("files/fonts/hand.ttf", 16, false, "antialiased")

	text = processNotepadTextEx(text, font)
	text[0] = "((" .. getElementData(localPlayer, "visibleName"):gsub("_", " ") .. "))"

	dxSetRenderTarget(rt)

	if iscopy then
		dxDrawImage(0, 0, 399, 527, "files/pagecopy.png")
	else
		dxDrawImage(0, 0, 399, 527, "files/page.png")
	end

	for i = 0, 23 do
		local x, y = 0, 0 + 40

		if iscopy then
			dxDrawLine(x + 67, y + 22 * (i - 2) - 1, x + 399, y + 22 * (i - 2) - 1, tocolor(110, 110, 110))
		else
			dxDrawLine(x + 67, y + 22 * (i - 2) - 1, x + 399, y + 22 * (i - 2) - 1, tocolor(0, 15, 200, 185))
		end

		if text[i] then
			if iscopy then
				dxDrawText(text[i], x + 70, 0, x + 395, y + 22 * (i - 1) + 5, tocolor(77, 77, 77), 1, font, i > 0 and "left" or "center", "bottom", true)
			else
				dxDrawText(text[i], x + 70, 0, x + 395, y + 22 * (i - 1) + 5, tocolor(0, 15, 85, 185), 1, font, i > 0 and "left" or "center", "bottom", true)
			end
		end
	end

	dxSetRenderTarget()

	if isElement(font) then
		destroyElement(font)
	end

	if isElement(rt) then
		local pixels = dxGetTexturePixels(rt)
		pixels = dxConvertPixels(pixels, "png")
		destroyElement(rt)
		return pixels
	end

	return false
end

addEvent("gotRequestWallNotes", true)
addEventHandler("gotRequestWallNotes", getRootElement(),
	function (datas)
		wallNotes = datas

		local x, y, z = getElementPosition(localPlayer)

		for id in pairs(wallNotes) do
			wallNotes[id][1] = dxCreateTexture(wallNotes[id][1], "dxt3")
			wallNotes[id][9] = createColSphere(wallNotes[id][4], wallNotes[id][5], wallNotes[id][6], wallNoteRadius)

			setElementInterior(wallNotes[id][9], wallNotes[id][7])
			setElementDimension(wallNotes[id][9], wallNotes[id][8])

			if getDistanceBetweenPoints3D(wallNotes[id][4], wallNotes[id][5], wallNotes[id][6], x, y, z) < wallNoteRadius then
				nearbyWallNotes[id] = true
			end

			wallNoteCol[wallNotes[id][9]] = id
		end
	end)

addEvent("deleteWallNote", true)
addEventHandler("deleteWallNote", getRootElement(),
	function (id)
		nearbyWallNotes[id] = nil

		if wallNotes[id] then
			if isElement(wallNotes[id][9]) then
				destroyElement(wallNotes[id][9])
			end

			wallNoteCol[id] = nil
		end

		wallNotes[id] = nil
	end)

addEvent("addWallNote", true)
addEventHandler("addWallNote", getRootElement(),
	function (id, data)
		wallNotes[id] = data
		wallNotes[id][1] = dxCreateTexture(wallNotes[id][1], "dxt3")
		wallNotes[id][9] = createColSphere(wallNotes[id][4], wallNotes[id][5], wallNotes[id][6], wallNoteRadius)

		setElementInterior(wallNotes[id][9], wallNotes[id][7])
		setElementDimension(wallNotes[id][9], wallNotes[id][8])

		local x, y, z = getElementPosition(localPlayer)

		if getDistanceBetweenPoints3D(wallNotes[id][4], wallNotes[id][5], wallNotes[id][6], x, y, z) < wallNoteRadius then
			nearbyWallNotes[id] = true
		end

		wallNoteCol[wallNotes[id][9]] = id
	end)

addEventHandler("onClientColShapeHit", getRootElement(),
	function (element, matchdim)
		if element == localPlayer and matchdim and wallNoteCol[source] then
			nearbyWallNotes[wallNoteCol[source]] = true
		end
	end)

addEventHandler("onClientColShapeLeave", getRootElement(),
	function (element, matchdim)
		if element == localPlayer and matchdim and wallNoteCol[source] then
			nearbyWallNotes[wallNoteCol[source]] = nil
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if state == "up" and hoverWallNote then
			triggerServerEvent("deleteWallNote", localPlayer, hoverWallNote)
		end
	end)

local nametagScale = (screenX + 1920) / 3840

addEventHandler("onClientRender", getRootElement(),
	function ()
		local dimension = getElementDimension(localPlayer)
		local cx, cy = getCursorPosition()
		local camx, camy, camz = getCameraMatrix()

		if isCursorShowing() then
			cx, cy = cx * screenX, cy * screenY
		else
			cx, cy = -1, -1
		end

		hoverWallNote = false

		for id in pairs(nearbyWallNotes) do
			local note = wallNotes[id]

			if note and note[8] == dimension then
				local x, y, z = note[4], note[5], note[6] - 0.2

				if isLineOfSightClear(camx, camy, camz, x, y, z, true, false, false, true, false, true, false) then
					local sx, sy = getScreenFromWorldPosition(x, y, z, 0, false)
					local sx2, sy2 = getScreenFromWorldPosition(x, y, z + 0.4, 0, false)

					if sx and sy then
						local dist = getDistanceBetweenPoints3D(camx, camy, camz, x, y, z)

						if dist <= 7 then
							local scale = interpolateBetween(1, 0, 0, 0.45, 0, 0, dist / 7, "OutQuad") * nametagScale

							if sx2 then
								dxDrawText(note[12], sx2 - 10, 0, sx2 + 10, sy2 - 4, tocolor(255, 255, 255), scale, Roboto, "center", "bottom")
							end

							dxDrawImage(math.floor(sx - 32 * scale), math.floor(sy + 32 * scale), math.floor(64 * scale), math.floor(64 * scale), "files/search.png")

							if cx >= sx - 32 * scale and cy >= sy + 32 * scale and cx <= sx + 32 * scale and cy <= sy + 96 * scale then
								if myAdminLevel >= 1 or note[2] == myCharacterId then
									dxDrawRectangle(cx - 199 - 4, cy - 4 - 263, 407, 555, tocolor(0, 0, 0, 150), true)
									dxDrawText("Kattints egyet a törléshez.", cx - 10, cy + 263 + 4, cx + 10, cy + 263 + 4 + 20, tocolor(255, 255, 255), 0.45, Roboto, "center", "center", false, false, true)
									hoverWallNote = id
								else
									dxDrawRectangle(cx - 199 - 4, cy - 4 - 263, 407, 535, tocolor(0, 0, 0, 150), true)
								end

								dxDrawImage(cx - 199, cy - 263, 399, 527, note[1], 0, 0, 0, tocolor(255, 255, 255), true)
							end
						end
					end
				end

				dxDrawMaterialLine3D(note[4], note[5], note[6] + 0.2, note[4], note[5], note[6] - 0.2, note[1], 0.3, tocolor(255, 255, 255), note[4] + note[10], note[5] + note[11], note[6])
			else
				nearbyWallNotes[id] = nil
			end
		end
	end)

function checkAnticheatState()
	local res = getResourceFromName("seal_anticheat")
	if getResourceState(res) ~= "running" then
		triggerServerEvent("reportSuspiciousAction", localPlayer, "WWSVTSJW", {
			{ name = "Anticheat", value = "Nem fut a resource." }
		})
	end
end
setTimer(checkAnticheatState, 5000, 0)

addEvent("openSanta", true)
addEventHandler("openSanta", resourceRoot, function()
	if getElementData(localPlayer, "startedBunnyOpening") or getElementData(localPlayer, "startedChestOpening") then
		return
	end

	exports.seal_autumnspinner:tryToStartSantaOpening()
end)

addEvent("openSanta2", true)
addEventHandler("openSanta2", resourceRoot, function()
	if getElementData(localPlayer, "startedBunnyOpening") or getElementData(localPlayer, "startedChestOpening") then
		return
	end

	exports.seal_discordspinner:tryToStartSantaOpening()
end)

addEvent("openPumpkin", true)
addEventHandler("openPumpkin", resourceRoot, function()
	if getElementData(localPlayer, "startedBunnyOpening") or getElementData(localPlayer, "startedChestOpening") then
		return
	end

	exports.seal_pumpkin:tryToStartPumpkinOpening()
end)

addEvent("openSanta12", true)
addEventHandler("openSanta12", resourceRoot, function()
	if getElementData(localPlayer, "startedBunnyOpening") or getElementData(localPlayer, "startedChestOpening") then
		return
	end
	
	exports.seal_santa:TryToStartSantaOpening()
end)

addEvent("waitForResponse", true)
addEventHandler("waitForResponse", resourceRoot, function()
	waitForResponse = false
end)

local trashSounds = {"trash1.wav", "trash2.wav", "trash3.wav", "trash4.wav", "trash5.wav", "trash6.wav"}

addEvent("playTrashSound", true)
addEventHandler("playTrashSound", getRootElement(), function(x, y, z, interior, dimension)
    if x and y and z then
        local randomIndex = math.random(1, #trashSounds)
        local selectedSound = trashSounds[randomIndex]
        local sound = playSound3D("files/trashes/" .. selectedSound, x, y, z, false)
        setElementInterior(sound, interior)
        setElementDimension(sound, dimension)
        setSoundMaxDistance(sound, 30)
    end
end)