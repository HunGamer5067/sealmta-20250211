local groupRadio = {
	[911] = 4, -- NNI
	[112] = 1, -- PD
	[66] = 2, -- TEK
	[999] = 8, -- NAV
	[104] = 3, -- OMSZ
}

addCommandHandler("tuneradio",
	function (sourcePlayer, commandName, value)
		if getElementData(sourcePlayer, "loggedIn") then
			value = tonumber(value)
		
			if not value then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Frekvencia]", sourcePlayer, 0, 0, 0, true)
			else
				if value >= 0 and value <= 1000000000 then
					if not exports.seal_items:hasItem(sourcePlayer, 4) then
						outputChatBox("#d75959[SealMTA]: #ffffffNincs rádiód!", sourcePlayer, 0, 0, 0, true)
						return
					end

					setElementData(sourcePlayer, "char.Radio", value)

					outputChatBox("#4adfbf[SealMTA]: #ffffffFrekvencia sikeresen beállítva.", sourcePlayer, 0, 0, 0, true)
				else
					outputChatBox("#d75959[SealMTA]: #ffffffÉrvénytelen rádió frekvencia!", sourcePlayer, 0, 0, 0, true)
				end
			end
		end
	end)

addCommandHandler("tuneradio2",
	function (sourcePlayer, commandName, value)
		if getElementData(sourcePlayer, "loggedIn") then
			value = tonumber(value)
		
			if not value then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Frekvencia]", sourcePlayer, 0, 0, 0, true)
			else
				if value >= 0 and value <= 1000000000 then
					if not exports.seal_items:hasItem(sourcePlayer, 4) then
						outputChatBox("#d75959[SealMTA]: #ffffffNincs rádiód!", sourcePlayer, 0, 0, 0, true)
						return
					end

					setElementData(sourcePlayer, "char.Radio2", value)

					outputChatBox("#4adfbf[SealMTA]: #ffffffMásodlagos frekvencia sikeresen beállítva.", sourcePlayer, 0, 0, 0, true)
				else
					outputChatBox("#d75959[SealMTA]: #ffffffÉrvénytelen rádió frekvencia!", sourcePlayer, 0, 0, 0, true)
				end
			end
		end
	end)

function onRadio(sourcePlayer, commandName, ...)
	if getElementData(sourcePlayer, "loggedIn") then
		if not (...) then
			outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 0, 0, 0, true)
		else
			if not exports.seal_items:hasItem(sourcePlayer, 4) then
				outputChatBox("#d75959[SealMTA]: #ffffffNincs rádiód!", sourcePlayer, 0, 0, 0, true)
				return
			end

			local tuneRadio = getElementData(sourcePlayer, "char.Radio") or 0
			if tuneRadio == 0 then
				outputChatBox("#d75959[SealMTA]: #ffffffNincs beállítva rádiófrekvencia!", sourcePlayer, 0, 0, 0, true)
				return
			end

			local groupId = (groupRadio[tuneRadio] or false)
			if groupId then
				if not exports.seal_groups:isPlayerInGroup(sourcePlayer, groupId) then
					outputChatBox("#d75959[SealMTA]: #ffffffEzt a frekvenciát csak az adott csoport tagjai használhatják!", sourcePlayer, 0, 0, 0, true)
					return
				end
			end

			local affected = {}
			local players = getElementsByType("player")

			for i = 1, #players do
				local targetPlayer = players[i]

				if targetPlayer ~= sourcePlayer then
					if exports.seal_items:hasItem(targetPlayer, 4) then
						if (getElementData(targetPlayer, "char.Radio") or getElementData(targetPlayer, "char.Radio2")) == tuneRadio then
							table.insert(affected, targetPlayer)
						end
					end
				end
			end

			local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
			local message = utf8.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")
			local playerRank = ""

			if groupId then
				playerRank = select(2, exports.seal_groups:getPlayerRank(sourcePlayer, groupId))
			end

			table.insert(affected, sourcePlayer)

			for i = 1, #affected do
				local targetPlayer = affected[i]

				if targetPlayer ~= sourcePlayer then

					if not groupId then
						outputChatBox("#00ced1" .. playerRank .. " " .. playerName .. " mondja ((rádióba)): " .. message, targetPlayer, 0, 0, 0, true)
					elseif groupId and exports.seal_groups:isPlayerInGroup(targetPlayer, groupId) then
						outputChatBox("#00ced1" .. playerRank .. " " .. playerName .. " mondja ((rádióba)): " .. message, targetPlayer, 0, 0, 0, true)
					else
						outputChatBox("#00ced1" .. trunklateText(playerRank .. " " .. playerName, 2) .. " mondja ((rádióba)): " .. trunklateText(message, 10), targetPlayer, 0, 0, 0, true)
					end
				end
			end

			outputChatBox("#00ced1" .. playerRank .. " " .. playerName .. " mondja ((rádióba)): " .. message, sourcePlayer, 0, 0, 0, true)

			triggerClientEvent(sourcePlayer, "localRadioMessage", sourcePlayer, message)

			triggerClientEvent(affected, "playRadioSound", sourcePlayer)
		end
	end
end
addCommandHandler("r", onRadio)
addCommandHandler("Rádió", onRadio)

addCommandHandler("r2",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "loggedIn") then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				if not exports.seal_items:hasItem(sourcePlayer, 4) then
					outputChatBox("#d75959[SealMTA]: #ffffffNincs rádiód!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local tuneRadio = getElementData(sourcePlayer, "char.Radio2") or 0
				if tuneRadio == 0 then
					outputChatBox("#d75959[SealMTA]: #ffffffNincs beállítva másodlagos rádiófrekvencia!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local groupId = (groupRadio[tuneRadio] or false)
				if groupId then
					if not exports.seal_groups:isPlayerInGroup(sourcePlayer, groupId) then
						outputChatBox("#d75959[SealMTA]: #ffffffEzt a frekvenciát csak az adott csoport tagjai használhatják!", sourcePlayer, 0, 0, 0, true)
						return
					end
				end

				local affected = {}
				local players = getElementsByType("player")

				for i = 1, #players do
					local targetPlayer = players[i]

					if targetPlayer ~= sourcePlayer then
						if exports.seal_items:hasItem(targetPlayer, 4) then
							if (getElementData(targetPlayer, "char.Radio2") or getElementData(targetPlayer, "char.Radio2")) == tuneRadio then
								table.insert(affected, targetPlayer)
							end
						end
					end
				end

				local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
				local message = utf8.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				table.insert(affected, sourcePlayer)

				for i = 1, #affected do
					local targetPlayer = affected[i]

					if targetPlayer ~= sourcePlayer then
						if not groupId then
							outputChatBox("#00999c" .. playerName .. " mondja ((rádióba)): " .. message, targetPlayer, 0, 0, 0, true)
						end
					end
				end

				outputChatBox("#00999c" .. playerName .. " mondja ((rádióba)): " .. message, sourcePlayer, 0, 0, 0, true)
				triggerClientEvent(sourcePlayer, "localRadioMessage", sourcePlayer, message)
				triggerClientEvent(affected, "playRadioSound", sourcePlayer)
			end
		end
	end
)

addCommandHandler("d",
	function (sourcePlayer, commandName, ...)
		local groupId = exports.seal_groups:isPlayerHavePermission(sourcePlayer, "departmentRadio")

		if groupId then
			if not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				if not exports.seal_items:hasItem(sourcePlayer, 4) then
					outputChatBox("#d75959[SealMTA]: #ffffffNincs rádiód!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local affected = {}
				local players = getElementsByType("player")

				for i = 1, #players do
					local targetPlayer = players[i]

					if targetPlayer ~= sourcePlayer then
						if exports.seal_items:hasItem(targetPlayer, 4) then
							if exports.seal_groups:isPlayerHavePermission(targetPlayer, "departmentRadio") then
								table.insert(affected, targetPlayer)
							end
						end
					end
				end

				local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
				local message = utf8.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				local groupPrefix = exports.seal_groups:getGroupPrefix(groupId)
				local playerRank = select(2, exports.seal_groups:getPlayerRank(sourcePlayer, groupId))

				table.insert(affected, sourcePlayer)

				for i = 1, #affected do
					local targetPlayer = affected[i]

					if targetPlayer ~= sourcePlayer then
						outputChatBox("#d75959[" .. groupPrefix .. "]: " .. playerRank .. " " .. playerName .. " mondja ((rádióba)): " .. message, targetPlayer, 0, 0, 0, true)
					end
				end

				outputChatBox("#d75959[" .. groupPrefix .. "]: " .. playerRank .. " " .. playerName .. " mondja ((rádióba)): " .. message, sourcePlayer, 0, 0, 0, true)

				triggerClientEvent(sourcePlayer, "localRadioMessage", sourcePlayer, message)

				triggerClientEvent(affected, "playRadioSound", sourcePlayer)
			end
		end
	end)

addEvent("localRadioMessage", true)
addEventHandler("localRadioMessage", getRootElement(),
	function (message, players)
		if isElement(source) then
			local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
			
			for k, v in ipairs(players) do
				if isElement(v[1]) then
					outputChatBox(v[2] .. visibleName .. " mondja (rádióba): " .. message, v[1], 0, 0, 0, true)
				end
			end
		end
	end)

function trunklateText(text, level)
	level = math.ceil(level * #text / 2)

	for i = 1, level do
		x = math.random(1, #text)

		if text:sub(x, x) == " " then
			i = i - 1
		else
			local a = text:sub(1, x - 1) or ""
			local b = text:sub(x + 1) or ""
			local c = ""

			if math.random(6) == 1 then
				c = string.char(math.random(65, 90))
			else
				c = string.char(math.random(97, 122))
			end

			text = a .. c .. b
		end
	end

	return text
end

addEvent("onShipRadio", true)
addEventHandler("onShipRadio", getRootElement(),
	function (vehicles, players, message)
		if isElement(source) then
			triggerClientEvent(players, "onShipRadio", source, message, vehicles)
		end
	end)

addEvent("onAirRadio", true)
addEventHandler("onAirRadio", getRootElement(),
	function (vehicles, players, message)
		if isElement(source) then
			triggerClientEvent(players, "onAirRadio", source, message, vehicles)
		end
	end)