local adminTitles = {
	[1] = "Admin 1",
	[2] = "Admin 2",
	[3] = "Admin 3",
	[4] = "Admin 4",
	[5] = "Admin 5",
	[6] = "FőAdmin",
	[7] = "SzuperAdmin",
	[8] = "Modeller",
	[9] = "Manager",
	[10] = "Fejlesztő",
	[11] = "Tulajdonos",
	[12] = "Rendszergazda"
}

local levelColors = {
	[1] = "#4adfbf",
	[2] = "#4adfbf",
	[3] = "#4adfbf",
	[4] = "#4adfbf",
	[5] = "#4adfbf",
	[6] = "#f3d65a",
	[7] = "#ff9514",
	[8] = "#fab328",
	[9] = "#3cb8aa",
	[10] = "#31b4e1",
	[11] = "#f35a5a",
	[12] = "#32BA9D"
}

function getPlayerAdminTitle(player)
	return adminTitles[getPlayerAdminLevel(player)] or false
end

function getAdminLevelColor(adminLevel)
	return levelColors[tonumber(adminLevel)] or "#4adfbf"
end

function getPlayerAdminLevel(player)
	return isElement(player) and tonumber(getElementData(player, "acc.adminLevel")) or 0
end

function getPlayerAdminNick(player,val)

	playerName = isElement(player) and getElementData(player, "acc.adminNick")

	if val then
		if (getElementData(player, "adminDuty") or 0) == 1 then
			playerName = isElement(player) and getElementData(player, "acc.adminNick")
		else
			playerName = isElement(player) and getElementData(player, "char.Name")
		end
	end
	
	return playerName
end


local developerSerials = {
	["0EB993DA466366F4F7A9DE8AD585B391"] = true, -- erxk
	["AC224757ECF1FABAE6C7319C5935F153"] = true, -- babi
	-- ["D90DAD1A3C9C3F779CA43AFFD9CF44A2"] = true, -- balage
	-- ["E1DB5F3FC88337507391CD971F1A5C13"] = true, -- viktor
}

function isPlayerDeveloper(element)
	if developerSerials[getPlayerSerial(element)] then
		return true
	end

	return false
end

adminCommands = {
	["resetduty"] = 7,
	["resetdutyoffline"] = 7,
	["listallduty"] = 7,
	["resetallduty"] = 7,
	["listalladmin"] = 7,
	["setdim"] = 5,
	["setint"] = 5,
	["gotovehplayer"] = 1,
}

function isHavePermission(element, command)
	if isPlayerDeveloper(element) then
		return true
	end

	if adminCommands[command] then
		local adminLevel = getElementData(element, "acc.adminLevel") or 0

		if adminLevel >= adminCommands[command] then
			return true
		end
	end

	return false
end