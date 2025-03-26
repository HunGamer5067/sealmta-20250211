local createdSafePlaces = {}
local safePlaceElements = {}
local zoneCount = 0

addCommandHandler("createsafezone",
    function(sourcePlayer, commandName, zoneSize)
        if getElementData(sourcePlayer, "acc.adminLevel") >= 5 then
            local zoneSize = tonumber(zoneSize)

            if not (zoneSize) then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Méret]", sourcePlayer, 255, 150, 0, true)
            else
                if zoneSize then
                    local zoneSize = math.floor(zoneSize)
        
                    local playerX, playerY, playerZ = getElementPosition(sourcePlayer)
                    local safeRectangle = createColSphere(playerX, playerY, playerZ, zoneSize)

                    if safeRectangle then
                        zoneCount = zoneCount + 1
                        createdSafePlaces[safeRectangle] = {zoneElement = safeRectangle, zoneId = zoneCount}

                        outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen létrehoztad a zónát! #4adfbf(" .. zoneSize .. " #ffffff| #4adfbf" .. zoneCount .. ")", sourcePlayer, 255, 255, 255, true)
                    end
                end
            end
        end
    end
)

local foundZone = false

addCommandHandler("deletesafezone",
    function(sourcePlayer, commandName, zoneId)
        if getElementData(sourcePlayer, "acc.adminLevel") >= 5 then
            local zoneId = tonumber(zoneId)

            if not zoneId then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Zóna Id]", sourcePlayer, 255, 150, 0, true)
            else
                if zoneId then
                    local zoneId = math.floor(zoneId)

                    for k, v in pairs(createdSafePlaces) do
                        if v.zoneId == zoneId then
                            if isElement(k) then
                                foundZone = false
                                createdSafePlaces[k] = nil
                                destroyElement(k)
                                outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen kitörölted a zónát! #4adfbf(" .. zoneId .. ")", sourcePlayer, 255, 255, 255, true)
                            end
                        else
                            foundZone = true
                        end
                    end

                    if foundZone then
                        outputChatBox("#d75959[SealMTA]: #ffffffIlyen azonosítóval nem létezik zóna!", sourcePlayer, 255, 255, 255, true) 
                    end

                    for k, v in pairs(getElementsByType("player")) do
                        if safePlaceElements[v] then
                            safePlaceElements[v] = nil
                            setElementAlpha(v, 255)
                            triggerClientEvent(v, "disableSafeZone", v)

                            outputChatBox("#4adfbf[SealMTA]: #ffffffA védett zóna amiben voltál törölve lett!", v, 255, 255, 255, true)
                        end
                    end

                    for k, v in pairs(getElementsByType("vehicle")) do
                        if safePlaceElements[v] then
                            safePlaceElements[v] = nil
                            setElementAlpha(v, 255)
                            triggerClientEvent(v, "disableSafeZone", v)
                        end
                    end
                end
            end
        end
    end
)

addEventHandler("onColShapeHit", getRootElement(),
    function(hitElement, matchingDimension)
        if isElement(hitElement) and matchingDimension then
            local elementType = getElementType(hitElement)

            if createdSafePlaces[source] then
                safePlaceElements[hitElement] = hitElement
                setElementAlpha(hitElement, 160)
                triggerClientEvent(hitElement, "enableSafeZone", hitElement)
                
                outputChatBox("#4adfbf[SealMTA]: #ffffffBeléptél egy védett zónába!", sourcePlayer, 255, 255, 255, true)
            end
        end
    end
)

addEventHandler("onColShapeLeave", getRootElement(),
    function(hitElement, matchingDimension)
        if isElement(hitElement) and matchingDimension then
            if createdSafePlaces[source] then
                safePlaceElements[hitElement] = nil
                setElementAlpha(hitElement, 255)
                triggerClientEvent(hitElement, "disableSafeZone", hitElement)

                outputChatBox("#4adfbf[SealMTA]: #ffffffKiléptél egy védett zónából!", sourcePlayer, 255, 255, 255, true)
            end
        end
    end
)

addEventHandler("onVehicleDamage", getRootElement(),
    function(loss)
        if safePlaceElements[source] then
            setElementHealth(source, math.min(1000, getElementHealth(source) + loss))
        end
    end
)