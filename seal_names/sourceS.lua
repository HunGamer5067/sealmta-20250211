addEvent("syncChatState", true)
addEventHandler("syncChatState", getRootElement(), 
  function(players, state)
    triggerClientEvent(players, "syncChatState", client, state)
  end
)

addEvent("syncConsoleState", true)
addEventHandler("syncConsoleState", getRootElement(), 
  function(players, state)
    triggerClientEvent(players, "syncConsoleState", client, state)
  end
)

addCommandHandler("anames", function(sourcePlayer)
    local adminLevel = getElementData(sourcePlayer, "acc.adminLevel") or 0
    local adminDuty = getElementData(sourcePlayer, "adminDuty") or 0
    local anamesState = getElementData(sourcePlayer, "anamesState") or 0
    
    if anamesState > 0 and adminLevel > 0 then
        setElementData(sourcePlayer, "anamesState", 0)
        outputChatBox("[color=primary][SealMTA]: [color=hudwhite]Sikeresen [color=red]kikapcsoltad[color=hudwhite] az anamest!", sourcePlayer, 255, 255, 255, true)
        return
    end
    
    if adminLevel < 1 then
        outputChatBox("[color=red][SealMTA]: [color=hudwhite]Nincs jogosultságod a parancs használatához!", sourcePlayer, 255, 255, 255, true)
        return
    end
    
    if adminLevel <= 5 and adminDuty == 0 then
        setElementData(sourcePlayer, "anamesState", 0)
        outputChatBox("[color=red][SealMTA]: [color=hudwhite]Csak admindutyban használhatod ezt a parancsot!", sourcePlayer, 255, 255, 255, true)
        return
    end
    
    setElementData(sourcePlayer, "anamesState", adminLevel >= 8 and 3 or (adminLevel >= 6 and 2 or 1))
    outputChatBox("[color=primary][SealMTA]: [color=hudwhite]Sikeresen [color=green]bekapcsoltad[color=hudwhite] az anamest!", sourcePlayer, 255, 255, 255, true)
end)