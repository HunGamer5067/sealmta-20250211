local screenX, screenY = guiGetScreenSize()
local destroyMarker = createMarker(2184.2644042969, -1980.9727783203, 13.5517797470095 - 1, "cylinder", 5, 51, 102, 153, 200)

local panelState = false
local panelFont = false
local activeButton = false

addEventHandler("onClientMarkerHit", destroyMarker,
	function (hitPlayer, matchingDimension)
		if hitPlayer == localPlayer and matchingDimension then
			local pedveh = getPedOccupiedVehicle(localPlayer)

			if isElement(pedveh) then
				if getVehicleController(pedveh) == localPlayer then
					panelFont = dxCreateFont(":seal_hud/files/fonts/Roboto.ttf", 13, false, "proof")
					panelState = true

					setElementFrozen(pedveh, true)
					showCursor(true)
				end
			end
		end
	end)

addEventHandler("onClientMarkerLeave", destroyMarker,
	function (leftPlayer, matchingDimension)
		if leftPlayer == localPlayer then
			if panelState then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if isElement(pedveh) then
					setElementFrozen(pedveh, false)
				end

				panelState = false
				showCursor(false)

				if isElement(panelFont) then
					destroyElement(panelFont)
				end

				panelFont = nil
			end
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if panelState then
			if activeButton then
				if button == "left" then
					if state == "up" then
						local pedveh = getPedOccupiedVehicle(localPlayer)

						if isElement(pedveh) then
							setElementFrozen(pedveh, false)

							if activeButton == "accept" then
								local vehicleId = getElementData(pedveh, "vehicle.dbID") or false
								if vehicleId then
									local ownerId = getElementData(pedveh, "vehicle.owner") or false
									if ownerId then
										local charId = getElementData(localPlayer, "char.ID") or false
										if charId then
											if tonumber(charId) == tonumber(ownerId) then
												triggerServerEvent("destroyVehicle", localPlayer, pedveh, vehicleId)
											else
												exports.seal_hud:showInfobox("e", "Más kocsiját nem zúzathatod be!")
											end
										end
									end
								end
							end
						end

						panelState = false
						showCursor(false)

						if isElement(panelFont) then
							destroyElement(panelFont)
						end

						panelFont = nil
					end
				end
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if panelState then
			local sx, sy = 300, 150
			local x = screenX / 2 - sx / 2
			local y = screenY / 2 - sy / 2
			local buttons = {}

			dxDrawRectangle(x, y, sx, sy, tocolor(25,25,25))
			
			dxDrawRectangle(x, y, sx, 35, tocolor(35,35,35, 200))
			
			dxDrawText("#4adfbfSeal#ffffffMTA", x + 10, y, 0, y + 35, tocolor(200, 200, 200, 200), 1, panelFont, "left", "center", false, false, false, true)

			dxDrawText("Biztosan beszeretnéd zuzatni ezt a járművet?", x + 10, y + 45, x + sx - 20, y + sy - 55, tocolor(200, 200, 200), 0.75, panelFont, "center", "center", false, true)

			local oneSize = (sx - 30) / 2

			buttons["accept"] = {x + 10, y + sy - 45, oneSize, 35}

			if activeButton == "accept" then
				dxDrawRectangle(x + 10, y + sy - 45, oneSize, 35, tocolor(94, 193, 230, 225))
			else
				dxDrawRectangle(x + 10, y + sy - 45, oneSize, 35, tocolor(94, 193, 230, 180))
			end

			dxDrawText("Elfogadás", x + 10, y + sy - 45, x + 10 + oneSize, y + sy - 10, tocolor(200, 200, 200, 200), 0.8, panelFont, "center", "center")

			buttons["decline"] = {x + 20 + oneSize, y + sy - 45, oneSize, 35}

			if activeButton == "decline" then
				dxDrawRectangle(x + 20 + oneSize, y + sy - 45, oneSize, 35, tocolor(215, 89, 89, 225))
			else
				dxDrawRectangle(x + 20 + oneSize, y + sy - 45, oneSize, 35, tocolor(215, 89, 89, 180))
			end

			dxDrawText("Elutasítás", x + 20 + oneSize, y + sy - 45, x + 20 + oneSize * 2, y + sy - 10, tocolor(200, 200, 200, 200), 0.8, panelFont, "center", "center")

			local cx, cy = getCursorPosition()

			activeButton = false

			if tonumber(cx) then
				cx = cx * screenX
				cy = cy * screenY

				for k, v in pairs(buttons) do
					if cx >= v[1] and cx <= v[1] + v[3] and cy >= v[2] and cy <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			end
		end
	end)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "loggedIn") then
			setTimer(triggerServerEvent, 2000, 1, "loadPlayerVehicles", localPlayer)
		end
	end)

addEventHandler("onClientElementStreamIn", getResourceRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			if getVehicleType(source) == "Helicopter" then
				setHeliBladeCollisionsEnabled(source, false)
			end
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldVal)
		if dataName == "noCollide" then
			if getElementData(source, dataName) then
				setElementCollidableWith(source, localPlayer, false)
			else
				setElementCollidableWith(source, localPlayer, true)
			end
		end
	end)

addEvent("handleParkingProcess", true)
addEventHandler("handleParkingProcess", getRootElement(),
	function (vehicle, positions)
		if isElement(vehicle) then
			if type(positions) == "table" then
				local canPark = true
				local x, y, z = getElementPosition(vehicle)
				local interior = getElementInterior(vehicle)
				local dimension = getElementDimension(vehicle)

				for k, v in pairs(positions) do
					if interior == v.interior and dimension == v.dimension then
						if getDistanceBetweenPoints3D(x, y, z, v.posX, v.posY, v.posZ) <= 5 then
							canPark = false
						end
					end
				end

				if canPark then
					triggerServerEvent("finishParkingProcess", localPlayer, vehicle)
				else
					outputChatBox("#DC143C[SealMTA]: #FFFFFFEzen a pozíción nem parkolhatod le a járművedet.", 255, 255, 255, true)
				end
			end
		end
	end)

	local tiresHeatLevels = {}
	local handleBurnout = false
	
	local currentVehicle = false
	local vehicleDriveType = "rwd"
	
	addEventHandler("onClientVehicleEnter", getRootElement(),
		function (enterPlayer, seatIndex)
			if enterPlayer == localPlayer then
				if seatIndex == 0 then
					currentVehicle = source
					vehicleDriveType = getVehicleHandling(source).driveType
	
					if not handleBurnout then
						handleBurnout = true
						addEventHandler("onClientPreRender", getRootElement(), burnoutRender)
					end
				end
			end
		end
	)
	
	addEventHandler("onClientVehicleExit", getRootElement(),
		function (exitPlayer, seatIndex)
			if exitPlayer == localPlayer then
				if seatIndex == 0 then
					currentVehicle = false
	
					if handleBurnout then
						handleBurnout = false
						removeEventHandler("onClientPreRender", getRootElement(), burnoutRender)
					end
				end
			end
		end
	)
	
	addEventHandler("onClientPlayerSpawn", localPlayer,
		function ()
			currentVehicle = false
	
			if handleBurnout then
				handleBurnout = false
				removeEventHandler("onClientPreRender", getRootElement(), burnoutRender)
			end
		end
	)
	
	addEventHandler("onClientElementDestroy", getRootElement(),
		function ()
			if source == currentVehicle then
				currentVehicle = false
	
				if handleBurnout then
					handleBurnout = false
					removeEventHandler("onClientPreRender", getRootElement(), burnoutRender)
				end
			end
		end
	)
	
	function burnoutRender(deltaTime)
		if currentVehicle and isElement(currentVehicle) then
			if getVehicleEngineState(currentVehicle) then
				if not isPedInVehicle(localPlayer) then
					currentVehicle = false
					removeEventHandler("onClientPreRender", getRootElement(), burnoutRender)
					handleBurnout = false
				end
	
				local accelerate = false
				local brake_reverse = false
				local handbrake = false
	
				for k in pairs(getBoundKeys("accelerate")) do
					if getKeyState(k) then
						accelerate = true
					end
				end
	
				if vehicleDriveType == "awd" or vehicleDriveType == "rwd" then
					for k in pairs(getBoundKeys("brake_reverse")) do
						if getKeyState(k) then
							brake_reverse = true
						end
					end
				end
	
				if vehicleDriveType == "awd" or vehicleDriveType == "fwd" then
					for k in pairs(getBoundKeys("handbrake")) do
						if getKeyState(k) then
							handbrake = true
						end
					end
				end
	
				if not tiresHeatLevels[currentVehicle] then
					tiresHeatLevels[currentVehicle] = {0, 0, 0, 0}
				end
	
				if (getVehicleSpeed(currentVehicle) or 0) < 20 then
					local handbrakeState = brake_reverse and handbrake
	
					-- Rear
					if accelerate and brake_reverse and not handbrakeState then
						tiresHeatLevels[currentVehicle][1] = tiresHeatLevels[currentVehicle][1] + deltaTime / math.random(100, 2250) * 1000
						tiresHeatLevels[currentVehicle][2] = tiresHeatLevels[currentVehicle][2] + deltaTime / math.random(100, 2250) * 1000
	
						if tiresHeatLevels[currentVehicle][1] / 10000 * 100 > 100 then
							tiresHeatLevels[currentVehicle][1] = 0
							triggerServerEvent("damageWheels", currentVehicle, 2)
							exports.seal_hud:showInfobox("e", "Túlmelegedett a gumid, és kidurrant!")
						end
	
						if tiresHeatLevels[currentVehicle][2] / 10000 * 100 > 100 then
							tiresHeatLevels[currentVehicle][2] = 0
							triggerServerEvent("damageWheels", currentVehicle, 4)
							exports.seal_hud:showInfobox("e", "Túlmelegedett a gumid, és kidurrant!")
						end
					else
						if tiresHeatLevels[currentVehicle][1] > 0 then
							tiresHeatLevels[currentVehicle][1] = tiresHeatLevels[currentVehicle][1] - deltaTime / math.random(100, 1000) * 1000
						end
	
						if tiresHeatLevels[currentVehicle][2] > 0 then
							tiresHeatLevels[currentVehicle][2] = tiresHeatLevels[currentVehicle][2] - deltaTime / math.random(100, 1000) * 1000
						end
					end
	
					-- Front
					if accelerate and handbrake and not handbrakeState then
						tiresHeatLevels[currentVehicle][3] = tiresHeatLevels[currentVehicle][3] + deltaTime / math.random(100, 2250) * 1000
						tiresHeatLevels[currentVehicle][4] = tiresHeatLevels[currentVehicle][4] + deltaTime / math.random(100, 2250) * 1000
	
						if tiresHeatLevels[currentVehicle][3] / 10000 * 100 > 100 then
							tiresHeatLevels[currentVehicle][3] = 0
							triggerServerEvent("damageWheels", currentVehicle, 1)
							exports.seal_hud:showInfobox("e", "Túlmelegedett a gumid, és kidurrant!")
						end
	
						if tiresHeatLevels[currentVehicle][4] / 10000 * 100 > 100 then
							tiresHeatLevels[currentVehicle][4] = 0
							triggerServerEvent("damageWheels", currentVehicle, 3)
							exports.seal_hud:showInfobox("e", "Túlmelegedett a gumid, és kidurrant!")
						end
					else
						if tiresHeatLevels[currentVehicle][3] > 0 then
							tiresHeatLevels[currentVehicle][3] = tiresHeatLevels[currentVehicle][3] - deltaTime / math.random(100, 1000) * 1000
						end
	
						if tiresHeatLevels[currentVehicle][4] > 0 then
							tiresHeatLevels[currentVehicle][4] = tiresHeatLevels[currentVehicle][4] - deltaTime / math.random(100, 1000) * 1000
						end
					end
				end
			end
		end
	end
	
	function getVehicleSpeed(vehicle)
		if isElement(vehicle) then
			local vx, vy, vz = getElementVelocity(vehicle)
			return (vx*vx + vy*vy + vz*vz) ^ 0.5 * 187.5
		end
		return 9999
	end
	