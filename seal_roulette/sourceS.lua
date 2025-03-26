local roulettes = {}
local roulettesHistory = {}
local roulettePlayers = {}
local tableCountdowns = {}

local objects = {
    {7982, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {3433, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {8528, 1580.5618896484, -1597.29481, 573.84674072266},
    {8515, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {7982, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {8514, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {7982, 1580.5618896484, -1597.2827148438, 573.84674072266},
    {8502, 1556.05, -1572.3065185547, 570.8}
}

addEventHandler("onResourceStart", resourceRoot,
    function()


        for i, objData in ipairs(objects) do
            local model, x, y, z = unpack(objData)
            local obj = createObject(model, x, y, z)
            setElementInterior(obj, 2)
            setElementDimension(obj, 2)

            setElementDoubleSided(obj, true)
        end
    end
)

function resetRoulette(id)
    roulettes[id] = {
        lastNumber = 1,
        lastPos = 1,
        bets = {}
    }
    roulettesHistory[id] = {}

    for i = 1, 8 do
        table.insert(roulettesHistory[id], math.random(0, 36))
    end

    tableCountdowns[id] = {
        spin = false,
        slow = false,
        bounce = false,
        n = false,
        countdownStart = false
    }

    for seat = 1, 8 do
        roulettes[id].bets[seat] = {}
    end
end

function startRouletteSpin(id)
    local tbl = roulettes[id]
    local cd = tableCountdowns[id]

    cd.countdownStart = false
    cd.spinUp = getTickCount()

    triggerClientEvent(getRootElement(), "rouletteSpinUpBall", getRootElement(), id)

    setTimer(startRouletteSlow, math.random(3000, 6000), 1, id)
end

function startRouletteSlow(id)
    local tbl = roulettes[id]
    local cd = tableCountdowns[id]

    cd.spinUp = false
    cd.slowDown = getTickCount()

    triggerClientEvent(getRootElement(), "rouletteSlowDownBall", getRootElement(), id)

    setTimer(startRouletteBounce, math.random(3000, 6000), 1, id)
end

function startRouletteBounce(id)
    local tbl = roulettes[id]
    local cd = tableCountdowns[id]

    local win = {}
    local bet = {}

    local nextLP = math.random(0, #rouletteWheelNums - 1)
    local winNum = rouletteWheelNums[nextLP + 1]

    local seatPayouts = {}
    local seatTotalBets = {}

    for seat, bets in pairs(tbl.bets) do
        seatPayouts[seat] = 0
        seatTotalBets[seat] = 0

        for hover, amount in pairs(bets) do
            local hoverType = false

            if validBets[hover] then
                local tmp = validBets[hover]

                if type(tmp) == "table" then
                    hoverType = tmp[1]
                else
                    hoverType = tmp
                end
            end

            if hoverType then
                seatTotalBets[seat] = seatTotalBets[seat] + amount

                local winnerBets = winnerBets[winNum]

                for i = 1, #winnerBets do
                    local winnerBet = winnerBets[i]

                    if winnerBet == hover then
                        seatPayouts[seat] = seatPayouts[seat] + amount * (payouts[hoverType] + 1)
                    end
                end
            end
        end

        win[seat] = seatPayouts[seat] / seatTotalBets[seat]
        bet[seat] = seatTotalBets[seat]

        if seatTotalBets[seat] <= 0 then
            win[seat] = nil
            bet[seat] = nil
        else
            if win[seat] <= 0 then
                win[seat] = nil
            end

            if bet[seat] <= 0 then
                bet[seat] = nil
            end
        end
    end

    cd.slowDown = false
    cd.bounce = getTickCount()
    cd.n = winNum

    triggerClientEvent(getRootElement(), "rouletteBounceTheBall", getRootElement(), id, nextLP, winNum, win, bet)

    setTimer(endRouletteRound, 20000, 1, id)
end

function endRouletteRound(id)
    local tbl = roulettes[id]
    local cd = tableCountdowns[id]

    local winnerNum = cd.n

    for seat, bets in pairs(tbl.bets) do
        local player = roulettePlayers[id] and roulettePlayers[id][seat]

        if isElement(player) then
            local payout = 0
            local totalBets = 0

            for hover, amount in pairs(bets) do
                local hoverType = false

                if validBets[hover] then
                    local tmp = validBets[hover]

                    if type(tmp) == "table" then
                        hoverType = tmp[1]
                    else
                        hoverType = tmp
                    end
                end
                
                if hoverType then
                    totalBets = totalBets + amount

                    local winnerBets = winnerBets[winnerNum]

                    for i = 1, #winnerBets do
                        local winnerBet = winnerBets[i]

                        if winnerBet == hover then
                            payout = payout + amount * (payouts[hoverType] + 1)
                        end
                    end
                end
            end

            if payout > 0 then
                exports.seal_coindealer:giveSlotCoin(player, payout)
            end
        end
    end

    table.insert(roulettesHistory[id], winnerNum)

    cd.bounce = false
    cd.n = false

    tbl.bets = {}

    for seat = 1, 8 do
        tbl.bets[seat] = {}
    end

    triggerClientEvent(getRootElement(), "rouletteNewRound", getRootElement(), id)
end

addEvent("requestRouletteMachine", true)
addEventHandler("requestRouletteMachine", getRootElement(), function()
    for id = 1, #roulettes do
        local cd = tableCountdowns[id]
        local spin = cd.spinUp and getTickCount() - cd.spinUp
        local slow = cd.slowDown and getTickCount() - cd.slowDown
        local bounce = cd.bounce and getTickCount() - cd.bounce
        local n = cd.n
        local countdown = cd.countdownStart and getTickCount() - cd.countdownStart
        triggerLatentClientEvent(client, "streamInRoulette", client, id, roulettes[id], spin, slow, bounce, n, countdown, roulettesHistory[id])
    end
end)

addEvent("tryToSitDownRoulette", true)
addEventHandler("tryToSitDownRoulette", getRootElement(), function(id, seat)
    if client == source then
        for id2 in pairs(roulettePlayers) do
            for seat in pairs(roulettePlayers[id2]) do
                if roulettePlayers[id2][seat] == client then
                    exports.seal_gui:showInfobox(client, "e", "Már ülsz egy asztalnál!")
                    return
                end
            end
        end

        if roulettePlayers[id] then
            for seat2 in pairs(roulettePlayers[id]) do
                if seat == seat2 then
                    if roulettePlayers[id][seat2] and isElement(roulettePlayers[id][seat2]) then
                        return
                    end
                end
            end
        end

        if not roulettePlayers[id] then
            roulettePlayers[id] = {}
        end

        roulettePlayers[id][seat] = client

        triggerClientEvent(client, "refreshSSC", client, getElementData(client, "char.slotCoins"))
        triggerClientEvent(getRootElement(), "gotRoulettePlayer", client, id, seat, client)
    else
        --ac ban
    end
end)

addEvent("tryToExitRoulette", true)
addEventHandler("tryToExitRoulette", getRootElement(), function()
    if client == source then
        for id in pairs(roulettePlayers) do
            for seat in pairs(roulettePlayers[id]) do
                if roulettePlayers[id][seat] == client then
                    roulettePlayers[id][seat] = nil

                    triggerClientEvent(getRootElement(), "gotRoulettePlayer", client, id, seat, false)
                    return
                end
            end
        end
    else
        --ac ban
    end
end)

addEvent("tryToAddRouletteBet", true)
addEventHandler("tryToAddRouletteBet", getRootElement(), function(hover, amount)
    if client == source then
        local tmp = false

        for i = 1, #coinValues do
            if coinValues[i] == math.abs(amount) then
                tmp = true
                break
            end
        end
        
        if not tmp then
            --ac ban
            return
        end

        for id in pairs(roulettePlayers) do
            for seat in pairs(roulettePlayers[id]) do
                if roulettePlayers[id][seat] == client then
                    local tbl = roulettes[id]
                    local cd = tableCountdowns[id]
                    local bets = {}

                    if validBets[hover] then
                        local dat = validBets[hover]

                        if dat[1] == "n" then
                            local tmp = neighbours[dat[2]]

                            for i = 1, #tmp do
                                table.insert(bets, tmp[i])
                            end
                        else
                            table.insert(bets, hover)
                        end
                    else
                        local tmp = _G[hover .. "Bets"]

                        for i = 1, #tmp do
                            table.insert(bets, tmp[i])
                        end
                    end

                    if amount > 0 then
                        local minBetNoti = false

                        for i = 1, #bets do
                            local bet = bets[i]
                            local bets = tbl.bets[seat]
                            local previousBet = bets[bet]

                            if (bets[bet] or 0) + amount >= minBet then
                                if exports.seal_coindealer:takeSlotCoin(client, amount) then
                                    bets[bet] = (bets[bet] or 0) + amount
        
                                    if previousBet ~= bets[bet] then
                                        if not cd.countdownStart then
                                            cd.countdownStart = getTickCount()
                                            setTimer(startRouletteSpin, 65000, 1, id)
                                        end
        
                                        triggerClientEvent(getRootElement(), "gotNewRouletteBet", client, id, seat, bet, bets[bet], i ~= 1)
                                        triggerClientEvent(client, "refreshSSC", client, getElementData(client, "char.slotCoins"))
                                        exports.seal_anticheat:sendDiscordMessage(getPlayerName(client) .. " felrakott " .. inspect(amount) .. " SSC-t " .. inspect(bet) .. " asztal " .. inspect(id), "casino")
                                    end
                                else
                                    exports.seal_gui:showInfobox(client, "e", "Nincs elegendő SSC egyenleged!")
                                end
                            elseif not minBetNoti then
                                exports.seal_gui:showInfobox(client, "e", "Minimum tét: " .. minBet .. " SSC")
                                minBetNoti = true
                            end
                        end
                    else
                        for i = 1, #bets do
                            local bet = bets[i]
                            local bets = tbl.bets[seat]
                            local previousBet = bets[bet]

                            if bets[bet] then
                                local minus = math.abs(amount)
                                minus = math.min(bets[bet], minus)

                                if bets[bet] - minus < minBet then
                                    minus = bets[bet]
                                end

                                exports.seal_coindealer:giveSlotCoin(client, minus)
                                bets[bet] = bets[bet] - minus

                                if bets[bet] <= 0 then
                                    bets[bet] = nil
                                end

                                exports.seal_anticheat:sendDiscordMessage(getPlayerName(client) .. " levett " .. inspect(minus) .. " SSC-t ", "casino")
                            end

                            if previousBet ~= bets[bet] then
                                triggerClientEvent(getRootElement(), "gotNewRouletteBet", client, id, seat, bet, bets[bet], i ~= 1)
                                triggerClientEvent(client, "refreshSSC", client, getElementData(client, "char.slotCoins"))
                            end
                        end
                    end

                    return
                end
            end
        end
    else
        --ac ban
    end
end)

addEventHandler("onResourceStart", getRootElement(), function(res)
    if res == getThisResource() then
        for i = 1, #rouletteTableCoords do
            resetRoulette(i)
        end
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    for id in pairs(roulettePlayers) do
        for seat in pairs(roulettePlayers[id]) do
            if roulettePlayers[id][seat] == source then
                triggerClientEvent(getRootElement(), "gotRoulettePlayer", source, id, seat, false)
                roulettes[id].bets[seat] = {}
                roulettePlayers[id][seat] = nil
            end
        end
    end
end)