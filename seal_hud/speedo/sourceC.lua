local electricVehicles = {
    [429] = true,
    [585] = true,
    [479] = true,
	[516] = true,
}
local vehicleIndicators = {}
local vehicleIndicatorTimers = {}
local vehicleIndicatorStates = {}
local vehicleLightStates = {}
local vehicleOverrideLights = {}local engineState = false
local handBrakeState = false
local tempomatSpeed = false
local lockState = false
local windowState = false

local speedoColor = {255, 255, 255}
local speedoColor2 = {255, 255, 255}
local selectedSpeedoColor = {255, 255, 255}

local vehicleName = ""
local nitroLevel = 0

local consumptions = {}
local defaultConsumption = 1
local consumptionMultipler = 3
local consumptionValue = 0

local fuelTankSize = {}
local defaultFuelTankSize = 50
local outOfFuel = false
local fuelLevel = 0

local totalDistance = 0
local tripDistance = 0
local lastOilChange = 0

local vehicleUpdateTimer = false

local seatBeltState = false
local seatBeltChange = 0
local seatBeltIcon = true

local beltlessModels = {
	[445] = false,
}

local speedoFont46 = dxCreateFont("speedo/font.ttf", 46, true)
local speedoFont31 = dxCreateFont("speedo/font.ttf", 31, true)
local speedoFont16 = dxCreateFont("speedo/font.ttf", 16, true)

local fuelFont = dxCreateFont("speedo/font.ttf", 14, true)
local vehNameFont = dxCreateFont("files/fonts/Roboto.ttf", 12, true)
local kmFont = dxCreateFont("files/fonts/Roboto.ttf", 11, true)

local inReverseGear = false
local lastBeepStart = 0
local lastBeepStop = 0
local beepSounds = {}
local beepingTrucks = {
	[403] = true,
	[406] = true,
	[407] = true,
	[408] = true,
	[413] = true,
	[414] = true,
	[416] = true,
	[418] = true,
	[423] = true,
	[427] = true,
	[428] = true,
	[431] = true,
	[433] = true,
	[437] = true,
	[440] = true,
	[443] = true,
	[455] = true,
	[456] = true,
	[459] = true,
	[482] = true,
	[486] = true,
	[498] = true,
	[499] = true,
	[508] = true,
	[514] = true,
	[515] = true,
	[524] = true,
	[528] = true,
	[530] = true,
	[531] = true,
	[532] = true,
	[544] = true,
	[573] = true,
	[578] = true,
	[582] = true,
	[588] = true
}

local nitroTex = false
local forceHideSpeedo = false

local speedoShaderRaw = [[float minAngle = 90; float maxAngle = 115; static const float PI = 3.1415926535; float direction = 1; texture MaskTexture; sampler MaskSampler = sampler_state { Texture = <MaskTexture>; }; float4 MaskTextureMain( float2 uv : TEXCOORD0 ) : COLOR0 { float2 pixelVector = normalize(uv - float2(0.5, 0.5)); if (length(pixelVector) < 0.001) return 0; float angle = 0; if (pixelVector.x * direction < 0) angle = PI - acos(-pixelVector.y); else angle = PI + acos(-pixelVector.y); angle = angle * 180 / PI; if (angle < minAngle || angle > maxAngle) return 0; return tex2D(MaskSampler, uv); } technique Technique1 { pass Pass1 { AlphaBlendEnable = true; SrcBlend = SrcAlpha; DestBlend = InvSrcAlpha; PixelShader = compile ps_2_0 MaskTextureMain(); } }]]
local circleShaderRaw = [[//
// Example shader - circle.fx
//

//
// Based on code from:
// http://www.geeks3d.com/20130705/shader-library-circle-disc-fake-sphere-in-glsl-opengl-glslhacker/
//

float sCircleHeightInPixel = 100;
float sCircleWidthInPixel = 50;
float sBorderWidthInPixel = 10;
float sAngleStart = -3.14;
float sAngleEnd = 3.14;

texture MaskTexture;
sampler MaskSampler = sampler_state
{
    Texture = <MaskTexture>;
};

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(float2 TexCoord : TEXCOORD0) : COLOR0
{
    float2 uv = normalize(TexCoord - float2(0.5, 0.5)) ;

    // Clip unwanted pixels from partial pie
    float angle = atan2( -uv.x, uv.y );  // -PI to +PI
    if ( sAngleStart > sAngleEnd )
    {
        if ( angle < sAngleStart && angle > sAngleEnd )
            return 0;
    }
    else
    {
        if ( angle < sAngleStart || angle > sAngleEnd )
            return 0;
    }

    return tex2D(MaskSampler,TexCoord);
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique tec0
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
]]

local speedoShader = false
local fuelShader = false
local nitroShader = false

addEvent("forceHideSpeedo", true)
addEventHandler("forceHideSpeedo", root,
	function (newState)
		if newState ~= nil then
			forceHideSpeedo = newState
		end
	end
)

addEventHandler("onClientResourceStart", getRootElement(),
	function (startedres)
		tachTexture = dxCreateTexture("speedo/images/mask_tach.png", "dxt3")
		fuelTexture = dxCreateTexture("speedo/images/mask_fuel.png", "dxt3")
		nitroTexture = dxCreateTexture("speedo/images/mask_nitro.png", "dxt3")

		sectionTexture = dxCreateTexture("speedo/newimages/section.dds", "dxt3", false, "wrap")
		pulsetex = dxCreateTexture("speedo/newimages/pulse.dds", "dxt5")

		if getResourceName(startedres) == "seal_vehiclepanel" then
			consumptions = exports.seal_vehiclepanel:getTheConsumptionTable()
			fuelTankSize = exports.seal_vehiclepanel:getTheFuelTankTable()
		elseif startedres == getThisResource() then
			local seal_vehiclepanel = getResourceFromName("seal_vehiclepanel")

			if seal_vehiclepanel and getResourceState(seal_vehiclepanel) == "running" then
				consumptions = exports.seal_vehiclepanel:getTheConsumptionTable()
				fuelTankSize = exports.seal_vehiclepanel:getTheFuelTankTable()
			end

			loadVehicleData(localPlayer)
		end
	end)

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player, seat)
		if player == localPlayer then
			setElementData(source, "tempomatSpeed", false)

			tempomatSpeed = false

			loadVehicleData(localPlayer)
		end

		if source == getPedOccupiedVehicle(localPlayer) and player ~= localPlayer and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			local vehicleId = getElementData(source, "vehicle.dbID") or 0

			if vehicleId > 0 then
				updateVehicle(source, 0, vehicleId, getElementModel(source))
			end
		end
	end)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player, seat)
		if player == localPlayer then
			if seat == 0 then
				local vehicleId = getElementData(source, "vehicle.dbID") or 0
				local model = getElementModel(source)

				if vehicleId > 0 then
					updateVehicle(source, seat, vehicleId, model, true)
				end

				if beepingTrucks[model] then
					setElementData(source, "inReverseGear", false)
				end
			end

			if isTimer(vehicleUpdateTimer) then
				killTimer(vehicleUpdateTimer)
			end

			toggleNOS(false)
			startNOS("lctrl", "up")

			engineState = false
			outOfFuel = false
		end
	end)

addEventHandler("onClientPlayerWasted", getRootElement(),
	function ()
		if source == localPlayer then
			local occupiedVehicle = getPedOccupiedVehicle(localPlayer)

			if getPedOccupiedVehicleSeat(localPlayer) == 0 then
				local vehicleId = getElementData(occupiedVehicle, "vehicle.dbID") or 0

				if vehicleId > 0 then
					updateVehicle(occupiedVehicle, getPedOccupiedVehicleSeat(localPlayer), vehicleId, getElementModel(occupiedVehicle))
				end
			end

			if isTimer(vehicleUpdateTimer) then
				killTimer(vehicleUpdateTimer)
			end

			toggleNOS(false)
			startNOS("lctrl", "up")

			engineState = false
			outOfFuel = false
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if beepSounds[source] then
			if isElement(beepSounds[source]) then
				destroyElement(beepSounds[source])
			end

			beepSounds[source] = nil
		end

		if source == getPedOccupiedVehicle(localPlayer) then
			if isTimer(vehicleUpdateTimer) then
				killTimer(vehicleUpdateTimer)
			end

			toggleNOS(false)
			startNOS("lctrl", "up")
		end
	end)

function loadVehicleData(player)
	local pedveh = getPedOccupiedVehicle(player)

	if pedveh then
		local pedseat = getPedOccupiedVehicleSeat(localPlayer)

		if pedseat < 2 then
			local vehicleModel = getElementModel(pedveh)

			fuelLevel = getElementData(pedveh, "vehicle.fuel") or 50
			engineState = getElementData(pedveh, "vehicle.engine") == 1
			totalDistance = getElementData(pedveh, "vehicle.distance") or 0
			lastOilChange = getElementData(pedveh, "lastOilChange") or 0
			handBrakeState = getElementData(pedveh, "vehicle.handBrake")
			tempomatSpeed = getElementData(pedveh, "tempomatSpeed")
			nitroLevel = getElementData(pedveh, "vehicle.nitroLevel") or 0
			lockState = getElementData(pedveh, "vehicle.locked") == 1
			windowState = getElementData(pedveh, "vehicle.windowState")
			speedoColor = getElementData(pedveh, "vehicle.speedoColor") or {255, 255, 255}
			speedoColor2 = getElementData(pedveh, "vehicle.speedoColor2") or {255, 255, 255}
			vehicleName = exports.seal_vehiclenames:getCustomVehicleName(pedveh)
			eletricVehicle = exports.seal_ev:getChargingPortOffset(vehicleModel)

			local capacity = fuelTankSize[vehicleModel] or defaultFuelTankSize

			setElementData(pedveh, "vehicle.maxFuel", capacity)

			if not fuelLevel or fuelLevel > capacity then
				setElementData(pedveh, "vehicle.fuel", capacity)
				fuelLevel = capacity
			end

			consumptionValue = 0
			outOfFuel = false

			if isTimer(vehicleUpdateTimer) then
				killTimer(vehicleUpdateTimer)
			end

			if getPedOccupiedVehicleSeat(player) == 0 then
				vehicleUpdateTimer = setTimer(updateVehicle, 60000, 0)
				toggleNOS(true)
			end
			
			seatBeltState = getElementData(localPlayer, "player.seatBelt")
			seatBeltChange = getTickCount()
			seatBeltIcon = true
		end
	end
end

function updateVehicle(vehicle, seat, dbID, model, save)
	if not vehicle then
		vehicle = getPedOccupiedVehicle(localPlayer)

		if vehicle and getPedOccupiedVehicleSeat(localPlayer) == 0 and getVehicleType(vehicle) ~= "BMX" then
			local vehicleId = getElementData(vehicle, "vehicle.dbID") or 0

			if vehicleId > 0 then
				local model = getElementModel(vehicle)
				local consumption = consumptions[model] or defaultConsumption
				local fuel = fuelLevel - consumptionValue / 10000 * consumption * consumptionMultipler

				if fuel < 0 then
					fuel = 0
				end

				triggerServerEvent("updateVehicle", localPlayer, vehicle, vehicleId, save, fuel, totalDistance + tripDistance, lastOilChange)
			end
		end
	elseif seat == 0 and dbID and model and getVehicleType(vehicle) ~= "BMX" then
		local model = getElementModel(vehicle)
		local consumption = consumptions[model] or defaultConsumption
		local fuel = fuelLevel - consumptionValue / 10000 * consumption * consumptionMultipler

		if fuel < 0 then
			fuel = 0
		end

		triggerServerEvent("updateVehicle", localPlayer, vehicle, dbID, save, fuel, totalDistance + tripDistance, lastOilChange)
	end
end

addEventHandler("onClientPreRender", getRootElement(),
	function (deltaTime)
		local pedveh = getPedOccupiedVehicle(localPlayer)

		if pedveh and engineState and not outOfFuel then
			if isVehicleNitroActivated(pedveh) then
				setVehicleNitroActivated(pedveh, false)
			end

			local speed = getVehicleSpeed(pedveh)
			local decimal = 1000 / deltaTime
			local distance = speed / 3600 / decimal

			if distance * 1000 >= 1 / decimal then
				consumptionValue = consumptionValue + distance * 1000
			else
				consumptionValue = consumptionValue + 1 / decimal
			end

			local model = getElementModel(pedveh)
			local consumption = consumptions[model] or defaultConsumption

			consumption = consumptionValue / 10000 * consumption * consumptionMultipler
			tripDistance = tripDistance + distance

			--setElementData(pedveh, "tripDistance", tripDistance)

			local pedseat = getPedOccupiedVehicleSeat(localPlayer)

			if getVehicleType(pedveh) == "Automobile" then
				lastOilChange = lastOilChange + distance * 1000

				local vehicleModel = getElementModel(pedveh)
				if not exports.seal_ev:getChargingPortOffset(vehicleModel) then
					if lastOilChange > 515000 and pedseat == 0 and getElementHealth(pedveh) > 321 then
						engineState = false
						setElementHealth(pedveh, 320)
						triggerServerEvent("setVehicleHealthSync", localPlayer, pedveh, 320)
						outputChatBox("#768fe3[SealMTA - Szerelő]:#FFFFFF Mivel nem cserélted ki a motorolajat, ezért az autód motorja elromlott!", 255, 255, 255, true)
					end
				end
			end

			if fuelLevel - consumption <= 0 and pedseat == 0 then
				outOfFuel = true
				triggerServerEvent("ranOutOfFuel", localPlayer, pedveh)
				setElementData(pedveh, "vehicle.fuel", 0)
				setElementData(pedveh, "vehicle.engine", 0)
			end
		end

		if isElement(pedveh) and getVehicleController(pedveh) == localPlayer then
			if getVehicleType(pedveh) == "Automobile" then
				if not electricVehicles[getElementModel(pedveh)] then
					if getElementHealth(pedveh) <= 600 and math.random(100000) <= 20 and getVehicleEngineState(pedveh) then
						engineState = false
						setVehicleEngineState(pedveh, false)
						setElementData(pedveh, "vehicle.engine", 0)
						showInfobox("e", "Lefulladt a járműved!")
					end
				end
			end
		end

		if isElement(pedveh) and getVehicleController(pedveh) == localPlayer then
			if getVehicleType(pedveh) == "Automobile" then
				if getElementData(pedveh, "vehicle.wrongFuel") and math.random(20000) <= 20 and getVehicleEngineState(pedveh) then
					engineState = false
					setElementHealth(pedveh, 320)
					triggerServerEvent("setVehicleHealthSync", localPlayer, pedveh, 320)
					showInfobox("e", "A járműved motorja súlyosan megsérült a rossz üzemanyagtól!")
				end
			end
		end
	end)

local indicatorCoronas = {}
local indicatorStates = {}
local indicatorCount = {}

local turn_leftState = false
local turn_rightState = false

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		for veh, v in pairs(indicatorCount) do
			--if not isElement(veh) or not isElement(getVehicleOccupant(veh)) then
			if not isElement(veh) then
				indicatorCount[veh] = nil

				indicatorCoronas[veh] = nil
				indicatorStates[veh] = nil
			else
				if isElementStreamedIn(veh) then
					if getTickCount() - indicatorStates[veh][2] >= 500 then
						indicatorStates[veh] = {not indicatorStates[veh][1], getTickCount()}

						if veh == getPedOccupiedVehicle(localPlayer) then
							if indicatorStates[veh][1] then
								playSound(":seal_vehiclepanel/files/turnsignal.mp3")
							end

							if v[1] == 1 and #v == 2 then
								turn_leftState = indicatorStates[veh][1]
								turn_rightState = false
							elseif v[1] == 3 and v[2] == 4 then
								turn_leftState = false
								turn_rightState = indicatorStates[veh][1]
							elseif v[1] == 1 and #v == 4 then
								turn_leftState = indicatorStates[veh][1]
								turn_rightState = indicatorStates[veh][1]
							end
						end
					end
				end
			end
		end
	end)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "mouse1" or key == "mouse2" or key == "F6" then
			if press then
				if not isCursorShowing() and not isConsoleActive() then
					local pedveh = getPedOccupiedVehicle(localPlayer)

					if pedveh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
						local vehtype = getVehicleType(pedveh)

						if vehtype == "Automobile" or vehtype == "Quad" then
							if key == "mouse1" then
								setElementData(pedveh, "turn_right", false)
			 					setElementData(pedveh, "turn_left", not getElementData(pedveh, "turn_left"))
							elseif key == "mouse2" then
								setElementData(pedveh, "turn_left", false)
								setElementData(pedveh, "turn_right", not getElementData(pedveh, "turn_right"))
							else
								setElementData(pedveh, "turn_left", false)
								setElementData(pedveh, "turn_right", false)
								setElementData(pedveh, "emergency_light", not getElementData(pedveh, "emergency_light"))
							end
						end
					end
				end
			end
		end
	end)

local customIndicatorVehicles = {
	[529] = true,
	[589] = true,
	[566] = true,
	[549] = true,
	[527] = true,
	[502] = true,
	[495] = true,
	[480] = true,
	[470] = true,
	[559] = true,
	[503] = true,
	[405] = true,
	[507] = true,
	[600] = true,
	[518] = true,
}

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if dataName == "turn_right" or dataName == "turn_left" or dataName == "emergency_light" then
			local vehicleModel = getElementModel(source)
			if vehicleModel < 400 or vehicleModel > 611 then
				vehicleModel = getElementData(source, "vehicle.customId")
			end
			if dataName == "turn_left" then
				if not vehicleModel then return end
				if not vehicleIndicators[source] then
					vehicleIndicators[source] = {}
				end
	
				if not vehicleLightStates[source] then
					vehicleLightStates[source] = {}
	
					for i = 0, 3 do
						vehicleLightStates[source][i] = 0
					end
				end
	
				if not vehicleOverrideLights[source] then
					local lightState = getElementData(source, "vehicle.light")
	
					if not lightState then
						vehicleOverrideLights[source] = 1
					else
						vehicleOverrideLights[source] = 2
					end
				end
	
				if getElementData(source, dataName) then
					vehicleIndicators[source].left = true
	
					vehicleLightStates[source][0] = getVehicleLightState(source, 0)
					vehicleLightStates[source][3] = getVehicleLightState(source, 3)
					vehicleOverrideLights[source] = getVehicleOverrideLights(source)
	
					setVehicleOverrideLights(source, 2)
	
					if not vehicleIndicatorTimers[source] then
						processIndicatorEffect(source)
						vehicleIndicatorTimers[source] = setTimer(processIndicatorEffect, 500, 0, source)
	
						vehicleLightStates[source][1] = getVehicleLightState(source, 1)
						vehicleLightStates[source][2] = getVehicleLightState(source, 2)
					end
	
					if vehicleOverrideLights[source] ~= 2 then
						if not customIndicatorVehicles[vehicleModel] then
							setVehicleLightState(source, 1, 1)
							setVehicleLightState(source, 2, 1)
						else
							setVehicleComponentVisible(source, "indicator_l", true);setVehicleComponentVisible(source, "indicator_left", true);setVehicleComponentVisible(source, "index_l", true)
						end
					end
	
					vehicleIndicatorStates[source] = true
				else
					vehicleIndicators[source].left = false
	
					if not customIndicatorVehicles[vehicleModel] then
						setVehicleLightState(source, 0, vehicleLightStates[source][0] or 0)
						setVehicleLightState(source, 3, vehicleLightStates[source][3] or 0)
					else
						setVehicleComponentVisible(source, "indicator_l", false)
					end
	
					if not vehicleIndicators[source].left then
						if not customIndicatorVehicles[vehicleModel] then
							setVehicleLightState(source, 1, vehicleLightStates[source][1] or 0)
							setVehicleLightState(source, 2, vehicleLightStates[source][2] or 0)
							setVehicleOverrideLights(source, vehicleOverrideLights[source])
						else
							setVehicleComponentVisible(source, "indicator_l", false)
						end
	
						if isTimer(vehicleIndicatorTimers[source]) then
							killTimer(vehicleIndicatorTimers[source])
							vehicleIndicatorTimers[source] = nil
						end
	
						vehicleIndicatorStates[source] = false
					end
				end
			end
	
			if dataName == "turn_right" then
				if not vehicleIndicators[source] then
					vehicleIndicators[source] = {}
				end
	
				if not vehicleLightStates[source] then
					vehicleLightStates[source] = {}
	
					for i = 0, 3 do
						vehicleLightStates[source][i] = 0
					end
				end
	
				if not vehicleOverrideLights[source] then
					local lightState = getElementData(source, "vehicle.light")
	
					if not lightState then
						vehicleOverrideLights[source] = 1
					else
						vehicleOverrideLights[source] = 2
					end
				end
	
				if getElementData(source, dataName) then
					vehicleIndicators[source].right = true
	
					vehicleLightStates[source][1] = getVehicleLightState(source, 1)
					vehicleLightStates[source][2] = getVehicleLightState(source, 2)
					vehicleOverrideLights[source] = getVehicleOverrideLights(source)
	
					setVehicleOverrideLights(source, 2)
	
					if not vehicleIndicatorTimers[source] then
						processIndicatorEffect(source)
						vehicleIndicatorTimers[source] = setTimer(processIndicatorEffect, 500, 0, source)
	
						vehicleLightStates[source][0] = getVehicleLightState(source, 0)
						vehicleLightStates[source][3] = getVehicleLightState(source, 3)
					end
	
					if vehicleOverrideLights[source] ~= 2 then
						if not customIndicatorVehicles[vehicleModel] then
							setVehicleLightState(source, 0, 1)
							setVehicleLightState(source, 3, 1)
						else
							setVehicleComponentVisible(source, "indicator_r", true);setVehicleComponentVisible(source, "indicator_right", true);setVehicleComponentVisible(source, "index_r", true)
						end
					end
	
					vehicleIndicatorStates[source] = true
				else
					vehicleIndicators[source].right = false
	
					if not customIndicatorVehicles[vehicleModel] then
						setVehicleLightState(source, 1, vehicleLightStates[source][1] or 0)
						setVehicleLightState(source, 2, vehicleLightStates[source][2] or 0)
					else
						setVehicleComponentVisible(source, "indicator_r", false)
					end
	
					if not vehicleIndicators[source].right then
						if not customIndicatorVehicles[vehicleModel] then
							setVehicleLightState(source, 0, vehicleLightStates[source][0] or 0)
							setVehicleLightState(source, 3, vehicleLightStates[source][3] or 0)
							setVehicleOverrideLights(source, vehicleOverrideLights[source])
						else
							setVehicleComponentVisible(source, "indicator_r", false)
						end
	
						if isTimer(vehicleIndicatorTimers[source]) then
							killTimer(vehicleIndicatorTimers[source])
							vehicleIndicatorTimers[source] = nil
						end
	
						vehicleIndicatorStates[source] = false
					end
				end
			end
	
			if dataName == "emergency_light" then
				if not vehicleIndicators[source] then
					vehicleIndicators[source] = {}
				end
	
				if not vehicleLightStates[source] then
					vehicleLightStates[source] = {}
	
					for i = 0, 3 do
						vehicleLightStates[source][i] = 0
					end
				end
	
				if not vehicleOverrideLights[source] then
					local lightState = getElementData(source, "vehicle.light")
	
					if not lightState then
						vehicleOverrideLights[source] = 1
					else
						vehicleOverrideLights[source] = 2
					end
				end
	
				if getElementData(source, dataName) then
					vehicleIndicators[source].left = true
					vehicleIndicators[source].right = true
	
					for i = 0, 3 do
						vehicleLightStates[source][i] = getVehicleLightState(source, i)
					end
	
					vehicleOverrideLights[source] = getVehicleOverrideLights(source)
	
					setVehicleOverrideLights(source, 2)
	
					if not vehicleIndicatorTimers[source] then
						processIndicatorEffect(source)
						vehicleIndicatorTimers[source] = setTimer(processIndicatorEffect, 500, 0, source)
					end
	
					if vehicleOverrideLights[source] ~= 2 then
						if not customIndicatorVehicles[vehicleModel] then
							for i = 0, 3 do
								setVehicleLightState(source, i, 1)
							end
						else
							setVehicleComponentVisible(source, "indicator_l", true);setVehicleComponentVisible(source, "indicator_left", true);setVehicleComponentVisible(source, "index_l", true)
							setVehicleComponentVisible(source, "indicator_r", true);setVehicleComponentVisible(source, "indicator_right", true);setVehicleComponentVisible(source, "index_r", true)
						end
					end
	
					vehicleIndicatorStates[source] = true
				else
					vehicleIndicators[source].left = false
					vehicleIndicators[source].right = false
	
					if not customIndicatorVehicles[vehicleModel] then
						setVehicleOverrideLights(source, vehicleOverrideLights[source])
						for i = 0, 3 do
							setVehicleLightState(source, i, vehicleLightStates[source][i] or 0)
						end
					else
						setVehicleComponentVisible(source, "indicator_l", false)
						setVehicleComponentVisible(source, "indicator_r", false)
					end
	
	
					if isTimer(vehicleIndicatorTimers[source]) then
						killTimer(vehicleIndicatorTimers[source])
						vehicleIndicatorTimers[source] = nil
					end
	
					vehicleIndicatorStates[source] = false
				end
			end
		end

		if dataName == "inReverseGear" then
			if isElement(beepSounds[source]) then
				destroyElement(beepSounds[source])
			end

			if getElementData(source, dataName) and isElementStreamedIn(source) then
				local x, y, z = getElementPosition(source)

				beepSounds[source] = playSound3D(":seal_vehiclepanel/files/reverse.mp3", x, y, z, true)

				if isElement(beepSounds[source]) then
					setElementInterior(beepSounds[source], getElementInterior(source))
					setElementDimension(beepSounds[source], getElementDimension(source))
					attachElements(beepSounds[source], source)
				end
			end
		end

		if source == localPlayer and dataName == "player.seatBelt" then
			seatBeltState = getElementData(localPlayer, "player.seatBelt")
			seatBeltChange = getTickCount()
			seatBeltIcon = true
		end

		if isElement(source) and getPedOccupiedVehicle(localPlayer) == source then
			local dataValue = getElementData(source, dataName)

			if dataName == "vehicle.fuel" then
				if dataValue then
					fuelLevel = tonumber(dataValue)
					consumptionValue = 0

					if fuelLevel <= 0 then
						fuelLevel = 0
						outOfFuel = true

						triggerServerEvent("ranOutOfFuel", localPlayer, source)
						setElementData(source, "vehicle.fuel", 0)
						setElementData(source, "vehicle.engine", 0)

						if getVehicleController(source) == localPlayer then
							showInfobox("e", "Kifogyott az üzemanyag!")
						end
					else
						outOfFuel = false
					end
				end
			elseif dataName == "vehicle.distance" then
				if dataValue then
					totalDistance = tonumber(dataValue)
					tripDistance = 0
				end
			elseif dataName == "vehicle.nitroLevel" then
				if dataValue then
					nitroLevel = tonumber(dataValue)
				end
			elseif dataName == "vehicle.engine" then
				engineState = getElementData(source, "vehicle.engine") == 1
			elseif dataName == "vehicle.locked" then
				lockState = getElementData(source, "vehicle.locked") == 1
			elseif dataName == "vehicle.windowState" then
				windowState = getElementData(source, "vehicle.windowState")
			elseif dataName == "lastOilChange" then
				if dataValue then
					lastOilChange = tonumber(dataValue)
				end
			elseif dataName == "vehicle.handBrake" then
				handBrakeState = getElementData(source, "vehicle.handBrake")
			elseif dataName == "tempomatSpeed" then
				tempomatSpeed = getElementData(source, "tempomatSpeed")
			end
		end
	end)

	leftState = false

	rightState = false

	function processIndicatorEffect(vehicle)
		if isElement(vehicle) then
			local vehicleModel = getElementModel(vehicle)
			if vehicleModel < 400 or vehicleModel > 611 then
				vehicleModel = getElementData(vehicle, "vehicle.customId")
			end
			if vehicleIndicators[vehicle].left then
				leftState = (not leftState)
			else
				leftState = false
			end

			if vehicleIndicators[vehicle].right then
				rightState = (not rightState)
			else
				rightState = false
			end

			if vehicleIndicators[vehicle].left then
				if not customIndicatorVehicles[vehicleModel] then
					if vehicleLightStates[vehicle][0] ~= 1 then
						if vehicleIndicatorStates[vehicle] then
							setVehicleLightState(vehicle, 0, 0)
						else
							setVehicleLightState(vehicle, 0, 1)
						end
					end
		
					if vehicleLightStates[vehicle][3] ~= 1 then
						if vehicleIndicatorStates[vehicle] then
							setVehicleLightState(vehicle, 3, 0)
						else
							setVehicleLightState(vehicle, 3, 1)
						end
					end
				else
					if vehicleIndicatorStates[vehicle] then
						setVehicleComponentVisible(vehicle, "indicator_l", false)
					else
						setVehicleComponentVisible(vehicle, "indicator_l", true)
					end
				end
	
				if vehicle == getPedOccupiedVehicle(localPlayer) then
					currentIndicatorState = vehicleIndicatorStates[vehicle]
				end
			end
	
			if vehicleIndicators[vehicle].right then
				if not customIndicatorVehicles[vehicleModel] then
					if vehicleLightStates[vehicle][1] ~= 1 then
						if vehicleIndicatorStates[vehicle] then
							setVehicleLightState(vehicle, 1, 0)
						else
							setVehicleLightState(vehicle, 1, 1)
						end
					end
		
					if vehicleLightStates[vehicle][2] ~= 1 then
						if vehicleIndicatorStates[vehicle] then
							setVehicleLightState(vehicle, 2, 0)
						else
							setVehicleLightState(vehicle, 2, 1)
						end
					end
				else
					if vehicleIndicatorStates[vehicle] then
						setVehicleComponentVisible(vehicle, "indicator_r", false)
					else
						setVehicleComponentVisible(vehicle, "indicator_r", true)
					end
				end
	
				if vehicle == getPedOccupiedVehicle(localPlayer) then
					currentIndicatorState = vehicleIndicatorStates[vehicle]
				end
			end
	
			if vehicle == getPedOccupiedVehicle(localPlayer) and vehicleIndicatorStates[vehicle] then
				playSound(":seal_vehiclepanel/files/turnsignal.mp3")
			end




			vehicleIndicatorStates[vehicle] = not vehicleIndicatorStates[vehicle]
		else
			killTimer(sourceTimer)
		end
	end

function getBoardDatas(model)
	local consumption = consumptions[model] or defaultConsumption
	return math.floor(fuelLevel - consumptionValue / 10000 * consumption * consumptionMultipler), math.floor(totalDistance + tripDistance), lastOilChange
end

function getVehicleOverrideLightsEx(vehicle)
	return getVehicleOverrideLights(vehicle)
end

function getVehicleSpeed(currentElement)
	if isElement(currentElement) then
		local x, y, z = getElementVelocity(currentElement)
	  	local speed = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
		local speed = speed * 180 * 1.1

	  	return speed
	end
	
	return 0
end
  

function round(number)
	return math.floor(number * 10 ^ 0 + 0.5) / 10 ^ 0
end

function getVehicleGear(vehicle, speed)
	local currentGear = getElementData(vehicle, "currentGear")
	if vehicle then
		return currentGear == 0 and "N" or currentGear == -1 and "R" or currentGear == 1 and "D"
	end
end


local nitroState = false
local nitroStart = 0
local nitroStop = 0
local clickTick = 0

function toggleNOS(state)
	if state ~= nitroState then
		if state then
			bindKey("lctrl", "both", startNOS)
			nitroState = true
		else
			unbindKey("lctrl", "both", startNOS)
			nitroState = false

			local pedveh = getPedOccupiedVehicle(localPlayer)

			if pedveh then
				local upgrade = getVehicleUpgradeOnSlot(pedveh, 8)

				if type(upgrade) == "number" then
					removeVehicleUpgrade(pedveh, upgrade)
				end
			end
		end
	end
end

function startNOS(button, state)
	local pedveh = getPedOccupiedVehicle(localPlayer)

	if pedveh then
		if state == "up" then
			removeVehicleUpgrade(pedveh, 1010)
			setPedControlState(localPlayer, "vehicle_fire", false)
			triggerServerEvent("updateNitroLevel", localPlayer, pedveh, getElementData(pedveh, "vehicle.dbID"), nitroLevel)
			triggerServerEvent("nitroEffect", pedveh, false)
			nosState = false
		else
			clickTick = getTickCount()

			if nitroLevel > 0 then
				triggerServerEvent("nitroEffect", pedveh, true)
				addVehicleUpgrade(pedveh, 1010)
				setPedControlState(localPlayer, "vehicle_fire", true)
				nosState = true
			end
		end
	end
end

addEventHandler("onClientVehicleStartExit", getRootElement(),
	function (player, seat, door)
		if player == localPlayer then
			if nosState then
				removeVehicleUpgrade(source, 1010)
				setPedControlState(localPlayer, "vehicle_fire", false)
				triggerServerEvent("updateNitroLevel", localPlayer, source, getElementData(source, "vehicle.dbID"), nitroLevel)
				triggerServerEvent("nitroEffect", source, false)
				nosState = false
			end
		end	
	end
)

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		local pedveh = getPedOccupiedVehicle(localPlayer)

		if pedveh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			local currentTime = getTickCount()

			if getPedControlState(localPlayer, "vehicle_fire") then
				local upgrade = getVehicleUpgradeOnSlot(pedveh, 8)

				if type(upgrade) == "number" and upgrade ~= 0 then
					if nitroLevel > 0 then
						nitroLevel = nitroLevel - timeSlice / 1000 * 3

						if nitroLevel < 0 then
							toggleNOS(false)
							startNOS("lctrl", "up")
						end
						
						if currentTime - clickTick > 20000 then
							removeVehicleUpgrade(pedveh, upgrade)
							addVehicleUpgrade(pedveh, upgrade)
							
							setPedControlState(localPlayer, "vehicle_fire", false)
							setPedControlState(localPlayer, "vehicle_fire", true)

							clickTick = currentTime
						end
					else
						nitroLevel = 0
						removeVehicleUpgrade(pedveh, 1010)
						setPedControlState(localPlayer, "vehicle_fire", false)
					end
				end
			end

		end
	end)

    function renderSpeedoForTest(vehicle, color, colorId)
        if colorId == 7 then
            speedoColor = color
        else
            speedoColor2 = color
        end
    
        selectedSpeedoColor = color
    
        render.speedo(screenX / 2 - (128), screenY - (384))
    end
    
    addEvent("resetSpeedoColor", true)
    addEventHandler("resetSpeedoColor", getRootElement(),
        function ()
            speedoColor = getElementData(source, "vehicle.speedoColor") or {255, 255, 255}
            speedoColor2 = getElementData(source, "vehicle.speedoColor2") or {255, 255, 255}
        end
    )
    



    addEvent("buySpeedoColor", true)
    addEventHandler("buySpeedoColor", getRootElement(),
        function (colorId)
            if colorId == 7 then
                setElementData(source, "vehicle.speedoColor", selectedSpeedoColor)
            else
                setElementData(source, "vehicle.speedoColor2", selectedSpeedoColor)
            end
    
            speedoColor = getElementData(source, "vehicle.speedoColor") or {255, 255, 255}
            speedoColor2 = getElementData(source, "vehicle.speedoColor2") or {255, 255, 255}
        end)

local smoothFillWidth = 0 -- Globális változó a smooth kitöltéshez

render.speedo = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["speedo"] then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["speedo"] and  smoothMove < resp(224) then
		return
	end

	if forceHideSpeedo then
		return
	end

	local pedveh = getPedOccupiedVehicle(localPlayer)

	if pedveh then
		setRadioChannel(0)
		
		local pedseat = getPedOccupiedVehicleSeat(localPlayer)

		if pedseat == 0 or pedseat == 1 then

			-- RPM LINE

			local vehicleRPM = getVehicleRPM(pedveh)
			local maxRPM = 9800
			local rpmRatio = math.min(vehicleRPM / maxRPM, 1)
			local targetFillWidth = rpmRatio * 233
			
			local function interpolateColorRPM(vehicleRPM)
				local r, g, b
				if vehicleRPM >= 4000 then
					r = 255
					g = math.floor(255 - 175 * (vehicleRPM - 4000) / (maxRPM - 4000))
					b = math.floor(255 - 175 * (vehicleRPM - 4000) / (maxRPM - 4000))
				else
					r = 255
					g = 255
					b = 255
				end
				return tocolor(r, g, b, 255)
			end
			
			local barColor = interpolateColorRPM(vehicleRPM)
			
			local step = 25
			if smoothFillWidth < targetFillWidth then
				smoothFillWidth = math.min(smoothFillWidth + step, targetFillWidth)
			elseif smoothFillWidth > targetFillWidth then
				smoothFillWidth = math.max(smoothFillWidth - step, targetFillWidth)
			end
			
			dxDrawRectangle(x, y + 190, smoothFillWidth, 4, barColor)

			-- fuel

			local fuelLevel = getElementData(pedveh, "vehicle.fuel")
			local currentFuel = fuelLevel
			
			if currentFuel <= 0 then
				currentFuel = 0
			end
			
			local fuelBarHeight = 120
			local fuelBarWidth = 7
			local fuelBarX = x
			local fuelBarY = y
			
			local fuelPercent = math.max(math.min(currentFuel / 100, 1), 0) 
			local fuelFillHeight = fuelBarHeight * fuelPercent
			local fuelText = fuelPercent * 100
			
			-- Function to interpolate color based on fuel level
			local function interpolateColorFuel(fuelPercent)
				local r, g, b
				if fuelPercent >= 0.3 then
					r = 255
					g = 255
					b = 255
				else
					r = 255
					g = math.floor(255 * fuelPercent * 2)
					b = 0
				end
				return tocolor(r, g, b, 255)
			end
			
			local fuelColor = interpolateColorFuel(fuelPercent)
			
			dxDrawRectangle(fuelBarX + 240, fuelBarY + 105 + (fuelBarHeight - fuelFillHeight), fuelBarWidth, fuelFillHeight, fuelColor)
			if eletricVehicle then
				dxDrawText(math.floor(fuelText) .. " %", fuelBarX + 205, fuelBarY + 205, fuelBarX, fuelBarY, tocolor(255, 255, 255), 1, fuelFont)
			else
				dxDrawText(math.floor(fuelText) .. " L", fuelBarX + 205, fuelBarY + 205, fuelBarX, fuelBarY, tocolor(255, 255, 255), 1, fuelFont)
			end

			-- NITRO LINE
			local function interpolateColorNitro(nitroLevel)
				local r, g, b
				if nitroLevel >= 50 then
					r = 78
					g = 111
					b = 181
				else
					r = 185
					g = math.floor(73 * (nitroLevel / 35))
					b = math.floor(73 * (nitroLevel / 35))
				end
				return tocolor(r, g, b, 255)
			end
			
			local nosLevel = (nitroLevel / 100) * 132 - 0.5
			
			if nitroLevel <= 0 then
				nosLevel = 0
			end
			
			local nosX = x
			local nosY = y
			local nosWidth = 5
			local nosHeight = 190
			
			local barColor = interpolateColorNitro(nitroLevel)
			
			if nosLevel > 0 then
				dxDrawRectangle(nosX + 253, nosY + 46 + (nosHeight - nosLevel), nosWidth, nosLevel, barColor)
			end


			-- OTHER
			local vehicleSpeed = math.floor(getVehicleSpeed(pedveh))
			local vehicleGear = getVehicleCurrentGear(pedveh)
			
			if vehicleGear == 0 and vehicleSpeed > 1 then
				vehicleGear = "R"
			elseif vehicleGear == 0 or vehicleGear == 1 and vehicleSpeed <= 1 then
				vehicleGear = "N"
			elseif vehicleGear >= 1 then
				vehicleGear = "D"
			end
			
			local r, g, b = 255, 255, 255
			local text = "KM/H"
			if tempomatSpeed then
				r, g, b = 243, 214, 90
				text = "*CC*"
			end
			
			-- Szín interpoláció sebesség alapján
			local function interpolateSpeedColor(vehicleSpeed)
				local maxSpeed = 200 -- Maximalizált sebesség, amit figyelembe veszünk az átmenethez
				local speedRatio = math.min(vehicleSpeed / maxSpeed, 1)
			
				local r, g, b
				if speedRatio >= 0.5 then
					r = 255
					g = math.floor(255 - 150 * (speedRatio - 0.5) * 2) -- Csökkentett zöld komponens
					b = math.floor(255 - 150 * (speedRatio - 0.5) * 2) -- Csökkentett kék komponens
				else
					r = 255
					g = 255
					b = 255
				end
				return r, g, b
			end
			
			local r, g, b = interpolateSpeedColor(vehicleSpeed)
			dxDrawText(getFormatSpeed(vehicleSpeed), x + 140, y + 100, x + 233, y - 12 + 233, tocolor(r, g, b), 1, speedoFont46, "center", "center")
			
			-- Tempomat szöveg (ha aktív)
			dxDrawText(text, x - 10, y + 85, x + 15 + 233, y + 25 + 233, tocolor(255, 255, 255), 1, speedoFont16, "center", "center")
			
			
			local vehicleName = exports.seal_vehiclenames:getCustomVehicleName(pedveh) or "Nincs név"
			local fasz = getElementData(pedveh, "vehicle.distance") or 0
			local km = false

			if fasz > 0 then
				km = math.floor(fasz * 10) / 10
			else
				km = 0
			end

			-- Autónév
			dxDrawText(km .. " km", x + 115, y - 115, x + 15 + 233, y + 25 + 233, tocolor(75, 75, 75, 175), 1, kmFont, "right", "center")
			dxDrawText(vehicleName, x + 115, y - 75, x + 15 + 233, y + 25 + 233, tocolor(255, 255, 255), 1, vehNameFont, "right", "center")

			-- Gear-ek sorrendben
			local gears = {"R", "N", "D"}
			local gearWidth = 20  -- Különböző gear-ek szélessége, hogy megfelelően elférjenek
			local xOffset = x + 65
			
			-- Képzeld el, hogy a "vehicleGear" aktuális értékhez tartozó gear-t kiemeljük
			for i, gear in ipairs(gears) do
				local bgColor = tocolor(74, 223, 191, 150)  -- Háttér szín
				if gear == vehicleGear then
					-- Ha a gear az aktív, akkor háttérszínt adunk hozzá
					dxDrawRectangle(xOffset + (i - 1) * gearWidth - 36.8, y + 154, gearWidth, 30, bgColor)
				end
				-- Gear-ek szövege
				dxDrawText(gear, xOffset + (i - 1) * gearWidth - 75, y + 300, xOffset + (i - 1) * gearWidth + gearWidth, y + 40, tocolor(255, 255, 255), 1, speedoFont16, "center", "center")
			end
			

			if getVehicleType(pedveh) == "Automobile" and not beltlessModels[model] then
				if not seatBeltState then
					if getTickCount() - seatBeltChange >= 750 then
						seatBeltChange = getTickCount()
						seatBeltIcon = not seatBeltIcon
					end
					
					if seatBeltIcon then
						dxDrawImage(x + 105, y + 203, 17, 24, "speedo/images/belt.png", 0, 0, 0, tocolor(243, 90, 90))
					else
						dxDrawImage(x + 105, y + 203, 17, 24, "speedo/images/belt.png", 0, 0, 0, tocolor(200, 200, 200))
					end
				else
					dxDrawImage(x + 105, y + 203, 17, 24, "speedo/images/belt.png", 0, 0, 0, tocolor(200, 200, 200))
				end
			end

			if vehicleIndicators[pedveh] and vehicleIndicators[pedveh].right then
				dxDrawImage(x + 165, y + 199, 32, 32, "speedo/images/index.png", 180, 0, 0, tocolor(74, 223, 191))
			else
				dxDrawImage(x + 165, y + 199, 32, 32, "speedo/images/index.png", 180, 0, 0, tocolor(200, 200, 200))
			end

			if vehicleIndicators[pedveh] and vehicleIndicators[pedveh].left then
				dxDrawImage(x + 130, y + 199, 32, 32, "speedo/images/index.png", 0, 0, 0, tocolor(74, 223, 191))
			else
				dxDrawImage(x + 130, y + 199, 32, 32, "speedo/images/index.png", 0, 0, 0, tocolor(200, 200, 200))
			end

			if lockState then
				dxDrawImage(x + 15, y + 203, 24, 24, "speedo/images/locked.png", 0, 0, 0, tocolor(74, 223, 191))
			else
				dxDrawImage(x + 15, y + 203, 24, 24, "speedo/images/locked.png", 0, 0, 0, tocolor(200, 200, 200))
			end

			if getElementData(pedveh, "vehicle.lights") == 0 then
				dxDrawImage(x + 75, y + 203, 24, 24, "speedo/images/light.png", 0, 0, 0, tocolor(200, 200, 200))
			else
				dxDrawImage(x + 75, y + 203, 24, 24, "speedo/images/light.png", 0, 0, 0, tocolor(74, 223, 191))
			end

			if getElementHealth(pedveh) > 640 then
				dxDrawImage(x + 45, y + 203, 24, 24, "speedo/images/engine.png", 0, 0, 0, tocolor(200, 200, 200))
			elseif getElementHealth(pedveh) >= 400 and getElementHealth(pedveh) <= 640 then
				dxDrawImage(x + 45, y + 203, 24, 24, "speedo/images/engine.png", 0, 0, 0, tocolor(255, 149, 20))
			elseif getElementHealth(pedveh) < 400 then
				dxDrawImage(x + 45, y + 203, 24, 24, "speedo/images/engine.png", 0, 0, 0, tocolor(243, 90, 90))
			end

			
			return true
		end		
	end
	return false
end
    
    render.fuel = function (x, y)
        local pedveh = getPedOccupiedVehicle(localPlayer)
        if renderData.showTrashTray and not renderData.inTrash["fuel"] then
            return
        end
        if renderData.showTrashTray and renderData.inTrash["fuel"] and  smoothMove < resp(224) then
            return
        end
    
        if pedveh then
            local pedseat = getPedOccupiedVehicleSeat(localPlayer)
    
            if pedseat == 0 or pedseat == 1 then
                local model = getElementModel(pedveh)
                local speed = getVehicleSpeed(pedveh)
    
                local r, g, b = 240, 240, 240
                local r2, g2, b2 = 0, 0, 0
                
                if speed > 280 then
                    local progress = (speed - 280) / 40
    
                    r, g, b = interpolateBetween(
                        speedoColor[1], speedoColor[2], speedoColor[3],
                        215, 89, 89,
                        progress, "Linear")
    
                    r2, g2, b2 = interpolateBetween(
                        0, 0, 0,
                        215, 89, 89,
                        progress, "Linear")
                end
    

				return true
				
            end
        end
    
        return false
    end

	function math.round(num, decimals)
		decimals = math.pow(10, decimals or 0)
		num = num * decimals
		if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
		return num / decimals
	end

--[[function updateGear()
	currentGear = 0
end

function gearFunction()
	local pedveh = getPedOccupiedVehicle(localPlayer)
	if isElement(pedveh) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		triggerServerEvent("updateGear", resourceRoot, pedveh, currentGear)
		setElementData(pedveh, "currentGear", currentGear, false)
		setControlState("handbrake", false)
	end
end

function gearUp()
	local pedveh = getPedOccupiedVehicle(localPlayer)
	if isElement(pedveh) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		iprint(getVehicleCurrentGear(pedveh))
		if currentGear + 1 == 1 and getVehicleSpeed(pedveh) > 0 and getVehicleCurrentGear(pedveh) < 1 then return end
		if currentGear + 1 <= 1 then
			currentGear = currentGear + 1
		end
		gearFunction()
	end
end
bindKey("lshift", "down", gearUp)

function gearDown()
	local pedveh = getPedOccupiedVehicle(localPlayer)
	if isElement(pedveh) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		if currentGear - 1 == -1 and getVehicleSpeed(pedveh) > 0 and getVehicleCurrentGear(pedveh) ~= 0 then return end
		if currentGear - 1 >= -1 then
			currentGear = currentGear - 1
		end
		gearFunction()
	end
end
bindKey("lctrl", "down", gearDown)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		updateGear()
	end
)

addEventHandler("onClientPedVehicleEnter", getRootElement(), updateGear)

addEventHandler("onClientPreRender", getRootElement(),
	function()
		local pedveh = getPedOccupiedVehicle(localPlayer)
		if isElement(pedveh) and getVehicleEngineState(pedveh) then
			local currentGear = getElementData(pedveh, "currentGear")
			local accelerate = getAnalogControlState("accelerate")
			local brake_reverse = getAnalogControlState("brake_reverse")
			local vehicleSpeed = getVehicleSpeed(pedveh)
			local reversing = getVehicleCurrentGear(pedveh) == 0

			if currentGear == 0 then
				if vehicleSpeed > 0 then
					if reversing then
						if brake_reverse > 0 then
							setAnalogControlState("brake_reverse", 0, true)
						end
					else
						if accelerate > 0 then
							setAnalogControlState("accelerate", 0, true)
						end
					end
				elseif vehicleSpeed == 0 then
					setAnalogControlState("accelerate", 0, true)
					setAnalogControlState("brake_reverse", 0, true)
				end
			elseif currentGear == -1 then
				setAnalogControlState("accelerate", brake_reverse, true)
				setAnalogControlState("brake_reverse", accelerate, true)

				if brake_reverse == 0 and not (accelerate > 0) then
					if vehicleSpeed < 5 then
						setAnalogControlState("brake_reverse", 0.25, true)
					end
				end
				if vehicleSpeed < 1 then
					setAnalogControlState("accelerate", 0, true)
				end 
				if not reversing and vehicleSpeed > 0 then
					setAnalogControlState("accelerate", 0, true)
				end
			elseif currentGear == 1 then
				if brake_reverse == 0 and not (accelerate > 0.1) then
					if vehicleSpeed < 5 then
						setAnalogControlState("accelerate", 0.1, true)
					end
				end
				if vehicleSpeed < 1 then
					setAnalogControlState("brake_reverse", 0, true)
				end
				if reversing and vehicleSpeed > 0 then
					setAnalogControlState("brake_reverse", 0, true)
				end
			end
		end
	end
)]]

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "vehicle" and customIndicatorVehicles[getElementModel(source)] then
		setVehicleComponentVisible(source, "indicator_l", false);setVehicleComponentVisible(source, "indicator_left", false);setVehicleComponentVisible(source, "index_l", false)
		setVehicleComponentVisible(source, "indicator_r", false);setVehicleComponentVisible(source, "indicator_right", false);setVehicleComponentVisible(source, "index_r", false)
	end
end)

function getVehicleRPM(vehicle)
    local vehicleRPM = 0
    if (vehicle) then
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then
                vehicleRPM = math.floor(((getVehicleSpeed(vehicle) / getVehicleCurrentGear(vehicle)) * 160) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(1650, 1750)
                elseif (vehicleRPM >= 9000) then
                    vehicleRPM = math.random(9000, 9900)
                end
            else
                vehicleRPM = math.floor((getVehicleSpeed(vehicle) * 160) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(1650, 1750)
                elseif (vehicleRPM >= 9000) then
                    vehicleRPM = math.random(9000, 9900)
                end
            end
        else
            vehicleRPM = 0
        end

        return vehicleRPM
    else
        return 0
    end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "00" .. unit
    elseif unit < 100 then
        unit = "0" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end