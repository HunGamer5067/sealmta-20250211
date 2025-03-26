local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif getResourceName(res) == "steel_connection" then
        connection = exports.seal_database:getConnection()
    end
end)

addEvent("requestECUData", true)
addEventHandler("requestECUData", getRootElement(), function()
    checkCanUse(source, "drivetype")
    if checkCanUse(source, "ecu") then
        local ecuData = getElementData(source, "vehicle.ecu") or {
            balance = 0,
            settings = { 0, 0, 0, 0, 0, 0 },
        }

        if ecuData then
            triggerClientEvent(client, "gotVehicleEcuData", source, ecuData.balance, ecuData.settings)
        end
    else
        triggerClientEvent(client, "gotVehicleEcuData", source)
    end
end)

addEvent("saveEcuData", true)
addEventHandler("saveEcuData", getRootElement(), function(newBalance, newSettings)
    if checkCanUse(source, "ecu") then
        local ecuData = getElementData(source, "vehicle.ecu") or {
            balance = 0,
            defaultSettings = { 0, 0, 0, 0, 0, 0 },
        }

        if ecuData then
            local vehicleId = getElementData(source, "vehicle.dbID")
            local validECUValue = 0

            for i = 1, #newSettings do
                local relativeValue = calculateRelativeValue(newSettings[i], ecuData.defaultSettings[i])
                validECUValue = validECUValue + relativeValue
            end

            local averageMultiplier = validECUValue / #ecuData.defaultSettings
            triggerClientEvent("gotVehicleEcuData", source, newBalance, newSettings)

            local values = {
                balance = newBalance,
                settings = newSettings,
                defaultSettings = ecuData.defaultSettings,
                multiplier = averageMultiplier
            }

            setElementData(source, "vehicle.ecu", values)
            exports.seal_tuning:makeTuning(source)
            dbExec(connection, "UPDATE vehicles SET ecu = ? WHERE vehicleId = ?", toJSON(values), vehicleId)
        end
    end
end)

addCommandHandler("loadbestecu", function(client)
	if getElementData(client, "acc.adminLevel") >= 7 then
		local vehicle = getPedOccupiedVehicle(client)

		if vehicle then
			local vehicleId = getElementData(vehicle, "vehicle.dbID")
            local ecuData = getElementData(vehicle, "vehicle.ecu")

			ecuData.settings = ecuData.defaultSettings
            setElementData(vehicle, "vehicle.ecu", ecuData)
			dbExec(connection, "UPDATE vehicles SET ecu = ? WHERE vehicleId = ?", toJSON(ecuData), vehicleId)
			triggerClientEvent("gotVehicleEcuData", vehicle, ecuData.balance, ecuData.settings)
			outputChatBox("[color=green][SealMTA]: [color=hudwhite]A best ecu sikeresen betöltve.", client, 255, 255, 255, true)
		else
			outputChatBox("[color=red][SealMTA - Hiba]: [color=hudwhite]Nem ülsz járműben.", client, 255, 255, 255, true)
		end
	end
end)

addEvent("requestDriveTypeData", true)
addEventHandler("requestDriveTypeData", getRootElement(), function()
    if checkCanUse(source, "drivetype") then
        local drivetype = getElementData(source, "activeDriveType") or "awd"
        triggerClientEvent(client, "gotVehicleDriveTypeData", source, drivetype)
    end
end)

addEvent("setCurrentVehicleDriveType", true)
addEventHandler("setCurrentVehicleDriveType", getRootElement(), function(drivetype)
    if checkCanUse(source, "drivetype") then
        setElementData(source, "activeDriveType", drivetype)
        triggerClientEvent("gotVehicleDriveTypeData", source, drivetype)
        exports.seal_tuning:makeTuning(source)
    end
end)

addEvent("requestAirrideData", true)
addEventHandler("requestAirrideData", getRootElement(), function()
    if checkCanUse(source, "airride") then
        local bias = getElementData(source, "airrideBias") or 0
        local level = getElementData(source, "airrideLevel") or 0
        local softness = getElementData(source, "airrideSoftness") or 0
        triggerClientEvent(client, "gotVehicleAirRide", source, level, bias, softness)
    else
        triggerClientEvent(client, "gotVehicleAirRide", source, false, false, false)
    end
end)

local lastAirrideInteract = {}

addEvent("setVehicleAirRideLevel", true)
addEventHandler("setVehicleAirRideLevel", getRootElement(), function(newLevel, playerSync)
    if checkCanUse(source, "airride") then
        local vehicleId = getElementData(source, "vehicle.dbID")
        local currentBias = getElementData(source, "airrideBias") or 0
        local currentLevel = getElementData(source, "airrideLevel") or 0
        local currentSoftness = getElementData(source, "airrideSoftness") or 0

        if lastAirrideInteract[client] and (getTickCount() - lastAirrideInteract[client]) < 1000 then
            triggerClientEvent("gotVehicleAirRide", source, currentLevel, currentBias, currentSoftness)
            return
        end
        lastAirrideInteract[client] = getTickCount()

        local vehicleModel = getElementModel(source)
        local vehicleHandling = exports.seal_tuning:getHandlingTable(vehicleModel).suspensionLowerLimit

        if vehicleHandling.suspensionLowerLimit then
            suspensionLowerLimit = vehicleHandling.suspensionLowerLimit
        else
            local vehicleHandling = getModelHandling(vehicleModel)
            suspensionLowerLimit = vehicleHandling.suspensionLowerLimit
        end

        local suspensionLowerLimit = suspensionLowerLimit + newLevel * 0.015
        setVehicleHandling(source, "suspensionLowerLimit", suspensionLowerLimit)
        
        setElementData(source, "airrideLevel", newLevel)
        dbExec(connection, "UPDATE vehicles SET airrideLevel = ? WHERE vehicleId = ?", newLevel, vehicleId)

		if playerSync then
			triggerClientEvent(playerSync, "airrideSound", client)
		end

		triggerClientEvent("gotVehicleAirRide", source, newLevel, currentBias, currentSoftness)
    else
        triggerClientEvent("gotVehicleAirRide", source)
        setElementData(source, "vehradio.menu", "home")
    end
end)

addEvent("setVehicleAirRideBias", true)
addEventHandler("setVehicleAirRideBias", getRootElement(), function(newLevel, playerSync)
    if checkCanUse(source, "airride") then
        local vehicleId = getElementData(source, "vehicle.dbID")
        local currentBias = getElementData(source, "airrideBias") or 0
        local currentLevel = getElementData(source, "airrideLevel") or 0
        local currentSoftness = getElementData(source, "airrideSoftness") or 0

        if lastAirrideInteract[client] and (getTickCount() - lastAirrideInteract[client]) < 1000 then
            triggerClientEvent("gotVehicleAirRide", source, currentLevel, currentBias, currentSoftness)
            return
        end
        lastAirrideInteract[client] = getTickCount()

        local vehicleModel = getElementModel(source)
        local vehicleHandling = exports.seal_tuning:getHandlingTable(vehicleModel)

        if vehicleHandling.centerOfMass then
            centerOfMass = vehicleHandling.centerOfMass
        else
            local vehicleHandling = getModelHandling(vehicleModel)
            centerOfMass = vehicleHandling.centerOfMass
        end

		centerOfMass[2] = centerOfMass[2] + newLevel / 10
        setVehicleHandling(source, "centerOfMass", centerOfMass)

        setElementData(source, "airrideBias", newLevel)
        dbExec(connection, "UPDATE vehicles SET airrideBias = ? WHERE vehicleId = ?", newLevel, vehicleId)

		if playerSync then
			triggerClientEvent(playerSync, "airrideSound", client)
		end

		triggerClientEvent("gotVehicleAirRide", source, currentLevel, newLevel, currentSoftness)
    else
        triggerClientEvent("gotVehicleAirRide", source)
        setElementData(source, "vehradio.menu", "home")
    end
end)

addEvent("setVehicleAirRideSoftness", true)
addEventHandler("setVehicleAirRideSoftness", getRootElement(), function(newLevel, playerSync)
    if checkCanUse(source, "airride") then
        local vehicleId = getElementData(source, "vehicle.dbID")
        local currentBias = getElementData(source, "airrideBias") or 0
        local currentLevel = getElementData(source, "airrideLevel") or 0
        local currentSoftness = getElementData(source, "airrideSoftness") or 0

        if lastAirrideInteract[client] and (getTickCount() - lastAirrideInteract[client]) < 1000 then
            triggerClientEvent("gotVehicleAirRide", source, currentLevel, currentBias, currentSoftness)
            return
        end
        lastAirrideInteract[client] = getTickCount()

        local vehicleModel = getElementModel(source)
        local vehicleHandling = exports.seal_tuning:getHandlingTable(vehicleModel)

        if vehicleHandling.suspensionDamping then
            suspensionDamping = vehicleHandling.suspensionDamping
        else
            local vehicleHandling = getModelHandling(vehicleModel)
            suspensionDamping = vehicleHandling.suspensionDamping
        end

        local suspensionDamping = suspensionDamping + newLevel * 0.5
        setVehicleHandling(source, "suspensionDamping", suspensionDamping)

        setElementData(source, "airrideSoftness", newLevel)
        dbExec(connection, "UPDATE vehicles SET airrideSoftness = ? WHERE vehicleId = ?", newLevel, vehicleId)

		if playerSync then
			triggerClientEvent(playerSync, "airrideSound", client)
		end

		triggerClientEvent("gotVehicleAirRide", source, currentLevel, currentBias, newLevel)
    else
        triggerClientEvent("gotVehicleAirRide", source)
        setElementData(source, "vehradio.menu", "home")
    end
end)

addEventHandler("onElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" then
        if dataName == "vehicle.tuning.ECU" then
            if newValue == 5 then
                local ecuData = getElementData(source, "vehicle.ecu")
                if ecuData then
                    triggerClientEvent("gotVehicleEcuData", source, ecuData.balance, ecuData.settings)
                end
            elseif oldValue == 5 then
                triggerClientEvent("gotVehicleEcuData", source)
            end

            exports.seal_tuning:makeTuning(source)
        elseif dataName == "vehicle.tuning.DriveType" then
            if newValue == "tog" then
                local drivetype = getElementData(source, "activeDriveType") or "awd"
                triggerClientEvent("gotVehicleDriveTypeData", source, drivetype)
            elseif oldValue == "tog" then
                triggerClientEvent("gotVehicleDriveTypeData", source)
            end

            exports.seal_tuning:makeTuning(source)
        elseif dataName == "vehicle.tuning.AirRide" then
            if newValue and newValue == 1 then
                local currentBias = getElementData(source, "airrideBias") or 0
                local currentLevel = getElementData(source, "airrideLevel") or 0
                local currentSoftness = getElementData(source, "airrideSoftness") or 0
                triggerClientEvent("gotVehicleAirRide", source, currentLevel, currentBias, currentSoftness)
            elseif oldValue and oldValue == 1 then
                triggerClientEvent("gotVehicleAirRide", source)
            end

            exports.seal_tuning:makeTuning(source)
        end
    end
end)

function checkCanUse(vehicleElement, tuningType)
    if vehicleElement and tuningType then
        if tuningType == "ecu" then
            local ecu = getElementData(vehicleElement, "vehicle.tuning.ECU") or 0
            
            if ecu == 5 then
                return true
            end
        elseif tuningType == "drivetype" then
            local drivetype = getElementData(vehicleElement, "vehicle.tuning.DriveType") or false

            if drivetype == "tog" then
                return true
            end
        elseif tuningType == "airride" then
            local airride = getElementData(vehicleElement, "vehicle.tuning.AirRide") or 0

            if airride == 1 then
                return true
            end
        end
    end

    return false
end

function calculateRelativeValue(value, base)
    local difference = math.abs(value - base)
    local relativeValue = 1 / (difference + 1)
    return relativeValue
end