local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif resName == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

addEvent("checkPlayerBanState", true)
addEventHandler("checkPlayerBanState", getRootElement(), function()
    dbQuery(function(qh, client)
        local result = dbPoll(qh, 0)

        if #result > 0 then
            for i = 1, #result do
                if result[i] then
                    if getRealTime().timestamp > result[i].expireTimestamp then
                        dbExec(connection, "UPDATE bans SET deactivated = 'Yes' WHERE serial = ?", serial)
                        dbExec(connection, "UPDATE accounts SET suspended = 0 WHERE serial = ?", serial)

                        triggerClientEvent(client, "receiveBanState", client, {}, getPlayerSerial(client))
                        break
                    end

                    if getRealTime().timestamp < result[i].expireTimestamp then
                        triggerClientEvent(client, "receiveBanState", client, result[1], getPlayerSerial(client))
                        break 
                    end
                end
            end
        else
            triggerClientEvent(client, "receiveBanState", client, {}, getPlayerSerial(client))
        end
    end, {client}, connection, "SELECT * FROM bans WHERE serial = ? AND deactivated = 'No'", getPlayerSerial(client))
end)

addEvent("tryRegistration", true)
addEventHandler("tryRegistration", getRootElement(), function()
    dbQuery(function(qh, client)
        local result = dbPoll(qh, 0)

        if #result > 0 then
            exports.seal_gui:showInfobox(client, "e", "A számítógépedhez már van társítva fiók.")
        else
            triggerClientEvent(client, "registrationResponse", client)
        end
    end, {client}, connection, "SELECT * FROM accounts WHERE serial = ?", getPlayerSerial(client))
end)

addEvent("tryEndRegistration", true)
addEventHandler("tryEndRegistration", getRootElement(), function(username, password, email)
    dbQuery(function(qh, client, username, password, email)
        local result = dbPoll(qh, 0)

        if #result > 0 then
            exports.seal_gui:showInfobox(client, "e", "A számítógépedhez már van társítva fiók.")
        else
            dbQuery(function(qh, client, username, password, email)
                local result = dbPoll(qh, 0)
        
                if result[1] and string.lower(result[1].username) == string.lower(username) then
                    exports.seal_gui:showInfobox(client, "e", "A felhasználónév már használatban van!")
                    return
                end
    
                if result[1] and string.lower(result[1].emailAddress) == string.lower(email) then
                    exports.seal_gui:showInfobox(client, "e", "Az email cím már használatban van!")
                    return
                end

                dbExec(connection, "INSERT INTO accounts (username, password, emailAddress, serial) VALUES (?,?,?,?)", username, passwordHash(password, "bcrypt", {}), email, getPlayerSerial(client))
                triggerClientEvent(client, "registrationEndResponse", client)
            end, {client, username, password, email}, connection, "SELECT * FROM accounts WHERE username OR emailAddress = ?", getPlayerSerial(client))
        end
    end, {client, username, password, email}, connection, "SELECT * from accounts WHERE serial = ?", getPlayerSerial(client))
end)

addEvent("tryLogin", true)
addEventHandler("tryLogin", getRootElement(), function(username, password)
    dbQuery(function(qh, client)
        local result = dbPoll(qh, 0)

        if #result > 0 then
            if passwordVerify(password, result[1].password) then
                setElementData(client, "char.accID", result[1].accountId)
                setElementData(client, "acc.username", result[1].username)
                setElementData(client, "acc.adminLevel", result[1].adminLevel)
                setElementData(client, "acc.helperLevel", result[1].helperLevel)
                setElementData(client, "acc.adminNick", result[1].adminNick)
                setElementData(client, "acc.premiumPoints", result[1].premiumPoints)
                setElementData(client, "acc.created", result[1].created)
                setElementData(client, "acc.lastLogin", result[1].lastLogin)
                
                dbQuery(function(qh, client)
                    local result = dbPoll(qh, 0)

                    if #result > 0 then
                        triggerClientEvent(client, "loginResponse", client, true, result)
                    else
                        triggerClientEvent(client, "loginResponse", client, false, {})
                    end
                end, {client}, connection, "SELECT * FROM characters WHERE accountId = ?", result[1].accountId)
            else
                exports.seal_gui:showInfobox(client, "e", "Helytelen felhasználónév vagy jelszó!")
            end
        else
            exports.seal_gui:showInfobox(client, "e", "Helytelen felhasználónév vagy jelszó!")
        end
    end, {client}, connection, "SELECT * FROM accounts WHERE serial = ?", getPlayerSerial(client))
end)

local characterSelect = {}
addEvent("selectCharacter", true)
addEventHandler("selectCharacter", getRootElement(), function(characterId)
    local accountId = getElementData(client, "char.accID") or false
    dbQuery(function(qh, client, characterId)
        local result = dbPoll(qh, 0)

        if #result > 0 then
            if result[1].accountId == accountId then
                spawnPlayer(client, result[1].posX, result[1].posY, result[1].posZ, result[1].rotZ, result[1].skin, result[1].interior, result[1].dimension)
                print(result[1].posZ)
                setElementModel(client, result[1].skin)
                setPedRotation(client, result[1].rotZ)
                setElementHealth(client, result[1].health)
                setPedArmor(client, result[1].armor)
                setPlayerName(client, result[1].name)
                
                setElementData(client, "char.ID", result[1].characterId)
                setElementData(client, "char.Name", result[1].name)
                setElementData(client, "char.Age", result[1].age)
                setElementData(client, "char.Description", result[1].description)
                setElementData(client, "char.Weight", result[1].weight)
                setElementData(client, "char.Height", result[1].height)
                setElementData(client, "char.Gender", result[1].gender)
                setElementData(client, "char.Hunger", result[1].hunger)
                setElementData(client, "char.Thirst", result[1].thirst)
                setElementData(client, "char.Money", result[1].money)
                setElementData(client, "char.bankMoney", result[1].bankMoney)
                setElementData(client, "char.playTimeForPayday", result[1].playTimeForPayday)
                setElementData(client, "char.slotCoins", result[1].slotCoins)
                setElementData(client, "char.playedMinutes", result[1].playedMinutes)
                setElementData(client, "char.maxVehicles", result[1].maxVehicles)
                setElementData(client, "char.interiorLimit", result[1].interiorLimit)
                setElementData(client, "char.Job", result[1].job)
                setElementData(client, "char.springs", tonumber(result[1].springs) or 0)
                setElementData(client, "visibleName", result[1].name)
                setElementData(client, "callRoomNumber", result[1].dimension)
                setElementData(client, "char.Skin", result[1].skin)
                setElementData(client, "colletedRewards", fromJSON(result[1].colletedRewards))
                setElementData(client, "completedRewards", fromJSON(result[1].completedRewards))

                if result[1].bulletDamages then
                    bulletDamages = fromJSON(result[1].bulletDamages)
                else
                    bulletDamages = {}
                end
                
                setElementData(client, "bulletDamages", bulletDamages)
                
                if result[1].radio > 0 then
                    setElementData(client, "char.Radio", result[1].radio)
                end
                
                if result[1].radio2 > 0 then
                    setElementData(client, "char.Radio2", result[1].radio2)
                end
                
                if result[1].paintOnPlayerTime > 0 then
                    setElementData(client, "paintOnPlayerTime", result[1].paintOnPlayerTime)
                end

                if result[1].clothesLimit then
                    setElementData(client, "clothesLimit", result[1].clothesLimit or 2)
                    
                    if result[1].boughtClothes and result[1].boughtClothes ~= "[[]]" and utfLen(result[1].boughtClothes) > 0 then
                        setElementData(client, "boughtClothes", result[1].boughtClothes)
                    end
                    
                    if result[1].currentClothes and result[1].currentClothes ~= "[[]]" and utfLen(result[1].currentClothes) > 0 then
                        setElementData(client, "currentClothes", result[1].currentClothes)
                    end
                end
                
                if result[1].weaponSkills and utfLen(result[1].weaponSkills) > 0 then
                    local skills = split(result[1].weaponSkills, ",")
                    
                    for i = 0, 10 do
                        setPedStat(client, 69 + i, tonumber(skills[i + 1]))
                    end
                end

                if result[1].actionBarItems and utfLen(result[1].actionBarItems) > 0 then
                    local items = split(result[1].actionBarItems, ";")
                    local temp = {}

                    for i = 1, 6 do
                        if items[i] then
                            temp[i] = tonumber(items[i])
                        else
                            temp[i] = false
                        end
                    end
                    
                    setElementData(client, "actionBarItems", temp)
                end
                
                if #result[1].playerRecipes > 0 then
                    local recipes = split(result[1].playerRecipes, ",")
                    local temp = {}

                    for i = 1, #recipes do
                        temp[tonumber(recipes[i])] = true
                    end

                    setElementData(client, "playerRecipes", temp)
                end
                
                setElementData(client, "isPlayerDeath", result[1].isPlayerDeath == 1)
                
                if #result[1].groups > 0 then
                    local groups = fromJSON(result[1].groups)

                    if groups then
                        local playerGroups = {}

                        for k, v in pairs(groups) do
                            playerGroups[tonumber(v.groupId)] = v.data
                        end

                        setElementData(client, "player.groups", playerGroups)

                        if result[1].inDuty ~= 0 and playerGroups[result[1].inDuty] then
                            setElementData(client, "inDuty", result[1].inDuty)
                            setElementModel(client, playerGroups[result[1].inDuty][2])
                        end
                    end
                end

                dbQuery(
                    function (qh)
                        local result = dbPoll(qh, 0)

                        if result then
                            setElementData(client, "acc.adminJail", result[1].adminJail)
                            setElementData(client, "acc.adminJailBy", result[1].adminJailBy, false)
                            setElementData(client, "acc.adminJailTimestamp", result[1].adminJailTimestamp, false)
                            setElementData(client, "acc.adminJailTime", result[1].adminJailTime)
                            setElementData(client, "acc.adminJailReason", result[1].adminJailReason, false)

                            if result[1].adminJail > 0 then
                                setTimer(setElementPosition, 1200, 1, client, 154.4810333252, -1951.5290527344, 47.875)
                                setElementDimension(client, getElementData(client, "char.accID") + math.random(1, 100))
                            end
                        end
                    end,
                connection, "SELECT adminJail, adminJailBy, adminJailTimestamp, adminJailTime, adminJailReason FROM accounts WHERE accountId = ?", result[1].accountId)
                
                dbQuery(
                    function (qh)
                        local result = dbPoll(qh, 0)[1]

                        if result and result.impoundedNum > 0 then
                            exports.seal_impound:informatePlayer(element)
                        end
                    end,
                connection, "SELECT COUNT(vehicleId) AS impoundedNum FROM vehicles WHERE impounded = 1 AND ownerId = ?", result[1].characterId)
                
                if result[1].jail == 1 then
                    setElementData(client, "char.jail", 1)
                    setElementData(client, "char.jailTime", result[1].jailTime)
                    setElementData(client, "char.jailTimestamp", result[1].jailTimestamp, false)
                    setElementData(client, "char.jailReason", result[1].jailReason, false)
                end

                if result[1].currentCustomInterior ~= 0 then
                    if not getElementData(client, "acc.adminJail") and not getElementData(client, "char.jail") then
                        exports.seal_interioredit:loadInterior(client, result[1].currentCustomInterior)
                    end
                end

                triggerClientEvent(client, "characterSelected", client, result[1].posX, result[1].posY, result[1].posZ, result[1].rotZ)
                characterSelect[client] = true
            end
        end
    end, {client, characterId}, connection, "SELECT * FROM characters WHERE characterId = ?", characterId)
end)

addEvent("successfullyLoggedIn", true)
addEventHandler("successfullyLoggedIn", getRootElement(), function()
    if characterSelect[client] then
        setElementData(client, "loggedIn", true)
        setElementFrozen(client, false)
        setCameraTarget(client, client)
        characterSelect[client] = false
    end
end)

addEvent("checkCharacterName", true)
addEventHandler("checkCharacterName", getRootElement(), function(name)
    dbQuery(function(qh, client)    
        local result = dbPoll(qh, 0)
        triggerClientEvent(client, "characterNameResponse", client, #result > 0)
    end, {client}, connection, "SELECT * FROM characters WHERE name = ?", name)
end)

addEvent("tryCharacterCreation", true)
addEventHandler("tryCharacterCreation", getRootElement(), function(name, age, weight, height, description, gender, skin)
    local accountId = tonumber(getElementData(client, "char.accID"))
    local name = name:gsub(" ", "_")
    if accountId then
        dbQuery(function(qh, client, accountId, name, age, weight, height, description, gender, skin)
            local result = dbPoll(qh, 0)

            if #result > 0 then
                exports.seal_gui:showInfobox(client, "e", "Ilyen névvel már van regisztrálva karakter!")
            else
                dbQuery(function(qh, client, accountId, name, age, weight, height, description, gender, skin)
                    local result = dbPoll(qh, 0)

                    if #result > 0 then
                        dbQuery(function(qh, client, accountId, name, age, weight, height, description, gender, skin, maxCharacters)    
                            local result, _, last = dbPoll(qh, 0)
                            if #result < maxCharacters then
                                triggerClientEvent(client, "successCharCreation", client)
                                dbExec(connection, "INSERT INTO characters (accountId, name, age, description, weight, height, gender, skin) VALUES (?,?,?,?,?,?,?,?)", accountId, name, age, description, weight, height, gender, skin)
                            end
                            dbFree(qh)
                        end, {client, accountId, name, age, weight, height, description, gender, skin, result[1].maximumCharacters}, connection, "SELECT * FROM characters WHERE accountId = ?", accountId)        
                    end
                    dbFree(qh)
                end, {client, accountId, name, age, weight, height, description, gender, skin}, connection, "SELECT * FROM accounts WHERE accountId = ?", accountId)
            end
            dbFree(qh)
        end, {client, accountId, name, age, weight, height, description, gender, skin}, connection, "SELECT * FROM characters WHERE name = ?", name)
    end
end)

