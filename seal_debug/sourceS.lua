local developers = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		local playerElements = getElementsByType("player")

		for i = 1, #playerElements do
			if playerElements[i] then
				local loggedIn = getElementData(playerElements[i], "loggedIn") or false

				if loggedIn then
					local adminLevel = getElementData(playerElements[i], "acc.adminLevel") or 0

					if adminLevel >= 7 then
						developers[playerElements[i]] = true
					end
				end
			end
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(),
	function (dataName, oldValue, newValue)
		if dataName == "acc.adminLevel" then
			if newValue >= 7 then
				developers[source] = true
			else
				developers[source] = nil
			end	
		end
	end
)

addEventHandler("onPlayerQuit", resourceRoot,
	function ()
		if developers[source] then
			developers[source] = nil
		end
	end
)

addEventHandler("onDebugMessage", getRootElement(),
	function (message, level, file, line, r, g, b)
		if level == 1 then
			level = "#d75959[ERROR] "
		elseif level == 2 then
			level = "#FF9600[WARNING] "
		else
			level = "#7cc576[INFO] "
		end

		for k, v in pairs(developers) do
			if file and line then
				triggerClientEvent(k, "addDebugLine", resourceRoot, level .. file .. ":" .. line .. ", " .. message, color)
			else
				triggerClientEvent(k, "addDebugLine", resourceRoot, level .. message, color)
			end
		end
	end
)