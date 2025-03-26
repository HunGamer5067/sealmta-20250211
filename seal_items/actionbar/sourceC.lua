local screenX, screenY = guiGetScreenSize()

local slotLimit = 6

local panelState = false

local w, h = 80
local panelWidth = (80 + (5)) * slotLimit + (5)
local panelHeight = 80 + (5) * 2

local panelPosX = screenX  / 2 - panelWidth / 2
local panelPosY = screenY - panelHeight - (5)

local actionBarItems = {}
local actionBarSlots = {}
local slotPositions = false

local loggedIn = false
local editHud = false
local bigRadarState = false

local moveDifferenceX = 0
local moveDifferenceY = 0

local movedSlotId = false
local lastHoverSlotId = false
local hoverSpecialItem = false

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if getElementData(localPlayer, "loggedIn") then
			loadActionBarItems()

			loggedIn = true
			panelState = true

			triggerEvent("requestChangeItemStartPos", localPlayer)
			triggerEvent("movedItemInInv", localPlayer, false)
		end
	end
)

function drawBorder(x, y, sx, sy, borderWidth, borderColor)
	if not borderColor then
		borderColor = tocolor(20, 20, 20, 255)
	end

	dxDrawRectangle(x - borderWidth, y, borderWidth, sy, borderColor) -- bal
	dxDrawRectangle(x + sx, y, borderWidth, sy, borderColor) -- jobb
	dxDrawRectangle(x - borderWidth, y - borderWidth, sx + 2, borderWidth, borderColor) -- felső
	dxDrawRectangle(x - borderWidth, y + sy, sx + 2, borderWidth, borderColor) -- alsó
end 

function loadActionBarItems()
	local items = getElementData(localPlayer, "actionBarItems") or {}

	actionBarSlots = {}

	for i = 1, 6 do
		if items[i] then
			actionBarSlots[i - 1] = items[i]
		end
	end
end

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName, oldValue)
		if dataName == "loggedIn" then
			if getElementData(localPlayer, "loggedIn") then
				loadActionBarItems()

				loggedIn = true
				panelState = true	
			end
		elseif dataName == "actionBarItems" then
			triggerEvent("movedItemInInv", localPlayer)
		elseif dataName == "bigRadarState" then
			bigRadarState = getElementData(source, "bigRadarState")
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absX, absY)
		if loggedIn and not editHud and not bigRadarState then
			if button == "left" then
				if state == "down" then
					local hoverSlotId, slotPosX, slotPosY = findActionBarSlot(absX, absY)

					if hoverSlotId and actionBarSlots[hoverSlotId] then
						movedSlotId = hoverSlotId

						moveDifferenceX = absX - slotPosX
						moveDifferenceY = absY - slotPosY

						playSound("files/sounds/select.mp3")
					end
				elseif state == "up" then
					if movedSlotId then
						local items = getElementData(localPlayer, "actionBarItems") or {}
						local hoverSlotId = findActionBarSlot(absX, absY)

						if hoverSlotId then
							if not actionBarSlots[hoverSlotId] then
								actionBarSlots[hoverSlotId] = actionBarSlots[movedSlotId]
								items[hoverSlotId+1] = actionBarSlots[movedSlotId]

								for i = 1, 6 do
									if items[i] then
										if movedSlotId == i - 1 then
											items[i] = nil
										end
									end
								end

								setElementData(localPlayer, "actionBarItems", items)
								actionBarSlots[movedSlotId] = nil
							end
						else
							for i = 1, 6 do
								if items[i] then
									if movedSlotId == i - 1 then
										items[i] = nil
									end
								end
							end
								
							actionBarSlots[movedSlotId] = nil
							setElementData(localPlayer, "actionBarItems", items)
						end

						playSound("files/sounds/select.mp3")
						movedSlotId = false
					elseif hoverSpecialItem then
						if currentItemInUse then
							itemsTable.player[currentItemInUse.slot].inUse = false
							triggerServerEvent("detachObject", localPlayer)
							currentItemInUse = false
							currentItemRemainUses = false
						end
					end
				end
			elseif button == "right" then
				if state == "up" then
					if hoverSpecialItem and currentItemInUse then
						useSpecialItem()
					end
				end
			end
		end
	end)

function putOnActionBar(slot, item)
	if slot then
		if not actionBarSlots[slot] then
			local items = getElementData(localPlayer, "actionBarItems") or {}

			actionBarSlots[slot] = item.dbID
			items[slot + 1] = item.dbID

			setElementData(localPlayer, "actionBarItems", items)

			return true
		else
			return false
		end
	else
		return false
	end
end

function findActionBarSlot(x, y)
	if panelState then
		local slot = false
		local slotPosX, slotPosY = false, false

		for i = 0, slotLimit - 1 do
			if not slotPositions or not slotPositions[i] then
				return
			end

			local x2 = slotPositions[i][1]
			local y2 = slotPositions[i][2]

			if x >= x2 + 20 and x <= x2 + 20 + 36 and y >= y2 + 20 and y <= y2 + 20 + 36 then
				slot = tonumber(i)
				slotPosX, slotPosY = x2 + 20, y2 + 20
				break
			end
		end

		if slot then
			return slot, slotPosX, slotPosY
		else
			return false
		end
	else
		return false
	end
end

for i = 1, slotLimit do
	bindKey(tostring(i), "down",
		function ()
			if not editHud and not bigRadarState and loggedIn then
				useActionSlot(i)
			end
		end
	)
end

local toggleUse = false
function toggleActionBarUse(state)
	toggleUse = state
end

function useActionSlot(slot)
	if not haveMoving and slot and not toggleUse then
		slot = tonumber(slot - 1)

		if not guiGetInputEnabled() then
			local item = tonumber(actionBarSlots[slot])

			if item then
				useItem(item)
			end
		end
	end
end

addEvent("updateItemID", true)
addEventHandler("updateItemID", getRootElement(),
	function (ownerType, itemId, newId)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			newId = tonumber(newId)
			
			if itemId and newId then
				for i = 0, slotLimit - 1 do
					if tonumber(actionBarSlots[i]) == itemId then
						actionBarItems[i].itemId = newId
					end
				end
			end
		end
	end)

addEvent("updateData1", true)
addEventHandler("updateData1", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			
			if itemId and newData then
				for i = 0, slotLimit - 1 do
					if tonumber(actionBarSlots[i]) == itemId then
						actionBarItems[i].data1 = newData
					end
				end
			end
		end
	end)

addEvent("updateData2", true)
addEventHandler("updateData2", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			
			if itemId and newData then
				for i = 0, slotLimit - 1 do
					if tonumber(actionBarSlots[i]) == itemId then
						actionBarItems[i].data2 = newData
					end
				end
			end
		end
	end)

addEvent("updateData3", true)
addEventHandler("updateData3", getRootElement(),
	function (ownerType, itemId, newData)
		if itemsTable[ownerType] then
			itemId = tonumber(itemId)
			
			if itemId and newData then
				for i = 0, slotLimit - 1 do
					if tonumber(actionBarSlots[i]) == itemId then
						actionBarItems[i].data3 = newData
					end
				end
			end
		end
	end)

function isPointOnActionBar(x, y)
	if panelState then
		if x >= panelPosX and x <= panelPosX + panelWidth and y >= panelPosY and y <= panelPosY + panelHeight then
			return true
		else
			return false
		end
	else
		return false
	end
end

function changeItemStartPos(x, y)
	panelPosX = x
	panelPosY = y
	slotPositions = {}

	for i = 0, slotLimit - 1 do
		slotPositions[i] = {math.floor(x + (39) * i) - 20, y - 20}
	end
end

function processActionBarShowHide(state)
	panelState = state
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if panelState and slotPositions then
			if isCursorShowing() then
				editHud = getKeyState("lctrl")
			elseif editHud then
				editHud = false
			end

			local cx, cy = getCursorPosition()

			if cx and cy then
				cx = cx * screenX
				cy = cy * screenY
			else
				cx, cy = (-1), (-1)
			end

			for i = 0, slotLimit - 1 do
				if slotPositions[i] then
					renderActionBarItem(i, slotPositions[i][1], slotPositions[i][2], cx, cy)
				end
			end

			if movedSlotId then
				local x = cx - moveDifferenceX
				local y = cy - moveDifferenceY
				local item = false

				for k, v in pairs(itemsTable.player) do
					if actionBarSlots[movedSlotId] == v.dbID then
						item = v
						break
					end
				end

				if item and tonumber(item.itemId) and tonumber(item.amount) then
					drawItemPicture(item, x, y)
				else
					dxDrawImage(x, y, 30, 30, "files/noitem.png")
				end
			end

			hoverSpecialItem = false

			if currentItemInUse and specialItems[currentItemInUse.itemId] then
				local sx, sy = 25, 25
				local x = math.floor(panelPosX + 296 / 2)
				local y = math.floor(panelPosY - 40 - (30))

				if cx >= x and cy >= y and cx <= x + sx and cy <= y + sy then
					dxDrawRectangle(x, y, sx, sy, tocolor(245, 150, 34))
					hoverSpecialItem = true
				else
					dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 50))
				end

				drawItemPicture(currentItemInUse, x, y, sx, sy)
				dxDrawImage(x + sx / 2 - 46 / 2 - 46, y + sy / 2 - 46 / 2, 46, 46, "files/leftMouse.png")
				dxDrawImage(x + sx / 2 - 46 / 2 + 46, y + sy / 2 - 46 / 2, 46, 46, "files/rightMouse.png")
				
				local sx, sy = 296, 6
				

				local x, y = panelPosX - 4, panelPosY - sy * 3.5

				dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 20)) -- háttér

				local progress = currentItemRemainUses / specialItems[currentItemInUse.itemId][2]
				local progresscolor = tocolor(94, 193, 230)
			
				if progress > 0.20 and progress <= 0.65 then
					progresscolor = tocolor(245, 150, 34)
				elseif progress <= 0.20 then
					progresscolor = tocolor(245, 81, 81)
				end

				dxDrawRectangle(x, y, sx * progress, sy, progresscolor) -- állapot
			end
		end
	end, true, "low")

function renderActionBarItem(slot, x, y, cx, cy)
	if actionBarItems[slot] and actionBarSlots[slot] and slot ~= movedSlotId then
		local item = actionBarItems[slot].slot
		local slotColor = tocolor(65, 65, 65)
		local inUse = false
		local x, y = x + 20, y + 20

		if item and itemsTable.player[item] and itemsTable.player[item].inUse then
			slotColor = tocolor(74, 223, 191)
			inUse = true
		end

		if (getKeyState(slot + 1) or cx >= x and cx <= x + 36 and cy >= y and cy <= y + 36) and not editHud then
			if not inUse then
				slotColor = tocolor(245, 150, 34)
			end
			
			if lastHoverSlotId ~= slot then
				lastHoverSlotId = slot

				if not movedSlotId then
					playSound("files/sounds/hover.mp3")
				end
			end
		elseif lastHoverSlotId == slot then
			lastHoverSlotId = false
		end

		dxDrawRectangle(x, y, 36, 36, tocolor(180, 180, 180, 100))
		dxDrawImage(x, y, 36, 36, ":seal_hud/files/images/shadow2.png", 0, 0, 0, slotColor)

		if actionBarItems[slot].itemId and actionBarItems[slot].amount then
			drawItemPicture(actionBarItems[slot], x, y)
		else
			dxDrawImage(x, y, 36, 36, "files/noitem.png")
		end

		dxDrawImage(x, y, 36, 36, ":seal_hud/files/images/shadow2.png", 0, 0, 0, slotColor)
		if inUse then
			slotColor = tocolor(74, 223, 191)
			dxDrawImage(x, y, 36, 36, ":seal_hud/files/images/shadow2.png", 0, 0, 0, slotColor)
		end
	else
		local slotColor = tocolor(65, 65, 65)
		local x, y = x + 20, y + 20

		if getKeyState(slot + 1) or cx >= x and cx <= x + 36 and cy >= y and cy <= y + 36 then
			if not editHud then
				slotColor = tocolor(74, 223, 191)
			end
		end

		dxDrawRectangle(x, y, 36, 36, tocolor(60, 60, 60, 100))
		dxDrawImage(x, y, 36, 36, ":seal_hud/files/images/shadow2.png", 0, 0, 0, slotColor)
	end
end

local sideWeapons = {
	--AK47
	[25] = 355,
	[265] = 355,
	[266] = 355,
	[267] = 355,
	[268] = 355,
	[269] = 355,
	[270] = 355,
	[271] = 355,

	--Sniper
	[28] = 358,
	[221] = 358,
	[222] = 358,
	[223] = 358,
	[224] = 358,
	
	--Deagle
	[18] = 348,
	[207] = 348,
	[272] = 348,
	[273] = 348,

	--MP5
	[23] = 353,
	[208] = 353,
	[209] = 353,
	[276] = 353,
	[277] = 353,
	[278] = 353,
	[279] = 353,

	--sawedoff
	[20] = 350,

	--Kések
	[9] = 335,
	[137] = 335,
	[138] = 335,
	[139] = 335,
	[140] = 335,
	[141] = 335,
	[280] = 335,
	[281] = 335,
	[282] = 335,

	--Tec9
	[24] = 372,
	
	--UZI
	[22] = 352,
	[283] = 352,
	[284] = 352,
	[285] = 352,
	[286] = 352,

	--Shotgun
	[19] = 349,
	[21] = 351,
	[214] = 349,
	[215] = 349,
	[216] = 349,

	--M4
	[26] = 356,
	[142] = 356,
	[143] = 356,
	[144] = 356,
	[145] = 356,
	[146] = 356,
	[151] = 356,
	[152] = 356,
	--[153] = 356,
	[155] = 356,
	[157] = 356,
	[158] = 356,
	[159] = 356,
	[166] = 356,
	[176] = 356,
}

addEvent("movedItemInInv", true)
addEventHandler("movedItemInInv", getRootElement(),
	function (simpleUpdate)
		local sideWeapons = exports.seal_weapons:getWeaponModels()
		checkRecipeHaveItem()
		
		for i = 0, slotLimit - 1 do
			actionBarItems[i] = {}

			for k, v in pairs(itemsTable.player) do
				if actionBarSlots[i] == v.dbID then
					actionBarItems[i].slot = tonumber(v.slot)
					actionBarItems[i].itemId = tonumber(v.itemId)
					actionBarItems[i].amount = tonumber(v.amount)
					actionBarItems[i].data1 = tonumber(v.data1)
					actionBarItems[i].data2 = tonumber(v.data2)
					actionBarItems[i].data3 = tonumber(v.data3)
					break
				end
			end
		end

		if not simpleUpdate then
			local added = {}
			local datas = {}

			for i = 0, defaultSettings.slotLimit - 1 do
				if itemsTable.player[i] then
					local item = itemsTable.player[i]

					if sideWeapons[item.itemId] then
						local k = item.itemId .. "," .. (weaponSkins[item.itemId] or 0)

						if not added[k] then
							added[k] = true

							if item.inUse then
								table.insert(datas, {item.itemId, "inuse", weaponSkins[item.itemId] or 0})
							else
								table.insert(datas, {item.itemId, true, weaponSkins[item.itemId] or 0})
							end
						end
					end
				end
			end

			local currentdatas = getElementData(localPlayer, "playerSideWeapons") or {}
			local updatedata = false

			if currentdatas then
				local old = {}
				local new = {}

				for k, v in ipairs(currentdatas) do
					old[tostring(v[1]) .. "," .. tostring(v[2]) .. "," .. tostring(v[3])] = true
				end
				
				for k, v in ipairs(datas) do
					new[tostring(v[1]) .. "," .. tostring(v[2]) .. "," .. tostring(v[3])] = true
				end
				
				for k, v in pairs(old) do
					if not new[k] then
						updatedata = true
						break
					end
				end
				
				for k, v in pairs(new) do
					if not old[k] then
						updatedata = true
						break
					end
				end
			end

			if updatedata then
				setElementData(localPlayer, "playerSideWeapons", datas)
			end
		end
	end)

function isActionBarVisible()
	return panelState
end