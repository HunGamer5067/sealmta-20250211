groupTypes = {
	law_enforcement = "Rendvédelem",
	government = "Önkormányzat",
	mafia = "Maffia",
	gang = "Banda",
	organisation = "Szervezet",
	other = "Egyéb"
}

availableGroups = {
	[1] = {
		name = "Rendőrség",
		prefix = "PD",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			megaPhone = true,
			roadBlock = true,
			cuff = true,
			graffitiClean = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true,
			wheelClamp = true
		},
		duty = {
			skins = {281, 282, 283, 284, 288, 289},
			positions = {
				{262.29830932617, 109.57605743408, 1004.6171875, 10, 8}
			},
			armor = 100,
			items = {
				{49, 1},
				{15, 1},
				{147, 1},
				{48, 1},
				{8, 1},
				{135, 1},
				{318, 1},
				{340, 500},
				{325, 1}, -- deagle
				{344, 250}, -- deagle ammo .50 ae
			}
		}
	},
	[2] = {
		name = "Terrorelhárítási Központ",
		prefix = "TEK",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			megaPhone = true,
			roadBlock = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true
		},
		duty = {
			skins = {252, 267, 285, 286, 287,251},
			positions = {
				{254.49725341797, 79.192413330078, 1003.640625, 6, 9}
			},
			armor = 100,
			items = {
				{15, 1},
				{49, 1},
				{147, 1},
				{48, 1},
				{291, 1},
				{30, 1},
				{31, 1},
				{28, 1},

				{319, 1},
				{343, 500},
				{318, 1},
				{340, 350},
				{348, 250},
				{135, 1},
			}
		}
	},
	[3] = {
		name = "Országos Mentőszolgálat",
		prefix = "OMSZ",
		type = "law_enforcement",
		permissions = {
			megaPhone = true,
			bulletExamine = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			heal = true,
		},
		duty = {
			skins = {274, 275, 276, 277, 278, 279, 280, 243},
			positions = {
				{1160.9683837891, -1319.1217041016, 15.421481132507, 0, 0}
			},
			armor = 100,
			items = {
				{150, 1},
				{125, 1},
				{124, 1},
				{482, 1},
			}
		}
	},
	[4] = {
		name = "Nemzeti Nyomozó Iroda",
		prefix = "NNI",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			trackPhone = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			megaPhone = true,
			roadBlock = true,
			heal = true,
			graffitiClean = true,
			cuff = true,
			gov = true,
			hideWeapons = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			hiddenName = true,
			doorRammer = true
		},
		duty = {
			skins = {306, 307, 308, 310, 312},
			positions = {
				{262.67031860352, 109.7388458252, 1004.6171875, 10, 29}
			},
			armor = 100,
			items = {

				{15, 1}, -- Sokkoló
				{147, 1}, -- Faltörő kos
				{48, 1}, -- Bilincs
				{49, 1}, -- Bilincs kulcs
				{291, 1}, -- Villogó

				{313, 1}, -- M4A1 ACOG
				{343, 250}, -- 5X56.45MM

				{331, 1}, -- P90
				{325, 1}, -- Five-Seven
				{344, 500}, -- 5.7x28MM

				{8, 1}, -- Gumibot
				{336, 1}, -- Nikon kamera
				{135, 1}, -- Csekkfüzet
				{150, 1}, -- Esettáska
			}
		}
	},
	[5] = {
		name = "Volgograd Brigada",
		prefix = "VG",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
			
		},
		duty = {
			skins = {102, 103, 104, 105, 106},
			armor = 0,
			items = false
		}
	},
	[6] = {
		name = "Kayseri Connection",
		prefix = "KC",
		type = "mafia",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[7] = {
		name = "Albanian Mafia",
		prefix = "CHGB",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[8] = {
		name = "Nemzeti adó és Vámhivatal",
		prefix = "NAV",
		type = "law_enforcement",
		permissions = {
			tazer = true,
			bulletExamine = true,
			impoundTow = true,
			impoundTowFinal = true,
			megaPhone = true,
			roadBlock = true,
			cuff = true,
			graffitiClean = true,
			gov = true,
			ticket = true,
			departmentRadio = true,
			jail = true,
			doorRammer = true,
			wheelClamp = true
		},
		duty = {
			skins = {81, 82, 83, 84, 85, 86, 87},
			positions = {
				{263.27954101562, 109.94397735596, 1004.6171875, 10, 84}
			},
			armor = 100,
			items = {

				{15, 1}, -- Sokkoló
				{147, 1}, -- Faltörő kos
				{48, 1}, -- Bilincs
				{49, 1}, -- Bilincs kulcs
				{291, 1}, -- Villogó

				{313, 1}, -- M4A1 ACOG
				{343, 250}, -- 5X56.45MM

				{331, 1}, -- P90
				{325, 1}, -- Five-Seven
				{344, 500}, -- 5.7x28MM

				{8, 1}, -- Gumibot
				{336, 1}, -- Nikon kamera
				{135, 1}, -- Csekkfüzet
				{150, 1}, -- Esettáska
			}
		},
	},
	[9] = {
		name = "La Cosa Nostra",
		prefix = "LCN",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[10] = {
		name = "Šibenik Croatian Maffia",
		prefix = "SCM",
		type = "mafia",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[11] = {
		name = "Crips Gang",
		prefix = "BG",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[12] = {
		name = "Shadow Syndicate",
		prefix = "SS",
		type = "mafia",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {150,151,152,153},
			armor = 0,
			items = false
		}
	},
	[13] = {
		name = "Cartel De Lazo",
		prefix = "CDL",
		type = "mafia",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
	[14] = {
		name = "White Knights",
		prefix = "WK",
		type = "gang",
		permissions = {
			sprayGraffiti = true,
			hideWeapons = true,
			canRobATM = true
		},
		duty = {
			skins = {},
			armor = 0,
			items = false
		}
	},
}


for k, v in pairs(availableGroups) do
	if not availableGroups[k].balance then
		availableGroups[k].balance = 0
	end

	if not availableGroups[k].description then
		availableGroups[k].description = "leírás"
	end

	if not availableGroups[k].ranks then
		availableGroups[k].ranks = {}
	end

	for i = 1, 15 do
		if not availableGroups[k].ranks[i] then
			availableGroups[k].ranks[i] = {
				name = "rang " .. i,
				pay = 0
			}
		end
	end
end

function getGroups()
	return availableGroups
end

function getGroupTypes()
	return groupTypes
end

function getGroupData(groupId)
	return availableGroups[groupId]
end

function addPlayerGroup(playerElement, groupId, dutySkin)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if not playerGroups[groupId] then
						if not dutySkin then
							dutySkin = availableGroups[groupId].duty.skins[1]
						end

						playerGroups[groupId] = {1, dutySkin, "N"}
						setElementData(playerElement, "player.groups", playerGroups)

						return true
					end
				end
			end
		end
	end
	
	return false
end

function removePlayerGroup(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId] = nil
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function setPlayerLeader(playerElement, groupId, state)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId][3] = state
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function isPlayerLeaderInGroup(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						if utf8.lower(playerGroups[groupId][3]) == "y" then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

function isPlayerInGroup(playerElement, groups)
	if isElement(playerElement) then
		if groups then
			if type(groups) == "table" then
				local playerGroups = getElementData(playerElement, "player.groups") or {}

				if playerGroups then
					for i = 1, #groups do
						local groupId = groups[i]

						if availableGroups[groupId] then
							if playerGroups[groupId] then
								return groupId
							end
						end
					end
				end
			else
				local groupId = tonumber(groups)
				
				if availableGroups[groupId] then
					local playerGroups = getElementData(playerElement, "player.groups") or {}
					
					if playerGroups then
						if playerGroups[groupId] then
							return groupId
						end
					end
				end
			end
		end
	end

	return false
end

function getPlayerGroups(playerElement)
	if isElement(playerElement) then
		local playerGroups = getElementData(playerElement, "player.groups") or {}
		
		if playerGroups then
			return playerGroups
		end
	end
	
	return false
end

function getPlayerGroupCount(playerElement)
	if isElement(playerElement) then
		local playerGroups = getElementData(playerElement, "player.groups") or {}
		local groupCounter = 0
		
		for k, v in pairs(playerGroups) do
			groupCounter = groupCounter + 1
		end

		return groupCounter
	end
	
	return false
end

function setPlayerRank(playerElement, groupId, rankId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)
		rankId = tonumber(rankId)

		if groupId and rankId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}
				
				if playerGroups then
					if playerGroups[groupId] then
						playerGroups[groupId][1] = rankId
						setElementData(playerElement, "player.groups", playerGroups)
						return true
					end
				end
			end
		end
	end
	
	return false
end

function getPlayerRank(playerElement, groupId)
	if isElement(playerElement) then
		groupId = tonumber(groupId)

		if groupId then
			if availableGroups[groupId] then
				local playerGroups = getElementData(playerElement, "player.groups") or {}

				if playerGroups then
					if playerGroups[groupId] then
						local rankId = playerGroups[groupId][1]

						if rankId then
							if availableGroups[groupId].ranks[rankId] then
								return rankId, availableGroups[groupId].ranks[rankId].name, availableGroups[groupId].ranks[rankId].pay
							end
						end
					end
				end
			end
		end
	end

	return false
end

function getGroupPrefix(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].prefix
		end
	end
	
	return false
end

function getGroupName(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].name
		end
	end
	
	return false
end

function getGroupType(groupId)
	if groupId then
		if availableGroups[groupId] then
			return availableGroups[groupId].type
		end
	end
	
	return false
end

function isPlayerHavePermission(playerElement, permission)
	if isElement(playerElement) and permission then
		local playerGroups = getElementData(playerElement, "player.groups") or {}

		if playerGroups then
			for k, v in pairs(playerGroups) do
				if availableGroups[k] and availableGroups[k].permissions[permission] then
					return k
				end
			end
		end
	end

	return false
end

function thousandsStepper(amount)
	local left, center, right = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1 ")) .. right
end

function isPlayerOfficer(playerElement)
	return isPlayerInGroup(playerElement, {1, 2, 3, 4, 8})
end

function getGroupSkins(groupId)
	if availableGroups[groupId] then
		return availableGroups[groupId].duty.skins
	end
	return {}
end