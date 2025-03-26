local seexports = {seal_controls = false}
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
local staminaStarted = false
local staminaStartValue = 0
local stamina = 100
local staminaRefillStarted = getTickCount()
local inTired = false
local staminaUpSynced = false
local jumpDone = false
local jumpStarted = 0
local adminDuty = 0
local parachuteState = false
local drugStaminaOff
local playerGlueState = false
addEventHandler("onClientResourceStart", getResourceRootElement(), function()
  adminDuty = getElementData(localPlayer, "adminDuty")
  drugStaminaOff = getElementData(localPlayer, "drugStaminaOff")
  playerGlueState = getElementData(localPlayer, "playerGlueState")
  parachuteState = getElementData(localPlayer, "parachuting") or false
end)
addEventHandler("onClientElementDataChange", getRootElement(), function(data)
  if data == "adminDuty" and source == localPlayer then
    adminDuty = getElementData(localPlayer, data)
  end
  if data == "drugStaminaOff" and source == localPlayer then
    drugStaminaOff = getElementData(localPlayer, data)
  end
  if data == "playerGlueState" and source == localPlayer then
    playerGlueState = getElementData(localPlayer, data)
  end
  if data == "parachuting" and source == localPlayer then
    parachuteState = getElementData(localPlayer, "parachuting") or false
  end
end)
local controls = true
local staminaTireMultipler = 0.005
local staminaUnTireMultipler = 0.0075
local maxZ = 0
local jumped = false
addEventHandler("onClientPreRender", getRootElement(), function(delta)
  renderTestTick = getTickCount()
  if adminDuty ~= 1 and not parachuteState then
    speedx, speedy, speedz = getElementVelocity(localPlayer)
    actualspeed = (speedx ^ 2 + speedy ^ 2) ^ 0.5
    if speedz >= 0.1 and not jumped and not drugStaminaOff and not isPedInVehicle(localPlayer) and not playerGlueState then
      jumped = true
      stamina = stamina - 10
      if stamina <= 0 then
        stamina = 0
        if controls then
          seexports.seal_controls:toggleControl({
            "forwards",
            "backwards",
            "left",
            "right",
            "jump"
          }, false)
          triggerServerEvent("tiredAnim", localPlayer, true)
          controls = false
        end
      end
    end
    if speedz < 0.05 then
      jumped = false
    end
    if actualspeed < 0.05 and not jumped then
      if stamina <= 100 then
        if 25 < stamina then
          if not controls then
            seexports.seal_controls:toggleControl({
              "forwards",
              "backwards",
              "left",
              "right",
              "jump"
            }, true)
            triggerServerEvent("tiredAnim", localPlayer, false)
            controls = true
          end
          stamina = stamina + staminaUnTireMultipler * delta
        else
          stamina = stamina + staminaUnTireMultipler * delta * 0.75
        end
      else
        stamina = 100
      end
    elseif actualspeed >= 0.1 and not drugStaminaOff and not isPedInVehicle(localPlayer) and not playerGlueState then
      if 0 <= stamina then
        stamina = stamina - staminaTireMultipler * delta
      else
        stamina = 0
        if controls then
          seexports.seal_controls:toggleControl({
            "forwards",
            "backwards",
            "left",
            "right",
            "jump"
          }, false)
          triggerServerEvent("tiredAnim", localPlayer, true)
          controls = false
        end
      end
    end
  else
    stamina = 100
    if not controls then
      seexports.seal_controls:toggleControl({
        "forwards",
        "backwards",
        "left",
        "right",
        "jump"
      }, true)
      triggerServerEvent("tiredAnim", localPlayer, false)
      controls = true
    end
  end
  setControlState(localPlayer, "walk", true)
end)
function getStamina()
	return stamina
end