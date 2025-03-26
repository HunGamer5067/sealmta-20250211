local sealexports = {
  seal_controls = false,
  pattach = false,
  seal_gui = false,
}
local function sealangProcessExports()
  for k in pairs(sealexports) do
    local res = getResourceFromName(k)
    if res and getResourceState(res) == "running" then
      sealexports[k] = exports[k]
    else
      sealexports[k] = false
    end
  end
end
sealangProcessExports()
if triggerServerEvent then
  addEventHandler("onClientResourceStart", getRootElement(), sealangProcessExports, true, "high+9999999999")
end
if triggerClientEvent then
  addEventHandler("onResourceStart", getRootElement(), sealangProcessExports, true, "high+9999999999")
end
local sealangStatImgHand = false
local sealangStaticImage = {}
local sealangStaticImageToc = {}
local sealangStaticImageUsed = {}
local sealangStaticImageDel = {}
local processsealangStaticImage = {}
sealangStaticImageToc[0] = true
sealangStaticImageToc[1] = true
sealangStaticImageToc[2] = true
sealangStaticImageToc[3] = true
sealangStaticImageToc[4] = true
sealangStaticImageToc[5] = true
sealangStaticImageToc[6] = true
sealangStaticImageToc[7] = true
sealangStaticImageToc[8] = true
sealangStaticImageToc[9] = true
sealangStaticImageToc[10] = true
sealangStaticImageToc[11] = true
sealangStaticImageToc[12] = true
sealangStaticImageToc[13] = true
sealangStaticImageToc[14] = true
sealangStaticImageToc[15] = true
sealangStaticImageToc[16] = true
sealangStaticImageToc[17] = true
local sealangStatImgPre
function sealangStatImgPre()
  local now = getTickCount()
  if sealangStaticImageUsed[0] then
    sealangStaticImageUsed[0] = false
    sealangStaticImageDel[0] = false
  elseif sealangStaticImage[0] then
    if sealangStaticImageDel[0] then
      if now >= sealangStaticImageDel[0] then
        if isElement(sealangStaticImage[0]) then
          destroyElement(sealangStaticImage[0])
        end
        sealangStaticImage[0] = nil
        sealangStaticImageDel[0] = false
        sealangStaticImageToc[0] = true
        return
      end
    else
      sealangStaticImageDel[0] = now + 5000
    end
  else
    sealangStaticImageToc[0] = true
  end
  if sealangStaticImageUsed[1] then
    sealangStaticImageUsed[1] = false
    sealangStaticImageDel[1] = false
  elseif sealangStaticImage[1] then
    if sealangStaticImageDel[1] then
      if now >= sealangStaticImageDel[1] then
        if isElement(sealangStaticImage[1]) then
          destroyElement(sealangStaticImage[1])
        end
        sealangStaticImage[1] = nil
        sealangStaticImageDel[1] = false
        sealangStaticImageToc[1] = true
        return
      end
    else
      sealangStaticImageDel[1] = now + 5000
    end
  else
    sealangStaticImageToc[1] = true
  end
  if sealangStaticImageUsed[2] then
    sealangStaticImageUsed[2] = false
    sealangStaticImageDel[2] = false
  elseif sealangStaticImage[2] then
    if sealangStaticImageDel[2] then
      if now >= sealangStaticImageDel[2] then
        if isElement(sealangStaticImage[2]) then
          destroyElement(sealangStaticImage[2])
        end
        sealangStaticImage[2] = nil
        sealangStaticImageDel[2] = false
        sealangStaticImageToc[2] = true
        return
      end
    else
      sealangStaticImageDel[2] = now + 5000
    end
  else
    sealangStaticImageToc[2] = true
  end
  if sealangStaticImageUsed[3] then
    sealangStaticImageUsed[3] = false
    sealangStaticImageDel[3] = false
  elseif sealangStaticImage[3] then
    if sealangStaticImageDel[3] then
      if now >= sealangStaticImageDel[3] then
        if isElement(sealangStaticImage[3]) then
          destroyElement(sealangStaticImage[3])
        end
        sealangStaticImage[3] = nil
        sealangStaticImageDel[3] = false
        sealangStaticImageToc[3] = true
        return
      end
    else
      sealangStaticImageDel[3] = now + 5000
    end
  else
    sealangStaticImageToc[3] = true
  end
  if sealangStaticImageUsed[4] then
    sealangStaticImageUsed[4] = false
    sealangStaticImageDel[4] = false
  elseif sealangStaticImage[4] then
    if sealangStaticImageDel[4] then
      if now >= sealangStaticImageDel[4] then
        if isElement(sealangStaticImage[4]) then
          destroyElement(sealangStaticImage[4])
        end
        sealangStaticImage[4] = nil
        sealangStaticImageDel[4] = false
        sealangStaticImageToc[4] = true
        return
      end
    else
      sealangStaticImageDel[4] = now + 5000
    end
  else
    sealangStaticImageToc[4] = true
  end
  if sealangStaticImageUsed[5] then
    sealangStaticImageUsed[5] = false
    sealangStaticImageDel[5] = false
  elseif sealangStaticImage[5] then
    if sealangStaticImageDel[5] then
      if now >= sealangStaticImageDel[5] then
        if isElement(sealangStaticImage[5]) then
          destroyElement(sealangStaticImage[5])
        end
        sealangStaticImage[5] = nil
        sealangStaticImageDel[5] = false
        sealangStaticImageToc[5] = true
        return
      end
    else
      sealangStaticImageDel[5] = now + 5000
    end
  else
    sealangStaticImageToc[5] = true
  end
  if sealangStaticImageUsed[6] then
    sealangStaticImageUsed[6] = false
    sealangStaticImageDel[6] = false
  elseif sealangStaticImage[6] then
    if sealangStaticImageDel[6] then
      if now >= sealangStaticImageDel[6] then
        if isElement(sealangStaticImage[6]) then
          destroyElement(sealangStaticImage[6])
        end
        sealangStaticImage[6] = nil
        sealangStaticImageDel[6] = false
        sealangStaticImageToc[6] = true
        return
      end
    else
      sealangStaticImageDel[6] = now + 5000
    end
  else
    sealangStaticImageToc[6] = true
  end
  if sealangStaticImageUsed[7] then
    sealangStaticImageUsed[7] = false
    sealangStaticImageDel[7] = false
  elseif sealangStaticImage[7] then
    if sealangStaticImageDel[7] then
      if now >= sealangStaticImageDel[7] then
        if isElement(sealangStaticImage[7]) then
          destroyElement(sealangStaticImage[7])
        end
        sealangStaticImage[7] = nil
        sealangStaticImageDel[7] = false
        sealangStaticImageToc[7] = true
        return
      end
    else
      sealangStaticImageDel[7] = now + 5000
    end
  else
    sealangStaticImageToc[7] = true
  end
  if sealangStaticImageUsed[8] then
    sealangStaticImageUsed[8] = false
    sealangStaticImageDel[8] = false
  elseif sealangStaticImage[8] then
    if sealangStaticImageDel[8] then
      if now >= sealangStaticImageDel[8] then
        if isElement(sealangStaticImage[8]) then
          destroyElement(sealangStaticImage[8])
        end
        sealangStaticImage[8] = nil
        sealangStaticImageDel[8] = false
        sealangStaticImageToc[8] = true
        return
      end
    else
      sealangStaticImageDel[8] = now + 5000
    end
  else
    sealangStaticImageToc[8] = true
  end
  if sealangStaticImageUsed[9] then
    sealangStaticImageUsed[9] = false
    sealangStaticImageDel[9] = false
  elseif sealangStaticImage[9] then
    if sealangStaticImageDel[9] then
      if now >= sealangStaticImageDel[9] then
        if isElement(sealangStaticImage[9]) then
          destroyElement(sealangStaticImage[9])
        end
        sealangStaticImage[9] = nil
        sealangStaticImageDel[9] = false
        sealangStaticImageToc[9] = true
        return
      end
    else
      sealangStaticImageDel[9] = now + 5000
    end
  else
    sealangStaticImageToc[9] = true
  end
  if sealangStaticImageUsed[10] then
    sealangStaticImageUsed[10] = false
    sealangStaticImageDel[10] = false
  elseif sealangStaticImage[10] then
    if sealangStaticImageDel[10] then
      if now >= sealangStaticImageDel[10] then
        if isElement(sealangStaticImage[10]) then
          destroyElement(sealangStaticImage[10])
        end
        sealangStaticImage[10] = nil
        sealangStaticImageDel[10] = false
        sealangStaticImageToc[10] = true
        return
      end
    else
      sealangStaticImageDel[10] = now + 5000
    end
  else
    sealangStaticImageToc[10] = true
  end
  if sealangStaticImageUsed[11] then
    sealangStaticImageUsed[11] = false
    sealangStaticImageDel[11] = false
  elseif sealangStaticImage[11] then
    if sealangStaticImageDel[11] then
      if now >= sealangStaticImageDel[11] then
        if isElement(sealangStaticImage[11]) then
          destroyElement(sealangStaticImage[11])
        end
        sealangStaticImage[11] = nil
        sealangStaticImageDel[11] = false
        sealangStaticImageToc[11] = true
        return
      end
    else
      sealangStaticImageDel[11] = now + 5000
    end
  else
    sealangStaticImageToc[11] = true
  end
  if sealangStaticImageUsed[12] then
    sealangStaticImageUsed[12] = false
    sealangStaticImageDel[12] = false
  elseif sealangStaticImage[12] then
    if sealangStaticImageDel[12] then
      if now >= sealangStaticImageDel[12] then
        if isElement(sealangStaticImage[12]) then
          destroyElement(sealangStaticImage[12])
        end
        sealangStaticImage[12] = nil
        sealangStaticImageDel[12] = false
        sealangStaticImageToc[12] = true
        return
      end
    else
      sealangStaticImageDel[12] = now + 5000
    end
  else
    sealangStaticImageToc[12] = true
  end
  if sealangStaticImageUsed[13] then
    sealangStaticImageUsed[13] = false
    sealangStaticImageDel[13] = false
  elseif sealangStaticImage[13] then
    if sealangStaticImageDel[13] then
      if now >= sealangStaticImageDel[13] then
        if isElement(sealangStaticImage[13]) then
          destroyElement(sealangStaticImage[13])
        end
        sealangStaticImage[13] = nil
        sealangStaticImageDel[13] = false
        sealangStaticImageToc[13] = true
        return
      end
    else
      sealangStaticImageDel[13] = now + 5000
    end
  else
    sealangStaticImageToc[13] = true
  end
  if sealangStaticImageUsed[14] then
    sealangStaticImageUsed[14] = false
    sealangStaticImageDel[14] = false
  elseif sealangStaticImage[14] then
    if sealangStaticImageDel[14] then
      if now >= sealangStaticImageDel[14] then
        if isElement(sealangStaticImage[14]) then
          destroyElement(sealangStaticImage[14])
        end
        sealangStaticImage[14] = nil
        sealangStaticImageDel[14] = false
        sealangStaticImageToc[14] = true
        return
      end
    else
      sealangStaticImageDel[14] = now + 5000
    end
  else
    sealangStaticImageToc[14] = true
  end
  if sealangStaticImageUsed[15] then
    sealangStaticImageUsed[15] = false
    sealangStaticImageDel[15] = false
  elseif sealangStaticImage[15] then
    if sealangStaticImageDel[15] then
      if now >= sealangStaticImageDel[15] then
        if isElement(sealangStaticImage[15]) then
          destroyElement(sealangStaticImage[15])
        end
        sealangStaticImage[15] = nil
        sealangStaticImageDel[15] = false
        sealangStaticImageToc[15] = true
        return
      end
    else
      sealangStaticImageDel[15] = now + 5000
    end
  else
    sealangStaticImageToc[15] = true
  end
  if sealangStaticImageUsed[16] then
    sealangStaticImageUsed[16] = false
    sealangStaticImageDel[16] = false
  elseif sealangStaticImage[16] then
    if sealangStaticImageDel[16] then
      if now >= sealangStaticImageDel[16] then
        if isElement(sealangStaticImage[16]) then
          destroyElement(sealangStaticImage[16])
        end
        sealangStaticImage[16] = nil
        sealangStaticImageDel[16] = false
        sealangStaticImageToc[16] = true
        return
      end
    else
      sealangStaticImageDel[16] = now + 5000
    end
  else
    sealangStaticImageToc[16] = true
  end
  if sealangStaticImageUsed[17] then
    sealangStaticImageUsed[17] = false
    sealangStaticImageDel[17] = false
  elseif sealangStaticImage[17] then
    if sealangStaticImageDel[17] then
      if now >= sealangStaticImageDel[17] then
        if isElement(sealangStaticImage[17]) then
          destroyElement(sealangStaticImage[17])
        end
        sealangStaticImage[17] = nil
        sealangStaticImageDel[17] = false
        sealangStaticImageToc[17] = true
        return
      end
    else
      sealangStaticImageDel[17] = now + 5000
    end
  else
    sealangStaticImageToc[17] = true
  end
  if sealangStaticImageToc[0] and sealangStaticImageToc[1] and sealangStaticImageToc[2] and sealangStaticImageToc[3] and sealangStaticImageToc[4] and sealangStaticImageToc[5] and sealangStaticImageToc[6] and sealangStaticImageToc[7] and sealangStaticImageToc[8] and sealangStaticImageToc[9] and sealangStaticImageToc[10] and sealangStaticImageToc[11] and sealangStaticImageToc[12] and sealangStaticImageToc[13] and sealangStaticImageToc[14] and sealangStaticImageToc[15] and sealangStaticImageToc[16] and sealangStaticImageToc[17] then
    sealangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre)
  end
end
processsealangStaticImage[0] = function()
  if not isElement(sealangStaticImage[0]) then
    sealangStaticImageToc[0] = false
    sealangStaticImage[0] = dxCreateTexture("files/tengrad.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[1] = function()
  if not isElement(sealangStaticImage[1]) then
    sealangStaticImageToc[1] = false
    sealangStaticImage[1] = dxCreateTexture("files/orsol.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[2] = function()
  if not isElement(sealangStaticImage[2]) then
    sealangStaticImageToc[2] = false
    sealangStaticImage[2] = dxCreateTexture("files/orso0.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[3] = function()
  if not isElement(sealangStaticImage[3]) then
    sealangStaticImageToc[3] = false
    sealangStaticImage[3] = dxCreateTexture("files/orso1.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[4] = function()
  if not isElement(sealangStaticImage[4]) then
    sealangStaticImageToc[4] = false
    sealangStaticImage[4] = dxCreateTexture("files/orso2.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[5] = function()
  if not isElement(sealangStaticImage[5]) then
    sealangStaticImageToc[5] = false
    sealangStaticImage[5] = dxCreateTexture("files/orso3.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[6] = function()
  if not isElement(sealangStaticImage[6]) then
    sealangStaticImageToc[6] = false
    sealangStaticImage[6] = dxCreateTexture("files/orso4.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[7] = function()
  if not isElement(sealangStaticImage[7]) then
    sealangStaticImageToc[7] = false
    sealangStaticImage[7] = dxCreateTexture("files/float.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[8] = function()
  if not isElement(sealangStaticImage[8]) then
    sealangStaticImageToc[8] = false
    sealangStaticImage[8] = dxCreateTexture("files/waterline.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[9] = function()
  if not isElement(sealangStaticImage[9]) then
    sealangStaticImageToc[9] = false
    sealangStaticImage[9] = dxCreateTexture("files/gotfish1.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[10] = function()
  if not isElement(sealangStaticImage[10]) then
    sealangStaticImageToc[10] = false
    sealangStaticImage[10] = dxCreateTexture("files/gotfish2.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[11] = function()
  if not isElement(sealangStaticImage[11]) then
    sealangStaticImageToc[11] = false
    sealangStaticImage[11] = dxCreateTexture("files/win.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[12] = function()
  if not isElement(sealangStaticImage[12]) then
    sealangStaticImageToc[12] = false
    sealangStaticImage[12] = dxCreateTexture("files/event.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[13] = function()
  if not isElement(sealangStaticImage[13]) then
    sealangStaticImageToc[13] = false
    sealangStaticImage[13] = dxCreateTexture("files/screen.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[14] = function()
  if not isElement(sealangStaticImage[14]) then
    sealangStaticImageToc[14] = false
    sealangStaticImage[14] = dxCreateTexture("files/tournament.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[15] = function()
  if not isElement(sealangStaticImage[15]) then
    sealangStaticImageToc[15] = false
    sealangStaticImage[15] = dxCreateTexture("files/glow1.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[16] = function()
  if not isElement(sealangStaticImage[16]) then
    sealangStaticImageToc[16] = false
    sealangStaticImage[16] = dxCreateTexture("files/glow2.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
processsealangStaticImage[17] = function()
  if not isElement(sealangStaticImage[17]) then
    sealangStaticImageToc[17] = false
    sealangStaticImage[17] = dxCreateTexture("files/7seg.dds", "argb", true)
  end
  if not sealangStatImgHand then
    sealangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), sealangStatImgPre, true, "high+999999999")
  end
end
local closeIcon = false
local red = false
local grey1 = false
local grey2 = false
local yellow = false
local blue = false
local purple = false
local green = false
local distanceFont = false
local distanceFontScale = false
local distanceFontEx = false
local distanceFontExScale = false
local distanceFontExWidth = false
local gearboxFont = false
local gearboxFontScale = false
local gearboxHeight = false
local gearboxWidth = false
local fishNameFont = false
local fishNameFontScale = false
local fishDataFontEx = false
local fishDataFontExScale = false
local fishDataFont = false
local fishDataFontScale = false
local fishDataFontHeight = false
local fishPriceFont = false
local fishPriceFontScale = false
local fishPriceFontHeight = false
local screenFont = false
local screenFontScale = false
local screenFontHeight = false
local faTicks = false
local gradientTick = false
local function sealangGuiRefreshColors()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    closeIcon = sealexports.seal_gui:getFaIconFilename("times", 32)
    red = sealexports.seal_gui:getColorCode("red")
    grey1 = sealexports.seal_gui:getColorCode("grey1")
    grey2 = sealexports.seal_gui:getColorCode("grey2")
    yellow = sealexports.seal_gui:getColorCode("yellow")
    blue = sealexports.seal_gui:getColorCode("blue")
    purple = sealexports.seal_gui:getColorCode("purple")
    green = sealexports.seal_gui:getColorCode("green")
    distanceFont = sealexports.seal_gui:getFont("13/BebasNeueRegular.otf")
    distanceFontScale = sealexports.seal_gui:getFontScale("13/BebasNeueRegular.otf")
    distanceFontEx = sealexports.seal_gui:getFont("12/BebasNeueRegular.otf")
    distanceFontExScale = sealexports.seal_gui:getFontScale("12/BebasNeueRegular.otf")
    distanceFontExWidth = sealexports.seal_gui:getTextWidthFont(".0 m", "12/BebasNeueRegular.otf")
    gearboxFont = sealexports.seal_gui:getFont("14/BebasNeueBold.otf")
    gearboxFontScale = sealexports.seal_gui:getFontScale("14/BebasNeueBold.otf")
    gearboxHeight = sealexports.seal_gui:getFontHeight("14/BebasNeueBold.otf")
    gearboxWidth = sealexports.seal_gui:getTextWidthFont(" 0", "14/BebasNeueBold.otf")
    fishNameFont = sealexports.seal_gui:getFont("25/BebasNeueBold.otf")
    fishNameFontScale = sealexports.seal_gui:getFontScale("25/BebasNeueBold.otf")
    fishDataFontEx = sealexports.seal_gui:getFont("15/BebasNeueRegular.otf")
    fishDataFontExScale = sealexports.seal_gui:getFontScale("15/BebasNeueRegular.otf")
    fishDataFont = sealexports.seal_gui:getFont("15/BebasNeueBold.otf")
    fishDataFontScale = sealexports.seal_gui:getFontScale("15/BebasNeueBold.otf")
    fishDataFontHeight = sealexports.seal_gui:getFontHeight("15/BebasNeueBold.otf")
    fishPriceFont = sealexports.seal_gui:getFont("16/BebasNeueBold.otf")
    fishPriceFontScale = sealexports.seal_gui:getFontScale("16/BebasNeueBold.otf")
    fishPriceFontHeight = sealexports.seal_gui:getFontHeight("16/BebasNeueBold.otf")
    screenFont = sealexports.seal_gui:getFont("11/Ubuntu-R.ttf")
    screenFontScale = sealexports.seal_gui:getFontScale("11/Ubuntu-R.ttf")
    screenFontHeight = sealexports.seal_gui:getFontHeight("11/Ubuntu-R.ttf")
    faTicks = sealexports.seal_gui:getFaTicks()
    gradientTick = sealexports.seal_gui:getGradientTick()
    guiRefreshed()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), sealangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), sealangGuiRefreshColors)
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = sealexports.seal_gui:getFaTicks()
end)
addEventHandler("refreshGradientTick", getRootElement(), function()
  gradientTick = sealexports.seal_gui:getGradientTick()
end)
local sealangCondHandlState21 = false
local function sealangCondHandl21(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState21 then
    sealangCondHandlState21 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderFishSell, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderFishSell)
    end
  end
end
local sealangCondHandlState20 = false
local function sealangCondHandl20(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState20 then
    sealangCondHandlState20 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderFishSell, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderFishSell)
    end
  end
end
local sealangCondHandlState19 = false
local function sealangCondHandl19(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState19 then
    sealangCondHandlState19 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderFishStand, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderFishStand)
    end
  end
end
local sealangCondHandlState18 = false
local function sealangCondHandl18(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState18 then
    sealangCondHandlState18 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderWinFish, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderWinFish)
    end
  end
end
local sealangCondHandlState17 = false
local function sealangCondHandl17(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState17 then
    sealangCondHandlState17 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderWinFish, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderWinFish)
    end
  end
end
local sealangCondHandlState16 = false
local function sealangCondHandl16(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState16 then
    sealangCondHandlState16 = cond
    if cond then
      addEventHandler("onClientClick", getRootElement(), clickWinFish, true, prio)
    else
      removeEventHandler("onClientClick", getRootElement(), clickWinFish)
    end
  end
end
local sealangCondHandlState15 = false
local function sealangCondHandl15(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState15 then
    sealangCondHandlState15 = cond
    if cond then
      addEventHandler("onClientRestore", getRootElement(), restoreScreen, true, prio)
    else
      removeEventHandler("onClientRestore", getRootElement(), restoreScreen)
    end
  end
end
local sealangCondHandlState14 = false
local function sealangCondHandl14(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState14 then
    sealangCondHandlState14 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), reDrawEventScreen, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), reDrawEventScreen)
    end
  end
end
local sealangCondHandlState13 = false
local function sealangCondHandl13(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState13 then
    sealangCondHandlState13 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderEventGraph, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderEventGraph)
    end
  end
end
local sealangCondHandlState12 = false
local function sealangCondHandl12(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState12 then
    sealangCondHandlState12 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderPreviewFish, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderPreviewFish)
    end
  end
end
local sealangCondHandlState11 = false
local function sealangCondHandl11(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState11 then
    sealangCondHandlState11 = cond
    if cond then
      addEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedRods, true, prio)
    else
      removeEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedRods)
    end
  end
end
local sealangCondHandlState10 = false
local function sealangCondHandl10(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState10 then
    sealangCondHandlState10 = cond
    if cond then
      addEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedBones, true, prio)
    else
      removeEventHandler("onClientPedsProcessed", getRootElement(), pedsProcessedBones)
    end
  end
end
local sealangCondHandlState9 = false
local function sealangCondHandl9(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState9 then
    sealangCondHandlState9 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderRods, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderRods)
    end
  end
end
local sealangCondHandlState8 = false
local function sealangCondHandl8(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState8 then
    sealangCondHandlState8 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), doFishSyncOverwrite, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), doFishSyncOverwrite)
    end
  end
end
local sealangCondHandlState7 = false
local function sealangCondHandl7(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState7 then
    sealangCondHandlState7 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderPlayer, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderPlayer)
    end
  end
end
local sealangCondHandlState6 = false
local function sealangCondHandl6(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState6 then
    sealangCondHandlState6 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderPlayerGui, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderPlayerGui)
    end
  end
end
local sealangCondHandlState5 = false
local function sealangCondHandl5(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState5 then
    sealangCondHandlState5 = cond
    if cond then
      addEventHandler("onClientKey", getRootElement(), keyPlayer, true, prio)
    else
      removeEventHandler("onClientKey", getRootElement(), keyPlayer)
    end
  end
end
local sealangCondHandlState4 = false
local function sealangCondHandl4(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState4 then
    sealangCondHandlState4 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), preRenderPlayer, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), preRenderPlayer)
    end
  end
end
local sealangCondHandlState3 = false
local function sealangCondHandl3(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState3 then
    sealangCondHandlState3 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), checkDisableSyncerList, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), checkDisableSyncerList)
    end
  end
end
local sealangCondHandlState2 = false
local function sealangCondHandl2(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState2 then
    sealangCondHandlState2 = cond
    if cond then
      addEventHandler("onClientPlayerQuit", getRootElement(), streamOutSyncer, true, prio)
    else
      removeEventHandler("onClientPlayerQuit", getRootElement(), streamOutSyncer)
    end
  end
end
local sealangCondHandlState1 = false
local function sealangCondHandl1(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState1 then
    sealangCondHandlState1 = cond
    if cond then
      addEventHandler("onClientElementStreamOut", getRootElement(), streamOutSyncer, true, prio)
    else
      removeEventHandler("onClientElementStreamOut", getRootElement(), streamOutSyncer)
    end
  end
end
local sealangCondHandlState0 = false
local function sealangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= sealangCondHandlState0 then
    sealangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientElementStreamIn", getRootElement(), streamInSyncer, true, prio)
    else
      removeEventHandler("onClientElementStreamIn", getRootElement(), streamInSyncer)
    end
  end
end
local currentFishingRod = false
addEvent("gotUsingFishingRod", true)
addEventHandler("gotUsingFishingRod", getRootElement(), function(rod)
  currentFishingRod = rod
end)
function modePlayerRotationNeeded(mode)
  return mode == "aim" or mode == "throw" or mode == "waiting" or mode == "getout" or mode == "catching" or mode == "catched"
end
function modeSpindleNeeded(mode)
  return mode == "waiting" or mode == "catching" or mode == "catched"
end
function modeInWater(mode)
  return mode == "throw" or mode == "waiting" or mode == "catching" or mode == "catched"
end
function modeWaterPed(mode)
  return mode == "throw" or mode == "waiting" or mode == "catching"
end
function modeBendNeeded(mode)
  return mode == "throw" or mode == "waiting" or mode == "catching" or mode == "catched" or mode == "getout"
end
function modeInWaterFishing(mode)
  return mode == "waiting" or mode == "catching" or mode == "catched"
end
function modeFishNeeded(mode)
  return mode == "catched" or mode == "getout"
end
function getRodShaderSource(tex)
  return " struct VSInput { float3 Position : POSITION0; float3 Normal : NORMAL0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; }; float4x4 gWorld : WORLD; float4x4 gView : VIEW; float4x4 gProjection : PROJECTION; float4 MTACalcScreenPosition( float3 InPosition ) { float4 posWorld = mul(float4(InPosition,1), gWorld); float4 posWorldView = mul(posWorld, gView); return mul(posWorldView, gProjection); } int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } float tensionD = 0; float tensionR = 0; PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; float h = VS.Position.z - 1.4; if(h > 0) { h /= 2; VS.Position.x += (1-cos(h*1.57))*tensionD; VS.Position.y += (1-cos(h*1.57))*tensionR; VS.Position.z -= 0.5*h*(1-cos(tensionD*1.57)); } PS.Position = MTACalcScreenPosition ( VS.Position ); PS.TexCoord = VS.TexCoord; PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse ); return PS; } " .. (tex and " texture ReplacedTexture; " or " ") .. " technique tec0 { pass P0 { " .. (tex and " Texture[0] = ReplacedTexture; " or " ") .. "VertexShader = compile vs_2_0 VertexShaderFunction();" .. " } } "
end
local fishShaderSource = " struct VSInput { float3 Position : POSITION0; float3 Normal : NORMAL0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord : TEXCOORD0; }; float4x4 gWorld : WORLD; float4x4 gView : VIEW; float4x4 gProjection : PROJECTION; float4 MTACalcScreenPosition( float3 InPosition ) { float4 posWorld = mul(float4(InPosition,1), gWorld); float4 posWorldView = mul(posWorld, gView); return mul(posWorldView, gProjection); } int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } float wave = 0; float waveSize = 0; float ficank = 0; float length = 0; PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; float h = -VS.Position.x/length; VS.Position.y += ((sin((h/2+wave)*6.2831852) - sin(wave*6.2831852))*(length/30))*waveSize; VS.Position.y += ((1-cos(abs(h-0.5)*3.14) - 1)*ficank)*(length/12); PS.Position = MTACalcScreenPosition ( VS.Position ); PS.TexCoord = VS.TexCoord; PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse ); return PS; } technique tec0 { pass P0 { VertexShader = compile vs_2_0 VertexShaderFunction(); } } "
local fishGuiShaderSource = " float3 sElementOffset = float3(0,0,0); float3 sWorldOffset = float3(0,0,0); float3 sCameraPosition = float3(0,0,0); float3 sCameraForward = float3(0,0,0); float3 sCameraUp = float3(0,0,0); float sFov = 1; float sAspect = 1; float2 sMoveObject2D = float2(0,0); float2 sScaleObject2D = float2(1,1); float2 sRealScale2D = float2(1,1); float sAlphaMult = 1; float sProjZMult = 2; float4 sColorFilter1 = float4(0,0,0,0); float4 sColorFilter2 = float4(0,0,0,0); texture gTexture0 < string textureState=\"0,Texture\"; >; float4x4 gWorld : WORLD; float4x4 gProjection : PROJECTION; texture secondRT < string renderTarget = \"yes\"; >; int gLighting < string renderState=\"LIGHTING\"; >; float4 gGlobalAmbient < string renderState=\"AMBIENT\"; >; int gAmbientMaterialSource < string renderState=\"AMBIENTMATERIALSOURCE\"; >; int gDiffuseMaterialSource < string renderState=\"DIFFUSEMATERIALSOURCE\"; >; int gEmissiveMaterialSource < string renderState=\"EMISSIVEMATERIALSOURCE\"; >; float4 gMaterialAmbient < string materialState=\"Ambient\"; >; float4 gMaterialDiffuse < string materialState=\"Diffuse\"; >; float4 gMaterialSpecular < string materialState=\"Specular\"; >; float4 gMaterialEmissive < string materialState=\"Emissive\"; >; int CUSTOMFLAGS <string createNormals = \"yes\"; string skipUnusedParameters = \"yes\"; >; float4 gTextureFactor < string renderState=\"TEXTUREFACTOR\"; >; sampler Sampler0 = sampler_state { Texture = (gTexture0); }; struct VSInput { float3 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; }; struct PSInput { float4 Position : POSITION0; float4 Diffuse : COLOR0; float2 TexCoord0 : TEXCOORD0; float4 vPosition : TEXCOORD1; float2 Depth : TEXCOORD2; }; float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec ) { float3 zaxis = normalize( fwVec); float3 xaxis = normalize( cross( -upVec, zaxis )); float3 yaxis = cross( xaxis, zaxis ); float4x4 viewMatrix = { float4( xaxis.x, yaxis.x, zaxis.x, 0 ), float4( xaxis.y, yaxis.y, zaxis.y, 0 ), float4( xaxis.z, yaxis.z, zaxis.z, 0 ), float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ), 1 ) }; return viewMatrix; } float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect, float2 ss_mov, float2 ss_scale) { float h, w, Q; w = 1/tan(fov_horiz * 0.5); h = w/fov_aspect; Q = far_plane/(far_plane - near_plane); float4x4 projectionMatrix = { float4(w * ss_scale.x, 0, 0, 0), float4(0, h * ss_scale.y, 0, 0), float4(ss_mov.x, ss_mov.y, Q, 1), float4(0, 0, -Q*near_plane, 0) }; return projectionMatrix; } float4 MTACalcGTABuildingDiffuse( float4 InDiffuse ) { float4 OutDiffuse; if ( !gLighting ) { OutDiffuse = InDiffuse; } else { float4 ambient = gAmbientMaterialSource == 0 ? gMaterialAmbient : InDiffuse; float4 diffuse = gDiffuseMaterialSource == 0 ? gMaterialDiffuse : InDiffuse; float4 emissive = gEmissiveMaterialSource == 0 ? gMaterialEmissive : InDiffuse; OutDiffuse = gGlobalAmbient * saturate( ambient + emissive ); OutDiffuse.a *= diffuse.a; } return OutDiffuse; } float wave = 0; float waveSize = 0; float length = 0; PSInput VertexShaderFunction(VSInput VS) { PSInput PS = (PSInput)0; float h = -VS.Position.x/length; VS.Position.y += ((sin((h/2+wave)*6.2831852))*(length/30))*waveSize; float4 wPos = mul(float4(VS.Position, 1), gWorld); wPos.xyz += sWorldOffset; float4x4 sView = createViewMatrix(sCameraPosition, sCameraForward, sCameraUp); float4 vPos = mul(wPos, sView); vPos.xzy += sElementOffset; float sFarClip = gProjection[3][2] / (1 - gProjection[2][2]); float sNearClip = gProjection[3][2] / - gProjection[2][2]; float4x4 sProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, sMoveObject2D, sScaleObject2D); float4x4 tProjection = createProjectionMatrix(sNearClip, sFarClip, sFov, sAspect, float2(0,0), sScaleObject2D / sRealScale2D); PS.Position = mul(vPos, sProjection); PS.vPosition = mul(vPos, tProjection); PS.Depth = float2(PS.Position.z, PS.Position.w); PS.TexCoord0 = VS.TexCoord0; float Diffa = MTACalcGTABuildingDiffuse(VS.Diffuse).a; PS.Diffuse = float4(0.35, 0.35, 0.3, Diffa); return PS; } struct Pixel { float4 Color : COLOR0; float4 Extra : COLOR1; float Depth : DEPTH0; }; Pixel PixelShaderFunction(PSInput PS) { Pixel output; float4 texel = tex2D(Sampler0, PS.TexCoord0); output.Color = float4(0, 0, 0, min(min(texel.a * PS.Diffuse.a, 0.006105), sAlphaMult)); float4 finalColor = texel * PS.Diffuse; float2 scrCoord =(PS.vPosition.xy / PS.vPosition.w) * float2(0.5, -0.5) + 0.5; output.Depth = ((PS.Depth.x * 0.00625 * sProjZMult) / PS.Depth.y); if ((scrCoord.x > 1) || (scrCoord.x < 0) || (scrCoord.y > 1) || (scrCoord.y < 0)) { output.Depth = 1; output.Color = 0; } output.Extra = saturate(finalColor); output.Extra.rgb += output.Extra.rgb * sColorFilter1.rgb * sColorFilter1.a; output.Extra.rgb += output.Extra.rgb * sColorFilter2.rgb * sColorFilter2.a; output.Extra.a *= sAlphaMult; return output; } technique fx_pre_object_MRT { pass P0 { FogEnable = false; AlphaBlendEnable = true; AlphaRef = 1; SeparateAlphaBlendEnable = true; SrcBlendAlpha = SrcAlpha; DestBlendAlpha = One; VertexShader = compile vs_2_0 VertexShaderFunction(); PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
local texReplaceShaderSource = " texture ReplacedTexture; technique TextureChange { pass P0 { Texture[0] = ReplacedTexture; } } "
local rodQ = {
  0.98863478211704,
  0.010203121539638,
  0.07918750013634,
  -0.12738329451461
}
local models = {}
local rodSkinCache = {}
local rodSkinShader = {}
local rodSkinUsers = {}
for i = 1, 4 do
  rodSkinUsers[i] = {}
end
function processRodSkinCache(rod)
  if #rodSkinUsers[rod] <= 0 then
    if isElement(rodSkinCache[rod]) then
      destroyElement(rodSkinCache[rod])
    end
    rodSkinCache[rod] = nil
    if isElement(rodSkinShader[rod]) then
      destroyElement(rodSkinShader[rod])
    end
    rodSkinShader[rod] = nil
  else
    if not isElement(rodSkinCache[rod]) then
      rodSkinCache[rod] = dxCreateTexture("files/rods/" .. rod .. ".dds", "dxt1")
    end
    if not isElement(rodSkinShader[rod]) then
      rodSkinShader[rod] = dxCreateShader(texReplaceShaderSource)
      dxSetShaderValue(rodSkinShader[rod], "ReplacedTexture", rodSkinCache[rod])
    end
    return rodSkinShader[rod]
  end
end
function getRodSkinCache(rod, client)
  if rodSkinUsers[rod] then
    table.insert(rodSkinUsers[rod], client)
    return processRodSkinCache(rod)
  end
end
local rodLineCache = {}
local rodLineShader = {}
local rodLineUsers = {}
for i = 1, #fishingLineColors do
  rodLineUsers[i] = {}
end
function processRodLineCache(line)
  if #rodLineUsers[line] <= 0 then
    if isElement(rodLineCache[line]) then
      destroyElement(rodLineCache[line])
    end
    rodLineCache[line] = nil
    if isElement(rodLineShader[line]) then
      destroyElement(rodLineShader[line])
    end
    rodLineShader[line] = nil
  else
    if not isElement(rodLineCache[line]) then
      rodLineCache[line] = dxCreateTexture("files/lines/" .. line .. ".dds", "dxt1")
    end
    if not isElement(rodLineShader[line]) then
      rodLineShader[line] = dxCreateShader(texReplaceShaderSource)
      dxSetShaderValue(rodLineShader[line], "ReplacedTexture", rodLineCache[line])
    end
    return rodLineShader[line]
  end
end
function getRodLineCache(line, client)
  if rodLineUsers[line] then
    table.insert(rodLineUsers[line], client)
    return processRodLineCache(line)
  end
end
local rodFloatSkinCache = {}
local rodFloatSkinShader = {}
local rodFloatSkinUsers = {}
for i = 1, 3 do
  rodFloatSkinUsers[i] = {}
end
function processRodFloatSkinCache(float)
  if #rodFloatSkinUsers[float] <= 0 then
    if isElement(rodFloatSkinCache[float]) then
      destroyElement(rodFloatSkinCache[float])
    end
    rodFloatSkinCache[float] = nil
    if isElement(rodFloatSkinShader[float]) then
      destroyElement(rodFloatSkinShader[float])
    end
    rodFloatSkinShader[float] = nil
  else
    if not isElement(rodFloatSkinCache[float]) then
      rodFloatSkinCache[float] = dxCreateTexture("files/floats/" .. float .. ".dds", "dxt1")
    end
    if not isElement(rodFloatSkinShader[float]) then
      rodFloatSkinShader[float] = dxCreateShader(texReplaceShaderSource)
      dxSetShaderValue(rodFloatSkinShader[float], "ReplacedTexture", rodFloatSkinCache[float])
    end
    return rodFloatSkinShader[float]
  end
end
function getRodFloatSkinCache(float, client)
  if rodFloatSkinUsers[float] then
    table.insert(rodFloatSkinUsers[float], client)
    return processRodFloatSkinCache(float)
  end
end
local syncerList = false
local syncerListRealState = false
local disableSyncerList = false
function streamInSyncer()
  if getElementType(source) == "player" then
    if source ~= localPlayer then
      syncNum = syncNum + 1
      triggerServerEvent("addPlayerFishingSyncer", source)
    end
  end
end
function streamOutSyncer()
  if getElementType(source) == "player" then
    if source ~= localPlayer then
      syncNum = syncNum - 1
      triggerServerEvent("removedPlayerFishingSyncer", source)
    end
  end
end
function checkDisableSyncerList()
  if getTickCount() - disableSyncerList > 15000 then
    syncNum = 0
    sealangCondHandl0(false)
    sealangCondHandl1(false)
    sealangCondHandl2(false)
    sealangCondHandl3(false)
    if syncerListRealState then
      triggerServerEvent("refreshPlayerFishingSyncers", localPlayer, false)
      syncerListRealState = false
    end
  end
end
function setSyncerListEnabled(state)
  syncerList = state
  if state then
    disableSyncerList = false
    if not syncerListRealState then
      syncNum = 0
      syncerListRealState = true
      local players = getElementsByType("player", getRootElement(), true)
      for i = #players, 1, -1 do
        if players[i] == localPlayer then
          table.remove(players, i)
        else
          syncNum = syncNum + 1
        end
      end
      triggerServerEvent("refreshPlayerFishingSyncers", localPlayer, players)
    end
    sealangCondHandl3(false)
    sealangCondHandl0(true)
    sealangCondHandl1(true)
    sealangCondHandl2(true)
  else
    disableSyncerList = getTickCount()
    sealangCondHandl3(true)
  end
end
local fishingRods = {}
local fishingFloats = {}
local fishingRodSkin = {}
local fishingRodLine = {}
local fishingRodFloat = {}
local fishingData = {}
function setFishingMode(client, mode, multi)
  if not fishingData[client] then
    fishingData[client] = {}
  end
  local was = fishingData[client].mode
  fishingData[client].mode = mode
  if mode == "idle" then
    fishingData[client].floatPos = {}
    setPedAnimation(client)
  elseif mode == "getout" then
    local a1, a2 = getPedAnimation(client)
    if a1 ~= "fishing_kihuzas" or a2 ~= "bather" then
      setPedAnimation(client, "fishing_kihuzas", "bather", -1, true, false, false, true, 0)
    end
    fishingData[client].getOutStart = getTickCount()
  elseif modeSpindleNeeded(mode) then
    local a1, a2 = getPedAnimation(client)
    if a1 ~= "fishing_stand" or a2 ~= "bather" then
      setPedAnimation(client, "fishing_stand", "bather", -1, true, false, false, true, 0)
    end
  elseif mode == "aim" or mode == "throw" then
    local a1, a2 = getPedAnimation(client)
    if a1 ~= "fishing_bedobas" or a2 ~= "bather" then
      setPedAnimation(client, "fishing_bedobas", "bather", -1, true, false, false, true, 0)
    end
    if mode == "throw" then
      if fishingRods[client] and not multi then
        local m = getElementMatrix(fishingRods[client])
        local rodEndX, rodEndY, rodEndZ = m[4][1] + m[3][1] * 3.43532, m[4][2] + m[3][2] * 3.43532, m[4][3] + m[3][3] * 3.43532
        playSound3D("files/woosh.mp3", rodEndX, rodEndY, rodEndZ)
      end
      local x, y, z = getElementPosition(fishingFloats[client])
      fishingData[client].fishingFloatPos = {
        x,
        y,
        z
      }
    else
      fishingData[client].throwingTension = 0
    end
  else
    setPedAnimation(client)
  end
  if not multi then
    if mode == "waiting" and isElement(fishingFloats[client]) then
      local x, y, z = getElementPosition(fishingFloats[client])
      local sound = playSound3D("files/splash.mp3", x, y, z)
      setSoundMaxDistance(sound, 50)
      fxAddWaterSplash(x, y, z)
    end
    if mode == "getout" and isElement(fishingFloats[client]) then
      local x, y, z = getElementPosition(fishingFloats[client])
      playSound3D(fishingData[client].fish and "files/waterout.mp3" or "files/splash.mp3", x, y, z)
      fxAddWaterSplash(x, y, z)
    end
  end
  if modePlayerRotationNeeded(mode) and not modePlayerRotationNeeded(mode) then
    fishingData[client].playerRot = 0
    fishingData[client].targetPlayerRot = 0
  end
  if not modeWaterPed(mode) then
    if isElement(fishingData[client].waterPed) then
      destroyElement(fishingData[client].waterPed)
    end
    fishingData[client].waterPed = nil
  end
  if modeInWater(mode) then
    if not isElement(fishingData[client].reelSound) then
      fishingData[client].reelSound = playSound3D("files/reel.mp3", 0, 0, 0, true)
      setSoundVolume(fishingData[client].reelSound, 0)
    end
    if not isElement(fishingData[client].spindleSound) then
      fishingData[client].spindleSound = playSound3D("files/spindle.mp3", 0, 0, 0, true)
      setSoundVolume(fishingData[client].spindleSound, 0)
    end
    if not isElement(fishingData[client].creakSound) then
      fishingData[client].creakSound = playSound3D("files/creak.mp3", 0, 0, 0, true)
      setSoundVolume(fishingData[client].creakSound, 0)
    end
  else
    if isElement(fishingData[client].reelSound) then
      destroyElement(fishingData[client].reelSound)
    end
    fishingData[client].reelSound = nil
    if isElement(fishingData[client].spindleSound) then
      destroyElement(fishingData[client].spindleSound)
    end
    fishingData[client].spindleSound = nil
    if isElement(fishingData[client].creakSound) then
      destroyElement(fishingData[client].creakSound)
    end
    fishingData[client].creakSound = nil
  end
  if modeFishNeeded(mode) and fishingData[client].fish then
    local fishType = fishTypes[fishingData[client].fish]
    if fishType.modelId then
      if isElement(fishingData[client].fishObject) then
        setElementModel(fishingData[client].fishObject, fishType.modelId)
      else
        fishingData[client].fishObject = createObject(fishType.modelId, 0, 0, 0)
      end
    end
    if fishingData[client].fishObject then
      setElementCollisionsEnabled(fishingData[client].fishObject, false)
      if fishType.doublesided then
        setElementDoubleSided(fishingData[client].fishObject, true)
      end
    end
    local scale = fishType.scale or 1
    if fishingData[client].fishWeight and type(fishType.weight) == "table" then
      scale = (fishingData[client].fishWeight - fishType.weight[1]) / (fishType.weight[2] - fishType.weight[1]) * (fishType.weight[4] - fishType.weight[3]) + fishType.weight[3]
    end
    if fishingData[client].fishObject then
      setObjectScale(fishingData[client].fishObject, scale)
    end
    if fishType.nonAlive then
      if isElement(fishingData[client].fishShader) then
        destroyElement(fishingData[client].fishShader)
      end
      fishingData[client].fishShader = nil
    else
      if not isElement(fishingData[client].fishShader) then
        fishingData[client].fishShader = dxCreateShader(fishShaderSource)
      end
      dxSetShaderValue(fishingData[client].fishShader, "length", fishType.length * scale)
      if fishingData[client].fishObject then
        engineApplyShaderToWorldTexture(fishingData[client].fishShader, "*", fishingData[client].fishObject)
      end
    end
  else
    if isElement(fishingData[client].fishObject) then
      destroyElement(fishingData[client].fishObject)
    end
    fishingData[client].fishObject = nil
    if isElement(fishingData[client].fishShader) then
      destroyElement(fishingData[client].fishShader)
    end
    fishingData[client].fishShader = nil
  end
  if modeBendNeeded(mode) then
    if not modeBendNeeded(was) then
      fishingData[client].floatingValue = nil
      fishingData[client].tension = nil
      fishingData[client].lastTension = nil
      fishingData[client].lineTension = nil
      fishingData[client].targetFloatPos = nil
      fishingData[client].lastPosSync = nil
      fishingData[client].lineLength = nil
      fishingData[client].targetLineLength = nil
      fishingData[client].lastLineLengthSync = nil
      fishingData[client].lineLengthVector = nil
      fishingData[client].tensionR = nil
      fishingData[client].tensionD = nil
      fishingData[client].floatSyncVector = nil
      fishingData[client].targetSpindleRoll = nil
      fishingData[client].syncedSpindleRoll = nil
      fishingData[client].spindleRollVector = nil
      fishingData[client].lastSpindleRollSync = nil
      fishingData[client].spindleRoll = nil
      fishingData[client].lineVelocity = nil
      fishingData[client].spindleGear = nil
      fishingData[client].deepness = nil
      fishingData[client].lastDeepnessSync = nil
      fishingData[client].fishDirection = nil
      fishingData[client].catchingForce = nil
      fishingData[client].lineUnderwater = nil
      fishingData[client].fishPosition = nil
      fishingData[client].fishTargetPosition = nil
      fishingData[client].fishTargetVector = nil
      fishingData[client].fishTargetTries = nil
      fishingData[client].fishMinimumDistance = nil
      fishingData[client].fishEnergy = nil
      fishingData[client].fishWave = nil
      fishingData[client].fishVector = nil
      fishingData[client].targetFishVector = nil
      fishingData[client].lastFishVectorSync = nil
      fishingData[client].fishVectorSyncVector = nil
    end
    if not isElement(fishingData[client].rodBendShader) then
      local rod = fishingRodSkin[client]
      fishingData[client].rodBendShader = dxCreateShader(getRodShaderSource(isElement(rodSkinCache[rod])))
      if isElement(rodSkinCache[rod]) then
        dxSetShaderValue(fishingData[client].rodBendShader, "ReplacedTexture", rodSkinCache[rod])
      end
      engineApplyShaderToWorldTexture(fishingData[client].rodBendShader, "v4_fishing_rod", fishingRods[client])
    end
  else
    if isElement(fishingData[client].rodBendShader) then
      destroyElement(fishingData[client].rodBendShader)
    end
    fishingData[client].rodBendShader = nil
  end
  if client == localPlayer then
    sealangCondHandl4(mode)
    sealangCondHandl5(mode)
    if mode then
      sealangCondHandl6(true)
      sealangCondHandl7(true)
    end
    if mode ~= "catched" and mode ~= "catching" then
      gotFishNoti(false)
    else
      gotFishNoti(mode)
    end
    setSyncerListEnabled(mode and mode ~= "idle")
    sealexports.seal_controls:toggleControl("all", mode or mode ~= "idle")
    if syncerListRealState then
      syncFishingData("mode")
    end
  end
end
function syncFishingData(data)
  if fishingData[localPlayer] then
    triggerServerEvent("syncFishingData", localPlayer, data, fishingData[localPlayer][data])
  end
end
local fishSyncOverwrite = {}
local fishSyncOverwritePlayer = {}
function doFishSyncOverwrite()
  for client in pairs(fishSyncOverwritePlayer) do
    if fishSyncOverwrite[client] and fishSyncOverwrite[client][1] then
      local data, value, multi = fishSyncOverwrite[client][1][1], fishSyncOverwrite[client][1][2], fishSyncOverwrite[client][1][3]
      table.remove(fishSyncOverwrite[client], 1)
      if fishingData[client] then
        if data == "mode" then
          setFishingMode(client, value, multi)
        else
          fishingData[client][data] = value
          if data == "spindleGear" then
            playGearSound(client)
          end
          if data == "targetFloatPos" then
            fishingData[client].floatSyncVector = {
              fishingData[client].targetFloatPos[1] - (fishingData[client].fishingFloatPos and fishingData[client].fishingFloatPos[1] or 0),
              fishingData[client].targetFloatPos[2] - (fishingData[client].fishingFloatPos and fishingData[client].fishingFloatPos[2] or 0),
              fishingData[client].targetFloatPos[3] - (fishingData[client].fishingFloatPos and fishingData[client].fishingFloatPos[3] or 0)
            }
          end
          if data == "targetFishVector" then
            fishingData[client].fishVectorSyncVector = {
              fishingData[client].targetFishVector[1] - (fishingData[client].fishVector and fishingData[client].fishVector[1] or 0),
              fishingData[client].targetFishVector[2] - (fishingData[client].fishVector and fishingData[client].fishVector[2] or 0)
            }
          end
          if data == "targetLineLength" then
            fishingData[client].lineLengthVector = fishingData[client].targetLineLength - (fishingData[client].lineLength or 0)
          end
          if data == "targetSpindleRoll" then
            fishingData[client].spindleRollVector = fishingData[client].targetSpindleRoll - (fishingData[client].spindleRoll or 0)
          end
        end
      end
    else
      fishSyncOverwritePlayer[client] = nil
    end
  end
  for client in pairs(fishSyncOverwritePlayer) do
    return
  end
  sealangCondHandl8(true)
end
addEvent("damageFishingLineSound", true)
addEventHandler("damageFishingLineSound", getRootElement(), function()
  if fishingRods[source] then
    local m = getElementMatrix(fishingRods[source])
    local rodEndX, rodEndY, rodEndZ = m[4][1] + m[3][1] * 3.43532, m[4][2] + m[3][2] * 3.43532, m[4][3] + m[3][3] * 3.43532
    playSound3D("files/snap.mp3", rodEndX, rodEndY, rodEndZ)
  end
end)
function gotSyncFishingData(data, value, multi)
  if not fishSyncOverwrite[source] then
    fishSyncOverwrite[source] = {}
  else
    for k = #fishSyncOverwrite[source], 1, -1 do
      if fishSyncOverwrite[source][k][1] == data then
        table.remove(fishSyncOverwrite[source], k)
      end
    end
  end
  table.insert(fishSyncOverwrite[source], {
    data,
    value,
    multi
  })
  if isElementStreamedIn(source) then
    fishSyncOverwritePlayer[source] = true
    sealangCondHandl8(true)
  end
end
addEvent("syncFishingData", true)
addEventHandler("syncFishingData", getRootElement(), gotSyncFishingData)
addEvent("syncMultiFishingData", true)
addEventHandler("syncMultiFishingData", getRootElement(), function(data)
  local mode = false
  if data.targetFloatPos then
    data.fishingFloatPos = data.targetFloatPos
  end
  if data.targetFishVector then
    data.fishVector = data.targetFishVector
  end
  if data.targetLineLength then
    data.lineLength = data.targetLineLength
  end
  if data.targetSpindleRoll then
    data.spindleRoll = data.targetSpindleRoll
  end
  for k, v in pairs(data) do
    if k == "mode" then
      mode = v
    else
      gotSyncFishingData(k, v, true)
    end
  end
  if mode then
    gotSyncFishingData("mode", mode, true)
  end
end)
function processFishingRod(client, rod)
  if fishingRodSkin[client] ~= rod then
    local was = fishingRodSkin[client]
    fishingRodSkin[client] = rod
    if rodSkinUsers[was] then
      for i = #rodSkinUsers[was], 1, -1 do
        if rodSkinUsers[was][i] == client then
          table.remove(rodSkinUsers[was], i)
        end
      end
      processRodSkinCache(was)
    end
    if rod then
      setFishingMode(client, "idle")
      if not isElement(fishingRods[client]) then
        fishingRods[client] = createObject(models.v4_fishing_rod, 0, 0, 0)
      end
      exports.pattach:attach(fishingRods[client], client, 24, 0.41828443255367, 0.031623268510538, 0.11513275195109, 0, 0, 0)
      exports.pattach:setRotationQuaternion(fishingRods[client], rodQ)
      exports.pattach:disableScreenCheck(fishingRods[client], true)
      local shader = getRodSkinCache(rod, client)
      if shader then
        engineApplyShaderToWorldTexture(shader, "v4_fishing_rod", fishingRods[client])
      end
      sealangCondHandl9(true)
      sealangCondHandl10(true)
      sealangCondHandl11(true, "low-99999999999")
    else
      setFishingMode(client, false)
      fishingData[client] = nil
      if isElement(fishingRods[client]) then
        destroyElement(fishingRods[client])
      end
      fishingRods[client] = nil
      for k in pairs(fishingRods) do
        return
      end
      sealangCondHandl9(false)
      sealangCondHandl10(false)
      sealangCondHandl11(false, "low-99999999999")
    end
  end
end
function processFishingRodLine(client, line)
  if fishingRodLine[client] ~= line then
    local was = fishingRodLine[client]
    fishingRodLine[client] = line
    if rodLineUsers[was] then
      for i = #rodLineUsers[was], 1, -1 do
        if rodLineUsers[was][i] == client then
          table.remove(rodLineUsers[was], i)
        end
      end
      local shader = processRodLineCache(was)
      if shader and isElement(fishingRods[client]) then
        engineRemoveShaderFromWorldTexture(shader, "v4_fishing_line", fishingRods[client])
      end
    end
    if line and isElement(fishingRods[client]) then
      local shader = getRodLineCache(line, client)
      if shader then
        engineApplyShaderToWorldTexture(shader, "v4_fishing_line", fishingRods[client])
      end
    end
    if not line and fishingData[client] and fishingData[client].mode and fishingData[client].mode ~= "idle" then
      setFishingMode(client, "idle")
    end
  end
end
function processFishingRodFloat(client, float)
  float = float and float - 1
  if fishingRodFloat[client] ~= float then
    local was = fishingRodFloat[client]
    fishingRodFloat[client] = float
    if rodFloatSkinUsers[was] then
      for i = #rodFloatSkinUsers[was], 1, -1 do
        if rodFloatSkinUsers[was][i] == client then
          table.remove(rodFloatSkinUsers[was], i)
        end
      end
      local shader = processRodFloatSkinCache(was)
      if shader and isElement(fishingFloats[client]) then
        engineRemoveShaderFromWorldTexture(shader, "v4_fishing_bobber", fishingFloats[client])
      end
    end
    if float then
      if not isElement(fishingFloats[client]) then
        fishingFloats[client] = createObject(models.v4_fishing_bobber, 0, 0, 0)
        setElementCollisionsEnabled(fishingFloats[client], false)
      end
      local shader = getRodFloatSkinCache(float, client)
      if shader then
        engineApplyShaderToWorldTexture(shader, "v4_fishing_bobber", fishingFloats[client])
      end
    else
      if fishingData[client] and fishingData[client].mode and fishingData[client].mode ~= "idle" then
        setFishingMode(client, "idle")
      end
      if isElement(fishingFloats[client]) then
        destroyElement(fishingFloats[client])
      end
      fishingFloats[client] = nil
    end
  end
end
function removeFishingRod()
  processFishingRod(source, false)
  processFishingRodLine(source, false)
  processFishingRodFloat(source, false)
  processPreviewFish(source, false)
  fishingData[source] = nil
  fishSyncOverwritePlayer[source] = nil
  fishSyncOverwrite[source] = nil
end
addEventHandler("onClientElementStreamOut", getRootElement(), removeFishingRod)
addEventHandler("onClientPlayerQuit", getRootElement(), removeFishingRod)
addEventHandler("onClientElementStreamIn", getRootElement(), function()
  if getElementType(source) == "player" then
    local rod = getElementData(source, "usingFishingRod")
    if rod then
      processFishingRod(source, rod)
    else
      sealexports.seal_controls:toggleControl("all", true)
    end
    local line = getElementData(source, "usingFishingRodLine")
    if line then
      processFishingRodLine(source, line)
    end
    local float = getElementData(source, "usingFishingRodFloat")
    if float then
      processFishingRodFloat(source, float)
    end
    local preview = getElementData(source, "previewFish")
    if preview then
      processPreviewFish(source, preview)
    end
    if fishSyncOverwrite[source] then
      fishSyncOverwritePlayer[source] = true
      sealangCondHandl8(true)
    end
  end
end)
addEventHandler("onClientElementDataChange", getRootElement(), function(data, old, new)
  if getElementType(source) == "player" then
    if isElementStreamedIn(source) then
      if data == "usingFishingRod" then
        processFishingRod(source, new)
      elseif data == "usingFishingRodLine" then
        processFishingRodLine(source, new)
      elseif data == "usingFishingRodFloat" then
        processFishingRodFloat(source, new)
      elseif data == "previewFish" then
        processPreviewFish(source, new)
      end
    end
  end
end)
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  engineLoadIFP("files/bedobas.ifp", "fishing_bedobas")
  engineLoadIFP("files/kihuzas.ifp", "fishing_kihuzas")
  engineLoadIFP("files/fishingstand.ifp", "fishing_stand")
  engineLoadIFP("files/halpoz.ifp", "halpoz")
end)
local previewFishObject = {}
local previewFishData = {}
function processPreviewFish(client, data)
  if isElement(previewFishObject[client]) then
    destroyElement(previewFishObject[client])
  end
  previewFishObject[client] = nil
  if data then
    local fishType = fishTypes[data[1]]
    if fishType and fishType.modelId and fishType.previewLength and fishType.height then
      previewFishObject[client] = createObject(fishType.modelId, 0, 0, 0)
      previewFishData[client] = data
      local scale = fishType.scale or 1
      if data[2] and type(fishType.weight) == "table" then
        scale = (data[2] - fishType.weight[1]) / (fishType.weight[2] - fishType.weight[1]) * (fishType.weight[4] - fishType.weight[3]) + fishType.weight[3]
      end
      setObjectScale(previewFishObject[client], scale)
      previewFishData[client] = {
        fishType.previewLength * scale,
        fishType.height * scale
      }
      setPedAnimation(client, "halpoz", "camcrch_idleloop", -1, true, false, false, true, 0)
      sealangCondHandl12(true)
      setElementDimension(previewFishObject[client], getElementDimension(client))
      setElementInterior(previewFishObject[client], getElementInterior(client))
      setElementCollisionsEnabled(previewFishObject[client], false)
    else
      previewFishData[client] = nil
      setPedAnimation(client)
    end
  else
    previewFishData[client] = nil
    setPedAnimation(client)
  end
end
function preRenderPreviewFish()
  local canEnd = true
  for client, data in pairs(previewFishData) do
    local a1, a2 = getPedAnimation(client)
    if a1 ~= "halpoz" or a2 ~= "camcrch_idleloop" then
      setPedAnimation(client, "halpoz", "camcrch_idleloop", -1, true, false, false, true, 0)
    end
    local bm = getElementBoneMatrix(client, 25)
    local bm2 = getElementBoneMatrix(client, 24)
    for i = 1, 3 do
      for j = 1, 3 do
        bm[i][j] = (bm[i][j] + bm2[i][j]) / 2
      end
    end
    local bx, by, bz = getPedBonePosition(client, 35)
    local vx, vy, vz = bm[4][1] - bx, bm[4][2] - by, bm[4][3] - bz
    local len = math.sqrt(vx * vx + vy * vy + vz * vz)
    bm[4][1], bm[4][2], bm[4][3] = (bm[4][1] + bx) / 2 + vx / len * data[1], (bm[4][2] + by) / 2 + vy / len * data[1], (bm[4][3] + bz) / 2 + vz / len * data[1]
    bm[4][1], bm[4][2], bm[4][3] = bm[4][1] + bm[2][1] * data[2], bm[4][2] + bm[2][2] * data[2], bm[4][3] + bm[2][3] * data[2]
    setElementMatrix(previewFishObject[client], {
      bm[3],
      bm[1],
      bm[2],
      bm[4]
    })
    canEnd = false
  end
  if canEnd then
    sealangCondHandl12(false)
  end
end
local smallSellPos = {}
local bigSellPos = {}
local smallSellScreen = {}
local bigSellScreen = {}
local fishStandObject = {}
function loadModels()
  models.v4_fishing_rod = 2993
  models.v4_fishing_bobber = 1702
  models.v4_fishing_tournamentsign = 16339
  models.des_baitshop_props = 3410
  models.des_baitshop_door = 11523
  for i = 1, #dropoffPoses do
    local x, y, z, r = unpack(dropoffPoses[i])
    createObject(models.des_baitshop_props, x, y, z, 0, 0, r)
    fishStandObject[i] = createObject(18233, x, y, z, 0, 0, r)
    local lod = createObject(18233, x, y, z, 0, 0, r, true)
    setLowLODElement(fishStandObject[i], lod)
    local rad = math.rad(r)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    createObject(models.des_baitshop_door, x + cos * 3.3531 + sin * 0.0179, y + sin * 3.3531 - cos * 0.0179, z + 1.604, 0, 0, r)
    local ped = createPed(158, x + cos * 4 - sin * 2, y + sin * 4 + cos * 2, z + 0.925, r - 60)
    setElementData(ped, "visibleName", "Haller Babó")
    setElementData(ped, "invulnerable", true)
    setElementFrozen(ped, true)
    table.insert(displayPoses, {
      x + cos * 4.404 + sin * 2.2,
      y + sin * 4.404 - cos * 2.2,
      z + 1.504,
      r + 25
    })
    smallSellPos[i] = {
      x + cos * 5.503 - sin * 2.398,
      y + sin * 5.503 + cos * 2.398,
      z + 1.5
    }
    bigSellPos[i] = {
      x + cos * 5.503 - sin * 3.2823,
      y + sin * 5.503 + cos * 3.2823,
      z + 2.2
    }
    local w = -0.02916666666666667
    local sx, sy, sz, vx, vy = x + cos * 5.53 - sin * 2.4016, y + sin * 5.53 + cos * 2.4016, z + 1.8888, sin, -cos
    sx, sy = sx - vx * w, sy - vy * w
    smallSellScreen[i] = {}
    table.insert(smallSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 0.025
    sy = sy - vy * 0.025
    table.insert(smallSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 1 / 3 * 0.025
    sy = sy - vy * 1 / 3 * 0.025
    table.insert(smallSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 0.025
    sy = sy - vy * 0.025
    table.insert(smallSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    local sx, sy, sz, vx, vy = x + cos * 5.53 - sin * 3.2859, y + sin * 5.53 + cos * 3.2859, z + 2.5888, sin, -cos
    sx, sy = sx - vx * w, sy - vy * w
    bigSellScreen[i] = {}
    table.insert(bigSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 0.025
    sy = sy - vy * 0.025
    table.insert(bigSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 1 / 3 * 0.025
    sy = sy - vy * 1 / 3 * 0.025
    table.insert(bigSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
    sx = sx - vx * 0.025
    sy = sy - vy * 0.025
    table.insert(bigSellScreen[i], {
      sx,
      sy,
      sz,
      sx - vy,
      sy + vx
    })
  end
  local players = getElementsByType("player", getRootElement(), true)
  for i = 1, #players do
    local rod = getElementData(players[i], "usingFishingRod")
    if rod then
      processFishingRod(players[i], rod)
    end
    local line = getElementData(players[i], "usingFishingRodLine")
    if line then
      processFishingRodLine(players[i], line)
    end
    local float = getElementData(players[i], "usingFishingRodFloat")
    if float then
      processFishingRodFloat(players[i], float)
    end
    local preview = getElementData(players[i], "previewFish")
    if preview then
      processPreviewFish(players[i], preview)
    end
  end
  for k in pairs(fishTypes) do
    if fishTypes[k].model then
      fishTypes[k].modelId = fishTypes[k].model
    end
  end
  triggerServerEvent("requestFishStand", localPlayer)
  triggerServerEvent("requestFishingEvent", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, loadModels)
function fishingLineOffset(m, offX, offY, offZ, tensionD, tensionR)
  local h = offZ - 1.4
  if 0 < h then
    h = h / 2
    offX = offX + (1 - math.cos(h * 1.57)) * tensionD
    offY = offY + (1 - math.cos(h * 1.57)) * tensionR
    offZ = offZ - 0.5 * h * (1 - math.cos(tensionD * 1.57))
  end
  local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
  local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
  local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
  return x, y, z
end
function drawWaterTestLine(x, y, z, x2, y2, z2, r, g, b)
  local water, wx, wy, wz = testLineAgainstWater(x, y, z, x2, y2, z2)
  if water then
    dxDrawLine3D(x, y, z, wx, wy, wz, tocolor(r, g, b, 100), 0.25)
    dxDrawLine3D(wx, wy, wz, x2, y2, z2, tocolor(r / 2, g / 2, b / 2, 50), 0.5)
  else
    water, wx, wy, wz = testLineAgainstWater(x, y, 1000, x, y, math.max(z2, z))
    if water then
      dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(r / 2, g / 2, b / 2, 50), 0.5)
    else
      dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(r, g, b, 100), 0.25)
    end
  end
end
function drawFishingLine(m, vis, lineTension, tensionD, tensionR, r, g, b, tx, ty, tz, fx, fy, fz)
  local x, y, z, lx, ly, lz
  if vis then
    lx, ly, lz = fishingLineOffset(m, 0.0957, 0.003, 0.5462, tensionD, tensionR)
    x, y, z = fishingLineOffset(m, 0.0546, 0.0338, 0.5409, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
    x, y, z = fishingLineOffset(m, 0.0227, 0.0034, 0.7411, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
    x, y, z = fishingLineOffset(m, 0.0186, 0.0034, 1.4063, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
    x, y, z = fishingLineOffset(m, 0.0186, 0.0034, 2.07, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
    x, y, z = fishingLineOffset(m, 0.0156, 0.0034, 2.7136, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
    x, y, z = fishingLineOffset(m, 0.0109, -0, 3.457, tensionD, tensionR)
    dxDrawLine3D(x, y, z, lx, ly, lz, tocolor(r, g, b, 100), 0.25)
    lx, ly, lz = x, y, z
  elseif tx then
    lx, ly, lz = fishingLineOffset(m, 0.0109, -0, 3.457, tensionD, tensionR)
  end
  if tx then
    if 1 <= lineTension then
      drawWaterTestLine(lx, ly, lz, tx, ty, tz, r, g, b)
    else
      local t = 1 - math.max(-0, lineTension)
      local d = getDistanceBetweenPoints3D(lx, ly, lz, tx, ty, tz)
      d = tonumber(d) or 1
      d = math.max(10, math.min(40, math.ceil(d / 2.5)))
      local vx = (tx - lx) / d
      local vy = (ty - ly) / d
      local vz = (tz - lz) / d
      for i = 1, d do
        local p1 = math.sin(math.pow((i - 1) / d, 0.7) * math.pi)
        local p2 = math.sin(math.pow(i / d, 0.7) * math.pi)
        drawWaterTestLine(lx, ly, lz - p1 * t, lx + vx, ly + vy, lz + vz - p2 * t, r, g, b)
        lx = lx + vx
        ly = ly + vy
        lz = lz + vz
      end
    end
    dxDrawLine3D(tx, ty, tz, fx, fy, fz, tocolor(r / 2, g / 2, b / 2, 50), 0.5)
  end
  return lx, ly, lz
end
local delta = 0
local now = 0
local lastAim = 0
function keyPlayer(key, por)
  if modeSpindleNeeded(fishingData[localPlayer].mode) then
    if key == "mouse_wheel_up" then
      local gear = 1 + (fishingData[localPlayer].spindleGear or 0) * 0.35
      fishingData[localPlayer].lineVelocity = (fishingData[localPlayer].lineVelocity or 0) + 0.25 * gear
      fishingData[localPlayer].targetSpindleRoll = (fishingData[localPlayer].targetSpindleRoll or 0) - 0.1
      fishingData[localPlayer].spindleRollVector = fishingData[localPlayer].targetSpindleRoll - (fishingData[localPlayer].spindleRoll or 0)
    elseif key == "mouse_wheel_down" then
      local gear = 1 + (fishingData[localPlayer].spindleGear or 0) * 0.35
      fishingData[localPlayer].lineVelocity = (fishingData[localPlayer].lineVelocity or 0) - 0.25 * gear
      fishingData[localPlayer].targetSpindleRoll = (fishingData[localPlayer].targetSpindleRoll or 0) + 0.1
      fishingData[localPlayer].spindleRollVector = fishingData[localPlayer].targetSpindleRoll - (fishingData[localPlayer].spindleRoll or 0)
    elseif por then
      if key == "lshift" then
        local gear = fishingData[localPlayer].spindleGear or 0
        if gear < 4 then
          fishingData[localPlayer].spindleGear = gear + 1
          syncFishingData("spindleGear")
          playGearSound(localPlayer)
        end
      elseif key == "lctrl" then
        local gear = fishingData[localPlayer].spindleGear or 0
        if 0 < gear then
          fishingData[localPlayer].spindleGear = gear - 1
          syncFishingData("spindleGear")
          playGearSound(localPlayer)
        end
      end
    end
  end
end
local screenX, screenY = guiGetScreenSize()
local tensionGradient1, tensionGradient2, successGradient, minigameGradient
function guiRefreshed()
  tensionGradient1 = sealexports.seal_gui:getGradient3Filename(350, 2, sealexports.seal_gui:getColorCode("blue"), sealexports.seal_gui:getColorCode("yellow"))
  tensionGradient2 = sealexports.seal_gui:getGradient3Filename(350, 2, sealexports.seal_gui:getColorCode("yellow"), sealexports.seal_gui:getColorCode("red"))
  successGradient = sealexports.seal_gui:getGradientFilename(512, 512, sealexports.seal_gui:getColorCode("grey1"), sealexports.seal_gui:getColorCode("blue"))
  minigameGradient = sealexports.seal_gui:getGradient3Filename(256, 2, sealexports.seal_gui:getColorCode("blue"), sealexports.seal_gui:getColorCode("green"))
end
local guiData = {
  tensionA = 0,
  spindleA = 0,
  lineLength = 0,
  spindleRoll = 0,
  spindleGear = 0,
  tension = 0,
  floatA = 0,
  floatWater = 0,
  inDeepWater = false,
  gotFishA = 0,
  gotFishState = false
}
function gotFishNoti(state)
  if state then
    sealangCondHandl6(true)
    sealangCondHandl7(true)
    if not guiData.gotFishState then
      playSound("files/gotfish.mp3")
    end
    guiData.gotFishState = state == "catching" and true or 5000
  else
    guiData.gotFishState = false
  end
end
function preRenderPlayerGui(delta)
  if fishingData[localPlayer] and fishingData[localPlayer].mode then
    if modeInWaterFishing(fishingData[localPlayer].mode) then
      guiData.tensionA = math.min(1, guiData.tensionA + 3 * delta / 1000)
      guiData.floatA = math.min(1, guiData.floatA + 3 * delta / 1000)
      local floatZ = fishingData[localPlayer].fishingFloatPos[4] or fishingData[localPlayer].fishingFloatPos[3]
      if guiData.inDeepWater then
        guiData.floatWater = floatZ - guiData.inDeepWater - (fishingData[localPlayer].lineUnderwater or 0) * 1.25
      else
        guiData.floatWater = false
      end
    else
      if guiData.tensionA > 0 then
        guiData.tensionA = math.max(0, guiData.tensionA - 3 * delta / 1000)
        if guiData.tensionA <= 0 then
          guiData.tension = 0
        end
      end
      if guiData.floatA > 0 then
        guiData.floatA = math.max(0, guiData.floatA - 3 * delta / 1000)
        if guiData.floatA <= 0 then
          guiData.floatWater = 0
        end
      end
    end
    if fishingData[localPlayer].mode ~= "idle" and fishingData[localPlayer].mode ~= "aim" then
      guiData.fishingLineColor = fishingRodLine[localPlayer]
      guiData.tension = fishingData[localPlayer].tension or 0
      guiData.spindleA = math.min(1, guiData.spindleA + 3 * delta / 1000)
      if fishingData[localPlayer].lineLength then
        guiData.lineLength = fishingData[localPlayer].lineLength
      end
      if fishingData[localPlayer].spindleRoll then
        guiData.spindleRoll = fishingData[localPlayer].spindleRoll
      end
      if fishingData[localPlayer].spindleGear then
        if guiData.spindleGear < fishingData[localPlayer].spindleGear then
          guiData.spindleGear = guiData.spindleGear + 4 * delta / 1000
          if guiData.spindleGear > fishingData[localPlayer].spindleGear then
            guiData.spindleGear = fishingData[localPlayer].spindleGear
          end
        end
        if guiData.spindleGear > fishingData[localPlayer].spindleGear then
          guiData.spindleGear = guiData.spindleGear - 4 * delta / 1000
          if guiData.spindleGear < fishingData[localPlayer].spindleGear then
            guiData.spindleGear = fishingData[localPlayer].spindleGear
          end
        end
      end
    elseif 0 < guiData.spindleA then
      guiData.spindleA = math.max(0, guiData.spindleA - 3 * delta / 1000)
      if 0 >= guiData.spindleA then
        guiData.lineLength = 0
        guiData.spindleRoll = 0
        guiData.spindleGear = 0
        guiData.inDeepWater = false
      end
    end
    if guiData.gotFishState then
      guiData.gotFishA = math.min(1, guiData.gotFishA + 3 * delta / 600)
      if tonumber(guiData.gotFishState) then
        guiData.gotFishState = guiData.gotFishState - delta
        if 0 >= guiData.gotFishState then
          guiData.gotFishState = false
        end
      end
    else
      guiData.gotFishA = math.max(0, guiData.gotFishA - 3 * delta / 5000)
    end
  else
    guiData.gotFishState = false
    guiData.tensionA = math.max(0, guiData.tensionA - 3 * delta / 1000)
    guiData.spindleA = math.max(0, guiData.spindleA - 3 * delta / 1000)
    guiData.floatA = math.max(0, guiData.floatA - 3 * delta / 1000)
    guiData.gotFishA = math.max(0, guiData.gotFishA - 3 * delta / 5000)
    if 0 >= guiData.tensionA + guiData.spindleA + guiData.floatA + guiData.gotFishA then
      sealangCondHandl6(false)
      sealangCondHandl7(false)
      guiData.tension = 0
      guiData.lineLength = 0
      guiData.spindleRoll = 0
      guiData.spindleGear = 0
      guiData.floatWater = 0
      guiData.inDeepWater = false
    end
  end
end
function renderPlayer()
  if guiData.tensionA > 0 then
    local tension = guiData.tension
    local y = math.floor(screenY * 0.85)
    dxDrawRectangle(screenX / 2 - 350 - 3 - 1, y - 3 - 1, 708, 1, tocolor(255, 255, 255, 150 * guiData.tensionA))
    dxDrawRectangle(screenX / 2 - 350 - 3 - 1, y + 16 + 3, 708, 1, tocolor(255, 255, 255, 150 * guiData.tensionA))
    dxDrawRectangle(screenX / 2 - 350 - 3 - 1, y - 3, 1, 22, tocolor(255, 255, 255, 150 * guiData.tensionA))
    dxDrawRectangle(screenX / 2 + 350 + 3, y - 3, 1, 22, tocolor(255, 255, 255, 150 * guiData.tensionA))
    dxDrawRectangle(screenX / 2 - 350 - 3, y - 3, 706, 22, tocolor(255, 255, 255, 50 * guiData.tensionA))
    local p = math.min(1, math.max(0, tension))
    if 0 < p then
      dxDrawImageSection(screenX / 2 - 350, y, 350 * math.min(1, p / 0.5), 16, 0, 0, 350 * math.min(1, p / 0.5), 2, ":seal_gui/" .. tensionGradient1 .. "." .. gradientTick[tensionGradient1], 0, 0, 0, tocolor(255, 255, 255, 255 * guiData.tensionA))
    end
    if 0.5 < p then
      dxDrawImageSection(screenX / 2, y, 350 * math.min(1, (p - 0.5) / 0.5), 16, 0, 0, 350 * math.min(1, (p - 0.5) / 0.5), 2, ":seal_gui/" .. tensionGradient2 .. "." .. gradientTick[tensionGradient2], 0, 0, 0, tocolor(255, 255, 255, 255 * guiData.tensionA))
    end
    dxDrawRectangle(screenX / 2 - 350, y, 700 * p, 8, tocolor(255, 255, 255, 100 * guiData.tensionA))
    if 0.6 < tension then
      local a = math.min(1, (tension - 0.6) / 0.4)
      sealangStaticImageUsed[0] = true
      if sealangStaticImageToc[0] then
        processsealangStaticImage[0]()
      end
      dxDrawImage(screenX / 2 - 350 + 700 * (p - 1) - 16, y - 16, 732, 48, sealangStaticImage[0], 0, 0, 0, tocolor(red[1], red[2], red[3], 255 * a * guiData.tensionA))
    end
    local w = 116.66666666666667
    for i = 1, 5 do
      local x = screenX / 2 - 350 + w * i
      dxDrawRectangle(x - 1, y - 3, 2, 22, tocolor(255, 255, 255, 100 * guiData.tensionA))
    end
  end
  if 0 < guiData.spindleA then
    local r = tocolor(red[1], red[2], red[3], 255 * guiData.spindleA)
    local c = tocolor(255, 255, 255, 255 * guiData.spindleA)
    local col = fishingLineColors[guiData.fishingLineColor]
    local c2 = tocolor(col[1], col[2], col[3], 255 * guiData.spindleA)
    local g = tocolor(grey1[1], grey1[2], grey1[3], 255 * guiData.spindleA)
    local y = 16 + 128 * guiData.floatA
    local s = 64 * (1 - 0.3 * guiData.lineLength / 100)
    sealangStaticImageUsed[1] = true
    if sealangStaticImageToc[1] then
      processsealangStaticImage[1]()
    end
    dxDrawImage(screenX - 24 - 64 - s, screenY - y - 64 - s, s * 2, s * 2, sealangStaticImage[1], 0, 0, 0, c2)
    sealangStaticImageUsed[2] = true
    if sealangStaticImageToc[2] then
      processsealangStaticImage[2]()
    end
    dxDrawImage(screenX - 24 - 128, screenY - y - 128, 128, 128, sealangStaticImage[2], 0, 0, 0, g)
    sealangStaticImageUsed[3] = true
    if sealangStaticImageToc[3] then
      processsealangStaticImage[3]()
    end
    dxDrawImage(screenX - 24 - 128, screenY - y - 128, 128, 128, sealangStaticImage[3], 0, 0, 0, c)
    sealangStaticImageUsed[4] = true
    if sealangStaticImageToc[4] then
      processsealangStaticImage[4]()
    end
    dxDrawImage(screenX - 24 - 128, screenY - y - 128, 128, 128, sealangStaticImage[4], -(guiData.lineLength / 1.15) * 360, 0, 0, c)
    sealangStaticImageUsed[5] = true
    if sealangStaticImageToc[5] then
      processsealangStaticImage[5]()
    end
    dxDrawImage(screenX - 24 - 128, screenY - y - 128, 128, 128, sealangStaticImage[5], -(guiData.spindleRoll or 0) * 360, 0, 0, c)
    sealangStaticImageUsed[6] = true
    if sealangStaticImageToc[6] then
      processsealangStaticImage[6]()
    end
    dxDrawImage(screenX - 24 - 128, screenY - y - 128, 128, 128, sealangStaticImage[6], -(guiData.spindleRoll or 0) * 360, 0, 0, r)
    local x = screenX - 24 - 110 - (gearboxWidth + 4) * 5
    dxDrawRectangle(x + guiData.spindleGear * (gearboxWidth + 4), screenY - y - 6 - gearboxHeight, gearboxWidth, gearboxHeight, tocolor(yellow[1], yellow[2], yellow[3], 255 * guiData.spindleA))
    for i = 1, 5 do
      local d = math.min(1, math.abs(i - (guiData.spindleGear + 1)))
      local r = (255 - grey1[1]) * d + grey1[1]
      local g = (255 - grey1[2]) * d + grey1[2]
      local b = (255 - grey1[3]) * d + grey1[3]
      dxDrawText(i, x, 0, x + gearboxWidth, screenY - y - 6, tocolor(r, g, b, 255 * guiData.spindleA), gearboxFontScale, gearboxFont, "center", "bottom")
      x = x + gearboxWidth + 4
    end
    dxDrawText("." .. math.floor(guiData.lineLength % 1 * 10) .. " m", screenX - 16 - distanceFontExWidth, 0, 0, screenY - y - 6, c, distanceFontExScale, distanceFontEx, "left", "bottom")
    dxDrawText(math.floor(guiData.lineLength), 0, 0, screenX - 16 - distanceFontExWidth, screenY - y - 6, c, distanceFontScale, distanceFont, "right", "bottom")
  end
  if 0 < guiData.floatA then
    local x = screenX - 16 - 110 - (gearboxWidth + 4) * 5
    local y = screenY - 144
    local w = screenX - 16 - x
    local h = 128
    local fx = x + w / 2 - 8
    local fy = y + h / 2
    sealangStaticImageUsed[7] = true
    if sealangStaticImageToc[7] then
      processsealangStaticImage[7]()
    end
    dxDrawImage(fx, fy - 32, 16, 64, sealangStaticImage[7], 90 * math.abs(guiData.tension or 0) * (0 > (guiData.tension or 0) and -0.15 or 1), 0, 0, tocolor(255, 255, 255, 255 * guiData.floatA))
    if guiData.floatWater then
      local level = guiData.floatWater * 64
      local a = 1
      local abs = math.abs(level)
      if abs > h / 2 * 0.9 then
        a = (h / 2 - abs) / (h / 2 * 0.1)
      end
      if 0 < a then
        local wy = y + h / 2 - 2 + level
        sealangStaticImageUsed[8] = true
        if sealangStaticImageToc[8] then
          processsealangStaticImage[8]()
        end
        dxDrawImage(x, wy, w, 4, sealangStaticImage[8], 0, 0, 0, tocolor(255, 255, 255, 255 * guiData.floatA * a))
      end
    end
  end
  if 0 < guiData.gotFishA then
    local y = math.floor(screenY * 0.2)
    local a = math.min(1, guiData.gotFishA * 5)
    sealangStaticImageUsed[9] = true
    if sealangStaticImageToc[9] then
      processsealangStaticImage[9]()
    end
    dxDrawImage(screenX / 2 - 512 * guiData.gotFishA, y, 1024 * guiData.gotFishA, 128, sealangStaticImage[9], 0, 0, 0, tocolor(yellow[1], yellow[2], yellow[3], 255 * a))
    local p = guiData.gotFishA * guiData.gotFishA
    sealangStaticImageUsed[10] = true
    if sealangStaticImageToc[10] then
      processsealangStaticImage[10]()
    end
    dxDrawImageSection(screenX / 2 - 512 * p, y, 1024 * p, 128, 512 * (1 - p), 0, 1024 * p, 128, sealangStaticImage[10], 0, 0, 0, tocolor(grey1[1], grey1[2], grey1[3], 255 * a))
  end
end
local damageNoti = false
function preRenderPlayer(delta)
  if fishingData[localPlayer].mode == "getout" then
    local p = math.min(1, (now - fishingData[localPlayer].getOutStart) / 4000)
    if p >= (fishingData[localPlayer].fish and 1 or 0.5) then
      setFishingMode(localPlayer, "idle")
    end
  elseif fishingData[localPlayer].mode == "idle" then
    if fishingRodFloat[localPlayer] and getElementDimension(localPlayer) <= 0 and 0 >= getElementInterior(localPlayer) and getKeyState("mouse2") and 500 < now - lastAim and not isPedInVehicle(localPlayer) and not isElementInWater(localPlayer) then
      setFishingMode(localPlayer, "aim")
      lastAim = now
    else
      damageNoti = false
    end
  elseif fishingData[localPlayer].mode == "aim" then
    if fishingData[localPlayer].throwing then
      if not getKeyState("mouse1") then
        fishingData[localPlayer].throwing = false
        syncFishingData("throwing")
        if fishingData[localPlayer].throwingTension > 0.25 then
          setFishingMode(localPlayer, "throw")
          local force = fishingData[localPlayer].throwingTension
          local cx, cy, cz, ctx, cty, ctz = getCameraMatrix()
          local cr = math.atan2(cty - cy, ctx - cx)
          local rx, ry, rz = getElementRotation(localPlayer)
          rz = math.rad(rz)
          cr = cr - rz - math.pi / 2
          cr = (cr + math.pi) % (math.pi * 2) - math.pi
          cr = math.max(-math.pi / 4, math.min(math.pi / 4, cr)) + rz + math.pi / 2
          fishingData[localPlayer].fishingThrowForce = {
            math.cos(cr),
            math.sin(cr),
            force * 60,
            force * 15
          }
          syncFishingData("fishingFloatPos")
          syncFishingData("fishingThrowForce")
        end
      end
    elseif getKeyState("mouse1") and 500 < now - lastAim then
      lastAim = now
      fishingData[localPlayer].throwing = true
      fishingData[localPlayer].throwingTension = 0
      syncFishingData("throwing")
    end
    if not getKeyState("mouse2") or not fishingRodFloat[localPlayer] then
      fishingData[localPlayer].throwing = false
      setFishingMode(localPlayer, "idle")
    end
  end
  if modePlayerRotationNeeded(fishingData[localPlayer].mode) then
    local cx, cy, cz, ctx, cty, ctz = getCameraMatrix()
    local cr = math.atan2(cty - cy, ctx - cx)
    local rx, ry, rz = getElementRotation(localPlayer)
    cr = cr - math.rad(rz) - math.pi / 2
    cr = (cr + math.pi) % (math.pi * 2) - math.pi
    fishingData[localPlayer].targetPlayerRot = math.max(-45, math.min(67, math.deg(cr))) - 22
    if 0 < syncNum and 1 < math.abs((fishingData[localPlayer].syncedPlayerRot or 0) - fishingData[localPlayer].targetPlayerRot) then
      if not fishingData[localPlayer].lastRotSync then
        fishingData[localPlayer].lastRotSync = now
      end
      local t = 200 + math.floor(syncNum / 10) * 50
      if t <= now - fishingData[localPlayer].lastRotSync then
        fishingData[localPlayer].syncedPlayerRot = fishingData[localPlayer].targetPlayerRot
        fishingData[localPlayer].lastRotSync = now
        syncFishingData("targetPlayerRot")
      end
    end
  end
end
function preRenderRods(d)
  delta = d
  now = getTickCount()
  for client, data in pairs(fishingData) do
    if modeSpindleNeeded(data.mode) then
      setPedAnimationProgress(client, "bather", (fishingData[client].spindleRoll or 0) % 1)
    elseif data.mode == "throw" then
      data.throwingTension = math.max(0, (data.throwingTension or 0) - delta / 250)
      local a1, a2 = getPedAnimation(client)
      local at = 0 < data.throwingTension and "fishing_bedobas" or "fishing_stand"
      if a1 ~= at or a2 ~= "bather" then
        setPedAnimation(client, at, "bather", -1, true, false, false, true, 0)
      end
      setPedAnimationProgress(client, "bather", data.throwingTension * 0.825 + 0.15)
    elseif data.mode == "aim" then
      if data.throwing then
        data.throwingTension = math.min(1, (data.throwingTension or 0) + delta / 2000)
      else
        data.throwingTension = math.max(0, (data.throwingTension or 0) - delta / 2000)
      end
      setPedAnimationProgress(client, "bather", (data.throwingTension or 0) * 0.825 + 0.15)
    end
    if data.targetPlayerRot and data.playerRot ~= data.targetPlayerRot then
      local cr = (data.playerRot or 0) - data.targetPlayerRot
      if 0 < cr then
        data.playerRot = math.max(data.targetPlayerRot, (data.playerRot or 0) - 180 * delta / 1000)
      end
      if cr < 0 then
        data.playerRot = math.min(data.targetPlayerRot, (data.playerRot or 0) + 180 * delta / 1000)
      end
    end
  end
end
function pedsProcessedBones()
  for client, data in pairs(fishingData) do
    if modePlayerRotationNeeded(data.mode) then
      local a1, a2 = getPedAnimation(client)
      if modeSpindleNeeded(data.mode) then
        if a1 ~= "fishing_stand" or a2 ~= "bather" then
          setPedAnimation(client, "fishing_stand", "bather", -1, true, false, false, true, 0)
        end
      elseif data.mode ~= "throw" and data.mode ~= "getout" and (a1 ~= "fishing_bedobas" or a2 ~= "bather") then
        setPedAnimation(client, "fishing_bedobas", "bather", -1, true, false, false, true, 0)
      end
      if not isElementOnScreen(client) then
        setElementBoneRotation(client, 2, -0.8259938955307 + (data.playerRot or 0) / 2, 3.4172387123108, -0.47918018698692)
        setElementBoneRotation(client, 3, -1.5559765100479 + (data.playerRot or 0) / 2, 6.2390885353088, -0.61579948663712)
      else
        local rx, ry, rz = getElementBoneRotation(client, 2)
        setElementBoneRotation(client, 2, rx + (data.playerRot or 0) / 2, ry, rz)
        local rx, ry, rz = getElementBoneRotation(client, 3)
        setElementBoneRotation(client, 3, rx + (data.playerRot or 0) / 2, ry, rz)
      end
      updateElementRpHAnim(client)
    end
  end
end
function playGearSound(client)
  local m = getElementMatrix(fishingRods[client])
  playSound3D("files/gear.mp3", m[4][1] + m[3][1] * 0.5462, m[4][2] + m[3][2] * 0.5462, m[4][3] + m[3][3] * 0.5462)
end
function processReelSound(client, m, spd)
  if fishingData[client].reelSound then
    if 0 < spd then
      spd = spd / 10
      setElementPosition(fishingData[client].reelSound, m[4][1] + m[3][1] * 0.5462, m[4][2] + m[3][2] * 0.5462, m[4][3] + m[3][3] * 0.5462)
      setSoundVolume(fishingData[client].reelSound, math.min(1, spd * 3))
      setSoundSpeed(fishingData[client].reelSound, math.min(2, 0.75 + spd))
    else
      setSoundVolume(fishingData[client].reelSound, 0)
    end
  end
end
function processSpindleSound(client, m, spd)
  if fishingData[client].spindleSound then
    if 0 < spd then
      spd = spd / 7.5
      setElementPosition(fishingData[client].spindleSound, m[4][1] + m[3][1] * 0.5462, m[4][2] + m[3][2] * 0.5462, m[4][3] + m[3][3] * 0.5462)
      setSoundVolume(fishingData[client].spindleSound, math.min(1, spd * 3) * 1.5)
      setSoundSpeed(fishingData[client].spindleSound, math.min(2, 0.5 + spd))
    else
      setSoundVolume(fishingData[client].spindleSound, 0)
    end
  end
end
function isNaN(n)
  return n ~= n
end
function pedsProcessedRods()
  for client, rod in pairs(fishingRods) do
    if fishingRodLine[client] then
      local selfPlayer = client == localPlayer
      local screen = isElementOnScreen(rod)
      local m = getElementMatrix(rod)
      local col = fishingLineColors[fishingRodLine[client]]
      local r, g, b = col[1], col[2], col[3]
      if modeInWater(fishingData[client].mode) and fishingFloats[client] then
        local rodEndX, rodEndY, rodEndZ = m[4][1] + m[3][1] * 3.43532, m[4][2] + m[3][2] * 3.43532, m[4][3] + m[3][3] * 3.43532
        local floaterScreen = screen or isElementOnScreen(fishingFloats[client])
        local x, y, z
        if fishingData[client].fishingFloatPos then
          x, y, z = unpack(fishingData[client].fishingFloatPos)
          if isNaN(x) or isNaN(y) or isNaN(z) then
            x, y, z = getElementPosition(fishingFloats[client])
          end
        else
          x, y, z = getElementPosition(fishingFloats[client])
        end
        local testWater = floaterScreen or selfPlayer
        if fishingData[client].fishingThrowForce then
          local t = delta / 1000
          local a = -22
          local s = math.max(0, fishingData[client].fishingThrowForce[3] * t + 0.5 * a * t * t)
          fishingData[client].fishingThrowForce[3] = math.max(0, fishingData[client].fishingThrowForce[3] + a * t)
          x = x + fishingData[client].fishingThrowForce[1] * s
          y = y + fishingData[client].fishingThrowForce[2] * s
          local a = -9.8
          z = z + fishingData[client].fishingThrowForce[4] * t + 0.5 * a * t * t
          fishingData[client].fishingThrowForce[4] = fishingData[client].fishingThrowForce[4] + a * t
          z = math.max(-2, z)
          fishingData[client].fishingFloatPos[1] = x
          fishingData[client].fishingFloatPos[2] = y
          testWater = true
        end
        local inDeepWater = false
        local waterZ = false
        if testWater then
          local water, wx, wy, wz = testLineAgainstWater(x, y, z + 10, x, y, z - 10)
          waterZ = wz
          local hit, hx, hy, hz = processLineOfSight(x, y, z + 10, x, y, z - 10, true, true, false, true)
          if hit then
            z = math.max(z, hz)
          end
          inDeepWater = water and (not hit or hz <= wz - 2) and wz or false
          if selfPlayer and inDeepWater then
            local deepness = math.min(6.5, hz and wz and math.floor((wz - hz) * 10) / 10 or 6.5)
            deepness = math.max(2.5, deepness)
            if deepness ~= fishingData[client].deepness and now - (fishingData[client].lastDeepnessSync or 0) > 250 then
              fishingData[client].lastDeepnessSync = now
              fishingData[client].deepness = deepness
              syncFishingData("deepness")
            end
          end
          if water and modeWaterPed(fishingData[client].mode) and not isElement(fishingData[client].waterPed) and (not hit or wz > hz) then
            fishingData[client].waterPed = createPed(1, wx, wy, wz)
            setElementAlpha(fishingData[client].waterPed, 0)
            setElementInterior(fishingData[client].waterPed, 1)
            setElementData(fishingData[client].waterPed, "invulnerable", true)
          end
        end
        local toWaiting = false
        if selfPlayer then
          if fishingData[client].fishingThrowForce and z >= fishingData[client].fishingFloatPos[3] and fishingData[client].fishingThrowForce[3] <= 0 and fishingData[client].fishingThrowForce[4] <= 0 then
            fishingData[client].fishingThrowForce = nil
            syncFishingData("fishingThrowForce")
            if inDeepWater then
              toWaiting = true
            else
              sealexports.seal_gui:showInfobox("e", "Itt nem elég mély a víz a horgászathoz.")
            end
          end
          if testWater and not fishingData[client].fishingThrowForce and not inDeepWater then
            if fishingData[client].mode == "catched" then
              if fishingData[client].lineLength < fishingData[client].fishMinimumDistance * 1.25 then
              else
                sealexports.seal_gui:showInfobox("e", "Elúszott a hal!")
                fishingData[client].fish = nil
                syncFishingData("fish")
              end
            else
              fishingData[client].fish = nil
              syncFishingData("fish")
            end
            setFishingMode(localPlayer, "getout")
          end
        end
        if fishingData[client].fishingFloatPos and z ~= fishingData[client].fishingFloatPos[3] then
          fishingData[client].fishingFloatPos[3] = z
        end
        if fishingData[client].waterPed then
          local px, py, pz = getElementPosition(fishingData[client].waterPed)
          local d = getDistanceBetweenPoints2D(px, py, x, y)
          if waterZ and 2 < math.abs(pz - waterZ) - 0.55 then
            setElementPosition(fishingData[client].waterPed, x, y, waterZ)
          elseif 2 < d then
            setElementPosition(fishingData[client].waterPed, x, y, pz)
          end
          setElementRotation(fishingData[client].waterPed, 0, 0, math.deg(math.atan2(py - y, px - x)) + 90, "default", true)
          setPedAnalogControlState(fishingData[client].waterPed, "forwards", math.min(1, d))
          z = math.max(z, pz + 0.4)
          if fishingData[client].fishingFloatPos then
            fishingData[client].fishingFloatPos[4] = z
          end
        elseif fishingData[client].fishingFloatPos and fishingData[client].mode == "catched" then
          if not fishingData[client].fishingFloatPos[4] and waterZ then
            fishingData[client].fishingFloatPos[4] = waterZ
          end
          if fishingData[client].fishingFloatPos[4] then
            z = fishingData[client].fishingFloatPos[4]
          end
        end
        if not fishingData[client].lineUnderwater then
          fishingData[client].lineUnderwater = 0
        end
        if fishingData[client].mode == "catched" then
          if 1 > fishingData[client].lineUnderwater then
            fishingData[client].lineUnderwater = fishingData[client].lineUnderwater + 2 * delta / 1000
            if 1 < fishingData[client].lineUnderwater then
              fishingData[client].lineUnderwater = 1
            end
          end
        elseif 0 < fishingData[client].lineUnderwater then
          fishingData[client].lineUnderwater = fishingData[client].lineUnderwater - 2 * delta / 1000
          if 0 > fishingData[client].lineUnderwater then
            fishingData[client].lineUnderwater = 0
          end
        end
        z = z - fishingData[client].lineUnderwater * 1.25
        local floaterDistance = getDistanceBetweenPoints3D(rodEndX, rodEndY, rodEndZ, x, y, z)
        local reelSound = true
        local spindleSound = true
        if toWaiting then
          if reelSound then
            local spd = (floaterDistance - 0.125 - (fishingData[client].lineLength or 0)) / (delta / 1000)
            processReelSound(client, m, spd)
            reelSound = false
          end
          fishingData[client].lineLength = floaterDistance - 0.125
          fishingData[client].targetFloatPos = {
            fishingData[client].fishingFloatPos[1],
            fishingData[client].fishingFloatPos[2],
            fishingData[client].fishingFloatPos[3]
          }
          syncFishingData("lineLength")
          syncFishingData("targetFloatPos")
          syncFishingData("fishingFloatPos")
          setFishingMode(localPlayer, "waiting")
        elseif fishingData[client].mode == "throw" then
          if reelSound then
            local spd = (floaterDistance - 0.125 - (fishingData[client].lineLength or 0)) / (delta / 1000)
            processReelSound(client, m, spd)
            reelSound = false
          end
          fishingData[client].lineLength = floaterDistance - 0.125
        end
        if fishingFloats[client] then
          setElementPosition(fishingFloats[client], x, y, z)
        end
        if inDeepWater and 1 >= (fishingData[client].floatingValue or 0) then
          if not fishingData[client].floatingValue then
            fishingData[client].floatingValue = 0
          end
          if inDeepWater >= z - 1 then
            fishingData[client].floatingValue = fishingData[client].floatingValue + delta / 400
            if 1 < fishingData[client].floatingValue then
              fishingData[client].floatingValue = 1
            end
          end
        elseif fishingData[client].floatingValue and 0 < fishingData[client].floatingValue then
          fishingData[client].floatingValue = fishingData[client].floatingValue - delta / 1000
          if 0 > fishingData[client].floatingValue then
            fishingData[client].floatingValue = 0
          end
        end
        local tension = fishingData[client].lineLength and (floaterDistance - fishingData[client].lineLength) / 1.5 or 0
        local creak = (tension - (fishingData[client].lastTension or tension)) / delta * 25 * math.min(1, tension / 0.5)
        fishingData[client].lastTension = tension
        if fishingData[client].creakSound then
          if 0 < creak then
            setElementPosition(fishingData[client].creakSound, rodEndX, rodEndY, rodEndZ)
            setSoundVolume(fishingData[client].creakSound, math.min(2, creak / 0.125))
            setSoundSpeed(fishingData[client].creakSound, 1 + creak / 0.25 * 2)
          else
            setSoundVolume(fishingData[client].creakSound, 0)
          end
        end
        local deg = math.atan2(rodEndY - y, rodEndX - x) + math.pi
        if not fishingData[client].tension then
          fishingData[client].tension = 0
        end
        if not fishingData[client].lineTension then
          fishingData[client].lineTension = 1
        end
        if fishingData[client].mode ~= "throw" then
          if tension > fishingData[client].tension then
            fishingData[client].tension = fishingData[client].tension + 4 * delta / 1000
            if tension < fishingData[client].tension then
              fishingData[client].tension = tension
            end
          end
          if tension < fishingData[client].tension then
            fishingData[client].tension = fishingData[client].tension - 4 * delta / 1000
            if tension > fishingData[client].tension then
              fishingData[client].tension = tension
            end
          end
          local lineTension = fishingData[client].tension / 0.15
          if lineTension > fishingData[client].lineTension then
            fishingData[client].lineTension = fishingData[client].lineTension + 1 * delta / 1000
            if lineTension < fishingData[client].lineTension then
              fishingData[client].lineTension = lineTension
            end
          end
          if lineTension < fishingData[client].lineTension then
            fishingData[client].lineTension = fishingData[client].lineTension - 1 * delta / 1000
            if lineTension > fishingData[client].lineTension then
              fishingData[client].lineTension = lineTension
            end
          end
        end
        if fishingData[client].rodBendShader then
          local p = math.max(0, math.min(1, fishingData[client].tension))
          fishingData[client].tensionD = math.pow(p, 3)
          local deg = math.atan2(m[4][2] - y, m[4][1] - x) + math.pi
          local r = math.atan2(rodEndY - m[4][2], rodEndX - m[4][1])
          r = deg - r
          r = (r + math.pi) % (math.pi * 2) - math.pi
          fishingData[client].tensionR = math.max(-1, math.min(1, r / math.pi * 2 * p))
          fishingData[client].tensionD = math.pow(p, 3) * (1 - 0.75 * math.abs(fishingData[client].tensionR)) - (fishingData[client].throwingTension or 0) * 0.5
          dxSetShaderValue(fishingData[client].rodBendShader, "tensionD", fishingData[client].tensionD)
          dxSetShaderValue(fishingData[client].rodBendShader, "tensionR", fishingData[client].tensionR)
        else
          fishingData[client].tensionD = 0
          fishingData[client].tensionR = 0
        end
        local fx, fy, fz = x, y, z - 0.5
        local fvx, fvy, flen = 0, 0, 0
        if fishingData[client].fishVector then
          fvx = fishingData[client].fishVector[1]
          fvy = fishingData[client].fishVector[2]
          flen = math.sqrt(fvx * fvx + fvy * fvy)
          if 1 < flen then
            fvx = fvx / flen
            fvy = fvy / flen
          end
          fishingData[client].fishWave = ((fishingData[client].fishWave or 0) + 0.5 * flen * delta / 1000) % 1
        end
        if fishingData[client].fishObject then
          fx = fx + fvx * (fishingData[client].lineUnderwater or 0)
          fy = fy + fvy * (fishingData[client].lineUnderwater or 0)
          setElementPosition(fishingData[client].fishObject, fx, fy, fz)
          local r = math.atan2(fvy, fvx)
          setElementRotation(fishingData[client].fishObject, 0, 0, math.deg(r))
          setElementAlpha(fishingData[client].fishObject, 255 * (fishingData[client].lineUnderwater or 0))
        end
        if fishingData[client].fishShader then
          dxSetShaderValue(fishingData[client].fishShader, "wave", fishingData[client].fishWave or 0)
          dxSetShaderValue(fishingData[client].fishShader, "waveSize", (0.5 + 0.25 * flen) * (fishingData[client].lineUnderwater or 0))
          dxSetShaderValue(fishingData[client].fishShader, "ficank", 0)
        end
        drawFishingLine(m, screen, fishingData[client].lineTension, fishingData[client].tensionD, fishingData[client].tensionR, r, g, b, x, y, z, fx, fy, fz)
        if fishingFloats[client] then
          fishingData[client].deg = math.deg(deg)
          setElementRotation(fishingFloats[client], 180 * (1 - (fishingData[client].floatingValue or 0)), 90 * math.abs(fishingData[client].tension) * (0 > fishingData[client].tension and 0.15 or 1), fishingData[client].deg + (0 > fishingData[client].tension and 180 or 0))
        end
        if selfPlayer then
          guiData.inDeepWater = inDeepWater
          local floater2DDistance = getDistanceBetweenPoints2D(rodEndX, rodEndY, x, y)
          if fishingData[client].mode ~= "getout" then
            local hit, hx, hy, hz = processLineOfSight(rodEndX, rodEndY, rodEndZ, x, y, z, true, true, false, true)
            if hit then
              fishingData[client].fish = nil
              syncFishingData("fish")
              setFishingMode(localPlayer, "idle")
              sealexports.seal_gui:showInfobox("e", "Elszakadt a damil!")
              triggerServerEvent("damageFishingLine", localPlayer, currentFishingRod, true)
              playSound3D("files/snap.mp3", rodEndX, rodEndY, rodEndZ)
            end
            if 105 < floaterDistance then
              fishingData[client].fish = nil
              syncFishingData("fish")
              setFishingMode(localPlayer, "idle")
              sealexports.seal_gui:showInfobox("e", "Elszakadt a damil!")
              triggerServerEvent("damageFishingLine", localPlayer, currentFishingRod, true)
              playSound3D("files/snap.mp3", rodEndX, rodEndY, rodEndZ)
            end
            if floater2DDistance <= 1 and fishingData[client].mode ~= "throw" then
              if fishingData[client].mode == "catched" and fishingData[client].fish then
              else
                fishingData[client].fish = nil
                syncFishingData("fish")
              end
              setFishingMode(localPlayer, "getout")
            end
            if 1.025 < tension then
              fishingData[client].fish = nil
              syncFishingData("fish")
              setFishingMode(localPlayer, "idle")
              sealexports.seal_gui:showInfobox("e", "Elszakadt a damil!")
              triggerServerEvent("damageFishingLine", localPlayer, currentFishingRod, true)
              playSound3D("files/snap.mp3", rodEndX, rodEndY, rodEndZ)
            end
            if tension < -3.5 then
              fishingData[client].fish = nil
              syncFishingData("fish")
              setFishingMode(localPlayer, "idle")
              sealexports.seal_gui:showInfobox("e", "Összecsomósodott a damilod!")
              triggerServerEvent("damageFishingLine", localPlayer, currentFishingRod)
            end
          end
          if modeInWaterFishing(fishingData[client].mode) then
            if not fishingData[client].targetFloatPos then
              fishingData[client].targetFloatPos = {
                fishingData[client].fishingFloatPos[1],
                fishingData[client].fishingFloatPos[2],
                fishingData[client].fishingFloatPos[3]
              }
            end
            local vx = rodEndX - fishingData[client].fishingFloatPos[1]
            local vy = rodEndY - fishingData[client].fishingFloatPos[2]
            local len = math.sqrt(vx * vx + vy * vy)
            if 0 < len then
              vx, vy = vx / len, vy / len
              local a = math.abs(tension)
              if 0.1 < a then
                local t = tension - 0.1 * (tension / a)
                local speed = 0.5
                if 0 < tension then
                  speed = 5 + (1 - (fishingData[client].mode == "catched" and fishingData[client].fishWeight or 0) / 60) * 12
                else
                  t = math.min(-0.25, t)
                end
                t = t * speed
                vx = vx * t
                vy = vy * t
                fishingData[client].fishingFloatPos[1] = fishingData[client].fishingFloatPos[1] + vx * delta / 1000
                fishingData[client].fishingFloatPos[2] = fishingData[client].fishingFloatPos[2] + vy * delta / 1000
              end
            end
            if fishingData[client].mode == "catched" then
              if not fishingData[client].fishMinimumDistance then
                fishingData[client].fishMinimumDistance = fishingData[client].lineLength
              elseif fishingData[client].lineLength < fishingData[client].fishMinimumDistance then
                fishingData[client].fishMinimumDistance = fishingData[client].lineLength
              end
              local e = 1
              local fvx, fvy = 0, 0
              if not fishTypes[fishingData[client].fish].nonAlive then
                e = math.max(0.1, (fishingData[client].fishEnergy or 1) - tension * (0.0125 * (1 - fishingData[client].fishWeight / 60 * 0.5)) * delta / 1000)
                fishingData[client].fishEnergy = e
                fishingData[client].fishForceSwitch = (fishingData[client].fishForceSwitch or 0) - delta
                if not fishingData[client].fishPosition then
                  fishingData[client].fishPosition = {
                    fishingData[client].fishingFloatPos[1],
                    fishingData[client].fishingFloatPos[2]
                  }
                end
                if not fishingData[client].fishTargetPosition then
                  fishingData[client].fishTargetPosition = {
                    fishingData[client].fishingFloatPos[1],
                    fishingData[client].fishingFloatPos[2]
                  }
                end
                if 0 >= fishingData[client].fishForceSwitch or 0.25 > getDistanceBetweenPoints2D(fishingData[client].fishTargetPosition[1], fishingData[client].fishTargetPosition[2], fishingData[client].fishingFloatPos[1], fishingData[client].fishingFloatPos[2]) then
                  local d = math.random() * (150 - fishingData[client].fishMinimumDistance) + fishingData[client].fishMinimumDistance
                  fishingData[client].fishTargetTries = (fishingData[client].fishTargetTries or 0) + 1
                  if fishingData[client].fishTargetTries > 100 then
                    setFishingMode(localPlayer, "getout")
                    sealexports.seal_gui:showInfobox("e", "Elúszott a hal!")
                  else
                    local nx, ny = fishingToRealWorldCoords(client, math.random() * math.pi / 2 - math.pi / 4, d)
                    fishingData[client].fishForceSwitch = 0
                    local water, wx, wy, wz = testLineAgainstWater(nx, ny, z + 10, nx, ny, z - 10)
                    if water then
                      local hit, hx, hy, hz = processLineOfSight(nx, ny, z + 10, nx, ny, z - 10, true, true, false, true)
                      if not hit or hz <= wz - 2.5 then
                        local hit = processLineOfSight(nx, ny, z, x, y, z, true, true, false, true)
                        if not hit then
                          fishingData[client].fishTargetTries = 0
                          fishingData[client].fishForceSwitch = math.random() * 10000 + 1000
                          fishingData[client].fishTargetPosition = {nx, ny}
                          fishingData[client].fishTargetVector = {
                            nx - fishingData[client].fishPosition[1],
                            ny - fishingData[client].fishPosition[2]
                          }
                        end
                      end
                    end
                  end
                else
                  if fishingData[client].fishTargetVector then
                    local canEnd = true
                    if fishingData[client].fishPosition[1] < fishingData[client].fishTargetPosition[1] then
                      fishingData[client].fishPosition[1] = fishingData[client].fishPosition[1] + fishingData[client].fishTargetVector[1] * delta / 500
                      if fishingData[client].fishPosition[1] > fishingData[client].fishTargetPosition[1] then
                        fishingData[client].fishPosition[1] = fishingData[client].fishTargetPosition[1]
                      else
                        canEnd = false
                      end
                    end
                    if fishingData[client].fishPosition[1] > fishingData[client].fishTargetPosition[1] then
                      fishingData[client].fishPosition[1] = fishingData[client].fishPosition[1] + fishingData[client].fishTargetVector[1] * delta / 500
                      if fishingData[client].fishPosition[1] < fishingData[client].fishTargetPosition[1] then
                        fishingData[client].fishPosition[1] = fishingData[client].fishTargetPosition[1]
                      else
                        canEnd = false
                      end
                    end
                    if fishingData[client].fishPosition[2] < fishingData[client].fishTargetPosition[2] then
                      fishingData[client].fishPosition[2] = fishingData[client].fishPosition[2] + fishingData[client].fishTargetVector[2] * delta / 500
                      if fishingData[client].fishPosition[2] > fishingData[client].fishTargetPosition[2] then
                        fishingData[client].fishPosition[2] = fishingData[client].fishTargetPosition[2]
                      else
                        canEnd = false
                      end
                    end
                    if fishingData[client].fishPosition[2] > fishingData[client].fishTargetPosition[2] then
                      fishingData[client].fishPosition[2] = fishingData[client].fishPosition[2] + fishingData[client].fishTargetVector[2] * delta / 500
                      if fishingData[client].fishPosition[2] < fishingData[client].fishTargetPosition[2] then
                        fishingData[client].fishPosition[2] = fishingData[client].fishTargetPosition[2]
                      else
                        canEnd = false
                      end
                    end
                    if canEnd then
                      fishingData[client].fishTargetVector = nil
                    end
                  end
                  fvx = fishingData[client].fishPosition[1] - fishingData[client].fishingFloatPos[1]
                  fvy = fishingData[client].fishPosition[2] - fishingData[client].fishingFloatPos[2]
                  local len = math.sqrt(fvx * fvx + fvy * fvy)
                  if 0 < len then
                    fvx, fvy = fvx / len, fvy / len
                  end
                end
              end
              local force = 0.45 * (0.2 + 0.8 * (fishingData[client].fishWeight / 60)) * e
              if not fishTypes[fishingData[client].fish].nonAlive then
                local spd = (60 - fishingData[client].fishWeight) / 10 + 3
                fvx = fvx * spd * e
                fvy = fvy * spd * e
              end
              fvx = fvx - vx * force
              fvy = fvy - vy * force
              if not fishingData[client].fishVector then
                fishingData[client].fishVector = {0, 0}
              end
              if not fishingData[client].targetFishVector then
                fishingData[client].targetFishVector = {0, 0}
              end
              fishingData[client].fishVector = {fvx, fvy}
              if getDistanceBetweenPoints2D(fvx, fvy, fishingData[client].targetFishVector[1], fishingData[client].targetFishVector[2]) > 0.05 and 250 < now - (fishingData[client].lastFishVectorSync or 0) then
                fishingData[client].lastFishVectorSync = now
                fishingData[client].targetFishVector = {fvx, fvy}
                syncFishingData("targetFishVector")
              end
              fishingData[client].fishingFloatPos[1] = fishingData[client].fishingFloatPos[1] + fvx * delta / 1000
              fishingData[client].fishingFloatPos[2] = fishingData[client].fishingFloatPos[2] + fvy * delta / 1000
            elseif fishingData[client].mode == "catching" then
              if not fishingData[client].catchingForce then
                fishingData[client].catchingForce = {
                  0,
                  0,
                  0
                }
              end
              fishingData[client].catchingForce[3] = fishingData[client].catchingForce[3] - 2 * delta / 1000
              if 0 < fishingData[client].catchingForce[3] then
                local vx = fishingData[client].catchingForce[1] * fishingData[client].catchingForce[3]
                local vy = fishingData[client].catchingForce[2] * fishingData[client].catchingForce[3]
                fishingData[client].fishingFloatPos[1] = fishingData[client].fishingFloatPos[1] + vx * delta / 1000
                fishingData[client].fishingFloatPos[2] = fishingData[client].fishingFloatPos[2] + vy * delta / 1000
              else
                local rad = math.random() * math.pi * 2
                fishingData[client].catchingForce = {
                  math.cos(rad),
                  math.sin(rad),
                  math.random() * 1 + 1
                }
              end
              if 0.25 < tension then
                setFishingMode(localPlayer, "catched")
              end
            end
            if checkPosesForSync(fishingData[client].fishingFloatPos[1], fishingData[client].fishingFloatPos[2], fishingData[client].fishingFloatPos[3], fishingData[client].targetFloatPos[1], fishingData[client].targetFloatPos[2], fishingData[client].targetFloatPos[3], fishingData[client].mode) then
              if not fishingData[localPlayer].lastPosSync then
                fishingData[localPlayer].lastPosSync = now
              end
              if now - fishingData[localPlayer].lastPosSync >= 250 * (syncNum == 0 and 2 or 1) then
                fishingData[client].targetFloatPos[1] = fishingData[client].fishingFloatPos[1]
                fishingData[client].targetFloatPos[2] = fishingData[client].fishingFloatPos[2]
                fishingData[client].targetFloatPos[3] = fishingData[client].fishingFloatPos[3]
                syncFishingData("targetFloatPos")
                fishingData[localPlayer].lastPosSync = now
              end
            end
            if not fishingData[client].spindleRoll then
              fishingData[client].spindleRoll = 0
            end
            if not fishingData[client].targetSpindleRoll then
              fishingData[client].targetSpindleRoll = 0
            end
            if fishingData[client].targetSpindleRoll ~= fishingData[client].spindleRoll then
              if fishingData[client].spindleRoll > fishingData[client].targetSpindleRoll then
                fishingData[client].spindleRoll = fishingData[client].spindleRoll + fishingData[client].spindleRollVector * delta / 200
                if spindleSound then
                  processSpindleSound(client, m, fishingData[client].spindleRollVector * 1000 / 200)
                  spindleSound = false
                end
                if fishingData[client].spindleRoll < fishingData[client].targetSpindleRoll then
                  fishingData[client].spindleRoll = fishingData[client].targetSpindleRoll
                end
              end
              if fishingData[client].spindleRoll < fishingData[client].targetSpindleRoll then
                fishingData[client].spindleRoll = fishingData[client].spindleRoll + fishingData[client].spindleRollVector * delta / 200
                if spindleSound then
                  processSpindleSound(client, m, math.abs(fishingData[client].spindleRollVector * 1000 / 200))
                  spindleSound = false
                end
                if fishingData[client].spindleRoll > fishingData[client].targetSpindleRoll then
                  fishingData[client].spindleRoll = fishingData[client].targetSpindleRoll
                end
              end
            end
            if spindleSound then
              processSpindleSound(client, m, 0)
              spindleSound = false
            end
            if 0.1 < math.abs((fishingData[client].syncedSpindleRoll or 0) - (fishingData[client].targetSpindleRoll or 0)) then
              if not fishingData[localPlayer].lastSpindleRollSync then
                fishingData[localPlayer].lastSpindleRollSync = now
              end
              if now - fishingData[localPlayer].lastSpindleRollSync >= 250 * (syncNum == 0 and 10 or 1) then
                fishingData[client].syncedSpindleRoll = fishingData[client].targetSpindleRoll
                syncFishingData("targetSpindleRoll")
                fishingData[client].lastSpindleRollSync = now
              end
            end
            if not fishingData[client].lineVelocity then
              fishingData[client].lineVelocity = 0
            end
            if fishingData[client].lineVelocity ~= 0 then
              local abs = math.abs(fishingData[client].lineVelocity)
              local a = fishingData[client].lineVelocity / abs
              local slow = math.max(2, abs * 2)
              fishingData[client].lineVelocity = fishingData[client].lineVelocity - a * delta / 1000 * slow
              if a < 0 and 0 < fishingData[client].lineVelocity then
                fishingData[client].lineVelocity = 0
              end
              if 0 < a and 0 > fishingData[client].lineVelocity then
                fishingData[client].lineVelocity = 0
              end
            end
            local vel = fishingData[client].lineVelocity + math.max(0, tension) * 4.5 / (1 + (fishingData[localPlayer].spindleGear or 0) * 0.35)
            if 0 < vel and fishingData[client].lineLength >= 100 then
              vel = 0
            end
            if reelSound then
              processReelSound(client, m, vel)
              reelSound = false
            end
            fishingData[client].lineLength = fishingData[client].lineLength + vel * delta / 1000
            if 0.1 < math.abs(fishingData[client].lineLength - (fishingData[client].targetLineLength or 0)) then
              if not fishingData[localPlayer].lastLineLengthSync then
                fishingData[localPlayer].lastLineLengthSync = now
              end
              if now - fishingData[localPlayer].lastLineLengthSync >= 250 * (syncNum == 0 and 10 or 1) then
                fishingData[client].targetLineLength = fishingData[client].lineLength
                syncFishingData("targetLineLength")
                fishingData[client].lastLineLengthSync = now
              end
            end
          end
        elseif modeInWaterFishing(fishingData[client].mode) then
          if fishingData[client].lineLengthVector then
            if not fishingData[client].lineLength then
              fishingData[client].lineLength = 0
            end
            if fishingData[client].lineLength < fishingData[client].targetLineLength then
              if reelSound then
                processReelSound(client, m, fishingData[client].lineLengthVector * 1000 / 287.5)
                reelSound = false
              end
              fishingData[client].lineLength = fishingData[client].lineLength + fishingData[client].lineLengthVector * delta / 287.5
              if fishingData[client].lineLength > fishingData[client].targetLineLength then
                fishingData[client].lineLength = fishingData[client].targetLineLength
                fishingData[client].lineLengthVector = nil
              end
            end
            if fishingData[client].lineLength > fishingData[client].targetLineLength then
              if reelSound then
                processReelSound(client, m, 0)
                reelSound = false
              end
              fishingData[client].lineLength = fishingData[client].lineLength + fishingData[client].lineLengthVector * delta / 287.5
              if fishingData[client].lineLength < fishingData[client].targetLineLength then
                fishingData[client].lineLength = fishingData[client].targetLineLength
                fishingData[client].lineLengthVector = nil
              end
            end
          end
          if reelSound then
            processReelSound(client, m, 0)
            reelSound = false
          end
          if fishingData[client].spindleRollVector then
            if not fishingData[client].spindleRoll then
              fishingData[client].spindleRoll = 0
            end
            if fishingData[client].spindleRoll < fishingData[client].targetSpindleRoll then
              fishingData[client].spindleRoll = fishingData[client].spindleRoll + fishingData[client].spindleRollVector * delta / 287.5
              if spindleSound then
                processSpindleSound(client, m, fishingData[client].spindleRollVector * 1000 / 287.5)
                spindleSound = false
              end
              if fishingData[client].spindleRoll > fishingData[client].targetSpindleRoll then
                fishingData[client].spindleRoll = fishingData[client].targetSpindleRoll
                fishingData[client].spindleRollVector = nil
              end
            end
            if fishingData[client].spindleRoll > fishingData[client].targetSpindleRoll then
              fishingData[client].spindleRoll = fishingData[client].spindleRoll + fishingData[client].spindleRollVector * delta / 287.5
              if spindleSound then
                processSpindleSound(client, m, math.abs(fishingData[client].spindleRollVector * 1000 / 287.5))
                spindleSound = false
              end
              if fishingData[client].spindleRoll < fishingData[client].targetSpindleRoll then
                fishingData[client].spindleRoll = fishingData[client].targetSpindleRoll
                fishingData[client].spindleRollVector = nil
              end
            end
          end
          if spindleSound then
            processSpindleSound(client, m, 0)
            spindleSound = false
          end
          if fishingData[client].floatSyncVector then
            if not fishingData[client].fishingFloatPos then
              fishingData[client].fishingFloatPos = {
                fishingData[client].targetFloatPos[1],
                fishingData[client].targetFloatPos[2],
                fishingData[client].targetFloatPos[3]
              }
            end
            local canEnd = true
            if fishingData[client].floatSyncVector[1] then
              if fishingData[client].fishingFloatPos[1] < fishingData[client].targetFloatPos[1] then
                fishingData[client].fishingFloatPos[1] = fishingData[client].fishingFloatPos[1] + fishingData[client].floatSyncVector[1] * delta / 287.5
                if fishingData[client].fishingFloatPos[1] > fishingData[client].targetFloatPos[1] then
                  fishingData[client].fishingFloatPos[1] = fishingData[client].targetFloatPos[1]
                  fishingData[client].floatSyncVector[1] = nil
                end
              end
              if fishingData[client].fishingFloatPos[1] > fishingData[client].targetFloatPos[1] then
                fishingData[client].fishingFloatPos[1] = fishingData[client].fishingFloatPos[1] + fishingData[client].floatSyncVector[1] * delta / 287.5
                if fishingData[client].fishingFloatPos[1] < fishingData[client].targetFloatPos[1] then
                  fishingData[client].fishingFloatPos[1] = fishingData[client].targetFloatPos[1]
                  fishingData[client].floatSyncVector[1] = nil
                end
              end
              canEnd = false
            end
            if fishingData[client].floatSyncVector[2] then
              if fishingData[client].fishingFloatPos[2] < fishingData[client].targetFloatPos[2] then
                fishingData[client].fishingFloatPos[2] = fishingData[client].fishingFloatPos[2] + fishingData[client].floatSyncVector[2] * delta / 287.5
                if fishingData[client].fishingFloatPos[2] > fishingData[client].targetFloatPos[2] then
                  fishingData[client].fishingFloatPos[2] = fishingData[client].targetFloatPos[2]
                  fishingData[client].floatSyncVector[2] = nil
                end
              end
              if fishingData[client].fishingFloatPos[2] > fishingData[client].targetFloatPos[2] then
                fishingData[client].fishingFloatPos[2] = fishingData[client].fishingFloatPos[2] + fishingData[client].floatSyncVector[2] * delta / 287.5
                if fishingData[client].fishingFloatPos[2] < fishingData[client].targetFloatPos[2] then
                  fishingData[client].fishingFloatPos[2] = fishingData[client].targetFloatPos[2]
                  fishingData[client].floatSyncVector[2] = nil
                end
              end
              canEnd = false
            end
            if fishingData[client].floatSyncVector[3] then
              if fishingData[client].fishingFloatPos[3] < fishingData[client].targetFloatPos[3] then
                fishingData[client].fishingFloatPos[3] = fishingData[client].fishingFloatPos[3] + fishingData[client].floatSyncVector[3] * delta / 287.5
                if fishingData[client].fishingFloatPos[3] > fishingData[client].targetFloatPos[3] then
                  fishingData[client].fishingFloatPos[3] = fishingData[client].targetFloatPos[3]
                  fishingData[client].floatSyncVector[3] = nil
                end
              end
              if fishingData[client].fishingFloatPos[3] > fishingData[client].targetFloatPos[3] then
                fishingData[client].fishingFloatPos[3] = fishingData[client].fishingFloatPos[3] + fishingData[client].floatSyncVector[3] * delta / 287.5
                if fishingData[client].fishingFloatPos[3] < fishingData[client].targetFloatPos[3] then
                  fishingData[client].fishingFloatPos[3] = fishingData[client].targetFloatPos[3]
                  fishingData[client].floatSyncVector[3] = nil
                end
              end
              canEnd = false
            end
            if canEnd then
              fishingData[client].floatSyncVector = nil
            end
          end
          if fishingData[client].fishVectorSyncVector then
            if not fishingData[client].fishVector then
              fishingData[client].fishVector = {
                fishingData[client].targetFishVector[1],
                fishingData[client].targetFishVector[2]
              }
            end
            local canEnd = true
            if fishingData[client].fishVectorSyncVector[1] then
              if fishingData[client].fishVector[1] < fishingData[client].targetFishVector[1] then
                fishingData[client].fishVector[1] = fishingData[client].fishVector[1] + fishingData[client].fishVectorSyncVector[1] * delta / 287.5
                if fishingData[client].fishVector[1] > fishingData[client].targetFishVector[1] then
                  fishingData[client].fishVector[1] = fishingData[client].targetFishVector[1]
                  fishingData[client].fishVectorSyncVector[1] = nil
                end
              end
              if fishingData[client].fishVector[1] > fishingData[client].targetFishVector[1] then
                fishingData[client].fishVector[1] = fishingData[client].fishVector[1] + fishingData[client].fishVectorSyncVector[1] * delta / 287.5
                if fishingData[client].fishVector[1] < fishingData[client].targetFishVector[1] then
                  fishingData[client].fishVector[1] = fishingData[client].targetFishVector[1]
                  fishingData[client].fishVectorSyncVector[1] = nil
                end
              end
              canEnd = false
            end
            if fishingData[client].fishVectorSyncVector[2] then
              if fishingData[client].fishVector[2] < fishingData[client].targetFishVector[2] then
                fishingData[client].fishVector[2] = fishingData[client].fishVector[2] + fishingData[client].fishVectorSyncVector[2] * delta / 287.5
                if fishingData[client].fishVector[2] > fishingData[client].targetFishVector[2] then
                  fishingData[client].fishVector[2] = fishingData[client].targetFishVector[2]
                  fishingData[client].fishVectorSyncVector[2] = nil
                end
              end
              if fishingData[client].fishVector[2] > fishingData[client].targetFishVector[2] then
                fishingData[client].fishVector[2] = fishingData[client].fishVector[2] + fishingData[client].fishVectorSyncVector[2] * delta / 287.5
                if fishingData[client].fishVector[2] < fishingData[client].targetFishVector[2] then
                  fishingData[client].fishVector[2] = fishingData[client].targetFishVector[2]
                  fishingData[client].fishVectorSyncVector[2] = nil
                end
              end
              canEnd = false
            end
            if canEnd then
              fishingData[client].fishVectorSyncVector = nil
            end
          end
        end
      elseif fishingData[client].mode == "getout" then
        local p = math.min(1, (now - fishingData[client].getOutStart) / 4000)
        p2 = math.min(1, p / 0.4)
        local a1, a2 = getPedAnimation(client)
        if a1 ~= "fishing_kihuzas" or a2 ~= "bather" then
          setPedAnimation(client, "fishing_kihuzas", "bather", -1, true, false, false, true, 0)
        end
        local x, y, z = 0, 0, 0
        local luw = (fishingData[client].lineUnderwater or 0) * (1 - p2)
        if fishingData[client].fishingFloatPos then
          x, y = fishingData[client].fishingFloatPos[1], fishingData[client].fishingFloatPos[2]
          z = fishingData[client].fishingFloatPos[4] or fishingData[client].fishingFloatPos[3]
          z = z - luw * 1.25
        end
        local bm = getElementBoneMatrix(client, 35)
        local bx = bm[4][1] + bm[1][1] * 0.15
        local by = bm[4][2] + bm[1][2] * 0.15
        local bz = bm[4][3] + bm[1][3] * 0.15
        x = (bx - x) * p2 + x
        y = (by - y) * p2 + y
        z = (bz + 0.5 - z) * p2 + z
        local fx, fy, fz = x, y, z - 0.5
        local fvx, fvy, flen = 0, 0, 0
        if fishingData[client].fishVector then
          fvx = fishingData[client].fishVector[1]
          fvy = fishingData[client].fishVector[2]
          flen = math.sqrt(fvx * fvx + fvy * fvy)
          if 1 < flen then
            fvx = fvx / flen
            fvy = fvy / flen
          end
        end
        if fishingData[client].fishObject then
          fx = fx + fvx * (luw or 0)
          fy = fy + fvy * (luw or 0)
          setElementPosition(fishingData[client].fishObject, fx, fy, fz)
          local r = math.atan2(fvy, fvx)
          setElementRotation(fishingData[client].fishObject, 0, -90 * p2, math.deg(r))
          setElementAlpha(fishingData[client].fishObject, 255)
        end
        if fishingData[client].fishShader then
          dxSetShaderValue(fishingData[client].fishShader, "wave", fishingData[client].fishWave or 0)
          dxSetShaderValue(fishingData[client].fishShader, "waveSize", (0.5 + 0.25 * flen) * (luw or 0))
          local p = getTickCount() % 300 / 300 * 2
          if 1 < p then
            p = 2 - p
          end
          dxSetShaderValue(fishingData[client].fishShader, "ficank", p * 2 - 1 * p2)
        end
        fishingData[client].floatPos[1] = x
        fishingData[client].floatPos[2] = y
        fishingData[client].floatPos[3] = z
        setPedAnimationProgress(client, "bather", p * 0.99)
        setElementPosition(fishingFloats[client], x, y, z)
        local p3 = math.min(1, p2 * 2)
        local p4 = 1 - p3
        setElementRotation(fishingFloats[client], 180 * math.min(1, math.max(1 - (fishingData[client].floatingValue or 0), p3)), 90 * math.abs(fishingData[client].tension or 0) * (0 > (fishingData[client].tension or 0) and 0.15 or 1) * p4, (fishingData[client].deg or 0) + (0 > (fishingData[client].tension or 0) and 180 or 0))
        if fishingData[client].rodBendShader then
          dxSetShaderValue(fishingData[client].rodBendShader, "tensionD", (fishingData[client].tensionD or 0) * p4)
          dxSetShaderValue(fishingData[client].rodBendShader, "tensionR", (fishingData[client].tensionR or 0) * p4)
        else
          fishingData[client].tensionD = 0
          fishingData[client].tensionR = 0
        end
        drawFishingLine(m, screen, (1 - (fishingData[client].lineTension or 1)) * p3 + (fishingData[client].lineTension or 1), (fishingData[client].tensionD or 0) * p4, (fishingData[client].tensionR or 0) * p4, r, g, b, x, y, z, fx, fy, fz)
      elseif fishingData[client].mode == "idle" or fishingData[client].mode == "aim" then
        local x, y, z = drawFishingLine(m, screen, 1, 0, 0, r, g, b)
        if x and fishingFloats[client] then
          if not fishingData[client].floatPos[1] then
            fishingData[client].floatPos[1] = x
          end
          if not fishingData[client].floatPos[2] then
            fishingData[client].floatPos[2] = y
          end
          if not fishingData[client].floatPos[3] then
            fishingData[client].floatPos[3] = z - 0.5
          end
          local dx, dy, dz = x - fishingData[client].floatPos[1], y - fishingData[client].floatPos[2], z - 0.5 - fishingData[client].floatPos[3]
          local len = math.sqrt(dx * dx + dy * dy + dz * dz)
          if 0 < len then
            dx = dx / len
            dy = dy / len
            dz = dz / len
            fishingData[client].floatPos[1] = fishingData[client].floatPos[1] + dx * len * delta / 75
            fishingData[client].floatPos[2] = fishingData[client].floatPos[2] + dy * len * delta / 75
            fishingData[client].floatPos[3] = fishingData[client].floatPos[3] + dz * len * delta / 75
          end
          local tx, ty, tz = fishingData[client].floatPos[1], fishingData[client].floatPos[2], fishingData[client].floatPos[3]
          local vx, vy, vz = tx - x, ty - y, tz - z
          local len = math.sqrt(vx * vx + vy * vy + vz * vz)
          if 0 < len then
            tx = x + vx / len * math.min(len, 0.5)
            ty = y + vy / len * math.min(len, 0.5)
            tz = z + vz / len * math.min(len, 0.5)
          end
          dxDrawLine3D(x, y, z, tx, ty, tz, tocolor(r, g, b, 100), 0.25)
          dxDrawLine3D(tx, ty, tz, tx, ty, tz - 0.75, tocolor(r / 2, g / 2, b / 2, 50), 0.5)
          setElementPosition(fishingFloats[client], tx, ty, tz)
          setElementRotation(fishingFloats[client], 180, 0, 0)
        end
      end
    end
  end
end
function createElementMatrix(rx, ry, rz)
  local rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
  return {
    {
      math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry),
      math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry),
      -math.cos(rx) * math.sin(ry),
      0
    },
    {
      -math.cos(rx) * math.sin(rz),
      math.cos(rz) * math.cos(rx),
      math.sin(rx),
      0
    },
    {
      math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx),
      math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx),
      math.cos(rx) * math.cos(ry),
      0
    },
    {
      0,
      0,
      0,
      1
    }
  }
end
function getEulerAnglesFromMatrix(mat)
  local nz1, nz2, nz3
  nz3 = math.sqrt(mat[2][1] * mat[2][1] + mat[2][2] * mat[2][2])
  nz1 = -mat[2][1] * mat[2][3] / nz3
  nz2 = -mat[2][2] * mat[2][3] / nz3
  local vx = nz1 * mat[1][1] + nz2 * mat[1][2] + nz3 * mat[1][3]
  local vz = nz1 * mat[3][1] + nz2 * mat[3][2] + nz3 * mat[3][3]
  return math.deg(math.asin(mat[2][3])), -math.deg(math.atan2(vx, vz)), -math.deg(math.atan2(mat[2][1], mat[2][2]))
end
function getPositionFromMatrixOffset(mat, x, y, z)
  return x * mat[1][1] + y * mat[2][1] + z * mat[3][1] + mat[4][1], x * mat[1][2] + y * mat[2][2] + z * mat[3][2] + mat[4][2], x * mat[1][3] + y * mat[2][3] + z * mat[3][3] + mat[4][3]
end
function getPositionFromMatrixOffsetEx(mat, x, y, z)
  return x * mat[1][1] + y * mat[2][1] + z * mat[3][1], x * mat[1][2] + y * mat[2][2] + z * mat[3][2], x * mat[1][3] + y * mat[2][3] + z * mat[3][3]
end
function matrixMultiply(mat1, mat2)
  local matOut = {}
  for i = 1, #mat1 do
    matOut[i] = {}
    for j = 1, #mat2[1] do
      local num = mat1[i][1] * mat2[1][j]
      for n = 2, #mat1[1] do
        num = num + mat1[i][n] * mat2[n][j]
      end
      matOut[i][j] = num
    end
  end
  return matOut
end
local eventGraphStart = 0
addEvent("gotFishingEventWin", true)
addEventHandler("gotFishingEventWin", getRootElement(), function()
  eventGraphStart = getTickCount()
  sealangCondHandl13(true)
  playSound("files/legendary.wav")
end)
function renderEventGraph()
  local now = getTickCount()
  local p = (now - eventGraphStart) / 1000
  local y = math.floor(screenY * 0.8)
  local a = math.min(1, p)
  if 11 <= p then
    a = 1 - (p - 11) / 1.5
    if a <= 0 then
      sealangCondHandl13(false)
      return
    end
  end
  sealangStaticImageUsed[11] = true
  if sealangStaticImageToc[11] then
    processsealangStaticImage[11]()
  end
  dxDrawImage(screenX / 2 - 200, y - 200, 400, 400, sealangStaticImage[11], now / 30, 0, 0, tocolor(40, 240, 186, 255 * a))
  sealangStaticImageUsed[12] = true
  if sealangStaticImageToc[12] then
    processsealangStaticImage[12]()
  end
  dxDrawImage(screenX / 2 - 100, y - 42.5, 200, 85, sealangStaticImage[12], 0, 0, 0, tocolor(255, 255, 255, 255 * a))
end
local currentFishingEvent = false
local currentFishingTournament = false
local currentFishingTournamentToplist = false
local currentFishingTournamentRanking = false
local fishingScreens = {}
local fishingScreenStreamed = false
local fishingScreenRt = false
local fishingScreenShader = false
function screenStreamIn()
  fishingScreenStreamed = true
  if not isElement(fishingScreenRt) then
    fishingScreenRt = dxCreateRenderTarget(256, 182)
  end
  if not isElement(fishingScreenShader) then
    fishingScreenShader = dxCreateShader(texReplaceShaderSource)
    dxSetShaderValue(fishingScreenShader, "ReplacedTexture", fishingScreenRt)
    engineApplyShaderToWorldTexture(fishingScreenShader, "v4_fishingtournament_rt")
  end
  sealangCondHandl14(true)
  sealangCondHandl15(true)
end
function restoreScreen()
  sealangCondHandl14(true)
end
function screenStreamOut()
  for i = 1, #fishingScreens do
    if isElementStreamedIn(fishingScreens[i]) then
      return
    end
  end
  fishingScreenStreamed = false
  if isElement(fishingScreenRt) then
    destroyElement(fishingScreenRt)
  end
  fishingScreenRt = nil
  if isElement(fishingScreenShader) then
    destroyElement(fishingScreenShader)
  end
  fishingScreenShader = nil
  sealangCondHandl15(false)
  sealangCondHandl14(false)
end
function reDrawEventScreen()
  dxSetRenderTarget(fishingScreenRt, true)
  dxSetBlendMode("modulate_add")
  sealangStaticImageUsed[13] = true
  if sealangStaticImageToc[13] then
    processsealangStaticImage[13]()
  end
  dxDrawImage(0, 0, 256, 182, sealangStaticImage[13])
  if currentFishingEvent then
    local y = 91 - (93 + screenFontHeight) / 2
    local timeFrom = getRealTime(currentFishingEvent[1] * 24 * 60 * 60)
    local timeTo = getRealTime(currentFishingEvent[2] * 24 * 60 * 60)
    sealangStaticImageUsed[12] = true
    if sealangStaticImageToc[12] then
      processsealangStaticImage[12]()
    end
    dxDrawImage(28, y, 200, 85, sealangStaticImage[12])
    dxDrawText(string.format("%04d. %02d. %02d.", timeFrom.year + 1900, timeFrom.month + 1, timeFrom.monthday) .. " - " .. string.format("%04d. %02d. %02d.", timeTo.year + 1900, timeTo.month + 1, timeTo.monthday), 0, y + 85 + 8, 256, 0, tocolor(255, 255, 255, 255), screenFontScale, screenFont, "center", "top")
  end
  if currentFishingTournament then
    sealangStaticImageUsed[14] = true
    if sealangStaticImageToc[14] then
      processsealangStaticImage[14]()
    end
    dxDrawImage(2, 2, 64, 27, sealangStaticImage[14])
    local timeFrom = getRealTime(currentFishingTournament[1] * 24 * 60 * 60)
    local timeTo = getRealTime(currentFishingTournament[2] * 24 * 60 * 60)
    local y = 31
    dxDrawText("Fishing Tournament eredmények\n" .. string.format("%04d. %02d. %02d.", timeFrom.year + 1900, timeFrom.month + 1, timeFrom.monthday) .. " - " .. string.format("%04d. %02d. %02d.", timeTo.year + 1900, timeTo.month + 1, timeTo.monthday), 68, 0, 256, y, tocolor(255, 255, 255, 255), screenFontScale * 0.7, screenFont, "center", "center")
    if currentFishingTournamentToplist then
      local inTop = currentFishingTournamentRanking and currentFishingTournamentRanking[1] <= 10
      local inTopEx = currentFishingTournamentRanking and currentFishingTournamentRanking[1] <= 11
      local n = currentFishingTournamentRanking and (inTop and 10 or 11) or 10
      local h = (182 - (inTopEx and 0 or 8) - y) / n
      local w = 248
      local w1 = 4 + w * 0.1
      local w2 = w1 + w * 0.6
      local w3 = w2 + w * 0.3
      for i = 1, n do
        if 10 < i and currentFishingTournamentRanking then
          if not inTopEx then
            dxDrawText("\226\128\162\226\128\162\226\128\162", 0, y, 256, y + 8, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "center", "center")
            y = y + 8
          end
          dxDrawText(currentFishingTournamentRanking[1] .. ".", 4, y, w1, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "center", "center")
          dxDrawText(currentFishingTournamentRanking[2], w1, y, w2, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "left", "center")
          dxDrawText(math.floor(currentFishingTournamentRanking[3] * 10) / 10 .. " kg", w2, y, w3, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "right", "center")
        elseif currentFishingTournamentToplist[i] then
          dxDrawText(i .. ".", 4, y, w1, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "center", "center")
          dxDrawText(currentFishingTournamentToplist[i][1], w1, y, w2, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "left", "center")
          dxDrawText(math.floor(currentFishingTournamentToplist[i][2] * 10) / 10 .. " kg", w2, y, w3, y + h, tocolor(255, 255, 255, 255), screenFontScale * 0.68, screenFont, "right", "center")
          y = y + h
        end
      end
    end
  end
  dxSetBlendMode("blend")
  dxSetRenderTarget()
  sealangCondHandl14(false)
end
addEvent("gotFishingEvent", true)
addEventHandler("gotFishingEvent", getRootElement(), function(event, tournament)
  currentFishingEvent = event
  currentFishingTournament = tournament
  currentFishingTournamentToplist = false
  currentFishingTournamentRanking = false
  if currentFishingEvent or currentFishingTournament then
    for i = 1, #displayPoses do
      if not isElement(fishingScreens[i]) then
        fishingScreens[i] = createObject(models.v4_fishing_tournamentsign, displayPoses[i][1], displayPoses[i][2], displayPoses[i][3], 0, 0, displayPoses[i][4])
        addEventHandler("onClientElementStreamIn", fishingScreens[i], screenStreamIn)
        addEventHandler("onClientElementStreamOut", fishingScreens[i], screenStreamOut)
      end
    end
  else
    for i = 1, #displayPoses do
      if isElement(fishingScreens[i]) then
        destroyElement(fishingScreens[i])
      end
      fishingScreens[i] = nil
    end
  end
end)
addEvent("updateFishingTournament", true)
addEventHandler("updateFishingTournament", getRootElement(), function(update)
  if not currentFishingTournamentToplist then
    currentFishingTournamentToplist = {}
  end
  for i, dat in pairs(update) do
    if not currentFishingTournamentToplist[i] then
      currentFishingTournamentToplist[i] = {}
    end
    for j, val in pairs(dat) do
      currentFishingTournamentToplist[i][j] = val
    end
  end
  if currentFishingTournament and fishingScreenStreamed then
    sealangCondHandl14(true)
  end
end)
addEvent("gotFishingTournamentRanking", true)
addEventHandler("gotFishingTournamentRanking", getRootElement(), function(rank, name, weight)
  currentFishingTournamentRanking = {
    rank,
    name,
    weight
  }
  if currentFishingTournament and fishingScreenStreamed then
    sealangCondHandl14(true)
  end
end)
local winObjectShader = false
local winFish = false
local winFishRT = false
local winFishLength = false
local winFishPreviewLength = false
local winFishName = false
local winFishClass = false
local winFishClassColor = false
local winFishWeight = weight
local winFishLengthVal = weight
local winFishRod = weight
local winFishTime = weight
local winFishWave = 0
local winFishCloseP = 0
local winFishP = 0
local winFishDirection = false
local winFishHover = false
local winFishApplaud = false
local winFishPhotoTaken = false
addEvent("gotFishWin", true)
addEventHandler("gotFishWin", getRootElement(), function(fishType, weight, time, rod)
  local fishType = fishTypes[fishType]
  if not fishType or not fishType.previewLength then
    return
  end
  local scale = 1
  if weight and type(fishType.weight) == "table" then
    scale = (weight - fishType.weight[1]) / (fishType.weight[2] - fishType.weight[1]) * (fishType.weight[4] - fishType.weight[3]) + fishType.weight[3]
  end
  if isElement(winObjectShader) then
    destroyElement(winObjectShader)
  end
  winObjectShader = nil
  if isElement(winFish) then
    destroyElement(winFish)
  end
  winFish = nil
  if isElement(winFishRT) then
    destroyElement(winFishRT)
  end
  winFishRT = nil
  winObjectShader = dxCreateShader(fishGuiShaderSource, 0, 0, false, "all")
  winFish = createObject(fishType.modelId, 0, 0, 0)
  winFishRT = dxCreateRenderTarget(screenX, screenY, true)
  winFishLength = fishType.length
  winFishPreviewLength = winFishLength / 2
  winFishName = fishType.name
  winFishClass = fishType.class or "Common"
  winFishClassColor = sealexports.seal_gui:getColorCode(fishType.classColor or "lightgrey")
  winFishWave = 0
  winFishCloseP = 0
  winFishWeight = math.floor(weight * 10) / 10 .. " kg"
  winFishLengthVal = math.floor(winFishLength * scale * 100 * 10) / 10 .. " cm"
  winFishRod = rod
  winFishTime = string.format("%02d:%02d.%03d", math.floor(time / 60), math.floor(time % 60), time % 60 % 1 * 1000)
  setElementCollisionsEnabled(winFish, false)
  winFishP = 0
  winFishDirection = false
  winFishHover = false
  winFishApplaud = false
  winFishPhotoTaken = false
  engineApplyShaderToWorldTexture(winObjectShader, "*", winFish)
  dxSetShaderValue(winObjectShader, "sFov", 70)
  dxSetShaderValue(winObjectShader, "sAspect", screenY / screenX)
  dxSetShaderValue(winObjectShader, "secondRT", winFishRT)
  dxSetShaderValue(winObjectShader, "length", winFishLength)
  sealangCondHandl16(true)
  sealangCondHandl17(true)
  sealangCondHandl18(true)
  playSound("files/fishin.wav")
end)
function clickWinFish(button, state)
  if state == "up" and winFishHover then
    winFishDirection = true
    sealexports.seal_gui:setCursorType("normal")
    playSound("files/fishout.wav")
  end
end
function preRenderWinFish(delta)
  winFishP = winFishDirection and math.max(0, winFishP - 1 * delta / 3500) or math.min(1, winFishP + 1 * delta / 3500)
  if 0.5 <= winFishP and not winFishApplaud then
    winFishApplaud = true
    playSound("files/" .. utf8.lower(winFishClass) .. ".wav")
  end
  if 1 <= winFishP and winFishPhotoTaken and not winFishDirection then
    if getKeyState("space") then
      winFishDirection = true
      playSound("files/fishout.wav")
    end
    local cx, cy = getCursorPosition()
    if cx then
      cx = cx * screenX
      cy = cy * screenY
      if cx >= screenX / 2 + 256 - 32 and cx <= screenX / 2 + 256 - 8 and cy >= screenY / 2 - 287.5 + 8 - (currentFishingTournament and currentFishingTournamentToplist and 40 or 0) and cy <= screenY / 2 - 287.5 + 32 - (currentFishingTournament and currentFishingTournamentToplist and 40 or 0) then
        winFishCloseP = math.min(1, winFishCloseP + delta / 250)
        if not winFishHover then
          winFishHover = true
          sealexports.seal_gui:setCursorType("link")
        end
      else
        winFishCloseP = math.max(0, winFishCloseP - delta / 250)
        if winFishHover then
          winFishHover = false
          sealexports.seal_gui:setCursorType("normal")
        end
      end
    end
  else
    if winFishHover then
      winFishHover = false
      sealexports.seal_gui:setCursorType("normal")
    end
    winFishHover = false
    winFishCloseP = math.max(0, winFishCloseP - delta / 250)
  end
  local flen = 2.5 + (1 - winFishP) * 2.5
  winFishWave = ((winFishWave or 0) + 0.5 * flen * delta / 1000) % 1
  dxSetShaderValue(winObjectShader, "wave", winFishWave)
  dxSetShaderValue(winObjectShader, "waveSize", 0.5 + 0.25 * flen)
  dxSetRenderTarget(winFishRT, true)
  dxSetRenderTarget()
  local x = winFishDirection and -screenX * getEasingValue(1 - winFishP, "InQuad") or screenX * (1 - getEasingValue(winFishP, "OutQuad"))
  local y = screenY / 2 - 250 + 25 + 60
  if currentFishingTournament and currentFishingTournamentToplist then
    y = y - 40
  end
  local sy = 415 - fishDataFontHeight * 4 - 25 - 20
  local sx = screenX
  local psx, psy = sx / screenX / 2, sy / screenY / 2
  local ppx, ppy = x / screenX + psx - 0.5, -(y / screenY + psy - 0.5)
  ppx, ppy = 2 * ppx, 2 * ppy
  local cameraMatrix = getElementMatrix(getCamera())
  local transformMatrix = createElementMatrix(0, 0, 180)
  local multipliedMatrix = matrixMultiply(transformMatrix, cameraMatrix)
  local rotX, rotY, rotZ = getEulerAnglesFromMatrix(multipliedMatrix)
  local dim = getElementDimension(localPlayer)
  local int = getElementInterior(localPlayer)
  local posX, posY, posZ = getPositionFromMatrixOffset(cameraMatrix, -winFishPreviewLength, winFishLength * 1.35, 0)
  setElementPosition(winFish, posX, posY, posZ, false)
  setElementRotation(winFish, rotX, rotY, rotZ, "ZXY")
  setElementDimension(winFish, dim)
  setElementInterior(winFish, int)
  dxSetShaderValue(winObjectShader, "sCameraPosition", cameraMatrix[4])
  dxSetShaderValue(winObjectShader, "sCameraForward", cameraMatrix[2])
  dxSetShaderValue(winObjectShader, "sCameraUp", cameraMatrix[3])
  dxSetShaderValue(winObjectShader, "sMoveObject2D", ppx, ppy)
  dxSetShaderValue(winObjectShader, "sScaleObject2D", 2 * math.min(psx, psy), 2 * math.min(psx, psy))
  dxSetShaderValue(winObjectShader, "sRealScale2D", 2 * psx, 2 * psy)
  if winFishP <= 0 then
    setElementPosition(winFish, 0, 0, 0, false)
    sealangCondHandl16(false)
    sealangCondHandl17(false)
    sealangCondHandl18(false)
    if isElement(winFish) then
      destroyElement(winFish)
    end
    winFish = nil
    if isElement(winFishRT) then
      destroyElement(winFishRT)
    end
    winFishRT = nil
    if isElement(winObjectShader) then
      destroyElement(winObjectShader)
    end
    winObjectShader = nil
  end
end
function drawFishWinGui(x, y, a)
  dxDrawRectangle(x, y, 512, 575, tocolor(grey1[1], grey1[2], grey1[3], 255 * a))
  dxDrawImage(x, y + 575, 512, -575, ":seal_gui/" .. successGradient .. "." .. gradientTick[successGradient], 0, 0, 0, tocolor(255, 255, 255, 175 * a))
  dxDrawRectangle(x + 60, y + 25, 392, 60, tocolor(grey1[1], grey1[2], grey1[3], 200 * a))
  dxDrawText(winFishName, x, y + 25, x + 512, y + 25 + 60, tocolor(yellow[1], yellow[2], yellow[3], 255 * a), fishNameFontScale, fishNameFont, "center", "center")
  y = y + 575 - 25
  dxDrawRectangle(x + 20, y, 472, 2, tocolor(grey2[1], grey2[2], grey2[3], 255 * a))
  y = y - 2 - 8
  dxDrawText("Bot:", x + 20, y - fishDataFontHeight, 0, y, tocolor(255, 255, 255, 255 * a), fishDataFontScale, fishDataFont, "left", "center")
  dxDrawText(winFishRod, 0, y - fishDataFontHeight, x + 512 - 20, y, tocolor(yellow[1], yellow[2], yellow[3], 255 * a), fishDataFontExScale, fishDataFontEx, "right", "center")
  y = y - fishDataFontHeight
  dxDrawText("Idő:", x + 20, y - fishDataFontHeight, 0, y, tocolor(255, 255, 255, 255 * a), fishDataFontScale, fishDataFont, "left", "center")
  dxDrawText(winFishTime, 0, y - fishDataFontHeight, x + 512 - 20, y, tocolor(yellow[1], yellow[2], yellow[3], 255 * a), fishDataFontExScale, fishDataFontEx, "right", "center")
  y = y - fishDataFontHeight
  dxDrawText("Hossz:", x + 20, y - fishDataFontHeight, 0, y, tocolor(255, 255, 255, 255 * a), fishDataFontScale, fishDataFont, "left", "center")
  dxDrawText(winFishLengthVal, 0, y - fishDataFontHeight, x + 512 - 20, y, tocolor(yellow[1], yellow[2], yellow[3], 255 * a), fishDataFontExScale, fishDataFontEx, "right", "center")
  y = y - fishDataFontHeight
  dxDrawText("Súly:", x + 20, y - fishDataFontHeight, 0, y, tocolor(255, 255, 255, 255 * a), fishDataFontScale, fishDataFont, "left", "center")
  dxDrawText(winFishWeight, 0, y - fishDataFontHeight, x + 512 - 20, y, tocolor(yellow[1], yellow[2], yellow[3], 255 * a), fishDataFontExScale, fishDataFontEx, "right", "center")
  y = y - fishDataFontHeight
  y = y - 8
  dxDrawRectangle(x + 20, y, 472, 2, tocolor(grey2[1], grey2[2], grey2[3], 255 * a))
  y = y - 2
  local h = y - (screenY / 2 - 287.5 + 25 + 60)
  sealangStaticImageUsed[15] = true
  if sealangStaticImageToc[15] then
    processsealangStaticImage[15]()
  end
  dxDrawImage(x, y - 64 - 24, 512, 64, sealangStaticImage[15], 0, 0, 0, tocolor(winFishClassColor[1], winFishClassColor[2], winFishClassColor[3], 255 * a))
  sealangStaticImageUsed[16] = true
  if sealangStaticImageToc[16] then
    processsealangStaticImage[16]()
  end
  dxDrawImage(x, y - 64 - 24, 512, 64, sealangStaticImage[16], 0, 0, 0, tocolor(255, 255, 255, 200 * a))
  dxDrawText(winFishClass, x, y - 64 - 24, x + 512, y - 32 - 24, tocolor(255, 255, 255, 255 * a), fishDataFontExScale, fishDataFontEx, "center", "center")
end
function renderWinFish()
  local a = math.pow(winFishP, 5)
  local x = screenX / 2 - 256
  local y = screenY / 2 - 287.5
  if currentFishingTournament and currentFishingTournamentToplist then
    y = y - 40
    local ty = y + 575 + 16
    sealangStaticImageUsed[14] = true
    if sealangStaticImageToc[14] then
      processsealangStaticImage[14]()
    end
    dxDrawImage(x + 1, ty + 1, 150, 64, sealangStaticImage[14], 0, 0, 0, tocolor(0, 0, 0, 150 * a))
    sealangStaticImageUsed[14] = true
    if sealangStaticImageToc[14] then
      processsealangStaticImage[14]()
    end
    dxDrawImage(x, ty, 150, 64, sealangStaticImage[14], 0, 0, 0, tocolor(255, 255, 255, 255 * a))
    local inTop = currentFishingTournamentRanking and currentFishingTournamentRanking[1] <= 3
    local inTopEx = currentFishingTournamentRanking and currentFishingTournamentRanking[1] <= 4
    local n = currentFishingTournamentRanking and (inTop and 3 or 4) or 3
    local h = (64 - (inTopEx and 0 or 6)) / n
    local w = 346
    local w1 = x + 150 + 8 + w * 0.1
    local w2 = w1 + w * 0.6
    local w3 = w2 + w * 0.3
    for i = 1, n do
      if 3 < i and currentFishingTournamentRanking then
        if not inTopEx then
          dxDrawText("\226\128\162\226\128\162\226\128\162", x + 150 + 1, ty + 1, x + 512 + 1, ty + 6 + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "center", "center")
          dxDrawText("\226\128\162\226\128\162\226\128\162", x + 150, ty, x + 512, ty + 6, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "center", "center")
          ty = ty + 6
        end
        dxDrawText(currentFishingTournamentRanking[1] .. ".", x + 150 + 8 + 1, ty + 1, w1 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "center", "center")
        dxDrawText(currentFishingTournamentRanking[1] .. ".", x + 150 + 8, ty, w1, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "center", "center")
        dxDrawText(currentFishingTournamentRanking[2], w1 + 1, ty + 1, w2 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "left", "center")
        dxDrawText(currentFishingTournamentRanking[2], w1, ty, w2, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "left", "center")
        dxDrawText(math.floor(currentFishingTournamentRanking[3] * 10) / 10 .. " kg", w2 + 1, ty + 1, w3 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "right", "center")
        dxDrawText(math.floor(currentFishingTournamentRanking[3] * 10) / 10 .. " kg", w2, ty, w3, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "right", "center")
      elseif currentFishingTournamentToplist[i] then
        dxDrawText(i .. ".", x + 150 + 8 + 1, ty + 1, w1 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "center", "center")
        dxDrawText(i .. ".", x + 150 + 8, ty, w1, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "center", "center")
        dxDrawText(currentFishingTournamentToplist[i][1], w1 + 1, ty + 1, w2 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "left", "center")
        dxDrawText(currentFishingTournamentToplist[i][1], w1, ty, w2, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "left", "center")
        dxDrawText(math.floor(currentFishingTournamentToplist[i][2] * 10) / 10 .. " kg", w2 + 1, ty + 1, w3 + 1, ty + h + 1, tocolor(0, 0, 0, 150 * a), screenFontScale * 0.95, screenFont, "right", "center")
        dxDrawText(math.floor(currentFishingTournamentToplist[i][2] * 10) / 10 .. " kg", w2, ty, w3, ty + h, tocolor(255, 255, 255, 255 * a), screenFontScale * 0.95, screenFont, "right", "center")
        ty = ty + h
      end
    end
  end
  drawFishWinGui(x, y, a)
  dxDrawImage(0, 0, screenX, screenY, winFishRT)
  local r = (red[1] - 255) * winFishCloseP + 255
  local g = (red[2] - 255) * winFishCloseP + 255
  local b = (red[3] - 255) * winFishCloseP + 255
  dxDrawImage(x + 512 - 32, y + 8, 24, 24, ":seal_gui/" .. closeIcon .. (faTicks[closeIcon] or ""), 0, 0, 0, tocolor(r, g, b, 255 * a))
  if 1 <= winFishP and not winFishPhotoTaken then
    winFishPhotoTaken = true
    local time = getRealTime()
    local filename = string.format("%04d-%02d-%02d_%02d-%02d-%02d", time.year + 1900, time.month + 1, time.monthday, time.hour, time.minute, time.second)
    local rt = dxCreateRenderTarget(512, 575)
    dxSetRenderTarget(rt)
    drawFishWinGui(0, 0, 1)
    dxDrawImage(-x, -y, screenX, screenY, winFishRT)
    dxSetRenderTarget()
    local rawPixels = dxGetTexturePixels(rt)
    rawPixels = dxConvertPixels(rawPixels, "jpeg", 95)
    if rawPixels then
      local jpg = filename
      local post = ""
      local i = 1
      while fileExists("#fishing_v4/" .. jpg .. post .. ".jpg") do
        i = i + 1
        post = "_" .. i
      end
      jpg = "#fishing_v4/" .. jpg .. post .. ".jpg"
      if not fileExists(jpg) then
        local file = fileCreate(jpg)
        if file then
          fileWrite(file, rawPixels)
          fileClose(file)
        end
      end
    end
    rawPixels = nil
    collectgarbage("collect")
    if isElement(rt) then
      destroyElement(rt)
    end
    rt = nil
  end
end
function canUseAnimPanel()
  if fishingData[localPlayer] and modeSpindleNeeded(fishingData[localPlayer].mode) then
    return false
  end
  if previewFishObject[localPlayer] then
    return false
  end
  return true
end
local sellWindow
local sellFishObject = {}
local sellFishPos = {}
local fishStandScreen = {}
function preRenderFishStand(delta)
  local canEnd = true
  for i, dat in pairs(fishStandScreen) do
    if isElementStreamedIn(fishStandObject[i]) and isElementOnScreen(fishStandObject[i]) then
      local weight = dat[2]
      if weight < dat[3] then
        weight = weight + 30 * delta / 1000
        if weight > dat[3] then
          weight = dat[3]
        end
      end
      dat[2] = weight
      setElementPosition(sellFishObject[i], sellFishPos[i][1], sellFishPos[i][2], sellFishPos[i][3] + 0.05 - weight / 50 * 0.05)
      for j = 1, #dat[1] do
        local p = 0
        if j == 1 then
          p = math.floor(weight / 10) % 10
        elseif j == 2 then
          p = math.floor(weight) % 10
        elseif j == 4 then
          p = math.floor(weight * 10) % 10
        end
        sealangStaticImageUsed[17] = true
        if sealangStaticImageToc[17] then
          processsealangStaticImage[17]()
        end
        dxDrawMaterialSectionLine3D(dat[1][j][1], dat[1][j][2], dat[1][j][3] + 0.025, dat[1][j][1], dat[1][j][2], dat[1][j][3] - 0.025, (j == 3 and 10 or p) * 32, 0, 32, 64, sealangStaticImage[17], 0.025, tocolor(35, 35, 20), dat[1][j][4], dat[1][j][5], dat[1][j][3])
      end
    end
    canEnd = false
  end
  if canEnd then
    sealangCondHandl19(false)
  end
end
local sellingPriceFrom = 0
local sellingPriceTo = 0
local fishSellA = 0
local fishSellGameAllowed = false
local fishSellInGame = false
local fishSellP = 0
local fishSellSpeed = 1
local fishSellGraph = {}
function preRenderFishSell(delta)
  if getKeyState("space") and 1 <= fishSellA then
    if fishSellGameAllowed then
      fishSellGameAllowed = false
      fishSellInGame = true
    end
  else
    fishSellInGame = false
  end
  if fishSellInGame then
    fishSellP = math.min(1, fishSellP + delta / 1000 * fishSellSpeed)
    if 1 <= fishSellP then
      fishSellInGame = false
    end
  elseif fishSellGameAllowed then
    if fishSellA < 1 then
      fishSellA = fishSellA + 1 * delta / 1000
      if 1 <= fishSellA then
        fishSellA = 1
        sealexports.seal_gui:showInfobox("i", "Tartsd lenyomva a [Space] gombot, majd engedd fel a megfelelő árnál.")
      end
    end
  else
    fishSellA = fishSellA - 1 * delta / 1000
  end
end
function renderFishSell()
  local p = 0
  for i = 1, #fishSellGraph do
    if fishSellP <= fishSellGraph[i][1] then
      local lastP = fishSellGraph[i - 1] and fishSellGraph[i - 1][1] or 0
      local lastS = fishSellGraph[i - 1] and fishSellGraph[i - 1][2] or 0
      p = (fishSellP - lastP) / (fishSellGraph[i][1] - lastP) * (fishSellGraph[i][2] - lastS) + lastS
      break
    end
  end
  p = getEasingValue(p, "InOutQuad")
  if fishSellA <= 0 then
    sealangCondHandl20(false)
    sealangCondHandl21(false)
    triggerServerEvent("closeFishSelling", localPlayer, 1 - math.abs(p - 0.5) * 2)
    sealexports.seal_controls:toggleControl("all", true)
  else
    local y = math.floor(screenY * 0.85)
    dxDrawRectangle(screenX / 2 - 256 - 3 - 1, y - 3 - 1, 520, 1, tocolor(255, 255, 255, 150 * fishSellA))
    dxDrawRectangle(screenX / 2 - 256 - 3 - 1, y + 16 + 3, 520, 1, tocolor(255, 255, 255, 150 * fishSellA))
    dxDrawRectangle(screenX / 2 - 256 - 3 - 1, y - 3, 1, 22, tocolor(255, 255, 255, 150 * fishSellA))
    dxDrawRectangle(screenX / 2 + 256 + 3, y - 3, 1, 22, tocolor(255, 255, 255, 150 * fishSellA))
    dxDrawRectangle(screenX / 2 - 256 - 3, y - 3, 518, 22, tocolor(255, 255, 255, 50 * fishSellA))
    if 0 < p then
      dxDrawImageSection(screenX / 2 - 256, y, 256 * math.min(1, p / 0.5), 16, 0, 0, 256 * math.min(1, p / 0.5), 2, ":seal_gui/" .. minigameGradient .. "." .. gradientTick[minigameGradient], 0, 0, 0, tocolor(255, 255, 255, 255 * fishSellA))
    end
    if 0.5 < p then
      dxDrawImageSection(screenX / 2, y, 256 * math.min(1, (p - 0.5) / 0.5), 16, 0, 0, -256 * math.min(1, (p - 0.5) / 0.5), 2, ":seal_gui/" .. minigameGradient .. "." .. gradientTick[minigameGradient], 0, 0, 0, tocolor(255, 255, 255, 255 * fishSellA))
    end
    local w = 128
    for i = 1, 3 do
      local x = screenX / 2 - 256 + w * i
      dxDrawRectangle(x - 1, y - 3, 2, 22, tocolor(255, 255, 255, 100 * fishSellA))
    end
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceFrom) .. " $", screenX / 2 - 256 + 1, y + 16 + 8 + 1, screenX / 2 - 256 + 1, 0, tocolor(0, 0, 0, 125 * fishSellA), fishPriceFontScale * 0.7, fishPriceFont, "center", "top")
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceFrom) .. " $", screenX / 2 - 256, y + 16 + 8, screenX / 2 - 256, 0, tocolor(blue[1], blue[2], blue[3], 255 * fishSellA), fishPriceFontScale * 0.7, fishPriceFont, "center", "top")
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceFrom) .. " $", screenX / 2 + 256 + 1, y + 16 + 8 + 1, screenX / 2 + 256 + 1, 0, tocolor(0, 0, 0, 125 * fishSellA), fishPriceFontScale * 0.7, fishPriceFont, "center", "top")
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceFrom) .. " $", screenX / 2 + 256, y + 16 + 8, screenX / 2 + 256, 0, tocolor(blue[1], blue[2], blue[3], 255 * fishSellA), fishPriceFontScale * 0.7, fishPriceFont, "center", "top")
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceTo) .. " $", screenX / 2 + 1, y + 16 + 8 + 1, screenX / 2 + 1, 0, tocolor(0, 0, 0, 125 * fishSellA), fishPriceFontScale * 0.8, fishPriceFont, "center", "top")
    dxDrawText(sealexports.seal_gui:thousandsStepper(sellingPriceTo) .. " $", screenX / 2, y + 16 + 8, screenX / 2, 0, tocolor(green[1], green[2], green[3], 255 * fishSellA), fishPriceFontScale * 0.8, fishPriceFont, "center", "top")
    local op = p
    p = 1 - math.abs(p - 0.5) * 2
    local r = blue[1] + (green[1] - blue[1]) * p
    local g = blue[2] + (green[2] - blue[2]) * p
    local b = blue[3] + (green[3] - blue[3]) * p
    dxDrawText(sealexports.seal_gui:thousandsStepper(math.floor(sellingPriceFrom + (sellingPriceTo - sellingPriceFrom) * p)) .. " $", screenX / 2 - 256 + 512 * op + 1, 0, screenX / 2 - 256 + 512 * op + 1, y - 8 + 1, tocolor(0, 0, 0, 125 * fishSellA), fishPriceFontScale * (0.9 + 0.1 * p), fishPriceFont, "center", "bottom")
    dxDrawText(sealexports.seal_gui:thousandsStepper(math.floor(sellingPriceFrom + (sellingPriceTo - sellingPriceFrom) * p)) .. " $", screenX / 2 - 256 + 512 * op, 0, screenX / 2 - 256 + 512 * op, y - 8, tocolor(r, g, b, 255 * fishSellA), fishPriceFontScale * (0.9 + 0.1 * p), fishPriceFont, "center", "bottom")
  end
end
addEvent("closeFishSelling", true)
addEventHandler("closeFishSelling", getRootElement(), function()
  triggerServerEvent("closeFishSelling", localPlayer)
  if sellWindow then
    sealexports.seal_gui:deleteGuiElement(sellWindow)
  end
  sellWindow = nil
end)
addEvent("finalSellFish", true)
addEventHandler("finalSellFish", getRootElement(), function()
  triggerServerEvent("startFishSelling", localPlayer)
  sealangCondHandl20(true)
  sealangCondHandl21(true)
  sealexports.seal_controls:toggleControl("all", false)
  fishSellGameAllowed = true
  fishSellInGame = false
  fishSellA = 0.0001
  fishSellP = 0
  fishSellSpeed = 1 + (math.random() * 2 - 1) * 0.2
  fishSellGraph = {}
  for i = 0, 1, 0.1 do
    table.insert(fishSellGraph, {
      math.min(1, i + 0.025 * math.random()),
      math.min(1, math.max(0, i + (math.random() * 2 - 1) * 0.025))
    })
  end
  table.insert(fishSellGraph, {1, 1})
  if sellWindow then
    sealexports.seal_gui:deleteGuiElement(sellWindow)
  end
  sellWindow = nil
end)
addEvent("refreshFishStand", true)
addEventHandler("refreshFishStand", getRootElement(), function(i, fishType, weight)
  fishStandScreen[i] = nil
  if isElement(sellFishObject[i]) then
    destroyElement(sellFishObject[i])
  end
  sellFishObject[i] = nil
  local fishType = fishTypes[fishType]
  local scale = 1
  if fishType and fishType.modelId then
    weight = tonumber(weight) or 0
    if weight and type(fishType.weight) == "table" then
      scale = (weight - fishType.weight[1]) / (fishType.weight[2] - fishType.weight[1]) * (fishType.weight[4] - fishType.weight[3]) + fishType.weight[3]
    end
    sellFishPos[i] = 1 < fishType.length * scale and bigSellPos[i] or smallSellPos[i]
    sellFishObject[i] = createObject(fishType.modelId, sellFishPos[i][1], sellFishPos[i][2], sellFishPos[i][3], 0, -90, dropoffPoses[i][4] + 90)
    setObjectScale(sellFishObject[i], scale)
    fishStandScreen[i] = {
      1 < fishType.length * scale and bigSellScreen[i] or smallSellScreen[i],
      0,
      weight
    }
    sealangCondHandl19(true)
    playSound3D("files/fishweight.wav", sellFishPos[i][1], sellFishPos[i][2], sellFishPos[i][3])
  end
  if source == localPlayer then
    if sellWindow then
      sealexports.seal_gui:deleteGuiElement(sellWindow)
    end
    sellWindow = nil
    sealangCondHandl20(false)
    sealangCondHandl21(false)
    sealexports.seal_controls:toggleControl("all", true)
    if fishType then
      local titleBarHeight = sealexports.seal_gui:getTitleBarHeight()
      local pw = 300
      local ph = titleBarHeight + 32 + 80 + 5 + 30 + 5
      sellWindow = sealexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      sealexports.seal_gui:setWindowTitle(sellWindow, "16/BebasNeueRegular.otf", "Hal eladás")
      sealexports.seal_gui:setWindowCloseButton(sellWindow, "closeFishSelling")
      local label = sealexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, 32, sellWindow)
      sealexports.seal_gui:setLabelText(label, fishType.name)
      sealexports.seal_gui:setLabelFont(label, "11/Ubuntu-B.ttf")
      sealexports.seal_gui:setLabelAlignment(label, "center", "center")
      sellingPriceFrom = math.floor(fishType.price * weight * 0.7)
      sellingPriceTo = math.floor(fishType.price * weight * 1)
      local label = sealexports.seal_gui:createGuiElement("label", 0, titleBarHeight + 32, pw, 80, sellWindow)
      sealexports.seal_gui:setLabelText(label, "Súly: " .. math.floor(weight * 10) / 10 .. [[
 kg
Hossz: ]] .. math.floor(fishType.length * scale * 100) .. " cm\nEladási ár: [color=green]" .. sealexports.seal_gui:thousandsStepper(sellingPriceFrom) .. " - " .. sealexports.seal_gui:thousandsStepper(sellingPriceTo) .. " $\n#ffffffEladási ár: [color=blue]" .. sealexports.seal_gui:thousandsStepper(math.floor(sellingPriceFrom / 320)) .. " - " .. sealexports.seal_gui:thousandsStepper(math.floor(sellingPriceTo / 320)) .. " PP")
      sealexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      sealexports.seal_gui:setLabelAlignment(label, "center", "center")
      local btn = sealexports.seal_gui:createGuiElement("button", 5, ph - 35, pw - 10, 30, sellWindow)
      sealexports.seal_gui:setGuiBackground(btn, "solid", "green")
      sealexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      sealexports.seal_gui:setButtonFont(btn, "15/BebasNeueBold.otf")
      sealexports.seal_gui:setButtonTextColor(btn, "#ffffff")
      sealexports.seal_gui:setButtonText(btn, "Eladás")
      sealexports.seal_gui:setClickEvent(btn, "finalSellFish")
    end
  end
end)
