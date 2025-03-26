local availableNeons = {
	[8628] = "red",
	[8626] = "blue",
	[8627] = "green",
	[8582] = "yellow",
	[7041] = "pink",
	[7045] = "white",
	[6882] = "purple",
	[7252] = "lightblue",
	[7253] = "orange",
}

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
	local col = engineLoadCOL("files/neon/neons.col")

	for k, v in pairs(availableNeons) do
		local dff = engineLoadDFF("files/neon/neon_" .. v .. ".dff")
		if dff and col then
			engineReplaceModel(dff, k)
			engineReplaceCOL(col, k)

			local dff = engineLoadDFF("files/neon/neon_" .. v .. "_lil.dff")
			if dff and col then
				engineReplaceModel(dff, k + 32)
				engineReplaceCOL(col, k + 32)
			end
		end
	end
end)

addCommandHandler("toggle-neon", function()
	local pedveh = getPedOccupiedVehicle(localPlayer)

	if pedveh and getVehicleController(pedveh) == localPlayer then
		if getElementData(pedveh, "tuning.neon") ~= 0 then
			if getElementData(pedveh, "tuning.neon.state") then
				if getElementData(pedveh, "tuning.neon.state") == 0 then
					setElementData(pedveh, "tuning.neon.state", 1)
				elseif getElementData(pedveh, "tuning.neon.state") == 1 then
					setElementData(pedveh, "tuning.neon.state", 0)
				end
			end
		end
	end
end)
bindKey("u", "down", "toggle-neon")

local neonObjects = {}

function changeNeonState(vehicle, state)
	if isElement(vehicle) then
		if neonObjects[vehicle] then
			if isElement(neonObjects[vehicle][1]) then
				destroyElement(neonObjects[vehicle][1])
			end

			if isElement(neonObjects[vehicle][2]) then
				destroyElement(neonObjects[vehicle][2])
			end
			
			if isElement(neonObjects[vehicle][3]) then
				destroyElement(neonObjects[vehicle][3])
			end
			
			if isElement(neonObjects[vehicle][4]) then
				destroyElement(neonObjects[vehicle][4])
			end

			neonObjects[vehicle] = nil
		end
		neonObjects[vehicle] = {}

		local currentState = getElementData(vehicle, "tuning.neon.state")
		local neonModel = getElementData(vehicle, "tuning.neon")
		
		if currentState and neonModel and tonumber(neonModel) > 0 then
			neonModel = tonumber(neonModel) 
			local smallModel = neonModel + 32

			if tonumber(smallModel) then
				local int = getElementInterior(vehicle)
				local dim = getElementDimension(vehicle)
				local x, y, z, x1, y1, z1 = getElementBoundingBox(vehicle)
				
				local x = (math.abs(x) + math.abs(x1)) / 2 - 0.4

				local neon = createObject(neonModel, 0, 0, 0)
				setElementDimension(neon, dim)
				setElementInterior(neon, int)
				attachElements(neon, vehicle, x, 0, z * 0.5)
				setObjectScale(neon, 0)
				setElementCollisionsEnabled(neon, false)
				neonObjects[vehicle][1] = neon
				
				local neon = createObject(neonModel, 0, 0, 0)
				setElementDimension(neon, dim)
				setElementInterior(neon, int)
				attachElements(neon, vehicle, -x, 0, z * 0.5)
				setObjectScale(neon, 0)
				setElementCollisionsEnabled(neon, false)
				neonObjects[vehicle][2] = neon

				local y = (math.abs(y) + math.abs(y1)) / 2 - 0.4
				
				local neon = createObject(smallModel, 0, 0, 0)
				if not neon then
					outputChatBox(neonModel .. ", " .. smallModel .. " hibas")
				end
				setElementDimension(neon, dim)
				setElementInterior(neon, int)
				attachElements(neon, vehicle, 0, y, z * 0.5, 0, 0, 90)
				setObjectScale(neon, 0)
				setElementCollisionsEnabled(neon, false)
				neonObjects[vehicle][3] = neon
				
				local neon = createObject(smallModel, 0, 0, 0)
				setElementDimension(neon, dim)
				setElementInterior(neon, int)
				attachElements(neon, vehicle, 0, -y, z * 0.5, 0, 0, 90)
				setObjectScale(neon, 0)
				setElementCollisionsEnabled(neon, false)
				neonObjects[vehicle][4] = neon
			end
		end
	end
end

addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		if neonObjects[source] then
			if isElement(neonObjects[source][1]) then
				destroyElement(neonObjects[source][1])
			end

			if isElement(neonObjects[source][2]) then
				destroyElement(neonObjects[source][2])
			end
			
			if isElement(neonObjects[source][3]) then
				destroyElement(neonObjects[source][3])
			end
			
			if isElement(neonObjects[source][4]) then
				destroyElement(neonObjects[source][4])
			end
			
			neonObjects[source] = nil
		end
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue)
	if dataName == "loggedIn" then
		if source == localPlayer then
			if getElementData(source, "loggedIn") then
				for k, v in ipairs(getElementsByType("vehicle")) do
					if (getElementData(v, "tuning.neon") or 0) ~= 0 then
						if (getElementData(v, "tuning.neon.state") or 0) == 1 then
							changeNeonState(v)
						end
					end
				end
			end
		end
	elseif dataName == "tuning.neon.state" or dataName == "tuning.neon" then
		if getElementType(source) == "vehicle" then
			local state = getElementData(source, "tuning.neon.state")

			if state then
				changeNeonState(source, state)
			end
		end
	end
end)