local infobox = {}
local kickbox = {}
local interiorbox = false

local boxSize = respc(32)
local iconSize = respc(24)
local boxSize2 = respc(60)

local Ubuntu15 = dxCreateFont("files/fonts/Ubuntu-Regular.ttf", respc(12))

function showInteriorBox(text, text2, isLocked, interiorType, gameInterior)
	interiorbox = {}

	interiorbox.text = text
	interiorbox.text2 = text2

	if isLocked == "Y" then
		interiorbox.doorState = "close"
	else
		interiorbox.doorState = "open"
	end

	interiorbox.interiorType = interiorType
	interiorbox.gameInterior = gameInterior

	if gameInterior then
		if not fileExists(":lv_interiors/files/pics/" .. gameInterior .. ".jpg") then
			interiorbox.gameInterior = false
		end
	end

	local textWidth = dxGetTextWidth(text, 0.55, RobotoBJo)
	local textWidth2 = dxGetTextWidth(text2, 0.85, RobotoA)

	interiorbox.tileWidth = textWidth

	if textWidth2 > textWidth then
		interiorbox.tileWidth = textWidth2
	end

	interiorbox.alphaGetStart = getTickCount()
	interiorbox.openTileTick = interiorbox.alphaGetStart + 500
	interiorbox.closeTileTick = false
	interiorbox.alphaGetInverse = false
end

function setInteriorDoorState(isLocked, interiorType)
	if interiorbox then
		if isLocked == "Y" then
			interiorbox.doorState = "close"
		else
			interiorbox.doorState = "open"
		end

		interiorbox.interiorType = interiorType
	end
end

function endInteriorBox()
	if interiorbox then
		interiorbox.closeTileTick = getTickCount()
		interiorbox.alphaGetInverse = interiorbox.closeTileTick + 500
	end
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if interiorbox then
			local now = getTickCount()
			local alpha = 0
			local sx = interiorbox.tileWidth + boxSize2 * 2

			if interiorbox.alphaGetStart and now >= interiorbox.alphaGetStart then
				alpha = interpolateBetween(
					0, 0, 0,
					1, 0, 0,
					(now - interiorbox.alphaGetStart) / 300,
					"Linear"
				)
			end

			if interiorbox.alphaGetInverse and now >= interiorbox.alphaGetInverse then
				local progress = (now - interiorbox.alphaGetInverse) / 300

				alpha = interpolateBetween(
					1, 0, 0,
					0, 0, 0,
					progress,
					"Linear")

				if progress >= 1 then
					interiorbox = false
					return
				end
			end

			local x = (screenX - respc(512)) / 2 + (respc(512) - sx) / 2
			local y = screenY - respc(176)

			dxDrawRectangle(x, y, sx, boxSize2, tocolor(30, 35, 48, 255 * alpha))
			dxDrawRectangle(x, y, boxSize2, boxSize2, tocolor(40, 45, 58, 255 * alpha))

			if interiorbox.interiorType == "duty" then
				dxDrawImage(x, y, boxSize2, boxSize2, "infobox/duty.png", 0, 0, 0, tocolor(255, 255, 255, alpha * 255))
			elseif interiorbox.interiorType == "carshop" then
				dxDrawImage(x, y, boxSize2, boxSize2, "infobox/carshop.png", 0, 0, 0, tocolor(118, 143, 227, alpha * 255))
			elseif interiorbox.interiorType == "garage" then
				dxDrawImage(x, y, boxSize2, boxSize2, "infobox/garage" .. interiorbox.doorState .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * 255))
			elseif interiorbox.interiorType == "garagepaint" then
				dxDrawImage(x, y, boxSize2, boxSize2, "infobox/garagepaint.png", 0, 0, 0, tocolor(255, 255, 255, alpha * 255))
			else
				dxDrawImage(x, y, boxSize2, boxSize2, "infobox/door" .. interiorbox.doorState .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * 255))
			end

			dxDrawText(interiorbox.text, x + boxSize2 + respc(10), y + respc(10), x + boxSize2 + respc(10) + sx, y + respc(10) + boxSize2, tocolor(118, 143, 227, alpha * 255), 0.55, RobotoB, "left", "top", true)
			dxDrawText(interiorbox.text2, x + boxSize2 + respc(10), y - respc(10), x + boxSize2 + respc(10) + sx, y - respc(10) + boxSize2, tocolor(255, 255, 255, alpha * 255), 0.85, RobotoA, "left", "bottom", true)
		
			if interiorbox.gameInterior then
				local sx, sy = respc(259.2), respc(145.8)
				local x = math.floor(screenX / 2 - sx / 2)
				local y = math.floor(screenY - respc(176) - respc(155.8))
				
				dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 200 * alpha))
				dxDrawImage(x + 3, y + 3, sx - 6, sy - 6, ":lv_interiors/files/pics/" .. interiorbox.gameInterior .. ".jpg", 0, 0, 0, tocolor(255, 255, 255, alpha * 255))
			end
		end
	end)

addEvent("addKickbox", true)
addEventHandler("addKickbox", localPlayer,
	function (boxType, adminNick, playerName, reason, banTime)
		local now = getTickCount()
		local temp = {}

		for i = 1, 5 do
			local dat = kickbox[i]

			if dat then
				temp[i + 1] = dat
				dat.moveUpStart = now
			end
		end

		local data = {
			type = boxType,
			admin = adminNick,
			player = playerName,
			reason = reason
		}

		data.offsetY = respc(45) * 4
		data.alphaGetStart = now
		data.openTileTick = data.alphaGetStart + 600
		data.closeTileTick = data.openTileTick + 5000
		data.alphaGetInverse = data.closeTileTick + 600

		kickbox = temp
		kickbox[1] = data
		
		if renderData.hudDisableNumber > 0 or renderData.inTrash.kickbox then
			if boxType == "ban" then
				if banTime == "0" then
					outputChatBox("#d75959[Ban]: #7cc576" .. playerName .. " #ffffffki lett tiltva a szerverről #7cc576" .. adminNick .. " #ffffffáltal. #32b3ef(véglegesen)", 255, 255, 255, true)
				else
					outputChatBox("#d75959[Ban]: #7cc576" .. playerName .. " #ffffffki lett tiltva a szerverről #7cc576" .. adminNick .. " #ffffffáltal. #32b3ef(" .. banTime .. " óra)", 255, 255, 255, true)
				end

				outputChatBox("#d75959[Ban]: #7cc576Indok: #ffffff" .. reason, 255, 255, 255, true)
			elseif boxType == "kick" then
				outputChatBox("#d75959[Kick]: #7cc576" .. playerName .. " #ffffffki lett rúgva a szerverről #7cc576" .. adminNick .. " #ffffffáltal.", 255, 255, 255, true)
				outputChatBox("#d75959[Kick]: #7cc576Indok: #ffffff" .. reason, 255, 255, 255, true)
			end
		elseif boxType == "ban" then
			if banTime == "0" then
				outputConsole("[Ban]: " .. playerName .. " ki lett tiltva a szerverről " .. adminNick .. " által. (véglegesen)")
			else
				outputConsole("[Ban]: " .. playerName .. " ki lett tiltva a szerverről " .. adminNick .. " által. (" .. banTime .. " óra)")
			end

			outputConsole("[Ban]: Indok: " .. reason)
		elseif boxType == "kick" then
			outputConsole("[Kick]: " .. playerName .. " ki lett rúgva a szerverről " .. adminNick .. " által.")
			outputConsole("[Kick]: Indok: " .. reason)
		end
	end)

render.kickbox = function (x, y)
	if #kickbox > 0 then
		local now = getTickCount()

		for i = 1, 5 do
			local dat = kickbox[i]

			if dat then
				local alpha = 0
				local sizeX = respc(40)
				local moveY = dat.offsetY

				if now >= dat.alphaGetStart and now < dat.alphaGetInverse then
					alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (now - dat.alphaGetStart) / 350, "Linear")
				elseif now >= dat.alphaGetInverse then
					alpha = interpolateBetween(1, 0, 0, 0, 0, 0, (now - dat.alphaGetInverse) / 350, "Linear")
				end

				if now >= dat.openTileTick and now < dat.closeTileTick then
					sizeX = interpolateBetween(respc(40), 0, 0, respc(320), 0, 0, (now - dat.openTileTick) / 300, "Linear")
				elseif now >= dat.closeTileTick then
					sizeX = interpolateBetween(respc(320), 0, 0, respc(40), 0, 0, (now - dat.closeTileTick) / 300, "Linear")
				end

				if dat.moveUpStart and now >= dat.moveUpStart then
					moveY = interpolateBetween(dat.offsetY, 0, 0, respc(45) * (5 - i), 0, 0, (now - dat.moveUpStart) / 300, "Linear")
					dat.offsetY = moveY
				end

				local y = y + moveY

				dxDrawRoundedRectangle(x, y, sizeX, respc(40), tocolor(0, 0, 0, 150 * alpha))
				dxDrawRoundedRectangle(x, y, respc(40), respc(40), tocolor(0, 0, 0, 150 * alpha))

				if dat.type == "kick" then
					dxDrawText(dat.admin .. " kickelte " .. dat.player .. "-t", x + respc(45), y, x + sizeX, y + respc(25), tocolor(255, 127, 0, 255 * alpha), 0.4, RobotoBJo, "left", "center", true)
					dxDrawImage(x + respc(2), y + respc(2), respc(36), respc(36), "infobox/kick.png", 0, 0, 0, tocolor(255, 127, 0, 255 * alpha))
				else
					dxDrawText(dat.admin .. " banolta " .. dat.player .. "-t", x + respc(45), y, x + sizeX, y + respc(25), tocolor(215, 89, 89, 255 * alpha), 0.4, RobotoBJo, "left", "center", true)
					dxDrawImage(x + respc(2), y + respc(2), respc(36), respc(36), "infobox/ban.png", 0, 0, 0, tocolor(215, 89, 89, 255 * alpha))
				end

				dxDrawText("Indok: " .. dat.reason, x + respc(45), y + respc(20), x + sizeX, y + respc(40), tocolor(255, 255, 255, 255 * alpha), 0.75, RobotoA, "left", "center", true)
			end
		end

		return true
	end

	return false
end

function showInfobox(type, str)
	--if str then
	--	infobox.state = true
	--	type = utfSub(type, 1, 1)
--
	--	infobox.alphaGetStart = getTickCount()
	--	infobox.openTileTick = infobox.alphaGetStart + 500
	--	infobox.closeTileTick = infobox.openTileTick + 300 + 2500
	--	infobox.alphaGetInverse = infobox.closeTileTick + 500
--
	--	infobox.text = str
	--	infobox.type = type
--
--
	--	playSound("files/sounds/" .. type .. ".mp3")
	--	outputConsole("[Infobox]: " .. str)
	--end
	exports.seal_gui:showInfobox(type, str)
end
addEvent("showInfobox", true)
addEventHandler("showInfobox", localPlayer, showInfobox)

render.infobox = function (x, y)
	if infobox.state then
		local now = getTickCount()
		local alpha = 0
		local sx = boxSize

		if now >= infobox.alphaGetStart and now < infobox.alphaGetInverse then
			alpha = interpolateBetween(
				0, 0, 0,
				1, 0, 0,
				(now - infobox.alphaGetStart) / 1300,
				"Linear"
			)
		elseif now >= infobox.alphaGetInverse then
			local progress = (now - infobox.alphaGetInverse) / 1300

			alpha = interpolateBetween(
				1, 0, 0,
				0, 0, 0,
				progress,
				"Linear")

			if progress >= 1 then
				infobox.state = false
			end
		end

		sx = dxGetTextWidth(infobox.text, 1, Ubuntu15) + boxSize + respc(15)

		x = x + (respc(512) - sx) / 2

		if infobox.type == "w" then
			secondColor = {225, 156, 52}
			mainColor = {220, 170, 100}
		elseif infobox.type == "e" then
			secondColor = {225, 90, 90}
			mainColor = {225, 112, 112}
		elseif infobox.type == "i" then
			secondColor = {71, 161, 213}
			mainColor = {100, 180, 220}
		elseif infobox.type == "s" then
			secondColor = {85, 155, 104}
			mainColor = {125, 176, 121}
		end

		dxDrawRectangle(x, y, sx, boxSize, tocolor(mainColor[1], mainColor[2], mainColor[3], mainColor[4] or 255 * alpha), true)
		dxDrawRectangle(x, y, boxSize, boxSize, tocolor(secondColor[1], secondColor[2], secondColor[3], secondColor[4] or 255 * alpha), true)

		dxDrawImage(math.floor(x + (boxSize - iconSize) / 2), math.floor(y + (boxSize - iconSize) / 2), iconSize, iconSize, "files/images/" .. infobox.type .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * 255), true)
		dxDrawText(infobox.text, x + boxSize, y, x + sx, y + boxSize, tocolor(255, 255, 255, alpha * 255), 1, Ubuntu15, "center", "center", true, false, true)
		
		return true
	else
		return false
	end
end