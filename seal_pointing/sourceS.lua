local linkedTargets = {}

addEvent("syncPointer", true)
addEventHandler("syncPointer", root,
	function (boneId, targetX, targetY, targetZ)
		local clientPlayer = client

		if not clientPlayer then
			return
		end

		if boneId and targetX and targetY and targetZ then
			triggerClientEvent(root, "syncPointer", clientPlayer, boneId, targetX, targetY, targetZ)
		end
	end
)

addEvent("togglePointerMode", true)
addEventHandler("togglePointerMode", root,
	function (syncerElements)
		local clientPlayer = client

		if not clientPlayer then
			return
		end

		if syncerElements then
			triggerClientEvent(syncerElements, "togglePointerMode", clientPlayer, true)
		else
			triggerClientEvent(root, "togglePointerMode", clientPlayer, false)
		end
	end
)

addEvent("syncLink", true)
addEventHandler("syncLink", resourceRoot, function(clientEx, clientBaseBone, clientExBaseBone)
	if isElement(client) and isElement(clientEx) and tonumber(clientBaseBone) and tonumber(clientExBaseBone) and not linkedTargets[client] and not linkedTargets[clientEx] then
		linkedTargets[client] = true
		linkedTargets[clientEx] = true
		triggerClientEvent(getRootElement(), "syncLink", resourceRoot, client, clientEx, clientBaseBone, clientExBaseBone)
	end
end)

addEvent("syncLinkBreak", true)
addEventHandler("syncLinkBreak", resourceRoot, function(client, clientEx)
	linkedTargets[client] = nil
	linkedTargets[clientEx] = nil
	triggerClientEvent(getRootElement(), "syncLinkBreak", resourceRoot, client, clientEx)
end)