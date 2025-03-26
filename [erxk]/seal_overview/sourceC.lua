local screenW, screenH = guiGetScreenSize()

local dataState = false

addEvent("requestedCharDatas", true)
addEventHandler("requestedCharDatas", getRootElement(),
    function(charDatas, accDatas)
        if charDatas and accDatas then
            accountDatas = accDatas
            characterDatas = charDatas
            foundedPlayerRender(charDatas)
            dataState = true
        end
    end
)

function renderPanel()
    local mainW, mainH = 300, 150
    local mainPosX, mainPosY = (screenW - mainW) / 2, (screenH - mainH) / 2

    mainBg = exports.seal_gui:createGuiElement("window", mainPosX, mainPosY, mainW, mainH)
    exports.seal_gui:setWindowTitle(mainBg, "16/BebasNeueRegular.otf", "SealMTA - Overview")
    exports.seal_gui:setWindowCloseButton(mainBg, "destroyMainPanel")

    accidInput = exports.seal_gui:createGuiElement("input", 10, 40, mainW - 20, 30, mainBg)
    exports.seal_gui:setInputIcon(accidInput, "search")
    exports.seal_gui:setInputFont(accidInput, "14/BebasNeueRegular.otf")
    exports.seal_gui:setInputPlaceholder(accidInput, "AccountID")
    exports.seal_gui:setInputMaxLength(accidInput, 24)

    playerNameInput = exports.seal_gui:createGuiElement("input", 10, 75, mainW - 20, 30, mainBg)
    exports.seal_gui:setInputIcon(playerNameInput, "search")
    exports.seal_gui:setInputFont(playerNameInput, "14/BebasNeueRegular.otf")
    exports.seal_gui:setInputPlaceholder(playerNameInput, "Karakternév (Példa_Név)")
    exports.seal_gui:setInputMaxLength(playerNameInput, 24)

    local button = exports.seal_gui:createGuiElement("button", 10, 110, mainW - 20, 30, mainBg)
    exports.seal_gui:setButtonFont(button, "14/BebasNeueRegular.otf")
    exports.seal_gui:setButtonText(button, "Keresés...")
    exports.seal_gui:setClickEvent(button, "tryToFind")
end

function destroyMainPanel()
    if exports.seal_gui:isGuiElementValid(mainBg) then
        exports.seal_gui:deleteGuiElement(mainBg)
    end
end

addEvent("destroyMainPanel", true)
addEventHandler("destroyMainPanel", getRootElement(),
    function()
        if exports.seal_gui:isGuiElementValid(mainBg) then
            exports.seal_gui:deleteGuiElement(mainBg)
        end
    end
)

function foundedPlayerRender(data)
    local charDatas = data.characters
    local accountData = data.account
    local bans = data.bans or {}

    if exports.seal_gui:isGuiElementValid(mainBg) then
        exports.seal_gui:deleteGuiElement(mainBg)
    end

    if dataState then

        local mainW, mainH = 600, 530
        local mainPosX, mainPosY = screenW / 2 - mainW / 2, screenH / 2 - mainH / 2

        local posY = 0

        local charDataText = "\n"

        -- Karakter adatok megjelenítése
        local dataNames = {"Karakternév", "Account ID", "Készpénz", "Bankban lévő pénz", "Kaszinó coin", "Életkor", "Skin ID", "Utoljára aktív", "Játszott percek"}
        local dataValues = {"name", "accountId", "money", "bankMoney", "slotCoins", "age", "skin", "lastOnline", "playedMinutes"}

        for i, charData in ipairs(charDatas) do
            for j, dataName in ipairs(dataNames) do
                local textColor = "#4adfbf"
                local value = charData[dataValues[j]]

                if value then
                    charDataText = charDataText .. textColor .. dataName .. ": #ffffff" .. value .. "\n"
                end
            end
        end

        local accountDataNames = {"Felhasználónév", "Serial", "Prémiumpont", "Admin szint", "Admin név", "Regisztráció dátuma", "Adminjailben", "Adminjailben általa", "Adminjail perc", "Adminjail indok"}
        local accountDataValues = {"username", "serial", "premiumPoints", "adminLevel", "adminNick", "created", "adminJail", "adminJailBy", "adminJailTime", "adminJailReason"}

        local accountDataText = "\n"

        for i, accountDataName in ipairs(accountDataNames) do
            local value = accountData[accountDataValues[i]]
            if accountDataValues[i] == "adminLevel" then
                local adminLevels = {
                    "Admin 1", "Admin 2", "Admin 3", "Admin 4", "Admin 5",
                    "FőAdmin", "SzuperAdmin", "Modeller", "Manager", "Fejlesztő",
                    "Tulajdonos", "Rendszergazda"
                }
                --value = adminLevels[value] .. " (#4adfbf" .. value .. "#ffffff)" or "N/A"
            end
            if accountDataValues[i] == "premiumPoints" then
                value = value .. " PP"
            end

            if accountDataValues[i] == "username" and getElementData(localPlayer, "acc.adminLevel") < 6 then
                value = "******"
            end
            if accountDataValues[i] == "adminJail" then
                value = value == 1 and "Igen" or "-"
            end
            if accountDataValues[i] == "adminJailBy" or accountDataValues[i] == "adminJailReason" then
                value = value == "" and "-" or value
            end
            if accountDataValues[i] == "adminJailTime" and value < 1 then
                value = "-"
            end

            accountDataText = accountDataText .. "#4adfbf " .. accountDataName .. ": #ffffff" .. value .. "\n"
        end

            local banDataText = ""
            if #bans > 0 then
                for i, ban in ipairs(bans) do

                    if ban.deactivated == "No" then

                        local banDate = "-"
                        local banExpire = "-"
                        if ban.banTimestamp and ban.banTimestamp > 0 then
                            banDate = os.date("%Y-%m-%d %H:%M:%S", ban.banTimestamp)
                        end
                        if ban.expireTimestamp and ban.expireTimestamp > 0 then
                            banExpire = os.date("%Y-%m-%d %H:%M:%S", ban.expireTimestamp)
                        end

                        posY = posY + 97
                        mainH = mainH + 95
                        local banText = string.format(
                            "#4adfbfIndok: #ffffff%s\n#4adfbfAdmin: #ffffff%s\n#4adfbfKitiltás dátuma: #ffffff%s\n#4adfbfKitiltás lejárata: #ffffff%s\n",
                            ban.banReason or "-", ban.adminName or "-", banDate or "-", banExpire or "-"
                        )
                        banDataText = banDataText .. banText
                    end
                end
            end


        -- Egyesített szöveg
        local combinedText = charDataText .. accountDataText .. banDataText

        dataMain = exports.seal_gui:createGuiElement("window", mainPosX, mainPosY, mainW, mainH)
        exports.seal_gui:setWindowTitle(dataMain, "16/BebasNeueRegular.otf", "SealMTA - Karakter és fiók adatok")
        exports.seal_gui:setWindowCloseButton(dataMain, "destroyDataPanel")

        local charLabel = exports.seal_gui:createGuiElement("label", 5, posY, 580, 575, dataMain)
        exports.seal_gui:setLabelFont(charLabel, "14/BebasNeueRegular.otf")
        exports.seal_gui:setLabelText(charLabel, combinedText .. "\n")
        exports.seal_gui:setLabelAlignment(charLabel, "left", "bottom")
    end
end


function destroyDataPanel()
    if exports.seal_gui:isGuiElementValid(dataMain) then
        exports.seal_gui:deleteGuiElement(dataMain)
        dataState = false
    end
end

addEvent("destroyDataPanel", true)
addEventHandler("destroyDataPanel", getRootElement(),
    function()
        if exports.seal_gui:isGuiElementValid(dataMain) then
            exports.seal_gui:deleteGuiElement(dataMain)
            dataState = false
        end
    end
)

addEvent("tryToFind", true)
addEventHandler("tryToFind", getRootElement(),
    function()
        if accidInput then
            local foundAccID = exports.seal_gui:getInputValue(accidInput)
            local foundCharName = exports.seal_gui:getInputValue(playerNameInput)

            if foundAccID and foundCharName then
                destroyMainPanel()
                exports.seal_gui:showInfobox("error", "Egyszerre csak egy mezőt tölts ki!")
                return
            end

            if foundAccID and not foundCharName then
                triggerServerEvent("findPlayerFromAccID", resourceRoot, foundAccID)
                destroyMainPanel()
                dataState = true
            end

            if foundCharName and not foundAccID then
                triggerServerEvent("findPlayerFromName", resourceRoot, foundCharName)
                destroyMainPanel()
                dataState = true
            end
        end
    end
)


addCommandHandler("overview",
    function()
        if getElementData(localPlayer, "acc.adminLevel") >= 1 then
            triggerServerEvent("sendCharacterDatas", localPlayer)
            renderPanel()
        end
    end
)

function displayCharacterData(charDatas)
    local charDataStr = ""

    for _, charData in ipairs(charDatas) do
        charDataStr = charDataStr .. "Character Name: " .. charData.name .. "\n"
    end

    outputChatBox(charDataStr)
end