addEventHandler("onClientPlayerDamage", getRootElement(), function(attacker, weapon)
    if weapon == 0 and getElementData(attacker, "budspencer") then
      -- setElementInterior(playSound3D("hit/hit" .. math.random(10) .. ".mp3", getElementPosition(attacker)), getElementInterior(attacker))
      -- setElementDimension(playSound3D("hit/hit" .. math.random(10) .. ".mp3", getElementPosition(attacker)), getElementDimension(attacker))
      budspencer = playSound3D("hit/hit" .. math.random(10) .. ".mp3", getElementPosition(attacker))
      setElementInterior(budspencer, getElementInterior(attacker))
      setElementDimension(budspencer, getElementDimension(attacker))
    end
end)
addCommandHandler("budspencer", function()
    if getElementData(localPlayer,"acc.adminLevel") >= 6 then 
      setElementData(localPlayer, "budspencer", not getElementData(localPlayer, "budspencer"))

      if(getElementData(localPlayer, "budspencer")) then
        outputChatBox("#7cc576[Budspencer]: #ffffffBekapcsoltad a Bud Spencer modot.", 255, 255, 255, true)
      else
        outputChatBox("#7cc576[Budspencer]: #ffffffKikapcsoltad a Bud Spencer modot.", 255, 255, 255, true)
      end
    end
end)