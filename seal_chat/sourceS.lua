	function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end
connection = false

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
	end)

addEvent("onOOCMessage", true)
addEventHandler("onOOCMessage", getRootElement(), function(message, oocColorState)
	if client == source then
		local visibleName = getElementData(client, "visibleName"):gsub("_", " ")
		local adminLevel = getElementData(client, "acc.adminLevel")

		if (adminLevel >= 6 and oocColorState) or getElementData(client, "adminDuty") == 1 then
			local adminLevel = getElementData(client, "acc.adminLevel") or 0
			local adminTitle = exports.seal_administration:getPlayerAdminTitle(client)
			local levelColor = exports.seal_administration:getAdminLevelColor(adminLevel)

			visibleName = levelColor .. adminTitle .. " " .. visibleName
		else
			visibleName = "#FFFFFF" .. visibleName
		end

		local clientX, clientY, clientZ = getElementPosition(client)
		local affectedPlayerElements = {}
		local affectedSpectatorElements = {}

		for _, playerElement in pairs(getElementsByType("player")) do
			local playerX, playerY, playerZ = getElementPosition(playerElement)
			local playerDistance = getDistanceBetweenPoints3D(clientX, clientY, clientZ, playerX, playerY, playerZ)

			if playerDistance <= 12 then
				table.insert(affectedPlayerElements, playerElement)
			end
		end

		local spectatingPlayers = getElementData(client, "spectatingPlayers") or {}

		for playerElement in pairs(spectatingPlayers) do
			if isElement(playerElement) then
				table.insert(affectedSpectatorElements, playerElement)
			end
		end

		triggerClientEvent(affectedPlayerElements, "onClientRecieveOOCMessage", client, message, visibleName)

		if #affectedSpectatorElements > 0 then
			triggerClientEvent(affectedSpectatorElements, "onClientRecieveOOCMessage", client, message, visibleName, true)
		end
	end
end)

function sendLocalSay(ped, msg)
	if isElement(ped) then
		if utfLen(msg) == 0 then
			return
		end

		local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
		local affected = {}
		local pedveh = getPedOccupiedVehicle(ped)
		local str = ""

		exports.seal_anticheat:sendDiscordMessage(visibleName .. " mondja: **"..msg.."**", "rplog")

		iprint(getElementData(pedveh, "vehicle.windowState"))

		if pedveh and getElementData(pedveh, "vehicle.windowState") then
			str = str .. " (járműben)"

			for k, v in pairs(getVehicleOccupants(pedveh)) do
				if getElementData(v, "loggedIn") then
					table.insert(affected, {v, "#FFFFFF"})
				end
			end
		else
			local px, py, pz = getElementPosition(ped)

			for k, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "loggedIn") then
					local maxdist = 12
					local pedveh = getPedOccupiedVehicle(v)

					if pedveh then
						if getElementData(pedveh, "vehicle.windowState") then
							maxdist = 8
						end
					end

					local tx, ty, tz = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
					if getElementDimension(v) == getElementDimension(ped) and getElementInterior(v) == getElementInterior(ped) then
						if dist <= maxdist then
							table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / maxdist, "Linear"))})
						end
					end
				end
			end
		end

		if #affected > 0 then
			msg = firstToUpper(msg)

			for i = 1, #affected do
				local dat = affected[i]

				if isElement(dat[1]) then
					outputChatBox(dat[2] .. visibleName .. " mondja" .. str .. ": " .. msg, dat[1], 231, 217, 176, true)
				end
			end
		end

		if getElementType(ped) == "player" then
			triggerClientEvent("chatBubble", ped, "say", msg)
		elseif getElementType(ped) == "ped" then
			triggerClientEvent("npcChatBubble", ped, "say", msg)
		end
	end
end

function sendLocalSayInPhone(ped, msg)
	if isElement(ped) then
		if utfLen(msg) == 0 then
			return
		end
		
		local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
		local affected = {}
		local pedveh = getPedOccupiedVehicle(ped)
		local str = " (telefonba)"
		
		if pedveh and getElementData(pedveh, "vehicle.windowState") then
			str = " (járműben, telefonba)"
			
			for k, v in pairs(getVehicleOccupants(pedveh)) do
				if getElementData(v, "loggedIn") then
					table.insert(affected, {v, "#FFFFFF"})
				end
			end
		else
			local px, py, pz = getElementPosition(ped)
			
			for k, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "loggedIn") then
					local maxdist = 12
					local pedveh = getPedOccupiedVehicle(v)
					
					if pedveh then
						if getElementData(pedveh, "vehicle.windowState") then
							maxdist = 8
						end
					end

					local tx, ty, tz = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)
					if getElementDimension(v) == getElementDimension(ped) and getElementInterior(v) == getElementInterior(ped) then
						if dist <= maxdist then
							table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / maxdist, "Linear"))})
						end
					end
				end
			end
		end
		
		if #affected > 0 then
			msg = firstToUpper(msg)
			
			for i = 1, #affected do
				local dat = affected[i]
				
				if isElement(dat[1]) then
					outputChatBox(dat[2] .. visibleName .. " mondja" .. str .. ": " .. msg, dat[1], 231, 217, 176, true)
				end
			end
		end

		exports.seal_anticheat:sendDiscordMessage(visibleName .." mondja" .. str .. " **" .. msg .. "**", "rplog")
	end
end

function localAction(ped, msg)
	if isElement(ped) then
		if utfLen(msg) == 0 then
			return
		end

		local px, py, pz = getElementPosition(ped)
		local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
		local affected = {}
		
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "loggedIn") then
				local tx, ty, tz = getElementPosition(v)
				if getElementDimension(v) == getElementDimension(ped) and getElementInterior(v) == getElementInterior(ped) then
					if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 12 then
						table.insert(affected, v)
					end
				end
			end
		end
		
		if #affected > 0 then
			for i = 1, #affected do
				outputChatBox("#C2A2DA*** " .. visibleName .. " #C2A2DA" .. msg, affected[i], 194, 162, 218, true)
			end
		end
		
		--?? Nagyon spamel, felesleges
		--exports.seal_anticheat:sendDiscordMessage("[ME] " .. visibleName .. " " .. msg, "rplog")
	end
end

function sendLocalDo(ped, msg)
	if isElement(ped) then
		if utfLen(msg) == 0 then
			return
		end

		local px, py, pz = getElementPosition(ped)
		local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
		local affected = {}
		
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "loggedIn") then
				local tx, ty, tz = getElementPosition(v)
				
				if getElementDimension(v) == getElementDimension(ped) and getElementInterior(v) == getElementInterior(ped) then
					if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 12 then
						table.insert(affected, v)
					end
				end
			end
		end
		
		if #affected > 0 then
			msg = firstToUpper(msg)
			
			for i = 1, #affected do
				outputChatBox(" *" .. msg .. " ((#FF2850" .. visibleName .. "))", affected[i], 255, 40, 80, true)
			end
		end

		exports.seal_anticheat:sendDiscordMessage("[DO] " .. msg .. " (("..getElementData(ped, "visibleName"):gsub("_", " ").."))", "rplog")
	end
end

addEvent("onDoMessage", true)
addEventHandler("onDoMessage", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					outputChatBox(" *" .. msg .. " ((#FF2850" .. visibleName .. "))", v, 255, 40, 80, true)
				end
			end

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("[>o<] *" .. msg .. " ((#FF2850" .. visibleName .. "))", k, 255, 40, 80, true)
					end
				end
			end

			triggerClientEvent("chatBubble", client, "do", msg)
			exports.seal_anticheat:sendDiscordMessage("[DO] " .. msg .. " ((".. visibleName .."))", "rplog")
		end
	end)

addEvent("onDoMessageLow", true)
addEventHandler("onDoMessageLow", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					outputChatBox("[LOW] *" .. msg .. " ((#ff6682" .. visibleName .. "))", v, 255, 102, 130, true)
				end
			end
			
			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("[>o<] [LOW] *" .. msg .. " ((#ff6682" .. visibleName .. "))", k, 255, 102, 130, true)
					end
				end
			end

			triggerClientEvent("chatBubble", client, "dolow", msg)
			exports.seal_anticheat:sendDiscordMessage("[DO LOW] " .. msg .. " (("..getElementData(client, "visibleName"):gsub("_", " ").."))", "rplog")
		end
	end)

addEvent("onActionMessageLow", true)
addEventHandler("onActionMessageLow", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					outputChatBox("#DBC5EB*** [LOW] " .. visibleName .. " #DBC5EB" .. msg, v, 219, 197, 235, true)
				end
			end
			triggerClientEvent("chatBubble", client, "melow", msg)

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("#DBC5EB[>o<] *** [LOW] " .. visibleName .. " #DBC5EB" .. msg, k, 219, 197, 235, true)
					end
				end
			end
		end
	end)

addEvent("onActionMessageA", true)
addEventHandler("onActionMessageA", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					outputChatBox("#956CB4>> " .. visibleName .. " #956CB4" .. msg, v, 194, 162, 218, true)
				end
			end
			triggerClientEvent("chatBubble", client, "ame", msg)

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("#956CB4[>o<] >> " .. visibleName .. " #956CB4" .. msg, k, 194, 162, 218, true)
					end
				end
			end
		end
	end)

addEvent("onActionMessage", true)
addEventHandler("onActionMessage", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					outputChatBox("#C2A2DA*** " .. visibleName .. " #C2A2DA" .. msg, v, 194, 162, 218, true)
				end
			end
			triggerClientEvent("chatBubble", client, "me", msg)

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("#C2A2DA[>o<] *** " .. visibleName .. " #C2A2DA" .. msg, k, 194, 162, 218, true)
					end
				end
			end
		end
	end)

local motorcycleTable = {}

function RGBToHex(r, g, b)
	return string.format("#%.2X%.2X%.2X", r, g, b)
end

addEvent("onLocalMessage", true)
addEventHandler("onLocalMessage", getRootElement(), function (distance, visibleName, msg, str, adminDuty, adminTitle, levelColor, ped)
	if isElement(source) and client == source then
		local nearby = {}
		if distance > 12 then
			distance = 12
		end

		local px, py, pz = getElementPosition(ped)
		local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")

		for _, playerElement in pairs(getElementsByType("player")) do
			if playerElement ~= client then
				local tx, ty, tz = getElementPosition(playerElement)
				local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

				if dist <= distance then
					table.insert(nearby, {playerElement, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / distance, "Linear"))})
				end
			end
		end

		for k, v in ipairs(nearby) do
			if isElement(v[1]) then
				if adminDuty ~= 1 then
					outputChatBox(v[2] .. visibleName .. " mondja" .. str .. ": " .. msg, v[1], 255, 255, 255, true)
				else
					outputChatBox(levelColor .. "[ADMIN] " .. adminTitle .. " " .. visibleName .. " mondja" .. str .. ": " .. msg, v[1], 255, 255, 255, true)
				end
			end
		end

		local talkingAnim = getElementData(ped, "talkingAnim") or "false"

		if talkingAnim ~= "false" then
			setPedAnimation(ped, "GANGS", talkingAnim, #msg * 150, true, true, false, false)
			--triggerServerEvent("sayAnimServer", getRootElement(), ped, msg, talkingAnim)
		end

		local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
		if spectatingPlayers then
			for k, v in pairs(spectatingPlayers) do
				if isElement(k) then
					if adminDuty ~= 1 then
						outputChatBox("[>o<] " .. visibleName .. " mondja" .. str .. ": " .. msg, k, 255, 255, 255, true)
					else
						outputChatBox(levelColor .. "[>o<] [ADMIN] " .. adminTitle .. " " .. visibleName .. " mondja" .. str .. ": " .. msg, k, 255, 255, 255, true)
					end
				end
			end
		end

		if getElementType(ped) == "player" then
			triggerClientEvent("chatBubble", ped, "say", msg)
		elseif getElementType(ped) == "ped" then
			triggerClientEvent("npcChatBubble", ped, "say", msg)
		end

		exports.seal_anticheat:sendDiscordMessage(visibleName .. " mondja" .. str .. ": **" .. msg .. "**", "rplog");
	end
end)

	local tradeContractDatas = {}

addEvent("laughAnim", true)
addEventHandler("laughAnim", getRootElement(),
	function ()
		if isElement(source) and client == source then
			setPedAnimation(source, "rapping", "laugh_01", -1, false, false, false, false, 250, true)
		end
	end)

addEvent("sayAnimServer", true)
addEventHandler("sayAnimServer", getRootElement(),
	function(player, message, anim)
		if isElement(player) and player == client then
			setPedAnimation(player, "GANGS", anim, #message * 150, true, true, false, false)
		end
	end
)

addEventHandler("onPlayerCommand", getRootElement(),
	function (commandName)
		if commandName == "say" or commandName == "me" then
			cancelEvent()
		end
	end)

function firstToUpper(text)
	return (text:gsub("^%l", string.upper))
end

function RGBToHex(r, g, b)
	return string.format("#%.2X%.2X%.2X", r, g, b)
end

addEvent("onMegaPhoneMessage", true)
addEventHandler("onMegaPhoneMessage", getRootElement(),
	function (nearby, visibleName, msg)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v[1]) then
					outputChatBox("((" .. visibleName .. ")) Megaphone <O: " .. msg, v[1], 255 * v[2], 255 * v[2], 0 * v[2], true)
				end
			end

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						outputChatBox("[>o<] ((" .. visibleName .. ")) Megaphone <O: " .. msg, k, 255, 255, 0, true)
					end
				end
			end

			triggerClientEvent("chatBubble", client, "megaphone", msg)
		end
	end)

addEvent("onTryMessage", true)
addEventHandler("onTryMessage", getRootElement(),
	function (nearby, visibleName, msg, rnd, commandName)
		if #nearby == #getElementsByType("player") then iprint("próbálkozik", client);kickPlayer(client) return end
		if isElement(source) and client == source then
			for k, v in ipairs(nearby) do
				if isElement(v) then
					if commandName == "megprobal" or commandName == "megpróbál" then
						if rnd == 1 then
							outputChatBox(" *** " .. visibleName .. " megpróbál " .. msg .. " és sikerül neki.", v, 173, 211, 115, true)
							triggerClientEvent("chatBubble", client, "trygreen", msg)
						elseif rnd == 2 then
							outputChatBox(" *** " .. visibleName .. " megpróbál " .. msg .. " de sajnos nem sikerül neki.", v, 220, 20, 60, true)
							triggerClientEvent("chatBubble", client, "tryred", msg)
						end
					elseif commandName == "megprobalja" or commandName == "megpróbálja" then
						if rnd == 1 then
							outputChatBox(" *** " .. visibleName .. " megpróbálja " .. msg .. " és sikerül neki.", v, 173, 211, 115, true)
							triggerClientEvent("chatBubble", client, "trygreen", msg)
						elseif rnd == 2 then
							outputChatBox(" *** " .. visibleName .. " megpróbálja " .. msg .. " de sajnos nem sikerül neki.", v, 220, 20, 60, true)
							triggerClientEvent("chatBubble", client, "tryred", msg)
						end
					end
				end
			end

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						if commandName == "megprobal" or commandName == "megpróbál" then
							if rnd == 1 then
								outputChatBox("[>o<] *** " .. visibleName .. " megpróbál " .. msg .. " és sikerül neki.", v, 173, 211, 115, true)
							elseif rnd == 2 then
								outputChatBox("[>o<] *** " .. visibleName .. " megpróbál " .. msg .. " de sajnos nem sikerül neki.", v, 220, 20, 60, true)
							end
						elseif commandName == "megprobalja" or commandName == "megpróbálja" then
							if rnd == 1 then
								outputChatBox("[>o<] *** " .. visibleName .. " megpróbálja " .. msg .. " és sikerül neki.", k, 173, 211, 115, true)
							elseif rnd == 2 then
								outputChatBox("[>o<] *** " .. visibleName .. " megpróbálja " .. msg .. " de sajnos nem sikerül neki.", k, 220, 20, 60, true)
							end
						end
					end
				end
			end
		end
	end)

addEvent("shoutNormal", true)
addEventHandler("shoutNormal", getRootElement(),
	function (msg)
		if isElement(source) and client == source then
			local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
			local affected = {}
			local pedveh = getPedOccupiedVehicle(source)
			local str = ""


			local px, py, pz = getElementPosition(source)

			for k, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "loggedIn") then
					local maxdist = 20
					local pedveh = getPedOccupiedVehicle(v)

					if pedveh then
						if getElementData(pedveh, "vehicle.windowState") then
							maxdist = 12
						end
					end

					local tx, ty, tz = getElementPosition(v)
					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

					if dist <= maxdist and getElementDimension(v) == getElementDimension(client) and getElementInterior(v) == getElementInterior(client) then
						table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / maxdist, "Linear"))})
					end
				end
			end

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						table.insert(affected, {k, "#FFFFFF", true})
					end
				end
			end

			if #affected > 0 then
				msg = firstToUpper(msg)

				for i = 1, #affected do
					local dat = affected[i]

					if isElement(dat[1]) then
						if dat[3] then
							outputChatBox("[>o<] " .. dat[2] .. visibleName .. " ordítja" .. str .. ": " .. msg, dat[1], 255, 255, 255, true)
						else
							outputChatBox(dat[2] .. visibleName .. " ordítja" .. str .. ": " .. msg, dat[1], 255, 255, 255, true)
						end
					end
				end
			end

			triggerClientEvent("chatBubble", client, "say", msg)

			setPedAnimation(source, "RIOT", "RIOT_shout", -1, false, false, false, false, 250, true)
		end
	end)

addEvent("shoutInterior", true)
addEventHandler("shoutInterior", getRootElement(),
	function (currentStandingInterior, msg, intX, intY, intZ)
		if isElement(source) and client == source then
			local px, py, pz = getElementPosition(source)
			local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
			local affected = {}

			for k, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "loggedIn") then
					if getElementDimension(v) == currentStandingInterior[1] then
						local tx, ty, tz = getElementPosition(v)
						local dist = getDistanceBetweenPoints3D(intX, intY, intZ, tx, ty, tz)

						if dist <= 20 then
							table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / 20, "Linear")), false, true})
						end
					else
						local tx, ty, tz = getElementPosition(v)
						local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

						if dist <= 20 then
							table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / 20, "Linear"))})
						end
					end
				end
			end

			local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}
	
			if spectatingPlayers then
				for k, v in pairs(spectatingPlayers) do
					if isElement(k) then
						table.insert(affected, {k, "#FFFFFF", true})
					end
				end
			end

			if #affected > 0 then
				msg = firstToUpper(msg)

				for i = 1, #affected do
					local dat = affected[i]

					if isElement(dat[1]) then
						if dat[3] then
							outputChatBox("[>o<] " .. dat[2] .. visibleName .. " ordítja: " .. msg, dat[1], 231, 217, 176, true)
						else
							if dat[4] then
								outputChatBox(dat[2] .. visibleName .. " ordítja ((befelé)): " .. msg, dat[1], 231, 217, 176, true)
							else
								outputChatBox(dat[2] .. visibleName .. " ordítja ((kifelé)): " .. msg, dat[1], 231, 217, 176, true)
							end
						end
					end
				end
			end

			triggerClientEvent("chatBubble", client, "say", msg)
			setPedAnimation(source, "RIOT", "RIOT_shout", -1, false, false, false, false, 250, true)
		end
	end)

addEvent("acceptInteriorBuy", true)
addEventHandler("acceptInteriorBuy", getRootElement(),
	function(seller, interiorId, price)
		if isElement(source) and isElement(seller) and interiorId and client == source then
			local currentTime = getRealTime().timestamp

			if tradeContractDatas[source] then
				if currentTime <= tradeContractDatas[source]["tradeEnd"] then
					local currentMoney = getElementData(source, "char.Money") or 0

					if currentMoney - price >= 0 then
						local characterId = getElementData(source, "char.ID") or 0

						exports.seal_core:takeMoney(source, price, "buyInterior")
						exports.seal_core:giveMoney(seller, price, "sellInterior")

						localAction(source, "aláír egy adásvételi szerződést.")

						dbQuery(
							function(qh, player, oldowner)
								exports.seal_interiors:changeInteriorOwnerSell(interiorId, characterId)

								triggerClientEvent("changeInteriorOwner", resourceRoot, interiorId, characterId)

								if isElement(player) then
									exports.seal_hud:showInfobox(player, "s", "Sikeresen megvásároltad az ingatlant " .. formatNumber(price) .. " $-ért.")
								end

								if isElement(oldowner) then
									exports.seal_hud:showInfobox(oldowner, "s", "Sikeresen eladtad az ingatlant " .. formatNumber(price) .. " $-ért.")
								end

								dbFree(qh)
							end, {source, seller}, connection, "UPDATE interiors SET ownerId = ? WHERE interiorId = ?", characterId, interiorId
						)
					else
						exports.seal_hud:showInfobox(source, "e", "Nincs nálad elegendő pénz!")

						outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "Nincs nálad elegendő pénz az ingatlan megvételéhez!", source, 0, 0, 0, true)
						outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "Az adásvételi szerződés automatikusan visszavonva.", source, 0, 0, 0, true)
					end
				else
					exports.seal_hud:showInfobox(source, "e", "Nincs folyamatban adásvételi szerződés!")
				end
			else
				exports.seal_hud:showInfobox(source, "e", "Nincs folyamatban adásvételi szerződés!")
			end

			tradeContractDatas[source] = nil
		end
	end)

addEvent("tryToSellInterior", true)
addEventHandler("tryToSellInterior", getRootElement(),
	function(targetPlayer, interiorId, interiorData, price)
		if isElement(source) and isElement(targetPlayer) and client == source then
			local characterId = getElementData(source, "char.ID") or 0
			local targetId = getElementData(targetPlayer, "char.ID") or 0

			if characterId > 0 and targetId > 0 then
				local currentTime = getRealTime().timestamp

				if tradeContractDatas[targetPlayer] and currentTime >= tradeContractDatas[targetPlayer]["tradeEnd"] then
					tradeContractDatas[targetPlayer] = nil
				end

				if not tradeContractDatas[targetPlayer] then
					dbQuery(
						function(qh, theSeller, thePerson, intiId, thePrice, intiData)
							local result = dbPoll(qh, 0)

							if result then
								local interiorSlot = getElementData(targetPlayer, "char.interiorLimit") or 0

								result = result[1]["COUNT(interiorId)"]

								if result < interiorSlot then
									tradeContractDatas[thePerson] = {}
									tradeContractDatas[thePerson]["tradeEnd"] = getRealTime().timestamp + 300 -- 5 perc
									tradeContractDatas[thePerson]["theSeller"] = theSeller
									tradeContractDatas[thePerson]["interiorId"] = intiId

									triggerClientEvent(thePerson, "sellInteriorNotification", thePerson, theSeller, intiId, thePrice, intiData)
									triggerClientEvent(theSeller, "failedToSell", theSeller) -- adásvételi kioffolása

									local personName = getElementData(thePerson, "visibleName"):gsub("_", " ")

									localAction(theSeller, "átnyújt egy adásvételi szerződést " .. personName .. "-nak/nek.")

									exports.seal_hud:showInfobox(theSeller, "i", "Átnyújtottál egy adásvételi szerződést.")
								else
									triggerClientEvent(theSeller, "failedToSell", theSeller, "A kiválasztott játékosnak nincs több interior slotja!")
								end
							end
						end, {source, targetPlayer, interiorId, price, interiorData}, connection, "SELECT COUNT(interiorId) FROM interiors WHERE ownerId = ?", personId
					)
				else
					triggerClientEvent(source, "failedToSell", source, "A kiválasztott játékosnak már folyamatban van egy adásvételi szerződés!")
				end
			end
		end
	end)

addEvent("acceptVehicleBuy", true)
addEventHandler("acceptVehicleBuy", getRootElement(),
	function(seller, veh, price)
		if isElement(source) and isElement(seller) and isElement(veh) and client == source then
			local currentTime = getRealTime().timestamp

			if tradeContractDatas[source] then
				if currentTime <= tradeContractDatas[source]["tradeEnd"] then
					local currentMoney = getElementData(source, "char.Money") or 0

					if currentMoney - price >= 0 then
						local characterId = getElementData(source, "char.ID") or 0

						exports.seal_core:takeMoney(source, price, "buyVehicle")
						exports.seal_core:giveMoney(seller, price, "sellVehicle")

						exports.seal_anticheat:sendDiscordMessage("`Jármű eladás:` Vásárló: **" .. getElementData(source, "visibleName") .. " (" .. getElementData(source, "char.accID") ..  ")**, eladta: **" .. getElementData(seller, "visibleName") .. " (" .. getElementData(seller, "char.accID") ..  ")**", "contract")

						localAction(source, "aláír egy adásvételi szerződést.")

						dbQuery(
							function(qh, player, oldowner)
								setElementData(veh, "vehicle.owner", characterId)

								if isElement(player) then
									exports.seal_hud:showInfobox(player, "s", "Sikeresen megvásároltad a járművet " .. formatNumber(price) .. " $-ért.")
								end

								if isElement(oldowner) then
									exports.seal_hud:showInfobox(oldowner, "s", "Sikeresen eladtad a járművet " .. formatNumber(price) .. " $-ért.")
								end

								dbFree(qh)
							end, {source, seller}, connection, "UPDATE vehicles SET ownerId = ? WHERE vehicleId = ?", characterId, getElementData(veh, "vehicle.dbID")
						)
					else
						exports.seal_hud:showInfobox(source, "e", "Nincs nálad elegendő pénz!")

						outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "Nincs nálad elegendő pénz a jármű megvételéhez!", source, 0, 0, 0, true)
						outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "Az adásvételi szerződés automatikusan visszavonva.", source, 0, 0, 0, true)
					end
				else
					exports.seal_hud:showInfobox(source, "e", "Nincs folyamatban adásvételi szerződés!")
				end
			else
				exports.seal_hud:showInfobox(source, "e", "Nincs folyamatban adásvételi szerződés!")
			end

			tradeContractDatas[source] = nil
		end
	end)

addEvent("tryToSellVehicle", true)
addEventHandler("tryToSellVehicle", getRootElement(),
	function(personElement, vehicleElement, price)
		if isElement(source) and isElement(personElement) and isElement(vehicleElement) and client == source then
			local characterId = getElementData(source, "char.ID") or 0
			local personId = getElementData(personElement, "char.ID") or 0

			if characterId > 0 and personId > 0 then
				local ownerId = getElementData(vehicleElement, "vehicle.owner") or 0

				if ownerId == characterId then
					local groupId = getElementData(vehicleElement, "vehicle.group") or 0

					if groupId == 0 then
						local currentTime = getRealTime().timestamp

						if tradeContractDatas[personElement] and currentTime >= tradeContractDatas[personElement]["tradeEnd"] then
							tradeContractDatas[personElement] = nil
						end

						if not tradeContractDatas[targetPlayer] then
							dbQuery(
								function(qh, theSeller, thePerson, theVeh, thePrice)
									local result = dbPoll(qh, 0)
			
									if result then
										local vehicleSlot = getElementData(thePerson, "char.maxVehicles") or 0
		
										result = result[1]["COUNT(vehicleId)"]
		
										if result < vehicleSlot then
											tradeContractDatas[thePerson] = {}
											tradeContractDatas[thePerson]["tradeEnd"] = getRealTime().timestamp + 300 -- 5 perc
											tradeContractDatas[thePerson]["theSeller"] = theSeller
											tradeContractDatas[thePerson]["vehicleId"] = getElementData(theVeh, "vehicle.dbID")
		
											triggerClientEvent(thePerson, "sellVehicleNotification", thePerson, theSeller, theVeh, thePrice)
											triggerClientEvent(theSeller, "failedToSell", theSeller) -- adásvételi kioffolása
		
											local personName = getElementData(thePerson, "visibleName"):gsub("_", " ")
		
											localAction(theSeller, "átnyújt egy adásvételi szerződést " .. personName .. "-nak/nek.")
		
											exports.seal_hud:showInfobox(theSeller, "i", "Átnyújtottál egy adásvételi szerződést.")
										else
											triggerClientEvent(theSeller, "failedToSell", theSeller, "A kiválasztott játékosnak nincs több jármű slotja!")
										end
									end
								end, {source, personElement, vehicleElement, price}, connection, "SELECT COUNT(vehicleId) FROM vehicles WHERE ownerId = ? AND groupId = '0'", personId
							)
						else
							triggerClientEvent(source, "failedToSell", source, "A kiválasztott játékosnak már folyamatban van egy adásvételi szerződés!")
						end
					else
						triggerClientEvent(source, "failedToSell", source, "Frakció járművet nem tudsz eladni!")
					end
				else
					triggerClientEvent(source, "failedToSell", source, "Ez a jármű nem a tiéd!")
				end
			else
				triggerClientEvent(source, "failedToSell", source, "Hiba történt.")
			end
		end
	end)

local payTimers = {}

function payTheMoney(sourcePlayer, targetPlayer, amount)
	if isElement(sourcePlayer) and isElement(targetPlayer) then
		local chargeAmount = math.floor(amount * 0.1)
		local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
		local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")

		localAction(sourcePlayer, "átad valamennyi összegű pénzt " .. targetName .. "-nak/nek.")
		exports.seal_anticheat:sendDiscordMessage("**".. playerName .."** átadott " .. formatNumber(amount, " ") .. " dollárt **" .. targetName .. "-nak/nek**", "moneylog")

		exports.seal_core:takeMoney(sourcePlayer, amount - chargeAmount)
		exports.seal_core:giveMoney(targetPlayer, amount - chargeAmount)

		outputChatBox("#4adfbf[SealMTA]: #ffffffAdtál #00aeef" .. targetName .. "#ffffff-nak/nek #4adfbf" .. formatNumber(amount, " ") .. "#ffffff dollárt. (Adó: #00aeef" .. formatNumber(chargeAmount, " ") .. "$#ffffff)", sourcePlayer, 0, 0, 0, true)
		outputChatBox("#4adfbf[SealMTA]: #00aeef" .. playerName .. "#ffffff adott neked #4adfbf" .. formatNumber(amount, " ") .. "#ffffff dollárt. (Adó: #00aeef" .. formatNumber(chargeAmount, " ") .. "$#ffffff)", targetPlayer, 0, 0, 0, true)
	end

	payTimers[sourcePlayer] = nil
end

addCommandHandler("pay",
	function(sourcePlayer, cmd, targetPlayer, amount)
		amount = tonumber(amount)

		if not (targetPlayer and amount) then
			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "/" .. cmd .. " [Játékos név / ID] [Összeg]", sourcePlayer, 0, 0, 0, true)
		else
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				if targetPlayer ~= sourcePlayer then
					local px, py, pz = getElementPosition(sourcePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)

					local pi = getElementInterior(sourcePlayer)
					local ti = getElementInterior(targetPlayer)

					local pd = getElementDimension(sourcePlayer)
					local td = getElementDimension(targetPlayer)

					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

					if dist <= 5 and pi == ti and pd == td then
						amount = math.ceil(amount)

						if amount > 0 then
							local currentMoney = getElementData(sourcePlayer, "char.Money") or 0

							if currentMoney - amount >= 0 then
								if not payTimers[sourcePlayer] then
									payTimers[sourcePlayer] = setTimer(
									function()
										local currentMoney = getElementData(sourcePlayer, "char.Money") or 0
										if currentMoney - amount >= 0 then
											payTheMoney(sourcePlayer, targetPlayer, amount)
										else
											outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "Nincs nálad ennyi pénz!", sourcePlayer, 0, 0, 0, true)
										end
									end, 5000, 1)

									outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "A pénz átadása #ffa6005 #ffffffmásodpercen belül megkezdődik.", sourcePlayer, 0, 0, 0, true)
								else
									outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "Még az előző pénzt sem adtad át, hova ilyen gyorsan?!", sourcePlayer, 0, 0, 0, true)
								end
							else
								outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "Nincs nálad ennyi pénz!", sourcePlayer, 0, 0, 0, true)
							end
						else
							outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "Maradjunk a nullánál nagyobb egész számoknál.", sourcePlayer, 0, 0, 0, true)
						end
					else
						outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "A kiválasztott játékos túl messze van tőled.", sourcePlayer, 0, 0, 0, true)
					end
				else
					outputChatBox("#4adfbf[SealMTA - Hiba]: #ffffff" .. "Magadnak nem tudsz pénzt adni!", sourcePlayer, 0, 0, 0, true)
				end
			end
		end
	end)

function formatNumber(amount, stepper)
	amount = tonumber(amount)
	
	if not amount then
		return ""
	end
	
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end