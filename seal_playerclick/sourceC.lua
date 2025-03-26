pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));end)
local screenX, screenY = guiGetScreenSize()

local responsiveMultipler = 1

local responsiveMultipler = exports.seal_hud:getResponsiveMultipler()

function respc(x)
	return math.ceil(x * responsiveMultipler)
end

function createFonts()
	destroyFonts()
	Rubik = dxCreateFont("files/Rubik.ttf", respc(11), false, "proof")
end

function destroyFonts()
	if isElement(Rubik) then
		destroyElement(Rubik)
	end
end

local enabledButtons = 0

local bulletDamages = false

local canOperate = false
local canStitch = false

local renderDamageData = {
    sizeX = respc(300),
    sizeY = respc(50)
}

local bulletLocation = {
	[3] = "törzsben",
	[4] = "medencében",
	[5] = "bal kézben",
	[6] = "jobb kézben",
	[7] = "bal lábban",
	[8] = "jobb lábban",
	[9] = "fejben"
}

local surfaceLocation = {
	[3] = "törzsön",
	[4] = "medencén",
	[5] = "bal kézen",
	[6] = "jobb kézen",
	[7] = "bal lábon",
	[8] = "jobb lábon",
	[9] = "fejen"
}

local bulletOperation = {
	[3] = "törzséből",
	[4] = "medencéjéből",
	[5] = "bal kezéből",
	[6] = "jobb kezéből",
	[7] = "bal lábából",
	[8] = "jobb lábából",
	[9] = "fejéből"
}

local stitchOperation = {
	[3] = "törzsén",
	[4] = "medencéjén",
	[5] = "bal kezén",
	[6] = "jobb kezén",
	[7] = "bal lábán",
	[8] = "jobb lábán",
	[9] = "fején"
}

function dogElementStreamed()
    if getElementType(source) == "ped" then
        if getElementData(source, "animal.animalId") then
            if getElementData(source, "animal.ownerId") == getElementData(localPlayer, "char.ID") then
                animalElement = source
            end
        end
    end 
end
addEventHandler("onClientElementStreamIn", getRootElement(), dogElementStreamed)

function renderClickPanel()

    if renderData.sourceElement and isElement(renderData.sourceElement) then
        buttons = {}

        local worldX, worldY, worldZ = getPositionFromElementOffset(renderData.sourceElement, 0, 0, 0.2)
        local playerX, playerY, playerZ = getElementPosition(localPlayer)

        if worldX and worldY and worldZ then
            local clickPanelPosX, clickPanelPosY = getScreenFromWorldPosition(worldX, worldY, worldZ)
            local clickPanelDistance = getDistanceBetweenPoints3D(worldX, worldY, worldZ, playerX, playerY, playerZ)

            if clickPanelPosX and clickPanelPosY and clickPanelDistance < 5 then
                if bulletDamages then
                    local damages = {}

                    for data, amount in pairs(bulletDamages) do
                        local typ = gettok(data, 1, ";")
                        local part = tonumber(gettok(data, 2, ";"))

                        if typ == "stitch-cut" then
                            table.insert(damages, {"Összevart vágás a " .. surfaceLocation[part]})
                        elseif typ == "stitch-hole" then
                            table.insert(damages, {"Összevart golyó helye a " .. surfaceLocation[part]})
                        elseif typ == "punch" then
                            table.insert(damages, {"Ütések a " .. surfaceLocation[part]})
                        elseif typ == "hole" then
                            table.insert(damages, {amount .. " golyó helye a " .. surfaceLocation[part], false, data})
                        elseif typ == "cut" then
                            table.insert(damages, {amount .. " vágás a " .. surfaceLocation[part], false, data})
                        else
                            local weapon = tonumber(typ)

                            if weapon >= 25 and weapon <= 27 then
                                table.insert(damages, {"Sörétek a " .. bulletLocation[part], data, false})
                            else
                                table.insert(damages, {amount .. " golyó a " .. bulletLocation[part], data, false})
                            end
                        end
                    end

                    if #damages == 0 then
                        damages[1] = {"Nem található sérülés."}
                    end

                    local clickPanelSizeW = 200
                    local clickPanelSizeH = #damages * 30
                
                    local clickPanelPosX = clickPanelPosX - clickPanelSizeW / 2
                    local clickPanelPosY = clickPanelPosY - clickPanelSizeH / 2

                    dxDrawRectangle(clickPanelPosX - 4, clickPanelPosY - 4, clickPanelSizeW + 8, clickPanelSizeH + 38, tocolor(26, 27, 31))

                    if exports.seal_items:playerHasItem(150) then
                        for i = 1, #damages do
                            local y = clickPanelPosY + 30 * (i - 1)
                            local dmg = damages[i]

                            dxDrawText(dmg[1], clickPanelPosX + 4, y, clickPanelPosX + 4 + clickPanelSizeW, y + 30, tocolor(255, 255, 255), 0.9, Rubik, "left", "center")

                            if dmg[2] and canOperate then                               
                                drawButton("getoutbullet:"  .. dmg[2], "Kivétel", clickPanelPosX + clickPanelSizeW - 40, y, 40, 25, {50, 186, 157}, false, Rubik, true, 0.75)
                            elseif dmg[3] and canStitch then                               
                                drawButton("stitch:"  .. dmg[3], "Varrás", clickPanelPosX + clickPanelSizeW - 40, y, 40, 25, {50, 186, 157}, false, Rubik, true, 0.75)
                            end
                        end
                    end

                    clickPanelPosY = clickPanelPosY + #damages * 30
                    drawButton("exitPanel", "Kilépés", clickPanelPosX, clickPanelPosY + 4, clickPanelSizeW, 26, {243, 90, 90}, false, Rubik, true)
                else
                    local clickPanelSizeW = 200
                    local clickPanelSizeH = enabledButtons * 30 + 4
                    enabledButtons = 0

                    local clickPanelPosX = clickPanelPosX - clickPanelSizeW / 2
                    local clickPanelPosY = clickPanelPosY - clickPanelSizeH / 2

                    dxDrawRectangle(clickPanelPosX - 4, clickPanelPosY - 4, clickPanelSizeW + 8, clickPanelSizeH, tocolor(26, 27, 31))

                    drawButton("spectatePlayer", "Vizsgálat", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {50, 186, 157}, false, Rubik, true)
                    enabledButtons = enabledButtons + 1
                    
                    if exports.seal_items:playerHasItem(482) or exports.seal_items:playerHasItem(150) then
                        if renderData.injureLeftFoot or renderData.injureRightFoot or renderData.injureLeftArm or renderData.injureRightArm or getElementHealth(renderData.sourceElement) <= 20 then
                            clickPanelPosY = clickPanelPosY + 30
                            enabledButtons = enabledButtons + 1

                            if getElementHealth(renderData.sourceElement) <= 20 then                        
                                drawButton("growUpPlayer", "Felsegítés", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {188, 61, 64}, false, Rubik, true)
                            elseif renderData.injureLeftFoot or renderData.injureRightFoot or renderData.injureLeftArm or renderData.injureRightArm or getElementHealth(renderData.sourceElement) <= 20 then
                                drawButton("growUpPlayer", "Gyógyítás", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {188, 61, 64}, false, Rubik, true)
                            end
                        end
                    end
                    
                    if exports.seal_items:playerHasItem(48) and exports.seal_groups:isPlayerHavePermission(localPlayer, "cuff") then
                        local cuffed = getElementData(renderData.sourceElement, "cuffed")
                        local buttonText = "Megbilincselés"

                        if cuffed then
                            buttonText = "Bilincs levétele"
                        end

                        clickPanelPosY = clickPanelPosY + 30
                        enabledButtons = enabledButtons + 1

                        drawButton("cuffPlayer", buttonText, clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {50, 186, 157}, false, Rubik, true)

                        if cuffed then
                            local buttonText = "Visz"

                        if getElementData(renderData.sourceElement, "visz") then
                            buttonText = "Elenged"
                        end

                        clickPanelPosY = clickPanelPosY + 30
                        enabledButtons = enabledButtons + 1

                        drawButton("takePlayer", buttonText, clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {50, 186, 157}, false, Rubik, true)
                    end
                end

                
                if animalElement then
                    local myAnimal = animalElement
                    if isElement(myAnimal) then
                        clickPanelPosY = clickPanelPosY + 30
                        enabledButtons = enabledButtons + 1

                        drawButton("dogAttack", "Kutya rá úszítása", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {50, 186, 157}, false, Rubik, true)
                    end
                end

                clickPanelPosY = clickPanelPosY + 30
                enabledButtons = enabledButtons + 1

                drawButton("seePlayerItems", "Motozás", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {50, 186, 157}, false, Rubik, true)

                clickPanelPosY = clickPanelPosY + 30
                enabledButtons = enabledButtons + 1

                drawButton("exitPanel", "Bezárás", clickPanelPosX, clickPanelPosY, clickPanelSizeW, 26, {243, 90, 90}, false, Rubik, true)
            end
        else
            closeClickPanel()
        end
    end
end

    local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		activeButton = false
		if not buttons then
			return
		end
		for k,v in pairs(buttons) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	else
		activeButton = false
	end
end

local lastTryToHelpUp = 0

function clickOnClickPanel(sourceKey, keyState)
    if sourceKey == "left" and keyState == "down" then
        if activeButton then
            if activeButton == "spectatePlayer" then
                spectatePlayerBody(renderData.sourceElement)
                if bulletDamages then
                    exports.seal_gui:showInfobox("i", "Vedd elő az esettáskát, hogy eltudd látni a játékost.")
                end

            elseif activeButton == "growUpPlayer" then
                helpUpPlayer(renderData.sourceElement)
                closeClickPanel()

            elseif activeButton == "cuffPlayer" then
                triggerServerEvent("cuffPlayer", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButton == "takePlayer" then
                triggerServerEvent("viszPlayer", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButton == "dogAttack" then
                local localX, localY, localZ = getElementPosition(localPlayer)
				local targetX, targetY, targetZ = getElementPosition(animalElement)

				if getDistanceBetweenPoints3D(localX, localY, localZ, targetX, targetY, targetZ) <= 15 then
                    setPedTask(animalElement, {"killPed", renderData.sourceElement, 5, 0})
                    triggerEvent("createDogPanelFont", localPlayer)
                    closeClickPanel()
                else
                    outputChatBox("#d75959[SealMTA]: #ffffffA peted túl messze van tőled.", 255, 255, 255, true)
                end

            elseif activeButton == "seePlayerItems" then
                triggerServerEvent("searchPlayerItems", localPlayer, renderData.sourceElement)
                closeClickPanel()

            elseif activeButton == "exitPanel" then
                closeClickPanel()

            elseif string.find(activeButton, "getoutbullet") then
                if canOperate then
                    local selected = gettok(activeButton, 2, ":")
                    local dmgtype = tonumber(gettok(selected, 1, ";"))
                    local bodypart = tonumber(gettok(selected, 2, ";"))
                    local visibleName = getElementData(renderData.sourceElement, "visibleName"):gsub("_", " ")

                    triggerServerEvent("getOutBullet", renderData.sourceElement, selected)

                    if dmgtype >= 25 and dmgtype <= 27 then
                        exports.seal_chat:localActionC(localPlayer, "kiveszi a söréteket " .. visibleName .. " " .. bulletOperation[bodypart] .. ".")
                    else
                        exports.seal_chat:localActionC(localPlayer, "kivesz egy golyót " .. visibleName .. " " .. bulletOperation[bodypart] .. ".")
                    end

                    closeClickPanel()
                end

            elseif string.find(activeButton, "stitch") then
                if canStitch then
                    local selected = gettok(activeButton, 2, ":")
                    local bodypart = tonumber(gettok(selected, 2, ";"))
                    local visibleName = getElementData(renderData.sourceElement, "visibleName"):gsub("_", " ")

                    triggerServerEvent("stitchPlayerCut", renderData.sourceElement, selected)

                    exports.seal_chat:localActionC(localPlayer, "összevarr egy sebet " .. visibleName .. " " .. stitchOperation[bodypart] .. ".")

                    closeClickPanel()
                end
            end
            playSound(":seal_radio/files/hifibuttons.mp3", false)
            activeButton = false
        end
    end
end



function examineMyself()
    if not renderData then
        openClickPanel(localPlayer)

        spectatePlayerBody(localPlayer)
    end
end
addCommandHandler("examinemyself", examineMyself)
addCommandHandler("sérüléseim", examineMyself)
addCommandHandler("seruleseim", examineMyself)

function openClickPanel(targetPlayer)
    animalElement = getElementByID("animal_" .. getElementData(localPlayer, "char.ID"))

    renderData = {
        sourceElement = targetPlayer,
        visibleName = utf8.gsub(getElementData(targetPlayer, "visibleName"), "_", " "),
        clickPanelSizeW = respc(200),
        clickPanelSizeH = respc(240),
        injureLeftFoot = getElementData(targetPlayer, "char.injureLeftFoot"),
        injureRightFoot = getElementData(targetPlayer, "char.injureRightFoot"),
        injureLeftArm = getElementData(targetPlayer, "char.injureLeftArm"),
        injureRightArm = getElementData(targetPlayer, "char.injureRightArm"),
    }

    playSound(":seal_radio/files/hifiopen.mp3", false)

    createFonts()

    addEventHandler("onClientClick", getRootElement(), clickOnClickPanel)
    addEventHandler("onClientRender", getRootElement(), renderClickPanel)
end

function closeClickPanel()
    removeEventHandler("onClientClick", getRootElement(), clickOnClickPanel)
    removeEventHandler("onClientRender", getRootElement(), renderClickPanel)

    playSound(":seal_radio/files/hificlose.mp3", false)

    bulletDamages = false

    renderData = nil 
    destroyFonts()
end

addEventHandler("onClientClick", getRootElement(), 
    function(sourceKey, keyState, relX, relY, worldX, worldY, worldZ, clickedElement)
        if sourceKey  == "right" and keyState == "down" then
            if clickedElement then
                if getElementType(clickedElement) == "player" then
                    if clickedElement and clickedElement ~= localPlayer then
                        if not renderData then
                            local x, y, z = getElementPosition(localPlayer)
                            local x2, y2, z2 = getElementPosition(clickedElement)
                            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

                            if distance > 10 then
                                return
                            end

                            openClickPanel(clickedElement)
                        end
                    end
                end
            end
        end
    end
)

function setPedTask(pedElement, selectedTask)
	if isElement(pedElement) then
		clearPedTasks(pedElement)
		setElementData(pedElement, "ped.task.1", selectedTask)
		setElementData(pedElement, "ped.thisTask", 1)
		setElementData(pedElement, "ped.lastTask", 1)
		return true
	else
		return false
	end
end

function clearPedTasks(pedElement)
	if isElement(pedElement) then
		local thisTask = getElementData(pedElement, "ped.thisTask")

		if thisTask then
			local lastTask = getElementData(pedElement, "ped.lastTask")

			for currentTask = thisTask, lastTask do
				setElementData(pedElement, "ped.task." .. currentTask, nil)
			end

			setElementData(pedElement, "ped.thisTask", nil)
			setElementData(pedElement, "ped.lastTask", nil)
			return true
		end
	else
		return false
	end
end

function spectatePlayerBody(targetPlayer)
    if getElementType(targetPlayer) == "player" then
        bulletDamages = getElementData(targetPlayer, "bulletDamages") or {}
    else
        bulletDamages = getElementData(targetPlayer, "deathPed") or {}

        if bulletDamages then
            bulletDamages = bulletDamages[5] or {}
        end
    end

    if isElement(getElementData(localPlayer, "holdingBag")) then
        canOperate = true
        canStitch = true
    end
end

function helpUpPlayer(targetPlayer)
    if getTickCount() - lastTryToHelpUp >= 1000 then
        lastTryToHelpUp = getTickCount()

        local injureLeftFoot = getElementData(targetPlayer, "char.injureLeftFoot")
        local injureRightFoot = getElementData(targetPlayer, "char.injureRightFoot")
        local injureLeftArm = getElementData(targetPlayer, "char.injureLeftArm")
        local injureRightArm = getElementData(targetPlayer, "char.injureRightArm")
        local damages = {}
        local damageCount = 0

        if getElementType(targetPlayer) == "player" then
            damages = getElementData(targetPlayer, "bulletDamages") or {}
        else
            damages = getElementData(targetPlayer, "deathPed") or {}

            if damages then
                damages = damages[5] or {}
            end
        end

        for k, v in pairs(damages) do
            damageCount = damageCount + 1
        end

        if injureLeftFoot or injureRightFoot or injureLeftArm or injureRightArm or damageCount > 0 or getElementHealth(targetPlayer) <= 20 then
            for data, amount in pairs(damages) do
                local typ = gettok(data, 1, ";")

                if typ == "stitch-cut" then
                elseif typ == "stitch-hole" then
                elseif typ == "punch" then
                elseif typ == "hole" then
                    outputChatBox("#d75959[SealMTA]: #ffffffAddig nem gyógyíthatod meg, amíg vágás van a testén!", 255, 255, 255, true)
                    exports.seal_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg vágás van a testén!")
                    return
                elseif typ == "cut" then
                    outputChatBox("#d75959[SealMTA]: #ffffffAddig nem gyógyíthatod meg, amíg vágás van a testén!", 255, 255, 255, true)
                    exports.seal_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg vágás van a testén!")
                    return
                else
                    local weapon = tonumber(typ)

                    if weapon >= 25 and weapon <= 27 then
                        outputChatBox("#d75959[SealMTA]: #ffffffAddig nem gyógyíthatod meg, amíg sörétek vannak a testében!", 255, 255, 255, true)
                        exports.seal_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg sörétek vannak a testében!")
                        return
                    else
                        outputChatBox("#d75959[SealMTA]: #ffffffAddig nem gyógyíthatod meg, amíg golyó van a testében!", 255, 255, 255, true)
                        exports.seal_hud:showInfobox("e", "Addig nem gyógyíthatod meg, amíg golyó van a testében!")
                        return
                    end
                end
            end

            triggerServerEvent("takeMedicBag", localPlayer, targetPlayer)
            closeClickPanel()
        else
            outputChatBox("#d75959[SealMTA]: #ffffffA kiválasztott játékos nincs megsérülve!", 255, 255, 255, true)
            exports.seal_hud:showInfobox("e", "A kiválasztott játékos nincs megsérülve!")
        end
    end
end

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end
