local steelexports = {
  seal_mall = false,
  seal_weapons = false,
  pattach = false
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
local steelangModloaderLoaded = function()
  loadModelIds()
end
addEventHandler("modloaderLoaded", getRootElement(), steelangModloaderLoaded)
if getElementData(localPlayer, "loggedIn") or steelexports.seal_mall and steelexports.seal_mall:isModloaderLoaded() then
  addEventHandler("onClientResourceStart", getResourceRootElement(), steelangModloaderLoaded)
end
weaponItemData = {}
local weaponDefaultsItems = {}
weaponDefaults = {}
function loadModelIds()
  for model in pairs(clothesList) do
    if not clothesList[model].model then
      clothesList[model].model = steelexports.seal_mall:getModelId(model)
    end
  end
  local itemIds = steelexports.seal_weapons:getWeaponItemIds()
  for itemId in pairs(itemIds) do
    local modelOrig, bone, canHide, model = steelexports.seal_weapons:getWeaponClothesshopData(itemId)
    if modelOrig then
      weaponItemData[itemId] = {
        model,
        bone,
        modelOrig,
        canHide
      }
    end
  end
  weaponDefaults = {}
  for item, dat in pairs(weaponDefaultsItems) do
    if weaponItemData[item] then
      local model = weaponItemData[item][3]
      local bone = weaponItemData[item][2]
      if model then
        if type(bone) == "table" then
          for b in pairs(bone) do
            if b == dat[1] then
              weaponDefaults[model] = dat
              break
            end
          end
        elseif tonumber(bone) == dat[1] then
          weaponDefaults[model] = dat
        end
      end
    end
  end
  initClothes()
end
local streamedClientList = {}
streamedWeapons = {}
streamedClothes = {}
local streamOutTime = {}
selfWeaponShader = {}
selfWeaponTex = {}
playerWeaponCoords = {}
local currentWeapon = {}
streamedClothes[localPlayer] = {}
streamedWeapons[localPlayer] = {}
playerWeaponCoords[localPlayer] = {}
myClothData = {}
local storedAlpha = {}
addEventHandler("onClientPreRender", getRootElement(), function()
  for i = 1, #streamedClientList do
    local client = streamedClientList[i]
    if isElement(client) then
      local alpha = getElementAlpha(client)
      if storedAlpha[client] ~= alpha then
        storedAlpha[client] = alpha
        for item, obj in pairs(streamedWeapons[client]) do
          if isElement(obj) then
            setElementAlpha(obj, alpha)
          end
        end
        for slot, obj in pairs(streamedClothes[client]) do
          if isElement(obj) then
            setElementAlpha(obj, alpha)
          end
        end
      end
    end
  end
end)
function refreshPlayerWeapon(client, item)
  if playerWeaponCoords[client] then
    if weaponItemData[item] and playerWeaponCoords[client][item] and currentWeapon[client] ~= item then
      if not isElement(streamedWeapons[client][item]) then
        streamedWeapons[client][item] = createObject(weaponItemData[item][1], 0, 0, 0)
        setElementCollisionsEnabled(streamedWeapons[client][item], false)
      else
        setElementModel(streamedWeapons[client][item], weaponItemData[item][1])
      end
      local bone = playerWeaponCoords[client][item][1]
      if tonumber(weaponItemData[item][2]) then
        bone = weaponItemData[item][2]
      elseif not weaponItemData[item][2][bone] then
        for k in pairs(weaponItemData[item][2]) do
          bone = k
          break
        end
      end
      if client == localPlayer then
        if item == editingWeapon then
          setElementAlpha(streamedWeapons[client][item], 0)
        else
          setElementAlpha(streamedWeapons[client][item], getElementAlpha(client))
        end
      end
      steelexports.pattach:detach(streamedWeapons[client][item])
      steelexports.pattach:attach(streamedWeapons[client][item], client, bone, -playerWeaponCoords[client][item][4], playerWeaponCoords[client][item][3], playerWeaponCoords[client][item][2], 0, 0, 0)
      steelexports.pattach:setRotationQuaternion(streamedWeapons[client][item], playerWeaponCoords[client][item][5])
      setElementAlpha(streamedWeapons[client][item], getElementAlpha(client))
      local shader, tex = steelexports.seal_weapons:processWPSkinBack(client, item, true)
      if shader then
        engineApplyShaderToWorldTexture(shader, tex, streamedWeapons[client][item])
        if client == localPlayer then
          selfWeaponShader[item] = shader
          selfWeaponTex[item] = tex
        end
      end
    elseif item then
      steelexports.seal_weapons:processWPSkinBack(client, item, false)
      if client == localPlayer then
        selfWeaponShader[item] = nil
        selfWeaponTex[item] = nil
      end
      if isElement(streamedWeapons[client][item]) then
        destroyElement(streamedWeapons[client][item])
      end
      streamedWeapons[client][item] = nil
    end
  end
end
function refreshPlayerCloth(client, slot, model, bone, x, y, z, q, sx, sy, sz, armorId)
  if streamedClothes[client] then
    if client == localPlayer then
      if bone then
        myClothData[slot] = {
          model,
          bone,
          x,
          y,
          z,
          q,
          sx,
          sy,
          sz,
          armorId
        }
      else
        myClothData[slot] = nil
      end
      if clothesListWindow then
        createClothesList()
      end
    end
    if clothesList[model] then
      if not isElement(streamedClothes[client][slot]) then
        streamedClothes[client][slot] = createObject(clothesList[model].model, 0, 0, 0)
        setElementCollisionsEnabled(streamedClothes[client][slot], false)
      else
        setElementModel(streamedClothes[client][slot], clothesList[model].model)
      end
      if client == localPlayer then
        if slot == editingSlot then
          setElementAlpha(streamedClothes[client][slot], 0)
        else
          setElementAlpha(streamedClothes[client][slot], getElementAlpha(client))
        end
      end
      steelexports.pattach:detach(streamedClothes[client][slot])
      steelexports.pattach:attach(streamedClothes[client][slot], client, bone, -z, y, x, 0, 0, 0)
      steelexports.pattach:setRotationQuaternion(streamedClothes[client][slot], q)
      setObjectScale(streamedClothes[client][slot], sx, sy, sz)
    else
      if isElement(streamedClothes[client][slot]) then
        destroyElement(streamedClothes[client][slot])
      end
      streamedClothes[client][slot] = nil
    end
  end
end
function getSelfClothData()
  local objs = {}
  for slot, dat in pairs(myClothData) do
    local model, bone, x, y, z, q, sx, sy, sz = unpack(dat)
    table.insert(objs, {
      clothesList[model].model,
      bone,
      -z,
      y,
      x,
      q,
      sx,
      sy,
      sz
    })
  end
  for item in pairs(streamedWeapons[localPlayer]) do
    local bone = playerWeaponCoords[localPlayer][item][1]
    if tonumber(weaponItemData[item][2]) then
      bone = weaponItemData[item][2]
    elseif not weaponItemData[item][2][bone] then
      for k in pairs(weaponItemData[item][2]) do
        bone = k
        break
      end
    end
    local shader, tex, texEl = steelexports.seal_weapons:processWPSkinBack("self", item, true)
    table.insert(objs, {
      weaponItemData[item][1],
      bone,
      -playerWeaponCoords[localPlayer][item][4],
      playerWeaponCoords[localPlayer][item][3],
      playerWeaponCoords[localPlayer][item][2],
      playerWeaponCoords[localPlayer][item][5],
      1,
      1,
      1,
      shader and tex,
      shader and texEl,
      item
    })
  end
  return objs
end
addEvent("refreshPlayerClothWeapon", true)
addEventHandler("refreshPlayerClothWeapon", getRootElement(), function(item, new)
  if streamedWeapons[source] then
    if source == localPlayer and item == editingWeapon then
      stopEditorSaving()
    else
      if new then
        if item then
          triggerLatentServerEvent("requestPlayerWeaponCloth", source, item)
        else
          if playerWeaponCoords[source] then
            for item in pairs(playerWeaponCoords[source]) do
              playerWeaponCoords[source][item] = nil
              refreshPlayerWeapon(source, item)
            end
          end
          triggerLatentServerEvent("requestPlayerWeaponClothesAll", source)
        end
      elseif item and playerWeaponCoords[source] then
        playerWeaponCoords[source][item] = nil
      end
      refreshPlayerWeapon(source, item)
    end
    if not new and source == localPlayer and weaponWindow then
      openWeaponClothesEditor()
    end
  end
end)
addEvent("refreshPlayerCloth", true)
addEventHandler("refreshPlayerCloth", getRootElement(), function(slot, new)
  if streamedClothes[source] then
    if source == localPlayer and slot == editingSlot then
      stopEditorSaving()
    elseif new then
      if slot then
        triggerLatentServerEvent("requestPlayerSingleCloth", source, slot)
      else
        for slot in pairs(streamedClothes[client]) do
          refreshPlayerCloth(source, slot, false)
        end
        triggerLatentServerEvent("requestPlayerClothes", source)
      end
    elseif slot then
      if isElement(streamedClothes[source][slot]) then
        destroyElement(streamedClothes[source][slot])
      end
      streamedClothes[source][slot] = nil
      if source == localPlayer then
        myClothData[slot] = nil
        if clothesListWindow then
          createClothesList()
        end
      end
    end
  end
end)
addEvent("gotPlayerCloth", true)
addEventHandler("gotPlayerCloth", getRootElement(), function(slot, model, bone, x, y, z, q, sx, sy, sz, armorId)
  refreshPlayerCloth(source, slot, model, bone, x, y, z, q, sx, sy, sz, armorId)
end)
addEvent("gotPlayerWeaponCloth", true)
addEventHandler("gotPlayerWeaponCloth", getRootElement(), function(item, bone, x, y, z, q)
  if playerWeaponCoords[source] and weaponItemData[item] then
    if streamedWeapons[source] and item then
      for item, obj in pairs(streamedWeapons[source]) do
        if not exports.seal_items:playerHasItem(item) then
          if isElement(obj) then
            destroyElement(obj)
          end
          streamedWeapons[source][item] = nil
        end
      end
    end
    if bone then
      if bone == -1 then
        playerWeaponCoords[source][item] = {
          1,
          0,
          -0.20408225,
          0.062490303,
          {
            0.90512902,
            -0.071643382,
            -0.41879866,
            -0.014711358
          }
        }
      else
        playerWeaponCoords[source][item] = {
          bone,
          x,
          y,
          z,
          q
        }
      end
    else
      playerWeaponCoords[source][item] = nil
    end
    refreshPlayerWeapon(source, item)
    if source == localPlayer and weaponWindow then
      openWeaponClothesEditor()
    end
  end
end)
function streamOut(client)
  if client ~= localPlayer then
    if streamedClothes[client] then
      for slot, obj in pairs(streamedClothes[client]) do
        if isElement(obj) then
          destroyElement(obj)
        end
      end
    end
    if streamedWeapons[client] then
      for item, obj in pairs(streamedWeapons[client]) do
        if isElement(obj) then
          destroyElement(obj)
        end
        steelexports.seal_weapons:processWPSkinBack(client, item, false)
      end
    end
    streamedClothes[client] = nil
    streamedWeapons[client] = nil
  end
  for i = #streamedClientList, 1, -1 do
    if streamedClientList[i] == client then
      table.remove(streamedClientList, i)
    end
  end
  streamOutTime[client] = nil
  storedAlpha[client] = nil
  currentWeapon[client] = nil
  playerWeaponCoords[client] = nil
end
setTimer(function()
  local now = getTickCount()
  for client, t in pairs(streamOutTime) do
    if 15000 < now - t then
      streamOut(client)
    end
  end
end, 5000, 0)
local clothesInitDone = false
function initClothes()
  local players = getElementsByType("player", getRootElement(), true)
  for i = 1, #players do
    if not streamedClothes[players[i]] then
      streamedClothes[players[i]] = {}
    end
    if not streamedWeapons[players[i]] then
      streamedWeapons[players[i]] = {}
    end
    if not playerWeaponCoords[players[i]] then
      playerWeaponCoords[players[i]] = {}
    end
    currentWeapon[players[i]] = getElementData(source, "equippedCustomWeaponId")
    streamOutTime[players[i]] = nil
    triggerLatentServerEvent("requestPlayerWeaponClothesAll", players[i])
    triggerLatentServerEvent("requestPlayerClothes", players[i])
    table.insert(streamedClientList, players[i])
  end
  clothesInitDone = true
end
addEventHandler("onClientElementDataChange", getRootElement(), function(data, old, new)
  if (data == "equippedCustomWeaponId") and streamedWeapons[source] then
    local old = currentWeapon[source]
    currentWeapon[source] = getElementData(source, "equippedCustomWeaponId")
    if old then
      refreshPlayerWeapon(source, old)
    end
    if currentWeapon[source] then
      refreshPlayerWeapon(source, currentWeapon[source])
    end
  end
end)
addEventHandler("onClientElementStreamIn", getRootElement(), function()
  if clothesInitDone and source ~= localPlayer then
    currentWeapon[source] = getElementData(source, "equippedCustomWeaponId")
    streamOutTime[source] = nil
    if getElementType(source) == "player" and not streamedClothes[source] then
      streamedClothes[source] = {}
      streamedWeapons[source] = {}
      playerWeaponCoords[source] = {}
      triggerLatentServerEvent("requestPlayerWeaponClothesAll", source)
      triggerLatentServerEvent("requestPlayerClothes", source)
      table.insert(streamedClientList, source)
    end
  end
end)
addEventHandler("onClientElementStreamOut", getRootElement(), function()
  if streamedClothes[source] and source ~= localPlayer then
    streamOutTime[source] = getTickCount()
  end
end)
addEventHandler("onClientPlayerQuit", getRootElement(), function()
  streamOut(source)
end)