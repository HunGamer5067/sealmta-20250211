local connection = false
local createdPeds = {}

addEventHandler("onDatabaseConnected", getRootElement(),
	function(db)
		connection = db
	end
)

addEventHandler("onResourceStart", getRootElement(),
	function (startedRes)
		if startedRes == getThisResource() then
			connection = exports.seal_database:getConnection()
            loadShopPeds()
		end
	end
)

addEvent("buyShopItem", true)
addEventHandler("buyShopItem", getRootElement(),
    function(itemData, shopCategory, itemCount)
        if isElement(source) and client and client == source then
            local itemData, shopCategory, itemCount = tonumber(itemData), tonumber(shopCategory), tonumber(itemCount)

            if itemData and shopCategory and itemCount then
                if itemCount > shopDatas[shopCategory][2][itemData][3] then
                    exports.seal_gui:showInfobox(client, "e", "A kiválasztott tárgyból nem vehetsz ennyit!")
                    return
                end

                if itemCount == 0 then
                    exports.seal_gui:showInfobox(client, "e", "A kiválasztott tárgyból nem vehetsz ennyit!")
                    return
                end

                local clientMoney = getElementData(client, "char.Money") or 0
                local newMoneyBalance = clientMoney - (shopDatas[shopCategory][2][itemData][2] * itemCount)

                if newMoneyBalance >= 0 then
                    setElementData(client, "char.Money", newMoneyBalance)
                    exports.seal_items:giveItem(client, shopDatas[shopCategory][2][itemData][1], itemCount)
                    exports.seal_gui:showInfobox(client, "s", "Sikeresen megvásároltad a kiválasztott tárgyat!")
                    triggerClientEvent(client, "backToShop", client)
                else
                    exports.seal_gui:showInfobox(client, "e", "Nincs elég pénzed a kiválasztott tárgy megvásárlásához!")
                end
            end
        end
    end
)

function loadShopPeds()
    dbQuery(
        function(qh)
            local result = dbPoll(qh, 0)

            if #result > 0 then
                for k, data in pairs(result) do
                    local shopId = tonumber(data.shopId)

                    createdPeds[shopId] = createPed(data.skinId, data.posX, data.posY, data.posZ)
                    setElementData(createdPeds[shopId], "invulnerable", true)
                    setElementData(createdPeds[shopId], "visibleName", data.name)

                    setElementData(createdPeds[shopId], "shop.id", shopId)
                    setElementData(createdPeds[shopId], "shopType", data.type)
                    setElementData(createdPeds[shopId], "pedNameType", "Bolt")
                    setElementData(createdPeds[shopId], "shopPed", true, true)

                    setElementDimension(createdPeds[shopId], data.dimension)
                    setElementInterior(createdPeds[shopId], data.interior)
                    setElementModel(createdPeds[shopId], data.skinId)
                    setPedRotation(createdPeds[shopId], data.rot)
                    setElementFrozen(createdPeds[shopId], true)

                    setElementHealth(createdPeds[shopId], 100)
                    setPedArmor(createdPeds[shopId], 100)
                end
            end
        end, connection, "SELECT * FROM shop"
    )
end

function loadOnePed(shopId)
    dbQuery(
        function(qh)
            local result = dbPoll(qh, 0)

            if #result > 0 then
                local shopId = tonumber(result[1].shopId)

                createdPeds[shopId] = createPed(result[1].skinId, result[1].posX, result[1].posY, result[1].posZ)
                setElementData(createdPeds[shopId], "invulnerable", true)
                setElementData(createdPeds[shopId], "visibleName", result[1].name)

                setElementData(createdPeds[shopId], "shop.id", shopId)
                setElementData(createdPeds[shopId], "shopType", result[1].type)
                setElementData(createdPeds[shopId], "pedNameType", "Bolt")
                setElementData(createdPeds[shopId], "shopPed", true, true)

                setElementDimension(createdPeds[shopId], result[1].dimension)
                setElementInterior(createdPeds[shopId], result[1].interior)
                setElementModel(createdPeds[shopId], result[1].skinId)
                setPedRotation(createdPeds[shopId], result[1].rot)
                setElementFrozen(createdPeds[shopId], true)

                setElementHealth(createdPeds[shopId], 100)
                setPedArmor(createdPeds[shopId], 100)
            end
        end, connection, "SELECT * from shop WHERE shopId = ?", shopId
    )
end

addCommandHandler("createshop",
    function(sourcePlayer, commandName, shopType, skinId, ...)
        if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
            if not (tonumber(shopType) and tonumber(skinId) and ...) then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Bolt típusa (Lásd console)] [skinId] [Eladó Neve]", sourcePlayer, 255, 150, 0, true)
                
                outputConsole("Bolt típusok:", sourcePlayer)
                for i = 1, #shopDatas do
                    outputConsole("    " .. i .. " - " .. shopDatas[i][1], sourcePlayer)
                end
            else
                local shopType = math.floor(shopType)
                local skinId = math.floor(skinId)

                if shopDatas[shopType] then
                    local shopPosX, shopPosY, shopPosZ = getElementPosition(sourcePlayer)
                    local sourceInterior, sourceDimension = getElementInterior(sourcePlayer), getElementDimension(sourcePlayer)
                    local sourceRot = getPedRotation(sourcePlayer)

                    local shopName = table.concat({...}, " "):gsub(" ", "_")
                    local validSkin = false
                    local availableSkin = getValidPedModels()

                    for i = 1, #availableSkin do
                        if availableSkin[i] == skinId then
                            validSkin = true
                            break
                        end
                    end

                    if not validSkin then
                        outputChatBox("[SealMTA - Hiba]: #ffffffÉrvénytelen skinId.", sourcePlayer, 215, 89, 89, true)
                        return
                    end

                    dbExec(connection, "INSERT INTO shop (posX, posY, posZ, interior, dimension, type, name, skinId, rot) VALUES (?,?,?,?,?,?,?,?,?)", shopPosX, shopPosY, shopPosZ, sourceInterior, sourceDimension, shopType, shopName, skinId, sourceRot)
                
                    dbQuery(
                        function (qh)
                            local result = dbPoll(qh, 0)[1]
    
                            if result then
                                loadOnePed(result.shopId)
    
                                if isElement(sourcePlayer) then
                                    outputChatBox("#4adfbf[SealMTA - Siker]: #ffffffLétrehoztál egy pedet. #32b3ef(ID: " .. result.shopId .. " | Típus: " .. shopDatas[result.type][1] .. ")", sourcePlayer, 0, 0, 0, true)
                                end
                            end
                        end, connection, "SELECT * FROM shop WHERE shopId = LAST_INSERT_ID()"
                    )
                else
                    outputChatBox("[SealMTA - Hiba]: #ffffffNincs ilyen típusú bolt.", sourcePlayer, 215, 89, 89, true)
                end
            end
        end
    end
)

addCommandHandler("deleteshop",
    function(sourcePlayer, commandName, shopId)
        if not tonumber(shopId) then
            outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Bolt id]", sourcePlayer, 255, 150, 0, true)
        else
            local shopId = math.floor(shopId)

            if createdPeds[shopId] then
                if isElement(createdPeds[shopId]) then
                    destroyElement(createdPeds[shopId])
                end

                dbExec(connection, "DELETE FROM shop WHERE shopId = ?", shopId)
                outputChatBox("#4adfbf[SealMTA - Siker]: #ffffffSikeresen kitörölted a #32b3ef" .. shopId .. "#ffffff id-val(vel) rendelkező boltot.", sourcePlayer, 0, 0, 0, true)
            else
                outputChatBox("[SealMTA - Hiba]: #ffffffNincs ilyen id-vel rendelkező bolt.", sourcePlayer, 215, 89, 89, true)
            end
        end
    end
)