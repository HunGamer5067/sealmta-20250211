local oldRPH = updateElementRpHAnim
local updateRPHList = {}
function updateElementRpHAnim(el)
	updateRPHList[el] = true
end

addEventHandler("onClientPedsProcessed", getRootElement(), function()
	for el in pairs(updateRPHList) do
		updateRPHList[el] = nil
		oldRPH(el)
	end
end, true, "low-99999999")