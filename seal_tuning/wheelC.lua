local createdCustomWheels = {}
local customWheelDatas = {}
local wheelDummys = {"wheel_lf_dummy","wheel_rf_dummy","wheel_lb_dummy","wheel_rb_dummy"}

local loggedIn = false

addEventHandler("onClientPreRender", getRootElement(), function()
    if loggedIn then
        for vehicle, data in pairs(createdCustomWheels) do
            if createdCustomWheels[vehicle] then
                local frontWheels = customWheelDatas[vehicle].front --getElementData(vehicle, "vehicle.tuning.wheelsFront") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}
                local backWheels = customWheelDatas[vehicle].back --getElementData(vehicle, "vehicle.tuning.wheelsBack") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}

                for i = 1, #wheelDummys do
                    local wheelDummy = wheelDummys[i]

                    if wheelDummy then
                        if createdCustomWheels[vehicle][wheelDummy] and isElement(createdCustomWheels[vehicle][wheelDummy].object) then
                            local x, y, z = getVehicleComponentPosition(vehicle, wheelDummy, "parent")
                            local rx, ry, rz = getVehicleComponentRotation(vehicle, wheelDummy, "world")

                            local interior = getElementInterior(vehicle)
                            local dimension = getElementDimension(vehicle)

                            setElementInterior(createdCustomWheels[vehicle][wheelDummy].object, interior)
                            setElementDimension(createdCustomWheels[vehicle][wheelDummy].object, dimension)

                            if i <= 2 then
                                local wheelOffSet = frontWheels.offset
                                local wheelWidth = frontWheels.width
                                local wheelAngle = frontWheels.angle
                                local wheelColor = frontWheels.color

								if string.find(wheelDummy, "wheel_l") then
									x, y, z = getPositionFromElementOffset(vehicle, x + 0.05 - (wheelOffSet / 10), y, z)
								else
									x, y, z = getPositionFromElementOffset(vehicle, x - 0.05 + (wheelOffSet / 10), y, z)
								end

								if wheelWidth < 0.7 then
									wheelWidth = 0.7
								end
								
								setElementPosition(createdCustomWheels[vehicle][wheelDummy].object, x, y, z)
								setElementRotation(createdCustomWheels[vehicle][wheelDummy].object, rx, ry - wheelAngle, rz, "ZYX")
								
                                setObjectScale(createdCustomWheels[vehicle][wheelDummy].object, wheelWidth, getVehicleWheelSize(vehicle), getVehicleWheelSize(vehicle))

								setVehicleComponentVisible(vehicle, "wheel_lf_dummy", false)
								setVehicleComponentVisible(vehicle, "wheel_rf_dummy", false)
                            else
                                local wheelOffSet = backWheels.offset
                                local wheelWidth = backWheels.width
                                local wheelAngle = backWheels.angle
                                local wheelColor = backWheels.color

								if string.find(wheelDummy, "wheel_l") then
									x, y, z = getPositionFromElementOffset(vehicle, x + 0.05 - (wheelOffSet / 10), y, z)
								else
									x, y, z = getPositionFromElementOffset(vehicle, x - 0.05 + (wheelOffSet / 10), y, z)
								end

								if wheelWidth < 0.7 then
									wheelWidth = 0.7
								end

								setElementPosition(createdCustomWheels[vehicle][wheelDummy].object, x, y, z)
								setElementRotation(createdCustomWheels[vehicle][wheelDummy].object, rx, ry - wheelAngle, rz, "ZYX")
								
                                setObjectScale(createdCustomWheels[vehicle][wheelDummy].object, wheelWidth, getVehicleWheelSize(vehicle), getVehicleWheelSize(vehicle))

								setVehicleComponentVisible(vehicle, "wheel_lb_dummy", false)
								setVehicleComponentVisible(vehicle, "wheel_rb_dummy", false)
                            end
                        end
                    end
                end
            end
        end
    end
end)

function addCustomWheels(vehicle)
    if vehicle and isElement(vehicle) then
        if isElementStreamedIn(vehicle) then
            if not createdCustomWheels[vehicle] then
                local frontWheels = getElementData(vehicle, "vehicle.tuning.wheelsFront") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}
                local backWheels = getElementData(vehicle, "vehicle.tuning.wheelsBack") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}

                createdCustomWheels[vehicle] = {
					wheel_lf_dummy = {},
					wheel_rf_dummy = {},
					wheel_lb_dummy = {},
					wheel_rb_dummy = {}, 
				}

				customWheelDatas[vehicle] = {}
				customWheelDatas[vehicle].front = frontWheels
				customWheelDatas[vehicle].back = backWheels

                local wheelId = frontWheels.id
                local wheelOffSet = frontWheels.offset
                local wheelWidth = frontWheels.width
                local wheelAngle = frontWheels.angle
                local wheelColor = frontWheels.color

                if wheelId and wheelId > 0 then
                    createdCustomWheels[vehicle]["wheel_lf_dummy"] = {
						object = createObject(customizableWheels[wheelId][1], 0, 0, 0),
					}

                    setElementCollisionsEnabled(createdCustomWheels[vehicle]["wheel_lf_dummy"].object, false)
                    
                    createdCustomWheels[vehicle]["wheel_rf_dummy"] = {
						object = createObject(customizableWheels[wheelId][1], 0, 0, 0),
					}

					setElementCollisionsEnabled(createdCustomWheels[vehicle]["wheel_rf_dummy"].object, false)
            
                    setVehicleComponentVisible(vehicle, "wheel_lf_dummy", false)
					setVehicleComponentVisible(vehicle, "wheel_rf_dummy", false)
                else
                    setVehicleComponentVisible(vehicle, "wheel_lf_dummy", true)
					setVehicleComponentVisible(vehicle, "wheel_rf_dummy", true)
                end

                local wheelId = backWheels.id
                local wheelOffSet = backWheels.offset
                local wheelWidth = backWheels.width
                local wheelAngle = backWheels.angle
                local wheelColor = backWheels.color

                if wheelId and wheelId > 0 then
                    createdCustomWheels[vehicle]["wheel_lb_dummy"] = {
						object = createObject(customizableWheels[wheelId][1], 0, 0, 0),
					}

                    setElementCollisionsEnabled(createdCustomWheels[vehicle]["wheel_lb_dummy"].object, false)

                    createdCustomWheels[vehicle]["wheel_rb_dummy"] = {
						object = createObject(customizableWheels[wheelId][1], 0, 0, 0),
					}

					setElementCollisionsEnabled(createdCustomWheels[vehicle]["wheel_rb_dummy"].object, false)
            
                    setVehicleComponentVisible(vehicle, "wheel_lb_dummy", false)
					setVehicleComponentVisible(vehicle, "wheel_rb_dummy", false)
                else
					setVehicleComponentVisible(vehicle, "wheel_lb_dummy", true)
					setVehicleComponentVisible(vehicle, "wheel_rb_dummy", true)
                end
            else
				local frontWheels = getElementData(vehicle, "vehicle.tuning.wheelsFront") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}
                local backWheels = getElementData(vehicle, "vehicle.tuning.wheelsBack") or {id = 0, width = 0, angle = 0, color = {255, 255, 255}}
				local hasObject = true

				customWheelDatas[vehicle] = {}
				customWheelDatas[vehicle].front = frontWheels
				customWheelDatas[vehicle].back = backWheels

				if not customizableWheels[frontWheels.id] or not customizableWheels[backWheels.id] then
					hasObject = false
				end

				if createdCustomWheels[vehicle] and createdCustomWheels[vehicle]["wheel_lf_dummy"] and hasObject then
					if createdCustomWheels[vehicle]["wheel_lf_dummy"].object and isElement(createdCustomWheels[vehicle]["wheel_lf_dummy"].object) then
						setElementModel(createdCustomWheels[vehicle]["wheel_lf_dummy"].object, customizableWheels[frontWheels.id][1])
					else
						hasObject = false
					end
				end
				if createdCustomWheels[vehicle] and createdCustomWheels[vehicle]["wheel_rf_dummy"] and hasObject then
					if createdCustomWheels[vehicle]["wheel_rf_dummy"].object and isElement(createdCustomWheels[vehicle]["wheel_rf_dummy"].object) then
						setElementModel(createdCustomWheels[vehicle]["wheel_rf_dummy"].object, customizableWheels[frontWheels.id][1])
					else
						hasObject = false
					end
				end

				if createdCustomWheels[vehicle] and createdCustomWheels[vehicle]["wheel_lb_dummy"] and hasObject then
					if createdCustomWheels[vehicle]["wheel_lb_dummy"].object and isElement(createdCustomWheels[vehicle]["wheel_lb_dummy"].object) then
						setElementModel(createdCustomWheels[vehicle]["wheel_lb_dummy"].object, customizableWheels[backWheels.id][1])
					else
						hasObject = false
					end
				end
				if createdCustomWheels[vehicle] and createdCustomWheels[vehicle]["wheel_rb_dummy"] and hasObject then
					if createdCustomWheels[vehicle]["wheel_rb_dummy"].object and isElement(createdCustomWheels[vehicle]["wheel_rb_dummy"].object) then
						setElementModel(createdCustomWheels[vehicle]["wheel_rb_dummy"].object, customizableWheels[backWheels.id][1])
					else
						hasObject = false
					end
				end

				if not hasObject then
					removeCustomWheels(vehicle)
					addCustomWheels(vehicle)
				end
            end
        end
    end
end

function removeCustomWheels(vehicle)
    if vehicle and isElement(vehicle) then
		if createdCustomWheels[vehicle] then
			for k, v in ipairs(wheelDummys) do
				if isElement(createdCustomWheels[vehicle][v].object) then
					destroyElement(createdCustomWheels[vehicle][v].object)
				end
			end
			createdCustomWheels[vehicle] = nil
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	    for k, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle.tuning.wheelsFront") or getElementData(v, "vehicle.tuning.wheelsBack") then
            addCustomWheels(v)
        end
    end

	loggedIn = getElementData(localPlayer, "loggedIn") or false
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		addCustomWheels(source)
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		removeCustomWheels(source)
	end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		removeCustomWheels(source)
	end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
	if source == localPlayer then
		if dataName == "loggedIn" then
			loggedIn = newValue
		end
	end

	if getElementType(source) == "vehicle" then
		if isElementStreamedIn(source) then
			if dataName == "vehicle.tuning.wheelsFront" then
				addCustomWheels(source)
			elseif dataName == "vehicle.tuning.wheelsBack" then
				addCustomWheels(source)
			end
		end
	end
end)

customizationTemp = {}
customization = {
    front = {
        id = 1,
        offset = 0,
        width = 1,
        angle = 0,
        color = {255, 255, 255},
    },

	back = {
        id = 1,
        offset = 0,
        width = 1,
        angle = 0,
        color = {255, 255, 255},
    },
}

function destroyWheelCustomization(reset)
    if reset then
        local playerVehicle = getPedOccupiedVehicle(localPlayer)

        if isElement(playerVehicle) then
            setElementData(playerVehicle, "vehicle.tuning.wheelsFront", customizationTemp.front, false)
            setElementData(playerVehicle, "vehicle.tuning.wheelsBack", customizationTemp.back, false)
        end
    end

    if exports.seal_gui:isGuiElementValid(wheelCustomBg) then
        exports.seal_gui:deleteGuiElement(wheelCustomBg)
    end

    customization.front = {
        id = 1,
        offset = 0,
        width = 1,
        angle = 0,
        color = {255, 255, 255},
    }
    customization.back = {
        id = 1,
        offset = 0,
        width = 1,
        angle = 0,
        color = {255, 255, 255},
    }
end

function createWheelCustomization(x, y)
    local x, y = x or 0, y or 0
    local pedveh = getPedOccupiedVehicle(localPlayer)

    if pedveh then
        customizationTemp.front = getElementData(pedveh, "vehicle.tuning.wheelsFront")
        customizationTemp.back = getElementData(pedveh, "vehicle.tuning.wheelsBack")

        if not customizationTemp.front then
            customizationTemp.front = customization.front
            customizationTemp.back = customization.back

            customizationTemp.reset = true
        end

        customization.front = getElementData(pedveh, "vehicle.tuning.wheelsFront") or customization.front
        customization.back = getElementData(pedveh, "vehicle.tuning.wheelsBack") or customization.back

        local sx, sy = 300, 200
        wheelCustomBg = exports.seal_gui:createGuiElement("rectangle", x, y, sx, sy)
        exports.seal_gui:setGuiBackground(wheelCustomBg, "solid", "grey1")

        local label = exports.seal_gui:createGuiElement("label", 6, 0, sx, 36, wheelCustomBg)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Kerekek szerkesztése")
        exports.seal_gui:setLabelAlignment(label, "left", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 61, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "setWheelType")
        exports.seal_gui:setSliderValue(slider, customization.front.id/8)
        local label = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Kerék típusa")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wheelType = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(wheelType, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wheelType, customization.front.id)
        exports.seal_gui:setLabelAlignment(wheelType, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 100, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "setWheelAngle")
        exports.seal_gui:setSliderValue(slider, customization.front.angle/25)
        local label = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Kerék dőlés")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wheelAngle = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(wheelAngle, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wheelAngle, customization.front.angle)
        exports.seal_gui:setLabelAlignment(wheelAngle, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 142, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "setWheelOffSet")
        exports.seal_gui:setSliderValue(slider, customization.front.offset/2)
        local label = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Kerék pozíció")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wheelOffSet = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(wheelOffSet, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wheelOffSet, customization.front.offset)
        exports.seal_gui:setLabelAlignment(wheelOffSet, "right", "center")

        local slider = exports.seal_gui:createGuiElement("slider", 6, 184, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setSliderColor(slider, "grey2", "purple")
        exports.seal_gui:setSliderChangeEvent(slider, "setWheelWidth")
        exports.seal_gui:setSliderValue(slider, customization.front.width/1.3)
        local label = exports.seal_gui:createGuiElement("label", 6, 163, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(label, "Kerék szélessége")
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        wheelWidth = exports.seal_gui:createGuiElement("label", 6, 163, sx - 12, 10, wheelCustomBg)
        exports.seal_gui:setLabelFont(wheelWidth, "10/Ubuntu-R.ttf")
        exports.seal_gui:setLabelText(wheelWidth, customization.front.width)
        exports.seal_gui:setLabelAlignment(wheelWidth, "right", "center")
    end
end

addEvent("setWheelType", true)
addEventHandler("setWheelType", getRootElement(), function(el, value)
    local newValue = math.floor(value * 8)
    if newValue ~= customization.front.id then
        customization.front.id = newValue
        customization.back.id = customization.front.id

        if customization.front.width < 0.7 then
            customization.front.width = 0.7
        end
        if customization.back.width < 0.7 then
            customization.back.width = 0.7
        end

        customization.updated = true
        
        local playerVehicle = getPedOccupiedVehicle(localPlayer)
        if isElement(playerVehicle) then
            setElementData(playerVehicle, "vehicle.tuning.wheelsFront", customization.front, false)
            setElementData(playerVehicle, "vehicle.tuning.wheelsBack", customization.back, false)
        end

        if exports.seal_gui:isGuiElementValid(wheelType) then
            exports.seal_gui:setLabelText(wheelType, customization.front.id)
        end
    end
end)

addEvent("setWheelAngle", true)
addEventHandler("setWheelAngle", getRootElement(), function(el, value)
    local newValue = math.floor(value * 11)
    
    if newValue ~= customization.front.width then
        customization.front.angle = newValue
        customization.back.angle = customization.front.angle
        if customization.front.width < 0.7 then
            customization.front.width = 0.7
        end
        if customization.back.width < 0.7 then
            customization.back.width = 0.7
        end

        local playerVehicle = getPedOccupiedVehicle(localPlayer)
        if isElement(playerVehicle) then
            setElementData(playerVehicle, "vehicle.tuning.wheelsFront", customization.front, false)
            setElementData(playerVehicle, "vehicle.tuning.wheelsBack", customization.back, false)
        end
        
        if exports.seal_gui:isGuiElementValid(wheelAngle) then
            exports.seal_gui:setLabelText(wheelAngle, customization.front.angle)
        end
    end
end)

addEvent("setWheelOffSet", true)
addEventHandler("setWheelOffSet", getRootElement(), function(el, value)
    local newValue = math.round(value * 1.25, 2)

    if newValue ~= customization.front.width then
        customization.front.offset = newValue
        customization.back.offset = customization.front.offset
        if customization.front.width < 0.7 then
            customization.front.width = 0.7
        end
        if customization.back.width < 0.7 then
            customization.back.width = 0.7
        end

        local playerVehicle = getPedOccupiedVehicle(localPlayer)
        if isElement(playerVehicle) then
            setElementData(playerVehicle, "vehicle.tuning.wheelsFront", customization.front, false)
            setElementData(playerVehicle, "vehicle.tuning.wheelsBack", customization.back, false)
        end

        if exports.seal_gui:isGuiElementValid(wheelOffSet) then
            exports.seal_gui:setLabelText(wheelOffSet, customization.front.offset)
        end
    end
end)

addEvent("setWheelWidth", true)
addEventHandler("setWheelWidth", getRootElement(), function(el, value)
    local value = value + 0.9
    newValue = math.round(value * 0.7, 2)

    if newValue ~= customization.back.width then
        customization.front.width = newValue
        customization.back.width = customization.front.width
        customization.front.width = math.max(0, math.min(1.3, customization.front.width))
        customization.back.width = customization.front.width
        if customization.front.width < 0.7 then
            customization.front.width = 0.7
        end
        if customization.back.width < 0.7 then
            customization.front.width = 0.7
        end

        local playerVehicle = getPedOccupiedVehicle(localPlayer)
        if isElement(playerVehicle) then
            setElementData(playerVehicle, "vehicle.tuning.wheelsFront", customization.front, false)
            setElementData(playerVehicle, "vehicle.tuning.wheelsBack", customization.back, false)
        end

        if exports.seal_gui:isGuiElementValid(wheelWidth) then
            exports.seal_gui:setLabelText(wheelWidth, customization.front.width)
        end
    end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end