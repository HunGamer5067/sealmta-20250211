local tickSync = 0

addEvent("playPrivateMessageSound", true)
addEventHandler("playPrivateMessageSound", getRootElement(), function()
	--playSound ( string soundPath, [ bool looped = false, bool throttled = true ] )
	playSound("files/pm.mp3")
end)

addEvent("getTickSyncKillmsg", true)
addEventHandler("getTickSyncKillmsg", getRootElement(),
	function (tick)
		tickSync = tick - getRealTime().timestamp
	end)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		triggerServerEvent("getTickSyncKillmsg", localPlayer)
	end)

local quitReasons = {
	unknown = "Ismeretlen",
	quit = "Lecsatlakozott",
	kicked = "Kirúgva",
	banned = "Kitiltva",
	["bad connection"] = "Rossz kapcsolat",
	["timed out"] = "Időtúllépés"
}

addEventHandler("onClientPlayerQuit", getRootElement(),
	function (reason)
		if getElementData(source, "loggedIn") then
			local localX, localY, localZ = getElementPosition(localPlayer)
			local playerX, playerY, playerZ = getElementPosition(source)
			local distance = getDistanceBetweenPoints3D(localX, localY, localZ, playerX, playerY, playerZ)

			if distance <= 20 then
				outputChatBox(getElementData(source, "visibleName"):gsub("_", " ") .. " kilépett a közeledben. [" .. quitReasons[string.lower(reason)] .. "] Távolság: " .. math.floor(distance) .. " yard", 215, 89, 89, true)
			end
		end
	end)

local deathTypes = {
	[19] = "robbanás",
	[37] = "égés",
	[49] = "autóbaleset",
	[50] = "autóbaleset",
	[51] = "robbanás",
	[52] = "elütötték",
	[53] = "fulladás",
	[54] = "esés",
	[55] = "unknown",
	[56] = "verekedés",
	[57] = "fegyver",
	[59] = "tank",
	[63] = "robbanás",
	[0] = "verekedés"
}

local weaponNames = {
	Rammed = "autóbaleset",
	shovel = "Csákány",
	["colt 45"] = "Glock 17",
	silenced = "Hangtompítós Colt-45",
	rifle = "Vadász puska",
	sniper = "Remington 700",
	mp5 = "P90"
}

addEventHandler("onClientPlayerWasted", getRootElement(),
	function (killer, weapon, bodypart)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			timestamp = getRealTime().timestamp + tickSync
			time = getRealTime(timestamp)

			time = "[" .. string.format("%04d.%02d.%02d %02d:%02d:%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second) .. "] "

			killedName = getElementData(source, "visibleName"):gsub("_", " ")
			deathText = ""
			customText = getElementData(source, "customDeath") or getElementData(source, "deathReason")

			if customText then
				deathText = " [" .. customText .. "]"
			elseif tonumber(weapon) then
				deathText = deathTypes[weapon]

				if not deathText then
					local weaponName = getWeaponNameFromID(weapon)
					if getElementData(killer, "equippedCustomWeapon") and getElementData(killer, "equippedWeaponName") then
						weaponName = getElementData(killer, "equippedWeaponName")
					end

					if weaponNames[weaponName] then
						weaponName = weaponNames[weaponName]

						if weaponName == "autóbaleset" then
							deathText = " [autóbaleset]"
						else
							deathText = " [" .. weaponName .. "]"
						end
					else
						deathText = " [" .. weaponName .. "]"
					end

					if bodypart == 9 then
						deathText = deathText .. " (fejlövés)"
					end
				else
					deathText = " [" .. deathText .. "]"
				end
			end

			if isElement(killer) then
				local killerType = getElementType(killer)

				if killerType == "player" then
					if exports.seal_groups:isPlayerInGroup(killer, 40) then -- hitman
						return
					end
				end

				local killerName = ""

				if killerType == "player" then
					killerName = getElementData(killer, "visibleName"):gsub("_", " ")
					if not killerName then
						killerName = getPlayerName(killer)
					end

				elseif killerType == "vehicle" then
					local vehdriver = getVehicleController(killer)

					if vehdriver then
						killerName = getElementData(vehdriver, "visibleName"):gsub("_", " ")
					else
						killerName = "Egy jármű"
					end
				end

				

				outputChatBox(time .. killerName .. " megölte " .. killedName .. "-t." .. deathText, 175, 175, 175)
				--exports.seal_anticheat:sendDiscordMessage(time .. killerName .." megölte ".. killedName .."-t")
			else
				outputChatBox(time .. killedName .. " meghalt." .. deathText, 175, 175, 175)
				
			end
		end

		triggerServerEvent("showKillMessage", source, time, kiledName, deathText, killerName)
	end
)

function playNotification(typ)
	if typ then
		if typ == "error" then
			playSound("files/error.mp3", false)
		elseif typ == "epanel" then
			playSound("files/epanel.mp3", false)
		end
	end
end
	
addEvent("playNotification", true)
addEventHandler("playNotification", getRootElement(),
	function (typ)
		if typ then
			playNotification(typ)
		end
	end)	

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "spectateTarget" and source == localPlayer then
			spectateTarget = getElementData(localPlayer, "spectateTarget")

			if spectateTarget then
				local targetInterior = getElementInterior(spectateTarget)
				local targetDimension = getElementDimension(spectateTarget)

				triggerServerEvent("updateSpectatePosition", localPlayer, targetInterior, targetDimension, tonumber(getElementData(spectateTarget, "currentCustomInterior") or 0))
			end
		end
	end
)

addEvent("startHimnuszSound", true)
addEventHandler("startHimnuszSound", resourceRoot,
	function ()
		local sound = playSound3D("himnusz.mp3", -2234.4921875, -1745.9820556641, 480.87271118164)
		setSoundMaxDistance(sound, 250)
	end
)
local adminMarks = {}

function loadAdminMarks()
	if fileExists("marks.astral") then
		local markFile = fileOpen("marks.astral")
		local fileSize = fileGetSize(markFile)
		local fileData = fileRead(markFile, fileSize)
		fileClose(markFile)

		local markData = split(fileData, "\n")

		for k, v in ipairs(markData) do
			local row = split(v, ";")

			if #row > 1 then
				local name = row[1]
				local x, y, z = row[2], row[3], row[4]
				local interior = row[5]
				local dimension = row[6]

				adminMarks[name] = {
					x, y, z,
					interior, dimension
				}
			end
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadAdminMarks)

function addAdminMark(name, data)
	adminMarks[name] = data

	local file

	if fileExists("marks.astral") then
		file = fileOpen("marks.astral")
	else
		file = fileCreate("marks.astral")
	end

	if file then
		local fileSize = fileGetSize(file)
		local fileData = table.concat(data, ";")

		fileSetPos(file, fileSize)
	  	fileWrite(file, name .. ";" .. fileData .. "\n")
	end

	fileClose(file)
end

function deleteAdminMark(name)
	if adminMarks[name] then
		adminMarks[name] = nil

	  	if fileExists("marks.astral") then
			fileDelete("marks.astral")
	  	end

	  	local file = fileCreate("marks.astral")

	  	for i in pairs(adminMarks) do
			local fileData = table.concat(adminMarks[i], ";")
			fileWrite(file, i .. ";" .. fileData .. "\n")
	  	end

	  	fileClose(file)
	end
end

addCommandHandler("marks",
	function(commandName, ...)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
	  		outputChatBox("[color=primary][SealMTA - Teleportok]: #ffffff név - (x, y, z, int, dim) ", 255, 255, 255, true)

	  		for name, data in pairs(adminMarks) do
				outputChatBox("#FFFFFF- [color=primary]" .. name .. "#ffffff - (" .. table.concat(data, ", ") .. ")", 255, 255, 255, true)
	  		end
		end
  	end
)

addCommandHandler("mark",
	function(commandName, ...)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local name = table.concat({...}, " ")
	  		name = utf8.lower(name)

	  		if name and utf8.len(name) > 0 then
				local x, y, z = getElementPosition(localPlayer)
				local interior = getElementInterior(localPlayer)
				local dimension = getElementDimension(localPlayer)

				addAdminMark(name, {x, y, z, interior, dimension})
				outputChatBox("[color=primary][SealMTA]: #FFFFFFTeleport [color=blue]" .. name .. "#FFFFFF sikeresen mentve.", 0, 255, 0, true)
	  		else
				outputChatBox("[color=blue][SealMTA - Használat]: #FFFFFF/" .. commandName .. " [Név]", 255, 255, 255, true)
	  		end
		end
	end
)

addCommandHandler("delmark",
	function(commandName, ...)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local name = table.concat({...}, " ")
			name = utf8.lower(name)

	  		if name and utf8.len(name) > 0 then
				if adminMarks[name] then
					deleteAdminMark(name)
		  			outputChatBox("[color=primary][SealMTA]: #FFFFFFTeleport [color=blue]" .. name .. "#FFFFFF sikeresen törölve.", 0, 255, 0, true)
				else
		  			outputChatBox("[color=red][SealMTA]: #FFFFFFTeleport [color=blue]" .. name .. "#FFFFFF nem létezik.", 0, 255, 0, true)
				end
	  		else
				outputChatBox("[color=blue][SealMTA - Használat]: #FFFFFF/" .. commandName .. " [Név]", 255, 255, 255, true)
	  		end
		end
  	end
)

addCommandHandler("gotomark",
	function(commandName, ...)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local name = table.concat({...}, " ")

	  		if adminMarks[name] then
				if getPedOccupiedVehicle(localPlayer) then
		  			triggerServerEvent("markVehicle", resourceRoot, adminMarks[name][1], adminMarks[name][2], adminMarks[name][3], adminMarks[name][4], adminMarks[name][5])
				else
		  			triggerServerEvent("markPlayer", resourceRoot, adminMarks[name][1], adminMarks[name][2], adminMarks[name][3], adminMarks[name][4], adminMarks[name][5])
				end
	  		else
				outputChatBox("[color=red][SealMTA]: #FFFFFFNincs megjelölve ilyen teleport.", 255, 255, 255, true)
	  		end
		end
  	end
)
  