defaultSettings = {
	characterId = "char.ID",
	vehicleId = "vehicle.dbID",
	objectId = "object.dbID",
	slotLimit = 50,
	width = 10,
	weightLimit = {
		player = 20,
		vehicle = 100,
		object = 60,
	},
	
	slotBoxWidth = 36,
	slotBoxHeight = 36
}

safeSettings = {
	small = {
		weightLimit = 60,
		slotLimit = 50,
		width = 10,
	},

	mid = {
		weightLimit = 120,
		slotLimit = 80,
		width = 15,
	},

	big = {
		weightLimit = 180,
		slotLimit = 100,
		width = 20,
	},
}

safeSizeNames = {
	[1] = "small",
	[2] = "mid",
	[3] = "big"
}

local weightLimits = {}

function getWeightLimit(elementType, element)
	local elementModel = getElementModel(element)
	local returnValue = false
	
	if elementType == "object" and (elementModel == 2332 or elementModel == 11424 or elementModel == 9249) then
		local safeSize = getElementData(element, "safeSize") or 1
		local safeSizeName = false

		if safeSize then
			local safeSizeName = safeSizeNames[safeSize] or "small"

			if safeSizeName then
				returnValue = safeSettings[safeSizeName].weightLimit
			end
		end
	else
		returnValue = weightLimits[elementModel] or defaultSettings.weightLimit[elementType]
	end

	return returnValue
end

local trashModels = {
	[1574] = true,
	[1359] = true,
	[1439] = true,
	[1372] = true,
	[1334] = true,
	[1330] = true,
	[1331] = true,
	[1339] = true,
	[1343] = true,
	[1227] = true,
	[1329] = true,
	[1328] = true,
	[2770] = true,
	[1358] = true,
	[1415] = true,
	[3035] = true
}

function isTrashModel(model)
	return trashModels[model]
end

taxiPos = {
	[445] = {-0.4,0.08, 0.78, 0, 0, 0}, -- M5
	[567] = {-0.4,0.08, 0.78, 0, 0, 0}, -- M5
	[467] = {-0.4,0.08, 0.78, 0, 0, 0}, -- M5
	[426] = {-0.5,0.08, 0.79, 0, 0, 0}, -- M5
	[540] = {-0.4,0.08, 0.98, 0, 0, 0}, -- M5
	[558] = {-0.48, 0.15, 0.89, -5, -3, 0}, -- BMW M4
	[602] = {-0.4,0.08, 0.88, -5, 0, 0}, -- m4
	[580] = {-0.45, 0.3, 0.58, -4, -3, 0}, -- rs4
	[507] = {-0.45,0.02, 0.80, 0, 0, 0}, -- e500
	[400] = {-0.45,0.02, 1.27, 0, 0, 0}, -- SRT8 landstalker
	[458] = {-0.45,-0.22, 0.95, 0, 0, 0}, -- e500
	[550] = {-0.52,0.02, 0.64, 0, 0, 0}, -- e420
	[585] = {-0.45,0.02, 0.95, 0, 0, 0}, -- crown vic
	[421] = {-0.58,0.27, 0.65, -13, 0, 0}, -- 760
	[438] = {-0.40,0.12, 0.80, 0, 0, 0}, -- 438 e39
	[551] = {-0.6,0.25, 1.03, -10, 0, 0}, -- 750 e38
	[566] = {-0.5,0.25, 0.78, -12, 0, 0}, -- 750 e38
	[560] = {-0.5,0.25, 1.08, -12, 0, 0}, -- 750 e38
	[579] = {-0.65,0.39, 1.01, -10, 0, 0}, -- 750 e38
	[541] = {-0.5,0.15, 0.73, -12, 0, 0}, -- 750 e38
	[546] = {-0.65,0.12, 1.38, -2, -4, 0}, -- 750 e38
	[482] = {-0.65,0.72, 0.95, 0, 0, 0}, -- 750 e38
	[529] = {-0.51,0.03, 0.78, -5, -5, 0}, -- 750 e38
	[604] = {-0.51,0.03, 0.78, -5, -5, 0}, -- 750 e38
	[492] = {-0.52, 0.35, 0.73, -3, -3, 0}, -- e420
	[409] = {-0.52, 1.97, 1.038, -3, -3, 0}, -- e420
	[525] = {-0.52, 0.65, 1.168, -0, -3, 0}, -- e420
	[598] = {-0.51,0.2, 0.63, -13, -5, 0}, -- valami BMW.
	[466] = {-0.5,0.08, 0.83, -11, -5, 0}, -- Dodge Demon SRT.
}

sirenPos = {
	[445] = {-0.45,0.11, 0.68, 0.1, 0.0, 0.0}, -- BMW M5 e60.
	[467] = {-0.45,0.11, 1.01, 0.0, 0.0, 0.0}, -- a4 allroad
	[426] = {-0.5,0.08, 0.83, 0, 0, 0}, -- e90
	[540] = {-0.45,0.22, 0.88, 0, 0, 0}, -- Subaru Impreza WRX STI.
	[580] = {-0.5,0.15, 0.73, 0, 0, 0}, -- cls brabus
	[507] = {-0.45,0.02, 0.68, 0, 0, 0}, -- f90
	[400] = {-0.58,0.25, 1.1, -5, -3, 0}, -- g65
	[458] = {-0.56, 0.35, 0.81, -11, -3, 0}, -- Volkswagen Passat B6.
	[550] = {-0.52,0.25, 0.80, -10, -4, 0}, -- brabus e63
	[421] = {-0.58,0.4, 0.77, -13, -9, 0}, -- rs6c6
	[551] = {-0.45,0.20, 1.1, -12, -3, 0}, -- g60
	[566] = {-0.5,0.09, 0.61, -12, -4, 0}, -- gt63cls
	[547] = {-0.5,0.09, 0.61, -12, -4, 0}, -- m5cs

	--[560] = {-0.54,0.38, 1.01, -14, -3, 0}, -- Mitsubishi Lancer Evolution X.

	[579] = {-0.55,-0.05, 1.18, 0, 0, 0}, -- Range Rover Sport SC.
	[541] = {-0.5,0.15, 0.69, -12.1, 0, 0}, -- Chevrolet Camaro ZL1.
	[405] = {-0.56,0.25, 0.99, -12, -3, 0}, -- Audi A8 D4.
	[466] = {-0.5,0.08, 0.79, -11, -5, 0}, -- Dodge Demon SRT.
	[517] = {-0.5, 0, 0.75, -11, -5, 0}, -- BMW M6.
	[489] = {-0.5, 0.3, 0.9, -11, -5, 0}, -- BMW M6.
}