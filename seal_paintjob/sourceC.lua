local modelTextures = {
	[598] = "remap",
	[596] = "remap",
}

local availableTextures = {

	
	[1] = "bmw_f11/pd.dds",
	[2] = "bmw_f11/nav.dds",
	[3] = "bmw_f11/omsz.dds",

}

local paintjobs = {
	["remap"] = {
		[596] = {1, 2, 3},
		[598] = {1, 2, 3},
	
	},

}

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
	end)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			applyTexture(source)
		end
	end)

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
	function (dataName, _, newValue)
		if dataName == "vehicle.tuning.Paintjob" and newValue ~= -1 then
			applyTexture(source)
		end
	end)

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

addCommandHandler("apaintjob",
	function (commandName, paintjobId)
		if getElementData(localPlayer, "acc.adminLevel") >= 6 then
			paintjobId = tonumber(paintjobId)

			if not paintjobId then
				outputChatBox("#4adfbf[Használat]:#ffffff /" .. commandName .. " [ID]", 255, 255, 255, true)
			else
				local pedveh = getPedOccupiedVehicle(localPlayer)

				if pedveh then
					local model = getElementModel(pedveh)
					if getElementData(pedveh, "vehicle.customId") and getElementData(pedveh, "vehicle.customId") ~= "0" then
						model = getElementData(pedveh, "vehicle.customId")
					end

					if isTextureIdValid(model, paintjobId) or paintjobId == 0 then
						setElementData(pedveh, "vehicle.tuning.Paintjob", paintjobId)
						triggerServerEvent("logAdminPaintjob", localPlayer, getElementData(pedveh, "vehicle.dbID") or 0, commandName, paintjobId)
					else
						outputChatBox("#d75959[SealMTA]: #ffffffEz a paintjob nem kompatibilis ezzel a kocsival!", 255, 255, 255, true)
					end
				else
					outputChatBox("#d75959[SealMTA]: #ffffffElőbb ülj be egy kocsiba!", 255, 255, 255, true)
				end
			end
		end
	end)

local waitingTextures = 0
function applyTexture(vehicle)
	local paintjobId = getElementData(vehicle, "vehicle.tuning.Paintjob") or 0

	if paintjobId then
		if paintjobId == 0 or paintjobId == -1 then
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

			local modelTexture = modelTextures[model]

			if modelTexture then
				local paintjob = paintjobs[modelTexture]

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

			local modelTexture = modelTextures[model]

			if modelTexture then
				local paintjob = paintjobs[modelTexture]

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

function isTextureIdValid(model, textureId)
	local modelTexture = modelTextures[model]

	if modelTexture then
		local paintjob = paintjobs[modelTexture]

		if paintjob then
			if paintjob[model] then
				if paintjob[model][textureId] then
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

function applyPaintJob(paintjobId, sync)
	local pedveh = getPedOccupiedVehicle(localPlayer)

	paintjobId = tonumber(paintjobId)

	if paintjobId then
		if isElement(pedveh) then
			local model = getElementModel(pedveh)
			if getElementData(pedveh, "vehicle.customId") and getElementData(pedveh, "vehicle.customId") ~= "0" then
				model = getElementData(pedveh, "vehicle.customId")
			end

			if isTextureIdValid(model, paintjobId) or paintjobId == 0 then
				setElementData(pedveh, "vehicle.tuning.Paintjob", paintjobId, sync)
			end
		end
	end
end

function getPaintJobCount(model)
	model = tonumber(model)
	if model < 400 or model > 611 then
		model = exports.seal_mods_veh:getCustomIdByModel(model)
	end

	local modelTexture = modelTextures[model]
	local paintjob = paintjobs[modelTexture]

	if model == 467 then
		return #paintjob[model] - 2
	end

	if model == 500 or model == 438 then
		return #paintjob[model] - 1
	end

	if model == 596 or model == 598 or model == 490 then
		return #paintjob[model] - 5
	end

	if model and modelTexture and paintjob and paintjob[model] then
		return #paintjob[model]
	end

	return false
end