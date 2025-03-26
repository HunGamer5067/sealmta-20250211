local mapSet = {}
local mapList = {}
local mapDataCache = {}
local mapRequestTime = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		local directoryStack = {"maps"}

		while #directoryStack > 0 do
			local currentPath = table.remove(directoryStack)
			
			for itemIndex, itemName in ipairs(pathListDir(currentPath)) do
				local itemPath = currentPath .. "/" .. itemName
	
				if pathIsFile(itemPath) then
					mapSet[itemPath] = true
					table.insert(mapList, itemPath)
				elseif pathIsDirectory(itemPath) then
					table.insert(directoryStack, itemPath)
				end
			end
		end

		local modelID = 18233  -- Az objektum modell ID-ja, amit törölni szeretnél
		local radius = 25     -- Az a sugár, amelyen belül az objektumot törölni szeretnéd
		local x, y, z = -2062.587890625, -2467.041015625, 30.656608581543  -- Az objektum koordinátái

		removeWorldModel(modelID, radius, x, y, z)

		scheduleCacheClear()
	end
)

addEventHandler("onPlayerResourceStart", root,
	function (startedResource)
		if startedResource == resource then
			triggerClientEvent(source, "gotMapList", source, mapList)
		end
	end
)

addEvent("requestMapData", true)
addEventHandler("requestMapData", root,
	function (mapPath)
		if client then
			if not mapSet[mapPath] then
				return
			end

			mapRequestTime[mapPath] = getTickCount()

			if not mapDataCache[mapPath] then
				mapDataCache[mapPath] = readMap(mapPath)
			end

			triggerClientEvent(client, "gotMapData", client, mapPath, mapDataCache[mapPath])
		end
	end
)

function readMap(mapFile)
	local mapFile = xmlLoadFile(mapFile, true)

	if mapFile then
		local mapData = {}

		for nodeIndex, nodeElement in ipairs(xmlNodeGetChildren(mapFile)) do
			local nodeAttributes = xmlNodeGetAttributes(nodeElement)

			nodeAttributes.id = nil
			nodeAttributes.type = xmlNodeGetName(nodeElement)

			mapData[nodeIndex] = nodeAttributes
		end

		xmlUnloadFile(mapFile)

		return mapData
	end

	return nil
end

function scheduleCacheClear()
	setTimer(
		function ()
			local currentTime = getTickCount()

			for mapPath, requestTime in pairs(mapRequestTime) do
				if currentTime - requestTime > 60000 then
					mapDataCache[mapPath] = nil
					mapRequestTime[mapPath] = nil
				end
			end

			collectgarbage()
		end,
	60000, 0)
end

addCommandHandler("loadmap",
	function (sourcePlayer, commandName, mapPath)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			mapPath = "maps/server/" .. tostring(mapPath) .. ".map"

			if not pathIsFile(mapPath) then
				exports.seal_gui:showInfobox(sourcePlayer, "e", "Nem létező map fájl!")
			else
				exports.seal_gui:showInfobox(sourcePlayer, "s", "A kiválaszott map betöltése folyamatban!")
				
				if not mapSet[mapPath] then
					mapSet[mapPath] = true
					table.insert(mapList, mapPath)
				end

				mapDataCache[mapPath] = readMap(mapPath)
				mapRequestTime[mapPath] = getTickCount()

				triggerClientEvent("gotMapData", resourceRoot, mapPath, mapDataCache[mapPath])
			end
		end
	end
)

addCommandHandler("unloadmap",
	function (sourcePlayer, commandName, mapPath)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			mapPath = "maps/server/" .. tostring(mapPath) .. ".map"

			if not mapSet[mapPath] then
				exports.seal_gui:showInfobox(sourcePlayer, "e", "A kiválaszott map nincs betöltve!")
			else
				exports.seal_gui:showInfobox(sourcePlayer, "s", "A kiválaszott map leállításra került.")

				mapSet[mapPath] = nil
				mapDataCache[mapPath] = nil
				mapRequestTime[mapPath] = nil

				for i = #mapList, 1, -1 do
					if mapList[i] == mapPath then
						table.remove(mapList, i)
						break
					end
				end

				triggerClientEvent("gotMapData", resourceRoot, mapPath, nil)
			end
		end
	end
)

addCommandHandler("reloadmap",
	function (sourcePlayer, commandName, mapPath)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			mapPath = "maps/server/" .. tostring(mapPath) .. ".map"

			if not mapSet[mapPath] then
				exports.seal_gui:showInfobox(sourcePlayer, "e", "A kiválaszott map nincs betöltve!")
			else
				exports.seal_gui:showInfobox(sourcePlayer, "s", "A kiválaszott map újratöltésre került.")

				mapDataCache[mapPath] = readMap(mapPath)
				mapRequestTime[mapPath] = getTickCount()

				triggerClientEvent("gotMapData", resourceRoot, mapPath, mapDataCache[mapPath])
			end
		end
	end
)

addCommandHandler("reloadallmaps",
	function (sourcePlayer, commandName, mapPath)
		if getElementData(sourcePlayer, "acc.adminLevel") >= 8 then
			exports.seal_gui:showInfobox(sourcePlayer, "s", "A mappolások újratöltése elindítva.")

			for i = 1, #mapList do
				local mapPath = mapList[i]

				mapDataCache[mapPath] = readMap(mapPath)
				mapRequestTime[mapPath] = getTickCount()

				triggerLatentClientEvent("gotMapData", resourceRoot, mapPath, mapDataCache[mapPath])
			end
		end
	end
)