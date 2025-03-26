local screenW, screenH = guiGetScreenSize()

local oneSizeW = 400
local oneSizeH = 35

local providerSizeW = 400
local providerSizeH = 490

local providerPosX = screenW / 2 - (providerSizeW / 2)
local providerPosY = screenH / 2 - (providerSizeH / 2)

local providerGui = false
local providerButtons = {}
local providerPed = false

local truckerBlip = false

local haveJob = false
local availableJobs = {
	{"shipping-fast", "Postás", "Szállítsd ki a küldeményeket.", {"Szállítsd ki a #6cb3c9küldeményeket#ffffff.", "#F0E76CMunkajármű#ffffff kéréséhez menj a kis, #F0E76Cteherautó#ffffff jelzéshez."}},
	{"pizza-slice", "Pizzafutár", "A feladatod, hogy szállítsd ki a pizzákat.", {"A feladatod, hogy szállítsd ki a #d75959pizzákat#ffffff.", "Menj a pizzázóhoz, és vedd fel a rendeléseket a főnöködtől, #598ed7Joe#ffffff-tól. (Kattints az NPC-re.)", "#F0E76CMunkajármű#ffffff kéréséhez menj a kis, #F0E76Cteherautó#ffffff jelzéshez."}},
	{"bus", "Buszsofőr (Városi)", "Menj végig a buszmegállókon és szállítsd az utasokat.", {"Menj végig a #6cb3c9buszmegállókon#ffffff és szállítsd az utasokat.", "#F0E76CMunkajármű#ffffff kéréséhez menj a kis, #F0E76Cteherautó#ffffff jelzéshez."}},
}

function createGui()
    if exports.seal_gui:isGuiElementValid(providerGui) then
        exports.seal_gui:deleteGuiElement(providerGui)
    end

    if haveJob then
        local panelW, panelH = 400, 250
        local panelPosX, panelPosY = (screenW - panelW) / 2, (screenH - panelH) / 2
        local panelVisible = true

        panelBg = exports.seal_gui:createGuiElement("window", panelPosX, panelPosY, panelW, panelH)
        exports.seal_gui:setWindowTitle(panelBg, "15/BebasNeueRegular.otf", "SealMTA - Munkaközvetítő")

        local text = exports.seal_gui:createGuiElement("label", 0, -40, panelW, panelH, panelBg)
        exports.seal_gui:setLabelText(text, "Neked már van aktív munkád!")
        exports.seal_gui:setLabelFont(text, "16/BebasNeueRegular.otf")
        exports.seal_gui:setLabelAlignment(text, "center")

        local text = exports.seal_gui:createGuiElement("label", 0, -20, panelW, panelH, panelBg)
        exports.seal_gui:setLabelText(text, "Ha felszeretnél mondani, kattints a gombra!")
        exports.seal_gui:setLabelFont(text, "16/BebasNeueRegular.otf")
        exports.seal_gui:setLabelAlignment(text, "center")

        acceptButton = exports.seal_gui:createGuiElement("button", 5, panelH - 85, panelW - 10, 36, panelBg)
        exports.seal_gui:setGuiBackground(acceptButton, "solid", "primary")
        exports.seal_gui:setGuiHover(acceptButton, "gradient", {"primary", "secondary"}, false, true)
        exports.seal_gui:setButtonFont(acceptButton, "17/BebasNeueBold.otf")
        exports.seal_gui:setClickEvent(acceptButton, "quitJob", true)
        exports.seal_gui:setButtonText(acceptButton, "Felmondás")

        declineButton = exports.seal_gui:createGuiElement("button", 5, panelH - 41, panelW - 10, 36, panelBg)
        exports.seal_gui:setGuiBackground(declineButton, "solid", "red")
        exports.seal_gui:setGuiHover(declineButton, "gradient", {"red", "red-second"}, false, true)
        exports.seal_gui:setButtonFont(declineButton, "17/BebasNeueBold.otf")
        exports.seal_gui:setClickEvent(declineButton, "closePanel", true)
        exports.seal_gui:setButtonText(declineButton, "Mégsem")
    else
        providerGui = exports.seal_gui:createGuiElement("window", providerPosX, providerPosY, providerSizeW, providerSizeH)
        exports.seal_gui:setWindowTitle(providerGui, "15/BebasNeueRegular.otf", "SealMTA - Munkaközvetítő")
        exports.seal_gui:setWindowCloseButton(providerGui, "closePanel")

        for i = 1, 13 do
            local contentPosY = oneSizeH * i

            if availableJobs[i] then
                local button = exports.seal_gui:createGuiElement("button", 0, contentPosY, oneSizeW - 40, oneSizeH, providerGui)
                exports.seal_gui:setGuiBackground(button, "solid", "grey2")
                exports.seal_gui:setGuiHover(button, "gradient", {"grey1", "grey2"}, false, true)
                exports.seal_gui:guiToFront(button)
                exports.seal_gui:guiSetTooltip(button, availableJobs[i][3])
                exports.seal_gui:setClickEvent(button, "applyJob")
                providerButtons[button] = i

                local text = exports.seal_gui:createGuiElement("label", 35, contentPosY, 85, oneSizeH, providerGui)
                exports.seal_gui:setLabelText(text, availableJobs[i][2])
                exports.seal_gui:setLabelFont(text, "14/BebasNeueRegular.otf")
                exports.seal_gui:setLabelAlignment(text, "left")

                local image = exports.seal_gui:createGuiElement("image", 5, contentPosY + 6.5, oneSizeH - 10, oneSizeH - 10, providerGui)
                exports.seal_gui:setImageFile(image, exports.seal_gui:getFaIconFilename(availableJobs[i][1], oneSizeH - 10))
                exports.seal_gui:setImageColor(image, "primary")

                local line = exports.seal_gui:createGuiElement("rectangle", 0, contentPosY, providerSizeW, 1, providerGui)
                exports.seal_gui:setGuiBackground(line, "solid", "grey2")

                local line = exports.seal_gui:createGuiElement("rectangle", 0, contentPosY + 1, providerSizeW, 1, providerGui)
                exports.seal_gui:setGuiBackground(line, "solid", "grey3")
            end
        end
    end
end

addEvent("applyJob", true)
addEventHandler("applyJob", getRootElement(), function(button, state, absX, absY, guiElement)
    if providerButtons[guiElement] then
        triggerServerEvent("changeJobState", localPlayer, providerButtons[guiElement])

        if exports.seal_gui:isGuiElementValid(panelBg) then
            exports.seal_gui:deleteGuiElement(panelBg)
        end

        if exports.seal_gui:isGuiElementValid(providerGui) then
            exports.seal_gui:deleteGuiElement(providerGui)
        end

        showCursor(false)
        setElementFrozen(localPlayer, false)
    end
end)

addEvent("quitJob", true)
addEventHandler("quitJob", getRootElement(),
	function()
		if exports.seal_gui:isGuiElementValid(panelBg) then
			exports.seal_gui:deleteGuiElement(panelBg)
		end

		showCursor(false)
		setElementFrozen(localPlayer, false)
		triggerServerEvent("changeJobState", localPlayer, 0)
	end 
)

addEvent("closePanel", true)
addEventHandler("closePanel", getRootElement(),
	function()
		if exports.seal_gui:isGuiElementValid(panelBg) then
			exports.seal_gui:deleteGuiElement(panelBg)
		end
		if exports.seal_gui:isGuiElementValid(providerGui) then
			exports.seal_gui:deleteGuiElement(providerGui)
		end

		if isElement(providerGui2) then
			destroyElement(providerGui2)
		end

		showCursor(false)
		setElementFrozen(localPlayer, false)
	end 
)

addEvent("informateJobInstructions", true)
addEventHandler("informateJobInstructions", getRootElement(),
	function(jobId)
		if tonumber(jobId) then
			if availableJobs[jobId] then
				for i = 1, #availableJobs[jobId][4] do
					outputChatBox("#4adfbf[SealMTA - " .. availableJobs[jobId][2] .. "]: #ffffff" .. availableJobs[jobId][4][i], 255, 255, 255, true)
				end
			end
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function(dataName, oldValue, newValue)
		if source == localPlayer then
			if dataName == "char.Job" then
				if newValue > 0 then
					triggerEvent("informateJobInstructions", source, newValue)
				end
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		providerPed = createPed(2, 1483.34765625, -1802.3500976562, 17.54686164856, 18.734375, 0)
		setElementData(providerPed, "visibleName", "Nagy Dezső")
		setElementData(providerPed, "invulnerable", true)
		setElementFrozen(providerPed, true)
	end
)

local lastCallTime = 0
local cooldownTime = 3000 

addEventHandler("onClientClick", getRootElement(),
    function(button, state, _, _, _, _, _, clickedElement)
        if button == "left" and state == "down" then
            local currentTime = getTickCount()
            if isElement(clickedElement) and clickedElement == providerPed then
                local pedPosX, pedPosY, pedPosZ = getElementPosition(clickedElement)
                local localPosX, localPosY, localPosZ = getElementPosition(localPlayer)

                if getDistanceBetweenPoints3D(pedPosX, pedPosY, pedPosZ, localPosX, localPosY, localPosZ) < 3 then
                    local localJob = getElementData(localPlayer, "char.Job") or 0

                    if currentTime - lastCallTime < cooldownTime then
                        local remainingTime = (cooldownTime - (currentTime - lastCallTime)) / 1000
                        exports.seal_gui:showInfobox("error", "Várnod kell még vele " .. math.floor(remainingTime) .. " másodpercet!")
                        return
                    end
                    
                    lastCallTime = currentTime

                    if localJob > 0 then
                        haveJob = true
                        createGui()
                    else
                        haveJob = false
                        createGui()
                    end

                    setElementFrozen(localPlayer, true)
                    showCursor(true)
                end
            end
        end
    end
)