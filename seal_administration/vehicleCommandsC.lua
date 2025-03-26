addCommandHandler("nearbyvehicles",
	function (commandName)
		if getElementData(localPlayer, "loggedIn") then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local vehiclesTable = getElementsByType("vehicle", getRootElement(), true)
			local nearbyList = {}

			for i = 1, #vehiclesTable do
				local vehicleElement = vehiclesTable[i]

				if isElement(vehicleElement) then
					local vehicleId = getElementData(vehicleElement, "vehicle.dbID") or 0

					if vehicleId then
						local targetX, targetY, targetZ = getElementPosition(vehicleElement)

						if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 15 then
							table.insert(nearbyList, {getElementModel(vehicleElement), getVehicleName(vehicleElement), vehicleId, getVehiclePlateText(vehicleElement)})
						end
					end
				end
			end

			if #nearbyList > 0 then
				outputChatBox("#4adfbf[SealMTA]: #ffffffKözeledben lévő járművek (15 yard):", 255, 255, 255, true)

				for i, v in ipairs(nearbyList) do
					outputChatBox("    * #4adfbfTípus: #ffffff" .. v[1] .. " (" .. v[2] .. ") | #4adfbfAzonosító: #ffffff" .. (v[3] == 0 and "Nincs (ideiglenes)" or v[3]) .. " | #4adfbfRendszám: #ffffff" .. (v[4] or "Nincs"), 255, 255, 255, true)
				end
			else
				outputChatBox("#d75959[SealMTA]: #ffffffNincs egyetlen jármű sem a közeledben.", 255, 255, 255, true)
			end
		end
	end)

addCommandHandler("nearbygroupvehicles",
	function (commandName)
		if exports.seal_groups:isPlayerHavePermission(localPlayer, "impoundTowFinal") or getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local vehiclesTable = getElementsByType("vehicle", getRootElement(), true)
			local nearbyList = {}

			for i = 1, #vehiclesTable do
				local vehicleElement = vehiclesTable[i]

				if isElement(vehicleElement) then
					local vehicleId = getElementData(vehicleElement, "vehicle.dbID") or 0
					local groupId = getElementData(vehicleElement, "vehicle.group") or 0

					if vehicleId and groupId > 0 then
						local targetX, targetY, targetZ = getElementPosition(vehicleElement)

						if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) <= 15 then
							table.insert(nearbyList, {getElementModel(vehicleElement), getVehicleName(vehicleElement), vehicleId, getVehiclePlateText(vehicleElement), groupId})
						end
					end
				end
			end

			if #nearbyList > 0 then
				outputChatBox("#4adfbf[SealMTA]: #ffffffKözeledben lévő frakciójárművek (15 yard):", 255, 255, 255, true)

				for i, v in ipairs(nearbyList) do
					outputChatBox("    * #4adfbfTípus: #ffffff" .. v[1] .. " (" .. v[2] .. ") | #4adfbfAzonosító: #ffffff" .. (v[3] == 0 and "Nincs (ideiglenes)" or v[3]) .. " | #4adfbfRendszám: #ffffff" .. (v[4] or "Nincs") .. " | " .. v[5], 255, 255, 255, true)
				end
			else
				outputChatBox("#d75959[SealMTA]: #ffffffNincs egyetlen frakciójármű sem a közeledben.", 255, 255, 255, true)
			end
		end
	end)

addEventHandler("onClientPedsProcessed", getRootElement(),
    function()
        for k, v in pairs(getElementsByType("player")) do
            if isElement(v) and getElementData(v, "cipel") then
                setElementBoneRotation(v, 22, 0, -180, 90)
                setElementBoneRotation(v, 32, 0, 180, -90)

                updateElementRpHAnim(v)
            end
        end
    end, true, "high+99"
)

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end

bindKey("mouse1", "down",
	function()
		local cipel = getElementData(localPlayer, "cipel")
		if cipel and isElement(cipel) and getElementData(localPlayer, "acc.adminLevel") >= 6 then
			local x1,y1,z1 = getElementPosition(localPlayer)
			local x2,y2,z2 = getPositionFromElementOffset(cipel, 0, 3, 0)
			x2,y2,z2 = x2-x1,y2-y1,z2-z1
			local spd = 0.5/math.sqrt(x2*x2+y2*y2+z2*z2)
			x2,y2,z2 = x2*spd,y2*spd,z2*spd
			triggerServerEvent("hulk_push", resourceRoot, cipel, x2,y2,z2)
		end
	end
)


local vehicleStatsHandled = false
local RobotoFont2 = false

addCommandHandler("dl",
	function()
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			if vehicleStatsHandled then
				removeEventHandler("onClientRender", getRootElement(), renderVehicleStats)

				if isElement(RobotoFont2) then
					destroyElement(RobotoFont2)
					RobotoFont2 = nil
				end

				if isElement(RobotoFont2) then
					destroyElement(RobotoFont2)
					RobotoBolderFont = nil
				end

				vehicleStatsHandled = false
			else
				RobotoFont2 = dxCreateFont("files/Roboto.ttf", 10, false, "antialiased")

				addEventHandler("onClientRender", getRootElement(), renderVehicleStats)

				vehicleStatsHandled = true
			end
		end
	end)

function renderVehicleStats()
	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local vehicles = getElementsByType("vehicle", getRootElement(), true)

	for k = 1, #vehicles do
		v = vehicles[k]

		if isElement(v) and isElementOnScreen(v) then
			local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(v)

			if isLineOfSightClear(playerPosX, playerPosY, playerPosZ, vehiclePosX, vehiclePosY, vehiclePosZ, true, false, false, true, false, false, false, localPlayer) then
				local dist = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, vehiclePosX, vehiclePosY, vehiclePosZ)

				if dist <= 75 then
					local screenPosX, screenPosY = getScreenFromWorldPosition(vehiclePosX, vehiclePosY, vehiclePosZ)

					if screenPosX and screenPosY then
						local scaleFactor = 1 - dist / 75

						local vehicleId = getElementData(v, "vehicle.dbID") or "Ideiglenes"
						local vehicleName = getVehicleName(v)
						local vehicleModel = getElementModel(v)

						local sx = dxGetTextWidth(vehicleName .. " (" .. vehicleModel .. ")", scaleFactor, RobotoFont2) + 100 * scaleFactor
						local sy = 80 * scaleFactor

						local x = screenPosX - sx / 2
						local y = screenPosY - sy / 2

						dxDrawRectangle(x - 7, y - 7, sx + 14, sy + 14, tocolor(0, 0, 0, 150))
						dxDrawRectangle(x - 5, y - 5, sx + 10, sy + 10, tocolor(0, 0, 0, 125))

						dxDrawText("#7cc576" .. vehicleName .. " #7cc576(" .. vehicleModel .. ")", x, y, x + sx, y, tocolor(255, 255, 255), scaleFactor, RobotoFont2, "center", "top", false, false, false, true)
							
						dxDrawText("Adatbázis ID:", x, y + 25 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, RobotoFont2, "left", "top")
						dxDrawText(vehicleId, x, y + 25 * scaleFactor, x + sx, 0, tocolor(215, 89, 89), scaleFactor, RobotoFont2, "right", "top")

						dxDrawRectangle(x, y + 41.5 * scaleFactor, sx, 2, tocolor(255, 255, 255, 50))

						dxDrawText("Rendszám:", x, y + 45 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, RobotoFont2, "left", "top")
						dxDrawText(getVehiclePlateText(v), x, y + 45 * scaleFactor, x + sx, 0, tocolor(50, 179, 239), scaleFactor, RobotoFont2, "right", "top")

						dxDrawRectangle(x, y + 61.5 * scaleFactor, sx, 2, tocolor(255, 255, 255, 50))

						dxDrawText("Állapot:", x, y + 65 * scaleFactor, x + sx, 0, tocolor(255, 255, 255), scaleFactor, RobotoFont2, "left", "top")
						dxDrawText(math.floor(getElementHealth(v) / 10) .. "%", x, y + 65 * scaleFactor, x + sx, 0, tocolor(50, 179, 239), scaleFactor, RobotoFont2, "right", "top")
					end
				end
			end
		end
	end
end