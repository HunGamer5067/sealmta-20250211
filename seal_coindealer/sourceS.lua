local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif getResourceName(res) == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

addEvent("buySSC", true)
addEventHandler("buySSC", getRootElement(), function(amount)
    if client == source then
        if tonumber(amount) and amount >= 1000 and amount <= 500000 then
            local amount = math.floor(amount)
            local price = amount * 5

            if takeMoney(client, price) then
                giveSlotCoin(client, amount)

                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffSikeres SSC vásárlás!", client, 255, 255, 255, true)
                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffVásárolt SSC: [color=yellow]" .. amount .. " SSC", client, 255, 255, 255, true)
                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffVégösszeg: [color=primary]" .. price .. " $", client, 255, 255, 255, true)
            else
                exports.seal_hud:showInfobox(client, "e", "Nincs elég készpénzed!")
            end
        end
    else
        -- ac ban
    end 
end)

addEvent("sellSSC", true)
addEventHandler("sellSSC", getRootElement(), function(amount)
    if client == source then
        if tonumber(amount) and amount >= 1000 and amount <= 500000 then
            local amount = math.floor(amount)
            local price = amount * 5
            local tax = price * 0.1
            price = price - tax

            if takeSlotCoin(client, amount) then
                giveMoney(client, price)

                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffSikeres SSC eladás!", client, 255, 255, 255, true)
                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffEladott SSC: [color=yellow]" .. amount .. " SSC", client, 255, 255, 255, true)
                outputChatBox("[color=yellow][SealMTA - Kaszinó]: #ffffffVégösszeg: [color=primary]" .. price .. " $", client, 255, 255, 255, true)
            else
                exports.seal_hud:showInfobox(client, "e", "Nincs elég SSC egyenleged!")
            end
        end
    else
        -- ac ban
    end
end)

function giveSlotCoin(player, amount)
    local slotcoins = getElementData(player, "char.slotCoins") or 0

    setElementData(player, "char.slotCoins", slotcoins + amount)
    dbExec(connection, "UPDATE characters SET slotCoins = ? WHERE characterId = ?", slotcoins + amount, getElementData(player, "char.ID"))

    return true
end

function takeSlotCoin(player, amount)
    local slotcoins = getElementData(player, "char.slotCoins") or 0

    if (slotcoins - amount) >= 0 then
        setElementData(player, "char.slotCoins", slotcoins - amount)
        dbExec(connection, "UPDATE characters SET slotCoins = ? WHERE characterId = ?", slotcoins - amount, getElementData(player, "char.ID"))
        return true
    end

    return false
end

function giveMoney(player, amount)
    local money = getElementData(player, "char.Money") or 0

    setElementData(player, "char.Money", money + amount)
    dbExec(connection, "UPDATE characters SET money = ? WHERE characterId = ?", money + amount, getElementData(player, "char.ID"))

    return true
end

function takeMoney(player, amount)
    local money = getElementData(player, "char.Money") or 0

    if (money - amount) >= 0 then
        setElementData(player, "char.Money", money - amount)
        dbExec(connection, "UPDATE characters SET money = ? WHERE characterId = ?", money - amount, getElementData(player, "char.ID"))
        return true
    end

    return false
end

addEventHandler("onElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if dataName == "char.slotCoins" then
        triggerClientEvent(source, "refreshSSC", source, newValue)
    end
end)