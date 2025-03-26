--[[-- Server-side Script

local vehicleEngineStates = {}
local vehicleEngineToggleLock = {}
local vehicleBlacklist = { [509] = true, [481] = true, [510] = true }

local soundPaths = {
    lockDoors = "sounds/doorlock.wav",
    unlockDoors = "sounds/doorlock.wav",
    turnOnLights = "sounds/lightswitch.wav",
    turnOffLights = "sounds/lightswitch.wav"
}

local function isVehicleBlacklisted(vehicle)
    return vehicleBlacklist[getElementModel(vehicle)] == true
end

-- Função para verificar se uma string termina com outra string
local function stringEndsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- Implementação da função getFilesInResourceFolder usando pathListDir
local function getFilesInResourceFolder(path)
    local files = {}
    local entries = pathListDir(path) or {}
    for _, entry in ipairs(entries) do
        if stringEndsWith(entry, ".wav") then
            table.insert(files, path .. "/" .. entry)
        end
    end
    return files
end

local function getSoundPropertiesFromFiles()
    local files = getFilesInResourceFolder("sounds/engines")
    local soundProperties = {}

    for _, file in ipairs(files) do
        local vehicleIds = {}
        for ids in string.gmatch(file, "(%d+[-%d]*)_startup") do
            for id in string.gmatch(ids, "(%d+)") do
                table.insert(vehicleIds, tonumber(id))
            end
        end
        for ids in string.gmatch(file, "(%d+[-%d]*)_shutdwn") do
            for id in string.gmatch(ids, "(%d+)") do
                table.insert(vehicleIds, tonumber(id))
            end
        end
        local delay = tonumber(string.match(file, "_(%d+)ms")) or config.defaultDelay
        table.insert(soundProperties, {path = file, ids = vehicleIds, delay = delay})
    end

    return soundProperties
end

local function getVehicleSoundPaths(vehicleModel, soundType)
    for _, prop in ipairs(config.soundProperties) do
        for _, id in ipairs(prop.ids) do
            if id == vehicleModel then
                if string.find(prop.path, soundType) then
                    return prop.path, prop.delay
                end
            end
        end
    end
    return nil, config.defaultDelay
end

local function isMotorcycle(vehicle)
    return getVehicleType(vehicle) == "Bike"
end

local function isQuad(vehicle)
    return getVehicleType(vehicle) == "Quad"
end

local function hasDoors(vehicle)
    return getVehicleType(vehicle) ~= "Bike" and getVehicleType(vehicle) ~= "Quad"
end

local function initializeVehicleState(vehicle)
    if isVehicleBlacklisted(vehicle) then return end
    vehicleEngineStates[vehicle] = false
    setVehicleEngineState(vehicle, false)
end

local function playSound3DForVehicle(vehicle, soundType)
    local model = getElementModel(vehicle)
    local soundPath, delay = getVehicleSoundPaths(model, soundType)
    if soundPath then
        triggerClientEvent(root, "onCustomSoundPlay3D", vehicle, soundPath)
    end
end

local function playAdditionalSound(vehicle, soundType)
    local soundPath = soundPaths[soundType]
    if soundPath then
        triggerClientEvent(root, "onCustomSoundPlay3D", vehicle, soundPath)
    end
end

local function startEngineWithDelay(vehicle)
    local model = getElementModel(vehicle)
    local soundPath, delay = getVehicleSoundPaths(model, "startup")
    triggerClientEvent(root, "stopEngineCoolingSound", vehicle, vehicle)
    playSound3DForVehicle(vehicle, "startup")
    setTimer(function(v)
        if isElement(v) and getVehicleController(v) then
            setVehicleEngineState(v, true)
            vehicleEngineStates[v] = true
        end
    end, delay, 1, vehicle)
end

addEventHandler("onPlayerVehicleEnter", root, function(vehicle, seat)
    if not vehicleEngineStates[vehicle] then
        initializeVehicleState(vehicle)
    end
    if seat == 0 then
        if not vehicleEngineStates[vehicle] then
            startEngineWithDelay(vehicle)
        end
    end
end)

addEventHandler("onPlayerVehicleExit", root, function(vehicle, seat)
    if seat == 0 then
        vehicleEngineStates[vehicle] = getVehicleEngineState(vehicle)
        setVehicleLocked(vehicle, false)
    end
end)

local function autoLockDoors(vehicle)
    local lockSpeed = getElementData(vehicle, "autoLockSpeed")
    if lockSpeed then
        local speedx, speedy, speedz = getElementVelocity(vehicle)
        local actualSpeed = (speedx^2 + speedy^2 + speedz^2)^0.5 * 180
        if actualSpeed >= lockSpeed and not isVehicleLocked(vehicle) then
            setVehicleLocked(vehicle, true)
            playAdditionalSound(vehicle, "lockDoors")
            removeElementData(vehicle, "autoLockSpeed")
        end
    end
end

local function checkAutoLock()
    for _, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementData(vehicle, "autoLockSpeed") then
            autoLockDoors(vehicle)
        end
    end
end
setTimer(checkAutoLock, 1000, 0)

addEvent("toggleEngine", true)
addEventHandler("toggleEngine", resourceRoot, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle and getVehicleOccupant(vehicle, 0) == player and not isVehicleBlacklisted(vehicle) then
        if vehicleEngineToggleLock[vehicle] then return end
        local engineState = getVehicleEngineState(vehicle)
        local soundType = engineState and "shutdwn" or "startup"
        local _, delay = getVehicleSoundPaths(getElementModel(vehicle), soundType)
        vehicleEngineToggleLock[vehicle] = true
        setTimer(function(v)
            vehicleEngineToggleLock[v] = nil
        end, delay + 250, 1, vehicle)
        if not engineState then
            startEngineWithDelay(vehicle)
        else
            playSound3DForVehicle(vehicle, "shutdwn")
            setTimer(function(v)
                if isElement(v) then
                    setVehicleEngineState(v, false)
                    vehicleEngineStates[v] = false
                    triggerClientEvent(root, "playEngineCoolingSound", v)
                end
            end, delay, 1, vehicle)
        end
    end
end)

addEvent("toggleLock", true)
addEventHandler("toggleLock", resourceRoot, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle and hasDoors(vehicle) then
        local lockState = not isVehicleLocked(vehicle)
        setVehicleLocked(vehicle, lockState)
        playAdditionalSound(vehicle, lockState and "lockDoors" or "unlockDoors")
    end
end)

addEvent("toggleLights", true)
addEventHandler("toggleLights", resourceRoot, function(player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle and getVehicleOccupant(vehicle, 0) == player then
        local lightsState = getVehicleOverrideLights(vehicle)
        if lightsState == 2 then
            setVehicleOverrideLights(vehicle, 1)
            playAdditionalSound(vehicle, "turnOffLights")
        else
            setVehicleOverrideLights(vehicle, 2)
            playAdditionalSound(vehicle, "turnOnLights")
        end
    end
end)

-- Load sound properties on resource start
addEventHandler("onResourceStart", resourceRoot, function()
    local soundProperties = getSoundPropertiesFromFiles()
    config.soundProperties = soundProperties
    triggerClientEvent("onServerSendSoundProperties", resourceRoot, soundProperties)
end)

-- Configurações compartilhadas

config = {
    soundMaxDistance = 60,
    soundVolume = 0.5,
    keyToggleEngine = "j",
    keyToggleLock = "k",
    keyToggleLights = "l",
    defaultDelay = 500,
    soundProperties = {}
}

-- Definido apenas para fins de referência compartilhada
function setSoundProperties(properties)
    config.soundProperties = properties
end
]]