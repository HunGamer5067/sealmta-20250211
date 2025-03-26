local buildings = {}
local tuningMarkers = {}
local garageColShape = createColCuboid(390, 2471.5, 15, 29.5, 10, 8.5)

connection = false

local spinnerVehicles = {}

local tuningModelPosX = 1044
local tuningModelPosY = -906.9
local tuningModelPosZ = 41

local tuningModelsLoaded = {}
local tuningModelToBeLoaded = {8068, 8069}
local tuningModelRemoveables = {
    {1563, 0.25, 0.5703, 26.6719, 1199.8125},
    {1563,  0.25, 0.6016, 24.375, 1199.8125},
    {1562,  0.25, 0.6016, 24.7188, 1199.2656},
    {1562,  0.25, 0.5703, 27.0156, 1199.2656},
    {1562,  0.25, 0.6016, 29.3516, 1199.2656},
    {1563,  0.25, 0.6016, 29.6953, 1199.8125},
    {1564,  0.25, 1.6328, 25.0547, 1202},
    {1565,  0.25, 1.6328, 25.0547, 1202.0234},
    {1564,  0.25, 1.6328, 26.9063, 1202},
    {1565,  0.25, 1.6328, 26.9063, 1202.0234},
    {1563,  0.25, 2.8594, 25.4375, 1199.8125},
    {1562,  0.25, 2.8594, 25.7813, 1199.2656},
    {1563,  0.25, 2.8594, 27.7109, 1199.8125},
    {1562,  0.25, 2.8594, 28.0547, 1199.2656},
    {1564,  0.25, 1.6328, 28.875, 1202},
    {1565,  0.25, 1.6328, 28.875, 1202.0234},
    {14405, 0.25, 1.7266, 30.0547, 1199.2656},
    {1562,  0.25, 2.8594, 30.3984, 1199.2656},
    {1563,  0.25, 2.8594, 30.7422, 1199.8125},
    {1564,  0.25, 1.6328, 30.7578, 1202},
    {1565,  0.25, 1.6328, 30.7578, 1202.0234},
}

addEventHandler("onResourceStart", resourceRoot,
    function ()
        for i = 1, #tuningModelRemoveables do
            local tuningData = tuningModelRemoveables[i]

            if tuningData then
                local modelId = tuningData[1]

                if modelId then
                    local modelPosX = tuningData[2]
                    local modelPosY = tuningData[3]
                    local modelPosZ = tuningData[4]

                    if modelPosX and modelPosY and modelPosZ then
                        local modelRadius = tuningData[5]

                        if modelRadius then
                            removeWorldModel(modelId, modelPosX, modelPosY, modelPosZ, modelRadius)
                        end
                    end
                end
            end
        end

        for i = 1, #tuningModelToBeLoaded do
            local tuningModelId = tuningModelToBeLoaded[i]

            if tuningModelId then
                local objectElement = createObject(tuningModelId, tuningModelPosX, tuningModelPosY, tuningModelPosZ)

                if objectElement then
                    setElementDoubleSided(objectElement, true)
					setElementRotation(objectElement, 0, 0, 99)
                    setElementDimension(objectElement, 0)
                    setElementInterior(objectElement, 0)
                
                    if not tuningModelsLoaded[objectElement] then
                        tuningModelsLoaded[objectElement] = true
                    end
                end
            end
        end
    end
)

addEventHandler("onPlayerWasted", root,
	function()
		if getElementData(source, "activeTuningMarker") then
			triggerEvent("exitTuning", source)
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if getElementData(source, "activeTuningMarker") then
			local tuningMarker = getElementData(source, "activeTuningMarker")

			if isElement(tuningMarker) then
				setElementAlpha(tuningMarker, 1)
			end

			local sourceVehicle = getPedOccupiedVehicle(source)
	
			if isElement(sourceVehicle) and isElement(tuningMarker) then
				local vehicleOccupants = getVehicleOccupant(sourceVehicle)
				local x, y, z = getElementPosition(tuningMarker)

				setElementFrozen(sourceVehicle, false)
				setElementPosition(sourceVehicle, 1020.3281860352, -910.69818115234, 42.12638092041)
				setElementRotation(sourceVehicle, 0, 0, 101)
				setElementInterior(sourceVehicle, 0)
				setElementDimension(sourceVehicle, 0)
	
				local vehicleOccupants = getVehicleOccupants(sourceVehicle)
	
				for i = 0, 3 do
					if vehicleOccupants[i] then
						setElementInterior(vehicleOccupants[i], 0)
						setElementDimension(vehicleOccupants[i], 0)
						exports.seal_controls:toggleControl(vehicleOccupants[i], "all", true)
					end
				end
				exports.seal_nocollide:setElementCollisionsEnabled(sourceVehicle, false, 15000, true)
			end	
		end
	end
)

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end)

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.seal_database:getConnection()

		for k, v in ipairs(tuningPositions) do
			tuningMarkers[k] = createMarker(v[1], v[2], v[3] + 1, "cylinder", 3, 94, 193, 230, 1)

			if isElement(tuningMarkers[k]) then
				setElementData(tuningMarkers[k], "tuningPositionId", k)
			end
		end
	end)

local backlistedVehicleTypes = {
	["Boat"] = true,
	["Train"] = true,
	["Helicopter"] = true,
	["Plane"] = true,
	["BMX"] = true,
	["Trailer"] = true,
}

addEventHandler("onMarkerHit", getResourceRootElement(),
	function (hitElement)
		local positionId = getElementData(source, "tuningPositionId")

		if positionId then
			if getElementType(hitElement) == "vehicle" and not backlistedVehicleTypes[getVehicleType(hitElement)] then
				local driver = getVehicleController(hitElement)

				if driver then
					setControlState(driver, "accelerate", false)
					exports.seal_controls:toggleControl(driver, "all", false)
					if getElementAlpha(source) ~= 0 then
						setElementAlpha(source, 1)

						local health = getElementHealth(hitElement)
						fixVehicle(hitElement)
						setElementHealth(hitElement, health)

						local vehX, vehY, vehZ = getElementPosition(hitElement)

						setElementPosition(hitElement, tuningPositions[positionId][1], tuningPositions[positionId][2], vehZ)
						setElementRotation(hitElement, 0, 0, tuningPositions[positionId][4])

						setElementData(driver, "activeTuningMarker", source, false)

						setElementFrozen(hitElement, false)
						setElementVelocity(hitElement, 0, 0, 0)
						setElementAngularVelocity(hitElement, 0, 0, 0)

						setTimer(
							function()
								setElementFrozen(hitElement, true)
						end, 750, 1)

						local building = createObject(8842, 1131.7099609375, -1539.5729980469, 454.796875)
						setElementDimension(building, getElementData(hitElement, "vehicle.dbID")+100)
						buildings[driver] = building

						setElementPosition(hitElement, 1131.8957519531, -1540.6186523438, 455.796875)
						setElementRotation(hitElement, 0, 0, 0)
						setElementDimension(hitElement, getElementData(hitElement, "vehicle.dbID")+100)

						local occupants = getVehicleOccupants(hitElement)

						for i = 0, 3 do
							if occupants[i] then
								setElementDimension(occupants[i], getElementData(hitElement, "vehicle.dbID")+100)
								triggerClientEvent(occupants[i], "syncTuningSound", occupants[i], getElementDimension(occupants[i]), getElementInterior(occupants[i]))
								setElementData(occupants[i], "inTuning", true)
							end
						end
						
						triggerClientEvent(driver, "toggleTuning", driver, true)
					end
				end
			end
		end
	end)

addEvent("exitTuning", true)
addEventHandler("exitTuning", getRootElement(),
	function ()
		if isElement(source) then
			local tuningMarker = getElementData(source, "activeTuningMarker")
			setElementData(source, "activeTuningMarker", false)
			
			if isElement(tuningMarker) then
				local pedVehicle = getPedOccupiedVehicle(source)
				triggerClientEvent(source, "toggleTuning", source, false)

				if pedVehicle then
					setElementFrozen(pedVehicle, false)
					setElementPosition(pedVehicle, 1020.3281860352, -910.69818115234, 42.12638092041)
					setElementRotation(pedVehicle, 0, 0, 98)
					setElementInterior(pedVehicle, 0)
					setElementDimension(pedVehicle, 0)
					setVehicleEngineState(pedVehicle, false)
					setElementFrozen(pedVehicle, true)
					setElementData(pedVehicle, "vehicle.handBrake", true)
 
					local wheelTuningFront = getElementData(pedVehicle, "vehicle.tuning.wheelsFront")
					local wheelTuningBack = getElementData(pedVehicle, "vehicle.tuning.wheelsBack")
					
					if not wheelTuningFront then
						triggerClientEvent(source, "removeCustomWheel", source, pedVehicle)
					end

					local occupants = getVehicleOccupants(pedVehicle)
					for i = 0, 3 do
						if occupants[i] then
							setElementInterior(occupants[i], 0)
							setElementDimension(occupants[i], 0)
							exports.seal_controls:toggleControl(occupants[i], "all", true)
							triggerClientEvent(occupants[i], "destroyTuningSound", occupants[i])
						end
					end

					if buildings[source] then
						if isElement(buildings[source]) then
							destroyElement(buildings[source])
						end
					end
					buildings[source] = nil
					collectgarbage("collect")

					exports.seal_nocollide:setElementCollisionsEnabled(pedVehicle, false, 15000, true)
				end
				setElementAlpha(tuningMarker, 1)
			end
		end
	end)

addEventHandler("onColShapeHit", garageColShape,
	function (hitElement, matchingDimension)
		if getElementType(hitElement) == "player" then
			if matchingDimension then
				if not isGarageOpen(45) then
					setGarageOpen(45, true)
				end
			end
		end
	end)

addEventHandler("onColShapeLeave", garageColShape,
	function (leftElement, matchingDimension)
		if getElementType(leftElement) == "player" then
			if matchingDimension then
				if #getElementsWithinColShape(source, "player") == 0 then
					if isGarageOpen(45) then
						setGarageOpen(45, false)
					end
				end
			end
		end
	end)

addEvent("setVehicleHandling", true)
addEventHandler("setVehicleHandling", getRootElement(),
	function (property, value)
		if isElement(source) then
			if property then
				local vehicle = getPedOccupiedVehicle(source)

				if isElement(vehicle) then
					setVehicleHandling(vehicle, property, value)
				end
			end
		end
	end)

addEvent("previewVariant", true)
addEventHandler("previewVariant", getRootElement(),
	function (variant)
		if isElement(source) then
			if not variant then
				variant = getElementData(source, "vehicle.variant") or 0
			end

			if variant == 0 then
				setVehicleVariant(source, 255, 255)
			else
				setVehicleVariant(source, variant - 1, 255)
			end
		end
	end)

function canTuneVehicle(vehicle, player, notice)
	local ownerId = getElementData(vehicle, "vehicle.owner") or 0
	local groupId = getElementData(vehicle, "vehicle.group") or 0

	if ownerId == 0 and groupId == 0 then
		return true
	end

	if ownerId > 0 then
		if ownerId == getElementData(player, "char.ID") then
			return true
		end
	end

	if groupId > 0 then
		if exports.seal_groups:isPlayerInGroup(player, groupId) then
			return true
		end
	end

	if notice then
		exports.seal_gui:showInfobox(player, "e", "Nem te vagy a jármű tulajdonosa!")
	end

	return false
end

addEvent("buyVariantTuning", true)
addEventHandler("buyVariantTuning", getRootElement(),
	function (variant, price)
		if client == source and variant and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local currVariant = getElementData(vehicle, "vehicle.variant") or 0
				local buyState = "failed"

				if currVariant ~= variant then
					if exports.seal_core:takeMoneyEx(client, price, eventName) then
						if variant == 0 then
							setVehicleVariant(vehicle, 255, 255)
							buyState = "successdown"
						else
							setVehicleVariant(vehicle, variant - 1, 255)
							buyState = "success"
						end

						setElementData(vehicle, "vehicle.variant", variant)

						if vehicleId then
							dbExec(connection, "UPDATE vehicles SET variant = ? WHERE vehicleId = ?", variant, vehicleId)
						end
					else
						exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyVariant", client, buyState)
			end
		end
	end)

addEvent("buySpinnerTuning", true)
addEventHandler("buySpinnerTuning", getRootElement(),
	function (value, r, g, b, sx, sy, sz, tinted, price)
		if client == source and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) and spinnerVehicles[getElementModel(vehicle)] then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local currSpinner = getElementData(vehicle, "tuningSpinners")
				local newSpinner = {}
				local buyState = "failed"

				if value then
					if tinted then
						newSpinner = {value, sx, sy, sz, r, g, b}
					else
						newSpinner = {value, sx, sy, sz}
					end
				else
					newSpinner = {}
				end

				if currSpinner ~= value then
					local currPP = getElementData(client, "acc.premiumPoints") or 0

					currPP = currPP - price

					if currPP >= 0 then
						setElementData(client, "acc.premiumPoints", currPP)
						dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currPP, getElementData(client, "char.accID"))

						if value then
							setElementData(vehicle, "tuningSpinners", newSpinner)
							buyState = "success"
						else
							setElementData(vehicle, "tuningSpinners", false)
							buyState = "successdown"
						end

						if vehicleId then
							dbExec(connection, "UPDATE vehicles SET tuningSpinners = ? WHERE vehicleId = ?", table.concat(newSpinner, ","), vehicleId)
						end
					else
						exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
					end
				else
					if value then
						exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
					else
						exports.seal_gui:showInfobox(client, "e", "Mégis mit akarsz leszerelni?")
					end
				end

				if value then
					triggerClientEvent(client, "buySpinner", client, buyState, newSpinner)
				else
					triggerClientEvent(client, "buySpinner", client, buyState, false)
				end
			end
		end
	end)

addEvent("buyOpticalTuning", true)
addEventHandler("buyOpticalTuning", getRootElement(),
	function (slot, value, priceType, price)
		if client == source and slot and value and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currUpgrade = getVehicleUpgradeOnSlot(vehicle, slot)
				local buyState = "failed"

				if currUpgrade ~= value then
					if value == 0 and ownerId ~= charId then
						exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa szerelhet le alkatrészt!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
							else
								exports.seal_core:takeMoney(client, price, eventName)
							end

							local currUpgrades = getElementData(vehicle, "vehicle.tuning.Optical") or ""
							local currUpgradesTable = split(currUpgrades, ",")
							local changed = false

							for k, upgrade in pairs(currUpgradesTable) do
								if getVehicleUpgradeSlotName(slot) == getVehicleUpgradeSlotName(upgrade) then
									currUpgradesTable[k] = value
									changed = true
								end
							end

							if not changed then
								currUpgrades = currUpgrades .. tostring(value) .. ","
							else
								currUpgrades = table.concat(currUpgradesTable, ",") .. ","
							end

							if value == 0 then
								removeVehicleUpgrade(vehicle, currUpgrade)
							else
								addVehicleUpgrade(vehicle, value)
							end

							setElementData(vehicle, "vehicle.tuning.Optical", currUpgrades)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningOptical = ? WHERE vehicleId = ?", currUpgrades, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyOpticalTuning", client, buyState, value)
			end
		end
	end)

addEvent("buyPlatina", true)
addEventHandler("buyPlatina", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.Platina") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa cserélhet platinát!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
							else
								exports.seal_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.Platina", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningPlatina = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyPlatina", client, buyState, value)
			end
		end
	end)

addEvent("buyPaintjob", true)
addEventHandler("buyPaintjob", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.Paintjob") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa cserélhet paintjobot!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
							else
								exports.seal_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.Paintjob", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningPaintjob = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyPaintjob", client, buyState, value)
			end
		end
	end)

addEvent("buyWheelPaintjob", true)
addEventHandler("buyWheelPaintjob", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.WheelPaintjob") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa cserélhet kerék paintjobot!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
								dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
							else
								exports.seal_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.WheelPaintjob", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningWheelPaintjob = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyWheelPaintjob", client, buyState, value)
			end
		end
	end)

addEvent("buyHeadLight", true)
addEventHandler("buyHeadLight", getRootElement(),
	function (value, priceType, price)
		if source == client and value and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local currPaintjob = getElementData(vehicle, "vehicle.tuning.HeadLight") or 0
				local buyState = "failed"

				if currPaintjob ~= value then
					if value == 0 and ownerId ~= charId then
						exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa cserélhet fényszórót!")
					else
						local currBalance = 0

						if priceType == "premium" then
							currBalance = getElementData(client, "acc.premiumPoints") or 0
						else
							currBalance = getElementData(client, "char.Money") or 0
						end

						currBalance = currBalance - price

						if currBalance >= 0 then
							buyState = "success"

							if priceType == "premium" then
								setElementData(client, "acc.premiumPoints", currBalance)
							else
								exports.seal_core:takeMoney(client, price, eventName)
							end

							setElementData(vehicle, "vehicle.tuning.HeadLight", value)

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET tuningHeadLight = ? WHERE vehicleId = ?", value, vehicleId)
							end
						else
							if priceType == "premium" then
								exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
							else
								exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
							end
						end
					end
				else
					exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
				end

				triggerClientEvent(client, "buyHeadLight", client, buyState, value)
			end
		end
	end)

addEvent("buyColor", true)
addEventHandler("buyColor", getRootElement(),
	function (colorId, vehicleColor, vehicleLightColor, priceType, price)
		if source == client and colorId and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")

				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				local buyState = "failed"
				local currBalance = 0

				if ownerId ~= charId then
					exports.seal_gui:showInfobox(client, "e", "Csak a jármű tulajdonosa festheti át a járművet!")
				else
					if priceType == "premium" then
						currBalance = getElementData(client, "acc.premiumPoints") or 0
					else
						currBalance = getElementData(client, "char.Money") or 0
					end

					currBalance = currBalance - price

					if currBalance >= 0 then
						buyState = "success"

						if priceType == "premium" then
							setElementData(client, "acc.premiumPoints", currBalance)
							dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
						else
							exports.seal_core:takeMoney(client, price, eventName)
						end

						if colorId <= 4 then
							local color1 = convertRGBToHEX(vehicleColor[1], vehicleColor[2], vehicleColor[3])
							local color2 = convertRGBToHEX(vehicleColor[4], vehicleColor[5], vehicleColor[6])
							local color3 = convertRGBToHEX(vehicleColor[7], vehicleColor[8], vehicleColor[9])
							local color4 = convertRGBToHEX(vehicleColor[10], vehicleColor[11], vehicleColor[12])

							setVehicleColor(vehicle, vehicleColor[1], vehicleColor[2], vehicleColor[3], vehicleColor[4], vehicleColor[5], vehicleColor[6], vehicleColor[7], vehicleColor[8], vehicleColor[9], vehicleColor[10], vehicleColor[11], vehicleColor[12])

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET color1 = ?, color2 = ?, color3 = ?, color4 = ? WHERE vehicleId = ?", color1, color2, color3, color4, vehicleId)
							end
						elseif colorId == 5 then
							local headLightColor = convertRGBToHEX(vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])

							setVehicleHeadLightColor(vehicle, vehicleLightColor[1], vehicleLightColor[2], vehicleLightColor[3])

							if vehicleId then
								dbExec(connection, "UPDATE vehicles SET headLightColor = ? WHERE vehicleId = ?", headLightColor, vehicleId)
							end
						elseif colorId >= 7 then
							triggerClientEvent(client, "buySpeedoColor", vehicle, colorId)
							buyState = "speedo"
						end
					else
						if priceType == "premium" then
							exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
						else
							exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
						end
					end
				end

				triggerClientEvent(client, "buyColor", client, buyState, vehicleColor, vehicleLightColor)
			end
		end
	end)

function convertRGBToHEX(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end

	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

addEvent("buyLicensePlate", true)
addEventHandler("buyLicensePlate", getRootElement(),
	function (value, plateText, priceType, price)
		if source == client and value and plateText and priceType and price then
			local vehicle = getPedOccupiedVehicle(client)

			if isElement(vehicle) then
				local vehicleId = getElementData(vehicle, "vehicle.dbID")
				local ownerId = getElementData(vehicle, "vehicle.owner")
				local charId = getElementData(client, "char.ID")

				dbQuery(
					function (qh, thePlayer)
						local result = dbPoll(qh, 0)[1]
						local buyState = "failed"

						if value == "custom" and result.plateState == 1 then
							exports.seal_gui:showInfobox(thePlayer, "e", "A kiválasztott rendszám foglalt, kérlek válassz másikat!")
						else
							local currBalance = 0

							if value == "default" and ownerId ~= charId then
								exports.seal_gui:showInfobox(thePlayer, "e", "Csak a jármű tulajdonosa cserélheti le a rendszámot!")
							else
								if priceType == "premium" then
									currBalance = getElementData(thePlayer, "acc.premiumPoints") or 0
								else
									currBalance = getElementData(thePlayer, "char.Money") or 0
								end

								currBalance = currBalance - price

								if currBalance >= 0 then
									buyState = "success"

									if priceType == "premium" then
										setElementData(thePlayer, "acc.premiumPoints", currBalance)
										dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(thePlayer, "char.accID"))
									else
										exports.seal_core:takeMoney(thePlayer, price, eventName)
									end

									if value == "default" then
										if vehicleId then
											plateText = exports.seal_vehicles:encodeDatabaseId(vehicleId)
										else
											plateText = ""
										end
									end

									setVehiclePlateText(vehicle, plateText)

									if vehicleId then
										dbExec(connection, "UPDATE vehicles SET plateText = ? WHERE vehicleId = ?", plateText, vehicleId)
									end
								else
									if priceType == "premium" then
										exports.seal_gui:showInfobox(thePlayer, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
									else
										exports.seal_gui:showInfobox(thePlayer, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
									end
								end
							end
						end

						triggerClientEvent(thePlayer, "buyLicensePlate", thePlayer, buyState, plateText)
					end,
				{client}, connection, "SELECT COUNT(1) AS plateState FROM vehicles WHERE plateText = ? LIMIT 1", plateText)
			end
		end
	end)


function customPlateText(source, vehicle, plateText)
	if getElementData(source, "acc.adminLevel") >= 6 then
		if not plateText then 
			outputChatBox("nincs text", source)
		elseif plateText then
			local vehicleId = getElementData(getPedOccupiedVehicle(source), "vehicle.dbID")
			setVehiclePlateText(getPedOccupiedVehicle(source), plateText)
			dbExec(connection, "UPDATE vehicles SET plateText = ? WHERE vehicleId = ?", plateText, vehicleId)
			exports.seal_anticheat:sendDiscordMessage("aplatezett " .. getPlayerName(source) .. ", " .. plateText, "test")
		elseif not getPedOccupiedVehicle(source) then 
			outputChatBox("nem vagy jarmuben" .. getElementData(source, "char.Name"), source)
		end
	end
end
addCommandHandler("aplate",customPlateText)

addEvent("buyTuning", true)
addEventHandler("buyTuning", getRootElement(),
	function (selectedMenu, selectedSubMenu, selectionLevel, isTheOriginal, customWheel)
		if source == client then
			local vehicle = getPedOccupiedVehicle(client)
			local model = getElementModel(vehicle)
			local container = tuningContainer

			if exports.seal_ev:getChargingPortOffset(model) then
				container = evTuningContainer
			end

			if isElement(vehicle) then
				local activeMenu = container[selectedMenu].subMenu[selectedSubMenu]
				local priceType = activeMenu.subMenu[selectionLevel].priceType
				local price = activeMenu.subMenu[selectionLevel].price
				local value = activeMenu.subMenu[selectionLevel].value

				local buyState = "failed"
				local currBalance = 0

				if priceType == "premium" then
					currBalance = getElementData(client, "acc.premiumPoints") or 0
				else
					currBalance = getElementData(client, "char.Money") or 0
				end

				currBalance = currBalance - price
				isCustomWheel = activeMenu.subMenu[selectionLevel].id == "customwheel"

				if currBalance >= 0 then
					if isTheOriginal then
						exports.seal_gui:showInfobox(client, "e", "A kiválasztott elem már fel van szerelve!")
					else
						buyState = "success"

						if priceType == "premium" then
							setElementData(client, "acc.premiumPoints", currBalance)
							dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", currBalance, getElementData(client, "char.accID"))
						else
							exports.seal_core:takeMoney(client, price)
						end

						if activeMenu.serverFunction then
							activeMenu.serverFunction(vehicle, value)
						end

						if selectedMenu == 1 and selectedSubMenu == 8 then
							if value == 0 then
								exports.seal_gui:showInfobox(client, "s", "Sikeresen kiürítetted a nitrós palackod.")
							else
								exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltad a kiválasztott elemet!")
							end
						elseif selectedMenu == 2 and selectedSubMenu == 11 then
							if value == 0 then
								exports.seal_gui:showInfobox(client, "s", "Sikeresen leszerelted a neont.")
							else
								exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltad a kiválasztott neont! ('u' betűvel kapcsolod ki és be)")
							end
						elseif activeMenu.id == "handling" then
							value = getVehicleHandling(vehicle)["handlingFlags"]
						end
					end
				else
					if priceType == "premium" then
						exports.seal_gui:showInfobox(client, "e", "Nincs elég prémium pontod a kiválasztott tétel megvásárlásához!")
					else
						exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tétel megvásárlásához!")
					end
				end

				if customWheel then
					local wheelData = buyState == "success" and customWheel[1] or customWheel[2]
				
					if wheelData.reset then
						setElementData(vehicle, "vehicle.tuning.wheelsFront", false)
						setElementData(vehicle, "vehicle.tuning.wheelsBack", false)
					elseif wheelData.front and wheelData.back and isCustomWheel then
						setElementData(vehicle, "vehicle.tuning.wheelsFront", wheelData.front)
						setElementData(vehicle, "vehicle.tuning.wheelsBack", wheelData.back)
					end
				end

				triggerClientEvent(client, "buyTuning", client, buyState, activeMenu.id, value)
			end
		end
	end)


function makeTuning(vehicleElement, disableTrailerCheck)
    if isElement(vehicleElement) then
        local defaultHandling = getOriginalHandling(getElementModel(vehicleElement))
		local defaultModelHandling = getModelHandling(getElementModel(vehicleElement))

		for propertyName, propertyValue in pairs(defaultModelHandling) do
			setVehicleHandling(vehicleElement, propertyName, propertyValue)
		end
		
        -- Collect installed performance tuning values
        local tuningDataValues = {}
        local tuningDataKeys = {
            ["vehicle.tuning.Engine"] = true,
            ["vehicle.tuning.Turbo"] = true,
            ["vehicle.tuning.ECU"] = true,
            ["vehicle.tuning.Transmission"] = true,
            ["vehicle.tuning.Suspension"] = true,
            ["vehicle.tuning.Brakes"] = true,
            ["vehicle.tuning.Tires"] = true,
            ["vehicle.tuning.WeightReduction"] = true
        }

        for dataName in pairs(tuningDataKeys) do
            local dataValue = getElementData(vehicleElement, dataName) or 0

            if dataValue > 0 then
                tuningDataValues[gettok(dataName, 3, ".")] = dataValue
            end
        end

		-- Reset the affected handling properties
		local propertiesToRestore = {}

		for effectName in pairs(tuningDataValues) do
			for propertyName in pairs(tuningEffect[effectName]) do
				propertiesToRestore[propertyName] = true
			end
		end

		for propertyName, propertyValue in pairs(defaultHandling) do
			if propertiesToRestore[propertyName] then
				setVehicleHandling(vehicleElement, propertyName, propertyValue)
			end
		end

        applyHandling(vehicleElement, propertiesToRestore)

        -- Apply the performance tunings
        local currentHandling = getVehicleHandling(vehicleElement)
        local appliedHandling = {}

        for effectName, effectValue in pairs(tuningDataValues) do
            if effectValue ~= 0 then
                for propertyName, propertyValue in pairs(tuningEffect[effectName]) do
                    if currentHandling[propertyName] then
                        if propertyValue[effectValue] then
                            if not appliedHandling[propertyName] then
                                appliedHandling[propertyName] = currentHandling[propertyName]
                            end
							if propertyName == "dragCoeff" then
							end

                            appliedHandling[propertyName] = appliedHandling[propertyName] + appliedHandling[propertyName] * (propertyValue[effectValue] / 135)
                        end
                    end
                end
            end
        end

        for propertyName, propertyValue in pairs(appliedHandling) do
            setVehicleHandling(vehicleElement, propertyName, propertyValue)
        end

        local airRideLevel = getElementData(vehicleElement, "airRideLevel") or 8

        if airRideLevel ~= 8 then
			local originalLimit = getHandlingProperty(vehicleElement, "suspensionLowerLimit")
			local newLimit = originalLimit + (airRideLevel - 8) * 0.0275

			setVehicleHandling(vehicleElement, "suspensionLowerLimit", newLimit)

			local x, y, z = getElementVelocity(vehicleElement)

			setElementVelocity(vehicleElement, x, y, z + 0.01)
        end

		local vehicle = vehicleElement
		local currentHandling = getVehicleHandling(vehicle)
		
		for property, value in pairs(appliedHandling) do


			if doubleExhaust[getElementModel(vehicle)] then
				setVehicleHandling(vehicle, "modelFlags", 0x00002000)
			end
			if singleExhaust[getElementModel(vehicle)] then
				setVehicleHandling(vehicle, "modelFlags", 0x0)
			end
			if noExhaust[getElementModel(vehicle)] then
				setVehicleHandling(vehicle, "modelFlags", 0x00001000)
			end
		end

		local ecuTuning = getElementData(vehicleElement, "vehicle.tuning.ECU") or false
		local airRideTuning = getElementData(vehicleElement, "vehicle.tuning.AirRide") or false

		if (ecuTuning and tonumber(ecuTuning)) == 5 then
			local currentHandling = getVehicleHandling(vehicleElement)
			local ecuDatas = getElementData(vehicleElement, "vehicle.ecu") or {
				balance = 0,
				settings = { 0, 0, 0, 0, 0, 0 },
				defaultSettings = { 0, 0, 0, 0, 0, 0 },
				multiplier = 1
			}

			local maxVelocity = currentHandling.maxVelocity
			local engineAcceleration = currentHandling.engineAcceleration
			local engineInertia = currentHandling.engineInertia
			local multipler = ecuDatas.multiplier
			local balance = ecuDatas.balance

			local realMultipler = (math.abs(balance) * multipler)

			if balance > 0 then
				engineAcceleration = engineAcceleration + realMultipler * 8
				--maxVelocity = maxVelocity + realMultipler * 30
				engineInertia = engineInertia + realMultipler * 3
			else
				engineAcceleration = engineAcceleration + realMultipler * 6
				--maxVelocity = maxVelocity - realMultipler * 30
				engineInertia = engineInertia + realMultipler * 5
			end

			iprint(engineAcceleration, engineInertia)

			setVehicleHandling(vehicleElement, "maxVelocity", maxVelocity)
			setVehicleHandling(vehicleElement, "engineAcceleration", engineAcceleration)
			setVehicleHandling(vehicleElement, "engineInertia", engineInertia)
		end

		if (airRideTuning and tonumber(airRideTuning)) == 1 then
			local arirrideBias = getElementData(vehicleElement, "airrideBias") or 0
			local airrideLevel = getElementData(vehicleElement, "airrideLevel") or 0
			local airrideSoftness = getElementData(vehicleElement, "airrideSoftness") or 0

			local centerOfMass = getVehicleHandling(vehicleElement).centerOfMass
			local suspensionLowerLimit = getVehicleHandling(vehicleElement).suspensionLowerLimit
			local suspensionDamping = getVehicleHandling(vehicleElement).suspensionDamping

			centerOfMass[2] = centerOfMass[2] + arirrideBias / 10
			suspensionLowerLimit = suspensionLowerLimit + airrideLevel * 0.015
			suspensionDamping = suspensionDamping + airrideSoftness * 0.5
			
			setVehicleHandling(vehicleElement, "centerOfMass", centerOfMass)
			setVehicleHandling(vehicleElement, "suspensionLowerLimit", suspensionLowerLimit)
			setVehicleHandling(vehicleElement, "suspensionDamping", suspensionDamping)

			triggerClientEvent("gotVehicleAirRide", vehicleElement, airrideLevel, arirrideBias, airrideSoftness)
		else
			triggerClientEvent("gotVehicleAirRide", vehicleElement)
		end

		--[[
		-- Apply trailer handling if needed
		if not disableTrailerCheck then
			local trailerVehicle = exports.seal_observer:getAttachedTrailer(vehicleElement)

			if isElement(trailerVehicle) then
				local tractorHandling = getVehicleHandling(vehicleElement)
				local trailerHandling = getVehicleHandling(trailerVehicle)

				setVehicleHandling(vehicleElement, "mass", tractorHandling.mass + trailerHandling.mass)
				setVehicleHandling(vehicleElement, "dragCoeff", tractorHandling.dragCoeff + trailerHandling.dragCoeff)

				local tractionAdjustment = math.random(10, 15) / 100

				setVehicleHandling(vehicleElement, "tractionMultiplier", (1 - tractionAdjustment) * tractorHandling.tractionMultiplier)
				setVehicleHandling(vehicleElement, "tractionLoss", (1 + tractionAdjustment) * tractorHandling.tractionLoss)
				setVehicleHandling(vehicleElement, "brakeDeceleration", (1 - tractionAdjustment) * tractorHandling.brakeDeceleration)

				local tractorCOM = tractorHandling.centerOfMass
				local trailerCOM = trailerHandling.centerOfMass

				tractorCOM[1] = 0
				tractorCOM[2] = -0.15
				tractorCOM[3] = -0.95

				setVehicleHandling(vehicleElement, "centerOfMass", tractorCOM)
				setVehicleHandling(vehicleElement, "suspensionFrontRearBias", 0.5)
				setVehicleHandling(vehicleElement, "suspensionAntiDiveMultiplier", 0)
			end
		end]]
    end
end

--[[
local handlingFlags = { 
	_1G_BOOST = 0x1, 
	_2G_BOOST = 0x2, 
	NPC_ANTI_ROLL = 0x4, 
	NPC_NEUTRAL_HANDL = 0x8, 
	NO_HANDBRAKE = 0x10, 
	STEER_REARWHEELS = 0x20, 
	HB_REARWHEEL_STEER = 0x40, 
	ALT_STEER_OPT = 0x80, 
	WHEEL_F_NARROW2 = 0x100, 
	WHEEL_F_NARROW = 0x200, 
	WHEEL_F_WIDE = 0x400, 
	WHEEL_F_WIDE2 = 0x800, 
	WHEEL_R_NARROW2 = 0x1000, 
	WHEEL_R_NARROW = 0x2000, 
	WHEEL_R_WIDE = 0x4000, 
	WHEEL_R_WIDE2 = 0x8000, 
	HYDRAULIC_GEOM = 0x10000, 
	HYDRAULIC_INST = 0x20000, 
	HYDRAULIC_NONE = 0x40000, 
	NOS_INST = 0x80000, 
	OFFROAD_ABILITY = 0x100000, 
	OFFROAD_ABILITY2 = 0x200000, 
	HALOGEN_LIGHTS = 0x400000, 
	PROC_REARWHEEL_1ST = 0x800000, 
	USE_MAXSP_LIMIT = 0x1000000, 
	LOW_RIDER = 0x2000000, 
	STREET_RACER = 0x4000000,
	SWINGING_CHASSIS = 0x10000000
}

local function isFlagSet(val, flag) 
	return (bitAnd(val, flag) == flag)
end

local function getVehicleHandlingFlags(vehicleElement) 
	local vehicleHandling = getVehicleHandling(vehicleElement)
	local flags = vehicleHandling["handlingFlags"]

	local handlingFlag = {}
	local flagBytes = 0

	for flagName, flagValue in pairs(handlingFlags) do
		if isFlagSet(flags, flagValue) then
			handlingFlag[flagName] = true
			flagBytes = flagBytes + flagValue
		end
	end

	return handlingFlag, flagBytes
end

local function updateVehicleHandlingFlag(vehicle, flag, enable)
    local flagsKeyed, currentFlagBytes = getVehicleHandlingFlags(vehicle)
    local initialFlagBytes = currentFlagBytes

    for flagKey in pairs(flagsKeyed) do
        if string.find(flagKey, flag) then
			local bytes = modelFlags[flagKey] or 0
            currentFlagBytes = currentFlagBytes - bytes
        end
    end

    if enable then
		local bytes = modelFlags[flag] or 0
        currentFlagBytes = currentFlagBytes + bytes
    end

    if initialFlagBytes ~= currentFlagBytes then
        setVehicleHandling(vehicle, "modelFlags", currentFlagBytes)
    end
end

function makeTuning(vehicleElement)
    if isElement(vehicleElement) then
		local vehicleModel = getElementModel(vehicleElement)
        local customModelHandling = customHandling[vehicleModel]
		local defaultModelHandling = getOriginalHandling(vehicleModel)

        for handlingProperty, propertyValue in pairs(defaultModelHandling) do
            setVehicleHandling(vehicleElement, handlingProperty, propertyValue)
        end

        if customModelHandling then
            for handlingProperty, propertyValue in pairs(customModelHandling) do
                if handlingProperty == "handlingFlags" then
                    local appliedFlags = getVehicleHandlingFlags(vehicleElement)
                    local flagBits = tonumber(propertyValue) or 0

					for flagName in pairs(appliedFlags) do
                        if handlingFlags[flagName] then
                            flagBits = flagBits + (handlingFlags[flagName] or 0)
                        end
                    end

                    setVehicleHandling(vehicleElement, "handlingFlags", flagBits)
                else
                    setVehicleHandling(vehicleElement, handlingProperty, propertyValue)
                end
            end
        end

		if customFlags[vehicleModel] then
			local modelFlags = customFlags[vehicleModel]
		
			if modelFlags.removeHandling then
				for flag in pairs(modelFlags.removeHandling) do
					updateVehicleHandlingFlag(vehicleElement, flag, false)
				end
			end
		
			if modelFlags.removeModel then
				for flag in pairs(modelFlags.removeModel) do
					updateVehicleHandlingFlag(vehicleElement, flag, false)
				end
			end
		
			if modelFlags.addHandling then
				for flag in pairs(modelFlags.addHandling) do
					updateVehicleHandlingFlag(vehicleElement, flag, true)
				end
			end
		
			if modelFlags.addModel then
				for flag in pairs(modelFlags.addModel) do
					updateVehicleHandlingFlag(vehicleElement, flag, true)
				end
			end
		end

		local tuningDataValues = {}
		local tuningDataKeys = {
			["vehicle.tuning.Engine"] = true,
			["vehicle.tuning.Turbo"] = true,
			["vehicle.tuning.ECU"] = true,
			["vehicle.tuning.Transmission"] = true,
			["vehicle.tuning.Suspension"] = true,
			["vehicle.tuning.Brakes"] = true,
			["vehicle.tuning.Tires"] = true,
			["vehicle.tuning.WeightReduction"] = true
		}
		
		for dataName in pairs(tuningDataKeys) do
			local dataValue = getElementData(vehicleElement, dataName) or 0
			if dataValue > 0 then
				tuningDataValues[dataName:match("([^%.]+)$")] = dataValue
			end
		end
		
		local propertiesToRestore = {}
		for effectName in pairs(tuningDataValues) do
			for propertyName in pairs(tuningEffect[effectName]) do
				propertiesToRestore[propertyName] = true
			end
		end
		
		local handlingTable = customModelHandling or defaultModelHandling
		for propertyName, propertyValue in pairs(handlingTable) do
			if propertiesToRestore[propertyName] then
				setVehicleHandling(vehicleElement, propertyName, propertyValue)
			end
		end
		
		local currentHandling = getVehicleHandling(vehicleElement)
		local appliedHandling = {}
		
		for effectName, effectValue in pairs(tuningDataValues) do
			if effectValue ~= 0 then
				for propertyName, propertyValue in pairs(tuningEffect[effectName]) do
					if currentHandling[propertyName] and propertyValue[effectValue] then
						appliedHandling[propertyName] = appliedHandling[propertyName] or currentHandling[propertyName]
						appliedHandling[propertyName] = appliedHandling[propertyName] + appliedHandling[propertyName] * (propertyValue[effectValue] / 135)
					end
				end
			end
		end
		
		for propertyName, propertyValue in pairs(appliedHandling) do
			setVehicleHandling(vehicleElement, propertyName, propertyValue)
		end		

		local vehicleDriveType = getElementData(vehicleElement, "vehicle.tuning.DriveType")
		local vehicleSteeringLock = getElementData(vehicleElement, "vehicle.tuning.SteeringLock") or 0

		local vehicleHandlingFlags = getElementData(vehicleElement, "vehicle.handlingFlags")
		if vehicleHandlingFlags then
			setVehicleHandling(vehicleElement, "handlingFlags", vehicleHandlingFlags)
		end

		if vehicleDriveType == "fwd" or vehicleDriveType == "rwd" or vehicleDriveType == "awd" then
			setVehicleHandling(vehicleElement, "driveType", vehicleDriveType)
		elseif vehicleDriveType == "tog" then
			setVehicleHandling(vehicleElement, "driveType", getElementData(vehicleElement, "activeDriveType") or "awd")
		end
		
		if vehicleSteeringLock ~= 0 then
			setVehicleHandling(vehicleElement, "steeringLock", vehicleSteeringLock)
		end

		if doubleExhaust[vehicleModel] then
			setVehicleHandling(vehicleElement, "modelFlags", 0x00002000)
		elseif noExhaust[vehicleModel] then
			setVehicleHandling(vehicleElement, "modelFlags", 0x00001000)
		end

		local ecuTuning = getElementData(vehicleElement, "vehicle.tuning.ECU") or false
		local airRideTuning = getElementData(vehicleElement, "vehicle.tuning.AirRide") or false

		if (ecuTuning and tonumber(ecuTuning)) == 5 then
			local currentHandling = getVehicleHandling(vehicleElement)
			local ecuDatas = getElementData(vehicleElement, "vehicle.ecu") or {
				balance = 0,
				settings = { 0, 0, 0, 0, 0, 0 },
				defaultSettings = { 0, 0, 0, 0, 0, 0 },
				multiplier = 1
			}

			local maxVelocity = currentHandling.maxVelocity
			local engineAcceleration = currentHandling.engineAcceleration
			local engineInertia = currentHandling.engineInertia
			local dragCoeff = currentHandling.dragCoeff
			local multipler = ecuDatas.multiplier
			local balance = ecuDatas.balance

			local realMultipler = (math.abs(balance) * multipler)

			if balance > 0 then
				engineAcceleration = engineAcceleration + realMultipler * 5
				maxVelocity = maxVelocity + realMultipler * 30
			else
				engineAcceleration = engineAcceleration + realMultipler * 15
				maxVelocity = maxVelocity - realMultipler * 30
				dragCoeff = 1
			end
			engineInertia = engineInertia + realMultipler * 50

			setVehicleHandling(vehicleElement, "maxVelocity", maxVelocity)
			setVehicleHandling(vehicleElement, "engineAcceleration", engineAcceleration)
			setVehicleHandling(vehicleElement, "engineInertia", engineInertia)
			setVehicleHandling(vehicleElement, "dragCoeff", dragCoeff)
		end

		if (airRideTuning and tonumber(airRideTuning)) == 1 then
			local arirrideBias = getElementData(vehicleElement, "airrideBias") or 0
			local airrideLevel = getElementData(vehicleElement, "airrideLevel") or 0
			local airrideSoftness = getElementData(vehicleElement, "airrideSoftness") or 0

			local centerOfMass = getVehicleHandling(vehicleElement).centerOfMass
			local suspensionLowerLimit = getVehicleHandling(vehicleElement).suspensionLowerLimit
			local suspensionDamping = getVehicleHandling(vehicleElement).suspensionDamping

			centerOfMass[2] = centerOfMass[2] + arirrideBias / 10
			suspensionLowerLimit = suspensionLowerLimit + airrideLevel * 0.015
			suspensionDamping = suspensionDamping + airrideSoftness * 0.5
			
			setVehicleHandling(vehicleElement, "centerOfMass", centerOfMass)
			setVehicleHandling(vehicleElement, "suspensionLowerLimit", suspensionLowerLimit)
			setVehicleHandling(vehicleElement, "suspensionDamping", suspensionDamping)

			triggerClientEvent("gotVehicleAirRide", vehicleElement, airrideLevel, arirrideBias, airrideSoftness)
		else
			triggerClientEvent("gotVehicleAirRide", vehicleElement)
		end
    end
end]]

addEventHandler("onResourceStart", resourceRoot,
	function()
		for k, v in pairs(getElementsByType("vehicle")) do
			setElementData(v, "appliedHandling", false)
		end
	end
)

addEventHandler("onPlayerVehicleEnter", root,
	function(vehicle, seat)
		if isElement(source) then
			if isElement(vehicle) and seat == 0 and not getElementData(vehicle, "appliedHandling") then
				setElementData(vehicle, "appliedHandling", true)
				applyHandling(vehicle)
				makeTuning(vehicle)
			end
		end
	end
)

addCommandHandler("tuningveh",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			local currentVeh = getPedOccupiedVehicle(sourcePlayer)

			if currentVeh then
				setElementData(currentVeh, "vehicle.tuning.Engine", 4)
				setElementData(currentVeh, "vehicle.tuning.Turbo", 4)
				setElementData(currentVeh, "vehicle.tuning.ECU", 4)
				setElementData(currentVeh, "vehicle.tuning.Transmission", 4)
				setElementData(currentVeh, "vehicle.tuning.Suspension", 4)
				setElementData(currentVeh, "vehicle.tuning.Brakes", 4)
				setElementData(currentVeh, "vehicle.tuning.Tires", 4)
				setElementData(currentVeh, "vehicle.tuning.WeightReduction", 4)
				makeTuning(currentVeh)
				outputChatBox("Jármű kifullozva.", sourcePlayer)
			end
		end
	end)


addCommandHandler("awd",
	function (sourcePlayer, commandName)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			local currentVeh = getPedOccupiedVehicle(sourcePlayer)

			if currentVeh then
				setElementData(currentVeh, "vehicle.tuning.DriveType", "awd")
				makeTuning(currentVeh)
				outputChatBox("összkerék beszerelve.", sourcePlayer)
			end
		end
	end)