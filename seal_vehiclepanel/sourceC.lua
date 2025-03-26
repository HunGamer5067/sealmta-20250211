local streamedVehicles = {}
local theOldCar = false

--pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));end)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

local renderData = {}

addCommandHandler("oldcar",
	function ()
		outputChatBox("#4adfbf[SealMTA - Vehicle]: #ffffffElőző járműved: #4adfbf" .. (theOldCar or "-"), 0, 0, 0, true)
	end)

local engineStartTimer = false
local preEngineStart = false
local lastEngineStart = 0

local straterEffect = {}
local startVehicle = false

function toggleEngineBind(key, state)
	local clientVehicle = getPedOccupiedVehicle(localPlayer)

	if isElement(clientVehicle) then
		vehicleType = getVehicleType(clientVehicle)
		vehicleOccupant = getVehicleOccupant(clientVehicle)
	end

	if clientVehicle and vehicleType ~= "BMX" and vehicleOccupant == localPlayer then
		local model = getElementModel(clientVehicle)
		if state == "down" and exports.seal_ev:getChargingPortOffset(model) then
			triggerServerEvent("toggleEletricEngine", localPlayer, clientVehicle)
		else
			if state == "down" then
				local engineState = getVehicleEngineState(clientVehicle)

				if not engineState then
					if isTimer(startTimer) then
						killTimer(startTimer)
					end

					playSound("files/lightswitch.mp3")
					startVehicle = true
				else
					triggerServerEvent("toggleEngine", localPlayer, clientVehicle, false, true)
				end
			elseif state == "up" then
				if isTimer(startTimer) then
					killTimer(startTimer)
				end

				startVehicle = false
			end
		end
	end
end

addCommandHandler("toggleEngine", toggleEngineBind)
bindKey("J", "both", toggleEngineBind)

function secondStartButtonBind(key, state)
	if startVehicle then
		local clientVehicle = getPedOccupiedVehicle(localPlayer)
		local vehicleType = getVehicleType(clientVehicle)
		local vehicleOccupant = getVehicleOccupant(clientVehicle)

		if clientVehicle and vehicleType ~= "BMX" and vehicleOccupant == localPlayer then
			if state == "down" then
				if isTimer(startTimer) then
					killTimer(startTimer)
				end

				playSound("files/starter.mp3")

				startTimer = setTimer(
					function()
						if startVehicle then
							triggerServerEvent("toggleEngine", localPlayer, clientVehicle, true, true)
						end
					end, 1000, 1
				)
			elseif state == "up" then
				if isTimer(startTimer) then
					killTimer(startTimer)
				end

				startVehicle = false
			end
		end
	end
end
addCommandHandler("secondStartButton", secondStartButtonBind)
bindKey("space", "both", secondStartButtonBind)

addEvent("syncVehicleSound", true)
addEventHandler("syncVehicleSound", getRootElement(),
	function (typ, path)
		if isElement(source) then
			if typ == "3d" then
				local x, y, z = getElementPosition(source)
				straterEffect[source] = playSound3D(path, x, y, z)

				if isElement(straterEffect[source]) then
					setElementInterior(straterEffect[source], getElementInterior(source))
					setElementDimension(straterEffect[source], getElementDimension(source))
					attachElements(straterEffect[source], source)
				end
			else
				--straterEffect[source] = playSound(path)
			end
		end
	end)


addEvent("onVehicleLockEffect", true)
addEventHandler("onVehicleLockEffect", getRootElement(),
	function ()
		if isElement(source) then
			processLockEffect(source)
		end
	end)

function processLockEffect(vehicle)
	if isElement(vehicle) then
		if getVehicleOverrideLights(vehicle) == 0 or getVehicleOverrideLights(vehicle) == 1 then
			setVehicleOverrideLights(vehicle, 2)
		else
			setVehicleOverrideLights(vehicle, 1)
		end
		
		setTimer(
			function()
				if getVehicleOverrideLights(vehicle) == 0 or getVehicleOverrideLights(vehicle) == 1 then
					setVehicleOverrideLights(vehicle, 2)
				else
					setVehicleOverrideLights(vehicle, 1)
				end
			end,
		548.57142857143 / 3, 3)
	end
end

local lastLockTick = 0

bindKey("k", "down",
	function ()
		if getTickCount() - lastLockTick > 500 then
			local x, y, z = getElementPosition(localPlayer)
			local pedveh = getPedOccupiedVehicle(localPlayer)

			if not isElement(pedveh) then
				local lastdist = math.huge

				for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
					local tx, ty, tz = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

					if dist <= 5 and dist < lastdist then
						lastdist = dist
						pedveh = v
					end
				end
			end

			if isElement(pedveh) then
				triggerServerEvent("toggleLock", localPlayer, pedveh, getElementsByType("player", getRootElement(), true))
			end

			lastLockTick = getTickCount()
		end
	end)

local lastLightTick = 0

bindKey("l", "down",
	function ()
		if isPedInVehicle(localPlayer) then
			if getTickCount() - lastLightTick > 500 then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if getVehicleType(pedveh) ~= "BMX" and getVehicleOccupant(pedveh) == localPlayer then
					if not getElementData(pedveh, "emergencyIndicator") and not getElementData(pedveh, "leftIndicator") and not getElementData(pedveh, "rightIndicator") then
						lastLightTick = getTickCount()
						triggerServerEvent("toggleLights", localPlayer, pedveh)
					end
				end
			end
		end
	end)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(),
	function (vehicle, seat)
		setVehicleDoorOpenRatio(vehicle, 2, 0, 0)
		setVehicleDoorOpenRatio(vehicle, 3, 0, 0)
		setVehicleDoorOpenRatio(vehicle, 4, 0, 0)
		setVehicleDoorOpenRatio(vehicle, 5, 0, 0)

		if getVehicleOverrideLights(vehicle) == 0 then
			setVehicleOverrideLights(vehicle, 1)
			setElementData(vehicle, "vehicle.lights", 0)
		end

		if source == localPlayer then
			if isElement(vehicle) then
				local vehicleType = getVehicleType(vehicle)

				theOldCar = getElementData(vehicle, "vehicle.dbID")

				if vehicleType == "BMX" then
					setVehicleEngineState(vehicle, true)
				end

				if (getElementData(vehicle, "vehicle.engine") or 0) ~= 1 then
					if seat == 0 and vehicleType ~= "BMX" then
						if exports.seal_ev:getChargingPortOffset(getElementModel(vehicle)) then
							exports.seal_core:showMessageToPlayer(false, "A jármű beinditáshoz nyomd le a #4adfbf'J-t'.", "info")
						else
							exports.seal_core:showMessageToPlayer(false, "A jármű beinditáshoz tartsd lenyomva a #4adfbf'J + SPACE-t'.", "info")
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientVehicleStartEnter", getRootElement(),
	function (player, seat, door)
		if player == localPlayer then
			if getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX" or getVehicleType(source) == "Boat" then
				if isVehicleLocked(source) then
					cancelEvent()

					local playerX, playerY, playerZ = getElementPosition(localPlayer)
					local vehicleX, vehicleY, vehicleZ = getElementPosition(source)

					if getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ) <= 5 then
						exports.seal_hud:showInfobox("error", "Ez a jármű be van zárva!")
					end
				end
			end
		end
	end)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			setVehicleDoorOpenRatio(source, 2, 0, 0)
			setVehicleDoorOpenRatio(source, 3, 0, 0)
			setVehicleDoorOpenRatio(source, 4, 0, 0)
			setVehicleDoorOpenRatio(source, 5, 0, 0)
			
			for i = 0, 6 do
				setVehiclePanelState(source, i, getVehiclePanelState(source, i))
			end

			if getElementData(source, "vehicle.dbID") then
				if getElementData(source, "vehicle.engine") == 1 then
					setVehicleEngineState(source, true)
				else
					setVehicleEngineState(source, false)
				end
				
				if getElementData(source, "vehicle.lights") == 1 then
					setVehicleOverrideLights(source, 2)
				else
					setVehicleOverrideLights(source, 1)
				end
				
				if getElementData(source, "vehicle.locked") == 1 then
					setVehicleLocked(source, true)
				else
					setVehicleLocked(source, false)
				end
			end
		end
	end)

local screenX, screenY = guiGetScreenSize()

local brakePanelState = false

local brakePanelWidth = 10
local brakePanelHeight = 250

local brakePanelPosX = screenX - brakePanelWidth - 12
local brakePanelPosY = screenY / 2 - brakePanelHeight / 2

local brakeProgress = 1
local brakeLastProgress = false

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if isPedInVehicle(localPlayer) then
			if getPedOccupiedVehicleSeat(localPlayer) == 0 then
				local pedveh = getPedOccupiedVehicle(localPlayer)
				local informateAbout = false

				if getElementData(pedveh, "vehicle.handBrake") then
					informateAbout = "Amíg be van húzva a kézifék, nem indulhatsz el."
				end

				if informateAbout and not isMTAWindowActive() and not isCursorShowing() then
					local pedtask = getPedSimplestTask(localPlayer)

					if pedtask == "TASK_SIMPLE_CAR_GET_OUT" or pedtask == "TASK_SIMPLE_CAR_CLOSE_DOOR_FROM_OUTSIDE" then
						return
					end

					local boundkeys = {}

					for k, v in pairs(getBoundKeys("accelerate")) do
						if k == key then
							table.insert(boundkeys, k)
						end
					end

					for k, v in pairs(getBoundKeys("brake_reverse")) do
						if k == key then
							table.insert(boundkeys, k)
						end
					end

					for i = 1, #boundkeys do
						if boundkeys[i] == key then
							cancelEvent()

							if press then
								if (getElementData(pedveh, "vehicle.engine") or 0) == 1 then
									exports.seal_hud:showInfobox("w", informateAbout)
								end
							end

							break
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientCursorMove", getRootElement(),
	function (relX, relY, absX, absY)
		if brakePanelState then
			if not isMTAWindowActive() and getKeyState("lalt") then
				local pedveh = getPedOccupiedVehicle(localPlayer)
				local state = getElementData(pedveh, "vehicle.handBrake")

				if getElementData(pedveh, "vehicle.Frozen") then
					return
				end
				

				brakeProgress = brakeProgress - (0.5 - relY) * 5

				if brakeProgress < 0 then
					brakeProgress = 0
				elseif brakeProgress > 2 then
					brakeProgress = 2
				end

				if brakeProgress < 0.5 then
					if state then
						lastHandbrakeTick = getTickCount()
						if getVehicleType(pedveh) == "Automobile" then
							setPedControlState(localPlayer, "handbrake", false)
							triggerServerEvent("toggleHandBrake", pedveh, false, true)
						else
							triggerServerEvent("toggleHandBrake", pedveh, false)
						end
					end
				elseif brakeProgress > 1.5 then
					if not state then
						lastHandbrakeTick = getTickCount()
						if getVehicleType(pedveh) == "Automobile" then
							setPedControlState(localPlayer, "handbrake", true)
							triggerServerEvent("toggleHandBrake", pedveh, true, true)
						else
							triggerServerEvent("toggleHandBrake", pedveh, true)
						end
					end
				end
				setCursorPosition(screenX / 2, screenY / 2)
			end
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "vehicle.handBrake" then
			local pedveh = getPedOccupiedVehicle(localPlayer)

			if pedveh == source then
				if getElementData(source, "vehicle.handBrake") then
					playSound("files/handbrakeon.mp3")
				else
					playSound("files/handbrakeoff.mp3")
				end
			end
		end
	end)

local lastGear = 0
local gearIFP = engineLoadIFP("files/gear.ifp", "gear_shift")
local gearVals = {}
local nextKerregesTime = 0

addEventHandler("onClientRender", getRootElement(),
	function ()
		local pedveh = getPedOccupiedVehicle(localPlayer)

		if pedveh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			local vx, vy, vz = getElementVelocity(pedveh)
			local actualspeed = math.sqrt(vx * vx + vy * vy + vz * vz) * 180
			local vehtype = getVehicleType(pedveh)
			local pedtask = getPedSimplestTask(localPlayer)

			if getKeyState("lalt") and pedtask == "TASK_SIMPLE_CAR_DRIVE" and isControlEnabled("accelerate") and actualspeed <= 1 and not getElementData(pedveh, "vehicle.Frozen") then
				if (vehtype ~= "Automobile" and actualspeed <= 5) or vehtype == "Automobile" then
					brakePanelState = true
					showCursor(true)
					setCursorAlpha(0)
				end
			else
				brakePanelState = false
				showCursor(false)
				setCursorAlpha(255)
				brakeLastProgress = false
			end

			if brakePanelState then
				local sizeForZone = brakePanelHeight / 3

				dxDrawRectangle(brakePanelPosX, brakePanelPosY, brakePanelWidth, brakePanelHeight, tocolor(0, 0, 0, 200))

				dxDrawRectangle(brakePanelPosX + 2, brakePanelPosY + 2, brakePanelWidth - 4, sizeForZone - 4, tocolor(94, 193, 230))

				dxDrawRectangle(brakePanelPosX + 2, brakePanelPosY + 2 + brakePanelHeight - sizeForZone, brakePanelWidth - 4, sizeForZone - 4, tocolor(215, 89, 89))

				dxDrawRectangle(brakePanelPosX + 2, brakePanelPosY + 2 + sizeForZone * brakeProgress, brakePanelWidth - 4, sizeForZone - 4, tocolor(255, 255, 255, 160))
			end

			if vehtype == "Automobile" then
				local state = getElementData(pedveh, "vehicle.handBrake")

				if state then
					local vx, vy, vz = getElementVelocity(pedveh)
					local actualspeed = math.sqrt(vx * vx + vy * vy + vz * vz) * 180

					if actualspeed <= 1 then
						setElementAngularVelocity(pedveh, 0, 0, 0)
						setElementFrozen(pedveh, true)
					else
						setPedControlState(localPlayer, "handbrake", true)
					end
				end

				if not brakeLastProgress then
					if state then
						brakeLastProgress = 2
						brakeProgress = 2
					else
						brakeLastProgress = 0
						brakeProgress = 0
					end
				end

				local currGear = getVehicleCurrentGear(pedveh)
				local x, y, z = getElementPosition(pedveh)
				local health = getElementHealth(pedveh)
				
				if not exports.seal_ev:getChargingPortOffset(getElementModel(pedveh)) then
					if health <= 600 then
						if getTickCount() > nextKerregesTime then
							local vx, vy, vz = getElementVelocity(pedveh)
							local actualspeed = math.sqrt(vx * vx + vy * vy + vz * vz) * 180

							if actualspeed >= 15 then
								nextKerregesTime = getTickCount() + math.random(40000, 60000)
								triggerServerEvent("playTurboSound", localPlayer, pedveh, -math.random(2, 3), getElementsWithinRange(x, y, z, 100, "player"))
							end
						end
					end

					if currGear > lastGear then
						lastGear = currGear

						local turboLevel = getElementData(pedveh, "vehicle.tuning.Turbo") or 0

						if turboLevel >= 4 then
							triggerServerEvent("playTurboSound", localPlayer, pedveh, turboLevel, getElementsWithinRange(x, y, z, 100, "player"))
						end

						if health <= 600 then
							if math.random(10) <= 7 then
								triggerServerEvent("playTurboSound", localPlayer, pedveh, -1, getElementsWithinRange(x, y, z, 100, "player"))
							end
						end
					elseif currGear < lastGear then
						lastGear = currGear

						if health <= 600 then
							if math.random(10) <= 7 then
								triggerServerEvent("playTurboSound", localPlayer, pedveh, -1, getElementsWithinRange(x, y, z, 100, "player"))
							end
						end
					end
				end
			end
		end

		local x, y, z = getElementPosition(localPlayer)
		local vehicles = getElementsWithinRange(x, y, z, 100, "vehicle")

		for i = 1, #vehicles do
			local veh = vehicles[i]

			if isElement(veh) then
				if getVehicleType(veh) == "Automobile" then
					local currGear = getVehicleCurrentGear(veh)

					if currGear and gearVals[veh] ~= currGear then
						gearVals[veh] = currGear

						local driver = getVehicleController(veh)

						if isElement(driver) then
							local currAnim = getPedAnimation(driver)

							if not currAnim then
								setPedAnimation(driver, "gear_shift", "CAR_tune_radio", -1, false, false, true, false)
							end
						end
					end
				end
			end
		end
	end)

addEvent("playTurboSound", true)
addEventHandler("playTurboSound", getRootElement(),
	function (turboLevel)
		if isElement(source) then
			--[[
				    [273] = true,
    [612] = true,
    [208] = true,
}
			]]
			--Electricnek ne duruzsoljon
			if exports.seal_ev:getChargingPortOffset(getElementModel(source)) then
				return
			end

			local x, y, z = getElementPosition(source)
			local soundEffect = false

			--if not exports.seal_electric:checkElectricVehFromElement(source) then
				if turboLevel == 4 then
					if getElementData(source, "vehicle.customTurbo") == 0 then
						soundEffect = playSound3D("files/turbo.mp3", x, y, z)
					end
				elseif turboLevel == -1 then
					soundEffect = playSound3D("files/kerreges.mp3", x, y, z)
				elseif turboLevel == -2 then
					soundEffect = playSound3D("files/ekszij1.mp3", x, y, z)
				elseif turboLevel == -3 then
					soundEffect = playSound3D("files/ekszij2.mp3", x, y, z)
				else
					if getElementData(source, "vehicle.customTurbo") == 0 then
						soundEffect = playSound3D("files/charger.mp3", x, y, z)
					end
				end
			--end

			if isElement(soundEffect) then
				if turboLevel == 4 then
					setSoundVolume(soundEffect, 0.3)
				end

				setElementDimension(soundEffect, getElementDimension(source))
				setElementInterior(soundEffect, getElementInterior(source))
				attachElements(soundEffect, source)
			end
		end
	end)

function getPlayerToVehicleRelatedPosition()
	local lookAtVehicle = getPedTarget(localPlayer)

	if lookAtVehicle and getElementType(lookAtVehicle) == "vehicle" then   
		local vehPosX, vehPosY, vehPosZ = getElementPosition(lookAtVehicle)
		local vehRotX, vehRotY, vehRotZ = getElementRotation(lookAtVehicle)
		local pedPosX, pedPosY, pedPosZ = getElementPosition(localPlayer)
		local angle = math.deg(math.atan2(pedPosX - vehPosX, pedPosY - vehPosY)) + 180 + vehRotZ
		
		if angle < 0 then
			angle = angle + 360
		elseif angle > 360 then
			angle = angle - 360
		end
		
		return math.floor(angle) + 0.5
	else
		return false
	end
end

function getDoor(vehicle)
	if vehicle then
		-- 0 (hood), 1 (trunk), 2 (front left), 3 (front right)
		if getPlayerToVehicleRelatedPosition() >= 140 and getPlayerToVehicleRelatedPosition() <= 220 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 330 and getPlayerToVehicleRelatedPosition() <= 360 or getPlayerToVehicleRelatedPosition() >= 0 and getPlayerToVehicleRelatedPosition() <= 30 then
			return 1
		end
			
		if getPlayerToVehicleRelatedPosition() >= 65 and getPlayerToVehicleRelatedPosition() <= 120 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 240 and getPlayerToVehicleRelatedPosition() <= 295 then
			return 3
		end
	elseif vehicle then
		-- 0 (hood), 2 (front left), 3 (front right)
		if getPlayerToVehicleRelatedPosition() >= 140 and getPlayerToVehicleRelatedPosition() <= 220 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 65 and getPlayerToVehicleRelatedPosition() <= 120 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 240 and getPlayerToVehicleRelatedPosition() <= 295 then
			return 3
		end
	elseif vehicle then
		-- 0 (hood), 1 (trunk), 2 (front left), 3 (front right), 4 (rear left), 5 (rear right)
		if getPlayerToVehicleRelatedPosition() >= 140 and getPlayerToVehicleRelatedPosition() <= 220 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 330 and getPlayerToVehicleRelatedPosition() <= 360 or getPlayerToVehicleRelatedPosition() >= 0 and getPlayerToVehicleRelatedPosition() <= 30 then
			return 1
		end
			
		if getPlayerToVehicleRelatedPosition() >= 91 and getPlayerToVehicleRelatedPosition() <= 120 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 240 and getPlayerToVehicleRelatedPosition() <= 270 then
			return 3
		end
			
		if getPlayerToVehicleRelatedPosition() >= 60 and getPlayerToVehicleRelatedPosition() <= 90 then
			return 4
		end
			
		if getPlayerToVehicleRelatedPosition() >= 271 and getPlayerToVehicleRelatedPosition() <= 300 then
			return 5
		end
	elseif vehicle then
		-- 0 (hood), 2 (front left), 3 (front right), 4 (rear left at back), 5 (rear right at back)
		if getPlayerToVehicleRelatedPosition() >= 140 and getPlayerToVehicleRelatedPosition() <= 220 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 91 and getPlayerToVehicleRelatedPosition() <= 130 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 230 and getPlayerToVehicleRelatedPosition() <= 270 then
			return 3
		end
			
		if getPlayerToVehicleRelatedPosition() >= 0 and getPlayerToVehicleRelatedPosition() <= 30 then
			return 4
		end
			
		if getPlayerToVehicleRelatedPosition() >= 330 and getPlayerToVehicleRelatedPosition() <= 360 then
			return 5
		end
	elseif vehicle then
		-- 0 (hood), 2 (front left), 3 (front right)
		if getPlayerToVehicleRelatedPosition() >= 160 and getPlayerToVehicleRelatedPosition() <= 200 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 120 and getPlayerToVehicleRelatedPosition() <= 155 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 205 and getPlayerToVehicleRelatedPosition() <= 230 then
			return 3
		end
	elseif vehicle then
		-- 2 (front left), 3 (front right)       
		if getPlayerToVehicleRelatedPosition() >= 120 and getPlayerToVehicleRelatedPosition() <= 155 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 205 and getPlayerToVehicleRelatedPosition() <= 230 then
			return 3
		end
	elseif vehicle then
		-- 0 (hood), 1 (trunk), 2 (front left), 3 (front right), 4 (rear left), 5 (rear right)
		if getPlayerToVehicleRelatedPosition() >= 140 and getPlayerToVehicleRelatedPosition() <= 220 then
			return 0
		end
			
		if getPlayerToVehicleRelatedPosition() >= 330 and getPlayerToVehicleRelatedPosition() <= 360 or getPlayerToVehicleRelatedPosition() >= 0 and getPlayerToVehicleRelatedPosition() <= 30 then
			return 1
		end
			
		if getPlayerToVehicleRelatedPosition() >= 91 and getPlayerToVehicleRelatedPosition() <= 120 then
			return 2
		end
			
		if getPlayerToVehicleRelatedPosition() >= 240 and getPlayerToVehicleRelatedPosition() <= 270 then
			return 3
		end
			
		if getPlayerToVehicleRelatedPosition() >= 60 and getPlayerToVehicleRelatedPosition() <= 90 then
			return 4
		end
			
		if getPlayerToVehicleRelatedPosition() >= 271 and getPlayerToVehicleRelatedPosition() <= 300 then
			return 5
		end
	end

	return nil
end

bindKey("mouse2", "down",
	function ()
		if getPedWeapon(localPlayer) == 0 then
			if not isCursorShowing() then
				if not getPedOccupiedVehicle(localPlayer) then
					local lookAtVehicle = getPedTarget(localPlayer)

					if isElement(lookAtVehicle) then
						if getElementType(lookAtVehicle) == "vehicle" then
							local playerX, playerY, playerZ = getElementPosition(localPlayer)
							local targetX, targetY, targetZ = getElementPosition(lookAtVehicle)

							if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 5 then
								if (getElementData(lookAtVehicle, "vehicle.locked") or 0) == 0 then
									local door = getDoor(lookAtVehicle)

									if door then
										local doorname = ""

										if door == 0 then
											doorname = "motorháztető"
										elseif door == 1 then
											doorname = "csomagtartó"
										elseif door == 2 then
											doorname = "bal első ajtó"
										elseif door == 3 then
											doorname = "jobb első ajtó"
										elseif door == 4 then
											doorname = "bal hátsó ajtó"
										elseif door == 5 then
											doorname = "jobb hátsó ajtó"
										end

										triggerServerEvent("doVehicleDoorInteract", localPlayer, lookAtVehicle, door, doorname)
									end
								else
									exports.seal_core:showMessageToPlayer(false, "A jármű be van zárva!", "error")
								end
							end
						end
					end
				end
			end
		end
	end)

addEvent("playDoorEffect", true)
addEventHandler("playDoorEffect", getRootElement(),
	function (vehicle, typ)
		if isElement(vehicle) and typ then
			local soundPath = false

			if typ == "open" then
				soundPath = exports.seal_vehiclepanel:getDoorOpenSound(getElementModel(vehicle))
			elseif typ == "close" then
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
					attachElements(sound, vehicle)
				end
			end
		end
	end
)

function loadFonts()
	Rubik = exports.seal_core:loadFont("Rubik.ttf", respc(12), false, "proof")
end

loadFonts()

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		grabState = getElementData(localPlayer, "grabbedPlayer") or false
	end
)

setTimer(function()
	for k, v in pairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(v) then
			streamedVehicles[v] = v
		end
	end
end, 2500, 0)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue, newValue)
		if source == localPlayer then
			if dataName == "grabbedPlayer" then
				grabState = newValue
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		local sourceType = getElementType(source)

		if sourceType == "vehicle" then
			streamedVehicles[source] = source
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if streamedVehicles[source] then
			streamedVehicles[source] = nil
			gearVals[source] = nil
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if streamedVehicles[source] then
			streamedVehicles[source] = nil
			gearVals[source] = nil
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
	if source == localPlayer then
		if dataName == "loggedIn" and newValue then
			setTimer(function()
				for _, vehicleElement in pairs(getElementsByType("vehicle", getRootElement(), true)) do
					streamedVehicles[vehicleElement] = vehicleElement
				end
			end, 5000, 1)
		end
	end
end)

local doorNames = {"door_rr_dummy", "door_lf_dummy", "door_rf_dummy", "door_lr_dummy", "door_rr_dummy"}

addEventHandler("onClientRender", getRootElement(),
	function ()
		buttons = {}

		for k, vehicle in pairs(streamedVehicles) do
			local vehicleType = getVehicleType(vehicle)
			
			if grabState and vehicleType == "Automobile" or vehicleType == "Helicopter" then
				for i = 0, 5 do
					local doorState = getVehicleDoorOpenRatio(vehicle, i)
					
					if i == 3 or i == 4 or i == 5 then
						if doorState > 0 then
							local pedInVehicle = isPedInVehicle(localPlayer)
							local vehX, vehY, vehZ = getElementPosition(vehicle)
							local dist = getDistanceBetweenPoints3D(vehX, vehY, vehZ, getElementPosition(localPlayer))

							if dist < 5 and not pedInVehicle then
								local posX, posY = getScreenFromWorldPosition(getVehicleComponentPosition(vehicle, doorNames[i], "world"))
			
								if posX and posY then
									dxDrawRectangle(posX, posY, 25, 25, tocolor(26, 27, 31))

									if activeButton == "helpIn:" .. i then
										dxDrawImage(posX + 2.5, posY + 2.5, 20, 20, "files/support.png", 0, 0, 0, tocolor(50, 186, 157))

										local textW, textH = dxGetTextWidth("Besegítés a járműbe", 0.9, Rubik) + 10, dxGetFontHeight(0.9, Rubik) + 10
										local cursorX, cursorY = getCursorPosition()

										if cursorX and cursorY then
											cursorX = cursorX * screenX + 7
											cursorY = cursorY * screenY + 7

											dxDrawRectangle(cursorX, cursorY, textW, textH, tocolor(26, 27, 31, 190))
											dxDrawText("Besegítés a járműbe", cursorX, cursorY, cursorX + textW, cursorY + textH, tocolor(255, 255, 255), 0.9, Rubik, "center", "center")
										end
									else
										dxDrawImage(posX + 2.5, posY + 2.5, 20, 20, "files/support.png")
									end
									buttons["helpIn:" .. i] = {posX + 2.5, posY + 2.5, 20, 20, vehicle}
								end
							end
						end
					end
				end
			end
		end

		local cx, cy = getCursorPosition()

		if tonumber(cx) and tonumber(cy) then
			cx = cx * screenX
			cy = cy * screenY

			activeButton = false
			if not buttons then
				return
			end
			for k,v in pairs(buttons) do
				if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
					activeButton = k
					break
				end
			end
		else
			activeButton = false
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (key, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
		if key == "left" then
			if activeButton then
				local buttonDetalist = split(activeButton, ":")
				local buttonData = buttons[activeButton]

				if state == "down" then
					if buttonDetalist[1] == "helpIn" then
						if grabState then
							local elementType = getElementType(buttonData[5])

							if elementType == "vehicle" then
								triggerServerEvent("sitInVehicleGrabbedPlayer", localPlayer, buttonData[5], buttonDetalist[2])
							end
						else
							exports.seal_hud:showInfobox("error", "Nem viszel senkit!")
							return
						end
					end
				end
			end
		end
	end
)

--[[
addEventHandler("onClientClick", getRootElement(),
	function(sourceKey, keyState, absX, absY, worldX, worldY, worldZ, clickedElement)
		if sourceKey == "right" and keyState == "down" then
			if isElement(clickedElement) then
				if getElementType(clickedElement) == "vehicle" then
					if (getElementData(clickedElement, "jobVehicleID") or 0) > 0 then
						return
					end
					local vehX, vehY, vehZ = getElementPosition(clickedElement)
					local dist = getDistanceBetweenPoints3D(vehX, vehY, vehZ, getElementPosition(localPlayer))
					if dist < 5 and (not getPedOccupiedVehicle(localPlayer) or not getPedOccupiedVehicle(localPlayer) == clickedElement) then
						if renderData.sourceElement == clickedElement then
							renderData.posX, renderData.posY = absX, absY
						end
						
						if not renderData.sourceElement then
							showVehiclePanel()

							effectOn = true
							createElementOutlineEffect(clickedElement, true)

							renderData = {
								sourceElement = clickedElement,
								posX = absX, 
								posY = absY,
								sizeX = respc(250),
								sizeY = respc(240),
							}
						end
					end
				end
			end
		end
	end
)

function showVehiclePanel()
	currentTick = getTickCount()

	addEventHandler("onClientRender", getRootElement(), renderVehiclePanel)
	addEventHandler("onClientClick", getRootElement(), clickVehiclePanel)
end

function destroyVehiclePanel()
	removeEventHandler("onClientRender", getRootElement(), renderVehiclePanel)
	removeEventHandler("onClientClick", getRootElement(), clickVehiclePanel)

	destroyElementOutlineEffect(renderData.sourceElement)
    effectOn = false
	renderData = {}
end

local enabledButtons = 0

function loadFonts()
	Rubik = exports.seal_core:loadFont("Rubik.ttf", respc(12), false, "proof")
end

loadFonts()

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

function clickVehiclePanel(sourceKey, keyState)
	if sourceKey == "left" and keyState == "down" then
		if renderData.sourceElement and isElement(renderData.sourceElement) then
			if activeButton then
				if activeButton == "toogleVehicleLock" then
					if getTickCount() - lastLockTick > 500 then
						local x, y, z = getElementPosition(localPlayer)
						local pedveh = renderData.sourceElement
			
						if isElement(pedveh) then
							triggerServerEvent("toggleLock", localPlayer, pedveh, getElementsByType("player", getRootElement(), true))
						end
			
						lastLockTick = getTickCount()
					end
				elseif activeButton == "close" then
					destroyVehiclePanel()
				elseif activeButton == "RBS" then
					exports.seal_groupscripting:openRBSPanel(getElementModel(renderData.sourceElement))
					destroyVehiclePanel()
				elseif activeButton == "sitGrabbedPlayer" then
					if getElementData(localPlayer, "grabbedPlayer") then
						triggerServerEvent("sitInVehicleGrabbedPlayer", localPlayer, renderData.sourceElement)
						return
					else
						exports.seal_hud:showInfobox("error", "Nem viszel senkit!")
						return
					end
				elseif activeButton == "vehicleBoot" then
					elementId = tonumber(getElementData(renderData.sourceElement, "vehicle.dbID"))

					if getElementModel(renderData.sourceElement) == 448 then
						return
					end

					if getElementModel(renderData.sourceElement) == 498 then
						return
					end

					if getPedOccupiedVehicle(localPlayer) then
						exports.seal_core:showMessageToPlayer(false, "Járműben ülve nem nézhetsz bele a csomagtartóba!", "error")
						return
					end

					--[if not bootCheck(renderData.sourceElement) then
						exports.seal_hud:showInfobox("error", "Csak a jármű csomagtartójánál állva nézhetsz bele a csomagterébe!")
						return
					end]

					triggerServerEvent("requestItems", localPlayer, renderData.sourceElement, elementId, "vehicle", getElementsByType("player", root, true))
					destroyVehiclePanel()
				elseif activeButton == "charger" then
					if getElementData(renderData.sourceElement, "vehicle.chargerState") then
						local vehicleChargerState = getElementData(renderData.sourceElement, "pumpElement")

						triggerServerEvent("attachPumpToPlayer", root, localPlayer, vehicleChargerState, renderData.sourceElement)
					else
						local playerChargerState = getElementData(localPlayer, "pumpElement")

						if playerChargerState and isElement(playerChargerState) then
							triggerServerEvent("attachPumpToVehicle", root, renderData.sourceElement, playerChargerState, localPlayer)
						end
					end

					destroyVehiclePanel()
				elseif activeButton == "wheelClamp" then
					local cX, cY, cZ = getVehicleComponentPosition(renderData.sourceElement, "wheel_lf_dummy", "world")

					if getDistanceBetweenPoints3D(cX, cY, cZ, getElementPosition(localPlayer)) <= 1.5 then
						local clampData = getElementData(renderData.sourceElement, "vehicle.wheelClamp")

						triggerEvent("startWheelClampingAnimation", localPlayer, not clampData)
						setElementData(renderData.sourceElement, "vehicle.wheelClamp", not clampData)
					else
						exports.seal_core:showMessageToPlayer("Kerékbilincs", "Túl messze vagy a bal első keréktől!", "error")
					end

					destroyVehiclePanel()
				end
			end
		end
	end
end

function renderVehiclePanel()
	if renderData.sourceElement and isElement(renderData.sourceElement) then
		local camX, camY, camZ = getCameraMatrix()
		local vehX, vehY, vehZ = getElementPosition(renderData.sourceElement)

		if isLineOfSightClear(vehX, vehY, vehZ + 1, camX, camY, camZ, true, true, false, true, false, true, false, renderData.sourceElement) then
			local dist = getDistanceBetweenPoints3D(vehX, vehY, vehZ, getElementPosition(localPlayer))
			local x, y = getScreenFromWorldPosition(vehX, vehY, vehZ + 1)

			if x and y then
				if dist < 5 then
					renderData.posX = x - renderData.sizeX / 2
					renderData.posY = y - renderData.sizeY

					if renderData.posX and renderData.posY then
						buttons = {}
						renderData.sizeY = enabledButtons * respc(35) + 4 + respc(30)

						enabledButtons = 0
					
						local now = getTickCount()
						local elapsedTime = now - currentTick
						local progress = elapsedTime / 500

						alpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress, "Linear")

						renderData.sizeX = respc(250) * alpha


						dxDrawRectangle(renderData.posX, renderData.posY, renderData.sizeX, renderData.sizeY, tocolor(25,25,25, 255 * alpha))
						dxDrawRectangle(renderData.posX + 4, renderData.posY + 4, renderData.sizeX - 8, respc(30) - 4, tocolor(45, 45, 45, 180 * alpha))
						dxDrawText(exports.seal_vehiclenames:getCustomVehicleName(getElementModel(renderData.sourceElement)), renderData.posX + 4 + respc(5), renderData.posY + 4 + (respc(30) - 4) / 2, nil, nil, tocolor(200, 200, 200, 200 * alpha), 0.9, Rubik, "left", "center", false, false, false, false, true)

						if activeButton == "close" then
							exitColor = tocolor(168, 71, 78, 200 * alpha)
						else
							exitColor = tocolor(200, 200, 200, 200 * alpha)
						end

						dxDrawText("X", renderData.posX + 4 + renderData.sizeX - 4 - respc(10), renderData.posY + 4 + (respc(30) - 4) / 2, nil, nil, exitColor, 0.9, Rubik, "right", "center", false, false, false, false, true)

						buttons["close"] = {
							renderData.posX + renderData.sizeX - respc(20),
							renderData.posY,
							respc(30),
							respc(30)
						}

						startY = renderData.posY + respc(30) + 4
						
						local toogleVehicleLockColor = {94, 193, 230}

						if isVehicleLocked(renderData.sourceElement) then
							vehicleLockText = "nyitása"
						else
							vehicleLockText = "zárása"
						end

						drawButton("toogleVehicleLock", "Jármű " .. vehicleLockText, renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, toogleVehicleLockColor, false, Rubik, true, 0.8, true)
						enabledButtons = enabledButtons + 1

						startY = startY + respc(35)
						local vehicleBootColor = {94, 193, 230}

						drawButton("vehicleBoot", "Csomagtartó", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, vehicleBootColor, false, Rubik, true, 0.8)
						enabledButtons = enabledButtons + 1

						startY = startY + respc(35)
						local sitGrabbedPlayerColor = {94, 193, 230}

						drawButton("sitGrabbedPlayer", "Besegítés", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, sitGrabbedPlayerColor, false, Rubik, true, 0.8)
						enabledButtons = enabledButtons + 1

						startY = startY + respc(35)

						--[if exports.seal_groups:isPlayerHavePermission(localPlayer, "wheelClamp") then
							local wheelClampColor = {60, 60, 60, 40}

							if activeButton == "wheelClamp" then
								wheelClampColor = {94, 193, 230, 140}
							end

							local clampTextState = "felrakása"

							if getElementData(renderData.sourceElement, "vehicle.wheelClamp") then
								clampTextState = "leszedése"
							end

							drawButton("wheelClamp", "Kerékbilincs " .. clampTextState, renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, wheelClampColor, false, Rubik, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)
						end]
						
						if exports.seal_groups:isPlayerHavePermission(localPlayer, "roadBlock") and (exports.seal_groupscripting:getRBSVehicles(renderData.sourceElement) and (getElementData(renderData.sourceElement, "vehicle.group") or 0) > 0) then
							local RBSColor = {94, 193, 230, 140}

							drawButton("RBS", "Útzár (RBS)", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, RBSColor, false, Rubik, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)
						end

						--[if exports.seal_electric:checkElectricVehFromElement(renderData.sourceElement) then
							local superChargerColor = {60, 60, 60, 40}

							if activeButton == "charger" then
								superChargerColor = {94, 193, 230, 140}
							end

							local chargerText = "Töltő csatlakoztatása"

							if getElementData(renderData.sourceElement, "vehicle.chargerState") then
								chargerText = "Töltő leválasztása"
							end

							drawButton("charger", chargerText, renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, superChargerColor, false, Rubik, true, 0.8)
							enabledButtons = enabledButtons + 1

							startY = startY + respc(35)
						end]

						local infoColor = {60, 60, 60, 40}

						--[if activeButton == "info" then
							infoColor = {94, 193, 230, 140}
						end
						drawButton("info", "Információk", renderData.posX + 4, startY, renderData.sizeX - 8, respc(35) - 4, infoColor, false, Rubik, true, 0.8)
						enabledButtons = enabledButtons + 1]

						local cx, cy = getCursorPosition()

						if tonumber(cx) and tonumber(cy) then
							cx = cx * screenX
							cy = cy * screenY

							activeButton = false
							if not buttons then
								return
							end
							for k,v in pairs(buttons) do
								if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
									activeButton = k
									break
								end
							end
						else
							activeButton = false
						end
					end
				else
					destroyVehiclePanel()
				end
			end
		end
	end
end--]]


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