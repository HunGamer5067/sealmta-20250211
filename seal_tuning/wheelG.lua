customizableWheels = {
	[1] = {1082, "disk"},
	[2] = {1077, "hamman_editrace"},
	[3] = {1079, "grseal_t57"},
	[4] = {1075, "enkei_nt03"},
	[5] = {1081, "advan_rgii"},
	[6] = {1073, "wed_105"},
	[7] = {1098, "crkai"},
	[8] = {1096, "advan_racingv2"},

}

defaultWheelSize = 0.7
customWheelSize = {
    [445] = 0.76,
    [405] = 0.78,
    [400] = 0.89,
    [549] = 0.75,
    [466] = 0.77,
    [492] = 0.77,
    [420] = 0.77,
    [541] = 0.71,
    [546] = 0.8,
    [506] = 0.74,
    [479] = 0.74,
    [604] = 0.75,
    [579] = 0.84,
    [540] = 0.74,
    [589] = 0.72,
    [458] = 0.77,
    [507] = 0.77,
    [585] = 0.73,
    [551] = 0.75,
    [426] = 0.76,
    [529] = 0.73,
    [587] = 0.79,
    [566] = 0.79,
    [527] = 0.76,
    [526] = 0.74,
    [421] = 0.79,
    [580] = 0.79,
    [602] = 0.83,
    [550] = 0.78,
    [596] = 0.77,
    [598] = 0.72,
    [467] = 0.82,
    [517] = 0.78,
    [489] = 0.97,
    [545] = 0.78,
    [505] = 0.94,
    [561] = 0.81,
    [560] = 0.77,
    [516] = 0.77,
    [547] = 0.73,
}

function getVehicleWheelSize(vehicle)
    if isElement(vehicle) then
        local vehicleModel = getElementModel(vehicle)

        if customWheelSize[vehicleModel] then
            return customWheelSize[vehicleModel]
        else
            return defaultWheelSize
        end
    end
end