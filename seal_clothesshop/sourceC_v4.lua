local steelexports = {
  seal_gui = false,
  seal_markers = false,
  pattach = false,
  seal_controls = false,
  seal_groups = false,
  seal_weapons = false,
  seal_items = false
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
local steelangStatImgHand = false
local steelangStaticImage = {}
local steelangStaticImageToc = {}
local steelangStaticImageUsed = {}
local steelangStaticImageDel = {}
local processsteelangStaticImage = {}
steelangStaticImageToc[0] = true
local steelangStatImgPre
function steelangStatImgPre()
  local now = getTickCount()
  if steelangStaticImageUsed[0] then
    steelangStaticImageUsed[0] = false
    steelangStaticImageDel[0] = false
  elseif steelangStaticImage[0] then
    if steelangStaticImageDel[0] then
      if now >= steelangStaticImageDel[0] then
        if isElement(steelangStaticImage[0]) then
          destroyElement(steelangStaticImage[0])
        end
        steelangStaticImage[0] = nil
        steelangStaticImageDel[0] = false
        steelangStaticImageToc[0] = true
        return
      end
    else
      steelangStaticImageDel[0] = now + 5000
    end
  else
    steelangStaticImageToc[0] = true
  end
  if steelangStaticImageToc[0] then
    steelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), steelangStatImgPre)
  end
end
processsteelangStaticImage[0] = function()
  if not isElement(steelangStaticImage[0]) then
    steelangStaticImageToc[0] = false
    steelangStaticImage[0] = dxCreateTexture("files/circle.dds", "argb", true)
  end
  if not steelangStatImgHand then
    steelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), steelangStatImgPre, true, "high+999999999")
  end
end
local steelangWaiterState0 = false
local function steelangProcessResWaiters()
  if not steelangWaiterState0 then
    local res0 = getResourceFromName("seal_markers")
    if res0 and getResourceState(res0) == "running" then
      markersStarted()
      steelangWaiterState0 = true
    end
  end
end
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), steelangProcessResWaiters)
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), steelangProcessResWaiters)
end
local steelangGuiRefreshColors = function()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    guiRefreshColors()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), steelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), steelangGuiRefreshColors)
local origFE = fileExists
local origFC = fileCreate
local origFO = fileOpen
local origFD = fileDelete
function fileExists(f)
  return origFE("!clothes_steel/" .. f)
end
function fileCreate(f)
  return origFC("!clothes_steel/" .. f)
end
function fileOpen(f)
  return origFO("!clothes_steel/" .. f)
end
function fileDelete(f)
  return origFD("!clothes_steel/" .. f)
end
local presetNames = {}
local presetIcons = {}
local presetIconList = {
  "tshirt",
  "user-tie",
  "user-secret",
  "user",
  "user-hard-hat",
  "user-md",
  "user-crown",
  "user-cowboy",
  "user-astronaut",
  "smoking",
  "smoking-ban"
}
addEventHandler("onClientResourceStart", resourceRoot, function()
  for i = 1, 9 do
    if fileExists("presetname_" .. i .. ".seal") then
      local file = fileOpen("presetname_" .. i .. ".seal")
      local data = fileRead(file, fileGetSize(file))
      if data and 1 <= utf8.len(data) and utf8.len(data) <= 48 then
        presetNames[i] = data
      end
      fileClose(file)
    end
    if fileExists("preseticon_" .. i .. ".seal") then
      local file = fileOpen("preseticon_" .. i .. ".seal")
      local data = tonumber(fileRead(file, fileGetSize(file)))
      if data and 1 <= data and data <= #presetIconList then
        presetIcons[i] = data
      end
      fileClose(file)
    end
  end
end)
screenX, screenY = guiGetScreenSize()
local freeSlots = defaultSlots
clothesListWindow = false
local clothesSelectorWindow = false
local slotButtons = false
local presetButtons = false
local selectorElements = false
local previewButtons = false
local selectorCategoryButtons = false
local selectorScrollBar = false
local clothesSelectorData = false
local countedClothes = false
local clothesScrollHandled = false
local savingPreset = false
local selectedPreset = false
local boughtClothes = {}
local bindState = false
addEvent("gotBoughtClothes", true)
addEventHandler("gotBoughtClothes", getRootElement(), function(data)
  boughtClothes = data or {}
end)
local loadedArmor = {}
local loadedArmorList = {}
addEvent("gotLoadedArmor", true)
addEventHandler("gotLoadedArmor", getRootElement(), function(data)
  loadedArmor = data or {}
  loadedArmorList = {}
  for dbID in pairs(loadedArmor) do
    table.insert(loadedArmorList, dbID)
  end
end)
addEvent("gotArmorDamage", true)
addEventHandler("gotArmorDamage", getRootElement(), function(armorId, hp)
  if loadedArmor[armorId] then
    if hp then
      loadedArmor[armorId][2] = hp
    else
      loadedArmor[armorId] = nil
    end
  end
end)
addEvent("gotNewBoughtCloth", true)
addEventHandler("gotNewBoughtCloth", getRootElement(), function(cloth, amount)
  boughtClothes[cloth] = amount
  if clothesSelectorWindow then
    createClothesSelector()
  end
end)
addEvent("gotNewBoughtArmor", true)
addEventHandler("gotNewBoughtArmor", getRootElement(), function(id, dat)
  loadedArmor[id] = dat
  loadedArmorList = {}
  for dbID in pairs(loadedArmor) do
    table.insert(loadedArmorList, dbID)
  end
  if clothesSelectorWindow then
    createClothesSelector()
  end
end)
editingWeapon = false
editingSlot = false
local selectedShopModel = false
local clothesShopMode = false
local preEditingSlot = false
local selectedArmorId = false
local editingObject = false
local editingModel = false
local editingUnsaved = false
local editorPrompt = false
local boneId = false
local coords = {
  0,
  0,
  0
}
local objQ = {
  1,
  0,
  0,
  0
}
local scale = {
  1,
  1,
  1
}
local movingAxis = false
local movingRot = false
local movingScale = false
local movingPosition = false
local camDist = 2
local camR1 = math.pi / 2
local camR2 = 0
function qCheck(q)
  local c = 0
  for i = 1, 4 do
    if q[i] ~= q[i] then
      return false
    end
    c = c + math.abs(q[i])
  end
  return 0 < c
end
function qNorm(q)
  local len = math.sqrt(q[1] * q[1] + q[2] * q[2] + q[3] * q[3] + q[4] * q[4])
  for i = 1, 4 do
    q[i] = q[i] / len
  end
  return q
end
function qMul(q1, q2)
  local q3 = {
    q1[1] * q2[1] - q1[2] * q2[2] - q1[3] * q2[3] - q1[4] * q2[4],
    q1[2] * q2[1] + q1[1] * q2[2] + q1[3] * q2[4] - q1[4] * q2[3],
    q1[1] * q2[3] - q1[2] * q2[4] + q1[3] * q2[1] + q1[4] * q2[2],
    q1[1] * q2[4] + q1[2] * q2[3] - q1[3] * q2[2] + q1[4] * q2[1]
  }
  return q3
end
function vecIntersect(Ax, Ay, Bx, By, Cx, Cy, Dx, Dy)
  local a1 = By - Ay
  local b1 = Ax - Bx
  local c1 = a1 * Ax + b1 * Ay
  local a2 = Dy - Cy
  local b2 = Cx - Dx
  local c2 = a2 * Cx + b2 * Cy
  local determinant = a1 * b2 - a2 * b1
  local x = (b2 * c1 - b1 * c2) / determinant
  local y = (a1 * c2 - a2 * c1) / determinant
  return x, y
end
function fromRad(axisx, axisy, axisz, ang)
  ang = ang / 2
  local cos = math.cos(ang)
  local sin = math.sin(ang)
  return {
    cos,
    axisx * sin,
    axisy * sin,
    axisz * sin
  }
end
function fromRotation(axisx, axisy, axisz, ang)
  ang = math.rad(ang) / 2
  local cos = math.cos(ang)
  local sin = math.sin(ang)
  return {
    cos,
    axisx * sin,
    axisy * sin,
    axisz * sin
  }
end
function copysign(a, b)
  if b < 0 then
    return -a
  else
    return a
  end
end
function toAngle(q)
  local output0, output1, output2
  local sinr_cosp = 2 * (q[1] * q[2] + q[3] * q[4])
  local cosr_cosp = 1 - 2 * (q[2] * q[2] + q[3] * q[3])
  output0 = math.atan2(sinr_cosp, cosr_cosp)
  local sinp = 2 * (q[1] * q[3] - q[4] * q[2])
  if 1 <= math.abs(sinp) then
    output1 = copysign(math.pi / 2, sinp)
  else
    output1 = math.asin(sinp)
  end
  local siny_cosp = 2 * (q[1] * q[4] + q[2] * q[3])
  local cosy_cosp = 1 - 2 * (q[3] * q[3] + q[4] * q[4])
  output2 = math.atan2(siny_cosp, cosy_cosp)
  return math.deg(output0), math.deg(output1), math.deg(output2)
end
function reverseMatrix(m, x, y, z)
  return (-m[2][1] * m[3][2] * z + m[2][1] * m[3][3] * y - m[2][2] * m[3][3] * x + m[2][2] * m[3][1] * z + m[3][2] * m[2][3] * x - m[2][3] * m[3][1] * y) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1]), (m[1][1] * m[3][2] * z - m[1][1] * m[3][3] * y - m[1][3] * m[3][2] * x + m[1][3] * m[3][1] * y + m[3][3] * m[1][2] * x - m[1][2] * m[3][1] * z) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1]), (-m[1][1] * m[2][2] * z + m[1][1] * m[2][3] * y - m[1][3] * m[2][1] * y + m[1][3] * m[2][2] * x + m[2][1] * m[1][2] * z - m[1][2] * m[2][3] * x) / (-m[1][1] * m[2][2] * m[3][3] + m[1][1] * m[3][2] * m[2][3] - m[1][3] * m[2][1] * m[3][2] + m[1][3] * m[2][2] * m[3][1] + m[2][1] * m[3][3] * m[1][2] - m[1][2] * m[2][3] * m[3][1])
end
function findPerpendicVecForCircl(Qx, Qy, Qz)
  local Ux, Uy, Uz
  if Qx ~= 0 then
    Ux = -Qy / Qx
    Uy = 1
    Uz = 0
  elseif Qy ~= 0 then
    Ux = 0
    Uy = -Qz / Qy
    Uz = 1
  else
    Ux = 1
    Uy = 0
    Uz = -Qx / Qz
  end
  local Vx = Qy * Uz - Qz * Uy
  local Vy = Qz * Ux - Qx * Uz
  local Vz = Qx * Uy - Qy * Ux
  local Ulength = math.sqrt(Ux * Ux + Uy * Uy + Uz * Uz)
  local Vlength = math.sqrt(Vx * Vx + Vy * Vy + Vz * Vz)
  Ux = Ux / Ulength
  Uy = Uy / Ulength
  Uz = Uz / Ulength
  Vx = Vx / Vlength
  Vy = Vy / Vlength
  Vz = Vz / Vlength
  return Ux, Uy, Uz, Vx, Vy, Vz
end
function circleAround(Ux, Uy, Uz, Vx, Vy, Vz, radius, cos, sin)
  return radius * (cos * Ux + sin * Vx), radius * (cos * Uy + sin * Vy), radius * (cos * Uz + sin * Vz)
end
local axisColors = {
  tocolor(0, 0, 0),
  tocolor(0, 0, 0),
  tocolor(0, 0, 0)
}
local faTicks = {}
local scaleIcon = false
local boneIcon = false
local moveIcon = false
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = steelexports.seal_gui:getFaTicks()
end)
local grey = false
local green = false
local green2 = false
function guiRefreshColors()
  local resource = getResourceFromName("seal_gui")
  if resource and getResourceState(resource) == "running" then
    grey = steelexports.seal_gui:getColorCodeToColor("grey1")
    green = steelexports.seal_gui:getColorCodeToColor("green")
    green2 = steelexports.seal_gui:getColorCode("green")
    green2[4] = 150
    axisColors[1] = steelexports.seal_gui:getColorCodeToColor("green")
    axisColors[2] = steelexports.seal_gui:getColorCodeToColor("blue")
    axisColors[3] = steelexports.seal_gui:getColorCodeToColor("red")
    refreshAxisAlpha()
    refreshIcons()
    faTicks = steelexports.seal_gui:getFaTicks()
  end
end
local customMarkers = {}
function markersStarted()
  for i = 1, #clothesShopPoses do
    local marker = steelexports.seal_markers:createCustomMarker(clothesShopPoses[i][1], clothesShopPoses[i][2], clothesShopPoses[i][3], clothesShopPoses[i][4], clothesShopPoses[i][5], "blue", "cloth2")
    steelexports.seal_markers:setCustomMarkerInterior(marker, "clothesShop", false, 1.5)
    table.insert(customMarkers, marker)
  end
  for i = 1, #armorShopPoses do
    local marker = steelexports.seal_markers:createCustomMarker(armorShopPoses[i][1], armorShopPoses[i][2], armorShopPoses[i][3], armorShopPoses[i][4], armorShopPoses[i][5], "blue", "armor")
    steelexports.seal_markers:setCustomMarkerInterior(marker, "clothesShopArmor", false, 1.5)
    table.insert(customMarkers, marker)
  end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for i = 1, #customMarkers do
    steelexports.seal_markers:deleteCustomMarker(customMarkers[i])
  end
end)
function planePoint(rayPointx, rayPointy, rayPointz, rayVectorx, rayVectory, rayVectorz, planePointx, planePointy, planePointz, planeNormalx, planeNormaly, planeNormalz)
  local diffx = rayPointx - planePointx
  local diffy = rayPointy - planePointy
  local diffz = rayPointz - planePointz
  local prod1 = diffx * planeNormalx + diffy * planeNormaly + diffz * planeNormalz
  local prod2 = rayVectorx * planeNormalx + rayVectory * planeNormaly + rayVectorz * planeNormalz
  local prod3 = prod1 / prod2
  return rayPointx - prod3 * rayVectorx, rayPointy - prod3 * rayVectory, rayPointz - prod3 * rayVectorz
end
local axisAlpha = 0.7375
local baseCursorSize = 0.26249999999999996
local cursorSize = 0
local lineWidth = 0
function refreshCursorSize()
  cursorSize = baseCursorSize * (camDist / 2)
  lineWidth = cursorSize * 1.65
end
function refreshAxisAlpha()
  for i = 1, 3 do
    axisColors[i] = bitReplace(axisColors[i], 255 * axisAlpha, 24, 8)
    axisColors[i + 3] = bitReplace(axisColors[i], bitExtract(axisColors[i], 24, 8) * 0.6, 24, 8)
  end
end
addEvent("changeClothesshopEditorCursorSize", true)
addEventHandler("changeClothesshopEditorCursorSize", getRootElement(), function(el, sliderValue)
  baseCursorSize = 0.1 + 0.24999999999999997 * sliderValue
  refreshCursorSize()
end)
addEvent("changeClothesshopEditorCursorAlpha", true)
addEventHandler("changeClothesshopEditorCursorAlpha", getRootElement(), function(el, sliderValue)
  axisAlpha = 0.25 + 0.75 * sliderValue
  refreshAxisAlpha()
end)
local worldMatrix = {
  {
    1,
    0,
    0
  },
  {
    0,
    1,
    0
  },
  {
    0,
    0,
    1
  }
}
local hover = false
local camX, camY, camZ = 0, 0, 0
local camMoveX = false
local camMoveY = false
local moveOrigin = "object"
local cameraOrigin = "char"
local currentMode = "move"
local mtmp = false
local editorGui = false
local modeButtons = {}
local originButtons = {}
local cameraButtons = {}
function clothesshopEditorKey(key, state)
  if key == "mouse_wheel_up" then
    if 0.5 < camDist then
      camDist = camDist - 0.1
      refreshCursorSize()
    end
  elseif key == "mouse_wheel_down" then
    if camDist < 3 then
      camDist = camDist + 0.1
      refreshCursorSize()
    end
  elseif key == "c" and state and not movingAxis then
    if cameraOrigin == "object" then
      cameraOrigin = "char"
    elseif cameraOrigin == "char" then
      cameraOrigin = "object"
    end
    refreshEditorGui()
  elseif key == "space" and state and not movingAxis then
    if mtmp == "move" then
      if moveOrigin == "object" then
        moveOrigin = "bone"
      elseif moveOrigin == "bone" then
        moveOrigin = "char"
      elseif moveOrigin == "char" then
        moveOrigin = "world"
      elseif moveOrigin == "world" then
        moveOrigin = "object"
      end
      refreshEditorGui()
    end
  elseif key == "lalt" and state and not movingAxis then
    if currentMode == "move" then
      currentMode = "rot"
    elseif currentMode == "rot" then
      if editingWeapon then
        currentMode = "move"
      else
        currentMode = "scale"
      end
    elseif currentMode == "scale" then
      currentMode = "move"
    end
  end
end
function refreshIcons()
  moveIcon = steelexports.seal_gui:getFaIconFilename("arrows", 22)
  scaleIcon = steelexports.seal_gui:getFaIconFilename("expand-alt", 22)
  boneIcon = steelexports.seal_gui:getFaIconFilename("bone", 22)
end
function dot(x, y, z, x2, y2, z2)
  return x * x2 + y * y2 + z * z2
end
function cross(x, y, z, x2, y2, z2)
  return y * z2 - y2 * z, z * x2 - z2 * x, x * y2 - x2 * y
end
function sortVerts(a, b)
  return a[5] < b[5]
end
addEvent("changeClothesshopCameraOrigin", false)
addEventHandler("changeClothesshopCameraOrigin", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not movingAxis then
    for cam, btn in pairs(cameraButtons) do
      if el == btn then
        cameraOrigin = cam
        refreshEditorGui()
        return
      end
    end
  end
end)
addEvent("changeClothesshopEditorOrigin", false)
addEventHandler("changeClothesshopEditorOrigin", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not movingAxis and mtmp == "move" then
    for origin, btn in pairs(originButtons) do
      if el == btn then
        moveOrigin = origin
        refreshEditorGui()
        return
      end
    end
  end
end)
addEvent("changeClothesshopEditorMode", false)
addEventHandler("changeClothesshopEditorMode", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not movingAxis then
    for mode, btn in pairs(modeButtons) do
      if el == btn then
        currentMode = mode
        return
      end
    end
  end
end)
function loadDataFromFile(name)
  name = "saves/" .. name .. ".seal"
  if fileExists(name) then
    local file = fileOpen(name)
    if file then
      local data = fileRead(file, fileGetSize(file))
      d = split(data, ",")
      for i = 1, 10 do
        if not tonumber(d[i]) then
          d[i] = 0
        end
      end
      if 0 >= math.abs(d[4]) + math.abs(d[5]) + math.abs(d[6]) + math.abs(d[7]) then
        d[4] = 1
      end
      coords = {
        d[1],
        d[2],
        d[3]
      }
      objQ = qNorm({
        d[4],
        d[5],
        d[6],
        d[7]
      })
      scale = {
        d[8],
        d[9],
        d[10]
      }
      for i = 1, 3 do
        scale[i] = math.max(0.25, math.min(2, scale[i]))
        coords[i] = math.max(-0.75, math.min(0.75, coords[i]))
      end
      steelexports.pattach:setPositionOffset(editingObject, -coords[3], coords[2], coords[1])
      steelexports.pattach:setRotationQuaternion(editingObject, objQ)
      setObjectScale(editingObject, scale[1], scale[2], scale[3])
      fileClose(file)
      data = nil
      collectgarbage("collect")
    end
  end
end
function saveDataToFile(name)
  name = "saves/" .. name .. ".seal"
  if fileExists(name) then
    fileDelete(name)
  end
  local file = fileCreate(name)
  if file then
    fileWrite(file, table.concat(coords, ",") .. ",")
    fileWrite(file, table.concat(objQ, ",") .. ",")
    fileWrite(file, table.concat(scale, ","))
    fileClose(file)
    collectgarbage("collect")
  end
end
addEvent("clothesshopSaveEditor", false)
addEventHandler("clothesshopSaveEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  startEditorSaving()
  if editingWeapon then
    if not playerWeaponCoords[localPlayer][editingWeapon] then
      playerWeaponCoords[localPlayer][editingWeapon] = {}
    end
    playerWeaponCoords[localPlayer][editingWeapon][1] = boneId
    playerWeaponCoords[localPlayer][editingWeapon][2] = coords[1]
    playerWeaponCoords[localPlayer][editingWeapon][3] = coords[2]
    playerWeaponCoords[localPlayer][editingWeapon][4] = coords[3]
    playerWeaponCoords[localPlayer][editingWeapon][5] = objQ
    refreshPlayerWeapon(localPlayer, editingWeapon)
    triggerLatentServerEvent("refreshPlayerWeapon", localPlayer, editingWeapon, boneId, coords[1], coords[2], coords[3], objQ)
  else
    refreshPlayerCloth(localPlayer, editingSlot, editingModel, boneId, coords[1], coords[2], coords[3], objQ, scale[1], scale[2], scale[3], selectedArmorId)
    triggerLatentServerEvent("refreshPlayerCloth", localPlayer, editingSlot, editingModel, boneId, coords[1], coords[2], coords[3], objQ, scale[1], scale[2], scale[3], selectedArmorId)
  end
  saveDataToFile(editingModel .. "/last")
  saveDataToFile(editingModel .. "/" .. boneId)
  saveDataToFile("bone/" .. boneId)
  if not editingWeapon then
    saveDataToFile("slot/" .. editingSlot)
  end
end)
addEvent("clothesshopFinalExitEditor", false)
addEventHandler("clothesshopFinalExitEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if editingUnsaved then
    editingUnsaved = false
    saveDataToFile(editingModel .. "/unsaved")
  end
  local wp = editingWeapon
  deleteEditor()
  if wp then
    openWeaponClothesEditor()
  else
    createClothesList()
  end
end)
addEvent("clothesshopCancelExit", false)
addEventHandler("clothesshopCancelExit", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if editorPrompt then
    steelexports.seal_gui:deleteGuiElement(editorPrompt)
  end
  editorPrompt = false
end)
addEvent("clothesshopExitEditor", false)
addEventHandler("clothesshopExitEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if not movingAxis then
    if editingUnsaved then
      if editorPrompt then
        steelexports.seal_gui:deleteGuiElement(editorPrompt)
      end
      local pw = 300
      local ph = 150
      editorPrompt = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      steelexports.seal_gui:setWindowTitle(editorPrompt, "16/BebasNeueRegular.otf", "Mentetlen változtatások")
      local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
      local label = steelexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight - 30 - 6 - 6, editorPrompt)
      steelexports.seal_gui:setLabelAlignment(label, "center", "center")
      steelexports.seal_gui:setLabelText(label, "Biztosan szeretnél kilépni?\n\nA mentetlen változtatások elvesznek!")
      steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      local bw = (pw - 18) / 2
      local btn = steelexports.seal_gui:createGuiElement("button", 6, ph - 30 - 6, bw, 30, editorPrompt)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, "Igen")
      steelexports.seal_gui:setClickEvent(btn, "clothesshopFinalExitEditor")
      local btn = steelexports.seal_gui:createGuiElement("button", pw - bw - 6, ph - 30 - 6, bw, 30, editorPrompt)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, "Nem")
      steelexports.seal_gui:setClickEvent(btn, "clothesshopCancelExit")
    else
      local wp = editingWeapon
      deleteEditor()
      if wp then
        openWeaponClothesEditor()
      else
        createClothesList()
      end
    end
  end
end)
local loaderIcon = false
local saveButton = false
local editorLoaderButtons = false
function deleteEditorGui()
  saveButton = false
  if editorPrompt then
    steelexports.seal_gui:deleteGuiElement(editorPrompt)
  end
  editorPrompt = false
  editorLoaderButtons = false
  if editorGui then
    steelexports.seal_gui:deleteGuiElement(editorGui)
  end
  editorGui = false
  loaderIcon = false
  modeButtons = {}
  originButtons = {}
  cameraButtons = {}
end
addEvent("clothesshopLoadSavedFinal", false)
addEventHandler("clothesshopLoadSavedFinal", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if editorLoaderButtons[el] then
    if editorLoaderButtons[el] == "def" then
      coords = {
        0,
        0,
        0
      }
      objQ = {
        1,
        0,
        0,
        0
      }
      scale = {
        1,
        1,
        1
      }
      local dat = weaponDefaults[editingModel]
      if dat and boneId == dat[1] then
        coords = {
          dat[2],
          dat[3],
          dat[4]
        }
        objQ = {
          dat[5],
          dat[6],
          dat[7],
          dat[8]
        }
      end
      steelexports.pattach:setPositionOffset(editingObject, -coords[3], coords[2], coords[1])
      steelexports.pattach:setRotationQuaternion(editingObject, objQ)
      setObjectScale(editingObject, scale[1], scale[2], scale[3])
      editingUnsaved = true
    else
      loadDataFromFile(editorLoaderButtons[el])
      editingUnsaved = true
    end
    if editingWeapon and streamedWeapons[localPlayer][editingWeapon] then
      setElementAlpha(streamedWeapons[localPlayer][editingWeapon], 0)
    end
    if editorPrompt then
      steelexports.seal_gui:deleteGuiElement(editorPrompt)
    end
    editorPrompt = false
    editorLoaderButtons = false
    refreshEditorGui()
  end
end)
addEvent("clothesshopLoadSaved", false)
addEventHandler("clothesshopLoadSaved", getRootElement(), function()
  if editorPrompt then
    steelexports.seal_gui:deleteGuiElement(editorPrompt)
  end
  editorLoaderButtons = {}
  local datas = {"def"}
  local names = {
    "Alapértelmezett"
  }
  if fileExists("saves/" .. editingModel .. "/" .. boneId .. ".seal") then
    table.insert(datas, editingModel .. "/" .. boneId)
    table.insert(names, "Előző mentés: ez a kiegészítő és ez a csont")
  end
  if fileExists("saves/" .. editingModel .. "/unsaved.seal") then
    table.insert(datas, editingModel .. "/unsaved")
    table.insert(names, "Előző mentetlen: ez a kiegészítő")
  end
  if fileExists("saves/" .. editingModel .. "/last.seal") then
    table.insert(datas, editingModel .. "/last")
    table.insert(names, "Előző mentés: ez a kiegészítő")
  end
  if fileExists("saves/bone/" .. boneId .. ".seal") then
    table.insert(datas, "bone/" .. boneId)
    table.insert(names, "Előző mentés: ez a csont")
  end
  if not editingWeapon and fileExists("saves/slot/" .. editingSlot .. ".seal") then
    table.insert(datas, "slot/" .. editingSlot)
    table.insert(names, "Előző mentés: ez a slot")
  end
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local pw = 400
  local ph = titleBarHeight + 6 + 36 * #datas
  editorPrompt = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
  steelexports.seal_gui:setWindowTitle(editorPrompt, "16/BebasNeueRegular.otf", "Elrendezések")
  steelexports.seal_gui:setWindowCloseButton(editorPrompt, "clothesshopCancelExit")
  for i = 1, #datas do
    local btn = steelexports.seal_gui:createGuiElement("button", 6, titleBarHeight + 6 + 36 * (i - 1), pw - 12, 30, editorPrompt)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3", false, true)
    steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey3", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("folder-open", 30))
    steelexports.seal_gui:setButtonText(btn, " " .. names[i])
    steelexports.seal_gui:setClickEvent(btn, "clothesshopLoadSavedFinal")
    editorLoaderButtons[btn] = datas[i]
  end
end)
function createEditorGui()
  deleteEditorGui()
  local y = math.floor(screenY * 0.8)
  local w = 604
  if editingWeapon then
    w = w - 32 - 6
  end
  editorGui = steelexports.seal_gui:createGuiElement("rectangle", screenX / 2 - w / 2, y, w, 64)
  steelexports.seal_gui:setGuiBackground(editorGui, "solid", "grey1")
  local x = 6
  y = 26
  local rect = steelexports.seal_gui:createGuiElement("rectangle", x, 6, 226, 20, editorGui)
  steelexports.seal_gui:setGuiHover(rect, "none")
  steelexports.seal_gui:setGuiHoverable(rect, true)
  steelexports.seal_gui:guiSetTooltip(rect, "Kurzor gyorsgomb: " .. steelexports.seal_gui:getColorCodeHex("blue") .. "ALT")
  local label = steelexports.seal_gui:createGuiElement("label", x, 0, 0, 26, editorGui)
  steelexports.seal_gui:setLabelAlignment(label, "left", "center")
  steelexports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
  steelexports.seal_gui:setLabelText(label, "Kurzor:")
  modeButtons.move = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(modeButtons.move, "gradient", {
    "green",
    "green-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(modeButtons.move, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(modeButtons.move, steelexports.seal_gui:getFaIconFilename("arrows", 32))
  steelexports.seal_gui:guiSetTooltip(modeButtons.move, "Mozgatás")
  steelexports.seal_gui:setClickEvent(modeButtons.move, "changeClothesshopEditorMode")
  x = x + 32 + 6
  modeButtons.rot = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(modeButtons.rot, "gradient", {
    "green",
    "green-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(modeButtons.rot, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(modeButtons.rot, steelexports.seal_gui:getFaIconFilename("sync", 32))
  steelexports.seal_gui:guiSetTooltip(modeButtons.rot, "Forgatás")
  steelexports.seal_gui:setClickEvent(modeButtons.rot, "changeClothesshopEditorMode")
  x = x + 32 + 6
  if not editingWeapon then
    modeButtons.scale = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
    steelexports.seal_gui:setGuiHover(modeButtons.scale, "gradient", {
      "green",
      "green-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(modeButtons.scale, "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(modeButtons.scale, steelexports.seal_gui:getFaIconFilename("expand-alt", 32))
    steelexports.seal_gui:guiSetTooltip(modeButtons.scale, "Méretezés")
    steelexports.seal_gui:setClickEvent(modeButtons.scale, "changeClothesshopEditorMode")
    x = x + 32 + 6
  end
  local icon = steelexports.seal_gui:createGuiElement("image", x, y, 13, 13, editorGui)
  steelexports.seal_gui:setImageFile(icon, steelexports.seal_gui:getFaIconFilename("expand-arrows-alt", 13, "solid"))
  local icon = steelexports.seal_gui:createGuiElement("image", x, y + 32 - 13, 13, 13, editorGui)
  steelexports.seal_gui:setImageFile(icon, steelexports.seal_gui:getFaIconFilename("lightbulb", 13, "solid"))
  x = x + 13 + 3
  local slider = steelexports.seal_gui:createGuiElement("slider", x, y, 96, 13, editorGui)
  steelexports.seal_gui:setSliderColor(slider, "grey3", "green")
  steelexports.seal_gui:setSliderSize(slider, 13)
  steelexports.seal_gui:guiSetTooltip(slider, "Kurzor méret")
  steelexports.seal_gui:setSliderChangeEvent(slider, "changeClothesshopEditorCursorSize")
  steelexports.seal_gui:setSliderValue(slider, (baseCursorSize - 0.1) / 0.24999999999999997)
  local slider = steelexports.seal_gui:createGuiElement("slider", x, y + 32 - 13, 96, 13, editorGui)
  steelexports.seal_gui:setSliderColor(slider, "grey3", "green")
  steelexports.seal_gui:setSliderSize(slider, 13)
  steelexports.seal_gui:guiSetTooltip(slider, "Kurzor átlátszóság")
  steelexports.seal_gui:setSliderChangeEvent(slider, "changeClothesshopEditorCursorAlpha")
  steelexports.seal_gui:setSliderValue(slider, (axisAlpha - 0.25) / 0.75)
  x = x + 96 + 6
  local border = steelexports.seal_gui:createGuiElement("hr", x, 6, 2, 52, editorGui)
  steelexports.seal_gui:setGuiHrColor(border, "grey3", "grey2")
  x = x + 6 + 2
  local rect = steelexports.seal_gui:createGuiElement("rectangle", x, 6, 146, 20, editorGui)
  steelexports.seal_gui:setGuiHover(rect, "none")
  steelexports.seal_gui:setGuiHoverable(rect, true)
  steelexports.seal_gui:guiSetTooltip(rect, "Mozgatás iránya gyorsgomb: " .. steelexports.seal_gui:getColorCodeHex("blue") .. "SPACE")
  local label = steelexports.seal_gui:createGuiElement("label", x, 0, 0, 26, editorGui)
  steelexports.seal_gui:setLabelAlignment(label, "left", "center")
  steelexports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
  steelexports.seal_gui:setLabelText(label, "Mozgatás iránya:")
  originButtons.object = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(originButtons.object, "gradient", {
    "blue",
    "blue-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(originButtons.object, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(originButtons.object, steelexports.seal_gui:getFaIconFilename("tshirt", 32))
  steelexports.seal_gui:guiSetTooltip(originButtons.object, "Kiegészítőhöz képest")
  steelexports.seal_gui:setClickEvent(originButtons.object, "changeClothesshopEditorOrigin")
  x = x + 32 + 6
  originButtons.bone = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(originButtons.bone, "gradient", {
    "blue",
    "blue-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(originButtons.bone, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(originButtons.bone, steelexports.seal_gui:getFaIconFilename("bone", 32))
  steelexports.seal_gui:guiSetTooltip(originButtons.bone, "Csonthoz képest")
  steelexports.seal_gui:setClickEvent(originButtons.bone, "changeClothesshopEditorOrigin")
  x = x + 32 + 6
  originButtons.char = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(originButtons.char, "gradient", {
    "blue",
    "blue-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(originButtons.char, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(originButtons.char, steelexports.seal_gui:getFaIconFilename("user", 32))
  steelexports.seal_gui:guiSetTooltip(originButtons.char, "Karakterhez képest")
  steelexports.seal_gui:setClickEvent(originButtons.char, "changeClothesshopEditorOrigin")
  x = x + 32 + 6
  originButtons.world = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(originButtons.world, "gradient", {
    "blue",
    "blue-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(originButtons.world, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(originButtons.world, steelexports.seal_gui:getFaIconFilename("globe-europe", 32))
  steelexports.seal_gui:guiSetTooltip(originButtons.world, "Világhoz képest")
  steelexports.seal_gui:setClickEvent(originButtons.world, "changeClothesshopEditorOrigin")
  x = x + 32 + 6
  local border = steelexports.seal_gui:createGuiElement("hr", x, 6, 2, 52, editorGui)
  steelexports.seal_gui:setGuiHrColor(border, "grey3", "grey2")
  x = x + 6 + 2
  local rect = steelexports.seal_gui:createGuiElement("rectangle", x, 6, 70, 20, editorGui)
  steelexports.seal_gui:setGuiHover(rect, "none")
  steelexports.seal_gui:setGuiHoverable(rect, true)
  steelexports.seal_gui:guiSetTooltip(rect, "Kamera gyorsgomb: " .. steelexports.seal_gui:getColorCodeHex("blue") .. "C")
  local label = steelexports.seal_gui:createGuiElement("label", x, 0, 0, 26, editorGui)
  steelexports.seal_gui:setLabelAlignment(label, "left", "center")
  steelexports.seal_gui:setLabelFont(label, "10/Ubuntu-R.ttf")
  steelexports.seal_gui:setLabelText(label, "Kamera:")
  cameraButtons.char = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(cameraButtons.char, "gradient", {
    "yellow",
    "yellow-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(cameraButtons.char, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(cameraButtons.char, steelexports.seal_gui:getFaIconFilename("user", 32))
  steelexports.seal_gui:guiSetTooltip(cameraButtons.char, "Karakterhez képest")
  steelexports.seal_gui:setClickEvent(cameraButtons.char, "changeClothesshopCameraOrigin")
  x = x + 32 + 6
  cameraButtons.object = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiHover(cameraButtons.object, "gradient", {
    "yellow",
    "yellow-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(cameraButtons.object, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(cameraButtons.object, steelexports.seal_gui:getFaIconFilename("tshirt", 32))
  steelexports.seal_gui:guiSetTooltip(cameraButtons.object, "Kiegészítőhöz képest")
  steelexports.seal_gui:setClickEvent(cameraButtons.object, "changeClothesshopCameraOrigin")
  x = x + 32 + 6
  local border = steelexports.seal_gui:createGuiElement("hr", x, 6, 2, 52, editorGui)
  steelexports.seal_gui:setGuiHrColor(border, "grey3", "grey2")
  x = x + 6 + 2
  saveButton = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiBackground(saveButton, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(saveButton, "gradient", {
    "green",
    "green-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(saveButton, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(saveButton, steelexports.seal_gui:getFaIconFilename("save", 32))
  steelexports.seal_gui:guiSetTooltip(saveButton, "Mentés")
  steelexports.seal_gui:setClickEvent(saveButton, "clothesshopSaveEditor")
  loaderIcon = steelexports.seal_gui:createGuiElement("image", 2, 2, 28, 28, saveButton)
  steelexports.seal_gui:setImageFile(loaderIcon, steelexports.seal_gui:getFaIconFilename("circle-notch", 28))
  steelexports.seal_gui:setImageSpinner(loaderIcon, true)
  steelexports.seal_gui:setGuiRenderDisabled(loaderIcon, true)
  x = x + 32 + 6
  local btn = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(btn, "gradient", {
    "blue",
    "blue-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("folder-open", 32))
  steelexports.seal_gui:guiSetTooltip(btn, "Elrendezés betöltése")
  steelexports.seal_gui:setClickEvent(btn, "clothesshopLoadSaved")
  x = x + 32 + 6
  local btn = steelexports.seal_gui:createGuiElement("button", x, y, 32, 32, editorGui)
  steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(btn, "gradient", {
    "red",
    "red-second"
  }, false, true)
  steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("times", 32))
  steelexports.seal_gui:guiSetTooltip(btn, "Kilépés")
  steelexports.seal_gui:setClickEvent(btn, "clothesshopExitEditor")
  refreshEditorGui()
end
function startEditorSaving()
  steelexports.seal_gui:setButtonIcon(saveButton, false)
  steelexports.seal_gui:setGuiHoverable(saveButton, false)
  steelexports.seal_gui:setGuiRenderDisabled(loaderIcon, false)
end
function stopEditorSaving()
  steelexports.seal_gui:setButtonIcon(saveButton, steelexports.seal_gui:getFaIconFilename("save", 32))
  steelexports.seal_gui:setGuiHoverable(saveButton, true)
  steelexports.seal_gui:setGuiRenderDisabled(loaderIcon, true)
  editingUnsaved = false
  refreshEditorGui()
end
function refreshEditorGui()
  local col = mtmp == currentMode and "green" or "orange"
  for mode, btn in pairs(modeButtons) do
    steelexports.seal_gui:setGuiBackground(btn, "solid", mtmp == mode and col or "grey3")
    steelexports.seal_gui:setGuiHoverable(btn, not movingAxis)
    steelexports.seal_gui:setButtonIconColor(btn, not movingAxis and "#ffffff" or "lightgrey")
  end
  for origin, btn in pairs(originButtons) do
    steelexports.seal_gui:setGuiBackground(btn, "solid", moveOrigin == origin and "blue" or "grey3")
    steelexports.seal_gui:setGuiHoverable(btn, mtmp == "move" and not movingAxis)
    steelexports.seal_gui:setButtonIconColor(btn, not (mtmp ~= "move" or movingAxis) and "#ffffff" or "lightgrey")
  end
  for cam, btn in pairs(cameraButtons) do
    steelexports.seal_gui:setGuiBackground(btn, "solid", cameraOrigin == cam and "yellow" or "grey3")
    steelexports.seal_gui:setGuiHoverable(btn, not movingAxis)
    steelexports.seal_gui:setButtonIconColor(btn, not movingAxis and "#ffffff" or "lightgrey")
  end
  steelexports.seal_gui:setButtonIconColor(saveButton, editingUnsaved and "orange" or "#ffffff")
end
function renderEditor()
  if editingWeapon and currentMode == "scale" then
    currentMode = "move"
  end
  setPedAnimationSpeed(localPlayer, "weapon_crouch", 0)
  setPedAnimationSpeed(localPlayer, "idle_stance", 0)
  local bm = getElementBoneMatrix(localPlayer, boneId)
  local om = getElementMatrix(editingObject)
  if not movingAxis then
    local rx, ry, rz = getElementRotation(localPlayer)
    local cm = cameraOrigin == "object" and om or bm
    if not isElementOnScreen(localPlayer) then
      cm = bm
    end
    local x, y, z = math.cos(camR1 + math.rad(rz)) * camDist, math.sin(camR1 + math.rad(rz)) * camDist, 0
    z = camDist * math.cos(math.pi / 2 - camR2)
    x = x * math.sin(math.pi / 2 - camR2)
    y = y * math.sin(math.pi / 2 - camR2)
    camX, camY, camZ = cm[4][1] + x, cm[4][2] + y, cm[4][3] + z
    setCameraMatrix(camX, camY, camZ, cm[4][1], cm[4][2], cm[4][3])
  end
  local shift = getKeyState("lshift")
  local ctrl = getKeyState("lctrl")
  local cx, cy = getCursorPosition()
  local mouse = false
  if cx then
    mouse = getKeyState("mouse1")
    cx = cx * screenX
    cy = cy * screenY
    if not mouse and movingAxis then
      steelexports.seal_gui:setCursorType("normal")
      hover = false
      movingAxis = false
      movingRot = false
      movingScale = false
      refreshEditorGui()
    end
  elseif movingAxis then
    steelexports.seal_gui:setCursorType("normal")
    hover = false
    movingAxis = false
    movingRot = false
    movingScale = false
    refreshEditorGui()
  end
  if currentMode == "rot" then
    shift = not shift
    if ctrl then
      shift = false
    end
  elseif currentMode == "scale" then
    ctrl = not ctrl
  end
  if movingAxis then
    if movingRot then
      shift = true
      ctrl = false
    elseif movingScale then
      shift = false
      ctrl = true
    else
      ctrl = false
      shift = false
    end
  end
  if editingWeapon then
    ctrl = false
  end
  local tmp = "move"
  if shift then
    tmp = "rot"
  elseif ctrl then
    tmp = "scale"
  end
  if tmp ~= mtmp then
    mtmp = tmp
    refreshEditorGui()
  end
  local ox, oy = getScreenFromWorldPosition(om[4][1], om[4][2], om[4][3], 128)
  local bx, by = getScreenFromWorldPosition(bm[4][1], bm[4][2], bm[4][3], 128)
  tmp = false
  if bx and ox and not editorPrompt then
    for a = 1, 3 do
      if not movingAxis or movingAxis == a then
        if shift then
          if 0 < om[a][3] then
            dxDrawLine3D(om[4][1], om[4][2], om[4][3], om[4][1] + om[a][1] * cursorSize, om[4][2] + om[a][2] * cursorSize, om[4][3] + om[a][3] * cursorSize, axisColors[a], lineWidth, true)
          else
            dxDrawLine3D(om[4][1], om[4][2], om[4][3], om[4][1] - om[a][1] * cursorSize, om[4][2] - om[a][2] * cursorSize, om[4][3] - om[a][3] * cursorSize, axisColors[a], lineWidth, true)
          end
          local lx, ly, lz, fx, fy, fz, vert, min, max, drawOther
          if movingAxis then
            vert = {}
            local v1, v2 = movingRot[9] % 360, (movingRot[9] + movingRot[8]) % 360
            min = math.min(v1, v2)
            max = math.max(v1, v2)
            drawOther = 180 < max - min
            local x, y, z = om[4][1] + movingRot[5] * cursorSize, om[4][2] + movingRot[6] * cursorSize, om[4][3] + movingRot[7] * cursorSize
            table.insert(vert, {
              x,
              y,
              z,
              axisColors[a + 3],
              (v1 - min + 180) % 360 - 180
            })
            dxDrawLine3D(x, y, z, om[4][1], om[4][2], om[4][3], axisColors[a], lineWidth, true)
          end
          local Ux, Uy, Uz, Vx, Vy, Vz = findPerpendicVecForCircl(om[a][1], om[a][2], om[a][3])
          for i = 1, 36 do
            local x, y, z = circleAround(Ux, Uy, Uz, Vx, Vy, Vz, cursorSize, math.cos(math.pi / 36 * 2 * i), math.sin(math.pi / 36 * 2 * i))
            x, y, z = om[4][1] + x, om[4][2] + y, om[4][3] + z
            if vert then
              local rd = 360 - i * 10
              local draw = min < rd and max > rd
              if drawOther then
                draw = not draw
              end
              if draw then
                table.insert(vert, {
                  x,
                  y,
                  z,
                  axisColors[a + 3],
                  (rd - min + 180) % 360 - 180
                })
              end
            end
            if lx then
              dxDrawLine3D(lx, ly, lz, x, y, z, axisColors[a], lineWidth, true)
            else
              fx, fy, fz = x, y, z
            end
            lx, ly, lz = x, y, z
          end
          dxDrawLine3D(lx, ly, lz, fx, fy, fz, axisColors[a], lineWidth, true)
          if cx and not tmp then
            local wx, wy, wz = getWorldFromScreenPosition(cx, cy, 1)
            local x, y, z = planePoint(camX, camY, camZ, wx - camX, wy - camY, wz - camZ, om[4][1], om[4][2], om[4][3], om[a][1], om[a][2], om[a][3])
            local x1, y1, d = getScreenFromWorldPosition(x, y, z, 128)
            if x1 then
              local vx, vy, vz = x - om[4][1], y - om[4][2], z - om[4][3]
              local len = math.sqrt(vx * vx + vy * vy + vz * vz)
              if math.abs(len - cursorSize) < lineWidth / 75 * 4 or movingAxis then
                vx = vx / len
                vy = vy / len
                vz = vz / len
                local x, y, z = om[4][1] + vx * cursorSize, om[4][2] + vy * cursorSize, om[4][3] + vz * cursorSize
                local x1, y1 = getScreenFromWorldPosition(x, y, z)
                if x1 then
                  tmp = a
                  if movingAxis then
                    local r = math.deg(math.acos(dot(vx, vy, vz, movingRot[5], movingRot[6], movingRot[7])))
                    local crx, cry, crz = cross(vx, vy, vz, movingRot[5], movingRot[6], movingRot[7])
                    if 0 > dot(om[a][1], om[a][2], om[a][3], crx, cry, crz) then
                      movingRot[8] = -r
                    else
                      movingRot[8] = r
                    end
                  elseif mouse then
                    steelexports.seal_gui:setCursorType("move")
                    movingAxis = a
                    editingUnsaved = true
                    refreshEditorGui()
                    local rx, ry, rz = reverseMatrix(bm, om[a][1], om[a][2], om[a][3])
                    movingRot = {
                      rx,
                      ry,
                      rz,
                      objQ,
                      vx,
                      vy,
                      vz,
                      0
                    }
                    local r = math.deg(math.acos(dot(vx, vy, vz, Ux, Uy, Uz)))
                    local crx, cry, crz = cross(vx, vy, vz, Ux, Uy, Uz)
                    if 0 > dot(om[a][1], om[a][2], om[a][3], crx, cry, crz) then
                      movingRot[9] = 360 - r
                    else
                      movingRot[9] = r
                    end
                  end
                  steelangStaticImageUsed[0] = true
                  if steelangStaticImageToc[0] then
                    processsteelangStaticImage[0]()
                  end
                  dxDrawImage(x1 - 11, y1 - 11, 22, 22, steelangStaticImage[0], 0, 0, 0, axisColors[a], true)
                end
                if vert then
                  local v2 = (movingRot[9] + movingRot[8]) % 360
                  table.insert(vert, {
                    x,
                    y,
                    z,
                    axisColors[a + 3],
                    (v2 - min + 180) % 360 - 180
                  })
                  table.sort(vert, sortVerts)
                  for i = 1, #vert do
                    vert[i][5] = nil
                  end
                  dxDrawLine3D(x, y, z, om[4][1], om[4][2], om[4][3], axisColors[a], lineWidth, true)
                  dxDrawPrimitive3D("trianglefan", true, {
                    om[4][1],
                    om[4][2],
                    om[4][3],
                    axisColors[a + 3]
                  }, unpack(vert))
                end
              end
            end
          end
        else
          local mm = om
          if moveOrigin == "world" then
            mm = worldMatrix
          elseif moveOrigin == "bone" then
            mm = bm
          elseif moveOrigin == "char" then
            mm = getElementMatrix(localPlayer)
          end
          local cs = cursorSize
          if ctrl then
            mm = om
            cs = cs * scale[a]
          end
          local x1, y1, z1, x2, y2, z2 = om[4][1] - mm[a][1] * cs, om[4][2] - mm[a][2] * cs, om[4][3] - mm[a][3] * cs, om[4][1] + mm[a][1] * cs, om[4][2] + mm[a][2] * cs, om[4][3] + mm[a][3] * cs
          dxDrawLine3D(x1, y1, z1, x2, y2, z2, axisColors[a], lineWidth, true)
          local x1, y1 = getScreenFromWorldPosition(x1, y1, z1, 128)
          local x2, y2 = getScreenFromWorldPosition(x2, y2, z2, 128)
          if x1 and x2 then
            local x, y = x1 - x2, y1 - y2
            local len = math.sqrt(x * x + y * y)
            if 44 <= len then
              local vx, vy = x1 - ox, y1 - oy
              local len = math.sqrt(vx * vx + vy * vy)
              local x1 = x1 + vx / len * 22 / 2
              local y1 = y1 + vy / len * 22 / 2
              local vx, vy = x2 - ox, y2 - oy
              local len = math.sqrt(vx * vx + vy * vy)
              local x2 = x2 + vx / len * 22 / 2
              local y2 = y2 + vy / len * 22 / 2
              steelangStaticImageUsed[0] = true
              if steelangStaticImageToc[0] then
                processsteelangStaticImage[0]()
              end
              dxDrawImage(x1 - 11, y1 - 11, 22, 22, steelangStaticImage[0], 0, 0, 0, axisColors[a], true)
              steelangStaticImageUsed[0] = true
              if steelangStaticImageToc[0] then
                processsteelangStaticImage[0]()
              end
              dxDrawImage(x2 - 11, y2 - 11, 22, 22, steelangStaticImage[0], 0, 0, 0, axisColors[a], true)
              local icon = ctrl and scaleIcon or moveIcon
              dxDrawImage(x1 - 11, y1 - 11, 22, 22, ":seal_gui/" .. icon .. faTicks[icon], 0, 0, 0, nil, true)
              dxDrawImage(x2 - 11, y2 - 11, 22, 22, ":seal_gui/" .. icon .. faTicks[icon], 0, 0, 0, nil, true)
              if movingAxis then
                local wx, wy, wz = getWorldFromScreenPosition(cx, cy, 1)
                local x, y, z = planePoint(camX, camY, camZ, wx - camX, wy - camY, wz - camZ, movingPosition[9], movingPosition[10], movingPosition[11], movingPosition[12], movingPosition[13], movingPosition[14])
                local wx = x - movingPosition[9]
                local wy = y - movingPosition[10]
                local wz = z - movingPosition[11]
                local dp = dot(wx, wy, wz, movingPosition[15], movingPosition[16], movingPosition[17])
                movingPosition[7] = dp - movingPosition[8]
              elseif not tmp and cx and (cx >= x1 - 11 and cy >= y1 - 11 and cx <= x1 + 11 and cy <= y1 + 11 or cx >= x2 - 11 and cy >= y2 - 11 and cx <= x2 + 11 and cy <= y2 + 11) then
                tmp = a
                if mouse then
                  steelexports.seal_gui:setCursorType("move")
                  movingAxis = a
                  movingScale = ctrl
                  editingUnsaved = true
                  refreshEditorGui()
                  local x1, y1 = cx, cy
                  if x1 > screenX / 2 then
                    x1 = x1 - screenX / 4
                  else
                    x1 = x1 + screenX / 4
                  end
                  local ux, uy, uz = getWorldFromScreenPosition(x1, y1, 1)
                  local wx, wy, wz = getWorldFromScreenPosition(cx, cy, 1)
                  ux, uy, uz = ux - wx, uy - wy, uz - wz
                  ux, uy, uz = cross(mm[a][1], mm[a][2], mm[a][3], ux, uy, uz)
                  local x, y, z = planePoint(camX, camY, camZ, wx - camX, wy - camY, wz - camZ, om[4][1], om[4][2], om[4][3], ux, uy, uz)
                  local wx = x - om[4][1]
                  local wy = y - om[4][2]
                  local wz = z - om[4][3]
                  local dp = dot(wx, wy, wz, mm[a][1], mm[a][2], mm[a][3])
                  local x, y, z = reverseMatrix(bm, mm[a][1], mm[a][2], mm[a][3])
                  local ds = movingScale and scale or coords
                  movingPosition = {
                    ds[1],
                    ds[2],
                    ds[3],
                    x,
                    y,
                    z,
                    0,
                    dp,
                    om[4][1],
                    om[4][2],
                    om[4][3],
                    ux,
                    uy,
                    uz,
                    mm[a][1],
                    mm[a][2],
                    mm[a][3]
                  }
                end
              end
            end
          end
        end
      end
    end
  end
  if tmp ~= hover and not movingAxis then
    hover = tmp
    steelexports.seal_gui:setCursorType(hover and "link" or "normal")
  elseif getKeyState("mouse2") and cx and not movingAxis then
    if camMoveX then
      local d = (screenX + screenY) / 2
      local dx = (cx - camMoveX) / d
      local dy = (cy - camMoveY) / d
      camR1 = (camR1 - dx * math.pi) % (math.pi * 2)
      camR2 = camR2 + dy * math.pi
      camR2 = math.max(camR2, -math.pi / 4)
      camR2 = math.min(camR2, math.pi / 2.1)
    end
    camMoveX = cx
    camMoveY = cy
  elseif camMoveX then
    camMoveX = false
    camMoveY = false
  end
  if movingAxis then
    if movingRot then
      local q = fromRotation(movingRot[1], movingRot[2], movingRot[3], movingRot[8])
      q = qNorm(qMul(movingRot[4], q))
      if qCheck(q) then
        objQ = q
        steelexports.pattach:setRotationQuaternion(editingObject, objQ)
      end
    elseif movingScale then
      scale[movingAxis] = math.max(0.25, math.min(2, movingPosition[movingAxis] + movingPosition[7] / cursorSize * (0 > movingPosition[8] and -1 or 1)))
      setObjectScale(editingObject, scale[1], scale[2], scale[3])
    else
      for i = 1, 3 do
        coords[i] = math.max(-0.75, math.min(0.75, movingPosition[i] + movingPosition[7] * movingPosition[3 + i]))
      end
      steelexports.pattach:setPositionOffset(editingObject, -coords[3], coords[2], coords[1])
    end
  end
end
function deleteEditor()
  editingModel = false
  if editingSlot or editingWeapon then
    removeEventHandler("onClientRender", getRootElement(), renderEditor)
    removeEventHandler("onClientKey", getRootElement(), clothesshopEditorKey)
  end
  if editingSlot then
    if streamedClothes[localPlayer][editingSlot] then
      setElementAlpha(streamedClothes[localPlayer][editingSlot], 255)
    end
    editingSlot = false
    selectedArmorId = false
  end
  if editingWeapon then
    if streamedWeapons[localPlayer][editingWeapon] then
      setElementAlpha(streamedWeapons[localPlayer][editingWeapon], 255)
    end
    editingWeapon = false
  end
  if isElement(editingObject) then
    destroyElement(editingObject)
  end
  editingObject = false
  deleteEditorGui()
  showCursor(false)
  setCameraTarget(localPlayer)
  steelexports.seal_controls:toggleControl("all", true)
  steelexports.seal_gui:setCursorType("normal")
end
function createWeaponEditor(item, bone)
  if not isElement(editingObject) and playerWeaponCoords[localPlayer][item] then
    deleteClothesList()
    if not editingSlot and not editingWeapon then
      addEventHandler("onClientRender", getRootElement(), renderEditor)
      addEventHandler("onClientKey", getRootElement(), clothesshopEditorKey)
    end
    editingWeapon = item
    editingSlot = false
    if streamedWeapons[localPlayer][item] then
      setElementAlpha(streamedWeapons[localPlayer][item], 0)
    end
    createEditorGui()
    showCursor(true)
    local x, y, z = getElementPosition(localPlayer)
    editingModel = weaponItemData[item][3]
    editingObject = createObject(weaponItemData[item][1], x, y, z)
    setElementCollisionsEnabled(editingObject, false)
    if isElement(selfWeaponShader[item]) then
      engineApplyShaderToWorldTexture(selfWeaponShader[item], selfWeaponTex[item], editingObject)
    end
    if bone then
      boneId = bone
    else
      boneId = playerWeaponCoords[localPlayer][item][1]
    end
    if tonumber(weaponItemData[item][2]) then
      boneId = weaponItemData[item][2]
    elseif not weaponItemData[item][2][boneId] then
      for k in pairs(weaponItemData[item][2]) do
        boneId = k
        break
      end
    end
    steelexports.pattach:attach(editingObject, localPlayer, boneId, 0, 0, 0, 0, 0, 0)
    if not bone then
      coords = {
        playerWeaponCoords[localPlayer][item][2],
        playerWeaponCoords[localPlayer][item][3],
        playerWeaponCoords[localPlayer][item][4]
      }
      objQ = playerWeaponCoords[localPlayer][item][5]
      scale = {
        1,
        1,
        1
      }
      steelexports.pattach:setPositionOffset(editingObject, -coords[3], coords[2], coords[1])
      steelexports.pattach:setRotationQuaternion(editingObject, objQ)
    else
      editingUnsaved = true
      coords = {
        0,
        0,
        0
      }
      objQ = {
        1,
        0,
        0,
        0
      }
      scale = {
        1,
        1,
        1
      }
      loadDataFromFile(editingModel .. "/" .. boneId)
    end
    hover = false
    movingAxis = false
    movingRot = false
    movingScale = false
    mtmp = false
    camMoveX = false
    camMoveY = false
    preEditingSlot = false
    refreshCursorSize()
    steelexports.seal_controls:toggleControl("all", false)
    steelexports.seal_gui:setCursorType("normal")
  end
end
function createEditor(slot, bone, keep)
  if not isElement(editingObject) then
    if not editingSlot and not editingWeapon then
      addEventHandler("onClientRender", getRootElement(), renderEditor)
      addEventHandler("onClientKey", getRootElement(), clothesshopEditorKey)
    end
    editingWeapon = false
    editingSlot = slot
    if streamedClothes[localPlayer][slot] then
      setElementAlpha(streamedClothes[localPlayer][slot], 0)
    end
    createEditorGui()
    showCursor(true)
    local x, y, z = getElementPosition(localPlayer)
    editingObject = createObject(clothesList[editingModel].model, x, y, z)
    setElementCollisionsEnabled(editingObject, false)
    if myClothData[slot] and not bone then
      boneId = myClothData[slot][2]
    else
      boneId = bone or 8
    end
    steelexports.pattach:attach(editingObject, localPlayer, boneId, 0, 0, 0, 0, 0, 0)
    if myClothData[slot] and (not bone or keep) then
      boneId = myClothData[slot][2]
      coords = {
        myClothData[slot][3],
        myClothData[slot][4],
        myClothData[slot][5]
      }
      objQ = myClothData[slot][6]
      scale = {
        myClothData[slot][7],
        myClothData[slot][8],
        myClothData[slot][9]
      }
      steelexports.pattach:setPositionOffset(editingObject, -coords[3], coords[2], coords[1])
      steelexports.pattach:setRotationQuaternion(editingObject, objQ)
      setObjectScale(editingObject, scale[1], scale[2], scale[3])
    else
      editingUnsaved = true
      coords = {
        0,
        0,
        0
      }
      objQ = {
        1,
        0,
        0,
        0
      }
      scale = {
        1,
        1,
        1
      }
      loadDataFromFile(editingModel .. "/" .. boneId)
    end
    hover = false
    movingAxis = false
    movingRot = false
    movingScale = false
    mtmp = false
    camMoveX = false
    camMoveY = false
    preEditingSlot = false
    refreshCursorSize()
    steelexports.seal_controls:toggleControl("all", true)
    steelexports.seal_gui:setCursorType("normal")
  end
end
function renderBoneSelector()
  local rx, ry, rz = getElementRotation(localPlayer)
  local cm = getElementMatrix(localPlayer)
  local x, y, z = math.cos(camR1 + math.rad(rz)) * camDist, math.sin(camR1 + math.rad(rz)) * camDist, 0
  z = camDist * math.cos(math.pi / 2 - camR2)
  x = x * math.sin(math.pi / 2 - camR2)
  y = y * math.sin(math.pi / 2 - camR2)
  camX, camY, camZ = cm[4][1] + x, cm[4][2] + y, cm[4][3] + z
  setCameraMatrix(camX, camY, camZ, cm[4][1], cm[4][2], cm[4][3])
  local cx, cy = getCursorPosition()
  if cx then
    cx = cx * screenX
    cy = cy * screenY
    if getKeyState("mouse2") then
      if camMoveX then
        local d = (screenX + screenY) / 2
        local dx = (cx - camMoveX) / d
        local dy = (cy - camMoveY) / d
        camR1 = (camR1 - dx * math.pi) % (math.pi * 2)
        camR2 = camR2 + dy * math.pi
        camR2 = math.max(camR2, -math.pi / 4)
        camR2 = math.min(camR2, math.pi / 2.1)
      end
      camMoveX = cx
      camMoveY = cy
    elseif camMoveX then
      camMoveX = false
      camMoveY = false
    end
  end
  local tmp = false
  for i = 1, #allowedBones do
    local bone = allowedBones[i]
    local allow = false
    if editingWeapon then
      if tonumber(weaponItemData[editingWeapon][2]) then
        allow = weaponItemData[editingWeapon][2] == bone
      elseif weaponItemData[editingWeapon][2] then
        allow = weaponItemData[editingWeapon][2][bone]
      end
    else
      allow = true
    end
    if allow then
      local x, y, z = getPedBonePosition(localPlayer, bone)
      local x, y = getScreenFromWorldPosition(x, y, z, 32)
      if x then
        steelangStaticImageUsed[0] = true
        if steelangStaticImageToc[0] then
          processsteelangStaticImage[0]()
        end
        dxDrawImage(x - 12, y - 12, 24, 24, steelangStaticImage[0], 0, 0, 0, grey)
        if cx and 12 > math.sqrt(math.pow(cx - x, 2) + math.pow(cy - y, 2)) then
          tmp = i
          dxDrawImage(x - 9, y - 9, 18, 18, ":seal_gui/" .. boneIcon .. faTicks[boneIcon], 0, 0, 0, green)
        else
          dxDrawImage(x - 9, y - 9, 18, 18, ":seal_gui/" .. boneIcon .. faTicks[boneIcon], 0, 0, 0, nil)
        end
      end
    end
  end
  if hover ~= tmp then
    hover = tmp
    steelexports.seal_gui:setCursorType(hover and "link" or "normal")
  end
end
function clickBoneSelector(btn, state)
  if state == "down" and btn == "left" and hover then
    removeEventHandler("onClientRender", getRootElement(), renderBoneSelector)
    removeEventHandler("onClientClick", getRootElement(), clickBoneSelector)
    if editingWeapon then
      local item = editingWeapon
      editingWeapon = false
      createWeaponEditor(item, allowedBones[hover])
    else
      createEditor(preEditingSlot, allowedBones[hover])
    end
  end
end
function startEditorFlow(model, force)
  if isPedInVehicle(localPlayer) then
    steelexports.seal_gui:showInfobox("e", "Előbb szállj ki az autóból!")
  elseif isElementInWater(localPlayer) then
    steelexports.seal_gui:showInfobox("e", "Előbb szállj ki a vízből!")
  elseif clothesList[model] then
    deleteClothesList()
    camR1 = math.pi / 2
    camR2 = 0
    editingModel = model
    if streamedClothes[localPlayer][preEditingSlot] then
      setElementAlpha(streamedClothes[localPlayer][preEditingSlot], 0)
    end
    if clothesList[model].cat == "armor" then
      if myClothData[preEditingSlot] then
        selectedArmorId = myClothData[preEditingSlot][10]
      end
      camDist = 2
      createEditor(-1, 3, true)
    elseif myClothData[preEditingSlot] and not force then
      camDist = 2
      createEditor(preEditingSlot)
    else
      editingUnsaved = true
      hover = false
      steelexports.seal_controls:toggleControl("all", false)
      camDist = 2.5
      showCursor(true)
      addEventHandler("onClientRender", getRootElement(), renderBoneSelector)
      addEventHandler("onClientClick", getRootElement(), clickBoneSelector, true, "low-999999")
    end
  end
end
weaponEditButtons = false
weaponBoneButtons = false
weaponViewButtons = false
weaponLoaderIcon = false
function deleteClothesList(skipPrev)
  local x, y = deleteWeaponWindow()
  if not skipPrev then
    deletePrevShader()
  end
  if editorPrompt then
    steelexports.seal_gui:deleteGuiElement(editorPrompt)
  end
  editorPrompt = false
  if clothesListWindow then
    x, y = steelexports.seal_gui:getGuiPosition(clothesListWindow)
    steelexports.seal_gui:deleteGuiElement(clothesListWindow)
  end
  clothesListWindow = false
  if presetEditorWindow then
    steelexports.seal_gui:deleteGuiElement(presetEditorWindow)
  end
  presetEditorWindow = false
  if clothesSelectorWindow then
    steelexports.seal_gui:deleteGuiElement(clothesSelectorWindow)
  end
  clothesSelectorWindow = false
  if clothesScrollHandled then
    removeEventHandler("onClientKey", getRootElement(), clothesScrollHandler)
  end
  selectorScrollBar = false
  clothesSelectorData = false
  countedClothes = false
  slotButtons = false
  presetButtons = false
  selectorCategoryButtons = false
  selectorElements = false
  previewButtons = false
  savingPreset = false
  selectedPreset = false
  weaponEditButtons = false
  weaponBoneButtons = false
  weaponViewButtons = false
  weaponLoaderIcon = false
  return x, y
end
addEvent("closeClothesList", false)
addEventHandler("closeClothesList", getRootElement(), function()
  clothesShopMode = false
  preEditingSlot = false
  selectedArmorId = false
  bindState = false
  deleteClothesList()
end)
addEvent("createClothesList", false)
addEventHandler("createClothesList", getRootElement(), function()
  createClothesList()
end)
addEvent("gotNewClothesshopSlots", true)
addEventHandler("gotNewClothesshopSlots", getRootElement(), function(slot)
  freeSlots = slot
  if clothesSelectorWindow or clothesListWindow then
    createClothesList()
  end
end)
addEvent("finalBuyEditorSlot", false)
addEventHandler("finalBuyEditorSlot", getRootElement(), function()
  deleteClothesList()
  local pw = 150
  local ph = 150
  clothesSelectorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
  steelexports.seal_gui:setWindowTitle(clothesSelectorWindow, "16/BebasNeueRegular.otf", "Vásárlás")
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local loadingIcon = steelexports.seal_gui:createGuiElement("image", pw / 2 - 24, titleBarHeight + (ph - titleBarHeight) / 2 - 24, 48, 48, clothesSelectorWindow)
  steelexports.seal_gui:setImageFile(loadingIcon, steelexports.seal_gui:getFaIconFilename("circle-notch", 48))
  steelexports.seal_gui:setImageSpinner(loadingIcon, true)
  triggerLatentServerEvent("buyClothesShopSlot", localPlayer)
end)
addEvent("selectClothesEditorSlot", false)
addEventHandler("selectClothesEditorSlot", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for slot, btn in pairs(slotButtons) do
    if el == btn then
      if slot == freeSlots + 1 then
        deleteClothesList()
        local pw = 325
        local ph = 150
        clothesSelectorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
        steelexports.seal_gui:setWindowTitle(clothesSelectorWindow, "16/BebasNeueRegular.otf", "Vásárlás")
        local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
        local label = steelexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight - 30 - 6 - 6, clothesSelectorWindow)
        steelexports.seal_gui:setLabelAlignment(label, "center", "center")
        steelexports.seal_gui:setLabelText(label, "Biztosan szeretnéd megvásárolni a slotot?\n\nÁr: [color=blue]" .. steelexports.seal_gui:thousandsStepper(getSlotPrice(freeSlots + 1)) .. " PP")
        steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        local bw = (pw - 18) / 2
        local btn = steelexports.seal_gui:createGuiElement("button", 6, ph - 30 - 6, bw, 30, clothesSelectorWindow)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonText(btn, "Igen")
        steelexports.seal_gui:setClickEvent(btn, "finalBuyEditorSlot")
        local btn = steelexports.seal_gui:createGuiElement("button", pw - bw - 6, ph - 30 - 6, bw, 30, clothesSelectorWindow)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "red",
          "red-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonText(btn, "Nem")
        steelexports.seal_gui:setClickEvent(btn, "createClothesList")
      else
        clothesShopMode = false
        preEditingSlot = slot
        createClothesSelector()
      end
      return
    end
  end
end)
addEvent("editClothesShopSlot", false)
addEventHandler("editClothesShopSlot", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  el = steelexports.seal_gui:getGuiParent(el)
  for slot, btn in pairs(slotButtons) do
    if el == btn then
      if myClothData[slot] then
        preEditingSlot = slot
        startEditorFlow(myClothData[slot][1])
      end
      return
    end
  end
end)
addEvent("newBoneClothesShopSlot", false)
addEventHandler("newBoneClothesShopSlot", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  el = steelexports.seal_gui:getGuiParent(el)
  for slot, btn in pairs(slotButtons) do
    if el == btn then
      if myClothData[slot] then
        preEditingSlot = slot
        startEditorFlow(myClothData[slot][1], true)
      end
      return
    end
  end
end)
addEvent("deleteClothesShopSlot", false)
addEventHandler("deleteClothesShopSlot", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  el = steelexports.seal_gui:getGuiParent(el)
  for slot, btn in pairs(slotButtons) do
    if el == btn then
      if myClothData[slot] then
        refreshPlayerCloth(localPlayer, slot)
        triggerLatentServerEvent("refreshPlayerCloth", localPlayer, slot)
        createClothesList()
      end
      return
    end
  end
end)
local clothesScroll = 0
local selectedClothCategory = "Összes"
addEvent("selectClothesSelectorCategory", false)
addEventHandler("selectClothesSelectorCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectorCategoryButtons[el] then
    clothesScroll = 0
    selectedClothCategory = selectorCategoryButtons[el]
    refreshClothSelectorCategory()
    refreshClothSelector()
  end
end)
addEvent("backToClothesShopPanel", true)
addEventHandler("backToClothesShopPanel", getRootElement(), function()
  createClothesSelector()
end)
addEvent("finalBuyClothesShop", false)
addEventHandler("finalBuyClothesShop", getRootElement(), function()
  if selectedShopModel then
    deleteClothesList()
    local pw = 150
    local ph = 150
    clothesSelectorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
    steelexports.seal_gui:setWindowTitle(clothesSelectorWindow, "16/BebasNeueRegular.otf", "Vásárlás")
    local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
    local loadingIcon = steelexports.seal_gui:createGuiElement("image", pw / 2 - 24, titleBarHeight + (ph - titleBarHeight) / 2 - 24, 48, 48, clothesSelectorWindow)
    steelexports.seal_gui:setImageFile(loadingIcon, steelexports.seal_gui:getFaIconFilename("circle-notch", 48))
    steelexports.seal_gui:setImageSpinner(loadingIcon, true)
    triggerLatentServerEvent("finalBuyClothesShop", localPlayer, selectedShopModel)
    selectedShopModel = false
  end
end)
addEvent("selectClothesSelectorToBuy", false)
addEventHandler("selectClothesSelectorToBuy", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  selectedShopModel = false
  for i = 1, 12 do
    if clothesSelectorData[i + clothesScroll] and selectorElements[i][5] == el then
      selectedShopModel = clothesSelectorData[i + clothesScroll]
      break
    end
  end
  if selectedShopModel then
    deleteClothesList()
    local pw = 300
    local ph = 150
    clothesSelectorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
    steelexports.seal_gui:setWindowTitle(clothesSelectorWindow, "16/BebasNeueRegular.otf", "Vásárlás")
    local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
    local label = steelexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight - 30 - 6 - 6, clothesSelectorWindow)
    steelexports.seal_gui:setLabelAlignment(label, "center", "center")
    local pt = ""
    if clothesList[selectedShopModel].price then
      pt = "[color=green]" .. steelexports.seal_gui:thousandsStepper(clothesList[selectedShopModel].price) .. " $"
    elseif clothesList[selectedShopModel].ppPrice then
      pt = "[color=blue]" .. steelexports.seal_gui:thousandsStepper(clothesList[selectedShopModel].ppPrice) .. " PP"
    else
      pt = "[color=green]ingyenes"
    end
    steelexports.seal_gui:setLabelText(label, "Biztosan szeretnéd megvásárolni?\n[color=blue]" .. clothesList[selectedShopModel].name .. "\n" .. pt)
    steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    local bw = (pw - 18) / 2
    local btn = steelexports.seal_gui:createGuiElement("button", 6, ph - 30 - 6, bw, 30, clothesSelectorWindow)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "green",
      "green-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonText(btn, "Igen")
    steelexports.seal_gui:setClickEvent(btn, "finalBuyClothesShop")
    local btn = steelexports.seal_gui:createGuiElement("button", pw - bw - 6, ph - 30 - 6, bw, 30, clothesSelectorWindow)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "red",
      "red-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonText(btn, "Nem")
    steelexports.seal_gui:setClickEvent(btn, "backToClothesShopPanel")
  end
end)
addEvent("selectClothesSelectorCloth", false)
addEventHandler("selectClothesSelectorCloth", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if preEditingSlot then
    for i = 1, 12 do
      if clothesSelectorData[i + clothesScroll] and selectorElements[i][5] == el then
        if preEditingSlot == -1 then
          selectedArmorId = loadedArmorList[i + clothesScroll]
        end
        startEditorFlow(clothesSelectorData[i + clothesScroll])
        return
      end
    end
  end
end)
addEvent("finalDeleteClothesArmor", false)
addEventHandler("finalDeleteClothesArmor", getRootElement(), function()
  if selectedArmorId then
    loadedArmor[selectedArmorId] = nil
    triggerServerEvent("finalDeleteClothesArmor", localPlayer, selectedArmorId)
    loadedArmorList = {}
    for dbID in pairs(loadedArmor) do
      table.insert(loadedArmorList, dbID)
    end
    selectedArmorId = false
    createClothesSelector()
  end
end)
addEvent("deleteClothesArmor", false)
addEventHandler("deleteClothesArmor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if preEditingSlot then
    for i = 1, 12 do
      if clothesSelectorData[i + clothesScroll] and selectorElements[i][12] == el then
        deleteClothesList()
        selectedArmorId = loadedArmorList[i + clothesScroll]
        local pw = 300
        local ph = 150
        editorPrompt = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
        steelexports.seal_gui:setWindowTitle(editorPrompt, "16/BebasNeueRegular.otf", "Mellény")
        local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
        local label = steelexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight - 30 - 6 - 6, editorPrompt)
        steelexports.seal_gui:setLabelAlignment(label, "center", "center")
        steelexports.seal_gui:setLabelText(label, "Biztosan szeretnél kidobni?\n\nA mellény örökre elvész!")
        steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        local bw = (pw - 18) / 2
        local btn = steelexports.seal_gui:createGuiElement("button", 6, ph - 30 - 6, bw, 30, editorPrompt)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonText(btn, "Igen")
        steelexports.seal_gui:setClickEvent(btn, "finalDeleteClothesArmor")
        local btn = steelexports.seal_gui:createGuiElement("button", pw - bw - 6, ph - 30 - 6, bw, 30, editorPrompt)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "red",
          "red-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonText(btn, "Nem")
        steelexports.seal_gui:setClickEvent(btn, "backToClothesShopPanel")
        return
      end
    end
  end
end)
addEvent("clothesPreviewHover", true)
addEventHandler("clothesPreviewHover", getRootElement(), function(el, state)
  if state and previewButtons[el] and clothesSelectorData[previewButtons[el] + clothesScroll] then
    createPrevObject(clothesList[clothesSelectorData[previewButtons[el] + clothesScroll]].model)
  else
    deletePrevObject()
  end
end)
function checkGroup(model)
  if clothesList[model].group then
    if type(clothesList[model].group) == "table" then
      for i = 1, #clothesList[model].group do
        if steelexports.seal_groups:isPlayerInGroup(localPlayer, clothesList[model].group[i]) then
          return true
        end
      end
      return false
    else
      return steelexports.seal_groups:isPlayerInGroup(localPlayer, clothesList[model].group)
    end
  end
  return true
end
function refreshClothSelectorCategory()
  clothesSelectorData = {}
  if clothesShopMode == "armor" then
    clothesSelectorData = {}
    for i = 1, #armorList do
      if checkGroup(armorList[i]) then
        table.insert(clothesSelectorData, armorList[i])
      end
    end
  elseif preEditingSlot == -1 then
    clothesSelectorData = {}
    for i = 1, #loadedArmorList do
      if checkGroup(sortedClothes[i]) then
        table.insert(clothesSelectorData, loadedArmor[loadedArmorList[i]][1])
      end
    end
  elseif selectedClothCategory == "Megvásárolt" then
    for i = 1, #sortedClothes do
      if boughtClothes[sortedClothes[i]] and boughtClothes[sortedClothes[i]] > 0 then
        table.insert(clothesSelectorData, sortedClothes[i])
      end
    end
  elseif selectedClothCategory == "Összes" then
    clothesSelectorData = {}
    for i = 1, #sortedClothes do
      if checkGroup(sortedClothes[i]) then
        table.insert(clothesSelectorData, sortedClothes[i])
      end
    end
  else
    for i = 1, #sortedClothes do
      if getCat(sortedClothes[i]) == selectedClothCategory and checkGroup(sortedClothes[i]) then
        table.insert(clothesSelectorData, sortedClothes[i])
      end
    end
  end
  countedClothes = {}
  for slot, dat in pairs(myClothData) do
    countedClothes[dat[1]] = (countedClothes[dat[1]] or 0) + 1
  end
  for btn, cat in pairs(selectorCategoryButtons) do
    if cat == selectedClothCategory then
      steelexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
      steelexports.seal_gui:setGuiHoverable(btn, false)
    else
      steelexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      steelexports.seal_gui:setGuiHoverable(btn, true)
    end
  end
  clothesScroll = math.min(clothesScroll, math.max(0, #clothesSelectorData - 12))
end
function refreshClothSelector()
  local armor = preEditingSlot == -1 or clothesShopMode == "armor"
  for i = 1, 12 do
    local cloth = clothesSelectorData[i + clothesScroll]
    if cloth then
      for j = 1, #selectorElements[i] do
        if selectorElements[i][j] then
          steelexports.seal_gui:setGuiRenderDisabled(selectorElements[i][j], false)
        end
      end
      local bought = boughtClothes[cloth] or 0
      local counted = countedClothes[cloth] or 0
      steelexports.seal_gui:setImageFile(selectorElements[i][1], steelexports.seal_gui:getFaIconFilename(getIcon(cloth), 24))
      steelexports.seal_gui:setLabelText(selectorElements[i][2], clothesList[cloth].name)
      if armor then
        for k = 1, 4 do
          steelexports.seal_gui:setImageFile(selectorElements[i][10 - k], steelexports.seal_gui:getFaIconFilename("shield", 24, k > clothesList[cloth].armorStrength and "regular" or "solid"))
          steelexports.seal_gui:setImageColor(selectorElements[i][10 - k], k > clothesList[cloth].armorStrength and "lightgrey" or "#ffffff")
          steelexports.seal_gui:guiSetTooltip(selectorElements[i][10 - k], "Erősség: " .. steelexports.seal_gui:getColorCodeHex("blue") .. clothesList[cloth].armorStrength .. "/4")
        end
        if clothesShopMode then
          if clothesList[cloth].price then
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " " .. steelexports.seal_gui:thousandsStepper(clothesList[cloth].price) .. " $")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "green")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "green",
              "green-second"
            }, false, true)
          elseif clothesList[cloth].ppPrice then
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " " .. steelexports.seal_gui:thousandsStepper(clothesList[cloth].ppPrice) .. " PP")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "blue")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "blue",
              "blue-second"
            }, false, true)
          else
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " Ingyenes")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "green")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "green",
              "green-second"
            }, false, true)
          end
        else
          steelexports.seal_gui:setGuiHoverable(selectorElements[i][1], true)
          steelexports.seal_gui:guiSetTooltip(selectorElements[i][1], "ID: " .. loadedArmorList[i + clothesScroll])
          steelexports.seal_gui:guiSetTooltip(selectorElements[i][10], "Állapot: " .. steelexports.seal_gui:getColorCodeHex("blue") .. math.floor(loadedArmor[loadedArmorList[i + clothesScroll]][2]) .. "%")
          steelexports.seal_gui:setGuiSize(selectorElements[i][11], 110 * loadedArmor[loadedArmorList[i + clothesScroll]][2] / 100, false)
        end
      else
        steelexports.seal_gui:setLabelText(selectorElements[i][3], counted .. "/" .. bought)
        steelexports.seal_gui:setLabelColor(selectorElements[i][3], 0 < bought and "#ffffff" or "midgrey")
        if clothesShopMode then
          if 5 <= bought then
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], false)
            steelexports.seal_gui:guiSetTooltip(selectorElements[i][5], "Maximum 5 darabot vásárolhatsz.")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " Max. elérve")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "orange")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "orange",
              "orange-second"
            }, false, true)
          elseif clothesList[cloth].price then
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:guiSetTooltip(selectorElements[i][5], "Megvásárlás")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " " .. steelexports.seal_gui:thousandsStepper(clothesList[cloth].price) .. " $")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "green")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "green",
              "green-second"
            }, false, true)
          elseif clothesList[cloth].ppPrice then
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:guiSetTooltip(selectorElements[i][5], "Megvásárlás")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " " .. steelexports.seal_gui:thousandsStepper(clothesList[cloth].ppPrice) .. " PP")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "blue")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "blue",
              "blue-second"
            }, false, true)
          else
            steelexports.seal_gui:setClickEvent(selectorElements[i][5], "selectClothesSelectorToBuy")
            steelexports.seal_gui:guiSetTooltip(selectorElements[i][5], "Megvásárlás")
            steelexports.seal_gui:setButtonText(selectorElements[i][5], " Ingyenes")
            steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", "green")
            steelexports.seal_gui:setGuiHover(selectorElements[i][5], "gradient", {
              "green",
              "green-second"
            }, false, true)
          end
        else
          steelexports.seal_gui:setImageColor(selectorElements[i][1], 0 < bought and "#ffffff" or "midgrey")
          steelexports.seal_gui:setLabelColor(selectorElements[i][2], 0 < bought and "#ffffff" or "midgrey")
          bought = 0 < bought and bought > counted
          steelexports.seal_gui:setGuiHoverable(selectorElements[i][5], bought)
          steelexports.seal_gui:setGuiBackground(selectorElements[i][5], "solid", bought and "green" or green2)
          steelexports.seal_gui:setButtonIconColor(selectorElements[i][5], bought and "#ffffff" or "lightgrey")
        end
      end
    else
      for j = 1, #selectorElements[i] do
        if selectorElements[i][j] then
          steelexports.seal_gui:setGuiRenderDisabled(selectorElements[i][j], true)
        end
      end
    end
  end
  local sh = 360 / math.max(1, #clothesSelectorData - 12 + 1)
  steelexports.seal_gui:setGuiSize(selectorScrollBar, false, sh)
  steelexports.seal_gui:setGuiPosition(selectorScrollBar, false, sh * clothesScroll)
end
function clothesScrollHandler(key)
  if prevD then
    if key == "mouse_wheel_up" then
      if prevD > 0.5 then
        prevD = prevD - 0.1
      end
    elseif key == "mouse_wheel_down" and prevD < 2.25 then
      prevD = prevD + 0.1
    end
  elseif key == "mouse_wheel_up" then
    if 0 < clothesScroll then
      clothesScroll = clothesScroll - 1
      refreshClothSelector()
    end
  elseif key == "mouse_wheel_down" and clothesScroll < #clothesSelectorData - 12 then
    clothesScroll = clothesScroll + 1
    refreshClothSelector()
  end
end
function createClothesSelector()
  deleteClothesList()
  createPrevShader()
  selectedShopModel = false
  addEventHandler("onClientKey", getRootElement(), clothesScrollHandler)
  clothesScrollHandled = true
  local armor = preEditingSlot == -1 or clothesShopMode == "armor"
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local w, h = 500 + (clothesShopMode and 100 or 0), titleBarHeight + 360 + 12
  clothesSelectorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  steelexports.seal_gui:setWindowTitle(clothesSelectorWindow, "16/BebasNeueRegular.otf", "Kiegészítők")
  if not clothesShopMode then
    steelexports.seal_gui:setWindowCloseButton(clothesSelectorWindow, "createClothesList")
  end
  local ch = (h - titleBarHeight) / (#categoryList + (clothesShopMode and 2 or 3))
  local y = titleBarHeight
  selectorCategoryButtons = {}
  selectorElements = {}
  previewButtons = {}
  local x = 0
  if not armor then
    local btn = steelexports.seal_gui:createGuiElement("button", 0, y, 160, ch, clothesSelectorWindow)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonText(btn, " Összes")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("globe", ch))
    steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorCategory")
    selectorCategoryButtons[btn] = "Összes"
    y = y + ch
    if not clothesShopMode then
      local btn = steelexports.seal_gui:createGuiElement("button", 0, y, 160, ch, clothesSelectorWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
      steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, " Megvásárolt")
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("user", ch))
      steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorCategory")
      selectorCategoryButtons[btn] = "Megvásárolt"
      y = y + ch
    end
    for i = 1, #categoryList do
      local btn = steelexports.seal_gui:createGuiElement("button", 0, y, 160, ch, clothesSelectorWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
      steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, " " .. categoryList[i])
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename(categories[categoryList[i]].icon, ch))
      steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorCategory")
      selectorCategoryButtons[btn] = categoryList[i]
      y = y + ch
    end
    local btn = steelexports.seal_gui:createGuiElement("button", 0, y, 160, ch, clothesSelectorWindow)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonText(btn, " Egyéb")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("ellipsis-h", ch))
    steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorCategory")
    selectorCategoryButtons[btn] = "Egyéb"
    x = x + 160
  end
  y = titleBarHeight + 6
  for i = 1, 12 do
    selectorElements[i] = {}
    selectorElements[i][1] = steelexports.seal_gui:createGuiElement("image", x + 6, y + 15 - 12, 24, 24, clothesSelectorWindow)
    selectorElements[i][2] = steelexports.seal_gui:createGuiElement("label", x + 6 + 24 + 3, y, 0, 30, clothesSelectorWindow)
    steelexports.seal_gui:setLabelAlignment(selectorElements[i][2], "left", "center")
    steelexports.seal_gui:setLabelFont(selectorElements[i][2], "11/Ubuntu-R.ttf")
    local bw = clothesShopMode and 134 or 30
    selectorElements[i][3] = steelexports.seal_gui:createGuiElement("label", 0, y, w - (30 + bw) - 2 - 12, 30, clothesSelectorWindow)
    steelexports.seal_gui:setLabelAlignment(selectorElements[i][3], "right", "center")
    steelexports.seal_gui:setLabelFont(selectorElements[i][3], "11/Ubuntu-R.ttf")
    if clothesShopMode then
      local btn = steelexports.seal_gui:createGuiElement("button", w - bw - 2 - 6, y + 15 - 12, 128, 24, clothesSelectorWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("shopping-cart", 24))
      steelexports.seal_gui:guiSetTooltip(btn, "Megvásárlás")
      steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorToBuy")
      selectorElements[i][5] = btn
    else
      local btn = steelexports.seal_gui:createGuiElement("button", w - bw - 2 - 6, y + 15 - 12, 24, 24, clothesSelectorWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("angle-right", 24))
      steelexports.seal_gui:guiSetTooltip(btn, "Kiválasztás")
      steelexports.seal_gui:setClickEvent(btn, "selectClothesSelectorCloth")
      selectorElements[i][5] = btn
      if armor then
        bw = bw + 6 + 24
        local btn = steelexports.seal_gui:createGuiElement("button", w - bw - 2 - 6, y + 15 - 12, 24, 24, clothesSelectorWindow)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "red",
          "red-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("trash-alt", 24))
        steelexports.seal_gui:guiSetTooltip(btn, "Kidobás")
        steelexports.seal_gui:setClickEvent(btn, "deleteClothesArmor")
        selectorElements[i][12] = btn
      end
    end
    local btn = steelexports.seal_gui:createGuiElement("button", w - (30 + bw) - 2 - 6, y + 15 - 12, 24, 24, clothesSelectorWindow)
    steelexports.seal_gui:setGuiBackground(btn, "solid", "blue")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "blue",
      "blue-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("eye", 24))
    steelexports.seal_gui:setHoverEvent(btn, "clothesPreviewHover")
    selectorElements[i][4] = btn
    previewButtons[btn] = i
    if armor then
      local sx = w - (30 + bw) - 2 - 12 - 24
      for k = 1, 4 do
        selectorElements[i][5 + k] = steelexports.seal_gui:createGuiElement("image", sx, y + 15 - 12, 24, 24, clothesSelectorWindow)
        steelexports.seal_gui:setGuiHoverable(selectorElements[i][5 + k], true)
        sx = sx - 20
      end
      if not clothesShopMode then
        sx = sx + 20 - 4 - 110
        selectorElements[i][10] = steelexports.seal_gui:createGuiElement("rectangle", sx, y + 15 - 5, 110, 10, clothesSelectorWindow)
        steelexports.seal_gui:setGuiBackground(selectorElements[i][10], "solid", "grey3")
        steelexports.seal_gui:setGuiHover(selectorElements[i][10], "none", false, false, true)
        steelexports.seal_gui:setGuiHoverable(selectorElements[i][10], true)
        selectorElements[i][11] = steelexports.seal_gui:createGuiElement("rectangle", 0, 0, 110, 10, selectorElements[i][10])
        steelexports.seal_gui:setGuiBackground(selectorElements[i][11], "solid", "blue")
      end
    end
    y = y + 30
    if i < 12 then
      local border = steelexports.seal_gui:createGuiElement("hr", x + 6, y - 1, w - 12 - x - 2 - 6, 2, clothesSelectorWindow)
    end
  end
  local rect = steelexports.seal_gui:createGuiElement("rectangle", w - 6 - 2, titleBarHeight + 6, 2, 360, clothesSelectorWindow)
  steelexports.seal_gui:setGuiBackground(rect, "solid", "grey3")
  selectorScrollBar = steelexports.seal_gui:createGuiElement("rectangle", 0, 0, 2, 360, rect)
  steelexports.seal_gui:setGuiBackground(selectorScrollBar, "solid", "midgrey")
  refreshClothSelectorCategory()
  refreshClothSelector()
end
local lastLoad = 0
function validateLoadCloth(slot, model, bone, x, y, z, q, sx, sy, sz)
  if not clothesList[model] then
    return false
  end
  if not allowedBonesEx[bone] then
    return false
  end
  if clothesList[model].cat == "armor" then
    return false
  end
  slot = tonumber(slot)
  if not slot or slot < 1 or slot > freeSlots then
    return false
  end
  if not boughtClothes[model] then
    return false
  end
  if clothesList[model].group and not checkGroup(model) then
    return false
  end
  local c = 0
  for s in pairs(myClothData) do
    if s ~= slot and myClothData[s][1] == model then
      c = c + 1
      if c >= boughtClothes[model] then
        return false
      end
    end
  end
  if sx < 0.15 or 2.1 < sx or sy < 0.15 or 2.1 < sy or sz < 0.15 or 2.1 < sz then
    return false
  end
  if x < -0.85 or 0.85 < x or y < -0.85 or 0.85 < y or z < -0.85 or 0.85 < z then
    return false
  end
  return true
end
addEvent("finalUseClothesPreset", false)
addEventHandler("finalUseClothesPreset", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectedPreset then
    if savingPreset then
      steelexports.seal_gui:showInfobox("s", "Jelenlegi ruházat sikeresen mentve erre: " .. selectedPreset .. ". mentett ruházat" .. (presetNames[selectedPreset] and " (" .. presetNames[selectedPreset] .. ")" or ""))
      if fileExists("fav/" .. selectedPreset .. ".seal") then
        fileDelete("fav/" .. selectedPreset .. ".seal")
      end
      local file = fileCreate("fav/" .. selectedPreset .. ".seal")
      if file then
        for slot = 1, freeSlots do
          if myClothData[slot] then
            fileWrite(file, myClothData[slot][1] .. "," .. myClothData[slot][2] .. "," .. myClothData[slot][3] .. "," .. myClothData[slot][4] .. "," .. myClothData[slot][5] .. "," .. table.concat(myClothData[slot][6], ",") .. "," .. myClothData[slot][7] .. "," .. myClothData[slot][8] .. "," .. myClothData[slot][9] .. "\n")
          else
            fileWrite(file, "-\n")
          end
        end
        fileClose(file)
      end
      createClothesList()
    else
      local id = selectedPreset
      createClothesList()
      steelexports.seal_gui:showInfobox("s", "Ruházat sikeresen betöltve: " .. id .. ". mentett ruházat" .. (presetNames[id] and " (" .. presetNames[id] .. ")" or ""))
      if fileExists("fav/" .. id .. ".seal") then
        local file = fileOpen("fav/" .. id .. ".seal")
        if file then
          lastLoad = getTickCount()
          local data = fileRead(file, fileGetSize(file))
          local dat = split(data, "\n")
          for slot = 1, freeSlots do
            local found = false
            if dat[slot] then
              local d = split(dat[slot], ",")
              if #d == 12 then
                for i = 2, 12 do
                  d[i] = tonumber(d[i]) or 0
                end
                local model, bone, x, y, z, qw, qx, qy, qz, sx, sy, sz = unpack(d)
                local q = {
                  qw,
                  qx,
                  qy,
                  qz
                }
                if validateLoadCloth(slot, model, bone, x, y, z, q, sx, sy, sz) then
                  found = true
                  triggerLatentServerEvent("refreshPlayerCloth", localPlayer, slot, model, bone, x, y, z, q, sx, sy, sz, false)
                end
              end
            end
            if not found and myClothData[slot] then
              triggerLatentServerEvent("refreshPlayerCloth", localPlayer, slot)
            end
          end
          data = nil
          collectgarbage("collect")
          fileClose(file)
        end
      end
    end
  end
end)
addEvent("useClothesPreset", false)
addEventHandler("useClothesPreset", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, 9 do
    if el == presetButtons[i] then
      if not savingPreset and not fileExists("fav/" .. i .. ".seal") then
        steelexports.seal_gui:showInfobox("e", "Nem található mentés!")
        return
      end
      if not savingPreset and getTickCount() - lastLoad < 15000 then
        steelexports.seal_gui:showInfobox("e", "Várj még a betöltéssel!")
        return
      end
      local tmp = savingPreset
      if editorPrompt then
        steelexports.seal_gui:deleteGuiElement(editorPrompt)
      end
      editorPrompt = nil
      savingPreset = tmp
      selectedPreset = i
      local pw = 320
      local ph = 130
      editorPrompt = steelexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      steelexports.seal_gui:setWindowTitle(editorPrompt, "16/BebasNeueRegular.otf", "Ruházat " .. (savingPreset and "mentés" or "betöltés"))
      local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
      local label = steelexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight - 30 - 6 - 6, editorPrompt)
      steelexports.seal_gui:setLabelAlignment(label, "center", "center")
      if savingPreset then
        steelexports.seal_gui:setLabelText(label, "Biztosan szeretnéd felülírni a mentést?\n" .. steelexports.seal_gui:getColorCodeHex("lightgrey") .. "(" .. selectedPreset .. ". mentés)")
      else
        steelexports.seal_gui:setLabelText(label, "Biztosan szeretnéd betölteni a mentést?\n" .. steelexports.seal_gui:getColorCodeHex("lightgrey") .. "(" .. selectedPreset .. ". mentés)")
      end
      steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      local bw = (pw - 18) / 2
      local btn = steelexports.seal_gui:createGuiElement("button", 6, ph - 30 - 6, bw, 30, editorPrompt)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, "Igen")
      steelexports.seal_gui:setClickEvent(btn, "finalUseClothesPreset")
      local btn = steelexports.seal_gui:createGuiElement("button", pw - bw - 6, ph - 30 - 6, bw, 30, editorPrompt)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonText(btn, "Nem")
      steelexports.seal_gui:setClickEvent(btn, "createClothesList")
      return
    end
  end
end)
addEvent("toggleClothesPresetSaver", false)
addEventHandler("toggleClothesPresetSaver", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  savingPreset = not savingPreset
  steelexports.seal_gui:setButtonIcon(el, steelexports.seal_gui:getFaIconFilename("save", 30, savingPreset and "solid" or "regular"))
  if savingPreset then
    steelexports.seal_gui:setGuiBackground(el, "solid", "blue")
    steelexports.seal_gui:setGuiHover(el, "gradient", {
      "blue",
      "blue-second"
    }, false, true)
    for i = 1, 9 do
      steelexports.seal_gui:guiSetTooltip(presetButtons[i], "Ruházat mentése: " .. i .. ".")
      steelexports.seal_gui:setButtonTextColor(presetButtons[i], "blue")
    end
  else
    steelexports.seal_gui:setGuiBackground(el, "solid", "grey3")
    steelexports.seal_gui:setGuiHover(el, "gradient", {"grey3", "grey2"}, false, true)
    for i = 1, 9 do
      steelexports.seal_gui:guiSetTooltip(presetButtons[i], i .. ". mentett ruházat" .. (presetNames[i] and "\n" .. presetNames[i] .. "" or ""))
      steelexports.seal_gui:setButtonTextColor(presetButtons[i], "#ffffff")
    end
  end
end)
local presetEditorInputs = {}
local presetEditorIcons = {}
addEvent("saveClothesshopPresetEditor", false)
addEventHandler("saveClothesshopPresetEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  for i = 1, 9 do
    presetNames[i] = steelexports.seal_gui:getInputValue(presetEditorInputs[i])
    if 1 > utf8.len(presetNames[i]) then
      presetNames[i] = nil
    end
    if fileExists("presetname_" .. i .. ".seal") then
      fileDelete("presetname_" .. i .. ".seal")
    end
    if presetNames[i] then
      local file = fileCreate("presetname_" .. i .. ".seal")
      fileWrite(file, tostring(presetNames[i]))
      fileClose(file)
    end
  end
  createClothesList()
end)
addEvent("setClothesshopPresetIcon", false)
addEventHandler("setClothesshopPresetIcon", getRootElement(), function(button, state, absoluteX, absoluteY, el, i)
  for j = 0, #presetIconList do
    if el == presetEditorIcons[i][j] then
      steelexports.seal_gui:setGuiHoverable(presetEditorIcons[i][j], false)
      steelexports.seal_gui:setGuiBackground(presetEditorIcons[i][j], "solid", "grey3")
      presetIcons[i] = 1 <= j and j or false
      if fileExists("preseticon_" .. i .. ".seal") then
        fileDelete("preseticon_" .. i .. ".seal")
      end
      if 0 < j then
        local file = fileCreate("preseticon_" .. i .. ".seal")
        fileWrite(file, tostring(j))
        fileClose(file)
      end
    else
      steelexports.seal_gui:setGuiHoverable(presetEditorIcons[i][j], true)
      steelexports.seal_gui:setGuiBackground(presetEditorIcons[i][j], "solid", "grey1")
    end
  end
end)
addEvent("openClothesshopPresetEditor", false)
addEventHandler("openClothesshopPresetEditor", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  deleteClothesList()
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local ih = 30
  local w, h = 700, titleBarHeight + (ih + 4) * 9 + 4
  presetEditorWindow = steelexports.seal_gui:createGuiElement("window", screenX / 2 - w / 2, screenY / 2 - h / 2, w, h)
  steelexports.seal_gui:setWindowTitle(presetEditorWindow, "16/BebasNeueRegular.otf", "Ruházatok")
  steelexports.seal_gui:setWindowCloseButton(presetEditorWindow, "saveClothesshopPresetEditor")
  for i = 1, 9 do
    local y = titleBarHeight + 4 + (ih + 4) * (i - 1)
    local iw = w - 4 - (ih + 4) * (#presetIconList + 1) - 4
    presetEditorInputs[i] = steelexports.seal_gui:createGuiElement("input", 4, y, iw, ih, presetEditorWindow)
    steelexports.seal_gui:setInputPlaceholder(presetEditorInputs[i], i .. ". ruházat neve")
    steelexports.seal_gui:setInputValue(presetEditorInputs[i], presetNames[i] or "")
    steelexports.seal_gui:setInputMaxLength(presetEditorInputs[i], 48)
    presetEditorIcons[i] = {}
    presetEditorIcons[i][0] = steelexports.seal_gui:createGuiElement("button", 4 + iw + 4, y, ih, ih, presetEditorWindow)
    steelexports.seal_gui:setGuiBackground(presetEditorIcons[i][0], "solid", "grey1")
    steelexports.seal_gui:setGuiHover(presetEditorIcons[i][0], "gradient", {"grey1", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(presetEditorIcons[i][0], "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonText(presetEditorIcons[i][0], i)
    steelexports.seal_gui:setClickEvent(presetEditorIcons[i][0], "setClothesshopPresetIcon")
    steelexports.seal_gui:setClickArgument(presetEditorIcons[i][0], i)
    for j = 1, #presetIconList do
      presetEditorIcons[i][j] = steelexports.seal_gui:createGuiElement("button", 4 + iw + 4 + (ih + 4) * j, y, ih, ih, presetEditorWindow)
      steelexports.seal_gui:setGuiBackground(presetEditorIcons[i][j], "solid", "grey1")
      steelexports.seal_gui:setGuiHover(presetEditorIcons[i][j], "gradient", {"grey1", "grey2"}, false, true)
      steelexports.seal_gui:setButtonFont(presetEditorIcons[i][j], "14/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(presetEditorIcons[i][j], steelexports.seal_gui:getFaIconFilename(presetIconList[j], 30))
      steelexports.seal_gui:setClickEvent(presetEditorIcons[i][j], "setClothesshopPresetIcon")
      steelexports.seal_gui:setClickArgument(presetEditorIcons[i][j], i)
    end
    local curr = presetIcons[i] or 0
    steelexports.seal_gui:setGuiHoverable(presetEditorIcons[i][curr], false)
    steelexports.seal_gui:setGuiBackground(presetEditorIcons[i][curr], "solid", "grey3")
  end
end)
function createClothesList()
  bindState = true
  local x, y
  if clothesListWindow then
    x, y = deleteClothesList()
  else
    deleteClothesList()
  end
  preEditingSlot = false
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local w, h = 400, titleBarHeight + 468 + 6 + 8
  clothesListWindow = steelexports.seal_gui:createGuiElement("window", x or screenX / 2 - w / 2, y or screenY / 2 - h / 2, w, h)
  steelexports.seal_gui:setWindowTitle(clothesListWindow, "16/BebasNeueRegular.otf", "Kiegészítők")
  steelexports.seal_gui:setWindowCloseButton(clothesListWindow, "closeClothesList")
  presetButtons = {}
  local y = titleBarHeight + 6
  local bw = (w - 6) / 11
  for i = 1, 9 do
    presetButtons[i] = steelexports.seal_gui:createGuiElement("button", 6 + (i - 1) * bw, y, bw - 6, 30, clothesListWindow)
    steelexports.seal_gui:setGuiBackground(presetButtons[i], "solid", "grey3")
    steelexports.seal_gui:setGuiHover(presetButtons[i], "gradient", {"grey3", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(presetButtons[i], "14/BebasNeueBold.otf")
    steelexports.seal_gui:guiSetTooltip(presetButtons[i], i .. ". mentett ruházat" .. (presetNames[i] and "\n" .. presetNames[i] .. "" or ""))
    steelexports.seal_gui:setClickEvent(presetButtons[i], "useClothesPreset")
    if presetIcons[i] then
      steelexports.seal_gui:setButtonIcon(presetButtons[i], steelexports.seal_gui:getFaIconFilename(presetIconList[presetIcons[i]], 30))
    else
      steelexports.seal_gui:setButtonText(presetButtons[i], i)
    end
  end
  local btn = steelexports.seal_gui:createGuiElement("button", 6 + 9 * bw, y, bw - 6, 30, clothesListWindow)
  steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey3", "grey2"}, false, true)
  steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("save", 30, "regular"))
  steelexports.seal_gui:setClickEvent(btn, "toggleClothesPresetSaver")
  steelexports.seal_gui:guiSetTooltip(btn, "Jelenlegi ruházatod mentése")
  local btn = steelexports.seal_gui:createGuiElement("button", 6 + 10 * bw, y, bw - 6, 30, clothesListWindow)
  steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey3", "grey2"}, false, true)
  steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("pen", 30))
  steelexports.seal_gui:setClickEvent(btn, "openClothesshopPresetEditor")
  steelexports.seal_gui:guiSetTooltip(btn, "Ruházatok elnevezése")
  y = y + 30 + 6
  slotButtons = {}
  for i = 1, 10 do
    if i <= freeSlots then
      if myClothData[i] then
        local bw = w - 12 - 108
        slotButtons[i] = steelexports.seal_gui:createGuiElement("button", 6, y, bw, 30, clothesListWindow)
        steelexports.seal_gui:setGuiBackground(slotButtons[i], "solid", "grey3")
        steelexports.seal_gui:setGuiHoverable(slotButtons[i], false)
        steelexports.seal_gui:setButtonFont(slotButtons[i], "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(slotButtons[i], steelexports.seal_gui:getFaIconFilename(getIcon(myClothData[i][1]), 30))
        steelexports.seal_gui:setButtonText(slotButtons[i], " " .. clothesList[myClothData[i][1]].name)
        local btn = steelexports.seal_gui:createGuiElement("button", bw + 6, 0, 30, 30, slotButtons[i])
        steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("pen", 30))
        steelexports.seal_gui:guiSetTooltip(btn, "Szerkesztés")
        steelexports.seal_gui:setClickEvent(btn, "editClothesShopSlot")
        local btn = steelexports.seal_gui:createGuiElement("button", bw + 6 + 30 + 6, 0, 30, 30, slotButtons[i])
        steelexports.seal_gui:setGuiBackground(btn, "solid", "blue")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "blue",
          "blue-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("bone", 30))
        steelexports.seal_gui:guiSetTooltip(btn, "Másik csont választása")
        steelexports.seal_gui:setClickEvent(btn, "newBoneClothesShopSlot")
        local btn = steelexports.seal_gui:createGuiElement("button", bw + 6 + 72, 0, 30, 30, slotButtons[i])
        steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "red",
          "red-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("trash-alt", 30))
        steelexports.seal_gui:guiSetTooltip(btn, "Levétel")
        steelexports.seal_gui:setClickEvent(btn, "deleteClothesShopSlot")
      else
        slotButtons[i] = steelexports.seal_gui:createGuiElement("button", 6, y, w - 12, 30, clothesListWindow)
        steelexports.seal_gui:setGuiBackground(slotButtons[i], "solid", "grey3")
        steelexports.seal_gui:setGuiHover(slotButtons[i], "gradient", {"grey3", "grey2"}, false, true)
        steelexports.seal_gui:setButtonFont(slotButtons[i], "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(slotButtons[i], steelexports.seal_gui:getFaIconFilename("empty-set", 30))
        steelexports.seal_gui:setButtonText(slotButtons[i], " Üres")
        steelexports.seal_gui:setClickEvent(slotButtons[i], "selectClothesEditorSlot")
      end
    elseif i == freeSlots + 1 then
      slotButtons[i] = steelexports.seal_gui:createGuiElement("button", 6, y, w - 12, 30, clothesListWindow)
      steelexports.seal_gui:setGuiBackground(slotButtons[i], "solid", "grey3", false, true)
      steelexports.seal_gui:setGuiHover(slotButtons[i], "gradient", {"grey3", "grey2"}, false, true)
      steelexports.seal_gui:setButtonFont(slotButtons[i], "14/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(slotButtons[i], steelexports.seal_gui:getFaIconFilename("gem", 30))
      steelexports.seal_gui:setButtonText(slotButtons[i], " Slot megvásárlása: " .. steelexports.seal_gui:thousandsStepper(getSlotPrice(i)) .. " PP")
      steelexports.seal_gui:setClickEvent(slotButtons[i], "selectClothesEditorSlot")
      steelexports.seal_gui:setButtonIconColor(slotButtons[i], "blue")
      steelexports.seal_gui:setButtonTextColor(slotButtons[i], "blue")
    else
      slotButtons[i] = steelexports.seal_gui:createGuiElement("button", 6, y, w - 12, 30, clothesListWindow)
      steelexports.seal_gui:setGuiBackground(slotButtons[i], "solid", "grey4")
      steelexports.seal_gui:setGuiHoverable(slotButtons[i], false)
      steelexports.seal_gui:setButtonFont(slotButtons[i], "14/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(slotButtons[i], steelexports.seal_gui:getFaIconFilename("lock-alt", 30))
      steelexports.seal_gui:setButtonText(slotButtons[i], " Zárolt slot (" .. steelexports.seal_gui:thousandsStepper(getSlotPrice(i)) .. " PP)")
      steelexports.seal_gui:setButtonIconColor(slotButtons[i], "lightgrey")
      steelexports.seal_gui:setButtonTextColor(slotButtons[i], "lightgrey")
    end
    y = y + 30 + 6
  end
  local border = steelexports.seal_gui:createGuiElement("hr", 6, y, w - 12, 2, clothesListWindow)
  y = y + 2 + 6
  if myClothData[-1] then
    local bw = w - 12 - 108
    slotButtons[-1] = steelexports.seal_gui:createGuiElement("button", 6, y, bw, 30, clothesListWindow)
    steelexports.seal_gui:setGuiBackground(slotButtons[-1], "solid", "grey3")
    steelexports.seal_gui:setGuiHoverable(slotButtons[-1], false)
    steelexports.seal_gui:setButtonFont(slotButtons[-1], "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(slotButtons[-1], steelexports.seal_gui:getFaIconFilename(getIcon(myClothData[-1][1]), 30))
    steelexports.seal_gui:setButtonText(slotButtons[-1], " " .. clothesList[myClothData[-1][1]].name)
    local btn = steelexports.seal_gui:createGuiElement("button", bw + 6, 0, 30, 30, slotButtons[-1])
    steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "green",
      "green-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("pen", 30))
    steelexports.seal_gui:guiSetTooltip(btn, "Szerkesztés")
    steelexports.seal_gui:setClickEvent(btn, "editClothesShopSlot")
    local btn = steelexports.seal_gui:createGuiElement("button", bw + 6 + 30 + 6, 0, 30, 30, slotButtons[-1])
    steelexports.seal_gui:setGuiBackground(btn, "solid", "blue")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "blue",
      "blue-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("bone", 30))
    steelexports.seal_gui:guiSetTooltip(btn, "Másik csont választása")
    steelexports.seal_gui:setClickEvent(btn, "newBoneClothesShopSlot")
    local btn = steelexports.seal_gui:createGuiElement("button", bw + 6 + 72, 0, 30, 30, slotButtons[-1])
    steelexports.seal_gui:setGuiBackground(btn, "solid", "red")
    steelexports.seal_gui:setGuiHover(btn, "gradient", {
      "red",
      "red-second"
    }, false, true)
    steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("trash-alt", 30))
    steelexports.seal_gui:guiSetTooltip(btn, "Levétel")
    steelexports.seal_gui:setClickEvent(btn, "deleteClothesShopSlot")
  else
    slotButtons[-1] = steelexports.seal_gui:createGuiElement("button", 6, y, w - 12, 30, clothesListWindow)
    steelexports.seal_gui:setGuiBackground(slotButtons[-1], "solid", "grey3")
    steelexports.seal_gui:setGuiHover(slotButtons[-1], "gradient", {"grey3", "grey2"}, false, true)
    steelexports.seal_gui:setButtonFont(slotButtons[-1], "14/BebasNeueBold.otf")
    steelexports.seal_gui:setButtonIcon(slotButtons[-1], steelexports.seal_gui:getFaIconFilename("shield-alt", 30))
    steelexports.seal_gui:setButtonText(slotButtons[-1], " Nincs rajtad mellény")
    steelexports.seal_gui:setClickEvent(slotButtons[-1], "selectClothesEditorSlot")
  end
  y = y + 30 + 6
  local btn = steelexports.seal_gui:createGuiElement("button", 6, y, w - 12, 30, clothesListWindow)
  steelexports.seal_gui:setGuiBackground(btn, "solid", "grey3")
  steelexports.seal_gui:setGuiHover(btn, "gradient", {"grey3", "grey2"}, false, true)
  steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  steelexports.seal_gui:setButtonText(btn, "Fegyverek")
  steelexports.seal_gui:setClickEvent(btn, "openWeaponClothesEditor")
end
weaponWindow = false
function deleteWeaponWindow()
  local x, y
  if weaponWindow then
    x, y = steelexports.seal_gui:getGuiPosition(weaponWindow)
    steelexports.seal_gui:deleteGuiElement(weaponWindow)
  end
  weaponWindow = false
  return x, y
end
addEvent("editClothesWeaponItem", false)
addEventHandler("editClothesWeaponItem", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if weaponEditButtons[el] then
    camR1 = math.pi / 2
    camR2 = 0
    camDist = 2
    createWeaponEditor(weaponEditButtons[el])
  elseif weaponBoneButtons[el] then
    editingWeapon = weaponBoneButtons[el]
    deleteClothesList()
    camR1 = math.pi / 2
    camR2 = 0
    editingUnsaved = true
    hover = false
    steelexports.seal_controls:toggleControl("all", false)
    camDist = 2.5
    showCursor(true)
    addEventHandler("onClientRender", getRootElement(), renderBoneSelector)
    addEventHandler("onClientClick", getRootElement(), clickBoneSelector, true, "low-999999")
  elseif weaponViewButtons[el] then
    local item = weaponViewButtons[el]
    for el, i in pairs(weaponEditButtons) do
      if i == item then
        steelexports.seal_gui:deleteGuiElement(el)
        weaponEditButtons[el] = nil
      end
    end
    for el, i in pairs(weaponBoneButtons) do
      if i == item then
        steelexports.seal_gui:deleteGuiElement(el)
        weaponBoneButtons[el] = nil
      end
    end
    for el, i in pairs(weaponViewButtons) do
      if i == item then
        steelexports.seal_gui:deleteGuiElement(el)
        weaponViewButtons[el] = nil
      end
    end
    for el, i in pairs(weaponLoaderIcon) do
      if i == item then
        steelexports.seal_gui:setGuiRenderDisabled(el, false)
      end
    end
    triggerLatentServerEvent("refreshPlayerWeaponHidden", localPlayer, item)
  end
end)
function openWeaponClothesEditor()
  local itemIds = steelexports.seal_weapons:getWeaponItemIds()
  local count = 0
  local weaponItems = {}
  local weaponPics = {}
  for itemId in pairs(itemIds) do
    if steelexports.seal_items:playerHasItem(itemId) and weaponItemData[itemId] then
      weaponItems[itemId] = steelexports.seal_items:getItemName(itemId)
      weaponPics[itemId] = ":seal_items/files/items/" .. itemId - 1 .. ".png"
      count = count + 1
    elseif streamedWeapons[localPlayer] and streamedWeapons[localPlayer][itemId] then
      local object = streamedWeapons[localPlayer][itemId]
      if isElement(object) then
        destroyElement(object)
      end
      streamedWeapons[localPlayer][itemId] = nil
    end
  end
  if count <= 0 then
    steelexports.seal_gui:showInfobox("e", "Nincs nálad fegyver!")
    return
  end
  local x, y
  if weaponWindow then
    x, y = deleteClothesList()
  else
    deleteClothesList()
  end
  local titleBarHeight = steelexports.seal_gui:getTitleBarHeight()
  local bw = 400
  local w, h = bw, titleBarHeight + 44 * count - 2
  local col = 1
  while h > screenY * 0.75 do
    col = col + 1
    w = w + bw
    h = titleBarHeight + 44 * math.ceil(count / col) - 2
  end
  weaponWindow = steelexports.seal_gui:createGuiElement("window", x or screenX / 2 - w / 2, y or screenY / 2 - h / 2, w, h)
  steelexports.seal_gui:setWindowTitle(weaponWindow, "16/BebasNeueRegular.otf", "Fegyverek")
  steelexports.seal_gui:setWindowCloseButton(weaponWindow, "createClothesList")
  local y = titleBarHeight
  local c2 = math.ceil(count / col)
  local c = 1
  local x = 0
  weaponEditButtons = {}
  weaponBoneButtons = {}
  weaponViewButtons = {}
  weaponLoaderIcon = {}
  for itemId in pairs(weaponItems) do
    y = y + 3
    local pic = steelexports.seal_gui:createGuiElement("image", x + 3, y, 36, 36, weaponWindow)
    steelexports.seal_gui:setImageFile(pic, weaponPics[itemId])--":seal_items/" .. weaponPics[itemId])
    local label = steelexports.seal_gui:createGuiElement("label", x + 3 + 36 + 3, y, 0, 36, weaponWindow)
    steelexports.seal_gui:setLabelAlignment(label, "left", "center")
    steelexports.seal_gui:setLabelText(label, weaponItems[itemId])
    steelexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    local bx = x + bw - 37
    if playerWeaponCoords[localPlayer] and playerWeaponCoords[localPlayer][itemId] then
      if weaponItemData[itemId][4] then
        local loaderIcon = steelexports.seal_gui:createGuiElement("image", bx, y + 18 - 16, 32, 32, weaponWindow)
        steelexports.seal_gui:setImageFile(loaderIcon, steelexports.seal_gui:getFaIconFilename("circle-notch", 32))
        steelexports.seal_gui:setImageSpinner(loaderIcon, true)
        steelexports.seal_gui:setGuiRenderDisabled(loaderIcon, true)
        weaponLoaderIcon[loaderIcon] = itemId
      end
      local btn = steelexports.seal_gui:createGuiElement("button", bx, y + 18 - 16, 32, 32, weaponWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("pen", 32))
      steelexports.seal_gui:guiSetTooltip(btn, "Szerkesztés")
      steelexports.seal_gui:setClickEvent(btn, "editClothesWeaponItem")
      weaponEditButtons[btn] = itemId
      bx = bx - 37
      if type(weaponItemData[itemId][2]) == "table" then
        local btn = steelexports.seal_gui:createGuiElement("button", bx, y + 18 - 16, 32, 32, weaponWindow)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "green")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("bone", 30))
        steelexports.seal_gui:guiSetTooltip(btn, "Másik csont választása")
        steelexports.seal_gui:setClickEvent(btn, "editClothesWeaponItem")
        weaponBoneButtons[btn] = itemId
        bx = bx - 37
      end
      if weaponItemData[itemId][4] then
        local btn = steelexports.seal_gui:createGuiElement("button", bx, y + 18 - 16, 32, 32, weaponWindow)
        steelexports.seal_gui:setGuiBackground(btn, "solid", "blue")
        steelexports.seal_gui:setGuiHover(btn, "gradient", {
          "blue",
          "blue-second"
        }, false, true)
        steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("eye", 32))
        steelexports.seal_gui:guiSetTooltip(btn, "Látható")
        steelexports.seal_gui:setClickEvent(btn, "editClothesWeaponItem")
        weaponViewButtons[btn] = itemId
        bx = bx - 37
      end
    elseif weaponItemData[itemId][4] then
      local btn = steelexports.seal_gui:createGuiElement("button", bx, y + 18 - 16, 32, 32, weaponWindow)
      steelexports.seal_gui:setGuiBackground(btn, "solid", "yellow")
      steelexports.seal_gui:setGuiHover(btn, "gradient", {
        "yellow",
        "yellow-second"
      }, false, true)
      steelexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
      steelexports.seal_gui:setButtonIcon(btn, steelexports.seal_gui:getFaIconFilename("eye-slash", 32))
      steelexports.seal_gui:guiSetTooltip(btn, "Nem látható")
      steelexports.seal_gui:setClickEvent(btn, "editClothesWeaponItem")
      weaponViewButtons[btn] = itemId
      local loaderIcon = steelexports.seal_gui:createGuiElement("image", bx, y + 18 - 16, 32, 32, weaponWindow)
      steelexports.seal_gui:setImageFile(loaderIcon, steelexports.seal_gui:getFaIconFilename("circle-notch", 32))
      steelexports.seal_gui:setImageSpinner(loaderIcon, true)
      steelexports.seal_gui:setGuiRenderDisabled(loaderIcon, true)
      weaponLoaderIcon[loaderIcon] = itemId
    end
    y = y + 36 + 3
    if c2 <= c then
      c = 0
      y = titleBarHeight
      x = x + bw
      col = col - 1
      if 0 < col then
        local border = steelexports.seal_gui:createGuiElement("hr", x - 1, y + 3, 2, h - titleBarHeight - 6, weaponWindow)
      end
    else
      local border = steelexports.seal_gui:createGuiElement("hr", x + 3, y, bw - 6, 2, weaponWindow)
      y = y + 2
    end
    c = c + 1
  end
end
addEvent("openWeaponClothesEditor", true)
addEventHandler("openWeaponClothesEditor", getRootElement(), openWeaponClothesEditor)
addCommandHandler("cuccaim", function()
  if getElementData(localPlayer, "loggedIn") then
    if not bindState then
      if not editingModel and not editingWeapon and not clothesShopMode then
        createClothesList()
      end
    else
      bindState = false
      clothesShopMode = false
      preEditingSlot = false
      selectedArmorId = false
      deleteClothesList()
    end
  end
end)
local cuccaimBind = "f9"
function getCuccaimBind()
  return cuccaimBind
end
function setCuccaimBind(button)
  cuccaimBind = button
end
addEventHandler("onClientKey", getRootElement(), function(button, por)
  if utf8.lower(button) == utf8.lower(cuccaimBind) and por and getElementData(localPlayer, "loggedIn") then
    if not bindState then
      if not editingModel and not editingWeapon and not clothesShopMode then
        createClothesList()
      end
    else
      bindState = false
      clothesShopMode = false
      preEditingSlot = false
      selectedArmorId = false
      deleteClothesList()
    end
  end
end)
addEventHandler("changeEnteredCustomMarker", getRootElement(), function(currentIntType)
  if currentIntType == "clothesShop" then
    if not editingModel and not editingWeapon and not preEditingSlot and not clothesSelectorWindow and not isPedInVehicle(localPlayer) then
      if selectedClothCategory == "Megvásárolt" then
        selectedClothCategory = "Összes"
        clothesScroll = 0
      end
      clothesShopMode = true
      createClothesSelector()
    end
  elseif currentIntType == "clothesShopArmor" then
    if not editingModel and not editingWeapon and not preEditingSlot and not clothesSelectorWindow and not isPedInVehicle(localPlayer) then
      if selectedClothCategory == "Megvásárolt" then
        selectedClothCategory = "Összes"
        clothesScroll = 0
      end
      clothesShopMode = "armor"
      createClothesSelector()
    end
  elseif clothesShopMode then
    clothesShopMode = false
    selectedArmorId = false
    deleteClothesList()
  end
end)
