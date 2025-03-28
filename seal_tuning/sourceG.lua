tuningPositions = {
	{1025.5280761719, -909.82281494141, 40, 0},
}

componentOffsets = {
	wheel_lf_dummy = {4, 0.25, 0, 0, -0.25, 0},
	bump_front_dummy = {-0.25, 4, 0.15, -0.25, 0, 0},
	bump_rear_dummy = {0.25, -4, 0.25, 0.25, 0, 0},
	bonnet_dummy = {0, 4, 2, 0, 0, 0},
	exhaust_ok = {0, -5, 1, 0, 0, 0},
	door_rf_dummy = {4, -0.75, -0.25, 0, -0.75, -0.5},
	boot_dummy = {0, -4.5, 1.25, 0, -1, 0},
	boot_dummy_excomp = {0, -5.25, 2.5, 0, -1, 0}
}



doubleExhaust = {
	[579] = true,
	[445] = true,
	[400] = true,
	[596] = true,
	[598] = true,
	[599] = true,
	[597] = true,
	[489] = true,
	[405] = true,
	[566] = true,
	[466] = true,
	[547] = true,
	[602] = true,
	[516] = true,
	[549] = true,
	[401] = true,
	[492] = true,
	[404] = true,
	[466] = true,
	[400] = true,
	[589] = true,
	
	[401] = true,
	[404] = true,
	[405] = true,
	[419] = true,
	[421] = true,
	[424] = true,
	[426] = true,
	[436] = true,
	[438] = true,
	[445] = true,
	[466] = true,
	[475] = true,
	[480] = true,
	[490] = true,
	[492] = true,
	[495] = true,
	[507] = true,
	[517] = true,
	[527] = true,
	
	[604] = true,
	[599] = true,
	[598] = true,
	[597] = true,
	[596] = true,
	[580] = true,
	[579] = true,
	[576] = true,
	[567] = true,
	[551] = true,
	[549] = true,
}

singleExhaust = {
	[540] = true,
	[562] = true,
	[602] = true,
	[565] = true,
	[562] = true,
	[561] = true,
	[559] = true,
	[458] = true,
	[603] = true,
	[436] = true,
}

noExhaust = {}

tuningEffect = {
	Engine = {
		maxVelocity = {
			0,
			0,
			0,
			15
		  },
		  engineAcceleration = {
			1,
			1.5,
			2.5,
			10
		  }
	},
	Turbo = {
		engineAcceleration = {
			1,
			1.5,
			2.5,
			10
		  }
	},
	ECU = {
		maxVelocity = {
			0,
			0,
			0,
			15
		  },
		  engineAcceleration = {
			1,
			1.5,
			2,
			10
		  }
	},
	Transmission = {
		maxVelocity = {
			0,
			0,
			0,
			15
		  },
		  engineAcceleration = {
			0.1,
			0.2,
			0.3,
			20
		  }
	},
	Suspension = {
		suspensionDamping = {
			0.1,
			0.2,
			0.3,
			0.5
		  }
	},
	Brakes = {
		brakeDeceleration = {
			0.1,
			0.2,
			0.3,
			0.5
		  }
	},
	Tires = {
		tractionMultiplier = {
			0.1,
			0.2,
			0.3,
			0.5
		  },
		  tractionLoss = {
			0.1,
			0.2,
			0.3,
			0.5
		  }
	},
	WeightReduction = {
		mass = {
			-0.1,
			-0.2,
			-0.3,
			-0.5
		  }
	}
}

handlingFlags = {
	_1G_BOOST = 0x1,
	_2G_BOOST = 0x2,
	NPC_ANTI_ROLL = 0x4,
	NPC_NEUTRAL_HANDL = 0x8,
	NO_HANDBRAKE = 0x10,
	STEER_REARWHEELS = 0x20,
	HB_REARWHEEL_STEER = 0x40,
	ALT_STEER_OPT = 0x80,
	WHEEL_F_NARROW2 = 0x100,
	WHEEL_F_NARROW = 0x200,
	WHEEL_F_WIDE = 0x400,
	WHEEL_F_WIDE2 = 0x800,
	WHEEL_R_NARROW2 = 0x1000,
	WHEEL_R_NARROW = 0x2000,
	WHEEL_R_WIDE = 0x4000,
	WHEEL_R_WIDE2 = 0x8000,
	HYDRAULIC_GEOM = 0x10000,
	HYDRAULIC_INST = 0x20000,
	HYDRAULIC_NONE = 0x40000,
	NOS_INST = 0x80000,
	OFFROAD_ABILITY = 0x100000,
	OFFROAD_ABILITY2 = 0x200000,
	HALOGEN_LIGHTS = 0x400000,
	PROC_REARWHEEL_1ST = 0x800000,
	USE_MAXSP_LIMIT = 0x1000000,
	LOW_RIDER = 0x2000000,
	STREET_RACER = 0x4000000,
	SWINGING_CHASSIS = 0x10000000
}

modelFlags = {
	IS_VAN = 0x1,
	IS_BUS = 0x2,
	IS_LOW = 0x4,
	IS_BIG = 0x8,
	REVERSE_BONNET = 0x10,
	HANGING_BOOT = 0x20,
	TALIGATE_BOOT = 0x40,
	NOSWING_BOOT = 0x80,
	NO_DOORS = 0x100,
	TANDEM_SEATS = 0x200,
	SIT_IN_BOAT = 0x400,
	CONVERTIBLE = 0x800,
	NO_EXHAUST = 0x1000,
	DBL_EXHAUST = 0x2000,
	NO1FPS_LOOK_BEHIND = 0x4000,
	FORCE_DOOR_CHECK = 0x8000,
	AXLE_F_NOTILT = 0x10000,
	AXLE_F_SOLID = 0x20000,
	AXLE_F_MCPHERSON = 0x40000,
	AXLE_F_REVERSE = 0x80000,
	AXLE_R_NOTILT = 0x100000,
	AXLE_R_SOLID = 0x200000,
	AXLE_R_MCPHERSON = 0x400000,
	AXLE_R_REVERSE = 0x800000,
	IS_BIKE = 0x1000000,
	IS_HELI = 0x2000000,
	IS_PLANE = 0x4000000,
	IS_BOAT = 0x8000000,
	BOUNCE_PANELS = 0x10000000,
	DOUBLE_RWHEELS = 0x20000000,
	FORCE_GROUND_CLEARANCE = 0x40000000,
	IS_HATCHBACK = 0x80000000
}

componentNames = {
	[1025] = "Zender Dynamic",
	[1073] = "WedsSport TC105N",
	[1074] = "Vossen 305T",
	[1075] = "Ronal Turbo",
	[1076] = "Dayton 100 Spoke",
	[1077] = "Hamann Edition Race",
	[1078] = "Dunlop Drag",
	[1079] = "Lemezfelni",
	[1080] = "Advan Racing RGII",
	[1081] = "Classic",
	[1082] = "Volk Racing TE37",
	[1083] = "Dub Bigchips",
	[1084] = "Borbet A",
	[1085] = "BBS RS",
	[1096] = "Fifteen52",
	[1097] = "AMG Monoblock",
	[1098] = "American Racing"
}

function isFlagSet(val, flag)
	return (bitAnd(val, flag) == flag)
end

function getVehicleHandlingFlags(vehicle)
	local flagBytes = getVehicleHandling(vehicle).handlingFlags
	local flagKeyed = {}

	for k, v in pairs(handlingFlags) do
		if isFlagSet(flagBytes, v) then
			flagKeyed[k] = true
		end
	end

	return flagKeyed, flagBytes
end

function getVehicleModelFlags(vehicle)
	local flagBytes = getVehicleHandling(vehicle).modelFlags
	local flagKeyed = {}

	for k, v in pairs(modelFlags) do
		if isFlagSet(flagBytes, v) then
			flagKeyed[k] = true
		end
	end

	return flagKeyed, flagBytes
end

evTuningContainer = {
	[1] = {
		name = "Teljesítmény",
		icon = "files/icons/teljesitmeny.png",
		subMenu = {
			[1] = {
				name = "Villanymotor",
				icon = "files/icons/performance/motor.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Engine",
				subMenu = {
					[1] = {
						name = "Gyári Villanymotor",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap Villanymotor",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 750
					},
					[3] = {
						name = "Profi Villanymotor",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 7500
					},
					[4] = {
						name = "Verseny Villanymotor",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom Villanymotor",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Engine", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningEngine = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Engine") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Akkumulátor",
				icon = "files/icons/performance/turbo.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Turbo",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap Akkumulátor",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1250
					},
					[3] = {
						name = "Profi Akkumulátor",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 6000
					},
					[4] = {
						name = "Verseny Akkumulátor",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 17500
					},
					[5] = {
						name = "Venom Akkumulátor",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					},
					[6] = {
						name = "Venom+Supercharger",
						icon = "files/icons/sch.png",
						value = 5,
						supercharger = true,
						priceType = "premium",
						price = 1200
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Turbo", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTurbo = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Turbo") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "ECU",
				icon = "files/icons/performance/ecu.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.ECU",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 6000
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 12500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 25000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					},
					[6] = {
						name = "Egyedi ECU",
						icon = "files/icons/pp.png",
						value = 5,
						priceType = "premium",
						price = 5400
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.ECU", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningECU = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.ECU") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Inverter",
				icon = "files/icons/performance/valto.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Transmission",
				subMenu = {
					[1] = {
						name = "Gyári Inverter",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap Inverter",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1400
					},
					[3] = {
						name = "Profi Inverter",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 8000
					},
					[4] = {
						name = "Verseny Inverter",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 12500
					},
					[5] = {
						name = "Venom Inverter",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Transmission", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTransmission = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Transmission") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Felfüggesztés",
				icon = "files/icons/performance/felfugg.png",
				camera = "wheel_lf_dummy",
				hideComponent = "wheel_rf_dummy",
				checkData = "vehicle.tuning.Suspension",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 5000
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 12500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 25000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Suspension", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningSuspension = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Suspension") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Fékek",
				icon = "files/icons/performance/fek.png",
				camera = "wheel_lf_dummy",
				hideComponent = false,
				checkData = "vehicle.tuning.Brakes",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 3250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 9000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Brakes", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningBrakes = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Brakes") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Gumik",
				icon = "files/icons/performance/gumi.png",
				camera = "wheel_lf_dummy",
				hideComponent = false,
				checkData = "vehicle.tuning.Tires",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 4000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 7500
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Tires", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTires = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Tires") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Súlycsökkentés",
				icon = "files/icons/performance/sulycsokkentes.png",
				camera = false,
				hideComponent = false,
				checkData = "vehicle.tuning.WeightReduction",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 4250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 7500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.WeightReduction", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningWeightReduction = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.WeightReduction") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			}
		}
	},
	[2] = {
		name = "Fényezés",
		icon = "files/icons/fenyezes.png",
		subMenu = {
			[1] = {
				name = "Szín 1",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 1,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[2] = {
				name = "Szín 2",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 2,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[3] = {
				name = "Szín 3",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 3,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[4] = {
				name = "Szín 4",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 4,
				priceType = "money",
				price = 10000,
				subMenu = false
			}
		}
	},
	[3] = {
		name = "Matrica",
		icon = "files/icons/extra.png",
		subMenu = {
			[1] = {
				name = "Lámpa csere",
				icon = "files/icons/optical/hatsolampa.png",
				id = "headlight",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalHeadLight == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Paintjob",
				icon = "files/icons/fenyezes.png",
				id = "paintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalPaintjob == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Kerék paintjob",
				icon = "files/icons/fenyezes.png",
				id = "wheelPaintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalWheelPaintjob == value then
						return true
					else
						return false
					end
				end
			},
		}
	},
	[4] = {
		name = "Elemek",
		icon = "files/icons/optika.png",
		subMenu = {
			[1] = {
				name = "Első lökhárító",
				icon = "files/icons/optical/elso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_front_dummy",
				upgradeSlot = 14,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Hátsó lökhárító",
				icon = "files/icons/optical/hatso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_rear_dummy",
				upgradeSlot = 15,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Küszöb",
				icon = "files/icons/optical/kuszob.png",
				priceType = "money",
				price = 1000,
				camera = "door_rf_dummy",
				upgradeSlot = 3,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Motorháztető",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "bonnet_dummy",
				upgradeSlot = 0,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Légterelő",
				icon = "files/icons/optical/legterelo.png",
				priceType = "money",
				price = 1500,
				camera = "boot_dummy_excomp",
				upgradeSlot = 2,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Tetőlégterelő",
				icon = "files/icons/optical/tetolegterelo.png",
				priceType = "money",
				price = 1000,
				upgradeSlot = 7,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Egyedi kerekek",
				icon = "files/icons/misc.png",
				camera = "base",
				id = "customwheel",
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = 0,
						id = "remove",
					},
					[2] = {
						name = "Szerkesztés",
						icon = "files/icons/misc.png",
						priceType = "premium",
						price = 7500,
						value = 1,
						id = "customwheel",
					},
				},
				serverFunction = function (vehicle, value)
					return false
				end,
				clientFunction = function (vehicle, value)
					return false
				end
			},
			[8] = {
				name = "Izzó szín",
				icon = "files/icons/optical/izzo.png",
				priceType = "money",
				price = 2500,
				id = "color",
				id2 = "headLightColor",
				camera = "lightpaint",
				subMenu = {
					[1] = {
						name = "Izzó szín",
						icon = "files/icons/optical/izzo.png",
						colorPicker = true,
						colorId = 5,
						priceType = "money",
						price = 2500
					}
				}
			},
			[9] = {
				name = "Neon",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "door_rf_dummy",
				id = "neon",
				subMenu = {
					[1] = {
						name = "Piros",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8628
					},
					[2] = {
						name = "Kék",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8626
					},
					[3] = {
						name = "Zöld",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8627
					},
					[4] = {
						name = "Citromsárga",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8582
					},
					[5] = {
						name = "Rózsaszín",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7041
					},
					[6] = {
						name = "Fehér",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7045
					},
					[7] = {
						name = "Raszta",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6882
					},
					[8] = {
						name = "Világoskék",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7252
					},
					[9] = {
						name = "Narancssárga",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7253
					},
					[10] = {
						name = "Eltávolítás",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "tuning.neon", value)
					setElementData(vehicle, "tuning.neon.state", 0)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if neonId == value then
						return true
					else
						return false
					end
				end
			},
			[10] = {
				name = "Spinner",
				icon = "files/icons/spinner.png",
				priceType = "premium",
				price = 1000,
				camera = "base",
				isSpinner = true,
				subMenu = {
					[1] = {
						name = "1. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8539
					},
					[2] = {
						name = "1. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8538,
						colorPicker = true,
						colorId = 6
					},
					[3] = {
						name = "2. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8525
					},
					[4] = {
						name = "2. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8850,
						colorPicker = true,
						colorId = 6
					},
					[5] = {
						name = "3. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 9166
					},
					[6] = {
						name = "3. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 9167,
						colorPicker = true,
						colorId = 6
					},
					[7] = {
						name = "4. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8633
					},
					[8] = {
						name = "4. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8540,
						colorPicker = true,
						colorId = 6
					},
					[9] = {
						name = "Leszerel",
						icon = "files/icons/spinner.png",
						priceType = "free",
						price = 0,
						isSpinnerItem = true,
						value = false
					}
				},
				clientFunction = function (vehicle, value)
					if exports.seal_spinner:getOriginalSpinner() == value then
						return true
					else
						return false
					end
				end
			}
		}
	},
	[5] = {
		name = "Elem leszerelés",
		icon = "files/icons/optika.png",
		subMenu = {
			[1] = {
				name = "Első lökhárító",
				icon = "files/icons/optical/elso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_front_dummy",
				removeableComponent = "bump_front_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bump_front_dummy"] = false
					else
						removedComponents["bump_front_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bump_front_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Hátsó lökhárító",
				icon = "files/icons/optical/hatso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_rear_dummy",
				removeableComponent = "bump_rear_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bump_rear_dummy"] = false
					else
						removedComponents["bump_rear_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bump_rear_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Motorháztető",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "bonnet_dummy",
				removeableComponent = "bonnet_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bonnet_dummy"] = false
					else
						removedComponents["bonnet_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bonnet_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Csomagtartó",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "boot_dummy",
				removeableComponent = "boot_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["boot_dummy"] = false
					else
						removedComponents["boot_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["boot_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
		}
	},
	[6] = {
		name = "Extrák",
		icon = "files/icons/extra.png",
		subMenu = {
			[1] = {
				name = "LSD ajtó",
				icon = "files/icons/optical/lsd.png",
				camera = "base",
				id = "door",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "premium",
						price = 1000,
						value = "scissor"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "free",
						price = 0,
						value = nil
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.DoorType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDoorType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if originalDoor == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Első kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "bump_front_dummy",
				id = "handling",
				handlingPrefix = "WHEEL_F_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_F_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_F_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Hátsó kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "bump_rear_dummy",
				id = "handling",
				handlingPrefix = "WHEEL_R_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_R_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Meghajtás",
				icon = "files/icons/optical/meghajtas.png",
				subMenu = {
					[1] = {
						name = "Elsőkerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "fwd"
					},
					[2] = {
						name = "Összkerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "awd"
					},
					[3] = {
						name = "Hátsókerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "rwd"
					},
					[4] = {
						name = "Kapcsolható",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 50000,
						value = "tog"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					if value == "tog" then
						setVehicleHandling(vehicle, "driveType", "awd")
						setElementData(vehicle, "activeDriveType", "awd")
					else
						setVehicleHandling(vehicle, "driveType", value)
					end

					setElementData(vehicle, "vehicle.tuning.DriveType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDriveType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.DriveType")

					if not current then
						current = getVehicleHandling(vehicle).driveType
					end

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Fordulókör",
				icon = "files/icons/slock.png",
				subMenu = {
					[1] = {
						name = "30°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 30
					},
					[2] = {
						name = "40°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 40
					},
					[3] = {
						name = "50°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 50
					},
					[4] = {
						name = "60°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 60
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setVehicleHandling(vehicle, "steeringLock", value)
					setElementData(vehicle, "vehicle.tuning.SteeringLock", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningSteeringLock = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if getVehicleHandling(vehicle).steeringLock == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Önzáró differenciálmű",
				icon = "files/icons/diff.png",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "SOLID"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "NORMAL"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleModelFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "AXLE_R_") then
							flagBytes = flagBytes - modelFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + modelFlags["AXLE_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "modelFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.modelFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET modelFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).modelFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, modelFlags["AXLE_R_SOLID"]) then
						activeFlag = "SOLID"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Offroad optimalizáció",
				icon = "files/icons/optical/offroad.png",
				subMenu = {
					[1] = {
						name = "Nincs optimalizálva",
						icon = "files/icons/optical/offroad.png",
						priceType = "free",
						price = 0,
						value = "NORMAL"
					},
					[2] = {
						name = "Terep beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY"
					},
					[3] = {
						name = "Murva beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "OFFROAD_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["OFFROAD_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).handlingFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY"]) then
						activeFlag = "ABILITY"
					elseif isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY2"]) then
						activeFlag = "ABILITY2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Rendszám",
				icon = "files/icons/optical/plate.png",
				camera = "bump_rear_dummy",
				id = "licensePlate",
				subMenu = {
					[1] = {
						name = "Gyári rendszám",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = "default"
					},
					[2] = {
						name = "Egyedi rendszám",
						icon = "files/icons/pp.png",
						licensePlate = true,
						priceType = "premium",
						price = 1200,
						value = "custom"
					}
				}
			},
			[9] = {
				name = "Traffipax radar",
				icon = "files/icons/optical/speedtrap.png",
				priceType = "money",
				price = 15000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "money",
						price = 15000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "traffipaxRadarInVehicle", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET traffipaxRadar = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "traffipaxRadarInVehicle") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[10] = {
				name = "Variáns",
				icon = "files/icons/variant.png",
				priceType = "money",
				price = 50000,
				camera = "base",
				variantEditor = true
			},
			[11] = {
				name = "Navigációs rendszer",
				icon = "files/icons/gps.png",
				priceType = "money",
				price = 3000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/gps.png",
						priceType = "money",
						price = 3000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/gps.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.GPS", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET gpsNavigation = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.GPS") or 0

					if value == 1 and current >= 1 or current == value then
						return true
					else
						return false
					end
				end
			},
			[12] = {
				name = "Egyedi duda",
				icon = "files/icons/horn.png",
				priceType = "premium",
				price = 1200,
				camera = "base",
				hornSound = true,
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/horn.png",
						priceType = "free",
						price = 0,
						value = 0
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "customHorn", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET customHorn = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "customHorn") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[13] = {
				name = "Hidraulika",
				icon = "files/icons/optical/hidra.png",
				priceType = "money",
				price = 15000,
				upgradeSlot = 9,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[14] = {
				name = "Air-Ride",
				icon = "files/icons/optical/airride.png",
				priceType = "premium",
				price = 1200,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "premium",
						price = 1200,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local currUpgrades = (getElementData(vehicle, "vehicle.tuning.Optical") or ""):gsub("1087,", "")
					local hydraulicsUpgrade = getVehicleUpgradeOnSlot(vehicle, 9)

					if hydraulicsUpgrade then
						removeVehicleUpgrade(vehicle, hydraulicsUpgrade)
					end

					setElementData(vehicle, "vehicle.tuning.AirRide", value)
					setElementData(vehicle, "vehicle.tuning.Optical", currUpgrades)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningAirRide = ?, tuningOptical = ? WHERE vehicleId = ?", value, currUpgrades, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.AirRide") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
		}
	},
}

tuningContainer = {
	[1] = {
		name = "Teljesítmény",
		icon = "files/icons/teljesitmeny.png",
		subMenu = {
			[1] = {
				name = "Motor",
				icon = "files/icons/performance/motor.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Engine",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 750
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 7500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Engine", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningEngine = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Engine") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Turbó, Supercharger",
				icon = "files/icons/performance/turbo.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Turbo",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 6000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 17500
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					},
					[6] = {
						name = "Venom+Supercharger",
						icon = "files/icons/sch.png",
						value = 5,
						supercharger = true,
						priceType = "premium",
						price = 1200
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Turbo", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTurbo = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Turbo") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "ECU",
				icon = "files/icons/performance/ecu.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.ECU",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 6000
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 12500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 25000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					},
					[6] = {
						name = "Egyedi ECU",
						icon = "files/icons/pp.png",
						value = 5,
						priceType = "premium",
						price = 5400
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.ECU", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningECU = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.ECU") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Váltó",
				icon = "files/icons/performance/valto.png",
				camera = "bonnet_dummy",
				hideComponent = "bonnet_dummy",
				checkData = "vehicle.tuning.Transmission",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1400
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 8000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 12500
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Transmission", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTransmission = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Transmission") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Felfüggesztés",
				icon = "files/icons/performance/felfugg.png",
				camera = "wheel_lf_dummy",
				hideComponent = "wheel_rf_dummy",
				checkData = "vehicle.tuning.Suspension",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 5000
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 12500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 25000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Suspension", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningSuspension = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Suspension") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Fékek",
				icon = "files/icons/performance/fek.png",
				camera = "wheel_lf_dummy",
				hideComponent = false,
				checkData = "vehicle.tuning.Brakes",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 3250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 9000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Brakes", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningBrakes = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Brakes") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Gumik",
				icon = "files/icons/performance/gumi.png",
				camera = "wheel_lf_dummy",
				hideComponent = false,
				checkData = "vehicle.tuning.Tires",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 1250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 4000
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 7500
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.Tires", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningTires = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.Tires") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Nitro",
				icon = "files/icons/performance/nitro.png",
				camera = "boot_dummy",
				hideComponent = "boot_dummy",
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "25%",
						icon = "files/icons/dollar.png",
						value = 25,
						priceType = "money",
						price = 700000
					},
					[3] = {
						name = "50%",
						icon = "files/icons/dollar.png",
						value = 50,
						priceType = "money",
						price = 1300000
					},
					[4] = {
						name = "75%",
						icon = "files/icons/dollar.png",
						value = 75,
						priceType = "money",
						price = 1900000
					},
					[5] = {
						name = "100%",
						icon = "files/icons/dollar.png",
						value = 100,
						priceType = "money",
						price = 2500000
					},
					--[[[6] = {
						name = "25% (Prémium)",
						icon = "files/icons/pp.png",
						value = "25",
						priceType = "premium",
						price = 5000
					},
					[7] = {
						name = "50% (Prémium)",
						icon = "files/icons/pp.png",
						value = "50",
						priceType = "premium",
						price = 9000
					},
					[8] = {
						name = "75% (Prémium)",
						icon = "files/icons/pp.png",
						value = "75",
						priceType = "premium",
						price = 13000
					},
					[9] = {
						name = "100% (Prémium)",
						icon = "files/icons/pp.png",
						value = "100",
						priceType = "premium",
						price = 17000
					}]]
				},
				serverFunction = function (vehicle, value)
					local nitroLevel = getElementData(vehicle, "vehicle.nitroLevel") or 0

					if nitroLevel then
						local premium = false
						if type(value) == "string" then
							premium = true
							value = tonumber(value)
						end
						if premium and getElementData(vehicle, "vehicle.nitroState") ~= "premium" and nitroLevel > 0 then
							setElementData(vehicle, "vehicle.nitroLevel", 0)
							nitroLevel = getElementData(vehicle, "vehicle.nitroLevel") or 0
						end
						setElementData(vehicle, "vehicle.nitroState", (premium and "premium") or "noPremium")
						if value > 0 then
							if nitroLevel + value <= 100 then
								setElementData(vehicle, "vehicle.nitroLevel", nitroLevel + value)
							else
								setElementData(vehicle, "vehicle.nitroLevel", 100)
							end
						else
							setElementData(vehicle, "vehicle.nitroLevel", 0)
						end
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					return false
				end
			},
			[9] = {
				name = "Súlycsökkentés",
				icon = "files/icons/performance/sulycsokkentes.png",
				camera = false,
				hideComponent = false,
				checkData = "vehicle.tuning.WeightReduction",
				subMenu = {
					[1] = {
						name = "Gyári",
						icon = "files/icons/free.png",
						value = 0,
						priceType = "free",
						price = 0
					},
					[2] = {
						name = "Alap csomag",
						icon = "files/icons/dollar.png",
						value = 1,
						priceType = "money",
						price = 4250
					},
					[3] = {
						name = "Profi csomag",
						icon = "files/icons/dollar.png",
						value = 2,
						priceType = "money",
						price = 7500
					},
					[4] = {
						name = "Verseny csomag",
						icon = "files/icons/dollar.png",
						value = 3,
						priceType = "money",
						price = 15000
					},
					[5] = {
						name = "Venom csomag",
						icon = "files/icons/pp.png",
						value = 4,
						priceType = "premium",
						price = 900
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.WeightReduction", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningWeightReduction = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.WeightReduction") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			}
		}
	},
	[2] = {
		name = "Fényezés",
		icon = "files/icons/fenyezes.png",
		subMenu = {
			[1] = {
				name = "Szín 1",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 1,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[2] = {
				name = "Szín 2",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 2,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[3] = {
				name = "Szín 3",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 3,
				priceType = "money",
				price = 10000,
				subMenu = false
			},
			[4] = {
				name = "Szín 4",
				icon = "files/icons/fenyezes.png",
				id = "color",
				colorPicker = true,
				colorId = 4,
				priceType = "money",
				price = 10000,
				subMenu = false
			}
		}
	},
	[3] = {
		name = "Matrica",
		icon = "files/icons/extra.png",
		subMenu = {
			[1] = {
				name = "Lámpa csere",
				icon = "files/icons/optical/hatsolampa.png",
				id = "headlight",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalHeadLight == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Paintjob",
				icon = "files/icons/fenyezes.png",
				id = "paintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalPaintjob == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Kerék paintjob",
				icon = "files/icons/fenyezes.png",
				id = "wheelPaintjob",
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalWheelPaintjob == value then
						return true
					else
						return false
					end
				end
			},
		}
	},
	[4] = {
		name = "Elemek",
		icon = "files/icons/optika.png",
		subMenu = {
			[1] = {
				name = "Első lökhárító",
				icon = "files/icons/optical/elso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_front_dummy",
				upgradeSlot = 14,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Hátsó lökhárító",
				icon = "files/icons/optical/hatso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_rear_dummy",
				upgradeSlot = 15,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Küszöb",
				icon = "files/icons/optical/kuszob.png",
				priceType = "money",
				price = 1000,
				camera = "door_rf_dummy",
				upgradeSlot = 3,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Motorháztető",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "bonnet_dummy",
				upgradeSlot = 0,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Légterelő",
				icon = "files/icons/optical/legterelo.png",
				priceType = "money",
				price = 1500,
				camera = "boot_dummy_excomp",
				upgradeSlot = 2,
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Tetőlégterelő",
				icon = "files/icons/optical/tetolegterelo.png",
				priceType = "money",
				price = 1000,
				upgradeSlot = 7,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Egyedi kerekek",
				icon = "files/icons/misc.png",
				camera = "base",
				id = "customwheel",
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = 0,
						id = "remove",
					},
					[2] = {
						name = "Szerkesztés",
						icon = "files/icons/misc.png",
						priceType = "premium",
						price = 7500,
						value = 1,
						id = "customwheel",
					},
				},
				serverFunction = function (vehicle, value)
					return false
				end,
				clientFunction = function (vehicle, value)
					return false
				end
			},
			[8] = {
				name = "Kipufogó",
				icon = "files/icons/optical/kipufogo.png",
				priceType = "money",
				price = 2000,
				upgradeSlot = 13,
				camera = "exhaust_ok",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[9] = {
				name = "Izzó szín",
				icon = "files/icons/optical/izzo.png",
				priceType = "money",
				price = 2500,
				id = "color",
				id2 = "headLightColor",
				camera = "lightpaint",
				subMenu = {
					[1] = {
						name = "Izzó szín",
						icon = "files/icons/optical/izzo.png",
						colorPicker = true,
						colorId = 5,
						priceType = "money",
						price = 2500
					}
				}
			},
			[10] = {
				name = "Neon",
				icon = "files/icons/optical/neon.png",
				priceType = "money",
				price = 5000,
				camera = "door_rf_dummy",
				id = "neon",
				subMenu = {
					[1] = {
						name = "Piros",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8628
					},
					[2] = {
						name = "Kék",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8626
					},
					[3] = {
						name = "Zöld",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8627
					},
					[4] = {
						name = "Citromsárga",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 8582
					},
					[5] = {
						name = "Rózsaszín",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7041
					},
					[6] = {
						name = "Fehér",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7045
					},
					[7] = {
						name = "Raszta",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 6882
					},
					[8] = {
						name = "Világoskék",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7252
					},
					[9] = {
						name = "Narancssárga",
						icon = "files/icons/optical/neon.png",
						priceType = "money",
						price = 5000,
						value = 7253
					},
					[10] = {
						name = "Eltávolítás",
						icon = "files/icons/optical/neon.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "tuning.neon", value)
					setElementData(vehicle, "tuning.neon.state", 0)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningNeon = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if neonId == value then
						return true
					else
						return false
					end
				end
			},
			[11] = {
				name = "Spinner",
				icon = "files/icons/spinner.png",
				priceType = "premium",
				price = 1000,
				camera = "base",
				isSpinner = true,
				subMenu = {
					[1] = {
						name = "1. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8539
					},
					[2] = {
						name = "1. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8538,
						colorPicker = true,
						colorId = 6
					},
					[3] = {
						name = "2. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8525
					},
					[4] = {
						name = "2. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8850,
						colorPicker = true,
						colorId = 6
					},
					[5] = {
						name = "3. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 9166
					},
					[6] = {
						name = "3. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 9167,
						colorPicker = true,
						colorId = 6
					},
					[7] = {
						name = "4. típus - króm",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8633
					},
					[8] = {
						name = "4. típus - színezhető",
						icon = "files/icons/spinner.png",
						priceType = "premium",
						price = 1000,
						isSpinnerItem = true,
						value = 8540,
						colorPicker = true,
						colorId = 6
					},
					[9] = {
						name = "Leszerel",
						icon = "files/icons/spinner.png",
						priceType = "free",
						price = 0,
						isSpinnerItem = true,
						value = false
					}
				},
				clientFunction = function (vehicle, value)
					if exports.seal_spinner:getOriginalSpinner() == value then
						return true
					else
						return false
					end
				end
			}
		}
	},
	[5] = {
		name = "Elem leszerelés",
		icon = "files/icons/optika.png",
		subMenu = {
			[1] = {
				name = "Első lökhárító",
				icon = "files/icons/optical/elso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_front_dummy",
				removeableComponent = "bump_front_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bump_front_dummy"] = false
					else
						removedComponents["bump_front_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bump_front_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Hátsó lökhárító",
				icon = "files/icons/optical/hatso.png",
				priceType = "money",
				price = 1000,
				camera = "bump_rear_dummy",
				removeableComponent = "bump_rear_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bump_rear_dummy"] = false
					else
						removedComponents["bump_rear_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bump_rear_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Motorháztető",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "bonnet_dummy",
				removeableComponent = "bonnet_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["bonnet_dummy"] = false
					else
						removedComponents["bonnet_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["bonnet_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Csomagtartó",
				icon = "files/icons/optical/motorhaz.png",
				priceType = "money",
				price = 1000,
				camera = "boot_dummy",
				removeableComponent = "boot_dummy",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "restorecomponent"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/elso.png",
						priceType = "money",
						price = 1000,
						value = "removecomponent"
					}
				},
				serverFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and value == "removecomponent" then
						removedComponents["boot_dummy"] = false
					else
						removedComponents["boot_dummy"] = true
					end
					setElementData(vehicle, "vehicle.modifiedComponents", removedComponents)

					return true
				end,
				clientFunction = function (vehicle, value)
					local removedComponents = getElementData(vehicle, "vehicle.modifiedComponents") or {}

					if removedComponents and not removedComponents["boot_dummy"] and value == "removecomponent" then
						return true
					else
						return false
					end
				end
			},
		}
	},
	[6] = {
		name = "Extrák",
		icon = "files/icons/extra.png",
		subMenu = {
			[1] = {
				name = "LSD ajtó",
				icon = "files/icons/optical/lsd.png",
				camera = "base",
				id = "door",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "premium",
						price = 1000,
						value = "scissor"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/optical/lsd.png",
						priceType = "free",
						price = 0,
						value = nil
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.tuning.DoorType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDoorType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if originalDoor == value then
						return true
					else
						return false
					end
				end
			},
			[2] = {
				name = "Első kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "bump_front_dummy",
				id = "handling",
				handlingPrefix = "WHEEL_F_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_F_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_F_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_F_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[3] = {
				name = "Hátsó kerék szélessége",
				icon = "files/icons/optical/gumiszelesseg.png",
				camera = "bump_rear_dummy",
				id = "handling",
				handlingPrefix = "WHEEL_R_",
				subMenu = {
					[1] = {
						name = "Extra keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NARROW2"
					},
					[2] = {
						name = "Keskeny",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 7500,
						value = "NARROW"
					},
					[3] = {
						name = "Normál",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 5000,
						value = "NORMAL"
					},
					[4] = {
						name = "Széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 15000,
						value = "WIDE"
					},
					[5] = {
						name = "Extra széles",
						icon = "files/icons/optical/gumiszelesseg.png",
						priceType = "money",
						price = 25000,
						value = "WIDE2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "WHEEL_R_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["WHEEL_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = originalHandling
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW2"]) then
						activeFlag = "NARROW2"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_NARROW"]) then
						activeFlag = "NARROW"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE"]) then
						activeFlag = "WIDE"
					elseif isFlagSet(flagBytes, handlingFlags["WHEEL_R_WIDE2"]) then
						activeFlag = "WIDE2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[4] = {
				name = "Meghajtás",
				icon = "files/icons/optical/meghajtas.png",
				subMenu = {
					[1] = {
						name = "Elsőkerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "fwd"
					},
					[2] = {
						name = "Összkerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "awd"
					},
					[3] = {
						name = "Hátsókerék",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 10000,
						value = "rwd"
					},
					[4] = {
						name = "Kapcsolható",
						icon = "files/icons/optical/meghajtas.png",
						priceType = "money",
						price = 50000,
						value = "tog"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					if value == "tog" then
						setVehicleHandling(vehicle, "driveType", "awd")
						setElementData(vehicle, "activeDriveType", "awd")
					else
						setVehicleHandling(vehicle, "driveType", value)
					end

					setElementData(vehicle, "vehicle.tuning.DriveType", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningDriveType = ? WHERE vehicleId = ?", value, vehicleId)
					end

					makeTuning(vehicle)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.DriveType")

					if not current then
						current = getVehicleHandling(vehicle).driveType
					end

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[5] = {
				name = "Fordulókör",
				icon = "files/icons/slock.png",
				subMenu = {
					[1] = {
						name = "30°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 30
					},
					[2] = {
						name = "40°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 40
					},
					[3] = {
						name = "50°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 50
					},
					[4] = {
						name = "60°",
						icon = "files/icons/slock.png",
						priceType = "money",
						price = 7500,
						value = 60
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setVehicleHandling(vehicle, "steeringLock", value)
					setElementData(vehicle, "vehicle.tuning.SteeringLock", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningSteeringLock = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					if getVehicleHandling(vehicle).steeringLock == value then
						return true
					else
						return false
					end
				end
			},
			[6] = {
				name = "Önzáró differenciálmű",
				icon = "files/icons/diff.png",
				subMenu = {
					[1] = {
						name = "Felszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "SOLID"
					},
					[2] = {
						name = "Leszerelés",
						icon = "files/icons/diff.png",
						priceType = "money",
						price = 10500,
						value = "NORMAL"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleModelFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "AXLE_R_") then
							flagBytes = flagBytes - modelFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + modelFlags["AXLE_R_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "modelFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.modelFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET modelFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).modelFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, modelFlags["AXLE_R_SOLID"]) then
						activeFlag = "SOLID"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[7] = {
				name = "Offroad optimalizáció",
				icon = "files/icons/optical/offroad.png",
				subMenu = {
					[1] = {
						name = "Nincs optimalizálva",
						icon = "files/icons/optical/offroad.png",
						priceType = "free",
						price = 0,
						value = "NORMAL"
					},
					[2] = {
						name = "Terep beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY"
					},
					[3] = {
						name = "Murva beállítás",
						icon = "files/icons/optical/offroad.png",
						priceType = "money",
						price = 20000,
						value = "ABILITY2"
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local flagsKeyed, flagBytes = getVehicleHandlingFlags(vehicle)
					local originalBytes = flagBytes

					for flag in pairs(flagsKeyed) do
						if string.find(flag, "OFFROAD_") then
							flagBytes = flagBytes - handlingFlags[flag]
						end
					end

					if value ~= "NORMAL" then
						flagBytes = flagBytes + handlingFlags["OFFROAD_" .. value]
					end

					if flagBytes ~= originalBytes then
						setVehicleHandling(vehicle, "handlingFlags", flagBytes)
					end

					setElementData(vehicle, "vehicle.handlingFlags", flagBytes)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET handlingFlags = ? WHERE vehicleId = ?", flagBytes, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local flagBytes = getVehicleHandling(vehicle).handlingFlags
					local activeFlag = "NORMAL"

					if isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY"]) then
						activeFlag = "ABILITY"
					elseif isFlagSet(flagBytes, handlingFlags["OFFROAD_ABILITY2"]) then
						activeFlag = "ABILITY2"
					end

					if activeFlag == value then
						return true
					else
						return false
					end
				end
			},
			[8] = {
				name = "Rendszám",
				icon = "files/icons/optical/plate.png",
				camera = "bump_rear_dummy",
				id = "licensePlate",
				subMenu = {
					[1] = {
						name = "Gyári rendszám",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = "default"
					},
					[2] = {
						name = "Egyedi rendszám",
						icon = "files/icons/pp.png",
						licensePlate = true,
						priceType = "premium",
						price = 1200,
						value = "custom"
					}
				}
			},
			[9] = {
				name = "Traffipax radar",
				icon = "files/icons/optical/speedtrap.png",
				priceType = "money",
				price = 15000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "money",
						price = 15000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/speedtrap.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "traffipaxRadarInVehicle", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET traffipaxRadar = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "traffipaxRadarInVehicle") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[10] = {
				name = "Variáns",
				icon = "files/icons/variant.png",
				priceType = "money",
				price = 50000,
				camera = "base",
				variantEditor = true
			},
			[11] = {
				name = "Navigációs rendszer",
				icon = "files/icons/gps.png",
				priceType = "money",
				price = 3000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/gps.png",
						priceType = "money",
						price = 3000,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/gps.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.GPS", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET gpsNavigation = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.GPS") or 0

					if value == 1 and current >= 1 or current == value then
						return true
					else
						return false
					end
				end
			},
			[12] = {
				name = "Egyedi duda",
				icon = "files/icons/horn.png",
				priceType = "premium",
				price = 1200,
				camera = "base",
				hornSound = true,
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/horn.png",
						priceType = "free",
						price = 0,
						value = 0
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "customHorn", value)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET customHorn = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "customHorn") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[13] = {
				name = "Backfire",
				icon = "files/icons/misc.png",
				--priceType = "premium",
				--price = 3000,
				camera = "base",
				id = "backfire",
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = 0,
						id = "remove",
					},
					[2] = {
						name = "Backfire",
						icon = "files/icons/misc.png",
						priceType = "premium",
						price = 2500,
						value = 1,
						id = "backfire",
					},
					[3] = {
						name = "Egyedi Backfire",
						icon = "files/icons/misc.png",
						priceType = "premium",
						price = 5500,
						value = 2,
						id = "custombf",
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					setElementData(vehicle, "vehicle.backfire", value)
					setElementData(vehicle, "vehicle.customBackfire", false)

					if tonumber(value) == 2 then
						local temp = {sound = 0, speed = 0, consistence = 0}
						local backfireDatas = getElementData(vehicle, "vehicle.customBackfireTemp") or temp

						setElementData(vehicle, "vehicle.customBackfire", backfireDatas)
						setElementData(vehicle, "vehicle.customBackfireTemp", false)
					end

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET backFire = ? WHERE vehicleId = ?", value, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.backfire") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[14] = {
				name = "Egyedi Turbó",
				icon = "files/icons/misc.png",
				--priceType = "premium",
				--price = 3000,
				camera = "base",
				id = "turbo",
				subMenu = {
					[1] = {
						name = "Kiszerelés",
						icon = "files/icons/free.png",
						priceType = "free",
						price = 0,
						value = 0,
						id = "remove",
					},
					[2] = {
						name = "Beszerelés",
						icon = "files/icons/misc.png",
						priceType = "premium",
						price = 10000,
						value = 1,
						id = "customturbo",
					},
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")

					if tonumber(value) == 1 then
						local tmp = {
							gainSoundVol = 1,
							gainSound = 1,
							wasteGateSoundVol = 1,
							wasteGateSound = 1,
						}
								
						local turboDatas = getElementData(vehicle, "vehicle.customTurboTemp")

						if turboDatas then
							turboDatas = turboDatas
						else
							turboDatas = tmp
						end

						local realDatas = {turboDatas.gainSoundVol, turboDatas.gainSound, turboDatas.wasteGateSoundVol, turboDatas.wasteGateSound}

						setElementData(vehicle, "vehicle.tuning.customTurbo", realDatas)
						setElementData(vehicle, "vehicle.customTurboTemp", false)
					else
						setElementData(vehicle, "vehicle.tuning.customTurbo", false)
					end

					setElementData(vehicle, "vehicle.customTurbo", value)

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.customTurbo") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
			[15] = {
				name = "Hidraulika",
				icon = "files/icons/optical/hidra.png",
				priceType = "money",
				price = 15000,
				upgradeSlot = 9,
				camera = "base",
				subMenu = false,
				clientFunction = function (vehicle, value)
					if originalUpgrade == value then
						return true
					else
						return false
					end
				end
			},
			[16] = {
				name = "Air-Ride",
				icon = "files/icons/optical/airride.png",
				priceType = "premium",
				price = 1200,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "premium",
						price = 1200,
						value = 1
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/airride.png",
						priceType = "free",
						price = 0,
						value = 0
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					local currUpgrades = (getElementData(vehicle, "vehicle.tuning.Optical") or ""):gsub("1087,", "")
					local hydraulicsUpgrade = getVehicleUpgradeOnSlot(vehicle, 9)

					if hydraulicsUpgrade then
						removeVehicleUpgrade(vehicle, hydraulicsUpgrade)
					end

					setElementData(vehicle, "vehicle.tuning.AirRide", value)
					setElementData(vehicle, "vehicle.tuning.Optical", currUpgrades)

					if vehicleId then
						dbExec(connection, "UPDATE vehicles SET tuningAirRide = ?, tuningOptical = ? WHERE vehicleId = ?", value, currUpgrades, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.tuning.AirRide") or 0

					if current == value then
						return true
					else
						return false
					end
				end
			},
		}
	},
	[7] = {
		name = "Egyedi Jármű Hang",
		icon = "files/icons/optical/kipufogo.png",
		subMenu = {
			[1] = {
				name = "Hangrendszer",
				icon = "files/icons/optical/kipufogo.png",
				priceType = "premium",
				id = "engineSound",
				price = 80000,
				camera = "base",
				subMenu = {
					[1] = {
						name = "Beszerelés",
						icon = "files/icons/optical/kipufogo.png",
						priceType = "premium",
						price = 80000,
						value = true
					},
					[2] = {
						name = "Kiszerelés",
						icon = "files/icons/optical/kipufogo.png",
						priceType = "free",
						price = 0,
						value = false
					}
				},
				serverFunction = function (vehicle, value)
					local vehicleId = getElementData(vehicle, "vehicle.dbID")
					setElementData(vehicle, "vehicle.customVehicleEngine", value)

					if not value then
						setElementData(vehicle, "vehicle:engine", false)
					end

					if vehicleId then
						local realValue = value and 1 or 0
						dbExec(connection, "UPDATE vehicles SET customEngineSound = ? WHERE vehicleId = ?", realValue, vehicleId)
					end

					return true
				end,
				clientFunction = function (vehicle, value)
					local current = getElementData(vehicle, "vehicle.customVehicleEngine") or false

					return current
				end
			},
		}
	},
}

for i = 1, 44 do
	tuningContainer[6].subMenu[12].subMenu[i + 1] = {
		name = "Duda "..i,
		icon = "files/icons/horn.png",
		priceType = "premium",
		price = 5000,
		value = i
	}
end