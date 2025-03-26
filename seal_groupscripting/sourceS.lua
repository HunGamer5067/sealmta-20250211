local sirenPoses = {
	[416] = { -- Ambulance
		{-0.6, 0.8, 1.1, 255, 60, 60, 255, 255}, -- tető
		{0, 0.8, 1.1, 255, 60, 60, 255, 255}, -- tető
		{0.6, 0.8, 1.1, 255, 60, 60, 255, 255}, -- tető

		{-0.4, 2.75, 0.05, 255, 60, 60, 255, 255}, -- elöl
		{0.4, 2.75, 0.05, 255, 60, 60, 255, 255}, -- elöl

		{-0.95, -3.75, 1.05, 255, 150, 0, 225, 225}, -- hátul szélen
		{0.95, -3.75, 1.05, 255, 150, 0, 225, 225}, -- hátul szélen

		{0, -3.75, 1.5, 255, 60, 60, 255, 255}, -- hátul fent középen
	},
	[407] = { -- Fire Truck
		
	}
}

addEvent("payTheTicket", true)
addEventHandler("payTheTicket", getRootElement(),
	function(itemID, money)
		if client == source and money > 0 then


			
			local currentBalance = exports.seal_groups:getGroupBalance(1) or 0

			if currentBalance then
				exports.seal_groups:setGroupBalance(1, currentBalance + (money / 2))
			end

			setElementData(source, "char.Money", getElementData(source, "char.Money") - money)
			triggerEvent("takeItem", source, source, "dbID", itemID)
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "sirenSound" then
			local sirenSound = getElementData(source, dataName)
			local sirenParams = getVehicleSirenParams(source)

			if sirenSound == 1 then
				if getVehicleSirensOn(source) then
					if sirenParams.Flags.Silent then
						switchTheSiren(source, false, true)
					else
						switchTheSiren(source, false, true)
					end
				else
					switchTheSiren(source, false, false)
				end
			else
				if getVehicleSirensOn(source) then
					if sirenParams.SirenType ~= 1 then
						switchTheSiren(source, true, true)
					else
						setVehicleSirensOn(source, false)
					end
				end
			end
		end
	end)

addEvent("switchTheSiren", true)
addEventHandler("switchTheSiren", getRootElement(),
	function ()
		if isElement(source) and client and getPedOccupiedVehicle(client) == source then
			local model = getElementModel(source)
			local sirenSound = getElementData(source, "sirenSound")
			local sirenParams = getVehicleSirenParams(source)

			if getVehicleSirensOn(source) then
				if sirenSound == 1 then
					if sirenParams.Flags.Silent then
						setVehicleSirensOn(source, false)
					else
						if sirenParams.SirenType ~= 1 then
							switchTheSiren(source, false, false)
						else
							switchTheSiren(source, false, true)
						end
					end
				else
					iprint("ige")
					setVehicleSirensOn(source, false)
				end
			else
				switchTheSiren(source, true, true)
			end
		end
	end)

function switchTheSiren(vehicle, silent, lights)
	local model = getElementModel(vehicle)

	if getElementData(vehicle,"sirens->State") then
		if lights then
			setElementData(vehicle,"sirens->Flasher",true)
		else
			setElementData(vehicle,"sirens->Flasher",false)
		end
	end

	if sirenPoses[model] then
		addVehicleSirens(vehicle, #sirenPoses[model], lights and math.random(2, 3) or 1, false, false, true, silent)

		for i = 1, #sirenPoses[model] do
			if lights then
				setVehicleSirens(vehicle, i, unpack(sirenPoses[model][i]))
			else
				setVehicleSirens(vehicle, i, 0, 0, 0, 0, 0, 0, 0, 0)
			end
		end

		setVehicleSirensOn(vehicle, true)
	end
end

--[[
local hiddenNames = {}

addCommandHandler("alnev",
	function(sourcePlayer, commandName, newName)
		if exports.seal_groups:isPlayerHavePermission(sourcePlayer, "hiddenName") then
			if hiddenNames[sourcePlayer] then
				setElementData(sourcePlayer, "visibleName", hiddenNames[sourcePlayer].oldName)
				setElementData(sourcePlayer, "char.Name", hiddenNames[sourcePlayer].oldName)
				hiddenNames[sourcePlayer] = nil

				outputChatBox("#4adfbf[SealMTA - Álnév] #ffffffSikeresen kikapcsoltad a #4adfbfálneved!", sourcePlayer, 255, 255, 255, true)
			else
				if newName then
					hiddenNames[sourcePlayer] = {oldName = getElementData(sourcePlayer, "char.Name"), newName = newName}

					if hiddenNames[sourcePlayer] then
						setElementData(sourcePlayer, "visibleName", hiddenNames[sourcePlayer].newName)
						setElementData(sourcePlayer, "char.Name", hiddenNames[sourcePlayer].newName)
						outputChatBox("#4adfbf[SealMTA - Álnév] #ffffffSikeresen bekapcsoltad az álneved! #4adfbf("..newName:gsub("_", " ")..")", sourcePlayer, 255, 255, 255, true)
					end
				end
			end
		end
	end
)]]