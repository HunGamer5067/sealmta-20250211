local screenX, screenY = guiGetScreenSize()
local dutyPositions = {}
local standingMarker = false

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedResource)
		if getResourceName(startedResource) == "seal_interiors" then
			destroyGroupMarkers()

			for k, v in pairs(availableGroups) do
				if not dutyPositions[k] then
					dutyPositions[k] = {}
				end

				if v.duty and v.duty.positions ~= nil  then
					for i, v2 in ipairs(v.duty.positions) do
						local colShapeElement = createColSphere(v2[1], v2[2], v2[3], 0.75)

						if isElement(colShapeElement) then
							setElementInterior(colShapeElement, v2[4])
							setElementDimension(colShapeElement, v2[5])
							setElementData(colShapeElement, "groupId", k)

							local markerElement = exports.seal_interiors:createCoolMarker(v2[1], v2[2], v2[3], "duty", false, false, startedResource, true)

							if isElement(markerElement) then
								setElementInterior(markerElement, v2[4])
								setElementDimension(markerElement, v2[5])
							end

							dutyPositions[k][i] = {}
							dutyPositions[k][i].colShape = colShapeElement
							dutyPositions[k][i].pickup = markerElement
						end
					end
				end
			end
		else
			if startedResource == getThisResource() then
				local seal_interiors = getResourceFromName("seal_interiors")

				if seal_interiors then
					if getResourceState(seal_interiors) == "running" then
						destroyGroupMarkers()

						for k, v in pairs(availableGroups) do
							if not dutyPositions[k] then
								dutyPositions[k] = {}
							end

							if v.duty and v.duty.positions ~= nil  then
								for i, v2 in ipairs(v.duty.positions) do
									local colShapeElement = createColSphere(v2[1], v2[2], v2[3], 0.75)

									if isElement(colShapeElement) then
										setElementInterior(colShapeElement, v2[4])
										setElementDimension(colShapeElement, v2[5])
										setElementData(colShapeElement, "groupId", k)

										local markerElement = exports.seal_interiors:createCoolMarker(v2[1], v2[2], v2[3], "duty", false, false, startedResource, true)

										if isElement(markerElement) then
											setElementInterior(markerElement, v2[4])
											setElementDimension(markerElement, v2[5])
										end

										dutyPositions[k][i] = {}
										dutyPositions[k][i].colShape = colShapeElement
										dutyPositions[k][i].pickup = markerElement
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		destroyGroupMarkers()
	end
)

function destroyGroupMarkers()
	for key, value in pairs(availableGroups) do
		if value.duty and value.duty.positions ~= nil then
			for key2, value2 in ipairs(value.duty.positions) do
				if dutyPositions[key] then
					if dutyPositions[key][key2] then
						if isElement(dutyPositions[key][key2].pickup) then
							destroyElement(dutyPositions[key][key2].pickup)
						end

						if isElement(dutyPositions[key][key2].colShape) then
							destroyElement(dutyPositions[key][key2].colShape)
						end

						dutyPositions[key][key2] = nil
					end
				end
			end
		end
	end
end

addEventHandler("onClientColShapeHit", getResourceRootElement(),
	function (hitElement, dimensionMatch)
		if hitElement == localPlayer and dimensionMatch then
			local groupId = getElementData(source, "groupId")

			if groupId then
				standingMarker = groupId
				exports.seal_hud:showInteriorBox("Szolgálat", "Nyomj [E] gombot a szolgálat felvételéhez/leadásához", false, "duty")
			end
		end
	end
)

addEventHandler("onClientColShapeLeave", getResourceRootElement(),
	function (leftElement, dimensionMatch)
		if leftElement == localPlayer and dimensionMatch then
			standingMarker = false
			exports.seal_hud:endInteriorBox()

			if exports.seal_gui:isGuiElementValid(guibg) then
				exports.seal_gui:deleteGuiElement(guibg)

				dutyItemAmounts = {}
				nameLabels = {}
				amountLabels = {}
				itemImages = {}
				plusButtons = {}
				minusButtons = {}
				panelOffSet = 0

				removeEventHandler("onClientKey", root, dutyPanelKeyHandler)
			end

			if exports.seal_gui:isGuiElementValid(selectorbg) then
				exports.seal_gui:deleteGuiElement(selectorbg)

				selectedDutySkin = false
				selectorCheckBoxes = {}
			end
		end
	end
)

local lastDutyTime = 0

bindKey("e", "down",
	function ()
		if standingMarker then
			if isPlayerInGroup(localPlayer, standingMarker) then
				createDutyPanel()
			end
		end
	end
)

local dutyItemAmounts = {}

local nameLabels = {}
local amountLabels = {}
local itemImages = {}
local plusButtons = {}
local minusButtons = {}

local panelOffSet = 0

function createDutyPanel()
	local playerDutyState = getElementData(localPlayer, "inDuty") or false

	if not playerDutyState then
		local dutyItems = availableGroups[standingMarker].duty.items

		for i = 1, #dutyItems do
			dutyItemAmounts[i] = {dutyItems[i][1], 0, dutyItems[i][2]}
		end

		local sx, sy = 400, 487
		guibg = exports.seal_gui:createGuiElement("window", screenX / 2 - (sx / 2), screenY / 2 - (sy / 2), sx, sy)
		exports.seal_gui:setWindowTitle(guibg, "13/Ubuntu-R.ttf", "Szolgálat")
		exports.seal_gui:setWindowCloseButton(guibg, "closeDutyPanel")

		for i = 1, 10 do
		    local hr = exports.seal_gui:createGuiElement("rectangle", 6, 36 * (i + 1), sx - 12, 1, guibg)
		    exports.seal_gui:setGuiBackground(hr, "solid", "grey4")

		    if dutyItems and dutyItems[i] then
			    local label = exports.seal_gui:createGuiElement("label", 36, 36 * i, sx - 12, 36, guibg)
		        exports.seal_gui:setLabelFont(label, "14/BebasNeueBold.otf")
		        exports.seal_gui:setLabelText(label, exports.seal_items:getItemName(dutyItems[i][1]))
		        exports.seal_gui:setLabelAlignment(label, "left", "center")
		        nameLabels[i] = label

		        local image = exports.seal_gui:createGuiElement("image", 6, (36 * i) + 6, 24, 24, guibg)
		        exports.seal_gui:setImageFile(image, ":seal_items/files/items/" .. dutyItems[i][1] - 1 .. ".png")
		        itemImages[i] = image

		        local button = exports.seal_gui:createGuiElement("button", sx - 30, (36 * i) + 6, 24, 24, guibg)
		        exports.seal_gui:setGuiBackground(button, "solid", "primary")
			    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"})
	    		exports.seal_gui:setButtonIcon(button, exports.seal_gui:getFaIconFilename("plus", 200))
	    		exports.seal_gui:setClickEvent(button, "changeItemAmount")
	    		exports.seal_gui:setClickSound(button, "selectdone")
	    		exports.seal_gui:guiSetTooltip(button, "Bal klikk: +1 hozzáadás\nJobb klikk: +50 hozzáadás")
	    		plusButtons[i] = button

	    		local button = exports.seal_gui:createGuiElement("button", sx - 96, (36 * i) + 6, 24, 24, guibg)
		        exports.seal_gui:setGuiBackground(button, "solid", "red")
			    exports.seal_gui:setGuiHover(button, "gradient", {"red", "red-second"})
	    		exports.seal_gui:setButtonIcon(button, exports.seal_gui:getFaIconFilename("minus", 200))
	    		exports.seal_gui:setClickEvent(button, "changeItemAmount")
	    		exports.seal_gui:setClickSound(button, "selectdone")
	    		exports.seal_gui:guiSetTooltip(button, "Bal klikk: -1 levonás\nJobb klikk: -50 levonás")
	    		minusButtons[i] = button

	    		local label = exports.seal_gui:createGuiElement("label", sx - 63, (36 * i) + 6, 24, 24, guibg)
	    		exports.seal_gui:setLabelText(label, dutyItemAmounts[i][2])
				exports.seal_gui:setLabelFont(label, "13/Ubuntu-L.ttf")
				exports.seal_gui:setLabelAlignment(label, "center", "center")
				amountLabels[i] = label
		    end
		end

		local button = exports.seal_gui:createGuiElement("button", 6, sy - 42, sx - 12, 36, guibg)
	    exports.seal_gui:setGuiBackground(button, "solid", "primary")
	    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"})
	    exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	    exports.seal_gui:setButtonText(button, "Szolgálat felvétele")
	    exports.seal_gui:setClickEvent(button, "tryToDuty")
	   	exports.seal_gui:setClickSound(button, "selectdone")

		local button = exports.seal_gui:createGuiElement("button", 6, sy - 84, sx - 12, 36, guibg)
	    exports.seal_gui:setGuiBackground(button, "solid", "red")
	    exports.seal_gui:setGuiHover(button, "gradient", {"red", "red-second"})
	    exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	    exports.seal_gui:setButtonText(button, "Duty skin kiválasztás")
	    exports.seal_gui:setClickEvent(button, "openSkinSelector")
	   	exports.seal_gui:setClickSound(button, "selectdone")

	    addEventHandler("onClientKey", root, dutyPanelKeyHandler)
	else
		local sx, sy = 400, 84
		guibg = exports.seal_gui:createGuiElement("window", screenX / 2 - (sx / 2), screenY / 2 - (sy / 2), sx, sy)
		exports.seal_gui:setWindowTitle(guibg, "13/Ubuntu-R.ttf", "Szolgálat")
		exports.seal_gui:setWindowCloseButton(guibg, "closeDutyPanel")

		local button = exports.seal_gui:createGuiElement("button", 6, sy - 42, sx - 12, 36, guibg)
	    exports.seal_gui:setGuiBackground(button, "solid", "red")
	    exports.seal_gui:setGuiHover(button, "gradient", {"red", "red-second"})
	    exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	    exports.seal_gui:setButtonText(button, "Szolgálat leadása")
	    exports.seal_gui:setClickEvent(button, "tryToDuty")
	   	exports.seal_gui:setClickSound(button, "selectdone")
	end
end

addEvent("openSkinSelector", true)
addEventHandler("openSkinSelector", root,
	function (button, state, absX, absY, el)
		if exports.seal_gui:isGuiElementValid(el) then
			if not exports.seal_gui:isGuiRenderDisabled(guibg) then
				exports.seal_gui:setGuiRenderDisabled(guibg, true, true)
			end

			createSkinSelector()
		end
	end
)

local selectorCheckBoxes = {}
local selectedDutySkin = false

function createSkinSelector()
	local dutySkins = availableGroups[standingMarker].duty.skins

	local sx, sy = 400, 541
	selectorbg = exports.seal_gui:createGuiElement("window", screenX / 2 - (sx / 2), screenY / 2 - (sy / 2), sx, sy)
	exports.seal_gui:setWindowTitle(selectorbg, "13/Ubuntu-R.ttf", "Szolgálat - Skin választó")

	for i = 1, 15 do
	    local hr = exports.seal_gui:createGuiElement("rectangle", 6, 31 * (i + 1), sx - 12, 1, selectorbg)
	    exports.seal_gui:setGuiBackground(hr, "solid", "grey4")

	    if dutySkins[i] then
		    local label = exports.seal_gui:createGuiElement("label", 6, 31 * i, sx - 12, 31, selectorbg)
	        exports.seal_gui:setLabelFont(label, "14/BebasNeueBold.otf")
	        exports.seal_gui:setLabelText(label, i .. ". Duty skin: " .. dutySkins[i])
	        exports.seal_gui:setLabelAlignment(label, "left", "center")

	        local checkbox = exports.seal_gui:createGuiElement("checkbox", sx - 30, 31 * i + 4, 24, 24, selectorbg)
		    exports.seal_gui:setClickEvent(checkbox, "selectSkin")
		    exports.seal_gui:setCheckboxColor(checkbox, _, _, "primary", "hudwhite")
		    selectorCheckBoxes[i] = checkbox
	    end
	end

	if exports.seal_gui:isGuiElementValid(selectorCheckBoxes[selectedDutySkin]) then
		exports.seal_gui:setCheckboxChecked(selectorCheckBoxes[selectedDutySkin], true)
	end

	local button = exports.seal_gui:createGuiElement("button", 6, sy - 37, sx - 12, 31, selectorbg)
	exports.seal_gui:setGuiBackground(button, "solid", "red")
	exports.seal_gui:setGuiHover(button, "gradient", {"red", "red-second"})
	exports.seal_gui:setButtonFont(button, "14/Ubuntu-R.ttf")
	exports.seal_gui:setButtonText(button, "Vissza")
	exports.seal_gui:setClickEvent(button, "backToDutyPanel")
	exports.seal_gui:setClickSound(button, "selectdone")
end

addEvent("backToDutyPanel", true)
addEventHandler("backToDutyPanel", root,
	function (button, state, absX, absY, el)
		if exports.seal_gui:isGuiElementValid(el) then
			if exports.seal_gui:isGuiElementValid(selectorbg) then
				exports.seal_gui:deleteGuiElement(selectorbg)
			end

			selectorCheckBoxes = {}

			if exports.seal_gui:isGuiElementValid(guibg) then
				exports.seal_gui:setGuiRenderDisabled(guibg, false, true)
			end
		end
	end
)

addEvent("selectSkin", true)
addEventHandler("selectSkin", root,
	function (button, state, absX, absY, el)
		if exports.seal_gui:isGuiElementValid(el) then
			for i = 1, #selectorCheckBoxes do
				if exports.seal_gui:isCheckboxChecked(selectorCheckBoxes[i]) then
					exports.seal_gui:setCheckboxChecked(selectorCheckBoxes[i], false)
				end

				if selectorCheckBoxes[i] == el then
					exports.seal_gui:setCheckboxChecked(el, true)
					selectedDutySkin = i
				end
			end
		end
	end
)

addEvent("closeDutyPanel", true)
addEventHandler("closeDutyPanel", root,
	function (button, state)
		if exports.seal_gui:isGuiElementValid(guibg) then
			exports.seal_gui:deleteGuiElement(guibg)

			dutyItemAmounts = {}
			nameLabels = {}
			amountLabels = {}
			itemImages = {}
			plusButtons = {}
			minusButtons = {}
			panelOffSet = 0

			if exports.seal_gui:isGuiElementValid(selectorbg) then
				exports.seal_gui:deleteGuiElement(selectorbg)
			end

			selectedDutySkin = false
			selectorCheckBoxes = {}

			removeEventHandler("onClientKey", root, dutyPanelKeyHandler)
		end
	end
)

function dutyPanelKeyHandler(key, press)
	if exports.seal_gui:isGuiElementValid(guibg) then
		if not press then
			return
		end

		local dutyItems = availableGroups[standingMarker].duty.items

		if key == "mouse_wheel_down" then
			if panelOffSet < #dutyItems - 10 then
				panelOffSet = panelOffSet + 1

				for i = 1, 10 do
					local number = i + panelOffSet
					exports.seal_gui:setLabelText(amountLabels[i], dutyItemAmounts[number][2])
					exports.seal_gui:setLabelText(nameLabels[i], exports.seal_items:getItemName(dutyItemAmounts[number][1]))
					exports.seal_gui:setImageFile(itemImages[i], ":seal_items/files/items/" .. dutyItemAmounts[number][1] - 1 .. ".png")
				end
			end
		end

		if key == "mouse_wheel_up" then
			if panelOffSet > 0 then
				panelOffSet = panelOffSet - 1

				for i = 1, 10 do
					local number = i + panelOffSet
					exports.seal_gui:setLabelText(amountLabels[i], dutyItemAmounts[number][2])
					exports.seal_gui:setLabelText(nameLabels[i], exports.seal_items:getItemName(dutyItemAmounts[number][1]))
					exports.seal_gui:setImageFile(itemImages[i], ":seal_items/files/items/" .. dutyItemAmounts[number][1] - 1 .. ".png")
				end
			end
		end
	end
end

addEvent("changeItemAmount", true)
addEventHandler("changeItemAmount", root,
	function (button, state, absX, absY, el)
		if exports.seal_gui:isGuiElementValid(el) then
			for i = 1, 10 do
				local number = i + panelOffSet
				if button == "right" then
					amount = 50
				else
					amount = 1
				end

				if plusButtons[i] == el then
					if (dutyItemAmounts[number][2] + amount) <= dutyItemAmounts[number][3] then
						dutyItemAmounts[number][2] = dutyItemAmounts[number][2] + amount
						exports.seal_gui:setLabelText(amountLabels[i], dutyItemAmounts[number][2])
					else
						exports.seal_gui:showInfobox("e", "Ennél az itemnél elérted a maximum mennyiséget.")
					end
				end

				if minusButtons[i] == el then
					if (dutyItemAmounts[number][2] - amount) >= 0 then
						dutyItemAmounts[number][2] = dutyItemAmounts[number][2] - amount
						exports.seal_gui:setLabelText(amountLabels[i], dutyItemAmounts[number][2])
					else
						exports.seal_gui:showInfobox("e", "Ennél az itemnél elérted a minimum mennyiséget.")
					end
				end
			end
		end
	end
)

addEvent("tryToDuty", true)
addEventHandler("tryToDuty", root,
	function (button, state, absX, absY, el)
		local elapsedTime = getTickCount() - lastDutyTime

		if elapsedTime >= 5000 then
			if exports.seal_gui:isGuiElementValid(guibg) then
				exports.seal_gui:deleteGuiElement(guibg)
				removeEventHandler("onClientKey", root, dutyPanelKeyHandler)

				if isPlayerInGroup(localPlayer, standingMarker) then
					local dutyState = getElementData(localPlayer, "inDuty") or false
					if not selectedDutySkin and not dutyState then
						exports.seal_gui:showInfobox("e", "A szolgálatba felvételéhez válassz duty skin-t.")
						return
					end

					triggerServerEvent("requestDuty", resourceRoot, standingMarker, dutyItemAmounts, selectedDutySkin)

					dutyItemAmounts = {}
					nameLabels = {}
					amountLabels = {}
					itemImages = {}
					plusButtons = {}
					minusButtons = {}
					panelOffSet = 0

					if exports.seal_gui:isGuiElementValid(selectorbg) then
						exports.seal_gui:deleteGuiElement(selectorbg)
					end

					selectedDutySkin = false
					selectorCheckBoxes = {}
				end
			end

			lastDutyTime = getTickCount()
		else
			exports.seal_gui:showInfobox("e", "Várj " .. 5 - math.ceil(elapsedTime / 1000) .. " másodpercet a következő dutyzásig.")
		end
	end
)

addCommandHandler("grouplist",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
			outputChatBox("#4adfbf[SealMTA]:#ffffff A csoportok megtekintéséhez nyisd meg a konzolt. (F8)", 255, 255, 255, true)
			
			local groupList = {}
			
			for k, v in pairs(availableGroups) do
				table.insert(groupList, {k, v})
			end
			
			table.sort(groupList,
				function (a, b)
					return a[1] < b[1]
				end
			)
			
			for i, v in ipairs(groupList) do
				outputConsole("    * (" .. v[1] .. "): " .. v[2].name .. " [" .. groupTypes[v[2].type] .. "]")
			end
		end
	end
)