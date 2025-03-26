local seexports = {seal_carshop = false}
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
bikePositions = {
  {487.8356628418, -1739.0104980469, 11.14395904541},
  {1024.8552246094, -1024.5391845703, 32.1015625},

}
heliPositions = {
  {
    -2227.55859375,
    2326.8330078125,
    7.546875
  },
  {
    1765.7763671875,
    -2286.2509765625,
    26.796022415161
  }
}
boatPositions = {
  {
    -333.5126953125,
    -473.4560546875,
    1.5
  },
  {
    727.803515625,
    -1509.7265625,
    1.5
  }
}
bikeOptions = {
  {
    part = "repair",
    name = "Karosszéria javítás",
    price = 0.015,
    time = 0.05
  },
  {
    part = "engineCondition",
    name = "Motorgenerál",
    price = 0.022,
    time = 0.001
  },
  {
    part = "timing",
    name = "Lámpák",
    price = 0.0075,
    time = 0.025
  },
  {
    part = "tires",
    name = "Gumik",
    price = 0.01,
    time = 0.025
  },
  {
    part = "oil",
    name = "Olajcsere",
    price = 0.0115,
    time = 0.0125
  },
}
heliFixPrice = 0.05
overridePrices = {}
function getBasePrice(veh)
  local model = false
  if tonumber(veh) then
    model = veh
  else
    model = getElementModel(veh)
  end
  if model then
    local price = seexports.seal_carshop:getVehiclePrice(model, "dollar")
    return price or overridePrices[model] or 1000000
  else
    return 1000000
  end
end
function getItemPrice(veh, price)
  if 1 < price then
    return price
  else
    local base = tonumber(getBasePrice(veh)) or 0
    return math.floor(base * price + 0.5)
  end
end
