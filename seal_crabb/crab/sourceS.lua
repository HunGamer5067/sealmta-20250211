local shipDatas = {}
local cagePositions = {}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		setTimer(processCrabCrates, 1000 * 60 * 5, 0)
		setTimer(randomizeCrabPrice, 1000 * 60 * 60, 0)
		randomizeCrabPrice()
	end
)

function randomizeCrabPrice()
	local oldCrabPrice = crabPrice

	while oldCrabPrice == crabPrice do
		crabPrice = math.randomf(6.5, 57.25)
	end

	setElementData(resourceRoot, "crabPrice", crabPrice)
end

function processCrabCrates()
	local currentTick = getTickCount()

	for k, v in pairs(cagePositions) do
		if v[2] ~= "done" then
			if v[3] > 0 then
				if currentTick >= v[2] then
					cagePositions[k][2] = "done"

					if isElement(k) then
						setElementData(k, "cageIsDone", true)
					end
				end
			end
		end
	end
end

addEvent("getTheShipDatas", true)
addEventHandler("getTheShipDatas", getRootElement(),
	function (shipElement)
		if isElement(shipElement) then
			if not shipDatas[shipElement] then
				shipDatas[shipElement] = {
					numOfCrabCrates = 0,
					currentBait = {},
					crabWeights = {}
				}
			end
			triggerClientEvent(client, "syncShipDatas", shipElement, shipDatas[shipElement])
		end
	end
)

addEventHandler("onElementDestroy", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			if getVehicleType(source) == "Boat" then
				local shipModel = getElementModel(source)

				if shipModel == 453 or shipModel == 454 then
					for k, v in pairs(cagePositions) do
						if v[1] == source then
							if isElement(k) then
								destroyElement(k)
							end

							cagePositions[k] = nil
							break
						end
					end
				end

				shipDatas[source] = nil
			end
		end
	end
)

addEvent("getInCage", true)
addEventHandler("getInCage", getRootElement(),
	function (shipElement, objectElement, streamedPlayers)
		if isElement(shipElement) then
			local shipData = shipDatas[shipElement]

			if shipData then
				local cageData = cagePositions[objectElement]

				if cageData then
					local crateIndex = shipData.numOfCrabCrates + 1

					if cageData[2] == "done" then
						shipData.currentBait[crateIndex] = 0
						shipData.crabWeights[crateIndex] = cageData[3]
					else
						shipData.currentBait[crateIndex] = cageData[4]
					end

					shipData.numOfCrabCrates = shipData.numOfCrabCrates + 1
					cagePositions[objectElement] = nil

					if isElement(objectElement) then
						destroyElement(objectElement)
					end

					triggerClientEvent(streamedPlayers, "syncShipDatas", shipElement, shipData)

					exports.seal_chat:localAction(client, "kihúz egy ketrecet a vízből.")
					outputChatBox("#4adfbf[SealMTA - Rákászat]: #FFFFFFKihúztál egy ketrecet a vízből. A rákokat leadni a dokkoknál tudod (#dfb551Rák ikon #FFFFFFa térképen).", client, 0, 0, 0, true)
				end
			end
		end
	end
)

addEvent("dropCage", true)
addEventHandler("dropCage", getRootElement(),
	function (shipElement, streamedPlayers)
		if isElement(shipElement) then
			local shipData = shipDatas[shipElement]

			if shipData then
				local lastCrateIndex = shipData.numOfCrabCrates

				if lastCrateIndex > 0 then
					local shipX, shipY, shipZ = getElementPosition(shipElement)
					local isPositionOk = false

					if shipX < -3000 or shipX > 3000 then
						isPositionOk = true
					elseif shipY < 0 or shipY > 3000 then
						isPositionOk = true
					end

					if isPositionOk then
						local cageX, cageY, cageZ = getPositionFromElementOffset(shipElement, 0, -5, 0)

						if getElementModel(shipElement) == 454 then
							cageX, cageY, cageZ = getPositionFromElementOffset(shipElement, 0, -17.5, 0)
						end

						if cageX and cageY then
							local nearbyCage = false

							for k, v in pairs(cagePositions) do
								if isElement(k) then
									local thisCageX, thisCageY = getElementPosition(k)

									if getDistanceBetweenPoints2D(cageX, cageY, thisCageX, thisCageY) <= 150 then
										nearbyCage = true
										break
									end
								end
							end

							if not nearbyCage then
								if not shipData.currentBait[lastCrateIndex] then
									shipData.currentBait[lastCrateIndex] = 0
								end

								local vehicleId = getElementData(shipElement, "vehicle.dbID")
								local objectElement = createObject(replacementModels.buoy, cageX, cageY, 0 + 0.25, 180, 0, 0)

								if isElement(objectElement) then
									setElementCollisionsEnabled(objectElement, false)
									setElementData(objectElement, "cageOfShip", vehicleId)

									cagePositions[objectElement] = {
										shipElement,
										getTickCount() + 1000 * 60 * math.random(5, 10),
										shipData.currentBait[lastCrateIndex] * math.randomf(2.9, 12.7),
										shipData.currentBait[lastCrateIndex]
									}
								end

								shipData.currentBait[lastCrateIndex] = 0
								shipData.numOfCrabCrates = shipData.numOfCrabCrates - 1

								triggerClientEvent(streamedPlayers, "playCrabSound", shipElement, "files/splash.mp3", cageX, cageY, 0 + 0.25)
								triggerClientEvent(streamedPlayers, "syncShipDatas", shipElement, shipData)

								exports.seal_chat:localAction(client, "bedob egy ketrecet a vízbe.")

								outputChatBox("#4adfbf[SealMTA - Rákászat]: #FFFFFFBedobtál egy ketrecet a vízbe. #bc873d10-15 perc #FFFFFFmúlva ki is húzhatod.", client, 0, 0, 0, true)
								outputChatBox("#4adfbf[SealMTA - Rákászat]: #FFFFFFAmint a ketrec megtelt, a hajó radarján a #d75959piros #FFFFFFrák ikon #dfb551sárgára #FFFFFFvált.", client, 0, 0, 0, true)
								outputChatBox("#4adfbf[SealMTA - Rákászat]: #bc873dTIPP: #FFFFFFjelöld meg a térképen ezt a helyet, hogy tudd hova dobtad a ketreceket.", client, 0, 0, 0, true)
							else
								exports.seal_hud:showInfobox(client, "w", "Már van egy ketrec ledobva 150 yardos körzetben!")
							end
						end
					else
						exports.seal_hud:showInfobox(client, "w", "Itt nem lehet kidobni a ketrecet, menj kicsit kintebb, a nyílt vizekre.")
					end
				end
			end
		end
	end
)

addEvent("syncShipDims", true)
addEventHandler("syncShipDims", getRootElement(),
	function (dimensionId)
		if isElement(source) then
			if dimensionId == 0 then
				setElementInterior(source, 0)
			else
				setElementInterior(source, 123)
			end

			setElementDimension(source, dimensionId)
		end
	end
)
