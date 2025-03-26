local sound = false
local cols = {}
local colZ = {}
local ambientCols = {
  {
    sound = "247",
    polygonHeight = {14, 19},
    colShape = createColPolygon(1090.690918, -1445.235474, 1101.651978, -1461.828857, 1079.536255, -1461.827271, 1079.494751, -1427.614868, 1101.651978, -1427.614868)
  },
  {
    sound = "odeas",
    polygonHeight = {14, 19},
    colShape = createColPolygon(1094.64844, -1483.93481, 1094.64844, -1483.93481, 1101.21912, -1462.60498, 1089.49622, -1462.55872, 1081.58423, -1484.91479)
  },
  {
    sound = "food",
    polygonHeight = {14, 19},
    colShape = createColPolygon(1155.81665, -1459.78955, 1155.81665, -1459.78955, 1155.51648, -1424.30688, 1184.86572, -1424.01208, 1185.00403, -1461.89575)
  },
  {
    sound = "bean",
    polygonHeight = {14, 19},
    colShape = createColPolygon(1162.42444, -1482.10486, 1162.42444, -1482.10486, 1172.29224, -1482.03552, 1172.10657, -1462.31592, 1156.00574, -1462.98169)
  },
  {
    sound = "bean",
    polygonHeight = {14.7993, 19},
    colShape = createColPolygon(1163.37854, -1516.647095, 1162.109253, -1496.572754, 1177.723511, -1502.456177, 1164.596069, -1538.23645, 1148.702393, -1532.208618)
  },
  {
    sound = "bean",
    polygonHeight = {19.1, 26.111},
    colShape = createColPolygon(1170.454102, -1520.070312, 1171.630127, -1497.241821, 1183.597656, -1501.428223, 1179.359985, -1517.386963, 1171.434937, -1540.427734, 1158.348389, -1535.856079)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1170.936646, -1433.334229, 1163.216187, -1425.469238, 1178.656738, -1425.469238, 1178.656738, -1441.195435, 1163.216187, -1441.193115)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1170.50293, -1452.478516, 1163.216309, -1444.721436, 1176.928223, -1444.712891, 1176.928223, -1460.215332, 1163.216187, -1460.215332)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1174.213745, -1472.70874, 1163.195923, -1463.144043, 1185.231323, -1463.077881, 1185.223511, -1482.343262, 1171.537109, -1482.341797)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1177.717651, -1489.735352, 1171.563354, -1485.138428, 1183.85791, -1485.107788, 1183.867676, -1494.387207, 1171.563354, -1494.379272)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1084.844727, -1475.811523, 1085.085327, -1487.873535, 1073.005737, -1484.398682, 1080.842896, -1462.912231, 1094.143555, -1462.963989)
  },
  {
    sound = "odeas",
    polygonHeight = {21.8, 25.5},
    colShape = createColPolygon(1086.653687, -1444.510986, 1094.194336, -1462.186523, 1079.560303, -1462.187378, 1079.546997, -1426.835693, 1093.265015, -1426.826416)
  },
  {
    sound = "food",
    polygonHeight = {12.5, 15.6},
    colShape = createColPolygon(2108.4336, -1803.3488, 2102.085, -1793.3567, 2123.385, -1793.3567, 2123.385, -1815.8635, 2102.0859, -1815.8635)
  }
}
local currentCol = false
local colHit = false
function ambientColHit(el)
  if el == localPlayer and not currentCol then
    for i = 1, #ambientCols do
      if source == ambientCols[i].colShape then
        currentCol = ambientCols[i].colShape
        colHit = getTickCount()
        if isElement(sound) then
          destroyElement(sound)
        end
        sound = playSound("files/" .. ambientCols[i].sound .. ".mp3", true)
        setSoundPosition(sound, getSoundLength(sound) * math.random(0, 1000) / 1000)
        break
      end
    end
  end
end
function ambientColLeave(el)
  if el == localPlayer and currentCol then
    currentCol = false
    colHit = getTickCount()
  end
end
for i = 1, #ambientCols do
  setColPolygonHeight(ambientCols[i].colShape, ambientCols[i].polygonHeight[1], ambientCols[i].polygonHeight[2])
  addEventHandler("onClientColShapeHit", ambientCols[i].colShape, ambientColHit)
  addEventHandler("onClientColShapeLeave", ambientCols[i].colShape, ambientColLeave)
end
addEventHandler("onClientRender", getRootElement(), function()
  if currentCol then
    if colHit then
      if isElement(sound) then
        local p = (getTickCount() - colHit) / 500
        if 1 < p then
          colHit = false
          p = 1
        end
        setSoundVolume(sound, p)
      else
        colHit = getTickCount()
      end
    end
  elseif colHit then
    local p = (getTickCount() - colHit) / 1000
    if 1 < p then
      colHit = false
      p = 1
    end
    if isElement(sound) then
      setSoundVolume(sound, 1 - p)
    end
  elseif sound then
    if isElement(sound) then
      destroyElement(sound)
    end
    sound = false
  end
end)
local forestSounds = {
  {
    -1299.9375,
    -2340.541015625,
    32.792617797852
  },
  {
    -2261.287109375,
    -1413.8369140625,
    110.39261627197
  },
  {
    -1030.6279296875,
    -1088.1220703125,
    132.59259033203
  },
  {
    -548.138671875,
    -105.306640625,
    68.592590332031
  },
  {
    948.939453125,
    4.59375,
    90.130279541016
  },
  {
    215.064453125,
    -548.9580078125,
    53.096832275391
  },
  {
    2083.91796875,
    144.779296875,
    21.324062347412
  },
  {
    2570.333984375,
    -423.9072265625,
    78.909019470215
  },
  {
    -2679.802734375,
    2730.109375,
    108.22838592529
  },
  {
    -1735.2744140625,
    2555.578125,
    104.81846618652
  },
  {
    -799.1416015625,
    1104.6669921875,
    45.144161224365
  },
  {
    -1455.6630859375,
    1764.9912109375,
    43.23722076416
  },
  {
    7299.966796875,
    171.154296875,
    113.75877380371
  },
  {
    7399.6416015625,
    -568.1650390625,
    82.050048828125
  }
}
local daySounds = {}
local nightSounds = {}
function processSounds()
  local h, m = getTime()
  local time = h + m / 60
  local nightTime = 0
  if 19 <= time then
    nightTime = math.min(1, (time - 19) / 4)
  end
  if time <= 7.5 then
    nightTime = 1 - math.min(1, math.max(0, (time - 5) / 2.5))
  end
  for i = 1, #forestSounds do
    if nightTime < 1 then
      if not isElement(daySounds[i]) then
        daySounds[i] = playSound3D("files/forestday.wav", forestSounds[i][1], forestSounds[i][2], forestSounds[i][3] + 20, true)
        setSoundMaxDistance(daySounds[i], 1200)
      end
      setSoundVolume(daySounds[i], 1 - nightTime)
    else
      if isElement(daySounds[i]) then
        destroyElement(daySounds[i])
      end
      daySounds[i] = nil
    end
    if 0 < nightTime then
      if not isElement(nightSounds[i]) then
        nightSounds[i] = playSound3D("files/forestnight.wav", forestSounds[i][1], forestSounds[i][2], forestSounds[i][3] + 20, true)
        setSoundMaxDistance(nightSounds[i], 1200)
      end
      setSoundVolume(nightSounds[i], nightTime * 1.75)
    else
      if isElement(nightSounds[i]) then
        destroyElement(nightSounds[i])
      end
      nightSounds[i] = nil
    end
  end
end
processSounds()
setTimer(processSounds, 10000, 0)
