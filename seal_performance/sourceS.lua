addEvent("getServerPerformanceStats", true)
addEventHandler("getServerPerformanceStats", getRootElement(),
	function (category)
		if isElement(source) and client and client == source and getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			triggerClientEvent(source, "getServerPerformanceStats", source, getPerformanceStats(category))
		end
	end)

addEvent("performanceFromAnotherClient", true)
addEventHandler("performanceFromAnotherClient", getRootElement(),
	function (anotherClient, category)
		if client and client == source and getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			triggerClientEvent(anotherClient, "clientFromAnotherClient", client, category)
		end
	end)

addEvent("sendToAnother", true)
addEventHandler("sendToAnother", getRootElement(),
	function (player, columns, rows)
		if isElement(source) and client and client == source and getElementData(sourcePlayer, "acc.adminLevel") >= 7 then
			triggerClientEvent(source, "getServerPerformanceStats", player, columns, rows, getPlayerName(source))
		end
	end)

addCommandHandler("performance",
	function (sourcePlayer, commandName, targetPlayer)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 7 and targetPlayer and client and client == source then
			targetPlayer = exports.seal_core:findPlayer(sourcePlayer, targetPlayer)

			if targetPlayer then
				triggerClientEvent(sourcePlayer, "clientPerformance", targetPlayer)
			end
		end
	end)