local phoneObjects = {}

addEvent("attachMobilePhone", true)
addEventHandler("attachMobilePhone", getRootElement(), function(phoneState)
    if client == source then
        if phoneState and not phoneObjects[client] then
            phoneObjects[client] = createObject(2967, 0, 0, 0)
            exports.seal_boneattach:attachElementToBone(phoneObjects[client], source, 12, 0, -0.038, 0.08, -90, 0, 90)
        else
            local phoneObject = phoneObjects[client]

            if isElement(phoneObject) then
                exports.seal_boneattach:detachElementFromBone(phoneObject)
                setElementCollisionsEnabled(phoneObject, false)
                destroyElement(phoneObject)

                phoneObjects[client] = nil
            end
        end
    end
end)

local playerInCall = {}

local lastAdvertisement = {
    nion = {},
    default = {},
}

local disabledAdvertisementWords = {
    ["discord.gg"] = true,
    ["dc.gg"] = true,
    [".gg"] = true,
    ["nigger"] = true,
    ["hitler"] = true,
    ["szar"] = true,
    ["kurva"] = true,
    ["anyád"] = true,
    ["fasz"] = true
}

addEvent("sendAdvertisement", true)
addEventHandler("sendAdvertisement", getRootElement(), function(message, number)
    if client == source then
        if exports.seal_items:hasItem(client, 5) then
            local lastAdverstiementAction = lastAdvertisement.default[client]
            local clientVisibleName = getElementData(client, "visibleName")

            if lastAdverstiementAction and (getTickCount() - lastAdverstiementAction) < 60000 then
                exports.seal_gui:showInfobox(client, "e", "Percenként csak egy hirdetést adhatsz fel!")
                return
            end

            for word in pairs(disabledAdvertisementWords) do
                message = message:gsub(word, "")
            end

            lastAdvertisement.default[client] = getTickCount()
            triggerClientEvent("onAdvertisement", client, message .. " ((" .. clientVisibleName:gsub("_", " ") .. "))", number)
        end
    end
end)

addEvent("sendNionAdvertisement", true)
addEventHandler("sendNionAdvertisement", getRootElement(), function(message, number)
    if client == source then
        if exports.seal_items:hasItem(client, 5) then
            local lastAdverstiementAction = lastAdvertisement.nion[client]
            local clientVisibleName = getElementData(client, "visibleName")

            if lastAdverstiementAction and (getTickCount() - lastAdverstiementAction) < 60000 then
                exports.seal_gui:showInfobox(client, "e", "Percenként csak egy hirdetést adhatsz fel!")
                return
            end

            for word in pairs(disabledAdvertisementWords) do
                message = message:gsub(word, "")
            end

            lastAdvertisement.nion[client] = getTickCount()
            triggerClientEvent("onNionAdvertisement", client, message .. " ((" .. clientVisibleName:gsub("_", " ") .. "))", number)
        end
    end
end)

addEvent("callNumber", true)
addEventHandler("callNumber", getRootElement(), function(calledNumber, selfNumber)
    if client == source then
        if exports.seal_items:hasItemWithData(client, 5, tonumber(selfNumber), "data1") then
            local playerElement = getPhoneNumberOwner(calledNumber)

            if playerElement then
                if calledNumber == selfNumber then
                    exports.seal_gui:showInfobox(source, "error", "Saját magadat nem tudod felhívni!")
                    return
                end

                if playerInCall[playerElement] then
                    triggerClientEvent(client, "lineIsBusy", client)
                else
                    playerInCall[client] = playerElement
                    triggerClientEvent(playerElement, "incomingCall", source, selfNumber, calledNumber)
                    exports.seal_chat:sendLocalDo(playerElement, "csörög a telefonja.")
                end
            else
                triggerClientEvent(client, "talkingSysMessage", client, "#DC143CEzen a számon előfizető \nnem kapcsolható")
            end
        end
    end
end)

addEvent("playRingtone", true)
addEventHandler("playRingtone", getRootElement(), function(syncedPlayers, currentRingtone)
    if client == source then
        triggerClientEvent(syncedPlayers, "playRingtone", client, currentRingtone)
    end
end)

addEvent("playVibrate", true)
addEventHandler("playVibrate", getRootElement(), function(syncedPlayers)
    if client == source then
        triggerClientEvent(syncedPlayers, "playVibrate", client)
    end
end)

addEvent("playNotificationSound", true)
addEventHandler("playNotificationSound", getRootElement(), function(syncedPlayers, currentNotisound)
    if client == source then
        triggerClientEvent(syncedPlayers, "playNotificationSound", client, currentNotisound)
    end
end)

addEvent("acceptCall", true)
addEventHandler("acceptCall", getRootElement(), function(player)
    if client == source then
        if playerInCall[player] then
            triggerClientEvent(player, "someoneAccepted", client)
            triggerClientEvent(player, "callingWith", client)

            playerInCall[client] = player
            triggerClientEvent("destroySound", client)
        end
    end
end)

addEvent("cancelCall", true)
addEventHandler("cancelCall", getRootElement(), function(player)
	if client == source then
        if playerInCall[client] then
            triggerClientEvent(playerInCall[client], "callEnd", playerInCall[client])
            triggerClientEvent("destroySound", playerInCall[client])
        end

        triggerClientEvent(client, "callEnd", client)
        triggerClientEvent("destroySound", client)

        if player then
            triggerClientEvent(player, "callEnd", player)
            triggerClientEvent("destroySound", player)
        end

        playerInCall[client] = nil
        playerInCall[player] = nil
    end
end)

addEvent("sendSMS", true)
addEventHandler("sendSMS", getRootElement(), function(smsNumber, selfNumber, smsMessage)
    if client == source then
        if exports.seal_items:hasItemWithData(client, 5, tonumber(selfNumber), "data1") then
            local playerElement = getPhoneNumberOwner(smsNumber)

            if playerElement then
                exports.seal_chat:sendLocalDo(playerElement, "kapott egy SMS-t.")
                triggerClientEvent(playerElement, "gotSMS", client, tonumber(selfNumber), smsMessage)

                exports.seal_chat:localAction(client, "küldött egy SMS-t.")
                triggerClientEvent(client, "addToMySMSLine", playerElement, smsMessage, tonumber(smsNumber), false)
            else
                triggerClientEvent(client, "addToMySMSLine", client, smsMessage, tonumber(smsNumber), true)
            end
        end
    end
end)

addEvent("sendPhoneMessage", true)
addEventHandler("sendPhoneMessage", getRootElement(), function(playerElement, phoneMessage)
    if client == source then
        if playerInCall[client] == playerElement then
            exports.seal_chat:sendLocalSayInPhone(client, phoneMessage)
            triggerClientEvent(playerElement, "talkingSysMessage", playerElement, phoneMessage)
        end
    end
end)

addEvent("selfieAim", true)
addEventHandler("selfieAim", getRootElement(), function(state)
    if client == source then
        if state then
            setPedAnimation(client, "PED", "gang_gunstand")
        else
            setPedAnimation(client, false)
        end
    end
end)

function getPhoneNumberOwner(phoneNumber)
    for _, playerElement in pairs(getElementsByType("player")) do
        if playerElement and phoneNumber and exports.seal_items:hasItemWithData(playerElement, 5, tonumber(phoneNumber), "data1") then
            return playerElement
        end
    end

    return false
end