--[[addCommandHandler("setturbo", function(sourcePlayer, commandName, loadVolume, loadSound, wasteGateVolume, wasteGateSound)
    loadVolume = tonumber(loadVolume)
    loadSound = tonumber(loadSound)
    wasteGateVolume = tonumber(wasteGateVolume)
    wasteGateSound = tonumber(wasteGateSound)
    if (loadVolume and loadSound and wasteGateVolume and wasteGateSound) then
        loadVolume = math.max(0, math.min(1, loadVolume))
        loadSound = math.max(1, math.min(8, loadSound))
        wasteGateVolume = math.max(0, math.min(1, wasteGateVolume))
        wasteGateSound = math.max(1, math.min(16, wasteGateSound))

        local veh = getPedOccupiedVehicle(sourcePlayer)
        if veh then
            setElementData(veh, "vehicle.tuning.customTurbo", {loadVolume, loadSound, wasteGateVolume, wasteGateSound})
            outputChatBox("siker " .. inspect(getElementData(veh, "vehicle.tuning.customTurbo")))
        else
            outputChatBox("nem ulsz jarganyban", sourcePlayer)
        end
    else
        outputChatBox("/" .. commandName .. " toltonyomashangereje(0-1), toltonyomashang(1-8), wastegatehangereje(0-1), wastegatehang(1-16)", sourcePlayer)
    end
end)]]