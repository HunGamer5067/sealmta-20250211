local coonection = exports.seal_database:getConnection()
local dutyTime = {}

addEventHandler("onResourceStop", getRootElement(),
	function(res)
		if res == getThisResource() then
			for k, v in pairs(dutyTime) do
				if isElement(k) then
					dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - v, getElementData(k, "char.accID"))
				end
			end
		end
	end)
addEventHandler("onResourceStart", getRootElement(),
	function(res)
		if res == getThisResource() then
			for k, v in pairs(getElementsByType("player")) do
				if getElementData(v, "adminDuty") == 1 then
					dutyTime[v] = getTickCount()
				end
			end
		end
	end)
addEventHandler("onElementDataChange", getRootElement(),
	function(data, oldval, newval)
		if data == "adminDuty" then
			if getElementData(source, "adminDuty") == 1 then
				dutyTime[source] = getTickCount()
			elseif dutyTime[source] then
				dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - dutyTime[source], getElementData(source, "char.accID"))
				dutyTime[source] = nil
			end
		end
	end)

--[[setTimer(function()
	for k, v in pairs(dutyTime) do
		if isElement(k) and v then
			local elapsedTime = getTickCount() - dutyTime[k]

			iprint(k, elapsedTime)

			dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - v, getElementData(k, "char.accID"))
			dutyTime[k] = getTickCount()
		end
	end
end, 5000, 0)]]

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		if dutyTime[source] then
			dbExec(connection, "UPDATE accounts SET adminDutyTime = adminDutyTime + ? WHERE accountID = ?", getTickCount() - dutyTime[source], getElementData(source, "char.accID"))
			dutyTime[source] = nil
		end
	end)

function getAdminStats(targetPlayer, forprint)
	local targetAdminName = getElementData(targetPlayer, "acc.adminNick")
	local adminDutyTime = getElementData(targetPlayer, "acc.adminDutyTime")
	local adminDutyData = adminDutyTime / 60000
	local adminDutyMinutes = math.floor(adminDutyData)

	outputChatBox("[SealMTA]: " .. targetAdminName .. " #ffffffadminDuty percei: #ff9600" .. adminDutyMinutes .. "#ffffff.", forprint, 255, 150, 0, true)
end

addCommandHandler("myastats",
	function(sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
				local targetPlayer = sourcePlayer
				if targetPlayer then
					setAdminDutyTime(targetPlayer)

					setTimer(getAdminStats, 100, 1, targetPlayer,targetPlayer)
				--end
			end
		end
	end
)

addCommandHandler("getadminstats",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (targetPlayer) then
				outputChatBox("[SealMTA]: #ffffff/" .. commandName .. " [ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					setAdminDutyTime(targetPlayer)

					setTimer(getAdminStats, 100, 1, targetPlayer, sourcePlayer)
				end
			end
		end
	end
)

addCommandHandler("resetadminstats",
	function(sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (targetPlayer) then
				outputChatBox("[SealMTA]: #ffffff/" .. commandName .. " [ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local targetAdminName = getElementData(targetPlayer, "acc.adminNick")
					outputChatBox("[SealMTA]: " .. targetAdminName .. "#ffffff adminDuty percei resetelve.", sourcePlayer, 255, 150, 0, true)

					setElementData(targetPlayer, "acc.adminDutyTime", 0)
					dbExec(connection, "UPDATE accounts SET adminDutyTime = 0 WHERE accountID = ?", getElementData(targetPlayer, "char.accID"))
				end
			end
		end
	end
)

function setAdminDutyTime(targetPlayer)
	dbQuery(
		function (qh)
			local result = dbPoll(qh, 0)

			if result then
				setElementData(targetPlayer, "acc.adminDutyTime", result[1].adminDutyTime)
			end
		end,
	connection, "SELECT adminDutyTime FROM accounts WHERE accountId = ?", getElementData(targetPlayer, "char.accID"))
end