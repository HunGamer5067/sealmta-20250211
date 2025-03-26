local screenX, screenY = guiGetScreenSize()

local scoreboardSizeW = 455
local scoreboardSizeH = 630

local scoreboardPosX = screenX / 2 - scoreboardSizeW / 2
local scoreboardPosY = screenY / 2 - scoreboardSizeH / 2

local scoreboardOneSize = 35

local playerCount = 0
local scoreboardDatas = {}
local scoreboardOffSet = 0

local scoreboardFadeIn = false
local scoreboardFadeOut = false

function guiRefreshColors()
	local resource = getResourceFromName("seal_gui")
	local resourceState = getResourceState(resource)

	if resource and resourceState == "running" then
		scoreboardFont15 = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		scoreboardFont15Scale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")

		scoreboardFont16 = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		scoreboardFont16Scale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")
		
		scoreboardRegularFont16 = exports.seal_gui:getFont("15/BebasNeueRegular.otf")
		scoreboardRegularFont16Scale = exports.seal_gui:getFontScale("15/BebasNeueRegular.otf")
		
		scoreboardLightFont15 = exports.seal_gui:getFont("15/BebasNeueLight.otf")
		scoreboardLightFont15Scale = exports.seal_gui:getFontScale("15/BebasNeueLight.otf")
	end
end
addEventHandler("onGuiRefreshColors", getRootElement(), guiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), guiRefreshColors)

function renderScoreboard()
	if scoreboardFadeIn then
		local now = getTickCount()
		local progress = now - scoreboardFadeIn

		if progress > 0 then
			a = interpolateBetween(0, 0, 0, 1, 0, 0, progress / 250, "Linear")
		end

		if progress >= 250 then
			scoreboardFadeIn = false
		end		
	end

	if scoreboardFadeOut then
		local now = getTickCount()
		local progress = now - scoreboardFadeOut

		if progress > 0 then
			a = interpolateBetween(1, 0, 0, 0, 0, 0, progress / 250, "Linear")
		end

		if progress >= 250 then
			closeScoreboard()
		end		
	end

	dxDrawRectangle(scoreboardPosX, scoreboardPosY, scoreboardSizeW, scoreboardOneSize, tocolor(25, 25, 25, 255 * a))
	
	if scoreboardLogoTick then
		local now = getTickCount()
		local progress = now - scoreboardLogoTick

		local logoPosX = scoreboardPosX + scoreboardSizeW / 2 - 48
		local logoPosY = scoreboardPosY - 112

		if progress > 0 then
			y = interpolateBetween(logoPosY, 0, 0, logoPosY - 10, 0, 0, progress / 750, "Linear")
		end
		logoPosY = y

		progress = progress - 750

		if progress > 0 then
			y = interpolateBetween(logoPosY, 0, 0, logoPosY + 10, 0, 0, progress / 750, "Linear")
		end
		logoPosY = y

		if progress >= 750 then
			scoreboardLogoTick = getTickCount()
		end

		dxDrawImage(logoPosX, logoPosY, 96, 96, "files/logo.png", 0, 0, 0, tocolor(50, 186, 157, 255 * a))
	else
		dxDrawImage(scoreboardPosX + scoreboardSizeW / 2 - 48, scoreboardPosY - 112, 96, 96, "files/logo.png", 0, 0, 0, tocolor(74, 223, 191, 255 * a))
	end

	dxDrawText("SealMTA - Scoreboard", scoreboardPosX + 6, scoreboardPosY, scoreboardPosX + 6 + scoreboardSizeW, scoreboardPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardFont15Scale, scoreboardFont15, "left", "center") 
	dxDrawText(playerCount .. "/1000", scoreboardPosX - 6, scoreboardPosY, scoreboardPosX - 6 + scoreboardSizeW, scoreboardPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardLightFont15Scale, scoreboardLightFont15, "right", "center") 

	for i = 1, 17 do
		local gridPosX, gridPosY = scoreboardPosX, scoreboardPosY + scoreboardOneSize + scoreboardOneSize * (i - 1)
		dxDrawRectangle(gridPosX, gridPosY, scoreboardSizeW, scoreboardOneSize, tocolor(35, 39, 42, 255 * a))
		dxDrawRectangle(gridPosX, gridPosY, scoreboardSizeW, 2, tocolor(26, 27, 31, 255 * a))
		dxDrawRectangle(gridPosX, gridPosY + 1, scoreboardSizeW, 1, tocolor(51, 53, 61, 255 * a))
	end

	local startPosX = scoreboardPosX
	local startPosY = scoreboardPosY + scoreboardOneSize

	dxDrawText("ID", startPosX + 12, startPosY, startPosX + 12 + scoreboardSizeW, startPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardFont16Scale, scoreboardFont16, "left", "center")
	dxDrawText("Név", startPosX - 75, startPosY, startPosX - 75 + scoreboardSizeW, startPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardFont16Scale, scoreboardFont16, "center", "center")
	dxDrawText("Szint", startPosX + 75, startPosY, startPosX + 75 + scoreboardSizeW, startPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardFont16Scale, scoreboardFont16, "center", "center")
	dxDrawText("Ping", startPosX - 12, startPosY, startPosX - 12 + scoreboardSizeW, startPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardFont16Scale, scoreboardFont16, "right", "center")

	local startPosY = scoreboardPosY + (scoreboardOneSize * 2)
	
	for i = 1, 16 do
		local dataPosX, dataPosY = startPosX, startPosY + scoreboardOneSize * (i - 1)
		local currentData = i + scoreboardOffSet

		if scoreboardDatas[currentData] then
			dxDrawText(scoreboardDatas[currentData][2], dataPosX + 12, dataPosY, dataPosX + 12 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "left", "center")
			
			local adminTitle = scoreboardDatas[currentData][8] and exports.seal_administration:getPlayerAdminTitle(scoreboardDatas[currentData][8]) or false
			local adminColor = scoreboardDatas[currentData][6] and exports.seal_administration:getAdminLevelColor(scoreboardDatas[currentData][6]) or false

			if scoreboardDatas[currentData][5] == 1 and adminColor and adminTitle and scoreboardDatas[currentData][7] then
				dxDrawText(adminColor .. adminTitle .. " " .. scoreboardDatas[currentData][7], dataPosX - 75, dataPosY, dataPosX - 75 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "center", "center", false, false, false, true)
			elseif scoreboardDatas[currentData][9] > 0 then
				dxDrawText("#ca468c" .. scoreboardDatas[currentData][3], dataPosX - 75, dataPosY, dataPosX - 75 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "center", "center", false, false, false, true)
			else
				dxDrawText(scoreboardDatas[currentData][3], dataPosX - 75, dataPosY, dataPosX - 75 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "center", "center")
			end

			if scoreboardDatas[currentData][1] then
				dxDrawText("LVL " .. scoreboardDatas[currentData][4], dataPosX + 75, dataPosY, dataPosX + 75 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(200, 200, 200, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "center", "center")

				local playerPing = getPlayerPing(scoreboardDatas[currentData][8]) or 0
				local pingColor = {200, 200, 200}

				if playerPing then
					if playerPing >= 300 then
						pingColor = {243, 90, 90}
					elseif playerPing >= 200 then
						pingColor = {255, 149, 20}
					elseif playerPing >= 100 then
						pingColor = {243, 214, 90}
					else
						pingColor = {60, 184, 130}
					end

					dxDrawText(playerPing .. " ms", dataPosX - 12, dataPosY, dataPosX - 12 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(pingColor[1], pingColor[2], pingColor[3], 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "right", "center")
				end
			else
				dxDrawText("Nincs bejelentkezve", dataPosX + 125, dataPosY, dataPosX + 125 + scoreboardSizeW, dataPosY + scoreboardOneSize, tocolor(180, 180, 180, 255 * a), scoreboardRegularFont16Scale, scoreboardRegularFont16, "center", "center")
			end
		end
	end
end

function keyScoreboard(key, press)
	if key == "mouse_wheel_up" then
		if scoreboardOffSet > 0 then
			scoreboardOffSet = scoreboardOffSet - 1
		end
	elseif key == "mouse_wheel_down" then
		if scoreboardOffSet < playerCount - 16 then
			scoreboardOffSet = scoreboardOffSet + 1
		end
	end
end

function openScoreboard()
	local playerElements = getElementsByType("player")

	playerCount = #playerElements
	scoreboardDatas = {}

	scoreboardLogoTick = getTickCount()
	scoreboardFadeIn = getTickCount()
	scoreboardFadeOut = false
	
	for i = 1, #playerElements do
		local player = playerElements[i]

		if isElement(player) then
			local loggedIn = getElementData(player, "loggedIn") or false
			local playerId = getElementData(player, "playerID") or 0
			local playerName = (getElementData(player, "visibleName") or getPlayerName(player)):gsub("_", " ")
			local playerLevel = exports.seal_core:getLevel(player) or 0
			local adminDuty = getElementData(player, "adminDuty") or 0
			local adminLevel = getElementData(player, "acc.adminLevel") or 0
			local adminNick = getElementData(player, "acc.adminNick") or "Ismeretlen"
			local helperLevel = getElementData(player, "acc.helperLevel") or 0

			table.insert(scoreboardDatas, {loggedIn, playerId, playerName, playerLevel, adminDuty, adminLevel, adminNick, player, helperLevel})
		end
	end

	if scoreboardDatas then
		table.sort(scoreboardDatas, function(a, b)
			if a[8] == localPlayer and b[8] ~= localPlayer then
				return true
			elseif a[8] ~= localPlayer and b[8] == localPlayer then
				return false
			else
				return a[2] < b[2]
			end
		end)		
	end

	if not alreadyHandledEvents then
		alreadyHandledEvents = true
		addEventHandler("onClientRender", getRootElement(), renderScoreboard)
		addEventHandler("onClientKey", getRootElement(), keyScoreboard)
	end
end

function closeScoreboard()
	if alreadyHandledEvents then
		removeEventHandler("onClientRender", getRootElement(), renderScoreboard)
		removeEventHandler("onClientKey", getRootElement(), keyScoreboard)
	end

	scoreboardFadeOut = false
	scoreboardFadeIn = false

	alreadyHandledEvents = false
	scoreboardDatas = {}
end

addEventHandler("onClientKey", getRootElement(), function(key, press)
	if getElementData(localPlayer, "loggedIn") then
		if key == "tab" then
			if press then
				openScoreboard()
			else
				scoreboardFadeOut = getTickCount()
			end
		end
	end
end)