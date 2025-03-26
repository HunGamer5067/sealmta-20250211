local seexports = {
  seal_gui = false,
  seal_vehiclepanel = false,
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
seelangStaticImageToc[28] = true
seelangStaticImageToc[29] = true
seelangStaticImageToc[30] = true
seelangStaticImageToc[31] = true
seelangStaticImageToc[32] = true
seelangStaticImageToc[33] = true
seelangStaticImageToc[34] = true
seelangStaticImageToc[35] = true
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
  if seelangStaticImageUsed[28] then
    seelangStaticImageUsed[28] = false
    seelangStaticImageDel[28] = false
  elseif seelangStaticImage[28] then
    if seelangStaticImageDel[28] then
      if now >= seelangStaticImageDel[28] then
        if isElement(seelangStaticImage[28]) then
          destroyElement(seelangStaticImage[28])
        end
        seelangStaticImage[28] = nil
        seelangStaticImageDel[28] = false
        seelangStaticImageToc[28] = true
        return
      end
    else
      seelangStaticImageDel[28] = now + 5000
    end
  else
    seelangStaticImageToc[28] = true
  end
  if seelangStaticImageUsed[29] then
    seelangStaticImageUsed[29] = false
    seelangStaticImageDel[29] = false
  elseif seelangStaticImage[29] then
    if seelangStaticImageDel[29] then
      if now >= seelangStaticImageDel[29] then
        if isElement(seelangStaticImage[29]) then
          destroyElement(seelangStaticImage[29])
        end
        seelangStaticImage[29] = nil
        seelangStaticImageDel[29] = false
        seelangStaticImageToc[29] = true
        return
      end
    else
      seelangStaticImageDel[29] = now + 5000
    end
  else
    seelangStaticImageToc[29] = true
  end
  if seelangStaticImageUsed[30] then
    seelangStaticImageUsed[30] = false
    seelangStaticImageDel[30] = false
  elseif seelangStaticImage[30] then
    if seelangStaticImageDel[30] then
      if now >= seelangStaticImageDel[30] then
        if isElement(seelangStaticImage[30]) then
          destroyElement(seelangStaticImage[30])
        end
        seelangStaticImage[30] = nil
        seelangStaticImageDel[30] = false
        seelangStaticImageToc[30] = true
        return
      end
    else
      seelangStaticImageDel[30] = now + 5000
    end
  else
    seelangStaticImageToc[30] = true
  end
  if seelangStaticImageUsed[31] then
    seelangStaticImageUsed[31] = false
    seelangStaticImageDel[31] = false
  elseif seelangStaticImage[31] then
    if seelangStaticImageDel[31] then
      if now >= seelangStaticImageDel[31] then
        if isElement(seelangStaticImage[31]) then
          destroyElement(seelangStaticImage[31])
        end
        seelangStaticImage[31] = nil
        seelangStaticImageDel[31] = false
        seelangStaticImageToc[31] = true
        return
      end
    else
      seelangStaticImageDel[31] = now + 5000
    end
  else
    seelangStaticImageToc[31] = true
  end
  if seelangStaticImageUsed[32] then
    seelangStaticImageUsed[32] = false
    seelangStaticImageDel[32] = false
  elseif seelangStaticImage[32] then
    if seelangStaticImageDel[32] then
      if now >= seelangStaticImageDel[32] then
        if isElement(seelangStaticImage[32]) then
          destroyElement(seelangStaticImage[32])
        end
        seelangStaticImage[32] = nil
        seelangStaticImageDel[32] = false
        seelangStaticImageToc[32] = true
        return
      end
    else
      seelangStaticImageDel[32] = now + 5000
    end
  else
    seelangStaticImageToc[32] = true
  end
  if seelangStaticImageUsed[33] then
    seelangStaticImageUsed[33] = false
    seelangStaticImageDel[33] = false
  elseif seelangStaticImage[33] then
    if seelangStaticImageDel[33] then
      if now >= seelangStaticImageDel[33] then
        if isElement(seelangStaticImage[33]) then
          destroyElement(seelangStaticImage[33])
        end
        seelangStaticImage[33] = nil
        seelangStaticImageDel[33] = false
        seelangStaticImageToc[33] = true
        return
      end
    else
      seelangStaticImageDel[33] = now + 5000
    end
  else
    seelangStaticImageToc[33] = true
  end
  if seelangStaticImageUsed[34] then
    seelangStaticImageUsed[34] = false
    seelangStaticImageDel[34] = false
  elseif seelangStaticImage[34] then
    if seelangStaticImageDel[34] then
      if now >= seelangStaticImageDel[34] then
        if isElement(seelangStaticImage[34]) then
          destroyElement(seelangStaticImage[34])
        end
        seelangStaticImage[34] = nil
        seelangStaticImageDel[34] = false
        seelangStaticImageToc[34] = true
        return
      end
    else
      seelangStaticImageDel[34] = now + 5000
    end
  else
    seelangStaticImageToc[34] = true
  end
  if seelangStaticImageUsed[35] then
    seelangStaticImageUsed[35] = false
    seelangStaticImageDel[35] = false
  elseif seelangStaticImage[35] then
    if seelangStaticImageDel[35] then
      if now >= seelangStaticImageDel[35] then
        if isElement(seelangStaticImage[35]) then
          destroyElement(seelangStaticImage[35])
        end
        seelangStaticImage[35] = nil
        seelangStaticImageDel[35] = false
        seelangStaticImageToc[35] = true
        return
      end
    else
      seelangStaticImageDel[35] = now + 5000
    end
  else
    seelangStaticImageToc[35] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] and seelangStaticImageToc[3] and seelangStaticImageToc[4] and seelangStaticImageToc[5] and seelangStaticImageToc[6] and seelangStaticImageToc[7] and seelangStaticImageToc[8] and seelangStaticImageToc[9] and seelangStaticImageToc[10] and seelangStaticImageToc[11] and seelangStaticImageToc[12] and seelangStaticImageToc[13] and seelangStaticImageToc[14] and seelangStaticImageToc[15] and seelangStaticImageToc[16] and seelangStaticImageToc[17] and seelangStaticImageToc[18] and seelangStaticImageToc[19] and seelangStaticImageToc[20] and seelangStaticImageToc[21] and seelangStaticImageToc[22] and seelangStaticImageToc[23] and seelangStaticImageToc[24] and seelangStaticImageToc[25] and seelangStaticImageToc[26] and seelangStaticImageToc[27] and seelangStaticImageToc[28] and seelangStaticImageToc[29] and seelangStaticImageToc[30] and seelangStaticImageToc[31] and seelangStaticImageToc[32] and seelangStaticImageToc[33] and seelangStaticImageToc[34] and seelangStaticImageToc[35] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processSeelangStaticImage[3] = function()
  if not isElement(seelangStaticImage[3]) then
    seelangStaticImageToc[3] = false
    seelangStaticImage[3] = dxCreateTexture("files/grad2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[4] = function()
  if not isElement(seelangStaticImage[4]) then
    seelangStaticImageToc[4] = false
    seelangStaticImage[4] = dxCreateTexture("files/grad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[5] = function()
  if not isElement(seelangStaticImage[5]) then
    seelangStaticImageToc[5] = false
    seelangStaticImage[5] = dxCreateTexture("files/bgshine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[6] = function()
  if not isElement(seelangStaticImage[6]) then
    seelangStaticImageToc[6] = false
    seelangStaticImage[6] = dxCreateTexture("files/timer.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[7] = function()
  if not isElement(seelangStaticImage[7]) then
    seelangStaticImageToc[7] = false
    seelangStaticImage[7] = dxCreateTexture("files/speedo.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[8] = function()
  if not isElement(seelangStaticImage[8]) then
    seelangStaticImageToc[8] = false
    seelangStaticImage[8] = dxCreateTexture("files/battery.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[9] = function()
  if not isElement(seelangStaticImage[9]) then
    seelangStaticImageToc[9] = false
    seelangStaticImage[9] = dxCreateTexture("files/engine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[10] = function()
  if not isElement(seelangStaticImage[10]) then
    seelangStaticImageToc[10] = false
    seelangStaticImage[10] = dxCreateTexture("files/fuel.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[11] = function()
  if not isElement(seelangStaticImage[11]) then
    seelangStaticImageToc[11] = false
    seelangStaticImage[11] = dxCreateTexture("files/car1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[12] = function()
  if not isElement(seelangStaticImage[12]) then
    seelangStaticImageToc[12] = false
    seelangStaticImage[12] = dxCreateTexture("files/car2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[13] = function()
  if not isElement(seelangStaticImage[13]) then
    seelangStaticImageToc[13] = false
    seelangStaticImage[13] = dxCreateTexture("files/ar1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[14] = function()
  if not isElement(seelangStaticImage[14]) then
    seelangStaticImageToc[14] = false
    seelangStaticImage[14] = dxCreateTexture("files/ar2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[21] = function()
  if not isElement(seelangStaticImage[21]) then
    seelangStaticImageToc[21] = false
    seelangStaticImage[21] = dxCreateTexture("files/4wdr.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[22] = function()
  if not isElement(seelangStaticImage[22]) then
    seelangStaticImageToc[22] = false
    seelangStaticImage[22] = dxCreateTexture("files/4wdf.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[23] = function()
  if not isElement(seelangStaticImage[23]) then
    seelangStaticImageToc[23] = false
    seelangStaticImage[23] = dxCreateTexture("files/4wd1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[24] = function()
  if not isElement(seelangStaticImage[24]) then
    seelangStaticImageToc[24] = false
    seelangStaticImage[24] = dxCreateTexture("files/dot.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[25] = function()
  if not isElement(seelangStaticImage[25]) then
    seelangStaticImageToc[25] = false
    seelangStaticImage[25] = dxCreateTexture("files/background.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[26] = function()
  if not isElement(seelangStaticImage[26]) then
    seelangStaticImageToc[26] = false
    seelangStaticImage[26] = dxCreateTexture("files/off.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[27] = function()
  if not isElement(seelangStaticImage[27]) then
    seelangStaticImageToc[27] = false
    seelangStaticImage[27] = dxCreateTexture("files/on.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[28] = function()
  if not isElement(seelangStaticImage[28]) then
    seelangStaticImageToc[28] = false
    seelangStaticImage[28] = dxCreateTexture("files/next.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[29] = function()
  if not isElement(seelangStaticImage[29]) then
    seelangStaticImageToc[29] = false
    seelangStaticImage[29] = dxCreateTexture("files/stop.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[30] = function()
  if not isElement(seelangStaticImage[30]) then
    seelangStaticImageToc[30] = false
    seelangStaticImage[30] = dxCreateTexture("files/play.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[31] = function()
  if not isElement(seelangStaticImage[31]) then
    seelangStaticImageToc[31] = false
    seelangStaticImage[31] = dxCreateTexture("files/iconshine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[32] = function()
  if not isElement(seelangStaticImage[32]) then
    seelangStaticImageToc[32] = false
    seelangStaticImage[32] = dxCreateTexture("files/shine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[33] = function()
  if not isElement(seelangStaticImage[33]) then
    seelangStaticImageToc[33] = false
    seelangStaticImage[33] = dxCreateTexture("files/radioglass.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[34] = function()
  if not isElement(seelangStaticImage[34]) then
    seelangStaticImageToc[34] = false
    seelangStaticImage[34] = dxCreateTexture("files/scratch.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processSeelangStaticImage[35] = function()
  if not isElement(seelangStaticImage[35]) then
    seelangStaticImageToc[35] = false
    seelangStaticImage[35] = dxCreateTexture("files/crash.dds", "argb", true)
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
local function dynamicImage(img, form, mip)
  if not seelangDynImgHand then
    seelangDynImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangDynImgPre, true, "high+999999999")
  end
  if not seelangDynImage[img] then
    seelangDynImage[img] = dxCreateTexture(img, form, mip)
  end
  seelangDynImageForm[img] = form
  seelangDynImageUsed[img] = true
  return seelangDynImage[img]
end
local saveIcon = false
local resetIcon = false
local caretIcon = false
local songIcon = false
local radioIcon = false
local listIcon = false
local hw = false
local faTicks = false
local function seelangGuiRefreshColors()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    saveIcon = seexports.seal_gui:getFaIconFilename("save", 24)
    resetIcon = seexports.seal_gui:getFaIconFilename("undo", 24)
    caretIcon = seexports.seal_gui:getFaIconFilename("angle-up", 24)
    songIcon = seexports.seal_gui:getFaIconFilename("album-collection", 48, "regular")
    radioIcon = seexports.seal_gui:getFaIconFilename("radio", 48)
    listIcon = seexports.seal_gui:getFaIconFilename("list", 32)
    hw = seexports.seal_gui:getColorCode("hudwhite")
    faTicks = seexports.seal_gui:getFaTicks()
    refreshFonts()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = seexports.seal_gui:getFaTicks()
end)
local seelangCondHandlState0 = false
local function seelangCondHandl0(cond, prio)
  cond = cond and true or false
  if cond ~= seelangCondHandlState0 then
    seelangCondHandlState0 = cond
    if cond then
      addEventHandler("onClientPreRender", getRootElement(), checkInsideVehicle, true, prio)
    else
      removeEventHandler("onClientPreRender", getRootElement(), checkInsideVehicle)
    end
  end
end
local streamerSounds = {}
function seelangSoundDestroy()
  streamerSounds[source] = nil
end
function setStreamerModeVolume(sound, vol)
  if not sound then
    return
  end
  if not streamerSounds[sound] then
    addEventHandler("onClientElementDestroy", sound, seelangSoundDestroy)
  end
  streamerSounds[sound] = vol
  setSoundVolume(sound, vol)
end
local currentVehicle = false
local vehicleSounds = {}
local radioFavorites = {}
local radioVolume = 1
local scratchLevel = 0
local radioCrashed = false
local radioState = false
local radioOpened = false
local defSoundDistane = 30
local radioWallpaper = 0
local radioBrightness = 0
local disableSystemAudio = false
local fonts = {}
local fontScales = {}
local fontHeights = {}
local currentRadio = 1
local cachedDatas = {}
local monitoredDatas = {}
function deleteMonitoring()
  cachedDatas[source] = nil
  monitoredDatas[source] = nil
end
addEventHandler("onClientElementDestroy", getRootElement(), deleteMonitoring)
addEventHandler("onClientElementStreamOut", getRootElement(), deleteMonitoring)
addEventHandler("onClientElementDataChange", getRootElement(), function(data, old, new)
  if getElementType(source) == "vehicle" then
    if monitoredDatas[source] and monitoredDatas[source][data] then
      cachedDatas[source][data] = new
    end
  end
end)
function getCachedData(veh, data)
  if not monitoredDatas[veh] then
    monitoredDatas[veh] = {}
    cachedDatas[veh] = {}
  end
  if not monitoredDatas[veh][data] then
    monitoredDatas[veh][data] = true
    cachedDatas[veh][data] = getElementData(veh, data)
  end
  return cachedDatas[veh][data]
end
function checkVehicleRadio2D()
  radioState = getCachedData(currentVehicle, "vehradio.state")
  if radioState then
    local station = getCachedData(currentVehicle, "vehradio.station")
    if station then
      currentRadio = station
      if isElement(vehicleSounds[currentVehicle]) then
        destroyElement(vehicleSounds[currentVehicle])
      end
      radioFavorites = getCachedData(currentVehicle, "vehradio.favorites") or {}
      radioVolume = getCachedData(currentVehicle, "vehradio.volume") or 1
      vehicleSounds[currentVehicle] = playSound(stationList[station][1])
      setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
      if radioCrashed then
        setSoundEffectEnabled(vehicleSounds[currentVehicle], "distortion", true)
      end
    end
  end
end
addEventHandler("onClientPlayerWasted", localPlayer, function()
  if vehicleSounds[currentVehicle] then
    if isElement(vehicleSounds[currentVehicle]) then
      destroyElement(vehicleSounds[currentVehicle])
    end
    vehicleSounds[currentVehicle] = nil
  end
end)
function checkVehicleRadioWindow(veh)
  if vehicleSounds[veh] then
    local vol = getCachedData(veh, "vehradio.volume") or 1
    local dist = defSoundDistane
    setSoundMinDistance(vehicleSounds[veh], 1.25)
    if getCachedData(veh, "vehicle.windowState") then
      setSoundEffectEnabled(vehicleSounds[veh], "i3dl2reverb", false)
      setSoundEffectEnabled(vehicleSounds[veh], "compressor", false)
      if getCachedData(veh, "vehradio.broken") then
        setSoundEffectEnabled(vehicleSounds[veh], "distortion", true)
      else
        setSoundEffectEnabled(vehicleSounds[veh], "distortion", false)
      end
    else
      vol = vol * 0.25
      dist = dist * 0.5
      setSoundEffectEnabled(vehicleSounds[veh], "i3dl2reverb", true)
      setSoundEffectEnabled(vehicleSounds[veh], "compressor", true)
      setSoundEffectEnabled(vehicleSounds[veh], "distortion", false)
    end
    setStreamerModeVolume(vehicleSounds[veh], vol)
    setSoundMaxDistance(vehicleSounds[veh], dist)
  end
end
function checkVehicleRadio3D(veh, exit)
  if isElementStreamedIn(veh) and (veh ~= currentVehicle or exit) then
    local state = getCachedData(veh, "vehradio.state")
    if state then
      local station = getCachedData(veh, "vehradio.station")
      if station then
        if isElement(vehicleSounds[veh]) then
          destroyElement(vehicleSounds[veh])
        end
        local x, y, z = getElementPosition(veh)
        vehicleSounds[veh] = playSound3D(stationList[station][1], x, y, z)
        setElementDimension(vehicleSounds[veh], getElementDimension(veh))
        setElementInterior(vehicleSounds[veh], getElementInterior(veh))
        checkVehicleRadioWindow(veh)
        attachElements(vehicleSounds[veh], veh)
      else
        if isElement(vehicleSounds[veh]) then
          destroyElement(vehicleSounds[veh])
        end
        vehicleSounds[veh] = nil
      end
    else
      if isElement(vehicleSounds[veh]) then
        destroyElement(vehicleSounds[veh])
      end
      vehicleSounds[veh] = nil
    end
  end
end
local favoriteSetTimer = false
local volumeTimer = false
function refreshFonts()
  fonts["18/Ubuntu-B.ttf"] = seexports.seal_gui:getFont("18/Ubuntu-B.ttf")
  fontScales["18/Ubuntu-B.ttf"] = seexports.seal_gui:getFontScale("18/Ubuntu-B.ttf")
  fontHeights["18/Ubuntu-B.ttf"] = seexports.seal_gui:getFontHeight("18/Ubuntu-B.ttf")
  fonts["16/Ubuntu-R.ttf"] = seexports.seal_gui:getFont("16/Ubuntu-R.ttf")
  fontScales["16/Ubuntu-R.ttf"] = seexports.seal_gui:getFontScale("16/Ubuntu-R.ttf")
  fontHeights["16/Ubuntu-R.ttf"] = seexports.seal_gui:getFontHeight("16/Ubuntu-R.ttf")
end
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  local veh = getPedOccupiedVehicle(localPlayer)
  if veh then
    vehicleEnter(veh)
  end
end)
local vehs = getElementsByType("vehicle", getRootElement(), true)
for k = 1, #vehs do
  checkVehicleRadio3D(vehs[k])
end
function vehicleEnter(veh)
  if currentVehicle then
    onPlayerVehicleExit()
  end
  local vt = getVehicleType(veh)
  if vt == "Automobile" or vt == "Quad" or vt == "Bike" then
    currentVehicle = veh
    if isElement(currentVehicle) then
      currentRadio = getCachedData(currentVehicle, "vehradio.station") or 1
    end
    radioCrashed = getCachedData(currentVehicle, "vehradio.broken")
    currentHover = false
    triggerServerEvent("requestECUData", currentVehicle)
    triggerServerEvent("requestAirrideData", currentVehicle)
    triggerServerEvent("requestDriveTypeData", currentVehicle)
    checkVehicleRadio2D()
    seelangCondHandl0(true)
  else
    currentVehicle = false
  end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(veh, seat)
  vehicleEnter(veh)
end)
addEventHandler("onClientElementStreamOut", getRootElement(), function()
  if getElementType(source) == "vehicle" then
    if source ~= currentVehicle then
      if isElement(vehicleSounds[source]) then
        destroyElement(vehicleSounds[source])
      end
      vehicleSounds[source] = nil
    end
  end
end)
addEventHandler("onClientElementStreamIn", getRootElement(), function()
  if getElementType(source) == "vehicle" then
    checkVehicleRadio3D(source)
  end
end)
addEventHandler("onClientElementDestroy", getRootElement(), function()
  if getElementType(source) == "vehicle" then
    if isElement(vehicleSounds[source]) then
      destroyElement(vehicleSounds[source])
    end
    vehicleSounds[source] = nil
    if source == currentVehicle then
      onPlayerVehicleExit(true)
    end
  end
end)
function onPlayerVehicleExit(exit)
  seelangCondHandl0(false)
  if currentVehicle then
    if isElement(vehicleSounds[currentVehicle]) then
      destroyElement(vehicleSounds[currentVehicle])
    end
    vehicleSounds[currentVehicle] = nil
    if not exit then
      checkVehicleRadio3D(currentVehicle, true)
    end
  end
  if isTimer(favoriteSetTimer) then
    killTimer(favoriteSetTimer)
  end
  favoriteSetTimer = false
  if isTimer(volumeTimer) then
    killTimer(volumeTimer)
  end
  volumeTimer = false
  currentVehicle = false
  if radioOpened then
    toggleRadio()
  end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, onPlayerVehicleExit)
screenX, screenY = guiGetScreenSize()
local sizeX = 652
local sizeY = 332
local radioX, radioY = math.floor(screenX / 2 - sizeX / 2), math.floor(screenY / 5)
local lastCurrentMenu = "off"
local currentMenu = "off"
local radioListScroll = 0
local radioOn = 0
local menuChange = 0
local ecuBalanceValue = false
local savedEcuBalanceValue = false
local ecuValues = false
local savedEcuValues = false
function setMenu(menu)
  if currentMenu == "on" and menu == "home" then
    radioOn = getTickCount()
  end
  lastCurrentMenu = currentMenu
  currentMenu = menu
  menuChange = getTickCount()
  if menu == "on" then
    radioOn = getTickCount()
  end
end
local radioChangeDir = false
local currentRadioChange = false
local lastStationName = false
local lastStationWidth = 0
local stationName = ""
local stationWidth = 0
local currentSongChange = false
local lastCurrentSong = false
local lastCurrentWidth = 0
local currentSong = ""
local currentWidth = 0
local currentHover = false
local volumeSet = false
local menus = {
  "radio",
  "settings",
  "computer",
  "airride",
  "ecu",
  "awd"
}
local menuTitles = {
  "Rádió",
  "Beállítások",
  "Computer",
  "AirRide",
  "SealECU",
  "Meghajtás"
}
function drawBcg(x, y, progress)
  if radioWallpaper == 0 then
    dxDrawRectangle(x, y, 538, 293, tocolor(17, 20, 32, 255 * progress))
  else
    dxDrawImage(x, y, 538, 293, dynamicImage("files/wp/" .. radioWallpaper .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
  end
  if radioBrightness < 6 then
    local a = (6 - radioBrightness) / 6 * 110
    dxDrawRectangle(x, y, 538, 293, tocolor(10, 10, 10, a * progress))
  end
end
local oilLevel = 1000
local fuelLiters = 80
local fuelMaxLiters = 80
local fuelConsumption = 10
function rotate(px, py, pz, pitch, roll, yaw)
  local cosa = math.cos(math.rad(yaw))
  local sina = math.sin(math.rad(yaw))
  local cosb = math.cos(math.rad(pitch))
  local sinb = math.sin(math.rad(pitch))
  local cosc = math.cos(math.rad(roll))
  local sinc = math.sin(math.rad(roll))
  local Axx = cosa * cosb
  local Axy = cosa * sinb * sinc - sina * cosc
  local Axz = cosa * sinb * cosc + sina * sinc
  local Ayx = sina * cosb
  local Ayy = sina * sinb * sinc + cosa * cosc
  local Ayz = sina * sinb * cosc - cosa * sinc
  local Azx = -sinb
  local Azy = cosb * sinc
  local Azz = cosb * cosc
  return Axx * px + Axy * py + Axz * pz, Ayx * px + Ayy * py + Ayz * pz, Azx * px + Azy * py + Azz * pz
end
local focal = 1024
function projection(x, y, z, size)
  size = size * 2
  local tana = size / 2 / focal
  local oX = x / z * (size / 2 / tana)
  local oY = y / z * (size / 2 / tana)
  return oX, oY
end
local blankShader = [[
texture texture0;

sampler implicitInputTexture = sampler_state 
{ 
	Texture = <texture0>; 
}; 
  
float4 Blank( float2 uv : TEXCOORD0 ) : COLOR0 
{ 
	 
	float4 sampledTexture = tex2D( implicitInputTexture, uv ); 
	return sampledTexture; 
} 
  
technique Technique1 
{ 
	pass Pass1 
	{ 
		PixelShader = compile ps_2_0 Blank(); 
	} 
} 
]]
local baseRt = false
local playerRt = false
local baseShader = false
local finalRt = false
local radioMove = false
function drawComputer(rt, month, monthday, hour, minute, x, y, progress)
  drawBcg(x, y, progress)
  dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, 0, y + 4, x + 538 - 8, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
  x = x + 8
  dxDrawText("Computer", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
  y = y + fontHeights["15/BebasNeueBold.otf"] + 2
  seelangStaticImageUsed[4] = true
  if seelangStaticImageToc[4] then
    processSeelangStaticImage[4]()
  end
  dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
  y = y + 8
  x = x - 4
  local w = 176.66666666666666
  local h = math.floor((293 - (y - (radioY + 19)) - 4) / 3)
  local id = 0
  for j = 1, 3 do
    for i = 1, 3 do
      local px, py = x + w * (i - 1) + 4, y + h * (j - 1) + 4
      dxDrawRectangle(px, py, w - 8, h - 8, tocolor(34, 38, 42, 200 * progress))
      id = id + 1
      if id == 1 then
        local r, g, b = 255, 255, 255
        local val = 1000
        local val = val - math.floor(math.floor(oilLevel) / 1000)
        if val <= 0 then
          r, g, b = 243, 90, 90
        elseif val <= 250 then
          r, g, b = 243, 214, 90
        end
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(px, py, w - 8, h - 8, seelangStaticImage[5], 0, 0, 0, tocolor(r, g, b, 75 * progress))
        dxDrawText("Következő olajcsere", px + 4, py + 2, 0, 0, tocolor(r, g, b, 200 * progress), fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], "left", "top")
        dxDrawText(" km", 0, 0, px + w - 8 - 4, py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "right", "bottom")
        dxDrawText(val, 0, 0, px + w - 8 - 4 - dxGetTextWidth(" km", fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"]), py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["22/BebasNeueBold.otf"], fonts["22/BebasNeueBold.otf"], "right", "bottom")
        seelangStaticImageUsed[9] = true
        if seelangStaticImageToc[9] then
          processSeelangStaticImage[9]()
        end
        dxDrawImage(px, py + h - 8 - 40, 40, 40, seelangStaticImage[9], 0, 0, 0, tocolor(r, g, b, 255 * progress))
      elseif id == 2 then
        local r, g, b = 255, 255, 255
        local val = fuelLiters
        local max = fuelMaxLiters
        if val / max <= 0.1 then
          r, g, b = 243, 90, 90
        elseif val / max <= 0.15 then
          r, g, b = 243, 214, 90
        end
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(px, py, w - 8, h - 8, seelangStaticImage[5], 0, 0, 0, tocolor(r, g, b, 75 * progress))
        dxDrawText("Üzemanyag", px + 4, py + 2, 0, 0, tocolor(r, g, b, 200 * progress), fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], "left", "top")
        dxDrawText("/" .. math.floor(max + 0.5) .. " L", 0, 0, px + w - 8 - 4, py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "right", "bottom")
        dxDrawText(math.floor(val + 0.5), 0, 0, px + w - 8 - 4 - dxGetTextWidth("/" .. max .. " L", fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"]), py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["22/BebasNeueBold.otf"], fonts["22/BebasNeueBold.otf"], "right", "bottom")
        seelangStaticImageUsed[10] = true
        if seelangStaticImageToc[10] then
          processSeelangStaticImage[10]()
        end
        dxDrawImage(px, py + h - 8 - 40, 40, 40, seelangStaticImage[10], 0, 0, 0, tocolor(r, g, b, 255 * progress))
      elseif id == 3 then
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(px, py, w - 8, h - 8, seelangStaticImage[5], 0, 0, 0, tocolor(255, 255, 255, 75 * progress))
        dxDrawText("Üzemanyag fogyasztás", px + 4, py + 2, 0, 0, tocolor(255, 255, 255, 200 * progress), fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], "left", "top")
        dxDrawText(" L/100km", 0, 0, px + w - 8 - 4, py + h - 8 - 2, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "right", "bottom")
        dxDrawText(fuelConsumption, 0, 0, px + w - 8 - 4 - dxGetTextWidth(" L/100km", fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"]), py + h - 8 - 2, tocolor(255, 255, 255, 255 * progress), fontScales["22/BebasNeueBold.otf"], fonts["22/BebasNeueBold.otf"], "right", "bottom")
        seelangStaticImageUsed[10] = true
        if seelangStaticImageToc[10] then
          processSeelangStaticImage[10]()
        end
        dxDrawImage(px, py + h - 8 - 40, 40, 40, seelangStaticImage[10], 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
      elseif id == 4 then
        local r, g, b = 255, 255, 255
        local val = math.floor(fuelLiters / fuelConsumption * 100 + 0.5)
        if val <= 25 then
          r, g, b = 243, 90, 90
        elseif val <= 100 then
          r, g, b = 243, 214, 90
        end
        seelangStaticImageUsed[5] = true
        if seelangStaticImageToc[5] then
          processSeelangStaticImage[5]()
        end
        dxDrawImage(px, py, w - 8, h - 8, seelangStaticImage[5], 0, 0, 0, tocolor(r, g, b, 75 * progress))
        dxDrawText("Üzemanyag hatótáv", px + 4, py + 2, 0, 0, tocolor(r, g, b, 200 * progress), fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], "left", "top")
        dxDrawText(" km", 0, 0, px + w - 8 - 4, py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "right", "bottom")
        dxDrawText(val, 0, 0, px + w - 8 - 4 - dxGetTextWidth(" km", fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"]), py + h - 8 - 2, tocolor(r, g, b, 255 * progress), fontScales["22/BebasNeueBold.otf"], fonts["22/BebasNeueBold.otf"], "right", "bottom")
        seelangStaticImageUsed[10] = true
        if seelangStaticImageToc[10] then
          processSeelangStaticImage[10]()
        end
        dxDrawImage(px, py + h - 8 - 40, 40, 40, seelangStaticImage[10], 0, 0, 0, tocolor(r, g, b, 255 * progress))
      end
    end
  end
end
addEvent("gotVehicleEcuData", true)
addEventHandler("gotVehicleEcuData", getRootElement(), function(bal, opt)
  if source == currentVehicle then
    ecuBalanceValue = bal
    savedEcuBalanceValue = bal
    ecuValues = {}
    savedEcuValues = {}
    if opt then
      for i = 1, 6 do
        ecuValues[i] = math.max(math.min(1, tonumber(opt[i]) or 0), -1)
        savedEcuValues[i] = math.max(math.min(1, tonumber(opt[i]) or 0), -1)
      end
    end
  end
end)
local ecuSettingState = false
function getVehicleSpeed(currentElement)
  if isElement(currentElement) then
    local x, y, z = getElementVelocity(currentElement)
    return math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) * 187.5
  end
end
local airrideLevel = 0
local airrideSettingLevel = false
local airrideBias = 0
local airrideSettingBias = false
local airrideSoftness = 0
local airrideSettingSoftness
local currentDriveType = false
addEvent("gotVehicleDriveTypeData", true)
addEventHandler("gotVehicleDriveTypeData", getRootElement(), function(dt)
  if source == currentVehicle then
    currentDriveType = dt
  end
end)
addEvent("gotVehicleAirRide", true)
addEventHandler("gotVehicleAirRide", getRootElement(), function(lvl, bias, softness)
  if source == currentVehicle then
    airrideLevel = lvl
    airrideSettingLevel = false
    airrideBias = bias
    airrideSettingBias = false
    airrideSoftness = softness
    airrideSettingSoftness = false
  end
end)
addEvent("airrideSound", true)
addEventHandler("airrideSound", getRootElement(), function()
  local s = playSound3D("files/airride.wav", 0, 0, 0, false)
  attachElements(s, source)
  setSoundVolume(s, 0.75)
  setElementDimension(s, getElementDimension(source))
  setElementInterior(s, getElementInterior(source))
end)
function drawAirRide(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  local canClick = getVehicleController(currentVehicle) == localPlayer and getVehicleSpeed(currentVehicle) <= 10
  local pulse = getTickCount() % 1000 / 1000
  pulse = pulse * 2
  if 1 < pulse then
    pulse = 2 - pulse
  end
  pulse = getEasingValue(pulse, "InOutQuad")
  drawBcg(x, y, progress)
  dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, 0, y + 4, x + 538 - 8, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
  x = x + 8
  dxDrawText("AirRide", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
  y = y + fontHeights["15/BebasNeueBold.otf"] + 2
  seelangStaticImageUsed[4] = true
  if seelangStaticImageToc[4] then
    processSeelangStaticImage[4]()
  end
  dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
  if airrideLevel then
    local w = 522
    y = y - 20
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processSeelangStaticImage[11]()
    end
    dxDrawImage(x + w / 2 - 150, y, 300, 300, seelangStaticImage[11], 0, 0, 0, tocolor(60, 184, 130, 200 * progress))
    local ty = 0
    local rot = 0
    if airrideSettingLevel then
      rot = (1.5 - airrideSettingLevel / 7 * 0.35) * (airrideBias / 4)
      seelangStaticImageUsed[12] = true
      if seelangStaticImageToc[12] then
        processSeelangStaticImage[12]()
      end
      dxDrawImage(x + w / 2 - 150, y - 8 + (airrideSettingLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(60, 184, 130, (155 + 100 * pulse) * progress))
      ty = y - 8 + (airrideSettingLevel + 8) / 15 * 16
    elseif airrideSettingBias then
      rot = (1.5 - airrideLevel / 7 * 0.35) * (airrideSettingBias / 4)
      seelangStaticImageUsed[12] = true
      if seelangStaticImageToc[12] then
        processSeelangStaticImage[12]()
      end
      dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(60, 184, 130, 255 * progress))
      ty = y - 8 + (airrideLevel + 8) / 15 * 16
    else
      rot = (1.5 - airrideLevel / 7 * 0.35) * (airrideBias / 4)
      seelangStaticImageUsed[12] = true
      if seelangStaticImageToc[12] then
        processSeelangStaticImage[12]()
      end
      dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(60, 184, 130, 255 * progress))
      ty = y - 8 + (airrideLevel + 8) / 15 * 16
    end
    ty = ty + 142.5
    local hoverSoftness = airrideSoftness
    for i = -4, 4 do
      if i == airrideSoftness then
        dxDrawRectangle(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 10 * i, 24, 7, tocolor(60, 184, 130, 255 * progress))
      elseif i == airrideSettingSoftness then
        dxDrawRectangle(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 10 * i, 24, 7, tocolor(255, 255, 255, 255 * progress))
        dxDrawRectangle(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 10 * i, 24, 7, tocolor(60, 184, 130, 255 * progress * pulse))
      elseif canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 150 - 12 - 24 and cx <= x + w / 2 - 150 - 12 - 24 + 24 and cy >= y + 150 - 5 + 1 + 10 * i and cy <= y + 150 - 5 + 1 + 10 * i + 10 then
        dxDrawRectangle(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 10 * i, 24, 7, tocolor(255, 255, 255, 255 * progress))
        hover = "airridesoftness:" .. i
        hoverSoftness = i
      else
        dxDrawRectangle(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 10 * i, 24, 7, tocolor(255, 255, 255, 150 * progress))
      end
    end
    if -4 < airrideSoftness then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 150 - 12 - 24 and cx <= x + w / 2 - 150 - 12 - 24 + 24 and cy >= y + 150 - 5 + 1 - 40 - 24 and cy <= y + 150 - 5 + 1 - 40 - 24 + 24 then
        dxDrawImage(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 - 40 - 24, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airridesoftness:up"
        hoverSoftness = hoverSoftness - 1
      else
        dxDrawImage(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 - 40 - 24, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
    if airrideSoftness < 4 then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 150 - 12 - 24 and cx <= x + w / 2 - 150 - 12 - 24 + 24 and cy >= y + 150 - 5 + 1 + 50 - 3 and cy <= y + 150 - 5 + 1 + 50 - 3 + 24 then
        dxDrawImage(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 50 - 3, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 180, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airridesoftness:down"
        hoverSoftness = hoverSoftness + 1
      else
        dxDrawImage(x + w / 2 - 150 - 12 - 24, y + 150 - 5 + 1 + 50 - 3, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 180, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
    local a = 200
    if airrideSettingSoftness then
      a = 200 - pulse * 100
      hoverSoftness = airrideSettingSoftness
    end
    local sw = 30 - 3 * hoverSoftness
    local tan = math.tan(math.rad(rot))
    local h = y + 174 - (ty + -83.1 * tan)
    seelangStaticImageUsed[13] = true
    if seelangStaticImageToc[13] then
      processSeelangStaticImage[13]()
    end
    dxDrawImage(x + w / 2 - 150 + 66.9 - 16, ty + -83.1 * tan, 32, h, seelangStaticImage[13], 0, 0, 0, tocolor(255, 255, 255, a * progress))
    seelangStaticImageUsed[14] = true
    if seelangStaticImageToc[14] then
      processSeelangStaticImage[14]()
    end
    dxDrawImage(x + w / 2 - 150 + 66.9 - sw / 2, ty + -83.1 * tan, sw, h, seelangStaticImage[14], 0, 0, 0, tocolor(255, 255, 255, a * progress))
    local h = y + 174 - (ty + 88.20000000000002 * tan)
    seelangStaticImageUsed[13] = true
    if seelangStaticImageToc[13] then
      processSeelangStaticImage[13]()
    end
    dxDrawImage(x + w / 2 - 150 + 238.20000000000002 - 16, ty + 88.20000000000002 * tan, 32, h, seelangStaticImage[13], 0, 0, 0, tocolor(255, 255, 255, a * progress))
    seelangStaticImageUsed[14] = true
    if seelangStaticImageToc[14] then
      processSeelangStaticImage[14]()
    end
    dxDrawImage(x + w / 2 - 150 + 238.20000000000002 - sw / 2, ty + 88.20000000000002 * tan, sw, h, seelangStaticImage[14], 0, 0, 0, tocolor(255, 255, 255, a * progress))
    for i = 1, 15 do
      local iy = y + 150 + 10 * (-7.5 + i - 1)
      if i == airrideLevel + 8 then
        dxDrawRectangle(x + w / 2 + 150 + 12, iy + 5 - 3.5, 24, 7, tocolor(60, 184, 130, 255 * progress))
      elseif airrideSettingLevel and i == airrideSettingLevel + 8 then
        dxDrawRectangle(x + w / 2 + 150 + 12, iy + 5 - 3.5, 24, 7, tocolor(255, 255, 255, 150 * progress))
        dxDrawRectangle(x + w / 2 + 150 + 12, iy + 5 - 3.5, 24, 7, tocolor(60, 184, 130, 255 * progress * pulse))
      elseif canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 + 150 + 12 and cx <= x + w / 2 + 150 + 12 + 24 and cy >= iy and cy <= iy + 10 then
        dxDrawRectangle(x + w / 2 + 150 + 12, iy + 5 - 3.5, 24, 7, tocolor(255, 255, 255, 255 * progress))
        hover = "airride:" .. i
        local rot = (1.5 - (i - 8) / 7 * 0.35) * (airrideBias / 4)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + i / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawRectangle(x + w / 2 + 150 + 12, iy + 5 - 3.5, 24, 7, tocolor(255, 255, 255, 150 * progress))
      end
    end
    for i = -4, 4 do
      if i == airrideBias then
        dxDrawRectangle(x + w / 2 - 3.5 + 10 * i, y + 150 + 75, 7, 24, tocolor(60, 184, 130, 255 * progress))
      elseif i == airrideSettingBias then
        dxDrawRectangle(x + w / 2 - 3.5 + 10 * i, y + 150 + 75, 7, 24, tocolor(255, 255, 255, 255 * progress))
        dxDrawRectangle(x + w / 2 - 3.5 + 10 * i, y + 150 + 75, 7, 24, tocolor(60, 184, 130, 255 * progress * pulse))
      elseif canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 5 + 10 * i and cx <= x + w / 2 - 5 + 10 * i + 10 and cy >= y + 150 + 75 and cy <= y + 150 + 75 + 24 then
        dxDrawRectangle(x + w / 2 - 3.5 + 10 * i, y + 150 + 75, 7, 24, tocolor(255, 255, 255, 255 * progress))
        hover = "airridebias:" .. i
        local rot = (1.5 - airrideLevel / 7 * 0.35) * (i / 4)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawRectangle(x + w / 2 - 3.5 + 10 * i, y + 150 + 75, 7, 24, tocolor(255, 255, 255, 150 * progress))
      end
    end
    if airrideBias < 4 then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 5 + 50 - 2 and cx <= x + w / 2 - 5 + 50 - 2 + 24 and cy >= y + 150 + 75 and cy <= y + 150 + 75 + 24 then
        dxDrawImage(x + w / 2 - 5 + 50 - 2, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 90, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airridebias:down"
        local rot = (1.5 - airrideLevel / 7 * 0.35) * ((airrideBias + 1) / 4)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawImage(x + w / 2 - 5 + 50 - 2, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 90, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
    if -4 < airrideBias then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 - 5 - 40 - 23 and cx <= x + w / 2 - 5 - 40 - 23 + 24 and cy >= y + 150 + 75 and cy <= y + 150 + 75 + 24 then
        dxDrawImage(x + w / 2 - 5 - 40 - 23, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 270, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airridebias:up"
        local rot = (1.5 - airrideLevel / 7 * 0.35) * ((airrideBias - 1) / 4)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawImage(x + w / 2 - 5 - 40 - 23, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 270, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
    if 1 < airrideLevel + 8 then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 + 150 + 12 and cx <= x + w / 2 + 150 + 12 + 24 and cy >= y + 150 - 75 - 24 and cy <= y + 150 - 75 then
        dxDrawImage(x + w / 2 + 150 + 12, y + 150 - 75 - 24, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airride:up"
        local rot = (1.5 - (airrideLevel - 1) / 7 * 0.35) * (airrideBias / 3)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8 - 1) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawImage(x + w / 2 + 150 + 12, y + 150 - 75 - 24, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
    if airrideLevel + 8 < 15 then
      if canClick and not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and cx and cx >= x + w / 2 + 150 + 12 and cx <= x + w / 2 + 150 + 12 + 24 and cy >= y + 150 + 75 and cy <= y + 150 + 75 + 24 then
        dxDrawImage(x + w / 2 + 150 + 12, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 180, 0, 0, tocolor(60, 184, 130, 255 * progress))
        hover = "airride:down"
        local rot = (1.25 - (airrideLevel + 1) / 7 * 0.35) * (airrideBias / 3)
        seelangStaticImageUsed[12] = true
        if seelangStaticImageToc[12] then
          processSeelangStaticImage[12]()
        end
        dxDrawImage(x + w / 2 - 150, y - 8 + (airrideLevel + 8 + 1) / 15 * 16, 300, 300, seelangStaticImage[12], -0.75 + rot, 0, 0, tocolor(255, 255, 255, 125 * progress))
      else
        dxDrawImage(x + w / 2 + 150 + 12, y + 150 + 75, 24, 24, ":seal_gui/" .. caretIcon .. (faTicks[caretIcon] or ""), 180, 0, 0, tocolor(255, 255, 255, 255 * progress))
      end
    end
  end
  return hover
end
function draw4WD(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  local canClick = cx and getVehicleController(currentVehicle) == localPlayer and getVehicleSpeed(currentVehicle) <= 10
  drawBcg(x, y, progress)
  dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, 0, y + 4, x + 538 - 8, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
  x = x + 8
  dxDrawText("Meghajtás", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
  y = y + fontHeights["15/BebasNeueBold.otf"] + 2
  seelangStaticImageUsed[4] = true
  if seelangStaticImageToc[4] then
    processSeelangStaticImage[4]()
  end
  dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
  local w = 522
  local h = 293 - (y - (radioY + 19))
  is = math.floor(h * 0.75 / 2) * 2
  local red = tocolor(184, 60, 60, 255 * progress)
  local green = tocolor(60, 184, 130, 255 * progress)
  local white = tocolor(255, 255, 255, 255 * progress)
  seelangStaticImageUsed[21] = true
  if seelangStaticImageToc[21] then
    processSeelangStaticImage[21]()
  end
  dxDrawImage(x + w / 2 - is, y + h / 2 - is / 2 - 16, is * 2, is, seelangStaticImage[21], 0, 0, 0, (currentDriveType == "awd" or currentDriveType == "rwd") and green or red)
  seelangStaticImageUsed[22] = true
  if seelangStaticImageToc[22] then
    processSeelangStaticImage[22]()
  end
  dxDrawImage(x + w / 2 - is, y + h / 2 - is / 2 - 16, is * 2, is, seelangStaticImage[22], 0, 0, 0, (currentDriveType == "awd" or currentDriveType == "fwd") and green or red)
  seelangStaticImageUsed[23] = true
  if seelangStaticImageToc[23] then
    processSeelangStaticImage[23]()
  end
  dxDrawImage(x + w / 2 - is, y + h / 2 - is / 2 - 16, is * 2, is, seelangStaticImage[23], 0, 0, 0, tocolor(61, 122, 184, 255 * progress))
  if canClick and cx >= x + w / 2 - 80 - 20 and cx <= x + w / 2 - 80 + 20 and cy >= y + h / 2 + is / 2 - 16 and cy <= y + h / 2 + is / 2 then
    hover = "drivetype:rwd"
  end
  dxDrawText("RWD", x + w / 2 - 80, y + h / 2 + is / 2 - 16, x + w / 2 - 80, y + h / 2 + is / 2, currentDriveType == "rwd" and green or white, fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "center", "center")
  if canClick and cx >= x + w / 2 - 20 and cx <= x + w / 2 + 20 and cy >= y + h / 2 + is / 2 - 16 and cy <= y + h / 2 + is / 2 then
    hover = "drivetype:awd"
  end
  dxDrawText("AWD", x + w / 2, y + h / 2 + is / 2 - 16, x + w / 2, y + h / 2 + is / 2, currentDriveType == "awd" and green or white, fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "center", "center")
  if canClick and cx >= x + w / 2 + 80 - 20 and cx <= x + w / 2 + 80 + 20 and cy >= y + h / 2 + is / 2 - 16 and cy <= y + h / 2 + is / 2 then
    hover = "drivetype:fwd"
  end
  dxDrawText("FWD", x + w / 2 + 80, y + h / 2 + is / 2 - 16, x + w / 2 + 80, y + h / 2 + is / 2, currentDriveType == "fwd" and green or white, fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "center", "center")
  return hover
end
function drawECU(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  local click = false
  if 1 <= progress then
    click = getKeyState("mouse1")
    if click and (getVehicleController(currentVehicle) ~= localPlayer or getVehicleSpeed(currentVehicle) > 10) then
      click = false
    end
  end
  local tmp = false
  local pulse = getTickCount() % 1000 / 1000
  pulse = pulse * 2
  if 1 < pulse then
    pulse = 2 - pulse
  end
  pulse = getEasingValue(pulse, "InOutQuad")
  drawBcg(x, y, progress)
  dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, 0, y + 4, x + 538 - 8, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
  x = x + 8
  dxDrawText("SealECU", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
  y = y + fontHeights["15/BebasNeueBold.otf"] + 2
  seelangStaticImageUsed[4] = true
  if seelangStaticImageToc[4] then
    processSeelangStaticImage[4]()
  end
  dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
  local w = 522
  if ecuBalanceValue then
    y = y + 16
    dxDrawText("Gyorsulás", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"] * 0.75, fonts["15/BebasNeueBold.otf"], "left", "top")
    dxDrawText("Végsebesség", 0, y, x + w, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"] * 0.75, fonts["15/BebasNeueBold.otf"], "right", "top")
    y = y + fontHeights["15/BebasNeueBold.otf"] * 0.75 + 4
    dxDrawRectangle(x, y, w, 2, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x, y + 24 - 2, w, 2, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x, y + 2, 2, 20, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x + w - 2, y + 2, 2, 20, tocolor(255, 255, 255, 125 * progress))
    local balW = (w / 2 - 2) * savedEcuBalanceValue
    seelangStaticImageUsed[24] = true
    if seelangStaticImageToc[24] then
      processSeelangStaticImage[24]()
    end
    dxDrawImage(x + w / 2 + balW - 4, y + 12 - 4, 8, 8, seelangStaticImage[24], 0, 0, 0, tocolor(255, 255, 255, 200 * progress))
    if cx and cx >= x and cx <= x + w and cy >= y and cy <= y + 24 then
      hover = "ecuBalance"
      if click then
        ecuBalanceValue = math.max(math.min(1, (cx - (x + 2)) / (w - 4) * 2 - 1), -1)
        tmp = "bal"
      end
    end
    local balW = (w / 2 - 2) * ecuBalanceValue
    if tmp == "bal" then
      dxDrawRectangle(x + w / 2, y + 2, balW, 20, tocolor(60, 184, 130, (150 - 100 * pulse) * progress))
    else
      dxDrawRectangle(x + w / 2, y + 2, balW, 20, tocolor(60, 184, 130, 150 * progress))
    end
    seelangStaticImageUsed[24] = true
    if seelangStaticImageToc[24] then
      processSeelangStaticImage[24]()
    end
    dxDrawImage(x + w / 2 + balW - 4, y + 12 - 4, 8, 8, seelangStaticImage[24], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
    local cols = 6
    local rows = 8
    local w2 = w / cols
    y = y + 32
    dxDrawText("Optimalizálás:", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
    y = y + fontHeights["15/BebasNeueBold.otf"] + 4
    local h = 293 - (y - (radioY + 19)) - 8 - 24 - 8
    local h2 = h / rows
    local ly = 0
    if cx and cx >= x and cy >= y and cx <= x + w and cy <= y + h then
      hover = "ecuValues"
      if click then
        local i = math.ceil((cx - x) / w2)
        ecuValues[i] = math.max(math.min(1, 1 - (cy - y) / h), -1) * 2 - 1
        tmp = i
      end
    end
    for i = 1, cols do
      local val = ecuValues[i] / 2 + 0.5
      if tmp == i then
        dxDrawRectangle(x + (i - 1) * w2, y + h * (1 - val), w2, h * val, tocolor(60, 184, 130, (150 - 100 * pulse) * progress))
      else
        dxDrawRectangle(x + (i - 1) * w2, y + h * (1 - val), w2, h * val, tocolor(60, 184, 130, 150 * progress))
      end
      if 1 < i then
        dxDrawRectangle(x + (i - 1) * w2 - 1, y + 2, 2, h - 4, tocolor(255, 255, 255, 125 * progress))
      end
      ly = y + h * (1 - val)
    end
    for i = 1, rows do
      if 1 < i then
        dxDrawRectangle(x, y + (i - 1) * h2 - 1, w, 2, tocolor(255, 255, 255, 62.5 * progress))
      end
    end
    dxDrawRectangle(x, y, w, 2, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x, y + 2, 2, h - 4, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x + w - 2, y + 2, 2, h - 4, tocolor(255, 255, 255, 125 * progress))
    dxDrawRectangle(x, y + h - 2, w, 2, tocolor(255, 255, 255, 125 * progress))
    local ly = 0
    local ly2 = 0
    for i = 1, cols do
      local lastVal = savedEcuValues[i] / 2 + 0.5
      if 1 < i then
        dxDrawLine(x + (i - 2 + 0.5) * w2, ly2, x + (i - 1 + 0.5) * w2, y + h * (1 - lastVal), tocolor(255, 255, 255, 100 * progress), 2)
      end
      seelangStaticImageUsed[24] = true
      if seelangStaticImageToc[24] then
        processSeelangStaticImage[24]()
      end
      dxDrawImage(x + (i - 1 + 0.5) * w2 - 5, y + h * (1 - lastVal) - 5, 10, 10, seelangStaticImage[24], 0, 0, 0, tocolor(255, 255, 255, 100 * progress))
      ly2 = y + h * (1 - lastVal)
      local val = ecuValues[i] / 2 + 0.5
      if 1 < i then
        dxDrawLine(x + (i - 2 + 0.5) * w2, ly, x + (i - 1 + 0.5) * w2, y + h * (1 - val), tocolor(60, 184, 130, 255 * progress), 2)
      end
      seelangStaticImageUsed[24] = true
      if seelangStaticImageToc[24] then
        processSeelangStaticImage[24]()
      end
      dxDrawImage(x + (i - 1 + 0.5) * w2 - 5, y + h * (1 - val) - 5, 10, 10, seelangStaticImage[24], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
      ly = y + h * (1 - val)
    end
    y = y + h + 10
    if cx and cx >= x + w - 24 and cx <= x + w and cy >= y and cy <= y + 24 and getVehicleController(currentVehicle) == localPlayer and getVehicleSpeed(currentVehicle) <= 10 then
      dxDrawImage(x + w - 24, y, 24, 24, ":seal_gui/" .. saveIcon .. (faTicks[saveIcon] or ""), 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
      hover = "saveECU"
    else
      dxDrawImage(x + w - 24, y, 24, 24, ":seal_gui/" .. saveIcon .. (faTicks[saveIcon] or ""), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
    end
    if cx and cx >= x + w - 48 and cx <= x + w - 24 and cy >= y and cy <= y + 24 and getVehicleController(currentVehicle) == localPlayer and getVehicleSpeed(currentVehicle) <= 10 then
      dxDrawImage(x + w - 48, y, 24, 24, ":seal_gui/" .. resetIcon .. (faTicks[resetIcon] or ""), 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
      hover = "resetECU"
    else
      dxDrawImage(x + w - 48, y, 24, 24, ":seal_gui/" .. resetIcon .. (faTicks[resetIcon] or ""), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
    end
    if tmp ~= ecuSettingState then
      ecuSettingState = tmp
      if ecuSettingState then
        local sound = playSound("files/push.wav")
        if radioCrashed then
          setSoundEffectEnabled(sound, "distortion", true)
        end
      else
        local sound = playSound("files/pushend.wav")
        if radioCrashed then
          setSoundEffectEnabled(sound, "distortion", true)
        end
      end
    end
  end
  return hover
end
function renderRadio()
  local cx, cy = getCursorPosition()
  if cx then
    cx = cx * screenX
    cy = cy * screenY
    if radioMove then
      radioX = cx - radioMove[1] + radioMove[3]
      radioY = cy - radioMove[2] + radioMove[4]
    end
  else
    radioMove = false
  end
  local hover = false
  local x, y = radioX, radioY
  seelangStaticImageUsed[25] = true
  if seelangStaticImageToc[25] then
    processSeelangStaticImage[25]()
  end
  dxDrawImage(x, y, sizeX, sizeY, seelangStaticImage[25])
  if currentMenu == "off" then
    seelangStaticImageUsed[26] = true
    if seelangStaticImageToc[26] then
      processSeelangStaticImage[26]()
    end
    dxDrawImage(x, y, sizeX, sizeY, seelangStaticImage[26])
  elseif currentMenu == "on" then
    local progress = getEasingValue(math.min((getTickCount() - radioOn) / 2500, 1), "InOutQuad")
    seelangStaticImageUsed[26] = true
    if seelangStaticImageToc[26] then
      processSeelangStaticImage[26]()
    end
    dxDrawImage(x, y, sizeX, sizeY, seelangStaticImage[26], 0, 0, 0, tocolor(255, 255, 255, 255 - progress * 255))
    seelangStaticImageUsed[27] = true
    if seelangStaticImageToc[27] then
      processSeelangStaticImage[27]()
    end
    dxDrawImage(x, y, sizeX, sizeY, seelangStaticImage[27], 0, 0, 0, tocolor(255, 255, 255, progress * 255))
  else
    seelangStaticImageUsed[27] = true
    if seelangStaticImageToc[27] then
      processSeelangStaticImage[27]()
    end
    dxDrawImage(x, y, sizeX, sizeY, seelangStaticImage[27])
  end
  if currentMenu ~= "on" and cx and cx >= x + 23 and cx <= x + 37 and cy >= y + 26 and cy <= y + 41 then
    hover = "toggle"
  end
  local rt = getRealTime()
  local month = rt.month + 1
  if 2 > utf8.len(month) then
    month = "0" .. month
  end
  local monthday = rt.monthday
  if 2 > utf8.len(monthday) then
    monthday = "0" .. monthday
  end
  local hour = rt.hour
  if 2 > utf8.len(hour) then
    hour = "0" .. hour
  end
  local minute = rt.minute
  if 2 > utf8.len(minute) then
    minute = "0" .. minute
  end
  local progress = 1
  if (currentMenu ~= "radio" or lastCurrentMenu ~= "radiolist") and (currentMenu ~= "radiolist" or lastCurrentMenu ~= "radio") then
    progress = (getTickCount() - menuChange) / 1000
    progress = getEasingValue(math.min(progress, 1), "InOutQuad")
  end
  if currentMenu ~= "off" and cx and cx >= x + 610 and cx <= x + 630 then
    if cy >= y + 26 and cy <= y + 46 then
      hover = "menu:home"
    elseif cy >= y + 75 and cy <= y + 89 then
      hover = "volPlus"
    elseif cy >= y + 122 and cy <= y + 136 then
      hover = "volMinus"
    end
  end
  local click = getKeyState("mouse1") or getKeyState("mouse2")
  dxDrawImage(x, y, sizeX, sizeY, dynamicImage("files/home_" .. (click and hover == "menu:home" and "on" or "off") .. ".dds"))
  dxDrawImage(x, y, sizeX, sizeY, dynamicImage("files/plus_" .. (click and hover == "volPlus" and "on" or "off") .. ".dds"))
  dxDrawImage(x, y, sizeX, sizeY, dynamicImage("files/minus_" .. (click and hover == "volMinus" and "on" or "off") .. ".dds"))
  if progress < 1 and hover == "menu:home" then
    hover = false
  end
  if currentMenu == "home" or currentMenu == "off" then
    progress = 1 - progress
    if progress <= 0 then
      lastCurrentMenu = false
    end
  end
  local streamTitle = "N/A"
  if isElement(vehicleSounds[currentVehicle]) then
    local metaTags = getSoundMetaTags(vehicleSounds[currentVehicle])
    if metaTags and metaTags.stream_title then
      streamTitle = metaTags.stream_title
      if utf8.len(streamTitle) > 60 then
        streamTitle = utf8.sub(streamTitle, 1, 60) .. "..."
      end
    end
  end
  if streamTitle ~= currentSong then
    setCurrentSong(streamTitle)
  end
  local songMove = 0
  if currentSongChange then
    songMove = (getTickCount() - currentSongChange) / 750
    songMove = getEasingValue(math.min(songMove, 1), "InOutQuad")
    if 1 <= songMove then
      currentSongChange = false
    end
  end
  if currentMenu == "on" then
    local progress = (getTickCount() - radioOn) / 2500
    if 2 < progress then
      progress = 1 - (progress - 2)
      if progress <= 0 then
        progress = 0
        setMenu("home")
      end
    end
    progress = getEasingValue(math.min(progress, 1), "InOutQuad")
    dxDrawRectangle(x + 57, y + 19, 538, 293, tocolor(17, 20, 32))
    x = x + sizeX / 2
    y = y + sizeY / 2 - 60
    for k = 0, 8 do
      local h = math.floor(math.random(60) * (math.min(k / 8, (8 - k) / 8) * 1.75 + 0.25) * progress)
      seelangStaticImageUsed[3] = true
      if seelangStaticImageToc[3] then
        processSeelangStaticImage[3]()
      end
      dxDrawImage(math.floor(x + 16 * (-4.5 + k) + 2), y + 60 - h, 12, h, seelangStaticImage[3], 0, 0, 0, tocolor(60, 184, 130))
    end
    y = y + 60 + 20
    dxDrawText("SEAL AUDIO SYSTEM", x - 256 * progress, y - 10, x + 256 * progress, y + 10, tocolor(255, 255, 255), fontScales["18/BebasNeueBold.otf"], fonts["18/BebasNeueBold.otf"], "center", "center", true)
    y = y + 25
    local w = math.floor(128 * progress + 0.5)
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y - 2, w, 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130))
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x - w, y - 2, w, 2, seelangStaticImage[4], 180, 0, 0, tocolor(60, 184, 130))
  elseif currentMenu ~= "off" and (currentMenu == "home" or progress < 1) then
    local onProgress = (getTickCount() - radioOn) / 1000
    onProgress = getEasingValue(math.min(onProgress, 1), "InOutQuad")
    x = x + 57
    y = y + 19
    drawBcg(x, y, onProgress)
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y + 293 - 48 - 20, math.floor(538 * onProgress), 20, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130))
    dxDrawRectangle(x, y + 293 - 48, 538 * onProgress, 48, tocolor(18, 18, 18))
    dxDrawText(stationName .. ": ", x + 8, y + 293 - 48 - 20, x + 538 * onProgress, y + 293 - 48, tocolor(255, 255, 255), fontScales["11/Ubuntu-B.ttf"], fonts["11/Ubuntu-B.ttf"], "left", "center", true)
    if currentSongChange then
      dxDrawText(currentSong, x + 8 + dxGetTextWidth(stationName .. ": ", fontScales["11/Ubuntu-B.ttf"], fonts["11/Ubuntu-B.ttf"]), y + 293 - 48 - 20, x + 538 * onProgress, y + 293 - 48 - 20 + 20 * songMove, tocolor(255, 255, 255), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "center", true)
      dxDrawText(lastCurrentSong, x + 8 + dxGetTextWidth(stationName .. ": ", fontScales["11/Ubuntu-B.ttf"], fonts["11/Ubuntu-B.ttf"]), y + 293 - 48 - 20 + 20 * songMove, x + 538 * onProgress, y + 293 - 48, tocolor(255, 255, 255), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "center", true)
    else
      dxDrawText(currentSong, x + 8 + dxGetTextWidth(stationName .. ": ", fontScales["11/Ubuntu-B.ttf"], fonts["11/Ubuntu-B.ttf"]), y + 293 - 48 - 20, x + 538 * onProgress, y + 293 - 48, tocolor(255, 255, 255), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "center", true)
    end
    dxDrawRectangle(x + 538 - 175 - 9, y + 293 - 24 + 14 - 6, 175, 3, tocolor(135, 135, 135, 255 * onProgress))
    if cy and cy >= y + 293 - 48 and cy <= y + 293 and cx >= x + 538 - 175 - 9 - 8 and cx <= x + 538 - 9 + 8 then
      hover = "volume"
    end
    if volumeSet then
      radioVolume = math.max(math.min(1, (cx - (x + 538 - 175 - 9)) / 175), 0)
      if isElement(vehicleSounds[currentVehicle]) then
        setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
      end
    end
    seelangStaticImageUsed[3] = true
    if seelangStaticImageToc[3] then
      processSeelangStaticImage[3]()
    end
    dxDrawImage(x + 538 - 175 - 9 + 171 * radioVolume, math.floor(y + 293 - 24 - 14), 4, 28, seelangStaticImage[3], 0, 0, 0, tocolor(60, 184, 130, 255 * onProgress))
    dxDrawText(math.floor(radioVolume * 100 + 0.5) .. " % ", 0, math.floor(y + 293 - 24 - 14), x + 538 - 175 - 9 + 171 * radioVolume - 4, 0, tocolor(255, 255, 255, 255 * onProgress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
    if cx and cy >= y + 293 - 48 and cy <= y + 293 then
      if cx >= x + 8 and cx <= x + 8 + 43 then
        hover = "prev"
      elseif cx >= x + 16 + 43 and cx <= x + 16 + 43 + 48 then
        hover = "startstop"
      elseif cx >= x + 24 + 43 + 48 and cx <= x + 24 + 43 + 48 + 43 then
        hover = "next"
      end
    end
    if hover == "prev" then
      seelangStaticImageUsed[28] = true
      if seelangStaticImageToc[28] then
        processSeelangStaticImage[28]()
      end
      dxDrawImage(x + 8, y + 293 - 24 - 11, 43, 22, seelangStaticImage[28], 180, 0, 0, tocolor(60, 184, 130, 255 * onProgress))
    else
      seelangStaticImageUsed[28] = true
      if seelangStaticImageToc[28] then
        processSeelangStaticImage[28]()
      end
      dxDrawImage(x + 8, y + 293 - 24 - 11, 43, 22, seelangStaticImage[28], 180, 0, 0, tocolor(255, 255, 255, 105 * onProgress))
    end
    local color = tocolor(255, 255, 255, 105 * onProgress)
    if hover == "startstop" then
      color = tocolor(60, 184, 130, 255 * onProgress)
    end
    if radioState then
      seelangStaticImageUsed[29] = true
      if seelangStaticImageToc[29] then
        processSeelangStaticImage[29]()
      end
      dxDrawImage(x + 16 + 43, y + 293 - 48, 48, 48, seelangStaticImage[29], 0, 0, 0, color)
    else
      seelangStaticImageUsed[30] = true
      if seelangStaticImageToc[30] then
        processSeelangStaticImage[30]()
      end
      dxDrawImage(x + 16 + 43, y + 293 - 48, 48, 48, seelangStaticImage[30], 0, 0, 0, color)
    end
    if hover == "next" then
      seelangStaticImageUsed[28] = true
      if seelangStaticImageToc[28] then
        processSeelangStaticImage[28]()
      end
      dxDrawImage(x + 24 + 43 + 48, y + 293 - 24 - 11, 43, 22, seelangStaticImage[28], 0, 0, 0, tocolor(60, 184, 130, 255 * onProgress))
    else
      seelangStaticImageUsed[28] = true
      if seelangStaticImageToc[28] then
        processSeelangStaticImage[28]()
      end
      dxDrawImage(x + 24 + 43 + 48, y + 293 - 24 - 11, 43, 22, seelangStaticImage[28], 0, 0, 0, tocolor(255, 255, 255, 105 * onProgress))
    end
    dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, x + 538 - 8 - 128 * onProgress, y + 4, x + 538 - 8, y + 64, tocolor(255, 255, 255), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top", true)
    x = x + 8
    dxDrawText("SEAL AUDIO SYSTEM", x, y, x + 128 * onProgress, y + 64, tocolor(255, 255, 255), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top", true)
    y = y + fontHeights["15/BebasNeueBold.otf"] + 2
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y, math.floor(256 * onProgress), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130))
    local w = math.floor(261)
    local itemW = w * 2 / 4
    local h = 225 - (fontHeights["15/BebasNeueBold.otf"] + 2)
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y + h / 2, w + 64, 1, seelangStaticImage[4], 0, 0, 0, tocolor(220, 220, 220, 220 * onProgress))
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x + w - 64, y + h / 2, w + 64, 1, seelangStaticImage[4], 180, 0, 0, tocolor(220, 220, 220, 220 * onProgress))
    local item = 48 + fontHeights["11/Ubuntu-L.ttf"] + 4
    local id = 1
    for i = 1, 2 do
      for k = 1, 4 do
        if menus[id] then
          local available = true
          local a = 255
          if menus[id] == "ecu" then
            available = ecuBalanceValue and true or false
            a = available and 255 or 200
          elseif menus[id] == "airride" then
            available = airrideLevel and true or false
            a = available and 255 or 200
          elseif menus[id] == "awd" then
            available = currentDriveType and true or false
            a = available and 255 or 200
          end
          if cx and cx >= x + itemW / 2 - 32 and cx <= x + itemW / 2 + 32 and cy >= y + h / 4 - item / 2 and cy <= y + h / 4 + item / 2 then
            hover = "menu:" .. menus[id]
            dxDrawImage(x + itemW / 2 - 24, y + h / 4 - item / 2, 48, 48, dynamicImage("files/" .. menus[id] .. (not available and "2" or "") .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, a * onProgress))
            seelangStaticImageUsed[31] = true
            if seelangStaticImageToc[31] then
              processSeelangStaticImage[31]()
            end
            dxDrawImage(x + itemW / 2 - 24, y + h / 4 - item / 2, 48, 48, seelangStaticImage[31], 0, 0, 0, tocolor(255, 255, 255, a * 0.75 * onProgress))
            dxDrawText(menuTitles[id], x + itemW / 2 - 32, y + h / 4 - item / 2 + 48 + 4, x + itemW / 2 + 32, y, tocolor(255, 255, 255, a * onProgress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
          else
            dxDrawImage(x + itemW / 2 - 24 + 3, y + h / 4 - item / 2 + 3, 42, 42, dynamicImage("files/" .. menus[id] .. (not available and "2" or "") .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, a * onProgress))
            dxDrawText(menuTitles[id], x + itemW / 2 - 32, y + h / 4 - item / 2 + 48 + 4, x + itemW / 2 + 32, y, tocolor(255, 255, 255, a * onProgress), fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], "center", "top")
          end
        end
        id = id + 1
        x = x + itemW
      end
      x = x - itemW * 4
      y = y + h / 2 + 1
    end
  else
    dxDrawRectangle(x + 57, y + 19, 538, 293, tocolor(15, 15, 15))
  end
  x, y = radioX + 57, radioY + 19
  if currentMenu == "awd" or lastCurrentMenu == "awd" then
    hover = draw4WD(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  elseif currentMenu == "ecu" or lastCurrentMenu == "ecu" then
    hover = drawECU(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  elseif currentMenu == "airride" or lastCurrentMenu == "airride" then
    hover = drawAirRide(cx, cy, hover, rt, month, monthday, hour, minute, x, y, progress)
  elseif currentMenu == "computer" or lastCurrentMenu == "computer" then
    drawComputer(rt, month, monthday, hour, minute, x, y, progress)
  elseif currentMenu == "settings" or lastCurrentMenu == "settings" then
    drawBcg(x, y, progress)
    dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, 0, y + 4, x + 538 - 8, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
    x = x + 8
    dxDrawText("Beállítások", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["15/BebasNeueBold.otf"], fonts["15/BebasNeueBold.otf"], "left", "top")
    y = y + fontHeights["15/BebasNeueBold.otf"] + 2
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
    y = y + 24
    dxDrawText("Háttérkép: ", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "left", "top")
    x = x + dxGetTextWidth("Háttérkép: ", fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"]) + 8
    if cx and cx >= x and cx <= x + 12 and cy >= y and cy <= y + fontHeights["11/Ubuntu-L.ttf"] then
      hover = "prevWallpaper"
      dxDrawText("<", x, y, x + 12, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    else
      dxDrawText("<", x, y, x + 12, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    end
    x = x + 12
    dxDrawText(radioWallpaper, x, y, x + 24, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    x = x + 24
    if cx and cx >= x and cx <= x + 12 and cy >= y and cy <= y + fontHeights["11/Ubuntu-L.ttf"] then
      hover = "nextWallpaper"
      dxDrawText(">", x, y, x + 12, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    else
      dxDrawText(">", x, y, x + 12, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    end
    x = radioX + 57 + 8
    y = y + fontHeights["11/Ubuntu-L.ttf"] + 4
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(220, 220, 220, 220 * progress))
    y = y + 8
    dxDrawText("Fényerő: ", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "left", "top")
    x = x + dxGetTextWidth("Fényerő: ", fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"]) + 8
    if cx and cx >= x and cx <= x + 12 and cy >= y and cy <= y + fontHeights["11/Ubuntu-L.ttf"] then
      hover = "minusBrightness"
      dxDrawText("<", x, y, x + 12, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    else
      dxDrawText("<", x, y, x + 12, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    end
    x = x + 12
    dxDrawText(radioBrightness, x, y, x + 24, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    x = x + 24
    if cx and cx >= x and cx <= x + 12 and cy >= y and cy <= y + fontHeights["11/Ubuntu-L.ttf"] then
      hover = "plusBrightness"
      dxDrawText(">", x, y, x + 12, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    else
      dxDrawText(">", x, y, x + 12, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    end
    x = radioX + 57 + 8
    y = y + fontHeights["11/Ubuntu-L.ttf"] + 4
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(220, 220, 220, 220 * progress))
    y = y + 8
    dxDrawText("Rendszerhangok: ", x, y, 0, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "left", "top")
    x = x + dxGetTextWidth("Rendszerhangok: ", fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"]) + 8
    if cx and cx >= x and cx <= x + 24 and cy >= y and cy <= y + fontHeights["11/Ubuntu-L.ttf"] then
      hover = "disableSystemAudio"
    end
    if not disableSystemAudio then
      dxDrawText("be", x, y, x + 24, 0, tocolor(60, 184, 130, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    else
      dxDrawText("ki", x, y, x + 24, 0, tocolor(243, 90, 90, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "center", "top")
    end
    x = radioX + 57 + 8
    y = y + fontHeights["11/Ubuntu-L.ttf"] + 4
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processSeelangStaticImage[4]()
    end
    dxDrawImage(x, y, math.floor(256), 2, seelangStaticImage[4], 0, 0, 0, tocolor(220, 220, 220, 220 * progress))
  elseif currentMenu == "radio" or lastCurrentMenu == "radio" or currentMenu == "radiolist" or lastCurrentMenu == "radiolist" then
    drawBcg(x, y, progress)
    dxDrawRectangle(x, y + 293 - 48, 538, 48, tocolor(18, 18, 18, 255 * progress))
    local s = math.ceil(fontHeights["11/Ubuntu-L.ttf"] * 1.25)
    if cx and cx >= x + 4 and cy >= y + 4 and cx <= x + s + 4 and cy <= y + s + 4 and (not menuChange or getTickCount() - menuChange >= 1000) then
      hover = "menu:" .. (currentMenu == "radio" and "radiolist" or "radio")
    end
    dxDrawImage(x + 4, y + 4, s, s, ":seal_gui/" .. listIcon .. (faTicks[listIcon] or ""), 0, 0, 0, tocolor(255, 255, 255, 255 * progress))
    if cx and cx >= x and cy >= y + 293 - 48 and cx <= x + 48 and cy <= y + 293 then
      hover = "startstop"
    end
    if hover == "startstop" then
      if isElement(vehicleSounds[currentVehicle]) and radioState then
        seelangStaticImageUsed[29] = true
        if seelangStaticImageToc[29] then
          processSeelangStaticImage[29]()
        end
        dxDrawImage(x, y + 293 - 48, 48, 48, seelangStaticImage[29], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
      else
        seelangStaticImageUsed[30] = true
        if seelangStaticImageToc[30] then
          processSeelangStaticImage[30]()
        end
        dxDrawImage(x, y + 293 - 48, 48, 48, seelangStaticImage[30], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
      end
    elseif isElement(vehicleSounds[currentVehicle]) and radioState then
      seelangStaticImageUsed[29] = true
      if seelangStaticImageToc[29] then
        processSeelangStaticImage[29]()
      end
      dxDrawImage(x, y + 293 - 48, 48, 48, seelangStaticImage[29], 0, 0, 0, tocolor(255, 255, 255, 105 * progress))
    else
      seelangStaticImageUsed[30] = true
      if seelangStaticImageToc[30] then
        processSeelangStaticImage[30]()
      end
      dxDrawImage(x, y + 293 - 48, 48, 48, seelangStaticImage[30], 0, 0, 0, tocolor(255, 255, 255, 105 * progress))
    end
    dxDrawRectangle(x + 538 - 175 - 9, y + 293 - 24 + 14 - 6, 175, 3, tocolor(135, 135, 135, 255 * progress))
    if cy and cy >= y + 293 - 48 and cy <= y + 293 and cx >= x + 538 - 175 - 9 - 8 and cx <= x + 538 - 9 + 8 then
      hover = "volume"
    end
    if volumeSet then
      radioVolume = math.max(math.min(1, (cx - (x + 538 - 175 - 9)) / 175), 0)
      if isElement(vehicleSounds[currentVehicle]) then
        setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
      end
    end
    seelangStaticImageUsed[3] = true
    if seelangStaticImageToc[3] then
      processSeelangStaticImage[3]()
    end
    dxDrawImage(x + 538 - 175 - 9 + 171 * radioVolume, math.floor(y + 293 - 24 - 14), 4, 28, seelangStaticImage[3], 0, 0, 0, tocolor(60, 184, 130, 255 * progress))
    dxDrawText(math.floor(radioVolume * 100 + 0.5) .. " % ", 0, math.floor(y + 293 - 24 - 14), x + 538 - 175 - 9 + 171 * radioVolume - 4, 0, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top")
    dxDrawText(rt.year - 100 .. "." .. month .. "." .. monthday .. " | " .. hour .. ":" .. minute, x, y + 4, x + 538 - 8, y + 64, tocolor(255, 255, 255, 255 * progress), fontScales["11/Ubuntu-L.ttf"], fonts["11/Ubuntu-L.ttf"], "right", "top", true)
    local id = 0
    x = x + 1
    y = y - 1
    local w = 134
    for i = 1, 4 do
      for j = 1, 2 do
        id = id + 1
        if cx and cx >= x + w * (i - 1) + 1 and cy >= y + 293 - 48 - 64 + 32 * (j - 1) + 1 and cx <= x + w * i + 1 and cy <= y + 293 - 48 - 64 + 32 * j + 1 then
          dxDrawRectangle(x + w * (i - 1) + 1, y + 293 - 48 - 64 + 32 * (j - 1) + 1, w - 2, 30, tocolor(44, 48, 52, 200 * progress))
          hover = "fav:" .. id
        else
          dxDrawRectangle(x + w * (i - 1) + 1, y + 293 - 48 - 64 + 32 * (j - 1) + 1, w - 2, 30, tocolor(34, 38, 42, 200 * progress))
        end
        if radioFavorites[id] and stationList[radioFavorites[id]] then
          local color = false
          if currentRadio == radioFavorites[id] then
            color = tocolor(60, 184, 130, 255 * progress)
          else
            color = tocolor(255, 255, 255, 200 * progress)
          end
          dxDrawText(stationList[radioFavorites[id]][2], x + w * (i - 1) + 5, y + 293 - 48 - 64 + 32 * (j - 1) + 5, x + w * i - 5, y + 293 - 48 - 64 + 32 * j - 5, color, fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"], dxGetTextWidth(stationList[radioFavorites[id]][2], fontScales["11/Ubuntu-L.ttf"] * 0.9, fonts["11/Ubuntu-L.ttf"]) > 124.5 and "left" or "center", "center", true)
        end
      end
    end
    x = x - 1
    y = y + 1
    y = y + 8
    local p2 = (currentMenu == "radiolist" or lastCurrentMenu == "radiolist") and 1 or 0
    local p3 = (currentMenu == "radio" or lastCurrentMenu == "radio") and 1 or 0
    if currentMenu == "radio" and lastCurrentMenu == "radiolist" or currentMenu == "radiolist" and lastCurrentMenu == "radio" then
      p2 = (getTickCount() - menuChange) / 1000
      p2 = getEasingValue(math.min(p2, 1), "InOutQuad")
      p3 = 1 - p2
      if currentMenu == "radio" then
        p2, p3 = p3, p2
      end
    end
    if 0 < p2 then
      local y = y + 4 + s
      local h = 165 - s
      dxDrawRectangle(x + 4, y, 530, h, tocolor(34, 38, 42, 150 * progress * p2))
      local sh = h / (#stationList - 6 + 1)
      dxDrawRectangle(x + 538 - 4 - 2, y, 2, h, tocolor(34, 38, 42, 255 * progress * p2))
      dxDrawRectangle(x + 538 - 4 - 2, y + sh * radioListScroll, 2, sh, tocolor(60, 184, 130, 255 * progress * p2))
      h = h / 6
      for i = 1, 6 do
        if 1 <= progress and 1 <= p2 then
          if currentRadio == i + radioListScroll then
            dxDrawRectangle(x + 4, y, 528, h, tocolor(44, 48, 52, 170 * progress * p2))
            if cx and cx >= x + 4 and cx <= x + 538 - 4 and cy >= y and cy <= y + h then
              hover = "radiolist:" .. i
            end
          elseif cx and cx >= x + 4 and cx <= x + 538 - 4 and cy >= y and cy <= y + h then
            dxDrawRectangle(x + 4, y, 528, h, tocolor(44, 48, 52, 150 * progress * p2))
            hover = "radiolist:" .. i
          end
        end
        if stationList[i + radioListScroll] then
          local c = currentRadio == i + radioListScroll and tocolor(60, 184, 130, 255 * progress * p2) or tocolor(255, 255, 255, 200 * progress * p2)
          dxDrawText(stationList[i + radioListScroll][2], x + 4 + 4, y, x + 538 - 12 - 2, y + h, c, fontScales["11/Ubuntu-R.ttf"], fonts["11/Ubuntu-R.ttf"], "left", "center", true)
          if currentRadio == i + radioListScroll then
            local sx = x + 538 - 12 - 2 - 32
            if isElement(vehicleSounds[currentVehicle]) then
              local w = 3.2
              local soundSample = getSoundFFTData(vehicleSounds[currentVehicle], 1024, 24)
              if soundSample then
                for i = 1, 10 do
                  local p1 = math.min(1, math.max(0, soundSample[i * 2 - 1]))
                  local p2 = math.min(1, math.max(0, soundSample[i * 2]))
                  local hg = math.floor((h - 8) * (p1 + p2) + 0.5) + 5
                  if hg > h - 8 then
                    hg = h - 8
                  end
                  seelangStaticImageUsed[3] = true
                  if seelangStaticImageToc[3] then
                    processSeelangStaticImage[3]()
                  end
                  dxDrawImage(sx + w * (i - 1), y + h - 4 - hg, w / 2, hg, seelangStaticImage[3], 0, 0, 0, tocolor(60, 184, 130, 255 * progress * p2))
                end
              end
            end
            dxDrawText(currentSong, x + 4 + 4 + dxGetTextWidth(stationList[i + radioListScroll][2], fontScales["11/Ubuntu-R.ttf"], fonts["11/Ubuntu-R.ttf"]) + 4, y, sx - 8, y + h, c, fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "right", "center", true)
          end
          y = y + h
        end
      end
    end
    if 0 < p3 then
      if currentRadioChange then
        local move = (getTickCount() - currentRadioChange) / 1000
        move = getEasingValue(math.min(move, 1), "InOutQuad")
        if 1 <= move then
          currentRadioChange = false
        end
        if radioChangeDir then
          dxDrawText(lastStationName, x + 269 - lastStationWidth / 2 + (269 + lastStationWidth / 2) * move, y, x + 538 - 43 - 8, y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"], "left", "center", true)
          dxDrawText(stationName, x + 43 + 8, y, x + (269 + stationWidth / 2) * move, y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"], "right", "center", true)
        else
          dxDrawText(lastStationName, x + 43 + 8, y, x + (269 + lastStationWidth / 2) * (1 - move), y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"], "right", "center", true)
          dxDrawText(stationName, x + 538 - 43 - 8 + (269 - stationWidth / 2 - 487) * move, y, x + 538 - 43 - 8, y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"], "left", "center", true)
        end
      else
        dxDrawText(stationName, x + 269 - stationWidth / 2, y, x + 538, y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"], "left", "center", true)
      end
      seelangStaticImageUsed[28] = true
      if seelangStaticImageToc[28] then
        processSeelangStaticImage[28]()
      end
      if cy and cy >= y + 90.5 - 11 and cy <= y + 90.5 + 11 then
        if cx >= x + 538 - 43 - 8 and cx <= x + 538 - 8 then
          hover = "next"
        elseif cx >= x + 8 and cx <= x + 8 + 43 then
          hover = "prev"
        end
      end
      if hover == "next" then
        seelangStaticImageUsed[28] = true
        if seelangStaticImageToc[28] then
          processSeelangStaticImage[28]()
        end
        dxDrawImage(x + 538 - 43 - 8, y + 90.5 - 11, 43, 22, seelangStaticImage[28], 0, 0, 0, tocolor(60, 184, 130, 255 * progress * p3))
      else
        seelangStaticImageUsed[28] = true
        if seelangStaticImageToc[28] then
          processSeelangStaticImage[28]()
        end
        dxDrawImage(x + 538 - 43 - 8, y + 90.5 - 11, 43, 22, seelangStaticImage[28], 0, 0, 0, tocolor(255, 255, 255, 105 * progress * p3))
      end
      if hover == "prev" then
        seelangStaticImageUsed[28] = true
        if seelangStaticImageToc[28] then
          processSeelangStaticImage[28]()
        end
        dxDrawImage(x + 8, y + 90.5 - 11, 43, 22, seelangStaticImage[28], 180, 0, 0, tocolor(60, 184, 130, 255 * progress * p3))
      else
        seelangStaticImageUsed[28] = true
        if seelangStaticImageToc[28] then
          processSeelangStaticImage[28]()
        end
        dxDrawImage(x + 8, y + 90.5 - 11, 43, 22, seelangStaticImage[28], 180, 0, 0, tocolor(255, 255, 255, 105 * progress * p3))
      end
      local w = math.floor(134.5)
      seelangStaticImageUsed[4] = true
      if seelangStaticImageToc[4] then
        processSeelangStaticImage[4]()
      end
      dxDrawImage(x + 269 - w, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2, w, 2, seelangStaticImage[4], 180, 0, 0, tocolor(60, 184, 130, 255 * progress * p3))
      seelangStaticImageUsed[4] = true
      if seelangStaticImageToc[4] then
        processSeelangStaticImage[4]()
      end
      dxDrawImage(x + 269, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2, w, 2, seelangStaticImage[4], 0, 0, 0, tocolor(60, 184, 130, 255 * progress * p3))
      if currentSongChange then
        dxDrawText(currentSong, x + 269 - currentWidth / 2, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2 + 10, x + 538, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2 + 10 + fontHeights["11/Ubuntu-LI.ttf"] * songMove, tocolor(255, 255, 255, 255 * progress * p3), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "top", true)
        dxDrawText(lastCurrentSong, x + 269 - lastCurrentWidth / 2, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2 + 10 + fontHeights["11/Ubuntu-LI.ttf"] * songMove, x + 538, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2 + 10 + fontHeights["11/Ubuntu-LI.ttf"], tocolor(255, 255, 255, 255 * progress * p3), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "bottom", true)
      else
        dxDrawText(currentSong, x + 269 - currentWidth / 2, y + 90.5 + 8 + fontHeights["24/BebasNeueLight.otf"] / 2 + 10, x + 538, y + 293 - 48 - 64, tocolor(255, 255, 255, 255 * progress * p3), fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"], "left", "top", true)
      end
      if isElement(vehicleSounds[currentVehicle]) then
        local w = math.floor((stationWidth + 4) / 10)
        local bx = math.floor(x + 269 - (stationWidth + 4) / 2)
        local by = math.floor(y + 90.5 - fontHeights["24/BebasNeueLight.otf"] / 2)
        local soundSample = getSoundFFTData(vehicleSounds[currentVehicle], 1024, 24)
        if soundSample then
          for i = 1, 10 do
            local p1 = math.min(1, math.max(0, soundSample[i * 2 - 1]))
            local p2 = math.min(1, math.max(0, soundSample[i * 2]))
            local h = math.floor(65 * (p1 + p2) + 0.5) + 5
            if 65 < h then
              h = 65
            end
            seelangStaticImageUsed[3] = true
            if seelangStaticImageToc[3] then
              processSeelangStaticImage[3]()
            end
            dxDrawImage(bx + w * (i - 1) + 2, by - h, w - 4, h, seelangStaticImage[3], 0, 0, 0, tocolor(60, 184, 130, 255 * progress * p3))
          end
        end
      end
    end
    if not (1 <= p2) and not (1 <= p3) then
      hover = false
    end
  end
  if hover ~= currentHover and 1 >= getPedOccupiedVehicleSeat(localPlayer) then
    currentHover = hover
    seexports.seal_gui:setCursorType(hover and "link" or "normal")
    if currentHover then
      local cmd = split(currentHover, ":")
      if cmd[1] == "fav" then
        seexports.seal_gui:showTooltip("Mentéshez tartsd nyomva")
      elseif cmd[1] == "airridesoftness" then
        seexports.seal_gui:showTooltip("Airride keménység")
      elseif cmd[1] == "airride" then
        seexports.seal_gui:showTooltip("Airride hasmagasság")
      elseif cmd[1] == "airridebias" then
        seexports.seal_gui:showTooltip("Airride dőlés")
      elseif cmd[1] == "airridememory" then
        seexports.seal_gui:showTooltip("Kattintás: memória betöltése\nNyomva tartás (pittyenésig): memória mentés")
      else
        seexports.seal_gui:showTooltip(false)
      end
    else
      seexports.seal_gui:showTooltip(false)
    end
  end
  if currentMenu ~= "off" or 0 < progress then
    local prog = (currentMenu == "off" or currentMenu == "on") and progress or 1
    if radioBrightness < 5 then
      local a = (5 - radioBrightness) / 5 * 195
      dxDrawRectangle(radioX + 57, radioY + 19, 538, 293, tocolor(10, 10, 10, a * prog))
    end
    seelangStaticImageUsed[32] = true
    if seelangStaticImageToc[32] then
      processSeelangStaticImage[32]()
    end
    dxDrawImage(radioX, radioY, sizeX, sizeY, seelangStaticImage[32], 0, 0, 0, tocolor(255, 255, 255, 200 * (radioBrightness / 10) * prog))
  end
  seelangStaticImageUsed[33] = true
  if seelangStaticImageToc[33] then
    processSeelangStaticImage[33]()
  end
  dxDrawImage(radioX, radioY, sizeX, sizeY, seelangStaticImage[33])
  if 0 < scratchLevel then
    seelangStaticImageUsed[34] = true
    if seelangStaticImageToc[34] then
      processSeelangStaticImage[34]()
    end
    dxDrawImage(radioX, radioY, sizeX, sizeY, seelangStaticImage[34], 0, 0, 0, tocolor(255, 255, 255, 255 * scratchLevel))
  end
  if radioCrashed then
    seelangStaticImageUsed[35] = true
    if seelangStaticImageToc[35] then
      processSeelangStaticImage[35]()
    end
    dxDrawImage(radioX, radioY, sizeX, sizeY, seelangStaticImage[35], 0, 0, 0, tocolor(255, 255, 255, 178.5))
  end
end
function carTuneRadio(veh)
end
addEventHandler("onClientElementDataChange", getRootElement(), function(data, was, new)
  if getElementType(source) == "vehicle" then
    if source == currentVehicle then
      if data == "vehradio.broken" then
        radioCrashed = new
        checkVehicleRadio2D()
      elseif data == "vehradio.wallpaper" then
        radioWallpaper = new or 0
        if not disableSystemAudio then
          local sound = playSound("files/button.wav")
          if radioCrashed then
            setSoundEffectEnabled(sound, "distortion", true)
          end
        end
      elseif data == "vehradio.brightness" then
        radioBrightness = new or 6
        if not disableSystemAudio then
          local sound = playSound("files/button.wav")
          if radioCrashed then
            setSoundEffectEnabled(sound, "distortion", true)
          end
        end
      elseif data == "vehradio.sysAudio" then
        disableSystemAudio = new
        if not disableSystemAudio then
          local sound = playSound("files/button.wav")
          if radioCrashed then
            setSoundEffectEnabled(sound, "distortion", true)
          end
        end
      elseif data == "vehradio.state" then
        radioState = new
        if isElement(vehicleSounds[currentVehicle]) then
          destroyElement(vehicleSounds[currentVehicle])
        end
        if radioState then
          vehicleSounds[currentVehicle] = playSound(stationList[currentRadio][1])
          setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
          if radioCrashed then
            setSoundEffectEnabled(vehicleSounds[currentVehicle], "distortion", true)
          end
        else
          vehicleSounds[currentVehicle] = false
        end
      elseif data == "vehradio.favorites" then
        radioFavorites = new or {}
        local sound = "fav"
        local sum = 0
        for k in pairs(radioFavorites) do
          if radioFavorites[k] and stationList[radioFavorites[k]] then
            sum = sum + 1
          end
        end
        local sum2 = 0
        for k in pairs(was or {}) do
          if was[k] and stationList[was[k]] then
            sum2 = sum2 + 1
          end
        end
        if sum < sum2 then
          sound = "delfav"
        end
        if not disableSystemAudio then
          local sound = playSound("files/" .. sound .. ".wav")
          if radioCrashed then
            setSoundEffectEnabled(sound, "distortion", true)
          end
        end
      elseif data == "vehradio.menu" then
        local menu = new or "off"
        if menu == "off" then
          setElementData(currentVehicle, "vehradio.state", false)
        end
        if was == "off" or not was then
          if not disableSystemAudio then
            local sound = playSound("files/on.wav")
            if radioCrashed then
              setSoundEffectEnabled(sound, "distortion", true)
            end
          end
          setMenu("on")
        else
          setMenu(menu)
          if not disableSystemAudio then
            local sound = playSound("files/menu.wav")
            if radioCrashed then
              setSoundEffectEnabled(sound, "distortion", true)
            end
          end
        end
      elseif data == "vehradio.volume" then
        radioVolume = new or 1
        if isElement(vehicleSounds[currentVehicle]) then
          setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
        end
      elseif data == "vehradio.station" then
        currentRadio = tonumber(new) or 1
        setCurrentStation(currentRadio)
        local dir = currentRadio - (was or 0)
        radioChangeDir = (not (0 < dir) or not (dir <= 1)) and not (dir < -1)
        if not disableSystemAudio then
          local sound = playSound("files/button.wav")
          if radioCrashed then
            setSoundEffectEnabled(sound, "distortion", true)
          end
        end
      end
    elseif data == "vehradio.volume" then
      if isElement(vehicleSounds[source]) then
        if isElementStreamedIn(source) and source ~= currentVehicle then
          checkVehicleRadioWindow(source)
        else
          setStreamerModeVolume(vehicleSounds[source], new or 1)
        end
      end
    elseif data == "vehicle.windowState" or data == "vehradio.broken" then
      if isElementStreamedIn(source) and source ~= currentVehicle then
        checkVehicleRadioWindow(source)
      end
    elseif data == "vehradio.station" or data == "vehradio.state" then
      checkVehicleRadio3D(source)
    end
  end
end)
function setFavorite()
  favoriteSetTimer = false
  if currentVehicle and currentHover then
    local cmd = split(currentHover, ":")
    if cmd[1] == "fav" then
      local id = tonumber(cmd[2]) or 1
      if id then
        radioFavorites[id] = currentRadio
        setElementData(currentVehicle, "vehradio.favorites", radioFavorites)
      end
    end
  end
end
function setVolumeButton(cmd)
  if cmd == "volPlus" then
    radioVolume = radioVolume + 0.05
    if 1 < radioVolume then
      radioVolume = 1
    end
    setElementData(currentVehicle, "vehradio.volume", radioVolume)
  elseif cmd == "volMinus" then
    radioVolume = radioVolume - 0.05
    if radioVolume < 0 then
      radioVolume = 0
    end
    setElementData(currentVehicle, "vehradio.volume", radioVolume)
  end
end
local lastChange = 0
function setFavoriteAirride()
  favoriteSetTimer = false
  if currentVehicle and currentHover then
    local cmd = split(currentHover, ":")
    if cmd[1] == "airridememory" then
      local id = tonumber(cmd[2]) or 1
      if id then
        triggerServerEvent("saveVehicleAirrideFavorite", currentVehicle, id)
        local sound = playSound("files/fav.wav")
      end
    end
  end
end
local lastAirrideLoad = 0
function clickRadio(button, state, cx, cy)
  if getElementData(localPlayer, "cuffed") then
    return
  end
  if state == "up" and radioMove then
    radioMove = false
  elseif state == "up" and volumeTimer then
    if isTimer(volumeTimer) then
      killTimer(volumeTimer)
    end
    volumeTimer = false
  elseif state == "up" and favoriteSetTimer then
    if isTimer(favoriteSetTimer) then
      killTimer(favoriteSetTimer)
    end
    favoriteSetTimer = false
    if currentHover then
      local cmd = split(currentHover, ":")
      if cmd[1] == "airridememory" then
        local id = tonumber(cmd[2]) or 1
        triggerServerEvent("loadVehicleAirrideFavorite", currentVehicle, id, getElementsByType("player", getRootElement(), true))
      elseif cmd[1] == "fav" then
        local id = tonumber(cmd[2]) or 1
        if radioFavorites[id] and stationList[radioFavorites[id]] then
          setElementData(currentVehicle, "vehradio.station", radioFavorites[id])
        end
      end
    end
  elseif state == "up" and volumeSet then
    volumeSet = false
    setElementData(currentVehicle, "vehradio.volume", radioVolume)
  elseif state == "down" then
    if currentHover then
      local cmd = split(currentHover, ":")
      if cmd[1] == "drivetype" then
        triggerServerEvent("setCurrentVehicleDriveType", currentVehicle, cmd[2])
        local sound = playSound("files/savestats.wav")
        if radioCrashed then
          setSoundEffectEnabled(sound, "distortion", true)
        end
      elseif cmd[1] == "saveECU" then
        triggerServerEvent("saveEcuData", currentVehicle, ecuBalanceValue, ecuValues)
        local sound = playSound("files/savestats.wav")
        if radioCrashed then
          setSoundEffectEnabled(sound, "distortion", true)
        end
      elseif cmd[1] == "resetECU" then
        ecuBalanceValue = savedEcuBalanceValue
        for i = 1, #ecuValues do
          ecuValues[i] = savedEcuValues[i]
        end
        local sound = playSound("files/reset.wav")
        if radioCrashed then
          setSoundEffectEnabled(sound, "distortion", true)
        end
      elseif cmd[1] == "airridememory" then
        if not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness and getTickCount() - lastAirrideLoad > 2000 then
          favoriteSetTimer = setTimer(setFavoriteAirride, 1000, 1)
          lastAirrideLoad = getTickCount()
        end
      elseif cmd[1] == "airridesoftness" then
        if not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness then
          if cmd[2] == "up" then
            if -4 < airrideSoftness then
              airrideSettingSoftness = airrideSoftness - 1
              triggerServerEvent("setVehicleAirRideSoftness", currentVehicle, airrideSettingSoftness, getElementsByType("player", getRootElement(), true))
            end
          elseif cmd[2] == "down" then
            if airrideSoftness < 4 then
              airrideSettingSoftness = airrideSoftness + 1
              triggerServerEvent("setVehicleAirRideSoftness", currentVehicle, airrideSettingSoftness, getElementsByType("player", getRootElement(), true))
            end
          elseif tonumber(cmd[2]) and tonumber(cmd[2]) >= -4 and tonumber(cmd[2]) <= 4 then
            airrideSettingSoftness = tonumber(cmd[2])
            triggerServerEvent("setVehicleAirRideSoftness", currentVehicle, airrideSettingSoftness, getElementsByType("player", getRootElement(), true))
          end
        end
      elseif cmd[1] == "airridebias" then
        if not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness then
          if cmd[2] == "up" then
            if -4 < airrideBias then
              airrideSettingBias = airrideBias - 1
              triggerServerEvent("setVehicleAirRideBias", currentVehicle, airrideSettingBias, getElementsByType("player", getRootElement(), true))
            end
          elseif cmd[2] == "down" then
            if airrideBias < 4 then
              airrideSettingBias = airrideBias + 1
              triggerServerEvent("setVehicleAirRideBias", currentVehicle, airrideSettingBias, getElementsByType("player", getRootElement(), true))
            end
          elseif tonumber(cmd[2]) and tonumber(cmd[2]) >= -4 and tonumber(cmd[2]) <= 4 then
            airrideSettingBias = tonumber(cmd[2])
            triggerServerEvent("setVehicleAirRideBias", currentVehicle, airrideSettingBias, getElementsByType("player", getRootElement(), true))
          end
        end
      elseif cmd[1] == "airride" then
        if not airrideSettingLevel and not airrideSettingBias and not airrideSettingSoftness then
          if cmd[2] == "up" then
            if -7 < airrideLevel then
              airrideSettingLevel = airrideLevel - 1
              triggerServerEvent("setVehicleAirRideLevel", currentVehicle, airrideSettingLevel, getElementsByType("player", getRootElement(), true))
            end
          elseif cmd[2] == "down" then
            if airrideLevel < 7 then
              airrideSettingLevel = airrideLevel + 1
              triggerServerEvent("setVehicleAirRideLevel", currentVehicle, airrideSettingLevel, getElementsByType("player", getRootElement(), true))
            end
          elseif tonumber(cmd[2]) and 1 <= tonumber(cmd[2]) and tonumber(cmd[2]) <= 15 then
            airrideSettingLevel = tonumber(cmd[2]) - 8
            triggerServerEvent("setVehicleAirRideLevel", currentVehicle, airrideSettingLevel, getElementsByType("player", getRootElement(), true))
          end
        end
      elseif cmd[1] == "menu" then
        if cmd[2] == "ecu" then
          if not ecuBalanceValue then
            seexports.seal_gui:showInfobox("e", "A menüpont használatához Állítható Venom ECU-ra van szükséged!")
            return
          end
        elseif cmd[2] == "airride" then
          if not airrideLevel then
            seexports.seal_gui:showInfobox("e", "A menüpont használatához AirRide szettre van szükséged!")
            return
          end
        elseif cmd[2] == "awd" and not currentDriveType then
          seexports.seal_gui:showInfobox("e", "A menüpont használatához állítható AWD meghajtásra van szükséged!")
          return
        end
        setElementData(currentVehicle, "vehradio.menu", cmd[2])
      elseif cmd[1] == "disableSystemAudio" then
        setElementData(currentVehicle, "vehradio.sysAudio", not disableSystemAudio)
      elseif cmd[1] == "plusBrightness" then
        if radioBrightness < 10 then
          radioBrightness = radioBrightness + 1
          setElementData(currentVehicle, "vehradio.brightness", radioBrightness)
        end
      elseif cmd[1] == "minusBrightness" then
        if 1 < radioBrightness then
          radioBrightness = radioBrightness - 1
          setElementData(currentVehicle, "vehradio.brightness", radioBrightness)
        end
      elseif cmd[1] == "nextWallpaper" then
        radioWallpaper = radioWallpaper + 1
        if 39 < radioWallpaper then
          radioWallpaper = 0
        end
        setElementData(currentVehicle, "vehradio.wallpaper", radioWallpaper)
      elseif cmd[1] == "prevWallpaper" then
        radioWallpaper = radioWallpaper - 1
        if radioWallpaper < 0 then
          radioWallpaper = 39
        end
        setElementData(currentVehicle, "vehradio.wallpaper", radioWallpaper)
      elseif cmd[1] == "radiolist" then
        if not currentRadioChange and getTickCount() - lastChange > 250 then
          local id = (tonumber(cmd[2]) or 0) + radioListScroll
          if id ~= currentRadio and stationList[id] then
            lastChange = getTickCount()
            currentRadio = id
            setElementData(currentVehicle, "vehradio.station", currentRadio)
          end
        end
      elseif cmd[1] == "fav" then
        local id = tonumber(cmd[2]) or 1
        if button == "right" then
          radioFavorites[id] = false
          setElementData(currentVehicle, "vehradio.favorites", radioFavorites)
        else
          favoriteSetTimer = setTimer(setFavorite, 1000, 1)
        end
      elseif cmd[1] == "volPlus" or cmd[1] == "volMinus" then
        setVolumeButton(cmd[1])
        if isTimer(volumeTimer) then
          killTimer(volumeTimer)
        end
        volumeTimer = setTimer(setVolumeButton, 300, 0, cmd[1])
      elseif cmd[1] == "volume" then
        volumeSet = true
      elseif cmd[1] == "startstop" then
        radioState = not radioState
        setElementData(currentVehicle, "vehradio.state", radioState)
      elseif cmd[1] == "toggle" then
        if currentMenu == "off" then
          setElementData(currentVehicle, "vehradio.menu", "home")
        else
          setElementData(currentVehicle, "vehradio.menu", "off")
        end
      elseif cmd[1] == "next" then
        if not currentRadioChange and getTickCount() - lastChange > 250 then
          lastChange = getTickCount()
          currentRadio = currentRadio + 1
          if currentRadio > #stationList then
            currentRadio = 1
          end
          setElementData(currentVehicle, "vehradio.station", currentRadio)
        end
      elseif cmd[1] == "prev" and not currentRadioChange and getTickCount() - lastChange > 250 then
        lastChange = getTickCount()
        currentRadio = currentRadio - 1
        if currentRadio < 1 then
          currentRadio = #stationList
        end
        setElementData(currentVehicle, "vehradio.station", currentRadio)
      end
    elseif cx >= radioX and cy >= radioY and cx <= radioX + sizeX and cy <= radioY + sizeY and (cx <= radioX + 57 or cy <= radioY + 19 or cx >= radioX + 57 + 538 or cy >= radioY + 19 + 293) then
      radioMove = {
        cx,
        cy,
        radioX,
        radioY
      }
    end
  end
end
function setCurrentStation(id)
  if currentMenu == "radio" then
    currentRadioChange = getTickCount()
  end
  lastStationName = stationName
  lastStationWidth = stationWidth
  stationName = stationList[id][2] or ""
  if fonts["24/BebasNeueLight.otf"] then
    stationWidth = dxGetTextWidth(stationName, fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"])
  else
    stationWidth = 0
  end
  if isElement(vehicleSounds[currentVehicle]) then
    destroyElement(vehicleSounds[currentVehicle])
  end
  if radioState then
    vehicleSounds[currentVehicle] = playSound(stationList[id][1])
    setStreamerModeVolume(vehicleSounds[currentVehicle], radioVolume)
    if radioCrashed then
      setSoundEffectEnabled(vehicleSounds[currentVehicle], "distortion", true)
    end
  else
    vehicleSounds[currentVehicle] = false
  end
end
local lastWheel = 0
function keyRadio(key, por)
  if getTickCount() - lastWheel > 250 and getPedOccupiedVehicleSeat(localPlayer) <= 1 and (key == "mouse_wheel_up" or key == "mouse_wheel_down") then
    if getElementData(localPlayer, "cuffed") then
      return
    end
    local on = getCachedData(currentVehicle, "vehradio.menu") or "off"
    if on == "off" then
      return
    end
    if currentHover == "volume" then
      if key == "mouse_wheel_up" then
        setVolumeButton("volPlus")
        lastWheel = getTickCount()
      elseif key == "mouse_wheel_down" then
        setVolumeButton("volMinus")
        lastWheel = getTickCount()
      end
    elseif currentHover and utf8.find(currentHover, "radiolist") then
      if key == "mouse_wheel_up" then
        if 0 < radioListScroll then
          radioListScroll = radioListScroll - 1
        end
      elseif key == "mouse_wheel_down" and radioListScroll < #stationList - 6 then
        radioListScroll = radioListScroll + 1
      end
    elseif key == "mouse_wheel_down" then
      if not currentRadioChange then
        currentRadio = currentRadio + 1
        if currentRadio > #stationList then
          currentRadio = 1
        end
        setElementData(currentVehicle, "vehradio.station", currentRadio)
        lastWheel = getTickCount()
      end
    elseif key == "mouse_wheel_up" and not currentRadioChange then
      currentRadio = currentRadio - 1
      if currentRadio < 1 then
        currentRadio = #stationList
      end
      setElementData(currentVehicle, "vehradio.station", currentRadio)
      lastWheel = getTickCount()
    end
  end
end
function setCurrentSong(text)
  currentSongChange = getTickCount()
  if utf8.len(text) > 50 then
    text = utf8.sub(text, 1, 50) .. "..."
  end
  lastCurrentSong = currentSong
  lastCurrentWidth = currentWidth
  currentSong = text
  currentWidth = dxGetTextWidth(currentSong, fontScales["11/Ubuntu-LI.ttf"], fonts["11/Ubuntu-LI.ttf"])
end
function toggleRadio()
  radioOpened = not radioOpened
  if radioOpened then
    if not currentVehicle then
      radioOpened = false
    else
      addEventHandler("onClientRender", getRootElement(), renderRadio)
      addEventHandler("onClientClick", getRootElement(), clickRadio)
      addEventHandler("onClientKey", getRootElement(), keyRadio)
      fonts["24/BebasNeueLight.otf"] = seexports.seal_gui:getFont("24/BebasNeueLight.otf")
      fontScales["24/BebasNeueLight.otf"] = seexports.seal_gui:getFontScale("24/BebasNeueLight.otf")
      fontHeights["24/BebasNeueLight.otf"] = seexports.seal_gui:getFontHeight("24/BebasNeueLight.otf")
      fonts["22/BebasNeueBold.otf"] = seexports.seal_gui:getFont("22/BebasNeueBold.otf")
      fontScales["22/BebasNeueBold.otf"] = seexports.seal_gui:getFontScale("22/BebasNeueBold.otf")
      fontHeights["22/BebasNeueBold.otf"] = seexports.seal_gui:getFontHeight("22/BebasNeueBold.otf")
      fonts["18/BebasNeueBold.otf"] = seexports.seal_gui:getFont("18/BebasNeueBold.otf")
      fontScales["18/BebasNeueBold.otf"] = seexports.seal_gui:getFontScale("18/BebasNeueBold.otf")
      fontHeights["18/BebasNeueBold.otf"] = seexports.seal_gui:getFontHeight("18/BebasNeueBold.otf")
      fonts["15/BebasNeueBold.otf"] = seexports.seal_gui:getFont("15/BebasNeueBold.otf")
      fontScales["15/BebasNeueBold.otf"] = seexports.seal_gui:getFontScale("15/BebasNeueBold.otf")
      fontHeights["15/BebasNeueBold.otf"] = seexports.seal_gui:getFontHeight("15/BebasNeueBold.otf")
      fonts["11/Ubuntu-L.ttf"] = seexports.seal_gui:getFont("11/Ubuntu-L.ttf")
      fontScales["11/Ubuntu-L.ttf"] = seexports.seal_gui:getFontScale("11/Ubuntu-L.ttf")
      fontHeights["11/Ubuntu-L.ttf"] = seexports.seal_gui:getFontHeight("11/Ubuntu-L.ttf")
      fonts["11/Ubuntu-R.ttf"] = seexports.seal_gui:getFont("11/Ubuntu-R.ttf")
      fontScales["11/Ubuntu-R.ttf"] = seexports.seal_gui:getFontScale("11/Ubuntu-R.ttf")
      fontHeights["11/Ubuntu-R.ttf"] = seexports.seal_gui:getFontHeight("11/Ubuntu-R.ttf")
      fonts["11/Ubuntu-LI.ttf"] = seexports.seal_gui:getFont("11/Ubuntu-LI.ttf")
      fontScales["11/Ubuntu-LI.ttf"] = seexports.seal_gui:getFontScale("11/Ubuntu-LI.ttf")
      fontHeights["11/Ubuntu-LI.ttf"] = seexports.seal_gui:getFontHeight("11/Ubuntu-LI.ttf")
      fonts["11/Ubuntu-B.ttf"] = seexports.seal_gui:getFont("11/Ubuntu-B.ttf")
      fontScales["11/Ubuntu-B.ttf"] = seexports.seal_gui:getFontScale("11/Ubuntu-B.ttf")
      fontHeights["11/Ubuntu-B.ttf"] = seexports.seal_gui:getFontHeight("11/Ubuntu-B.ttf")
      if isElement(finalRt) then
        destroyElement(finalRt)
      end
      if isElement(baseRt) then
        destroyElement(baseRt)
      end
      if isElement(baseShader) then
        destroyElement(baseShader)
      end
      if isElement(playerRt) then
        destroyElement(playerRt)
      end
      if isElement(playerShader) then
        destroyElement(playerShader)
      end
      playerRt = dxCreateRenderTarget(41, 43, true)
      playerShader = dxCreateShader(blankShader)
      dxSetShaderValue(playerShader, "texture0", playerRt)
      baseShader = dxCreateShader(blankShader)
      dxSetShaderValue(baseShader, "texture0", baseRt)
      radioFavorites = getCachedData(currentVehicle, "vehradio.favorites") or {}
      radioVolume = getCachedData(currentVehicle, "vehradio.volume") or 1
      currentRadio = getCachedData(currentVehicle, "vehradio.station") or 1
      radioCrashed = getCachedData(currentVehicle, "vehradio.broken")
      stationName = stationList[currentRadio][2]
      stationWidth = dxGetTextWidth(stationName, fontScales["24/BebasNeueLight.otf"], fonts["24/BebasNeueLight.otf"])
      currentMenu = getCachedData(currentVehicle, "vehradio.menu") or "off"
      radioWallpaper = getCachedData(currentVehicle, "vehradio.wallpaper") or 0
      radioBrightness = getCachedData(currentVehicle, "vehradio.brightness") or 6
      disableSystemAudio = getCachedData(currentVehicle, "vehradio.sysAudio")
      fuelLiters = getCachedData(currentVehicle, "vehicle.fuel") or 70
      oilLevel = getCachedData(currentVehicle, "lastOilChange") or 70
      if currentMenu == "home" and 1 > (getTickCount() - radioOn) / 2500 then
        currentMenu = "on"
      end
      local model = getElementModel(currentVehicle)
      fuelMaxLiters = seexports.seal_vehiclepanel:getTheFuelTankSizeOfVehicle(model)
      fuelConsumption = seexports.seal_vehiclepanel:getTheConsumptionOfVehicle(model)
    end
  else
    seexports.seal_gui:setCursorType("normal")
    seexports.seal_gui:showTooltip(false)
    removeEventHandler("onClientRender", getRootElement(), renderRadio)
    removeEventHandler("onClientClick", getRootElement(), clickRadio)
    removeEventHandler("onClientKey", getRootElement(), keyRadio)
    if isElement(finalRt) then
      destroyElement(finalRt)
    end
    finalRt = false
    if isElement(baseRt) then
      destroyElement(baseRt)
    end
    baseRt = false
    if isElement(baseShader) then
      destroyElement(baseShader)
    end
    baseShader = false
    if isElement(playerRt) then
      destroyElement(playerRt)
    end
    playerRt = false
    if isElement(playerShader) then
      destroyElement(playerShader)
    end
    playerShader = false
  end
end
bindKey("r", "down", toggleRadio)
local radioWidgetState = false
local widgetPos = {}
local widgetSize = {}
local radioAlpha = 0
local songTitleWidgetTmp = false
local radioWidgetTmp = false
local lastRadio = 0
local lastTickWidget = 0
local widgetSide = false
function renderRadioWidget()
  local radioName = "Kikapcsolva"
  local streamTitle = "Kikapcsolva"
  if currentVehicle and radioState and currentRadio then
    streamTitle = "N/A"
    if isElement(vehicleSounds[currentVehicle]) then
      local metaTags = getSoundMetaTags(vehicleSounds[currentVehicle])
      if metaTags and metaTags.stream_title then
        streamTitle = metaTags.stream_title
        if utf8.len(streamTitle) > 60 then
          streamTitle = utf8.sub(streamTitle, 1, 60) .. "..."
        end
      end
    end
    radioName = stationList[currentRadio][2]
  end
  local now = getTickCount()
  local delta = now - lastTickWidget
  lastTickWidget = now
  if songTitleWidgetTmp ~= streamTitle or radioWidgetTmp ~= radioName then
    songTitleWidgetTmp = streamTitle
    radioWidgetTmp = radioName
    lastRadio = now
  end
  if now - lastRadio < 5000 then
    if radioAlpha < 1 then
      radioAlpha = radioAlpha + 4 * delta / 1000
      if 1 < radioAlpha then
        radioAlpha = 1
      end
    end
  elseif 0 < radioAlpha then
    radioAlpha = radioAlpha - 1 * delta / 1000
  end
  if 0 < radioAlpha then
    local x, y = unpack(widgetPos)
    local sx, sy = unpack(widgetSize)
    local is = sy / 2
    local fs = sy / 96
    if widgetSide then
      dxDrawImage(x + sx - is, y, is, is, ":seal_gui/" .. radioIcon .. (faTicks[radioIcon] or ""), 0, 0, 0, tocolor(hw[1], hw[2], hw[3], 180 * radioAlpha))
      dxDrawImage(x + sx - is, y + is, is, is, ":seal_gui/" .. songIcon .. (faTicks[songIcon] or ""), 0, 0, 0, tocolor(hw[1], hw[2], hw[3], 220 * radioAlpha))
      dxDrawText(radioWidgetTmp, x, y, x + sx - is * 1.1, y + is, tocolor(hw[1], hw[2], hw[3], 180 * radioAlpha), 1 * fs * fontScales["16/Ubuntu-R.ttf"], fonts["16/Ubuntu-R.ttf"], "right", "center", true)
      if dxGetTextWidth(streamTitle, 1 * fs * fontScales["18/Ubuntu-B.ttf"] * 0.9, fonts["18/Ubuntu-B.ttf"]) > sx - is * 1.1 then
        dxDrawText(streamTitle, x, y + is, x + sx - is * 1.1, y + is * 2, tocolor(hw[1], hw[2], hw[3], 220 * radioAlpha), 1 * fs * fontScales["18/Ubuntu-B.ttf"] * 0.9, fonts["18/Ubuntu-B.ttf"], "left", "center", true)
      else
        dxDrawText(streamTitle, x, y + is, x + sx - is * 1.1, y + is * 2, tocolor(hw[1], hw[2], hw[3], 220 * radioAlpha), 1 * fs * fontScales["18/Ubuntu-B.ttf"] * 0.9, fonts["18/Ubuntu-B.ttf"], "right", "center", true)
      end
    else
      dxDrawImage(x, y, is, is, ":seal_gui/" .. radioIcon .. (faTicks[radioIcon] or ""), 0, 0, 0, tocolor(hw[1], hw[2], hw[3], 180 * radioAlpha))
      dxDrawImage(x, y + is, is, is, ":seal_gui/" .. songIcon .. (faTicks[songIcon] or ""), 0, 0, 0, tocolor(hw[1], hw[2], hw[3], 220 * radioAlpha))
      dxDrawText(radioWidgetTmp, x + is * 1.1, y, x + sx, y + is, tocolor(hw[1], hw[2], hw[3], 180 * radioAlpha), 1 * fs * fontScales["16/Ubuntu-R.ttf"], fonts["16/Ubuntu-R.ttf"], "left", "center", true)
      dxDrawText(streamTitle, x + is * 1.1, y + is, x + sx, y + is * 2, tocolor(hw[1], hw[2], hw[3], 220 * radioAlpha), 1 * fs * fontScales["18/Ubuntu-B.ttf"] * 0.9, fonts["18/Ubuntu-B.ttf"], "left", "center", true)
    end
  end
end
function checkInsideVehicle()
  local veh = getPedOccupiedVehicle(localPlayer)
  if veh ~= currentVehicle then
    if isElement(veh) then
      vehicleEnter(veh)
    else
      onPlayerVehicleExit()
    end
  end
end