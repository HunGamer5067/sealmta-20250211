local superChargerPistolInUse = {}
local superChargerPistolInVehicle = {}

addEvent("requestSuperchargerSync", true)
addEventHandler("requestSuperchargerSync", getRootElement(), function()
    for charger, player in pairs(superChargerPistolInUse) do
        if isElement(player) then
            triggerClientEvent(root, "syncSuperchargerUser", player, charger, player)
        end
    end

    for charger, data in pairs(superChargerPistolInVehicle) do
        if isElement(data.vehicleElement) then
            triggerClientEvent(root, "syncSuperchargerUser", root, charger, data.vehicleElement)
        end
    end
end)

function calculateChargingCost(currentCharge)
    local percentToCharge = 100 - currentCharge
    if percentToCharge <= 0 then
        return 0, 0
    end
    
    local secondsToCharge = (percentToCharge / 5) * 60
    local costToCharge = (secondsToCharge / 60) * 250
    return secondsToCharge, costToCharge
end

function calculatePercentageFilled(seconds)
    local percentPerSecond = 5 / 60
    local percentageFilled = seconds * percentPerSecond
    return percentageFilled
end

addEvent("trySuperchargerPistolInHand", true)
addEventHandler("trySuperchargerPistolInHand", getRootElement(), function(charger)
    if client == source then
        if superChargerPistolInVehicle[charger] then
            local now = getTickCount()
            local elapsedTime = now - superChargerPistolInVehicle[charger].startedCharging
            local elapsedSeconds = elapsedTime / 1000

            local minutes = math.floor(elapsedSeconds / 60)
            local remainingSeconds = elapsedSeconds % 60
            local chargedTime = string.format("%02d:%02d", minutes, remainingSeconds)

            local batteryLevel = superChargerPistolInVehicle[charger].batteryLevel
            local newBatteryLevel = calculatePercentageFilled(elapsedSeconds) + batteryLevel

            local vehicleElement = superChargerPistolInVehicle[charger].vehicleElement

            if isElement(vehicleElement) then
                local remainingSeconds, remainingPrice = calculateChargingCost(newBatteryLevel)

                if newBatteryLevel >= 100 then
                    newBatteryLevel = 100
                    remainingSeconds = 0
                    remainingPrice = 0
                end

                setElementData(vehicleElement, "vehicle.fuel", newBatteryLevel)
                setElementData(vehicleElement, "vehicle.onCharging", false)

                local playerElement = superChargerPistolInVehicle[charger].chargerElement
                local totalCost = superChargerPistolInVehicle[charger].chargingCost - remainingPrice
                totalCost = math.floor(totalCost)
                
                local payedPrice = superChargerPistolInVehicle[charger].chargingCost - totalCost
                payedPrice = math.floor(payedPrice)

                if isElement(playerElement) then
                    local moneyValue = getElementData(playerElement, "char.Money") or 0
                    setElementData(playerElement, "char.Money", moneyValue + payedPrice)

                    local vehiclePlate = getVehiclePlateText(vehicleElement):gsub("-", " ")
                    exports.seal_gui:showInfobox(playerElement, "i", vehiclePlate .. " rendszámú járműved töltése befejeződtt.")
                    exports.seal_gui:showInfobox(playerElement, "i", "Töltési idő: " .. chargedTime .. ", fizetendő: " .. thousandsStepper(totalCost) .. " $")
                    exports.seal_gui:showInfobox(playerElement, "i", "A töltési különbözetet visszakaptad. (" .. thousandsStepper(payedPrice) .. " $)")
                end
            end

            superChargerPistolInVehicle[charger] = nil
            superChargerPistolInUse[charger] = client
            triggerClientEvent(root, "syncSuperchargerUser", client, charger, client)
        else
            local currentCharger = false

            for charger, player in pairs(superChargerPistolInUse) do
                if player == client then
                    currentCharger = charger
                end
            end

            if currentCharger then
                superChargerPistolInUse[currentCharger] = nil
                triggerClientEvent(root, "syncSuperchargerUser", client, currentCharger)
            else
                superChargerPistolInUse[charger] = client
                triggerClientEvent(root, "syncSuperchargerUser", client, charger, client)
            end
        end
    end
end)

addEvent("putSuperchargerPistolInVehicle", true)
addEventHandler("putSuperchargerPistolInVehicle", getRootElement(), function(hoveredElement)
    if client == source then
        local hoveredElementModel = getElementModel(hoveredElement)
        if not chargingPortRotation[hoveredElementModel] then
            return
        end

        for charger, data in pairs(superChargerPistolInVehicle) do
            if data.vehicleElement == hoveredElement then
                return
            end
        end

        local currentCharger = false

        for charger, player in pairs(superChargerPistolInUse) do
            if player == client then
                currentCharger = charger
            end
        end

        if currentCharger then
            local vehiclePlate = getVehiclePlateText(hoveredElement):gsub("-", " ")
            local currentBatteryLevel  = getElementData(hoveredElement, "vehicle.fuel") or 0

            local chargingTime, chargingCost = calculateChargingCost(currentBatteryLevel)
            chargingCost = math.floor(chargingCost)

            local moneyValue = getElementData(client, "char.Money") or 0
            setElementData(client, "char.Money", moneyValue - chargingCost)

            exports.seal_gui:showInfobox(client, "i", vehiclePlate .. " rendszámú járműved töltése elkezdődött. Töltési díj 250 $/perc")
            exports.seal_gui:showInfobox(client, "i", "Zárolásra került " .. thousandsStepper(chargingCost) .. " $, melyet a töltés befejezésekor visszakapsz.")

            setElementData(hoveredElement, "vehicle.onCharging", true)
            setElementData(hoveredElement, "vehicle.engine", 0)
            setVehicleEngineState(hoveredElement, false)

            superChargerPistolInVehicle[currentCharger] = {
                chargerElement = client,
                vehicleElement = hoveredElement,
                startedCharging = getTickCount(),
                batteryLevel = currentBatteryLevel,
                chargingCost = chargingCost,
                chargingTime = chargingTime
            }

            triggerClientEvent(root, "syncSuperchargerUser", client, currentCharger, hoveredElement)
        end
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    for charger, player in pairs(superChargerPistolInUse) do
        if player == source then
            superChargerPistolInUse[charger] = nil
            triggerClientEvent(root, "syncSuperchargerUser", root, charger)
        end
    end
end)

addEventHandler("onElementDestroy", getRootElement(), function()
    for charger, data in pairs(superChargerPistolInVehicle) do
        if data.vehicleElement == source then
            superChargerPistolInVehicle[charger] = nil
            triggerClientEvent(root, "syncSuperchargerUser", root, charger)
        end
    end
end)

function thousandsStepper(amount)
    local formatted = amount

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")

        if k == 0 then
            break
        end
    end

    return formatted
end