addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        bigFont = exports.seal_gui:getFont("19/BebasNeueBold.otf")
        bigFontScale = exports.seal_gui:getFontScale("19/BebasNeueBold.otf")
        bigFontH = exports.seal_gui:getFontHeight("19/BebasNeueBold.otf")
        midFont = exports.seal_gui:getFont("10/BebasNeueBold.otf")
        midFontScale = exports.seal_gui:getFontScale("10/BebasNeueBold.otf")
        midFontH = exports.seal_gui:getFontHeight("10/BebasNeueBold.otf")
        speedoColor = exports.seal_gui:getColorCodeToColor("hudwhite")
        speedoColorEx = bitReplace(speedoColor, bitExtract(speedoColor, 0, 8) * 0.55, 0, 8)
        speedoColorEx = bitReplace(speedoColorEx, bitExtract(speedoColor, 8, 8) * 0.55, 8, 8)
        speedoColorEx = bitReplace(speedoColorEx, bitExtract(speedoColor, 16, 8) * 0.55, 16, 8)
        redColor = exports.seal_gui:getColorCodeToColor("red")

        sourceVehicle = getPedOccupiedVehicle(localPlayer)
        vehicleSeat = getPedOccupiedVehicleSeat(localPlayer)

        if sourceVehicle then
            customTurbo = getElementData(sourceVehicle, "vehicle.customTurbo") or 0
        else
            customTurbo = 0
        end
    end
)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player, seat)
		if player == localPlayer then
            sourceVehicle = getPedOccupiedVehicle(localPlayer)
            customTurbo = getElementData(sourceVehicle, "vehicle.customTurbo") or 0
            vehicleSeat = getPedOccupiedVehicleSeat(localPlayer)
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player, seat)
		if player == localPlayer then
            sourceVehicle = false
            customTurbo = false
            vehicleSeat = false
		end
	end
)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function ()
		if source == localPlayer then
            sourceVehicle = false
            customTurbo = false
            vehicleSeat = false
        end
    end
)

addEventHandler("onClientElementDataChange", getRootElement(),
    function ()
    
    end
)


addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if getElementType(source) == "vehicle" then
        if dataName == "vehicle.customTurbo" and isPedInVehicle(localPlayer) then
            if newValue then
                customTurbo = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customTurbo") or 0
            end
        end
    end
end)

render.turbo = function (x, y)
    if renderData.showTrashTray and not renderData.inTrash["turbo"] then
        return
    end

    if renderData.showTrashTray and renderData.inTrash["turbo"] then
        return
    end

    if sourceVehicle and vehicleSeat < 2 and customTurbo == 1 then
        local turboDatas = exports.seal_turbo:getVehicleTurboDatas(sourceVehicle)
        local vehicleLightState = getVehicleOverrideLights(sourceVehicle)

        local turboSizeW = 200
        local turboSizeH = 200

        local turboPosX = x
        local turboPosY = y

        local turboRadius = math.max(-36.86666666666667, turboDatas.vehSpeed * 65)

        if turboRadius < 0 then
            turboRadius = turboRadius * 2.5
        end

        local redAlphaProgress = math.min(1, math.max(0, (turboRadius - 125) / 13.888888888888888 + 1))

        if redAlphaProgress > 0 then
          dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "speedo/newimages/pulse.dds", 0, 0, 0, tocolor(245, 81, 81, 100 * redAlphaProgress))
        end

        if vehicleLightState then
            dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/light.dds", 0, 0, 0, tocolor(255, 255, 255, 100))
            dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/light2.dds", 0, 0, 0, tocolor(215, 89, 89, 100))
        end

        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/base.dds")
        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/redline.dds", 0, 0, 0, tocolor(215, 89, 89, 255))

        local rad = math.rad(35)
        local rad2 = math.rad(250) / 6

        for i = 0, 6 do
            local numberPosX = 100 - math.cos(-rad + rad2 * i) * 42
            local numberPosY = 100 - math.sin(-rad + rad2 * i) * 42

            local number = -1 + i * 0.5
            local progress = 0

            if number == 0 then
                progress = 1
            elseif number > 0 then
                progress = math.min(1, math.max(0, (turboRadius - 41.666666666666664 * (i - 2)) / 13.888888888888888 + 1))
            else
                progress = 1 - math.min(1, math.max(0, (turboRadius - 41.666666666666664 * (i - 2)) / 13.888888888888888))
            end

            if i > 4 and progress > 0 then
                dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(speedoColor, 53 * (1 - progress), 24, 8), midFontScale, midFont, "center", "center")
                dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(redColor, 255 * progress, 24, 8), midFontScale, midFont, "center", "center")
            elseif number < 0 then
                if progress > 0 then
                    dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(speedoColor, 53 * (1 - progress), 24, 8), midFontScale, midFont, "center", "center")
                    dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(speedoColorEx, 53 + 202 * progress, 24, 8), midFontScale, midFont, "center", "center")
                else
                    dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(speedoColor, 53, 24, 8), midFontScale, midFont, "center", "center")
                end
            else
                dxDrawText(number, turboPosX + numberPosX, turboPosY + numberPosY, turboPosX + numberPosX, turboPosY + numberPosY, bitReplace(speedoColor, 53 + 202 * progress, 24, 8), midFontScale, midFont, "center", "center")
            end
        end

        local barSizeW = 12
        local barSizeH = 0

        local barValue = turboRadius / 41.666666666666664 * 0.5
        local vacValue = barValue < 0
        barValue = math.abs(math.floor(barValue * 100 + 0.5))

        local digit = math.floor(barValue / 100)
        barValue = barValue - digit * 100

        local digitPosX = turboPosX + 100 - barSizeW * 3.5 / 2
        local digitPosY = turboPosY + 44

        digitColor = {}
        digitColor.defaultColor = speedoColor
        digitColor.modifiedColor = speedoColor

        if redAlphaProgress > 0 then
            digitColor.defaultColor = bitReplace(speedoColor, 255 * (1 - redAlphaProgress), 24, 8)
            digitColor.modifiedColor = bitReplace(redColor, 255 * redAlphaProgress, 24, 8)
        end

        dxDrawText(digit, digitPosX, digitPosY, digitPosX + barSizeW, turboPosY + 140, digitColor.defaultColor, bigFontScale, bigFont, "center", "center")
        if redAlphaProgress > 0 then
          dxDrawText(digit, digitPosX, digitPosY, digitPosX + barSizeW, turboPosY + 140, digitColor.modifiedColor, bigFontScale, bigFont, "center", "center")
        end

        dxDrawText(".", digitPosX + barSizeW, digitPosY, digitPosX + barSizeW * 1.5, turboPosY + 140, digitColor.defaultColor, bigFontScale, bigFont, "center", "center")
        if redAlphaProgress > 0 then
          dxDrawText(".", digitPosX + barSizeW, digitPosY, digitPosX + barSizeW * 1.5, turboPosY + 140, digitColor.modifiedColor, bigFontScale, bigFont, "center", "center")
        end

        local digit = math.floor(barValue / 10)
        barValue = barValue - digit * 10
        
        dxDrawText(digit, digitPosX + barSizeW * 1.5, turboPosY + 44, digitPosX + barSizeW * 2.5, turboPosY + 140, digitColor.defaultColor, bigFontScale, bigFont, "center", "center")
        if redAlphaProgress > 0 then
            dxDrawText(digit, digitPosX + barSizeW * 1.5, turboPosY + 44, digitPosX + barSizeW * 2.5, turboPosY + 140, digitColor.modifiedColor, bigFontScale, bigFont, "center", "center")
        end

        dxDrawText(barValue, digitPosX + barSizeW * 2.5, turboPosY + 44, digitPosX + barSizeW * 3.5, turboPosY + 140, digitColor.defaultColor, bigFontScale, bigFont, "center", "center")
        if redAlphaProgress > 0 then
            dxDrawText(barValue, digitPosX + barSizeW * 2.5, turboPosY + 44, digitPosX + barSizeW * 3.5, turboPosY + 140, digitColor.modifiedColor, bigFontScale, bigFont, "center", "center")
        end

        dxDrawText(vacValue and "VAC" or "BOOST", turboPosX, turboPosY + 44 + bigFontH, turboPosX + 200, turboPosY + 140 + bigFontH, digitColor.defaultColor, midFontScale, midFont, "center", "center")
        if redAlphaProgress > 0 then
            dxDrawText(vacValue and "VAC" or "BOOST", turboPosX, turboPosY + 44 + bigFontH, turboPosX + 200, turboPosY + 140 + bigFontH, digitColor.modifiedColor, midFontScale, midFont, "center", "center")
        end

        local sectionRotation = 48.33333333333333
        turboRadius = math.min(215 - sectionRotation, math.max(-35 - sectionRotation, turboRadius))

        if math.abs(turboRadius) >= 5 then
            if turboRadius > 0 then
                dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + turboRadius + sectionRotation, 0, 0, 126 < turboRadius and redColor or speedoColor)

                for i = 1, math.floor(math.abs(turboRadius) / 9) do
                    if i > 14 then
                        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + sectionRotation + 9 * i, 0, 0, redColor)
                    else
                        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + sectionRotation + 9 * i, 0, 0, speedoColor)
                    end
                end
            else
                dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + turboRadius + sectionRotation + 10, 0, 0, speedoColorEx)

                for i = 1, math.floor(math.abs(turboRadius) / 9) do
                    dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + sectionRotation + 10 - 9 * i, 0, 0, speedoColorEx)
                end
            end
        end

        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section.dds", 35 + sectionRotation + 4, 0, 0, speedoColorEx)
        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/section2.dds", 35 + sectionRotation + 5 + 6, 0, 0, speedoColor)

        if redAlphaProgress > 0 then
            dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/indicator.dds", turboRadius + sectionRotation, 0, 0, redColor)
        elseif turboRadius < 0 then
            dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/indicator.dds", turboRadius + sectionRotation, 0, 0, speedoColorEx)
        else
            dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/indicator.dds", turboRadius + sectionRotation)
        end

        dxDrawImage(turboPosX, turboPosY, turboSizeW, turboSizeH, "turbo/line.dds", 0, 0, 0, tocolor(0, 0, 0, 255))
    end
end