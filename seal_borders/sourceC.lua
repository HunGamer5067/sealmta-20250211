local screenW, screenH = guiGetScreenSize()

local bollards = {}
local bollardsLOD = {}
local borderColShape = {}
local borderState = {}
local borderAnimation = {}

local borderOffsetZ = 1.5
local borderOpenTime = 2000
local borderCloseTime = 1500

local borderPedSkins = {265, 266, 267, 277, 278, 288}

function rotateAround(angle, x, y, x2, y2)
	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + (x2 or 0)
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + (y2 or 0)
	return rotatedX, rotatedY
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for i = 1, #availableBorders do
			local datas = availableBorders[i]

			bollards[i] = {}
			bollardsLOD[i] = {}
			
			for k, v in ipairs(borderOffset[datas[13]]) do
				local rotatedX, rotatedY = rotateAround(datas[4], v[1], v[2])
				
				bollards[i][k] = createObject(1214, datas[1] + rotatedX, datas[2] + rotatedY, datas[3])
				bollardsLOD[i][k] = createObject(1214, datas[1] + rotatedX, datas[2] + rotatedY, datas[3], 0, 0, 0, true)
				
				setLowLODElement(bollards[i][k], bollardsLOD[i][k])
				setObjectScale(bollards[i][k], 1)
				setObjectBreakable(bollards[i][k], false)
				setElementFrozen(bollards[i][k], true)
			end
			
			local collision = createObject(datas[14], datas[1], datas[2], datas[3] + 0.5, 0, 0, datas[4] + 90)
			setElementAlpha(collision, 0)
			table.insert(bollards[i], collision)
			
			borderColShape[i] = {
				[1] = createColSphere(datas[5], datas[6], datas[7], datas[8]),
				[2] = createColSphere(datas[9], datas[10], datas[11], datas[12])
			}
			
			setElementData(borderColShape[i][1], "borderId", i)
			setElementData(borderColShape[i][2], "borderId", i)
			
			borderState[i] = getElementData(resourceRoot, "border." .. i .. ".state")
			borderAnimation[i] = 0

			local borderPed = createPed(borderPedSkins[math.random(1, #borderPedSkins)], unpack(borderPedPositions[i]))
			setElementFrozen(borderPed, true)
			setElementData(borderPed, "visibleName", "Határőr", false)
			setElementData(borderPed, "invulnerable", true, false)
		end
	end)

addEventHandler("onClientElementDataChange", getResourceRootElement(),
	function (dataName, oldValue)
		if string.find(dataName, "border.") then
			local borderId = tonumber(gettok(dataName, 2, "."))

			if borderId then
				if availableBorders[borderId] then
					local dataType = gettok(dataName, 3, ".")

					if dataType == "state" then
						borderState[borderId] = getElementData(source, dataName)
						borderAnimation[borderId] = getTickCount()
					elseif dataType == "mode" then
						local dataValue = getElementData(source, dataName) or 1

						if dataValue == 1 or dataValue == 3 then
							borderState[borderId] = false
						elseif dataValue == 2 then
							borderState[borderId] = true
						end
						
						borderAnimation[borderId] = getTickCount()
					end
				end
			end
		end
	end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		local now = getTickCount()

		for k, v in pairs(borderAnimation) do
			if now <= v + borderOpenTime then
				local z = 0

				if borderState[k] then
					z = interpolateBetween(0, 0, 0, borderOffsetZ, 0, 0, (now - v) / borderOpenTime, "InQuad")
				else
					z = interpolateBetween(borderOffsetZ, 0, 0, 0, 0, 0, (now - v) / borderCloseTime, "InQuad")
				end

				for k2, v2 in pairs(bollards[k]) do
					local x, y = getElementPosition(v2)

					if k2 < #bollards[k] then
						setElementPosition(v2, x, y, availableBorders[k][3] - z)
					else
						setElementPosition(v2, x, y, availableBorders[k][3] - z + 0.5)
					end
				end
			end
		end
	end)

function isOfficer(player)
	return exports.seal_groups:isPlayerInGroup(player, 1) or exports.seal_groups:isPlayerInGroup(player, 2) or exports.seal_groups:isPlayerInGroup(player, 3) or exports.seal_groups:isPlayerInGroup(player, 4) or exports.seal_groups:isPlayerInGroup(player, 26)
end

function rgbToHex(r, g, b)
	return string.format("#%.2X%.2X%.2X", r, g, b)
end

addCommandHandler("hatar",
	function (commandName, mode)
		if isOfficer(localPlayer) then
			mode = tonumber(mode)

			if not (mode and mode >= 1 and mode <= 3) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Mód (1/2/3)]", 255, 255, 255, true)
				outputChatBox("#4adfbf[Módok]: #ffffffAutomatikus(1), Nyitva(2), Zárva(3)", 255, 255, 255, true)
			else
				local borderId = false

				for k, v in pairs(borderColShape) do
					if isElementWithinColShape(localPlayer, v[1]) then
						borderId = getElementData(v[1], "borderId")
						break
					elseif isElementWithinColShape(localPlayer, v[2]) then
						borderId = getElementData(v[2], "borderId")
						break
					end
				end

				if borderId then
					setElementData(resourceRoot, "border." .. borderId .. ".mode", mode)

					if mode == 2 then
						setElementData(resourceRoot, "border." .. borderId .. ".state", true)
					elseif mode == 1 or mode == 3 then
						setElementData(resourceRoot, "border." .. borderId .. ".state", false)
					end

					triggerServerEvent("warnAboutBorderSet", localPlayer, getElementData(localPlayer, "visibleName"), borderId, mode)
				else
					outputChatBox("#4adfbf[Határ]: #ffffffCsak a határ közelében használhatod ezt a parancsot! (ColShape)", 255, 255, 255, true)
				end
			end
		end
	end)

addEvent("warnAboutBorderSet", true)
addEventHandler("warnAboutBorderSet", getRootElement(),
	function (playerName, borderId, set)
		if isOfficer(localPlayer) or getElementData(localPlayer, "acc.adminLevel") >= 1 then
			if set == 2 or set == 3 then
				local state = "nyitva"

				if set == 3 then
					state = "zárva"
				end

				outputChatBox("#4adfbf[SealMTA - Határ]: #ffffff" .. playerName:gsub("_", " ") .. " átállított egy határt manuális nyitásra. (#" .. borderId .. " - " .. state .. ")", 255, 255, 255, true)
			elseif set == 1 then
				outputChatBox("#4adfbf[SealMTA - Határ]: #ffffff" .. playerName:gsub("_", " ") .. " átállított egy határt automatikus nyitásra. (#" .. borderId .. ")", 255, 255, 255, true)
			end
		end
	end)

local borderWarns = true

addCommandHandler("toghatar",
	function ()
		if borderWarns then
			outputChatBox("#4adfbf[SealMTA - Határ]: #ffffffSikeresen kikapcsoltad az határ értesítéseket!", 255, 255, 255, true)
			borderWarns = false
		else
			outputChatBox("#4adfbf[SealMTA - Határ]: #ffffffSikeresen bekapcsoltad az határ értesítéseket!", 255, 255, 255, true)
			borderWarns = true
		end
	end)

addEvent("warnAboutBorderCross", true)
addEventHandler("warnAboutBorderCross", getRootElement(),
	function (vehicle)
		if isElement(vehicle) and isOfficer(localPlayer) and borderWarns then
			local plateText = getVehiclePlateText(vehicle)

			if plateText then
				local plateParts = split(plateText, "-")
				
				plateText = {}

				for i = 1, #plateParts do
					if utf8.len(plateParts[i]) >= 1 then
						table.insert(plateText, plateParts[i])
					end
				end
				local r1, g1, b1, r2, g2, b2 = getVehicleColor(vehicle, true)
				local vehicleElement = getPedOccupiedVehicle(source)

				outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Átlépte egy jármű a határt!", 255, 255, 255, true)
				outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Rendszáma: #4adfbf" .. table.concat(plateText, "-"), 255, 255, 255, true)
				outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Típusa: #4adfbf" .. exports.seal_vehiclenames:getCustomVehicleName(getElementModel(vehicle)) .. "#FFFFFF Színek: " .. rgbToHex(r1, g1, b1) .. "szín [1] " .. rgbToHex(r2, g2, b2) .. "szín [2]", 255, 255, 255, true)
				outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Pozició: #4adfbf" ..getZoneName(getElementPosition(source)), 255,255,255, true) 


				local occupants = getVehicleOccupants(vehicleElement) or {}
				for seat, occupant in pairs(occupants) do 
					if (occupant and getElementType(occupant) == "player") then 
						if seat == 0 then
							outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Sofőr: #4adfbf" .. getElementData(occupant, "char.Name"):gsub("_", " ") or "Ismeretlen" , 255, 255, 255, true)
						else 
							outputChatBox("#4adfbf[SealMTA - Határ]:#ffffff Utas: #4adfbf" .. getElementData(occupant, "char.Name"):gsub("_", " ") or "Ismeretlen" , 255, 255, 255, true)
						end  
						--if not getElementData(occupant, "player.seatBelt") then 
						--	outputChatBox("#4adfbf[SealMTA - Határ]: #4adfbf" .. getElementData(occupant, "char.Name") .. "#ffffff öve nem volt bekötve!", 255,255,255, true)
						--end  
				end
			end
		end
	end
end)

--Körözést megírni!!!
--Öv-utasok stb! kész!

local responsiveMultipler = 1


addEventHandler("onClientResourceStart", getRootElement(),
	function (startedres)
		if getResourceName(startedres) == "seal_hud" then
			responsiveMultipler = exports.seal_hud:getResponsiveMultipler()
		else
			if source == getResourceRootElement() then
				local seal_hud = getResourceFromName("seal_hud")

				if seal_hud then
					if getResourceState(seal_hud) == "running" then
						responsiveMultipler = exports.seal_hud:getResponsiveMultipler()
					end
				end
			end
		end
	end)

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local currentBorderId = false
local currentBorderColShapeId = false

local panelBg = false
function createGui()

	if exports.seal_gui:isGuiElementValid(panelBg) then
		exports.seal_gui:deleteGuiElement(panelBg)
	end

	local panelW, panelH = 400, 200
	local panelPosX, panelPosY = (screenW - panelW) / 2, (screenH - panelH) / 2

	panelBg = exports.seal_gui:createGuiElement("window", panelPosX, panelPosY, panelW, panelH)
	exports.seal_gui:setWindowTitle(panelBg, "15/BebasNeueRegular.otf", "SealMTA - Határ")
	exports.seal_gui:setWindowCloseButton(panelBg, "closeTheBorderButton")

    local label = exports.seal_gui:createGuiElement("label", 0, -50, panelW, panelH, panelBg)
    exports.seal_gui:setLabelText(label, "(Ha átszeretnél kelni a határon, fogadd el alul)")
    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(label, "primary")

    local label = exports.seal_gui:createGuiElement("label", 0, 0, panelW, panelH, panelBg)
    exports.seal_gui:setLabelText(label, "Átlépsz a határon?")
    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(label, "grey")

	local label = exports.seal_gui:createGuiElement("label", 0, 20, panelW, panelH, panelBg)
    exports.seal_gui:setLabelText(label, "Fizetendő: #4adfbf15 000 $")
    exports.seal_gui:setLabelAlignment(label, "center", "center")
    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(label, "grey")

    local acceptButton = exports.seal_gui:createGuiElement("button", 5, panelH - 41, panelW - 10, 36, panelBg)
    exports.seal_gui:setGuiBackground(acceptButton, "solid", "primary")
    exports.seal_gui:setGuiHover(acceptButton, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickEvent(acceptButton, "openTheBorderButton", true)
    exports.seal_gui:setButtonFont(acceptButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setButtonText(acceptButton, "Átkelés")
end

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (theElement, matchingDimension)
		if theElement == localPlayer and matchingDimension then
			local borderId = getElementData(source, "borderId")

			if borderId then
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if isElement(pedveh) then
					if not getElementData(pedveh, "borderTargetColShapeId") then
						if not getElementData(resourceRoot, "border." .. borderId .. ".state") and getElementData(resourceRoot, "border." .. borderId .. ".mode") == 1 then
							if source == borderColShape[borderId][2] then
								return
							end

							currentBorderId = borderId
							createGui()
							currentBorderColShapeId = 1

							if isElement(Rubik) then
								destroyElement(Rubik)
							end

							Rubik = dxCreateFont("files/Rubik.ttf", respc(15), false, "proof")
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (theElement)
		if theElement == localPlayer then
			if getElementData(source, "borderId") then
				currentBorderId = false
				currentBorderColShapeId = false

				if exports.seal_gui:isGuiElementValid(panelBg) then
					exports.seal_gui:deleteGuiElement(panelBg)
				end
			end
		end

		if isElement(theElement) then
			if getElementType(theElement) == "vehicle" then
				if getVehicleController(theElement) == localPlayer then
					local targetColShapeId = getElementData(theElement, "borderTargetColShapeId")

					if targetColShapeId then
						local borderId = getElementData(source, "borderId")

						if borderId then
							if source == borderColShape[borderId][targetColShapeId] then
								triggerServerEvent("closeTheBorder", localPlayer, borderId, targetColShapeId, theElement)
								triggerServerEvent("checkMDC", localPlayer, theElement, false)
							end
						end
					end
				end
			end
		end
	end)

local activeButton = false

local passportItemId = false
local passportData1 = false
local passportData2 = false
local passportIsCopy = false

local passportRubik = false
local passportRT = false
local passportShader = false

function togglePassport(itemId, data1, data2, data3)
	if passportData1 then
		triggerEvent("updateInUse", localPlayer, "player", passportItemId, false)

		passportItemId = false
		passportData1 = false
		passportData2 = false
		passportIsCopy = false

		if isElement(passportRubik) then
			destroyElement(passportRubik)
		end

		if isElement(passportRT) then
			destroyElement(passportRT)
		end

		if isElement(passportShader) then
			destroyElement(passportShader)
		end

		passportRubik = nil
		passportRT = nil
		passportShader = nil

		exports.seal_chat:localActionC(localPlayer, "elrak egy útlevelet.")
	else
		triggerEvent("updateInUse", localPlayer, "player", itemId, true)

		passportItemId = itemId
		passportData1 = fromJSON(data1)
		passportData2 = data2
		passportIsCopy = data3 and split(data3, ";")

		passportRubik = dxCreateFont("files/Rubik.ttf", respc(10), false, "proof")
		passportRT = dxCreateRenderTarget(481, 481, true)
		passportShader = dxCreateShader(":seal_items/files/monochrome.fx")
		dxSetShaderValue(passportShader, "screenSource", passportRT)

		exports.seal_chat:localActionC(localPlayer, "elővesz egy útlevelet.")
	end
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if passportData1 then
			local sx = 481
			local sy = 277

			local x = screenX / 2 - sx / 2
			local y = screenY / 2 - sy / 2

			x = math.floor(x)
			y = math.floor(y)

			if passportIsCopy then
				dxSetRenderTarget(passportRT, true)
				x, y = 0, 0
			end

			dxDrawImage(x, y, sx, sy, "files/passport.png")

			if fileExists(":seal_binco/files/skins/" .. passportData1.skin .. ".png") then
				dxDrawImage(x + 20, y + 43, 120, 120, ":seal_binco/files/skins/" .. passportData1.skin .. ".png")
			end

			dxDrawText(passportData1.name1, x + 255, y + 45, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData1.name2, x + 255, y + 65, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData1.age, x + 200, y + 86, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData1.sex, x + 215, y + 107, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData1.weight, x + 235, y + 126, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData1.height, x + 250, y + 146, 0, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top")
			dxDrawText(passportData2, x + 25, y + 186, x + 461, 0, tocolor(10, 10, 10), 1, passportRubik, "left", "top", false, true)

			if passportIsCopy then
				dxSetRenderTarget()

				local x = screenX / 2 - 400
				local y = screenY / 2 - 250

				dxDrawRectangle(x, y, 800, 500, tocolor(255, 255, 255))
				dxDrawImage(x + passportIsCopy[1], y + passportIsCopy[2], 481, 481, passportShader, -passportIsCopy[3], 210, 210)
				dxDrawImage(x, y, 800, 500, ":seal_items/files/paper.png")
			end
		end

		if not getPedOccupiedVehicle(localPlayer) or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
			if exports.seal_gui:isGuiElementValid(panelBg) then
				exports.seal_gui:deleteGuiElement(panelBg)
			end
			currentBorderId = false
			currentBorderColShapeId = false
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if button == "left" then
			if state == "down" then
				if currentBorderId then
					if activeButton then
						if activeButton == "yes" then
							local pedveh = getPedOccupiedVehicle(localPlayer)

							triggerServerEvent("openTheBorder", localPlayer, currentBorderId, currentBorderColShapeId, pedveh)
						end

						currentBorderId = false
						currentBorderColShapeId = false

						if exports.seal_gui:isGuiElementValid(panelBg) then
							exports.seal_gui:deleteGuiElement(panelBg)
						end

						Rubik = nil
					end
				end
			end
		end
	end)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if currentBorderId then
			if key == "enter" or key == "backspace" then
				cancelEvent()

				if press then
					if key == "enter" then
						local pedveh = getPedOccupiedVehicle(localPlayer)

						triggerServerEvent("openTheBorder", localPlayer, currentBorderId, currentBorderColShapeId, pedveh)
					end

					currentBorderId = false
					currentBorderColShapeId = false

					if exports.seal_gui:isGuiElementValid(panelBg) then
						exports.seal_gui:deleteGuiElement(panelBg)
					end
				end
			end
		end
	end)

addEvent("openTheBorderButton", true)
addEventHandler("openTheBorderButton", getRootElement(),
	function()
		local pedveh = getPedOccupiedVehicle(localPlayer)

		triggerServerEvent("openTheBorder", localPlayer, currentBorderId, currentBorderColShapeId, pedveh)
		exports.seal_gui:deleteGuiElement(panelBg)
	end
)

addEvent("closeTheBorderButton", true)
addEventHandler("closeTheBorderButton", getRootElement(),
	function()
		exports.seal_gui:deleteGuiElement(panelBg)
	end
)