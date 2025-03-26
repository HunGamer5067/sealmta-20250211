local screenX, screenY = guiGetScreenSize()

local shopGui = false
local buyGui = false

local oneSizeW = 375
local oneSizeH = 35

local shopSizeW = 650
local shopSizeH = 13 * oneSizeH

local shopPosX = screenX / 2 - (shopSizeW /  2)
local shopPosY = screenY / 2 - (shopSizeH /  2)

local buySizeW = 350
local buySizeH = 160

local buyPosX = screenX / 2 - (buySizeW /  2)
local buyPosY = screenY / 2 - (buySizeH /  2)

local shopScroll = 0
local inputValue = 1
local shopCategory = 2

local buttons = {}
local images = {}
local texts = {}

local itemData = false
local guiShopElement = false

function createGui()
	if exports.seal_gui:isGuiElementValid(shopGui) then
		exports.seal_gui:deleteGuiElement(shopGui)
        shopGui = false
	end

    itemNames = exports.seal_items:getItemNameList()
    
    shopGui = exports.seal_gui:createGuiElement("window", shopPosX, shopPosY, shopSizeW, shopSizeH)
    exports.seal_gui:setWindowTitle(shopGui, "15/BebasNeueRegular.otf", "SealMTA - Shop")
    exports.seal_gui:setWindowCloseButton(shopGui, "closeShop")
    exports.seal_gui:setWindowElementMaxDistance(shopGui, guiShopElement, 3, "closeShop")

    for i = 1, 12 do
        local contentPosY = oneSizeH * i

        local rectangle = exports.seal_gui:createGuiElement("rectangle", 0, contentPosY, shopSizeW, 1, shopGui)
        exports.seal_gui:setGuiBackground(rectangle, "solid", "midgrey")

        local rectangle = exports.seal_gui:createGuiElement("rectangle", 0, contentPosY + 1, shopSizeW, 1, shopGui)
        exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

        if shopDatas[shopCategory][2][i + shopScroll] then
            local itemId = shopDatas[shopCategory][2][i + shopScroll][1]

            local text = exports.seal_gui:createGuiElement("label", 34, 0, contentPosY, oneSizeH, rectangle)
            exports.seal_gui:setLabelText(text, itemNames[itemId] .. " #4adfbf(" .. shopDatas[shopCategory][2][i + shopScroll][2] .. "$)")
            exports.seal_gui:setLabelFont(text, "14/BebasNeueRegular.otf")
            exports.seal_gui:setLabelAlignment(text, "left", "center")
            texts[i] = text

            local image = exports.seal_gui:createGuiElement("image", 5, 5.5, 24, 24, rectangle)
            exports.seal_gui:setImageFile(image, ":seal_items/files/items/" .. itemId - 1 .. ".png")
            images[i] = image

            local button = exports.seal_gui:createGuiElement("button", shopSizeW - 155, 5.5, 150, 24, rectangle)
            exports.seal_gui:setButtonText(button, "Megvásárlás")
            exports.seal_gui:setButtonFont(button, "12/BebasNeueRegular.otf")
            exports.seal_gui:setGuiBackground(button, "solid", "primary")
            exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, 60)
            exports.seal_gui:setClickEvent(button, "buyShopItem")
            buttons[i] = button
        end
    end

    addEventHandler("onClientKey", getRootElement(), shopKey)
end

function recreateList()
    for i = 1, 12 do
        local itemId = shopDatas[shopCategory][2][i + shopScroll][1]
        exports.seal_gui:setLabelText(texts[i], itemNames[itemId] .. " #4adfbf(" .. shopDatas[shopCategory][2][i + shopScroll][2] .. "$)")
        exports.seal_gui:setImageFile(images[i], ":seal_items/files/items/" .. itemId - 1 .. ".png")
    end
end

addEvent("buyShopItem", true)
addEventHandler("buyShopItem", getRootElement(), function(button, state, absX, absY, el)
    for i = 1, 12 do
        if exports.seal_gui:isGuiElementValid(shopGui) then
            if buttons[i] == el then
                local number = i + shopScroll
                if exports.seal_gui:isGuiElementValid(shopGui) then
                    exports.seal_gui:deleteGuiElement(shopGui)
                    shopGui = false
                    removeEventHandler("onClientKey", getRootElement(), shopKey)
                end

                itemData = number
                createBuyGui()
                break
            end
        end
    end
end)

function shopKey(key, press)
    if press then
        if shopGui then
            if key == "mouse_wheel_down" then
                if shopScroll < #shopDatas[shopCategory][2] - 12 then
                    shopScroll = shopScroll + 1
                    recreateList()
                end
            elseif key == "mouse_wheel_up" then
                if shopScroll > 0 then
                    shopScroll = shopScroll - 1
                    recreateList()
                end
            end
        end
    end
end

function createBuyGui()
    if exports.seal_gui:isGuiElementValid(buyGui) then
        exports.seal_gui:deleteGuiElement(buyGui)
        buyGui = false
    end

    local itemId = shopDatas[shopCategory][2][itemData][1]
    local itemPrice = shopDatas[shopCategory][2][itemData][2]

    buyGui = exports.seal_gui:createGuiElement("window", buyPosX, buyPosY, buySizeW, buySizeH)
    exports.seal_gui:setWindowTitle(buyGui, "15/BebasNeueRegular.otf", "SealMTA - Shop")
    exports.seal_gui:setWindowCloseButton(buyGui, "backToShop")
    exports.seal_gui:setWindowElementMaxDistance(buyGui, guiShopElement, 5, "backToShop")

    local label = exports.seal_gui:createGuiElement("label", 0, oneSizeH, buySizeW, oneSizeH, buyGui)
	exports.seal_gui:setLabelText(label, "Biztosan megszeretnéd vásárolni?")
	exports.seal_gui:setLabelFont(label, "14/BebasNeueRegular.otf")
	exports.seal_gui:setLabelAlignment(label, "center", "center")

    priceLabel = exports.seal_gui:createGuiElement("label", 0, oneSizeH + 25, buySizeW, oneSizeH, buyGui)
	exports.seal_gui:setLabelText(priceLabel, itemNames[itemId] .. " #4adfbf(" .. itemPrice * inputValue .. "$)")
	exports.seal_gui:setLabelFont(priceLabel, "14/BebasNeueRegular.otf")
	exports.seal_gui:setLabelAlignment(priceLabel, "center", "center")

    countLabel = exports.seal_gui:createGuiElement("label", 0, oneSizeH + 50, buySizeW, oneSizeH, buyGui)
	exports.seal_gui:setLabelText(countLabel, "Mennyiség: #4adfbf" .. inputValue .. " DB")
	exports.seal_gui:setLabelFont(countLabel, "14/BebasNeueRegular.otf")
	exports.seal_gui:setLabelAlignment(countLabel, "center", "center")

    buyButton = exports.seal_gui:createGuiElement("button", 5, 125, buySizeW - 10, 30, buyGui)
    exports.seal_gui:setButtonText(buyButton, "Megvásárlás")
    exports.seal_gui:setButtonFont(buyButton, "14/BebasNeueRegular.otf")
    exports.seal_gui:setGuiBackground(buyButton, "solid", "primary")
    exports.seal_gui:setGuiHover(buyButton, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickEvent(buyButton, "buyShopItemFinal")

    addEventHandler("onClientCharacter", getRootElement(), buyChar)
    addEventHandler("onClientKey", getRootElement(), buyKey)
end

addEvent("buyShopItemFinal", true)
addEventHandler("buyShopItemFinal", getRootElement(),
    function(guiElement)
        if exports.seal_gui:isGuiElementValid(buyGui) then
            triggerServerEvent("buyShopItem", localPlayer, itemData, shopCategory, tonumber(inputValue))
        end
    end
)

addEvent("backToShop", true)
addEventHandler("backToShop", getRootElement(),
    function()
        createGui()

        if exports.seal_gui:isGuiElementValid(buyGui) then
            exports.seal_gui:deleteGuiElement(buyGui)
            buyGui = false

            removeEventHandler("onClientCharacter", getRootElement(), buyChar)
            removeEventHandler("onClientKey", getRootElement(), buyKey)
        end
    end
)

function buyChar(char)
    if buyGui then
        if tonumber(char) then
            local inputLength = utf8.len(inputValue)
            
            if inputLength > 3 then
                return
            end

            if inputValue == "0" then
                inputValue = char
            else
                inputValue = inputValue .. char
            end

            local itemId = shopDatas[shopCategory][2][itemData][1]
            local itemPrice = shopDatas[shopCategory][2][itemData][2]

            exports.seal_gui:setLabelText(priceLabel, itemNames[itemId] .. " #4adfbf(" .. itemPrice * tonumber(inputValue)  .. "$)")
            exports.seal_gui:setLabelText(countLabel, "Mennyiség: #4adfbf" .. inputValue .. " DB")
        end
    end
    return
end

function buyKey(key, press)
    if buyGui then
        if press then
            if key == "backspace" then
                cancelEvent()

                local inputLength = utf8.len(inputValue)
                
                if inputLength > 0 then
                    inputValue = utf8.sub(inputValue, 1, -2)
                end

                if inputLength == 1 then
                    inputValue = "0"
                end

                local itemId = shopDatas[shopCategory][2][itemData][1]
                local itemPrice = shopDatas[shopCategory][2][itemData][2]

                exports.seal_gui:setLabelText(priceLabel, itemNames[itemId] .. " #4adfbf(" .. itemPrice * tonumber(inputValue)  .. "$)")
                exports.seal_gui:setLabelText(countLabel, "Mennyiség: #4adfbf" .. inputValue .. " DB")
            end
        end
    end
end

addEventHandler("onClientClick", getRootElement(),
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if not shopGui and not buyGui then
            if button and state == "down" then
                if isElement(clickedElement) then
                    if getElementData(clickedElement, "shopPed") then
                        local localPosX, localPosY, localPosZ = getElementPosition(localPlayer)
                        local pedPosX, pedPosY, pedPosZ = getElementPosition(clickedElement)

                        if getDistanceBetweenPoints3D(pedPosX, pedPosY, pedPosZ, localPosX, localPosY, localPosZ) < 3 then
                            shopScroll = 0
                            inputValue = 1
                            shopCategory = getElementData(clickedElement, "shopType") or 1

                            exports.seal_items:toggleActionBarUse(true)

                            if shopCategory == 6 then
                                local playerLevel = exports.seal_core:getLevel(localPlayer) or 0
                                local hasWeaponLicense = exports.seal_items:playerHasItem(75)

                                if playerLevel <= 5 then
                                    exports.seal_gui:showInfobox("error", "A fegyverbolt csak 5. szinttől elérhető.")
                                    return
                                end

                                if not hasWeaponLicense then
                                        exports.seal_gui:showInfobox("error", "A fegyverbolt csak fegyverviselési engedéllyel látogatható.")
                                    return
                                end

                                guiShopElement = clickedElement
                                createGui()
                            elseif shopCategory ~= 6 then
                                guiShopElement = clickedElement
                                createGui()
                            end
                        end
                   end
                end
            end
        end
    end
)

addEvent("closeShop", true)
addEventHandler("closeShop", getRootElement(),
    function()
        if exports.seal_gui:isGuiElementValid(shopGui) then
            exports.seal_gui:deleteGuiElement(shopGui)
            shopGui = false
            removeEventHandler("onClientKey", getRootElement(), shopKey)
            exports.seal_items:toggleActionBarUse(false)
            guiShopElement = false
        end 
    end
)

addCommandHandler("nearbyshops",
	function(commandName)
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
            local distance = 15
			local localPosX, localPosY, localPosZ = getElementPosition(localPlayer)
			local availablePeds = {}

            for k, v in pairs(getElementsByType("ped", getResourceRootElement(), true)) do
                local isShopPed = getElementData(v, "shopPed") or false

                if isShopPed then
                    local shopPosX, shopPosY, shopPosZ = getElementPosition(v)

                    if getDistanceBetweenPoints3D(localPosX, localPosY, localPosZ, shopPosX, shopPosY, shopPosZ) <= distance then
                        table.insert(availablePeds, {getElementData(v, "shop.id") or 0, getElementData(v, "visibleName"), getElementDimension(v), getElementInterior(v)})
                    end
                end
            end

			if #availablePeds > 0 then
				outputChatBox("#4adfbf[SealMTA - Bolt]: #ffffffKözeledben lévő boltok (" .. distance .. " yard):", 255, 255, 255, true)
				
                for k, data in ipairs(availablePeds) do
                    outputChatBox("    Név: #4adfbf" .. data[2]:gsub("_", " ") .. " #ffffffAzonosító: #4adfbf" .. data[1] .. " #ffffffDimenzió: #4adfbf" .. data[3] .. " #ffffffInterior: #4adfbf" .. data[4], 255, 255, 255, true)
                end
			else
                outputChatBox("[SealMTA - Hiba]: #ffffffNincs a közeledben egy bolt sem.", sourcePlayer, 215, 89, 89, true)
			end
		end
	end)