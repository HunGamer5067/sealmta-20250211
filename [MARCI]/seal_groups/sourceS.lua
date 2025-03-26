local connection = false
local maximumRanks = 25

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.seal_database:getConnection()

		if connection then
			dbQuery(loadAllGroup, connection, "SELECT * FROM groups")
		end
	end)

local enabledPDGroups = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[8] = true,
}

addCommandHandler("getpdcount",
	function(sourcePlayer)
		local count = 0
		for k, v in pairs(getElementsByType("player")) do
			local playerGroups = (getElementData(v, "player.groups") or {})
			
			for k in pairs(playerGroups) do
				if enabledPDGroups[k] then
					count = count + 1
					break
				end
			end
		end
		outputChatBox("#4adfbf[SealMTA]: #ffffffOnline rendvédelmisek száma: #4adfbf"..count, sourcePlayer, 255, 255, 255, true)
	end
)

function loadAllGroup(qh)
	local resultTable = dbPoll(qh, 0)

	if resultTable then
		for k, v in pairs(resultTable) do
			local id = v.groupId

			if availableGroups[id] then
				availableGroups[id].balance = tonumber(v.balance) or 0
				availableGroups[id].description = v.description

				if not availableGroups[id].ranks then
					availableGroups[id].ranks = {}
				end

				local ranksTable = split(v.ranks, ",")
				local rankPaysTable = split(v.ranks_pay, ",")

				for i = 1, maximumRanks do
					if not availableGroups[id].ranks[i] then
						availableGroups[id].ranks[i] = {}
					end

					availableGroups[id].ranks[i].name = ranksTable[i] or "rang " .. i
					availableGroups[id].ranks[i].pay = tonumber(rankPaysTable[i]) or 0
				end

				if not availableGroups[id].permissions then
					availableGroups[id].permissions = {}
				end

				if not availableGroups[id].duty then
					availableGroups[id].duty = {}
				end

				if not availableGroups[id].duty.skins then
					availableGroups[id].duty.skins = {}
				end
			else
				--outputDebugString("Group " .. id .. ". not found in the table.")
			end
		end
	end
end

function loadPlayerGroups(thePlayer)
	local characterId = tonumber(getElementData(thePlayer, "char.ID"))

	if characterId then
		dbQuery(
			function (qh)
				local result = dbPoll(qh, 0)
				local groups = {}

				if result then
					for k, v in ipairs(result) do
						groups[v.groupId] = {v.rank, v.dutySkin, v.isLeader}
					end
				end

				setElementData(thePlayer, "player.groups", groups)
			end,
		connection, "SELECT * FROM groupmembers WHERE characterId = ?", characterId)
	end
end

function requestGroupData(source, groups, characterId, groupId)
	local groupIds = {}

	for k, v in pairs(groups) do
		table.insert(groupIds, k)
	end

	if #groupIds > 0 then
		local members = {}

		dbQuery(
			function (qh, client)
				local result, rows = dbPoll(qh, 0)
				
				for k, row in ipairs(result) do
					if row.characterName then
						local group = row.groupId

						if not members[group] then
							members[group] = {}
						end

						table.insert(members[group], row)
					end
				end

				triggerClientEvent(client, "receiveGroupMembers", client, members, characterId, groupId)
			end,
		{source}, connection, [[
			SELECT groupmembers.groupId AS groupId, groupmembers.rank AS rank, groupmembers.isLeader AS isLeader, groupmembers.dutySkin AS dutySkin, characters.name AS characterName, characters.characterId AS id, characters.lastOnline AS lastOnline 
			FROM groupmembers 
			LEFT JOIN characters 
			ON characters.characterId = groupmembers.characterId 
			WHERE groupmembers.groupId IN (]] .. table.concat(groupIds, ",") .. [[) 
			ORDER BY groupmembers.groupId, groupmembers.rank, characters.name
		]])
	end
end

addEvent("requestGroupData", true)
addEventHandler("requestGroupData", getRootElement(),
	function (groups)
		if isElement(source) and groups then
			requestGroupData(source, groups)
		end
	end)

addEvent("requestGroups", true)
addEventHandler("requestGroups", getRootElement(),
	function ()
		if isElement(source) then
			triggerClientEvent(source, "receiveGroups", source, availableGroups)
		end
	end)

function reloadGroupDatasForPlayer(qh, player, sourcePlayer, sourceGroups, characterId, groupId)
	if isElement(player) then
		loadPlayerGroups(player)
	end

	if isElement(sourcePlayer) then
		requestGroupData(sourcePlayer, sourceGroups, characterId, groupId)
	end

	dbFree(qh)
end

addEvent("modifyLeaderForPlayer", true)
addEventHandler("modifyLeaderForPlayer", getRootElement(), function(characterId, groupId, state, player, playerGroups)
	if characterId and groupId and state then
		if (isPlayerLeaderInGroup(client, groupId) or getElementData(client, "acc.adminLevel") >= 6) then
			if state == "give" then
				dbQuery(reloadGroupDatasForPlayer, {player, client, playerGroups, characterId, groupId}, connection, "UPDATE groupmembers SET isLeader = 'Y' WHERE groupId = ? AND characterId = ?", groupId, characterId)
			elseif state == "take" then
				dbQuery(reloadGroupDatasForPlayer, {player, client, playerGroups, characterId, groupId}, connection, "UPDATE groupmembers SET isLeader = 'N' WHERE groupId = ? AND characterId = ?", groupId, characterId)
			end
		end
	end
end)

addEvent("modifyRankForPlayer", true)
addEventHandler("modifyRankForPlayer", getRootElement(), function(characterId, currRank, groupId, state, player, sourceGroups, refreshDashboard)
	if characterId and currRank and groupId and state then
		if (isPlayerLeaderInGroup(client, groupId) or getElementData(client, "acc.adminLevel") >= 6) then
			if state == "up" then
				if currRank < maximumRanks then
					dbQuery(reloadGroupDatasForPlayer, {player, source, sourceGroups, characterId, groupId, refreshDashboard}, connection, "UPDATE groupmembers SET rank = ? WHERE groupId = ? AND characterId = ?", currRank + 1, groupId, characterId)
				end
			elseif state == "down" then
				if currRank > 1 then
					dbQuery(reloadGroupDatasForPlayer, {player, source, sourceGroups, characterId, groupId, refreshDashboard}, connection, "UPDATE groupmembers SET rank = ? WHERE groupId = ? AND characterId = ?", currRank - 1, groupId, characterId)
				end
			end
		end
	end
end)

addEvent("deletePlayerFromGroup", true)
addEventHandler("deletePlayerFromGroup", getRootElement(), function(characterId, groupId, player, sourceGroups)
	if characterId and groupId then
		if (isPlayerLeaderInGroup(client, groupId) or getElementData(client, "acc.adminLevel") >= 6) then
			if isElement(player) then
				exports.seal_gui:showInfobox(player, "s", "Kirúgtak egy frakcióból. (" .. getGroupName(groupId) .. ")")
			end

			dbQuery(reloadGroupDatasForPlayer, {player, client, sourceGroups}, connection, "DELETE FROM groupmembers WHERE groupId = ? AND characterId = ?", groupId, characterId)
		end
	end
end)

addEvent("invitePlayerToGroup", true)
addEventHandler("invitePlayerToGroup", getRootElement(), function (characterId, groupId, player, sourceGroups)
	if characterId and groupId then
		if (isPlayerLeaderInGroup(client, groupId) or getElementData(client, "acc.adminLevel") >= 6) then
			dbQuery(function(queryHandle, player, client, sourceGroups)
				local queryResult = dbPoll(queryHandle, 0)

				if #queryResult == 0 then
					dbQuery(reloadGroupDatasForPlayer, {player, client, sourceGroups}, connection, "INSERT INTO groupmembers (groupId, characterId) VALUES (?,?)", groupId, characterId)
					exports.seal_gui:showInfobox(client, "s", "Sikeresen felvetted a játékost a frakcióba.")

					if isElement(player) then
						exports.seal_gui:showInfobox(player, "s", "Felvettek egy frakcióba. (" .. getGroupName(groupId) .. ")")
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A játékos már tagja a frakciónak.")
				end
			end, {player, client, sourceGroups}, connection, "SELECT * FROM groupmembers WHERE groupId = ? AND characterId = ?", groupId, characterId)
		end
	end
end)

addCommandHandler("setplayerleader",
	function (sourcePlayer, commandName, targetPlayer, groupId, isLeader)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			groupId = tonumber(groupId)
			isLeader = tonumber(isLeader)

			if not (targetPlayer and groupId and isLeader) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Csoport ID] [Leader (0 = nem | 1 = igen)]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if availableGroups[groupId] then
						if isPlayerInGroup(targetPlayer, groupId) then
							if isLeader == 0 then
								if isPlayerLeaderInGroup(targetPlayer, groupId) then
									dbQuery(
										function (qh)
											if isElement(targetPlayer) then
												loadPlayerGroups(targetPlayer)
											end

											if isElement(sourcePlayer) then
												outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen elvetted a kiválasztott játékos leader jogát a csoportból.", sourcePlayer, 255, 255, 255, true)
											end

											dbFree(qh)
										end,
									connection, "UPDATE groupmembers SET isLeader = 'N' WHERE groupId = ? AND characterId = ?", groupId, getElementData(targetPlayer, "char.ID"))
								else
									outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos nem leader a csoportban.", sourcePlayer, 255, 255, 255, true)
								end
							else
								if not isPlayerLeaderInGroup(targetPlayer, groupId) then
									dbQuery(
										function (qh)
											if isElement(targetPlayer) then
												loadPlayerGroups(targetPlayer)
											end

											if isElement(sourcePlayer) then
												outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen beállítottad a játékost a kiválasztott csoport leaderének.", sourcePlayer, 255, 255, 255, true)
											end

											dbFree(qh)
										end,
									connection, "UPDATE groupmembers SET isLeader = 'Y' WHERE groupId = ? AND characterId = ?", groupId, getElementData(targetPlayer, "char.ID"))
								else
									outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos már a csoport leadere.", sourcePlayer, 255, 255, 255, true)
								end
							end
						else
							outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos nem a csoport tagja.", sourcePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott csoport nem létezik.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addCommandHandler("addplayergroup",
	function (sourcePlayer, commandName, targetPlayer, groupId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			groupId = tonumber(groupId)

			if not (targetPlayer and groupId) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Csoport ID]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if availableGroups[groupId] then
						if not isPlayerInGroup(targetPlayer, groupId) then
							dbQuery(
								function (qh)
									if isElement(targetPlayer) then
										loadPlayerGroups(targetPlayer)
									end

									if isElement(sourcePlayer) then
										outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen hozzáadtad a játékost a kiválasztott csoporthoz.", sourcePlayer, 255, 255, 255, true)
									end

									dbFree(qh)
								end,
							connection, "INSERT INTO groupmembers (groupId, characterId) VALUES (?,?)", groupId, getElementData(targetPlayer, "char.ID"))
						else
							outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos már a csoport tagja.", sourcePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott csoport nem létezik.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addCommandHandler("removeplayergroup",
	function (sourcePlayer, commandName, targetPlayer, groupId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			groupId = tonumber(groupId)

			if not (targetPlayer and groupId) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Csoport ID]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if availableGroups[groupId] then
						if isPlayerInGroup(targetPlayer, groupId) then
							dbQuery(
								function (qh)
									if isElement(targetPlayer) then
										loadPlayerGroups(targetPlayer)
									end

									if isElement(sourcePlayer) then
										outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen eltávolítottad a játékost a kiválasztott csoportból.", sourcePlayer, 255, 255, 255, true)
									end

									dbFree(qh)
								end,
							connection, "DELETE FROM groupmembers WHERE groupId = ? AND characterId = ?", groupId, getElementData(targetPlayer, "char.ID"))
						else
							outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos nem a csoport tagja.", sourcePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott csoport nem létezik.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end)

addEvent("renameGroupRank", true)
addEventHandler("renameGroupRank", getRootElement(), function(rankId, rankName, groupId)
	if rankId and rankName and groupId then
		if (isPlayerLeaderInGroup(client, groupId) or getElementData(client, "acc.adminLevel") >= 6) then
			local ranks = {}

			availableGroups[groupId].ranks[rankId].name = rankName
			triggerClientEvent(getElementsByType("player"), "modifyGroupData", resourceRoot, groupId, "rankName", rankId, rankName)

			for i = 1, #availableGroups[groupId].ranks do
				table.insert(ranks, availableGroups[groupId].ranks[i].name)
			end

			dbExec(connection, "UPDATE groups SET ranks = ? WHERE groupId = ?", table.concat(ranks, ","), groupId)
			exports.seal_logs:logCommand(source, eventName, {groupId, getElementData(source, "visibleName"), rankName, "rank: " .. rankId})
		end
	end
end)

addEvent("setGroupRankPayment", true)
addEventHandler("setGroupRankPayment", getRootElement(),
	function (rankId, payment, groupId)
		if rankId and payment and groupId then
			local ranks_pay = {}

			availableGroups[groupId].ranks[rankId].pay = payment

			triggerClientEvent(getElementsByType("player"), "modifyGroupData", resourceRoot, groupId, "rankPayment", rankId, payment)

			for i = 1, #availableGroups[groupId].ranks do
				table.insert(ranks_pay, availableGroups[groupId].ranks[i].pay)
			end

			dbExec(connection, "UPDATE groups SET ranks_pay = ? WHERE groupId = ?", table.concat(ranks_pay, ","), groupId)

			exports.seal_logs:logCommand(source, eventName, {groupId, getElementData(source, "visibleName"), payment, "rank: " .. rankId})
		end
	end)

addEvent("rewriteGroupDescription", true)
addEventHandler("rewriteGroupDescription", getRootElement(),
	function (description, groupId)
		if description and groupId then
			availableGroups[groupId].description = description

			triggerClientEvent(getElementsByType("player"), "modifyGroupData", resourceRoot, groupId, "description", false, description)

			dbExec(connection, "UPDATE groups SET description = ? WHERE groupId = ?", description, groupId)

			exports.seal_logs:logCommand(source, eventName, {groupId, getElementData(source, "visibleName"), description})
		end
	end)

addEvent("setGroupBalance", true)
addEventHandler("setGroupBalance", getRootElement(),
	function (amount, groupId)
		if amount and groupId then
			local currentBalance = availableGroups[groupId].balance

			currentBalance = currentBalance + amount

			local currentMoney = getElementData(source, "char.Money") or 0

			if currentBalance < 0 then
				triggerClientEvent(source, "setInputError", source, "#d75959Nincs elegendő pénz a számlán.")
			else
				if amount > 0 and currentMoney < amount then
					triggerClientEvent(source, "setInputError", source, "#d75959Nincs nálad ennyi pénz.")
				else
					setElementData(source, "char.Money", currentMoney - amount)

					availableGroups[groupId].balance = currentBalance

					dbQuery(
						function (qh, player)
							exports.seal_logs:logCommand(player, "groupBalance", {groupId, getElementData(player, "visibleName"), amount .. " $", "balance: " .. currentBalance .. " $"})

							triggerClientEvent(player, "setInputError", player, "#4adfbfA tranzakció sikeresen megtörtént!")
							
							triggerClientEvent(getElementsByType("player"), "modifyGroupData", resourceRoot, groupId, "balance", false, currentBalance)

							dbFree(qh)
						end,
					{source}, connection, "UPDATE groups SET balance = ? WHERE groupId = ?", currentBalance, groupId)
				end
			end
		end
	end)

function getGroupBalance(groupId)
	if tonumber(groupId) then
		if availableGroups[groupId] then
			return tonumber(availableGroups[groupId].balance)
		else
			return false
		end
	else
		return false
	end
end

function setGroupBalance(groupId, balance)
	if tonumber(groupId) and tonumber(balance) then
		if availableGroups[groupId] then
			dbExec(connection, "UPDATE groups SET balance = ? WHERE groupId = ?", tonumber(balance), tonumber(groupId))
			availableGroups[groupId].balance = tonumber(balance)
		else
			return false
		end
	else
		return false
	end
end

function getGroupRankPay(groupId, rankId)
	if tonumber(groupId) and rankId then
		if availableGroups[groupId] then
			if availableGroups[groupId].ranks[rankId] then
				return availableGroups[groupId].ranks[rankId].pay or 0
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function sendGroupMessage(groupId, messages)
	if tonumber(groupId) and messages then
		if availableGroups[groupId] then
			local players = getElementsByType("player")

			for i = 1, #players do
				local player = players[i]

				if isElement(player) and isPlayerInGroup(player, groupId) then
					if type(messages) == "table" then
						for j = 1, #messages do
							outputChatBox(messages[j], player, 0, 0, 0, true)
						end
					else
						outputChatBox(messages, player, 0, 0, 0, true)
					end
				end
			end

			return true
		else
			return false
		end
	else
		return false
	end
end

addEvent("updateDutySkin", true)
addEventHandler("updateDutySkin", getRootElement(),
	function (groupId, selectedSkin, originalSkin)
		if groupId and availableGroups[groupId] then
			local characterId = getElementData(source, "char.ID")

			if characterId then
				local playerGroups = getElementData(source, "player.groups")

				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId][2] = selectedSkin
					end

					setElementData(source, "player.groups", playerGroups)
				end

				if getElementData(source, "inDuty") then
					setElementModel(source, selectedSkin)
				else
					setElementModel(source, originalSkin)
				end

				dbExec(connection, "UPDATE groupmembers SET dutySkin = ? WHERE groupId = ? AND characterId = ?", selectedSkin, groupId, characterId)
			end
		end
	end)

addCommandHandler("getgroupcount",
	function (sourcePlayer, commandName, groupId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			groupId = tonumber(groupId)

			if not groupId then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Csoport ID]", sourcePlayer, 255, 255, 255, true)
			else
				if availableGroups[groupId] then
					local count = 0

					for k, v in pairs(getElementsByType("player")) do
						if getElementData(v, "loggedIn") then
							local groups = getElementData(v, "player.groups") or {}

							if groups[groupId] then
								count = count + 1
							end
						end
					end

					outputChatBox("#4adfbf[SealMTA]: #ffffffA kiválasztott csoport online létszáma #4adfbf" .. count .. ".", sourcePlayer, 255, 255, 255, true)
				else
					outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott csoport nem létezik.", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end)

addEventHandler("onElementModelChange", getRootElement(),
	function (oldModel, newModel)
		if getElementType(source) == "player" and (getElementData(source, "adminDuty") or 0) == 0 then
			local allowed = true

			for k, v in ipairs(availableGroups) do
				for k2, v2 in ipairs(v.duty.skins) do
					if v2 == newModel and not isPlayerInGroup(source, k) then
					--if v2 == newModel and not isPlayerInGroup(source, k) then
						allowed = false
						break
					end
				end
			end

			if not allowed then
				setTimer(
					function (player)
						setElementModel(player, oldModel)
					end,
				500, 1, source)

				outputChatBox("#d75959[SealMTA]: #ffffffEzt a skint csak az adott csoport tagjai hordhatják!", source, 0, 0, 0, true)
			end
		end
	end)

addEvent("requestDuty", true)
addEventHandler("requestDuty", resourceRoot,
	function (groupId, items, dutySkin)
		if source ~= client and groupId and items then
			if availableGroups[groupId] then
				local dutyState = getElementData(client, "inDuty") or false

				if dutyState then
					local groupData = availableGroups[groupId]

					setElementData(client, "inDuty", false)
					setElementModel(client, getElementData(client, "char.Skin"))
					setPedArmor(client, 0)

					if groupData.duty.items then
						for k, v in ipairs(groupData.duty.items) do
							exports.seal_items:takeItemWithData(client, v[1], "duty", "data3")
						end
					end
					
					exports.seal_gui:showInfobox(client, "i", "Leadtad a szolgálatot.")
				else
					local groupData = availableGroups[groupId]
					local playerGroupData = getPlayerGroups(client)[groupId]

					if groupData and playerGroupData then
						if not dutySkin then
							setElementModel(client, 1)
						else
							setElementModel(client, groupData.duty.skins[dutySkin])
						end

						setElementData(client, "inDuty", groupId)


						if groupData.duty.armor and groupData.duty.armor > 0 then
							local armor = getPedArmor(client)

							armor = armor + groupData.duty.armor

							if armor < 100 then
								setPedArmor(client, armor)
							else
								setPedArmor(client, 100)
							end
						end

						if items then
							for i = 1, #items do
								if items[i][2] > 0 then
									exports.seal_items:giveItem(client, items[i][1], items[i][2], false, items[i][3], items[i][4], "duty")
								end
							end
						end

						exports.seal_gui:showInfobox(client, "i", "Felvetted a szolgálatot.")
					end
				end
			end
		end
	end
)

--[[
addEvent("requestDuty", true)
addEventHandler("requestDuty", getRootElement(),
	function (groupId)
		if source == client and groupId then
			local group = availableGroups[groupId]
			
			if group then
				if getElementData(source, "inDuty") then
					setElementData(source, "inDuty", false)
					setElementModel(source, getElementData(source, "char.Skin"))

					if group.duty.items then
						for k, v in ipairs(group.duty.items) do
							exports.seal_items:takeItemWithData(source, v[1], "duty", "data3")
						end
					end
					
					outputChatBox("#4adfbf[SealMTA]: #ffffffLeadtad a szolgálatot.", source, 0, 0, 0, true)
				else
					local groupData = getPlayerGroups(source)[groupId]
					local skinId = tonumber(groupData[2])

					if skinId == 0 then
						skinId = false
					end

					if not skinId or skinId == 0 then
						if group.duty.skins and group.duty.skins[1] then
							skinId = group.duty.skins[1]
						end
					end

					setElementData(source, "inDuty", groupId)
					if skinId then
						setElementModel(source, skinId)
					end

					if group.duty.armor and group.duty.armor > 0 then
						local armor = getPedArmor(source)

						armor = armor + group.duty.armor

						if armor < 100 then
							setPedArmor(source, armor)
						else
							setPedArmor(source, 100)
						end
					end

					if group.duty.items then
						for k, v in ipairs(group.duty.items) do
							exports.seal_items:giveItem(source, v[1], v[2], false, v[3], v[4], "duty")
						end
					end

					outputChatBox("#4adfbf[SealMTA]: #ffffffFelvetted a szolgálatot.", source, 0, 0, 0, true)
				end
			end
		end
	end)]]

addCommandHandler("changelock", 
	function(sourcePlayer, commandName)
		if getPedOccupiedVehicle(sourcePlayer) then
			local veh = getPedOccupiedVehicle(sourcePlayer)
			if isPlayerLeaderInGroup(sourcePlayer, getElementData(veh, "vehicle.group")) then
				exports.seal_items:giveItem(sourcePlayer, 1, 1, false, getElementData(veh, "vehicle.dbID"))
				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen másoltál kulcsot! #4adfbf("..getElementData(veh, "vehicle.dbID")..")", sourcePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox("#4adfbf[SealMTA]: #ffffffNem ülsz járműben!", sourcePlayer, 255, 255, 255, true)
		end
	end
)

addCommandHandler("changelock2", 
	function(sourcePlayer, commandName)
		if getPedOccupiedVehicle(sourcePlayer) then
			local veh = getPedOccupiedVehicle(sourcePlayer)
			if veh and isPlayerLeaderInGroup(sourcePlayer, getElementData(veh, "vehicle.group")) then
				for k, v in pairs(getElementsByType("player")) do
					exports.seal_items:takeItemWithData(v, 1, getElementData(veh, "vehicle.dbID"))
				end
				dbExec(connection, "DELETE FROM items WHERE itemId = 1 AND data1 = ?", getElementData(veh, "vehicle.dbID"))
				exports.seal_items:giveItem(sourcePlayer, 1, 1, false, getElementData(veh, "vehicle.dbID"))
				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen kitörölted az összes meglévő kulcsot, és másoltál egy újat! #4adfbf("..getElementData(veh, "vehicle.dbID")..")", sourcePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox("#4adfbf[SealMTA]: #ffffffNem ülsz járműben!", sourcePlayer, 255, 255, 255, true)
		end
	end
)

addCommandHandler("achangelock", 
	function(sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if getPedOccupiedVehicle(sourcePlayer) then
				local veh = getPedOccupiedVehicle(sourcePlayer)
				exports.seal_items:giveItem(sourcePlayer, 1, 1, false, getElementData(veh, "vehicle.dbID"))
				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen másoltál kulcsot! #4adfbf("..getElementData(veh, "vehicle.dbID")..")", sourcePlayer, 255, 255, 255, true)
			else
				outputChatBox("#4adfbf[SealMTA]: #ffffffNem ülsz járműben!", sourcePlayer, 255, 255, 255, true)
			end
		end
	end
)

addCommandHandler("achangelock2", 
	function(sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if getPedOccupiedVehicle(sourcePlayer) then
				local veh = getPedOccupiedVehicle(sourcePlayer)
				for k, v in pairs(getElementsByType("player")) do
					exports.seal_items:takeItemWithData(v, 1, getElementData(veh, "vehicle.dbID"))
				end
				dbExec(connection, "DELETE FROM items WHERE itemId = 1 AND data1 = ?", getElementData(veh, "vehicle.dbID"))
				exports.seal_items:giveItem(sourcePlayer, 1, 1, false, getElementData(veh, "vehicle.dbID"))
				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen kitörölted az összes meglévő kulcsot, és másoltál egy újat! #4adfbf("..getElementData(veh, "vehicle.dbID")..")", sourcePlayer, 255, 255, 255, true)
			else
				outputChatBox("#4adfbf[SealMTA]: #ffffffNem ülsz járműben!", sourcePlayer, 255, 255, 255, true)
			end
		end
	end
)

local enabledFakeNameGroups = {
	[4] = true,
}

function fakeName(sourcePlayer, commandName, ...)
	for k, v in pairs(enabledFakeNameGroups) do
		if isPlayerInGroup(sourcePlayer, k) then
			local fakeName = table.concat({...}, "_")

			if utfLen(fakeName) > 0 and fakeName ~= getElementData(sourcePlayer, "visibleName") then
				for k, v in pairs(getElementsByType("player")) do
					if getElementData(v, "loggedIn") then
						if getElementData(v, "acc.adminLevel") > 0 then
							outputChatBox("#4adfbf[Álnév]: #ffffff"..getElementData(sourcePlayer, "char.Name").." használta a /álnév parancsot! #4adfbf("..fakeName..")", v, 255, 255, 255, true)
						end
					end
				end
				setElementData(sourcePlayer, "visibleName", fakeName)
				setElementData(sourcePlayer, "fakeNameInUse", true)
			else
				if getElementData(sourcePlayer, "visibleName") ~= getElementData(sourcePlayer, "char.Name") then
					setElementData(sourcePlayer, "visibleName", getElementData(sourcePlayer, "char.Name"))
					setElementData(sourcePlayer, "fakeNameInUse", false)
				else
					outputChatBox("#4adfbf[Használat]: #ffffff/"..commandName.." [álneved]", sourcePlayer, 255, 255, 255, true)
				end
			end
			break
		end
	end
end
addCommandHandler("álnév", fakeName)
addCommandHandler("alnev", fakeName)
addCommandHandler("fakename", fakeName)
 
local lastGovTick = {}
local govGroups = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[8] = true,
}

addCommandHandler("gov",
	function(sourcePlayer, commandName, ...)
		local govMessage = table.concat({...}, "_")

		for groupId, v in pairs(govGroups) do
			if isPlayerLeaderInGroup(sourcePlayer, groupId) then
				if utfLen(govMessage) > 0 then
					local govMessage = govMessage:gsub("_", " ")
					if not lastGovTick[sourcePlayer] then
						lastGovTick[sourcePlayer] = 0
					end
					
					if getTickCount() - lastGovTick[sourcePlayer] < 60000 * 2 then
						exports.seal_hud:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					lastGovTick[sourcePlayer] = getTickCount()

					for k, v in pairs(getElementsByType("player")) do
						if getElementData(v, "loggedIn") then
							if getElementData(v, "acc.adminLevel") > 0 then
								outputChatBox("#4adfbf[GOV]: #ffffff" .. getElementData(sourcePlayer, "char.Name"):gsub("_", " ") .. " használta a /gov parancsot!", v, 255, 255, 255, true)
							end
						end
						
						outputChatBox ("============[".. getGroupName(groupId) .. " felhívás]============", v, 199, 66, 68, true )
						outputChatBox (">> " .. govMessage, v, 32, 184, 29, true)
					end
				else
					outputChatBox("[Használat]: #ffffff/"..commandName.." [Üzenet]", sourcePlayer, 255, 150, 0, true)
				end
				break
			end	
		end
	end
)