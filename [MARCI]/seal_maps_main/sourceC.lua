local screenWidth, screenHeight = guiGetScreenSize()

local loadingMapNum = 0
local loadingMapList = {}

local mapLoadingProcess = false
local mapLoadingWaiting = false
local mapLoadingProgress = 0
local mapLoadingFinished = false
local mapLoadingInterpolation = 0
local mapLoadingInterpolationStart = false

local loadedMapData = {}
local customObjectModels = {}

addEventHandler("onClientResourceStop", resourceRoot,
	function ()
		for mapFile in pairs(loadedMapData) do
			unloadMapData(mapFile)
		end
	end
)

addEvent("gotMapList", true)
addEventHandler("gotMapList", localPlayer,
	function (mapList)
		loadingMapNum = loadingMapNum + #mapList

		for i = 1, #mapList do
			table.insert(loadingMapList, mapList[i])
		end

		if not mapLoadingProcess then
			addEventHandler("onClientPreRender", root, processMapLoading)
			mapLoadingProcess = true
		end

		mapLoadingFinished = false
	end
)

addEvent("gotMapData", true)
addEventHandler("gotMapData", root,
	function (mapFile, mapData)
		if mapLoadingWaiting == mapFile then
			mapLoadingWaiting = false
		end

		for i = #loadingMapList, 1, -1 do
			if loadingMapList[i] == mapFile then
				table.remove(loadingMapList, i)
			end
		end

		processMapData(mapFile, mapData)
	end
)

addEventHandler("onClientObjectDamage", resourceRoot,
	function ()
		cancelEvent()
	end
)

addEventHandler("onModloaderLoaded", localPlayer,
	function ()
		refreshModels()
	end
)

function processMapLoading(deltaTime)
	local screenWidth, screenHeight = guiGetScreenSize()

	if not mapLoadingWaiting then
		local nextMap = loadingMapList[1]

		if nextMap then
			triggerServerEvent("requestMapData", localPlayer, nextMap)
			mapLoadingWaiting = nextMap
		elseif not mapLoadingFinished then
			mapLoadingFinished = 2000
		end
	end

	if mapLoadingFinished then
		mapLoadingFinished = mapLoadingFinished - deltaTime

		if mapLoadingFinished <= 0 then
			mapLoadingFinished = 0
			removeEventHandler("onClientPreRender", root, processMapLoading)
			mapLoadingProcess = false
			return
		end
	end

	local fadeOutProgress = 0

	if mapLoadingInterpolationStart then
		local elapsedTime = (getTickCount() - mapLoadingInterpolationStart) / 1000

		while true do
			if elapsedTime < 1 then
				mapLoadingInterpolation = math.min(mapLoadingProgress, mapLoadingInterpolation + (mapLoadingProgress - mapLoadingInterpolation) * elapsedTime)
				break
			end

			if mapLoadingInterpolation >= 1 then
				fadeOutProgress = math.min(1, (elapsedTime - 1) / 0.25)
				break
			end

			break
		end
	else
		mapLoadingInterpolation = 0
	end

	dxDrawRectangle(0, screenHeight - 3, screenWidth * mapLoadingInterpolation, 3, tocolor(124, 197, 118, (1 - fadeOutProgress) * 255))
end

function processMapData(mapFile, rawData)
	local mapDataWas = loadedMapData[mapFile]

	if mapDataWas then
		unloadMapData(mapFile)
	end

	if rawData then
		local mapData = loadedMapData[mapFile] or {
			objectList = {},
			lowLodList = {},
			removeList = {},
		}

		for i = 1, #rawData do
			local v = rawData[i]

			if v.type == "removeWorldObject" then
				local sphereRadius = tonumber(v.radius)

				local centerX = tonumber(v.posX)
				local centerY = tonumber(v.posY)
				local centerZ = tonumber(v.posZ)

				local modelId = tonumber(v.model)
				local lodModelId = tonumber(v.lodModel)
				local interiorId = tonumber(v.interior) or 0
				
				if modelId and sphereRadius and centerX and centerY and centerZ then
					removeWorldModelEx(mapData, modelId, sphereRadius, centerX, centerY, centerZ, interiorId)
	
					if lodModelId and lodModelId > 0 then
						removeWorldModelEx(mapData, lodModelId, sphereRadius, centerX, centerY, centerZ, interiorId)
					end
				end
			elseif v.type == "object" then
				local modelId = tonumber(v.model) or exports.seal_mall:getModelId(v.model)

				local posX = tonumber(v.posX)
				local posY = tonumber(v.posY)
				local posZ = tonumber(v.posZ)

				local rotX = tonumber(v.rotX)
				local rotY = tonumber(v.rotY)
				local rotZ = tonumber(v.rotZ)

				if modelId and posX and posY and posZ and rotX and rotY and rotZ then
					local objectElement = createObject(modelId, posX, posY, posZ, rotX, rotY, rotZ)

					if isElement(objectElement) then
						local interiorId = tonumber(v.interior)
						local dimensionId = tonumber(v.dimension)

						if interiorId then
							setElementInterior(objectElement, interiorId)
						end

						if dimensionId and dimensionId > 0 then
							setElementDimension(objectElement, dimensionId)
						else
							setElementDimension(objectElement, -1)
						end

						local alphaValue = tonumber(v.alpha)
						local scaleValue = {tonumber(v.scale)}

						if alphaValue then
							setElementAlpha(objectElement, math.min(255, math.max(0, alphaValue)))
						end

						if scaleValue[1] then
							setObjectScale(objectElement, scaleValue[1])
						else
							scaleValue[1] = tonumber(v.scaleX)
							scaleValue[2] = tonumber(v.scaleY)
							scaleValue[3] = tonumber(v.scaleZ)

							if scaleValue[1] and scaleValue[2] and scaleValue[3] then
								setObjectScale(objectElement, unpack(scaleValue))
							end
						end

						if v.doublesided == "true" then
							setElementDoubleSided(objectElement, true)
						end

						if v.breakable == "false" then
							setObjectBreakable(objectElement, false)
						end

						if v.collisions == "false" then
							setElementCollisionsEnabled(objectElement, false)
						end

						if v.frozen == "true" then
							setElementFrozen(objectElement, true)
						end

						if not tonumber(v.model) then
							customObjectModels[objectElement] = v.model
						end

						local lodModelId = v.longstream == "true" and v.model or v.LOD

						if lodModelId then
							lodModelId = tonumber(lodModelId) or exports.seal_mall:getModelId(lodModelId)

							if lodModelId then
								local lowLodObject = createObject(lodModelId, posX, posY, posZ, rotX, rotY, rotZ, true)

								if isElement(lowLodObject) then
									if scaleValue[1] and scaleValue[2] and scaleValue[3] then
										setObjectScale(lowLodObject, unpack(scaleValue))
									elseif scaleValue[1] then
										setObjectScale(lowLodObject, scaleValue[1])
									end

									if interiorId then
										setElementInterior(lowLodObject, interiorId)
									end

									if dimensionId and dimensionId > 0 then
										setElementDimension(lowLodObject, dimensionId)
									else
										setElementDimension(lowLodObject, -1)
									end

									if v.worldModelLOD == "true" then
										setElementAlpha(objectElement, 0)
										setElementCollisionsEnabled(objectElement, false)
									end

									if not tonumber(lodModelId) then
										customObjectModels[lowLodObject] = lodModelId
									end

									setLowLODElement(objectElement, lowLodObject)
								end

								table.insert(mapData.lowLodList, lowLodObject)
							end
						end

						table.insert(mapData.objectList, objectElement)
					end
				end
			end
		end

		loadedMapData[mapFile] = mapData
	else
		loadedMapData[mapFile] = nil
	end

	mapLoadingProgress = (loadingMapNum - #loadingMapList) / loadingMapNum
	mapLoadingInterpolationStart = getTickCount()
end

function unloadMapData(mapFile)
	local mapData = loadedMapData[mapFile]

	if mapData then
		for i = 1, #mapData.objectList do
			local objectElement = mapData.objectList[i]

			if isElement(objectElement) then
				customObjectModels[objectElement] = nil
				destroyElement(objectElement)
			end

			mapData.objectList[i] = nil
		end

		for i = 1, #mapData.lowLodList do
			local lowLodElement = mapData.lowLodList[i]

			if isElement(lowLodElement) then
				customObjectModels[lowLodElement] = nil
				destroyElement(lowLodElement)
			end

			mapData.lowLodList[i] = nil
		end

		for i = 1, #mapData.removeList do
			restoreWorldModel(unpack(mapData.removeList[i]))
			mapData.removeList[i] = nil
		end
	end

	loadedMapData[mapFile] = nil
end

function removeWorldModelEx(mapData, ...)
	removeWorldModel(...)
	table.insert(mapData.removeList, {...})
end

function refreshModels()
	for mapFile, mapData in pairs(loadedMapData) do
		for i = 1, #mapData.objectList do
			local objectElement = mapData.objectList[i]

			if isElement(objectElement) then
				local objectModel = customObjectModels[objectElement]

				if objectModel then
					setElementModel(objectElement, exports.seal_mall:getModelId(objectModel))
				end
			end
		end

		for i = 1, #mapData.lowLodList do
			local lowLodElement = mapData.lowLodList[i]

			if isElement(lowLodElement) then
				local lowLodModel = customObjectModels[lowLodElement]

				if lowLodModel then
					setElementModel(lowLodElement, exports.seal_mall:getModelId(lowLodModel))
				end
			end
		end
	end
end
