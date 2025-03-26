local screenX, screenY = guiGetScreenSize()

local crashParticles = {}
local groundCache = {}

local crashTexture = {
    "files/crash1.dds",
    "files/crash2.dds",
    "files/crash3.dds",
    "files/crash4.dds",
    "files/shard1.dds",
    "files/shard2.dds",
    "files/shard3.dds",
    "files/shard4.dds",
    "files/shard5.dds",
    "files/cardebris1.dds",
    "files/cardebris2.dds",
    "files/cardebris3.dds",
    "files/cardebris4.dds",
    "files/cardebris5.dds"
}

local dynamicImageHandler = false
local dynamicImageLatCr = false
local dynamicImages = {}
local dynamicImageForm = {}
local dynamicImageMip = {}
local dynamicImageUsed = {}
local dynamicImageDelete = {}
local dynamicImagePreHandler

function dynamicImagePreHandler()
    local now = getTickCount()
    local rem = true
    dynamicImageLatCr = true

    for k in pairs(dynamicImages) do
        rem = false

        if dynamicImageDelete[k] then
            if now >= dynamicImageDelete[k] then
                if isElement(dynamicImages[k]) then
                    destroyElement(dynamicImages[k])
                end

                dynamicImages[k] = nil
                dynamicImageForm[k] = nil
                dynamicImageMip[k] = nil
                dynamicImageDelete[k] = nil
                break
            end
        elseif not dynamicImageUsed[k] then
            dynamicImageDelete[k] = now + 5000
        end
    end

    for k in pairs(dynamicImageUsed) do
        if not dynamicImages[k] and dynamicImageLatCr then
            dynamicImageLatCr = false
            dynamicImages[k] = dxCreateTexture(k, dynamicImageForm[k], dynamicImageMip[k])
        end

        dynamicImageUsed[k] = nil
        dynamicImageDelete[k] = nil
        rem = false
    end

    if rem then
        removeEventHandler("onClientPreRender", getRootElement(), dynamicImagePreHandler)
        dynamicImageHandler = false
    end
end

local function dynamicImage(img, form, mip)
    if not dynamicImageHandler then
        dynamicImageHandler = true
        addEventHandler("onClientPreRender", getRootElement(), dynamicImagePreHandler, true, "high+999999999")
    end
    if not dynamicImages[img] then
        dynamicImages[img] = dxCreateTexture(img, form, mip)
    end

    dynamicImageForm[img] = form
    dynamicImageUsed[img] = true

    return dynamicImages[img]
end

function spawnCrashParticle(keep, x, y, z, v, t, r, g, b, a, size)
    local r1, r2 = math.rad(math.random(0, 3600) / 10), math.rad(math.random(0, 3600) / 10)
    local vetritcal, horizontal = math.random(200, 1200) / 250 * v, math.random(400, 600) / 75

    if not keep then
        vetritcal = vetritcal * 1.1
        horizontal = horizontal * 1.5
        z = z - 0.15
    end

    table.insert(crashParticles, {x, y, z, math.cos(r1), math.sin(r1), math.cos(r2) * vetritcal, math.sin(r2) * vetritcal, horizontal, size, false, t, r, g, b, a, keep})
end

addEventHandler("onClientVehicleCollision", getRootElement(), function(collider, damageImpulseMag, bodyPart, x, y, z, nx, ny, nz)
    local sourceStreaiming = isElementStreamedIn(source)
    local sourceFrozen = isElementFrozen(source)

    if not sourceStreaiming then
        return
    end

    if sourceFrozen then
        return
    end

    if damageImpulseMag > 110 then
        local soundMaxDistance = math.min(120, 30 + 90 * ((damageImpulseMag - 110) / 1000))
        local soundInterior, soundDimension = getElementInterior(source), getElementDimension(source)

        local sound = playSound3D("files/crash" .. math.random(1, 9) .. ".mp3", x, y, z)
        setElementDimension(sound, soundDimension)
        setElementInterior(sound, soundInterior)
        setSoundMaxDistance(sound, soundMaxDistance)
        setSoundVolume(sound, 2.25)

        local number = math.max(20, math.ceil(damageImpulseMag * 0.2)) * 2
        local t, r, g, b, a = 1, 0, 0, 0, 255
        local s = 1

        for i = 1, number do
            local rand = math.random(10000) / 100

            if rand > 90 then
                r, g, b = getVehicleColor(source, true)
                t, a, s = math.random(1, 4), 255, 0.75
            elseif rand > 65 then
                r, g, b, a, t = 230, 240, 255, 175, math.random(5, 9)
            elseif rand > 25 then
                local color = math.random(0, 40)
                r, g, b, s, t, a = color, color, color, 0.85, math.random(1, 4), 255
            else
                local color = math.random(0, 200)
                s, r, g, b, a, t = 0.5, color, color, color, 255, math.random(10, 14)
            end
            
            spawnCrashParticle(i % 3 == 0, x, y, z - 0.1, 0.3 + (damageImpulseMag - 90) / 275, t, r, g, b, a, s * 0.8 * math.min(0.45, math.random(400, 1400) / 1000 * damageImpulseMag / 100 * 0.35))

            local playerVehicle = getPedOccupiedVehicle(localPlayer)
            if playerVehicle and playerVehicle == source then
                shakeCamera(0.5)
                setTimer(resetShakeCamera, 5000, 1)
            end
        end

        if #crashParticles > 1200 then
            for i = 1200, #crashParticles do
                table.remove(crashParticles, 1)
            end
        end
    end
end)


addEventHandler("onClientPreRender", getRootElement(), function(delta)
    if #crashParticles > 0 then
        local tick = getTickCount()
        local x, y, z = getWorldFromScreenPosition(screenX / 2, 0, 128)
        local x2, y2, z2 = getWorldFromScreenPosition(screenX / 2, screenY / 2, 128)

        x = x2 - x
        y = y2 - y
        z = z2 - z

        local len = math.sqrt(x * x + y * y + z * z) * 2

        x = x / len
        y = y / len
        z = z / len
        
        local keep = 0

        if #crashParticles < 0 then
            groundCache = {}
        end

        for i = #crashParticles, 1, -1 do
            local size = crashParticles[i][9]
            local rx, ry = crashParticles[i][4] * size / 2, crashParticles[i][5] * size / 2
            local a = crashParticles[i][15]

            if not crashParticles[i][10] then
                if crashParticles[i][8] > -10 then
                    crashParticles[i][8] = crashParticles[i][8] - 20 * delta / 1000
                end

                if crashParticles[i][16] then
                    keep = keep + 1
                end

                if 500 < keep then
                    crashParticles[i][16] = false
                end

                local mx, my, mz = crashParticles[i][6], crashParticles[i][7], crashParticles[i][8]

                if crashParticles[i][8] < 0 then
                    local gx, gy = math.floor(crashParticles[i][1] + 0.5), math.floor(crashParticles[i][2] + 0.5)
                    if not groundCache[gx] then
                        groundCache[gx] = {}
                    end

                    if not groundCache[gx][gy] then
                        groundCache[gx][gy] = math.max(-1, getGroundPosition(gx, gy, crashParticles[i][3] + 1) + 0.025)
                    end

                    local gz = groundCache[gx][gy]
                    if gz == 0 then
                        groundCache[gx][gy] = false
                    end

                    if gz < crashParticles[i][3] then
                        crashParticles[i][1] = crashParticles[i][1] + mx * delta / 1000
                        crashParticles[i][2] = crashParticles[i][2] + my * delta / 1000
                        crashParticles[i][3] = crashParticles[i][3] + mz * delta / 1000
                    elseif crashParticles[i][16] then
                        crashParticles[i][3] = gz
                        crashParticles[i][10] = tick + math.random(-2000, 2000)
                    else
                        table.remove(crashParticles, i)
                        a = 0
                    end
                else
                    crashParticles[i][1] = crashParticles[i][1] + mx * delta / 1000
                    crashParticles[i][2] = crashParticles[i][2] + my * delta / 1000
                    crashParticles[i][3] = crashParticles[i][3] + mz * delta / 1000
                end
            else
                local particle = (tick - crashParticles[i][10]) / 15000

                if particle > 1 then
                    particle = (particle - 1) / 0.1

                    if particle > 1 then
                        table.remove(crashParticles, i)
                        a = 0
                    else
                        a = a * (1 - particle)
                    end
                end
            end

            if a > 0 then
                local x, y, z = crashParticles[i][1], crashParticles[i][2], crashParticles[i][3]
                if crashParticles[i][10] then
                    dxDrawMaterialLine3D(x + rx, y + ry, z, x - rx, y - ry, z, dynamicImage(crashTexture[crashParticles[i][11]]), size, tocolor(crashParticles[i][12], crashParticles[i][13], crashParticles[i][14], a), x, y, z + 1)
                else
                    dxDrawMaterialLine3D(x, y, z - size / 2, x, y, z + size / 2, dynamicImage(crashTexture[crashParticles[i][11]]), size, tocolor(crashParticles[i][12], crashParticles[i][13], crashParticles[i][14], a))
                end
            end
        end
    end
end)