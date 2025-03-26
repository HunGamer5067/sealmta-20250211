local seexports = {
    seal_gui = false,
    seal_fuel = false,
    seal_speedo = false,
    seal_tuning = false
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
  heliWindow = false
  local menuButtons = {}
  local fuelPriceLabel = false
  local fuelSumLabel = false
  local fuelSlider = false
  local plateMode = false
  local plateInput = false
  local variantCheckboxes = {}
  local toReset = false
  local currentMenu = 1
  local bcgH1 = false
  local bcgH2 = false
  local bcgH3 = false
  local sliderH = false
  local bcgS1 = false
  local bcgS2 = false
  local sliderS = false
  local bcgL1 = false
  local bcgL2 = false
  local bcgL3 = false
  local sliderL = false
  local colorHexInput = false
  local colorPickerR, colorPickerG, colorPickerB
  function refreshColorPicker(refreshInput)
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      toReset = veh
      local h = seexports.seal_gui:getSliderValue(sliderH)
      local s = seexports.seal_gui:getSliderValue(sliderS)
      local l = seexports.seal_gui:getSliderValue(sliderL)
      local fR, fG, fB = convertHSLToRGB(h, s, l)
      seexports.seal_gui:setGuiBackground(bcgH1, "solid", {
        convertHSLToRGB(0, 0, l)
      })
      seexports.seal_gui:setImageColor(bcgH2, {
        255,
        255,
        255,
        s * 255
      })
      local r, g, b = convertHSLToRGB(0, 0, l)
      local a = math.abs(l - 0.5) / 0.5 * 255
      seexports.seal_gui:setGuiBackground(bcgH3, "solid", {
        r,
        g,
        b,
        a
      })
      seexports.seal_gui:setGuiBackground(bcgS1, "solid", {
        convertHSLToRGB(h, 0, l)
      })
      seexports.seal_gui:setImageColor(bcgS2, {
        convertHSLToRGB(h, 1, l)
      })
      seexports.seal_gui:setImageColor(bcgL3, {
        convertHSLToRGB(h, s, 0.5)
      })
      local col = {
        fR,
        fG,
        fB
      }
      colorPickerR, colorPickerG, colorPickerB = fR, fG, fB
      seexports.seal_gui:setSliderColor(sliderH, {
        0,
        0,
        0,
        0
      }, col)
      seexports.seal_gui:setSliderColor(sliderS, {
        0,
        0,
        0,
        0
      }, col)
      seexports.seal_gui:setSliderColor(sliderL, {
        0,
        0,
        0,
        0
      }, col)
      local hex = utf8.sub(seexports.seal_gui:getColorCodeHex(col), 2, 7)
      if refreshInput then
        seexports.seal_gui:setInputValue(colorHexInput, hex)
      end
      local col = {
        getVehicleColor(veh, true)
      }
      if currentMenu == 5 then
        col[1], col[2], col[3] = fR, fG, fB
        setVehicleColor(veh, unpack(col))
      elseif currentMenu == 6 then
        col[4], col[5], col[6] = fR, fG, fB
        setVehicleColor(veh, unpack(col))
      end
    end
  end
  addEvent("heliColorPickerChanged", false)
  addEventHandler("heliColorPickerChanged", getRootElement(), function()
    refreshColorPicker(true)
  end)
  addEvent("refreshHeliPickerInput", false)
  addEventHandler("refreshHeliPickerInput", getRootElement(), function(val)
    seexports.seal_gui:setInputValue(colorHexInput, utf8.upper(val))
    local r = tonumber("0x" .. val:sub(1, 2))
    local g = tonumber("0x" .. val:sub(3, 4))
    local b = tonumber("0x" .. val:sub(5, 6))
    if r and g and b then
      local h, s, l = convertRGBToHSL(r, g, b)
      seexports.seal_gui:setSliderValue(sliderH, h)
      seexports.seal_gui:setSliderValue(sliderS, s)
      seexports.seal_gui:setSliderValue(sliderL, l)
      refreshColorPicker()
    end
  end)
  function deleteHeliWindow(noReset)
    if toReset and not noReset then
      triggerServerEvent("resetHelicopterFix", localPlayer, toReset)
      toReset = false
    end
    if heliWindow then
      seexports.seal_gui:deleteGuiElement(heliWindow)
      menuButtons = {}
      fuelPriceLabel = false
      fuelSumLabel = false
      fuelSlider = false
      plateInput = false
      bcgH1 = false
      bcgH2 = false
      bcgH3 = false
      sliderH = false
      bcgS1 = false
      bcgS2 = false
      sliderS = false
      bcgL1 = false
      bcgL2 = false
      bcgL3 = false
      sliderL = false
      colorHexInput = false
      variantCheckboxes = {}
      removeEventHandler("onClientPlayerVehicleExit", localPlayer, deleteExitHeli)
    end
    heliWindow = false
  end
  function deleteExitHeli()
    deleteHeliWindow()
  end
  addEventHandler("onClientResourceStop", getResourceRootElement(), function()
    deleteHeliWindow()
  end)
  addEvent("changeHeliServiceMenu", false)
  addEventHandler("changeHeliServiceMenu", getRootElement(), function(button, state, absoluteX, absoluteY, el)
    if menuButtons[el] then
      currentMenu = menuButtons[el]
      createHeliWindow()
    end
  end)
  local customPlate = false
  local fuelLiter = 0
  function refreshHeliFuelPrice()
    if fuelPriceLabel and fuelSumLabel and fuelSlider then
      local price = seexports.seal_fuel:getHeliFuelPrices()
      seexports.seal_gui:setLabelText(fuelPriceLabel, "Üzemanyagár: [color=green]" .. price .. " $ / liter")
      local fuel, fuelMax = seexports.seal_speedo:getFuel()
      if fuel and fuelMax then
        local maxAmount = fuelMax - fuel
        fuelLiter = (seexports.seal_gui:getSliderValue(fuelSlider) or 0) * maxAmount
        fuelLiter = math.floor(fuelLiter * 10) / 10
        local sumPrice = math.ceil(fuelLiter * price)
        seexports.seal_gui:setLabelText(fuelSumLabel, "Összesen: [color=blue]" .. fuelLiter .. " liter\n#ffffffVégösszeg: [color=green]" .. seexports.seal_gui:thousandsStepper(sumPrice) .. " $")
      end
    end
  end
  addEvent("changeHeliFuelSlider", false)
  addEventHandler("changeHeliFuelSlider", getRootElement(), refreshHeliFuelPrice)
  addEvent("switchHeliPlateMode", false)
  addEventHandler("switchHeliPlateMode", getRootElement(), function()
    plateMode = not plateMode
    createHeliWindow()
  end)
  addEvent("helicopterReapirShowPrompt", false)
  addEventHandler("helicopterReapirShowPrompt", getRootElement(), function()
    if currentMenu == 2 then
      if fuelLiter <= 0 then
        seexports.seal_gui:showInfobox("e", "0 litert nem tankolhatsz!")
        return
      end
    elseif currentMenu == 3 and plateMode then
      customPlate = seexports.seal_gui:getInputValue(plateInput)
      if 0 >= utf8.len(customPlate) then
        seexports.seal_gui:showInfobox("e", "Nem lehet üres a rendszám mező!")
        return
      end
    end
    deleteHeliWindow(true)
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh ~= toReset and toReset then
      triggerServerEvent("resetHelicopterFix", localPlayer, toReset)
      toReset = false
    end
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
      local pw = 350
      local ph = titleBarHeight + 8 + 24 + 8 + 96 + 8
      heliWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      local title = ""
      if getVehicleType(veh) == "Boat" then
        title = "Hajó - "
      else
        title = "Helikopter - "
      end
      if currentMenu == 1 then
        title = title .. "Javítás"
      elseif currentMenu == 2 then
        title = title .. "Tankolás"
      elseif currentMenu == 3 then
        title = title .. "Rendszám"
      elseif currentMenu == 4 then
        title = title .. "Variáns"
      elseif currentMenu == 5 then
        title = title .. "Fényezés (#1)"
      elseif currentMenu == 6 then
        title = title .. "Fényezés (#2)"
      end
      seexports.seal_gui:setWindowTitle(heliWindow, "16/BebasNeueRegular.otf", title)
      local y = titleBarHeight + 8
      local bw = (pw - 24) / 2
      local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      seexports.seal_gui:setLabelAlignment(label, "center", "center")
      seexports.seal_gui:setLabelText(label, "Biztosan szeretnéd megvásárolni?")
      y = y + 32
      if currentMenu == 1 then
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelColor(label, "blue")
        seexports.seal_gui:setLabelText(label, "Javítás")
        y = y + 32
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]" .. seexports.seal_gui:thousandsStepper(getItemPrice(veh, heliFixPrice)) .. " $")
        y = y + 32 + 8
      elseif currentMenu == 2 then
        local price = seexports.seal_fuel:getHeliFuelPrices()
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelColor(label, "blue")
        seexports.seal_gui:setLabelText(label, fuelLiter .. " liter üzemanyag (" .. price .. " $/l)")
        y = y + 32
        local sumPrice = math.ceil(fuelLiter * price)
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]" .. seexports.seal_gui:thousandsStepper(sumPrice) .. " $")
        y = y + 32 + 8
      elseif currentMenu == 3 then
        if plateMode then
          local price = seexports.seal_tuning:getTuningPrice("customPlate", true)[2]
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelColor(label, "blue")
          seexports.seal_gui:setLabelText(label, "Egyedi rendszám")
          y = y + 32
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelText(label, "Fizetendő: [color=blue]" .. seexports.seal_gui:thousandsStepper(price) .. " PP")
          y = y + 32 + 8
        else
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelColor(label, "blue")
          seexports.seal_gui:setLabelText(label, "Gyári rendszám")
          y = y + 32
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]ingyenes")
          y = y + 32 + 8
        end
      elseif currentMenu == 4 then
        local price = seexports.seal_tuning:getTuningPrice("variant", 1)[2]
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelColor(label, "blue")
        if selectedVariant == 0 then
          seexports.seal_gui:setLabelText(label, "Variáns (nincs)")
        else
          seexports.seal_gui:setLabelText(label, "Variáns (" .. selectedVariant .. ")")
        end
        y = y + 32
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]" .. seexports.seal_gui:thousandsStepper(price) .. " $")
        y = y + 32 + 8
      elseif currentMenu == 5 then
        local price = seexports.seal_tuning:getTuningPrice("color", 1)[2]
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelColor(label, "blue")
        seexports.seal_gui:setLabelText(label, "Fényezés - #1")
        y = y + 32
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]" .. seexports.seal_gui:thousandsStepper(price) .. " $")
        y = y + 32 + 8
      elseif currentMenu == 6 then
        local price = seexports.seal_tuning:getTuningPrice("color", 1)[2]
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelColor(label, "blue")
        seexports.seal_gui:setLabelText(label, "Fényezés - #2")
        y = y + 32
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Fizetendő: [color=green]" .. seexports.seal_gui:thousandsStepper(price) .. " $")
        y = y + 32 + 8
      end
      local btn = seexports.seal_gui:createGuiElement("button", 8, y, bw, 24, heliWindow)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
      seexports.seal_gui:setButtonText(btn, "Igen")
      seexports.seal_gui:setGuiBackground(btn, "solid", "green")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "green",
        "green-second"
      }, false, true)
      seexports.seal_gui:setClickEvent(btn, "helicopterReapirPromptYes")
      local btn = seexports.seal_gui:createGuiElement("button", pw / 2 + 4, y, bw, 24, heliWindow)
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
      seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
      seexports.seal_gui:setButtonText(btn, "Nem")
      seexports.seal_gui:setGuiBackground(btn, "solid", "red")
      seexports.seal_gui:setGuiHover(btn, "gradient", {
        "red",
        "red-second"
      }, false, true)
      seexports.seal_gui:setClickEvent(btn, "helicopterReapirPromptNo")
    end
    if heliWindow then
      addEventHandler("onClientPlayerVehicleExit", localPlayer, deleteExitHeli)
    end
  end)
  addEvent("helicopterReapirPromptYes", false)
  addEventHandler("helicopterReapirPromptYes", getRootElement(), function()
    deleteHeliWindow(true)
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh ~= toReset and toReset then
      triggerServerEvent("resetHelicopterFix", localPlayer, toReset)
      toReset = false
    end
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
      local pw = 350
      local ph = titleBarHeight + 32
      heliWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      local title = ""
      if getVehicleType(veh) == "Boat" then
        title = "Hajó - "
      else
        title = "Helikopter - "
      end
      if currentMenu == 1 then
        title = title .. "Javítás"
      elseif currentMenu == 2 then
        title = title .. "Tankolás"
      elseif currentMenu == 3 then
        title = title .. "Rendszám"
      elseif currentMenu == 4 then
        title = title .. "Variáns"
      elseif currentMenu == 5 then
        title = title .. "Fényezés (#1)"
      elseif currentMenu == 6 then
        title = title .. "Fényezés (#2)"
      end
      seexports.seal_gui:setWindowTitle(heliWindow, "16/BebasNeueRegular.otf", title)
      local y = titleBarHeight
      local bw = (pw - 24) / 2
      local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
      seexports.seal_gui:setLabelAlignment(label, "center", "center")
      seexports.seal_gui:setLabelText(label, "Vásárlás folyamatban...")
      if currentMenu == 1 then
        triggerServerEvent("helicopterRepairJob", localPlayer)
      elseif currentMenu == 2 then
        triggerServerEvent("helicopterFueling", localPlayer, fuelLiter)
      elseif currentMenu == 3 then
        triggerServerEvent("buyHelicopterPlate", localPlayer, plateMode and customPlate or false)
      elseif currentMenu == 4 then
        triggerServerEvent("helicopterVariant", localPlayer, selectedVariant)
      elseif currentMenu == 5 then
        triggerServerEvent("helicopterColor", localPlayer, 1, colorPickerR, colorPickerG, colorPickerB)
      elseif currentMenu == 6 then
        triggerServerEvent("helicopterColor", localPlayer, 2, colorPickerR, colorPickerG, colorPickerB)
      end
    end
  end)
  addEvent("gotHeliFixResponse", true)
  addEventHandler("gotHeliFixResponse", getRootElement(), function()
    if heliWindow then
      createHeliWindow()
    end
  end)
  addEvent("helicopterReapirPromptNo", false)
  addEventHandler("helicopterReapirPromptNo", getRootElement(), function()
    createHeliWindow()
  end)
  addEvent("heliVariantChanged", false)
  addEventHandler("heliVariantChanged", getRootElement(), function(button, state, absoluteX, absoluteY, el)
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      local val = 0
      for i = 0, 6 do
        if variantCheckboxes[i] == el then
          seexports.seal_gui:setCheckboxChecked(variantCheckboxes[i], true)
          val = i
        else
          seexports.seal_gui:setCheckboxChecked(variantCheckboxes[i], false)
        end
      end
      if 0 < val then
        setVehicleVariant(veh, val - 1, 255)
      else
        setVehicleVariant(veh, 255, 255)
      end
      selectedVariant = val
      toReset = veh
      triggerServerEvent("previewHelicopterVariant", localPlayer, veh, val)
    end
  end)
  function createHeliWindow()
    deleteHeliWindow(true)
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh ~= toReset and toReset then
      triggerServerEvent("resetHelicopterFix", localPlayer, toReset)
      toReset = false
    end
    if veh and getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Helicopter" or getVehicleType(veh) == "Boat") and getElementData(veh, "vehicle.dbID") then
      local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
      local pw = 300
      local ph = titleBarHeight + 30
      if currentMenu == 1 then
        ph = ph + 96 + 8
      elseif currentMenu == 2 then
        ph = ph + 160 + 8
      elseif currentMenu == 3 then
        ph = ph + 8 + 24 + 8
        if plateMode then
          ph = ph + 32 + 8
        end
        ph = ph + 64 + 8
      elseif currentMenu == 4 then
        ph = ph + 168 + 64 + 8
      elseif currentMenu == 5 or currentMenu == 6 then
        ph = ph + 48 + 60 + 24 + 64
      end
      heliWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      local title = ""
      if getVehicleType(veh) == "Boat" then
        title = "Hajó - "
      else
        title = "Helikopter - "
      end
      if currentMenu == 1 then
        title = title .. "Javítás"
      elseif currentMenu == 2 then
        title = title .. "Tankolás"
      elseif currentMenu == 3 then
        title = title .. "Rendszám"
      elseif currentMenu == 4 then
        title = title .. "Variáns"
      elseif currentMenu == 5 then
        title = title .. "Fényezés (#1)"
      elseif currentMenu == 6 then
        title = title .. "Fényezés (#2)"
      end
      seexports.seal_gui:setWindowTitle(heliWindow, "16/BebasNeueRegular.otf", title)
      y = titleBarHeight + 30
      if currentMenu == 1 then
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        local health = getElementHealth(veh)
        local r, g, b = getPartColor(health / 10)
        seexports.seal_gui:setLabelText(label, "Állapot: " .. rgbToHex(r, g, b) .. math.floor(health / 10) .. " %")
        y = y + 32
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Javítás ára: [color=green]" .. seexports.seal_gui:thousandsStepper(getItemPrice(veh, heliFixPrice)) .. " $")
        y = y + 32 + 8
        local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
        seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        seexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Javítás")
        seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
      elseif currentMenu == 2 then
        fuelPriceLabel = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(fuelPriceLabel, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(fuelPriceLabel, "center", "center")
        y = y + 32
        fuelSlider = seexports.seal_gui:createGuiElement("slider", 8, y + 16 - 8, pw - 16, 16, heliWindow)
        seexports.seal_gui:setSliderChangeEvent(fuelSlider, "changeHeliFuelSlider")
        y = y + 32
        fuelSumLabel = seexports.seal_gui:createGuiElement("label", 0, y, pw, 64, heliWindow)
        seexports.seal_gui:setLabelFont(fuelSumLabel, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(fuelSumLabel, "center", "center")
        y = y + 64 + 8
        local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
        seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        seexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Tankolás")
        seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
        refreshHeliFuelPrice()
      elseif currentMenu == 3 then
        y = y + 8
        local bw = (pw - 24) / 2
        local btn = seexports.seal_gui:createGuiElement("button", 8, y, bw, 24, heliWindow)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Gyári")
        if plateMode then
          seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
          seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
          seexports.seal_gui:setClickEvent(btn, "switchHeliPlateMode")
        else
          seexports.seal_gui:setGuiHoverable(btn, false)
          seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        end
        local btn = seexports.seal_gui:createGuiElement("button", pw / 2 + 4, y, bw, 24, heliWindow)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Egyedi")
        if not plateMode then
          seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
          seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
          seexports.seal_gui:setClickEvent(btn, "switchHeliPlateMode")
        else
          seexports.seal_gui:setGuiHoverable(btn, false)
          seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        end
        y = y + 24 + 8
        if plateMode then
          plateInput = seexports.seal_gui:createGuiElement("input", 8, y, pw - 16, 32, heliWindow)
          seexports.seal_gui:setInputFont(plateInput, "10/Ubuntu-R.ttf")
          seexports.seal_gui:setInputPlaceholder(plateInput, "Rendszám")
          seexports.seal_gui:setInputValue(plateInput, getVehiclePlateText(veh))
          seexports.seal_gui:setInputIcon(plateInput, "car")
          seexports.seal_gui:setInputMaxLength(plateInput, 8)
          y = y + 32 + 8
          local price = seexports.seal_tuning:getTuningPrice("customPlate", true)[2]
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelText(label, "Ár: [color=blue]" .. seexports.seal_gui:thousandsStepper(price) .. " PP")
          y = y + 32 + 8
          local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
          seexports.seal_gui:setGuiBackground(btn, "solid", "green")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "green",
            "green-second"
          }, false, true)
          seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
          seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
          seexports.seal_gui:setButtonText(btn, "Megvásárlás")
          seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
        else
          local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelAlignment(label, "center", "center")
          seexports.seal_gui:setLabelText(label, "Ár: [color=green]ingyenes")
          y = y + 32 + 8
          local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
          seexports.seal_gui:setGuiBackground(btn, "solid", "green")
          seexports.seal_gui:setGuiHover(btn, "gradient", {
            "green",
            "green-second"
          }, false, true)
          seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
          seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
          seexports.seal_gui:setButtonText(btn, "Megvásárlás")
          seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
        end
      elseif currentMenu == 4 then
        variantCheckboxes[0] = seexports.seal_gui:createGuiElement("checkbox", 8, y, 24, 24, heliWindow)
        seexports.seal_gui:setGuiColorScheme(variantCheckboxes[0], "darker")
        seexports.seal_gui:setClickEvent(variantCheckboxes[0], "heliVariantChanged")
        local label = seexports.seal_gui:createGuiElement("label", 36, y, 0, 24, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "left", "center")
        seexports.seal_gui:setLabelText(label, "Nincs variáns")
        y = y + 24
        for i = 1, 6 do
          variantCheckboxes[i] = seexports.seal_gui:createGuiElement("checkbox", 8, y, 24, 24, heliWindow)
          seexports.seal_gui:setGuiColorScheme(variantCheckboxes[i], "darker")
          seexports.seal_gui:setClickEvent(variantCheckboxes[i], "heliVariantChanged")
          local label = seexports.seal_gui:createGuiElement("label", 36, y, 0, 24, heliWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
          seexports.seal_gui:setLabelAlignment(label, "left", "center")
          seexports.seal_gui:setLabelText(label, i .. ". variáns")
          y = y + 24
        end
        local var = getVehicleVariant(veh)
        if 0 <= var and var <= 6 then
          var = var + 1
        else
          var = 0
        end
        selectedVariant = var
        seexports.seal_gui:setCheckboxChecked(variantCheckboxes[var], true)
        local price = seexports.seal_tuning:getTuningPrice("variant", 1)[2]
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Ár: [color=green]" .. seexports.seal_gui:thousandsStepper(price) .. " $")
        y = y + 32 + 8
        local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
        seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        seexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Megvásárlás")
        seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
      elseif currentMenu == 5 or currentMenu == 6 then
        local x = 0
        y = y + 8
        bcgH1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        bcgH2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        seexports.seal_gui:setImageDDS(bcgH2, ":seal_tuning/files/col3.dds")
        bcgH3 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        sliderH = seexports.seal_gui:createGuiElement("slider", x + 8, y, pw - 16, 20, heliWindow)
        seexports.seal_gui:setSliderSize(sliderH, 20)
        seexports.seal_gui:setSliderBorder(sliderH, {
          0,
          0,
          0
        }, 1)
        seexports.seal_gui:setSliderChangeEvent(sliderH, "heliColorPickerChanged")
        y = y + 20 + 8
        bcgS1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        bcgS2 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        seexports.seal_gui:setImageDDS(bcgS2, ":seal_tuning/files/col1.dds")
        sliderS = seexports.seal_gui:createGuiElement("slider", x + 8, y, pw - 16, 20, heliWindow)
        seexports.seal_gui:setSliderSize(sliderS, 20)
        seexports.seal_gui:setSliderBorder(sliderS, {
          0,
          0,
          0
        }, 1)
        seexports.seal_gui:setSliderChangeEvent(sliderS, "heliColorPickerChanged")
        y = y + 20 + 8
        bcgL1 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10, y + 10 - 6, (pw - 16 - 20) / 2, 12, heliWindow)
        seexports.seal_gui:setGuiBackground(bcgL1, "solid", {
          0,
          0,
          0
        })
        bcgL2 = seexports.seal_gui:createGuiElement("rectangle", x + 8 + 10 + (pw - 16 - 20) / 2, y + 10 - 6, (pw - 16 - 20) / 2, 12, heliWindow)
        seexports.seal_gui:setGuiBackground(bcgL2, "solid", {
          255,
          255,
          255
        })
        bcgL3 = seexports.seal_gui:createGuiElement("image", x + 8 + 10, y + 10 - 6, pw - 16 - 20, 12, heliWindow)
        seexports.seal_gui:setImageDDS(bcgL3, ":seal_tuning/files/col2.dds")
        sliderL = seexports.seal_gui:createGuiElement("slider", x + 8, y, pw - 16, 20, heliWindow)
        seexports.seal_gui:setSliderSize(sliderL, 20)
        seexports.seal_gui:setSliderBorder(sliderL, {
          0,
          0,
          0
        }, 1)
        seexports.seal_gui:setSliderChangeEvent(sliderL, "heliColorPickerChanged")
        y = y + 20 + 8
        colorHexInput = seexports.seal_gui:createGuiElement("input", x + pw / 2 - 50, y, 100, 24, heliWindow)
        seexports.seal_gui:setInputPlaceholder(colorHexInput, "HEX színkód")
        seexports.seal_gui:setInputValue(colorHexInput, "FF0000")
        seexports.seal_gui:setInputFont(colorHexInput, "10/Ubuntu-R.ttf")
        seexports.seal_gui:setInputIcon(colorHexInput, "hashtag")
        seexports.seal_gui:setInputMaxLength(colorHexInput, 6)
        seexports.seal_gui:setInputChangeEvent(colorHexInput, "refreshHeliPickerInput")
        local h, s, l = 0, 0, 1
        local col = {
          getVehicleColor(veh, true)
        }
        if currentMenu == 5 then
          h, s, l = convertRGBToHSL(col[1], col[2], col[3])
        elseif currentMenu == 6 then
          h, s, l = convertRGBToHSL(col[4], col[5], col[6])
        end
        seexports.seal_gui:setSliderValue(sliderH, h)
        seexports.seal_gui:setSliderValue(sliderS, s)
        seexports.seal_gui:setSliderValue(sliderL, l)
        refreshColorPicker(true)
        y = y + 24 + 8
        local price = seexports.seal_tuning:getTuningPrice("color", 1)[2]
        local label = seexports.seal_gui:createGuiElement("label", 0, y, pw, 32, heliWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Ár: [color=green]" .. seexports.seal_gui:thousandsStepper(price) .. " $")
        y = y + 32 + 8
        local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, 24, heliWindow)
        seexports.seal_gui:setGuiBackground(btn, "solid", "green")
        seexports.seal_gui:setGuiHover(btn, "gradient", {
          "green",
          "green-second"
        }, false, true)
        seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
        seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
        seexports.seal_gui:setButtonText(btn, "Megvásárlás")
        seexports.seal_gui:setClickEvent(btn, "helicopterReapirShowPrompt")
      end
      local w = pw / 6
      local x = 0
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 1 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 1
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("wrench", 30))
      seexports.seal_gui:guiSetTooltip(btn, "Javítás")
      x = x + w
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 2 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 2
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIcon(btn, seexports.seal_gui:getFaIconFilename("gas-pump", 30))
      seexports.seal_gui:guiSetTooltip(btn, "Tankolás")
      x = x + w
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 3 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 3
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIconDDS(btn, ":seal_tuning/files/icons/plate.dds")
      seexports.seal_gui:guiSetTooltip(btn, "Rendszám")
      x = x + w
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 4 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 4
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIconDDS(btn, ":seal_tuning/files/icons/variant.dds")
      seexports.seal_gui:guiSetTooltip(btn, "Variáns")
      x = x + w
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 5 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 5
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIconDDS(btn, ":seal_tuning/files/icons/fenyezes.dds")
      seexports.seal_gui:guiSetTooltip(btn, "Fényezés (#1)")
      x = x + w
      local btn = seexports.seal_gui:createGuiElement("button", x, titleBarHeight - 1, w, 31, heliWindow)
      if currentMenu == 6 then
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey2")
        seexports.seal_gui:setGuiHoverable(btn, false)
      else
        seexports.seal_gui:setGuiBackground(btn, "solid", "grey1")
        seexports.seal_gui:setGuiHover(btn, "gradient", {"grey1", "grey3"}, false, true)
        seexports.seal_gui:setClickEvent(btn, "changeHeliServiceMenu")
        menuButtons[btn] = 6
      end
      seexports.seal_gui:setButtonFont(btn, "13/BebasNeueRegular.otf")
      seexports.seal_gui:setButtonIconDDS(btn, ":seal_tuning/files/icons/fenyezes.dds")
      seexports.seal_gui:guiSetTooltip(btn, "Fényezés (#2)")
      x = x + w
      local model = getElementModel(veh)
    end
    if heliWindow then
      addEventHandler("onClientPlayerVehicleExit", localPlayer, deleteExitHeli)
    end
  end
  