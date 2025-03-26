openTimers = {}

addEvent("tryToStartTreasureOpening", true)
addEventHandler("tryToStartTreasureOpening", getRootElement(), function (itemId, dbID)
    if client == source then
        if exports.seal_items:hasItem(client, 443, 1) then
            if isTimer(openTimers[client]) then
                return
            end

            exports.seal_items:takeItem(client, "dbID", dbID)
            realItem = chooseRandomItem(itemId)
            triggerClientEvent(client, "createChestMinigame", client, itemId, 50, realItem)

            openTimers[client] = setTimer(function(player, realItem)
                exports.seal_items:giveItem(player, realItem, 1, 1)
            end, 30000, 1, client, realItem)
        end
    else
        -- ac ban
    end
end)