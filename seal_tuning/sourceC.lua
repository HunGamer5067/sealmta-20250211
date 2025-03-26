local markerElements = {}
local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

local customBackfirePanel = false
local customTurboPanel = false
local customWheelPanel = false

local blockedVariantVehicles = {
	[534] = true,
	[467] = true,
	[561] = true,
}

local enabledCustomSound = {
	[580] = true,
	[547] = true,
	[517] = true,
	[585] = true,
	[546] = true,
	[540] = true,
	[404] = true,
}

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

addEvent("finalPaintjobEditorExit", true)
addEventHandler("finalPaintjobEditorExit", getRootElement(), function()
	exports.seal_custompj:stopPaintjobEditor()
end)

local bebasNeueBold24 = false
local bebasNeueBold24Scale = false

local bebasNeueLight18 = false
local bebasNeueLight18Scale = false

local ubuntuRegular12 = false
local ubuntuRegular12Scale = false

local ubuntuRegular14 = false
local ubuntuRegular14Scale = false

local function guiRefreshColors()
    local resource = getResourceFromName("seal_gui")

    if resource then
        local resourceState = getResourceState(resource)

        if resourceState == "running" then
            bebasNeueBold24 = exports.seal_gui:getFont("24/BebasNeueBold.otf")
            bebasNeueBold24Scale = exports.seal_gui:getFontScale("24/BebasNeueBold.otf")
			
            bebasNeueLight18 = exports.seal_gui:getFont("18/BebasNeueLight.otf")
            bebasNeueLight18Scale = exports.seal_gui:getFontScale("18/BebasNeueLight.otf")

            ubuntuRegular12 = exports.seal_gui:getFont("12/Ubuntu-R.ttf")
            ubuntuRegular12Scale = exports.seal_gui:getFontScale("12/Ubuntu-R.ttf")

            ubuntuRegular14 = exports.seal_gui:getFont("14/Ubuntu-R.ttf")
            ubuntuRegular14Scale = exports.seal_gui:getFontScale("14/Ubuntu-R.ttf")
			
            ubuntuLight14 = exports.seal_gui:getFont("14/Ubuntu-L.ttf")
            ubuntuLight14Scale = exports.seal_gui:getFontScale("14/Ubuntu-L.ttf")
        end
    end
end
addEventHandler("onGuiRefreshColors", getRootElement(), guiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), guiRefreshColors)

local wheelObject = {
	1025,
	1073,
	1074,
	1075,
	1076,
	1077,
	1078,
	1079,
	1080,
	1081,
	1082,
	1083,
	1084,
	1085,
	1096,
	1097,
	1098,
}

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

panelState = false
vehicleElement = false

tuningSizeW = 400
tuningSizeH = 600
tuningPosX = 6
tuningPosY = 6
titleSizeH = 36

Roboto = false
Roboto2 = false
Roboto3 = false
Roboto4 = false

function createFonts()
	destroyFonts()
	Roboto = dxCreateFont(":seal_gui/fonts/Ubuntu-L.ttf", 11)
	Roboto2 = dxCreateFont("files/fonts/Roboto.ttf", resp(18), false, "antialiased")
	Roboto3 = dxCreateFont("files/fonts/Roboto.ttf", resp(36), false, "antialiased")
	Roboto4 = dxCreateFont("files/fonts/Roboto.ttf", resp(11), false, "antialiased")
end

function destroyFonts()
	if isElement(Roboto) then
		destroyElement(Roboto)
	end

	if isElement(Roboto2) then
		destroyElement(Roboto2)
	end

	if isElement(Roboto3) then
		destroyElement(Roboto3)
	end

	if isElement(Roboto4) then
		destroyElement(Roboto4)
	end
end

local currentMoney = 0
local moneyChangeTick = 0
local moneyChangeValue = 0

local currentPP = 0
local ppChangeTick = 0
local ppChangeValue = 0

selectedMenu = 0
selectedSubMenu = 0
local activeMenu = {}
local activeSubMenu = {}

selectionLevel = 1
local oldSelectionLevel = selectionLevel
local selectionStart = 0
local selectionPosY = 0
local selectionColor = false

originalUpgrade = 0
originalHandling = false
vehicleColor = {}
vehicleLightColor = {}

local neonState = false
neonId = false
originalDoor = false
originalPaintjob = false
originalPlatina = false
originalHeadLight = false
originalWheelPaintjob = false

local editPlate = false
local originalPlate = false

local variantEditor = false
local selectedVariant = false
local lastVariantChange = 0

local previewHorn = false

local camRotation = 0
local camOffsetZ = 0
local camDefPos = {}
local camPosition = {}
local camStartPos = {}
local camTargetPos = {}
local camMoveStart = false
local lastCursorPos = false
local camZoomLevel = 1
local camZoomStart = false
local camZoomInterpolation = {}
local camView = "base"

local spinnerVehicles = {
	[585] = true,
	[579] = true,
	[576] = true,
	[536] = true,
	[492] = true,
	[467] = true,
	--[466] = true,
	[542] = true
}

local previewBlockObject = false
local blockObjects = {}
local blockOffsets = {
	[507] = {-0.22, 2.1, 0}
}

local selectionSubLevel = false

function isHaveSupercharger(vehicleModel)
	return blockOffsets[vehicleModel] and "#4adfbfvan" or "#d75959nincs"
end

buyingInProgress = false

local promptState = false
local promptWidth = respc(600)
local promptHeight = respc(200)
local promptPosX = screenX / 2 - promptWidth / 2
local promptPosY = screenY / 2 - promptHeight / 2

local buyProgressStart = 0
local buyProgressDuration = 0
local buyProgressText = false
local buyProgressSound = false

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function (startedResource)
		for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
			if getElementData(v, "vehicle.tuning.Turbo") == 5 then
				local vehicleModel = getElementModel(v)
				
				if blockOffsets[vehicleModel] then
					local bx, by, bz = unpack(blockOffsets[vehicleModel])
					blockObjects[v] = createObject(3272, 0, 0, 0)
					
					attachElements(blockObjects[v], v, bx, by, bz)
					setElementCollisionsEnabled(blockObjects[v], false)
					
					local x, y, z = getElementPosition(v)

					setElementPosition(v, x, y, z + 0.01)
					setElementPosition(v, x, y, z)
				end
			end
		end
		
		setTimer(
			function()
				for k, v in pairs(getElementsByType("marker")) do
					if getElementData(v, "tuningPositionId") then
						local v2 = {getElementPosition(v)}
						markerElements[getElementData(v, "tuningPositionId")] = exports.seal_interiors:createCoolMarker(v2[1], v2[2], v2[3] + 1, "tuning", false, false, startedResource, true)
					end
				end
			end, 1000, 1
		)
	end)


addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		for i = 1, #markerElements do
			destroyElement(markerElements[i])
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if blockObjects[source] then
			if isElement(blockObjects[source]) then
				destroyElement(blockObjects[source])
			end

			blockObjects[source] = nil
		end
	end)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if blockObjects[source] then
			if isElement(blockObjects[source]) then
				destroyElement(blockObjects[source])
			end
			
			blockObjects[source] = nil
		end
	end)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if blockObjects[source] then
			if isElement(blockObjects[source]) then
				destroyElement(blockObjects[source])
			end
			
			blockObjects[source] = nil
		end

		if getElementData(source, "vehicle.tuning.Turbo") == 5 then
			local vehicleModel = getElementModel(source)
				
			if blockOffsets[vehicleModel] then
				local bx, by, bz = unpack(blockOffsets[vehicleModel])
				blockObjects[source] = createObject(3272, 0, 0, 0)
				
				attachElements(blockObjects[source], source, bx, by, bz)
				setElementCollisionsEnabled(blockObjects[source], false)
			
				local x, y, z = getElementPosition(source)

				setElementPosition(source, x, y, z + 0.01)
				setElementPosition(source, x, y, z)
			end
		end
	end)

addEvent("toggleTuning", true)
addEventHandler("toggleTuning", getRootElement(),
	function (state)
		if state then
			setPedCanBeKnockedOffBike(localPlayer, false)
		else
			setPedCanBeKnockedOffBike(localPlayer, true)
		end
		panelState = state
		showCursor(state)

		camRotation = 0
		camOffsetZ = 0
		camZoomLevel = 1

		if panelState then
			vehicleElement = getPedOccupiedVehicle(localPlayer)

			if not vehicleElement then
				panelState = false
				return
			end

			local vehicleModel = getElementModel(vehicleElement)
			if exports.seal_ev:getChargingPortOffset(vehicleModel) then
				if not oldTuningContainer then
					oldTuningContainer = tuningContainer
				end

				tuningContainer = evTuningContainer
			else
				tuningContainer = tuningContainer

				if oldTuningContainer then
					tuningContainer = oldTuningContainer
				end
			end	

			createFonts()
			exports.seal_hud:hideHUD()

			local vehPosition = {619.22235107422, -5.4094648361206, 1007.1172485352}
			local vehRotation = {0, 0, 270}
			local rotatedX, rotatedY = rotateAround(vehRotation[3], 5, 5)

			camDefPos = {vehPosition[1] + rotatedX, vehPosition[2] + rotatedY, vehPosition[3] + 2.5, vehPosition[1], vehPosition[2], vehPosition[3]}
			camPosition = camDefPos
			camTargetPos = camPosition

			vehicleColor = {getVehicleColor(vehicleElement, true)}
			vehicleLightColor = {getVehicleHeadLightColor(vehicleElement)}

			currentMoney = getElementData(localPlayer, "char.Money") or 0
			currentPP = getElementData(localPlayer, "acc.premiumPoints") or 0

			selectedMenu = 0
			selectedSubMenu = 0
			activeMenu = {}

			selectionLevel = 1
			oldSelectionLevel = selectionLevel
			selectionStart = 0
			selectionPosY = 0
			selectionColor = false
		else
			destroyFonts()
			setCameraTarget(localPlayer)
			exports.seal_hud:showHUD()
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "char.Money" then
				local dataValue = getElementData(source, dataName) or 0

				if dataValue < currentMoney then
					moneyChangeValue = currentMoney - dataValue
					moneyChangeTick = getTickCount()
				end

				currentMoney = dataValue
			end

			if dataName == "acc.premiumPoints" then
				local dataValue = getElementData(source, dataName) or 0

				if dataValue < currentPP then
					ppChangeValue = currentPP - dataValue
					ppChangeTick = getTickCount()
				end

				currentPP = dataValue
			end

			if dataName == "loggedIn" then
				for i, veh in ipairs(getElementsByType("vehicle")) do -- MTA bug fix
					local currUpgrades = getElementData(veh, "vehicle.tuning.Optical") or ""
					local currUpgradesTable = split(currUpgrades, ",")

					for k, upgrade in pairs(currUpgradesTable) do
						addVehicleUpgrade(veh, upgrade)
					end
				end
			end
		end

		if dataName == "vehicle.tuning.Turbo" then
			if blockObjects[source] then
				if isElement(blockObjects[source]) then
					destroyElement(blockObjects[source])
				end
				
				blockObjects[source] = nil
			end

			if getElementData(source, "vehicle.tuning.Turbo") == 5 then
				if isElementStreamedIn(source) then
					local vehicleModel = getElementModel(source)
						
					if blockOffsets[vehicleModel] then
						local bx, by, bz = unpack(blockOffsets[vehicleModel])
						blockObjects[source] = createObject(3272, 0, 0, 0)
						
						attachElements(blockObjects[source], source, bx, by, bz)
						setElementCollisionsEnabled(blockObjects[source], false)

						local x, y, z = getElementPosition(source)

						setElementPosition(source, x, y, z + 0.01)
						setElementPosition(source, x, y, z)
					end
				end
			end
		end
	end)

local policeCars = {
	[490] = true,
	[596] = true,
	[597] = true,
	[598] = true,
	[599] = true,
}

local x, y = 75, 75

function dxDrawBorderRectangle(x, y, w, h, color, postgui, borderSize)
	local r, g, b, a = color[1], color[2], color[3], color[4] or 1

	if not borderSize then
		borderSize = 2
	end

	dxDrawRectangle(x, y, w, h, tocolor(r, g, b, 255 * a), postgui or false)
end

local blockVehicles = {}

function getVehicleSpeed(veh)
    if isElement(veh) then
        local x, y, z = getElementVelocity(veh)
        return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
    end
end

addEventHandler("onClientPreRender", getRootElement(), function(delta)
	for veh, obj in pairs(blockObjects) do
		local engine = getVehicleEngineState(veh)
		
		if engine then
			local speed = getVehicleSpeed(veh)
			local gear = getVehicleCurrentGear(veh)

			if not blockVehicles[veh] then
				blockVehicles[veh] = {}
				blockVehicles[veh].speed = 0
				blockVehicles[veh].lastSpeed = 0
			end

			local acceleration = math.max(-0.5, (speed - (blockVehicles[veh].lastSpeed or 0)) * (delta / 1000) * 100)
			local acceleration2 = acceleration + (math.random(-5, 5) / 10)

			blockVehicles[veh].lastSpeed = speed

			local rx, ry, rz = getElementRotation(veh)
			setElementRotation(obj, rx, ry + (acceleration2 * 1.5), rz)
		else
			local rx, ry, rz = getElementRotation(veh)
			setElementRotation(obj, rx, ry, rz)
		end
	end
end)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if panelState then
			local cursorX, cursorY = getCursorPosition()

			if tonumber(cursorX) then
				cursorX = cursorX * screenX
				cursorY = cursorY * screenY
			end

			buttons = {}

			local currentTime = getTickCount()
			
			activeMenu = tuningContainer

			if selectedMenu ~= 0 then
				activeMenu = tuningContainer[selectedMenu].subMenu

				if selectedSubMenu > 0 then
					activeSubMenu = tuningContainer[selectedMenu].subMenu[selectedSubMenu].subMenu
				end
			end

			local currentMenu = activeMenu[selectionLevel]

			local menuOffset = 1
			if selectionLevel > 10 then
				menuOffset = 1 + selectionLevel - 10
			end

			local textWidth, textHeight = exports.seal_gui:getTextWidthFont("SealMTA - Tuningoló", bebasNeueBold24, bebasNeueBold24Scale), exports.seal_gui:getFontHeight(bebasNeueBold24, bebasNeueBold24Scale)

			-- ** title
			dxDrawText("SealMTA - Tuningoló", x, y, x + textWidth, y + textHeight, tocolor(200, 200, 200), bebasNeueBold24Scale, bebasNeueBold24, "left", "center")
			dxDrawText("A jobb élményért, teljesítményért!", x, y + textHeight + 28, x + textWidth, y + textHeight + 28 + textHeight, tocolor(200, 200, 200), bebasNeueLight18Scale, bebasNeueLight18, "left", "center")
			dxDrawRectangle(x, y + textHeight + 18, textWidth, 4, tocolor(200, 200, 200))
	
			-- ** content
			for i = 0, 9 do
				local dat = activeMenu[i + menuOffset]
					
				if dat then
					local validSelectionLevel = (selectionLevel - 1)
					local cx, cy = x, y + 125 + (i * 48)
										
					if validSelectionLevel > 9 then
						validSelectionLevel = 9
					end

					local now = getTickCount()
					local progress = now - selectionStart
	
					if progress > 0 then
						if validSelectionLevel == i then
							local textWidth = dxGetTextWidth(dat.name, ubuntuRegular12Scale, ubuntuRegular12) + 6
							pos = interpolateBetween(42, 0, 0, 62, 0, 0, progress / 300, "Linear")
							iconPos = interpolateBetween(9, 0, 0, 29, 0, 0, progress / 300, "Linear")
							px, py = interpolateBetween(cx, 0, 0, cx - 2, 0, 0, progress / 300, "Linear"), interpolateBetween(cy, 0, 0, cy - 2, 0, 0, progress / 300, "Linear")
							sx, sy = interpolateBetween(300, 0, 0, 304, 0, 0, progress / 300, "Linear"), interpolateBetween(42, 0, 0, 46, 0, 0, progress / 300, "Linear")
						end
					end
		
					dxDrawBorderRectangle(cx, cy, 300, 42, {26, 27, 31})
					if validSelectionLevel == i then
						local textWidth = dxGetTextWidth(dat.name, ubuntuRegular12Scale, ubuntuRegular12) + 6
						dxDrawBorderRectangle(px, py, sx, sy, {30, 172, 144, 70})
						dxDrawText(dat.name, cx + pos, cy, cx + pos - textWidth, cy + 42, tocolor(255, 255, 255), ubuntuRegular12Scale, ubuntuRegular12, "left", "center")
						dxDrawImage(cx + iconPos, cy + 9, 24, 24, dat.icon, 0, 0, 0, tocolor(255, 255, 255))
					else
						dxDrawText(dat.name, cx + 42, cy, cx + 42 + 300, cy + 42, tocolor(255, 255, 255), ubuntuRegular12Scale, ubuntuRegular12, "left", "center")
						dxDrawImage(cx + 9, cy + 9, 24, 24, dat.icon)
					end
				end
			end

			if activeSubMenu and selectionSubLevel then
				local subMenuOffset = 1
				if selectionSubLevel > 5 then
					subMenuOffset = 1 + selectionSubLevel - 5
				end

				for i = 0, 4 do
					local validSubSelectionLevel = (selectionSubLevel - 1)
					if screenY < 900 then
						cx, cy = x + (i * 256), screenY - 183
					else
						cx, cy = x + (i * 256), screenY - 219
					end

					if validSubSelectionLevel > 4 then
						validSubSelectionLevel = 4
					end

					dxDrawBorderRectangle(cx, cy, 250, 134, {26, 27, 31})	

					local dat = activeSubMenu[i + subMenuOffset]

					if dat then
						local textHeight = exports.seal_gui:getFontHeight(ubuntuRegular14, ubuntuRegular14Scale)

						if validSubSelectionLevel == i then
							dxDrawBorderRectangle(cx, cy, 250, 134, {30, 172, 144, 70})									
							dxDrawText(dat.name, cx + 36, cy - textHeight / 2 - 6, cx + 36 + 250, cy - textHeight / 2 - 6 + 134, tocolor(255, 255, 255), ubuntuRegular14Scale, ubuntuRegular14, "left", "center")
						else
						
							dxDrawText(dat.name, cx + 36, cy - textHeight / 2 - 6, cx + 36 + 250, cy - textHeight / 2 - 6 + 134, tocolor(255, 255, 255), ubuntuRegular14Scale, ubuntuRegular14, "left", "center")
						end

						if selectedSubMenu > 0 then
							if tuningContainer[selectedMenu].subMenu[selectedSubMenu].clientFunction and dat.value then
								if tuningContainer[selectedMenu].subMenu[selectedSubMenu].clientFunction(vehicleElement, dat.value) then
									dxDrawText("Felszerelve", cx + 36, cy + textHeight / 2 + 6, cx + 36 + 250, cy + textHeight / 2 + 6 + 134, tocolor(255, 255, 255), ubuntuLight14Scale, ubuntuLight14, "left", "center")
								else
									if dat.priceType == "free" then
										dxDrawText("Ár: Ingyenes", cx + 36, cy + textHeight / 2 + 6, cx + 36 + 250, cy + textHeight / 2 + 6 + 134, tocolor(255, 255, 255), ubuntuLight14Scale, ubuntuLight14, "left", "center")
									elseif dat.priceType == "money" then
										dxDrawText("Ár: " .. dat.price .. "$", cx + 36, cy + textHeight / 2 + 6, cx + 36 + 250, cy + textHeight / 2 + 6 + 134, tocolor(255, 255, 255), ubuntuLight14Scale, ubuntuLight14, "left", "center")
									elseif dat.priceType == "premium" then
										dxDrawText("Ár: " .. dat.price .. "PP", cx + 36, cy + textHeight / 2 + 6, cx + 36 + 250, cy + textHeight / 2 + 6 + 134, tocolor(255, 255, 255), ubuntuLight14Scale, ubuntuLight14, "left", "center")
									end
								end
							end
						end

						if dat.icon then
							if validSubSelectionLevel == i then
								dxDrawImage(cx + 206, cy + 8, 36, 36, dat.icon, 0, 0, 0, tocolor(255, 255, 255))
							else
								dxDrawImage(cx + 206, cy + 8, 36, 36, dat.icon)
							end
						end
					end
				end
			end

			if variantEditor then
				local cx, cy = screenX - 375, y + 125

				dxDrawBorderRectangle(cx, cy, 300, 324, {15, 15, 15, 40})
				dxDrawImage(cx + 32, cy + 137, 236, 181, "files/variant.png", 0, 0, 0, tocolor(200, 200, 200, 235))

				dxDrawText("Jelenlegi variáns:", cx, cy + 36, cx + 300, cy + 36 + 324, tocolor(200, 200, 200), ubuntuRegular14Scale, ubuntuRegular14, "center", "top")				dxDrawText("Jelenlegi variáns:", cx, cy + 36, cx + 300, cy + 36 + 324, tocolor(200, 200, 200), ubuntuRegular14Scale, ubuntuRegular14, "center", "top")
				dxDrawText(selectedVariant, cx, cy + 72, cx + 300, cy + 72 + 324, tocolor(200, 200, 200), ubuntuRegular14Scale, ubuntuRegular14, "center", "top")
			end

			if editPlate then
				local platePosX = x + 300 + 6
				local platePosY = y + ((selectionLevel + 1) * 48)

				dxDrawBorderRectangle(platePosX, platePosY, 300, 42, {15, 15, 15, 40})
				dxDrawText((getVehiclePlateText(vehicleElement) or ""):upper(), platePosX, platePosY, platePosX + 300, platePosY + 42, tocolor(200, 200, 200), 1, Roboto, "center", "center")
			end

			if buyProgressStart + buyProgressDuration > currentTime then
				local buyProgressPosX = x + 300 + 6
				local buyProgressPosY = y + 125 + ((math.min(10, selectionLevel) - 1) * 48)

				dxDrawBorderRectangle(buyProgressPosX, buyProgressPosY, 300, 42, {15, 15, 15, 40})
				dxDrawBorderRectangle(buyProgressPosX, buyProgressPosY, reMap(currentTime - buyProgressStart, 0, buyProgressDuration, 0, 300), 42, {69, 164, 145})
				dxDrawText(buyProgressText, buyProgressPosX, buyProgressPosY, buyProgressPosX + 300, buyProgressPosY + 42, tocolor(200, 200, 200), 1, Roboto, "center", "center")
			end

			-- ** Megerősítés
			local data = activeSubMenu[selectionSubLevel]

			if not data then
				data = activeMenu[selectionLevel]
			end
			
			if promptState and data.value ~= "custompj" then
				local tuningPromptSizeW = 500
				local tuningPromptSizeH = 165
				
				local tuningPromptPosX = screenX / 2 - (tuningPromptSizeW / 2)
				local tuningPromptPosY = screenY / 2 - (tuningPromptSizeH / 2)

				local titleSizeW = tuningPromptSizeW
				local titleSizeH = 30

				local buttonSizeW = (tuningPromptSizeW / 2) - 9
				local buttonSizeH = 30

				if data.priceType == "money" then
					price = formatNumber(data.price) .. " $"
					hex = "#4adfbf"
				elseif data.priceType == "premium" then
					price = formatNumber(data.price) .. " PP"
					hex = "#32b2ee"
				elseif data.priceType == "free" then
					price = "Ingyenes"
					hex = "#f55151"
				end
				
				dxDrawBorderRectangle(tuningPromptPosX, tuningPromptPosY, tuningPromptSizeW, tuningPromptSizeH, {26, 27, 31})
				dxDrawRectangle(tuningPromptPosX + 2, tuningPromptPosY + 2, titleSizeW - 4, titleSizeH, tocolor(14, 15, 17))
				dxDrawText("SealMTA - Tuning", tuningPromptPosX + 5, tuningPromptPosY, tuningPromptPosX + 5 + titleSizeW, tuningPromptPosY + titleSizeH, tocolor(255, 255, 255), 1, Roboto, "left", "center", false, false, false, true)

				dxDrawText("#FFFFFFBiztosan megszeretnéd vásárolni a kiválasztott tuningot?\nA tuning ára: " .. hex .. price, tuningPromptPosX, tuningPromptPosY + (titleSizeH * 2), tuningPromptPosX + tuningPromptSizeW, tuningPromptPosY + (titleSizeH * 2) + tuningPromptSizeH, tocolor(255, 255, 255), 1, Roboto, "center", "top", false, false, false, true)
				
				if activeButton == "buyTuning" then
					dxDrawRectangle(tuningPromptPosX + 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH, tocolor(63, 147, 212, 225))
				else
					dxDrawRectangle(tuningPromptPosX + 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH, tocolor(63, 147, 212, 200))
				end
				dxDrawText("Vásárlás", tuningPromptPosX + 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, tuningPromptPosX + 6 + buttonSizeW, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6 + buttonSizeH, tocolor(255, 255, 255), 1, Roboto, "center", "center")
				buttons["buyTuning"] = {tuningPromptPosX + 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH}

				if activeButton == "cancelTuningBuy" then
					dxDrawRectangle(tuningPromptPosX + tuningPromptSizeW - buttonSizeW - 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH, tocolor(245, 81, 81, 225))
				else
					dxDrawRectangle(tuningPromptPosX + tuningPromptSizeW - buttonSizeW - 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH, tocolor(245, 81, 81, 200))
				end
				dxDrawText("Mégsem", tuningPromptPosX + tuningPromptSizeW - buttonSizeW - 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, tuningPromptPosX + tuningPromptSizeW - buttonSizeW - 6 + buttonSizeW, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6 + buttonSizeH, tocolor(255, 255, 255), 1, Roboto, "center", "center", false, false, false, true)
				buttons["cancelTuningBuy"] = {tuningPromptPosX + tuningPromptSizeW - buttonSizeW - 6, tuningPromptPosY + tuningPromptSizeH - buttonSizeH - 6, buttonSizeW, buttonSizeH}
			elseif promptState and data.value == "custompj" then
				promptState = false
				exports.seal_custompj:startPaintjobEditor(getPedOccupiedVehicle(localPlayer), false)
				panelState = false
			end

			-- ** Button handler
			activeButton = false

			if isCursorShowing() then
				for k, v in pairs(buttons) do
					if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			end
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if panelState then
			if button == "left" and state == "down" then
				if activeButton then
					if activeButton == "buyTuning" then
						buyTuning()
						promptState = false
						playSound("files/sounds/promptaccept.mp3")
					elseif activeButton == "cancelTuningBuy" then
						promptState = false
						playSound("files/sounds/promptdecline.mp3")
					end
				end
			end
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if panelState then
			if key ~= "escape" and key ~= "l" then
				cancelEvent()
			end

			if not press then
				return
			end

			if isCursorShowing() and not isMTAWindowActive() then
				if (key == "mouse_wheel_up" or key == "mouse_wheel_down") and not camZoomStart and not camMoveStart and not buyingInProgress then
					if key == "mouse_wheel_down" then
						if camZoomLevel > 1 and camView == "base" or camZoomLevel > 0.75 and camView ~= "base" then
							local val = camZoomLevel - 0.2 * camZoomLevel

							if camView ~= "base" then
								if val < 0.75 then
									val = 0.75
								end
							elseif val < 1 then
								val = 1
							end
							
							camZoomInterpolation = {camZoomLevel, val}
							camZoomStart = getTickCount()
						end
					elseif camZoomLevel <= 3 then
						camZoomInterpolation = {camZoomLevel, camZoomLevel + 0.2 * camZoomLevel}
						camZoomStart = getTickCount()
					end
				end
			end

			if activeColorInput then
				cancelEvent()
				return
			end

			if buyingInProgress or buyProgressStart + buyProgressDuration > getTickCount() then
				return
			end

			if key == "enter" and press then
				if promptState then
					buyTuning()
					promptState = false
					playSound("files/sounds/promptaccept.mp3")
					return
				end

				local currentMenu = activeMenu[selectionLevel]

				if selectedMenu == 0 then
					if currentMenu.subMenu then
						selectedMenu = selectionLevel
						oldSelectionLevel = selectionLevel
						selectionLevel = 1

						if tuningContainer[selectedMenu].subMenu[selectionLevel].colorPicker then
							colorPicker = true
							colorX = false
						else
							colorPicker = false
						end

						playSound("files/sounds/menuselect.mp3")
					end
				else
					if selectedSubMenu == 0 then
						if variantEditor then
							confirmTuning()
							return
						end

						if currentMenu.handlingPrefix == "WHEEL_F_" or currentMenu.handlingPrefix == "WHEEL_R_" then
							if getElementData(vehicleElement, "tuningSpinners") then
								exports.seal_gui:showInfobox("e", "Előbb szereld le a spinnert!")
								return
							end
						end

						if currentMenu.isTheWheelTuning then
							if (getElementData(vehicleElement, "vehicle.currentWheelTexture") or 0) ~= 0 then
								exports.seal_gui:showInfobox("e", "Előbb vedd le a kerék paintjobot!")
								return
							end
						end

						if currentMenu.isSpinner then
							if not spinnerVehicles[getElementModel(vehicleElement)] or getVehicleType(vehicleElement) ~= "Automobile" then
								exports.seal_gui:showInfobox("e", "Ez az alkatrész nem kompatibilis a járműveddel!")
								return
							end

							local flagsKeyed = getVehicleHandlingFlags(vehicleElement)

							for flag in pairs(flagsKeyed) do
								if string.sub(flag, 1, 6) == "WHEEL_" then
									exports.seal_gui:showInfobox("e", "Előbb szereld át a kerekeid szélességét normálra!")
									return
								end
							end

							exports.seal_spinner:getSizeForPreview(vehicleElement)
							exports.seal_spinner:setPreviewColor(vehicleElement, colorInputs.r, colorInputs.g, colorInputs.b)
							exports.seal_spinner:previewSpinner(vehicleElement, currentMenu.subMenu[1].value, currentMenu.subMenu[1].colorPicker)
						end

						if currentMenu.variantEditor then
							if policeCars[getElementModel(vehicleElement)] or blockedVariantVehicles[getElementModel(vehicleElement)] then exports.seal_gui:showInfobox("e", "Ez az alkatrész nem kompatibilis a járműveddel!") return end
						end

						if not enabledCustomSound[getElementModel(vehicleElement)] then
							if currentMenu.id and currentMenu.id == "engineSound" then
								exports.seal_gui:showInfobox("e", "Ez az alkatrész nem kompatibilis a járműveddel!")
								return
							end
						end

						if currentMenu.variantEditor then
							variantEditor = true
							selectedVariant = getElementData(vehicleElement, "vehicle.variant") or 0
							triggerServerEvent("previewVariant", vehicleElement, selectedVariant)
							return
						else
							variantEditor = false
						end

						if currentMenu.upgradeSlot then
								local upgrades = false
								local upgrades = (getVehicleCompatibleUpgrades(vehicleElement, currentMenu.upgradeSlot)) --(vehicleComponents[getElementModel(getPedOccupiedVehicle(localPlayer))][currentMenu.upgradeSlot])
								currentMenu.subMenu = {}

								if upgrades and #upgrades > 0 then
									table.insert(currentMenu.subMenu, {
										name = "Gyári",
										icon = currentMenu.icon,
										priceType = "free",
										price = 0,
										value = 0
									})

									for k, v in ipairs(upgrades) do
										local name = currentMenu.name .. " " .. k

										if componentNames[v] then
											name = componentNames[v]
										end

										table.insert(currentMenu.subMenu, {
											name = name,
											icon = currentMenu.icon,
											priceType = currentMenu.priceType,
											price = currentMenu.price,
											value = v
										})
									end
								else
									currentMenu.subMenu = false
									exports.seal_gui:showInfobox("e", "Sajnos a kiválasztott alkatrész nem kompatibilis a járműveddel!")
								end
							--end
						end

						if currentMenu.id == "color" then
							colorPicker = true
							colorX = false
						end

						if currentMenu.id == "platina" then
							local textureCount = exports.seal_platina:getPaintJobCount(getElementModel(vehicleElement))

							currentMenu.subMenu = {}

							if textureCount and textureCount > 0 then
								table.insert(currentMenu.subMenu, {
									name = "Gyári",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0
								})

								for i = 1, textureCount do
									table.insert(currentMenu.subMenu, {
										name = "Platina " .. i,
										icon = "files/icons/pp.png",
										priceType = "premium",
										price = 3500,
										value = i
									})
								end
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.id == "paintjob" then
							currentMenu.subMenu = {}

							if exports.seal_custompj:getCustomPjTextureName(getElementModel(vehicleElement)) then
								table.insert(currentMenu.subMenu, {
									name = "Gyári",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0
								})
								table.insert(currentMenu.subMenu, {
									name = "Egyedi Paintjob",
									icon = "files/icons/pp.png",
									priceType = "premium",
									price = exports.seal_custompj:getCustomPjPrice(),
									value = "custompj"
								})
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.id == "wheelPaintjob" then
							local textureCount = exports.seal_wheeltexture:getWheelTextureCount(vehicleElement)

							currentMenu.subMenu = {}

							if textureCount and textureCount > 0 then
								table.insert(currentMenu.subMenu, {
									name = "Nincs",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0
								})

								for i = 1, textureCount do
									table.insert(currentMenu.subMenu, {
										name = "Paintjob " .. i,
										icon = "files/icons/pp.png",
										priceType = "premium",
										price = 1500,
										value = i
									})
								end
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.id == "wheelChange" then
							local textureCount = 18

							currentMenu.subMenu = {}

							if textureCount and textureCount > 0 then
								table.insert(currentMenu.subMenu, {
									name = "Gyári",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0
								})
							

								for i = 1, textureCount do
									table.insert(currentMenu.subMenu, {
										name = componentNames[wheelObject[i]],
										icon = "files/icons/pp.png",
										priceType = "money",
										price = 5000,
										value = wheelObject[i]
									})
								end
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.id == "performance" then
							local textureCount = 4

							currentMenu.subMenu = {}

							if textureCount and textureCount > 0 then
								table.insert(currentMenu.subMenu, {
									name = "Gyári",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0
								})
							

								performances = {
									{"Alap", 2500, "dollar"},
									{"Profi", 7500, "dollar"},
									{"Verseny", 15000, "dollar"},
									{"Venom", 900, "pp"},
								}

								for i = 1, textureCount do
									table.insert(currentMenu.subMenu, {
										name = performances[i][1],
										icon = "files/icons/"..performances[i][3]..".png",
										priceType = "money",
										price = performances[i][2],
										value = i
									})
								end
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.id == "headlight" then
							local textureCount = exports.seal_headlight:getHeadLightCount(getElementModel(vehicleElement))

							currentMenu.subMenu = {}

							if textureCount and textureCount > 0 then
								table.insert(currentMenu.subMenu, {
									name = "Gyári",
									icon = "files/icons/free.png",
									priceType = "free",
									price = 0,
									value = 0,
									hint = "Vásárlás előtt ajánlott fel- és lekapcsolt lámpával is megtekinteni a járművet. (L gomb)"
								})

								for i = 1, textureCount do
									table.insert(currentMenu.subMenu, {
										name = "Fényszóró " .. i,
										icon = "files/icons/pp.png",
										priceType = "premium",
										price = 1200,
										value = i,
										hint = "Vásárlás előtt ajánlott fel- és lekapcsolt lámpával is megtekinteni a járművet. (L gomb)"
									})
								end
							else
								currentMenu.subMenu = false
							end
						end

						if currentMenu.subMenu then
							selectedSubMenu = selectionLevel
							selectionSubLevel = 1
							playSound("files/sounds/menuselect.mp3")
--
							if currentMenu.camera then
								changeCamera(currentMenu.camera)
							end

							installPreviewTuning()
						elseif currentMenu.id == "color" then
							confirmTuning()
						else
							exports.seal_gui:showInfobox("e", "Sajnos a kiválasztott alkatrész nem kompatibilis a járműveddel!")
						end
					else
						local currentMenu = activeMenu[selectionLevel].subMenu[selectionSubLevel]
						if currentMenu.supercharger then
							if not blockOffsets[getElementModel(vehicleElement)] then
								exports.seal_gui:showInfobox("e", "Ezzel az autóval nem kompatibilis a supercharger.")
								return
							end
						end

						confirmTuning()
					end
				end
			end

			if key == "backspace" then
				if promptState then
					promptState = false
					playSound("files/sounds/promptdecline.mp3")
					return
				end

				if customBackfirePanel then
					exports.seal_backfire:destroyBackfireSelector()
					customBackfirePanel = false
				end
				
				if customTurboPanel then
					exports.seal_turbo:deleteTurboEditor()
					customTurboPanel = false
				end

				if customWheelPanel then
					destroyWheelCustomization(true)
					customWheelPanel = false
				end

				local currentMenu = activeMenu[selectionLevel]

				if selectedMenu > 0 then
					if variantEditor then
						variantEditor = false
						triggerServerEvent("previewVariant", vehicleElement, false)
						return
					end

					if editPlate then
						local plateText = getVehiclePlateText(vehicleElement) or ""

						if utfLen(plateText) >= 1 then
							setVehiclePlateText(vehicleElement, utf8.sub(plateText, 1, -2))
						end

						return
					end

					togglePlateEdit(false)

					if currentMenu.id == "color" or currentMenu.colorPicker then
						setVehicleColor(vehicleElement, vehicleColor[1], vehicleColor[2], vehicleColor[3], vehicleColor[4], vehicleColor[5], vehicleColor[6], vehicleColor[7], vehicleColor[8], vehicleColor[9], vehicleColor[10], vehicleColor[11], vehicleColor[12])
						setVehicleHeadLightColor(vehicleElement, vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])
						setElementData(vehicleElement, "vehicleColor", {vehicleColor[1], vehicleColor[2], vehicleColor[3]}, false)
						triggerEvent("resetSpeedoColor", vehicleElement)
					end
					
					if selectedSubMenu > 0 then
						changeCamera("base")
						restorePreviewTuning()

						--selectedMenu = selectionLevel
						selectionLevel = selectedSubMenu
						selectedSubMenu = 0
						selectionSubLevel = false
					else
						selectionLevel = selectedMenu
						selectedMenu = 0
					end

					colorPicker = false
					colorX = false
				else
					triggerServerEvent("exitTuning", localPlayer)
				end

				playSound("files/sounds/menuback.mp3")
			end

			if key == "arrow_u" then
				if promptState then
					return
				end

				if selectionSubLevel then
					return
				end

				if variantEditor then
					if getTickCount() - lastVariantChange >= 250 then
						selectedVariant = selectedVariant + 1
						
						if selectedVariant > 6 then
							selectedVariant = 0
						end

						triggerServerEvent("previewVariant", vehicleElement, selectedVariant)

						lastVariantChange = getTickCount()
					end

					return
				end
					
				if selectionLevel > 1 then
					selectionStart = getTickCount()
					oldSelectionLevel = selectionLevel
					selectionLevel = selectionLevel - 1
					playSound("files/sounds/menunavigate.mp3")

					if selectedSubMenu > 0 then
						installPreviewTuning()
					end
				end
			end

			if key == "arrow_d" then
				if promptState then
					return
				end

				if selectionSubLevel then
					return
				end

				if variantEditor then
					if getTickCount() - lastVariantChange >= 250 then
						selectedVariant = selectedVariant - 1
						
						if selectedVariant < 0 then
							selectedVariant = 6
						end

						triggerServerEvent("previewVariant", vehicleElement, selectedVariant)

						lastVariantChange = getTickCount()
					end

					return
				end

				if selectionLevel < #activeMenu then
					selectionStart = getTickCount()
					oldSelectionLevel = selectionLevel
					selectionLevel = selectionLevel + 1
					playSound("files/sounds/menunavigate.mp3")
					
					if selectedSubMenu > 0 then
						installPreviewTuning()
					end
				end
			end

			if key == "arrow_l" then
				if not selectionSubLevel then
					return
				end

				if promptState then
					return
				end

				if selectionSubLevel > 1 then
					selectionSubLevel = selectionSubLevel - 1
					playSound("files/sounds/menunavigate.mp3")
					
					if selectedSubMenu > 0 then
						installPreviewTuning()

						if customBackfirePanel then
							exports.seal_backfire:destroyBackfireSelector()
							customBackfirePanel = false
						end

						if customTurboPanel then
							exports.seal_turbo:deleteTurboEditor()
							customTurboPanel = false
						end

						if customWheelPanel then
							destroyWheelCustomization(true)
							customWheelPanel = false
						end
					end
				end
			end

			if key == "arrow_r" then
				if not selectionSubLevel then
					return
				end

				if promptState then
					return
				end

				if selectionSubLevel < #activeSubMenu then
					selectionSubLevel = selectionSubLevel + 1
					playSound("files/sounds/menunavigate.mp3")
					
					if selectedSubMenu > 0 then
						local currentMenu = activeSubMenu[selectionSubLevel]

						installPreviewTuning()
	
						if currentMenu.id == "custombf" and not customBackfirePanel then
							exports.seal_backfire:createBackfireSelector(screenX - 375, y + 125)
							customBackfirePanel = true
						end

						if currentMenu.id == "customwheel" and not customWheelPanel then
							createWheelCustomization(screenX - 375, 407)
							customWheelPanel = true
						end
	
						if currentMenu.id == "customturbo" and not customTurboPanel then
							exports.seal_turbo:createTurboEditor(screenX - 375, y + 125)
							customTurboPanel = true
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientCharacter", getRootElement(),
	function (character)
		if panelState and editPlate then
			if string.find(character, "[a-z]") or string.find(character, "[0-9]") or character == "-" then
				local plateText = getVehiclePlateText(vehicleElement) or ""

				if utfLen(plateText) < 8 then
					setVehiclePlateText(vehicleElement, plateText .. character:upper())
				end
			end
		end
	end)

function togglePlateEdit(state)
	editPlate = state

	if editPlate then
		if not originalPlate then
			originalPlate = getVehiclePlateText(vehicleElement) or ""
		end
	elseif originalPlate then
		setVehiclePlateText(vehicleElement, originalPlate)
		originalPlate = false
	end
end

function confirmTuning()
	if panelState and not buyingInProgress and not promptState then
		promptState = true
		playSound("files/sounds/prompt.mp3")
	end
end

function buyTuning()
	if panelState and not buyingInProgress and promptState then
		if variantEditor then
			variantEditor = false
			buyingInProgress = true
			triggerServerEvent("buyVariantTuning", localPlayer, selectedVariant, tuningContainer[selectedMenu].subMenu[selectionLevel].price)
			return
		end

		if selectedSubMenu > 0 then
			if selectionSubLevel then
				mainMenu = tuningContainer[selectedMenu]
				subMenu = mainMenu.subMenu[selectedSubMenu]
				currentSelection = subMenu.subMenu[selectionSubLevel]
			else
				mainMenu = tuningContainer[selectedMenu]
				subMenu = mainMenu.subMenu[selectedSubMenu]
				currentSelection = subMenu.subMenu[selectionLevel]
			end

			if currentSelection.isSpinnerItem then
				local r, g, b, sx, sy, sz = exports.seal_spinner:getPreviewColor()
				triggerServerEvent("buySpinnerTuning", localPlayer, currentSelection.value, r, g, b, sx, sy, sz, currentSelection.colorPicker, currentSelection.price)
				buyingInProgress = true
			elseif subMenu.upgradeSlot then
				triggerServerEvent("buyOpticalTuning", localPlayer, subMenu.upgradeSlot, currentSelection.value, currentSelection.priceType, currentSelection.price)
				buyingInProgress = true
			elseif subMenu.id == "paintjob" then
				if currentSelection.value == "custompj" then
					exports.seal_custompj:startPaintjobEditor(getPedOccupiedVehicle(localPlayer), false)
					panelState = false
				elseif currentSelection.value == 0 then
					triggerServerEvent("buyPaintjob", localPlayer, currentSelection.value, currentSelection.priceType, currentSelection.price)
					buyingInProgress = true
				end
			elseif subMenu.id == "platina" then
				triggerServerEvent("buyPlatina", localPlayer, currentSelection.value, currentSelection.priceType, currentSelection.price)
				buyingInProgress = true
			elseif subMenu.id == "wheelPaintjob" then
				triggerServerEvent("buyWheelPaintjob", localPlayer, currentSelection.value, currentSelection.priceType, currentSelection.price)
				buyingInProgress = true
			elseif subMenu.id == "headlight" then
				triggerServerEvent("buyHeadLight", localPlayer, currentSelection.value, currentSelection.priceType, currentSelection.price)
				buyingInProgress = true
			elseif subMenu.id == "color" then
				local currVehColor = {getVehicleColor(vehicleElement, true)}
				local currLightColor = {getVehicleHeadLightColor(vehicleElement)}

				if not compareTables(vehicleColor, currVehColor) or not compareTables(vehicleLightColor, currLightColor) or currentSelection.colorId >= 7 then
					triggerServerEvent("buyColor", localPlayer, currentSelection.colorId, currVehColor, currLightColor, subMenu.priceType, subMenu.price)
					buyingInProgress = true
				else
					exports.seal_gui:showInfobox("e", "A kiválasztott szín nem lehet ugyan az, mint a jelenlegi.")
					buyingInProgress = false
				end
			elseif subMenu.id == "licensePlate" then
				local plateText = getVehiclePlateText(vehicleElement)

				if plateText then
					triggerServerEvent("buyLicensePlate", localPlayer, currentSelection.value, plateText, currentSelection.priceType, currentSelection.price)
					buyingInProgress = true
				else
					exports.seal_gui:showInfobox("e", "A jármű nem maradhat rendszám nélkül!")
					buyingInProgress = false
					togglePlateEdit(false)
				end
			else
				local isTheOriginal = false

				if selectedSubMenu > 0 then
					if subMenu.clientFunction and currentSelection.value then
						if subMenu.clientFunction(vehicleElement, currentSelection.value) then
							if currentSelection.id ~= "custombf" and currentSelection.id ~= "customturbo" and currentSelection.id ~= "customwheel" then
								isTheOriginal = true
							end
						end
					end
				end

				if customization.updated then
					customWheel = {customization, customizationTemp}
				end

				if selectionSubLevel then
					triggerServerEvent("buyTuning", localPlayer, selectedMenu, selectedSubMenu, selectionSubLevel, isTheOriginal, customWheel)
				else
					triggerServerEvent("buyTuning", localPlayer, selectedMenu, selectedSubMenu, selectionLevel, isTheOriginal, customWheel)
				end

				buyingInProgress = true
			end
		elseif selectedMenu > 0 then
			local mainMenu = tuningContainer[selectedMenu]
			local currentSelection = mainMenu.subMenu[selectionSubLevel]

			if not currentSelection then
				currentSelection = mainMenu.subMenu[selectionLevel]
			end

			if currentSelection.id == "color" then
				local currVehColor = {getVehicleColor(vehicleElement, true)}
				local currLightColor = {getVehicleHeadLightColor(vehicleElement)}

				if not compareTables(vehicleColor, currVehColor) or not compareTables(vehicleLightColor, currLightColor) or currentSelection.colorId >= 7 then
					triggerServerEvent("buyColor", localPlayer, currentSelection.colorId, currVehColor, currLightColor, currentSelection.priceType, currentSelection.price)
					buyingInProgress = true
				else
					exports.seal_gui:showInfobox("e", "A kiválasztott szín nem lehet ugyan az, mint a jelenlegi.")
					buyingInProgress = false
				end
			end
		end
	end
end

function compareTables(t1, t2)
	if #t1 ~= #t2 then
		return false
	end

	for i = 1, #t1 do
		if t1[i] ~= t2[i] then
			return false
		end
	end

	return true
end

addEvent("buyTuning", true)
addEventHandler("buyTuning", getRootElement(),
	function (state, item, value)
		if state == "success" then
			if item == "neon" then
				neonId = value
			end

			if item == "handling" then
				originalHandling = value
			end

			if item == "door" then
				originalDoor = value
			end

			if not value or value == 0 then
				startBuyProgress("newpart", "Leszerelés...")
			else
				startBuyProgress("newpart", "Felszerelés...")
			end

			if customBackfirePanel then
				exports.seal_backfire:destroyBackfireSelector()
				customBackfirePanel = false
			end

			if customTurboPanel then
				exports.seal_turbo:deleteTurboEditor()
				customTurboPanel = false
			end

			if customWheelPanel then
				destroyWheelCustomization()
				customWheelPanel = false
			end
		elseif state == "failed" then
			if customWheelPanel then
				destroyWheelCustomization(true)
				customWheelPanel = false
			end
		end

		buyingInProgress = false
	end)

addEvent("buyOpticalTuning", true)
addEventHandler("buyOpticalTuning", getRootElement(),
	function (state, upgrade)
		if state == "success" then
			if upgrade then
				originalUpgrade = upgrade

				if upgrade == 0 then
					startBuyProgress("newpart", "Leszerelés...")
				else
					startBuyProgress("newpart", "Felszerelés...")
				end
			end
		end

		buyingInProgress = false
	end)

addEvent("buyVariant", true)
addEventHandler("buyVariant", getRootElement(),
	function (state)
		if state == "success" then
			startBuyProgress("newpart", "Felszerelés...")
		elseif state == "successdown" then
			startBuyProgress("newpart", "Leszerelés...")
		end

		buyingInProgress = false
	end)

addEvent("buySpinner", true)
addEventHandler("buySpinner", getRootElement(),
	function (state, value)
		if state == "success" then
			startBuyProgress("newpart", "Felszerelés...")
		elseif state == "successdown" then
			startBuyProgress("newpart", "Leszerelés...")
		end

		buyingInProgress = false
	end)

addEvent("buyPlatina", true)
addEventHandler("buyPlatina", getRootElement(),
	function (state, value)
		if state == "success" then
			if value then
				originalPlatina = value
			end

			exports.seal_platina:applyPaintJob(value, true)

			startBuyProgress("paint", "Festés...")
		end

		buyingInProgress = false
	end)

addEvent("buyPaintjob", true)
addEventHandler("buyPaintjob", getRootElement(),
	function (state, value)
		if state == "success" then
			if value then
				originalPaintjob = value
			end

			exports.seal_paintjob:applyPaintJob(value, true)

			startBuyProgress("paint", "Festés...")
		end

		buyingInProgress = false
	end)

addEvent("buyWheelPaintjob", true)
addEventHandler("buyWheelPaintjob", getRootElement(),
	function (state, value)
		if state == "success" then
			if value then
				originalWheelPaintjob = value
			end

			exports.seal_wheeltexture:applyWheelTexture(value, true)

			startBuyProgress("paint", "Festés...")
		end

		buyingInProgress = false
	end)

addEvent("buyHeadLight", true)
addEventHandler("buyHeadLight", getRootElement(),
	function (state, value)
		if state == "success" then
			if value then
				originalHeadLight = value
			end

			exports.seal_headlight:applyHeadLight(value, true)

			startBuyProgress("newpart", "Felszerelés...")
		end

		buyingInProgress = false
	end)

addEvent("buyColor", true)
addEventHandler("buyColor", getRootElement(),
	function (state, bodyColor, lightColor)
		if state == "success" then
			if not compareTables(bodyColor, vehicleColor) then
				vehicleColor = bodyColor
				startBuyProgress("paint", "Festés...")
			end

			if not compareTables(lightColor, vehicleLightColor) then
				vehicleLightColor = lightColor
				startBuyProgress("newpart", "Izzó cseréje...")
			end
		end

		buyingInProgress = false
	end)

addEvent("buyLicensePlate", true)
addEventHandler("buyLicensePlate", getRootElement(),
	function (state, value)
		if state == "success" then
			if value then
				originalPlate = value
			end

			startBuyProgress("newpart", "Felszerelés...")
			togglePlateEdit(false)
		end

		buyingInProgress = false
	end)

function startBuyProgress(typ, text)
	if isElement(buyProgressSound) then
		destroyElement(buyProgressSound)
	end

	buyProgressStart = getTickCount()
	buyProgressText = text

	if typ == "newpart" then
		buyProgressDuration = 3565
	elseif typ == "paint" then
		buyProgressDuration = 4500
	end

	--buyProgressSound = playSound("files/sounds/" .. typ .. ".mp3", false)
end

function installPreviewTuning()
	local currentMenu = tuningContainer[selectedMenu].subMenu[selectedSubMenu]
	local currentSelection = currentMenu.subMenu[selectionSubLevel]

	if currentMenu.removeableComponent then
		if currentSelection.value == "removecomponent" then
			setVehicleComponentVisible(vehicleElement, currentMenu.removeableComponent, false)
		else
			setVehicleComponentVisible(vehicleElement, currentMenu.removeableComponent, true)
		end
		previewComponent = true
	end

	if currentMenu.upgradeSlot then
		local upgrade = getVehicleUpgradeOnSlot(vehicleElement, currentMenu.upgradeSlot)

		if upgrade and upgrade > 0 then
			removeVehicleUpgrade(vehicleElement, upgrade)

			if not originalUpgrade then
				originalUpgrade = upgrade
			end
		elseif not originalUpgrade then
			originalUpgrade = 0
		end

		if currentSelection.value and currentSelection.value > 0 then
			addVehicleUpgrade(vehicleElement, currentMenu.subMenu[selectionSubLevel].value)
		end
	end

	if currentMenu.id == "handling" and currentMenu.handlingPrefix then
		if not originalHandling then
			originalHandling = getVehicleHandling(vehicleElement)["handlingFlags"]
		end

		if currentSelection.value then
			local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicleElement)

			for flag in pairs(flagsKeyed) do
				if string.find(flag, currentMenu.handlingPrefix) then
					flagBytes = flagBytes - handlingFlags[flag]
				end
			end

			if currentSelection.value ~= "NORMAL" then
				flagBytes = flagBytes + handlingFlags[currentMenu.handlingPrefix .. currentSelection.value]
			end

			triggerServerEvent("setVehicleHandling", localPlayer, "handlingFlags", flagBytes)
		end
	end

	if currentMenu.id == "color" or currentSelection.colorPicker then
		setVehicleColor(vehicleElement, vehicleColor[1], vehicleColor[2], vehicleColor[3], vehicleColor[4], vehicleColor[5], vehicleColor[6], vehicleColor[7], vehicleColor[8], vehicleColor[9], vehicleColor[10], vehicleColor[11], vehicleColor[12])
		setVehicleHeadLightColor(vehicleElement, vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])
		setElementData(vehicleElement, "vehicleColor", {vehicleColor[1], vehicleColor[2], vehicleColor[3]}, false)
		triggerEvent("resetSpeedoColor", vehicleElement)
	end

	if currentSelection.colorPicker then
		colorPicker = true
		setElementData(vehicleElement, "vehicleColor", {vehicleColor[1], vehicleColor[2], vehicleColor[3]}, false)
		colorX = false
	else
		colorPicker = false
	end

	if currentMenu.id == "neon" then
		if not neonId then
			neonId = getElementData(vehicleElement, "tuning.neon") or 0
		end

		if not neonState then
			neonState = getElementData(vehicleElement, "tuning.neon.state") or 0
		end

		setElementData(vehicleElement, "tuning.neon", currentSelection.value, false)
		setElementData(vehicleElement, "tuning.neon.state", 1, false)
	end

	if currentSelection.isSpinnerItem then
		if colorPicker then
			exports.seal_spinner:setPreviewColor(vehicleElement, colorInputs.r, colorInputs.g, colorInputs.b)
			exports.seal_spinner:previewSpinner(vehicleElement, currentSelection.value, true)
		else
			exports.seal_spinner:previewSpinner(vehicleElement, currentSelection.value)
		end
	end

	if isElement(previewBlockObject) then
		destroyElement(previewBlockObject)
	end
	
	previewBlockObject = nil

	if currentSelection.supercharger then
		local vehicleModel = getElementModel(vehicleElement)

		if blockOffsets[vehicleModel] then
			local x, y, z = blockOffsets[vehicleModel][1], blockOffsets[vehicleModel][2], blockOffsets[vehicleModel][3]
			previewBlockObject = createObject(3272, 0, 0, 0)
			
			attachElements(previewBlockObject, vehicleElement, x, y, z)
			setElementCollisionsEnabled(previewBlockObject, false)
			setElementDimension(previewBlockObject, getElementDimension(vehicleElement))
			setElementInterior(previewBlockObject, getElementInterior(vehicleElement))
			
			local x, y, z = getElementPosition(vehicleElement)

			setElementPosition(vehicleElement, x, y, z + 0.01)
			setElementPosition(vehicleElement, x, y, z)
		end
	end

	if currentMenu.id == "door" then
		if not originalDoor then
			originalDoor = getElementData(vehicleElement, "vehicle.tuning.DoorType") or 0
		end

		setElementData(vehicleElement, "vehicle.tuning.DoorType", currentSelection.value, false)

		if not currentSelection.value then
			setVehicleDoorOpenRatio(vehicleElement, 2, 0, 500)
			setVehicleDoorOpenRatio(vehicleElement, 3, 0, 500)
		else
			setVehicleDoorOpenRatio(vehicleElement, 2, 1, 500)
			setVehicleDoorOpenRatio(vehicleElement, 3, 1, 500)
		end
	end

	if currentMenu.id == "paintjob" then
		if not originalPaintjob then
			originalPaintjob = getElementData(vehicleElement, "vehicle.tuning.Paintjob")
		end

		if currentSelection.value then
			--exports.seal_paintjob:applyPaintJob(currentSelection.value, false)
		end
	end

	if currentMenu.id == "platina" then
		if not originalPlatina then
			originalPlatina = getElementData(vehicleElement, "vehicle.tuning.Platina")
		end

		if currentSelection.value then
			exports.seal_platina:applyPaintJob(currentSelection.value, false)
		end
	end

	if currentMenu.id == "wheelPaintjob" then
		if not originalWheelPaintjob then
			originalWheelPaintjob = getElementData(vehicleElement, "vehicle.tuning.WheelPaintjob")
		end

		if currentSelection.value then
			setElementData(vehicleElement, "vehicle.tuning.WheelPaintjob", currentSelection.value, false)
		end
	end

	if currentMenu.id == "headlight" then
		if not originalHeadLight then
			originalHeadLight = getElementData(vehicleElement, "vehicle.tuning.HeadLight")
		end

		if currentSelection.value then
			exports.seal_headlight:applyHeadLight(currentSelection.value, false)
		end
	end

	if currentSelection.licensePlate then
		togglePlateEdit(true)
	else
		togglePlateEdit(false)
	end

	if currentMenu.hornSound then
		if isElement(previewHorn) then
			destroyElement(previewHorn)
		end

		if currentSelection.value > 0 then
			previewHorn = playSound(":seal_customhorn/horns/" .. currentSelection.value .. ".wav")
			setSoundEffectEnabled(previewHorn, "reverb", true)
		end
	end
end

function restorePreviewTuning()
	local currentMenu = tuningContainer[selectedMenu].subMenu[selectedSubMenu]

	if previewComponent then
		previewComponent = false
	end
	

	if currentMenu.upgradeSlot then
		local upgrade = getVehicleUpgradeOnSlot(vehicleElement, currentMenu.upgradeSlot)

		if upgrade and upgrade > 0 then
			removeVehicleUpgrade(vehicleElement, upgrade)
		end

		if originalUpgrade and originalUpgrade > 0 then
			addVehicleUpgrade(vehicleElement, originalUpgrade)
		end
	end

	if currentMenu.id == "handling" and originalHandling then
		triggerServerEvent("setVehicleHandling", localPlayer, "handlingFlags", originalHandling)
	end

	if currentMenu.id == "neon" then
		if neonState then
			setElementData(vehicleElement, "tuning.neon.state", neonState)
			neonState = false
		end

		if neonId then
			setElementData(vehicleElement, "tuning.neon", neonId)
			neonId = false
		end
	end

	if currentMenu.isSpinner then
		exports.seal_spinner:resetSpinner(vehicleElement)
	end

	if currentMenu.id == "door" then
		setVehicleDoorOpenRatio(vehicleElement, 2, 0, 500)
		setVehicleDoorOpenRatio(vehicleElement, 3, 0, 500)

		if not originalDoor or originalDoor == 0 then
			setElementData(vehicleElement, "vehicle.tuning.DoorType", false, false)
		else
			setElementData(vehicleElement, "vehicle.tuning.DoorType", originalDoor, false)
		end
	end

	if currentMenu.id == "paintjob" then
		--setElementData(vehicleElement, "vehicle.tuning.Paintjob", originalPaintjob, false)
	end

    if currentMenu.id == "platina" then
        setElementData(vehicleElement, "vehicle.tuning.Platina", originalPlatina)
    end

	if currentMenu.id == "wheelPaintjob" then
		setElementData(vehicleElement, "vehicle.tuning.WheelPaintjob", originalWheelPaintjob)
	end

	if currentMenu.id == "headlight" then
		setElementData(vehicleElement, "vehicle.tuning.HeadLight", originalHeadLight)
	end

	if isElement(previewBlockObject) then
		destroyElement(previewBlockObject)
	end

	if isElement(previewHorn) then
		destroyElement(previewHorn)
	end

	previewHorn = nil
	previewBlockObject = nil
	originalUpgrade = false
	originalHandling = false
	originalDoor = false
	originalPaintjob = false
	originalWheelPaintjob = false
	originalHeadLight = false
    originalPlatina = false
end

function formatNumber(amount, stepper)
	if not tonumber(amount) then return amount end
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function rotateAround(angle, x1, y1, x2, y2)
	angle = math.rad(angle)

	local rotatedX = x1 * math.cos(angle) - y1 * math.sin(angle)
	local rotatedY = x1 * math.sin(angle) + y1 * math.cos(angle)

	return rotatedX + (x2 or 0), rotatedY + (y2 or 0)
end

function setCameraMatrixRotated(x, y, z, cx, cy, cz)
	camPosition = {x, y, z, cx, cy, cz}

	if not tonumber(camRotation) then
		camRotation = 0
	end

	if not tonumber(camOffsetZ) then
		camOffsetZ = 0
	end

	if not tonumber(camZoomLevel) then
		camZoomLevel = 1
	end

	x, y = rotateAround(camRotation + 10, x - cx, y - cy, cx, cy)

	setCameraMatrix(x, y, z + camOffsetZ, cx, cy, cz, 0, 70 / (camZoomLevel or 1))
end

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		if panelState then
			local vehPosition = {getElementPosition(vehicleElement)}
			local vehRotation = {0, 0, 270}
			local rotatedX, rotatedY = rotateAround(vehRotation[3], 5, 5)

			camDefPos = {vehPosition[1] + rotatedX, vehPosition[2] + rotatedY, vehPosition[3] + 2.5, vehPosition[1], vehPosition[2], vehPosition[3]}
			camPosition = camDefPos
			camTargetPos = camPosition

			if not tonumber(camRotation) then
				camRotation = 0
			end

			if not tonumber(camOffsetZ) then
				camOffsetZ = 0
			end

			if getKeyState("mouse1") and not customBackfirePanel and not customTurboPanel and not customWheelPanel and not camMoveStart and not isMTAWindowActive() and not isColorPicking and not isLuminancePicking then
				local cursorX, cursorY = getCursorPositionEx()

				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY, camRotation, camOffsetZ}
				end
				
				camRotation = lastCursorPos[3] - (cursorX - lastCursorPos[1]) / screenX * 270
				camOffsetZ = lastCursorPos[4] + (cursorY - lastCursorPos[2]) / screenY * 10
				
				if camRotation > 360 then
					camRotation = camRotation - 360
				elseif camRotation < 0 then
					camRotation = camRotation + 360
				end
				
				if camOffsetZ < -0.9 then
					camOffsetZ = -0.9
				elseif camOffsetZ > 0.9 then
					camOffsetZ = 0.9
				end
			else
				lastCursorPos = false
			end

			if camZoomStart and not camMoveStart then
				local progress = (getTickCount() - camZoomStart) / 150

				camZoomLevel = interpolateBetween(
					camZoomInterpolation[1], 0, 0,
					camZoomInterpolation[2], 0, 0,
					progress, "InOutQuad"
				)
				
				if progress >= 1 then
					camZoomStart = false
				end
			end

			if camMoveStart then
				local progress = (getTickCount() - camMoveStart) / 600
				
				local x, y, z = interpolateBetween(
					camStartPos[1], camStartPos[2], camStartPos[3],
					camTargetPos[1], camTargetPos[2], camTargetPos[3],
					progress, "InOutQuad"
				)

				local cx, cy, cz = interpolateBetween(
					camStartPos[4], camStartPos[5], camStartPos[6],
					camTargetPos[4], camTargetPos[5], camTargetPos[6],
					progress, "InOutQuad"
				)
				
				camOffsetZ, camZoomLevel = interpolateBetween(
					camStartPos[8], camStartPos[9], 0,
					0, 1, 0,
					progress, "InOutQuad"
				)

				camRotation = getShortestAngle(camStartPos[7], 0, getEasingValue(progress, "InOutQuad"))
				
				setCameraMatrixRotated(x, y, z, cx, cy, cz)
				
				if progress >= 1 then
					camMoveStart = false
					camZoomStart = false
				end
			else
				setCameraMatrixRotated(unpack(camPosition))
			end
		end
	end)

function getShortestAngle(start, stop, amount)
		local shortest_angle = ((((stop - start) % 360) + 540) % 360) - 180
		return start + (shortest_angle * amount) % 360
end

function shallowcopy(t)
	if type(t) ~= "table" then
		return t
	end
	
	local target = {}

	for k, v in pairs(t) do
		target[k] = v
	end

	return target
end

function changeCamera(view)
	if not view or camView == view then
		return
	end
	
	local component = string.gsub(view, "_excomp", "")
	
	camStartPos = shallowcopy(camPosition)
	camStartPos[7] = camRotation
	camStartPos[8] = camOffsetZ
	camStartPos[9] = camZoomLevel
	
	if view == "base" then
		camTargetPos = camDefPos
	elseif view == "lightpaint" then
		local vehPosX, vehPosY, vehPosZ = getElementPosition(vehicleElement)
		local vehRotX, vehRotY, vehRotZ = getElementRotation(vehicleElement)
		local rotatedX, rotatedY = rotateAround(vehRotZ, 0, 10)
		
		camTargetPos = {vehPosX + rotatedX, vehPosY + rotatedY, vehPosZ, vehPosX, vehPosY, vehPosZ}
	elseif component then
		if getVehicleComponents(vehicleElement)[component] then
			local componentX, componentY, componentZ = getVehicleComponentPosition(vehicleElement, component, "world")
			local vehRotX, vehRotY, vehRotZ = getElementRotation(vehicleElement)

			local offsets = componentOffsets[view]
			local x, y = rotateAround(vehRotZ, offsets[1], offsets[2], componentX, componentY)
			local cx, cy = rotateAround(vehRotZ, offsets[4], offsets[5], componentX, componentY)

			camTargetPos = {x, y, componentZ + offsets[3], cx, cy, componentZ + offsets[6]}
		end
	end
	
	if view == "base" then
		for k in pairs(getVehicleComponents(vehicleElement)) do
			setVehicleComponentVisible(vehicleElement, k, true)
		end
		previewComponent = false
		--exports.seal_drm:hideComponent(vehicleElement)
	else
		local component = tuningContainer[selectedMenu].subMenu[selectedSubMenu].hideComponent

		if component then
			setVehicleComponentVisible(vehicleElement, component, false)
			previewComponent = true
		end
	end
	
	if view ~= camView then
		playSound("files/sounds/cammove.mp3")
	end
	
	camMoveStart = getTickCount()
	camView = view
end

--local getCursorPositionEx = getCursorPosition
function getCursorPositionEx()
	if isCursorShowing() then
		local cursorX, cursorY = getCursorPosition()
		return cursorX * screenX, cursorY * screenY
	else
		return 0, 0
	end
end

addCommandHandler("setvehcolor", function(cmd, color1, color2, color3, color4, color5, color6)
    if getElementData(localPlayer, "acc.adminLevel") > 7 then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if vehicle then
            if not color1 or not  color2 or not color3 then
                outputChatBox("#85aac7[SealMTA] #ffffffAdj meg egy színkódot [pl.: 255,255,255], ha a felnit is szeretned színezni [pl.:255,255,255,255,255,255]", 255, 255, 255, true)
            else
				vehicleColor = {getVehicleColor(vehicle, true)}
                local color1 = tonumber(color1) or 0
                local color2 = tonumber(color2) or 0
                local color3 = tonumber(color3) or 0
                local color4 = tonumber(color4) or vehicleColor[4]
                local color5 = tonumber(color5) or vehicleColor[5]
                local color6 = tonumber(color6) or vehicleColor[6]
                setVehicleColor(vehicle, color1, color2, color3, color4, color5, color6)		
                outputChatBox("#4adfbf[SealMTA] #ffffffSikeresen ráhelyezted a platinát a járgányra.", 255, 255, 255, true)
            end
        end
    end
end)

function reopen()
	panelState = true
end

local controlTable = { "fire", "aim_weapon", "next_weapon", "previous_weapon", "forwards", "backwards", "left", "right", "zoom_in", "zoom_out",
"change_camera", "jump", "sprint", "look_behind", "crouch", "action", "walk", "conversation_yes", "conversation_no",
"group_control_forwards", "group_control_back", "enter_exit", "vehicle_fire", "vehicle_secondary_fire", "vehicle_left", "vehicle_right",
"steer_forward", "steer_back", "accelerate", "brake_reverse", "radio_next", "radio_previous", "radio_user_track_skip", "horn", "sub_mission",
"handbrake", "vehicle_look_left", "vehicle_look_right", "vehicle_look_behind", "vehicle_mouse_look", "special_control_left", "special_control_right",
"special_control_down", "special_control_up" }

			exports.seal_controls:toggleControl({"jump", "fire", "aim_weapon", }, true)

local disabledState = false
addEventHandler("onClientElementDimensionChange", localPlayer,
	function(_, newDim)
		if disabledState then
			exports.seal_controls:toggleControl({"enter_exit", "enter_passenger"}, true)
		end
		if getPedOccupiedVehicle(localPlayer) then
			if newDim == getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.dbID")+100 then
				disabledState = true
				exports.seal_controls:toggleControl({"enter_exit", "enter_passenger"}, false)
			end
		end
	end
)

local streamedVehicles = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	for id, vehicle in pairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(vehicle) then
			local componentData = getElementData(vehicle, "vehicle.modifiedComponents")
			
			if componentData then
				streamedVehicles[vehicle] = componentData
			end
		end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
	if getElementType(source) == "vehicle" then
		if isElementStreamedIn(source) and dataName == "vehicle.modifiedComponents" then
			local componentData = getElementData(source, "vehicle.modifiedComponents")
			
			if componentData then
				streamedVehicles[source] = componentData
			else
				streamedVehicles[source] = nil
				collectgarbage("collect")
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		local componentData = getElementData(source, "vehicle.modifiedComponents")

		if componentData then
			streamedVehicles[source] = componentData
		else
			streamedVehicles[source] = nil
			collectgarbage("collect")
		end
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if streamedVehicles[source] then
		streamedVehicles[source] = nil
		collectgarbage("collect")
	end	
end)

addEventHandler("onClientPreRender", getRootElement(), function()
	if previewComponent then
		return
	end

	for vehicle, data in pairs(streamedVehicles) do
		if isElement(vehicle) and data then
			for component, state in pairs(data) do
				setVehicleComponentVisible(vehicle, component, state)
			end
		end
	end
end)

local tuningMusic = false
local tuningAmbient1 = false
local tuningAmbient2 = false

addEvent("syncTuningSound", true)
addEventHandler("syncTuningSound", getRootElement(), function(dim, int)
	if getElementData(source, "inTuning") then
		if isElement(tuningAmbient1) then
			destroyElement(tuningAmbient1)
		end

		tuningAmbient1 = playSound3D("files/ambient1.mp3", 1129.4575195312, -1536.1231689453, 452.5546875, true)
		setSoundVolume(tuningAmbient1, 0.5)
		setSoundMaxDistance(tuningAmbient1, 150)
		setSoundEffectEnabled(tuningAmbient1, "i3dl2reverb", true)
		setElementDimension(tuningAmbient1, dim)
		setElementInterior(tuningAmbient1, int)
		setSoundPosition(tuningAmbient1, math.random(getSoundLength(tuningAmbient1)))

		if isElement(tuningAmbient2) then
			destroyElement(tuningAmbient2)
		end

		tuningAmbient2 = playSound3D("files/ambient2.mp3", 1125.0988769531, -1583.9466552734, 452.56170654297, true)
		setSoundVolume(tuningAmbient2, 0.5)
		setSoundMaxDistance(tuningAmbient2, 150)
		setSoundEffectEnabled(tuningAmbient2, "i3dl2reverb", true)
		setElementDimension(tuningAmbient2, dim)
		setElementInterior(tuningAmbient2, int)
		setSoundPosition(tuningAmbient2, math.random(getSoundLength(tuningAmbient2)))

		if isElement(tuningMusic) then
			destroyElement(tuningMusic)
		end

		tuningMusic = playSound("files/music.mp3")
		setSoundVolume(tuningMusic, 0.2)
		setSoundEffectEnabled(tuningMusic, "i3dl2reverb", true)
	end
end)

addEvent("destroyTuningSound", true)
addEventHandler("destroyTuningSound", getRootElement(), function()
	if isElement(tuningAmbient1) then
		destroyElement(tuningAmbient1)
	end
	
	if isElement(tuningAmbient2) then
		destroyElement(tuningAmbient2)
	end

	if isElement(tuningMusic) then
		destroyElement(tuningMusic)
	end

	tuningMusic = false
	tuningAmbient1 = false
	tuningAmbient2 = false
end)

addEvent("removeCustomWheel", true)
addEventHandler("removeCustomWheel", getRootElement(), function(vehicleElement)
	if isElement(vehicleElement) then
		setElementData(vehicleElement, "vehicle.tuning.wheelsFront", false)
		setElementData(vehicleElement, "vehicle.tuning.wheelsBack", false)
	end
end)