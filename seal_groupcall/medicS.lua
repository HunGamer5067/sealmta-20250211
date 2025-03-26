local callerPlayers = {}
local callTimers = {}

addEvent("callAmbulance", true)
addEventHandler("callAmbulance", getRootElement(),
	function (phoneNumber)
		if isElement(client) then
			if not getElementData(client, "isCalledMedic") then 
				local x, y, z = getElementPosition(client)
				local callID = 1

				for i = 1, #callerPlayers + 1 do
					if not callerPlayers[i] then
						callID = i
						break
					end
				end

				callerPlayers[callID] = client
				callTimers[client] = setTimer(cancelAuto, 1000 * 60 * 15, 1, client, callID)
				setElementData(client, "isCalledMedic", true)

				triggerClientEvent("medicMessageFromServer", resourceRoot, "Hívás érkezett! (" .. getZoneName(x, y, z) .. ")")
				triggerClientEvent("medicMessageFromServer", resourceRoot, "Elfogadáshoz: /acceptmedic " .. callID .. " vagy /acceptmedic auto")
			else
				outputChatBox("#d75959[SealMTA]: #FFFFFFMár hívtál egy mentőt.", client, 255, 255, 255, true)
			end
		end
	end
)

function cancelAuto(playerElement, callID, disconnected)
	if not disconnected then
		triggerClientEvent("medicMessageFromServer", resourceRoot, "Mivel az " .. callID .. ". számú hívásra nem válaszolt senki 15 percig, ezért törlődött.")
	end

	if callerPlayers[callID] then
		if callerPlayers[callID] == playerElement then
			callerPlayers[callID] = nil
		end
	end

	if isTimer(callTimers[playerElement]) then
		killTimer(callTimers[playerElement])
	end

	callTimers[playerElement] = nil
end

addEvent("endTheMedic", true)
addEventHandler("endTheMedic", getRootElement(),
	function (callerId)
		if callerId then
			callerPlayers[callerId] = nil
		end
	end
)

addCommandHandler("acceptmedic",
	function (sourcePlayer, commandName, callerId)
		if exports.seal_groups:isPlayerInGroup(sourcePlayer, {3}) then
			if callerId == "auto" then
				local lastId = false

				for k, v in pairs(callerPlayers) do
					if v ~= "accepted" then
						lastId = k
					end
				end

				if lastId then
					acceptMedic(sourcePlayer, lastId)
				else
					medicMessage("Nincs fogadatlan hívás.", sourcePlayer)
				end
			else
				callerId = tonumber(callerId)

				if callerId then
					acceptMedic(sourcePlayer, callerId)
				else
					medicMessage("/" .. commandName .. " [< szám | auto >]", sourcePlayer)
				end
			end
		end
	end
)

function acceptMedic(playerElement, callerId)
	if callerPlayers[callerId] then
		local targetPlayer = callerPlayers[callerId]

		if isElement(targetPlayer) then
			if isTimer(callTimers[targetPlayer]) then
				killTimer(callTimers[targetPlayer])
			end

			callTimers[targetPlayer] = nil
		
			local visibleName = getElementData(playerElement, "visibleName"):gsub("_", " ")

			triggerClientEvent(playerElement, "handleMedicBlip", playerElement, targetPlayer, callerId)
			triggerClientEvent("medicMessageFromServer", resourceRoot, visibleName .. " elfogadta az " .. callerId .. ". számú hívást.")
			triggerClientEvent("radioSoundForMedic", resourceRoot)

			exports.seal_hud:showInfobox(targetPlayer, "s", "Elfogadták a hívásod! Maradj a helyszínen.")
			setElementData(targetPlayer, "isCalledMedic", false)
		else
			if targetPlayer == "accepted" then
				medicMessage("Már elfogadta egy kollegád.", playerElement)
			end
		end

		callerPlayers[callerId] = "accepted"
	else
		medicMessage("Nincs hívás ezzel az azonosítóval.", playerElement)
	end
end

function medicMessage(message, playerElement)
	outputChatBox("#4adfbf[SealMTA - Mentő]:#FFFFFF " .. message, playerElement, 255, 255, 255, true)
end