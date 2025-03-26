local screenX, screenY = guiGetScreenSize()
local pointingTargets = {}
local startedToLink = false
local linkedTargets = {}
local linked = false
local delinkStart = false

addEventHandler("onClientPlayerQuit", getRootElement(), function()
	pointingTargets[source] = nil
end)

addEventHandler("onClientPlayerStreamOut", getRootElement(), function()
	pointingTargets[source] = nil
end)

local isPointing = false
local lastPoint = 0
local lastPoint = 0
local pointingBone
local pointingKey = "x"

function getPointingKey()
	return pointingKey
end

function setPointingKey(key)
	pointingKey = key
end

addEvent("togglePointerMode", true)
addEventHandler("togglePointerMode", getRootElement(), function(state)
	if isElement(source) then
		if state then
			pointingTargets[source] = {}

			addEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessPointer, true)
			addEventHandler("onClientPreRender", getRootElement(), preRenderPointer, true)
			addEventHandler("onClientRender", getRootElement(), pedsProcessPointerEx, true)
		else
			pointingTargets[source] = nil
		end
	end
end)

addEvent("syncPointer", true)
addEventHandler("syncPointer", getRootElement(), function(bone, x, y, z)
	if pointingTargets[source] then
		pointingTargets[source][1] = bone
		pointingTargets[source][5], pointingTargets[source][6], pointingTargets[source][7] = x, y, z
	end
end)

local pointSync = false
local syncedBone, syncedTx, syncedTy, syncedTz

addEventHandler("onClientKey", getRootElement(), function(key, por)
	if key == pointingKey and not linked then
		if por and not isPedInVehicle(localPlayer) and not isChatBoxInputActive() and not isConsoleActive() then
			if getTickCount() - lastPoint > 500 then
				pointingBone = 20
				lastPoint = getTickCount()
				addEventHandler("onClientPreRender", getRootElement(), preRenderLocalPointing, true)
				isPointing = true
				local syncers = getElementsByType("player", getRootElement(), true)
				for i = #syncers, 1, -1 do
					if syncers[i] == localPlayer then
						table.remove(syncers, i)
					end
				end
				triggerServerEvent("togglePointerMode", localPlayer, syncers)
				pointSync = 0
				syncedBone, syncedTx, syncedTy, syncedTz = false, false, false
			end
		elseif isPointing then
			pointingTargets[localPlayer] = nil

			removeEventHandler("onClientPreRender", getRootElement(), preRenderLocalPointing, true)
			removeEventHandler("onClientRender", getRootElement(), renderLocalPointer, true)

			triggerServerEvent("togglePointerMode", localPlayer, false)
		end
	end
end)

function preRenderLocalPointing()
	local cursx, cursy, wx, wy, wz = getCursorPosition()
	local rightHandAllowed = getPedWeapon(localPlayer) <= 0
	local rx, ry, rz = getElementRotation(localPlayer)
	local cx, cy, cz, ctx, cty, ctz = getCameraMatrix()
	local tx, ty, tz
	local nx, ny, nz = 0, 0, 1
	if cursx then
		tx, ty, tz = wx, wy, wz
		local rd = math.rad(rz) - math.atan2(ty - cy, tx - cx)
		rd = (rd + math.pi) % (math.pi * 2) - math.pi
		if rd < 0 then
			if rightHandAllowed then
				local tmp = rd < -math.pi / 2 and 30 or 20
				if tmp ~= pointingBone and math.abs(rd + math.pi / 2) > math.pi / 6 then
					pointingBone = tmp
				end
			else
				pointingBone = rd < -math.pi / 3 and 30 or false
			end
		else
			pointingBone = false
		end
	else
		local rd = math.rad(rz) - math.atan2(cty - cy, ctx - cx)
		rd = (rd + math.pi) % (math.pi * 2) - math.pi
		if rd < 0 then
			if rightHandAllowed then
				local tmp = rd < -math.pi / 2 and 30 or 20
				if tmp ~= pointingBone and math.abs(rd + math.pi / 2) > math.pi / 6 then
					pointingBone = tmp
				end
			else
				pointingBone = rd < -math.pi / 3 and 30 or false
			end
		else
			pointingBone = false
		end
		if pointingBone then
			tx, ty, tz = getWorldFromScreenPosition(screenX * (20 < pointingBone and 0.45 or 0.55), screenY * 0.45, 100)
		end
	end
	if pointingBone then
		if not pointingTargets[localPlayer] then
			pointingTargets[localPlayer] = {}

			addEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessPointer, true)
			addEventHandler("onClientPreRender", getRootElement(), preRenderPointer, true)
			addEventHandler("onClientRender", getRootElement(), renderLocalPointer, true)
			addEventHandler("onClientRender", getRootElement(), pedsProcessPointerEx, true)
		end
		pointingTargets[localPlayer][1] = pointingBone
		if tx then
			local hit, hx, hy, hz, he, nx, ny, nz = processLineOfSight(cx, cy, cz, tx, ty, tz, true, true, true, true, true, false, false, false, localPlayer)
			if hit then
				tx, ty, tz = hx, hy, hz
			end
			pointingTargets[localPlayer][5], pointingTargets[localPlayer][6], pointingTargets[localPlayer][7] = tx, ty, tz
		end
	elseif pointingTargets[localPlayer] then
		pointingTargets[localPlayer] = nil
		removeEventHandler("onClientRender", getRootElement(), renderLocalPointer, true)
	end
	if tx then
		tx = math.floor(tx * 10 + 0.5) / 10
		ty = math.floor(ty * 10 + 0.5) / 10
		tz = math.floor(tz * 10 + 0.5) / 10
	end
	local now = getTickCount()
	if 100 < now - pointSync and (pointingBone ~= syncedBone or tx ~= syncedTx or ty ~= syncedTy or tz ~= syncedTz) then
		syncedBone, syncedTx, syncedTy, syncedTz = pointingBone, tx, ty, tz
		pointSync = now
		triggerServerEvent("syncPointer", localPlayer, pointingBone, tx, ty, tz)
	end
end

function renderLocalPointer()
	--local x, y, z = pointingTargets[localPlayer][2], pointingTargets[localPlayer][3], pointingTargets[localPlayer][4]
	--if x then
		--local x, y = getScreenFromWorldPosition(x, y, z, 32)
		--if x then
			--dxDrawImage(x - 16, y, 32, 32, ":seal_gui/" .. handIcon .. faTicks[handIcon])
			--dxDrawImage(x - 16, y, 32, 32, ":seal_gui/" .. handOutline .. faTicks[handOutline], 0, 0, 0, tocolor(0, 0, 0))
		--end
	--end
end

function preRenderPointer(delta)
	local found = false
	for client, dat in pairs(pointingTargets) do
		found = true
		for j = 2, 4 do
			if pointingTargets[client][j + 3] then
				if not pointingTargets[client][j] then
					pointingTargets[client][j] = pointingTargets[client][j + 3]
				elseif pointingTargets[client][j] > pointingTargets[client][j + 3] then
					local spd = math.max(1, pointingTargets[client][j] - pointingTargets[client][j + 3]) * 10
					pointingTargets[client][j] = pointingTargets[client][j] - spd * delta / 1000
					if pointingTargets[client][j] < pointingTargets[client][j + 3] then
						pointingTargets[client][j] = pointingTargets[client][j + 3]
					end
				elseif pointingTargets[client][j] < pointingTargets[client][j + 3] then
					local spd = math.max(1, pointingTargets[client][j + 3] - pointingTargets[client][j]) * 10
					pointingTargets[client][j] = pointingTargets[client][j] + spd * delta / 1000
					if pointingTargets[client][j] > pointingTargets[client][j + 3] then
						pointingTargets[client][j] = pointingTargets[client][j + 3]
					end
				end
			end
		end
	end
	if not found and #linkedTargets <= 0 then
		removeEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessPointer, true)
		removeEventHandler("onClientPreRender", getRootElement(), preRenderPointer, true)
		removeEventHandler("onClientRender", getRootElement(), pedsProcessPointerEx, true)
	end
end
function pedsProcessPointer()
	for client, dat in pairs(pointingTargets) do
		local baseBone, otx, oty, otz = dat[1], dat[2], dat[3], dat[4]
		if baseBone and otx and isElementOnScreen(client) then
			local m = getElementBoneMatrix(client, baseBone + 1)
			local x1, y1, z1 = getElementBonePosition(client, baseBone + 2)
			local rx, ry, rz = getElementRotation(client)
			local hit, tx, ty, tz = processLineOfSight(x1, y1, z1, otx, oty, otz, true, true, true, true, true, false, false, false, client)
			if not hit then
				tx, ty, tz = otx, oty, otz
			end
			m[4][1] = x1
			m[4][2] = y1
			m[4][3] = z1
			local x2, y2, z2 = getElementBonePosition(client, baseBone + 3)
			local x3, y3, z3 = getElementBonePosition(client, baseBone + 4)
			local x, y, z = reverseMatrix(m, tx - x1, ty - y1, tz - z1)
			local deg = math.deg(math.atan2(y, x))
			local deg2 = math.deg(math.atan2(-z, math.sqrt(x * x + y * y)))
			local l1 = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
			local l2 = getDistanceBetweenPoints3D(x2, y2, z2, x3, y3, z3)
			local l3 = math.sqrt(x * x + y * y + z * z)
			local joint2 = 180
			if l3 < l1 + l2 then
				joint2 = math.deg(math.acos((l1 * l1 + l2 * l2 - l3 * l3) / (2 * l1 * l2)))
			end
			if tonumber(deg) and tonumber(deg2) and tonumber(joint2) and deg == deg and deg2 == deg2 and joint2 == joint2 then
				setElementBoneRotation(client, baseBone + 2, 0, deg + (180 - joint2) / 2, deg2)
				setElementBoneRotation(client, baseBone + 3, 0, -(180 - joint2), 0)
				setElementBoneRotation(client, baseBone + 4, 20 < baseBone and 270 or 90, 0, 0)
			end
			updateElementRpHAnim(client)
		end
	end
	
	for i = 1, #linkedTargets do
		if linkedTargets[i] then
			local client, clientEx, clientBaseBone, clientExBaseBone = unpack(linkedTargets[i])
			local m = getElementBoneMatrix(client, clientBaseBone + 1)
			local m_2 = getElementBoneMatrix(clientEx, clientExBaseBone + 1)
			local x2, y2, z2 = getElementBonePosition(client, clientBaseBone + 3)
			local x2_2, y2_2, z2_2 = getElementBonePosition(clientEx, clientExBaseBone + 3)
			local x3, y3, z3 = getElementBonePosition(client, clientBaseBone + 4)
			local x3_2, y3_2, z3_2 = getElementBonePosition(clientEx, clientExBaseBone + 4)
			if m and m_2 then
				local x1, y1, z1 = getElementBonePosition(client, clientBaseBone + 2)
				local x1_2, y1_2, z1_2 = getElementBonePosition(clientEx, clientExBaseBone + 2)
				m[4][1] = x1
				m[4][2] = y1
				m[4][3] = z1
				m_2[4][1] = x1_2
				m_2[4][2] = y1_2
				m_2[4][3] = z1_2
				local tx, ty, tz = (x3 + x3_2) / 2, (y3 + y3_2) / 2, (z3 + z3_2) / 2
				local x, y, z = reverseMatrix(m, tx - x1, ty - y1, tz - z1)
				local x_2, y_2, z_2 = reverseMatrix(m_2, tx - x1_2, ty - y1_2, tz - z1_2)
				local deg = math.deg(math.atan2(y, x))
				local deg2 = math.deg(math.atan2(-z, math.sqrt(x * x + y * y)))
				local deg_2 = math.deg(math.atan2(y_2, x_2))
				local deg2_2 = math.deg(math.atan2(-z_2, math.sqrt(x_2 * x_2 + y_2 * y_2)))
				local l1 = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)
				local l1_2 = getDistanceBetweenPoints3D(x1_2, y1_2, z1_2, x2_2, y2_2, z2_2)
				local l2 = getDistanceBetweenPoints3D(x2, y2, z2, x3, y3, z3)
				local l2_2 = getDistanceBetweenPoints3D(x2_2, y2_2, z2_2, x3_2, y3_2, z3_2)
				local l3 = math.sqrt(x * x + y * y + z * z)
				local l3_2 = math.sqrt(x_2 * x_2 + y_2 * y_2 + z_2 * z_2)
				local joint2 = 180
				if l3 < l1 + l2 then
					joint2 = math.deg(math.acos((l1 * l1 + l2 * l2 - l3 * l3) / (2 * l1 * l2)))
				end
				local joint2_2 = 180
				if l3_2 < l1_2 + l2_2 then
					joint2_2 = math.deg(math.acos((l1_2 * l1_2 + l2_2 * l2_2 - l3_2 * l3_2) / (2 * l1_2 * l2_2)))
				end
				
				if tonumber(deg) and tonumber(deg2) and tonumber(joint2) and deg == deg and deg2 == deg2 and joint2 == joint2 then
					setElementBoneRotation(client, clientBaseBone + 2, 0, deg + (180 - joint2) / 2, deg2)
					setElementBoneRotation(client, clientBaseBone + 3, 0, -(180 - joint2), 0)
					setElementBoneRotation(client, clientBaseBone + 4, 20 < clientBaseBone and 270 or 90, 0, 0)
				end
				updateElementRpHAnim(client)
				if tonumber(deg_2) and tonumber(deg2_2) and tonumber(joint2_2) and deg_2 == deg_2 and deg2_2 == deg2_2 and joint2_2 == joint2_2 then
					setElementBoneRotation(clientEx, clientExBaseBone + 2, 0, deg_2 + (180 - joint2_2) / 2, deg2_2)
					setElementBoneRotation(clientEx, clientExBaseBone + 3, 0, -(180 - joint2_2), 0)
					setElementBoneRotation(clientEx, clientExBaseBone + 4, 20 < clientExBaseBone and 270 or 90, 0, 0)
				end
				updateElementRpHAnim(clientEx)
			elseif client == localPlayer then
				triggerServerEvent("syncLinkBreak", resourceRoot, client, clientEx)
			end

			if client == localPlayer then
				local dist = getDistanceBetweenPoints3D(x3, y3, z3, x3_2, y3_2, z3_2)
				
				if dist >= 1.5 then
					if not delinkStart then
						delinkStart = getTickCount()
					end
					if (getTickCount() - delinkStart) >= 500 then
						triggerServerEvent("syncLinkBreak", resourceRoot, client, clientEx)
						delinkStart = false
					end
				else
					delinkStart = false
				end
			end
		end
	end
end

function pedsProcessPointerEx()
	for client, dat in pairs(pointingTargets) do
		if dat and #dat > 0 and isElementOnScreen(client) then
			local baseBone = dat[1]
			local wrist = baseBone + 4
			local bx, by, bz = getPedBonePosition(client, wrist)
			
			if client ~= localPlayer then
				local clientEx, datEx = localPlayer, pointingTargets[localPlayer]
				if datEx and #datEx > 0 then
					local baseBoneEx = datEx[1] or 20
					local wristEx = baseBoneEx + 4
					local bx2, by2, bz2 = getPedBonePosition(clientEx, wristEx)
					local distance = getDistanceBetweenPoints3D(bx, by, bz, bx2, by2, bz2)

					if distance <= 0.35 and baseBoneEx ~= baseBone then
						if not startedToLink then
							startedToLink = {getTickCount(), client}
						end
					elseif startedToLink and startedToLink[2] == client then
						startedToLink = false
					end
				end
			end
		end
	end

	if startedToLink then
		local tick, client = unpack(startedToLink)

		if (getTickCount() - tick) >= 1000 then
			if pointingTargets[localPlayer] and pointingTargets[localPlayer][1] and pointingTargets[client] and pointingTargets[client][1] then
				triggerServerEvent("syncLink", resourceRoot, client, pointingTargets[localPlayer][1], pointingTargets[client][1])
			end
			startedToLink = false
		end
	end
end

addEvent("syncLink", true)
addEventHandler("syncLink", resourceRoot, function(client, clientEx, clientBaseBone, clientExBaseBone)
	table.insert(linkedTargets, {client, clientEx, clientBaseBone, clientExBaseBone})
	if client == localPlayer or clientEx == localPlayer then
		linked = true
		
		pointingTargets[localPlayer] = nil

		removeEventHandler("onClientPreRender", getRootElement(), preRenderLocalPointing, true)
		removeEventHandler("onClientRender", getRootElement(), renderLocalPointer, true)

		triggerServerEvent("togglePointerMode", localPlayer, false)
	end
end)

addEvent("syncLinkBreak", true)
addEventHandler("syncLinkBreak", resourceRoot, function(client, clientEx)
	if client == localPlayer or clientEx == localPlayer then
		linked = false
	end

	for i = 1, #linkedTargets do
		if linkedTargets[i][1] == client and linkedTargets[i][2] == clientEx then
			local x, y, z = getElementPosition(client)
			local x2, y2, z2 = getElementPosition(clientEx)
			local x3, y3, z3 = (x + x2) / 2, (y + y2) / 2, (z + z2) / 2

			local s = playSound3D("unlink.mp3", x3, y3, z3)

			table.remove(linkedTargets, i)
			break
		end
	end
end)

function reverseMatrix(m, x, y, z)
	return (-m[2][1] * m[3][2] * z + m[2][1] * m[3][3] * y - m[2][2] * m[3][3] * x + m[2][2] * m[3][1] * z + m[3][2] * m[2][3] * x - m[2][3] * m[3][1] * y) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1]), (m[1][1] * m[3][2] * z - m[1][1] * m[3][3] * y - m[1][3] * m[3][2] * x + m[1][3] * m[3][1] * y + m[3][3] * m[1][2] * x - m[1][2] * m[3][1] * z) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1]), (-m[1][1] * m[2][2] * z + m[1][1] * m[2][3] * y - m[1][3] * m[2][1] * y + m[1][3] * m[2][2] * x + m[2][1] * m[1][2] * z - m[1][2] * m[2][3] * x) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1])
end