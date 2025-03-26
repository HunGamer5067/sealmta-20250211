screenWidth, screenHeight = guiGetScreenSize()

local jewelryPermission = false

local jewelryButtonHover = false
local jewelryButtonArgument = false
local jewelryButtonTempArg = false
local jewelryButtonTemp = false
local jewelryButtonTooltip = false

local jewelryButtonObjects = {}
local jewelryObjectBox = false
local jewelryObjectDoor = false

local jewelryCurrentState = false
local jewelryInMinigame = false

local jewelryCaseObjects = {}

addEvent("startClientSound", true)
addEventHandler("startClientSound", root,
	function (filePath)
		playSound3D(filePath, jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ)
	end
)

addEvent("syncJewelryState", true)
addEventHandler("syncJewelryState", root,
	function (jewelryState)
		if jewelryCurrentState ~= jewelryState then
			jewelryCurrentState = jewelryState
		end
	end
)

addEvent("syncJewelryObjects", true)
addEventHandler("syncJewelryObjects", root,
	function (jewelryBoxElement, jewelryDoorElement, jewelryButtonElements)
		if jewelryBoxElement and jewelryDoorElement then
			jewelryObjectBox = jewelryBoxElement
			jewelryObjectDoor = jewelryDoorElement
			jewelryButtonObjects = jewelryButtonElements
		end
	end
)

addEvent("tryToStartCrowbarMinigame", true)
addEventHandler("tryToStartCrowbarMinigame", root,
	function ()
		initMinigame()
	end
)

addEvent("syncJewelryCaseObjects", true)
addEventHandler("syncJewelryCaseObjects", root,
	function (jewelryCaseObjectsTable)
		jewelryCaseObjects = jewelryCaseObjectsTable
	end
)

local alarmSound = false

addEvent("syncJewelryAlarm", true)
addEventHandler("syncJewelryAlarm", root,
	function (alarmState)
		if isElement(alarmSound) then
			destroyElement(alarmSound)
		end

		if alarmState then
			alarmSound = playSound3D("files/sounds/alarm.mp3", 1933.1400146484, -2123.310546875, 13.6171875, true)
			setSoundVolume(alarmSound, 1)
			setSoundMaxDistance(alarmSound, 100)
		end
	end
)

addEvent("syncJewelrySound", true)
addEventHandler("syncJewelrySound", root,
	function (soundType, playerX, playerY, playerZ)
		if soundType == "glassbreak" then
			playSound3D("files/sounds/glassbreak.mp3", playerX, playerY, playerZ)
		elseif soundType == "loot" then
			playSound3D("files/sounds/loot.mp3", playerX, playerY, playerZ)
		end
	end
)

local jewelryRobStarted = false
local jewelryPedDuck = false
local jewelryPedReport = false
local jewelryPedFear = 0
local jewelryPedFearTo = 0
local jewelryPedFearMax = 1
local jewelryPedFearMin = 0

addEvent("syncJewelryPedFear", true)
addEventHandler("syncJewelryPedFear", root,
	function (fearLevel)
		if not jewelryRobStarted then
			jewelryRobStarted = true
		end

		jewelryPedFearTo = fearLevel
	end
)

local playerLastTask = 0
local playerLastTarget = false
local jewelryFearDone = false

addEventHandler("onClientPreRender", root, 
	function (delta)
		local playerCurrentTarget = getPedTarget(localPlayer)

		if playerCurrentTarget then
			local playerTargetType = getElementType(playerCurrentTarget)

			if playerTargetType == "ped" then
				local playerCurrentTask = getPedTask(localPlayer, "secondary", 0)

				if playerLastTask ~= playerCurrentTask then
					if (playerCurrentTask == "TASK_SIMPLE_USE_GUN" or playerLastTask == "TASK_SIMPLE_USE_GUN") then
						triggerServerEvent("tryToStartJewelryRob", localPlayer)
					end	

					playerLastTask = playerCurrentTask
				end

				if playerLastTarget ~= playerCurrentTarget then
					playerLastTarget = playerCurrentTarget

					if playerLastTarget and playerLastTask == "TASK_SIMPLE_USE_GUN" then
						triggerServerEvent("tryToStartJewelryRob", localPlayer, playerLastTask)
					end
				end
			end
		end

		if jewelryRobStarted then
			if not jewelryPedDuck and not jewelryPedReport then
				if jewelryPedFearTo == 0 then
					jewelryPedFear = jewelryPedFear - delta / 3500 * 1

					if jewelryPedFear < 0 and not jewelryFearDone then
						jewelryPedFear = 0
						jewelryPedReport = true

						triggerServerEvent("jewelryFearFailed", localPlayer)
						jewelryFearDone = true
					end
				else
					jewelryPedFear = jewelryPedFear + delta / 3500 * 1

					if jewelryPedFear > 1 and not jewelryFearDone then
						jewelryPedFear = 1
						jewelryFearDone = true

						triggerServerEvent("jewelryFearSuccess", localPlayer)
					end
				end
			end
		end
	end
)

addEvent("syncJewelryFearSuccess", true)
addEventHandler("syncJewelryFearSuccess", root,
	function (jewelryPed)
		jewelryPedDuck = jewelryPed
	end
)

addEvent("syncJewelryBlip", true)
addEventHandler("syncJewelryBlip", root,
	function (player)
		local blipElement = createBlip(0, 0, 0, 0, 2, 215, 89, 89)
		attachElements(blipElement, player)
		setElementData(blipElement, "blipTooltipText", "Ékszerbolt behatoló!")
		setTimer(destroyElement, 60000, 1, blipElement)
	end
)

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedResource)
		if startedResource ~= getThisResource() then
			return
		end

		local hasPermission = false

		for i = 1, #jewelryFactions do
			local factionId = jewelryFactions[i]

			if factionId then
				local isStaff = getElementData(localPlayer, "acc.adminLevel") >= 7
				local inIllegal = exports.seal_groups:isPlayerInGroup(localPlayer, factionId) or false

				if inIllegal or isStaff then
					hasPermission = true
					break
				end
			end
		end

		if hasPermission then
			if not jewelryPermission then
				jewelryPermission = hasPermission
			end
		end
	end
)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName, oldValue, newValue)
		if dataName == "player.groups" then
			local hasPermission = false

			for i = 1, #jewelryFactions do
				local factionId = jewelryFactions[i]

				if factionId then
					local isStaff = getElementData(localPlayer, "acc.adminLevel") >= 7
					local inIllegal = exports.seal_groups:isPlayerInGroup(localPlayer, factionId) or false

					if inIllegal or isStaff then
						hasPermission = true
						break
					end
				end
			end

			if hasPermission then
				if not jewelryPermission then
					jewelryPermission = hasPermission
				end
			else
				if jewelryPermission then
					jewelryPermission = nil
				end
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function (mouseButton, mouseState)
		if mouseButton == "left" and mouseState == "down" then
			if jewelryInMinigame then
				return
			end

			local stateCrowbar = jewelryButtonHover and jewelryButtonHover == "crowbar"
			local stateSwitches = jewelryButtonHover and jewelryButtonHover == "electric"
			local stateHammer = jewelryButtonHover and jewelryButtonHover == "hammer"
			local stateBag = jewelryButtonHover and jewelryButtonHover == "bag"

			if stateCrowbar then
				triggerServerEvent("tryToStartCrowbar", localPlayer)
			elseif stateSwitches and jewelryButtonArgument then
				triggerServerEvent("tryToStartSwitches", localPlayer, jewelryButtonArgument)
			elseif stateHammer then
				triggerServerEvent("tryToBreakGlass", localPlayer, jewelryCaseObjects[jewelryButtonArgument], jewelryButtonArgument)
			elseif stateBag then
				triggerServerEvent("tryToGetJewelry", localPlayer, jewelryCaseObjects[jewelryButtonArgument], jewelryButtonArgument)
			end
		end
	end
)

addEventHandler("onClientRender", root,
	function ()
		if jewelryRobStarted then
			if jewelryPedDuck then
				local a, b = getPedAnimation(jewelryPedDuck)
				if a ~= "ped" or b ~= "duck_cower" then
				  setPedAnimation(jewelryPedDuck, "ped", "duck_cower", -1, false, false, false)
				end
			else
				local playerX, playerY, playerZ = getElementPosition(localPlayer)
				local jewelryDistance = getDistanceBetweenPoints3D(1924.7586669922, -2123.9089355469, 14.8171875, playerX, playerY, playerZ)

				if jewelryDistance < 5 then
					local worldX, worldY = getScreenFromWorldPosition(1924.7586669922, -2123.9089355469, 14.8171875, 32)

					if worldX and worldY then
						local fearLineWidth = 98
						local fearLineHeight = 10

						local fearLinePosX = worldX - fearLineWidth / 2
						local fearLinePosY = worldY - fearLineHeight / 2

						dxDrawRectangle(fearLinePosX, fearLinePosY, fearLineWidth, fearLineHeight, tocolor(26, 27, 31, 255))
						dxDrawRectangle(fearLinePosX + 2, fearLinePosY + 2, (fearLineWidth - 4) * jewelryPedFear, fearLineHeight - 4, tocolor(243, 90, 90, 255))
					end
				end
			end
		end

		if jewelryPermission then
			local jewelryButtonTemp = false
			local jewelryButtonTooltip = false
			local jewelryButtonTempArg = false
	
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local cursorX, cursorY = getCursorPosition()
	
			if cursorX then
				cursorX = cursorX * screenWidth
				cursorY = cursorY * screenHeight
			end

			if jewelryCurrentState == "crowbar" then
				if jewelryObjectBox and jewelryObjectDoor then
					local jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ = getElementPosition(jewelryObjectDoor)
					local jewelryDistance = getDistanceBetweenPoints3D(jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ, playerX, playerY, playerZ)

					if jewelryDistance < 2.5 then
						local worldX, worldY = getScreenFromWorldPosition(jewelryBoxPosX - 0.45, jewelryBoxPosY, jewelryBoxPosZ, 32)

						if worldX and worldY then
							local distanceAlpha = 255 - jewelryDistance / 2.5 * 255

							if jewelryDistance < 1.2 and isMouseInPosition(worldX - 16, worldY - 16, 32, 32) then
								jewelryButtonTemp = "crowbar"
								jewelryButtonTooltip = "Felfeszítés"

								dxDrawRectangle(worldX - 16, worldY - 16, 32, 32, tocolor(0, 0, 0, 255))
								dxDrawImage(worldX - 16, worldY - 16, 32, 32, "files/images/crowbar.dds", 0, 0, 0, tocolor(124, 197, 118, 255))
							else
								dxDrawRectangle(worldX - 16, worldY - 16, 32, 32, tocolor(0, 0, 0, distanceAlpha))
								dxDrawImage(worldX - 16, worldY - 16, 32, 32, "files/images/crowbar.dds", 0, 0, 0, tocolor(255, 255, 255, distanceAlpha))
							end
						end
					end
				end
			elseif jewelryCurrentState == "switches" then
				for i = 1, #jewelryButtonObjects do
					local jewelryObject = jewelryButtonObjects[i]

					if jewelryObject then
						local jewelrySwitchId = getElementData(jewelryObject, "switchIdentity") or false

						if jewelrySwitchId then
							local jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ = getElementPosition(jewelryObject)
							local jewelryDistance = getDistanceBetweenPoints3D(jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ, playerX, playerY, playerZ)

							if jewelryDistance < 2.5 then
								local worldX, worldY = getScreenFromWorldPosition(jewelryBoxPosX, jewelryBoxPosY, jewelryBoxPosZ, 32)

								if worldX and worldY then
									local distanceAlpha = 255 - jewelryDistance / 2.5 * 255

									if jewelryDistance < 1.2 and isMouseInPosition(worldX - 14, worldY - 14, 28, 28) then
										jewelryButtonTemp = "electric"
										jewelryButtonTooltip = i .. ". Megszakító lekapcsolása"
										jewelryButtonTempArg = jewelrySwitchId

										dxDrawRectangle(worldX - 16, worldY - 16, 28, 28, tocolor(0, 0, 0, 255))
										dxDrawImage(worldX - 16, worldY - 16, 28, 28, "files/images/electric.dds", 0, 0, 0, tocolor(124, 197, 118, 255))
									else
										dxDrawRectangle(worldX - 16, worldY - 16, 28, 28, tocolor(0, 0, 0, distanceAlpha))
										dxDrawImage(worldX - 16, worldY - 16, 28, 28, "files/images/electric.dds", 0, 0, 0, tocolor(255, 255, 255, distanceAlpha))
									end
								end
							end
						end
					end
				end
			elseif jewelryCurrentState == "hammer" then
				for i = 1, #jewelryCaseObjects do
					local jewelryObject = jewelryCaseObjects[i]
		
					if jewelryObject then
						local jewelryCasePosX, jewelryCasePosY, jewelryCasePosZ = getElementPosition(jewelryObject)
						local jewelryCaseDistance = getDistanceBetweenPoints3D(jewelryCasePosX, jewelryCasePosY, jewelryCasePosZ, playerX, playerY, playerZ)
		
						if jewelryCaseDistance < 2.5 then
							local worldX, worldY = getScreenFromWorldPosition(jewelryCasePosX, jewelryCasePosY, jewelryCasePosZ + 0.2, 32)
		
							if worldX and worldY then
								local jewelryCaseLooted = getElementData(jewelryObject, "isJewelryCaseLooted") or false
		
								if not jewelryCaseLooted then
									local distanceAlpha = 255 - jewelryCaseDistance / 2.5 * 255
		
									local jewelryCaseBreaked = getElementData(jewelryObject, "isJewelryCaseBreaked") or false	
									local jewelryButtonTexture = "hammer"
		
									if jewelryCaseBreaked then
										jewelryButtonTexture = "bag"
									end
		
									if jewelryCaseDistance < 1.2 and isMouseInPosition(worldX - 16, worldY - 16, 32, 32) then
										if jewelryCaseBreaked then
											jewelryButtonTemp = "bag"
											jewelryButtonTooltip = "Ékszerek kivétele"
											jewelryButtonTempArg = i
										else
											jewelryButtonTemp = "hammer"
											jewelryButtonTooltip = "Üveg kitörése"
											jewelryButtonTempArg = i
										end
		
										dxDrawRectangle(worldX - 16, worldY - 16, 32, 32, tocolor(0, 0, 0, 255))
										dxDrawImage(worldX - 16, worldY - 16, 32, 32, "files/images/" .. jewelryButtonTexture .. ".dds", 0, 0, 0, tocolor(124, 197, 118, 255))
									else
										dxDrawRectangle(worldX - 16, worldY - 16, 32, 32, tocolor(0, 0, 0, distanceAlpha))
										dxDrawImage(worldX - 16, worldY - 16, 32, 32, "files/images/" .. jewelryButtonTexture .. ".dds", 0, 0, 0, tocolor(255, 255, 255, distanceAlpha))
									end
								end
							end
						end
					end
				end
			end

			if jewelryButtonHover ~= jewelryButtonTemp then
				jewelryButtonHover = jewelryButtonTemp

				exports.seal_gui:setCursorType(jewelryButtonHover and "link" or "normal")
				exports.seal_gui:showTooltip(jewelryButtonHover and jewelryButtonTooltip)
			end

			if jewelryButtonArgument ~= jewelryButtonTempArg then
				jewelryButtonArgument = jewelryButtonTempArg
			end
		end
	end
)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end