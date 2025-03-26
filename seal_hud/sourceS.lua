function showInfobox(el, type, str)
	if isElement(el) then
		triggerClientEvent(el, "showInfobox", el, type, str)
	end
end


addEvent("tiredAnim", true)
addEventHandler("tiredAnim", resourceRoot,
	function (state)
		if isElement(source) then
			if state then
				setPedAnimation(client, "FAT", "idle_tired", -1, true, false, false)
			else
				setPedAnimation(client, false)
			end
		end
	end)

addEvent("setPedFightingStyle", true)
addEventHandler("setPedFightingStyle", resourceRoot,
	function (style)
		if isElement(client) then
			setPedFightingStyle(client, tonumber(style))
		end
	end)

addEvent("setPedWalkingStyle", true)
addEventHandler("setPedWalkingStyle", resourceRoot,
	function (style)
		if isElement(client) then
			setPedWalkingStyle(client, style)
		end
	end)

addEvent("kickPlayerCuzScreenSize", true)
addEventHandler("kickPlayerCuzScreenSize", resourceRoot,
	function ()
		if source ~= client then
			return
		end
		if isElement(client) then
			kickPlayer(client, "Alacsony képernyőfelbontás! (Minimum 1024x768)")
		end
	end)

addEvent("executeCommand", true)
addEventHandler("executeCommand", resourceRoot,
	function (commandName, arguments)
		if source ~= client then
			return
		end
		if commandName and arguments then
			if isElement(client) then
				if not hasObjectPermissionTo(client, "command." .. commandName, true) then
					return
				end
				
				executeCommandHandler(commandName, client, arguments)
			end
		end
	end
)

addEvent("updateGear", true)
addEventHandler("updateGear", resourceRoot,
	function(vehicleElement, newGear)
		if getPedOccupiedVehicle(client) == vehicleElement then
			setElementData(vehicleElement, "currentGear", newGear)
		end
	end
)