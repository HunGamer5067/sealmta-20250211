takenVehs = {}
local connection = exports.seal_database:getConnection()

addEvent("requestBikeConditions", true)
function requestBikeConditions()
    local veh = getPedOccupiedVehicle(client)
    local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
    local brake = 100
    if getElementData(veh, "vehicle.pulling") then
        brake = brake - (getElementData(veh, "vehicle.pulling") * 200)
    end
    local bodywork = 100
    for i = 0, 6 do
        local panel = getVehiclePanelState(veh, i)
        if panel ~= 0 then
            bodywork = bodywork - 14
        end
    end
    local lights = 100
    for i = 0, 3 do
        local state = getVehicleLightState(veh, i)
        if state == 1 then
            lights = lights - 25
        end
    end
    local oil = 500 - math.floor(math.floor(getElementData(veh, "lastOilChange") or 0) / 1000)
    local dat = {bodywork, math.floor(getElementHealth(veh) / 10), lights, {frontLeft == 0 and 100 or 0, rearLeft == 0 and 100 or 0,
    frontRight == 0 and 100 or 0, rearRight == 0 and 100 or 0}, math.floor(brake), {oil / 100, math.floor(oil)}}
    triggerClientEvent(client, "gotBikeConditions", client, veh, dat)
end
addEventHandler("requestBikeConditions", root, requestBikeConditions)
takens = {}
addEvent("acceptBikeRepairOffer", true)
function acceptBikeRepairOffer(veh, options)
    local money = getElementData(client, "char.Money")
    sumTime = 0
    sum = 0
    for k, v in pairs(options) do
        sumTime = sumTime + bikeOptions[k].time
        sum = sum + getItemPrice(veh, bikeOptions[k].price)
    end
    if money >= sum then
        local occupants = getVehicleOccupants(veh)
        for k, v in pairs(occupants) do
            removePedFromVehicle(v)
        end
        setElementData(client, "char.Money", money - sum)
        setElementDimension(veh, getElementData(veh, "vehicle.dbID"))
        setElementInterior(veh, getElementData(veh, "vehicle.dbID"))
        setVehicleDamageProof(veh, false)
        local a, b, c, d = getVehicleWheelStates(veh)
        local hp = getElementHealth(veh)
        if options[1] then
            fixVehicle(veh)
            setVehicleWheelStates(veh, a, b, c, d)
            setElementHealth(veh, hp)
        end
        if options[2] then
            setElementHealth(veh, 1000)
        end
        if options[3] then
            for i = 0, 3 do
                setVehicleLightState(veh, i, 0)
            end
        end
        if options[4] then
            setVehicleWheelStates(veh, 0, 0, 0, 0)
        end
        if options[6] then
            setElementData(veh, "vehicle.lastOilChange", getElementData(veh, "vehicle.distance"))
        end
        local vehicleGroup = getElementData(veh, "vehicle.group")
        local characterID = getElementData(client, "char.ID")
        local vehicleOwner = vehicleGroup > 0 and characterID or getElementData(veh, "vehicle.owner")
        table.insert(takens, {getElementData(veh, "vehicle.dbID"), getElementModel(veh), getRealTime().timestamp + (sumTime * 3600), vehicleOwner})
        triggerClientEvent(client, "gotServiceBikeList", client, getPlayerVehs(characterID))
    else
        triggerClientEvent(client, "showInfobox", client, "error", "Nincs elég pénzed!")
    end
end
addEventHandler("acceptBikeRepairOffer", root, acceptBikeRepairOffer)

function getPlayerVehs(id)
    local vehs = {}
    for k, v in pairs(takens) do
        if v[4] == id then
            local temp = deepcopy(v)
            
            temp[3] = math.ceil((takens[k][3] - getRealTime().timestamp) / 60)
            table.insert(vehs, temp)
        end
    end
    return vehs
end

addEvent("requestInServiceBikeList", true)
function requestInServiceBikeList()
    triggerClientEvent(client, "gotServiceBikeList", client, getPlayerVehs(getElementData(client, "char.ID")))
end
addEventHandler("requestInServiceBikeList", root, requestInServiceBikeList)

function findVehicle(id)
    local veh = false
    for k, v in pairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle.dbID") == id then
            veh = v
        end
    end
    return veh
end

addEvent("pickUpBikeInSerivce", true)
function pickUpBikeInSerivce(id)
    local x, y, z = getElementPosition(client)
    local veh = findVehicle(id)
    setElementPosition(veh, x, y, z)
    setElementDimension(veh, 0)
    setElementInterior(veh, 0)
    warpPedIntoVehicle(client, veh)
    setElementData(veh, "vehicleNoCol", true)
    setTimer(giveBackCol, 1000 * 35, 1, veh)
    setVehicleDamageProof(veh, false)
    for k, v in ipairs(takens) do
        if v[1] == id then
            table.remove(takens, k)
        end
    end
end
addEventHandler("pickUpBikeInSerivce", root, pickUpBikeInSerivce)

function giveBackCol(veh)
    setElementData(veh, "vehicleNoCol", false)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end