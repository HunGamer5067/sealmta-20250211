local screenX, screenY = guiGetScreenSize()
local isWatermarkEnabled = true
local watermarkLabel = false


local logoImage = dxCreateTexture("files/logo.png", "argb", true, "clamp")
dxSetTextureEdge(logoImage, "border", 0x00000000)

function getServerLogo()
	return logoImage
end

addCommandHandler("togwatermark",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 9 then
			isWatermarkEnabled = not isWatermarkEnabled

			if isWatermarkEnabled then
				createWatermark()
			else
				destroyWatermark()
			end
		end
	end)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setHeatHaze(0)
		setBlurLevel(0)
		setCloudsEnabled(false)

		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)

		setWorldSpecialPropertyEnabled("randomfoliage", false)
		setWorldSpecialPropertyEnabled("extraairresistance", false)

		setAmbientSoundEnabled("general", true)
		setAmbientSoundEnabled("gunfire", false)

		for k, v in ipairs(getElementsByType("player")) do
			setPedVoice(v, "PED_TYPE_DISABLED")
			setPlayerNametagShowing(v, false)
		end

		for k, v in ipairs(getElementsByType("ped")) do
			setPedVoice(v, "PED_TYPE_DISABLED")
		end

		setTimer(
			function ()
				toggleControl("next_weapon", false)
				toggleControl("previous_weapon", false)
			end,
		1000, 0)

		if isWatermarkEnabled then
			createWatermark()
		end
	end)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "ped" or getElementType(source) == "player" then
			setPedVoice(source, "PED_TYPE_DISABLED")
		end
	end)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName)
		if dataName == "loggedIn" then
			if isWatermarkEnabled then
				updateWatermark()
			end
		end
	end)

function destroyWatermark()
	if isElement(watermarkLabel) then
		destroyElement(watermarkLabel)
	end
	watermarkLabel = nil
end

function createWatermark()
	destroyWatermark()

	watermarkLabel = guiCreateLabel(0, screenY - 25, screenX - 70, 24, "", false)

	if isElement(watermarkLabel) then
		guiLabelSetVerticalAlign(watermarkLabel, "bottom")
		guiLabelSetHorizontalAlign(watermarkLabel, "right")
		guiSetAlpha(watermarkLabel, 0.5)
		updateWatermark()
	end
end

function updateWatermark()
	if isElement(watermarkLabel) then
		local time = getRealTime()
		local date = string.format("%04d.%02d.%02d", time.year + 1900, time.month + 1, time.monthday)
		local str = "SealMTA"

		if getElementData(localPlayer, "loggedIn") then
			str = str .. " | Account ID: " .. getElementData(localPlayer, "char.accID")
		end

		str = str .. " | " .. date .. " | "

		guiSetText(watermarkLabel, str)
	end
end

addEventHandler("onClientPlayerJoin", getRootElement(),
	function ()
		setPlayerNametagShowing(source, false)
	end)

addEventHandler("onClientGUIBlur", getRootElement(),
	function ()
		guiSetInputMode("no_binds_when_editing")
	end)

function findPlayer(sourcePlayer, partialNick, noPrintTheChat)
	if not partialNick and not isElement(sourcePlayer) and type(sourcePlayer) == "string" then
		partialNick = sourcePlayer
		sourcePlayer = nil
	end

	local candidates = {}
	local matchPlayer = nil
	local matchNickAccuracy = -1

	partialNick = string.lower(partialNick)

	if sourcePlayer and partialNick == "*" then
		return sourcePlayer, string.gsub(getPlayerName(sourcePlayer), "_", " ")
	elseif tonumber(partialNick) then
		local players = getElementsByType("player")

		for i = 1, #players do
			local player = players[i]

			if isElement(player) then
				if getElementData(player, "loggedIn") then
					if getElementData(player, "playerID") == tonumber(partialNick) then
						matchPlayer = player
						break
					end
				end
			end
		end

		candidates = {matchPlayer}
	else
		local players = getElementsByType("player")

		partialNick = string.gsub(partialNick, "-", "%%-")

		for i = 1, #players do
			local player = players[i]

			if isElement(player) then
				local playerName = getElementData(player, "visibleName")

				if not playerName then
					playerName = getPlayerName(player)
				end

				playerName = string.gsub(playerName, "_", " ")
				playerName = string.lower(playerName)

				if playerName then
					local startPos, endPos = string.find(playerName, tostring(partialNick))

					if startPos and endPos then
						if endPos - startPos > matchNickAccuracy then
							matchNickAccuracy = endPos - startPos
							matchPlayer = player
							candidates = {player}
						elseif endPos - startPos == matchNickAccuracy then
							matchPlayer = nil
							table.insert(candidates, player)
						end
					end
				end
			end
		end
	end

	if not matchPlayer or not isElement(matchPlayer) then
		if noPrintTheChat then
			return
		end
		if #candidates == 0 then
			showMessageToPlayer(false, "A kiválasztott játékos nem található.", "error")

		else
			outputChatBox("#4adfbf[SealMTA]: #ffffffEzzel a névrészlettel #4adfbf" .. #candidates .. " db #ffffffjátékos található:", 255, 255, 255, true)

			for i = 1, #candidates do
				local player = candidates[i]

				if isElement(player) then
					local playerId = getElementData(player, "playerID")
					local playerName = string.gsub(getPlayerName(player), "_", " ")

					outputChatBox("#4adfbf    (" .. tostring(playerId) .. ") #ffffff" .. playerName, 255, 255, 255, true)
				end
			end
		end

		return false
	else
		if getElementData(matchPlayer, "loggedIn") then
			local playerName = getElementData(matchPlayer, "visibleName")

			if not playerName then
				playerName = getPlayerName(matchPlayer)
			end

			return matchPlayer, string.gsub(playerName, "_", " ")
		else
			showMessageToPlayer(false, "A kiválasztott játékos nincs bejelentkezve.", "error")
			return false
		end
	end
end


function isInSlot(x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end
	local sx, sy = guiGetScreenSize()
	local cx, cy = getCursorPosition()
	local cx, cy = (cx*sx), (cy*sy)	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function drawText(text, x, y, w, h, color, size, font)
    dxDrawText(text, x + w / 2 , y + h / 2, x + w / 2, y + h / 2, color, size, font, "center", "center", false, false, false, true)
end

addEvent("onCoreStarted", true)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function()
		triggerEvent("onCoreStarted", localPlayer, interfaceFunctions())
	end
)


--[[

*********** Interface elementek meghívása (szkriptek elejére): ***********

	pcall(loadstring(base64Decode(exports.seal_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.seal_core:getInterfaceElements())));end)

*********** Szükséges elemek onClientRender-be: ***********
	
	buttons = {}

	-- ide jön a te kódod, e két kis rész közé.
	-- csekkolni, hogy aktív-e a gomb: if activeButton == "gombNeve" then

	local relX, relY = getCursorPosition()

	activeButton = false

	if relX and relY then
		relX = relX * screenX
		relY = relY * screenY

		for k, v in pairs(buttons) do
			if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end

]]

function interfaceFunctions()
	return {"colorInterpolation", "drawButton", "drawInput", "drawButton2"}
end

local wErTzu666iop = base64Encode
function getInterfaceElements()
	return wErTzu666iop([[

	buttons = {}
	activeButton = false

	local inputLineGetStart = {}
	local inputLineGetInverse = {}

	local inputCursorState = false
	local lastChangeCursorState = 0

	local repeatTimer = false
	local repeatStartTimer = false

	fakeInputs = {}
	selectedInput = false

	function drawInput(key, label, x, y, sx, sy, font, fontScale, a)
		a = a or 1

		if not fakeInputs[key] then
			fakeInputs[key] = ""
		end

		dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 75 * a))

		local borderColor

		if selectedInput == key then
			borderColor = {colorInterpolation("input:" .. key, 117, 117, 117, 255)}
		elseif activeButton == "input:" .. key then
			borderColor = {colorInterpolation("input:" .. key, 117, 117, 117, 255)}
		else
			borderColor = {colorInterpolation("input:" .. key, 75, 75, 75, 255)}
		end

		if selectedInput == key then
			if not inputLineGetStart[key] then
				inputLineGetInverse[key] = false
				inputLineGetStart[key] = getTickCount()
			end
		elseif inputLineGetStart[key] then
			inputLineGetInverse[key] = getTickCount()
			inputLineGetStart[key] = false
		end

		local lineProgress = 0

		if inputLineGetStart[key] then
			local elapsedTime = getTickCount() - inputLineGetStart[key]
			local progress = elapsedTime / 300

			lineProgress = interpolateBetween(
				0, 0, 0,
				1, 0, 0,
				progress, "Linear")
		elseif inputLineGetInverse[key] then
			local elapsedTime = getTickCount() - inputLineGetInverse[key]
			local progress = elapsedTime / 300

			lineProgress = interpolateBetween(
				1, 0, 0,
				0, 0, 0,
				progress, "Linear")
		end

		lineProgress = sx / 2 * lineProgress

		local activeColor = tocolor(36, 119, 159, 255 * a)
		--dxDrawRectangle(x, y + sy - 2, sx, 2, tocolor(borderColor[1], borderColor[2], borderColor[3], borderColor[4] * a))
		--dxDrawRectangle(x + sx / 2, y + sy - 2, -lineProgress, 2, activeColor)
		--dxDrawRectangle(x + sx / 2, y + sy - 2, lineProgress, 2, activeColor)

		sy = sy - 2

		if utf8.len(fakeInputs[key]) > 0 then
			dxDrawText(fakeInputs[key], x + 3, y, x + sx - 3, y + sy, tocolor(255, 255, 255, 230 * a), fontScale, font, "left", "center", true)
		elseif label then
			dxDrawText(label, x + 3, y, x + sx - 3, y + sy, tocolor(100, 100, 100, 200 * a), fontScale, font, "left", "center", true)
		end

		if selectedInput == key then
			if inputCursorState then
				local contentSizeX = dxGetTextWidth(fakeInputs[key], fontScale, font)

				dxDrawLine(x + 3 + contentSizeX, y + 5, x + 3 + contentSizeX, y + sy - 5, tocolor(230, 230, 230, 255 * a))
			end

			if getTickCount() - lastChangeCursorState >= 500 then
				inputCursorState = not inputCursorState
				lastChangeCursorState = getTickCount()
			end
		end

		buttons["input:" .. key] = {x, y, sx, sy}
	end



		colorSwitches = {}
		lastColorSwitches = {}
		startColorSwitch = {}
		lastColorConcat = {}
		
		function processColorSwitchEffect(key, color, duration, type)
			if not colorSwitches[key] then
				if not color[4] then
					color[4] = 255
				end
		
				colorSwitches[key] = color
				lastColorSwitches[key] = color
		
				lastColorConcat[key] = table.concat(color)
			end
		
			duration = duration or 3000
			type = type or "Linear"
		
			if lastColorConcat[key] ~= table.concat(color) then
				lastColorConcat[key] = table.concat(color)
				lastColorSwitches[key] = color
				startColorSwitch[key] = getTickCount()
			end
		
			if startColorSwitch[key] then
				local progress = (getTickCount() - startColorSwitch[key]) / duration
		
				local r, g, b = interpolateBetween(
						colorSwitches[key][1], colorSwitches[key][2], colorSwitches[key][3],
						color[1], color[2], color[3],
						progress, type
				)
		
				local a = interpolateBetween(colorSwitches[key][4], 0, 0, color[4], 0, 0, progress, type)
		
				colorSwitches[key][1] = r
				colorSwitches[key][2] = g
				colorSwitches[key][3] = b
				colorSwitches[key][4] = a
		
				if progress >= 1 then
					startColorSwitch[key] = false
				end
			end
		
			return colorSwitches[key][1], colorSwitches[key][2], colorSwitches[key][3], colorSwitches[key][4]
		end

		local alpha = 1
		
		function rgba(r, g, b, a)
			return tocolor(r, g, b, (a or 255) * alpha)
		end
		
		function drawButton(key, label, x, y, w, h, activeColor, postGui, theFont, rgbaoff, labelScale)
			local buttonColor
			if activeButton == key then
				if getKeyState("mouse1") then
					buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], (activeColor[4] or 255) - 65}, 500)}
				else
					buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], (activeColor[4] or 255)}, 500)}
				end
			else
				buttonColor = {processColorSwitchEffect(key, {activeColor[1], activeColor[2], activeColor[3], (activeColor[4] or 255) - 65}, 500)}
			end
		
			postGui = postGui or false
			labelScale = labelScale or 1
			
			if rgbaoff then
				dxDrawRectangle(x, y, w, h, tocolor(buttonColor[1], buttonColor[2], buttonColor[3], buttonColor[4]))
				dxDrawText(label, x, y, x + w, y + h, tocolor(255, 255, 255, (activeColor[4] or 255)), labelScale, theFont, "center", "center", false, false, false, true)
			else
				dxDrawRectangle(x, y, w, h, rgba(buttonColor[1], buttonColor[2], buttonColor[3], buttonColor[4]))
				dxDrawText(label, x, y, x + w, y + h, rgba(255, 255, 255, (activeColor[4] or 255)), labelScale, theFont, "center", "center", false, false, false, true)
			end
		
			buttons[key] = {x, y, w, h}
		end
		
		function dxDrawInnerBorder(thickness, x, y, w, h, color, postGUI)
			thickness = thickness or 1
			dxDrawRectangle(x, y, w, thickness, color, postGUI)
			dxDrawRectangle(x, y + h - thickness, w, thickness, color, postGUI)
			dxDrawRectangle(x, y, thickness, h, color, postGUI)
			dxDrawRectangle(x + w - thickness, y, thickness, h, color, postGUI)
		end

		-----------edit box----------------------

		local sx, sy = guiGetScreenSize()
		local screenX, screenY = guiGetScreenSize()
		local edits = {}

		function reMap(value, low1, high1, low2, high2)
			return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
		end
		
		screenX, screenY = guiGetScreenSize()
		responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)
		
		function resp(num)
			return num * responsiveMultipler
		end
		
		function respc(num)
			return math.ceil(num * responsiveMultipler)
		end

		local RubikL = dxCreateFont(":seal_core/files/Rubik.ttf", respc(15))



		function dxCreateEdit(name, text, defaultText, x, y, w, h, font, type)
			local id = #edits + 1
			edits[id] = {name, text, defaultText, x, y, w, h, font, type, false, 0, 0, 00, getTickCount()}
			return id
		end

		local numbers = {
			["0"] = true,
			["1"] = true,
			["2"] = true,
			["3"] = true,
			["4"] = true,
			["5"] = true,
			["6"] = true,
			["7"] = true,
			["8"] = true,
			["9"] = true,
		}
		
		function editBoxesKey(button, state)
			if button == "mouse1" and state and isCursorShowing() then
				for k, v in pairs(edits) do
					local name, text, defaultText, x, y, w, h, font, type, active, tick = unpack(v)
					if not active then
						if isMouseInPosition(x, y, w, h) then
							edits[k][10] = true
							edits[k][11] = getTickCount()
						end
					else
						edits[k][10] = false
						edits[k][11] = getTickCount()
					end
				end
			end
		
			if button == "tab" and state and isCursorShowing() then
				if dxGetActiveEdit() then
					local nextGUI = dxGetActiveEdit()+1
					if edits[nextGUI] then
						local current = dxGetActiveEdit()
						edits[current][10] = false
						edits[current][11] = getTickCount()
		
						edits[nextGUI][10] = true
						edits[nextGUI][11] = getTickCount()
					else
						local current = dxGetActiveEdit()
						edits[current][10] = false
						edits[current][11] = getTickCount()
		
						edits[1][10] = true
						edits[1][11] = getTickCount()
					end
				end
				cancelEvent()
			end
		
			for k, v in pairs(edits) do
				local name, text, defaultText, x, y, w, h, font, type, active, tick, w2 = unpack(v)
				if active then
					if not getKeyState("v") and not getKeyState("lctrl") then
						cancelEvent()
					end
				end
			end
		end
		
		function editBoxesCharacter(key)
			if isCursorShowing() then
				for k, v in pairs(edits) do
					local name, text, defaultText, x, y, w, h, font, type, active, tick, w2 = unpack(v)
					if active then
						if type == 2 then
							if numbers[key] then  
								edits[k][2] = edits[k][2] .. key
							end
						else
							edits[k][2] = edits[k][2] .. key
						end
					end
				end
			end
		end
		
		function isMouseInPosition(x, y, w, h)
			if not isCursorShowing() then 
				return 
			end
			local pos = {getCursorPosition()}
			pos[1], pos[2] = (pos[1] * sx), (pos[2] * sy)
			if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
				return true
			else
				return false
			end
		end
		
		function dxGetActiveEditName()
			local a = false
			for k, v in pairs(edits) do
				local name, text, defaultText, x, y, w, h, font, type, active, tick, w2 = unpack(v)
				if active then
					a = name
					break
				end
			end
			return a
		end
		
		function dxGetActiveEdit()
			local a = false
			for k, v in pairs(edits) do
				local name, text, defaultText, x, y, w, h, font, type, active, tick, w2 = unpack(v)
				if active then
					a = k
					break
				end
			end
			return a
		end
		
		function dxDestroyEdit(id)
			if tonumber(id) then
				if not edits[id] then return false end
				table.remove(edits, id)
				return true
			else
				local edit = dxGetEdit(id)
				if not edits[edit] then 
					return false 
				end
				table.remove(edits, edit)
				return true
			end
		end
		
		function dxEditSetText(id, text)
			if tonumber(id) then
				if not edits[id] then 
					error("Not valid editbox") 
					return false 
				end
		
				edits[id][2] = text
				return true
			else
				local edit = dxGetEdit(id)
				if not edits[edit] then 
					error("Not valid editbox") 
					return false 
				end
				edits[edit][2] = text
				return true
			end
		end
		
		function dxGetEdit(name)
			local found = false
			for k, v in pairs(edits) do
				if v[1] == name then
					found = k
					break
				end
			end
			return found
		end
		
		function dxGetEditText(id)
			if tonumber(id) then
				if not edits[id] then error("Not valid editbox") return false end
				return edits[id][2]
			else
				local edit = dxGetEdit(id)
				if not edits[edit] then error("Not valid editbox") return false end
				return edits[edit][2]
			end
		end
		
		function dxSetEditPosition(id, x, y)
			if tonumber(id) then
				if not edits[id] then error("Not valid editbox") return false end
				edits[id][4] = x
				edits[id][5] = y
				return true
			else
				local edit = dxGetEdit(id)
				if not edits[edit] then error("Not valid editbox") return false end
				edits[edit][4] = x
				edits[edit][5] = y
				return true
			end
		end
		
		function isMouseInPosition(x, y, w, h)
			if not isCursorShowing() then return end
			local pos = {getCursorPosition()}
			pos[1], pos[2] = (pos[1] * screenX), (pos[2] * screenY)
			if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
				return true
			else
				return false
			end
		end

		function renderEditBoxes()
			for k, v in pairs(edits) do
				local name, text, defaultText, x, y, w, h, font, type, active, tick, w2, backState, tickBack = unpack(v)
				local textWidth = dxGetTextWidth(text, 0.7, RubikL, false) or 0
				dxDrawRectangle(x, y, w, h, tocolor(55, 55, 55, 120), true)
				dxDrawInnerBorder(2, x, y, w, h, tocolor(55, 55, 55, 200), true)
				if active then
					edits[k][12] = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()-tick)/200, "Linear")
					dxDrawRectangle(x, y + h - 2, w * w2, 2, tocolor(94, 193, 230), true)
		
					local carretAlpha = interpolateBetween(50, 0, 0, 255, 0, 0, (getTickCount()-tick)/1000, "SineCurve")
					local carretSize = dxGetFontHeight(0.7, RubikL)*2.4
					local carretPosX = textWidth > (w-10) and x + w - 10 or x + textWidth + 5
					dxDrawRectangle(carretPosX + 2, y + 2.5, 2, h - 5, tocolor(200, 200, 200, carretAlpha), true)
		
					if getKeyState("backspace") then
						backState = backState - 1
					else
						backState = 100
					end
					if getKeyState("backspace") and (getTickCount() - tickBack) > backState then
						edits[k][2] = string.sub(text, 1, #text - 1)
						edits[k][14] = getTickCount()
					end
				else
					if w2 > 0 then
						edits[k][12] = interpolateBetween(edits[k][12], 0, 0, 0, 0, 0, (getTickCount()-tick)/200, "Linear")
						dxDrawRectangle(x, y + h - 2, w * w2, 2, tocolor(94, 193, 230), true)
					end
				end
		
				if string.len(text) == 0 or textWidth == 0 then
					dxDrawText(defaultText, x+5, y, w, y+h, tocolor(255, 255, 255, 120), 0.7, RubikL, "left", "center", false, false, true)
				else
					if w > textWidth then
						dxDrawText(text, x+5, y, w, y+h, tocolor(200, 200, 200), 0.7, RubikL, "left", "center", false, false, true)
					else
						dxDrawText(text, x+5, y, x+w-5, y+h, tocolor(200, 200, 200), 0.7, RubikL, "right", "center", true, false, true)
					end
				end
			end
		end


		function drawStrongPanelBottomExit(x, y, h, w, font, buttonFontScale)

			dxDrawRectangle(x, y, h, w, tocolor(25,25,25))
			dxDrawRectangle(x + 3, y + 3, h - 6, respc(40) - 6, tocolor(55, 55, 55, 200))
			dxDrawText("AstralMTA", x + respc(5), y + respc(40) / 2, nil, nil, tocolor(200, 200, 200, 200), 1, font, "left", "center")

			drawButton("exitFromPanel", "Kilépés", x + 3, y + w - respc(40), h - 6, respc(40) - 3, {188, 64, 61}, false, font, true, buttonFontScale)
		end
		local colorInterpolationValues = {}
		local lastColorInterpolationValues = {}
		local colorInterpolationTicks = {}

		function colorInterpolation(key, r, g, b, a, duration)
			if not colorInterpolationValues[key] then
				colorInterpolationValues[key] = {r, g, b, a}
				lastColorInterpolationValues[key] = r .. g .. b .. a
			end

			if lastColorInterpolationValues[key] ~= (r .. g .. b .. a) then
				lastColorInterpolationValues[key] = r .. g .. b .. a
				colorInterpolationTicks[key] = getTickCount()
			end

			if colorInterpolationTicks[key] then
				local progress = (getTickCount() - colorInterpolationTicks[key]) / (duration or 500)
				local red, green, blue = interpolateBetween(colorInterpolationValues[key][1], colorInterpolationValues[key][2], colorInterpolationValues[key][3], r, g, b, progress, "Linear")
				local alpha = interpolateBetween(colorInterpolationValues[key][4], 0, 0, a, 0, 0, progress, "Linear")

				colorInterpolationValues[key][1] = red
				colorInterpolationValues[key][2] = green
				colorInterpolationValues[key][3] = blue
				colorInterpolationValues[key][4] = alpha

				if progress >= 1 then
					colorInterpolationTicks[key] = false
				end
			end

			return colorInterpolationValues[key][1], colorInterpolationValues[key][2], colorInterpolationValues[key][3], colorInterpolationValues[key][4]
		end
	]])
end

addEvent("onHoverButtonPlaySound", true)
addEventHandler("onHoverButtonPlaySound", getRootElement(),
	function()
		playSound("files/hover.wav")
	end
)

local fontCache = {}
local resourceFonts = {}

local function getFontUsedCount(token)
	local count = 0

	for k, v in pairs(resourceFonts) do
		for k2 in pairs(v) do
			if k2 == token then
				count = count + 1
			end
		end
	end

	return count
end

function getFontsDetail()
	local fonts = {}

	for k, v in pairs(fontCache) do
		local subStrings = split(k, "/")
		table.insert(fonts, {subStrings[1], subStrings[2], subStrings[3], subStrings[4], getFontUsedCount(k)})
	end

	return fonts
end

function loadFont(fontName, size, bold, quality)
	if not fileExists("fonts/" .. fontName) then
		print("[dxFont - Error]: Font \""  .. fontName .. "\" not found.")
		return false
	end

	size = size or 14
	quality = quality or "cleartype"

	local token = fontName .. "/" .. size .. "/" .. tostring(bold) .. "/" .. quality

	if not fontCache[token] then
		fontCache[token] = dxCreateFont("fonts/" .. fontName, size, bold, quality)

		if not fontCache[token] then
			if bold then
				fontCache[token] = "default-bold"
			else
				fontCache[token] = "Arial"
			end

			print("[dxFont - Warning]: Font \""  .. fontName .. "\" loading failed. (Not enough VRAM)")
		end
	end

	if not resourceFonts[sourceResource] then
		resourceFonts[sourceResource] = {}
	end

	resourceFonts[sourceResource][token] = true

	return fontCache[token]
end

addEvent("onAssetsLoaded", true)
addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		triggerEvent("onAssetsLoaded", localPlayer)
	end
)

addEventHandler("onClientResourceStop", getRootElement(),
	function (stoppedResource)
		if stoppedResource == resourceRoot then
			for k,v in pairs(fontCache) do
				if isElement(v) then
					destroyElement(v)
				end
				fontCache[k] = nil
			end

			return
		end

		if stoppedResource ~= resourceRoot and resourceFonts[stoppedResource] then
			for k, v in pairs(resourceFonts[stoppedResource]) do
				if getFontUsedCount(k) <= 1 then
					if isElement(fontCache[k]) then
						destroyElement(fontCache[k])
					end
					fontCache[k] = nil
				end
			end
			resourceFonts[stoppedResource] = nil
		end
	end
)

local copterRotorStates = {}
local vehiclePanelStates = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
			vehiclePanelStates[v] = {}

			for i = 0, 6 do
				vehiclePanelStates[v][i] = getElementData(v, "panelState:" .. i)
				setVehiclePanelState(v, i, vehiclePanelStates[v][i] or 0)
			end

			if getVehicleType(v) == "Helicopter" then
				copterRotorStates[v] = getElementData(v, "vehicle.engine")
			end
		end
	end
)

addEventHandler("onClientVehicleDamage", getRootElement(),
	function (attackerElement, weaponId, damageTaken, damagePosX, damagePosY, damagePosZ, tireId)
		if isElement(attackerElement) then
			if getElementData(attackerElement, "tazerState") then
				cancelEvent()
				return
			end
		end

		if attackerElement == localPlayer then
			if not vehiclePanelStates[source] then
				vehiclePanelStates[source] = {}
			end

			for i = 0, 6 do
				local state = getVehiclePanelState(source, i)

				if vehiclePanelStates[source][i] ~= state then
					vehiclePanelStates[source][i] = state
					--setElementData(source, "panelState:" .. i, state)
				end
			end
		elseif not attackerElement then
			if getPedOccupiedVehicle(localPlayer) == source then
				if getPedOccupiedVehicleSeat(localPlayer) == 0 then
					if not vehiclePanelStates[source] then
						vehiclePanelStates[source] = {}
					end

					for i = 0, 6 do
						local state = getVehiclePanelState(source, i)

						if vehiclePanelStates[source][i] ~= state then
							vehiclePanelStates[source][i] = state
							--setElementData(source, "panelState:" .. i, state)
						end
					end
				end
			end
		end

		if tireId then
			if source == getPedOccupiedVehicle(localPlayer) then
				if getPedOccupiedVehicleSeat(localPlayer) == 0 then
					triggerServerEvent("onTireFlatten", source, tireId)
				end
			end
		end
	end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function ()
		if getVehicleType(source) ~= "BMX" then
			setVehicleEngineState(source, true)

			if not getElementData(source, "vehicle.engine") then
				setVehicleEngineState(source, false)
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "vehicle.engine" then
			if getVehicleType(source) == "Helicopter" then
				if isElementStreamedIn(source) then
					copterRotorStates[source] = getElementData(source, "vehicle.engine")
				end
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		local elementType = getElementType(source)

		if elementType == "vehicle" then
			vehiclePanelStates[source] = {}

			for i = 0, 6 do
				vehiclePanelStates[source][i] = getElementData(source, "panelState:" .. i)
				setVehiclePanelState(source, i, vehiclePanelStates[source][i] or 0)
			end

			if getVehicleType(source) == "Helicopter" then
				copterRotorStates[source] = getElementData(source, "vehicle.engine")
			end
		elseif elementType == "ped" or elementType == "player" then
			local activeAnimation = getElementData(source, "activeAnimation")

			if activeAnimation then
				setPedAnimation(source, unpack(activeAnimation))
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			vehiclePanelStates[source] = nil

			if getVehicleType(source) == "Helicopter" then
				copterRotorStates[source] = nil
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function()
		if getElementType(source) == "vehicle" then
			vehiclePanelStates[source] = nil

			if getVehicleType(source) == "Helicopter" then
				copterRotorStates[source] = nil
			end
		end
	end
)

addEventHandler("onClientPreRender", getRootElement(),
	function (timeStep)
		for helicopter, rotorState in pairs(copterRotorStates) do
			if isElement(helicopter) then
				if rotorState == 0 then
					local speed = getHelicopterRotorSpeed(helicopter)

					if speed > 0 then
						local new_speed = speed - 0.075 * timeStep / 1000

						if new_speed < 0 then
							new_speed = 0
						end

						setHelicopterRotorSpeed(helicopter, new_speed)
					else
						setHelicopterRotorSpeed(helicopter, 0)
					end
				else
					if not getVehicleController(helicopter) then
						setHelicopterRotorSpeed(helicopter, 0.1)
					end
				end
			else
				copterRotorStates[helicopter] = nil
			end
		end
	end
)

addCommandHandler("fixcam",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
			setCameraTarget(localPlayer)
		end
	end
)

function showMessageToPlayer(scriptType, message, messageType)
	outputChatBox(getServerSyntax(scriptType, messageType) .. message, 255, 255, 255, true)
end

--showMessageOnClient("Vehicle", "anyad kinyitva.", "info")