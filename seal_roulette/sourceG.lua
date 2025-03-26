syncZoneCoords = {
  {
    1592.5209960938, -1631.9234619141, 567.99517822266,
    35,
    2,
    2,
    "Los Santos Casino",
  },
  {
    74.809181213379, 2046.6680908203, 51.0859375,
    270,
    1,
    22,
    "Ház",
  }
}
rouletteTableCoords = {
  {
    74.809181213379, 2046.6680908203, 51.0859375,
    270,
    1,
    22,
  },
  {
    1601.5401611328, -1636.2829589844, 567.99517822266,
    0,
    2,
    2
  },
  {
    1601.5401611328, -1626.2829589844, 567.99517822266,
    0,
    2,
    2
  },
  {
    1601.5401611328, -1646.2829589844, 567.99517822266,
    0,
    2,
    2
  },
  {
    1586.5401611328, -1646.2829589844, 567.99517822266,
    0,
    2,
    2
  },
  {
    1586.5401611328, -1638.2829589844, 567.99517822266,
    0,
    2,
    2
  },
  {
    1587.28515625, -1645.0482177734, 575.3115234375,
    0,
    2,
    2
  },
  {
    1603.28515625, -1645.0482177734, 575.3115234375,
    0,
    2,
    2
  },
  {
    1603.28515625, -1635.0482177734, 575.3115234375,
    0,
    2,
    2
  },
  {
    1603.28515625, -1625.0482177734, 575.3115234375,
    0,
    2,
    2
  },
  {
    1603.28515625, -1615.0482177734, 575.3115234375,
    0,
    2,
    2
  }
}
rouletteWheelNums = {
  20,
  14,
  31,
  9,
  22,
  18,
  29,
  7,
  28,
  12,
  35,
  3,
  26,
  0,
  32,
  15,
  19,
  4,
  21,
  2,
  25,
  17,
  34,
  6,
  27,
  13,
  36,
  11,
  30,
  8,
  23,
  10,
  5,
  24,
  16,
  33,
  1
}
rouletteWheelNumsReverse = {}
for i = 1, #rouletteWheelNums do
  rouletteWheelNumsReverse[rouletteWheelNums[i]] = i
end
neighbours = {}
neighboursEx = {}
for n = 0, 36 do
  local j = rouletteWheelNumsReverse[n] - 1
  neighbours[n] = {
    rouletteWheelNums[(j - 1) % 37 + 1],
    n,
    rouletteWheelNums[(j + 1) % 37 + 1]
  }
  neighboursEx[n] = {}
  for i = 1, 3 do
    neighboursEx[n][neighbours[n][i]] = true
  end
end
tierBets = {
  "splith8",
  "splitv10",
  "splith16",
  "splitv23",
  "splith30",
  "splith36"
}
tierAmount = 6
orphelinsBets = {
  1,
  "splith9",
  "splith17",
  "splith20",
  "splith34"
}
orphelinsAmount = 5
voisinsBets = {
  "trio2",
  "splith7",
  "splith15",
  "splith21",
  "splith22",
  "corner25",
  "splith35"
}
voisinsAmount = 9
zeroBets = {
  "splith3",
  "splith15",
  26,
  "splith35"
}
zeroAmount = 4
tierBetsRev = {}
for i = 1, #tierBets do
  tierBetsRev[tierBets[i]] = true
end
orphelinsBetsRev = {}
for i = 1, #orphelinsBets do
  orphelinsBetsRev[orphelinsBets[i]] = true
end
voisinsBetsRev = {}
for i = 1, #voisinsBets do
  voisinsBetsRev[voisinsBets[i]] = true
end
zeroBetsRev = {}
for i = 1, #zeroBets do
  zeroBetsRev[zeroBets[i]] = true
end
oneRad = math.pi * 2 / 37
wrSpeed = 12
wrSpeedRad = math.rad(wrSpeed)
fastSpeed = math.rad(630)
slowSpeed = math.rad(90)
sfSpeed = fastSpeed - slowSpeed
numberColors = {
  [32] = 1,
  [19] = 1,
  [21] = 1,
  [25] = 1,
  [34] = 1,
  [27] = 1,
  [36] = 1,
  [30] = 1,
  [23] = 1,
  [5] = 1,
  [16] = 1,
  [1] = 1,
  [14] = 1,
  [9] = 1,
  [18] = 1,
  [7] = 1,
  [12] = 1,
  [3] = 1
}
for i = 1, 36 do
  if not numberColors[i] then
    numberColors[i] = 2
  end
end
minBet = 100
coinValues = {
  5,
  25,
  50,
  100,
  500,
  1000,
  5000
}
maxCoinValue = coinValues[#coinValues]
for i = 1, #coinValues do
  if coinValues[i] >= minBet then
    minCoin = i
    break
  end
end
pif = math.pi * 2
pi3 = math.pi * 3
pih = math.pi / 2
pit = math.pi / 3
pit2 = math.pi / 3 * 2
piq = math.pi / 4
piq2 = math.pi / 4 * 2
piq3 = math.pi / 4 * 3
countdownTime = 60
winnerBets = {}
for i = 0, 36 do
  winnerBets[i] = {i}
  if 0 <= i and i <= 3 then
    table.insert(winnerBets[i], "basket")
  end
  if 1 <= i then
    if 1 <= i and i <= 12 then
      table.insert(winnerBets[i], "d1")
    elseif 13 <= i and i <= 24 then
      table.insert(winnerBets[i], "d2")
    elseif 25 <= i and i <= 36 then
      table.insert(winnerBets[i], "d3")
    end
    if numberColors[i] == 1 then
      table.insert(winnerBets[i], "red")
    else
      table.insert(winnerBets[i], "black")
    end
    if i % 2 == 1 then
      table.insert(winnerBets[i], "odd")
    else
      table.insert(winnerBets[i], "even")
    end
    if 1 <= i and i <= 18 then
      table.insert(winnerBets[i], "1half")
    elseif 19 <= i and i <= 36 then
      table.insert(winnerBets[i], "2half")
    end
  end
end
for j = 1, 3 do
  for i = 0, 11 do
    table.insert(winnerBets[i * 3 + j], "col" .. j)
  end
end
for a = 1, 36 do
  local b = math.max(0, a - 3)
  table.insert(winnerBets[a], "splith" .. a)
  table.insert(winnerBets[b], "splith" .. a)
end
for a = 1, 36 do
  if a % 3 > 0 then
    local b = a + 1
    table.insert(winnerBets[a], "splitv" .. a)
    table.insert(winnerBets[b], "splitv" .. a)
  end
end
for i = 1, 2 do
  table.insert(winnerBets[0], "trio" .. i)
  table.insert(winnerBets[i], "trio" .. i)
  table.insert(winnerBets[i + 1], "trio" .. i)
end
for i = 0, 10 do
  for j = 1, 2 do
    local n = j + i * 3
    table.insert(winnerBets[n], "corner" .. n)
    table.insert(winnerBets[n + 1], "corner" .. n)
    table.insert(winnerBets[n + 3], "corner" .. n)
    table.insert(winnerBets[n + 4], "corner" .. n)
  end
end
for i = 0, 11 do
  local n = i * 3 + 1
  table.insert(winnerBets[n], "street" .. n)
  table.insert(winnerBets[n + 1], "street" .. n)
  table.insert(winnerBets[n + 2], "street" .. n)
  if n < 34 then
    table.insert(winnerBets[n], "doublestreet" .. n)
    table.insert(winnerBets[n + 1], "doublestreet" .. n)
    table.insert(winnerBets[n + 2], "doublestreet" .. n)
    table.insert(winnerBets[n + 3], "doublestreet" .. n)
    table.insert(winnerBets[n + 4], "doublestreet" .. n)
    table.insert(winnerBets[n + 5], "doublestreet" .. n)
  end
end
payouts = {
  straight = 35,
  splith = 17,
  splitv = 17,
  trio = 11,
  street = 11,
  basket = 8,
  corner = 8,
  doublestreet = 5,
  dozen = 2,
  col = 2,
  half = 1,
  even = 1,
  red = 1,
  black = 1,
  odd = 1
}
payoutsForBets = {}
validBets = {
  [0] = "straight",
  [1] = "straight",
  [2] = "straight",
  [3] = "straight",
  [4] = "straight",
  [5] = "straight",
  [6] = "straight",
  [7] = "straight",
  [8] = "straight",
  [9] = "straight",
  [10] = "straight",
  [11] = "straight",
  [12] = "straight",
  [13] = "straight",
  [14] = "straight",
  [15] = "straight",
  [16] = "straight",
  [17] = "straight",
  [18] = "straight",
  [19] = "straight",
  [20] = "straight",
  [21] = "straight",
  [22] = "straight",
  [23] = "straight",
  [24] = "straight",
  [25] = "straight",
  [26] = "straight",
  [27] = "straight",
  [28] = "straight",
  [29] = "straight",
  [30] = "straight",
  [31] = "straight",
  [32] = "straight",
  [33] = "straight",
  [34] = "straight",
  [35] = "straight",
  [36] = "straight",
  d1 = {"dozen", 1},
  d2 = {"dozen", 2},
  d3 = {"dozen", 3},
  ["1half"] = {"half", 1},
  even = "even",
  red = "red",
  black = "black",
  odd = "odd",
  ["2half"] = {"half", 2},
  col1 = {"col", 1},
  col2 = {"col", 2},
  col3 = {"col", 3},
  basket = "basket",
  splith1 = {"splith", 1},
  splith2 = {"splith", 2},
  splith3 = {"splith", 3},
  splith4 = {"splith", 4},
  splith5 = {"splith", 5},
  splith6 = {"splith", 6},
  splith7 = {"splith", 7},
  splith8 = {"splith", 8},
  splith9 = {"splith", 9},
  splith10 = {"splith", 10},
  splith11 = {"splith", 11},
  splith12 = {"splith", 12},
  splith13 = {"splith", 13},
  splith14 = {"splith", 14},
  splith15 = {"splith", 15},
  splith16 = {"splith", 16},
  splith17 = {"splith", 17},
  splith18 = {"splith", 18},
  splith19 = {"splith", 19},
  splith20 = {"splith", 20},
  splith21 = {"splith", 21},
  splith22 = {"splith", 22},
  splith23 = {"splith", 23},
  splith24 = {"splith", 24},
  splith25 = {"splith", 25},
  splith26 = {"splith", 26},
  splith27 = {"splith", 27},
  splith28 = {"splith", 28},
  splith29 = {"splith", 29},
  splith30 = {"splith", 30},
  splith31 = {"splith", 31},
  splith32 = {"splith", 32},
  splith33 = {"splith", 33},
  splith34 = {"splith", 34},
  splith35 = {"splith", 35},
  splith36 = {"splith", 36},
  splitv1 = {"splitv", 1},
  splitv2 = {"splitv", 2},
  splitv4 = {"splitv", 4},
  splitv5 = {"splitv", 5},
  splitv7 = {"splitv", 7},
  splitv8 = {"splitv", 8},
  splitv10 = {"splitv", 10},
  splitv11 = {"splitv", 11},
  splitv13 = {"splitv", 13},
  splitv14 = {"splitv", 14},
  splitv16 = {"splitv", 16},
  splitv17 = {"splitv", 17},
  splitv19 = {"splitv", 19},
  splitv20 = {"splitv", 20},
  splitv22 = {"splitv", 22},
  splitv23 = {"splitv", 23},
  splitv25 = {"splitv", 25},
  splitv26 = {"splitv", 26},
  splitv28 = {"splitv", 28},
  splitv29 = {"splitv", 29},
  splitv31 = {"splitv", 31},
  splitv32 = {"splitv", 32},
  splitv34 = {"splitv", 34},
  splitv35 = {"splitv", 35},
  trio1 = {"trio", 1},
  trio2 = {"trio", 2},
  corner1 = {"corner", 1},
  corner2 = {"corner", 2},
  corner4 = {"corner", 4},
  corner5 = {"corner", 5},
  corner7 = {"corner", 7},
  corner8 = {"corner", 8},
  corner10 = {"corner", 10},
  corner11 = {"corner", 11},
  corner13 = {"corner", 13},
  corner14 = {"corner", 14},
  corner16 = {"corner", 16},
  corner17 = {"corner", 17},
  corner19 = {"corner", 19},
  corner20 = {"corner", 20},
  corner22 = {"corner", 22},
  corner23 = {"corner", 23},
  corner25 = {"corner", 25},
  corner26 = {"corner", 26},
  corner28 = {"corner", 28},
  corner29 = {"corner", 29},
  corner31 = {"corner", 31},
  corner32 = {"corner", 32},
  street1 = {"street", 1},
  street4 = {"street", 4},
  street7 = {"street", 7},
  street10 = {"street", 10},
  street13 = {"street", 13},
  street16 = {"street", 16},
  street19 = {"street", 19},
  street22 = {"street", 22},
  street25 = {"street", 25},
  street28 = {"street", 28},
  street31 = {"street", 31},
  street34 = {"street", 34},
  doublestreet1 = {
    "doublestreet",
    1
  },
  doublestreet4 = {
    "doublestreet",
    4
  },
  doublestreet7 = {
    "doublestreet",
    7
  },
  doublestreet10 = {
    "doublestreet",
    10
  },
  doublestreet13 = {
    "doublestreet",
    13
  },
  doublestreet16 = {
    "doublestreet",
    16
  },
  doublestreet19 = {
    "doublestreet",
    19
  },
  doublestreet22 = {
    "doublestreet",
    22
  },
  doublestreet25 = {
    "doublestreet",
    25
  },
  doublestreet28 = {
    "doublestreet",
    28
  },
  doublestreet31 = {
    "doublestreet",
    31
  },
  n0 = {"n", 0},
  n1 = {"n", 1},
  n2 = {"n", 2},
  n3 = {"n", 3},
  n4 = {"n", 4},
  n5 = {"n", 5},
  n6 = {"n", 6},
  n7 = {"n", 7},
  n8 = {"n", 8},
  n9 = {"n", 9},
  n10 = {"n", 10},
  n11 = {"n", 11},
  n12 = {"n", 12},
  n13 = {"n", 13},
  n14 = {"n", 14},
  n15 = {"n", 15},
  n16 = {"n", 16},
  n17 = {"n", 17},
  n18 = {"n", 18},
  n19 = {"n", 19},
  n20 = {"n", 20},
  n21 = {"n", 21},
  n22 = {"n", 22},
  n23 = {"n", 23},
  n24 = {"n", 24},
  n25 = {"n", 25},
  n26 = {"n", 26},
  n27 = {"n", 27},
  n28 = {"n", 28},
  n29 = {"n", 29},
  n30 = {"n", 30},
  n31 = {"n", 31},
  n32 = {"n", 32},
  n33 = {"n", 33},
  n34 = {"n", 34},
  n35 = {"n", 35},
  n36 = {"n", 36}
}
for bet, betType in pairs(validBets) do
  if type(betType) == "table" then
    if payouts[betType[1]] then
      payoutsForBets[bet] = payouts[betType[1]]
    end
  elseif payouts[betType] then
    payoutsForBets[bet] = payouts[betType]
  end
end
