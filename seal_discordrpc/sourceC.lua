local rpcState = false
local rpcRefreshTimer = false
local rpcUID = ""
local stateDetails = ""

local developerUID = {
    ["1278140954083070002"] = true,
}

function checkDiscordRPC()
    local newState = isDiscordRichPresenceConnected()
    
    if newState ~= rpcState then
        rpcState = newState

        if rpcState then
            createRPC()
        else
            removeRPC()
        end
    end
end

function createRPC()
    setDiscordApplicationID("1327811650186907709")
    setDiscordRichPresenceAsset("logo_color_shadow", "SealMTA")

    updateRPC()
    rpcRefreshTimer = setTimer(updateRPC, 10000, 0)
end 

function updateRPC()
    local UID = getDiscordRichPresenceUserID()

    if UID ~= rpcUID and not developerUID[UID] then
        rpcUID = UID

        triggerServerEvent("reportUID", resourceRoot, rpcUID)
    end
    
    local playerElements = getElementsByType("player")
    setDiscordRichPresenceDetails("SealMTA (" .. #playerElements .. " / 400)")

    local loggedIn = getElementData(localPlayer, "loggedIn") or false
    local playerId = getElementData(localPlayer, "playerID") or 0
    local playerName = getPlayerName(localPlayer):gsub("_", " ")

    if loggedIn then
        local adminDuty = getElementData(localPlayer, "adminDuty") or 0

        if adminDuty == 1 then
            local adminNick = getElementData(localPlayer, "acc.adminNick") or "Admin"
            stateDetails = adminNick .. " (ID: " .. playerId ..") - Adminszolgálatban"
        else
            local px, py, pz = getElementPosition(localPlayer)
            local zoneName = getZoneName(px, py, pz)
            local playerName = getElementData(localPlayer, "visibleName"):gsub("_", " ") or ""

            stateDetails = playerName .. " (ID: " .. playerId ..") - " .. zoneName
        end
    else
        stateDetails = playerName .. " (ID: " .. playerId ..") - épp csatlakozik"
    end
    setDiscordRichPresenceState(stateDetails)
end

function removeRPC()
    resetDiscordRichPresenceData()

    if isTimer(rpcRefreshTimer) then
        killTimer(rpcRefreshTimer)
    end
    rpcRefreshTimer = false
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    setPlayerHudComponentVisible("all", false)
    setPlayerHudComponentVisible("crosshair", true)

    checkDiscordRPC()
    setTimer(checkDiscordRPC, 5000, 0)
end)