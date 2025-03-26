-- Szerver oldal módosításai

-- Játékos kilépés esemény kezelése
addEventHandler("onPlayerQuit", root, function()
    local player = source
    if getElementData(player, "hasPlacedObject") then
        for _, object in ipairs(getElementsByType("object")) do
            if getElementData(object, "creator") == player then
                destroyCustomObject(object)
            end
        end
    end
end)

-- További kód a meglévő részekből
addEventHandler("onResourceStart", resourceRoot,
    function()
        setElementData(source, "hasPlacedObject", false)
    end
)

local canPlaceThis = true

function createCustomObject(player)
    if getElementData(player, "hasPlacedObject") then 
        return 
    end
    
    local x, y, z = getElementPosition(player)
    local object = createObject(8493, x, y, z - 1)
    local colShape = createColSphere(x, y, z, 15)
    local rot1, rot2, rot3 = getElementRotation(player)
    setElementRotation(object, rot1, rot2, rot3 - 90)

    setElementData(object, "customColShape", colShape)
    setElementData(colShape, "customObject", object)
    setElementData(object, "creator", player)
    setElementData(player, "hasPlacedObject", true)
    setElementCollisionsEnabled(object, false)

    triggerClientEvent("onCustomObjectCreated", root, object)
    exports.seal_chat:localAction(player, "lerak egy jelző háromszöget.")

    addEventHandler("onColShapeLeave", colShape, function(element)
        if element == getElementData(object, "creator") then
            destroyCustomObject(object)
            exports.seal_chat:localAction(player, "felvesz egy jelző háromszöget.")
        end
    end)
end

function destroyCustomObject(object)
    if isElement(object) then
        local colShape = getElementData(object, "customColShape")
        if colShape and isElement(colShape) then
            destroyElement(colShape)
        end

        local creator = getElementData(object, "creator")
        if creator then
            setElementData(creator, "hasPlacedObject", false)
        end

        destroyElement(object)
    end
end

addEventHandler("onElementDestroy", root, function()
    local colShape = getElementData(source, "customColShape")
    if colShape and isElement(colShape) then
        destroyElement(colShape)
    end

    local creator = getElementData(source, "creator")
    if creator then
        setElementData(creator, "hasPlacedObject", false)
    end

    triggerClientEvent("onCustomObjectDestroyed", root, source)
end)

addEvent("onRequestObjectDeletion", true)
addEventHandler("onRequestObjectDeletion", root, function(object)
    local player = client
    if isElement(object) and player == getElementData(object, "creator") then
        destroyCustomObject(object)
    end
end)
