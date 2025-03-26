addEvent("onLightning", true)
addEventHandler("onLightning", getRootElement(), function(boltX, boltY, boltZ)
	if getElementData(source, "acc.adminLevel") < 9 then return end
	triggerClientEvent("onLightning", source, boltX, boltY, boltZ)
end)