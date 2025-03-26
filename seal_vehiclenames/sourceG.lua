local vehicleNames = {
	[445] = "BMW M5 e60",
	[405] = "Mitsubishi Lancer Evo X",
	[400] = "Mercedes Benz G65 AMG",
	[549] = "BMW M8 Competition",
	[466] = "Alfa Romeo Giulia",
	[492] = "BMW 5 series F10",
	[420] = "BMW M5 e34",
	[541] = "Chevrolet Camaro ZL1",
	[546] = "Dodge Demon SRT",
	[506] = "McLaren P1",
	[479] = "Mercedes Benz 190E Evolution II",
	[604] = "Mercedes AMG GT63s",
	[579] = "Range Rover Sport SC",
	[540] = "Subaru Impreza WRX STI",
	[589] = "Volkswagen Golf VII",
	[458] = "Volkswagen Passat B6",
	[467] = "Audi RS4",
	[507] = "BMW M5 F90",
	[585] = "BMW M3 CS",
	[551] = "BMW 5 series G60",
	[426] = "BMW 3 series E90",
	[529] = "Mercedes-Benz 560 SEC AMG",
	[587] = "Ford Mustang",
	[566] = "Brabus Rocket 900 GT63s",
	[527] = "BMW M4 Competition",
	[580] = "Brabus 850	CLS63 S AMG",
	[602] = "Brabus 900 Rocket R 911",
	[550] = "Brabus 850",
	[526] = "Mercedes Benz C63",
	[421] = "Audi RS6 C6",
	[517] = "BMW M6",
	[489] = "BMW X7",
	[582] = "Mercedes Benz Sprinter",
	[554] = "Dodge Ram TRX 2021 [egyedi] ",
	[545] = "Rolls-Royce Wraith Black",
	[505] = "Rolls-Royse Cullinan",
	[560] = "Porsche Taycan",
	[558] = "Peugeot 406 [egyedi]",
	[516] = "BMW i4",
	[561] = "Tesla Model S Plaid",
	[547] = "BMW M5 CS",
	[596] = "BMW 530i",
	[598] = "Skoda Octavia"
}

local manufacturerNames = {
}

function getCustomVehicleName(model)
	if tonumber(model) then
		if vehicleNames[model] then
			return vehicleNames[model]
		else
			return getVehicleNameFromModel(model) or "Invalid modelId"
		end
	elseif isElement(model) then
		local customId = getElementData(model, "vehicle.customId")
		if customId and customId ~= "0" then
			if vehicleNames[customId] then
				return vehicleNames[customId]
			elseif vehicleNames[getElementModel(model)] then
				return vehicleNames[getElementModel(model)]
			else
				return getVehicleNameFromModel(model) or "Invalid modelId"
			end
		else
			if vehicleNames[getElementModel(model)] then
				return vehicleNames[getElementModel(model)]
			else
				return getVehicleNameFromModel(getElementModel(model)) or "Invalid modelId"
			end
		end
	else
		return "Invalid modelId"
	end
end

for k, v in pairs(vehicleNames) do
	if not manufacturerNames[k] then
		manufacturerNames[k] = split(v, " ")[1]
	end
end

function getCustomVehicleManufacturer(model)
	if type(tonumber(model)) == "number" and (model < 400 or model > 611) then
		model = exports.seal_mods_veh:getCustomIdByModel(model)
	end
	if manufacturerNames[model] then
		return manufacturerNames[model]
	end
	return "GTA-SA"
end