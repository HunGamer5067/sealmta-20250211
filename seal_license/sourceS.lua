local requestedLicenses = {}

addEvent("licenseOfficeRequest", true)
addEventHandler("licenseOfficeRequest", root,
    function (type)
        if source ~= client then
            if not requestedLicenses[client] then
                requestedLicenses[client] = type

                if type == "id" then
                    photo = true
                elseif type == "dl" then
                    photo = true
                elseif type == "wp" then
                    photo = true
                elseif type == "fs" then
                    photo = false
                    licenseType = "fs"
                    itemId = 66
                end

                if photo then
                    triggerClientEvent(client, "licenseOfficeResponse", resourceRoot, photo)
                else
                    local money = getElementData(client, "char.Money") or 0

                    if (money - 50000) >= 0 then
                        local licenseId = getRealTime().timestamp
                        local clientName = getElementData(client, "char.Name") or "Ismeretlen"
                        local characterId = getElementData(client, "char.ID")

                        exports.seal_items:giveItem(client, itemId, 1, false, clientName, characterId, licenseId .. "_" .. licenseType)
                        requestedLicenses[client] = false
                        exports.seal_gui:showInfobox(client, "s", "Sikeresen kiváltottad a dokumentumot.")
                        setElementData(client, "char.Money", money - 50000)
                    else
                        exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a dokumentum kiváltásához.")
                    end
                end
            end
        end
    end
)

addEvent("sendLicensePhoto", true)
addEventHandler("sendLicensePhoto", resourceRoot,
    function (photoPixels)
        if source ~= client then
            local licenseType = "id"
            local itemId = 65

            if requestedLicenses[client] == "id" then
                licenseType = "id"
                itemId = 65
                price = 0
            elseif requestedLicenses[client] == "dl" then
                licenseType = "dl"
                itemId = 68
                price = 0
            elseif requestedLicenses[client] == "wp" then
                licenseType = "wp"
                itemId = 75
                price = 1000000
            elseif requestedLicenses[client] == "fs" then
                licenseType = "fs"
                itemId = 66
                price = 50000
            end

            if price then
                local money = getElementData(client, "char.Money") or 0
                if (money - price) >= 0 then
                    setElementData(client, "char.Money", money - price)
                else
                    exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a dokumentum kiváltásához.")
                    triggerClientEvent(client, "endLicensePhotoMode", resourceRoot)
                    return
                end
            end

            local licenseId = getRealTime().timestamp

            local clientName = getElementData(client, "char.Name") or "Ismeretlen"
            local characterId = getElementData(client, "char.ID")

            local imageName = clientName .. "_" .. characterId .. "_" .. licenseId .. "_" .. licenseType
            if fileExists("images/" .. imageName .. ".jpg") then
                fileDelete("images/" .. imageName .. ".jpg")
            end

            local file = fileCreate("images/" .. imageName .. ".jpg")
            fileWrite(file, photoPixels)
            fileClose(file)

            requestedLicenses[client] = false

            exports.seal_items:giveItem(client, itemId, 1, false, clientName, characterId, licenseId .. "_" .. licenseType)
            exports.seal_gui:showInfobox(client, "s", "Sikeresen kiváltottad a dokumentumot.")

            triggerClientEvent(client, "endLicensePhotoMode", resourceRoot)
        end
    end
)

addEvent("loadLicenseData", true)
addEventHandler("loadLicenseData", resourceRoot,
    function (characterName, characterId, licenseDatas)
        if source ~= client then
            local imageName = characterName .. "_" .. characterId .. "_" .. licenseDatas

            local licenseDatas = split(licenseDatas, "_")
            local data = {}

            data.name = characterName:gsub("_", " ")
            data.id = tonumber(licenseDatas[1])
            data.licenseType = licenseDatas[2]
            data.created = tonumber(licenseDatas[1])
            data.expire = tonumber(licenseDatas[1])

            if fileExists("images/" .. imageName .. ".jpg") then
                local photo = fileOpen("images/" .. imageName .. ".jpg")
                if photo then
                    local pixels = fileRead(photo, fileGetSize(photo))
                    fileClose(photo)
                    triggerClientEvent(client, "gotLicenseData", resourceRoot, pixels, data)
                    pixels = nil
                    collectgarbage("collect")
                end
            else
                triggerClientEvent(client, "gotLicenseData", resourceRoot, false, data)
            end
        end
    end
)