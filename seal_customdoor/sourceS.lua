local createdDoors = {}
local doorTimers = {}
local availableDoors = {
    {16775, {1443.0489501953, -1468.2, 14.418354034424}, {1440.199, -1467.9, 17.39999}, 0, 0, 83, 0.75, 7},
}

addEventHandler("onResourceStart", resourceRoot, function()
    for i = 1, #availableDoors do
        local doorData = availableDoors[i]

        if doorData then
            local x, y, z = doorData[2][1], doorData[2][2], doorData[2][3]
            local ox, oy, oz = doorData[3][1], doorData[3][2], doorData[3][3]
            local rx, ry, rz = doorData[4] or 0, doorData[5] or 0, doorData[6] or 0
            local scale, col = doorData[7] or 1, doorData[8] or 1

            local door = createObject(doorData[1], x, y, z)
            setElementRotation(door, rx, ry, rz)
            setObjectScale(door, scale)

            local col = createColSphere(x, y, z - 1, col)
            setElementData(col, "isDoorCol", true)
            createdDoors[col] = {door, x, y, z, ox, oy, oz}
        end
    end
end)

addEvent("moveDoorObject", true)
addEventHandler("moveDoorObject", getRootElement(), function(element)
    if source == client then
        return
    end

    if createdDoors[element] then
        if createdDoors[element][8] then
            if isTimer(doorTimers[element]) then
                killTimer(doorTimers[element])
            end

            doorTimers[element] = setTimer(function(element)
                if createdDoors[element] and createdDoors[element][1] then
                    moveObject(createdDoors[element][1], 2000, createdDoors[element][2], createdDoors[element][3], createdDoors[element][4], 90, 0, 0)
                end

                if isTimer(doorTimers[element]) then
                    killTimer(doorTimers[element])
                end

                createdDoors[element][8] = false
            end, 5000, 1, element)
            return
        end

        moveObject(createdDoors[element][1], 2000, createdDoors[element][5], createdDoors[element][6], createdDoors[element][7], -90, 0, 0)
        createdDoors[element][8] = true
    end
end)