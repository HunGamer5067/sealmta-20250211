addCommandHandler("auncuff",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if getElementData(targetPlayer, "cuffed") then
						triggerEvent("cuffPlayer", sourcePlayer, targetPlayer)
						exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
					else
						outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos nincs megbilincselve.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addCommandHandler("acuff",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if not getElementData(targetPlayer, "cuffed") then
						triggerEvent("cuffPlayer", sourcePlayer, targetPlayer)
						exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
					else
						outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos már meg van bilincselve.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addCommandHandler("cuff",
	function (sourcePlayer, commandName, targetPlayer)
		if exports.seal_groups:isPlayerHavePermission(sourcePlayer, "cuff") then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer and targetPlayer ~= sourcePlayer then
					local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(sourcePlayer)
					local targetPosX, targetPosY, targetPosZ = getElementPosition(targetPlayer)

					local sourceInterior = getElementInterior(sourcePlayer)
					local targetInterior = getElementInterior(targetPlayer)

					local sourceDimension = getElementDimension(sourcePlayer)
					local targetDimension = getElementDimension(targetPlayer)

					local distance = getDistanceBetweenPoints3D(sourcePosX, sourcePosY, sourcePosZ, targetPosX, targetPosY, targetPosZ)

					if distance <= 5 and sourceInterior == targetInterior and sourceDimension == targetDimension then
						triggerEvent("cuffPlayer", sourcePlayer, targetPlayer)
					else
						outputChatBox("#d75959[Bilincs]: #ffffffA kiválasztott játékos túl messze van tőled.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addEvent("cuffPlayer", true)
addEventHandler("cuffPlayer", getRootElement(),
	function (targetPlayer)
		if isElement(source) and isElement(targetPlayer) then
			if client ~= source then

			end

			local state = not getElementData(targetPlayer, "cuffed")
			local targetPlayerPos = {getElementPosition(targetPlayer)}
			local sourcePlayerPos = {getElementPosition(source)}
			local distance = getDistanceBetweenPoints3D(targetPlayerPos[1], targetPlayerPos[2], targetPlayerPos[3], sourcePlayerPos[1], sourcePlayerPos[2], sourcePlayerPos[3])
			
			if distance > 15 then
				return
			end
			if not exports.seal_items:hasItem(source, 48) and not ((getElementData(source, "acc.adminLevel") or 0) >= 1) then
				return
			end

			setElementData(targetPlayer, "cuffed", state)

			if not state then
				setElementData(targetPlayer, "visz", false)
			end
			
			if state then
				exports.seal_controls:toggleControl(targetPlayer, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, false)
			else
				exports.seal_controls:toggleControl(targetPlayer, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, true)
			end

			local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")
			local playerName = getElementData(source, "visibleName"):gsub("_", " ")

			if state then
				outputChatBox("#4adfbf[Bilincs]: #ffffffSikeresen megbilincselted a kiválasztott játékost! #6094cb(" .. targetName .. ")", source, 255, 255, 255, true)
				outputChatBox("#4adfbf[Bilincs]: #6094cb" .. playerName .. " #ffffffmegbilincselt téged!", targetPlayer, 255, 255, 255, true)

				exports.seal_chat:localAction(source, "megbilincselte " .. targetName .. "-t.")
			else
				removeElementData(source, "grabbedPlayer")
				outputChatBox("#4adfbf[Bilincs]: #ffffffSikeresen elengedted a kiválasztott játékost! #6094cb(" .. targetName .. ")", source, 255, 255, 255, true)
				outputChatBox("#4adfbf[Bilincs]: #6094cb" .. playerName .. " #fffffflevette rólad a bilincset!", targetPlayer, 255, 255, 255, true)

				exports.seal_chat:localAction(source, "elengedte " .. targetName .. "-t.")
			end
		end
	end)

local warpTimer = {}

addCommandHandler("visz",
	function (sourcePlayer, commandName, targetPlayer)
		if exports.seal_groups:isPlayerHavePermission(sourcePlayer, "cuff") then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer and targetPlayer ~= sourcePlayer then
					local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(sourcePlayer)
					local targetPosX, targetPosY, targetPosZ = getElementPosition(targetPlayer)

					local sourceInterior = getElementInterior(sourcePlayer)
					local targetInterior = getElementInterior(targetPlayer)

					local sourceDimension = getElementDimension(sourcePlayer)
					local targetDimension = getElementDimension(targetPlayer)

					local distance = getDistanceBetweenPoints3D(sourcePosX, sourcePosY, sourcePosZ, targetPosX, targetPosY, targetPosZ)

					if distance <= 5 and sourceInterior == targetInterior and sourceDimension == targetDimension then
						if getElementData(targetPlayer, "cuffed") then
							triggerEvent("viszPlayer", sourcePlayer, targetPlayer)
						else
							outputChatBox("#d75959[Vezetőszár]: #ffffffA kiválasztott játékos nincs megbilincselve.", sourcePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[Vezetőszár]: #ffffffA kiválasztott játékos túl messze van tőled.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addEvent("viszPlayer", true)
addEventHandler("viszPlayer", getRootElement(),
	function (targetPlayer)
		if isElement(source) and isElement(targetPlayer) then
			local targetPlayerPos = {getElementPosition(targetPlayer)}
			local sourcePlayerPos = {getElementPosition(source)}
			local distance = getDistanceBetweenPoints3D(targetPlayerPos[1], targetPlayerPos[2], targetPlayerPos[3], sourcePlayerPos[1], sourcePlayerPos[2], sourcePlayerPos[3])
			
			if distance > 15 then
				return
			end
			if not getElementData(targetPlayer, "cuffed") then
				return
			end
			
			local state = not getElementData(targetPlayer, "visz")

			if warpTimer[targetPlayer] then
				if isTimer(warpTimer[targetPlayer]) then
					killTimer(warpTimer[targetPlayer])
				end
			end

			if state then
				setElementData(targetPlayer, "visz", source)
				setElementData(source, "grabbedPlayer", targetPlayer)
				setElementData(targetPlayer, "cuffAnimation", 1)
				if getPedOccupiedVehicle(targetPlayer) then
					removePedFromVehicle(targetPlayer)
					warpPlayer(targetPlayer, source)
				end
				warpTimer[targetPlayer] = setTimer(warpPlayer, 1500, 0, targetPlayer, source)
			else
				if getElementData(targetPlayer, "cuffed") then
					setElementData(targetPlayer, "cuffAnimation", 3)
				else
					setElementData(targetPlayer, "cuffAnimation", false)
				end
				removeElementData(source, "grabbedPlayer")

				setElementData(targetPlayer, "visz", false)
				warpTimer[targetPlayer] = nil
			end

			local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")
			local playerName = getElementData(source, "visibleName"):gsub("_", " ")

			if state then
				outputChatBox("#4adfbf[Vezetőszár]: #ffffffElkezdted vinni a kiválasztott játékost! #6094cb(" .. targetName .. ")", source, 255, 255, 255, true)
			else
				outputChatBox("#4adfbf[Vezetőszár]: #ffffffSikeresen elengedted a kiválasztott játékost! #6094cb(" .. targetName .. ")", source, 255, 255, 255, true)
			end
		end
	end)

function warpPlayer(player, target)
	if isElement(player) and isElement(target) then
		local playerInterior = getElementInterior(player)
		local targetInterior = getElementInterior(target)

		local playerDimension = getElementDimension(player)
		local targetDimension = getElementDimension(target)

		local playerPosX, playerPosY, playerPosZ = getElementPosition(player)
		local targetPosX, targetPosY, targetPosZ = getElementPosition(target)

		local _, _, playerRotZ = getElementRotation(player)
		local _, _, targetRotZ = getElementRotation(target)
		local angle = math.rad(targetRotZ + 180 - playerRotZ)

		local deltaX = targetPosX - playerPosX
		local deltaY = targetPosY - playerPosY
		local distance = deltaX * deltaX + deltaY * deltaY

		if playerInterior ~= targetInterior or playerDimension ~= targetDimension or distance > 10 then
			setElementPosition(player, targetPosX + math.cos(angle) / 2, targetPosY + math.sin(angle) / 2, targetPosZ)
			setElementInterior(player, targetInterior)
			setElementDimension(player, targetDimension)
		end
	else
		if isTimer(warpTimer[player]) then
			killTimer(warpTimer[player])
		end

		warpTimer[player] = nil
	end
end

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		setElementData(source, "cuffed", false)
		setElementData(source, "cuffAnimation", false)
		setElementData(source, "visz", false)
	end)

addEventHandler("onPlayerWasted", getRootElement(),
	function ()
		setElementData(source, "cuffed", false)
		setElementData(source, "cuffAnimation", false)
		setElementData(source, "visz", false)
	end)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue, newValue)
		if dataName == "visz" then
			if not newValue then
				if warpTimer[source] then
					if isTimer(warpTimer[source]) then
						killTimer(warpTimer[source])
					end

					warpTimer[source] = nil
				end
			end
		end
	end)