local steelexports = {
    seal_models = false
}

local function steelangProcessExports()
    for k in pairs(steelexports) do
        local res = getResourceFromName(k)
        if res and getResourceState(res) == "running" then
            steelexports[k] = exports[k]
        else
            steelexports[k] = false
        end
    end
end

steelangProcessExports()

if triggerServerEvent then
    addEventHandler("onClientResourceStart", getRootElement(), steelangProcessExports, true, "high+9999999999")
end

if triggerClientEvent then
    addEventHandler("onResourceStart", getRootElement(), steelangProcessExports, true, "high+9999999999")
end

local mapObjects = {}

local function removeMapObjects()
    for mapName in pairs(mapObjects) do
        local objects = mapObjects[mapName]

        for i = 1, #objects do
            local object = objects[i]

            if isElement(object) then
                destroyElement(object)
            end
        end
    end
end

addEvent("gotMapObjects", true)
addEventHandler("gotMapObjects", resourceRoot, function(mapName, objects)
    objects = fromJSON(objects)
    if not objects then
        objects = {}
    end
    for i = 1, #objects do
        local objectDetails = objects[i]

        if objectDetails then
            local px, py, pz = unpack(objectDetails.position)
            local rx, ry, rz = unpack(objectDetails.rotation)

            if (px and py and pz and rx and ry and rz) then
                local modelId = objectDetails.modelName

                if modelId then
                    --modelId = steelexports.seal_models:getModelId(objectDetails.modelName) or exports.seal_modloader:getModelId(objectDetails.modelName) or objectDetails.modelId
                else
                    modelId = objectDetails.modelId
                end
            
                local lod = objectDetails.lod

                if lod then
                    lod = true
                end
                if not modelId then
                    iprint(objectDetails.modelName)
                end
                local object = createObject(modelId, px, py, pz, rx, ry, rz, lod)

                if isElement(object) then
                    setObjectScale(object, objectDetails.scale)

                    setElementInterior(object, objectDetails.interior)
                    setElementDimension(object, objectDetails.dimension)

                    if objectDetails.doubleSided then
                        setElementDoubleSided(object, objectDetails.doubleSided)
                    end

                    if objectDetails.invisible then
                        setElementAlpha(object, 0)
                    end

                    if objectDetails.collisionsDisabled then
                        setElementCollisionsEnabled(object, false)
                    end

                    if not mapObjects[mapName] then
                        mapObjects[mapName] = {}
                    end

                    mapObjects[mapName][i] = object

                    if objectDetails.lod and objectDetails.lod == "previous" then
                        local previousObject = mapObjects[mapName][i - 1]

                        if isElement(previousObject) then
                            setLowLODElement(previousObject, object)
                        end
                    end
                end
            end
        end
    end

    objects = nil
    collectgarbage("collect")
end)

addEvent("extraLoadStart:loadingMaps", false)
addEventHandler("extraLoadStart:loadingMaps", getRootElement(), function()
    removeMapObjects()
    triggerServerEvent("requestMaps", resourceRoot)
    triggerEvent("extraLoaderDone", localPlayer, "loadingMaps")
end)

addEventHandler("modloaderLoaded", getRootElement(), function()
    if getElementData(localPlayer, "loggedIn") then
        removeMapObjects()
        triggerServerEvent("requestMaps", resourceRoot)
    end
end)

addEventHandler("onClientResourceStart", getResourceRootElement(), function()
    for k, v in pairs(removeWorldModels) do
        removeWorldModel(unpack(v))
    end

    triggerServerEvent("requestMaps", resourceRoot)
end)

addEventHandler("onClientResourceStop", getRootElement(), function(res)
    if getResourceName(res) == "seal_models" then
        removeMapObjects()
    end
end)