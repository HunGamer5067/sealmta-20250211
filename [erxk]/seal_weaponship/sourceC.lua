local crates = {}

addEvent("receiveCrates", true)
addEventHandler("receiveCrates", resourceRoot,
    function(receivedCrates)
        crates = receivedCrates
    end
)

addEventHandler("onClientResourceStart", root,
    function()
        loadFonts()
    end
)

function loadFonts()
    BebasFont = exports.seal_gui:getFont("6/BebasNeueRegular.otf")
end

addEventHandler("onClientRender", root,
function()
    for i, crateData in ipairs(crates) do
        if crateData.imageVisible then
            local playerX, playerY, playerZ = getElementPosition(localPlayer)
            local x, y, z = crateData[2], crateData[3], crateData[4]
            local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, x, y, z)

            local px, py = getScreenFromWorldPosition(x, y, z)

            if distance < 2 then
                if px and py then
                    dxDrawImage(px - 25, py, 24, 24, "files/crowbar.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                end
            end
        end
    end
end)

addEvent("removeCrateImage", true)
addEventHandler("removeCrateImage", resourceRoot,
function(crateIndex)
    if crates[crateIndex].imageVisible then
        crates[crateIndex].imageVisible = false
    end
end)

addEventHandler("onClientClick", root,
    function(button, state, _, _, _, _, _, clickedElement)
        if button ~= "left" or state ~= "down" then return end

        if not clickedElement then 
            return 
        end

        if getElementType(clickedElement) == "object" then
            local robObject = getElementData(clickedElement, "isWeaponBox")
            local playerX, playerY, playerZ = getElementPosition(localPlayer)
            local elementX, elementY, elementZ = getElementPosition(clickedElement)
            local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, elementX, elementY, elementZ)

            local isBeingPickedUp = getElementData(clickedElement, "isBeingPickedUp")
            local boxInHand = getElementData(localPlayer, "boxInHand")

            -- Ellenőrzések
            if distance >= 2 then 
                return
            end

            if robObject then
                if boxInHand then
                    outputChatBox("#ff0000[SealMTA - Fegyverhajó]: #ffffffMár egy ládát tartasz.", 255, 255, 255, true)
                    return
                end

                if isBeingPickedUp then
                    outputChatBox("#ff0000[SealMTA - Fegyverhajó]: #ffffffEz a láda már fel van véve egy másik játékos által.", 255, 255, 255, true)
                    return
                end

                if not exports.seal_items:playerHasItem(118) then
                    outputChatBox("#ff0000[SealMTA - Fegyverhajó]: #ffffffNincs elég felszerelésed a doboz felfeszítéséhez.", 255, 255, 255, true)
                    return
                end

                triggerServerEvent("playerPickingBox", localPlayer, clickedElement)
            end
        end

        if button == "left" and state == "down" then
            if clickedElement and getElementType(clickedElement) == "ped" then
                local clickedPed = getElementData(clickedElement, "isInformationPed")
                
                if clickedPed then
                    triggerServerEvent("giveInformationItem", localPlayer)
                end
            end
        end
    end
)



function isMouseInPosition(x, y, width, height)
    if not isCursorShowing() then return false end
    local cursorX, cursorY = getCursorPosition()
    if cursorX and cursorY then
        local screenWidth, screenHeight = guiGetScreenSize()
        cursorX, cursorY = cursorX * screenWidth, cursorY * screenHeight
        return cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height
    end
    return false
end