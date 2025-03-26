local getZoneNameEx = getZoneName

function getZoneName(x, y, z, cities)
	local zone = getZoneNameEx(x, y, z, cities)

	if zone == "Greenglass College" then
		return "Las Venturas City Hall"
	end

	return zone
end

local screenX, screenY = guiGetScreenSize()

local renderData = {}

local buttons = {}
local activeButton = false

local fakeInputValue = {}
local activeFakeInput = false
local caretIndex = false
local repeatTimer = false
local repeatStartTimer = false
local inputError = false
local inputErrorText = ""

local mdcVehicles = {
	[597] = true,
	[596] = true,
	[497] = true,
	[598] = true,
	[427] = true,
	[599] = true,
	[601] = true,
	[490] = true,
	[528] = true,
	[604] = true,
	[470] = true
}

local groupPrefixes = {
	[1] = "PD",
	[4] = "NNI",
	[2] = "TEK",
	[3] = "OMSZ",
	[8] = "NAV",
}

local availableTabs = {
	{
		name = "wantedCars",
		title = "Körözött járművek"
	},
	{
		name = "wantedPeople",
		title = "Körözött személyek"
	},
	{
		name = "punishedPeople",
		title = "Büntetések"
	},
	{
		name = "btk",
		title = "BTK"
	}
}

local panelState = false

local Rubik = false
local RubikB = false
local RubikL = false

local loggedInMDC = false
local currentPage = "login"

local lastVehicle = false

function createFonts()
	destroyFonts()

	Rubik = dxCreateFont("files/fonts/Rubik.ttf", 14, false, "proof")
	RubikL = dxCreateFont("files/fonts/RubikL.ttf", 15, false, "proof")
	RubikB = dxCreateFont("files/fonts/RubikB.ttf", 32, false, "proof")
end

function destroyFonts()
	if isElement(Rubik) then
		destroyElement(Rubik)
	end
	Rubik = nil

	if isElement(RubikL) then
		destroyElement(RubikL)
	end
	RubikL = nil

	if isElement(RubikB) then
		destroyElement(RubikB)
	end
	RubikB = nil
end

function policeMessage(text)
	outputChatBox("#4adfbf[SealMTA - Rendőrség]:#FFFFFF " .. text, 255, 255, 255, true)
end

local mdcNotifications = true
local backupSoundState = true

addCommandHandler("togmdcmsg",
	function ()
		if exports.seal_groups:isPlayerOfficer(localPlayer) then
			if mdcNotifications then
				policeMessage("Sikeresen kikapcsoltad az MDC értesítéseket!")
				mdcNotifications = false
				backupSoundState = false
			else
				policeMessage("Sikeresen bekapcsoltad az MDC értesítéseket!")
				mdcNotifications = true
				backupSoundState = true
			end
		end
	end)

addCommandHandler("togbackupsound",
	function ()
		if exports.seal_groups:isPlayerOfficer(localPlayer) then
			if backupSoundState then
				policeMessage("Sikeresen kikapcsoltad a backup hangokat!")
				backupSoundState = false
			else
				policeMessage("Sikeresen bekapcsoltad a backup hangokat!")
				backupSoundState = true
			end
		end
	end
)

addEvent("mdcAlertFromServer", true)
addEventHandler("mdcAlertFromServer", getRootElement(),
	function (plate, cctv, reason)
		if mdcNotifications then
			if isElement(source) and exports.seal_groups:isPlayerOfficer(localPlayer) then
				local x, y, z = getElementPosition(source)

				if cctv then
					policeMessage("Figyelem! Az egyik biztonsági kamerán (#4adfbf" .. getZoneName(x, y, z) .. "#FFFFFF) egy #d75959körözött járművet#ffffff észleltek!")
				else
					policeMessage("Figyelem! Az egyik ellenőrzőponton (#4adfbf" .. getZoneName(x, y, z) .. "#FFFFFF) egy #d75959körözött jármű#ffffff haladt át!")
				end

				local r1, g1, b1, r2, g2, b2 = getVehicleColor(source, true)

				policeMessage("Rendszám: #4adfbf" .. plate .. "#FFFFFF Típus: #4adfbf" .. exports.seal_vehiclenames:getCustomVehicleName(getElementModel(source)) .. "#FFFFFF Színek: " .. rgbToHex(r1, g1, b1) .. "szín1 " .. rgbToHex(r2, g2, b2) .. "szín2")
				policeMessage("Ezért körözik: " .. reason)

				local blipElement = createBlip(x, y, z, 0, 2, 215, 89, 89)

				attachElements(blipElement, source)
				setTimer(destroyElement, 15000, 1, blipElement)
				setElementData(blipElement, "blipTooltipText", "Körözött jármű: " .. plate)

				exports.seal_groupscripting:mdcAlertFromServer(plate, cctv, reason)
			end
		end
	end)

addEvent("shootAlertFromServer", true)
addEventHandler("shootAlertFromServer", getRootElement(),
	function (suspectName, vehicleElement, personReason, vehicleReason, zoneName)
		if mdcNotifications then
			if isElement(source) and exports.seal_groups:isPlayerOfficer(localPlayer) then
				if exports.seal_groups:isPlayerOfficer(source) then
					return
				end
				
				local x, y, z = getElementPosition(source)
				local text = "lövést"

				if isElement(vehicleElement) then
					text = "lövést (járműből)"
				end

				if suspectName ~= "ismeretlen" then
					policeMessage("Figyelem! Az egyik biztonsági kamera (#4adfbf" .. zoneName .. "#FFFFFF) #d75959" .. text .. "#ffffff észlelt! Elkövető: #4adfbf" .. suspectName .. " #d75959(körözött bűnöző)")
					policeMessage("Ezt a személyt jelenleg körözik: " .. personReason)
				else
					policeMessage("Figyelem! Az egyik biztonsági kamera (#4adfbf" .. zoneName .. "#FFFFFF) #d75959" .. text .. "#ffffff észlelt! Elkövető: #d75959" .. suspectName)
				end

				if vehicleReason then
					if isElement(vehicleElement) then
						local plateText = getVehiclePlateText(vehicleElement)

						if plateText then
							local plateSection = {}
							local plateTextTable = split(plateText, "-")

							for i = 1, #plateTextTable do
								if utf8.len(plateTextTable[i]) > 0 then
									table.insert(plateSection, plateTextTable[i])
								end
							end

							plateText = table.concat(plateSection, "-")

							policeMessage("Egy járműből lőttek. Rendszáma: " .. plateText .. ". Típusa: " .. exports.seal_vehiclenames:getCustomVehicleName(getElementModel(vehicleElement)) .. ".")
							policeMessage("Ezt a járművet eddig ezért körözik: " .. vehicleReason)
						end
					end
				end

				local blipElement = createBlip(x, y, z, 0, 2, 215, 89, 89)

				attachElements(blipElement, source)
				setTimer(destroyElement, 5500, 1, blipElement)

				if suspectName ~= "ismeretlen" then
					setElementData(blipElement, "blipTooltipText", "Körözött személy (lövés): " .. suspectName .. " (körözött bűnöző)")
				else
					setElementData(blipElement, "blipTooltipText", "Körözött személy (lövés): " .. suspectName)
				end
			end
		end
	end)

addEvent("killAlertFromServer", true)
addEventHandler("killAlertFromServer", getRootElement(),
	function (suspectName, vehicleElement, personReason, vehicleReason, zoneName)
		if mdcNotifications then
			if isElement(source) and exports.seal_groups:isPlayerOfficer(localPlayer) then
				local x, y, z = getElementPosition(source)
				local text = "emberölést"

				if isElement(vehicleElement) then
					text = "emberölést (járműből)"
				end

				if suspectName ~= "ismeretlen" then
					policeMessage("Figyelem! Az egyik biztonsági kamera (#4adfbf" .. zoneName .. "#FFFFFF) #d75959" .. text .. "#ffffff észlelt! Elkövető: #4adfbf" .. suspectName .. " #d75959(körözött bűnöző)")
					policeMessage("Ezt a személyt jelenleg körözik: " .. personReason)
				else
					policeMessage("Figyelem! Az egyik biztonsági kamera (#4adfbf" .. zoneName .. "#FFFFFF) #d75959" .. text .. "#ffffff észlelt! Elkövető: #d75959" .. suspectName)
				end

				if vehicleReason then
					if isElement(vehicleElement) then
						local plateText = getVehiclePlateText(vehicleElement)

						if plateText then
							local plateSection = {}
							local plateTextTable = split(plateText, "-")

							for i = 1, #plateTextTable do
								if utf8.len(plateTextTable[i]) > 0 then
									table.insert(plateSection, plateTextTable[i])
								end
							end

							plateText = table.concat(plateSection, "-")

							policeMessage("Egy járműből lőttek. Rendszáma: " .. plateText .. ". Típusa: " .. exports.seal_vehiclenames:getCustomVehicleName(getElementModel(vehicleElement)) .. ".")
							policeMessage("Ezt a járművet eddig ezért körözik: " .. vehicleReason)
						end
					end
				end

				local blipElement = createBlip(x, y, z, 0, 2, 215, 89, 89)

				attachElements(blipElement, source)
				setTimer(destroyElement, 5500, 1, blipElement)

				if suspectName ~= "ismeretlen" then
					setElementData(blipElement, "blipTooltipText", "Körözött személy (gyilkosság): " .. suspectName .. " (körözött bűnöző)")
				else
					setElementData(blipElement, "blipTooltipText", "Körözött személy (gyilkosság): " .. suspectName)
				end
			end
		end
	end)

function rgbToHex(r, g, b, a)
	if (r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255) or (a and (a < 0 or a > 255)) then
		return nil
	end

	if a then
		return string.format("#%.2X%.2X%.2X%.2X", r, g, b, a)
	else
		return string.format("#%.2X%.2X%.2X", r, g, b)
	end
end

local vowels = {
	a = true,
	["á"] = true,
	e = true,
	["é"] = true,
	i = true,
	["í"] = true,
	o = true,
	["ó"] = true,
	["ö"] = true,
	["ő"] = true,
	u = true,
	["ú"] = true,
	["ü"] = true,
	["ű"] = true
}

function findTheArticle(str)
	if tonumber(str) then
		local num = tonumber(str)

		if num == 1 then
			return "az"
		end

		if tonumber(utf8.sub(str, 1, 1)) == 1 and (utf8.len(str) % 4 == 0 or utf8.len(str) % 4 == 3) then
			return "az"
		end

		return "a"
	end

	str = utf8.lower(str)

	if vowels[utf8.sub(utf8.lower(str), 1, 1)] then
		return "az"
	else
		return "a"
	end
end

function firstToUpper(text)
	return (text:gsub("^%l", string.upper))
end

local unitBlips = {}
local unitTimers = {}

function blipTimer(blipElement)
	if isElement(blipElement) then
		local r, g, b = getBlipColor(blipElement)

		if r == 89 then
			setBlipColor(blipElement, 215, 89, 89, 255)
		else
			setBlipColor(blipElement, 89, 142, 215, 255)
		end
	end
end

local atmRobBlips = {}
local moneyCasetteBlips = {}

function initMDCBlips()
	local objectsTable = getElementsByType("object")

	for i = 1, #objectsTable do
		local objectElement = objectsTable[i]

		if isElement(objectElement) then
			local objectModel = getElementModel(objectElement)

			if objectModel == 2942 or objectModel == 2943 then
				if isElement(atmRobBlips[objectElement]) then
					destroyElement(atmRobBlips[objectElement])
				end

				atmRobBlips[objectElement] = nil

				if getElementData(objectElement, "isRobbed") then
					local x, y, z = getElementPosition(objectElement)

					atmRobBlips[objectElement] = createBlip(x, y, z, 0, 2, 215, 89, 89)

					if isElement(atmRobBlips[objectElement]) then
						setElementData(atmRobBlips[objectElement], "blipTooltipText", "Üzemképtelen ATM")
					end

					outputChatBox("#d75959[SealMTA - ATM]: #FFFFFFFigyelem! Egy #d75959ATM#ffffff üzemképtelen (#4adfbf" .. getZoneName(x, y, z) .. "#FFFFFF).", 0, 0, 0, true)
				end
			end
		end
	end

	local seal_items = getResourceFromName("seal_items")

	for k, v in pairs(moneyCasetteBlips) do
        if isElement(v[1]) then
            destroyElement(v[1])
        end
    end

    moneyCasetteBlips = {}

    if seal_items then
        if getResourceState(seal_items) == "running" then
            local itemsRootElement = getResourceRootElement(seal_items)
            local moneyCasettes = getElementData(itemsRootElement, "moneyCasettes") or {}

            for k, v in pairs(moneyCasettes) do
                moneyCasetteBlips[k] = {false, 0, 0}
                moneyCasetteBlips[k][1] = createBlip(0, 0, 0, 0, 2, 191, 255, 0)

                if isElement(moneyCasetteBlips[k][1]) then
                    setElementData(moneyCasetteBlips[k][1], "blipTooltipText", "Pénzkazetta")
                end
            end
        end
    end

	local currVeh = getPedOccupiedVehicle(localPlayer)

	if currVeh then
		renderData.unitNumber = getElementData(currVeh, "unitNumber")
	end

	for k, veh in ipairs(getElementsByType("vehicle")) do
		local unitState = getElementData(veh, "unitState")
		local unitNumber = getElementData(veh, "unitNumber")

		if unitState and unitNumber then
			local groupId = getElementData(veh, "vehicle.group") or 0
			local groupPrefix = groupPrefixes[groupId] or "CIVIL"

			if unitState == "off" then
				if isElement(unitBlips[veh]) then
					destroyElement(unitBlips[veh])
				end

				if isTimer(unitTimers[veh]) then
					killTimer(unitTimers[veh])
				end
			elseif unitState == "patrol" then
				local x, y, z = getElementPosition(veh)

				if not isElement(unitBlips[veh]) then
					unitBlips[veh] = createBlip(x, y, z, 0, 2, 89, 142, 215)
					attachElements(unitBlips[veh], veh)
				end

				if isTimer(unitTimers[veh]) then
					killTimer(unitTimers[veh])
				end

				setBlipColor(unitBlips[veh], 89, 142, 215, 255)
				setElementData(unitBlips[veh], "blipTooltipText", unitNumber .. ". számú egység (járőr)")
			elseif unitState == "chase" then
				local x, y, z = getElementPosition(veh)

				if not isElement(unitBlips[veh]) then
					unitBlips[veh] = createBlip(x, y, z, 0, 2, 89, 142, 215)
					attachElements(unitBlips[veh], veh)
				end

				if isTimer(unitTimers[veh]) then
					killTimer(unitTimers[veh])
				end

				setBlipColor(unitBlips[veh], 89, 142, 215, 255)
				unitTimers[veh] = setTimer(blipTimer, 500, 0, unitBlips[veh])

				setElementData(unitBlips[veh], "blipTooltipText", unitNumber .. ". számú egység (üldözés)")
			elseif unitState == "action" then
				local x, y, z = getElementPosition(veh)

				if not isElement(unitBlips[veh]) then
					unitBlips[veh] = createBlip(x, y, z, 0, 2, 89, 142, 215)
					attachElements(unitBlips[veh], veh)
				end

				if isTimer(unitTimers[veh]) then
					killTimer(unitTimers[veh])
				end

				setBlipColor(unitBlips[veh], 89, 142, 215, 255)
				unitTimers[veh] = setTimer(blipTimer, 500, 0, unitBlips[veh])

				setElementData(unitBlips[veh], "blipTooltipText", unitNumber .. ". számú egység (akció)")
			end

			if veh == currVeh then
				renderData.unitState = unitState

				if renderData.unitState == "off" then
					renderData.unitStateStr = "#d75959off"
				elseif renderData.unitState == "patrol" then
					renderData.unitStateStr = "#4adfbfjárőr"
				elseif renderData.unitState == "chase" then
					renderData.unitStateStr = "#4adfbfüldözés"
				elseif renderData.unitState == "action" then
					renderData.unitStateStr = "#4adfbfakció"
				end
			end
		end
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if exports.seal_groups:isPlayerOfficer(localPlayer) then
			initMDCBlips()
		end
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		if panelState then
			exports.seal_hud:showHUD()
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if unitTimers[source] then
			if isTimer(unitTimers[source]) then
				killTimer(unitTimers[source])
			end

			unitTimers[source] = nil
		end

		if unitBlips[source] then
			if isElement(unitBlips[source]) then
				destroyElement(unitBlips[source])
			end

			unitBlips[source] = nil
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == localPlayer then
			if dataName == "player.groups" then
				for k, v in pairs(moneyCasetteBlips) do
					if isElement(v[1]) then
						destroyElement(v[1])
					end
				end

				moneyCasetteBlips = {}

				for k, v in pairs(atmRobBlips) do
					if isElement(v) then
						destroyElement(v)
					end
				end

				for k, v in pairs(unitBlips) do
					if isElement(v) then
						destroyElement(v)
					end
				end

				for k, v in pairs(unitTimers) do
					if isTimer(v) then
						killTimer(v)
					end
				end

				if exports.seal_groups:isPlayerOfficer(localPlayer) then
					initMDCBlips()
				end
			end
		end

		if dataName == "moneyCasettes" then
			if exports.seal_groups:isPlayerOfficer(localPlayer) then
				for k, v in pairs(moneyCasetteBlips) do
					if isElement(v[1]) then
						destroyElement(v[1])
					end
				end

				moneyCasetteBlips = {}

				local itemsRootElement = getResourceRootElement(getResourceFromName("seal_items"))
				local moneyCasettes = getElementData(itemsRootElement, "moneyCasettes") or {}

				for k, v in pairs(moneyCasettes) do
					moneyCasetteBlips[k] = {false, 0, 0}
					moneyCasetteBlips[k][1] = createBlip(0, 0, 0, 0, 2, 191, 255, 0)

					if isElement(moneyCasetteBlips[k][1]) then
						setElementData(moneyCasetteBlips[k][1], "blipTooltipText", "Pénzkazetta")
					end
				end
			end
		end

		if dataName == "isRobbed" then
			if exports.seal_groups:isPlayerOfficer(localPlayer) then
				if isElement(atmRobBlips[source]) then
					destroyElement(atmRobBlips[source])
				end

				atmRobBlips[source] = nil

				if getElementData(source, "isRobbed") then
					local x, y, z = getElementPosition(source)

					atmRobBlips[source] = createBlip(x, y, z, 0, 2, 215, 89, 89)

					if isElement(atmRobBlips[source]) then
						setElementData(atmRobBlips[source], "blipTooltipText", "Üzemképtelen ATM")
					end

					outputChatBox("#d75959[SealMTA - ATM]: #FFFFFFFigyelem! Egy #d75959ATM#ffffff üzemképtelen (#4adfbf" .. getZoneName(x, y, z) .. "#FFFFFF).", 0, 0, 0, true)
				end
			end
		end

		if dataName == "unitNumber" or dataName == "unitState" then
			if exports.seal_groups:isPlayerOfficer(localPlayer) then
				local dataVal = getElementData(source, dataName)
				local groupId = getElementData(source, "vehicle.group") or 0
				local groupPrefix = groupPrefixes[groupId] or "CIVIL"

				if dataName == "unitNumber" and mdcNotifications then
					if oldValue and not dataVal then
						policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. groupPrefix .. "-" .. oldValue .. ".#ffffff számú egység #4adfbffelbomlott#ffffff.")
					end

					if dataVal then
						policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. groupPrefix .. "-" .. dataVal .. ".#ffffff számú egység #4adfbflétrejött#ffffff.")
					end

					if isElement(unitBlips[source]) then
						destroyElement(unitBlips[source])
					end

					if isTimer(unitTimers[source]) then
						killTimer(unitTimers[source])
					end

					if source == getPedOccupiedVehicle(localPlayer) then
						renderData.unitNumber = dataVal
					end
				end

				if dataName == "unitState" then
					local unitNumber = getElementData(source, "unitNumber")

					if dataVal ~= oldValue and unitNumber and mdcNotifications then
						if dataVal == "off" or not dataVal then
							policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. unitNumber .. ".#ffffff számú egység #4adfbfkiállt a szolgálatból#ffffff.")

							if isElement(unitBlips[source]) then
								destroyElement(unitBlips[source])
							end

							if isTimer(unitTimers[source]) then
								killTimer(unitTimers[source])
							end
						elseif dataVal == "patrol" then
							local x, y, z = getElementPosition(source)

							policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. unitNumber .. ".#ffffff számú egység szolgálati állapota: #4adfbfjárőr#ffffff.")

							if not isElement(unitBlips[source]) then
								unitBlips[source] = createBlip(x, y, z, 0, 2, 89, 142, 215)
								attachElements(unitBlips[source], source)
							end

							if isTimer(unitTimers[source]) then
								killTimer(unitTimers[source])
							end

							setBlipColor(unitBlips[source], 89, 142, 215, 255)
							setElementData(unitBlips[source], "blipTooltipText", unitNumber .. ". számú egység (járőr)")
						elseif dataVal == "chase" and mdcNotifications then
							local x, y, z = getElementPosition(source)

							policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. unitNumber .. ".#ffffff számú egység szolgálati állapota: #4adfbfüldözés#ffffff.")

							if not isElement(unitBlips[source]) then
								unitBlips[source] = createBlip(x, y, z, 0, 2, 89, 142, 215)
								attachElements(unitBlips[source], source)
							end

							if isTimer(unitTimers[source]) then
								killTimer(unitTimers[source])
							end

							setBlipColor(unitBlips[source], 89, 142, 215, 255)
							unitTimers[source] = setTimer(blipTimer, 500, 0, unitBlips[source])

							setElementData(unitBlips[source], "blipTooltipText", unitNumber .. ". számú egység (üldözés)")
						elseif dataVal == "action" and mdcNotifications then
							local x, y, z = getElementPosition(source)

							policeMessage(firstToUpper(findTheArticle(groupPrefix)) .. " #d75959" .. unitNumber .. ".#ffffff számú egység szolgálati állapota: #4adfbfakció#ffffff.")

							if not isElement(unitBlips[source]) then
								unitBlips[source] = createBlip(x, y, z, 0, 2, 89, 142, 215)
								attachElements(unitBlips[source], source)
							end

							if isTimer(unitTimers[source]) then
								killTimer(unitTimers[source])
							end

							setBlipColor(unitBlips[source], 89, 142, 215, 255)
							unitTimers[source] = setTimer(blipTimer, 500, 0, unitBlips[source])

							setElementData(unitBlips[source], "blipTooltipText", unitNumber .. ". számú egység (akció)")
						end

						if source == getPedOccupiedVehicle(localPlayer) then
							renderData.unitState = dataVal

							if renderData.unitState == "off" or not dataVal then
								renderData.unitStateStr = "#d75959off"
							elseif renderData.unitState == "patrol" then
								renderData.unitStateStr = "#4adfbfjárőr"
							elseif renderData.unitState == "chase" then
								renderData.unitStateStr = "#4adfbfüldözés"
							elseif renderData.unitState == "action" then
								renderData.unitStateStr = "#4adfbfakció"
							end
						end
					end
				end
			end
		end
	end)

--[[addEventHandler("onClientVehicleExit", getRootElement(),
	function (leftPlayer)
		if leftPlayer == localPlayer then
			if getElementData(source, "unitState") then
				local occupants = getVehicleOccupants(source)
				local count = 0

				for k in pairs(occupants) do
					count = count + 1
				end

				if count < 1 then
					setElementData(source, "unitState", false)
				end
			end
		end
	end)]]

local vehicleList = {}
renderData.vehicleList = {}
renderData.wantedCarsOffset = 0

local peopleList = {}
renderData.peopleList = {}
renderData.wantedPeopleOffset = 0

local punishmentList = {}
renderData.punishmentList = {}
renderData.punishmentOffset = 0

local btkList = {
	{"#4adfbfMaximum kiszabható pénzbírság: #d75959750.000.000#4adfbf$ | Maximum börtönbüntetés: #d75959200#4adfbf perc.", ""},
	--{"#4adfbfPénzbírság orientált", ""},
	{"", ""},
	{"#d75959Közlekedési Szabálysértés", ""},
	{"   Forgalom Feltartása", "25 000 000$ | Nincs"},
	{"   Gondatlan Vezetés", "400.000 - 25 000 000$| Nincs"},
	{"   Közúti Veszélyeztetés", "25 000 000$ | Nincs"},
	{"   Tilosban Parkolás", "25 000 000$ | Nincs"},
	{"   Tilos Jelzésen Való Áthaladás", "25 000 000$ | Nincs"},
	{"   Bukósisak Hiánya", "25 000 000$ | Nincs"},
	{"   Kanyarodási szabályok megszegése", "25 000 000$ | Nincs"},
	{"   Kanyarodási szándék jelzésének elmulasztása", "25 000 000$ | Nincs"},
	{"   Cserbenhagyásos gázolás", "25 000 000$ | 10 perc"},
	{"   Kötelező Felszerelés Hiánya", "10 000 000$ | Nincs"},
	{"   Fényszóró Használtának Mulasztása", "10 000 000$ | Nincs"},
	{"   Biztonsági öv Használatának Mulasztása", "10 000 000$ | Nincs"},
	{"   Mobiltelefon Használata Vezetéskor", "10 000 000$ | Nincs"},
	{"   Nem rendelkezik jogosítvánnyal", "15 000 000$ | Nincs"},
	{"   Nem rendelkezik forgalmi engedélyel", "15 000 000$ | Nincs"},
	{"   Járművezetés Ittas Állapotban", "15 000 000$ | 10 perc"},
	{"   Járművezetés Eltiltás Hatálya Alatt", "15 000 000$ | 10 perc"},
	{"   Helytelen Járműabroncs Használata", "15 000 000$ | Nincs"},
	{"   Közlekedési Korlátozás Megszegése", "15 000 000$ | Nincs"},
	{"", ""},
	{"#d75959Megengedett Sebesség Túllépése", ""},
	{"   Gyorshajtás Lakott Területen (50km/h)", "4 000 000$ | Nincs"},
	{"   Gyorshajtás Országúton (90km/h)", "16 000 000$ | Nincs"},
	{"   Gyorshajtás Autópályán (120km/h)", "25 000 000$ | Nincs"}, -- gergő anyxját innen
	{"", ""},
	{"#d75959Egyéb Közlekedésre Vonatkozó Szabálysértések", ""},
	{"   Illegális Autóalkatrész", "10 000 000$ | Nincs"},
	{"   Rongált Járművel Való Közlekedés", "10.000.000 $ | Nincs"},
	{"", ""},
	{"#d75959Enyhébb Szabálysértések", ""},
	{"   Személyi Igazolvány Hiánya", "10 000 000$ | Nincs"},
	{"   Útlevél Hiánya", "10 000 000$ | Nincs"},
	{"   Rendőrrel Szembeni Tiszteletlenség", "25 000 000$ | Nincs"},
	{"", ""},
	{"#d75959Vétségek", ""},
	{"   Segítségnyújtás elmulasztása", "10 000 000$ | 10 perc"},
	{"   Közerkölcs megsértése", "11 000 000$ | 10 perc"},
	{"   Rongálás", "12 000 000$ | 10 perc"},
	{"   Lopás", "20.000.000 $ | 60 perc"},
	{"   Benzinlopás", "14 000 000$ | 20 perc"},
	{"   Autólopás", "15 000 000$ | 25 perc"},
	{"", ""},
	{"#d75959Igazságszolgáltatás Elleni Bűncselekmények", ""},
	{"   Hamis Vád", "8 000 000$ | 10 perc"},
	{"   Hatóság Félrevezetése", "18 000 000$ | 60 perc"},
	{"   Célravezető Bizonyíték Eltitkolása", "5 000 000$ | 10 perc"},
	{"   Okirathamisítás", "60.000 000$ | 60 perc"},
	{"   Fogolyszökés/Fogolyszöktetés", "15 000 000$ | 10 perc"},
	{"   Korrupció", "10 000 000$ | 120 perc"},
	{"   Nyomozás Szándékos Félrevezetése", "75 000 000$ | 40 perc"},
	{"   Parancsmegtagadás", "10 000 000$ | Nincs"},
	{"", ""},
	{"#d75959Köznyugalom Elleni Bűncselekmények", ""},
	{"   Rendbontás", "900.000$ | 10 perc"},
	{"   Kábítószer Birtoklás", "300.000$ / db | 10 perc"},
	{"   Kábítószer Árusítás", "2.700.000$ | 10 perc"},
	{"   Kábítószer Termesztés", "300.000$ | 10 perc"},
	{"", ""},
	{"#d75959Emberi Szabadság Elleni Bűncselekmények", ""},
	{"   Emberrablás", "60 000 000$ | 40 perc"},
	{"   Emberrablás Feljelentésének Mulasztása", "3 000 000$ | 30 perc"},
	{"   Emberkereskedelem", "50 000 000$ | 30 perc"},
	{"   Személyi Szabadság Megsértése", "1 300 000$ | 10 perc"},
	{"", ""},
	{"#d75959Emberi Méltóság és Alapvető Jogok Elleni Bűncselekmények", ""},
	{"   Személyes Adattal Való Visszaélés", "10 000 000$ | 10 perc"},
	{"   Magánlaksértés", "10 000 000$ | 10 perc"},
	{"   Zaklatás", "10 000 000$ | 10 perc"},
	{"", ""},
	{"#d75959Közbiztonság Elleni Bűncselekmények", ""},
	{"   Terrorcselekmény", "60 000 000$ | 60 perc"},
	{"   Terrorcselekmény Feljelentésének Mulasztása", "4.000.000$ | 40 perc"},
	{"   Bűnszövetkezetben való részvétel", "85 200 000$ | 120 perc"},
	{"   Illegális Fegyver Birtoklása", "15 000 000$ | 40 perc"},
	{"   Illegális Fegyver Kereskedelem", "10 200 000$ | 30 perc"},
	{"   Illegális Alkotóelem Birtoklása", "2 000 000$ | 20 perc"},
	{"   Illegális Fegyvertár Birtoklása", "250 000$ / db | 30 perc"},
	{"   Rendvédelem Előli Menekülés", "10 000 000$ | 40 perc"},
	{"   Rendvédelmi Utasítás Megszegése", "1 000 000$ | 20 perc"},
	{"   Rablás", "15 000 000$ | 40 perc"},
	{"   Bűnrészesség", "10 000 000$ | 40 perc"},
	{"", ""},
}
renderData.btkList = btkList
renderData.btkOffset = 0

renderData.unitState = "off"
renderData.unitStateStr = "#d75959off"

addCommandHandler("mdc",
	function ()
		if isPedInVehicle(localPlayer) and exports.seal_groups:isPlayerOfficer(localPlayer) then
			if getPedOccupiedVehicleSeat(localPlayer) == 0 or getPedOccupiedVehicleSeat(localPlayer) == 1 then
				local currVeh = getPedOccupiedVehicle(localPlayer)
				if groupPrefixes[getElementData(currVeh, "vehicle.group")] then
					local groupId = getElementData(currVeh, "vehicle.group") or 0

					if groupId > 0 then
						panelState = not panelState

						if lastVehicle ~= currVeh then
							loggedInMDC = false
							currentPage = "login"
						end

						lastVehicle = currVeh

						activeButton = false
						activeFakeInput = false
						fakeInputValue = {}
						caretIndex = false
						inputError = false
						renderData.whatKindOfGroup = groupPrefixes[groupId] or "CIVIL"

						if panelState then
							renderData.unitNumber = getElementData(currVeh, "unitNumber")
							renderData.unitState = getElementData(currVeh, "unitState")

							if renderData.unitState == "off" then
								renderData.unitStateStr = "#d75959off"
							elseif renderData.unitState == "patrol" then
								renderData.unitStateStr = "#4adfbfjárőr"
							elseif renderData.unitState == "chase" then
								renderData.unitStateStr = "#4adfbfüldözés"
							elseif renderData.unitState == "action" then
								renderData.unitStateStr = "#4adfbfakció"
							end

							createFonts()
							--showCursor(true)
							renderMove = false
							playSound("files/sounds/mdcon.mp3")
						else
							destroyFonts()
							--showCursor(false)
							playSound("files/sounds/mdcoff.mp3")
							renderMove = false
						end
					end
				end
			end
		end
	end)

function closeMDC()
	panelState = false
	activeButton = false
	activeFakeInput = false
	fakeInputValue = {}
	caretIndex = false
	inputError = false

	destroyFonts()
	--showCursor(false)
	playSound("files/sounds/mdcoff.mp3")

	renderMove = false
end

local renderMove = false

local loggedPos = {
	x = screenX / 2 - 1000 / 2,
	y = screenY / 2 - 675 / 2
}

addEventHandler("onClientRender", getRootElement(),
	function ()
		for k in pairs(moneyCasetteBlips) do
            if not (getElementDimension(k) or false) then
                return
            end
            local currentDimension = getElementDimension(k)

            if currentDimension ~= moneyCasetteBlips[k][2] then
                moneyCasetteBlips[k][2] = currentDimension

                if moneyCasetteBlips[k][2] ~= 0 then
                    local interiorX, interiorY, interiorZ = exports.seal_interiors:getInteriorEntrancePosition(currentDimension)

                    setElementPosition(moneyCasetteBlips[k][1], interiorX, interiorY, interiorZ)
                end
            elseif moneyCasetteBlips[k][2] == 0 then
                local currentX, currentY, currentZ = getElementPosition(k)

                setElementPosition(moneyCasetteBlips[k][1], currentX, currentY, currentZ)
            end
        end

		if panelState then
			local currVeh = getPedOccupiedVehicle(localPlayer)

			buttons = {}

			if renderMove then
				local cursorX, cursorY = getCursorPosition()
				local posX, posY = cursorX * screenX - posOffSetX, cursorY * screenY - posOffSetY
				loggedPos = {
					x = posX,
					y = posY
				}
			end
			
			if not currVeh then
				closeMDC()
				return
			end

			local groupType = renderData.whatKindOfGroup
			

			-- ** Panel wardis
			local sx, sy = 400, 315

			if currentPage ~= "login" then
				sx, sy = 1000, 675
			end
			if currentPage ~= "login" then
				x = loggedPos.x
				y = loggedPos.y
			else
				x = screenX / 2 - sx / 2
				y = screenY / 2 - sy / 2
			end
			local margin = 10

			-- ** Háttér
			dxDrawRectangle(x, y, sx, sy, tocolor(32, 32, 32))
			drawRectangleOutline(x, y, sx, sy, tocolor(81, 81, 81))

			-- ** Cím
			dxDrawRectangle(x, y, sx, 40, tocolor(64, 64, 64))
			dxDrawText("Mobile Data Computer", x + margin, y, 0, y + 40, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")

			-- Kilépés
			buttons["exit"] = {x + sx - 45, y, 45, 39}

			if activeButton == "exit" then
				dxDrawRectangle(x + sx - 45, y, 45, 39, tocolor(232, 17, 35))
			end

			dxDrawImage(math.floor(x + sx - 45 / 2 - 30 / 2), math.floor(y + 39 / 2 - 30 / 2), 30, 30, "files/images/icons/close.png")

			y = y + 40

			-- ** Content
			if currentPage == "login" then
				local inputWidth = sx - margin * 4
				local inputHeight = 35

				dxDrawText("Kérjük, jelentkezzen be alább\na számítógép eléréséhez.", x, y, x + sx, y + 100, tocolor(255, 255, 255), 1, RubikL, "center", "center")

				y = y + 100

				drawInput("username|24", "Felhasználónév", x + margin * 2, y, inputWidth - margin * 3, inputHeight, "files/images/icons/user.png")

				y = y + inputHeight + margin

				drawInput("password|24|hash", "Jelszó", x + margin * 2, y, inputWidth - margin * 3, inputHeight, "files/images/icons/key.png")

				y = y + inputHeight + margin * 3

				drawButton("login", "Bejelentkezés", x + sx / 2 - inputWidth / 2, y, inputWidth, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
			else
				local holderSize = sx / #availableTabs
				local contentSize = sx - holderSize

				dxDrawRectangle(x, y, holderSize, sy - 40, tocolor(0, 0, 0, 00))
				dxDrawRectangle(x + holderSize - 1, y, 1, sy - 40, tocolor(50, 50, 50))
				dxDrawRectangle(x + holderSize, y, contentSize, 30, tocolor(0, 0, 0))

				if renderData.unitNumber then
					local startY = y + (sy - 40) / 2 - (40*7 + margin*6) / 2

					dxDrawText("Egységszám: #4adfbf" .. renderData.unitNumber, x, startY, x + holderSize, startY + 40, tocolor(255, 255, 255), 0.75, Rubik, "center", "center", false, false, false, true)
					startY = startY + 40 + margin

					drawButton("delUnit", "Egységcsere", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					startY = startY + 40 + margin

					dxDrawText("Szolgálat: " .. renderData.unitStateStr, x, startY, x + holderSize, startY + 40, tocolor(255, 255, 255), 0.85, Rubik, "center", "center", false, false, false, true)
					startY = startY + 40 + margin

					drawButton("setUnitState:off", "OFF", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(180, 45, 45), tocolor(200, 60, 60), tocolor(200, 80, 80))
					startY = startY + 40 + margin

					drawButton("setUnitState:patrol", "Járőr", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					startY = startY + 40 + margin

					drawButton("setUnitState:chase", "Üldözés", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					startY = startY + 40 + margin

					drawButton("setUnitState:action", "Akció", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
				else
					local startY = y + (sy - 40) / 2 - (40*3 + margin*3) / 2

					dxDrawText("Add meg az egységszámot:", x, startY, x + holderSize, startY + 40, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")
					startY = startY + 40 + margin

					drawInput("unitNum|8", "Egység", x + margin * 2, startY, holderSize - margin * 4, 40)
					startY = startY + 40 + margin * 2

					drawButton("enterUnit", "Megad", x + margin * 2, startY, holderSize - margin * 4, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
				end

				local oneTabSize = holderSize * 3 / 4

				for i = 1, #availableTabs do
					local tabX = x + holderSize + oneTabSize * (i - 1)
					local tab = availableTabs[i]

					if currentPage == tab.name then
						dxDrawRectangle(tabX, y, oneTabSize, 30, tocolor(84, 84, 84))
					else
						if activeButton == "setCurrentPage:" .. tab.name then
							dxDrawRectangle(tabX, y, oneTabSize, 30, tocolor(75, 75, 75))
						end

						buttons["setCurrentPage:" .. tab.name] = {tabX, y, oneTabSize, 30}
					end

					dxDrawText(tab.title, tabX, y, tabX + oneTabSize, y + 30, tocolor(255, 255, 255), 0.7, Rubik, "center", "center", false, false, false, false, true)
				end

				y = y + 30

				if currentPage == "wantedCars" then
					local startX = x + holderSize
					local startY = y + margin

					-- Oszlopok
					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					dxDrawText("Típus", startX + margin * 2, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 250, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Rendszám", startX + margin * 2 + 250, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 350, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Indok", startX + margin * 2 + 350, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")

					-- Tartalom
					local tabNum = 9
					local oneSize = 25

					startY = startY + 35

					for i = 1, tabNum do
						local rowY = startY + oneSize * (i - 1)

						if i % 2 == 0 then
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(0, 0, 0, 25))
						else
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 10))
						end

						local record = renderData.vehicleList[i + renderData.wantedCarsOffset]

						if record then
							if renderData.editingVehicle == record.id then
								dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(5, 115, 195, 150))
							elseif activeButton == "editVehicle:" .. i + renderData.wantedCarsOffset then
								dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 15))
							end

							buttons["editVehicle:" .. i + renderData.wantedCarsOffset] = {startX + margin, rowY, contentSize - margin * 4 - 22, oneSize}

							dxDrawText(record.type, startX + margin * 2, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.plate, startX + margin * 2 + 250, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.reason, startX + margin * 2 + 350, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")

							if activeButton == "delReportVehicle:" .. record.id .. ":" .. record.plate then
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png", 0, 0, 0, tocolor(232, 17, 35))
							else
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png")
							end

							buttons["delReportVehicle:" .. record.id .. ":" .. record.plate] = {startX + contentSize - margin * 2 - 22, rowY, 22, 22}
						end
					end

					local listHeight = tabNum * oneSize

					if #renderData.vehicleList > tabNum then
						local gripSize = listHeight / #renderData.vehicleList

						dxDrawRectangle(startX + contentSize - margin - 5, startY, 5, listHeight, tocolor(75, 75, 75))
						dxDrawRectangle(startX + contentSize - margin - 5, startY + renderData.wantedCarsOffset * gripSize, 5, tabNum * gripSize, tocolor(125, 125, 125))
					end

					drawRectangleOutline(startX + margin, y + margin, contentSize - margin * 2, 35 + listHeight, tocolor(50, 50, 50))

					startY = startY + listHeight

					-- Kereső mező
					startY = startY + margin

					drawInput("searchByPlate|8", "Keresés rendszám alapján...", startX + margin + 2, startY + 2, contentSize - 150 - margin * 2 - 4, 40 - 4, false, "files/images/icons/search.png")
					drawButton("searchByPlate", "Keresés", startX + contentSize - 150 - margin, startY, 150, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))

					-- Körözés kiadás
					startY = startY + 40 + margin

					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					if renderData.editingVehicle then
						dxDrawText("Körözés szerkesztése (" .. renderData.editingVehiclePlate .. ")", startX, startY, startX + contentSize, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")
					else
						dxDrawText("Körözés kiadása", startX, startY, startX + contentSize, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")
					end

					startY = startY + 35 + margin

					drawInput("addReportVehicleType|48", "Jármű típusa", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/car.png")

					startY = startY + 40 + margin

					drawInput("addReportVehiclePlate|8", "Jármű rendszáma", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/plate.png")

					startY = startY + 40 + margin

					drawInput("addReportReason|60", "Indoklás", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/pencil.png")

					startY = startY + 40 + margin * 1.5

					if renderData.editingVehicle then
						local buttonSize = (contentSize - margin * 3) / 2

						drawButton("cancelReportVehicle", "Mégsem", startX + margin, startY, buttonSize, 40, tocolor(180, 45, 45), tocolor(200, 60, 60), tocolor(200, 80, 80))

						drawButton("editReportVehicle", "Körözés szerkesztése", startX + margin * 2 + buttonSize, startY, buttonSize, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					else
						drawButton("addReportVehicle", "Körözés kiadása", startX + margin, startY, contentSize - margin * 2, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					end
				end

				if currentPage == "wantedPeople" then
					local startX = x + holderSize
					local startY = y + margin

					-- Oszlopok
					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					dxDrawText("Név", startX + margin * 2, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 250, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Indok", startX + margin * 2 + 250, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")

					-- Tartalom
					local tabNum = 9
					local oneSize = 25

					startY = startY + 35

					for i = 1, tabNum do
						local rowY = startY + oneSize * (i - 1)

						if i % 2 == 0 then
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(0, 0, 0, 25))
						else
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 10))
						end

						local record = renderData.peopleList[i + renderData.wantedPeopleOffset]

						if record then
							if renderData.editingPerson == record.id then
								dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(5, 115, 195, 150))
							elseif activeButton == "editPerson:" .. i + renderData.wantedPeopleOffset then
								dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 15))
							end

							buttons["editPerson:" .. i + renderData.wantedPeopleOffset] = {startX + margin, rowY, contentSize - margin * 4 - 22, oneSize}

							dxDrawText(record.name, startX + margin * 2, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.reason, startX + margin * 2 + 250, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")

							if activeButton == "delReportPerson:" .. record.id then
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png", 0, 0, 0, tocolor(232, 17, 35))
							else
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png")
							end

							buttons["delReportPerson:" .. record.id] = {startX + contentSize - margin * 2 - 22, rowY, 22, 22}
						end
					end

					local listHeight = tabNum * oneSize

					if #renderData.peopleList > tabNum then
						local gripSize = listHeight / #renderData.peopleList

						dxDrawRectangle(startX + contentSize - margin - 5, startY, 5, listHeight, tocolor(75, 75, 75))
						dxDrawRectangle(startX + contentSize - margin - 5, startY + renderData.wantedPeopleOffset * gripSize, 5, tabNum * gripSize, tocolor(125, 125, 125))
					end

					drawRectangleOutline(startX + margin, y + margin, contentSize - margin * 2, 35 + listHeight, tocolor(50, 50, 50))

					startY = startY + listHeight

					-- Kereső mező
					startY = startY + margin

					drawInput("searchByName|30", "Keresés név alapján...", startX + margin + 2, startY + 2, contentSize - 150 - margin * 2 - 4, 40 - 4, false, "files/images/icons/search.png")
					drawButton("searchByName", "Keresés", startX + contentSize - 150 - margin, startY, 150, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))

					-- Körözés kiadás
					startY = startY + 40 + margin

					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					if renderData.editingPerson then
						dxDrawText("Körözés szerkesztése (" .. renderData.editingPersonName .. ")", startX, startY, startX + contentSize, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")
					else
						dxDrawText("Körözés kiadása", startX, startY, startX + contentSize, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")
					end

					startY = startY + 35 + margin

					drawInput("addReportPersonName|30", "Személy neve", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/user.png")

					startY = startY + 40 + margin

					drawInput("addReportReason|60", "Indok", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/pencil.png")

					startY = startY + 40 + margin

					drawInput("addReportPersonVisual|60", "Személyleírás", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/pencil.png")

					startY = startY + 40 + margin * 1.5

					if renderData.editingPerson then
						local buttonSize = (contentSize - margin * 3) / 2

						drawButton("cancelReportPerson", "Mégsem", startX + margin, startY, buttonSize, 40, tocolor(180, 45, 45), tocolor(200, 60, 60), tocolor(200, 80, 80))

						drawButton("editReportPerson", "Körözés szerkesztése", startX + margin * 2 + buttonSize, startY, buttonSize, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					else
						drawButton("addReportPerson", "Körözés kiadása", startX + margin, startY, contentSize - margin * 2, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
					end
				end

				if currentPage == "punishedPeople" then
					local startX = x + holderSize
					local startY = y + margin

					-- Oszlopok
					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					dxDrawText("Név", startX + margin * 2, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 200, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Bírság", startX + margin * 2 + 200, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 275, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Börtönbüntetés", startX + margin * 2 + 275, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawRectangle(startX + margin + 400, startY, 1, 35, tocolor(100, 100, 100))

					dxDrawText("Indok", startX + margin * 2 + 400, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")

					-- Tartalom
					local tabNum = 7
					local oneSize = 25

					startY = startY + 35

					for i = 1, tabNum do
						local rowY = startY + oneSize * (i - 1)

						if i % 2 == 0 then
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(0, 0, 0, 25))
						else
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 10))
						end

						local record = renderData.punishmentList[i + renderData.punishmentOffset]

						if record then
							dxDrawText(record.name, startX + margin * 2, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.ticket, startX + margin * 2 + 200, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.jail, startX + margin * 2 + 275, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
							dxDrawText(record.reason, startX + margin * 2 + 400, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")

							if activeButton == "delPunishment:" .. record.id then
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png", 0, 0, 0, tocolor(232, 17, 35))
							else
								dxDrawImage(math.floor(startX + contentSize - margin * 2 - 22), math.floor(rowY + oneSize / 2 - 11), 22, 22, "files/images/icons/close.png")
							end

							buttons["delPunishment:" .. record.id] = {startX + contentSize - margin * 2 - 22, rowY, 22, 22}
						end
					end

					local listHeight = tabNum * oneSize

					if #renderData.punishmentList > tabNum then
						local gripSize = listHeight / #renderData.punishmentList

						dxDrawRectangle(startX + contentSize - margin - 5, startY, 5, listHeight, tocolor(75, 75, 75))
						dxDrawRectangle(startX + contentSize - margin - 5, startY + renderData.punishmentOffset * gripSize, 5, tabNum * gripSize, tocolor(125, 125, 125))
					end

					drawRectangleOutline(startX + margin, y + margin, contentSize - margin * 2, 35 + listHeight, tocolor(50, 50, 50))

					startY = startY + listHeight

					-- Kereső mező
					startY = startY + margin

					drawInput("searchPunishment|30", "Keresés név alapján...", startX + margin + 2, startY + 2, contentSize - 150 - margin * 2 - 4, 40 - 4, false, "files/images/icons/search.png")
					drawButton("searchPunishment", "Keresés", startX + contentSize - 150 - margin, startY, 150, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))

					-- Körözés kiadás
					startY = startY + 40 + margin

					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))
					dxDrawText("Büntetés hozzáadása", startX, startY, startX + contentSize, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "center", "center")

					startY = startY + 35 + margin

					drawInput("addPunishmentName|30", "Személy neve", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/user.png")

					startY = startY + 40 + margin

					drawInput("addPunishmentTicket|8", "Bírság", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/dollar.png")

					startY = startY + 40 + margin

					drawInput("addPunishmentJail|8", "Börtönbüntetés", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/clock.png")

					startY = startY + 40 + margin

					drawInput("addPunishmentReason|30", "Indok", startX + margin + 2, startY + 2, contentSize - margin * 2 - 32 - 4, 40 - 4, "files/images/icons/pencil.png")

					startY = startY + 40 + margin * 1.5

					drawButton("addPunishment", "Büntetés hozzáadása", startX + margin, startY, contentSize - margin * 2, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
				end

				if currentPage == "btk" then
					local startX = x + holderSize
					local startY = y + margin

					-- Oszlopok
					dxDrawRectangle(startX + margin, startY, contentSize - margin * 2, 35, tocolor(25,25,25))

					dxDrawText("Büntetés", startX + margin * 2, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")
					dxDrawText("[Pénzbírság | Börtönbüntetés]", startX + margin * 2 + 400, startY, 0, startY + 35, tocolor(255, 255, 255), 0.75, Rubik, "left", "center")

					-- Tartalom
					local tabNum = 19
					local oneSize = 25

					startY = startY + 35

					for i = 1, tabNum do
						local rowY = startY + oneSize * (i - 1)

						if i % 2 == 0 then
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(0, 0, 0, 25))
						else
							dxDrawRectangle(startX + margin, rowY, contentSize - margin * 2, oneSize, tocolor(255, 255, 255, 10))
						end

						local dat = renderData.btkList[i + renderData.btkOffset]

						if dat then
							dxDrawText(dat[1], startX + margin * 2, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center", false, false, false, true)
							dxDrawText(dat[2], startX + margin * 2 + 400, rowY, startX + contentSize, rowY + oneSize, tocolor(255, 255, 255), 0.65, Rubik, "left", "center")
						end
					end

					local listHeight = tabNum * oneSize

					if #renderData.btkList > tabNum then
						local gripSize = listHeight / #renderData.btkList

						dxDrawRectangle(startX + contentSize - margin - 5, startY, 5, listHeight, tocolor(75, 75, 75))
						dxDrawRectangle(startX + contentSize - margin - 5, startY + renderData.btkOffset * gripSize, 5, tabNum * gripSize, tocolor(125, 125, 125))
					end

					drawRectangleOutline(startX + margin, y + margin, contentSize - margin * 2, 35 + listHeight, tocolor(50, 50, 50))

					startY = startY + listHeight

					-- Kereső mező
					startY = startY + margin

					drawInput("searchBTK|30", "Keresés büntetés alapján...", startX + margin + 2, startY + 2, contentSize - 150 - margin * 2 - 4, 40 - 4, false, "files/images/icons/search.png")
					drawButton("searchBTK", "Keresés", startX + contentSize - 150 - margin, startY, 150, 40, tocolor(51, 51, 51), tocolor(5, 115, 195), tocolor(105, 160, 200))
				end
			end

			-- ** Gombok
			local cx, cy = getCursorPosition()

			activeButton = false

			if cx and cy then
				cx = cx * screenX
				cy = cy * screenY

				for k, v in pairs(buttons) do
					if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
						activeButton = k
						break
					end
				end
			end
		end
	end, true, "low-999")

local loginClickTick = 0

addEvent("onClientGotMDCData", true)
addEventHandler("onClientGotMDCData", getRootElement(),
	function (data)
		currentPage = "wantedCars"
		loggedInMDC = data
		playSound("files/sounds/login.mp3")
	end)

addEvent("onClientGotMDCVehicles", true)
addEventHandler("onClientGotMDCVehicles", getRootElement(),
	function (data)
		if loggedInMDC then
			vehicleList = data
			renderData.vehicleList = vehicleList
		end
	end)

local backupBlips = {}

addEvent("createBlipForOfficers", true)
addEventHandler("createBlipForOfficers", getRootElement(),
	function (player, reason)
		if exports.seal_groups:isPlayerOfficer(localPlayer) then
			if reason then
				backupBlips[player] = createBlip(0, 0, 0, 0, 2, 215, 89, 89)
				setElementData(backupBlips[player], "blipTooltipText", "Erősítés ("..reason..")")
				attachElements(backupBlips[player], player)
				
				if backupSoundState then
					playSound("files/sounds/backup.mp3")
				end
			else
				if isElement(backupBlips[player]) then
					destroyElement(backupBlips[player])
				end
			end
		end
	end)

addEvent("createBlipMessage", true)
addEventHandler("createBlipMessage", getRootElement(),
	function(sourcePlayer)
		exports.seal_chat:localActionC(sourcePlayer, "erősítést hívott.")
end)

addEvent("destroyBlipMessage", true)
addEventHandler("destroyBlipMessage", getRootElement(),
	function(sourcePlayer)
		exports.seal_chat:localActionC(sourcePlayer, "lemondta az erősítést.")
end)

addEvent("createBlipForOfficers", true)
addEventHandler("createBlipForOfficers", getRootElement(),
	function (data)
		if loggedInMDC then
			peopleList = data
			renderData.peopleList = peopleList
		end
	end)

	addEvent("onClientGotMDCPeople", true)
addEventHandler("onClientGotMDCPeople", getRootElement(),
	function (data)
		if loggedInMDC then
			peopleList = data
			renderData.peopleList = peopleList
		end
	end)

addEvent("onClientGotMDCPunishment", true)
addEventHandler("onClientGotMDCPunishment", getRootElement(),
	function (data)
		if loggedInMDC then
			punishmentList = data
			renderData.punishmentList = punishmentList
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if panelState then
			if button == "left" and state == "down" then
				if isCursorInPos(loggedPos.x - 50, loggedPos.y, 1000, 40) then
					local cursorX, cursorY = getCursorPosition()
					posOffSetX, posOffSetY = cursorX * screenX - loggedPos.x, cursorY * screenY - loggedPos.y
					renderMove = true
				end
			elseif button == "left" and state == "up" then
				renderMove = false
			end
			
			if button == "left" then
				if activeButton then
					local selected = split(activeButton, ":")

					if state == "down" then
						if inputError == "searchByPlate|8" then
							renderData.vehicleList = vehicleList
						elseif inputError == "searchByName|30" then
							renderData.peopleList = peopleList
						elseif inputError == "searchPunishment|30" then
							renderData.punishmentList = punishmentList
						elseif inputError == "searchBTK|30" then
							renderData.btkList = btkList
						end

						activeFakeInput = false

						if selected[1] == "setFakeInput" then
							activeFakeInput = selected[2]
							caretIndex = false
							inputError = false
						end

						if selected[1] == "exit" then
							closeMDC()
						end
					else
						if selected[1] == "login" then
							local elapsedTime = getTickCount() - loginClickTick

							if elapsedTime >= 10000 then
								if utf8.len(fakeInputValue["username|24"]) < 1 or utf8.len(fakeInputValue["password|24|hash"]) < 1 then
									exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
								else
									loginClickTick = getTickCount()
									triggerServerEvent("tryToLoginMDC", localPlayer, fakeInputValue["username|24"], sha256(fakeInputValue["password|24|hash"]))
									fakeInputValue = {}
								end
							else
								exports.seal_accounts:showInfo("e", "Várj még " .. 10 - math.floor(elapsedTime / 1000) .. " másodpercet az újrapróbálkozásig!")
							end
						end

						if selected[1] == "setCurrentPage" then
							currentPage = selected[2]
							playSound("files/sounds/mdcnavklikk.mp3")
						end

						if selected[1] == "enterUnit" then
							if string.len(fakeInputValue["unitNum|8"]) >= 1 then
								setElementData(getPedOccupiedVehicle(localPlayer), "unitNumber", fakeInputValue["unitNum|8"])
								renderData.unitNumber = fakeInputValue["unitNum|8"]
								fakeInputValue = {}
								playSound("files/sounds/mdcsetgroup.mp3")
							end
						elseif selected[1] == "delUnit" then
							setElementData(getPedOccupiedVehicle(localPlayer), "unitNumber", false)
							renderData.unitNumber = false
							fakeInputValue = {}
							playSound("files/sounds/mdcnavklikk.mp3")
						elseif selected[1] == "setUnitState" then
							local state = selected[2]

							if state ~= renderData.unitState then

								if state == "off" then
									playSound("files/sounds/mdcnavklikk.mp3")
								elseif state == "patrol" then
									playSound("files/sounds/mdcpatrol.mp3")
								elseif state == "chase" then
									playSound("files/sounds/mdcnavklikk.mp3")
								elseif state == "action" then
									playSound("files/sounds/mdcaction.mp3")
								end

								setElementData(getPedOccupiedVehicle(localPlayer), "unitState", state)
							end
						end

						if selected[1] == "addReportVehicle" then
							local vehtype = fakeInputValue["addReportVehicleType|48"]
							local plate = fakeInputValue["addReportVehiclePlate|8"]
							local reason = fakeInputValue["addReportReason|60"]

							if utf8.len(vehtype) < 1 or utf8.len(plate) < 1 or utf8.len(reason) < 1 then
								exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
							else
								triggerServerEvent("addReportVehicle", localPlayer, vehtype, plate, reason)

								fakeInputValue = {}
							end
						elseif selected[1] == "delReportVehicle" then
							triggerServerEvent("delReportVehicle", localPlayer, tonumber(selected[2]), selected[3])
						end

						if selected[1] == "editVehicle" then
							local offset = tonumber(selected[2])

							renderData.editingVehicle = renderData.vehicleList[offset].id
							renderData.editingVehiclePlate = renderData.vehicleList[offset].plate

							fakeInputValue["addReportVehicleType|48"] = renderData.vehicleList[offset].type
							fakeInputValue["addReportVehiclePlate|8"] = renderData.vehicleList[offset].plate
							fakeInputValue["addReportReason|60"] = renderData.vehicleList[offset].reason
						elseif selected[1] == "editReportVehicle" then
							local vehtype = fakeInputValue["addReportVehicleType|48"]
							local plate = fakeInputValue["addReportVehiclePlate|8"]
							local reason = fakeInputValue["addReportReason|60"]

							if utf8.len(vehtype) < 1 or utf8.len(plate) < 1 or utf8.len(reason) < 1 then
								exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
							else
								triggerServerEvent("editReportVehicle", localPlayer, renderData.editingVehicle, vehtype, plate, reason)

								renderData.editingVehicle = false
								renderData.editingVehiclePlate = false
								fakeInputValue = {}
							end
						elseif selected[1] == "cancelReportVehicle" then
							renderData.editingVehicle = false
							renderData.editingVehiclePlate = false
							fakeInputValue = {}
						end

						if selected[1] == "addReportPerson" then
							local name = fakeInputValue["addReportPersonName|30"]
							local reason = fakeInputValue["addReportReason|60"]
							local visual = fakeInputValue["addReportPersonVisual|60"]

							if utf8.len(name) < 1 or utf8.len(reason) < 1 or utf8.len(visual) < 1 then
								exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
							else
								triggerServerEvent("addReportPerson", localPlayer, name, reason, visual)

								fakeInputValue = {}
							end
						elseif selected[1] == "delReportPerson" then
							local id = tonumber(selected[2])

							if id == renderData.editingPerson then
								renderData.editingPerson = false
								renderData.editingPersonName = false
								fakeInputValue = {}
							end

							triggerServerEvent("delReportPerson", localPlayer, id)
						end

						if selected[1] == "editPerson" then
							local offset = tonumber(selected[2])

							renderData.editingPerson = renderData.peopleList[offset].id
							renderData.editingPersonName = renderData.peopleList[offset].name

							fakeInputValue["addReportPersonName|30"] = renderData.peopleList[offset].name
							fakeInputValue["addReportReason|60"] = renderData.peopleList[offset].reason
							fakeInputValue["addReportPersonVisual|60"] = renderData.peopleList[offset].description
						elseif selected[1] == "editReportPerson" then
							local name = fakeInputValue["addReportPersonName|30"]
							local reason = fakeInputValue["addReportReason|60"]
							local visual = fakeInputValue["addReportPersonVisual|60"]

							if utf8.len(name) < 1 or utf8.len(reason) < 1 or utf8.len(visual) < 1 then
								exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
							else
								triggerServerEvent("editReportPerson", localPlayer, renderData.editingPerson, name, reason, visual)

								renderData.editingPerson = false
								renderData.editingPersonName = false
								fakeInputValue = {}
							end
						elseif selected[1] == "cancelReportPerson" then
							renderData.editingPerson = false
							renderData.editingPersonName = false
							fakeInputValue = {}
						end

						if selected[1] == "addPunishment" then
							local name = fakeInputValue["addPunishmentName|30"]
							local ticket = fakeInputValue["addPunishmentTicket|8"]
							local jail = fakeInputValue["addPunishmentJail|8"]
							local reason = fakeInputValue["addPunishmentReason|30"]

							if utf8.len(name) < 1 or utf8.len(ticket) < 1 or utf8.len(jail) < 1 or utf8.len(reason) < 1 then
								exports.seal_accounts:showInfo("e", "Minden mező kitöltése kötelező!")
							else
								triggerServerEvent("addPunishment", localPlayer, name, ticket, jail, reason)

								fakeInputValue = {}
							end
						elseif selected[1] == "delPunishment" then
							triggerServerEvent("delPunishment", localPlayer, tonumber(selected[2]))
						end

						if selected[1] == "searchByPlate" then
							local searchText = fakeInputValue["searchByPlate|8"]

							if utf8.len(searchText) > 0 then
								local result = {}

								searchText = utf8.gsub(utf8.lower(searchText), "%-", "%%-")

								for i = 1, #vehicleList do
									local record = vehicleList[i]

									if record then
										if utf8.find(utf8.lower(record.plate), searchText) then
											table.insert(result, record)
										end
									end
								end

								renderData.vehicleList = result

								if #result == 0 then
									inputError = "searchByPlate|8"
									inputErrorText = "Nincs találat!"
								end
							else
								renderData.vehicleList = vehicleList
							end
						elseif selected[1] == "searchByName" then
							local searchText = fakeInputValue["searchByName|30"]

							if utf8.len(searchText) > 0 then
								local result = {}

								searchText = utf8.lower(searchText)

								for i = 1, #peopleList do
									local record = peopleList[i]

									if record then
										if utf8.find(utf8.lower(record.name), searchText) then
											table.insert(result, record)
										end
									end
								end

								renderData.peopleList = result

								if #result == 0 then
									inputError = "searchByName|30"
									inputErrorText = "Nincs találat!"
								end
							else
								renderData.peopleList = peopleList
							end
						elseif selected[1] == "searchPunishment" then
							local searchText = fakeInputValue["searchPunishment|30"]

							if utf8.len(searchText) > 0 then
								local result = {}

								searchText = utf8.lower(searchText)

								for i = 1, #punishmentList do
									local record = punishmentList[i]

									if record then
										if utf8.find(utf8.lower(record.name), searchText) then
											table.insert(result, record)
										end
									end
								end

								renderData.punishmentList = result

								if #result == 0 then
									inputError = "searchPunishment|30"
									inputErrorText = "Nincs találat!"
								end
							else
								renderData.punishmentList = punishmentList
							end
						elseif selected[1] == "searchBTK" then
							local searchText = fakeInputValue["searchBTK|30"]

							if utf8.len(searchText) > 0 then
								local result = {}

								searchText = utf8.lower(searchText)

								for i = 1, #btkList do
									local dat = btkList[i]

									if dat then
										if utf8.find(utf8.lower(dat[1]), searchText) then
											table.insert(result, dat)
										end
									end
								end

								renderData.btkList = result

								if #result == 0 then
									inputError = "searchBTK|30"
									inputErrorText = "Nincs találat!"
								end
							else
								renderData.btkList = btkList
							end
						end
					end
				else
					if state == "down" then
						activeFakeInput = false
					end
				end
			end
		end
	end)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if panelState then
			if press then
				if (key == "v" and getKeyState("lctrl") or key == "v" and getKeyState("rctrl") or "m" and not activeFakeInput) and not (key == "mouse_wheel_up" or key == "mouse_wheel_down") then
					return
				end

				if key ~= "escape" then
					cancelEvent()
				end

				if loggedInMDC then
					local cx, cy = getCursorPosition()

					if cx and cy then
						cx = cx * screenX
						cy = cy * screenY

						if currentPage == "wantedCars" then
							if key == "mouse_wheel_up" then
								if renderData.wantedCarsOffset > 0 then
									renderData.wantedCarsOffset = renderData.wantedCarsOffset - 1
								end
							elseif key == "mouse_wheel_down" then
								if renderData.wantedCarsOffset < #renderData.vehicleList - 9 then
									renderData.wantedCarsOffset = renderData.wantedCarsOffset + 1
								end
							end
						end

						if currentPage == "wantedPeople" then
							if key == "mouse_wheel_up" then
								if renderData.wantedPeopleOffset > 0 then
									renderData.wantedPeopleOffset = renderData.wantedPeopleOffset - 1
								end
							elseif key == "mouse_wheel_down" then
								if renderData.wantedPeopleOffset < #renderData.peopleList - 9 then
									renderData.wantedPeopleOffset = renderData.wantedPeopleOffset + 1
								end
							end
						end

						if currentPage == "punishedPeople" then
							if key == "mouse_wheel_up" then
								if renderData.punishmentOffset > 0 then
									renderData.punishmentOffset = renderData.punishmentOffset - 1
								end
							elseif key == "mouse_wheel_down" then
								if renderData.punishmentOffset < #renderData.punishmentList - 7 then
									renderData.punishmentOffset = renderData.punishmentOffset + 1
								end
							end
						end

						if currentPage == "btk" then
							if key == "mouse_wheel_up" then
								if renderData.btkOffset > 0 then
									renderData.btkOffset = renderData.btkOffset - 1
								end
							elseif key == "mouse_wheel_down" then
								if renderData.btkOffset < #renderData.btkList - 21 then
									renderData.btkOffset = renderData.btkOffset + 1
								end
							end
						end
					end
				end

				if key == "backspace" then
					if activeFakeInput then
						subFakeInputText(activeFakeInput)

						if getKeyState(key) then
							repeatStartTimer = setTimer(subFakeInputText, 500, 1, activeFakeInput, true)
						end
					end
				end

				if key == "arrow_l" then
					if activeFakeInput then
						if utf8.len(fakeInputValue[activeFakeInput]) > 1 then
							if not caretIndex then
								caretIndex = utf8.len(fakeInputValue[activeFakeInput])
							end

							caretIndex = caretIndex - 1

							if caretIndex < 0 then
								caretIndex = 0
							end
						end
					end
				end

				if key == "arrow_r" then
					if activeFakeInput then
						if caretIndex then
							caretIndex = caretIndex + 1

							if caretIndex > utf8.len(fakeInputValue[activeFakeInput]) then
								caretIndex = false
							end
						end
					end
				end

				if key == "c" then
					if activeFakeInput then
						if getKeyState("lctrl") or getKeyState("rctrl") then
							local text = fakeInputValue[activeFakeInput]
							local length = utf8.len(text)

							if string.find(activeFakeInput, "hash") then
								if length > 0 then
									text = string.rep("•", length)
								end
							end

							setClipboard(text)
						end
					end
				end
			end
		end

		if not press then
			if isTimer(repeatStartTimer) then
				killTimer(repeatStartTimer)
			end

			if isTimer(repeatTimer) then
				killTimer(repeatTimer)
			end
		end
	end)

addEventHandler("onClientCharacter", getRootElement(),
	function (character)
		if panelState then
			if activeFakeInput then
				local details = split(activeFakeInput, "|")

				if utf8.len(fakeInputValue[activeFakeInput]) < tonumber(details[2]) then
					if details[3] == "num-only" then
						if not tonumber(character) then
							return
						end
					end

					if caretIndex then
						caretIndex = caretIndex + 1
						fakeInputValue[activeFakeInput] = utf8.insert(fakeInputValue[activeFakeInput], caretIndex, tostring(character))
					else
						fakeInputValue[activeFakeInput] = utf8.insert(fakeInputValue[activeFakeInput], tostring(character))
					end

					playSound("files/sounds/key" .. math.random(1, 3) .. ".mp3")
				end
			end
		end
	end)

addEventHandler("onClientPaste", getRootElement(),
	function (clipboardText)
		if panelState then
			if activeFakeInput then
				local details = split(activeFakeInput, "|")
				local clipLength = utf8.len(clipboardText)
				local currLength = utf8.len(fakeInputValue[activeFakeInput])
				local remainingLength = tonumber(details[2]) - currLength

				if remainingLength > 0 then
					local finalText = clipboardText

					if clipLength > remainingLength then
						finalText = utf8.sub(clipboardText, 1, remainingLength)
					end

					if details[3] == "num-only" then
						if not tonumber(finalText) then
							return
						end
					end

					if caretIndex then
						caretIndex = caretIndex + utf8.len(finalText)
						fakeInputValue[activeFakeInput] = utf8.insert(fakeInputValue[activeFakeInput], caretIndex, tostring(finalText))
					else
						fakeInputValue[activeFakeInput] = utf8.insert(fakeInputValue[activeFakeInput], tostring(finalText))
					end
				end
			end
		end
	end)

function subFakeInputText(inputName, repeatTheTimer)
	if utf8.len(fakeInputValue[inputName]) > 0 then
		if caretIndex then
			if caretIndex > 0 then
				fakeInputValue[inputName] = utf8.sub(fakeInputValue[inputName], 1, caretIndex - 1) .. utf8.sub(fakeInputValue[inputName], caretIndex + 1, utf8.len(fakeInputValue[inputName]))
				caretIndex = caretIndex - 1
			end
		else
			fakeInputValue[inputName] = utf8.sub(fakeInputValue[inputName], 1, -2)
		end

		if repeatTheTimer then
			repeatTimer = setTimer(subFakeInputText, 50, 1, inputName, repeatTheTimer)
		end
	end
end

function getFitFontScale(text, scale, font, maxwidth)
	local scaleex = scale

	while true do
		if dxGetTextWidth(text, scaleex, font) > maxwidth then
			scaleex = scaleex - 0.01
		else
			break
		end
	end

	return scaleex
end

function drawInput(id, placeholder, x, y, sx, sy, icon, innericon)
	if not fakeInputValue[id] then
		fakeInputValue[id] = ""
	end

	local hash = false
	local length = utf8.len(fakeInputValue[id])

	if string.find(id, "hash") then
		if length > 0 then
			hash = string.rep("•", length)
		end
	end

	local text = hash

	if not hash then
		text = fakeInputValue[id]
	end

	if icon then
		buttons["setFakeInput:" .. id] = {x + 32, y, sx, sy}
	else
		buttons["setFakeInput:" .. id] = {x, y, sx, sy}
	end

	local scale = 0.75

	if length == 0 and placeholder then
		scale = getFitFontScale(placeholder, 0.75, Rubik, sx - 10)
	else
		scale = getFitFontScale(text, 0.75, Rubik, sx - 10)
	end

	if activeFakeInput == id then
		if icon then
			dxDrawRectangle(x, y - 2, 32, sy + 4, tocolor(7, 112, 196))
			dxDrawImage(x, y + sy / 2 - 32 / 2, 32, 32, icon)

			x = x + 32
		end

		dxDrawRectangle(x, y, sx, sy, tocolor(255, 255, 255))
		drawRectangleOutline(x, y, sx, sy, tocolor(7, 112, 196), 2)

		if innericon then
			if length == 0 and placeholder then
				dxDrawImage(x + sx - 32, y + sy / 2 - 32 / 2, 32, 32, innericon, 0, 0, 0, tocolor(167, 167, 167))
			else
				dxDrawImage(x + sx - 32, y + sy / 2 - 32 / 2, 32, 32, innericon, 0, 0, 0, tocolor(0, 0, 0))
			end

			sx = sx - 32
		end

		if length == 0 and placeholder then
			dxDrawText(placeholder, x + 10, y, x + sx - 10, y + sy, tocolor(167, 167, 167), scale, 0.75, Rubik, "left", "center", true)
		else
			dxDrawText(text, x + 10, y, x + sx - 10, y + sy, tocolor(0, 0, 0), scale, 0.75, Rubik, "left", "center", true)
		end

		local progress = math.abs(getTickCount() % 750 - 375) / 375

		if progress > 0.5 then
			local textWidth = 0

			if caretIndex then
				textWidth = dxGetTextWidth(utf8.sub(text, 1, caretIndex), scale, Rubik)
			else
				textWidth = dxGetTextWidth(text, scale, Rubik)
			end

			local caretX = x + 10 + textWidth

			if caretX > x + sx - 10 then
				caretX = x + sx - 10
			end

			dxDrawRectangle(caretX, y + 5, 1, sy - 10, tocolor(0, 0, 0))
		end
	else
		local color = tocolor(75, 75, 75)
		local bgcolor = tocolor(0, 0, 0, 00)

		if inputError == id then
			color = tocolor(232, 17, 35)
			bgcolor = tocolor(255, 255, 255)
		elseif activeButton == "setFakeInput:" .. id then
			color = tocolor(100, 100, 100)
		end

		if icon then
			dxDrawRectangle(x, y - 2, 32, sy + 4, color)
			dxDrawImage(x, y + sy / 2 - 32 / 2, 32, 32, icon)

			x = x + 32
		end

		dxDrawRectangle(x, y, sx, sy, bgcolor)
		drawRectangleOutline(x, y, sx, sy, color, 2)

		if innericon then
			if inputError == id then
				dxDrawImage(x + sx - 32, y + sy / 2 - 32 / 2, 32, 32, innericon, 0, 0, 0, tocolor(232, 17, 35))
			elseif length == 0 and placeholder then
				dxDrawImage(x + sx - 32, y + sy / 2 - 32 / 2, 32, 32, innericon, 0, 0, 0, tocolor(75, 75, 75))
			else
				dxDrawImage(x + sx - 32, y + sy / 2 - 32 / 2, 32, 32, innericon, 0, 0, 0, tocolor(255, 255, 255))
			end

			sx = sx - 32
		end

		if inputError == id and inputErrorText then
			dxDrawText(inputErrorText, x + 10, y, x + sx - 10, y + sy, tocolor(232, 17, 35), scale, 0.75, Rubik, "left", "center", true)
		elseif length == 0 and placeholder then
			dxDrawText(placeholder, x + 10, y, x + sx - 10, y + sy, tocolor(75, 75, 75), scale, 0.75, Rubik, "left", "center", true)
		else
			dxDrawText(text, x + 10, y, x + sx - 10, y + sy, tocolor(255, 255, 255), scale, 0.75, Rubik, "left", "center", true)
		end
	end
end

function drawButton(id, text, x, y, sx, sy, bgcolor, bordercolor, presscolor, scale)
	if activeButton == id then
		bgcolor = bordercolor
	end

	dxDrawRectangle(x, y, sx, sy, bgcolor)

	if activeButton == id then
		if getKeyState("mouse1") then
			drawRectangleOutline(x + 2, y + 2, sx - 4, sy - 4, presscolor, 2)
		end
	end

	dxDrawText(text, x, y, x + sx, y + sy, tocolor(255, 255, 255), scale or 0.85, Rubik, "center", "center")

	buttons[id] = {x, y, sx, sy}

	return x + sx
end

function drawRectangleOutline(x, y, sx, sy, color, thickness)
	thickness = thickness or 1
	dxDrawRectangle(x, y - thickness, sx, thickness, color) -- felső
	dxDrawRectangle(x, y + sy, sx, thickness, color) -- alsó
	dxDrawRectangle(x - thickness, y - thickness, thickness, sy + thickness * 2, color) -- bal
	dxDrawRectangle(x + sx, y - thickness, thickness, sy + thickness * 2, color) -- jobb
end

function drawRectangleOutlineEx(x, y, sx, sy, color, thickness)
	thickness = thickness or 1
	dxDrawRectangle(x, y - thickness, sx, thickness, color) -- felső
	dxDrawRectangle(x, y + sy, sx, thickness, color) -- alsó
	dxDrawRectangle(x - thickness, y, thickness, sy, color) -- bal
	dxDrawRectangle(x + sx, y, thickness, sy, color) -- jobb
end

function isCursorInPos(posX, posY, width, height)
	if isCursorShowing() then
		local mouseX, mouseY = getCursorPosition()
		local clientW, clientH = guiGetScreenSize()
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH;
		if (mouseX > posX and mouseX < (posX+width) and mouseY > posY and mouseY < (posY+height)) then
			return true;
		end
	end
	return false
end


function initATMRestore()
	for k, v in pairs(atmRobBlips) do
		destroyElement(v[objectElement])
	end
end
addEvent("initATMRestore", true)
addEventHandler("initATMRestoreClient", getRootElement(), initATMRestore)

addEvent("destroyBlips", true)
addEventHandler("destroyBlips", getRootElement(),
	function(vehicleElement)
		if getVehicleOccupant(vehicleElement) then
			return
		end
		
		if isElement(unitBlips[vehicleElement]) then
			destroyElement(unitBlips[vehicleElement])
		end

		if isTimer(unitTimers[vehicleElement]) then
			killTimer(unitTimers[vehicleElement])
		end
	end
)

addEvent("destoryBackupBlips", true)
addEventHandler("destoryBackupBlips", getRootElement(),
	function()
		if backupBlips[source] then
			destroyElement(backupBlips[source])
			backupBlips[source] = nil
		end
	end
)
--[[
addEvent("gotVehicleDatas", true)
addEventHandler("gotVehicleDatas", root,
	function (data)
		if exports.seal_gui:isGuiElementValid(loaderBackground) then
			exports.seal_gui:deleteGuiElement(loaderBackground)
		end

		if type(data) == "string" then
			exports.seal_gui:showInfobox("e", data)
		else
			searchedVehicle = data

			local w, h = 1000, 675
			dataBackground = exports.seal_gui:createGuiElement("window", screenX / 2 - (w / 2), screenY / 2 - (h / 2), w, h)
			exports.seal_gui:setWindowTitle(dataBackground, "14/Ubuntu-R.ttf",  "Jármű lekérdezés")
			exports.seal_gui:setWindowCloseButton(dataBackground, "closeDataPanel")

			if searchedVehicle.ownerId == 0 then
				vehicleOwnerName = "Frakció jármű"
			else
				vehicleOwnerName = "Nigga János"
			end
		end
	end
)

addEvent("closeDataPanel", true)
addEventHandler("closeDataPanel", root,
	function (button, state)
		if button == "left" and state == "down" then
			if exports.seal_gui:isGuiElementValid(dataBackground) then
				exports.seal_gui:deleteGuiElement(dataBackground)
			end
		end
	end
)

function createSearchPanel()
	local w, h = 375, 162
	guibg = exports.seal_gui:createGuiElement("window", screenX / 2 - (w / 2), screenY / 2 - (h / 2), w, h)
	exports.seal_gui:setWindowTitle(guibg, "14/Ubuntu-R.ttf",  "Jármű lekérdezés")
	exports.seal_gui:setWindowCloseButton(guibg, "closeSearchPanel")

	local label = exports.seal_gui:createGuiElement("label", 6, 42, w, h, guibg)
    exports.seal_gui:setLabelText(label, "Lekérdezés rendszám alapján:")
	exports.seal_gui:setLabelFont(label, "13/Ubuntu-L.ttf")
	exports.seal_gui:setLabelAlignment(label, "left", "top")

	plateInput = exports.seal_gui:createGuiElement("input", 6, 72, w - 12, 36, guibg)
    exports.seal_gui:setInputPlaceholder(plateInput, "Rendszám")
    exports.seal_gui:setInputFont(plateInput, "12/Ubuntu-R.ttf")
    exports.seal_gui:setInputMaxLength(plateInput, 8)

    local button = exports.seal_gui:createGuiElement("button", 6, h - 42, w - 12, 36, guibg)
    exports.seal_gui:setGuiBackground(button, "solid", "primary")
    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"})
    exports.seal_gui:setButtonFont(button, "13/Ubuntu-R.ttf")
    exports.seal_gui:setButtonText(button, "Lekérdezés indítása")
    exports.seal_gui:setButtonIcon(button, exports.seal_gui:getFaIconFilename("search", 36))
    exports.seal_gui:setClickEvent(button, "startSearching")
    exports.seal_gui:setClickSound(button, "selectdone")
end
createSearchPanel()

addEvent("startSearching", true)
addEventHandler("startSearching", root,
	function (button, state, absX, absY, el)
		if exports.seal_gui:isGuiElementValid(el) then
			local plateText = exports.seal_gui:getInputValue(plateInput) or ""
			local palteLength = utf8.len(plateText)

			if palteLength <= 8 and palteLength > 0 then
				if exports.seal_gui:isGuiElementValid(guibg) then
					exports.seal_gui:deleteGuiElement(guibg)
				end

				loaderBackground = exports.seal_gui:createGuiElement("rectangle", screenX / 2 - 64, screenY / 2 - 64, 128, 128)
				exports.seal_gui:setGuiBackground(loaderBackground, "solid", "grey2")

				local loaderIcon = exports.seal_gui:createGuiElement("image", 16, 16, 96, 96, loaderBackground)
				exports.seal_gui:setImageFile(loaderIcon, exports.seal_gui:getFaIconFilename("circle-notch", 96))
				exports.seal_gui:setImageSpinner(loaderIcon, true)

				local plateSection = {}
				local plateTextTable = split(plateText:upper(), " ")

				for i = 1, #plateTextTable do
					if utf8.len(plateTextTable[i]) > 0 then
						table.insert(plateSection, plateTextTable[i])
					end
				end

				triggerServerEvent("requestVehicleDatas", resourceRoot, table.concat(plateSection, "-"))
			end
		end
	end
)

addEvent("closeSearchPanel", true)
addEventHandler("closeSearchPanel", root,
	function (button, state)
		if button == "left" and state == "down" then
			if exports.seal_gui:isGuiElementValid(guibg) then
				exports.seal_gui:deleteGuiElement(guibg)
			end
		end
	end
)]]

setTimer(
	function ()
		local vehicleElements = getElementsByType("vehicle")

		for i = 1, #vehicleElements do
			if isElement(vehicleElements[i]) then
				local unitState = getElementData(vehicleElements[i], "unitState") or false

				if unitState then
					local vehicleOccupants = {}

					for k, v in pairs(getVehicleOccupants(vehicleElements[i])) do
						table.insert(vehicleOccupants, {k, v})
					end

					if #vehicleOccupants <= 0 and unitState ~= "off" then
						setElementData(vehicleElements[i], "unitState", "off")
					end
				end
			end
		end
	end, 60000 * 15, 0
)