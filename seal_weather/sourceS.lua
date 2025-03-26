function sendWeather(player)
    local rt = getRealTime()
    local h, m, s = rt.hour, rt.minute, rt.second
    if player then
        triggerClientEvent(player, "gotTimeChange", player, h, m, s)
    else
        triggerClientEvent(getRootElement(), "gotTimeChange", getRootElement(), h, m, s)
    end
end
addEvent("requestWeather", true)
addEventHandler("requestWeather", getRootElement(), sendWeather)

addEventHandler("onResourceStart", resourceRoot, function()
    sendWeather()
    setTime(h, m)
    setTimer(sendWeather, 10000, 0)
end)