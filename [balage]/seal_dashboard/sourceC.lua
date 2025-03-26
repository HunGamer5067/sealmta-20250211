local screenX, screenY = guiGetScreenSize()

local dashboardFadeIn = false
local dashboardFadeOut = false
local dashboardFadeSpeed = 500

local dashboardAlpha = 0

local dashboardWidth = 1200
local dashboardHeight = 680

local dashboardPosX = (screenX - dashboardWidth) / 2
local dashboardPosY = (screenY - dashboardHeight) / 2

local dashboardSelectedMenu = "information"
local dashboardMenus = {
    {
        menuName = "information",
        menuTitle = "Információ",
        menuIcon = "files/images/info.png",
    },

    {
        menuName = "vehicles",
        menuTitle = "Járművek",
        menuIcon = "files/images/car.png",
    },

    {
        menuName = "interiors",
        menuTitle = "Ingatlanok",
        menuIcon = "files/images/home.png",
    },

    {
        menuName = "factions",
        menuTitle = "Frakciók",
        menuIcon = "files/images/users.png",
    },

    {
        menuName = "premiumshop",
        menuTitle = "PrémiumShop",
        menuIcon = "files/images/shopping_cart.png",
    },

    {
        menuName = "admins",
        menuTitle = "Adminisztrátorok",
        menuIcon = "files/images/user_cog.png",
    },

    {
        menuName = "settings",
        menuTitle = "Beállítások",
        menuIcon = "files/images/cogs.png",
    },
}

local dashboardDatas = {}
local dashboardDataNames = {
    ["visibleName"] = true,
    ["char.accID"] = true,
    ["char.ID"] = true,
    ["char.Money"] = true,
    ["char.bankMoney"] = true,
    ["acc.premiumPoints"] = true,
    ["char.slotCoins"] = true,
    ["char.Age"] = true,
    ["char.Skin"] = true,
    ["char.playedMinutes"] = true,
    ["acc.adminLevel"] = true,
    ["acc.adminNick"] = true,
    ["acc.helperLevel"] = true,
    ["acc.created"] = true,
    ["acc.emailAddress"] = true,
    ["acc.username"] = true,
    ["char.Hunger"] = true,
    ["char.Thirst"] = true,
    ["char.maxVehicles"] = true,
    ["char.interiorLimit"] = true,
}

local interiorTypes = {
    business_passive = "Passzív Biznisz",
    business_active = "Aktív Biznisz",
    building = "Középület",
    garage = "Garázs",
    building2 = "Zárható Középület",
    rentable = "Bérlakás",
    house = "Ház"
}

local numberToBoolean = {}
local tuningName = {
    [0] = "#d75959Gyári",
    [1] = "#FF9600Alap",
    [2] = "#FF9600Profi",
    [3] = "#FF9600Verseny",
    [4] = "#32b3efVenom",
    [5] = "#32b3efVenom+SC."
}

local dashboardFightningStyleNames = {"Sima", "Boxoló", "Kung-Fu", "Térdelős", "Kick-Box", "Könyök"}
local dashboardFightningStyles = {4, 5, 6, 7, 15, 16}
local dashboardFightningStylesEx = {}

local dashboardWalkingStyleNames = {"Alap", "Öreges #1", "Öreges #2", "Bandás #1", "Bandás #2", "Öreges #3", "Túlsúlyos", "Részeg", "Alap", "Női #1", "Öreges Női #1", "Női #2", "Női #3", "Női #4", "Öreges női #2", "Túlsúlyos Női" , "Öreges Női Túlsúlyosos"}
local dashboardWalkingStyles = {118, 119, 120, 121, 122, 123, 124, 126, 128, 129, 130, 131, 132, 133, 134, 135, 137}
local dashboardWalkingStylesEx = {}

local dashboardTalkingStyles = {"prtial_gngtlka", "prtial_gngtlkb", "prtial_gngtlkc", "prtial_gngtlkd", "prtial_gngtlke", "prtial_gngtlkf", "prtial_gngtlkg", "prtial_gngtlkh", "prtial_hndshk_01", "prtial_hndshk_biz_01", "false"}
local dashboardTalkingStylesEx = {}

local dashboardInformations = {
    { infoTitle = "Karakter Név: ", infoDataName = "visibleName" },
    { infoTitle = "Karakter ID: ", infoDataName = "char.ID" },
    { infoTitle = "Készpénz: ", infoDataName = "char.Money", infoSuffix = " $", formatNumber = true },
    { infoTitle = "Bankban lévő pénz: ", infoDataName = "char.bankMoney", infoSuffix = " $", formatNumber = true },
    { infoTitle = "Prémium Pontok: ", infoDataName = "acc.premiumPoints", infoSuffix = " PP", formatNumber = true },
    { infoTitle = "Slot Coinok: ", infoDataName = "char.slotCoins", infoSuffix = " SSC", formatNumber = true },
    { infoTitle = "Játszott percek: ", infoDataName = "char.playedMinutes", infoSuffix = " perc", formatNumber = true },
    { infoTitle = "Skin: ", infoDataName = "char.Skin" },
    { infoTitle = "Kor: ", infoDataName = "char.Age", infoSuffix = " éves" },
    { breakLine = true },
    { infoTitle = "Felhasználónév: ", infoDataName = "acc.username", hideMode = true },
    { infoTitle = "E-mail cím: ", infoDataName = "acc.emailAddress", hideMode = true },
    { infoTitle = "Serial: ", infoDataName = "serial" },
    { infoTitle = "Account ID: ", infoDataName = "char.accID" },
    { infoTitle = "Admin szint: ", infoDataName = "acc.adminLevel" },
    { infoTitle = "Admin név: ", infoDataName = "acc.adminNick" },
    { infoTitle = "Adminsegéd szint: ", infoDataName = "acc.helperLevel" },
    { infoTitle = "Regisztráció dátuma: ", infoDataName = "acc.created" },
}

local dashboardVehicleInformations = {
    { infoTitle = "", infoDataName = "color", formatColor = true },
    { breakLine = true },
    { infoTitle = "Frakció: ", infoDataName = "groupId", formatGroup = true },
    { infoTitle = "ModelId: ", infoDataName = "modelId" },
    { infoTitle = "Rendszám: ", infoDataName = "plate" },
    { infoTitle = "Jármű állapota: ", infoDataName = "health" },
    { infoTitle = "Motor: ", infoDataName = "engine" },
    { infoTitle = "Lámpák: ", infoDataName = "lights" },
    { infoTitle = "Zárva: ", infoDataName = "locked" },
    { infoTitle = "Kézfiék: ", infoDataName = "handbrake" },
    { infoTitle = "Üzemanyag: ", infoDataName = "fuel" },
    { infoTitle = "Lefoglalva: ", infoDataName = "impounded" },
    { breakLine = true },
    { infoTitle = "Motor Tuning: ", infoDataName = "tuningEngine" },
    { infoTitle = "Turbó Tuning: ", infoDataName = "tuningTurbo" },
    { infoTitle = "Váltó Tuning: ", infoDataName = "tuningTransmission" },
    { infoTitle = "ECU Tuning: ", infoDataName = "tuningECU" },
    { infoTitle = "Kerék Tuning: ", infoDataName = "tuningTires" },
    { infoTitle = "Fék Tuning: ", infoDataName = "tuningBrakes" },
    { infoTitle = "Felfüggesztés Tuning: ", infoDataName = "tuningSuspension" },
    { infoTitle = "Súlycsökkentés Tuning: ", infoDataName = "tuningWeightReduction" },
    { infoTitle = "Nitró: ", infoDataName = "tuningNitroLevel" },
    { infoTitle = "Spinner: ", infoDataName = "tuningSpinners", rightSide = true },
    { infoTitle = "Airride: ", infoDataName = "tuningAirRide", rightSide = true },
    { infoTitle = "Drivetype: ", infoDataName = "tuningDriveType", rightSide = true },
    { infoTitle = "Neon: ", infoDataName = "tuningNeon", rightSide = true },
    { breakLine = true },
    { infoTitle = "Egyedi Kerekek: ", infoDataName = "customWheel", rightSide = true },
    { infoTitle = "Egyedi Matrica: ", infoDataName = "tuningPaintjob", rightSide = true },
    { infoTitle = "Egyedi Turbó: ", infoDataName = "customTurbo", rightSide = true },
    { infoTitle = "Egyedi Backfire: ", infoDataName = "customBackfire", rightSide = true },
}

local dashboardInteriorInformations = {
    { infoTitle = "Tulajdonos: ", infoDataName = "ownerName" },
    { infoTitle = "", infoDataName = "price" },
    { infoTitle = "Interior Belső: ", infoDataName = "gameInterior" },
    { infoTitle = "Egyed Interior: ", infoDataName = "editable" },
    { infoTitle = "Zárva: ", infoDataName = "locked" },
    { infoTitle = "Típus: ", infoDataName = "type" },
}

local dashboardSettings = {
    { optionTitle = "Sétastílus:", optionDataName = "walkingStyle", defaultValue = 1 },
    { optionTitle = "Beszédstílus:", optionDataName = "talkingStyle", optionSuffix = "-es beszédstílus", defaultValue = 1 },
    { optionTitle = "Harcstílus:", optionDataName = "fightingStyle", defaultValue = 1 },
    { optionTitle = "Célkereszt:", optionDataName = "crosshair", defaultValue = 0 },
    { optionTitle = "Látótávolság:", optionDataName = "viewdistance", defaultValue = 500, minimumValue = 0, maximumValue = 5000, isSlider = true },
    { optionTitle = "Élsimitíás:", optionDataName = "dl_ssao", defaultValue = false, isSwitchable = true },
}

local dashboardColorSwitch = {}
local dashboardActiveButton = false

local playerVehicles = {}
local vehicleScrollOffset = 0
local vehicleListSelected = false

local playerInteriors = {}
local interiorScrollOffset = 0
local interiorListSelected = false

local premiumCategorySelected = "premiumItems"
local premiumCategoryScroll = 0
local premiumItemBuy = false

local premiumItemBuyGui = false
local premiumItemBuyButton = false
local premiumItemCancelBuyButton = false

local adminScrollOffset = 0
local adminListDatas = {}

local groupScrollOffset = 0
local groupMemberScrollOffset = 0

local groupListSelected = 1
local playerGroups = {}
local playerGroupDatas = {}

local groupMemberSelected = false
local groupMenuSelected = "groupInformation"

local groupDescriptionInput = false
local groupMemberInviteInput = false

local groupRankNameInput = false
local groupRankSalaryInput = false

local groupMemberKickPrompt = false
local groupMemberInvitePrompt = false

local groupVehicleScrollOffset = 0
local groupVehicleSelected = false

local groupRankScrollOffset = 0
local groupRankSelected = false

local groupActionButtons = {
    {
        buttonName = "groupInvite",
        buttonTitle = "Új tag felvétele",
        buttonColor = {50, 186, 157}
    },

    {
        buttonName = "groupKick",
        buttonTitle = "Kirúgás",
        buttonColor = {243, 90, 90}
    },

    {
        buttonName = "groupLeaderGive",
        buttonTitle = "Leader adás",
        buttonColor = {50, 186, 157}
    },

    {
        buttonName = "groupLeaderTake",
        buttonTitle = "Leader elvétel",
        buttonColor = {243, 90, 90}
    },

    {
        buttonName = "groupPromote",
        buttonTitle = "Rang Emelés",
        buttonColor = {50, 186, 157}
    },

    {
        buttonName = "groupDemote",
        buttonTitle = "Rang csökkentés",
        buttonColor = {243, 90, 90}
    }
}

local groupRankButtons = {
    {
        buttonName = "groupRankRename",
        buttonTitle = "Rang átnevezése",
        buttonColor = {50, 186, 157}
    },

    {
        buttonName = "grupRankPayChange",
        buttonTitle = "Fizetés beállítása",
        buttonColor = {50, 186, 157}
    }
}

local groupMenus = {
    {
        menuName = "groupInformation",
        menuTitle = "Áttekintés",
    },

    {
        menuName = "groupMembers",
        menuTitle = "Tagok",
    },

    {
        menuName = "groupVehicles",
        menuTitle = "Járművek",
    },

    {
        menuName = "groupRanks",
        menuTitle = "Rangok",
    },
}

local vehicleBuySlotPrompt = false
local interiorBuySlotPrompt = false

function renderDashboard()
    dashboardButtons = {}
    
	local cursorX, cursorY = getCursorPosition()

	if tonumber(cursorX) then
		cursorX = cursorX * screenX
		cursorY = cursorY * screenY
	end

    if dashboardFadeIn then
        local now = getTickCount()
        local progress = (now - dashboardFadeIn)

        dashboardAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, progress / dashboardFadeSpeed, "Linear")

        if progress >= dashboardFadeSpeed then
            dashboardFadeIn = false
        end
    end

    if dashboardFadeOut then
        local now = getTickCount()
        local progress = (now - dashboardFadeOut)

        dashboardAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, progress / dashboardFadeSpeed, "Linear")

        if progress >= dashboardFadeSpeed then
            dashboardFadeOut = false
            setDashboardState(false)
        end
    end

    if premiumItemBuy then
        if not premiumItemBuyGui then
            local premiumPromptSizeW = 450
            local premiumPromptSizeH = 203
            
            local premiumPromptPosX = screenX / 2 - (premiumPromptSizeW / 2)
            local premiumPromptPosY = screenY / 2 - (premiumPromptSizeH / 2)

            premiumItemBuyGui = exports.seal_gui:createGuiElement("window", premiumPromptPosX, premiumPromptPosY, premiumPromptSizeW, premiumPromptSizeH)
            exports.seal_gui:setWindowTitle(premiumItemBuyGui, "15/BebasNeueRegular.otf", "SealMTA - PrémiumShop")
            exports.seal_gui:setWindowCloseButton(premiumItemBuyGui, "closePremiumBuyGui")

            local label = exports.seal_gui:createGuiElement("label", 0, 42, premiumPromptSizeW, premiumPromptSizeH, premiumItemBuyGui)
            exports.seal_gui:setLabelText(label, "Biztosan megszeretnéd vásárolni a kiválasztott itemet?")
            exports.seal_gui:setLabelFont(label, "16/BebasNeueRegular.otf")
            exports.seal_gui:setLabelAlignment(label, "center", "top")

            local itemData = premiumShopCategoryItems[premiumCategorySelected][premiumItemBuy]

            if itemData then
                premiumItemPrice = exports.seal_gui:createGuiElement("label", 0, 72, premiumPromptSizeW, premiumPromptSizeH, premiumItemBuyGui)
                exports.seal_gui:setLabelText(premiumItemPrice, exports.seal_items:getItemName(itemData.itemId) .. " " .. dashboardBlueColor .. itemData.itemPrice .. " PP")
                exports.seal_gui:setLabelFont(premiumItemPrice, "16/BebasNeueRegular.otf")
                exports.seal_gui:setLabelAlignment(premiumItemPrice, "center", "top")
            end

            premiumItemAmountInput = exports.seal_gui:createGuiElement("input", 10, 112, premiumPromptSizeW - 20, 35, premiumItemBuyGui)
            exports.seal_gui:setInputPlaceholder(premiumItemAmountInput, "Mennyiség")
            exports.seal_gui:setInputIcon(premiumItemAmountInput, "cubes")
            exports.seal_gui:setInputMaxLength(premiumItemAmountInput, 3)
            exports.seal_gui:setInputNumberOnly(premiumItemAmountInput, true)
            exports.seal_gui:setInputChangeEvent(premiumItemAmountInput, "refreshItemPriceLabel")

            premiumItemBuyButton = exports.seal_gui:createGuiElement("button", 10, premiumPromptSizeH - 45, premiumPromptSizeW / 2 - 15, 35, premiumItemBuyGui)
            exports.seal_gui:setGuiBackground(premiumItemBuyButton, "solid", "primary")
            exports.seal_gui:setGuiHover(premiumItemBuyButton, "gradient", {"primary", "secondary"}, false, true)
            exports.seal_gui:setButtonFont(premiumItemBuyButton, "17/BebasNeueBold.otf")
            exports.seal_gui:setClickEvent(premiumItemBuyButton, "tryToClickPremiumButton")
            exports.seal_gui:setButtonText(premiumItemBuyButton, "Megvásárlás")
            
            premiumItemCancelBuyButton = exports.seal_gui:createGuiElement("button", premiumPromptSizeW / 2 + 5, premiumPromptSizeH - 45, premiumPromptSizeW / 2 - 15, 35, premiumItemBuyGui)
            exports.seal_gui:setGuiBackground(premiumItemCancelBuyButton, "solid", "red")
            exports.seal_gui:setGuiHover(premiumItemCancelBuyButton, "gradient", {"red", "red-second"}, false, true)
            exports.seal_gui:setButtonFont(premiumItemCancelBuyButton, "17/BebasNeueBold.otf")
            exports.seal_gui:setClickEvent(premiumItemCancelBuyButton, "tryToClickPremiumButton")
            exports.seal_gui:setButtonText(premiumItemCancelBuyButton, "Mégsem")
        end
    elseif vehicleBuySlotPrompt or interiorBuySlotPrompt then
        if not slotBuyGui then
            local slotPromptSizeW = 450
            local slotPromptSizeH = 203
        
            local slotPromptPosX = screenX / 2 - (slotPromptSizeW / 2)
            local slotPromptPosY = screenY / 2 - (slotPromptSizeH / 2)
        
            slotBuyGui = exports.seal_gui:createGuiElement("window", slotPromptPosX, slotPromptPosY, slotPromptSizeW, slotPromptSizeH)
            exports.seal_gui:setWindowTitle(slotBuyGui, "15/BebasNeueRegular.otf", "SealMTA - Slot Vásárlás")
            exports.seal_gui:setWindowCloseButton(slotBuyGui, "closeslotBuyGui")
        
            local label = exports.seal_gui:createGuiElement("label", 0, 42, slotPromptSizeW, slotPromptSizeH, slotBuyGui)
            exports.seal_gui:setLabelText(label, "Biztosan megszeretnéd vásárolni a slotot?")
            exports.seal_gui:setLabelFont(label, "16/BebasNeueRegular.otf")
            exports.seal_gui:setLabelAlignment(label, "center", "top")
        
            slotItemPrice = exports.seal_gui:createGuiElement("label", 0, 72, slotPromptSizeW, slotPromptSizeH, slotBuyGui)
            exports.seal_gui:setLabelText(slotItemPrice, "1 SLOT " .. dashboardBlueColor .. "100 PP")
            exports.seal_gui:setLabelFont(slotItemPrice, "16/BebasNeueRegular.otf")
            exports.seal_gui:setLabelAlignment(slotItemPrice, "center", "top")
        
            slotItemAmountInput = exports.seal_gui:createGuiElement("input", 10, 112, slotPromptSizeW - 20, 35, slotBuyGui)
            exports.seal_gui:setInputPlaceholder(slotItemAmountInput, "Mennyiség")
            exports.seal_gui:setInputIcon(slotItemAmountInput, "cubes")
            exports.seal_gui:setInputMaxLength(slotItemAmountInput, 3)
            exports.seal_gui:setInputNumberOnly(slotItemAmountInput, true)
            exports.seal_gui:setInputChangeEvent(slotItemAmountInput, "refreshSlotPriceLabel")
        
            slotItemBuyButton = exports.seal_gui:createGuiElement("button", 10, slotPromptSizeH - 45, slotPromptSizeW / 2 - 15, 35, slotBuyGui)
            exports.seal_gui:setGuiBackground(slotItemBuyButton, "solid", "primary")
            exports.seal_gui:setGuiHover(slotItemBuyButton, "gradient", {"primary", "secondary"}, false, true)
            exports.seal_gui:setButtonFont(slotItemBuyButton, "17/BebasNeueBold.otf")
            exports.seal_gui:setClickEvent(slotItemBuyButton, "tryToClickSlotButton")
            exports.seal_gui:setButtonText(slotItemBuyButton, "Megvásárlás")
        
            slotItemCancelBuyButton = exports.seal_gui:createGuiElement("button", slotPromptSizeW / 2 + 5, slotPromptSizeH - 45, slotPromptSizeW / 2 - 15, 35, slotBuyGui)
            exports.seal_gui:setGuiBackground(slotItemCancelBuyButton, "solid", "red")
            exports.seal_gui:setGuiHover(slotItemCancelBuyButton, "gradient", {"red", "red-second"}, false, true)
            exports.seal_gui:setButtonFont(slotItemCancelBuyButton, "17/BebasNeueBold.otf")
            exports.seal_gui:setClickEvent(slotItemCancelBuyButton, "tryToClickSlotButton")
            exports.seal_gui:setButtonText(slotItemCancelBuyButton, "Mégsem")
        end
    else
        dxDrawRectangle(dashboardPosX, dashboardPosY, dashboardWidth, dashboardHeight, tocolor(26, 27, 31, dashboardAlpha * 255))

        local dashboardSelectorWidth = 250
        local dashboardSelectorHeight = dashboardHeight

        local dashboardSelectorPosX = dashboardPosX
        local dashboardSelectorPosY = dashboardPosY

        dxDrawRectangle(dashboardSelectorPosX, dashboardSelectorPosY, dashboardSelectorWidth, dashboardSelectorHeight, tocolor(35, 39, 42, dashboardAlpha * 255))

        local dashboardLogoWidth = 128
        local dashboardLogoHeight = 128

        local dashboardLogoPosX = dashboardPosX + (dashboardSelectorWidth - dashboardLogoWidth) / 2
        local dashboardLogoPosY = dashboardPosY

        dxDrawImage(dashboardLogoPosX + 1, dashboardLogoPosY + 1, dashboardLogoWidth, dashboardLogoHeight, "files/images/logo.png", 0, 0, 0, tocolor(0, 0, 0, dashboardAlpha * 255))
        dxDrawImage(dashboardLogoPosX, dashboardLogoPosY, dashboardLogoWidth, dashboardLogoHeight, "files/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))

        local dashboardTitleTextWidth = dashboardSelectorWidth
        local dashboardTitleTextHeight = dashboardLogoHeight

        local dashboardTitleTextPosX = dashboardPosX
        local dashboardTitleTextPosY = dashboardPosY + 40

        dxDrawText("SealMTA - Dashboard", dashboardTitleTextPosX + 1, dashboardTitleTextPosY + 1, dashboardTitleTextPosX + 1 + dashboardTitleTextWidth, dashboardTitleTextPosY + 1 + dashboardTitleTextHeight, tocolor(0, 0, 0, dashboardAlpha * 255), 1, bebasNeueRegular11, "center", "bottom", false, false, false, true)
        dxDrawText(dashboardPrimaryColor .. "SealMTA #ffffff- Dashboard", dashboardTitleTextPosX, dashboardTitleTextPosY, dashboardTitleTextPosX + dashboardTitleTextWidth, dashboardTitleTextPosY + dashboardTitleTextHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular11, "center", "bottom", false, false, false, true)

        for i = 1, #dashboardMenus do
            local dashboardMenu = dashboardMenus[i]

            if dashboardMenu then
                local dashboardMenuKey = "selectMenu:" .. dashboardMenu.menuName

                local dashboardMenuWidth = dashboardSelectorWidth
                local dashboardMenuHeight = 40

                local dashboardMenuIconWidth = dashboardMenuHeight - 10
                local dashboardMenuIconHeight = dashboardMenuHeight - 10

                local dashboardMenuPosX = dashboardSelectorPosX
                local dashboardMenuPosY = dashboardSelectorPosY + 55 + dashboardTitleTextHeight + (i - 1) * (dashboardMenuHeight + 5)

                if dashboardActiveButton == dashboardMenuKey or dashboardSelectedMenu == dashboardMenu.menuName then
                    dashboardMenuColorR, dashboardMenuColorG, dashboardMenuColorB, dashboardMenuColorA = processColorSwitchEffect(dashboardMenuKey, 50, 186, 157, 255 * dashboardAlpha)
                    dashboardMenuImageColorR, dashboardMenuImageColorG, dashboardMenuImageColorB, dashboardMenuImageColorA = processColorSwitchEffect(dashboardMenuKey .. ":select", 50, 186, 157, 180 * dashboardAlpha)
                else
                    dashboardMenuColorR, dashboardMenuColorG, dashboardMenuColorB, dashboardMenuColorA = processColorSwitchEffect(dashboardMenuKey, 255, 255, 255, 255 * dashboardAlpha)
                    dashboardMenuImageColorR, dashboardMenuImageColorG, dashboardMenuImageColorB, dashboardMenuImageColorA = processColorSwitchEffect(dashboardMenuKey .. ":select", 51, 53, 61, 180 * dashboardAlpha)
                end

                dxDrawImage(dashboardMenuPosX + 5, dashboardMenuPosY, dashboardMenuWidth - 10, dashboardMenuHeight, "files/images/selector.png", 0, 0, 0, tocolor(dashboardMenuImageColorR, dashboardMenuImageColorG, dashboardMenuImageColorB, dashboardMenuImageColorA))
                dxDrawImage(dashboardMenuPosX + 10, dashboardMenuPosY + 5, dashboardMenuIconWidth, dashboardMenuIconHeight, dashboardMenu.menuIcon, 0, 0, 0, tocolor(dashboardMenuColorR, dashboardMenuColorG, dashboardMenuColorB, dashboardMenuColorA))
                dxDrawText(dashboardMenu.menuTitle, dashboardMenuPosX + dashboardMenuIconWidth + 15, dashboardMenuPosY, dashboardMenuPosX + dashboardMenuIconWidth + 15 + dashboardMenuWidth, dashboardMenuPosY + dashboardMenuHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                
                dashboardButtons[dashboardMenuKey] = {dashboardMenuPosX, dashboardMenuPosY, dashboardMenuWidth, dashboardMenuHeight}
            end
        end

        if dashboardSelectedMenu == "information" then
            for i = 1, #dashboardInformations do
                local dashboardInformation = dashboardInformations[i]

                if dashboardInformation then
                    local informationPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
                    local informationPosY = dashboardSelectorPosY + 10 + (i - 1) * 33

                    if dashboardInformation.breakLine then
                        informationPosY = informationPosY + 30
                    else
                        local informationData = dashboardDatas[dashboardInformation.infoDataName] or "N/A"

                        if dashboardInformation.formatNumber then
                            informationData = formatNumber(informationData)
                        end

                        dxDrawText(dashboardInformation.infoTitle .. dashboardPrimaryColor .. informationData .. (dashboardInformation.infoSuffix or ""), informationPosX, informationPosY, informationPosX + 200, informationPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    end
                end
            end
            
            local informationBarWidth = 300
            local informationBarHeight = 14

            local informationBarPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
            local informationBarPosY = dashboardSelectorPosY + dashboardSelectorHeight - informationBarHeight - 10

            local playerHealth = getElementHealth(localPlayer)
            local playerArmor = getPedArmor(localPlayer)

            if dashboardDatas["char.Hunger"] then
                dxDrawRectangle(informationBarPosX + informationBarHeight + 4, informationBarPosY, informationBarWidth / 2 - 2, informationBarHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
                dxDrawRectangle(informationBarPosX + informationBarHeight + 6, informationBarPosY + 2, (informationBarWidth / 2 - 6) * (dashboardDatas["char.Hunger"] / 100), informationBarHeight - 4, tocolor(243, 214, 90, dashboardAlpha * 255))
                dxDrawImage(informationBarPosX, informationBarPosY, informationBarHeight, informationBarHeight, "files/images/untensils.png", 0, 0, 0, tocolor(243, 214, 90, dashboardAlpha * 255))
            end

            if dashboardDatas["char.Thirst"] then
                dxDrawRectangle(informationBarPosX + informationBarHeight + informationBarWidth / 2 + 6, informationBarPosY, informationBarWidth / 2 - 2, informationBarHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
                dxDrawRectangle(informationBarPosX + informationBarHeight + informationBarWidth / 2 + 8, informationBarPosY + 2, (informationBarWidth / 2 - 6) * (dashboardDatas["char.Thirst"] / 100), informationBarHeight - 4, tocolor(49, 180, 225, dashboardAlpha * 255))
            end

            informationBarPosY = informationBarPosY - informationBarHeight - 4
            dxDrawImage(informationBarPosX, informationBarPosY, informationBarHeight, informationBarHeight, "files/images/shield.png", 0, 0, 0, tocolor(49, 154, 215, dashboardAlpha * 255))
            dxDrawRectangle(informationBarPosX + informationBarHeight + 4, informationBarPosY, informationBarWidth, informationBarHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
            dxDrawRectangle(informationBarPosX + informationBarHeight + 6, informationBarPosY + 2, (informationBarWidth - 4) * (playerArmor / 100), informationBarHeight - 4, tocolor(49, 154, 215, dashboardAlpha * 255))

            informationBarPosY = informationBarPosY - informationBarHeight - 4
            dxDrawImage(informationBarPosX, informationBarPosY, informationBarHeight, informationBarHeight, "files/images/heart.png", 0, 0, 0, tocolor(243, 90, 90, dashboardAlpha * 255))
            dxDrawRectangle(informationBarPosX + informationBarHeight + 4, informationBarPosY, informationBarWidth, informationBarHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
            dxDrawRectangle(informationBarPosX + informationBarHeight + 6, informationBarPosY + 2, (informationBarWidth - 4) * (playerHealth / 100), informationBarHeight - 4, tocolor(243, 90, 90, dashboardAlpha * 255))
        elseif dashboardSelectedMenu == "vehicles" then
            local vehicleListWidth = dashboardSelectorWidth + 75
            local vehicleListHeight = dashboardHeight - 20

            local vehicleListPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
            local vehicleListPosY = dashboardSelectorPosY + 10

            for i = 1, 15 do
                local vehicleListIndex = i + vehicleScrollOffset
                local vehicleListKey = "selectVehicle:" .. vehicleListIndex
                local vehicleData = playerVehicles[vehicleListIndex]

                local vehicleOneWidth = vehicleListWidth
                local vehicleOneHeight = vehicleListHeight / 15

                local vehicleOnePosX = vehicleListPosX
                local vehicleOnePosY = vehicleListPosY + (i - 1) * vehicleOneHeight

                if dashboardActiveButton == vehicleListKey or vehicleListSelected == vehicleListIndex then
                    vehicleListColorR, vehicleListColorG, vehicleListColorB, vehicleListColorA = processColorSwitchEffect(vehicleListKey, 50, 186, 157, 255 * dashboardAlpha)
                else
                    vehicleListColorR, vehicleListColorG, vehicleListColorB, vehicleListColorA = processColorSwitchEffect(vehicleListKey, 35, 39, 42, 255 * dashboardAlpha)
                end

                dxDrawImage(vehicleOnePosX, vehicleOnePosY, vehicleOneWidth, vehicleOneHeight, "files/images/selector.png", 0, 0, 0, tocolor(vehicleListColorR, vehicleListColorG, vehicleListColorB, vehicleListColorA))
                dxDrawRectangle(vehicleOnePosX, vehicleOnePosY, vehicleOneWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))

                if vehicleData then
                    if vehicleData.brand then
                        dxDrawText(vehicleData.name .. dashboardPrimaryColor .. " (" .. vehicleData.dbID .. ")", vehicleOnePosX + vehicleOneHeight, vehicleOnePosY, vehicleOnePosX + vehicleOneHeight + vehicleOneWidth, vehicleOnePosY + vehicleOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        dxDrawImage(vehicleOnePosX + 5, vehicleOnePosY + 5, vehicleOneHeight - 10, vehicleOneHeight - 10, vehicleData.brand, 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                    else
                        dxDrawText(vehicleData.name .. dashboardPrimaryColor .. " (" .. vehicleData.dbID .. ")", vehicleOnePosX + 10, vehicleOnePosY, vehicleOnePosX + 10 + vehicleOneWidth, vehicleOnePosY + vehicleOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    end
                
                    dashboardButtons[vehicleListKey] = {vehicleOnePosX, vehicleOnePosY, vehicleOneWidth, vehicleOneHeight}
                end
            end

            if vehicleListSelected then
                local vehicleDataWidth = dashboardWidth - (vehicleListWidth * 2) + 45
                local vehicleDataHeight = dashboardHeight - 20

                local vehicleDataPosX = vehicleListPosX + vehicleListWidth + 10
                local vehicleDataPosY = vehicleListPosY

                dxDrawImage(vehicleDataPosX, vehicleDataPosY, vehicleDataWidth, vehicleDataHeight, "files/images/selector.png", 180, 0, 0, tocolor(35, 39, 42, dashboardAlpha * 255))
    
                local vehicleData = playerVehicles[vehicleListSelected]
                if vehicleData then
                    dxDrawText(vehicleData.name .. dashboardPrimaryColor .. " (" .. vehicleData.dbID .. ")", vehicleDataPosX + 10, vehicleDataPosY + 10, vehicleDataPosX + vehicleDataWidth, vehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                    if vehicleData.brand then
                        dxDrawImage(vehicleDataPosX + vehicleDataWidth - 74, vehicleDataPosY + vehicleDataHeight - 74, 64, 64, vehicleData.brand, 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                    end

                    for i = 1, #dashboardVehicleInformations do
                        local dashboardVehicleInformation = dashboardVehicleInformations[i]

                        local vehicleOneWidth = vehicleDataWidth
                        local vehicleOneHeight = 28

                        local vehicleOnePosX = vehicleDataPosX

                        if dashboardVehicleInformation.rightSide then
                            vehicleOnePosX = vehicleOnePosX + 300
                            i = i - 22
                        end
                        
                        local vehicleOnePosY = vehicleDataPosY + 35 + (i - 1) * vehicleOneHeight

                        if vehicleData.eletricVehicle then
                            if dashboardVehicleInformation.infoDataName == "fuel" then
                                dashboardVehicleInformation.infoTitle = "Akkumulátor: "
                            elseif dashboardVehicleInformation.infoDataName == "tuningEngine" then
                                dashboardVehicleInformation.infoTitle = "Villanymotor: "
                            elseif dashboardVehicleInformation.infoDataName == "tuningTurbo" then
                                dashboardVehicleInformation.infoTitle = "Akkumulátor: "
                            elseif dashboardVehicleInformation.infoDataName == "tuningTransmission" then
                                dashboardVehicleInformation.infoTitle = "Inverter: "
                            end
                        end

                        if dashboardVehicleInformation.infoDataName == "fuel" and vehicleData.eletricVehicle then
                            dashboardVehicleInformation.infoTitle = "Akkumulátor: "
                        end

                        local informationData = vehicleData[dashboardVehicleInformation.infoDataName] or "N/A"
                        local informationColor = dashboardPrimaryColor

                        if dashboardVehicleInformation.breakLine then
                            vehicleOnePosY = vehicleOnePosY + 30
                        else
                            dxDrawText(dashboardVehicleInformation.infoTitle .. informationColor .. informationData, vehicleOnePosX + 10, vehicleOnePosY, vehicleOnePosX + vehicleOneWidth, vehicleOnePosY + vehicleOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        end
                    end
                end
            end

            if not vehicleBuySlotPrompt then
                if dashboardActiveButton == "buyVehicleSlot" then
                    slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA = processColorSwitchEffect("buyVehicleSlot", 50, 186, 157, 255 * dashboardAlpha)
                else
                    slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA = processColorSwitchEffect("buyVehicleSlot", 50, 186, 157, 150 * dashboardAlpha)
                end
                
                dxDrawRectangle(dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, 100, 30, tocolor(slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA, dashboardAlpha * 255))
                dxDrawText("+SLOT", dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, dashboardPosX + dashboardWidth - 20, dashboardPosY + 50, tocolor(255, 255, 255, dashboardAlpha * 255), 0.85, bebasNeueRegular9, "center", "center", false, false, false, true)
                dxDrawText(#playerVehicles .. "/" .. dashboardDatas["char.maxVehicles"], dashboardPosX + dashboardWidth - 120, dashboardPosY + 50, dashboardPosX + dashboardWidth - 120 + 100, dashboardPosY + 50 + 35, tocolor(255, 255, 255, dashboardAlpha * 255), 0.9, bebasNeueRegular9, "center", "center", false, false, false, true)
                dashboardButtons["buyVehicleSlot"] = {dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, 100, 35}
            end
        elseif dashboardSelectedMenu == "interiors" then
            local interiorListWidth = dashboardSelectorWidth + 75
            local interiorListHeight = dashboardHeight - 20

            local interiorListPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
            local interiorListPosY = dashboardSelectorPosY + 10

            for i = 1, 15 do
                local interiorListIndex = i + interiorScrollOffset
                local interiorListKey = "selectInterior:" .. interiorListIndex
                local interiorData = playerInteriors[interiorListIndex]

                local interiorOneWidth = interiorListWidth
                local interiorOneHeight = interiorListHeight / 15

                local interiorOnePosX = interiorListPosX
                local interiorOnePosY = interiorListPosY + (i - 1) * interiorOneHeight

                if dashboardActiveButton == interiorListKey or interiorListSelected == interiorListIndex then
                    interiorListColorR, interiorListColorG, interiorListColorB, interiorListColorA = processColorSwitchEffect(interiorListKey, 50, 186, 157, 255 * dashboardAlpha)
                else
                    interiorListColorR, interiorListColorG, interiorListColorB, interiorListColorA = processColorSwitchEffect(interiorListKey, 35, 39, 42, 255 * dashboardAlpha)
                end

                dxDrawImage(interiorOnePosX, interiorOnePosY, interiorOneWidth, interiorOneHeight, "files/images/selector.png", 0, 0, 0, tocolor(interiorListColorR, interiorListColorG, interiorListColorB, interiorListColorA))
                dxDrawRectangle(interiorOnePosX, interiorOnePosY, interiorOneWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))

                if interiorData then
                    dxDrawImage(interiorOnePosX + 5, interiorOnePosY + 5, interiorOneHeight - 10, interiorOneHeight - 10, interiorData.icon, 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                    dxDrawText(interiorData.data.name .. dashboardPrimaryColor .. " (" .. interiorData.interiorId .. ")", interiorOnePosX + interiorOneHeight, interiorOnePosY, interiorOnePosX + interiorOneHeight + interiorOneWidth, interiorOnePosY + interiorOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                    dashboardButtons[interiorListKey] = {interiorOnePosX, interiorOnePosY, interiorOneWidth, interiorOneHeight}
                end
            end

            if interiorListSelected then
                local interiorDataWidth = dashboardWidth - (interiorListWidth * 2) + 45
                local interiorDataHeight = dashboardHeight - 20

                local interiorDataPosX = interiorListPosX + interiorListWidth + 10
                local interiorDataPosY = interiorListPosY

                dxDrawImage(interiorDataPosX, interiorDataPosY, interiorDataWidth, interiorDataHeight, "files/images/selector.png", 180, 0, 0, tocolor(35, 39, 42, dashboardAlpha * 255))

                local interiorData = playerInteriors[interiorListSelected]

                if interiorData then
                    if interiorData.data.editable == "N" then
                        dxDrawImage(interiorDataPosX + interiorDataWidth - 394, interiorDataPosY + interiorDataHeight - 202, 384, 192, ":seal_interiors/files/pics/" .. interiorData.data.gameInterior .. ".jpg", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                    end

                    dxDrawText(interiorData.data.name .. dashboardPrimaryColor .. " (" .. interiorData.interiorId .. ")", interiorDataPosX + 10, interiorDataPosY + 10, interiorDataPosX + interiorDataWidth, interiorDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                
                    for i = 1, #dashboardInteriorInformations do
                        local dashboardInteriorInformation = dashboardInteriorInformations[i]

                        local interiorOneWidth = interiorDataWidth
                        local interiorOneHeight = 28

                        local interiorOnePosX = interiorDataPosX
                        local interiorOnePosY = interiorDataPosY + 35 + (i - 1) * interiorOneHeight

                        local informationData = interiorData[dashboardInteriorInformation.infoDataName] or "N/A"
                        local informationColor = dashboardPrimaryColor

                        if dashboardInteriorInformation.breakLine then
                            interiorOnePosY = interiorOnePosY + 30
                        else
                            dxDrawText(dashboardInteriorInformation.infoTitle .. informationColor .. informationData, interiorOnePosX + 10, interiorOnePosY, interiorOnePosX + interiorOneWidth, interiorOnePosY + interiorOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        end
                    end
                end
            end

            if not interiorBuySlotPrompt then
                if dashboardActiveButton == "buyInteriorSlot" then
                    slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA = processColorSwitchEffect("buyInteriorSlot", 50, 186, 157, 255 * dashboardAlpha)
                else
                    slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA = processColorSwitchEffect("buyInteriorSlot", 50, 186, 157, 150 * dashboardAlpha)
                end
                
                dxDrawRectangle(dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, 100, 30, tocolor(slotButtonColorR, slotButtonColorG, slotButtonColorB, slotButtonColorA, dashboardAlpha * 255))
                dxDrawText("+SLOT", dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, dashboardPosX + dashboardWidth - 20, dashboardPosY + 50, tocolor(255, 255, 255, dashboardAlpha * 255), 0.85, bebasNeueRegular9, "center", "center", false, false, false, true)
                dxDrawText(#playerInteriors .. "/" .. dashboardDatas["char.interiorLimit"], dashboardPosX + dashboardWidth - 120, dashboardPosY + 50, dashboardPosX + dashboardWidth - 120 + 100, dashboardPosY + 50 + 35, tocolor(255, 255, 255, dashboardAlpha * 255), 0.9, bebasNeueRegular9, "center", "center", false, false, false, true)
                dashboardButtons["buyInteriorSlot"] = {dashboardPosX + dashboardWidth - 120, dashboardPosY + 20, 100, 35}
            end
        elseif dashboardSelectedMenu == "factions" then
            for i = 1, 15 do
                local groupListIndex = i + groupScrollOffset
                local groupListKey = "selectGroup:" .. groupListIndex
                local groupData = playerGroupDatas[groupListIndex]

                local groupListWidth = dashboardSelectorWidth + 75
                local groupListHeight = (dashboardHeight - 20) / 15

                local groupListPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
                local groupListPosY = dashboardSelectorPosY + 10 + (i - 1) * groupListHeight
            
                if dashboardActiveButton == groupListKey or groupListSelected == groupListIndex then
                    groupListColorR, groupListColorG, groupListColorB, groupListColorA = processColorSwitchEffect(groupListKey, 50, 186, 157, 255 * dashboardAlpha)
                else
                    groupListColorR, groupListColorG, groupListColorB, groupListColorA = processColorSwitchEffect(groupListKey, 35, 39, 42, 255 * dashboardAlpha)
                end

                dxDrawImage(groupListPosX, groupListPosY, groupListWidth, groupListHeight, "files/images/selector.png", 0, 0, 0, tocolor(groupListColorR, groupListColorG, groupListColorB, groupListColorA))
                dxDrawRectangle(groupListPosX, groupListPosY, groupListWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))
                dashboardButtons[groupListKey] = {groupListPosX, groupListPosY, groupListWidth, groupListHeight}

                if groupData then
                    dxDrawText(groupData.name .. dashboardPrimaryColor .. " (" .. groupData.id .. ")", groupListPosX + 10, groupListPosY, groupListPosX + groupListWidth, groupListPosY + groupListHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                end
            end

            if groupListSelected then
                local groupMenuPosX = dashboardSelectorPosX + dashboardSelectorWidth
                local groupMenuPosY = dashboardSelectorPosY + 10

                for i = 1, #groupMenus do
                    local groupMenuIndex = "selectGroupMenu:" .. groupMenus[i].menuName
                    local groupMenuName = groupMenus[i].menuTitle

                    local groupMenuNameWidth = dxGetTextWidth(groupMenuName, 1, bebasNeueRegular9) + 20
                    local groupMenuWidth = 361
                    local groupMenuHeight = 40

                    if dashboardActiveButton == groupMenuIndex or groupMenuSelected == groupMenus[i].menuName then
                        groupMenuColorR, groupMenuColorG, groupMenuColorB, groupMenuColorA = processColorSwitchEffect(groupMenuIndex, 50, 186, 157, 255 * dashboardAlpha)
                    else
                        groupMenuColorR, groupMenuColorG, groupMenuColorB, groupMenuColorA = processColorSwitchEffect(groupMenuIndex, 35, 39, 42, 255 * dashboardAlpha)
                    end

                    dxDrawRectangle(groupMenuPosX + dashboardSelectorWidth + 212, groupMenuPosY, groupMenuNameWidth, groupMenuHeight, tocolor(groupMenuColorR, groupMenuColorG, groupMenuColorB, groupMenuColorA))
                    dxDrawText(groupMenuName, groupMenuPosX + dashboardSelectorWidth + 212, groupMenuPosY, groupMenuPosX + dashboardSelectorWidth + 212 + groupMenuNameWidth, groupMenuPosY + groupMenuHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "center", "center", false, false, false, true)
                    dashboardButtons[groupMenuIndex] = {groupMenuPosX + dashboardSelectorWidth + 212, groupMenuPosY, groupMenuNameWidth, groupMenuHeight}

                    groupMenuPosX = groupMenuPosX + (groupMenuNameWidth + 5)
                end

                local groupData = playerGroupDatas[groupListSelected]

                if groupData then
                    local groupDataWidth = dashboardWidth - (dashboardSelectorWidth * 2) - 110
                    local groupDataHeight = dashboardHeight - 70
                    
                    local groupDataPosX = dashboardSelectorPosX + (dashboardSelectorWidth * 2) + 100
                    local groupDataPosY = groupMenuPosY + 50

                    if groupMenuSelected == "groupInformation" then
                        dxDrawText(groupData.name .. dashboardPrimaryColor .. " (" .. groupData.id .. ")", groupDataPosX + 10, groupDataPosY + 10, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                        
                        groupDataPosY = groupDataPosY + 40
                        dxDrawText("Tagok: " .. dashboardPrimaryColor .. #groupData.members .. " #ffffffdb", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        groupDataPosY = groupDataPosY + 30
                        dxDrawText("Elérhető tagok: " .. dashboardPrimaryColor .. groupData.onlineMembers .. " #fffffffő", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        groupDataPosY = groupDataPosY + 30
                        dxDrawText("Szolgálatban: " .. dashboardPrimaryColor .. groupData.inDutyMembers .. " #fffffffő", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        groupDataPosY = groupDataPosY + 30
                        dxDrawText("Rangok: " .. dashboardPrimaryColor .. #groupData.ranks .. " #ffffffdb", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        groupDataPosY = groupDataPosY + 30
                        dxDrawText("Járművek: " .. dashboardPrimaryColor .. #groupData.vehicles .. " #ffffffdb", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        groupDataPosY = groupDataPosY + 30
                        dxDrawText("Banki egyenleg: " .. dashboardPrimaryColor .. groupData.balance .. " #ffffff$", groupDataPosX + 10, groupDataPosY, groupDataPosX + groupDataWidth, groupDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        if not groupDescriptionInput and not dashboardFadeOut then
                            if groupData.leader then
                                groupDescriptionInput = exports.seal_gui:createGuiElement("input", groupDataPosX + 10, groupDataPosY + 60, groupDataWidth - 20, groupDataHeight / 2)
                            else
                                groupDescriptionInput = exports.seal_gui:createGuiElement("input", groupDataPosX + 10, groupDataPosY + 105, groupDataWidth - 20, groupDataHeight / 2)
                                exports.seal_gui:setInputDisabled(groupDescriptionInput, true)
                            end

                            exports.seal_gui:setInputMultiline(groupDescriptionInput, true)
                            exports.seal_gui:setInputMaxLength(groupDescriptionInput, 500)
                            exports.seal_gui:setInputPlaceholder(groupDescriptionInput, "Leírás")
                            exports.seal_gui:setInputValue(groupDescriptionInput, groupData.description)
                        end
                        
                        if groupData.leader then
                            local descriptionButtonIndex = "editGroupDescription"

                            if dashboardActiveButton == descriptionButtonIndex then
                                descriptionButtonColorR, descriptionButtonColorG, descriptionButtonColorB, descriptionButtonColorA = processColorSwitchEffect(descriptionButtonIndex, 50, 186, 157, 255 * dashboardAlpha)
                            else
                                descriptionButtonColorR, descriptionButtonColorG, descriptionButtonColorB, descriptionButtonColorA = processColorSwitchEffect(descriptionButtonIndex, 51, 53, 61, 255 * dashboardAlpha)
                            end

                            dxDrawRectangle(groupDataPosX + 10, groupDataPosY + 70 + groupDataHeight / 2, groupDataWidth - 20, 35, tocolor(descriptionButtonColorR, descriptionButtonColorG, descriptionButtonColorB, descriptionButtonColorA * dashboardAlpha))
                            dxDrawText("Leírás szerkesztése", groupDataPosX + 10, groupDataPosY + 70 + groupDataHeight / 2, groupDataPosX + 10 + groupDataWidth - 20, groupDataPosY + 70 + groupDataHeight / 2 + 35, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                            dashboardButtons[descriptionButtonIndex] = {groupDataPosX + 10, groupDataPosY + 70 + groupDataHeight / 2, groupDataWidth - 20, 35}
                        end
                    
                    elseif groupMenuSelected == "groupMembers" then
                        for i = 1, 15 do
                            local groupMemberIndex = i + groupMemberScrollOffset
                            local groupMemberKey = "selectGroupMember:" .. groupMemberIndex

                            local groupMemberWidth = 250
                            local groupMemberHeight = (groupDataHeight - 20) / 15

                            local groupMemberPosX = groupDataPosX + 10
                            local groupMemberPosY = groupDataPosY + 10 + (i - 1) * groupMemberHeight

                            if dashboardActiveButton == groupMemberKey or groupMemberSelected == groupMemberIndex then
                                groupMemberColorR, groupMemberColorG, groupMemberColorB, groupMemberColorA = processColorSwitchEffect(groupMemberKey, 50, 186, 157, 200 * dashboardAlpha)
                            else
                                groupMemberColorR, groupMemberColorG, groupMemberColorB, groupMemberColorA = processColorSwitchEffect(groupMemberKey, 35, 39, 42, 255 * dashboardAlpha)
                            end

                            dxDrawRectangle(groupMemberPosX, groupMemberPosY, groupMemberWidth, groupMemberHeight, tocolor(groupMemberColorR, groupMemberColorG, groupMemberColorB, groupMemberColorA))
                            dxDrawRectangle(groupMemberPosX, groupMemberPosY, groupMemberWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))
                            dashboardButtons[groupMemberKey] = {groupMemberPosX, groupMemberPosY, groupMemberWidth, groupMemberHeight}

                            if groupData.members[groupMemberIndex] then
                                local groupMemberData = groupData.members[groupMemberIndex]
                                local groupMemberRank = groupData.ranks[groupMemberData.rank]

                                if groupMemberData.online then
                                    dxDrawText(groupMemberData.name, groupMemberPosX + 10, groupMemberPosY, groupMemberPosX + groupMemberWidth, groupMemberPosY + groupMemberHeight, tocolor(60, 184, 130, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "left", "center", false, false, false, true)
                                else
                                    dxDrawText(groupMemberData.name, groupMemberPosX + 10, groupMemberPosY, groupMemberPosX + groupMemberWidth, groupMemberPosY + groupMemberHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "left", "center", false, false, false, true)
                                end
                                dxDrawText(dashboardPrimaryColor .. groupMemberRank.name, groupMemberPosX - 10, groupMemberPosY, groupMemberPosX - 10 + groupMemberWidth, groupMemberPosY + groupMemberHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "right", "center", false, false, false, true)
                            end
                        end

                        local groupMemberData = groupData.members[groupMemberSelected]
                        if groupMemberData then
                            local groupMemberDataWidth = dashboardWidth - (dashboardSelectorWidth * 2) - 110
                            local groupMemberDataHeight = dashboardHeight - 70

                            local groupMemberDataPosX = dashboardSelectorPosX + 250 + (dashboardSelectorWidth * 2) + 120
                            local groupMemberDataPosY = groupMenuPosY + 50

                            local memberOnline = groupMemberData.online and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
                            local memberLastOnline = groupMemberData.lastOnline or "N/A"
                            local memberLeader = groupMemberData.leader and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"

                            dxDrawText(groupMemberData.name, groupMemberDataPosX, groupMemberDataPosY + 10, groupMemberDataPosX + groupMemberDataWidth, groupMemberDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                            
                            groupMemberDataPosY = groupMemberDataPosY + 40
                            dxDrawText("Online: " .. memberOnline, groupMemberDataPosX, groupMemberDataPosY, groupMemberDataPosX + groupMemberDataWidth, groupMemberDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        
                            groupMemberDataPosY = groupMemberDataPosY + 30
                            dxDrawText("Utoljára Online: " .. dashboardPrimaryColor .. memberLastOnline, groupMemberDataPosX, groupMemberDataPosY, groupMemberDataPosX + groupMemberDataWidth, groupMemberDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        
                            groupMemberDataPosY = groupMemberDataPosY + 30
                            dxDrawText("Rang: " .. dashboardPrimaryColor .. groupData.ranks[groupMemberData.rank].name, groupMemberDataPosX, groupMemberDataPosY, groupMemberDataPosX + groupMemberDataWidth, groupMemberDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        
                            groupMemberDataPosY = groupMemberDataPosY + 30
                            dxDrawText("Leader: " .. memberLeader, groupMemberDataPosX, groupMemberDataPosY, groupMemberDataPosX + groupMemberDataWidth, groupMemberDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                        
                            if groupData.leader then
                                for i = 1, #groupActionButtons do
                                    local actionButton = groupActionButtons[i]

                                    local actionButtonIndex = actionButton.buttonName
                                    local actionButtonName = actionButton.buttonTitle
                                    local actionButtonColor = actionButton.buttonColor

                                    local actionButtonWidth = 310
                                    local actionButtonHeight = 35

                                    local actionButtonPosX = groupMemberDataPosX
                                    local actionButtonPosY = groupMemberDataPosY + 235 + (i - 1) * (actionButtonHeight + 5)

                                    if dashboardActiveButton == actionButtonIndex then
                                        actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect(actionButtonIndex, actionButtonColor[1], actionButtonColor[2], actionButtonColor[3], 255 * dashboardAlpha)
                                    else
                                        actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect(actionButtonIndex, 35, 39, 42, 255 * dashboardAlpha)
                                    end

                                    if groupMemberKickPrompt and actionButtonIndex == "groupKick" then
                                        dxDrawText("Biztosan kiszeretnéd rúgni?", actionButtonPosX, actionButtonPosY, actionButtonPosX + actionButtonWidth, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "left", "center", false, false, false, true)
                                    
                                        if dashboardActiveButton == "finalGroupMemberKick" then
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("finalGroupMemberKick", 50, 186, 157, 255 * dashboardAlpha)
                                        else
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("finalGroupMemberKick", 35, 39, 42, 255 * dashboardAlpha)
                                        end

                                        dxDrawRectangle(actionButtonPosX + actionButtonWidth - 50, actionButtonPosY, 50, actionButtonHeight, tocolor(actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA * dashboardAlpha))
                                        dxDrawText("Igen", actionButtonPosX + actionButtonWidth - 50, actionButtonPosY, actionButtonPosX + actionButtonWidth - 50 + 50, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                        dashboardButtons["finalGroupMemberKick"] = {actionButtonPosX + actionButtonWidth - 50, actionButtonPosY, 50, actionButtonHeight}

                                        if dashboardActiveButton == "cancelGroupMemberKick" then
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("cancelGroupMemberKick", 243, 90, 90, 255 * dashboardAlpha)
                                        else
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("cancelGroupMemberKick", 35, 39, 42, 255 * dashboardAlpha)
                                        end

                                        dxDrawRectangle(actionButtonPosX + actionButtonWidth - 105, actionButtonPosY, 50, actionButtonHeight, tocolor(actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA * dashboardAlpha))
                                        dxDrawText("Nem", actionButtonPosX + actionButtonWidth - 105, actionButtonPosY, actionButtonPosX + actionButtonWidth - 105 + 50, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                        dashboardButtons["cancelGroupMemberKick"] = {actionButtonPosX + actionButtonWidth - 105, actionButtonPosY, 50, actionButtonHeight}
                                    elseif groupMemberInvitePrompt and actionButtonIndex == "groupInvite" then
                                        if not groupMemberInviteInput then
                                            groupMemberInviteInput = exports.seal_gui:createGuiElement("input", actionButtonPosX, actionButtonPosY, actionButtonWidth - 130, actionButtonHeight)
                                            exports.seal_gui:setInputPlaceholder(groupMemberInviteInput, "Játékos Név/ID")
                                            exports.seal_gui:setInputMaxLength(groupMemberInviteInput, 32)
                                        end
                                        
                                        if dashboardActiveButton == "finalGroupMemberInvite" then
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("finalGroupMemberInvite", 50, 186, 157, 255 * dashboardAlpha)
                                        else
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("finalGroupMemberInvite", 35, 39, 42, 255 * dashboardAlpha)
                                        end

                                        dxDrawRectangle(actionButtonPosX + actionButtonWidth - 60, actionButtonPosY, 60, actionButtonHeight, tocolor(actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA * dashboardAlpha))
                                        dxDrawText("Felvétel", actionButtonPosX + actionButtonWidth - 60, actionButtonPosY, actionButtonPosX + actionButtonWidth - 60 + 60, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                        dashboardButtons["finalGroupMemberInvite"] = {actionButtonPosX + actionButtonWidth - 60, actionButtonPosY, 60, actionButtonHeight}

                                        if dashboardActiveButton == "cancelGroupMemberInvite" then
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("cancelGroupMemberInvite", 243, 90, 90, 255 * dashboardAlpha)
                                        else
                                            actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA = processColorSwitchEffect("cancelGroupMemberInvite", 35, 39, 42, 255 * dashboardAlpha)
                                        end

                                        dxDrawRectangle(actionButtonPosX + actionButtonWidth - 125, actionButtonPosY, 60, actionButtonHeight, tocolor(actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA * dashboardAlpha))
                                        dxDrawText("Mégsem", actionButtonPosX + actionButtonWidth - 125, actionButtonPosY, actionButtonPosX + actionButtonWidth - 125 + 60, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                        dashboardButtons["cancelGroupMemberInvite"] = {actionButtonPosX + actionButtonWidth - 125, actionButtonPosY, 60, actionButtonHeight}
                                    else
                                        dxDrawRectangle(actionButtonPosX, actionButtonPosY, actionButtonWidth, actionButtonHeight, tocolor(actionButtonColorR, actionButtonColorG, actionButtonColorB, actionButtonColorA * dashboardAlpha))
                                        dxDrawText(actionButtonName, actionButtonPosX, actionButtonPosY, actionButtonPosX + actionButtonWidth, actionButtonPosY + actionButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                        dashboardButtons[actionButtonIndex] = {actionButtonPosX, actionButtonPosY, actionButtonWidth, actionButtonHeight}
                                    end
                                end
                            end
                        end
                    elseif groupMenuSelected == "groupVehicles" then
                        for i = 1, 15 do
                            local groupVehicleIndex = i + groupVehicleScrollOffset
                            local groupVehicleKey = "selectGroupVehicle:" .. groupVehicleIndex

                            local groupVehicleWidth = 250
                            local groupVehicleHeight = (groupDataHeight - 20) / 15

                            local groupVehiclePosX = groupDataPosX + 10
                            local groupVehiclePosY = groupDataPosY + 10 + (i - 1) * groupVehicleHeight

                            if dashboardActiveButton == groupVehicleKey or groupVehicleSelected == groupVehicleIndex then
                                groupVehicleColorR, groupVehicleColorG, groupVehicleColorB, groupVehicleColorA = processColorSwitchEffect(groupVehicleKey, 50, 186, 157, 200 * dashboardAlpha)
                            else
                                groupVehicleColorR, groupVehicleColorG, groupVehicleColorB, groupVehicleColorA = processColorSwitchEffect(groupVehicleKey, 35, 39, 42, 255 * dashboardAlpha)
                            end

                            dxDrawRectangle(groupVehiclePosX, groupVehiclePosY, groupVehicleWidth, groupVehicleHeight, tocolor(groupVehicleColorR, groupVehicleColorG, groupVehicleColorB, groupVehicleColorA))
                            dxDrawRectangle(groupVehiclePosX, groupVehiclePosY, groupVehicleWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))
                            dashboardButtons[groupVehicleKey] = {groupVehiclePosX, groupVehiclePosY, groupVehicleWidth, groupVehicleHeight}

                            if groupData.vehicles[groupVehicleIndex] then
                                local groupVehicleData = groupData.vehicles[groupVehicleIndex]

                                dxDrawText(groupVehicleData.vehicleName .. dashboardPrimaryColor .. " (" .. groupVehicleData.vehicleId .. ")", groupVehiclePosX + 10, groupVehiclePosY, groupVehiclePosX + groupVehicleWidth, groupVehiclePosY + groupVehicleHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "left", "center", false, false, false, true)
                            end
                        end

                        if groupVehicleSelected then
                            local groupVehicleData = groupData.vehicles[groupVehicleSelected]

                            if groupVehicleData then
                                local groupVehicleDataWidth = dashboardWidth - (dashboardSelectorWidth * 2) - 110
                                local groupVehicleDataHeight = dashboardHeight - 70

                                local groupVehicleDataPosX = dashboardSelectorPosX + 250 + (dashboardSelectorWidth * 2) + 120
                                local groupVehicleDataPosY = groupMenuPosY + 50

                                dxDrawText(groupVehicleData.vehicleName .. dashboardPrimaryColor .. " (" .. groupVehicleData.vehicleId .. ")", groupVehicleDataPosX, groupVehicleDataPosY + 10, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular10, "left", "center", false, false, false, true)
                                
                                groupVehicleDataPosY = groupVehicleDataPosY + 45
                                dxDrawText("Rendszám: " .. dashboardPrimaryColor .. groupVehicleData.vehiclePlate, groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            
                                if groupVehicleData.eletricVehicle then
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Villanymotor Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningEngine], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Akkumulátor Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningTurbo], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                else
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Motor Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningEngine], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Turbó Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningTurbo], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                end

                                groupVehicleDataPosY = groupVehicleDataPosY + 30
                                dxDrawText("ECU Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningECU], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            
                                if groupVehicleData.eletricVehicle then
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Inverter Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningTransmission], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                else
                                    groupVehicleDataPosY = groupVehicleDataPosY + 30
                                    dxDrawText("Váltó Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningTransmission], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                end

                                groupVehicleDataPosY = groupVehicleDataPosY + 30
                                dxDrawText("Felfüggesztés Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningSuspension], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            
                                groupVehicleDataPosY = groupVehicleDataPosY + 30
                                dxDrawText("Fék Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningBrakes], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            
                                groupVehicleDataPosY = groupVehicleDataPosY + 30
                                dxDrawText("Kerék Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningTires], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            
                                groupVehicleDataPosY = groupVehicleDataPosY + 30
                                dxDrawText("Súlycsökkentés Tuning: " .. dashboardPrimaryColor .. tuningName[groupVehicleData.tuningWeightReduction], groupVehicleDataPosX, groupVehicleDataPosY, groupVehicleDataPosX + groupVehicleDataWidth, groupVehicleDataPosY + 30, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                            end
                        end
                    elseif groupMenuSelected == "groupRanks" then
                        for i = 1, 15 do
                            local groupRankIndex = i + groupRankScrollOffset
                            local groupRankKey = "selectGroupRank:" .. groupRankIndex

                            if groupData.leader then
                                if i == 13 or i == 14 or i == 15 then
                                    groupRankWidth = 250
                                else
                                    groupRankWidth = groupDataWidth - 10
                                end
                            else
                                groupRankWidth = groupDataWidth - 10
                            end
                            local groupRankHeight = (groupDataHeight - 20) / 15

                            local groupRankPosX = groupDataPosX + 10
                            local groupRankPosY = groupDataPosY + 10 + (i - 1) * groupRankHeight

                            if dashboardActiveButton == groupRankKey or groupRankSelected == groupRankIndex then
                                groupRankColorR, groupRankColorG, groupRankColorB, groupRankColorA = processColorSwitchEffect(groupRankKey, 50, 186, 157, 200 * dashboardAlpha)
                            else
                                groupRankColorR, groupRankColorG, groupRankColorB, groupRankColorA = processColorSwitchEffect(groupRankKey, 35, 39, 42, 255 * dashboardAlpha)
                            end

                            dxDrawRectangle(groupRankPosX, groupRankPosY, groupRankWidth, groupRankHeight, tocolor(groupRankColorR, groupRankColorG, groupRankColorB, groupRankColorA))
                            dxDrawRectangle(groupRankPosX, groupRankPosY, groupRankWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))
                            dashboardButtons[groupRankKey] = {groupRankPosX, groupRankPosY, groupRankWidth, groupRankHeight}

                            if groupData.ranks[groupRankIndex] then
                                local groupRankData = groupData.ranks[groupRankIndex]
                                dxDrawText(groupRankData.name, groupRankPosX + 10, groupRankPosY, groupRankPosX + groupRankWidth, groupRankPosY + groupRankHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "left", "center", false, false, false, true)
                                dxDrawText(dashboardPrimaryColor .. formatNumber(groupRankData.pay) .. " #ffffff$", groupRankPosX - 10, groupRankPosY, groupRankPosX - 10 + groupRankWidth, groupRankPosY + groupRankHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "right", "center", false, false, false, true)
                            end
                        end

                        if groupRankSelected and groupData.leader then
                            local groupRankData = groupData.ranks[groupRankSelected]

                            if groupRankData then
                                dxDrawText("Rang szerkesztése", groupDataPosX + 270, groupDataPosY + 485, groupDataPosX + 270 + 320, groupDataPosY + 485 + 35, tocolor(255, 255, 255, dashboardAlpha * 255), 0.85, bebasNeueRegular9, "center", "center", false, false, false, true)
                                
                                for i = 1, #groupRankButtons do
                                    local rankButton = groupRankButtons[i]

                                    if rankButton then
                                        local rankButtonIndex = rankButton.buttonName
                                        local rankButtonName = rankButton.buttonTitle

                                        local rankButtonWidth = 320
                                        local rankButtonHeight = 35

                                        local rankButtonPosX = groupDataPosX + rankButtonWidth - 50
                                        local rankButtonPosY = groupDataPosY + 525 + (i - 1) * (rankButtonHeight + 5)

                                        if dashboardActiveButton == rankButtonIndex then
                                            rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect(rankButtonIndex, 50, 186, 157, 255 * dashboardAlpha)
                                        else
                                            rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect(rankButtonIndex, 35, 39, 42, 255 * dashboardAlpha)
                                        end

                                        if groupRankRenamePrompt and rankButtonIndex == "groupRankRename" then
                                            if not groupRankNameInput then
                                                groupRankNameInput = exports.seal_gui:createGuiElement("input", rankButtonPosX, rankButtonPosY, rankButtonWidth - 130, rankButtonHeight)
                                                exports.seal_gui:setInputPlaceholder(groupRankNameInput, "Rang Név")
                                                exports.seal_gui:setInputMaxLength(groupRankNameInput, 32)
                                                exports.seal_gui:setInputValue(groupRankNameInput, groupRankData.name)
                                            end

                                            if dashboardActiveButton == "saveRankName" then
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("saveRankName", 50, 186, 157, 255 * dashboardAlpha)
                                            else
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("saveRankName", 35, 39, 42, 255 * dashboardAlpha)
                                            end

                                            dxDrawRectangle(rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, 60, rankButtonHeight, tocolor(rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA * dashboardAlpha))
                                            dxDrawText("Mentés", rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, rankButtonPosX + rankButtonWidth - 60 + 60, rankButtonPosY + rankButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                            dashboardButtons["saveRankName"] = {rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, 60, rankButtonHeight}

                                            if dashboardActiveButton == "cancelRankName" then
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("cancelRankName", 243, 90, 90, 255 * dashboardAlpha)
                                            else
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("cancelRankName", 35, 39, 42, 255 * dashboardAlpha)
                                            end

                                            dxDrawRectangle(rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, 60, rankButtonHeight, tocolor(rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA * dashboardAlpha))
                                            dxDrawText("Mégsem", rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, rankButtonPosX + rankButtonWidth - 125 + 60, rankButtonPosY + rankButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                            dashboardButtons["cancelRankName"] = {rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, 60, rankButtonHeight}
                                        elseif groupRankPayChangePrompt and rankButtonIndex == "grupRankPayChange" then
                                            if not groupRankSalaryInput then
                                                groupRankSalaryInput = exports.seal_gui:createGuiElement("input", rankButtonPosX, rankButtonPosY, rankButtonWidth - 130, rankButtonHeight)
                                                exports.seal_gui:setInputPlaceholder(groupRankSalaryInput, "Rang Fizetés")
                                                exports.seal_gui:setInputMaxLength(groupRankSalaryInput, 32)
                                                exports.seal_gui:setInputNumberOnly(groupRankSalaryInput, true)
                                                exports.seal_gui:setInputValue(groupRankSalaryInput, groupRankData.pay)
                                            end

                                            if dashboardActiveButton == "saveRankSalary" then
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("saveRankSalary", 50, 186, 157, 255 * dashboardAlpha)
                                            else
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("saveRankSalary", 35, 39, 42, 255 * dashboardAlpha)
                                            end

                                            dxDrawRectangle(rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, 60, rankButtonHeight, tocolor(rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA * dashboardAlpha))
                                            dxDrawText("Mentés", rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, rankButtonPosX + rankButtonWidth - 60 + 60, rankButtonPosY + rankButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                            dashboardButtons["saveRankSalary"] = {rankButtonPosX + rankButtonWidth - 60, rankButtonPosY, 60, rankButtonHeight}

                                            if dashboardActiveButton == "cancelRankSalary" then
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("cancelRankSalary", 243, 90, 90, 255 * dashboardAlpha)
                                            else
                                                rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA = processColorSwitchEffect("cancelRankSalary", 35, 39, 42, 255 * dashboardAlpha)
                                            end

                                            dxDrawRectangle(rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, 60, rankButtonHeight, tocolor(rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA * dashboardAlpha))
                                            dxDrawText("Mégsem", rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, rankButtonPosX + rankButtonWidth - 125 + 60, rankButtonPosY + rankButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                            dashboardButtons["cancelRankSalary"] = {rankButtonPosX + rankButtonWidth - 125, rankButtonPosY, 60, rankButtonHeight}
                                        else
                                            dxDrawRectangle(rankButtonPosX, rankButtonPosY, rankButtonWidth, rankButtonHeight, tocolor(rankButtonColorR, rankButtonColorG, rankButtonColorB, rankButtonColorA * dashboardAlpha))
                                            dxDrawText(rankButtonName, rankButtonPosX, rankButtonPosY, rankButtonPosX + rankButtonWidth, rankButtonPosY + rankButtonHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                                            dashboardButtons[rankButtonIndex] = {rankButtonPosX, rankButtonPosY, rankButtonWidth, rankButtonHeight}
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif dashboardSelectedMenu == "premiumshop" then
            local categoryPosX = dashboardSelectorPosX + dashboardSelectorWidth
            local categoryPosY = dashboardSelectorPosY + 10

            for i = 1, #premiumShopCategorys do
                local premiumShopCategory = premiumShopCategorys[i]

                if premiumShopCategory then
                    local categoryIndex = "selectPremiumCategory:" .. premiumShopCategory[1]
                    local categoryName = premiumShopCategory[2]

                    local categoryNameWidth = dxGetTextWidth(categoryName, 1, bebasNeueRegular9) + 20
                    local categoryWidth = 774
                    local categoryHeight = 40

                    if dashboardActiveButton == categoryIndex or premiumCategorySelected == premiumShopCategory[1] then
                        premiumCategoryListColorR, premiumCategoryListColorG, premiumCategoryListColorB, premiumCategoryListColorA = processColorSwitchEffect(categoryIndex, 50, 186, 157, 255 * dashboardAlpha)
                    else
                        premiumCategoryListColorR, premiumCategoryListColorG, premiumCategoryListColorB, premiumCategoryListColorA = processColorSwitchEffect(categoryIndex, 35, 39, 42, 255 * dashboardAlpha)
                    end

                    dxDrawRectangle(categoryPosX + (dashboardWidth - dashboardSelectorWidth) / 2 - categoryWidth / 2, categoryPosY, categoryNameWidth, categoryHeight, tocolor(premiumCategoryListColorR, premiumCategoryListColorG, premiumCategoryListColorB, premiumCategoryListColorA))
                    dxDrawText(categoryName, categoryPosX + (dashboardWidth - dashboardSelectorWidth) / 2 - categoryWidth / 2 + 10, categoryPosY, categoryPosX + (dashboardWidth - dashboardSelectorWidth) / 2 - categoryWidth / 2 + categoryNameWidth, categoryPosY + categoryHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    dashboardButtons[categoryIndex] = {categoryPosX + (dashboardWidth - dashboardSelectorWidth) / 2 - categoryWidth / 2, categoryPosY, categoryNameWidth, categoryHeight}
                    
                    categoryPosX = categoryPosX + (categoryNameWidth + 5)
                end
            end

            if premiumShopCategoryItems[premiumCategorySelected] then
                local categoryItems = premiumShopCategoryItems[premiumCategorySelected]

                local categoryWidth = dashboardWidth - dashboardSelectorWidth - 20
                local categoryHeight = dashboardHeight - 70

                local categoryPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
                local categoryPosY = dashboardSelectorPosY + 60

                for i = 1, 13 do
                    local categoryOneWidth = categoryWidth
                    local categoryOneHeight = categoryHeight / 13

                    local categoryOnePosX = categoryPosX
                    local categoryOnePosY = categoryPosY + (i - 1) * categoryOneHeight

                    dxDrawImage(categoryOnePosX, categoryOnePosY, categoryOneWidth, categoryOneHeight, "files/images/selector.png", 0, 0, 0, tocolor(35, 39, 42, dashboardAlpha * 255))
                    dxDrawRectangle(categoryOnePosX, categoryOnePosY, categoryOneWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))

                    local categoryIndex = i + premiumCategoryScroll
                    local categoryData = categoryItems[categoryIndex]
                    
                    if categoryData then
                        local categoryButtonIndex = "buyPremiumItem:" .. categoryIndex

                        local categoryButtonWidth = 120
                        local categoryButtonHeight = categoryOneHeight - 10

                        dxDrawImage(categoryOnePosX + 5, categoryOnePosY + 5, categoryButtonHeight, categoryButtonHeight, ":seal_items/files/items/" .. categoryData.itemId - 1 .. ".png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                        dxDrawText(categoryData.itemName .. dashboardBlueColor .. " (" .. categoryData.itemPrice .. " PP)", categoryOnePosX + categoryButtonHeight + 10, categoryOnePosY, categoryOnePosX + categoryOneWidth, categoryOnePosY + categoryOneHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                    
                        if dashboardActiveButton == categoryButtonIndex then
                            premiumButtonColorR, premiumButtonColorG, premiumButtonColorB, premiumButtonColorA = processColorSwitchEffect(categoryButtonIndex, 50, 186, 157, 255 * dashboardAlpha)
                        else
                            premiumButtonColorR, premiumButtonColorG, premiumButtonColorB, premiumButtonColorA = processColorSwitchEffect(categoryButtonIndex, 35, 39, 42, 255 * dashboardAlpha)
                        end
                        
                        dxDrawRectangle(categoryOnePosX + categoryOneWidth - categoryButtonWidth - 5, categoryOnePosY + 5, categoryButtonWidth, categoryButtonHeight, tocolor(premiumButtonColorR, premiumButtonColorG, premiumButtonColorB, premiumButtonColorA))
                        dxDrawText("Megvásárlás", categoryOnePosX + categoryOneWidth - categoryButtonWidth - 5, categoryOnePosY + 5, categoryOnePosX + categoryOneWidth - 5, categoryOnePosY + categoryButtonHeight + 5, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "center", "center", false, false, false, true)
                    
                        dashboardButtons[categoryButtonIndex] = {categoryOnePosX + categoryOneWidth - categoryButtonWidth - 5, categoryOnePosY + 5, categoryButtonWidth, categoryButtonHeight}
                    end
                end
            end
        elseif dashboardSelectedMenu == "admins" then
            local adminListWidth = dashboardWidth - dashboardSelectorWidth - 50
            local adminListHeight = dashboardHeight - 20

            local adminListPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
            local adminListPosY = dashboardSelectorPosY + 10

            for i = 1, 4 do
                local adminListIndex = i + adminScrollOffset
                local adminListKey = "selectAdmin:" .. adminListIndex

                local adminOneWidth = adminListWidth / 4
                local adminOneHeight = adminListHeight

                local adminOnePosX = adminListPosX + ((adminOneWidth + 10) * (i - 1))
                local adminOnePosY = adminListPosY

                dxDrawRectangle(adminOnePosX, adminOnePosY, adminOneWidth, adminOneHeight, tocolor(35, 39, 42, dashboardAlpha * 255))

                local adminListData = adminListDatas[adminListIndex]

                if adminListData then
                    for j = 1, 15 do                        
                        local adminDataWidth = adminOneWidth
                        local adminDataHeight = adminOneHeight / 15

                        local adminDataPosX = adminOnePosX
                        local adminDataPosY = adminOnePosY + (j - 1) * adminDataHeight

                        dxDrawRectangle(adminDataPosX, adminDataPosY, adminDataWidth, adminDataHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
                        dxDrawRectangle(adminDataPosX, adminDataPosY, adminDataWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))

                        local adminData = adminListData[j]

                        if adminData then
                            if not adminData[3] and adminData[2] then
                                dxDrawText(adminData[1], adminDataPosX, adminDataPosY, adminDataPosX + adminDataWidth, adminDataPosY + adminDataHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "center", "center", false, false, false, true)
                            else
                                if adminData[3] == 1 or adminData[6] then
                                    dxDrawText(adminData[1] .. " (" .. adminData[5] .. ")", adminDataPosX + 10, adminDataPosY, adminDataPosX + adminDataWidth, adminDataPosY + adminDataHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                else
                                    dxDrawText(adminData[1], adminDataPosX + 10, adminDataPosY, adminDataPosX + adminDataWidth, adminDataPosY + adminDataHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)
                                end
                                
                                dxDrawText(adminData[2], adminDataPosX - 10, adminDataPosY, adminDataPosX - 10 + adminDataWidth, adminDataPosY + adminDataHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "right", "center", false, false, false, true)
                            end
                        end
                    end
                end
            end
        elseif dashboardSelectedMenu == "settings" then
            for i = 1, #dashboardSettings do
                local dashboardSetting = dashboardSettings[i]
                local settingsWidth = dashboardWidth - dashboardSelectorWidth - 20
                local settingsHeight = 40

                local settingsPosX = dashboardSelectorPosX + dashboardSelectorWidth + 10
                local settingsPosY = dashboardSelectorPosY + 15 + (i - 1) * settingsHeight

                local settingsKey = "selectSetting:" .. i

                if dashboardActiveButton == settingsKey then
                    settingsColorR, settingsColorG, settingsColorB, settingsColorA = processColorSwitchEffect(settingsKey, 50, 186, 157, 255 * dashboardAlpha)
                else
                    settingsColorR, settingsColorG, settingsColorB, settingsColorA = processColorSwitchEffect(settingsKey, 35, 39, 42, 255 * dashboardAlpha)
                end
                
                dxDrawImage(settingsPosX, settingsPosY, settingsWidth, settingsHeight, "files/images/selector.png", 0, 0, 0, tocolor(settingsColorR, settingsColorG, settingsColorB, settingsColorA, 255 * dashboardAlpha))
                dxDrawRectangle(settingsPosX, settingsPosY, settingsWidth, 1, tocolor(26, 27, 31, 255 * dashboardAlpha))
                dxDrawText(dashboardSetting.optionTitle, settingsPosX + 10, settingsPosY, settingsPosX + settingsWidth, settingsPosY + settingsHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "left", "center", false, false, false, true)

                if dashboardSetting.isSwitchable then
                    local switchKey = settingsKey .. ":switch"

                    local switchWidth = 60
                    local switchHeight = settingsHeight - 10

                    local switchPosX = settingsPosX + settingsWidth - switchWidth - 10
                    local switchPosY = settingsPosY + 5

                    local switchMoveWidth = switchWidth / 2 - 5
                    local switchMoveX = 0

                    if dashboardSetting.customValue then
                        switchMoveX = processColorSwitchEffect(switchKey, switchMoveWidth, 0, 0, 0)
                        sliderColorR, sliderColorG, sliderColorB, sliderColorA = processColorSwitchEffect(switchKey .. ":color", 50, 186, 157, 255 * dashboardAlpha)
                    else
                        switchMoveX = processColorSwitchEffect(switchKey, 0, 0, 0, 0)
                        sliderColorR, sliderColorG, sliderColorB, sliderColorA = processColorSwitchEffect(switchKey .. ":color", 243, 90, 90, 255 * dashboardAlpha)
                    end

                    dxDrawRectangle(switchPosX, switchPosY, switchWidth, switchHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
                    dxDrawRectangle(switchPosX + 5 + switchMoveX, switchPosY + 5, switchMoveWidth, switchHeight - 10, tocolor(sliderColorR, sliderColorG, sliderColorB, sliderColorA))
                    dashboardButtons[switchKey] = {switchPosX, switchPosY, switchWidth, switchHeight}
                elseif dashboardSetting.isSlider then
                    local sliderKey = settingsKey .. ":slider"
                    local sliderSettingValue = dashboardSetting.customValue or dashboardSetting.defaultValue

                    local sliderWidth = 200
                    local sliderHeight = settingsHeight - 10

                    local sliderPosX = settingsPosX + settingsWidth - sliderWidth - 10
                    local sliderPosY = settingsPosY + 5

                    local sliderMoveProgress = (sliderSettingValue - dashboardSetting.minimumValue) / (dashboardSetting.maximumValue - dashboardSetting.minimumValue)
                    local sliderMoveWidth = (sliderWidth - 10) * sliderMoveProgress

                    if getKeyState("mouse1") then
                        if dashboardActiveButton == sliderKey then
                            local sliderValue = (cursorX - sliderPosX) / (sliderWidth - 10)
                            sliderValue = math.max(0, math.min(1, sliderValue))

                            dashboardSetting.customValue = dashboardSetting.maximumValue * sliderValue
                            dashboardSetting.customValue = math.max(dashboardSetting.minimumValue, math.min(dashboardSetting.maximumValue, dashboardSetting.customValue))
                            sliderMoveWidth = (sliderWidth - 10) * sliderValue

                            if dashboardSetting.optionDataName == "viewdistance" then
                                setFarClipDistance(100 + dashboardSetting.customValue)
                            end
                        end
                    end

                    dxDrawRectangle(sliderPosX, sliderPosY, sliderWidth, sliderHeight, tocolor(35, 39, 42, dashboardAlpha * 255))
                    dxDrawRectangle(sliderPosX + 5, sliderPosY + 5, sliderMoveWidth, sliderHeight - 10, tocolor(50, 186, 157, dashboardAlpha * 255))
                    dxDrawText(math.floor(sliderSettingValue) .. " yard", sliderPosX, sliderPosY, sliderPosX + sliderWidth, sliderPosY + sliderHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 0.8, bebasNeueRegular9, "center", "center", false, false, false, true)
                    dashboardButtons[sliderKey] = {sliderPosX, sliderPosY, sliderWidth, sliderHeight}
                else
                    if dashboardSetting.optionDataName == "crosshair" then
                        local settingsValue = dashboardSetting.customValue and dashboardSetting.customValue or dashboardSetting.defaultValue

                        local crosshairWidth = settingsHeight - 10
                        local crosshairHeight = crosshairWidth
                    
                        local crosshairPosX = settingsPosX + settingsWidth - crosshairWidth - 10
                        local crosshairPosY = settingsPosY + 5

                        local crosshairWidth = crosshairWidth * 0.5
                        local crosshairHeight = crosshairHeight * 0.5

                        dxDrawImage(crosshairPosX, crosshairPosY, crosshairWidth, crosshairHeight, ":seal_crosshair/files/" .. settingsValue .. ".png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                        dxDrawImage(crosshairPosX + (crosshairWidth * 2), crosshairPosY, -crosshairWidth, crosshairHeight, ":seal_crosshair/files/" .. settingsValue .. ".png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))

                        dxDrawImage(crosshairPosX, crosshairPosY + (crosshairHeight * 2), crosshairWidth, -crosshairHeight, ":seal_crosshair/files/" .. settingsValue .. ".png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                        dxDrawImage(crosshairPosX + (crosshairWidth * 2), crosshairPosY + (crosshairHeight * 2), -crosshairWidth, -crosshairHeight, ":seal_crosshair/files/" .. settingsValue .. ".png", 0, 0, 0, tocolor(255, 255, 255, dashboardAlpha * 255))
                    else
                        local settingsValue = dashboardSetting.customValue and dashboardSetting.customValue or dashboardSetting.defaultValue
                        local settingsSuffix = dashboardSetting.optionSuffix or ""

                        if dashboardSetting.optionDataName == "fightingStyle" then
                            settingsValue = dashboardFightningStyleNames[settingsValue] or "N/A"
                        elseif dashboardSetting.optionDataName == "walkingStyle" then
                            settingsValue = dashboardWalkingStyleNames[settingsValue] or "N/A"
                        end

                        dxDrawText(dashboardPrimaryColor .. settingsValue .. settingsSuffix, settingsPosX - 10, settingsPosY, settingsPosX - 10 + settingsWidth, settingsPosY + settingsHeight, tocolor(255, 255, 255, dashboardAlpha * 255), 1, bebasNeueRegular9, "right", "center", false, false, false, true)
                    end
                    
                    dashboardButtons[settingsKey] = {settingsPosX, settingsPosY, settingsWidth, settingsHeight}
                end
            end
        end
    end

    -- ** Button handler
    dashboardActiveButton = false

    if isCursorShowing() then
        for buttonName, buttonPosition in pairs(dashboardButtons) do
            if isMouseInPosition(buttonPosition[1], buttonPosition[2], buttonPosition[3], buttonPosition[4]) then
                dashboardActiveButton = buttonName
                break
            end
        end
    end
end

addEvent("refreshItemPriceLabel", true)
addEventHandler("refreshItemPriceLabel", getRootElement(), function(inputValue, el)
    if premiumItemAmountInput == el then
        local itemData = premiumShopCategoryItems[premiumCategorySelected][premiumItemBuy]
        local itemName = "N/A"
        local itemPrice = 0

        if itemData then
            itemName = exports.seal_items:getItemName(itemData.itemId)
            itemPrice = itemData.itemPrice * (tonumber(inputValue) or 1)
        end

        if premiumItemPrice then
            exports.seal_gui:setLabelText(premiumItemPrice, itemName .. " " .. dashboardBlueColor .. itemPrice .. " PP")
        end
    end
end)

addEvent("refreshSlotPriceLabel", true)
addEventHandler("refreshSlotPriceLabel", getRootElement(), function(inputValue, el)
    if slotItemAmountInput == el then
        if slotItemPrice then
            local slotAmount = tonumber(inputValue) or 0
            exports.seal_gui:setLabelText(slotItemPrice, slotAmount .. " SLOT " .. dashboardBlueColor .. slotAmount * 100 .. " PP")
        end
    end
end)

addEvent("closeSlotBuyGui", true)
addEventHandler("closeSlotBuyGui", getRootElement(), function ()
    if slotBuyGui then
        exports.seal_gui:deleteGuiElement(slotBuyGui)
    end
    
    vehicleBuySlotPrompt = false
    interiorBuySlotPrompt = false
    
    slotBuyGui = false
    slotItemPrice = false
    slotItemAmountInput = false
    slotItemBuyButton = false
    slotItemCancelBuyButton = false
end)

addEvent("closePremiumBuyGui", true)
addEventHandler("closePremiumBuyGui", getRootElement(), function ()
    if slotBuyGui then
        exports.seal_gui:deleteGuiElement(slotBuyGui)
    end

    slotBuyGui = false
    slotItemPrice = false
    slotItemAmountInput = false
    slotItemBuyButton = false
    slotItemCancelBuyButton = false
end)

function clickDashboard(button, state)
    if dashboardActiveButton then
        if state ~= "down" then
            return
        end

        if dashboardFadeIn or dashboardFadeOut then
            return
        end

        if premiumItemBuy then
            return
        end

        local buttonData = split(dashboardActiveButton, ":")

        if dashboardActiveButton == "buyVehicleSlot" then
            vehicleBuySlotPrompt = true
        elseif dashboardActiveButton == "buyInteriorSlot" then
            interiorBuySlotPrompt = true
        elseif dashboardActiveButton == "editGroupDescription" then
            local groupDescription = exports.seal_gui:getInputValue(groupDescriptionInput) or ""
            triggerServerEvent("rewriteGroupDescription", localPlayer, groupDescription, playerGroupDatas[groupListSelected].id)
        elseif dashboardActiveButton == "groupRankRename" then
            groupRankRenamePrompt = true
        elseif dashboardActiveButton == "saveRankName" then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupRankData = playerGroupData.ranks[groupRankSelected]

                if groupRankData then
                    local groupRankName = exports.seal_gui:getInputValue(groupRankNameInput) or ""

                    if groupRankName == "" then
                        exports.seal_gui:showNotification("error", "Kérlek adj meg egy rang nevet!")
                        return
                    end

                    triggerServerEvent("renameGroupRank", localPlayer, groupRankSelected, groupRankName, playerGroupData.id)
                end
            end

            if groupRankNameInput then
                exports.seal_gui:deleteGuiElement(groupRankNameInput)
            end
            groupRankRenamePrompt = false
            groupRankNameInput = false
        elseif dashboardActiveButton == "cancelRankName" then
            if groupRankNameInput then
                exports.seal_gui:deleteGuiElement(groupRankNameInput)
            end
            groupRankRenamePrompt = false
            groupRankNameInput = false
        elseif dashboardActiveButton == "saveRankSalary" then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupRankData = playerGroupData.ranks[groupRankSelected]

                if groupRankData then
                    local groupRankSalary = exports.seal_gui:getInputValue(groupRankSalaryInput) or ""

                    local groupRankSalary = tonumber(groupRankSalary) or 0
                    if groupRankSalary < 0 then
                        exports.seal_gui:showInfobox("error", "Kérlek adj meg egy pozitív számot!")
                        return
                    end

                    if groupRankSalary > 100000 then
                        exports.seal_gui:showInfobox("error", "A fizetés nem lehet több, mint 100.000$")
                        return
                    end

                    triggerServerEvent("setGroupRankPayment", localPlayer, groupRankSelected, groupRankSalary, playerGroupData.id)
                end
            end

            if groupRankSalaryInput then
                exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
            end
            groupRankPayChangePrompt = false
            groupRankSalaryInput = false
        elseif dashboardActiveButton == "cancelRankSalary" then
            if groupRankSalaryInput then
                exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
            end
            groupRankPayChangePrompt = false
            groupRankSalaryInput = false
        elseif dashboardActiveButton == "grupRankPayChange" then
            groupRankPayChangePrompt = true
        elseif dashboardActiveButton == "groupPromote" and groupMemberSelected then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    triggerServerEvent("modifyRankForPlayer", localPlayer, groupMemberData.characterId, groupMemberData.rank, playerGroupData.id, "up", groupMemberData.online, playerGroups, true)
                end
            end
        elseif dashboardActiveButton == "groupDemote" and groupMemberSelected then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    triggerServerEvent("modifyRankForPlayer", localPlayer, groupMemberData.characterId, groupMemberData.rank, playerGroupData.id, "down", groupMemberData.online, playerGroups, true)
                end
            end
        elseif dashboardActiveButton == "groupLeaderGive" and groupMemberSelected then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    triggerServerEvent("modifyLeaderForPlayer", localPlayer, groupMemberData.characterId, playerGroupData.id, "give", groupMemberData.online, playerGroups)
                end
            end
        elseif dashboardActiveButton == "groupLeaderTake" and groupMemberSelected then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    triggerServerEvent("modifyLeaderForPlayer", localPlayer, groupMemberData.characterId, playerGroupData.id, "take", groupMemberData.online, playerGroups)
                end
            end
        elseif dashboardActiveButton == "groupKick" and groupMemberSelected then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    groupMemberKickPrompt = true
                end
            end
        elseif dashboardActiveButton == "finalGroupMemberKick" then
            local playerGroupData = playerGroupDatas[groupListSelected]
            
            if playerGroupData then
                local groupMemberData = playerGroupData.members[groupMemberSelected]

                if groupMemberData then
                    if not isElement(groupMemberData.online) then
                        groupMemberData.online = false
                    end

                    triggerServerEvent("deletePlayerFromGroup", localPlayer, groupMemberData.characterId, playerGroupData.id, groupMemberData.online, playerGroups)
                end
            end

            groupMemberSelected = false
            groupMemberScrollOffset = 0
        elseif dashboardActiveButton == "cancelGroupMemberKick" then
            groupMemberKickPrompt = false
        elseif dashboardActiveButton == "groupInvite" then
            groupMemberInvitePrompt = true
        elseif dashboardActiveButton == "finalGroupMemberInvite" then
            local playerGroupData = playerGroupDatas[groupListSelected]

            if playerGroupData then
                local groupInviteText = exports.seal_gui:getInputValue(groupMemberInviteInput) or ""
                local groupInvitedElement = exports.seal_core:findPlayer(localPlayer, groupInviteText)

                if groupInvitedElement and isElement(groupInvitedElement) then
                    local characterId = getElementData(groupInvitedElement, "char.ID")

                    triggerServerEvent("invitePlayerToGroup", localPlayer, characterId, playerGroupData.id, groupInvitedElement, playerGroups)
                end
                
                if groupMemberInviteInput then
                    exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
                end

                groupMemberInviteInput = false
                groupMemberInvitePrompt = false
            end
        elseif dashboardActiveButton == "cancelGroupMemberInvite" then
            if groupMemberInviteInput then
                exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
            end

            groupMemberInviteInput = false
            groupMemberInvitePrompt = false
        elseif buttonData[1] == "selectGroupRank" then
            if playerGroupDatas[groupListSelected] then
                groupRankSelected = tonumber(buttonData[2])

                if groupRankNameInput then
                    exports.seal_gui:deleteGuiElement(groupRankNameInput)
                end

                if groupRankSalaryInput then
                    exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
                end

                groupRankNameInput = false
                groupRankSalaryInput = false

                groupRankRenamePrompt = false
                groupRankPayChangePrompt = false
            end
        elseif buttonData[1] == "selectGroup" then
            if playerGroupDatas[tonumber(buttonData[2])] then
                groupListSelected = tonumber(buttonData[2])

                if groupDescriptionInput then
                    exports.seal_gui:deleteGuiElement(groupDescriptionInput)
                end

                if groupMemberInviteInput then
                    exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
                end
                
                if groupRankNameInput then
                    exports.seal_gui:deleteGuiElement(groupRankNameInput)
                end
                groupRankNameInput = false

                if groupRankSalaryInput then
                    exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
                end
                groupRankSalaryInput = false

                groupMemberSelected = false
                groupMemberScrollOffset = 0

                groupDescriptionInput = false
                groupMemberKickPrompt = false
                groupMemberInvitePrompt = false
                groupMemberInviteInput = false

                groupRankRenamePrompt = false
                groupRankPayChangePrompt = false
            end
        elseif buttonData[1] == "selectGroupMember" then
            local groupData = playerGroupDatas[groupListSelected]

            if groupData then
                local groupMemberIndex = tonumber(buttonData[2])

                if groupData.members and groupData.members[groupMemberIndex] then
                    groupMemberSelected = tonumber(buttonData[2])

                    if groupMemberInviteInput then
                        exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
                    end

                    groupMemberKickPrompt = false
                    groupMemberInvitePrompt = false
                    groupMemberInviteInput = false
                end
            end
        elseif buttonData[1] == "selectGroupVehicle" then
            local groupData = playerGroupDatas[groupListSelected]

            if groupData then
                local groupVehicleINdex = tonumber(buttonData[2])

                if groupData.vehicles and groupData.vehicles[groupVehicleINdex] then
                    groupVehicleSelected = tonumber(buttonData[2])
                end
            end
        elseif buttonData[1] == "selectGroupMenu" then
            groupMenuSelected = buttonData[2]

            if groupDescriptionInput then
                exports.seal_gui:deleteGuiElement(groupDescriptionInput)
            end

            if groupMemberInviteInput then
                exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
            end

            if groupRankNameInput then
                exports.seal_gui:deleteGuiElement(groupRankNameInput)
            end
            groupRankNameInput = false

            if groupRankSalaryInput then
                exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
            end
            groupRankSalaryInput = false

            groupDescriptionInput = false
            groupMemberKickPrompt = false
            groupMemberInvitePrompt = false
            groupMemberInviteInput = false
            groupRankRenamePrompt = false
            groupRankPayChangePrompt = false
        elseif buttonData[1] == "selectMenu" then
            if dashboardSelectedMenu == "factions" then
                if groupDescriptionInput then
                    exports.seal_gui:deleteGuiElement(groupDescriptionInput)
                end
                
                if groupMemberInviteInput then
                    exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
                end

                if groupRankNameInput then
                    exports.seal_gui:deleteGuiElement(groupRankNameInput)
                end
                groupRankNameInput = false

                if groupRankSalaryInput then
                    exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
                end
                groupRankSalaryInput = false

                groupDescriptionInput = false
                groupMemberKickPrompt = false
                groupMemberInvitePrompt = false
                groupMemberInviteInput = false
                groupRankRenamePrompt = false
                groupRankPayChangePrompt = false
            elseif dashboardSelectedMenu == "vehicles" then
                vehicleBuySlotPrompt = false
                interiorBuySlotPrompt = false
            end

            dashboardSelectedMenu = buttonData[2]

            if dashboardSelectedMenu == "vehicles" then
                triggerServerEvent("requestPlayerVehicles", localPlayer)
            elseif dashboardSelectedMenu == "interiors" then
                playerInteriors = exports.seal_interiors:requestInteriors(localPlayer)

                for i = 1, #playerInteriors do
                    local priceType = (playerInteriors[i].data.type == "rentable") and "#ffffffBérelti díj" or "#ffffffEredeti ár"
                    local priceUnit = (playerInteriors[i].data.type == "rentable") and "$/hét" or "$"
                    playerInteriors[i].price = priceType .. ": " .. dashboardPrimaryColor .. formatNumber(playerInteriors[i].data.price) .. " #ffffff" .. priceUnit         
                    
                    playerInteriors[i].icon = exports.seal_interiors:getIconByMarkerType(playerInteriors[i].data.type)
                    playerInteriors[i].type = interiorTypes[playerInteriors[i].data.type]
                    playerInteriors[i].locked = playerInteriors[i].locked == "Y" and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
                    playerInteriors[i].editable = playerInteriors[i].editable == "Y" and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
                    playerInteriors[i].gameInterior = playerInteriors[i].data.gameInterior
                    playerInteriors[i].ownerName = dashboardDatas["visibleName"]
                end
            elseif dashboardSelectedMenu == "admins" then
                refreshAdminList()
            elseif dashboardSelectedMenu == "factions" then
                refreshGroupList()
            end
        elseif buttonData[1] == "selectVehicle" then
            vehicleListSelected = tonumber(buttonData[2])
        elseif buttonData[1] == "selectInterior" then
            interiorListSelected = tonumber(buttonData[2])
        elseif buttonData[1] == "selectPremiumCategory" then
            premiumCategorySelected = buttonData[2]
            premiumCategoryScroll = 0
        elseif buttonData[1] == "buyPremiumItem" then
            premiumItemBuy = tonumber(buttonData[2])
        elseif buttonData[1] == "selectSetting" then
            if buttonData[3] == "switch" then
                local settingData = dashboardSettings[tonumber(buttonData[2])]

                if settingData then
                    settingData.customValue = not settingData.customValue

                    if settingData.optionDataName == "dl_ssao" then
                        exports.seal_dlssao:handleonClientSwitchAO(settingData.customValue)
                    end
                end
            else
                local settingData = dashboardSettings[tonumber(buttonData[2])]

                if settingData then
                    if settingData.optionDataName == "fightingStyle" then
                        local fightingStyle = settingData.customValue or settingData.defaultValue
                        fightingStyle = fightingStyle + 1
                        fightingStyle = (fightingStyle > #dashboardFightningStyles) and 1 or fightingStyle

                        settingData.customValue = fightingStyle
                        triggerServerEvent("setPedFightingStyle", localPlayer, dashboardFightningStyles[fightingStyle])
                    elseif settingData.optionDataName == "walkingStyle" then
                        local walkingStyle = settingData.customValue or settingData.defaultValue
                        walkingStyle = walkingStyle + 1
                        walkingStyle = (walkingStyle > #dashboardWalkingStyles) and 1 or walkingStyle

                        settingData.customValue = walkingStyle
                        triggerServerEvent("setPedWalkingStyle", localPlayer, dashboardWalkingStyles[walkingStyle])
                    elseif settingData.optionDataName == "talkingStyle" then
                        local talkingStyle = settingData.customValue or settingData.defaultValue
                        talkingStyle = talkingStyle + 1
                        talkingStyle = (talkingStyle > #dashboardTalkingStyles) and 1 or talkingStyle

                        settingData.customValue = talkingStyle
                        setElementData(localPlayer, "talkingAnim", dashboardTalkingStyles[talkingStyle])
                    elseif settingData.optionDataName == "crosshair" then
                        local crosshairStyle = settingData.customValue or settingData.defaultValue
                        crosshairStyle = crosshairStyle + 1
                        crosshairStyle = (crosshairStyle > 12) and 0 or crosshairStyle

                        settingData.customValue = crosshairStyle
                        setElementData(localPlayer, "crosshairData", {crosshairStyle, 255, 255, 255})
                    end
                end
            end
        end
    end
end

function keyDashboard(key, state)
    if premiumItemBuy then
        return
    end

    if key == "mouse_wheel_down" then
        if dashboardSelectedMenu == "vehicles" then
            if vehicleScrollOffset < #playerVehicles - 15 then
                vehicleScrollOffset = vehicleScrollOffset + 1
            end
        elseif dashboardSelectedMenu == "interiors" then
            if interiorScrollOffset < #playerInteriors - 15 then
                interiorScrollOffset = interiorScrollOffset + 1
            end
        elseif dashboardSelectedMenu == "premiumshop" then
            if premiumCategoryScroll < #premiumShopCategoryItems[premiumCategorySelected] - 13 then
                premiumCategoryScroll = premiumCategoryScroll + 1
            end
        elseif dashboardSelectedMenu == "factions" then
            if dashboardActiveButton then
                local buttonData = split(dashboardActiveButton, ":")

                if buttonData[1] == "selectGroup" then
                    if groupScrollOffset < #playerGroups - 16 then
                        groupScrollOffset = groupScrollOffset + 1
                    end
                elseif buttonData[1] == "selectGroupMember" then
                    if groupMemberScrollOffset < #playerGroupDatas[groupListSelected].members - 15 then
                        groupMemberScrollOffset = groupMemberScrollOffset + 1
                    end
                elseif buttonData[1] == "selectGroupVehicle" then
                    if groupVehicleScrollOffset < #playerGroupDatas[groupListSelected].vehicles - 15 then
                        groupVehicleScrollOffset = groupVehicleScrollOffset + 1
                    end
                elseif buttonData[1] == "selectGroupRank" then
                    if groupRankScrollOffset < #playerGroupDatas[groupListSelected].ranks - 15 then
                        groupRankScrollOffset = groupRankScrollOffset + 1
                    end
                end
            end
        end
    elseif key == "mouse_wheel_up" then
        if dashboardSelectedMenu == "vehicles" then
            vehicleScrollOffset = math.max(vehicleScrollOffset - 1, 0)
        elseif dashboardSelectedMenu == "interiors" then
            interiorScrollOffset = math.max(interiorScrollOffset - 1, 0)
        elseif dashboardSelectedMenu == "premiumshop" then
            premiumCategoryScroll = math.max(premiumCategoryScroll - 1, 0)
        elseif dashboardSelectedMenu == "factions" then
            if dashboardActiveButton then
                local buttonData = split(dashboardActiveButton, ":")

                if buttonData[1] == "selectGroup" then
                    groupScrollOffset = math.max(groupScrollOffset - 1, 0)
                elseif buttonData[1] == "selectGroupMember" then
                    groupMemberScrollOffset = math.max(groupMemberScrollOffset - 1, 0)
                elseif buttonData[1] == "selectGroupVehicle" then
                    groupVehicleScrollOffset = math.max(groupVehicleScrollOffset - 1, 0)
                elseif buttonData[1] == "selectGroupRank" then
                    groupRankScrollOffset = math.max(groupRankScrollOffset - 1, 0)
                end
            end
        end
    end
end

addEvent("tryToClickPremiumButton", true)
addEventHandler("tryToClickPremiumButton", getRootElement(), function(button, state, absX, absY, el)
    if button == "left" and state == "down" then
        if premiumItemBuyButton == el then
            local itemData = premiumShopCategoryItems[premiumCategorySelected][premiumItemBuy]

            if itemData then
                local itemAmount = exports.seal_gui:getInputValue(premiumItemAmountInput)
                triggerServerEvent("buyPremiumItem", localPlayer, premiumCategorySelected, premiumItemBuy, itemAmount)
            end
        end
        
        if premiumItemBuyGui then
            exports.seal_gui:deleteGuiElement(premiumItemBuyGui)
        end
        
        premiumItemBuy = false
        premiumItemBuyGui = false
        premiumItemBuyButton = false
        premiumItemCancelBuyButton = false
        premiumItemAmountInput = false
    end
end)

addEvent("tryToClickSlotButton", true)
addEventHandler("tryToClickSlotButton", getRootElement(), function(button, state, absX, absY, el)
    if button == "left" and state == "down" then
        if slotItemBuyButton == el then
            local slotAmount = exports.seal_gui:getInputValue(slotItemAmountInput)
            triggerServerEvent("buySlot", localPlayer, slotAmount, vehicleBuySlotPrompt, interiorBuySlotPrompt)
        end
        
        if slotBuyGui then
            exports.seal_gui:deleteGuiElement(slotBuyGui)
        end
        
        vehicleBuySlotPrompt = false
        interiorBuySlotPrompt = false
        
        slotBuyGui = false
        slotItemPrice = false
        slotItemAmountInput = false
        slotItemBuyButton = false
        slotItemCancelBuyButton = false
    end
end)

function setDashboardState(state)
    if state then
        dashboardFadeIn = getTickCount()
        dashboardFadeOut = false

        exports.seal_hud:hideHUD()

        for dataName in pairs(dashboardDataNames) do
            dashboardDatas[dataName] = getElementData(localPlayer, dataName) or "N/A"
        end
        dashboardDatas["serial"] = getPlayerSerial(localPlayer)
        dashboardDatas["visibleName"] = dashboardDatas["visibleName"]:gsub("_", " ")

        if dashboardSelectedMenu == "vehicles" then
            triggerServerEvent("requestPlayerVehicles", localPlayer)
        elseif dashboardSelectedMenu == "interiors" then
            playerInteriors = exports.seal_interiors:requestInteriors(localPlayer)

            for i = 1, #playerInteriors do
                local priceType = (playerInteriors[i].data.type == "rentable") and "#ffffffBérelti díj" or "#ffffffEredeti ár"
                local priceUnit = (playerInteriors[i].data.type == "rentable") and "$/hét" or "$"
                playerInteriors[i].price = priceType .. ": " .. dashboardPrimaryColor .. formatNumber(playerInteriors[i].data.price) .. " #ffffff" .. priceUnit         
                
                playerInteriors[i].icon = exports.seal_interiors:getIconByMarkerType(playerInteriors[i].data.type)
                playerInteriors[i].type = interiorTypes[playerInteriors[i].data.type]
                playerInteriors[i].locked = playerInteriors[i].locked == "Y" and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
                playerInteriors[i].editable = playerInteriors[i].editable == "Y" and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
                playerInteriors[i].gameInterior = playerInteriors[i].data.gameInterior
                playerInteriors[i].ownerName = dashboardDatas["visibleName"]
            end
        elseif dashboardSelectedMenu == "admins" then
            refreshAdminList()
        elseif dashboardSelectedMenu == "factions" then
            if groupDescriptionInput then
                exports.seal_gui:deleteGuiElement(groupDescriptionInput)
            end
            groupDescriptionInput = false

            if groupMemberInviteInput then
                exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
            end
            groupMemberInviteInput = false

            if groupRankNameInput then
                exports.seal_gui:deleteGuiElement(groupRankNameInput)
            end
            groupRankNameInput = false

            if groupRankSalaryInput then
                exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
            end
            groupRankSalaryInput = false

            groupRankRenamePrompt = false
            groupRankPayChangePrompt = false
            
            refreshGroupList()
        end

        addEventHandler("onClientRender", root, renderDashboard)
        addEventHandler("onClientClick", root, clickDashboard)
        addEventHandler("onClientKey", root, keyDashboard)
    else
        dashboardFadeIn = false
        dashboardFadeOut = false

        exports.seal_hud:showHUD()

        dashboardDatas = {}
        collectgarbage("collect")
        
        removeEventHandler("onClientRender", root, renderDashboard)
        removeEventHandler("onClientClick", root, clickDashboard)
        removeEventHandler("onClientKey", root, keyDashboard)

        setTimer(function()
            if groupDescriptionInput then
                exports.seal_gui:deleteGuiElement(groupDescriptionInput)
            end
            groupDescriptionInput = false

            if groupMemberInviteInput then
                exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
            end
            groupMemberInviteInput = false
            
            if groupRankNameInput then
                exports.seal_gui:deleteGuiElement(groupRankNameInput)
            end
            groupRankNameInput = false

            if groupRankSalaryInput then
                exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
            end
            groupRankSalaryInput = false
        end, 100, 1)
    end
end

addEventHandler("onClientElementDataChange", localPlayer, function(dataName)
    if dashboardDatas[dataName] then
        dashboardDatas[dataName] = getElementData(localPlayer, dataName) or "N/A"
    end
end)

function refreshAdminList()
    adminListDatas = {
        [1] = {
            {"Adminsegédek", true, false, 99}
        },
        [2] = {
            {"Adminok", true, false, 99}
        },
        [3] = {
            {"FA/SA", true, false, 99}
        },
        [4] = {
            {"Vezetőség", true, false, 99}
        },
    }

    local playerElements = getElementsByType("player")
    for i = 1, #playerElements do
        local playerElement = playerElements[i]

        if playerElement then
            local playerID = getElementData(playerElement, "playerID") or 0
            local adminLevel = getElementData(playerElement, "acc.adminLevel") or 0
            local adminNick = getElementData(playerElement, "acc.adminNick") or 0
            local adminDuty = getElementData(playerElement, "adminDuty") or 0

            if adminLevel > 0 then
                adminTitle = exports.seal_administration:getPlayerAdminTitle(playerElement)
                adminColor = exports.seal_administration:getAdminLevelColor(adminLevel)
            end

            local helperLevel = getElementData(playerElement, "acc.helperLevel") or 0
            local helperNick = getElementData(playerElement, "visibleName") or 0

            if helperLevel > 0 and adminLevel == 0 then
                table.insert(adminListDatas[1], {helperNick, "#ca468cAS", adminDuty, helperLevel, playerID, true})
            elseif adminLevel > 0 and adminLevel <= 5 then
                table.insert(adminListDatas[2], {adminNick, adminColor .. adminTitle, adminDuty, adminLevel, playerID})
            elseif adminLevel > 5 and adminLevel <= 7 then
                table.insert(adminListDatas[3], {adminNick, adminColor .. adminTitle, adminDuty, adminLevel, playerID})
            elseif adminLevel > 7 then
                table.insert(adminListDatas[4], {adminNick, adminColor .. adminTitle, adminDuty, adminLevel, playerID})
            end
        end
    end

    for i = 1, 4 do
        table.sort(adminListDatas[i], function(a, b)
            return a[4] > b[4]
        end)
    end
end

function refreshGroupList()    
    if groupDescriptionInput then
        exports.seal_gui:deleteGuiElement(groupDescriptionInput)
    end

    if groupMemberInviteInput then
        exports.seal_gui:deleteGuiElement(groupMemberInviteInput)
    end

    if groupRankNameInput then
        exports.seal_gui:deleteGuiElement(groupRankNameInput)
    end
    groupRankNameInput = false

    if groupRankSalaryInput then
        exports.seal_gui:deleteGuiElement(groupRankSalaryInput)
    end
    groupRankSalaryInput = false

    groupScrollOffset = 0
    groupMemberScrollOffset = 0

    groupListSelected = false
    playerGroups = {}
    playerGroupDatas = {}

    groupMemberSelected = false
    groupMenuSelected = "groupInformation"
    groupDescriptionInput = false
    groupMemberInviteInput = false
    
    groupMemberKickPrompt = false
    groupMemberInvitePrompt = false

    groupVehicleScrollOffset = 0
    groupVehicleSelected = false

    groupRankScrollOffset = 0
    groupRankSelected = false

    groupRankRenamePrompt = false
    groupRankPayChangePrompt = false

    playerGroups = exports.seal_groups:getPlayerGroups(localPlayer)

    local groupIndex = 0
    for groupId, groupData in pairs(playerGroups) do
        groupIndex = groupIndex + 1

        playerGroupDatas[groupIndex] = {}
        playerGroupDatas[groupIndex].name = exports.seal_groups:getGroupName(groupId)
        playerGroupDatas[groupIndex].id = groupId
        playerGroupDatas[groupIndex].leader = groupData[3] == "Y"
    end

    triggerServerEvent("requestGroupData", localPlayer, playerGroups)
    triggerServerEvent("requestGroups", localPlayer)
end

addEvent("receiveGroupMembers", true)
addEventHandler("receiveGroupMembers", getRootElement(), function(groupDatas, selectedId)
    for groupId, groupData in pairs(groupDatas) do
        local groupIndex = getRightGroupIndex(groupId)
		local groupOnlinePlayers = {}
        local groupInDutyPlayers = {}

		for _, playerElement in pairs(getElementsByType("player")) do
			local characterId = getElementData(playerElement, "char.ID")
            local inDuty = getElementData(playerElement, "inDuty") or false

			if characterId then
				groupOnlinePlayers[characterId] = {
                    playerElement = playerElement,
                    inDuty = inDuty
                }
			end
		end

        if groupIndex then
            playerGroupDatas[groupIndex].vehicles = {}

            for _, vehicleElement in pairs(getElementsByType("vehicle")) do
                local vehicleGroup = getElementData(vehicleElement, "vehicle.group")
    
                if vehicleGroup == groupId then
                    local vehicleModel = getElementModel(vehicleElement)

                    table.insert(playerGroupDatas[groupIndex].vehicles, {
                        vehicleElement = vehicleElement,
                        vehicleModel = vehicleModel,
                        vehicleName = exports.seal_vehiclenames:getCustomVehicleName(vehicleModel),
                        vehicleId = getElementData(vehicleElement, "vehicle.dbID"),
                        vehiclePlate = getVehiclePlateText(vehicleElement):gsub("-", " "),
                        tuningEngine = getElementData(vehicleElement, "vehicle.tuning.Engine") or 0,
                        tuningTurbo = getElementData(vehicleElement, "vehicle.tuning.Turbo") or 0,
                        tuningECU = getElementData(vehicleElement, "vehicle.tuning.ECU") or 0,
                        tuningTransmission = getElementData(vehicleElement, "vehicle.tuning.Transmission") or 0,
                        tuningSuspension = getElementData(vehicleElement, "vehicle.tuning.Suspension") or 0,
                        tuningBrakes = getElementData(vehicleElement, "vehicle.tuning.Brakes") or 0,
                        tuningTires = getElementData(vehicleElement, "vehicle.tuning.Tires") or 0,
                        tuningWeightReduction = getElementData(vehicleElement, "vehicle.tuning.WeightReduction") or 0,
                        eletricVehicle = exports.seal_ev:getChargingPortOffset(vehicleModel)
                    })
                end
            end

            playerGroupDatas[groupIndex].members = {}
            playerGroupDatas[groupIndex].onlineMembers = 0
            playerGroupDatas[groupIndex].inDutyMembers = 0

            for i = 1, #groupData do
                local memberData = groupData[i]

                if memberData then
                    local memberCharacterId = memberData.id
                    local memberName = memberData.characterName
                    local memberRank = memberData.rank
                    local memberLeader = memberData.isLeader == "Y"
                    local memberLastOnline = memberData.lastOnline
                    local memberOnline = false
                    local memberInDuty = false

                    if groupOnlinePlayers[memberCharacterId] then
                        local playerElement = groupOnlinePlayers[memberCharacterId].playerElement

                        memberOnline = playerElement
                        memberName = getElementData(playerElement, "visibleName")
                        memberInDuty = groupOnlinePlayers[memberCharacterId].inDuty
                    end

                    table.insert(playerGroupDatas[groupIndex].members, {
                        characterId = memberCharacterId,
                        name = memberName:gsub("_", " "),
                        rank = memberRank,
                        leader = memberLeader,
                        lastOnline = memberLastOnline,
                        online = memberOnline,
                    })

                    if memberOnline then
                        playerGroupDatas[groupIndex].onlineMembers = playerGroupDatas[groupIndex].onlineMembers + 1
                    end

                    if memberInDuty then
                        playerGroupDatas[groupIndex].inDutyMembers = playerGroupDatas[groupIndex].inDutyMembers + 1
                    end
                end
            end

        end
    end

    if selectedId then
        local playerGroupData = playerGroupDatas[groupListSelected]

        if playerGroupData then
            local groupMemberDatas = playerGroupData.members
    
            for memberId, memberData in pairs(groupMemberDatas) do
                
                if memberData.characterId == selectedId then
                    groupMemberSelected = memberId
                    break
                end
            end
        end
    end
end)

addEvent("receiveGroups", true)
addEventHandler("receiveGroups", getRootElement(), function(groupDatas)
    for groupId, groupData in pairs(groupDatas) do
        local groupIndex = getRightGroupIndex(groupId)

        if groupIndex then
            playerGroupDatas[groupIndex].description = groupData.description
            playerGroupDatas[groupIndex].balance = formatNumber(groupData.balance)
            playerGroupDatas[groupIndex].ranks = groupData.ranks
        end
    end
end)

addEvent("modifyGroupData", true)
addEventHandler("modifyGroupData", getRootElement(), function(groupId, dataType, rankId, data)
    local groupIndex = getRightGroupIndex(groupId)

    if groupIndex then
        if dataType == "rankName" then
            playerGroupDatas[groupIndex].ranks[rankId].name = data
        elseif dataType == "rankPayment" then
            playerGroupDatas[groupIndex].ranks[rankId].pay = tonumber(data)
        elseif dataType == "description" then
            playerGroupDatas[groupIndex].description = data

            if groupDescriptionInput then
                exports.seal_gui:setInputValue(groupDescriptionInput, playerGroupDatas[groupIndex].description)
            end
        elseif dataType == "balance" then
            playerGroupDatas[groupIndex].balance = formatNumber(tonumber(data))
        end
    end
end)

function getRightGroupIndex(groupId)
    for i = 1, #playerGroupDatas do
        if playerGroupDatas[i].id == groupId then
            return i
        end
    end
end

addEvent("gotPlayerVehicles", true)
addEventHandler("gotPlayerVehicles", getRootElement(), function(vehicles)
    if vehicles then
        playerVehicles = {}

        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local validColors = {}

            playerVehicles[i] = {}
            playerVehicles[i].name = exports.seal_vehiclenames:getCustomVehicleName(vehicle.modelId)
            playerVehicles[i].brand = exports.seal_carshop:getVehicleBrandLogo(vehicle.modelId)
            playerVehicles[i].dbID = vehicle.vehicleId
            playerVehicles[i].group = exports.seal_groups:getGroupName(vehicle.group) or "N/A"
            playerVehicles[i].eletricVehicle = exports.seal_ev:getChargingPortOffset(vehicle.modelId)

            for i = 1, 4 do
                local colorName = "color" .. i
                local color = vehicle[colorName]

                if color == "" then
                    color = "ffffff"
                end

                vehicle[colorName] = string.upper(color)
                table.insert(validColors, color)
            end

            local colorDatas = {"Szín 1", "Szín 2", "Szín 3", "Szín 4"}
            for i = 1, 4 do
                local color = validColors[i]
                colorDatas[i] = "#" .. color:gsub("#", "") .. colorDatas[i]
            end
            playerVehicles[i].color = table.concat(colorDatas, ", ")

            playerVehicles[i].modelId = vehicle.modelId
            playerVehicles[i].plate = vehicle.plateText:gsub("-", " ")
            playerVehicles[i].health = vehicle.health / 10 .. "%"
            playerVehicles[i].engine = numberToBoolean[vehicle.engine]
            playerVehicles[i].lights = numberToBoolean[vehicle.lights]
            playerVehicles[i].locked = numberToBoolean[vehicle.locked]
            playerVehicles[i].handbrake = numberToBoolean[vehicle.handBrake]
            playerVehicles[i].impounded = numberToBoolean[vehicle.impounded]

            if playerVehicles[i].eletricVehicle then
                playerVehicles[i].fuel = vehicle.fuel .. " %"
            else
                playerVehicles[i].fuel = vehicle.fuel .. " Liter"
            end

            playerVehicles[i].tuningEngine = tuningName[vehicle.tuningEngine]
            playerVehicles[i].tuningTurbo = tuningName[vehicle.tuningTurbo]
            playerVehicles[i].tuningECU = tuningName[vehicle.tuningECU]
            playerVehicles[i].tuningTransmission = tuningName[vehicle.tuningTransmission]
            playerVehicles[i].tuningTires = tuningName[vehicle.tuningTires]
            playerVehicles[i].tuningBrakes = tuningName[vehicle.tuningBrakes]
            playerVehicles[i].tuningSuspension = tuningName[vehicle.tuningSuspension]
            playerVehicles[i].tuningWeightReduction = tuningName[vehicle.tuningWeightReduction]

            local customWheel = fromJSON(vehicle.customWheel)
            playerVehicles[i].customWheel = customWheel.front and customWheel.front.id == 0 and dashboardRedColor .. "Nem" or dashboardPrimaryColor .. "Igen"

            playerVehicles[i].tuningNitroLevel = math.floor(vehicle.tuningNitroLevel) .. "%"
            playerVehicles[i].tuningSpinners = vehicle.tuningSpinner and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
            playerVehicles[i].tuningAirRide = numberToBoolean[vehicle.tuningAirRide]
            playerVehicles[i].tuningPaintjob = vehicle.tuningPaintjob == -1 and dashboardPrimaryColor .. "Igen" or dashboardRedColor .. "Nem"
            playerVehicles[i].customTurbo = numberToBoolean[vehicle.customTurbo]
            playerVehicles[i].customBackfire = vehicle.backFire ~= 2 and dashboardRedColor .. "Nem" or dashboardPrimaryColor .. "Igen"
            playerVehicles[i].tuningDriveType = vehicle.tuningDriveType == "" and dashboardRedColor .. "Nem" or dashboardPrimaryColor .. "Igen"
            playerVehicles[i].tuningNeon = vehicle.tuningNeon == 0 and dashboardRedColor .. "Nem" or dashboardPrimaryColor .. "Igen"
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    dashboardPrimaryColor = exports.seal_gui:getColorCodeHex("primary")
    dashboardRedColor = exports.seal_gui:getColorCodeHex("red")
    dashboardBlueColor = exports.seal_gui:getColorCodeHex("blue")

    bebasNeueRegular11 = exports.seal_gui:getFont("11/BebasNeueRegular.otf")
    bebasNeueRegular10 = exports.seal_gui:getFont("10/BebasNeueRegular.otf")
    bebasNeueRegular9 = exports.seal_gui:getFont("9/BebasNeueRegular.otf")

    numberToBoolean = {
        [0] = dashboardRedColor .. "Nem",
        [1] = dashboardPrimaryColor .. "Igen",
    }

    if fileExists("dashboard.json") then
        local dashboardFile = fileOpen("dashboard.json")
        local dashboardData = fileRead(dashboardFile, fileGetSize(dashboardFile))
        fileClose(dashboardFile)

        dashboardData = fromJSON(dashboardData)

        if dashboardData then
            local walkingStyle = dashboardData[1]
            triggerServerEvent("setPedWalkingStyle", localPlayer, dashboardWalkingStyles[walkingStyle])
            dashboardSettings[1].customValue = walkingStyle

            local talkingAnim = dashboardData[2]
            setElementData(localPlayer, "talkingAnim", dashboardTalkingStyles[talkingAnim])
            dashboardSettings[2].customValue = talkingAnim

            local fightingStyle = dashboardData[3]
            triggerServerEvent("setPedFightingStyle", localPlayer, dashboardFightningStyles[fightingStyle])
            dashboardSettings[3].customValue = fightingStyle

            setElementData(localPlayer, "crosshairData", {dashboardData[4], 255, 255, 255})
            dashboardSettings[4].customValue = dashboardData[4]

            setFarClipDistance(100 + dashboardData[5])
            dashboardSettings[5].customValue = dashboardData[5]

            exports.seal_dlssao:handleonClientSwitchAO(dashboardData[6])
            dashboardSettings[6].customValue = dashboardData[6]
        end

        dashboardData = nil
        collectgarbage("collect")
    end

    for i = 1, #dashboardFightningStyles do
        local fightingStyle = dashboardFightningStyles[i]
        dashboardFightningStylesEx[i] = fightingStyle
    end
    
    for i = 1, #dashboardWalkingStyles do
        local walkingStyle = dashboardWalkingStyles[i]
        dashboardWalkingStylesEx[i] = walkingStyle
    end

    for i = 1, #dashboardTalkingStyles do
        local talkingStyle = dashboardTalkingStylesEx[i]
        dashboardTalkingStylesEx[i] = talkingStyle
    end
end)

addEventHandler("onClientKey", getRootElement(), function(key, state)
    if key == "home" and state then
        if getElementData(localPlayer, "loggedIn") then
            if not dashboardFadeIn and not dashboardFadeOut and not premiumItemBuy then
                if dashboardAlpha > 0 then
                    dashboardFadeOut = getTickCount()
                    showCursor(false)
                else
                    showCursor(true)
                    setDashboardState(true)
                end
            end
        end
        
        cancelEvent()
        return
    end
    
    if key == "F3" and state then
        if getElementData(localPlayer, "loggedIn") then
            if not dashboardFadeIn and not dashboardFadeOut and not premiumItemBuy then
                if dashboardAlpha > 0 then
                    dashboardFadeOut = getTickCount()
                    showCursor(false)
                else
                    showCursor(true)
                    setDashboardState(true)
                    dashboardSelectedMenu = "factions"
                    groupMenuSelected = "groupInformation"
                end
            end
        end
        
        cancelEvent()
        return
    end
end)


addEventHandler("onClientResourceStop", resourceRoot, function()
    local dashboardData = {}

    for dataName, dataValue in pairs(dashboardSettings) do
        dashboardData[dataName] = dataValue.customValue or dataValue.defaultValue
    end

    local dashboardFile = fileCreate("dashboard.json")
    fileWrite(dashboardFile, toJSON(dashboardData))
    fileClose(dashboardFile)
end)

function processColorSwitchEffect(key, r, g, b, a, effectDuration, effectEasingType)
    local effectData = dashboardColorSwitch[key] or {}

    r = tonumber(r) or 255
    g = tonumber(g) or 255
    b = tonumber(b) or 255
    a = tonumber(a) or 255

    local hexCode = string.format("%x", 0x01000000 * a + 0x010000 * r + 0x0100 * g + b)

    if not effectData[1] then
        effectData = {r, g, b, a, hexCode}
    end

    effectDuration = tonumber(effectDuration) or 500

    if effectData[5] ~= hexCode then
        effectData[5] = hexCode
        effectData[6] = getTickCount()
    end

    if effectData[6] then
        local linearValue = math.min(1, (getTickCount() - effectData[6]) / (tonumber(effectDuration) or 500))
        local easingValue = getEasingValue(linearValue, effectEasingType or "Linear")

        effectData[1] = effectData[1] + (r - effectData[1]) * easingValue
        effectData[2] = effectData[2] + (g - effectData[2]) * easingValue
        effectData[3] = effectData[3] + (b - effectData[3]) * easingValue
        effectData[4] = effectData[4] + (a - effectData[4]) * easingValue

        if linearValue >= 1 then
            effectData[6] = nil
        end
    end

    dashboardColorSwitch[key] = effectData

    return effectData[1], effectData[2], effectData[3], effectData[4]
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function formatNumber(number, sep)
    local sep = " "
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end