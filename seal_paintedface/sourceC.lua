local availableTextures = {
    "files/g1.png",
    "files/g2.png",
    "files/g3.png",
    --"files/g4.png",
}
local textures = {}

local playerTextures = {}
local playerShaders = {}

function createPaintedPlayerTexture(player)
    if playerShaders[player] then
        destroyPaintedPlayerTexture(player)
    end

    if isElement(player) then
        if not playerShaders[player] then
            playerShaders[player] = {}
        end
        
        local playerModel = getElementModel(player)
        local modelTextures = engineGetModelTextures(playerModel)

        for textureName, textureValue in pairs(modelTextures) do
            local shader = dxCreateShader("files/texturechanger.fx", 0, 0, false, "ped")

            if isElement(shader) then
                local pixels = dxGetTexturePixels(textureValue)
                local w, h = dxGetPixelsSize(pixels)

                pixels = nil
                collectgarbage("collect")

                local rt = dxCreateRenderTarget(w, h, true)
                dxSetRenderTarget(rt, true)
                dxSetBlendMode("modulate_add")

                dxDrawImage(0, 0, w, h, textureValue)

                for i = 1, 3 do
                    local splatterW, splatterH = (math.random(200, 1024)/1024)*w, (math.random(100, 511)/511)*h
                    local splatterX, splatterY = (w - splatterW)*math.random(0, 100)/100, (h - splatterH)*math.random(0, 100)/100
                    dxDrawImage(splatterX, splatterY, splatterW, splatterH, textures["files/g" .. i .. ".png"], 0, 0, 0, tocolor(255, 255, 255, 100))
                end

                dxSetBlendMode("blend")
                dxSetRenderTarget()

                local pixels = dxGetTexturePixels(rt)
                local texture = dxCreateTexture(pixels)
                
                engineApplyShaderToWorldTexture(shader, textureName, player)
                dxSetShaderValue(shader, "Tex0", texture)

                if isElement(texture) then
                    destroyElement(texture)
                end
                texture = nil

                if isElement(rt) then
                    destroyElement(rt)
                end
                rt = nil
                pixels = nil

                collectgarbage("collect")

                playerShaders[player][textureName] = shader
            end
        end
    end
end

function destroyPaintedPlayerTexture(player)
    if playerShaders[player] then
        for textureName in pairs(playerShaders[player]) do
            if isElement(playerShaders[player][textureName]) then
                destroyElement(playerShaders[player][textureName])
            end
            playerShaders[player][textureName] = nil
        end
        playerShaders[player] = nil
        collectgarbage("collect")
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    for i = 1, #availableTextures do
        textures[availableTextures[i]] = dxCreateTexture(availableTextures[i], "argb")
    end

    for k, v in pairs(getElementsByType("player", getRootElement(), true)) do
        if getElementData(v, "paintVisibleOnPlayer") then
            createPaintedPlayerTexture(v)
        end
    end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementData(source, "paintVisibleOnPlayer") then
        createPaintedPlayerTexture(source)
    end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if playerShaders[source] then
        destroyPaintedPlayerTexture(source)
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
    if playerShaders[source] then
        destroyPaintedPlayerTexture(source)
    end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if dataName == "paintVisibleOnPlayer" then
        if isElementStreamedIn(source) then
            if newValue then
                createPaintedPlayerTexture(source)
            elseif playerShaders[source] then
                destroyPaintedPlayerTexture(source)
            end
        end
    end
end)

addEventHandler("onClientElementModelChange", getRootElement(), function(oldValue, newValue)
    if playerShaders[source] then
        createPaintedPlayerTexture(source)
    end
end)