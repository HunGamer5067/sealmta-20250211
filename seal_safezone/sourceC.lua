local disabledDamage = {}

addEvent("enableSafeZone", true)
addEventHandler("enableSafeZone", getRootElement(),
    function()
        for _, elementType in pairs({"player", "vehicle", "ped"}) do
            for _, element in pairs(getElementsByType(elementType)) do
                setElementCollidableWith(source, element, false)
            end
        end

        local elementType = getElementType(source)
        
        if elementType == "vehicle" then
            iprint("kocsa")
        else
            disabledDamage[source] = source
        end 
    end
)

addEvent("disableSafeZone", true)
addEventHandler("disableSafeZone", getRootElement(),
    function()
        for _, elementType in pairs({"player", "vehicle", "ped"}) do
            for _, element in pairs(getElementsByType(elementType)) do
                setElementCollidableWith(source, element, true)
            end
        end

        local elementType = getElementType(source)
        
        if elementType == "vehicle" then
            iprint("kocsa")
        else
            disabledDamage[source] = nil
        end 
    end
)

addEventHandler("onClientPlayerDamage", getRootElement(),
    function()
        if disabledDamage[source] then
            cancelEvent()
        end
    end
)