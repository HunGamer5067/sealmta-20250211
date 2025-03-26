addEvent("logAdminPaintjob", true)
addEventHandler("logAdminPaintjob", getRootElement(),
	function (vehicleId, commandName, paintjobId)
		if vehicleId and commandName and paintjobId then
			--exports.seal_logs:logCommand(client, commandName, {vehicleId, paintjobId})
		end
	end)

addCommandHandler("flipveh",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")

						local rx, ry, rz = getElementRotation(theVehicle)

						if rx > 90 and rx < 270 then
							setElementRotation(theVehicle, 0, 0, rz + 180)
						else
							setElementRotation(theVehicle, 0, 0, rz)
						end

						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffvisszaforgatta a járműved.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen visszaforgattad a kiválasztott játékos járművét. #4adfbf(" .. targetName .. ")", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("oilveh",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")

						setElementData(theVehicle, "lastOilChange", 0)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen kicserélted a kiválasztott jármű olaját.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("setvehoil",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 then
			value = tonumber(value) or 515

			if not (targetPlayer and value and value >= 0 and value <= 10000) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Olajcsere (0 km - 10 000 km)]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")
						local lastOilChange = getElementData(theVehicle, "lastOilChange") or 0

						setElementData(theVehicle, "lastOilChange", value)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megváltoztattad a kiválasztott jármű következő olajcseréjének idejét.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId, lastOilChange, -value})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("fuelveh",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 2 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")

						local fuelTankSize = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(theVehicle))
						local currentFuelLevel = getElementData(theVehicle, "vehicle.fuel")

						setElementData(theVehicle, "vehicle.fuel", fuelTankSize)

						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegtankolta a járműved.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megtankoltad a kiválasztott járművét.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("setvehfuel",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			value = tonumber(value)

			if not (targetPlayer and value and value >= 0 and value <= 100) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Üzemanyagszint (0-100)]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")

						local fuelTankSize = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(theVehicle))
						local currentFuelLevel = getElementData(theVehicle, "vehicle.fuel")
						local newFuelLevel = reMap(value, 0, 100, 0, fuelTankSize)

						if newFuelLevel > fuelTankSize then
							newFuelLevel = fuelTankSize
						end

						setElementData(theVehicle, "vehicle.fuel", newFuelLevel)

						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta a járműved üzemanyagszintjét. #4adfbf(" .. value .. "%)", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megváltoztattad a kiválasztott jármű üzemanyagszintjét.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId, currentFuelLevel, newFuelLevel})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("setvehhp",
	function (sourcePlayer, commandName, targetPlayer, value)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			value = tonumber(value)

			if not (targetPlayer and value and value >= 0 and value <= 100) then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Életerő (0-100)]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")
						local currHealth = getElementHealth(theVehicle)
						local newHealth = value * 10

						if newHealth < 320 then
							newHealth = 320
						end

						exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** megváltoztatta egy járműnek az életerejét **"..value.."%**", "adminlog")

						setElementHealth(theVehicle, newHealth)

						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegváltoztatta a járműved életerejét. #4adfbf(" .. value .. "%)", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megváltoztattad a kiválasztott jármű életerejét.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId, currHealth, newHealth})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("rtc",
	function (sourcePlayer, commandName, vehicleId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if isPedInVehicle(sourcePlayer) then
				local targetVehicle = getPedOccupiedVehicle(sourcePlayer)
				local parkedData = getElementData(targetVehicle, "vehicle.parkPosition")
				setVehicleRespawnPosition(targetVehicle, parkedData[1], parkedData[2], parkedData[3], parkedData[4], parkedData[5], parkedData[6])
				
				respawnVehicle(targetVehicle)

				if parkedData then
					setElementInterior(targetVehicle, parkedData[7])
					setElementDimension(targetVehicle, parkedData[8])
				end

				setElementData(targetVehicle, "vehicle.engine", 0)
				setVehicleEngineState(targetVehicle, false)

				showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen helyreállítottad a kiválasztott járművet.", 74, 223, 191)
			else
				if not vehicleId then
					showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Jármű ID]", 255, 150, 0)
				else
					local targetVehicle = false

					for k, v in ipairs(getElementsByType("vehicle")) do
						if getElementData(v, "vehicle.dbID") == vehicleId then
							targetVehicle = v
							break
						end
					end

					if isElement(targetVehicle) then
						local parkedData = getElementData(targetVehicle, "vehicle.parkPosition")
						setVehicleRespawnPosition(targetVehicle, parkedData[1], parkedData[2], parkedData[3], parkedData[4], parkedData[5], parkedData[6])

						respawnVehicle(targetVehicle)

						if parkedData then
							setElementInterior(targetVehicle, parkedData[7])
							setElementDimension(targetVehicle, parkedData[8])
						end

						setElementData(targetVehicle, "vehicle.engine", 0)
						setVehicleEngineState(targetVehicle, false)

						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen helyreállítottad a kiválasztott járművet.", 74, 223, 191)

						exports.seal_logs:logCommand(sourcePlayer, commandName, {vehicleId})
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott jármű nem található.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("rtc2",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(sourcePlayer)

			for k, v in pairs(getElementsByType("vehicle")) do
				local vehPosX, vehPosY, vehPosZ = getElementPosition(v)
				local vehicleDriver = getVehicleOccupant(v)

				if getDistanceBetweenPoints3D(sourcePosX, sourcePosY, sourcePosZ, vehPosX, vehPosY, vehPosZ) <= 10 then
					if not vehicleDriver then
						respawnVehicle(v)
						setElementPosition(v, 1961.5715332031, -1802.2886962891, 12.941633224487)
						setElementInterior(v, 1000)
						setElementDimension(v, 1000)
						setElementData(v, "vehicle.engine", 0)
						setVehicleEngineState(v, false)
					end
				end
			end
		end
	end)

addCommandHandler("gotoveh",
	function (sourcePlayer, commandName, vehicleId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Jármű ID]", 255, 150, 0)
			else
				local targetVehicle = false

				for k, v in ipairs(getElementsByType("vehicle")) do
					if getElementData(v, "vehicle.dbID") == vehicleId then
						targetVehicle = v
						break
					end
				end

				if isElement(targetVehicle) then
					local x, y, z = getElementPosition(targetVehicle)
					local rx, ry, rz = getVehicleRotation(targetVehicle)

					x = x + math.cos(math.rad(rz)) * 2
					y = y + math.sin(math.rad(rz)) * 2

					setElementPosition(sourcePlayer, x, y, z)
					setPedRotation(sourcePlayer, rz)
					setElementInterior(sourcePlayer, getElementInterior(targetVehicle))
					setElementDimension(sourcePlayer, getElementDimension(targetVehicle))

					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffElteleportáltál a kiválasztott járműhöz.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {vehicleId})
				else
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott jármű nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("getveh",
	function (sourcePlayer, commandName, vehicleId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Jármű ID]", 255, 150, 0)
			else
				local targetVehicle = false

				for k, v in ipairs(getElementsByType("vehicle")) do
					if getElementData(v, "vehicle.dbID") == vehicleId then
						targetVehicle = v
						break
					end
				end

				if isElement(targetVehicle) then
					local x, y, z = getElementPosition(sourcePlayer)
					local rotation = getPedRotation(sourcePlayer)

					x = x + math.cos(math.rad(rotation)) * 2
					y = y + math.sin(math.rad(rotation)) * 2

					if getElementHealth(targetVehicle) == 0 then
						spawnVehicle(targetVehicle, x, y, z, 0, 0, rotation)
					else
						setElementPosition(targetVehicle, x, y, z)
						setVehicleRotation(targetVehicle, 0, 0, rotation)
					end
					
					setElementInterior(targetVehicle, getElementInterior(sourcePlayer))
					setElementDimension(targetVehicle, getElementDimension(sourcePlayer))

					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMagadhoz teleportáltad a kiválasztott járművet.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {vehicleId})
				else
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott jármű nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("fixveh",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then						
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminTitle = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")

						fixVehicle(theVehicle)
						setVehicleDamageProof(theVehicle, false)

						for i = 0, 6 do
							removeElementData(theVehicle, "panelState:" .. i)
						end

						exports.seal_anticheat:sendDiscordMessage("**"..adminName.."** megjavította egy játékos járművét **"..targetName.."**", "adminlog")


						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegjavította a járműved.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megjavítottad #4adfbf" .. targetName .. " #ffffffjárművét.", 74, 223, 191)
						exports.seal_administration:showAdminLog(adminTitle .. " " .. adminName .. " megjavította #4adfbf" .. targetName .. "#ffffff járművét.", 2)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("fixvehbody",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", 255, 150, 0)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if isPedInVehicle(targetPlayer) then
						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						
						local theVehicle = getPedOccupiedVehicle(targetPlayer)
						local vehicleId = getElementData(theVehicle, "vehicle.dbID")
						local currhealth = getElementHealth(theVehicle)
					
						fixVehicle(theVehicle)
						setElementHealth(theVehicle, currhealth)

						for i = 0, 6 do
							removeElementData(theVehicle, "panelState:" .. i)
						end

						showAdminMessageFor(targetPlayer, "[SealMTA]: #4adfbf" .. adminName .. " #ffffffmegjavította a járműved külsejét.", 74, 223, 191)
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffSikeresen megjavítottad #4adfbf" .. targetName .. " #ffffffjárművének külsejét.", 74, 223, 191)

						if tonumber(vehicleId) then
							exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName, vehicleId})
						end
					else
						showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott játékos nem ül járműben.", 215, 89, 89)
					end
				end
			end
		end
	end)

addCommandHandler("gotojobcar",
	function (sourcePlayer, commandName, vehicleId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Jármű ID]", 255, 150, 0)
			else
				local targetVehicle = false

				for k, v in ipairs(getElementsByType("vehicle")) do
					if getElementData(v, "jobVehicleID") == vehicleId then
						targetVehicle = v
						break
					end
				end

				if isElement(targetVehicle) then
					local x, y, z = getElementPosition(targetVehicle)
					local rx, ry, rz = getVehicleRotation(targetVehicle)

					x = x + math.cos(math.rad(rz)) * 2
					y = y + math.sin(math.rad(rz)) * 2

					setElementPosition(sourcePlayer, x, y, z)
					setPedRotation(sourcePlayer, rz)
					setElementInterior(sourcePlayer, getElementInterior(targetVehicle))
					setElementDimension(sourcePlayer, getElementDimension(targetVehicle))

					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffElteleportáltál a kiválasztott munkajárműhöz.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {vehicleId})
				else
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott munkajármű nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("getjobcar",
	function (sourcePlayer, commandName, vehicleId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			vehicleId = tonumber(vehicleId)

			if not vehicleId then
				showAdminMessageFor(sourcePlayer, "[Használat]: #ffffff/" .. commandName .. " [Jármű ID]", 255, 150, 0)
			else
				local targetVehicle = false

				for k, v in ipairs(getElementsByType("vehicle")) do
					if getElementData(v, "jobVehicleID") == vehicleId then
						targetVehicle = v
						break
					end
				end

				if isElement(targetVehicle) then
					local x, y, z = getElementPosition(sourcePlayer)
					local rotation = getPedRotation(sourcePlayer)

					x = x + math.cos(math.rad(rotation)) * 2
					y = y + math.sin(math.rad(rotation)) * 2

					if getElementHealth(targetVehicle) == 0 then
						spawnVehicle(targetVehicle, x, y, z, 0, 0, rotation)
					else
						setElementPosition(targetVehicle, x, y, z)
						setVehicleRotation(targetVehicle, 0, 0, rotation)
					end
					
					setElementInterior(targetVehicle, getElementInterior(sourcePlayer))
					setElementDimension(targetVehicle, getElementDimension(sourcePlayer))

					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffMagadhoz teleportáltad a kiválasztott munkajárművet.", 74, 223, 191)

					exports.seal_logs:logCommand(sourcePlayer, commandName, {vehicleId})
				else
					showAdminMessageFor(sourcePlayer, "[SealMTA]: #ffffffA kiválasztott munkajármű nem található.", 215, 89, 89)
				end
			end
		end
	end)

addCommandHandler("cipel",
	function(sourcePlayer)
		if (getElementData(sourcePlayer, "acc.adminLevel") >= 1 and getElementData(sourcePlayer, "adminDuty") == 1) or getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			local vehicle = getPedContactElement(sourcePlayer)
			local cipel = getElementData(sourcePlayer, "cipel")

			if cipel then
				setElementData(sourcePlayer, "cipel", nil)
				if isElement(cipel) then
					detachElements(cipel, sourcePlayer)
					setElementCollisionsEnabled(cipel, true)
					local x, y, z = getElementPosition(cipel)
					setElementPosition(cipel, x, y, z - 1.9)
				end
			else
				if isElement(vehicle) and getElementType(vehicle) == "vehicle" then
					local cipel = vehicle
					setElementData(sourcePlayer, "cipel", cipel)
					attachElements(vehicle, sourcePlayer, 0, 0, 1.9, 0, 0, 0)
					setElementCollisionsEnabled(cipel, false)
				end
			end
		end
	end
)

addEvent("hulk_push",true)
addEventHandler("hulk_push",resourceRoot,function(veh,vx,vy,vz)
	iprint(veh, vx, vy, vz)
	setElementData(client, "cipel", nil)
	if isElement(veh) then
		detachElements(veh, sourcePlayer)
		setElementCollisionsEnabled(veh, true)
		local vecLen = math.sqrt(vx * vx + vy * vy + vz * vz)
		setElementFrozen(veh, false)
		setElementVelocity(veh,vx,vy,vz)
	end
end
)

addCommandHandler("gotovehplayer",
	function (sourcePlayer, commandName, targetPlayer, vehicleId)
		if isHavePermission(sourcePlayer, "gotovehplayer") then
			local vehicleId = tonumber(vehicleId)

			if not (targetPlayer and vehicleId) then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID] [Jármű ID]", sourcePlayer, 245, 150, 34, true)
			else
				local targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					local targetVehicle = findVehicle(sourcePlayer, vehicleId)
					
					if targetVehicle then
						local adminNick = getElementData(sourcePlayer, "acc.adminNick") or "Ismeretlen"

						local vehiclePosX, vehiclePosY, vehiclePosZ = getElementPosition(targetVehicle)
						local vehicleDimension = getElementDimension(targetVehicle)
						local vehicleInterior = getElementInterior(targetVehicle)

						setElementDimension(targetPlayer, vehicleDimension)
						setElementInterior(targetPlayer, vehicleInterior)
						setElementPosition(targetPlayer, vehiclePosX + 1.5, vehiclePosY + 1.5, vehiclePosZ)

						outputChatBox("[SealMTA]: #ffffffSikeresen elteleportáltad a játékost a kiválaszott járműhöz.", sourcePlayer, 74, 223, 191, true)
						outputChatBox("[SealMTA]: #32b2ee" .. adminNick .. " #ffffffelteleportált a #32b2ee" .. vehicleId .. " #ffffffid-vel rendelkező járműhöz.", targetPlayer, 74, 223, 191, true)
					end
				end
			end
		end
	end
)

function findVehicle(element, vehicleId)
	local targetVehicle = false

	for k, v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "vehicle.dbID") == vehicleId then
			targetVehicle = v
			break
		end
	end

	if not targetVehicle then
		outputChatBox("[SealMTA - Hiba]: #ffffffNem található ilyen id-vel rendelkező jármű.", element, 245, 81, 81, true)
	end

	return targetVehicle
end