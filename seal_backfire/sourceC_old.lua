local vehBackfires = {}
local vehicleFireTick = 0
local enabledVehicles = {
	[527] = true,
	[503] = true,
	[426] = true,
	[566] = true,
	[579] = true,
	[540] = true,
	[489] = true,
	[602] = true,
	[541] = true,
	[402] = true,
}

function getPositionFromElementOffset(element, x, y, z)
	local m = getElementMatrix(element)
	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		   x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		   x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end


function getElementSpeed(element)
	local vx,vy,vz = getElementVelocity(element)
    return (vx * vx + vy * vy + vz * vz) * 0.5
end

function isHaveBackfire(vehicle)
  return vehBackfires[vehicle]
end

addEvent("onBackFire", true)
addEventHandler("onBackFire", getRootElement(), 
	function(sound, speed, consistence)
		if isElement(source) and source then
			if sound and speed and consistence then
				if sound then
					currentBackfireSound = sound
				else
					currentBackfireSound = 0
				end

				local s = playSound3D("sound/" .. currentBackfireSound .. ".wav", getElementPosition(source))
				setElementDimension(s, getElementDimension(localPlayer))
				setElementInterior(s, getElementInterior(localPlayer))
				setSoundVolume(s, 0.7)

				if speed then
					length = (400 * speed) + 250
				else
					length = 400
				end
				
				local fireTexNum = math.random(1,8)
				local vehX, vehY, vehZ = getElementPosition(source)
				local exhaustX, exhaustY, exhaustZ = getVehicleModelExhaustFumesPosition((getElementModel(source)))

				table.insert(vehBackfires, {
					fireTexNum,
					source,
					getTickCount(),
					exhaustX, 
					exhaustY, 
					exhaustZ,
					length,
					consistence
				})

				if bitAnd(getVehicleHandling(source).modelFlags, 8192) == 8192 then
					local fireTexNum = math.random(1,8)
					local vehX, vehY, vehZ = getElementPosition(source)
					local exhaustX, exhaustY, exhaustZ = getVehicleModelExhaustFumesPosition((getElementModel(source)))
					table.insert(vehBackfires, {
						fireTexNum,
						source,
						getTickCount(),
						-exhaustX,
						exhaustY,
						exhaustZ,
						length,
						consistence
					})
				end
			else
				for k = 1, 2 do 
					local vehX, vehY, vehZ = getElementPosition(source)
					local exhaustX, exhaustY, exhaustZ = getVehicleModelExhaustFumesPosition((getElementModel(source)))
					table.insert(vehBackfires, {
						createEffect("gunflash", vehX, vehY, vehZ),
						source,
						getTickCount(),
						exhaustX, 
						exhaustY, 
						exhaustZ
					})
				end

				if bitAnd(getVehicleHandling(source).modelFlags, 8192) == 8192 then
					for k = 1, 2 do
						local vehX, vehY, vehZ = getElementPosition(source)
						local exhaustX, exhaustY, exhaustZ = getVehicleModelExhaustFumesPosition((getElementModel(source)))
						table.insert(vehBackfires, {
							createEffect("gunflash", vehX, vehY, vehZ),
							source,
							getTickCount(),
							-exhaustX,
							exhaustY - 0.1,
							exhaustZ
						})
					end
				end
				setSoundVolume(playSound3D("sound/0.wav", getElementPosition(source)), 0.7)
			end
		end
	end
)

local s = 1.25
local fireTex = false
local sparkTex = false
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		fireTex = dxCreateTexture("images/fire.dds", "dxt5")
		sparkTex = dxCreateTexture("images/spark.dds", "dxt5")
	end
)

addEventHandler("onClientElementDataChange", getRootElement(), 
	function(_ARG_0_)
  		if source == getPedOccupiedVehicle(localPlayer) and (string.find(_ARG_0_, "vehicle.tuning") or _ARG_0_ == "vehicle.backfire") then
			vehicleTuning = 0
			vehicleTuning = vehicleTuning + (getElementData(source, "vehicle.tuning.ECU") or 0)
			vehicleTuning = vehicleTuning + (getElementData(source, "vehicle.tuning.Engine") or 0)
			vehicleTuning = vehicleTuning + (getElementData(source, "vehicle.tuning.Turbo") or 0)
			vehicleTuning = vehicleTuning + (getElementData(source, "vehicle.tuning.Transmission") or 0)
			if getElementData(source, "vehicle.backfire") == 0 then
				vehicleTuning = 0
			end
		end
	end
)

function processBackfire()
	for k = 1, #vehBackfires do
		if vehBackfires[k] and vehBackfires[k][8] then
			local fireTexNum, source, tick, x, y, z, duration = unpack(vehBackfires[k])
			if isElement(vehBackfires[k][2]) then
				local elapsedTime = getTickCount() - tick
				local p = elapsedTime / 100
				local p2 = 1
				if 1 < p then
				  p2 = 2 - p
				end
				if 1 < p then
				  p = 1
				end
				if p2 < 0 then
				  p2 = 0
				end

				local m = getElementMatrix(source)
				local fx = x
				local fy = y
				local fz = z
				local x = fx * m[1][1] + fy * m[2][1] + fz * m[3][1] + m[4][1]
				local y = fx * m[1][2] + fy * m[2][2] + fz * m[3][2] + m[4][2]
				local z = fx * m[1][3] + fy * m[2][3] + fz * m[3][3] + m[4][3]
				local sp = s * p
				local rx, ry, rz = -m[2][1], -m[2][2], -m[2][3]
				
				dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, fireTex, s / 2, tocolor(255, 255, 255, 200), false, x, y, z + 1)
				dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, fireTex, s / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z)
				dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, fireTex, s / 2, tocolor(255, 255, 255, 200), false, x + 1, y, z + 1)
				dxDrawMaterialSectionLine3D(x + rx * sp, y + ry * sp, z + rz * sp, x + rx * (s * (1 - p2)), y + ry * (s * (1 - p2)), z + rz * (s * (1 - p2)), math.random(0, 7) * 128, 256 * (1 - p), 128, 256 * p * p2, fireTex, s / 2, tocolor(255, 255, 255, 200), false, x - 1, y, z + 1)
			  

				if elapsedTime >= duration then
					vehBackfires[k] = nil
				end
			else
				vehBackfires[k] = nil
			end
		else
			if vehBackfires[k] then
	      		if isElement(vehBackfires[k][2]) and isElement(vehBackfires[k][1]) then
					setEffectSpeed(vehBackfires[k][1], 0.5)
				setElementPosition(vehBackfires[k][1], getPositionFromElementOffset(vehBackfires[k][2], vehBackfires[k][4], vehBackfires[k][5], vehBackfires[k][6]))
					local rot = Vector3(getElementRotation(vehBackfires[k][2]))
					setElementRotation(vehBackfires[k][1], 0, 90, -rot.z - 90)
					if getTickCount() - vehBackfires[k][3] > 250 then
						destroyElement(vehBackfires[k][1])
						vehBackfires[k] = nil
					end
				else
					if isElement(vehBackfires[k][1]) then
						destroyElement(vehBackfires[k][1])
					end
					vehBackfires[k] = nil
				end
			end
		end
	end

	if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		if getPedOccupiedVehicle(localPlayer) ~= vehGearSecond then
			vehGearFirst, vehGearSecond = getVehicleCurrentGear((getPedOccupiedVehicle(localPlayer))), getPedOccupiedVehicle(localPlayer)
			vehicleTuning = 0
			vehicleTuning = vehicleTuning + (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.ECU") or 0)
			vehicleTuning = vehicleTuning + (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Engine") or 0)
			vehicleTuning = vehicleTuning + (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Turbo") or 0)
			vehicleTuning = vehicleTuning + (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.tuning.Transmission") or 0)
			if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.backfire") == 0 then
				vehicleTuning = 0
			end
		end

		if vehicleTuning >= 16 and (getElementModel((getPedOccupiedVehicle(localPlayer))) == 549 or getElementModel((getPedOccupiedVehicle(localPlayer))) == 602  or getElementModel((getPedOccupiedVehicle(localPlayer))) == 502 or getElementModel((getPedOccupiedVehicle(localPlayer))) == 494) and getPedControlState("accelerate") and (getPedControlState("handbrake") or getPedControlState("brake_reverse")) and getTickCount() - vehicleFireTick > 100 then
			vehicleFireTick = getTickCount()
			triggerServerEvent("onBackFire", getPedOccupiedVehicle(localPlayer), getElementsByType("player", getRootElement(), true))
		end

		if vehGearFirst ~= getVehicleCurrentGear((getPedOccupiedVehicle(localPlayer))) then
			vehGearFirst = getVehicleCurrentGear((getPedOccupiedVehicle(localPlayer)))
			if vehicleTuning >= 16 then
				triggerServerEvent("onBackFire", getPedOccupiedVehicle(localPlayer), getElementsByType("player", getRootElement(), true))

				if not getPedControlState("accelerate") then
					local customBackfire = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customBackfire") or false

					if customBackfire then
						backfireValue = (customBackfire.consistence * 10) + 1

						setTimer(
							function()
								triggerServerEvent("onBackFire", getPedOccupiedVehicle(localPlayer), getElementsByType("player", getRootElement(), true))
							end, 150, backfireValue
						)
					end
				end
			end
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), processBackfire)

addEventHandler("onClientElementStreamOut", getRootElement(), 
	function()
		if isElement(vehBackfires[source]) then
			destroyElement(vehBackfires[source])
		end

		vehBackfires[source] = nil
	end
)
addEventHandler("onClientElementDestroy", getRootElement(), 
	function()
		if isElement(vehBackfires[source]) then
			destroyElement(vehBackfires[source])
		end

		vehBackfires[source] = nil
	end
)

local screenX, screenY = guiGetScreenSize()

local backfireSelector = false
local backfireDatas = {
	sound = 0,
	speed = 0,
	consistence = 0
}

function createBackfireSelector(x, y)
	local pedveh = getPedOccupiedVehicle(localPlayer)

	if pedveh then
		local tempDatas = getElementData(pedveh, "vehicle.customBackfire") or backfireDatas
		setElementData(pedveh, "vehicle.customBackfireTemp", tempDatas)
		backfireDatas = tempDatas

		local sx, sy = 300, 159
		backfireSelector = exports.seal_gui:createGuiElement("rectangle", x, y, sx, sy)
		exports.seal_gui:setGuiBackground(backfireSelector, "solid", "grey1")
	
		local rect = exports.seal_gui:createGuiElement("rectangle", 0, 0, sx, 2, backfireSelector)
		exports.seal_gui:setGuiBackground(rect, "solid", {255, 255, 255, 50})
		
		local rect = exports.seal_gui:createGuiElement("rectangle", 0, sy - 2, sx, 2, backfireSelector)
		exports.seal_gui:setGuiBackground(rect, "solid", {255, 255, 255, 50})

		local rect = exports.seal_gui:createGuiElement("rectangle", 0, 2, 2, sy - 4, backfireSelector)
		exports.seal_gui:setGuiBackground(rect, "solid", {255, 255, 255, 50})

		local rect = exports.seal_gui:createGuiElement("rectangle", sx - 2, 2, 2, sy - 4, backfireSelector)
		exports.seal_gui:setGuiBackground(rect, "solid", {255, 255, 255, 50})

		local label = exports.seal_gui:createGuiElement("label", 6, 0, sx, 36, backfireSelector)
		exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(label, "Backfire szerkesztés")
		exports.seal_gui:setLabelAlignment(label, "left", "center")

		local slider = exports.seal_gui:createGuiElement("slider", 6, 61, sx - 12, 10, backfireSelector)
		exports.seal_gui:setSliderColor(slider, "grey2", "purple")
		exports.seal_gui:setSliderChangeEvent(slider, "setBackfireSound")
		exports.seal_gui:setSliderValue(slider, tempDatas.sound/12)
		local label = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(label, "Hang")
		exports.seal_gui:setLabelAlignment(label, "left", "center")
		sound = exports.seal_gui:createGuiElement("label", 6, 42, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(sound, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(sound, tempDatas.sound)
		exports.seal_gui:setLabelAlignment(sound, "right", "center")
	
		local slider = exports.seal_gui:createGuiElement("slider", 6, 100, sx - 12, 10, backfireSelector)
		exports.seal_gui:setSliderColor(slider, "grey2", "purple")
		exports.seal_gui:setSliderChangeEvent(slider, "setBackfireSpeed")
		exports.seal_gui:setSliderValue(slider, tempDatas.speed)
		local label = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(label, "Sebesség")
		exports.seal_gui:setLabelAlignment(label, "left", "center")
		speed = exports.seal_gui:createGuiElement("label", 6, 79, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(speed, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(speed, 0)
		exports.seal_gui:setLabelAlignment(speed, "right", "center")
		exports.seal_gui:setLabelText(speed, math.round(tempDatas.speed, 2))

		local slider = exports.seal_gui:createGuiElement("slider", 6, 142, sx - 12, 10, backfireSelector)
		exports.seal_gui:setSliderColor(slider, "grey2", "purple")
		exports.seal_gui:setSliderChangeEvent(slider, "setBackfireConsistence")
		exports.seal_gui:setSliderValue(slider, tempDatas.consistence)
		local label = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(label, "Sűrűség")
		exports.seal_gui:setLabelAlignment(label, "left", "center")
		consistence = exports.seal_gui:createGuiElement("label", 6, 121, sx - 12, 10, backfireSelector)
		exports.seal_gui:setLabelFont(consistence, "10/Ubuntu-R.ttf")
		exports.seal_gui:setLabelText(consistence, 0)
		exports.seal_gui:setLabelAlignment(consistence, "right", "center")
		exports.seal_gui:setLabelText(consistence, math.round(tempDatas.consistence, 2))

		addEventHandler("onClientKey", root, backfireSelectorKey)
	end
end

function destroyBackfireSelector()
	if backfireSelector then
		exports.seal_gui:deleteGuiElement(backfireSelector)
	end

	backfireSelector = false
	backfireDatas = {
		sound = 0,
		speed = 0,
		consistence = 0
	}

	removeEventHandler("onClientKey", root, backfireSelectorKey)
end

addEvent("setBackfireSound", true)
addEventHandler("setBackfireSound", root,
	function (el, value)
		backfireDatas.sound = math.floor(value*12)
		exports.seal_gui:setLabelText(sound, backfireDatas.sound)
		setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customBackfireTemp", backfireDatas)
	end
)

addEvent("setBackfireSpeed", true)
addEventHandler("setBackfireSpeed", root,
	function (el, value)
		backfireDatas.speed = math.round(value, 2)
		exports.seal_gui:setLabelText(speed, backfireDatas.speed)
		setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customBackfireTemp", backfireDatas)
	end
)

addEvent("setBackfireConsistence", true)
addEventHandler("setBackfireConsistence", root,
	function (el, value)
		backfireDatas.consistence = math.round(value, 2)
		exports.seal_gui:setLabelText(consistence, backfireDatas.consistence)
		setElementData(getPedOccupiedVehicle(localPlayer), "vehicle.customBackfireTemp", backfireDatas)
	end
)

local lastTestTick = 0

function backfireSelectorKey(key, press)
	if key == "lalt" and press then
		if getTickCount() - lastTestTick > 1000 then
			lastTestTick = getTickCount()
			triggerServerEvent("onBackFire", getPedOccupiedVehicle(localPlayer), getElementsByType("player", getRootElement(), true), backfireDatas)
		end
	end
end

function getBackfireDatas()
	return backfireDatas
end

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

addCommandHandler("getinfo",
    function ()
        local info = dxGetStatus ()
        for k, v in pairs (info) do
            outputChatBox (k .. " : " .. tostring (v))
        end
    end
)