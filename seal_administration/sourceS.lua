local onlineAdmins = {}
local onlineVezetoseg = {}
local dutyTime = {}
connection = false

local adminCommandTimers = {}

addEventHandler("onPlayerCommand", root,
	function (command)
		if adminCommands[command] then
			if not adminCommandTimers[source] then
				adminCommandTimers[source] = {}
			end

			if adminCommandTimers[source][command] then
				local currentTick = getTickCount()
				local commandTick = adminCommandTimers[source][command]
			
				if currentTick - commandTick > 3000 then
					adminCommandTimers[source][command] = false
				else
					exports.seal_gui:showInfobox(source, "e", "Várj egy kicsit a parancs használatához.")
					cancelEvent()
				end
			else
				adminCommandTimers[source][command] = getTickCount()
			end
		end
	end
)

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		if client then
			banPlayer(client, true, false, true, "Anticheat", "AC #1")
            return
		end
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.seal_database:getConnection()

		for k, v in pairs(getElementsByType("player")) do
			local adminLevel = getElementData(v, "acc.adminLevel") or 0
			if adminLevel > 0 then
				onlineAdmins[v] = adminLevel
			end
		end

		for k, v in pairs(getElementsByType("player")) do
			local vezetosegiTag = getElementData(v, "acc.adminLevel") or 0

			if vezetosegiTag >= 6 then
				onlineVezetoseg[v] = vezetosegiTag
			end
		end
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "acc.adminLevel" or dataName == "adminDuty" then
			local adminLevel = getElementData(source, "acc.adminLevel") or 0
			if adminLevel > 0 then
				onlineAdmins[source] = adminLevel
			else
				onlineAdmins[source] = nil
			end
		end

		if dataName == "acc.adminLevel" or dataName == "adminDuty" then
			local vezetosegLevel = getElementData(source, "acc.adminLevel") or 0

			if vezetosegLevel >= 6 then
				onlineVezetoseg[source] = vezetosegLevel
			else
				onlineVezetoseg[source] = nil
			end
		end
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function(data, oldval, newval)
		if data == "adminDuty" then
			if getElementData(source, "adminDuty") then
				dutyTime[source] = getTickCount()
			elseif dutyTime[source] then
				dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - dutyTime[source], getElementData(source, "acc.dbID"))
				dutyTime[source] = nil
			end
		end

		if data == "afk" then
			if newval then
				if dutyTime[source] then
					dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - dutyTime[source], getElementData(source, "acc.dbID"))
					dutyTime[source] = nil
				end
			end

			if not newval then
				dutyTime[source] = getTickCount()
			end
		end
	end)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if onlineAdmins[source] then
			onlineAdmins[source] = nil
		elseif dutyTime[source] then
			dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - dutyTime[source], getElementData(source, "acc.dbID"))
			dutyTime[source] = nil
		end
	end)

addEventHandler("onPlayerChangeNick", getRootElement(),
	function (oldNick, newNick, changedByUser)
		if changedByUser then
			cancelEvent()
		end
	end)

addEvent("warpToGameInterior", true)
addEventHandler("warpToGameInterior", getRootElement(),
	function (interiorId, gameInterior)
		if isElement(source) and client == source then
			if gameInterior then
				setElementPosition(source, gameInterior.position[1], gameInterior.position[2], gameInterior.position[3])
				setElementRotation(source, gameInterior.rotation[1], gameInterior.rotation[2], gameInterior.rotation[3])
				setElementInterior(source, gameInterior.interior)
				setElementDimension(source, 0)
				setCameraInterior(source, gameInterior.interior)
				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen elteleportáltál a kiválasztott interior belsőbe. #4adfbf([" .. interiorId .. "] " .. gameInterior.name .. ")", source, 255, 255, 255, true)
			end
		end
	end)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function showAdminMessageFor(player, message, r, g, b)
	if type(message) == "string" then
		if r and g and b then
			return outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, player, r, g, b, true)
		else
			return outputChatBox(message, player, 255, 255, 255, true)
		end
	end
end

function showAdminMessage(message, r, g, b)
	if r and g and b then
		return outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, root, r, g, b, true)
	else
		return outputChatBox(message, root, 255, 255, 255, true)
	end
end

addCommandHandler("togalogs", function(sourcePlayer)
	if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
		local urmaState = getElementData(sourcePlayer, "togurma")
		local urmaState2 = getElementData(sourcePlayer, "togurma2")
		
		setElementData(sourcePlayer, "togurma", (not urmaState))
		setElementData(sourcePlayer, "togurma2", (not urmaState2))
		
		if urmaState then
			outputChatBox("#4adfbf[SealMTA] #ffffffSikeresen #4adfbfbekapcsoltad #ffffffaz adminisztrátori logokat.", sourcePlayer, 255, 255, 255, true)
		else
			outputChatBox("#4adfbf[SealMTA] #ffffffSikeresen #4adfbfkikapcsoltad #ffffffaz adminisztrátori logokat", sourcePlayer, 255, 255, 255, true)
		end
	elseif getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
		outputChatBox("#4adfbf[SealMTA] #ffffffTúl kicsi az adminszinted, hogy tudd ki-be kapcsolni az adminlogokat.", sourcePlayer, 255, 255, 255, true)
	end
end)

addCommandHandler("togurma",
	function(sourcePlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			setElementData(sourcePlayer, "togurma", not getElementData(sourcePlayer, "togurma"))
			setElementData(sourcePlayer, "togurma2", not getElementData(sourcePlayer, "togurma2"))

			if getElementData(sourcePlayer, "togurma") then
				outputChatBox("togúrma ón", sourcePlayer)
			else
				outputChatBox("togúrma kikapcs", sourcePlayer)
			end
		end
	end
)

function showMessageForAdmins(message, r, g, b, achat)
	for playerElement, adminLevel in pairs(onlineAdmins) do
		if isElement(playerElement) then
			if not achat and not getElementData(playerElement, "togurma") then
				if r and g and b then
					outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, playerElement, r, g, b, true)
				else
					outputChatBox(message, playerElement, 255, 255, 255, true)
				end
			elseif not getElementData(playerElement, "togurma2") then
				if r and g and b then
					outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, playerElement, r, g, b, true)
				else
					outputChatBox(message, playerElement, 255, 255, 255, true)
				end
			end
		end
	end
end

function showMessageForVezetoseg(message, r, g, b, achat)
	for playerElement, adminLevel in pairs(onlineVezetoseg) do
		if isElement(playerElement) then
			if not achat and not getElementData(playerElement, "togurma") then
				if r and g and b then
					outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, playerElement, r, g, b, true)
				else
					outputChatBox(message, playerElement, 255, 255, 255, true)
				end
			elseif not getElementData(playerElement, "togurma2") then
				if r and g and b then
					outputChatBox(string.format("#%.2X%.2X%.2X", r, g, b) .. message, playerElement, r, g, b, true)
				else
					outputChatBox(message, playerElement, 255, 255, 255, true)
				end
			end
		end
	end
end

function showAdminLog(message, level)
	level = level or 1

	for playerElement, adminLevel in pairs(onlineAdmins) do
		if isElement(playerElement) and not getElementData(playerElement, "togurma") then
			if adminLevel >= level then
				outputChatBox("#4adfbf[SealMTA - ALOG]: #ffffff" .. message, playerElement, 255, 255, 255, true)
				--exports.seal_anticheat:sendDiscordMessage("[SealMTA - ALOG] **"..message.."**", "adminlog")
			end
		end
	end
end
--triggerServerEvent("sendDiscordReport", resourceRoot, time, killedName, deathText, killerName)
addEvent("showKillMessage", true)
addEventHandler("showKillMessage", getRootElement(), function(time, kiledName, deathText, killerName)
	if killerName then
--		exports.seal_anticheat:sendDiscordMessage("**"..time or 0 .."** "..killerName.." megölte ".. getElementData(source, "visibleName"):gsub("_", " ") .."-t. **"..deathText.."**", "killog")
	else
--		exports.seal_anticheat:sendDiscordMessage("**".. time or 0 .."** " .. getElementData(source, "visibleName"):gsub("_", " ") .. " meghalt.", "killog")
	end
end)	

addEvent("getTickSyncKillmsg", true)
addEventHandler("getTickSyncKillmsg", getRootElement(),
	function ()
		if isElement(source) and client == source then
			triggerClientEvent(source, "getTickSyncKillmsg", source, getRealTime().timestamp)
		end
	end
)

local asayTick = {}

addCommandHandler("asay",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (...) then
				outputChatBox("#ff9600[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 255, 255, 255, true)
			else
				local msg = table.concat({...}, " ")

				if #msg > 0 and utfLen(msg) > 0 and utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
					local adminNick = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					if not asayTick[sourcePlayer] then
						asayTick[sourcePlayer] = 0
					end
					
					if getTickCount() - asayTick[sourcePlayer] < 3000 then
						exports.seal_hud:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					asayTick[sourcePlayer] = getTickCount()

					outputChatBox(adminRank .. " " .. adminNick .. ": " .. msg, getRootElement(), 215, 89, 89, true)

					triggerClientEvent(getElementsByType("player"), "playNotification", sourcePlayer, "epanel")
				end
			end
		end
	end)

local vsayTick = {}

addCommandHandler("vsay",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (...) then
				outputChatBox("#ff9600[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 255, 255, 255, true)
			else
				local msg = table.concat({...}, " ")

				if #msg > 0 and utfLen(msg) > 0 and utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
					local adminNick = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					if not vsayTick[sourcePlayer] then
						vsayTick[sourcePlayer] = 0
					end
					
					if getTickCount() - vsayTick[sourcePlayer] < 3000 then
						exports.seal_hud:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					vsayTick[sourcePlayer] = getTickCount()
					
					outputChatBox("[Vezetőségi Felhívás]: #ffffff" .. msg, getRootElement(), 215, 89, 89, true)

					triggerClientEvent(getElementsByType("player"), "playNotification", sourcePlayer, "epanel")
				end
			end
		end
	end)

addCommandHandler("setoffpp",
	function(sourcePlayer, commandName, accountId, ppAmount)
		if getElementData(sourcePlayer) >= 9 then
			dbQuery(
				function(qh, sourcePlayer, accountId, ppAmount)
					local result = dbPoll(qh, 0)

					if #result >= 1 then
						dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", ppAmount, accountId)
						outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen átállítottad a játékos prémiumpontjait!", sourcePlayer, 255, 255, 255, true)
					else
						outputChatBox("[SealMTA]: #ffffffNincs találat!", sourcePlayer, 215, 89, 89, true)
					end
				end, {sourcePlayer, accountId, ppAmount}, connection, "SELECT accountId, premiumPoints FROM accounts WHERE accountId = ?", accountId
			)
		end
	end
)

addCommandHandler("setdim",
	function (sourcePlayer, commandName, dimension)
		if isHavePermission(sourcePlayer, "setdim") then
			local dimension = tonumber(dimension)

			if not dimension then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Dimenzió]", sourcePlayer, 245, 150, 34, true)
			else
				outputChatBox("[SealMTA]: #ffffffSikeres dimenizió váltás. #32b2ee(" .. dimension .. ")", sourcePlayer, 94, 193, 230, true)
				setElementDimension(sourcePlayer, dimension)
			end
		end
	end
)

addCommandHandler("setint",
	function (sourcePlayer, commandName, interior)
		if isHavePermission(sourcePlayer, "setint") then
			local interior = tonumber(interior)

			if not interior then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Interior]", sourcePlayer, 245, 150, 34, true)
			else
				outputChatBox("[SealMTA]: #ffffffSikeres dimenizió váltás. #32b2ee(" .. interior .. ")", sourcePlayer, 94, 193, 230, true)
				setElementInterior(sourcePlayer, interior)
			end
		end
	end
)

addCommandHandler("starthimnusz",
	function (sourcePlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			triggerClientEvent(root, "startHimnuszSound", resourceRoot)
		end
	end
)

addEvent("markVehicle", true)
addEventHandler("markVehicle", resourceRoot,
	function (x, y, z, interior, dimension)
		if source ~= client then
			local vehicle = getPedOccupiedVehicle(client)
			local vehicleOccupants = getVehicleOccupants(vehicle)

			setElementPosition(vehicle, x, y, z)
			setElementInterior(vehicle, interior)
			setElementDimension(vehicle, dimension)

			for seat, player in pairs(vehicleOccupants) do
				setElementInterior(player, interior)
				setElementDimension(player, dimension)
			end
		end
	end
)

addEvent("markPlayer", true)
addEventHandler("markPlayer", resourceRoot,
	function (x, y, z, interior, dimension)
		if source ~= client then
			setElementPosition(client, x, y, z)
			setElementInterior(client, interior)
			setElementDimension(client, dimension)
		end
	end
)