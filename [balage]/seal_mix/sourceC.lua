local screenX, screenY = guiGetScreenSize()

local copmetetionDatas = {}

local mixPanelWidth = 1110
local mixPanelHeight = 560

local mixPanelPosX = screenX / 2 - mixPanelWidth / 2
local mixPanelPosY = screenY / 2 - mixPanelHeight / 2

local mixPanelFadeIn = false
local mixPanelFadeOut = false

local mixPanelFadeTime = 500
local mixPanelFadeAlpha = 0

local mixPanelSelectedMenu = "liveMatches"
local mixPanelMenus = {
    {
        dataName = "upcomingMatches",
        titleName = "Következik"
    },

    {
        dataName = "liveMatches",
        titleName = "Élőben"
    },

    {
        dataName = "activeBets",
        titleName = "Aktív fogadások"
    },
}

local mixPanelSelectedSubMenu = 1
local mixPanelSubMenus = {
    {
        dataName = 1,
        titleName = "Nemzeti Bajnokság I"
    },

    {
        dataName = 2,
        titleName = "Nemzeti Bajnokság II"
    }
}

local mixPanelColorSwitch = {}
local mixPanelActiveButton = false

local matchScrollOffset = 0

local mixPanelSelectedMatch = false
local mixPanelSelectedOdd = false

local mixBetWindow = false
local mixPanelState = false

local oddTitles = {
    [1] = "Hazai",
    [3] = "Idegen",
    [2] = "Döntetlen"
}

local mixPedElement = createPed(1, 1180.4428710938, -1490.5679931641, 22.79993057251)
setElementFrozen(mixPedElement, true)
setElementData(mixPedElement, "visibleName", "Sport Jenő")
setElementData(mixPedElement, "pedNameType", "Sportfogadás")
setElementData(mixPedElement, "invulnerable", true)
setElementRotation(mixPedElement, 0, 0, 90)

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button == "left" and state == "down" then
        if clickedElement and clickedElement == mixPedElement then
            openMixPanel()
        end
    end
end)

function openMixPanel()
    if mixPanelFadeIn or mixPanelFadeOut or mixPanelState then
        return
    end

    mixPanelFadeAlpha = 0
    matchScrollOffset = 0

    mixPanelFadeIn = getTickCount()
    mixPanelFadeOut = false

    mixPanelState = true
    exports.seal_hud:hideHUD()

    mixPanelSelectedMenu = "activeBets"
    triggerServerEvent("requestActiveBets", localPlayer)

    addEventHandler("onClientRender", root, renderMixPanel)
    addEventHandler("onClientClick", root, clickMixPanel)
    addEventHandler("onClientKey", root, keyMixPanel)
end

addEvent("receiveUpcomingMatches", true)
addEventHandler("receiveUpcomingMatches", getRootElement(), function(data, sub)
    mixPanelSelectedMenu = "upcomingMatches"
    mixPanelSelectedSubMenu = sub
    matchScrollOffset = 0
    copmetetionDatas = data
end)

addEvent("receiveLiveMatches", true)
addEventHandler("receiveLiveMatches", getRootElement(), function(data, sub)
    mixPanelSelectedMenu = "liveMatches"
    mixPanelSelectedSubMenu = sub
    matchScrollOffset = 0
    copmetetionDatas = data
end)

addEvent("receiveActiveBets", true)
addEventHandler("receiveActiveBets", getRootElement(), function(data)
    mixPanelSelectedMenu = "activeBets"
    matchScrollOffset = 0
    copmetetionDatas = data
end)

local grey1 = false
local grey2 = false
local grey3 = false
local blue = false
local red = false

function refreshGuiColors()
    menuFont = exports.seal_gui:getFont("15/BebasNeueRegular.otf")
    menuFontScale = exports.seal_gui:getFontScale("15/BebasNeueRegular.otf")

    matchFont = exports.seal_gui:getFont("17/BebasNeueBold.otf")
    matchFontScale = exports.seal_gui:getFontScale("17/BebasNeueBold.otf")

	grey1 = exports.seal_gui:getColorCode("grey1")
	grey2 = exports.seal_gui:getColorCode("grey2")
	grey3 = exports.seal_gui:getColorCode("grey3")
    blue = exports.seal_gui:getColorCode("blue")
    red = exports.seal_gui:getColorCode("red")
end
addEventHandler("onGuiRefreshColors", localPlayer, refreshGuiColors)
addEventHandler("onClientResourceStart", resourceRoot, refreshGuiColors)

function renderMixPanel()
    mixPanelButtons = {}

    if mixBetWindow then
        return
    end

    if mixPanelFadeIn then
        local now = getTickCount()
        local elapsedTime = now - mixPanelFadeIn
        
        mixPanelFadeAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime / mixPanelFadeTime, "Linear")
        
        if elapsedTime >= mixPanelFadeTime then
            mixPanelFadeIn = false
        end
    end

    if mixPanelFadeOut then
        local now = getTickCount()
        local elapsedTime = now - mixPanelFadeOut
        
        mixPanelFadeAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, elapsedTime / mixPanelFadeTime, "Linear")

        if elapsedTime >= mixPanelFadeTime then
            mixPanelFadeOut = false
            mixPanelFadeIn = false

            matchScrollOffset = 0
            mixPanelState = false
            copmetetionDatas = {}

            exports.seal_hud:showHUD()

            removeEventHandler("onClientRender", root, renderMixPanel)
            removeEventHandler("onClientClick", root, clickMixPanel)
            removeEventHandler("onClientKey", root, keyMixPanel)
        end
    end

    dxDrawRectangle(mixPanelPosX, mixPanelPosY, mixPanelWidth, mixPanelHeight, tocolor(grey1[1], grey1[2], grey1[3], 255 * mixPanelFadeAlpha))
    dxDrawRectangle(mixPanelPosX, mixPanelPosY, mixPanelWidth, 40, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))
    dxDrawText("SealMTA - Sportfogadás", mixPanelPosX + 5, mixPanelPosY, mixPanelPosX + 5 + mixPanelWidth, mixPanelPosY + 40, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "left", "center")

    if mixPanelActiveButton == "closeMixPanel" then
        closeButtonColorA, closeButtonColorR, closeButtonColorG, closeButtonColorA = processColorSwitchEffect("closeMixPanel", red[1], red[2], red[3], 255 * mixPanelFadeAlpha)
    else
        closeButtonColorA, closeButtonColorR, closeButtonColorG, closeButtonColorA = processColorSwitchEffect("closeMixPanel", 255, 255, 255, 255 * mixPanelFadeAlpha)
    end
    mixPanelButtons["closeMixPanel"] = {mixPanelPosX + mixPanelWidth - 35, mixPanelPosY + 5, 30, 30}
    dxDrawText("X", mixPanelPosX + mixPanelWidth - 35, mixPanelPosY + 5, mixPanelPosX + mixPanelWidth - 5, mixPanelPosY + 35, tocolor(closeButtonColorA, closeButtonColorR, closeButtonColorG, closeButtonColorA), menuFontScale * 1.3, menuFont, "center", "center")
    
    for i = 1, #mixPanelMenus do
        local menuDataName = "selectPanel:" .. mixPanelMenus[i].dataName
        local menuTitleName = mixPanelMenus[i].titleName

        local menuWidth = 150
        local menuHeight = 30

        local menuPosX = mixPanelPosX + mixPanelWidth - 35 - (menuWidth + 5) * i
        local menuPosY = mixPanelPosY + 5

        if mixPanelActiveButton == menuDataName or mixPanelSelectedMenu == mixPanelMenus[i].dataName then
            menuButtonColorR, menuButtonColorG, menuButtonColorB, menuButtonColorA = processColorSwitchEffect(menuDataName, blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha)
        else
            menuButtonColorR, menuButtonColorG, menuButtonColorB, menuButtonColorA = processColorSwitchEffect(menuDataName, grey3[1], grey3[2], grey3[3], 255 * mixPanelFadeAlpha)
        end

        dxDrawRectangle(menuPosX, menuPosY, menuWidth, menuHeight, tocolor(menuButtonColorR, menuButtonColorG, menuButtonColorB, menuButtonColorA))
        dxDrawText(menuTitleName, menuPosX, menuPosY, menuPosX + menuWidth, menuPosY + menuHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "center")
        mixPanelButtons[menuDataName] = {menuPosX, menuPosY, menuWidth, menuHeight}
    end

    if mixPanelSelectedMenu == "upcomingMatches" then
        local subMenuWidth = 220
        local subMenuHeight = mixPanelHeight - 50

        local subMenuPosX = mixPanelPosX + 5
        local subMenuPosY = mixPanelPosY + 45

        dxDrawRectangle(subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

        for i = 1, #mixPanelSubMenus do
            local subMenuDataName = "selectSubMenu:" .. mixPanelSubMenus[i].dataName
            local subMenuTitleName = mixPanelSubMenus[i].titleName

            local subMenuWidth = subMenuWidth
            local subMenuHeight = 35

            local subMenuPosX = mixPanelPosX + 5
            local subMenuPosY = mixPanelPosY + 45 + subMenuHeight * (i - 1)

            if mixPanelActiveButton == subMenuDataName or mixPanelSelectedSubMenu == mixPanelSubMenus[i].dataName then
                subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA = processColorSwitchEffect(subMenuDataName, blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha)
            else
                subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA = processColorSwitchEffect(subMenuDataName, grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha)
            end

            dxDrawRectangle(subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight, tocolor(subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA))
            dxDrawText(subMenuTitleName, subMenuPosX, subMenuPosY, subMenuPosX + subMenuWidth, subMenuPosY + subMenuHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "center")
            mixPanelButtons[subMenuDataName] = {subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight}
        end

        dxDrawRectangle(subMenuPosX + mixPanelWidth - 15, subMenuPosY, 5, mixPanelHeight - 53, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

        if #copmetetionDatas > 8 then
            local scrollWidth = 5
            local scrollHeight = (8 / #copmetetionDatas) * (mixPanelHeight - 53)

            local scrollPosX = mixPanelPosX + mixPanelWidth - 10
            local scrollPosY = subMenuPosY + (matchScrollOffset / (#copmetetionDatas - 8)) * (mixPanelHeight - 53 - scrollHeight)

            dxDrawRectangle(scrollPosX, scrollPosY, scrollWidth, scrollHeight, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        else
            dxDrawRectangle(subMenuPosX + mixPanelWidth - 15, subMenuPosY, 5, mixPanelHeight - 53, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        end

        if copmetetionDatas then
            for i = 0, 7 do
                local matchIndex = (i + 1) + matchScrollOffset
                
                local matchWidth = 430
                local matchHeight = 123

                local matchPosX = mixPanelPosX + 230 + ((matchWidth + 5) * (i % 2))
                local matchPosY = mixPanelPosY + 45 + ((matchHeight + 5) * math.floor(i / 2))
        
                dxDrawRectangle(matchPosX, matchPosY, matchWidth, matchHeight, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

                if copmetetionDatas[matchIndex] then
                    local matchData = copmetetionDatas[matchIndex]
                    
                    if matchData then
                        dxDrawText(matchData.home_name .. " - " .. matchData.away_name, matchPosX, matchPosY, matchPosX + matchWidth, matchPosY + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), matchFontScale, matchFont, "center", "top")
                        dxDrawText(matchData.date .. " " .. matchData.time .. " | " .. matchData.location, matchPosX, matchPosY + 30, matchPosX + matchWidth, matchPosY + 30 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale * 0.95, menuFont, "center", "top")
                    
                        for j = 1, 3 do
                            local oddsWidth = 137
                            local oddsHeight = 35
        
                            local oddsPosX = matchPosX + 5 + (oddsWidth + 5) * (j - 1)
                            local oddsPosY = matchPosY + 83

                            local oddsText = oddTitles[j]

                            if matchData.odds[j] then
                                oddsText = oddTitles[j] .. " (" .. math.round(matchData.odds[j], 2) .. "x" .. ")"
                                mixPanelButtons["odds:" .. matchIndex .. ":" .. j] = {oddsPosX, oddsPosY, oddsWidth, oddsHeight}
                            end

                            if mixPanelActiveButton == "odds:" .. matchIndex .. ":" .. j then
                                oddsButtonColorR, oddsButtonColorG, oddsButtonColorB, oddsButtonColorA = processColorSwitchEffect("odds:" .. matchIndex .. ":" .. j, blue[1], blue[2], blue[3], 200 * mixPanelFadeAlpha)
                            else
                                oddsButtonColorR, oddsButtonColorG, oddsButtonColorB, oddsButtonColorA = processColorSwitchEffect("odds:" .. matchIndex .. ":" .. j, grey3[1], grey3[2], grey3[3], 255 * mixPanelFadeAlpha)
                            end

                            dxDrawRectangle(oddsPosX, oddsPosY, oddsWidth, oddsHeight, tocolor(oddsButtonColorR, oddsButtonColorG, oddsButtonColorB, oddsButtonColorA))
                            dxDrawText(oddsText, oddsPosX, oddsPosY, oddsPosX + oddsWidth, oddsPosY + oddsHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "center")
                        end
                    end
                end
            end
        end
    elseif mixPanelSelectedMenu == "liveMatches" then
        local subMenuWidth = 220
        local subMenuHeight = mixPanelHeight - 50

        local subMenuPosX = mixPanelPosX + 5
        local subMenuPosY = mixPanelPosY + 45

        dxDrawRectangle(subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

        for i = 1, #mixPanelSubMenus do
            local subMenuDataName = "selectSubMenu:" .. mixPanelSubMenus[i].dataName
            local subMenuTitleName = mixPanelSubMenus[i].titleName

            local subMenuWidth = subMenuWidth
            local subMenuHeight = 35

            local subMenuPosX = mixPanelPosX + 5
            local subMenuPosY = mixPanelPosY + 45 + subMenuHeight * (i - 1)
            if mixPanelActiveButton == subMenuDataName or mixPanelSelectedSubMenu == mixPanelSubMenus[i].dataName then
                subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA = processColorSwitchEffect(subMenuDataName, blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha)
            else
                subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA = processColorSwitchEffect(subMenuDataName, grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha)
            end

            dxDrawRectangle(subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight, tocolor(subMenuButtonColorR, subMenuButtonColorG, subMenuButtonColorB, subMenuButtonColorA))
            dxDrawText(subMenuTitleName, subMenuPosX, subMenuPosY, subMenuPosX + subMenuWidth, subMenuPosY + subMenuHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "center")
            mixPanelButtons[subMenuDataName] = {subMenuPosX, subMenuPosY, subMenuWidth, subMenuHeight}
        end

        dxDrawRectangle(subMenuPosX + mixPanelWidth - 15, subMenuPosY, 5, mixPanelHeight - 53, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

        if #copmetetionDatas > 8 then
            local scrollWidth = 5
            local scrollHeight = (8 / #copmetetionDatas) * (mixPanelHeight - 53)

            local scrollPosX = mixPanelPosX + mixPanelWidth - 10
            local scrollPosY = subMenuPosY + (matchScrollOffset / (#copmetetionDatas - 8)) * (mixPanelHeight - 53 - scrollHeight)

            dxDrawRectangle(scrollPosX, scrollPosY, scrollWidth, scrollHeight, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        else
            dxDrawRectangle(subMenuPosX + mixPanelWidth - 15, subMenuPosY, 5, mixPanelHeight - 53, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        end
        
        if copmetetionDatas then
            for i = 0, 7 do
                local matchIndex = (i + 1) + matchScrollOffset
                
                local matchWidth = 430
                local matchHeight = 123

                local matchPosX = mixPanelPosX + 230 + ((matchWidth + 5) * (i % 2))
                local matchPosY = mixPanelPosY + 45 + ((matchHeight + 5) * math.floor(i / 2))
        
                dxDrawRectangle(matchPosX, matchPosY, matchWidth, matchHeight, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

                if copmetetionDatas[matchIndex] then
                    local matchData = copmetetionDatas[matchIndex]
                    dxDrawText(matchData.home_name .. " - " .. matchData.away_name, matchPosX, matchPosY, matchPosX + matchWidth, matchPosY + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), matchFontScale, matchFont, "center", "top")
                    
                    if matchData.status == "IN PLAY" or matchData.status == "ADDED TIME" then
                        dxDrawText("Játékban: #319ad7" .. matchData.time .. " perc", matchPosX, matchPosY + 30, matchPosX + matchWidth, matchPosY + 30 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    elseif matchData.status == "HALF TIME BREAK" then
                        dxDrawText("Félidő", matchPosX, matchPosY + 30, matchPosX + matchWidth, matchPosY + 30 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    elseif matchData.status == "NOT STARTED" then
                        dxDrawText("Kezdőrúgás: #319ad7" .. matchData.scheduled .. "", matchPosX, matchPosY + 30, matchPosX + matchWidth, matchPosY + 30 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    elseif matchData.status == "FINISHED" then
                        dxDrawText("Játék vége", matchPosX, matchPosY + 30, matchPosX + matchWidth, matchPosY + 30 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    end

                    if matchData.half_time_score and matchData.half_time_score ~= "" then
                        dxDrawText("Félidei állás: #319ad7" .. matchData.half_time_score, matchPosX, matchPosY + 60, matchPosX + matchWidth, matchPosY + 60 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    else
                        dxDrawText("Félidei állás: #319ad7? - ?", matchPosX, matchPosY + 60, matchPosX + matchWidth, matchPosY + 60 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                    end

                    if matchData.score then
                        if matchData.status == "FINISHED" then
                            dxDrawText("Végeredmény: #319ad7" .. matchData.score, matchPosX, matchPosY + 85, matchPosX + matchWidth, matchPosY + 85 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                        else
                            dxDrawText("Jelenlegi állás: #319ad7" .. matchData.score, matchPosX, matchPosY + 85, matchPosX + matchWidth, matchPosY + 85 + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "center", "top", false, false, false, true)
                        end
                    end
                end
            end
        end
    elseif mixPanelSelectedMenu == "activeBets" then
        for i = 1, 12 do
            local competetionIndex = i + matchScrollOffset
            local copmetetionData = copmetetionDatas[competetionIndex]

            local matchWidth = mixPanelWidth - 20
            local matchHeight = (mixPanelHeight - 105) / 12

            local matchPosX = mixPanelPosX + 5
            local matchPosY = mixPanelPosY + 45 + ((matchHeight + 5) * (i - 1))

            dxDrawRectangle(matchPosX, matchPosY, matchWidth, matchHeight, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))
        
            if copmetetionData then
                dxDrawText(copmetetionData.teams[1] .. " - " .. copmetetionData.teams[2], matchPosX + 5, matchPosY, matchPosX + 5 + matchWidth, matchPosY + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "left", "center")
                dxDrawText("Fogadás: #319ad7" .. oddTitles[copmetetionData.team] ..  " #ffffffSzorzó: #319ad7" .. math.round(copmetetionData.odds, 2) .. "x #ffffffTét: #3cb882" .. copmetetionData.amount .. "$ #ffffffVárható nyeremény: #3cb882" .. math.floor(copmetetionData.odds * copmetetionData.amount) .. "$", matchPosX - 5, matchPosY, matchPosX - 5 + matchWidth, matchPosY + matchHeight, tocolor(255, 255, 255, 255 * mixPanelFadeAlpha), menuFontScale, menuFont, "right", "center", false, false, false, true)
            end
        end

        dxDrawRectangle(mixPanelPosX + mixPanelWidth - 10, mixPanelPosY + 45, 5, mixPanelHeight - 50, tocolor(grey2[1], grey2[2], grey2[3], 255 * mixPanelFadeAlpha))

        if #copmetetionDatas > 12 then
            local scrollWidth = 5
            local scrollHeight = (12 / #copmetetionDatas) * (mixPanelHeight - 50)

            local scrollPosX = mixPanelPosX + mixPanelWidth - 10
            local scrollPosY = mixPanelPosY + 45 + (matchScrollOffset / (#copmetetionDatas - 12)) * (mixPanelHeight - 50 - scrollHeight)

            dxDrawRectangle(scrollPosX, scrollPosY, scrollWidth, scrollHeight, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        else
            dxDrawRectangle(mixPanelPosX + mixPanelWidth - 10, mixPanelPosY + 45, 5, mixPanelHeight - 50, tocolor(blue[1], blue[2], blue[3], 255 * mixPanelFadeAlpha))
        end
    end

    -- ** Button handler
    mixPanelActiveButton = false

    if isCursorShowing() then
        for buttonName, buttonPosition in pairs(mixPanelButtons) do
            if isMouseInPosition(buttonPosition[1], buttonPosition[2], buttonPosition[3], buttonPosition[4]) then
                mixPanelActiveButton = buttonName
                break
            end
        end
    end
end

function clickMixPanel(button, state)
    if mixBetWindow then
        return
    end

    if mixPanelActiveButton and state == "down" then
        local buttonDatas = split(mixPanelActiveButton, ":")

        if mixPanelActiveButton == "closeMixPanel" then
            mixPanelFadeOut = getTickCount()
        elseif buttonDatas[1] == "selectPanel" then
            if mixPanelSelectedMenu ~= buttonDatas[2] then
                if buttonDatas[2] == "upcomingMatches" then
                    triggerServerEvent("requestUpcomingMatches", localPlayer, mixPanelSelectedSubMenu)
                elseif buttonDatas[2] == "liveMatches" then
                    triggerServerEvent("requestLiveMatches", localPlayer, mixPanelSelectedSubMenu)
                elseif buttonDatas[2] == "activeBets" then
                    triggerServerEvent("requestActiveBets", localPlayer)
                end
            end
        elseif buttonDatas[1] == "selectSubMenu" then
            if mixPanelSelectedSubMenu ~= tonumber(buttonDatas[2]) then
                if mixPanelSelectedMenu == "upcomingMatches" then
                    triggerServerEvent("requestUpcomingMatches", localPlayer, tonumber(buttonDatas[2]))
                elseif mixPanelSelectedMenu == "liveMatches" then
                    triggerServerEvent("requestLiveMatches", localPlayer, tonumber(buttonDatas[2]))
                elseif mixPanelSelectedMenu == "activeBets" then
                    triggerServerEvent("requestActiveBets", localPlayer)
                end
            end
        elseif buttonDatas[1] == "odds" then
            mixPanelSelectedMatch = tonumber(buttonDatas[2])
            mixPanelSelectedOdd = tonumber(buttonDatas[3])

            if copmetetionDatas[mixPanelSelectedMatch] then
                local matchData = copmetetionDatas[mixPanelSelectedMatch]

                if matchData.odds[mixPanelSelectedOdd] then
                    createBetWindow()
                    mixPanelActiveButton = false
                end
            end
        end
    end
end

function keyMixPanel(button, state)
    if mixBetWindow then
        return
    end

    if button == "mouse_wheel_down" then
        if mixPanelSelectedMenu == "activeBets" then
            if matchScrollOffset < #copmetetionDatas - 12 then
                matchScrollOffset = matchScrollOffset + 1
            end
        else
            if matchScrollOffset < #copmetetionDatas - 8 then
                matchScrollOffset = matchScrollOffset + 2
            end
        end
    elseif button == "mouse_wheel_up" then
        if mixPanelSelectedMenu == "activeBets" then
            matchScrollOffset = math.max(matchScrollOffset - 1, 0)
        else
            matchScrollOffset = math.max(matchScrollOffset - 2, 0)
        end
    end
end

function createBetWindow()
    local betWindowSizeW = 450
    local betWindowSizeH = 180
    
    local betWindowPosX = screenX / 2 - (betWindowSizeW / 2)
    local betWindowPosY = screenY / 2 - (betWindowSizeH / 2)

    mixBetWindow = exports.seal_gui:createGuiElement("window", betWindowPosX, betWindowPosY, betWindowSizeW, betWindowSizeH)
    exports.seal_gui:setWindowTitle(mixBetWindow, "15/BebasNeueRegular.otf", "SealMTA - Sportfogadás")
    exports.seal_gui:setWindowCloseButton(mixBetWindow, "closeBetWindow")

    local betData = copmetetionDatas[mixPanelSelectedMatch]
    local betTitle = betData.home_name .. " - " .. betData.away_name

    local label = exports.seal_gui:createGuiElement("label", 0, 42, betWindowSizeW, betWindowSizeH, mixBetWindow)
    exports.seal_gui:setLabelText(label, betTitle)
    exports.seal_gui:setLabelFont(label, "16/BebasNeueRegular.otf")
    exports.seal_gui:setLabelAlignment(label, "center", "top")

    local label = exports.seal_gui:createGuiElement("label", 0, 70, betWindowSizeW, betWindowSizeH, mixBetWindow)
    exports.seal_gui:setLabelText(label, "Szorzó: #319ad7" .. math.round(betData.odds[mixPanelSelectedOdd], 2) .. "x")
    exports.seal_gui:setLabelFont(label, "15/BebasNeueRegular.otf")
    exports.seal_gui:setLabelAlignment(label, "center", "top")

    betAmountInput = exports.seal_gui:createGuiElement("input", 5, betWindowSizeH - 80, betWindowSizeW - 10, 35, mixBetWindow)
    exports.seal_gui:setInputPlaceholder(betAmountInput, "Mennyiség")
    exports.seal_gui:setInputIcon(betAmountInput, "cubes")
    exports.seal_gui:setInputMaxLength(betAmountInput, 12)
    exports.seal_gui:setInputNumberOnly(betAmountInput, true)

    betAmountButton = exports.seal_gui:createGuiElement("button", 5, betWindowSizeH - 40, betWindowSizeW - 10, 35, mixBetWindow)
    exports.seal_gui:setGuiBackground(betAmountButton, "solid", "blue")
    exports.seal_gui:setGuiHover(betAmountButton, "gradient", {"blue", "blue-second"}, false, true)
    exports.seal_gui:setButtonFont(betAmountButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setClickEvent(betAmountButton, "tryToClickBetButton")
    exports.seal_gui:setButtonText(betAmountButton, "Tét megerősítése")
end

addEvent("tryToClickBetButton", true)
addEventHandler("tryToClickBetButton", getRootElement(), function()
    local betAmount = exports.seal_gui:getInputValue(betAmountInput) or 0

    if tonumber(betAmount) then
        local betData = copmetetionDatas[mixPanelSelectedMatch]

        if betData then
            triggerServerEvent("tryToAddBetForMatch", localPlayer, {betData.home_name, betData.away_name}, mixPanelSelectedOdd, tonumber(betAmount), math.round(betData.odds[mixPanelSelectedOdd], 2))

            if mixBetWindow then
                exports.seal_gui:deleteGuiElement(mixBetWindow)
                mixBetWindow = false
            end

            betAmountInput = false
            betAmountButton = false
        end
    end
end)

addEvent("closeBetWindow", true)
addEventHandler("closeBetWindow", getRootElement(), function()
    if mixBetWindow then
        exports.seal_gui:deleteGuiElement(mixBetWindow)
        mixBetWindow = false
    end

    betAmountInput = false
    betAmountButton = false
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function processColorSwitchEffect(key, r, g, b, a, effectDuration, effectEasingType)
    local effectData = mixPanelColorSwitch[key] or {}

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

    mixPanelColorSwitch[key] = effectData

    return effectData[1], effectData[2], effectData[3], effectData[4]
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end