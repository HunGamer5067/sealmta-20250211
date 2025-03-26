--[[local objects = {}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local obj = createObject(8888, 1853.9868164062, -1385.9820556641, 13.390625 - 0.9)
        table.insert(objects, obj)
        local obj = createObject(8888, 1845.9868164062, -1385.9820556641, 13.390625 - 0.9)
        table.insert(objects, obj)
        local obj = createObject(8888, 1553.0380859375, -1160.8344726562, 23.90625 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1183.6693115234, -1140.2529296875, 23.65625 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1183.6693115234, -1149.5529296875, 23.65625 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 2524.9108886719, -1047.7281494141, 69.4140625 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 2176.2829589844, -1006.966784668, 62.792251586914 - 0.9, 0, 0, 80)
        table.insert(objects, obj)
        local obj = createObject(8888, 2109.6494140625, -1106.3946533203, 25.073152542114 - 0.9, 0, 0, 72)
        table.insert(objects, obj)
        local obj = createObject(8888, 2081.6923828125, -1883.5129394531, 13.376214981079 - 1.02, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 2642.7319335938, -1077.7265625, 69.445907592773 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 2487.6896972656, -1732.2783203125, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1018.158203125, -1572.28125, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1866.8836669922, -1089.1840820312, 23.66014289856 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1203.0155029297, -1852.2646484375, 13.389078140259 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 785.41296386719, -899.35021972656, 56.457443237305 - 0.9, 0, 0, 145)
        table.insert(objects, obj)
        local obj = createObject(8888, 1961.615234375, -2074.560546875, 13.3828125 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1961.6885986328, -1798.775390625, 13.3828125 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1886.9300537109, -1752.3139648438, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 2175.6293945312, -1158.4095458984, 24.667110443115 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1821.6756591797, -1659.2889404297, 13.3828125 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1821.6964111328, -1843.9957275391, 13.4140625 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1625.2119140625, -1732.3565673828, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1515.5706787109, -1732.2344970703, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1442.6247558594, -1732.2836914062, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1429.5422363281, -1676.5919189453, 13.3828125 - 0.9, 0, 0, 0)
        table.insert(objects, obj)
        local obj = createObject(8888, 1722.6131591797, -1732.2954101562, 13.393310546875 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1629.3273925781, -1592.3132324219, 13.535793304443 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 1488.1867675781, -1592.2894287109, 13.3828125 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
        local obj = createObject(8888, 678.60406494141, -1319.5528564453, 13.521600723267 - 0.9, 0, 0, 90)
        table.insert(objects, obj)
    end
)

function getElementSpeed(element)
	if isElement(element) then
		local vx, vy, vz = getElementVelocity(element)
		return math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5
	end
end

local col = true
addEventHandler("onClientPreRender", getRootElement(), function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        local speed = getElementSpeed(veh)

        if speed <= 30 and col then
            for i = 1, #objects do
                setElementCollisionsEnabled(objects[i], false)
            end
            col = false
        elseif speed > 30 and not col then
            for i = 1, #objects do
                setElementCollisionsEnabled(objects[i], true)
            end
            col = true
        end 
    end
end)]]

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getPlayerSerial() == "C2B0917DC563370C91078DDE8C7F3DB4" then
        local n = 0
        for i = 400, 611 do
            local veh = createVehicle(i, 1400.3059082031 + 5 * n, -2607.7822265625, 13.546875)
            if getVehicleType(veh) == "Automobile" then
                n = n + 1
                setVehiclePlateText(veh, i)
            else
                destroyElement(veh)
            end
        end
    end
end)