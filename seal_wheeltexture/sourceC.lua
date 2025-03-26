local modelTextureNames = {
	[526] = "S15_Ratas",
	[562] = "disk",
	[565] = "wheel",
	[540] = "wheel",
	[445] = "nodamage",
	["bmw_5_e60"] = "nodamage",
	[466] = "c63_wheel",
	[405] = "a8wheel",
	[502] = "*nosegrillm4_wheel*",
	[467] = "*nosegrillm4_wheel*",
	["ronalt"] = "v4_tuningwheel_ronalt1",
	["drag"] = "v4_tuningwheel_tire(r)"
}

local availableTextures = {
	[1] = "textures/nissan/1.png",
	[2] = "defaults/ronalt/1.png",
	[3] = "defaults/ronalt/2.png",
	[4] = "defaults/ronalt/3.png",
	[5] = "defaults/ronalt/4.png",
	[6] = "defaults/ronalt/5.png",
	[7] = "defaults/drag/1.png",
	[8] = "defaults/drag/2.png",
	[9] = "defaults/drag/3.png",
	[10] = "defaults/ronalt/6.png",
	[11] = "defaults/ronalt/7.png",
	[12] = "defaults/ronalt/8.png",
	[13] = "defaults/ronalt/9.png",
	[14] = "defaults/ronalt/10.png",
	[15] = "textures/nissan/2.png",
	[16] = "textures/nissan/3.png",
	[17] = "textures/nissanskyline/1.png",
	[18] = "textures/nissanskyline/2.png",
	[19] = "textures/nissanskyline/3.png",
	[20] = "textures/subaru/1.png",
	[21] = "textures/subaru/2.png",
	[22] = "textures/subaru/3.png",
	[23] = "textures/wrx/1.png",
	[24] = "textures/e60/1.png",
	[25] = "textures/e60/2.png",
	[26] = "textures/c63/wheelc63.png",
	[27] = "textures/a8/a8w.png",
	[28] = "textures/e60/3.png",
	
	[29] = "textures/m4/1.png",
	[30] = "textures/m4/2.png",
	[31] = "textures/m4/3.png",
	[32] = "textures/m4/4.png",
	[33] = "textures/m4/5.png",
}

local availablePaintjobs = {
	disk = {
		[562] = {17, 18, 19},
	},
	["c63_wheel"] = {
		[466] = {26},
	},
	["*nosegrillm4_wheel*"] = {
		[502] = {29, 30, 31, 32, 33},
		[467] = {29, 30, 31, 32, 33},
	},
	["a8wheel"] = {
		[405] = {27},
	},
	["wheel"] = {
		[565] = {20, 21, 22},
		[540] = {23}
	},
	["nodamage"] = {
		[445] = {24, 25, 28},
		["bmw_5_e60"] = {24, 25, 28},
	},
	["S15_Ratas"] = {
		[526] = {1, 15, 16}
	},
	["v4_tuningwheel_ronalt1"] = {
		2, 3, 4, 5, 6, 10, 11, 12, 13, 14
	},
	["v4_tuningwheel_tire(r)"] = {
		7, 8, 9
	}
}

local availableWheelPaintjobs = {
	[1075] = "ronalt",
	[1078] = "drag"
}

local createdTextures = {}
local createdShaders = {}

local textures = {}
local shaders = {}
local createdTextures = {}
for k in pairs(availableTextures) do
	createdTextures[k] = 0
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in pairs(getElementsByType("vehicle"), getRootElement(), true) do
			applyTexture(v)
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			applyTexture(source)
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(),
	function ()
		for k, v in pairs(shaders) do
			if isElement(v) then
				destroyElement(v)
			end
		end

		for k, v in pairs(textures) do
			destroyElement(v)
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if dataName == "vehicle.tuning.WheelPaintjob" then
			applyTexture(source)
		end
	end
)
addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if shaders[source] then
			if isElement(shaders[source]) then
				destroyElement(shaders[source])
			end

			if isElement(textures[sorurce]) then
				destroyElement(textures[source])
				print("Destroy textures")
			end


			shaders[source] = nil
			destroyTexture(source)
		end
	end)

addEventHandler("onClientElementStreamOut", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			if shaders[source] then
				if isElement(shaders[source]) then
					destroyElement(shaders[source])
				end

				shaders[source] = nil
				destroyTexture(source)
			end
		end
	end 
)
addCommandHandler("awheeltext",
	function (commandName, paintjobId)
		if getElementData(localPlayer, "acc.adminLevel") >= 7 then
			paintjobId = tonumber(paintjobId)

			if not paintjobId then
				outputChatBox("#7cc576[Használat]:#ffffff /" .. commandName .. " [ID]", 255, 255, 255, true)
			else
				local currentVeh = getPedOccupiedVehicle(localPlayer)

				if currentVeh then
					if isTextureIdValid(currentVeh, paintjobId) or paintjobId == 0 then
						setElementData(currentVeh, "vehicle.tuning.WheelPaintjob", paintjobId)
						triggerServerEvent("logAdminPaintjob", localPlayer, getElementData(currentVeh, "vehicle.dbID") or 0, commandName, paintjobId)
					else
						outputChatBox("#d75959[SeeMTA]: #ffffffEz a kerék nem kompatibilis ezzel a kocsival!", 255, 255, 255, true)
					end
				else
					outputChatBox("#d75959[SeeMTA]: #ffffffElőbb ülj be egy kocsiba!", 255, 255, 255, true)
				end
			end
		end
	end
)

local waitingTextures = 0
function applyTexture(vehicle)
	local paintjobId = getElementData(vehicle, "vehicle.tuning.WheelPaintjob") or 0

	if paintjobId then
		if paintjobId == 0 then
			if isElement(shaders[vehicle]) then
				destroyElement(shaders[vehicle])
			end

			shaders[vehicle] = nil
		elseif paintjobId > 0 then
			local model = getElementModel(vehicle)
			if getElementData(vehicle, "vehicle.customId") and getElementData(vehicle, "vehicle.customId") ~= "0" then
				model = getElementData(vehicle, "vehicle.customId")
			end

			if not isElement(shaders[vehicle]) then
				shaders[vehicle] = dxCreateShader("texturechanger.fx")
			end

			local modelTexture = modelTextureNames[model]

			if modelTexture then
				local paintjob = availablePaintjobs[modelTexture]

				if paintjob and paintjob[model] then
					local textureId = paintjob[model][paintjobId]

					if textureId and shaders[vehicle] then
						setTimer(
							function(textureId, shaders, vehicle, modelTexture)
								if isElementStreamedIn(vehicle) then
									if not isElement(textures[textureId]) then
										textures[textureId] = dxCreateTexture("textures/" .. availableTextures[textureId], "dxt1")
										createdTextures[textureId] = createdTextures[textureId] + 1
									end	
									if textures[textureId] then
										dxSetShaderValue(shaders[vehicle], "gTexture", textures[textureId])
										engineApplyShaderToWorldTexture(shaders[vehicle], modelTexture, vehicle)
									end
								end
								waitingTextures = waitingTextures - 1
							end, waitingTextures * 500, 1, textureId, shaders, vehicle, modelTexture
						)
						waitingTextures = waitingTextures + 1
					end
				end
			end
		end
	end
end



function destroyTexture(vehicle)
	local paintjobId = getElementData(vehicle, "vehicle.tuning.Paintjob") or 0

	if paintjobId then
		if paintjobId == 0 then
			if isElement(shaders[vehicle]) then
				destroyElement(shaders[vehicle])
			end

			shaders[vehicle] = nil
		elseif paintjobId > 0 then
			local model = getElementModel(vehicle)
			if getElementData(vehicle, "vehicle.customId") and getElementData(vehicle, "vehicle.customId") ~= "0" then
				model = getElementData(vehicle, "vehicle.customId")
			end

			local modelTexture = modelTextureNames[model]

			if modelTexture then
				local paintjob = availablePaintjobs[modelTexture]

				if paintjob and paintjob[model] then
					local textureId = paintjob[model][paintjobId]

					if textureId and shaders[vehicle] then
						createdTextures[textureId] = createdTextures[textureId] - 1
						if createdTextures[textureId] < 1 then
							if isElement(textures[textureId]) then
								setTimer(
									function(textureId, vehicle)
										if createdTextures[textureId] < 1 and isElement(vehicle) then
											if isElement(textures[textureId]) then
												destroyElement(textures[textureId])
											end
											if isElement(shaders[vehicle]) then
												destroyElement(shaders[vehicle])
											end
										end
										waitingTextures = waitingTextures - 1
									end, waitingTextures * 500, 1, textureId, vehicle
								)
								waitingTextures = waitingTextures + 1
							end
							createdTextures[textureId] = 0
						end
					end
				end
			end
		end
	end
end

function isTextureIdValid(vehicle, textureId)
	local wheelUpgrade = getVehicleUpgradeOnSlot(vehicle, 12)

	if wheelUpgrade > 0 then
		local wheelTexture = availableWheelPaintjobs[wheelUpgrade]

		if wheelTexture then
			local modelTexture = modelTextureNames[wheelTexture]

			if availablePaintjobs[modelTexture] then
				if availablePaintjobs[modelTexture][wheelTexture] then
					if availablePaintjobs[modelTexture][wheelTexture][textureId] then
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	else
		local model = getElementModel(vehicle)
		if getElementData(vehicle, "vehicle.customId") and getElementData(vehicle, "vehicle.customId") ~= "0" then
			model = getElementData(vehicle, "vehicle.customId")
		end
		local modelTexture = modelTextureNames[model]

		if modelTexture then
			local selectedPaintjob = availablePaintjobs[modelTexture]

			if selectedPaintjob then
				if selectedPaintjob[model] then
					if selectedPaintjob[model][textureId] then
						return true
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end
end

function applyWheelTexture(paintjobId, sync)
	paintjobId = tonumber(paintjobId)

	if paintjobId then
		local currentVeh = getPedOccupiedVehicle(localPlayer)

		if isElement(currentVeh) then
			if isTextureIdValid(currentVeh, paintjobId) or paintjobId == 0 then
				setElementData(currentVeh, "vehicle.tuning.WheelPaintjob", paintjobId, sync)
			end
		end
	end
end

function getWheelTextureCount(vehicle)
	local wheelUpgrade = getVehicleUpgradeOnSlot(vehicle, 12)

	if wheelUpgrade > 0 then
		local wheelTexture = availableWheelPaintjobs[wheelUpgrade]

		if wheelTexture then
			local modelTexture = modelTextureNames[wheelTexture]
			return #availablePaintjobs[modelTexture]
		else
			return false
		end
	else
		local model = getElementModel(vehicle)
		if getElementData(vehicle, "vehicle.customId") and getElementData(vehicle, "vehicle.customId") ~= "0" then
			model = getElementData(vehicle, "vehicle.customId")
		end
		local modelTexture = modelTextureNames[model]
		local selectedPaintjob = availablePaintjobs[modelTexture]

		if modelTexture then
			if selectedPaintjob then
				if selectedPaintjob[model] then
					return #selectedPaintjob[model]
				end
			end
		end
	end

	return false
end
