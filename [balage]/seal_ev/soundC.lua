local vehicleSounds = {}
local vehicleSpeeds = {}
local accelerationStates = {}

local streamedElectricVehicles = {}

local disabledSoundGroups = {
    [40] = true,
}

for groupID = 7, 16 do
    disabledSoundGroups[groupID] = true
end

local function handleEvSounds(groupID, soundID)
    if disabledSoundGroups[groupID] or (groupID == 19 and (soundID == 37 or soundID == 19 or soundID == 20)) then
        cancelEvent()
    end
end

local function getVehicleSpeed(vehicle)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 187.5
    end

    return 0
end

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        local vehicleModel = getElementModel(source)

        if chargingPortOffset[vehicleModel] then
            streamedElectricVehicles[source] = true
            vehicleSpeeds[source] = 0
            accelerationStates[source] = 0

            addEventHandler("onClientWorldSound", source, handleEvSounds)
        end
    end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        if streamedElectricVehicles[source] then
            streamedElectricVehicles[source] = nil
            vehicleSpeeds[source] = nil
            accelerationStates[source] = nil

            removeEventHandler("onClientWorldSound", source, handleEvSounds)
        end
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        if streamedElectricVehicles[source] then
            streamedElectricVehicles[source] = nil
            vehicleSpeeds[source] = nil
            accelerationStates[source] = nil

            removeEventHandler("onClientWorldSound", source, handleEvSounds)
        end
    end

    if vehicleSounds[source] then
        if isElement(vehicleSounds[source]) then
            destroyElement(vehicleSounds[source])
        end
        vehicleSounds[source] = nil
    end
end)

addEventHandler("onClientPreRender", getRootElement(), function(deltaTime)
    local vehicles = getElementsByType("vehicle", getRootElement(), true)

    for _, vehicle in ipairs(vehicles) do
        local engineState = getVehicleEngineState(vehicle)
        local vehicleModel = getElementModel(vehicle)
        
        if not streamedElectricVehicles[vehicle] and chargingPortOffset[vehicleModel] then
            streamedElectricVehicles[vehicle] = true
            vehicleSpeeds[vehicle] = 0
            accelerationStates[vehicle] = 0

            addEventHandler("onClientWorldSound", vehicle, handleEvSounds)
        end
          
        if engineState and streamedElectricVehicles[vehicle] then
            if not isElement(vehicleSounds[vehicle]) then
                vehicleSounds[vehicle] = playSound3D("sounds/ev.mp3", 0, 0, 0, true)
                setElementDimension(vehicleSounds[vehicle], getElementDimension(vehicle))
                setElementInterior(vehicleSounds[vehicle], getElementInterior(vehicle))
                setSoundMaxDistance(vehicleSounds[vehicle], 40)
                attachElements(vehicleSounds[vehicle], vehicle)
            end

            local currentSpeed = getVehicleSpeed(vehicle)
            local previousSpeed = vehicleSpeeds[vehicle] or 0
            local acceleration = (currentSpeed - previousSpeed) / deltaTime * 17

            vehicleSpeeds[vehicle] = currentSpeed

            if acceleration > 0 then
                accelerationStates[vehicle] = math.min(
                    1 + math.min(1, math.max(0, acceleration)) * 0.125,
                    (accelerationStates[vehicle] or 0) + deltaTime / 250 * math.min(1, acceleration / 0.1 * currentSpeed / 5)
                )
            else
                accelerationStates[vehicle] = math.max(0, (accelerationStates[vehicle] or 0) - deltaTime / 3000)
            end

            local volumeFactor = 1
            local speedFactor = 1

            setSoundVolume(vehicleSounds[vehicle], math.min(accelerationStates[vehicle], currentSpeed / 10) * 0.175 * volumeFactor)
            setSoundSpeed(vehicleSounds[vehicle], (0.5 + math.min(1.5, currentSpeed / 200)) * speedFactor)
        elseif vehicleSounds[vehicle] then
            if isElement(vehicleSounds[vehicle]) then
                destroyElement(vehicleSounds[vehicle])
            end
            vehicleSounds[vehicle] = nil
        end
    end
end)
