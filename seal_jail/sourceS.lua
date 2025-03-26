local connection = false
local availableArrestPoints = {
	{226.21542358398, 114.35690307617, 999.015625, 10, 8, 4.5},
	{268.25955200195, 77.731826782227, 1001.0390625, 6, 9, 2.5},
	{226.32208251953, 114.09180450439, 999.015625, 10, 84, 2.5}
}
local availablePrisonCellPoints = {}

addEventHandler("onDatabaseConnected", getRootElement(), function(db)
	connection = db
end)

addEventHandler("onResourceStart", getResourceRootElement(), function()
	connection = exports.seal_database:getConnection()
	table.insert(availablePrisonCellPoints, {227.55267333984, 109.56513214111, 999.015625, 10, 8})
	table.insert(availablePrisonCellPoints, {223.58055114746, 109.89776611328, 999.015625, 10, 8})
	table.insert(availablePrisonCellPoints, {219.56718444824, 110.22931671143, 999.015625, 10, 8})
	table.insert(availablePrisonCellPoints, {215.59864807129, 110.48049926758, 999.015625, 10, 8})
	table.insert(availablePrisonCellPoints, {264.43307495117, 77.484634399414, 1001.0390625, 6, 9})
	table.insert(availablePrisonCellPoints, {227.53770446777, 110.00576782227, 999.015625, 10, 84})
	table.insert(availablePrisonCellPoints, {223.4931640625, 110.17556762695, 999.015625, 10, 84})
	table.insert(availablePrisonCellPoints, {219.63481140137, 110.1802444458, 999.015625, 10, 84})

	for k, v in pairs(availableArrestPoints) do
		createColSphere(v[1], v[2], v[3], v[6] and v[6] or 1)
	end
end)

addEvent("getPlayerOutOfJail", true)
addEventHandler("getPlayerOutOfJail", getRootElement(),
	function ()
		if isElement(source) then
			if client and client ~= source then return end
			local adminJail = getElementData(source, "acc.adminJail") or 0
			local charJail = getElementData(source, "char.jail") or 0

			if adminJail == 0 then
				dbExec(connection, "UPDATE accounts SET adminJail = 0, adminJailBy = '', adminJailTimestamp = 0, adminJailTime = 0, adminJailReason = '' WHERE accountId = ?", getElementData(source, "char.accID"))
			end

			if charJail == 0 then
				dbExec(connection, "UPDATE characters SET jail = 0, jailTime = 0, jailTimestamp = 0, jailReason = '' WHERE characterId = ?", getElementData(source, "char.ID"))
			end

			setElementInterior(source, 0)
	 		setElementDimension(source, 0)
			setElementPosition(source, 1481.1420898438, -1765.9304199219, 18.773551940918)
			setElementRotation(source, 0, 0, 270)

			exports.seal_hud:showInfobox(source, "info", "Szabadultál a börtönből. Ezentúl viselkedj normálisan.")
		end
	end
)

addEvent("updateJailTime", true)
addEventHandler("updateJailTime", getRootElement(),
	function(type)
		if isElement(source) and client and client == source then
			if type then
				if type == "prison" then
					local currentPrisonTime = getElementData(client, "char.jailTime") or 0

					setElementData(client, "char.jailTime", currentPrisonTime - 1)
					dbExec(connection, "UPDATE characters SET jailTime = ? WHERE characterId = ?", currentPrisonTime - 1, getElementData(client, "char.ID"))
				elseif type == "admin" then
					local currentJailTime = getElementData(client, "acc.adminJailTime") or 0

					setElementData(client, "acc.adminJailTime", currentJailTime - 1)
					dbExec(connection, "UPDATE accounts SET adminJailTime = ? WHERE accountId = ?", currentJailTime - 1, getElementData(client, "char.accID"))
				end
			end
		end
	end
)

addEvent("reSpawnInJail", true)
addEventHandler("reSpawnInJail", getRootElement(),
	function ()
		if isElement(source) and client and client == source then
			local accountId = getElementData(source, "char.accID")
			local adminJail = getElementData(source, "acc.adminJail") or 0
			local charJail = getElementData(source, "char.jail") or 0
			local skinId = getElementModel(source)

			if adminJail ~= 0 then
				spawnPlayer(source, 154.2003326416, -1951.8298339844, 47.875, 0, skinId, 0, accountId + math.random(100))
			elseif charJail ~= 0 then
				local prisonCell = availablePrisonCellPoints[math.random(1, #availablePrisonCellPoints)]

				spawnPlayer(source, prisonCell[1], prisonCell[2], prisonCell[3], 0, skinId, prisonCell[4], prisonCell[5])
			end

			setCameraTarget(source, source)
		end
	end)

function getNearbyArrestPoint(playerElement)
	local x, y, z = getElementPosition(playerElement)
	local interior = getElementInterior(playerElement)
	local dimension = getElementDimension(playerElement)

	local lastDistance = 5
	local nearbyArrestPoint = false

	for i = 1, #availableArrestPoints do
		local v = availableArrestPoints[i]

		if interior == v[4] and dimension == v[5] then
			local currentDistance = getDistanceBetweenPoints3D(x, y, z, v[1], v[2], v[3])

			if lastDistance >= currentDistance then
				lastDistance = currentDistance
				nearbyArrestPoint = i
			end
		end
	end

	return nearbyArrestPoint
end

function getNearestPrisonCell(playerElement)
	local x, y, z = getElementPosition(playerElement);
	local interior = getElementInterior(playerElement);
	local dimension = getElementDimension(playerElement);

	local lastDistance = 50;
	local nearbyArrestPoint = false;

	for i = 1, #availablePrisonCellPoints do
		local v = availablePrisonCellPoints[i];

		if interior == v[4] and dimension == v[5] then
			local currentDistance = getDistanceBetweenPoints3D(x, y, z, v[1], v[2], v[3]);

			if lastDistance >= currentDistance then
				lastDistance = currentDistance;
				nearbyArrestPoint = i;
			end
		end
	end

	return availablePrisonCellPoints[nearbyArrestPoint];
end 

addCommandHandler("jail",
	function (sourcePlayer, commandName, targetName, duration, fine, ...)
		local groupId = exports.seal_groups:isPlayerHavePermission(sourcePlayer, "jail")

		if groupId then
			duration = tonumber(duration)
			fine = tonumber(fine)

			if not (targetName and duration and duration >= 0 and fine and fine >= 0 and (...)) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Idő (perc)] [Bírság] [Indok]", sourcePlayer, 0, 0, 0, true)
			else
				local playerArrestPoint = getNearbyArrestPoint(sourcePlayer)
				if not playerArrestPoint then
					outputChatBox("#d75959[SealMTA - Jail]: #ffffffNem vagy cella közelében!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetName)
				if not targetPlayer then
					return
				end

				if duration <= 0 or duration > 300 then
					outputChatBox("#d75959[SealMTA - Jail]: #ffffffAz időtartam minimum #d759591 #ffffffés maximum #d75959300 #ffffffperc lehet.", sourcePlayer, 0, 0, 0, true)
					return
				end

				if fine < 0 or fine > 500000 then
					outputChatBox("#d75959[SealMTA - Jail]: #ffffffA bírság maximum #d75959500 000 $ #fffffflehet.", sourcePlayer, 0, 0, 0, true)
					return
				end

				local targetArrestPoint = getNearbyArrestPoint(targetPlayer)
				if targetArrestPoint ~= playerArrestPoint then
					outputChatBox("#d75959[SealMTA - Jail]: #ffffffA kiválasztott játékos nincs a cella közelében!", sourcePlayer, 0, 0, 0, true)
					return
				end

				local jailType = getElementData(targetPlayer, "char.jail") or 0
				if jailType ~= 0 then
					outputChatBox("#d75959[SealMTA - Jail]: #ffffffA kiválasztott játékos már börtönben van.", sourcePlayer, 0, 0, 0, true)
					return
				end

				local prisonCell = getNearestPrisonCell(targetPlayer);

				setElementData(targetPlayer, "cuffed", false)
				setElementData(targetPlayer, "cuffAnimation", false)
				setElementData(targetPlayer, "visz", false)

				local currTime = getRealTime().timestamp
				local reason = table.concat({...}, " ")

				setElementPosition(targetPlayer, prisonCell[1], prisonCell[2], prisonCell[3])
				setElementRotation(targetPlayer, 0, 0, 0)
				setElementInterior(targetPlayer, prisonCell[4])
				setElementDimension(targetPlayer, prisonCell[5])

				setElementData(targetPlayer, "char.jail", 1)
				setElementData(targetPlayer, "char.jailTime", duration)
				setElementData(targetPlayer, "char.jailTimestamp", currTime, false)
				setElementData(targetPlayer, "char.jailReason", reason, false)

				if fine > 0 then
					exports.seal_core:takeMoney(targetPlayer, fine, "jailFine")
				end

				local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
				local groupPrefix = exports.seal_groups:getGroupPrefix(groupId)
				local groupRankName = select(2, exports.seal_groups:getPlayerRank(sourcePlayer, groupId))
				local theOfficer = string.format("[%s] %s %s", groupPrefix, groupRankName, playerName)

				local groupBalance = exports.seal_groups:getGroupBalance(groupId)

				if groupBalance then
					exports.seal_groups:setGroupBalance(groupId, groupBalance + (fine / 2))
				end

				outputChatBox("#32b3ef[Börtön]: #ff9600" .. theOfficer .. " #ffffffbörtönbe helyezett téged.", targetPlayer, 0, 0, 0, true)
				outputChatBox("#32b3ef[Börtön]: #ffffffOka: #ff9600" .. reason, targetPlayer, 0, 0, 0, true)
				outputChatBox("#32b3ef[Börtön]: #ffffffIdő: #ff9600" .. duration .. " perc", targetPlayer, 0, 0, 0, true)

				exports.seal_anticheat:sendDiscordMessage("**"..theOfficer.."** bebörtönözte **".. targetName .. "**-t.\nIndok: **" .. reason .. "**\nIdő: **".. duration .. "** perc", "icjail");
				exports.seal_groups:sendGroupMessage(groupId, {
					"#32b3ef[Börtön]: #ff9600" .. theOfficer .. " #ffffffbebörtönözte #ff9600" .. targetName .. " #ffffffjátékost.",
					"#32b3ef[Börtön]: #ffffffOka: #ff9600" .. reason,
					"#32b3ef[Börtön]: #ffffffIdő: #ff9600" .. duration .. " perc"
				})

				dbExec(connection, "UPDATE characters SET jail = 1, jailTime = ?, jailTimestamp = ?, jailReason = ? WHERE characterId = ?", duration, currTime, reason, getElementData(targetPlayer, "char.ID"))
			end
		end
	end
)

addCommandHandler("takeout",
	function (sourcePlayer, commandName, targetPlayer)
		local groupId = exports.seal_groups:isPlayerHavePermission(sourcePlayer, "jail")
		if groupId then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local targetX, targetY, targetZ = getElementPosition(targetPlayer)
					local sourceX, sourceY, sourceZ = getElementPosition(sourcePlayer)
					if getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, targetX, targetY, targetZ) <= 3 then 
						local isArrested = getElementData(targetPlayer, "char.jail") or 0

						if isArrested > 0 then
							local adminName = getElementData(sourcePlayer, "acc.adminNick")
							local adminRank = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)

							setElementData(targetPlayer, "char.jail", 0)
							setElementData(targetPlayer, "char.jailTime", 0)

							triggerEvent("getPlayerOutOfJail", targetPlayer)

							local playerName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
							local groupPrefix = exports.seal_groups:getGroupPrefix(groupId)
							local groupRankName = select(2, exports.seal_groups:getPlayerRank(sourcePlayer, groupId))
							local theOfficer = string.format("[%s] %s %s", groupPrefix, groupRankName, playerName)

							outputChatBox("#32b3ef[Börtön]: #ff9600" .. theOfficer .. " #ffffffkiengedett a börtönből téged.", targetPlayer, 0, 0, 0, true)

							exports.seal_anticheat:sendDiscordMessage("**"..theOfficer.."** kivette **".. targetName .. "**-t a börtönből.", "icjail")

							exports.seal_groups:sendGroupMessage(groupId, {
								"#32b3ef[Börtön]: #ff9600" .. theOfficer .. " #ffffffkiengedte a börtönből #ff9600" .. targetName .. " #ffffffjátékost."
							})


							--exports.seal_administration:showMessageForAdmins("#4adfbf[SealMTA]: #32b3ef" .. adminRank .. " " .. adminName .. " #ffffffunjailezte #32b3ef" .. targetName .. "#ffffff-t.")
						else
							outputChatBox("#d75959[SealMTA - Börtön]: #ffffffA kiválasztott játékos nincs börtönben.", sourcePlayer, 255, 255, 255, true)
						end
					else
						outputChatBox("#d75959[SealMTA - Jail]: #ffffffA kiválasztott játékos nincs a közeledben!", sourcePlayer, 0, 0, 0, true)
					end
				end
			end
		end
	end
)

addCommandHandler("ajail",
	function (sourcePlayer, commandName, targetPlayer, jailtype, duration, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			jailtype = tonumber(jailtype)
			duration = tonumber(duration)

			if not (targetPlayer and jailtype and jailtype >= 1 and jailtype <= 3 and duration and duration >= 1 and (...)) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Típus (1: Sima, 2: Tanuló, 3: Szopató)] [Idő] [Indok]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local reason = table.concat({...}, " ")
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local accountId = getElementData(targetPlayer, "char.accID")
					local currentTime = getRealTime().timestamp

					triggerClientEvent(targetPlayer, "loadingScreenOnAJ", targetPlayer)

					setElementData(targetPlayer, "cuffed", false)
					setElementData(targetPlayer, "cuffAnimation", false)
					setElementData(targetPlayer, "visz", false)

					removePedFromVehicle(targetPlayer)
					detachElements(targetPlayer)
	
					setElementPosition(targetPlayer, 154.2003326416, -1951.8298339844, 47.875)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, accountId + math.random(1, 100))

					setElementData(targetPlayer, "acc.adminJail", jailtype)
					setElementData(targetPlayer, "acc.adminJailBy", adminName, true)
					setElementData(targetPlayer, "acc.adminJailTimestamp", currentTime, true)
					setElementData(targetPlayer, "acc.adminJailTime", duration)
					setElementData(targetPlayer, "acc.adminJailReason", reason, true)

					exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** bebörtönözte **"..targetName.."**-t **"..duration.." percre** **"..reason.."**", "ajail")
					exports.seal_anticheat:sendDiscordMessage("```"..reason.."```", "ajail")

					outputChatBox("#d75959[AdminJail]: #4adfbf" .. adminName .. " #ffffffbebörtönözte #4adfbf" .. targetName .. "#ffffff-t #32b3ef" .. duration .. " #ffffffpercre.", root, 255, 255, 255, true)
					outputChatBox("#d75959[AdminJail]: #4adfbfIndok: #ffffff" .. reason, root, 255, 255, 255, true)

					setElementData(sourcePlayer, "acc.ajail", (getElementData(sourcePlayer, "acc.ajail") or 0)+1)
					--dbExec(connection, "UPDATE accounts SET statAjail = ? WHERE accountId = ?", getElementData(sourcePlayer,"acc.ajail"), getElementData(sourcePlayer, "char.accID"))

					exports.seal_logs:addLogEntry("adminjail", {
						accountId = accountId,
						adminName = adminName,
						reason = reason,
						duration = duration
					})

					dbExec(connection, "UPDATE accounts SET adminJail = ?, adminJailBy = ?, adminJailTimestamp = ?, adminJailTime = ?, adminJailReason = ? WHERE accountId = ?", jailtype, adminName, currentTime, duration, reason, accountId)
				end
			end
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(),
	function (oldValue, newValue)
		local accountId = getElementData(source, "char.accID")
		if dataName == "acc.adminJail" then 
			adminJail = getElementData(source, "acc.adminJail")
			jailTime = getElementData(source, "acc.adminJailTime")
		elseif dataName == "acc.adminJailTime" then
			local adminJailTime = tonumber(getElementData(localPlayer, "acc.adminJailTime"))

			if adminJailTime then
				jailTime = adminJailTime
			dbExec(connection, "UPDATE accounts SET adminJailTime = ? WHERE = accountId = ?", adminJailTime, accountId)
			--print(adminJailTime)
			end
		end
	end 
)

addCommandHandler("offajail", 
	function (player, command, data, duration, ...)
		if getElementData(player, "acc.adminLevel") >= 2 then
			if not data or not duration or not (...) then
				--outputChatBox("#ff9428Használat: #ffffff/" .. command .. " [Account ID/Serial] [Perc]  [Indok]", player, 255, 255, 255, true)
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. command .. " [Karakternév] [Idő] [Indok]", player, 255, 255, 255, true)
			else
				duration = tonumber(duration)

				if duration < 1 then
					--outputErrorText("A jail időtartamának nagyobbnak kell lennie 0-nál!", player)
					outputChatBox("#d75959[SealMTA]: #FFFFFFA jail időtartamának nagyobbnak kell lennie, mint 0!", player, 255, 255, 255, true)
					--exports.cosmo_hud:showAlert(player, "error", "A jail időtartamának nagyobbnak kell lennie 0-nál!")
				else
					local now = getRealTime().timestamp
					local reason = table.concat({...}, " ")
					local adminName = getElementData(player, "acc.adminNick") or getPlayerName(player, true)
					local jailType = 1

					local jailInfo = now .. "/" .. utf8.gsub(reason, "/", ";") .. "/" .. duration .. "/" .. adminName

					local query = "SELECT * FROM characters WHERE name = ?"
					if tonumber(data) then
						data = tonumber(data)
						query = "SELECT * FROM characters WHERE name = ?"
					end

					dbQuery(
						function (qh)
							local result = dbPoll(qh, 0)

							if result and result[1] then
								local accountId = result[1].accountId
								--print(inspect(result[1]))
								----print(query)
								--print(result)
								--print(data)

								dbQuery(
									function (qh)
										dbExec(connection, "UPDATE accounts SET adminJail = ?, adminJailTime = ? WHERE accountId = ?", jailInfo, duration, accountId)
										local posX, posY, posZ = {154.2003326416, -1951.8298339844, 47.875}
										dbExec(connection, "UPDATE characters SET posX = ?, posY = ?, posZ = ?, dimension = ? WHERE accountId = ?", -18.462890625, 2321.8916015625, 24.303373336792, math.random(1, 999999), accountId)

										--exports.cosmo_hud:showAlert(root, "jail", adminName .. " bebörtönözte " .. result[1].username .. " felhasználót", "Időtartam: " .. duration .. " perc, Indok: " .. reason)
									
										outputChatBox("#d75959[OfflineJail]: #4adfbf"..adminName.."#ffffff bebörtönözte #4adfbf"..result[1].name:gsub("_", " ").."#ffffff-t #32b3ef" .. duration .. " #FFFFFFpercre.",root,255,255,255,true)
										outputChatBox("#d75959[OfflineJail]: #4adfbfIndok: #FFFFFF"..reason,root,255,255,255,true)

										exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** bebörtönözte **"..result[1].name:gsub("_", " ").."**-t **"..duration.." percre** **"..reason.."**", "adminlog")
										exports.seal_anticheat:sendDiscordMessage("```"..reason.." [OFFAJAIL]```", "adminlog")
					

										setElementData(player, "acc.offajail", (getElementData(player, "acc.offajail") or 0)+1)
										dbExec(connection, "UPDATE accounts SET statOfflineAjail = ? WHERE accountId = ?", getElementData(player,"acc.offajail"), getElementData(player, "char.accID"))
										
										--logs:toLog("adminaction", adminName .. " bebörtönözte " .. result[1].username .. " felhasználót (Időtartam: " .. duration .. " perc, Indok: " .. reason .. ")")
										--exports.cosmo_dclog:sendDiscordMessage("**"..adminName .. "** bebörtönözte **" .. result[1].username .. "** játékost Időtartam: **" .. duration .. "** perc, Indok: **" .. reason.."**", "adminlog")

										exports.seal_logs:addLogEntry("adminjail", {
											accountId = accountId,
											adminName = adminName,
											reason = reason,
											duration = duration
										})

										dbFree(qh)
										--dbExec(connection, "UPDATE accounts SET adminJail = ?, adminJailBy = ?, adminJailTimestamp = ?, adminJailTime = ?, adminJailReason = ? WHERE accountId = ?", jailtype, adminName, currentTime, duration, reason, accountId)
									end, connection, "UPDATE accounts SET adminJail = ?, adminJailBy = ?, adminJailTimestamp = ?, adminJailTime = ?, adminJailReason = ? WHERE accountId = ?", jailType, adminName, currentTime, duration, reason, accountId
								)
							else
								outputErrorText("A kiválasztott felhasználó nincs regisztrálva a szerveren!", player)
								exports.cosmo_hud:showAlert(player, "error", "A kiválasztott felhasználó nincs regisztrálva a szerveren!")
							end
						end, connection, query, data
					)
				end
			end
		end
	end 
)
--addCommandHandler("testDC", function(adminPlayer, commandName, targetPlayer)
--	exports.seal_anticheat:sendDiscordMessage("**"..getElementData(adminPlayer, "visibleName").."** Kiszedte **".. targetPlayer .. "**-t a jailből", "unjaillog")
--end)

addCommandHandler("unjail",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminJail = getElementData(targetPlayer, "acc.adminJail") or 0

					if adminJail > 0 then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminRank = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)

						setElementData(targetPlayer, "acc.adminJail", 0)
						setElementData(targetPlayer, "acc.adminJailTime", 0)

						triggerEvent("getPlayerOutOfJail", targetPlayer)

						exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** kiszedte **".. targetName .. "**-t az adminjailből", "adminlog")
						
						exports.seal_administration:showMessageForAdmins("#4adfbf[SealMTA]: #32b3ef" .. adminRank .. " " .. adminName .. " #ffffffunjailezte #32b3ef" .. targetName .. "#ffffff-t.", "adminlog")

						
						exports.seal_logs:addLogEntry("unjail", {
							targetPlayer = inspect(targetPlayer),
							adminName = adminName
						})

						setElementData(sourcePlayer, "acc.unjail", (getElementData(sourcePlayer, "acc.unjail") or 0)+1)
						--dbExec(connection, "UPDATE accounts SET statUnjail = ? WHERE accountId = ?", getElementData(sourcePlayer,"acc.unjail"), getElementData(sourcePlayer, "char.accID"))
					else
						outputChatBox("#d75959[SealMTA - AdminJail]: #ffffffA kiválasztott játékos nincs börtönben.", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end
)


function jailedInfo(sourcePlayer, sourceCommand, targetPlayer)
	if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
		if targetPlayer then
			local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			local adminJail = getElementData(targetPlayer, "acc.adminJail") or 0
			local charJail = getElementData(targetPlayer, "char.jail") or 0

			if adminJail > 0 then
				outputChatBox("#4adfbf[SealMTA - Adminjail]: #ffffffAdminjail információk", sourcePlayer, 255, 255, 255, true)
				outputChatBox("		#4adfbfIndok: #ffffff" .. getElementData(targetPlayer, "acc.adminJailReason"), sourcePlayer, 255, 255, 255, true)
				outputChatBox("		#4adfbfHátralévő idő: #ffffff" ..getElementData(targetPlayer, "acc.adminJailTime").. " perc", sourcePlayer, 255, 255, 255, true)
				outputChatBox("		#4adfbfAdmin: #ffffff" ..getElementData(targetPlayer, "acc.adminJailBy"), sourcePlayer, 255, 255, 255, true)
			elseif charJail > 0 then
				local jailTime = getRealTime(getElementData(targetPlayer, "char.jailTimestamp"))

				jailTime = string.format("%04d/%02d/%02d %02d:%02d", jailTime.year + 1900, jailTime.month + 1, jailTime.monthday, jailTime.hour, jailTime.minute)

				outputChatBox("#4adfbf[SealMTA - Jail]: #ffffffJail információk:", targetPlayer, 255, 255, 255, true)
				outputChatBox("     #4adfbfIndok: #ffffff" .. getElementData(targetPlayer, "char.jailReason"), sourcePlayer, 255, 255, 255, true)
				outputChatBox("     #4adfbfHátralévő idő: #ffffff" .. getElementData(targetPlayer, "char.jailTime") .. " perc", sourcePlayer, 255, 255, 255, true)
				outputChatBox("     #4adfbfIdőpont: #ffffff" .. jailTime, sourcePlayer, 255, 255, 255, true)
			else
				outputChatBox("#d75959[SealMTA]: #ffffffA játékos nincs börtönben..", sourcePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox("#d75959[SealMTA]: #ffffffHasználathoz: /"..sourceCommand.." [Játékos]", sourcePlayer, 255, 255, 255, true)
		end
	end
end
addCommandHandler("ajailinfo", jailedInfo)
addCommandHandler("jailed", jailedInfo)


function jailInfoFunction(sourcePlayer)
	local adminJail = getElementData(sourcePlayer, "acc.adminJail") or 0
	local charJail = getElementData(sourcePlayer, "char.jail") or 0

	if adminJail > 0 then
		outputChatBox("#d75959[SealMTA - AdminJail]: #ffffffJail információk:", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Indok: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailReason"), sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Hátralévő idő: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailTime") .. " perc", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Admin: #ffffff" .. getElementData(sourcePlayer, "acc.adminJailBy"), sourcePlayer, 255, 255, 255, true)
	elseif charJail > 0 then
		local jailTime = getRealTime(getElementData(sourcePlayer, "char.jailTimestamp"))

		jailTime = string.format("%04d/%02d/%02d %02d:%02d", jailTime.year + 1900, jailTime.month + 1, jailTime.monthday, jailTime.hour, jailTime.minute)

		outputChatBox("#d75959[SealMTA - Jail]: #ffffffJail információk:", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Indok: #ffffff" .. getElementData(sourcePlayer, "char.jailReason"), sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Hátralévő idő: #ffffff" .. getElementData(sourcePlayer, "char.jailTime") .. " perc", sourcePlayer, 255, 255, 255, true)
		outputChatBox("    - #d75959Időpont: #ffffff" .. jailTime, sourcePlayer, 255, 255, 255, true)
	else
		outputChatBox("#d75959[SealMTA]: #ffffffNem vagy börtönben.", sourcePlayer, 255, 255, 255, true)
	end
end
addCommandHandler("jailinfo", jailInfoFunction)
addCommandHandler("bortoninfo", jailInfoFunction)
addCommandHandler("börtöninfó", jailInfoFunction)
addCommandHandler("börtönidő", jailInfoFunction)
addCommandHandler("bortonido", jailInfoFunction)
addCommandHandler("jailtime", jailInfoFunction)

addCommandHandler("alljailed",
	function(sourcePlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			outputChatBox("#4adfbf[SealMTA - Jail]: #ffffffJailben lévő játékosok:", sourcePlayer, 255, 255, 255, true)
			for k, v in pairs(getElementsByType("player")) do
				if (getElementData(v, "acc.adminJail") or -1) > 0 then
					outputChatBox("#4adfbf-#4adfbf "..getPlayerName(v):gsub("_", " ").."#4adfbf: #ffffff"..getElementData(v, "acc.adminJailReason").."#4adfbf indok, #ffffff"..getElementData(v, "acc.adminJailTime").."#4adfbf perc, #ffffff"..getElementData(v, "acc.adminJailBy").."#4adfbf által!", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end
)