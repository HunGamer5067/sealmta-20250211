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
seelangStaticImageToc[1] = true
seelangStaticImageToc[2] = true
seelangStaticImageToc[3] = true
seelangStaticImageToc[4] = true
seelangStaticImageToc[5] = true
seelangStaticImageToc[6] = true
seelangStaticImageToc[7] = true
seelangStaticImageToc[8] = true
seelangStaticImageToc[9] = true
seelangStaticImageToc[10] = true
seelangStaticImageToc[11] = true
seelangStaticImageToc[12] = true
seelangStaticImageToc[13] = true
seelangStaticImageToc[14] = true
seelangStaticImageToc[15] = true
seelangStaticImageToc[16] = true
seelangStaticImageToc[17] = true
seelangStaticImageToc[18] = true
seelangStaticImageToc[19] = true
seelangStaticImageToc[20] = true
seelangStaticImageToc[21] = true
seelangStaticImageToc[22] = true
seelangStaticImageToc[23] = true
seelangStaticImageToc[24] = true
seelangStaticImageToc[25] = true
seelangStaticImageToc[26] = true
seelangStaticImageToc[27] = true
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
  if seelangStaticImageUsed[3] then
    seelangStaticImageUsed[3] = false
    seelangStaticImageDel[3] = false
  elseif seelangStaticImage[3] then
    if seelangStaticImageDel[3] then
      if now >= seelangStaticImageDel[3] then
        if isElement(seelangStaticImage[3]) then
          destroyElement(seelangStaticImage[3])
        end
        seelangStaticImage[3] = nil
        seelangStaticImageDel[3] = false
        seelangStaticImageToc[3] = true
        return
      end
    else
      seelangStaticImageDel[3] = now + 5000
    end
  else
    seelangStaticImageToc[3] = true
  end
  if seelangStaticImageUsed[4] then
    seelangStaticImageUsed[4] = false
    seelangStaticImageDel[4] = false
  elseif seelangStaticImage[4] then
    if seelangStaticImageDel[4] then
      if now >= seelangStaticImageDel[4] then
        if isElement(seelangStaticImage[4]) then
          destroyElement(seelangStaticImage[4])
        end
        seelangStaticImage[4] = nil
        seelangStaticImageDel[4] = false
        seelangStaticImageToc[4] = true
        return
      end
    else
      seelangStaticImageDel[4] = now + 5000
    end
  else
    seelangStaticImageToc[4] = true
  end
  if seelangStaticImageUsed[5] then
    seelangStaticImageUsed[5] = false
    seelangStaticImageDel[5] = false
  elseif seelangStaticImage[5] then
    if seelangStaticImageDel[5] then
      if now >= seelangStaticImageDel[5] then
        if isElement(seelangStaticImage[5]) then
          destroyElement(seelangStaticImage[5])
        end
        seelangStaticImage[5] = nil
        seelangStaticImageDel[5] = false
        seelangStaticImageToc[5] = true
        return
      end
    else
      seelangStaticImageDel[5] = now + 5000
    end
  else
    seelangStaticImageToc[5] = true
  end
  if seelangStaticImageUsed[6] then
    seelangStaticImageUsed[6] = false
    seelangStaticImageDel[6] = false
  elseif seelangStaticImage[6] then
    if seelangStaticImageDel[6] then
      if now >= seelangStaticImageDel[6] then
        if isElement(seelangStaticImage[6]) then
          destroyElement(seelangStaticImage[6])
        end
        seelangStaticImage[6] = nil
        seelangStaticImageDel[6] = false
        seelangStaticImageToc[6] = true
        return
      end
    else
      seelangStaticImageDel[6] = now + 5000
    end
  else
    seelangStaticImageToc[6] = true
  end
  if seelangStaticImageUsed[7] then
    seelangStaticImageUsed[7] = false
    seelangStaticImageDel[7] = false
  elseif seelangStaticImage[7] then
    if seelangStaticImageDel[7] then
      if now >= seelangStaticImageDel[7] then
        if isElement(seelangStaticImage[7]) then
          destroyElement(seelangStaticImage[7])
        end
        seelangStaticImage[7] = nil
        seelangStaticImageDel[7] = false
        seelangStaticImageToc[7] = true
        return
      end
    else
      seelangStaticImageDel[7] = now + 5000
    end
  else
    seelangStaticImageToc[7] = true
  end
  if seelangStaticImageUsed[8] then
    seelangStaticImageUsed[8] = false
    seelangStaticImageDel[8] = false
  elseif seelangStaticImage[8] then
    if seelangStaticImageDel[8] then
      if now >= seelangStaticImageDel[8] then
        if isElement(seelangStaticImage[8]) then
          destroyElement(seelangStaticImage[8])
        end
        seelangStaticImage[8] = nil
        seelangStaticImageDel[8] = false
        seelangStaticImageToc[8] = true
        return
      end
    else
      seelangStaticImageDel[8] = now + 5000
    end
  else
    seelangStaticImageToc[8] = true
  end
  if seelangStaticImageUsed[9] then
    seelangStaticImageUsed[9] = false
    seelangStaticImageDel[9] = false
  elseif seelangStaticImage[9] then
    if seelangStaticImageDel[9] then
      if now >= seelangStaticImageDel[9] then
        if isElement(seelangStaticImage[9]) then
          destroyElement(seelangStaticImage[9])
        end
        seelangStaticImage[9] = nil
        seelangStaticImageDel[9] = false
        seelangStaticImageToc[9] = true
        return
      end
    else
      seelangStaticImageDel[9] = now + 5000
    end
  else
    seelangStaticImageToc[9] = true
  end
  if seelangStaticImageUsed[10] then
    seelangStaticImageUsed[10] = false
    seelangStaticImageDel[10] = false
  elseif seelangStaticImage[10] then
    if seelangStaticImageDel[10] then
      if now >= seelangStaticImageDel[10] then
        if isElement(seelangStaticImage[10]) then
          destroyElement(seelangStaticImage[10])
        end
        seelangStaticImage[10] = nil
        seelangStaticImageDel[10] = false
        seelangStaticImageToc[10] = true
        return
      end
    else
      seelangStaticImageDel[10] = now + 5000
    end
  else
    seelangStaticImageToc[10] = true
  end
  if seelangStaticImageUsed[11] then
    seelangStaticImageUsed[11] = false
    seelangStaticImageDel[11] = false
  elseif seelangStaticImage[11] then
    if seelangStaticImageDel[11] then
      if now >= seelangStaticImageDel[11] then
        if isElement(seelangStaticImage[11]) then
          destroyElement(seelangStaticImage[11])
        end
        seelangStaticImage[11] = nil
        seelangStaticImageDel[11] = false
        seelangStaticImageToc[11] = true
        return
      end
    else
      seelangStaticImageDel[11] = now + 5000
    end
  else
    seelangStaticImageToc[11] = true
  end
  if seelangStaticImageUsed[12] then
    seelangStaticImageUsed[12] = false
    seelangStaticImageDel[12] = false
  elseif seelangStaticImage[12] then
    if seelangStaticImageDel[12] then
      if now >= seelangStaticImageDel[12] then
        if isElement(seelangStaticImage[12]) then
          destroyElement(seelangStaticImage[12])
        end
        seelangStaticImage[12] = nil
        seelangStaticImageDel[12] = false
        seelangStaticImageToc[12] = true
        return
      end
    else
      seelangStaticImageDel[12] = now + 5000
    end
  else
    seelangStaticImageToc[12] = true
  end
  if seelangStaticImageUsed[13] then
    seelangStaticImageUsed[13] = false
    seelangStaticImageDel[13] = false
  elseif seelangStaticImage[13] then
    if seelangStaticImageDel[13] then
      if now >= seelangStaticImageDel[13] then
        if isElement(seelangStaticImage[13]) then
          destroyElement(seelangStaticImage[13])
        end
        seelangStaticImage[13] = nil
        seelangStaticImageDel[13] = false
        seelangStaticImageToc[13] = true
        return
      end
    else
      seelangStaticImageDel[13] = now + 5000
    end
  else
    seelangStaticImageToc[13] = true
  end
  if seelangStaticImageUsed[14] then
    seelangStaticImageUsed[14] = false
    seelangStaticImageDel[14] = false
  elseif seelangStaticImage[14] then
    if seelangStaticImageDel[14] then
      if now >= seelangStaticImageDel[14] then
        if isElement(seelangStaticImage[14]) then
          destroyElement(seelangStaticImage[14])
        end
        seelangStaticImage[14] = nil
        seelangStaticImageDel[14] = false
        seelangStaticImageToc[14] = true
        return
      end
    else
      seelangStaticImageDel[14] = now + 5000
    end
  else
    seelangStaticImageToc[14] = true
  end
  if seelangStaticImageUsed[15] then
    seelangStaticImageUsed[15] = false
    seelangStaticImageDel[15] = false
  elseif seelangStaticImage[15] then
    if seelangStaticImageDel[15] then
      if now >= seelangStaticImageDel[15] then
        if isElement(seelangStaticImage[15]) then
          destroyElement(seelangStaticImage[15])
        end
        seelangStaticImage[15] = nil
        seelangStaticImageDel[15] = false
        seelangStaticImageToc[15] = true
        return
      end
    else
      seelangStaticImageDel[15] = now + 5000
    end
  else
    seelangStaticImageToc[15] = true
  end
  if seelangStaticImageUsed[16] then
    seelangStaticImageUsed[16] = false
    seelangStaticImageDel[16] = false
  elseif seelangStaticImage[16] then
    if seelangStaticImageDel[16] then
      if now >= seelangStaticImageDel[16] then
        if isElement(seelangStaticImage[16]) then
          destroyElement(seelangStaticImage[16])
        end
        seelangStaticImage[16] = nil
        seelangStaticImageDel[16] = false
        seelangStaticImageToc[16] = true
        return
      end
    else
      seelangStaticImageDel[16] = now + 5000
    end
  else
    seelangStaticImageToc[16] = true
  end
  if seelangStaticImageUsed[17] then
    seelangStaticImageUsed[17] = false
    seelangStaticImageDel[17] = false
  elseif seelangStaticImage[17] then
    if seelangStaticImageDel[17] then
      if now >= seelangStaticImageDel[17] then
        if isElement(seelangStaticImage[17]) then
          destroyElement(seelangStaticImage[17])
        end
        seelangStaticImage[17] = nil
        seelangStaticImageDel[17] = false
        seelangStaticImageToc[17] = true
        return
      end
    else
      seelangStaticImageDel[17] = now + 5000
    end
  else
    seelangStaticImageToc[17] = true
  end
  if seelangStaticImageUsed[18] then
    seelangStaticImageUsed[18] = false
    seelangStaticImageDel[18] = false
  elseif seelangStaticImage[18] then
    if seelangStaticImageDel[18] then
      if now >= seelangStaticImageDel[18] then
        if isElement(seelangStaticImage[18]) then
          destroyElement(seelangStaticImage[18])
        end
        seelangStaticImage[18] = nil
        seelangStaticImageDel[18] = false
        seelangStaticImageToc[18] = true
        return
      end
    else
      seelangStaticImageDel[18] = now + 5000
    end
  else
    seelangStaticImageToc[18] = true
  end
  if seelangStaticImageUsed[19] then
    seelangStaticImageUsed[19] = false
    seelangStaticImageDel[19] = false
  elseif seelangStaticImage[19] then
    if seelangStaticImageDel[19] then
      if now >= seelangStaticImageDel[19] then
        if isElement(seelangStaticImage[19]) then
          destroyElement(seelangStaticImage[19])
        end
        seelangStaticImage[19] = nil
        seelangStaticImageDel[19] = false
        seelangStaticImageToc[19] = true
        return
      end
    else
      seelangStaticImageDel[19] = now + 5000
    end
  else
    seelangStaticImageToc[19] = true
  end
  if seelangStaticImageUsed[20] then
    seelangStaticImageUsed[20] = false
    seelangStaticImageDel[20] = false
  elseif seelangStaticImage[20] then
    if seelangStaticImageDel[20] then
      if now >= seelangStaticImageDel[20] then
        if isElement(seelangStaticImage[20]) then
          destroyElement(seelangStaticImage[20])
        end
        seelangStaticImage[20] = nil
        seelangStaticImageDel[20] = false
        seelangStaticImageToc[20] = true
        return
      end
    else
      seelangStaticImageDel[20] = now + 5000
    end
  else
    seelangStaticImageToc[20] = true
  end
  if seelangStaticImageUsed[21] then
    seelangStaticImageUsed[21] = false
    seelangStaticImageDel[21] = false
  elseif seelangStaticImage[21] then
    if seelangStaticImageDel[21] then
      if now >= seelangStaticImageDel[21] then
        if isElement(seelangStaticImage[21]) then
          destroyElement(seelangStaticImage[21])
        end
        seelangStaticImage[21] = nil
        seelangStaticImageDel[21] = false
        seelangStaticImageToc[21] = true
        return
      end
    else
      seelangStaticImageDel[21] = now + 5000
    end
  else
    seelangStaticImageToc[21] = true
  end
  if seelangStaticImageUsed[22] then
    seelangStaticImageUsed[22] = false
    seelangStaticImageDel[22] = false
  elseif seelangStaticImage[22] then
    if seelangStaticImageDel[22] then
      if now >= seelangStaticImageDel[22] then
        if isElement(seelangStaticImage[22]) then
          destroyElement(seelangStaticImage[22])
        end
        seelangStaticImage[22] = nil
        seelangStaticImageDel[22] = false
        seelangStaticImageToc[22] = true
        return
      end
    else
      seelangStaticImageDel[22] = now + 5000
    end
  else
    seelangStaticImageToc[22] = true
  end
  if seelangStaticImageUsed[23] then
    seelangStaticImageUsed[23] = false
    seelangStaticImageDel[23] = false
  elseif seelangStaticImage[23] then
    if seelangStaticImageDel[23] then
      if now >= seelangStaticImageDel[23] then
        if isElement(seelangStaticImage[23]) then
          destroyElement(seelangStaticImage[23])
        end
        seelangStaticImage[23] = nil
        seelangStaticImageDel[23] = false
        seelangStaticImageToc[23] = true
        return
      end
    else
      seelangStaticImageDel[23] = now + 5000
    end
  else
    seelangStaticImageToc[23] = true
  end
  if seelangStaticImageUsed[24] then
    seelangStaticImageUsed[24] = false
    seelangStaticImageDel[24] = false
  elseif seelangStaticImage[24] then
    if seelangStaticImageDel[24] then
      if now >= seelangStaticImageDel[24] then
        if isElement(seelangStaticImage[24]) then
          destroyElement(seelangStaticImage[24])
        end
        seelangStaticImage[24] = nil
        seelangStaticImageDel[24] = false
        seelangStaticImageToc[24] = true
        return
      end
    else
      seelangStaticImageDel[24] = now + 5000
    end
  else
    seelangStaticImageToc[24] = true
  end
  if seelangStaticImageUsed[25] then
    seelangStaticImageUsed[25] = false
    seelangStaticImageDel[25] = false
  elseif seelangStaticImage[25] then
    if seelangStaticImageDel[25] then
      if now >= seelangStaticImageDel[25] then
        if isElement(seelangStaticImage[25]) then
          destroyElement(seelangStaticImage[25])
        end
        seelangStaticImage[25] = nil
        seelangStaticImageDel[25] = false
        seelangStaticImageToc[25] = true
        return
      end
    else
      seelangStaticImageDel[25] = now + 5000
    end
  else
    seelangStaticImageToc[25] = true
  end
  if seelangStaticImageUsed[26] then
    seelangStaticImageUsed[26] = false
    seelangStaticImageDel[26] = false
  elseif seelangStaticImage[26] then
    if seelangStaticImageDel[26] then
      if now >= seelangStaticImageDel[26] then
        if isElement(seelangStaticImage[26]) then
          destroyElement(seelangStaticImage[26])
        end
        seelangStaticImage[26] = nil
        seelangStaticImageDel[26] = false
        seelangStaticImageToc[26] = true
        return
      end
    else
      seelangStaticImageDel[26] = now + 5000
    end
  else
    seelangStaticImageToc[26] = true
  end
  if seelangStaticImageUsed[27] then
    seelangStaticImageUsed[27] = false
    seelangStaticImageDel[27] = false
  elseif seelangStaticImage[27] then
    if seelangStaticImageDel[27] then
      if now >= seelangStaticImageDel[27] then
        if isElement(seelangStaticImage[27]) then
          destroyElement(seelangStaticImage[27])
        end
        seelangStaticImage[27] = nil
        seelangStaticImageDel[27] = false
        seelangStaticImageToc[27] = true
        return
      end
    else
      seelangStaticImageDel[27] = now + 5000
    end
  else
    seelangStaticImageToc[27] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] and seelangStaticImageToc[3] and seelangStaticImageToc[4] and seelangStaticImageToc[5] and seelangStaticImageToc[6] and seelangStaticImageToc[7] and seelangStaticImageToc[8] and seelangStaticImageToc[9] and seelangStaticImageToc[10] and seelangStaticImageToc[11] and seelangStaticImageToc[12] and seelangStaticImageToc[13] and seelangStaticImageToc[14] and seelangStaticImageToc[15] and seelangStaticImageToc[16] and seelangStaticImageToc[17] and seelangStaticImageToc[18] and seelangStaticImageToc[19] and seelangStaticImageToc[20] and seelangStaticImageToc[21] and seelangStaticImageToc[22] and seelangStaticImageToc[23] and seelangStaticImageToc[24] and seelangStaticImageToc[25] and seelangStaticImageToc[26] and seelangStaticImageToc[27] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/afk.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/grave1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/grave2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[3] = function()
  if not isElement(seelangStaticImage[3]) then
    seelangStaticImageToc[3] = false
    seelangStaticImage[3] = dxCreateTexture("files/sgs1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[4] = function()
  if not isElement(seelangStaticImage[4]) then
    seelangStaticImageToc[4] = false
    seelangStaticImage[4] = dxCreateTexture("files/sgs2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[5] = function()
  if not isElement(seelangStaticImage[5]) then
    seelangStaticImageToc[5] = false
    seelangStaticImage[5] = dxCreateTexture("files/sgs3.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[6] = function()
  if not isElement(seelangStaticImage[6]) then
    seelangStaticImageToc[6] = false
    seelangStaticImage[6] = dxCreateTexture("files/sgs4.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[7] = function()
  if not isElement(seelangStaticImage[7]) then
    seelangStaticImageToc[7] = false
    seelangStaticImage[7] = dxCreateTexture("files/logo.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[8] = function()
  if not isElement(seelangStaticImage[8]) then
    seelangStaticImageToc[8] = false
    seelangStaticImage[8] = dxCreateTexture("files/logo2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[9] = function()
  if not isElement(seelangStaticImage[9]) then
    seelangStaticImageToc[9] = false
    seelangStaticImage[9] = dxCreateTexture("files/logo3.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[10] = function()
  if not isElement(seelangStaticImage[10]) then
    seelangStaticImageToc[10] = false
    seelangStaticImage[10] = dxCreateTexture("files/anim.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[11] = function()
  if not isElement(seelangStaticImage[11]) then
    seelangStaticImageToc[11] = false
    seelangStaticImage[11] = dxCreateTexture("files/bag1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[12] = function()
  if not isElement(seelangStaticImage[12]) then
    seelangStaticImageToc[12] = false
    seelangStaticImage[12] = dxCreateTexture("files/bag3.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[13] = function()
  if not isElement(seelangStaticImage[13]) then
    seelangStaticImageToc[13] = false
    seelangStaticImage[13] = dxCreateTexture("files/bag2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[14] = function()
  if not isElement(seelangStaticImage[14]) then
    seelangStaticImageToc[14] = false
    seelangStaticImage[14] = dxCreateTexture("files/cuff1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[15] = function()
  if not isElement(seelangStaticImage[15]) then
    seelangStaticImageToc[15] = false
    seelangStaticImage[15] = dxCreateTexture("files/cuff2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[16] = function()
  if not isElement(seelangStaticImage[16]) then
    seelangStaticImageToc[16] = false
    seelangStaticImage[16] = dxCreateTexture("files/tazer.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[17] = function()
  if not isElement(seelangStaticImage[17]) then
    seelangStaticImageToc[17] = false
    seelangStaticImage[17] = dxCreateTexture("files/hospital.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[18] = function()
  if not isElement(seelangStaticImage[18]) then
    seelangStaticImageToc[18] = false
    seelangStaticImage[18] = dxCreateTexture("files/feather.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[19] = function()
  if not isElement(seelangStaticImage[19]) then
    seelangStaticImageToc[19] = false
    seelangStaticImage[19] = dxCreateTexture("files/featherTop.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[20] = function()
  if not isElement(seelangStaticImage[20]) then
    seelangStaticImageToc[20] = false
    seelangStaticImage[20] = dxCreateTexture("files/corner.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[21] = function()
  if not isElement(seelangStaticImage[21]) then
    seelangStaticImageToc[21] = false
    seelangStaticImage[21] = dxCreateTexture("files/mic.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[22] = function()
  if not isElement(seelangStaticImage[22]) then
    seelangStaticImageToc[22] = false
    seelangStaticImage[22] = dxCreateTexture("files/death.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[23] = function()
  if not isElement(seelangStaticImage[23]) then
    seelangStaticImageToc[23] = false
    seelangStaticImage[23] = dxCreateTexture("files/wep.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[24] = function()
  if not isElement(seelangStaticImage[24]) then
    seelangStaticImageToc[24] = false
    seelangStaticImage[24] = dxCreateTexture("files/armor.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[25] = function()
  if not isElement(seelangStaticImage[25]) then
    seelangStaticImageToc[25] = false
    seelangStaticImage[25] = dxCreateTexture("files/belt.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[26] = function()
  if not isElement(seelangStaticImage[26]) then
    seelangStaticImageToc[26] = false
    seelangStaticImage[26] = dxCreateTexture("files/id.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[27] = function()
  if not isElement(seelangStaticImage[27]) then
    seelangStaticImageToc[27] = false
    seelangStaticImage[27] = dxCreateTexture("files/badge.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
local seelangGuiRefreshColors = function()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    refreshColors()
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
      addEventHandler("onClientRender", getRootElement(), renderNametag, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderNametag)
    end
  end
end
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientRender", getRootElement(), renderSquadSigns, true, prio)
    else
      removeEventHandler("onClientRender", getRootElement(), renderSquadSigns)
    end
  end
end
local charsetSize = 64
local charsetData = {
  bebas = {
    checksum = "F8746E2D88438195DC92A66CEC70680636D6AE5B2B5EBB39F3D7EE4DC7C52AE7",
    letters = {
      [" "] = 7,
      ["A"] = 16,
      ["B"] = 16,
      ["C"] = 16,
      ["D"] = 17,
      ["E"] = 15,
      ["F"] = 14,
      ["G"] = 16,
      ["H"] = 17,
      ["I"] = 8,
      ["J"] = 11,
      ["K"] = 17,
      ["L"] = 14,
      ["M"] = 22,
      ["N"] = 17,
      ["O"] = 16,
      ["P"] = 16,
      ["Q"] = 16,
      ["R"] = 16,
      ["S"] = 15,
      ["T"] = 15,
      ["U"] = 16,
      ["V"] = 16,
      ["W"] = 23,
      ["X"] = 16,
      ["Y"] = 16,
      ["Z"] = 15,
      ["a"] = 15,
      ["b"] = 16,
      ["c"] = 15,
      ["d"] = 16,
      ["e"] = 15,
      ["f"] = 11,
      ["g"] = 16,
      ["h"] = 16,
      ["i"] = 8,
      ["j"] = 8,
      ["k"] = 16,
      ["l"] = 8,
      ["m"] = 24,
      ["n"] = 16,
      ["o"] = 15,
      ["p"] = 16,
      ["q"] = 16,
      ["r"] = 11,
      ["s"] = 14,
      ["t"] = 11,
      ["u"] = 16,
      ["v"] = 15,
      ["w"] = 22,
      ["x"] = 15,
      ["y"] = 15,
      ["z"] = 14,
      ["0"] = 16,
      ["1"] = 12,
      ["2"] = 15,
      ["3"] = 15,
      ["4"] = 16,
      ["5"] = 16,
      ["6"] = 16,
      ["7"] = 15,
      ["8"] = 16,
      ["9"] = 16,
      ["Á"] = 16,
      ["É"] = 15,
      ["Í"] = 8,
      ["Ó"] = 16,
      ["Ö"] = 16,
      ["Ő"] = 16,
      ["Ú"] = 16,
      ["Ü"] = 16,
      ["Ű"] = 16,
      ["á"] = 15,
      ["é"] = 15,
      ["í"] = 8,
      ["ó"] = 15,
      ["ö"] = 15,
      ["ő"] = 15,
      ["ú"] = 16,
      ["ü"] = 16,
      ["ű"] = 16,
      ["("] = 11,
      [")"] = 11,
      ["<"] = 16,
      [">"] = 16,
      ["-"] = 11,
      ["."] = 8,
      ["•"] = 12,
      [","] = 8,
      [":"] = 8,
      ["["] = 11,
      ["]"] = 11,
      ["'"] = 7,
      ['"'] = 13,
      [";"] = 8,
      ["?"] = 15,
      ["!"] = 9,
      ["*"] = 17,
      ["/"] = 16,
      ["$"] = 16,
      ["&"] = 17,
      ["@"] = 28,
      ["#"] = 16,
      ["_"] = 12,
      ["✚"] = 31,
      ["★"] = 30,
      ["☆"] = 30,
    }
  },
  ubuntu = {
    checksum = "27E4A97E32E72A890176523EC2CC31800CE5F274D88C7F715B9BA5791955D601",
    letters = {
      [" "] = 7,
      A = 19,
      B = 19,
      C = 18,
      D = 21,
      E = 17,
      F = 16,
      G = 20,
      H = 21,
      I = 8,
      J = 15,
      K = 19,
      L = 16,
      M = 25,
      N = 21,
      O = 22,
      P = 18,
      Q = 22,
      R = 19,
      S = 16,
      T = 18,
      U = 20,
      V = 19,
      W = 27,
      X = 19,
      Y = 18,
      Z = 17,
      a = 15,
      b = 17,
      c = 14,
      d = 17,
      e = 16,
      f = 12,
      g = 17,
      h = 16,
      i = 8,
      j = 6,
      k = 16,
      l = 8,
      m = 24,
      n = 16,
      o = 17,
      p = 17,
      q = 17,
      r = 11,
      s = 14,
      t = 12,
      u = 16,
      v = 15,
      w = 21,
      x = 16,
      y = 15,
      z = 14,
      ["0"] = 16,
      ["1"] = 16,
      ["2"] = 16,
      ["3"] = 16,
      ["4"] = 16,
      ["5"] = 16,
      ["6"] = 16,
      ["7"] = 16,
      ["8"] = 16,
      ["9"] = 16,
      ["Á"] = 19,
      ["É"] = 17,
      ["Í"] = 8,
      ["Ó"] = 22,
      ["Ö"] = 22,
      ["Ő"] = 22,
      ["Ú"] = 20,
      ["Ü"] = 20,
      ["Ű"] = 20,
      ["á"] = 15,
      ["é"] = 16,
      ["í"] = 8,
      ["ó"] = 17,
      ["ö"] = 17,
      ["ő"] = 17,
      ["ü"] = 16,
      ["ű"] = 16,
      ["ú"] = 16,
      ["("] = 10,
      [")"] = 10,
      ["<"] = 16,
      [">"] = 16,
      ["-"] = 10,
      ["."] = 7,
      ["\226\128\162"] = 10,
      [","] = 7,
      [":"] = 7,
      ["["] = 10,
      ["]"] = 10,
      ["'"] = 6,
      ["\""] = 13,
      [";"] = 7,
      ["?"] = 13,
      ["!"] = 8,
      ["*"] = 14,
      ["/"] = 12,
      ["\\"] = 12,
      ["$"] = 16,
      ["&"] = 20,
      ["@"] = 27,
      ["#"] = 20,
      _ = 14,
      ["\226\156\154"] = 22,
      ["\226\152\133"] = 21,
      ["\226\152\134"] = 21
    }
  }
}
local helperColor = {
  255,
  255,
  255
}
local colors = {
  hudwhite = {
    255,
    255,
    255
  },
  grey1 = {
    26,
    27,
    31
  },
  grey2 = {
    35,
    39,
    42
  },
  grey2a = {
    35,
    39,
    42,
    125
  },
  grey3 = {
    51,
    53,
    61
  },
  grey4 = {
    30,
    33,
    36
  },
  midgrey = {
    84,
    86,
    93
  },
  lightgrey = {
    186,
    190,
    196
  },
  green = {
    60,
    184,
    130
  },
  ["green-second"] = {
    60,
    184,
    170
  },
  red = {
    243,
    90,
    90
  },
  ["red-second"] = {
    250,
    120,
    95
  },
  blue = {
    49,
    154,
    215
  },
  ["blue-second"] = {
    49,
    180,
    225
  },
  yellow = {
    243,
    214,
    90
  },
  ["yellow-second"] = {
    250,
    240,
    130
  },
  orange = {
    255,
    149,
    20
  },
  ["orange-second"] = {
    250,
    179,
    40
  },
  purple = {
    255,
    149,
    20
  },
  ["purple-second"] = {
    250,
    179,
    40
  }
}
function refreshColors()
  for k in pairs(colors) do
    colors[k] = seexports.seal_gui:getColorCode(k) or {
      255,
      255,
      255
    }
  end
  helperColor[1] = (colors["red-second"][1] + colors["purple-second"][1]) / 2
  helperColor[2] = (colors["red-second"][2] + colors["purple-second"][2]) / 2
  helperColor[3] = (colors["red-second"][3] + colors["purple-second"][3]) / 2
end
local charsetTexture = {}
local currentCharset = "bebas"
function loadCharsetTexture(name)
  if isElement(charsetTexture) then
    destroyElement(charsetTexture)
  end
  local invalid = true
  if fileExists("files/charset_" .. name .. ".see") then
    local image = fileOpen("files/charset_" .. name .. ".see", true)
    if image then
      local data = fileRead(image, fileGetSize(image))
      fileClose(image)
      local checksum = sha256(data)
      if checksum == charsetData[name].checksum then
        invalid = false
        charsetTexture[name] = dxCreateTexture(data, "argb")
      end
    end
  end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), function()
  for k in pairs(charsetData) do
    if isElement(charsetTexture[k]) then
      destroyElement(charsetTexture[k])
    end
  end
end)
for k in pairs(charsetData) do
  loadCharsetTexture(k)
  for l in pairs(charsetData[k].letters) do
    charsetData[k].letters[l] = math.ceil(charsetData[k].letters[l])
  end
end
local charset = {
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "Á",
  "É",
  "Í",
  "Ó",
  "Ö",
  "Ő",
  "Ú",
  "Ü",
  "Ű",
  "á",
  "é",
  "í",
  "ó",
  "ö",
  "ő",
  "ú",
  "ü",
  "ű",
  "(",
  ")",
  "<",
  ">",
  "-",
  ".",
  "\226\128\162",
  ",",
  ":",
  "[",
  "]",
  "'",
  "\"",
  ";",
  "?",
  "!",
  "*",
  "/",
  "\\",
  "$",
  "&",
  "@",
  "#",
  "_",
  "\226\156\154",
  "\226\152\133",
  "\226\152\134"
}
local charsetPos = {}
for i = 1, #charset do
  charsetPos[charset[i]] = i
end
function getSpecialTextWidth(scale, text, charset)
  charset = charset or currentCharset
  local len = utf8.len(text)
  local w = 0
  for i = 1, len do
    local c = utf8.sub(text, i, i)
    if charsetPos[c] then
      w = w + charsetData[charset].letters[c] * scale
    else
      w = w + charsetData[charset].letters[" "] * scale
    end
  end
  return w
end
function drawSpecialText(x, y, scale, color, text, left, w, charset, r, wave)
  y = y - charsetSize * scale / 2
  local len = utf8.len(text)
  charset = charset or currentCharset
  if not left then
    w = w or getSpecialTextWidth(scale, text, charset)
    x = x - w / 2
  end
  local t = getTickCount() / 1000 % 1000 * math.pi
  for i = 1, len do
    local c = utf8.sub(text, i, i)
    if charsetPos[c] then
      local w = charsetData[charset].letters[c] * scale
      local wy = 0
      if wave then
        local t = getTickCount() / 150
        wy = math.sin((wave + i) * math.pi / 5 + t) * charsetSize * scale * 0.15
      end
      local col = color
      if c == "\226\156\154" then
        col = tocolor(colors.red[1], colors.red[2], colors.red[3])
      end
      if r then
        local sy = charsetSize * scale
        if 0 <= r then
          dxDrawImageSection(x - charsetSize * scale / 2 + w / 2, y + wy + sy * (1 - math.sin(r)), charsetSize * scale, sy * math.sin(r), 64 * (charsetPos[c] - 1), 0, charsetSize, charsetSize, charsetTexture[charset], 0, 0, 0, col)
        else
          r = math.abs(r)
          dxDrawImageSection(x - charsetSize * scale / 2 + w / 2, y + wy, charsetSize * scale, sy * math.sin(r), 64 * (charsetPos[c] - 1), 0, charsetSize, charsetSize, charsetTexture[charset], 0, 0, 0, col)
        end
      else
        dxDrawImageSection(x - charsetSize * scale / 2 + w / 2, y + wy, charsetSize * scale, charsetSize * scale, 64 * (charsetPos[c] - 1), 0, charsetSize, charsetSize, charsetTexture[charset], 0, 0, 0, col)
      end
      x = x + w
    else
      x = x + charsetData[charset].letters[" "] * scale
    end
  end
end
local showSelf = false
local globalScale = 0.85
local maximumDistance = 35
local anamesDistance = {1000, 1000}
local maxScale = 0.95
local minScale = 0.05
local nameSizeRange = {0.6, 1.05}
function getNameSize()
  return (maxScale - nameSizeRange[1]) / (nameSizeRange[2] - nameSizeRange[1]) * 100
end
function setNameSize(p)
  maxScale = nameSizeRange[1] + (nameSizeRange[2] - nameSizeRange[1]) * (p / 100)
end
local nameAlpha = 1
function getNameAlpha()
  return nameAlpha * 255
end
function setNameAlpha(p)
  nameAlpha = p / 255
end
function getNameFont()
  return currentCharset == "bebas" and "Betűtípus #1" or "Betűtípus #2"
end
function setNameFont(p)
  currentCharset = p == "Betűtípus #1" and "bebas" or "ubuntu"
end
local namesData = {}
local namesList = {}
local afkStart = {}
local animStart = {}
function helperLevelData(dat)
  if dat and 0 < dat then
    local text = dat == 1 and " (Ideiglenes Adminsegéd)" or " (SGH Adminsegéd)"
    return {text, 0}
  else
    return false
  end
end
function adminDutyData(el, dat)
  if dat then
    local lvl = getElementData(el, "acc.adminLevel") or 1
    local color = "green"
    local text = " (Admin " .. lvl .. ")"
    local name = getElementData(el, "acc.adminNick") or getElementData(el, "visibleName") or getPlayerName(el)
    if lvl == 12 then
      color = "orange-second"
      text = "</Rendszergazda>"
    elseif lvl == 11 then
      color = "red"
      text = "(Tulajdonos)"
    elseif lvl == 10 then
      color = "blue-second"
      text = "</Fejlesztő>"
    elseif lvl == 9 then
      color = "green-second"
      text = "(Manager)"
    elseif lvl == 8 then
      color = "green"
      text = "(Modeller)"
    elseif lvl == 6 then
      color = "yellow"
      text = "(FőAdmin)"
    elseif lvl == 7 then
      color = "orange"
      text = "(SuperAdmin)"
    end
    return {
      text,
      color,
      name,
      0,
      8 <= lvl
    }
  else
    return false
  end
end
function refreshElementNameData(el, elType, data)
  elType = elType or getElementType(el)
  if data and namesData[el] then
    for k, v in pairs(data) do
      namesData[el][k] = v
    end
  else
    data = data or {}
    if elType == "player" then
      namesData[el] = {
        visibleName = data.visibleName or getElementData(el, "visibleName") or getPlayerName(el),
        playerID = data.playerID or getElementData(el, "playerID"),
        tazed = data.tazed or getElementData(el, "tazed"),
        visibleWeapon = data.visibleWeapon or getElementData(el, "visibleWeapon"),
        usingArmor = data.usingArmor or getElementData(el, "usingArmor"),
        deathTag = data.deathTag or getElementData(el, "isPlayerDeath"),
        helperLevel = data.helperLevel or helperLevelData(getElementData(el, "acc.helperLevel")),
        facePaint = data.facePaint or getElementData(el, "paintVisibleOnPlayer"),
        cuffed = data.cuffed or getElementData(el, "cuffed"),
        inventoryState = data.inventoryState or getElementData(el, "inventoryUsingLocalPlayer"),
        badgeData = data.badgeData or getElementData(el, "badgeName"),
        badgeExData = data.badgeExData or getElementData(el, "pinName"),
        adminDuty = data.adminDuty or adminDutyData(el, getElementData(el, "adminDuty") == 1),
        lastRespawn = data.lastRespawn or getElementData(el, "lastRespawn"),
        playerGlueState = data.playerGlueState or getElementData(el, "playerGlueState"),
        bloodDamage = data.bloodDamage or getElementData(el, "bloodDamage"),
        seatBelt = data.seatBelt or getElementData(el, "player.seatBelt"),
        chat = data.chat,
        console = data.console,
        health = getElementHealth(el),
        type = "player",
        bubbles = {},
        adrenaline = getElementData(el, "adrenaline") or false
      }
      if getElementData(el, "afk") then
        local time = afkStart[el] or getTickCount() - (getElementData(el, "afkMinutes") or 0) * 60 * 1000
        afkStart[el] = time
        namesData[el].afkTimer = {
          time,
          "0",
          "0",
          ":",
          "0",
          "0",
          ":",
          "0",
          "0"
        }
      end
      if 0 < (getElementData(el, "startedAnim") or 0) then
        local time = animStart[el] or getTickCount() - (getElementData(el, "startedAnim") or 0)
        animStart[el] = time
        namesData[el].animTimer = {
          time,
          "0",
          "0",
          ":",
          "1",
          "0",
          ":",
          "0",
          "0"
        }
      end
    elseif elType == "ped" then
      namesData[el] = {
        visibleName = data.visibleName or getElementData(el, "visibleName"),
        pedNameType = data.pedNameType or getElementData(el, "pedNameType"),
        petType = data.petType or getElementData(el, "petType"),
        deathPed = data.deathPed or getElementData(el, "deathPed"),
        type = "ped"
      }
    end
  end
  if namesData[el] and namesData[el].cuffed and not tonumber(namesData[el].cuffed) then
    namesData[el].cuffed = getTickCount()
  end
  if namesData[el] and namesData[el].inventoryState and not tonumber(namesData[el].inventoryState) then
    namesData[el].inventoryState = getTickCount()
  end
  if namesData[el] and namesData[el].visibleName then
    namesData[el].visibleName = utf8.gsub(namesData[el].visibleName, "_", " ")
  end
end
addEvent("syncChatState", true)
addEventHandler("syncChatState", getRootElement(), function(state)
  if isElement(source) and (source ~= localPlayer or showSelf) and isElementStreamedIn(source) then
    local hc = false
    if not state and (not namesData[el] or namesData[el].console) then
      hc = getTickCount()
    end
    refreshElementNameData(source, "player", {
      chat = state and getTickCount(),
      hideChat = hc
    })
  end
end)
addEvent("syncConsoleState", true)
addEventHandler("syncConsoleState", getRootElement(), function(state)
  if isElement(source) and (source ~= localPlayer or showSelf) and isElementStreamedIn(source) then
    local hc = false
    if not state and (not namesData[el] or namesData[el].console) then
      hc = getTickCount()
    end
    refreshElementNameData(source, "player", {
      console = state and getTickCount(),
      hideConsole = hc
    })
  end
end)
local anamesState = 0
function getPlayerAfkStart(el)
  return afkStart[el]
end
function setVoiceState(el, state)
  if namesData[el] then
    namesData[el].voice = state
  end
end
function dataChangeHandler(data, old, new)
  new = new or false
  local elType = getElementType(source)
  if (source ~= localPlayer or showSelf) and (elType == "player" or elType == "ped") then
    if data == "startedAnim" then
      if new and 0 < new then
        animStart[source] = getTickCount() - new
      else
        animStart[source] = false
      end
    elseif data == "afk" then
      afkStart[source] = new and getTickCount() - (getElementData(source, "afkMinutes") or 0) * 60 * 1000 or false
    end
    if isElementStreamedIn(source) then
      if data == "visibleName" then
        if new and not namesData[source] then
          for i = 1, #namesList do
            if namesList[i] == source then
              return
            end
          end
          table.insert(namesList, source)
        end
        refreshElementNameData(source, elType, {visibleName = new})
      elseif data == "pedNameType" then
        refreshElementNameData(source, elType, {pedNameType = new})
      elseif data == "petType" then
        refreshElementNameData(source, elType, {petType = new})
      elseif data == "playerID" then
        refreshElementNameData(source, elType, {playerID = new})
      elseif data == "paintVisibleOnPlayer" then
        refreshElementNameData(source, elType, {facePaint = new})
      elseif data == "tazed" then
        refreshElementNameData(source, elType, {tazed = new})
      elseif data == "visibleWeapon" then
        refreshElementNameData(source, elType, {visibleWeapon = new})
      elseif data == "usingArmor" then
        refreshElementNameData(source, elType, {usingArmor = new})
      elseif data == "acc.helperLevel" then
        refreshElementNameData(source, elType, {
          helperLevel = helperLevelData(new)
        })
      elseif data == "isPlayerDeath" then
        refreshElementNameData(source, elType, {deathTag = new})
      elseif data == "cuffed" then
        if not new and old then
          refreshElementNameData(source, elType, {
            cuffedOff = getTickCount(),
            cuffed = new
          })
        else
          refreshElementNameData(source, elType, {cuffed = new})
        end
      elseif data == "acc.adminLevel" then
        if namesData[source] and namesData[source].adminDuty then
          refreshElementNameData(source, elType, {
            adminDuty = adminDutyData(source, true)
          })
        end
      elseif data == "adminDuty" then
        refreshElementNameData(source, elType, {
          adminDuty = adminDutyData(source, new == 1)
        })
      elseif data == "deathPed" then
        refreshElementNameData(source, elType, {deathPed = new})
      elseif data == "inventoryUsingLocalPlayer" then
        if not new and old then
          refreshElementNameData(source, elType, {
            inventoryOff = getTickCount(),
            inventoryState = new
          })
        else
          refreshElementNameData(source, elType, {inventoryState = new})
        end
      elseif data == "lastRespawn" then
        refreshElementNameData(source, elType, {lastRespawn = new})
      elseif data == "badgeName" then
        refreshElementNameData(source, elType, {badgeData = new})
      elseif data == "pinName" then
        refreshElementNameData(source, elType, {badgeExData = new})
      elseif data == "playerGlueState" then
        refreshElementNameData(source, elType, {playerGlueState = new})
      elseif data == "player.seatBelt" then
        refreshElementNameData(source, elType, {seatBelt = new})
      elseif data == "bloodDamage" then
        refreshElementNameData(source, elType, {bloodDamage = new})
      elseif data == "startedAnim" then
        if new and 0 < new then
          refreshElementNameData(source, elType, {
            animTimer = {
              animStart[source],
              "0",
              "0",
              ":",
              "1",
              "0",
              ":",
              "0",
              "0"
            }
          })
        else
          refreshElementNameData(source, elType, {animTimer = false})
        end
      elseif data == "afk" then
        if new then
          refreshElementNameData(source, elType, {
            afkTimer = {
              afkStart[source],
              "0",
              "0",
              ":",
              "0",
              "0",
              ":",
              "0",
              "0"
            }
          })
        else
          refreshElementNameData(source, elType, {afkTimer = false})
        end
      elseif data == "adrenaline" then
        refreshElementNameData(source, elType, {adrenaline = new})
      end
    end
  end
end
addEventHandler("onClientElementDataChange", getRootElement(), dataChangeHandler)
addEventHandler("onClientElementStreamIn", getRootElement(), function()
  local elType = getElementType(source)
  if (source ~= localPlayer or showSelf) and (elType == "player" or elType == "ped") then
    local visibleName = getElementData(source, "visibleName")
    if elType == "player" or elType == "ped" and visibleName then
      refreshElementNameData(source, elType, {visibleName = visibleName})
      for i = 1, #namesList do
        if namesList[i] == source then
          return
        end
      end
      table.insert(namesList, source)
    end
  end
end)
addEventHandler("onClientElementStreamOut", getRootElement(), function()
  local elType = getElementType(source)
  if (source ~= localPlayer or showSelf) and (elType == "player" or elType == "ped") then
    for i = 1, #namesList do
      if namesList[i] == source then
        table.remove(namesList, i)
        break
      end
    end
    namesData[source] = nil
  end
end)
addEventHandler("onClientElementDestroy", getRootElement(), function()
  for i = 1, #namesList do
    if namesList[i] == source then
      table.remove(namesList, i)
      break
    end
  end
  namesData[source] = nil
end)
addEventHandler("onClientPlayerQuit", getRootElement(), function()
  for i = 1, #namesList do
    if namesList[i] == source then
      table.remove(namesList, i)
      break
    end
  end
  namesData[source] = nil
  afkStart[source] = nil
end)
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  local players = getElementsByType("player", getRootElement(), true)
  for i = 1, #players do
    local player = players[i]
    if player and isElementStreamedIn(player) and (player ~= localPlayer or showSelf) then
      table.insert(namesList, player)
      refreshElementNameData(player, "player")
    end
  end
  local peds = getElementsByType("ped", getRootElement(), true)
  for i = 1, #peds do
    local ped = peds[i]
    if ped and isElementStreamedIn(ped) and getElementData(ped, "visibleName") then
      table.insert(namesList, ped)
      refreshElementNameData(ped, "ped")
    end
  end
end)
local bowAnim = {}
addEvent("npcChatBubble", true)
addEventHandler("npcChatBubble", getRootElement(), function(theType, text)
  if isElement(source) and (source ~= localPlayer or showSelf) and isElementStreamedIn(source) and namesData[source] then
    local x, y, z = getElementPosition(source)
    local px, py, pz = getElementPosition(localPlayer)
    local d = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
    if d <= 12 then
      local color = 255
      color = 50 + 205 * (1 - d / 12)
      outputChatBox(namesData[source].visibleName .. " mondja: " .. text, color, color, color)
      if not namesData[source].bubbles then
        namesData[source].bubbles = {}
      end
      table.insert(namesData[source].bubbles, {
        getTickCount(),
        text,
        theType
      })
    end
  end
end)
addEvent("chatBubble", true)
addEventHandler("chatBubble", getRootElement(), function(theType, text)
  if isElement(source) and (source ~= localPlayer or showSelf) and isElementStreamedIn(source) and namesData[source] then
    for i = #namesData[source].bubbles, 1, -1 do
      if namesData[source].bubbles[i][3] == theType and namesData[source].bubbles[i][2] == text then
        table.remove(namesData[source].bubbles, i)
      end
    end
    if #namesData[source].bubbles >= 5 then
      table.remove(namesData[source].bubbles, 1)
    end
    table.insert(namesData[source].bubbles, {
      getTickCount(),
      text,
      theType
    })
  end
end)
local currentChatState = false
local currentConsoleState = false
function dxDrawLine2(x, y, x2, y2, r, g, b, a)
  dxDrawLine(x + 1, y + 1, x2 + 1, y2 + 1, tocolor(0, 0, 0, a * 0.75))
  dxDrawLine(x, y, x2, y2, tocolor(r, g, b, a))
end
function dxDrawLineEx(p, x, y, x2, y2, r, g, b, a)
  if x <= p and p <= x2 then
    local pr = (p - x) / (x2 - x)
    dxDrawLine2(x, y, x + (x2 - x) * pr, y + (y2 - y) * pr, r, g, b, a)
    dxDrawLine2(x, y, x + (x2 - x) * (1 - pr), y + (y2 - y) * (1 - pr), r, g, b, a * 0.25)
    return y + (y2 - y) * pr
  elseif x2 <= p then
    dxDrawLine2(x, y, x2, y2, r, g, b, a)
  elseif p <= x then
    dxDrawLine2(x, y, x2, y2, r, g, b, a * 0.25)
  end
end
addEventHandler("onClientElementDataChange", localPlayer, function(dataName, oldValue, newValue)
  if dataName == "anamesState" then
    anamesState = newValue or 0
  end
end)
local tick = getTickCount()
function dxDrawRectangleEx(x, y, w, h, col, a)
  dxDrawRectangle(x + 2 + 1, y + 2 + 1, w - 4, h - 4, tocolor(0, 0, 0, a))
  dxDrawRectangle(x + 2, y + 2, w - 4, h - 4, col)
end
local squadSigns = {}
function setVehicleSquad(veh, color, name)
  for i = #squadSigns, 1, -1 do
    if squadSigns[i][1] == veh then
      table.remove(squadSigns, i)
    end
  end
  if color and name then
    table.insert(squadSigns, {
      veh,
      color,
      name
    })
  end
end
local showSquadSigns = true
function setSquadsVisible(val)
  showSquadSigns = val
  seelangCondHandl0(showSquadSigns)
end
function getSquadsVisible()
  return showSquadSigns
end
addEventHandler("onClientPreRender", getRootElement(), function()
  local state = isChatBoxInputActive()
  if state ~= currentChatState then
    currentChatState = state
    local players = getElementsByType("player", getRootElement(), true)
    if 1 < #players then
      triggerServerEvent("syncChatState", localPlayer, players, state)
    end
  end
  state = isConsoleActive()
  if state ~= currentConsoleState then
    currentConsoleState = state
    local players = getElementsByType("player", getRootElement(), true)
    if 1 < #players then
      triggerServerEvent("syncConsoleState", localPlayer, players, state)
    end
  end
end)
function renderSquadSigns()
  local camX, camY, camZ = getCameraMatrix()
  for i = #squadSigns, 1, -1 do
    local veh = squadSigns[i][1]
    if isElement(veh) then
      if isElementStreamedIn(veh) and isElementOnScreen(veh) then
        local m = getElementMatrix(veh)
        if m then
          local x, y, z = m[4][1], m[4][2], m[4][3]
          local px, py, pz = getVehicleComponentPosition(veh, "bump_rear_dummy")
          if px then
            x = x + m[2][1] * py + m[1][1] * px
            y = y + m[2][2] * py + m[1][2] * px
            z = z + m[2][3] * py + m[1][3] * px
          end
          local currentDistance = getDistanceBetweenPoints3D(camX, camY, camZ, x, y, z)
          if currentDistance <= maximumDistance then
            local sx, sy = getScreenFromWorldPosition(x, y, z, 512)
            local clear = isLineOfSightClear(camX, camY, camZ, x, y, z, true, true, false, true, false, true, false, veh)
            if sx and clear then
              local p = currentDistance / maximumDistance
              local scale = minScale + (maxScale - minScale) * (1 - p)
              scale = scale * globalScale * 1.1
              local col = "" .. squadSigns[i][2]
              local a = 1
              if 0.55 < p then
                a = 1 - (p - 0.55) / 0.44999999999999996
              end
              a = a * nameAlpha
              drawSpecialText(sx, sy, scale, tocolor(colors[col][1], colors[col][2], colors[col][3], 200 * a), squadSigns[i][3])
            end
          end
        end
      end
    else
      table.remove(squadSigns, i)
    end
  end
end
local showItems = {}
function updateItemShowList(list)
  if list then
    for i = 1, #list do
      local t = 0
      if showItems[list[i][1]] then
        t = showItems[list[i][1]][2]
      end
      showItems[list[i][1]] = {
        list[i][4],
        t
      }
    end
  end
end
function checkSpeed(el)
  local x, y, z = getElementVelocity(el)
  if x ^ 2 + y ^ 2 + z ^ 2 > 1.0E-4 then
    return true
  end
  local veh = getPedOccupiedVehicle(el)
  if veh then
    local x, y, z = getElementVelocity(veh)
    local speed = math.sqrt(x ^ 2 + y ^ 2 + z ^ 2)
    if speed * 180 * 1.1 > 1 then
      return true
    end
  end
  return false
end
function renderNametag()
  local now = getTickCount()
  local camX, camY, camZ, lookX, lookY, lookZ = getCameraMatrix()
  local localX, localY, localZ = getElementPosition(localPlayer)
  local delta = now - tick
  tick = now
  for i = 1, #namesList do
    local el = namesList[i]
    local data = namesData[el]
    if isElement(el) and data then
      local x, y, z = getPedBonePosition(el, 5)
      if not (x and y) or not z then
        x, y, z = 0, 0, 0
      end
      if x ~= x or y ~= y or z ~= z then
        x, y, z = 0, 0, 0
      end
      z = z + 0.325
      local currentDistance = getDistanceBetweenPoints3D(camX, camY, camZ, x, y, z)
      local maxD = data.type == "player" and 0 < anamesState and anamesDistance[2] or maximumDistance
      if currentDistance <= maxD and isElementOnScreen(el) then
        local sx, sy = getScreenFromWorldPosition(x, y, z, 256)
        if sx then
          local clear = true
          if (data.type ~= "player" or anamesState < 3) and getElementAlpha(el) < 50 then
            clear = false
          end
          if (data.type ~= "player" or anamesState < 3) and clear then
            local veh = getPedOccupiedVehicle(el) or data.playerGlueState
            clear = isLineOfSightClear(camX, camY, camZ, x, y, z, true, true, false, true, false, true, false, veh)
          end
          if clear then
            local p = currentDistance / maxD
            local scale = minScale + (maxScale - minScale) * (1 - p)
            scale = scale * globalScale
            if 0 < anamesState then
              scale = scale * 0.75
            end
            if not data.adminDuty and (data.badgeData or data.facePaint or data.badgeExData) then
              sy = sy - charsetSize * 0.6 * scale
            end
            if data.helperLevel then
              sy = sy - charsetSize * 0.65 * scale
            end
            if 0 < anamesState then
              sy = sy - 20 * scale
            end
            local a = 1
            if 0.55 < p then
              a = 1 - (p - 0.55) / 0.44999999999999996
            end
            a = a * nameAlpha
            local hp = getElementHealth(el)
            if data.type == "player" then
              if hp ~= data.health then
                if hp < data.health then
                  data.hpMinus = now
                  namesData[el].hpMinus = now
                end
                namesData[el].health = hp
              end
              if data.afkTimer then
                local s = scale * 0.6
                local sec = math.max(0, math.floor((now - data.afkTimer[1]) / 1000))
                local col = 0
                if 1200 <= sec then
                  col = tocolor(colors.red[1], colors.red[2], colors.red[3], 200 * a)
                elseif 600 <= sec then
                  col = tocolor(colors.orange[1], colors.orange[2], colors.orange[3], 200 * a)
                else
                  col = 0 < hp and tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 200 * a) or tocolor(80, 80, 80, 200 * a)
                end
                local control = checkSpeed(el)
                if control then
                  if not data.afkP then
                    data.afkP = 0
                  end
                  if 1 > data.afkP then
                    data.afkP = data.afkP + delta / 250
                    if 1 < data.afkP then
                      data.afkP = 1
                    end
                  end
                elseif data.afkP and 0 < data.afkP then
                  data.afkP = data.afkP - delta / 250
                  if 0 > data.afkP then
                    data.afkP = 0
                  end
                end
                local ip = data.afkP or 0
                local ims = 128 * s
                local imy = sy - charsetSize * 0.8 * scale - ims
                local imx = sx - ims
                local w = getSpecialTextWidth(s, "0")
                if 0 < ip then
                  ims = ims + (charsetSize / 2 * scale - ims) * ip
                  imy = imy + (sy - charsetSize * 0.6 * scale - ims / 2 - imy) * ip
                  imx = sx - ims * (1 - ip) - (w * 4 + charsetSize / 2 * scale * 1.25) * ip
                end
                seelangStaticImageUsed[0] = true
                if seelangStaticImageToc[0] then
                  processSeelangStaticImage[0]()
                end
                dxDrawImage(imx, imy, ims * 2, ims, seelangStaticImage[0], 0, 0, 0, col)
                s = scale * 0.8
                min = math.floor(sec / 60)
                sec = sec - 60 * min
                hour = math.floor(min / 60)
                min = min - 60 * hour
                local text = string.format("%02d:%02d:%02d", hour, min, sec)
                local cw = charsetData[currentCharset].letters["0"] * s
                local sx = sx - w * 8 / 2
                if 0 < ip then
                  sx = sx + charsetSize / 2 * scale * 1.25 * ip / 2
                end
                for i = 1, 8 do
                  local c = utf8.sub(text, i, i)
                  local old = type(data.afkTimer[1 + i]) == "table" and data.afkTimer[1 + i][2] or data.afkTimer[1 + i]
                  if old ~= c then
                    data.afkTimer[1 + i] = {
                      old,
                      c,
                      now
                    }
                  end
                  local dat = data.afkTimer[1 + i]
                  if type(dat) == "table" then
                    local p = (now - dat[3]) / 500
                    if 1 <= p then
                      p = 1
                    end
                    p = p * 2
                    local tw = cw - charsetData[currentCharset].letters[dat[1]] * s
                    local r = math.rad(90 - 90 * math.min(1, p))
                    drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, dat[1], true, false, false, r)
                    p = p - 1
                    local tw = cw - charsetData[currentCharset].letters[dat[2]] * s
                    local r = math.rad(90 * math.max(0, p))
                    drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, dat[2], true, false, false, -r)
                    if 1 <= p then
                      data.afkTimer[1 + i] = dat[2]
                    end
                  else
                    local tw = cw - charsetData[currentCharset].letters[c] * s
                    drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, c, true, false, false, r)
                  end
                  sx = sx + w
                end
              else
                local animY = 0
                if hp <= 0 then
                  local p = now % 4900 / 700
                  local s = scale * 0.4
                  animY = charsetSize * 0.6 * scale + 256 * s
                  local p1 = math.min(0.5, p) / 0.5
                  local p2 = getEasingValue(math.min(1, p), "OutBounce", 0.4, 0.5)
                  seelangStaticImageUsed[1] = true
                  if seelangStaticImageToc[1] then
                    processSeelangStaticImage[1]()
                  end
                  dxDrawImage(sx - 128 * s, sy - charsetSize * 0.6 * scale - 256 * s * (4 - p2 * 3), 256 * s, 256 * s, seelangStaticImage[1], 0, 0, 0, tocolor(80, 80, 80, 200 * a * p1))
                  seelangStaticImageUsed[2] = true
                  if seelangStaticImageToc[2] then
                    processSeelangStaticImage[2]()
                  end
                  dxDrawImage(sx - 128 * s, sy - charsetSize * 0.6 * scale - 256 * s, 256 * s, 256 * s, seelangStaticImage[2], 0, 0, 0, tocolor(80, 80, 80, 200 * a))
                  local cw = 10 * s
                  local ch = 70 * s
                  local cw2 = ch * 0.6
                  local p3 = math.max(0, math.min(1, (p - 1) / 0.35))
                  local p4 = math.max(0, math.min(1, (p - 1.5) / 0.35))
                  dxDrawRectangle(sx - cw / 2 + 1, sy - charsetSize * 0.6 * scale - 128 * s - ch / 2 + 1, cw, ch * p3, tocolor(0, 0, 0, 125 * a))
                  dxDrawRectangle(sx - cw2 / 2 + 1, sy - charsetSize * 0.6 * scale - 128 * s - ch / 2 + ch * 0.3 - cw / 2 + 1, cw2 * p4, cw, tocolor(0, 0, 0, 125 * a))
                  dxDrawRectangle(sx - cw / 2, sy - charsetSize * 0.6 * scale - 128 * s - ch / 2, cw, ch * p3, tocolor(80, 80, 80, 255 * a))
                  dxDrawRectangle(sx - cw2 / 2, sy - charsetSize * 0.6 * scale - 128 * s - ch / 2 + ch * 0.3 - cw / 2, cw2 * p4, cw, tocolor(80, 80, 80, 255 * a))
                elseif showItems[el] then
                  local p = 1
                  showItems[el][2] = showItems[el][2] + delta / 1000
                  if 5 < showItems[el][2] then
                    p = 1 - (showItems[el][2] - 5) / 0.5
                  elseif showItems[el][2] < 0.5 then
                    p = showItems[el][2] / 0.5
                  end
                  if p < 0 then
                    showItems[el] = nil
                  elseif not isElement(showItems[el][1]) then
                    showItems[el] = nil
                  elseif 0 < p then
                    local s = scale * 1.25
                    animY = 132 * s
                    dxDrawImage(sx - 512 * s / 2, sy - 132 * s, 512 * s, 132 * s, showItems[el][1], 0, 0, 0, tocolor(255, 255, 255, 230 * a * p))
                  end
                elseif data.adminDuty then
                  local s = scale * 0.4
                  animY = (data.adminDuty[5] and 350 or 384) * s
                  local control = checkSpeed(el)
                  if not control then
                    if 1 > data.adminDuty[4] then
                      data.adminDuty[4] = data.adminDuty[4] + delta / 650
                      if 1 < data.adminDuty[4] then
                        data.adminDuty[4] = 1
                      end
                    end
                  elseif 0 < data.adminDuty[4] then
                    data.adminDuty[4] = data.adminDuty[4] - delta / 650
                    if 0 > data.adminDuty[4] then
                      data.adminDuty[4] = 0
                    end
                  end
                  local p = data.adminDuty[4]
                  animY = animY * p
                  local col = data.adminDuty[2]
                  if data.adminDuty[5] then
                    if p < 1 then
                      if 0 < p then
                        p = p * 3
                        local p2 = math.min(1, math.max(0, p))
                        local pos = 200 * s * (1 - p2)
                        seelangStaticImageUsed[3] = true
                        if seelangStaticImageToc[3] then
                          processSeelangStaticImage[3]()
                        end
                        dxDrawImage(sx - 150 * s - pos, sy - charsetSize * 0.45 * scale - 300 * s + pos / 2, 300 * s, 300 * s, seelangStaticImage[3], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a * p2))
                        p = p - 1
                        local p2 = math.min(1, math.max(0, p))
                        local pos = 200 * s * (1 - p2)
                        seelangStaticImageUsed[4] = true
                        if seelangStaticImageToc[4] then
                          processSeelangStaticImage[4]()
                        end
                        dxDrawImage(sx - 150 * s + pos, sy - charsetSize * 0.45 * scale - 300 * s + pos / 2, 300 * s, 300 * s, seelangStaticImage[4], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a * p2))
                        p = p - 1
                        local p2 = math.min(1, math.max(0, p))
                        local pos = 200 * s * (1 - p2)
                        seelangStaticImageUsed[5] = true
                        if seelangStaticImageToc[5] then
                          processSeelangStaticImage[5]()
                        end
                        dxDrawImage(sx - 150 * s, sy - charsetSize * 0.45 * scale - 300 * s - pos, 300 * s, 300 * s, seelangStaticImage[5], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a * p2))
                      end
                    else
                      seelangStaticImageUsed[6] = true
                      if seelangStaticImageToc[6] then
                        processSeelangStaticImage[6]()
                      end
                      dxDrawImage(sx - 150 * s, sy - charsetSize * 0.45 * scale - 300 * s, 300 * s, 300 * s, seelangStaticImage[6], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a))
                    end
                  elseif p < 1 then
                    if 0 < p then
                      p = p * 2
                      s = s * (0.5 + math.min(1, p) * 0.5)
                      seelangStaticImageUsed[7] = true
                      if seelangStaticImageToc[7] then
                        processSeelangStaticImage[7]()
                      end
                      dxDrawImage(sx - 192 * s, sy - charsetSize * 0.225 * scale - 384 * s, 384 * s, 384 * s, seelangStaticImage[7], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a * math.min(1, p)))
                      p = p - 1
                      p = math.max(0, math.min(1, p))
                      local s2 = s * (0.5 + p * 0.5)
                      seelangStaticImageUsed[8] = true
                      if seelangStaticImageToc[8] then
                        processSeelangStaticImage[8]()
                      end
                      dxDrawImage(sx - 192 * s2, sy - charsetSize * 0.225 * scale - 384 * s2, 384 * s2, 384 * s2, seelangStaticImage[8], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a * p))
                    end
                  else
                    seelangStaticImageUsed[9] = true
                    if seelangStaticImageToc[9] then
                      processSeelangStaticImage[9]()
                    end
                    dxDrawImage(sx - 192 * s, sy - charsetSize * 0.225 * scale - 384 * s, 384 * s, 384 * s, seelangStaticImage[9], 0, 0, 0, tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a))
                  end
                elseif data.animTimer and 0 < hp then
                  local s = scale * 0.6
                  local pin = now - data.animTimer[1]
                  local maxAnimTime = data.adrenaline and 15 or 10
                  local sec = maxAnimTime * 60 - math.floor(pin / 1000)
                  if sec < 0 then
                    sec = 0
                  end
                  local col = 0
                  seelangStaticImageUsed[10] = true
                  if seelangStaticImageToc[10] then
                    processSeelangStaticImage[10]()
                  end
                  s = scale * 0.8
                  local w = getSpecialTextWidth(s, "0")
                  local cw = charsetData[currentCharset].letters["0"] * s
                  if sec <= 120 then
                    col = tocolor(colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  elseif sec <= 240 then
                    col = tocolor(colors.orange[1], colors.orange[2], colors.orange[3], 200 * a)
                  else
                    col = tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 200 * a)
                  end
                  local ey = 30 * scale
                  local ew = w * 0.5
                  local y = sy - charsetSize * 0.8 * scale - ey * 1.35
                  animY = ey * 2 + charsetSize * 0.8 * scale
                  if sec <= 240 then
                    ey = 30 * scale * (sec / 240)
                  end
                  local p = sx - ew * 10 + pin % 2000 / 2000 * ew * 20
                  local ly = y
                  local ny = dxDrawLineEx(p, sx - ew * 5 - ew * 5, y, sx - ew * 5 - ew * 2, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx - ew * 5 - ew * 2, y, sx - ew * 5 - ew, y - ey, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx - ew * 5 - ew, y - ey, sx - ew * 5 + ew * 0.7, y + ey * 0.5, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx - ew * 5 + ew * 0.7, y + ey * 0.5, sx - ew * 5 + ew * 1.4, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx - ew * 5 + ew * 1.4, y, sx - ew * 5 + ew * 5, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx + ew * 5 - ew * 5, y, sx + ew * 5 - ew * 2, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx + ew * 5 - ew * 2, y, sx + ew * 5 - ew, y - ey, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx + ew * 5 - ew, y - ey, sx + ew * 5 + ew * 0.7, y + ey * 0.5, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx + ew * 5 + ew * 0.7, y + ey * 0.5, sx + ew * 5 + ew * 1.4, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  local ny = dxDrawLineEx(p, sx + ew * 5 + ew * 1.4, y, sx + ew * 5 + ew * 5, y, colors.red[1], colors.red[2], colors.red[3], 200 * a)
                  ly = ny or ly
                  dxDrawRectangle(p - 2 + 1, ly - 2 + 1, 4, 4, tocolor(0, 0, 0, 150 * a))
                  dxDrawRectangle(p - 2, ly - 2, 4, 4, tocolor(colors.red[1], colors.red[2], colors.red[3], 200 * a))
                  min = math.floor(sec / 60)
                  sec = sec - 60 * min
                  hour = math.floor(min / 60)
                  min = min - 60 * hour
                  local text = string.format("%02d:%02d:%02d", hour, min, sec)
                  local sx = sx - w * 8 / 2
                  for i = 1, 8 do
                    local c = utf8.sub(text, i, i)
                    local old = type(data.animTimer[1 + i]) == "table" and data.animTimer[1 + i][2] or data.animTimer[1 + i]
                    if old ~= c then
                      data.animTimer[1 + i] = {
                        old,
                        c,
                        now
                      }
                    end
                    local dat = data.animTimer[1 + i]
                    if type(dat) == "table" then
                      local p = (now - dat[3]) / 500
                      if 1 <= p then
                        p = 1
                      end
                      p = p * 2
                      local tw = cw - charsetData[currentCharset].letters[dat[1]] * s
                      local r = math.rad(90 - 90 * math.min(1, p))
                      drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, dat[1], true, false, false, r)
                      p = p - 1
                      local tw = cw - charsetData[currentCharset].letters[dat[2]] * s
                      local r = math.rad(90 * math.max(0, p))
                      drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, dat[2], true, false, false, -r)
                      if 1 <= p then
                        data.animTimer[1 + i] = dat[2]
                      end
                    else
                      local tw = cw - charsetData[currentCharset].letters[c] * s
                      drawSpecialText(sx + tw / 2, sy - charsetSize * 0.6 * scale, s, col, c, true, false, false, r)
                    end
                    sx = sx + w
                  end
                elseif data.inventoryState or data.inventoryOff then
                  local p = math.min(1, (getTickCount() - (data.inventoryState or data.inventoryOff)) / 1000)
                  if not data.inventoryState then
                    p = 1 - p
                    if p <= 0 then
                      p = 0
                      namesData[el].inventoryOff = nil
                    end
                  end
                  if p < 1 then
                    p = getEasingValue(p, "InOutQuad")
                  end
                  local s = scale * 0.6
                  local ts = 200
                  local ty = 64
                  local p2 = math.max(0, math.min(1, p / 0.25))
                  p = math.max(0, (p - 0.25) / 0.75)
                  animY = ts * s + 32 * s
                  local a2 = math.min(1, math.abs(1 - 2 * p) / 0.25)
                  seelangStaticImageUsed[11] = true
                  if seelangStaticImageToc[11] then
                    processSeelangStaticImage[11]()
                  end
                  dxDrawImage(sx - ts / 2 * s, sy - ts * s - 32 * s, ts * s, ts * s, seelangStaticImage[11], 0, 0, 0, tocolor(255, 255, 255, 225 * a * p2))
                  seelangStaticImageUsed[12] = true
                  if seelangStaticImageToc[12] then
                    processSeelangStaticImage[12]()
                  end
                  dxDrawImage(sx - ts / 2 * s, sy - ts / 2 * s - 32 * s - ty * s, ts * s, ty * s, seelangStaticImage[12], 0, 0, 0, tocolor(255, 255, 255, 225 * a * p2 * p))
                  seelangStaticImageUsed[13] = true
                  if seelangStaticImageToc[13] then
                    processSeelangStaticImage[13]()
                  end
                  dxDrawImage(sx - ts / 2 * s, sy - ts / 2 * s - 32 * s - ty * s, ts * s, ty * s * (1 - 2 * p), seelangStaticImage[13], 0, 0, 0, tocolor(255, 255, 255, 225 * a * p2 * a2))
                elseif data.cuffed or data.cuffedOff then
                  local p = 0
                  if data.cuffedOff then
                    p = 5 - (now - data.cuffedOff) / 200
                  else
                    p = (now - data.cuffed) / 200
                  end
                  if 5 < p then
                    p = 5
                  end
                  if p < 0 then
                    p = 0
                    namesData[el].cuffedOff = false
                  end
                  local s = scale * 0.6
                  local tx = 200
                  local ty = 162
                  local ts2 = 128
                  local p2 = math.max(0, math.min(1, p / 0.5))
                  p = p - 1.5
                  animY = ty * s - 32 * s
                  seelangStaticImageUsed[14] = true
                  if seelangStaticImageToc[14] then
                    processSeelangStaticImage[14]()
                  end
                  dxDrawImage(sx - tx / 2 * s - 45 * s, sy - ty * s - 32 * s + 50 * s, ts2 * s, ts2 * s, seelangStaticImage[14], 10 - 70 * math.max(0, math.min(1, p)), 0, 0, tocolor(120, 120, 120, 225 * a * p2))
                  p = p - 2.5
                  seelangStaticImageUsed[14] = true
                  if seelangStaticImageToc[14] then
                    processSeelangStaticImage[14]()
                  end
                  dxDrawImage(sx + tx / 2 * s + 46 * s, sy - ty * s - 32 * s + 50 * s, -ts2 * s, ts2 * s, seelangStaticImage[14], -10 + 70 * math.max(0, math.min(1, p)), 0, 0, tocolor(120, 120, 120, 225 * a * p2))
                  seelangStaticImageUsed[15] = true
                  if seelangStaticImageToc[15] then
                    processSeelangStaticImage[15]()
                  end
                  dxDrawImage(sx - tx / 2 * s, sy - ty * s - 32 * s, tx * s, ty * s, seelangStaticImage[15], 0, 0, 0, tocolor(120, 120, 120, 225 * a * p2))
                elseif data.tazed then
                  local s = scale * 0.85
                  animY = 256 * s
                  local x = 0
                  local lx = 0
                  for i = 1, 6.75 do
                    x = math.random(-40, 40) / 10 * s
                    dxDrawLine(sx - 128 * s + 188 * s + lx, sy - 256 * s + 80 * s + (i - 1) * 4 * s, sx - 128 * s + 188 * s + x, sy - 256 * s + 80 * s + i * 4 * s, tocolor(colors["blue-second"][1], colors["blue-second"][2], colors["blue-second"][3], 175 * a))
                    lx = x
                  end
                  seelangStaticImageUsed[16] = true
                  if seelangStaticImageToc[16] then
                    processSeelangStaticImage[16]()
                  end
                  dxDrawImage(sx - 128 * s, sy - 256 * s, 256 * s, 256 * s, seelangStaticImage[16], 0, 0, 0, tocolor(255, 255, 255, 175 * a))
                elseif data.lastRespawn then
                  local p = now % 4900 / 700
                  local s = scale * 0.4
                  animY = charsetSize * 0.8 * scale + 256 * s
                  local p1 = math.min(0.5, p) / 0.5
                  local p2 = getEasingValue(math.min(1, p), "OutBounce", 0.4, 0.5)
                  seelangStaticImageUsed[17] = true
                  if seelangStaticImageToc[17] then
                    processSeelangStaticImage[17]()
                  end
                  dxDrawImage(sx - 128 * s, sy - charsetSize * 0.8 * scale - 256 * s * (4 - p2 * 3), 256 * s, 256 * s, seelangStaticImage[17], 0, 0, 0, tocolor(colors.red[1], colors.red[2], colors.red[3], 225 * a * p1))
                  local cw = 64 * s
                  local ch = 16 * s
                  local p3 = math.max(0, math.min(1, (p - 1) / 0.35))
                  local p4 = math.max(0, math.min(1, (p - 1.5) / 0.35))
                  dxDrawRectangle(sx - cw / 2 + 1, sy - charsetSize * 0.8 * scale - 256 * s + 50 * s - ch / 2 + 1, cw * p3, ch, tocolor(0, 0, 0, 125 * a))
                  dxDrawRectangle(sx - ch / 2 + 1, sy - charsetSize * 0.8 * scale - 256 * s + 50 * s - cw / 2 + 1, ch, cw * p4, tocolor(0, 0, 0, 125 * a))
                  dxDrawRectangle(sx - cw / 2, sy - charsetSize * 0.8 * scale - 256 * s + 50 * s - ch / 2, cw * p3, ch, tocolor(colors.red[1], colors.red[2], colors.red[3], 255 * a))
                  dxDrawRectangle(sx - ch / 2, sy - charsetSize * 0.8 * scale - 256 * s + 50 * s - cw / 2, ch, cw * p4, tocolor(colors.red[1], colors.red[2], colors.red[3], 255 * a))
                  if 0 < data.lastRespawn then
                    drawSpecialText(sx, sy - charsetSize * scale * 0.6, scale * 0.8, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 225 * a), data.lastRespawn .. " perce éledt újra")
                  else
                    drawSpecialText(sx, sy - charsetSize * scale * 0.6, scale * 0.8, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 225 * a), "Most éledt újra")
                  end
                elseif data.helperLevel then
                  local s = scale * 0.4
                  animY = 384 * s
                  local control = checkSpeed(el)
                  if not control then
                    if 1 > data.helperLevel[2] then
                      data.helperLevel[2] = data.helperLevel[2] + delta / 650
                      if 1 < data.helperLevel[2] then
                        data.helperLevel[2] = 1
                      end
                    end
                  elseif 0 < data.helperLevel[2] then
                    data.helperLevel[2] = data.helperLevel[2] - delta / 650
                    if 0 > data.helperLevel[2] then
                      data.helperLevel[2] = 0
                    end
                  end
                  local p = data.helperLevel[2]
                  animY = animY * math.min(1, p * 2)
                  if p < 1 then
                    if 0 < p then
                      p = p * 2
                      s = s * (0.5 + math.min(1, p) * 0.5)
                      seelangStaticImageUsed[7] = true
                      if seelangStaticImageToc[7] then
                        processSeelangStaticImage[7]()
                      end
                      dxDrawImage(sx - 192 * s, sy - charsetSize * 0.225 * scale - 384 * s, 384 * s, 384 * s, seelangStaticImage[7], 0, 0, 0, tocolor(helperColor[1], helperColor[2], helperColor[3], 255 * a * math.min(1, p)))
                      p = p - 1
                      p = math.max(0, math.min(1, p))
                      local s2 = s * (0.5 + p * 0.5)
                      seelangStaticImageUsed[8] = true
                      if seelangStaticImageToc[8] then
                        processSeelangStaticImage[8]()
                      end
                      dxDrawImage(sx - 192 * s2, sy - charsetSize * 0.225 * scale - 384 * s2, 384 * s2, 384 * s2, seelangStaticImage[8], 0, 0, 0, tocolor(helperColor[1], helperColor[2], helperColor[3], 255 * a * p))
                    end
                  else
                    seelangStaticImageUsed[9] = true
                    if seelangStaticImageToc[9] then
                      processSeelangStaticImage[9]()
                    end
                    dxDrawImage(sx - 192 * s, sy - charsetSize * 0.225 * scale - 384 * s, 384 * s, 384 * s, seelangStaticImage[9], 0, 0, 0, tocolor(helperColor[1], helperColor[2], helperColor[3], 255 * a))
                  end
                end
                if data.chat or data.console or data.hideChat or data.hideConsole then
                  local t = now - (data.chat or data.console or data.hideChat or data.hideConsole)
                  local s = scale * 0.9
                  local y = charsetSize * scale * 0.75 + animY
                  local char = "\226\128\162"
                  if data.console or data.hideConsole then
                    char = "_"
                  end
                  local w1 = getSpecialTextWidth(s, char) + 8 * scale
                  local inP = math.min(1, t / 300)
                  if data.hideChat or data.hideConsole then
                    inP = 1 - inP
                    if inP <= 0 then
                      inP = 0
                      namesData[el].hideChat = false
                      namesData[el].hideConsole = false
                    end
                  end
                  if data.chat or data.console or data.hideChat or data.hideConsole then
                    local sx = sx - w1
                    if data.console or data.hideConsole then
                      sx = sx - w1 / 2
                      drawSpecialText(sx - w1, sy - y, s + 0.4 * p, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a), ">")
                    end
                    for i = 1, 3 do
                      local p = 0
                      if 1 <= inP then
                        p = (t - 300) / 300 % 3
                      end
                      p = math.min(math.max(p - i + 1, 0), 1)
                      p = p * 2
                      if 1 < p then
                        p = 2 - p
                      end
                      if data.console then
                        drawSpecialText(sx, sy - y, s, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a * p), char)
                      else
                        local a2 = 0.75 + 0.25 * p
                        drawSpecialText(sx, sy - y, s, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a * a2), char)
                      end
                      sx = sx + w1 * inP
                    end
                  end
                end
                if 0 < #data.bubbles then
                  local y = charsetSize * scale * 0.75 * ((data.chat or data.console or data.hideChat or data.hideConsole) and 2 or 1) + animY
                  for j = #data.bubbles, 1, -1 do
                    local text = data.bubbles[j][2]
                    local msgType = data.bubbles[j][3]
                    if msgType == "me" or msgType == "trygreen" or msgType == "tryred" then
                      text = "* " .. text
                    elseif msgType == "melow" then
                      text = "[LOW] * " .. text
                    elseif msgType == "ame" then
                      text = "> " .. text
                    elseif msgType == "do" then
                      text = "* " .. text
                    elseif msgType == "dolow" then
                      text = "[LOW] * " .. text
                    elseif msgType == "megaphone" then
                      text = "<O " .. text
                    end
                    local d = now - data.bubbles[j][1]
                    local p = d / 25
                    local len = utf8.len(text)
                    local a2 = math.min(3, p) / 3
                    if p > math.max(175, len * 5) then
                      local p = p - math.max(175, len * 5)
                      p = p / 3
                      if 1 < p then
                        p = 1
                      end
                      a2 = 1 - p
                    end
                    if p > len then
                      p = len
                    end
                    local bubbleColor = tocolor(0, 0, 0, 150 * a * a2)
                    local tr, tg, tb = colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3]
                    if msgType == "me" then
                      tr, tg, tb = 194, 162, 218
                    elseif msgType == "melow" then
                      tr, tg, tb = 219, 197, 235
                    elseif msgType == "ame" then
                      tr, tg, tb = 149, 108, 180
                    elseif msgType == "do" then
                      tr, tg, tb = 255, 40, 80
                    elseif msgType == "dolow" then
                      tr, tg, tb = 255, 102, 130
                    elseif msgType == "trygreen" then
                      tr, tg, tb = colors.green[1], colors.green[2], colors.green[3]
                    elseif msgType == "tryred" then
                      tr, tg, tb = colors.red[1], colors.red[2], colors.red[3]
                    elseif msgType == "megaphone" then
                      tr, tg, tb = 255, 255, 0
                    end
                    local char = 1 + math.floor(p)
                    local text1 = utf8.sub(text, 1, char - 1)
                    local text2 = utf8.sub(text, char, char)
                    local s = scale * 0.8
                    local w = getSpecialTextWidth(s, text, "ubuntu")
                    local w2 = getSpecialTextWidth(s, text1, "ubuntu")
                    local w3 = getSpecialTextWidth(s, text2, "ubuntu")
                    local p2 = p % 1
                    local feather = math.ceil(12 * s)
                    local bx = math.floor(sx - w / 2)
                    local by = math.floor(sy - y - 17 * s)
                    local bw = math.ceil(w2 + w3 * p2)
                    local bh = math.ceil(34 * s)
                    seelangStaticImageUsed[18] = true
                    if seelangStaticImageToc[18] then
                      processSeelangStaticImage[18]()
                    end
                    dxDrawImage(bx, by, -feather, bh, seelangStaticImage[18], 0, 0, 0, bubbleColor)
                    seelangStaticImageUsed[18] = true
                    if seelangStaticImageToc[18] then
                      processSeelangStaticImage[18]()
                    end
                    dxDrawImage(bx + bw, by, feather, bh, seelangStaticImage[18], 0, 0, 0, bubbleColor)
                    seelangStaticImageUsed[19] = true
                    if seelangStaticImageToc[19] then
                      processSeelangStaticImage[19]()
                    end
                    dxDrawImage(bx, by, bw, -feather, seelangStaticImage[19], 0, 0, 0, bubbleColor)
                    seelangStaticImageUsed[19] = true
                    if seelangStaticImageToc[19] then
                      processSeelangStaticImage[19]()
                    end
                    dxDrawImage(bx, by + bh, bw, feather, seelangStaticImage[19], 0, 0, 0, bubbleColor)
                    seelangStaticImageUsed[20] = true
                    if seelangStaticImageToc[20] then
                      processSeelangStaticImage[20]()
                    end
                    dxDrawImage(bx, by, -feather, -feather, seelangStaticImage[20], 90, 0, 0, bubbleColor)
                    seelangStaticImageUsed[20] = true
                    if seelangStaticImageToc[20] then
                      processSeelangStaticImage[20]()
                    end
                    dxDrawImage(bx + bw, by, feather, -feather, seelangStaticImage[20], 270, 0, 0, bubbleColor)
                    seelangStaticImageUsed[20] = true
                    if seelangStaticImageToc[20] then
                      processSeelangStaticImage[20]()
                    end
                    dxDrawImage(bx, by + bh, -feather, feather, seelangStaticImage[20], 270, 0, 0, bubbleColor)
                    seelangStaticImageUsed[20] = true
                    if seelangStaticImageToc[20] then
                      processSeelangStaticImage[20]()
                    end
                    dxDrawImage(bx + bw, by + bh, feather, feather, seelangStaticImage[20], 90, 0, 0, bubbleColor)
                    dxDrawRectangle(bx, by, bw, bh, bubbleColor)
                    drawSpecialText(bx, by + 17 * s, s, tocolor(tr, tg, tb, 255 * a * a2), text1, true, false, "ubuntu")
                    drawSpecialText(bx + w2, by + 17 * s, s, tocolor(tr, tg, tb, 255 * a * a2 * p2), text2, true, false, "ubuntu")
                    if a2 <= 0 and 1 <= p then
                      table.remove(namesData[el].bubbles, j)
                    end
                    y = y + bh + feather * 2 + 4 * scale
                  end
                end
              end
              if data.helperLevel then
                drawSpecialText(sx, sy, scale * 0.85, tocolor(helperColor[1], helperColor[2], helperColor[3], 255 * a), data.helperLevel[1])
                sy = sy + charsetSize * 0.65 * scale
              end
              local white = 0 < anamesState and "red" or "hudwhite"
              if 0 < anamesState then
                local w = 230 * scale
                local sx = sx - w / 2
                local sy = sy + 32 * scale
                if not data.adminDuty and (data.badgeData or data.facePaint or data.badgeExData) then
                  sy = sy + charsetSize * 0.6 * scale
                end
                dxDrawRectangle(sx - 2, sy - 1, w + 4, 12 * scale + 2, tocolor(0, 0, 0, 200 * a))
                dxDrawRectangle(sx - 1, sy, w / 2 + 1, 12 * scale, tocolor(colors.green[1] * 0.5, colors.green[2] * 0.5, colors.green[3] * 0.5, 200 * a))
                dxDrawRectangle(sx + w / 2, sy, w / 2 + 1, 12 * scale, tocolor(colors.blue[1] * 0.5, colors.blue[2] * 0.5, colors.blue[3] * 0.5, 200 * a))
                dxDrawRectangle(sx - 1, sy, w / 2 * getElementHealth(el) / 100, 12 * scale, tocolor(colors.green[1], colors.green[2], colors.green[3], 255 * a))
                dxDrawRectangle(sx + w / 2 + 1, sy, w / 2 * getPedArmor(el) / 100, 12 * scale, tocolor(colors.blue[1], colors.blue[2], colors.blue[3], 255 * a))
                dxDrawRectangle(sx + w / 2 - 1, sy, 2, 12 * scale, tocolor(0, 0, 0, 200 * a))
              end
              if data.adminDuty then
                local w = getSpecialTextWidth(scale, data.adminDuty[3] .. " ")
                local w2 = getSpecialTextWidth(scale, data.adminDuty[1])
                sx = sx - (w + w2) / 2
                local col = data.adminDuty[2]
                if 0 < anamesState then
                  local w3 = getSpecialTextWidth(scale, "(" .. data.playerID .. ") ")
                  sx = sx - w3 / 3
                  drawSpecialText(sx, sy, scale, 0 < hp and tocolor(colors[white][1], colors[white][2], colors[white][3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.adminDuty[3], true, w)
                  drawSpecialText(sx + w, sy, scale, 0 < hp and tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a) or tocolor(80, 80, 80, 225 * a), "(" .. data.playerID .. ")", true, w2)
                  drawSpecialText(sx + w + w3, sy, scale, 0 < hp and tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.adminDuty[1], true, w3)
                else
                  drawSpecialText(sx, sy, scale, 0 < hp and tocolor(colors[white][1], colors[white][2], colors[white][3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.adminDuty[3], true, w)
                  drawSpecialText(sx + w, sy, scale, 0 < hp and tocolor(colors[col][1], colors[col][2], colors[col][3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.adminDuty[1], true, w2)
                end
                if data.voice then
                  local vx = sx
                  local isy = charsetSize * scale / 2
                  local isx2 = 0.9375 * isy
                  local col = baseColor
                  seelangStaticImageUsed[21] = true
                  if seelangStaticImageToc[21] then
                    processSeelangStaticImage[21]()
                  end
                  dxDrawImage(vx - isx2 * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[21], 0, 0, 0, col)
                end
              else
                local baseColor = tocolor(colors[white][1], colors[white][2], colors[white][3], 255 * a)
                if data.hpMinus then
                  local col1 = colors[0 < anamesState and "red" or "hudwhite"]
                  local col2 = colors[0 < anamesState and "hudwhite" or "red"]
                  local p = 1 - (now - data.hpMinus) / 500
                  if p < 0 then
                    namesData[el].hpMinus = false
                    p = 0
                  end
                  local r, g, b = interpolateBetween(col1[1], col1[2], col1[3], col2[1], col2[2], col2[3], p, "Linear")
                  baseColor = tocolor(r, g, b, 255 * a)
                elseif data.bloodDamage then
                  local col1 = colors[0 < anamesState and "red" or "hudwhite"]
                  local col2 = colors[0 < anamesState and "hudwhite" or "red"]
                  local p = now % 1000 / 1000
                  p = p * 2
                  if 1 < p then
                    p = 2 - p
                  end
                  local r, g, b = interpolateBetween(col1[1], col1[2], col1[3], col2[1], col2[2], col2[3], p, "Linear")
                  baseColor = tocolor(r, g, b, 255 * a)
                end
                if 0 < anamesState then
                  local isy = charsetSize * scale / 2
                  local isx = 1.4375 * isy
                  local isx2 = 0.9375 * isy
                  local armor = data.usingArmor and 0 < getPedArmor(el)
                  local w = getSpecialTextWidth(scale, data.visibleName .. " ")
                  local w2 = getSpecialTextWidth(scale, "(" .. data.playerID .. ")" .. ((data.visibleWeapon or armor or data.deathTag) and " " or ""))
                  local col = 0 < hp and tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a) or tocolor(80, 80, 80, 225 * a)
                  if data.playerGlueState then
                    local w3 = getSpecialTextWidth(scale, " [G]")
                    local sx = sx - (w + w2 + w3) / 2
                    local wp = data.visibleWeapon
                    if wp or data.deathTag then
                      sx = sx - isx / 2
                    end
                    if armor then
                      sx = sx - isx2 / 2
                      if wp then
                        sx = sx - isx * 0.1 / 2
                      end
                    end
                    drawSpecialText(sx, sy, scale, 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a), data.visibleName, true)
                    drawSpecialText(sx + w, sy, scale, col, "(" .. data.playerID .. ")", true)
                    if data.deathTag then
                      seelangStaticImageUsed[22] = true
                      if seelangStaticImageToc[22] then
                        processSeelangStaticImage[22]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[22], 0, 0, 0, col)
                      drawSpecialText(sx + w + w2 + isx, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true)
                    elseif wp and armor then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + w2 + isx * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      drawSpecialText(sx + w + w2 + isx * 1.1 + isx2, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true)
                    elseif armor then
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      drawSpecialText(sx + w + w2 + isx2, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true)
                    elseif wp then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      drawSpecialText(sx + w + w2 + isx, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true)
                    else
                      drawSpecialText(sx + w + w2, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true)
                    end
                    if data.voice then
                      local vx = sx
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local col = baseColor
                      seelangStaticImageUsed[21] = true
                      if seelangStaticImageToc[21] then
                        processSeelangStaticImage[21]()
                      end
                      dxDrawImage(vx - isx2 * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[21], 0, 0, 0, col)
                    end
                  else
                    local sx = sx - (w + w2) / 2
                    if data.visibleWeapon or data.deathTag then
                      sx = sx - isx / 2
                    end
                    local armor = data.usingArmor and 0 < getPedArmor(el)
                    if armor then
                      sx = sx - isx2 / 2
                    end
                    drawSpecialText(sx, sy, scale, 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a), data.visibleName, true)
                    drawSpecialText(sx + w, sy, scale, col, "(" .. data.playerID .. ")", true)
                    if data.deathTag then
                      seelangStaticImageUsed[22] = true
                      if seelangStaticImageToc[22] then
                        processSeelangStaticImage[22]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[22], 0, 0, 0, col)
                    elseif data.visibleWeapon and armor then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + w2 + isx * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                    elseif armor then
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                    elseif data.visibleWeapon then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w + w2, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                    end
                    if data.voice then
                      local vx = sx
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local col = baseColor
                      seelangStaticImageUsed[21] = true
                      if seelangStaticImageToc[21] then
                        processSeelangStaticImage[21]()
                      end
                      dxDrawImage(vx - isx2 * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[21], 0, 0, 0, col)
                    end
                  end
                else
                  local wave = isElementInWater(el)
                  local wp = false
                  local armor = false
                  local belt = data.seatBelt
                  if not isPedInVehicle(el) then
                    wp = data.visibleWeapon
                    armor = data.usingArmor and 0 < getPedArmor(el)
                  end
                  if data.playerGlueState then
                    local text = data.visibleName .. " (" .. data.playerID .. ")"
                    if wp or armor or data.deathTag then
                      text = text .. " "
                    end
                    local w = getSpecialTextWidth(scale, text)
                    local w2 = getSpecialTextWidth(scale, " [G]")
                    local sx = sx - (w + w2) / 2
                    local isy = charsetSize * scale / 2
                    local isx = 1.4375 * isy
                    if wp or data.deathTag then
                      sx = sx - isx / 2
                    end
                    if armor then
                      sx = sx - isx / 2
                      if wp then
                        sx = sx - isx * 0.1 / 2
                      end
                    end
                    local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                    drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                    if data.deathTag then
                      seelangStaticImageUsed[22] = true
                      if seelangStaticImageToc[22] then
                        processSeelangStaticImage[22]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[22], 0, 0, 0, col)
                      drawSpecialText(sx + w + isx, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true, false, false, false, wave and utf8.len(text))
                    elseif wp and armor then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + isx * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      drawSpecialText(sx + w + isx * 1.1 + isx2, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true, false, false, false, wave and utf8.len(text))
                    elseif armor then
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      drawSpecialText(sx + w + isx2, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true, false, false, false, wave and utf8.len(text))
                    elseif wp then
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      drawSpecialText(sx + w + isx, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true, false, false, false, wave and utf8.len(text))
                    else
                      drawSpecialText(sx + w, sy, scale, 0 < hp and tocolor(120, 120, 120, 255 * a) or tocolor(80, 80, 80, 225 * a), " [G]", true, false, false, false, wave and utf8.len(text))
                    end
                    if data.voice then
                      local vx = sx
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local col = baseColor
                      seelangStaticImageUsed[21] = true
                      if seelangStaticImageToc[21] then
                        processSeelangStaticImage[21]()
                      end
                      dxDrawImage(vx - isx2 * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[21], 0, 0, 0, col)
                    end
                  else
                    local vx = false
                    local text = data.visibleName .. " (" .. data.playerID .. ")"
                    if data.deathTag then
                      text = text .. " "
                      local w = getSpecialTextWidth(scale, text)
                      local isy = charsetSize * scale / 2
                      local isx = 1.4375 * isy
                      local sx = sx - (isx + w) / 2
                      local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                      drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                      seelangStaticImageUsed[22] = true
                      if seelangStaticImageToc[22] then
                        processSeelangStaticImage[22]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[22], 0, 0, 0, col)
                      vx = sx
                    elseif wp and armor then
                      text = text .. " "
                      local w = getSpecialTextWidth(scale, text)
                      local isy = charsetSize * scale / 2
                      local isx = 1.4375 * isy
                      local isx2 = 0.9375 * isy
                      local sx = sx - (isx * 1.1 + isx2 + w) / 2
                      local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                      drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w + isx * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      vx = sx
                    elseif belt then
                      text = text .. " "
                      local w = getSpecialTextWidth(scale, text)
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local sx = sx - (isx2 + w) / 2
                      local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                      drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                      seelangStaticImageUsed[25] = true
                      if seelangStaticImageToc[25] then
                        processSeelangStaticImage[25]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx2, isy, seelangStaticImage[25], 0, 0, 0, col)
                      vx = sx
                    elseif armor then
                      text = text .. " "
                      local w = getSpecialTextWidth(scale, text)
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local sx = sx - (isx2 + w) / 2
                      local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                      drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                      seelangStaticImageUsed[24] = true
                      if seelangStaticImageToc[24] then
                        processSeelangStaticImage[24]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx2, isy, seelangStaticImage[24], 0, 0, 0, col)
                      vx = sx
                    elseif wp then
                      text = text .. " "
                      local w = getSpecialTextWidth(scale, text)
                      local isy = charsetSize * scale / 2
                      local isx = 1.4375 * isy
                      local sx = sx - (isx + w) / 2
                      local col = 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a)
                      drawSpecialText(sx, sy, scale, col, text, true, false, false, false, wave and 0)
                      seelangStaticImageUsed[23] = true
                      if seelangStaticImageToc[23] then
                        processSeelangStaticImage[23]()
                      end
                      dxDrawImage(sx + w, sy - isy * 0.42, isx, isy, seelangStaticImage[23], 0, 0, 0, col)
                      vx = sx
                    else
                      drawSpecialText(sx, sy, scale, 0 < hp and baseColor or tocolor(80, 80, 80, 225 * a), text, false, false, false, false, wave and 0)
                    end
                    if data.voice then
                      vx = vx or sx - getSpecialTextWidth(scale, text) / 2
                      local isy = charsetSize * scale / 2
                      local isx2 = 0.9375 * isy
                      local col = baseColor
                      seelangStaticImageUsed[21] = true
                      if seelangStaticImageToc[21] then
                        processSeelangStaticImage[21]()
                      end
                      dxDrawImage(vx - isx2 * 1.1, sy - isy * 0.42, isx2, isy, seelangStaticImage[21], 0, 0, 0, col)
                    end
                  end
                end
                if data.badgeExData then
                  local is = 32 * scale * 0.9
                  local w = getSpecialTextWidth(scale, data.badgeExData)
                  sx = sx - (w + is + 4 * scale) / 2
                  local y = sy + charsetSize * 0.6 * scale
                  seelangStaticImageUsed[26] = true
                  if seelangStaticImageToc[26] then
                    processSeelangStaticImage[26]()
                  end
                  dxDrawImage(sx, y + 2 * scale - is / 2, is, is, seelangStaticImage[26], 0, 0, 0, 0 < hp and tocolor(colors.blue[1], colors.blue[2], colors.blue[3], 255 * a) or tocolor(80, 80, 80, 225 * a))
                  drawSpecialText(sx + 4 * scale + is, y, scale * 0.9, 0 < hp and tocolor(colors.blue[1], colors.blue[2], colors.blue[3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.badgeExData, true)
                elseif data.badgeData then
                  local is = 32 * scale * 0.9
                  local w = getSpecialTextWidth(scale, data.badgeData)
                  sx = sx - (w + is + 4 * scale) / 2
                  local y = sy + charsetSize * 0.6 * scale
                  seelangStaticImageUsed[27] = true
                  if seelangStaticImageToc[27] then
                    processSeelangStaticImage[27]()
                  end
                  dxDrawImage(sx, y + 2 * scale - is / 2, is, is, seelangStaticImage[27], 0, 0, 0, 0 < hp and tocolor(colors.yellow[1], colors.yellow[2], colors.yellow[3], 255 * a) or tocolor(80, 80, 80, 225 * a))
                  drawSpecialText(sx + 4 * scale + is, y, scale * 0.9, 0 < hp and tocolor(colors.yellow[1], colors.yellow[2], colors.yellow[3], 255 * a) or tocolor(80, 80, 80, 225 * a), data.badgeData, true)
                elseif data.facePaint and not getPedOccupiedVehicle(el) then
                  drawSpecialText(sx, sy + charsetSize * 0.6 * scale, scale * 0.9, 0 < hp and tocolor(colors.purple[1], colors.purple[2], colors.purple[3], 255 * a) or tocolor(80, 80, 80, 225 * a), "* festékes az arca *")
                end
              end
            elseif data.type == "ped" then
              local text = ""
              if data.bubbles and 0 < #data.bubbles then
                local y = charsetSize * scale * 0.75 * ((data.chat or data.console or data.hideChat or data.hideConsole) and 2 or 1)
                for j = #data.bubbles, 1, -1 do
                  local text = data.bubbles[j][2]
                  local msgType = data.bubbles[j][3]
                  if msgType == "me" or msgType == "trygreen" or msgType == "tryred" then
                    text = "* " .. text
                  elseif msgType == "melow" then
                    text = "[LOW] * " .. text
                  elseif msgType == "ame" then
                    text = "> " .. text
                  elseif msgType == "do" then
                    text = "* " .. text
                  elseif msgType == "dolow" then
                    text = "[LOW] * " .. text
                  elseif msgType == "megaphone" then
                    text = "<O " .. text
                  end
                  local d = now - data.bubbles[j][1]
                  local p = d / 25
                  local len = utf8.len(text)
                  local a2 = math.min(3, p) / 3
                  if p > math.max(100, len * 3) then
                    local p = p - math.max(100, len * 3)
                    p = p / 3
                    if 1 < p then
                      p = 1
                    end
                    a2 = 1 - p
                  end
                  if p > len then
                    p = len
                  end
                  local bubbleColor = tocolor(0, 0, 0, 150 * a * a2)
                  local tr, tg, tb = colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3]
                  if msgType == "me" then
                    tr, tg, tb = 194, 162, 218
                  elseif msgType == "melow" then
                    tr, tg, tb = 219, 197, 235
                  elseif msgType == "ame" then
                    tr, tg, tb = 149, 108, 180
                  elseif msgType == "do" then
                    tr, tg, tb = 255, 40, 80
                  elseif msgType == "dolow" then
                    tr, tg, tb = 255, 102, 130
                  elseif msgType == "trygreen" then
                    tr, tg, tb = colors.green[1], colors.green[2], colors.green[3]
                  elseif msgType == "tryred" then
                    tr, tg, tb = colors.red[1], colors.red[2], colors.red[3]
                  elseif msgType == "megaphone" then
                    tr, tg, tb = 255, 255, 0
                  end
                  local char = 1 + math.floor(p)
                  local text1 = utf8.sub(text, 1, char - 1)
                  local text2 = utf8.sub(text, char, char)
                  local s = scale * 0.8
                  local w = getSpecialTextWidth(s, text, "ubuntu")
                  local w2 = getSpecialTextWidth(s, text1, "ubuntu")
                  local w3 = getSpecialTextWidth(s, text2, "ubuntu")
                  local p2 = p % 1
                  local feather = math.ceil(12 * s)
                  local bx = math.floor(sx - w / 2)
                  local by = math.floor(sy - y - 17 * s)
                  local bw = math.ceil(w2 + w3 * p2)
                  local bh = math.ceil(34 * s)
                  seelangStaticImageUsed[18] = true
                  if seelangStaticImageToc[18] then
                    processSeelangStaticImage[18]()
                  end
                  dxDrawImage(bx, by, -feather, bh, seelangStaticImage[18], 0, 0, 0, bubbleColor)
                  seelangStaticImageUsed[18] = true
                  if seelangStaticImageToc[18] then
                    processSeelangStaticImage[18]()
                  end
                  dxDrawImage(bx + bw, by, feather, bh, seelangStaticImage[18], 0, 0, 0, bubbleColor)
                  seelangStaticImageUsed[19] = true
                  if seelangStaticImageToc[19] then
                    processSeelangStaticImage[19]()
                  end
                  dxDrawImage(bx, by, bw, -feather, seelangStaticImage[19], 0, 0, 0, bubbleColor)
                  seelangStaticImageUsed[19] = true
                  if seelangStaticImageToc[19] then
                    processSeelangStaticImage[19]()
                  end
                  dxDrawImage(bx, by + bh, bw, feather, seelangStaticImage[19], 0, 0, 0, bubbleColor)
                  seelangStaticImageUsed[20] = true
                  if seelangStaticImageToc[20] then
                    processSeelangStaticImage[20]()
                  end
                  dxDrawImage(bx, by, -feather, -feather, seelangStaticImage[20], 90, 0, 0, bubbleColor)
                  seelangStaticImageUsed[20] = true
                  if seelangStaticImageToc[20] then
                    processSeelangStaticImage[20]()
                  end
                  dxDrawImage(bx + bw, by, feather, -feather, seelangStaticImage[20], 270, 0, 0, bubbleColor)
                  seelangStaticImageUsed[20] = true
                  if seelangStaticImageToc[20] then
                    processSeelangStaticImage[20]()
                  end
                  dxDrawImage(bx, by + bh, -feather, feather, seelangStaticImage[20], 270, 0, 0, bubbleColor)
                  seelangStaticImageUsed[20] = true
                  if seelangStaticImageToc[20] then
                    processSeelangStaticImage[20]()
                  end
                  dxDrawImage(bx + bw, by + bh, feather, feather, seelangStaticImage[20], 90, 0, 0, bubbleColor)
                  dxDrawRectangle(bx, by, bw, bh, bubbleColor)
                  drawSpecialText(bx, by + 17 * s, s, tocolor(tr, tg, tb, 255 * a * a2), text1, true, false, "ubuntu")
                  drawSpecialText(bx + w2, by + 17 * s, s, tocolor(tr, tg, tb, 255 * a * a2 * p2), text2, true, false, "ubuntu")
                  if a2 <= 0 and 1 <= p then
                    table.remove(namesData[el].bubbles, j)
                  end
                  y = y + bh + feather * 2 + 4 * scale
                end
              end
              if data.deathPed then
                local p = now % 4900 / 700
                local s = scale * 0.4
                local p1 = math.min(0.5, p) / 0.5
                local p2 = getEasingValue(math.min(1, p), "OutBounce", 0.4, 0.5)
                seelangStaticImageUsed[1] = true
                if seelangStaticImageToc[1] then
                  processSeelangStaticImage[1]()
                end
                dxDrawImage(sx - 128 * s, sy - charsetSize * 0.8 * scale - 256 * s * (4 - p2 * 3), 256 * s, 256 * s, seelangStaticImage[1], 0, 0, 0, tocolor(80, 80, 80, 200 * a * p1))
                seelangStaticImageUsed[2] = true
                if seelangStaticImageToc[2] then
                  processSeelangStaticImage[2]()
                end
                dxDrawImage(sx - 128 * s, sy - charsetSize * 0.8 * scale - 256 * s, 256 * s, 256 * s, seelangStaticImage[2], 0, 0, 0, tocolor(80, 80, 80, 200 * a))
                local cw = 10 * s
                local ch = 70 * s
                local cw2 = ch * 0.6
                local p3 = math.max(0, math.min(1, (p - 1) / 0.35))
                local p4 = math.max(0, math.min(1, (p - 1.5) / 0.35))
                dxDrawRectangle(sx - cw / 2 + 1, sy - charsetSize * 0.8 * scale - 128 * s - ch / 2 + 1, cw, ch * p3, tocolor(0, 0, 0, 125 * a))
                dxDrawRectangle(sx - cw2 / 2 + 1, sy - charsetSize * 0.8 * scale - 128 * s - ch / 2 + ch * 0.3 - cw / 2 + 1, cw2 * p4, cw, tocolor(0, 0, 0, 125 * a))
                dxDrawRectangle(sx - cw / 2, sy - charsetSize * 0.8 * scale - 128 * s - ch / 2, cw, ch * p3, tocolor(80, 80, 80, 255 * a))
                dxDrawRectangle(sx - cw2 / 2, sy - charsetSize * 0.8 * scale - 128 * s - ch / 2 + ch * 0.3 - cw / 2, cw2 * p4, cw, tocolor(80, 80, 80, 255 * a))
                drawSpecialText(sx, sy - charsetSize * scale * 0.5, scale * 0.8, tocolor(80, 80, 80, 225 * a), "Halál oka: " .. data.deathPed[3])
                drawSpecialText(sx, sy, scale, tocolor(80, 80, 80, 225 * a), data.visibleName .. " (" .. data.deathPed[2] .. ")")
              else
                if data.petType then
                  text = "(PET - " .. data.petType .. ")"
                elseif data.pedNameType then
                  text = "(NPC - " .. data.pedNameType .. ")"
                else
                  text = "(NPC)"
                end
                local w = getSpecialTextWidth(scale, data.visibleName .. " ")
                local w2 = getSpecialTextWidth(scale, text)
                sx = sx - (w + w2) / 2
                drawSpecialText(sx, sy, scale, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3], 255 * a), data.visibleName, true, w)
                drawSpecialText(sx + w, sy, scale, tocolor(colors.orange[1], colors.orange[2], colors.orange[3], 255 * a), text, true, w2)
              end
            end
          end
        end
      end
    end
  end
end
local namesState = true
seelangCondHandl1(true)
function getNamesState()
  return namesState
end
function setNamesState(state)
  namesState = state
  if namesState then
    seelangCondHandl1(true)
  else
    seelangCondHandl1(false)
  end
end
addCommandHandler("tognames", function()
  namesState = not namesState
  if namesState then
    seelangCondHandl1(true)
  else
    seelangCondHandl1(false)
  end
end)
function generateCharsetFile(name, fontIn)
  local font = seexports.seal_gui:getFont(fontIn)
  local fontScale = 1
  local height = dxGetFontHeight(fontScale, font)
  outputChatBox(fontIn .. ":")
  outputChatBox("h:" .. height)
  local rt = dxCreateRenderTarget(charsetSize * #charset, charsetSize, true)
  local x = 0
  dxSetRenderTarget(rt)
  local w = dxGetTextWidth(" ", fontScale, font)
  local log = fileCreate("data_" .. name .. ".lua")
  fileWrite(log, "[\"letters\"] = {\n")
  fileWrite(log, "[\"" .. " " .. "\"] = " .. w .. ",\n")
  for i = 1, #charset do
    dxDrawText(charset[i], x + 1, 1, x + charsetSize + 1, charsetSize + 1, tocolor(0, 0, 0), fontScale, font, "center", "center")
    dxDrawText(charset[i], x, 0, x + charsetSize, charsetSize, tocolor(colors.hudwhite[1], colors.hudwhite[2], colors.hudwhite[3]), fontScale, font, "center", "center")
    local w = dxGetTextWidth(charset[i], fontScale, font)
    fileWrite(log, "[\"" .. charset[i] .. "\"] = " .. w .. ",\n")
    x = x + charsetSize
  end
  fileWrite(log, "},\n")
  dxSetRenderTarget()
  if isElement(rt) then
    local pixels = dxGetTexturePixels(rt)
    destroyElement(rt)
    if pixels then
      local convertedPixels = dxConvertPixels(pixels, "plain")
      if convertedPixels then
        local checksum = sha256(convertedPixels)
        if fileExists("charset_" .. name .. ".see") then
          fileDelete("charset_" .. name .. ".see")
        end
        local convertedFile = fileCreate("charset_" .. name .. ".see")
        if convertedFile then
          fileWrite(convertedFile, convertedPixels)
          fileClose(convertedFile)
        end
        fileWrite(log, "--charset checksum: " .. checksum .. "\n")
      end
      local convertedPixels = dxConvertPixels(pixels, "png")
      if convertedPixels then
        local checksum = sha256(convertedPixels)
        if fileExists("charset_" .. name .. ".png") then
          fileDelete("charset_" .. name .. ".png")
        end
        local convertedFile = fileCreate("charset_" .. name .. ".png")
        if convertedFile then
          fileWrite(convertedFile, convertedPixels)
          fileClose(convertedFile)
        end
        fileWrite(log, "--charset checksum: " .. checksum .. "\n")
      end
    end
  end
  fileClose(log)
end
local afkStartTimer = false
addEventHandler("onClientKey", getRootElement(), function(key, press)
  if press then
    if getElementData(localPlayer, "afk") then
      setElementData(localPlayer, "afk", false)
    end
    if isTimer(afkStartTimer) then
      killTimer(afkStartTimer)
    end
    afkStartTimer = nil
    collectgarbage("collect")
    afkStartTimer = setTimer(function()
      setElementData(localPlayer, "afk", true)
    end, 60 * 1000, 1)
  end
end)
addEventHandler("onClientMinimize", getRootElement(), function()
  setElementData(localPlayer, "afk", true)
end)
addCommandHandler("togmyname", function()
  showSelf = not showSelf
  if showSelf then
    local visibleName = getElementData(localPlayer, "visibleName")
    refreshElementNameData(localPlayer, "player", {visibleName = visibleName})
    for i = 1, #namesList do
      if namesList[i] == localPlayer then
        return
      end
    end
    table.insert(namesList, localPlayer)
  else
    for i = 1, #namesList do
      if namesList[i] == localPlayer then
        table.remove(namesList, i)
        break
      end
    end
  end
end)