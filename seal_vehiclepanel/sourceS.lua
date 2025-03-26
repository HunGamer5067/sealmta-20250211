addEvent("playTurboSound", true)
addEventHandler("playTurboSound", getRootElement(),
	function (vehicle, turboLevel, players)
		if isElement(vehicle) and turboLevel and #players > 0 and #players ~= getElementsByType("player") and client and client == source and isElement(vehicle) and getPedOccupiedVehicle(source) == vehicle then
			triggerClientEvent(players, "playTurboSound", vehicle, turboLevel)
		end
	end)

addEvent("doVehicleDoorInteract", true)
addEventHandler("doVehicleDoorInteract", getRootElement(),
	function (vehicle, door, doorname)
		if isElement(source) and door and client and client == source then
			local doorRatio = getVehicleDoorOpenRatio(vehicle, door)

			if doorRatio <= 0 then
				setVehicleDoorOpenRatio(vehicle, door, 1, 500)

				triggerClientEvent(getElementsByType("player"), "playDoorEffect", source, vehicle, "open")

				--exports.seal_chat:localAction(source, "kinyitja a " .. doorname .. "t.")
			elseif doorRatio > 0 then
				setVehicleDoorOpenRatio(vehicle, door, 0, 250)

				setTimer(triggerClientEvent, 250, 1, getElementsByType("player"), "playDoorEffect", source, vehicle, "close")
				
				--exports.seal_chat:localAction(source, "becsukja a " .. doorname .. "t.")
			end

			setPedAnimation(source, "ped", "CAR_open_LHS", 300, false, false, true, false)
		end
	end)

addEvent("toggleHandBrake", true)
addEventHandler("toggleHandBrake", getRootElement(),
	function (state, normalmode)
		if isElement(source) and client and getPedOccupiedVehicle(client) == source then

			if getElementData(source, "vehicle.Frozen") then
				return
			end

			if state then


				if not normalmode then
					setElementFrozen(source, true)
				end

				setElementData(source, "vehicle.handBrake", true)
			else
				setElementFrozen(source, false)
				setElementData(source, "vehicle.handBrake", false)
			end
		end
	end)

addEvent("toggleLights", true)
addEventHandler("toggleLights", getRootElement(),
	function (vehicle)
		if isElement(vehicle) and client and client == source and isElement(vehicle) and getPedOccupiedVehicle(source) == vehicle then
			local theTrailer = getVehicleTowedByVehicle(vehicle)
			if (getElementData(vehicle, "vehicle.lights") or 0) == 1 then
				setVehicleOverrideLights(vehicle, 1)
				if isElement(theTrailer) then
					setVehicleOverrideLights(theTrailer, 1)
				end
				setElementData(vehicle, "vehicle.lights", 0)
				exports.seal_chat:localAction(source, "lekapcsolta a jármű lámpáit.")
				triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlightoff.mp3")

				if getElementData(vehicle, "vehicle.customVehicleEngine") then
					playAdditionalSound(vehicle, "turnOffLights")
				else
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlightoff.mp3")
				end
			else
				setVehicleOverrideLights(vehicle, 2)
				if isElement(theTrailer) then
					setVehicleOverrideLights(theTrailer, 2)
				end
				setElementData(vehicle, "vehicle.lights", 1)
				exports.seal_chat:localAction(source, "felkapcsolta a jármű lámpáit.")
				triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlighton.mp3")

				if getElementData(vehicle, "vehicle.customVehicleEngine") then
					playAdditionalSound(vehicle, "turnOnLights")
				else
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/headlightoff.mp3")
				end
			end
		end
	end)

addEvent("sitInVehicleGrabbedPlayer", true)
addEventHandler("sitInVehicleGrabbedPlayer", getRootElement(),
	function(vehicleElement, seat)
		if isElement(vehicleElement) and client and client == source then
			local seat = tonumber(seat)
			local grabbedPlayer = getElementData(client, "grabbedPlayer")
			if not getVehicleOccupants(vehicleElement)[seat] then
				setElementData(grabbedPlayer, "cuffAnimation", false)
				warpPedIntoVehicle(grabbedPlayer, vehicleElement, seat - 2)
				removeElementData(grabbedPlayer, "visz")
				removeElementData(client, "grabbedPlayer")

				exports.seal_chat:localAction(client, "besegít egy embert a járműbe.")
			end
		end
	end
)

addEvent("toggleLock", true)
addEventHandler("toggleLock", getRootElement(),
	function (vehicle, nearby)
		if isElement(vehicle) and client and client == source then
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or 0
			local adminDuty = getElementData(source, "adminDuty") or 0

			if vehicleId > 0 then
				if adminDuty == 0 then
					if not exports.seal_items:hasItemWithData(source, 1, vehicleId) then
						exports.seal_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			else
				if adminDuty == 0 then
					local jobSpawner = getElementData(vehicle, "jobSpawner")

					if jobSpawner ~= getElementData(source, "playerID") then
						exports.seal_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			end

			local vehicleModel = getElementModel(vehicle)

			if isVehicleLocked(vehicle) then
				setElementData(vehicle, "vehicle.locked", 0)
				setVehicleLocked(vehicle, false)

				if isPedInVehicle(source) then
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/unlockinside.mp3")
				else
					triggerClientEvent(nearby, "onVehicleLockEffect", vehicle)
					triggerClientEvent(nearby, "syncVehicleSound", vehicle, "3d", "files/unlockoutside.mp3")

					if getElementData(vehicle, "vehicle.customVehicleEngine") then
						playAdditionalSound(vehicle, "unlockDoors")
					else
						triggerClientEvent(nearby, "syncVehicleSound", vehicle, "3d", "files/unlockoutside.mp3")
					end
				end
			else
				setElementData(vehicle, "vehicle.locked", 1)
				setVehicleLocked(vehicle, true)

				if isPedInVehicle(source) then
					triggerClientEvent(getVehicleOccupants(vehicle), "syncVehicleSound", vehicle, true, "files/lockinside.mp3")
				else
					triggerClientEvent(nearby, "onVehicleLockEffect", vehicle)

					if getElementData(vehicle, "vehicle.customVehicleEngine") then
						playAdditionalSound(vehicle, "lockDoors")
					else
						triggerClientEvent(nearby, "syncVehicleSound", vehicle, "3d", "files/lockoutside.mp3")
					end
				end
			end

			if not isVehicleLocked(vehicle) then
				exports.seal_chat:localAction(source, "kinyitotta egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicle) .. " ajtaját.")
			else
				exports.seal_chat:localAction(source, "bezárta egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicle) .. " ajtaját.")
			end

			exports.seal_logs:logVehicle(source, vehicle, eventName, {
				"locked: " .. tostring(isVehicleLocked(vehicle)),
				"adminDuty: " .. tostring(adminDuty)
			})
		end
	end)

addEvent("syncVehicleSound", true)
addEventHandler("syncVehicleSound", getRootElement(),
	function (path, nearby, typ)
		if isElement(source) and client and getPedOccupiedVehicle(client) == source then
			if path then
				triggerClientEvent(nearby, "syncVehicleSound", source, typ or "3d", path)
			end
		end
	end)

addEvent("toggleEngine", true)
addEventHandler("toggleEngine", getRootElement(),
	function (vehicle, toggle)
		if isElement(vehicle) and isElement(source) and client and getPedOccupiedVehicle(source) == vehicle then
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or 0
			local adminDuty = getElementData(source, "adminDuty") or 0

			if vehicleId > 0 then
				if adminDuty == 0 then
					if not exports.seal_items:hasItemWithData(source, 1, vehicleId) then
						exports.seal_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			else
				if adminDuty == 0 then
					local jobSpawner = getElementData(vehicle, "jobSpawner")

					if jobSpawner ~= getElementData(source, "playerID") then
						exports.seal_hud:showInfobox(source, "e", "Ehhez a járműhöz nincs kulcsod!")
						return
					end
				end
			end

			local vehicleModel = getElementModel(vehicle)

			if toggle then
				if isElement(getElementData(vehicle, "pumpIn")) then
					exports.seal_hud:showInfobox(source, "e", "A járműt nem indíthatod el tankolás közben.")
					return
				end

				if getElementHealth(vehicle) <= 320 then
					exports.seal_hud:showInfobox(source, "e", "A jármű motorja túlságosan sérült.")
					exports.seal_chat:localAction(source, "megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
					return
				end

				if (getElementData(vehicle, "vehicle.fuel") or 50) <= 0 then
					exports.seal_hud:showInfobox(source, "e", "Nincs elég üzemanyag a járműben.")
					exports.seal_chat:localAction(source, "megpróbálja beindítani a jármű motorját, de nem sikerül neki.")
					return
				end

				exports.seal_chat:localAction(source, "beindítja egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicle) .. " motorját.")
			else
				exports.seal_chat:localAction(source, "leállítja egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicle) .. " motorját.")
			end
			
			setVehicleEngineState(vehicle, toggle)
			setElementData(vehicle, "vehicle.engine", toggle and 1 or 0)
		end
	end)

addEventHandler("onVehicleEnter", getRootElement(),
	function ()
		local vehicleType = getVehicleType(source)

		if vehicleType ~= "BMX" then
			setVehicleEngineState(source, getElementData(source, "vehicle.engine") == 1)
			setVehicleDamageProof(source, false) 
		end

		if vehicleType == "BMX" or vehicleType == "Bike" or vehicleType == "Boat" then
			setElementData(source, "vehicle.windowState", true)
		end
	end)

addCommandHandler("kiszed",
	function (sourcePlayer, commandName, targetPlayer)
		if not targetPlayer then
			outputChatBox("#4adfbf[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 255, 255, true)
		else
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				if targetPlayer ~= sourcePlayer then
					local playerX, playerY, playerZ = getElementPosition(sourcePlayer)
					local targetX, targetY, targetZ = getElementPosition(targetPlayer)

					if getDistanceBetweenPoints3D(playerX, playerY, playerZ, targetX, targetY, targetZ) < 5 then
						if getElementInterior(sourcePlayer) == getElementInterior(targetPlayer) and getElementDimension(sourcePlayer) == getElementDimension(targetPlayer) then
							if isPedInVehicle(targetPlayer) then
								local targetVehicle = getPedOccupiedVehicle(targetPlayer)

								if (getElementData(targetVehicle, "vehicle.locked") or 0) == 0 then
									if not getElementData(targetPlayer, "player.seatBelt") then
										removePedFromVehicle(targetPlayer)
										setElementPosition(targetPlayer, playerX, playerY, playerZ)
										exports.seal_chat:localAction(sourcePlayer, "kirángatott valakit egy járműből.")
									else
										exports.seal_core:showMessageToPlayer(false, "A kiválasztott játékosnak be van csatolva az öve.", "error", sourcePlayer)
									end
								else
									exports.seal_core:showMessageToPlayer(false, "A jármű be van zárva.", "error", sourcePlayer)
								end
							else
								exports.seal_core:showMessageToPlayer(false, "A kiválasztott játékos nem ül járműben.", "error", sourcePlayer)
							end
						else
							exports.seal_core:showMessageToPlayer(false, "A kiválasztott játékos túl messze van tőled.", "error", sourcePlayer)
						end
					else
						exports.seal_core:showMessageToPlayer(false, "A kiválasztott játékos túl messze van tőled.", "error", sourcePlayer)
					end
				else
					exports.seal_core:showMessageToPlayer(false, "Magadat nem tudod kirángatni.", "error", sourcePlayer)
				end
			end
		end
	end)

addEventHandler("onVehicleStartEnter", getRootElement(),
	function (occupant, seat, jacked)
		if isElement(jacked) then
			cancelEvent()
			outputChatBox("#d75959[SealMTA]: #ffffffEz NonRP-s kocsilopás. Használd a #d75959/kiszed #ffffffparancsot!", occupant, 0, 0, 0, true)
		end
	end)

function getVehicleSpeed(vehicle)
	if isElement(vehicle) then
		local vx, vy, vz = getElementVelocity(vehicle)
		return (vx*vx + vy*vy + vz*vz) ^ 0.5 * 187.5
	end
	return 9999
end

addEventHandler("onVehicleStartExit", getRootElement(),
	function (player)
		local vehicleType = getVehicleType(source)

		if vehicleType ~= "Bike" and vehicleType ~= "BMX" and vehicleType ~= "Boat" then
			local speed = getVehicleSpeed(source)
			if speed > 10 then
				cancelEvent()
			end

			if isVehicleLocked(source) then
				cancelEvent()
				exports.seal_hud:showInfobox(player, "e", "A jármű be van zárva!")
			elseif getElementData(player, "cuffed") then
				cancelEvent()
			end
		end
	end)

addEvent("toggleEletricEngine", true)
addEventHandler("toggleEletricEngine", getRootElement(), function(vehicleElement)
    if client == source then
        if vehicleElement == getPedOccupiedVehicle(client) then
            local vehicleID = getElementData(vehicleElement, "vehicle.dbID") or false
            local adminLevel = getElementData(client, "adminDuty") or 0
            local adminDuty = getElementData(client, "adminDuty") or 0
            local hasPermission = false
    
            if adminLevel >= 7 then
                hasPermission = true
            elseif adminDuty == 1 then
                hasPermission = true
            elseif vehicleID and exports.seal_items:hasItemWithData(client, 1, vehicleID) then
                hasPermission = true
            else
                local characterId = getElementData(client, "char.ID")
				local playerID = getElementData(client, "playerID")
                local jobSpawner = getElementData(vehicleElement, "jobSpawner")
                local rentCar = getElementData(vehicleElement, "rentedPlayerId")

                if playerID == jobSpawner then
                    hasPermission = true
                elseif characterId == rentCar then
                    hasPermission = true
                end
            end
    
            if hasPermission then
                local chargeState = getElementData(vehicleElement, "vehicle.onCharging") or false
                local fuelLevel = getElementData(vehicleElement, "vehicle.fuel") or 50
                local engineState = getVehicleEngineState(vehicleElement)
                local vehicleHealth = getElementHealth(vehicleElement)

                if vehicleHealth <= 320 then
                    exports.seal_hud:showInfobox(client, "e", "A jármű villanymotorja túlságosan sérült.")
                    exports.seal_chat:localAction(client, "megpróbálja beindítani a járműve motorját, de nem sikerül neki.")
                    return
                end
    
                if fuelLevel <= 0 then
                    exports.seal_hud:showInfobox(client, "e", "A jármű akkumulátorja levan merülve!")
                    exports.seal_chat:localAction(client, "megpróbálja beindítani a járműve motorját, de nem sikerül neki.")
                    return
                end
    
                if chargeState then
                    exports.seal_hud:showInfobox(client, "e", "Jármű töltés alatt nem indíthatod be a járművet!")
                    return
                end

                if engineState then
					setVehicleEngineState(vehicleElement, false)
					setElementData(vehicleElement, "vehicle.engine", 0)
					triggerClientEvent("syncVehicleSound", vehicleElement, "3d", "files/eloff.mp3")
					exports.seal_chat:localAction(client, "leállítja egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicleElement) .. " motorját.")
				else
					setVehicleEngineState(vehicleElement, true)
					setElementData(vehicleElement, "vehicle.engine", 1)
					triggerClientEvent("syncVehicleSound", vehicleElement, "3d", "files/elon.mp3")
					exports.seal_chat:localAction(client, "beindítja egy " .. exports.seal_vehiclenames:getCustomVehicleName(vehicleElement) .. " motorját.")
				end
            else
                exports.seal_hud:showInfobox(client, "e", "Ehhez a járműhöz nincs kulcsod!")
            end
        end
    end
end)

local soundPaths = {
    lockDoors = "sounds/doorlock.wav",
    unlockDoors = "sounds/doorlock.wav",
    turnOnLights = "sounds/lightswitch.wav",
    turnOffLights = "sounds/lightswitch.wav"
}

function playAdditionalSound(vehicle, soundType)
    local soundPath = soundPaths[soundType]
    if soundPath then
        triggerClientEvent("onCustomSoundPlay3D", vehicle, soundPath)
    end
end