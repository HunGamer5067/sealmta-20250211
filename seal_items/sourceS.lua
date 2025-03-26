connection = false

itemsTable = {}
inventoryInUse = {}

local wallNotes = {}
local playerItemObjects = {}

local lastWeaponSerial = 0
local lastTicketSerial = 0

local trackingTimer = {}

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		if client then
			banPlayer(client, true, false, true, "Anticheat", "AC #1")
            return
		end
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.seal_database:getConnection()

		setTimer(processPerishableItems, 1000 * 60, 0)
		setTimer(removeWallNotes, 1000 * 60 * 60 * 5, 0)

		if fileExists("saves.json") then
			local jsonFile = fileOpen("saves.json")
			if jsonFile then
				local fileContent = fileRead(jsonFile, fileGetSize(jsonFile))

				fileClose(jsonFile)

				if fileContent then
					local jsonData = fromJSON(fileContent) or {}

					lastWeaponSerial = tonumber(jsonData.lastWeaponSerial)
					lastTicketSerial = tonumber(jsonData.lastTicketSerial)
				end
			end
		end
	end)

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		for k, v in pairs(getElementsByType("player")) do
			takeAllWeapons(v)
			removeElementData(v, "canisterInHand")
		end

		if fileExists("saves.json") then
			fileDelete("saves.json")
		end

		local jsonFile = fileCreate("saves.json")
		if jsonFile then
			local jsonData = {}

			jsonData.lastWeaponSerial = tonumber(lastWeaponSerial or 0)
			jsonData.lastTicketSerial = tonumber(lastTicketSerial or 0)

			fileWrite(jsonFile, toJSON(jsonData, true, "tabs"))
			fileClose(jsonFile)
		end
	end)

addEventHandler("onElementDestroy", getRootElement(),
	function ()
		if itemsTable[source] then
			itemsTable[source] = nil
		end

		if inventoryInUse[source] then
			inventoryInUse[source] = nil
		end
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "loggedIn" then
			if getElementData(source, dataName) then
				setTimer(triggerEvent, 1000, 1, "requestCache", source)
			end
		end

		if dataName == "canisterInHand" then
			if getElementData(source, "canisterInHand") then
				playerItemObjects[source] = createObject(363, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0, 0.025, -0.025, 0, 270, 180)
				end
			else
				if playerItemObjects[source] then
					exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])

					if isElement(playerItemObjects[source]) then
						destroyElement(playerItemObjects[source])
					end

					playerItemObjects[source] = nil
				end
			end
		elseif dataName == "usingGrinder" then
			if getElementData(source, "usingGrinder") then
				playerItemObjects[source] = createObject(1636, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					setElementInterior(playerItemObjects[source], getElementInterior(source))
					setElementDimension(playerItemObjects[source], getElementDimension(source))

					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, -0.25, 0.05, 0.025, 0, 270, 90)
				end
			else
				if playerItemObjects[source] then
					exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])

					if isElement(playerItemObjects[source]) then
						destroyElement(playerItemObjects[source])
					end

					playerItemObjects[source] = nil
				end
			end
		elseif dataName == "fishingRodInHand" then
			if getElementData(source, "fishingRodInHand") then
				playerItemObjects[source] = createObject(2993, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					setElementInterior(playerItemObjects[source], getElementInterior(source))
					setElementDimension(playerItemObjects[source], getElementDimension(source))
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0.05, 0.05, 0.05, 0, -90, 0)
					setElementData(source, "attachedObject", playerItemObjects[source])
				end
			else
				if playerItemObjects[source] then
					if isElement(playerItemObjects[source]) then
						if getElementModel(playerItemObjects[source]) == 2993 then
							exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
							destroyElement(playerItemObjects[source])
							playerItemObjects[source] = nil
							setElementData(source, "attachedObject", false)
						end
					end
				end
			end
		end
	end)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if playerItemObjects[source] then
			exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])

			if isElement(playerItemObjects[source]) then
				destroyElement(playerItemObjects[source])
			end

			playerItemObjects[source] = nil
		end

		if trackingTimer[source] then
			if isTimer(trackingTimer[source]) then
				killTimer(trackingTimer[source])
			end

			trackingTimer[source] = nil
		end

		if itemsTable[source] then
			for k, v in pairs(itemsTable[source]) do
				if v.itemId == 119 then
					takeItem(source, "dbID", v.dbID)
				end
			end
		end
	end)

addEventHandler("onPlayerWasted", root,
	function()
		if itemsTable[source] then
			for k, v in pairs(itemsTable[source]) do
				if v.itemId == 119 then
					takeItem(source, "dbID", v.dbID)
				end
			end
		end
	end
)

addEvent("giveCasetteMoney", true)
addEventHandler("giveCasetteMoney", getRootElement(),
	function(amount)
		if isElement(source) and client and client == source and exports.seal_groups:isPlayerHavePermission(client, "canRobATM") and exports.seal_items:hasItem(client, 120, 1) and exports.seal_items:hasItem(client, 121, 1) and getElementData(client, "currentCraftingPosition") then
			if tonumber(amount) then
				if math.floor(amount) then
					setElementData(client, "char.Money", getElementData(client, "char.Money") + amount)

					exports.seal_anticheat:sendDiscordMessage(getElementData(client, "visibleName") .. " kinyitott egy kazettát: " .. amount, "killog")
				end
			end
		end
	end
)

local badgeGroups = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[8] = true,
}

addCommandHandler("givebadge",
	function (sourcePlayer, commandName, ...)
		local adminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
		local hasPermission = false

		if adminLevel >= 5 then
			hasPermission = true
		end

		if not hasPermission then
			for k, v in pairs(badgeGroups) do
				if exports.seal_groups:isPlayerLeaderInGroup(sourcePlayer, k) then
					hasPermission = true
					break
				end
			end
		end

		if hasPermission then
			if not (...) then
				outputChatBox("[SealMTA]: #ffffff/" .. commandName .. " [Jelvény Neve]", sourcePlayer, 245, 150, 34, true)
			else
				local badgeName = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

				if utf8.len(badgeName) > 50 then
					exports.seal_gui:showInfobox(sourcePlayer, "e", "A jelvény neve maximum 50 karakter lehet.")
					return
				end

				if badgeName then
					giveItem(sourcePlayer, 206, 1, nil, badgeName, nil, nil, "bottocukraszda.pw")
					exports.seal_gui:showInfobox(sourcePlayer, "i", "Sikeresen adtál magadnak egy jelvényt.")
				end
			end
		end
	end
)

local pinGroups = {
	[3] = true,
}

addCommandHandler("givepin",
	function (sourcePlayer, commandName, ...)
		local adminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
		local hasPermission = false

		if adminLevel >= 5 then
			hasPermission = true
		end

		if not hasPermission then
			for k, v in pairs(pinGroups) do
				if exports.seal_groups:isPlayerLeaderInGroup(sourcePlayer, k) then
					hasPermission = true
					break
				end
			end
		end

		if hasPermission then
			if not (...) then
				outputChatBox("[SealMTA]: #ffffff/" .. commandName .. " [Kitűző Neve]", sourcePlayer, 245, 150, 34, true)
			else
				local pinName = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

				if pinName then
					giveItem(sourcePlayer, 432, 1, nil, pinName, nil, nil, "bottocukraszda.pw")
					exports.seal_gui:showInfobox(sourcePlayer, "i", "Sikeresen adtál magadnak egy kitűzőt.")
				end
			end
		end
	end
)

function useItem(item, additional, additional2)
	if client ~= source then
		return
	end

	if not hasItem(client, item.itemId) then
		return
	end

	if not item or not item.dbID then
		return
	end

	local itemId = item.itemId

	if not fishingRods[itemId] then
		if getElementData(client, "usingFishingRodID") then
			exports.seal_gui:showInfobox(client, "e", "Először tedd el a horgászbotod!")
			return
		end
	end

	-- ** Láda
	if fishingRods[itemId] then
		local usingFishingRodID = getElementData(client, "usingFishingRodID")

		if usingFishingRodID then
			if usingFishingRodID == item.dbID then
				local mode = exports.seal_fishing:getPlayerFishingData(client, "mode")
        
				if mode and mode ~= "idle" and mode ~= "aim" then
					damageFishingLine(client, item.dbID, true)
					exports.seal_gui:showInfobox(client, "e", "Mivel horgászat közben elraktad a botod, elszakadt a damil.")
				end
				
				setElementData(client, "usingFishingRod", false)
				setElementData(client, "usingFishingRodID", false)
				setElementData(client, "usingFishingRodLine", false)
				setElementData(client, "usingFishingRodFloat", false)
						
				triggerClientEvent(client, "gotUsingFishingRod", client, false)
				exports.seal_controls:toggleControl("all", true)
				exports.seal_chat:localAction(client, "elrakott egy horgászbotot (" .. availableItems[itemId][1] .. ").")
			end
		else
			setElementData(client, "usingFishingRod", fishingRods[itemId])
			setElementData(client, "usingFishingRodID", item.dbID)
	
			local line = tonumber(item.data1)
			line = line ~= 0 and line

			local float = tonumber(item.data3)
			float = float ~= 0 and float

			setElementData(client, "usingFishingRodLine", line)
			setElementData(client, "usingFishingRodFloat", float)

			triggerClientEvent(client, "gotUsingFishingRod", client, item.dbID)
			exports.seal_chat:localAction(client, "elővett egy horgászbotot (" .. availableItems[itemId][1] .. ").")
		end
	elseif fishItems[itemId] then
		if exports.seal_fishing:isPlayerStandingInDropOffCol(client) then
			triggerEvent("sellFishItemUse", client, item)
		else
			local usingFishingRodID = getElementData(client, "usingFishingRodID")
			local previewFish = getElementData(client, "previewFish")
			local previewFishId = getElementData(client, "previewFishId")
	
			if not usingFishingRodID then
				if previewFish then
					if previewFishId and previewFishId == item.dbID then
						setElementData(client, "previewFish", false)
					end
				else
					setElementData(client, "previewFish", {fishItems[itemId], (tonumber(item.data2) or 1)})
					setElementData(client, "previewFishId", item.dbID)
				end
			end
		end
	elseif itemId == 479 then
		takeItem(source, "dbID", item.dbID)
		giveItem(source, 480, 1, false, false, false, false, "bottocukraszda.pw")
		giveItem(source, 481, 1, false, false, false, false, "bottocukraszda.pw")
	elseif itemId == 247 then
		local chestItems = {253, 254, 259, 260}
		takeItem(source, "dbID", item.dbID)
		giveItem(source, chestItems[math.random(1, #chestItems)], 1, false, false, false, false, "bottocukraszda.pw")
	elseif itemId == 434 then
		setElementHealth(source, 100)
		setElementData(source, "bloodLevel", 100)
	
		local armor = getPedArmor(source)
		setPedArmor(source, armor + math.random(15, 20))

		setElementData(source, "char.Hunger", 100)
		setElementData(source, "char.Thirst", 100)

		removeElementData(source, "bulletDamages")
		removeElementData(source, "triedToHelpUp")
	
		if getElementData(source, "char.injureLeftFoot") then
			exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
		end
	
		if getElementData(source, "char.injureRightFoot") then
			exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
		end
	
		if getElementData(source, "char.injureLeftArm") then
			exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
		end
	
		if getElementData(source, "char.injureRightArm") then
			exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
		end
	
		removeElementData(source, "char.injureLeftFoot")
		removeElementData(source, "char.injureRightFoot")
		removeElementData(source, "char.injureLeftArm")
		removeElementData(source, "char.injureRightArm")

		takeItem(source, "dbID", item.dbID, 1)
		exports.seal_chat:localAction(source, "megevett egy csokitojást.")
	elseif itemId == 438 then
        state = not state 
        triggerClientEvent(source, "renderWsMap", resourceRoot, state)

		if state then
			exports.seal_chat:localAction(source, "elővett egy térképet.")
			outputChatBox("#4adfbf[SealMTA - Fegyverhajó adatok]", source, 255, 255, 255, true)
			outputChatBox("#4adfbfIdőpont: #ffffff18:00", source, 255, 255, 255, true)
			triggerClientEvent("sendSound", source)
		else
			exports.seal_chat:localAction(source, "elrakott egy térképet.")
			triggerClientEvent("sendSound", source)
		end
	elseif itemId == 444 then

	    local playerVeh = isPedInVehicle(source)
	    local playerInt = getElementInterior(source)
	    local playerDim = getElementDimension(source)

	    if playerVeh then
	        return exports.seal_gui:showInfobox(source, "e", "Autóban nem tudod használni!")
	    end

	    if getElementData(source, "hasPlacedObject") then
	    	return exports.seal_gui:showInfobox(source, "e", "Neked már van egy háromszöged lerakva!")
	    end

	    if playerInt > 0 then
	    	exports.seal_gui:showInfobox(source, "e", "Interiorban nem tudod használni!")
	    end

	    if playerDim > 0 then
	    	exports.seal_gui:showInfobox(source, "e", "Interiorban nem tudod használni!")
	    end

		exports.seal_hazard:createCustomObject(source)
		takeItem(source, "dbID", item.dbID, 1)
	elseif itemId == 288 then
		local px, py, pz = getElementPosition(source)
		local dist = getDistanceBetweenPoints3D(1481.1502685547, -1783.2280273438, 18.734375, px, py, pz)
		if dist <= 4 and getElementInterior(source) == 0 and getElementDimension(source) == 0 then
			local itemData = item.data1

			takeItem(source, "dbID", item.dbID, 1)
			giveItem(source, 289, 1, false, itemData, false, false, "bottocukraszda.pw")

			local itemData = fromJSON(itemData)
			local vehicleId = tonumber(itemData.vehicleDbID)

			local selectedVeh = false

			for k, v in pairs(getElementsByType("vehicle")) do
				local vehId = getElementData(v, "vehicle.dbID") or 0

				if vehId == vehicleId then
					selectedVeh = v
					--break
				end
			end

			if selectedVeh then
				--setElementData(selectedVeh, "licenseExpire", itemData.expires)
--
				--dbExec(connection, "UPDATE vehicles SET licenseExpire = ? WHERE vehicleId = ?", itemData.expires, vehicleId)
--
				--iprint(selectedVeh)
			end
		else
			exports.seal_hud:showInfobox(source, "e", "Nem vagy a városházán!")
			
		end
	-- * Horgászbot
	elseif itemId == 163 then
		if not getElementData(source, "caseOpening") then
			triggerClientEvent(source, "showTheRaffle", source, "defaultEgg")
			takeItem(source, "dbID", item.dbID)
		end
	elseif itemId == 164 then
		if not getElementData(source, "caseOpening") then
			triggerClientEvent(source, "showTheRaffle", source, "goldEgg")
			takeItem(source, "dbID", item.dbID)
		end
	elseif itemId == 165 then
		if not getElementData(source, "caseOpening") then
			triggerClientEvent(source, "showTheRaffle", source, "boostEgg")
			takeItem(source, "dbID", item.dbID)
		end
	elseif itemId == 156 then
		if not getElementData(source, "caseOpening") then
			triggerEvent("startSpinner", getRootElement(), source)
			takeItem(source, "dbID", item.dbID)
		end
	elseif itemId == 150 then
		if getElementData(source, "holdingBag") then
			local bag = getElementData(source, "holdingBag")
			if isElement(bag) then
				exports.seal_boneattach:detachElementFromBone(bag)
				destroyElement(bag)
			end
			setElementData(source, "holdingBag", false)
			exports.seal_chat:localAction(source, "elrakott egy esettáskát.")
		else
			local bag = createObject(9006, 0, 0, 0)
			setElementInterior(bag, getElementInterior(source))
			setElementDimension(bag, getElementDimension(source))
			exports.seal_pattach:attach(bag, source, 24, 0.2, 0, 0, 180, -90, 0)
			setElementData(source, "holdingBag", bag)
			setElementCollisionsEnabled(bag, false)
			exports.seal_chat:localAction(source, "elővett egy esettáskát.")
		end
	elseif itemId == 153 then
		if not getElementData(source, "caseOpening") then
			triggerEvent("startBeachballSpinner", getRootElement(), source)
			takeItem(source, "dbID", item.dbID)
		end
	elseif itemId == 166 then
		takeItem(source, "dbID", item.dbID)
		exports.seal_vehicles:createPermVehicle({
			modelId = 502,
			color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
			color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
			targetPlayer = source,
			posX = x,
			posY = y,
			posZ = z,
			rotX = 0,
			rotY = 0,
			rotZ = getPedRotation(source),
			interior = getElementInterior(source),
			dimension = getElementDimension(source)
		})
	elseif itemId == 363 then
		takeItem(source, "dbID", item.dbID)
		setElementData(source, "acc.premiumPoints", getElementData(source, "acc.premiumPoints") + 4500)
		triggerClientEvent(source, "StartPremiumUI", source, 4500)
		--exports.seal_accounts:showInfo(source, "s", "1.500.000PP került az egyenlegedre!")
	 elseif itemId == 167 then
	 	takeItem(source, "dbID", item.dbID)
	 	exports.seal_vehicles:createPermVehicle({
	 		modelId = 507,
	 		color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	 		color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	 		targetPlayer = source,
	 		posX = x,
	 		posY = y,
	 		posZ = z,
	 		rotX = 0,
	 		rotY = 0,
	 		rotZ = getPedRotation(source),
	 		interior = getElementInterior(source),
	 		dimension = getElementDimension(source)
	 	})
	elseif itemId == 168 then
		takeItem(source, "dbID", item.dbID)
		exports.seal_vehicles:createPermVehicle({
			modelId = 507,
			color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
			color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
			targetPlayer = source,
			posX = x,
			posY = y,
			posZ = z,
			rotX = 0,
			rotY = 0,
			rotZ = getPedRotation(source),
			interior = getElementInterior(source),
			dimension = getElementDimension(source)
		})
	-- elseif itemId == 169 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	exports.seal_vehicles:createPermVehicle({
	-- 		modelId = 404,
	-- 		color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		targetPlayer = source,
	-- 		posX = x,
	-- 		posY = y,
	-- 		posZ = z,
	-- 		rotX = 0,
	-- 		rotY = 0,
	-- 		rotZ = getPedRotation(source),
	-- 		interior = getElementInterior(source),
	-- 		dimension = getElementDimension(source)
	-- 	})
	-- elseif itemId == 173 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	exports.seal_vehicles:createPermVehicle({
	-- 		modelId = 487,
	-- 		color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		targetPlayer = source,
	-- 		posX = x,
	-- 		posY = y,
	-- 		posZ = z,
	-- 		rotX = 0,
	-- 		rotY = 0,
	-- 		rotZ = getPedRotation(source),
	-- 		interior = getElementInterior(source),
	-- 		dimension = getElementDimension(source)
	-- 	})
	-- elseif itemId == 174 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	exports.seal_vehicles:createPermVehicle({
	-- 		modelId = 411,
	-- 		color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
	-- 		targetPlayer = source,
	-- 		posX = x,
	-- 		posY = y,
	-- 		posZ = z,
	-- 		rotX = 0,
	-- 		rotY = 0,
	-- 		rotZ = getPedRotation(source),
	-- 		interior = getElementInterior(source),
	-- 		dimension = getElementDimension(source)
	-- 	})
	-- elseif itemId == 170 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	--setElementData(source, "acc.premiumPoints", getElementData(source, "acc.premiumPoints") + 10000000)
	-- 	exports.seal_accounts:showInfo(source, "s", "10.000.000PP került az egyenlegedre!")
	-- elseif itemId == 175 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	--setElementData(source, "acc.premiumPoints", getElementData(source, "acc.premiumPoints") + 2000000)
	-- 	exports.seal_accounts:showInfo(source, "s", "2.000.000PP került az egyenlegedre!")
	-- elseif itemId == 171 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	--setElementData(source, "acc.premiumPoints", getElementData(source, "acc.premiumPoints") + 30000000)
	-- 	exports.seal_accounts:showInfo(source, "s", "30.000.000PP került az egyenlegedre!")
	-- elseif itemId == 172 then
	-- 	takeItem(source, "dbID", item.dbID)
	-- 	--setElementData(source, "acc.premiumPoints", getElementData(source, "acc.premiumPoints") + 50000000)
	-- 	exports.seal_accounts:showInfo(source, "s", "50.000.000PP került az egyenlegedre!")
	elseif itemId == 131 then
		local sourceVehicle = getPedOccupiedVehicle(source)
		
		if sourceVehicle then
			if taxiPos[getElementModel(sourceVehicle)] or sirenPos[getElementModel(sourceVehicle)] then
				taxiLampToServer(source, sourceVehicle, "create")

				local ownerType = getElementType(source)
				local slot = getItemSlotID(source, item.dbID)

				if slot then
					itemsTable[source][slot].itemId = 132

					itemsTable[source][slot].data1 = getElementData(sourceVehicle, "vehicle.dbID")
					itemsTable[source][slot].data2 = getElementData(source, "char.ID")

					dbExec(connection, "UPDATE items SET itemId = 132 WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data1 = " .. getElementData(sourceVehicle, "vehicle.dbID") .. " WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data2 = " .. getElementData(source, "char.ID") .. " WHERE dbID = ?", itemsTable[source][slot].dbID)

					if ownerType == "player" then
						triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 132)
						triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data1)
						triggerClientEvent(source, "updateData2", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data2)
						triggerClientEvent(source, "movedItemInInv", source, true)
					end
				end

				exports.seal_chat:localAction(source, "felrakott a járműre egy taxilámpát.")
			else

			end
		end
	elseif itemId == 132 then
		local sourceVehicle = getPedOccupiedVehicle(source)
		
		if sourceVehicle then
			if taxiPos[getElementModel(sourceVehicle)] then
				if getElementData(sourceVehicle, "lampObject") then
					if item.data1 and item.data2 and item.data1 == getElementData(sourceVehicle, "vehicle.dbID") and item.data2 == getElementData(source, "char.ID") then
						taxiLampToServer(source, sourceVehicle, "destroy")

						local ownerType = getElementType(source)
						local slot = getItemSlotID(source, item.dbID)

						if slot then
							itemsTable[source][slot].itemId = 131

							itemsTable[source][slot].data1 = 0
							itemsTable[source][slot].data2 = 0

							dbExec(connection, "UPDATE items SET itemId = 131 WHERE dbID = ?", itemsTable[source][slot].dbID)
							dbExec(connection, "UPDATE items SET data1 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)
							dbExec(connection, "UPDATE items SET data2 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)

							if ownerType == "player" then
								
								triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 131)
								triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data1)
								triggerClientEvent(source, "updateData2", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data2)
								triggerClientEvent(source, "movedItemInInv", source, true)
							end
						end

						exports.seal_chat:localAction(source, "levett a járműről egy taxilámpát.")
					else

					end
				else

				end
			else

			end
		end
	elseif itemId == 291 then
		local sourceVehicle = getPedOccupiedVehicle(source)
		
		if sourceVehicle then
			if sirenPos[getElementModel(sourceVehicle)] then
				sirenLampToServer(sourceVehicle, "create")

				local ownerType = getElementType(source)
				local slot = getItemSlotID(source, item.dbID)

				if slot then
					itemsTable[source][slot].itemId = 292

					itemsTable[source][slot].data1 = getElementData(sourceVehicle, "vehicle.dbID")
					itemsTable[source][slot].data2 = getElementData(source, "char.ID")

					dbExec(connection, "UPDATE items SET itemId = 292 WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data1 = " .. getElementData(sourceVehicle, "vehicle.dbID") .. " WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data2 = " .. getElementData(source, "char.ID") .. " WHERE dbID = ?", itemsTable[source][slot].dbID)

					if ownerType == "player" then
						
						triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 292)
						triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data1)
						triggerClientEvent(source, "updateData2", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data2)
						triggerClientEvent(source, "movedItemInInv", source, true)
					end
				end

				triggerClientEvent(source, "showSirenGui", source, getPedOccupiedVehicle(source))
				exports.seal_chat:localAction(source, "felrakott a járműre egy villogót.")
			else

			end
		end
	elseif itemId == 292 then
		local sourceVehicle = getPedOccupiedVehicle(source)
		
		if sourceVehicle then
			if sirenPos[getElementModel(sourceVehicle)] then
				if getElementData(sourceVehicle, "lampObject") then
					if item.data1 and item.data2 and item.data1 == getElementData(sourceVehicle, "vehicle.dbID") and item.data2 == getElementData(source, "char.ID") then
						sirenLampToServer(sourceVehicle, "destroy")

						local ownerType = getElementType(source)
						local slot = getItemSlotID(source, item.dbID)

						if slot then
							itemsTable[source][slot].itemId = 291

							itemsTable[source][slot].data1 = 0
							itemsTable[source][slot].data2 = 0

							dbExec(connection, "UPDATE items SET itemId = 291 WHERE dbID = ?", itemsTable[source][slot].dbID)
							dbExec(connection, "UPDATE items SET data1 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)
							dbExec(connection, "UPDATE items SET data2 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)

							if ownerType == "player" then
								
								triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 291)
								triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data1)
								triggerClientEvent(source, "updateData2", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data2)
								triggerClientEvent(source, "movedItemInInv", source, true)
							end
						end

						exports.seal_chat:localAction(source, "levett a járműről egy villogót.")
					else

					end
				else

					dbExec(connection, "UPDATE items SET itemId = 291 WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data1 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)
					dbExec(connection, "UPDATE items SET data2 = " .. 0 .. " WHERE dbID = ?", itemsTable[source][slot].dbID)

					if ownerType == "player" then
						
						triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 291)
						triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data1)
						triggerClientEvent(source, "updateData2", source, "player", itemsTable[source][slot].dbID, itemsTable[source][slot].data2)
						triggerClientEvent(source, "movedItemInInv", source, true)
					end
				end
			else

			end
		end
	
	elseif itemId == 215 then
		if getElementData(source, "fishingRodInHand") then
			setElementData(source, "fishingRodInHand", false)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)
			exports.seal_chat:localAction(source, "elrak egy horgászbotot.")
		else
			setElementData(source, "fishingRodInHand", item.dbID)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)
			exports.seal_chat:localAction(source, "elővesz egy horgászbotot.")
		end
	-- ** Jelvény
	elseif itemId == 5 then -- telefon
--		if not getElementData(source, "phoneOpened") then
--			if not item.data1 or not tonumber(item.data1) then
--				local x, y, z = getElementPosition(source)
--				local city = getZoneName(x, y, z, true)
--				local prenum = "172"
--
--				itemsTable[source][item.slot].data1 = tonumber(prenum .. math.random(10000000, 99999999)) -- telefonszám
--				itemsTable[source][item.slot].data2 = "[[]]" -- adatok / üzenetek / hívásnapló stb
--				itemsTable[source][item.slot].data3 = "-" -- kontaktok
--
--				dbExec(connection, "UPDATE items SET data1 = ?, data2 = '[[]]', data3 = '-' WHERE dbID = ?", itemsTable[source][item.slot].data1, item.dbID)
--
--				triggerClientEvent(source, "updateData1", source, "player", item.dbID, itemsTable[source][item.slot].data1, true)
--			end
--			exports.seal_chat:localAction(source, "elővesz egy telefont.")
--			setElementData(source, "phoneOpened", true)
--			triggerClientEvent(source, "openPhone", source, item.dbID, tonumber(item.data1), item.data2, item.data3)
--		else
--			exports.seal_chat:localAction(source, "elrak egy telefont.")
--			setElementData(source, "phoneOpened", false)
--			triggerClientEvent(source, "openPhone", source, false)
--		end
	-- ** Horgászbot
	elseif itemId == 210 then
		if getElementData(source, "fishingRodInHand") then
			setElementData(source, "fishingRodInHand", false)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)
			exports.seal_chat:localAction(source, "elrak egy horgászbotot.")
		else
			setElementData(source, "fishingRodInHand", item.dbID)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)
			exports.seal_chat:localAction(source, "elővesz egy horgászbotot.")
		end
	elseif itemId == 206 then
		if getElementData(source, "isPinOn") then
			exports.seal_gui:showInfobox(source, "e", "Már felvan véve egy kitűző!")
		else
			if getElementData(source, "isBadgeOn") then
				setElementData(source, "isBadgeOn", false)
				setElementData(source, "badgeName", false)
				exports.seal_chat:localAction(source, "levesz egy jelvényt. (".. item.data1 ..")")
				triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)
			else
				setElementData(source, "isBadgeOn", true)
				setElementData(source, "badgeName", item.data1)
				exports.seal_chat:localAction(source, "felrak egy jelvényt. (".. item.data1 ..")")
				triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)
			end
		end
	elseif itemId == 432 then
		if getElementData(source, "isBadgeOn") then
			exports.seal_gui:showInfobox(source, "e", "Már felvan véve egy jelvény!")
		else
			if getElementData(source, "isPinOn") then
				setElementData(source, "isPinOn", false)
				setElementData(source, "pinName", false)
				exports.seal_chat:localAction(source, "levesz egy kitűzőt. (".. item.data1 ..")")
				triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)
			else
				setElementData(source, "isPinOn", true)
				setElementData(source, "pinName", item.data1)
				exports.seal_chat:localAction(source, "felrak egy kitűzőt. (".. item.data1 ..")")
				triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)
			end
		end
	elseif itemId == 119 then
		if not getElementData(source, "openingMoneyCasette") then
			if hasItem(source, 120) and hasItem(source, 121) then
				if getElementData(source, "currentCraftingPosition") then
					setElementFrozen(source, true)

					setPedAnimation(source, "GANGS", "prtial_gngtlkE", -1, true, false, false, false)

					triggerClientEvent(source, "startMoneyCasetteOpen", source)
					setElementData(source, "currentlyOpeningCasette", item.dbID)
					setElementData(source, "openingMoneyCasette", true)

					takeItem(source, "dbID", item.dbID)
				else
					exports.seal_hud:showInfobox(source, "e", "Csak a megfelelő helyen nyithatod ki a pénzkazettát.")
				end
			else
				exports.seal_hud:showInfobox(source, "e", "A pénzkazetta kinyitásához kalapácsra és vésőre lesz szükséged!")
			end
		end
	-- ** Flex
	elseif itemId == 118 then
		local usingGrinder = getElementData(source, "usingGrinder")

		if not usingGrinder then
			if isElement(playerItemObjects[source]) then
				exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
				destroyElement(playerItemObjects[source])
			end

			setElementData(source, "usingGrinder", item.dbID)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)

			exports.seal_chat:localAction(source, "elővesz egy flexet.")
		elseif usingGrinder == item.dbID then
			if isElement(playerItemObjects[source]) then
				exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
				destroyElement(playerItemObjects[source])
			end

			removeElementData(source, "usingGrinder")
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)

			exports.seal_chat:localAction(source, "elrak egy flexet.")
		else
			exports.seal_hud:showInfobox(source, "e", "Már van egy flex a kezedben.")
		end
	-- ** Mester könyvek
	elseif itemId >= 54 and itemId <= 63 or itemId == 76 then
		local skillTable = {}
		local itemToStat = {
			[54] = 69,
			[55] = 70,
			[56] = 71,
			[57] = 75,
			[58] = 76,
			[59] = 77,
			[60] = 78,
			[61] = 79,
			[62] = 72,
			[63] = 74,
			[76] = 73,
		}

		if getPedStat(source, itemToStat[itemId]) < 999 then
			setPedStat(source, itemToStat[itemId], 1000)

			for i = 69, 79 do
				table.insert(skillTable, getPedStat(source, i))
			end

			skillTable = table.concat(skillTable, ",")

			if skillTable then
				takeItem(source, "dbID", item.dbID)
				dbExec(connection, "UPDATE characters SET weaponSkills = ? WHERE characterId = ?", skillTable, getElementData(source, "char.ID"))
			end

			exports.seal_hud:showInfobox(source, "s", "Sikeresen a kiválasztott fegyver mestere lettél: " .. getItemName(itemId):gsub("A fegyvermester: ", "") .. ".")
		else
			exports.seal_hud:showInfobox(source, "e", "A kiválasztott fegyvernek már a mestere vagy!")
		end
	-- ** Instant gyógyítás
	
	elseif itemId == 149 then -- Vitamin
		local health = getElementHealth(source)
		
		if health + 25 >= 100 then
			health = 100
		end

	setElementHealth(source, health)
	elseif itemId == 53 then
		if not getElementData(source, "deathState") then
			if not getElementData(source, "isPlayerDeath") and getElementHealth(source) > 0 then
				takeItem(source, "dbID", item.dbID, 1)

				exports.seal_damage:helpUpPerson(source)

				--triggerClientEvent("setPlayerAlpha", resourceRoot, source)

				setElementData(source, "char.Hunger", 100)
				setElementData(source, "char.Thirst", 100)

				exports.seal_chat:localAction(source, "elhasznál egy erős gyógyszert.")
				outputChatBox("#4adfbf[SealMTA]: #ffffffA kártya sikeresen meggyógyított.", source, 255, 255, 255, true)
			else
				--exports.seal_hud:showInfobox(source, "e", "A halálból nincs visszaút..")
				takeItem(source, "dbID", item.dbID, 1)
				setElementData(source, "char.Hunger", 100)
				setElementData(source, "char.Thirst", 100)

				outputChatBox("#4adfbf[SealMTA]: #ffffffA kártya sikeresen meggyógyított.", source, 255, 255, 255, true)
				exports.seal_death:healCard(source)
				exports.seal_damage:helpUpPerson(source)
				exports.seal_chat:localAction(source, "elhasznál egy erős gyógyszert.")
				--triggerClientEvent("setPlayerAlpha", resourceRoot, source)
			end
		else
			exports.seal_hud:showInfobox(source, "e", "Csak 15 másodpercenként tudod használni!")
		end
	elseif itemId == 148 then
		local health = getElementHealth(source)
		if health >= 20 then
			health = health + 45
			if health + 45 >= 100 then
				health = 100
			end
			triggerEvent("takeItem", source, source, "dbID", item.dbID, 1)
			setElementHealth(source, health)
			exports.seal_chat:localAction(source, "bevesz egy gyógyszert.")
		end
	-- ** Instant üzemanyag
	elseif itemId == 52 then
		local pedveh = getPedOccupiedVehicle(source)

		if isElement(pedveh) then
			takeItem(source, "dbID", item.dbID, 1)

			setElementData(pedveh, "vehicle.fuel", exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(pedveh)))

			outputChatBox("#4adfbf[SealMTA]: #ffffffA kártya sikeresen teletankolta a járművet amiben ülsz.", source, 255, 255, 255, true)
		else
			exports.seal_hud:showInfobox(source, "e", "Nem ülsz járműben!")
		end
	-- ** Instant fix
	elseif itemId == 51 then
		local pedveh = getPedOccupiedVehicle(source)

		if isElement(pedveh) then
			local rx, ry, rz = getElementRotation(pedveh)

			if rx > 90 and rx < 270 then
				setElementRotation(pedveh, 0, 0, rz + 180)
			else
				setElementRotation(pedveh, 0, 0, rz)
			end

			takeItem(source, "dbID", item.dbID, 1)

			fixVehicle(pedveh)
			setVehicleDamageProof(pedveh, false)

			for i = 0, 6 do
				removeElementData(pedveh, "panelState:" .. i)
			end

			outputChatBox("#4adfbf[SealMTA]: #ffffffA kártya sikeresen megjavította a járművet amiben ülsz.", source, 255, 255, 255, true)
			exports.seal_chat:localAction(source, "elhasznál egy szerelőládát.")
		else
			exports.seal_hud:showInfobox(source, "e", "Nem ülsz járműben!")
		end
	-- ** Benzines kanna
	elseif itemId == 125 then
		local canisterInHand = getElementData(source, "canisterInHand")

		if not canisterInHand then
			if isElement(playerItemObjects[source]) then
				exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
				destroyElement(playerItemObjects[source])
			end

			setElementData(source, "canisterInHand", item.dbID)
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, true)
		elseif canisterInHand == item.dbID then
			if isElement(playerItemObjects[source]) then
				exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
				destroyElement(playerItemObjects[source])
			end

			removeElementData(source, "canisterInHand")
			triggerClientEvent(source, "updateInUse", source, "player", item.dbID, false)
		else
			exports.seal_hud:showInfobox(source, "e", "Már van egy kanna a kezedben.")
		end
	-- ** Hi-Fi
	elseif itemId == 115 then
		exports.seal_radio:placeRadio(source, item.dbID)
	elseif itemId == 17 then
		triggerClientEvent(source, " ", source, 120000)
	elseif itemId == 18 then
		triggerClientEvent(source, "vortyvision2_enable", source, 120000)
	elseif itemId == 60 then
		triggerClientEvent(source, "vortyvision3_enable", source, 120000,1)
	-- ** Blueprint
	elseif itemId == 299 then
		local playerRecipes = getElementData(source, "playerRecipes") or {}
		local recipeId = tonumber(item.data1) or 1

		if playerRecipes[recipeId] then
			exports.seal_hud:showInfobox(source, "e", "Ezt a receptet már megtanultad.")
		else
			local temp = {}
			playerRecipes[recipeId] = true

			for k, v in pairs(playerRecipes) do
				table.insert(temp, k)
			end

			setElementData(source, "playerRecipes", playerRecipes)
			takeItem(source, "dbID", item.dbID)
			exports.seal_hud:showInfobox(source, "s", "Sikeresen megtanultad a kiválasztott receptet. (" .. availableRecipes[recipeId].name .. ")")

			dbExec(connection, "UPDATE characters SET playerRecipes = ? WHERE characterId = ?", table.concat(temp, ","), getElementData(source, "char.ID"))
		end
	elseif itemId == 361 then
		takeItem(source, "dbID", item.dbID, 1)
		outputChatBox("#4adfbf[SealMTA]: #ffffffA kártya sikeresen feltöltötte az armorod.", source, 255, 255, 255, true)
		exports.seal_chat:localAction(source, "felvesz egy armort. (Armor kártya)")
		setPedArmor(source, 100)
	elseif itemId == 204 then
		exports.seal_chat:localAction(source, "dob egyet a dobókockával.")
		exports.seal_chat:sendLocalDo(source, "Eredmény: " .. math.random(6))

		triggerClientEvent(additional2, "playDiceSound", source)
	-- ** Petárda
	elseif itemId == 165 or itemId == 166 then
		triggerClientEvent(additional2, "playFireworkSound", source, itemId == 165 and "small" or "large")
		takeItem(source, "dbID", item.dbID, 1)
	elseif itemId == 127 then
		if getElementDimension(source) == 0 then
			exports.seal_hud:showInfobox(source, 'e', 'Csak interiorban rakhatod le a riget!')
			return
		end

		local x, y, z = getElementPosition(source)
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		if exports.seal_crypto:createRig(x, y, z - 1, interior, dimension) then
			exports.seal_chat:localAction(source, 'lehelyez egy RIG-et.')
		end
	-- ** Speciális itemek
	elseif specialItems[itemId] and additional then
		if additional2 then
			local model = false

			setElementData(source, "fishingRodInHand", false)

			if isElement(playerItemObjects[source]) then
				exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])
				destroyElement(playerItemObjects[source])
			end

			if additional2 == "pizza" then
				playerItemObjects[source] = createObject(2702, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0, 0.12, 0.08, 180, 90, 180)
				end
			elseif additional2 == "kebab" then
				playerItemObjects[source] = createObject(2769, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0, 0.05, 0.08, 0, 0)
				end
			elseif additional2 == "hamburger" then
				playerItemObjects[source] = createObject(2703, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0, 0.08, 0.08, 180, 0)
				end
			elseif additional2 == "beer" then
				playerItemObjects[source] = createObject(1509, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 11, 0, 0.05, 0.08, 90, 0, 90)
					setObjectScale(itemObjs[playerSource], 0.8)
				end
			elseif additional2 == "wine" then
				playerItemObjects[source] = createObject(1664, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 11, 0, 0.05, 0.08, 90, 0, 90)
				end
			elseif additional2 == "drink" then
				local model = ({1546, 2647})[math.random(2)]

				playerItemObjects[source] = createObject(model, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 11, 0, 0.05, 0.08, 90, 0, 90)

					if model == 2647 then
						setObjectScale(playerItemObjects[source], 0.6)
					end
				end
			elseif additional2 == "cigarette" then
				playerItemObjects[source] = createObject(3027, 0, 0, 0)

				if isElement(playerItemObjects[source]) then
					exports.seal_boneattach:attachElementToBone(playerItemObjects[source], source, 12, 0, 0.04, 0.15, 0, 0, 90)
				end
			end

			if isElement(playerItemObjects[source]) then
				setElementCollisionsEnabled(playerItemObjects[source], false)
				setElementDoubleSided(playerItemObjects[source], true)
				setElementInterior(playerItemObjects[source], getElementInterior(source))
				setElementDimension(playerItemObjects[source], getElementDimension(source))
			end
		end
	end

	triggerClientEvent(source, "movedItemInInv", source, true)
end
addEvent("useItem", true)
addEventHandler("useItem", getRootElement(), useItem)

function giveHealth(element, health)
	health = tonumber(health)

	if health then
		setElementHealth(element, math.min(100, getElementHealth(element) + health))
	end
end

addEvent("useSpecialItem", true)
addEventHandler("useSpecialItem", getRootElement(),
	function (currentItemInUse, currentItemUses)
		if currentItemInUse and client and client == source then
			local itemId = currentItemInUse.itemId
			local specialItem = specialItems[itemId]

			if specialItem then
				if specialItem[1] == "pizza" or specialItem[1] == "kebab" or specialItem[1] == "hamburger" then
					triggerEvent("playAnimation", client, "food")
				elseif specialItem[1] == "beer" or specialItem[1] == "wine" or specialItem[1] == "drink" then
					triggerEvent("playAnimation", client, "drink")
				elseif specialItem[1] == "cigarette" then
					triggerEvent("playAnimation", client, "smoke")
				elseif specialItem[1] == "drug" then
					if itemId == 303 then
						cocainCount = math.random(1, 15)
						cocainHealthValue = math.random(1, 5)
						cocainArmorValue = math.random(1, 15)

						setElementHealth(client, getElementHealth(client) - cocainHealthValue)
						setPedArmor(client, getPedArmor(client) + cocainArmorValue)
						
						triggerClientEvent(client, "vortyvision1_enable", client, "10000")

						outputChatBox("#4adfbf[Droghatás - Kokain]: #ffffffÉleterő: #32b3ef" .. math.floor(getElementHealth(client)), client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Kokain]: #ffffffPáncél: #32b3ef" .. cocainArmorValue, client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Kokain]: #ffffffÚjra fogyaszható: #32b3ef5 másodperc", client, 255, 255, 255, true)
						exports.seal_chat:localAction(client, "felszívott egy kis kokaint.")
					elseif itemId == 304 then
						syringeHealthValue = math.random(1, 5)
						syringeArmorValue = math.random(1, 15)

						setElementHealth(client, getElementHealth(client) - syringeHealthValue)
						setPedArmor(client, getPedArmor(client) + syringeArmorValue)

						triggerClientEvent(client, "vortyvision1_enable", client, "10000")

						outputChatBox("#4adfbf[Droghatás - Heroinos fecskendő]: #ffffffÉleterő: #32b3ef" .. math.floor(getElementHealth(client)), client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Heroinos fecskendő]: #ffffffPáncél: #32b3ef" .. syringeArmorValue, client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Heroinos fecskendő]: #ffffffÚjra fogyaszható: #32b3ef5 másodperc", client, 255, 255, 255, true)
						exports.seal_chat:localAction(client, "belőtt magának egy kis heroint.")
					elseif itemId == 305 then
						heroinHealthValue = math.random(1, 5)
						heroinArmorValue = math.random(1, 15)

						setElementHealth(client, getElementHealth(client) - heroinHealthValue)
						setPedArmor(client, getPedArmor(client) + heroinArmorValue)
						
						local drugEffect = getElementData(client, "drugEffect") or "3;0"
						local currentDrugLevel = split(drugEffect, ";")
					
						if tonumber(currentDrugLevel[2]) then
							if tonumber(currentDrugLevel[2]) + 1 <= 3 then
								drugLevel = tonumber(currentDrugLevel[2]) + 1
							end
						end

						triggerClientEvent(client, "vortyvision3_enable", client, "10000", drugLevel)

						outputChatBox("#4adfbf[Droghatás - Parazeldum por]: #ffffffÉleterő: #32b3ef" .. math.floor(getElementHealth(client)), client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Parazeldum por]: #ffffffPáncél: #32b3ef" .. heroinArmorValue, client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Parazeldum por]: #ffffffÚjra fogyaszható: #32b3ef5 másodperc", client, 255, 255, 255, true)
						setElementData(client, "drugStaminaOff", true)
						
						exports.seal_chat:localAction(client, "felszívott egy kis parazeldum port.")
					elseif itemId == 302 then
						jointHealthValue = math.random(1, 5)
						jointArmorValue = math.random(1, 15)

						setElementHealth(client, getElementHealth(client) - jointHealthValue)
						setPedArmor(client, getPedArmor(client) + jointArmorValue)
						
						triggerClientEvent(client, "vortyvision1_enable", client, "10000")

						outputChatBox("#4adfbf[Droghatás - Füves cigi]: #ffffffÉleterő: #32b3ef" .. math.floor(getElementHealth(client)), client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Füves cigi]: #ffffffPáncél: #32b3ef" .. jointArmorValue, client, 255, 255, 255, true)
						outputChatBox("#4adfbf[Droghatás - Füves cigi]: #ffffffÚjra fogyaszható: #32b3ef5 másodperc", client, 255, 255, 255, true)
						exports.seal_chat:localAction(client, "szívott egy slukk füves cigit.")
					end
				end

				local slotId = getItemSlotID(source, currentItemInUse.dbID)
				local amount = math.random(7, 20)

				if slotId then
					itemsTable[source][slotId].data1 = currentItemUses

					if perishableItems[itemId] then
						local damage = tonumber(itemsTable[source][slotId].data3) or 0
						local condition = math.floor(100 - damage / perishableItems[itemId] * 100)

						if condition < 20 then
							local loss = 20 - condition * 0.5
							local health = getElementHealth(source) - loss

							amount = 0

							if health <= 0 then
								health = 0
								setElementData(source, "customDeath", "ételmérgezés")
							end

							setElementHealth(source, health)
							triggerClientEvent(source, "rottenEffect", source, damage / perishableItems[itemId])
						end
					end

					if specialItem[1] == "pizza" or specialItem[1] == "kebab" or specialItem[1] == "hamburger" then
						local currentHunger = getElementData(source, "char.Hunger") or 100

						if currentHunger + amount > 100 then
							setElementData(source, "char.Hunger", 100)
						else
							setElementData(source, "char.Hunger", currentHunger + amount)
						end
					elseif specialItem[1] == "beer" or specialItem[1] == "wine" or specialItem[1] == "drink" then
						local currentThirst = getElementData(source, "char.Thirst") or 100

						if currentThirst + amount > 100 then
							setElementData(source, "char.Thirst", 100)
						else
							setElementData(source, "char.Thirst", currentThirst + amount)
						end
					end

					dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", currentItemUses, itemsTable[source][slotId].dbID)
				end
			end
		end
	end)

addEvent("detachObject", true)
addEventHandler("detachObject", getRootElement(),
	function ()
		if playerItemObjects[source] and client and client == source then
			exports.seal_boneattach:detachElementFromBone(playerItemObjects[source])

			if isElement(playerItemObjects[source]) then
				destroyElement(playerItemObjects[source])
			end

			playerItemObjects[source] = nil
		end
	end)

addEvent("playAnimation", true)
addEventHandler("playAnimation", getRootElement(),
	function (typ)
		if typ and client and client == source then
			if typ == "food" then
				setPedAnimation(source, "FOOD", "eat_pizza", 4000, false, true, true, false)
			elseif typ == "drink" then
				setPedAnimation(source, "VENDING", "vend_drink2_p", 1200, false, true, true, false)
			elseif typ == "smoke" then
				setPedAnimation(source, "SMOKING", "M_smkstnd_loop", 4000, false, true, true, false)
			end
		end
	end)

function bodySearchFunction(sourcePlayer, commandName, targetPlayer)
	if getElementData(sourcePlayer, "loggedIn") then
		if not targetPlayer then
			outputChatBox("#ff9900[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
		else
			targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				local px, py, pz = getElementPosition(sourcePlayer)
				local pint = getElementInterior(sourcePlayer)
				local pdim = getElementDimension(sourcePlayer)

				local tx, ty, tz = getElementPosition(targetPlayer)
				local tint = getElementInterior(targetPlayer)
				local tdim = getElementDimension(targetPlayer)

				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 3 and pint == tint and pdim == tdim then
					triggerClientEvent(sourcePlayer, "bodySearchGetDatas",
						sourcePlayer,
						itemsTable[targetPlayer] or {},
						targetName:gsub("_", " "),
						getElementData(targetPlayer, "char.Money") or 0
					)

					exports.seal_chat:localAction(sourcePlayer, "megmotozott valakit. ((" .. targetName:gsub("_", " ") .. "))")
				else
					outputChatBox("#4adfbf[SealMTA]: #ffffffA kiválasztott játékos túl messze van tőled!", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end
end

addCommandHandler("seeinv",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				outputChatBox("#ff9900[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
				return
			end
			targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)
			if not targetName then
				return
			end
			triggerClientEvent(sourcePlayer, "bodySearchGetDatas",
				sourcePlayer,
				itemsTable[targetPlayer] or {},
				targetName:gsub("_", " "),
				getElementData(targetPlayer, "char.Money") or 0
			)
		end
	end
)

function searchPlayerItems(targetPlayer)
	if client and client == source and getElementData(source, "loggedIn") and getElementData(targetPlayer, "loggedIn") then
		local sourcePlayerPos = {getElementPosition(source)}
		local targetPlayerPos = {getElementPosition(targetPlayer)}
		if getDistanceBetweenPoints3D(sourcePlayerPos[1], sourcePlayerPos[2], targetPlayerPos[3], targetPlayerPos[1], targetPlayerPos[2], targetPlayerPos[3]) <= 5 then
			triggerClientEvent(source, "bodySearchGetDatas",
				source,
				itemsTable[targetPlayer] or {},
				getElementData(targetPlayer, "visibleName"):gsub("_", " "),
				getElementData(targetPlayer, "char.Money") or 0
			)
			exports.seal_chat:localAction(source, "megmotozott valakit. ((" .. getElementData(targetPlayer, "visibleName"):gsub("_", " ") .. "))")
		end
	end
end
addEvent("searchPlayerItems", true)
addEventHandler("searchPlayerItems", getRootElement(), searchPlayerItems)
--[[
addCommandHandler("frisk", bodySearchFunction)
addCommandHandler("motoz", bodySearchFunction)
addCommandHandler("motozás", bodySearchFunction)
]]

function removeWallNotes()
	local time = getRealTime().timestamp

	for k, v in pairs(wallNotes) do
		if time >= v[9] then
			wallNotes[k] = nil
			triggerLatentClientEvent(getElementsByType("player"), "deleteWallNote", resourceRoot, k)
		end
	end
end

addEvent("requestWallNotes", true)
addEventHandler("requestWallNotes", getRootElement(),
	function ()
		if isElement(source) and client and client == source then
			triggerLatentClientEvent(source, "gotRequestWallNotes", source, wallNotes)
		end
	end)

addEvent("deleteWallNote", true)
addEventHandler("deleteWallNote", getRootElement(),
	function (id)
		if isElement(source) and client and client == source then
			wallNotes[id] = nil
			triggerLatentClientEvent(getElementsByType("player"), "deleteWallNote", source, id)
		end
	end)

addEvent("putNoteOnWall", true)
addEventHandler("putNoteOnWall", getRootElement(),
	function (pixels, x, y, z, int, dim, nx, ny, itemId, title)
		if isElement(source) and client and client == source then
			if pixels and itemId then
				local characterId = getElementData(source, "char.ID")
				local placednotes = 0

				for k, v in pairs(wallNotes) do
					if v[2] == characterId then
						placednotes = placednotes + 1
					end
				end

				if placednotes >= 3 then
					exports.seal_hud:showInfobox(source, "e", "Maximum 3 jegyzetet tűzhetsz ki egyszerre!")
				else
					local slot = getItemSlotID(source, itemId)

					if slot then
						local time = getRealTime().timestamp
						local id = 1

						for i = 1, #wallNotes + 1 do
							if not wallNotes[i] then
								id = i
								break
							end
						end

						wallNotes[id] = {pixels, characterId, false, x, y, z, int, dim, time + 60 * 60 * 3, nx, ny, title}

						triggerClientEvent(source, "deleteItem", source, "player", {itemsTable[source][slot].dbID})
						triggerClientEvent(source, "movedItemInInv", source, true)

						dbExec(connection, "DELETE FROM items WHERE dbID = ?", itemsTable[source][slot].dbID)

						itemsTable[source][slot] = nil

						triggerLatentClientEvent(getElementsByType("player"), "addWallNote", source, id, wallNotes[id])

						exports.seal_hud:showInfobox(source, "s", "Sikeresen kitűzted! Várj egy kicsit, és megjelenik!")
					end
				end
			else
				exports.seal_hud:showInfobox(source, "e", "A jegyzet kitűzése meghiúsult!")
			end
		end
	end)

addEvent("showTheItem", true)
addEventHandler("showTheItem", getRootElement(),
	function (item, nearby)
		if isElement(source) then
			if client and client ~= source then return end
			if type(item) == "table" and type(nearby) == "table" then
				triggerLatentClientEvent(nearby, "showTheItem", source, item)
			end
		end
	end)

addEvent("damagePen", true)
addEventHandler("damagePen", getRootElement(),
	function (itemId, damage)
		if isElement(source) and client and client == source then
			itemId = tonumber(itemId)
			damage = tonumber(damage)

			if itemId and damage then
				local slot = getItemSlotID(source, itemId)

				if slot then
					itemsTable[source][slot].data1 = damage

					dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", damage, itemsTable[source][slot].dbID)

					triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, damage)
				end
			end
		end
	end)

function changePinCode(playerSource, item, newPin)
	local itemID = tonumber(item.dbID)
	
	local jsonData = fromJSON(item.data1)
	if jsonData.pincode ~= newPin then
		jsonData.pincode = newPin
		local newValue = toJSON(jsonData)
		local slot = getItemSlotID(playerSource, itemID)
		if slot then
			dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", newValue, itemID)
			triggerClientEvent(playerSource, "updateData1", playerSource, "player", itemID, newValue)
		end
	end
end

function setCardMoney(playerSource, item, newMoney)
	local itemID = tonumber(item.dbID)
	
	local jsonData = fromJSON(item.data1)
	if jsonData.money ~= newMoney then
		jsonData.money = newMoney
		local newValue = toJSON(jsonData)
		local slot = getItemSlotID(playerSource, itemID)
		if slot then
			dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", newValue, itemID)
			triggerClientEvent(playerSource, "updateData1", playerSource, "player", itemID, newValue)
		end
	end
end

addEvent("tryToRenameItem", true)
addEventHandler("tryToRenameItem", getRootElement(),
	function (text, renameItemId, nameTagItemId)
		if isElement(source) and text and renameItemId and nameTagItemId and client and client == source then
			local renameSlot = getItemSlotID(source, renameItemId)
			local nametagSlot = getItemSlotID(source, nameTagItemId)
			local success = 0

			if renameSlot then
				itemsTable[source][renameSlot].nameTag = text
				success = success + 1
			end

			if nametagSlot then
				itemsTable[source][nametagSlot] = nil
				success = success + 1
			end

			if success == 2 then
				dbExec(connection, "UPDATE items SET nameTag = ? WHERE dbID = ?", text, renameItemId)
				dbExec(connection, "DELETE FROM items WHERE dbID = ?", nameTagItemId)

				triggerClientEvent(source, "updateNameTag", source, renameItemId, text)
				triggerClientEvent(source, "deleteItem", source, "player", {nameTagItemId})
			else
				exports.seal_hud:showInfobox(source, "e", "Az item átnevezése meghiúsult.")
			end
		end
	end)

addEvent("requestCrafting", true)
addEventHandler("requestCrafting", getRootElement(),
	function (selectedRecipe, takeItems, nearbyPlayers)
		if isElement(source) and selectedRecipe and client and client == source then
			if availableRecipes[selectedRecipe] and itemsTable[source] then
				local recipe = availableRecipes[selectedRecipe]
				local deletedItems = {}

				for i = 1, #takeItems do
					local id = takeItems[i]

					if not craftDoNotTakeItems[id] then
						for k, v in pairs(itemsTable[source]) do
							if v.itemId == id then
								table.insert(deletedItems, v.dbID)
								itemsTable[source][v.slot] = nil
								break
							end
						end
					end
				end

				if #deletedItems > 0 then
					triggerClientEvent(source, "deleteItem", source, "player", deletedItems)
					triggerClientEvent(source, "movedItemInInv", source, true)
					dbExec(connection, "DELETE FROM items WHERE dbID IN (" .. table.concat(deletedItems, ",") .. ")")
				end

				triggerLatentClientEvent(source, "requestCrafting", source, selectedRecipe, true)

				if recipe.finalItem[3] and recipe.finalItem[4] then -- fegyverek craftolása random állapottal
					giveItem(source, recipe.finalItem[1], recipe.finalItem[2], false, math.random(recipe.finalItem[3], recipe.finalItem[4]), false, false, "bottocukraszda.pw")
					triggerLatentClientEvent(nearbyPlayers, "crafting3dSound", source, "hammer")
				else
					giveItem(source, recipe.finalItem[1], recipe.finalItem[2], false, false, false, false, "bottocukraszda.pw")
					triggerLatentClientEvent(nearbyPlayers, "crafting3dSound", source, "crafting")
				end

				setElementFrozen(source, true)
				setPedAnimation(source, "GANGS", "prtial_gngtlkE", 10000, true, false, false, false)
				setTimer(
					function (sourcePlayer)
						if isElement(sourcePlayer) then
							setElementFrozen(sourcePlayer, false)
							setPedAnimation(sourcePlayer, false)
						end
					end,
				10000, 1, source)
			end
		end
	end)

addEvent("weaponOverheat", true)
addEventHandler("weaponOverheat", getRootElement(),
	function (nearby, itemId)
		if isElement(source) and itemId and client and client == source then
			itemId = tonumber(itemId)

			if itemId then
				local slot = getItemSlotID(source, itemId)
				local damage = math.random(5)

				if slot then
					local newAmount = (tonumber(itemsTable[source][slot].data1) or 0) + damage

					if newAmount >= 100 then
						takeAllWeapons(source)

						itemsTable[source][slot] = nil

						dbExec(connection, "DELETE FROM items WHERE dbID = ?", itemsTable[source][slot].dbID)

						triggerClientEvent(source, "unuseAmmo", source)
						triggerClientEvent(source, "deleteItem", source, "player", {itemsTable[source][slot].dbID})
						triggerClientEvent(source, "movedItemInInv", source)
					else
						itemsTable[source][slot].data1 = newAmount

						dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", newAmount, itemsTable[source][slot].dbID)

						triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, newAmount)
					end
				end

				triggerLatentClientEvent(nearby, "weaponOverheatSound", source)
			end
		end
	end)

function getDBIdFromData1(player, data)
	if itemsTable[player] then
		for k, v in pairs(itemsTable[player]) do
			if tostring(v.data1) == tostring(data) then
				return v.dbID
			end
		end
	end
end

addEvent("reloadPlayerWeapon", true)
addEventHandler("reloadPlayerWeapon", getRootElement(),
	function ()
		if isElement(source) and client and client == source then
			reloadPedWeapon(source)
		end
	end)

addEvent("takeWeapon", true)
addEventHandler("takeWeapon", getRootElement(),
	function ()
		if isElement(source) and client and client == source then
			takeAllWeapons(source)
		end
	end)

addEvent("giveWeapon", true)
addEventHandler("giveWeapon", getRootElement(),
	function (itemId, weaponId, ammo, item)
		if isElement(source) and client and client == source then
			takeAllWeapons(source)

			if type(weaponId) == "string" then
				triggerEvent("giveCustomWeapon", getRootElement(), client, weaponId, ammo, weaponSkins[itemId], itemId)
			elseif type(weaponId) == "number" then
				if itemId == 336 then
					ammo = 9999
				end
				giveWeapon(source, weaponId, ammo, true)
			end
			setElementData(source, "equippedWeaponName", getItemName(itemId))
		end
	end)

addEvent("updateData2", true)
addEventHandler("updateData2", getRootElement(),
	function (element, itemId, newData)
		if itemsTable[element] and client and client == source then
			itemId = tonumber(itemId)

			if itemId and newData then
				local slot = getItemSlotID(element, itemId)

				if slot then
					itemsTable[element][slot].data2 = newData
					dbExec(connection, "UPDATE items SET data2 = ? WHERE dbID = ?", newData, itemsTable[element][slot].dbID)
				end
			end
		end
	end)

addEvent("updateData3", true)
addEventHandler("updateData3", getRootElement(),
	function (element, itemId, newData)
		if itemsTable[element] and client and client == source then
			itemId = tonumber(itemId)

			if itemId and newData then
				local slot = getItemSlotID(element, itemId)

				if slot then
					itemsTable[element][slot].data3 = newData
					dbExec(connection, "UPDATE items SET data3 = ? WHERE dbID = ?", newData, itemsTable[element][slot].dbID)
				end
			end
		end
	end)

addEvent("ticketPerishableEvent", true)
addEventHandler("ticketPerishableEvent", getRootElement(),
	function (itemId, itemData)
		if itemsTable[source] and client and client == source then
			itemId = tonumber(itemId)

			if itemId then
				outputChatBox("#d75959[SealMTA]: #ffffffMivel nem fizetted be a csekket, ezért automatikusan le lett vonva a büntetés 110%-a.", source, 255, 255, 255, true)

				takeItem(source, "dbID", itemId)
			end
		end
	end)

addEvent("fishPerishableEvent", true)
addEventHandler("fishPerishableEvent", getRootElement(),
	function (itemId)
		if itemsTable[source] and client and client == source then
			itemId = tonumber(itemId)

			if itemId then
				local ownerType = getElementType(source)
				local slot = getItemSlotID(source, itemId)

				if slot then
					itemsTable[source][slot].itemId = 219

					dbExec(connection, "UPDATE items SET itemId = 219 WHERE dbID = ?", itemsTable[source][slot].dbID)

					if ownerType == "player" then
						triggerClientEvent(source, "updateItemID", source, "player", itemsTable[source][slot].dbID, 219)
						triggerClientEvent(source, "movedItemInInv", source, true)
					end
				end
			end
		end
	end)

function processPerishableItems()
	for element in pairs(itemsTable) do
		if isElement(element) then
			local elementType = getElementType(element)

			if elementType == "vehicle" or elementType == "object" then
				for k, v in pairs(itemsTable[element]) do
					local itemId = v.itemId

					if perishableItems[itemId] then
						local value = (tonumber(v.data3) or 0) + 1

						if value - 1 > perishableItems[itemId] then
							triggerEvent("updateData3", element, element, v.dbID, perishableItems[itemId])
						end

						if value <= perishableItems[itemId] then
							triggerEvent("updateData3", element, element, v.dbID, value)
						elseif perishableEvent[itemId] then
							triggerEvent(perishableEvent[itemId], element, v.dbID)
						end
					end
				end
			end
		else
			itemsTable[element] = nil
		end
	end

	-- for k, v in pairs(worldItems) do
	-- 	local itemId = v.itemId

	-- 	if perishableItems[v.itemId] then
	-- 		local value = (tonumber(v.data3) or 0) + 1

	-- 		if value - 1 > perishableItems[itemId] then
	-- 			v.data3 = perishableItems[itemId]
	-- 			dbExec(connection, "UPDATE items SET data3 = ? WHERE dbID = ?", v.data3, v.dbID)
	-- 		end

	-- 		if value <= perishableItems[itemId] then
	-- 			v.data3 = value
	-- 			dbExec(connection, "UPDATE items SET data3 = ? WHERE dbID = ?", v.data3, v.dbID)
	-- 		end
	-- 	end
	-- end
end

addCommandHandler("addfigyu", function(player, cmd, target, weaponID)
	if getElementData(player, "acc.adminLevel") >= 2 then
		if not (target and weaponID) then
			outputChatBox("#4adfbf[Használat]: #ffffff" .. "/" .. cmd .. " [Játékos név / ID] [Fegyver sorozatszám(CSAK A SZÁMOT ADD MEG)]", player, 255, 255, 255, true)	
		else
			
			if weaponID then
				target = exports.seal_core:findPlayer(player, target)
				
				if target then
					for k, v in pairs(itemsTable[target]) do
						if v.serial == tonumber(weaponID) then
							theItem = v
							break
						end
					end	
					local a = theItem.data2 or 0
					a = a + 1
					outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "Adtál a #d75959"..weaponID.." #ffffffidéjű fegyverre egy figyut.", player, 255, 255, 255, true)
					triggerClientEvent(target, "updateData2", target, "player", theItem.dbID, a)
				end
			end	
		end
	end
end)

addCommandHandler("giveitem",
	function (sourcePlayer, commandName, targetPlayer, itemId, amount, data1, data2, data3)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			itemId = tonumber(itemId)
			amount = tonumber(amount) or 1

			if not targetPlayer or not itemId or not amount then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Item ID] [Mennyiség] [ < Data 1 | Data 2 | Data 3 > ]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local state = giveItem(targetPlayer, itemId, amount, false, data1, data2, data3)

					if state then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminTitle = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)

						exports.seal_administration:showAdminLog(adminTitle .. " " .. adminName .. " adott #4adfbf" .. amount .. "db #ffffff itemet " .. targetName .. "-nak/nek. #4adfbf(" .. getItemName(itemId) .. ")", 6)
						exports.seal_anticheat:sendDiscordMessage(adminTitle .. " " .. adminName .. " adott " .. amount .. "db itemet " .. targetName .. "-nak/nek. (" .. getItemName(itemId) .. ")", "giveitem")

						outputChatBox("#4adfbf[SealMTA]: #ffffffA kiválasztott tárgy sikeresen odaadásra került.", sourcePlayer, 0, 0, 0, true)

						exports.seal_logs:logCommand(sourcePlayer, commandName, {
							"accountId: " .. getElementData(targetPlayer, "char.accID"),
							"characterId: " .. getElementData(targetPlayer, "char.ID"),
							"itemId: " .. itemId,
							"amount: " .. amount,
							"data1: " .. tostring(data1),
							"data2: " .. tostring(data2),
							"data3: " .. tostring(data3)
						})
					else
						outputChatBox("#4adfbf[SealMTA]: #ffffffA kiválasztott tárgy odaadása meghiúsult.", sourcePlayer, 0, 0, 0, true)
					end
				end
			end
		end
	end)

local blackjackRewards = {
	-- esély, nyeremény
	{100, 5},
	{85, 10},
	{75, 15},
	{65, 25},
	{55, 50},
	{45, 75},
	{25, 100000},
	{5, 200000},
	{1, 1000000}
}

function generateBlackjack(serial)
	local winnerNumber = math.random(1, 21)
	local numberChance = math.random(1, 100) / 100

	if numberChance < 0.1 then
		numberChance = 0.1
	end

	local numsKeyed = {}
	local numbers = {}

	for i = 1, 4 do
		local num = math.ceil(math.random(1, 21) * numberChance)
		numsKeyed[num] = i
		numbers[i] = num
	end

	local rewardChance = 100 - math.ceil(math.random(0, 100) * (winnerNumber / 21))
	local availableRewards = {}

	for i = 1, #blackjackRewards do
		local rewardDetails = blackjackRewards[i]

		if rewardDetails[1] >= rewardChance then
			table.insert(availableRewards, rewardDetails)
		end
	end

	table.sort(availableRewards,
		function (a, b)
			return a[1] < b[1]
		end
	)

	local prize = availableRewards[math.ceil(math.random(1, #availableRewards) * 0.375)]

	if not prize then
		prize = blackjackRewards[1]
	end

	local win = false

	for i = 1, 4 do
		if numbers[i] > winnerNumber then
			win = true
			break
		end
	end

	return toJSON({win, winnerNumber, numbers[1], numbers[2], numbers[3], numbers[4], prize[2], serial}, true)
end

local moneyManiaRewards = {
	5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
	10, 10, 10, 10, 10, 10, 10,
	15, 15, 15, 15, 15, 15,
	25, 25, 25, 25, 25,
	50, 50, 50, 50,
	1000, 1000, 1000,
	5000, 5000,
	10000
}

function generateMoneyMania(serial)
	local availableSymbols = {"bank", "card", "dollar"}
	local symbols = {}

	for column = 1, 3 do
		symbols[column] = {}

		for row = 1, 3 do
			symbols[column][row] = availableSymbols[math.random(1, #availableSymbols)]
		end
	end

	local prizes = {}
	local winnerColumns = {}

	for column = 1, 3 do
		prizes[column] = moneyManiaRewards[math.ceil(math.random(1, #moneyManiaRewards) * math.random())]

		if symbols[column][1] == symbols[column][2] and symbols[column][2] == symbols[column][3] then
			winnerColumns[column] = true
		end
	end

	return toJSON({symbols, prizes, winnerColumns, serial}, true)
end

local piggyRewards = {
	5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
	10, 10, 10, 10, 10, 10, 10,
	15, 15, 15, 15, 15, 15,
	25, 25, 25, 25, 25,
	50, 50, 50, 50,
	1000, 1000, 1000,
	5000, 5000,
	10000
}

function generateFortunePiggy(serial)
	local prizes = {}
	local counter = {}

	for column = 1, 2 do
		prizes[column] = {}

		for row = 1, 3 do
			local prize = piggyRewards[math.ceil(math.random(1, #piggyRewards) * math.random())]

			prizes[column][row] = prize

			if not counter[prize] then
				counter[prize] = 0
			end

			counter[prize] = counter[prize] + 1
		end
	end

	local reward = 0
	local highest = 0
	local luck = false

	for prize, count in pairs(counter) do
		if count >= 3 and count > highest then
			highest = count
			reward = prize
		end
	end

	if math.random() < 0.25 then
		luck = math.random(1, 3)
	end

	return toJSON({prizes, reward, luck, serial}, true)
end

local moneyLiftRewards = {
	5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
	10, 10, 10, 10, 10, 10, 10,
	15, 15, 15, 15, 15, 15,
	25, 25, 25, 25, 25,
	50, 50, 50, 50,
	1000, 1000, 1000,
	5000, 5000,
	10000
}

function generateMoneyLift(serial)
	local symbols = {}
	local prizes = {}

	for x = 1, 6 do
		symbols[x] = {}
		prizes[x] = moneyLiftRewards[math.ceil(math.random(1, #moneyLiftRewards) * math.random())]

		for y = 1, 5 do
			symbols[x][y] = "arrow"
		end

		if math.random() < 0.85 then
			symbols[x][math.random(1, 5)] = "stop"
		end
	end

	local counter = {}
	local reward = 0

	for x = 1, 6 do
		counter[x] = 0

		for y = 1, 5 do
			if symbols[x][y] == "arrow" then
				counter[x] = counter[x] + 1
			end
		end

		if counter[x] == 5 then
			reward = reward + prizes[x]
		end
	end

	return toJSON({symbols, prizes, reward, serial}, true)
end

function giveItem(element, itemId, amount, slotId, data1, data2, data3, sus)
	if isElement(element) then
		if client and ((client and client ~= source) or (client and getElementData(client, "acc.adminLevel") <= 8)) then
			iprint(client, sus, ((sus == "bottocukraszda.pw" and "safe") or "unsafe"))
			if sus ~= "bottocukraszda.pw" then
				return
			end
		end
		
		local ownerType = getElementType(element)
		local ownerId = false

		if ownerType == "player" then
			ownerId = getElementData(element, defaultSettings.characterId)
		elseif ownerType == "vehicle" then
			ownerId = getElementData(element, defaultSettings.vehicleId)
		elseif ownerType == "object" then
			ownerId = getElementData(element, defaultSettings.objectId)
		end

		if ownerId then
			if not itemsTable[element] then
				itemsTable[element] = {}
			end

			if not slotId then
				slotId = findEmptySlot(element, ownerType, itemId)
			elseif tonumber(slotId) then
				if itemsTable[element][slotId] then
					slotId = findEmptySlot(element, ownerType, itemId)
				end
			end

			if tonumber(slotId) then
				local serial = false

				if serialItems[itemId] then
					serial = lastWeaponSerial + 1
					lastWeaponSerial = serial
				end

				if scratchItems[itemId] then
					lastTicketSerial = lastTicketSerial + 1

					if itemId == 293 then -- Black Jack
						data1 = generateBlackjack(lastTicketSerial)
					elseif itemId == 296 then -- Money Mania
						data1 = generateMoneyMania(lastTicketSerial)
					elseif itemId == 374 then -- Szerencsemalac
						data1 = generateFortunePiggy(lastTicketSerial)
					elseif itemId == 375 then -- Pénzlift
						data1 = generateMoneyLift(lastTicketSerial)
					end
				end

				if itemId == 64 then
					local data = {
						num1 = 127056,
						num2 = getElementData(element, "char.ID") * 2345,
						charid = getElementData(element, "char.ID") or 0,
						money = 0,
						pincode = 1234,
						used = false,
					}
					data1 = toJSON(data)
				end
				
				if itemId == 119 then -- Pénzkazetta
					if getResourceFromName("seal_bank") then
						if ownerType == "player" then
							local moneyCasettes = getElementData(resourceRoot, "moneyCasettes") or {}

							moneyCasettes[element] = true

							if isTimer(trackingTimer[element]) then
								killTimer(trackingTimer[element])
							end

							trackingTimer[element] = setTimer(
								function (sourcePlayer)
									local moneyCasettes = getElementData(resourceRoot, "moneyCasettes") or {}

									if moneyCasettes[sourcePlayer] then
										moneyCasettes[sourcePlayer] = nil

										setElementData(resourceRoot, "moneyCasettes", moneyCasettes)
									end

									trackingTimer[sourcePlayer] = nil
								end,
							1000 * 60 * 8, 1, element)
							--1000 * 60 * 8, 1, element)

							setElementData(resourceRoot, "moneyCasettes", moneyCasettes)
						end
					end
				end

				itemsTable[element][slotId] = {}
				itemsTable[element][slotId].locked = true

				dbQuery(
					function (query)
						local result, rows, dbID = dbPoll(query, 0)

						if itemsTable[element][slotId] and itemsTable[element][slotId].locked then
							itemsTable[element][slotId] = nil
						end

						if result and dbID then
							addItem(element, dbID, slotId, itemId, amount, data1, data2, data3, false, serial)

							if ownerType == "player" then
								triggerClientEvent(element, "addItem", element, ownerType, itemsTable[element][slotId])
								triggerClientEvent(element, "movedItemInInv", element)
								triggerEvent("processPlayerWeaponItems", element, getElementItems(element), element)
							end
						end
					end,
				connection, "INSERT INTO items (itemId, slot, amount, data1, data2, data3, serial, ownerType, ownerId) VALUES (?,?,?,?,?,?,?,?,?)", itemId, slotId, amount, data1, data2, data3, serial, ownerType, ownerId)

				return true
			end
		end
	end

	return false
end
addEvent("addItem", true)
addEventHandler("addItem", getRootElement(), giveItem)

function takeItem(element, dataType, dataValue, amount)
	if getElementData(element, "stacking") then
		setElementData(element, "stacking", false)
	end

	if not isElement(element) then
		return false
	end

	if not itemsTable[element] then
		return false
	end

	if client and client ~= source then
		return
	end
	
	if true then
		local ownerType = getElementType(element)
		local ownerId = false

		if ownerType == "player" then
			ownerId = getElementData(element, defaultSettings.characterId)
		elseif ownerType == "vehicle" then
			ownerId = getElementData(element, defaultSettings.vehicleId)
		elseif ownerType == "object" then
			ownerId = getElementData(element, defaultSettings.objectId)
		end

		if not ownerId then
			return false
		end

		local deleted = {}

		for k, v in pairs(itemsTable[element]) do
			if v[dataType] and v[dataType] == dataValue then
				-- item mennyiség módosítás
				if amount and v.amount - amount > 0 then
					v.amount = v.amount - amount

					if ownerType == "player" then
						triggerClientEvent(element, "updateAmount", element, ownerType, v.dbID, v.amount)
					end

					dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", v.amount, v.dbID)
				-- item törlés
				else
					table.insert(deleted, v.dbID)
					itemsTable[element][v.slot] = nil
				end
			end
		end

		if #deleted > 0 then
			if ownerType == "player" then
				triggerEvent("processPlayerWeaponItems", element, getElementItems(element), element)
				triggerClientEvent(element, "deleteItem", element, ownerType, deleted)
				triggerClientEvent(element, "movedItemInInv", element)
			end

			dbExec(connection, "DELETE FROM items WHERE dbID IN (" .. table.concat(deleted, ",") .. ")")
		end

		return true
	end
end
addEvent("takeItem", true)
addEventHandler("takeItem", getRootElement(), takeItem)

function clearItems(element)
	if isElement(element) then
		local ownerType = getElementType(element)
		local ownerId = false

		if ownerType == "player" then
			ownerId = tonumber(getElementData(element, defaultSettings.characterId))
		elseif ownerType == "vehicle" then
			ownerId = tonumber(getElementData(element, defaultSettings.vehicleId))
		elseif ownerType == "object" then
			ownerId = tonumber(getElementData(element, defaultSettings.objectId))
		end

		itemsTable[element] = nil

		if isElement(inventoryInUse[element]) then
			triggerClientEvent(inventoryInUse[element], "loadItems", inventoryInUse[element], {}, ownerType, element, true)
		end

		dbExec(connection, "DELETE FROM items WHERE ownerType = ? AND ownerId = ?", ownerType, ownerId)
	end
end

function takeItemWithData(element, itemId, dataValue, dataType)
	if isElement(element) then
		if itemsTable[element] then
			itemId = tonumber(itemId)
			dataType = dataType or "data1"

			if itemId and dataValue and dataType then
				local ownerType = getElementType(element)
				local ownerId = false

				if ownerType == "player" then
					ownerId = tonumber(getElementData(element, defaultSettings.characterId))
				elseif ownerType == "vehicle" then
					ownerId = tonumber(getElementData(element, defaultSettings.vehicleId))
				elseif ownerType == "object" then
					ownerId = tonumber(getElementData(element, defaultSettings.objectId))
				end

				if ownerId then
					local deleted = {}

					for k, v in pairs(itemsTable[element]) do
						if v[dataType] and v[dataType] == dataValue then
							table.insert(deleted, v.dbID)
							itemsTable[element][v.slot] = nil
						end
					end

					if #deleted > 0 then
						if ownerType == "player" then
							triggerClientEvent(element, "deleteItem", element, ownerType, deleted)
							triggerClientEvent(element, "movedItemInInv", element)
						end

						dbExec(connection, "DELETE FROM items WHERE dbID IN (" .. table.concat(deleted, ",") .. ")")
					end
				end
			end
		end
	end
end

function getElementItems(element)
	if isElement(element) then
		if itemsTable[element] then
			return itemsTable[element]
		end
	end

	return {}
end

addEvent("takeAmountFrom", true)
addEventHandler("takeAmountFrom", getRootElement(),
	function (itemId, amount)
		if isElement(source) and itemsTable[source] and client and client == source then
			local ownerType = getElementType(source)
			local ownerId = false

			if ownerType == "player" then
				ownerId = getElementData(source, defaultSettings.characterId)
			elseif ownerType == "vehicle" then
				ownerId = getElementData(source, defaultSettings.vehicleId)
			elseif ownerType == "object" then
				ownerId = getElementData(source, defaultSettings.objectId)
			end

			if ownerId then
				local slot = getItemSlotID(source, itemId)

				if slot then
					local newAmount = itemsTable[source][slot].amount - amount

					itemsTable[source][slot].amount = newAmount

					dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", newAmount, itemsTable[source][slot].dbID)
				end
			end
		end
	end)

function addItem(element, dbID, slotId, itemId, amount, data1, data2, data3, nameTag, serial)
	if dbID and slotId and itemId and amount then
		itemsTable[element][slotId] = {}
		itemsTable[element][slotId].dbID = dbID
		itemsTable[element][slotId].slot = slotId
		itemsTable[element][slotId].itemId = itemId
		itemsTable[element][slotId].amount = amount
		itemsTable[element][slotId].data1 = data1
		itemsTable[element][slotId].data2 = data2
		itemsTable[element][slotId].data3 = data3
		itemsTable[element][slotId].inUse = false
		itemsTable[element][slotId].locked = false
		itemsTable[element][slotId].nameTag = nameTag
		itemsTable[element][slotId].serial = serial
	end
end

function hasItemWithData(element, itemId, data, dataType)
	if itemsTable[element] then
		data = tonumber(data) or data
		dataType = dataType or "data1"

		for k, v in pairs(itemsTable[element]) do
			if v.itemId == itemId and (tonumber(v[dataType]) or v[dataType]) == data then
				return v
			end
		end
	end
	--outputChatBox("false")
	return false
end

function hasItem(element, itemId, amount)
	if itemsTable[element] then
		for k, v in pairs(itemsTable[element]) do
			if v.itemId == itemId and (not amount or v.amount == amount) then
				return v
			end
		end
	end

	return false
end

function hasItemEx(element, dataName, dataValue, amount, data1)
    if itemsTable[element] then
        for k, v in pairs(itemsTable[element]) do
            if v[dataName] == dataValue and (not amount or v.amount >= amount) and (not data1 or (v.data1 == data1 or tonumber(v.data1) == data1)) then
                return v
            end
        end
    end

    return false
end

function hasItemAmount(element, itemId, amount)
	local count = 0
	if itemsTable[element] then
		for k, v in pairs(itemsTable[element]) do
			if v.itemId == itemId then
				count = count + v.amount
			end
		end
	end

	return count
end

function getItemSlotID(element, itemDbID)
	if itemsTable[element] then
		for k, v in pairs(itemsTable[element]) do
			if v.dbID == itemDbID then
				return v.slot
			end
		end
	end

	return false
end

function getItemsCount(element)
	local items = 0

	if itemsTable[element] then
		for k, v in pairs(itemsTable[element]) do
			items = items + 1
		end
	end

	return items
end

function getCurrentWeight(element)
	local weight = 0
	if itemsTable[element] then
		for k, v in pairs(itemsTable[element]) do
			weight = weight + (getItemWeight(v.itemId) or 0) * tonumber(v.amount)
		end
	end

	return weight
end

function getFreeSlotCount(element, itemId)
	if itemsTable[element] then
		local elementType = getElementType(element)
		local emptyslot = 0

		if elementType == "player" and itemId then
			if isKeyItem(itemId) then
				for i = defaultSettings.slotLimit, defaultSettings.slotLimit * 2 - 1 do
					if not itemsTable[element][i] then
						emptyslot = emptyslot + 1
					end
				end
			elseif isPaperItem(itemId) then
				for i = defaultSettings.slotLimit * 2, defaultSettings.slotLimit * 3 - 1 do
					if not itemsTable[element][i] then
						emptyslot = emptyslot + 1
					end
				end
			else
				for i = 0, defaultSettings.slotLimit - 1 do
					if not itemsTable[element][i] then
						emptyslot = emptyslot + 1
					end
				end
			end
		else
			for i = 0, defaultSettings.slotLimit - 1 do
				if not itemsTable[element][i] then
					emptyslot = emptyslot + 1
				end
			end
		end

		return emptyslot
	end

	return 0
end

addEvent("moveItem", true)
addEventHandler("moveItem", getRootElement(),
	function (dbID, itemId, movedSlotId, hoverSlotId, stackAmount, ownerElement, targetElement)
		if not isElement(source) or not isElement(ownerElement) or not isElement(targetElement) then
			return
		end



		dbID = tonumber(dbID)

		if not dbID then
			return
		end

		local ownerType = getElementType(ownerElement)
		local ownerId = false

		if ownerType == "player" then
			ownerId = getElementData(ownerElement, defaultSettings.characterId)
		elseif ownerType == "vehicle" then
			ownerId = getElementData(ownerElement, defaultSettings.vehicleId)
		elseif ownerType == "object" then
			ownerId = getElementData(ownerElement, defaultSettings.objectId)
		end

		if ownerElement == targetElement then
			local movedItem = itemsTable[ownerElement][movedSlotId]

			if not movedItem or dbID ~= movedItem.dbID or itemId ~= movedItem.itemId then
				iprint(client)
				return
			end

			if itemsTable[ownerElement][hoverSlotId] then
				if itemsTable[ownerElement][hoverSlotId].locked then
					outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFEz a slot zárolva van! Kérlek várj egy kicsit.", source, 255, 255, 255, true)
				else
					outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFA kiválasztott slot foglalt.", source, 255, 255, 255, true)
				end

				triggerClientEvent(source, "failedToMoveItem", source, movedSlotId, hoverSlotId, stackAmount)
				return
			end

			-- mozgatás
			if stackAmount >= movedItem.amount or stackAmount <= 0 then
				if ownerElement == source and targetElement == source then
					triggerClientEvent(source, "movedItemInInv", source, true)
				end

				itemsTable[ownerElement][hoverSlotId] = itemsTable[ownerElement][movedSlotId]
				itemsTable[ownerElement][hoverSlotId].slot = hoverSlotId
				itemsTable[ownerElement][movedSlotId] = nil

				dbExec(connection, "UPDATE items SET ownerType = ?, ownerId = ?, slot = ? WHERE dbID = ?", ownerType, ownerId, hoverSlotId, dbID)
			-- stackelés
			elseif stackAmount > 0 then
				movedItem.amount = movedItem.amount - stackAmount

				giveItem(ownerElement, itemId, stackAmount, hoverSlotId, movedItem.data1, movedItem.data2, movedItem.data3, "bottocukraszda.pw")

				dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", movedItem.amount, dbID)
				src = source
				setTimer(function()
					triggerClientEvent(src, "loadItems", src, itemsTable[ownerElement], getElementType(ownerElement), ownerElement, false)
				end, 150, 1)
			end

			return
		end

		-- átmozgatás egy másik inventoryba
		local targetType = getElementType(targetElement)
		local targetId = false

		if targetType == "player" then
			targetId = getElementData(targetElement, defaultSettings.characterId)
		elseif targetType == "vehicle" then
			targetId = getElementData(targetElement, defaultSettings.vehicleId)
		elseif targetType == "object" then
			targetId = getElementData(targetElement, defaultSettings.objectId)
		end

		if targetType == "vehicle" then
			if isVehicleLocked(targetElement) then
				outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFA kiválasztott jármű csomagtartója zárva van.", source, 255, 255, 255, true)
				triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
				return
			end
		end

		local movedItem = itemsTable[ownerElement][movedSlotId]

		if not movedItem or dbID ~= movedItem.dbID then
			triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
			return
		end

		if isElement(inventoryInUse[targetElement]) then
			outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFNem rakhatsz tárgyat az inventoryba amíg azt valaki más használja!", source, 255, 255, 255, true)
			triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
			return
		end

		if targetType == "object" then
			if storedSafes[targetId] then
				if storedSafes[targetId].ownerGroup > 0 then
					if not exports.seal_groups:isPlayerInGroup(source, storedSafes[targetId].ownerGroup) then
						outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFA kiválasztott széfhez nincs kulcsod.", source, 255, 255, 255, true)
						triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
						return
					end
				elseif not hasItemWithData(source, 154, targetId) then
					outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFA kiválasztott széfhez nincs kulcsod.", source, 255, 255, 255, true)
					triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
					return
				end
			end
		end

		if targetType ~= "player" then
			if itemId == 361 then -- Pénzkazetta
				outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFEzt az itemet csak más játékosnak adhatod át!", source, 255, 255, 255, true)
				triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
				return
			end
		end

		if not itemsTable[targetElement] then
			itemsTable[targetElement] = {}
		end

		hoverSlotId = findEmptySlot(targetElement, targetType, itemId)

		if not hoverSlotId then
			outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFNincs szabad slot a kiválasztott inventoryban!", source, 255, 255, 255, true)
			triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
			return
		end

		local statement = false

		if stackAmount >= movedItem.amount or stackAmount <= 0 then
			statement = "move"
			stackAmount = movedItem.amount
		elseif stackAmount > 0 then
			statement = "stack"
		end

		if getCurrentWeight(targetElement) + getItemWeight(itemId) * stackAmount > getWeightLimit(targetType, targetElement) then
			outputChatBox("#DC143C[SealMTA - Inventory]: #FFFFFFA kiválasztott inventory nem bírja el ezt a tárgyat!", source, 255, 255, 255, true)
			triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)
			return
		end

		if statement == "move" then
			itemsTable[targetElement][hoverSlotId] = itemsTable[ownerElement][movedSlotId]
			itemsTable[targetElement][hoverSlotId].slot = hoverSlotId
			itemsTable[ownerElement][movedSlotId] = nil

			triggerItemEvent(targetElement, "addItem", targetType, itemsTable[targetElement][hoverSlotId])
			triggerItemEvent(ownerElement, "deleteItem", ownerType, {dbID})

			dbExec(connection, "UPDATE items SET ownerType = ?, ownerId = ?, slot = ? WHERE dbID = ?", targetType, targetId, hoverSlotId, dbID)
		end

		if statement == "stack" then
			movedItem.amount = movedItem.amount - stackAmount

			giveItem(targetElement, itemId, stackAmount, hoverSlotId, movedItem.data1, movedItem.data2, movedItem.data3, "bottocukraszda.pw")
			triggerItemEvent(ownerElement, "updateAmount", ownerType, dbID, movedItem.amount)

			dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", movedItem.amount, dbID)
		end

		triggerClientEvent(source, "unLockItem", source, ownerType, movedSlotId)

		exports.seal_logs:logCommand(source, eventName, {dbID, itemId, stackAmount, ownerType, ownerId, targetType, targetId})

		local itemName = ""

		if availableItems[itemId] then
			itemName = getItemName(itemId)
			if itemsTable[targetElement] and itemsTable[targetElement][hoverSlotId] then
				if itemsTable[targetElement][hoverSlotId].nameTag then
					itemName = " (" .. itemName .. " (" .. itemsTable[targetElement][hoverSlotId].nameTag .. "))"
			
				else
					itemName = " (" .. itemName .. ")"
				end
			end
		end

		if ownerType == "player" and targetType == "player" then
			exports.seal_chat:localAction(ownerElement, "átadott egy tárgyat " .. getElementData(targetElement, "visibleName"):gsub("_", " ") .. "-nak/nek." .. itemName)
			exports.seal_anticheat:sendDiscordMessage("**" .. getElementData(ownerElement, "visibleName"):gsub("_", " ") .. "** átadott egy tárgyat **" .. getElementData(targetElement, "visibleName"):gsub("_", " ") .. "**-nak/nek **[dbId: " .. dbID .. " | stackAmount: " .. stackAmount .. " | itemId: " .. itemId .. "]**", "itemlog")

			setPedAnimation(ownerElement, "DEALER", "DEALER_DEAL", -1, false, false, false, false)
			setPedAnimation(targetElement, "DEALER", "DEALER_DEAL", -1, false, false, false, false)

			triggerEvent("processPlayerWeaponItems", ownerElement, getElementItems(ownerElement), ownerElement)
			triggerEvent("processPlayerWeaponItems", targetElement, getElementItems(targetElement), targetElement)

			return
		end

		if ownerType == "player" then
			if targetType == "vehicle" then
				triggerEvent("processPlayerWeaponItems", ownerElement, getElementItems(ownerElement), ownerElement)
				exports.seal_chat:localAction(ownerElement, "berakott egy tárgyat a jármű csomagtartójába." .. itemName)
				exports.seal_anticheat:sendDiscordMessage("**" .. getElementData(ownerElement, "visibleName"):gsub("_", " ") .. "** berakott egy tárgyat a jármű csomagtartójába. **[dbID: " .. dbID .. " | itemId: " .. itemId .. " | stackAmount: " .. stackAmount .. " | vehId: "..getElementData(targetElement, "vehicle.dbID").."]**", "itemlog")
			end

			if targetType == "object" then
				triggerEvent("processPlayerWeaponItems", ownerElement, getElementItems(ownerElement), ownerElement)
				exports.seal_chat:localAction(ownerElement, "berakott egy tárgyat a széfbe." .. itemName)
				exports.seal_anticheat:sendDiscordMessage("**" .. getElementData(ownerElement, "visibleName"):gsub("_", " ") .. "** berakott egy tárgyat a széfbe. **[dbID: " .. dbID .. " | itemId: " .. itemId .. " | stackAmount: " .. stackAmount.. "]**", "itemlog")
				
			end

			return
		end

		if ownerType == "vehicle" then
			triggerEvent("processPlayerWeaponItems", targetElement, getElementItems(targetElement), targetElement)
			exports.seal_chat:localAction(targetElement, "kivett egy tárgyat a jármű csomagtartójából." .. itemName)

			exports.seal_anticheat:sendDiscordMessage("**" .. getElementData(targetElement, "visibleName"):gsub("_", " ") .. "** kivett egy tárgyat a jármű csomagtartójából. **[dbID: " .. dbID .. " | itemId: " .. itemId .. " | stackAmount: " .. stackAmount .. " | vehId: "..getElementData(ownerElement, "vehicle.dbID").."]**", "itemlog")
			
			return
		end

		if ownerType == "object" then
			triggerEvent("processPlayerWeaponItems", targetElement, getElementItems(targetElement), targetElement)
			exports.seal_chat:localAction(targetElement, "kivett egy tárgyat a széfből." .. itemName)

			exports.seal_anticheat:sendDiscordMessage("**" .. getElementData(targetElement, "visibleName"):gsub("_", " ") .. "** kivett egy tárgyat a széfből. **[dbID: " .. dbID .. " | itemId: " .. itemId .. " | stackAmount: " .. stackAmount .. "]**", "itemlog")
			
			return
		end

		setElementData(source, "movedItemID", false)
	end)

addEvent("stackItem", true)
addEventHandler("stackItem", getRootElement(),
	function (ownerElement, movedItemId, hoverItemId, stackAmount)
		if isElement(source) then
			if itemsTable[ownerElement] then
				local ownerType = getElementType(ownerElement)

				for k, v in pairs(itemsTable[ownerElement]) do
					if v.dbID == hoverItemId then
						v.amount = v.amount + stackAmount

						triggerItemEvent(source, "updateAmount", ownerType, v.dbID, v.amount)

						dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", v.amount, v.dbID)
					end

					if v.dbID == movedItemId then
						if v.amount - stackAmount > 0 then
							v.amount = v.amount - stackAmount

							triggerItemEvent(source, "updateAmount", ownerType, v.dbID, v.amount)

							dbExec(connection, "UPDATE items SET amount = ? WHERE dbID = ?", v.amount, v.dbID)
						else
							triggerItemEvent(source, "deleteItem", ownerType, {v.dbID})

							dbExec(connection, "DELETE FROM items WHERE dbID = ?", v.dbID)

							itemsTable[ownerElement][v.slot] = nil
						end
					end
				end
			end
		end
	end)

function triggerItemEvent(element, event, ...)
	local sourcePlayer = element

	if getElementType(element) == "player" then
		triggerClientEvent(element, event, element, ...)
	else
		if isElement(inventoryInUse[element]) then
			triggerClientEvent(inventoryInUse[element], event, inventoryInUse[element], ...)
			sourcePlayer = inventoryInUse[element]
		end
	end

	if event == "addItem" or event == "deleteItem" or event == "updateAmount" then
		if isElement(sourcePlayer) and getElementType(element) == "player" then
			triggerClientEvent(sourcePlayer, "movedItemInInv", sourcePlayer, event == "updateAmount")
		end
	end
end

function hasSpaceForItem(element, itemId, amount)
	if itemsTable[element] then
		local elementType = getElementType(element)
		local emptyslot = 0

		amount = amount or 1

		if elementType == "player" and isKeyItem(itemId) then
			for i = defaultSettings.slotLimit, defaultSettings.slotLimit * 2 - 1 do
				if not itemsTable[element][i] then
					emptyslot = emptyslot + 1
				end
			end
		elseif elementType == "player" and isPaperItem(itemId) then
			for i = defaultSettings.slotLimit * 2, defaultSettings.slotLimit * 3 - 1 do
				if not itemsTable[element][i] then
					emptyslot = emptyslot + 1
				end
			end
		else
			for i = 0, defaultSettings.slotLimit - 1 do
				if not itemsTable[element][i] then
					emptyslot = emptyslot + 1
				end
			end
		end

		if emptyslot >= 1 then
			if getCurrentWeight(element) + getItemWeight(itemId) * amount <= getWeightLimit(elementType, element) then
				return true
			end

			return false, "weight"
		end

		return false, "slot"
	end

	return false
end

function findEmptySlot(element, ownerType, itemId)
	if itemsTable[element] then
		if ownerType == "player" then
			if isKeyItem(itemId) then
				return findEmptySlotOfKeys(element)
			elseif isPaperItem(itemId) then
				return findEmptySlotOfPapers(element)
			end
		end

		local slotId = false

		for i = 0, defaultSettings.slotLimit - 1 do
			if not itemsTable[element][i] then
				slotId = tonumber(i)
				break
			end
		end

		if slotId then
			if slotId <= defaultSettings.slotLimit then
				return tonumber(slotId)
			end
		end

		return false
	end

	return false
end

function findEmptySlotOfKeys(player)
	if itemsTable[player] then
		local slotId = false

		for i = defaultSettings.slotLimit, defaultSettings.slotLimit * 2 - 1 do
			if not itemsTable[player][i] then
				slotId = tonumber(i)
				break
			end
		end

		if slotId then
			if slotId <= defaultSettings.slotLimit * 2 then
				return tonumber(slotId)
			else
				return false
			end
		else
			return false
		end
	end

	return false
end

function findEmptySlotOfPapers(player)
	if itemsTable[player] then
		local slotId = false

		for i = defaultSettings.slotLimit * 2, defaultSettings.slotLimit * 3 - 1 do
			if not itemsTable[player][i] then
				slotId = tonumber(i)
				break
			end
		end

		if slotId then
			if slotId <= defaultSettings.slotLimit * 3 then
				return tonumber(slotId)
			else
				return false
			end
		else
			return false
		end
	end

	return false
end

addEvent("closeInventory", true)
addEventHandler("closeInventory", getRootElement(),
	function (element, nearby)
		if isElement(element) and client and client == source then
			inventoryInUse[element] = nil

			if getElementType(element) == "vehicle" and getVehicleType(element) == "Automobile" then
				setVehicleDoorOpenRatio(element, 1, 0, 250)
				setTimer(triggerLatentClientEvent, 250, 1, nearby, "toggleVehicleTrunk", source, "close", element)
			end
		end
	end)


	
addEvent("requestItems", true)
addEventHandler("requestItems", getRootElement(),
	function (element, ownerId, ownerType, nearbyPlayers)
		if isElement(element) and client and client == source then
			if ownerId and ownerType then
				local canOpenInv = true

				if ownerType == "vehicle" then
					if isVehicleLocked(element) then
						canOpenInv = false
					end
				elseif ownerType == "object" then
					if storedSafes[ownerId] then
						if getElementData(client, "acc.adminLevel") >= 7 and getElementData(client, "adminDuty") == 1 then
							canOpenInv = true
						elseif storedSafes[ownerId].ownerGroup > 0 then
							if not exports.seal_groups:isPlayerInGroup(source, storedSafes[ownerId].ownerGroup) then
								canOpenInv = false
							end
						elseif not hasItemWithData(source, 154, ownerId) then
							canOpenInv = false
						end
					end
				end

				if not canOpenInv then
					outputChatBox("#4adfbf[SealMTA - Inventory]: #FFFFFFA kiválasztott inventory zárva van, esetleg nincs kulcsod hozzá.", source, 255, 255, 255, true)
					return
				end

				if isElement(inventoryInUse[element]) then
					outputChatBox("#4adfbf[SealMTA - Inventory]: #FFFFFFA kiválasztott inventory már használatban van!", source, 255, 255, 255, true)
					return
				end

				inventoryInUse[element] = source
				loadItems(element)

				if ownerType == "vehicle" then
					exports.seal_chat:localAction(source, "belenézett a csomagtartóba.")

					local vehicleCount = 0
					for k, v in pairs(getElementsByType("vehicle")) do
						if getElementData(element, "vehicle.dbID") == getElementData(v, "vehicle.dbID") and not getElementData(element, "jobVehicleID") then
							vehicleCount = vehicleCount + 1
						end
					end
					if vehicleCount > 1 then
						for k, v in pairs(getElementsByType("player")) do
							if getElementData(element, "vehicle.owner") == getElementData(v, "char.ID") then
								destroyElement(element)
								kickPlayer(v, "Anticheat", "Több azonos jármű!")
								exports.seal_logs:logAnticheatHook("Több azonos jármű (csomagtartó)", vehicleCount .. " db, Serial: " .. getPlayerSerial(v))
							end
						end
						return
					end

					if getVehicleType(element) == "Automobile" then
						setVehicleDoorOpenRatio(element, 1, 1, 500)
						triggerLatentClientEvent(nearbyPlayers, "toggleVehicleTrunk", source, "open", element)
					end
				elseif ownerType == "object" then
					exports.seal_chat:localAction(source, "belenézett a széfbe.")
				end
			end
		end
	end)

addEventHandler("onPlayerVehicleEnter", root,
	function(element)
		local vehicleCount = 0
		for k, v in pairs(getElementsByType("vehicle")) do
			if getElementData(element, "vehicle.dbID") == getElementData(v, "vehicle.dbID") and not getElementData(element, "jobVehicleID") then
				vehicleCount = vehicleCount + 1
			end
		end
		if vehicleCount > 1 then
			for k, v in pairs(getElementsByType("player")) do
				if getElementData(element, "vehicle.owner") == getElementData(v, "char.ID") and getElementData(v, "loggedIn") then
					kickPlayer(v, "Anticheat", "Több azonos jármű!")
					exports.seal_logs:logAnticheatHook("Több azonos jármű (beszállás)", vehicleCount .. " db, Serial: " .. getPlayerSerial(v))
				end
			end
			return
		end
	end
)

addEvent("requestCache", true)
addEventHandler("requestCache", getRootElement(),
	function ()
		if isElement(source) then
			if client then
				if not (client == source) then
					return
				end
			end
			local characterId = getElementData(source, defaultSettings.characterId)

			if characterId then
				loadItems(source)
			end
		end
	end
)

function loadItems(element)
	if isElement(element) then
		local ownerType = getElementType(element)
		local ownerId = false

		if ownerType == "player" then
			ownerId = tonumber(getElementData(element, defaultSettings.characterId))
		elseif ownerType == "vehicle" then
			ownerId = tonumber(getElementData(element, defaultSettings.vehicleId))
		elseif ownerType == "object" then
			ownerId = tonumber(getElementData(element, defaultSettings.objectId))
		end

		if ownerId then
			itemsTable[element] = {}

			return dbQuery(
				function (query)
					local result = dbPoll(query, 0)

					if result then
						local lost, restored = 0, 0

						for k, v in pairs(result) do
							local slotId = false

							if itemsTable[element][v.slot] then
								slotId = findEmptySlot(element, ownerType, v.itemId)

								if slotId then
									dbExec(connection, "UPDATE items SET slot = ? WHERE dbID = ?", slotId, v.dbID)
									restored = restored + 1
								end

								lost = lost + 1
							else
								slotId = v.slot
							end

							addItem(element, v.dbID, slotId, v.itemId, v.amount, v.data1, v.data2, v.data3, v.nameTag, v.serial)
						end

						if lost > 0 and ownerType == "player" then
							outputChatBox("#4adfbf[SealMTA - Inventory]: #4aabd0" .. lost .. " #ffffffdarab elveszett tárggyal rendelkezel.", element, 255, 255, 255, true)

							if restored > 0 then
								outputChatBox("#4adfbf[SealMTA - Inventory]: #ffffffEbből #4aabd0" .. restored .. " #ffffffdarab lett visszaállítva.", element, 255, 255, 255, true)
							end

							if lost - restored > 0 then
								outputChatBox("#4adfbf[SealMTA - Inventory]: #ffffffNem sikerült visszaállítani #4aabd0" .. lost - restored .. " #ffffffdarab tárgyad, mert nincs szabad slot az inventorydban.", element, 255, 255, 255, true)
								outputChatBox("#4adfbf[SealMTA - Inventory]: #ffffffkövetkező bejelentkezésedkor ismét megpróbáljuk.", element, 255, 255, 255, true)
							end

							if lost == restored then
								outputChatBox("#4adfbf[SealMTA - Inventory]: #ffffffAz összes hibás tárgyadat sikeresen visszaállítottuk. Kellemes játékot kívánunk! :).", element, 255, 255, 255, true)
							end
						end
					end

					if ownerType == "player" then
						exports.seal_clothesshop:storePlayerClothes(element)
						triggerClientEvent(element, "loadItems", element, itemsTable[element], "player")
					else
						if isElement(inventoryInUse[element]) then
							triggerClientEvent(inventoryInUse[element], "loadItems", inventoryInUse[element], itemsTable[element], ownerType, element, true)
						end
					end
				end,
			connection, "SELECT * FROM items WHERE ownerType = ? AND ownerId = ?", ownerType, ownerId)
		end

		return false
	end

	return false
end

addEvent("completeJobItem", true)
addEventHandler("completeJobItem", getRootElement(),
	function(sourcePlayer, itemData)
		if client and client == source then
			exports.seal_dashboard:completeJob(sourcePlayer, itemData)
		end
	end
)

function sirenLampToServer(vehicle, state)
	if state == "create" and sirenPos[getElementModel(vehicle)] then
		if not isElement(getElementData(vehicle, "lampObject")) then
			local posX, posY, posZ, rotX, rotY, rotZ = sirenPos[getElementModel(vehicle)][1], sirenPos[getElementModel(vehicle)][2], sirenPos[getElementModel(vehicle)][3], sirenPos[getElementModel(vehicle)][4], sirenPos[getElementModel(vehicle)][5], sirenPos[getElementModel(vehicle)][6]
			local x, y, z = getElementPosition(vehicle)
			local lamp = createObject(1314,x,y,z)
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or false

			attachElements(lamp, vehicle, posX, posY, posZ, rotX, rotY, rotZ)
			setElementCollisionsEnabled(lamp, false)
			setElementData(vehicle, "lampObject", lamp)
			addVehicleSirens(vehicle, 1, 2, true, false, false, true)
			setVehicleSirens(vehicle, 1, sirenPos[getElementModel(vehicle)][1], sirenPos[getElementModel(vehicle)][2], sirenPos[getElementModel(vehicle)][3], 0, 0, 255, 255, 255) -- KÉK
			setVehicleSirensOn(vehicle, true)
			setElementData(vehicle, "civilSiren", true)

			if vehicleId then
				dbExec(connection, "UPDATE vehicles SET sirenLamp = 1 WHERE vehicleId = ?", vehicleId)
			end
		end
	elseif state == "destroy" then
		local vehicleId = getElementData(vehicle, "vehicle.dbID") or false
		if isElement(getElementData(vehicle, "lampObject")) then
			destroyElement(getElementData(vehicle, "lampObject"))
		end
		
		removeVehicleSirens(vehicle)
		setElementData(vehicle, "civilSiren", false)

		if vehicleId then
			dbExec(connection, "UPDATE vehicles SET sirenLamp = 0 WHERE vehicleId = ?", vehicleId)
		end
	end
end

function taxiLampToServer(playerSource, vehicle, state)
	if state == "create" then
		if not isElement(getElementData(vehicle, "lampObject")) then
			local x, y, z = getElementPosition(vehicle)
			local lamp = createObject(1313,x,y,z)

			local taxiPos = taxiPos
			if not taxiPos[getElementModel(vehicle)] then
				taxiPos[getElementModel(vehicle)] = sirenPos[getElementModel(vehicle)]
			end

			local posX, posY, posZ, rotX, rotY, rotZ = taxiPos[getElementModel(vehicle)][1] + 0.1, taxiPos[getElementModel(vehicle)][2], taxiPos[getElementModel(vehicle)][3] - 0.05, taxiPos[getElementModel(vehicle)][4], taxiPos[getElementModel(vehicle)][5], taxiPos[getElementModel(vehicle)][6]
				
			attachElements(lamp, vehicle, posX, posY, posZ, rotX, rotY, rotZ)
			setElementCollisionsEnabled(lamp, false)
			setElementData(vehicle, "lampObject", lamp)
			
				
			local clockState = getElementData(vehicle, "veh.TaxiClock")
				
			if clockState then
				local marker = createMarker(x, y, z, "corona", 0.6, 255, 255, 0, 80)

				attachElements(marker, lamp)
				setElementData(vehicle, "lampMarker", marker)
			end

			setElementData(vehicle, "isVehicleInObject", true)
			setElementData(playerSource, "isSirenVehicle", vehicle)
		end
	elseif state == "destroy" then
		if isElement(getElementData(vehicle, "lampObject")) then
			destroyElement(getElementData(vehicle, "lampObject"))
		end
		
		if isElement(getElementData(vehicle, "lampMarker")) then
			destroyElement(getElementData(vehicle, "lampMarker"))
		end
			
		setElementData(vehicle, "isVehicleInObject", false)
		setElementData(playerSource, "isSirenVehicle", nil)
	end
end

addEventHandler("onElementDestroy", getRootElement(),
	function()
		if getElementType(source) == "vehicle" then
			if getElementData(source, "lampObject") then
				if isElement(getElementData(source, "lampObject")) then
					destroyElement(getElementData(source, "lampObject"))
				end

				if isElement(getElementData(source, "lampMarker")) then
					destroyElement(getElementData(source, "lampMarker"))
				end
			end
		end
	end
)

setTimer(
	function()
		for k, ownerElement in pairs(getElementsByType("player")) do
			if hasItem(ownerElement, 119) then
				local moneyCasettes = getElementData(resourceRoot, "moneyCasettes") or {}

				moneyCasettes[ownerElement] = true

				if isTimer(trackingTimer[ownerElement]) then
					killTimer(trackingTimer[ownerElement])
				end

				trackingTimer[ownerElement] = setTimer(
						function()
							local moneyCasettes = getElementData(resourceRoot, "moneyCasettes") or {}

							if moneyCasettes[ownerElement] then
								moneyCasettes[ownerElement] = nil

								setElementData(ownerElement, "moneyCasettes", moneyCasettes)
							end

							trackingTimer[ownerElement] = nil
						end,
						1000 * 60 * 8, 1)

				setElementData(resourceRoot, "moneyCasettes", moneyCasettes)
			else
				local moneyCasettes = getElementData(resourceRoot, "moneyCasettes") or {}

				if moneyCasettes[ownerElement] then
					moneyCasettes[ownerElement] = nil

					setElementData(resourceRoot, "moneyCasettes", moneyCasettes)
				end

				trackingTimer[ownerElement] = nil
			end
		end
	end,
1500, 0)

addEvent("equipPortalGun", true)
addEventHandler("equipPortalGun", resourceRoot,
	function(on)
		--exports.seal_ggun:equipPortalGun(client, on)
	end
)

addEvent("updatePhoneNumber", true)
addEventHandler("updatePhoneNumber", getRootElement(),
	function (itemId, number)
		if isElement(source) and client and client == source then
			itemId = tonumber(itemId)
			number = tonumber(number)

			if itemId and number then
				local slot = getItemSlotID(source, itemId)

				if slot then
					itemsTable[source][slot].data1 = number

					dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", number, itemsTable[source][slot].dbID)

					triggerClientEvent(source, "updateData1", source, "player", itemsTable[source][slot].dbID, number)
				end
			end
		end
	end)

addEvent("openSanta", true)
addEventHandler("openSanta", resourceRoot, function(item)
	if not getElementData(client, "tryToStartSantaOpening") and not getElementData(client, "startedChestOpening") and hasItemWithData(client, 300, item.dbID, "dbID") then
		setElementData(client, "tryToStartSantaOpening", true)
		triggerEvent("takeItem", client, client, "dbID", item.dbID)
		triggerClientEvent(client, "openSanta", resourceRoot)
	end
end)

addEvent("openSanta2", true)
addEventHandler("openSanta2", resourceRoot, function(item)
	if not getElementData(client, "tryToStartSantaOpening") and not getElementData(client, "startedChestOpening") and hasItemWithData(client, 301, item.dbID, "dbID") then
		setElementData(client, "tryToStartSantaOpening", true)
		triggerEvent("takeItem", client, client, "dbID", item.dbID)
		triggerClientEvent(client, "openSanta2", resourceRoot)
	end
end)

addEvent("openSanta12", true)
addEventHandler("openSanta12", resourceRoot, function(item)
	if not getElementData(client, "tryToStartSantaOpening") and not getElementData(client, "startedChestOpening") and hasItemWithData(client, 156, item.dbID, "dbID") then
		setElementData(client, "tryToStartSantaOpening", true)
		triggerEvent("takeItem", client, client, "dbID", item.dbID)
		triggerClientEvent(client, "openSanta12", resourceRoot)
	end
end)

addEvent("openPumpkin", true)
addEventHandler("openPumpkin", resourceRoot, function(item)
	if not getElementData(client, "tryToStartSantaOpening") and not getElementData(client, "startedChestOpening") and hasItemWithData(client, 337, item.dbID, "dbID") then
		setElementData(client, "tryToStartSantaOpening", true)
		triggerEvent("takeItem", client, client, "dbID", item.dbID)
		triggerClientEvent(client, "openPumpkin", resourceRoot)
	end
end)

addEvent("openVehicleCase", true)
addEventHandler("openVehicleCase", resourceRoot, function(item)
	if not getElementData(client, "tryToStartSantaOpening") and not getElementData(client, "startedChestOpening") and hasItemWithData(client, 421, item.dbID, "dbID") then
		setElementData(client, "tryToStartSantaOpening", true)
		triggerEvent("takeItem", client, client, "dbID", item.dbID)
		triggerClientEvent(client, "openVehicleCase", resourceRoot)
	end
end)

addEvent("waitForResponse", true)
addEventHandler("waitForResponse", resourceRoot, function()
	triggerClientEvent(client, "waitForResponse", resourceRoot)
end)

addEvent("playTrashSound", true)
addEventHandler("playTrashSound", root, function()
    local posX, posY, posZ = getElementPosition(client)
    local interior = getElementInterior(client)
    local dimension = getElementDimension(client)

    triggerClientEvent("playTrashSound", resourceRoot, posX, posY, posZ, interior, dimension)
end)


addEvent("useFishingLine", true)
addEventHandler("useFishingLine", getRootElement(), function(lineDbID, rodDbID)
    local lineItemData = hasItemEx(client, "dbID", lineDbID)
    local rodItemData = hasItemEx(client, "dbID", rodDbID)

    if lineItemData and rodItemData then
		local rodItemId = rodItemData.itemId
		local lineItemId = lineItemData.itemId

        if fishingRods[rodItemId] and fishingLines[lineItemId] then
            updateItemData1(client, rodDbID, fishingLines[lineItemId])
            updateItemData2(client, rodDbID, 0)
            takeItem(client, "dbID", lineDbID, 1)
            exports.seal_chat:localAction(client, "felszerelt egy tekercs " .. string.lower(availableItems[lineItemId][1]) .. "t a horgászbotjára (" .. availableItems[rodItemId][1] .. ").")
        end
    end
end)

addEvent("useFishingFloater", true)
addEventHandler("useFishingFloater", getRootElement(), function(floaterDbID, rodDbID)
    local floaterItemData = hasItemEx(client, "dbID", floaterDbID)
    local rodItemData = hasItemEx(client, "dbID", rodDbID)

    if floaterItemData and rodItemData then
		local rodItemId = rodItemData.itemId
		local floaterItemId = floaterItemData.itemId

        if fishingRods[rodItemId] and fishingFloaters[floaterItemId] then
            updateItemData3(client, rodDbID, fishingFloaters[floaterItemId])
            takeItem(client, "dbID", floaterDbID, 1)
            exports.seal_chat:localAction(client, "felszerelt egy úszót a horgászbotjára (" .. availableItems[rodItemId][1] .. ").")
        end
    end
end)

function updateItemData1(thePlayer, itemDBID, newData1)
    if itemsTable[thePlayer] then
        local slot = getItemSlotID(thePlayer, itemDBID)

        if slot then
            itemsTable[thePlayer][slot].data1 = newData1
            dbExec(connection, "UPDATE items SET data1 = ? WHERE dbID = ?", newData1, itemsTable[thePlayer][slot].dbID)

            triggerClientEvent(thePlayer, "updateData1", thePlayer, "player", itemDBID, newData1)
        end
    end
end

function updateItemData2(thePlayer, itemDBID, newData2)
    if itemsTable[thePlayer] then
        local slot = getItemSlotID(thePlayer, itemDBID)

        if slot then
            itemsTable[thePlayer][slot].data2 = newData2
            dbExec(connection, "UPDATE items SET data2 = ? WHERE dbID = ?", newData2 or nil, itemsTable[thePlayer][slot].dbID)

            triggerClientEvent(client, "updateData2Ex", client, "player", itemDBID, newData2)
        end
    end
end

function setItemData2(thePlayer, itemDBID, newData2)
    if itemsTable[thePlayer] then
        local slot = getItemSlotID(thePlayer, itemDBID)

        if slot then
            itemsTable[thePlayer][slot].data2 = newData2
            dbExec(connection, "UPDATE items SET data2 = ? WHERE dbID = ?", newData2 or nil, itemsTable[thePlayer][slot].dbID)
        end
    end
end

function updateItemData3(thePlayer, itemDBID, newData3)
    if itemsTable[thePlayer] then
        local slot = getItemSlotID(thePlayer, itemDBID)

        if slot then
            itemsTable[thePlayer][slot].data3 = newData3
            dbExec(connection, "UPDATE items SET data3 = ? WHERE dbID = ?", newData3, itemsTable[thePlayer][slot].dbID)

            triggerClientEvent(thePlayer, "updateData3Ex", thePlayer, "player", itemDBID, newData3)
        end
    end
end

function damageFishingLine(client, rodDbID, tear)
    local rodItemData = hasItemEx(client, "dbID", rodDbID)

    if rodItemData then
        if fishingRods[rodItemData.itemId] then
            local wear = rodItemData.data2 + math.random(7, 15)

            if wear >= 100 then
                updateItemData1(client, rodDbID, 0)
                updateItemData3(client, rodDbID, 0)
                setElementData(client, "usingFishingRodLine", false)
                setElementData(client, "usingFishingRodFloat", false)
                exports.seal_fishing:removePlayerBait(client)
            elseif not tear then
                updateItemData2(client, rodDbID, wear)
            elseif tear then
                updateItemData2(client, rodDbID, wear)
                updateItemData3(client, rodDbID, 0)
                setElementData(client, "usingFishingRodFloat", false)
                exports.seal_fishing:removePlayerBait(client)
            end

            triggerClientEvent(getRootElement(), "damageFishingLineSound", client)
        end
    end
end

addEvent("damageFishingLine", true)
addEventHandler("damageFishingLine", getRootElement(), function(rodDbID, tear)
    if source == client then
        damageFishingLine(client, rodDbID, tear)
    else
        --ac ban
    end
end)