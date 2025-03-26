local trackingDatas = {}
local trackBlip = false
local trackBlipTimer = false

addEvent("createTrackingBlip", true)
addEventHandler("createTrackingBlip", resourceRoot, function(trackDatas)
    trackingDatas = trackDatas

    initTrackBlip()
    trackBlipTimer = setTimer(initTrackBlip, 20000, 0)
end)

function initTrackBlip()
    if isElement(trackingDatas[2]) then
        if not isElement(trackBlip) then
            trackBlip = createBlip(0, 0, 0, 0, 2, 215, 89, 89)
            setElementData(trackBlip, "blipTooltipText", "Telefonszám: " .. trackingDatas[1])
        end

        local x, y, z = getElementPosition(trackingDatas[2])
        local dim = getElementDimension(trackingDatas[2])

        if dim > 0 then
            local entrance = exports.seal_interiors:getInteriorEntrance(dim)
            if entrance then
                x, y, z = unpack(entrance.position)
            end
        end

        setElementPosition(trackBlip, x, y, z)
    else
        if isTimer(trackBlipTimer) then
            killTimer(trackBlipTimer)
        end
        trackBlipTimer = false
        outputChatBox("[SealMTA]: #ffffffMegszakadt a jel!", sourcePlayer, 215, 89, 89, true)
    end
end 

addEvent("deleteTrackingBlip", true)
addEventHandler("deleteTrackingBlip", resourceRoot, function()
    if isTimer(trackBlipTimer) then
        killTimer(trackBlipTimer)
    end
    trackBlipTimer = false

    if isElement(trackBlip) then
        destroyElement(trackBlip)
    end
    trackBlip = false

    trackingDatas = {}
end)