local networkStatus = false

addEventHandler("onClientRender", root,
    function()
        local network = getNetworkStats()
        local breaked = false
        
        if network["packetlossTotal"] > 3 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to packetloss!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if network["packetlossLastSecond"] >= 1.6 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to packetloss!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if network["messagesInResendBuffer"] >= 2 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to messagesInResendBuffer!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if network["isLimitedByCongestionControl"] > 0 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to isLimitedByCongestionControl!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if network["isLimitedByOutgoingBandwidthLimit"] > 0 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to isLimitedByOutgoingBandwidthLimit!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if localPlayer.ping > 220 then
            if not networkStatus then
                --outputConsole("[Network] Switched off due to ping!")
                networkStatus = true
                setElementData(localPlayer, "networkState", true, false)
                lastBreakedTick = getTickCount()
                return
            end
            
            breaked = true
        end
        
        if networkStatus and not breaked then
            if lastBreakedTick + 3000 <= getTickCount() then
                --outputConsole("[Network] Switched on!")
                setElementData(localPlayer, "networkState", false, false)
                networkStatus = false
                return
            end
        end
    end, true, "high+55"
)

function getNetworkStatus()
    return networkStatus
end