local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif resName == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

local playerRequesting = {}
local activeBets = {}
local competitionDatas = {
    {
        competition_id = 19,
        competition_name = "NB I",
        competetion_datas = {}
    }, 

    {
        competition_id = 174,
        competition_name = "NB II",
        competetion_datas = {}
    }
}

local availableMatches = {}
local notifyPlayers = {}

addEventHandler("onElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if dataName == "loggedIn" and newValue then
        local characterId = getElementData(source, "char.ID") or false

        if characterId and notifyPlayers[characterId] then
            local home = notifyPlayers[characterId].home
            local away = notifyPlayers[characterId].away
            local win = notifyPlayers[characterId].win

            if win then
                local odd = notifyPlayers[characterId].odd
                local amount = notifyPlayers[characterId].amount

                exports.seal_hud:showInfobox(source, "s", "Gratulálunk, a fogadásod nyert! (" .. home .. " - " .. away .. ")")
                outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffGratulálunk, a fogadásod nyert! #319ad7(" .. home .. " - " .. away .. ")", source, 255, 255, 255, true)
                outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffSzorzó: #319ad7" .. odd .. "x", source, 255, 255, 255, true)
                outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffÖsszeg: #319ad7" .. amount .. "$", source, 255, 255, 255, true)
                outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffA nyereményedet a karakteredhez hozzáadtuk!", source, 255, 255, 255, true)
            else
                exports.seal_hud:showInfobox(source, "e", "Sajnáljuk, de a fogadásod veszített! (" .. home .. " - " .. away .. ")")
                outputChatBox("#f35a5a[SealMTA - Sportfogadás]: #ffffffSajnáljuk, de a fogadásod veszített! #319ad7(" .. home .. " - " .. away .. ")", source, 255, 255, 255, true)
            end
            
            notifyPlayers[characterId] = nil
        end
    end
end)

function fetchUnpcomingMatches()
    for i = 1, #competitionDatas do
        competitionDatas[i].competetion_datas = {}

        iprint("fetchedData has been requested for " .. competitionDatas[i].competition_id)

        fetchRemote("https://livescore-api.com/api-client/fixtures/matches.json?competition_id=" .. competitionDatas[i].competition_id .. "&key=vmUvu3Hu5It2uF0L&secret=CWeJTOsMCDmxTIFp4AVyDC2JkwLPcMAO", function (data)
            local fetchedData = fromJSON(data)

            iprint("fetchedData has been received")

            for j = 1, #fetchedData.data.fixtures do
                competitionDatas[i].competetion_datas[j] = {
                    home_name = fetchedData.data.fixtures[j].home_name,
                    away_name = fetchedData.data.fixtures[j].away_name,
                    date = fetchedData.data.fixtures[j].date,
                    time = fetchedData.data.fixtures[j].time:gsub("(%d+:%d+:%d+)", addOneHour),
                    location = fetchedData.data.fixtures[j].location,
                    odds = fetchedData.data.fixtures[j].odds.pre,
                }

                local fixtureName = getFixtureFromName(fetchedData.data.fixtures[j].home_name, fetchedData.data.fixtures[j].away_name)
                availableMatches[fixtureName] = true

                local odds = {}
                for _, odd in pairs(competitionDatas[i].competetion_datas[j].odds) do
                    table.insert(odds, odd)
                end
                competitionDatas[i].competetion_datas[j].odds = odds
            end
        end)
    end
end

function fetchLiveMatches()
    for i = 1, #competitionDatas do
        fetchRemote("https://livescore-api.com/api-client/matches/live.json?competition_id=" .. competitionDatas[i].competition_id .. "&key=vmUvu3Hu5It2uF0L&secret=CWeJTOsMCDmxTIFp4AVyDC2JkwLPcMAO", function (data)
            local fetchedData = fromJSON(data)

            if fetchedData and fetchedData.data then
                local matchData = fetchedData.data.match

                if matchData then
                    for i = 1, #matchData do
                        local data = matchData[i]

                        local fixtureName = getFixtureFromName(data.home.name, data.away.name)

                        if data.status ~= "NOT STARTED" then
                            availableMatches[fixtureName] = false
                        end

                        if data.status == "FINISHED" then
                            checkBetsForMatch(fixtureName, data.outcomes.full_time, data.odds.pre, data.home.name, data.away.name)
                        end
                    end
                end
            end
        end)
    end
end

function getFixtureFromName(homeName, awayName)
    local fixtureName = homeName .. " - " .. awayName
    local bytes = encodeString("base64", fixtureName)
    bytes = bytes:gsub("=", "")

    return string.upper(bytes)
end

function checkBetsForMatch(fixtureId, team, odds, home, away)
    local betData = activeBets[fixtureId]
    
    if betData then
        for i = 1, #betData do
            local currentBet = betData[i]

            local characterId = currentBet.characterId
            local playerElement = getPlayerFromCharacterId(characterId)

            local betWinState = false
            local betTeam = tonumber(team) or team
            local betOdd = false
            local betAmount = currentBet.amount

            if betTeam == currentBet.team then
                local betTeam = tostring(betTeam)
                betOdd = odds[betTeam]
                betWinState = true
            end

            if betWinState then
                dbExec(connection, "UPDATE characters SET money = money + ? WHERE characterId = ?", math.floor(betAmount * betOdd), characterId)

                if playerElement then
                    local playerMoney = getElementData(playerElement, "char.Money") or 0
                    setElementData(playerElement, "char.Money", playerMoney + math.floor(betAmount * betOdd))

                    exports.seal_hud:showInfobox(playerElement, "s", "Gratulálunk, a fogadásod nyert! (" .. home .. " - " .. away .. ")")    
                    outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffGratulálunk, a fogadásod nyert! #319ad7(" .. home .. " - " .. away .. ")", playerElement, 255, 255, 255, true)
                    outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffSzorzó: #319ad7" .. math.round(betOdd, 2) .. "x", playerElement, 255, 255, 255, true)
                    outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffÖsszeg: #319ad7" .. math.floor(betAmount * betOdd) .. "$", playerElement, 255, 255, 255, true)
                else
                    notifyPlayers[characterId] = {
                        home = home,
                        away = away,
                        odd = math.round(betOdd, 2),
                        amount = math.floor(betAmount * betOdd),
                        win = true
                    }
                end
            else
                if playerElement then
                    exports.seal_hud:showInfobox(playerElement, "e", "Sajnáljuk, de a fogadásod veszített! (" .. home .. " - " .. away .. ")")
                    outputChatBox("#f35a5a[SealMTA - Sportfogadás]: #ffffffSajnáljuk, de a fogadásod veszített! #319ad7(" .. home .. " - " .. away .. ")", playerElement, 255, 255, 255, true)
                else
                    notifyPlayers[characterId] = {
                        home = home,
                        away = away,
                        win = false
                    }
                end
            end
        end
    end

    activeBets[fixtureId] = nil
end

function tryToAddBetForMatch(playerElement, teams, selectedTeam, betAmount, odds)
    if playerElement and teams and selectedTeam and betAmount then
        local fixtureId = getFixtureFromName(teams[1], teams[2])

        if not availableMatches[fixtureId] then
            exports.seal_gui:showInfobox(playerElement, "e", "A kiválasztott meccs nem elérhető!")
            return
        end

        if not activeBets[fixtureId] then
            activeBets[fixtureId] = {}
        end

        local characterId = getElementData(playerElement, "char.ID")
        local playerMoney = getElementData(playerElement, "char.Money") or 0

        for i = 1, #activeBets[fixtureId] do
            if activeBets[fixtureId][i].characterId == characterId then
                exports.seal_gui:showInfobox(playerElement, "e", "Már fogadtál erre a meccsre!")
                return
            end
        end

        if playerMoney - betAmount >= 0 then
            table.insert(activeBets[fixtureId], {
                characterId = characterId,
                amount = betAmount,
                team = selectedTeam,
                teams = teams,
                odds = odds
            })

            dbExec(connection, "UPDATE characters SET money = money - ? WHERE characterId = ?", betAmount, characterId)
            setElementData(playerElement, "char.Money", playerMoney - betAmount)

            exports.seal_hud:showInfobox(playerElement, "s", "Sikeresen fogadtál a meccsre! (" .. teams[1] .. " - " .. teams[2] .. ")")
            outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffSikeresen fogadtál a meccsre! #319ad7(" .. teams[1] .. " - " .. teams[2] .. ")", playerElement, 255, 255, 255, true)
            outputChatBox("#319ad7[SealMTA - Sportfogadás]: #ffffffÖsszeg: #319ad7" .. betAmount .. "$", playerElement, 255, 255, 255, true)
        else
            outputChatBox("#f35a5a[SealMTA - Sportfogadás]: #ffffffNincs elegendő pénzed a fogadáshoz!", playerElement, 255, 255, 255, true)
        end
    end
end

addEvent("tryToAddBetForMatch", true)
addEventHandler("tryToAddBetForMatch", getRootElement(), function(teams, selectedTeam, betAmount, odds)
    if client == source then
        if betAmount <= 0 then
            exports.seal_gui:showInfobox(client, "e", "A fogadás összege nem lehet 0 vagy annál kisebb!")
            return
        end

        tryToAddBetForMatch(client, teams, selectedTeam, betAmount, odds)
    end
end)

addEvent("requestLiveMatches", true)
addEventHandler("requestLiveMatches", getRootElement(), function(selectedCompetetion)
    if client == source then
        if not playerRequesting[client] then
            playerRequesting[client] = {}
        end

        if playerRequesting[client].liveMatches and (getTickCount() - playerRequesting[client].liveMatches) < 1000 then
            return
        end

        if competitionDatas[selectedCompetetion] then
            local playerElement = client
            local selectedCompetetion = selectedCompetetion
            playerRequesting[client].liveMatches = getTickCount()

            fetchRemote("https://livescore-api.com/api-client/matches/live.json?competition_id=" .. competitionDatas[selectedCompetetion].competition_id .. "&key=vmUvu3Hu5It2uF0L&secret=CWeJTOsMCDmxTIFp4AVyDC2JkwLPcMAO", function (data)
                local fetchedData = fromJSON(data)
                local matchData = fetchedData.data.match
                local liveMatches = {}

                for i = 1, #matchData do
                    local data = matchData[i]

                    liveMatches[i] = {
                        home_name = data.home.name,
                        away_name = data.away.name,
                        status = data.status,
                        time = data.time,
                        score = data.scores.score,
                        half_time_score = data.scores.ht_score,
                        scheduled = data.scheduled:gsub("(%d+:%d+:%d+)", addOneHour),
                    }
                end

                iprint(playerElement)
                triggerClientEvent(playerElement, "receiveLiveMatches", playerElement, liveMatches, selectedCompetetion)
            end)
        end
    end
end)

addEvent("requestActiveBets", true)
addEventHandler("requestActiveBets", getRootElement(), function()
    if client == source then
        if not playerRequesting[client] then
            playerRequesting[client] = {}
        end

        if playerRequesting[client].activeBets and (getTickCount() - playerRequesting[client].activeBets) < 1000 then
            return
        end

        playerRequesting[client].activeBets = getTickCount()

        local characterId = getElementData(client, "char.ID") or false
        local activeBets = {}

        if characterId then
            activeBets = getActiveBetsFromCharacterId(characterId)
        end

        triggerClientEvent(client, "receiveActiveBets", client, activeBets)
    end
end)

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function getActiveBetsFromCharacterId(characterId)
    local activePlayerBets = {}

    for fixtureId, bets in pairs(activeBets) do
        for i = 1, #bets do
            if bets[i].characterId == characterId then
                table.insert(activePlayerBets, bets[i])
            end
        end
    end

    return activePlayerBets
end

function getPlayerFromCharacterId(characterId)
    for _, player in pairs(getElementsByType("player")) do
        if getElementData(player, "char.ID") == characterId then
            return player
        end
    end
    return false
end

function sendUpcomingMatches(playerElement, selectedCompetetion)
    triggerClientEvent(playerElement, "receiveUpcomingMatches", playerElement, competitionDatas[selectedCompetetion].competetion_datas, selectedCompetetion)
end

addEvent("requestUpcomingMatches", true)
addEventHandler("requestUpcomingMatches", getRootElement(), function(selectedCompetetion)
    if client == source then
        if not playerRequesting[client] then
            playerRequesting[client] = {}
        end

        if playerRequesting[client].upcomingMatches and (getTickCount() - playerRequesting[client].upcomingMatches) < 1000 then
            return
        end

        if competitionDatas[selectedCompetetion] then
            playerRequesting[client].upcomingMatches = getTickCount()
            sendUpcomingMatches(client, selectedCompetetion)
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, function(startedResource)
    if fileExists("activeBets.json") then
        local file = fileOpen("activeBets.json")
        local data = fileRead(file, fileGetSize(file))
        fileClose(file)

        activeBets = fromJSON(data)
    end

    fetchUnpcomingMatches()
    
    setTimer(fetchUnpcomingMatches, 60000 * 30, 0)
    setTimer(fetchLiveMatches, 15000, 0)
end)

addEventHandler("onResourceStop", resourceRoot, function(stoppedResource)
    if fileExists("activeBets.json") then
        fileDelete("activeBets.json")
    end

    local file = fileCreate("activeBets.json")
    fileWrite(file, toJSON(activeBets))
    fileClose(file)
end)

function addOneHour(timeString)
    local hours, minutes, seconds = timeString:match("(%d+):(%d+):(%d+)")
    hours, minutes, seconds = tonumber(hours), tonumber(minutes), tonumber(seconds)

    if hours then
        hours = (hours + 1) % 24
    end

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end