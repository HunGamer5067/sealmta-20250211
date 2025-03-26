local enabledGroups = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4]	= true,
}

local white = "#FFFFFF"
local serverColor = "#4adfbf"

addEvent("onTrafiHit", true)
addEventHandler("onTrafiHit", root, function(ticketPrice, vehicleSpeed, speedLimit)
	if source ~= client then
		return
	end

	if ticketPrice < 0 then 
		local punishmentStart = getTickCount()
		local logText = "PLAYER BANNED - " .. getPlayerName(client) .. "\n"
	
		logText = logText .. "BAN DETAILS:" .. "\n"
		logText = logText .. "  REASON: " .. "onTrafiHit unvalid" .. "\n"
		logText = logText .. "  DESCRIPTION: " .. tostring(ticketPrice) .. "\n"
		 
		logText = logText .. "PLAYER DETAILS:" .. "\n"
		logText = logText .. "  SERIAL: " .. getPlayerSerial(client) .. "\n"
		logText = logText .. "  IP ADDRESS: " .. getPlayerIP(client) .. "\n"
	
		logText = logText .. "PUNISHED IN " .. getTickCount() - punishmentStart .. "ms"
	
		exports.seal_anticheat:sendDiscordMessage(logText, "anticheat")
		
		banPlayer(client, true, false, true, "ANTICHEAT", "AC #412")
	end

	local vehicle = getPedOccupiedVehicle(client)
	local vehicleGroup = getElementData(vehicle, "vehicle.group") or 0

	if not enabledGroups[vehicleGroup] then
		outputChatBox ("#dc4949[Traffipax] #ffffffÁtlépted a sebességhatárt, megengedett sebesség: " .. serverColor .. speedLimit .."#ffffff km/h!", client, 255,255,255,true)
		outputChatBox ("#dc4949[Traffipax] #ffffffA túllépés mértéke: " .. math.ceil(vehicleSpeed) .. "km/h #ffffffBirság: ".. serverColor .. formatMoney(math.floor(ticketPrice)) .. white .. " $", client, 255,255,255,true)
		
		local playerMoney = getElementData(source, "char.Money")
		local playerTicket = playerMoney - ticketPrice
		setElementData(source, "char.Money", playerTicket)

		local policeGroupBalance = exports.seal_groups:getGroupBalance(1)

		if policeGroupBalance then
			exports.seal_groups:setGroupBalance(1, policeGroupBalance + (ticketPrice / 2))
		end
	end
end)

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end