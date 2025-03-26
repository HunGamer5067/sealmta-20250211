local showedPlayers = {}
local showingPlayers = false
local showingPlayersTimer = false

function generateBlips()
    for k, v in pairs(showedPlayers) do
        if isElement(v[1]) then
            destroyElement(v[1])
        end
    end
    for k, v in pairs(getElementsByType("player")) do
        if getElementData(v, "loggedIn") then
            if getElementDimension(v) == 0 and v ~= localPlayer then
                showedPlayers[k] = {false, 0, 0}
                local playerPos = {getElementPosition(v)}
				showedPlayers[k][1] = createBlip(playerPos[1], playerPos[2], playerPos[3], 0, 2, 20, 100, 255)

				if isElement(showedPlayers[k][1]) then
					setElementData(showedPlayers[k][1], "blipTooltipText", getPlayerName(v))
				end
            end
        end
    end
end

addCommandHandler("showplayer",
    function(sourcePlayer)
        if getElementData(localPlayer, "acc.adminLevel") >= 1 then
            if getElementData(localPlayer, "adminDuty") == 1 or getPlayerSerial() == "C2B0917DC563370C91078DDE8C7F3DB4" then
                showingPlayers = not showingPlayers
                if showingPlayers then
                    showingPlayersTimer = setTimer(generateBlips, 500, 0)
                    outputChatBox("#4adfbf[SealMTA]: #ffffffBekapcsoltad a játékosok helyzetét. Megtekintés (F11)", 255, 255, 255, true)
                else
                    if isTimer(showingPlayersTimer) then
                        killTimer(showingPlayersTimer) 
                    end
                    for k, v in pairs(showedPlayers) do
                        if isElement(v[1]) then
                            destroyElement(v[1])
                        end
                    end
                    outputChatBox("#4adfbf[SealMTA]: #ffffffKikapcsoltad a játékosok helyzetét.", 255, 255, 255, true)
                end
            else
                outputChatBox("#4adfbf[SealMTA]: #ffffffCsak admindutyban használhatod ezt a parancsot.", 255, 255, 255, true)
            end
        end
    end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue, newValue)
        if source == localPlayer then
            if dataName == "adminDuty" then
                if newValue == 0 then
                    if isTimer(showingPlayersTimer) then
                        killTimer(showingPlayersTimer) 
                    end
        
                    for k, v in pairs(showedPlayers) do
                        if isElement(v[1]) then
                            destroyElement(v[1])
                        end
                    end

                    showingPlayers = false
                end
            end
        end
	end
)