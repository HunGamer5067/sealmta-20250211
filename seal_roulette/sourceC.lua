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
local processseelangStaticImage = {}
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
seelangStaticImageToc[36] = true
seelangStaticImageToc[37] = true
seelangStaticImageToc[38] = true
seelangStaticImageToc[39] = true
seelangStaticImageToc[40] = true
seelangStaticImageToc[41] = true
seelangStaticImageToc[42] = true
seelangStaticImageToc[43] = true
seelangStaticImageToc[44] = true
seelangStaticImageToc[45] = true
seelangStaticImageToc[46] = true
seelangStaticImageToc[47] = true
seelangStaticImageToc[48] = true
seelangStaticImageToc[49] = true
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
  if seelangStaticImageUsed[36] then
    seelangStaticImageUsed[36] = false
    seelangStaticImageDel[36] = false
  elseif seelangStaticImage[36] then
    if seelangStaticImageDel[36] then
      if now >= seelangStaticImageDel[36] then
        if isElement(seelangStaticImage[36]) then
          destroyElement(seelangStaticImage[36])
        end
        seelangStaticImage[36] = nil
        seelangStaticImageDel[36] = false
        seelangStaticImageToc[36] = true
        return
      end
    else
      seelangStaticImageDel[36] = now + 5000
    end
  else
    seelangStaticImageToc[36] = true
  end
  if seelangStaticImageUsed[37] then
    seelangStaticImageUsed[37] = false
    seelangStaticImageDel[37] = false
  elseif seelangStaticImage[37] then
    if seelangStaticImageDel[37] then
      if now >= seelangStaticImageDel[37] then
        if isElement(seelangStaticImage[37]) then
          destroyElement(seelangStaticImage[37])
        end
        seelangStaticImage[37] = nil
        seelangStaticImageDel[37] = false
        seelangStaticImageToc[37] = true
        return
      end
    else
      seelangStaticImageDel[37] = now + 5000
    end
  else
    seelangStaticImageToc[37] = true
  end
  if seelangStaticImageUsed[38] then
    seelangStaticImageUsed[38] = false
    seelangStaticImageDel[38] = false
  elseif seelangStaticImage[38] then
    if seelangStaticImageDel[38] then
      if now >= seelangStaticImageDel[38] then
        if isElement(seelangStaticImage[38]) then
          destroyElement(seelangStaticImage[38])
        end
        seelangStaticImage[38] = nil
        seelangStaticImageDel[38] = false
        seelangStaticImageToc[38] = true
        return
      end
    else
      seelangStaticImageDel[38] = now + 5000
    end
  else
    seelangStaticImageToc[38] = true
  end
  if seelangStaticImageUsed[39] then
    seelangStaticImageUsed[39] = false
    seelangStaticImageDel[39] = false
  elseif seelangStaticImage[39] then
    if seelangStaticImageDel[39] then
      if now >= seelangStaticImageDel[39] then
        if isElement(seelangStaticImage[39]) then
          destroyElement(seelangStaticImage[39])
        end
        seelangStaticImage[39] = nil
        seelangStaticImageDel[39] = false
        seelangStaticImageToc[39] = true
        return
      end
    else
      seelangStaticImageDel[39] = now + 5000
    end
  else
    seelangStaticImageToc[39] = true
  end
  if seelangStaticImageUsed[40] then
    seelangStaticImageUsed[40] = false
    seelangStaticImageDel[40] = false
  elseif seelangStaticImage[40] then
    if seelangStaticImageDel[40] then
      if now >= seelangStaticImageDel[40] then
        if isElement(seelangStaticImage[40]) then
          destroyElement(seelangStaticImage[40])
        end
        seelangStaticImage[40] = nil
        seelangStaticImageDel[40] = false
        seelangStaticImageToc[40] = true
        return
      end
    else
      seelangStaticImageDel[40] = now + 5000
    end
  else
    seelangStaticImageToc[40] = true
  end
  if seelangStaticImageUsed[41] then
    seelangStaticImageUsed[41] = false
    seelangStaticImageDel[41] = false
  elseif seelangStaticImage[41] then
    if seelangStaticImageDel[41] then
      if now >= seelangStaticImageDel[41] then
        if isElement(seelangStaticImage[41]) then
          destroyElement(seelangStaticImage[41])
        end
        seelangStaticImage[41] = nil
        seelangStaticImageDel[41] = false
        seelangStaticImageToc[41] = true
        return
      end
    else
      seelangStaticImageDel[41] = now + 5000
    end
  else
    seelangStaticImageToc[41] = true
  end
  if seelangStaticImageUsed[42] then
    seelangStaticImageUsed[42] = false
    seelangStaticImageDel[42] = false
  elseif seelangStaticImage[42] then
    if seelangStaticImageDel[42] then
      if now >= seelangStaticImageDel[42] then
        if isElement(seelangStaticImage[42]) then
          destroyElement(seelangStaticImage[42])
        end
        seelangStaticImage[42] = nil
        seelangStaticImageDel[42] = false
        seelangStaticImageToc[42] = true
        return
      end
    else
      seelangStaticImageDel[42] = now + 5000
    end
  else
    seelangStaticImageToc[42] = true
  end
  if seelangStaticImageUsed[43] then
    seelangStaticImageUsed[43] = false
    seelangStaticImageDel[43] = false
  elseif seelangStaticImage[43] then
    if seelangStaticImageDel[43] then
      if now >= seelangStaticImageDel[43] then
        if isElement(seelangStaticImage[43]) then
          destroyElement(seelangStaticImage[43])
        end
        seelangStaticImage[43] = nil
        seelangStaticImageDel[43] = false
        seelangStaticImageToc[43] = true
        return
      end
    else
      seelangStaticImageDel[43] = now + 5000
    end
  else
    seelangStaticImageToc[43] = true
  end
  if seelangStaticImageUsed[44] then
    seelangStaticImageUsed[44] = false
    seelangStaticImageDel[44] = false
  elseif seelangStaticImage[44] then
    if seelangStaticImageDel[44] then
      if now >= seelangStaticImageDel[44] then
        if isElement(seelangStaticImage[44]) then
          destroyElement(seelangStaticImage[44])
        end
        seelangStaticImage[44] = nil
        seelangStaticImageDel[44] = false
        seelangStaticImageToc[44] = true
        return
      end
    else
      seelangStaticImageDel[44] = now + 5000
    end
  else
    seelangStaticImageToc[44] = true
  end
  if seelangStaticImageUsed[45] then
    seelangStaticImageUsed[45] = false
    seelangStaticImageDel[45] = false
  elseif seelangStaticImage[45] then
    if seelangStaticImageDel[45] then
      if now >= seelangStaticImageDel[45] then
        if isElement(seelangStaticImage[45]) then
          destroyElement(seelangStaticImage[45])
        end
        seelangStaticImage[45] = nil
        seelangStaticImageDel[45] = false
        seelangStaticImageToc[45] = true
        return
      end
    else
      seelangStaticImageDel[45] = now + 5000
    end
  else
    seelangStaticImageToc[45] = true
  end
  if seelangStaticImageUsed[46] then
    seelangStaticImageUsed[46] = false
    seelangStaticImageDel[46] = false
  elseif seelangStaticImage[46] then
    if seelangStaticImageDel[46] then
      if now >= seelangStaticImageDel[46] then
        if isElement(seelangStaticImage[46]) then
          destroyElement(seelangStaticImage[46])
        end
        seelangStaticImage[46] = nil
        seelangStaticImageDel[46] = false
        seelangStaticImageToc[46] = true
        return
      end
    else
      seelangStaticImageDel[46] = now + 5000
    end
  else
    seelangStaticImageToc[46] = true
  end
  if seelangStaticImageUsed[47] then
    seelangStaticImageUsed[47] = false
    seelangStaticImageDel[47] = false
  elseif seelangStaticImage[47] then
    if seelangStaticImageDel[47] then
      if now >= seelangStaticImageDel[47] then
        if isElement(seelangStaticImage[47]) then
          destroyElement(seelangStaticImage[47])
        end
        seelangStaticImage[47] = nil
        seelangStaticImageDel[47] = false
        seelangStaticImageToc[47] = true
        return
      end
    else
      seelangStaticImageDel[47] = now + 5000
    end
  else
    seelangStaticImageToc[47] = true
  end
  if seelangStaticImageUsed[48] then
    seelangStaticImageUsed[48] = false
    seelangStaticImageDel[48] = false
  elseif seelangStaticImage[48] then
    if seelangStaticImageDel[48] then
      if now >= seelangStaticImageDel[48] then
        if isElement(seelangStaticImage[48]) then
          destroyElement(seelangStaticImage[48])
        end
        seelangStaticImage[48] = nil
        seelangStaticImageDel[48] = false
        seelangStaticImageToc[48] = true
        return
      end
    else
      seelangStaticImageDel[48] = now + 5000
    end
  else
    seelangStaticImageToc[48] = true
  end
  if seelangStaticImageUsed[49] then
    seelangStaticImageUsed[49] = false
    seelangStaticImageDel[49] = false
  elseif seelangStaticImage[49] then
    if seelangStaticImageDel[49] then
      if now >= seelangStaticImageDel[49] then
        if isElement(seelangStaticImage[49]) then
          destroyElement(seelangStaticImage[49])
        end
        seelangStaticImage[49] = nil
        seelangStaticImageDel[49] = false
        seelangStaticImageToc[49] = true
        return
      end
    else
      seelangStaticImageDel[49] = now + 5000
    end
  else
    seelangStaticImageToc[49] = true
  end
  if seelangStaticImageToc[0] and seelangStaticImageToc[1] and seelangStaticImageToc[2] and seelangStaticImageToc[3] and seelangStaticImageToc[4] and seelangStaticImageToc[5] and seelangStaticImageToc[6] and seelangStaticImageToc[7] and seelangStaticImageToc[8] and seelangStaticImageToc[9] and seelangStaticImageToc[10] and seelangStaticImageToc[11] and seelangStaticImageToc[12] and seelangStaticImageToc[13] and seelangStaticImageToc[14] and seelangStaticImageToc[15] and seelangStaticImageToc[16] and seelangStaticImageToc[17] and seelangStaticImageToc[18] and seelangStaticImageToc[19] and seelangStaticImageToc[20] and seelangStaticImageToc[21] and seelangStaticImageToc[22] and seelangStaticImageToc[23] and seelangStaticImageToc[24] and seelangStaticImageToc[25] and seelangStaticImageToc[26] and seelangStaticImageToc[27] and seelangStaticImageToc[28] and seelangStaticImageToc[29] and seelangStaticImageToc[30] and seelangStaticImageToc[31] and seelangStaticImageToc[32] and seelangStaticImageToc[33] and seelangStaticImageToc[34] and seelangStaticImageToc[35] and seelangStaticImageToc[36] and seelangStaticImageToc[37] and seelangStaticImageToc[38] and seelangStaticImageToc[39] and seelangStaticImageToc[40] and seelangStaticImageToc[41] and seelangStaticImageToc[42] and seelangStaticImageToc[43] and seelangStaticImageToc[44] and seelangStaticImageToc[45] and seelangStaticImageToc[46] and seelangStaticImageToc[47] and seelangStaticImageToc[48] and seelangStaticImageToc[49] then
    seelangStatImgHand = false
    removeEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre)
  end
end
processseelangStaticImage[0] = function()
  if not isElement(seelangStaticImage[0]) then
    seelangStaticImageToc[0] = false
    seelangStaticImage[0] = dxCreateTexture("files/bigshad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[1] = function()
  if not isElement(seelangStaticImage[1]) then
    seelangStaticImageToc[1] = false
    seelangStaticImage[1] = dxCreateTexture("files/reel.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[2] = function()
  if not isElement(seelangStaticImage[2]) then
    seelangStaticImageToc[2] = false
    seelangStaticImage[2] = dxCreateTexture("files/reel2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[3] = function()
  if not isElement(seelangStaticImage[3]) then
    seelangStaticImageToc[3] = false
    seelangStaticImage[3] = dxCreateTexture("files/ball.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[4] = function()
  if not isElement(seelangStaticImage[4]) then
    seelangStaticImageToc[4] = false
    seelangStaticImage[4] = dxCreateTexture("files/bshad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[5] = function()
  if not isElement(seelangStaticImage[5]) then
    seelangStaticImageToc[5] = false
    seelangStaticImage[5] = dxCreateTexture("files/reel1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[6] = function()
  if not isElement(seelangStaticImage[6]) then
    seelangStaticImageToc[6] = false
    seelangStaticImage[6] = dxCreateTexture("files/reel3_s.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[7] = function()
  if not isElement(seelangStaticImage[7]) then
    seelangStaticImageToc[7] = false
    seelangStaticImage[7] = dxCreateTexture("files/reel3.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[8] = function()
  if not isElement(seelangStaticImage[8]) then
    seelangStaticImageToc[8] = false
    seelangStaticImage[8] = dxCreateTexture("files/reel4.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[9] = function()
  if not isElement(seelangStaticImage[9]) then
    seelangStaticImageToc[9] = false
    seelangStaticImage[9] = dxCreateTexture("files/reel5.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[10] = function()
  if not isElement(seelangStaticImage[10]) then
    seelangStaticImageToc[10] = false
    seelangStaticImage[10] = dxCreateTexture("files/hlzero.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[11] = function()
  if not isElement(seelangStaticImage[11]) then
    seelangStaticImageToc[11] = false
    seelangStaticImage[11] = dxCreateTexture("files/hl0.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[12] = function()
  if not isElement(seelangStaticImage[12]) then
    seelangStaticImageToc[12] = false
    seelangStaticImage[12] = dxCreateTexture("files/hlvoisins.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[13] = function()
  if not isElement(seelangStaticImage[13]) then
    seelangStaticImageToc[13] = false
    seelangStaticImage[13] = dxCreateTexture("files/hltier.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[14] = function()
  if not isElement(seelangStaticImage[14]) then
    seelangStaticImageToc[14] = false
    seelangStaticImage[14] = dxCreateTexture("files/n0.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[15] = function()
  if not isElement(seelangStaticImage[15]) then
    seelangStaticImageToc[15] = false
    seelangStaticImage[15] = dxCreateTexture("files/n10.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[16] = function()
  if not isElement(seelangStaticImage[16]) then
    seelangStaticImageToc[16] = false
    seelangStaticImage[16] = dxCreateTexture("files/n11.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[17] = function()
  if not isElement(seelangStaticImage[17]) then
    seelangStaticImageToc[17] = false
    seelangStaticImage[17] = dxCreateTexture("files/n23.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[18] = function()
  if not isElement(seelangStaticImage[18]) then
    seelangStaticImageToc[18] = false
    seelangStaticImage[18] = dxCreateTexture("files/n26.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[19] = function()
  if not isElement(seelangStaticImage[19]) then
    seelangStaticImageToc[19] = false
    seelangStaticImage[19] = dxCreateTexture("files/n3.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[20] = function()
  if not isElement(seelangStaticImage[20]) then
    seelangStaticImageToc[20] = false
    seelangStaticImage[20] = dxCreateTexture("files/n30.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[21] = function()
  if not isElement(seelangStaticImage[21]) then
    seelangStaticImageToc[21] = false
    seelangStaticImage[21] = dxCreateTexture("files/n32.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[22] = function()
  if not isElement(seelangStaticImage[22]) then
    seelangStaticImageToc[22] = false
    seelangStaticImage[22] = dxCreateTexture("files/n35.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[23] = function()
  if not isElement(seelangStaticImage[23]) then
    seelangStaticImageToc[23] = false
    seelangStaticImage[23] = dxCreateTexture("files/n5.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[24] = function()
  if not isElement(seelangStaticImage[24]) then
    seelangStaticImageToc[24] = false
    seelangStaticImage[24] = dxCreateTexture("files/n8.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[25] = function()
  if not isElement(seelangStaticImage[25]) then
    seelangStaticImageToc[25] = false
    seelangStaticImage[25] = dxCreateTexture("files/bg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[26] = function()
  if not isElement(seelangStaticImage[26]) then
    seelangStaticImageToc[26] = false
    seelangStaticImage[26] = dxCreateTexture("files/rstrip.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[27] = function()
  if not isElement(seelangStaticImage[27]) then
    seelangStaticImageToc[27] = false
    seelangStaticImage[27] = dxCreateTexture("files/stripglow.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[28] = function()
  if not isElement(seelangStaticImage[28]) then
    seelangStaticImageToc[28] = false
    seelangStaticImage[28] = dxCreateTexture("files/stripfg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[29] = function()
  if not isElement(seelangStaticImage[29]) then
    seelangStaticImageToc[29] = false
    seelangStaticImage[29] = dxCreateTexture("files/table.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[30] = function()
  if not isElement(seelangStaticImage[30]) then
    seelangStaticImageToc[30] = false
    seelangStaticImage[30] = dxCreateTexture("files/coin/glow.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[31] = function()
  if not isElement(seelangStaticImage[31]) then
    seelangStaticImageToc[31] = false
    seelangStaticImage[31] = dxCreateTexture("files/1.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[32] = function()
  if not isElement(seelangStaticImage[32]) then
    seelangStaticImageToc[32] = false
    seelangStaticImage[32] = dxCreateTexture("files/2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[33] = function()
  if not isElement(seelangStaticImage[33]) then
    seelangStaticImageToc[33] = false
    seelangStaticImage[33] = dxCreateTexture("files/0.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[34] = function()
  if not isElement(seelangStaticImage[34]) then
    seelangStaticImageToc[34] = false
    seelangStaticImage[34] = dxCreateTexture("files/liveshad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[35] = function()
  if not isElement(seelangStaticImage[35]) then
    seelangStaticImageToc[35] = false
    seelangStaticImage[35] = dxCreateTexture("files/live.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[36] = function()
  if not isElement(seelangStaticImage[36]) then
    seelangStaticImageToc[36] = false
    seelangStaticImage[36] = dxCreateTexture("files/wave.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[37] = function()
  if not isElement(seelangStaticImage[37]) then
    seelangStaticImageToc[37] = false
    seelangStaticImage[37] = dxCreateTexture("files/winbg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[38] = function()
  if not isElement(seelangStaticImage[38]) then
    seelangStaticImageToc[38] = false
    seelangStaticImage[38] = dxCreateTexture("files/win.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[39] = function()
  if not isElement(seelangStaticImage[39]) then
    seelangStaticImageToc[39] = false
    seelangStaticImage[39] = dxCreateTexture("files/coin/shine.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[40] = function()
  if not isElement(seelangStaticImage[40]) then
    seelangStaticImageToc[40] = false
    seelangStaticImage[40] = dxCreateTexture("files/light.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[41] = function()
  if not isElement(seelangStaticImage[41]) then
    seelangStaticImageToc[41] = false
    seelangStaticImage[41] = dxCreateTexture("files/ledgrad.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[42] = function()
  if not isElement(seelangStaticImage[42]) then
    seelangStaticImageToc[42] = false
    seelangStaticImage[42] = dxCreateTexture("files/ledgrad2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[43] = function()
  if not isElement(seelangStaticImage[43]) then
    seelangStaticImageToc[43] = false
    seelangStaticImage[43] = dxCreateTexture("files/livebg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[44] = function()
  if not isElement(seelangStaticImage[44]) then
    seelangStaticImageToc[44] = false
    seelangStaticImage[44] = dxCreateTexture("files/smlogo.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[45] = function()
  if not isElement(seelangStaticImage[45]) then
    seelangStaticImageToc[45] = false
    seelangStaticImage[45] = dxCreateTexture("files/livecd.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[46] = function()
  if not isElement(seelangStaticImage[46]) then
    seelangStaticImageToc[46] = false
    seelangStaticImage[46] = dxCreateTexture("files/livecd2.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[47] = function()
  if not isElement(seelangStaticImage[47]) then
    seelangStaticImageToc[47] = false
    seelangStaticImage[47] = dxCreateTexture("files/smallbg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[48] = function()
  if not isElement(seelangStaticImage[48]) then
    seelangStaticImageToc[48] = false
    seelangStaticImage[48] = dxCreateTexture("files/smallfg.dds", "argb", true)
  end
  if not seelangStatImgHand then
    seelangStatImgHand = true
    addEventHandler("onClientPreRender", getRootElement(), seelangStatImgPre, true, "high+999999999")
  end
end
processseelangStaticImage[49] = function()
  if not isElement(seelangStaticImage[49]) then
    seelangStaticImageToc[49] = false
    seelangStaticImage[49] = dxCreateTexture("files/win3d.dds", "argb", true)
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
local lightGreyHex = false
local greenHex = false
local redHex = false
local blueHex = false
local helpFont = false
local helpFontScale = false
local cdFont = false
local cdFontScale = false
local numberFont = false
local numberFontScale = false
local sitIcon = false
local sitColor = false
local sitBgColor = false
local faTicks = false
local function seelangGuiRefreshColors()
  local res = getResourceFromName("seal_gui")
  if res and getResourceState(res) == "running" then
    lightGreyHex = seexports.seal_gui:getColorCodeHex("lightgrey")
    greenHex = seexports.seal_gui:getColorCodeHex("green")
    redHex = seexports.seal_gui:getColorCodeHex("red")
    blueHex = seexports.seal_gui:getColorCodeHex("blue")
    helpFont = seexports.seal_gui:getFont("12/BebasNeueRegular.otf")
    helpFontScale = seexports.seal_gui:getFontScale("12/BebasNeueRegular.otf")
    cdFont = seexports.seal_gui:getFont("20/BebasNeueBold.otf")
    cdFontScale = seexports.seal_gui:getFontScale("20/BebasNeueBold.otf")
    numberFont = seexports.seal_gui:getFont("10/BebasNeueRegular.otf")
    numberFontScale = seexports.seal_gui:getFontScale("10/BebasNeueRegular.otf")
    sitIcon = seexports.seal_gui:getFaIconFilename("user", 24)
    sitColor = seexports.seal_gui:getColorCodeToColor("green-second")
    sitBgColor = seexports.seal_gui:getColorCode("grey1")
    faTicks = seexports.seal_gui:getFaTicks()
  end
end
addEventHandler("onGuiRefreshColors", getRootElement(), seelangGuiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangGuiRefreshColors)
addEventHandler("refreshFaTicks", getRootElement(), function()
  faTicks = seexports.seal_gui:getFaTicks()
end)
local seelangModloaderLoaded = function()
  loadModelIds()
end
addEventHandler("modloaderLoaded", getRootElement(), seelangModloaderLoaded)
addEventHandler("onClientResourceStart", getResourceRootElement(), seelangModloaderLoaded)
local screenX, screenY = guiGetScreenSize()
local objectModels = {}
local textureChanger = " texture gTexture; technique hello { pass P0 { Texture[0] = gTexture; } } "
function loadModelIds()
  objectModels = {
    roulette_table = 8620,
    roulette_wheel = 8416,
    roulette_ball = 8418,
    roulette_glass = 8417,
  }

  triggerServerEvent("requestRouletteMachine", localPlayer)
end
rouletteTables = {}
local myTable = false
local mySeat = false
local myLastBets = {}
local myBetPlus = {}
local myWin = 0
local myWinFormatted = "0"
local myBet = 0
local myBetFormatted = "0"
local wheelRot = getRealTime().timestamp % 360
local seatOffsets = {
  {
    -2.68,
    2.52,
    0.2,
    -110
  },
  {
    -3.2,
    0.9115,
    0.2,
    -95
  },
  {
    -3.2,
    -0.91,
    0.2,
    -80
  },
  {
    -2.7,
    -2.54,
    0.2,
    -70
  },

  -- jobb oldaliak

  {
    2.7,
    2.5, -- jobb oldal jobb szélső
    0.2,
    105
  },
  {
    3.2,
    0.95,
    0.2,
    105
  },
  {
    3.2,
    -0.84,
    0.2,
    80
  },
  {
    2.7,
    -2.48,
    0.2,
    70
  },
}
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  if getElementData(localPlayer, "loggedIn") then
   -- triggerServerEvent("requestSSC", localPlayer)
  end
  for i = 1, #rouletteTableCoords do
    local tbl = {}
    tbl.id = i
    tbl.players = {}
    tbl.win = {}
    tbl.betted = {}
    tbl.int = rouletteTableCoords[i][5]
    tbl.dim = rouletteTableCoords[i][6]
    local tx, ty, tz, rz = rouletteTableCoords[i][1], rouletteTableCoords[i][2], rouletteTableCoords[i][3], rouletteTableCoords[i][4]
    tbl.seats = {}
    tbl.rad = math.rad(rz)
    tbl.cos = math.cos(tbl.rad)
    tbl.sin = math.sin(tbl.rad)
    for j = 1, 8 do
      tbl.seats[j] = {
        tx + seatOffsets[j][1] * tbl.cos - seatOffsets[j][2] * tbl.sin,
        ty + seatOffsets[j][1] * tbl.sin + seatOffsets[j][2] * tbl.cos,
        tz + seatOffsets[j][3],
        seatOffsets[j][4] + rz
      }
    end
    tbl.bz = rouletteTableCoords[i][3] + 1.02845
    tbl.rad = math.rad(rouletteTableCoords[i][4])
    tbl.ballRad = 0.435
    tbl.ballRot = 0
    tbl.ballRotBounce = 0
    tbl.ballWrs = 0
    tbl.ballSpeed = 0
    tbl.wheelRandom = i * 21.5
    tbl.lastPos = math.random(0, 36)
    tbl.lastNumber = rouletteWheelNums[tbl.lastPos + 1]
    tbl.lastNumberColor = numberColors[tbl.lastNumber]
    tbl.history = {}
    tbl.canBet = true
    tbl.bets = {}
    for i = 1, 8 do
      tbl.bets[i] = {}
    end
    tbl.betCoins = {}
    for i = 1, 8 do
      tbl.betCoins[i] = {}
    end
    rouletteTables[i] = tbl
  end
  generateHoverRectangles()
end)
local streamedIn = {}
addEvent("streamInRoulette", true)
addEventHandler("streamInRoulette", getRootElement(), function(id, data, spin, slow, bounce, n, cd, history)
  if #streamedIn <= 0 then
    addEventHandler("onClientRender", getRootElement(), renderSeatIcons)
    addEventHandler("onClientClick", getRootElement(), clickSeatIcons)
    addEventHandler("onClientRender", getRootElement(), renderRoulette)
    addEventHandler("onClientPreRender", getRootElement(), preRenderRoulette)
  end
  local tx, ty, tz, rz = rouletteTableCoords[id][1], rouletteTableCoords[id][2], rouletteTableCoords[id][3], rouletteTableCoords[id][4]
  local tbl = rouletteTables[id]
  if not isElement(tbl.obj) then
    tbl.obj = createObject(objectModels.roulette_table, tx, ty, tz, 0, 0, rz)
    setElementInterior(tbl.obj, tbl.int)
    setElementDimension(tbl.obj, tbl.dim)
  end
  if not isElement(tbl.wheel) then
    tbl.wheel = createObject(objectModels.roulette_wheel, tx, ty, tbl.bz - 1, 0, 0, rz)
    setElementInterior(tbl.wheel, tbl.int)
    setElementDimension(tbl.wheel, tbl.dim)
    setElementCollisionsEnabled(tbl.wheel, false)
  end
  if not isElement(tbl.glass) then
    tbl.glass = createObject(objectModels.roulette_glass, tx - 0.01, ty + 0.01, tz - 0.05)
    setElementInterior(tbl.glass, tbl.int)
    setElementDimension(tbl.glass, tbl.dim)
    setElementCollisionsEnabled(tbl.glass, false)
  end
  if not isElement(tbl.ball) then
    tbl.ball = createObject(objectModels.roulette_ball, tx, ty, tz)
    setElementInterior(tbl.ball, tbl.int)
    setElementDimension(tbl.ball, tbl.dim)
    setElementCollisionsEnabled(tbl.ball, false)
  end
  if not isElement(tbl.smallRt) then
    tbl.smallRt = dxCreateRenderTarget(170, 129)
  end
  if not isElement(tbl.smallShader) then
    tbl.smallShader = dxCreateShader(textureChanger)
    dxSetShaderValue(tbl.smallShader, "gTexture", tbl.smallRt)
    engineApplyShaderToWorldTexture(tbl.smallShader, "roulette_screen", tbl.obj)
  end
  if not isElement(tbl.bigRt) then
    tbl.bigRt = dxCreateRenderTarget(342, 256)
  end
  if not isElement(tbl.bigShader) then
    tbl.bigShader = dxCreateShader(textureChanger)
    dxSetShaderValue(tbl.bigShader, "gTexture", tbl.bigRt)
    engineApplyShaderToWorldTexture(tbl.bigShader, "roulette_bigscreen", tbl.obj)
  end
  if not isElement(tbl.ledRt) then
    tbl.ledRt = dxCreateRenderTarget(360, 32)
  end
  if not isElement(tbl.ledShader) then
    tbl.ledShader = dxCreateShader(textureChanger)
    dxSetShaderValue(tbl.ledShader, "gTexture", tbl.ledRt)
    engineApplyShaderToWorldTexture(tbl.ledShader, "roulette_neon", tbl.obj)
  end
  for k, v in pairs(data) do
    tbl[k] = v
  end
  tbl.lastNumberColor = numberColors[tbl.lastNumber]
  for i = 1, math.max(#history, #tbl.history) do
    if history[i] then
      tbl.history[i] = {
        history[i],
        numberColors[history[i]] or 0
      }
    else
      tbl.history[i] = nil
    end
  end
  if bounce then
    bounceTheBallFinal(id, tbl.lastPos, n, bounce)
  elseif slow then
    slowDownBall(id, slow)
  elseif spin then
    spinUpBall(id, spin)
  end
  if cd then
    tbl.countdown = getTickCount() - cd
    tbl.countdownTime = false
  end
  for seat = 1, 8 do
    for bet, val in pairs(tbl.bets[seat]) do
      processBetCoin(tbl, seat, bet, val)
    end
    if isElement(tbl.players[seat]) then
      attachElements(tbl.players[seat], tbl.obj, seatOffsets[seat][1], seatOffsets[seat][2], seatOffsets[seat][3])
      setPedAnimation(tbl.players[seat], "int_office", "off_sit_idle_loop", -1, true, false, false, false)
    end
  end
  table.insert(streamedIn, id)
end)
addEvent("streamOutRoulettes", true)
addEventHandler("streamOutRoulettes", getRootElement(), function()
  if 0 < #streamedIn then
    for i = 1, #streamedIn do
      local tbl = rouletteTables[streamedIn[i]]
      if isElement(tbl.obj) then
        destroyElement(tbl.obj)
      end
      tbl.obj = nil
      if isElement(tbl.wheel) then
        destroyElement(tbl.wheel)
      end
      tbl.wheel = nil
      if isElement(tbl.glass) then
        destroyElement(tbl.glass)
      end
      tbl.glass = nil
      if isElement(tbl.ball) then
        destroyElement(tbl.ball)
      end
      tbl.ball = nil
      if isElement(tbl.smallRt) then
        destroyElement(tbl.smallRt)
      end
      tbl.smallRt = nil
      if isElement(tbl.smallShader) then
        destroyElement(tbl.smallShader)
      end
      tbl.smallShader = nil
      if isElement(tbl.bigRt) then
        destroyElement(tbl.bigRt)
      end
      tbl.bigRt = nil
      if isElement(tbl.bigShader) then
        destroyElement(tbl.bigShader)
      end
      tbl.bigShader = nil
      if isElement(tbl.ledRt) then
        destroyElement(tbl.ledRt)
      end
      tbl.ledRt = nil
      if isElement(tbl.ledShader) then
        destroyElement(tbl.ledShader)
      end
      tbl.ledShader = nil
      if isTimer(tbl.winLoseSoundTimer) then
        killTimer(tbl.winLoseSoundTimer)
      end
      tbl.winLoseSoundTimer = nil
      if isElement(tbl.spinSound) then
        destroyElement(tbl.spinSound)
      end
      tbl.spinSound = false
      for seat = 1, 8 do
        if isElement(tbl.players[seat]) then
          detachElements(tbl.players[seat], tbl.obj)
          setPedAnimation(tbl.players[seat])
        end
      end
    end
    removeEventHandler("onClientRender", getRootElement(), renderSeatIcons)
    removeEventHandler("onClientClick", getRootElement(), clickSeatIcons)
    removeEventHandler("onClientRender", getRootElement(), renderRoulette)
    removeEventHandler("onClientPreRender", getRootElement(), preRenderRoulette)
  end
  streamedIn = {}
end)
function rDistRad(a, b)
  local a = a - b
  return (a + math.pi) % pif - math.pi
end
function rDist(a, b)
  local a = a - b
  return (a + 180) % 360 - 180
end
function saveDebug(id)
  pixels = dxConvertPixels(dxGetTexturePixels(rouletteTables[id].bigRt), "png")
  local fh = fileCreate(id .. getRealTime().timestamp .. getTickCount() .. ".png")
  fileWrite(fh, pixels)
  fileClose(fh)
end
local knocks = {}
for i = 1, 8 do
  table.insert(knocks, math.rad((i - 0.5) * 45))
end
local titleBarHeight = 0
local bigX, bigY = false, false
local bigWindow = false
local bigPreview = false
local smallWindow = false
local smallX, smallY = false, false
function playTableSound(sound, id)
  local el = false
  if id == myTable then
    el = playSound("files/sound/" .. sound .. ".mp3")
  else
    local tbl = rouletteTables[id]
    el = playSound3D("files/sound/" .. sound .. ".mp3", rouletteTableCoords[id][1], rouletteTableCoords[id][2], rouletteTableCoords[id][3])
    setElementDimension(el, tbl.dim)
    setElementInterior(el, tbl.int)
    setSoundVolume(el, 0.75)
    setSoundMinDistance(el, 1.35)
    setSoundMaxDistance(el, 14)
  end
  return el
end
function playSeatSound(sound, tbl, seat)
  local el = false
  if tbl.id == myTable and seat == mySeat then
    el = playSound("files/sound/" .. sound .. ".mp3")
  else
    local scr = tbl.screenCoord[seat]
    local x, y, z = scr[1], scr[2], scr[3]
    el = playSound3D("files/sound/" .. sound .. ".mp3", x, y, z)
    setElementDimension(el, tbl.dim)
    setElementInterior(el, tbl.int)
    setSoundVolume(el, 0.75)
    setSoundMinDistance(el, 1.35)
    setSoundMaxDistance(el, 14)
  end
  return el
end
function playBallSound(tbl, text, loop, notAttach)
  if isElement(tbl.ball) then
    local x, y, z = getElementPosition(tbl.ball)
    local sound = playSound3D("files/sound/" .. text .. ".mp3", x, y, z, loop)
    setElementInterior(sound, tbl.int)
    setElementDimension(sound, tbl.dim)
    if not notAttach then
      attachElements(sound, tbl.ball)
    end
    return sound
  end
  return false
end
function bounceTheBall(id, lp, n, win, bet)
  local tbl = rouletteTables[id]
  tbl.bounceNextLP = lp
  tbl.bounceNextN = n
  for i = 1, 8 do
    tbl.win[i] = win[i]
    tbl.betted[i] = bet[i]
  end
end
local balance = 0
local balanceNew = 0
local balanceText = false
local balanceSpeed = false
function convertBalanceText()
  balanceText = seexports.seal_gui:thousandsStepper(math.floor(balance))
end
addEvent("refreshSSC", true)
addEventHandler("refreshSSC", getRootElement(), function(amount)
  balanceNew = math.max(0, tonumber(amount) or 0)
  if not myTable or not balanceText then
    balance = balanceNew
    convertBalanceText()
  elseif balance > balanceNew then
    balanceSpeed = math.abs(balance - balanceNew) / 400
  else
    balanceSpeed = math.abs(balance - balanceNew) / 1000
  end
end)
function playWinLoseSound(id)
  if id == myTable and smallWindow then
    createWindow(true)
  end
  local tbl = rouletteTables[id]
  tbl.winLoseSoundTimer = nil
  for j = 1, 8 do
    if tbl.win[j] then
      local maxtime = 3500 + 450 * (tbl.win[j] - 1) + 2000
      for k = 3750, maxtime, 250 do
        setTimer(playSeatSound, k, 1, "wincount", tbl, j)
      end
      for k = 0, tbl.win[j] - 1 do
        setTimer(playSeatSound, 3500 + 450 * k, 1, "sscfade", tbl, j)
      end
    end
  end
end
function bounceTheBallFinal(id, lp, n, delta)
  local tbl = rouletteTables[id]
  if not delta then
    if not tbl.spinSound then
      tbl.spinSound = playBallSound(tbl, "spin", true)
    end
    if tbl.spinSound then
      setSoundSpeed(tbl.spinSound, 0.95)
    end
  end
  delta = delta or 0
  myWin = 0
  myWinFormatted = "0"
  tbl.canBet = false
  tbl.spinUp = false
  tbl.slowDown = false
  tbl.countdown = false
  tbl.countdownTime = false
  tbl.bounces = {}
  tbl.bounceStart = getTickCount() - delta
  tbl.lastPos = lp
  tbl.lastNumber = rouletteWheelNums[lp + 1]
  tbl.lastNumberColor = numberColors[tbl.lastNumber]
  tbl.winnerBets = {}
  for i = 1, #winnerBets[tbl.lastNumber] do
    tbl.winnerBets[winnerBets[tbl.lastNumber][i]] = true
  end
  table.insert(tbl.history, {
    tbl.lastNumber,
    tbl.lastNumberColor or 0
  })
  if #tbl.history > 25 then
    table.remove(tbl.history, 1)
  end
  tbl.ballSpeed = 0
  local wr = math.rad(wheelRot + tbl.wheelRandom) + oneRad * tbl.lastPos
  local d = pif + rDistRad(wr, tbl.ballRot)
  local t = d / (wrSpeedRad + slowSpeed)
  local bt = tbl.ballRot + slowSpeed * t
  local absMinD = false
  local minD = false
  for i = 1, 8 do
    local d = rDistRad(knocks[i], bt)
    local dAbs = math.abs(d)
    if not absMinD or absMinD > dAbs then
      absMinD = dAbs
      minD = d
    end
  end
  t = (d + minD) / (wrSpeedRad + slowSpeed)
  local time = t
  wr = wr - wrSpeedRad * t
  local rad = 0.4175
  local rot = tbl.ballRot + slowSpeed * t
  table.insert(tbl.bounces, {
    tbl.ballRot,
    slowSpeed * t,
    0.435,
    -0.019500000000000017,
    t * 1000,
    true
  })
  local d = 1 + n * 0.8
  local t = 0.45 * math.pow(0.8583690987124464, n)
  local lastSide = 0
  for i = 1, n do
    t = t * 1.15
    d = d / 1.25
    local target = 0
    local side = math.random() < 0.5 and -1 or 1
    if side == lastSide then
      target = wr + side * (1 + math.random()) * d / 2 * oneRad
    else
      target = wr + side * math.random() * d / 2 * oneRad
    end
    lastSide = side
    local newRad = 0.275 + (i % 2 == 1 and -1 or 1) * (0.5 + math.random()) * d / 1.5 * (0.2 / (1 + n))
    table.insert(tbl.bounces, {
      rot,
      rDistRad(target, rot),
      rad,
      newRad - rad,
      t * 1000,
      delta >= time
    })
    time = time + t
    rad = newRad
    rot = target
    wr = wr - wrSpeedRad * t
  end
  t = t * 1.25
  wr = wr - wrSpeedRad * t
  table.insert(tbl.bounces, {
    rot,
    rDistRad(wr, rot),
    rad,
    0.275 - rad,
    t * 1000,
    delta >= time
  })
  time = time + t
  tbl.ended = tbl.bounceStart + time * 1000
  local t = time * 1000 + 1000 - delta
  if 100 < t then
    tbl.winLoseSoundTimer = setTimer(playWinLoseSound, t, 1, id)
  end
end
function slowDownBall(id, delta)
  local tbl = rouletteTables[id]
  if not tbl.spinSound then
    tbl.spinSound = playBallSound(tbl, "spin", true)
  end
  tbl.canBet = false
  tbl.ended = false
  tbl.spinUp = false
  tbl.slowDown = getTickCount() - (delta or 0)
  tbl.countdown = false
  tbl.countdownTime = false
  tbl.ballRad = 0.435
  tbl.ballSpeed = fastSpeed
  myWin = 0
  myWinFormatted = "0"
end
function spinUpBall(id, delta)
  if id == myTable and bigWindow then
    createWindow(false)
  end
  local tbl = rouletteTables[id]
  if not delta then
    playBallSound(tbl, "air", false, true)
  end
  if not tbl.spinSound then
    tbl.spinSound = playBallSound(tbl, "spin", true)
  end
  local wr = wheelRot + tbl.wheelRandom
  tbl.canBet = false
  tbl.ended = false
  tbl.slowDown = false
  tbl.spinUp = getTickCount() - (delta or 0)
  tbl.countdown = false
  tbl.countdownTime = 0
  tbl.ballRad = 0.435
  tbl.ballRot = math.rad(wr) + oneRad * tbl.lastPos
  tbl.ballSpeed = 0
  myWin = 0
  myWinFormatted = "0"
end
addEvent("rouletteSpinUpBall", true)
addEventHandler("rouletteSpinUpBall", getRootElement(), spinUpBall)
addEvent("rouletteSlowDownBall", true)
addEventHandler("rouletteSlowDownBall", getRootElement(), slowDownBall)
addEvent("rouletteBounceTheBall", true)
addEventHandler("rouletteBounceTheBall", getRootElement(), bounceTheBall)
function drawReel(x, y, s, r, br, bd, pos, bNot)
  local rx = x - s / 2
  local ry = y - s / 2
  seelangStaticImageUsed[0] = true
  if seelangStaticImageToc[0] then
    processseelangStaticImage[0]()
  end
  dxDrawImage(rx + s * 0.05 * 0.3826, ry + s * 0.05 * 0.9238, s, s, seelangStaticImage[0], 0, 0, 0, tocolor(0, 0, 0, 125))
  seelangStaticImageUsed[1] = true
  if seelangStaticImageToc[1] then
    processseelangStaticImage[1]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[1], r)
  seelangStaticImageUsed[2] = true
  if seelangStaticImageToc[2] then
    processseelangStaticImage[2]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[2])
  if not bNot then
    local bs = s / 230 * (9.5 + pos * 11)
    local bs2 = bs / 34 * 60
    local bx = x - s * bd * math.cos(br)
    local by = y - s * bd * math.sin(br)
    seelangStaticImageUsed[3] = true
    if seelangStaticImageToc[3] then
      processseelangStaticImage[3]()
    end
    dxDrawImage(bx - bs / 2, by - bs / 2, bs, bs, seelangStaticImage[3], math.deg(br))
    seelangStaticImageUsed[4] = true
    if seelangStaticImageToc[4] then
      processseelangStaticImage[4]()
    end
    dxDrawImage(bx - bs2 / 2, by - bs2 / 2, bs2, bs2, seelangStaticImage[4], 0, 0, 0, tocolor(0, 0, 0))
  end
  seelangStaticImageUsed[5] = true
  if seelangStaticImageToc[5] then
    processseelangStaticImage[5]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[5])
  if not bNot then
    seelangStaticImageUsed[6] = true
    if seelangStaticImageToc[6] then
      processseelangStaticImage[6]()
    end
    dxDrawImage(rx + s * 0.035 * 0.3826, ry + s * 0.035 * 0.9238, s, s, seelangStaticImage[6], r, 0, 0, tocolor(0, 0, 0, 100))
  end
  seelangStaticImageUsed[7] = true
  if seelangStaticImageToc[7] then
    processseelangStaticImage[7]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[7], r)
  seelangStaticImageUsed[8] = true
  if seelangStaticImageToc[8] then
    processseelangStaticImage[8]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[8])
  seelangStaticImageUsed[9] = true
  if seelangStaticImageToc[9] then
    processseelangStaticImage[9]()
  end
  dxDrawImage(rx, ry, s, s, seelangStaticImage[9], r)
end
local zSegments = {
  {0.425858, -0.001797},
  {0.376589, -0.019799},
  {0.30914, -0.040762},
  {0.306024, -0.040762},
  {0.285381, -0.066699},
  {0.264619, -0.066699},
  {0.244739, -0.040762},
  {0.229809, -0.040763},
  {0.037806, 0}
}
for i = 1, #zSegments do
  zSegments[i][2] = zSegments[i][2] + 0.02785
end
function calculateZSegment(p)
  for i = 1, #zSegments do
    if p > zSegments[i][1] then
      local fromP = zSegments[i - 1] and zSegments[i - 1][1] or 0.5
      local from = zSegments[i][2]
      local to = zSegments[math.max(i - 1, 1)][2]
      return from + (to - from) * (p - zSegments[i][1]) / (fromP - zSegments[i][1])
    end
  end
  return -0.02785
end
local restZ = calculateZSegment(0.275)
local spinZ = calculateZSegment(0.435)
local wRad = 0.8
function processBall(id, tbl, rot, rad, bz)
  local x, y, z = rouletteTableCoords[id][1], rouletteTableCoords[id][2], rouletteTableCoords[id][3]
  x = x + wRad * rad * math.cos(-rot + tbl.rad + math.pi)
  y = y + wRad * rad * math.sin(-rot + tbl.rad + math.pi)
  setElementPosition(tbl.ball, x, y, tbl.bz + bz)
end
local hlColor = tocolor(190, 190, 190, 110)
local hover = false
local screenCoords = {
  {
    -1.1564,
    0.54,
    1.0499,
    -0.26745,
    0,
    0.963572,
    0,
    -1,
    0,
    -0.963572,
    0,
    -0.267449
  },
  {
    -0.54,
    1.1564,
    1.0499,
    0,
    0.2674,
    0.9636,
    -1,
    0,
    0,
    0,
    0.963572,
    -0.26745
  },
  {
    0.54,
    1.1564,
    1.0499,
    0,
    0.2674,
    0.9636,
    -1,
    0,
    0,
    0,
    0.963572,
    -0.26745
  },
  {
    1.1564,
    0.54,
    1.0499,
    0.26745,
    0,
    0.963572,
    0,
    1,
    0,
    0.963572,
    0,
    -0.267449
  },
  {
    1.1564,
    -0.54,
    1.0499,
    0.26745,
    0,
    0.963572,
    0,
    1,
    0,
    0.963572,
    0,
    -0.267449
  },
  {
    0.54,
    -1.1564,
    1.0499,
    0,
    -0.2674,
    0.9636,
    1,
    0,
    0,
    0,
    -0.963572,
    -0.26745
  },
  {
    -0.54,
    -1.1564,
    1.0499,
    0,
    -0.2674,
    0.9636,
    1,
    0,
    0,
    0,
    -0.963572,
    -0.26745
  },
  {
    -1.1564,
    -0.54,
    1.0499,
    -0.26745,
    0,
    0.963572,
    0,
    -1,
    0,
    -0.963572,
    0,
    -0.267449
  }
}
local hoverRectangles = {}
local betCoinPlaces = {}
local coinS = 0.007980875
function generateHoverRectangles()
  local w = 43
  local h = 57
  betCoinPlaces[0] = {
    408.5,
    478.5 - h * 1.5
  }
  for i = 0, 11 do
    for j = 1, 3 do
      hoverRectangles[i * 3 + j] = {
        {
          442.5 + w * i,
          478.5 - h * j,
          w,
          h
        }
      }
      betCoinPlaces[i * 3 + j] = {
        442.5 + w * (i + 0.5),
        478.5 - h * (j - 0.5)
      }
    end
  end
  for i = 1, 3 do
    hoverRectangles["col" .. i] = {
      {
        442.5,
        478.5 - h * i,
        516 + w,
        h
      }
    }
    betCoinPlaces["col" .. i] = {
      442.5 + w * 12.5,
      478.5 - h * (i - 0.5)
    }
  end
  for i = 1, 3 do
    hoverRectangles["d" .. i] = {
      {
        442.5 + w * 4 * (i - 1),
        307.5,
        w * 4,
        h * 4
      }
    }
    betCoinPlaces["d" .. i] = {
      442.5 + w * 4 * (i - 1 + 0.5),
      478.5 + h * 0.5
    }
  end
  betCoinPlaces["1half"] = {
    442.5 + w * 2 * 0.5,
    478.5 + h * 1.5
  }
  betCoinPlaces.even = {
    442.5 + w * 2 * 1.5,
    478.5 + h * 1.5
  }
  betCoinPlaces.red = {
    442.5 + w * 2 * 2.5,
    478.5 + h * 1.5
  }
  betCoinPlaces.black = {
    442.5 + w * 2 * 3.5,
    478.5 + h * 1.5
  }
  betCoinPlaces.odd = {
    442.5 + w * 2 * 4.5,
    478.5 + h * 1.5
  }
  betCoinPlaces["2half"] = {
    442.5 + w * 2 * 5.5,
    478.5 + h * 1.5
  }
  hoverRectangles["1half"] = {
    {
      442.5,
      478.5 + h,
      w * 2,
      h
    },
    {
      442.5,
      307.5,
      w * 6,
      h * 3
    }
  }
  hoverRectangles["2half"] = {
    {
      958.5 - w * 2,
      478.5 + h,
      w * 2,
      h
    },
    {
      442.5 + w * 6,
      307.5,
      w * 6,
      h * 3
    }
  }
  hoverRectangles.even = {
    {
      442.5 + w * 2,
      478.5 + h,
      w * 2,
      h
    }
  }
  hoverRectangles.odd = {
    {
      958.5 - w * 4,
      478.5 + h,
      w * 2,
      h
    }
  }
  for i = 1, 36 do
    if i % 2 == 1 then
      table.insert(hoverRectangles.odd, hoverRectangles[i][1])
    else
      table.insert(hoverRectangles.even, hoverRectangles[i][1])
    end
  end
  hoverRectangles.red = {
    {
      442.5 + w * 4,
      478.5 + h,
      w * 2,
      h
    }
  }
  hoverRectangles.black = {
    {
      958.5 - w * 6,
      478.5 + h,
      w * 2,
      h
    }
  }
  for j = 0, 2 do
    for i = 0, 11 do
      local num = 1 + i * 3 + j
      local col = numberColors[num] == 1 and "red" or "black"
      if numberColors[num] == numberColors[num + 3] then
        table.insert(hoverRectangles[col], {
          hoverRectangles[num][1][1],
          hoverRectangles[num][1][2],
          w * 2,
          hoverRectangles[num][1][4]
        })
      elseif numberColors[num] ~= numberColors[num - 3] then
        table.insert(hoverRectangles[col], hoverRectangles[num][1])
      end
    end
  end
  for i = 0, 11 do
    for j = 1, 3 do
      if i == 0 then
        hoverRectangles["splith" .. j + i * 3] = {
          {
            442.5,
            478.5 - h * j,
            w,
            h
          }
        }
        betCoinPlaces["splith" .. j + i * 3] = {
          442.5,
          478.5 - h * (j - 0.5)
        }
      else
        hoverRectangles["splith" .. j + i * 3] = {
          {
            442.5 + w * (i - 1),
            478.5 - h * j,
            w * 2,
            h
          }
        }
        betCoinPlaces["splith" .. j + i * 3] = {
          442.5 + w * i,
          478.5 - h * (j - 0.5)
        }
      end
      if j < 3 then
        hoverRectangles["splitv" .. j + i * 3] = {
          {
            442.5 + w * i,
            478.5 - h * (j + 1),
            w,
            h * 2
          }
        }
        betCoinPlaces["splitv" .. j + i * 3] = {
          442.5 + w * (i + 0.5),
          478.5 - h * j
        }
      end
    end
  end
  for i = 0, 11 do
    hoverRectangles["street" .. i * 3 + 1] = {
      {
        442.5 + i * w,
        307.5,
        w,
        h * 3
      }
    }
    betCoinPlaces["street" .. i * 3 + 1] = {
      442.5 + w * (i + 0.5),
      478.5
    }
  end
  for i = 0, 10 do
    hoverRectangles["doublestreet" .. i * 3 + 1] = {
      {
        442.5 + i * w,
        307.5,
        w * 2,
        h * 3
      }
    }
    betCoinPlaces["doublestreet" .. i * 3 + 1] = {
      442.5 + w * (i + 1),
      478.5
    }
  end
  hoverRectangles.basket = {
    {
      442.5,
      307.5,
      w,
      h * 3
    }
  }
  betCoinPlaces.basket = {442.5, 478.5}
  for i = 1, 2 do
    hoverRectangles["trio" .. i] = {
      {
        442.5,
        478.5 - h * (i + 1),
        w,
        h * 2
      }
    }
    betCoinPlaces["trio" .. i] = {
      442.5,
      478.5 - h * i
    }
  end
  for i = 0, 10 do
    for j = 1, 2 do
      hoverRectangles["corner" .. j + i * 3] = {
        {
          442.5 + w * i,
          478.5 - h * (j + 1),
          w * 2,
          h * 2
        }
      }
      betCoinPlaces["corner" .. j + i * 3] = {
        442.5 + w * (i + 1),
        478.5 - h * j
      }
    end
  end
  for i = 0, 36 do
    local num = rouletteWheelNums[i + 1]
    hoverRectangles["n" .. num] = {}
    if hoverRectangles[num] then
      table.insert(hoverRectangles["n" .. num], hoverRectangles[num][1])
    end
    for j = -1, 1, 2 do
      local k = rouletteWheelNums[(i + j) % 37 + 1]
      if hoverRectangles[k] then
        table.insert(hoverRectangles["n" .. num], hoverRectangles[k][1])
      end
    end
    if 33 <= i then
      table.insert(hoverRectangles["n" .. num], {
        238.5 + 34 * (i - 33),
        153,
        102,
        48
      })
    elseif 27 <= i then
    elseif 25 <= i then
      table.insert(hoverRectangles["n" .. num], {
        374.5 - 34 * (3 + i - 25),
        239,
        102,
        48
      })
    elseif i == 24 then
      table.insert(hoverRectangles["n" .. num], {
        307,
        239,
        125,
        48
      })
    elseif i == 23 then
      table.insert(hoverRectangles["n" .. num], {
        341,
        239,
        148,
        48
      })
    elseif i == 22 then
      table.insert(hoverRectangles["n" .. num], {
        375,
        239,
        171,
        48
      })
    elseif i == 21 then
      table.insert(hoverRectangles["n" .. num], {
        432,
        239,
        148,
        48
      })
    elseif i == 20 then
      table.insert(hoverRectangles["n" .. num], {
        488,
        239,
        126,
        48
      })
    elseif 15 <= i then
      table.insert(hoverRectangles["n" .. num], {
        784.5 - 34 * (3 + i - 15),
        239,
        102,
        48
      })
    elseif i <= 9 then
      table.insert(hoverRectangles["n" .. num], {
        375 + 34 * i,
        153,
        102,
        48
      })
    end
  end
  hoverRectangles.tier = {}
  hoverRectangles.orphelins = {
    {
      375,
      153,
      171,
      135
    }
  }
  hoverRectangles.voisins = {}
  hoverRectangles.zero = {}
  for i = 1, #tierBets do
    for j = 1, #hoverRectangles[tierBets[i]] do
      table.insert(hoverRectangles.tier, hoverRectangles[tierBets[i]][j])
    end
  end
  for i = 1, #orphelinsBets do
    for j = 1, #hoverRectangles[orphelinsBets[i]] do
      table.insert(hoverRectangles.orphelins, hoverRectangles[orphelinsBets[i]][j])
    end
  end
  for i = 1, #voisinsBets do
    for j = 1, #hoverRectangles[voisinsBets[i]] do
      table.insert(hoverRectangles.voisins, hoverRectangles[voisinsBets[i]][j])
    end
  end
  for i = 1, #zeroBets do
    for j = 1, #hoverRectangles[zeroBets[i]] do
      table.insert(hoverRectangles.zero, hoverRectangles[zeroBets[i]][j])
    end
  end
  for i = 1, #rouletteTableCoords do
    local tx, ty, tz = rouletteTableCoords[i][1], rouletteTableCoords[i][2], rouletteTableCoords[i][3]
    local tbl = rouletteTables[i]
    tbl.screenCoord = {}
    tbl.screenBets = {}
    tbl.winCoord = {}
    for j = 1, #screenCoords do
      tbl.screenCoord[j] = {
        tx + screenCoords[j][1] * tbl.cos - screenCoords[j][2] * tbl.sin,
        ty + screenCoords[j][1] * tbl.sin + screenCoords[j][2] * tbl.cos,
        tz + screenCoords[j][3]
      }
      local x, y, z = tx, ty, tz
      x = x + screenCoords[j][1] * tbl.cos - screenCoords[j][2] * tbl.sin
      y = y + screenCoords[j][1] * tbl.sin + screenCoords[j][2] * tbl.cos
      z = z + screenCoords[j][3]
      local nx = x + screenCoords[j][4] * tbl.cos - screenCoords[j][5] * tbl.sin
      local ny = y + screenCoords[j][4] * tbl.sin + screenCoords[j][5] * tbl.cos
      local nz = z + screenCoords[j][6]
      x = x + screenCoords[j][4] * tbl.cos * 0.005 - screenCoords[j][5] * tbl.sin * 0.005
      y = y + screenCoords[j][4] * tbl.sin * 0.005 + screenCoords[j][5] * tbl.cos * 0.005
      z = z + screenCoords[j][6] * 0.005
      tbl.winCoord[j] = {
        x - screenCoords[j][10] * tbl.cos * 0.218904 + screenCoords[j][11] * tbl.sin * 0.218904,
        y - screenCoords[j][10] * tbl.sin * 0.218904 - screenCoords[j][11] * tbl.cos * 0.218904,
        z - screenCoords[j][12] * 0.218904,
        x + screenCoords[j][10] * tbl.cos * 0.218904 - screenCoords[j][11] * tbl.sin * 0.218904,
        y + screenCoords[j][10] * tbl.sin * 0.218904 + screenCoords[j][11] * tbl.cos * 0.218904,
        z + screenCoords[j][12] * 0.218904,
        nx,
        ny,
        nz
      }
    end
  end
end
function processHover(cx, cy)
  if cx < 170 or cy < 154 or 1001.5 < cx then
    return false
  end
  if 307.5 <= cy then
    if cy <= 478.5 then
      if 958.5 <= cx then
        if cx <= 1001.5 then
          if 421.5 <= cy then
            return "col1"
          elseif 364.5 <= cy then
            return "col2"
          else
            return "col3"
          end
        end
      elseif 442.5 <= cx then
        cx = (cx - 442.5) / 43
        cy = (cy - 307.5) / 57
        local px1 = cx % 1 <= 0.2
        local py2 = cy % 1 >= 0.8
        local py1, px2
        if cx <= 11 then
          px2 = cx % 1 >= 0.8
        end
        if 1 <= cy then
          py1 = cy % 1 <= 0.2
        end
        if px1 then
          if py1 then
            if 1 <= cx then
              return "corner" .. math.floor(4 - cy) + math.floor(cx - 1) * 3
            else
              return "trio" .. math.floor(4 - cy)
            end
          elseif py2 then
            if cx <= 1 then
              if cy <= 2 then
                return "trio" .. math.floor(4 - cy - 1)
              else
                return "basket"
              end
            elseif cy <= 2 then
              return "corner" .. math.floor(4 - cy - 1) + math.floor(cx - 1) * 3
            else
              return "doublestreet" .. 1 + math.floor(cx - 1) * 3
            end
          else
            return "splith" .. math.floor(4 - cy) + math.floor(cx) * 3
          end
        elseif px2 then
          if py1 then
            return "corner" .. math.floor(4 - cy) + math.floor(cx) * 3
          elseif py2 then
            if cy <= 2 then
              return "corner" .. math.floor(4 - cy - 1) + math.floor(cx) * 3
            else
              return "doublestreet" .. 1 + math.floor(cx) * 3
            end
          else
            return "splith" .. math.floor(4 - cy) + math.floor(cx + 1) * 3
          end
        elseif py1 then
          return "splitv" .. math.floor(4 - cy) + math.floor(cx) * 3
        elseif py2 then
          if cy <= 2 then
            return "splitv" .. math.floor(4 - cy - 1) + math.floor(cx) * 3
          else
            return "street" .. 1 + math.floor(cx) * 3
          end
        else
          return math.floor(4 - cy) + math.floor(cx) * 3
        end
      elseif 433.4 <= cx then
        cy = (cy - 307.5) / 57
        if cy <= 0.8 then
          return "splith3"
        elseif 2.8 <= cy then
          return "basket"
        elseif cy % 1 <= 0.2 then
          return "trio" .. math.floor(4 - cy)
        elseif cy % 1 >= 0.8 then
          return "trio" .. math.floor(4 - cy - 1)
        else
          return "splith" .. math.floor(4 - cy)
        end
      elseif 400 <= cx then
        return 0
      elseif 374.5 <= cx then
        return 1 >= math.abs(cy - 393) / 85.5 / ((cx - 374.5) / 25.5) and 0 or false
      end
    elseif 442.5 <= cx and cx <= 958.5 then
      if cy <= 489.9 then
        cx = (cx - 442.5) / 43
        if cx % 1 <= 0.2 then
          if cx <= 1 then
            return "basket"
          else
            return "doublestreet" .. 1 + math.floor(cx - 1) * 3
          end
        elseif cx <= 11 and cx % 1 >= 0.8 then
          return "doublestreet" .. 1 + math.floor(cx) * 3
        else
          return "street" .. 1 + math.floor(cx) * 3
        end
      elseif cy <= 535.5 then
        cx = (cx - 442.5) / 172
        return "d" .. math.floor(cx) + 1
      elseif cy <= 592.5 then
        cx = math.floor((cx - 442.5) / 86)
        if cx == 0 then
          return "1half"
        elseif cx == 1 then
          return "even"
        elseif cx == 2 then
          return "red"
        elseif cx == 3 then
          return "black"
        elseif cx == 4 then
          return "odd"
        elseif cx == 5 then
          return "2half"
        end
      end
    end
  elseif 154 <= cy and 170 <= cx then
    if cx <= 238.5 and cy <= 286.5 then
      cx = cx - 238.5
      cy = cy - 220.25
      local r = math.sqrt(cx * cx + cy * cy)
      if r <= 19.5 then
        return "tier"
      elseif r <= 67.5 then
        local r = -math.atan2(cx, cy)
        if r >= piq3 then
          return "n10"
        elseif r >= piq2 then
          return "n23"
        elseif r >= piq then
          return "n8"
        else
          return "n30"
        end
      end
    elseif cx <= 784.5 then
      if cy <= 201 then
        return "n" .. rouletteWheelNums[(math.floor((cx - 238.5) / 34.125) - 5) % 37 + 1]
      elseif cy <= 239.5 then
        if 699 <= cx then
          return "zero"
        elseif 546 <= cx then
          return "voisins"
        elseif 375 <= cx then
          return "orphelins"
        elseif 238.5 <= cx then
          return "tier"
        end
      elseif cy <= 286.5 then
        if 546 <= cx then
          return "n" .. rouletteWheelNums[30 - math.floor((cx - 238.5) / 34.125)]
        elseif 375 <= cx then
          return "n" .. rouletteWheelNums[24 - math.floor((cx - 375) / 57)]
        elseif 238.5 <= cx then
          return "n" .. rouletteWheelNums[28 - math.floor((cx - 238.5) / 34.125)]
        end
      end
    elseif cx <= 854 and cy <= 286.5 then
      cx = cx - 784.5
      cy = cy - 220.25
      local r = math.sqrt(cx * cx + cy * cy)
      if r <= 19.5 then
        return "zero"
      elseif r <= 67.5 then
        local r = math.atan2(cx, cy)
        if r >= pit2 then
          return "n3"
        elseif r >= pit then
          return "n26"
        else
          return "n0"
        end
      end
    end
  end
end
function getBetName(hover)
  if hover == "tier" then
    return "Le Tiers du Cylindre " .. lightGreyHex .. "(6 zsetonos gyorstét 12 számra)"
  elseif hover == "orphelins" then
    return "Orphelins \195\160 Cheval " .. lightGreyHex .. "(5 zsetonos gyorstét 8 számra)"
  elseif hover == "voisins" then
    return "Voisins du Zéro " .. lightGreyHex .. "(9 zsetonos gyorstét 17 számra)"
  elseif hover == "zero" then
    return "Jeu Zéro " .. lightGreyHex .. "(4 zsetonos gyorstét 7 számra)"
  elseif validBets[hover] == "straight" then
    return "Straight up " .. hover
  elseif validBets[hover] == "even" then
    return "Even " .. lightGreyHex .. "(Páros számok)"
  elseif validBets[hover] == "red" then
    return "Red " .. lightGreyHex .. "(Piros számok)"
  elseif validBets[hover] == "black" then
    return "Black " .. lightGreyHex .. "(Fekete számok)"
  elseif validBets[hover] == "odd" then
    return "Odd " .. lightGreyHex .. "(Páratlan számok)"
  elseif validBets[hover] == "basket" then
    return "Basket " .. lightGreyHex .. "(0-tól 3-ig)"
  elseif validBets[hover] then
    local n = validBets[hover][2]
    if validBets[hover][1] == "dozen" then
      if n == 1 then
        return "1. dozen " .. lightGreyHex .. "(1-től 12-ig)"
      elseif n == 2 then
        return "2. dozen " .. lightGreyHex .. "(13-tól 24-ig)"
      elseif n == 3 then
        return "3. dozen " .. lightGreyHex .. "(25-től 36-ig)"
      end
    elseif validBets[hover][1] == "half" then
      if n == 1 then
        return "Low " .. lightGreyHex .. "(1-től 18-ig)"
      elseif n == 2 then
        return "High " .. lightGreyHex .. "(19-től 36-ig)"
      end
    elseif validBets[hover][1] == "col" then
      return n .. ".column " .. lightGreyHex .. "(" .. n .. ", " .. n + 3 .. ", " .. n + 6 .. " ... " .. 33 + n .. "-ig)"
    elseif validBets[hover][1] == "splith" then
      return "Split " .. math.max(0, n - 3) .. "-" .. n
    elseif validBets[hover][1] == "splitv" then
      return "Split " .. n .. "-" .. n + 1
    elseif validBets[hover][1] == "trio" then
      return "Trio 0-" .. n .. "-" .. n + 1
    elseif validBets[hover][1] == "corner" then
      return "Corner " .. n .. "-" .. n + 1 .. "-" .. n + 3 .. "-" .. n + 4
    elseif validBets[hover][1] == "street" then
      return "Street " .. n .. "-" .. n + 2
    elseif validBets[hover][1] == "doublestreet" then
      return "Double Street " .. n .. "-" .. n + 2 .. " & " .. n + 3 .. "-" .. n + 5
    elseif validBets[hover][1] == "n" then
      return "3 zsetonos gyorstét: " .. neighbours[n][1] .. "-" .. n .. "-" .. neighbours[n][3]
    end
  end
end
function formatBetTooltip(tbl, hover)
  local name = getBetName(hover)
  if name then
    if tbl.bets[mySeat][hover] then
      if payoutsForBets[hover] then
        name = name .. "\n#ffffffTét: " .. greenHex .. seexports.seal_gui:thousandsStepper(tbl.bets[mySeat][hover]) .. " SSC\n#ffffffKifizetés: " .. blueHex .. payoutsForBets[hover] .. ":1 " .. lightGreyHex .. "(" .. seexports.seal_gui:thousandsStepper(tbl.bets[mySeat][hover] * (payoutsForBets[hover] + 1)) .. " SSC)"
      else
        name = name .. "\n#ffffffTét: " .. greenHex .. seexports.seal_gui:thousandsStepper(tbl.bets[mySeat][hover]) .. " SSC"
      end
    elseif validBets[hover] and tbl.canBet and (not tbl.countdownTime or tbl.countdownTime > 0) and payoutsForBets[hover] then
      name = name .. "\n#ffffffMinimum tét: " .. greenHex .. minBet .. " SSC\n#ffffffKifizetés: " .. blueHex .. payoutsForBets[hover] .. ":1 " .. lightGreyHex .. "(" .. payoutsForBets[hover] + 1 .. "x)"
    end
    return name
  end
  return hover
end
local cx, cy = false, false
local currentCoin = 1
function drawHover(x, y, hover, hlColor)
  if hover == "zero" then
    seelangStaticImageUsed[10] = true
    if seelangStaticImageToc[10] then
      processseelangStaticImage[10]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[10], 0, 0, 0, hlColor)
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
  elseif hover == "voisins" then
    seelangStaticImageUsed[12] = true
    if seelangStaticImageToc[12] then
      processseelangStaticImage[12]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[12], 0, 0, 0, hlColor)
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
  elseif hover == "tier" then
    seelangStaticImageUsed[13] = true
    if seelangStaticImageToc[13] then
      processseelangStaticImage[13]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[13], 0, 0, 0, hlColor)
  elseif hover == "n0" then
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
    seelangStaticImageUsed[14] = true
    if seelangStaticImageToc[14] then
      processseelangStaticImage[14]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[14], 0, 0, 0, hlColor)
  elseif hover == "n10" then
    seelangStaticImageUsed[15] = true
    if seelangStaticImageToc[15] then
      processseelangStaticImage[15]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[15], 0, 0, 0, hlColor)
  elseif hover == "n11" then
    seelangStaticImageUsed[16] = true
    if seelangStaticImageToc[16] then
      processseelangStaticImage[16]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[16], 0, 0, 0, hlColor)
  elseif hover == "n23" then
    seelangStaticImageUsed[17] = true
    if seelangStaticImageToc[17] then
      processseelangStaticImage[17]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[17], 0, 0, 0, hlColor)
  elseif hover == "n26" then
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
    seelangStaticImageUsed[18] = true
    if seelangStaticImageToc[18] then
      processseelangStaticImage[18]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[18], 0, 0, 0, hlColor)
  elseif hover == "n3" then
    seelangStaticImageUsed[19] = true
    if seelangStaticImageToc[19] then
      processseelangStaticImage[19]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[19], 0, 0, 0, hlColor)
  elseif hover == "n30" then
    seelangStaticImageUsed[20] = true
    if seelangStaticImageToc[20] then
      processseelangStaticImage[20]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[20], 0, 0, 0, hlColor)
  elseif hover == "n32" then
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
    seelangStaticImageUsed[21] = true
    if seelangStaticImageToc[21] then
      processseelangStaticImage[21]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[21], 0, 0, 0, hlColor)
  elseif hover == "n35" then
    seelangStaticImageUsed[22] = true
    if seelangStaticImageToc[22] then
      processseelangStaticImage[22]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[22], 0, 0, 0, hlColor)
  elseif hover == "n5" then
    seelangStaticImageUsed[23] = true
    if seelangStaticImageToc[23] then
      processseelangStaticImage[23]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[23], 0, 0, 0, hlColor)
  elseif hover == "n8" then
    seelangStaticImageUsed[24] = true
    if seelangStaticImageToc[24] then
      processseelangStaticImage[24]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[24], 0, 0, 0, hlColor)
  elseif hover == 0 or hover == "basket" or hover == "trio1" or hover == "trio2" or hover == "splith1" or hover == "splith2" or hover == "splith3" then
    seelangStaticImageUsed[11] = true
    if seelangStaticImageToc[11] then
      processseelangStaticImage[11]()
    end
    dxDrawImage(x, y, 1024, 768, seelangStaticImage[11], 0, 0, 0, hlColor)
  end
  if hoverRectangles[hover] then
    for i = 1, #hoverRectangles[hover] do
      local r = hoverRectangles[hover][i]
      dxDrawRectangle(x + r[1], y + r[2], r[3], r[4], hlColor)
    end
  end
end
function drawTable(x, y)
  local now = getTickCount()
  local tbl = rouletteTables[myTable]
  seelangStaticImageUsed[25] = true
  if seelangStaticImageToc[25] then
    processseelangStaticImage[25]()
  end
  dxDrawImage(x, y, 1024, 768, seelangStaticImage[25])
  if tbl.bounceStart then
    seelangStaticImageUsed[26] = true
    if seelangStaticImageToc[26] then
      processseelangStaticImage[26]()
    end
    dxDrawImageSection(x + 660, y + 72, 364, 44, -208 + (tbl.ballRotBounce - tbl.ballWrs) / math.pi * 814, 0, 364, 44, seelangStaticImage[26])
  elseif tbl.spinUp or tbl.slowDown then
    seelangStaticImageUsed[26] = true
    if seelangStaticImageToc[26] then
      processseelangStaticImage[26]()
    end
    dxDrawImageSection(x + 660, y + 72, 364, 44, -208 + (tbl.ballRot - tbl.ballWrs) / math.pi * 814, 0, 364, 44, seelangStaticImage[26])
  else
    seelangStaticImageUsed[26] = true
    if seelangStaticImageToc[26] then
      processseelangStaticImage[26]()
    end
    dxDrawImageSection(x + 660, y + 72, 364, 44, -208 + tbl.lastPos * 44, 0, 364, 44, seelangStaticImage[26])
  end
  local eDelta = tbl.ended and now - tbl.ended - 1000
  local ep = false
  local ep2 = false
  local rp = false
  local pulse = false
  if tbl.newRound then
    rp = 1 - math.min(1, (now - tbl.newRound) / 1000)
    pulse = now % 1500 / 1500
    if 0.5 < pulse then
      pulse = 1 - pulse
    end
    pulse = getEasingValue(pulse * 2, "OutQuad")
    seelangStaticImageUsed[27] = true
    if seelangStaticImageToc[27] then
      processseelangStaticImage[27]()
    end
    dxDrawImage(x + 858, y + 62, 64, 64, seelangStaticImage[27], 0, 0, 0, tocolor(255, 255, 255, (155 + 100 * pulse) * rp))
  elseif eDelta and 0 < eDelta then
    ep = math.min(1, eDelta / 1000)
    ep2 = math.min(1, eDelta / 3000)
    pulse = now % 1500 / 1500
    if 0.5 < pulse then
      pulse = 1 - pulse
    end
    pulse = getEasingValue(pulse * 2, "OutQuad")
    seelangStaticImageUsed[27] = true
    if seelangStaticImageToc[27] then
      processseelangStaticImage[27]()
    end
    dxDrawImage(x + 858, y + 62, 64, 64, seelangStaticImage[27], 0, 0, 0, tocolor(255, 255, 255, (155 + 100 * pulse) * ep))
  end
  seelangStaticImageUsed[28] = true
  if seelangStaticImageToc[28] then
    processseelangStaticImage[28]()
  end
  dxDrawImage(x, y, 1024, 768, seelangStaticImage[28])
  local tcx, tcy = getCursorPosition()
  local tmp = false
  if tcx and bigWindow then
    tcx = tcx * screenX - x
    tcy = tcy * screenY - y
    if tcx ~= cx or tcy ~= cy then
      cx = tcx
      cy = tcy
      tmp = processHover(cx, cy)
      if tmp ~= hover then
        hover = tmp
        seexports.seal_gui:setCursorType(hover and "link" or "normal")
        seexports.seal_gui:showTooltip(formatBetTooltip(tbl, hover))
      end
    end
  elseif hover then
    hover = false
    seexports.seal_gui:setCursorType("normal")
    seexports.seal_gui:showTooltip()
    tcx, tcy = false, false
  end
  if ep or rp then
    local a = 120 + 85 * pulse
    drawHover(x, y, tbl.lastNumber, tocolor(218, 181, 72, a * (ep or rp)))
  elseif hover then
    drawHover(x, y, hover, hlColor)
  end
  seelangStaticImageUsed[29] = true
  if seelangStaticImageToc[29] then
    processseelangStaticImage[29]()
  end
  dxDrawImage(x, y, 1024, 768, seelangStaticImage[29])
  if eDelta and 0 < eDelta then
    dxDrawText("Játék vége, eredményhirdetés", x + 15, y + 68, 0, y + 120, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "left", "center")
  elseif tbl.spinUp or tbl.slowDown or tbl.bounceStart or tbl.ended then
    dxDrawText("Sok szerencsét!", x + 15, y + 68, 0, y + 120, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "left", "center")
  else
    local w = 0
    local py = 120
    if tbl.countdownTime and 0 < tbl.countdownTime then
      local p = math.max(0, 1 - (now - (tbl.countdown or 0)) / (countdownTime * 1000))
      dxDrawRectangle(x + 7, y + 117, 350, 3, tocolor(180, 180, 180))
      dxDrawRectangle(x + 7, y + 117, 350 * p, 3, tocolor(245, 95, 95))
      py = 117
      w = 56
      dxDrawText(tbl.countdownTime .. "s", x + 15, y + 68, 0, y + py, tocolor(245, 95, 95), cdFontScale * 1.25, cdFont, "left", "center")
    end
    if not tbl.countdownTime or 0 < tbl.countdownTime then
      dxDrawText("Kérem tegyék meg tétjeiket!", x + 15 + w, y + 68, 0, y + py, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "left", "center")
    else
      dxDrawText("Köszönöm, nincs több tét!", x + 15 + w, y + 68, 0, y + py, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "left", "center")
    end
  end
  local excludeBets = false
  if tbl.canBet and (not tbl.countdownTime or 0 < tbl.countdownTime) then
    if hover == "tier" then
      for i = 1, #tierBets do
        local bet = tierBets[i]
        local r = betCoinPlaces[bet]
        if r then
          local s = 14
          local c = 0
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          else
            c = coinValues[math.max(currentCoin, minCoin)]
          end
          if tbl.bets[mySeat][bet] then
            c = processBetCoinEx(tbl.bets[mySeat][bet] + c)
          else
            c = processBetCoinEx(c)
          end
          seelangStaticImageUsed[30] = true
          if seelangStaticImageToc[30] then
            processseelangStaticImage[30]()
          end
          dxDrawImage(x + r[1] - 14, y + r[2] - 14, 28, 28, seelangStaticImage[30])
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. c .. ".dds"))
        end
      end
      excludeBets = tierBetsRev
    elseif hover == "orphelins" then
      for i = 1, #orphelinsBets do
        local bet = orphelinsBets[i]
        local r = betCoinPlaces[bet]
        if r then
          local s = 14
          local c = 0
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          else
            c = coinValues[math.max(currentCoin, minCoin)]
          end
          if tbl.bets[mySeat][bet] then
            c = processBetCoinEx(tbl.bets[mySeat][bet] + c)
          else
            c = processBetCoinEx(c)
          end
          seelangStaticImageUsed[30] = true
          if seelangStaticImageToc[30] then
            processseelangStaticImage[30]()
          end
          dxDrawImage(x + r[1] - 14, y + r[2] - 14, 28, 28, seelangStaticImage[30])
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. c .. ".dds"))
        end
      end
      excludeBets = orphelinsBetsRev
    elseif hover == "voisins" then
      for i = 1, #voisinsBets do
        local bet = voisinsBets[i]
        local r = betCoinPlaces[bet]
        if r then
          local s = 14
          local c = 0
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          elseif bet == "trio2" or bet == "corner25" then
            c = coinValues[math.max(currentCoin, minCoin)] * 2
          else
            c = coinValues[math.max(currentCoin, minCoin)]
          end
          if tbl.bets[mySeat][bet] then
            c = processBetCoinEx(tbl.bets[mySeat][bet] + c)
          else
            c = processBetCoinEx(c)
          end
          seelangStaticImageUsed[30] = true
          if seelangStaticImageToc[30] then
            processseelangStaticImage[30]()
          end
          dxDrawImage(x + r[1] - 14, y + r[2] - 14, 28, 28, seelangStaticImage[30])
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. c .. ".dds"))
        end
      end
      excludeBets = voisinsBetsRev
    elseif hover == "zero" then
      for i = 1, #zeroBets do
        local bet = zeroBets[i]
        local r = betCoinPlaces[bet]
        if r then
          local s = 14
          local c = 0
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          else
            c = coinValues[math.max(currentCoin, minCoin)]
          end
          if tbl.bets[mySeat][bet] then
            c = processBetCoinEx(tbl.bets[mySeat][bet] + c)
          else
            c = processBetCoinEx(c)
          end
          seelangStaticImageUsed[30] = true
          if seelangStaticImageToc[30] then
            processseelangStaticImage[30]()
          end
          dxDrawImage(x + r[1] - 14, y + r[2] - 14, 28, 28, seelangStaticImage[30])
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. c .. ".dds"))
        end
      end
      excludeBets = zeroBetsRev
    elseif hover and type(validBets[hover]) == "table" and validBets[hover][1] == "n" then
      local n = validBets[hover][2]
      for i = 1, 3 do
        local bet = neighbours[n][i]
        local r = betCoinPlaces[bet]
        if r then
          local s = 14
          local c = 0
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          else
            c = coinValues[math.max(currentCoin, minCoin)]
          end
          if tbl.bets[mySeat][bet] then
            c = processBetCoinEx(tbl.bets[mySeat][bet] + c)
          else
            c = processBetCoinEx(c)
          end
          seelangStaticImageUsed[30] = true
          if seelangStaticImageToc[30] then
            processseelangStaticImage[30]()
          end
          dxDrawImage(x + r[1] - 14, y + r[2] - 14, 28, 28, seelangStaticImage[30])
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. c .. ".dds"))
        end
      end
      excludeBets = neighboursEx[n]
    end
  end
  local wt = eDelta and eDelta - 3500
  if ep and 1 <= ep and not rp then
    myWin = 0
  end
  if not rp then
    for bet, value in pairs(tbl.bets[mySeat]) do
      local r = betCoinPlaces[bet]
      if r and (not excludeBets or not excludeBets[bet]) then
        if ep then
          local s = 14
          if tbl.winnerBets[bet] and payoutsForBets[bet] then
            if 1 <= ep then
              local cx, cy, a = interpolateBetween(r[1], r[2], 1, 512, 230, 0, math.min(1, math.max(0, wt / 2000)), "OutQuad")
              myWin = myWin + value * (1 + payoutsForBets[bet]) * (1 - a)
              wt = wt - 450
              seelangStaticImageUsed[30] = true
              if seelangStaticImageToc[30] then
                processseelangStaticImage[30]()
              end
              dxDrawImage(x + cx - s, y + cy - s, s * 2, s * 2, seelangStaticImage[30], 0, 0, 0, tocolor(255, 255, 255, (155 + 100 * pulse) * ep * a))
              dxDrawImage(x + cx - s, y + cy - s, s * 2, s * 2, dynamicImage("files/coin/c" .. tbl.betCoins[mySeat][bet] .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, 255 * a))
            else
              seelangStaticImageUsed[30] = true
              if seelangStaticImageToc[30] then
                processseelangStaticImage[30]()
              end
              dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, seelangStaticImage[30], 0, 0, 0, tocolor(255, 255, 255, (155 + 100 * pulse) * ep))
              dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. tbl.betCoins[mySeat][bet] .. ".dds"), 0, 0, 0, tocolor(255, 255, 255))
            end
          else
            s = s - 3 * ep
            dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. tbl.betCoins[mySeat][bet] .. ".dds"), 0, 0, 0, tocolor(255 - 125 * ep, 255 - 125 * ep, 255 - 125 * ep, 255 - 255 * ep2))
          end
        else
          local s = 14
          if myLastBets[bet] then
            local p = (now - myLastBets[bet]) / 400
            if 1 < p then
              p = 1
              myLastBets[bet] = nil
            end
            if myBetPlus[bet] then
              s = 19 - 5 * getEasingValue(p, "OutQuad")
            else
              s = 14 + 5 * getEasingValue(p, "OutQuad")
            end
          end
          dxDrawImage(x + r[1] - s, y + r[2] - s, s * 2, s * 2, dynamicImage("files/coin/c" .. tbl.betCoins[mySeat][bet] .. ".dds"), 0, 0, 0, tocolor(255, 255, 255, excludeBets and 102 or 255))
        end
      end
    end
  end
  if ep and 1 <= ep and not rp then
    myWin = math.floor(myWin)
    myWinFormatted = seexports.seal_gui:thousandsStepper(myWin)
  end
  local w = 42.083333333333336
  local hx = 7 + x + w / 2 - 12
  local a = 255
  local n = #tbl.history
  if tbl.bounceStart or tbl.ended and now - tbl.ended <= 1000 then
    n = n - 1
  end
  local to = math.max(1, n - 23)
  for i = n, to, -1 do
    if tbl.history[i] then
      local c = tocolor(255, 255, 255, a)
      if tbl.history[i][2] == 1 then
        seelangStaticImageUsed[31] = true
        if seelangStaticImageToc[31] then
          processseelangStaticImage[31]()
        end
        dxDrawImage(hx, y + 21, 24, 24, seelangStaticImage[31], 0, 0, 0, c)
      elseif tbl.history[i][2] == 2 then
        seelangStaticImageUsed[32] = true
        if seelangStaticImageToc[32] then
          processseelangStaticImage[32]()
        end
        dxDrawImage(hx, y + 21, 24, 24, seelangStaticImage[32], 0, 0, 0, c)
      else
        seelangStaticImageUsed[33] = true
        if seelangStaticImageToc[33] then
          processseelangStaticImage[33]()
        end
        dxDrawImage(hx, y + 21, 24, 24, seelangStaticImage[33], 0, 0, 0, c)
      end
      dxDrawText(tbl.history[i][1], hx, y + 21, hx + 24, y + 45, c, numberFontScale, numberFont, "center", "center")
      hx = hx + w
      a = a - 8
    end
  end
  dxDrawText(balanceText, x + 219, y + 725, x + 407, y + 753, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "center", "center")
  dxDrawText(myBetFormatted, x, y + 725, x + 1024, y + 753, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "center", "center")
  dxDrawText(myWinFormatted, x + 617, y + 725, x + 807, y + 753, tocolor(255, 255, 255), cdFontScale * 0.8, cdFont, "center", "center")
  seelangStaticImageUsed[34] = true
  if seelangStaticImageToc[34] then
    processseelangStaticImage[34]()
  end
  dxDrawImage(x + 6, y + 315, 350, 270, seelangStaticImage[34])
  dxDrawImage(x + 21, y + 330, 320, 240, tbl.bigRt)
  seelangStaticImageUsed[35] = true
  if seelangStaticImageToc[35] then
    processseelangStaticImage[35]()
  end
  dxDrawImage(x + 19, y + 328, 324, 244, seelangStaticImage[35])
  if (tbl.newRound or eDelta) and tbl.win[mySeat] then
    local gp = 0
    local p = 0.5
    local tp = 1
    if tbl.newRound then
      gp = rp
      p = now % 2000 / 2000
    elseif eDelta and 0 < eDelta then
      gp = ep
      p = now % 2000 / 2000
      tp = math.min(1, math.max(0, (eDelta - 3500) / 500))
    end
    if 0 < gp then
      seelangStaticImageUsed[36] = true
      if seelangStaticImageToc[36] then
        processseelangStaticImage[36]()
      end
      dxDrawImageSection(x + 7, y + 7, 1010, 754, 0, -756 * p, 1012, 756, seelangStaticImage[36], 0, 0, 0, tocolor(243, 210, 74, 75 * gp))
      seelangStaticImageUsed[37] = true
      if seelangStaticImageToc[37] then
        processseelangStaticImage[37]()
      end
      dxDrawImage(x, y + 146, 1024, 100, seelangStaticImage[37], 0, 0, 0, tocolor(255, 255, 255, 255 * gp))
      seelangStaticImageUsed[38] = true
      if seelangStaticImageToc[38] then
        processseelangStaticImage[38]()
      end
      dxDrawImage(x, y + 107 + 16 * (1 - tp), 1024, 146, seelangStaticImage[38], 0, 0, 0, tocolor(255, 255, 255, 255 * gp))
      if 0 < tp then
        local text2 = myWinFormatted .. " SSC"
        local n = utf8.len(text2)
        local w = 12
        local x = x + 512 + w * n / 2
        for i = 1, n do
          local d = 1 - (i - n * p) % n / n
          if 0.5 < d then
            d = (1 - d) * 2
          else
            d = d * 2
          end
          d = 0.75 + getEasingValue(d, "InQuad") * 0.25
          dxDrawText(utf8.sub(text2, -i, -i), x - w, y + 200, x, y + 246, tocolor(243 * d, 210 * d, 74 * d, 255 * tp), cdFontScale * 0.85, cdFont, "center", "center")
          x = x - w
        end
      end
    end
  elseif tbl.countdownTime and tbl.countdownTime <= 10 and tbl.countdown then
    local delta = now - tbl.countdown
    local a = 1 - delta % 1000 / 1000
    if delta < countdownTime * 1000 then
      seelangStaticImageUsed[36] = true
      if seelangStaticImageToc[36] then
        processseelangStaticImage[36]()
      end
      dxDrawImageSection(x + 7, y + 7, 1010, 754, 0, -378 - 756 * delta / 1000, 1012, 756, seelangStaticImage[36], 0, 0, 0, tocolor(245, 95, 95, 125 * a))
    end
  end
  local cx = x + 512 - 64 * #coinValues / 2
  local cy = y + 632
  for i = 1, #coinValues do
    local curr = i == currentCoin
    local s = curr and 1 or 0.9
    if curr then
      seelangStaticImageUsed[30] = true
      if seelangStaticImageToc[30] then
        processseelangStaticImage[30]()
      end
      dxDrawImage(cx + 64 * (1 - s) / 2, cy + 64 * (1 - s) / 2, 64 * s, 64 * s, seelangStaticImage[30])
    end
    dxDrawImage(cx + 64 * (1 - s) / 2, cy + 64 * (1 - s) / 2, 64 * s, 64 * s, dynamicImage("files/coin/" .. i .. ".dds"))
    dxDrawText(coinValues[i], cx, cy, cx + 64, cy + 60.8, tocolor(0, 0, 0), helpFontScale * s, helpFont, "center", "center")
    seelangStaticImageUsed[39] = true
    if seelangStaticImageToc[39] then
      processseelangStaticImage[39]()
    end
    dxDrawImage(cx + 64 * (1 - s) / 2, cy + 64 * (1 - s) / 2, 64 * s, 64 * s, seelangStaticImage[39], 0, 0, 0, tocolor(255, 255, 255, curr and 255 or 175))
    cx = cx + 64
  end
  seelangStaticImageUsed[40] = true
  if seelangStaticImageToc[40] then
    processseelangStaticImage[40]()
  end
  dxDrawImage(x, y, 1024, 768, seelangStaticImage[40])
end
function preRenderRoulette(delta)
  if balanceSpeed then
    if balance > balanceNew then
      balance = balance - balanceSpeed * delta
      if balance < balanceNew then
        balance = balanceNew
        balanceSpeed = false
      end
      convertBalanceText()
    end
    if balance < balanceNew then
      balance = balance + balanceSpeed * delta
      if balance > balanceNew then
        balance = balanceNew
        balanceSpeed = false
      end
      convertBalanceText()
    end
  end
  local now = getTickCount()
  local pulse = now % 1500 / 1500
  if 0.5 < pulse then
    pulse = 1 - pulse
  end
  pulse = getEasingValue(pulse * 2, "OutQuad")
  wheelRot = (wheelRot - wrSpeed * delta / 1000) % 360
  local px, py, pz = getElementPosition(localPlayer)
  local camx, camy, camz = getCameraMatrix()
  for l = 1, #streamedIn do
    local i = streamedIn[l]
    local tbl = rouletteTables[i]
    local tx, ty, tz = rouletteTableCoords[i][1], rouletteTableCoords[i][2], rouletteTableCoords[i][3]
    tbl.d = getDistanceBetweenPoints3D(tx, ty, tz, camx, camy, camz)
    tbl.onScreen = i == myTable or isElementOnScreen(tbl.obj) and tbl.d < 75 and pz - tz < 5
    local wr = wheelRot + tbl.wheelRandom
    local wrs = math.rad(wr)
    tbl.ballWrs = wrs
    if tbl.spinUp or tbl.slowDown then
      tbl.ballRot = tbl.ballRot + tbl.ballSpeed * delta / 1000
    end
    if tbl.bounceNextLP then
      bounceTheBallFinal(i, tbl.bounceNextLP, tbl.bounceNextN)
      tbl.bounceNextLP = nil
      tbl.bounceNextN = nil
    end
    if tbl.newRound and 1000 < now - tbl.newRound then
      tbl.canBet = true
      tbl.newRound = false
      tbl.countdown = false
      tbl.countdownTime = false
      for i = 1, 8 do
        tbl.bets[i] = {}
        tbl.betCoins[i] = {}
      end
      myLastBets = {}
      if i == myTable then
        myBet = 0
        myBetFormatted = 0
      end
    end
    local rot = 0
    local rad = 0
    local pos = 0
    if tbl.bounceStart then
      local bDelta = now - tbl.bounceStart
      local n = #tbl.bounces
      for i = 1, n do
        local bounce = tbl.bounces[i]
        local t = bounce[5]
        bDelta = bDelta - t
        if bDelta <= 0 then
          local p = (bDelta + t) / t
          if not bounce[6] then
            if tbl.spinSound then
              if isElement(tbl.spinSound) then
                destroyElement(tbl.spinSound)
              end
              tbl.spinSound = false
            end
            playBallSound(tbl, "knock-0" .. math.random(1, 8))
            bounce[6] = true
          end
          if i == n then
            rad = bounce[3] + bounce[4] * p
            p = getEasingValue(p, "OutQuad")
          elseif i == 1 then
            rad = bounce[3] + bounce[4] * getEasingValue(p, "InQuad")
          else
            rad = bounce[3] + bounce[4] * p
          end
          rot = bounce[1] + bounce[2] * p
          break
        end
      end
      if 0 < bDelta then
        rot = tbl.bounces[n][1] + tbl.bounces[n][2]
        rad = tbl.bounces[n][3] + tbl.bounces[n][4]
        tbl.bounceStart = false
        playBallSound(tbl, "end")
      end
      tbl.ballRotBounce = rot
      pos = rad < 0.435 and calculateZSegment(rad) or spinZ
    elseif tbl.slowDown then
      local p = getEasingValue(math.min(1, (now - tbl.slowDown) / 5000), "OutQuad")
      tbl.ballSpeed = slowSpeed + sfSpeed * (1 - p)
      setSoundSpeed(tbl.spinSound, 1.05 - 0.1 * p)
      rot, rad, pos = tbl.ballRot, 0.435, spinZ
    elseif tbl.spinUp then
      local p = getEasingValue(math.min(1, (now - tbl.spinUp) / 5000), "OutQuad")
      tbl.ballSpeed = fastSpeed * p
      local p2 = math.min(1, p * 7)
      rad = 0.275 + 0.16 * p2
      setSoundVolume(tbl.spinSound, p2)
      setSoundSpeed(tbl.spinSound, 0.95 + 0.1 * p)
      pos = rad < 0.435 and calculateZSegment(rad) or spinZ
      rot = tbl.ballRot
    else
      rot, rad, pos = wrs + oneRad * tbl.lastPos, 0.275, restZ
    end
    if tbl.onScreen then
      if tbl.d < 15 then
        setElementRotation(tbl.wheel, 0, 0, -wr + rouletteTableCoords[i][4])
      end
      for i = 1, 8 do
        if isElement(tbl.players[i]) then
          setElementRotation(tbl.players[i], 0, 0, tbl.seats[i][4], "default", true)
          local a, b = getPedAnimation(tbl.players[i])
          if a ~= "int_office" or b ~= "off_sit_idle_loop" then
            setPedAnimation(tbl.players[i], "int_office", "off_sit_idle_loop", -1, true, false, false, false)
          end
        end
      end
    end
    if tbl.countdown then
      local new = math.max(0, math.ceil(countdownTime - (now - tbl.countdown) / 1000))
      if tbl.countdownTime ~= new then
        tbl.countdownTime = new
        if new <= 10 and 1 <= new then
          playTableSound("10sec", i)
        end
        if i == myTable and new <= 0 then
          seexports.seal_gui:showTooltip(formatBetTooltip(tbl, hover))
        end
      end
    end
    local s = 246
    local zoom = 0
    local xp = 0
    local eDelta = false
    if tbl.spinUp then
      xp = 1 - getEasingValue(math.min(1, (now - tbl.spinUp) / 1000), "InOutQuad")
    elseif tbl.bounceStart then
      local bDelta = now - tbl.bounceStart
      zoom = math.min(1, bDelta / 3500)
      if zoom < 1 then
        zoom = getEasingValue(zoom, "InOutQuad")
      end
    elseif tbl.ended then
      eDelta = now - tbl.ended
      eDelta = eDelta - 3500
      if 5000 < eDelta then
        xp = 1
        zoom = 0
      elseif 0 < eDelta then
        xp = math.min(1, eDelta / 5000)
        zoom = 1 - xp
        if zoom < 1 then
          zoom = getEasingValue(zoom, "InOutQuad")
        end
        if 1 < xp then
          xp = 1
        else
          xp = math.max(0, xp * 2 - 1)
        end
      else
        zoom = 1
      end
    elseif not tbl.spinUp and tbl.ballSpeed <= 0 then
      xp = 1
    end
    s = s * (1 + zoom * 1.05)
    if tbl.onScreen then
      if tbl.d < 15 then
        processBall(i, tbl, rot, rad, pos - 1)
      end
      dxSetBlendMode("modulate_add")
      dxSetRenderTarget(tbl.ledRt, true)
      local degRot = math.deg(rot)
      if tbl.spinUp or tbl.slowDown or tbl.bounceStart or tbl.ended and 1000 >= now - tbl.ended then
        dxDrawRectangle(0, 8, 360, 8, tocolor(220, 175, 16, 50))
        seelangStaticImageUsed[41] = true
        if seelangStaticImageToc[41] then
          processseelangStaticImage[41]()
        end
        dxDrawImageSection(0, 8, 360, 8, -180 - degRot, 0, 360, 8, seelangStaticImage[41], 0, 0, 0, tocolor(220, 175, 16))
        dxDrawRectangle(0, 0, 360, 8, tocolor(220, 175, 16, 150))
        dxDrawRectangle(0, 24, 360, 8, tocolor(220, 175, 16, 50))
        seelangStaticImageUsed[42] = true
        if seelangStaticImageToc[42] then
          processseelangStaticImage[42]()
        end
        dxDrawImageSection(0, 0, 360, 8, -180 + degRot, 0, 360, 8, seelangStaticImage[42], 0, 0, 0, tocolor(220, 175, 16))
        seelangStaticImageUsed[42] = true
        if seelangStaticImageToc[42] then
          processseelangStaticImage[42]()
        end
        dxDrawImageSection(0, 24, 360, 8, -180 - degRot, 0, 360, 8, seelangStaticImage[42], 0, 0, 0, tocolor(220, 175, 16))
      else
        if tbl.lastNumberColor == 1 then
          dxDrawRectangle(0, 0, 360, 16, tocolor(205, 50, 38, 150))
        elseif tbl.lastNumberColor == 2 then
          dxDrawRectangle(0, 0, 360, 16, tocolor(10, 10, 10, 150))
        else
          dxDrawRectangle(0, 0, 360, 16, tocolor(0, 166, 62, 150))
        end
        seelangStaticImageUsed[41] = true
        if seelangStaticImageToc[41] then
          processseelangStaticImage[41]()
        end
        dxDrawImageSection(0, 0, 360, 8, -180 - degRot, 0, 360, 8, seelangStaticImage[41], 0, 0, 0, tocolor(255, 255, 255))
        seelangStaticImageUsed[42] = true
        if seelangStaticImageToc[42] then
          processseelangStaticImage[42]()
        end
        dxDrawImageSection(0, 8, 360, 8, -180 - degRot, 0, 360, 8, seelangStaticImage[42], 0, 0, 0, tocolor(255, 255, 255))
        dxDrawRectangle(0, 24, 360, 8, tocolor(220, 175, 16, 100))
        seelangStaticImageUsed[42] = true
        if seelangStaticImageToc[42] then
          processseelangStaticImage[42]()
        end
        seelangStaticImageUsed[42] = true
        if seelangStaticImageToc[42] then
          processseelangStaticImage[42]()
        end
        dxDrawImageSection(0, 24, 360, 8, -180 - degRot, 0, 360, 8, seelangStaticImage[42], 0, 0, 0, tocolor(220, 175, 16))
        if tbl.newRound or tbl.ended and 1000 < now - tbl.ended then
          local a = 130 + 125 * pulse
          if tbl.newRound then
            a = a - a * math.min(1, (now - tbl.newRound) / 1000)
          end
          for i = 1, 8 do
            local c = tocolor(0, 0, 0, a)
            if tbl.win[i] then
              c = tocolor(0, 166, 62, a)
            elseif tbl.betted[i] then
              c = tocolor(205, 50, 38, a)
            end
            dxDrawRectangle((i - 1) * 45, 16, 45, 8, c)
          end
        end
        if tbl.countdownTime and tbl.countdownTime <= 10 then
          local delta = now - tbl.countdown
          local a = 1 - delta % 1000 / 1000
          if delta < countdownTime * 1000 then
            dxDrawRectangle(0, 0, 360, 32, tocolor(245, 95, 95, 255 * a))
          end
        end
      end
      dxSetRenderTarget(tbl.bigRt)
      dxDrawRectangle(0, 0, 342, 256, tocolor(26, 70, 30))
      local bx = 171 + s * rad * math.cos(rot) * zoom - xp * 34
      local by = 128 + s * rad * math.sin(rot) * zoom
      local sx = s * 342 / 256
      seelangStaticImageUsed[43] = true
      if seelangStaticImageToc[43] then
        processseelangStaticImage[43]()
      end
      dxDrawImage(bx - sx / 2, by - s / 2, sx, s, seelangStaticImage[43])
      drawReel(bx, by, s, wr, rot, rad, pos, tbl.d > 20)
      if 0 < xp then
        local x = 342 - xp * 68
        dxDrawRectangle(x, 0, 68, 256, tocolor(0, 0, 0, 75))
        local h = 26.5
        local w = h - 6
        local y = 36 + h / 2
        local c = 0
        for i = #tbl.history, 1, -1 do
          if tbl.history[i] then
            local x = x + 34
            if tbl.history[i][2] == 1 then
              x = x - 12
              seelangStaticImageUsed[31] = true
              if seelangStaticImageToc[31] then
                processseelangStaticImage[31]()
              end
              dxDrawImage(x - w / 2, y - w / 2, w, w, seelangStaticImage[31])
            elseif tbl.history[i][2] == 2 then
              x = x + 12
              seelangStaticImageUsed[32] = true
              if seelangStaticImageToc[32] then
                processseelangStaticImage[32]()
              end
              dxDrawImage(x - w / 2, y - w / 2, w, w, seelangStaticImage[32])
            else
              seelangStaticImageUsed[33] = true
              if seelangStaticImageToc[33] then
                processseelangStaticImage[33]()
              end
              dxDrawImage(x - w / 2, y - w / 2, w, w, seelangStaticImage[33])
            end
            if tbl.d < 25 then
              dxDrawText(tbl.history[i][1], x, y, x, y, tocolor(255, 255, 255), numberFontScale, numberFont, "center", "center")
            end
            y = y + h
            c = c + 1
            if 8 <= c then
              break
            end
          end
        end
      end
      seelangStaticImageUsed[44] = true
      if seelangStaticImageToc[44] then
        processseelangStaticImage[44]()
      end
      dxDrawImage(278, 4, 62, 24, seelangStaticImage[44], 0, 0, 0, tocolor(255, 255, 255, 255 * (0.5 + 0.5 * xp)))
      if tbl.countdownTime and 0 < xp then
        if tbl.countdownTime > 0 then
          seelangStaticImageUsed[45] = true
          if seelangStaticImageToc[45] then
            processseelangStaticImage[45]()
          end
          dxDrawImage(0, 30, 342, 45, seelangStaticImage[45], 0, 0, 0, tocolor(255, 255, 255, 160))
          dxDrawText(tbl.countdownTime .. "s", 8, 30, 0, 75, tocolor(245, 95, 95), cdFontScale * 1.25, cdFont, "left", "center")
        else
          seelangStaticImageUsed[46] = true
          if seelangStaticImageToc[46] then
            processseelangStaticImage[46]()
          end
          seelangStaticImageUsed[45] = true
          if seelangStaticImageToc[45] then
            processseelangStaticImage[45]()
          end
          dxDrawImage(0, 30, 342, 45, seelangStaticImage[45], 0, 0, 0, tocolor(255, 255, 255, 160 * xp))
          dxDrawText("Köszönöm, nincs több tét!", 8, 30, 0, 75, tocolor(255, 255, 255, 255 * xp), cdFontScale * 0.65, cdFont, "left", "center")
        end
        if tbl.countdown and tbl.countdownTime <= 10 then
          local delta = now - tbl.countdown
          local a = 1 - delta % 1000 / 1000
          if delta < countdownTime * 1000 then
            seelangStaticImageUsed[36] = true
            if seelangStaticImageToc[36] then
              processseelangStaticImage[36]()
            end
            dxDrawImageSection(0, 0, 342, 256, 0, -378 - 756 * delta / 1000, 1012, 756, seelangStaticImage[36], 0, 0, 0, tocolor(245, 95, 95, 125 * a))
          end
        end
      end
      dxSetRenderTarget(tbl.smallRt)
      seelangStaticImageUsed[47] = true
      if seelangStaticImageToc[47] then
        processseelangStaticImage[47]()
      end
      dxDrawImage(0, 0, 170, 129, seelangStaticImage[47])
      if tbl.d < 25 then
        if tbl.bounceStart then
          seelangStaticImageUsed[26] = true
          if seelangStaticImageToc[26] then
            processseelangStaticImage[26]()
          end
          dxDrawImageSection(109.57, 12.093, 60.429, 7.39, -208 + (tbl.ballRotBounce - tbl.ballWrs) / math.pi * 814, 0, 364, 44, seelangStaticImage[26])
        elseif tbl.spinUp or tbl.slowDown then
          seelangStaticImageUsed[26] = true
          if seelangStaticImageToc[26] then
            processseelangStaticImage[26]()
          end
          dxDrawImageSection(109.57, 12.093, 60.429, 7.39, -208 + (tbl.ballRot - tbl.ballWrs) / math.pi * 814, 0, 364, 44, seelangStaticImage[26])
        else
          seelangStaticImageUsed[26] = true
          if seelangStaticImageToc[26] then
            processseelangStaticImage[26]()
          end
          dxDrawImageSection(109.57, 12.093, 60.429, 7.39, -208 + tbl.lastPos * 44, 0, 364, 44, seelangStaticImage[26])
        end
        if tbl.countdownTime and tbl.countdownTime <= 10 and tbl.countdown then
          local delta = now - tbl.countdown
          local a = 1 - delta % 1000 / 1000
          if delta < countdownTime * 1000 then
            seelangStaticImageUsed[36] = true
            if seelangStaticImageToc[36] then
              processseelangStaticImage[36]()
            end
            dxDrawImageSection(1.162, 1.162, 167.676, 126.676, 0, -378 - 756 * delta / 1000, 1012, 756, seelangStaticImage[36], 0, 0, 0, tocolor(245, 95, 95, 125 * a))
          end
        end
        if eDelta and 0 < eDelta + 2500 then
          dxDrawText("Játék vége, eredményhirdetés", 2.5, 11.421, 0, 20.156, tocolor(255, 255, 255), cdFontScale * 0.1328, cdFont, "left", "center")
        elseif tbl.spinUp or tbl.slowDown or tbl.bounceStart or tbl.ended then
          dxDrawText("Sok szerencsét!", 2.5, 11.421, 0, 20.156, tocolor(255, 255, 255), cdFontScale * 0.1328, cdFont, "left", "center")
        else
          local w = 0
          if tbl.countdownTime and tbl.countdownTime > 0 then
            w = 9.296
            dxDrawText(tbl.countdownTime .. "s", 2.5, 11.421, 0, 20.156, tocolor(245, 95, 95), cdFontScale * 0.2075, cdFont, "left", "center")
          end
          if not tbl.countdownTime or tbl.countdownTime > 0 then
            dxDrawText("Kérem tegyék meg tétjeiket!", 2.5 + w, 11.421, 0, 20.156, tocolor(255, 255, 255), cdFontScale * 0.1328, cdFont, "left", "center")
          else
            dxDrawText("Köszönöm, nincs több tét!", 2.5 + w, 11.421, 0, 20.156, tocolor(255, 255, 255), cdFontScale * 0.1328, cdFont, "left", "center")
          end
        end
      end
      dxDrawImage(3.486, 55.429, 53.125, 40.3125, tbl.bigRt)
      seelangStaticImageUsed[48] = true
      if seelangStaticImageToc[48] then
        processseelangStaticImage[48]()
      end
      dxDrawImage(0, 0, 170, 129, seelangStaticImage[48])
      dxSetBlendMode("blend")
      dxSetRenderTarget()
    end
  end
end
local coinButtons = {}
addEvent("changeRouletteCoin", false)
addEventHandler("changeRouletteCoin", getRootElement(), function(button, state, absX, absY, el)
  if coinButtons[el] and currentCoin ~= coinButtons[el] then
    currentCoin = coinButtons[el]
    playSound("files/sound/sscswitch" .. math.random(1, 3) .. ".mp3")
  end
end)
function deleteWindow()
  if hover then
    hover = false
    seexports.seal_gui:setCursorType("normal")
    seexports.seal_gui:showTooltip()
  end
  if smallWindow then
    smallX, smallY = seexports.seal_gui:getGuiPosition(smallWindow)
    seexports.seal_gui:deleteGuiElement(smallWindow)
  end
  smallWindow = false
  if bigWindow then
    seexports.seal_gui:deleteGuiElement(bigWindow)
  end
  bigWindow = false
  bigPreview = false
  coinButtons = {}
end
addEvent("toggleRouletteWindow", false)
addEventHandler("toggleRouletteWindow", getRootElement(), function(el, state)
  if bigWindow then
    createWindow(false)
  else
    createWindow(true)
  end
end)
addEvent("rouletteBigPreview", false)
addEventHandler("rouletteBigPreview", getRootElement(), function(el, state)
  bigPreview = state
end)
function createWindow(big)
  deleteWindow()
  titleBarHeight = seexports.seal_gui:getTitleBarHeight()
  local pw, ph
  if big then
    pw, ph = 1024, 768 + titleBarHeight
    if not bigX then
      bigX, bigY = screenX / 2 - pw / 2, screenY / 2 - ph / 2
    end
  else
    pw, ph = 324, 244 + titleBarHeight
    if not smallX then
      smallX, smallY = screenX / 2 - pw / 2, math.floor(screenY * 0.75) - ph / 2
    end
  end
  local x = big and bigX or smallX
  local y = big and bigY or smallY
  local window = seexports.seal_gui:createGuiElement("window", x, y, pw, big and titleBarHeight or ph)
  seexports.seal_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "Roulette")
  if big then
    seexports.seal_gui:setWindowCloseButton(window, "tryToExitRoulette")
    seexports.seal_gui:setWindowMoveEvent(window, "moveRouletteWindow")
    local image = seexports.seal_gui:createGuiElement("image", pw - titleBarHeight * 2, 0, titleBarHeight, titleBarHeight, window)
    seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("compress-alt", titleBarHeight))
    seexports.seal_gui:setGuiHoverable(image, true)
    seexports.seal_gui:setGuiHover(image, "solid", "green")
    seexports.seal_gui:setClickEvent(image, "toggleRouletteWindow")
    bigWindow = window
    local x = 512 - 64 * #coinValues / 2
    local y = titleBarHeight + 632
    for i = 1, #coinValues do
      local btn = seexports.seal_gui:createGuiElement("rectangle", x + 6, y + 6, 52, 52, window)
      seexports.seal_gui:setGuiHover(btn, "none", false, false, true)
      seexports.seal_gui:setGuiHoverable(btn, true)
      seexports.seal_gui:setClickEvent(btn, "changeRouletteCoin")
      coinButtons[btn] = i
      x = x + 64
    end
  else
    local image = seexports.seal_gui:createGuiElement("image", pw - titleBarHeight, 0, titleBarHeight, titleBarHeight, window)
    seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("expand-alt", titleBarHeight))
    seexports.seal_gui:setGuiHoverable(image, true)
    seexports.seal_gui:setGuiHover(image, "solid", "green")
    seexports.seal_gui:setClickEvent(image, "toggleRouletteWindow")
    local image = seexports.seal_gui:createGuiElement("image", pw - titleBarHeight * 2, 0, titleBarHeight, titleBarHeight, window)
    seexports.seal_gui:setImageFile(image, seexports.seal_gui:getFaIconFilename("eye", titleBarHeight, "regular"))
    seexports.seal_gui:setGuiHoverable(image, true)
    seexports.seal_gui:setGuiHover(image, "solid", "green")
    seexports.seal_gui:setHoverEvent(image, "rouletteBigPreview")
    smallWindow = window
    local tbl = rouletteTables[myTable]
    local image = seexports.seal_gui:createGuiElement("image", 2, titleBarHeight + 2, 320, 240, window)
    seexports.seal_gui:setImageFile(image, tbl.bigRt)
    local image = seexports.seal_gui:createGuiElement("image", 0, titleBarHeight, 324, 244, window)
    seexports.seal_gui:setImageDDS(image, ":seal_roulette/files/live.dds")
  end
end
addEvent("moveRouletteWindow", false)
addEventHandler("moveRouletteWindow", getRootElement(), function(el, x, y)
  bigX, bigY = x, y
end)
function processBetCoinEx(val)
  if val then
    for i = #coinValues, 1, -1 do
      if val >= coinValues[i] then
        return i
      end
    end
  else
    return 1
  end
end
function processBetCoin(tbl, seat, bet, val)
  if val then
    for i = #coinValues, 1, -1 do
      if val >= coinValues[i] then
        tbl.betCoins[seat][bet] = i
        break
      end
    end
  else
    tbl.betCoins[seat][bet] = nil
  end
end
addEvent("rouletteNewRound", true)
addEventHandler("rouletteNewRound", getRootElement(), function(id)
  local tbl = rouletteTables[id]
  tbl.ended = false
  tbl.newRound = getTickCount()
end)
addEvent("gotNewRouletteBet", true)
addEventHandler("gotNewRouletteBet", getRootElement(), function(id, seat, bet, amount, disableSound)
  local tbl = rouletteTables[id]
  if id == myTable and seat == mySeat then
    myBet = myBet - (tbl.bets[seat][bet] or 0)
    myBetPlus[bet] = (amount or 0) > (tbl.bets[seat][bet] or 0)
  end
  if not disableSound then
    if amount then
      if amount > (tbl.bets[seat][bet] or 0) then
        playSeatSound("ssc1", tbl, seat)
      else
        playSeatSound("ssc2", tbl, seat)
      end
    else
      playSeatSound("ssc2", tbl, seat)
    end
  end
  tbl.bets[seat][bet] = amount
  if id == myTable and seat == mySeat then
    myBet = myBet + (tbl.bets[seat][bet] or 0)
    myBetFormatted = seexports.seal_gui:thousandsStepper(myBet)
  end
  processBetCoin(tbl, seat, bet, amount)
  local now = getTickCount()
  if id == myTable and seat == mySeat then
    myLastBets[bet] = amount and now or nil
    if bet == hover then
      seexports.seal_gui:showTooltip(formatBetTooltip(tbl, hover))
    end
  end
  if not tbl.countdown then
    tbl.countdown = now
    tbl.countdownTime = false
  end
end)
local lastBetTry = {}
function rouletteClick(btn, state)
  if state == "down" then
    local tbl = rouletteTables[myTable]
    if tbl.canBet and (not tbl.countdownTime or tbl.countdownTime > 0) then
      local now = getTickCount()
      if now - (lastBetTry[hover] or 0) <= 250 then
        return
      end
      local amount = (btn == "right" and -1 or 1) * coinValues[currentCoin]
      if hover == "tier" then
        for i = 1, #tierBets do
          if myLastBets[tierBets[i]] then
            return
          end
        end
        if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] * 6 then
          seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
          return
        end
        triggerServerEvent("tryToAddRouletteBet", localPlayer, "tier", amount)
        lastBetTry.tier = now + 500
      elseif hover == "orphelins" then
        for i = 1, #orphelinsBets do
          if myLastBets[orphelinsBets[i]] then
            return
          end
        end
        if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] * 5 then
          seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
          return
        end
        triggerServerEvent("tryToAddRouletteBet", localPlayer, "orphelins", amount)
        lastBetTry.orphelins = now + 500
      elseif hover == "voisins" then
        for i = 1, #voisinsBets do
          if myLastBets[voisinsBets[i]] then
            return
          end
        end
        if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] * 9 then
          seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
          return
        end
        triggerServerEvent("tryToAddRouletteBet", localPlayer, "voisins", amount)
        lastBetTry.voisins = now + 500
      elseif hover == "zero" then
        for i = 1, #zeroBets do
          if myLastBets[zeroBets[i]] then
            return
          end
        end
        if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] * 4 then
          seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
          return
        end
        triggerServerEvent("tryToAddRouletteBet", localPlayer, "zero", amount)
        lastBetTry.zero = now + 500
      elseif validBets[hover] then
        if type(validBets[hover]) == "table" and validBets[hover][1] == "n" then
          local num = validBets[hover][2]
          local j = rouletteWheelNumsReverse[num] - 1
          if myLastBets[num] then
            return
          end
          if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] * 3 then
            seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
            return
          end
          for k = -1, 1, 2 do
            local num = rouletteWheelNums[(j + k) % 37 + 1]
            if myLastBets[num] then
              return
            end
          end
          triggerServerEvent("tryToAddRouletteBet", localPlayer, hover, amount)
          lastBetTry[hover] = now + 500
        else
          if myLastBets[hover] then
            return
          end
          if 0 < amount and (balanceNew or balance) < coinValues[currentCoin] then
            seexports.seal_gui:showInfobox("e", "Nincs elegendő SSC egyenleged!")
            return
          end
          triggerServerEvent("tryToAddRouletteBet", localPlayer, hover, amount)
          lastBetTry[hover] = now
        end
      end
    end
  end
end
local tblHover = false
local seatHover = false
function renderSeatIcons()
  local cx, cy = getCursorPosition()
  if cx then
    cx = cx * screenX
    cy = cy * screenY
  end
  local tmpTbl = false
  local tmpSeat = false
  local px, py, pz = getElementPosition(localPlayer)
  for l = 1, #streamedIn do
    local k = streamedIn[l]
    local tbl = rouletteTables[k]
    if tbl.onScreen then
      for i = 1, 8 do
        if not tbl.players[i] then
          local x, y, z = tbl.seats[i][1], tbl.seats[i][2], tbl.seats[i][3]
          local d = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
          if d < 5 then
            local x, y = getScreenFromWorldPosition(x, y, z, 32)
            if x then
              local a = 255 - d / 5 * 255
              if d < 1.5 and cx and cx >= x - 16 and cx <= x + 16 and cy >= y - 16 and cy <= y + 16 then
                tmpTbl = k
                tmpSeat = i
                dxDrawRectangle(x - 16, y - 16, 32, 32, tocolor(sitBgColor[1], sitBgColor[2], sitBgColor[3]))
                dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. sitIcon .. faTicks[sitIcon], 0, 0, 0, sitColor)
              else
                dxDrawRectangle(x - 16, y - 16, 32, 32, tocolor(sitBgColor[1], sitBgColor[2], sitBgColor[3], a))
                dxDrawImage(x - 12, y - 12, 24, 24, ":seal_gui/" .. sitIcon .. faTicks[sitIcon], 0, 0, 0, tocolor(255, 255, 255, a))
              end
            end
          end
        end
      end
    end
  end
  if tblHover ~= tmpTbl or seatHover ~= tmpSeat then
    tblHover = tmpTbl
    seatHover = tmpSeat
    seexports.seal_gui:setCursorType(tblHover and "link" or "normal")
    seexports.seal_gui:showTooltip(tblHover and "Leülés")
  end
end
function clickSeatIcons(btn, state)
  if state == "up" and tblHover and not myTable then
    triggerServerEvent("tryToSitDownRoulette", localPlayer, tblHover, seatHover)
  end
end
addEvent("tryToExitRoulette", false)
addEventHandler("tryToExitRoulette", getRootElement(), function()
  local tbl = rouletteTables[myTable]
  for bet in pairs(tbl.bets[mySeat]) do
    seexports.seal_gui:showInfobox("e", "Amíg érvényes téted van az asztalon, nem állhatsz fel!")
    return
  end
  triggerServerEvent("tryToExitRoulette", localPlayer)
  showCursor(false)
end)
addEvent("gotRoulettePlayer", true)
addEventHandler("gotRoulettePlayer", getRootElement(), function(id, seat, client)
  local tbl = rouletteTables[id]
  if client then
    if client == localPlayer then
      if not myTable then
        removeEventHandler("onClientRender", getRootElement(), renderSeatIcons)
        removeEventHandler("onClientClick", getRootElement(), clickSeatIcons)
        addEventHandler("onClientClick", getRootElement(), rouletteClick)
      end
      myTable = id
      mySeat = seat
      createWindow(true)
    end
    tbl.players[seat] = client
    playSeatSound("sit", tbl, seat)
    attachElements(tbl.players[seat], tbl.obj, seatOffsets[seat][1], seatOffsets[seat][2], seatOffsets[seat][3])
    setPedAnimation(client, "int_office", "off_sit_idle_loop", -1, true, false, false, false)
  else
    if id == myTable and seat == mySeat then
      if myTable then
        addEventHandler("onClientRender", getRootElement(), renderSeatIcons)
        addEventHandler("onClientClick", getRootElement(), clickSeatIcons)
        removeEventHandler("onClientClick", getRootElement(), rouletteClick)
      end
      myTable = false
      mySeat = false
      deleteWindow()
    end
    playSeatSound("stand", tbl, seat)
    if isElement(tbl.players[seat]) then
      detachElements(tbl.players[seat], tbl.obj)
      setPedAnimation(tbl.players[seat])
    end
    tbl.bets[seat] = {}
    tbl.betCoins[seat] = {}
    tbl.players[seat] = nil
  end
end)
function renderRoulette()
  local now = getTickCount()
  if myTable then
    if bigWindow then
      drawTable(bigX, bigY + titleBarHeight)
    elseif bigPreview then
      drawTable(screenX / 2 - 512, screenY / 2 - 384)
    end
  end
  for l = 1, #streamedIn do
    local i = streamedIn[l]
    local tbl = rouletteTables[i]
    if tbl.onScreen and tbl.d < 25 then
      for j = 1, 8 do
        if (tbl.newRound or tbl.ended and now > tbl.ended + 1000) and tbl.win[j] then
          local el = tbl.winCoord[j]
          seelangStaticImageUsed[49] = true
          if seelangStaticImageToc[49] then
            processseelangStaticImage[49]()
          end
          dxDrawMaterialLine3D(el[1], el[2], el[3], el[4], el[5], el[6], seelangStaticImage[49], 0.583744, tocolor(255, 255, 255), el[7], el[8], el[9])
        end
      end
    end
  end
end
