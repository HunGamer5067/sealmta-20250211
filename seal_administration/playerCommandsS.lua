addCommandHandler("resetplayer",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			if not (targetPlayer) then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					triggerClientEvent("addKickbox", root, "kick", getElementData(sourcePlayer, "acc.adminNick"), getElementData(targetPlayer, "visibleName"), "Vagyonod törölve!")
					local charId = getElementData(targetPlayer, "char.ID")
					kickPlayer(targetPlayer, sourcePlayer, "Vagyontörlés!")

					dbExec(connection, "DELETE FROM items WHERE ownerType = 'player' AND ownerId = ?", charId)
					dbExec(connection, "DELETE FROM vehicles WHERE ownerId = ?", charId)
					dbExec(connection, "UPDATE interiors SET deleted = 'Y' WHERE ownerId = ?", charId)
					dbExec(connection, "UPDATE characters SET money = 100000, slotCoins = 0, playedMinutes = 0, bankMoney = 0, maxVehicles = 2, interiorLimit = 5 WHERE accountId = ?", charId)

					outputChatBox("[SealMTA]: #ffffffSikeresen resetelted a playert.", sourcePlayer, 255, 150, 0, true)
				end
			end
		end
	end
)

function helpUpPerson(player)
	setElementHealth(player, 100)
	setElementData(player, "bloodLevel", 100)

	removeElementData(player, "bulletDamages")
	removeElementData(player, "triedToHelpUp")

	if getElementData(player, "char.injureLeftFoot") then
		exports.seal_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureRightFoot") then
		exports.seal_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureLeftArm") then
		exports.seal_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	if getElementData(player, "char.injureRightArm") then
		exports.seal_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	removeElementData(player, "char.injureLeftFoot")
	removeElementData(player, "char.injureRightFoot")
	removeElementData(player, "char.injureLeftArm")
	removeElementData(player, "char.injureRightArm")
end

addCommandHandler("agyogyit",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				local adminLevel = getElementData(sourcePlayer ,"acc.adminLevel") or 0
				local adminDuty = getElementData(sourcePlayer, "adminDuty") or 0

				if adminLevel <= 1 and adminDuty == 0 then
					outputChatBox("[SealMTA - Hiba]: #ffffffAdmindutyban nem használhatod ezt a parancsot.", sourcePlayer, 245, 81, 81, true)
					return
				end

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminTitle = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)

					helpUpPerson(targetPlayer)
					setElementData(targetPlayer, "char.Hunger", 100)
					setElementData(targetPlayer, "char.Thirst", 100)

					exports.seal_anticheat:sendDiscordMessage("**".. getElementData(sourcePlayer, "visibleName"):gsub("_", " ") .."** meggyógyította **"..targetName.."**", "adminlog")

					outputChatBox("[SealMTA]: #4adfbf" .. adminName .. " #ffffffmeggyógyított téged.", targetPlayer, 74, 223, 191, true)
					outputChatBox("[SealMTA]: #ffffffMeggyógyítottad #4adfbf" .. targetName .. " #ffffffjátékost.", sourcePlayer, 74, 223, 191, true)

					if not togurma then
						exports.seal_administration:showAdminLog(adminTitle .. " " .. adminName .. " meggyógyította #4adfbf" .. targetName .. "#ffffff-t.", 2)
					end
					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end
)

addCommandHandler("vá",
	function (sourcePlayer, commandName, partialNick, ...)
		local myAdminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
		local myHelperLevel = getElementData(sourcePlayer, "acc.helperLevel") or 0

		if myAdminLevel > 0 or myHelperLevel > 0 then
			if not partialNick or not (...) then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local message = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

					if message then
						local myName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local myPlayerID = getElementData(sourcePlayer, "playerID") or "N/A"
						local targetPlayerID = getElementData(targetPlayer, "playerID") or "N/A"

						if getElementData(sourcePlayer, "adminDuty") == 1 then
							triggerClientEvent(sourcePlayer, "onClientPM", sourcePlayer, targetPlayer,  message, true)
						end
						exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** válaszolt **"..getElementData(targetPlayer, "visibleName"):gsub("_", " ").."-nak/nek** ", "adminreplies")
						exports.seal_anticheat:sendDiscordMessage("```"..message.."```", "adminreplies")

						if myHelperLevel > 0 then
							outputChatBox(string.format("#5ec1e6[Válasz]: #ffffff%s (%d): #5ec1e6%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
							outputChatBox(string.format("#5ec1e6[Segítség]: #ffffff%s (%d): #5ec1e6%s", myName, myPlayerID, message), targetPlayer, 0, 0, 0, true)

							

							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Adminsegéd %s válaszolt neki: %s", myName, targetName))
							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Üzenet: %s", message))
						elseif myAdminLevel > 0 then
							local adminName = getElementData(sourcePlayer, "acc.adminNick")
							local adminRank = getPlayerAdminTitle(sourcePlayer)

							outputChatBox(string.format("#5ec1e6[Válasz]: #ffffff%s (%d): #5ec1e6%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
							outputChatBox(string.format("#5ec1e6[Segítség]: #ffffff%s %s (%d): #5ec1e6%s", adminRank, adminName, myPlayerID, message), targetPlayer, 0, 0, 0, true)

							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("%s %s válaszolt neki: %s", adminRank, adminName, targetName))
							triggerClientEvent("onAdminMSGVa", resourceRoot, string.format("Üzenet: %s", message))
						end
					end
				end
			end
		end
	end
)

addCommandHandler("pm",
	function (sourcePlayer, commandName, partialNick, ...)
		if getElementData(sourcePlayer, "loggedIn") then
			if not partialNick or not (...) then
				outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Üzenet]", sourcePlayer, 0, 0, 0, true)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local message = table.concat({...}, " "):gsub("#%x%x%x%x%x%x", "")

					if message then
						local myName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local myAdminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
						local myPlayerID = getElementData(sourcePlayer, "playerID") or "N/A"

						if myAdminLevel == 0 or myAdminLevel >= 6 then
							local targetHelperLevel = getElementData(targetPlayer, "acc.helperLevel") or 0
							local targetAdminLevel = getElementData(targetPlayer, "acc.adminLevel") or 0
							local targetAdminDuty = getElementData(targetPlayer, "adminDuty") or 0
							local targetPlayerID = getElementData(targetPlayer, "playerID") or "N/A"

							local togPMState = getElementData(targetPlayer, "togpmstate") or false
                            
                            if togPMState then
                                outputChatBox("#4adfbf[SealMTA]: #ffffffAz adminisztrátor letiltotta a privát üzenetek fogadását.", sourcePlayer, 0, 0, 0, true)
                                return
                            end

							if (targetHelperLevel and targetHelperLevel > 0) or (targetAdminLevel and targetAdminLevel > 0 and targetAdminDuty == 1) then
								outputChatBox(string.format("#4adfbf[Küldött PM]: #ffffff%s (%d): #4adfbf%s", targetName, targetPlayerID, message), sourcePlayer, 0, 0, 0, true)
								outputChatBox(string.format("#03bafc[Fogadott PM]: #ffffff%s (%d): #03bafc%s", myName, myPlayerID, message), targetPlayer, 0, 0, 0, true)
							
								triggerClientEvent(targetPlayer, "playPrivateMessageSound", targetPlayer)
							else
								outputChatBox("#4adfbf[SealMTA]: #ffffffCsak szolgálatban lévő adminnak, illetve adminsegédnek tudsz privát üzenetet írni.", sourcePlayer, 0, 0, 0, true)
							end
						else
							outputChatBox("#4adfbf[SealMTA]: #ffffffNincs jogosultságod privát üzenetet írni. Használd a #4adfbf/vá #ffffffparancsot.", sourcePlayer, 0, 0, 0, true)
						end
					end
				end
			end
		end
	end)

addCommandHandler("togpm",
	function(sourcePlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			local togPMState = getElementData(sourcePlayer, "togpmstate") or false

			if not togPMState then
				outputChatBox("#4adfbf[SealMTA]: #ffffffLetiltottad a PM-ek fogadását.", sourcePlayer, 255, 255, 255, true)
				setElementData(sourcePlayer, "togpmstate", true)
			elseif togPMState then
				outputChatBox("#4adfbf[SealMTA]: #ffffffEngedélyezted a PM-ek fogadását.", sourcePlayer, 255, 255, 255, true)
				setElementData(sourcePlayer, "togpmstate", false)
			end
		end
	end
)

addCommandHandler("getpmrate",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (targetPlayer) then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név/ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local targetMessages = getElementData(targetPlayer, "admin.pm") or 0
					local targetResponses = getElementData(targetPlayer, "admin.response") or 0
					local targetName = getElementData(targetPlayer, "acc.adminNick") or "Admin"

					if tonumber(targetMessages) and tonumber(targetResponses) then
						outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen lekérdezted #4adfbf" .. targetName .. "#ffffff pm/válasz arányát.", sourcePlayer, 255, 255, 255, true)
					
						outputChatBox("		- PM-ek száma: #4adfbf" .. targetMessages, sourcePlayer, 255, 255, 255, true)
						outputChatBox("		- Válaszok száma: #4adfbf" .. targetResponses, sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end
)

addCommandHandler("resetpmrate",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (targetPlayer) then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név/ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local targetName = getElementData(targetPlayer, "acc.adminNick") or "Admin"
					local accountId = getElementData(targetPlayer, "char.accID") or 0
					
					outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen resetelted #4adfbf" .. targetName .. "#ffffff pm/válasz arányát.", sourcePlayer, 255, 255, 255, true)

					setElementData(targetPlayer, "admin.pm", 0)
					setElementData(targetPlayer, "admin.response", 0)

					dbExec(connection, "UPDATE accounts SET response = ? WHERE accountId = ?", 0, accountId)
					dbExec(connection, "UPDATE accounts SET pm = ? WHERE accountId = ?", 0, accountId)

				end
			end
		end
	end
)--]]

addCommandHandler("v",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (...) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Üzenet]", 255, 150, 0)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						showMessageForVezetoseg("[Vezetőségi Chat]: #4adfbf" .. adminRank .. " " .. adminName .. ": #ffffff" .. msg, 89, 142, 215, true)
					end
				end
			end
		end
	end)

addCommandHandler("a",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (...) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Üzenet]", 255, 150, 0)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						showMessageForAdmins("[AdminChat]: #4adfbf" .. adminRank .. " " .. adminName .. ": #ffffff" .. msg, 89, 142, 215, true)
					end
				end
			end
		end
	end)

addCommandHandler("as",
	function (sourcePlayer, commandName, ...)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 or getElementData(sourcePlayer, "acc.helperLevel") >= 1 or getElementData(sourcePlayer, "acc.rpGuard") then
			if not (...) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Üzenet]", 255, 150, 0)
			else
				local msg = string.gsub(table.concat({...}, " "), "#%x%x%x%x%x%x", "")

				if #msg > 0 and utf8.len(msg) > 0 then
					if utf8.len((utf8.gsub(msg, " ", "") or 0)) > 0 then
						local adminName = getElementData(sourcePlayer, "visibleName"):gsub("_", " ")
						local adminRank = getPlayerAdminTitle(sourcePlayer)

						if not adminRank then
							if getElementData(sourcePlayer, "acc.helperLevel") == 1 then
								adminRank = "AdminSegéd"
							elseif getElementData(sourcePlayer, "acc.helperLevel") == 2 then
								adminRank = "Helper"
							end
						end

						for k, v in pairs(getElementsByType("player")) do
							if (getElementData(v, "acc.adminLevel") or 0) >= 1 or (getElementData(v, "acc.helperLevel") or 0) >= 1 then
								outputChatBox("[HelperChat]: #4adfbf" .. adminRank .. " " .. adminName .. ": #ffffff" .. msg, v, 215, 89, 89, true)
							end
						end
					end
				end
			end
		end
	end)

addCommandHandler("unban",
	function (sourcePlayer, commandName, targetData)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 5 then
			if not targetData then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Account ID / Serial]", 255, 150, 0)
			else
				local adminNick = getElementData(sourcePlayer, "acc.adminNick")
				local unbanType = "playerAccountId"

				if tonumber(targetData) then
					targetData = tonumber(targetData)
				elseif string.len(targetData) == 32 then
					unbanType = "serial"
				else
					return false
				end

				local currTimestamp = getRealTime().timestamp

				--exports.seal_anticheat:sendDiscordMessage("**"..adminNick.."** feloldotta **"..targetData.."**", "prvdclog")
				
				dbQuery(
					function (qh, adminPlayer)
						local result, rows = dbPoll(qh, 0)
						
						if rows > 0 and result then
							local accountId = false
							
							for k, v in ipairs(result) do
								if not accountId then
									accountId = v.playerAccountId
								end

								dbExec(connection, "UPDATE bans SET deactivated = 'Yes', deactivatedBy = ?, deactivateTimestamp = ? WHERE banId = ?", adminNick,currTimestamp,v.banId)
							end

							

							dbExec(connection, "UPDATE accounts SET suspended = 0 WHERE accountId = ?", accountId)
							exports.seal_logs:logCommand(adminPlayer, commandName, {targetData})

							if isElement(adminPlayer) then
								exports.seal_anticheat:sendDiscordMessage("**"..adminNick.."** feloldotta egy játékos kitiltását **"..targetData.."**", "adminlog")

								showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen feloldottad a kiválasztott játékos tiltását.", 74, 223, 191)
							end
						else
							showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nincs kitiltva.", 215, 89, 89)
						end
					end,
				{sourcePlayer}, connection, "SELECT * FROM bans WHERE ?? = ? AND deactivated = 'No'", unbanType, targetData)
			end
		end
	end)

addCommandHandler("getaccid", 
	function(sourcePlayer, commandName, name)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not name then
				showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffff[Név] (PL.: Teszt_Elek)", 74, 223, 191)
			else
				dbQuery(
					function(qh, sourcePlayer)
						local result = dbPoll(qh, 0)[1]
						
						if not result then
							showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffNincs ilyen nevű felhasználó regisztrálva!", 74, 223, 191)
						else
							showAdminMessageFor(sourcePlayer, name.." #ffffffaccountID-je: #4adfbf "..result.accountId, 74, 223, 191)					
						end
					
					end, {sourcePlayer}, connection, "SELECT accountId from characters WHERE name = ?", name)
			end
		end
	end
)

function banFunction(datas)
	local adminNick = datas.adminNick
	local adminAccountId = datas.adminAccountId

	if isElement(datas.sourcePlayer) then
		adminNick = getElementData(datas.sourcePlayer, "acc.adminNick")
		adminAccountId = getElementData(datas.sourcePlayer, "char.accID")
	end

	local targetName = datas.targetName
	local accountName, playerAccountId = datas.accountName, datas.playerAccountId
	local duration = datas.duration

	if isElement(datas.targetPlayer) then
		targetName = getElementData(datas.targetPlayer, "visibleName"):gsub("_", " ")
		accountName = getElementData(datas.targetPlayer, "acc.Name")
		playerAccountId = getElementData(datas.targetPlayer, "char.accID")
	end

	local currentTime = getRealTime().timestamp
	local expireTime = currentTime

	if duration == 0 then
		expireTime = currentTime + 31536000 * 100
	else
		expireTime = currentTime + duration * 3600
	end

	if isElement(datas.targetPlayer) then
		kickPlayer(datas.targetPlayer, adminNick, datas.reason)
	end

	if targetName then
		exports.seal_anticheat:sendDiscordMessage("**"..adminNick.."** Kibannolta **"..targetName:gsub("_", " ").."**", "adminlog")
		exports.seal_anticheat:sendDiscordMessage("```"..datas.reason.."```", "adminlog")
		
		triggerClientEvent("addKickbox", root, "ban", adminNick, targetName, datas.reason, tostring(duration))
	end

	dbExec(connection, [[
		INSERT INTO bans
		(serial, playerName, playerAccountId, adminName, adminAccountId, banReason, banTimestamp, expireTimestamp)
		VALUES (?,?,?,?,?,?,?,?)
	]], datas.serial, accountName, playerAccountId, adminNick, adminAccountId, (datas.reason or "N/A"), currentTime, expireTime)

	dbExec(connection, "UPDATE accounts SET suspended = 1 WHERE accountId = ?", playerAccountId)

	return "ok"
end

function offBanFunction(datas)
	local adminNick = datas.adminNick
	local adminAccountId = datas.adminAccountId

	if isElement(datas.sourcePlayer) then
		adminNick = getElementData(datas.sourcePlayer, "acc.adminNick")
		adminAccountId = getElementData(datas.sourcePlayer, "char.accID")
	end

	local qh = dbQuery(connection, "SELECT * FROM accounts WHERE accountId = ?", datas.targetPlayerAccId)
	local result = dbPoll(qh, -1)
	result = result[1]
	
	if not result then
		exports.seal_accounts:showInfo(datas.sourcePlayer, "e", "Nincs ilyen AccountID-vel találat!")
		return
	end

	local qh2 = dbQuery(connection, "SELECT * FROM characters WHERE accountId = ?", result.accountId)
	local result2 = dbPoll(qh2, -1)
	result2 = result2[1]

	local targetName = result2.name
	local accountName, playerAccountId = result.username, result.accountId
	local duration = datas.duration

	--[[if isElement(datas.targetPlayer) then
		targetName = getElementData(datas.targetPlayer, "visibleName"):gsub("_", " ")
		accountName = getElementData(datas.targetPlayer, "acc.Name")
		playerAccountId = getElementData(datas.targetPlayer, "char.accID")
	end]]

	local currentTime = getRealTime().timestamp
	local expireTime = currentTime

	if duration == 0 then
		expireTime = currentTime + 31536000 * 100
	else
		expireTime = currentTime + duration * 3600
	end

	--[[if isElement(datas.targetPlayer) then
		kickPlayer(datas.targetPlayer, adminNick, datas.reason)
	end]]

	if targetName then
		exports.seal_anticheat:sendDiscordMessage("**"..adminNick.."** Kibannolta **"..targetName:gsub("_", " ").."**", "adminlog")
		exports.seal_anticheat:sendDiscordMessage("```"..datas.reason.."```", "adminlog")
		triggerClientEvent("addKickbox", root, "ban", adminNick, targetName, datas.reason, tostring(duration))
	end

	iprint(result.serial, accountName, playerAccountId, adminNick, adminAccountId, (datas.reason or "N/A"), currentTime, expireTime)
	dbExec(connection, [[
		INSERT INTO bans
		(serial, playerName, playerAccountId, adminName, adminAccountId, banReason, banTimestamp, expireTimestamp)
		VALUES (?,?,?,?,?,?,?,?)
	]], result.serial, accountName, playerAccountId, adminNick, adminAccountId, (datas.reason or "N/A"), currentTime, expireTime)

	dbExec(connection, "UPDATE accounts SET suspended = 1 WHERE accountId = ?", playerAccountId)

	return "ok"
end

addCommandHandler("ban",
	function (sourcePlayer, commandName, targetPlayer, duration, ...)
		duration = tonumber(duration)

		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 then
			if not (targetPlayer and duration and (...)) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Óra < 0 = örök >] [Indok]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)
				if targetPlayer then
					
					banFunction({
						sourcePlayer = sourcePlayer,
						targetPlayer = targetPlayer,
						reason = table.concat({...}, " "),
						duration = math.floor(math.abs(duration)),
						serial = getPlayerSerial(targetPlayer)
					})

					exports.seal_logs:addLogEntry("ban", {
						sourcePlayer = inspect(sourcePlayer),
						targetPlayer = inspect(targetPlayer),
						reason = table.concat({...}, " "),
						duration = math.floor(math.abs(duration)),
						serial = getPlayerSerial(targetPlayer)
					})
				end
			end
		end
	end)

local offbanTick = {}

addCommandHandler("offban",
	function (sourcePlayer, commandName, accountId, duration, ...)
		duration = tonumber(duration)

		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 or getElementData(sourcePlayer, "acc.adminNick") == "muffsheen" then
			if not (duration and accountId and (...)) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Account ID] [Óra < 0 = örök >] [Indok]", 255, 150, 0)
			else
				--targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)
				if accountId then
					if not offbanTick[sourcePlayer] then
						offbanTick[sourcePlayer] = 0
					end
					
					if getTickCount() - offbanTick[sourcePlayer] < 3000 then
						exports.seal_gui:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					offbanTick[sourcePlayer] = getTickCount()

					offBanFunction({
						sourcePlayer = sourcePlayer,
						targetPlayerAccId = accountId,
						reason = table.concat({...}, " "),
						duration = math.floor(math.abs(duration)),
						--serial = getPlayerSerial(targetPlayer)
					})

					exports.seal_logs:addLogEntry("offban", {
						sourcePlayer = sourcePlayer,
						targetPlayerAccId = accountId,
						reason = table.concat({...}, " "),
						duration = math.floor(math.abs(duration))
					})
				end
			end
		end
	end)


addCommandHandler("kick",
	function (sourcePlayer, commandName, targetPlayer, ...)
		--if getPlayerSerial(sourcePlayer) == "E04648D6E7957CDE9ADC17429148D6A1" then
		--	return
		--end
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (targetPlayer and (...)) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Indok]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminLevel = getElementData(targetPlayer, "acc.adminLevel") or 0
					if adminLevel >= 6 then
						outputChatBox("#4adfbf[SealMTA]: #ffffffSikertelen művelet.", sourcePlayer, 255, 255, 255, true)
						return
					end

					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local reason = table.concat({...}, " ")

					exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** kickelte **"..targetName.."**", "adminlog")
					exports.seal_anticheat:sendDiscordMessage("```"..reason.."```", "adminlog")

					triggerClientEvent("addKickbox", root, "kick", adminName, targetName, reason)
					kickPlayer(targetPlayer, adminName, reason)

					exports.seal_logs:logCommand(adminName, commandName, {targetName, reason})
				end
			end
		end
	end)

--[[addCommandHandler("crash",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					triggerClientEvent(targetPlayer, "onPlayerCrashFromServer", targetPlayer)
				end
			end
		end
	end
)]]

addEventHandler("onPlayerQuit", root,
	function()
		local spectatingPlayers = getElementData(source, "spectatingPlayers") or {}

		for k, v in pairs(spectatingPlayers) do
			if isElement(k) then
				local playerLastPos = getElementData(k, "playerLastPos")
				local currentTarget = getElementData(k, "spectateTarget") -- nézett játékos lekérése

				spectatingPlayers[k] = nil -- kivesszük a parancs használóját a nézett játékos nézelődői közül

				setElementAlpha(k, 255)
				setElementInterior(k, playerLastPos[4])
				setElementDimension(k, playerLastPos[5])
				setCameraInterior(k, playerLastPos[4])
				setCameraTarget(k, k)
				setElementFrozen(k, false)
				setElementCollisionsEnabled(k, true)
				setElementPosition(k, playerLastPos[1], playerLastPos[2], playerLastPos[3])
				setElementRotation(k, 0, 0, playerLastPos[6])

				removeElementData(k, "spectateTarget")
				removeElementData(k, "playerLastPos")
			end
		end
	end
)

addCommandHandler("takemoney",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			value = tonumber(value)

			if not (targetPlayer and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					value = math.floor(value)
					exports.seal_core:takeMoney(targetPlayer, value, "admintake")

					exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** elvett egy játékostól **"..formatNumber(value).." dollárt** **"..targetName.."**", "moneylog")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffelvett tőled #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffElvettél #4adfbf" .. targetName .. " #ffffffjátékostól #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
				end
			end
		end
	end)

addCommandHandler("givemoney",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			value = tonumber(value)

			if not (targetPlayer and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** Adott egy játékosnak **"..formatNumber(value).." dollárt** **"..targetName.."**", "setmoney")


					value = math.floor(value)
					exports.seal_core:giveMoney(targetPlayer, value, "admingive")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffadott neked #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffAdtál #4adfbf" .. targetName .. " #ffffffjátékosnak #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
				end
			end
		end
	end)

addCommandHandler("setmoney",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			value = tonumber(value)

			if not (targetPlayer and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					--exports.seal_anticheat:sendDiscordMessage(adminName.." Adott pénzt : ".. formatNumber(value).. " playerElement : "..targetName .. " [setMoney]", "anticheat")

					exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** átállította a pénzét egy játékosnak **"..formatNumber(value).." dollárt** **"..targetName.."**", "setmoney")


					value = math.floor(value)
					exports.seal_core:setMoney(targetPlayer, value, "admingive")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffátállította a pénzösszeged #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffÁtállítottad a pénzösszegét #4adfbf" .. targetName .. " #ffffffjátékosnak #4adfbf" .. formatNumber(value) .. " #ffffffdollárt.", 74, 223, 191)
				end
			end
		end
	end)

addCommandHandler("setpp",
	function (sourcePlayer, commandName, targetPlayer, state, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			state = tonumber(state)
			value = tonumber(value)

			if not (targetPlayer and state and state >= 0 and state <= 1 and value and value > 0) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [0 = levonás | 1 = hozzáadás] [Összeg]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local currentPP = getElementData(targetPlayer, "acc.premiumPoints") or 0
					local newPP = currentPP

					value = math.floor(value)

					if state == 0 then
						newPP = currentPP - value

						if newPP < 0 then
							newPP = 0
						end
					elseif state == 1 then
						newPP = currentPP + value
					end

					setElementData(targetPlayer, "acc.premiumPoints", newPP)

					dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPP, getElementData(targetPlayer, "char.accID"))

					if state == 0 then
						exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** levont egy játékostól **"..formatNumber(value).." Prémiumpontot** **"..targetName.."**", "setpp")


						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #fffffflevont tőled #4adfbf" .. formatNumber(value) .. " #ffffffPP-t.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffLevontál #4adfbf" .. targetName .. " #ffffffjátékostól #4adfbf" .. formatNumber(value) .. " #ffffffPP-t.", 74, 223, 191)
					elseif state == 1 then
						exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** adott egy játékosnak **"..formatNumber(value).." Prémiumpontot** **"..targetName.."**", "setpp")


						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffadott neked #4adfbf" .. formatNumber(value) .. " #ffffffPP-t.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffAdtál #4adfbf" .. targetName .. " #ffffffjátékosnak #4adfbf" .. formatNumber(value) .. " #ffffffPP-t.", 74, 223, 191)
					end
				end
			end
		end
	end)

addCommandHandler("setskin",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Skin ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementModel(targetPlayer, value)
					setElementData(targetPlayer, "char.Skin", value)

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta a kinézeted. #4adfbf(" .. value .. ")", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megváltoztattad #4adfbf" .. targetName .. " #ffffffkinézetét. #4adfbf(" .. value .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("unfreeze",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local pedveh = getPedOccupiedVehicle(targetPlayer)

					if pedveh then
						setElementFrozen(pedveh, false)
					end

					setElementFrozen(targetPlayer, false)
					exports.seal_controls:toggleControl(targetPlayer, "all", true)

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffkiolvasztott téged.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffKiolvasztottad #4adfbf" .. targetName .. " #ffffffjátékost.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("freeze",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local pedveh = getPedOccupiedVehicle(targetPlayer)

					if pedveh then
						setElementFrozen(pedveh, true)
					end

					setElementFrozen(targetPlayer, true)
					exports.seal_controls:toggleControl(targetPlayer, "all", false)

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #fffffflefagyasztott téged.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffLefagyasztottad #4adfbf" .. targetName .. " #ffffffjátékost.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("setthirst",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Szomjúság < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "char.Thirst", value)

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta a szomjúságszinted. #4adfbf(" .. value .. ")", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMegváltoztattad #4adfbf" .. targetName .. " #ffffffjátékos szomjúságszintjét. #4adfbf(" .. value .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("sethunger",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Éhség < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "char.Hunger", value)

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta az éhségszinted. #4adfbf(" .. value .. ")", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMegváltoztattad #4adfbf" .. targetName .. " #ffffffjátékos éhségszintjét. #4adfbf(" .. value .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("setarmor",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Páncélzat < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					setPedArmor(targetPlayer, value)
					exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** megváltoztatta egy játékos páncélzatát **"..targetName.."** ["..value.."]", "adminlog")


					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta a páncélzatodat. #4adfbf(" .. value .. ")", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMegváltoztattad #4adfbf" .. targetName .. " #ffffffjátékos páncélzatát. #4adfbf(" .. value .. ")", 74, 223, 191)
					if not togurma then
						showAdminLog(adminRank .. " " .. adminName .. " átállította #4adfbf" .. targetName .. " #ffffffpáncélzatát. #4adfbf(" .. value .. ")")
					end
					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

addCommandHandler("sethp",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 100 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Életerő < 0 - 100 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local adminRank = getPlayerAdminTitle(sourcePlayer)

					setElementHealth(targetPlayer, value)

					exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** megváltoztatta egy játékos életerejét **"..targetName.."** ["..value.."]", "adminlog")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta az életerődet. #4adfbf(" .. value .. ")", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMegváltoztattad #4adfbf" .. targetName .. " #ffffffjátékos életerejét. #4adfbf(" .. value .. ")", 74, 223, 191)
					if not togurma then
						showAdminLog(adminRank .. " " .. adminName .. " átállította #4adfbf" .. targetName .. " #fffffféleterejét. #4adfbf(" .. value .. ")")
					end

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

local vhspawnTick = {}

addCommandHandler("vhspawn",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if not vhspawnTick[sourcePlayer] then
						vhspawnTick[sourcePlayer] = 0
					end

					if getTickCount() - vhspawnTick[sourcePlayer] < 3000 then
						exports.seal_gui:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					vhspawnTick[sourcePlayer] = getTickCount()

					if isPedInVehicle(targetPlayer) then
						removePedFromVehicle(targetPlayer)
					end

					setElementPosition(targetPlayer, 1481.3143310547, -1751.4930419922, 15.4453125)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, 0)

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffelteleportált téged a városházára.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen elteleportáltad a kiválasztott játékost a városházára. #4adfbf(" .. targetName .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

local akspawnTick = {}

	addCommandHandler("akspawn",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if not akspawnTick[sourcePlayer] then
						akspawnTick[sourcePlayer] = 0
					end
					
					if getTickCount() - akspawnTick[sourcePlayer] < 3000 then
						exports.seal_gui:showInfobox(sourcePlayer, "e", "Várj egy kicsit!")
						return
					end
				
					akspawnTick[sourcePlayer] = getTickCount()

					if isPedInVehicle(targetPlayer) then
						removePedFromVehicle(targetPlayer)
					end

					setElementPosition(targetPlayer,  2131.1018066406, -1137.1456298828, 25.567993164062)
					setElementInterior(targetPlayer, 0)
					setElementDimension(targetPlayer, 0)

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffelteleportált téged az autókereskedéshez.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen elteleportáltad a kiválasztott játékost a autókereskedéshez. #4adfbf(" .. targetName .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("gethere",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local x, y, z = getElementPosition(sourcePlayer)
					local int = getElementInterior(sourcePlayer)
					local dim = getElementDimension(sourcePlayer)
					local rot = getPedRotation(sourcePlayer)

					x = x + math.cos(math.rad(rot)) * 2
					y = y + math.sin(math.rad(rot)) * 2

					local customInterior = getElementData(sourcePlayer, "currentCustomInterior") or 0
					if customInterior > 0 then
						exports.seal_interioredit:loadInterior(targetPlayer, customInterior)
					end

					if isPedInVehicle(targetPlayer) then
						local pedveh = getPedOccupiedVehicle(targetPlayer)

						setElementAngularVelocity(pedveh, 0, 0, 0)
						setElementInterior(pedveh, int)
						setElementDimension(pedveh, dim)
						setElementPosition(pedveh, x, y, z + 1)

						setTimer(setElementAngularVelocity, 50, 20, pedveh, 0, 0, 0)
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, int)
						setElementDimension(targetPlayer, dim)
					end

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmagához teleportált.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMagadhoz teleportáltad #4adfbf" .. targetName .. " #ffffffjátékost.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("goto",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local x, y, z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local rot = getPedRotation(targetPlayer)

					x = x + math.cos(math.rad(rot)) * 2
					y = y + math.sin(math.rad(rot)) * 2

					local customInterior = getElementData(targetPlayer, "currentCustomInterior") or 0
					if customInterior > 0 then
						local editingInterior = getElementData(targetPlayer, "editingInterior") or 0
						if editingInterior == 0 then
							exports.seal_interioredit:loadInterior(sourcePlayer, customInterior)
						else
							showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos interior szerkesztő módban van.", 74, 223, 191)
							return
						end
					end

					if isPedInVehicle(sourcePlayer) then
						local pedveh = getPedOccupiedVehicle(sourcePlayer)

						setElementAngularVelocity(pedveh, 0, 0, 0)
						setElementInterior(pedveh, int)
						setElementDimension(pedveh, dim)
						setElementPosition(pedveh, x, y, z + 1)

						setElementInterior(sourcePlayer, int)
						setElementDimension(sourcePlayer, dim)
						setCameraInterior(sourcePlayer, int)

						warpPedIntoVehicle(sourcePlayer, pedveh)
						setTimer(setElementAngularVelocity, 50, 20, pedveh, 0, 0, 0)
					else
						setElementPosition(sourcePlayer, x, y, z)
						setElementInterior(sourcePlayer, int)
						setElementDimension(sourcePlayer, dim)
						setCameraInterior(sourcePlayer, int)
					end

					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffhozzád teleportált.", 74, 223, 191)
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffElteleportáltál #4adfbf" .. targetName .. " #ffffffjátékoshoz.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
				end
			end
		end
	end)

addCommandHandler("vanish",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			local vanished = getElementData(sourcePlayer, "player.Vanished")
			local newState = not vanished

			setElementData(sourcePlayer, "player.Vanished", newState)
			setElementAlpha(sourcePlayer, newState and 0 or 255)

			if newState then
				showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffLáthatatlanná tetted magad.", 74, 223, 191)
			else
				showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffLáthatóvá tetted magad.", 74, 223, 191)
			end
		end
	end)

addCommandHandler("aduty",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
			local adminDutyState = getElementData(sourcePlayer, "adminDuty") or 0
			local adminName = getElementData(sourcePlayer, "acc.adminNick")

			if adminDutyState == 0 then
				setPlayerName(sourcePlayer, adminName)
				setElementData(sourcePlayer, "visibleName", adminName)
				setElementData(sourcePlayer, "adminDuty", 1)
				setElementData(sourcePlayer, "invulnerable", true)
				
				exports.seal_gui:showInfobox(root, "g", adminName .. " adminszolgálatba lépett.")
			else
				local playerElements = getElementsByType("player")
				local adminCount, adminDutyCount = getAvailableAdmins()

				if getElementData(sourcePlayer, "acc.adminLevel") <= 5 then
					local playerElements = getElementsByType("player")
					local adminCount, adminDutyCount = getAvailableAdmins()

					if adminDutyCount * 20 < #playerElements then
						showMessageForAdmins("[AdminDuty]: #4adfbf" .. adminName .. " #ffffffmegpróbált kilépni adminszolgálatból, de nincs arány!", 89, 142, 215)
						exports.seal_gui:showInfobox(sourcePlayer, "e", "Nincs arány!")
						return
					end
				end

				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 0)
				setElementData(sourcePlayer, "invulnerable", false)

				exports.seal_gui:showInfobox(root, "o", adminName .. " kilépett az adminszolgálatból.")
			end
		end
	end)

function getAvailableAdmins()
	local playerElements = getElementsByType("player")
	local adminCounter = 0
	local adminDutyCounter = 0

	for i = 1, #playerElements do
		local loggedIn = getElementData(playerElements[i], "loggedIn") or false

		if loggedIn then
			local adminLevel = getElementData(playerElements[i], "acc.adminLevel") or 0
			local adminDuty = getElementData(playerElements[i], "adminDuty") or false

			if adminLevel <= 5 then
				adminCounter = adminCounter + 1

				if adminDuty == 1 then
					adminDutyCounter = adminDutyCounter + 1
				end
			end
		end
	end

	return adminCounter, adminDutyCounter
end

addCommandHandler("forceaduty",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not targetPlayer then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					executeCommandHandler("aduty", targetPlayer)
				end
			end
		end
	end
)

--[[addCommandHandler("aduty2",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			local adminDutyState = getElementData(sourcePlayer, "adminDuty") or 0
			local adminName = getElementData(sourcePlayer, "acc.adminNick")

			if adminDutyState ~= 2 then
				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 2)
				setElementData(sourcePlayer, "invulnerable", true)
				setElementData(sourcePlayer, "adminDuty2", true)

				showAdminMessageFor(sourcePlayer, "[AdminDuty - Hidden]: #ffffffRejtett adminszolgálatba léptél.", 89, 142, 215)
			else
				local characterName = getElementData(sourcePlayer, "char.Name")

				setPlayerName(sourcePlayer, characterName)
				setElementData(sourcePlayer, "visibleName", characterName)
				setElementData(sourcePlayer, "adminDuty", 0)
				setElementData(sourcePlayer, "invulnerable", false)
				setElementData(sourcePlayer, "adminDuty2", false)

				showAdminMessageFor(sourcePlayer, "[AdminDuty - Hidden]: #ffffffKiléptél az adminszolgálatból..", 89, 142, 215)
			end
		end
	end)]]

addCommandHandler("changename",
	function (sourcePlayer, commandName, partialNick, newName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not (partialNick and newName) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Név / ID] [Új név]", 255, 150, 0)
			else
				local targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, partialNick)

				if isElement(targetPlayer) then
					local serial = getPlayerSerial(sourcePlayer)
					local targetSerial = getPlayerSerial(targetPlayer)

					local accountId = getElementData(targetPlayer, "char.ID")
					local fixedName = utf8.gsub(newName, " ", "_")
					local currentName = getElementData(targetPlayer, "char.Name"):gsub("_", " ")

					dbQuery(
						function (queryHandle)
							local result, numRows = dbPoll(queryHandle, 0)

							if numRows == 0 then
								dbExec(connection, "UPDATE characters SET name = ? WHERE characterId = ?", fixedName, accountId)

								if isElement(targetPlayer) then
									local adminName = getElementData(sourcePlayer, "acc.adminNick")

									setPlayerName(targetPlayer, fixedName)
									setElementData(targetPlayer, "char.Name", fixedName)

									if getElementData(targetPlayer, "adminDuty") ~= 1 then
										setElementData(targetPlayer, "visibleName", fixedName)
									end

									exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName"):gsub("_", " ").."** megváltoztatta egy játékos nevét **"..currentName.."  "..fixedName:gsub("_", " ").."**", "adminlog")
									showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffátállította a karakterneved. #4adfbf(" .. fixedName:gsub("_", " ") .. ")", 74, 223, 191)
								end

								if isElement(sourcePlayer) then
									showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffÁtállítottad #4adfbf" .. currentName .. " #ffffffjátékos karakternevét. #4adfbf(" .. fixedName:gsub("_", " ") .. ")", 74, 223, 191)
								end

								
								exports.seal_logs:addLogEntry("changename", {
									sourcePlayer = inspect(sourcePlayer),
									targetPlayer = inspect(targetPlayer),
									oldName = currentName,
									newName = fixedName,
									adminName = adminName,
									sourceSerial = serial,
									targetSerial = targetSerial
								})
							else
								showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott karakternév foglalt!", 215, 89, 89)
							end
						end,
					connection, "SELECT name FROM characters WHERE name = ? LIMIT 1", fixedName)
				end
			end
		end
	end
)

addCommandHandler("setadminnick",
	function (sourcePlayer, commandName, targetPlayer, newName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			if not targetPlayer or not newName then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Új név]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")

					setElementData(targetPlayer, "acc.adminNick", newName)

					if getElementData(targetPlayer, "adminDuty") == 1 then
						setElementData(targetPlayer, "visibleName", newName)
					end

					dbExec(connection, "UPDATE accounts SET adminNick = ? WHERE accountId = ?", newName, getElementData(targetPlayer, "char.accID"))

					showAdminMessage("[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta #4adfbf" .. targetName .. " #ffffffadminisztrátori nevét. #4adfbf(" .. newName .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, newName})
				end
			end
		end
	end)

addCommandHandler("setadminlevel",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			value = tonumber(value)

			if not targetPlayer or not value or value < 0 or value > 12 then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Szint < 0 - 12 >]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local adminName = getElementData(sourcePlayer, "acc.adminNick")
					local currentAdminLevel = getElementData(targetPlayer, "acc.adminLevel") or 0

					if value == currentAdminLevel then
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos már a megadott szinten van.", 215, 89, 89)
						return
					end

					if value == 0 then
						setElementData(targetPlayer, "adminDuty", 0)
						setElementData(targetPlayer, "visibleName", getElementData(targetPlayer, "char.Name"))
					end

					exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName").."** megváltoztatta egy játékos admin szintjét. **["..targetName.." , " .. currentAdminLevel .. " >> " .. value .. "]**", "adminlog")

					setElementData(targetPlayer, "acc.adminLevel", value)

					dbExec(connection, "UPDATE accounts SET adminLevel = ? WHERE accountId = ?", value, getElementData(targetPlayer, "char.accID"))

					showAdminMessage("[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta #4adfbf" .. targetName .. " #ffffffadminisztrátori szintjét. #4adfbf(" .. currentAdminLevel .. " >> " .. value .. ")", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
				end
			end
		end
	end)

	
addCommandHandler("sethelperlevel",
function (sourcePlayer, commandName, targetPlayer, value)
	if getElementData(sourcePlayer, "acc.adminLevel") >= 3 or getPlayerSerial(sourcePlayer) == "0" then
		value = tonumber(value)

		if not targetPlayer or not value or value < 0 or value > 2 then
			showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Szint < 0 - 2 >]", 255, 150, 0)
		else
			targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				if getElementData(sourcePlayer, "acc.adminLevel") <= 5 then
					if value > 1 then
						outputChatBox("#4adfbf[SealMTA]: #ffffffCsak I.D.G adminsegédet adhatsz!", sourcePlayer, 255, 255, 255, true)
						return
					end
				end
				
				local adminName = getElementData(sourcePlayer, "acc.adminNick")
				local currentAdminLevel = getElementData(targetPlayer, "acc.helperLevel") or 0

				if value == currentAdminLevel then
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos már a megadott szinten van.", 215, 89, 89)
					return
				end

				if value == 1 then
					setElementData(targetPlayer, "acc.helperLevel", value)
				else
					setElementData(targetPlayer, "acc.helperLevel", value)
					dbExec(connection, "UPDATE accounts SET helperLevel = ? WHERE accountId = ?", value, getElementData(targetPlayer, "char.accID"))
				end

				exports.seal_anticheat:sendDiscordMessage("**"..getElementData(sourcePlayer, "visibleName").."** megváltoztatta egy játékos adminsegéd szintjét. **["..targetName.." , " .. value .. "]**", "adminlog")


				showAdminMessage("[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta #4adfbf" .. targetName .. " #ffffffadminsegéd szintjét.", 74, 223, 191)

				exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, value})
			end
		end
	end
end)

function outputInfoText(string, playerSource)
	if isElement(playerSource) then
		outputChatBox("#4adfbf[SealMTA]: #ffffff" .. string, playerSource, 0, 0, 0, true)
	end
end

addCommandHandler("stats", function(sourcePlayer, commandName, targetPlayer)
	if getElementData(sourcePlayer,"acc.adminLevel") >= 1 then
		if not targetPlayer then
			outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Név / ID]", sourcePlayer, 0, 0, 0, true)
		else
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)
			
			if targetPlayer then
				if tonumber(getElementData(targetPlayer, "acc.adminLevel")) >= 7 and tonumber(getElementData(sourcePlayer, "acc.adminLevel")) < 7 then
					outputInfoText("Őt nem tudod statolni. (Adminszintje: " .. tonumber(getElementData(targetPlayer, "acc.adminLevel")) .. ")", sourcePlayer)
					outputInfoText(getPlayerName(sourcePlayer).." megpróbált téged statolni", targetPlayer)
				else
					local accountId = tonumber(getElementData(targetPlayer, "char.accID"))
					local targetPlayerName = getElementData(targetPlayer, "char.Name")
					local money = tonumber(getElementData(targetPlayer, "char.Money"))
					local bankMoney = tonumber(getElementData(targetPlayer, "char.bankMoney"))
					local premium = tonumber(getElementData(targetPlayer, "acc.premiumPoints"))
					local admin = tonumber(getElementData(targetPlayer, "acc.adminLevel"))
                    local uc = tonumber(getElementData(targetPlayer, "char.slotCoins"))

					outputInfoText(targetPlayerName.." játékos adatai", sourcePlayer)
					outputInfoText("AccountID: #32b3ef"..accountId, sourcePlayer)
					outputInfoText("Név: #32b3ef"..targetPlayerName, sourcePlayer)
					outputInfoText("Készpénz: #32b3ef"..formatNumber(money).. " $", sourcePlayer)
					outputInfoText("Banki vagyon: #32b3ef"..formatNumber(bankMoney).." $", sourcePlayer)
					outputInfoText("Prémium Pont: #32b3ef"..formatNumber(premium) .. " PP", sourcePlayer)
                    outputInfoText("Kaszinó zseton: #32b3ef"..formatNumber(uc) .. " Coin", sourcePlayer)
				
					if admin > 0 then
						local adminNick = getPlayerAdminNick(targetPlayer)
						outputInfoText("Admin név: #32b3ef"..adminNick, sourcePlayer)
						outputInfoText("Admin szint: #32b3ef"..admin, sourcePlayer)
					else
						outputInfoText("Admin: Nem admin", sourcePlayer)
					end
					
					local groupString = ""
					local group = exports.seal_groups:getPlayerGroups(targetPlayer)
					
					
					for groupID, groupData in pairs(group) do
						local groupPrefix = exports.seal_groups:getGroupPrefix(groupID)
						local isLeader = "#cc0a0aNem#ffffff"
						
						if groupData[3] == "Y" then
							isLeader = "#17cc0aIgen#ffffff"
						end
						
						groupString = groupString .. groupPrefix.." : Leader: "..isLeader.." | "
					end
					outputInfoText("Frakció: "..groupString, sourcePlayer)
				end
			end
		end
	end
end)

addEvent("updateSpectatePosition", true)
addEventHandler("updateSpectatePosition", getRootElement(),
	function (interior, dimension, customInterior)
		if isElement(source) and client == source then
			setElementInterior(source, interior)
			setElementDimension(source, dimension)
			setCameraInterior(source, interior)

			if customInterior and customInterior > 0 then
				triggerClientEvent(source, "loadCustomInterior", source, customInterior)
			end
		end
	end
)

addCommandHandler("hiddenspec", function(sourcePlayer, commandName, targetPlayer)
	if getElementData(sourcePlayer, "acc.adminLevel") > 4 then
		if not targetPlayer then
			showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
		else
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				local adminNick = getElementData(sourcePlayer, "acc.adminNick")

				if targetPlayer == sourcePlayer then -- ha a célszemély saját maga, kapcsolja ki a nézelődést
					local playerLastPos = getElementData(sourcePlayer, "playerLastPos")

					if playerLastPos then -- ha tényleg nézelődött
						local currentTarget = getElementData(sourcePlayer, "spectateTarget") -- nézett játékos lekérése
						local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} -- nézett játékos nézelődőinek lekérése

						spectatingPlayers[sourcePlayer] = nil -- kivesszük a parancs használóját a nézett játékos nézelődői közül
						setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) -- elmentjük az úrnak

						setElementAlpha(sourcePlayer, 255)
						setElementInterior(sourcePlayer, playerLastPos[4])
						setElementDimension(sourcePlayer, playerLastPos[5])
						setCameraInterior(sourcePlayer, playerLastPos[4])
						setCameraTarget(sourcePlayer, sourcePlayer)
						setElementFrozen(sourcePlayer, false)
						setElementCollisionsEnabled(sourcePlayer, true)
						setElementPosition(sourcePlayer, playerLastPos[1], playerLastPos[2], playerLastPos[3])
						setElementRotation(sourcePlayer, 0, 0, playerLastPos[6])

						local targetName = getElementData(getElementData(sourcePlayer, "spectateTarget"), "visibleName"):gsub("_", " ")
						removeElementData(sourcePlayer, "spectateTarget")
						removeElementData(sourcePlayer, "playerLastPos")

					end
				else
					local targetInterior = getElementInterior(targetPlayer)
					local targetDimension = getElementDimension(targetPlayer)
					local currentTarget = getElementData(sourcePlayer, "spectateTarget")
					local playerLastPos = getElementData(sourcePlayer, "playerLastPos")

					if currentTarget and currentTarget ~= targetPlayer then -- ha a jelenleg nézett célszemély nem az új célszemély vegye ki a nézelődők listájából
						local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} -- jelenleg nézett célszemély nézelődői

						spectatingPlayers[sourcePlayer] = nil -- eltávolítjuk az eddig nézett játékos nézelődői közül
						setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) -- elmentjük a változásokat
					end

					if not playerLastPos then -- ha eddig nem volt nézelődő módban, mentse el a jelenlegi pozícióját
						local localX, localY, localZ = getElementPosition(sourcePlayer)
						local localRotX, localRotY, localRotZ = getElementPosition(sourcePlayer)
						local localInterior = getElementInterior(sourcePlayer)
						local localDimension = getElementDimension(sourcePlayer)

						setElementData(sourcePlayer, "playerLastPos", {localX, localY, localZ, localInterior, localDimension, localRotZ}, false)
					end

					setElementAlpha(sourcePlayer, 0)
					setPedWeaponSlot(sourcePlayer, 0)
					setElementInterior(sourcePlayer, targetInterior)
					setElementDimension(sourcePlayer, targetDimension)
					setCameraInterior(sourcePlayer, targetInterior)
					setCameraTarget(sourcePlayer, targetPlayer)
					setElementFrozen(sourcePlayer, true)
					setElementCollisionsEnabled(sourcePlayer, false)

					local spectatingPlayers = getElementData(targetPlayer, "spectatingPlayers") or {} -- lekérjük az új úrfi jelenlegi nézelődőit

					spectatingPlayers[sourcePlayer] = true -- hozzáadjuk az úrfi nézelődőihez a parancs használóját
					setElementData(targetPlayer, "spectatingPlayers", spectatingPlayers) -- elmentjük az úrfinak a változásokat

					setElementData(sourcePlayer, "spectateTarget", targetPlayer)
				end
			end
		end
	end
end)

addCommandHandler("spec", function(sourcePlayer, commandName, targetPlayer)
	if getElementData(sourcePlayer, "acc.adminLevel") > 0 then
		if not targetPlayer then
			showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
		else
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				local adminNick = getElementData(sourcePlayer, "acc.adminNick")

				if targetPlayer == sourcePlayer then -- ha a célszemély saját maga, kapcsolja ki a nézelődést
					local playerLastPos = getElementData(sourcePlayer, "playerLastPos")

					if playerLastPos then -- ha tényleg nézelődött
						local currentTarget = getElementData(sourcePlayer, "spectateTarget") -- nézett játékos lekérése
						local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} -- nézett játékos nézelődőinek lekérése

						spectatingPlayers[sourcePlayer] = nil -- kivesszük a parancs használóját a nézett játékos nézelődői közül
						setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) -- elmentjük az úrnak

						setElementAlpha(sourcePlayer, 255)
						setElementInterior(sourcePlayer, playerLastPos[4])
						setElementDimension(sourcePlayer, playerLastPos[5])
						setCameraInterior(sourcePlayer, playerLastPos[4])
						setCameraTarget(sourcePlayer, sourcePlayer)
						setElementFrozen(sourcePlayer, false)
						setElementCollisionsEnabled(sourcePlayer, true)
						setElementPosition(sourcePlayer, playerLastPos[1], playerLastPos[2], playerLastPos[3])
						setElementRotation(sourcePlayer, 0, 0, playerLastPos[6])

						local targetName = getElementData(getElementData(sourcePlayer, "spectateTarget"), "visibleName"):gsub("_", " ")
						removeElementData(sourcePlayer, "spectateTarget")
						removeElementData(sourcePlayer, "playerLastPos")

						exports.seal_administration:showAdminLog("#4adfbf" .. adminNick .. " #ffffffbefejezte #4adfbf" .. targetName .. " #ffffffTV-zését.", 6)
					end
				else
					local targetInterior = getElementInterior(targetPlayer)
					local targetDimension = getElementDimension(targetPlayer)
					local currentTarget = getElementData(sourcePlayer, "spectateTarget")
					local playerLastPos = getElementData(sourcePlayer, "playerLastPos")

					if currentTarget and currentTarget ~= targetPlayer then -- ha a jelenleg nézett célszemély nem az új célszemély vegye ki a nézelődők listájából
						local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} -- jelenleg nézett célszemély nézelődői

						spectatingPlayers[sourcePlayer] = nil -- eltávolítjuk az eddig nézett játékos nézelődői közül
						setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) -- elmentjük a változásokat
					end

					if not playerLastPos then -- ha eddig nem volt nézelődő módban, mentse el a jelenlegi pozícióját
						local localX, localY, localZ = getElementPosition(sourcePlayer)
						local localRotX, localRotY, localRotZ = getElementPosition(sourcePlayer)
						local localInterior = getElementInterior(sourcePlayer)
						local localDimension = getElementDimension(sourcePlayer)

						setElementData(sourcePlayer, "playerLastPos", {localX, localY, localZ, localInterior, localDimension, localRotZ}, false)
					end

					setElementAlpha(sourcePlayer, 0)
					setPedWeaponSlot(sourcePlayer, 0)
					setElementInterior(sourcePlayer, targetInterior)
					setElementDimension(sourcePlayer, targetDimension)
					setCameraInterior(sourcePlayer, targetInterior)
					setCameraTarget(sourcePlayer, targetPlayer)
					setElementFrozen(sourcePlayer, true)
					setElementCollisionsEnabled(sourcePlayer, false)

					local spectatingPlayers = getElementData(targetPlayer, "spectatingPlayers") or {} -- lekérjük az új úrfi jelenlegi nézelődőit

					spectatingPlayers[sourcePlayer] = true -- hozzáadjuk az úrfi nézelődőihez a parancs használóját
					setElementData(targetPlayer, "spectatingPlayers", spectatingPlayers) -- elmentjük az úrfinak a változásokat

					setElementData(sourcePlayer, "spectateTarget", targetPlayer)

					local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")

					exports.seal_administration:showAdminLog("#4adfbf" .. adminNick .. " #ffffffelkezdte TV-zni #4adfbf" .. targetName .. " #ffffff-t.", 6)

					if getElementData(targetPlayer, "acc.adminLevel") >= 6 then
						showAdminMessageFor(targetPlayer, "ez a köcsög kukkol: #32b3ef" .. getElementData(sourcePlayer, "acc.adminNick"), 255, 255, 255)
					end
				end
			end
		end
	end
end)

addCommandHandler("gotopos",
	function(sourcePlayer, cmd, x, y, z)
	    if getElementData(sourcePlayer, "acc.adminLevel") > 5 then
		    setElementPosition(sourcePlayer, x, y, z)
	   end
	end
)