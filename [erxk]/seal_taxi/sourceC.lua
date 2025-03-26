local screenW, screenH = guiGetScreenSize()

local requestCol = false
local pickupBlip = false
local pedCol = nil

local panelState = false
local isPanelOpened = false
local panelBg = false

addEventHandler("onClientResourceStart", resourceRoot,
	function()

	if not isElement(requestCol) then
		requestCol = createColRectangle(requestPosX, requestPosY, 8, 5)
		addEventHandler("onClientColShapeHit", requestCol, colShapeHit)
		addEventHandler("onClientColShapeLeave", requestCol, ColShapeLeave)
	end

	if isElement(pickupBlip) then
		destroyElement(pickupBlip)
		pickupBlip = false
	end

	if getElementData(localPlayer, "inTaxiJob") then
		if not isElement(pickupBlip) then
			startJobBlip()
		end
	end
end)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if isElement(requestCol) then
			destroyElement(requestCol)
		end
	end
)

function renderPanel(panelState)
	if panelBg then
		exports.seal_gui:deleteGuiElement(panelBg)

		panelState = false
		isPanelOpened = false
		panelBg = false
	end

	if isPanelOpened then
		return
	end

	if panelState and not getElementData(localPlayer, "inTaxiJob") then
		panelState = true
		isPanelOpened = true
		local panelW, panelH = 400, 175
		local panelPosX, panelPosY = (screenW - panelW) / 2, (screenH - panelH) / 2

		panelBg = exports.seal_gui:createGuiElement("window", panelPosX, panelPosY, panelW, panelH)
		exports.seal_gui:setWindowTitle(panelBg, "15/BebasNeueRegular.otf", "SealMTA - Taxi")
		exports.seal_gui:setWindowCloseButton(panelBg, "closePanel")

	    local label = exports.seal_gui:createGuiElement("label", 190, 40, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "(Ha felszeretnéd venni a munkát, fogadd el alul)")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "primary")
	    local label = exports.seal_gui:createGuiElement("label", 190, 85, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "Ha elfogadod a munkát a chatboxban")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "grey")
	    local label = exports.seal_gui:createGuiElement("label", 190, 105, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "minden fontos információt megkapsz.")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "grey")

	    acceptButton = exports.seal_gui:createGuiElement("button", 5, panelH - 41, panelW - 10, 36, panelBg)
	    exports.seal_gui:setGuiBackground(acceptButton, "solid", "primary")
	    exports.seal_gui:setGuiHover(acceptButton, "gradient", {"primary", "secondary"}, false, true)
	    exports.seal_gui:setButtonFont(acceptButton, "17/BebasNeueBold.otf")
	    exports.seal_gui:setClickEvent(acceptButton, "acceptClick", true)
	    exports.seal_gui:setButtonText(acceptButton, "Elfogadás")

	elseif panelState and getElementData(localPlayer, "inTaxiJob") then
		local panelW, panelH = 400, 175
		local panelPosX, panelPosY = (screenW - panelW) / 2, (screenH - panelH) / 2

		panelBg = exports.seal_gui:createGuiElement("window", panelPosX, panelPosY, panelW, panelH)
		exports.seal_gui:setWindowTitle(panelBg, "15/BebasNeueRegular.otf", "SealMTA - Taxi")
		exports.seal_gui:setWindowCloseButton(panelBg, "closePanel")

	    local label = exports.seal_gui:createGuiElement("label", 190, 40, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "(Ha leszeretnéd adni a munkát, fogadd el alul)")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "primary")
	    local label = exports.seal_gui:createGuiElement("label", 190, 85, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "Ha leadod a munkát akkor újra")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "grey")
	    local label = exports.seal_gui:createGuiElement("label", 190, 105, 20, 24, panelBg)
	    exports.seal_gui:setLabelText(label, "el kell fogadnod, hogy dolgozhass.")
	    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
	    exports.seal_gui:setLabelColor(label, "grey")

	    acceptButton = exports.seal_gui:createGuiElement("button", 5, panelH - 41, panelW - 10, 36, panelBg)
	    exports.seal_gui:setGuiBackground(acceptButton, "solid", "primary")
	    exports.seal_gui:setGuiHover(acceptButton, "gradient", {"primary", "secondary"}, false, true)
	    exports.seal_gui:setClickEvent(acceptButton, "leaveJob", true)
	    exports.seal_gui:setButtonFont(acceptButton, "17/BebasNeueBold.otf")
	    exports.seal_gui:setButtonText(acceptButton, "Munka leadása")
	end
end

addEvent("acceptClick", true)
addEventHandler("acceptClick", getRootElement(),
	function()
		if panelState then
			acceptClick()
			startJobBlip()
		end

		isPanelOpened = false
	end
)

function startJobBlip()
	if not isElement(pickupBlip) then
		pickupBlip = createBlip(blipPosX, blipPosY, blipPosZ, 51, 0, 255, 255, 255)
		setElementData(pickupBlip, "blipTooltipText", "Munka elkezdése")
	end
end

function startBlipDestroy()
	if isElement(pickupBlip) then
		destroyElement(pickupBlip)
	end

	pickupBlip = false
end

addEvent("closePanel", true)
addEventHandler("closePanel", getRootElement(),
    function()
        if panelState then
        	closePanel()
        end

        isPanelOpened = false
    end
)

function acceptClick()
	triggerServerEvent("onAcceptJob", localPlayer)
	closePanel()
end

function closePanel()
	panelState = false
    if exports.seal_gui:isGuiElementValid(panelBg) then
        exports.seal_gui:deleteGuiElement(panelBg)
    end
    panelBg = false
    isPanelOpened = false
end

addEvent("leaveJob", true)
addEventHandler("leaveJob", getRootElement(),
	function()
		if panelState then
			leaveJob()
			closePanel()
		end
		
		isPanelOpened = false
		if isElement(pickupBlip) then
			startBlipDestroy()
		end
	end
)

function leaveJob()
	triggerServerEvent("onPlayerLeaveJob", localPlayer)
end

addEventHandler("onClientClick", getRootElement(),
    function(mousepanelState, buttonpanelState, _, _, _, _, _, clickedElement)
        if buttonpanelState == "up" then
            if clickedElement then
                local clickedPed = getElementData(clickedElement, "isJobPed")
                local playerX, playerY, playerZ = getElementPosition(localPlayer)
                local pedPosX, pedPosY, pedPosZ = getElementPosition(clickedElement)
                local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, pedPosX, pedPosY, pedPosZ)

                if not panelBg then
	                if distance < 2 and clickedPed then
	                    panelState = true
	                    renderPanel(panelState)
	                end
	            end
            end
        end
    end
)

function generateRequesters()
    if getElementData(localPlayer, "inTaxiJob") then
        if not getElementData(localPlayer, "havePassenger") then
            local requester = taxiRequesters[math.random(#taxiRequesters)]

            local reqX, reqY, reqZ = requester[1], requester[2], requester[3]
            local rotX, rotY, rotZ = requester[4], requester[5], requester[6]
            local destX, destY, destZ = requester[7], requester[8], requester[9]

            local ped = createPed(150, reqX, reqY, reqZ, rotZ)
            setElementData(ped, "visibleName", "Utas")
            pedBlip = createBlip(reqX, reqY, reqZ, 51, 0, 255, 200, 200)
            setElementData(pedBlip, "blipTooltipText", "Utas pozíciója")

            pedCol = createColSphere(reqX, reqY, reqZ, 2.5)
            setElementData(pedCol, "taxiPed", ped)
            setElementData(ped, "taxiDestination", {destX, destY, destZ})
            addEventHandler("onClientColShapeHit", pedCol, onHitRequestedPedCol)

            triggerServerEvent("onPlayerHavePassenger", localPlayer)

            if ped then
                outputChatBox("#fece01[SealMTA - Taxi] #ffffffAz utas pozícióját kijelöltük a térképen, menj el érte és szállítsd el!", 255, 255, 255, true)
                exports.seal_gui:showInfobox("info", "Sikeresen elvállaltad a munkát, menj el az utasért, és szállítsd el!")
            end
        else
        	outputChatBox("#fece01[SealMTA - Taxi]: #ffffffNeked már van egy utasod!", 255, 255, 255, true)
        end
    else
        outputChatBox("#fece01[SealMTA - Taxi]: #ffffffElőször fel kell venned a munkát!", 255, 255, 255, true)
    end
end

function onHitRequestedPedCol(hitElement)
    if hitElement == localPlayer then
        local ped = getElementData(source, "taxiPed")
        if ped then
            local playerVehicle = getPedOccupiedVehicle(localPlayer)
            if playerVehicle then
	            local maxSeats = getVehicleMaxPassengers(playerVehicle)
	            local seatFound = false

	            for seat = 0, maxSeats do
	                if not getVehicleOccupant(playerVehicle, seat) then
	                    seatFound = true
	                    break
	                end
	            end

	            if not seatFound then
	            	outputChatBox("#fece01[SealMTA - Taxi] #ffffffNincs elegendő hely a járműben!", 255, 255, 255, true)
	            	return
	            end

                local destX, destY, destZ = unpack(getElementData(ped, "taxiDestination"))
                
                setElementFrozen(playerVehicle, true)
                exports.seal_controls:toggleControl("all", false)
                destroyElement(source)
                destroyElement(pedBlip)
                startProgressBar()

                setTimer(
                	function()
                	setElementFrozen(playerVehicle, false)
                	exports.seal_controls:toggleControl("all", true)

	                destBlip = createBlip(destX, destY, destZ, 41, 2, 255, 0, 0)
	                setElementData(destBlip, "blipTooltipText", "Szállítási pozíció")
	                destCol = createColSphere(destX, destY, destZ, 2.5)
	                
	                destroyElement(ped)

	                triggerServerEvent("warpPedToVehicle", localPlayer)
	                
	                addEventHandler("onClientColShapeHit", destCol, onHitRequestedDestCol)
                end, 5000, 1)
            end
        end
    end
end

function onHitRequestedDestCol(hitElement)
    if hitElement == localPlayer then
		
		local playerVehicle = getPedOccupiedVehicle(localPlayer)
        
        if playerVehicle then
	    	destroyElement(destCol)
	    	destroyElement(destBlip)
	        triggerServerEvent("onClientHitDestCol", localPlayer)
	    end
    end
end

function colShapeHit(element, matchDimension)
    if (element == localPlayer) then
        triggerEvent("sendColHitToServer", element, true)

        local playerVeh = getPedOccupiedVehicle(element)

        if playerVeh then
            generateRequesters()
        end
    end
end

function ColShapeLeave(element, matchDimension)
	if (element == localPlayer) then
		triggerEvent("sendColLeaveToServer", element, false)
	end
end

addEvent("sendColHitToServer", true)
addEventHandler("sendColHitToServer", getRootElement(),
	function(panelState)
		triggerServerEvent("requestColHit", localPlayer, panelState)
	end
)

addEvent("sendColLeaveToServer", true)
addEventHandler("sendColLeaveToServer", getRootElement(),
	function(panelState)
		triggerServerEvent("requestColLeave", localPlayer, panelState)
	end
)

function getVehicleSpeed(currentElement)
	if isElement(currentElement) then
		local x, y, z = getElementVelocity(currentElement)
	  	local speed = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
		local speed = speed * 180 * 1.1

	  	return speed
	end
	
	return 0
end

local progress = 0
local progressBarWidth = 300
local progressBarHeight = 25
local screenWidth, screenHeight = guiGetScreenSize()
local progressBarX = screenWidth / 2 - progressBarWidth / 2
local progressBarY = screenHeight - progressBarHeight - 75
local isProgressActive = false
local startTime
local duration = 5000

function startProgressBar()
    progress = 0
    startTime = getTickCount()
    isProgressActive = true
    addEventHandler("onClientRender", root, renderProgressBar)
end

function renderProgressBar()
	local BebasFont = exports.seal_gui:getFont("8/BebasNeueBold.otf")

    if isProgressActive then
        local now = getTickCount()
        local elapsedTime = now - startTime
        local currentProgress = math.min(elapsedTime / duration, 1)
        progress = currentProgress * progressBarWidth

        dxDrawRectangle(progressBarX, progressBarY, progressBarWidth, progressBarHeight, tocolor(26, 27, 31, 180))
        dxDrawRectangle(progressBarX, progressBarY, progress, progressBarHeight, tocolor(204, 164, 30, 200))
        dxDrawText(math.floor(currentProgress * 100) .. "%", progressBarX + 15, progressBarY, progressBarX + progressBarWidth, progressBarY + progressBarHeight, tocolor(255, 255, 255, 255), 1, BebasFont, "center", "center")

        if currentProgress >= 1 then
            isProgressActive = false
            removeEventHandler("onClientRender", root, renderProgressBar)
        end
    end
end