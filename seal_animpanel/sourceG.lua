categoryList = {
  [1] = {"Ülések", "chair"},
  [2] = {
    "Verekedés",
    "fist-raised"
  },
  [3] = {
    "Dohányzás",
    "smoking"
  },
  [4] = {
    "Keménykedés",
    "head-side-cough"
  },
  [5] = {
    "Általános",
    "dice-d6"
  },
  [6] = {
    "Szerencsejáték",
    "dice"
  },
  [7] = {"Ruhák", "tshirt"},
  [8] = {"Haldoklás", "tombstone"},
  [9] = {"Táncok", "walking"},
  [10] = {
    "Köszönések",
    "hand-heart"
  },
  [11] = {
    "Beszélgetések",
    "american-sign-language-interpreting"
  },
  [12] = {
    "Csókolózás",
    "kiss-wink-heart"
  },
  [13] = {"Edzés", "dumbbell"},
  [14] = {"Autóban", "car"}
}
animList = {}
commandLookup = {}
function addAnimation(name, block, anim, categID, loop, custom, freezeLast, commandName)
  table.insert(animList, {
    categID,
    name,
    block,
    anim,
    loop,
    custom,
    freezeLast,
    commandName
  })
  if commandName then
    local commandData = split(commandName, " ")
    if #commandData == 1 then
      if not commandLookup[commandData[1]] then
        commandLookup[commandData[1]] = {}
      end
      commandLookup[commandData[1]][0] = #animList
    else
      if not commandLookup[commandData[1]] then
        commandLookup[commandData[1]] = {}
      end
      commandLookup[commandData[1]][tonumber(commandData[2])] = #animList
    end
  end
end
function getCategoryAnimations(categID)
  local list = {}
  for i = 1, #animList do
    if animList[i][1] == categID then
      table.insert(list, i)
    end
  end
  return list
end
local animations = {
  {
    "Törökülés 1",
    "SGSGun_stand_4",
    "Gun_stand",
    1,
    true,
    true
  },
  {
    "Törökülés 2",
    "SGSLay_Bac_Loop",
    "Lay_Bac_Loop",
    1,
    true,
    true
  },
  {
    "Laza leülés",
    "Attractors",
    "Stepsit_in",
    1,
    false
  },
  {
    "Laza felállás",
    "Attractors",
    "Stepsit_out",
    1,
    false
  },
  {
    "Napozás",
    "BEACH",
    "bather",
    1,
    true
  },
  {
    "Háton fekvés",
    "BEACH",
    "Lay_Bac_Loop",
    1,
    true,
    false,
    false,
    "lay 1"
  },
  {
    "Háton fekvés női",
    "BEACH",
    "SitnWait_loop_W",
    1,
    true,
    false,
    false,
    "lay 2"
  },
  {
    "Földön ülés",
    "BEACH",
    "ParkSit_M_loop",
    1,
    true
  },
  {
    "Földön ülés 2",
    "SGSGun_stand",
    "Gun_stand",
    1,
    true,
    true
  },
  {
    "Földön ülés 3",
    "SGSParkSit_M_loop",
    "ParkSit_M_loop",
    1,
    true,
    true
  },
  {
    "Földön ülés 4",
    "SGSParkSit_W_loop",
    "ParkSit_W_loop",
    1,
    true,
    true
  },
  {
    "Földön ülés 5",
    "SGSSitnWait_loop_W",
    "SitnWait_loop_W",
    1,
    true,
    true
  },
  {
    "Földön ülés női",
    "BEACH",
    "ParkSit_W_loop",
    1,
    true
  },
  {
    "Ülés 1",
    "ped",
    "SEAT_idle",
    1,
    true,
    false,
    false,
    "sit 1"
  },
  {
    "Ülés 2",
    "FOOD",
    "FF_Sit_Look",
    1,
    true,
    false,
    false,
    "sit 2"
  },
  {
    "Ülés 3",
    "Attractors",
    "Stepsit_loop",
    1,
    true,
    false,
    false,
    "sit 3"
  },
  {
    "Ülés 4",
    "BEACH",
    "ParkSit_W_loop",
    1,
    true,
    false,
    false,
    "sit 4"
  },
  {
    "Ülés 4",
    "BEACH",
    "ParkSit_M_loop",
    1,
    true,
    false,
    false,
    "sit 5"
  },
  {
    "Laza ülés",
    "int_house",
    "lou_loop",
    1,
    true
  },
  {
    "Láblógatás",
    "SGSGun_stand_2",
    "Gun_stand",
    1,
    true,
    true
  },
  {
    "Padon ülés",
    "SGSGun_stand_3",
    "Gun_stand",
    1,
    true,
    true
  },
  {
    "Hason fekvés",
    "SGSnoifekv",
    "bather",
    1,
    true,
    true
  },
  {
    "Lábfelrakás",
    "SGSLOU",
    "LOU_Loop",
    1,
    true,
    true
  },
  {
    "Asztalon támaszkodás",
    "int_office",
    "off_sit_bored_loop",
    1,
    true
  },
  {
    "Görnyedt ülés",
    "misc",
    "seat_lr",
    1,
    true
  },
  {
    "Társalgás ülés közben 1",
    "misc",
    "seat_talk_01",
    1,
    true
  },
  {
    "Társalgás ülés közben 2",
    "misc",
    "seat_talk_02",
    1,
    true
  },
  {
    "Kiterülés 1",
    "ped",
    "FLOOR_hit_f",
    2,
    false,
    false,
    true,
    "fallfront"
  },
  {
    "Kiterülés 2",
    "ped",
    "FLOOR_hit",
    2,
    false,
    false,
    true,
    "fall"
  },
  {
    "Beállás ütésre",
    "BASEBALL",
    "Bat_IDLE",
    2,
    true
  },
  {
    "Beállás karddal",
    "SWORD",
    "sword_IDLE",
    2,
    true
  },
  {
    "Ütést kap 1",
    "BASEBALL",
    "Bat_Hit_1",
    2,
    false
  },
  {
    "Ütést kap 2",
    "BASEBALL",
    "Bat_Hit_2",
    2,
    false
  },
  {
    "Ütést kap 3",
    "BASEBALL",
    "Bat_Hit_3",
    2,
    false
  },
  {
    "Ütést kap 4",
    "ped",
    "handscower",
    2,
    false
  },
  {
    "Ütést kap 5",
    "SGSHcrckidle4",
    "crckidle4",
    2,
    false,
    true,
    true
  },
  {
    "Rágyújtás",
    "SGSrSitnWait_loop_W",
    "SitnWait_loop_W",
    3,
    false,
    true
  },
  {
    "Cigizés falnál 1",
    "BD_FIRE",
    "M_smklean_loop",
    3,
    true
  },
  {
    "Cigizés falnál 2",
    "LOWRIDER",
    "F_smklean_loop",
    3,
    true
  },
  {
    "Cigizés állva 1",
    "GANGS",
    "smkcig_prtl",
    3,
    true
  },
  {
    "Cigizés állva 2",
    "GANGS",
    "smkcig_prtl_F",
    3,
    true
  },
  {
    "Cigizés állva 3",
    "LOWRIDER",
    "M_smkstnd_loop",
    3,
    true
  },
  {
    "Cigizés állva 4",
    "SMOKING",
    "M_smk_drag",
    3,
    true
  },
  {
    "Cigizés állva 5",
    "SGSfSitnWait_loop_W",
    "SitnWait_loop_W",
    3,
    true,
    true
  },
  {
    "Cigi begyújt",
    "SMOKING",
    "M_smk_in",
    3,
    true
  },
  {
    "Cigi eldob",
    "SMOKING",
    "M_smk_out",
    3,
    true
  },
  {
    "Cigi eldob 2",
    "SGScSitnWait_loop_W",
    "SitnWait_loop_W",
    3,
    false,
    true
  },
  {
    "Cigi hamuzás",
    "SMOKING",
    "M_smk_tap",
    3,
    true
  },
  {
    "Feszítés",
    "benchpress",
    "gym_bp_celebrate",
    4,
    true
  },
  {
    "Feszítés 2",
    "CRACK",
    "Bbalbat_Idle_01",
    4,
    true,
    false,
    false,
    "bat 1"
  },
  {
    "Feszítés 3",
    "CRACK",
    "Bbalbat_Idle_02",
    4,
    true,
    false,
    false,
    "bat 2"
  },
  {
    "Feszítés 4",
    "Baseball",
    "Bat_IDLE",
    4,
    true,
    false,
    false,
    "bat 3"
  },
  {
    "Mivan?!",
    "RIOT",
    "RIOT_ANGRY",
    4,
    true,
    false,
    false,
    "what"
  },
  {
    "Árnyékolás",
    "GYMNASIUM",
    "GYMshadowbox",
    4,
    true
  },
  {
    "Földön pofozás",
    "MISC",
    "bitchslap",
    4,
    true
  },
  {
    "Rúgás",
    "POLICE",
    "Door_Kick",
    4,
    false
  },
  {
    "Célzás jobb kézzel",
    "SHOP",
    "ROB_Loop",
    4,
    true,
    false,
    false,
    "aim"
  },
  {
    "Célzás nagykaliberrel",
    "SHOP",
    "SHP_Gun_Aim",
    4,
    true
  },
  {
    "Seggrepacsi",
    "SWEET",
    "sweet_ass_slap",
    4,
    false,
    false,
    false,
    "slapass"
  },
  {
    "Bemutatás",
    "RIOT",
    "RIOT_FUKU",
    4,
    false,
    false,
    false,
    "fu"
  },
  {
    "Mutogatás",
    "LOWRIDER",
    "RAP_C_Loop",
    5,
    true,
    false,
    false
  },
  {
    "Állj",
    "POLICE",
    "CopTraf_Stop",
    5,
    true,
    false,
    false,
    "copstop"
  },
  {
    "Gyere",
    "CAMERA",
    "camstnd_cmon",
    5,
    true
  },
  {
    "Gyere 2",
    "POLICE",
    "CopTraf_Come",
    5,
    true,
    false,
    false,
    "copcome"
  },
  {
    "Gyere guggolva",
    "CAMERA",
    "camcrch_cmon",
    5,
    true
  },
  {
    "Tapsolás 1",
    "SGSclap1_tran_gtup",
    "tran_gtup",
    5,
    true,
    true,
    false,
    "clap 1"
  },
  {
    "Tapsolás 2",
    "SGSclap2_tran_hng",
    "tran_hng",
    5,
    true,
    true,
    false,
    "clap 2"
  },
  {
    "Terelés",
    "police",
    "coptraf_away",
    5,
    true,
    false,
    false,
    "copaway"
  },
  {
    "Terelés 2",
    "POLICE",
    "CopTraf_Left",
    5,
    true,
    false,
    false,
    "copleft"
  },
  {
    "Guggolás",
    "CAMERA",
    "camcrch_idleloop",
    5,
    false
  },
  {
    "Óra megnézése",
    "COP_AMBIENT",
    "Coplook_watch",
    5,
    false
  },
  {
    "Bólintás",
    "COP_AMBIENT",
    "Coplook_think",
    5,
    true,
    false,
    false,
    "think"
  },
  {
    "Ölbe tett kéz",
    "COP_AMBIENT",
    "Coplook_loop",
    5,
    true,
    false,
    false,
    "wait"
  },
  {
    "Fizetés",
    "DEALER",
    "shop_pay",
    5,
    false
  },
  {
    "Félénk állás",
    "SGSleanIDLE",
    "leanIDLE",
    5,
    true,
    true
  },
  {
    "Állás 1",
    "DEALER",
    "DEALER_IDLE",
    5,
    true
  },
  {
    "Állás 2",
    "GANGS",
    "leanIDLE",
    5,
    true,
    false,
    false,
    "lean"
  },
  {
    "Állás 3",
    "DEALER",
    "DEALER_IDLE_01",
    5,
    true,
    false,
    false,
    "idle"
  },
  {
    "Csípőre tett kéz",
    "COP_AMBIENT",
    "Coplook_shake",
    5,
    true,
    false,
    false,
    "shake"
  },
  {
    "Megnézés",
    "GRAFFITI",
    "graffiti_Chkout",
    5,
    false
  },
  {
    "Lánykérés",
    "SGSLcamcrch_cmon",
    "camcrch_cmon",
    12,
    true,
    true
  },
  {
    "Meglepődés",
    "ON_LOOKERS",
    "panic_loop",
    5,
    true,
    false,
    false,
    "shocked"
  },
  {
    "Nevetés",
    "RAPPING",
    "Laugh_01",
    5,
    true,
    false,
    false,
    "laugh"
  },
  {
    "Rajtolás",
    "CAR",
    "flag_drop",
    5,
    false,
    false,
    false,
    "startrace"
  },
  {
    "Védekezés",
    "ped",
    "cower",
    5,
    true
  },
  {
    "Kézfelrakás 1",
    "ped",
    "handsup",
    5,
    false,
    false,
    true,
    "handsup"
  },
  {
    "Kézfelrakás 2",
    "SHOP",
    "SHP_Rob_React",
    5,
    false,
    false,
    true
  },
  {
    "Jelvénnyel felszólítás",
    "SGSRcolt45_fire_2hands",
    "colt45_fire_2hands",
    5,
    false,
    true
  },
  {
    "Tisztelgés",
    "SGSRtisztelges_gsign5LH",
    "gsign5LH",
    5,
    true,
    true
  },
  {
    "Tarkóra tett kéz térdelve",
    "SGSRtarkonhandsup_cower",
    "cower",
    5,
    true,
    true
  },
  {
    "Tarkóra tett kéz",
    "SGSRhandsup",
    "handsup",
    5,
    false,
    true,
    true
  },
  {
    "Újra éleszt",
    "MEDIC",
    "CPR",
    5,
    false
  },
  {
    "Orrba szívás",
    "CRACK",
    "Bbalbat_Idle_02",
    5,
    true
  },
  {
    "Orrba szívás 2",
    "SGSgum_eat",
    "gum_eat",
    5,
    false,
    true,
    false,
    "coke"
  },
  {
    "Pózolás 1",
    "SGSFPParkSit_M_loop",
    "ParkSit_M_loop",
    5,
    true,
    true
  },
  {
    "Pózolás 2",
    "SGSFP2ParkSit_M_loop",
    "ParkSit_M_loop",
    5,
    true,
    true
  },
  {
    "Pózolás 3",
    "SGSFPbather",
    "bather",
    5,
    true,
    true
  },
  {
    "Pózolás 4",
    "SGSFP2bather",
    "bather",
    5,
    true,
    true
  },
  {
    "Pózolás 5",
    "SGSFP3bather",
    "bather",
    5,
    true,
    true
  },
  {
    "Pózolás 6",
    "SGSFP4bather",
    "bather",
    5,
    true,
    true
  },
  {
    "Pózolás 7",
    "SGSFP5bather",
    "bather",
    5,
    true,
    true
  },
  {
    "Pózolás 8",
    "SGSFPCoplook_loop",
    "Coplook_loop",
    5,
    true,
    true
  },
  {
    "Pózolás 9",
    "SGSFPCoplook_in",
    "Coplook_in",
    5,
    true,
    true
  },
  {
    "Pózolás 10",
    "SGSFPGun_Stand",
    "Gun_Stand",
    5,
    true,
    true
  },
  {
    "Ordítás 1",
    "OTB",
    "wtchrace_win",
    5,
    true,
    false,
    false,
    "cheer 1"
  },
  {
    "Ordítás 2",
    "RIOT",
    "RIOT_shout",
    5,
    true,
    false,
    false,
    "cheer 2"
  },
  {
    "Ordítás 3",
    "STRIP",
    "PUN_HOLLER",
    5,
    true,
    false,
    false,
    "cheer 3"
  },
  {
    "Gyász",
    "GRAVEYARD",
    "mrnM_loop",
    5,
    true,
    false,
    false,
    "mourn"
  },
  {
    "Sírás",
    "GRAVEYARD",
    "mrnF_loop",
    5,
    true,
    false,
    false,
    "cry"
  },
  {
    "Kifáradt",
    "FAT",
    "idle_tired",
    5,
    true,
    false,
    false,
    "tired"
  },
  {
    "Ivás",
    "gangs",
    "drnkbr_prtl",
    5,
    true
  },
  {
    "Hamburger evés",
    "FOOD",
    "EAT_Burger",
    5,
    true
  },
  {
    "Csirke evés",
    "FOOD",
    "EAT_Chicken",
    5,
    true
  },
  {
    "Pizza evés",
    "FOOD",
    "EAT_Pizza",
    5,
    true
  },
  {
    "Matatás",
    "BOMBER",
    "BOM_Plant_Loop",
    5,
    true
  },
  {
    "Felvesz",
    "CARRY",
    "liftup",
    5,
    false
  },
  {
    "Letesz",
    "CARRY",
    "putdwn",
    5,
    false
  },
  {
    "Szurkol",
    "CASINO",
    "manwind",
    5,
    true
  },
  {
    "Szurkol 2",
    "CASINO",
    "manwinb",
    5,
    true,
    false,
    false,
    "win 1"
  },
  {
    "Szurkol 3",
    "CASINO",
    "manwind",
    5,
    true,
    false,
    false,
    "win 2"
  },
  {
    "Telefonálás",
    "ped",
    "phone_talk",
    5,
    true
  },
  {
    "Újraélesztés",
    "medic",
    "cpr",
    5,
    true,
    false,
    false,
    "cpr"
  },
  {
    "Rosszullét",
    "FOOD",
    "EAT_Vomit_P",
    5,
    true,
    false,
    false,
    "puke"
  },
  {
    "Vakarózás",
    "MISC",
    "Scratchballs_01",
    5,
    true,
    false,
    false,
    "scratch"
  },
  {
    "Vizelés",
    "PAULNMAC",
    "Piss_loop",
    5,
    true,
    false,
    false,
    "piss"
  },
  {
    "Önkielégítés",
    "PAULNMAC",
    "wank_loop",
    5,
    true,
    false,
    false,
    "wank"
  },
  {
    "Kártya emelés",
    "CASINO",
    "cards_raise",
    6,
    false
  },
  {
    "Kártya nézés",
    "CASINO",
    "cards_loop",
    6,
    true
  },
  {
    "Kártya veszít",
    "CASINO",
    "cards_lose",
    6,
    false
  },
  {
    "Kártya nyer",
    "CASINO",
    "cards_win",
    6,
    false
  },
  {
    "Rouletthez állás",
    "CASINO",
    "Roulette_in",
    6,
    false
  },
  {
    "Roulett nézés",
    "CASINO",
    "Roulette_loop",
    6,
    true
  },
  {
    "Roulett veszítés",
    "CASINO",
    "Roulette_lose",
    6,
    false
  },
  {
    "Roulett nyerés",
    "CASINO",
    "Roulette_win",
    6,
    false
  },
  {
    "Kalap megnézés",
    "CLOTHES",
    "CLO_Pose_Hat",
    7,
    true
  },
  {
    "Nadrág megnézés",
    "CLOTHES",
    "CLO_Pose_Legs",
    7,
    true
  },
  {
    "Cipő megnézés",
    "CLOTHES",
    "CLO_Pose_Shoes",
    7,
    true
  },
  {
    "Kar megnézés",
    "CLOTHES",
    "CLO_Pose_Torso",
    7,
    true
  },
  {
    "Óra megnézés",
    "CLOTHES",
    "CLO_Pose_Watch",
    7,
    true
  },
  {
    "Sérülés 1",
    "SGSSEcrckidle1",
    "crckidle1",
    8,
    true,
    true
  },
  {
    "Sérülés 2",
    "SGSSEcrckidle4",
    "crckidle4",
    8,
    true,
    true
  },
  {
    "Sérülés 3",
    "SGSSEcrckidle3",
    "crckidle3",
    8,
    true,
    true
  },
  {
    "Halál 1",
    "CRACK",
    "crckdeth1",
    8,
    false
  },
  {
    "Halál 2",
    "CRACK",
    "crckdeth2",
    8,
    false
  },
  {
    "Halál 3",
    "CRACK",
    "crckdeth3",
    8,
    false
  },
  {
    "Halál 4",
    "SGSHCS_Dead_Guy",
    "CS_Dead_Guy",
    8,
    false,
    true
  },
  {
    "Halál 5",
    "SGSSEcrckidle2",
    "crckidle2",
    8,
    true,
    true
  },
  {
    "Halál 6",
    "CRACK",
    "crckidle2",
    8,
    true,
    false,
    false,
    "cheer 3"
  },
  {
    "Halál ülve előre",
    "FOOD",
    "FF_Die_Fwd",
    8,
    false
  },
  {
    "Halál ülve jobbra",
    "FOOD",
    "FF_Die_Right",
    8,
    false
  },
  {
    "Halál ülve balra",
    "FOOD",
    "FF_Die_Left",
    8,
    false
  },
  {
    "Haldoklás 1",
    "CRACK",
    "crckidle1",
    8,
    true
  },
  {
    "Haldoklás 2",
    "CRACK",
    "crckidle3",
    8,
    true
  },
  {
    "Haldoklás 3",
    "CRACK",
    "crckidle4",
    8,
    true
  },
  {
    "Tánc 1",
    "DANCING",
    "dance_loop",
    9,
    true,
    false,
    false,
    "dance 1"
  },
  {
    "Tánc 2",
    "DANCING",
    "DAN_Down_A",
    9,
    true,
    false,
    false,
    "dance 2"
  },
  {
    "Tánc 3",
    "DANCING",
    "DAN_Left_A",
    9,
    true,
    false,
    false,
    "dance 3"
  },
  {
    "Tánc 4",
    "DANCING",
    "DAN_Loop_A",
    9,
    true,
    false,
    false,
    "dance 4"
  },
  {
    "Tánc 5",
    "DANCING",
    "DAN_Right_A",
    9,
    true,
    false,
    false,
    "dance 5"
  },
  {
    "Tánc 6",
    "DANCING",
    "DAN_Up_A",
    9,
    true,
    false,
    false,
    "dance 6"
  },
  {
    "Tánc 7",
    "DANCING",
    "dnce_M_a",
    9,
    true,
    false,
    false,
    "dance 7"
  },
  {
    "Tánc 9",
    "DANCING",
    "dnce_M_b",
    9,
    true,
    false,
    false,
    "dance 9"
  },
  {
    "Tánc 10",
    "DANCING",
    "dnce_M_c",
    9,
    true,
    false,
    false,
    "dance 10"
  },
  {
    "Tánc 11",
    "DANCING",
    "dnce_M_d",
    9,
    true,
    false,
    false,
    "dance 11"
  },
  {
    "Tánc 12",
    "DANCING",
    "dnce_M_e",
    9,
    true,
    false,
    false,
    "dance 12"
  },
  {
    "Bandás 1",
    "GANGS",
    "hndshkaa",
    10,
    true
  },
  {
    "Bandás 2",
    "GANGS",
    "hndshkba",
    10,
    true
  },
  {
    "Bandás 3",
    "GANGS",
    "hndshkca",
    10,
    true
  },
  {
    "Bandás 4",
    "GANGS",
    "hndshkcb",
    10,
    true
  },
  {
    "Bandás 5",
    "GANGS",
    "hndshkda",
    10,
    true
  },
  {
    "Bandás 6",
    "GANGS",
    "hndshkea",
    10,
    true
  },
  {
    "Bandás 7",
    "GANGS",
    "hndshkfa",
    10,
    true
  },
  {
    "Kézrázás",
    "GANGS",
    "prtial_hndshk_biz_01",
    10,
    true
  },
  {
    "Integetés",
    "GHANDS",
    "gsign5LH",
    10,
    true
  },
  {
    "Integetés női",
    "KISSING",
    "gfwave2",
    10,
    true
  },
  {
    "Beszélgetés 1",
    "GANGS",
    "prtial_gngtlkA",
    11,
    true
  },
  {
    "Beszélgetés 2",
    "GANGS",
    "prtial_gngtlkB",
    11,
    true
  },
  {
    "Beszélgetés 3",
    "GANGS",
    "prtial_gngtlkC",
    11,
    true
  },
  {
    "Beszélgetés 4",
    "GANGS",
    "prtial_gngtlkD",
    11,
    true
  },
  {
    "Beszélgetés 5",
    "GANGS",
    "prtial_gngtlkE",
    11,
    true
  },
  {
    "Beszélgetés 6",
    "GANGS",
    "prtial_gngtlkF",
    11,
    true
  },
  {
    "Beszélgetés 7",
    "GANGS",
    "prtial_gngtlkG",
    11,
    true
  },
  {
    "Beszélgetés 8",
    "GANGS",
    "prtial_gngtlkH",
    11,
    true
  },
  {
    "Beszélgetés 9",
    "GHANDS",
    "gsign1",
    11,
    true,
    false,
    false,
    "gsign 1"
  },
  {
    "Beszélgetés 10",
    "GHANDS",
    "gsign2",
    11,
    true,
    false,
    false,
    "gsign 2"
  },
  {
    "Beszélgetés 11",
    "GHANDS",
    "gsign3",
    11,
    true,
    false,
    false,
    "gsign 3"
  },
  {
    "Beszélgetés 12",
    "GHANDS",
    "gsign4",
    11,
    true,
    false,
    false,
    "gsign 4"
  },
  {
    "Beszélgetés 13",
    "GHANDS",
    "gsign5",
    11,
    true,
    false,
    false,
    "gsign 5"
  },
  {
    "Beszéd autóban",
    "CAR_CHAT",
    "car_talkm_loop",
    11,
    true,
    false,
    false,
    "carchat"
  },
  {
    "Csók 1",
    "KISSING",
    "Playa_Kiss_01",
    12,
    true
  },
  {
    "Csók 2",
    "KISSING",
    "Playa_Kiss_02",
    12,
    true
  },
  {
    "Csók 3",
    "KISSING",
    "Playa_Kiss_03",
    12,
    true
  },
  {
    "Csók női 1",
    "KISSING",
    "Grlfrd_Kiss_01",
    12,
    true
  },
  {
    "Csók női 2",
    "KISSING",
    "Grlfrd_Kiss_02",
    12,
    true
  },
  {
    "Csók női 3",
    "KISSING",
    "Grlfrd_Kiss_03",
    12,
    true
  },
  {
    "Guggolás",
    "SGSS3SitnWait_loop_W",
    "SitnWait_loop_W",
    13,
    true,
    true
  },
  {
    "Bemelegítés",
    "SGSS2SitnWait_loop_W",
    "SitnWait_loop_W",
    13,
    true,
    true
  },
  {
    "Felülés",
    "SGSSSitnWait_loop_W",
    "SitnWait_loop_W",
    13,
    true,
    true
  },
  {
    "Fekvőtámasz",
    "SGSScrckdeth2",
    "crckdeth2",
    13,
    true,
    true
  },
  {
    "Tánc 13",
    "SGSDdnce_M_e",
    "dnce_M_e",
    9,
    true,
    true,
    false,
    "dance 13"
  },
  {
    "Tánc 14",
    "SGSDdnce_M_b",
    "dnce_M_b",
    9,
    true,
    true,
    false,
    "dance 14"
  },
  {
    "Tánc 15",
    "SGSDdnce_M_a",
    "dnce_M_a",
    9,
    true,
    true,
    false,
    "dance 15"
  },
  {
    "Tánc 16",
    "SGSDDAN_Up_A",
    "DAN_Up_A",
    9,
    true,
    true,
    false,
    "dance 16"
  },
  {
    "Tánc 17",
    "SGSDDAN_Right_A",
    "DAN_Right_A",
    9,
    true,
    true,
    false,
    "dance 17"
  },
  {
    "Tánc 18",
    "SGSDDAN_Loop_A",
    "DAN_Loop_A",
    9,
    true,
    true,
    false,
    "dance 18"
  },
  {
    "Tánc 19",
    "SGSDDAN_Left_A",
    "DAN_Left_A",
    9,
    true,
    true,
    false,
    "dance 19"
  },
  {
    "Tánc 20",
    "SGSDDAN_Down_A",
    "DAN_Down_A",
    9,
    true,
    true,
    false,
    "dance 20"
  },
  {
    "Tánc 21",
    "SGSDdance_loop",
    "dance_loop",
    9,
    true,
    true,
    false,
    "dance 21"
  },
  {
    "Tánc 22",
    "SGSDbd_clap1",
    "bd_clap1",
    9,
    true,
    true,
    false,
    "dance 22"
  },
  {
    "Tánc 23",
    "SGSDbd_clap",
    "bd_clap",
    9,
    true,
    true,
    false,
    "dance 23"
  },
  {
    "Tánc 24",
    "STRIP",
    "strip_D",
    9,
    true,
    false,
    false,
    "strip"
  },
  {
    "Tánc 25",
    "LOWRIDER",
    "RAP_A_Loop",
    9,
    true,
    false,
    false,
    "rap 1"
  },
  {
    "Tánc 26",
    "LOWRIDER",
    "RAP_B_Loop",
    9,
    true,
    false,
    false,
    "rap 2"
  },
  {
    "Tánc 27",
    "LOWRIDER",
    "RAP_C_Loop",
    9,
    true,
    false,
    false,
    "rap 3"
  },
  {
    "Sofőr 1",
    "SGSbal_elso_2",
    "Tyd2car_high",
    14,
    true,
    true,
    false,
    "carsit 1"
  },
  {
    "Sofőr 2",
    "SGSbal_elso_3",
    "Tyd2car_med",
    14,
    true,
    true,
    false,
    "carsit 2"
  },
  {
    "Sofőr 3",
    "CAR",
    "Tap_hand",
    14,
    true,
    false,
    false,
    "carsit 3"
  },
  {
    "Sofőr 4",
    "CAR",
    "Sit_relaxed",
    14,
    true,
    false,
    false,
    "carsit 4"
  },
  {
    "Utas bal 1",
    "SGSbal_hatso_1",
    "lrgirl_l12_to_l0",
    14,
    true,
    true,
    false,
    "carsit 5"
  },
  {
    "Utas bal 2",
    "SGSbal_hatso_2",
    "lrgirl_idle_to_l0",
    14,
    true,
    true,
    false,
    "carsit 6"
  },
  {
    "Utas jobb 1",
    "SGSjobb_2",
    "Tyd2car_bump",
    14,
    true,
    true,
    false,
    "carsit 7"
  },
  {
    "Utas jobb 2",
    "SGSjobb_3",
    "Tyd2car_low",
    14,
    true,
    true,
    false,
    "carsit 8"
  },
  {
    "Hátraszaltó",
    "SGStricking",
    "bf360",
    13,
    false,
    true,
    false
  },
  {
    "Hátraszaltó 2",
    "SGStricking",
    "bf",
    13,
    false,
    true,
    false
  },
  {
    "Oldalszaltó",
    "SGStricking",
    "folha",
    13,
    false,
    true,
    false
  },
  {
    "Kézenállás",
    "SGStricking",
    "handstand",
    13,
    false,
    true,
    false
  },
  {
    "Bemelegítés 2",
    "SGStricking",
    "backspring",
    13,
    false,
    true,
    false
  },
  {
    "Szaltó",
    "SGStricking",
    "aerial",
    13,
    false,
    true,
    false
  }
}
for k = 1, #animations do
  animations[k][2] = utf8.lower(animations[k][2])
  animations[k][3] = utf8.lower(animations[k][3])
end
for k = 1, #animations do
  local anim = animations[k]
  addAnimation(anim[1], anim[2], anim[3], anim[4], anim[5], anim[6], anim[7], anim[8])
end
