local jewelryButtons = {}
local jewelrySwitchValues = {}
local jewelryPermissions = {}

local jewelryObjectBox = false
local jewelryObjectDoor = false

local jewelryCurrentState = "crowbar"

local jewelryActionCrowbar = false

local jewelryCaseObjects = {}
local jewelryEnteredPlayers = {}

local jewelryPed = false
local jewelryPedTargeted = false

local jewelryRobStarted = false
local jewelryRobTimer = false
local jewelryPoliceNotified = false
local jewelryDetectorDisabled = false
local jewelrySwitchChange = false
local jewelryLastPoliceReport = false
local jewelryPedSay = false

local alarmState = false

addEventHandler("onResourceStart", resourceRoot,
	function ()
		local radarObject = createObject(2412, 1940.25, -2124.0397949219, 12.6171875)
		setElementRotation(radarObject, 0, 0, 90)

		local radarObject = createObject(2412, 1940.25, -2121.74, 12.6171875)
		setElementRotation(radarObject, 0, 0, 90)

		jewelryColshape = createColPolygon(1940.6286621094, -2115.7585449219, 1940.3735351562, -2133.7561035156, 1921.3718261719, -2133.5551757812, 1919.3348388672, -2112.1611328125, 1939.9594726562, -2112.2504882812)
		jewelryObjectBox = createObject(jewelryModelBox, jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ, jewelryBoxRotX, jewelryBoxRotY, jewelryBoxRotZ)

		if jewelryObjectBox then
			local jewelryMatrix = getElementMatrix(jewelryObjectBox)

			if jewelryMatrix then
				local offsetX, offsetY, offsetZ = getElementOffset(jewelryMatrix, jewelryOffsetX, jewelryOffsetY, jewelryOffsetZ)

				if offsetX and offsetY and offsetZ then
					jewelryObjectDoor = createObject(jewelryModelDoor, offsetX, offsetY, offsetZ, 0, 0, 0)
				end

				if jewelryObjectBox and jewelryObjectDoor then
					setElementData(jewelryObjectBox, "isElectrical", true)
					setElementData(jewelryObjectDoor, "isElectrical", true)

					setElementCollisionsEnabled(jewelryObjectDoor, false)
				end

				for i = 1, #jewelryButtonsOffsets do
					local buttonData = jewelryButtonsOffsets[i]

					if buttonData then
						local buttonOffsetX = buttonData[1]
						local buttonOffsetY = buttonData[2]
						local buttonOffsetZ = buttonData[3]

						if buttonOffsetX and buttonOffsetY and buttonOffsetZ then
							local buttonMatrix = getElementMatrix(jewelryObjectBox)

							if buttonMatrix then
								local offsetX, offsetY, offsetZ = getElementOffset(buttonMatrix, buttonOffsetX, buttonOffsetY, buttonOffsetZ)

								if offsetX and offsetY and offsetZ then
									jewelryButtons[i] = createObject(jewelryModelButton, offsetX, offsetY, offsetZ, jewelryBoxRotX, 180, jewelryBoxRotZ)
								
									if jewelryButtons[i] then
										setElementData(jewelryButtons[i], "switchIdentity", i)
									end
								end
							end
						end
					end
				end
			end
		end

		local playerElements = getElementsByType("player")

		for i = 1, #playerElements do
			local playerElement = playerElements[i]

			if playerElement then
				local hasPermission = false

				for i = 1, #jewelryFactions do
					local factionId = jewelryFactions[i]

					if factionId then
						local isStaff = (getElementData(playerElement, "acc.adminLevel") or 0) >= 7
						local inIllegal = exports.seal_groups:isPlayerInGroup(playerElement, factionId) or false

						if inIllegal or isStaff then
							hasPermission = true
							break
						end
					end
				end

				if hasPermission then
					if not jewelryPermissions[source] then
						jewelryPermissions[playerElement] = true
					end
				end
			end
		end

		for i = 1, #jewelryCasePositions do
			local positionData = jewelryCasePositions[i]

			if positionData then
				local casePositionX = positionData[1]
				local casePositionY = positionData[2]
				local casePositionZ = positionData[3]
				local caseRotation = positionData[4] or 0

				if casePositionX and casePositionY and casePositionZ then
					local caseObject = createObject(3466, casePositionX, casePositionY, casePositionZ)

					if caseObject then
						setElementRotation(caseObject, 0, 0, caseRotation)
						setElementData(caseObject, "isJewelryCase", true)

						table.insert(jewelryCaseObjects, caseObject)
					end
				end
			end
		end

		jewelryPed = createPed(167, 1924.7586669922, -2123.9089355469, 13.6171875)

		if jewelryPed then
			setElementRotation(jewelryPed, 0, 0, 270)
			setElementFrozen(jewelryPed, true)
			setElementData(jewelryPed, "visibleName", "Pityu")
			setElementData(jewelryPed, "pedNameType", "Ékszerész")
			setElementData(jewelryPed, "invulnerable", true)
		end

		setTimer(
			function ()
				triggerClientEvent(root, "syncJewelryObjects", root, jewelryObjectBox, jewelryObjectDoor, jewelryButtons)
				triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
				triggerClientEvent(root, "syncJewelryCaseObjects", root, jewelryCaseObjects)
			end, 500, 1
		)
	end
)

addEventHandler("onColShapeHit", root, function (playerElement, matchingDimension)
	if playerElement and matchingDimension then
		if jewelryColshape == source then
			if getElementType(playerElement) == "player" then
				if not jewelryPermissions[playerElement] then
					return
				end

				local adminDuty = getElementData(playerElement, "adminDuty") or 0
				if adminDuty == 0 then
					jewelryEnteredPlayers[playerElement] = true
				end
			end
		end
	end
end)

addEventHandler("onColShapeLeave", root, function (playerElement, matchingDimension)
	if playerElement and matchingDimension then
		if jewelryColshape == source then
			if jewelryEnteredPlayers[playerElement] and jewelryPermissions[playerElement] then
				jewelryEnteredPlayers[playerElement] = nil

				if jewelryRobStarted then
					exports.seal_mdc:policeMessage("A rabló elhagyta az ékszerboltot! A pozíciója elérhető egy percig.")

					for _, player in pairs(getElementsByType("player")) do
						local officer = exports.seal_groups:isPlayerOfficer(player)

						if officer then
							triggerClientEvent(player, "syncJewelryBlip", root, playerElement)
						end
					end
				end
			end
		end
	end
end)

addEvent("tryToStartJewelryRob", true)
addEventHandler("tryToStartJewelryRob", root, function ()
	if client == source then
		local clientWeapon = getPedWeapon(source)
		local clientTarget = getPedTarget(source)

		if not jewelryPermissions[client] then
			return
		end

		if jewelryDisabledWeapons[clientWeapon] then
			return
		end

		if clientTarget == jewelryPed then
			if not jewelryRobStarted then
				jewelryRobStarted = true

				setTimer(function ()
					jewelryCurrentState = "crowbar"
					jewelryActionCrowbar = false

					jewelryCaseObjects = {}
					jewelryEnteredPlayers = {}

					jewelryPed = false
					jewelryPedTargeted = false

					jewelryRobStarted = false
					jewelryRobTimer = false
					jewelryPoliceNotified = false
					jewelryDetectorDisabled = false
					jewelryLastPoliceReport = false

					alarmState = false
					triggerClientEvent(root, "syncJewelryAlarm", root, alarmState)
				
					for _, buttonElement in pairs(jewelryButtons) do
						if isElement(buttonElement) then
							setElementRotation(buttonElement, 0, 0, 0)
						end
					end
					
					if isElement(jewelryObjectBox) then
						local jewelryMatrix = getElementMatrix(jewelryObjectBox)

						if jewelryMatrix then
							local offsetX, offsetY, offsetZ = getElementOffset(jewelryMatrix, jewelryOffsetX, jewelryOffsetY, jewelryOffsetZ)

							if isElement(jewelryObjectDoor) then
								setElementPosition(jewelryObjectDoor, offsetX, offsetY, offsetZ)
								setElementRotation(jewelryObjectDoor, 0, 0, 0)
							end
						end
					end

					if isTimer(jewelryRobTimer) then
						killTimer(jewelryRobTimer)
					end
					jewelryRobTimer = nil

					triggerClientEvent(root, "syncJewelryObjects", root, jewelryObjectBox, jewelryObjectDoor, jewelryButtons)
					triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
					triggerClientEvent(root, "syncJewelryCaseObjects", root, jewelryCaseObjects)
				end, 60000 * 30, 1)

				jewelryRobTimer = setTimer(function ()
					alarmState = true
					triggerClientEvent(root, "syncJewelryAlarm", root, alarmState)
					exports.seal_mdc:policeMessage("Az ékszerbolt rablás alatt áll! Riasztás minden egységnek.")

					setTimer(function()
						alarmState = false
						triggerClientEvent(root, "syncJewelryAlarm", root, alarmState)
					end, 60000 * 3, 1)
				end, 60000, 1)
			end

			jewelryPedTargeted = client
			triggerClientEvent(root, "syncJewelryPedFear", root, 1)
		elseif client == jewelryPedTargeted then
			jewelryPedTargeted = false
			triggerClientEvent(root, "syncJewelryPedFear", root, 0)
		end
	end
end)

addEvent("jewelryFearSuccess", true)
addEventHandler("jewelryFearSuccess", root, function ()
	if client == source then
		if not jewelryPermissions[client] then
			return
		end

		if jewelryCurrentState == "hammer" then
			return
		end
		
		jewelryCurrentState = "hammer"
		jewelryPedTargeted = false

		if not jewelryPedSay then
			exports.seal_chat:sendLocalSay(jewelryPed, "Vigyenek mindent, csak kérem ne bántsanak!")
			jewelryPedSay = true
		end

		triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
		triggerClientEvent(root, "syncJewelryFearSuccess", root, jewelryPed)
	end
end)

addEvent("jewelryFearFailed", true)
addEventHandler("jewelryFearFailed", root, function ()
	if client == source then
		if not jewelryPermissions[client] then
			return
		end

		if jewelryCurrentState == "hammer" then
			return
		end

		if not jewelryPoliceNotified then
			exports.seal_mdc:policeMessage("Az ékszerbolt rablás alatt áll! Riasztás minden egységnek.")
			triggerClientEvent(root, "syncJewelrySound", client, "alarm", 1933.1400146484, -2123.310546875, 13.6171875, true)
			jewelryPoliceNotified = true
		end

		if not jewelryPedSay then
			exports.seal_chat:sendLocalSay(jewelryPed, "Vigyenek mindent, csak kérem ne bántsanak!")
			jewelryPedSay = true
		end

		if isTimer(jewelryRobTimer) then
			killTimer(jewelryRobTimer)
		end
		
		alarmState = true
		triggerClientEvent(root, "syncJewelryAlarm", client, alarmState)

		setTimer(function()
			alarmState = false
			triggerClientEvent(root, "syncJewelryAlarm", client, alarmState)
		end, 60000 * 3, 1)

		jewelryCurrentState = "hammer"
		jewelryPedTargeted = false

		triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
		triggerClientEvent(root, "syncJewelryFearSuccess", root, jewelryPed)
	end
end)

addEventHandler("onElementDataChange", root,
	function (dataName, oldValue, newValue)
		if dataName == "loggedIn" then
			local loggedIn = getElementData(source, "loggedIn") or false

			if loggedIn then
				triggerClientEvent(source, "syncJewelryObjects", source, jewelryObjectBox, jewelryObjectDoor, jewelryButtons)
				triggerClientEvent(source, "syncJewelryState", source, jewelryCurrentState)
				triggerClientEvent(source, "syncJewelryCaseObjects", source, jewelryCaseObjects)
				triggerClientEvent(source, "syncJewelryAlarm", source, alarmState)
			end
		end

		if dataName == "acc.adminLevel" then
			local isStaff = getElementData(source, "acc.adminLevel") >= 7

			if isStaff then
				if not jewelryPermissions[source] then
					jewelryPermissions[source] = true
				end
			else
				if jewelryPermissions[source] then
					jewelryPermissions[source] = nil
				end
			end
		end

		if dataName == "player.groups" then
			local hasPermission = false

			for i = 1, #jewelryFactions do
				local factionId = jewelryFactions[i]

				if factionId then
					local isStaff = getElementData(source, "acc.adminLevel") >= 7
					local inIllegal = exports.seal_groups:isPlayerInGroup(source, factionId) or false

					if inIllegal or isStaff then
						hasPermission = true
						break
					end
				end
			end

			if hasPermission then
				if not jewelryPermissions[source] then
					jewelryPermissions[source] = true
				end
			else
				if jewelryPermissions[source] then
					jewelryPermissions[source] = nil
				end
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function ()
		if jewelryActionCrowbar == source then
			jewelryActionCrowbar = false
		end

		if jewelryActionSwitches == source then
			jewelryActionSwitches = false
		end
	end
)

addEvent("tryToStartSwitches", true)
addEventHandler("tryToStartSwitches", root,
	function (switchId)
		if not client then
			return
		end

		if not switchId then
			return
		end

		if client ~= source then
			return
		end

		if not jewelryPermissions[client] then
			return
		end

		if jewelrySwitchChange then
			return
		end

		if jewelrySwitchValues[switchId] then
			exports.seal_hud:showInfobox(client, "e", "Sikertelen megszakító lekapcsolás!")
		else
			jewelryDetectorDisabled = true
			exports.seal_hud:showInfobox(client, "s", "Sikeres megszakító lekapcsolás!")
		end

		jewelrySwitchChange = true
		jewelryCurrentState = false

		setElementRotation(jewelryButtons[switchId], jewelryBoxRotX, 0, jewelryBoxRotZ)
		triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
		triggerClientEvent(root, "startClientSound", client, "files/sounds/electric.mp3")
	end
)

addEvent("tryToStartCrowbar", true)
addEventHandler("tryToStartCrowbar", root,
	function ()
		if not client then
			return
		end

		if client ~= source then
			return
		end

		if not jewelryPermissions[client] then
			return
		end

		if jewelryActionCrowbar then
			return
		end
		jewelryActionCrowbar = client

		triggerClientEvent(client, "tryToStartCrowbarMinigame", client)
	end
)

addEvent("tryToOpenUpElectricalBox", true)
addEventHandler("tryToOpenUpElectricalBox", root,
	function ()
		if not client then
			return
		end

		if client ~= source then
			return
		end

		if not jewelryPermissions[client] then
			return
		end

		jewelryCurrentState = "switches"

		if jewelryActionCrowbar then
			jewelryActionCrowbar = false
		end

		if jewelryCurrentState then
			triggerClientEvent(root, "syncJewelryState", root, jewelryCurrentState)
		end

		local electricX, electricY, electricZ = getElementPosition(jewelryObjectDoor)
		local electricRX, electricRY, electricRZ = getElementRotation(jewelryObjectDoor)

		if electricX and electricY and electricZ then
			local randomSwitchToBeBad = math.random(5)

			for i = 1, 5 do
				jewelrySwitchValues[i] = false
			end

			if jewelrySwitchValues[randomSwitchToBeBad] then
				jewelrySwitchValues[randomSwitchToBeBad] = true
			end

			moveObject(jewelryObjectDoor, 500, electricX, electricY, electricZ, electricRX, electricRY, electricRZ + 145, "InOutQuad")
		
			triggerClientEvent(root, "startClientSound", client, "files/sounds/electricdoor.mp3")
		end
	end
)

addEvent("tryToBreakGlass", true)
addEventHandler("tryToBreakGlass", root, function (jewelryCaseObject, jewelryCase)
	if client == source then
		if not jewelryPermissions[client] then
			return
		end

		if jewelryCaseObject and jewelryCase then
			local isJewelryCase = getElementData(jewelryCaseObject, "isJewelryCase")
			local isJewelryCaseBreaked = getElementData(jewelryCaseObject, "isJewelryCaseBreaked")
			local playerX, playerY, playerZ = getElementPosition(client)
			
			if isJewelryCase and not isJewelryCaseBreaked then
				setElementData(jewelryCaseObject, "isJewelryCaseBreaked", true)
				setElementModel(jewelryCaseObject, 3464)

				exports.seal_chat:localAction(client, "kitöri egy ékszeres vitrin üvegét.")
				triggerClientEvent(root, "syncJewelrySound", client, "glassbreak", playerX, playerY, playerZ)
			end
		end
	end
end)

local jewelryItems = {203, 204}

addEvent("tryToGetJewelry", true)
addEventHandler("tryToGetJewelry", root, function (jewelryCaseObject, jewelryCase)
	if client == source then
		if jewelryCaseObject and jewelryCase then
			if not jewelryPermissions[client] then
				return
			end

			local isJewelryCase = getElementData(jewelryCaseObject, "isJewelryCase")
			local isJewelryCaseBreaked = getElementData(jewelryCaseObject, "isJewelryCaseBreaked")
			
			if isJewelryCase and isJewelryCaseBreaked then
				local isJewelryCaseLooted = getElementData(jewelryCaseObject, "isJewelryCaseLooted")

				if not isJewelryCaseLooted then
					local jewelryAmount = math.random(1, 2)
					local playerX, playerY, playerZ = getElementPosition(client)

					setElementData(jewelryCaseObject, "isJewelryCaseLooted", true)
					setPedAnimation(client, "carry", "liftup", -1, false, false, false, false)
					triggerClientEvent(root, "syncJewelrySound", client, "loot", playerX, playerY, playerZ)
					
					setTimer(function(client)
						setPedAnimation(client, false)
					end, 1500, 1, client)

					for i = 1, jewelryAmount do
						exports.seal_items:giveItem(client, jewelryItems[math.random(#jewelryItems)], 1)
					end

					exports.seal_chat:localAction(client, "kirabol egy ékszeres vitrint.")
				end
			end
		end
	end
end)