local screenX, screenY = guiGetScreenSize()
local isVisible = false
local clickTime = 0

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function()
		for k, v in pairs(pedPositions) do
			bankPed = createPed(233, v[1], v[2], v[3], v[4])
			setElementData(bankPed, "visibleName", v[5])
			setElementData(bankPed, "pedType", "Banki ügyintéző")
			setElementData(bankPed, "invulnerable", true)
			setElementData(bankPed, "bankPed.id", k)

			setElementFrozen(bankPed, true)
		end
	end
)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if not isVisible then
		if button == "right" and state == "down" and clickedElement then
			if getElementType(clickedElement) == "ped" and getElementData(clickedElement, "bankPed.id") then
			p1, p2, p3 = getElementPosition(localPlayer)
			clicked1, clicked2, clicked3 = getElementPosition(clickedElement)
				if (getDistanceBetweenPoints3D(p1, p2, p3, clicked1, clicked2, clicked3)) <= 2 then
					playerMoney = getElementData(localPlayer, "char.Money") or 0
					playerBankMoney = getElementData(localPlayer, "char.bankMoney") or 0
					isVisible = true
				
					createPanel()
				end
			end
		end
	end
end)

function createPanel()
	if guiBG then
		exports.seal_gui:deleteGuiElement(guiBG)
	end
	guiBG = false

	showCursor(true)

	local panelSizeW, panelSizeH = 500, 240
	local panelPosX, panelPosY = screenX / 2 - (panelSizeW / 2), screenY / 2 - (panelSizeH / 2)

	local panelTitleHeight = 35
	local buttonWidth, buttonHeight = (panelSizeW / 2) - 15, 35

	guiBG = exports.seal_gui:createGuiElement("rectangle", panelPosX, panelPosY, panelSizeW, panelSizeH)
	exports.seal_gui:setGuiBackground(guiBG, "solid", "grey2")

	local bg = exports.seal_gui:createGuiElement("rectangle", 0, 0, panelSizeW, panelTitleHeight, guiBG)
	exports.seal_gui:setGuiBackground(bg, "solid", "grey1")

	local label = exports.seal_gui:createGuiElement("label", 5, 0, panelSizeW, panelTitleHeight, bg)
	exports.seal_gui:setLabelText(label, "SealMTA - Bank")
	exports.seal_gui:setLabelFont(label, "14/Ubuntu-R.ttf")
	exports.seal_gui:setLabelAlignment(label, "left", "center")

	bankMoneyLabel = exports.seal_gui:createGuiElement("label", 0, panelTitleHeight, panelSizeW, panelTitleHeight, bg)
	exports.seal_gui:setLabelText(bankMoneyLabel, "Elérhető egyenleg: #4adfbf" .. formatNumber(playerBankMoney) .. "#ffffff $")
	exports.seal_gui:setLabelFont(bankMoneyLabel, "14/Ubuntu-R.ttf")
	exports.seal_gui:setLabelAlignment(bankMoneyLabel, "center", "center")

	moneyLabel = exports.seal_gui:createGuiElement("label", 0, panelTitleHeight * 2 - 10, panelSizeW, panelTitleHeight, bg)
	exports.seal_gui:setLabelText(moneyLabel, "Elérhető készpénz: #4adfbf" .. formatNumber(playerMoney) .. "#ffffff $")
	exports.seal_gui:setLabelFont(moneyLabel, "14/Ubuntu-R.ttf")
	exports.seal_gui:setLabelAlignment(moneyLabel, "center", "center")

	input = exports.seal_gui:createGuiElement("input", 10, panelSizeH - (buttonHeight * 3) - 30, panelSizeW - 20, buttonHeight, bg)
    exports.seal_gui:setInputPlaceholder(input, "Összeg")
    exports.seal_gui:setInputFont(input, "14/Ubuntu-R.ttf")
    exports.seal_gui:setInputMaxLength(input, 24)
	exports.seal_gui:setInputIcon(input, "coins")
    exports.seal_gui:setInputNumberOnly(input, true)

	local button = exports.seal_gui:createGuiElement("button", 10, panelSizeH - (buttonHeight * 2) - 20, buttonWidth, buttonHeight, bg)
	exports.seal_gui:setButtonText(button, "Kivétel")
	exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	exports.seal_gui:setGuiBackground(button, "solid", "primary")
	exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, 60)
	exports.seal_gui:setClickEvent(button, "depositMoney")

	local button = exports.seal_gui:createGuiElement("button", panelSizeW - buttonWidth - 10, panelSizeH - (buttonHeight * 2) - 20, buttonWidth, buttonHeight, bg)
	exports.seal_gui:setButtonText(button, "Berakás")
	exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	exports.seal_gui:setGuiBackground(button, "solid", "primary")
	exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, 60)
	exports.seal_gui:setClickEvent(button, "withdrawMoney")

	local button = exports.seal_gui:createGuiElement("button", 10, panelSizeH - buttonHeight - 10, panelSizeW - 20, buttonHeight, bg)
	exports.seal_gui:setButtonText(button, "Kilépés")
	exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	exports.seal_gui:setGuiBackground(button, "solid", "red")
	exports.seal_gui:setGuiHover(button, "gradient", {"red", "red-second"}, 60)
	exports.seal_gui:setClickEvent(button, "closePanel")
end

local withdrawTick = 0

addEvent("withdrawMoney", true)
addEventHandler("withdrawMoney", getRootElement(),
	function()
		if (exports.seal_network:getNetworkStatus()) then 
			if guiBG then
				exports.seal_gui:deleteGuiElement(guiBG)
			end
			guiBG = false
			isVisible = false
			return 
		else
			isVisible = true
		end

		if isVisible then
			if input then
				if getTickCount() - withdrawTick > 3000 then
					local inputValue = exports.seal_gui:getInputValue(input)

					if inputValue == "" then
						return
					end

					local inputValue = tonumber(inputValue)

					if inputValue > getElementData(localPlayer, "char.Money") then
						exports.seal_hud:showInfobox("error", "Nincsen ennyi pénzed!")
					end

					if inputValue > 0 then
						withdrawTick = getTickCount()
						triggerServerEvent("seal_bankS:givePlayerBankMoney", localPlayer, localPlayer, inputValue)
					else
						exports.seal_hud:showInfobox("error", "Az összegnek nagyobbnak kell lennie, mint 0!")
					end
				end
			end
		end
	end
)

local depositTick = 0

addEvent("depositMoney", true)
addEventHandler("depositMoney", getRootElement(),
	function()
		if (exports.seal_network:getNetworkStatus()) then 
			if guiBG then
				exports.seal_gui:deleteGuiElement(guiBG)
			end
			guiBG = false
			isVisible = false
			return 
		else
			isVisible = true
		end

		if isVisible then
			if input then
				if getTickCount() - depositTick > 3000 then
					local inputValue = exports.seal_gui:getInputValue(input)

					if inputValue == "" then
						return
					end

					local inputValue = tonumber(inputValue)

					if inputValue > getElementData(localPlayer, "char.bankMoney") then
						exports.seal_hud:showInfobox("error", "Nincsen ennyi pénz a kártyádon!")
					end

					if inputValue > 0 then
						depositTick = getTickCount()
						triggerServerEvent("seal_bankS:takePlayerBankMoney", localPlayer, localPlayer, inputValue)
					else
						exports.seal_hud:showInfobox("error", "Az összegnek nagyobbnak kell lennie, mint 0!")
					end
				end
			end
		end
	end
)

addEvent("closePanel", true)
addEventHandler("closePanel", getRootElement(),
	function()
		if isVisible then
			playerMoney = false
			playerBankMoney = false
			isVisible = false
			showCursor(false)

			if guiBG then
				exports.seal_gui:deleteGuiElement(guiBG)
			end
			guiBG = false
		end
	end
)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if not isVisible then
		if button == "right" and state == "down" and clickedElement then
			if getElementType(clickedElement) == "object" and getElementData(clickedElement, "bankId") then
				if getElementData(clickedElement, "atm.robbery") then return end
                p1, p2, p3 = getElementPosition(localPlayer)
                clicked1, clicked2, clicked3 = getElementPosition(clickedElement)
				if (getDistanceBetweenPoints3D(p1, p2, p3, clicked1, clicked2, clicked3)) <= 2 then
					playerMoney = getElementData(localPlayer, "char.Money") or 0
					playerBankMoney = getElementData(localPlayer, "char.bankMoney") or 0
					isVisible = true
					
					createPanel()
				end
			end
		end
	end
end)

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

addEventHandler("onClientElementDataChange", localPlayer,
	function(dataName)
		if isVisible then
			if dataName == "char.Money" then
				playerMoney = getElementData(source, "char.Money") or 0
				exports.seal_gui:setLabelText(moneyLabel, "Elérhető készpénz: #4adfbf" .. formatNumber(playerMoney) .. "#ffffff $")
			elseif dataName == "char.bankMoney" then
				playerBankMoney = getElementData(source, "char.bankMoney") or 0
				exports.seal_gui:setLabelText(bankMoneyLabel, "Elérhető egyenleg: #4adfbf" .. formatNumber(playerBankMoney) .. "#ffffff $")
			end
		end
	end
)