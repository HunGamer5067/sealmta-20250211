local screenX, screenY = guiGetScreenSize()
local responsiveMultipler = 1

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local lastVehicleDamage = 0
local lastSplatterTick = 0

local splatterStart = false
local greenSplatter = false
local splatters = {}
local splatterSizes = {
	[1] = {1024, 666},
	[2] = {1024, 751},
	[3] = {1024, 515},
	[4] = {1024, 510}
}

local vignetteShader = false
local damageEffect = false
local screenSource = dxCreateScreenSource(screenX, screenY)

local attackStartTick = false
local attackerPosX = 0
local attackerPosY = 0

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedres)
		if getResourceName(startedres) == "seal_hud" then
			responsiveMultipler = exports.seal_hud:getResponsiveMultipler()
		else
			if source == getResourceRootElement() then
				local seal_hud = getResourceFromName("seal_hud")

				if seal_hud then
					if getResourceState(seal_hud) == "running" then
						responsiveMultipler = exports.seal_hud:getResponsiveMultipler()
					end
				end

				vignetteShader = dxCreateShader("files/vignette.fx")
			end
		end
	end)

addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		local currentHealth = getElementHealth(localPlayer)

		if currentHealth < 25 then
			local progress = interpolateBetween(1, 0, 0, 0, 0, 0, currentHealth / 25, "Linear")

			dxUpdateScreenSource(screenSource)

			dxSetShaderValue(vignetteShader, "ScreenSource", screenSource)
			dxSetShaderValue(vignetteShader, "radius", 13)
			dxSetShaderValue(vignetteShader, "rdarkness", 0.5 * progress)
			dxSetShaderValue(vignetteShader, "gdarkness", 1 * progress)
			dxSetShaderValue(vignetteShader, "bdarkness", 1 * progress)

			dxDrawImage(0, 0, screenX, screenY, vignetteShader)
		else
			if #splatters >= 1 or damageEffect then
				local progress = 0.5

				if splatterStart then
					progress = interpolateBetween(0, 0, 0, 0.5, 0, 0, (getTickCount() - splatterStart) / 200, "Linear")
				elseif damageEffect then
					progress = interpolateBetween(0.5, 0, 0, 0, 0, 0, (getTickCount() - damageEffect) / 200, "Linear")

					if progress <= 0 then
						damageEffect = false
					end
				end

				dxUpdateScreenSource(screenSource)

				dxSetShaderValue(vignetteShader, "ScreenSource", screenSource)
				dxSetShaderValue(vignetteShader, "radius", 13)

				if greenSplatter then
					local r, g, b = 1-(148/255), 1-(60/255), 1-(184/255)
					dxSetShaderValue(vignetteShader, "rdarkness", r * progress)
					dxSetShaderValue(vignetteShader, "gdarkness", g * progress)
					dxSetShaderValue(vignetteShader, "bdarkness", b * progress)
				else
					dxSetShaderValue(vignetteShader, "rdarkness", 0.5 * progress)
					dxSetShaderValue(vignetteShader, "gdarkness", 1 * progress)
					dxSetShaderValue(vignetteShader, "bdarkness", 1 * progress)
				end

				dxDrawImage(0, 0, screenX, screenY, vignetteShader)
			end
		end

		if #splatters >= 1 then
			if not splatterStart then
				splatterStart = getTickCount()
			end

			for k = 1, #splatters do
				local v = splatters[k]

				if v then
					local progress = 0

					if getTickCount() >= v[2] then
						local elapsedTime = getTickCount() - v[2]

						progress = elapsedTime / 1000

						if progress >= 1 then
							splatters[k] = nil

							if #splatters < 1 then
								splatterStart = false
								damageEffect = getTickCount()
							end
						end
					end

					if v then
						local alpha = interpolateBetween(
							255, 0, 0,
							0, 0, 0,
							progress, "Linear")

						dxDrawImage(v[3], v[4], v[5], v[6], "files/splatters/" .. v[1] .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					end
				end
			end
		end

		if attackStartTick then
			local elapsedTime = getTickCount() - attackStartTick

			if elapsedTime <= 4500 then
				local alpha = 255

				if elapsedTime > 3500 then
					alpha = interpolateBetween(
						255, 0, 0,
						0, 0, 0,
						(elapsedTime - 3500) / 1000, "Linear")
				end

				local playerPosX, playerPosY = getElementPosition(localPlayer)
				local angle = -math.deg(math.atan2(attackerPosX - playerPosX, attackerPosY - playerPosY))

				if angle < 0 then
					angle = angle + 360
				end

				local cameraX, cameraY, _, lookAtX, lookAtY = getCameraMatrix()
				local angle2 = -math.deg(math.atan2(lookAtX - cameraX, lookAtY - cameraY))

				if angle2 < 0 then
					angle2 = angle2 + 360
				end

				local imageangle = -(angle - angle2)
				local theta = math.rad(imageangle)
				local x = (182 + 64) * math.sin(theta) - (0.5 * 256 * math.cos(theta))
				local y = (182 + 64) * math.cos(theta) + (0.5 * 256 * math.sin(theta))

				dxDrawImage(screenX / 2 + x, screenY / 2 - y, 256, 64, "files/arrow.png", imageangle, -128, -32, tocolor(255, 255, 255, alpha), true)
			else
				attackStartTick = false
			end
		end
	end, true, "high+999999999")

addEvent("addBloodToScreenByCarDamage", true)
addEventHandler("addBloodToScreenByCarDamage", getRootElement(),
	function (affected)
		local loss = affected[localPlayer] or 5

		if loss > 2 and getTickCount() - lastSplatterTick >= 1000 then
			lastSplatterTick = getTickCount()
			greenSplatter = false

			for i = 1, #splatters + 1 do
				if not splatters[i] then
					local id = math.random(1, 4)
					local sx = respc(splatterSizes[id][1])
					local sy = respc(splatterSizes[id][2])
					local x = math.random(-(sx / 2), screenX - sx + sx / 2)
					local y = math.random(-(sy / 2), screenY - sy + sy / 2)

					splatters[i] = {tostring(id), getTickCount() + math.abs(loss) * math.random(40, 60), x, y, sx, sy}

					break
				end
			end
		end
	end)

addEvent("addGreenSplatter", true)
addEventHandler("addGreenSplatter", getRootElement(),
	function (amount)
		if amount > 2 and getTickCount() - lastSplatterTick >= 1000 then
			lastSplatterTick = getTickCount()
			greenSplatter = true

			for i = 1, #splatters + math.random(1, 3) do
				if not splatters[i] then
					local id = math.random(1, 4)
					local sx = respc(splatterSizes[id][1])
					local sy = respc(splatterSizes[id][2])
					local x = math.random(-(sx / 2), screenX - sx + sx / 2)
					local y = math.random(-(sy / 2), screenY - sy + sy / 2)

					splatters[i] = {"g" .. tostring(id), getTickCount() + math.abs(amount) * math.random(400, 600), x, y, sx, sy}

					break
				end
			end
		end
	end)

addEventHandler("onClientPlayerDamage", localPlayer,
	function (attacker, weapon, bodypart, loss)
		if getElementData(source, "invulnerable") then
			cancelEvent()
			return
		end

		if getTickCount() - lastSplatterTick >= 1000 then
			lastSplatterTick = getTickCount()
			greenSplatter = false

			for i = 1, #splatters + 1 do
				if not splatters[i] then
					local id = math.random(1, 4)
					local sx = respc(splatterSizes[id][1])
					local sy = respc(splatterSizes[id][2])
					local x = math.random(-(sx / 2), screenX - sx + sx / 2)
					local y = math.random(-(sy / 2), screenY - sy + sy / 2)

					splatters[i] = {tostring(id), getTickCount() + math.abs(loss) * math.random(400, 600), x, y, sx, sy}

					break
				end
			end
		end

		if isElement(attacker) then
			if getElementType(attacker) == "player" then
				if weapon and weapon > 9 then
					attackerPosX, attackerPosY = getElementPosition(attacker)
					attackStartTick = getTickCount()
				end

				if getElementData(attacker, "tazerState") then
					if weapon == 24 then
						triggerServerEvent("onTazerShoot", attacker, source, bodypart)
						cancelEvent()
					end
				elseif bodypart == 9 then
					triggerServerEvent("processHeadShot", localPlayer, attacker, weapon)
					cancelEvent()
				end
			elseif getElementType(attacker) == "ped" then
				local hitDamage = getElementData(attacker, "hitDamage")

				if hitDamage then
					setElementHealth(localPlayer, getElementHealth(localPlayer) - hitDamage)
					cancelEvent()
				end
			end
		end
	end)

addEventHandler("onClientVehicleDamage", getRootElement(),
	function (attacker, weapon, loss, dmgPosX, dmgPosY, dmgPosZ, tireId)
		if (not weapon or weapon == 0) and attacker == localPlayer and not tireId then
			if not getElementData(localPlayer, "invulnerable") then
				triggerServerEvent("damageCarPunch", localPlayer)
			end
		end

		if not weapon and source == getPedOccupiedVehicle(localPlayer) then
			if getTickCount() - lastVehicleDamage >= 2000 then
				local vehicleModel = getElementModel(source)
				local damageMultipler = damageMultiplers[vehicleModel] or 1
				local affected = {}
				local count = 0

				for k, v in pairs(getVehicleOccupants(source)) do
					if (getElementData(v, "adminDuty") or 0) == 0 then
						if getElementData(v, "player.seatBelt") then
							affected[v] = math.floor(loss * 0.3) * 0.5 * damageMultipler
						else
							affected[v] = math.floor(loss * 0.3) * damageMultipler
						end

						if affected[v] == 0 then
							affected[v] = nil
						else
							count = count + 1
						end
					end
				end

				if count > 0 then
					triggerServerEvent("vehicleDamage", localPlayer, affected)
				end

				lastVehicleDamage = getTickCount()
			end
		end
	end, true, "high+99999")

addEventHandler("onClientPedDamage", getRootElement(),
	function ()
		if getElementData(source, "invulnerable") then
			cancelEvent()
		end
	end)

local seatBeltLastUse = 0
local seatBeltTimer = false

addCommandHandler("öv",
	function ()
		local pedveh = getPedOccupiedVehicle(localPlayer)

		if isElement(pedveh) then
			if (getVehicleType(pedveh) or "N/A") == "Automobile" and not beltlessModels[getElementModel(pedveh)] then
				if getTickCount() - seatBeltLastUse >= 1000 then
					triggerServerEvent("useSeatbelt", resourceRoot)
					--setElementData(localPlayer, "player.seatBelt", not getElementData(localPlayer, "player.seatBelt"))

					if getElementData(localPlayer, "player.seatBelt") then
						--exports.seal_chat:localActionC(localPlayer, "kicsatolja a biztonsági övét.")
						playSound(":seal_vehiclepanel/files/beltout.mp3", false)
					else
						--exports.seal_chat:localActionC(localPlayer, "becsatolja a biztonsági övét.")
						playSound(":seal_vehiclepanel/files/beltin.mp3", false)
					end

					seatBeltLastUse = getTickCount()
				else
					exports.seal_hud:showInfobox("e", "Csak másodpercenként csatolhatod ki/be az öved.")
				end
			end
		end
	end)
bindKey("F5", "down", "öv")

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "player.seatBelt"then
			local myveh = getPedOccupiedVehicle(localPlayer)
			local pedveh = getPedOccupiedVehicle(source)

			if isElement(myveh) and isElement(pedveh) and myveh == pedveh then
				if source ~= localPlayer then
					if getElementData(source, "player.seatBelt") then
						playSound(":seal_vehiclepanel/files/beltin.mp3", false)
					else
						playSound(":seal_vehiclepanel/files/beltout.mp3", false)
					end
				end

				checkSeatBelt(myveh)
			end
		end
	end)

addEventHandler("onClientVehicleStartEnter", getRootElement(),
	function (player)
		if player == localPlayer then
			setElementData(localPlayer, "player.seatBelt", false)
		end
	end)

addEventHandler("onClientPlayerVehicleEnter", getRootElement(),
	function (vehicle, seat)
		if vehicle == getPedOccupiedVehicle(localPlayer) or source == localPlayer then
			checkSeatBelt(vehicle)
		end
	end)

addEventHandler("onClientPlayerVehicleExit", getRootElement(),
	function (vehicle, seat)
		if vehicle == getPedOccupiedVehicle(localPlayer) or source == localPlayer then
			checkSeatBelt(vehicle)
		end
	end)

addEventHandler("onClientPlayerQuit", getRootElement(),
	function ()
		local pedveh = getPedOccupiedVehicle(source)

		if pedveh == getPedOccupiedVehicle(localPlayer) then
			setTimer(checkSeatBelt, 1000, 1, pedveh)
		end
	end)

function seatBeltSound()
	local pedveh = getPedOccupiedVehicle(localPlayer)

	if pedveh then
		if getVehicleEngineState(pedveh) then
			playSound(":seal_vehiclepanel/files/belt.mp3", false)
		end
	else
		if isTimer(seatBeltTimer) then
			killTimer(seatBeltTimer)
		end

		if getElementData(localPlayer, "player.seatBelt") then
			setElementData(localPlayer, "player.seatBelt", false)
		end
	end
end

function checkSeatBelt(vehicle)
	if isElement(vehicle) then
		if beepingModels[getElementModel(vehicle)] then
			local playSound = false

			for k, v in pairs(getVehicleOccupants(vehicle)) do
				if getElementType(v) == "player" and not getElementData(v, "player.seatBelt") then
					playSound = true
					break
				end
			end

			if not playSound then
				if isTimer(seatBeltTimer) then
					killTimer(seatBeltTimer)
				end
			elseif not isTimer(seatBeltTimer) then
				seatBeltTimer = setTimer(seatBeltSound, 1500, 0)
			end
		elseif isTimer(seatBeltTimer) then
			killTimer(seatBeltTimer)
		end
	end
end

local bulletLocation = {
	[3] = "törzsben",
	[4] = "medencében",
	[5] = "bal kézben",
	[6] = "jobb kézben",
	[7] = "bal lábban",
	[8] = "jobb lábban",
	[9] = "fejben"
}

local surfaceLocation = {
	[3] = "törzsön",
	[4] = "medencén",
	[5] = "bal kézen",
	[6] = "jobb kézen",
	[7] = "bal lábon",
	[8] = "jobb lábon",
	[9] = "fejen"
}

local bulletOperation = {
	[3] = "törzséből",
	[4] = "medencéjéből",
	[5] = "bal kezéből",
	[6] = "jobb kezéből",
	[7] = "bal lábából",
	[8] = "jobb lábából",
	[9] = "fejéből"
}

local stitchOperation = {
	[3] = "törzsén",
	[4] = "medencéjén",
	[5] = "bal kezén",
	[6] = "jobb kezén",
	[7] = "bal lábán",
	[8] = "jobb lábán",
	[9] = "fején"
}

local panelPosX = 0
local panelPosY = 0
local panelFont = false

local buttons = {}
local activeButton = false

local examinedPed = false
local injureLeftFoot = false
local injureRightFoot = false
local injureLeftArm = false
local injureRightArm = false
local bulletDamages = false

local canOperate = false
local canStitch = false

function examineMyself()
	if not examinedPed then
		examinedPed = localPlayer

		panelPosX = screenX / 2
		panelPosY = screenY / 2

		panelFont = dxCreateFont("files/Rubik.ttf", respc(13), false, "proof")

		bulletDamages = getElementData(examinedPed, "bulletDamages") or {}

		if getElementData(localPlayer, "holdingBag") then
			canOperate = true
			canStitch = true
		end
	end
end
addCommandHandler("examinemyself", examineMyself)
addCommandHandler("sérüléseim", examineMyself)
addCommandHandler("seruleseim", examineMyself)

addCommandHandler("msegit",
	function()
		if not getElementData(localPlayer, "isPlayerDeath") and getElementHealth(localPlayer) > 0 and getElementHealth(localPlayer) <= 20 then
			exports.seal_minigames:startMinigame("ghero", "helpUpMyself", "failedToHelpUpMyself", 0.15, 0.2, 120, 100)
			setElementData(localPlayer, "triedToHelpUp", true)
		end
	end)

addEvent("failedToHelpUpMyself", true)
addEventHandler("failedToHelpUpMyself", localPlayer,
	function ()
		outputChatBox("#d75959[SealMTA]: #ffffffNem sikerült meggyógyítanod magadat.", 255, 255, 255, true)
		exports.seal_hud:showInfobox("e", "Nem sikerült meggyógyítanod magadat.")
	end)

addEvent("helpUpMyself", true)
addEventHandler("helpUpMyself", localPlayer,
	function ()
		triggerServerEvent("helpUpPerson", localPlayer)
		outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen meggyógyítottad magadat.", 255, 255, 255, true)
		exports.seal_hud:showInfobox("s", "Sikeresen meggyógyítottad magadat.")
		setElementData(localPlayer, "triedToHelpUp", true)
	end)

local helpUpPerson = false

addEvent("takeMedicBag", true)
addEventHandler("takeMedicBag", localPlayer,
	function (player)
		if isElement(player) then
			helpUpPerson = player
			exports.seal_chat:localActionC(localPlayer, "elkezdte felsegíteni " .. getElementData(player, "visibleName"):gsub("_", " ") .. "-t.")

			if isElement(getElementData(localPlayer, "holdingBag")) then
				exports.seal_minigames:startMinigame("ghero", "helpUpPerson", "failedToHelpUp", 0.15, 0.2, 100, 40)
			else
				exports.seal_minigames:startMinigame("ghero", "helpUpPerson", "failedToHelpUp", 0.15, 0.2, 120, 80)
			end
		end
	end)

addEvent("failedToHelpUp", true)
addEventHandler("failedToHelpUp", localPlayer,
	function ()
		if isElement(helpUpPerson) then
			outputChatBox("#d75959[SealMTA]: #ffffffNem sikerült felsegíteni " .. getElementData(helpUpPerson, "visibleName"):gsub("_", " ") .. "-t, ezért meghalt.", 255, 255, 255, true)
			exports.seal_hud:showInfobox("e", "Nem sikerült felsegíteni, ezért meghalt.")
			triggerServerEvent("killPlayerBadHelpup", helpUpPerson, "nagy faszt akarok a seggembe")
		end
	end)

addEvent("helpUpPerson", true)
addEventHandler("helpUpPerson", localPlayer,
	function ()
		if isElement(helpUpPerson) then
			triggerServerEvent("helpUpPerson", helpUpPerson)
			outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen meggyógyítottad " .. getElementData(helpUpPerson, "visibleName"):gsub("_", " ") .. "-t.", 255, 255, 255, true)
			exports.seal_hud:showInfobox("s", "Sikeresen meggyógyítottad.")
		end
	end)

addEventHandler("onClientPlayerStealthKill", getRootElement(),	
	function(p)
		if isElementFrozen(p) or getElementData(p, "invulnerable") then
			cancelEvent()
		end
	end
)

function isDamagedForFishing()
	return injureLeftArm or injureRightArm or injureLeftLeg and injureRightLeg == 1
  end