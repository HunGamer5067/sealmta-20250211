local playerAnims = {}

function endAnimations(p)
    setPedAnimation(p, false)
    removeElementData(p, "customAnim")
end

addEvent("playAnimpanelAnimation", true)
addEventHandler("playAnimpanelAnimation", getRootElement(), function(anim)
    if not client then
        client = source
    end

    if canUseAnimation(client) then
        if playerAnims[client] ~= anim then
            playerAnims[client] = anim
        else
            playerAnims[client] = false
            endAnimations(client)
            setElementFrozen(client, false)
            triggerClientEvent(client, "gotCurrentAnim", client, false)
            return
        end
        
        if anim then
            if animList[anim][6] then
                setElementData(client, "customAnim", anim)
            else
                setPedAnimation(client, animList[anim][3], animList[anim][4], -1, animList[anim][5], false, false, animList[anim][7])
            end
        else
            setElementData(client, "customAnim", false)
            setPedAnimation(client) 
        end
        triggerClientEvent(client, "gotCurrentAnim", client, anim)
    end
end)

addCommandHandler("stopanim", function(p, cmd)
    if canUseAnimation(p) then
        endAnimations(p)
        setElementFrozen(p, false)
    end
end)

function canUseAnimation(playerElement)
    if isElement(playerElement) then
        local isPlayerTazed = getElementData(playerElement, "tazed")
        local isPlayerCuffed = getElementData(playerElement, "cuffed")

        if isPlayerTazed then
            return false
        end

        if isPlayerCuffed then
            return false
        end

        return true
    end

    return false
end