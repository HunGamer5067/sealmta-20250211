local seexports = {seal_gui = false, seal_markers = false}
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
local seelangWaiterState0 = false
local function seelangProcessResWaiters()
  if not seelangWaiterState0 then
    local res0 = getResourceFromName("seal_markers")
    if res0 and getResourceState(res0) == "running" then
      markersLoaded()
      seelangWaiterState0 = true
    end
  end
end
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), seelangProcessResWaiters)
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), seelangProcessResWaiters)
end
screenX, screenY = guiGetScreenSize()
function hue2rgb(m1, m2, h)
  if h < 0 then
    h = h + 1
  elseif 1 < h then
    h = h - 1
  end
  if 1 > h * 6 then
    return m1 + (m2 - m1) * h * 6
  elseif 1 > h * 2 then
    return m2
  elseif 2 > h * 3 then
    return m1 + (m2 - m1) * (0.6666666666666666 - h) * 6
  else
    return m1
  end
end
function convertHSLToRGB(h, s, l)
  local m2
  if l < 0.5 then
    m2 = l * (s + 1)
  else
    m2 = l + s - l * s
  end
  local m1 = l * 2 - m2
  local r = hue2rgb(m1, m2, h + 0.3333333333333333) * 255
  local g = hue2rgb(m1, m2, h) * 255
  local b = hue2rgb(m1, m2, h - 0.3333333333333333) * 255
  return math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5)
end
function convertRGBToHSL(r, g, b)
  r = r / 255
  g = g / 255
  b = b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s
  local l = (max + min) / 2
  if max == min then
    h = 0
    s = 0
  else
    local d = max - min
    s = 0.5 < l and d / (2 - max - min) or d / (max + min)
    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    end
    if max == g then
      h = (b - r) / d + 2
    end
    if max == b then
      h = (r - g) / d + 4
    end
    h = h / 6
  end
  return h, s, l
end
function rgbToHex(nR, nG, nB)
  local sColor = "#"
  nR = string.format("%X", nR)
  sColor = sColor .. (string.len(nR) == 1 and "0" .. nR or nR)
  nG = string.format("%X", nG)
  sColor = sColor .. (string.len(nG) == 1 and "0" .. nG or nG)
  nB = string.format("%X", nB)
  sColor = sColor .. (string.len(nB) == 1 and "0" .. nB or nB)
  return sColor
end
function getPartColor(hp)
  local green = seexports.seal_gui:getColorCode("green")
  local red = seexports.seal_gui:getColorCode("red")
  local orange = seexports.seal_gui:getColorCode("orange")
  hp = math.abs(hp)
  local q = 50
  if hp < q then
    return red[1] + (orange[1] - red[1]) * (hp / q), red[2] + (orange[2] - red[2]) * (hp / q), red[3] + (orange[3] - red[3]) * (hp / q)
  elseif hp < 100 then
    return orange[1] + (green[1] - orange[1]) * ((hp - q) / q), orange[2] + (green[2] - orange[2]) * ((hp - q) / q), orange[3] + (green[3] - orange[3]) * ((hp - q) / q)
  elseif hp < 0 then
    return unpack(red)
  else
    return unpack(green)
  end
end
local markers = {}
function markersLoaded()
  for i = 1, #bikePositions do
    local marker = seexports.seal_markers:createCustomMarker(bikePositions[i][1], bikePositions[i][2], bikePositions[i][3], 0, 0, "blue", "car")
    seexports.seal_markers:setCustomMarkerInterior(marker, "bikefix", i, 2)
    table.insert(markers, marker)
  end
  for i = 1, #heliPositions do
    local marker = seexports.seal_markers:createCustomMarker(heliPositions[i][1], heliPositions[i][2], heliPositions[i][3], 0, 0, "blue", "helicopter")
    seexports.seal_markers:setCustomMarkerInterior(marker, "helifix", i, 6)
    table.insert(markers, marker)
  end
  for i = 1, #boatPositions do
    local marker = seexports.seal_markers:createCustomMarker(boatPositions[i][1], boatPositions[i][2], boatPositions[i][3], 0, 0, "orange", "boat")
    seexports.seal_markers:setCustomMarkerInterior(marker, "helifix", i + #heliPositions, 6)
    table.insert(markers, marker)
  end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for i = 1, #markers do
    seexports.seal_markers:deleteCustomMarker(markers[i])
  end
end)
inBikeMarker = false
inHeliMarker = false
addEvent("changeEnteredCustomMarker", false)
addEventHandler("changeEnteredCustomMarker", getRootElement(), function(theType, id)
  if theType == "bikefix" then
    inBikeMarker = true
    inHeliMarker = false
    bikeList = false
    if not isPedInVehicle(localPlayer) then
      triggerServerEvent("requestInServiceBikeList", localPlayer)
    end
    deleteHeliWindow()
    createBikeWindow()
  elseif theType == "helifix" then
    inBikeMarker = false
    inHeliMarker = true
    deleteBikeWindow()
    gotHeliProtect = false
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      createHeliWindow()
    end
  else
    inBikeMarker = false
    inHeliMarker = false
    if heliWindow then
      deleteHeliWindow()
    end
    if bikeWindow then
      deleteBikeWindow()
    end
  end
end)
