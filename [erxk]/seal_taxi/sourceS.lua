addEventHandler("onResourceStart", resourceRoot,
	function()
		jobPed = createPed(pedSkin, pedPosX, pedPosY, pedPosZ)
		setElementData(jobPed, "visibleName", "Michael")
        setElementData(jobPed, "pedNameType", "Taxi")
        setElementData(jobPed, "invulnerable", true)
        setElementData(jobPed, "isJobPed", true)
		setElementRotation(jobPed, 0, 0, 270)
		setElementFrozen(jobPed, true)

		for k, v in pairs(getElementsByType("player")) do
			setElementData(v, "havePassenger", false)
		end
	end
)

addEvent("onPlayerHavePassenger", true)
addEventHandler("onPlayerHavePassenger", getRootElement(),
	function()
		if client and client ~= source then
			return
		end

		setElementData(source, "havePassenger", true)
	end
)

local playerPeds = {}

addEvent("warpPedToVehicle", true)
addEventHandler("warpPedToVehicle", getRootElement(), function(ped, veh)
	if client == source then
		local vehicleElement = getPedOccupiedVehicle(client)
        local passengerPed = createPed(150, 0, 0, 0)

        if passengerPed then
	        setElementData(passengerPed, "visibleName", "Utas")
	        setElementData(passengerPed, "invulnerable", true)
	        
        	playerPeds[client] = passengerPed
        end

        if vehicleElement then
            local maxSeats = getVehicleMaxPassengers(vehicleElement)
            local seatFound = false

            for seat = 0, maxSeats do
                if not getVehicleOccupant(vehicleElement, seat) then
                    warpPedIntoVehicle(passengerPed, vehicleElement, seat)
                    outputChatBox("#fece01[SealMTA - Taxi]: #ffffffVidd el az utast a kijelölt helyre, ahol megkapod a jutalmad!", client, 255, 255, 255, true)
                    seatFound = true
                    break
                end
            end
        end
	end
end)

addEvent("onClientHitDestCol", true)
addEventHandler("onClientHitDestCol", getRootElement(), function()
    if client == source then
        if playerPeds[client] then
            local jobPrice = math.random(20000, 50000)
            local premiumPoints = math.random(40, 100)

            if playerPeds[client] then
                destroyElement(playerPeds[client])
            end
            playerPeds[client] = nil

            setElementData(client, "havePassenger", false)
            outputChatBox("#fece01[SealMTA - Taxi]: #ffffffSikeresen elvégezted a munkát, a jutalmad " .. jobPrice .. " $ és " .. premiumPoints .. " PP.", client, 255, 255, 255, true)
            exports.seal_gui:showInfobox(client, "success", "Sikeresen elvégezted a munkát, a jutalmad " .. jobPrice .. " $ és " .. premiumPoints .. " PP.")

            exports.seal_core:giveMoney(client, jobPrice)

            local currentPP = getElementData(client, "acc.premiumPoints") or 0
            setElementData(client, "acc.premiumPoints", currentPP + premiumPoints)
        end
    end
end)

addEvent("onAcceptJob", true)
addEventHandler("onAcceptJob", getRootElement(),
	function()
		if client and client ~= source then
			return
		end

		if getElementData(source, "inTaxiJob") then
			outputChatBox("#fece01[SealMTA - Taxi]: #ffffffTe már taxis vagy!", source, 255, 255, 255, true)
		else
			outputChatBox("#fece01[SealMTA - Taxi]: #ffffffSikeresen felvetted a munkát!", source, 255, 255, 255, true)
			outputChatBox("#fece01[SealMTA - Taxi]: A teendőid: #ffffffÁllj be az autóddal a parkolóba, és várj a hívásokra!", source, 255, 255, 255, true)
			exports.seal_gui:showInfobox(client, "info", "Állj be az autóddal a parkolóba, és várj a hívásokra!")
			setElementData(source, "inTaxiJob", true)
		end
	end
)

addEvent("onPlayerLeaveJob", true)
addEventHandler("onPlayerLeaveJob", getRootElement(),
	function()
		if client and client ~= source then
			return
		end

		if getElementData(source, "inTaxiJob") then
			outputChatBox("#fece01[SealMTA - Taxi]: #ffffffSikeresen leadtad a munkát!", source, 255, 255, 255, true)
			setElementData(source, "inTaxiJob", false)
		end
	end
)

addEvent("requestColHit", true)
addEventHandler("requestColHit", getRootElement(),
	function(state)
		if client and client ~= source then
			return
		end

		if state then
			setElementData(source, "taxi.canJob", state)
		end
	end
)

addEvent("requestColLeave", true)
addEventHandler("requestColLeave", getRootElement(),
	function(state)
		if client and client ~= source then
			return
		end

		if not state then
			setElementData(source, "taxi.canJob", state)
		end
	end
)