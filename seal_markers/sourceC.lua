local seexports = {seal_gui = false}
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
local seelangStatImgHand = false
local seelangStaticImage = {}
local seelangStaticImageToc = {}
local seelangStaticImageUsed = {}
local seelangStaticImageDel = {}
local processSeelangStaticImage = {}
seelangStaticImageToc[0] = true
local seelangStatImgPre
function seelangStatImgPre()
  local now = getTickCount()
  if seelangStaticImageUsed[0] then
    seelangStaticImageUsed[0] = false
    seelangStaticImageDel[0] = false
  elseif seelangStaticImage[0] then
    if seelangStaticImageDel[0] then
      if now >= seelangStaticImageDel[0] then
        if isElement(seelangStaticImage[0]) then
          destroyElement(seelangStaticImage[0])
        end
        seelangStaticImage[0] = nil
        seelangStaticImageDel[0] = false
        seelangStaticImageToc[0] = true
        return
      end
    else
      seelangStaticImageDel[0] = now + 5000
    end
  else
    seelangStaticImageToc[0] = true
  end
  if seelangStaticImageToc[0] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/charset.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangDynImgHand = false
local seelangDynImgLatCr = falselocal
seelangDynImage = {}
local seelangDynImageForm = {}
local seelangDynImageMip = {}
local seelangDynImageUsed = {}
local seelangDynImageDel = {}
local seelangDynImgPre
function seelangDynImgPre()
  local now = getTickCount()
  seelangDynImgLatCr = true
  local rem = true
  for k in pairs(seelangDynImage) do
    rem = false
    if seelangDynImageDel[k] then
      if now >= seelangDynImageDel[k] then
        if isElement(seelangDynImage[k]) then
          destroyElement(seelangDynImage[k])
        end
        seelangDynImage[k] = nil
        seelangDynImageForm[k] = nil
        seelangDynImageMip[k] = nil
        seelangDynImageDel[k] = nil
        break
      end
    elseif not seelangDynImageUsed[k] then
      seelangDynImageDel[k] = now + 5000
    end
  end
  for k in pairs(seelangDynImageUsed) do
    if not seelangDynImage[k] and seelangDynImgLatCr then
      seelangDynImgLatCr = false
      seelangDynImage[k] = dxCreateTexture(k, seelangDynImageForm[k], seelangDynImageMip[k])
    end
    seelangDynImageUsed[k] = nil
    seelangDynImageDel[k] = nil
    rem = false
  end
  if rem then
    removeEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre)
    seelangDynImgHand = false
  end
end
local seelangBlankTex = dxCreateTexture(1, 1)
local function latentDynamicImage(img, form, mip)
  if not seelangDynImgHand then
    seelangDynImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
  end
  seelangDynImageForm[img] = form
  seelangDynImageMip[img] = mip
  seelangDynImageUsed[img] = true
  return seelangDynImage[img] or seelangBlankTex
end
local seelangGuiRefreshColors = function()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    refershColorCache()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
local markerTypes = {
  arrow = {
    "files/arrow.dds",
    0.3125,
    0.25
  },
  arrow_sm = {
    "files/arrow.dds",
    0.15625,
    0.125
  },
  arrow2 = {
    "files/arrow2.dds",
    0.3125,
    0.5
  },
  duty = {
    "files/duty.dds",
    0.3125,
    0.5,
    true
  },
  house = {
    "files/house.dds",
    0.3125,
    0.5,
    true
  },
  house_sale = {
    "files/house_sale.dds",
    0.3125,
    0.5,
    true
  },
  house_group = {
    "files/house_group.dds",
    0.3125,
    0.5,
    true
  },
  barn = {
    "files/barn.dds",
    0.3125,
    0.5,
    true
  },
  barn_rent = {
    "files/barn_rent.dds",
    0.3125,
    0.5,
    true
  },
  business = {
    "files/business.dds",
    0.3125,
    0.5,
    true
  },
  business_sale = {
    "files/business_sale.dds",
    0.3125,
    0.5,
    true
  },
  business_group = {
    "files/business_group.dds",
    0.3125,
    0.5,
    true
  },
  garage = {
    "files/garage.dds",
    0.3125,
    0.5,
    true
  },
  garage_sale = {
    "files/garage_sale.dds",
    0.3125,
    0.5,
    true
  },
  garage_group = {
    "files/garage_group.dds",
    0.3125,
    0.5,
    true
  },
  garage_rent = {
    "files/garage_rent.dds",
    0.3125,
    0.5,
    true
  },
  garage_paint = {
    "files/garage_paint.dds",
    0.3125,
    0.5,
    true
  },
  garage_paint_rent = {
    "files/garage_paint_rent.dds",
    0.3125,
    0.5,
    true
  },
  lift = {
    "files/lift.dds",
    0.3125,
    0.5,
    true
  },
  lift_sale = {
    "files/lift_sale.dds",
    0.3125,
    0.5,
    true
  },
  lift_group = {
    "files/lift_group.dds",
    0.3125,
    0.5,
    true
  },
  stairs = {
    "files/stairs.dds",
    0.3125,
    0.5,
    true
  },
  stairs_sale = {
    "files/stairs_sale.dds",
    0.3125,
    0.5,
    true
  },
  stairs_group = {
    "files/stairs_group.dds",
    0.3125,
    0.5,
    true
  },
  door = {
    "files/door.dds",
    0.3125,
    0.5,
    true
  },
  door_sale = {
    "files/door_sale.dds",
    0.3125,
    0.5,
    true
  },
  door_group = {
    "files/door_group.dds",
    0.3125,
    0.5,
    true
  },
  building = {
    "files/building.dds",
    0.3125,
    0.5,
    true
  },
  rentable_forrent = {
    "files/rentable_forrent.dds",
    0.3125,
    0.5,
    true
  },
  seedyno = {
    "files/seedyno.dds",
    0.3125,
    0.5
  },
  tuning = {
    "files/tuning.dds",
    0.3125,
    0.5
  },
  yunk = {
    "files/yunk.dds",
    0.3125,
    0.5
  },
  car = {
    "files/car.dds",
    0.3125,
    0.5
  },
  carsale = {
    "files/carsale.dds",
    0.3125,
    0.5
  },
  helisale = {
    "files/helisale.dds",
    0.3125,
    0.5
  },
  boatsale = {
    "files/boatsale.dds",
    0.3125,
    0.5
  },
  bike = {
    "files/bike.dds",
    0.3125,
    0.5
  },
  helicopter = {
    "files/helicopter.dds",
    0.3125,
    0.5
  },
  boat = {
    "files/boat.dds",
    0.3125,
    0.5
  },
  armor = {
    "files/armor.dds",
    0.3125,
    0.5
  },
  cloth = {
    "files/cloth.dds",
    0.3125,
    0.5
  },
  cloth2 = {
    "files/cloth2.dds",
    0.3125,
    0.5
  },
  police = {
    "files/police.dds",
    0.3125,
    0.5
  },
  cctv = {
    "files/cctv.dds",
    0.3125,
    0.5
  },
  mdc = {
    "files/mdc.dds",
    0.3125,
    0.5
  },
  medic = {
    "files/medic.dds",
    0.3125,
    0.5,
    true
  }
}
function getCustomMarkerTexture(text)
  if markerTypes[text] then
    return ":seal_markers/" .. markerTypes[text][1]
  end
end
local charset = {
  A = {0, 0.359375},
  B = {23, 0.375},
  C = {47, 0.34375},
  D = {69, 0.375},
  E = {93, 0.328125},
  F = {114, 0.3125},
  G = {134, 0.359375},
  H = {157, 0.390625},
  I = {182, 0.1875},
  J = {194, 0.25},
  K = {210, 0.375},
  L = {234, 0.3125},
  M = {254, 0.484375},
  N = {285, 0.390625},
  O = {310, 0.359375},
  P = {333, 0.359375},
  Q = {356, 0.359375},
  R = {379, 0.375},
  S = {403, 0.34375},
  T = {425, 0.328125},
  U = {446, 0.375},
  V = {470, 0.34375},
  W = {492, 0.5},
  X = {524, 0.375},
  Y = {548, 0.359375},
  Z = {571, 0.328125},
  a = {592, 0.34375},
  b = {614, 0.359375},
  c = {637, 0.328125},
  d = {658, 0.359375},
  e = {681, 0.34375},
  f = {703, 0.25},
  g = {719, 0.359375},
  h = {742, 0.359375},
  i = {765, 0.1875},
  j = {777, 0.1875},
  k = {789, 0.359375},
  l = {812, 0.1875},
  m = {824, 0.53125},
  n = {858, 0.359375},
  o = {881, 0.34375},
  p = {903, 0.359375},
  q = {926, 0.359375},
  r = {949, 0.25},
  s = {965, 0.3125},
  t = {985, 0.25},
  u = {1001, 0.359375},
  v = {1024, 0.328125},
  w = {1045, 0.484375},
  x = {1076, 0.34375},
  y = {1098, 0.328125},
  z = {1119, 0.3125},
  ["0"] = {1139, 0.359375},
  ["1"] = {1162, 0.265625},
  ["2"] = {1179, 0.34375},
  ["3"] = {1201, 0.34375},
  ["4"] = {1223, 0.359375},
  ["5"] = {1246, 0.34375},
  ["6"] = {1268, 0.359375},
  ["7"] = {1291, 0.328125},
  ["8"] = {1312, 0.359375},
  ["9"] = {1335, 0.359375},
  ["Á"] = {1358, 0.359375},
  ["É"] = {1381, 0.328125},
  ["Í"] = {1402, 0.1875},
  ["Ó"] = {1414, 0.359375},
  ["Ö"] = {1437, 0.359375},
  ["Ő"] = {1460, 0.359375},
  ["Ú"] = {1483, 0.375},
  ["Ü"] = {1507, 0.375},
  ["Ű"] = {1531, 0.375},
  ["á"] = {1555, 0.34375},
  ["é"] = {1577, 0.34375},
  ["í"] = {1599, 0.1875},
  ["ó"] = {1611, 0.34375},
  ["ö"] = {1633, 0.34375},
  ["ő"] = {1655, 0.34375},
  ["ú"] = {1677, 0.359375},
  ["ü"] = {1700, 0.359375},
  ["ű"] = {1723, 0.359375},
  ["("] = {1746, 0.25},
  [")"] = {1762, 0.25},
  ["<"] = {1778, 0.359375},
  [">"] = {1801, 0.359375},
  ["-"] = {1824, 0.25},
  ["."] = {1840, 0.1875},
  ["\226\128\162"] = {1852, 0.28125},
  [","] = {1870, 0.1875},
  [":"] = {1882, 0.1875},
  ["["] = {1894, 0.25},
  ["]"] = {1910, 0.25},
  ["'"] = {1926, 0.171875},
  ["\""] = {1937, 0.296875},
  [";"] = {1956, 0.1875},
  ["?"] = {1968, 0.328125},
  ["!"] = {1989, 0.203125},
  ["*"] = {2002, 0.390625},
  ["/"] = {2027, 0.359375},
  ["\\"] = {2050, 0.359375},
  ["$"] = {2073, 0.359375},
  ["&"] = {2096, 0.375},
  ["@"] = {2120, 0.625},
  ["#"] = {2160, 0.359375},
  _ = {2183, 0.28125},
  ["\226\156\154"] = {2201, 0.609375},
  ["\226\152\133"] = {2240, 0.59375},
  ["\226\152\134"] = {2278, 0.59375}
}
local customMarkers = {}
local carMarkColor = false
function processText(text, colors)
  if text then
    local dat = {}
    for i = 1, #text do
      local col = colors and colors[i]
      dat[i] = {
        {},
        0,
        col
      }
      if col then
        cacheColor(col)
      end
      local n = utf8.len(text[i])
      for j = 1, n do
        dat[i][1][j] = utf8.sub(text[i], j, j)
        local dc = charset[dat[i][1][j]]
        if dc then
          dat[i][2] = dat[i][2] + dc[2]
        else
          dat[i][2] = dat[i][2] + 0.25
        end
      end
    end
    return dat
  end
  return nil
end
local white = {
  255,
  255,
  255
}
local markedVehicle = false
function setMarkedVehicle(veh, color)
  markedVehicle = veh
  if veh and exports.seal_gui then
    carMarkColor = seexports.seal_gui:getColorCode(color or "green")
  else
    carMarkColor = white
  end
end
local screenX, screenY = guiGetScreenSize()
local syncZones = {}
local syncSize = 100
function getSyncZone(x, y, int, dim)
  if 0 < dim then
    return "dim", dim
  else
    x = math.floor(x / syncSize)
    y = math.floor(y / syncSize)
    return x, y
  end
end
function setCustomMarkerText(id, text, textColors)
  if customMarkers[id] then
    customMarkers[id][8] = processText(text, textColors)
    if customMarkers[id][8] then
      customMarkers[id][9] = 0
    else
      customMarkers[id][9] = nil
    end
  end
end
function setCustomMarkerColor(id, color)
  if customMarkers[id] then
    cacheColor(color)
    customMarkers[id][7] = color
  end
end
function setCustomMarkerType(id, theType)
  if customMarkers[id] then
    customMarkers[id][6] = theType
  end
end
function setCustomMarkerPosition(id, nx, ny, nz, ni, nd)
  if customMarkers[id] then
    local x, y, z, int, dim = customMarkers[id][1], customMarkers[id][2], customMarkers[id][3], customMarkers[id][4], customMarkers[id][5]
    local nzx, nzy = getSyncZone(nx, ny, ni, nd)
    local zx, zy = false, false
    if x and y and int and dim then
      zx, zy = getSyncZone(x, y, int, dim)
      if (zx ~= nzx or zy ~= nzy) and syncZones[zx] and syncZones[zx][zy] then
        for i = #syncZones[zx][zy], 1, -1 do
          if syncZones[zx][zy][i] == id then
            table.remove(syncZones[zx][zy], i)
          end
        end
        if #syncZones[zx][zy] <= 0 then
          syncZones[zx][zy] = nil
        end
      end
    end
    if zx ~= nzx or zy ~= nzy then
      if not syncZones[nzx] then
        syncZones[nzx] = {}
      end
      if not syncZones[nzx][nzy] then
        syncZones[nzx][nzy] = {}
      end
      table.insert(syncZones[nzx][nzy], id)
    end
    customMarkers[id][1], customMarkers[id][2], customMarkers[id][3], customMarkers[id][4], customMarkers[id][5] = nx, ny, nz, ni, nd
  end
end
function setCustomMarkerInt(id, ni)
  if customMarkers[id] then
    local x, y, z, int, dim = customMarkers[id][1], customMarkers[id][2], customMarkers[id][3], customMarkers[id][4], customMarkers[id][5]
    setCustomMarkerPosition(id, x, y, z, ni, dim)
  end
end
function setCustomMarkerDimension(id, nd)
  if customMarkers[id] then
    local x, y, z, int, dim = customMarkers[id][1], customMarkers[id][2], customMarkers[id][3], customMarkers[id][4], customMarkers[id][5]
    setCustomMarkerPosition(id, x, y, z, int, nd)
  end
end
local guiReady = false
local colorCache = {}
function cacheColor(color, force)
  if not colorCache[color] or force then
    if guiReady then
      colorCache[color] = seexports.seal_gui:getColorCode(color)
    else
      colorCache[color] = white
    end
  end
end
function refershColorCache()
  guiReady = true
  for col in pairs(colorCache) do
    cacheColor(col, true)
  end
end
local lastId = 0
function deleteCustomMarker(id)
  if customMarkers[id] then
    local x, y, z, int, dim = customMarkers[id][1], customMarkers[id][2], customMarkers[id][3], customMarkers[id][4], customMarkers[id][5]
    if x and y and int and dim then
      zx, zy = getSyncZone(x, y, int, dim)
      if syncZones[zx] and syncZones[zx][zy] then
        for i = #syncZones[zx][zy], 1, -1 do
          if syncZones[zx][zy][i] == id then
            table.remove(syncZones[zx][zy], i)
          end
        end
        if #syncZones[zx][zy] <= 0 then
          syncZones[zx][zy] = nil
        end
      end
    end
  end
  customMarkers[id] = nil
end
function setCustomMarkerInterior(id, intType, intId, range)
  if customMarkers[id] then
    customMarkers[id][10] = intType
    customMarkers[id][11] = intId
    customMarkers[id][12] = range
  end
end
function setCustomMarkerPolice(id, lock, lockBy)
  if customMarkers[id] then
    if lock then
      customMarkers[id][13] = processText({
        tostring(lock),
        tostring(lockBy)
      }, {"red", "red"})
    else
      customMarkers[id][13] = nil
    end
  end
end
function createCustomMarker(x, y, z, int, dim, color, theType, text, textColors)
  lastId = lastId + 1
  customMarkers[lastId] = {}
  setCustomMarkerPosition(lastId, x, y, z, int, dim)
  setCustomMarkerColor(lastId, color)
  setCustomMarkerType(lastId, theType)
  setCustomMarkerText(lastId, text, textColors)
  return lastId
end
local currentIntType = false
local currentIntId = false
local currentIntTypeTmp = false
local currentIntIdTmp = false
addEventHandler("onClientPreRender", getRootElement(), function(delta)
  local px, py, pz = getElementPosition(localPlayer)
  local int = getElementInterior(localPlayer)
  local dim = getElementDimension(localPlayer)
  local zx, zy = getSyncZone(px, py, int, dim)
  local now = getTickCount()
  if markedVehicle and isElement(markedVehicle) and getElementDimension(markedVehicle) == dim and getElementInterior(markedVehicle) == int then
    local x, y, z = getElementPosition(markedVehicle)
    local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(markedVehicle)
    z = z + (maxZ or 0) + 0.75
    local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
    if dist < 250 then
      local a = 255
      if 200 < dist then
        a = 255 - 255 * (dist - 200) / 50
      end
      local p = (now - 75) / 1500 % 2
      if 1 < p then
        p = 1 - (p - 1)
      end
      local z = interpolateBetween(z - 0.125, 0, 0, z + 0.125, 0, 0, p, "InOutQuad")
      local tex = latentDynamicImage(markerTypes.car[1])
      if tex then
        dxDrawMaterialLine3D(x, y, z + markerTypes.car[3], x, y, z - markerTypes.car[3], tex, markerTypes.car[2] * 2, tocolor(carMarkColor[1], carMarkColor[2], carMarkColor[3], a))
      end
    end
  end
  currentIntTypeTmp = false
  currentIntIdTmp = false
  local cx, cy, cz = getCameraMatrix()
  if tonumber(zx) then
    for x = -1, 1 do
      if syncZones[zx + x] then
        for y = -1, 1 do
          local zone = syncZones[zx + x][zy + y]
          if zone then
            drawZone(zone, now, delta, cx, cy, cz, px, py, pz, int)
          end
        end
      end
    end
  else
    local zone = syncZones[zx] and syncZones[zx][zy]
    if zone then
      drawZone(zone, now, delta, cx, cy, cz, px, py, pz, int)
    end
  end
  if currentIntTypeTmp ~= currentIntType or currentIntIdTmp ~= currentIntId then
    currentIntType = currentIntTypeTmp
    currentIntId = currentIntIdTmp
    triggerEvent("changeEnteredCustomMarker", localPlayer, currentIntType, currentIntId)
  end
end)
addEvent("changeEnteredCustomMarker", false)
addCommandHandler("debugmarkers", function()
  outputChatBox("---")
  local px, py, pz = getElementPosition(localPlayer)
  local int = getElementInterior(localPlayer)
  local dim = getElementDimension(localPlayer)
  local zx, zy = getSyncZone(px, py, int, dim)
  if tonumber(zx) then
    for x = -1, 1 do
      if syncZones[zx + x] then
        for y = -1, 1 do
          local zone = syncZones[zx + x][zy + y]
          if zone then
            outputChatBox("zone " .. zx + x .. ", " .. zy + y)
            for i = #zone, 1, -1 do
              local id = zone[i]
              outputChatBox("id: " .. tostring(id))
            end
          end
        end
      end
    end
  else
    local zone = syncZones[zx][zy]
    outputChatBox("zone " .. zx .. ", " .. zy)
    if zone then
      for i = #zone, 1, -1 do
        local id = zone[i]
        outputChatBox("id: " .. tostring(id))
      end
    end
  end
end)
function drawZone(zone, now, delta, cx, cy, cz, px, py, pz, int)
  if zone then
    for i = #zone, 1, -1 do
      local id = zone[i]
      if id and customMarkers[id] then
        if int == customMarkers[id][4] then
          local x, y, z = customMarkers[id][1], customMarkers[id][2], customMarkers[id][3]
          local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
          local a = 255
          if dist > syncSize - 10 then
            a = 255 - 255 * (dist - (syncSize - 10)) / 10
          end
          if customMarkers[id][12] and dist < customMarkers[id][12] then
            currentIntTypeTmp = customMarkers[id][10]
            currentIntIdTmp = customMarkers[id][11]
          end
          if 0 < a then
            local p = (now + id * 75) / 1500 % 2
            if 1 < p then
              p = 1 - (p - 1)
            end
            local theType = customMarkers[id][6]
            if not markerTypes[theType] then
            end
            local zs = markerTypes[theType][3] / 4
            local z = interpolateBetween(z - zs, 0, 0, z + zs, 0, 0, p, "InOutQuad")
            local col = colorCache[customMarkers[id][7]] or white
            local vx, vy = false, false
            if markerTypes[theType][4] or customMarkers[id][13] then
              vx = cx - x
              vy = cy - y
              local len = math.sqrt(vx * vx + vy * vy)
              vx = vx / len
              vy = vy / len
              if not customMarkers[id][9] then
                customMarkers[id][9] = 0
              end
              if dist < 7.5 then
                if 1 > customMarkers[id][9] then
                  customMarkers[id][9] = customMarkers[id][9] + 2.5 * delta / 1000
                  if 1 < customMarkers[id][9] then
                    customMarkers[id][9] = 1
                  end
                end
              elseif 0 < customMarkers[id][9] then
                customMarkers[id][9] = customMarkers[id][9] - 2.5 * delta / 1000
                if 0 > customMarkers[id][9] then
                  customMarkers[id][9] = 0
                end
              end
              local text = customMarkers[id][8]
              if customMarkers[id][13] then
                if not text then
                  text = customMarkers[id][13]
                else
                  local tmp = {}
                  for i = 1, #text do
                    table.insert(tmp, text[i])
                  end
                  for i = 1, #customMarkers[id][13] do
                    table.insert(tmp, customMarkers[id][13][i])
                  end
                  text = tmp
                end
              end
              if text then
                local p2 = customMarkers[id][9]
                local tex = latentDynamicImage(markerTypes.arrow2[1])
                if tex then
                  dxDrawMaterialLine3D(x, y, z + markerTypes.arrow2[3], x, y, z - markerTypes.arrow2[3], tex, markerTypes.arrow2[2] * 2, tocolor(col[1], col[2], col[3], a))
                end
                local ls = 0.125
                local n = #text
                local lz = z + 0.025 + ls * 0.85 * n
                z = z + (0.025 + ls * 0.85 * n + 0.05) * p2
                if 0 < p2 then
                  for l = 1, n do
                    lz = lz - ls * 0.85
                    local t = text[l][1]
                    local w = text[l][2] * ls
                    local lx = x + vy * w / 2
                    local ly = y - vx * w / 2
                    local col = tocolor(255, 255, 255)
                    if text[l][3] and colorCache[text[l][3]] then
                      col = tocolor(colorCache[text[l][3]][1], colorCache[text[l][3]][2], colorCache[text[l][3]][3])
                    end
                    for j = 1, #t do
                      local w = charset[t[j]]
                      if w then
                        local lw = w[2] * ls
                        local z2 = math.min(z, lz + ls)
                        local z1 = math.min(z, lz)
                        local h = (z2 - z1) / ls
                        seelangStaticImageUsed[0] = true
                        if seelangStaticImageToc[0] then
                          processSeelangStaticImage[0]()
                        end
                        dxDrawMaterialSectionLine3D(lx - vy * lw / 2, ly + vx * lw / 2, z2, lx - vy * lw / 2, ly + vx * lw / 2, z1, w[1], 64 * (1 - h), w[2] * 64, 64 * h, seelangStaticImage[0], lw, col, lx + vx, ly + vy, lz)
                        lx = lx - vy * lw
                        ly = ly + vx * lw
                      else
                        local lw = 0.25 * ls
                        lx = lx - vy * lw
                        ly = ly + vx * lw
                      end
                    end
                  end
                end
                local s = 1 - 0.4 * p2
                if customMarkers[id][13] then
                  local x, y = x + vx * 0.05, y + vy * 0.05
                  local tex = latentDynamicImage(markerTypes.police[1])
                  if tex then
                    dxDrawMaterialLine3D(x, y, z + markerTypes.police[3] * s, x, y, z - markerTypes.police[3] * s, tex, markerTypes.police[2] * s * 2, tocolor(255, 255, 255, a))
                  end
                end
                local tex = latentDynamicImage(markerTypes[theType][1])
                if tex then
                  dxDrawMaterialLine3D(x, y, z + markerTypes[theType][3] * s, x, y, z - markerTypes[theType][3] * s, tex, markerTypes[theType][2] * s * 2, tocolor(col[1], col[2], col[3], a))
                end
              else
                local tex = latentDynamicImage(markerTypes.arrow2[1])
                if tex then
                  dxDrawMaterialLine3D(x, y, z + markerTypes.arrow2[3], x, y, z - markerTypes.arrow2[3], tex, markerTypes.arrow2[2] * 2, tocolor(col[1], col[2], col[3], a))
                end
                local tex = latentDynamicImage(markerTypes[theType][1])
                if tex then
                  dxDrawMaterialLine3D(x, y, z + markerTypes[theType][3], x, y, z - markerTypes[theType][3], tex, markerTypes[theType][2] * 2, tocolor(col[1], col[2], col[3], a))
                end
              end
            else
              local tex = latentDynamicImage(markerTypes[theType][1])
              if tex then
                dxDrawMaterialLine3D(x, y, z + markerTypes[theType][3], x, y, z - markerTypes[theType][3], tex, markerTypes[theType][2] * 2, tocolor(col[1], col[2], col[3], a))
              end
            end
          end
        end
      else
        table.remove(zone, i)
      end
    end
  end
end
