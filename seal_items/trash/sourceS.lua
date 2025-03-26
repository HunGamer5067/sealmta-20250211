local seexports = {
    seal_modloader = false
}
trashCache = {}

local function seelangProcessExports()
    for k in pairs(seexports) do
        local res = getResourceFromName(k)
        if res and getResourceState(res) == "running" then
            seexports[k] = exports[k]
        else
            seexports[k] = false
        end
    end
end
seelangProcessExports()
if triggerServerEvent then
    addEventHandler("onClientResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end
if triggerClientEvent then
    addEventHandler("onResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end

function safeCall(resourceName, fnName, ...)
    local res = getResourceFromName(resourceName)
    if res and getResourceState(res) == "running" then
        local cl = call(res, fnName, ...)
        return cl
    end
end

local connection = exports.seal_database:getConnection()

addEventHandler("onDatabaseConnected", root, function(newConnection)
    connection = newConnection
end)

local trashModels = {
    [1] = 1328,
    [2] = 1339,
    [3] = 1337, 
    [4] = 1359, 
    [5] = 1329,
    [6] = 1330,
    [7] = 1574,
}

local trashCache = {}
local alreadyRequestedTrash = {}

addEventHandler("onPlayerQuit", root,
    function ()
        if alreadyRequestedTrash[source] then
            alreadyRequestedTrash[source] = nil
        end
    end
)

addEvent("requestNewTrashes", true)
addEventHandler("requestNewTrashes", root,
    function ()
        if client and client ~= source then
            -- ** Potenciális csaló #1
            return
        end

        if alreadyRequestedTrash[client] then
            -- ** Miért tennél olyat, hogy kérsz mégegyet ha már egyszer megkaptad?
            -- ** Potenciális csaló #2
            return
        end
        alreadyRequestedTrash[client] = true


        triggerClientEvent(client, "recieveNewTrashes", client, trashCache)
    end
)

addCommandHandler("maketrash", function(thePlayer, commandName, selectedTrashId)
    local adminLevel = getElementData(thePlayer, "acc.adminLevel")
    if adminLevel < 6 then
        return
    end

    selectedTrashId = tonumber(selectedTrashId)

    if not selectedTrashId then
        outputChatBox("#4adfbf[Használat]: #ffffff/"..commandName.." [Kuka ID (Lásd konzol)]", thePlayer, 255, 255, 255, true)

        outputConsole("[1] - Fedeles fém kuka", thePlayer)
        outputConsole("[2] - Zöld lezárható kuka (Lezárt)", thePlayer)
        outputConsole("[3] - Kék lezárható kuka (Lezárt)", thePlayer)
        outputConsole("[4] - Modern utcai kuka", thePlayer)
        outputConsole("[5] - Zöld lezárható kuka (Nyitott)", thePlayer)
        outputConsole("[6] - Kék lezárható kuka (Nyitott)", thePlayer)
        outputConsole("[7] - Lamart kuka", thePlayer)
        
        return
    end

    local rotZ = getPedRotation(thePlayer)

    local posX, posY, posZ = getElementPosition(thePlayer)
    posZ = posZ - 0.5

    if selectedTrashId == 7 then
        posZ = posZ - 0.5
    end

    local interior = getElementInterior(thePlayer)
    local dimension = getElementDimension(thePlayer)

    local nt = {
        trashId = 1,
        objectElement = createObject(trashModels[selectedTrashId], posX, posY, posZ),
        rotZ = rotZ,
        posX = posX,
        posY = posY,
        posZ = posZ,
        rotZ = rotZ,
        interior = interior,
        dimension = dimension,
        trashModel = selectedTrashId,
        lamart = (selectedTrashId == 7 and true or false)
    }

    dbExec(connection, "INSERT INTO trashes (posX, posY, posZ, rotZ, interior, dimension, model) VALUES (?,?,?,?,?,?,?)", nt.posX, nt.posY, nt.posZ, nt.rotZ, nt.interior, nt.dimension, selectedTrashId)
        dbQuery(
            function (qh)
                local result = dbPoll(qh, 0)[1]

                if result then
                    if isElement(nt.objectElement) then
                        setElementInterior(nt.objectElement, result.interior)
                        setElementDimension(nt.objectElement, result.dimension)
                        triggerClientEvent(root, "createTrash", thePlayer, result.trashId, nt)

                        setElementRotation(nt.objectElement, 0, 0, result.rotZ - 180)
                        trashCache[result.trashId] = deepcopy(nt)
                    end

                    outputChatBox("#4adfbf[SealMTA]: #ffffffA szemetes sikeresen létrehozva. #dfe520(" .. result.trashId .. ")", thePlayer, 0, 0, 0, true)
                else
                    outputChatBox("#ff0000[SealMTA]: #ffffffA szemetes létrehozása meghiúsult.", thePlayer, 0, 0, 0, true)
                end
            end,
        connection, "SELECT * FROM trashes WHERE trashId = LAST_INSERT_ID()")
end)

addCommandHandler("deletetrash", function(thePlayer, commandName, id)
    local adminLevel = getElementData(thePlayer, "acc.adminLevel")
    if adminLevel < 6 then
        return
    end

    if not id then
        outputChatBox("#ff0000[Használat]: #ffffff/"..commandName.." [Kuka ID]", thePlayer, 255, 255, 255, true)
        return
    end

    local id = tonumber(id)

    dbExec(connection, "DELETE FROM trashes WHERE trashId = ?", id)

    triggerClientEvent("destroyTrash", thePlayer, id)

    exports.seal_hud:showInfobox(thePlayer, "success", "Sikeresen kitörölted a kukát. (ID: " .. id .. ")")

    if trashCache[id] then
        destroyElement(trashCache[id].objectElement)
        trashCache[id] = nil
    else
        outputChatBox("ff0000[SealMTA]: #ffffffA kiválasztott kuka nem létezik.", thePlayer, 255, 255, 255, true)
    end
end)

addCommandHandler("nearbytrash", function(thePlayer, commandName, radius)
    local adminLevel = getElementData(thePlayer, "acc.adminLevel")
    if adminLevel < 6 then
        return
    end

    local radius = tonumber(radius) or 10 -- Alapértelmezett sugár 10, ha nem adnak meg értéket

    local px, py, pz = getElementPosition(thePlayer)
    local nearbyTrashes = {}

    for id, trashData in pairs(trashCache) do
        if trashData.objectElement and isElement(trashData.objectElement) then
            local tx, ty, tz = getElementPosition(trashData.objectElement)
            local distance = getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz)

            if distance <= radius then
                table.insert(nearbyTrashes, { id = id, distance = distance })
            end
        end
    end

    if #nearbyTrashes == 0 then
        outputChatBox("ff0000[SealMTA]: #ffffffNincs kuka a közeledben (sugár: " .. radius .. ").", thePlayer, 255, 255, 255, true)
        return
    end

    outputChatBox("00ff00[SealMTA]: #ffffffKukák a közeledben:", thePlayer, 255, 255, 255, true)
    for _, trash in ipairs(nearbyTrashes) do
        outputChatBox(" - ID: " .. trash.id .. ", Távolság: " .. string.format("%.2f", trash.distance) .. " méter", thePlayer, 255, 255, 255, true)
    end
end)

function loadTrash(trashId, data, sync)
    if tonumber(trashId) and type(data) == "table" then
        if isElement(trashCache.objectElement) then
            setElementInterior(trashCache.objectElement, interior)
            setElementDimension(trashCache.objectElement, dimension)

            triggerClientEvent("createTrash", resourceRoot, trashCache.trashId, trashCache)

            iprint(trashCache)
        end
    end
end

addEventHandler("onResourceStart", root, 
    function ()
        local qh =  dbQuery(connection, "SELECT * FROM trashes")
        local result = dbPoll(qh, -1)

        if result then
            for k, v in pairs(result) do
                trash = createObject(trashModels[v.model], v.posX, v.posY, v.posZ)

                trashCache[v.trashId] = {
                    trashId = v.trashId,
                    objectElement = trash,
                    rotZ = v.rotZ,
                    posX = v.posX,
                    posY = v.posY,
                    posZ = v.posZ,
                    rotZ = v.rotZ,
                    interior = v.interior,
                    dimension = v.dimension,
                    lamart = (v.model == 7 and true or false)
                }

                if isElement(trash) then
                    setElementInterior(trash, v.interior)
                    setElementDimension(trash, v.dimension)
                    setElementRotation(trash, 0, 0, v.rotZ - 180)
                end
            end
        end
    end
)


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