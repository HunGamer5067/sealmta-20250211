function rotateAround(angle, x, y, x2, y2)
	local theta = math.rad(angle)
	local rotatedX = x * math.cos(theta) - y * math.sin(theta) + (x2 or 0)
	local rotatedY = x * math.sin(theta) + y * math.cos(theta) + (y2 or 0)
	return rotatedX, rotatedY
end

pedPositions = {
	{
	  -1,
	  1.4,
	  0.7
	},
	{
	  -0.45,
	  1.4,
	  0.7
	},
	{
	  -0.9,
	  1.2,
	  0.7,
	  180
	},
	{
	  -0.35,
	  1.2,
	  0.7,
	  180
	},
	{
	  0.9000000000000001,
	  1.4,
	  0.7
	},
	{
	  0.45000000000000007,
	  1.2,
	  0.7,
	  180
	},
	{
	  1,
	  1.2,
	  0.7,
	  180
	},
	{
	  -1,
	  -0.9,
	  1
	},
	{
	  -0.45,
	  -0.9,
	  1
	},
	{
	  -1,
	  -1.6,
	  1
	},
	{
	  -0.45,
	  -1.6,
	  1
	},
	{
	  0.9,
	  -1.6,
	  1
	},
	{
	  -1,
	  -2.34,
	  1.2
	},
	{
	  -0.45,
	  -2.34,
	  1.2
	},
	{
	  0.9,
	  -2.34,
	  1.2
	},
	{
	  -1,
	  -4,
	  1.2
	},
	{
	  -0.45,
	  -4,
	  1.2
	},
	{
	  -1,
	  -4,
	  1.2,
	  180
	},
	{
	  -0.45,
	  -4,
	  1.2,
	  180
	}
}

pedBasePositions = {
	{-1.1, -2},
  	{-1.1, -1},
  	{-1.1, 0},
  	{-1.1, 1},
  	{-1.1, 2}
}

busStops = {}

markerPoints = {
	normal = {},
	country = {}
}

pedPoints = {
	normal = {},
	country = {}
}

function initBusStop(lineType, baseX, baseY, baseZ, rotation)
	local markerX, markerY = rotateAround(rotation, -4, 0)

	table.insert(markerPoints[lineType], {baseX + markerX, baseY + markerY, baseZ})

	if setObjectBreakable then
		local objectElement = createObject(1257, baseX, baseY, baseZ + 0.15, 0, 0, rotation)

		if isElement(objectElement) then
			setObjectBreakable(objectElement, false)
			busStops[objectElement] = true
		end
	end

	local markerId = #markerPoints[lineType]

	pedPoints[lineType][markerId] = {}

	for i = 1, #pedBasePositions do
		local pedX, pedY = rotateAround(rotation, pedBasePositions[i][1], pedBasePositions[i][2])

		table.insert(pedPoints[lineType][markerId], {baseX + pedX, baseY + pedY, baseZ, rotation + 90})
	end
end

initBusStop("normal", 2163.5, -2191.6001, 13.8, 134.75)
initBusStop("normal", 2008.3, -2160.1001, 13.8, 90)
initBusStop("normal", 1770.6, -2160.3, 13.8, 90)
initBusStop("normal", 1480.1, -1866.2, 13.8, 90)
initBusStop("normal", 1247.5, -1846, 13.8, 90)
initBusStop("normal", 1186.3, -1786.6, 13.8, 0)
initBusStop("normal", 1087.4, -1706, 13.8, 90)
initBusStop("normal", 955.70001, -1565.8, 13.9, 90)
initBusStop("normal", 822.5, -1620.5, 13.8, 138)
initBusStop("normal", 608.40039, -1669.2998, 16.3, 83.996)
initBusStop("normal", 293.5, -1632.2, 33.6, 83.496)
initBusStop("normal", 377.79999, -1429.5, 34.6, 308.241)
initBusStop("normal", 502, -1315.3, 16.1, 38.238)
initBusStop("normal", 598.90039, -1233, 18.4, 290.978)
initBusStop("normal", 767.5, -1063.9, 24.9, 281.732)
initBusStop("normal", 1025.2, -972.59998, 42.7, 279.228)
initBusStop("normal", 1599, -976.59998, 38.7, 262.973)
initBusStop("normal", 1983.4, -1033, 35, 267.469)
initBusStop("normal", 2252.5, -1149.2, 26.8, 254.718)
initBusStop("normal", 2364.7, -1208.1, 27.9, 180.963)
initBusStop("normal", 2364.6001, -1367.2, 24.3, 179.961)
initBusStop("normal", 2424.8999, -1567.7, 24.3, 180)
initBusStop("normal", 2264.3999, -1725.9, 13.8, 89.995)
initBusStop("normal", 2208.1001, -1948.9, 13.8, 177.739)

initBusStop("country", 2347.1001, -2236.7, 13.8, 314.5)
initBusStop("country", 2844.1001, -2021.8, 11.4, 0)
initBusStop("country", 2905.5, -802.59998, 11.3, 0)
initBusStop("country", 2844.3999, -337, 8.2, 10.25)
initBusStop("country", 2788.3999, 50.7, 21.8, 90.992)
initBusStop("country", 2432.7, 48, 26.8, 90)
initBusStop("country", 2167.3, 49.4, 26.7, 88.995)
initBusStop("country", 1594.3, 136.3, 30, 101.241)
initBusStop("country", 950.40002, -172.39999, 11.7, 85.991)
initBusStop("country", 303.7998, -135.59961, 1.7, 90)
initBusStop("country", 82.7, -205, 1.9, 90)
initBusStop("country", -642.09998, -235.8, 63.8, 93)
initBusStop("country", -1049.4, -447.79999, 36.1, 115.499)
initBusStop("country", -1791.9, -569.79999, 16.7, 90)
initBusStop("country", -1944.6, -569.90002, 24.8, 90)
initBusStop("country", -2245.5, -96.1, 35.5, 0)
initBusStop("country", -2378.1001, 699.09998, 35.5, 0)
initBusStop("country", -2397.6001, 1115.4, 56, 71)
initBusStop("country", -2667.8, 2185.3999, 56.1, 4.499)
initBusStop("country", -2534.2, 2411.3999, 16.1, 128.999)
initBusStop("country", -2551.3999, 2280.8, 5.3, 231.248)
initBusStop("country", -2460.1001, 2317.1001, 5.2, 0)
initBusStop("country", -2698.3999, 2177.1001, 56.1, 188)
initBusStop("country", -2740.6001, 1191.6, 54.1, 141.998)
initBusStop("country", -2757.0996, 947.40039, 54.7, 179.995)
initBusStop("country", -2712.3, 434.5, 4.6, 179.995)
initBusStop("country", -2712, 181.2002, 4.6, 179.995)
initBusStop("country", -2712, -145.2, 4.6, 179.995)
initBusStop("country", -2779.6001, -204.10001, 7.5, 89.995)
initBusStop("country", -2827.1001, -389.60001, 7.5, 175.739)
initBusStop("country", -2879.3999, -864.5, 8.1, 178.75)
initBusStop("country", -2699.7998, -2062.7998, 36.1, 242.496)
initBusStop("country", -1968.5, -2644.2998, 59.7, 290.995)
initBusStop("country", -1574.2998, -2808.0996, 47.3, 226.247)
initBusStop("country", 16.90039, -2659.8994, 40.5, 3.494)
initBusStop("country", -303.2998, -2139.3994, 28.8, 17.49)
initBusStop("country", -256.40039, -1653.5, 15.4, 332.238)
initBusStop("country", 527.5, -1244.2, 16.6, 126.238)
initBusStop("country", 178, -1498, 12.9, 146.983)
initBusStop("country", 215.7, -1668.6, 12.3, 223.73)
initBusStop("country", 727.90002, -1780.7, 13.9, 257.995)
initBusStop("country", 1046.7, -2309.1001, 13.3, 209.242)
initBusStop("country", 1432.4, -2690, 13.8, 265.24)
initBusStop("country", 2187.1001, -2417.8999, 13.8, 345.237)