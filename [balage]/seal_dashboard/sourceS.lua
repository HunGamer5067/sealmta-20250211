local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif resName == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

addEvent("requestPlayerVehicles", true)
addEventHandler("requestPlayerVehicles", getRootElement(), function()
    if client == source then
        local characterId = getElementData(client, "char.ID")

        if characterId then
            dbQuery(function(queryHandle, client)
                local queryResult = dbPoll(queryHandle, -1)

                if queryResult then
                    for i = 1, #queryResult do
                        local vehicle = queryResult[i]
                        local vehicleElement = getVehicleElementById(vehicle.vehicleId)

                        if vehicleElement then
                            queryResult[i].health = math.floor(getElementHealth(vehicleElement))
                            queryResult[i].fuel = math.floor(getElementData(vehicleElement, "vehicle.fuel"))
                            queryResult[i].engine = getElementData(vehicleElement, "vehicle.engine")
                            queryResult[i].locked = getElementData(vehicleElement, "vehicle.locked")
                            queryResult[i].lights = getElementData(vehicleElement, "vehicle.lights")
                            queryResult[i].handbrake = getElementData(vehicleElement, "vehicle.handBrake")
                        end
                    end

                    triggerClientEvent(client, "gotPlayerVehicles", client, queryResult)
                end
            end, {client}, connection, "SELECT * FROM vehicles WHERE ownerId = ?", characterId)
        end
    end
end)

addEvent("buyPremiumItem", true)
addEventHandler("buyPremiumItem", getRootElement(), function(itemCategory, itemIndex, itemAmount)
    if client == source then
        local categoryItems = premiumShopCategoryItems[itemCategory]

        if categoryItems then
            local itemDatas = categoryItems[itemIndex]

            if itemDatas then
                local accountId = getElementData(client, "char.accID") or false

                if accountId then
                    local itemAmount = tonumber(itemAmount) or 1
                    itemAmount = math.floor(itemAmount)

                    if itemAmount < 1 then
                        return
                    end

                    local itemPrice = itemDatas.itemPrice * itemAmount
                    local premiumPoints = getElementData(client, "acc.premiumPoints") or 0
                    local newPremiumValue = premiumPoints - itemPrice

                    if newPremiumValue >= 0 then
                        if itemDatas.itemMaximumAmount < itemAmount then
                            exports.seal_gui:showInfobox(client, "e", "A maximális vásárolható mennyiség " .. itemDatas.itemMaximumAmount .. " db!")
                            return
                        end

                        exports.seal_items:giveItem(client, itemDatas.itemId, itemAmount)
                        exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltál " .. itemAmount .. " db " .. exports.seal_items:getItemName(itemDatas.itemId) .. " tárgyat!")

                        setElementData(client, "acc.premiumPoints", newPremiumValue)
                        dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPremiumValue, accountId)
                    else
                        exports.seal_gui:showInfobox(client, "e", "Nincs elegendő prémiumpontod a vásárláshoz!")
                    end
                end
            end
        end
    end
end)

addEvent("buySlot", true)
addEventHandler("buySlot", getRootElement(), function(slotAmount, isVehicle, isInterior)
    if client == source then
        local slotAmount = tonumber(slotAmount) or 1

        if slotAmount <= 0 then
            exports.seal_gui:showInfobox(client, "e", "Minimum 1 slotot vásárolhatsz!")
            return
        end
        
        local premiumPoints = getElementData(client, "acc.premiumPoints") or 0
        local price = slotAmount * 100

        if premiumPoints >= price then
            local newPremiumValue = premiumPoints - price

            setElementData(client, "acc.premiumPoints", newPremiumValue)
            dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPremiumValue, getElementData(client, "char.accID"))

            if isVehicle then
                exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltál " .. slotAmount .. " db jármű slotot!")

                local maxVehicles = getElementData(client, "char.maxVehicles") or 2
                setElementData(client, "char.maxVehicles", maxVehicles + slotAmount)
                dbExec(connection, "UPDATE characters SET maxVehicles = ? WHERE characterId = ?", maxVehicles + slotAmount, getElementData(client, "char.ID"))
            elseif isInterior then
                exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltál " .. slotAmount .. " db ingatlan slotot!")

                local maxInteriors = getElementData(client, "char.interiorLimit") or 5
                setElementData(client, "char.interiorLimit", maxInteriors + slotAmount)
                dbExec(connection, "UPDATE characters SET interiorLimit = ? WHERE characterId = ?", maxInteriors + slotAmount, getElementData(client, "char.ID"))
            end
        else
            exports.seal_gui:showInfobox(client, "e", "Nincs elegendő prémiumpontod a slot(ok) megvásárlásához!")
        end
    end
end)


addEvent("setPedFightingStyle", true)
addEventHandler("setPedFightingStyle", getRootElement(), function(fightningStyle)
	setPedFightingStyle(client, fightningStyle)
end)

addEvent("setPedWalkingStyle", true)
addEventHandler("setPedWalkingStyle", getRootElement(), function(walkingStyle)
    if walkingStyle == 0 then
        walkingStyle = 118
    end

	setPedWalkingStyle(client, walkingStyle)
end)

function getVehicleElementById(vehicleId)
    for i, vehicle in ipairs(getElementsByType("vehicle")) do
        if getElementData(vehicle, "vehicle.dbID") == vehicleId then
            return vehicle
        end
    end

    return false
end