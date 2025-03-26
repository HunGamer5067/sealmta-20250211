local encryptedFileList = {}

addEventHandler("onResourceStart", resourceRoot, function()
    if fileExists("encrypted.json") then
        local file = fileOpen("encrypted.json")

        if file then
            local fileSize = fileGetSize(file)
            local fileData = fileRead(file, fileSize)
            fileClose(file)

            if fileData then
                encryptedFileList = fromJSON(fileData)
            end

            for file in pairs(encryptedFileList) do
                if not fileExists("encrypted/" .. file .. ".seal") then
                    encryptedFileList[file] = nil
                end
            end
        end
    end
end)

addEventHandler("onResourceStop", resourceRoot, function()
    if fileExists("encrypted.json") then
        fileDelete("encrypted.json")
    end

    local file = fileCreate("encrypted.json")
    fileWrite(file, toJSON(encryptedFileList))
    fileClose(file)
end)

function encryptFile(filePath)
    if fileExists(filePath) then
        local file = fileOpen(filePath)

        if file then
            local fileSize = fileGetSize(file)
            local fileData = fileRead(file, fileSize)
            fileClose(file)

            if fileData then
                local encryptKey = generateRandomUniqueString(16)

                encodeString("aes128", fileData, {key = encryptKey}, function(encodedData, encodedIv)
                    local encryptedFile = fileCreate("encrypted/" .. filePath .. ".seal")
                    fileWrite(encryptedFile, encodedData)
                    fileClose(encryptedFile)

                    local encryptedFileIv = fileCreate("encrypted/" .. filePath .. ".iv")
                    fileWrite(encryptedFileIv, encodedIv)
                    fileClose(encryptedFileIv)

                    encryptedFileList[filePath] = encryptKey
                end)
            else
                return "Can't read file"
            end
        else
            return "Can't open file"
        end
    else
        return "File not found"
    end
end

function getEncryptedDetails(filePath)
    local encryptedKey = encryptedFileList[filePath]

    if encryptedKey then
        local encryptedIvKey = false

        if fileExists("encrypted/" .. filePath .. ".iv") then
            local file = fileOpen("encrypted/" .. filePath .. ".iv")

            if file then
                local fileSize = fileGetSize(file)
                local fileData = fileRead(file, fileSize)
                fileClose(file)

                if fileData then
                    encryptedIvKey = encodeString("base64", fileData)
                end
            end
        end

        return encryptedKey, encryptedIvKey
    end
end

addCommandHandler("encryptfile", function(playerSource, commandName, filePath)
    if getElementData(playerSource, "acc.adminLevel") >= 10 then
        if not filePath then
            outputChatBox("[Használat]: #ffffff/" .. commandName .. " [file path]", playerSource, 255, 150, 0, true)
        else
            local encryptResult = encryptFile(filePath)

            if encryptResult then
                outputChatBox("#d75959[Encryption]: #ffffff" .. encryptResult, playerSource, 255, 255, 255, true)
            else
                outputChatBox("#7cc576[Encryption]: #ffffffA fájl sikeresen titkosítva lett!", playerSource, 0, 255, 0, true)
            end
        end
    end
end)

local fileRequestFromClient = {}

addEvent("requestProtectedFile", true)
addEventHandler("requestProtectedFile", resourceRoot, function(filePath)
    local encryptedKey, encryptedIvKey = getEncryptedDetails(filePath)

    if fileRequestFromClient[client] and fileRequestFromClient[client][filePath] then
        return
    end

    if not fileRequestFromClient[client] then
        fileRequestFromClient[client] = {}
    end
    fileRequestFromClient[client][filePath] = true

    if encryptedKey and encryptedIvKey then
        triggerClientEvent(client, "receiveProtectedFile", resourceRoot, filePath, encryptedKey, encryptedIvKey)
    end
end)

function generateRandomUniqueString(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""

    for i = 1, length do
        local randIndex = math.random(1, #charset)
        result = result .. charset:sub(randIndex, randIndex)
    end

    return result
end