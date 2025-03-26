local turboVehs = {}

function setVehicleTurbo(veh)
    local customTurbo = getElementData(veh, "vehicle.customTurbo")
    local customTurboDatas = getElementData(veh, "vehicle.tuning.customTurbo")

    if customTurbo == 1 and customTurboDatas then
        if turboVehs[veh] then
            if isElement(turboVehs[veh].sound) then
                destroyElement(turboVehs[veh].sound)
            end
            turboVehs[veh].sound = false
        end

        turboVehs[veh] = {
            gainSoundVol = customTurboDatas[1],
            gainSound = customTurboDatas[2],
            wasteGateSoundVol = customTurboDatas[3],
            wasteGateSound = customTurboDatas[4],
            sound = false,
            progress = 0,
            vehSpeed = getVehicleSpeed(veh) or 0,
            vehGear = getVehicleCurrentGear(veh),
            vehGearSpeeds = {},
            vol = 0,
            turboSpeed = 0,
            discharge = 1,
            lastSpeed = 0
        }
    end
end

function destroyVehicleTurbo(veh)
    if turboVehs[veh] then
        if isElement(turboVehs[veh].sound) then
            destroyElement(turboVehs[veh].sound)
        end
        turboVehs[veh].sound = false

        turboVehs[veh] = nil
    end
end

function getVehicleSpeed(veh)
    if isElement(veh) then
        local x, y, z = getElementVelocity(veh)
        return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
    end
end

addEventHandler("onClientPreRender", getRootElement(), function(delta)
    for veh, data in pairs(turboVehs) do
        local engine = getVehicleEngineState(veh)
        local speed = getVehicleSpeed(veh)
        local gear = getVehicleCurrentGear(veh)

        if engine then
            local acceleration = math.max(-0.5, (speed - (turboVehs[veh].lastSpeed or 0)) * (delta / 1000) * 100)
            turboVehs[veh].lastSpeed = speed

            if data.vehGear ~= gear then
                if gear > turboVehs[veh].vehGear then
                    if gear > 1 then
                        speed = speed - 20
                    end
                    turboVehs[veh].vehGearSpeeds[gear] = speed

                    local sound = playSound3D("files/boff" .. data.wasteGateSound .. ".wav", 0, 0, 0)
                    setElementDimension(sound, getElementDimension(veh))
                    setElementInterior(sound, getElementInterior(veh))
                    local x, y, z = getVehicleDummyPosition(veh, "engine")
                    attachElements(sound, veh, x, y, z)
                    setSoundVolume(sound, data.vol * 0.6 * 1.2 * data.wasteGateSoundVol)
                    setSoundMaxDistance(sound, 20 + 20 * data.vol)
                    if turboVehs[veh].discharge then
                        turboVehs[veh].discharge = 5.5
                    end
                end
                turboVehs[veh].vehGear = gear
            end

            speed = math.min(2, math.max(0, (speed - (turboVehs[veh].vehGearSpeeds[gear] or 0)) / 30) - 0.35) * 1.05 + acceleration * 0.8
            speed = math.min(speed, 3)
            if turboVehs[veh].discharge and turboVehs[veh].discharge > 0.85 then
                turboVehs[veh].discharge = turboVehs[veh].discharge - 1.8 * delta / 1000
            end
        end

        if turboVehs[veh].vehSpeed > speed then
            turboVehs[veh].vehSpeed = turboVehs[veh].vehSpeed - turboVehs[veh].discharge * delta / 1000
            if speed > turboVehs[veh].vehSpeed then
                turboVehs[veh].vehSpeed = speed
            end
        else
            turboVehs[veh].vehSpeed = turboVehs[veh].vehSpeed + 0.75 * delta / 1000
            if speed < turboVehs[veh].vehSpeed then
                turboVehs[veh].vehSpeed = speed
            end
        end

        if engine then
            if turboVehs[veh].sound then
                local pitch = math.min(math.max(0.3, turboVehs[veh].vehSpeed * 1.15), 4) + 0.25
                turboVehs[veh].vol = getEasingValue(math.max(math.min(turboVehs[veh].vehSpeed * 2 - 0.5, 1), 0), "OutQuad") * 0.8 + math.max(0, 0.25 * (pitch - 1) / 3)
                setSoundVolume(turboVehs[veh].sound, turboVehs[veh].vol * 0.135 * 1.2 * turboVehs[veh].gainSoundVol)
                setSoundSpeed(turboVehs[veh].sound, pitch * 0.35)
                setSoundMaxDistance(turboVehs[veh].sound, 20 + 20 * turboVehs[veh].vol)
            else
                if isElement(turboVehs[veh].sound) then
                    destroyElement(turboVehs[veh].sound)
                end
                turboVehs[veh].sound = playSound3D("files/turbo" .. turboVehs[veh].gainSound .. ".wav", 0, 0, 0, true)
                setElementDimension(turboVehs[veh].sound, getElementDimension(veh))
                setElementInterior(turboVehs[veh].sound, getElementInterior(veh))
                setSoundVolume(turboVehs[veh].sound, 0)
                local x, y, z = getVehicleDummyPosition(veh, "engine")
                attachElements(turboVehs[veh].sound, veh, x, y, z)
            end
        elseif turboVehs[veh].sound then
            if isElement(turboVehs[veh].sound) then
                destroyElement(turboVehs[veh].sound)
            end
            turboVehs[veh].sound = nil
        end

        if turboVehs[veh].vehSpeed > 5 then
            turboVehs[veh].vehSpeed = 0
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k, v in pairs(getElementsByType("vehicle", getRootElement(), true)) do
        local customTurbo = getElementData(v, "vehicle.tuning.customTurbo")
        if customTurbo then
            setVehicleTurbo(v)
        end
    end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        local customTurbo = getElementData(source, "vehicle.tuning.customTurbo")
        if customTurbo then
            setVehicleTurbo(source)
        end
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
    if turboVehs[source] then
        destroyVehicleTurbo(source)
    end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if turboVehs[source] then
        destroyVehicleTurbo(source)
    end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" then
        if dataName == "vehicle.customTurbo" then
            if newValue == 1 then
                setVehicleTurbo(source)
            elseif newValue == 0 then
                destroyVehicleTurbo(source)
            end
        end

        local turbo = getElementData(source, "vehicle.customTurbo") or 0
        if dataName == "vehicle.tuning.customTurbo" and turbo == 1 then
            setVehicleTurbo(source)
        end
    end
end)

function getVehicleTurboDatas(vehicleElement)
    if turboVehs[vehicleElement] then
        return turboVehs[vehicleElement]
    end

    return false
end

local screenX, screenY = guiGetScreenSize()
local turboDatas = {
    gainSoundVol = 1,
    gainSound = 0,
    wasteGateSoundVol = 1,
    wasteGateSound = 0,
}

function createTurboEditor(x, y)
    if isPedInVehicle(localPlayer) then
        local customTurbo = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurbo")
        local customTurboDatas = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.customTurbo")

        if customTurbo == 1 and customTurboDatas then
            turboDatas = {
                gainSoundVol = customTurboDatas[1],
                gainSound = customTurboDatas[2],
                wasteGateSoundVol = customTurboDatas[3],
                wasteGateSound = customTurboDatas[4],
            }
            setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurboTemp", turboDatas)
        end

        local sx, sy = 300, 200
        turboRectangle = exports.seal_gui:createGuiElement("rectangle", x, y, sx, sy)
		exports.seal_gui:setGuiBackground(turboRectangle, "solid", "grey1")


        local label = exports.seal_gui:createGuiElement("label", 6, 0, sx, 36, turboRectangle)
		exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(label, "Turbo szerkesztés")
		exports.seal_gui:setLabelAlignment(label, "left", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 61, sx - 12, 10, turboRectangle)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "updateTurboSoundVol")
        exports.seal_gui:setSliderValue(slider, math.round(turboDatas.gainSoundVol, 2))
        local label = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Töltőnyomás hangereje")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        turboSoundVol = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(turboSoundVol, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(turboSoundVol, math.round(turboDatas.gainSoundVol, 2))
        exports.seal_gui:setLabelAlignment(turboSoundVol, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 100, sx - 12, 10, turboRectangle)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "updateTurboSound")
        exports.seal_gui:setSliderValue(slider, turboDatas.gainSound/8)
        local label = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Töltőnyomás hangja")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        turboSound = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(turboSound, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(turboSound, turboDatas.gainSound)
        exports.seal_gui:setLabelAlignment(turboSound, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 142, sx - 12, 10, turboRectangle)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "updateTurboWasteGateSoundVol")
        exports.seal_gui:setSliderValue(slider, math.round(turboDatas.wasteGateSoundVol, 2))
        local label = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Wastegate szelep hangerő")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wasteGateSoundVol = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(wasteGateSoundVol, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wasteGateSoundVol, math.round(turboDatas.wasteGateSoundVol, 2))
        exports.seal_gui:setLabelAlignment(wasteGateSoundVol, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 184, sx - 12, 10, turboRectangle)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "updateTurboWasteGateSound")
        exports.seal_gui:setSliderValue(slider, turboDatas.wasteGateSound/8)
        local label = exports.seal_gui:createGuiElement("label", 6, 163, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Wastegate szelep típus")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wasteGateSound = exports.seal_gui:createGuiElement("label", 6, 163, sx - 12, 10, turboRectangle)
        exports.seal_gui:setLabelFont(wasteGateSound, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wasteGateSound, turboDatas.wasteGateSound)
        exports.seal_gui:setLabelAlignment(wasteGateSound, "right", "center")

        addEventHandler("onClientKey", root, turboTestKey)
    end
end

function deleteTurboEditor()
    if exports.seal_gui:isGuiElementValid(turboRectangle) then
        exports.seal_gui:deleteGuiElement(turboRectangle)
    end

    turboDatas = {
        gainSoundVol = 1,
        gainSound = 0,
        wasteGateSoundVol = 1,
        wasteGateSound = 0,
    }

    removeEventHandler("onClientKey", root, turboTestKey)
end

addEvent("updateTurboSound", true)
addEventHandler("updateTurboSound", root,
    function (el, value)
        if exports.seal_gui:isGuiElementValid(turboSound) then
            local value = math.floor(value*8)
            value = math.max(1, math.min(8, value))
            exports.seal_gui:setLabelText(turboSound, value)
            turboDatas.gainSound = value
            setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurboTemp", turboDatas)
        end
    end
)

addEvent("updateTurboSoundVol", true)
addEventHandler("updateTurboSoundVol", root,
    function (el, value)
        if exports.seal_gui:isGuiElementValid(turboSoundVol) then
            exports.seal_gui:setLabelText(turboSoundVol, math.round(value, 2))
            turboDatas.gainSoundVol = math.round(value, 2)
            setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurboTemp", turboDatas)
        end
    end
)

addEvent("updateTurboWasteGateSound", true)
addEventHandler("updateTurboWasteGateSound", root,
    function (el, value)
        if exports.seal_gui:isGuiElementValid(wasteGateSound) then
            local value = math.floor(value*18)
            value = math.max(1, math.min(18, value))
            exports.seal_gui:setLabelText(wasteGateSound, value)
            turboDatas.wasteGateSound = value
            setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurboTemp", turboDatas)
        end
    end
)

addEvent("updateTurboWasteGateSoundVol", true)
addEventHandler("updateTurboWasteGateSoundVol", root,
    function (el, value)
        if exports.seal_gui:isGuiElementValid(wasteGateSoundVol) then
            exports.seal_gui:setLabelText(wasteGateSoundVol, math.round(value, 2))
            turboDatas.wasteGateSoundVol = math.round(value, 2)
            setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurboTemp", turboDatas)
        end
    end
)

function turboTestKey(key, state)
    if exports.seal_gui:isGuiElementValid(turboRectangle) and isPedInVehicle(localPlayer) then
        if key == "lalt" and state then
            local veh = getPedOccupiedVehicle(localPlayer)
            local id = turboDatas.gainSound
            local boff = turboDatas.wasteGateSound
            local sv = turboDatas.gainSoundVol
            local bv = turboDatas.wasteGateSoundVol

            previewTurboSound(veh, id, boff, sv, bv)
        end
    end
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

local turboPreviewProgress = false
local turboPreviewSound = false
local turboPreviewSoundId = false
local turboPreviewBlowoffSound = false
local turboPreivewVol = 0
local turboPreviewSoundVol = 1
local turboPreviewBoffVol = 1

function previewTurboSound(veh, id, boff, sv, bv)
    turboPreviewVeh = veh

    if not turboPreviewProgress then
        if isElement(veh) then
            turboPreviewProgress = 0
            turboPreivewVol = 0
            turboPreviewSoundVol = sv
            turboPreviewBoffVol = bv

            if sv <= 0.05 then
                turboPreviewProgress = 2.5
                if turboPreviewSoundId == 1 then
                    local pitch = math.min(math.max(0.2, turboPreviewProgress * 1.7), 4) + 0.2
                    turboPreivewVol = getEasingValue(math.max(math.min(turboPreviewProgress * 3 - 0.5, 1), 0), "OutQuad") + math.max(0, 0.15 * (pitch - 0.8) / 3)
                else
                    local pitch = math.min(math.max(0.3, turboPreviewProgress * 1.15), 4) + 0.25
                    turboPreivewVol = getEasingValue(math.max(math.min(turboPreviewProgress * 2 - 0.5, 1), 0), "OutQuad") * 0.8 + math.max(0, 0.25 * (pitch - 1) / 3)
                end
            else
                turboPreviewSound = playSound3D("files/turbo" .. id .. ".wav", 0, 0, 0, true)
                setElementDimension(turboPreviewSound, getElementDimension(veh))
                setElementInterior(turboPreviewSound, getElementInterior(veh))
                setSoundVolume(turboPreviewSound, 0)
                local x, y, z = getVehicleDummyPosition(veh, "engine")
                attachElements(turboPreviewSound, veh, x, y, z)
                turboPreviewSoundId = id
            end

            turboPreviewBlowoffSound = boff
            addEventHandler("onClientPreRender", getRootElement(), turboPreviewPreRender)
        end
    else
        turboPreviewProgress = 2.5
    end
end

function turboPreviewPreRender(delta)
    turboPreviewProgress = turboPreviewProgress + 1 * delta / 1000

    if 2.5 < turboPreviewProgress or not isElement(turboPreviewVeh) then
        removeEventHandler("onClientPreRender", getRootElement(), turboPreviewPreRender)

        if isElement(turboPreviewSound) then
            destroyElement(turboPreviewSound)
        end

        if isElement(turboPreviewVeh) then
            local s = playSound3D("files/boff" .. turboPreviewBlowoffSound .. ".wav", 0, 0, 0)
            setElementDimension(s, getElementDimension(turboPreviewVeh))
            setElementInterior(s, getElementInterior(turboPreviewVeh))
            setSoundMaxDistance(s, 20 + 20 * turboPreivewVol)
            setSoundVolume(s, turboPreivewVol * 0.6 * 1.15 * turboPreviewBoffVol)
            local x, y, z = getVehicleDummyPosition(turboPreviewVeh, "engine")
            attachElements(s, turboPreviewVeh, x, y, z)
        end

        turboPreviewBlowoffSound = false
        turboPreivewVol = 0
        turboPreviewSoundVol = 1
        turboPreviewBoffVol = 1
        turboPreviewSoundId = false
        turboPreviewSound = false
        turboPreviewProgress = false
        turboPreviewVeh = false
    elseif turboPreviewSoundId == 1 then
        local pitch = math.min(math.max(0.2, turboPreviewProgress * 1.7), 4) + 0.2
        local vol = getEasingValue(math.max(math.min(turboPreviewProgress * 3 - 0.5, 1), 0), "OutQuad") + math.max(0, 0.15 * (pitch - 0.8) / 3)
        setSoundVolume(turboPreviewSound, vol * 0.125 * 1.15 * turboPreviewSoundVol)
        setSoundMaxDistance(turboPreviewSound, 20 + 20 * vol)
        turboPreivewVol = vol
        setSoundSpeed(turboPreviewSound, pitch * 0.75)
    else
        local pitch = math.min(math.max(0.3, turboPreviewProgress * 1.15), 4) + 0.25
        local vol = getEasingValue(math.max(math.min(turboPreviewProgress * 2 - 0.5, 1), 0), "OutQuad") * 0.8 + math.max(0, 0.25 * (pitch - 1) / 3)
        setSoundVolume(turboPreviewSound, vol * 0.135 * 1.15 * turboPreviewSoundVol)
        setSoundMaxDistance(turboPreviewSound, 20 + 20 * vol)
        turboPreivewVol = vol
        setSoundSpeed(turboPreviewSound, pitch * 0.35)
    end
end