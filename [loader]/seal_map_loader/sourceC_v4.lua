local seexports = {
    seal_mall = false,
    seal_gui = false,
}

local function seelangProcessExports()
    for k in pairs(seexports) do
        local res = getResourceFromName(k)
        if res and getResourceState(res) == "running" then
            seexports[k] = exports[k]
        else
            seexports[k] = false
        end
    end
end

seelangProcessExports()

if triggerServerEvent then
    addEventHandler("onClientResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end

if triggerClientEvent then
    addEventHandler("onResourceStart", getRootElement(), seelangProcessExports, true, "high+9999999999")
end

local BebasNeueFont = false
local BebasNeueScale = false
local BebasNeueHeight = false
local primary = false

local function seelangGuiRefreshColors()
    local res = getResourceFromName("seal_gui")
    if res and getResourceState(res) == "running" then
        BebasNeueFont = seexports.seal_gui:getFont("14/BebasNeueRegular.otf")
        BebasNeueScale = seexports.seal_gui:getFontScale("14/BebasNeueRegular.otf")
        BebasNeueHeight = seexports.seal_gui:getFontHeight("14/BebasNeueRegular.otf")
        primary = seexports.seal_gui:getColorCodeToColor("primary")
    end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)

local mapLoadingHandeld = false

function handleMapLoading(state)
    if state ~= mapLoadingHandeld then
        mapLoadingHandeld = state

        if mapLoadingHandeld then
            addEventHandler("onClientPreRender", getRootElement(), preRenderMapLoading, true)
        else
            removeEventHandler("onClientPreRender", getRootElement(), preRenderMapLoading)
        end
    end
end

local mapList = {}
local canLoadMaps = false
local mapLoadingStarted = false
local customModelCache = {}
local loadedMaps = 0
local mapStorage = {}

function startMapLoading()
    if mapLoadingStarted then
        return
    end
    
    mapLoadingStarted = true
    triggerServerEvent("mapLoader:requestInitialMapList", localPlayer)
end

function processMapData(mapName, mapData, defaultDimension)
    if mapStorage[mapName] and mapStorage[mapName].objects then
        for _, object in ipairs(mapStorage[mapName].objects) do
            if isElement(object) then
                destroyElement(object)
            end
        end
        mapStorage[mapName].objects = {}

        for _, lod in ipairs(mapStorage[mapName].lods) do
            if isElement(lod) then
                destroyElement(lod)
            end
        end
        mapStorage[mapName].lods = {}

        for _, removeData in ipairs(mapStorage[mapName].removes) do
            restoreWorldModel(table.unpack(removeData))
        end
        mapStorage[mapName].removes = {}
    end

    if mapData then
        if not mapStorage[mapName] then
            mapStorage[mapName] = {objects = {}, lods = {}, removes = {}}
        end

        for _, elementData in ipairs(mapData) do
            if elementData.type == "object" and (not elementData.server or elementData.server == "lv") then
                local model = tonumber(elementData.model) or seexports.seal_mall:getModelId(elementData.model)
                local posX, posY, posZ = tonumber(elementData.posX), tonumber(elementData.posY), tonumber(elementData.posZ)
                local rotX, rotY, rotZ = tonumber(elementData.rotX), tonumber(elementData.rotY), tonumber(elementData.rotZ)
                
                if model and posX and posY and posZ and rotX and rotY and rotZ then
                    if not tonumber(elementData.model) then
                        customModelCache[model] = elementData.model
                    end

                    local object = createObject(model, posX, posY, posZ, rotX, rotY, rotZ)
                    
                    if elementData.alpha then
                        setElementAlpha(object, tonumber(elementData.alpha))
                    end
                    if elementData.scale then
                        setObjectScale(object, tonumber(elementData.scale))
                    elseif elementData.scaleX and elementData.scaleY and elementData.scaleZ then
                        setObjectScale(object, tonumber(elementData.scaleX), tonumber(elementData.scaleY), tonumber(elementData.scaleZ))
                    end
                    if elementData.doublesided == "true" then
                        setElementDoubleSided(object, true)
                    end
                    if elementData.breakable == "false" then
                        setObjectBreakable(object, false)
                    end
                    if elementData.collisions == "false" then
                        setElementCollisionsEnabled(object, false)
                    end
                    if elementData.frozen == "true" then
                        setElementFrozen(object, true)
                    end
                    if elementData.interior then
                        setElementInterior(object, tonumber(elementData.interior))
                    end
                    local dimension = defaultDimension or tonumber(elementData.dimension)
                    setElementDimension(object, dimension and dimension > 0 and dimension or -1)

                    table.insert(mapStorage[mapName].objects, object)

                    local lodModel = elementData.LOD or (elementData.longstream == "true" and model)
                    if lodModel then
                        lodModel = tonumber(lodModel) or seexports.seal_mall:getModelId(lodModel)
                        if lodModel then
                            local lod = createObject(lodModel, posX, posY, posZ, rotX, rotY, rotZ, true)
                            if elementData.scale then
                                setObjectScale(lod, tonumber(elementData.scale))
                            elseif elementData.scaleX and elementData.scaleY and elementData.scaleZ then
                                setObjectScale(lod, tonumber(elementData.scaleX), tonumber(elementData.scaleY), tonumber(elementData.scaleZ))
                            end
                            if elementData.interior then
                                setElementInterior(lod, tonumber(elementData.interior))
                            end
                            setElementDimension(lod, dimension and dimension > 0 and dimension or -1)
                            
                            if elementData.worldModelLOD == "true" then
                                setElementAlpha(object, 0)
                                setElementCollisionsEnabled(object, false)
                            end

                            setLowLODElement(object, lod)
                            table.insert(mapStorage[mapName].lods, lod)
                        end
                    end
                end
            elseif elementData.type == "removeWorldObject" then
                local model = tonumber(elementData.model)
                local lodModel = tonumber(elementData.lodModel)
                local radius = tonumber(elementData.radius)
                local posX, posY, posZ = tonumber(elementData.posX), tonumber(elementData.posY), tonumber(elementData.posZ)
                local interior = tonumber(elementData.interior) or 0

                if model and radius and posX and posY and posZ then
                    removeWorldModel(model, radius, posX, posY, posZ, interior)
                    table.insert(mapStorage[mapName].removes, {model, radius, posX, posY, posZ, interior})
                    if lodModel and lodModel > 0 then
                        removeWorldModel(lodModel, radius, posX, posY, posZ, interior)
                        table.insert(mapStorage[mapName].removes, {lodModel, radius, posX, posY, posZ, interior})
                    end
                end
            end
        end
    else
        mapStorage[mapName] = nil
    end
end

addEvent("mapLoader:gotMapData", true)
addEventHandler("mapLoader:gotMapData", getRootElement(), function(mapName, mapObjects)
    for i = #mapList, 1, -1 do
        if mapList[i] == mapName then
            table.remove(mapList, i)
        end
    end

    processMapData(mapName, mapObjects)
    canLoadMaps = false
end)

addEvent("mapLoader:refreshMapList", true)
addEventHandler("mapLoader:refreshMapList", getRootElement(), function(map)
    if type(map) == "table" then
        loadedMaps = loadedMaps + #map
        for i = 1, #map, 1 do
            table.insert(mapList, map[i])
        end
    else
        loadedMaps = loadedMaps + 1
        table.insert(mapList, map)
    end

    handleMapLoading(true)
end)

function preRenderMapLoading()
    if not canLoadMaps then
        for i = 1, #mapList, 1 do
            if mapList[i] then
                triggerServerEvent("mapLoader:requestMapData", localPlayer, mapList[i])
                canLoadMaps = true
                break
            end
        end

        if #mapList <= 0 then
            handleMapLoading(false)
        end
    end
end

local screenX, screenY = guiGetScreenSize()
local nearbyMapsState = false

function renderNearbyMaps()
  dxDrawText("Nearby maps on", 1, screenY - 256 + 1, screenX + 1, screenY + 1, tocolor(0, 0, 0), BebasNeueScale * 1.5, BebasNeueFont, "center", "center")
  dxDrawText("Nearby maps on", 0, screenY - 256, screenX, screenY, primary, BebasNeueScale * 1.5, BebasNeueFont, "center", "center")

  for map in pairs(mapStorage) do
        for i = 1, #mapStorage[map].objects, 1 do
            local object = mapStorage[map].objects[i]

            if isElement(object) and isElementStreamedIn(object) and isElementOnScreen(object) then
                local ox, oy, oz = getElementPosition(object)
                local x, y = getScreenFromWorldPosition(ox, oy, oz, 128)

                if x then
                    local model = getElementModel(object)

                    dxDrawText(customModelCache[model] or model, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0), BebasNeueScale, BebasNeueFont, "center", "center")
                    dxDrawText(customModelCache[model] or model, x, y, x, y, primary, BebasNeueScale, BebasNeueFont, "center", "center")

                    y = y + BebasNeueHeight

                    dxDrawText(map, x + 1, y + 1, x + 1, y + 1, tocolor(0, 0, 0), BebasNeueScale, BebasNeueFont, "center", "center")
                    dxDrawText(map, x, y, x, y, tocolor(255, 255, 255), BebasNeueScale, BebasNeueFont, "center", "center")
                end
            end
        end
    end
end

addCommandHandler("nearbymaps", function()
    if getElementData(localPlayer, "acc.adminLevel") >= 7 then
        nearbyMapsState = not nearbyMapsState

        if nearbyMapsState then
            outputChatBox("[color=primary][SealMTA - Maps]: #ffffffNearby maps: [color=blue]be", 255, 255, 255, true)
            addEventHandler("onClientRender", getRootElement(), renderNearbyMaps)
        else
            outputChatBox("[color=primary][SealMTA - Maps]: #ffffffNearby maps: [color=blue]ki", 255, 255, 255, true)
            removeEventHandler("onClientRender", getRootElement(), renderNearbyMaps)
        end
    end
end)

addCommandHandler("nearbyobjects", function()
    if getElementData(localPlayer, "acc.adminLevel") >= 7 then
        local objects = #getElementsByType("object", getRootElement(), true)
        local color = "primary"

        if objects > 500 then
            color = "red"
        elseif objects > 400 then
            color = "orange"
        elseif objects > 300 then
            color = "yellow"
        end

        outputChatBox("[color=primary][SealMTA - Maps]: #ffffffObjectek száma: [color=" .. color .. "]" .. objects, 255, 255, 255, true)
    end
end)

addCommandHandler("melyikmap", function()
    if getElementData(localPlayer, "acc.adminLevel") >= 7 then
        local object = getPedContactElement(localPlayer)
        
        for map in pairs(mapStorage) do
            for i = 1, #mapStorage[map].objects, 1 do
                if mapStorage[map].objects[i] == object then
                    outputChatBox("[color=primary][SealMTA - Maps]: #ffffffObject id: [color=blue]" .. getElementModel(object), 255, 255, 255, true)
                    outputChatBox("[color=primary][SealMTA - Maps]: #ffffffMap név: [color=blue]" .. map, 255, 255, 255, true)
                end
            end
        end
    end
end)

local markedObjects = {}

addCommandHandler("markobjects", function(commandName, objectId)
    if getElementData(localPlayer, "acc.adminLevel") >= 7 then
        objectId = tonumber(objectId)

        if not objectId then
            for i = 1, #markedObjects, 1 do
                if isElement(markedObjects[i]) then
                    destroyElement(markedObjects[i])
                end

                markedObjects[i] = nil
            end

            markedObjects = {}
            outputChatBox("[color=primary][SealMTA]: #ffffffMegjelölések eltávolítva.", 255, 255, 255, true)
            return
        end

        for map in pairs(mapStorage) do
            for i = 1, #mapStorage[map].objects, 1 do
                local object = mapStorage[map].objects[i]
                if getElementModel(object) == objectId then
                    local x, y, z = getElementPosition(object)
                    local blip = createBlip(x, y, z)
                    table.insert(markedObjects, blip)
                end
            end
        end

        outputChatBox("[color=primary][SealMTA]: #ffffff" .. #markedObjects .. " db object megjelölve.", 255, 255, 255, true)
    end
end)

addEventHandler("onClientResourceStart", getRootElement(), function(startedResource)
    if startedResource == getThisResource() then
        local resource = getResourceFromName("seal_mall")

        if getResourceState(resource) == "running" then
            setOcclusionsEnabled(false)
            startMapLoading()
        end
    end
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName, oldValue, newValue)
    if source == localPlayer then
        if dataName == "loggedIn" and newValue then
            setOcclusionsEnabled(false)

            setTimer(function()
                startMapLoading()
            end, 5000, 1)
        end
    end
end)