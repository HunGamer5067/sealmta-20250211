local createdGates = {}
local connection = exports.seal_database:getConnection()

function loadGates(qh, sync)
	local result = dbPoll(qh, 1000)

	for k, v in pairs(availableGates) do
		if isElement(createdGates[k].objectElement) then
			destroyElement(createdGates[k].objectElement)
		end
		availableGates[k] = nil
	end

	for k, v in pairs(result) do
		k = v.gateId
		v = {v.openX, v.openY, v.openZ, v.openRotX, v.openRotY, v.openRotZ, v.closeX, v.closeY, v.closeZ, v.closeRotX, v.closeRotY, v.closeRotZ, v.interior, v.dimension, v.modelId, v.time, v.groupId, v.gateId}
		availableGates[k] = v

		local objectElement = createObject(v[15], v[7], v[8], v[9], v[10], v[11], v[12])

		if isElement(objectElement) then
			setElementFrozen(objectElement, true)
			setElementInterior(objectElement, v[13])
			setElementDimension(objectElement, v[14])

			setObjectBreakable(objectElement, false)

			createdGates[k] = {}
			createdGates[k].objectElement = objectElement
			createdGates[k].state = false
			createdGates[k].startTime = 0
			createdGates[k].groupId = v[17]
			createdGates[k].id = v[18]
		end
	end
	if sync then
		triggerClientEvent(getRootElement(), "syncGates", resourceRoot, availableGates)
	end
end	

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		loadGates(dbQuery(connection, "SELECT * FROM gates"))
	end
)

local prisonGateGroups = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
}

addEvent("toggleGate", true)
addEventHandler("toggleGate", getRootElement(),
	function (gateID)
		if isElement(source) and client == source then
			local gateParameters = availableGates[gateID]

			if gateParameters then
				local selectedGate = createdGates[gateID]

				if selectedGate then
					local hasPermission = false
					local adminLevel = getElementData(source, "acc.adminLevel") or 0

					if adminLevel >= 6 then
						hasPermission = true
					end
					
					if not hasPermission then
						if exports.seal_items:hasItemWithData(source, 3, gateID) then
							hasPermission = true
						end
					end

					if not hasPermission then
						local gateGroup = createdGates[gateID].groupId

						if exports.seal_groups:isPlayerInGroup(source, gateGroup) then
							hasPermission = true
						end
					end

					if not hasPermission then
						if prisonGates[createdGates[gateID].id] then
							for k, v in pairs(prisonGateGroups) do
								if exports.seal_groups:isPlayerInGroup(source, k) then
									hasPermission = true
								end
							end
						end
					end

					if hasPermission then
						local elapsedTime = getTickCount() - selectedGate.startTime
						local movementTime = gateParameters[16]

						
						if elapsedTime >= movementTime then
							selectedGate.startTime = getTickCount()

							local rotX = angleDiff(gateParameters[10], gateParameters[4])
							local rotY = angleDiff(gateParameters[11], gateParameters[5])
							local rotZ = angleDiff(gateParameters[12], gateParameters[6])

							if not selectedGate.state then
								moveObject(selectedGate.objectElement, movementTime, gateParameters[1], gateParameters[2], gateParameters[3], rotX, rotY, rotZ)
							else
								moveObject(selectedGate.objectElement, movementTime, gateParameters[7], gateParameters[8], gateParameters[9], -rotX, -rotY, -rotZ)
							end

							selectedGate.state = not selectedGate.state

							if selectedGate.state then
								exports.seal_chat:localAction(source, "kinyit egy közelben lévő kaput.")
							else
								exports.seal_chat:localAction(source, "bezár egy közelben lévő kaput.")
							end
						end
					end
				end
			end
		end
	end
)

function angleDiff(firstAngle, secondAngle)
	local difference = secondAngle - firstAngle

	while difference < -180 do
		difference = difference + 360
	end

	while difference > 180 do
		difference = difference - 360
	end

	return difference
end

addEvent("syncGates", true)
addEventHandler("syncGates", resourceRoot,
	function()
		triggerClientEvent(client, "syncGates", resourceRoot, availableGates)
	end
)

addEvent("insertNewGate", true)
addEventHandler("insertNewGate", resourceRoot,
	function(openX, openY, openZ, openRotX, openRotY, openRotZ, closeX, closeY, closeZ, closeRotX, closeRotY, closeRotZ, interior, dimension, modelId, time, groupId)
		if getElementData(client, "acc.adminLevel") >= 6 then
			dbExec(connection, "INSERT INTO gates (openX, openY, openZ, openRotX, openRotY, openRotZ, closeX, closeY, closeZ, closeRotX, closeRotY, closeRotZ, interior, dimension, modelId, time, groupId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", openX, openY, openZ, openRotX, openRotY, openRotZ, closeX, closeY, closeZ, closeRotX, closeRotY, closeRotZ, interior, dimension, modelId, time, groupId)
			loadGates(dbQuery(connection, "SELECT * FROM gates"), true)
		end
	end
)

addCommandHandler("deletegate",	
	function(sourcePlayer, commandName, gateId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			gateId = tonumber(gateId)

			if gateId then
				if availableGates[gateId] then
					dbExec(connection, "DELETE FROM gates WHERE gateId = ?", gateId)
					loadGates(dbQuery(connection, "SELECT * FROM gates"), true)
					outputChatBox("#768fe3[SealMTA]:#ffffff Sikeresen törölted!", sourcePlayer,  255, 255, 255, true)
				else
					outputChatBox("[Használat]: #FFFFFFNem létezik ilyen azonosítóval gate!", sourcePlayer,  215, 89, 89, true)
				end
			else
				outputChatBox("#768fe3[Használat]: #FFFFFF/" .. commandName .. " [GateID]", sourcePlayer, 255, 255, 255, true)
			end
		end
	end
)

addCommandHandler("setgategroup",	
	function(sourcePlayer, commandName, gateId, groupId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			gateId = tonumber(gateId)
			groupId = tonumber(groupId)

			if gateId and groupId then
				if availableGates[gateId] then
					dbExec(connection, "UPDATE gates SET groupId = ? WHERE gateId = ?", groupId, gateId)
					loadGates(dbQuery(connection, "SELECT * FROM gates"), true)
					outputChatBox("#768fe3[SealMTA]:#ffffff Sikeresen beállítottad!", sourcePlayer,  255, 255, 255, true)
				else
					outputChatBox("[Használat]: #FFFFFFNem létezik ilyen azonosítóval gate!", sourcePlayer,  215, 89, 89, true)
				end
			else
				outputChatBox("#768fe3[Használat]: #FFFFFF/" .. commandName .. " [GateID] [GroupID]", sourcePlayer, 255, 255, 255, true)
			end
		end
	end
)

addCommandHandler("gotogate",	
	function(sourcePlayer, commandName, gateId)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
			gateId = tonumber(gateId)

			if gateId then
				if availableGates[gateId] then
					setElementPosition(sourcePlayer, availableGates[gateId][1], availableGates[gateId][2], availableGates[gateId][3])
				else
					outputChatBox("[Használat]: #FFFFFFNem létezik ilyen azonosítóval gate!", sourcePlayer,  215, 89, 89, true)
				end
			else
				outputChatBox("#768fe3[Használat]: #FFFFFF/" .. commandName .. " [GateID]", sourcePlayer, 255, 255, 255, true)
			end
		end
	end
)