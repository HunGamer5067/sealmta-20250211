local seexports = {
  seal_gui = false,
  seal_hud = false,
  seal_fishing = false
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
local seelangStatImgHand = false
local seelangStaticImage = {}
local seelangStaticImageToc = {}
local seelangStaticImageUsed = {}
local seelangStaticImageDel = {}
local processSeelangStaticImage = {}
seelangStaticImageToc[0] = true
seelangStaticImageToc[1] = true
seelangStaticImageToc[2] = true
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
  if seelangStaticImageUsed[1] then
    seelangStaticImageUsed[1] = false
    seelangStaticImageDel[1] = false
  elseif seelangStaticImage[1] then
    if seelangStaticImageDel[1] then
      if now >= seelangStaticImageDel[1] then
        if isElement(seelangStaticImage[1]) then
          destroyElement(seelangStaticImage[1])
        end
        seelangStaticImage[1] = nil
        seelangStaticImageDel[1] = false
        seelangStaticImageToc[1] = true
        return
      end
    else
      seelangStaticImageDel[1] = now + 5000
    end
  else
    seelangStaticImageToc[1] = true
  end
  if seelangStaticImageUsed[2] then
    seelangStaticImageUsed[2] = false
    seelangStaticImageDel[2] = false
  elseif seelangStaticImage[2] then
    if seelangStaticImageDel[2] then
      if now >= seelangStaticImageDel[2] then
        if isElement(seelangStaticImage[2]) then
          destroyElement(seelangStaticImage[2])
        end
        seelangStaticImage[2] = nil
        seelangStaticImageDel[2] = false
        seelangStaticImageToc[2] = true
        return
      end
    else
      seelangStaticImageDel[2] = now + 5000
    end
  else
    seelangStaticImageToc[2] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/glow.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/circle.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/outline.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local circleFont = false
local circleFontScale = false
local circleBg = false
local circleIcon = false
local circleGreen = false
local circleRed = false
local faTicks = false
local function seelangGuiRefreshColors()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    circleFont = seexports.seal_gui:getFont("14/BebasNeueRegular.otf")
    circleFontScale = seexports.seal_gui:getFontScale("14/BebasNeueRegular.otf")
    circleBg = seexports.seal_gui:getColorCode("grey1")
    circleIcon = seexports.seal_gui:getColorCode("midgrey")
    circleGreen = seexports.seal_gui:getColorCode("green")
    circleRed = seexports.seal_gui:getColorCode("red")
    faTicks = seexports.seal_gui:getFaTicks()
    guiRefresh()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = seexports.seal_gui:getFaTicks()
end)
local seelangCondHandlState1 = false
local function seelangCondHandl1(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState1 then
    seelangCondHandlState1 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderAnimCircle, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderAnimCircle)
    end
  end
end
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderAnimCircle, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderAnimCircle)
    end
  end
end
local circleBind = "mouse3"
local LaptopCircleBind = "F9"
local iconS = 64
local screenX, screenY = guiGetScreenSize()
local icons = {}
local closeIcon
function guiRefresh()
  for i = 1, #categoryList do
    local categIcon = categoryList[i][2]
    icons[i] = seexports.seal_gui:getFaIconFilename(categIcon, iconS)
  end
  closeIcon = seexports.seal_gui:getFaIconFilename("ban", iconS, "light")
end
local animCircle = false
local animCircleOpened = 0
local selectedAnim = false
local tmpSelected = false
local circleCenterP = 1
local builtCircleList = {}
function preRenderAnimCircle(delta)
  local cx, cy = getCursorPosition()
  if not cx then
    animCircle = false
  else
    cx, cy = cx * screenX, cy * screenY
  end
  local selected = false
  if selectedAnim then
    selected = selectedAnim
  elseif cx and 3 <= animCircleOpened then
    local d = getDistanceBetweenPoints2D(cx, cy, screenX / 2, screenY / 2)
    if 75 < d then
      local d = math.atan2(cy - screenY / 2, cx - screenX / 2)
      local deg = math.pi * 2 / #builtCircleList
      local min = deg * 2
      for i = 1, #builtCircleList do
        local comp = math.abs((deg * i - d + math.pi) % (math.pi * 2) - math.pi)
        if min > comp then
          selected = i
          min = comp
        end
      end
    end
  end
  if tmpSelected ~= selected then
    tmpSelected = selected
    playSound("files/hover.wav")
  end
  if animCircle then
    if animCircleOpened < 3 then
      animCircleOpened = animCircleOpened + delta / 1000 * 4.75
      if 3 < animCircleOpened then
        animCircleOpened = 3
        selectedAnim = false
      end
    end
  elseif 0 < animCircleOpened then
    animCircleOpened = animCircleOpened - delta / 1000 * 4
    if animCircleOpened < 0 then
      animCircleOpened = 0
      seelangCondHandl0(false)
      seelangCondHandl1(false)
    end
  end
  for i = 1, #builtCircleList do
    if i == selected then
      if builtCircleList[i][3] < 1 then
        builtCircleList[i][3] = builtCircleList[i][3] + delta / 1000 * 4
        if builtCircleList[i][3] > 1 then
          builtCircleList[i][3] = 1
        end
      end
    elseif builtCircleList[i][3] > 0 then
      builtCircleList[i][3] = builtCircleList[i][3] - delta / 1000 * 4
      if builtCircleList[i][3] < 0 then
        builtCircleList[i][3] = 0
      end
    end
  end
  if selected then
    if 0 < circleCenterP then
      circleCenterP = circleCenterP - delta / 1000 * 4
      if circleCenterP < 0 then
        circleCenterP = 0
      end
    end
  elseif circleCenterP < 1 then
    circleCenterP = circleCenterP + delta / 1000 * 4
    if 1 < circleCenterP then
      circleCenterP = 1
    end
  end
end
function renderCircle(a, s, ts, i, rad, deg, p)
  local x = screenX / 2 + math.cos(deg * i) * rad * 250
  local y = screenY / 2 + math.sin(deg * i) * rad * 250
  local centerP = builtCircleList[i][3]
  if 0 < centerP and centerP < 1 then
    centerP = getEasingValue(centerP, "InOutQuad")
  end
  local r = 255 + (circleGreen[1] - 255) * centerP
  local g = 255 + (circleGreen[2] - 255) * centerP
  local b = 255 + (circleGreen[3] - 255) * centerP
  local sp = 1.5 - centerP * 0.5
  seelangStaticImageUsed[0] = true
  if seelangStaticImageToc[0] then
    processSeelangStaticImage[0]()
  end
  dxDrawImage(x - s * 2 * a / 2, y - s * 2 * a / 2, s * 2 * a, s * 2 * a, seelangStaticImage[0], 0, 0, 0, tocolor(r, g, b, 255 * centerP * a))
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processSeelangStaticImage[1]()
  end
  dxDrawImage(x - s * a / 2, y - s * a / 2, s * a, s * a, seelangStaticImage[1], 0, 0, 0, tocolor(circleBg[1], circleBg[2], circleBg[3], 255 * a))
  local icon = icons[builtCircleList[i][2]]
  dxDrawImage(x - iconS * a / 2, y - iconS * a / 2, iconS * a, iconS * a, ":seal_gui/" .. icon .. faTicks[icon], 0, 0, 0, tocolor(circleIcon[1], circleIcon[2], circleIcon[3], 200 * a))
  dxDrawText(builtCircleList[i][1], x - ts * a / 2, y - ts * a / 2, x + ts * a / 2, y + ts * a / 2, tocolor(r, g, b, 255 * a), circleFontScale * a, circleFont, "center", "center", false, true)
  seelangStaticImageUsed[2] = true
  if seelangStaticImageToc[2] then
    processSeelangStaticImage[2]()
  end
  dxDrawImage(x - s * sp * a / 2, y - s * sp * a / 2, s * sp * a, s * sp * a, seelangStaticImage[2], 0, 0, 0, tocolor(circleGreen[1], circleGreen[2], circleGreen[3], 255 * centerP * a))
end
function renderAnimCircle()
  local s = 150
  local ts = s * 0.8
  local a = 1
  if animCircleOpened < 1 then
    a = 1 * getEasingValue(animCircleOpened, "InQuad")
  end
  local rad = 0
  local deg = math.pi * 2 / #builtCircleList
  if 1 < animCircleOpened then
    if animCircleOpened < 3 then
      rad = getEasingValue((animCircleOpened - 1) / 2, "OutQuad")
    else
      rad = 1
    end
    for i = 1, #builtCircleList do
      if i ~= selectedAnim then
        renderCircle(1, s, ts, i, rad, deg)
      end
    end
  end
  if not selectedAnim or 1 < animCircleOpened then
    local x = screenX / 2
    local y = screenY / 2
    local centerP = circleCenterP
    if 0 < circleCenterP and circleCenterP < 1 then
      centerP = getEasingValue(centerP, "InOutQuad")
    end
    local r = 255 + (circleRed[1] - 255) * centerP
    local g = 255 + (circleRed[2] - 255) * centerP
    local b = 255 + (circleRed[3] - 255) * centerP
    local sp = 1.5 - centerP * 0.5
    seelangStaticImageUsed[0] = true
    if seelangStaticImageToc[0] then
      processSeelangStaticImage[0]()
    end
    dxDrawImage(x - s * 2 * a / 2, y - s * 2 * a / 2, s * 2 * a, s * 2 * a, seelangStaticImage[0], 0, 0, 0, tocolor(r, g, b, 255 * centerP * a))
    seelangStaticImageUsed[1] = true
    if seelangStaticImageToc[1] then
      processSeelangStaticImage[1]()
    end
    dxDrawImage(x - s * a / 2, y - s * a / 2, s * a, s * a, seelangStaticImage[1], 0, 0, 0, tocolor(circleBg[1], circleBg[2], circleBg[3], 255 * a))
    dxDrawImage(x - iconS * a / 2, y - iconS * a / 2, iconS * a, iconS * a, ":seal_gui/" .. closeIcon .. faTicks[closeIcon], 0, 0, 0, tocolor(r, g, b, 255 * a))
    seelangStaticImageUsed[2] = true
    if seelangStaticImageToc[2] then
      processSeelangStaticImage[2]()
    end
    dxDrawImage(x - s * sp * a / 2, y - s * sp * a / 2, s * sp * a, s * sp * a, seelangStaticImage[2], 0, 0, 0, tocolor(circleRed[1], circleRed[2], circleRed[3], 255 * centerP * a))
  end
  if selectedAnim then
    renderCircle(a, s, ts, selectedAnim, rad, deg)
  end
end
addEventHandler("onClientKey", getRootElement(), function(key, state)
  if (key == circleBind or key == LaptopCircleBind) and getElementData(localPlayer, "loggedIn") then
    if state and not isPedInVehicle(localPlayer) and not getElementData(localPlayer, "dashboardState") --[[and not seexports.seal_hud:getHudDisabled()]] and seexports.seal_fishing:canUseAnimPanel() then
      animCircle = true
      seelangCondHandl0(true)
      seelangCondHandl1(true)
      showCursor(true)
      playSound("files/whosh1.wav")
      if animCircleOpened <= 0 then
        tmpSelected = false
        selectedAnim = false
        setCursorPosition(screenX / 2, screenY / 2)
        circleCenterP = selectedAnim and 0 or 1
        builtCircleList = {}
        for i = 1, #circleList do
          local anim = {
            animList[circleList[i]][2],
            animList[circleList[i]][1],
            currentAnimId == circleList[i] and 1 or 0,
            circleList[i]
          }
          table.insert(builtCircleList, anim)
        end
      end
      cancelEvent()
    elseif animCircle then
      animCircle = false
      showCursor(false)
      playSound("files/whosh2.wav")
      if 1 <= animCircleOpened then
        selectedAnim = false
        for i = 1, #builtCircleList do
          if builtCircleList[i][3] > 0.5 and (not selectedAnim or builtCircleList[i][3] > builtCircleList[selectedAnim][3]) then
            selectedAnim = i
          end
        end
        if selectedAnim then
          if currentAnimId ~= builtCircleList[selectedAnim][4] then
            triggerServerEvent("playAnimpanelAnimation", localPlayer, builtCircleList[selectedAnim][4])
          end
        else
          triggerServerEvent("playAnimpanelAnimation", localPlayer, false)
        end
      end
      cancelEvent()
    end
  end
end)
function getAnimCircleBind()
  return circleBind
end
function setAnimCircleBind(btn)
  circleBind = btn
end
