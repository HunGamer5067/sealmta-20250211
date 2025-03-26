local maps = {
    "icjail",
}

addEvent("requestMaps", true)
addEventHandler("requestMaps", resourceRoot, function()
    for i = 1, #maps do
        local map = maps[i]

        local file = fileOpen("maps/" .. map .. "_fixed")
        local content = fileRead(file, fileGetSize(file))
        fileClose(file)
        
        triggerLatentClientEvent(client, "gotMapObjects", 50000000, resourceRoot, map, content)
        content = nil
        collectgarbage("collect")
    end
end)