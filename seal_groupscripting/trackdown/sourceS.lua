local trackDatas = {}
local trackTimers = {}
local lastUsed = {}

addCommandHandler("lenyomoz", function(sourcePlayer, commandName, phoneNum)
    if exports.seal_groups:isPlayerHavePermission(sourcePlayer, "trackPhone") then
        if not ((getTickCount() - (lastUsed[sourcePlayer] or 0)) > 20000) then
            outputChatBox("[SealMTA]: #ffffffEzt a parancsot csak 20 másodpercenként használhatod!", sourcePlayer, 215, 89, 89, true)
            return
        end
        phoneNum = tonumber(phoneNum)

        if not trackDatas[sourcePlayer] then
            if phoneNum then
                for k, v in pairs(getElementsByType("player")) do
                    if getElementData(v, "loggedIn") then
                        local items = exports.seal_items:getElementItems(v)

                        if items then
                            for k2, v2 in pairs(items) do
                                if v2.itemId == 5 then
                                    local number = tonumber(v2.data1)
                                    if number and number == phoneNum then
                                        iprint(v2.data1)
                                        trackDatas[sourcePlayer] = {phoneNum, v}
                                        triggerClientEvent(sourcePlayer, "createTrackingBlip", resourceRoot, trackDatas[sourcePlayer])
                                        trackTimers[sourcePlayer] = setTimer(checkTrackBlip, 20000, 0, sourcePlayer)
                                        checkTrackBlip(sourcePlayer)
                                        lastUsed[sourcePlayer] = getTickCount()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end

                if trackDatas[sourcePlayer] then
                    outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen elkezdted lenyomozni a telefonszámot.", sourcePlayer, 0, 0, 0, true)
                else
                    outputChatBox("[SealMTA]: #ffffffA telefonszám lenyomozása sikertelen.", sourcePlayer, 215, 89, 89, true)
                end
            else
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Telefonszám]", sourcePlayer, 255, 150, 0, true)
            end
        else
            if isTimer(trackDatas[sourcePlayer]) then
                killTimer(trackDatas[sourcePlayer])
            end
            trackDatas[sourcePlayer] = nil
            triggerClientEvent(sourcePlayer, "deleteTrackingBlip", resourceRoot)
            outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen megszakítottad a telefonszám lenyomozását.", sourcePlayer, 0, 0, 0, true)
            trackDatas[sourcePlayer] = nil
        end
    end
end)

function checkTrackBlip(playerElement)
    if trackDatas[playerElement] and isElement(playerElement) then
        local state = exports.seal_items:hasItemWithData(trackDatas[playerElement][2], 5, tostring(trackDatas[playerElement][1]), "data1")
        if state then
            
        else
            if isTimer(trackDatas[playerElement]) then
                killTimer(trackDatas[playerElement])
            end
            trackDatas[playerElement] = nil
            triggerClientEvent(playerElement, "deleteTrackingBlip", resourceRoot)
        end
    else
        if isTimer(trackDatas[playerElement]) then
            killTimer(trackDatas[playerElement])
        end
        trackDatas[playerElement] = nil
        if isElement(playerElement) then
            triggerClientEvent(playerElement, "deleteTrackingBlip", resourceRoot)
        end
    end
end