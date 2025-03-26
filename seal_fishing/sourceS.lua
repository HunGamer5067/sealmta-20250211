local connection = false

local fishingEvent = false
local fishingEventStart = 0
local fishingEventEnd = 0

addEventHandler("onResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if res == getThisResource() then
        connection = exports.seal_database:getConnection()

        if fileExists("fishingEvent.json") then
            local file = fileOpen("fishingEvent.json")
            local fileSize = fileGetSize(file)
            local fileContent = fileRead(file, fileSize)
            fileClose(file)

            local data = fromJSON(fileContent)
            fishingEvent = data[1]
            fishingEventStart = data[2]
            fishingEventEnd = data[3]
        end
    elseif resName == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

addCommandHandler("fishingmaffia", function(playerSource, commandName, eventLength)
    if getElementData(playerSource, "acc.adminLevel") >= 8 then
        if not eventLength then
            if fileExists("fishingEvent.json") then
                fileDelete("fishingEvent.json")
            end

            fishingEvent = false
            fishingEventStart = 0
            fishingEventEnd = 0

            triggerClientEvent("gotFishingEvent", playerSource, false, false)
            exports.seal_gui:showInfobox(playerSource, "i", "Sikeresen leállítottad a fishing eventet!")
        else
            dbExec(connection, "UPDATE characters SET fishingWeight = 0 WHERE fishingWeight > 0")
        
            local currentTime = getRealTime()
            local totalSeconds = currentTime.timestamp
            local fishingEventStart = math.floor(totalSeconds / 86400)
            local fishingEventEnd = fishingEventStart + tonumber(eventLength)
    
            if fileExists("fishingEvent.json") then
                fileDelete("fishingEvent.json")
            end
            fishingEvent = true
    
            local file = fileCreate("fishingEvent.json")
            fileWrite(file, toJSON({fishingEvent, fishingEventStart, fishingEventEnd}))
            fileClose(file)
    
            triggerClientEvent("gotFishingEvent", playerSource, false, {fishingEventStart, fishingEventEnd})
    
            dbQuery(function (queryHandle, playerSource)
                local queryResult = dbPoll(queryHandle, -1)
                local fishingResult = {}
    
                for i = 1, #queryResult do
                    table.insert(fishingResult, {queryResult[i].name:gsub("_", " "), queryResult[i].fishingWeight})
                end
    
                triggerClientEvent("updateFishingTournament", playerSource, fishingResult)
            end, {playerSource}, connection, "SELECT * FROM characters ORDER BY fishingWeight DESC LIMIT 10")

            exports.seal_gui:showInfobox(playerSource, "i", "Sikeresen beállítottad a fishing eventet!")
        end
    end
end)

addEvent("requestFishingEvent", true)
addEventHandler("requestFishingEvent", getRootElement(), function()
    if fishingEvent then
        triggerClientEvent(client, "gotFishingEvent", client, false, {fishingEventStart, fishingEventEnd})

        dbQuery(function (queryHandle, client)
            local queryResult = dbPoll(queryHandle, -1)
            local fishingResult = {}

            for i = 1, #queryResult do
                table.insert(fishingResult, {queryResult[i].name:gsub("_", " "), queryResult[i].fishingWeight})
            end

            triggerClientEvent(client, "updateFishingTournament", client, fishingResult)
        end, {client}, connection, "SELECT * FROM characters ORDER BY fishingWeight DESC LIMIT 10")
    end
end)

local playerSyncers = {}
local playerFishingDatas = {}
local fishWaitTimers = {}
local fishGetOutStart = {}
local dropoffCols = {}
local dropoffSells = {}
local fishSelling = {}
local playerHasBait = {}
local fishGetAwayTimers = {}

function fishWaitTimer(client, rod)
    fishWaitTimers[client] = nil

    local fish = chooseRandomFish(rod)
    local weight = fishTypes[fish].weight or {0.5, 2.5}

    if type(weight) == "table" then
        weight = math.random(weight[1] * 10, weight[2] * 10) / 10
    end
    
    updatePlayerFishingData(client, "fish", fish)
    updatePlayerFishingData(client, "fishWeight", weight)
    updatePlayerFishingData(client, "mode", "catching", true)

    fishGetOutStart[client] = getTickCount()
    playerHasBait[client] = false
end

function getPlayerFishingDatas(player)
    return playerFishingDatas[player]
end

function getPlayerFishingData(player, data)
    return playerFishingDatas[player] and playerFishingDatas[player][data]
end

local rodTimes = {
    [445] = 60000,
    [446] = 55000,
    [447] = 50000,
    [448] = 45000,
    [449] = 35000,
}

function updatePlayerFishingData(client, data, value, multi)
    if not playerFishingDatas[client] then
        playerFishingDatas[client] = {}
    end

    playerFishingDatas[client][data] = value

    if data == "mode" then
        print(value, "OUOUOU")

        if value == "waiting" and not multi and playerHasBait[client] then
            fishWaitTimers[client] = setTimer(fishWaitTimer, math.random(10000, 60000), 1, client, 445 + getElementData(client, "usingFishingRod"))
        elseif value == "idle" then
            if playerFishingDatas[client].fish then
                local fish = playerFishingDatas[client].fish

                exports.seal_gui:showInfobox(client, "s", "Kifogtál egy " .. fishTypes[fish].nameEx .. "!")

                if fishTypes[fish].item then
                    local weight = playerFishingDatas[client].fishWeight
                    local start = fishGetOutStart[client]
                    
                    exports.seal_items:giveItem(client, fishTypes[fish].item, 1, false, 0, weight)
                    if fishTypes[fish].previewLength then
                        local start = start or getTickCount()
                        triggerClientEvent(client, "gotFishWin", client, fish, weight, (getTickCount() - start) / 1000, exports.seal_items:getItemName(445 + getElementData(client, "usingFishingRod")))
                        exports.seal_gui:showInfobox(client, "i", "Súly: " .. weight .. " kg, hossz: " .. calculateFishLength(fish, weight) .. " cm")
                    end

                    if fishingEvent then
                        dbExec(connection, "UPDATE characters SET fishingWeight = fishingWeight + ? WHERE characterId = ?", weight, getElementData(client, "char.ID"))

                        dbQuery(function (queryHandle)
                            local queryResult = dbPoll(queryHandle, -1)
                            local fishingResult = {}
                
                            for i = 1, #queryResult do
                                table.insert(fishingResult, {queryResult[i].name:gsub("_", " "), queryResult[i].fishingWeight})
                            end
                
                            triggerClientEvent("updateFishingTournament", getRootElement(), fishingResult)
                        end, connection, "SELECT * FROM characters ORDER BY fishingWeight DESC LIMIT 10")
                    end
                end

                if playerFishingDatas[client] then
                    playerFishingDatas[client] = false
                end
                playerFishingDatas[client] = nil
                
                fishGetOutStart[client] = nil
            end
        elseif value == "catching" then
            if not fishGetAwayTimers[client] then
                fishGetAwayTimers[client] = setTimer(fishGetAwayTimer, 15000, 1, client)
            end
        elseif value == "catched" then
            if isTimer(fishGetAwayTimers[client]) then
                killTimer(fishGetAwayTimers[client])
            end
            fishGetAwayTimers[client] = nil
        elseif value == "throw" then
            local bait = exports.seal_items:hasItem(client, 450)

            if not playerHasBait[client] then
                if bait then
                    exports.seal_chat:localAction(client, "horogra tűzött egy csalit.")
                    exports.seal_items:takeItem(client, "dbID", bait.dbID, 1)

                    playerHasBait[client] = true
                else
                    exports.seal_gui:showInfobox(client, "w", "Nincs nálad csali!")
                end
            end
        else
            if isTimer(fishWaitTimers[client]) then
                killTimer(fishWaitTimers[client])
            end
            fishWaitTimers[client] = nil
        end
    end
    
    if multi then
        triggerClientEvent(client, "syncMultiFishingData", client, playerFishingDatas[client])
    else
        triggerClientEvent(playerSyncers[client], "syncFishingData", client, data, value)
    end
end

function fishGetAwayTimer(client)
    if fishGetOutStart[client] then
        exports.seal_gui:showInfobox(client, "w", "Elúszott a hal, és elvitte a csalit!")
        playerHasBait[client] = false
        fishGetOutStart[client] = false
        fishGetAwayTimers[client] = false
        updatePlayerFishingData(client, "mode", "waiting", true)
    end
end

function removePlayerBait(client)
    playerHasBait[client] = false
end

local rodMultipliers = {
    [445] = 3,
    [446] = 2.5,
    [447] = 2,
    [448] = 1.5,
    [449] = 1
}

function chooseRandomFish(rod)
    local rodMultiplier = rodMultipliers[rod] or 1.0
    local scaledChances = {}
    local scaledChanceSum = 0

    for k, v in pairs(chances) do
        local invertedChance = 16 - v
        local scaledChance = invertedChance * rodMultiplier
        scaledChances[k] = scaledChance
        scaledChanceSum = scaledChanceSum + scaledChance
    end

    local selectedWeight = math.random() * scaledChanceSum
    local iteratedWeight = 0
    local selectedFish = false

    for k, v in pairs(scaledChances) do
        iteratedWeight = iteratedWeight + v

        if selectedWeight <= iteratedWeight then
            selectedFish = k
            break
        end
    end

    return selectedFish
end

function isPlayerStandingInDropOffCol(client)
    local dropoffCol = false

    for col, i in pairs(dropoffCols) do
        local within = isElementWithinColShape(client, col)

        if within then
            dropoffCol = i

            break
        end
    end

    return dropoffCol
end

addEvent("refreshPlayerFishingSyncers", true)
addEventHandler("refreshPlayerFishingSyncers", getRootElement(), function(players)
    if source == client then
        playerSyncers[client] = players
    else
        --ac ban
    end
end)

addEvent("addPlayerFishingSyncer", true)
addEventHandler("addPlayerFishingSyncer", getRootElement(), function(player)
    if source == client then
        if not playerSyncers[source] then
            playerSyncers[source] = {}
        end

        table.remove(playerSyncers[source], player)
    else
        --ac ban
    end
end)

addEvent("removedPlayerFishingSyncer", true)
addEventHandler("removedPlayerFishingSyncer", getRootElement(), function(player)
    if source == client then
        if playerSyncers[source] then
            for i = 1, #playerSyncers[source] do
                if playerSyncers[source][i] == player then
                    table.remove(playerSyncers[source], i)
                    break
                end
            end
        end
    else
        --ac ban
    end
end)

addEvent("syncFishingData", true)
addEventHandler("syncFishingData", getRootElement(), function(data, value)
    if source == client then
        updatePlayerFishingData(client, data, value)
    else
        --ac ban
    end
end)

addEventHandler("onElementDataChange", getRootElement(), function(data, old, new)
    if data == "usingFishingRod" and not new then
        playerFishingDatas[source] = nil
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    playerSyncers[source] = nil
    playerFishingDatas[source] = nil

    if isTimer(fishWaitTimers[source]) then
        killTimer(fishWaitTimers[source])
    end
    fishWaitTimers[source] = nil
    
    fishGetOutStart[source] = nil

    for dropoffCol = 1, #dropoffSells do
        local client, fish, weight, itemData = unpack(dropoffSells[dropoffCol])

        if source == client then
            triggerClientEvent(getRootElement(), "refreshFishStand", source, dropoffCol, false, false)
        
            if dropoffSells[dropoffCol] then
                dropoffSells[dropoffCol] = false
            end
            dropoffSells[dropoffCol] = nil
        end
    end
    
    fishSelling[source] = nil
    playerHasBait[source] = nil

    if isTimer(fishGetAwayTimers[source]) then
        killTimer(fishGetAwayTimers[source])
    end
    fishGetAwayTimers[source] = nil
end)

addEvent("requestFishStand", true)
addEventHandler("requestFishStand", getRootElement(), function()

end)

addEventHandler("onColShapeHit", getRootElement(), function(he, md)
    if dropoffCols[source] and md then
        if getElementType(he) == "player" then
            exports.seal_gui:showInfobox(he, "i", "A hal eladásához kattints rá jobb klikkel az inventoryban.")
        end
    end
end)



addEvent("sellFishItemUse", true)
addEventHandler("sellFishItemUse", getRootElement(), function(itemData)
    if client then
        return
    end

    local dropoffCol = exports.seal_fishing:isPlayerStandingInDropOffCol(source)

    if dropoffCol then
        local fish = false
        local weight = tonumber(itemData.data2)

        for k, v in pairs(fishTypes) do
            if v.item == itemData.itemId then
                fish = k
                break
            end
        end

        if fish and weight and not dropoffSells[dropoffCol] then
            dropoffSells[dropoffCol] = {source, fish, weight, itemData}

            triggerClientEvent(getRootElement(), "refreshFishStand", source, dropoffCol, fish, weight)
        end
    end
end)

addEvent("startFishSelling", true)
addEventHandler("startFishSelling", getRootElement(), function()
    if client == source then
        fishSelling[client] = true
    else
        --ac ban
    end
end)

addEvent("closeFishSelling", true)
addEventHandler("closeFishSelling", getRootElement(), function(slider)
    if client == source then
        for dropoffCol = 1, #dropoffPoses do
            if dropoffSells[dropoffCol] then
                local source, fish, weight, itemData = unpack(dropoffSells[dropoffCol])
                
                if source == client then
                    if fishSelling[client] and slider and slider > 0 then
                        if slider >= 0 or slider <= 1 then
                            local fishType = fishTypes[fish]
                            
                            if fishType then
                                local sellingPriceFrom = math.floor(fishType.price * weight * 0.7)
                                local sellingPriceTo = math.floor(fishType.price * weight * 1)
                                local price = math.floor(sellingPriceFrom + (sellingPriceTo - sellingPriceFrom) * slider)

                                local itemData = exports.seal_items:hasItemEx(client, "dbID", itemData.dbID)
                                if itemData and exports.seal_items:takeItem(client, "dbID", itemData.dbID) then
                                    local moneyValue = getElementData(client, "char.Money") or 0
                                    local newMoneyValue = moneyValue + price

                                    local premiumValue = getElementData(client, "acc.premiumPoints") or 0
                                    local newPremiumValue = premiumValue + (price / 320)

                                    setElementData(client, "char.Money", newMoneyValue)
                                    dbExec(connection, "UPDATE characters SET money = ? WHERE characterId = ?", newMoneyValue, getElementData(client, "char.ID"))

                                    setElementData(client, "acc.premiumPoints", math.floor(newPremiumValue))
                                    dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", math.floor(newPremiumValue), getElementData(client, "char.accID"))

                                    outputChatBox("[color=blue][SealMTA - Horgászat]: [color=hudwhite]Eladtál egy " .. fishTypes[fish].nameEx .. ".", client)
                                    outputChatBox("[color=blue][SealMTA - Horgászat]: [color=hudwhite]Súly: [color=blue]" .. itemData.data2 .. " kg[color=hudwhite], hossz: [color=blue]" .. calculateFishLength(fish, itemData.data2) .. "cm", client)
                                    outputChatBox("[color=blue][SealMTA - Horgászat]: [color=hudwhite]Eladási ár: [color=green]" .. thousandsStepper(price) .. " $", client)
                                    outputChatBox("[color=blue][SealMTA - Horgászat]: [color=hudwhite]Eladási ár: [color=blue]" .. thousandsStepper(math.floor(price / 320)) .. " PP", client)
                                end
                            end   
                        else
                            --ac ban
                        end
                    end

                    fishSelling[client] = nil
                    dropoffSells[dropoffCol] = nil

                    triggerClientEvent(getRootElement(), "refreshFishStand", source, dropoffCol, false, false)
                end
            end
        end
    else
        --ac ban
    end
end)

addEventHandler("onResourceStart", getRootElement(), function(res)
    if res == getThisResource() then
        for i = 1, #dropoffPoses do
            local x, y, z, r = unpack(dropoffPoses[i])
            local rad = math.rad(r)
            local cos = math.cos(rad)
            local sin = math.sin(rad)
            local col = createColSphere(x + cos * 5 - sin * 2, y + sin * 7 + cos * 2, z + 0.925, 2)
            dropoffCols[col] = i
        end
    else
        local resName = getResourceName(res)


    end
end)

addEvent("damageFishingLine", true)
addEventHandler("damageFishingLine", getRootElement(), function(rodDbID, tear)
    if source == client then
        updatePlayerFishingData(client, "mode", "idle", true)
    else
        --ac ban
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