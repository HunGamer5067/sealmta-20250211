local dbConnection = false

addEventHandler("onDatabaseConnected", root,
	function (databaseConnect)
		if client then
			return
		end

		dbConnection = databaseConnection
	end
)

addEventHandler("onResourceStart", resourceRoot,
	function ()
		dbConnection = exports.seal_database:getConnection()
	end
)

addEvent("tryToSyncronizeShopVehicles", true)
addEventHandler("tryToSyncronizeShopVehicles", root,
	function ()
		if not client then
			return
		end

		if client ~= source then
			return
		end

		local vehicleModels = {}

        for i, v in ipairs(vehicleContainer) do
            table.insert(vehicleModels, v.modelId)
        end

        vehicleModels = table.concat(vehicleModels, ',')

        dbQuery(
            function (queryHandle, sourceElement)
                local queryResponse = dbPoll(queryHandle, 0)

                if queryResponse then
                    for _,r in ipairs(queryResponse) do
                        for _,v in ipairs(vehicleContainer) do
                            if v.modelId == r.modelId then
                                v.limitCurrent = r.vehicleCount
                                break
                            end
                        end
                    end

                    triggerClientEvent(sourceElement, "syncronizeShopVehicles", sourceElement, vehicleContainer)
                end
            end, {client},
        dbConnection, 'SELECT modelId, COUNT(vehicleId) AS vehicleCount FROM vehicles WHERE modelId IN (' .. vehicleModels .. ') AND groupId = 0 AND ownerId > 0 GROUP BY modelId')
	end
)

addEvent("tryToBuyVehicle", true)
addEventHandler("tryToBuyVehicle", root,
	function (vehicleModelId, paymentMethod, vehicleColor, vehicleCustomPlate, shopCategory)
		if not client then
			return
		end

		if client ~= source then
			return
		end

		if not vehicleModelId then
			return
		end

		if not paymentMethod then
			return
		end

		if not vehicleColor then
			return
		end

		if not shopCategory then
			return
		end

		if vehicleCustomPlate then
			dbQuery(
				function (queryHandle, sourceElement)
					local queryResult = dbPoll(queryHandle, 0)

					if queryResult and queryResult[1] and queryResult[1].plateState > 0 then
						exports.seal_gui:showInfobox(sourceElement, "error", "Ez a rendszám már foglalt, válasz másikat!")
						triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
						return
					else
						proceedWithVehiclePurchase(sourceElement, vehicleModelId, paymentMethod, vehicleColor, vehicleCustomPlate, shopCategory)
					end
				end,
				{client}, dbConnection, "SELECT COUNT(1) AS plateState FROM vehicles WHERE plateText = ? LIMIT 1", vehicleCustomPlate
			)
		else
			proceedWithVehiclePurchase(client, vehicleModelId, paymentMethod, vehicleColor, nil, shopCategory)
		end
	end
)

function proceedWithVehiclePurchase(clientElement, vehicleModelId, paymentMethod, vehicleColor, vehicleCustomPlate, shopCategory)
	local vehicleModels = {}

    for i, v in ipairs(vehicleContainer) do
        table.insert(vehicleModels, v.modelId)
    end

    vehicleModels = table.concat(vehicleModels, ',')

    dbQuery(
        function (queryHandle, sourceElement)
            local queryResponse = dbPoll(queryHandle, 0)

            if queryResponse then
                for _,r in ipairs(queryResponse) do
                    for _,v in ipairs(vehicleContainer) do
                        if v.modelId == r.modelId then
                            v.limitCurrent = r.vehicleCount
                            break
                        end
                    end
                end

                local serverResponse = "unsuccessful"
                local vehicleFoundData = false

                for i = 1, #vehicleContainer do
                	local vehicleData = vehicleContainer[i]

                	if vehicleData.modelId == vehicleModelId then
                		vehicleFoundData = i
                		break
                	end
                end

               	if vehicleFoundData then
               		local vehicleDatas = vehicleContainer[vehicleFoundData]

               		if vehicleDatas then
               			if not vehicleSpawnPoints[shopCategory] or not shopCategory then
               				exports.seal_gui:showInfobox(sourceElement, "warning", "A márkakereskedésnek nincsen létrehozási koordinátája, keress fel egy fejlesztőt!")
							triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
               				return
               			end

               			local vehiclePriceDollar = vehicleDatas.priceMoney
               			local vehiclePricePremium = vehicleDatas.pricePremium

               			local vehicleCurrentLimit = vehicleDatas.limitCurrent
           				local vehicleMaximumLimit = vehicleDatas.limitMaximum

           				local vehiclePriceMultiplier = 1
           				local vehicleLimitReached = false

           				local vehiclePaymentMethod = "unknown"
                   		local vehiclePaymentPrice = false

                   		local vehicleHaveToPayPremiumPlate = false

                   		local randomizeSpawnPosition = math.random(#vehicleSpawnPoints[shopCategory])
                   		local randomizeSelected = vehicleSpawnPoints[shopCategory][randomizeSpawnPosition]

                   		local randomizedPosnX = randomizeSelected[1]
                   		local randomizedPosnY = randomizeSelected[2]
                   		local randomizedPosnZ = randomizeSelected[3]

                   		local randomizedRotZ = randomizeSelected[4]

           				if vehicleCurrentLimit >= vehicleMaximumLimit then
           					vehiclePriceMultiplier = 2
           					vehicleLimitReached = true
           				end

               			if vehiclePriceDollar or vehiclePricePremium then
               				if vehicleCurrentLimit and vehicleMaximumLimit then
                   				local vehiclePremiumOnly = vehicleDatas.premiumOnly or false
                   				local vehiclePremiumCanBuy = vehicleDatas.premiumCanBuy or false

								if (vehiclePriceDollar and not vehiclePremiumOnly) and (vehiclePricePremium and vehiclePremiumCanBuy) then
									if paymentMethod == 1 then
										if not vehicleLimitReached then
											vehiclePaymentMethod = "dollar"
											vehiclePaymentPrice = vehiclePriceDollar
										else
											vehiclePaymentMethod = "reached"
											vehiclePaymentPrice = 0
										end
									elseif paymentMethod == 2 then
										vehiclePaymentMethod = "premium"

										if not vehicleLimitReached then
											vehiclePaymentPrice = vehiclePricePremium
										else
											vehiclePaymentPrice = vehiclePricePremium * vehiclePriceMultiplier
										end
									else
										vehiclePaymentMethod = "unknown"
										vehiclePaymentPrice = false
									end
								elseif vehiclePriceDollar and not vehiclePremiumOnly then
									if paymentMethod == 1 then
										vehiclePaymentMethod = "dollar"

										if not vehicleLimitReached then
											vehiclePaymentPrice = vehiclePriceDollar
										else
											vehiclePaymentPrice = vehiclePriceDollar * vehiclePriceMultiplier
										end
									else
										vehiclePaymentMethod = "unknown"
										vehiclePaymentPrice = false
									end
								elseif vehiclePricePremium and vehiclePremiumCanBuy then
									if paymentMethod == 2 then
										vehiclePaymentMethod = "premium"

										if not vehicleLimitReached then
											vehiclePaymentPrice = vehiclePricePremium
										else
											vehiclePaymentPrice = vehiclePricePremium * vehiclePriceMultiplier
										end
									else
										vehiclePaymentMethod = "unknown"
										vehiclePaymentPrice = false
									end
								end
							end
						else
							vehiclePaymentMethod = "unknown"
							vehiclePaymentPrice = false
						end

						if vehiclePaymentMethod and vehiclePaymentMethod ~= "unknown" then
							if vehiclePaymentPrice then
								if vehiclePaymentMethod == "reached" then
									exports.seal_gui:showInfobox(sourceElement, "warning", "A jármű limitje megtelt, már csak prémiumpontból lehet megvásárolni!")
									triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
									return
								end

								if not exports.seal_items:hasSpaceForItem(sourceElement, 1, 1) then
									exports.seal_gui:showInfobox(sourceElement, "error", "Nincs elég hely az inventorydban a kulcshoz.")
									triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
									return
								end

								if vehiclePaymentMethod == "dollar" then
									if vehicleCustomPlate then
										vehicleHaveToPayPremiumPlate = true
									end
								elseif vehiclePaymentMethod == "premium" then
									if vehicleCustomPlate then
										vehiclePaymentPrice = vehiclePaymentPrice + vehiclePlatePrice
									end
								end

								local clientMoney = getElementData(sourceElement, "char.Money") or 0
								local clientPremium = getElementData(sourceElement, "acc.premiumPoints") or 0

								local clientBought = false

								if vehiclePaymentMethod == "premium" then
									if clientPremium < vehiclePaymentPrice then
										exports.seal_gui:showInfobox(sourceElement, "warning", "Nincs elég prémiumpontod a jármű megvásárlásához!")
										triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
										return
									end
									clientBought = true

									setElementData(sourceElement, "acc.premiumPoints", clientPremium - vehiclePaymentPrice)
								elseif vehiclePaymentMethod == "dollar" then
									if clientMoney < vehiclePaymentPrice then
										exports.seal_gui:showInfobox(sourceElement, "warning", "Nincs elég készpénzed a jármű megvásárlásához!")
										triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
										return
									end

									if vehicleHaveToPayPremiumPlate then
										if clientPremium < vehiclePlatePrice then
											exports.seal_gui:showInfobox(sourceElement, "warning", "Nincs elég prémiumpontod a rendszám megvásárlásához!")
											triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, "unsuccessful")
											return
										end
									end

									clientBought = true

									setElementData(sourceElement, "char.Money", clientMoney - vehiclePaymentPrice)
								else
									exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X5]")
								end

								if clientBought then
									serverResponse = "successful"

									exports.seal_vehicles:createPermVehicle({
										modelId = vehicleDatas.modelId,
										color1 = string.format("#%.2X%.2X%.2X", vehicleColor[1] or 255, vehicleColor[2] or 255, vehicleColor[3] or 255),
										color2 = string.format("#%.2X%.2X%.2X", vehicleColor[1] or 255, vehicleColor[2] or 255, vehicleColor[3] or 255),
										targetPlayer = sourceElement,
										plateText = vehicleCustomPlate,
										posX = randomizedPosnX,
				          				posY = randomizedPosnY,
				          				posZ = randomizedPosnZ,
				          				rotX = 0,
				          				rotY = 0,
				          				rotZ = randomizedRotZ,
				          				interior = 0,
				          				dimension = 0
									}, true)
								else
									exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X6]")
								end
							else
								exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X4]")
							end
						else
							exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X3]")
						end
               		else
               			exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X2]")
               		end
               	else
               		exports.seal_gui:showInfobox(sourceElement, "error", "Hiba történt a jármű vásárlásakor próbálkozz újra. [X1]")
               	end

               	if serverResponse then
               		triggerClientEvent(sourceElement, "gotResponseFromServer", sourceElement, serverResponse)
               	end
            end
        end, {clientElement},
    dbConnection, 'SELECT modelId, COUNT(vehicleId) AS vehicleCount FROM vehicles WHERE modelId IN (' .. vehicleModels .. ') AND groupId = 0 AND ownerId > 0 GROUP BY modelId')
end