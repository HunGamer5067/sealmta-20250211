local minigamePanelWidth = 150 + 20
local minigamePanelHeight = 200 + 20

local minigamePanelPosX = (screenWidth - minigamePanelWidth) / 2
local minigamePanelPosY = (screenHeight - minigamePanelHeight) / 2

local minigameLines = {}
local minigameStarted = false
local minigameLine = 1

function initMinigame()
    if minigameStarted then
        return
    end

    minigameStarted = true
    minigameLine = 1
    
    for i = 1, 4 do
        minigameLines[i] = {}
        minigameLines[i].lineStop = math.random(2, 8) / 10
        minigameLines[i].lineSize = 0
        minigameLines[i].reachedSize = true
    end

    showCursor(true)

    addEventHandler("onClientPreRender", root, minigamePreRender)
    addEventHandler("onClientRender", root, minigameRender)
    addEventHandler("onClientKey", root, minigameKey)
end

function minigamePreRender(delta)
    local selectedLine = minigameLines[minigameLine]

    if selectedLine then
        if selectedLine.reachedSize then
            selectedLine.lineSize = selectedLine.lineSize - delta / 700 * 1

            if selectedLine.lineSize <= 0 then
                selectedLine.lineSize = 0
                selectedLine.reachedSize = false
            end
        else
            selectedLine.lineSize = selectedLine.lineSize + delta / 700 * 1

            if selectedLine.lineSize >= 1 then
                selectedLine.lineSize = 1
                selectedLine.reachedSize = true
            end
        end
    end
end

function minigameRender()
    dxDrawRectangle(minigamePanelPosX, minigamePanelPosY, minigamePanelWidth, minigamePanelHeight, tocolor(26, 27, 31))

    for i = 1, 4 do
        local lineWidth, lineHeight = 30, 200
        local linePosX, linePosY = minigamePanelPosX + 10 + ((i - 1) * (lineWidth + 10)), minigamePanelPosY + 10

        if linePosX and linePosY then
            local lineData = minigameLines[i]

            dxDrawRectangle(linePosX, linePosY, lineWidth, lineHeight, tocolor(35, 39, 42))

            if lineData then
                if lineData.sucessfullStopped then
                    dxDrawRectangle(linePosX, linePosY, lineWidth, lineHeight * lineData.lineSize, tocolor(60, 184, 130, 150))
                    dxDrawRectangle(linePosX - 1, linePosY + (lineHeight * lineData.lineStop) - 20, lineWidth + 2, 20, tocolor(60, 184, 130))
                else
                    dxDrawRectangle(linePosX, linePosY, lineWidth, lineHeight * lineData.lineSize, tocolor(243, 90, 90, 150))
                    dxDrawRectangle(linePosX - 1, linePosY + (lineHeight * lineData.lineStop) - 20, lineWidth + 2, 20, tocolor(243, 90, 90))
                end
            end
        end
    end
end

function minigameKey(key, state)
    if key == "enter" and state then
        if minigameLines[minigameLine] then
            local lineStopPosition = minigamePanelPosY + 10 + (200 * minigameLines[minigameLine].lineStop) - 20
            local lineCurrentPosition = minigamePanelPosY + 10 + (200 * minigameLines[minigameLine].lineSize) - 2

            if lineCurrentPosition >= lineStopPosition and lineCurrentPosition <= lineStopPosition + 25 then
                minigameLines[minigameLine].sucessfullStopped = true
                minigameLines[minigameLine].lineSize = minigameLines[minigameLine].lineStop
            end
        end

        minigameLine = minigameLine + 1

        if minigameLine > 4 then
            local totalSucess = 0
            
            for _, data in pairs(minigameLines) do
                if data.sucessfullStopped then
                    totalSucess = totalSucess + 1
                end
            end

            if totalSucess >= 2 then
				triggerServerEvent("tryToOpenUpElectricalBox", localPlayer)
            end

            minigameStarted = false
            minigameLine = 1

            showCursor(false)

            removeEventHandler("onClientPreRender", root, minigamePreRender)
            removeEventHandler("onClientRender", root, minigameRender)
            removeEventHandler("onClientKey", root, minigameKey)
        end
    end
end