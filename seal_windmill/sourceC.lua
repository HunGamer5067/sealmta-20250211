local windmills = {}
local windmillSounds = {}
local windmillPoses = {
  {
    -1501.671,
    2192.451,
    112.881
  },
  {
    -1455.311,
    1985.811,
    112.179
  },
  {
    -1506.211,
    2405.811,
    111.879
  },
  {
    -987.767578125,
    1513.6708984375,
    105.5
  },
  {
    -1368.7060546875,
    -2810,
    126
  },
  {
    -2346.142578125,
    -2667.95703125,
    125
  },
  {
    -1838.537109375,
    -2647.1943359375,
    118
  },
  {
    -1373.3935546875,
    -1508.8916015625,
    165
  },
  {
    -1359.8408203125,
    -1069.0791015625,
    225
  },
  {
    -1008.4677734375,
    -1870,
    142
  },
  {
    -463.7841796875,
    -2431.2490234375,
    175
  },
  {
    -877.4052734375,
    -2507.1552734375,
    173
  },
  {
    -2421.7705078125,
    -720.0732421875,
    197
  }
}
local rz = -180
local windmillObjects = {}
function createWindmills()
  for k = 1, #windmillPoses do
    local x, y, z = unpack(windmillPoses[k])
    local sound = playSound3D("files/wind.mp3", x, y, z + 56.5, true)
    setSoundMaxDistance(sound, 750)
    local alap = createObject(1540, x, y, z, 0, 0, rz)
    local alapLOD = createObject(1540, x, y, z, 0, 0, rz, true)
    setLowLODElement(alap, alapLOD)
    local rotor = createObject(1539, x, y, z + 56.5)
    local rotorLOD = createObject(1539, x, y, z + 56.5, 0, 0, rz, true)
    setLowLODElement(rotor, rotorLOD)
    setElementDimension(alap, -1)
    setElementDimension(alapLOD, -1)
    setElementDimension(rotor, -1)
    setElementDimension(rotorLOD, -1)
    setSoundVolume(sound, 0)
    windmills[k] = {
      rotor,
      rotorLOD,
      sound,
      alap,
      alapLOD,
      sound,
      math.random() * 360,
      math.random() * 0.25 + 0.75
    }
    triggerServerEvent("requestWindMillVelocity", localPlayer)
  end
end
createWindmills()
local dimension = 0
local windRot = 0
local windVelocityValue = false
local targetVelocityValue = false
addEvent("gotWindMillVelocity", true)
addEventHandler("gotWindMillVelocity", getRootElement(), function(vel)
  if not targetVelocityValue then
    windVelocityValue = vel + 1
    addEventHandler("onClientPreRender", getRootElement(), preRenderWindmill)
  end
  targetVelocityValue = vel
end)
function preRenderWindmill(delta)
  local rs = false
  if windVelocityValue < targetVelocityValue then
    rs = true
    windVelocityValue = windVelocityValue + 0.25 * delta / 1000
    if windVelocityValue > targetVelocityValue then
      windVelocityValue = targetVelocityValue
    end
  elseif windVelocityValue > targetVelocityValue then
    rs = true
    windVelocityValue = windVelocityValue - 0.25 * delta / 1000
    if windVelocityValue < targetVelocityValue then
      windVelocityValue = targetVelocityValue
    end
  end
  if rs then
    setWindVelocity(0.75 * windVelocityValue / 180, 0, 0)
  end
  windRot = windRot + delta / 1000 * windVelocityValue
  for k = 1, #windmills do
    local wr = windmills[k][7] + windRot * windmills[k][8]
    setElementRotation(windmills[k][1], wr, 0, rz)
    setElementRotation(windmills[k][2], wr, 0, rz)
    if rs then
      local vel = windVelocityValue * windmills[k][8]
      local v = vel / 65
      if v < 1 then
        v = math.pow(v, 0.25)
      end
      setSoundVolume(windmills[k][6], v * 1.5)
      setSoundSpeed(windmills[k][6], math.max(0.5, math.min(1.5, vel / 60)))
    end
  end
end


addEventHandler("onClientResourceStart", resourceRoot, function()
  local txd = engineLoadTXD("files/windmill.txd")
  if txd then
    engineImportTXD(txd, 1540)
    local dff = engineLoadDFF("files/windmill_alap.dff")
    if dff then
      engineReplaceModel(dff, 1540)
      local col = engineLoadCOL("files/windmill_alap.col")
      if col then
        engineReplaceCOL(col, 1540)
      end
    end
    
    engineImportTXD(txd, 1539)
    local dff = engineLoadDFF("files/windmill_rotor.dff")
    if dff then
      engineReplaceModel(dff, 1539)
      local col = engineLoadCOL("files/windmill_rotor.col")
      if col then
        engineReplaceCOL(col, 1539)
      end
    end
  end
end)