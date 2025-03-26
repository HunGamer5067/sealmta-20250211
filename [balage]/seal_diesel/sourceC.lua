local screenX, screenY = guiGetScreenSize()
local collisionSmoke = dxCreateTexture("images/collisionsmoke.dds", "argb")

local smokeParticles = {}
local vehicleDatas = {}
local smokeVehicles = {
    [458] = true,
    [582] = true,
    [554] = true,
}

addEventHandler("onClientElementStreamOut", getRootElement(), function()
    if vehicleDatas[source] then
        vehicleDatas[source] = nil
    end
end)

addEventHandler("onClientPreRender", getRootElement(), function(delta)
    local vehicleElements = getElementsByType("vehicle", getRootElement(), true)
    local cameraX, cameraY, cameraZ = getCameraMatrix()
    local tick = getTickCount()

    for _, vehicleElement in pairs(vehicleElements) do
        local vehicleEngine = getVehicleEngineState(vehicleElement)
        local vehicleModel = getElementModel(vehicleElement)
        local vehicleHealth = getElementHealth(vehicleElement)
        local vehicleGear = getVehicleCurrentGear(vehicleElement)
        local vehicleController = getVehicleController(vehicleElement)

        if not vehicleDatas[vehicleElement] then
            vehicleDatas[vehicleElement] = {
                lastGear = 0,
                lastFume = 0,
                lastShift = 0
            }
        end

        if vehicleEngine and smokeVehicles[vehicleModel] then
            local smokeSpeed = 45 + 90 * (1 - 45 + 90 * (1 - vehicleHealth / 1000) / 1000)
            local vehicleSpeed = getVehicleSpeed(vehicleElement)
            local vehicleDatas = vehicleDatas[vehicleElement]

            if vehicleDatas.lastGear ~= vehicleGear then
                vehicleDatas.lastGear = vehicleGear
                vehicleDatas.lastShift = getTickCount()
            end

            if smokeSpeed >= vehicleSpeed or tick - vehicleDatas.lastShift < 1500 then
                local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicleElement)
                local distance = getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, cameraX, cameraY, cameraZ)

                if distance <= 80 then
                    vehicleDatas.lastFume = vehicleDatas.lastFume + delta

                    local smokeNum = 90 - 40 * (1 - vehicleHealth / 1000)
                    smokeNum = smokeNum * (0.5 + 0.5 * math.max(0, 1 - vehicleHealth / smokeSpeed))

                    local smokeSize = 0.7 + 0.4 * (1 - vehicleHealth / 1000)
                    local smokeColor = 30
                    local smokeAlpha = 0.8

                    if vehicleHealth < 700 then
                        smokeColor = smokeColor * (1 - 0.3 * vehicleHealth / 700)
                        smokeAlpha = smokeAlpha * (0.6 + 0.4 * (1 - vehicleHealth / 700))
                      else
                        smokeAlpha = smokeAlpha * 0.6
                    end

                    if vehicleSpeed > 0 then
                        smokeNum = smokeNum - smokeNum * 0.1
                        smokeSize = smokeSize + 0.45
                        smokeColor = smokeColor - 10
                    end

                    if smokeNum < vehicleDatas.lastFume then
                        vehicleDatas.lastFume = 0

                        local fumePositionX, fumePositionY, fumePositionZ = getVehicleModelExhaustFumesPosition(getElementModel(vehicleElement))
                        local rotationX, rotationY, rotationZ = getElementRotation(vehicleElement)
                        local velocityX, velocityY, velocityZ = getElementVelocity(vehicleElement)
                        velocityX = velocityX * 0.75
                        velocityY = velocityY * 0.75
                        velocityZ = velocityZ * 0.75
                        
                        if bitAnd(getVehicleHandling(vehicleElement).modelFlags, 8192) == 8192 then
                            spawnFume(vehicleX, vehicleY, vehicleZ, -fumePositionX, fumePositionY, fumePositionZ, rotationX, rotationY, rotationZ, smokeSize, smokeColor, smokeAlpha, velocityX, velocityY, velocityZ)
                        end

                        spawnFume(vehicleX, vehicleY, vehicleZ, fumePositionX, fumePositionY, fumePositionZ, rotationX, rotationY, rotationZ, smokeSize, smokeColor, smokeAlpha, velocityX, velocityY, velocityZ)
                    end
                end
            end
        end
    end
    if #smokeParticles > 0 then
        local screenMidX, screenMidY = screenX / 2, screenY / 2
        local worldX1, worldY1, worldZ1 = getWorldFromScreenPosition(screenMidX, 0, 128)
        local worldX2, worldY2, worldZ2 = getWorldFromScreenPosition(screenMidX, screenMidY, 128)
        
        local dirX, dirY, dirZ = worldX2 - worldX1, worldY2 - worldY1, worldZ2 - worldZ1
        local length = math.sqrt(dirX^2 + dirY^2 + dirZ^2) * 2
        
        dirX, dirY, dirZ = dirX / length, dirY / length, dirZ / length
        
        for i = #smokeParticles, 1, -1 do
            local particle = smokeParticles[i]
            if particle then
                local deltaFactor = delta / 1000
                
                particle[1] = particle[1] + particle[4] * deltaFactor
                particle[2] = particle[2] + particle[5] * deltaFactor
                particle[3] = particle[3] + particle[6] * deltaFactor
                
                local progress = math.min((tick - particle[7]) / 50, 1)
                
                if tick - particle[7] > particle[8] then
                    progress = 1 - (tick - (particle[7] + particle[8])) / 600
                    
                    if progress < 0 then
                        table.remove(smokeParticles, i)
                        progress = 0
                    end
                end
                
                particle[13] = particle[13] + particle[14] * deltaFactor
                dxDrawMaterialLine3D(particle[1] + dirX * particle[13], particle[2] + dirY * particle[13], particle[3] + dirZ * particle[13], particle[1] - dirX * particle[13], particle[2] - dirY * particle[13], particle[3] - dirZ * particle[13], collisionSmoke, particle[13], tocolor(particle[9], particle[10], particle[11], particle[12] * progress))
            end
        end
    end
end)

function spawnParticle(x, y, z, dx, dy, dz, life, r, g, b, a, size, sizePlus)
    table.insert(smokeParticles, {
        x,
        y,
        z,
        dx,
        dy,
        dz,
        getTickCount(),
        life,
        r,
        g,
        b,
        a,
        size,
        sizePlus
    })
end

function makeMatrix(rx, ry, rz)
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local m = {}
    m[1] = {}
    m[1][1] = math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry)
    m[1][2] = math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry)
    m[1][3] = -math.cos(rx) * math.sin(ry)
    m[1][4] = 1
    m[2] = {}
    m[2][1] = -math.cos(rx) * math.sin(rz)
    m[2][2] = math.cos(rz) * math.cos(rx)
    m[2][3] = math.sin(rx)
    m[2][4] = 1
    m[3] = {}
    m[3][1] = math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx)
    m[3][2] = math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx)
    m[3][3] = math.cos(rx) * math.cos(ry)
    m[3][4] = 1
    return m
end

function spawnFume(vx, vy, vz, fx, fy, fz, rx, ry, rz, size, c, a, velx, vely, velz)
    local m = makeMatrix(rx, ry, rz)
    local fox = fx * m[1][1] + fy * m[2][1] + fz * m[3][1] + vx
    local foy = fx * m[1][2] + fy * m[2][2] + fz * m[3][2] + vy
    local foz = fx * m[1][3] + fy * m[2][3] + fz * m[3][3] + vz
    local offX, offY, offZ = math.random(-35, 35) / 100, -0.8 - math.random(50) / 100, math.random(40) / 100
    local ox = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1]
    local oy = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2]
    local oz = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3]
    spawnParticle(fox, foy, foz, ox + velx, oy + vely, oz + velz, math.random(2500, 3500) * size, c, c, c, math.random(200, 230) * size * a, math.random(30, 35) / 100, math.random(70, 90) / 100 * size)
end

function getVehicleSpeed(currentElement)
    if isElement(currentElement) then
        local x, y, z = getElementVelocity(currentElement)
        return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
    end
end