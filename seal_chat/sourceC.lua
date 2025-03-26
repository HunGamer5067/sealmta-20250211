local oocColorState = false

addEventHandler("onClientElementDataChange", getRootElement(),
	function(dataName, oldValue, newValue)
		if source == localPlayer then
			if dataName == "dateState" then
				dateState = newValue
			end
		end
	end
)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function onOOCChat(commandName, ...)
	local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")
	
	if utf8.len(msg) > 0 and utf8.len(msg) <= 128 then
		triggerServerEvent("onOOCMessage", localPlayer, msg, oocColorState)
	end
end
addCommandHandler("b", onOOCChat)
addCommandHandler("LocalOOC", onOOCChat)
bindKey("b", "down", "chatbox", "LocalOOC")

--bindKey("r", "down", "r", "Rádió:")

function togColorFA()
	if getElementData(localPlayer, "acc.adminLevel") >= 6 then
		oocColorState = not oocColorState

		if oocColorState then
			outputChatBox("#4adfbf[SealMTA]: #ffffffOOC Chat szín #4adfbfbekapcsolva", 255, 255, 255, true)
		else
			outputChatBox("#4adfbf[SealMTA]: #ffffffOOC Chat szín #d75959kikapcsolva", 255, 255, 255, true)
		end
	end
end
addCommandHandler("togcolorooc", togColorFA)

function localActionC(ped, msg)
	localAction(ped, msg)
end

function sendLocalDoC(ped, msg)
	localDo(ped, msg)
end

function sendLocalSay(ped, msg)
	sendSay(ped, msg)
end

addCommandHandler("say",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			local msg = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")
			if getElementData(localPlayer, "char.ID") == 2987 then
				--msg = string.gsub(msg, "r", "l")
				--msg = string.gsub(msg, "R", "L")
			end

			sendSay(localPlayer, msg)
		end
	end)

function literalize(msd)
	return msd:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function (character)
		return "%" .. character
	end)
end

local motorcycleTable = {
	[581] = true,
	[509] = true,
	[481] = true,
	[462] = true,
	[521] = true,
	[463] = true,
	[510] = true,
	[522] = true,
	[461] = true,
	[448] = true,
	[468] = true,
	[586] = true,

}

local smileyTable = {
	[":D"] = "nevet",
	["xD"] = "szakad a röhögéstől",
	[":$"] = "elpirul",
	[":P"] = "nyelvet ölt",
	[":p"] = "nyelvet ölt",
	[":("] = "szomorú",
	[":-("] = "szomorú",
	["):"] = "szomorú",
	[":)"] = "mosolyog",
	["(:"] = "mosolyog",
	[";-)"] = "kacsint",
	["(-;"] = "kacsint",
	[":@"] = "mérges",
	[";D"] = "nagyot kacsint",
	[";-D"] = "nagyot kacsint",
	["xd"] = "szakad a röhögéstől",
	["XD"] = "szakad a röhögéstől",
	["Xd"] = "szakad a röhögéstől",
	["^^"] = "vihog",
	[":'("] = "sír",
	["-.-"] = "sóhajt",
	[":O"] = "meglepődik",
	[":o"] = "meglepődik",
	["o.O"] = "meglepődik",
	["O.o"] = "meglepődik"
}

function sendSay(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local adminDuty = getElementData(ped, "adminDuty") or 0

	if adminDuty ~= 1 then
		local laugh = false

		for k, v in pairs(smileyTable) do
			if utf8.find(msg, k, 1, true) then
				laugh = v
				localActionC(ped, v .. ".")
				msg = utf8.gsub(msg, literalize(k), "")
			end
		end

		if laugh == "szakad a röhögéstől" or laugh == "nevet" then
			triggerServerEvent("laughAnim", ped)
		end
	end

	if utf8.len((utf8.gsub(msg, " ", "") or 0)) == 0 then
		return
	end

	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local pedveh = getPedOccupiedVehicle(ped)
	local str = ""
	local maxdist = 12

	if isElement(pedveh) and (not getElementData(pedveh, "vehicle.windowState") and not motorcycleTable[getElementModel(pedveh)]) then
		str = str .. " (járműben)"

		for k, v in pairs(getVehicleOccupants(pedveh)) do
			if v ~= ped then
				table.insert(affected, {v, "#FFFFFF"})
				count = count + 1
			end
		end
	else
		local px, py, pz = getElementPosition(ped)

		for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
			if v ~= localPlayer then
				local pedveh = getPedOccupiedVehicle(v)

				if pedveh then
					if getElementData(pedveh, "vehicle.windowState") == "opened" then
						maxdist = 8
					end
				end

				local tx, ty, tz = getElementPosition(v)
				local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

				if dist <= maxdist then
					table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 50, 50, 50, dist / maxdist, "Linear"))})
					count = count + 1
				end
			end
		end
	end

	local adminLevel = getElementData(ped, "acc.adminLevel") or 0
	local adminTitle = exports.seal_administration:getPlayerAdminTitle(ped)
	local levelColor = exports.seal_administration:getAdminLevelColor(adminLevel)

	msg = firstToUpper(msg)

	if adminDuty ~= 1 or ped ~= localPlayer then
		outputChatBox("#FFFFFF" .. visibleName .. " mondja" .. str .. ": " .. msg, 231, 217, 176, true)
	else
		outputChatBox(levelColor .. "[ADMIN] " .. adminTitle .. " " .. visibleName .. " mondja" .. str .. ": " .. msg, 231, 217, 176, true)
	end

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers") or {}
	
	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(v) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onLocalMessage", localPlayer, maxdist, visibleName, msg, str, adminDuty, adminTitle, levelColor, ped)
	else
		local talkingAnim = getElementData(localPlayer, "talkingAnim") or "false"

		if talkingAnim ~= "false" then
			triggerServerEvent("sayAnimServer", getRootElement(), ped, msg, talkingAnim)
		end
	end
end

addCommandHandler("c",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[SealMTA - Chat]: #ffffff/" .. commandName .. " [szöveg]", 255, 194, 14, true)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					local laugh = false
					local maxdist = 4

					for k, v in pairs(smileyTable) do
						if utf8.find(msg, k, 1, true) then
							laugh = v
							localActionC(localPlayer, v)
							msg = utf8.gsub(msg, literalize(k), "")
						end
					end

					if laugh == "szakad a röhögéstől" or laugh == "nevet" then
						triggerServerEvent("laughAnim", localPlayer)
					end

					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local visibleName = getElementData(localPlayer, "visibleName"):gsub("_", " ")
						local affected = {}
						local count = 0
						local pedveh = getPedOccupiedVehicle(localPlayer)
						local str = " (suttogva)"

						if isElement(pedveh) and getElementData(pedveh, "vehicle.windowState") then
							str = str .. "(járműben)"
							
							for k, v in pairs(getVehicleOccupants(pedveh)) do
								if v ~= localPlayer then
									table.insert(affected, {v, "#FFFFFF"})
									count = count + 1
								end
							end
						else
							local px, py, pz = getElementPosition(localPlayer)

							for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
								if v ~= localPlayer then
									local pedveh = getPedOccupiedVehicle(v)

									if pedveh then
										if getElementData(pedveh, "vehicle.windowState") then
											return
										end
									end

									local tx, ty, tz = getElementPosition(v)
									local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

									if dist <= maxdist then
										table.insert(affected, {v, RGBToHex(interpolateBetween(255, 255, 255, 70, 70, 70, dist / maxdist, "Linear"))})
										count = count + 1
									end
								end
							end
						end

						msg = firstToUpper(msg)
						
						outputChatBox("#FFFFFF" .. visibleName .. " mondja" .. str .. ": " .. msg, 231, 217, 176, true)
						
						local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

						if spectatingPlayers then
							for k, v in pairs(spectatingPlayers) do
								if isElement(k) then
									count = count + 1
								end
							end
						end

						if count > 0 then
							triggerServerEvent("onLocalMessage", localPlayer, maxdist, visibleName, msg, str, 0, "", "#ffffff", localPlayer)
						end
					end
				end
			end
		end
	end)

function localActionLow(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local px, py, pz = getElementPosition(ped)
	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local syncer = false

	if getElementType(ped) == "ped" then
		syncer = localPlayer
	else
		syncer = ped
	end

	for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		if v ~= syncer then
			local tx, ty, tz = getElementPosition(v)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 6 then
				table.insert(affected, v)
				count = count + 1
			end
		end
	end

	outputChatBox("#DBC5EB*** [LOW] " .. visibleName .. " #DBC5EB" .. msg, 219, 197, 235, true)

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onActionMessageLow", syncer, affected, visibleName, msg)
	end
end

function localActionA(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local px, py, pz = getElementPosition(ped)
	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local syncer = false

	if getElementType(ped) == "ped" then
		syncer = localPlayer
	else
		syncer = ped
	end

	for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		if v ~= syncer then
			local tx, ty, tz = getElementPosition(v)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 12 then
				table.insert(affected, v)
				count = count + 1
			end
		end
	end

	outputChatBox("#956CB4>> " .. visibleName .. " #956CB4" .. msg, 194, 162, 218, true)

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onActionMessageA", syncer, affected, visibleName, msg)
	end
end

function localAction(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local px, py, pz = getElementPosition(ped)
	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local syncer = false

	if getElementType(ped) == "ped" then
		syncer = localPlayer
	else
		syncer = ped
	end

	for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		if v ~= syncer then
			local tx, ty, tz = getElementPosition(v)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 12 then
				table.insert(affected, v)
				count = count + 1
			end
		end
	end

	outputChatBox("#C2A2DA*** " .. visibleName .. " #C2A2DA" .. msg, 194, 162, 218, true)

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onActionMessage", syncer, affected, visibleName, msg)
	end
end

addCommandHandler("me",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
			else
				localAction(localPlayer, table.concat({...}, " "):gsub("#%x%x%x%x%x%x", ""))
			end
		end
	end)

addCommandHandler("melow",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
			else
				localActionLow(localPlayer, table.concat({...}, " "):gsub("#%x%x%x%x%x%x", ""))
			end
		end
	end)

addCommandHandler("ame",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
			else
				localActionA(localPlayer, table.concat({...}, " "):gsub("#%x%x%x%x%x%x", ""))
			end
		end
	end)

function localDo(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local px, py, pz = getElementPosition(ped)
	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local syncer = false

	if getElementType(ped) == "ped" then
		syncer = localPlayer
	else
		syncer = ped
	end

	for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		if v ~= syncer then
			local tx, ty, tz = getElementPosition(v)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 12 then
				table.insert(affected, v)
				count = count + 1
			end
		end
	end

	msg = firstToUpper(msg)

	outputChatBox(" *" .. msg .. " ((#FF2850" .. visibleName .. "))", 255, 40, 80, true)

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onDoMessage", syncer, affected, visibleName, msg)
	end
end

function localDoLow(ped, msg)
	if string.len(msg) == 0 then
		return
	end

	local px, py, pz = getElementPosition(ped)
	local visibleName = getElementData(ped, "visibleName"):gsub("_", " ")
	local affected = {}
	local count = 0
	local syncer = false

	if getElementType(ped) == "ped" then
		syncer = localPlayer
	else
		syncer = ped
	end

	for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		if v ~= syncer then
			local tx, ty, tz = getElementPosition(v)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 6 then
				table.insert(affected, v)
				count = count + 1
			end
		end
	end

	msg = firstToUpper(msg)

	outputChatBox("[LOW] *" .. msg .. " ((#ff6682" .. visibleName .. "))", 255, 102, 130, true)

	local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

	if spectatingPlayers then
		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				count = count + 1
			end
		end
	end

	if count > 0 then
		triggerServerEvent("onDoMessageLow", syncer, affected, visibleName, msg)
	end
end

addCommandHandler("dolow",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
			else
				localDoLow(localPlayer, table.concat({...}, " "):gsub("#%x%x%x%x%x%x", ""))
			end
		end
	end)


addCommandHandler("do",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
			else
				localDo(localPlayer, table.concat({...}, " "):gsub("#%x%x%x%x%x%x", ""))
			end
		end
	end)

addCommandHandler("m",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if exports.seal_groups:isPlayerHavePermission(localPlayer, "megaPhone") then
				if not (...) then
					outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
				else
					local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

					if #msg > 0 and utf8.len(msg) > 0 then
						local msg2 = utf8.gsub(msg, " ", "") or 0

						if utf8.len(msg2) > 0 then
							local visibleName = getElementData(localPlayer, "visibleName"):gsub("_", " ")
							local px, py, pz = getElementPosition(localPlayer)
							local affected = {}
							local count = 0

							for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
								if v ~= localPlayer then
									local tx, ty, tz = getElementPosition(v)
									local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

									if dist <= 60 then
										table.insert(affected, {v, 1 - dist / 60})
										count = count + 1
									end
								end
							end

							msg = firstToUpper(msg)

							outputChatBox("((" .. visibleName .. ")) Megaphone <O: " .. msg, 255, 255, 0, true)

							local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")

							if spectatingPlayers then
								for k, v in pairs(spectatingPlayers) do
									if isElement(k) then
										count = count + 1
									end
								end
							end

							if count > 0 then
								triggerServerEvent("onMegaPhoneMessage", localPlayer, affected, visibleName, msg)
							end
						end
					end
				end
			end
		end
	end)

function tryCommand(commandName, ...)
	if getElementData(localPlayer, "loggedIn") then
		if not (...) then
			outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [üzenet]", 255, 255, 255, true)
		else
			local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

			if #msg > 0 and utf8.len(msg) > 0 then
				local visibleName = getElementData(localPlayer, "visibleName"):gsub("_", " ")
				local px, py, pz = getElementPosition(localPlayer)
				local affected = {}
				local count = 0

				for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
					if v ~= localPlayer then
						local tx, ty, tz = getElementPosition(v)
						local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

						if dist <= 12 then
							table.insert(affected, v)
							count = count + 1
						end
					end
				end
				
				local rnd = math.random(1, 2)
				
				if commandName == "megprobal" or commandName == "megpróbál" then
					if rnd == 1 then
						outputChatBox(" *** " .. visibleName .. " megpróbál " .. msg .. " és sikerül neki.", 173, 211, 115, true)
					elseif rnd == 2 then
						outputChatBox(" *** " .. visibleName .. " megpróbál " .. msg .. " de sajnos nem sikerül neki.", 220, 20, 60, true)
					end
				elseif commandName == "megprobalja" or commandName == "megpróbálja" then
					if rnd == 1 then
						outputChatBox(" *** " .. visibleName .. " megpróbálja " .. msg .. " és sikerül neki.", 173, 211, 115, true)
					elseif rnd == 2 then
						outputChatBox(" *** " .. visibleName .. " megpróbálja " .. msg .. " de sajnos nem sikerül neki.", 220, 20, 60, true)
					end
				end

				local spectatingPlayers = getElementData(localPlayer, "spectatingPlayers")
				
				if spectatingPlayers then
					for k, v in pairs(spectatingPlayers) do
						if isElement(k) then
							count = count + 1
						end
					end
				end
				
				if count > 0 then
					triggerServerEvent("onTryMessage", localPlayer, affected, visibleName, msg, rnd, commandName)
				end
			end
		end
	end
end
addCommandHandler("megprobal", tryCommand)
addCommandHandler("megpróbál", tryCommand)
addCommandHandler("megprobalja", tryCommand)
addCommandHandler("megpróbálja", tryCommand)

function firstToUpper(text)
	return (text:gsub("^%l", string.upper))
end

function RGBToHex(r, g, b)
	return string.format("#%.2X%.2X%.2X", r, g, b)
end

addCommandHandler("s",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[SealMTA - Chat]: #ffffff/" .. commandName .. " [szöveg]", 255, 194, 14, true)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					local msg2 = utf8.gsub(msg, " ", "") or 0

					if utf8.len(msg2) > 0 then
						local currentStandingInterior = exports.seal_interiors:getCurrentStandingInterior()

						if currentStandingInterior then
							local x, y, z = 0, 0, 0

							if currentStandingInterior[2] == "entrance" then
								x, y, z = exports.seal_interiors:getInteriorExitPosition(currentStandingInterior[1])
							else
								x, y, z = exports.seal_interiors:getInteriorEntrancePosition(currentStandingInterior[1])
							end

							triggerServerEvent("shoutInterior", localPlayer, currentStandingInterior, msg, x, y, z)
						else
							triggerServerEvent("shoutNormal", localPlayer, msg)
						end
					end
				end
			end
		end
	end)

local gotSelling = false
local tradeContract = false

addCommandHandler("acceptsell",
	function()
		if tradeContract then
			-- jármű
			if isElement(tradeContract[2]) then
				triggerServerEvent("acceptVehicleBuy", localPlayer, tradeContract[1], tradeContract[2], tradeContract[3])
			-- ingatlan
			elseif tonumber(tradeContract[2]) then
				triggerServerEvent("acceptInteriorBuy", localPlayer, tradeContract[1], tradeContract[2], tradeContract[3])
			end

			tradeContract = false
		end
	end)

addCommandHandler("acceptvehsell",
	function()
		if tradeContract then
			triggerServerEvent("acceptVehicleBuy", localPlayer, tradeContract[1], tradeContract[2], tradeContract[3])
		end
	end
)

addEvent("sellInteriorNotification", true)
addEventHandler("sellInteriorNotification", getRootElement(),
	function(seller, inti, price, data)
		if not tradeContract then
			local sellerName = getElementData(seller, "visibleName"):gsub("_", " ")

			exports.seal_hud:showInfobox("i", sellerName .. " el akar adni neked egy ingatlant " .. formatNumber(price) .. " $-ért!")

			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "#32b3ef" .. sellerName .. " #ffffffel akar adni neked egy ingatlant #FF9600" .. formatNumber(price) .. " $#ffffff-ért!", 0, 0, 0, true)
			
			outputChatBox("    * #FF9600Ingatlan: #ffffff" .. data.name, 255, 255, 255, true)

			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "#FF96005 #ffffffperced van elfogadni az ingatlant a #32b3ef/acceptsell #ffffffparanccsal.", 0, 0, 0, true)

			tradeContract = {seller, inti, price}
		end
	end)

addEvent("sellVehicleNotification", true)
addEventHandler("sellVehicleNotification", getRootElement(),
	function(seller, veh, price)
		if not tradeContract then
			local sellerName = getElementData(seller, "visibleName"):gsub("_", " ")

			exports.seal_hud:showInfobox("i", sellerName .. " el akar adni neked egy járművet " .. formatNumber(price) .. " $-ért!")

			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "#32b3ef" .. sellerName .. " #ffffffel akar adni neked egy járművet #FF9600" .. formatNumber(price) .. " $#ffffff-ért!", 0, 0, 0, true)
			
			outputChatBox("    * #FF9600Típus: #ffffff" .. exports.seal_vehiclenames:getCustomVehicleName(getElementModel(veh)), 255, 255, 255, true)

			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "#FF96005 #ffffffperced van elfogadni a járművet a #32b3ef/acceptsell #ffffffparanccsal.", 0, 0, 0, true)

			tradeContract = {seller, veh, price}
		end
	end)

addEvent("failedToSell", true)
addEventHandler("failedToSell", getRootElement(),
	function(errno)
		if errno then
			exports.seal_gui:showInfobox("e", errno)
		end

		gotSelling = false		
	end)

addCommandHandler("sell",
	function(cmd, targetPlayer, amount)
		amount = tonumber(amount)

		if not (targetPlayer and amount) then
			outputChatBox("#4adfbf[SealMTA]: #ffffff" .. "/" .. cmd .. " [Játékos név / ID] [Összeg]", 0, 0, 0, true)
		else
			targetPlayer = exports.seal_core:findPlayer(localPlayer, targetPlayer)

			if targetPlayer then
				if targetPlayer ~= localPlayer then

					local px, py, pz = getElementPosition(localPlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)

					local pi = getElementInterior(localPlayer)
					local ti = getElementInterior(targetPlayer)

					local pd = getElementDimension(localPlayer)
					local td = getElementDimension(targetPlayer)

					local dist = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

					if dist <= 5 and pi == ti and pd == td then
						
						amount = math.ceil(amount)

						if amount >= 0 then
							local pedveh = getPedOccupiedVehicle(localPlayer)
							local inti = exports.seal_interiors:getCurrentStandingInterior()

							if isElement(pedveh) then
								print("asd5")
								if not gotSelling then
									print("asd6")
									gotSelling = true

									iprint(localPlayer, targetPlayer, pedveh, amount)
									triggerServerEvent("tryToSellVehicle", localPlayer, targetPlayer, pedveh, amount)
								else
									outputChatBox("#d75959[SealMTA]: #ffffff" .. "Egy adásvételi szerződés már folyamatban van!", 0, 0, 0, true)
								end
							elseif inti then
								local intidata = exports.seal_interiors:getInteriorData(inti[1])

								if intidata then
									if intidata.type == "house" or intidata.type == "garage" then
										if intidata.ownerId == getElementData(localPlayer, "char.ID") then
											if not gotSelling then
												gotSelling = true

												triggerServerEvent("tryToSellInterior", localPlayer, targetPlayer, inti[1], intidata, amount)
											else
												outputChatBox("#d75959[SealMTA]: #ffffff" .. "Egy adásvételi szerződés már folyamatban van!", 0, 0, 0, true)
											end
										else
											outputChatBox("#d75959[SealMTA]: #ffffff" .. "Ez az ingatlan nem a tiéd.", 0, 0, 0, true)
										end
									end
								end
							end
						else
							outputChatBox("#d75959[SealMTA]: #ffffff" .. "Maradjunk a nullánál nagyobb egész számoknál.", 0, 0, 0, true)
						end
					else
						outputChatBox("#d75959[SealMTA]: #ffffff" .. "A kiválasztott játékos túl messze van tőled.", 0, 0, 0, true)
					end
				else
					outputChatBox("#d75959[SealMTA]: #ffffff" .. "Magadnak nem adhatod el.", 0, 0, 0, true)
				end
			end
		end
	end)