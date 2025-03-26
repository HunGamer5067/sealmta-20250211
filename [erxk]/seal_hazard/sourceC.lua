local objects = {}

addEvent("onCustomObjectCreated", true)
addEventHandler("onCustomObjectCreated", root, function(object)
    objects[object] = true
end)

addEvent("onCustomObjectDestroyed", true)
addEventHandler("onCustomObjectDestroyed", root, function(object)
    if objects[object] then
        objects[object] = nil
    end
end)

addEventHandler("onClientRender", root, function()
    for obj, _ in pairs(objects) do
        if isElement(obj) then
            local pX, pY, pZ = getElementPosition(localPlayer)
            local x, y, z = getElementPosition(obj)
            local distance = getDistanceBetweenPoints3D(pX, pY, pZ, x, y, z)
            local screenX, screenY = getScreenFromWorldPosition(x, y, z + 0.5, 0.07)
            if distance < 2 and screenX and screenY then
                dxDrawRectangle(screenX - 25, screenY - 25, 35, 35, tocolor(26, 27, 31, 255))
                dxDrawImage(screenX - 25, screenY - 22, 32, 32, "files/icon.png", 0, 0, 0)
            end
        end
    end
end)

-- Klikk esemény kezelése
addEventHandler("onClientClick", root, function(button, state, clickX, clickY)
    if button == "left" and state == "down" then
        for obj, _ in pairs(objects) do
            if isElement(obj) then
                local x, y, z = getElementPosition(obj)
                local screenX, screenY = getScreenFromWorldPosition(x, y, z + 0.5, 0.07)
                if screenX and screenY then
                    -- Ellenőrizzük, hogy a kattintás az ikon területén belül történt-e
                    local iconSize = 35
                    if clickX >= (screenX - iconSize / 2) and clickX <= (screenX + iconSize / 2) and
                       clickY >= (screenY - iconSize / 2) and clickY <= (screenY + iconSize / 2) then
                        
                        -- Törlés kérése a szerverről
                        local creator = getElementData(obj, "creator")
                        if creator == localPlayer then
                            triggerServerEvent("onRequestObjectDeletion", resourceRoot, obj)
                            exports.seal_chat:localActionC(localPlayer, "felvesz egy jelző háromszöget.")
                        else
                            exports.seal_gui:showInfobox("e", "Ez nem a te jelző háromszöged!")
                        end
                        break
                    end
                end
            end
        end
    end
end)
