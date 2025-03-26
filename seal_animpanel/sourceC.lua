local seexports = {seal_gui = false, seal_fishing = false}
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
local seelangGuiRefreshColors = function()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    refreshListener()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
local seelangCondHandlState1 = false
local function seelangCondHandl1(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState1 then
    seelangCondHandlState1 = cond
    if cond then
      addEventHandler("onClientKey", getRootElement(), animpanelKeyHandler, true, prio)
    else
      removeEventHandler("onClientKey", getRootElement(), animpanelKeyHandler)
    end
  end
end
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), checkIfAnimStillPlaying, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), checkIfAnimStillPlaying)
    end
  end
end
local screenX, screenY = guiGetScreenSize()
local scrollOffset = 0
local selectorElements = {}
local selectorCategoryButtons = {}
local currentCategory = "user"
local buttonActions = {}
local currentAnimList = {}
local favoriteList = {}
circleList = {}
local categoryIcons = {}
local categoryIconList = {}
local specialIcons = {}
function refreshListener()
  local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
  local w, h = 600, titleBarHeight + 360 + 12
  local iconHeight = (h - titleBarHeight) / (#categoryList + 2)
  for i = 1, #categoryList do
    categoryIcons[i] = seexports.seal_gui:getFaIconFilename(categoryList[i][2], 24) or seexports.seal_gui:getFaIconFilename("user", 24)
  end
  for i = 1, #categoryList do
    categoryIconList[i] = seexports.seal_gui:getFaIconFilename(categoryList[i][2], iconHeight) or seexports.seal_gui:getFaIconFilename("user", iconHeight)
  end
  specialIcons.play = seexports.seal_gui:getFaIconFilename("play", 24)
  specialIcons.stop = seexports.seal_gui:getFaIconFilename("stop", 24)
  specialIcons.bolt = seexports.seal_gui:getFaIconFilename("bolt", 24)
  specialIcons.user = seexports.seal_gui:getFaIconFilename("user", 24)
  specialIcons.star = seexports.seal_gui:getFaIconFilename("star", 24, "solid")
  specialIcons.play_regular = seexports.seal_gui:getFaIconFilename("play", 24, "regular")
  specialIcons.bolt_regular = seexports.seal_gui:getFaIconFilename("bolt", 24, "regular")
  specialIcons.star_regular = seexports.seal_gui:getFaIconFilename("star", 24, "regular")
end
function loadConfig(name, maxValues)
  local ret = {}
  if fileExists(name .. ".seal") then
    local file = fileOpen(name .. ".seal")
    if file then
      local data = split(fileRead(file, fileGetSize(file)), "\n")
      for i = 1, #data do
        if maxValues and maxValues < i then
          break
        end
        if tonumber(data[i]) then
          table.insert(ret, tonumber(data[i]))
        end
      end
    end
    fileClose(file)
  else
    return ret
  end
  return ret
end
function saveConfig(data, name)
  local file = false
  if fileExists(name .. ".seal") then
    fileDelete(name .. ".seal")
  end
  file = fileCreate(name .. ".seal")
  if file then
    local saveData = ""
    for i = 1, #data do
      if tonumber(data[i]) then
        if i ~= #data then
          saveData = saveData .. data[i] .. "\n"
        else
          saveData = saveData .. data[i]
        end
      end
    end
    fileWrite(file, saveData)
    fileFlush(file)
    fileClose(file)
  end
  return {}
end
favoriteList = loadConfig("!animpanel/fav")
currentAnimList = favoriteList
circleList = loadConfig("!animpanel/circle", 8)
local animPlaying = false
local waitingForAnim = false
currentAnimId = false
function checkIfAnimStillPlaying(delta)
  local animBlock, animName = getPedAnimation(localPlayer)
  if animBlock and animName then
    animBlock, animName = utf8.lower(animBlock), utf8.lower(animName)
  end
  if waitingForAnim then
    waitingForAnim = waitingForAnim - delta
    if waitingForAnim < 0 then
      waitingForAnim = false
    else
      if animBlock == animList[currentAnimId][3] and animName == animList[currentAnimId][4] then
        waitingForAnim = false
      end
      return
    end
  end
  if animBlock ~= animList[currentAnimId][3] or animName ~= animList[currentAnimId][4] then
    currentAnimId = false
    seelangCondHandl0(false)
    seelangCondHandl1(false)
    triggerServerEvent("playAnimpanelAnimation", localPlayer)
    if animpanelWindow then
      refreshAnimList()
    end
  end
end
function animpanelKeyHandler(key, state)
  if key == "space" and state and not seexports.seal_gui:getActiveInput() and not isChatBoxInputActive() and not isConsoleActive() then
    currentAnimId = false
    seelangCondHandl0(false)
    seelangCondHandl1(false)
    triggerServerEvent("playAnimpanelAnimation", localPlayer)
    if animpanelWindow then
      refreshAnimList()
    end
  end
end
function isFavorite(animID)
  for i = 1, #favoriteList do
    if favoriteList[i] == animID then
      return true
    end
  end
  return false
end
function isCircle(id)
  for i = 1, #circleList do
    if circleList[i] == id then
      return true
    end
  end
  return false
end
function refreshAnimList()
  for btn, val in pairs(selectorCategoryButtons) do
    if currentCategory == val then
      seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
      seexports.seal_gui:setGuiHoverable(btn, false)
    else
      seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      seexports.seal_gui:setGuiHoverable(btn, true)
    end
  end
  for i = 1, #selectorElements do
    if not currentAnimList[i] then
      for j = 1, #selectorElements[i] do
        if selectorElements[i][j] then
          seexports.seal_gui:setGuiRenderDisabled(selectorElements[i][j], true)
        end
      end
    else
      for j = 1, #selectorElements[i] do
        if selectorElements[i][j] then
          seexports.seal_gui:setGuiRenderDisabled(selectorElements[i][j], false)
        end
      end
      seexports.seal_gui:setImageFile(selectorElements[i][1], categoryIcons[currentCategory] or specialIcons.user)
      seexports.seal_gui:setLabelText(selectorElements[i][2], animList[currentAnimList[i + scrollOffset]][2])
      if isFavorite(currentAnimList[i + scrollOffset]) then
        seexports.seal_gui:setImageFile(selectorElements[i][4], specialIcons.star)
        seexports.seal_gui:setImageColor(selectorElements[i][4], "yellow")
      else
        seexports.seal_gui:setImageFile(selectorElements[i][4], specialIcons.star_regular)
        seexports.seal_gui:setImageColor(selectorElements[i][4], "#FFFFFF")
      end
      if isCircle(currentAnimList[i + scrollOffset]) then
        seexports.seal_gui:setImageFile(selectorElements[i][6], specialIcons.bolt)
        seexports.seal_gui:setImageColor(selectorElements[i][6], "blue")
      else
        seexports.seal_gui:setImageFile(selectorElements[i][6], specialIcons.bolt_regular)
        seexports.seal_gui:setImageColor(selectorElements[i][6], "#FFFFFF")
      end
      seexports.seal_gui:setClickArgument(selectorElements[i][6], currentAnimList[i + scrollOffset])
      if currentAnimId == currentAnimList[i + scrollOffset] then
        seexports.seal_gui:setImageFile(selectorElements[i][5], specialIcons.stop)
        seexports.seal_gui:setImageColor(selectorElements[i][5], "green")
        seexports.seal_gui:setClickArgument(selectorElements[i][5], currentAnimList[i + scrollOffset])
      else
        seexports.seal_gui:setImageFile(selectorElements[i][5], specialIcons.play)
        seexports.seal_gui:setImageColor(selectorElements[i][5], "#FFFFFF")
        seexports.seal_gui:setClickArgument(selectorElements[i][5], currentAnimList[i + scrollOffset])
      end
    end
  end
  local sh = 360 / math.max(1, #currentAnimList - 12 + 1)
  seexports.seal_gui:setGuiSize(selectorScrollBar, false, sh)
  seexports.seal_gui:setGuiPosition(selectorScrollBar, false, sh * scrollOffset)
end
addEvent("setFavorite", true)
addEventHandler("setFavorite", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  local num = 0
  for i = 1, #selectorElements do
    if selectorElements[i][4] == el then
      num = i
      break
    end
  end
  if isFavorite(currentAnimList[num + scrollOffset]) then
    for i = 1, #favoriteList do
      if favoriteList[i] == currentAnimList[num + scrollOffset] then
        table.remove(favoriteList, i)
      end
    end
  else
    table.insert(favoriteList, currentAnimList[num + scrollOffset])
  end
  saveConfig(favoriteList, "!animpanel/fav")
  refreshAnimList()
end)
addEvent("setCircle", true)
addEventHandler("setCircle", getRootElement(), function(button, state, absoluteX, absoluteY, el, id)
  if isCircle(id) then
    for i = 1, #circleList do
      if circleList[i] == id then
        table.remove(circleList, i)
      end
    end
  elseif #circleList < 8 then
    table.insert(circleList, id)
  else
    seexports.seal_gui:showInfobox("e", "Egyszerre maximum 8 darab animációt rakhatsz a gyors elérésbe!")
  end
  saveConfig(circleList, "!animpanel/circle")
  refreshAnimList()
end)
addEvent("playAnimation", true)
addEventHandler("playAnimation", getRootElement(), function(button, state, absoluteX, absoluteY, el, id)
  if getPedSimplestTask(localPlayer) ~= "TASK_SIMPLE_IN_AIR" and getPedSimplestTask(localPlayer) ~= "TASK_SIMPLE_LAND" and seexports.seal_fishing:canUseAnimPanel() then
      triggerServerEvent("playAnimpanelAnimation", localPlayer, id)
  end
end)
addEvent("gotCurrentAnim", true)
addEventHandler("gotCurrentAnim", getRootElement(), function(id)
  currentAnimId = id
  waitingForAnim = 10000
  seelangCondHandl0(id)
  seelangCondHandl1(id)
  if animpanelWindow then
    refreshAnimList()
  end
end)
function scrollHandler(key)
  if key == "mouse_wheel_up" then
    if 0 < scrollOffset then
      scrollOffset = scrollOffset - 1
      refreshAnimList()
    end
  elseif key == "mouse_wheel_down" and scrollOffset < #currentAnimList - 12 then
    scrollOffset = scrollOffset + 1
    refreshAnimList()
  end
end
addEvent("selectAnimpanelCategory", true)
addEventHandler("selectAnimpanelCategory", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if selectorCategoryButtons[el] then
    scrollOffset = 0
    currentCategory = selectorCategoryButtons[el]
    if currentCategory == "user" then
      currentAnimList = favoriteList
    elseif currentCategory == "circle" then
      currentAnimList = circleList
    else
      currentAnimList = getCategoryAnimations(currentCategory)
    end
    refreshAnimList()
  end
end)
function closeAnimpanel()
  removeEventHandler("onClientKey", getRootElement(), scrollHandler)
  local x, y = seexports.seal_gui:getGuiPosition(animpanelWindow)
  if fileExists("!animpanel/pos.seal") then
    fileDelete("!animpanel/pos.seal")
  end
  local file = fileCreate("!animpanel/pos.seal")
  fileWrite(file, x .. ";" .. y)
  fileClose(file)
  if animpanelWindow then
    seexports.seal_gui:deleteGuiElement(animpanelWindow)
  end
  animpanelWindow = nil
end
addEvent("closeAnimpanel", true)
addEventHandler("closeAnimpanel", getRootElement(), closeAnimpanel)
function createAnimSelector()
  if getElementData(localPlayer, "loggedIn") then
    if animpanelWindow then
      closeAnimpanel()
    else
      addEventHandler("onClientKey", getRootElement(), scrollHandler)
      local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
      local w, h = 600, titleBarHeight + 360 + 12
      local posX, posY = screenX / 2 - w / 2, screenY / 2 - h / 2
      if fileExists("!animpanel/pos.seal") then
        local file = fileOpen("!animpanel/pos.seal")
        local data = fileRead(file, fileGetSize(file))
        fileClose(file)
        local pos = split(data, ";")
        posX, posY = tonumber(pos[1]), tonumber(pos[2])
      end
      animpanelWindow = seexports.seal_gui:createGuiElement("window", posX, posY, w, h)
      seexports.seal_gui:setWindowTitle(animpanelWindow, "16/BebasNeueRegular.otf", "Animációk")
      seexports.seal_gui:setWindowCloseButton(animpanelWindow, "closeAnimpanel")
      local ch = (h - titleBarHeight) / (#categoryList + 2)
      local y = titleBarHeight
      selectorCategoryButtons = {}
      selectorElements = {}
      previewButtons = {}
      local x = 0
      local btn = seexports.seal_gui:createGuiElement("button", 0, y, 160, ch, animpanelWindow)
      seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
      seexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      seexports.seal_gui:setButtonText(btn, " Kedvencek")
      seexports.seal_gui:setButtonIcon(btn, specialIcons.user)
      seexports.seal_gui:setClickEvent(btn, "selectAnimpanelCategory")
      selectorCategoryButtons[btn] = "user"
      y = y + ch
      local btn = seexports.seal_gui:createGuiElement("button", 0, y, 160, ch, animpanelWindow)
      seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
      seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
      seexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      seexports.seal_gui:setButtonText(btn, " Gyors elérés")
      seexports.seal_gui:setButtonIcon(btn, specialIcons.bolt)
      seexports.seal_gui:setClickEvent(btn, "selectAnimpanelCategory")
      selectorCategoryButtons[btn] = "circle"
      y = y + ch
      for i = 1, #categoryList do
        local btn = seexports.seal_gui:createGuiElement("button", 0, y, 160, ch, animpanelWindow)
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
        seexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
        seexports.seal_gui:setButtonText(btn, " " .. categoryList[i][1])
        seexports.seal_gui:setButtonIcon(btn, categoryIconList[i])
        seexports.seal_gui:setClickEvent(btn, "selectAnimpanelCategory")
        selectorCategoryButtons[btn] = i
        y = y + ch
      end
      x = x + 160
      y = titleBarHeight + 6
      for i = 1, 12 do
        selectorElements[i] = {}
        selectorElements[i][1] = seexports.seal_gui:createGuiElement("image", x + 6, y + 15 - 12, 24, 24, animpanelWindow)
        selectorElements[i][2] = seexports.seal_gui:createGuiElement("label", x + 6 + 24 + 3, y, 0, 30, animpanelWindow)
        seexports.seal_gui:setLabelAlignment(selectorElements[i][2], "left", "center")
        seexports.seal_gui:setLabelFont(selectorElements[i][2], "11/Ubuntu-R.ttf")
        local bw = 24
        selectorElements[i][3] = seexports.seal_gui:createGuiElement("label", 0, y, w - (30 + bw) - 2 - 12, 30, animpanelWindow)
        seexports.seal_gui:setLabelAlignment(selectorElements[i][3], "right", "center")
        seexports.seal_gui:setLabelFont(selectorElements[i][3], "11/Ubuntu-R.ttf")
        local icon = seexports.seal_gui:createGuiElement("image", w - bw - 2 - 6 - 2 - 24 - 2, y + 15 - 12, 24, 24, animpanelWindow)
        seexports.seal_gui:setImageFile(icon, specialIcons.star_regular)
        seexports.seal_gui:setGuiHoverable(icon, true)
        seexports.seal_gui:setClickEvent(icon, "setFavorite")
        selectorElements[i][4] = icon
        local icon = seexports.seal_gui:createGuiElement("image", w - bw - 2 - 6 - 2, y + 15 - 12, 24, 24, animpanelWindow)
        seexports.seal_gui:setImageFile(icon, specialIcons.play_regular)
        seexports.seal_gui:setGuiHoverable(icon, true)
        seexports.seal_gui:setClickEvent(icon, "playAnimation")
        selectorElements[i][5] = icon
        local icon = seexports.seal_gui:createGuiElement("image", w - bw - 2 - 6 - 4 - 48, y + 15 - 12, 24, 24, animpanelWindow)
        seexports.seal_gui:setImageFile(icon, specialIcons.bolt_regular)
        seexports.seal_gui:setGuiHoverable(icon, true)
        seexports.seal_gui:setClickEvent(icon, "setCircle")
        selectorElements[i][6] = icon
        y = y + 30
        if i < 12 then
          local border = seexports.seal_gui:createGuiElement("hr", x + 6, y - 1, w - 12 - x - 2 - 6, 2, animpanelWindow)
        end
      end
      local rect = seexports.seal_gui:createGuiElement("rectangle", w - 6 - 2, titleBarHeight + 6, 2, 360, animpanelWindow)
      seexports.seal_gui:setGuiBackground(rect, "solid", "grey3")
      selectorScrollBar = seexports.seal_gui:createGuiElement("rectangle", 0, 0, 2, 360, rect)
      seexports.seal_gui:setGuiBackground(selectorScrollBar, "solid", "midgrey")
      refreshAnimList()
    end
  end
end
addCommandHandler("animpanel", createAnimSelector)
local customAnimList = {
  "SEcrckidle1",
  "Scrckdeth2",
  "S3SitnWait_loop_W",
  "S2SitnWait_loop_W",
  "Rtisztelges_gsign5LH",
  "Rtarkonhandsup_cower",
  "rSitnWait_loop_W",
  "Rhandsup",
  "Rfallfront_csplay",
  "Rcolt45_fire_2hands",
  "ParkSit_W_loop",
  "ParkSit_M_loop",
  "noifekv",
  "LOU",
  "leanIDLE",
  "Lcamcrch_cmon",
  "Lay_Bac_Loop",
  "HCS_Dead_Guy",
  "Hcrckidle4",
  "Gun_stand_4",
  "Gun_stand_3",
  "Gun_stand_2",
  "Gun_stand",
  "fSitnWait_loop_W",
  "FPParkSit_M_loop",
  "FPGun_stand",
  "FPCoplook_loop",
  "FPCoplook_in",
  "FPbather",
  "FP5bather",
  "FP4bather",
  "FP3bather",
  "FP2ParkSit_M_loop",
  "FP2bather",
  "fekves",
  "FARMSitnWait_loop_W",
  "FARMBARman_idle",
  "FARM2SitnWait_loop_W",
  "FARM2BARman_idle",
  "Ddnce_M_e",
  "Ddnce_M_b",
  "Ddnce_M_a",
  "Ddance_loop",
  "DDAN_Up_A",
  "DDAN_Right_A",
  "DDAN_Loop_A",
  "DDAN_Left_A",
  "DDAN_Down_A",
  "Dbd_clap1",
  "Dbd_clap",
  "cSitnWait_loop_W",
  "bather",
  "SSitnWait_loop_W",
  "SitnWait_loop_W",
  "SEcrckidle4",
  "SEcrckidle3",
  "SEcrckidle2",
  "clap2_tran_hng",
  "clap1_tran_gtup",
  "gum_eat",
  "bal_elso_2",
  "bal_elso_3",
  "bal_hatso_1",
  "bal_hatso_2",
  "jobb_2",
  "jobb_3",
  "tricking"
}
local ifpList = {}
for i = 1, #customAnimList do
  local ifp = engineLoadIFP("custom/" .. customAnimList[i] .. ".ifp", "SGS" .. customAnimList[i])
  table.insert(ifpList, ifp)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for i = 1, #ifpList do
    destroyElement(ifpList[i])
  end
end)
local farmAnims = {
  {
    "FARMSitnWait_loop_W",
    "SitnWait_loop_W"
  },
  {
    "FARMBARman_idle",
    "BARman_idle"
  },
  {
    "FARM2SitnWait_loop_W",
    "SitnWait_loop_W"
  },
  {
    "FARM2BARman_idle",
    "BARman_idle"
  }
}
function processCustomAnim(client)
  local customAnim = getElementData(client, "customAnim") or false
  if customAnim and tonumber(customAnim) then
    local updatePosition = false
    if animList[customAnim][3] == "sgstricking" then
      updatePosition = true
    end
    setPedAnimation(client, animList[customAnim][3], animList[customAnim][4], -1, animList[customAnim][5], updatePosition, false, animList[customAnim][7])
  elseif customAnim and utf8.len(customAnim) > 0 then
    if utf8.find(customAnim, "farm") then
      local dat = split(customAnim, "_")
      local anim = tonumber(dat[2])
      local farmAnim = farmAnims[anim]
      setPedAnimation(client, "SGS" .. farmAnim[1], farmAnim[2], tonumber(dat[3]), true, false, false, false)
    end
  else
    setPedAnimation(client)
  end
end
addEventHandler("onClientPlayerStreamIn", getRootElement(), function()
  processCustomAnim(source)
end)
addEventHandler("onClientPlayerDataChange", getRootElement(), function(dataName)
  if dataName == "customAnim" then
    processCustomAnim(source)
  end
end)
function commandDispatcher(cmd, arg)
  arg = tonumber(arg) or 0
  if commandLookup[cmd] then
    local animId
    if arg == 0 and commandLookup[cmd][1] then
      animId = commandLookup[cmd][1]
    else
      animId = commandLookup[cmd][arg]
    end
    if animId and getPedSimplestTask(localPlayer) ~= "TASK_SIMPLE_IN_AIR" and getPedSimplestTask(localPlayer) ~= "TASK_SIMPLE_LAND" and seexports.seal_fishing:canUseAnimPanel() then
      triggerServerEvent("playAnimpanelAnimation", localPlayer, animId)
    end
  end
end
for k, v in pairs(commandLookup) do
  addCommandHandler(k, commandDispatcher, false)
end
addCommandHandler("anims", function()
  local outText = {}
  for k, v in pairs(commandLookup) do
    local arg = 1 < #v and " [1-" .. #v .. "]" or ""
    table.insert(outText, "#FFFFFF/" .. k .. arg)
  end
  local realOutTexts = {}
  for i = 1, #outText do
    if not realOutTexts[i % 7] then
      realOutTexts[i % 7] = {}
    end
    table.insert(realOutTexts[i % 7], outText[i])
  end
  for k, v in pairs(realOutTexts) do
    local text = table.concat(v, ", ")
    outputChatBox("[color=green][SealMTA - Animációk]: " .. text, 255, 255, 255, true)
  end
end)
local animPanelBind = "f2"
function getAnimPanelBind()
  return animPanelBind
end
function setAnimPanelBind(button)
  animPanelBind = button
end
addEventHandler("onClientKey", getRootElement(), function(button, por)
  if animPanelBind and utf8.lower(button) == utf8.lower(animPanelBind) and por then
    createAnimSelector()
  end
end)
