local gasStationObjects = {}
local pumpObjects = {}

function createGasStation(posX, posY, posZ, rotZ)
    local stationObject = createObject(3465, posX, posY, posZ, 0, 0, rotZ)
    setElementData(stationObject, "gasStation", true)
    
    local pumpPositions = {}
    gasStationObjects[stationObject] = {object = stationObject, pumps = {}}

    for i = 1, 6 do
        local pumpX, pumpY, pumpZ
        if i <= 3 then
            pumpX, pumpY, pumpZ = getPositionFromElementOffset(stationObject, 0.45, -0.17 + (i%3) * 0.25 + 0.22, -0.2)
        else
            pumpX, pumpY, pumpZ = getPositionFromElementOffset(stationObject, -0.45, -0.17 + (i%3) * 0.25 + 0.22, -0.2)
        end

        local pumpObject = createObject(1327, pumpX, pumpY, pumpZ, 0, 45, rotZ + ((i >= 4 and -180) or 0))
        setElementCollisionsEnabled(pumpObject, false)

        table.insert(pumpPositions, {pumpX, pumpY, pumpZ})

        local splinePositions

        if i <= 3 then
            splinePositions = {
                {getPositionFromElementOffset(stationObject, 0.45, -0.17 + (i%3) * 0.25 + 0.22, -0.2)},
                {getPositionFromElementOffset(stationObject, 0.40, -0.17 + (i%3) * 0.25 + 0.22, -0.65)},
                {getPositionFromElementOffset(stationObject, 0.3, -0.17 + (i%3) * 0.25 + 0.22, -0.95)},
            }
        else
            splinePositions = {
                {getPositionFromElementOffset(stationObject, -0.45, -0.17 + (i%3) * 0.25 + 0.22, -0.2)},
                {getPositionFromElementOffset(stationObject, -0.40, -0.17 + (i%3) * 0.25 + 0.22, -0.65)},
                {getPositionFromElementOffset(stationObject, -0.3, -0.17 + (i%3) * 0.25 + 0.22, -0.95)},
            }
        end

        setElementRotation(pumpObject, 0, 45, rotZ + ((i >= 4 and -180) or 0))

        local defaultSpline = createSpline(splinePositions)
        pumpObjects[pumpObject] = {object = pumpObject, stationObject = stationObject, defaultPos = {pumpX, pumpY, pumpZ}, rotZ = select(3, getElementRotation(pumpObject)), defaultSpline = defaultSpline}
    end

    -- Calculate the center position and radius for the collision sphere
    local centerX, centerY, centerZ = 0, 0, 0
    for _, pos in ipairs(pumpPositions) do
        centerX = centerX + pos[1]
        centerY = centerY + pos[2]
        centerZ = centerZ + pos[3]
    end
    centerX = centerX / #pumpPositions
    centerY = centerY / #pumpPositions
    centerZ = centerZ / #pumpPositions

    local maxDistance = 0
    for _, pos in ipairs(pumpPositions) do
        local distance = getDistanceBetweenPoints3D(centerX, centerY, centerZ, pos[1], pos[2], pos[3])
        if distance > maxDistance then
            maxDistance = distance
        end
    end
end

addEventHandler("onResourceStart", resourceRoot,
    function(startedRes)
        
        if startedRes ~= getThisResource() then
            return
        end

        for i = 1, #fuelPeds do
            local ped = createPed(171, fuelPeds[i][1], fuelPeds[i][2], fuelPeds[i][3], fuelPeds[i][4])
            
            setElementData(ped, "invulnerable", true)
            setElementData(ped, "visibleName", "Fuel Joe")
            setElementData(ped, "fuelPed", true)
            setElementFrozen(ped, true)
        end

        --déli

        print("asd")

        createGasStation(1941.1676025391, -1779.9, 13.550974845886 + 0.4, 180)
        createGasStation(1941.1676025391, -1782, 13.550974845886 + 0.4, 180)

        createGasStation(1930.4676025391, -1779.9, 13.550974845886 + 0.4, 180)
        createGasStation(1930.4676025391, -1782, 13.550974845886 + 0.4, 180)

        createGasStation(1919.8676025391, -1779.9, 13.550974845886 + 0.4, 180)
        createGasStation(1919.8676025391, -1782, 13.550974845886 + 0.4, 180)

        -- északi

        createGasStation(1001.9, -939.1, 42.287448883057 + 0.4, 97)
        createGasStation(1004, -939, 42.287448883057 + 0.4, 97)

        createGasStation(1000.5, -928.6, 42.287448883057 + 0.4, 97)
        createGasStation(1002.65, -928.4, 42.287448883057 + 0.4, 97)

        createGasStation(1001.4002075195, -918, 42.287448883057 + 0.4, 97)
        createGasStation(999.3, -918.2, 42.287448883057 + 0.4, 97)

        createObject(5409, 1916.9859, -1805.793, 12.550012)
        createObject(8640, 1930.61636, -1781.48006, 15.22285)

        createObject(5409, 992.3234, -898.0683, 41.31802, 0, 0, -173.314)
        createObject(8640, 1001.0977, -928.7335, 43.959324, 0, 0, -83.3144)

        setTimer(triggerClientEvent, 1000, 1, "receiveGasStationObjects", resourceRoot, gasStationObjects, pumpObjects)
    end
)

addEvent("requestGasStationObjects", true)
addEventHandler("requestGasStationObjects", resourceRoot,
    function()
        triggerClientEvent(client, "receiveGasStationObjects", resourceRoot, gasStationObjects, pumpObjects)
    end
)

addEvent("pickUpPump", true)
addEventHandler("pickUpPump", resourceRoot,
    function(pumpObject)
        for pumpElement in pairs(pumpObjects) do
            if getElementData(pumpElement, "holder") == client then
                return
            end
        end
        if not isElement(getElementData(client, "holdingPump")) then
            exports.seal_boneattach:attachElementToBone(pumpObject, client, 12, 0, 0, 0, 180, 0, 0)
            setElementData(client, "holdingPump", pumpObject)
            setElementData(pumpObject, "holder", client)
        end
    end
)

addEvent("putDownPump", true)
addEventHandler("putDownPump", resourceRoot,
    function(pumpObject)
        if isElement(getElementData(client, "holdingPump")) then
            local pumpObject = getElementData(client, "holdingPump")
            setElementData(pumpObject, "holder", nil)
            exports.seal_boneattach:detachElementFromBone(pumpObject)
            setElementCollisionsEnabled(pumpObject, false)
            setElementPosition(pumpObject, unpack(pumpObjects[pumpObject].defaultPos))
            setElementRotation(pumpObject, 0, 45, pumpObjects[pumpObject].rotZ)
            
            setElementData(client, "holdingPump", false)
        end
    end
)

addEvent("putInPump", true)
addEventHandler("putInPump", resourceRoot,
    function(vehicleElement, tankPos)
        if not isElement(getElementData(vehicleElement, "pumpIn")) then
            if not getVehicleEngineState(vehicleElement) then
                local pumpElement = getElementData(client, "holdingPump")

                exports.seal_boneattach:detachElementFromBone(pumpElement)
                setElementCollisionsEnabled(pumpElement, false)

                local vehicleModel = getElementModel(vehicleElement)
                local tankX, tankY, tankZ = unpack(tankPos[vehicleModel])
                tankZ = tankZ + 0.55

                attachElements(pumpElement, vehicleElement, tankX + 0.25 + (tankX <= 0 and -0.5 or 0), tankY, tankZ, 0, 30, -180 + (tankX >= 0 and -180 or 0))

                setElementData(client, "holdingPump", false)
                setElementData(vehicleElement, "pumpIn", pumpElement)
                setElementData(pumpElement, "vehicleElement", vehicleElement)
                setElementFrozen(vehicleElement, true)
            elseif getVehicleEngineState(vehicleElement) then
                exports.seal_hud:showInfobox(client, "e", "A járműt nem tankolhatod járó motorral.")
            end
        end
    end
)

addEvent("putOutPump", true)
addEventHandler("putOutPump", resourceRoot,
    function(vehicleElement)
        if not isElement(getElementData(client, "holdingPump")) then
            local pumpElement = getElementData(vehicleElement, "pumpIn")
            if getElementData(pumpElement, "holder") == client then
                detachElements(pumpElement, vehicleElement)
                exports.seal_boneattach:attachElementToBone(pumpElement, client, 12, 0, 0, 0, 180, 0, 0)

                setElementData(client, "holdingPump", pumpElement)
                setElementData(pumpElement, "vehicleElement", nil)
                setElementData(vehicleElement, "pumpIn", false)
            end
        end
    end
)

addEvent("syncTankingLiters", true)
addEventHandler("syncTankingLiters", resourceRoot,
    function(vehicleElement, liters)
        triggerClientEvent("syncTankingLiters", resourceRoot, vehicleElement, liters)
    end
)

addEventHandler("onElementDestroy", getRootElement(),
    function()
        if getElementType(source) == "vehicle" then
            local pumpElement = getElementData(source, "pumpIn")
            if isElement(pumpElement) then
                detachElements(pumpElement, source)
                setElementData(source, "pumpIn", false)
                setElementData(pumpElement, "vehicleElement", false)
                setElementCollisionsEnabled(pumpElement, false)
                setElementPosition(pumpElement, unpack(pumpObjects[pumpElement].defaultPos))
                setElementRotation(pumpElement, 0, 45, pumpObjects[pumpElement].rotZ)
            end
        end
    end
)

addEventHandler("onPlayerQuit", getRootElement(),
    function()
        local pumpObject = getElementData(source, "holdingPump")
        exports.seal_boneattach:detachElementFromBone(pumpObject)
        if isElement(pumpObject) then
            setElementData(pumpObject, "holder", nil)
            setElementPosition(pumpObject, unpack(pumpObjects[pumpObject].defaultPos))
            setElementRotation(pumpObject, 0, 45, pumpObjects[pumpObject].rotZ)
        end
    end
)

addEvent("pistolTooFar", true)
addEventHandler("pistolTooFar", resourceRoot,
    function(pumpElement)
        setElementData(pumpElement, "holder", nil)
        exports.seal_boneattach:detachElementFromBone(pumpElement)
        setElementCollisionsEnabled(pumpElement, false)
        setElementPosition(pumpElement, unpack(pumpObjects[pumpElement].defaultPos))
        setElementRotation(pumpElement, 0, 45, pumpObjects[pumpElement].rotZ)
        
        setElementData(client, "holdingPump", false)
        exports.seal_hud:showInfobox(client, "e", "Ilyen messzire nem tudsz elmenni a pisztollyal!")
    end
)

addEvent("pistolCantGoThrough", true)
addEventHandler("pistolCantGoThrough", resourceRoot,
    function(pumpElement)
        setElementData(pumpElement, "holder", nil)
        exports.seal_boneattach:detachElementFromBone(pumpElement)
        setElementCollisionsEnabled(pumpElement, false)
        setElementPosition(pumpElement, unpack(pumpObjects[pumpElement].defaultPos))
        setElementRotation(pumpElement, 0, 45, pumpObjects[pumpElement].rotZ)
        
        setElementData(client, "holdingPump", false)
        exports.seal_hud:showInfobox(client, "e", "Itt nem tud átmenni a pisztoly kábele!")
    end
)

addEvent("payFuel", true)
addEventHandler("payFuel", resourceRoot,
    function(vehicleElement, liters)
        if not liters then
            exports.seal_hud:showInfobox(client, "e", "Nem tankoltál! Nincs mit kifizetni.")
            return
        end

        local fuelPrice = liters * 63
        fuelPrice = math.floor(fuelPrice)

        local playerMoney = getElementData(client, "char.Money")
        playerMoney = playerMoney - fuelPrice

        if playerMoney >= 0 and liters > 0 then
            local vehicleFuel = getElementData(vehicleElement, "vehicle.fuel")
            vehicleFuel = vehicleFuel + liters
            
            setElementData(client, "char.Money", math.floor(playerMoney))
            setElementData(vehicleElement, "vehicle.fuel", math.floor(vehicleFuel))

            triggerClientEvent("payFuel", resourceRoot, vehicleElement, client)
            exports.seal_hud:showInfobox(client, "s", "Sikeresen kifizetted a tankolást! Az üzemanyag bekerült a járművedbe!")
        else
            exports.seal_hud:showInfobox(client, "e", "Nincs elég pénzed!")
            triggerClientEvent("payFuel", resourceRoot, vehicleElement, client)
        end 
    end
)