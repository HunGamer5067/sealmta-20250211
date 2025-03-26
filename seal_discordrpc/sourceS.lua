local reportedUID = {}
local reportContent = "**DISCORD UID REPORT**\n```client serial: %s\nclient ip: %s\nclient name: %s\nclient uid: %s```\nclient mention: <@%s>"
local joinContent = "**PLAYER JOINED**\n```client serial: %s\nclient ip: %s\nclient name: %s```"
local joinContentAdmin = "**PLAYER JOINED**\n```client name: %s```"
local quitContent = "**PLAYER DISCONNECTED**\n```client serial: %s\nclient ip: %s\nclient name: %s```"
local quitContentAdmin = "**PLAYER DISCONNECTED**\n```client name: %s```"

addEvent("reportUID", true)
addEventHandler("reportUID", resourceRoot, function(uid)
    if not (reportedUID[client] and reportedUID[client] == uid) then
        reportedUID[client] = uid

        local serial = getPlayerSerial(client)
        local ipAddress = getPlayerIP(client)
        local name = getPlayerName(client)

        sendWebhook("discord-uid", string.format(reportContent, serial, ipAddress, name, uid, uid))
    end
end)

addEventHandler("onPlayerJoin", getRootElement(), function()
    local serial = getPlayerSerial(source)
    local ipAddress = getPlayerIP(source)
    local name = getPlayerName(source)
    sendWebhook("connect-disconnect", string.format(joinContent, serial, ipAddress, name))
    sendWebhook("connect-disconnect-admin", string.format(joinContentAdmin, name))
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    reportedUID[source] = nil
    
    local serial = getPlayerSerial(source)
    local ipAddress = getPlayerIP(source)
    local name = getPlayerName(source)
    sendWebhook("connect-disconnect", string.format(quitContent, serial, ipAddress, name))
    sendWebhook("connect-disconnect-admin", string.format(quitContentAdmin, name))
end)