local deathPeds = {}

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		if deathPeds[source] then
			if isElement(deathPeds[source]) then
				destroyElement(deathPeds[source])
			end

			deathPeds[source] = nil
		end
	end)

addEvent("pickupSpawnBack", true)
addEventHandler("pickupSpawnBack", getRootElement(),
	function ()
		if isElement(source) and client == source then
			if isElement(deathPeds[source]) then
				local x, y, z = getElementPosition(deathPeds[source])

				setElementPosition(source, x, y, z)
				setElementRotation(source, 0, 0, getPedRotation(deathPeds[source]))
				setElementInterior(source, getElementInterior(deathPeds[source]))
				setElementDimension(source, getElementDimension(deathPeds[source]))
				setPedAnimation(source, "ped", "FLOOR_hit_f", -1, false, false, false)

				destroyElement(deathPeds[source])
				deathPeds[source] = nil
			else
				setPedAnimation(source, false)
				setElementHealth(source, 35)
			end
		end
	end)

addEvent("spawnToHospital", true)
addEventHandler("spawnToHospital", getRootElement(),
	function ()
		if isElement(source) and client == source then
			setElementPosition(source, 1178.0213623047, -1323.9495849609, 14.107316970825)
			setElementRotation(source, 0, 0, 270)
			setElementInterior(source, 0)
			setElementDimension(source, 0)

			if isElement(deathPeds[source]) then
				destroyElement(deathPeds[source])
			end

			deathPeds[source] = nil

			setElementHealth(source, 100)
			setElementData(source, "bloodLevel", 100)
			setElementData(source, "lastRespawn", 20)

			removeElementData(source, "bulletDamages")
			removeElementData(source, "triedToHelpUp")

			if getElementData(source, "char.injureLeftFoot") then
				exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
			end

			if getElementData(source, "char.injureRightFoot") then
				exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, true)
			end

			if getElementData(source, "char.injureLeftArm") then
				exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
			end

			if getElementData(source, "char.injureRightArm") then
				exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, true)
			end

			removeElementData(source, "char.injureLeftFoot")
			removeElementData(source, "char.injureRightFoot")
			removeElementData(source, "char.injureLeftArm")
			removeElementData(source, "char.injureRightArm")

			removeElementData(source, "paintOnPlayerTime")
			removeElementData(source, "paintVisibleOnPlayer")
			removeElementData(source, "paintOnPlayerFace")
		end
	end)

addEvent("spawnPlayerInAether", true)
addEventHandler("spawnPlayerInAether", getRootElement(),
	function ()
		if isElement(source) and client == source then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(source)
			local playerRotX, playerRotY, playerRotZ = getElementRotation(source)
			local currentInterior = getElementInterior(source)
			local currentDimension = getElementDimension(source)

			local playerId = getElementData(source, "playerID")
			local headless = isPedHeadless(source)
			local skinId = getElementModel(source)



			spawnPlayer(source, 1413.1413574219, -2970.6918945312, 8298.4296875, 0, skinId, 111, playerId)
			setElementDimension(source, playerId)
			setElementInterior(source, 0)
			setCameraTarget(source, source)

			setElementData(source, "char.Hunger", 100)
			setElementData(source, "char.Thirst", 100)

			local deathPed = createPed(skinId, playerPosX, playerPosY, playerPosZ, playerRotZ)

			if isElement(deathPed) then
				setElementInterior(deathPed, currentInterior)
				setElementDimension(deathPed, currentDimension)
				setElementFrozen(deathPed, true)
				setPedAnimation(deathPed, "ped", "FLOOR_hit_f", -1, false, false, false)
				setElementData(deathPed, "activeAnimation", {"ped", "FLOOR_hit_f", -1, false, false, false})
				setElementData(deathPed, "invulnerable", true)
				setElementData(deathPed, "deathPed", true)
				setPedHeadless(deathPed, headless)

				local visibleName = getElementData(source, "visibleName"):gsub("_", " ")
				local deathReason = getElementData(source, "deathReason") or "ismeretlen"
				local bulletDamages = getElementData(source, "bulletDamages")

				setElementData(deathPed, "deathPed", {source, visibleName, playerId, deathReason, bulletDamages})
				setElementData(deathPed, "visibleName", visibleName)
				setElementCollisionsEnabled(deathPed, false)

				deathPeds[source] = deathPed
			end

			setTimer(function()
				if isElement(deathPeds[source]) then
					destroyElement(deathPeds[source])
					print("disztroy")
				end
			end, 1000 * 60 * 5, 1)

		end
	end)

addEvent("killPlayerAnimTimer", true)
addEventHandler("killPlayerAnimTimer", getRootElement(),
	function ()
		if isElement(source) and client == source then
			setElementData(source, "customDeath", "elvérzett (lejárt anim idő)")
			setElementHealth(source, 0)
			setPedAnimation(source)
		end
	end)

addEvent("bringBackInjureAnim", true)
addEventHandler("bringBackInjureAnim", getRootElement(),
	function (state)
		if isElement(source) and client == source then
			if state then
				setPedAnimation(source)
			elseif isPedInVehicle(source) then
				setPedAnimation(source, "ped", "car_dead_lhs", -1, false, false, false)
			else
				setPedAnimation(source, "sweet", "sweet_injuredloop", -1, false, false, false)
			end
		end
	end)

addCommandHandler("asegit",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			if not targetPlayer then
				outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Játékos Név / ID]", sourcePlayer, 255, 150, 0, true)
			else
				targetPlayer, targetName = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

				if targetPlayer then
					if getElementData(sourcePlayer, "acc.adminLevel") >= 1 and getElementData(sourcePlayer, "acc.adminLevel") < 6 then
						if getElementData(sourcePlayer, "adminDuty") == 0 then
							outputChatBox("#4adfbf[SealMTA]: #ffffffCsak admindutyban használhatod a parancsot.", sourcePlayer, 255, 255, 255, true)
							return
						end
					end
					
					if getElementData(targetPlayer, "isPlayerDeath") then
						local x, y, z = getElementPosition(targetPlayer)
						local int = getElementInterior(targetPlayer)
						local dim = getElementDimension(targetPlayer)
						local skin = getElementModel(targetPlayer)
						local rot = getPedRotation(targetPlayer)

						if isElement(deathPeds[targetPlayer]) then
							x, y, z = getElementPosition(deathPeds[targetPlayer])
							int = getElementInterior(deathPeds[targetPlayer])
							dim = getElementDimension(deathPeds[targetPlayer])
							rot = getPedRotation(deathPeds[targetPlayer])

							destroyElement(deathPeds[targetPlayer])
							deathPeds[targetPlayer] = nil
						end

						removeElementData(targetPlayer, "triedToHelpUp")
						setElementData(targetPlayer, "isPlayerDeath", false)
						setElementData(targetPlayer, "deathState", false)
						spawnPlayer(targetPlayer, x, y, z, rot, skin, int, dim)
						setPedAnimation(targetPlayer)

						setElementData(targetPlayer, "bloodLevel", 100)
					
						removeElementData(targetPlayer, "bulletDamages")
						removeElementData(targetPlayer, "triedToHelpUp")

						if getElementData(targetPlayer, "char.injureLeftFoot") then
							exports.seal_controls:toggleControl(targetPlayer, {"crouch", "sprint", "jump"}, true)
						end
			
						if getElementData(targetPlayer, "char.injureRightFoot") then
							exports.seal_controls:toggleControl(targetPlayer, {"crouch", "sprint", "jump"}, true)
						end
			
						if getElementData(targetPlayer, "char.injureLeftArm") then
							exports.seal_controls:toggleControl(targetPlayer, {"aim_weapon", "fire", "jump"}, true)
						end
			
						if getElementData(targetPlayer, "char.injureRightArm") then
							exports.seal_controls:toggleControl(targetPlayer, {"aim_weapon", "fire", "jump"}, true)
						end
			
						removeElementData(targetPlayer, "char.injureLeftFoot")
						removeElementData(targetPlayer, "char.injureRightFoot")
						removeElementData(targetPlayer, "char.injureLeftArm")
						removeElementData(targetPlayer, "char.injureRightArm")

						local adminName = getElementData(sourcePlayer, "acc.adminNick")
						local adminTitle = exports.seal_administration:getPlayerAdminTitle(sourcePlayer)

						outputChatBox("[SealMTA]: #ffffffSikeresen felsegítetted a kiválasztott játékost. #6094cb(" .. targetName .. ")", sourcePlayer, 94, 193, 230, true)
						outputChatBox("[SealMTA]: #6094cb" .. adminName .. " #fffffffelsegített téged.", targetPlayer, 94, 193, 230, true)

						exports.seal_administration:showAdminLog(adminTitle .. " " .. adminName .. " felsegítette #6094cb" .. targetName .. "#ffffff-t.", 2)
						exports.seal_logs:logCommand(sourcePlayer, commandName, {targetName})
					else
						outputChatBox("[SealMTA]: #ffffffA kiválasztott játékos nincs meghalva.", sourcePlayer, 215, 89, 89, true)
					end
				end
			end
		end
	end)

function healCard(targetPlayer)
	if targetPlayer then
		--if getElementData(targetPlayer, "isPlayerDeath") then
			local x, y, z = getElementPosition(targetPlayer)
			local int = getElementInterior(targetPlayer)
			local dim = getElementDimension(targetPlayer)
			local skin = getElementModel(targetPlayer)
			local rot = getPedRotation(targetPlayer)

			if isElement(deathPeds[targetPlayer]) then
				x, y, z = getElementPosition(deathPeds[targetPlayer])
				int = getElementInterior(deathPeds[targetPlayer])
				dim = getElementDimension(deathPeds[targetPlayer])
				rot = getPedRotation(deathPeds[targetPlayer])

				destroyElement(deathPeds[targetPlayer])
				deathPeds[targetPlayer] = nil
			end

			removeElementData(targetPlayer, "triedToHelpUp")
			setElementData(targetPlayer, "isPlayerDeath", false)
			spawnPlayer(targetPlayer, x, y, z, rot, skin, int, dim)
			setPedAnimation(targetPlayer)
			setElementData(targetPlayer, "bloodLevel", 100)
		--else
			--outputChatBox("[SealMTA]: #ffffffA kiválasztott játékos nincs meghalva.", sourcePlayer, 215, 89, 89, true)
		--end
	end
end

addCommandHandler("resetdeathpeds",
	function(sourcePlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 1 then
			outputChatBox("[SealMTA]: #ffffffSikeresen kitörölted a buggos pedeket!", sourcePlayer, 94, 193, 230, true)
			for k, v in pairs(getElementsByType("ped")) do
				if getElementData(v, "deathPed") then
					destroyElement(v)
				end
				--[[if deathPeds[v] then
					if isElement(deathPeds[v]) then
						destroyElement(deathPeds[v])
					end
		
					deathPeds[v] = nil
				end]]
			end
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
	if dataName == "isPlayerDeath" and getElementType(source) == "player" and newValue then
		removeElementData(source, "paintOnPlayerTime")
		removeElementData(source, "paintVisibleOnPlayer")
		removeElementData(source, "paintOnPlayerFace")
	end
end)