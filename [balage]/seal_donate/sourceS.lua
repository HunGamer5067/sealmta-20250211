local connection = false

addEventHandler("onResourceStart", getRootElement(), function(res)
    local resName = getResourceName(res)

    if res == getThisResource() then
        connection = exports.seal_database:getConnection()
    elseif resName == "seal_database" then
        connection = exports.seal_database:getConnection()
    end
end)

function gotDonationFromPlayer(accountId, premiumAmount)
    local accountId = tonumber(accountId) or false
    local premiumAmount = tonumber(premiumAmount) or false

    if accountId and premiumAmount then
        local playerElement = getPlayerFromAccountId(accountId)

        if playerElement then
            local playerPremiumAmount = getElementData(playerElement, "acc.premiumPoints") or 0
            local newPremiumAmount = playerPremiumAmount + premiumAmount

            setElementData(playerElement, "acc.premiumPoints", newPremiumAmount)
            dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPremiumAmount, accountId)
            exports.seal_gui:showInfobox(playerElement, "s", "Köszönjük, hogy támogattad a szervert! (" .. formatNumber(premiumAmount) .. " PP)")
        else
            dbExec(connection, "UPDATE accounts SET premiumPoints = premiumPoints + ? WHERE accountId = ?", premiumAmount, accountId)
        end
    end
end

function formatNumber(number, sep)
    local sep = " "
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

function getPlayerFromAccountId(accountId)
    local playerElement = false

    for _, player in pairs(getElementsByType("player")) do
        local playerAccountId = getElementData(player, "char.accID") or false

        if playerAccountId and accountId == playerAccountId then
            playerElement = player
            break
        end
    end

    return playerElement
end