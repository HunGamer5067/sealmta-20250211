local timeH, timeM, timeS = 0, 0, 0

local skyColors = {{4.5,4,7,10,5,12,25},{7,65,132,208,209,199,154},{7.5,17,107,219,77,147,230},{12,17,107,219,77,147,230},{14.75,17,107,219,77,147,230},{17.5,71,100,136,135,87,45},{19.5,70,92,117,123,101,101},{22,4,7,10,5,12,25}}
function processSkyDay(p)
    local n = #skyColors
    for i = n, 1, -1 do
        if p >= skyColors[i][1] then
            if i >= n then
                return skyColors[n][2], skyColors[n][3], skyColors[n][4], skyColors[n][5], skyColors[n][6], skyColors[n][7]
            else
                local prog = (p - skyColors[i][1]) / (skyColors[i + 1][1] - skyColors[i][1])
                return skyColors[i][2] + (skyColors[i + 1][2] - skyColors[i][2]) * prog, skyColors[i][3] + (skyColors[i + 1][3] - skyColors[i][3]) * prog, skyColors[i][4] + (skyColors[i + 1][4] - skyColors[i][4]) * prog, skyColors[i][5] + (skyColors[i + 1][5] - skyColors[i][5]) * prog, skyColors[i][6] + (skyColors[i + 1][6] - skyColors[i][6]) * prog, skyColors[i][7] + (skyColors[i + 1][7] - skyColors[i][7]) * prog
            end
        end
    end
    return skyColors[1][2], skyColors[1][3], skyColors[1][4], skyColors[1][5], skyColors[1][6], skyColors[1][7]
end

function processSky(p)
    local tr, tg, tb, br, bg, bb = processSkyDay(p)
    setSkyGradient(tr, tg, tb, br, bg, bb)
end

addEvent("gotTimeChange", true)
addEventHandler("gotTimeChange", getRootElement(), function(h, m, s)
  timeH, timeM, timeS = h, m, s
  processSky(h + m / 60 + s / 3600)
end)

addEventHandler("onClientPreRender", getRootElement(), function(delta)
    local h = timeH
    local m = timeM

    local debugCycle = false
    if debugCycle then
        h = (getTickCount() % debugCycle) / (debugCycle/24)
        m = (getTickCount() % (debugCycle/24)) / ((debugCycle/24)/60)
    end

    setTime(h, m)
    setWeather(forceW or 2)
end, true, "high+9999999")

addEventHandler("onClientResourceStart", resourceRoot, function()
    triggerServerEvent("requestWeather", localPlayer, localPlayer)
    
    setMinuteDuration(1147483647)
    resetSkyGradient()
    resetWaterColor()
    processSky(timeH + timeM / 60 + timeS / 3600)
end)