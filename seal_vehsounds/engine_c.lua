-- engine_c.lua

ENGINE_ENABLED = true -- Enables/disables the resource
GEAR_SHIFT_SOUNDS_ENABLED = true -- Enable/disable gear shift sounds
GEAR_SHIFT_SOUNDS_VOLUME = 1.5 -- Volume of gear shift sounds
ENGINE_VOLUME_MASTER = 0.3 -- 0.3 - Volume multiplier
ENGINE_VOLUME_IDLE = 1.0 -- 0.5 - Idle speed volume
ENGINE_VOLUME_THROTTLE_BOOST = 2.5 -- Increasing the engine volume if we use the accelerator
ENGINE_SOUND_FADE_DIMENSION = 6969 -- Dimension for unload sounds
ENGINE_SOUND_DISTANCE = 70 -- Maximum distance
REV_LIMITER_ENABLED = true -- Enable/Disable Rev Limiter
DEBUG = false -- Show debug information

local vehicleSettings = {
	[580] = {revlim = true, revmul = 1.5}, -- Brabus Rocket 900 (Alpha)
	[547] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
	[517] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
	[585] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
    [546] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
	[540] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
	[404] = {revlim = true, revmul = 0.8}, -- Brabus Rocket 900 (Alpha)
}

-- Variables to determine the type of exhaust
local allowedExhaustBytes = { ["2"] = true, ["6"] = true, ["A"] = true, ["E"] = true }
local allowedExhaustTypes = { ["0"] = true, ["1"] = false, ["2"] = true, ["3"] = false }

-- Gear shift sounds table by category
local gearShiftSounds = {
    default = {400, 401, 405, 409},
    truck = {403, 514, 515, 532},
	bmw = {429},
	porsche = {580, 517},
    motorcycle = {581, 521, 522, 461, 463, 468},
    dsg = {404},

}

-- Function to get the vehicle sound category
function getVehicleCategory(model)
    for category, models in pairs(gearShiftSounds) do
        if table.contains(models, model) then
            return category
        end
    end
    return "default"
end

-- Function to check if a table contains a value
function table.contains(tab, val)
    for i = 1, #tab do
        if tab[i] == val then
            return true
        end
    end
    return false
end

-- Function to get the position of the exhaust dummies
function getVehicleExhaustPositions(vehicle)
    local positions = {}
    local modelFlags = getVehicleHandling(vehicle).modelFlags
    local fourthByte = string.format("%08X", modelFlags):reverse():sub(4, 4)
    local twoExhaust = allowedExhaustTypes[fourthByte] and allowedExhaustBytes[fourthByte]
    local oneExhaust = allowedExhaustTypes[fourthByte]

    if not oneExhaust then
        return positions
    end

    local exhX, exhY, exhZ = getVehicleDummyPosition(vehicle, "exhaust")
    if not exhX then
        return positions
    end

    table.insert(positions, {exhX, exhY, exhZ})
    if twoExhaust then
        table.insert(positions, {-exhX, exhY, exhZ})
    end

    return positions
end

local streamedVehicles = {}
local pi = math.pi

-- Caches frequently used functions
local getElementPosition = getElementPosition
local getElementRotation = getElementRotation
local getElementVelocity = getElementVelocity
local getVehicleHandling = getVehicleHandling
local getVehicleController = getVehicleController
local getPedControlState = getPedControlState
local getPedAnalogControlState = getPedAnalogControlState
local isElement = isElement
local isElementFrozen = isElementFrozen
local isElementInWater = isElementInWater
local isLineOfSightClear = isLineOfSightClear
local getPedOccupiedVehicle = getPedOccupiedVehicle
local getDistanceBetweenPoints3D = getDistanceBetweenPoints3D
local interpolateBetween = interpolateBetween
local playSound3D = playSound3D
local setSoundEffectEnabled = setSoundEffectEnabled
local setSoundVolume = setSoundVolume
local setSoundSpeed = setSoundSpeed
local setElementPosition = setElementPosition
local setElementDimension = setElementDimension
local setSoundMaxDistance = setSoundMaxDistance
local createEffect = createEffect
local setEffectSpeed = setEffectSpeed
local setEffectDensity = setEffectDensity
local destroyElement = destroyElement
local setTimer = setTimer

-- Function to calculate vehicle gear ratios
function calculateGearRatios(vehicle, maxRPM, startRatio)
    local ratios = {}
    local handling = getVehicleHandling(vehicle)
    local gears = math.max(4, handling.numberOfGears)
    local maxVelocity = handling.maxVelocity
    local acc = handling.engineAcceleration
    local drag = handling.dragCoeff
    local curGear, curRatio = 1, 0
    local mRPM = maxVelocity * 100
    mRPM = ((maxRPM * gears) / mRPM) * maxRPM

    repeat
        if mRPM / curGear > maxRPM * curRatio then
            curRatio = curRatio + 0.1 / curGear
        else
            ratios[curGear] = curRatio * 0.95
            curGear = curGear + 1
            curRatio = 0
        end
    until #ratios == gears

    ratios[0] = 0
    ratios[-1] = ratios[1]
    return ratios
end

local lastRevLimiterTick = 0
local lastSoundUpdateTick = 0

-- Function to check if the vehicle is reving
function isVehicleReving(vehicle)
    if vehicle and isElement(vehicle) then
        local controller = getVehicleController(vehicle)
        if controller == localPlayer then
            local velocity = (Vector3(getElementVelocity(vehicle))).length * 180
            local handbrake = getPedControlState(controller, "handbrake")
            local brake = getPedControlState(controller, "brake_reverse")
            local accelerate = getPedControlState(controller, "accelerate")
            local engineOn = getVehicleEngineState(vehicle)

            return engineOn and velocity < 2 and (handbrake or brake) and accelerate
        end
    end
    return false
end

-- Function to stream the vehicle
function streamInVehicle(vehicle)
    if not streamedVehicles[vehicle] then
        if isElement(vehicle) and getElementData(vehicle, "vehicle:engine") and getElementData(vehicle, "vehicle.customVehicleEngine") then
            streamedVehicles[vehicle] = {}
            addEventHandler("onClientElementDestroy", vehicle, function()
                streamOutVehicle(source)
            end)
        end
    end
end

-- Function to check if rev limiter effect should be applied
function shouldApplyRevLimiter(vehicle)
    local model = getElementModel(vehicle)
    local settings = vehicleSettings[model] or {}
    return settings.revlim == true
end

-- Function to get rev limiter multiplier
function getRevLimiterMultiplier(vehicle)
    local model = getElementModel(vehicle)
    local settings = vehicleSettings[model] or {}
    return settings.revmul or 1
end

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
        if dataName == "vehicle.customVehicleEngine" then
            if newValue then
                streamedVehicles[source] = nil
                setTimer(streamInVehicle, 2000, 1, source)
            else
                streamOutVehicle(source)
            end
        end
    end
end)

-- Function to update engines
function updateEngines(dt)
    if not ENGINE_ENABLED then return end

    local myVehicle = getPedOccupiedVehicle(localPlayer)
    if myVehicle and getVehicleController(myVehicle) ~= localPlayer then
        myVehicle = false
    end

    local cx, cy, cz = getCameraMatrix()
    local now = getTickCount()
    for vehicle, data in pairs(streamedVehicles) do
        if isElement(vehicle) then
            local engine = getElementData(vehicle, "vehicle:engine")
            
            if engine then
                local x, y, z = getElementPosition(vehicle)
                local rx, ry, rz = getElementRotation(vehicle)
                local distance = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)

                if getVehicleEngineState(vehicle) == true and distance < ENGINE_SOUND_DISTANCE * 2 then
                    local model = getElementModel(vehicle)
                    local handling = getVehicleHandling(vehicle)
                    local velocityVec = Vector3(getElementVelocity(vehicle))
                    local velocity = velocityVec.length * 180
                    local controller = getVehicleController(vehicle)
                    local upgrades = getElementData(vehicle, "vehicle:upgrades") or {}
                    engine.gear = engine.gear or 1
                    local settings = vehicleSettings[model] or {}
                    engine.volMult = engine.volMult or 1
                    engine.shiftUpRPM = engine.shiftUpRPM or engine.maxRPM * 0.91
                    engine.shiftDownRPM = engine.shiftDownRPM or (engine.idleRPM + engine.maxRPM) / 2.5

                    data.prevThrottle = data.throttle
                    data.throttle = controller and (getPedControlState(controller, "accelerate"))
                    if not data.reverse and velocity < 10 then
                        data.reverse = controller and (getPedAnalogControlState(controller, "brake_reverse") > 0.5) or false
                    elseif data.throttle and velocity < 50 then
                        data.reverse = false
                    end

                    local isSkidding = controller and ((getPedControlState(controller, "accelerate") and getPedControlState(controller, "brake_reverse") or getPedControlState(controller, "handbrake")) and velocity < 40) or false
                    data.forceNeutral = isSkidding -- w/s or handbrake no motion: neutral gear
                        or (isLineOfSightClear(x, y, z, x, y, z - (getElementDistanceFromCentreOfMassToBaseOfModel(vehicle) * 1.25), true, false, false, true, true, false, false, vehicle) and data.throttle) -- vehicle in the air: neutral gear
                        or isElementFrozen(vehicle) or isElementInWater(vehicle) -- frozen / in water: neutral gear
                        or ((rx > 110) and (rx < 250)) -- on the roof: neutral gear

                    data.groundRPM = data.groundRPM or 0
                    data.throttlingRPM = data.throttlingRPM or 0
                    data.previousGear = data.previousGear or engine.gear
                    data.gear = data.gear or 1
                    data.currentGear = data.currentGear or 1
                    data.changingGear = type(data.changingGear) == "number" and data.changingGear or false
                    data.changingRPM = data.changingRPM or 0
                    data.changingTargetRPM = data.changingTargetRPM or 0
                    data.effects = data.effects or {}
                    local changedGear = false
                    local gearRatios = calculateGearRatios(vehicle, engine.maxRPM, engine.startRatio or 1)
                    local soundPack = engine.soundPack
                    local wheel_rpm = velocity * 100
                    local rpm = wheel_rpm -- engine rpm

                    if getVehicleController(vehicle) then
                        rpm = rpm * gearRatios[data.gear]
                    else
                        rpm = engine.idleRPM
                    end

                    if not data.forceNeutral then
                        data.throttlingRPM = math.max(0, data.throttlingRPM - (engine.maxRPM * 0.0012) * dt)
                    else
                        if data.throttle then
                            data.throttlingRPM = data.throttlingRPM + (engine.maxRPM * 0.0012) * dt
                        else
                            data.throttlingRPM = math.max(0, data.throttlingRPM - (engine.maxRPM * 0.0012) * dt)
                        end
                        data.throttlingRPM = math.min(data.throttlingRPM, engine.maxRPM)
                    end

                    rpm = rpm + data.throttlingRPM
                    rpm = rpm + data.changingRPM
					
					if data.changingGear then
						local progress = (now-data.changingTargetRPM.time) / 300 -- how long
						data.changingRPM = interpolateBetween(data.changingTargetRPM.target, 0, 0, 0, 0, 0, progress, "InQuad")
						
						if progress >= 1 then
							data.changingGear = false
							data.changingGearDirection = false
							data.changingRPM = 0
							data.changingTargetRPM = false
						end
					end

                    if data.previousGear ~= data.currentGear then
                        changedGear = (data.currentGear < data.previousGear) and "down" or "up"
                        data.changingGear = data.currentGear
                        data.changingGearDirection = changedGear
                        local nextrpm = engine.maxRPM
                        if gearRatios[data.changingGear] then
                            nextrpm = wheel_rpm * gearRatios[data.changingGear]
                        end
                        data.changingRPM = rpm - nextrpm
                        data.changingTargetRPM = {target = data.changingRPM, time = now}
                        data.gear = data.currentGear

                        -- Play gear shift sound
                        if GEAR_SHIFT_SOUNDS_ENABLED and velocity > 0 then
                            local category = getVehicleCategory(model)
                            local soundFileUp = "sounds/gearshifts/" .. category .. "/gearup.wav"
                            local soundFileDown = "sounds/gearshifts/" .. category .. "/geardn.wav"
                            local soundFile = changedGear == "up" and soundFileUp or soundFileDown
                            if soundFile then
                                local gearShiftSound = playSound3D(soundFile, x, y, z, false)
                                setSoundVolume(gearShiftSound, GEAR_SHIFT_SOUNDS_VOLUME * ENGINE_VOLUME_MASTER)
                                setSoundMaxDistance(gearShiftSound, ENGINE_SOUND_DISTANCE)
                                setElementDimension(gearShiftSound, getElementDimension(vehicle))
                            end
                        end
                    end

                    data.previousGear = data.currentGear

                    if not data.changingGear and data.throttlingRPM == 0 and wheel_rpm > 200 then
                        if rpm > engine.shiftUpRPM and data.throttle then
                            data.currentGear = math.min(data.currentGear + 1, math.max(4, getVehicleHandling(vehicle).numberOfGears))
                        elseif rpm < engine.shiftDownRPM then
                            data.currentGear = math.max(1, data.currentGear - 1)
                        end
                    end

                    if rpm < engine.idleRPM then
                        rpm = engine.idleRPM + math.random(0, 100)
                    elseif rpm > engine.maxRPM then
                        rpm = engine.maxRPM - math.random(0, 100)
                        data.wasRevLimited = true
                    end

                    if data.wasRevLimited then
                        if (data.rpm or 0) < engine.maxRPM * 0.98 then
                            data.wasRevLimited = false
                        end
                    end

                    data.rpm = rpm

                    local svol = {}
                    if not data.sounds then
                        data.sounds = {}
                        data.sounds[1] = playSound3D("sounds/" .. soundPack .. "/idle.wav", x, y, z, true)
                        data.sounds[2] = playSound3D("sounds/" .. soundPack .. "/low.wav", x, y, z, true)
                        data.sounds[3] = playSound3D("sounds/" .. soundPack .. "/high.wav", x, y, z, true)

                        for i = 1, 3 do
                            setSoundEffectEnabled(data.sounds[i], "compressor", true)
                        end
                    else
                        local minMidProgress = math.min(1, (rpm + 500) / (engine.maxRPM / 2))
                        local maxMidProgress = minMidProgress - ((engine.maxRPM / 2) / rpm)
                        local highProgress = (rpm - (engine.maxRPM / 2.2)) / (engine.maxRPM / 2.2)
                        svol[1] = 1 - 2 ^ (rpm / (engine.idleRPM * 1.5) - 2)
                        svol[2] = minMidProgress < 1 and interpolateBetween(0, 0, 0, 0.8, 0, 0, minMidProgress, "InQuad") or interpolateBetween(0.8, 0, 0, 0, 0, 0, maxMidProgress, "OutQuad")
                        svol[3] = interpolateBetween(0, 0, 0, 1, 0, 0, highProgress, "OutQuad")

                        local vol = svol[1]
                        vol = vol * ENGINE_VOLUME_IDLE * engine.volMult
                        if data.throttle then
                            vol = vol * ENGINE_VOLUME_THROTTLE_BOOST
                        end
                        setSoundVolume(data.sounds[1], math.max(0, vol))
                        setSoundSpeed(data.sounds[2], rpm / (engine.idleRPM * 2))

                        vol = svol[2]
                        vol = vol * ENGINE_VOLUME_MASTER * engine.volMult
                        if data.throttle then
                            vol = vol * ENGINE_VOLUME_THROTTLE_BOOST
                        end
                        if data.changingGearDirection == "up" and vol > 0.1 then
                            vol = vol / 2
                        end
                        setSoundVolume(data.sounds[2], math.max(0, vol))
                        setSoundSpeed(data.sounds[2], rpm / (engine.maxRPM * 0.6))

                        vol = svol[3]
                        vol = vol * ENGINE_VOLUME_MASTER * engine.volMult
                        if data.throttle then
                            vol = vol * ENGINE_VOLUME_THROTTLE_BOOST
                        end
                        if data.changingGearDirection == "up" and vol > 0.1 then
                            vol = vol / 2
                        end

                        -- "Rev limiter" effect on high RPM
                        if REV_LIMITER_ENABLED and (isVehicleReving(vehicle) or (not isVehicleOnGround(vehicle) and data.throttle)) and shouldApplyRevLimiter(vehicle) then
                            local revMultiplier = getRevLimiterMultiplier(vehicle)
                            if (now - lastRevLimiterTick) > (100 / revMultiplier) then
                                setSoundSpeed(data.sounds[3], 0.7 * revMultiplier)
                                lastRevLimiterTick = now
                            else
                                setSoundSpeed(data.sounds[3], rpm / (engine.maxRPM * 0.925))
                            end
                        else
                            setSoundSpeed(data.sounds[3], rpm / (engine.maxRPM * 0.925))
                        end
                        setSoundVolume(data.sounds[3], math.max(0, vol))

                        -- Add gear shift effects to high RPM
                        if changedGear then
                            local originalVolume = getSoundVolume(data.sounds[3])
                            local originalSpeed = getSoundSpeed(data.sounds[3])

                            if GEAR_SHIFT_STYLES == 1 then
                                -- Soft Style
                                if changedGear == "up" then
                                    -- Smooth transition with no noticeable effects
                                    setSoundVolume(data.sounds[3], originalVolume)
                                    setSoundSpeed(data.sounds[3], originalSpeed)
                                elseif changedGear == "down" then
                                    setSoundVolume(data.sounds[3], originalVolume)
                                    setSoundSpeed(data.sounds[3], originalSpeed)
                                end
                            elseif GEAR_SHIFT_STYLES == 2 then
                                -- Noticeable Style
                                if changedGear == "up" then
                                    setSoundVolume(data.sounds[3], originalVolume * 0.3)
                                    setSoundSpeed(data.sounds[3], originalSpeed * 0.5)
                                elseif changedGear == "down" then
                                    setSoundVolume(data.sounds[3], originalVolume * 1.8)
                                    setSoundSpeed(data.sounds[3], originalSpeed * 1.6)
                                end
                            elseif GEAR_SHIFT_STYLES == 3 then
                                -- Impactful Style
                                if changedGear == "up" then
                                    setSoundVolume(data.sounds[3], originalVolume * 0.1)
                                    setSoundSpeed(data.sounds[3], originalSpeed * 0.4)
                                elseif changedGear == "down" then
                                    setSoundVolume(data.sounds[3], originalVolume * 2.0)
                                    setSoundSpeed(data.sounds[3], originalSpeed * 1.8)
                                end
                            end

                            setTimer(function()
                                if data.sounds[3] then
                                    setSoundVolume(data.sounds[3], originalVolume)
                                    setSoundSpeed(data.sounds[3], originalSpeed)
                                end
                            end, 500, 1)
                        end

                        for i = 1, #data.sounds do
                            local v = data.sounds[i]
                            if isElement(v) then
                                setElementPosition(v, x, y, z)
                                setElementDimension(v, (svol[i] or 1) > 0 and getElementDimension(vehicle) or ENGINE_SOUND_FADE_DIMENSION)
                                if vehicle == getPedOccupiedVehicle(localPlayer) then
                                    setSoundMaxDistance(v, ENGINE_SOUND_DISTANCE * 2)
                                else
                                    setSoundMaxDistance(v, ENGINE_SOUND_DISTANCE)
                                end
                            end
                        end

                        local rx, ry, rz = getElementRotation(vehicle)
                        for ef, offset in pairs(data.effects) do
                            if isElement(ef) then
                                local ox, oy, oz = getPositionFromElementOffset(vehicle, offset[1], offset[2], offset[3])
                                setElementPosition(ef, ox, oy, oz)
                                setElementRotation(ef, offset[4] - rx, offset[5] - ry, offset[6] - rz)
                            end
                        end
                    end

                    if DEBUG and vehicle == myVehicle then
                        dxDrawText("Silnik\nTyp: " .. tostring(engine.name) .. "\nRPM: " .. tostring(rpm) .. "\nVol1: " .. tostring(svol[1]) .. "\nVol2: " .. tostring(svol[2]) .. "\nVol3: " .. tostring(svol[3]) .. "\nTurboVol: " .. tostring(svol[4]), 300, 300)
                        local t = "Biegi\nBieg: " .. tostring(data.gear) .. "/" .. tostring(#gearRatios) .. "\n"
                        for k, v in ipairs(gearRatios) do
                            t = t .. "Ratio " .. tostring(k) .. ": " .. v .. "\n"
                        end
                        dxDrawText(t, 300, 440)
                    end
                else
                    if data.sounds and type(data.sounds) == "table" then
                        for k, v in ipairs(data.sounds) do
                            if isElement(v) then
                                destroyElement(v)
                            end
                        end
                        data.sounds = false
                    end
                    data.rpm = 0
                    data.gear = 1
                    data.previousGear = 0
                end
            else
                if data and data.sounds then
                    for i = 1, 3 do
                        if data.sounds[i] then
                            if isElement(data.sounds[i]) then
                                destroyElement(data.sounds[i])
                            end
                        end
                    end

                    data.sounds = false
                end
            end
        end
    end
end
addEventHandler("onClientPreRender", root, updateEngines)


-- Function to stream out from the vehicle
function streamOutVehicle(vehicle)
    if streamedVehicles[vehicle] then
        if streamedVehicles[vehicle].sounds then
            for k, v in ipairs(streamedVehicles[vehicle].sounds) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
        end
        streamedVehicles[vehicle] = nil
    end
end

-- Function to get vehicle RPM in standard GTA
function getGTARPM(vehicle)
    if vehicle then
        local velocityVec = Vector3(getElementVelocity(vehicle))
        local velocity = velocityVec.length * 180
        if isVehicleOnGround(vehicle) then
            if getVehicleEngineState(vehicle) == true then
                if getVehicleCurrentGear(vehicle) > 0 then
                    vehicleRPM = math.floor(((velocity / getVehicleCurrentGear(vehicle)) * 150) + 0.5)
                    if vehicleRPM < 650 then
                        vehicleRPM = math.random(650, 750)
                    elseif vehicleRPM >= 8000 then
                        vehicleRPM = 8000
                    end
                else
                    vehicleRPM = math.floor(((velocity / 1) * 220) + 0.5)
                    if vehicleRPM < 650 then
                        vehicleRPM = math.random(650, 750)
                    elseif vehicleRPM >= 8000 then
                        vehicleRPM = 8000
                    end
                end
            else
                vehicleRPM = 0
            end
        else
            if getVehicleEngineState(vehicle) == true then
                vehicleRPM = vehicleRPM - 150
                if vehicleRPM < 650 then
                    vehicleRPM = math.random(650, 750)
                elseif vehicleRPM >= 8000 then
                    vehicleRPM = 8000
                end
            else
                vehicleRPM = 0
            end
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

-- EXPORTS
-- Function to obtain the vehicle's RPM
function getVehicleRPM(vehicle)
    if streamedVehicles[vehicle] then
        return streamedVehicles[vehicle].rpm or getGTARPM(vehicle)
    else
        return getGTARPM(vehicle)
    end
end

-- Function to obtain the vehicle's gear
function getVehicleGear(vehicle)
    if streamedVehicles[vehicle] then
        return streamedVehicles[vehicle].gear or getVehicleCurrentGear(vehicle)
    else
        return getVehicleCurrentGear(vehicle)
    end
end

-- Function to activate/deactivate the engines
function toggleEngines(bool)
    ENGINE_ENABLED = bool
    if bool == true then
        for k, v in ipairs(getElementsByType("vehicle", root, true)) do
            streamInVehicle(v)
        end
    else
        for vehicle, data in pairs(streamedVehicles) do
            streamOutVehicle(vehicle)
        end
        streamedVehicles = {}
    end
end

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then
        streamInVehicle(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    streamOutVehicle(source)
end)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
    if seat == 0 then
        setTimer(streamInVehicle, 200, 1, source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    toggleEngines(true)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k, v in pairs(streamedVehicles) do
        if v.sounds and #v.sounds > 0 then
            for _, sound in pairs(v.sounds) do
                if isElement(sound) then
                    destroyElement(sound)
                end
            end
        end
    end
end)

-- Function to get position from element offset
function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element) -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] -- Apply transformation
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z -- Returns the transformed point
end

-- Adding world sound interceptor to disable original sounds
local exceptionGroups = { [17] = true, [19] = true, [6] = true }
local vehicleTypesToExclude = { "BMX", "Boat", "Plane", "Helicopter", "Train", "Trailer" }
local rcVehicles = { [441] = true, [464] = true, [594] = true, [501] = true, [465] = true, [564] = true }

addEventHandler("onClientWorldSound", root, function(group)
    if getElementData(source, "vehicle.customVehicleEngine") then
        if getElementType(source) == "vehicle" and not exceptionGroups[group] then
            local vehicleType = getVehicleType(source)
            local model = getElementModel(source)
            if not tableContains(vehicleTypesToExclude, vehicleType) and not rcVehicles[model] then
                cancelEvent()
            end
        end
    end
end)

function tableContains(tab, val)
    for index, value in pairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end