local policeCallers = {}
local policeTimers = {}
local calledPolice = {}

addEvent("callPolice", true)
addEventHandler("callPolice", getRootElement(), function(phoneNumber)
	if client == source then
		if calledPolice[client] then
			outputChatBox("#d75959[SealMTA]: #FFFFFFMár hívtál egy rendőrt.", client, 255, 255, 255, true)
			return
		end

		local x, y, z = getElementPosition(client)
		local callID = 1

		for i = 1, #policeCallers + 1 do
			if not policeCallers[i] then
				callID = i
				break
			end
		end

		policeCallers[callID] = client
		policeTimers[client] = setTimer(cancelAuto, 1000 * 60 * 15, 1, client, callID)
		calledPolice[client] = true

		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=hudwhite]Hívás érkezett! Hívó telefonszáma: [color=green]" .. phoneNumber .. " ((" .. getElementData(client, "visibleName"):gsub("_", " ") .. "))")
		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=hudwhite]Elfogadáshoz: [color=green]/acceptpolice " .. callID .. " [color=hudwhite]vagy [color=green]/acceptpolice auto")
	end
end)

addEvent("reportPolice", true)
addEventHandler("reportPolice", getRootElement(), function(phoneNumber, reportText)
	if client == source then
		if calledPolice[client] then
			outputChatBox("#d75959[SealMTA]: #FFFFFFMár hívtál egy rendőrt.", client, 255, 255, 255, true)
			return
		end

		local x, y, z = getElementPosition(client)
		local callID = 1

		for i = 1, #policeCallers + 1 do
			if not policeCallers[i] then
				callID = i
				break
			end
		end

		policeCallers[callID] = client
		policeTimers[client] = setTimer(cancelAuto, 1000 * 60 * 15, 1, client, callID)
		calledPolice[client] = true

		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=hudwhite]Bejelentés érkezett! Bejelentő telefonszáma: [color=green]" .. phoneNumber .. " ((" .. getElementData(client, "visibleName"):gsub("_", " ") .. "))")
		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=hudwhite]Bejelentés szövege:")
		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=red]" .. reportText)
	end
end)

function cancelAuto(playerElement, callID, disconnected)
	if not disconnected then
		triggerClientEvent("policeMessageFromServer", client, "[color=blue][SealMTA - Rendőrség]: [color=hudwhite]Mivel az " .. callID .. ". számú hívásra nem válaszolt senki 15 percig, ezért törlődött.")
	end

	if policeCallers[callID] then
		if policeCallers[callID] == playerElement then
			policeCallers[callID] = nil
		end
	end

	if isTimer(policeTimers[playerElement]) then
		killTimer(policeTimers[playerElement])
	end

	policeTimers[playerElement] = nil
end

addEvent("endTheMedic", true)
addEventHandler("endTheMedic", getRootElement(),
	function (callID)
		if callID then
			policeCallers[callID] = nil
		end
	end
)

addCommandHandler("acceptpolice",
	function (sourcePlayer, commandName, callID)
		if exports.seal_groups:isPlayerInGroup(sourcePlayer, {1, 2, 4, 8}) then
			if callID == "auto" then
				local lastId = false

				for k, v in pairs(policeCallers) do
					if v ~= "accepted" then
						lastId = k
					end
				end

				if lastId then
					acceptPolice(sourcePlayer, lastId)
				else
					policeMessage("Nincs fogadatlan hívás.", sourcePlayer)
				end
			else
				callID = tonumber(callID)

				if callID then
					acceptPolice(sourcePlayer, callID)
				else
					policeMessage("/" .. commandName .. " [< szám | auto >]", sourcePlayer)
				end
			end
		end
	end
)

function acceptPolice(playerElement, callID)
	if policeCallers[callID] then
		local targetPlayer = policeCallers[callID]

		if isElement(targetPlayer) then
			if isTimer(policeTimers[targetPlayer]) then
				killTimer(policeTimers[targetPlayer])
			end

			policeTimers[targetPlayer] = nil
		
			local visibleName = getElementData(playerElement, "visibleName"):gsub("_", " ")

			triggerClientEvent(playerElement, "handleMedicBlip", playerElement, targetPlayer, callID)
			triggerClientEvent("policeMessageFromServer", resourceRoot, visibleName .. " elfogadta az " .. callID .. ". számú hívást.")
			triggerClientEvent("radioSoundForMedic", resourceRoot)

			exports.seal_gui:showInfobox(targetPlayer, "s", "Elfogadták a hívásod! Maradj a helyszínen.")
			calledPolice[targetPlayer] = false
		else
			if targetPlayer == "accepted" then
				policeMessage("Már elfogadta egy kollegád.", playerElement)
			end
		end

		policeCallers[callID] = "accepted"
	else
		policeMessage("Nincs hívás ezzel az azonosítóval.", playerElement)
	end
end

function policeMessage(message, playerElement)
	outputChatBox("#4adfbf[SealMTA - Rendőrség]:#FFFFFF " .. message, playerElement, 255, 255, 255, true)
end