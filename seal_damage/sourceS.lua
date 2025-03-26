local healPositions = {
	[1] = {
		ped = {
			position = {1176.8898925781, -1339.2155761719, 13.956119537354, 270},
			rotation = {0, 0, 0},
			name = "Trey Smith",
			skin = 274
		},
		marker = {
			position = {1178.3380126953, -1339.2166748047, 13.893835067749 - 0.5}
		}
	},
	[2] = {
		ped = {
			position = {-2672.205078125, 634.66931152344, 14.453125, 180},
			rotation = {0, 0, 0},
			name = "James Jones",
			skin = 272
		},
		marker = {
			position = {-2672.205078125, 633.62536621094, 14.453125 - 0.5}
		}
	}
}

for i = 1, #healPositions do
	local dat = healPositions[i]

	dat.ped.element = createPed(dat.ped.skin, dat.ped.position[1], dat.ped.position[2], dat.ped.position[3], dat.ped.position[4])
	dat.marker.element = createMarker(dat.marker.position[1], dat.marker.position[2], dat.marker.position[3] - 0.5, "cylinder", 1, 89, 142, 215, 200)
	dat.marker.colshape = createColSphere(dat.marker.position[1], dat.marker.position[2], dat.marker.position[3] + 1, 1)

	setElementFrozen(dat.ped.element, true)
	setElementData(dat.ped.element, "invulnerable", true)
	setElementData(dat.ped.element, "visibleName", dat.ped.name)
end

addEventHandler("onColShapeHit", getResourceRootElement(),
	function (hitElement, matchingDimension)
		if matchingDimension then
			if getElementType(hitElement) == "player" then
				exports.seal_gui:showInfobox(hitElement, "i", "Használd az [E] betűt sérüléseid ellátásához!")
				bindKey(hitElement, "e", "up", healPlayer)
			end
		end
	end)

addEventHandler("onColShapeLeave", getResourceRootElement(),
	function (leftElement, matchingDimension)
		if getElementType(leftElement) == "player" then
			unbindKey(leftElement, "e", "up", healPlayer)
		end
	end)

function healPlayer(thePlayer)
	local onlinemedic = false
	local players = getElementsByType("player")

	for i = 1, #players do
		local player = players[i]

		if player and exports.seal_groups:isPlayerInGroup(player, 2) then
			--onlinemedic = true
			break
		end
	end

	if onlinemedic then
		exports.seal_gui:showInfobox(thePlayer, "e", "Van fent mentős!")
		return
	end

	local injureLeftFoot = getElementData(thePlayer, "char.injureLeftFoot")
	local injureRightFoot = getElementData(thePlayer, "char.injureRightFoot")
	local injureLeftArm = getElementData(thePlayer, "char.injureLeftArm")
	local injureRightArm = getElementData(thePlayer, "char.injureRightArm")

	local damages = getElementData(thePlayer, "bulletDamages") or {}
	local damageCount = 0

	for k, v in pairs(damages) do
		damageCount = damageCount + 1
	end

	if injureLeftFoot or injureRightFoot or injureLeftArm or injureRightArm or damageCount > 0 or getElementHealth(thePlayer) <= 20 then
		helpUpPerson(thePlayer)
		exports.seal_gui:showInfobox(thePlayer, "s", "Sikeresen ellátták minden sérülésed.")
	else
		exports.seal_gui:showInfobox(thePlayer, "e", "Nem vagy megsérülve!")
	end
end

addEvent("stitchPlayerCut", true)
addEventHandler("stitchPlayerCut", getRootElement(),
	function (selected)
		if isElement(source) and selected then
			local damages = getElementData(source, "bulletDamages") or {}

			if damages[selected] then
				local bodypart = gettok(selected, 2, ";")
				local serial = gettok(selected, 3, ";")

				damages["stitch-cut;" .. bodypart .. ";" .. serial] = (damages["stitch-cut;" .. bodypart .. ";" .. serial] or 0) + 1
				damages[selected] = nil

				setElementData(source, "bulletDamages", damages)
			end
		end
	end)

addEvent("getOutBullet", true)
addEventHandler("getOutBullet", getRootElement(),
	function (selected)
		iprint(client)
		if isElement(source) and selected then
			local damages = getElementData(source, "bulletDamages") or {}

			if damages[selected] then
				local bodypart = gettok(selected, 2, ";")
				local serial = gettok(selected, 3, ";")

				if not serial or not bodypart then
					return
				end

				local added = exports.seal_items:giveItem(client, 123, 1, false, selected, "---------------")
				print(serial)

				if added then
					damages[selected] = damages[selected] - 1
					damages["hole;" .. bodypart .. ";" .. serial] = (damages["hole;" .. bodypart .. ";" .. serial] or 0) + 1

					if damages[selected] <= 0 then
						damages[selected] = nil
					end

					setElementData(source, "bulletDamages", damages)
				end
			end
		end
	end)

addEventHandler("onPlayerDamage", getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if not loss or loss < 0.5 then
			return
		end

		if weapon == 53 then
			return
		end

		if not bodypart and getPedOccupiedVehicle(source) then
			bodypart = 3
		end

		if attacker and bodypart ~= 9 and weapon ~= 53 and (weapon < 16 or weapon > 18) then
			local bulletDamages = getElementData(source, "bulletDamages") or {}
			local damageType = false

			if weapon == 0 then
				damageType = "punch"
			elseif weapon == 4 or weapon == 8 then
				damageType = "cut"
			elseif weapon >= 22 and weapon <= 34 then
				damageType = weapon
			end

			if damageType then
				local data = damageType .. ";" .. bodypart
				local weaponSerial = getElementData(attacker, "currentWeaponSerial")

				if weaponSerial then
					data = data .. ";" .. weaponSerial
				end

				bulletDamages[data] = (bulletDamages[data] or 0) + 1

				setElementData(source, "bulletDamages", bulletDamages)
			end
		end

		if weapon > 15 then
			-- lábak
			if getPedArmor(source) == 0 then
				if (bodypart == 3 and loss >= 15) or bodypart == 7 or bodypart == 8 then
					local torso = false

					if bodypart == 3 then
						torso = true
						bodypart = math.random(7, 8)
					end

					if bodypart == 7 then
						if not getElementData(source, "char.injureLeftFoot") then
							if torso then
								setElementData(source, "char.injureLeftFoot", true)
								exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, false)
								exports.seal_hud:showInfobox(source, "w", "Eltörted a bal lábad!")
							else
								exports.seal_hud:showInfobox(source, "w", "Megütötted a bal lábad!")
							end
						end
					elseif bodypart == 8 then
						if not getElementData(source, "char.injureRightFoot") then
							if torso then
								setElementData(source, "char.injureRightFoot", true)
								exports.seal_controls:toggleControl(source, {"crouch", "sprint", "jump"}, false)
								exports.seal_hud:showInfobox(source, "w", "Eltörted a jobb lábad!")
							else
								exports.seal_hud:showInfobox(source, "w", "Megütötted a jobb lábad!")
							end
						end
					end
				-- karok
				elseif bodypart == 5 or bodypart == 6 then
					if bodypart == 5 then
						if not getElementData(source, "char.injureLeftArm") then
							setElementData(source, "char.injureLeftArm", true)
							exports.seal_controls:toggleControl(source, {"aim_weapon", "jump"}, false)
							exports.seal_hud:showInfobox(source, "w", "Eltörted a bal kezed!")
						end
					elseif bodypart == 6 then
						if not getElementData(source, "char.injureRightArm") then
							setElementData(source, "char.injureRightArm", true)
							exports.seal_controls:toggleControl(source, {"aim_weapon", "jump"}, false)
							exports.seal_hud:showInfobox(source, "w", "Eltörted a jobb kezed!")
						end
					end
				end
			end
		end
	end)

addEvent("damageCarPunch", true)
addEventHandler("damageCarPunch", getRootElement(),
	function ()
		if isElement(source) and client == source then
			local bodypart = math.random(5, 6)

			if bodypart == 5 then
				if not getElementData(source, "char.injureLeftArm") then
					setElementData(source, "char.injureLeftArm", true)
					exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
					exports.seal_hud:showInfobox(source, "w", "Eltörted a bal kezed!")
				end
			elseif bodypart == 6 then
				if not getElementData(source, "char.injureRightArm") then
					setElementData(source, "char.injureRightArm", true)
					exports.seal_controls:toggleControl(source, {"aim_weapon", "fire", "jump"}, false)
					exports.seal_hud:showInfobox(source, "w", "Eltörted a jobb kezed!")
				end
			end
		else
			exports.seal_anticheat:sendDiscordMessage("@everyone car punch damage\nserial: " .. getPlayerSerial(client), "anticheat")
		end
	end)

addEvent("processHeadShot", true)
addEventHandler("processHeadShot", getRootElement(),
	function (attacker, weapon)
		if isElement(attacker) and weapon and getPedWeapon(attacker) == weapon then
			killPed(source, attacker, weapon, 9)
			setPedHeadless(source, true)
		end
	end)

addEventHandler("onPlayerSpawn", getRootElement(),
	function ()
		setPedHeadless(source, false)
		setElementData(source, "player.seatBelt", false)
	end)

addEvent("vehicleDamage", true)
addEventHandler("vehicleDamage", getRootElement(),
	function (affected)
		if type(affected) == "table" then
			local players = {}

			for k, v in pairs(affected) do
				if isElement(k) and not isPedDead(k) then
					local health = getElementHealth(k) - v

					setElementHealth(k, health)

					if health <= 0 then
						setElementData(k, "customDeath", "autóbaleset")
					end

					table.insert(players, k)
				end
			end

			triggerClientEvent(players, "addBloodToScreenByCarDamage", source, affected)
		end
	end)

addEvent("killPlayerBadHelpup", true)
addEventHandler("killPlayerBadHelpup", getRootElement(),
	function (faszkell)
		if isElement(source) and faszkell == "nagy faszt akarok a seggembe" then
			setElementData(source, "customDeath", "elrontott elsősegély")
			setElementHealth(source, 0)
			setPedAnimation(source)
		else
			local logText = "**killPlayerBadHelpup** \nRészletek:\n```"
			logText = logText .. "\nINSPECTED CLIENTELEMENT: " .. inspect(client)
			logText = logText .. "\n    SERIAL: " .. getPlayerSerial(client)
			logText = logText .. "\n    IP: " .. getPlayerIP(client)
			logText = logText .. "\n    BANNED: " .. "true"
			logText = logText .. "```||@everyone||"
			exports.seal_anticheat:sendDiscordMessage(logText, "anticheat")
			banPlayer(client, true, false, true, "ANTICHEAT", "HELPUP #1")
		end
	end)

addEvent("helpUpPerson", true)
addEventHandler("helpUpPerson", getRootElement(),
	function ()
		if isElement(source) then
			helpUpPerson(source)
			setElementData(source, "char.Hunger", 50)
			setElementData(source, "char.Thirst", 50)
		end
	end)

addEvent("takeMedicBag", true)
addEventHandler("takeMedicBag", getRootElement(),
	function (player)
		if isElement(source) then
			-- seal_clothesshop után az lvmsbag-ot a földre rakni
			triggerClientEvent(source, "takeMedicBag", source, player)
			setElementData(player, "triedToHelpUp", true)
		end
	end)

function helpUpPerson(player)
	if isPedDead(player) then
		exports.seal_death:healCard(player)
	end
	setElementHealth(player, 100)
	setElementData(player, "bloodLevel", 100)

	removeElementData(player, "bulletDamages")
	removeElementData(player, "triedToHelpUp")

	if getElementData(player, "char.injureLeftFoot") then
		exports.seal_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureRightFoot") then
		exports.seal_controls:toggleControl(player, {"crouch", "sprint", "jump"}, true)
	end

	if getElementData(player, "char.injureLeftArm") then
		exports.seal_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	if getElementData(player, "char.injureRightArm") then
		exports.seal_controls:toggleControl(player, {"aim_weapon", "fire", "jump"}, true)
	end

	removeElementData(player, "char.injureLeftFoot")
	removeElementData(player, "char.injureRightFoot")
	removeElementData(player, "char.injureLeftArm")
	removeElementData(player, "char.injureRightArm")
end

addEvent("useSeatbelt", true)
addEventHandler("useSeatbelt", resourceRoot,
	function()
		setElementData(client, "player.seatBelt", not getElementData(client, "player.seatBelt"))
		if getElementData(client, "player.seatBelt") then
			exports.seal_chat:localAction(client, "becsatolja a biztonsági övét.")
		else
			exports.seal_chat:localAction(client, "kicsatolja a biztonsági övét.")
		end
	end
)

addEventHandler("onPlayerStealthKill", getRootElement(),	
	function(p)
		if isElementFrozen(p) or getElementData(p, "invulnerable") then
			cancelEvent()
		end
	end
)