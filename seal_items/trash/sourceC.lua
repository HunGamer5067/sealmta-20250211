addEventHandler("onClientResourceStart", root,
    function (startedResource)
        local resourceThis = getThisResource()
        local resourceName = getResourceName(startedResource)

        local startedResourceThis = startedResource == resourceThis
        local startedResourceModels = resourceName == "seal_loader_encrypted"

        if startedResourceThis or startedResourceModels then
            requestNewTrashContainer()
        end
    end
)

addEventHandler("onClientElementDataChange", localPlayer,
    function (dataName, oldValue, newValue)
        if dataName == "loggedIn" then
            if newValue then
                requestNewTrashContainer()
            end
        end
    end
)

local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), lamartTrashPreRender, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), lamartTrashPreRender)
    end
  end
end
storedTrashes = {}
local insectTrashes = {
  [1329] = true,
  [1330] = true
}
local trashEffects = {}
local objects = getElementsByType("object", getRootElement(), true)
for i = 1, #objects do
  local model = getElementModel(objects[i])
  if insectTrashes[model] then
    local x, y, z = getElementPosition(objects[i])
    trashEffects[objects[i]] = createEffect("insects", x, y, z + 1)
    setEffectDensity(trashEffects[objects[i]], 2)
    setElementInterior(trashEffects[objects[i]], getElementInterior(objects[i]))
    setElementDimension(trashEffects[objects[i]], getElementDimension(objects[i]))
    if getElementDimension(objects[i]) ~= -1 then
      setElementInterior(trashEffects[objects[i]], getElementInterior(objects[i]))
      setElementDimension(trashEffects[objects[i]], getElementDimension(objects[i]))
    else
      setElementInterior(trashEffects[objects[i]], getElementInterior(localPlayer))
      setElementDimension(trashEffects[objects[i]], getElementDimension(localPlayer))
    end
  end
end
addEventHandler("onClientObjectStreamIn", getRootElement(), function()
  if insectTrashes[getElementModel(source)] then
    local x, y, z = getElementPosition(source)
    trashEffects[source] = createEffect("insects", x, y, z + 1)
    setEffectDensity(trashEffects[source], 2)
    if getElementDimension(source) ~= -1 then
      setElementInterior(trashEffects[source], getElementInterior(source))
      setElementDimension(trashEffects[source], getElementDimension(source))
    else
      setElementInterior(trashEffects[source], getElementInterior(localPlayer))
      setElementDimension(trashEffects[source], getElementDimension(localPlayer))
    end
  end
end)
local streamedInLamart = {}
local lamartData = {}
local lamartSound = {}
function destroyedInsectObject()
  streamedInLamart[source] = nil
  if isElement(trashEffects[source]) then
    destroyElement(trashEffects[source])
  end
  trashEffects[source] = nil
  if isElement(lamartSound[source]) then
    destroyElement(lamartSound[source])
  end
  lamartSound[source] = nil
end
addEventHandler("onClientObjectStreamOut", getRootElement(), destroyedInsectObject)
addEventHandler("onClientObjectDestroy", getRootElement(), destroyedInsectObject)
function destroyLamart()
  if lamartData[source] then
    if isElement(lamartData[source][1]) then
      destroyElement(lamartData[source][1])
    end
    lamartData[source][1] = nil
    if isElement(lamartData[source][2]) then
      destroyElement(lamartData[source][2])
    end
    lamartData[source][2] = nil
  end
  lamartData[source] = nil
end
local lidModel = false
local loadTrashes = getElementData(localPlayer, "loggedIn")
addEvent("extraLoadStart:loadingTrashes", false)
addEventHandler("extraLoadStart:loadingTrashes", getRootElement(), function()
  if lidModel then
    triggerLatentServerEvent("requestTrashes", localPlayer)
  else
    loadTrashes = true
  end
end)

function requestNewTrashContainer()
    lidModel = 16442

    if lidModel then
        triggerServerEvent("requestNewTrashes", localPlayer)
    end
end

function lamartTrashPreRender(delta)
    local canEnd = true

    for obj, dat in pairs(lamartData) do
        local els = getElementsWithinColShape(dat[2], "player")
        local state = 1 <= #els

        if state ~= dat[5] then
            local x, y, z = getElementPosition(obj)
            local int = getElementInterior(obj)
            local dim = getElementDimension(obj)

            if isElement(lamartSound[obj]) then
                destroyElement(lamartSound[obj])
            end

            lamartSound[obj] = nil
            lamartSound[obj] = playSound3D("files/lamart.mp3", x, y, z)

            setElementInterior(lamartSound[obj], int)
            setElementDimension(lamartSound[obj], dim)

            if state then
                setSoundPosition(lamartSound[obj], dat[3] * 0.75)
            else
                setSoundPosition(lamartSound[obj], (1 - dat[3]) * 0.75)
            end

            dat[5] = state

            if isElement(trashEffects[obj]) then
                destroyElement(trashEffects[obj])
            end

            trashEffects[obj] = nil

            if state then
                trashEffects[obj] = createEffect("insects", x, y, z + 1)
                setEffectDensity(trashEffects[obj], 2)
                setElementInterior(trashEffects[obj], int)
                setElementDimension(trashEffects[obj], dim)
            end
        end

        if state then
            dat[3] = dat[3] + 1 * delta / 750
            
            if 1 < dat[3] then
              dat[3] = 1
            end
        else
          dat[3] = dat[3] - 1 * delta / 750
          if dat[3] < 0 then
            dat[3] = 0
          end
        end

        local p = dat[3]

        if 0 < p and p < 1 then
          p = getEasingValue(p, "InOutQuad")
        end

        if dat[1] then
          setElementRotation(dat[1], -p * 80, 0, dat[4] + 180)
        else
          print("dat[1] geci")
        end

        canEnd = false
    end
    
    if canEnd then
        seelangCondHandl0(false)
    end
end

function lamartTrashStreamIn()
  streamedInLamart[source] = true
  seelangCondHandl0(true)
end

addEvent("recieveNewTrashes", true)
addEventHandler("recieveNewTrashes", getRootElement(), function(trashData)
    if trashData and type(trashData) == "table" then
        storedTrashes = trashData

        for id, dat in pairs(trashData) do
            if dat.lamart then
                addEventHandler("onClientElementDestroy", dat.objectElement, destroyLamart)
                addEventHandler("onClientElementStreamIn", dat.objectElement, lamartTrashStreamIn)

                if isElementStreamedIn(dat.objectElement) then
                    streamedInLamart[dat.objectElement] = true
                    seelangCondHandl0(true)
                end

                local rad = math.rad(dat.rotZ)
                local cos = math.cos(rad)
                local sin = math.sin(rad)

                local x = dat.posX + 0.1527 * sin
                local y = dat.posY - 0.1527 * cos
                local z = dat.posZ + 1.0504

                local lid = createObject(lidModel, x, y, z, 0, 0, dat.rotZ + 180)

                setElementInterior(lid, dat.interior)
                setElementDimension(lid, dat.dimension)

                if not lamartData[dat.objectElement] then
                    local col = createColSphere(x, y, z, 2)
                    lamartData[dat.objectElement] = {lid, col, 0, dat.rotZ, false}

                    setElementInterior(col, dat.interior)
                    setElementDimension(col, dat.dimension)
                end
            end
        end
    end

    setTimer(triggerEvent, 250, 1, "extraLoaderDone", localPlayer, "loadingTrashes")
end)

addEvent("createTrash", true)
addEventHandler("createTrash", getRootElement(), function(databaseId, trashData)
  if databaseId then
    databaseId = tonumber(databaseId)
    if trashData and type(trashData) == "table" then
      storedTrashes[databaseId] = trashData
      if trashData.lamart then
        addEventHandler("onClientElementDestroy", trashData.objectElement, destroyLamart)
        addEventHandler("onClientElementStreamIn", trashData.objectElement, lamartTrashStreamIn)
        if isElementStreamedIn(trashData.objectElement) then
          streamedInLamart[trashData.objectElement] = true
          seelangCondHandl0(true)
        end
        local rad = math.rad(trashData.rotZ)
        local cos = math.cos(rad)
        local sin = math.sin(rad)
        local x = trashData.posX + 0.1527 * sin
        local y = trashData.posY - 0.1527 * cos
        local z = trashData.posZ + 1.0504
        local lid = createObject(lidModel, x, y, z, 0, 0, trashData.rotZ + 180)
        setElementInterior(lid, trashData.interior)
        setElementDimension(lid, trashData.dimension)
        local col = createColSphere(x, y, z, 1.5)
        lamartData[trashData.objectElement] = {
          lid,
          col,
          0,
          trashData.rotZ,
          false
        }
        setElementInterior(col, trashData.interior)
        setElementDimension(col, trashData.dimension)
      end
    end
  end
end)

addEvent("destroyTrash", true)
addEventHandler("destroyTrash", getRootElement(), function(databaseId)
  if databaseId then
    databaseId = tonumber(databaseId)
    if storedTrashes[databaseId] then
      storedTrashes[databaseId] = nil
    end
  end
end)