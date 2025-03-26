local properties = {
	"mass",
	"turnMass",
	"dragCoeff",
	"centerOfMass",
	"percentSubmerged",
	"tractionMultiplier",
	"tractionLoss",
	"tractionBias",
	"numberOfGears",
	"maxVelocity",
	"engineAcceleration",
	"engineInertia",
	"driveType",
	"engineType",
	"brakeDeceleration",
	"brakeBias",
	"ABS",
	"steeringLock",
	"suspensionForceLevel",
	"suspensionDamping",
	"suspensionHighSpeedDamping",
	"suspensionUpperLimit",
	"suspensionLowerLimit",
	"suspensionFrontRearBias",
	"suspensionAntiDiveMultiplier",
	"seatOffsetDistance",
	"collisionDamageMultiplier",
	"monetary",
	"modelFlags",
	"handlingFlags",
	"headLight",
	"tailLight",
	"animGroup"
}

handlingFlags = {
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

customHandling = {
	
  }

textHandling = {
	--[443] = "PACKER 8000 48273.301 2 0 0 0 90 0.65 0.85 0.35 5 110 2 6 r d 5.7 0.35 false 40 1.5 0.04 0 0.5 -0.01 0.5 0 0.56 0.4 20000 240001 148100 0 1 2",
	[507] = "ELEGANT 2200 5000 1.8 0 0.1 -0.25 75 0.9 0.8 0.51 5 220 14 10 4 p 6 0.55 false 56 1 0.1 0 0.35 -0.15 0.5 0.3 0.2 0.3 35000 40002000 10400000 0 1 0", --pipa
	[445] = "ADMIRAL 1283.333 3851.4 2 0 0 -0.2 75 0.794 1.1 0.51 5 200 14.5 8 4 p 10.389 0.52 false 30 1 0.539 0 0.27 -0.19 0.5 0.55 0.2 0.56 35000 2000 400000 0 1 0", --pipa
	[400] = "LANDSTAL 1322.222 5008.3 2.5 0 0 -0.5 85 0.8 1.1 0.5 5 240 16 20 4 d 7.578 0.6 false 35 2.4 0.287 0 0.28 -0.14 0.5 0.25 0.27 0.23 25000 2000 500002 0 1 0", --pipa
	[405] = "SENTINEL 1244.444 4000 2.2 0 0 -0.2 75 1 0.917 0.5 5 301.255 14 10 4 p 12.222 0.5 false 27 1 0.287 0 0.3 -0.2 0.5 0.3 0.2 0.56 35000 2000 400000 0 1 0", --pipa
	[549] = "TAMPA 1322.222 4166.4 2.5 0 0.15 -0.1 70 0.9 1.039 0.52 5 300 17 8 4 p 9.986 0.52 false 35 0.7 0.287 1 0.3 -0.16 0.5 0.5 0.3 0.52 19000 2000 400004 1 1 1", --pipa
	[466] = "GLENDALE 1244.444 4000 2.5 0 0 0.02 75 0.733 1.027 0.52 5 300 14 15 4 p 7.578 0.55 false 30 0.8 0.251 0 0.35 -0.22 0.5 0.5 0.23 0.4 20000 2000 10800002 1 1 0", --pipa
	[492] = "GREENWOO 1244.444 4000 2.5 0 0 -0.2 70 0.856 0.978 0.52 4 310 14 13 4 p 6.6 0.6 false 30 1.1 0.431 5 0.32 -0.2 0.5 0 0.22 0.54 19000 2000 10000001 0 3 0", --pipa
	[420] = "TAXI 1127.778 4056.4 2.2 0 0.3 -0.25 75 0.978 0.917 0.45 5 255 11 25 4 p 11.122 0.6 false 35 2 0.359 1 0.25 -0.18 0.54 0 0.2 0.51 20000 200000 200000 0 1 0", --pipa
	[546] = "INTRUDER 1800 4350 2 0 0 0 70 0.9 0.978 0.49 5 270 13 15 4 p 6.6 0.6 false 30 1.5 0.323 1 0.32 -0.15 0.54 0 0.26 0.54 19000 0 2 0 3 0", --pipa
	[585] = "EMPEROR 1400 3200 2.2 0 0.2 -0.4 75 0.9 0.978 0.52 5 280 17.5 15 4 p 9.778 0.45 false 32 0.9 0.467 3 0.3 -0.1 0.5 0.3 0.2 0.56 35000 40002000 400000 0 1 0", --pipa
	[506] = "SUPERGT 1088.889 2800 2 0 -0.2 -0.24 70 0.917 1.051 0.48 5 419.931 13 5 4 p 9.778 0.52 false 30 1 0.719 0 0.25 -0.1 0.5 0.3 0.4 0.54 105000 40002004 208000 0 0 1", --pipa
	[479] = "REGINA 1200 3800 2 0 0.2 -0.2 75 0.794 1.039 0.52 5 280 11 25 4 p 6.111 0.6 false 30 1 0.359 0 0.27 -0.15 0.5 0.2 0.24 0.48 18000 2020 1 1 1 0", --pipa
	[604] = "GLENDALE 1244.444 3200 2.5 0 0 -0.22 75 0.9 1.027 0.52 5 300 18.5 13 4 p 7.578 0.55 false 30 1.1 0.2 0.1 0.3 -0.22 0.5 0.5 0.23 0.4 20000 2000 10800002 1 1 0", --pipa
	[579] = "HUNTLEY 1944.444 6000 2.5 0 0 -0.2 80 0.758 1.088 0.5 5 292.126 14 25 4 p 8.556 0.45 false 35 1 0.18 0 0.45 -0.21 0.45 0.3 0.44 0.35 40000 2000 4404 0 1 0", --pipa
	[540] = "VINCENT 1400 3000 2 0 0.3 0 70 0.856 0.978 0.5 5 292.126 12 20 4 p 6.6 0.6 false 30 1 0.323 0 0.32 -0.16 0.56 0 0.26 0.54 19000 0 2 0 3 0", --pipa
	[589] = "CLUB 1088.889 2200 2.8 0 0 -0.3 80 0.917 1.1 0.49 5 350 17 10 4 p 13.444 0.45 false 30 1.9 0.359 0 0.28 -0.12 0.5 0 0.25 0.5 35000 2000 C00000 1 1 0", --pipa
	[458] = "SOLAIR 1555.556 5500 2 0 0 0 75 0.917 0.978 0.52 5 160 8 10 4 p 6.111 0.6 false 30 1.2 0.359 0 0.27 -0.17 0.5 0.2 0.24 0.48 18000 0 0 1 1 0", --pipa
	[467] = "OCEANIC 1477.778 4529.9 2 0 0 0 75 0.819 0.917 0.52 5 310 12 5 4 p 12 0.55 false 30 1 0.359 0 0.35 -0.17 0.5 0.5 0.23 0.45 20000 2000 10800000 2 1 0", --pipa
	[551] = "MERIT 1800 4500 2.2 0 0.2 -0.1 75 0.8 0.8 0.49 5 320 14 10 4 p 9 0.55 false 30 1.1 0.15 0 0.27 -0.08 0.54 0.3 0.2 0.56 35000 40002000 400001 0 1 0", --pipa
	[426] = "PREMIER 1244.444 3921.3 1.8 0 -0.4 -0.2 75 0.917 1.039 0.52 5 330 10 10 4 p 12.222 0.53 false 35 1.3 0.431 0 0.28 -0.12 0.38 0 0.2 0.24 25000 2000 200 0 1 0", --pipa
	[529] = "WILLARD 1400 4350 2 0 0 0 70 0.856 0.978 0.52 4 292.126 9 15 4 p 6.6 0.6 false 30 1.1 0.539 0.2 0.32 -0.14 0.5 0 0.26 0.54 19000 40002000 0 0 3 0", --pipa
	[587] = "EUROS 1088.889 2998.3 2.2 0 0.1 -0.1 75 0.856 0.978 0.5 5 365.158 12 5 4 p 9.778 0.55 false 30 1.2 0.539 0 0.3 -0.1 0.5 0.3 0.25 0.6 35000 40002804 0 1 1 0", --pipa
	[566] = "TAHOMA 1400 4000 2.3 0 -0.3 -0.2 75 0.917 1.039 0.52 5 450 21 10 4 p 8.556 0.5 false 35 1 0.287 0 0.28 -0.2 0.45 0.3 0.25 0.6 35000 2000 12010000 1 1 0", --pipa
	[527] = "CADRONA 933.333 2000 2.2 0 0.15 -0.1 70 0.7 1.051 0.5 4 340 16 5 4 p 9.778 0.6 false 30 1.4 0.431 0 0.3 -0.08 0.5 0 0.26 0.5 9000 2000 2 0 0 0", --pipa
	[580] = "STAFFORD 1711.111 6000 2.5 0 0 -0.2 75 0.794 1.124 0.5 5 380 22 15 4 p 6.111 0.55 false 30 1.4 0.359 0 0.27 -0.22 0.5 0.3 0.2 0.56 35000 2000 400000 0 1 0", --pipa
	[602] = "ALPHA 1166.667 3400 2 0 0.1 -0.2 85 0.856 0.978 0.5 5 387 18 5 4 p 8.556 0.55 false 30 1.2 0.431 0 0.3 -0.15 0.5 0.4 0.25 0.5 35000 0 208000 1 1 0", --pipa
	[550] = "SUNRISE 1244.444 3550 2 0 0.3 0 70 0.856 0.978 0.52 5 385 17 5 4 p 6.6 0.6 false 30 1 0.323 0 0.3 -0.12 0.55 0 0.26 0.54 19000 40002000 1 0 3 0", --pipa
	[598] = "POLICE_VG 1600 4500 2 0 0.3 -0.25 75 0.75 0.85 0.52 5 222.222 11.707 10 4 p 10 0.7 false 35 0.9 0.08 0 0.28 -0.17 0.55 0 0.2 0.24 25000 2000 10200008 0 1 0",
	--uj
	[421] = "WASHING 1850 5000 2.2 0 0 -0.1 75 0.75 0.9 0.52 5 210 17 10 4 p 7.5 0.65 false 30 1 0.2 0 0.27 -0.2 0.5 0.35 0.24 0.6 18000 2000 10400000 1 1 0", --pipa
	[526] = "FORTUNE 1700 4166.4 2 0 -0.1 -0.25 70 0.8 0.84 0.53 4 230 13 10 4 p 8.17 0.52 false 30 1.2 0.15 0 0.3 -0.1 0.5 0.25 0.3 0.52 19000 40222800 4004 1 1 0",
	[596] = "POLICE_LA 1600 4500 2 0 0.3 -0.1 75 0.75 0.85 0.5 5 300 17.5 10 4 p 10 0.53 false 35 1 0.12 0 0.28 -0.12 0.55 0 0.2 0.24 25000 40002000 10200008 0 1 0",
	[416] = "AMBULAN 2600 10202.8 2.5 0 0 -0.1 90 0.75 0.8 0.47 5 210 13 10 4 d 7 0.55 false 35 1 0.07 0 0.4 -0.2 0.5 0 0.58 0.33 10000 4001 4 0 1 13",
	[489] = "RANCHER 2500 7604.2 2.5 0 0 -0.35 80 0.8 0.85 0.54 5 230 16 5 4 p 7 0.45 false 35 0.8 0.08 0 0.45 -0.25 0.45 0.3 0.44 0.35 40000 226020 100004 0 1 0",
	[517] = "MAJESTIC 1400 3267.8 2.2 0 0.1 -0.1 75 0.9 0.8 0.52 5 220 17 10 4 p 7 0.7 false 30 1.3 0.13 0 0.27 -0.15 0.5 0.3 0.2 0.56 35000 402000 10400000 0 1 0",
	[554] = "YOSEMITE 3000 6000 3 0 0.35 0 80 1 0.8 0.4 5 220 26 15 4 p 8.5 0.3 false 50 1 0.3 0 0.24 -0.2 0.5 0.5 0.44 0.3 40000 20200020 504400 0 1 0",
	[505] = "RANCHER 2500 7604.2 2.5 0 0 -0.35 80 0.8 0.85 0.54 5 220 17 5 4 p 7 0.45 false 45 0.8 0.08 0 0.45 -0.25 0.45 0.3 0.44 0.35 40000 4020 100004 0 1 0",
	[545] = "HUSTLER 1700 4000 2.5 0 0 -0.05 75 0.75 0.75 0.54 5 230 19 10 4 p 8 0.5 false 47 0.45 0.1 0.2 0.1 -0.15 0.5 0.5 0.18 0.45 20000 2000 800000 2 1 0",
	[558] = "URANUS 1400 2998.3 2 0 0.1 -0.3 75 0.9 0.85 0.47 5 250 18 5 4 p 8 0.45 false 45 1 0.15 0 0.28 -0.1 0.5 0.3 0.25 0.6 35000 C0000800 4000001 1 1 0",
	[560] = "SULTAN 1400 3400 2.4 0 0.1 -0.1 75 0.8 0.8 0.5 5 220 19 5 4 p 10 0.5 false 30 1.2 0.15 0 0.28 -0.2 0.5 0.3 0.25 0.6 35000 2800 4000002 1 1 0",
	[516] = "NEBULA 1400 4000 2 0 0.3 -0.1 75 0.8 0.8 0.5 5 230 16 10 4 p 8 0.55 false 50 1 0.1 0 0.27 -0.1 0.58 0.3 0.2 0.56 35000 1000 400000 0 1 0",
	[561] = "STRATUM 1793.333 4500 2.1 0 0.1 -0.1 75 0.8 0.853 0.5 5 274.348 17 10 4 p 7.026 0.5 false 30 1 0.151 0 0.28 -0.16 0.5 0.3 0.25 0.6 35000 0 4000200 1 1 0",
	[547] = "PRIMO 1600 3000 2.2 0 0 -0.2 70 0.8 0.8 0.54 5 240 21 7 4 p 5.4 0.6 false 40 0.7 0.14 0 0.32 -0.14 0.5 0 0.26 0.54 19000 2000 0 0 3 0"
}

strawTextHandling = {

  }

for model, text in pairs(textHandling) do
	local words = split(text, " ")
	local propertyId = 0

	customHandling[model] = {}

	for i, value in ipairs(words) do
		if i ~= 1 then
			if i == 5 then
				customHandling[model].centerOfMass = {value}
			elseif i > 5 and i <= 7 then
				table.insert(customHandling[model].centerOfMass, value)

				if i == 7 then
					propertyId = propertyId + 1
				end
			elseif i == 16 then
				propertyId = propertyId + 1

				if value == "r" then
					customHandling[model][properties[propertyId]] = "rwd"
				elseif value == "f" then
					customHandling[model][properties[propertyId]] = "fwd"
				else
					customHandling[model][properties[propertyId]] = "awd"
				end
			elseif i == 17 then
				propertyId = propertyId + 1

				if value == "p" then
					customHandling[model][properties[propertyId]] = "petrol"
				elseif value == "d" then
					customHandling[model][properties[propertyId]] = "diesel"
				else
					customHandling[model][properties[propertyId]] = "electric"
				end
			else
				propertyId = propertyId + 1
				customHandling[model][properties[propertyId]] = value
			end
		end
	end
end

for model, text in pairs(strawTextHandling) do
	if not customHandling[model] then
		local words = split(text, " ")
		local propertyId = 0

		customHandling[model] = {}

		for i, value in ipairs(words) do
			if i ~= 1 then
				if i == 5 then
					customHandling[model].centerOfMass = {value}
				elseif i > 5 and i <= 7 then
					table.insert(customHandling[model].centerOfMass, value)

					if i == 7 then
						propertyId = propertyId + 1
					end
				elseif i == 16 then
					propertyId = propertyId + 1

					if value == "r" then
						customHandling[model][properties[propertyId]] = "rwd"
					elseif value == "f" then
						customHandling[model][properties[propertyId]] = "fwd"
					else
						customHandling[model][properties[propertyId]] = "awd"
					end
				elseif i == 17 then
					propertyId = propertyId + 1

					if value == "p" then
						customHandling[model][properties[propertyId]] = "petrol"
					elseif value == "d" then
						customHandling[model][properties[propertyId]] = "diesel"
					else
						customHandling[model][properties[propertyId]] = "electric"
					end
				else
					propertyId = propertyId + 1
					customHandling[model][properties[propertyId]] = value
				end
			end
		end
	end
end

customFlags = {}
textFlag = {
  [438] = " ; ;DBL_EXHAUST; ",
  [463] = " ; ; ;DBL_EXHAUST",
  [598] = " ; ;DBL_EXHAUST; ",
  [551] = " ; ;DBL_EXHAUST; ",
  [566] = " ; ;DBL_EXHAUST; ",
  [420] = " ; ;AXLE_R_SOLID,; ",
  [600] = " ; ;DBL_EXHAUST; ",
  [410] = "WHEEL_R_WIDE2; ; ; ",
  [436] = " ; ;AXLE_F_SOLID,AXLE_R_SOLID; ",
  [602] = "WHEEL_R_WIDE2; ; ; ",
  [562] = " ; ; ;DBL_EXHAUST",
  [477] = "WHEEL_R_WIDE; ;AXLE_R_SOLID,DBL_EXHAUST; ",
  [470] = "OFFROAD_ABILITY, OFFROAD_ABILITY2; ;IS_BIG; ",
  [475] = "WHEEL_R_WIDE; ;DBL_EXHAUST; ",
  --[438] = " ; ;DBL_EXHAUST; ",
  [412] = " ; ;DBL_EXHAUST; ",
  [545] = " ; ;DBL_EXHAUST; ",
  [559] = " ; ; ;DBL_EXHAUST",
  [486] = " ;STEER_REARWHEELS; ; ",
  [525] = " ; ;AXLE_F_NOTILT; ",
  [494] = " ; ;DBL_EXHAUST; ",
  [480] = " ; ;DBL_EXHAUST; ",
  [597] = "WHEEL_R_WIDE2,WHEEL_F_WIDE2; ;AXLE_F_NOTILT,AXLE_R_NOTILT; ",
  [454] = " ; ; ;SIT_IN_BOAT",
  [495] = " ;HYDRAULIC_GEOM,WHEEL_F_WIDE2,WHEEL_R_WIDE2;DBL_EXHAUST,AXLE_F_NOTILT,AXLE_R_NOTILT; ",
  [405] = " ; ;DBL_EXHAUST; ",
  [580] = " ; ;DBL_EXHAUST; ;AXLE_R_NOTILT;",
  [421] = " ; ;DBL_EXHAUST; ",
  [445] = " ; ;DBL_EXHAUST; ",
  [467] = " ; ;DBL_EXHAUST; ",
  [466] = " ; ;AXLE_R_NOTILT; ",
  [576] = " ; ;DBL_EXHAUST; ",
  [517] = " ; ;DBL_EXHAUST; ",
  [567] = " ; ;DBL_EXHAUST; ",
  [521] = " ; ;DBL_EXHAUST; ",
  [458] = " ; ;DBL_EXHAUST; ",
  [585] = " ; ;DBL_EXHAUST; ",
  [527] = " ; ;DBL_EXHAUST; ",
  [400] = " ; ;DBL_EXHAUST; ",
  [550] = " ; ;DBL_EXHAUST; ",
  [492] = " ; ;DBL_EXHAUST; ",
  [596] = " ; ;DBL_EXHAUST; ",
  [490] = " ; ;DBL_EXHAUST; ",
  [525] = " ; ;DBL_EXHAUST; ",
  [526] = "WHEEL_R_WIDE; ;CONVERTIBLE,AXLE_R_SOLID,AXLE_F_SOLID; ",
  [489] = " ; ;AXLE_R_SOLID,AXLE_F_SOLID,DBL_EXHAUST; ",
  [516] = " ; ;DBL_EXHAUST; ",
  [404] = " ; ;DBL_EXHAUST; ",
  [575] = "WHEEL_R_WIDE2;WHEEL_F_NARROW2,WHEEL_R_NARROW,HYDRAULIC_GEOM,LOW_RIDER;DBL_EXHAUST; ",
  [424] = " ;WHEEL_F_NARROW;DBL_EXHAUST;NO_EXHAUST",
  [503] = "WHEEL_F_NARROW;WHEEL_R_WIDE,WHEEL_F_WIDE;AXLE_R_SOLID,AXLE_F_SOLID,DBL_EXHAUST; ",
  [429] = " ;OFFROAD_ABILITY2; ; ",
  [561] = "WHEEL_F_NARROW; ; ;DBL_EXHAUST,CONVERTIBLE",
  [549] = "HALOGEN_LIGHTS; ;AXLE_R_SOLID,DBL_EXHAUST; ",
  [426] = "WHEEL_F_NARROW;OFFROAD_ABILITY2,SWINGING_CHASSIS,NPC_NEUTRAL_HANDL;DBL_EXHAUST; ",
}

for model, text in pairs(textFlag) do
	local sections = split(text, ";")

	customFlags[model] = {
		addHandling = {},
		removeHandling = {},
		addModel = {},
		removeModel = {}
	}

	for i = 1, 4 do
		local section = sections[i]

		if section and utf8.len(section) > 1 then
			local flags = split(section, ",")

			for k, flag in pairs(flags) do
				flag = flag:gsub(" ", "")

				if utf8.len(flag) > 1 then
					if i == 1 then
						customFlags[model].addHandling[flag] = true
					elseif i == 2 then
						customFlags[model].removeHandling[flag] = true
					elseif i == 3 then
						customFlags[model].addModel[flag] = true
					elseif i == 4 then
						customFlags[model].removeModel[flag] = true
					end
				end
			end
		end
	end
end
modelFlags = {
  IS_VAN = 1,
  IS_BUS = 2,
  IS_LOW = 4,
  IS_BIG = 8,
  REVERSE_BONNET = 16,
  HANGING_BOOT = 32,
  TALIGATE_BOOT = 64,
  NOSWING_BOOT = 128,
  NO_DOORS = 256,
  TANDEM_SEATS = 512,
  SIT_IN_BOAT = 1024,
  CONVERTIBLE = 2048,
  NO_EXHAUST = 4096,
  DBL_EXHAUST = 8192,
  NO1FPS_LOOK_BEHIND = 16384,
  FORCE_DOOR_CHECK = 32768,
  AXLE_F_NOTILT = 65536,
  AXLE_F_SOLID = 131072,
  AXLE_F_MCPHERSON = 262144,
  AXLE_F_REVERSE = 524288,
  AXLE_R_NOTILT = 1048576,
  AXLE_R_SOLID = 2097152,
  AXLE_R_MCPHERSON = 4194304,
  AXLE_R_REVERSE = 8388608,
  IS_BIKE = 16777216,
  IS_HELI = 33554432,
  IS_PLANE = 67108864,
  IS_BOAT = 134217728,
  BOUNCE_PANELS = 268435456,
  DOUBLE_RWHEELS = 536870912,
  FORCE_GROUND_CLEARANCE = 1073741824,
  IS_HATCHBACK = 2147483648
}

local function setVehicleHandlingFlag(vehicle, flag, set)
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

local function setVehicleModelFlag(vehicle, flag, set)
	local flagsKeyed, flagBytes = getVehicleModelFlags(vehicle)
	local originalBytes = flagBytes

	for k in pairs(flagsKeyed) do
		if string.find(k, flag) then
			flagBytes = flagBytes - modelFlags[k]
		end
	end

	if set then
		flagBytes = flagBytes + modelFlags[flag]
	end

	if originalBytes ~= flagBytes then
		setVehicleHandling(vehicle, "modelFlags", flagBytes)
	end
end

function applyHandling(vehicle, exceptions)
	if isElement(vehicle) then
		local model = getElementModel(vehicle)

		if customHandling[model] then
			for property, value in pairs(customHandling[model]) do
				if (exceptions and exceptions[property]) or not exceptions then
					if value == "true" then
						setVehicleHandling(vehicle, property, true)
					elseif value == "false" then
						setVehicleHandling(vehicle, property, false)
					elseif property == "modelFlags" or property == "handlingFlags" then
						setVehicleHandling(vehicle, property, tonumber("0x" .. value))
					else
						setVehicleHandling(vehicle, property, value)
					end
				end
			end
		end

		if customFlags[model] and not exceptions then
			if customFlags[model].removeHandling then
				for flag in pairs(customFlags[model].removeHandling) do
					setVehicleHandlingFlag(vehicle, flag, false)
				end
			end

			if customFlags[model].addHandling then
				for flag in pairs(customFlags[model].addHandling) do
					setVehicleHandlingFlag(vehicle, flag, true)
				end
			end

			if customFlags[model].removeModel then
				for flag in pairs(customFlags[model].removeModel) do
					setVehicleModelFlag(vehicle, flag, false)
				end
			end

			if customFlags[model].addModel then
				for flag in pairs(customFlags[model].addModel) do
					setVehicleModelFlag(vehicle, flag, true)
				end
			end
		end

		local currHandlingFlags = getElementData(vehicle, "vehicle.handlingFlags") or 0
		local currModelFlags = getElementData(vehicle, "vehicle.modelFlags") or 0
		local currDriveType = getElementData(vehicle, "vehicle.tuning.DriveType")
		local currSteeringLock = getElementData(vehicle, "vehicle.tuning.SteeringLock") or 0

		if currHandlingFlags ~= 0 then
			setVehicleHandling(vehicle, "handlingFlags", currHandlingFlags)
		end

		if currModelFlags ~= 0 then
			setVehicleHandling(vehicle, "modelFlags", currModelFlags)
		end

		if currDriveType == "fwd" or currDriveType == "rwd" or currDriveType == "awd" then
			setVehicleHandling(vehicle, "driveType", currDriveType)
		elseif currDriveType == "tog" then
			local activeDriveType = getElementData(vehicle, "activeDriveType") or "awd"

			setVehicleHandling(vehicle, "driveType", activeDriveType)

			if activeDriveType == "awd" then
				setVehicleHandling(vehicle, "maxVelocity", getVehicleHandling(vehicle).maxVelocity * 0.65)
			end
		end

		if currSteeringLock ~= 0 then
			setVehicleHandling(vehicle, "steeringLock", currSteeringLock)
		end
	end
end

function getHandlingTable(model)
	if isElement(model) then
		model = getElementModel(model)
	end

	if customHandling[model] then
		return customHandling[model]
	else
		return getOriginalHandling(model)
	end

	return false
end

function getHandlingProperty(model, property)
	if isElement(model) then
		model = getElementModel(model)
	end

	if customHandling[model] then
		if customHandling[model][property] then
			return customHandling[model][property]
		else
			return getOriginalHandling(model)[property]
		end
	else
		return getOriginalHandling(model)[property]
	end

	return false
end

if triggerServerEvent then
	addCommandHandler("texthandling",
		function(commandName, modelId)
			modelId = tonumber(modelId)
			if customHandling[modelId] then
				for k, v in pairs(customHandling[modelId]) do
					outputChatBox(k .. " = " .. inspect(v) .. ",")
				end
			end
		end
	)
end