local screenX, screenY = guiGetScreenSize()
local sscNPCs = {
  {189,1568.76171875, -1608.3707275391, 568.83892822266,334,2,2},
  {189, 68.786178588867, 2054.8781738281, 51.0859375, 215, 1, 22},
}
local obj = createObject(7288, -1810.95, 901.4970703125, 27.75, 0, 0, 225)
setObjectScale(obj, 0.225)
setElementCollisionsEnabled(obj, false)
setElementDoubleSided(obj, true)
local sscNPCElements = {}
for i = 1, #sscNPCs do
  local npc = createPed(sscNPCs[i][1], sscNPCs[i][2], sscNPCs[i][3], sscNPCs[i][4], sscNPCs[i][5])
  setElementInterior(npc, sscNPCs[i][6])
  setElementDimension(npc, sscNPCs[i][7])
  setElementFrozen(npc, true)
  setElementData(npc, "invulnerable", true)
  setElementData(npc, "visibleName", "Pénztáros")
  setElementData(npc, "pedNameType", "SSC")
  sscNPCElements[npc] = i
end
local currentSSCPed = false
addEventHandler("onClientClick", getRootElement(), 
function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
  if state == "down" and not currentSSCPed then
    local i = sscNPCElements[clickedElement]
    if i then
      local x, y, z = getElementPosition(localPlayer)
      if 3 > getDistanceBetweenPoints3D(x, y, z, sscNPCs[i][2], sscNPCs[i][3], sscNPCs[i][4]) then
        currentSSCPed = clickedElement
        createSSCWindow()
      end
    end
  end
end, true, "high+9999999999")

local window = false
local amountBox = false
local amountSlider = false
local sscLabel = false
local buy = true

function deleteSSCWindow()
  amountBox = false
  amountSlider = false
  sscLabel = false
  if window then
    local x, y = exports.seal_gui:getGuiPosition(window)
    exports.seal_gui:deleteGuiElement(window)
    window = false
    return x, y
  end
end

addEvent("switchSSCWindowBuy", true)
addEventHandler("switchSSCWindowBuy", getRootElement(), 
function()
  buy = true
  createSSCWindow()
end)

addEvent("switchSSCWindowSell", true)
addEventHandler("switchSSCWindowSell", getRootElement(), 
function()
  buy = false
  createSSCWindow()
end)

function formatSSCLabel()
  if buy then
    exports.seal_gui:setLabelText(sscLabel, "[color=yellow]" .. exports.seal_gui:thousandsStepper(sscAmount) .. " SSC\n#ffffffFizetendő: [color=primary]" .. exports.seal_gui:thousandsStepper(sscAmount * 5) .. " $")
  else
    local tax = math.ceil(sscAmount * 5 * 0.1)
    exports.seal_gui:setLabelText(sscLabel, "[color=yellow]" .. exports.seal_gui:thousandsStepper(sscAmount) .. " SSC\n#ffffffAdó: [color=primary]" .. exports.seal_gui:thousandsStepper(tax) .. " $\n#ffffffVégösszeg: [color=primary]" .. exports.seal_gui:thousandsStepper(sscAmount * 5 - tax) .. " $")
  end
end

addEvent("changeSSCSlider", false)
addEventHandler("changeSSCSlider", getRootElement(), 
function(el, sliderValue, final)
  sscAmount = 1000 + math.floor(sliderValue * 499000 / 1000) * 1000
  exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
  formatSSCLabel()
end)

addEvent("changeSSCInput", false)
addEventHandler("changeSSCInput", getRootElement(), 
function(amount)
  sscAmount = tonumber(amount) or 0
  local slider = math.min(1, math.max(0, (sscAmount - 1000) / 499000))
  exports.seal_gui:setSliderValue(amountSlider, slider)
  formatSSCLabel()
end)

local lastSSCTry = 0

addEvent("sscCashierFinal", false)
addEventHandler("sscCashierFinal", getRootElement(), 
function(amount)
  if sscAmount < 1000 then
    sscAmount = 1000
    formatSSCLabel()
    exports.seal_hud:showInfobox("e", "Minimum összeg: 1 000 SSC")
    exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
  elseif sscAmount > 500000 then
    sscAmount = 500000
    formatSSCLabel()
    exports.seal_hud:showInfobox("e", "Maximum összeg: 500 000 SSC")
    exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
  else
    if getTickCount() - lastSSCTry < 10000 then
      exports.seal_hud:showInfobox("e", "Kérlek várj!")
      return
    end
    lastSSCTry = getTickCount()
    triggerServerEvent(buy and "buySSC" or "sellSSC", localPlayer, sscAmount)
  end
end)

addEvent("closeSSCWindow", false)
addEventHandler("closeSSCWindow", getRootElement(), 
function(amount)
  deleteSSCWindow()
  currentSSCPed = false
end)

addEventHandler("onActiveInputChange", getRootElement(), 
function(el, was)
  if was and was == amountBox then
    if sscAmount < 1000 then
      sscAmount = 1000
      formatSSCLabel()
      exports.seal_hud:showInfobox("e", "Minimum összeg: 1 000 SSC")
      exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
    elseif sscAmount > 500000 then
      sscAmount = 500000
      formatSSCLabel()
      exports.seal_hud:showInfobox("e", "Maximum összeg: 500 000 SSC")
      exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
    end
  end
end)

function createSSCWindow()
  sscAmount = 1000

  local x, y = deleteSSCWindow()
  local titleBarHeight = exports.seal_gui:getTitleBarHeight()
  local pw, ph = 350, titleBarHeight + 20 + 8 + 30 + 8 + 15 + 8 + 96 + 8 + 24 + 8

  window = exports.seal_gui:createGuiElement("window", x or screenX / 2 - pw / 2, y or screenY / 2 - ph / 2, pw, ph)
  exports.seal_gui:setWindowTitle(window, "16/BebasNeueRegular.otf", "SSC pénztár")
  exports.seal_gui:setWindowCloseButton(window, "closeSSCWindow")
  exports.seal_gui:setWindowElementMaxDistance(window, currentSSCPed, 3, "closeSSCWindow")

  local btn = exports.seal_gui:createGuiElement("button", 0, titleBarHeight - 1, pw / 2, 21, window)

  if buy then
    exports.seal_gui:setGuiBackground(btn, "solid", "grey2")
    exports.seal_gui:setGuiHoverable(btn, false)
  else
    exports.seal_gui:setGuiBackground(btn, "solid", "grey1")
    exports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
  end

  exports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
  exports.seal_gui:setButtonTextColor(btn, "#ffffff")
  exports.seal_gui:setButtonText(btn, "SSC vásárlás")
  exports.seal_gui:setClickEvent(btn, "switchSSCWindowBuy")

  local btn = exports.seal_gui:createGuiElement("button", pw / 2, titleBarHeight - 1, pw / 2, 21, window)

  if buy then
    exports.seal_gui:setGuiBackground(btn, "solid", "grey1")
    exports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey2"}, false, true)
  else
    exports.seal_gui:setGuiBackground(btn, "solid", "grey2")
    exports.seal_gui:setGuiHoverable(btn, false)
  end

  exports.seal_gui:setButtonFont(btn, "12/BebasNeueBold.otf")
  exports.seal_gui:setButtonTextColor(btn, "#ffffff")
  exports.seal_gui:setButtonText(btn, "SSC eladás")
  exports.seal_gui:setClickEvent(btn, "switchSSCWindowSell")

  local y = titleBarHeight + 20 + 8

  amountBox = exports.seal_gui:createGuiElement("input", pw / 2 - 100, y, 200, 30, window)
  exports.seal_gui:setInputPlaceholder(amountBox, "SSC összeg")
  exports.seal_gui:setInputValue(amountBox, tostring(sscAmount))
  exports.seal_gui:setInputColor(amountBox, "midgrey", "grey2", "grey4", "grey3", "lightgrey")
  exports.seal_gui:setInputFont(amountBox, "10/Ubuntu-R.ttf")
  exports.seal_gui:setInputIcon(amountBox, "coin")
  exports.seal_gui:setInputMaxLength(amountBox, 16)
  exports.seal_gui:setInputNumberOnly(amountBox, true)
  exports.seal_gui:setInputChangeEvent(amountBox, "changeSSCInput")

  y = y + 30 + 8

  amountSlider = exports.seal_gui:createGuiElement("slider", 8, y, pw - 16, 15, window)
  exports.seal_gui:setSliderChangeEvent(amountSlider, "changeSSCSlider")
  exports.seal_gui:setSliderValue(amountSlider, 0)

  y = y + 15 + 8

  sscLabel = exports.seal_gui:createGuiElement("label", 0, y, pw, 96, window)
  exports.seal_gui:setLabelFont(sscLabel, "12/Ubuntu-R.ttf")
  exports.seal_gui:setLabelAlignment(sscLabel, "center", "center")

  y = y + 96 + 8

  local btn = exports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, window)

  exports.seal_gui:setGuiBackground(btn, "solid", "primary")
  exports.seal_gui:setGuiHover(btn, "gradient", {"primary","secondary"}, false, true)
  exports.seal_gui:setButtonFont(btn, "14/BebasNeueBold.otf")
  exports.seal_gui:setButtonTextColor(btn, "#ffffff")
  exports.seal_gui:setButtonText(btn, buy and "Vásárlás" or "Eladás")
  exports.seal_gui:setClickEvent(btn, "sscCashierFinal")
  formatSSCLabel()
end