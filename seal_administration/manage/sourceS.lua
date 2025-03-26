local connection = false

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		connection = db
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		connection = exports.seal_database:getConnection()
	end
)

addCommandHandler("resetallduty",
    function (sourcePlayer)
        if isHavePermission(sourcePlayer, "resetallduty") then
            dbQuery(
                function (qh)
                    local result = dbPoll(qh, 0)

                    for i = 1, #result do
                        if result[i] then
                            if result[i].online == 1 or result[i].online == "1" then
                                local playerElements = getElementsByType("player")

                                for k = 1, #playerElements do
                                    if playerElements[k] then
                                        local accountId = getElementData(playerElements[k], "char.accID") or false

                                        if tonumber(accountId) == tonumber(result[i].accountId) then
                                            setElementData(playerElements[k], "acc.adminDutyTime", 0)
                                        end
                                    end
                                end
                            end
                            dbExec(connection, "UPDATE accounts SET adminDutyTime = 0 WHERE accountId = ?", result[i].accountId)
                        end
                    end
                end, connection, "SELECT * FROM accounts WHERE adminLevel > 0 OR adminDutyTime > 0"
            )
            outputChatBox("[SealMTA]: #ffffffSikeresen nulláztad #32b2eemindenki#ffffff percét.", sourcePlayer, 94, 193, 230, true)
        end
    end
)

addCommandHandler("resetduty",
    function (sourcePlayer, commandName, targetPlayer)
        if isHavePermission(sourcePlayer, "resetduty") then
            if not targetPlayer then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név/ID]", sourcePlayer, 245, 150, 34, true)
            else
                local targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

                if targetPlayer then
                    local accountId = getElementData(targetPlayer, "char.accID") or false

                    if accountId then
                        local adminNick = getElementData(targetPlayer, "acc.adminNick") or false

                        setElementData(targetPlayer, "acc.adminDutyTime", 0)
                        dbExec(connection, "UPDATE accounts SET adminDutyTime = 0 WHERE accountId = ?", accountId)

                        if adminNick then    
                            outputChatBox("[SealMTA]: #ffffffSikeresen nulláztad #32b2ee" .. adminNick .. "#ffffff perceit.", sourcePlayer, 94, 193, 230, true)
                        end
                    end
                end
            end
        end
    end
)

addCommandHandler("resetdutyoffline",
    function (sourcePlayer, commandName, accountId)
        if isHavePermission(sourcePlayer, "resetdutyoffline") then
            local accountId = tonumber(accountId)

            if not accountId then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos AccountId]", sourcePlayer, 245, 150, 34, true)
            else
                dbQuery(
                    function (qh)
                        local result = dbPoll(qh, 0)

                        if #result > 0 then
                            local playerElements = getElementsByType("player")
                            local adminNick = result[1].adminNick

                            dbExec(connection, "UPDATE accounts SET adminDutyTime = 0 WHERE accountId = ?", accountId)

                            for i = 1, #playerElements do
                                if playerElements[i] then
                                    local elementAccountId = getElementData(playerElements[i], "char.accID") or false
                                    local targetAccountId = result[1].accountId or false
                                    
                                    if tonumber(elementAccountId) == tonumber(targetAccountId) then
                                        setElementData(playerElements[i], "acc.adminDutyTime", 0)
                                    end
                                end
                            end

                            if adminNick then
                                outputChatBox("[SealMTA]: #ffffffSikeresen nulláztad #32b2ee" .. adminNick .. "#ffffff perceit.", sourcePlayer, 94, 193, 230, true)
                            end
                        else
                            exports.seal_gui:showInfobox(sourcePlayer, "e", "Ilyen accountId-vel nem található játékos.")
                        end
                    end, connection, "SELECT * FROM accounts WHERE accountId = ?", accountId
                )
            end
        end
    end
)

addCommandHandler("listallduty",
    function(sourcePlayer)
        if isHavePermission(sourcePlayer, "listallduty") then
            dbQuery(
                function(qh)
                    local result = dbPoll(qh, 0)
                    local adminList = {}

                    for i = 1, #result do
                        local data = result[i]
                        if data then
                            table.insert(adminList, {
                                accountId = data.accountId,
                                adminLevel = data.adminLevel,
                                adminNick = data.adminNick,
                                adminDutyTime = data.adminDutyTime
                            })
                        end
                    end

                    table.sort(adminList,
                        function(a, b)
                            if a.adminDutyTime and b.adminDutyTime then
                                return tonumber(a.adminDutyTime) > tonumber(b.adminDutyTime)
                            end
                        end
                    )

                    local requiredMinutes =  2000*60000

                    for i = 1, #adminList do
                        local adminDutyMinutes = adminList[i].adminDutyTime / 60000

                        local color = "#32b2ee"
                        if tonumber(adminList[i].adminDutyTime) < tonumber(requiredMinutes) then
                            color = "#f55151"
                        end

                        if i <= 3 then
                            outputChatBox(getAdminLevelColor(adminList[i].adminLevel) .. "TOP " .. i .. " " .. adminList[i].adminNick .. " #ffffff[" .. adminList[i].accountId .. "] percei: " .. color  .. math.floor(adminDutyMinutes) .. "/2000.", sourcePlayer, 255, 255, 255, true)

                            if i == 3 then
                                outputChatBox("-----------------------------------", sourcePlayer, 255, 255, 255, true)
                            end
                        else
                            outputChatBox(getAdminLevelColor(adminList[i].adminLevel) .. adminList[i].adminNick .. " #ffffff[" .. adminList[i].accountId .. "] percei: " .. color  .. math.floor(adminDutyMinutes) .. "/2000.", sourcePlayer, 255, 255, 255, true)
                        end

                    end
                end,
            {sourcePlayer}, connection, "SELECT * FROM accounts WHERE adminLevel > 0 AND adminLevel < 6")
        end
    end
)

addCommandHandler("listalladmins",
    function(sourcePlayer)
        if isHavePermission(sourcePlayer, "listalladmins") then
            local playerElements = getElementsByType("player")
            outputChatBox("[SealMTA]: #ffffffElérhető adminok a szerveren:", sourcePlayer, 94, 193, 230, true)

            for i = 1, #playerElements do
                if playerElements[i] then
                    local adminLevel = getElementData(playerElements[i], "acc.adminLevel") or 0

                    if adminLevel >= 1 then
                        local adminNick = getElementData(playerElements[i], "acc.adminNick") or "Ismeretlen"
                        local loggedIn = getElementData(playerElements[i], "loggedIn") or false
                        local playerId = getElementData(playerElements[i], "playerID") or 0

                        if loggedIn then
                            loggedInText = "#32b2eeBejelentkezve"
                        else
                            loggedInText = "#f55151Nincs bejelentkezve"
                        end

                        local adminLevelColor = getAdminLevelColor(adminLevel) or "#7cc576"
                        local adminLevelTitle = getPlayerAdminTitle(playerElements[i]) or "Admin"

                        outputChatBox(adminLevelColor .. adminLevelTitle .. " (" .. adminLevel .. ") #ffffff" .. adminNick .. ": | Id: " .. playerId .. " | " .. loggedInText, sourcePlayer, 255, 255, 255, true)
                    end
                end
            end
        end
    end
)

-- Biztonsági intézkedések
addEventHandler("onResourceStart", resourceRoot,
    function()
        dbQuery(
            function(qh)
                local result = dbPoll(qh, -1)

                for k, v in pairs(result) do
                    if v.online == "1" then
                        local playerElements = getElementsByType("player")

                        for i = 1, #playerElements do
                            if playerElements[i] then
                                local elementAccountId = getElementData(playerElements[i], "char.accID") or false
                                local resultAccountId = v.accountId or false

                                if tonumber(elementAccountId) == tonumber(targetAccountId) then
                                    kickPlayer(playerElements[i], "AC - R189DGG1VDW47Y0T")
                                end
                            end
                        end
                    end
                end
            end,
        connection, "SELECT * FROM accounts WHERE suspended = '1'")
    end
)

addEventHandler("onPlayerQuit", root,
    function()
        if getElementData(source, "loggedIn") then
            local accountId = getElementData(source, "char.accID") or false
            local premiumPoints = getElementData(source, "acc.premiumPoints") or false

            if accountId and premiumPoints then
                dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", premiumPoints, accountId)
            end
        end
    end
)