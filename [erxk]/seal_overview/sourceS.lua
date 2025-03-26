local db = exports.seal_database:getConnection()

-- ha elbaszódna akkor a client == source a baj

addEvent("sendCharacterDatas", true)
addEventHandler("sendCharacterDatas", getRootElement(),
    function(accountData)

    if getElementData(client, "acc.adminLevel") < 1 then
        return
    end

    if isElement(client) and accountData then

        dbQuery(
            function(qh)

            local result = dbPoll(qh, -1)

            if result and #result > 0 then
                triggerClientEvent(client, "requestedCharDatas", client, result, accountData)
            else
                return exports.seal_gui:showInfobox(client, "error", "Nincs ilyen Karakternév!")
            end
        end, db, "SELECT * FROM accounts WHERE accID = ? FROM characters WHERE name = ?", accountData.accID)
    end
end)

addEvent("findPlayerFromAccID", true)
addEventHandler("findPlayerFromAccID", getRootElement(),
    function(accID)

        if getElementData(client, "acc.adminLevel") < 1 then
            return
        end

        local theClient = client
        if isElement(theClient) and accID then
            dbQuery(
                function(qh)
                    local result = dbPoll(qh, -1)
                    if result and #result > 0 then
                        dbQuery(
                            function(accQh)
                                local accResult = dbPoll(accQh, -1)
                                if accResult and #accResult > 0 then
                                    -- Ban adatok lekérése
                                    dbQuery(
                                        function(bansQh)
                                            local bansResult = dbPoll(bansQh, -1)
                                            if not bansResult then
                                                bansResult = {} -- Üres tábla, ha nincs ban
                                            end

                                            -- Adatok egyesítése
                                            local combinedData = {
                                                characters = result,
                                                account = accResult[1],
                                                bans = bansResult,
                                            }
                                            triggerClientEvent(theClient, "requestedCharDatas", theClient, combinedData, {})
                                        end, db, "SELECT * FROM bans WHERE playerAccountId = ?", accID
                                    )
                                else
                                    return exports.seal_gui:showInfobox(theClient, "error", "Nincs ilyen AccountID!")
                                end
                            end, db, "SELECT * FROM accounts WHERE accountId = ?", accID
                        )
                    else
                        return exports.seal_gui:showInfobox(theClient, "error", "Nincs ilyen AccountID!")
                    end
                end, db, "SELECT * FROM characters WHERE accountId = ?", accID
            )
        end
    end
)


addEvent("findPlayerFromName", true)
addEventHandler("findPlayerFromName", getRootElement(),
    function(charName)

        if getElementData(client, "acc.adminLevel") < 1 then
            return
        end

        local theClient = client
        if isElement(theClient) and charName then
            dbQuery(
                function(qh)
                    local result = dbPoll(qh, -1)
                    if result and #result > 0 then
                        local accountId = result[1].accountId

                        dbQuery(
                            function(accQh)
                                local accResult = dbPoll(accQh, -1)
                                if accResult and #accResult > 0 then
                                    -- Ban adatok lekérése
                                    dbQuery(
                                        function(bansQh)
                                            local bansResult = dbPoll(bansQh, -1)
                                            if not bansResult then
                                                bansResult = {} -- Üres tábla, ha nincs ban
                                            end

                                            -- Adatok egyesítése
                                            local combinedData = {
                                                characters = result,
                                                account = accResult[1],
                                                bans = bansResult,
                                            }
                                            triggerClientEvent(theClient, "requestedCharDatas", theClient, combinedData, {})
                                        end, db, "SELECT * FROM bans WHERE playerAccountId = ?", accountId
                                    )
                                else
                                    return exports.seal_gui:showInfobox(theClient, "error", "Nem található a karakterhez tartozó fiók!")
                                end
                            end, db, "SELECT * FROM accounts WHERE accountId = ?", accountId
                        )
                    else
                        return exports.seal_gui:showInfobox(theClient, "error", "Nincs fiók ezzel a karakter névvel!")
                    end
                end, db, "SELECT * FROM characters WHERE name = ?", charName
            )
        end
    end
)