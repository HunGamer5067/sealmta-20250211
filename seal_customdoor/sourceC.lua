addEventHandler("onClientColShapeHit", getRootElement(), function(element, match)
    if (element == localPlayer) and match then
        if getElementData(source, "isDoorCol") then
            triggerServerEvent("moveDoorObject", getRootElement(), source)
        end
    end
end)

addEventHandler("onClientColShapeLeave", getRootElement(), function(element, match)
    if (element == localPlayer) and match then
        if getElementData(source, "isDoorCol") then
            triggerServerEvent("moveDoorObject", getRootElement(), source)
        end
    end
end)