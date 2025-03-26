local handledSuperchargerPreRender = false
local handledSuperchargerPedProcess = false

local handledRenderNotInHand = false
local handledClickNotInHand = false

local handledRenderInHand = false
local handledClickInHand = false

local lastButtonTry = 0

local function handleSuperchargerPreRender(state, prio)
    if handledSuperchargerPreRender ~= state then
        handledSuperchargerPreRender = state
        
        if handledSuperchargerPreRender then
            addEventHandler("onClientPreRender", getRootElement(), preRenderSuperchargers, true, prio)
        else
            removeEventHandler("onClientPreRender", getRootElement(), preRenderSuperchargers)
        end
    end
end

local function handleSuperchargerPedProcess(state, prio)
  if handledSuperchargerPedProcess ~= state then
        handledSuperchargerPedProcess = state

        if handledSuperchargerPreRender then
            addEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedSuperchargers, true, prio)
        else
            removeEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedSuperchargers)
        end
    end
end

local function handleRenderNotInHand(state, prio)
    if handledRenderNotInHand ~= state then
        handledRenderNotInHand = state

        if handledRenderNotInHand then
            addEventHandler("onClientRender", getRootElement(), renderNotInHand, true, prio)
        else
            removeEventHandler("onClientRender", getRootElement(), renderNotInHand)
        end
    end
end

local function handleClickNotInHand(state, prio)
    if handledClickNotInHand ~= state then
        handledClickNotInHand = state

        if handledClickNotInHand then
            addEventHandler("onClientClick", getRootElement(), clickNotInHand, true, prio)
        else
            removeEventHandler("onClientClick", getRootElement(), clickNotInHand)
        end
    end
end

local function handleRenderInHand(state, prio)
    if handledRenderInHand ~= state then
        handledRenderInHand = state

        if handledRenderInHand then
            addEventHandler("onClientRender", getRootElement(), renderInHand, true, prio)
        else
            removeEventHandler("onClientRender", getRootElement(), renderInHand)
        end
    end
end

local function handleClickInHand(state, prio)
    if handledClickInHand ~= state then
        handledClickInHand = state

        if handledClickInHand then
            addEventHandler("onClientClick", getRootElement(), clickInHand, true, prio)
        else
            removeEventHandler("onClientClick", getRootElement(), clickInHand)
        end
    end
end

local boltIcon = false
local grey1 = false
local green = false
local green2 = false
local faTicks = false

local function r11_0()
    local res = getResourceFromName("seal_gui")
    if res and getResourceState(res) == "running" then
        boltIcon = exports.seal_gui:getFaIconFilename("bolt", 64)
        grey1 = exports.seal_gui:getColorCode("grey1")
        green = exports.seal_gui:getColorCodeToColor("green")
        green2 = exports.seal_gui:getColorCode("green")
        faTicks = exports.seal_gui:getFaTicks()
    end
end
addEventHandler("onGuiRefreshColors", getRootElement(), r11_0)
addEventHandler("onClientResourceStart", getResourceRootElement(), r11_0)

addEventHandler("refreshFaTicks", getRootElement(), function()
    faTicks = exports.seal_gui:getFaTicks()
end)

local screenX, screenY = guiGetScreenSize()

local chargerObjects = {}
local pistolInHand = false

addEventHandler("onClientObjectBreak", getRootElement(), function(attacker)
    for i = 1, #superchargerList, 1 do
        local supercharger = superchargerList[i]

        if supercharger.object == source then
            cancelEvent()
        end
    end
end)

addEventHandler("onClientResourceStart", getRootElement(), function(startedResource)
    if startedResource == getThisResource() then
        local chargerModelID = 7459
        local pistolModelID = 327

        for i = 1, #superchargerList, 1 do
            local supercharger = superchargerList[i]

            supercharger.object = createObject(chargerModelID, supercharger.pos[1], supercharger.pos[2], supercharger.pos[3], 0, 0, supercharger.pos[4])
            setElementDimension(supercharger.object, supercharger.dimension or 0)
            chargerObjects[supercharger.object] = i

            local x = supercharger.pos[1]
            local y = supercharger.pos[2]
            local z = supercharger.pos[3]

            local cosAngle, sinAngle = supercharger.cos, supercharger.sin

            supercharger.pistolPos = {
                x + cosAngle * 0.4691 - sinAngle * 0.04,
                y + sinAngle * 0.469 + cosAngle * 0.04,
                z + 1.0088
            }
        
            supercharger.cablePos = {
                x + cosAngle * 0.3818 + sinAngle * 0.045,
                y + sinAngle * 0.3818 - cosAngle * 0.045,
                z + 1.7433
            }
            supercharger.pistol = createObject(
                327,
                supercharger.pistolPos[1],
                supercharger.pistolPos[2],
                supercharger.pistolPos[3],
                0, -10, supercharger.pos[4]
            )

            setElementCollisionsEnabled(supercharger.pistol, false)
            setElementDimension(supercharger.pistol, supercharger.dimension or 0)
        
            local cableStartX, cableStartY, cableStartZ = supercharger.cablePos[1], supercharger.cablePos[2], supercharger.cablePos[3]
            local cableDiffX = supercharger.pistolPos[1] - cableStartX
            local cableDiffY = supercharger.pistolPos[2] - cableStartY
            local cableDiffZ = supercharger.pistolPos[3] - cableStartZ
        
            supercharger.defaultCable = {}
            for segment = 1, 20 do
                local segmentX, segmentY, segmentZ = findCablePos(
                    cableStartX, cableStartY, cableStartZ,
                    cableDiffX, cableDiffY, cableDiffZ,
                    1, segment
                )
                table.insert(supercharger.defaultCable, { segmentX, segmentY, segmentZ })
            end


            addEventHandler("onClientElementStreamIn", supercharger.object, superchargerStreamIn)
            addEventHandler("onClientElementStreamOut", supercharger.object, superchargerStreamOut)
        end
  
        triggerServerEvent("requestSuperchargerSync", localPlayer)
    end
end)

function findCablePos(startX, startY, startZ, directionX, directionY, directionZ, distanceFactor, distance)
    local scaledDistance = distance / 20 * distanceFactor
    local newX = startX + directionX * scaledDistance
    local newY = startY + directionY * scaledDistance
    local newZ = startZ + directionZ * scaledDistance - math.sin(scaledDistance * math.pi)
    
    return newX, newY, newZ
end

local streamedChargers = {}
local streamedVehicleChargingPorts = {}

local chargerRenderTarget = false
local chargerShader = false
local chargerShaderRaw = " texture gTexture; technique hello { pass P0 { Texture[0] = gTexture; } } "

local hoveredCharger = false
local hoveredElement = false

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        if streamedVehicleChargingPorts[source] then
            setVehicleComponentRotation(source, "chargingport", 0, 0, 0)
        end

        streamedVehicleChargingPorts[source] = nil
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
    if getElementType(source) == "vehicle" then
        streamedVehicleChargingPorts[source] = nil
    end
end)

function superchargerStreamIn()
    local chargerObject = chargerObjects[source]

    if chargerObject then
        handleSuperchargerPreRender(true)
        handleSuperchargerPedProcess(true, "low-99999999999")
        handleRenderNotInHand(not pistolInHand)
        handleClickNotInHand(not pistolInHand)

        if not isElement(chargerRenderTarget) then
            chargerRenderTarget = dxCreateRenderTarget(1, 1)

            if isElement(chargerShader) then
                dxSetShaderValue(chargerShader, "gTexture", chargerRenderTarget)
            end
        end

        if not isElement(chargerShader) then
            chargerShader = processText(chargerShaderRaw)
            dxSetShaderValue(chargerShader, "gTexture", chargerRenderTarget)
        end

        for i = 1, #streamedChargers, 1 do
            if streamedChargers[i] == chargerObject then
                return 
            end
        end

        table.insert(streamedChargers, chargerObject)
        superchargerList[chargerObject].streamedIn = true

        if superchargerList[chargerObject].pistolInVehicle then
            engineApplyShaderToWorldTexture(chargerShader, "v4_plugsee_led", superchargerList[chargerObject].object)
        end
    end
end

function superchargerStreamOut()
    local chargerObject = chargerObjects[source]

    if chargerObject then
        for i = #streamedChargers, 1, -1 do
            if streamedChargers[i] == chargerObject then
                table.remove(streamedChargers, i)
            end
        end

        handleRenderNotInHand(#streamedChargers > 0 and not pistolInHand)
        handleClickNotInHand(#streamedChargers > 0 and not pistolInHand)

        if hoveredCharger or hoveredElement then
            exports.seal_gui:setCursorType("normal")
            exports.seal_gui:showTooltip(false)
        end

        hoveredCharger = false
        hoveredElement = false

        superchargerList[chargerObject].streamedIn = false
        superchargerList[chargerObject].soundP = false

        if isElement(superchargerList[chargerObject].sound) then
            destroyElement(superchargerList[chargerObject].sound)
        end
        superchargerList[chargerObject].sound = nil

        if isElement(chargerShader) then
            engineRemoveShaderFromWorldTexture(chargerShader, "v4_plugsee_led", superchargerList[chargerObject].object)
        end
    end
end

function preRenderSuperchargers(delta)
    dxSetRenderTarget(chargerRenderTarget)
    local dynamicAlpha = (math.cos(getTickCount() / 250) / 2 + 0.5) * 255
    dxDrawRectangle(0, 0, 1, 1, tocolor(10, 30, 20))
    dxDrawRectangle(0, 0, 1, 1, tocolor(60, 184, 130, dynamicAlpha))
    dxSetRenderTarget()

    local renderStreamedChargers = #streamedChargers <= 0
    local vehicles = getElementsByType("vehicle", getRootElement(), true)
    local fasz = {}

    for i = 1, #streamedChargers, 1 do
        local streamedCharger = streamedChargers[i]
    
        if streamedCharger then
            local charger = superchargerList[streamedCharger]

            if charger.pistolInVehicle then
                fasz[charger.pistolInVehicle] = true

                if not charger.soundP then
                    if isElement(charger.sound) then
                      destroyElement(charger.sound)
                    end
                    charger.sound = nil
                    charger.soundP = 0
                    charger.sound = playSound3D("sounds/charger.mp3", charger.pos[1], charger.pos[2], charger.pos[3], true)
                    setElementDimension(charger.sound, charger.dimension or 0)
                end
                charger.soundP = math.min(1, charger.soundP + delta / 3000)
            else
                if charger.pistolInHand then
                    local vehiclesInCol = getElementsWithinColShape(charger.vehicleCol, "vehicle")

                    for j = 1, #vehiclesInCol, 1 do
                        local vehicle = vehiclesInCol[j]
                        local vehicleModel = getElementModel(vehicle)

                        if chargingPortRotation[vehicleModel] then
                            fasz[vehicle] = true
                        end
                    end
                end

                if charger.soundP then
                    charger.soundP = math.max(0, charger.soundP - delta / 5000)

                    if charger.soundP <= 0 then
                        charger.soundP = nil

                        if isElement(charger.sound) then
                            destroyElement(charger.sound)
                        end

                        charger.sound = nil
                    end
                end
            end

            if charger.soundP then
                setSoundVolume(charger.sound, math.min(1, charger.soundP * 3))
                setSoundSpeed(charger.sound, 0.5 + charger.soundP * 0.5)
            end
        end
    end

    for vehicleElement in pairs(streamedVehicleChargingPorts) do
        local vehicleModel = getElementModel(vehicleElement)
        local chargingPortRot = chargingPortRotation[vehicleModel]

        if chargingPortRot then
            local easingValue = getEasingValue(streamedVehicleChargingPorts[vehicleElement], "InOutQuad")
            setVehicleComponentRotation(vehicleElement, "chargingport", chargingPortRot[1] * easingValue, chargingPortRot[2] * easingValue, chargingPortRot[3] * easingValue)
        end

        if fasz[vehicleElement] then
            streamedVehicleChargingPorts[vehicleElement] = math.min(1, streamedVehicleChargingPorts[vehicleElement] + 1 * delta / 800)
            fasz[vehicleElement] = nil
        else
            if streamedVehicleChargingPorts[vehicleElement] >= 1 then
                local chargingPortOffset = chargingPortOffset[vehicleModel]

                if not chargingPortOffset then
                    chargingPortOffset = {0, 0, 0}
                end

                local sound = playSound3D("sounds/plug.mp3", 0, 0, 0)
                setElementDimension(sound, getElementDimension(vehicleElement))
                attachElements(sound, vehicleElement, chargingPortOffset[1], chargingPortOffset[2], chargingPortOffset[3])
            end

            streamedVehicleChargingPorts[vehicleElement] = math.max(0, streamedVehicleChargingPorts[vehicleElement] - 1 * delta / 800)
            if streamedVehicleChargingPorts[vehicleElement] <= 0 then
                streamedVehicleChargingPorts[vehicleElement] = nil
            end
        end

        renderStreamedChargers = false
    end

    for vehicleElement in pairs(fasz) do
        if isElement(vehicleElement) then
            local vehicleModel = getElementModel(vehicleElement)
            local chargingOffset = chargingPortOffset[vehicleModel]

            if not chargingOffset then
                chargingOffset = {0, 0, 0}
            end

            local sound = playSound3D("sounds/plug.mp3", 0, 0, 0)
            setElementDimension(sound, getElementDimension(vehicleElement))
            attachElements(sound, vehicleElement, chargingOffset[1], chargingOffset[2], chargingOffset[3])
            streamedVehicleChargingPorts[vehicleElement] = 0
            renderStreamedChargers = false
        end
    end

    if renderStreamedChargers then
        handleSuperchargerPreRender(false)
        handleSuperchargerPedProcess(false, "low-99999999999")

        if isElement(chargerRenderTarget) then
            destroyElement(chargerRenderTarget)
        end
        chargerRenderTarget = nil

        if isElement(chargerShader) then
            destroyElement(chargerShader)
        end
        chargerShader = nil
    end
end

function pedsProcessedSuperchargers()
    for index = 1, #streamedChargers do
        local supercharger = superchargerList[streamedChargers[index]]

        if supercharger.pistolInHand or supercharger.pistolInVehicle then
            local cablePosX, cablePosY, cablePosZ = unpack(supercharger.cablePos)
            local pistolPosX, pistolPosY, pistolPosZ = getElementPosition(supercharger.pistol)

            local deltaX = pistolPosX - cablePosX
            local deltaY = pistolPosY - cablePosY
            local deltaZ = pistolPosZ - cablePosZ

            local currentX, currentY, currentZ = cablePosX, cablePosY, cablePosZ

            for segment = 1, 20 do
                local cableX, cableY, cableZ = findCablePos(cablePosX, cablePosY, cablePosZ, deltaX, deltaY, deltaZ, 1, segment)
                dxDrawLine3D(currentX, currentY, currentZ, cableX, cableY, cableZ, tocolor(0, 0, 0, 255), 2)
                currentX, currentY, currentZ = cableX, cableY, cableZ
            end
        else
            local cablePosX, cablePosY, cablePosZ = unpack(supercharger.cablePos)
            
            for i = 1, #supercharger.defaultCable do
                local defaultCableX, defaultCableY, defaultCableZ = unpack(supercharger.defaultCable[i])
                dxDrawLine3D(cablePosX, cablePosY, cablePosZ, defaultCableX, defaultCableY, defaultCableZ, tocolor(0, 0, 0, 255), 2)
                cablePosX, cablePosY, cablePosZ = defaultCableX, defaultCableY, defaultCableZ
            end
        end
    end
end

function renderNotInHand()
    local px, py, pz = getElementPosition(localPlayer)
    local cursorX, cursorY = getCursorPosition()

    if cursorX then
        cursorX = cursorX * screenX
        cursorY = cursorY * screenY
    end

    local tempHover = false
    local pedVeh = getPedOccupiedVehicle(localPlayer)

    if pedVeh then
        local vehicleModel = getElementModel(pedVeh)

        if chargingPortOffset[vehicleModel] then
            for i = 1, #streamedChargers, 1 do
                if isElementWithinColShape(pedVeh, superchargerList[streamedChargers[i]].vehicleCol) then
                    local charingPosX, charingPosY, charingPosZ = getChargingPortPosition(pedVeh)
                    local x, y = getScreenFromWorldPosition(charingPosX, charingPosY, charingPosZ, 32)

                    if x then
                        local alpha = getTickCount() % 1600 / 800

                        if alpha > 1 then
                            alpha = 2 - alpha
                        end
                        alpha = getEasingValue(alpha, "InOutQuad") * 255

                        for j = -1, 1, 2 do
                            for k = -1, 1, 2 do
                                dxDrawImage(x - 16 + j, y - 16 + k, 32, 32, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(0, 0, 0, alpha))
                            end
                        end

                        dxDrawImage(x - 16, y - 16, 32, 32, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(green2[1], green2[2], green2[3], alpha))
                    end
                end
            end
        end
    else
        for i = 1, #streamedChargers, 1 do
            local streamedCharger = streamedChargers[i]

            if streamedCharger then
                local charger = superchargerList[streamedCharger]

                if charger then
                    if charger.pistolInVehicle then
                        x, y, z = getElementPosition(charger.pistol)
                    elseif not charger.pistolInHand then
                        x = charger.pistolPos[1]
                        y = charger.pistolPos[2]
                        z = charger.pistolPos[3] + 0.25
                    end

                    if x then
                        local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

                        if distance < 1.25 then
                            local x, y = getScreenFromWorldPosition(x, y, z, 32)

                            if x then
                                local alpha = (1 - math.max(0, (distance - 1) / 0.25)) * 255
                                dxDrawRectangle(x - 16, y - 16, 32, 32, tocolor(grey1[1], grey1[2], grey1[3], alpha))

                                if cursorX and 255 <= alpha and x - 16 <= cursorX and y - 16 <= cursorY and cursorX <= x + 16 and cursorY <= y + 16 then
                                    tempHover = streamedCharger
                                    dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(green2[1], green2[2], green2[3], alpha))
                                else
                                    dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(255, 255, 255, alpha))
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if tempHover ~= hoveredCharger then
        hoveredCharger = tempHover

        if hoveredCharger then
            exports.seal_gui:setCursorType("link")
            exports.seal_gui:showTooltip("Töltőfej felvétele")
        else
            exports.seal_gui:setCursorType("normal")
            exports.seal_gui:showTooltip(false)
        end
    end
end

function clickNotInHand(button, state)
    if state == "down" and hoveredCharger then
        triggerServerEvent("trySuperchargerPistolInHand", localPlayer, hoveredCharger)
    end
end

function getChargingPortPosition(vehicle)
    local chargingPortX, chargingPortY, chargingPortZ = getVehicleComponentPosition(vehicle, "chargingport", "world")
    
    if not chargingPortX then
        local vehicleMatrix = getElementMatrix(vehicle)
        
        if not vehicleMatrix then
            return getElementPosition(vehicle)
        end
        
        local vehicleModel = getElementModel(vehicle)
        
        if chargingPortOffset[vehicleModel] then
            local offset = chargingPortOffset[vehicleModel]
            chargingPortX = vehicleMatrix[4][1] + offset[1] * vehicleMatrix[1][1] + offset[2] * vehicleMatrix[2][1] + offset[3] * vehicleMatrix[3][1]
            chargingPortY = vehicleMatrix[4][2] + offset[1] * vehicleMatrix[1][2] + offset[2] * vehicleMatrix[2][2] + offset[3] * vehicleMatrix[3][2]
            chargingPortZ = vehicleMatrix[4][3] + offset[1] * vehicleMatrix[1][3] + offset[2] * vehicleMatrix[2][3] + offset[3] * vehicleMatrix[3][3]
        else
            chargingPortX = vehicleMatrix[4][1]
            chargingPortY = vehicleMatrix[4][2]
            chargingPortZ = vehicleMatrix[4][3]
        end
    end
    
    return chargingPortX, chargingPortY, chargingPortZ
end

addEvent("syncSuperchargerUser", true)
addEventHandler("syncSuperchargerUser", getRootElement(), function(charger, target)
    local supercharger = superchargerList[charger]

    if pistolInHand == charger then
        pistolInHand = false

        handleRenderInHand(false)
        handleClickInHand(false)
        handleClickNotInHand(0 < #streamedChargers)
        handleRenderNotInHand(0 < #streamedChargers)

        if hoveredCharger or hoveredElement then
            exports.seal_gui:setCursorType("normal")
            exports.seal_gui:showTooltip(false)
        end

        hoveredCharger = false
        hoveredElement = false
    end

    detachElements(supercharger.pistol)
    exports.pattach:detach(supercharger.pistol)

    local pistolInVehicle = supercharger.pistolInVehicle
    supercharger.pistolInHand = false
    supercharger.pistolInVehicle = false

    if supercharger.streamedIn then
        engineRemoveShaderFromWorldTexture(chargerShader, "v4_plugsee_led", supercharger.object)
    end

    if isElement(target) then
        if target == localPlayer then
            pistolInHand = charger

            handleRenderInHand(true)
            handleClickInHand(true)
            handleClickNotInHand(false)
            handleRenderNotInHand(false)

            if hoveredCharger or hoveredElement then
                exports.seal_gui:setCursorType("normal")
                exports.seal_gui:showTooltip(false)
            end
    
            hoveredCharger = false
            hoveredElement = false
        end

        if getElementType(target) == "player" then
            exports.pattach:attach(supercharger.pistol, target, "right-hand", 0.1, 0.05, 0, 0, 0, 110)
            exports.pattach:disableScreenCheck(supercharger.pistol, true)
            supercharger.pistolInHand = target

            if supercharger.streamedIn then
                local pistolPosX = supercharger.pistolPos[1]
                local pistolPosY = supercharger.pistolPos[2]
                local pistolPosZ = supercharger.pistolPos[3]

                if pistolInVehicle then
                    if isElement(pistolInVehicle) then
                        pistolPosX, pistolPosY, pistolPosZ = getChargingPortPosition(pistolInVehicle)
                    end

                    local sound = playSound3D("sounds/plugout.mp3", pistolPosX, pistolPosY, pistolPosZ)
                    setElementDimension(sound, supercharger.dimension or 0)
                else
                    local sound = playSound3D("sounds/pickup.mp3", pistolPosX, pistolPosY, pistolPosZ)
                    setElementDimension(sound, supercharger.dimension or 0)
                end
            end
        elseif getElementType(target) == "vehicle" then
            if supercharger.streamedIn then
                engineApplyShaderToWorldTexture(chargerShader, "v4_plugsee_led", supercharger.object)
            end

            local chargingPortX, chargingPortY, chargingPortZ = 0, 0, 0
            local chargingRotY, chargingRotZ = 0, 0

            local vehicleModel = getElementModel(target)
            if chargingPortOffset[vehicleModel] then
                chargingPortX, chargingPortY, chargingPortZ, chargingRotY, chargingRotZ = unpack(chargingPortOffset[vehicleModel])
            end

            attachElements(supercharger.pistol, target, chargingPortX, chargingPortY, chargingPortZ, 0, chargingRotY, chargingRotZ)
            supercharger.pistolInVehicle = target

            if supercharger.streamedIn then
                local soundPosX, soundPosY, soundPosZ = getChargingPortPosition(supercharger.pistolInVehicle)
                local sound = playSound3D("sounds/plugin.mp3", soundPosX, soundPosY, soundPosZ)
                setElementDimension(sound, supercharger.dimension or 0)
            end
        end
    else
        setElementPosition(supercharger.pistol, supercharger.pistolPos[1], supercharger.pistolPos[2], supercharger.pistolPos[3])
        setElementRotation(supercharger.pistol, 0, -10, supercharger.pos[4])

        if supercharger.streamedIn then
            local sound = playSound3D("sounds/pickup.mp3", supercharger.pistolPos[1], supercharger.pistolPos[2], supercharger.pistolPos[3])
            setElementDimension(sound, supercharger.dimension or 0)
        end
    end
end)

function renderInHand()
    local px, py, pz = getElementPosition(localPlayer)
    local cursorX, cursorY = getCursorPosition()

    if cursorX then
        cursorX = cursorX * screenX
        cursorY = cursorY * screenY
    end

    local tempHover = false

    local charger = superchargerList[pistolInHand]
    local pistolPosX = charger.pistolPos[1]
    local pistolPosY = charger.pistolPos[2]
    local pistolPosZ = charger.pistolPos[3] + 0.25

    local distance = getDistanceBetweenPoints3D(pistolPosX, pistolPosY, pistolPosZ, px, py, pz)

    if distance < 1.25 then
        local x, y = getScreenFromWorldPosition(pistolPosX, pistolPosY, pistolPosZ, 32)

        if x then
            local alpha = (1 - math.max(0, (distance - 1) / 0.25)) * 255
            dxDrawRectangle(x - 16, y - 16, 32, 32, tocolor(grey1[1], grey1[2], grey1[3], alpha))

            if cursorX and 255 <= alpha and x - 16 <= cursorX and y - 16 <= cursorY and cursorX <= x + 16 and cursorY <= y + 16 then
                tempHover = true
                dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(green2[1], green2[2], green2[3], alpha))
            else
                dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(255, 255, 255, alpha))
            end
        end
    end

    local chargeVehicles = getElementsWithinColShape(charger.vehicleCol, "vehicle")

    for i = 1, #chargeVehicles, 1 do
        local vehicle = chargeVehicles[i]

        if streamedVehicleChargingPorts[vehicle] and 1 <= streamedVehicleChargingPorts[vehicle] then
            local chargingPosX, chargingPosY, chargingPosZ = getChargingPortPosition(vehicle)
            local distance = getDistanceBetweenPoints3D(px, py, pz, chargingPosX, chargingPosY, chargingPosZ)

            if distance < 1.25 then
                local x, y = getScreenFromWorldPosition(chargingPosX, chargingPosY, chargingPosZ, 32)

                if x then
                    local alpha = (1 - math.max(0, (distance - 1) / 0.25)) * 255
                    dxDrawRectangle(x - 16, y - 16, 32, 32, tocolor(grey1[1], grey1[2], grey1[3], alpha))
        
                    if cursorX and 255 <= alpha and x - 16 <= cursorX and y - 16 <= cursorY and cursorX <= x + 16 and cursorY <= y + 16 then
                        tempHover = vehicle
                        dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(green2[1], green2[2], green2[3], alpha))
                    else
                        dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. boltIcon .. faTicks[boltIcon], 0, 0, 0, tocolor(255, 255, 255, alpha))
                    end
                end
            end
        end
    end

    if tempHover ~= hoverElement then
        hoveredElement = tempHover

        if tempHover then
            cursorType = "link"
        else
            cursorType = "normal"
        end
        exports.seal_gui:setCursorType(cursorType)

        if isElement(tempHover) then
            exports.seal_gui:showTooltip("Töltőfej bedugása\nTöltési díj: " .. exports.seal_gui:thousandsStepper(charger.chargingPrice) .. " $/perc")
        elseif tempHover then
            exports.seal_gui:showTooltip("Töltőfej visszahelyezése")
        else
            exports.seal_gui:showTooltip(false)
        end
    end

    if isPedInVehicle(localPlayer) or 3 < distance then
        triggerServerEvent("trySuperchargerPistolInHand", localPlayer)
        handleRenderInHand(false)
    end
end

function clickInHand(button, state)
    if state == "down" then
        if getTickCount() - lastButtonTry < 5000 then
            exports.seal_gui:showInfobox("e", "Kérlek várj 5 másodpercet!")
            return
        end

        if isElement(hoveredElement) then
            triggerServerEvent("putSuperchargerPistolInVehicle", localPlayer, hoveredElement)
        elseif hoveredElement then
            triggerServerEvent("trySuperchargerPistolInHand", localPlayer)
        end

        lastButtonTry = getTickCount()
    end
end