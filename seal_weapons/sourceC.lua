local sealexports = {
    seal_gui = false,
    seal_pattach = false,
    seal_hud = false,
    seal_items = false,
    seal_boneattach = false,
    seal_groups = false
}

local function sealangProcessSealExports()
    for resourceName in pairs(sealexports) do
        local resource = getResourceFromName(resourceName)

        if resource and getResourceState(resource) == "running" then
            sealexports[resourceName] = exports[resourceName]
        else
            sealexports[resourceName] = false
        end
    end
end

sealangProcessSealExports()

if triggerServerEvent then
    addEventHandler("onClientResourceStart", getRootElement(), sealangProcessSealExports, true, "high+9999999999")
end

if triggerClientEvent then
    addEventHandler("onResourceStart", getRootElement(), sealangProcessSealExports, true, "high+9999999999")
end

local screenX, screenY = guiGetScreenSize()

local availableTextures = {
    "files/muzzle/8.dds",
    "files/muzzle/9.dds",
    "files/lecer.dds",
    "files/circle.dds",
}
local textures = {}

local weaponObjectContainer = {}

local weaponFires = {}

local textureChangerFx = [[texture gTexture;
technique hello
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]

local availablePaintjobs = {}
local weaponTextureNames = {
	["ak-47"] = "ak",
	["sniper"] = "tekstura",
	["silenced"] = "1911",
	["desert_eagle"] = "deagle",
	["m4"] = "1stpersonassualtcarbine",
	["mp5lng"] = "mp5lng",
	["p90"] = "p90TEX",
	["knifecur"] = "kabar",
	["micro_uzi"] = "9MM_C",
	["chromegun"] = "m870t",
}
local weaponPaintjobs = {}

local laserSettings = {}

local editor = false

function toggleEditorGui()
    if isElement(editor) then
        destroyElement(editor)
    else
        local playerSideWeapons = getElementData(localPlayer, "playerSideWeapons")

        local playerSideWeaponsEx = {}
        for i = 1, #playerSideWeapons do
            local itemId = playerSideWeapons[i][1]

            table.insert(playerSideWeaponsEx, {itemId})
        end
        
        local num = math.min(#playerSideWeaponsEx, 12)
        local sx, sy = 500, 45 + num * 40

        editor = sealexports.seal_gui:createGuiElement("rectangle", screenX/2-sx/2, screenY/2-200, sx, sy)
        sealexports.seal_gui:setGuiBackground(editor, "solid", "grey3")
        sealexports.seal_gui:setGuiMoveable(editor, {0, 0, sx, 35})
        local header = sealexports.seal_gui:createGuiElement("rectangle", 0, 0, sx, 35, editor)
        sealexports.seal_gui:setGuiBackground(header, "solid", "grey2")
        local label = sealexports.seal_gui:createGuiElement("label", 5, 0, sx, 35, header)
        sealexports.seal_gui:setLabelFont(label, "14/Ubuntu")
        sealexports.seal_gui:setLabelText(label, "Fegyverek szerkesztése")

        for i = 1, num do
            local playerSideWeapon = playerSideWeaponsEx[i]

            local y = 40 + (i - 1) * 40
            local rect = sealexports.seal_gui:createGuiElement("rectangle", 5, y, sx - 10, 40, editor)
            sealexports.seal_gui:setGuiBackground(rect, "solid", "grey2")
            local img = sealexports.seal_gui:createGuiElement("image", 2, 2, 36, 36, rect)
            sealexports.seal_gui:setImageFile(img, ":seal_items/files/items/" .. playerSideWeapon[1] - 1 .. ".png")
            local label = sealexports.seal_gui:createGuiElement("label", 43, 0, sx, 40, rect)
            sealexports.seal_gui:setLabelFont(label, "14/Ubuntu")
            sealexports.seal_gui:setLabelText(label, sealexports.seal_items:getItemName(playerSideWeapon[1]) or "nil")
            local button = sealexports.seal_gui:createGuiElement("button", sx - 125, 5, 30, 30, rect)
            sealexports.seal_gui:setGuiBackground(button, "solid", "accent")
            sealexports.seal_gui:setGuiHover(button, "gradient", {"accent", "primary"}, 35)
            sealexports.seal_gui:setButtonIcon(button, "fa:eye-slash")
            local button = sealexports.seal_gui:createGuiElement("button", sx - 85, 5, 30, 30, rect)
            sealexports.seal_gui:setGuiBackground(button, "solid", "primary2")
            sealexports.seal_gui:setGuiHover(button, "gradient", {"primary2", "accent"}, 35)
            sealexports.seal_gui:setButtonIcon(button, "fa:bone")
            local button = sealexports.seal_gui:createGuiElement("button", sx - 45, 5, 30, 30, rect)
            sealexports.seal_gui:setGuiBackground(button, "solid", "primary")
            sealexports.seal_gui:setGuiHover(button, "gradient", {"primary", "accent"}, 35)
            sealexports.seal_gui:setButtonIcon(button, "fa:pencil-alt")

            if i ~= num then
                local hr = sealexports.seal_gui:createGuiElement("rectangle", 0, 39, sx - 10, 1, rect)
                sealexports.seal_gui:setGuiBackground(hr, "solid", "grey")
                local hr = sealexports.seal_gui:createGuiElement("rectangle", 0, 40, sx - 10, 1, rect)
                sealexports.seal_gui:setGuiBackground(hr, "solid", "grey3")
            end
        end
    end
end

addEvent("giveCustomWeapon", true)
addEventHandler("giveCustomWeapon", getRootElement(), function(player, weapon, skin)
    if weaponObjectContainer[player] then
        if isElement(weaponObjectContainer[player][1]) then
            sealexports.seal_pattach:detach(weaponObjectContainer[player][1])
            destroyElement(weaponObjectContainer[player][1])
        end
        weaponObjectContainer[player] = nil
    end

    if customWeaponContainer[weapon].modelId then
        weaponObjectContainer[player] = {createObject(customWeaponContainer[weapon].modelId, 0, 0, 0), weapon}
        setElementCollisionsEnabled(weaponObjectContainer[player][1], false)
        sealexports.seal_pattach:attach(weaponObjectContainer[player][1], player, 24, 0, 0, 0, 0, 0, 0)

        setElementData(weaponObjectContainer[player][1], "weapon.paintjob", skin)
        setElementData(weaponObjectContainer[player][1], "weapon.type", weapon)
        setElementData(weaponObjectContainer[player][1], "weapon.owner", player)
    end

    if player == localPlayer then
        if customWeaponContainer[weapon].laserOffset then
            outputChatBox("[SealMTA]: #ffffffA lézer színének megváltoztatásához használd a #5ec1e6/setlasercolor [0-6] #ffffffparancsot!", 94, 193, 230, true)
            outputChatBox("[SealMTA]: #ffffffA lézert ki-be kapcsolhatod az #5ec1e6'L' #ffffffbetűvel!", 94, 193, 230, true)

            if not getElementData(localPlayer, "laserSettings") then
                setElementData(localPlayer, "laserSettings", {0, true}) 
            end
        end
    end
end)

addEvent("takeCustomWeapon", true)
addEventHandler("takeCustomWeapon", getRootElement(), function()
    if weaponObjectContainer[source] then
        if isElement(weaponObjectContainer[source][1]) then
            sealexports.seal_pattach:detach(weaponObjectContainer[source][1])
            destroyElement(weaponObjectContainer[source][1])
        end
        weaponObjectContainer[source] = nil

        if isElement(source) and source == localPlayer then
            triggerServerEvent("syncCustomWeaponTake", resourceRoot)
        end
    end
end)

addEvent("syncWeaponShotSound", true)
addEventHandler("syncWeaponShotSound", resourceRoot, function(sourcePlayer, equippedCustomWeapon, x, y, z)
    if equippedCustomWeapon and not isElementStreamedIn(sourcePlayer) then
        if customWeaponContainer[equippedCustomWeapon] and customWeaponContainer[equippedCustomWeapon].soundPath then
            local px, py, pz = getElementPosition(localPlayer)
            local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            local soundPath = customWeaponContainer[equippedCustomWeapon].soundPath
            local maxSoundDistance = customWeaponContainer[equippedCustomWeapon].maxSoundDistance
            local maxDistance = 1

            if distance <= maxSoundDistance and distance > maxSoundDistance*0.75 then
                soundPath = soundPath .. "rev2"
                maxDistance = maxSoundDistance*2.3
            elseif distance <= maxSoundDistance*0.75 and distance > maxSoundDistance*0.5 then
                soundPath = soundPath .. "rev"
                maxDistance = maxSoundDistance*2
            elseif distance <= maxSoundDistance*0.5 and distance > maxSoundDistance*0.3 then
                soundPath = soundPath .. "dist2"
                maxDistance = maxSoundDistance
            elseif distance <= maxSoundDistance*0.3 and distance > maxSoundDistance*0.1 then
                soundPath = soundPath .. "dist"
                maxDistance = maxSoundDistance*0.6
            else
                maxDistance = 200
            end

            if fileExists("sounds/" .. soundPath .. ".wav") then
                local sound = playSound3D("sounds/" .. soundPath .. ".wav", x, y, z)
                setElementDimension(sound, getElementDimension(sourcePlayer))
                setElementInterior(sound, getElementInterior(sourcePlayer))
                setSoundMaxDistance(sound, maxDistance)
            end
        end
    end
end)

addEventHandler("onClientPlayerWeaponFire", getRootElement(), function(weapon, ammo, clipAmmo, hx, hy, hz, hitElement, sx, sy, sz)
    local equippedCustomWeapon = getElementData(source, "equippedCustomWeapon")

    if equippedCustomWeapon and customWeaponContainer[equippedCustomWeapon] then
        local weaponDatas = customWeaponContainer[equippedCustomWeapon]
        
        if customWeaponContainer[equippedCustomWeapon] and customWeaponContainer[equippedCustomWeapon].soundPath then
            if source == localPlayer then
                if weapon == 43 then
                    return
                end
                
                triggerServerEvent("syncWeaponShotSound", resourceRoot)
    
                if customWeaponContainer[equippedCustomWeapon].dropSoundPath then
                    setTimer(playSound, 100, 1, "sounds/" .. customWeaponContainer[equippedCustomWeapon].dropSoundPath .. ".wav")
                end
            end

            local px, py, pz = getElementPosition(localPlayer)
            local distance = getDistanceBetweenPoints3D(sx, sy, sz, px, py, pz)
            local soundPath = customWeaponContainer[equippedCustomWeapon].soundPath
            local maxSoundDistance = customWeaponContainer[equippedCustomWeapon].maxSoundDistance
            local maxDistance = 1

            if distance <= maxSoundDistance and distance > maxSoundDistance*0.75 then
                soundPath = soundPath .. "rev2"
                maxDistance = maxSoundDistance*2.3
            elseif distance <= maxSoundDistance*0.75 and distance > maxSoundDistance*0.5 then
                soundPath = soundPath .. "rev"
                maxDistance = maxSoundDistance*2
            elseif distance <= maxSoundDistance*0.5 and distance > maxSoundDistance*0.3 then
                soundPath = soundPath .. "dist2"
                maxDistance = maxSoundDistance
            elseif distance <= maxSoundDistance*0.3 and distance > maxSoundDistance*0.1 then
                soundPath = soundPath .. "dist"
                maxDistance = maxSoundDistance*0.6
            else
                maxDistance = 200
            end

            if fileExists("sounds/" .. soundPath .. ".wav") then
                if weapon == 43 then
                    return
                end

                local sound = playSound3D("sounds/" .. soundPath .. ".wav", sx, sy, sz)
                setElementDimension(sound, getElementDimension(source))
                setElementInterior(sound, getElementInterior(source))
                setSoundMaxDistance(sound, maxDistance)
            end
        end

        if customWeaponContainer[equippedCustomWeapon] and customWeaponContainer[equippedCustomWeapon].muzzlePosition then
            table.insert(weaponFires, {source, getTickCount(), equippedCustomWeapon, customWeaponContainer[equippedCustomWeapon].muzzlePosition, customWeaponContainer[equippedCustomWeapon].muzzleSize or 0.14})
        end
    end
end)

addEventHandler("onClientPedsProcessed", getRootElement(), function()
    local now = getTickCount()

    for i = 1, #weaponFires do
        if weaponFires[i] then
            local weaponFire = weaponFires[i]
            local sourcePlayer = weaponFire[1]
            local start = weaponFire[2]
            local elapsedTime = now - start
            local mx, my, mz = unpack(weaponFire[4])

            if isElement(sourcePlayer) and elapsedTime <= 100 and weaponObjectContainer[sourcePlayer] and isElement(weaponObjectContainer[sourcePlayer][1]) then
                local m = getElementMatrix(weaponObjectContainer[sourcePlayer][1])

                local size = weaponFire[5]
                local x2, y2, z2 = elementOffset(m, mx, my, mz)
                local x3, y3, z3 = elementOffset(m, mx + size * 2, my, mz)

				local angleStep = 360 / 5
				local randommax = 360
				local random = math.random(1, randommax)
                for i = 1, 5 do
					local angle = math.rad(angleStep * i) + (random/(360/randommax))
					local x4 = math.sin(angle)
					local y4 = math.cos(angle)
					local fx, fy, fz = elementOffset(m, mx, my + x4, mz + y4)
					dxDrawMaterialSectionLine3D(
						x3 - size/2, y3, z3,
						x2 + size/2, y2, z2,
						math.random(0, 2)*512, 0, 512, 512,
						textures["files/muzzle/9.dds"], size, tocolor(255, 255, 255, 200),
						fx, fy, fz
					)
                end
            else
                table.remove(weaponFires, i)
            end
        end
    end

    for playerElement, weaponDatas in pairs(weaponObjectContainer) do
        local weaponObject = weaponDatas[1]
        local weaponType = weaponDatas[2]
        local laserOffset = customWeaponContainer[weaponType].laserOffset
        local laserOffset2 = customWeaponContainer[weaponType].laserOffset2

        if isElement(playerElement) and isElement(weaponObject) then
            if laserOffset and laserSettings[playerElement] then
                local color = laserSettings[playerElement][1]
                local on = laserSettings[playerElement][2]

                if on then
                    local lx, ly, lz = unpack(laserOffset)

                    local m = getElementMatrix(weaponObject)
                    local x, y, z = elementOffset(m, lx, ly, lz)
                    local x2, y2, z2 = 0, 0, 0
                    if getPedControlState(playerElement, "aim_weapon") then
                        x2, y2, z2 = getPedTargetEnd(playerElement)
                    else
                        if laserOffset2 then
                            local lx2, ly2, lz2 = unpack(laserOffset2)
                            x2, y2, z2 = elementOffset(m, lx + 20 + lx2, ly + ly2, lz + lz2)
                        else
                            x2, y2, z2 = elementOffset(m, lx + 20, ly, lz)
                        end
                    end
                        
                    local hit, hx, hy, hz = processLineOfSight(x, y, z, x2, y2, z2)
                    if hit then
                        x2, y2, z2 = hx, hy, hz
                    end

                    dxDrawMaterialSectionLine3D(
                        x, y, z,
                        x2, y2, z2,
                        color*22, 0, 22, 1,
                        textures["files/lecer.dds"], 0.03
                    )
                end
            end
        else
            if isElement(weaponObject) then
                destroyElement(weaponObject)
            end
            weaponObjectContainer[playerElement] = nil
        end
    end
end, true, "low-9999")

--[[local previewObject = createObject(1905, getElementPosition(localPlayer))
addEventHandler("onClientRender", getRootElement(), function()
    if isElement(previewObject) then
        local m = getElementMatrix(previewObject)
        local x, y, z = getElementPosition(previewObject)
        
        local ax_x, ax_y, ax_z = elementOffset(m, 0.5, 0, 0)
        local ax2_x, ax2_y, ax2_z = elementOffset(m, -0.5, 0, 0)
        local ay_x, ay_y, ay_z = elementOffset(m, 0, 0.5, 0)
        local ay2_x, ay2_y, ay2_z = elementOffset(m, 0, -0.5, 0)
        local az_x, az_y, az_z = elementOffset(m, 0, 0, 0.5)
        local az2_x, az2_y, az2_z = elementOffset(m, 0, 0, -0.5)

        local camX, camY, camZ, lookAtX, lookAtY, lookAtZ = getCameraMatrix()

        local diffX, diffY, diffZ = x - camX, y - camY, z - camZ
    
        local distanceXY = math.sqrt(diffX * diffX + diffY * diffY)
        local pitch = math.deg(math.atan2(diffZ, distanceXY))
        local yaw = math.deg(math.atan2(diffY, diffX))
    
        local sx, sy = getScreenFromWorldPosition(x, y, z)
        dxDrawText(pitch .. ";" .. yaw, sx, sy)

        local distance = getDistanceBetweenPoints3D(x, y, z, camX, camY, camZ)
        local distanceMul = interpolateBetween(0.95, 0, 0, 0.17, 0, 0, distance/10, "Linear")

        local circleSize = 30 * distanceMul

        dxDrawLine3D(
            ax_x, ax_y, ax_z, 
            ax2_x, ax2_y, ax2_z,
            tocolor(69, 237, 97, 150), 1, true
        )
        dxDrawLine3D(
            ay_x, ay_y, ay_z, 
            ay2_x, ay2_y, ay2_z,
            tocolor(69, 133, 237, 150), 1, true
        )
        dxDrawLine3D(
            az_x, az_y, az_z, 
            az2_x, az2_y, az2_z,
            tocolor(237, 80, 69, 150), 1, true
        )
        
        local ax_sx, ax_sy = getScreenFromWorldPosition(ax_x, ax_y, ax_z)
        local ax2_sx, ax2_sy = getScreenFromWorldPosition(ax2_x, ax2_y, ax2_z)
        dxDrawImage(ax_sx - circleSize/2, ax_sy - circleSize/2, circleSize, circleSize, textures["files/circle.dds"], 0, 0, 0, tocolor(69, 237, 97), true)
        dxDrawImage(ax2_sx - circleSize/2, ax2_sy - circleSize/2, circleSize, circleSize, textures["files/circle.dds"], 0, 0, 0, tocolor(69, 237, 97), true)
    end
end)]]

addEventHandler("onClientKey", getRootElement(), function(key, press)
    if press then
        if key == "l" then
            if not isCursorShowing() and not guiGetInputEnabled() then
                local laserSettings = getElementData(localPlayer, "laserSettings")
                if laserSettings then
                    laserSettings[2] = not laserSettings[2]
                    setElementData(localPlayer, "laserSettings", laserSettings)
                end
            end
        end
    end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if dataName == "weapon.paintjob" then
        local weaponType = getElementData(source, "weapon.type")
        if weaponType then
            local weaponOwner = getElementData(source, "weapon.owner")
            local weaponPaintjob = getElementData(source, "weapon.paintjob")

            if weaponPaintjob and tonumber(weaponPaintjob) then
                weaponPaintjob = tonumber(weaponPaintjob)

                if availablePaintjobs[weaponType] and availablePaintjobs[weaponType][weaponPaintjob] and weaponTextureNames[weaponType] then
                    if weaponPaintjobs[source] then
                        if isElement(weaponPaintjobs[source]) then
                            destroyElement(weaponPaintjobs[source])
                        end
                        weaponPaintjobs[source] = nil
                    end
                    
                    local shader = dxCreateShader(textureChangerFx)

                    if shader then
                        dxSetShaderValue(shader, "gTexture", availablePaintjobs[weaponType][weaponPaintjob])
                        engineApplyShaderToWorldTexture(shader, weaponTextureNames[weaponType], source)
                        
                        weaponPaintjobs[source] = shader
                    end
                end
            end
        end
    elseif dataName == "laserSettings" then
        if isElementStreamedIn(source) then
            laserSettings[source] = newValue
        end
    elseif dataName == "equippedCustomWeapon" then
        if not newValue then
            if weaponObjectContainer[source] then
                if isElement(weaponObjectContainer[source][1]) then
                    sealexports.seal_pattach:detach(weaponObjectContainer[source][1])
                    destroyElement(weaponObjectContainer[source][1])
                end
                weaponObjectContainer[source] = nil
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementType(source) == "player" then
        laserSettings[source] = getElementData(source, "laserSettings")
    end

    local weaponType = getElementData(source, "weapon.type")
    if weaponType then
        local weaponOwner = getElementData(source, "weapon.owner")
        local weaponPaintjob = getElementData(source, "weapon.paintjob")

        if weaponPaintjob and tonumber(weaponPaintjob) then
            weaponPaintjob = tonumber(weaponPaintjob)

            if availablePaintjobs[weaponType] and availablePaintjobs[weaponType][weaponPaintjob] and weaponTextureNames[weaponType] then
                if weaponPaintjobs[source] then
                    if isElement(weaponPaintjobs[source]) then
                        destroyElement(weaponPaintjobs[source])
                    end
                    weaponPaintjobs[source] = nil
                end
                
                local shader = dxCreateShader(textureChangerFx)

                if shader then
                    dxSetShaderValue(shader, "gTexture", availablePaintjobs[weaponType][weaponPaintjob])
                    engineApplyShaderToWorldTexture(shader, weaponTextureNames[weaponType], source)
                    
                    weaponPaintjobs[source] = shader
                end
            end
        end
    end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if weaponPaintjobs[source] then
        if isElement(weaponPaintjobs[source]) then
            destroyElement(weaponPaintjobs[source])
        end
        weaponPaintjobs[source] = nil
    end
    if laserSettings[source] then
        laserSettings[source] = nil 
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
    if weaponObjectContainer[source] then
        if isElement(weaponObjectContainer[source][1]) then
            destroyElement(weaponObjectContainer[source][1])
        end
        weaponObjectContainer[source] = nil
    end
end)

addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), function(previousWeaponSlot, currentWeaponSlot)
    if getPedWeapon(source) == 0 then
        if weaponObjectContainer[source] then
            if isElement(weaponObjectContainer[source][1]) then
                destroyElement(weaponObjectContainer[source][1])
            end
            weaponObjectContainer[source] = nil
            triggerServerEvent("syncCustomWeaponTake", resourceRoot)
        end
    end
end)

addEventHandler("onClientElementDimensionChange", getRootElement(), function(oldDimension, newDimension)
    if weaponObjectContainer[source] then
        setElementDimension(weaponObjectContainer[source][1], newDimension)
    end
end)

addEventHandler("onClientElementInteriorChange", getRootElement(), function(oldInterior, newInterior)
    if weaponObjectContainer[source] then
        setElementInterior(weaponObjectContainer[source][1], newInterior)
    end
end)

addCommandHandler("setlasercolor", function(commandName, colorId)
    if tonumber(colorId) and tonumber(colorId) >= 0 and tonumber(colorId) <= 6 then
        colorId = tonumber(colorId)

        local laserSettings = getElementData(localPlayer, "laserSettings")
        if laserSettings then
            laserSettings[1] = colorId
            setElementData(localPlayer, "laserSettings", laserSettings)
        end
    else
        outputChatBox("#5ec1e6[SealMTA]: #ffffff/" .. commandName .. "[0-6]", 255, 255, 255, true)
    end
end)

addCommandHandler("fegyvereim", function()
    --toggleEditorGui()
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for model, path in pairs(weaponDummyContainer) do
        local dff = engineLoadDFF("files/weaponmodels/dummy/dummy_" .. path .. ".dff") 
        if dff then
            engineReplaceModel(dff, model)
        end
    end

    for weapon, datas in pairs(customWeaponContainer) do
        if datas.path and datas.modelId then
            local txd = engineLoadTXD("files/weaponmodels/" .. datas.path .. ".txd")
            if txd then
                engineImportTXD(txd, datas.modelId)

                local dff = engineLoadDFF("files/weaponmodels/" .. datas.path .. ".dff") 
                if dff then
                    engineReplaceModel(dff, datas.modelId)
                end
            end
        end
    end

    for k in pairs(availableTextures) do
        textures[availableTextures[k]] = dxCreateTexture(availableTextures[k], "argb")
    end

    setWorldSoundEnabled(5, false)

    local blankTex = dxCreateTexture(1, 1)
    local shader = dxCreateShader(textureChangerFx, 0, 0, false, "ped")
    if shader then
        dxSetShaderValue(shader, "gTexture", blankTex)
        engineApplyShaderToWorldTexture(shader, "muzzle_texture4")
    end

    availablePaintjobs = {
        ["ak-47"] = {
            [1] = dxCreateTexture("skins/ak/camo.png", "dxt1"),
            [2] = dxCreateTexture("skins/ak/camo2.png", "dxt1"),
            [3] = dxCreateTexture("skins/ak/camo3.png", "dxt1"),
            [4] = dxCreateTexture("skins/ak/gold.png", "dxt1"),
            [5] = dxCreateTexture("skins/ak/gold2.png", "dxt1"),
            [6] = dxCreateTexture("skins/ak/silver.png", "dxt1"),
            [7] = dxCreateTexture("skins/ak/kitty.png", "dxt1"),
        },
        ["sniper"] = {
            [1] = dxCreateTexture("skins/sniper/camo2.png", "dxt1"),
            [2] = dxCreateTexture("skins/sniper/camo.png", "dxt1"),
            [3] = dxCreateTexture("skins/sniper/gold.png", "dxt1"),
            [4] = dxCreateTexture("skins/sniper/hellokitty.png", "dxt1"),
        },
        ["desert_eagle"] = {
            [1] = dxCreateTexture("skins/deagle/camo.png", "dxt1"),
            [2] = dxCreateTexture("skins/deagle/gold.png", "dxt1"),
            [3] = dxCreateTexture("skins/deagle/hellokitty.png", "dxt1"),
        },
        ["katana"] = {
            [1] = dxCreateTexture("skins/katana/galaxy.png", "dxt1"),
            [2] = dxCreateTexture("skins/katana/gold.png", "dxt1"),
        },
        ["mp5lng"] = {
            [1] = dxCreateTexture("skins/mp5/mp51.png", "dxt1"),
            [2] = dxCreateTexture("skins/mp5/mp52.png", "dxt1"),
            [3] = dxCreateTexture("skins/mp5/mp53.png", "dxt1"),
            [4] = dxCreateTexture("skins/mp5/mp54.png", "dxt1"),
            [5] = dxCreateTexture("skins/mp5/mp55.png", "dxt1"),
            [6] = dxCreateTexture("skins/mp5/mp56.png", "dxt1"),
        },
        ["knifecur"] = {
            [1] = dxCreateTexture("skins/knife/knife1.png", "dxt1"),
            [2] = dxCreateTexture("skins/knife/knife2.png", "dxt1"),
            [3] = dxCreateTexture("skins/knife/knife3.png", "dxt1"),
            [4] = dxCreateTexture("skins/knife/knife4.png", "dxt1"),
            [5] = dxCreateTexture("skins/knife/knife5.png", "dxt1"),
            [6] = dxCreateTexture("skins/knife/knife6.png", "dxt1"),
            [7] = dxCreateTexture("skins/knife/knife7.png", "dxt1"),
            [8] = dxCreateTexture("skins/knife/knife8.png", "dxt1"),
        },
        ["micro_uzi"] = {
            [1] = dxCreateTexture("skins/uzi/uzi1.png", "dxt1"),
            [2] = dxCreateTexture("skins/uzi/uzi2.png", "dxt1"),
            [3] = dxCreateTexture("skins/uzi/uzi3.png", "dxt1"),
            [4] = dxCreateTexture("skins/uzi/uzi4.png", "dxt1"),
        },
        ["chromegun"] = {
            [5] = dxCreateTexture("skins/shotgun/shotgun_camo.png", "dxt1"),
            [6] = dxCreateTexture("skins/shotgun/shotgun_gold.png", "dxt1"),
            [7] = dxCreateTexture("skins/shotgun/shotgun_rust2.png", "dxt1"),
        },
        ["silenced"] = {
            [1] = dxCreateTexture("skins/silenced/camo.png", "dxt1"),
            [2] = dxCreateTexture("skins/silenced/camo2.png", "dxt1"),
            [3] = dxCreateTexture("skins/silenced/gold.png", "dxt1"),
            [4] = dxCreateTexture("skins/silenced/kitty.png", "dxt1"),
        },
        ["m4"] = {
            [1] = dxCreateTexture("skins/m4/camom4.png", "dxt1"),
            [2] = dxCreateTexture("skins/m4/digitm4.png", "dxt1"),
            [3] = dxCreateTexture("skins/m4/goldm4.png", "dxt1"),
            [4] = dxCreateTexture("skins/m4/goldm42.png", "dxt1"),
            [5] = dxCreateTexture("skins/m4/hellom4.png", "dxt1"),
            [6] = dxCreateTexture("skins/m4/icem4.png", "dxt1"),
            [7] = dxCreateTexture("skins/m4/m4_dragon.png", "dxt1"),
            [8] = dxCreateTexture("skins/m4/m4_howl.png", "dxt1"),
            [9] = dxCreateTexture("skins/m4/paintm4.png", "dxt1"),
            [10] = dxCreateTexture("skins/m4/rosem4.png", "dxt1"),
            [11] = dxCreateTexture("skins/m4/rustm4.png", "dxt1"),
            [12] = dxCreateTexture("skins/m4/silverm4.png", "dxt1"),
            [13] = dxCreateTexture("skins/m4/wandalm4.png", "dxt1"),
            [14] = dxCreateTexture("skins/m4/winterm4.png", "dxt1"),
        },
    }
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    for k in pairs(textures) do
        if isElement(textures[k]) then
            destroyElement(textures[k])
        end
        textures[k] = false
    end
end)

local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local playerWeaponShaders = {}
local sideWeaponObjects = {}
local sideWeaponShaders = {}

local previewWidth = respc(700)
local previewHeight = respc(500)

local previewPosX = screenX / 2 - previewWidth / 2
local previewPosY = screenY / 2 - previewHeight / 2

local previewName = false
local previewTarget = false
local previewScreen = false
local previewScreenSize = respc(1000)
local previewZoomSection = respc(250)
local previewZoom = 1

local previewInteriorObject = false
local previewWeaponObject = false
local previewWeaponShader = false

local myLastInterior = false
local myLastFrozenState = false

local Roboto = false
local isRotatingWeapon = false

function previewWeapon(itemId)
	Roboto = dxCreateFont("files/Roboto.ttf", respc(14), false, "antialiased")

	previewZoom = 1
	previewName = sealexports.seal_items:getItemName(itemId)
	previewTarget = dxCreateScreenSource(screenX, screenY)
	previewScreen = dxCreateScreenSource(previewScreenSize, previewScreenSize)

	dxUpdateScreenSource(previewTarget)

	myLastInterior = getElementInterior(localPlayer)
	myLastFrozenState = isElementFrozen(localPlayer)

	local pedX, pedY, pedZ = getElementPosition(localPlayer)
	local pedDimension = getElementDimension(localPlayer)

	setElementInterior(localPlayer, 255)
	setCameraMatrix(pedX + 1, pedY + 0.93, pedZ + 10 + 0.45, pedX - 1, pedY - 0.93, pedZ + 10 - 0.45, 0, 70)

	previewInteriorObject = createObject(18088, pedX - 1, pedY - 0.93, pedZ + 10 - 0.45)
	previewWeaponObject = createObject(itemWeaponModel[itemId], pedX - 1, pedY - 0.93, pedZ + 10 - 0.45)
	previewWeaponShader = dxCreateShader(textureChangerFx, 0, 0, false, "object")

	local weaponId = itemWeaponId[itemId]
	local paintjobId = sealexports.seal_items:getWeaponSkin(itemId)

	dxSetShaderValue(previewWeaponShader, "gTexture", availablePaintjobs[weaponId][paintjobId])
	engineApplyShaderToWorldTexture(previewWeaponShader, weaponTextureNames[weaponId], previewWeaponObject)

	setElementCollisionsEnabled(previewInteriorObject, false)
	setElementCollisionsEnabled(previewWeaponObject, false)

	setElementInterior(previewInteriorObject, 255)
	setElementInterior(previewWeaponObject, 255)

	setElementDimension(previewInteriorObject, pedDimension)
	setElementDimension(previewWeaponObject, pedDimension)

	isRotatingWeapon = false
	showCursor(true)
	setElementFrozen(localPlayer, true)

	addEventHandler("onClientHUDRender", getRootElement(), renderPreviewBCG, true, "high+99999")
	addEventHandler("onClientRender", getRootElement(), renderPreview, true, "low")
	addEventHandler("onClientRestore", getRootElement(), restoreThePreview)
	addEventHandler("onClientKey", getRootElement(), previewKey)
end

function restoreThePreview()
	setCameraTarget(localPlayer)

	removeEventHandler("onClientHUDRender", getRootElement(), renderPreviewBCG)
	removeEventHandler("onClientRender", getRootElement(), renderPreview)
	removeEventHandler("onClientRestore", getRootElement(), restoreThePreview)
	removeEventHandler("onClientKey", getRootElement(), previewKey)

	if isElement(previewScreen) then
		destroyElement(previewScreen)
	end

	if isElement(previewTarget) then
		destroyElement(previewTarget)
	end

	if isElement(previewInteriorObject) then
		destroyElement(previewInteriorObject)
	end

	if isElement(previewWeaponObject) then
		destroyElement(previewWeaponObject)
	end

	if isElement(previewWeaponShader) then
		destroyElement(previewWeaponShader)
	end

	if isElement(Roboto) then
		destroyElement(Roboto)
	end

	previewScreen = nil
	previewTarget = nil
	previewInteriorObject = nil
	previewWeaponObject = nil
	previewWeaponShader = nil
	Roboto = nil

	showCursor(false)
	setCursorAlpha(255)

	setElementInterior(localPlayer, myLastInterior)
	setElementFrozen(localPlayer, myLastFrozenState)
end

function previewKey(key, press)
	if key == "escape" or key == "backspace" then
		cancelEvent()

		if not press then
			restoreThePreview()
		end
	end

	if press then
		if key == "mouse_wheel_down" then
			if previewZoom > 1 then
				previewZoom = previewZoom - 0.1
			end
		elseif key == "mouse_wheel_up" then
			if previewZoom < 1.75 then
				previewZoom = previewZoom + 0.1
			end
		end
	end
end

function renderPreviewBCG()
	dxDrawImage(0, 0, screenX, screenY, previewTarget)
end

function renderPreview()
	dxUpdateScreenSource(previewScreen)

	dxDrawText(previewName, previewPosX + 1, previewPosY - respc(40) + 1, previewPosX + previewWidth + 1, previewPosY + 1, tocolor(0, 0, 0), 1, Roboto, "center", "center")
	dxDrawText(previewName, previewPosX, previewPosY - respc(40), previewPosX + previewWidth, previewPosY, tocolor(255, 255, 255), 1, Roboto, "center", "center")

	dxDrawRectangle(previewPosX - 5, previewPosY - 5, previewWidth + 10, previewHeight + 10, tocolor(0, 0, 0, 150))
	dxDrawImageSection(previewPosX, previewPosY, previewWidth, previewHeight, previewZoomSection * (previewZoom - 1), previewZoomSection * (previewZoom - 1), previewScreenSize - previewZoomSection * (previewZoom - 1) * 2, previewScreenSize - previewZoomSection * (previewZoom - 1) * 2, previewScreen)

	dxDrawText("Forgatás: egér | Kilépés: ESC / Backspace | Nagyítás: görgő", previewPosX + 1, previewPosY + previewHeight + 1, previewPosX + previewWidth + 1, previewPosY + previewHeight + respc(40) + 1, tocolor(0, 0, 0), 0.75, Roboto, "center", "center")
	dxDrawText("Forgatás: egér | Kilépés: ESC / Backspace | Nagyítás: görgő", previewPosX, previewPosY + previewHeight, previewPosX + previewWidth, previewPosY + previewHeight + respc(40), tocolor(255, 255, 255), 0.75, Roboto, "center", "center")

	local cursorX, cursorY = getCursorPosition()

	if cursorX then
		if isRotatingWeapon then
			local rotX, rotY, rotZ = getElementRotation(previewWeaponObject)

			setElementRotation(previewWeaponObject, rotX, rotY, (rotZ - (0.5 - cursorX) * 75) % 360)
			setCursorPosition(screenX / 2, screenY / 2)

			if not getKeyState("mouse1") then
				isRotatingWeapon = false
				setCursorAlpha(255)
			end
		else
			cursorX = cursorX * screenX
			cursorY = cursorY * screenY

			if cursorX >= previewPosX and cursorX <= previewPosX + previewWidth and cursorY >= previewPosY and cursorY <= previewPosY + previewHeight then
				if getKeyState("mouse1") then
					isRotatingWeapon = true
					setCursorAlpha(0)
					setCursorPosition(screenX / 2, screenY / 2)
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in pairs(getElementsByType("player")) do
			if getElementData(v, "loggedIn") then
				local currentWeaponPaintjob = getElementData(v, "currentWeaponPaintjob")

				if currentWeaponPaintjob then
					local paintjobId = currentWeaponPaintjob[1]
					local weaponId = currentWeaponPaintjob[2]

					if paintjobId then
						if paintjobId > 0 then
							playerWeaponShaders[v] = dxCreateShader(textureChangerFx, 0, 0, false, "ped")

							if isElement(playerWeaponShaders[v]) then
								dxSetShaderValue(playerWeaponShaders[v], "gTexture", availablePaintjobs[weaponId][paintjobId])
								engineApplyShaderToWorldTexture(playerWeaponShaders[v], weaponTextureNames[weaponId], v)
							end
						end
					end
				end

                --[[
				if getElementData(v, "playerSideWeapons") then
					if isElementStreamedIn(v) then
						processSideWeapons(v)
					end
				end]]
			end
		end
	end
)

local weaponSkinDatas = {}

function processWPSkinBack(pedElement, itemId, streamState)
    if not weaponSkinDatas[pedElement] then
        weaponSkinDatas[pedElement] = {}
    end

    if not weaponSkinDatas[pedElement][itemId] then
        weaponSkinDatas[pedElement][itemId] = {}
    end

    if streamState then
        local weaponId = itemWeaponId[itemId]
        local paintjobId = sealexports.seal_items:getWeaponSkin(itemId)
        
        if availablePaintjobs[weaponId] and availablePaintjobs[weaponId][paintjobId] and weaponTextureNames[weaponId] then
            weaponSkinDatas[pedElement][itemId].shader = dxCreateShader(textureChangerFx)
            weaponSkinDatas[pedElement][itemId].tex = weaponTextureNames[weaponId]
    
            weaponSkinDatas[pedElement][itemId].shader = dxCreateShader(textureChangerFx, 0, 0, false, "object")
            dxSetShaderValue(weaponSkinDatas[pedElement][itemId].shader, "gTexture", availablePaintjobs[weaponId][paintjobId])
            
            return weaponSkinDatas[pedElement][itemId].shader, weaponSkinDatas[pedElement][itemId].tex
        end
    else
        if weaponSkinDatas[pedElement] and weaponSkinDatas[pedElement][itemId] then
            if isElement(weaponSkinDatas[pedElement][itemId].shader) then
                destroyElement(weaponSkinDatas[pedElement][itemId].shader)
            end

            if isElement(weaponSkinDatas[pedElement][itemId].tex) then
                destroyElement(weaponSkinDatas[pedElement][itemId].tex)
            end

            weaponSkinDatas[pedElement][itemId] = nil
            collectgarbage("collect")
        end
    end

    return false
end

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "currentWeaponPaintjob" then
			local newValue = getElementData(source, "currentWeaponPaintjob")

			if isElement(playerWeaponShaders[source]) then
				destroyElement(playerWeaponShaders[source])
			end

			if newValue then
				local paintjobId = newValue[1]
				local weaponId = newValue[2]

				if paintjobId then
					if paintjobId > 0 then
						playerWeaponShaders[source] = dxCreateShader(textureChangerFx, 0, 0, false, "ped")

						if isElement(playerWeaponShaders[source]) then
							dxSetShaderValue(playerWeaponShaders[source], "gTexture", availablePaintjobs[weaponId][paintjobId])
							engineApplyShaderToWorldTexture(playerWeaponShaders[source], weaponTextureNames[weaponId], source)
						end
					end
				end
			end
            --[[
		elseif dataName == "adminDuty" then
			if isElementStreamedIn(source) then
				processSideWeapons(source)
			end
		elseif dataName == "playerSideWeapons" then
			if isElementStreamedIn(source) then
				processSideWeapons(source)
			end
		elseif dataName == "player.groups" then
			if isElementStreamedIn(source) then
				processSideWeapons(source)
			end]]
		end
	end
)

--[[
addEventHandler("onClientElementModelChange", getRootElement(),
	function ()
		if getElementType(source) == "player" then
			if getElementData(source, "playerSideWeapons") then
				processSideWeapons(source)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "player" then
			if getElementData(source, "playerSideWeapons") then
				processSideWeapons(source)
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if sideWeaponObjects[source] then
			for i = 1, #sideWeaponObjects[source] do
				if isElement(sideWeaponObjects[source][i]) then
					destroyElement(sideWeaponObjects[source][i])
				end
			end

			sideWeaponObjects[source] = nil
		end

		if sideWeaponShaders[source] then
			for i = 1, #sideWeaponShaders[source] do
				if isElement(sideWeaponShaders[source][i]) then
					destroyElement(sideWeaponShaders[source][i])
				end
			end

			sideWeaponShaders[source] = nil
		end
	end
)

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		if sideWeaponObjects[source] then
			for i = 1, #sideWeaponObjects[source] do
				if isElement(sideWeaponObjects[source][i]) then
					destroyElement(sideWeaponObjects[source][i])
				end
			end

			sideWeaponObjects[source] = nil
		end

		if sideWeaponShaders[source] then
			for i = 1, #sideWeaponShaders[source] do
				if isElement(sideWeaponShaders[source][i]) then
					destroyElement(sideWeaponShaders[source][i])
				end
			end

			sideWeaponShaders[source] = nil
		end
	end
)

function attachToBoneEX(sizeName, sideId, objectElement, pedElement, boneId, posX, posY, posZ, rotX, rotY, rotZ)
	local skinId = getElementModel(pedElement)
	local multiplier = (0.4) * 2.55

	if sizeName == "small" then
		if primaryMultipliers[skinId] then
			multiplier = primaryMultipliers[skinId] * 2.55
		end

		if sideId == 2 then
			if secondaryMultipliers[skinId] then
				multiplier = secondaryMultipliers[skinId] * 2.55
			end
		end

		if skinRotationOffsets[skinId] then
			rotX = rotX + skinRotationOffsets[skinId][1]
			rotY = rotY + skinRotationOffsets[skinId][2]
			rotZ = rotZ + skinRotationOffsets[skinId][3]
		end

		if skinPositionOffsets[skinId] then
			posX = posX + skinPositionOffsets[skinId][1]
			posY = posY + skinPositionOffsets[skinId][2]
			posZ = posZ + skinPositionOffsets[skinId][3]
		end
	end


	sealexports.seal_boneattach:attachElementToBone(objectElement, pedElement, boneId, posX * multiplier, posY * multiplier, posZ * multiplier, rotX, rotY, rotZ)
end]]

--[[
function processSideWeapons(pedElement)
	local visibleObjects = {}

	if sideWeaponShaders[pedElement] then
		if #sideWeaponShaders[pedElement] > 0 then
			for i = 1, #sideWeaponShaders[pedElement] do
				if isElement(sideWeaponShaders[pedElement][i]) then
					destroyElement(sideWeaponShaders[pedElement][i])
				end
			end
		end
	end

	sideWeaponShaders[pedElement] = {}

	if isElementStreamedIn(pedElement) then
		if getElementData(pedElement, "adminDuty") ~= 1 then
			local playerSideWeapons = getElementData(pedElement, "playerSideWeapons") or {}
			local sideWeaponCount = 0
			local backWeaponCount = 0
			local isIllegal = sealexports.seal_groups:isPlayerHavePermission(pedElement, "hideWeapons")

			for i = 1, #playerSideWeapons do
				local weaponData = playerSideWeapons[i]
				local itemId = weaponData[1]
				local modelId = itemWeaponModel[itemId]
				local hideTheWeapon = false

				if isIllegal and modelId then
					local statId = false

					if modelId == 352 or modelId == 372 then -- TEC-9, UZI
						statId = 75
					elseif modelId == 348 then -- Deagle
						statId = 71
					end

					if statId then
						if getPedStat(pedElement, statId) >= 990 then
							hideTheWeapon = true
						end
					end
				end

				if not hideTheWeapon then
					if weaponData[2] == "inuse" then
						if backWeapons[itemId] then
							backWeaponCount = backWeaponCount + 1

							if backWeaponCount > #backOffsets then
								backWeaponCount = 1
							end
						else
							sideWeaponCount = sideWeaponCount + 1

							if sideWeaponCount > #sideOffsets then
								sideWeaponCount = 1
							end
						end
					elseif weaponData[2] then
						if modelId then
							local pedX, pedY, pedZ = getElementPosition(pedElement)
							local objectElement = createObject(modelId, pedX, pedY, pedZ)

							setElementDimension(objectElement, getElementDimension(pedElement))
							setElementInterior(objectElement, getElementInterior(pedElement))
							setElementCollisionsEnabled(objectElement, false)

							local itemOffset = itemOffsets[itemId]

							if backWeapons[itemId] then
								backWeaponCount = backWeaponCount + 1

								if backWeaponCount > #backOffsets then
									backWeaponCount = 1
								end

								local mainOffset = backOffsets[backWeaponCount]
								local extraOffset = false

								if itemOffset then
									extraOffset = itemOffset[backWeaponCount]
								end
								
								if extraOffset then
									attachToBoneEX("big", backWeaponCount, objectElement, pedElement, 3, mainOffset[1] + extraOffset[1], mainOffset[2] + extraOffset[2], mainOffset[3] + extraOffset[3], mainOffset[4] + extraOffset[4], mainOffset[5] + extraOffset[5], mainOffset[6] + extraOffset[6])
								else
									attachToBoneEX("big", backWeaponCount, objectElement, pedElement, 3, unpack(mainOffset))
								end
							elseif itemOffset then
								sideWeaponCount = sideWeaponCount + 1

								if sideWeaponCount > #sideOffsets then
									sideWeaponCount = 1
								end

								local mainOffset = sideOffsets[sideWeaponCount]
								local extraOffset = itemOffset[sideWeaponCount]

								attachToBoneEX("small", sideWeaponCount, objectElement, pedElement, 4, mainOffset[1] + extraOffset[1], mainOffset[2] + extraOffset[2], mainOffset[3] + extraOffset[3], mainOffset[4] + extraOffset[4], mainOffset[5] + extraOffset[5], mainOffset[6] + extraOffset[6])
							else
								sideWeaponCount = sideWeaponCount + 1

								if sideWeaponCount > #sideOffsets then
									sideWeaponCount = 1
								end

								attachToBoneEX("small", sideWeaponCount, objectElement, pedElement, 4, unpack(sideOffsets[sideWeaponCount]))
							end

							local paintjobId = tonumber(weaponData[3])

							if paintjobId then
								if paintjobId > 0 then
									local weaponId = itemWeaponId[itemId]

									if weaponId then
										if weaponTextureNames[weaponId] then
											if availablePaintjobs[weaponId][paintjobId] then
												local shaderIndex = #sideWeaponShaders[pedElement] + 1

												sideWeaponShaders[pedElement][shaderIndex] = dxCreateShader(textureChangerFx, 0, 0, false, "object")

												if isElement(sideWeaponShaders[pedElement][shaderIndex]) then
													dxSetShaderValue(sideWeaponShaders[pedElement][shaderIndex], "gTexture", availablePaintjobs[weaponId][paintjobId])
													engineApplyShaderToWorldTexture(sideWeaponShaders[pedElement][shaderIndex], weaponTextureNames[weaponId], objectElement)
												end
											end
										end
									end
								end
							end

							table.insert(visibleObjects, objectElement)
						end
					end
				end
			end
		end
	end

	if sideWeaponObjects[pedElement] then
		for i = 1, #sideWeaponObjects[pedElement] do
			if isElement(sideWeaponObjects[pedElement][i]) then
				destroyElement(sideWeaponObjects[pedElement][i])
			end
		end
	end

	if visibleObjects then
		sideWeaponObjects[pedElement] = visibleObjects
	end
end--]]

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker)
    if isElement(attacker) and getElementType(attacker) == "player" then
        local equippedCustomWeapon = getElementData(attacker, "equippedCustomWeapon")

        if equippedCustomWeapon and equippedCustomWeapon == "vipera" then
            triggerServerEvent("viperaInjure", resourceRoot)
        end
    end
end)