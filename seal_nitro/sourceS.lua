local handlingFlags = {
    _1G_BOOST = 1,
    _2G_BOOST = 2,
    NPC_ANTI_ROLL = 4,
    NPC_NEUTRAL_HANDL = 8,
    NO_HANDBRAKE = 16,
    STEER_REARWHEELS = 32,
    HB_REARWHEEL_STEER = 64,
    ALT_STEER_OPT = 128,
    WHEEL_F_NARROW2 = 256,
    WHEEL_F_NARROW = 512,
    WHEEL_F_WIDE = 1024,
    WHEEL_F_WIDE2 = 2048,
    WHEEL_R_NARROW2 = 4096,
    WHEEL_R_NARROW = 8192,
    WHEEL_R_WIDE = 16384,
    WHEEL_R_WIDE2 = 32768,
    HYDRAULIC_GEOM = 65536,
    HYDRAULIC_INST = 131072,
    HYDRAULIC_NONE = 262144,
    NOS_INST = 524288,
    OFFROAD_ABILITY = 1048576,
    OFFROAD_ABILITY2 = 2097152,
    HALOGEN_LIGHTS = 4194304,
    PROC_REARWHEEL_1ST = 8388608,
    USE_MAXSP_LIMIT = 16777216,
    LOW_RIDER = 33554432,
    STREET_RACER = 67108864,
    SWINGING_CHASSIS = 268435456
}

function isFlagSet(val, flag)
	return (bitAnd(val, flag) == flag)
end

function getVehicleHandlingFlags(vehicle)
	local flagBytes = getVehicleHandling(vehicle).handlingFlags
	local flagKeyed = {}

	for k, v in pairs(handlingFlags) do
		if isFlagSet(flagBytes, v) then
			flagKeyed[k] = true
		end
	end

	return flagKeyed, flagBytes
end

function setVehicleHandlingFlag(vehicle, flag, set)
	local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
	local originalBytes = flagBytes

	for k in pairs(flagsKeyed) do
		if string.find(k, flag) then
			flagBytes = flagBytes - handlingFlags[k]
		end
	end

	if set then
		flagBytes = flagBytes + handlingFlags[flag]
	end
  
	if originalBytes ~= flagBytes then
		setVehicleHandling(vehicle, "handlingFlags", flagBytes)
	end
end

local handlingRestore = {}
addEvent("nitroEffect", true)
addEventHandler("nitroEffect", getRootElement(), function(state)
    if getPedOccupiedVehicle(client) == source then
        triggerClientEvent("nitroEffect", source, state)
        if state then
            if handlingRestore[source] then
                for k, v in pairs(handlingRestore[source]) do
                    setVehicleHandling(source, k, v)
                end

                handlingRestore[source] = nil
            end

            handlingRestore[source] = {
                dragCoeff = getVehicleHandling(source).dragCoeff,
                engineAcceleration = getVehicleHandling(source).engineAcceleration
            }

            setVehicleHandling(source, "engineAcceleration", getVehicleHandling(source).engineAcceleration + 5)
            setVehicleHandling(source, "dragCoeff", 0)
        else
            if handlingRestore[source] then
                for k, v in pairs(handlingRestore[source]) do
                    setVehicleHandling(source, k, v)
                end

                handlingRestore[source] = nil
            end
        end
    end
end)