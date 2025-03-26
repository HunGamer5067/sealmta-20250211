local bridgePos = {
    [596] = {0, -0.4, 0.75, 0, 0, 0, 0.8},
    [467] = {0, -0.4, 0.75, 0, 0, 0, 0.8},
    [598] = {0, -0.4, 0.75, 0, 0, 0, 0.8},
    [597] = {0, -0.2, 1.15, 0, 0, 0, 0.95},
    [490] = {0, 0, 1.45, 0, 0, 0, 1.05},
    [400] = {0, 0, 0.85, 0, 0, 0, 0.85},
    [599] = {0, -0.1, 0.9, 0, 0, 0, 0.85},
    [561] = {0, 0, 0.85, 0, 0, 0, 0.85},
}

addCommandHandler("togglelightbridge",
    function(sourcePlayer)
        if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
            local pedveh = getPedOccupiedVehicle(sourcePlayer)
            if not bridgePos[getElementModel(pedveh)] then return end
            if isElement(pedveh) then
                local lightBridge = getElementData(pedveh, "lightBridge")
                setElementData(pedveh, "lightBridge", (lightBridge and lightBridge == 1 and 0) or 1)
            end
        end
    end
)

local sirenBridges = {}

function createLightBridge(vehicle)
    if isElement(sirenBridges[vehicle]) then
        destroyElement(sirenBridges[vehicle])
    end
    if not bridgePos[getElementModel(vehicle)] then
        setElementData(vehicle, "lightBridge", 0)
    end
    local x, y, z = getElementPosition(vehicle)
    setVehicleVariant(vehicle, 2, 0)

    local posX, posY, posZ, rotX, rotY, rotZ = bridgePos[getElementModel(vehicle)][1], bridgePos[getElementModel(vehicle)][2], bridgePos[getElementModel(vehicle)][3], bridgePos[getElementModel(vehicle)][4], bridgePos[getElementModel(vehicle)][5], bridgePos[getElementModel(vehicle)][6]
    local scale = bridgePos[getElementModel(vehicle)][7]
    addVehicleSirens(vehicle, 2, 2, true, false, true, true)

    setVehicleSirens(vehicle, 1, bridgePos[getElementModel(vehicle)][1] - 0.5 * scale, bridgePos[getElementModel(vehicle)][2], bridgePos[getElementModel(vehicle)][3], 0, 0, 255, 255, 255) -- KÉK
    setVehicleSirens(vehicle, 2, bridgePos[getElementModel(vehicle)][1] + 0.5 * scale, bridgePos[getElementModel(vehicle)][2], bridgePos[getElementModel(vehicle)][3], 255, 0, 0, 200, 200) -- piros

    setVehicleSirensOn(vehicle, false)
    setElementData(vehicle, "lampMarker", lampSiren)
    setElementData(vehicle, "civilSiren", true)
    sirenBridges[vehicle] = lamp
end

function destroyLightBridge(vehicle)
    if isElement(sirenBridges[vehicle]) then
        destroyElement(sirenBridges[vehicle])
    end
    sirenBridges[vehicle] = nil
    setElementData(vehicle, "civilSiren", false)
    setElementData(vehicle, "lampObject", false)
    setElementData(vehicle, "lampMarker", false)
    setVehicleSirensOn(vehicle, false)
    setVehicleVariant(vehicle, 255, 255)
end

addEventHandler("onElementDataChange", getRootElement(),    
    function(dataName, oldValue, newValue)
        if getElementType(source) == "vehicle" then
            if dataName == "lightBridge" then
                if tonumber(newValue) and newValue == 1 then
                    createLightBridge(source)
                elseif getElementData(source, "civilSiren") and newValue == 0 then
                    destroyLightBridge(source)
                end
            end
        end
    end
)

addEventHandler("onResourceStart", resourceRoot,
    function()
        for k, v in pairs(getElementsByType("vehicle")) do
            if getElementData(v, "lightBridge") and getElementData(v, "lightBridge") == 1 then
                createLightBridge(v)
            end
        end
    end
)