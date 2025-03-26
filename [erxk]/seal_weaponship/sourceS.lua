local startX, startY, startZ = 3100.496, -2594.251, 8.747
local endX, endY, endZ = 2750.615, -2594.251, 8.747

local shipModelId = 10230
local moveTimer = nil
local ship = nil
local shipState = false
local isMoving = false

local createdCrates = {}
local dropZone = nil


local attachedElementsTable = {}

local messageSent = false

local illegalFactions = {5, 6, 7, 9, 10, 11, 12, 13, 14}
local informationPeds = {}

addEventHandler("onResourceStart", resourceRoot,
    function()
        local wsX, wsY, wsZ = 2685.6936035156, -2608.4260253906, 3
        weaponShipZone = createColRectangle(wsX, wsY, 125, 35)

        spawnInformationPed()
    end
)

function spawnInformationPed()
    for k, infoPedData in pairs(informationPed) do
        local informationPed = createPed(infoPedData[2], infoPedData[3], infoPedData[4], infoPedData[5])
        setElementRotation(informationPed, 0, 0, 180)
        setElementData(informationPed, "visibleName", infoPedData[1])
        setElementData(informationPed, "pedNameType", "Információ")
        setElementData(informationPed, "invulnerable", true)
        setElementData(informationPed, "isInformationPed", true)
        setElementFrozen(informationPed, true)
        table.insert(informationPeds, informationPed)
    end
end

function spawnShipTime()
    local time = getRealTime()
    local hour = time.hour
    local minute = time.minute
    local shipHour, shipMinute = 18, 41

    if hour == shipHour and minute == shipMinute then
        if not shipState then
            createShip()
            shipState = true
        end
    else
        shipState = false
    end
end
setTimer(spawnShipTime, 10000, 0)

function createShip()
    if ship then
        destroyElement(ship)
    end

    ship = createObject(shipModelId, startX, startY, startZ, 0, 0, 0)
    moveShipToEndPosition()
    sendMessageToIllegal()
end

function moveShipToEndPosition()
    if ship then
        local moveTime = 10000
        moveObject(ship, moveTime, endX, endY, endZ)
        isMoving = true
        moveTimer = setTimer(checkShipPosition, 500, 0)
    end
end

function deleteShip()
    if ship then
        local moveTime = 10000
        setElementRotation(ship, 0, 0, 180)
        moveObject(ship, moveTime, startX, startY, startZ)
        isMoving = true

        setTimer(function()
            if isElement(ship) then
                destroyElement(ship)
                ship = nil
            end
            shipState = false
            isMoving = false

            -- Delete dropZone
            if isElement(dropZone) then
                destroyElement(dropZone)
                dropZone = nil
            end

        end, moveTime, 1)
    end
end

function checkBoxStates()
    setTimer(function()
        if #createdCrates == 0 and not messageSent then
            -- Üzenet küldése
            for _, player in ipairs(getElementsByType("player")) do
                if isElementWithinColShape(player, weaponShipZone) then
                    outputChatBox("#4adfbf[SealMTA - Fegyverhajó]: #ffffff Az összes láda felvételre került, 2 perc múlva eltűnik a hajó!", player, 255, 255, 255, true)
                end
            end
            messageSent = true

            -- Aktuális idő lekérése
            local currentTime = getRealTime()
            local futureTime = currentTime.timestamp + 120 -- 120 másodperc hozzáadása (2 perc)

            -- Késleltetett hajó eltűnésének indítása 2 perc múlva
            setTimer(function()
                deleteShip()
            end, 120000, 1) -- 120000 ms = 2 perc
        end
    end, 5000, 0)
end

function checkShipPosition()
    if ship then
        local shipX, shipY, shipZ = getElementPosition(ship)
        if math.abs(shipX - endX) < 1 and math.abs(shipY - endY) < 1 and math.abs(shipZ - endZ) < 1 then
            if #createdCrates == 0 then
                for k, crateData in ipairs(crates) do
                    local weaponBox = createObject(crateData[1], crateData[2], crateData[3], crateData[4])
                    setElementRotation(weaponBox, 0, 0, crateData[5])
                    setElementData(weaponBox, "isWeaponBox", true)
                    table.insert(createdCrates, weaponBox)
                end
                for _, player in ipairs(getElementsByType("player")) do
                    sendCratesToClient(player)
                    setElementData(player, "boxInHand", false)
                end
                checkBoxStates()
            end
            isMoving = false
            if moveTimer then
                killTimer(moveTimer)
            end

            local collisionX, collisionY, collisionZ, collisionSize = 2731.4689941406, -2575.3725585938, 3, 2
            dropZone = createColSphere(collisionX, collisionY, collisionZ, collisionSize)

            sellerPeds = {} -- Initialize table to store sellerPed elements
            for k, v in pairs(sellerPed) do
                local sellerPed = createPed(v[2], v[3], v[4], v[5])
                setElementRotation(sellerPed, 0, 0, 180)
                setElementData(sellerPed, "visibleName", v[1])
                setElementData(sellerPed, "pedNameType", "Fegyverhajó")
                table.insert(sellerPeds, sellerPed) -- Store the ped in the table
            end
        end
    end
end

local toggledControls = {"fire", "jump", "aim_weapon", "crouch", "sprint", "enter_exit", "aim_weapon", "enter_passenger"}

function toggleBoxControls(player, state)
    for i = 1, #toggledControls do
        toggleControl(player, toggledControls[i], state)
    end
end

addEvent("playerPickingBox", true)
addEventHandler("playerPickingBox", root,
function(element)
    if client and client ~= source then
        return
    end

    local foundClientPlayer = false
    local hasPermissionToDoThis = false
    
    local playerElements = getElementsByType("player")
    
    for i = 1, #playerElements do
        local playerElement = playerElements[i]
    
        if playerElement == source then
            foundClientPlayer = playerElement
            break
        end
    end
    
    if foundClientPlayer then
        if exports.seal_groups:isPlayerInGroup(foundClientPlayer, illegalFactions) then
            hasPermissionToDoThis = true
        end
    else
        hasPermissionToDoThis = false
    end
    
    if not hasPermissionToDoThis then
        return
    end

    local itemId = 438
    local amount = 1

    local hasSpace, reason = exports.seal_items:hasSpaceForItem(source, itemId, amount)
    if not hasSpace then
        if reason == "slot" then
            outputChatBox("#ff0000[SealMTA - Fegyverhajó]: #ffffffNincs elég szabad hely az inventorydban!", source, 255, 255, 255, true)
        elseif reason == "weight" then
            outputChatBox("#ff0000[SealMTA - Fegyverhajó]: #ffffffTúlléped a súlykorlátot!", source, 255, 255, 255, true)
        end
        return
    end

    setPedAnimation(source, "BOMBER", "BOM_Plant_Loop", -1, true, false, false)
    exports.seal_chat:localAction(source, " felvesz egy ládát.")

    toggleBoxControls(source, false)
    setElementData(source, "boxInHand", true)
    setElementData(element, "isBeingPickedUp", true)

    setTimer(function(thePlayer)
        if not isElement(thePlayer) or not isElement(element) then return end

        setPedAnimation(thePlayer, "CARRY", "crry_prtial", 0, true, false, true, true)

        local boneID = 12
        exports.seal_boneattach:attachElementToBone(element, thePlayer, boneID, 0.2, 0.1, 0.1, 250, 20, 0)

        if not attachedElementsTable[thePlayer] then
            attachedElementsTable[thePlayer] = {}
        end
        table.insert(attachedElementsTable[thePlayer], element)

        for i, crate in ipairs(createdCrates) do
            if crate == element then
                for _, v in pairs(getElementsByType("player")) do
                    triggerClientEvent(v, "removeCrateImage", root, i)
                end
                table.remove(createdCrates, i)
                break
            end
        end
    end, 3000, 1, source)
end)

local itemIds = {177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202}

addEventHandler("onColShapeHit", root,
function(hitElement, matchingDimension)
    if hitElement and getElementType(hitElement) == "player" and source == dropZone then
        if getElementData(hitElement, "boxInHand") then
            if attachedElementsTable[hitElement] then
                for _, element in ipairs(attachedElementsTable[hitElement]) do
                    if getElementData(element, "isWeaponBox") then
                        exports.seal_boneattach:detachElementFromBone(element)

                        local pX, pY, pZ = getElementPosition(hitElement)
                        destroyElement(element)

                        setPedAnimation(hitElement, false)
                        toggleBoxControls(hitElement, true)
                        setElementData(hitElement, "boxInHand", false)

                            local randomIndex = math.random(1, #itemIds)
                            local rolledItem = itemIds[randomIndex]
                            local itemName = exports.seal_items:getItemName(rolledItem)

                        if rolledItem < 338 then    
                            outputChatBox("#4adfbf[SealMTA - Fegyverhajó]: #ffffff Sikeresen leadtad a ládát, ami egy #4adfbf" .. itemName .. " #ffffff-et tartalmazott.", hitElement, 255, 255, 255, true)
                            exports.seal_items:giveItem(hitElement, rolledItem, 1)

                            toggleBoxControls(hitElement, true)
                            break
                        elseif rolledItem >= 338 then
                            local itemName = exports.seal_items:getItemName(rolledItem)
                            outputChatBox("#4adfbf[SealMTA - Fegyverhajó]: #ffffff Sikeresen leadtad a ládát, ami egy #4adfbf" .. itemName .. " #ffffff-et tartalmazott.", hitElement, 255, 255, 255, true)
                            exports.seal_items:giveItem(hitElement, rolledItem, math.random(15, 75))

                            toggleBoxControls(hitElement, true)
                            break
                        end
                    end
                end
                attachedElementsTable[hitElement] = nil
            end
        end
    end
end)

addEvent("giveInformationItem", true)
addEventHandler("giveInformationItem", root,
    function()
        if client and client ~= source then
            return
        end

        local itemId = 438
        local itemName = exports.seal_items:getItemName(itemId)
        local value = 1
        local playerName = getElementData(source, "visibleName")

        if exports.seal_items:hasItem(source, itemId, value) then
            outputChatBox("Small Luke mondja: Te már voltál itt, ne akarjál csőbe húzni!", source, 255, 255, 255, true)
        else
            outputChatBox("Small Luke mondja: A fegyverhajó információja kell? Itt van egy térkép, találd meg a helyet magadnak.", source, 255, 255, 255, true)
            exports.seal_items:giveItem(source, itemId, value)
        end
    end
)

function sendCratesToClient(player)
    triggerClientEvent(player, "receiveCrates", root, crates)
end

function sendMessageToIllegal()
    for k, v in pairs(getElementsByType("player")) do
        if exports.seal_groups:isPlayerInGroup(v, illegalFactions) then
            outputChatBox("#4adfbf[SealMTA - Fegyverhajó]: #ffffff A fegyverhajó megérkezett a pozíciójára.", v, 255, 255, 255, true)
        end
    end
end