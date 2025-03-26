availableItems = {
	-- [ItemID] = {Név, Leírás, Súly, Stackelhető, Fegyver ID, Töltény item ID, Eldobható, Model, RotX, RotY, RotZ, Z offset}
	[1] = {"Jármű kulcs", "Jármû kulcs, a gépjárművedhez.", 0, false, -1, -1},
	[2] = {"Lakás kulcs", "Lakáskulcs a lakásodhoz", 0, false, -1, -1},
	[3] = {"Kapu távirányító", "Távirányító egy kapuhoz", 0, false, -1, -1},
	[147] = {"Faltörő kos", "Ezzel betörheted az ingatlanok ajtaját", 0, false, -1, -1},
	[154] = {"Széf kulcs", "Kulcs egy széfhez", 0, false, -1, -1},
	[4] = {"Rádió", "Egy kis walki-talkie rádió.", 0.8, false, -1, -1},
	[5] = {"Telefon", "Egy okos telefon", 0.8, false, -1, -1},
	[6] = {"Boxer", "Kicsit nagyobb pofont lehet vele osztani.", 0.5, false, 1, -1},
	[7] = {"Vipera", "Tilhoff anyabaszó készlete.", 0.5, false, 2, -1},
	[8] = {"Gumibot", "Gumibot, tartani a rendet.", 0.8, false, 3, -1},
	[9] = {"Kés", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[280] = {"Camo knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[281] = {"Rust knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[282] = {"Carbon knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[10] = {"Baseball ütő", "Egy szép darab baseball ütő.", 1, false, 5, -1},
	[11] = {"Ásó", "Egy szép darab ásó.", 1.5, false, 6, -1},
	[12] = {"Biliárd dákó", "Egy hosszú biliárd dákó.", 0.8, false, 7, -1},
	[13] = {"Katana", "Ősi japán ereklye.", 3, false, "katana", -1},
	[14] = {"Láncfűrész", "Egy benzines motoros láncfűrész.", 2, false, 9, -1},
	[15] = {"Taser X26", "Sokkoló pisztoly", 0.25, false, "taser_x26", -1},
	[16] = {"Glock 17", "Egy Glock 17-es.", 3, false, "glock17", 341},
	[17] = {"Hangtompítós Colt 45", "Egy Colt45-ös hangtompítóval szerelve.", 3, false, "silenced", 341},
	[18] = {"Desert Eagle pisztoly", "Nagy kaliberű Desert Eagle pisztoly.", 3, false, "desert_eagle", 345},
	[272] = {"Camo Desert Eagle", "Nagy kaliberű Desert Eagle pisztoly.", 3, false, "desert_eagle", 345},
	[273] = {"Gold Desert Eagle", "Nagy kaliberű Desert Eagle pisztoly.", 3, false, "desert_eagle", 345},
	[19] = {"Sörétes puska", "Nagy kaliberű sörétes puska.", 6, false, "chromegun", 338},
	[20] = {"Rövid csövű sörétes puska", "Nagy kaliberű sörétes puska levágott csővel", 6, false, "sawnoff", 338},
	[21] = {"SPAZ-12 taktikai sörétes puska", "SPAZ-12 taktikai sörétes puska elit fegyver.", 6, false, "shotgspa", 338},
	[22] = {"Uzi", "Uzi géppisztoly.", 3, false, "micro_uzi", 349},
	[283] = {"Bronze UZI", "Uzi géppisztoly.", 3, false, "micro_uzi", 349},
	[284] = {"Camo UZI", "Uzi géppisztoly.", 3, false, "micro_uzi", 349},
	[285] = {"Gold UZI", "Uzi géppisztoly.", 3, false, "micro_uzi", 349},
	[286] = {"Winter UZI", "Uzi géppisztoly.", 3, false, "micro_uzi", 349},
	[115] = {"Hi-fi", "", 0.8, false, -1, -1},
	[23] = {"MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[24] = {"TEC-9", "TEC-9-es gépfegyver.", 3, false, "tec9", 349},
	[25] = {"AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[26] = {"M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[265] = {"Winter AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[266] = {"Camo AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[267] = {"Digit AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[268] = {"Gold AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[269] = {"Gold AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[270] = {"Silver AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[271] = {"Hello AK-47", "AK-47-es gépfegyver.", 5, false, "ak-47", 346},
	[27] = {"Vadász puska", "Vadász puska a pontos és határozott lövéshez.", 6, false, "rifle", 348},
	[28] = {"Remington 700", "Remington 700-as puska.", 6, false, "sniper", 348},
	[276] = {"Camo MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[277] = {"Gold MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[278] = {"Hotline Miami MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[279] = {"Winter MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[29] = {"Flamethrower", "Flamethrower.", 1.23, false, 37, -1},
	[30] = {"Flashbang", "Flashbang", 0.5, false, 16, -1},
	[31] = {"Füst gránát", "Füst gránát a tökéletes taktikai fegyver.", 0.54, false, 17, -1},
	[32] = {"Molotov koktél", "Molotov koktél.", 1.23, false, 18, -1},
	[33] = {"Spray kanna", "Spray kanna.", 0.3, false, 41, 34},
	[34] = {"Festék patron", "Festék patron fújós spayekhez", 0.001, true, -1, -1},
	[35] = {"Poroltó", "Poroltó", 0.001, false, 42, 98},

	[36] = {"Csákány", "Csákány", 1.23, false, 15, -1},
	[37] = {"Balta", "Balta", 1.23, false, 10, -1},
	[38] = {"Bárd", "Bárd.", 1.23, false, 12, -1},
	[39] = {"Virágok", "Egy csokor virág.", 0.3, false, 14, -1},
	[40] = {"Sétapálca", "Sétapálca.", 0.2, false, 15, -1},
	[41] = {"Ejtőernyő", "Ejtőernyő.", 2.23, false, 46, -1},

	[42] = {"(outdated)5x9mm-es töltény", "Colt45, Desert 5x9mm-es töltény", 0.001, true, -1, -1},
	[43] = {"(outdated)AK47-es töltény", "AK47-es töltény", 0.001, true, -1, -1},
	[44] = {"(outdated)Vadászpuska töltény", "Hosszú Vadászpuska töltény", 0.001, true, -1, -1},
	[45] = {"(outdated)Kis gépfegyver töltények", "Kis gépfegyver töltények (UZI,MP5)", 0.001, true, -1, -1},
	[46] = {"(outdated)M4-es gépfegyver töltény", "M4-es gépfegyver töltény", 0.001, true, -1, -1},
	[47] = {"(outdated)Sörétes töltény", "Sörétes töltény", 0.001, true, -1, -1},

	[48] = {"Bilincs", "Bilincs", 0.8, false, -1, -1},
	[49] = {"Bilincskulcs", "Bilincskulcs", 0.005, false, -1, -1},
	[50] = {"Széf kulcs", "Széf kulcs", 0, false, -1, -1},

	[51] = {"Instant Fix Kártya", "Amikor egy isteni erő újjáéleszti az autódat, amiben ülsz.", 0, true, -1, -1},
	[52] = {"Instant Üzemanyag Kártya", "S lőn, teli a tank, ha a kocsiba ülsz.", 0, true, -1, -1},
	[53] = {"Instant Gyógyítás", "S lőn, egy isteni csoda felsegít téged.", 0, true, -1, -1},

	[54] = {"A fegyvermester: Glock 17", "", 1, false, -1, -1},
	[55] = {"A fegyvermester: Glock 17, Colt-45, USP-S, Five-Seven", "", 1, false, -1, -1},
	[56] = {"A fegyvermester: Desert Eagle, Colt Python, Colt Anaconda, Taser X26", "", 1, false, -1, -1},
	[57] = {"A fegyvermester: UZI & TEC-9", "", 1, false, -1, -1},
	[58] = {"A fegyvermester: MP5, Galil Ace, Colt MK18, AK-47 (DRUM), MP7, Vector Kriss, P90", "", 1, false, -1, -1},
	[59] = {"A fegyvermester: AK-47, AK-74, AK-47 (Tus nélkül)", "", 1, false, -1, -1},
	[60] = {"A fegyvermester: M4, Beretta 160, M4A1, HK416, MK18", "", 1, false, -1, -1},
	[61] = {"A fegyvermester: Vadász-Mesterlövész puska", "", 1, false, -1, -1},
	[62] = {"A fegyvermester: Sörétes puska", "", 1, false, -1, -1},
	[63] = {"A fegyvermester: Taktikai sörétes puska", "", 1, false, -1, -1},

 	[64] = {"Bankkártya", "", 0.1, false, -1, -1},
	[373] = {"Kutya nyakörv", "", 0.1, false, -1, -1},
 	[65] = {"Személyi igazolvány", "", 0.1, false, -1, -1},
 	[66] = {"Horgászengedély", "", 0.1, false, -1, -1},
 	[67] = {"Útlevél", "", 0.1, false, -1, -1},
 	[68] = {"Jogosítvány", "", 0.1, false, -1, -1},
 	[69] = {"Üres adásvételi", "", 0.1, false, -1, -1},
 	[70] = {"Adásvételi", "", 0.1, false, -1, -1},
	[71] = {"Jegyzetfüzet", "", 0.1, false, -1, -1},
	[72] = {"Füzetlap", "", 0.1, false, -1, -1},
	[73] = {"Toll", "", 0.1, false, -1, -1},
	[148] = {"Gyógyszer", "", 0.1, false, -1, -1},
	[149] = {"Vitamin", "", 0.1, false, -1, -1},
	[206] = {"Jelvény", "", 0.1, false, -1, -1},
	[207] = {"Hello Kitty Desert Eagle", "Nagy kaliberű Desert Eagle pisztoly.", 3, false, "desert_eagle", 345},
	[74] = {"Számla", "", 0.1, false, -1, -1},
	[75] = {"Fegyverviselési engedély", "", 0.1, false, -1, -1},
	[76] = {"A fegyvermester: A lefűrészelt sörétes", "Az alábbi könyv elolvasásával az adott fegyver mesterévé válhatsz", 1, false, -1, -1},
	[77] = {"Sajtospogácsa", "Sajtospogácsa", 0.2, true, -1, -1},
	[78] = {"Krémes", "Krémes", 0.2, true, -1, -1},
	[79] = {"Alma", "Egy szép piros alma.", 0.2, true, -1, -1},
	[80] = {"Narancs", "Egy kis vitamin a szervezetbe!", 0.2, true, -1, -1},
	[81] = {"Sült marhahús", "Steak.", 0.2, true, -1, -1},
	[82] = {"Fajita", "Fajita.", 0.2, true, -1, -1},
	[83] = {"Duplahúsos hamburger", "Hambi :')", 0.2, false, -1, -1},
	[84] = {"Bacon burger", "Hambi :')", 0.2, false, -1, -1},
	[85] = {"Hagymás Hotdog", "Hotdog :')", 0.2, false, -1, -1},
	[86] = {"Hotdog", "Hotdog :')", 0.2, false, -1, -1},
	[87] = {"Sült csirkehús", "Steak.", 0.2, true, -1, -1},
	[88] = {"Banán", "Gyümölcs.", 0.2, true, -1, -1},
	[89] = {"Eper", "Gyümölcs.", 0.2, true, -1, -1},
	[90] = {"Áfonya", "Gyümölcs.", 0.2, true, -1, -1},
	[91] = {"Mirinda szelet", "Sütemény.", 0.2, true, -1, -1},
	[92] = {"Víz", "Egy hűsítő ital.", 0.2, true, -1, -1},
	[93] = {"Redbull Energy", "Nem egészséges lötty.", 0.2, true, -1, -1},
	[94] = {"Monster Energy", "Nem egészséges lötty.", 0.2, true, -1, -1},
	[95] = {"Hell Energy", "Nem egészséges lötty.", 0.2, true, -1, -1},
	[96] = {"Kávé", "Szar koffeinos lötty.", 0.2, true, -1, -1},
	[97] = {"Cappuccino", "Szar koffeinos lötty.", 0.2, true, -1, -1},

	[98] = {"Antenna", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[99] = {"Ventillátor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[100] = {"Tranzisztor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[101] = {"NYÁK", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[102] = {"Mikroprocesszor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[103] = {"Mini kijelző", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[104] = {"Mikrofon", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[105] = {"Elemlámpa LED", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[106] = {"Kondenzátor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[107] = {"Hangszóró", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[108] = {"Nyomógomb", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[109] = {"Ellenállás", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[110] = {"Elem", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[111] = {"Műanyag doboz", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[112] = {"Walkie Talkie", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[113] = {"Tápegység", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[114] = {"Számológép", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[116] = {"Elemlámpa", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[117] = {"Diktafon", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1, true},
	[118] = {"Flex", "", 0.5, false, -1, -1},
	[119] = {"Pénzkazetta", "", 0.02, false, -1, -1},
	[120] = {"Kalapács", "", 0.3, false, -1, -1},
	[121] = {"Véső", "", 0.2, false, -1, -1},
	[122] = {"Fuvarlevél", "", 0, false, -1, -1},
	[123] = {"Kioperált golyo", "", 0.1, false, -1, -1},
	[124] = {"Tű", "", 0.1, false, -1, -1},
	[125] = {"Csipesz", "", 0.1, false, -1, -1},
	[126] = {"Döglött hal", "", 0.1, false, -1, -1},
	[131] = {"Taxilámpa", "", 0.1, false, -1, -1},
	[132] = {"Taxilámpa", "", 0.1, false, -1, -1},
	[135] = {"Csekkfüzet", "", 0.2, false, -1, -1},
	[136] = {"Csekk", "", 0.1, false, -1, -1},
	[133] = {"Dragon MP5", "Egyedi fegyver", 3, false, "mp5lng", 349},
	[134] = {"M4 Black Ice", "Egyedi fegyver", 5, false, "m4", 46},
	[177] = {"Cső és előágy", "Fegyver alkatrész", 0.1, false, -1, -1},
	[178] = {"Előágy felső része", "Fegyver alkatrész", 0.1, false, -1, -1},
	[179] = {"Elsütőszerkezet és tus", "Fegyver alkatrész", 0.1, false, -1, -1},
	[180] = {"Nézőke", "Fegyver alkatrész", 0.1, false, -1, -1},
	[181] = {"Tár", "Fegyver alkatrész", 0.1, false, -1, -1},
	[182] = {"Tok", "Fegyver alkatrész", 0.1, false, -1, -1},
	[183] = {"Alsó rész", "Fegyver alkatrész", 0.1, false, -1, -1},
	[184] = {"Felső rész", "Fegyver alkatrész", 0.1, false, -1, -1},
	[185] = {"Markolat", "Fegyver alkatrész", 0.1, false, -1, -1},
	[186] = {"Ravasz", "Fegyver alkatrész", 0.1, false, -1, -1},
	[187] = {"Tár", "Fegyver alkatrész", 0.1, false, -1, -1},
	[188] = {"Cső", "Fegyver alkatrész", 0.1, false, -1, -1},
	[189] = {"Pumpáló", "Fegyver alkatrész", 0.1, false, -1, -1},
	[190] = {"Ravasz és tok", "Fegyver alkatrész", 0.1, false, -1, -1},
	[191] = {"Tus", "Fegyver alkatrész", 0.1, false, -1, -1},
	[192] = {"Cső", "Fegyver alkatrész", 0.1, false, -1, -1},
	[193] = {"Ravasz és markolat", "Fegyver alkatrész", 0.1, false, -1, -1},
	[194] = {"Tok", "Fegyver alkatrész", 0.1, false, -1, -1},
	[195] = {"Tus", "Fegyver alkatrész", 0.1, false, -1, -1},
	[196] = {"Markolat", "Fegyver alkatrész", 0.1, false, -1, -1},
	[197] = {"Penge", "Fegyver alkatrész", 0.1, false, -1, -1},
	[198] = {"Tár", "Fegyver alkatrész", 0.1, false, -1, -1},
	[199] = {"Markolat", "Fegyver alkatrész", 0.1, false, -1, -1},
	[200] = {"Cső", "Fegyver alkatrész", 0.1, false, -1, -1},
	[201] = {"Felső rész", "Fegyver alkatrész", 0.1, false, -1, -1},
	[202] = {"Felső rész", "Fegyver alkatrész", 0.1, false, -1, -1},
	[203] = {"Gyémánt", "Egy értékes drágakő", 0.3, false, -1, -1},
	[204] = {"Rubin drágakő", "Egy értékes drágakő", 0.3, false, -1, -1},

	[291] = {"Villogó", "", 0.1, false, -1, -1},
	[292] = {"Villogó", "", 0.1, false, -1, -1},

	[350] = {"Névcédula", "", 0.1, false, -1, -1},
	[163] = {"PPsnack", "", 0.1, false, -1, -1},
	[160] = {"Jutalom falat", "", 0.1, false, -1, -1},
	[161] = {"Kutya táp", "", 0.1, false, -1, -1},
	[162] = {"Kutya snack", "", 0.1, false, -1, -1},
	[163] = {"Láda", "", 0.1, false, -1, -1},
	[164] = {"Láda (Arany)", "", 0.1, false, -1, -1},
	[165] = {"Láda (Boost)", "", 0.1, false, -1, -1},
	--[166] = {"BMW M4 G82 kulcs", "", 0.1, false, -1, -1},
	[167] = {"BMW M5 F90 Competition kulcs", "", 0.1, false, -1, -1},
	--[168] = {"Dodge Demon SRT kulcs", "", 0.1, false, -1, -1},
	--[169] = {"Mercedes-Benz G63 kulcs", "", 0.1, false, -1, -1},
	-- [170] = {"10.000.000 PP", "", 0.1, false, -1, -1},
	-- [171] = {"30.000.000 PP", "", 0.1, false, -1, -1},
	-- [172] = {"50.000.000 PP", "", 0.1, false, -1, -1},
	-- [173] = {"Maverick (helikopter) kulcs", "", 0.1, false, -1, -1},
	-- [174] = {"Ferrari 488 Pista kulcs", "", 0.1, false, -1, -1},
	-- [175] = {"2.000.000 PP", "", 0.1, false, -1, -1},
	[376] = {"Fémdetektor", "", 2, false, -1, -1},
	[377] = {"Arany óra", "Fődes lút", 0.15, false, -1, -1},
	[378] = {"Üres háborús lőszer", "Fődes lút", 1.5, false, -1, -1},
	[379] = {"Antik étkészlet", "Fődes lút", 0.75, false, -1, -1},
	[380] = {"Kehely", "Fődes lút", 0.5, false, -1, -1},
	[381] = {"Kereszt", "Fődes lút", 0.125, false, -1, -1},
	[382] = {"Aranylánc", "Fődes lút", 0.05, false, -1, -1},
	[383] = {"Aranymedál", "Fődes lút", 0.25, false, -1, -1},
	[384] = {"Antik pénz", "Fődes lút", 0.01, false, -1, -1},
	[385] = {"Antik tányér", "Fődes lút", 0.5, false, -1, -1},
	[386] = {"Üdítős doboz", "Fődes lút", 0.01, false, -1, -1},
	[387] = {"Antik törzsi maszk", "Fődes lút", 2, false, -1, -1},
	[156] = {"Ajándék", "", 0.2, false, -1, -1},

	[137] = {"Tiger Knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[138] = {"Digit Knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[139] = {"Spider Knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[140] = {"Galaxy Knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},
	[141] = {"Hello Kitty Knife", "Egy fegyvernek minősülő kés.", 0.8, false, "knifecur", -1},

	[142] = {"Camo M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[143] = {"Digit M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[144] = {"Gold M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[145] = {"Gold M4 (ver. 2)", "M4-es gépfegyver.", 5, false, "m4", 343},
	[146] = {"Hello Kitty M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[151] = {"Dragon King M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[152] = {"Howl M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	--[153] = {"Paint M4", "M4-es gépfegyver.", 5, false, "m4", 46},
	[155] = {"Rose M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[157] = {"Rust M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[158] = {"Silver M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[159] = {"Wandal M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	[176] = {"Winter M4", "M4-es gépfegyver.", 5, false, "m4", 343},
	
	[208] = {"Hello Kitty MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	[209] = {"Rose MP5", "MP5-ös fegyver.", 3, false, "mp5lng", 349},
	
	[210] = {"Horgászbot", "Kész horgászbot", 1.1, false, -1, -1},
	
	[214] = {"Camo Shotgun", "Nagy kaliberű sörétes puska.", 6, false, "chromegun", 338},
	[215] = {"Gold Shotgun", "Nagy kaliberű sörétes puska.", 6, false, "chromegun", 338},
	[216] = {"Rust Shotgun", "Nagy kaliberű sörétes puska.", 6, false, "chromegun", 338},
	
	--[217] = {"Halloween USP-S", "Egy Colt45-ös hangtompítóval szerelve.", 3, false, "silenced", 42},
	--[218] = {"Camo USP-S", "Egy Colt45-ös hangtompítóval szerelve.", 3, false, "silenced", 42},
	[219] = {"Gold USP-S", "Egy Colt45-ös hangtompítóval szerelve.", 3, false, "silenced", 341},
	[220] = {"Hello Kitty USP-S", "Egy Colt45-ös hangtompítóval szerelve.", 3, false, "silenced", 341},
	
	[221] = {"Winter Sniper", "Remington 700-as puska.", 6, false, "sniper", 348},
	[222] = {"Camo Sniper", "Remington 700-as puska.", 6, false, "sniper", 348},
	[223] = {"Gold Sniper", "Remington 700-as puska.", 6, false, "sniper", 348},
	[224] = {"Hello Kitty Sniper", "Remington 700-as puska.", 6, false, "sniper", 348},
	
	[225] = {"Gravity Gun", "apád trakoron", 0.5, false, -1, -1},

	[226] = {"Szamuráj rák", "Szamuráj rák", 0.5, false, -1, -1},
	[227] = {"Lepényhal", "Lepényhal", 1, false, -1, -1},
	[228] = {"Sügér", "Sügér", 2, false, -1, -1},
	[229] = {"Harcsa", "Harcsa", 2, false, -1, -1},
	[230] = {"Ponty", "Ponty", 2, false, -1, -1},
	[231] = {"Tengericsillag", "Tengericsillag", 0.2, false, -1, -1},
	[232] = {"Szárított marihuana", "Szárított marihuana.", 0.001, true, -1, -1},
	[246] = {"Púpos horgászhal", "Púpos horgászhal", 1, false, -1, -1},
	[247] = {"Antik láda", "Antik láda", 1, false, -1, -1},
	[248] = {"Rák", "Rák", 0.5, false, -1, -1},
	[249] = {"Szakadt halászhaló", "Szakadt halászhaló", 0.5, false, -1, -1},
	[250] = {"Óriáspolip", "Óriáspolip", 5, false, -1, -1},
	[251] = {"Pörölycápa", "Pörölycápa", 4, false, -1, -1},
	[252] = {"Koi ponty", "Koi ponty", 2, false, -1, -1},
	[254] = {"Antik szobor", "Antik szobor", 2, false, -1, -1},
	[255] = {"Piranha", "Piranha", 0.5, false, -1, -1},
	[256] = {"Gömbhal", "Gömbhal", 0.5, false, -1, -1},
	[257] = {"Rozsdás vödör", "Rozsdás vödör", 0.5, false, -1, -1},
	[258] = {"Törött deszka", "Törött deszka", 1, false, -1, -1},
	[259] = {"Cápafog nyaklác", "Cápafog nyaklác", 0.1, false, -1, -1},
	[260] = {"Koponya", "Koponya", 2, false, -1, -1},
	[261] = {"Teknős", "Teknős", 2, false, -1, -1},
	[363] = {"Prémium hal", "PP HAL", 1, false, -1, -1},
	
	[351] = {"Barracuda", "Barracuda", 2.5, false, -1, -1},
	[352] = {"Mahi Mahi", "Mahi Mahi", 3, false, -1, -1},
	[353] = {"Makréla", "Makréla", 1.5, false, -1, -1},
	[354] = {"Pávahal", "Pávahal", 2, false, -1, -1},
	[355] = {"Rája", "Rája", 4, false, -1, -1},
	[356] = {"Piros Snapper", "Piros Snapper", 1, false, -1, -1},
	[357] = {"Kakashal", "Kakashal", 3, false, -1, -1},
	[358] = {"Szakadt damil", "Szakadt damil", 0.1, false, -1, -1},
	[359] = {"Kék tonhal", "Kék tonhal", 3, false, -1, -1},
	[360] = {"Viperahal", "Viperahal", 1, false, -1, -1},
	
	[153] = {"Strandlabda", "", 0.2, false, -1, -1},
	
	[150] = {"Esettáska", "ads", 2, false, -1, -1},
	
	[205] = {"OBD scanner", "OBD scanner", 0.8, false, -1, -1},
	[288] = {"Műszaki adatlap", "Műszaki adatlap", 0.1, false, -1, -1},
	[289] = {"Forgalmi engedély", "Forgalmi engedély", 0.1, false, -1, -1},
	
	[300] = {"Őszi falevél", "Őszi színekben pompázó falevél", 0.1, false, -1, -1},
	[301] = {"Wumpus ajándéka", "igen nem igen nem nem", 0.1, false, -1, -1},
	[302] = {"Füves cigi", "Füves cigaretta.", 0.1, true, -1, -1},
	[303] = {"Kokain", "Kokain.", 0.1, true, -1, -1},
	[304] = {"Heroinos fecskendő", "Heroinos fecskendő.", 0.1, true, -1, -1},
	[305] = {"Parazeldum por", "Parazeldum por.", 0.1, true, -1, -1},

	[306] = {"Beretta ARX160 (Laser)", "customweapon", 4.5, false, "beretta160laser", 343},
	[307] = {"Galil Ace (Laser)", "customweapon", 3.5, false, "galilacelaser", 343},
	[308] = {"MK14 Sniper", "customweapon", 6.4, false, "springmk14", 348},
	[309] = {"M4A1 ACOG", "customweapon", 4.0, false, "m4a1cog", 343},
	[310] = {"MK18", "customweapon", 3.5, false, "coltmk18deadshot", 343},
	[311] = {"Colt Python", "customweapon", 1.3, false, "coltpython", 339},
	[312] = {"Colt Anaconda", "customweapon", 1.5, false, "coltanaconda", 339},
	[313] = {"HK416 (EOTech, Laser)", "customweapon", 4.0, false, "hk416eotechlaser", 343},
	[314] = {"AK-47 (Round Drum Magazine)", "customweapon", 3.0, false, "ak47_v2", 346},
	[315] = {"AK-47 (Tus nélkül)", "customweapon", 3.5, false, "ak47_v3", 346},
	[316] = {"Dragunov PSL", "customweapon", 5.3, false, "dragunov_psl", 348},
	[317] = {"Tactical M4", "customweapon", 3.8, false, "m4_tactical", 343},
	[318] = {"MP7", "customweapon", 2.0, false, "mp7", 340},
	[319] = {"HK416 (HOLO, Laser)", "customweapon", 4.0, false, "hk416setup", 343},
	[320] = {"MK18 SOPMOD", "customweapon", 3.8, false, "mk18sopmod", 343},
	[321] = {"AK-47 (Laser)", "customweapon", 4.0, false, "akgp", 346},
	[322] = {"AK-74M", "customweapon", 3.4, false, "ak74m", 342},
	[323] = {"AK-74M WOOD", "customweapon", 3.5, false, "ak74m_wood", 342},
	[324] = {"Castellano CQC-11", "customweapon", 4.4, false, "cqc11", 338},
	[325] = {"Five-Seven (Laser)", "customweapon", 0.8, false, "fiveseven_laser", 344},
	[326] = {"Kriss Vector", "customweapon", 2.7, false, "vectorkriss", 349},
	[327] = {"Pump Shotgun", "customweapon", 3.0, false, "pumpshotgun", 338},
	[328] = {"Vipera", "customweapon", 0.6, false, "vipera", -1},
	[329] = {"Balta", "customweapon", 1.2, false, "axe", -1},
	[330] = {"Kalapács", "customweapon", 0.4, false, "hammer", -1},
	[331] = {"P90", "customweapon", 3.0, false, "p90", 344},
	[332] = {"Csákány", "customweapon", 1.5, false, "pickaxe", -1},
	[333] = {"Csőkulcs", "customweapon", 1.2, false, "pipe_wrench", -1},
	--[334] = {"Taser X26", "customweapon", 0.1, false, "taser_x26", 46},
	--[335] = {"Glock 17", "customweapon", 0.1, false, "glock17", 46},
	[336] = {"Nikon D600", "Egy fényképezőgép.", 0.4, false, 43, -1},
	[337] = {"Tök", "Egy halloweeni tök.", 0.5, false, -1, -1},

	[338] = {"12 GAUGE", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[339] = {".357 MAGNUM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[340] = {"4.6X30MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[341] = {".45 ACP", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[342] = {"5.45X39MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[343] = {"5.56X45MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[344] = {"5.7X28MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[345] = {".50 AE", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[346] = {"7.62X39MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[347] = {"7.62X51MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[348] = {"7.62X54MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[349] = {"9X19MM", "Egy halloweeni tök.", 0.001, true, -1, -1},
	[361] = {"Armor kártya", "Egy kártya ami valamilyen csodával feltölti armorod.", 1, true, -1, -1},

	[400] = {"Antenna", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[401] = {"Ventillátor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[402] = {"Tranzisztor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[403] = {"NYÁK", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[404] = {"Mikroprocesszor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[405] = {"Mini kijelző", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[406] = {"Mikrofon", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[407] = {"Elemlámpa LED", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[408] = {"Kondenzátor", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[409] = {"Hangszóró", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[410] = {"Nyomógomb", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[411] = {"Ellenállás", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[412] = {"Elem", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[413] = {"Műanyag doboz", "Alkatrész az elektronikai gyárban", 0.1, false, -1, -1},
	[414] = {"Walkie Talkie", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[415] = {"Tápegység", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[416] = {"Számológép", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[417] = {"Rádió", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[418] = {"Elemlámpa", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[419] = {"Diktafon", "Kész termék az elektronikai gyárban", 0.1, false, -1, -1},
	[420] = {"Piszkos pénz", "", 0.1, false, -1, -1},
	[421] = {"Vehicle case", "", 0.1, false, -1, -1},
	
	[422] = {"M4A1", "customweapon", 4.0, false, "m4a1", 343},
	[423] = {"M4A1 Camo", "customweapon", 4.0, false, "m4a1camo", 343},
	[424] = {"M4A1 Tan", "customweapon", 4.0, false, "m4a1tan", 343},
	[425] = {"M4A1 USA", "customweapon", 4.0, false, "m4a1usa", 343},
	[426] = {"M4A1 X-MAS", "customweapon", 4.0, false, "m4a1xmas", 343},
	
	[427] = {"AR-15", "customweapon", 4.0, false, "m4ar15", 343},
	
	[428] = {"M110 Sniper", "customweapon", 6.4, false, "m110", 348},
	[429] = {"M110 Sniper Tan", "customweapon", 6.4, false, "m110tan", 348},
	[430] = {"Cigaretta", "", 0.01, false, -1, -1},
	[431] = {"M4A1 Spring", "customweapon", 4.0, false, "m4a1spring", 343},
	[432] = {"Kitűző", "", 0.1, false, -1, -1},
	[433] = {"Bónusztojás", "", 1, false, -1, -1},
	[434] = {"Csokitojás", "", 0.1, true, -1, -1},
	[435] = {"Záptojás", "", 0.1, true, -1, -1},
	[436] = {"Treasure chest", "Láda", 2, false, -1, -1},
	[437] = {"Mystery chest", "Láda", 2, false, -1, -1},
	[438] = {"Fegyverhajó térkép", "Térkép", 0.1, false, -1, -1},

	[439] = {"Sör", "Térkép", 0.1, true, -1, -1},
	[440] = {"Whiskey", "Térkép", 0.1, true, -1, -1},
	[441] = {"Pálinka", "Térkép", 0.1, true, -1, -1},
	[442] = {"Fishing Chest", "Térkép", 0.1, false, -1, -1},
	[443] = {"Pirate Chest", "Térkép", 0.1, false, -1, -1},
	[444] = {"Jelző háromszög", "Háromszög", 0.1, false, -1, -1},

	[445] = {"SealRod 2000", "rod:0", 0.1, false, -1, -1},
	[446] = {"SealRod 3000", "rod:1", 0.1, false, -1, -1},
	[447] = {"SealRod 4000", "rod:2", 0.1, false, -1, -1},
	[448] = {"SealRod 5000", "rod:3", 0.1, false, -1, -1},
	[449] = {"SealRod 6000", "rod:4", 0.1, false, -1, -1},

	[450] = {"Csali", "bait", 0.1, true, -1, -1},

	[451] = {"Bézs Damil", "line", 0.1, false, -1, -1},
	[452] = {"Zöld Damil", "line", 0.1, false, -1, -1},
	[453] = {"Fehér Damil", "line", 0.1, false, -1, -1},
	[454] = {"Piros Damil", "line", 0.1, false, -1, -1},
	[455] = {"Sárga Damil", "line", 0.1, false, -1, -1},
	[456] = {"Rózsaszín Damil", "line", 0.1, false, -1, -1},
	[457] = {"Kék Damil", "line", 0.1, false, -1, -1},

	[458] = {"Úszó 1", "floater", 0.1, false, -1, -1},
	[459] = {"Úszó 2", "floater", 0.1, false, -1, -1},
	[460] = {"Úszó 3", "floater", 0.1, false, -1, -1},

	[461] = {"Makréla", "fish", 0.1, false, -1, -1},
	[462] = {"Keményfejű harcsa", "fish", 0.1, false, -1, -1},
	[463] = {"Csattogóhal", "fish", 0.1, false, -1, -1},
	[464] = {"Sárgafarkú csattogóhal", "fish", 0.1, false, -1, -1},
	[465] = {"Legendary Csattogóhal", "fish", 0.1, false, -1, -1},
	[466] = {"Vörös lazac", "fish", 0.1, false, -1, -1},
	[467] = {"Rózsaszín lazac", "fish", 0.1, false, -1, -1},
	[468] = {"Kékúszójú tonhal", "fish", 0.1, false, -1, -1},
	[469] = {"Sárgaúszójú tonhal", "fish", 0.1, false, -1, -1},
	[470] = {"Kakashal", "fish", 0.1, false, -1, -1},
	[471] = {"Legendary Kakashal", "fish", 0.1, false, -1, -1},
	[472] = {"Kardhal", "fish", 0.1, false, -1, -1},
	[473] = {"Mahi-mahi", "fish", 0.1, false, -1, -1},
	[474] = {"Legendary Mahi-mahi", "fish", 0.1, false, -1, -1},
	[475] = {"Makócápa", "fish", 0.1, false, -1, -1},
	[476] = {"Tigriscápa", "fish", 0.1, false, -1, -1},
	[477] = {"Fehér cápa", "fish", 0.1, false, -1, -1},
	[478] = {"Legendary Fehér cápa", "fish", 0.1, false, -1, -1},

	[479] = {"Kagyló igazgyönggyel", "fish", 0.1, false, -1, -1},
	[480] = {"Üres kagyló", "fish", 0.1, false, -1, -1},
	[481] = {"Igazgyöngy", "fish", 0.1, false, -1, -1},
	[482] = {"Elsősegély doboz", "EÜ", 1, false, -1, -1},
}

for i = 1, 1000 do
	if not availableItems[i] then
		availableItems[i] = {"INVALID ITEM", "", 0.1, false, -1, -1}
	end
end

fishItems = {
	[461] = "v4_fish_mackerel",
	[462] = "v4_fish_hardheadcatfish",
	[463] = "v4_fish_snapper",
	[464] = "v4_fish_yellowtailsnapper",
	[465] = "v4_fish_snapper_leg",
	[466] = "v4_fish_redsalmon",
	[467] = "v4_fish_pinksalmon",
	[468] = "v4_fish_tunabluefin",
	[469] = "v4_fish_tunayellowfin",
	[470] = "v4_fish_rooster",
	[471] = "v4_fish_rooster_leg",
	[472] = "v4_fish_swordfish",
	[473] = "v4_fish_mahi",
	[474] = "v4_fish_mahi_leg",
	[475] = "v4_fish_makoshark",
	[476] = "v4_fish_tigershark",
	[477] = "v4_fish_greatwhite",
	[478] = "v4_fish_greatwhite_leg",
}

fishingLines = {
	[451] = 1,
	[452] = 2,
	[453] = 3,
	[454] = 4,
	[455] = 5,
	[456] = 6,
	[457] = 7,
}

fishingFloaters = {
	[458] = 1,
	[459] = 2,
	[460] = 3,
}

fishingRods = {
	[445] = 0,
	[446] = 1,
	[447] = 2,
	[448] = 3,
	[449] = 4,
}

scratchItems = {}

function resourceStart(res)
	for i = 1, 419 do
		if not availableItems[i] then
			availableItems[i] = {"Szabad hely", "nem létezik szóval ne addold", 0.1, false, -1, -1}
		end
	end
	if getResourceName(res) == "seal_lottery" then
		scratchItems = exports.seal_lottery:getScratchItems()
	else
		if source == resourceRoot then
			local seal_lottery = getResourceFromName("seal_lottery")

			if seal_lottery and getResourceState(seal_lottery) == "running" then
				scratchItems = exports.seal_lottery:getScratchItems()
			end
		end
	end
end
addEventHandler("onResourceStart", root, resourceStart)
addEventHandler("onClientResourceStart", root, resourceStart)

function getWeaponNameFromIDNew(id)
	if id == 16 then
		return "Glock-17"
	elseif id == 23 then
		return "MP5"
	elseif id == 28 then
		return "Remington 700"
	elseif id == 27 then
		return "Vadászpuska"
	else
		return getWeaponNameFromID(id)
	end
end

specialItems = {
	[83] = {"hamburger", 5},
	[84] = {"hamburger", 5},
	[85] = {"hamburger", 5},
	[86] = {"kebab", 5},
	[92] = {"drink", 5},
	[93] = {"drink", 5},
	[94] = {"drink", 5},
	[95] = {"drink", 5},
	[96] = {"drink", 5},
	[97] = {"drink", 5},
	[302] = {"drug", 10},
	[303] = {"drug", 10},
	[304] = {"drug", 10},
	[305] = {"drug", 10},
	[430] = {"cigarette", 20},
	[439] = {"alcohol", 5},
	[440] = {"alcohol", 5},
	[441] = {"alcohol", 5},
}

copyableItems = {
	[65] = true,
	[66] = true,
	[67] = true,
	[68] = true,
	[72] = true,
	[75] = true,
}

ticketGroups = {
	army = {"Szabad rendvédelmi frakció", 21},
	nav = {"Las Venturas Sheriff Department", 13},
	pd = {"Las Venturas Police Department", 1},
	tek = {"Special Weapons And Tactics", 26},
	nni = {"Federal Bureau of Investigation", 12}
}

perishableItems = {
	[136] = 420,
	[461] = 600,
	[462] = 600,
	[463] = 600,
	[464] = 600,
	[465] = 600,
	[466] = 600,
	[467] = 600,
	[468] = 600,
	[469] = 600,
	[470] = 600,
	[471] = 600,
	[472] = 600,
	[473] = 600,
	[474] = 600,
	[475] = 600,
	[476] = 600,
	[477] = 600,
	[478] = 600,
}

perishableEvent = {
	[136] = "ticketPerishableEvent",
	[461] = "fishPerishableEvent",
	[462] = "fishPerishableEvent",
	[463] = "fishPerishableEvent",
	[464] = "fishPerishableEvent",
	[465] = "fishPerishableEvent",
	[466] = "fishPerishableEvent",
	[467] = "fishPerishableEvent",
	[468] = "fishPerishableEvent",
	[469] = "fishPerishableEvent",
	[470] = "fishPerishableEvent",
	[471] = "fishPerishableEvent",
	[472] = "fishPerishableEvent",
	[473] = "fishPerishableEvent",
	[474] = "fishPerishableEvent",
	[475] = "fishPerishableEvent",
	[476] = "fishPerishableEvent",
	[477] = "fishPerishableEvent",
	[478] = "fishPerishableEvent",
}

for k, v in pairs(perishableItems) do
	availableItems[k][4] = false
end

weaponSkins = {
	[265] = 1,
	[266] = 2,
	[267] = 3,
	[268] = 4,
	[269] = 5,
	[270] = 6,
	[271] = 7,
	[272] = 1,
	[273] = 2,
	[207] = 3,
	[274] = 1,
	[275] = 2,
	[276] = 1,
	[277] = 2,
	[278] = 3,
	[279] = 4,
	[340] = 5,
	[341] = 6,
	[346] = 7,
	[347] = 8,
	[280] = 1,
	[281] = 2,
	[282] = 3,
	[407] = 4,
	[408] = 5,
	[409] = 6,
	[283] = 1,
	[284] = 2,
	[285] = 3,
	[286] = 4,
	[342] = 1,
	[343] = 2,
	[344] = 3,
	[345] = 4,
	[369] = 9,
	[410] = 1,
	[411] = 2,

	[133] = 1,
	--[134] = 2,

	
	[137] = 4,
	[138] = 5,
	[139] = 6,
	[140] = 7,
	[141] = 8,
	
	[142] = 1,
	[143] = 2,
	[144] = 3,
	[145] = 4,
	[146] = 5,
	[150] = 6,
	[151] = 7,
	[152] = 8,
	--[153] = 9,
	[155] = 10,
	[157] = 11,
	[158] = 12,
	[159] = 13,
	[176] = 14,

	[205] = 4,
	[208] = 5,
	[209] = 6,

	[210] = 1,
	[211] = 2,
	[212] = 3,
	[213] = 4,
	
	[214] = 5,
	[215] = 6,
	[216] = 7,
	
	[217] = 1,
	[218] = 2,
	[219] = 3,
	[220] = 4,
	
	[221] = 2,
	[222] = 1,
	[223] = 3,
	[224] = 4,
  }

function getItemPerishable(itemId)
	if availableItems[itemId] then
		if perishableItems[itemId] then
			return perishableItems[itemId]
		end
	end
	return false
end

function getWeaponSkin(itemId)
	return weaponSkins[itemId]
end

function isKeyItem(itemId)
	if itemId <= 3 or itemId == 154 --[[or itemId == 119]] then
		return true
	end
	return false
end

paperItems = {
	[65] = true,
	[68] = true,
	[66] = true,
	[67] = true,
	[69] = true,
	[71] = true,
	[72] = true,
	[74] = true,
	[75] = true,
	[122] = true,
	[136] = true,
	[289] = true,
	[288] = true,
}

function isPaperItem(itemId)
	if paperItems[itemId] or scratchItems[itemId] then
		return true
	end
	return false
end

function getItemInfoForShop(itemId)
	return getItemName(itemId), getItemDescription(itemId), getItemWeight(itemId)
end

function getItemNameList()
	local nameList = {}

	for i = 1, #availableItems do
		nameList[i] = getItemName(i)
	end

	return nameList
end

function getItemDescriptionList()
	local descriptionList = {}

	for i = 1, #availableItems do
		descriptionList[i] = getItemDescription(i)
	end

	return descriptionList
end

function getItemName(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][1]
	end
	return "false"
end

function getItemDescription(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][2] or ""
	end
	return false
end

function getItemWeight(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][3]
	end
	return false
end

function isItemStackable(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][4]
	end
	return false
end

function getItemWeaponID(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][5] or 0
	end
	return false
end

function getItemAmmoID(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][6]
	end
	return false
end

function isItemDroppable(itemId)
	if availableItems[itemId] then
		return availableItems[itemId][7]
	end
	return false
end

function getItemDropDetails(itemId)
	if availableItems[itemId] and availableItems[itemId][8] then
		return availableItems[itemId][8], availableItems[itemId][9], availableItems[itemId][10], availableItems[itemId][11], availableItems[itemId][12]
	end
	return false
end

function isWeaponItem(itemId)
	if availableItems[itemId] and (type(getItemWeaponID(itemId)) == "string" or (type(getItemWeaponID(itemId)) == "number" and getItemWeaponID(itemId) > 0)) then
		return true
	end
	return false
end

function isAmmoItem(itemId)
	if itemId >= 338 and itemId <= 349 or itemId == 34 then
		return true
	end
	return false
end

serialItems = {}

local weaponTypes = {
	[22] = "P",
	[23] = "P",
	[24] = "P",
	[25] = "S",
	[26] = "S",
	[27] = "S",
	[28] = "SM",
	[29] = "SM",
	[32] = "SM",
	[30] = "AR",
	[31] = "AR",
	[33] = "R",
	[34] = "R",
	[12] = "K",
	[8] = "K",
	[4] = "K"
}

for i = 1, #availableItems do
	if isWeaponItem(i) then
		local weaponId = getItemWeaponID(i)

		if (type(weaponId) == "number" and weaponId >= 22 and weaponId <= 39 or weaponId == 12 or weaponId == 8 or weaponId == 4 or weaponId == 1 or not (weaponSkins[weaponId])) or type(weaponId) == "string" then
			availableItems[i][4] = false
			
			if i == 15 then
				serialItems[i] = "T"
			else
				serialItems[i] = weaponTypes[weaponId] or "O"
			end
		end
	end
end

local nonStackableItems = {}

for i = 1, #availableItems do
	if not isItemStackable(i) then
		table.insert(nonStackableItems, i)
	end
end

function getNonStackableItems()
	return nonStackableItems
end

craftDoNotTakeItems = {
	[120] = true,
	[118] = true,
}

availableRecipes = {
	[1] = {
		name = "M4A1 Acog",
		items = {
			{
				false,
				120,
				false
			  },
			  {
				177,
				178,
				179
			  },
			  {
				false,
				186,
				181
			  }
		},
		finalItem = {309, 1},
		requiredPermission = "canRobATM",
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Fegyverek"
	},
	[2] = {
		name = "Colt Anaconda",
		items = {
			{
				188,
				184,
				183
			  },
			  {
				false,
				186,
				185
			  },
			  {
				120,
				false,
				181
			  }
		},
		finalItem = {312, 1},
		requiredPermission = "canRobATM",
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Fegyverek"
	},
	[3] = {
		name = "Pump Shotgun",
		items = {
			{
				false,
				188,
				false
			  },
			  {
				189,
				190,
				191
			  },
			  {
				false,
				false,
				false
			  }
		},
		finalItem = {327, 1},
		requiredPermission = "canRobATM",
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Fegyverek"
	},
	[4] = {
		name = "Kés",
		items = {
			{
				120,
				false,
				118
			  },
			  {
				false,
				false,
				197
			  },
			  {
				false,
				196,
				false
			  }
		},
		finalItem = {9, 1},
		requiredPermission = "canRobATM",
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Fegyverek"
	},
	
	[5] = {
		name = "Rádió",
		items = {
			[1] = {false, 405, 410},
			[2] = {400, 402, 408},
			[3] = {false, 403, 413}
		},
		finalItem = {417,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	},

	[6] = {
		name = "Walkie Talkie",
		items = {
			[1] = {409,  405, 410},
			[2] = {400, 402, 412},
			[3] = {406, 403, 413}
		},
		finalItem = {414,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	},

	[7] = {
		name = "Diktafon",
		items = {
			[1] = {false, 406, false},
			[2] = {412,  403, 405},
			[3] = {411,  409,  413}
		},
		finalItem = {419,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	},

	[8] = {
		name = "Elemlámpa",
		items = {
			[1] = {false, 407, false},
			[2] = {410,  411,  413},
			[3] = {false, 412,  false}
		},
		finalItem = {418,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	},

	[9] = {
		name = "Tápegység",
		items = {
			[1] = {false, 408,  false},
			[2] = {410,  411,  413},
			[3] = {403, 401, false}
		},
		finalItem = {415,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	},

	[10] = {
		name = "Számológép",
		items = {
			[1] = {false, 405, 410},
			[2] = {402, 404, 412},
			[3] = {false, 403, 413}
		},
		finalItem = {416,  1},
		requiredJob = 1,
		suitableColShapes = {3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		category = "Elektronika"
	}
}

laserColors = {
	[0] = "#ff2828",
	[1] = "#696ef5",
	[2] = "#76ff82",
	[3] = "#f2d55e",
	[4] = "#bc5ef2",
	[5] = "#f2be5e",
	[6] = "#65f0e2",
}

function getLaserColor(data2)
	if data2 then
		local data2Details = split(data2, ":")
		if data2Details and data2Details[1] and data2Details[1] == "laser" then
			return laserColors[tonumber(data2Details[2]) or 0]
		end
	end
	return false
end

function getItemPic(itemId)
	return "files/items/" .. itemId - 1 .. ".png"
end