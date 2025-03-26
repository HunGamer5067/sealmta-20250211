local engineCoolingSound = {}

local config = {
    soundMaxDistance = 60,
    soundVolume = 0.5,
}

local function isSoundFinished(sound)
    if not sound or not isElement(sound) then return true end
    return getSoundPosition(sound) == getSoundLength(sound)
end

addEvent("onCustomSoundPlay3D", true)
addEventHandler("onCustomSoundPlay3D", root, function(soundPath, looped)
    local x, y, z = getElementPosition(source)
    local sound = playSound3D(soundPath, x, y, z, looped or false)
    attachElements(sound, source)
    setSoundMaxDistance(sound, config.soundMaxDistance)
    setSoundVolume(sound, config.soundVolume)
end)

addEvent("stopEngineCoolingSound", true)
addEventHandler("stopEngineCoolingSound", root, function(vehicle)
    if engineCoolingSound[vehicle] and not isSoundFinished(engineCoolingSound[vehicle]) then
        stopSound(engineCoolingSound[vehicle])
        engineCoolingSound[vehicle] = nil
    end
end)