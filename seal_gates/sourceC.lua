pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(decodeString("base64", exports.seal_core:getInterfaceElements())));end)
local screenX, screenY = guiGetScreenSize()

function loadFonts()
	Rubik12 = exports.seal_core:loadFont("Rubik.ttf", respc(12), false, "proof")
	Rubik14 = exports.seal_core:loadFont("Rubik.ttf", respc(14), false, "proof")
	Rubik16 = exports.seal_core:loadFont("Rubik.ttf", respc(16), false, "proof")
	Rubik18 = exports.seal_core:loadFont("Rubik.ttf", respc(18), false, "proof")
	Rubik20 = exports.seal_core:loadFont("Rubik.ttf", respc(20), false, "proof")
end

addCommandHandler("gate",
	function ()
		local playerX, playerY, playerZ = getElementPosition(localPlayer)
		local playerInterior = getElementInterior(localPlayer)
		local playerDimension = getElementDimension(localPlayer)

		

		local lastDistance = 999999
		local nearbyGateID = false

		for k, v in pairs(availableGates) do
			if playerInterior == v[13] and playerDimension == v[14] then
				local currentDistance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, v[7], v[8], v[9])

				if lastDistance >= currentDistance then
					lastDistance = currentDistance
					nearbyGateID = k
				end
			end
		end

		if nearbyGateID then
			if lastDistance <= 8 then
				triggerServerEvent("toggleGate", localPlayer, nearbyGateID)
			end
		end
	end
)

addCommandHandler("nearbygates",
	function (commandName, maxDistance)
		if getElementData(localPlayer, "acc.adminLevel") >= 1 then
			local nearbyList = {}
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local playerInterior = getElementInterior(localPlayer)
			local playerDimension = getElementDimension(localPlayer)

			maxDistance = tonumber(maxDistance) or 15

			for k, v in pairs(availableGates) do
				if playerInterior == v[13] and playerDimension == v[14] then
					local currentDistance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, v[7], v[8], v[9])

					if currentDistance <= maxDistance then
						table.insert(nearbyList, {k, v[15], currentDistance})
					end
				end
			end

			if #nearbyList > 0 then
				outputChatBox("#768fe3[Gate]: #ffffffKözeledben lévő kapuk (" .. maxDistance .. " yard):", 255, 255, 255, true)
				
				for k, v in ipairs(nearbyList) do
					outputChatBox("    * #768fe3Azonosító: #ffffff" .. v[1] .. " | #768fe3Model: #ffffff" .. v[2] .. " | #768fe3Távolság: #ffffff" .. math.floor(v[3] * 1000) / 1000, 255, 255, 255, true)
				end
			else
				outputChatBox("#d75959[Gate]: #ffffffNincs egyetlen kapu sem a közeledben.", 255, 255, 255, true)
			end
		end
	end
)

local createGateDatas = {
	gateModelId = 968,
	time = 1000,
	groupId = 0,
	obj = false,
	stage = "closePosition",
	close = {},
	open = {}
}

local w, h = respc(500), respc(185)
local x, y = screenX/2 - w/2, screenY/2 - h/2
function onClientRender()
	local cursorX, cursorY = 0, 0

	if isCursorShowing() then
		cursorX, cursorY = getCursorPosition()
	end

	cursorX = cursorX * screenX
	cursorY = cursorY * screenY
	buttons = {}
	if createGateState == "panel" then

		dxDrawRectangle(x - 2, y - 2, w + 4, h + 4, tocolor(40, 40, 40))
		dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30))

		local x = x + respc(5)
		local w = w - respc(10)
		
		local y = y + respc(5)
		drawInput("gateModelId|5|num-only", "Gate modelID", x, y, w, respc(30), Rubik14, 1)
		local y = y + respc(35)
		drawInput("time|5|num-only", "Gate nyitási ideje (ms, 1000ms=1sec)", x, y, w, respc(30), Rubik14, 1)
		local y = y + respc(35)
		drawInput("groupId|5|num-only", "Gate frakcióID (0 = nincs)", x, y, w, respc(30), Rubik14, 1)
		local y = y + respc(40)
		drawButton("createGate", "Gate elkészítése", x, y, w, respc(30), {118, 143, 227}, 1, Rubik14)
		local y = y + respc(35)
		drawButton("closeGate", "Bezárás", x, y, w, respc(30), {215, 89, 89}, 1, Rubik14)
	elseif createGateState == "position" then
		local gateX, gateY, gateZ = getElementPosition(createGateDatas.obj)
		local gateRotX, gateRotY, gateRotZ = getElementRotation(createGateDatas.obj)
		local w, h = respc(540), respc(60)
		local x, y = screenX/2 - w/2, screenY - h - respc(140)
		dxDrawRectangle(x - 2, y - 2, w + 4, h + 4, tocolor(40, 40, 40))
		dxDrawRectangle(x, y, w, h, tocolor(30, 30, 30))

		local speedMul = 3
		if getKeyState("lshift") then
			speedMul = 9
		elseif getKeyState("lalt") then
			speedMul = 1
		end

		local x = x + respc(5)
		local y = y + respc(5)
		local w = w - respc(10)
		local h = h - respc(10)

		if activeButton == "rotate" then
			if getKeyState("mouse1") then
				if getKeyState("lctrl") then
					gateRotX = gateRotX + 0.3 * speedMul
				else
					gateRotX = gateRotX - 0.3 * speedMul
				end
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", 90, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", 90, 0, 0, tocolor(255, 255, 255))
		end
		buttons["rotate"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "rotate2" then
			if getKeyState("mouse1") then
				if getKeyState("lctrl") then
					gateRotY = gateRotY + 0.3 * speedMul
				else
					gateRotY = gateRotY - 0.3 * speedMul
				end
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", -90, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", -90, 0, 0, tocolor(255, 255, 255))
		end
		buttons["rotate2"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "rotate_l" then
			if getKeyState("mouse1") then
				gateRotZ = gateRotZ - 0.3 * speedMul
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_l.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["rotate_l"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "rotate_r" then
			if getKeyState("mouse1") then
				gateRotZ = gateRotZ + 0.3 * speedMul
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_r.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/rotate_r.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["rotate_r"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "move_l" then
			if getKeyState("mouse1") then
				gateX, gateY = getPositionFromElementOffset(createGateDatas.obj, -0.01 * speedMul, 0, 0)
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_l.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_l.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_l"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "move_r" then
			if getKeyState("mouse1") then
				gateX, gateY = getPositionFromElementOffset(createGateDatas.obj, 0.01 * speedMul, 0, 0)
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_r.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_r.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_r"] = {x, y, respc(50), respc(50)}
		
		
		local x = x - respc(60)
		local y = y - respc(70)

		dxDrawRectangle(x - respc(5) - 2, y - respc(5) - 2, respc(120) + 4, respc(60) + 4, tocolor(40, 40, 40))
		dxDrawRectangle(x - respc(5), y - respc(5), respc(120), respc(60), tocolor(30, 30, 30))
		if activeButton == "move_f" then
			if getKeyState("mouse1") then
				gateX, gateY = getPositionFromElementOffset(createGateDatas.obj, 0, 0.01 * speedMul, 0)
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_u.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_u.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_f"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "move_b" then
			if getKeyState("mouse1") then
				gateX, gateY = getPositionFromElementOffset(createGateDatas.obj, 0, -0.01 * speedMul, 0)
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_d.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_d.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_b"] = {x, y, respc(50), respc(50)}

		local y = y + respc(70)
		local x = x + respc(60)
		if activeButton == "move_u" then
			if getKeyState("mouse1") then
				gateZ = gateZ + 0.01 * speedMul
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_u.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_u.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_u"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "move_d" then
			if getKeyState("mouse1") then
				gateZ = gateZ - 0.01 * speedMul
			end
			dxDrawImage(x, y, respc(50), respc(50), "files/move_d.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/move_d.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["move_d"] = {x, y, respc(50), respc(50)}

		local x = x + respc(60)
		if activeButton == "save" then
			dxDrawImage(x, y, respc(50), respc(50), "files/save.png", 0, 0, 0, tocolor(118, 143, 227))
		else
			dxDrawImage(x, y, respc(50), respc(50), "files/save.png", 0, 0, 0, tocolor(255, 255, 255))
		end
		buttons["save"] = {x, y, respc(50), respc(50)}

		setElementPosition(createGateDatas.obj, gateX, gateY, gateZ)
		setElementRotation(createGateDatas.obj, gateRotX, gateRotY, gateRotZ)
	end
		
	activeButton = false

	if isCursorShowing() then
		for k, v in pairs(buttons) do
			if cursorX >= v[1] and cursorX <= v[1] + v[3] and cursorY >= v[2] and cursorY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

function onClientClick(key, state)
	if state == "up" then
		if activeButton then
			local buttonDetails = split(activeButton, ":")
			if buttonDetails[1] == "input" then
				selectedInput = buttonDetails[2]
			elseif buttonDetails[1] == "createGate" then
				createGateDatas.gateModelId = fakeInputs["gateModelId|5|num-only"]
				createGateDatas.time = fakeInputs["time|5|num-only"]
				createGateDatas.groupId = fakeInputs["groupId|5|num-only"]
				if not (tonumber(createGateDatas.gateModelId) and tonumber(createGateDatas.time) and tonumber(createGateDatas.groupId)) then
					exports.seal_accounts:showInfo("e", "Üresen nem hagyhatsz egy mezőt sem!")
					return
				end
				createGateDatas.obj = createObject(createGateDatas.gateModelId, Vector3(getElementPosition(localPlayer)))
				if not isElement(createGateDatas.obj) then
					exports.seal_accounts:showInfo("e", "Hibás modelID!")
					return
				end
				setElementInterior(createGateDatas.obj, getElementInterior(localPlayer))
				setElementDimension(createGateDatas.obj, getElementDimension(localPlayer))
				setElementCollisionsEnabled(createGateDatas.obj, false)
				selectedInput = false
				activeButton = false
				createGateState = "position"
				outputChatBox("#768fe3[SealMTA]: #ffffffHelyezd el a gate-t zárási pozícióba! Ha kész, kattints a mentés ikonra!", 255, 255, 255, true)
				outputChatBox("#768fe3[SealMTA]: LShift#ffffff-el gyorsabban, #768fe3LALT#ffffff-al lassabban mozgathatod a gatet!", 255, 255, 255, true)
			elseif buttonDetails[1] == "save" then
				if createGateDatas.stage == "closePosition" then
					createGateDatas.stage = "openPosition"
					createGateDatas.close = {pos = {getElementPosition(createGateDatas.obj)}, rot = {getElementRotation(createGateDatas.obj)}}
					outputChatBox("#768fe3[SealMTA]: #ffffffHelyezd el a gate-t nyitási pozícióba! Ha kész, kattints a mentés ikonra!", 255, 255, 255, true)
				elseif createGateDatas.stage == "openPosition" then
					createGateDatas.open = {pos = {getElementPosition(createGateDatas.obj)}, rot = {getElementRotation(createGateDatas.obj)}}
					triggerServerEvent("insertNewGate", resourceRoot, 
						createGateDatas.open.pos[1],
						createGateDatas.open.pos[2],
						createGateDatas.open.pos[3],	
						createGateDatas.open.rot[1],
						createGateDatas.open.rot[2],
						createGateDatas.open.rot[3],
						createGateDatas.close.pos[1],
						createGateDatas.close.pos[2],
						createGateDatas.close.pos[3],	
						createGateDatas.close.rot[1],
						createGateDatas.close.rot[2],
						createGateDatas.close.rot[3],
						getElementInterior(createGateDatas.obj),
						getElementDimension(createGateDatas.obj),
						createGateDatas.gateModelId,
						createGateDatas.time,
						createGateDatas.groupId
					)
					toggleGateCreate()
				end
			elseif buttonDetails[1] == "closeGate" then
				toggleGateCreate()
			end
		else
			selectedInput = false
		end
	end
end

function onClientCharacter(character)
	if selectedInput and character ~= "\\" and fakeInputs[selectedInput] then
		local selected = split(selectedInput, "|")

		if utf8.len(fakeInputs[selectedInput]) < tonumber(selected[2]) then
			if selected[3] == "num-only" and not tonumber(character) then
				return
			end

			if not string.find(character, "[a-zA-Z0-9#@._öüóőúűéáÖÜÓŐÚŰÉÁ ]") then
				return
			end

			fakeInputs[selectedInput] = fakeInputs[selectedInput] .. character
		end
	end
end

function onClientKey(key, press)
	if selectedInput and press and isCursorShowing() then
		cancelEvent()
		if key == "backspace" then
			removeCharacterFromInput(selectedInput)
			if getKeyState(key) then
				repeatStartTimer = setTimer(removeCharacterFromInput, 500, 1, selectedInput, true)
			end
		end
	else
		if isTimer(repeatStartTimer) then
			killTimer(repeatStartTimer)
		end

		if isTimer(repeatTimer) then
			killTimer(repeatTimer)
		end

		repeatStartTimer = nil
		repeatTimer = nil
	end
end

function removeCharacterFromInput(input, repeatTheTimer)
	if utf8.len(fakeInputs[input]) >= 1 then
		fakeInputs[input] = utf8.sub(fakeInputs[input], 1, -2)

		if string.find(input, "stack") then
			local stack = tonumber(fakeInputs[input])

			if stack then
				if stack >= 0 then
					stackAmount = tonumber(string.format("%.0f", stack))
				else
					stackAmount = 0
				end
			else
				stackAmount = 0
			end
		elseif string.find(input, "searchitem") then
			searchItems()
		end
	end

	if repeatTheTimer then
		repeatTimer = setTimer(removeCharacterFromInput, 50, 1, selectedInput, repeatTheTimer)
	end
end

local gateCreateState = false
function toggleGateCreate()
	gateCreateState = not gateCreateState
	if gateCreateState then
		addEventHandler("onClientRender", getRootElement(), onClientRender)
		addEventHandler("onClientCharacter", getRootElement(), onClientCharacter)
		addEventHandler("onClientClick", getRootElement(), onClientClick)
		addEventHandler("onClientKey", getRootElement(), onClientKey)
		createGateState = "panel"
		createGateDatas = {
			gateModelId = 980,
			time = 1000,
			groupId = 0,
			obj = false,
			stage = "closePosition",
			close = {},
			open = {}
		}
	else
		removeEventHandler("onClientRender", getRootElement(), onClientRender)
		removeEventHandler("onClientCharacter", getRootElement(), onClientCharacter)
		removeEventHandler("onClientClick", getRootElement(), onClientClick)
		removeEventHandler("onClientKey", getRootElement(), onClientKey)

		if isElement(createGateDatas.obj) then
			destroyElement(createGateDatas.obj)
		end
	end
end

addCommandHandler("creategate", 
	function()
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
			toggleGateCreate()
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadFonts()
		triggerServerEvent("syncGates", resourceRoot)
	end
)

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)

addEvent("syncGates", true)
addEventHandler("syncGates", resourceRoot,
	function(gates)
		availableGates = gates
	end
)

function getPositionFromElementOffset(element, x, y, z)
    if element then
        m = getElementMatrix(element)
        return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1], x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2], x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
    end
end