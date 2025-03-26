storedSafes = {}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		dbQuery(loadAllSafe, connection, "SELECT * FROM safes")
	end)

addEvent("requestSafes", true)
addEventHandler("requestSafes", getRootElement(),
	function ()
		if isElement(source) then
			triggerLatentClientEvent(source, "receiveSafes", source, storedSafes)
		end
	end)

addCommandHandler("movesafe",
	function (sourcePlayer, commandName, safeId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			safeId = tonumber(safeId)

			if not safeId then
				outputChatBox("#ea7212[Használat]: #FFFFFF/" .. commandName .. " [Azonosító]", sourcePlayer, 255, 255, 255, true)
			else
				local data = storedSafes[safeId]

				if data then
					local x, y, z = getElementPosition(sourcePlayer)
					local rz = select(3, getElementRotation(sourcePlayer))
					local int = getElementInterior(sourcePlayer)
					local dim = getElementDimension(sourcePlayer)

					if data.safeSize == 1 then
						objectId = 2332
						posZ = 0
					elseif data.safeSize == 2 then
						objectId = 11424
						posZ = 0.1
					elseif data.safeSize == 3 then
						objectId = 9249
						posZ = 0.4
					end

					z = z - 0.55 + posZ
					rz = (rz + 180) % 360

					data.posX, data.posY, data.posZ, data.rotZ = x, y, z, rz
					data.interior, data.dimension = int, dim

					setElementModel(data.objectElement, objectId)
					setElementPosition(data.objectElement, x, y, z)
					setElementRotation(data.objectElement, 0, 0, rz)
					setElementInterior(data.objectElement, int)
					setElementDimension(data.objectElement, dim)

					triggerClientEvent(getElementsByType("player"), "updateSafe", resourceRoot, safeId, data)

					exports.seal_accounts:showInfo(sourcePlayer, "s", "A kiválasztott széf sikeresen áthelyezésre került.")

					dbExec(connection, "UPDATE safes SET posX = ?, posY = ?, posZ = ?, rotZ = ?, interior = ?, dimension = ? WHERE dbID = ?", x, y, z, rz, int, dim, safeId)
				else
					outputChatBox("#DC143C[SealMTA]: #FFFFFFA kiválasztott széf nem található.", sourcePlayer, 255, 255, 255, true)
				end
			end
		end
	end)

addEvent("moveSafeFurniture", true)
addEventHandler("moveSafeFurniture", getRootElement(),
	function (safeId, x, y, z, rz, int, dim)
		if isElement(source) then
			if x and y and z and rz then
				local data = storedSafes[safeId]

				if data then
					if not int then
						int = getElementInterior(data.objectElement)
					end

					if not dim then
						dim = getElementDimension(data.objectElement)
					end

					data.posX, data.posY, data.posZ, data.rotZ = x, y, z, rz
					data.interior, data.dimension = int, dim

					setElementPosition(data.objectElement, x, y, z)
					setElementRotation(data.objectElement, 0, 0, rz)
					setElementInterior(data.objectElement, int)
					setElementDimension(data.objectElement, dim)

					triggerClientEvent(getElementsByType("player"), "updateSafe", resourceRoot, safeId, data)

					exports.seal_accounts:showInfo(source, "s", "A kiválasztott széf sikeresen áthelyezésre került.")

					dbExec(connection, "UPDATE safes SET posX = ?, posY = ?, posZ = ?, rotZ = ?, interior = ?, dimension = ? WHERE dbID = ?", x, y, z, rz, int, dim, safeId)
				end
			end
		end
	end)

addEvent("createSafe", true)
addEventHandler("createSafe", getRootElement(),
	function (ownerGroup, x, y, z, rz, int, dim, safeSize)
		if isElement(source) then
			ownerGroup = tonumber(ownerGroup)
			
			if ownerGroup and x and y and z and rz and int and dim then
				dbExec(connection, "INSERT INTO safes (posX, posY, posZ, rotZ, interior, dimension, ownerGroup, safeSize) VALUES (?,?,?,?,?,?,?,?)", x, y, z, rz, int, dim, ownerGroup, safeSize)
				dbQuery(
					function (qh, sourcePlayer)
						local result = dbPoll(qh, 0)[1]

						if result then
							loadSafe(result.dbID, result, true)
							giveItem(sourcePlayer, 154, 1, false, result.dbID)
							exports.seal_accounts:showInfo(sourcePlayer, "s", "Széf sikeresen létrehozva! ID: " .. result.dbID)
						end
					end, {source},
				connection, "SELECT * FROM safes WHERE dbID = LAST_INSERT_ID()")
			end
		end
	end)

addEvent("destroySafe", true)
addEventHandler("destroySafe", getRootElement(),
	function (safeId, sourcePlayer)
		if isElement(source) then
			safeId = tonumber(safeId)

			if safeId then
				dbExec(connection, "DELETE FROM safes WHERE dbID = ?", safeId)

				if isElement(storedSafes[safeId].objectElement) then
					destroyElement(storedSafes[safeId].objectElement)
				end

				storedSafes[safeId] = nil

				triggerClientEvent(getElementsByType("player"), "destroySafe", resourceRoot, safeId)

				outputChatBox("#3d7abc[SealMTA]: #ffffffA széf sikeresen törölve.", source, 0, 0, 0, true)
			end
		end
	end)

function loadAllSafe(qh)
	local result = dbPoll(qh, 0)

	if result then
		for k, v in pairs(result) do
			loadSafe(v.dbID, v)
		end
	end
end

function loadSafe(safeId, data, sync)
	if tonumber(safeId) and type(data) == "table" then
		storedSafes[safeId] = data

		if storedSafes[safeId].safeSize == 1 then
			objectId = 2332
			posZ = 0
		elseif storedSafes[safeId].safeSize == 2 then
			objectId = 11424
			posZ = 0.1
		elseif storedSafes[safeId].safeSize == 3 then
			objectId = 9249
			posZ = 0.4
		end

		storedSafes[safeId].objectElement = createObject(objectId, data.posX, data.posY, data.posZ + posZ, 0, 0, data.rotZ)

		if isElement(storedSafes[safeId].objectElement) then
			setElementInterior(storedSafes[safeId].objectElement, data.interior)
			setElementDimension(storedSafes[safeId].objectElement, data.dimension)
			setElementData(storedSafes[safeId].objectElement, defaultSettings.objectId, safeId)
			setElementData(storedSafes[safeId].objectElement, "safeId", safeId)
			setElementData(storedSafes[safeId].objectElement, "safeSize", storedSafes[safeId].safeSize)

			if sync then
				triggerClientEvent(getElementsByType("player"), "createSafe", resourceRoot, safeId, data, safeSize)
			end

			loadItems(storedSafes[safeId].objectElement)
		end
	end
end