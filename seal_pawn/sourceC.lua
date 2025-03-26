local seexports = {
    seal_gui = false,
    seal_items = false
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
  local objs = {}
  function loadModelIds()
  end
  addEvent("modloaderLoaded", false)
  addEventHandler("modloaderLoaded", getRootElement(), loadModelIds)
  loadModelIds()
  local screenX, screenY = guiGetScreenSize()
  local negotiationGui = false
  local negotiationData = false
  addEvent("refreshPawnData", true)
  addEventHandler("refreshPawnData", getRootElement(), function(dat)
    negotiationData = dat
    createNegotiation()
  end)
  local pawnName = "Zacis úr"
  local pawnPed = createPed(241, pawnSellPosX, pawnSellPosY, pawnSellPosZ, pawnSellPosR)
  setElementData(pawnPed, "invulnerable", true)
  setElementData(pawnPed, "visibleName", pawnName)
  setElementData(pawnPed, "pedNameType", "Zálogház")
  setElementFrozen(pawnPed, true)
  local goldPeds = {}
  for i = 1, #goldSellPoses do
    local ped = createPed(goldSellPoses[i][5], goldSellPoses[i][1], goldSellPoses[i][2], goldSellPoses[i][3], goldSellPoses[i][4])
    setElementData(ped, "invulnerable", true)
    setElementData(ped, "visibleName", goldSellPoses[i][6])
    setElementData(ped, "pedNameType", "Aranyrúd felvásárlás")
    setElementFrozen(ped, true)
    goldPeds[ped] = i
  end
  local playerIcon = false
  local pawnIcon = false
  local playerLabel = false
  local pawnLabel = false
  local playerRect = false
  local pawnRect = false
  local pawnX = false
  local barX, barStart, barY, barSX, barSize, barSY
  local barHover = false
  local barMoving = false
  function refreshPlayerPrice()
    local x = barStart + barSize * (negotiationData.playerPrice - negotiationData.minPrice) / (negotiationData.maxPrice - negotiationData.minPrice)
    seexports.seal_gui:setGuiPosition(playerRect, x - 1, false)
    seexports.seal_gui:setLabelText(playerLabel, seexports.seal_gui:thousandsStepper(negotiationData.playerPrice) .. " $")
    if pawnLabel then
      local lwpl = seexports.seal_gui:getLabelTextWidth(playerLabel) / 2 + 2
      local lwpa = seexports.seal_gui:getLabelTextWidth(pawnLabel) / 2 + 2
      local d = pawnX + lwpa - (x - lwpl)
      if 0 < d then
        seexports.seal_gui:setGuiPosition(playerLabel, x + d / 2, false)
        seexports.seal_gui:setGuiPosition(pawnLabel, pawnX - d / 2, false)
      else
        seexports.seal_gui:setGuiPosition(playerLabel, x, false)
        seexports.seal_gui:setGuiPosition(pawnLabel, pawnX, false)
      end
      local d = pawnX + 12 - (x - 12)
      if 0 < d then
        seexports.seal_gui:setGuiPosition(playerIcon, x + d / 2 - 12, false)
        seexports.seal_gui:setGuiPosition(pawnIcon, pawnX - d / 2 - 12, false)
      else
        seexports.seal_gui:setGuiPosition(playerIcon, x - 12, false)
        seexports.seal_gui:setGuiPosition(pawnIcon, pawnX - 12, false)
      end
    else
      seexports.seal_gui:setGuiPosition(playerLabel, x, false)
      seexports.seal_gui:setGuiPosition(playerIcon, x - 12, false)
    end
  end
  function onClientClick(btn, state, cx, cy)
    if negotiationData.canMove then
      if state == "down" then
        barMoving = barHover
        if barHover then
          negotiationData.playerPrice = math.floor(negotiationData.minPrice + (cx - barStart) / barSize * (negotiationData.maxPrice - negotiationData.minPrice))
          negotiationData.playerPrice = math.min(negotiationData.playerPrice, negotiationData.fixedPlayerPrice or negotiationData.maxPrice)
          negotiationData.playerPrice = math.max(negotiationData.playerPrice, negotiationData.pawnPrice or negotiationData.minPrice)
          refreshPlayerPrice()
        end
      else
        barMoving = false
        if not barHover then
          seexports.seal_gui:setCursorType("normal")
        end
      end
    end
  end
  function onClientCursorMove(x, y, cx, cy)
    if negotiationData.canMove then
      local tmp = cx >= barX and cy >= barY - 24 - 4 and cx <= barX + barSX and cy <= barY + barSY
      if barHover ~= tmp then
        barHover = tmp
        seexports.seal_gui:setCursorType((barHover or barMoving) and "link" or "normal")
      end
      if barMoving then
        negotiationData.playerPrice = math.floor(negotiationData.minPrice + (cx - barStart) / barSize * (negotiationData.maxPrice - negotiationData.minPrice))
        negotiationData.playerPrice = math.min(negotiationData.playerPrice, negotiationData.fixedPlayerPrice or negotiationData.maxPrice)
        negotiationData.playerPrice = math.max(negotiationData.playerPrice, negotiationData.pawnPrice or negotiationData.minPrice)
        refreshPlayerPrice()
      end
    end
  end
  addEvent("pawnOfferNewPrice", false)
  addEventHandler("pawnOfferNewPrice", getRootElement(), function()
    if not negotiationData.thinking then
      negotiationData.canMove = false
      negotiationData.thinking = true
      negotiationData.fixedPlayerPrice = negotiationData.playerPrice
      negotiationData.playerReply = math.random(1, 4) + (negotiationData.goldped and 5 or 0)
      createNegotiation(true)
      triggerServerEvent("pawnOfferNewPrice", localPlayer, negotiationData.playerPrice)
    end
  end)
  addEvent("pawnEndTheDeal", false)
  addEventHandler("pawnEndTheDeal", getRootElement(), function()
    if not negotiationData.thinking then
      negotiationData.canMove = false
      negotiationData.thinking = true
      triggerServerEvent("pawnEndTheDeal", localPlayer)
      createNegotiation(true)
    end
  end)
  addEvent("pawnAcceptOffer", false)
  addEventHandler("pawnAcceptOffer", getRootElement(), function()
    if not negotiationData.thinking and negotiationData.pawnPrice then
      negotiationData.canMove = false
      negotiationData.thinking = true
      negotiationData.playerPrice = negotiationData.pawnPrice
      negotiationData.fixedPlayerPrice = negotiationData.playerPrice
      negotiationData.playerReply = 5 + (negotiationData.goldped and 5 or 0)
      createNegotiation(true)
      triggerServerEvent("pawnAcceptOffer", localPlayer)
    end
  end)
  function deleteNegotiation()
    if negotiationGui then
      seexports.seal_gui:deleteGuiElement(negotiationGui)
      removeEventHandler("onClientCursorMove", getRootElement(), onClientCursorMove)
      removeEventHandler("onClientClick", getRootElement(), onClientClick)
      showCursor(false)
    end
    negotiationGui = false
    if barHover then
      seexports.seal_gui:setCursorType("normal")
    end
    playerIcon = false
    pawnIcon = false
    playerLabel = false
    pawnLabel = false
    playerRect = false
    pawnRect = false
    pawnX = false
    barX = false
    barStart = false
    barY = false
    barSX = false
    barSize = false
    barSY = false
    barHover = false
    barMoving = false
  end
  function createNegotiation(disBtn)
    deleteNegotiation()
    if negotiationData then
      showCursor(true)
      addEventHandler("onClientCursorMove", getRootElement(), onClientCursorMove)
      addEventHandler("onClientClick", getRootElement(), onClientClick)
      negotiationGui = seexports.seal_gui:createGuiElement("null", 0, 0, screenX, screenY)
      local sender = (negotiationData.pedName or pawnName) .. ": "
      local text = negotiationTexts[negotiationData.text]
      if negotiationData.playerReply then
        sender = getElementData(localPlayer, "visibleName"):gsub("_", " ") .. ": "
        text = playerReplys[negotiationData.playerReply]
        text = utf8.gsub(text, "%$", seexports.seal_gui:thousandsStepper(negotiationData.playerPrice))
      elseif negotiationData.pawnPrice then
        text = utf8.gsub(text, "%$", seexports.seal_gui:thousandsStepper(negotiationData.pawnPrice))
      end
      local w1 = seexports.seal_gui:getTextWidthFont(sender, "12/Ubuntu-R.ttf")
      local w2 = seexports.seal_gui:getTextWidthFont(text, "12/Ubuntu-L.ttf")
      local x = screenX / 2 - (w1 + w2) / 2
      local y = math.floor(screenY * 0.9)
      y = y - 150
      local label = seexports.seal_gui:createGuiElement("label", x, y, 0, 0, negotiationGui)
      seexports.seal_gui:setLabelAlignment(label, "left", "top")
      seexports.seal_gui:setLabelFont(label, "12/Ubuntu-R.ttf")
      seexports.seal_gui:setLabelText(label, sender)
      seexports.seal_gui:setLabelShadow(label, "#000000", 1, 1)
      local label = seexports.seal_gui:createGuiElement("label", x + w1, y, 0, 0, negotiationGui)
      seexports.seal_gui:setLabelAlignment(label, "left", "top")
      seexports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelText(label, text)
      seexports.seal_gui:setLabelShadow(label, "#000000", 1, 1)
      y = y + 70
      local rect = seexports.seal_gui:createGuiElement("rectangle", screenX / 2 - 225, y, 450, 16, negotiationGui)
      seexports.seal_gui:setGuiBackground(rect, "solid", "grey1")
      barX, barY, barSX, barSY = screenX / 2 - 225, y, 450, 16
      barStart = barX
      barSize = barSX
      local label = seexports.seal_gui:createGuiElement("label", barStart - 8, y, 0, barSY, negotiationGui)
      seexports.seal_gui:setLabelAlignment(label, "right", "center")
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelText(label, seexports.seal_gui:thousandsStepper(negotiationData.minPrice) .. " $")
      seexports.seal_gui:setLabelColor(label, "primary")
      seexports.seal_gui:setLabelShadow(label, "#000000", 1, 1)
      local label = seexports.seal_gui:createGuiElement("label", barStart + barSize + 8, y, 0, barSY, negotiationGui)
      seexports.seal_gui:setLabelAlignment(label, "left", "center")
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelText(label, seexports.seal_gui:thousandsStepper(negotiationData.maxPrice) .. " $")
      seexports.seal_gui:setLabelColor(label, "primary")
      seexports.seal_gui:setLabelShadow(label, "#000000", 1, 1)
      local redAlpha = seexports.seal_gui:getColorCode("red")
      redAlpha[4] = 150
      if negotiationData.pawnPrice then
        local w = barSize * (negotiationData.pawnPrice - negotiationData.minPrice) / (negotiationData.maxPrice - negotiationData.minPrice)
        local rect = seexports.seal_gui:createGuiElement("rectangle", barStart, y, w, barSY, negotiationGui)
        seexports.seal_gui:setGuiBackground(rect, "solid", redAlpha)
        barX = barX + w
        barSX = barSX - w
      end
      if negotiationData.fixedPlayerPrice then
        local w = barSize * (negotiationData.fixedPlayerPrice - negotiationData.minPrice) / (negotiationData.maxPrice - negotiationData.minPrice)
        local rect = seexports.seal_gui:createGuiElement("rectangle", barStart + w, y, barSize - w, barSY, negotiationGui)
        seexports.seal_gui:setGuiBackground(rect, "solid", redAlpha)
        barSX = barSX - (barSize - w)
      end
      if negotiationData.pawnPrice then
        local x = barStart + barSize * (negotiationData.pawnPrice - negotiationData.minPrice) / (negotiationData.maxPrice - negotiationData.minPrice)
        pawnIcon = seexports.seal_gui:createGuiElement("image", x - 12, y - 24 - 4, 24, 24, negotiationGui)
        seexports.seal_gui:setImageFile(pawnIcon, seexports.seal_gui:getFaIconFilename("store-alt", 24))
        seexports.seal_gui:setImageColor(pawnIcon, "blue")
        pawnRect = seexports.seal_gui:createGuiElement("rectangle", x - 1, y, 2, barSY, negotiationGui)
        seexports.seal_gui:setGuiBackground(pawnRect, "solid", "blue")
        pawnLabel = seexports.seal_gui:createGuiElement("label", x, y + barSY + 4, 0, 0, negotiationGui)
        seexports.seal_gui:setLabelAlignment(pawnLabel, "center", "top")
        seexports.seal_gui:setLabelFont(pawnLabel, "10/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelText(pawnLabel, seexports.seal_gui:thousandsStepper(negotiationData.pawnPrice) .. " $")
        seexports.seal_gui:setLabelColor(pawnLabel, "blue")
        seexports.seal_gui:setLabelShadow(pawnLabel, "#000000", 1, 1)
        pawnX = x
      end
      local x = barStart + barSize * (negotiationData.playerPrice - negotiationData.minPrice) / (negotiationData.maxPrice - negotiationData.minPrice)
      playerIcon = seexports.seal_gui:createGuiElement("image", x - 12, y - 24 - 4, 24, 24, negotiationGui)
      seexports.seal_gui:setImageFile(playerIcon, seexports.seal_gui:getFaIconFilename("user", 24))
      seexports.seal_gui:setImageColor(playerIcon, "primary")
      playerRect = seexports.seal_gui:createGuiElement("rectangle", x - 1, y, 2, barSY, negotiationGui)
      seexports.seal_gui:setGuiBackground(playerRect, "solid", "primary")
      playerLabel = seexports.seal_gui:createGuiElement("label", x, y + barSY + 4, 0, 0, negotiationGui)
      seexports.seal_gui:setLabelAlignment(playerLabel, "center", "top")
      seexports.seal_gui:setLabelFont(playerLabel, "10/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelText(playerLabel, seexports.seal_gui:thousandsStepper(negotiationData.playerPrice) .. " $")
      seexports.seal_gui:setLabelColor(playerLabel, "primary")
      seexports.seal_gui:setLabelShadow(playerLabel, "#000000", 1, 1)
      refreshPlayerPrice()
      if not disBtn and not negotiationData.thinking then
        y = y + barSY + 48
        local x = screenX / 2 - 180 * (negotiationData.pawnPrice and negotiationData.pawnPrice ~= negotiationData.playerPrice and negotiationData.pawnPrice < negotiationData.pawnLastPrice and 3 or 2) / 2
        if negotiationData.pawnPrice then
          local btn = seexports.seal_gui:createGuiElement("button", x + 4, y, 172, 24, negotiationGui)
          seexports.seal_gui:setGuiBackground(btn, "solid", "blue")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "blue",
            "blue-second"
          }, false, true)
          seexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
          seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("check", 24))
          seexports.seal_gui:setButtonText(btn, "Áll az alku! (" .. seexports.seal_gui:thousandsStepper(negotiationData.pawnPrice) .. " $)")
          seexports.seal_gui:setClickEvent(btn, "pawnAcceptOffer")
          x = x + 180
        end
        if negotiationData.pawnPrice ~= negotiationData.playerPrice and (not negotiationData.pawnPrice or negotiationData.pawnPrice < negotiationData.pawnLastPrice) then
          local btn = seexports.seal_gui:createGuiElement("button", x + 4, y, 172, 24, negotiationGui)
          seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "primary",
            "secondary"
          }, false, true)
          seexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
          seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("hand-holding-usd", 24))
          seexports.seal_gui:setButtonText(btn, "Ajánlattétel")
          seexports.seal_gui:setClickEvent(btn, "pawnOfferNewPrice")
          x = x + 180
        end
        local btn = seexports.seal_gui:createGuiElement("button", x + 4, y, 172, 24, negotiationGui)
        seexports.seal_gui:setGuiBackground(btn, "solid", "red")
        seexports.seal_gui:setGuiHover(btn, "gradient", {
          "red",
          "red-second"
        }, false, true)
        seexports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
        seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("times", 24))
        seexports.seal_gui:setButtonText(btn, "Alku megszakítása")
        seexports.seal_gui:guiSetTooltip(btn, "FIGYELEM! Sikertelen üzlet esetén csak 20 perc múlva próbálkozhatsz újra!")
        seexports.seal_gui:setClickEvent(btn, "pawnEndTheDeal")
      end
    end
  end
  local itemPlusButtons = {}
  local itemMinusButtons = {}
  local itemLabels = {}
  local itemAmounts = {}
  local itemSelectedAmount = {}
  local window = false
  local bigLabel = false
  addEventHandler("onClientClick", getRootElement(), function(button, state, x, y, wx, wy, wz, clickedElement)
    if state == "down" and not window and not negotiationData then
      if clickedElement == pawnPed then
        local px, py, pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(pawnSellPosX, pawnSellPosY, pawnSellPosZ, px, py, pz) <= 3 then
          triggerServerEvent("tryToStartPawnDeal", localPlayer)
        end
      elseif goldPeds[clickedElement] then
        local i = goldPeds[clickedElement]
        local px, py, pz = getElementPosition(localPlayer)
        if 3 >= getDistanceBetweenPoints3D(goldSellPoses[i][1], goldSellPoses[i][2], goldSellPoses[i][3], px, py, pz) then
          triggerServerEvent("tryToSellGoldBar", localPlayer, i)
        end
      end
    end
  end, true, "high+999999999999")
  addEvent("changePawnItemAmount", false)
  addEventHandler("changePawnItemAmount", getRootElement(), function(button, state, absoluteX, absoluteY, el)
    if itemPlusButtons[el] then
      local item = itemPlusButtons[el]
      if itemSelectedAmount[item] < itemAmounts[item] then
        itemSelectedAmount[item] = itemSelectedAmount[item] + 1
        refreshPawnItemAmounts(item)
        refreshBigLabel()
      end
    elseif itemMinusButtons[el] then
      local item = itemMinusButtons[el]
      if 0 < itemSelectedAmount[item] then
        itemSelectedAmount[item] = itemSelectedAmount[item] - 1
        refreshPawnItemAmounts(item)
        refreshBigLabel()
      end
    end
  end)
  function refreshPawnItemAmounts(k)
    seexports.seal_gui:setLabelText(itemLabels[k], itemSelectedAmount[k])
    for el, item in pairs(itemMinusButtons) do
      if item == k then
        seexports.seal_gui:setGuiRenderDisabled(el, itemSelectedAmount[k] <= 0)
        break
      end
    end
    for el, item in pairs(itemPlusButtons) do
      if item == k then
        seexports.seal_gui:setGuiRenderDisabled(el, itemSelectedAmount[k] >= itemAmounts[k])
        break
      end
    end
  end
  function refreshBigLabel()
    local sum = 0
    local c = 0
    for el, item in pairs(itemPlusButtons) do
      sum = sum + pawnItems[item] * itemSelectedAmount[item]
      c = c + itemSelectedAmount[item]
    end
    if 0 < c then
      seexports.seal_gui:setLabelText(bigLabel, c .. " db, " .. seexports.seal_gui:thousandsStepper(sum / 2) .. " $ - " .. seexports.seal_gui:thousandsStepper(sum * 2) .. " $")
    else
      seexports.seal_gui:setLabelText(bigLabel, c .. " db")
    end
  end
  function deleteItemSelector()
    if window then
      seexports.seal_gui:deleteGuiElement(window)
    end
    window = false
    itemPlusButtons = {}
    itemMinusButtons = {}
    itemLabels = {}
    itemAmounts = {}
    itemSelectedAmount = {}
    bigLabel = false
    showCursor(false)
  end
  addEvent("closePawnItemWindow", false)
  addEventHandler("closePawnItemWindow", getRootElement(), deleteItemSelector)
  addEvent("sellPawnItems", false)
  addEventHandler("sellPawnItems", getRootElement(), function()
    local c = 0
    for el, item in pairs(itemPlusButtons) do
      c = c + itemSelectedAmount[item]
      if itemSelectedAmount[item] <= 0 then
        itemSelectedAmount[item] = nil
      end
    end
    if c <= 0 then
      seexports.seal_gui:showInfobox("e", "Előbb válassz ki valamilyen tárgyat!")
      return
    end
    for el, item in pairs(itemPlusButtons) do
      if itemSelectedAmount[item] and itemSelectedAmount[item] <= 0 then
        itemSelectedAmount[item] = nil
      end
    end
    triggerServerEvent("startPawnSelling", localPlayer, itemSelectedAmount)
    deleteItemSelector()
  end)
  addEvent("openPawnItemSelector", true)
  addEventHandler("openPawnItemSelector", getRootElement(), function()
    createItemSelector()
  end)
  function createItemSelector()
    deleteItemSelector()
    if not negotiationData then
      showCursor(true)
      local items = seexports.seal_items:getLocalPlayerItems()
      itemAmounts = {}
      for k, v in pairs(items) do
        if pawnItems[v.itemId] then
          if not itemAmounts[v.itemId] then
            itemAmounts[v.itemId] = 1
          else
            itemAmounts[v.itemId] = itemAmounts[v.itemId] + 1
          end
        end
      end
      local c = 0
      for k, v in pairs(pawnItems) do
        c = c + 1
      end
      local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
      local h = titleBarHeight + c / 2 * 48 + 48
      window = seexports.seal_gui:createGuiElement("window", screenX / 2 - 310, screenY / 2 - h / 2, 620, h)
      seexports.seal_gui:setWindowColors(window, "grey2", "grey1", "grey3", "#ffffff")
      seexports.seal_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "Zálogház")
      seexports.seal_gui:setWindowCloseButton(window, "closePawnItemWindow")
      local y = titleBarHeight
      local transp = {
        200,
        200,
        200,
        150
      }
      local transp2 = seexports.seal_gui:getColorCode("primary")
      transp2 = {
        transp2[1],
        transp2[2],
        transp2[3],
        150
      }
      local border = seexports.seal_gui:createGuiElement("hr", 309, titleBarHeight + 6, 2, c / 2 * 48 - 6, window)
      seexports.seal_gui:setGuiHrColor(border, "grey3", "grey1")
      c = 0
      for k, v in pairs(pawnItems) do
        c = c + 1
        local img = seexports.seal_gui:createGuiElement("image", 6 + (c % 2 == 0 and 310 or 0), y + 6, 36, 36, window)
        seexports.seal_gui:setImageFile(img, ":seal_items/files/items/" .. k - 1 .. ".png")
        local label = seexports.seal_gui:createGuiElement("label", 42, 0, 0, 18, img)
        seexports.seal_gui:setLabelAlignment(label, "left", "center")
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelText(label, seexports.seal_items:getItemName(k))
        local money = seexports.seal_gui:createGuiElement("label", 42, 18, 0, 18, img)
        seexports.seal_gui:setLabelAlignment(money, "left", "center")
        seexports.seal_gui:setLabelFont(money, "10/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelText(money, seexports.seal_gui:thousandsStepper(pawnItems[k] / 2) .. " $ - " .. seexports.seal_gui:thousandsStepper(pawnItems[k] * 2) .. " $ / db")
        if not itemAmounts[k] then
          seexports.seal_gui:setImageColor(img, transp)
          seexports.seal_gui:setLabelColor(label, transp)
          seexports.seal_gui:setLabelColor(money, transp2)
        else
          seexports.seal_gui:setLabelColor(money, "primary")
          itemLabels[k] = seexports.seal_gui:createGuiElement("label", 242, 0, 32, 36, img)
          seexports.seal_gui:setLabelAlignment(itemLabels[k], "center", "center")
          seexports.seal_gui:setLabelFont(itemLabels[k], "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelText(itemLabels[k], "0")
          local btn = seexports.seal_gui:createGuiElement("button", 218, 6, 24, 24, img)
          seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "primary",
            "secondary"
          }, false, true)
          seexports.seal_gui:setClickEvent(btn, "changePawnItemAmount")
          seexports.seal_gui:setButtonFont(btn, "11/BebasNeueBold.otf")
          seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("minus", 24))
          itemMinusButtons[btn] = k
          local btn = seexports.seal_gui:createGuiElement("button", 274, 6, 24, 24, img)
          seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "primary",
            "secondary"
          }, false, true)
          seexports.seal_gui:setClickEvent(btn, "changePawnItemAmount")
          seexports.seal_gui:setButtonFont(btn, "11/BebasNeueBold.otf")
          seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("plus", 24))
          itemPlusButtons[btn] = k
          itemSelectedAmount[k] = 0
          refreshPawnItemAmounts(k)
        end
        if c % 2 == 0 then
          y = y + 48
          local border = seexports.seal_gui:createGuiElement("hr", 6, y - 1, 608, 2, window)
          seexports.seal_gui:setGuiHrColor(border, "grey3", "grey1")
        end
      end
      bigLabel = seexports.seal_gui:createGuiElement("label", 12, h - 48, 0, 48, window)
      seexports.seal_gui:setLabelAlignment(bigLabel, "left", "center")
      seexports.seal_gui:setLabelFont(bigLabel, "11/Ubuntu-R.ttf")
      seexports.seal_gui:setLabelText(bigLabel, "10 db, 200 000 $ - 300 000 $")
      refreshBigLabel()
      local btn = seexports.seal_gui:createGuiElement("button", 488, h - 24 - 12, 120, 24, window)
      seexports.seal_gui:setGuiBackground(btn, "solid", "primary")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "primary",
        "secondary"
      }, false, true)
      seexports.seal_gui:setClickEvent(btn, "sellPawnItems")
      seexports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
      seexports.seal_gui:setButtonText(btn, "Tárgyak eladása")
    end
  end