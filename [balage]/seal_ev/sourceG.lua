chargingPortRotation = {
    [561] = { 0, 120, 40 }, -- Tesla S Plaid
    [516] = { 0, -90, 0 }, -- BMW I4
    [560] = { 0, 90, 0 }, -- Porsche Taycan
}

chargingPortOffset = {
    [561] = { -1.15, -2.17, 0.145, -80.619665292593, 190 }, -- Tesla S Plaid
    [516] = { 1.18, -1.70, 0.78, -90 }, -- BMW I4
    [560] = { -1.3, 1.054923415184, 0.0734473913908, -90, 180 }, -- Porsche Taycan
}

function getChargingPortOffset(model)
    return chargingPortOffset[model]
end

function getChargingPortRotation(model)
    return chargingPortRotation[model]
end

superchargerList = {
    -- Kaszinó
    { pos = { 1201.8444824219, -1822.4412841797, 12.425382614136, 90 } },
    { pos = { 1201.8444824219, -1825.6520996094, 12.425382614136, 90 } },
    { pos = { 1201.8444824219, -1828.86291504, 12.425382614136, 90 } },

    -- Déli
    { pos = { 1931.8, -1810.9923095703, 12.3828125, 180 } },
    { pos = { 1935.01081543, -1810.9923095703, 12.3828125, 180 } },
    { pos = { 1938.22163086, -1810.9923095703, 12.3828125, 180 } },    
    { pos = { 1941.43244629, -1810.9923095703, 12.3828125, 180 } },   
    
    -- Északi
    { pos = { 1005.2615966797, -892.65423583984, 41.250305175781, 96.841537475586 } },
    { pos = { 1005.7615966797, -896.46984863281, 41.182537078857, 96.841537475586 } },
    { pos = { 1006.2615966797, -900.285461426, 41.182537078857, 96.841537475586 } },

}

for i, charger in ipairs(superchargerList) do
    local angleRad = math.rad(charger.pos[4])
    charger.cos = math.cos(angleRad)
    charger.sin = math.sin(angleRad)
    charger.chargingPrice = 250

    local x, y = charger.pos[1], charger.pos[2]
    local cosA, sinA = charger.cos, charger.sin

    charger.vehicleCol = createColPolygon(
        x, y,
        x + cosA * 1.5, y + sinA * 1.5,
        x - cosA * 1.5, y - sinA * 1.5,
        x - cosA * 1.5 + sinA * 5, y - sinA * 1.5 - cosA * 5,
        x + cosA * 1.5 + sinA * 5, y + sinA * 1.5 - cosA * 5
    )

    setElementDimension(charger.vehicleCol, charger.dimension or 0)
end