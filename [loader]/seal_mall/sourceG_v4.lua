fileHashList = {}
fileProtectList = {}
modelList = {
  ["barrier_gate1"] = {
    type = "object",
    model = "object",
    dff = "files/models/barrier_gate1.dff",
    txd = "files/textures/barrier_gate.txd",
    col = "files/collisions/barrier_gate1.col"
  },
  ["barrier_gate2"] = {
    type = "object",
    model = "object",
    dff = "files/models/barrier_gate2.dff",
    txd = "files/textures/barrier_gate.txd",
    col = "files/collisions/barrier_gate2.col"
  },
  ["barrier_gate3"] = {
    type = "object",
    model = "object",
    dff = "files/models/barrier_gate3.dff",
    txd = "files/textures/barrier_gate.txd",
    col = "files/collisions/barrier_gate3.col"
  },
  ["road_lawn04"] = {
    type = "object",
    model = 5995,
    dff = "files/models/road_lawn04.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/road_lawn04.col"
  },
  ["mall_laW"] = {
    type = "object",
    model = 6048,
    dff = "files/models/mall_laW.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_laW.col"
  },
  ["LODmall_law"] = {
    type = "object",
    model = 6131,
    dff = "files/models/LODmall_law.dff",
    txd = "files/textures/mall_lod.txd",
    lodDistance = 10000
  },
  ["mallb_laW"] = {
    type = "object",
    model = 6130,
    dff = "files/models/mallb_laW.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mallb_laW.col"
  },
  ["LODmallb_laW"] = {
    type = "object",
    model = 6255,
    dff = "files/models/LODmallb_laW.dff",
    txd = "files/textures/mall_lod.txd",
    lodDistance = 10000
  },
  ["mall_parking"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_parking.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_parking.col",
    lodDistance = 200
  },
  ["mall_parking_alpha"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_parking_alpha.dff",
    txd = "files/alpha_textures.txd",
    col = "files/collisions/mall_parking_alpha.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 250
  },
  ["mall_parking_props"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_parking_props.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_parking_props.col"
  },
  ["mall_neon1"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_neon1.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_neon1.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 200
  },
  ["mall_neon2"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_neon2.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_neon2.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 200
  },
  ["mallglass_laW"] = {
    type = "object",
    model = 6051,
    dff = "files/models/mallglass_laW.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mallglass_laW.col",
    transparent = true,
    flags = {"draw_last"},
    lodDistance = 200
  },
  ["mallb_laW_storeLogos"] = {
    type = "object",
    model = "object",
    dff = "files/models/mallb_laW_storeLogos.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mallb_laW_storeLogos.col",
    lodDistance = 200
  },
  ["mallb_laW_storeLogosLOD"] = {
    type = "object",
    model = "object",
    dff = "files/models/mallb_laW_storeLogosLOD.dff",
    txd = "files/textures/mall.txd",
    transparent = true,
    lodDistance = 10000
  },
  ["mall_clockwiseM"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_clockwiseM.dff",
    txd = "files/textures/mall.txd",
    transparent = true
  },
  ["mall_clockwiseH"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_clockwiseH.dff",
    txd = "files/textures/mall.txd",
    transparent = true
  },
  ["mall_door"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_door.dff",
    col = "files/collisions/mall_door.col",
    txd = "files/textures/mall.txd",
    transparent = true,
    lodDistance = 200,
    dynamicDoor = true
  },
  ["mall_bollards1"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_bollards1.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_bollards1.col"
  },
  ["mall_rooms_247"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_247.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_247.col",
    lodDistance = 200
  },
  ["mall_rooms_247prods"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_247prods.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_247.col"
  },
  ["mall_rooms_zip"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_zip.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_zip.col",
    lodDistance = 200
  },
  ["mall_rooms_burger_alpha"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_burger_alpha.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_burger_alpha.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 250
  },
  ["mall_rooms_burger_props"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_burger_props.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_burger_props.col"
  },
  ["mall_rooms_burger"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_burger.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_burger.col",
    lodDistance = 200
  },
  ["mall_rooms_jewelry"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_jewelry.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_jewelry.col",
    lodDistance = 200
  },
  ["mall_rooms_pharmacy"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_pharmacy.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_pharmacy.col",
    lodDistance = 200
  },
  ["mall_rooms_coffee_alpha"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_coffee_alpha.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_coffee_alpha.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 250
  },
  ["mall_rooms_coffee"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_coffee.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_coffee.col",
    lodDistance = 200
  },
  ["mall_rooms_digital"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_digital.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_digital.col",
    lodDistance = 200
  },
  ["mall_rooms_flintTools"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_flintTools.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_flintTools.col",
    lodDistance = 200
  },
  ["mall_rooms_lottery"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_lottery.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_lottery.col",
    lodDistance = 200
  },
  ["mall_rooms_bank"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_bank.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_bank.col",
    lodDistance = 200
  },
  ["mall_rooms_cluckinBell_alpha"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_cluckinBell_alpha.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_cluckinBell_alpha.col",
    transparent = true,
    flags = {
      "no_zbuffer_write"
    },
    lodDistance = 250
  },
  ["mall_rooms_cluckinBell_props"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_cluckinBell_props.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_cluckinBell_props.col"
  },
  ["mall_rooms_cluckinBell"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_cluckinBell.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_cluckinBell.col",
    lodDistance = 200
  },
  ["mall_rooms_toilet"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_rooms_toilet.dff",
    txd = "files/textures/mall.txd",
    col = "files/collisions/mall_rooms_toilet.col"
  },
  ["mall_toiletdoor_male"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_toiletdoor_male.dff",
    col = "files/collisions/mall_door.col",
    txd = "files/textures/mall.txd",
    dynamicDoor = true
  },
  ["mall_toiletdoor_female"] = {
    type = "object",
    model = "object",
    dff = "files/models/mall_toiletdoor_female.dff",
    col = "files/collisions/mall_door.col",
    txd = "files/textures/mall.txd",
    dynamicDoor = true
  },
  v4_backpack_greenarmy = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_greenarmy.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_whitearmy = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_whitearmy.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_blackchanel = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_blackchanel.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_blackgucci = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_blackgucci.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_browngucci = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_browngucci.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_luivuitton = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_luivuitton.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  v4_backpack_tiger = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_backpack_tiger.dff",
    txd = "files/clothing/bag/v4_backpacks.txd"
  },
  gucci_backpack = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/gucci_backpack.dff",
    txd = "files/clothing/bag/gucci_backpack.txd"
  },
  gucci_belt_bag = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/gucci_belt_bag.dff",
    txd = "files/clothing/bag/gucci_belt_bag.txd"
  },
  purse_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/purse_black.dff",
    txd = "files/clothing/bag/purse.txd"
  },
  purse_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/purse_grey.dff",
    txd = "files/clothing/bag/purse.txd"
  },
  purse_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/purse_pink.dff",
    txd = "files/clothing/bag/purse.txd"
  },
  purse_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/purse_red.dff",
    txd = "files/clothing/bag/purse.txd"
  },
  purse_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/purse_yellow.dff",
    txd = "files/clothing/bag/purse.txd"
  },
  v4_sidebag_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_sidebag_black.dff",
    txd = "files/clothing/bag/v4_sidebags.txd"
  },
  v4_sidebag_gucci = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_sidebag_gucci.dff",
    txd = "files/clothing/bag/v4_sidebags.txd"
  },
  v4_sidebag_luivuitton = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_sidebag_luivuitton.dff",
    txd = "files/clothing/bag/v4_sidebags.txd"
  },
  v4_sidebag_versace = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_sidebag_versace.dff",
    txd = "files/clothing/bag/v4_sidebags.txd"
  },
  v4_neckbag_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_neckbag_black.dff",
    txd = "files/clothing/bag/v4_neckbags.txd"
  },
  v4_neckbag_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_neckbag_green.dff",
    txd = "files/clothing/bag/v4_neckbags.txd"
  },
  v4_neckbag_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_neckbag_pink.dff",
    txd = "files/clothing/bag/v4_neckbags.txd"
  },
  v4_neckbag_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_neckbag_red.dff",
    txd = "files/clothing/bag/v4_neckbags.txd"
  },
  v4_suitcase_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_suitcase_black.dff",
    txd = "files/clothing/bag/v4_suitcase.txd"
  },
  v4_suitcase_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_suitcase_brown.dff",
    txd = "files/clothing/bag/v4_suitcase.txd"
  },
  v4_suitcase_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_suitcase_grey.dff",
    txd = "files/clothing/bag/v4_suitcase.txd"
  },
  v4_suitcase_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_suitcase_red.dff",
    txd = "files/clothing/bag/v4_suitcase.txd"
  },
  supreme_backpack_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/supreme_backpack_green.dff",
    txd = "files/clothing/bag/supreme_backpack.txd"
  },
  supreme_backpack_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/supreme_backpack_red.dff",
    txd = "files/clothing/bag/supreme_backpack.txd"
  },
  BackPack1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack1.dff",
    txd = "files/clothing/bag/BackPack1.txd"
  },
  BackPack2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack2.dff",
    txd = "files/clothing/bag/BackPack2.txd"
  },
  BackPack3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack3.dff",
    txd = "files/clothing/bag/BackPack3.txd"
  },
  BackPack4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack4.dff",
    txd = "files/clothing/bag/BackPack4.txd"
  },
  BackPack5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack5.dff",
    txd = "files/clothing/bag/BackPack5.txd"
  },
  BackPack6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/BackPack6.dff",
    txd = "files/clothing/bag/BackPack6.txd"
  },
  hasitasi = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/hasitasi.dff",
    txd = "files/clothing/bag/hasitasi.txd"
  },
  HikerBackpack1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/HikerBackpack1.dff",
    txd = "files/clothing/bag/HikerBackpack1.txd"
  },
  duffelbag = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v3_duffelbag1.dff",
    txd = "files/clothing/bag/v3_duffelbag.txd"
  },
  duffelbag2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v3_duffelbag2.dff",
    txd = "files/clothing/bag/v3_duffelbag.txd"
  },
  oldaltaska = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/oldaltaska.dff",
    txd = "files/clothing/bag/oldaltaska.txd"
  },
  SchoolPack = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/SchoolPack1.dff",
    txd = "files/clothing/bag/SchoolPack.txd"
  },
  SchoolPack2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/SchoolPack2.dff",
    txd = "files/clothing/bag/SchoolPack.txd"
  },
  SchoolPack3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/SchoolPack3.dff",
    txd = "files/clothing/bag/SchoolPack.txd"
  },
  v4_szatyor = {
    type = "object",
    model = "object",
    dff = "files/clothing/bag/v4_szatyor.dff",
    txd = "files/clothing/bag/v4_szatyor.txd"
  },
  v4_bandana1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_redneck = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_redneck.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana1_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana1_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana2_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana2_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_redneck = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_redneck.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana3_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana3_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana4_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana4_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_redneck = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_redneck.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana5_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana5_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_black.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_blue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_camo1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_camo1.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_camo2.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_darkblue = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_darkblue.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_darkgreen = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_darkgreen.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_green.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_grey.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_purple = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_purple.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_red.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_redneck = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_redneck.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_skull = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_skull.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  v4_bandana6_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/bandana/v4_bandana6_yellow.dff",
    txd = "files/clothing/bandana/v4_bandanas.txd"
  },
  GlassesType1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType1.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType2.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType3.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType4.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType5.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType6.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType7.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType8 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType8.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType9 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType9.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType10 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType10.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType11 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType11.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType12 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType12.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType13 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType13.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType14 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType14.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType15 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType15.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType16 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType16.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType17 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType17.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType18 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType18.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType19 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType19.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType20 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType20.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType21 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType21.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType22 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType22.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType23 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType23.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  GlassesType24 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/GlassesType24.dff",
    txd = "files/clothing/glasses/MatGlasses.txd",
    transparent = true
  },
  Szemuveg_1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/glasses/Szemuveg_1.dff",
    txd = "files/clothing/glasses/Szemuveg_1.txd"
  },
  v4_beard1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard1_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard1_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard1_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard1_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard1_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard1_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard1_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard1_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard1_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard2_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard2_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard2_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard2_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard2_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard2_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard2_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard2_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard2_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard3_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard3_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard3_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard3_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard3_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard3_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard3_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard3_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard3_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard4_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard4_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard4_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard4_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard4_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard4_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard4_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard4_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard4_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard4_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard5_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard5_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard5_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard5_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard5_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard5_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard5_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard5_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard5_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard5_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard6_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard6_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard6_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard6_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard6_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard6_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard6_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard6_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_beard6_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_beard6_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache1_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache1_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache1_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache1_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache1_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache1_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache1_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache1_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache1_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache2_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache2_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache2_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache2_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache2_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache2_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache2_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache2_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache2_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache3_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache3_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache3_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache3_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache3_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache3_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache3_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache3_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache3_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache4_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache4_black.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache4_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache4_brown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache4_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache4_darkbrown.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache4_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache4_grey.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_mustache4_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_mustache4_white.dff",
    txd = "files/clothing/hair/v4_beards_and_mustache.txd"
  },
  v4_hair_dreadlock1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_dreadlock1.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_dreadlock2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_dreadlock2.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long1_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long1_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long1_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long2_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long2_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long2_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long3_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_long3_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_long3_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_microfon_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_microfon_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_microfon_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_microfon_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_microfon_darkbrown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_microfon_darkbrown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_blue.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_green = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_green.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_pink.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_red.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_punk_yellow = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_punk_yellow.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short1_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short1_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short1_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short2_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short2_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short2_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short3_black.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_hair_short3_brown = {
    type = "object",
    model = "object",
    dff = "files/clothing/hair/v4_hair_short3_brown.dff",
    txd = "files/clothing/hair/v4_hairs.txd"
  },
  v4_cilinder_blackandgrey = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_blackandgrey.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_blackandwhite = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_blackandwhite.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_blueandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_blueandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_greenandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_greenandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_greyandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_greyandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_pinkandwhite = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_pinkandwhite.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_purpleandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_purpleandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_redandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_redandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  v4_cilinder_whiteandblack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_cilinder_whiteandblack.dff",
    txd = "files/clothing/headwear/v4_cilinderek.txd"
  },
  headband1_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband1_black.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband1_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband1_red.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband1_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband1_pink.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband2_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband2_black.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband2_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband2_red.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband2_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband2_pink.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband3_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband3_black.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband3_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband3_red.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband3_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband3_pink.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband4_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband4_black.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband4_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband4_red.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  headband4_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/headband4_pink.dff",
    txd = "files/clothing/headwear/headband.txd"
  },
  eyepatch_left = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/eyepatch_left.dff",
    txd = "files/clothing/headwear/eyepatch.txd"
  },
  eyepatch_right = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/eyepatch_right.dff",
    txd = "files/clothing/headwear/eyepatch.txd"
  },
  BPeaky = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/BPeaky.dff",
    txd = "files/clothing/headwear/PeakyHat.txd"
  },
  KPeaky = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/KPeaky.dff",
    txd = "files/clothing/headwear/PeakyHat.txd"
  },
  PPeaky = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/PPeaky.dff",
    txd = "files/clothing/headwear/PeakyHat.txd"
  },
  SzPeaky = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/SzPeaky.dff",
    txd = "files/clothing/headwear/PeakyHat.txd"
  },
  blackbikerhelmet = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/blackbikerhelmet.dff",
    txd = "files/clothing/headwear/blackbikerhelmet.txd"
  },
  CapTrucker = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker1.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker2.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker3.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker4.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker5.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  CapTrucker6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/CapTrucker6.dff",
    txd = "files/clothing/headwear/CapTrucker.txd"
  },
  cross_helmet = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cross_helmet1.dff",
    txd = "files/clothing/headwear/cross_helmet.txd"
  },
  cross_helmet2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cross_helmet2.dff",
    txd = "files/clothing/headwear/cross_helmet.txd"
  },
  cross_helmet3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cross_helmet3.dff",
    txd = "files/clothing/headwear/cross_helmet.txd"
  },
  cross_helmet4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cross_helmet4.dff",
    txd = "files/clothing/headwear/cross_helmet.txd"
  },
  mikulassapka = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/mikulassapka.dff",
    txd = "files/clothing/headwear/mikulassapka.txd"
  },
  MotorcycleHelmet1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/MotorcycleHelmet1.dff",
    txd = "files/clothing/headwear/MotorcycleHelmet.txd"
  },
  MotorcycleHelmet2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/MotorcycleHelmet2.dff",
    txd = "files/clothing/headwear/MotorcycleHelmet.txd"
  },
  MotorcycleHelmet3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/MotorcycleHelmet3.dff",
    txd = "files/clothing/headwear/MotorcycleHelmet.txd"
  },
  MotorcycleHelmet4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/MotorcycleHelmet4.dff",
    txd = "files/clothing/headwear/MotorcycleHelmet.txd"
  },
  greencamobikerhelmet = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/greencamobikerhelmet.dff",
    txd = "files/clothing/headwear/greencamobikerhelmet.txd"
  },
  HardHat1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HardHat1.dff",
    txd = "files/clothing/headwear/HardHat1.txd"
  },
  Hat1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat1.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat2.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat3.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat4.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat5.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat6.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat7.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat8 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat8.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat9 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat9.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  Hat10 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Hat10.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatBowler1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatBowler1.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatBowler2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatBowler2.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatBowler3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatBowler3.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatBowler4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatBowler4.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatBowler5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatBowler5.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatCool1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatCool1.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatCool2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatCool2.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  HatCool3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/HatCool3.dff",
    txd = "files/clothing/headwear/hats_v3.txd"
  },
  balaclava = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/balaclava.dff",
    txd = "files/clothing/headwear/balaclava.txd"
  },
  guccisapi = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/guccisapi.dff",
    txd = "files/clothing/headwear/guccisapi.txd"
  },
  v3_hut1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v3_hut1.dff",
    txd = "files/clothing/headwear/v3_hut.txd"
  },
  v3_hut2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v3_hut2.dff",
    txd = "files/clothing/headwear/v3_hut.txd"
  },
  v3_hut3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v3_hut3.dff",
    txd = "files/clothing/headwear/v3_hut.txd"
  },
  nikebuckethat = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/nikebuckethat.dff",
    txd = "files/clothing/headwear/nikebuckethat.txd"
  },
  jordanbuckethat = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/jordanbuckethat.dff",
    txd = "files/clothing/headwear/jordanbuckethat.txd"
  },
  manosapka = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/manosapka.dff",
    txd = "files/clothing/headwear/manosapka.txd"
  },
  sadboybuckethat = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/sadboybuckethat.dff",
    txd = "files/clothing/headwear/sadboybuckethat.txd"
  },
  Sapka_7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_7.dff",
    txd = "files/clothing/headwear/Sapka_7.txd"
  },
  SkullyCap1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/SkullyCap1.dff",
    txd = "files/clothing/headwear/SkullyCap.txd"
  },
  SkullyCap2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/SkullyCap2.dff",
    txd = "files/clothing/headwear/SkullyCap.txd"
  },
  SkullyCap3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/SkullyCap3.dff",
    txd = "files/clothing/headwear/SkullyCap.txd"
  },
  usanka = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/usanka.dff",
    txd = "files/clothing/headwear/usanka.txd"
  },
  whitecamobikerhelmet = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/whitecamobikerhelmet.dff",
    txd = "files/clothing/headwear/whitecamobikerhelmet.txd"
  },
  WitchesHat1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/WitchesHat1.dff",
    txd = "files/clothing/headwear/WitchesHat1.txd"
  },
  cow = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat1.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat2.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat3.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat4.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat5.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat6.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  cow7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/cowboy_hat7.dff",
    txd = "files/clothing/headwear/cowboy_hats.txd"
  },
  Sapka_1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_1.dff",
    txd = "files/clothing/headwear/Sapka_1.txd"
  },
  Sapka_2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_2.dff",
    txd = "files/clothing/headwear/Sapka_2.txd"
  },
  Sapka_3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_3.dff",
    txd = "files/clothing/headwear/Sapka_3.txd"
  },
  Sapka_4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_4.dff",
    txd = "files/clothing/headwear/Sapka_4.txd"
  },
  Sapka_5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_5.dff",
    txd = "files/clothing/headwear/Sapka_5.txd"
  },
  Sapka_6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_6.dff",
    txd = "files/clothing/headwear/Sapka_6.txd"
  },
  Sapka_7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/Sapka_7.dff",
    txd = "files/clothing/headwear/Sapka_7.txd"
  },
  newera_angels = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_angels.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_bostonredsox = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_bostonredsox.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_dodgers = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_dodgers.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_houstonastros = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_houstonastros.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_oaklandathletics = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_oaklandathletics.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_phillies = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_phillies.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_raiders = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_raiders.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_sfgiants = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_sfgiants.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_washingtonnationals = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_washingtonnationals.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_yankees = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_yankees.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_reds = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_reds.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  newera_sox = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/newera_sox.dff",
    txd = "files/clothing/headwear/newera.txd"
  },
  v4_burlap_sack = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/v4_burlap_sack.dff",
    txd = "files/clothing/headwear/v4_burlap_sack.txd"
  },
  seedyno_cap = {
    type = "object",
    model = "object",
    dff = "files/clothing/headwear/seedyno_cap.dff",
    txd = "files/clothing/headwear/seedyno_cap.txd"
  },
  earring1_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring1_gold.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring2_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring2_gold.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring3_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring3_gold.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring4_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring4_gold.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring1_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring1_silver.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring2_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring2_silver.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring3_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring3_silver.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  earring4_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/earring4_silver.dff",
    txd = "files/clothing/jewellery/earring.txd"
  },
  bracelet_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/bracelet_gold.dff",
    txd = "files/clothing/jewellery/bracelet.txd"
  },
  bracelet_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/bracelet_silver.dff",
    txd = "files/clothing/jewellery/bracelet.txd"
  },
  bracelet2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/bracelet2.dff",
    txd = "files/clothing/jewellery/bracelet2.txd"
  },
  bracelet3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/bracelet3.dff",
    txd = "files/clothing/jewellery/bracelet2.txd"
  },
  necklace_gold_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gold_black.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_gold_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gold_blue.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_gold_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gold_pink.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_gold_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gold_red.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_gold_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gold_white.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_silver_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_silver_black.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_silver_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_silver_blue.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_silver_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_silver_pink.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_silver_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_silver_red.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_silver_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_silver_white.dff",
    txd = "files/clothing/jewellery/necklace_iced.txd"
  },
  necklace_csonti = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_csonti.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_fu = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_fu.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_gang = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gang.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_gang2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_gang2.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_heart = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_joker = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_joker.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_maci = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_maci.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_maszk = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_maszk.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_nba = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_nba.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_snake = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_snake.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_snitch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_snitch.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  necklace_v = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_v.dff",
    txd = "files/clothing/jewellery/necklace.txd"
  },
  rocker_necklace = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/rocker_necklace.dff",
    txd = "files/clothing/jewellery/rocker_necklace.txd"
  },
  rocker_necklace2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/rocker_necklace2.dff",
    txd = "files/clothing/jewellery/rocker_necklace.txd"
  },
  necklace_heart_gold_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_gold_black.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_gold_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_gold_blue.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_gold_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_gold_pink.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_gold_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_gold_red.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_gold_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_gold_silver.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_silver_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_silver_black.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_silver_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_silver_blue.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_silver_pink = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_silver_pink.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  necklace_heart_silver_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/necklace_heart_silver_red.dff",
    txd = "files/clothing/jewellery/necklace_heart.txd"
  },
  piera1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piera1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piera2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piera2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piera3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piera3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piera4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piera4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piera5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piera5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraa1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraa1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraa2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraa2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraa3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraa3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraa4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraa4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraa5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraa5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaa1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaa1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaa1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaa1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaa2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaa2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaa3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaa3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaa4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaa4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaa5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaa5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaaa1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaaa1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaaa2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaaa2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaaa3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaaa3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaaa4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaaa4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieraaaaa5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieraaaaa5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieree1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieree1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieree2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieree2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieree3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieree3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieree4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieree4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  pieree5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/pieree5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereee1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereee1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeee1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeee1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeee2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeee2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeee3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeee3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeee4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeee4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeee5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeee5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeeee1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeeee1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeeee2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeeee2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeeee3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeeee3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeeee4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeeee4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piereeeee5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piereeeee5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  v3_necklace1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace1.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace2.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace3.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace4.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace5.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace6.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace7.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  v3_necklace8 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v3_necklace8.dff",
    txd = "files/clothing/jewellery/v3_necklace.txd",
    transparent = true
  },
  WatchType1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType1.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType2.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType3.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType4.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType5.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType6.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType7.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType8 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType8.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType9 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType9.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType10 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType10.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType11 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType11.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType12 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType12.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType13 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType13.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType14 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType14.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  WatchType15 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/WatchType15.dff",
    txd = "files/clothing/jewellery/WatchType.txd"
  },
  Nyaklanc_1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Nyaklanc_1.dff",
    txd = "files/clothing/jewellery/Nyaklanc_1.txd"
  },
  Nyaklanc_2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Nyaklanc_2.dff",
    txd = "files/clothing/jewellery/Nyaklanc_2.txd"
  },
  Nyaklanc_3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Nyaklanc_3.dff",
    txd = "files/clothing/jewellery/Nyaklanc_3.txd"
  },
  Nyaklanc_4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Nyaklanc_4.dff",
    txd = "files/clothing/jewellery/Nyaklanc_4.txd"
  },
  Nyaklanc_5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Nyaklanc_5.dff",
    txd = "files/clothing/jewellery/Nyaklanc_5.txd"
  },
  Ora_1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Ora_1.dff",
    txd = "files/clothing/jewellery/Ora_1.txd"
  },
  Ora_2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Ora_2.dff",
    txd = "files/clothing/jewellery/Ora_2.txd"
  },
  Ora_3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/Ora_3.dff",
    txd = "files/clothing/jewellery/Ora_3.txd"
  },
  v4_black_casio_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_casio_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_black_gold_casio_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_gold_casio_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_black_rosegold_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_rosegold_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_black_silver_casio_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_silver_casio_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_black_silver_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_silver_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_black_sunglass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_black_sunglass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_brown_sunglass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_brown_sunglass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_darkbrown_sunglass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_darkbrown_sunglass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_glasses = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_glasses.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_golden_bracelet = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_golden_bracelet.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_golden_golden_bracelet = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_golden_golden_bracelet.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_big_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_big_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_black_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_black_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_black_rolex_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_black_rolex_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_blue_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_blue_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_green_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_green_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_green_rolex_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_green_rolex_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_karika_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_karika_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_lion_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_lion_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_medium_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_medium_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_megafux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_megafux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_nyaklanc_kereszt = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_nyaklanc_kereszt.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_nyaklanc_kereszt2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_nyaklanc_kereszt2.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_pink_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_pink_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_raj_glass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_raj_glass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_gold_red_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_red_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_small_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_small_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_vastag_nyaklanc = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_vastag_nyaklanc.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_gold_white_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_gold_white_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_rugosbeke_gold = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_rugosbeke_gold.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_rugosbeke_silver = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_rugosbeke_silver.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_big_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_big_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_black_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_black_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_blue_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_blue_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_blue_rolex_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_blue_rolex_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_bracelet = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_bracelet.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_casio_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_casio_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_gold_rolex_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_gold_rolex_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_gold_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_gold_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_green_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_green_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_karika_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_karika_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_lion_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_lion_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_medium_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_medium_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_megafux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_megafux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_nyaklanc_kereszt = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_nyaklanc_kereszt.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_nyaklanc_kereszt2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_nyaklanc_kereszt2.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_pink_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_pink_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_raj_glass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_raj_glass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  v4_silver_red_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_red_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_rosegold_rolex_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_rosegold_rolex_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_rosegold_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_rosegold_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_silver_bracelet = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_silver_bracelet.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_blackruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_blackruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_blueruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_blueruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_greenruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_greenruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_pinkruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_pinkruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_redruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_redruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_small_whiteruby_ring = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_small_whiteruby_ring.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_vastag_nyaklanc = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_vastag_nyaklanc.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_watch = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_watch.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_silver_white_koves_kereszt_fux = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_silver_white_koves_kereszt_fux.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd"
  },
  v4_white_sunglass = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/v4_white_sunglass.dff",
    txd = "files/clothing/jewellery/v4_carlos_jewpack.txd",
    transparent = true
  },
  headset_camo = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/headset_camo.dff",
    txd = "files/clothing/other/headset.txd"
  },
  headset_camo2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/headset_camo2.dff",
    txd = "files/clothing/other/headset.txd"
  },
  headset_harleyquinn = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/headset_harleyquinn.dff",
    txd = "files/clothing/other/headset.txd"
  },
  headset_helo = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/headset_helo.dff",
    txd = "files/clothing/other/headset.txd"
  },
  headset_joker = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/headset_joker.dff",
    txd = "files/clothing/other/headset.txd"
  },
  piere1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere1.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere2.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere3.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere4.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  piere5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/jewellery/piere5.dff",
    txd = "files/clothing/jewellery/piercing.txd"
  },
  tie_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/tie_blue.dff",
    txd = "files/clothing/other/tie.txd"
  },
  tie_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/tie_red.dff",
    txd = "files/clothing/other/tie.txd"
  },
  tie_grey = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/tie_grey.dff",
    txd = "files/clothing/other/tie.txd"
  },
  rose_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/rose_black.dff",
    txd = "files/clothing/other/rose.txd"
  },
  rose_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/rose_blue.dff",
    txd = "files/clothing/other/rose.txd"
  },
  rose_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/rose_red.dff",
    txd = "files/clothing/other/rose.txd"
  },
  rose_white = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/rose_white.dff",
    txd = "files/clothing/other/rose.txd"
  },
  bowtie_black = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/bowtie_black.dff",
    txd = "files/clothing/other/bowtie.txd"
  },
  bowtie_red = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/bowtie_red.dff",
    txd = "files/clothing/other/bowtie.txd"
  },
  bowtie_blue = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/bowtie_blue.dff",
    txd = "files/clothing/other/bowtie.txd"
  },
  fehersal = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/fehersal.dff",
    txd = "files/clothing/other/fehersal.txd"
  },
  fejhallgato = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/fejhallgato.dff",
    txd = "files/clothing/other/fejhallgato.txd"
  },
  fejhallgato2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/fejhallgato2.dff",
    txd = "files/clothing/other/fejhallgato2.txd"
  },
  pirossal = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/pirossal.dff",
    txd = "files/clothing/other/pirossal.txd"
  },
  TheParrot1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/TheParrot1.dff",
    txd = "files/clothing/other/TheParrot1.txd"
  },
  zoldsal = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/zoldsal.dff",
    txd = "files/clothing/other/zoldsal.txd"
  },
  v4_weapon_sling1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/weapon_sling1.dff",
    txd = "files/clothing/other/v4_tactical_accs.txd"
  },
  v4_weapon_sling2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/weapon_sling2.dff",
    txd = "files/clothing/other/v4_tactical_accs.txd"
  },
  v4_holster = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/v4_holster.dff",
    txd = "files/clothing/other/v4_tactical_accs.txd"
  },
  v4_gunbag = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/v4_gunbag.dff",
    txd = "files/clothing/other/v4_tactical_accs.txd"
  },
  v4_cigar = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/v4_cigar.dff",
    txd = "files/clothing/other/v4_cigarette.txd"
  },
  v4_cigarette = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/v4_cigarette.dff",
    txd = "files/clothing/other/v4_cigarette.txd"
  },
  v4_joint = {
    type = "object",
    model = "object",
    dff = "files/clothing/other/v4_joint.dff",
    txd = "files/clothing/other/v4_cigarette.txd"
  },
  ferfimelleny = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/ferfimelleny.dff",
    txd = "files/clothing/vest/ferfimelleny.txd"
  },
  ferfimelleny2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/ferfimelleny2.dff",
    txd = "files/clothing/vest/ferfimelleny2.txd"
  },
  noimelleny = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/noimelleny.dff",
    txd = "files/clothing/vest/noimelleny.txd"
  },
  noimelleny2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/noimelleny2.dff",
    txd = "files/clothing/vest/noimelleny2.txd"
  },
  v3_civilianvest1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest1.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest2.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest3.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest4.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest5 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest5.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest6 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest6.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest7 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest7.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest8 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest8.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest9 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest9.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest10 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest10.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest11 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest11.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  v3_civilianvest12 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v3_civilianvest12.dff",
    txd = "files/clothing/vest/v3_civilianvest.txd"
  },
  JESSE_Triko = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/JESSE_Triko.dff",
    txd = "files/clothing/vest/JESSE_Triko.txd"
  },
  v4_armor1 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v4_armor1.dff",
    txd = "files/clothing/vest/v4_armor.txd"
  },
  v4_armor2 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v4_armor2.dff",
    txd = "files/clothing/vest/v4_armor.txd"
  },
  v4_armor3 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v4_armor3.dff",
    txd = "files/clothing/vest/v4_armor.txd"
  },
  v4_armor4 = {
    type = "object",
    model = "object",
    dff = "files/clothing/vest/v4_armor4.dff",
    txd = "files/clothing/vest/v4_armor.txd"
  },
  armor_camo = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/armor_camo.dff",
    txd = "files/clothing/faction/armor.txd"
  },
  polgi_armor = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/armor.dff",
    txd = "files/clothing/faction/polgi.txd"
  },
  armor_pd = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/armor_pd.dff",
    txd = "files/clothing/faction/armor.txd"
  },
  armor_nav = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/armor_nav.dff",
    txd = "files/clothing/faction/armor.txd"
  },
  nav_badge = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/nav_badge.dff",
    txd = "files/clothing/faction/nav_badge.txd"
  },
  merkur_vest = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/merkur_vest.dff",
    txd = "files/clothing/faction/merkur_vest.txd"
  },
  nav_traffic_vest = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/nav_traffic_vest.dff",
    txd = "files/clothing/faction/nav_traffic_vest.txd"
  },
  v4_pd_jelveny = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_pd_jelveny.dff",
    txd = "files/clothing/faction/v4_pd_jelveny.txd"
  },
  v4_pd_ovjelveny = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_pd_ovjelveny.dff",
    txd = "files/clothing/faction/v4_pd_ovjelveny.txd"
  },
  v4_pd_sapka = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_pd_sapka.dff",
    txd = "files/clothing/faction/v4_pd_sapka.txd"
  },
  OMSZmelleny = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/OMSZmelleny.dff",
    txd = "files/clothing/faction/OMSZmelleny.txd"
  },
  OMSZsisak = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/OMSZsisak.dff",
    txd = "files/clothing/faction/OMSZsisak.txd"
  },
  OMSZsztetoszkop = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/OMSZsztetoszkop.dff",
    txd = "files/clothing/faction/OMSZsztetoszkop.txd"
  },
  v4_tek_helmet = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_tek_helmet.dff",
    txd = "files/clothing/faction/v4_tek_helmet.txd"
  },
  v4_tek_plate = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_tek_plate.dff",
    txd = "files/clothing/faction/v4_tek_plate.txd"
  },
  v4_nni_jelveny = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_nni_jelveny.dff",
    txd = "files/clothing/faction/v4_nni_jelveny.txd"
  },
  v4_nni_vest = {
    type = "object",
    model = "object",
    dff = "files/clothing/faction/v4_nni_vest.dff",
    txd = "files/clothing/faction/v4_nni_vest.txd"
  },
}
function getModelId(model)
    if modelList[model] and tonumber(modelList[model].model) then
        return modelList[model].model
    end

    return false
end