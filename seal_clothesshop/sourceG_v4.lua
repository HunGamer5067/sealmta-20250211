allowedBones = {
  1,
  3,
  4,
  8,
  22,
  23,
  24,
  25,
  26,
  32,
  33,
  34,
  35,
  36,
  41,
  42,
  43,
  44,
  51,
  52,
  53,
  54
}
allowedBonesEx = {}
for i = 1, #allowedBones do
  allowedBonesEx[allowedBones[i]] = true
end
categories = {
  ["Arcszőrzetek"] = {icon = "head-side"},
  ["Bandana kendők"] = {icon = "scarf"},
  ["Ékszerek"] = {
    icon = "rings-wedding"
  },
  ["Fejhallgatók"] = {icon = "headphones"},
  ["Frakció kiegészítők"] = {icon = "users"},
  ["Hajformák"] = {icon = "cut"},
  ["Karórák, karkötők"] = {icon = "watch"},
  Maszkok = {
    icon = "theater-masks"
  },
  ["Mellények"] = {icon = "vest"},
  ["Sapkák, kalapok"] = {
    icon = "hat-cowboy-side"
  },
  Sisakok = {icon = "hard-hat"},
  ["Szemüvegek"] = {icon = "glasses"},
  ["Táskák"] = {
    icon = "shopping-bag"
  },
  armor = {icon = "shield-alt"}
}
categoryList = {}
for cat in pairs(categories) do
  if cat ~= "armor" then
    table.insert(categoryList, cat)
  end
end
table.sort(categoryList)
local catSort = {}
for i = 1, #categoryList do
  catSort[categoryList[i]] = i
end
clothesList = {
  rose_black = {
    name = "Rózsa #01",
    cat = "Egyéb",
    ppPrice = 360
  },
  rose_blue = {
    name = "Rózsa #02",
    cat = "Egyéb",
    ppPrice = 360
  },
  rose_white = {
    name = "Rózsa #04",
    cat = "Egyéb",
    ppPrice = 360
  },
  rocker_necklace2 = {
    name = "Szöges nyaklánc #02",
    cat = "Egyéb",
    ppPrice = 290
  },
  earring3_gold = {
    name = "Arany füllbevaló #03",
    cat = "Ékszerek",
    ppPrice = 1050
  },
  earring4_gold = {
    name = "Arany füllbevaló #04",
    cat = "Ékszerek",
    ppPrice = 1280
  },
  bracelet_gold = {
    name = "Arany karkötő #01",
    cat = "Ékszerek",
    ppPrice = 580
  },
  Ora_1 = {
    name = "Arany óra #01",
    cat = "Ékszerek",
    ppPrice = 680
  },
  Ora_2 = {
    name = "Arany óra #02",
    cat = "Ékszerek",
    ppPrice = 660
  },
  WatchType4 = {
    name = "Arany óra #04",
    cat = "Ékszerek",
    ppPrice = 640
  },
  necklace_nba = {
    name = "Nyaklánc #23",
    cat = "Ékszerek",
    ppPrice = 390
  },
  Nyaklanc_4 = {
    name = "Nyaklánc #35",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v3_necklace6 = {
    name = "Nyaklánc #42",
    cat = "Ékszerek",
    ppPrice = 670
  },
  piera1 = {
    name = "Piercing #01",
    cat = "Ékszerek",
    ppPrice = 450
  },
  piera2 = {
    name = "Piercing #02",
    cat = "Ékszerek",
    ppPrice = 450
  },
  piera3 = {
    name = "Piercing #03",
    cat = "Ékszerek",
    ppPrice = 450
  },
  piera4 = {
    name = "Piercing #04",
    cat = "Ékszerek",
    ppPrice = 450
  },
  piera5 = {
    name = "Piercing #05",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraa1 = {
    name = "Piercing #06",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraa2 = {
    name = "Piercing #07",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraa3 = {
    name = "Piercing #08",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraa4 = {
    name = "Piercing #09",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraa5 = {
    name = "Piercing #10",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaa1 = {
    name = "Piercing #11",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaa1 = {
    name = "Piercing #12",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaa2 = {
    name = "Piercing #13",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaa3 = {
    name = "Piercing #14",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaa4 = {
    name = "Piercing #15",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaa5 = {
    name = "Piercing #16",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaaa1 = {
    name = "Piercing #17",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaaa2 = {
    name = "Piercing #18",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaaa3 = {
    name = "Piercing #19",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaaa4 = {
    name = "Piercing #20",
    cat = "Ékszerek",
    ppPrice = 450
  },
  pieraaaaa5 = {
    name = "Piercing #21",
    cat = "Ékszerek",
    ppPrice = 450
  },
  headset_harleyquinn = {
    name = "Fejhallgató #05",
    cat = "Fejhallgatók",
    ppPrice = 580
  },
  headset_helo = {
    name = "Fejhallgató #06",
    cat = "Fejhallgatók",
    ppPrice = 580
  },
  v4_hair_dreadlock2 = {
    name = "Hajstílus #02",
    cat = "Hajformák",
    ppPrice = 1790
  },
  v4_hair_punk_blue = {
    name = "Hajstílus #13",
    cat = "Hajformák",
    ppPrice = 800
  },
  v4_hair_punk_green = {
    name = "Hajstílus #14",
    cat = "Hajformák",
    ppPrice = 800
  },
  v4_hair_punk_pink = {
    name = "Hajstílus #15",
    cat = "Hajformák",
    ppPrice = 800
  },
  v4_hair_punk_red = {
    name = "Hajstílus #16",
    cat = "Hajformák",
    ppPrice = 800
  },
  v4_hair_punk_yellow = {
    name = "Hajstílus #17",
    cat = "Hajformák",
    ppPrice = 800
  },
  balaclava = {
    name = "Símaszk",
    cat = "Maszkok",
    ppPrice = 1200
  },
  jordanbuckethat = {
    name = "Bucket sapka #01",
    cat = "Sapkák, kalapok",
    ppPrice = 380
  },
  Sapka_2 = {
    name = "Bucket sapka #04",
    cat = "Sapkák, kalapok",
    ppPrice = 390
  },
  v4_cilinder_pinkandwhite = {
    name = "Cilinder #06",
    cat = "Sapkák, kalapok",
    ppPrice = 1490
  },
  v4_cilinder_whiteandblack = {
    name = "Cilinder #09",
    cat = "Sapkák, kalapok",
    ppPrice = 1490
  },
  cow2 = {
    name = "Cowboy kalap #02",
    cat = "Sapkák, kalapok",
    ppPrice = 890
  },
  headband1_black = {
    name = "Fejpánt #01",
    cat = "Sapkák, kalapok",
    ppPrice = 380
  },
  headband1_pink = {
    name = "Fejpánt #02",
    cat = "Sapkák, kalapok",
    ppPrice = 380
  },
  headband1_red = {
    name = "Fejpánt #03",
    cat = "Sapkák, kalapok",
    ppPrice = 380
  },
  cross_helmet3 = {
    name = "Cross sisak #03",
    cat = "Sisakok",
    ppPrice = 1050
  },
  Szemuveg_1 = {
    name = "Szemüveg #25",
    cat = "Szemüvegek",
    ppPrice = 690
  },
  gucci_belt_bag = {
    name = "Gucci övtáska",
    cat = "Táskák",
    ppPrice = 390
  },
  gucci_backpack = {
    name = "Gucci táska",
    cat = "Táskák",
    ppPrice = 380
  },
  supreme_backpack_green = {
    name = "Hátizsák #10",
    cat = "Táskák",
    ppPrice = 410
  },
  v4_neckbag_green = {
    name = "Oldaltáska #03",
    cat = "Táskák",
    ppPrice = 890
  },
  v4_neckbag_pink = {
    name = "Oldaltáska #04",
    cat = "Táskák",
    ppPrice = 890
  },
  v4_neckbag_red = {
    name = "Oldaltáska #05",
    cat = "Táskák",
    ppPrice = 890
  },
  v4_sidebag_gucci = {
    name = "Oldaltáska #07",
    cat = "Táskák",
    ppPrice = 1490
  },
  v4_sidebag_luivuitton = {
    name = "Oldaltáska #08",
    cat = "Táskák",
    ppPrice = 1490
  },
  v4_sidebag_versace = {
    name = "Oldaltáska #09",
    cat = "Táskák",
    ppPrice = 1490
  },
  purse_pink = {
    name = "Retikül #03",
    cat = "Táskák",
    ppPrice = 380
  },
  v4_black_gold_casio_watch = {
    name = "Casio óra #02",
    cat = "Ékszerek",
    ppPrice = 1300
  },
  v4_black_rosegold_watch = {
    name = "Karóra #13",
    cat = "Ékszerek",
    ppPrice = 600
  },
  v4_black_silver_casio_watch = {
    name = "Casio óra #03",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_black_silver_watch = {
    name = "Karóra #14",
    cat = "Ékszerek",
    ppPrice = 600
  },
  v4_brown_sunglass = {
    name = "Szemüveg #27",
    cat = "Szemüvegek",
    ppPrice = 850
  },
  v4_darkbrown_sunglass = {
    name = "Szemüveg #28",
    cat = "Szemüvegek",
    ppPrice = 850
  },
  v4_glasses = {
    name = "Szemüveg #29",
    cat = "Szemüvegek",
    ppPrice = 1600
  },
  v4_golden_bracelet = {
    name = "Arany karkötő #02",
    cat = "Ékszerek",
    ppPrice = 1250
  },
  v4_golden_golden_bracelet = {
    name = "Arany karkötő #03",
    cat = "Ékszerek",
    ppPrice = 1250
  },
  v4_gold_big_blackruby_ring = {
    name = "Pecsétgyűrű #01",
    cat = "Ékszerek",
    ppPrice = 1610
  },
  v4_gold_big_blueruby_ring = {
    name = "Pecsétgyűrű #02",
    cat = "Ékszerek",
    ppPrice = 1610
  },
  v4_gold_big_greenruby_ring = {
    name = "Pecsétgyűrű #03",
    cat = "Ékszerek",
    ppPrice = 1610
  },
  v4_gold_big_pinkruby_ring = {
    name = "Pecsétgyűrű #04",
    cat = "Ékszerek",
    ppPrice = 1710
  },
  v4_gold_big_redruby_ring = {
    name = "Pecsétgyűrű #05",
    cat = "Ékszerek",
    ppPrice = 1710
  },
  v4_gold_big_whiteruby_ring = {
    name = "Pecsétgyűrű #06",
    cat = "Ékszerek",
    ppPrice = 1710
  },
  v4_gold_black_koves_kereszt_fux = {
    name = "Nyaklánc #45",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_gold_black_rolex_watch = {
    name = "Rolex óra #01",
    cat = "Ékszerek",
    ppPrice = 6700
  },
  v4_gold_blue_koves_kereszt_fux = {
    name = "Nyaklánc #46",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_gold_green_koves_kereszt_fux = {
    name = "Nyaklánc #47",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_gold_green_rolex_watch = {
    name = "Rolex óra #02",
    cat = "Ékszerek",
    ppPrice = 6700
  },
  v4_gold_lion_ring = {
    name = "Pecsétgyűrű #07",
    cat = "Ékszerek",
    ppPrice = 2550
  },
  v4_gold_medium_blackruby_ring = {
    name = "Pecsétgyűrű #08",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_medium_blueruby_ring = {
    name = "Pecsétgyűrű #09",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_medium_greenruby_ring = {
    name = "Pecsétgyűrű #10",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_medium_pinkruby_ring = {
    name = "Pecsétgyűrű #11",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_medium_redruby_ring = {
    name = "Pecsétgyűrű #12",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_medium_whiteruby_ring = {
    name = "Pecsétgyűrű #13",
    cat = "Ékszerek",
    ppPrice = 1210
  },
  v4_gold_megafux = {
    name = "Nyaklánc #48",
    cat = "Ékszerek",
    ppPrice = 7900
  },
  v4_gold_nyaklanc_kereszt = {
    name = "Nyaklánc #49",
    cat = "Ékszerek",
    ppPrice = 5400
  },
  v4_gold_nyaklanc_kereszt2 = {
    name = "Nyaklánc #50",
    cat = "Ékszerek",
    ppPrice = 5400
  },
  v4_gold_pink_koves_kereszt_fux = {
    name = "Nyaklánc #51",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_gold_raj_glass = {
    name = "Szemüveg #30",
    cat = "Szemüvegek",
    ppPrice = 3400
  },
  v4_gold_red_koves_kereszt_fux = {
    name = "Nyaklánc #52",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_gold_small_blackruby_ring = {
    name = "Pecsétgyűrű #14",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_small_blueruby_ring = {
    name = "Pecsétgyűrű #15",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_small_greenruby_ring = {
    name = "Pecsétgyűrű #16",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_small_pinkruby_ring = {
    name = "Pecsétgyűrű #17",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_small_redruby_ring = {
    name = "Pecsétgyűrű #18",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_small_whiteruby_ring = {
    name = "Pecsétgyűrű #19",
    cat = "Ékszerek",
    ppPrice = 890
  },
  v4_gold_vastag_nyaklanc = {
    name = "Nyaklánc #53",
    cat = "Ékszerek",
    ppPrice = 2800
  },
  v4_gold_watch = {
    name = "Karóra #15",
    cat = "Ékszerek",
    ppPrice = 1300
  },
  v4_gold_white_koves_kereszt_fux = {
    name = "Nyaklánc #54",
    cat = "Ékszerek",
    ppPrice = 1100
  },
  v4_rugosbeke_gold = {
    name = "Nyaklánc #55",
    cat = "Ékszerek",
    ppPrice = 7800
  },
  v4_rugosbeke_silver = {
    name = "Nyaklánc #56",
    cat = "Ékszerek",
    ppPrice = 4800
  },
  v4_silver_big_blackruby_ring = {
    name = "Pecsétgyűrű #20",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_big_blueruby_ring = {
    name = "Pecsétgyűrű #21",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_big_greenruby_ring = {
    name = "Pecsétgyűrű #22",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_big_pinkruby_ring = {
    name = "Pecsétgyűrű #23",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_big_redruby_ring = {
    name = "Pecsétgyűrű #24",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_big_whiteruby_ring = {
    name = "Pecsétgyűrű #25",
    cat = "Ékszerek",
    ppPrice = 510
  },
  v4_silver_blue_rolex_watch = {
    name = "Rolex óra #03",
    cat = "Ékszerek",
    ppPrice = 3800
  },
  v4_silver_casio_watch = {
    name = "Casio óra #04",
    cat = "Ékszerek",
    ppPrice = 1050
  },
  v4_silver_gold_rolex_watch = {
    name = "Rolex óra #04",
    cat = "Ékszerek",
    ppPrice = 5100
  },
  v4_silver_gold_watch = {
    name = "Karóra #16",
    cat = "Ékszerek",
    ppPrice = 1300
  },
  v4_silver_lion_ring = {
    name = "Pecsétgyűrű #26",
    cat = "Ékszerek",
    ppPrice = 850
  },
  v4_silver_megafux = {
    name = "Nyaklánc #60",
    cat = "Ékszerek",
    ppPrice = 3800
  },
  v4_silver_nyaklanc_kereszt = {
    name = "Nyaklánc #61",
    cat = "Ékszerek",
    ppPrice = 1800
  },
  v4_silver_nyaklanc_kereszt2 = {
    name = "Nyaklánc #62",
    cat = "Ékszerek",
    ppPrice = 1800
  },
  v4_silver_raj_glass = {
    name = "Szemüveg #31",
    cat = "Szemüvegek",
    ppPrice = 1500
  },
  v4_silver_rosegold_rolex_watch = {
    name = "Rolex óra #05",
    cat = "Ékszerek",
    ppPrice = 5100
  },
  v4_silver_rosegold_watch = {
    name = "Karóra #17",
    cat = "Ékszerek",
    ppPrice = 1300
  },
  v4_silver_vastag_nyaklanc = {
    name = "Nyaklánc #65",
    cat = "Ékszerek",
    ppPrice = 1600
  },
  v4_silver_watch = {
    name = "Karóra #18",
    cat = "Ékszerek",
    ppPrice = 1000
  },
  v4_white_sunglass = {
    name = "Szemüveg #32",
    cat = "Szemüvegek",
    ppPrice = 600
  },
  v4_cigar = {
    name = "Szivar",
    cat = "Egyéb",
    price = 10000
  },
  v4_cigarette = {
    name = "Cigaretta",
    cat = "Egyéb",
    price = 5000
  },
  v4_mustache1_black = {
    name = "Bajusz #01",
    cat = "Arcszőrzetek",
    price = 6440
  },
  v4_mustache1_brown = {
    name = "Bajusz #02",
    cat = "Arcszőrzetek",
    price = 6380
  },
  v4_mustache1_darkbrown = {
    name = "Bajusz #03",
    cat = "Arcszőrzetek",
    price = 6360
  },
  v4_mustache1_grey = {
    name = "Bajusz #04",
    cat = "Arcszőrzetek",
    price = 6460
  },
  v4_mustache1_white = {
    name = "Bajusz #05",
    cat = "Arcszőrzetek",
    price = 7400
  },
  v4_mustache2_black = {
    name = "Bajusz #06",
    cat = "Arcszőrzetek",
    price = 6860
  },
  v4_mustache2_brown = {
    name = "Bajusz #07",
    cat = "Arcszőrzetek",
    price = 6960
  },
  v4_mustache2_darkbrown = {
    name = "Bajusz #08",
    cat = "Arcszőrzetek",
    price = 6460
  },
  v4_mustache2_grey = {
    name = "Bajusz #09",
    cat = "Arcszőrzetek",
    price = 6670
  },
  v4_mustache2_white = {
    name = "Bajusz #10",
    cat = "Arcszőrzetek",
    price = 7280
  },
  v4_mustache3_black = {
    name = "Bajusz #11",
    cat = "Arcszőrzetek",
    price = 6990
  },
  v4_mustache3_brown = {
    name = "Bajusz #12",
    cat = "Arcszőrzetek",
    price = 6780
  },
  v4_mustache3_darkbrown = {
    name = "Bajusz #13",
    cat = "Arcszőrzetek",
    price = 6540
  },
  v4_mustache3_grey = {
    name = "Bajusz #14",
    cat = "Arcszőrzetek",
    price = 6770
  },
  v4_mustache3_white = {
    name = "Bajusz #15",
    cat = "Arcszőrzetek",
    price = 7370
  },
  v4_mustache4_black = {
    name = "Bajusz #16",
    cat = "Arcszőrzetek",
    price = 6830
  },
  v4_mustache4_brown = {
    name = "Bajusz #17",
    cat = "Arcszőrzetek",
    price = 6460
  },
  v4_mustache4_darkbrown = {
    name = "Bajusz #18",
    cat = "Arcszőrzetek",
    price = 6520
  },
  v4_mustache4_grey = {
    name = "Bajusz #19",
    cat = "Arcszőrzetek",
    price = 6680
  },
  v4_mustache4_white = {
    name = "Bajusz #20",
    cat = "Arcszőrzetek",
    price = 7380
  },
  v4_beard1_black = {
    name = "Szakáll #01",
    cat = "Arcszőrzetek",
    price = 6100
  },
  v4_beard1_brown = {
    name = "Szakáll #02",
    cat = "Arcszőrzetek",
    price = 6050
  },
  v4_beard1_darkbrown = {
    name = "Szakáll #03",
    cat = "Arcszőrzetek",
    price = 6080
  },
  v4_beard1_grey = {
    name = "Szakáll #04",
    cat = "Arcszőrzetek",
    price = 6440
  },
  v4_beard1_white = {
    name = "Szakáll #05",
    cat = "Arcszőrzetek",
    price = 6990
  },
  v4_beard2_black = {
    name = "Szakáll #06",
    cat = "Arcszőrzetek",
    price = 8440
  },
  v4_beard2_brown = {
    name = "Szakáll #07",
    cat = "Arcszőrzetek",
    price = 8520
  },
  v4_beard2_darkbrown = {
    name = "Szakáll #08",
    cat = "Arcszőrzetek",
    price = 8860
  },
  v4_beard2_grey = {
    name = "Szakáll #09",
    cat = "Arcszőrzetek",
    price = 8720
  },
  v4_beard2_white = {
    name = "Szakáll #10",
    cat = "Arcszőrzetek",
    price = 8990
  },
  v4_beard3_black = {
    name = "Szakáll #11",
    cat = "Arcszőrzetek",
    price = 12100
  },
  v4_beard3_brown = {
    name = "Szakáll #12",
    cat = "Arcszőrzetek",
    price = 12200
  },
  v4_beard3_darkbrown = {
    name = "Szakáll #13",
    cat = "Arcszőrzetek",
    price = 12600
  },
  v4_beard3_grey = {
    name = "Szakáll #14",
    cat = "Arcszőrzetek",
    price = 12480
  },
  v4_beard3_white = {
    name = "Szakáll #15",
    cat = "Arcszőrzetek",
    price = 12650
  },
  v4_beard4_black = {
    name = "Szakáll #16",
    cat = "Arcszőrzetek",
    price = 10600
  },
  v4_beard4_brown = {
    name = "Szakáll #17",
    cat = "Arcszőrzetek",
    price = 10880
  },
  v4_beard4_darkbrown = {
    name = "Szakáll #18",
    cat = "Arcszőrzetek",
    price = 10430
  },
  v4_beard4_grey = {
    name = "Szakáll #19",
    cat = "Arcszőrzetek",
    price = 10990
  },
  v4_beard4_white = {
    name = "Szakáll #20",
    cat = "Arcszőrzetek",
    price = 10990
  },
  v4_beard5_black = {
    name = "Szakáll #21",
    cat = "Arcszőrzetek",
    price = 13220
  },
  v4_beard5_brown = {
    name = "Szakáll #22",
    cat = "Arcszőrzetek",
    price = 13440
  },
  v4_beard5_darkbrown = {
    name = "Szakáll #23",
    cat = "Arcszőrzetek",
    price = 13600
  },
  v4_beard5_grey = {
    name = "Szakáll #24",
    cat = "Arcszőrzetek",
    price = 13800
  },
  v4_beard5_white = {
    name = "Szakáll #25",
    cat = "Arcszőrzetek",
    price = 13990
  },
  v4_beard6_black = {
    name = "Szakáll #26",
    cat = "Arcszőrzetek",
    price = 8480
  },
  v4_beard6_brown = {
    name = "Szakáll #27",
    cat = "Arcszőrzetek",
    price = 8560
  },
  v4_beard6_darkbrown = {
    name = "Szakáll #28",
    cat = "Arcszőrzetek",
    price = 8740
  },
  v4_beard6_grey = {
    name = "Szakáll #29",
    cat = "Arcszőrzetek",
    price = 8850
  },
  v4_beard6_white = {
    name = "Szakáll #30",
    cat = "Arcszőrzetek",
    price = 8990
  },
  v4_bandana1_black = {
    name = "Bandana #01",
    cat = "Bandana kendők",
    price = 8450
  },
  v4_bandana1_blue = {
    name = "Bandana #02",
    cat = "Bandana kendők",
    price = 8620
  },
  v4_bandana1_camo1 = {
    name = "Bandana #03",
    cat = "Bandana kendők",
    price = 8960
  },
  v4_bandana1_camo2 = {
    name = "Bandana #04",
    cat = "Bandana kendők",
    price = 8970
  },
  v4_bandana1_darkblue = {
    name = "Bandana #05",
    cat = "Bandana kendők",
    price = 8430
  },
  v4_bandana1_darkgreen = {
    name = "Bandana #06",
    cat = "Bandana kendők",
    price = 8420
  },
  v4_bandana1_green = {
    name = "Bandana #07",
    cat = "Bandana kendők",
    price = 8510
  },
  v4_bandana1_grey = {
    name = "Bandana #08",
    cat = "Bandana kendők",
    price = 8630
  },
  v4_bandana1_purple = {
    name = "Bandana #09",
    cat = "Bandana kendők",
    price = 8940
  },
  v4_bandana1_red = {
    name = "Bandana #10",
    cat = "Bandana kendők",
    price = 8780
  },
  v4_bandana1_redneck = {
    name = "Bandana #11",
    cat = "Bandana kendők",
    price = 9440
  },
  v4_bandana1_yellow = {
    name = "Bandana #12",
    cat = "Bandana kendők",
    price = 8530
  },
  v4_bandana2_black = {
    name = "Bandana #13",
    cat = "Bandana kendők",
    price = 8680
  },
  v4_bandana2_blue = {
    name = "Bandana #14",
    cat = "Bandana kendők",
    price = 8550
  },
  v4_bandana2_camo1 = {
    name = "Bandana #15",
    cat = "Bandana kendők",
    price = 8690
  },
  v4_bandana2_camo2 = {
    name = "Bandana #16",
    cat = "Bandana kendők",
    price = 8710
  },
  v4_bandana2_darkblue = {
    name = "Bandana #17",
    cat = "Bandana kendők",
    price = 8880
  },
  v4_bandana2_darkgreen = {
    name = "Bandana #18",
    cat = "Bandana kendők",
    price = 8430
  },
  v4_bandana2_green = {
    name = "Bandana #19",
    cat = "Bandana kendők",
    price = 8550
  },
  v4_bandana2_grey = {
    name = "Bandana #20",
    cat = "Bandana kendők",
    price = 8380
  },
  v4_bandana2_purple = {
    name = "Bandana #21",
    cat = "Bandana kendők",
    price = 8990
  },
  v4_bandana2_red = {
    name = "Bandana #22",
    cat = "Bandana kendők",
    price = 8750
  },
  v4_bandana2_yellow = {
    name = "Bandana #23",
    cat = "Bandana kendők",
    price = 8800
  },
  v4_bandana3_black = {
    name = "Bandana #24",
    cat = "Bandana kendők",
    price = 8760
  },
  v4_bandana3_blue = {
    name = "Bandana #25",
    cat = "Bandana kendők",
    price = 8680
  },
  v4_bandana3_camo1 = {
    name = "Bandana #26",
    cat = "Bandana kendők",
    price = 8990
  },
  v4_bandana3_camo2 = {
    name = "Bandana #27",
    cat = "Bandana kendők",
    price = 8990
  },
  v4_bandana3_darkblue = {
    name = "Bandana #28",
    cat = "Bandana kendők",
    price = 8770
  },
  v4_bandana3_darkgreen = {
    name = "Bandana #29",
    cat = "Bandana kendők",
    price = 8650
  },
  v4_bandana3_green = {
    name = "Bandana #30",
    cat = "Bandana kendők",
    price = 8440
  },
  v4_bandana3_grey = {
    name = "Bandana #31",
    cat = "Bandana kendők",
    price = 8400
  },
  v4_bandana3_purple = {
    name = "Bandana #32",
    cat = "Bandana kendők",
    price = 8660
  },
  v4_bandana3_red = {
    name = "Bandana #33",
    cat = "Bandana kendők",
    price = 8680
  },
  v4_bandana3_redneck = {
    name = "Bandana #34",
    cat = "Bandana kendők",
    price = 8580
  },
  v4_bandana3_yellow = {
    name = "Bandana #35",
    cat = "Bandana kendők",
    price = 8770
  },
  v4_bandana4_black = {
    name = "Bandana #36",
    cat = "Bandana kendők",
    price = 8335
  },
  v4_bandana4_blue = {
    name = "Bandana #37",
    cat = "Bandana kendők",
    price = 8330
  },
  v4_bandana4_camo1 = {
    name = "Bandana #38",
    cat = "Bandana kendők",
    price = 8660
  },
  v4_bandana4_camo2 = {
    name = "Bandana #39",
    cat = "Bandana kendők",
    price = 8480
  },
  v4_bandana4_darkblue = {
    name = "Bandana #40",
    cat = "Bandana kendők",
    price = 8450
  },
  v4_bandana4_darkgreen = {
    name = "Bandana #41",
    cat = "Bandana kendők",
    price = 8560
  },
  v4_bandana4_green = {
    name = "Bandana #42",
    cat = "Bandana kendők",
    price = 8660
  },
  v4_bandana4_grey = {
    name = "Bandana #43",
    cat = "Bandana kendők",
    price = 8440
  },
  v4_bandana4_purple = {
    name = "Bandana #44",
    cat = "Bandana kendők",
    price = 8550
  },
  v4_bandana4_red = {
    name = "Bandana #45",
    cat = "Bandana kendők",
    price = 8890
  },
  v4_bandana4_yellow = {
    name = "Bandana #46",
    cat = "Bandana kendők",
    price = 8780
  },
  v4_bandana5_black = {
    name = "Bandana #47",
    cat = "Bandana kendők",
    price = 8660
  },
  v4_bandana5_blue = {
    name = "Bandana #48",
    cat = "Bandana kendők",
    price = 8580
  },
  v4_bandana5_camo1 = {
    name = "Bandana #49",
    cat = "Bandana kendők",
    price = 8570
  },
  v4_bandana5_camo2 = {
    name = "Bandana #50",
    cat = "Bandana kendők",
    price = 8970
  },
  v4_bandana5_darkblue = {
    name = "Bandana #51",
    cat = "Bandana kendők",
    price = 8220
  },
  v4_bandana5_darkgreen = {
    name = "Bandana #52",
    cat = "Bandana kendők",
    price = 8380
  },
  v4_bandana5_green = {
    name = "Bandana #53",
    cat = "Bandana kendők",
    price = 8555
  },
  v4_bandana5_grey = {
    name = "Bandana #54",
    cat = "Bandana kendők",
    price = 8740
  },
  v4_bandana5_purple = {
    name = "Bandana #55",
    cat = "Bandana kendők",
    price = 8540
  },
  v4_bandana5_red = {
    name = "Bandana #56",
    cat = "Bandana kendők",
    price = 8990
  },
  v4_bandana5_redneck = {
    name = "Bandana #57",
    cat = "Bandana kendők",
    price = 9650
  },
  v4_bandana5_yellow = {
    name = "Bandana #58",
    cat = "Bandana kendők",
    price = 8690
  },
  bowtie_black = {
    name = "Csokor nyakkendő #01",
    cat = "Egyéb",
    price = 3800
  },
  bowtie_blue = {
    name = "Csokor nyakkendő #02",
    cat = "Egyéb",
    price = 3800
  },
  bowtie_red = {
    name = "Csokor nyakkendő #03",
    cat = "Egyéb",
    price = 3800
  },
  tie_blue = {
    name = "Nyakkendő #01",
    cat = "Egyéb",
    price = 8900
  },
  tie_grey = {
    name = "Nyakkendő #02",
    cat = "Egyéb",
    price = 9100
  },
  tie_red = {
    name = "Nyakkendő #03",
    cat = "Egyéb",
    price = 9200
  },
  rose_red = {
    name = "Rózsa #03",
    cat = "Egyéb",
    price = 14600
  },
  fehersal = {
    name = "Sál #01",
    cat = "Egyéb",
    price = 12600
  },
  pirossal = {
    name = "Sál #02",
    cat = "Egyéb",
    price = 12800
  },
  zoldsal = {
    name = "Sál #03",
    cat = "Egyéb",
    price = 13400
  },
  eyepatch_left = {
    name = "Szemfedő bal",
    cat = "Egyéb",
    price = 18600
  },
  eyepatch_right = {
    name = "Szemfedő jobb",
    cat = "Egyéb",
    price = 18600
  },
  rocker_necklace = {
    name = "Szöges nyaklánc #01",
    cat = "Egyéb",
    price = 28400
  },
  earring1_gold = {
    name = "Arany füllbevaló #01",
    cat = "Ékszerek",
    price = 105000
  },
  earring2_gold = {
    name = "Arany füllbevaló #02",
    cat = "Ékszerek",
    price = 128000
  },
  WatchType1 = {
    name = "Arany óra #03",
    cat = "Ékszerek",
    price = 280000
  },
  earring1_silver = {
    name = "Ezüst füllbevaló #01",
    cat = "Ékszerek",
    price = 62600
  },
  earring2_silver = {
    name = "Ezüst füllbevaló #02",
    cat = "Ékszerek",
    price = 70500
  },
  earring3_silver = {
    name = "Ezüst füllbevaló #03",
    cat = "Ékszerek",
    price = 80100
  },
  earring4_silver = {
    name = "Ezüst füllbevaló #04",
    cat = "Ékszerek",
    price = 81000
  },
  bracelet_silver = {
    name = "Ezüst karkötő #01",
    cat = "Ékszerek",
    price = 48600
  },
  WatchType2 = {
    name = "Ezüst óra #01",
    cat = "Ékszerek",
    price = 140000
  },
  WatchType5 = {
    name = "Ezüst óra #02",
    cat = "Ékszerek",
    price = 138000
  },
  necklace_csonti = {
    name = "Nyaklánc #01",
    cat = "Ékszerek",
    price = 125000
  },
  necklace_fu = {
    name = "Nyaklánc #02",
    cat = "Ékszerek",
    price = 134000
  },
  necklace_gang = {
    name = "Nyaklánc #03",
    cat = "Ékszerek",
    price = 131000
  },
  necklace_gang2 = {
    name = "Nyaklánc #04",
    cat = "Ékszerek",
    price = 83200
  },
  necklace_gold_black = {
    name = "Nyaklánc #05",
    cat = "Ékszerek",
    price = 108000
  },
  necklace_gold_blue = {
    name = "Nyaklánc #06",
    cat = "Ékszerek",
    price = 112000
  },
  necklace_gold_pink = {
    name = "Nyaklánc #07",
    cat = "Ékszerek",
    price = 109000
  },
  necklace_gold_red = {
    name = "Nyaklánc #08",
    cat = "Ékszerek",
    price = 114000
  },
  necklace_gold_white = {
    name = "Nyaklánc #09",
    cat = "Ékszerek",
    price = 116000
  },
  necklace_heart = {
    name = "Nyaklánc #10",
    cat = "Ékszerek",
    price = 109000
  },
  necklace_heart_gold_black = {
    name = "Nyaklánc #11",
    cat = "Ékszerek",
    price = 117000
  },
  necklace_heart_gold_blue = {
    name = "Nyaklánc #12",
    cat = "Ékszerek",
    price = 117000
  },
  necklace_heart_gold_pink = {
    name = "Nyaklánc #13",
    cat = "Ékszerek",
    price = 112000
  },
  necklace_heart_gold_red = {
    name = "Nyaklánc #14",
    cat = "Ékszerek",
    price = 119000
  },
  necklace_heart_gold_silver = {
    name = "Nyaklánc #15",
    cat = "Ékszerek",
    price = 109000
  },
  necklace_heart_silver_black = {
    name = "Nyaklánc #16",
    cat = "Ékszerek",
    price = 78000
  },
  necklace_heart_silver_blue = {
    name = "Nyaklánc #17",
    cat = "Ékszerek",
    price = 79000
  },
  necklace_heart_silver_pink = {
    name = "Nyaklánc #18",
    cat = "Ékszerek",
    price = 80500
  },
  necklace_heart_silver_red = {
    name = "Nyaklánc #19",
    cat = "Ékszerek",
    price = 77100
  },
  necklace_joker = {
    name = "Nyaklánc #20",
    cat = "Ékszerek",
    price = 195000
  },
  necklace_maci = {
    name = "Nyaklánc #21",
    cat = "Ékszerek",
    price = 190000
  },
  necklace_maszk = {
    name = "Nyaklánc #22",
    cat = "Ékszerek",
    price = 184600
  },
  necklace_silver_black = {
    name = "Nyaklánc #24",
    cat = "Ékszerek",
    price = 76500
  },
  necklace_silver_blue = {
    name = "Nyaklánc #25",
    cat = "Ékszerek",
    price = 77400
  },
  necklace_silver_pink = {
    name = "Nyaklánc #26",
    cat = "Ékszerek",
    price = 78100
  },
  necklace_silver_red = {
    name = "Nyaklánc #27",
    cat = "Ékszerek",
    price = 74600
  },
  necklace_silver_white = {
    name = "Nyaklánc #28",
    cat = "Ékszerek",
    price = 72800
  },
  necklace_snake = {
    name = "Nyaklánc #29",
    cat = "Ékszerek",
    price = 148600
  },
  necklace_snitch = {
    name = "Nyaklánc #30",
    cat = "Ékszerek",
    price = 81600
  },
  necklace_v = {
    name = "Nyaklánc #31",
    cat = "Ékszerek",
    price = 162000
  },
  Nyaklanc_1 = {
    name = "Nyaklánc #32",
    cat = "Ékszerek",
    price = 202000
  },
  Nyaklanc_2 = {
    name = "Nyaklánc #33",
    cat = "Ékszerek",
    price = 218000
  },
  Nyaklanc_3 = {
    name = "Nyaklánc #34",
    cat = "Ékszerek",
    price = 89900
  },
  Nyaklanc_5 = {
    name = "Nyaklánc #36",
    cat = "Ékszerek",
    price = 102000
  },
  v3_necklace1 = {
    name = "Nyaklánc #37",
    cat = "Ékszerek",
    price = 218000
  },
  v3_necklace2 = {
    name = "Nyaklánc #38",
    cat = "Ékszerek",
    price = 70600
  },
  v3_necklace3 = {
    name = "Nyaklánc #39",
    cat = "Ékszerek",
    price = 54500
  },
  v3_necklace4 = {
    name = "Nyaklánc #40",
    cat = "Ékszerek",
    price = 42900
  },
  v3_necklace5 = {
    name = "Nyaklánc #41",
    cat = "Ékszerek",
    price = 254000
  },
  v3_necklace7 = {
    name = "Nyaklánc #43",
    cat = "Ékszerek",
    price = 96700
  },
  v3_necklace8 = {
    name = "Nyaklánc #44",
    cat = "Ékszerek",
    price = 85400
  },
  piere1 = {
    name = "Piercing #22",
    cat = "Ékszerek",
    price = 51000
  },
  piere2 = {
    name = "Piercing #23",
    cat = "Ékszerek",
    price = 52000
  },
  piere3 = {
    name = "Piercing #24",
    cat = "Ékszerek",
    price = 50800
  },
  piere4 = {
    name = "Piercing #25",
    cat = "Ékszerek",
    price = 51200
  },
  piere5 = {
    name = "Piercing #26",
    cat = "Ékszerek",
    price = 50600
  },
  pieree1 = {
    name = "Piercing #27",
    cat = "Ékszerek",
    price = 50400
  },
  pieree2 = {
    name = "Piercing #28",
    cat = "Ékszerek",
    price = 51800
  },
  pieree3 = {
    name = "Piercing #29",
    cat = "Ékszerek",
    price = 50080
  },
  pieree4 = {
    name = "Piercing #30",
    cat = "Ékszerek",
    price = 51600
  },
  pieree5 = {
    name = "Piercing #31",
    cat = "Ékszerek",
    price = 51100
  },
  piereee1 = {
    name = "Piercing #32",
    cat = "Ékszerek",
    price = 51200
  },
  piereeee1 = {
    name = "Piercing #33",
    cat = "Ékszerek",
    price = 51600
  },
  piereeee2 = {
    name = "Piercing #34",
    cat = "Ékszerek",
    price = 51450
  },
  piereeee3 = {
    name = "Piercing #35",
    cat = "Ékszerek",
    price = 52600
  },
  piereeee4 = {
    name = "Piercing #36",
    cat = "Ékszerek",
    price = 52400
  },
  piereeee5 = {
    name = "Piercing #37",
    cat = "Ékszerek",
    price = 52200
  },
  piereeeee1 = {
    name = "Piercing #38",
    cat = "Ékszerek",
    price = 53600
  },
  piereeeee2 = {
    name = "Piercing #39",
    cat = "Ékszerek",
    price = 53000
  },
  piereeeee3 = {
    name = "Piercing #40",
    cat = "Ékszerek",
    price = 53400
  },
  piereeeee4 = {
    name = "Piercing #41",
    cat = "Ékszerek",
    price = 53250
  },
  piereeeee5 = {
    name = "Piercing #42",
    cat = "Ékszerek",
    price = 55000
  },
  fejhallgato = {
    name = "Fejhallgató #01",
    cat = "Fejhallgatók",
    price = 18400
  },
  fejhallgato2 = {
    name = "Fejhallgató #02",
    cat = "Fejhallgatók",
    price = 23600
  },
  headset_camo = {
    name = "Fejhallgató #03",
    cat = "Fejhallgatók",
    price = 38600
  },
  headset_camo2 = {
    name = "Fejhallgató #04",
    cat = "Fejhallgatók",
    price = 37000
  },
  headset_joker = {
    name = "Fejhallgató #07",
    cat = "Fejhallgatók",
    price = 50200
  },
  v4_hair_dreadlock1 = {
    name = "Hajstílus #01",
    cat = "Hajformák",
    price = 19600
  },
  v4_hair_long1_black = {
    name = "Hajstílus #03",
    cat = "Hajformák",
    price = 9140
  },
  v4_hair_long1_brown = {
    name = "Hajstílus #04",
    cat = "Hajformák",
    price = 9220
  },
  v4_hair_long2_black = {
    name = "Hajstílus #05",
    cat = "Hajformák",
    price = 9430
  },
  v4_hair_long2_brown = {
    name = "Hajstílus #06",
    cat = "Hajformák",
    price = 9220
  },
  v4_hair_long3_black = {
    name = "Hajstílus #07",
    cat = "Hajformák",
    price = 9380
  },
  v4_hair_long3_brown = {
    name = "Hajstílus #08",
    cat = "Hajformák",
    price = 9160
  },
  v4_hair_microfon_black = {
    name = "Hajstílus #09",
    cat = "Hajformák",
    price = 12300
  },
  v4_hair_microfon_brown = {
    name = "Hajstílus #10",
    cat = "Hajformák",
    price = 12400
  },
  v4_hair_microfon_darkbrown = {
    name = "Hajstílus #11",
    cat = "Hajformák",
    price = 12200
  },
  v4_hair_punk_black = {
    name = "Hajstílus #12",
    cat = "Hajformák",
    price = 10800
  },
  v4_hair_short1_black = {
    name = "Hajstílus #18",
    cat = "Hajformák",
    price = 8640
  },
  v4_hair_short1_brown = {
    name = "Hajstílus #19",
    cat = "Hajformák",
    price = 8580
  },
  v4_hair_short2_black = {
    name = "Hajstílus #20",
    cat = "Hajformák",
    price = 8660
  },
  v4_hair_short2_brown = {
    name = "Hajstílus #21",
    cat = "Hajformák",
    price = 8740
  },
  v4_hair_short3_black = {
    name = "Hajstílus #22",
    cat = "Hajformák",
    price = 8850
  },
  v4_hair_short3_brown = {
    name = "Hajstílus #23",
    cat = "Hajformák",
    price = 8940
  },
  Ora_3 = {
    name = "Karóra #01",
    cat = "Karórák, karkötők",
    price = 102000
  },
  WatchType10 = {
    name = "Karóra #02",
    cat = "Karórák, karkötők",
    price = 12800
  },
  WatchType11 = {
    name = "Karóra #03",
    cat = "Karórák, karkötők",
    price = 11600
  },
  WatchType12 = {
    name = "Karóra #04",
    cat = "Karórák, karkötők",
    price = 14300
  },
  WatchType13 = {
    name = "Karóra #05",
    cat = "Karórák, karkötők",
    price = 13800
  },
  WatchType14 = {
    name = "Karóra #06",
    cat = "Karórák, karkötők",
    price = 12670
  },
  WatchType15 = {
    name = "Karóra #07",
    cat = "Karórák, karkötők",
    price = 13480
  },
  WatchType3 = {
    name = "Karóra #08",
    cat = "Karórák, karkötők",
    price = 64500
  },
  WatchType6 = {
    name = "Karóra #09",
    cat = "Karórák, karkötők",
    price = 14600
  },
  WatchType7 = {
    name = "Karóra #10",
    cat = "Karórák, karkötők",
    price = 13950
  },
  WatchType8 = {
    name = "Karóra #11",
    cat = "Karórák, karkötők",
    price = 14100
  },
  WatchType9 = {
    name = "Karóra #12",
    cat = "Karórák, karkötők",
    price = 15100
  },
  bracelet2 = {
    name = "Szöges karkötő #01",
    cat = "Karórák, karkötők",
    price = 18400
  },
  bracelet3 = {
    name = "Szöges karkötő #02",
    cat = "Karórák, karkötők",
    price = 18400
  },
  v4_bandana6_black = {
    name = "Maszk #11",
    cat = "Maszkok",
    price = 15630
  },
  v4_bandana6_blue = {
    name = "Maszk #12",
    cat = "Maszkok",
    price = 15440
  },
  v4_bandana6_camo1 = {
    name = "Maszk #13",
    cat = "Maszkok",
    price = 19430
  },
  v4_bandana6_camo2 = {
    name = "Maszk #14",
    cat = "Maszkok",
    price = 18800
  },
  v4_bandana6_darkblue = {
    name = "Maszk #15",
    cat = "Maszkok",
    price = 16100
  },
  v4_bandana6_darkgreen = {
    name = "Maszk #16",
    cat = "Maszkok",
    price = 16200
  },
  v4_bandana6_green = {
    name = "Maszk #17",
    cat = "Maszkok",
    price = 16600
  },
  v4_bandana6_grey = {
    name = "Maszk #18",
    cat = "Maszkok",
    price = 15450
  },
  v4_bandana6_purple = {
    name = "Maszk #19",
    cat = "Maszkok",
    price = 18200
  },
  v4_bandana6_red = {
    name = "Maszk #20",
    cat = "Maszkok",
    price = 17950
  },
  v4_bandana6_redneck = {
    name = "Maszk #21",
    cat = "Maszkok",
    price = 19900
  },
  v4_bandana6_skull = {
    name = "Maszk #22",
    cat = "Maszkok",
    price = 21490
  },
  v4_bandana6_yellow = {
    name = "Maszk #23",
    cat = "Maszkok",
    price = 18550
  },
  ferfimelleny = {
    name = "Mellény #01",
    cat = "Mellények",
    price = 18400
  },
  ferfimelleny2 = {
    name = "Mellény #02",
    cat = "Mellények",
    price = 22400
  },
  v3_civilianvest1 = {
    name = "Láthatósági mellény",
    cat = "Mellények",
    price = 14200
  },
  v3_civilianvest10 = {
    name = "Mellény #04",
    cat = "Mellények",
    price = 15100
  },
  v3_civilianvest11 = {
    name = "Mellény #05",
    cat = "Mellények",
    price = 14300
  },
  v3_civilianvest12 = {
    name = "Mellény #06",
    cat = "Mellények",
    price = 14860
  },
  v3_civilianvest2 = {
    name = "Mellény #07",
    cat = "Mellények",
    price = 15230
  },
  v3_civilianvest3 = {
    name = "Mellény #08",
    cat = "Mellények",
    price = 14900
  },
  v3_civilianvest4 = {
    name = "Mellény #09",
    cat = "Mellények",
    price = 15100
  },
  v3_civilianvest5 = {
    name = "Mellény #10",
    cat = "Mellények",
    price = 14960
  },
  v3_civilianvest6 = {
    name = "Mellény #11",
    cat = "Mellények",
    price = 15080
  },
  v3_civilianvest7 = {
    name = "Mellény #12",
    cat = "Mellények",
    price = 14310
  },
  v3_civilianvest8 = {
    name = "Mellény #13",
    cat = "Mellények",
    price = 15100
  },
  v3_civilianvest9 = {
    name = "Mellény #03",
    cat = "Mellények",
    price = 14990
  },
  noimelleny = {
    name = "Női mellény #01",
    cat = "Mellények",
    price = 26200
  },
  noimelleny2 = {
    name = "Női mellény #02",
    cat = "Mellények",
    price = 26800
  },
  CapTrucker = {
    name = "Baseball sapka #01",
    cat = "Sapkák, kalapok",
    price = 12100
  },
  CapTrucker1 = {
    name = "Baseball sapka #02",
    cat = "Sapkák, kalapok",
    price = 13400
  },
  CapTrucker2 = {
    name = "Baseball sapka #03",
    cat = "Sapkák, kalapok",
    price = 12600
  },
  CapTrucker3 = {
    name = "Baseball sapka #04",
    cat = "Sapkák, kalapok",
    price = 11800
  },
  CapTrucker4 = {
    name = "Baseball sapka #05",
    cat = "Sapkák, kalapok",
    price = 13400
  },
  CapTrucker5 = {
    name = "Baseball sapka #06",
    cat = "Sapkák, kalapok",
    price = 12860
  },
  CapTrucker6 = {
    name = "Baseball sapka #07",
    cat = "Sapkák, kalapok",
    price = 13100
  },
  Hat1 = {
    name = "Baseball sapka #08",
    cat = "Sapkák, kalapok",
    price = 14080
  },
  Hat10 = {
    name = "Baseball sapka #09",
    cat = "Sapkák, kalapok",
    price = 14100
  },
  Hat2 = {
    name = "Baseball sapka #10",
    cat = "Sapkák, kalapok",
    price = 14200
  },
  Hat3 = {
    name = "Baseball sapka #11",
    cat = "Sapkák, kalapok",
    price = 15080
  },
  Hat4 = {
    name = "Baseball sapka #12",
    cat = "Sapkák, kalapok",
    price = 13900
  },
  Hat5 = {
    name = "Baseball sapka #13",
    cat = "Sapkák, kalapok",
    price = 13900
  },
  Hat6 = {
    name = "Baseball sapka #14",
    cat = "Sapkák, kalapok",
    price = 14050
  },
  Hat7 = {
    name = "Baseball sapka #15",
    cat = "Sapkák, kalapok",
    price = 14310
  },
  Hat8 = {
    name = "Baseball sapka #16",
    cat = "Sapkák, kalapok",
    price = 14400
  },
  Hat9 = {
    name = "Baseball sapka #17",
    cat = "Sapkák, kalapok",
    price = 15600
  },
  Sapka_1 = {
    name = "Baseball sapka #18",
    cat = "Sapkák, kalapok",
    price = 26700
  },
  Sapka_3 = {
    name = "Baseball sapka #19",
    cat = "Sapkák, kalapok",
    price = 27600
  },
  Sapka_4 = {
    name = "Baseball sapka #20",
    cat = "Sapkák, kalapok",
    ppPrice = 490
  },
  Sapka_6 = {
    name = "Baseball sapka #21",
    cat = "Sapkák, kalapok",
    price = 30600
  },
  Sapka_7 = {
    name = "Baseball sapka #22",
    cat = "Sapkák, kalapok",
    price = 44600
  },
  newera_angels = {
    name = "New Era LA Angels",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_bostonredsox = {
    name = "New Era Boston Red Sox",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_dodgers = {
    name = "New Era LA Dodgers",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_houstonastros = {
    name = "New Era Houston Astros",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_oaklandathletics = {
    name = "New Era Oakland Athletics",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_phillies = {
    name = "New Era Philadelphia Phillies",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_raiders = {
    name = "New Era Raiders",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_sfgiants = {
    name = "New Era SF Giants",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_washingtonnationals = {
    name = "New Era Washington Nationals",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_yankees = {
    name = "New Era New York Yankees",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_reds = {
    name = "New Era Cincinnati Reds",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  newera_sox = {
    name = "New Era Chicago White Sox",
    cat = "Sapkák, kalapok",
    price = 24000
  },
  seedyno_cap = {
    name = "SeeDYNO sapka",
    cat = "Sapkák, kalapok",
    price = 10000
  },
  nikebuckethat = {
    name = "Bucket sapka #02",
    cat = "Sapkák, kalapok",
    price = 20800
  },
  sadboybuckethat = {
    name = "Bucket sapka #03",
    cat = "Sapkák, kalapok",
    price = 31400
  },
  Sapka_5 = {
    name = "Bucket sapka #05",
    cat = "Sapkák, kalapok",
    price = 30800
  },
  v4_cilinder_blackandgrey = {
    name = "Cilinder #01",
    cat = "Sapkák, kalapok",
    price = 36400
  },
  v4_cilinder_blackandwhite = {
    name = "Cilinder #02",
    cat = "Sapkák, kalapok",
    price = 38500
  },
  v4_cilinder_blueandblack = {
    name = "Cilinder #03",
    cat = "Sapkák, kalapok",
    price = 34300
  },
  v4_cilinder_greenandblack = {
    name = "Cilinder #04",
    cat = "Sapkák, kalapok",
    price = 36900
  },
  v4_cilinder_greyandblack = {
    name = "Cilinder #05",
    cat = "Sapkák, kalapok",
    price = 37500
  },
  v4_cilinder_purpleandblack = {
    name = "Cilinder #07",
    cat = "Sapkák, kalapok",
    price = 39900
  },
  v4_cilinder_redandblack = {
    name = "Cilinder #08",
    cat = "Sapkák, kalapok",
    price = 38800
  },
  cow = {
    name = "Cowboy kalap #01",
    cat = "Sapkák, kalapok",
    price = 19600
  },
  cow3 = {
    name = "Cowboy kalap #03",
    cat = "Sapkák, kalapok",
    price = 20400
  },
  cow4 = {
    name = "Cowboy kalap #04",
    cat = "Sapkák, kalapok",
    price = 19800
  },
  cow5 = {
    name = "Cowboy kalap #05",
    cat = "Sapkák, kalapok",
    price = 21100
  },
  cow6 = {
    name = "Cowboy kalap #06",
    cat = "Sapkák, kalapok",
    price = 19900
  },
  cow7 = {
    name = "Cowboy kalap #07",
    cat = "Sapkák, kalapok",
    price = 19500
  },
  HatBowler1 = {
    name = "Elegáns kalap #01",
    cat = "Sapkák, kalapok",
    price = 31400
  },
  HatBowler2 = {
    name = "Elegáns kalap #02",
    cat = "Sapkák, kalapok",
    price = 32600
  },
  HatBowler3 = {
    name = "Elegáns kalap #03",
    cat = "Sapkák, kalapok",
    price = 31800
  },
  HatBowler4 = {
    name = "Elegáns kalap #04",
    cat = "Sapkák, kalapok",
    price = 30900
  },
  HatBowler5 = {
    name = "Elegáns kalap #06",
    cat = "Sapkák, kalapok",
    price = 31000
  },
  v3_hut1 = {
    name = "Elegáns kalap #07",
    cat = "Sapkák, kalapok",
    price = 34900
  },
  headband2_black = {
    name = "Fejpánt #04",
    cat = "Sapkák, kalapok",
    price = 28400
  },
  headband2_pink = {
    name = "Fejpánt #05",
    cat = "Sapkák, kalapok",
    price = 28900
  },
  headband2_red = {
    name = "Fejpánt #06",
    cat = "Sapkák, kalapok",
    price = 28500
  },
  headband3_black = {
    name = "Fejpánt #07",
    cat = "Sapkák, kalapok",
    price = 29200
  },
  headband3_pink = {
    name = "Fejpánt #08",
    cat = "Sapkák, kalapok",
    price = 29300
  },
  headband3_red = {
    name = "Fejpánt #09",
    cat = "Sapkák, kalapok",
    price = 29400
  },
  headband4_black = {
    name = "Fejpánt #10",
    cat = "Sapkák, kalapok",
    price = 28700
  },
  headband4_pink = {
    name = "Fejpánt #11",
    cat = "Sapkák, kalapok",
    price = 28800
  },
  headband4_red = {
    name = "Fejpánt #12",
    cat = "Sapkák, kalapok",
    price = 28900
  },
  guccisapi = {
    name = "Gucci sapka",
    cat = "Sapkák, kalapok",
    price = 78500
  },
  HatCool1 = {
    name = "Horgász kalap #01",
    cat = "Sapkák, kalapok",
    price = 10600
  },
  HatCool2 = {
    name = "Horgász kalap #02",
    cat = "Sapkák, kalapok",
    price = 10800
  },
  HatCool3 = {
    name = "Horgász kalap #03",
    cat = "Sapkák, kalapok",
    price = 11600
  },
  BPeaky = {
    name = "Peaky sapka #01",
    cat = "Sapkák, kalapok",
    price = 29300
  },
  KPeaky = {
    name = "Peaky sapka #02",
    cat = "Sapkák, kalapok",
    price = 29600
  },
  PPeaky = {
    name = "Peaky sapka #03",
    cat = "Sapkák, kalapok",
    price = 29450
  },
  SzPeaky = {
    name = "Peaky sapka #04",
    cat = "Sapkák, kalapok",
    price = 29600
  },
  SkullyCap1 = {
    name = "Sapka #01",
    cat = "Sapkák, kalapok",
    price = 12600
  },
  SkullyCap2 = {
    name = "Sapka #02",
    cat = "Sapkák, kalapok",
    price = 14080
  },
  SkullyCap3 = {
    name = "Sapka #03",
    cat = "Sapkák, kalapok",
    price = 13500
  },
  v3_hut2 = {
    name = "Szalma kalap #01",
    cat = "Sapkák, kalapok",
    price = 20800
  },
  v3_hut3 = {
    name = "Szalma kalap #02",
    cat = "Sapkák, kalapok",
    price = 20900
  },
  usanka = {
    name = "Usanka",
    cat = "Sapkák, kalapok",
    price = 20600
  },
  manosapka = {
    name = "Ünnepi sapka #01",
    cat = "Sapkák, kalapok",
    price = 18600
  },
  mikulassapka = {
    name = "Ünnepi sapka #02",
    cat = "Sapkák, kalapok",
    price = 19600
  },
  cross_helmet = {
    name = "Cross sisak #01",
    cat = "Sisakok",
    price = 30200
  },
  cross_helmet2 = {
    name = "Cross sisak #02",
    cat = "Sisakok",
    price = 30000
  },
  cross_helmet4 = {
    name = "Cross sisak #04",
    cat = "Sisakok",
    price = 29800
  },
  blackbikerhelmet = {
    name = "Motoros sisak #01",
    cat = "Sisakok",
    price = 18500
  },
  MotorcycleHelmet1 = {
    name = "Motoros sisak #02",
    cat = "Sisakok",
    price = 17600
  },
  MotorcycleHelmet2 = {
    name = "Motoros sisak #03",
    cat = "Sisakok",
    price = 18200
  },
  MotorcycleHelmet3 = {
    name = "Motoros sisak #04",
    cat = "Sisakok",
    price = 18100
  },
  MotorcycleHelmet4 = {
    name = "Motoros sisak #05",
    cat = "Sisakok",
    price = 18050
  },
  whitecamobikerhelmet = {
    name = "Motoros sisak #06",
    cat = "Sisakok",
    price = 17800
  },
  HardHat1 = {
    name = "Munkavédelmi sisak",
    cat = "Sisakok",
    price = 10500
  },
  greencamobikerhelmet = {
    name = "Terepmintás sisak",
    cat = "Sisakok",
    price = 20600
  },
  GlassesType1 = {
    name = "Szemüveg #01",
    cat = "Szemüvegek",
    price = 8400
  },
  GlassesType10 = {
    name = "Szemüveg #02",
    cat = "Szemüvegek",
    price = 8200
  },
  GlassesType11 = {
    name = "Szemüveg #03",
    cat = "Szemüvegek",
    price = 8300
  },
  GlassesType12 = {
    name = "Szemüveg #04",
    cat = "Szemüvegek",
    price = 8400
  },
  GlassesType13 = {
    name = "Szemüveg #05",
    cat = "Szemüvegek",
    price = 8900
  },
  GlassesType14 = {
    name = "Szemüveg #06",
    cat = "Szemüvegek",
    price = 8540
  },
  GlassesType15 = {
    name = "Szemüveg #07",
    cat = "Szemüvegek",
    price = 8180
  },
  GlassesType16 = {
    name = "Szemüveg #08",
    cat = "Szemüvegek",
    price = 8430
  },
  GlassesType17 = {
    name = "Szemüveg #09",
    cat = "Szemüvegek",
    price = 8700
  },
  GlassesType18 = {
    name = "Szemüveg #10",
    cat = "Szemüvegek",
    price = 8650
  },
  GlassesType19 = {
    name = "Szemüveg #11",
    cat = "Szemüvegek",
    price = 8940
  },
  GlassesType2 = {
    name = "Szemüveg #12",
    cat = "Szemüvegek",
    price = 8800
  },
  GlassesType20 = {
    name = "Szemüveg #13",
    cat = "Szemüvegek",
    price = 8650
  },
  GlassesType21 = {
    name = "Szemüveg #14",
    cat = "Szemüvegek",
    price = 8780
  },
  GlassesType22 = {
    name = "Szemüveg #15",
    cat = "Szemüvegek",
    price = 8950
  },
  GlassesType23 = {
    name = "Szemüveg #16",
    cat = "Szemüvegek",
    price = 8440
  },
  GlassesType3 = {
    name = "Szemüveg #17",
    cat = "Szemüvegek",
    price = 9000
  },
  GlassesType4 = {
    name = "Szemüveg #18",
    cat = "Szemüvegek",
    price = 9050
  },
  GlassesType5 = {
    name = "Szemüveg #19",
    cat = "Szemüvegek",
    price = 8530
  },
  GlassesType6 = {
    name = "Szemüveg #20",
    cat = "Szemüvegek",
    price = 8890
  },
  GlassesType7 = {
    name = "Szemüveg #21",
    cat = "Szemüvegek",
    price = 9100
  },
  GlassesType8 = {
    name = "Szemüveg #22",
    cat = "Szemüvegek",
    price = 9050
  },
  GlassesType9 = {
    name = "Szemüveg #23",
    cat = "Szemüvegek",
    price = 8950
  },
  GlassesType24 = {
    name = "Szemüveg #24",
    cat = "Szemüvegek",
    price = 9250
  },
  v4_suitcase_black = {
    name = "Bőrönd #01",
    cat = "Táskák",
    price = 10800
  },
  v4_suitcase_brown = {
    name = "Bőrönd #02",
    cat = "Táskák",
    price = 10700
  },
  v4_suitcase_grey = {
    name = "Bőrönd #03",
    cat = "Táskák",
    price = 10340
  },
  v4_suitcase_red = {
    name = "Bőrönd #04",
    cat = "Táskák",
    price = 10540
  },
  BackPack1 = {
    name = "Hátizsák #01",
    cat = "Táskák",
    price = 10000
  },
  BackPack2 = {
    name = "Hátizsák #02",
    cat = "Táskák",
    price = 10000
  },
  BackPack3 = {
    name = "Hátizsák #03",
    cat = "Táskák",
    price = 21600
  },
  BackPack4 = {
    name = "Hátizsák #04",
    cat = "Táskák",
    price = 22300
  },
  BackPack5 = {
    name = "Hátizsák #05",
    cat = "Táskák",
    price = 21800
  },
  BackPack6 = {
    name = "Hátizsák #06",
    cat = "Táskák",
    price = 8000
  },
  SchoolPack = {
    name = "Hátizsák #07",
    cat = "Táskák",
    price = 20800
  },
  SchoolPack2 = {
    name = "Hátizsák #08",
    cat = "Táskák",
    price = 19600
  },
  SchoolPack3 = {
    name = "Hátizsák #09",
    cat = "Táskák",
    price = 21200
  },
  supreme_backpack_red = {
    name = "Hátizsák #11",
    cat = "Táskák",
    price = 41800
  },
  hasitasi = {
    name = "Nike övtáska",
    cat = "Táskák",
    price = 12000
  },
  oldaltaska = {
    name = "Oldaltáska #01",
    cat = "Táskák",
    price = 19800
  },
  v4_neckbag_black = {
    name = "Oldaltáska #02",
    cat = "Táskák",
    price = 50600
  },
  v4_sidebag_black = {
    name = "Oldaltáska #06",
    cat = "Táskák",
    price = 34800
  },
  purse_black = {
    name = "Retikül #01",
    cat = "Táskák",
    price = 31400
  },
  purse_grey = {
    name = "Retikül #02",
    cat = "Táskák",
    price = 38000
  },
  purse_red = {
    name = "Retikül #04",
    cat = "Táskák",
    price = 37600
  },
  purse_yellow = {
    name = "Retikül #05",
    cat = "Táskák",
    price = 36500
  },
  HikerBackpack1 = {
    name = "Turista felszerelés",
    cat = "Táskák",
    price = 1200
  },
  duffelbag = {
    name = "Utazó táska #01",
    cat = "Táskák",
    price = 9860
  },
  duffelbag2 = {
    name = "Utazó táska #02",
    cat = "Táskák",
    price = 10500
  },
  v4_black_casio_watch = {
    name = "Casio óra #01",
    cat = "Ékszerek",
    price = 230000
  },
  v4_black_sunglass = {
    name = "Szemüveg #26",
    cat = "Szemüvegek",
    price = 35400
  },
  v4_gold_karika_ring = {
    name = "Arany gyűrű #01",
    cat = "Ékszerek",
    price = 205000
  },
  v4_silver_black_koves_kereszt_fux = {
    name = "Nyaklánc #57",
    cat = "Ékszerek",
    price = 220000
  },
  v4_silver_blue_koves_kereszt_fux = {
    name = "Nyaklánc #58",
    cat = "Ékszerek",
    price = 220000
  },
  v4_silver_bracelet = {
    name = "Ezüst karkötő #02",
    cat = "Ékszerek",
    price = 205000
  },
  v4_silver_green_koves_kereszt_fux = {
    name = "Nyaklánc #59",
    cat = "Ékszerek",
    price = 220000
  },
  v4_silver_karika_ring = {
    name = "Ezüst gyűrű #01",
    cat = "Ékszerek",
    price = 185000
  },
  v4_silver_medium_blackruby_ring = {
    name = "Pecsétgyűrű #27",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_medium_blueruby_ring = {
    name = "Pecsétgyűrű #28",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_medium_greenruby_ring = {
    name = "Pecsétgyűrű #29",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_medium_pinkruby_ring = {
    name = "Pecsétgyűrű #30",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_medium_redruby_ring = {
    name = "Pecsétgyűrű #31",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_medium_whiteruby_ring = {
    name = "Pecsétgyűrű #32",
    cat = "Ékszerek",
    price = 175000
  },
  v4_silver_pink_koves_kereszt_fux = {
    name = "Nyaklánc #63",
    cat = "Ékszerek",
    price = 220000
  },
  v4_silver_red_koves_kereszt_fux = {
    name = "Nyaklánc #64",
    cat = "Ékszerek",
    price = 220000
  },
  v4_silver_silver_bracelet = {
    name = "Ezüst karkötő #03",
    cat = "Ékszerek",
    price = 254000
  },
  v4_silver_small_blackruby_ring = {
    name = "Pecsétgyűrű #33",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_small_blueruby_ring = {
    name = "Pecsétgyűrű #34",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_small_greenruby_ring = {
    name = "Pecsétgyűrű #35",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_small_pinkruby_ring = {
    name = "Pecsétgyűrű #36",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_small_redruby_ring = {
    name = "Pecsétgyűrű #37",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_small_whiteruby_ring = {
    name = "Pecsétgyűrű #38",
    cat = "Ékszerek",
    price = 105000
  },
  v4_silver_white_koves_kereszt_fux = {
    name = "Nyaklánc #66",
    cat = "Ékszerek",
    price = 220000
  },
  v4_weapon_sling1 = {
    name = "Fegyverszíj (1 pontos)",
    cat = "Egyéb",
    ppPrice = 300
  },
  v4_weapon_sling2 = {
    name = "Fegyverszíj (2 pontos)",
    cat = "Egyéb",
    ppPrice = 300
  },
  v4_holster = {
    name = "Pisztolytok",
    cat = "Egyéb",
    price = 10000
  },
  v4_gunbag = {
    name = "Fegyvertáska",
    cat = "Egyéb",
    price = 30000
  },
  v4_pd_sapka = {
    name = "POLICE Sapka",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 1
  },
  v4_pd_jelveny = {
    name = "POLICE jelvény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 1
  },
  v4_pd_ovjelveny = {
    name = "POLICE Övjelvény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 1
  },
  OMSZmelleny = {
    name = "OMSZ Mellény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 3
  },
  OMSZsisak = {
    name = "OMSZ Sisak",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 3
  },
  OMSZsztetoszkop = {
    name = "OMSZ Sztetoszkóp",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 3
  },
  omsz_bag = {
    name = "OMSZ Esettáska",
    cat = "Frakció kiegészítők",
    model = 9006,
    price = 0,
    group = {
      1,
      2,
      3,
      4,
      8
    }
  },
  nav_badge = {
    name = "NAV Jelvény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 8
  },
  nav_traffic_vest = {
    name = "NAV Mellény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 8
  },
  v4_tek_helmet = {
    name = "TEK sisak",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 2
  },
  v4_nni_jelveny = {
    name = "NNI jelvény",
    cat = "Frakció kiegészítők",
    price = 0,
    group = 4
  },
  v4_tek_plate = {
    name = "Golyóálló mellény TEK",
    cat = "armor",
    armorStrength = 3,
    price = 0,
    group = 2
  },
  v4_nni_vest = {
    name = "Golyóálló mellény NNI",
    cat = "armor",
    armorStrength = 3,
    price = 0,
    group = 4
  },
  armor_pd = {
    name = "Golyóálló mellény POLICE",
    cat = "armor",
    armorStrength = 3,
    price = 0,
    group = 1
  },
  armor_camo = {
    name = "Golyóálló mellény CAMO",
    cat = "armor",
    armorStrength = 3,
    price = 0,
    group = 1
  },
  armor_nav = {
    name = "NAV Mellény",
    cat = "armor",
    armorStrength = 3,
    group = 8
  },
  merkur_vest = {
    name = "NAV MERKUR Mellény",
    cat = "armor",
    armorStrength = 3,
    group = 8
  },
  v4_armor1 = {
    name = "Golyóálló mellény #1",
    cat = "armor",
    armorStrength = 1,
    price = 50000
  },
  v4_armor2 = {
    name = "Golyóálló mellény #2",
    cat = "armor",
    armorStrength = 2,
    ppPrice = 100
  },
  v4_armor3 = {
    name = "Golyóálló mellény #3",
    cat = "armor",
    armorStrength = 3,
    ppPrice = 300
  },
  v4_armor4 = {
    name = "Golyóálló mellény #4",
    cat = "armor",
    armorStrength = 4,
    ppPrice = 500
  },
}
for i in pairs(clothesList) do
  if clothesList[i].price and clothesList[i].price <= 0 then
    clothesList[i].price = nil
  end
  if clothesList[i].ppPrice and clothesList[i].ppPrice <= 0 then
    clothesList[i].ppPrice = nil
  end
end
armorList = {}
sortedClothes = {}
for cloth in pairs(clothesList) do
  if clothesList[cloth].cat == "armor" then
    if not tonumber(clothesList[cloth].armorStrength) then
      clothesList[cloth].armorStrength = 1
    end
    table.insert(armorList, cloth)
  else
    if not categories[clothesList[cloth].cat] then
      clothesList[cloth].cat = nil
    end
    table.insert(sortedClothes, cloth)
  end
end
local tableAccents = {
  ["\195\159"] = "s",
  ["\195\160"] = "a",
  ["á"] = "a",
  ["\195\162"] = "a",
  ["\195\163"] = "a",
  ["\195\164"] = "a",
  ["\195\165"] = "a",
  ["\195\166"] = "ae",
  ["\195\167"] = "c",
  ["\195\168"] = "e",
  ["é"] = "e",
  ["ë"] = "e",
  ["\195\171"] = "e",
  ["\195\172"] = "i",
  ["í"] = "i",
  ["\195\174"] = "i",
  ["\195\175"] = "i",
  ["\195\176"] = "eth",
  ["\195\177"] = "n",
  ["\195\178"] = "o",
  ["ó"] = "o",
  ["\195\180"] = "o",
  ["ó"] = "o",
  ["ö"] = "o",
  ["ő"] = "o",
  ["\195\184"] = "o",
  ["\195\185"] = "u",
  ["ú"] = "u",
  ["ű"] = "u",
  ["ü"] = "u",
  ["ű"] = "u",
  ["\195\189"] = "y",
  ["\195\190"] = "p",
  ["\195\191"] = "y"
}
function normAccent(str)
  str = utf8.lower(str)
  str = utf8.gsub(str, "[%z\001-\127\194-\244][\128-\191]*", tableAccents)
  return str
end
function clothSorter(a, b)
  local acat = catSort[clothesList[a].cat] or 9999
  local bcat = catSort[clothesList[b].cat] or 9999
  local hasPPa = clothesList[a].ppPrice and 1 or 0
  local hasPPb = clothesList[b].ppPrice and 1 or 0
  if acat ~= bcat then
    return acat < bcat
  elseif hasPPa ~= hasPPb then
    return hasPPa > hasPPb
  else
    return normAccent(clothesList[a].name) < normAccent(clothesList[b].name)
  end
end
table.sort(sortedClothes, clothSorter)
table.sort(armorList, clothSorter)
function getCat(id)
  if clothesList[id].cat then
    return clothesList[id].cat
  end
  return "Egyéb"
end
function getIcon(id)
  if clothesList[id] then
    if clothesList[id].icon then
      return clothesList[id].icon
    end
    local cat = clothesList[id].cat
    if cat and categories[cat] then
      return categories[cat].icon or "ellipsis-h"
    end
  end
  return "ellipsis-h"
end
defaultSlots = 2
slots = 10
function getSlotPrice(slot)
  if slot > defaultSlots then
    return math.min(6000, math.floor(1000 * math.pow(1.5, slot - defaultSlots - 1) / 500 + 0.5) * 500)
  end
  return 0
end
clothesShopPoses = {
  {
    1081.08203125,
    -1458.712890625,
    22.729122161865,
    0,
    0
  },
  {
    202.48300170898, -107.83995056152, 1005.1328125,
    15,
    4
  },
}
armorShopPoses = {
  {
    1081.6069335938, -1441.9387207031, 22.746402740479,
    0,
    0
  },
  {
  267.51177978516, 107.77208709717, 1004.6171875,
  10,
  8,
  },
  {
    256.11441040039, 73.957473754883, 1003.640625,
    6,
    9,
    },
  {
    267.45974731445, 107.90483856201, 1004.6171875,
    10,
    29,
  },
}
if triggerClientEvent then
  if fileExists("armors.seal") then
    fileDelete("armors.seal")
  end
  local file = fileCreate("armors.seal")
  for k, dat in pairs(clothesList) do
    if dat.armorStrength then
      fileWrite(file, k .. ";" .. dat.armorStrength .. ";" .. dat.name .. "\n")
    end
  end
  fileClose(file)
end
