local pawnDeals = {}
local negotiationData = {}

addEvent("tryToStartPawnDeal", true)
addEventHandler("tryToStartPawnDeal", getRootElement(), function()
    if client == source then
        local characterId = getElementData(client, "char.ID") or false

        if characterId then
            if pawnDeals[characterId] then
                local seconds = math.floor((getTickCount() - pawnDeals[characterId]) / 1000)
                
                if seconds < 900 then
                    exports.seal_gui:showInfobox(client, "e", "Várj még " .. 15 - math.floor(seconds / 60) .. " percet a következő próbálkozásig!")
                    return
                else
                    pawnDeals[characterId] = nil
                end
            end

            triggerClientEvent(client, "openPawnItemSelector", client)
        end
    else
        -- ac ban
    end
end)

addEvent("startPawnSelling", true)
addEventHandler("startPawnSelling", getRootElement(), function(items)
    if client == source then
        local playerItems = exports.seal_items:getElementItems(client)
        local itemCounts = {}
        local tempItems = {}

        for itemId, itemAmount in pairs(items) do
            table.insert(tempItems, itemId)

            if not itemCounts[itemId] then
                itemCounts[itemId] = 0
            end
        end

        for key, value in pairs(playerItems) do
            for i = 1, #tempItems do
                if tempItems[i] == value.itemId and itemCounts[value.itemId] < items[value.itemId] then
                    itemCounts[value.itemId] = itemCounts[value.itemId] + 1
                end
            end
        end

        local characterId = getElementData(client, "char.ID") or false
        pawnDeals[characterId] = getTickCount()

        negotiationData[client] = {}
        negotiationData[client].minPrice = 0
        negotiationData[client].maxPrice = 0
        negotiationData[client].items = itemCounts

        for itemId, itemAmount in pairs (itemCounts) do
            negotiationData[client].maxPrice = negotiationData[client].maxPrice + ((pawnItems[itemId] * 2) * itemAmount)
            negotiationData[client].minPrice = negotiationData[client].minPrice + ((pawnItems[itemId] / 2) * itemAmount)
        end

        negotiationData[client].playerPrice = negotiationData[client].maxPrice
        negotiationData[client].lastPlayerPrice = 0
        negotiationData[client].pawnPrice = negotiationData[client].minPrice
        negotiationData[client].pawnLastPrice = 34563463
        negotiationData[client].canMove = true
        negotiationData[client].text = math.random(3)
        negotiationData[client].offerCount = 0
        negotiationData[client].maxOfferCount = math.random(15, 25)

        triggerClientEvent(client, "refreshPawnData", client, negotiationData[client])
    else
        -- ac ban
    end
end)

addEvent("pawnOfferNewPrice", true)
addEventHandler("pawnOfferNewPrice", getRootElement(), function(newPrice)
    if client == source then
        if negotiationData[client] and newPrice <= negotiationData[client].playerPrice and newPrice >= negotiationData[client].pawnPrice then
            if newPrice ~= negotiationData[client].lastPlayerPrice then
                negotiationData[client].fixedPlayerPrice = newPrice
                negotiationData[client].playerPrice = newPrice

                if negotiationData[client].playerPrice == negotiationData[client].pawnPrice then
                    negotiationData[client].text = 10
                else
                    if not negotiationData[client].firstPawnPrice then
                        local number = math.random(10, 55)
                        local onePercent = negotiationData[client].pawnPrice / 100

                        negotiationData[client].firstPawnPrice = true
                        negotiationData[client].pawnPrice = negotiationData[client].pawnPrice + (onePercent * number)
                    else
                        local number = math.random(3, 13)
                        local onePercent = negotiationData[client].pawnPrice / 100

                        if number > 9 then
                            if math.random(1, 100) >= 5 then
                                number = math.random(3, 9)
                            end
                        end

                        negotiationData[client].pawnPrice = negotiationData[client].pawnPrice + (onePercent * number)
                    end

                    negotiationData[client].pawnPrice = math.floor(negotiationData[client].pawnPrice)
                    negotiationData[client].offerCount = negotiationData[client].offerCount + 1

                    if negotiationData[client].pawnPrice >= negotiationData[client].playerPrice then
                        negotiationData[client].pawnPrice = negotiationData[client].playerPrice
                    end

                    if negotiationData[client].offerCount == negotiationData[client].maxOfferCount then
                        negotiationData[client].text = math.random(8, 9)
                        negotiationData[client].pawnLastPrice = negotiationData[client].pawnPrice
                    elseif negotiationData[client].offerCount > (negotiationData[client].maxOfferCount / 1.2) then
                        negotiationData[client].text = math.random(8, 12)
                    else
                        negotiationData[client].text = math.random(4, 7)
                    end
                end
            else
                negotiationData[client].text = math.random(11, 12)
            end

            negotiationData[client].lastPlayerPrice = newPrice

            setTimer(function(client)
                triggerClientEvent(client, "refreshPawnData", client, negotiationData[client])
            end, 2500, 1, client)
        end
    else
        -- ac ban
    end
end)

addEvent("pawnEndTheDeal", true)
addEventHandler("pawnEndTheDeal", getRootElement(), function()
    if client == source then
        if negotiationData[client] then
            negotiationData[client] = nil
            triggerClientEvent(client, "refreshPawnData", client)
        end
    end
end)

addEvent("pawnAcceptOffer", true)
addEventHandler("pawnAcceptOffer", getRootElement(), function()
    if client == source then
        if negotiationData[client] then
            local items = negotiationData[client].items
            local takedPawnItems = {}
            local validItemCount = 0
            local itemCount = 0

            if items then
                for itemId, itemAmount in pairs(items) do
                    validItemCount = validItemCount + itemAmount

                    for i = 1, itemAmount do
                        local hasItem = exports.seal_items:hasItem(client, itemId, 1)

                        if hasItem and hasItem.dbID then
                            table.insert(takedPawnItems, itemId)
                            exports.seal_items:takeItem(client, "dbID", hasItem.dbID, 1)
                            itemCount = itemCount + 1
                        end

                        if i == itemAmount and itemCount == validItemCount then
                            exports.seal_chat:localAction(client, "eladott egy tárgyat: " .. itemAmount .. " darab " .. exports.seal_items:getItemName(itemId) .. ".")
                        end
                    end
                end

                if validItemCount == itemCount then
                    exports.seal_core:giveMoney(client, negotiationData[client].pawnPrice, "pawnsell")
                    exports.seal_gui:showInfobox(client, "s", "Sikeresen eladtál " .. validItemCount .. " tárgyat " .. formatNumber(negotiationData[client].pawnPrice, " ") .. " dollárért.")
                else
                    for i = 1, #takedPawnItems do
                        if takedPawnItems[i] then
                            exports.seal_items:giveItem(client, takedPawnItems[i], 1, false)
                        end
                    end

                    exports.seal_gui:showInfobox(client, "e", "Hiányzó tárgyak!")
                end

                negotiationData[client] = nil
                items = nil
                takedPawnItems = nil
                validItemCount = nil
                itemCount = nil
                collectgarbage("collect")

                setTimer(function(client)
                    triggerClientEvent(client, "refreshPawnData", client)
                end, 2500, 1, client)
            end
        end
    else
        -- ac ban
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    if negotiationData[source] then
        negotiationData[source] = nil
    end
end)

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	sep = sep or '.'
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end