local screenWidth, screenHeight = guiGetScreenSize()

local carshopState = false
local carshopCategory = false
local carshopPageStart = 0

local changeFadeIn = false
local changeFadeOut = false
local changeTarget = false
local changeAlpha = 1
local changeInterpolateTime = 250

local blackSlideX = -screenWidth
local blackSlideIn = false
local blackSlideOut = false
local blackRenderEnded = false
local blackMagicHappening = false
local blackInterpolateTime = 850

local isInside = false
local inForcedLeave = false

local vehicleColors = {0, 0, 0}

local entrancePosnX = false
local entrancePosnY = false
local entrancePosnZ = false

local colorPicker = false
local colorPickerParent = false

local colorSliderH = false
local colorSliderS = false
local colorSliderL = false

local backgroundColorH1 = false
local backgroundColorH2 = false
local backgroundColorH3 = false

local backgroundColorS1 = false
local backgroundColorS2 = false

local backgroundColorL1 = false
local backgroundColorL2 = false
local backgroundColorL3 = false

local plateInput = false
local plateActive = false

local buttonContainer = {}
local buttonActive = false

local vehicleEconomySelected = 1
local vehicleSelected = false
local vehiclePreview = false

local licenseText = "12345678"
local licenseMaxLength = 8

local maximumLimit = false
local currentLimit = false

local vehicleDriveType = false
local vehicleFuelType = false

local vehicleTankCapacity = false
local vehicleBootCapacity = false

local vehicleName = false
local vehicleManifacturer = false
local vehicleSign = false

local vehicleShopDatas = {}
local vehicleShopVehicles = {}

local promptFadeIn = false
local promptFadeOut = false
local promptAlpha = 0
local promptInterpolateTime = 250
local promptState = false

local promptWidth = 465
local promptHeight = 450
local promptPosnX = (screenWidth - promptWidth) / 2
local promptPosnY = (screenHeight - promptHeight) / 2

local promptHasCustomPlate = false

local rectangleWidth = 300
local rectangleHeight = 140
local rectangleSpacing = 20

local rectangleMaximum = math.floor((screenWidth + rectangleSpacing) / (rectangleWidth + rectangleSpacing))
local rectangleTotalWidth = (rectangleWidth * rectangleMaximum) + (rectangleSpacing * (rectangleMaximum - 1))

local rectangleStartPosnX = (screenWidth - rectangleTotalWidth) / 2
local rectangleStartPosnY = screenHeight - rectangleHeight - 20

local waitingForServerResponse = false

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		if isInside then
			exports.seal_hud:showHUD()

			showChat(true)
			showCursor(false)

			setElementDimension(localPlayer, 0)
			setElementPosition(localPlayer, entrancePosnX, entrancePosnY, entrancePosnZ)
			setElementFrozen(localPlayer, false)
			setCameraTarget(localPlayer)
		end
	end
)

addEvent("onColorPickerChanged", false)
addEventHandler("onColorPickerChanged", root,
	function ()
		refreshColorPicker()
	end
)

addEvent("onPlateInputChange", true)
addEventHandler("onPlateInputChange", root,
	function (newInputValue)
		if newInputValue then
			licenseText = newInputValue:gsub("[^%a%d-]", "")
			licenseText = licenseText

			if vehiclePreview then
				exports.seal_gui:setInputValue(plateInput, licenseText)
				setVehiclePlateText(vehiclePreview, licenseText)
			end
		end
	end
)

addEvent("gotResponseFromServer", true)
addEventHandler("gotResponseFromServer", root,
	function (serverResponse)
		if serverResponse then
			local wasSuccessful = serverResponse == "successful"
			local wasNotSuccessful = serverResponse == "unsuccessful"

			if wasSuccessful then
				exports.seal_gui:showInfobox("successful", "Sikeresen megvásároltad a kiválasztott járművet!")

				showPrompt(false, true)
			elseif wasNotSuccessful then
				waitingForServerResponse = false
			end
		end
	end
)

addEvent("syncronizeShopVehicles", true)
addEventHandler("syncronizeShopVehicles", root,
	function (syncronizedData)
		vehicleContainer = syncronizedData

		if vehicleContainer then
			vehicleShopVehicles = getVehiclesByCategory(carshopCategory)

			if vehicleShopVehicles then
				table.sort(vehicleShopVehicles,
					function (a, b)
						return utf8.lower(b.modelName) > utf8.lower(a.modelName)
					end
				)

				if not vehicleSelected then
					vehicleSelected = 1
				end

				local vehicleDatas = vehicleShopVehicles[vehicleSelected]

				if vehicleDatas then
					local categoryDatas = vehicleCategoryShops[carshopCategory]

					if categoryDatas then
						vehiclePreview = createVehicle(vehicleDatas.modelId, categoryDatas[1], categoryDatas[2], categoryDatas[3])

						if vehiclePreview then
							local randomR = math.random(0, 255)
							local randomG = math.random(0, 255)
							local randomB = math.random(0, 255)

							if randomR and randomG and randomB then
								setVehicleColor(vehiclePreview, randomR, randomG, randomB)
							end

							setElementRotation(vehiclePreview, 0, 0, categoryDatas[4])
							setElementFrozen(vehiclePreview, true)

							setVehiclePlateText(vehiclePreview, licenseText)
						end

						entrancePosnX, entrancePosnY, entrancePosnZ = getElementPosition(localPlayer)

						isInside = true
						blackMagicHappening = "showshop"

						showCursor(true)
						showChat(false)

						changeVehicleDatas(vehicleSelected, false, true)

						if not blackSlideIn then
							blackSlideIn = getTickCount()
						end

						addEventHandler("onClientRender", root, renderCarshop, true, "low-99999999999999999999999999999999")
						addEventHandler("onClientKey", root, carshopKey)

						exports.seal_hud:hideHUD()
						exports.seal_tuning:applyHandling(vehiclePreview)

						setElementDimension(vehiclePreview, getElementData(localPlayer, "playerID"))
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", root,
	function (mouseButton, mouseState, _, _, _, _, _, clickedElement)
		if blackSlideIn or blackSlideOut then
			return
		end

		if promptFadeIn or promptFadeOut then
			return
		end

		if inForcedLeave then
			return
		end

		if mouseButton == "right" and mouseState == "up" then
			if clickedElement then
				local isCarshopPed = getElementData(clickedElement, "carshop.Ped")

				if isCarshopPed then
					local pedCategory = getElementData(clickedElement, "carshop.Category")

					if pedCategory then
						local sourceX, sourceY, sourceZ = getElementPosition(localPlayer)
						local pedPosX, pedPosY, pedPosZ = getElementPosition(clickedElement)

						if sourceX and pedPosX then
							local distanceBetween = getDistanceBetweenPoints3D(pedPosX, pedPosY, pedPosZ, sourceX, sourceY, sourceZ)

							if distanceBetween < 2 then
								if isInside then
									return
								end

								if isPedInVehicle(localPlayer) then
									exports.seal_gui:showInfobox("warning", "Előszőr pattanj ki a járműből.")
									return
								end

								showCarshop(true, pedCategory)
							else
								if distanceBetween < 5 then
									exports.seal_gui:showInfobox("warning", "Túl távol vagy az autókereskedő NPCtől, menj közelebb!")
								end
							end
						end
					end
				end
			end
		end

		if mouseButton == "left" and mouseState == "up" then
			if carshopState then
				if not buttonActive then
					return
				end

				if promptState then
					local buttonDetails = split(buttonActive, ":")

					if buttonDetails[1] == "buyPrompt" then
						local buttonAction = buttonDetails[2]

						if buttonAction == "buy" then
							if waitingForServerResponse then
								return
							end
							waitingForServerResponse = true

							triggerServerEvent("tryToBuyVehicle", localPlayer, vehicleShopVehicles[vehicleSelected].modelId, vehicleEconomySelected, vehicleColors, false, carshopCategory)
						elseif buttonAction == "buywcustom" then
							if waitingForServerResponse then
								return
							end
							waitingForServerResponse = true

							local plateText = exports.seal_gui:getInputValue(plateInput)

							if plateText then
								triggerServerEvent("tryToBuyVehicle", localPlayer, vehicleShopVehicles[vehicleSelected].modelId, vehicleEconomySelected, vehicleColors, plateText, carshopCategory)
							end
						elseif buttonAction == "cancel" then
							showPrompt(false)
						end
					end
				else
					if promptState then
						return
					end

					if buttonActive ~= "plateRectangle" then
						if exports.seal_gui:getActiveInput() == plateInput then
							exports.seal_gui:setActiveInput(false)
						end
					end

					local buttonDetails = split(buttonActive, ":")

					if buttonDetails[1] == "plateRectangle" then
						if exports.seal_gui:getActiveInput() == plateInput then
							return
						end

						exports.seal_gui:setActiveInput(plateInput)
					elseif buttonDetails[1] == "paymentMode" then
						local paymentId = tonumber(buttonDetails[2])

						if paymentId then
							if vehicleEconomySelected ~= paymentId then
								vehicleEconomySelected = paymentId
							end
						end
					elseif buttonDetails[1] == "tryToBuyVehicle" then
						if promptState then
							return
						end

						showPrompt(true)
					end
				end
			end
		end
	end
)

addEventHandler("onClientElementColShapeHit", localPlayer,
	function (colElement, matchingDimension)
		if not colElement then
			return
		end

		if not isElement(colElement) then
			return
		end

		if not matchingDimension then
			return
		end

		local isValidCol = colElement and matchingDimension

		if isValidCol then
			local isCarshopCol = getElementData(colElement, "carshop.Col") or false

			if isCarshopCol then
				exports.seal_gui:showInfobox("info", "Autókereskedésbe lépéshez jobb klikkelj az NPCre.")
			end
		end
	end
)

function showPrompt(newState, boughtWasSuccessful)
	if promptState ~= newState then
		promptState = newState

		if newState then
			if not promptFadeIn then
				promptFadeIn = getTickCount()
			end

			if exports.seal_gui:getActiveInput() == plateInput then
				exports.seal_gui:setActiveInput(false)
			end

			if not promptHasCustomPlate then
				local plateInputValue = exports.seal_gui:getInputValue(plateInput)

				if plateInputValue then
					if plateInputValue ~= "12345678" and plateInputValue ~= "" then
						promptHasCustomPlate = true
					end
				end
			end

			if promptHasCustomPlate then
				promptWidth = 465
				promptHeight = 290
				promptPosnX = (screenWidth - promptWidth) / 2
				promptPosnY = (screenHeight - promptHeight) / 2
			else
				promptWidth = 465
				promptHeight = 250
				promptPosnX = (screenWidth - promptWidth) / 2
				promptPosnY = (screenHeight - promptHeight) / 2
			end
		else
			if not promptFadeOut then
				promptFadeOut = getTickCount()
			end

			if boughtWasSuccessful then
				inForcedLeave = true
			end
		end
	end
end

function showCarshop(newState, categoryType)
	if carshopState ~= newState then
		carshopState = newState

		if newState and categoryType then
			carshopCategory = categoryType

			if carshopCategory then
				if not vehicleShopCategorys[categoryType] and categoryType ~= "default" then
					return
				end

				triggerServerEvent("tryToSyncronizeShopVehicles", localPlayer)
			end
		else
			blackMagicHappening = "closeshop"

			if not blackSlideIn then
				blackSlideIn = getTickCount()
			end
		end
	end
end

function carshopKey(keyboardKey, keyboardState)
    if carshopState then
        if keyboardState then
        	if promptState then
        		return
        	end

        	if promptFadeIn or promptFadeOut then
        		return
        	end

        	if blackSlideIn or blackSlideOut then
        		return
        	end

        	if changeTarget then
        		return
        	end

        	if changeFadeIn or changeFadeOut then
        		return
        	end

        	if exports.seal_gui:getActiveInput() == plateInput then
        		return
        	end

        	if inForcedLeave then
        		return
        	end

        	if keyboardKey == "backspace" then
        		inForcedLeave = true

        		if inForcedLeave then
        			showCarshop(false)
        		end
        	end

            if keyboardKey == "arrow_l" then
                vehicleSelected = vehicleSelected - 1

                if vehicleSelected < 1 then
                    vehicleSelected = #vehicleShopVehicles

                    if #vehicleShopVehicles > rectangleMaximum then
                        carshopPageStart = #vehicleShopVehicles - rectangleMaximum
                    end
                elseif #vehicleShopVehicles > rectangleMaximum then
                    if vehicleSelected <= carshopPageStart then
                        carshopPageStart = math.max(0, carshopPageStart - rectangleMaximum)
                    end
                end

                if vehicleSelected then
                	changeVehicleDatas(vehicleSelected)
                end
            elseif keyboardKey == "arrow_r" then
                vehicleSelected = vehicleSelected + 1

                if vehicleSelected > #vehicleShopVehicles then
                    vehicleSelected = 1
                    carshopPageStart = 0
                elseif #vehicleShopVehicles > rectangleMaximum then
                    if vehicleSelected > carshopPageStart + rectangleMaximum then
                        carshopPageStart = math.min(carshopPageStart + rectangleMaximum, #vehicleShopVehicles - rectangleMaximum)
                    end
                end

                if vehicleSelected then
                	changeVehicleDatas(vehicleSelected)
                end
            end

            if keyboardKey == "arrow_l" or keyboardKey == "arrow_r" then
	            if vehicleSelected then
	            	local selectedData = vehicleShopVehicles[vehicleSelected]

	            	if selectedData then
	            		changeTarget = vehicleSelected

	            		if not changeFadeOut then
	            			changeFadeOut = getTickCount()
	            		end
	            	end
	            end
	        end
        end
    end
end

function destroyColorPicker()
	if colorPickerParent then
		exports.seal_gui:deleteGuiElement(colorPickerParent)
	end
	colorPickerParent = false

	colorSliderH = false
	colorSliderS = false
	colorSliderL = false

	backgroundColorH1 = false
	backgroundColorH2 = false
	backgroundColorH3 = false

	backgroundColorS1 = false
	backgroundColorS2 = false

	backgroundColorL1 = false
	backgroundColorL2 = false
	backgroundColorL3 = false
end

function refreshColorPicker()
	local hslHueValue = exports.seal_gui:getSliderValue(colorSliderH)
	local hslSatValue = exports.seal_gui:getSliderValue(colorSliderS)
	local hslLigValue = exports.seal_gui:getSliderValue(colorSliderL)

	local convertedR, convertedG, convertedB = convertHSLToRGB(hslHueValue, hslSatValue, hslLigValue)

	if backgroundColorH1 then
		exports.seal_gui:setGuiBackground(backgroundColorH1, "solid", {convertHSLToRGB(0, 0, hslLigValue)})
	end

	if backgroundColorH2 then
		exports.seal_gui:setImageColor(backgroundColorH2, {255, 255, 255, hslSatValue * 255})
	end

	local lightnessR, lightnessG, lightnessB = convertHSLToRGB(0, 0, hslLigValue)
	local lightnessA = math.abs(hslLigValue - 0.5) / 0.5 * 255

	if backgroundColorH3 and lightnessR and lightnessG and lightnessB then
		exports.seal_gui:setGuiBackground(backgroundColorH3, "solid", {lightnessR, lightnessG, lightnessB, lightnessA})
	end

	if backgroundColorS1 then
		exports.seal_gui:setGuiBackground(backgroundColorS1, "solid", {convertHSLToRGB(hslHueValue, 0, hslLigValue)})
	end

	if backgroundColorS2 then
		exports.seal_gui:setImageColor(backgroundColorS2, {convertHSLToRGB(hslHueValue, 1, hslLigValue)})
	end

	if backgroundColorL3 then
		exports.seal_gui:setImageColor(backgroundColorL3, {convertHSLToRGB(hslHueValue, hslSatValue, 0.5)})
	end

	if colorSliderH and colorSliderS and colorSliderL then
		exports.seal_gui:setSliderColor(colorSliderH, {0, 0, 0, 0}, convertedR, convertedG, convertedB)
		exports.seal_gui:setSliderColor(colorSliderS, {0, 0, 0, 0}, convertedR, convertedG, convertedB)
		exports.seal_gui:setSliderColor(colorSliderL, {0, 0, 0, 0}, convertedR, convertedG, convertedB)
	end

	if convertedR and convertedG and convertedB then
		vehicleColors = {convertedR, convertedG, convertedB}
	end

	if vehiclePreview then
		setVehicleColor(vehiclePreview, convertedR, convertedG, convertedB)
	end
end

function createColorPicker(selectedVehicle)
	if selectedVehicle then
		local vehicleDatas = vehicleShopVehicles[selectedVehicle]

		if vehicleDatas then
			destroyColorPicker()

			local vehiclePriceDollar = vehicleDatas.priceMoney and formatNumber(vehicleDatas.priceMoney, " ")
			local vehiclePricePremium = vehicleDatas.pricePremium and formatNumber(vehicleDatas.pricePremium, " ")

			local colorPickerSizeX = 250
			local colorPickerSizeY = 12

			local colorPickerSliderH = 20

			if colorPickerSizeX and colorPickerSizeY then
				local colorPickerPosnX = rectangleStartPosnX + rectangleTotalWidth - colorPickerSizeX + 18
				local colorPickerPosnY = rectangleStartPosnY - 25 - 10 - 225

				if colorPickerPosnX and colorPickerPosnY then
					if vehiclePriceDollar or vehiclePricePremium then
						if (vehiclePriceDollar and not vehicleDatas.premiumOnly) and (vehiclePricePremium and vehicleDatas.premiumCanBuy) then
							colorPickerPosnY = colorPickerPosnY - 225
						elseif vehiclePriceDollar and not vehicleDatas.premiumOnly then
							colorPickerPosnY = colorPickerPosnY - 160
						elseif vehiclePricePremium and vehicleDatas.premiumCanBuy then
							colorPickerPosnY = colorPickerPosnY - 160
						end
					else
						colorPickerPosnY = colorPickerPosnY - 160
					end

					colorPickerParent = exports.seal_gui:createGuiElement("null", 0, 0, 0, 0)

					backgroundColorH1 = exports.seal_gui:createGuiElement("rectangle", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)
				 	backgroundColorH2 = exports.seal_gui:createGuiElement("image", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)
					backgroundColorH3 = exports.seal_gui:createGuiElement("rectangle", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)

					colorSliderH = exports.seal_gui:createGuiElement("slider", colorPickerPosnX + 8, colorPickerPosnY, colorPickerSizeX - 16, colorPickerSliderH, colorPickerParent)

					colorPickerPosnY = colorPickerPosnY + 20 + 8

					backgroundColorS1 = exports.seal_gui:createGuiElement("rectangle", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)
					backgroundColorS2 = exports.seal_gui:createGuiElement("image", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)

					colorSliderS = exports.seal_gui:createGuiElement("slider", colorPickerPosnX + 8, colorPickerPosnY, colorPickerSizeX - 16, colorPickerSliderH, colorPickerParent)

					colorPickerPosnY = colorPickerPosnY + 20 + 8

					backgroundColorL1 = exports.seal_gui:createGuiElement("rectangle", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, (colorPickerSizeX - 16 - colorPickerSliderH) / 2, colorPickerSizeY, colorPickerParent)
					backgroundColorL2 = exports.seal_gui:createGuiElement("rectangle", colorPickerPosnX + 8 + 10 + (colorPickerSizeX - 16 - colorPickerSliderH) / 2, colorPickerPosnY + 10 - 6, (colorPickerSizeX - 16 - colorPickerSliderH) / 2, colorPickerSizeY, colorPickerParent)
					backgroundColorL3 = exports.seal_gui:createGuiElement("image", colorPickerPosnX + 8 + 10, colorPickerPosnY + 10 - 6, colorPickerSizeX - 16 - colorPickerSliderH, colorPickerSizeY, colorPickerParent)

					colorSliderL = exports.seal_gui:createGuiElement("slider", colorPickerPosnX + 8, colorPickerPosnY, colorPickerSizeX - 16, colorPickerSliderH, colorPickerParent)

					if backgroundColorH2 then
						exports.seal_gui:setImageDDS(backgroundColorH2, ":seal_carshop/files/images/col3.dds")
					end

					if colorSliderH then
						exports.seal_gui:setSliderSize(colorSliderH, 20)
						exports.seal_gui:setSliderBorder(colorSliderH, {0, 0, 0}, 1)
						exports.seal_gui:setSliderChangeEvent(colorSliderH, "onColorPickerChanged")
						exports.seal_gui:setSliderColor(colorSliderH, "grey1", {74, 223, 191})
					end

					if backgroundColorS2 then
						exports.seal_gui:setImageDDS(backgroundColorS2, ":seal_carshop/files/images/col1.dds")
					end

					if colorSliderS then
						exports.seal_gui:setSliderSize(colorSliderS, 20)
						exports.seal_gui:setSliderBorder(colorSliderS, {0, 0, 0}, 1)
						exports.seal_gui:setSliderChangeEvent(colorSliderS, "onColorPickerChanged")
						exports.seal_gui:setSliderColor(colorSliderS, "grey1", {74, 223, 191})
					end

					if backgroundColorL1 then
						exports.seal_gui:setGuiBackground(backgroundColorL1, "solid", {0, 0, 0})
						exports.seal_gui:setGuiBackground(backgroundColorL2, "solid", {255, 255, 255})
					end

					if backgroundColorL3 then
						exports.seal_gui:setImageDDS(backgroundColorL3, ":seal_carshop/files/images/col2.dds")
					end

					if colorSliderL then
						exports.seal_gui:setSliderSize(colorSliderL, 20)
						exports.seal_gui:setSliderBorder(colorSliderL, {0, 0, 0}, 1)
						exports.seal_gui:setSliderChangeEvent(colorSliderL, "onColorPickerChanged")
						exports.seal_gui:setSliderColor(colorSliderL, "grey1", {74, 223, 191})
					end

					local hslHue = 0
					local hslSat = 0
					local hslLig = 1

					local pickerColor = {getVehicleColor(vehiclePreview, true)}

					if pickerColor then
						hslHue, hslSat, hslLig = convertRGBToHSL(pickerColor[1], pickerColor[2], pickerColor[3])
					end

					if hslHue and hslSat and hslLig then
						exports.seal_gui:setSliderValue(colorSliderH, hslHue)
						exports.seal_gui:setSliderValue(colorSliderS, hslSat)
						exports.seal_gui:setSliderValue(colorSliderL, hslLig)
					end

					refreshColorPicker(true)
				end
			end
		end
	end
end

function changeVehicleDatas(newVehicleSelected, forcedModelChange, justStarted)
	if newVehicleSelected then
		local vehicleDatas = vehicleShopVehicles[newVehicleSelected]

		if vehicleDatas then
			maximumLimit = vehicleDatas.limitMaximum
			currentLimit = vehicleDatas.limitCurrent

			vehicleDriveType = getVehicleHandling(vehiclePreview)["driveType"]
			vehicleFuelType = getVehicleHandling(vehiclePreview)["engineType"]

			vehicleTankCapacity = exports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(vehicleDatas.modelId) or 999
			vehicleBootCapacity = exports.seal_items:getWeightLimit("vehicle", vehiclePreview) or 999

			if vehicleFuelType == "petrol" then
				vehicleFuelType = "Benzin"
			elseif vehicleFuelType == "diesel" then
				vehicleFuelType = "Dízel"
			else
				vehicleFuelType = "Elektromos"
			end

			if vehicleDriveType == "fwd" then
				vehicleDriveType = "Elsőkerék"
			elseif vehicleDriveType == "rwd" then
				vehicleDriveType = "Hátsókerék"
			else
				vehicleDriveType = "Összkerék"
			end

			vehicleTankCapacity = vehicleTankCapacity .. " #319ad7l"
			vehicleBootCapacity = vehicleBootCapacity .. " #319ad7kg"

			vehicleName = vehicleDatas.modelName
			vehicleManifacturer = vehicleDatas.brandManufacturer
			vehicleSign = vehicleDatas.brandSign

			vehicleShopDatas = {
				{"", "Limit", "#f3d65a" .. currentLimit .. "/" .. maximumLimit},
				{"", "Meghajtás", "#4adfbf" .. vehicleDriveType},
				{"", "Üzemanyag típus", vehicleFuelType},
				{"", "Tank kapacitás", vehicleTankCapacity},
				{"", "Csomagtér kapaticás", vehicleBootCapacity},
				{"", "Gyártmány", "#319ad7" .. vehicleManifacturer}
			}

			local newVehiclePriceDollar = vehicleDatas.priceMoney
			local newVehiclePricePremium = vehicleDatas.pricePremium

			if newVehiclePriceDollar or newVehiclePricePremium then
				if (newVehiclePriceDollar and not vehicleDatas.premiumOnly) and (newVehiclePricePremium and vehicleDatas.premiumCanBuy) then
					vehicleEconomySelected = 1
				elseif newVehiclePriceDollar and not vehicleDatas.premiumOnly then
					vehicleEconomySelected = 1
				elseif newVehiclePricePremium and vehicleDatas.premiumCanBuy then
					vehicleEconomySelected = 2
				end
			else
				vehicleEconomySelected = 1
			end

			if not justStarted then
				createColorPicker(newVehicleSelected)
			end

			if forcedModelChange and vehiclePreview then
				setElementModel(vehiclePreview, vehicleDatas.modelId)
			end
		end
	end
end

function hue2rgb(m1, m2, h)
  if h < 0 then
    h = h + 1
  elseif h > 1 then
    h = h - 1
  end
  if 1 > h * 6 then
    return m1 + (m2 - m1) * h * 6
  elseif 1 > h * 2 then
    return m2
  elseif 2 > h * 3 then
    return m1 + (m2 - m1) * (0.6666666666666666 - h) * 6
  else
    return m1
  end
end

function convertHSLToRGB(h, s, l)
  local m2
  if l < 0.5 then
    m2 = l * (s + 1)
  else
    m2 = l + s - l * s
  end
  local m1 = l * 2 - m2
  local r = hue2rgb(m1, m2, h + 0.3333333333333333) * 255
  local g = hue2rgb(m1, m2, h) * 255
  local b = hue2rgb(m1, m2, h - 0.3333333333333333) * 255
  return math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
end

function convertRGBToHSL(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s
  local l = (max + min) / 2
  if max == min then
    h = 0
    s = 0
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    end
    if max == g then
      h = (b - r) / d + 2
    end
    if max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, l
end

function renderCarshop()
	if carshopState or blackSlideIn or blackSlideOut then
		local currentTime = getTickCount()

		if blackSlideIn then
			local elapsedTime = (currentTime - blackSlideIn) / blackInterpolateTime

			if elapsedTime then
				blackSlideX = interpolateBetween(-screenWidth, 0, 0, 0, 0, 0, elapsedTime, "InOutQuad")
			
				if elapsedTime >= 1 then
					if blackSlideIn then
						blackSlideIn = false
					end

					if not blackSlideOut then
						blackSlideOut = getTickCount()
					end

					if blackMagicHappening then
						if blackMagicHappening == "showshop" then
							local categoryDatas = vehicleCategoryShops[carshopCategory]

							if categoryDatas then
								setCameraMatrix(categoryDatas[5], categoryDatas[6], categoryDatas[7], categoryDatas[8], categoryDatas[9], categoryDatas[10])
							end
						
							if not blackRenderEnded then
								blackRenderEnded = true
							end

							createColorPicker(vehicleSelected)

							setElementDimension(localPlayer, getElementData(localPlayer, "playerID"))
							setElementFrozen(localPlayer, true)

							plateInput = exports.seal_gui:createGuiElement("input", -350, 0, 300, 25)

							if plateInput then
								exports.seal_gui:setInputValue(plateInput, "12345678")
								exports.seal_gui:setInputMaxLength(plateInput, 8)
								exports.seal_gui:setInputChangeEvent(plateInput, "onPlateInputChange")

								licenseText = exports.seal_gui:getInputValue(plateInput)
							end

							blackMagicHappening = false
						elseif blackMagicHappening == "closeshop" then
							carshopCategory = false
							carshopPageStart = 0

							changeFadeIn = false
							changeFadeOut = false
							changeTarget = false
							changeAlpha = 1

							isInside = false
							inForcedLeave = false

							plateActive = false

							buttonContainer = {}
							buttonActive = false

							blackRenderEnded = false

							vehicleEconomySelected = 1
							vehicleSelected = false

							licenseText = "12345678"

							maximumLimit = false
							currentLimit = false

							vehicleDriveType = false
							vehicleFuelType = false

							vehicleTankCapacity = false
							vehicleBootCapacity = false

							vehicleName = false
							vehicleManifacturer = false
							vehicleSign = false

							vehicleColors = {0, 0, 0}
							vehicleShopDatas = {}
							vehicleShopVehicles = {}

							promptHasCustomPlate = false

							waitingForServerResponse = false

							if isElement(vehiclePreview) then
								destroyElement(vehiclePreview)
							end
							vehiclePreview = nil

							if plateInput then
								exports.seal_gui:deleteGuiElement(plateInput)
							end
							plateInput = false

							local vehicleElement = getPedOccupiedVehicle(localPlayer)

							if vehicleElement then
								setElementFrozen(vehicleElement, false)
							end

							setCameraTarget(localPlayer)

							setElementDimension(localPlayer, 0)
							setElementFrozen(localPlayer, false)
							setElementPosition(localPlayer, entrancePosnX, entrancePosnY, entrancePosnZ)
						
							removeEventHandler("onClientKey", root, carshopKey)

							entrancePosnX = false
							entrancePosnY = false
							entrancePosnZ = false

							destroyColorPicker()
						end
					end
				end
			end
		end

		if blackSlideOut then
			local elapsedTime = (currentTime - blackSlideOut) / blackInterpolateTime

			if elapsedTime then
				blackSlideX = interpolateBetween(0, 0, 0, screenWidth, 0, 0, elapsedTime, "InOutQuad")
			
				if elapsedTime >= 1 then
					if blackSlideOut then
						blackSlideOut = false
					end

					if blackSlideIn then
						blackSlideIn = false
					end

					blackSlideX = -screenWidth

					if blackMagicHappening == "closeshop" then
						blackSlideIn = false
						blackSlideOut = false
						blackMagicHappening = false

						showCursor(false)
						showChat(false)

						exports.seal_hud:showHUD()

						removeEventHandler("onClientRender", root, renderCarshop)
					end
				end
			end
		end

		if changeFadeOut and changeTarget then
			local elapsedTime = (currentTime - changeFadeOut) / changeInterpolateTime

			if elapsedTime then
				changeAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, elapsedTime, "InOutQuad")

				if elapsedTime >= 1 then
					if changeTarget then
						changeVehicleDatas(changeTarget, true)
					end
					changeTarget = false

					if changeFadeOut then
						changeFadeOut = false
					end

					if not changeFadeIn then
						changeFadeIn = getTickCount()
					end
				end
			end
		end

		if changeFadeIn then
			local elapsedTime = (currentTime - changeFadeIn) / changeInterpolateTime

			if elapsedTime then
				changeAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime, "InOutQuad")

				if elapsedTime >= 1 then
					if changeFadeIn then
						changeFadeIn = false
					end
				end
			end
		end

		if promptFadeIn then
			local elapsedTime = (currentTime - promptFadeIn) / promptInterpolateTime

			if elapsedTime then
				promptAlpha = interpolateBetween(0, 0, 0, 1, 0, 0, elapsedTime, "InOutQuad")

				if elapsedTime >= 1 then
					if promptFadeIn then
						promptFadeIn = false
					end
				end
			end
		end

		if promptFadeOut then
			local elapsedTime = (currentTime - promptFadeOut) / promptInterpolateTime

			if elapsedTime then
				promptAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, elapsedTime, "InOutQuad")

				if elapsedTime >= 1 then
					if promptFadeOut then
						promptFadeOut = false
					end

					promptAlpha = 0
					promptState = false

					promptWidth = 465
					promptHeight = 450
					promptPosnX = (screenWidth - promptWidth) / 2
					promptPosnY = (screenHeight - promptHeight) / 2

					promptHasCustomPlate = false

					if inForcedLeave then
						showCarshop(false)
					end
				end
			end
		end

		local cursorX, cursorY = getCursorPosition()

		if tonumber(cursorX) then
			cursorX = cursorX * screenWidth
			cursorY = cursorY * screenHeight
		end

		buttons = {}

		if promptState or promptFadeIn or promptFadeOut then
			dxDrawRectangle(promptPosnX + 2, promptPosnY, promptWidth, promptHeight, tocolor(26, 27, 31, 200 * promptAlpha))
			dxDrawRectangle(promptPosnX, promptPosnY, promptWidth, promptHeight, tocolor(26, 27, 31, 200 * promptAlpha))

			dxDrawImage(promptPosnX + ((promptWidth - 150) / 2) + 2, promptPosnY + 15, 150, 150, vehicleTexturesLoaded["mark"], 0, 0, 0, tocolor(243, 214, 90, 100 * promptAlpha))
			dxDrawImage(promptPosnX + ((promptWidth - 150) / 2), promptPosnY + 15, 150, 150, vehicleTexturesLoaded["mark"], 0, 0, 0, tocolor(243, 214, 90, 255 * promptAlpha))
		
			local textShadowPosnX = promptPosnX + 2
			local textPosnX = promptPosnX
			local textPosnY = promptPosnY + 170

			if textPosnX and textPosnY then
				local textShadowSizeX = textShadowPosnX + promptWidth
				local textSizeX = textPosnX + promptWidth
				local textSizeY = textPosnY + 35

				if textSizeX and textSizeY then
					dxDrawText("Biztosan megszeretnéd vásárolni ezt a járművet?", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(220, 220, 220, 100 * promptAlpha), 1, fontsContainer["prompttitle"], "center", "center", false, false, false, false)
					dxDrawText("Biztosan megszeretnéd vásárolni ezt a járművet?", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["prompttitle"], "center", "center", false, false, false, false)
				end
			end

			if promptHasCustomPlate then
				local r1, r2, r3, r4
				local b1, b2, b3, b4

				local r21, r22, r23, r24
				local b21, b22, b23, b24

				local r31, r32, r33, r34
				local b31, b32, b33, b34

				if isMouseInPosition(promptPosnX + 5, promptPosnY + 250, promptWidth / 2 - 2, 35) then
					r1, r2, r3, r4 = processColorSwitchEffect("promptBuy3", 74, 223, 191, 100)
					b1, b2, b3, b4 = processColorSwitchEffect("promptBuy33", 74, 223, 191, 150)
				else
					r1, r2, r3, r4 = processColorSwitchEffect("promptBuy3", 49, 50, 57, 200)
					b1, b2, b3, b4 = processColorSwitchEffect("promptBuy33", 49, 50, 57, 255)
				end

				if isMouseInPosition(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 250, (promptWidth / 2 - 2) - 8, 35) then
					r21, r22, r23, r24 = processColorSwitchEffect("promptBuy4", 243, 90, 90, 100)
					b21, b22, b23, b24 = processColorSwitchEffect("promptBuy44", 243, 90, 90, 200)
				else
					r21, r22, r23, r24 = processColorSwitchEffect("promptBuy4", 49, 50, 57, 200)
					b21, b22, b23, b24 = processColorSwitchEffect("promptBuy44", 49, 50, 57, 255)
				end

				if isMouseInPosition(promptPosnX + 5, promptPosnY + 210, promptWidth - 10, 35) then
					r31, r32, r33, r34 = processColorSwitchEffect("promptBuy5", 49, 180, 225, 100)
					b31, b32, b33, b34 = processColorSwitchEffect("promptBuy55", 49, 180, 225, 200)
				else
					r31, r32, r33, r34 = processColorSwitchEffect("promptBuy5", 49, 50, 57, 200)
					b31, b32, b33, b34 = processColorSwitchEffect("promptBuy55", 49, 50, 57, 255)
				end

				buttonContainer["buyPrompt:buy"] = {promptPosnX + 5, promptPosnY + 250, promptWidth / 2 - 2, 35}
				buttonContainer["buyPrompt:cancel"] = {promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 250, (promptWidth / 2 - 2) - 8, 35}
				buttonContainer["buyPrompt:buywcustom"] = {promptPosnX + 5, promptPosnY + 210, promptWidth - 8, 35}

				dxDrawRectangle(promptPosnX + 5, promptPosnY + 210, promptWidth - 8, 35, tocolor(r31, r32, r33, r34 * promptAlpha)) -- új
				dxDrawRectangle(promptPosnX + 5, promptPosnY + 250, promptWidth / 2 - 2, 35, tocolor(r1, r2, r3, r4 * promptAlpha))
				dxDrawRectangle(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 250, (promptWidth / 2 - 2) - 8, 35, tocolor(r21, r22, r23, r24 * promptAlpha))
				dxDrawRectangleBorder(promptPosnX + 5, promptPosnY + 250, promptWidth / 2 - 2, 35, "inner", tocolor(b1, b2, b3, b4 * promptAlpha))
				dxDrawRectangleBorder(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 250, (promptWidth / 2 - 2) - 8, 35, "inner", tocolor(b21, b22, b23, b24 * promptAlpha))
				dxDrawRectangleBorder(promptPosnX + 5, promptPosnY + 210, promptWidth - 8, 35, "inner", tocolor(b31, b32, b33, b34 * promptAlpha))
			
				local textShadowPosnX = promptPosnX + 7
				local textPosnX = promptPosnX + 5
				local textPosnY = promptPosnY + 210

				if textPosnX and textPosnY then
					local textShadowSizeX = textShadowPosnX + promptWidth - 8
					local textSizeX = textPosnX + promptWidth - 8
					local textSizeY = textPosnY + 35

					if textSizeX and textSizeY then
						dxDrawText("Megvásárlás (Egyedi  Rendszámmal együtt +" .. vehiclePlatePrice .. " PP)", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 150 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, true)
						dxDrawText("Megvásárlás (Egyedi  Rendszámmal együtt +" .. vehiclePlatePrice .. " PP)", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, false)
					end
				end

				local textShadowPosnX = promptPosnX + 7
				local textPosnX = promptPosnX + 5
				local textPosnY = promptPosnY + 250

				if textPosnX and textPosnY then
					local textShadowSizeX = textShadowPosnX + promptWidth / 2 - 2
					local textSizeX = textPosnX + promptWidth / 2 - 2
					local textSizeY = textPosnY + 35

					if textSizeX and textSizeY then
						dxDrawText("Megvásárlás (Egyedi  Rendszám nélkül)", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 150 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, true)
						dxDrawText("Megvásárlás (Egyedi  Rendszám nélkül)", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, false)
					end
				end

				local textShadowPosnX = promptPosnX + 7 + (promptWidth / 2 + 2)
				local textPosnX = promptPosnX + 5 + (promptWidth / 2 + 2)
				local textPosnY = promptPosnY + 250

				if textPosnX and textPosnY then
					local textShadowSizeX = textShadowPosnX + promptWidth / 2 - 2
					local textSizeX = textPosnX + promptWidth / 2 - 2
					local textSizeY = textPosnY + 35

					if textSizeX and textSizeY then
						dxDrawText("Mégse", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 150 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, true)
						dxDrawText("Mégse", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, false)
					end
				end
			else
				local r1, r2, r3, r4
				local b1, b2, b3, b4

				local r21, r22, r23, r24
				local b21, b22, b23, b24

				if isMouseInPosition(promptPosnX + 5, promptPosnY + 210, promptWidth / 2 - 2, 35) then
					r1, r2, r3, r4 = processColorSwitchEffect("promptBuy1", 74, 223, 191, 100)
					b1, b2, b3, b4 = processColorSwitchEffect("promptBuy11", 74, 223, 191, 150)
				else
					r1, r2, r3, r4 = processColorSwitchEffect("promptBuy1", 49, 50, 57, 200)
					b1, b2, b3, b4 = processColorSwitchEffect("promptBuy11", 49, 50, 57, 255)
				end

				if isMouseInPosition(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 210, (promptWidth / 2 - 2) - 8, 35) then
					r21, r22, r23, r24 = processColorSwitchEffect("promptBuy2", 243, 90, 90, 100)
					b21, b22, b23, b24 = processColorSwitchEffect("promptBuy22", 243, 90, 90, 200)
				else
					r21, r22, r23, r24 = processColorSwitchEffect("promptBuy2", 49, 50, 57, 200)
					b21, b22, b23, b24 = processColorSwitchEffect("promptBuy22", 49, 50, 57, 255)
				end

				buttonContainer["buyPrompt:buy"] = {promptPosnX + 5, promptPosnY + 210, promptWidth / 2 - 2, 35}
				buttonContainer["buyPrompt:cancel"] = {promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 210, (promptWidth / 2 - 2) - 8, 35}

				dxDrawRectangle(promptPosnX + 5, promptPosnY + 210, promptWidth / 2 - 2, 35, tocolor(r1, r2, r3, r4 * promptAlpha))
				dxDrawRectangle(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 210, (promptWidth / 2 - 2) - 8, 35, tocolor(r21, r22, r23, r24 * promptAlpha))
				dxDrawRectangleBorder(promptPosnX + 5, promptPosnY + 210, promptWidth / 2 - 2, 35, "inner", tocolor(b1, b2, b3, b4 * promptAlpha))
				dxDrawRectangleBorder(promptPosnX + 5 + (promptWidth / 2 + 2), promptPosnY + 210, (promptWidth / 2 - 2) - 8, 35, "inner", tocolor(b21, b22, b23, b24 * promptAlpha))
			
				local textShadowPosnX = promptPosnX + 7
				local textPosnX = promptPosnX + 5
				local textPosnY = promptPosnY + 210

				if textPosnX and textPosnY then
					local textShadowSizeX = textShadowPosnX + promptWidth / 2 - 2
					local textSizeX = textPosnX + promptWidth / 2 - 2
					local textSizeY = textPosnY + 35

					if textSizeX and textSizeY then
						dxDrawText("Megvásárlás", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 150 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, true)
						dxDrawText("Megvásárlás", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, false)
					end
				end

				local textShadowPosnX = promptPosnX + 7 + (promptWidth / 2 + 2)
				local textPosnX = promptPosnX + 5 + (promptWidth / 2 + 2)
				local textPosnY = promptPosnY + 210

				if textPosnX and textPosnY then
					local textShadowSizeX = textShadowPosnX + promptWidth / 2 - 2
					local textSizeX = textPosnX + promptWidth / 2 - 2
					local textSizeY = textPosnY + 35

					if textSizeX and textSizeY then
						dxDrawText("Mégse", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 150 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, true)
						dxDrawText("Mégse", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255 * promptAlpha), 1, fontsContainer["promptbutton"], "center", "center", false, false, false, false)
					end
				end
			end
		end

		if (changeFadeOut or changeFadeIn) and changeAlpha and vehiclePreview then
			setElementAlpha(vehiclePreview, 255 * changeAlpha)
		end

		if blackRenderEnded then
			dxDrawImage(0, 0, screenWidth, screenHeight, vehicleTexturesLoaded["vignette"], 0, 0, 0, tocolor(26, 27, 31, 255))

			local vehicleDatas = vehicleShopVehicles[vehicleSelected]

			if vehicleDatas then
				dxDrawText(vehicleName, rectangleStartPosnX + 2, rectangleStartPosnY - 50, rectangleStartPosnX + 2 + rectangleTotalWidth, rectangleStartPosnY - 50 + 35, tocolor(0, 0, 0, 100), 1, fontsContainer["titlebb"], "left", "center", false, false, false, false)
				dxDrawText(vehicleName, rectangleStartPosnX, rectangleStartPosnY - 50, rectangleStartPosnX + rectangleTotalWidth, rectangleStartPosnY - 50 + 35, tocolor(74, 223, 191, 255), 1, fontsContainer["titlebb"], "left", "center", false, false, false, false)
				
				dxDrawText(vehicleSign, rectangleStartPosnX + 2, rectangleStartPosnY - 85, rectangleStartPosnX + 2 + rectangleTotalWidth, rectangleStartPosnY - 85 + 35, tocolor(0, 0, 0, 100), 1, fontsContainer["titlebr"], "left", "center", false, false, false, false)
				dxDrawText(vehicleSign, rectangleStartPosnX, rectangleStartPosnY - 85, rectangleStartPosnX + rectangleTotalWidth, rectangleStartPosnY - 85 + 35, tocolor(220, 220, 220, 255), 1, fontsContainer["titlebr"], "left", "center", false, false, false, false)
			
				local buySizeX = 200
				local buySizeY = 25

				local vehiclePriceDollar = vehicleDatas.priceMoney and formatNumber(vehicleDatas.priceMoney, " ")
				local vehiclePricePremium = vehicleDatas.pricePremium and formatNumber(vehicleDatas.pricePremium, " ")

				if buySizeX and buySizeY then
					local buyPositionX = rectangleStartPosnX + rectangleTotalWidth - buySizeX
					local buyPositionY = rectangleStartPosnY - buySizeY - 10

					if buyPositionX and buyPositionY then
						local r1, r2, r3, r4
						local b1, b2, b3, b4

						if isMouseInPosition(buyPositionX, buyPositionY, buySizeX, buySizeY) then
							r1, r2, r3, r4 = processColorSwitchEffect("tryBuyVehicle1", 74, 223, 191, 150)
							b1, b2, b3, b4 = processColorSwitchEffect("tryBuyVehicle2", 74, 223, 191, 200)
						else
							r1, r2, r3, r4 = processColorSwitchEffect("tryBuyVehicle1", 26, 27, 31, 200)
							b1, b2, b3, b4 = processColorSwitchEffect("tryBuyVehicle2", 26, 27, 31, 255)
						end

						dxDrawRectangle(buyPositionX, buyPositionY, buySizeX, buySizeY, tocolor(r1, r2, r3, r4))
						dxDrawRectangleBorder(buyPositionX, buyPositionY, buySizeX, buySizeY, "inner", tocolor(b1, b2, b3, b4))
					
						buttonContainer["tryToBuyVehicle"] = {buyPositionX, buyPositionY, buySizeX, buySizeY}

						dxDrawText("Megvásárlás", buyPositionX, buyPositionY - 2, buyPositionX + buySizeX, buyPositionY - 2 + buySizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center")

						local rectangleFullSize = buySizeX
						local rectangleSizeX = buySizeX / 2 - 5
						local rectangleSizeY = 85

						local rectanglePosnY = buyPositionY - rectangleSizeY - 10

						if rectangleSizeX and rectangleSizeY and rectanglePosnY then
							if vehiclePriceDollar or vehiclePricePremium then
								if (vehiclePriceDollar and not vehicleDatas.premiumOnly) and (vehiclePricePremium and vehicleDatas.premiumCanBuy) then
									local rectangleDollarX = buyPositionX
									local rectanglePremiumX = buyPositionX + buySizeX - rectangleSizeX

									if rectangleDollarX then
										local r1, r2, r3, r4
										local b1, b2, b3, b4

										if vehicleEconomySelected == 1 then
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 74, 223, 191, 200)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 74, 223, 191, 230)
										elseif isMouseInPosition(rectangleDollarX, rectanglePosnY, rectangleSizeX, rectangleSizeY) then
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 74, 223, 191, 150)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 74, 223, 191, 200)
										else
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 26, 27, 31, 200)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 26, 27, 31, 255)
										end

										dxDrawRectangle(rectangleDollarX, rectanglePosnY, rectangleSizeX, rectangleSizeY, tocolor(r1, r2, r3, r4))
										dxDrawRectangleBorder(rectangleDollarX, rectanglePosnY, rectangleSizeX, rectangleSizeY, "inner", tocolor(b1, b2, b3, b4))
									
										local imagePosnX = rectangleDollarX + (rectangleSizeX - 60) / 2

										if imagePosnX then
											dxDrawImage(imagePosnX + 2, rectanglePosnY + 2, 60, 60, vehicleTexturesLoaded["wallet"], 0, 0, 0, tocolor(0, 0, 0, 100))
											dxDrawImage(imagePosnX, rectanglePosnY, 60, 60, vehicleTexturesLoaded["wallet"], 0, 0, 0, tocolor(255, 255, 255, 255))
										end

										buttonContainer["paymentMode:1"] = {rectangleDollarX, rectanglePosnY, rectangleSizeX, rectangleSizeY}

										local textShadowX = rectangleDollarX + 2
										local textPosnX = rectangleDollarX
										local textPosnY = rectanglePosnY + 60

										if textPosnX and textPosnY then
											local textShadowSizeX = textShadowX + rectangleSizeX
											local textSizeX = textPosnX + rectangleSizeX
											local textSizeY = textPosnY + 25

											if textSizeX and textSizeY then
												dxDrawText("DOLLÁR", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
												dxDrawText("DOLLÁR", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
											end
										end
									end

									if rectanglePremiumX then
										local r1, r2, r3, r4
										local b1, b2, b3, b4

										if vehicleEconomySelected == 2 then
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 74, 223, 191, 200)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 74, 223, 191, 230)
										elseif isMouseInPosition(rectanglePremiumX, rectanglePosnY, rectangleSizeX, rectangleSizeY) then
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 74, 223, 191, 150)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 74, 223, 191, 200)
										else
											r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 26, 27, 31, 200)
											b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 26, 27, 31, 255)
										end

										dxDrawRectangle(rectanglePremiumX, rectanglePosnY, rectangleSizeX, rectangleSizeY, tocolor(r1, r2, r3, r4))
										dxDrawRectangleBorder(rectanglePremiumX, rectanglePosnY, rectangleSizeX, rectangleSizeY, "inner", tocolor(b1, b2, b3, b4))
									
										local imagePosnX = rectanglePremiumX + (rectangleSizeX - 60) / 2

										if imagePosnX then
											dxDrawImage(imagePosnX + 2, rectanglePosnY + 2, 60, 60, vehicleTexturesLoaded["premium"], 0, 0, 0, tocolor(0, 0, 0, 100))
											dxDrawImage(imagePosnX, rectanglePosnY, 60, 60, vehicleTexturesLoaded["premium"], 0, 0, 0, tocolor(255, 255, 255, 255))
										end

										buttonContainer["paymentMode:2"] = {rectanglePremiumX, rectanglePosnY, rectangleSizeX, rectangleSizeY}

										local textShadowX = rectanglePremiumX + 2
										local textPosnX = rectanglePremiumX
										local textPosnY = rectanglePosnY + 60

										if textPosnX and textPosnY then
											local textShadowSizeX = textShadowX + rectangleSizeX
											local textSizeX = textPosnX + rectangleSizeX
											local textSizeY = textPosnY + 25

											if textSizeX and textSizeY then
												dxDrawText("PRÉMIUM", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
												dxDrawText("PRÉMIUM", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
											end
										end
									end
								elseif vehiclePriceDollar and not vehicleDatas.premiumOnly then
									local r1, r2, r3, r4
									local b1, b2, b3, b4

									if vehicleEconomySelected == 1 then
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 74, 223, 191, 200)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 74, 223, 191, 230)
									elseif isMouseInPosition(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY) then
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 74, 223, 191, 150)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 74, 223, 191, 200)
									else
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod1", 26, 27, 31, 200)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod1B", 26, 27, 31, 255)
									end

									dxDrawRectangle(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, tocolor(r1, r2, r3, r4))
									dxDrawRectangleBorder(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, "inner", tocolor(b1, b2, b3, b4))
								
									local imagePosnX = buyPositionX + (rectangleFullSize - 60) / 2

									if imagePosnX then
										dxDrawImage(imagePosnX + 2, rectanglePosnY + 2, 60, 60, vehicleTexturesLoaded["wallet"], 0, 0, 0, tocolor(0, 0, 0, 100))
										dxDrawImage(imagePosnX, rectanglePosnY, 60, 60, vehicleTexturesLoaded["wallet"], 0, 0, 0, tocolor(255, 255, 255, 255))
									end

									buttonContainer["paymentMode:1"] = {buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY}

									local textShadowX = buyPositionX + 2
									local textPosnX = buyPositionX
									local textPosnY = rectanglePosnY + 60

									if textPosnX and textPosnY then
										local textShadowSizeX = textShadowX + rectangleFullSize
										local textSizeX = textPosnX + rectangleFullSize
										local textSizeY = textPosnY + 25

										if textSizeX and textSizeY then
											dxDrawText("DOLLÁR", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
											dxDrawText("DOLLÁR", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
										end
									end
								elseif vehiclePricePremium and vehicleDatas.premiumCanBuy then
									local r1, r2, r3, r4
									local b1, b2, b3, b4

									if vehicleEconomySelected == 2 then
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 49, 180, 225, 200)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 49, 180, 225, 230)
									elseif isMouseInPosition(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY) then
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 49, 180, 225, 150)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 49, 180, 225, 200)
									else
										r1, r2, r3, r4 = processColorSwitchEffect("payingMethod2", 26, 27, 31, 200)
										b1, b2, b3, b4 = processColorSwitchEffect("payingMethod2B", 26, 27, 31, 255)
									end

									dxDrawRectangle(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, tocolor(r1, r2, r3, r4))
									dxDrawRectangleBorder(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, "inner", tocolor(b1, b2, b3, b4))
								
									local imagePosnX = buyPositionX + (rectangleFullSize - 60) / 2

									if imagePosnX then
										dxDrawImage(imagePosnX + 2, rectanglePosnY + 2, 60, 60, vehicleTexturesLoaded["premium"], 0, 0, 0, tocolor(0, 0, 0, 100))
										dxDrawImage(imagePosnX, rectanglePosnY, 60, 60, vehicleTexturesLoaded["premium"], 0, 0, 0, tocolor(255, 255, 255, 255))
									end

									buttonContainer["paymentMode:2"] = {buyPositionX + buySizeX - rectangleFullSize, rectanglePosnY, rectangleFullSize, rectangleSizeY}

									local textShadowX = buyPositionX + 2
									local textPosnX = buyPositionX
									local textPosnY = rectanglePosnY + 60

									if textPosnX and textPosnY then
										local textShadowSizeX = textShadowX + rectangleFullSize
										local textSizeX = textPosnX + rectangleFullSize
										local textSizeY = textPosnY + 25

										if textSizeX and textSizeY then
											dxDrawText("PRÉMIUM", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
											dxDrawText("PRÉMIUM", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
										end
									end
								end
							else
								local r1, r2, r3, r4 = processColorSwitchEffect("payingMethod3", 223, 74, 74, 150)
								local b1, b2, b3, b4 = processColorSwitchEffect("payingMethod3B", 223, 74, 74, 200)

								dxDrawRectangle(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, tocolor(r1, r2, r3, r4))
								dxDrawRectangleBorder(buyPositionX, rectanglePosnY, rectangleFullSize, rectangleSizeY, "inner", tocolor(b1, b2, b3, b4))
							
								local imagePosnX = buyPositionX + (rectangleFullSize - 60) / 2

								if imagePosnX then
									dxDrawImage(imagePosnX + 2, rectanglePosnY + 2, 60, 60, vehicleTexturesLoaded["null"], 0, 0, 0, tocolor(0, 0, 0, 100))
									dxDrawImage(imagePosnX, rectanglePosnY, 60, 60, vehicleTexturesLoaded["null"], 0, 0, 0, tocolor(255, 255, 255, 255))
								end

								local textShadowX = buyPositionX + 2
								local textPosnX = buyPositionX
								local textPosnY = rectanglePosnY + 60

								if textPosnX and textPosnY then
									local textShadowSizeX = textShadowX + rectangleFullSize
									local textSizeX = textPosnX + rectangleFullSize
									local textSizeY = textPosnY + 25

									if textSizeX and textSizeY then
										dxDrawText("NINCS BEÁRAZVA", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
										dxDrawText("NINCS BEÁRAZVA", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["buybr"], "center", "center", false, false, false, false)
									end
								end
							end
						end
					end

					local costSizeX = buySizeX
					local costSizeY = 15

					if costSizeX and costSizeY then
						local costPosnX = buyPositionX
						local costPosnY = buyPositionY - 130

						if costPosnX and costPosnY then
							local vehicleLimitReached = false
							local vehiclePriceMultiplier = 1

							local vehicleCurrentLimit = vehicleDatas.limitCurrent
							local vehicleMaximumLimit = vehicleDatas.limitMaximum

							local vehicleDollarPrice = vehicleDatas.priceMoney
							local vehiclePremiumPrice = vehicleDatas.pricePremium

							if vehicleCurrentLimit >= vehicleMaximumLimit then
								vehicleLimitReached = true
								vehiclePriceMultiplier = 2
							end

							if vehiclePriceDollar or vehiclePricePremium then
								if (vehiclePriceDollar and not vehicleDatas.premiumOnly) and (vehiclePricePremium and vehicleDatas.premiumCanBuy) then
									local dollarText = "$ " .. vehiclePriceDollar
									local premiumText = vehiclePricePremium .. " PP"

									if vehicleLimitReached then
										dollarText = "$ " .. vehiclePriceDollar .. " (BETELT A LIMIT)"
										premiumText = formatNumber(vehiclePremiumPrice * vehiclePriceMultiplier, " ") .. " PP"
									end

									dxDrawText(dollarText, costPosnX + 2, costPosnY, costPosnX + 2 + costSizeX, costPosnY + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									dxDrawText(dollarText, costPosnX, costPosnY, costPosnX + costSizeX, costPosnY + costSizeY, tocolor(74, 223, 191, 255), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									
									dxDrawText("Ár (Dollár)", costPosnX + 2, costPosnY - 30, costPosnX + 2 + costSizeX, costPosnY - 30 + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
									dxDrawText("Ár (Dollár)", costPosnX, costPosnY - 30, costPosnX + costSizeX, costPosnY - 30 + costSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								
									dxDrawText(premiumText, costPosnX + 2, costPosnY - 130, costPosnX + 2 + costSizeX, costPosnY + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									dxDrawText(premiumText, costPosnX, costPosnY - 130, costPosnX + costSizeX, costPosnY + costSizeY, tocolor(49, 154, 215, 255), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
								
									dxDrawText("Ár (Prémium)", costPosnX + 2, costPosnY - 95, costPosnX + 2 + costSizeX, costPosnY - 95 + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
									dxDrawText("Ár (Prémium)", costPosnX, costPosnY - 95, costPosnX + costSizeX, costPosnY - 95 + costSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								elseif vehiclePriceDollar and not vehicleDatas.premiumOnly then
									local dollarText = "$ " .. vehiclePriceDollar
									
									if vehicleLimitReached then
										dollarText = "$ " .. formatNumber(vehicleDollarPrice * vehiclePriceMultiplier, " ")
									end

									dxDrawText(dollarText, costPosnX + 2, costPosnY, costPosnX + 2 + costSizeX, costPosnY + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									dxDrawText(dollarText, costPosnX, costPosnY, costPosnX + costSizeX, costPosnY + costSizeY, tocolor(74, 223, 191, 255), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									
									dxDrawText("Ár (Dollár)", costPosnX + 2, costPosnY - 30, costPosnX + 2 + costSizeX, costPosnY - 30 + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
									dxDrawText("Ár (Dollár)", costPosnX, costPosnY - 30, costPosnX + costSizeX, costPosnY - 30 + costSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								elseif vehiclePricePremium and vehicleDatas.premiumCanBuy then
									local premiumText = vehiclePricePremium .. " PP"

									if vehicleLimitReached then
										premiumText = formatNumber(vehiclePremiumPrice * vehiclePriceMultiplier, " ") .. " PP"
									end

									dxDrawText(premiumText, costPosnX + 2, costPosnY, costPosnX + 2 + costSizeX, costPosnY + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									dxDrawText(premiumText, costPosnX, costPosnY, costPosnX + costSizeX, costPosnY + costSizeY, tocolor(49, 154, 215, 255), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									
									dxDrawText("Ár (Prémium)", costPosnX + 2, costPosnY - 30, costPosnX + 2 + costSizeX, costPosnY - 30 + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
									dxDrawText("Ár (Prémium)", costPosnX, costPosnY - 30, costPosnX + costSizeX, costPosnY - 30 + costSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								end
							else
								dxDrawText("$ N/A", costPosnX + 2, costPosnY, costPosnX + 2 + costSizeX, costPosnY + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
								dxDrawText("$ N/A", costPosnX, costPosnY, costPosnX + costSizeX, costPosnY + costSizeY, tocolor(243, 90, 90, 255), 1, fontsContainer["tpricebb"], "right", "center", false, false, false, false)
									
								dxDrawText("Ár (N/A)", costPosnX + 2, costPosnY - 30, costPosnX + 2 + costSizeX, costPosnY - 30 + costSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								dxDrawText("Ár (N/A)", costPosnX, costPosnY - 30, costPosnX + costSizeX, costPosnY - 30 + costSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
							end
						end
					end

					local licenseSizeX = costSizeX
					local licenseSizeY = 100

					if licenseSizeX and licenseSizeY then
						local licensePosnX = buyPositionX
						local licensePosnY = buyPositionY - 130

						if licensePosnX and licensePosnY then
							local licenseUpper = utf8.upper(licenseText)
							
							if vehiclePriceDollar or vehiclePricePremium then
								if (vehiclePriceDollar and not vehicleDatas.premiumOnly) and (vehiclePricePremium and vehicleDatas.premiumCanBuy) then
									licensePosnY = licensePosnY - 210
								elseif vehiclePriceDollar and not vehicleDatas.premiumOnly then
									licensePosnY = licensePosnY - 145
								elseif vehiclePricePremium and vehicleDatas.premiumCanBuy then
									licensePosnY = licensePosnY - 145
								end
							else
								licensePosnY = licensePosnY - 145
							end

							buttonContainer["plateRectangle"] = {licensePosnX, licensePosnY, licenseSizeX, licenseSizeY}

							dxDrawImage(licensePosnX + 2, licensePosnY + 2, licenseSizeX, licenseSizeY, vehicleTexturesLoaded["license"], 0, 0, 0, tocolor(0, 0, 0, 100))
							dxDrawImage(licensePosnX, licensePosnY, licenseSizeX, licenseSizeY, vehicleTexturesLoaded["license"], 0, 0, 0, tocolor(255, 255, 255, 255))
						
							dxDrawText(licenseUpper, licensePosnX + 2, licensePosnY, licensePosnX + 2 + licenseSizeX, licensePosnY + licenseSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["license"], "center", "center", false, false, false, false)
							dxDrawText(licenseUpper, licensePosnX, licensePosnY, licensePosnX + licenseSizeX, licensePosnY + licenseSizeY, tocolor(20, 79, 178, 255), 1, fontsContainer["license"], "center", "center", false, false, false, false)
						end

						local descShadowX = buyPositionX + 2
						local descPosnX = buyPositionX
						local descPosnY = licensePosnY - 30

						if descPosnX and descPosnY then
							local descShadowSizeX = descShadowX + costSizeX
							local descSizeX = descPosnX + costSizeX
							local descSizeY = descPosnY + 25

							if descSizeX and descSizeY then
								dxDrawText("Egyedi rendszám: +" .. vehiclePlatePrice .. " PP", descShadowX, descPosnY, descShadowSizeX, descSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								dxDrawText("Egyedi rendszám: #319ad7+" .. vehiclePlatePrice .. " PP", descPosnX, descPosnY, descSizeX, descSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, true)
							end
						end

						local textShadowX = buyPositionX + 2
						local textPosnX = buyPositionX
						local textPosnY = descPosnY - 110

						if textPosnX and textPosnY then
							local textShadowSizeX = textShadowX + costSizeX
							local textSizeX = textPosnX + costSizeX
							local textSizeY = textPosnY + 25

							if textSizeX and textSizeY then
								dxDrawText("Színválasztó", textShadowX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
								dxDrawText("Színválasztó", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["tpricebr"], "right", "center", false, false, false, false)
							end
						end
					end
				end

				local placeHolderSizeX = 320
				local placeHolderSizeY = 45

				if placeHolderSizeX and placeHolderSizeY then
					local placeHolderPosnX = rectangleStartPosnX

					if placeHolderPosnX then
						for i = 1, #vehicleShopDatas do
							local shopData = vehicleShopDatas[i]

							if shopData then
								local placeHolderPosnY = rectangleStartPosnY - 410 + (placeHolderSizeY + 10) * (i - 1)

								if placeHolderPosnY then
									local holderIcon = shopData[1]
									local holderDesc = shopData[2]
									local holderValue = shopData[3]

									if holderIcon and holderDesc and holderValue then
										dxDrawImage(placeHolderPosnX + 2, placeHolderPosnY + 2, placeHolderSizeX, placeHolderSizeY, vehicleTexturesLoaded["menu_l"], 0, 0, 0, tocolor(0, 0, 0, 100))
										dxDrawImage(placeHolderPosnX, placeHolderPosnY, placeHolderSizeX, placeHolderSizeY, vehicleTexturesLoaded["menu_l"], 0, 0, 0, tocolor(26, 27, 31, 200))
									
										dxDrawImage(placeHolderPosnX + 2, placeHolderPosnY + 2, placeHolderSizeX, placeHolderSizeY, vehicleTexturesLoaded["menu_r"], 0, 0, 0, tocolor(0, 0, 0, 100))
										dxDrawImage(placeHolderPosnX, placeHolderPosnY, placeHolderSizeX, placeHolderSizeY, vehicleTexturesLoaded["menu_r"], 0, 0, 0, tocolor(26, 27, 31, 200))
									
										local iconShadowPosnX = placeHolderPosnX + 2
										local iconPosnX = placeHolderPosnX
										local iconPosnY = placeHolderPosnY

										if iconPosnX and iconPosnY then
											local iconShadowSizeX = iconShadowPosnX + placeHolderSizeY
											local iconSizeX = iconPosnX + placeHolderSizeY
											local iconSizeY = iconPosnY + placeHolderSizeY

											if iconSizeX and iconSizeY then
												dxDrawText(holderIcon, iconShadowPosnX, iconPosnY, iconShadowSizeX, iconSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["data"], "center", "center", false, false, false, false)
												dxDrawText(holderIcon, iconPosnX, iconPosnY, iconSizeX, iconSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["data"], "center", "center", false, false, false, false)
											end
										end

										local textShadowPosnX = placeHolderPosnX + 80 + 2
										local textPosnX = placeHolderPosnX + 80
										local textPosnY = placeHolderPosnY

										if textPosnX and textPosnY then
											local textShadowSizeX = textShadowPosnX + placeHolderSizeX - 80
											local textSizeX = textPosnX + placeHolderSizeX - 80
											local textSizeY = textPosnY + placeHolderSizeY

											if textSizeX and textSizeY then
												dxDrawText(holderDesc, textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["datadesc"], "left", "center", false, false, false, false)
												dxDrawText(holderDesc, textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["datadesc"], "left", "center", false, false, false, false)
											end
										end

										local textShadowPosnX = placeHolderPosnX + 80 - 5 + 2
										local textPosnX = placeHolderPosnX + 80 - 5
										local textPosnY = placeHolderPosnY

										if textPosnX and textPosnY then
											local textShadowSizeX = textShadowPosnX + placeHolderSizeX - 80
											local textSizeX = textPosnX + placeHolderSizeX - 80
											local textSizeY = textPosnY + placeHolderSizeY

											if textSizeX and textSizeY then
												dxDrawText(removeHexCodes(holderValue), textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["datavalue"], "right", "center", false, false, false, false)
												dxDrawText(holderValue, textPosnX, textPosnY, textSizeX, textSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["datavalue"], "right", "center", false, false, false, true)
											end
										end
									end
								end
							end
						end
					end
				end

				local instructionSizeX = 320
				local instructionSizeY = 30

				if instructionSizeX and instructionSizeY then
					local instructionPosnX = rectangleStartPosnX
					local instructionPosnY = rectangleStartPosnY - 450

					if instructionPosnX and instructionPosnY then
						local instructionWidth = dxGetTextWidth("BACKSPACE", 1, fontsContainer["instruction"]) + 10

						if instructionWidth then
							dxDrawRectangle(instructionPosnX + 2, instructionPosnY, instructionWidth, instructionSizeY, tocolor(49, 50, 57, 180))
							dxDrawRectangle(instructionPosnX, instructionPosnY, instructionWidth, instructionSizeY, tocolor(49, 50, 57, 180))
						
							local textShadowPosnX = instructionPosnX + 2
							local textPosnX = instructionPosnX
							local textPosnY = instructionPosnY

							if textPosnX and textPosnY then
								local textShadowSizeX = textShadowPosnX + instructionWidth
								local textSizeX = textPosnX + instructionWidth
								local textSizeY = textPosnY + instructionSizeY

								if textSizeX and textSizeY then
									dxDrawText("BACKSPACE", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["instruction"], "center", "center", false, false, false, false)
									dxDrawText("BACKSPACE", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["instruction"], "center", "center", false, false, false, false)
								end
							end

							local textShadowPosnX = instructionPosnX + instructionWidth + 10 + 2
							local textPosnX = instructionPosnX + instructionWidth + 10
							local textPosnY = instructionPosnY

							if textPosnX and textPosnY then
								local textShadowSizeX = textShadowPosnX + instructionWidth
								local textSizeX = textPosnX + instructionWidth
								local textSizeY = textPosnY + instructionSizeY

								if textSizeX and textSizeY then
									dxDrawText("Kilépés a kereskedésből", textShadowPosnX, textPosnY, textShadowSizeX, textSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["instruction"], "left", "center", false, false, false, false)
									dxDrawText("Kilépés a kereskedésből", textPosnX, textPosnY, textSizeX, textSizeY, tocolor(220, 220, 220, 255), 1, fontsContainer["instruction"], "left", "center", false, false, false, false)
								end
							end
						end
					end
				end
			end

			for i = 1, math.min(rectangleMaximum, #vehicleShopVehicles) do
				local rectanglePosnX = rectangleStartPosnX + (rectangleWidth + rectangleSpacing) * (i - 1)

				if rectanglePosnX then
					local vehicleDatas = vehicleShopVehicles[i + carshopPageStart]

					if vehicleDatas then
						local colorBackgroundR, colorBackgroundG, colorBackgroundB, colorBackgroundA
						local colorBorderR, colorBorderG, colorBorderB, colorBorderA

						if vehicleSelected == i + carshopPageStart then
							colorBackgroundR, colorBackgroundG, colorBackgroundB, colorBackgroundA = processColorSwitchEffect("carSelectorBG:" .. i, 74, 223, 191, 50)
							colorBorderR, colorBorderG, colorBorderB, colorBorderA                 = processColorSwitchEffect("carSelectorBR:" .. i, 74, 223, 191, 100)
						else
							colorBackgroundR, colorBackgroundG, colorBackgroundB, colorBackgroundA = processColorSwitchEffect("carSelectorBG:" .. i, 26, 27, 31, 180)
							colorBorderR, colorBorderG, colorBorderB, colorBorderA                 = processColorSwitchEffect("carSelectorBR:" .. i, 26, 27, 31, 255)
						end

						local vehiclePriceDollar = vehicleDatas.priceMoney and formatNumber(vehicleDatas.priceMoney, " ")
						local vehiclePricePremium = vehicleDatas.pricePremium and formatNumber(vehicleDatas.pricePremium, " ")

						local vehicleDollarWidth = vehicleDatas.priceMoney and dxGetTextWidth("$" .. vehiclePriceDollar, 1, fontsContainer["pricebr"]) + 10
						local vehiclePremiumWidth = vehicleDatas.pricePremium and dxGetTextWidth(vehiclePricePremium .. " PP", 1, fontsContainer["pricebr"]) + 10
						local vehicleNAWidth = dxGetTextWidth("NINCS BEÁRAZVA", 1, fontsContainer["pricebr"]) + 10

						local brandLogoPosnX = rectanglePosnX + 10
						local brandLogoPosnY = rectangleStartPosnY + 10

						local brandLogoNormal = vehicleBrandTexturesLoaded[vehicleBrands[vehicleDatas.brandManufacturer]]
						local brandLogoHover = vehicleBrandTexturesLoaded[vehicleBrands[vehicleDatas.brandManufacturer .. "H"]]

						--[[local sideImage = false

						if vehicleSideTexturesLoaded[vehicleDatas.modelId] then
							sideImage = vehicleSideTexturesLoaded[vehicleDatas.modelId]
						else
							sideImage = vehicleSideTexturesLoaded["all"]
						end]] -- IDEIGLENES

						local carSignShadowPosnX = rectanglePosnX + 12
						local carSignPosnX = rectanglePosnX + 10
						local carSignPosnY = rectangleStartPosnY + rectangleHeight - 30
						local carSignText = vehicleDatas.brandSign

						local carNameShadowPosnX = rectanglePosnX + 12
						local carNamePosnX = rectanglePosnX + 10
						local carNamePosnY = rectangleStartPosnY + rectangleHeight - 55
						local carNameText = vehicleDatas.modelName

						dxDrawRectangle(rectanglePosnX, rectangleStartPosnY, rectangleWidth, rectangleHeight, tocolor(colorBackgroundR, colorBackgroundG, colorBackgroundB, colorBackgroundA))
						dxDrawRectangleBorder(rectanglePosnX, rectangleStartPosnY, rectangleWidth, rectangleHeight, "inner", tocolor(colorBorderR, colorBorderG, colorBorderB, colorBorderA))
					
						--dxDrawText(vehicleDatas.modelName, rectanglePosnX, rectangleStartPosnY, rectanglePosnX + rectangleWidth, rectangleStartPosnY + rectangleHeight, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center")

						--[[if sideImage then
							dxDrawImage(rectanglePosnX + 2, rectangleStartPosnY, rectangleWidth, rectangleHeight, sideImage, 0, 0, 0, tocolor(0, 0, 0, 100))
							dxDrawImage(rectanglePosnX, rectangleStartPosnY, rectangleWidth, rectangleHeight, sideImage, 0, 0, 0, tocolor(255, 255, 255, 255))
						end]] -- IDEIGLENES

						if brandLogoPosnX and brandLogoPosnY then
							local brandLogoSize = 25

							if brandLogoSize and brandLogoNormal then
								if vehicleSelected == i + carshopPageStart and brandLogoHover then
									dxDrawImage(brandLogoPosnX + 2, brandLogoPosnY + 2, brandLogoSize, brandLogoSize, brandLogoNormal, 0, 0, 0, tocolor(0, 0, 0, 100))
									dxDrawImage(brandLogoPosnX, brandLogoPosnY, brandLogoSize, brandLogoSize, brandLogoHover)
								else
									dxDrawImage(brandLogoPosnX + 2, brandLogoPosnY + 2, brandLogoSize, brandLogoSize, brandLogoNormal, 0, 0, 0, tocolor(0, 0, 0, 100))
									dxDrawImage(brandLogoPosnX, brandLogoPosnY, brandLogoSize, brandLogoSize, brandLogoNormal)
								end
							end
						end

						if carNamePosnX and carNamePosnY then
							local carNameShadowSizeX = carNameShadowPosnX + rectangleWidth
							local carNameSizeX = carNamePosnX + rectangleWidth
							local carNameSizeY = carNamePosnY + 30

							if carNameSizeX and carNameSizeY then
								dxDrawText(carNameText, carNameShadowPosnX, carNamePosnY, carNameShadowSizeX, carNameSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["namebb"], "left", "center", false, false, false, false)
								dxDrawText(carNameText, carNamePosnX, carNamePosnY, carNameSizeX, carNameSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["namebb"], "left", "center", false, false, false, false)
							end
						end

						if carSignPosnX and carSignPosnY then
							local carSignShadowSizeX = carSignShadowPosnX + rectangleWidth
							local carSignSizeX = carSignPosnX + rectangleWidth
							local carSignSizeY = carSignPosnY + 30

							if carSignSizeX and carSignSizeY then
								dxDrawText(carSignText, carSignShadowPosnX, carSignPosnY, carSignShadowSizeX, carSignSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["namebr"], "left", "center", false, false, false, false)
								dxDrawText(carSignText, carSignPosnX, carSignPosnY, carSignSizeX, carSignSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["namebr"], "left", "center", false, false, false, false)
							end
						end

						if vehiclePriceDollar or vehiclePricePremium then
							if (vehiclePriceDollar and not vehicleDatas.premiumOnly) and (vehiclePricePremium and vehicleDatas.premiumCanBuy) then
								local dollarPosnX = rectanglePosnX + rectangleWidth - vehicleDollarWidth - 10 - vehiclePremiumWidth - 10
								local dollarPosnY = rectangleStartPosnY + 10

								if dollarPosnX and dollarPosnY then
									local dollarSizeX = vehicleDollarWidth
									local dollarSizeY = 25

									if dollarSizeX and dollarSizeY then
										local dollarText = "$" .. vehiclePriceDollar

										if dollarText then
											dxDrawRectangle(dollarPosnX, dollarPosnY, dollarSizeX, dollarSizeY, tocolor(63, 185, 159, 255))
											dxDrawText(dollarText, dollarPosnX + 2, dollarPosnY, dollarPosnX + 2 + dollarSizeX, dollarPosnY + dollarSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
											dxDrawText(dollarText, dollarPosnX, dollarPosnY, dollarPosnX + dollarSizeX, dollarPosnY + dollarSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
										end
									end
								end

								local premiumPosnX = rectanglePosnX + rectangleWidth - vehiclePremiumWidth - 10
								local premiumPosnY = rectangleStartPosnY + 10

								if premiumPosnX and premiumPosnY then
									local premiumSizeX = vehiclePremiumWidth
									local premiumSizeY = 25

									if premiumSizeX and premiumSizeY then
										local premiumText = vehiclePricePremium .. " PP"

										if premiumText then
											dxDrawRectangle(premiumPosnX, premiumPosnY, premiumSizeX, premiumSizeY, tocolor(49, 154, 215, 255))
											dxDrawText(premiumText, premiumPosnX + 2, premiumPosnY, premiumPosnX + 2 + premiumSizeX, premiumPosnY + premiumSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
											dxDrawText(premiumText, premiumPosnX, premiumPosnY, premiumPosnX + premiumSizeX, premiumPosnY + premiumSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
										end
									end
								end
							elseif vehiclePriceDollar and not vehicleDatas.premiumOnly then
								local dollarPosnX = rectanglePosnX + rectangleWidth - vehicleDollarWidth - 10
								local dollarPosnY = rectangleStartPosnY + 10

								if dollarPosnX and dollarPosnY then
									local dollarSizeX = vehicleDollarWidth
									local dollarSizeY = 25

									if dollarSizeX and dollarSizeY then
										local dollarText = "$" .. vehiclePriceDollar

										if dollarText then
											dxDrawRectangle(dollarPosnX, dollarPosnY, dollarSizeX, dollarSizeY, tocolor(63, 185, 159, 255))
											dxDrawText(dollarText, dollarPosnX + 2, dollarPosnY, dollarPosnX + 2 + dollarSizeX, dollarPosnY + dollarSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
											dxDrawText(dollarText, dollarPosnX, dollarPosnY, dollarPosnX + dollarSizeX, dollarPosnY + dollarSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
										end
									end
								end
							elseif vehiclePricePremium and vehicleDatas.premiumCanBuy then
								local premiumPosnX = rectanglePosnX + rectangleWidth - vehiclePremiumWidth - 10
								local premiumPosnY = rectangleStartPosnY + 10

								if premiumPosnX and premiumPosnY then
									local premiumSizeX = vehiclePremiumWidth
									local premiumSizeY = 25

									if premiumSizeX and premiumSizeY then
										local premiumText = vehiclePricePremium .. " PP"

										if premiumText then
											dxDrawRectangle(premiumPosnX, premiumPosnY, premiumSizeX, premiumSizeY, tocolor(49, 154, 215, 255))
											dxDrawText(premiumText, premiumPosnX + 2, premiumPosnY, premiumPosnX + 2 + premiumSizeX, premiumPosnY + premiumSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
											dxDrawText(premiumText, premiumPosnX, premiumPosnY, premiumPosnX + premiumSizeX, premiumPosnY + premiumSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
										end
									end
								end
							end
						else
							local naPosnX = rectanglePosnX + rectangleWidth - vehicleNAWidth - 10
							local naPosnY = rectangleStartPosnY + 10

							if naPosnX and naPosnY then
								local naSizeX = vehicleNAWidth
								local naSizeY = 25

								if naSizeX and naSizeY then
									local naText = "NINCS BEÁRAZVA"

									if naText then
										dxDrawRectangle(naPosnX, naPosnY, naSizeX, naSizeY, tocolor(243, 90, 90, 255))
										dxDrawText(naText, naPosnX + 2, naPosnY, naPosnX + 2 + naSizeX, naPosnY + naSizeY, tocolor(0, 0, 0, 100), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
										dxDrawText(naText, naPosnX, naPosnY, naPosnX + naSizeX, naPosnY + naSizeY, tocolor(255, 255, 255, 255), 1, fontsContainer["pricebr"], "center", "center", false, false, false, false)
									end
								end
							end
						end
					end
				end
			end
		end

		if blackSlideX and (blackSlideIn or blackSlideOut) then
			dxDrawRectangle(blackSlideX, 0, screenWidth, screenHeight, tocolor(26, 27, 31, 255))
		end

		buttonActive = false

		if isCursorShowing() then
			for buttonKey, buttonValue in pairs(buttonContainer) do
				if isMouseInPosition(buttonValue[1], buttonValue[2], buttonValue[3], buttonValue[4]) then
					buttonActive = buttonKey
					break
				end
			end
		end
	end
end

function removeHexCodes(inputString)
    return string.gsub(inputString, "#%x%x%x%x%x%x", ""):gsub("#%x%x%x", "")
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	sep = sep or '.'
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end