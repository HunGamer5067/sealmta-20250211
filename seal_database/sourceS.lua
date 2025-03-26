local connection = false
local sqlDatas = {
	["host"] = "localhost",
	["user"] = "root",
	["pw"] = "m9oRO3SGD7YhrNe9QT7k6",
	["database"] = "sealmta",
}

addEvent("onDatabaseConnected", true)
addEvent("onQueryReady", true)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = dbConnect("mysql", "dbname=".. sqlDatas["database"] ..";host="..sqlDatas["host"], sqlDatas["user"], sqlDatas["pw"], "autoreconnect=1")
		
		if not connection then
			cancelEvent()
		else
			dbExec(connection, "SET NAMES utf8")
		end

		if isElement(connection) then
			triggerEvent("onDatabaseConnected", root, connection)
		end
	end
)

addEventHandler("onResourceStop", getResourceRootElement(),
	function ()
		local playersTable = getElementsByType("player")

		for i = 1, #playersTable do
			local playerElement = playersTable[i]

			if playerElement then
				savePlayer(playerElement, true)
			end
		end

		local vehiclesTable = getElementsByType("vehicle")

		for i = 1, #vehiclesTable do
			local vehicleElement = vehiclesTable[i]

			if vehicleElement then
				saveVehicle(vehicleElement)
			end
		end

		outputDebugString("Database disconnected.")
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		savePlayer(source, true, true)
	end,
true, "high+999")

addCommandHandler("saveme",
	function (player, cmd, target)
		if getElementData(player, "acc.adminLevel") == 11 then
			if target then
				sourcePlayer, _ = exports.seal_core:findPlayer(player, target)
			else
				sourcePlayer = player
			end
			if savePlayer(sourcePlayer, true, true) then
				outputDebugString("Character saved.")
			else
				outputDebugString("Character saving failed.")
			end
		end
	end
)

function getConnection()
	return connection
end

function dbInsert(tableName, insertValues)
	if tableName and insertValues and type(insertValues) == "table" then
		local columns = {}
		local values = {}

		for column, value in pairs(insertValues) do
			table.insert(columns, column)
			table.insert(values, value)
		end

		local paramString = ("?,"):rep(#columns):sub(1, -2)
		local queryString = dbPrepareString(connection, "INSERT INTO ?? (" .. table.concat(columns, ",") .. ") VALUES (" .. paramString .. ");", tableName, unpack(values))

		return dbExec(connection, queryString)
	end

	return false
end

function dbUpdate(tableName, setFields, whereFields)
	if tableName and setFields and type(setFields) == "table" and whereFields and type(whereFields) == "table" then
		local columns = {}
		local values = {}
		local wheres = {}

		for column, value in pairs(setFields) do
			if string.sub(value, 0, 1) == "%" and string.sub(value, string.len(value)) == "%" then -- speciális esetek, pl. %NULL% vagy %CURRENT_TIMESTAMP%
				table.insert(columns, string.format("`%s`=%s", column, string.gsub(value, "%%", "")))
			else
				table.insert(columns, string.format("`%s`=?", column))
				table.insert(values, value)
			end
		end

		for column, value in pairs(whereFields) do
			table.insert(wheres, string.format("`%s`=?", column))
			table.insert(values, value)
		end

		local queryString = dbPrepareString(connection, "UPDATE ?? SET " .. table.concat(columns, ", ") .. " WHERE " .. table.concat(wheres, " AND ") .. ";", tableName, unpack(values))

		--iprint(queryString)
		return dbExec(connection, queryString)
	end

	return false
end

function dbSelect(queryIdentifier, tableName, selectFields, whereFields)
	if not (queryIdentifier and tableName) then
		return
	end

	selectFields = selectFields or "*"

	if type(selectFields) == "table" then
		selectFields = table.concat(selectFields, ", ")
	end

	local queryString = "SELECT " .. selectFields .. " FROM ??"
	local queryValues = {}

	if type(whereFields) == "table" then
		local wheres = {}

		for column, value in pairs(whereFields) do
			table.insert(wheres, string.format("`%s`=?", column))
			table.insert(queryValues, value)
		end

		queryString = queryString .. " WHERE " .. table.concat(wheres, " AND ")
	end

	dbQuery(connection,
		function (qHandle)
			triggerEvent("onQueryReady", root, queryIdentifier, dbPoll(qHandle, 0))
		end,
	queryString, tableName, unpack(queryValues))
end

function savePlayer(sourcePlayer, loggedOut, containsVehicles)
	if not sourcePlayer then
		sourcePlayer = source
	end
	if client and not source == client then
		return
	end

	if getElementData(sourcePlayer, "loggedIn") then
		local accountId = getElementData(sourcePlayer, "char.accID")
		local characterId = getElementData(sourcePlayer, "char.ID")

		if accountId and characterId then
			-- ** Alap adatok
			local interior = getElementInterior(sourcePlayer)
			local dimension = getElementDimension(sourcePlayer)
			if getElementData(sourcePlayer, "playerInClientsideJobInterior") then
				interior = 0
				dimension = 0
				playerX, playerY, playerZ = unpack(getElementData(sourcePlayer, "playerInClientsideJobInterior"))
			else
 				playerX, playerY, playerZ = getElementPosition(sourcePlayer)
			end

			--[[if getElementData(sourcePlayer, "activeTuningMarker") then
				playerX, playerY, playerZ = 1366.9074707031, -1791.7083740234, 13.499659538269
				interior = 0
				dimension = 0
			end]]

			local datas = {
				["posX"] = playerX,
				["posY"] = playerY,
				["posZ"] = playerZ,
				["rotZ"] = getPedRotation(sourcePlayer),
				["interior"] = interior,
				["dimension"] = dimension,
				["skin"] = getElementModel(sourcePlayer),
				["health"] = getElementHealth(sourcePlayer),
				["armor"] = getPedArmor(sourcePlayer),
				["hunger"] = getElementData(sourcePlayer, "char.Hunger") or 100,
				["description"] = getElementData(sourcePlayer, "char.Description") or "",
				["thirst"] = getElementData(sourcePlayer, "char.Thirst") or 100,
				["money"] = getElementData(sourcePlayer, "char.Money") or 0,
				["bankMoney"] = getElementData(sourcePlayer, "char.bankMoney") or 0,
				["playTimeForPayday"] = getElementData(sourcePlayer, "char.playTimeForPayday") or 60,
				["slotCoins"] = getElementData(sourcePlayer, "char.slotCoins") or 0,
				["playedMinutes"] = getElementData(sourcePlayer, "char.playedMinutes") or 0,
				["isPlayerDeath"] = getElementData(sourcePlayer, "isPlayerDeath") and 1 or 0,
				["job"] = getElementData(sourcePlayer, "char.Job") or 0,
				["radio"] = getElementData(sourcePlayer, "char.Radio") or 0,
				["radio2"] = getElementData(sourcePlayer, "char.Radio2") or 0,
				["paintOnPlayerTime"] = getElementData(sourcePlayer, "paintOnPlayerTime") or 0,
				["bulletDamages"] = toJSON((getElementData(sourcePlayer, "bulletDamages") or {})) or toJSON({})
			}

			if loggedOut then
				datas["lastOnline"] = "%CURRENT_TIMESTAMP%"
			end

			datas["springs"] = getElementData(sourcePlayer, "char.springs") or 0

			-- ** Frakciók
			local playerGroups = getElementData(sourcePlayer, "player.groups") or {}
			local groupsTable = {}

			for k, v in pairs(playerGroups) do
				table.insert(groupsTable, {
					["groupId"] = k,
					["data"] = v
				})
			end

			datas["groups"] = toJSON(groupsTable, true)
			datas["inDuty"] = getElementData(sourcePlayer, "inDuty") or 0

			if datas["inDuty"] ~= 0 then
				datas["skin"] = getElementData(sourcePlayer, "char.Skin") or 0
			end

			-- ** Actionbar itemek
			local actionBarItemsTable = getElementData(sourcePlayer, "actionBarItems") or {}
			datas["actionBarItems"] = {}

			for i = 1, 6 do
				if actionBarItemsTable[i] then
					table.insert(datas["actionBarItems"], tostring(actionBarItemsTable[i]))
				else
					table.insert(datas["actionBarItems"], "-")
				end
			end

			datas["actionBarItems"] = table.concat(datas["actionBarItems"], ";")

			local colletedRewards = getElementData(sourcePlayer, "colletedRewards") or {}
			datas["colletedRewards"] = toJSON(colletedRewards)

			local completedRewards = getElementData(sourcePlayer, "completedRewards") or {}
			datas["completedRewards"] = toJSON(completedRewards)

			-- ** Karakter mentése
			dbUpdate("characters", datas, {characterId = characterId})

			if not loggedOut then
				dbExec(connection, "UPDATE accounts SET online = 1 WHERE accountId = ?", accountId)
			else
				dbExec(connection, "UPDATE accounts SET online = 0 WHERE accountId = ?", accountId)
			end

			-- ** Járművek mentése
			if loggedOut and containsVehicles then
				local vehiclesTable = getElementsByType("vehicle")

				for i = 1, #vehiclesTable do
					local vehicleElement = vehiclesTable[i]

					if isElement(vehicleElement) then
						if getElementData(vehicleElement, "vehicle.owner") == characterId then
							local groupId = getElementData(vehicleElement, "vehicle.group") or 0
							local isProtected = getElementData(vehicleElement, "vehicle.protect") or 0
							
							if saveVehicle(vehicleElement) then
								if groupId == 0 and isProtected == 0 then
									destroyElement(vehicleElement)
								end
							end
						end
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
addEvent("autoSavePlayer", true)
addEventHandler("autoSavePlayer", getRootElement(), savePlayer)

function saveVehicle(sourceVehicle)
	local vehicleId = getElementData(sourceVehicle, "vehicle.dbID")

	if vehicleId then
		-- ** Adatok összegyűjtése
		local model = getElementModel(sourceVehicle)
		local datas = {
			["last_position"] = table.concat({getElementPosition(sourceVehicle)}, ","),
			["last_rotation"] = table.concat({getElementRotation(sourceVehicle)}, ","),
			["last_interior"] = getElementInterior(sourceVehicle),
			["last_dimension"] = getElementDimension(sourceVehicle),
			["health"] = getElementHealth(sourceVehicle),
			["fuel"] = getElementData(sourceVehicle, "vehicle.fuel") or exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(model),
			["engine"] = getElementData(sourceVehicle, "vehicle.engine") or 0,
			["customId"] = getElementData(sourceVehicle, "vehicle.customId") or 0,
			["lights"] = getElementData(sourceVehicle, "vehicle.lights") or 0,
			["locked"] = getElementData(sourceVehicle, "vehicle.locked") or 0,
			["handBrake"] = getElementData(sourceVehicle, "vehicle.handBrake") and 1 or 0,
			["distance"] = getElementData(sourceVehicle, "vehicle.distance") or 0,
			["tuningNitroLevel"] = getElementData(sourceVehicle, "vehicle.nitroLevel") or 0,
			["nitroState"] = getElementData(sourceVehicle, "vehicle.nitroState") or 0,
			["gpsNavigation"] = getElementData(sourceVehicle, "vehicle.GPS") or 0,
			["activeDriveType"] = getElementData(sourceVehicle, "activeDriveType") or "",
			["wheelStates"] = table.concat({getVehicleWheelStates(sourceVehicle)}, "/"),
			["tuningEngine"] = (getElementData(sourceVehicle, "vehicle.tuning.Engine")) or 0,
			["tuningTurbo"] = (getElementData(sourceVehicle, "vehicle.tuning.Turbo")) or 0,
			["tuningECU"] = (getElementData(sourceVehicle, "vehicle.tuning.ECU")) or 0,
			["tuningTransmission"] = (getElementData(sourceVehicle, "vehicle.tuning.Transmission")) or 0,
			["tuningSuspension"] = (getElementData(sourceVehicle, "vehicle.tuning.Suspension")) or 0,
			["tuningBrakes"] = (getElementData(sourceVehicle, "vehicle.tuning.Brakes")) or 0,
			["tuningTires"] = (getElementData(sourceVehicle, "vehicle.tuning.Tires")) or 0,
			["tuningWeightReduction"] = (getElementData(sourceVehicle, "vehicle.tuning.WeightReduction")) or 0,
			["tuningOptical"] = (getElementData(sourceVehicle, "vehicle.tuning.Optical")) or "",
			["backFire"] = (getElementData(sourceVehicle, "vehicle.backfire")) or 0,
			["protected"] = (getElementData(sourceVehicle, "vehicle.protect")) or 0,
			["driveSelector"] = (getElementData(sourceVehicle, "vehicle.driveSelector")) or 0,
			["lightBridge"] = (getElementData(sourceVehicle, "lightBridge")) or 0,
			["tuningPaintjob"] = (getElementData(sourceVehicle, "vehicle.tuning.Paintjob")) or 0,
		}

		local panelStatesTable = {}
		local doorStatesTable = {}

		for i = 0, 6 do
			table.insert(panelStatesTable, getVehiclePanelState(sourceVehicle, i))

			if i < 6 then
				table.insert(doorStatesTable, getVehicleDoorState(sourceVehicle, i))
			end
		end
		
		datas["panelStates"] = table.concat(panelStatesTable, "/")
		datas["doorStates"] = table.concat(doorStatesTable, "/")

		local speedoColor = getElementData(sourceVehicle, "vehicle.speedoColor") or {255, 255, 255}
		local speedoColor2 = getElementData(sourceVehicle, "vehicle.speedoColor2") or {255, 255, 255}

		for i = 1, 3 do
			if speedoColor[i] > 255 then
				speedoColor[i] = 255
			end
			if speedoColor2[i] > 255 then
				speedoColor2[i] = 255
			end
		end
		datas["speedoColor"] = table.concat({rgbToHex(unpack(speedoColor)), rgbToHex(unpack(speedoColor2))}, ";")
	
		local backfire = getElementData(sourceVehicle, "vehicle.backfire") or 0
		if backfire == 2 then
			local customBackfire = getElementData(sourceVehicle, "vehicle.customBackfire") or false

			if customBackfire then
				datas["customBackfire"] = toJSON(customBackfire)
			end
		end

		local customTurboDatas = getElementData(sourceVehicle, "vehicle.tuning.customTurbo") or {}
		datas["customTurbo"] = getElementData(sourceVehicle, "vehicle.customTurbo") or 0
		datas["customTurboDatas"] = toJSON(customTurboDatas)

		local customFrontWheelDatas = getElementData(sourceVehicle, "vehicle.tuning.wheelsFront") or {id = 0, width = 1, angle = 0, color = {255, 255, 255}, offset = 0}
		local customBackWheelDatas = getElementData(sourceVehicle, "vehicle.tuning.wheelsBack") or {id = 0, width = 1, angle = 0, color = {255, 255, 255}, offset = 0}

		if customFrontWheelDatas and customBackWheelDatas then
			local wheelDatas = {}
			wheelDatas.front = customFrontWheelDatas
			wheelDatas.back = customBackWheelDatas
			datas["customWheel"] = toJSON(wheelDatas)
		end

		local customComponents = getElementData(sourceVehicle, "vehicle.modifiedComponents") or {bonnet_dummy = true, boot_dummy = true, bump_front_dummy = true, bump_rear_dummy = true}
		datas["customComponents"] = toJSON(customComponents)

		-- ** Elmentés
		dbUpdate("vehicles", datas, {vehicleId = vehicleId})

		return true
	else
		return false
	end
end

function rgbToHex(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end

	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

function hexToRgb(color)
	if color and string.len(color) > 0 then
		color = color:gsub("#", "")
		return tonumber("0x" .. color:sub(1, 2)), tonumber("0x" .. color:sub(3, 4)), tonumber("0x" .. color:sub(5, 6))
	else
		return 255, 255, 255
	end
end

function validHexColor(color)
	return color:match("^%x%x%x%x%x%x$")
end

setTimer(
	function()
		for k, v in pairs(getElementsByType("player")) do
			savePlayer(v, false, false)
		end
	end, 60000 * 5, 0
)