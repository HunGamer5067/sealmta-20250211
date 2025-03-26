local mapList = { 
    "server-maps/lotteryinti_fix.map", 
    "server-maps/SealCityMall.map", 
}

addEvent("mapLoader:requestInitialMapList", true)
addEventHandler("mapLoader:requestInitialMapList", getRootElement(), function()
    if client == source then
        triggerClientEvent(client, "mapLoader:refreshMapList", client, mapList)
    end
end)

addEvent("mapLoader:requestMapData", true)
addEventHandler("mapLoader:requestMapData", getRootElement(), function(map)
    if map and fileExists(map) then
        local file = fileOpen(map)
        local size = fileGetSize(file)
        local buffer = fileRead(file, size)
        fileClose(file)
        
        if buffer then
            triggerLatentClientEvent(client, "mapLoader:gotMapData", 50000000, client, map, fromJSON(buffer))
        end
    end
end)