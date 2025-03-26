-- ** MAX SPEED NEM VAN JOL
-- ** FUEL TÍPUS LEKÉRÉS HIÁNYZIK
-- ** FUEL MAX LITER LEKÉRÉS HIÁNYZIK
-- ** KERÉK MEGHAJTÁS HIÁNYZIK
-- ** CSOMAGTÉR MÉRETE HIÁNYZIK

vehicleDefaults = {
	vehicleLimit = 50,
	vehiclePremiumOnly = false,
	vehiclePremiumCanBuy = true,
	vehicleBrandCategory = "default",
	vehicleBrandManufacturer = "SEAL",
	vehicleBrandSign = "Alacsony értéktartás",
}

vehicleContainer = {
	--[[
		{
			modelId = Jármű model idje ha nem adod meg autómatikusan törlésre kerül
			modelName = Jármű neve (Ha nem írsz ide semmit tehát "modelName = false" vagy egyáltalán nincs itt nem gond megpróbálja kikérni custom vehicle nameből a nevet ha nincs akkor N/A,

			limitCurrent = Jármű jelenlegi limitje (Nem kell változtatni),
			limitMaximum = Jármű maximum limitje,

			priceMoney = Jármű ára ($)
			pricePremium = Jármű ára (PP) (Ide mindenképp írj valamit mivel ha betelik a limit csak a megadott PPvel tudja megvenni)

			premiumOnly = Jármű csak prémiumpontal megvehető
			premiumCanBuy = Jármű megvásárolható prémiumpontal (Ha nem akkor amint betelik a limit többé nem lehet vásárolni autókereskedésben a járművet)

			brandCategory = Jármű a megadott márka autókereskedésében lesz csak kapható
			brandManufacturer = Jármű típusa pl.: BMW - Audi - Volkswagen
			brandSign = Jármű márka tartása pl.: Magas értéktartás, Közepes értéktartás, Alacsony értéktartás
		}
	]]
	{
		modelId = 445,

		limitCurrent = 0,
		limitMaximum = 100,

		priceMoney = 820000,
		pricePremium = 20000,

		brandManufacturer = "BMW"
	},
	{
		modelId = 405,

		limitCurrent = 0,
		limitMaximum = 80,

		priceMoney = 640000,
		pricePremium = 22000,
	},
	{
		modelId = 400,

		limitCurrent = 0,
		limitMaximum = 35,

		priceMoney = 1500000,
		pricePremium = 46500,
	},
	{
		modelId = 549,

		limitCurrent = 0,
		limitMaximum = 2,

		priceMoney = 2600000,
		pricePremium = 71000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 466,

		limitCurrent = 0,
		limitMaximum = 35,

		priceMoney = 980000,
		pricePremium = 32000,
	},
	{
		modelId = 492,

		limitCurrent = 0,
		limitMaximum = 130,

		priceMoney = 830000,
		pricePremium = 21500,

		brandManufacturer = "BMW",
	},
	{
		modelId = 420,

		limitCurrent = 0,
		limitMaximum = 28,

		priceMoney = 1250000,
		pricePremium = 35000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 541,

		limitCurrent = 0,
		limitMaximum = 26,

		priceMoney = 1400000,
		pricePremium = 26000,
	},
	{
		modelId = 546,

		limitCurrent = 0,
		limitMaximum = 70,

		priceMoney = 1950000,
		pricePremium = 32000,
	},
	{
		modelId = 506,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 40000,
	},
	{
		modelId = 479,

		limitCurrent = 0,
		limitMaximum = 55,

		priceMoney = 1720000,
		pricePremium = 29500,
	},
	{
		modelId = 604,

		limitCurrent = 0,
		limitMaximum = 3,

		priceMoney = 2900000,
		pricePremium = 52000,
	},
	{
		modelId = 579,

		limitCurrent = 0,
		limitMaximum = 300,

		priceMoney = 850000,
		pricePremium = 15000,
	},
	{
		modelId = 540,

		limitCurrent = 0,
		limitMaximum = 75,

		priceMoney = 620000,
		pricePremium = 19000,
	},
	{
		modelId = 589,

		limitCurrent = 0,
		limitMaximum = 33,

		priceMoney = 1280000,
		pricePremium = 23000,
	},
	{
		modelId = 458,

		limitCurrent = 0,
		limitMaximum = 180,

		priceMoney = 300000,
	},
	{
		modelId = 467,

		limitCurrent = 0,
		limitMaximum = 42,

		priceMoney = 1400000,
		pricePremium = 29900,
	},
	{
		modelId = 507,

		limitCurrent = 0,
		limitMaximum = 15,

		priceMoney = 3200000,
		pricePremium = 48000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 585,

		limitCurrent = 0,
		limitMaximum = 21,

		priceMoney = 2200000,
		pricePremium = 38000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 551,

		limitCurrent = 0,
		limitMaximum = 27,

		priceMoney = 2500000,
		pricePremium = 41000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 426,

		limitCurrent = 0,
		limitMaximum = 170,

		priceMoney = 758000,
		pricePremium = 16000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 529,

		limitCurrent = 0,
		limitMaximum = 47,

		priceMoney = 1750000,
		pricePremium = 26000,
	},
	{
		modelId = 527,

		limitCurrent = 0,
		limitMaximum = 18,

		priceMoney = 2350000,
		pricePremium = 45000,

		brandManufacturer = "BMW",
	},
	{
		modelId = 526,

		limitCurrent = 0,
		limitMaximum = 35,

		priceMoney = 710000,
		pricePremium = 23000,
	},
	{
		modelId = 421,

		limitCurrent = 0,
		limitMaximum = 20,

		priceMoney = 1600000,
		pricePremium = 38000,
	},
	{
		modelId = 517,

		limitCurrent = 0,
		limitMaximum = 30,

		priceMoney = 2300000,
		pricePremium = 38000,
	},
	{
		modelId = 489,

		limitCurrent = 0,
		limitMaximum = 18,

		priceMoney = 1900000,
		pricePremium = 33000,
	},
	{
		modelId = 582,

		limitCurrent = 0,

		priceMoney = 500000,
		pricePremium = 10000,
	},
	{
		modelId = 545,

		limitCurrent = 0,
		limitMaximum = 16,

		priceMoney = 5000000,
		pricePremium = 45000,
	},
	{
		modelId = 505,

		limitCurrent = 0,
		limitMaximum = 21,

		priceMoney = 4300000,
		pricePremium = 42000,
	},
	{
		modelId = 560,

		limitCurrent = 0,
		limitMaximum = 10,

		priceMoney = 6200000,
		pricePremium = 38500,
	},
	{
		modelId = 516,

		limitCurrent = 0,
		limitMaximum = 14,

		priceMoney = 4800000,
		pricePremium = 32000,
	},
	{
		modelId = 561,

		limitCurrent = 0,
		limitMaximum = 28,

		priceMoney = 5000000,
		pricePremium = 30000,
	},
	{
		modelId = 547,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 110000,
	},

	-- * BBRABUS

	{
		modelId = 550,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 90000,

		brandCategory = "brabus"
	},
	{
		modelId = 602,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 110000,

		brandCategory = "brabus"
	},
	{
		modelId = 580,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 135000,

		brandCategory = "brabus"
	},
	{
		modelId = 566,

		limitCurrent = 0,
		limitMaximum = 0,

		pricePremium = 85000,

		brandCategory = "brabus"
	},

	-- * Hajóbolt

	{
		modelId = 453,

		limitCurrent = 0,

		priceMoney = 400000,

		brandCategory = "boat"
	},
}

vehiclePlatePrice = 500

if triggerClientEvent then
	vehicleSpawnPoints = {
		--[Kategória] = {
			--{X, Y, Z, ROTZ}
		--}
		["default"] = {
			{2147.6228027344, -1138.8580322266, 25.447820663452, 270},
			{2147.9763183594, -1143.2890625, 24.963464736938, 270},
			{2147.482421875, -1148.5133056641, 24.384544372559, 270},
			{2147.6845703125, -1152.8912353516, 23.905992507935, 270},
		},
		["brabus"] = {
			{1247.873046875, -1164.8919677734, 23.776893615723, 0},
		},
		["boat"] = {
			{722.95300292969, -1505.1831054688, -0.58813565969467, 180},
		}
	}
end

if triggerServerEvent then
	colorSwitch = {}

	defaultBorderColor = tocolor(0, 0, 0, 180)
	defaultBorderSize = 2

	vehicleBrandTexturesLoaded = {}
	vehicleBrandTextureToBeLoaded = {
		"gtasa",
		"gtasa_hover",
		"bmw",
	}

	vehicleSideTexturesLoaded = {}
	vehicleSideTextureToBeLoaded = {
		{"all", "gtasa"},
	}

	vehicleBrands = {
		["SEAL"] = "gtasa",
		["SEALH"] = "gtasa_hover",
		["BMW"] = "bmw",
	}

	vehicleTexturesLoaded = {}
	vehicleTexturesToBeLoaded = {
		"vignette",
		"wallet",
		"premium",
		"null",
		"license",
		"picker",
		"mark",
		"menu_r",
		"menu_l",
	}

	vehicleShopElements = {}
	vehicleShopContainer = {
		--[[
			{NAME, SKIN ID, X, Y, Z, ROT, CATEGORY}
		]]
		{"Michael", 123, 2131.8200683594, -1150.7442626953, 24.123756408691, 0},
		{"Fosos Ferenc", 142, 1241.9879150391, -1170.0759277344, 23.700656890869, 44, "brabus"},
		{"Hajóbolt", 142, 722.47064208984, -1496.0904541016, 1.9343447685242, 0, "boat"}
	}

	vehicleShopCategorys = {
		["brabus"] = "Brabus Márkakereskedés",
		["alpina"] = "Alpina Márkakereskedés",
		["boat"] = "Hajó kereskedés"
	}

	vehicleCategoryShops = {
		--[CategoryName] = {VEHX, VEHY, VEHZ, ROTZ, CAMX, CAMY, CAMZ, CAMTX, CAMTY, CAMTZ}
		["default"] = {233.35227966309, -105.84027099609, 1.4296875, 23.793556213379, 228.39970397949, -100.92729949951, 2.5646998882294, 229.11622619629, -101.60194396973, 2.3873629570007},
		["brabus"] = {283.22845458984, -81.286201477051, 1.4228166341782, 58.908985137939, 279.17419433594, -78.598899841309, 2.5241000652313, 279.97406005859, -79.159820556641, 2.3105916976929},
		["boat"] = {728.21081542969, -1524.8615722656, 0.73434489965439, 725.12451171875, -1508.7138671875, 4.8534002304077, 725.42535400391, -1509.5770263672, 4.4479503631592}
	}

	fontsContainer = {}
	fontsToBeLoaded = {
		{"pricebr", "files/fonts/BebasNeueRegular.otf", 17},

		{"namebb", "files/fonts/BebasNeueBold.otf", 16},
		{"namebr", "files/fonts/BebasNeueRegular.otf", 14},

		{"titlebb", "files/fonts/BebasNeueBold.otf", 23},
		{"titlebr", "files/fonts/BebasNeueRegular.otf", 15},

		{"buybr", "files/fonts/BebasNeueRegular.otf", 15},

		{"tpricebr", "files/fonts/BebasNeueRegular.otf", 16},
		{"tpricebb", "files/fonts/BebasNeueBold.otf", 23},

		{"license", "files/fonts/License.ttf", 23},

		{"data", "files/fonts/Solid.otf", 15},
		{"datadesc", "files/fonts/BebasNeueBold.otf", 14},
		{"datavalue", "files/fonts/BebasNeueRegular.otf", 13},

		{"prompttitle", "files/fonts/BebasNeueBold.otf", 20},
		{"promptbutton", "files/fonts/BebasNeueRegular.otf", 13},

		{"instruction", "files/fonts/BebasNeueRegular.otf", 15},
	}

	function loadCarshopPeds(pedId, pedDatas)
		if pedId and pedDatas then
			local pedName = pedDatas[1]
			local pedSkinId = pedDatas[2]

			if pedName and pedSkinId then
				local pedPositionX = pedDatas[3]
				local pedPositionY = pedDatas[4]
				local pedPositionZ = pedDatas[5]

				if pedPositionX and pedPositionY and pedPositionZ then
					local pedRotation = pedDatas[6]
					local pedCategory = pedDatas[7] or "default"

					if pedRotation and pedCategory then
						if not vehicleShopElements[pedId] then
							vehicleShopElements[pedId] = {}
						end

						local pedElement = createPed(pedSkinId, pedPositionX, pedPositionY, pedPositionZ, pedRotation)

						if pedElement then
							local rotationDegree = pedRotation
							local rotationRadian = math.rad(rotationDegree + 90)
							local rotationDistance = 2

							if rotationDegree and rotationRadian and rotationDistance then
								local collisionPositionX = pedPositionX + math.cos(rotationRadian) * rotationDistance
								local collisionPositionY = pedPositionY + math.sin(rotationRadian) * rotationDistance

								if collisionPositionX and collisionPositionY then
									local colElement = createColSphere(collisionPositionX, collisionPositionY, pedPositionZ, 2)

									if colElement then
										setElementData(pedElement, "carshop.Ped", true)
										setElementData(pedElement, "carshop.Id", pedId)
										setElementData(pedElement, "carshop.Category", pedCategory)

										setElementData(pedElement, "invulnerable", true)
										setElementData(pedElement, "visibleName", pedName)
										setElementFrozen(pedElement, true)

										if vehicleShopCategorys[pedCategory] then
											setElementData(pedElement, "pedNameType", vehicleShopCategorys[pedCategory])
										else
											setElementData(pedElement, "pedNameType", "Autókereskedés")
										end

										setElementData(colElement, "carshop.Col", true)
										setElementData(colElement, "carshop.Id", pedId)
										setElementData(colElement, "carshop.Category", pedCategory)
										setElementData(colElement, "carshop.PedElement", pedElement)

										if not vehicleShopElements[pedId]["ped"] then
											vehicleShopElements[pedId]["ped"] = pedElement
										end

										if not vehicleShopElements[pedId]["col"] then
											vehicleShopElements[pedId]["col"] = colElement
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	function dxDrawRectangleBorder(posnX, posnY, sizeX, sizeY, borderType, borderColor, borderSize)
		borderType = borderType or "inner"
		borderColor = borderColor or defaultBorderColor
		borderSize = borderSize or defaultBorderSize

		if borderType == "outer" then
			dxDrawRectangle(posnX - borderSize, posnY - borderSize, sizeX + 2 * borderSize, borderSize, borderColor) -- felső
			dxDrawRectangle(posnX - borderSize, posnY + sizeY, sizeX + 2 * borderSize, borderSize, borderColor) -- alsó
			dxDrawRectangle(posnX - borderSize, posnY, borderSize, sizeY, borderColor) -- bal
			dxDrawRectangle(posnX + sizeX, posnY, borderSize, sizeY, borderColor) -- jobb
		elseif borderType == "inner" then
			dxDrawRectangle(posnX, posnY, sizeX, borderSize, borderColor) -- felső
			dxDrawRectangle(posnX, posnY + sizeY - borderSize, sizeX, borderSize, borderColor) -- alsó
			dxDrawRectangle(posnX, posnY + borderSize, borderSize, sizeY - 2 * borderSize, borderColor) -- bal
			dxDrawRectangle(posnX + sizeX - borderSize, posnY + borderSize, borderSize, sizeY - 2 * borderSize, borderColor) -- jobb
		end
	end

	function processColorSwitchEffect(key, r, g, b, a, effectDuration, effectEasingType)
	    local effectData = colorSwitch[key] or {}

	    r = tonumber(r) or 255
	    g = tonumber(g) or 255
	    b = tonumber(b) or 255
	    a = tonumber(a) or 255

	    local hexCode = string.format("%x", 0x01000000 * a + 0x010000 * r + 0x0100 * g + b)

	    if not effectData[1] then
	        effectData = {r, g, b, a, hexCode}
	    end

	    effectDuration = tonumber(effectDuration) or 500

	    if effectData[5] ~= hexCode then
	        effectData[5] = hexCode
	        effectData[6] = getTickCount()
	    end

	    if effectData[6] then
	        local linearValue = math.min(1, (getTickCount() - effectData[6]) / (tonumber(effectDuration) or 500))
	        local easingValue = getEasingValue(linearValue, effectEasingType or "Linear")

	        effectData[1] = effectData[1] + (r - effectData[1]) * easingValue
	        effectData[2] = effectData[2] + (g - effectData[2]) * easingValue
	        effectData[3] = effectData[3] + (b - effectData[3]) * easingValue
	        effectData[4] = effectData[4] + (a - effectData[4]) * easingValue

	        if linearValue >= 1 then
	            effectData[6] = nil
	        end
	    end

	    colorSwitch[key] = effectData

	    return effectData[1], effectData[2], effectData[3], effectData[4]
	end

	for i = 1, #vehicleShopContainer do
		local vehicleShopDatas = vehicleShopContainer[i]

		if vehicleShopDatas then
			loadCarshopPeds(i, vehicleShopDatas)
		end
	end

	for i = 1, #vehicleTexturesToBeLoaded do
		local textureName = vehicleTexturesToBeLoaded[i]

		if textureName then
			if not vehicleTexturesLoaded[textureName] then
				vehicleTexturesLoaded[textureName] = dxCreateTexture("files/images/" .. textureName .. ".dds", "argb", true)
			end
		end
	end

	for i = 1, #vehicleBrandTextureToBeLoaded do
		local textureName = vehicleBrandTextureToBeLoaded[i]

		if textureName then
			if not vehicleBrandTexturesLoaded[textureName] then
				vehicleBrandTexturesLoaded[textureName] = dxCreateTexture("files/images/brands/" .. textureName .. ".dds", "argb", true)
			end
		end
	end

	for i = 1, #vehicleSideTextureToBeLoaded do
		local textureData = vehicleSideTextureToBeLoaded[i]

		if textureData then
			local textureId = textureData[1]
			local texturePath = textureData[2]

			if textureId and texturePath then
				vehicleSideTexturesLoaded[textureId] = dxCreateTexture("files/images/sidephotos/" .. texturePath .. ".dds", "argb", true)
			end
		end
	end

	for i = 1, #fontsToBeLoaded do
		local fontData = fontsToBeLoaded[i]

		if fontData then
			local fontName = fontData[1]
			local fontPath = fontData[2]

			local fontSize = fontData[3]

			if fontName and fontPath and fontSize then
				fontsContainer[fontName] = dxCreateFont(fontPath, fontSize)
			end
		end
	end
end

for i = #vehicleContainer, 1, -1 do
	local vehicleDatas = vehicleContainer[i]

	if vehicleDatas then
		if not vehicleDatas.modelId then
			table.remove(vehicleDatas, i)
		end
	end
end

for i = 1, #vehicleContainer do
	local vehicleDatas = vehicleContainer[i]

	if vehicleDatas then
		if not vehicleDatas.modelName then
			local customName = exports.seal_vehiclenames:getCustomVehicleName(vehicleDatas.modelId) or false

			if customName then
				vehicleDatas.modelName = customName
			else
				vehicleDatas.modelName = "N/A"
			end
		end

		if not vehicleDatas.limitCurrent then
			vehicleDatas.limitCurrent = 0
		end

		if not vehicleDatas.limitMaximum then
			vehicleDatas.limitMaximum = vehicleDefaults.vehicleLimit
		end

		if not vehicleDatas.premiumCanBuy then
			vehicleDatas.premiumCanBuy = vehicleDefaults.vehiclePremiumCanBuy
		end

		if not vehicleDatas.brandCategory then
			vehicleDatas.brandCategory = vehicleDefaults.vehicleBrandCategory
		end

		if not vehicleDatas.brandManufacturer then
			vehicleDatas.brandManufacturer = vehicleDefaults.vehicleBrandManufacturer
		end

		if not vehicleDatas.brandSign then
			vehicleDatas.brandSign = vehicleDefaults.vehicleBrandSign
		end
	end
end

function findTableByModelId(vehicleModelId)
	if vehicleModelId then
		local foundData = false

		for i = 1, #vehicleContainer do
			local vehicleDatas = vehicleContainer[i]

			if vehicleDatas then
				if vehicleDatas.modelId == vehicleModelId then
					foundData = i
					break
				end
			end
		end

		if foundData then
			return foundData
		end
	end

	return false
end

function getVehicleContainer()
	return vehicleContainer
end

function getVehiclesByCategory(categoryName)
	if categoryName then
		local categoryContainer = {}

		for i = 1, #vehicleContainer do
			local vehicleDatas = vehicleContainer[i]

			if vehicleDatas then
				local vehicleCategory = vehicleDatas.brandCategory

				if vehicleCategory and vehicleCategory == categoryName then
					table.insert(categoryContainer, vehicleDatas)
				end
			end
		end

		if categoryContainer then
			return categoryContainer
		end
	end

	return false
end

function getVehiclePremiumCanBuy(vehicleModelId)
	if vehicleModelId then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas and vehicleDatas.premiumCanBuy then
				return true
			end
		end
	end

	return false
end

function getVehiclePremiumOnly(vehicleModelId)
	if vehicleModelId then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas and vehicleDatas.premiumOnly then
				return true
			end
		end
	end

	return false
end

function getVehicleMaximumLimit(vehicleModelId)
	if vehicleModelId then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas and vehicleDatas.limitMaximum then
				return vehicleDatas.limitMaximum
			end
		end
	end

	return "N/A"
end

function getVehiclePrice(vehicleModelId, economySign)
	if vehicleModelId and economySign then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas then
				local vehiclePriceDollar = vehicleDatas.priceMoney
				local vehiclePricePremium = vehicleDatas.pricePremium

				if economySign == "dollar" then
					if vehiclePriceDollar then
						return vehiclePriceDollar
					end
				elseif economySign == "premium" then
					if vehiclePricePremium then
						return vehiclePricePremium
					end
				end
			end
		end
	end

	return "N/A"
end

function getVehicleManufacturer(vehicleModelId)
	if vehicleModelId then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas then
				local vehicleManufacturer = vehicleDatas.brandManufacturer

				if vehicleManufacturer then
					return vehicleManufacturer
				end
			end
		end
	end

	return "N/A"
end

function getVehicleBrandLogo(vehicleModelId)
	if vehicleModelId then
		local vehicleTableId = findTableByModelId(vehicleModelId)

		if vehicleTableId then
			local vehicleDatas = vehicleContainer[vehicleTableId]

			if vehicleDatas then
				local vehicleManufacturer = vehicleDatas.brandManufacturer

				if vehicleManufacturer then
					local validBrand = vehicleBrands[vehicleManufacturer]

					if validBrand then
						local validBrandTexture = vehicleBrandTexturesLoaded[validBrand]

						if validBrandTexture then
							return validBrandTexture
						end
					else
						return vehicleBrandTexturesLoaded["gtasa"]
					end
				else
					return vehicleBrandTexturesLoaded["gtasa"]
				end
			end
		end
	end

	return false
end

function getElementOffset(sourceElement, offsetX, offsetY, offsetZ)
	if sourceElement then
		local sourceMatrix = getElementMatrix(sourceElement)

		if sourceMatrix then
			local calculatedOffsetX = offsetX * sourceMatrix[1][1] + offsetY * sourceMatrix[2][1] + offsetZ * sourceMatrix[3][1] + sourceMatrix[4][1]
    		local calculatedOffsetY = offsetX * sourceMatrix[1][2] + offsetY * sourceMatrix[2][2] + offsetZ * sourceMatrix[3][2] + sourceMatrix[4][2]
    		local calculatedOffsetZ = offsetX * sourceMatrix[1][3] + offsetY * sourceMatrix[2][3] + offsetZ * sourceMatrix[3][3] + sourceMatrix[4][3]

    		if calculatedOffsetX and calculatedOffsetY and calculatedOffsetZ then
    			return calculatedOffsetX, calculatedOffsetY, calculatedOffsetZ
    		end
		end
	end

	return false
end