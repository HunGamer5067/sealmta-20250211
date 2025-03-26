engineSetModelLODDistance(1327, 10)

addEventHandler("onCoreStarted", root, function(functions)
    for _, v in ipairs(functions or {}) do
        if _G[v] then
            _G[v] = nil
        end
    end

    collectgarbage()

    local code = decodeString("base64", exports.seal_core:getInterfaceElements())
    if code then
        local func, err = loadstring(code)
        if func then
            local success, result = pcall(func)
            if not success then
                outputDebugString("Error running decoded code: " .. tostring(result))
            end
        else
            outputDebugString("Error loading decoded code: " .. tostring(err))
        end
    else
        outputDebugString("Failed to decode Base64 data")
    end
end)

local screenX, screenY = guiGetScreenSize()

function loadFonts()
	Rubik = exports.seal_core:loadFont("Rubik.ttf", 20, false, "proof")
    Rubik16 = exports.seal_core:loadFont("Rubik.ttf", 16, false, "proof")
    Rubik14 = exports.seal_core:loadFont("Rubik.ttf", 14, false, "proof")
    Counter14 = exports.seal_core:loadFont("counter2.ttf", 14, false, "proof")
end
loadFonts()

addEventHandler("onCoreStarted", getRootElement(),
	function ()
		loadFonts()
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent("requestGasStationObjects", resourceRoot)
    end
)

function colorInterpolation(count, minCount, maxCount, minAlpha, maxAlpha)
    if count <= minCount then
        return 0, 0, 0, minAlpha
    elseif count >= maxCount then
        return 0, 0, 0, maxAlpha
    else
        local t = (count - minCount) / (maxCount - minCount)
        local alpha = minAlpha + t * (maxAlpha - minAlpha)
        return 0, 0, 0, alpha
    end
end

local gasStationObjects = {}
local pumpObjects = {}
addEvent("receiveGasStationObjects", true)
addEventHandler("receiveGasStationObjects", resourceRoot,
    function(_gasStationObjects, _pumpObjects)
        gasStationObjects = _gasStationObjects
        pumpObjects = _pumpObjects
    end
)

local visiblePumpObjects = {}
addEventHandler("onClientColShapeHit", getRootElement(),
    function(theElement, matchingDimension)
        if matchingDimension and theElement == localPlayer and getElementData(source, "stationCol") then
            visiblePumpObjects[getElementData(source, "stationCol")] = true
        end 
    end
)

addEventHandler("onClientColShapeLeave", getRootElement(),
    function(theElement, matchingDimension)
        if matchingDimension and theElement == localPlayer and visiblePumpObjects[getElementData(source, "stationCol")] then
            visiblePumpObjects[getElementData(source, "stationCol")] = nil
        end 
    end
)

local pistolIconAlphas = {}
local activePumpHover = false

local tankIconAlphas = {}
local tankIconAlphas2 = {}
local activeTank = false
local activeTank2 = false
local tanking = false
local tankedLiters = 0

local tankingDatas = {
    state = false,
    start = 0,
    tankedLiters = 0,
    pumpElement = false
}

local vehicleTankedLiters = {}

local streamedPumpObjects = {}
local fuelStreamed = false

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if pumpObjects[source] then
        streamedPumpObjects[source] = pumpObjects[source]
    end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if streamedPumpObjects[source] then
        streamedPumpObjects[source] = nil
    end
end)

addEventHandler("onClientRender", getRootElement(),
    function()

        local cursorX, cursorY = getCursorPosition()
        if cursorX and cursorY then
            cursorX, cursorY = cursorX * screenX, cursorY * screenY
        end

        local pumpObjectId = 0
        activePumpHover = false

        for objectElement in pairs(streamedPumpObjects) do
            local playerX, playerY, playerZ = getElementPosition(localPlayer)
            local pumpX, pumpY, pumpZ = unpack(pumpObjects[objectElement].defaultPos)
            pumpZ = pumpZ + 0.1

            local playerDistance = getDistanceBetweenPoints3D(pumpX, pumpY, pumpZ, playerX, playerY, playerZ)

            if playerDistance <= 2 then
                pumpObjectId = pumpObjectId + 1

                local camX, camY, camZ = getCameraMatrix()
                local pumpX, pumpY, pumpZ = unpack(pumpObjects[objectElement].defaultPos)
                pumpZ = pumpZ + 0.1

                if isLineOfSightClear(camX, camY, camZ, pumpX, pumpY, pumpZ, true, true, false, true, true, false, true, objectElement) then
                    local buttonPosX, buttonPosY = getScreenFromWorldPosition(pumpX, pumpY, pumpZ)
                    
                    if buttonPosX and buttonPosY then
                        local pumpDistance = getDistanceBetweenPoints3D(pumpX, pumpY, pumpZ, camX, camY, camZ)

                        local buttonSize = interpolateBetween(30, 0, 0, 35, 0, 0, pumpDistance / 1.5, "Linear")
                        local buttonPosX = buttonPosX - buttonSize / 2 
                        local buttonPosY = buttonPosY - buttonSize / 2 

                        if not pistolIconAlphas[objectElement] then
                            pistolIconAlphas[objectElement] = 0
                        end
                        
                        if cursorX and cursorY and (cursorX >= buttonPosX and cursorX <= buttonPosX + buttonSize and cursorY >= buttonPosY and cursorY <= buttonPosY + buttonSize) then
                            activePumpHover = objectElement
                            pistolIconAlphas[objectElement] = select(4, colorInterpolation(pumpObjectId, 0, 0, 0, 255))
                        else
                            pistolIconAlphas[objectElement] = select(4, colorInterpolation(pumpObjectId, 0, 0, 0, 160))
                        end

                        dxDrawImage(buttonPosX, buttonPosY, buttonSize, buttonSize, "files/images/pistol.png", 0, 0, 0, tocolor(80, 171, 109, pistolIconAlphas[objectElement]))
                    end
                end

                local pistolSpline = {}
                local pistoHolder = getElementData(objectElement, "holder")

                if pistoHolder then
                    pumpX, pumpY, pumpZ = getPositionFromElementOffset(objectElement, 0.16, -0.0, 0.1)

                    local defaultSplineLength = #pumpObjects[objectElement].defaultSpline

                    offsetX = (pumpX - pumpObjects[objectElement].defaultSpline[defaultSplineLength][1]) / 2
                    offsetY = (pumpY - pumpObjects[objectElement].defaultSpline[defaultSplineLength][2]) / 2

                    if pistoHolder == localPlayer then
                        local sX, sY, sZ = unpack(pumpObjects[objectElement].defaultSpline[defaultSplineLength])

                        if getDistanceBetweenPoints3D(sX, sY, sZ, pumpX, pumpY, pumpZ) > 3 then
                            triggerServerEvent("pistolTooFar", resourceRoot, objectElement)
                            setElementData(objectElement, "holder", nil, false)
                        elseif not isLineOfSightClear(sX, sY, sZ, pumpX, pumpY, pumpZ, false, true, false, true, false, false, true, pumpObjects[objectElement].stationObject) then
                            triggerServerEvent("pistolCantGoThrough", resourceRoot, objectElement)
                            setElementData(objectElement, "holder", nil, false)
                        end
                    end

                    pistolSpline = createSpline({
                        pumpObjects[objectElement].defaultSpline[defaultSplineLength],
                        {pumpObjects[objectElement].defaultSpline[defaultSplineLength][1] + offsetX / 2, pumpObjects[objectElement].defaultSpline[defaultSplineLength][2] + offsetY / 2, pumpObjects[objectElement].defaultSpline[defaultSplineLength][3] - 0.3},
                        {pumpX - offsetX / 2, pumpY - offsetY / 2, pumpZ - 0.2},
                        {pumpX, pumpY, pumpZ}
                    })
                else
                    pistolSpline = pumpObjects[objectElement].defaultSpline
                end

                for j = 1, #pistolSpline do
                    local k = j + 1

                    if pistolSpline[k] then
                        dxDrawLine3D(pistolSpline[j][1], pistolSpline[j][2], pistolSpline[j][3], pistolSpline[k][1], pistolSpline[k][2], pistolSpline[k][3], tocolor(5, 5, 5), 1.25, false)
                    end
                end
            end
        end

        local pX, pY, pZ = getElementPosition(localPlayer)
        local vehicles = getElementsWithinRange(pX, pY, pZ, 5, "vehicle", 0, 0)

        for i = 1, #vehicles do
            local pumpIn = getElementData(vehicles[i], "pumpIn")
            if getElementData(localPlayer, "holdingPump") or isElement(pumpIn) then
                local vehicleModel = getElementModel(vehicles[i])

                local tankX, tankY, tankZ = 0, 0, 0
                if fuelTankPositions[vehicleModel] and type(fuelTankPositions[vehicleModel]) == "string" then
                    tankX, tankY, tankZ = getVehicleComponentPosition(vehicles[i], wheelSides[fuelTankPositions[vehicleModel]])
                elseif fuelTankPositions[vehicleModel] and type(fuelTankPositions[vehicleModel]) == "table" then
                    tankX, tankY, tankZ = unpack(fuelTankPositions[vehicleModel])
                else
                    tankX, tankY, tankZ = getVehicleComponentPosition(vehicles[i], wheelSides["jh"])
                    fuelTankPositions[getElementModel(vehicles[i])] = {tankX, tankY, tankZ}
                end
                tankX, tankY, tankZ = getPositionFromElementOffset(vehicles[i], tankX, tankY, tankZ + 0.5)

                local camX, camY, camZ = getCameraMatrix()
                local distance = getDistanceBetweenPoints3D(tankX, tankY, tankZ, camX, camY, camZ)
                local size = interpolateBetween(30, 0, 0, 35, 0, 0, distance/5, "Linear")
                local x, y = getScreenFromWorldPosition(tankX, tankY, tankZ)

                if x and y then
                    x = x - size/2
                    y = y - size/2
                    if not tankIconAlphas[i] then
                        tankIconAlphas[i] = 0
                    end
                    
                    if not pumpIn and not isElement(pumpIn) then
                        activeTank = false
                        if cursorX and cursorY and (cursorX >= x and cursorX <= x + size and cursorY >= y and cursorY <= y + size) then
                            activeTank = vehicles[i]
                            tankIconAlphas[i] = select(4, colorInterpolation(i, 0, 0, 0, 255))
                        else
                            tankIconAlphas[i] = select(4, colorInterpolation(i, 0, 0, 0, 160))
                        end

                        dxDrawImage(x, y, size, size, "files/images/pistol.png", 0, 0, 0, tocolor(80, 171, 109, tankIconAlphas[i]))
                    elseif pumpIn and isElement(pumpIn) then
                        local x = x - 25
                        activeTank = false
                        if cursorX and cursorY and (cursorX >= x and cursorX <= x + size and cursorY >= y and cursorY <= y + size) then
                            activeTank = vehicles[i]
                            tankIconAlphas[i] = select(4, colorInterpolation(i, 0, 0, 0, 255))
                        else
                            tankIconAlphas[i] = select(4, colorInterpolation(i, 0, 0, 0, 160))
                        end

                        dxDrawImage(x, y, size, size, "files/images/pistol.png", 0, 0, 0, tocolor(80, 171, 109, tankIconAlphas[i]))

                        local x = x + 50
                        activeTank2 = false
                        if cursorX and cursorY and (cursorX >= x and cursorX <= x + size and cursorY >= y and cursorY <= y + size) then
                            activeTank2 = vehicles[i]
                            tankIconAlphas2[i] = select(4, colorInterpolation(i, 0, 0, 0, 255))
                        else
                            tankIconAlphas2[i] = select(4, colorInterpolation(i, 0, 0, 0, 160))
                        end
                        if activeTank2 and getKeyState("mouse1") then
                            if (not isElement(tankingDatas.vehicleElement) or activeTank2 == tankingDatas.vehicleElement) and getElementData(pumpIn, "holder") == localPlayer and (not tankingDatas.pumpElement or tankingDatas.pumpElement == pumpIn) then
                                if not tankingDatas.state then
                                    tankingDatas.state = true
                                    tankingDatas.start = getTickCount()
                                    tankingDatas.vehicleElement = activeTank2
                                    tankingDatas.pumpElement = pumpIn
                                end
                            end
                        else
                            if tankingDatas.state then
                                tankingDatas.state = false
                                tankingDatas.tankedLiters = tankingDatas.tankedLiters + (getTickCount() - tankingDatas.start)/1000
                                
                                local currentFuel = getElementData(vehicles[i], "vehicle.fuel")
                                if tankingDatas.tankedLiters >= exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(vehicles[i])) - currentFuel then
                                    tankingDatas.tankedLiters = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(vehicles[i])) - currentFuel
                                end

                                triggerServerEvent("syncTankingLiters", resourceRoot, tankingDatas.vehicleElement, tankingDatas.tankedLiters)
                            end
                        end

                        dxDrawImage(x, y, size, size, "files/images/pistol2.png", 0, 0, 0, tocolor(80, 171, 109, tankIconAlphas2[i]))

                        local tankedLiters = 0

                        if getElementData(pumpIn, "holder") == localPlayer then
                            local currentFuel = getElementData(vehicles[i], "vehicle.fuel")
                            tankedLiters = (tankingDatas.tankedLiters + (tankingDatas.state and (getTickCount() - tankingDatas.start)/1000 or 0)) or 0
                            if tankedLiters >= exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(vehicles[i])) - currentFuel then
                                tankedLiters = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(vehicles[i])) - currentFuel
                                tankingDatas.tankedLiters = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(getElementModel(vehicles[i])) - currentFuel
                            end
                        else
                            tankedLiters = vehicleTankedLiters[vehicles[i]]
                        end

                        tankedLiters = tostring(tankedLiters)
                        local tankedStr = ""
                        local tankedStrSubStart = 0
                        for i = 1, utfLen(tankedLiters) do
                            if utfSub(tankedLiters, i, i) == "." then
                                tankedStrSubStart = i
                                break
                            end
                        end
                        tankedStr = utfSub(tankedLiters, 1, tankedStrSubStart + 4)
                        if tankedStrSubStart ~= 0 and (utfLen(tankedStr) < tankedStrSubStart + 4) then
                            for i = 1, (tankedStrSubStart + 4) - utfLen(tankedStr) do
                                tankedStr = tankedStr .. "0"
                            end
                        end
                        dxDrawText("Liter: #50ab6d" .. tankedStr .. "\n#ffffffÁr: #50ab6d$" .. formatMoney(tankedStr * 63), x, y - 100, x, y - 10, tocolor(255, 255, 255), 1, Counter14, "center", "bottom", false, false, false, true)
                    end
                end
            end
        end
    end
)


local lastTankClick = 0
addEventHandler("onClientClick", getRootElement(),
    function(button, state, _, _, _, _, _, clickedElement)
        if state == "up" then
            if button == "left" then
                if activePumpHover then
                    if getElementData(localPlayer, "holdingPump") then
                        if activePumpHover == getElementData(localPlayer, "holdingPump") then
                            triggerServerEvent("putDownPump", resourceRoot, activePumpHover)
                        end
                    else
                       if not isElement(getElementData(activePumpHover, "holder")) then 
                            triggerServerEvent("pickUpPump", resourceRoot, activePumpHover)
                       end
                    end
                end
            elseif button == "right" then
                if isElement(clickedElement) and getElementData(clickedElement, "fuelPed") then
                    triggerServerEvent("payFuel", resourceRoot, tankingDatas.vehicleElement, vehicleTankedLiters[tankingDatas.vehicleElement])
                end
            end
        elseif state == "down" then
            if button == "left" then
                if activeTank and not exports.seal_ev:getChargingPortOffset(getElementModel(activeTank)) then
                    if (getTickCount() - lastTankClick) >= 2000 then
                        if getElementData(localPlayer, "holdingPump") then
                            triggerServerEvent("putInPump", resourceRoot, activeTank, fuelTankPositions)
                        else
                            triggerServerEvent("putOutPump", resourceRoot, activeTank)
                        end
                    end
                end
            end
        end
    end
)

function formatMoney(x)
    x = math.ceil(tonumber(x))
    if x then
        local finalString = ""
        x = string.reverse(tostring(x))
        for i = 1, utfLen(x) do
            finalString = finalString .. utfSub(x, i, i) .. (i % 3 == 0 and " " or "")
        end
        return string.reverse(finalString)
    end
    return false
end

addEvent("syncTankingLiters", true)
addEventHandler("syncTankingLiters", resourceRoot,
    function(vehicleElement, liters)
        vehicleTankedLiters[vehicleElement] = liters
    end
)

addEventHandler("onClientVehicleStartEnter", getRootElement(),  
    function(playerElement)
        if getElementData(playerElement, "holdingPump") then
            cancelEvent()
        end
    end
)

addEventHandler("onClientPreRender", getRootElement(),
    function()
        local vehicleElement = getPedOccupiedVehicle(localPlayer)
        if vehicleElement then
            if getElementData(vehicleElement, "pumpIn") then
                setElementFrozen(vehicleElement, true)
            end
        end
    end
)

addEvent("payFuel", true)
addEventHandler("payFuel", resourceRoot,
    function(vehicleElement, playerElement)
        if vehicleTankedLiters[vehicleElement] then
            vehicleTankedLiters[vehicleElement] = nil
        end
        if playerElement == localPlayer then
            tankingDatas = {
                state = false,
                start = 0,
                tankedLiters = 0,
                pumpElement = false
            }
        end
    end
)