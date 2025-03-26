local seexports = {seal_mall = false}
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
local seelangModloaderLoaded = function()
  modloaderLoaded()
end
addEventHandler("modloaderLoaded", getRootElement(), seelangModloaderLoaded)
if getElementData(localPlayer, "loggedIn") or seexports.seal_mall and seexports.seal_mall:isModloaderLoaded() then
  addEventHandler("onClientResourceStart", getResourceRootElement(), seelangModloaderLoaded)
end
local screenX, screenY = guiGetScreenSize()
function processBarrierPositions(poses, objs, p)
  local x, y, z, r = poses[1], poses[2], poses[3], poses[4]
  local rad = math.rad(r)
  if 0 < p then
    local r2 = -90 + 90 * p
    local rad2 = math.rad(r2)
    local d = math.sin(rad2) * 3.2
    x, y = x + math.cos(rad) * d, y + math.sin(rad) * d
    z = z + math.cos(rad2) * 3.2
    setElementRotation(objs[1], 0, r2, r)
  else
    local r2 = -90
    local rad2 = math.rad(r2)
    local d = math.sin(rad2) * 3.2
    x, y = x + math.cos(rad) * d, y + math.sin(rad) * d
    setElementRotation(objs[1], 0, -90, r)
  end
  setElementPosition(objs[2], x, y, z)
end
function modloaderLoaded()
  for i = 1, #parkingGarages do
    parkingGarages[i].enterBarrierObjects = {}
    parkingGarages[i].enterBarrierOpen = {}
    parkingGarages[i].enterBarrierProgress = {}
    parkingGarages[i].exitBarrierObjects = {}
    parkingGarages[i].exitBarrierOpen = {}
    parkingGarages[i].exitBarrierProgress = {}
    for j = 1, #parkingGarages[i].enterBarriers do
      local obj0 = createObject(seexports.seal_mall:getModelId("barrier_gate1"), parkingGarages[i].enterBarriers[j][1], parkingGarages[i].enterBarriers[j][2], parkingGarages[i].enterBarriers[j][3], 0, 0, parkingGarages[i].enterBarriers[j][4])
      local obj1 = createObject(seexports.seal_mall:getModelId("barrier_gate2"), parkingGarages[i].enterBarriers[j][1], parkingGarages[i].enterBarriers[j][2], parkingGarages[i].enterBarriers[j][3], 0, -90, parkingGarages[i].enterBarriers[j][4])
      local obj2 = createObject(seexports.seal_mall:getModelId("barrier_gate3"), parkingGarages[i].enterBarriers[j][1], parkingGarages[i].enterBarriers[j][2], parkingGarages[i].enterBarriers[j][3], 0, -90, parkingGarages[i].enterBarriers[j][4])
      setElementDimension(obj0, -1)
      setElementDimension(obj1, -1)
      setElementDimension(obj2, -1)
      parkingGarages[i].enterBarrierObjects[j] = {obj1, obj2}
      parkingGarages[i].enterBarrierOpen[j] = false
      parkingGarages[i].enterBarrierProgress[j] = 0
      processBarrierPositions(parkingGarages[i].enterBarriers[j], parkingGarages[i].enterBarrierObjects[j], 0)
    end
    for j = 1, #parkingGarages[i].exitBarriers do
      local obj0 = createObject(seexports.seal_mall:getModelId("barrier_gate1"), parkingGarages[i].exitBarriers[j][1], parkingGarages[i].exitBarriers[j][2], parkingGarages[i].exitBarriers[j][3], 0, 0, parkingGarages[i].exitBarriers[j][4])
      local obj1 = createObject(seexports.seal_mall:getModelId("barrier_gate2"), parkingGarages[i].exitBarriers[j][1], parkingGarages[i].exitBarriers[j][2], parkingGarages[i].exitBarriers[j][3], 0, -90, parkingGarages[i].exitBarriers[j][4])
      local obj2 = createObject(seexports.seal_mall:getModelId("barrier_gate3"), parkingGarages[i].exitBarriers[j][1], parkingGarages[i].exitBarriers[j][2], parkingGarages[i].exitBarriers[j][3], 0, -90, parkingGarages[i].exitBarriers[j][4])
      setElementDimension(obj0, -1)
      setElementDimension(obj1, -1)
      setElementDimension(obj2, -1)
      parkingGarages[i].exitBarrierObjects[j] = {obj1, obj2}
      parkingGarages[i].exitBarrierOpen[j] = false
      parkingGarages[i].exitBarrierProgress[j] = 0
      processBarrierPositions(parkingGarages[i].exitBarriers[j], parkingGarages[i].exitBarrierObjects[j], 0)
    end
  end
end
local barrierProgressHandled = false
function preRenderBarriers(delta)
  local ended = true
  for i = 1, #parkingGarages do
    for j = 1, #parkingGarages[i].enterBarriers do
      if parkingGarages[i].enterBarrierOpen[j] then
        ended = false
        if 1 > parkingGarages[i].enterBarrierProgress[j] then
          parkingGarages[i].enterBarrierProgress[j] = math.min(1, parkingGarages[i].enterBarrierProgress[j] + delta / 2000)
          processBarrierPositions(parkingGarages[i].enterBarriers[j], parkingGarages[i].enterBarrierObjects[j], getEasingValue(parkingGarages[i].enterBarrierProgress[j], "InOutQuad"))
        end
      elseif parkingGarages[i].enterBarrierProgress[j] > 0 then
        ended = false
        parkingGarages[i].enterBarrierProgress[j] = math.max(0, parkingGarages[i].enterBarrierProgress[j] - delta / 2000)
        processBarrierPositions(parkingGarages[i].enterBarriers[j], parkingGarages[i].enterBarrierObjects[j], getEasingValue(parkingGarages[i].enterBarrierProgress[j], "InOutQuad"))
      end
    end
    for j = 1, #parkingGarages[i].exitBarriers do
      if parkingGarages[i].exitBarrierOpen[j] then
        ended = false
        if 1 > parkingGarages[i].exitBarrierProgress[j] then
          parkingGarages[i].exitBarrierProgress[j] = math.min(1, parkingGarages[i].exitBarrierProgress[j] + delta / 2000)
          processBarrierPositions(parkingGarages[i].exitBarriers[j], parkingGarages[i].exitBarrierObjects[j], getEasingValue(parkingGarages[i].exitBarrierProgress[j], "InOutQuad"))
        end
      elseif 0 < parkingGarages[i].exitBarrierProgress[j] then
        ended = false
        parkingGarages[i].exitBarrierProgress[j] = math.max(0, parkingGarages[i].exitBarrierProgress[j] - delta / 2000)
        processBarrierPositions(parkingGarages[i].exitBarriers[j], parkingGarages[i].exitBarrierObjects[j], getEasingValue(parkingGarages[i].exitBarrierProgress[j], "InOutQuad"))
      end
    end
  end
  if ended then
    barrierProgressHandled = false
    removeEventHandler("onClientPreRender", getRootElement(), preRenderBarriers)
  end
end
addEvent("changeParkingEnterGateState", true)
addEventHandler("changeParkingEnterGateState", getRootElement(), function(i, j, dat)
  if parkingGarages[i].enterBarrierOpen then
    parkingGarages[i].enterBarrierOpen[j] = dat
    if dat and not barrierProgressHandled then
      barrierProgressHandled = true
      addEventHandler("onClientPreRender", getRootElement(), preRenderBarriers)
    end
  end
end)
addEvent("changeParkingExitGateState", true)
addEventHandler("changeParkingExitGateState", getRootElement(), function(i, j, dat)
  if parkingGarages[i] and parkingGarages[i].exitBarrierOpen then
    parkingGarages[i].exitBarrierOpen[j] = dat
    if dat and not barrierProgressHandled then
      barrierProgressHandled = true
      addEventHandler("onClientPreRender", getRootElement(), preRenderBarriers)
    end
  end
end)