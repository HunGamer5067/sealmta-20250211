
addEvent("requestServersideProtection", true)
addEventHandler("requestServersideProtection", getRootElement(), function(k, fileType, fileName)
    local realFileName = fileName .. ".see3"
    local data = false
    local offset = false

    if fileExists(realFileName) then
        local file = fileOpen(realFileName)
        local size = fileGetSize(file)
        local buffer = fileRead(file, size)
        fileClose(file)

        if buffer then
            buffer = fromJSON(buffer)
            data = buffer[1]
            offset = buffer[2]
        end

        buffer = nil
        collectgarbage("collect")
    end

    triggerClientEvent(client, "gotServersideProtection", client, k, fileType, fileName, data, offset)
end)