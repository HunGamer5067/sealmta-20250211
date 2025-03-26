local flyingPlayers = {}
local flyingState = false

addCommandHandler("fly",
	function()
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local adminLevel = getElementData(localPlayer ,"acc.adminLevel") or 0
			local adminDuty = getElementData(localPlayer, "adminDuty") or 0

			if adminLevel <= 5 and adminDuty == 0 then
				outputChatBox("[SealMTA - Hiba]: #ffffffCsak admindutyban használhatod ezt a parancsot.", localPlayer, 245, 81, 81, true)
				return
			end

			--if not isPedInVehicle(localPlayer) then
				toggleFly()
			--end
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function(dataName)
		if dataName == "flyMode" then
			flyingPlayers[source] = (getElementData(source, dataName) and true) or nil
			if getElementData(source, dataName) then
				if not getPedOccupiedVehicle(source) then
					setElementCollisionsEnabled(source, false)
				else
					setElementCollisionsEnabled(getPedOccupiedVehicle(source), false)
				end
			else
				if not getPedOccupiedVehicle(source) then
					setElementCollisionsEnabled(source, true)
				else
					setElementCollisionsEnabled(getPedOccupiedVehicle(source), true)
				end
			end
		elseif dataName == "acc.adminLevel" and source == localPlayer then
			if getElementData(localPlayer, dataName) == 0 then
				if flyingState then
					toggleFly()
				end
			end
		end
	end)

function toggleFly()
	flyingState = not flyingState

	if flyingState then
		addEventHandler("onClientRender", getRootElement(), flyingRender)
		setElementData(localPlayer, "flyMode", true)
	else
		removeEventHandler("onClientRender", getRootElement(), flyingRender)
		setElementData(localPlayer, "flyMode", false)
	end
end

function getFly()
	return flyingState
end

function flyingRender()
	if isMTAWindowActive() then
		return
	end
	local veh = getPedOccupiedVehicle(localPlayer)

	if veh then
		local x, y, z = getElementPosition(veh)
		local lx, ly = x, y
		local speed = 10

		if getKeyState("lalt") or getKeyState("ralt") then
			speed = 3
		elseif getKeyState("lshift") or getKeyState("rshift") then
			speed = 50
		elseif getKeyState("mouse1") then
			speed = 200
		end

		setElementRotation(veh, 0, 0, select(3, getElementRotation(veh)))

		if getKeyState("w") then
			x, y = rotatePoint(getRotationFromCamera(0), x, y, speed)
			setElementRotation(veh, 0, 0, select(3, getElementRotation(getCamera())))
		elseif getKeyState("s") then
			x, y = rotatePoint(getRotationFromCamera(180), x, y, speed)
			setElementRotation(veh, 0, 0, select(3, getElementRotation(getCamera())) + 180)
		end

		if getKeyState("a") then
			x, y = rotatePoint(getRotationFromCamera(-90), x, y, speed)
			setElementRotation(veh, 0, 0, select(3, getElementRotation(getCamera())) + 90)
		elseif getKeyState("d") then
			x, y = rotatePoint(getRotationFromCamera(90), x, y, speed)
			setElementRotation(veh, 0, 0, select(3, getElementRotation(getCamera())) - 90)
		end

		if getKeyState("space") then
			z = z + 0.1 * speed
		elseif getKeyState("lctrl") or getKeyState("rctrl") then
			z = z - 0.1 * speed
		end

		setElementVelocity(veh, 0, 0, 0)
		setElementPosition(veh, x, y, z)
	else
		local x, y, z = getElementPosition(localPlayer)
		local lx, ly = x, y
		local speed = 10

		if getKeyState("lalt") or getKeyState("ralt") then
			speed = 3
		elseif getKeyState("lshift") or getKeyState("rshift") then
			speed = 50
		elseif getKeyState("mouse1") then
			speed = 200
		end

		if getAnalogControlState("forwards") == 1 then
			x, y = rotatePoint(getRotationFromCamera(0), x, y, speed)
		elseif getAnalogControlState("backwards") == 1 then
			x, y = rotatePoint(getRotationFromCamera(180), x, y, speed)
		end

		if getAnalogControlState("left") == 1 then
			x, y = rotatePoint(getRotationFromCamera(-90), x, y, speed)
		elseif getAnalogControlState("right") == 1 then
			x, y = rotatePoint(getRotationFromCamera(90), x, y, speed)
		end

		if getKeyState("space") then
			z = z + 0.1 * speed
		elseif getKeyState("lctrl") or getKeyState("rctrl") then
			z = z - 0.1 * speed
		end

		setElementPosition(localPlayer, x, y, z)

		if lx ~= x or ly ~= y then
			setElementRotation(localPlayer, 0, 0, -math.deg(math.atan2(y - ly, x - lx)) + 90)
		end
	end
end

function rotatePoint(angle, x, y, dist)
	angle = math.rad(angle)
	return x + math.sin(angle) * 0.1 * dist, y + math.cos(angle) * 0.1 * dist
end

function getRotationFromCamera(offset)
	local cameraX, cameraY, _, faceX, faceY = getCameraMatrix()
	local deltaX, deltaY = faceX - cameraX, faceY - cameraY
	local rotation = math.deg(math.atan(deltaY / deltaX))

	if (deltaY >= 0 and deltaX <= 0) or (deltaY <= 0 and deltaX <= 0) then
		rotation = rotation + 180
	end

	return -rotation + 90 + offset
end

local customYaw = 0
local shoulders = {22, 32}

setTimer (function ()
	customYaw = customYaw + 5
end, 10, 0)

addEventHandler("onClientPedsProcessed", getRootElement(), 
	function()
		local now = getTickCount()
		local p = now % 800 / 800
		if 0.5 < p then
		p = 1 - p
		end
		p = getEasingValue(p * 2, "InQuad")
		for i in pairs(flyingPlayers) do
			local player = i
			if isElement(player) then
				setElementBoneRotation(player, 32, 0, 0, -45 + 90 * p)
				setElementBoneRotation(player, 33, 0, 0, -20 + 40 * p)
				setElementBoneRotation(player, 34, -90, 0, -45 + 90 * p)
				setElementBoneRotation(player, 35, 0, 0, 0)
				setElementBoneRotation(player, 36, 0, 0, 0)
				setElementBoneRotation(player, 22, 0, 0, 45 - 90 * p)
				setElementBoneRotation(player, 23, 0, 0, 20 - 40 * p)
				setElementBoneRotation(player, 24, 90, 0, 45 - 90 * p)
				setElementBoneRotation(player, 25, 0, 0, 0)
				setElementBoneRotation(player, 26, 0, 0, 0)
				updateElementRpHAnim(player)
			else
				flyingPlayers[player] = nil
			end
		end
	end)