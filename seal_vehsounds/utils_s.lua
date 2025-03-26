-- util_s.lua

VEHICLES_TYPES = {
	["Bus"] = {},
	["Truck"] = {},
	["Sport"] = {},
	["Casual"] = {},
	["Muscle"] = {},
	["Plane"] = {},
	["Boat"] = {},
	["Motorbike"] = {},

	["BRABUS 900"] = {580},
	["BMWM5"] = {547},
	["BMWM6"] = {517},
	["BMWB48"] = {585},
	["DEMON"] = {546},
    ["SUBARU"] = {540},
	["AUDI"] = {404},
}

CLASSES = {
    [{0, 200}] = "E",
    [{200, 400}] = "D",
    [{400, 600}] = "C",
    [{600, 800}] = "B",
    [{800, 1000000000}] = "A",
}

function getVehicleMaxVelocity(model)
    local handling = getModelHandling(model)
    if handling then 
        return handling.maxVelocity
    end

    return 0
end 

function getVehicleTypeByModel(model)
    for type, models in pairs(VEHICLES_TYPES) do 
        for _, mdl in pairs(models) do 
            if mdl == model then 
                return type
            end
        end
    end 
    
    return "Casual"
end

function calculateVehicleClass(vehicle)
    local handling = nil
    local v_type = nil
    if type(vehicle) == "number" then 
        handling = getOriginalHandling(vehicle)
        v_type = getVehicleTypeByModel(vehicle)
    else 
        handling = getVehicleHandling(vehicle)
        v_type = getElementData(vehicle, "vehicle:type")
    end
    
    -- engine
    local acc = handling.engineAcceleration 
    local vel = handling.maxVelocity
    local drag = handling.dragCoeff
    local c = (acc / drag / vel)
    if v_type == "Casual" then 
        c = c-0.010
    elseif v_type == "Sport" then 
        c =c-0.005
    elseif v_type == "Muscle" then 
        c = c-0.02
    elseif v_type == "Truck" then 
        c =c+0.01
    end
    
    -- steering
    local turnMass = handling.turnMass 
    local mass = handling.mass 
    local traction = handling.tractionLoss
    c = c - (turnMass/mass/traction)*0.001 
    
    return math.ceil(c*(10^4.54))
end

function getVehicleClass(vehicle)
    local class = calculateVehicleClass(vehicle)
    for required, name in pairs (CLASSES) do 
        if class >= required[1] and class <= required[2] then 
            return name
        end
    end
    
    return "E"
end 

if getModelHandling then
    for name, models in pairs(VEHICLES_TYPES) do 
        table.sort(models, function(a, b)
            return calculateVehicleClass(a) > calculateVehicleClass(b)
        end)    
    end
    
    function getBestVehicleClassByType(type)
        if type then 
            return VEHICLES_TYPES[type][1]
        end
    end     
end 