local disabledCollisionElements = {}

function setElementCollisionsEnabled(el, state, sync)
    if isElement(el) then
        setElementData(el, "nocollide", state or false, false)
    end
    
    if isElement(el) then
        if sync then
            triggerServerEvent("setElementCollisionsEnabled", resourceRoot, el, state)
        else
            if disabledCollisionElements[el] then
                disabledCollisionElements[el] = not (state or false)
            end

            if not disabledCollisionElements[el] and disabledCollisionElements[el] ~= nil then
                disabledCollisionElements[el] = nil
            end
            
            for _, elementType in pairs({"player", "vehicle", "ped"}) do
                for _, element in pairs(getElementsByType(elementType)) do
                    setElementCollidableWith(el, element, state or false)
                    setElementAlpha(el, (state and 255) or 160)
                end
            end
        end
    end
end
addEvent("setElementCollisionsEnabled", true)
addEventHandler("setElementCollisionsEnabled", getRootElement(), setElementCollisionsEnabled)

addEventHandler("onClientElementStreamIn", getRootElement(),
    function()
        if getElementData(source, "nocollide") then
            setElementCollisionsEnabled(el, false)
        end
    end
)