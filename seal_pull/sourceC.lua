function getVehicleSpeed(vehicle)
	if isElement(vehicle) then
		local vx, vy, vz = getElementVelocity(vehicle)
		return math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5
	end
end

local enabledWeapons = {
    [22] = true,
    [23] = true,
    [24] = true,
    [28] = true,
    [29] = true,
    [32] = true,
    [30] = true,
    [31] = true,
}

bindKey("x", "down",
    function()
        if getPedOccupiedVehicle(localPlayer) then
            local playerWeapon = getPedWeapon(localPlayer)

            if enabledWeapons[playerWeapon] then
                veh = getPedOccupiedVehicle(localPlayer)

                if getVehicleSpeed(veh) > 70 or getVehicleSpeed(veh) < 5 then
                    exports.seal_hud:showInfobox("error", "Pullozni csak 5-70 KM/H között tudsz!")
                    return
                end
            end

            if getPedOccupiedVehicleSeat(localPlayer) == 0 then exports.seal_hud:showInfobox("warning", "Vezetőként nem pullozhatsz!") return end
            if getPedWeapon(localPlayer) == 27 or getPedWeapon(localPlayer) == 34 then return end
            triggerServerEvent("togDriveby", localPlayer, not isPedDoingGangDriveby(localPlayer))
        end
    end
)

addEventHandler("onClientVehicleCollision", root,
    function()
        if source == getPedOccupiedVehicle(localPlayer) and isPedDoingGangDriveby(localPlayer) then
            triggerServerEvent("togDriveby", localPlayer, false)
        end
    end
)

addEventHandler("onClientRender", root,
    function()
        if isPedDoingGangDriveby(localPlayer) then
            if getVehicleSpeed(getPedOccupiedVehicle(localPlayer)) > 70 or getVehicleSpeed(getPedOccupiedVehicle(localPlayer)) < 5 then
                triggerServerEvent("togDriveby", localPlayer, false)
            end
        end
    end
)