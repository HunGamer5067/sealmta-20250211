local seexports = {seal_gui = false, seal_vehiclenames = false}
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
bikeWindow = false
local checkboxes = {}
local labels = {}
local sumLabel = false
local bikeButtons = {}
function deleteBikeWindow()
  if bikeWindow then
    seexports.seal_gui:deleteGuiElement(bikeWindow)
    checkboxes = {}
    labels = {}
    sumLabel = false
    bikeButtons = {}
    removeEventHandler("onClientPlayerVehicleEnter", localPlayer, createBikeWindow)
    removeEventHandler("onClientPlayerVehicleExit", localPlayer, createBikeWindow)
  end
  bikeWindow = false
end
function refreshRepairSums()
  local veh = getPedOccupiedVehicle(localPlayer)
  if getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Automobile") and getElementData(veh, "vehicle.dbID") then
    local sum = 0
    local sumTime = 0
    for i = 1, #bikeOptions do
      if seexports.seal_gui:isCheckboxChecked(checkboxes[i]) then
        sumTime = sumTime + bikeOptions[i].time
        sum = sum + getItemPrice(veh, bikeOptions[i].price)
      end
    end
    local hours = math.floor(sumTime)
    local minutes = sumTime * 60 - hours * 60
    local time = ""
    if 0 < hours then
      time = hours .. " óra "
    end
    if 0 < minutes then
      time = time .. minutes .. " perc "
    elseif hours <= 0 then
      time = "0 perc "
    end
    seexports.seal_gui:setLabelText(sumLabel, time .. "#ffffff/ [color=green]" .. seexports.seal_gui:thousandsStepper(sum) .. " $")
  else
    deleteBikeWindow()
  end
end
addEvent("bikeRepairChanged", false)
addEventHandler("bikeRepairChanged", getRootElement(), refreshRepairSums)
addEvent("gotBikeConditions", true)
addEventHandler("gotBikeConditions", getRootElement(), function(bike, dat)
  if bikeWindow then
    local veh = getPedOccupiedVehicle(localPlayer)
    if getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Automobile") and getElementData(veh, "vehicle.dbID") and veh == bike then
      for i = 1, #bikeOptions do
        if dat[i] then
          if tonumber(dat[i]) then
            local r, g, b = getPartColor(dat[i])
            seexports.seal_gui:setLabelText(labels[i], "Állapot: " .. rgbToHex(r, g, b) .. dat[i] .. " %")
          elseif bikeOptions[i].part == "oil" then
            local r, g, b = getPartColor(dat[i][1])
            seexports.seal_gui:setLabelText(labels[i], "Következő olajcsere: " .. rgbToHex(r, g, b) .. dat[i][2] .. " km")
          else
            local r, g, b = getPartColor(dat[i][1])
            local r2, g2, b2 = getPartColor(dat[i][2])
            local r3, g3, b3 = getPartColor(dat[i][3])
            local r4, g4, b4 = getPartColor(dat[i][4])
            seexports.seal_gui:setLabelText(labels[i], "Bal első: " .. rgbToHex(r, g, b) .. dat[i][1] .. " %#ffffff, Bal hátsó: " .. rgbToHex(r2, g2, b2) .. dat[i][2] .. "%\n#ffffffJobb első: " .. rgbToHex(r3, g3, b3) .. dat[i][3] .. "% #ffffffJobb hátsó: " .. rgbToHex(r4, g4, b4) .. dat[i][4] .." %")
          end
        end
      end
    end
  end
end)
addEvent("finalAcceptBikeRepair", true)
addEventHandler("finalAcceptBikeRepair", getRootElement(), function()
  local veh = getPedOccupiedVehicle(localPlayer)
  if getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Automobile") and getElementData(veh, "vehicle.dbID") then
    local options = {}
    local c = 0
    for i = 1, #bikeOptions do
      options[i] = seexports.seal_gui:isCheckboxChecked(checkboxes[i]) or nil
      if options[i] then
        c = c + 1
      end
    end
    if c <= 0 then
      seexports.seal_gui:showInfobox("e", "Legalább egy lehetőséged válassz ki!")
      return
    end
    triggerServerEvent("acceptBikeRepairOffer", localPlayer, veh, options)
    deleteBikeWindow()
  end
end)
bikeList = false
function bikeSortFunction(a, b)
  return a[3] < b[3]
end
addEvent("gotServiceBikeList", true)
addEventHandler("gotServiceBikeList", getRootElement(), function(dat)
  if inBikeMarker then
    bikeList = dat
    table.sort(bikeList, bikeSortFunction)
    createBikeWindow()
  end
end)
addEvent("pickUpBikeInSerivce", false)
addEventHandler("pickUpBikeInSerivce", getRootElement(), function(button, state, absoluteX, absoluteY, el)
  if bikeButtons[el] then
    triggerServerEvent("pickUpBikeInSerivce", localPlayer, bikeButtons[el])
    deleteBikeWindow()
  end
end)
function createBikeWindow()
  deleteBikeWindow()
  local titleBarHeight = seexports.seal_gui:getTitleBarHeight()
  local veh = getPedOccupiedVehicle(localPlayer)
  if not veh then
    if bikeList then
      if #bikeList > 0 then
        bikeButtons = {}
        local pw = 350
        local ph = titleBarHeight + 56 * (#bikeList - 1) + 48
        bikeWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
        seexports.seal_gui:setWindowTitle(bikeWindow, "16/BebasNeueRegular.otf", "Jármű szerviz")
        local y = titleBarHeight
        for i = 1, #bikeList do
          local label = seexports.seal_gui:createGuiElement("label", 8, y, pw, 24, bikeWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
          seexports.seal_gui:setLabelAlignment(label, "left", "center")
          seexports.seal_gui:setLabelText(label, "#" .. bikeList[i][1])
          seexports.seal_gui:setLabelWordBreak(label, true)
          local label = seexports.seal_gui:createGuiElement("label", 8, y + 24, 0, 24, bikeWindow)
          seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
          seexports.seal_gui:setLabelAlignment(label, "left", "center")
          seexports.seal_gui:setLabelText(label, seexports.seal_vehiclenames:getCustomVehicleName(bikeList[i][2]))
          --iprint(bikeList[i])
          if 0 < bikeList[i][3] then
            local hours = math.floor(bikeList[i][3] / 60)
            local minutes = bikeList[i][3] - hours * 60
            local time = ""
            if 0 < hours then
              time = hours .. " óra"
            end
            if 0 < minutes then
              time = time .. " " .. minutes .. " perc"
            end
            local label = seexports.seal_gui:createGuiElement("label", 0, y, pw - 8, 48, bikeWindow)
            seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
            seexports.seal_gui:setLabelAlignment(label, "right", "center")
            seexports.seal_gui:setLabelColor(label, "blue")
            seexports.seal_gui:setLabelText(label, time)
          else
            local btn = seexports.seal_gui:createGuiElement("button", pw - 8 - 75, y + 24 - 12, 75, 24, bikeWindow)
            seexports.seal_gui:setGuiBackground(btn, "solid", "green")
            seexports.seal_gui:setGuiHover(btn, "gradient", {
              "green",
              "green-second"
            }, false, true)
            seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
            seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
            seexports.seal_gui:setButtonText(btn, "Átvétel")
            seexports.seal_gui:setClickEvent(btn, "pickUpBikeInSerivce")
            bikeButtons[btn] = bikeList[i][1]
          end
          y = y + 48
          if i < #bikeList then
            y = y + 4
            local border = seexports.seal_gui:createGuiElement("hr", 8, y - 1, pw - 16, 2, bikeWindow)
            y = y + 4
          end
        end
      else
        local pw = 350
        local ph = titleBarHeight + 48
        bikeWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
        seexports.seal_gui:setWindowTitle(bikeWindow, "16/BebasNeueRegular.otf", "Jármű szerviz")
        local label = seexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight, bikeWindow)
        seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
        seexports.seal_gui:setLabelAlignment(label, "center", "center")
        seexports.seal_gui:setLabelText(label, "Nincsen leadott Járműved!")
      end
    else
      local pw = 350
      local ph = titleBarHeight + 48
      bikeWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
      seexports.seal_gui:setWindowTitle(bikeWindow, "16/BebasNeueRegular.otf", "Jármű szerviz")
      local label = seexports.seal_gui:createGuiElement("label", 0, titleBarHeight, pw, ph - titleBarHeight, bikeWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelAlignment(label, "center", "center")
      seexports.seal_gui:setLabelText(label, "Betöltés folyamatban...")
    end
  elseif getVehicleController(veh) == localPlayer and (getVehicleType(veh) == "Bike" or getVehicleType(veh) == "Quad" or getVehicleType(veh) == "Automobile") and getElementData(veh, "vehicle.dbID") then
    triggerServerEvent("requestBikeConditions", localPlayer)
    local pw = 350
    local ph = titleBarHeight + 56 * #bikeOptions + 24 + 32 + 8
    bikeWindow = seexports.seal_gui:createGuiElement("window", screenX / 2 - pw / 2, screenY / 2 - ph / 2, pw, ph)
    seexports.seal_gui:setWindowTitle(bikeWindow, "16/BebasNeueRegular.otf", "Jármű szerviz")
    checkboxes = {}
    local y = titleBarHeight
    for i = 1, #bikeOptions do
      checkboxes[i] = seexports.seal_gui:createGuiElement("checkbox", 8, y, 24, 24, bikeWindow)
      seexports.seal_gui:setGuiColorScheme(checkboxes[i], "darker")
      seexports.seal_gui:setClickEvent(checkboxes[i], "bikeRepairChanged")
      local label = seexports.seal_gui:createGuiElement("label", 36, y, 0, 24, bikeWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelAlignment(label, "left", "center")
      seexports.seal_gui:setLabelText(label, bikeOptions[i].name)
      labels[i] = seexports.seal_gui:createGuiElement("label", 8, y + 24, 0, 24, bikeWindow)
      seexports.seal_gui:setLabelFont(labels[i], "10/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelAlignment(labels[i], "left", "center")
      local label = seexports.seal_gui:createGuiElement("label", 0, y, pw - 8, 24, bikeWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelAlignment(label, "right", "center")
      seexports.seal_gui:setLabelColor(label, "blue")
      local time = bikeOptions[i].time
      local hours = math.floor(time)
      local minutes = time * 60 - hours * 60
      time = ""
      if 0 < hours then
        time = hours .. " óra"
      end
      if 0 < minutes then
        if 0 < hours then
          time = time .. " "
        end
        time = time .. minutes .. " perc"
      end
      seexports.seal_gui:setLabelText(label, time)
      local label = seexports.seal_gui:createGuiElement("label", 0, y + 24, pw - 8, 24, bikeWindow)
      seexports.seal_gui:setLabelFont(label, "11/Ubuntu-L.ttf")
      seexports.seal_gui:setLabelAlignment(label, "right", "center")
      seexports.seal_gui:setLabelColor(label, "green")
      seexports.seal_gui:setLabelText(label, seexports.seal_gui:thousandsStepper(getItemPrice(veh, bikeOptions[i].price)) .. " $")
      y = y + 48 + 4
      local border = seexports.seal_gui:createGuiElement("hr", 8, y - 1, pw - 16, 2, bikeWindow)
      y = y + 4
    end
    local label = seexports.seal_gui:createGuiElement("label", 8, y, 0, 24, bikeWindow)
    seexports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")
    seexports.seal_gui:setLabelAlignment(label, "left", "center")
    seexports.seal_gui:setLabelText(label, "Összesen:")
    sumLabel = seexports.seal_gui:createGuiElement("label", 0, y, pw - 8, 24, bikeWindow)
    seexports.seal_gui:setLabelFont(sumLabel, "11/Ubuntu-R.ttf")
    seexports.seal_gui:setLabelAlignment(sumLabel, "right", "center")
    seexports.seal_gui:setLabelColor(sumLabel, "blue")
    refreshRepairSums()
    y = y + 24
    y = y + 8
    local btn = seexports.seal_gui:createGuiElement("button", 8, y, pw - 16, ph - y - 8, bikeWindow)
    seexports.seal_gui:setGuiBackground(btn, "solid", "green")
    seexports.seal_gui:setGuiHover(btn, "gradient", {
      "green",
      "green-second"
    }, false, true)
    seexports.seal_gui:setButtonFont(btn, "13/BebasNeueBold.otf")
    seexports.seal_gui:setButtonTextColor(btn, "#ffffff")
    seexports.seal_gui:setButtonText(btn, "Szerelés megkezdése")
    seexports.seal_gui:setClickEvent(btn, "finalAcceptBikeRepair")
  end
  if bikeWindow then
    addEventHandler("onClientPlayerVehicleEnter", localPlayer, createBikeWindow)
    addEventHandler("onClientPlayerVehicleExit", localPlayer, createBikeWindow)
  end
end
