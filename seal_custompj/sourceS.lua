local connection = exports.seal_database:getConnection()

addEventHandler("onDatabaseConnected", getRootElement(),
    function(db)
        connection = db
    end
)

addEvent("doneCustomPaintjob", true)
addEventHandler("doneCustomPaintjob", getRootElement(), function(pixels)
    local clientVehicle = getPedOccupiedVehicle(client)

    if clientVehicle == source then
        local vehicleId = getElementData(clientVehicle, "vehicle.dbID")
        local ownerId = getElementData(clientVehicle, "vehicle.owner")

        if vehicleId then
            local charId = getElementData(client, "char.ID")

            if ownerId and charId and ownerId ~= charId then
                exports.seal_accounts:showInfo(client, "e", "Csak a jármű tulajdonosa vásárolhat egyedi paintjobot a járműre!")
                return
            end

            local premiumPoints = getElementData(client, "acc.premiumPoints") or 0

            if premiumPoints and premiumPoints - 8000 >= 0 then 
                local fileName = "server/" .. vehicleId .. ".png"

                if fileName then
                    if fileExists(fileName) then
                        fileDelete(fileName)
                    end

                    local file = fileCreate(fileName)

                    if file then
                        fileWrite(file, pixels)
                        fileClose(file)

                        setElementData(clientVehicle, "vehicle.tuning.Paintjob", -2)
                        setElementData(clientVehicle, "vehicle.tuning.Paintjob", -1)
                        dbExec(connection, "UPDATE vehicles SET tuningPaintjob = ? WHERE vehicleId = ?", -1, vehicleId)

                        setElementData(client, "acc.premiumPoints", premiumPoints - 8000)
                        triggerClientEvent(client, "boughtPaintjobResponse", client, true, false)
                    end
                end
            else
                triggerClientEvent(client, "boughtPaintjobResponse", client, false, false)
                exports.seal_accounts:showInfo(client, "e", "Nincs elegendő prémiumpontod!")
            end
        end
    end
end)

local requestQueue = {}
local queueTimer = {}

addEvent("requestCustomPJ", true)
addEventHandler("requestCustomPJ", getRootElement(), function()
    if not requestQueue[client] then
        requestQueue[client] = {}
    end

    table.insert(requestQueue[client], {
        player = client,
        vehicle = source
    })

    if not queueTimer[client] then
        queueTimer[client] = setTimer(function(playerElement)
            local requested = requestQueue[playerElement]

            if requested and requested[1] then
                local vehicleElement = requested[1].vehicle

                if isElement(vehicleElement) then
                    local vehicleId = getElementData(vehicleElement, "vehicle.dbID")

                    if vehicleId then
                        local fileName = "server/" .. vehicleId .. ".png"

                        if fileName and fileExists(fileName) then
                            local file = fileOpen(fileName)

                            if file then
                                local pixels = fileRead(file, fileGetSize(file))
                                fileClose(file)

                                triggerLatentClientEvent(playerElement, "requestCustomPJ", 1000000, false, vehicleElement, pixels)
                                pixels = nil
                                collectgarbage("collect")
                            end
                        end
                    end
                end

                table.remove(requested, 1)
            end
        end, 500, 0, client)
    end
end)