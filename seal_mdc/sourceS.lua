local connection = false

function policeMessage(text)
	for k, v in pairs(getElementsByType("player")) do
		if exports.seal_groups:isPlayerOfficer(v) then
			outputChatBox("[SealMTA - Rendőrség]:#FFFFFF " .. text, v, 215, 89, 89, true)
		end
	end
end

local groups = {
	PD = 1,
	FBI = 4,
	SWAT = 2,
	NAV = 8,
}

local accounts = {} local wantedcars = {} local wantedpeople = {} local
punishedpeople = {}

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
		
		dbQuery(
				function (qh)
					local result = dbPoll(qh, 0, true)

					for k, v in ipairs(result[1][1]) do
						table.insert(accounts, v)
					end
					
				end, 
		connection, "SELECT * FROM mdc_accounts")

		dbQuery(
				function (qh)
					local result = dbPoll(qh, 0, true)

					for k, v in ipairs(result[1][1]) do
						table.insert(wantedcars, v)
					end

				end, 
		connection, "SELECT * FROM mdc_wantedcars ORDER BY id DESC")

		dbQuery(
				function (qh)
					local result = dbPoll(qh, 0, true)

					for k, v in ipairs(result[1][1]) do
						table.insert(wantedpeople, v)
					end

				end, 
		connection, "SELECT * FROM mdc_wantedpeople ORDER BY id DESC")

		dbQuery(
				function (qh)
					local result = dbPoll(qh, 0, true)

					for k, v in ipairs(result[1][1]) do
						table.insert(punishedpeople, v)
					end

				end, 
		connection, "SELECT * FROM mdc_punishedpeople ORDER BY id DESC")
		
		
	end)


addEvent("reportKill", true)
addEventHandler("reportKill", getRootElement(),
	function (vehicle, zoneName)
		if source == client and zoneName then
			local suspectName = "ismeretlen"
			local wantedReason = false

			if isElement(vehicle) then
				local plateText = getVehiclePlateText(vehicle)
				local reasons = {}

				if plateText then
					plateText = fixPlateText(plateText)

					for i = 1, #wantedcars do
						local dat = wantedcars[i]

						if dat and dat.plate == plateText then
							table.insert(reasons, dat.reason)
						end
					end
				end

				if #reasons > 0 then
					wantedReason = table.concat(reasons, "; ")
				end

				triggerClientEvent(getElementsByType("player"), "killAlertFromServer", source, suspectName, vehicle, false, wantedReason, zoneName)
			else
				local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
				local reasons = {}

				for i = 1, #wantedpeople do
					local dat = wantedpeople[i]

					if dat and dat.name == visibleName then
						suspectName = dat.name
						table.insert(reasons, dat.reason)
					end
				end

				if #reasons > 0 then
					wantedReason = table.concat(reasons, "; ")
				end

				triggerClientEvent(getElementsByType("player"), "killAlertFromServer", source, suspectName, vehicle, wantedReason, false, zoneName)
			end
		end
	end)

addEvent("reportGunShot", true)
addEventHandler("reportGunShot", getRootElement(),
	function (vehicle, zoneName)
		if source == client and zoneName then
			local suspectName = "ismeretlen"
			local wantedReason = false

			if isElement(vehicle) then
				local plateText = getVehiclePlateText(vehicle)
				local reasons = {}

				if plateText then
					plateText = fixPlateText(plateText)

					for i = 1, #wantedcars do
						local dat = wantedcars[i]

						if dat and dat.plate == plateText then
							table.insert(reasons, dat.reason)
						end
					end
				end

				if #reasons > 0 then
					wantedReason = table.concat(reasons, "; ")
				end

				triggerClientEvent(getElementsByType("player"), "shootAlertFromServer", source, suspectName, vehicle, false, wantedReason, zoneName)
			else
				local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
				local reasons = {}

				for i = 1, #wantedpeople do
					local dat = wantedpeople[i]

					if dat and dat.name == visibleName then
						suspectName = dat.name
						table.insert(reasons, dat.reason)
					end
				end

				if #reasons > 0 then
					wantedReason = table.concat(reasons, "; ")
				end

				triggerClientEvent(getElementsByType("player"), "shootAlertFromServer", source, suspectName, vehicle, wantedReason, false, zoneName)
			end
		end
	end)

function fixPlateText(plate)
	local plateSection = {}
	local plateTextTable = split(plate:upper(), "-")

	for i = 1, #plateTextTable do
		if utf8.len(plateTextTable[i]) > 0 then
			table.insert(plateSection, plateTextTable[i])
		end
	end

	return table.concat(plateSection, "-")
end

addEvent("checkMDC", true)
addEventHandler("checkMDC", getRootElement(),
	function (vehicle, cctv)
		--iprint(vehicle, client, source)
		if source == client and isElement(vehicle) then
			local plateText = getVehiclePlateText(vehicle)

			if plateText then
				plateText = fixPlateText(plateText)

				for i = 1, #wantedcars do
					local dat = wantedcars[i]

					if dat and dat.plate == plateText then
						triggerClientEvent(getElementsByType("player"), "mdcAlertFromServer", vehicle, plateText, cctv, dat.reason)
						break
					end
				end
			end
		end
	end)

function punishedPeopleCallback(qh, thePlayer)
	dbFree(qh)

	if isElement(thePlayer) then
		dbQuery(
			function (qh)
				local result, rows = dbPoll(qh, 0)

				punishedpeople = {}

				if result then
					for k, v in ipairs(result) do
						table.insert(punishedpeople, v)
					end

					triggerClientEvent(getElementsByType("player"), "onClientGotMDCPunishment", thePlayer, punishedpeople)
				end
			end,
		connection, "SELECT * FROM mdc_punishedpeople ORDER BY id DESC")
	end
end

addEvent("addPunishment", true)
addEventHandler("addPunishment", getRootElement(),
	function (name, ticket, jail, reason)
		if source == client and ticket and jail and reason then
			dbQuery(punishedPeopleCallback, {client}, connection, "INSERT INTO mdc_punishedpeople (name, ticket, jail, reason) VALUES (?,?,?,?)", name:gsub("_", " "), ticket, jail, reason)
		end
	end)

addEvent("delPunishment", true)
addEventHandler("delPunishment", getRootElement(),
	function (id)
		if source == client and id then
			dbQuery(punishedPeopleCallback, {client}, connection, "DELETE FROM mdc_punishedpeople WHERE id = ?", id)
		end
	end)

function wWantedPeopleCallback(qh, thePlayer)
	dbFree(qh)

	if isElement(thePlayer) then
		dbQuery(
			function (qh)
				local result, rows = dbPoll(qh, 0)

				wantedpeople = {}

				if result then
					for k, v in ipairs(result) do
						table.insert(wantedpeople, v)
					end

					triggerClientEvent(getElementsByType("player"), "onClientGotMDCPeople", thePlayer, wantedpeople)
				end
			end,
		connection, "SELECT * FROM mdc_wantedpeople ORDER BY id DESC")
	end
end

addEvent("addReportPerson", true)
addEventHandler("addReportPerson", getRootElement(),
	function (name, reason, visual)
		if source == client and name and reason and visual then
			dbQuery(wWantedPeopleCallback, {client}, connection, "INSERT INTO mdc_wantedpeople (name, reason, description) VALUES (?,?,?)", name:gsub("_", " "), reason, visual)
			exports.seal_logs:logCommand(client, "addmdcperson", {name, reason, visual})
		end
	end)

addEvent("delReportPerson", true)
addEventHandler("delReportPerson", getRootElement(),
	function (id)
		if source == client and id then
			local personName = false

			for i = 1, #wantedpeople do
				local dat = wantedpeople[i]
				
				if dat.id == id then
					personName = dat.name
					break
				end
			end

			if personName then
				exports.seal_logs:logCommand(client, "delmdcperson", {personName, id, "csoport" .. tostring(exports.seal_groups:isPlayerOfficer(client))})
				dbQuery(wWantedPeopleCallback, {client}, connection, "DELETE FROM mdc_wantedpeople WHERE id = ?", id)
			end
		end
	end)

local backupBlips = {}

function sendNearbyMessage(sourcePlayer, message)
    if sourcePlayer and message and isElement(sourcePlayer) then
        local affectedPlayers = {}

        local sourceName = getPlayerName(sourcePlayer):gsub("_", " ")
        local sourceX, sourceY, sourceZ = getElementPosition(sourcePlayer)
        local availablePlayers = getElementsByType("player")
        
        for key, value in pairs(availablePlayers) do
            local playerX, playerY, playerZ = getElementPosition(value)
            local distanceBetweenSource = getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, playerX, playerY, playerZ)
            
            if distanceBetweenSource <= 10 then
                table.insert(affectedPlayers, value)
            end
        end

        if #affectedPlayers > 0 then
            for i = 1, #affectedPlayers do
                outputChatBox("#C2A2DA*** " .. sourceName.. " #C2A2DA" .. message, affectedPlayers[i], 194, 162, 218, true)
            end
        end
    end
end

addCommandHandler("backup",
    function (sourcePlayer, commandName, ...)
        local sourceName = getPlayerName(sourcePlayer):gsub("_", " ")
        local availablePlayers = getElementsByType("player")

        local isOfficer = exports.seal_groups:isPlayerOfficer(sourcePlayer) or false
        local backupReason = false

		if not (...) then
			backupReason = "Nincs indok"
		else
			backupReason = table.concat({...}, " ")
		end

        if isOfficer then
            local hasBackupBlip = backupBlips[sourcePlayer] or false

            if hasBackupBlip then
                backupBlips[sourcePlayer] = nil

                policeMessage(sourceName .. " lemondta az erősítést!")
                sendNearbyMessage(sourcePlayer, "lemondta az erősítést.")

				triggerClientEvent("createBlipForOfficers", root, sourcePlayer)
                return
            end

            if not backupReason then
                backupReason = "Nincs indok"
            end

            policeMessage(sourceName .. " erősítést hívott! (" .. backupReason .. ")")
            sendNearbyMessage(sourcePlayer, "erősítést hívott.")
			backupBlips[sourcePlayer] = true

			triggerClientEvent("createBlipForOfficers", root, sourcePlayer, backupReason)
        end
    end
)

-- addCommandHandler("backup",
-- 	function(sourcePlayer, commandName, ...)
-- 		local reason = table.concat({...}, " ")
-- 		if exports.seal_groups:isPlayerOfficer(sourcePlayer) then
-- 			if backupBlips[sourcePlayer] then
-- 				triggerClientEvent("createBlipForOfficers", root, sourcePlayer)
-- 				backupBlips[sourcePlayer] = nil
-- 				policeMessage(getPlayerName(sourcePlayer):gsub("_", " ").." lemondta az erősítést!")
-- 				triggerClientEvent("destroyBlipMessage", sourcePlayer, sourcePlayer)
-- 			else
-- 				if reason then
-- 					local x, y, z = getElementPosition(sourcePlayer)
-- 					backupBlips[sourcePlayer] = true
-- 					triggerClientEvent("createBlipForOfficers", root, sourcePlayer, reason)
-- 					policeMessage(getPlayerName(sourcePlayer):gsub("_", " ").." erősítést hívott! ("..reason..")")
-- 					triggerClientEvent("createBlipMessage", sourcePlayer, sourcePlayer)
-- 				end
-- 			end
-- 		end
-- 	end
-- )

--[[
addEvent("requestVehicleDatas", true)
addEventHandler("requestVehicleDatas", resourceRoot,
	function (vehiclePlate)
		if source ~= client and vehiclePlate then
			if exports.seal_groups:isPlayerOfficer(client) then
				local element = client

				dbQuery(
					function (qh)
						local result = dbPoll(qh, 0)

						if #result > 0 then
							triggerClientEvent(element, "gotVehicleDatas", resourceRoot, result[1])
						else
							triggerClientEvent(element, "gotVehicleDatas", resourceRoot, "Ilyen rendszámmal nem található jármű.")
						end
					end, connection, "SELECT * FROM vehicles WHERE plateText = ?", vehiclePlate
				)
			else
				triggerClientEvent(element, "gotVehicleDatas", resourceRoot, "Nincs jogosultságod használni ezt a funkciót!")
			end
		end
	end
)

function findVehicleById(vehicleId)
	local vehicleElement = false
	local vehicleElements = getElementsByType("vehicle")

	for k, v in pairs(vehicleElements) do
		if getElementData(v, "vehicle.dbID") == vehicleId and not vehicleElement then
			vehicleElement = v
		end
	end

	return vehicleElement
end]]

addEventHandler("onClientElementDestroy", getRootElement(),
	function()
		if backupBlips[sourcePlayer] then
			if isElement(backupBlips[sourcePlayer]) then
				destroyElement(backupBlips[sourcePlayer])
			end
			backupBlips[sourcePlayer] = nil
		end
	end
)

addEvent("editReportPerson", true)
addEventHandler("editReportPerson", getRootElement(),
	function (id, name, reason, visual)
		if source == client and id and name and reason and visual then
			dbQuery(wWantedPeopleCallback, {client}, connection, "UPDATE mdc_wantedpeople SET name = ?, reason = ?, description = ? WHERE id = ?", name:gsub("_", " "), reason, visual, id)
			exports.seal_logs:logCommand(client, "editmdcperson", {id, name, reason, visual})
		end
	end)

function wantedCarsCallback(qh, thePlayer)
	dbFree(qh)

	if isElement(thePlayer) then
		dbQuery(
			function (qh)
				local result, rows = dbPoll(qh, 0)

				wantedcars = {}

				if result then
					for k, v in ipairs(result) do
						table.insert(wantedcars, v)
					end

					triggerClientEvent(getElementsByType("player"), "onClientGotMDCVehicles", thePlayer, wantedcars)
				end
			end,
		connection, "SELECT * FROM mdc_wantedcars ORDER BY id DESC")
	end
end

addEvent("addReportVehicle", true)
addEventHandler("addReportVehicle", getRootElement(),
	function (vehtype, plate, reason)
		if source == client and vehtype and plate and reason then
			dbQuery(wantedCarsCallback, {client}, connection, "INSERT INTO mdc_wantedcars (type, plate, reason) VALUES (?,?,?)", vehtype, fixPlateText(plate), reason)
			exports.seal_logs:logCommand(client, "addmdcvehicle", {fixPlateText(plate), reason})
		end
	end)

addEvent("delReportVehicle", true)
addEventHandler("delReportVehicle", getRootElement(),
	function (id, plate)
		if source == client and id and plate then
			local plateText = false

			for i = 1, #wantedcars do
				local dat = wantedcars[i]

				if dat.id == id then
					plateText = dat.plate
					break
				end
			end

			if plateText then
				exports.seal_logs:logCommand(client, "delmdcvehicle", {plateText, id, "csoport" .. tostring(exports.seal_groups:isPlayerOfficer(client))})
				dbQuery(wantedCarsCallback, {client}, connection, "DELETE FROM mdc_wantedcars WHERE id = ?", id)
			end
		end
	end)

addEvent("editReportVehicle", true)
addEventHandler("editReportVehicle", getRootElement(),
	function (id, vehtype, plate, reason)
		if source == client and id and vehtype and plate and reason then
			dbQuery(wantedCarsCallback, {client}, connection, "UPDATE mdc_wantedcars SET type = ?, plate = ?, reason = ? WHERE id = ?", vehtype, fixPlateText(plate), reason, id)
			exports.seal_logs:logCommand(client, "editmdcvehicle", {id, fixPlateText(plate), reason})
		end
	end)

addEvent("tryToLoginMDC", true)
addEventHandler("tryToLoginMDC", getRootElement(),
	function (username, password)
		--print(password)
		if source == client and username and password then
			local account = false

			for k, v in pairs(accounts) do
				if v.username == username and v.password == password then
					account = v
					break
				end
			end

			if account then
				triggerClientEvent(client, "onClientGotMDCData", client, account.leader)
				triggerClientEvent(client, "onClientGotMDCVehicles", client, wantedcars)
				triggerClientEvent(client, "onClientGotMDCPeople", client, wantedpeople)
				triggerClientEvent(client, "onClientGotMDCPunishment", client, punishedpeople)
			else
				exports.seal_accounts:showInfo(client, "e", "Nincs ilyen felhasználónév/jelszó kombináció!")
			end
		end
	end)

addCommandHandler("addmdcacc",
	function (sourcePlayer, commandName, groupId, username, password, leader)
		if not groups[groupId] then
			groupId = false
		end

		leader = tonumber(leader) or 0

		if not (groupId and username and password) then
			if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
				outputChatBox("#ea7212[Használat]: #ffffff/" .. commandName .. " [Csoport Azonosító] [Felhasználónév] [Jelszó] [Leader fiók (0 = nem | 1 = igen)]", sourcePlayer, 0, 0, 0, true)
			else
				outputChatBox("#ea7212[Használat]: #ffffff/" .. commandName .. " [Csoport Azonosító] [Felhasználónév] [Jelszó]", sourcePlayer, 0, 0, 0, true)
			end
			outputChatBox("#ea7212[Elérhető csoportok]: #ffffffPD -> ORFK | SWAT -> TEK | SD -> NAV | FBI -> Nemzeti Nyomozó Iroda", sourcePlayer, 0, 0, 0, true)
		else
			if exports.seal_groups:isPlayerLeaderInGroup(sourcePlayer, groups[groupId]) or getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
				local found = false

				for k, v in pairs(accounts) do
					if v.username == username then
						found = true
						break
					end
				end

				if not found then
					if leader < 0 or leader > 1 then
						leader = 0
					end

					outputChatBox("#4adfbf[SealMTA - MDC]: #ffffffSikeresen létrehoztad az MDC fiókot. #32b3ef(" .. username .. ")", sourcePlayer, 0, 0, 0, true)

					dbExec(connection, "INSERT INTO mdc_accounts (username, password, leader) VALUES (?,?,?)", username, sha256(password), leader)
					accounts = {}
					dbQuery(
						function (qh)
							local result = dbPoll(qh, 0, true)

							for k, v in ipairs(result[1][1]) do
								table.insert(accounts, v)
							end
							
						end, 
				connection, "SELECT * FROM mdc_accounts")
				else
					outputChatBox("#d75959[SealMTA - MDC]: #ffffffA kiválasztott felhasználónév foglalt!", sourcePlayer, 0, 0, 0, true)
				end
			else
				outputChatBox("#d75959[SealMTA - MDC]: #ffffffNincs jogosultságod ilyen fiókot létrehozni!", sourcePlayer, 0, 0, 0, true)
			end
		end
	end)

addCommandHandler("delmdcacc",
	function (sourcePlayer, commandName, username)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not username then
				outputChatBox("#ea7212[Használat]: #ffffff/" .. commandName .. " [Felhasználónév]", sourcePlayer, 0, 0, 0, true)
			else
				local accountId = false

				for k, v in pairs(accounts) do
					if v.username == username then
						accountId = k
						break
					end
				end

				if accountId then
					accounts[accountId] = nil

					outputChatBox("#4adfbf[SealMTA - MDC]: #ffffffSikeresen törölted az MDC fiókot. #32b3ef(" .. username .. ")", sourcePlayer, 0, 0, 0, true)

					dbExec(connection, "DELETE FROM mdc_accounts WHERE accountId = ?", accountId)
				else
					outputChatBox("#d75959[SealMTA - MDC]: #ffffffA kiválasztott felhasználó nem létezik!", sourcePlayer, 0, 0, 0, true)
				end
			end
		end
	end)

addCommandHandler("setmdcpass",
	function (sourcePlayer, commandName, username, password)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			if not (username and password) then
				outputChatBox("#ea7212[Használat]: #ffffff/" .. commandName .. " [Felhasználónév] [Új jelszó]", sourcePlayer, 0, 0, 0, true)
			else
				local accountId = false

				for k, v in pairs(accounts) do
					if v.username == username then
						accountId = k
						break
					end
				end

				if accountId then
					password = sha256(password)
					accounts[accountId].password = password

					outputChatBox("#4adfbf[SealMTA - MDC]: #ffffffSikeresen módosítottad az MDC fiók jelszavát. #32b3ef(" .. username .. ")", sourcePlayer, 0, 0, 0, true)

					dbExec(connection, "UPDATE mdc_accounts SET password = ? WHERE accountId = ?", password, accountId)
				else
					outputChatBox("#d75959[SealMTA - MDC]: #ffffffA kiválasztott felhasználó nem létezik!", sourcePlayer, 0, 0, 0, true)
				end
			end
		end
	end)

addEventHandler("onPlayerQuit", getRootElement(),
	function()
		triggerClientEvent(getRootElement(), "destoryBackupBlips", source)
	end
)

local exitTimers = {}

addEventHandler("onPlayerVehicleExit", root,
	function (vehicle, seat)
		if isElement(vehicle) and seat == 0 then
			if isTimer(exitTimers[vehicle]) then
				killTimer(exitTimers[vehicle])
			end

			timer = setTimer(
				function ()
					local vehicleElement = vehicle
					
					if isElement(vehicleElement) then
						triggerClientEvent(root, "destroyBlips", root, vehicleElement)
					end
				end, 60000 * 5, 1
			)
			
			exitTimers[vehicle] = timer
		end
	end
)