function parseInteriorData(interiorId, data1, data2)
	if interiorId and data1 and data2 then
		local int = availableInteriors[interiorId]

		if int then
			local details = split(data1, "_")

			if details then
				local k = details[1]
				local k2 = details[2]
				
				if k and k2 then
					local v = split(data2, ",")
						
					if v then
						if not int[k] then
							int[k] = {}
						end
						
						if #v > 1 then
							int[k][k2] = {v[1], v[2], v[3]}
						else
							int[k][k2] = data2
						end
					end
				else
					int[data1] = data2
				end
			end
		end
	end
end

function formatNumber(amount, stepper)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right
end

gameInteriors = {
	e = {
		interior = 1,
		name = "Szerkeszthető",
		position = {37.9, 2034.5, 50},
		rotation = {0, 0, 0},
	},
	[1] = {
		interior = 1,
		name = "Ammo nation 1",
		position = {285.8505859375, -41.099609375, 1001.515625},
		rotation = {0, 0, 0}
	},
	[2] = {
		interior = 1,
		name = "Burglary House 1",
		position = {223.125, 1287.0751953125, 1082.140625},
		rotation = {0, 0, 0}
	},
	[3] = {
		interior = 1,
		name = "The Wellcome Pump (Catalina)",
		position = {681.5654296875, -446.388671875, -25.609762191772},
		rotation = {0, 0, 0}
	},
	[4] = {
		interior = 1,
		name = "Restaurant 1",
		position = {455.2529296875, -22.484375, 999.9296875},
		rotation = {0, 0, 0}
	},
	[5] = {
		interior = 1,
		name = "Caligulas Casino",
		position = {2233.9345703125, 1714.6845703125, 1012.3828125},
		rotation = {0, 0, 0}
	},
	[6] = {
		interior = 1,
		name = "Denise's Place",
		position = {244.0892, 304.8456, 999.1484},
		rotation = {0, 0, 0}
	},
	[7] = {
		interior = 1,
		name = "Shamal cabin",
		position = {3.0205078125, 33.20703125, 1199.59375},
		rotation = {0, 0, 0}
	},
	[8] = {
		interior = 1,
		name = "Sweet's House",
		position = {2525.042, -1679.115, 1015.499},
		rotation = {0, 0, 0}
	},
	[9] = {
		interior = 1,
		name = "Transfender",
		position = {627.302734375, -12.056640625, 1000.921875},
		rotation = {0, 0, 0}
	},
	[10] = {
		interior = 1,
		name = "Safe House 4",
		position = {2216.54, -1076.29, 1050.484},
		rotation = {0, 0, 0}
	},
	[11] = {
		interior = 1,
		name = "Trials Stadium",
		position = {-1401.13, 106.11, 1032.273},
		rotation = {0, 0, 0}
	},
	[12] = {
		interior = 1,
		name = "Warehouse 1",
		position = {1381.6873779297, -10.979570388794, 1006.3984375},
		rotation = {0, 0, 0}
	},
	[13] = {
		interior = 1,
		name = "Doherty Garage",
		position = {-2042.42, 178.59, 28.84},
		rotation = {0, 0, 0}
	},
	[14] = {
		interior = 1,
		name = "Sindacco Abatoir",
		position = {963.6078, 2108.397, 1011.03},
		rotation = {0, 0, 0}
	},
	[15] = {
		interior = 1,
		name = "Sub Urban",
		position = {203.6484375, -50.6640625, 1001.8046875},
		rotation = {0, 0, 0}
	},
	[16] = {
		interior = 1,
		name = "Wu Zi Mu's Betting place",
		position = {-2159.926, 641.4587, 1052.382},
		rotation = {0, 0, 0}
	},
	[17] = {
		interior = 2,
		name = "Ryder's House",
		position = {2468.8427734375, -1698.2109375, 1013.5078125},
		rotation = {0, 0, 0}
	},
	[18] = {
		interior = 2,
		name = "Angel Pine Trailer",
		position = {2.0595703125, -3.0146484375, 999.42840576172},
		rotation = {0, 0, 0}
	},
	[19] = {
		interior = 2,
		name = "The Pig Pen",
		position = {1204.748046875, -13.8515625, 1000.921875},
		rotation = {0, 0, 0}
	},
	[20] = {
		interior = 2,
		name = "BDups Crack Palace",
		position = {1523.751, -46.0458, 1002.131},
		rotation = {0, 0, 0}
	},
	[21] = {
		interior = 2,
		name = "Big Smoke's Crack Palace",
		position = {2541.5400390625, -1303.8642578125, 1025.0703125},
		rotation = {0, 0, 0}
	},
	[22] = {
		interior = 2,
		name = "Burglary House 2",
		position = {225.756, 1240, 1082.149},
		rotation = {0, 0, 0}
	},
	[23] = {
		interior = 2,
		name = "Burglary House 3",
		position = {447.47, 1398.348, 1084.305},
		rotation = {0, 0, 0}
	},
	[24] = {
		interior = 2,
		name = "Burglary House 4",
		position = {491.33203125, 1398.4990234375, 1080.2578125},
		rotation = {0, 0, 0}
	},
	[25] = {
		interior = 2,
		name = "Katie's Place",
		position = {267.229, 304.71, 999.148},
		rotation = {0, 0, 0}
	},
	[26] = {
		interior = 2,
		name = "Loco Low Co.",
		position = {612.591, -75.637, 997.992},
		rotation = {0, 0, 0}
	},
	[27] = {
		interior = 2,
		name = "Reece's Barbershop",
		position = {612.591, -75.637, 997.992},
		rotation = {0, 0, 0}
	},
	[28] = {
		interior = 3,
		name = "Jizzy's Pleasure Domes",
		position = {-2636.719, 1402.917, 906.4609},
		rotation = {0, 0, 0}
	},
	[29] = {
		interior = 3,
		name = "Brothel",
		position = {620.197265625, -70.900390625, 997.9921875},
		rotation = {0, 0, 0}
	},
	[30] = {
		interior = 3,
		name = "Brothel 2",
		position = {967.5334, -53.0245, 1001.125},
		rotation = {0, 0, 0}
	},
	[31] = {
		interior = 3,
		name = "BDups Apartment",
		position = {1525.6337890625, -11.015625, 1002.0971069336},
		rotation = {0, 0, 0}
	},
	[32] = {
		interior = 3,
		name = "Bike School",
		position = {1494.390625, 1303.5791015625, 1093.2890625},
		rotation = {0, 0, 0}
	},
	[32] = {
		interior = 3,
		name = "Bike School",
		position = {1494.390625, 1303.5791015625, 1093.2890625},
		rotation = {0, 0, 0}
	},
	[33] = {
		interior = 3,
		name = "Big Spread Ranch",
		position = {1212.0166015625, -25.875, 1000.953125},
		rotation = {0, 0, 0}
	},
	[34] = {
		interior = 3,
		name = "LV Tattoo Parlour",
		position = {-204.439, -43.652, 1002.299},
		rotation = {0, 0, 0}
	},
	[35] = {
		interior = 3,
		name = "LVPD HQ",
		position = {288.8291015625, 166.921875, 1007.171875},
		rotation = {0, 0, 0}
	},
	[36] = {
		interior = 3,
		name = "OG Loc's House",
		position = {516.889, -18.412, 1001.565},
		rotation = {0, 0, 0}
	},
	[37] = {
		interior = 3,
		name = "Pro-Laps",
		position = {206.9296875, -140.375, 1003.5078125},
		rotation = {0, 0, 0}
	},
	[38] = {
		interior = 3,
		name = "Las Venturas Planning Dep.",
		position = {390.7685546875, 173.8505859375, 1008.3828125},
		rotation = {0, 0, 0}
	},
	[39] = {
		interior = 3,
		name = "Record Label Hallway",
		position = {1038.219, 6.9905, 1001.284},
		rotation = {0, 0, 0}
	},
	[40] = {
		interior = 3,
		name = "Driving School",
		position = {-2027.92, -105.183, 1035.172},
		rotation = {0, 0, 0}
	},
	[41] = {
		interior = 3,
		name = "Johnson House",
		position = {2496.0791015625, -1692.083984375, 1014.7421875},
		rotation = {0, 0, 0}
	},
	[42] = {
		interior = 3,
		name = "Burglary House 5",
		position = {235.2529296875, 1186.6806640625, 1080.2578125},
		rotation = {0, 0, 0}
	},
	[43] = {
		interior = 3,
		name = "Gay Gordo's Barbershop",
		position = {418.662109375, -84.3671875, 1001.8046875},
		rotation = {0, 0, 0}
	},
	[44] = {
		interior = 3,
		name = "Helena's Place",
		position = {292.4459, 308.779, 999.1484},
		rotation = {0, 0, 0}
	},
	[45] = {
		interior = 3,
		name = "Inside Track Betting",
		position = {834.66796875, 7.306640625, 1004.1870117188},
		rotation = {0, 0, 0}
	},
	[46] = {
		interior = 3,
		name = "Sex Shop",
		position = {-100.314453125, -25.0380859375, 1000.71875},
		rotation = {0, 0, 0}
	},
	[47] = {
		interior = 3,
		name = "Wheel Arch Angels",
		position = {614.3889, -124.0991, 997.995},
		rotation = {0, 0, 0}
	},
	[48] = {
		interior = 4,
		name = "24/7 shop 1",
		position = {-27.0751953125, -31.7607421875, 1003.5572509766},
		rotation = {0, 0, 0}
	},
	[49] = {
		interior = 4,
		name = "Ammu-Nation 2",
		position = {285.6376953125, -86.6171875, 1001.5228881836},
		rotation = {0, 0, 0}
	},
	[50] = {
		interior = 4,
		name = "Burglary House 6",
		position = {-260.65234375, 1456.9775390625, 1084.3671875},
		rotation = {0, 0, 0}
	},
	[51] = {
		interior = 4,
		name = "Burglary House 7",
		position = {221.7998046875, 1140.837890625, 1082.609375},
		rotation = {0, 0, 0}
	},
	[52] = {
		interior = 4,
		name = "Burglary House 8",
		position = {261.01953125, 1284.294921875, 1080.2578125},
		rotation = {0, 0, 0}
	},
	[53] = {
		interior = 4,
		name = "Diner 2",
		position = {460, -88.43, 999.62},
		rotation = {0, 0, 0}
	},
	[54] = {
		interior = 4,
		name = "Dirtbike Stadium",
		position = {-1435.869, -662.2505, 1052.465},
		rotation = {0, 0, 0}
	},
	[55] = {
		interior = 4,
		name = "Michelle's Place",
		position = {302.6404, 304.8048, 999.1484},
		rotation = {0, 0, 0}
	},
	[56] = {
		interior = 5,
		name = "Madd Dogg's Mansion",
		position = {1272.9116, -768.9028, 1090.5097},
		rotation = {0, 0, 0}
	},
	[57] = {
		interior = 5,
		name = "Well Stacked Pizza Co.",
		position = {372.3212890625, -133.27734375, 1001.4921875},
		rotation = {0, 0, 0}
	},
	[58] = {
		interior = 5,
		name = "Victim",
		position = {227.5625, -7.5419921875, 1002.2109375},
		rotation = {0, 0, 0}
	},
	[59] = {
		interior = 5,
		name = "Burning Desire House",
		position = {2351.154, -1180.577, 1027.977},
		rotation = {0, 0, 0}
	},
	[60] = {
		interior = 5,
		name = "Burglary House 9",
		position = {22.79996, 1404.642, 1084.43},
		rotation = {0, 0, 0}
	},
	[61] = {
		interior = 5,
		name = "Burglary House 10",
		position = {227.0888671875, 1114.2666015625, 1080.9969482422},
		rotation = {0, 0, 0}
	},
	[62] = {
		interior = 5,
		name = "Burglary House 11",
		position = {140.5107421875, 1365.939453125, 1083.859375},
		rotation = {0, 0, 0}
	},
	[63] = {
		interior = 5,
		name = "The Crack Den",
		position = {318.6767578125, 1115.048828125, 1083.8828125},
		rotation = {0, 0, 0}
	},
	[64] = {
		interior = 5,
		name = "Police Station (Barbara's)",
		position = {322.318359375, 302.396484375, 999.1484375},
		rotation = {0, 0, 0}
	},
	[65] = {
		interior = 5,
		name = "Diner 1",
		position = {448.7435, -110.0457, 1000.0772},
		rotation = {0, 0, 0}
	},
	[66] = {
		interior = 5,
		name = "Ganton Gym",
		position = {772.36328125, -5.5146484375, 1000.7286376953},
		rotation = {0, 0, 0}
	},
	[67] = {
		interior = 5,
		name = "Vank Hoff Hotel",
		position = {2233.650390625, -1114.6142578125, 1050.8828125},
		rotation = {0, 0, 0}
	},
	[68] = {
		interior = 6,
		name = "Ammu-Nation 3",
		position = {296.8642578125, -112.0703125, 1001.515625},
		rotation = {0, 0, 0}
	},
	[69] = {
		interior = 6,
		name = "Ammu-Nation 4",
		position = {316.4541015625, -169.509765625, 999.60101318359},
		rotation = {0, 0, 0}
	},
	[70] = {
		interior = 6,
		name = "LSPD HQ",
		position = {246.7333984375, 63.0712890625, 1003.640625},
		rotation = {0, 0, 0}
	},
	[71] = {
		interior = 6,
		name = "Safe House 3",
		position = {2333.033, -1073.96, 1049.023},
		rotation = {0, 0, 0}
	},
	[72] = {
		interior = 6,
		name = "Safe House 5",
		position = {2196.7109375, -1204.205078125, 1049.0234375},
		rotation = {0, 0, 0}
	},
	[73] = {
		interior = 6,
		name = "Safe House 6",
		position = {2308.6064453125, -1212.41796875, 1049.0234375},
		rotation = {0, 0, 0}
	},
	[74] = {
		interior = 6,
		name = "Cobra Marital Arts Gym",
		position = {774.056640625, -50.0830078125, 1000.5859375},
		rotation = {0, 0, 0}
	},
	[75] = {
		interior = 6,
		name = "24/7 shop 2",
		position = {-27.365234375, -57.5771484375, 1003.546875},
		rotation = {0, 0, 0}
	},
	[76] = {
		interior = 6,
		name = "Millie's Bedroom",
		position = {344.52, 304.821, 999.148},
		rotation = {0, 0, 0}
	},
	[77] = {
		interior = 6,
		name = "Fanny Batter's Brothel",
		position = {744.271, 1437.253, 1102.703},
		rotation = {0, 0, 0}
	},
	[78] = {
		interior = 6,
		name = "Restaurant 2",
		position = {443.981, -65.219, 1050},
		rotation = {0, 0, 0}
	},
	[79] = {
		interior = 6,
		name = "Burglary House 15",
		position = {234.220703125, 1064.42578125, 1084.2111816406},
		rotation = {0, 0, 0}
	},
	[80] = {
		interior = 6,
		name = "Burglary House 16",
		position = {-68.701171875, 1351.806640625, 1080.2109375},
		rotation = {0, 0, 0}
	},
	[81] = {
		interior = 7,
		name = "Ammu-Nation 5 (2 Floors)",
		position = {315.385, -142.242, 999.601},
		rotation = {0, 0, 0}
	},
	[82] = {
		interior = 7,
		name = "8-Track Stadium",
		position = {-1417.872, -276.426, 1051.191},
		rotation = {0, 0, 0}
	},
	[83] = {
		interior = 7,
		name = "Below the Belt Gym",
		position = {773.7890625, -78.080078125, 1000.6616821289},
		rotation = {0, 0, 0}
	},
	[84] = {
		interior = 8,
		name = "Colonel Fuhrberger's House",
		position = {2807.5234375, -1174.1103515625, 1025.5703125},
		rotation = {0, 0, 0}
	},
	[85] = {
		interior = 8,
		name = "Burglary House 22",
		position = {-42.49, 1407.644, 1084.43},
		rotation = {0, 0, 0}
	},
	[86] = {
		interior = 9,
		name = "Unknown safe house",
		position = {2255.09375, -1140.169921875, 1050.6328125},
		rotation = {0, 0, 0}
	},
	[87] = {
		interior = 9,
		name = "Andromada Cargo hold",
		position = {315.48, 984.13, 1959.11},
		rotation = {0, 0, 0}
	},
	[88] = {
		interior = 9,
		name = "Burglary House 12",
		position = {82.8525390625, 1322.6796875, 1083.8662109375},
		rotation = {0, 0, 0}
	},
	[89] = {
		interior = 9,
		name = "Burglary House 13",
		position = {260.642578125, 1237.58203125, 1084.2578125},
		rotation = {0, 0, 0}
	},
	[90] = {
		interior = 9,
		name = "Cluckin' Bell",
		position = {365.67, -11.61, 1000.87},
		rotation = {0, 0, 0}
	},
	[91] = {
		interior = 10,
		name = "Four Dragons Casino",
		position = {2018.384765625, 1017.8740234375, 996.875},
		rotation = {0, 0, 0}
	},
	[92] = {
		interior = 10,
		name = "RC Zero's Battlefield",
		position = {-1128.666015625, 1066.4921875, 1345.7438964844},
		rotation = {0, 0, 0}
	},
	[93] = {
		interior = 10,
		name = "Burger Shot",
		position = {363.0419921875, -74.9619140625, 1001.5078125},
		rotation = {0, 0, 0}
	},
	[94] = {
		interior = 10,
		name = "Burglary House 14",
		position = {24.0498046875, 1340.3623046875, 1084.375},
		rotation = {0, 0, 0}
	},
	[95] = {
		interior = 10,
		name = "Janitor room(Four Dragons Maintenance)",
		position = {1891.396, 1018.126, 31.882},
		rotation = {0, 0, 0}
	},
	[96] = {
		interior = 10,
		name = "Hashbury safe house",
		position = {2269.576171875, -1210.4306640625, 1047.5625},
		rotation = {0, 0, 0}
	},
	[97] = {
		interior = 10,
		name = "24/7 shop 3",
		position = {6.0673828125, -30.60546875, 1003.5494384766},
		rotation = {0, 0, 0}
	},
	[98] = {
		interior = 10,
		name = "Abandoned AC Tower",
		position = {422.0302734375, 2536.4365234375, 10},
		rotation = {0, 0, 0}
	},
	[99] = {
		interior = 10,
		name = "SFPD HQ",
		position = {246.3916015625, 108.1259765625, 1003.21875},
		rotation = {0, 0, 0}
	},
	[100] = {
		interior = 11,
		name = "The Four Dragons Office",
		position = {2011.603, 1017.023, 39.091},
		rotation = {0, 0, 0}
	},
	[101] = {
		interior = 11,
		name = "Ten Green Bottles Bar",
		position = {501.900390625, -67.828125, 998.7578125},
		rotation = {0, 0, 0}
	},
	[102] = {
		interior = 12,
		name = "The Casino",
		position = {1133.158203125, -15.0625, 1000.6796875},
		rotation = {0, 0, 0}
	},
	[103] = {
		interior = 12,
		name = "Macisla's Barbershop",
		position = {411.98046875, -53.673828125, 1001.8984375},
		rotation = {0, 0, 0}
	},
	[104] = {
		interior = 12,
		name = "Safe house 7",
		position = {2237.297, -1077.925, 1049.023},
		rotation = {0, 0, 0}
	},
	[105] = {
		interior = 12,
		name = "Modern safe house",
		position = {2324.499, -1147.071, 1050.71},
		rotation = {0, 0, 0}
	},
	[106] = {
		interior = 13,
		name = "LS Atrium",
		position = {2324.499, -1147.071, 1050.71},
		rotation = {0, 0, 0}
	},
	[107] = {
		interior = 13,
		name = "CJ's Garage",
		position = {2324.499, -1147.071, 1050.71},
		rotation = {0, 0, 0}
	},
	[108] = {
		interior = 14,
		name = "Kickstart Stadium",
		position = {-1464.536, 1557.69, 1052.531},
		rotation = {0, 0, 0}
	},
	[109] = {
		interior = 14,
		name = "Didier Sachs",
		position = {204.0888671875, -168.1689453125, 1000.5234375},
		rotation = {0, 0, 0}
	},
	[110] = {
		interior = 14,
		name = "Francis Int. Airport (Front ext.)",
		position = {-1827.1473, 7.2074, 1061.1435},
		rotation = {0, 0, 0}
	},
	[111] = {
		interior = 14,
		name = "Francis Int. Airport (Baggage Claim/Ticket Sales)",
		position = {-1855.5687, 41.2631, 1061.1435},
		rotation = {0, 0, 0}
	},
	[112] = {
		interior = 14,
		name = "Wardrobe",
		position = {255.719, -41.137, 1002.023},
		rotation = {0, 0, 0}
	},
	[113] = {
		interior = 15,
		name = "Binco",
		position = {207.543, -109.004, 1005.133},
		rotation = {0, 0, 0}
	},
	[114] = {
		interior = 15,
		name = "Blood Bowl Stadium",
		position = {-1423.505859375, 936.16015625, 1036.4901123047},
		rotation = {0, 0, 0}
	},
	[115] = {
		interior = 15,
		name = "Jefferson Motel",
		position = {2227.7724609375, -1150.2373046875, 1025.796875},
		rotation = {0, 0, 0}
	},
	[116] = {
		interior = 15,
		name = "Burglary House 17",
		position = {-284.4794921875, 1471.185546875, 1084.375},
		rotation = {0, 0, 0}
	},
	[117] = {
		interior = 15,
		name = "Burglary House 18",
		position = {327.808, 1479.74, 1084.438},
		rotation = {0, 0, 0}
	},
	[118] = {
		interior = 15,
		name = "Burglary House 19",
		position = {375.572, 1417.439, 1081.328},
		rotation = {0, 0, 0}
	},
	[119] = {
		interior = 15,
		name = "Burglary House 20",
		position = {384.644, 1471.479, 1080.195},
		rotation = {0, 0, 0}
	},
	[120] = {
		interior = 15,
		name = "Burglary House 21",
		position = {294.990234375, 1472.7744140625, 1080.2578125},
		rotation = {0, 0, 0}
	},
	[121] = {
		interior = 16,
		name = "24/7 shop 4",
		position = {-25.8740234375, -140.95703125, 1003.546875},
		rotation = {0, 0, 0}
	},
	[122] = {
		interior = 16,
		name = "LS Tattoo Parlour",
		position = {-204.2294921875, -26.71875, 1002.2734375},
		rotation = {0, 0, 0}
	},
	[123] = {
		interior = 16,
		name = "Sumoring? stadium",
		position = {-1400, 1250, 1040},
		rotation = {0, 0, 0}
	},
	[124] = {
		interior = 17,
		name = "24/7 shop 5",
		position = {-25.7509765625, -187.48046875, 1003.546875},
		rotation = {0, 0, 0}
	},
	[125] = {
		interior = 17,
		name = "Club",
		position = {493.4687, -23.008, 1000.6796},
		rotation = {0, 0, 0}
	},
	[126] = {
		interior = 17,
		name = "Rusty Brown's - Ring Donuts",
		position = {377.003, -192.507, 1000.633},
		rotation = {0, 0, 0}
	},
	[127] = {
		interior = 17,
		name = "The Sherman's Dam Generator Hall",
		position = {-942.132, 1849.142, 5.005},
		rotation = {0, 0, 0}
	},
	[128] = {
		interior = 17,
		name = "Hemlock Tattoo",
		position = {377.003, -192.507, 1000.633},
		rotation = {0, 0, 0}
	},
	[129] = {
		interior = 18,
		name = "Lil Probe Inn",
		position = {-228.796875, 1401.177734375, 27.765625},
		rotation = {0, 0, 0}
	},
	[130] = {
		interior = 18,
		name = "24/7 shop 6",
		position = {-30.8720703125, -91.3359375, 1003.546875},
		rotation = {0, 0, 0}
	},
	[131] = {
		interior = 18,
		name = "Atrium",
		position = {1726.974609375, -1637.888671875, 20.222967147827},
		rotation = {0, 0, 0}
	},
	[132] = {
		interior = 18,
		name = "Warehouse 2",
		position = {1298.7800292969, 1.0887322425842, 1001.0229492188},
		rotation = {0, 0, 0}
	},
	[133] = {
		interior = 18,
		name = "Zip",
		position = {161.2744140625, -96.2490234375, 1001.8046875},
		rotation = {0, 0, 0}
	},
	[134] = {
		interior = 3,
		name = "Garázs - Kicsi",
		position = {615.82659912109, -117.30142974854, 999.35943603516},
		rotation = {0, 0, 270}
	},
	[135] = {
		interior = 1,
		name = "Garázs - Közepes",
		position = {627.26037597656, -5.3791508674622, 1007.625},
		rotation = {0, 0, 270}
	},
	[136] = {
		interior = 1,
		name = "Garázs - Nagy",
		position = {1381.6010742188, -11.174251556396, 1006.3984375},
		rotation = {0, 0, 270}
	},
	[137] = {
		interior = 18,
		name = "Iroda",
		position = {-32.39839553833, -78.046577453613, 965.95001220703},
		rotation = {0, 0, 270}
	}
}

function getGameInteriors()
	return gameInteriors
end

deletedInteriors = {}

availableInteriors = {}

  function getInteriorPosition(interiorId)
	if availableInteriors[interiorId] then
		return availableInteriors[interiorId].entrance.position
	end

	return false
end


function getInteriorName(interiorId)
	if availableInteriors[interiorId] then
		return availableInteriors[interiorId].name
	end

	return false
end

function getInteriorOwner(interiorId)
	if availableInteriors[interiorId] then
		return availableInteriors[interiorId].ownerId
	end

	return false
end

function getInteriorData(interiorId)
	if availableInteriors[interiorId] then
		return availableInteriors[interiorId]
	end

	return false
end

function getInteriorEntrance(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].entrance
		else
			return false
		end
	else
		return false
	end
end

function getInteriorEntrancePosition(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].entrance.position[1], availableInteriors[interiorId].entrance.position[2], availableInteriors[interiorId].entrance.position[3]
		else
			return false
		end
	else
		return false
	end
end

function getInteriorExit(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].exit
		else
			return false
		end
	else
		return false
	end
end

function getInteriorExitPosition(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].exit.position[1], availableInteriors[interiorId].exit.position[2], availableInteriors[interiorId].exit.position[3]
		else
			return false
		end
	else
		return false
	end
end

function getInteriorEntranceIntDim(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].entrance.interior, availableInteriors[interiorId].entrance.dimension
		else
			return false
		end
	else
		return false
	end
end

function getInteriorExitIntDim(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			return availableInteriors[interiorId].exit.interior, availableInteriors[interiorId].exit.dimension
		else
			return false
		end
	else
		return false
	end
end

function getInteriorEditable(interiorId)
	if interiorId then
		if availableInteriors[interiorId] then
			if availableInteriors[interiorId].editable ~= "N" then
				return availableInteriors[interiorId].editable
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end