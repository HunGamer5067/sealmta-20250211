local screenX, screenY = guiGetScreenSize()
local screenSrc, shader, texture
local effectState
local progress, effect = 0, 0
local vehicleFOV, vehicleMaxFOV = getCameraFieldOfView("vehicle"), getCameraFieldOfView("vehicle_max")
local fires = {}

function getVehicleSpeed(veh)
    if isElement(veh) then
        local x, y, z = getElementVelocity(veh)
        return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
    end
end

addEvent("nitroEffect", true)
addEventHandler("nitroEffect", getRootElement(), function(state)
    if isElement(source) and isElementStreamedIn(source) then
        local veh = getPedOccupiedVehicle(localPlayer)
        
        if source == veh then
            effectState = state

            setCameraFieldOfView("vehicle", vehicleFOV)
            setCameraFieldOfView("vehicle_max", vehicleMaxFOV)

            if state then
                playSound("files/ins.wav")
                
                dxSetShaderValue(shader, "r", 0.2)
                dxSetShaderValue(shader, "g", 0.1)
                dxSetShaderValue(shader, "b", -0.05)
            end
        end

        if state then
            local x, y, z = getElementPosition(source)
            local ex, ey, ez = getVehicleModelExhaustFumesPosition(getElementModel(source))
            local sound = playSound3D("files/outs.wav", x, y, z)
            setSoundMaxDistance(sound, 50)
            setSoundVolume(sound, 0.5)
            attachElements(sound, source)
            
            local t = getTickCount()
            table.insert(fires, {
                source,
                ex,
                ey,
                ez,
                0,
                false,
                sound,
                false,
                t
            })
            if bitAnd(getVehicleHandling(source).modelFlags, 8192) == 8192 then
                table.insert(fires, {
                    source,
                    -ex,
                    ey,
                    ez,
                    0,
                    false,
                    false,
                    false,
                    t
                })
            end
        else
            for i = #fires, 1, -1 do
                if fires[i][1] == source then
                    fires[i][6] = true
                end
            end
        end
    end
end)

addEventHandler("onClientPreRender", getRootElement(), function(delta)
    local cx, cy, cz = getCameraMatrix()
    local matrixes = {}
    for i = #fires, 1, -1 do
        if isElement(fires[i][1]) then
            if fires[i][6] then
                if fires[i][5] > 0 then
                    fires[i][5] = fires[i][5] - 2 * delta / 1000
                    if fires[i][5] < 0 then
                        fires[i][5] = 0
                    end
                end
            elseif 1 > fires[i][5] then
                fires[i][5] = fires[i][5] + 3 * delta / 1000
                if 1 < fires[i][5] then
                    fires[i][5] = 1
                end
            end
            local progress = 0
            local progress2 = 1
            if fires[i][6] then
                progress = 1
                progress2 = fires[i][5]
            else
                progress = fires[i][5]
                progress2 = 1
            end
            if matrixes[fires[i][1]] == nil then
                local x, y, z = getElementPosition(fires[i][1])
                if getDistanceBetweenPoints3D(cx, cy, cz, x, y, z) <= 90 then
                    matrixes[fires[i][1]] = getElementMatrix(fires[i][1])
                end
            end
            local m = matrixes[fires[i][1]]
            if m then
                local fx = fires[i][2]
                local fy = fires[i][3]
                local fz = fires[i][4]
                local x = fx * m[1][1] + fy * m[2][1] + fz * m[3][1] + m[4][1]
                local y = fx * m[1][2] + fy * m[2][2] + fz * m[3][2] + m[4][2]
                local z = fx * m[1][3] + fy * m[2][3] + fz * m[3][3] + m[4][3]
                if isElement(fires[i][7]) then
                    setElementPosition(fires[i][7], x, y, z)
                end
                local sp = 1.25 * progress
                local rx, ry, rz = -m[2][1], -m[2][2], -m[2][3]
                dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (1.25 * (1 - progress2)), y + ry * (1.25 * (1 - progress2)), z + rz * (1.25 * (1 - progress2)), math.random(0, 7) * 128, 256 * (1 - progress), 128, 256 * progress * progress2, texture, 1.25 / 2, tocolor(255, 255, 255, 200), false, x, y, z + 1)
                dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (1.25 * (1 - progress2)), y + ry * (1.25 * (1 - progress2)), z + rz * (1.25 * (1 - progress2)), math.random(0, 7) * 128, 256 * (1 - progress), 128, 256 * progress * progress2, texture, 1.25 / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z)
                dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (1.25 * (1 - progress2)), y + ry * (1.25 * (1 - progress2)), z + rz * (1.25 * (1 - progress2)), math.random(0, 7) * 128, 256 * (1 - progress), 128, 256 * progress * progress2, texture, 1.25 / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z + 1)
                dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (1.25 * (1 - progress2)), y + ry * (1.25 * (1 - progress2)), z + rz * (1.25 * (1 - progress2)), math.random(0, 7) * 128, 256 * (1 - progress), 128, 256 * progress * progress2, texture, 1.25 / 2, tocolor(255, 255, 255, 200), false, x - 1, y, z + 1)
            end
            if progress2 <= 0 then
                if isElement(fires[i][7]) then
                    destroyElement(fires[i][7])
                end
                table.remove(fires, i)
            end
        else
            if isElement(fires[i][7]) then
                destroyElement(fires[i][7])
            end
            table.remove(fires, i)
        end
    end

    local veh = getPedOccupiedVehicle(localPlayer)
    if effectState then
        if not veh then
            effectState = false
        end
        if progress < 1 then
            progress = progress + 4 * delta / 1000
            if 1 < progress then
                progress = 1
            end
        end
    elseif progress > 0 then
        progress = progress - 0.5 * delta / 1000
        if progress < 0 then
            progress = 0
            setCameraFieldOfView("vehicle", vehicleFOV)
            setCameraFieldOfView("vehicle_max", vehicleMaxFOV)
        end
    end
    if progress > 0 then
        local speed = veh and getVehicleSpeed(veh) or 0
        effect = math.min(1, math.max(0, speed / 150 * progress))
        dxSetShaderValue(shader, "blurValue", effect)
        setCameraFieldOfView("vehicle", vehicleFOV + 10 * effect)
        setCameraFieldOfView("vehicle_max", vehicleMaxFOV + 10 * effect)
    end
end)

addEventHandler("onClientRender", getRootElement(), function()
    if progress > 0 then
        dxUpdateScreenSource(screenSrc, true)
        dxDrawImage(math.random(-1000, 1000) / 800 * effect, math.random(-1000, 1000) / 800 * effect, screenX, screenY, shader)
    end
end, true, "low-9999999999")

addEventHandler("onClientResourceStart", resourceRoot, function()
    screenSrc = dxCreateScreenSource(screenX, screenY)
    dxUpdateScreenSource(screenSrc, true)
    shader = dxCreateShader("files/nitro.fx")
    dxSetShaderValue(shader, "sBaseTexture", screenSrc)
    texture = dxCreateTexture("files/backfire_nitro.dds")
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    setCameraFieldOfView("vehicle", vehicleFOV)
    setCameraFieldOfView("vehicle_max", vehicleMaxFOV)
end)