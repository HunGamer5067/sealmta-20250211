local connection = false

addEventHandler("onResourceStart", getRootElement(),
    function (startedResource)
        if getResourceName(startedResource) == "seal_database" then
            connection = exports.seal_database:getConnection()
        elseif source == getResourceRootElement() then
            if getResourceFromName("seal_database") and getResourceState(getResourceFromName("seal_database")) == "running" then
                connection = exports.seal_database:getConnection()
            end
        end
    end
)

function formatNumber(amount, stepper)
	amount = tonumber(amount)

	if not amount then
		return ""
	end

	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

function takePlayerBankMoney(player, amount)
    if isElement(source) and client == source then
        if amount then
            amount = tonumber(amount)

            if amount then
                amount = math.floor(amount)

                if amount then
                    local chargeAmount = math.floor(amount * 0.03)
                    local currentBalance = getElementData(source, "char.bankMoney") or 0
                    if currentBalance < amount then
                        return
                    end
                    local newBalance = currentBalance - amount

                    if exports.seal_core:giveMoney(source, amount - chargeAmount) then
                        setElementData(source, "char.bankMoney", newBalance)

                        outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen kivettél #4adfbf" .. formatNumber(amount) .. " $-t #ffffffa számládról.", source, 255, 255, 255, true)
                        exports.seal_anticheat:sendDiscordMessage("**"..getElementData(source, "visibleName"):gsub("_", " ").."** kivett a bankból **" .. formatNumber(amount) .."$**", "moneylog")
                        outputChatBox("Új egyenleged: #4adfbf" .. formatNumber(newBalance) .. " $", source, 255, 255, 255, true)
                        outputChatBox("Kezelési költség: #4adfbf" .. formatNumber(chargeAmount) .. " $", source, 255, 255, 255, true)

                        exports.seal_hud:showInfobox(source, "success", "Sikeres tranzakció! Részletek a chatboxban!")
                    end
                end
            end
        end
    end
end
addEvent("seal_bankS:takePlayerBankMoney", true)
addEventHandler("seal_bankS:takePlayerBankMoney", root, takePlayerBankMoney)

function givePlayerBankMoney(player, amount)
    if isElement(source) and client == source then
        if amount then
            amount = tonumber(amount)

            if amount then
                amount = math.floor(amount)

                if amount then
                    local chargeAmount = math.floor(amount * 0.03)
                    local currentBalance = getElementData(source, "char.bankMoney") or 0
                    local newBalance = currentBalance + amount - chargeAmount

                    if exports.seal_core:takeMoneyEx(source, amount) then
                        setElementData(source, "char.bankMoney", newBalance)

                        outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen befizettél #4adfbf" .. formatNumber(amount) .. " $-t #ffffffa számládra.", source, 255, 255, 255, true)
                        
                        outputChatBox("Új egyenleged: #4adfbf" .. formatNumber(newBalance) .. " $", source, 255, 255, 255, true)
                        outputChatBox("Kezelési költség: #4adfbf" .. formatNumber(chargeAmount) .. " $", source, 255, 255, 255, true)

                        exports.seal_hud:showInfobox(source, "success", "Sikeres tranzakció! Részletek a chatboxban!")
                    end
                end
            end
        end
    end
end
addEvent("seal_bankS:givePlayerBankMoney", true)
addEventHandler("seal_bankS:givePlayerBankMoney", root, givePlayerBankMoney)