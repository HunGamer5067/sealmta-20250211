local parkingDatas = {}

addEventHandler("onResourceStart", resourceRoot, function()
    for i = 1, #parkingGarages do
        local entranceProtection = parkingGarages[i].entranceProtection
        local exitProtection = parkingGarages[i].exitProtection

        local entranceProtectionCol = createColPolygon(unpack(entranceProtection))
        setElementDimension(entranceProtectionCol, parkingGarages[i].insideDimension)
        setElementData(entranceProtectionCol, "entranceProtectionCol", i)
        
        local exitProtectionCol = createColPolygon(unpack(exitProtection))
        setElementDimension(exitProtectionCol, parkingGarages[i].insideDimension)
        setElementData(exitProtectionCol, "exitProtectionCol", i)

        local zone = parkingGarages[i].zone
        local parkCeiling = parkingGarages[i].parkCeiling

        local zoneCol = createColPolygon(unpack(zone))
        setElementData(zoneCol, "parkingGarage", i)

        parkingDatas[i] = {
            entranceProtectionCol = entranceProtectionCol,
            exitProtectionCol = exitProtectionCol,
            zoneCol = zoneCol,
            enteredPlayers = {}
        }
    end
end)

addEventHandler("onColShapeHit", getRootElement(), function(hitElement, matchingDimension)
    local hitType = getElementType(hitElement)

    local parkingGarage = getElementData(source, "parkingGarage")
    local entranceCol = getElementData(source, "entranceProtectionCol")
    local exitCol = getElementData(source, "exitProtectionCol")

    if entranceCol and matchingDimension and hitType == "vehicle" then
        local parkingData = parkingDatas[entranceCol]

        if parkingData then
            triggerClientEvent("changeParkingEnterGateState", resourceRoot, entranceCol, 2, true)

            return
        end
    elseif exitCol and matchingDimension and hitType == "vehicle" then
        local parkingData = parkingDatas[exitCol]

        if parkingData then
            triggerClientEvent("changeParkingExitGateState", resourceRoot, exitCol, 2, true)

            return
        end
    end

    local parkingGarageData = parkingGarages[parkingGarage]
    local parkingData = parkingDatas[parkingGarage]

    if parkingData and parkingGarage then
        local hitElementPosX, hitElementPosY, hitElementPosZ = getElementPosition(hitElement)
        local parkCeiling = parkingGarageData.parkCeiling

        if hitElementPosZ <= parkCeiling then
            if hitType == "player" then
                table.insert(parkingData.enteredPlayers, hitElement)
            elseif hitType == "vehicle" then
                setElementData(hitElement, "noCollide", true)
                setElementAlpha(hitElement, 150)

                triggerClientEvent("changeParkingEnterGateState", resourceRoot, parkingGarage, 1, true)

                if #parkingData.enteredPlayers > 0 and not parkingData.exitGateState then
                    parkingData.exitGateState = true
                    triggerClientEvent("changeParkingExitGateState", resourceRoot, parkingGarage, 1, true)
                end
            end

            local insideDimension = parkingGarageData.insideDimension
            setElementDimension(hitElement, insideDimension)
        end
    end
end)

addEventHandler("onColShapeLeave", getRootElement(), function(leaveElement, matchingDimension)
    local leaveType = getElementType(leaveElement)
    local entranceCol = getElementData(source, "entranceProtectionCol")
    local exitCol = getElementData(source, "exitProtectionCol")

    if entranceCol and matchingDimension then
        local parkingData = parkingDatas[entranceCol]

        if parkingData then
            if leaveType == "vehicle" then
                triggerClientEvent("changeParkingEnterGateState", resourceRoot, entranceCol, 2, false)
            end

            return
        end
    elseif exitCol and matchingDimension then
        local parkingData = parkingDatas[exitCol]

        if parkingData then
            if leaveType == "vehicle" then
                setElementData(leaveElement, "noCollide", false)
                setElementAlpha(leaveElement, 255)

                triggerClientEvent("changeParkingExitGateState", resourceRoot, exitCol, 2, false)
            end

            for i, player in ipairs(parkingData.enteredPlayers) do
                if player == leaveElement then
                    table.remove(parkingData.enteredPlayers, i)
                    break
                end
            end

            return
        end
    end

    local parkingGarage = getElementData(source, "parkingGarage")
    local parkingGarageData = parkingGarages[parkingGarage]
    local parkingData = parkingDatas[parkingGarage]

    if parkingGarageData and parkingData then
        local leaveElementPosX, leaveElementPosY, leaveElementPosZ = getElementPosition(leaveElement)
        local parkCeiling = parkingGarageData.parkCeiling

        if leaveElementPosZ <= parkCeiling then
            if leaveType == "player" then
                for i, player in ipairs(parkingData.enteredPlayers) do
                    if player == leaveElement then
                        table.remove(parkingData.enteredPlayers, i)
                        break
                    end
                end
            elseif leaveType == "vehicle" then
                setElementData(leaveElement, "noCollide", false)
                setElementAlpha(leaveElement, 255)
            end

            if #parkingData.enteredPlayers == 0 and parkingData.exitGateState then
                parkingData.exitGateState = false
                triggerClientEvent("changeParkingEnterGateState", resourceRoot, parkingGarage, 1, false)
                triggerClientEvent("changeParkingExitGateState", resourceRoot, parkingGarage, 1, false)
            end

            local outsideDimension = parkingGarageData.outsideDimension
            setElementDimension(leaveElement, outsideDimension)
        end
    end
end)