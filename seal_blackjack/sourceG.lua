cardRanks = {
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "J",
  "Q",
  "K",
  "A"
}
cardSuits = {
  "S",
  "H",
  "D",
  "C"
}
dealerPositions = {
  0,
  0.4,
  -180
}
blackjackHelpText = {
  [1] = {
    {"Blackjack"},
    " A huszonegy egy kártyajáték, melyet 52 lapos francia kártyával játszanak dzsókerek nélkül.",
    " Blackjack néven is ismert.",
    " A játék célja, hogy a játékos lapjai összértéke minél közelebb legyen a huszonegyhez, de azt ne lépje túl.",
    "",
    {
      "Lapok értékei"
    },
    " Ász - 1 vagy 11",
    "  Az Ász értéke attól függ, hogy az adott helyzetben melyik az előnyösebb.",
    "  Két Ász esetén az egyik értéke 1, a másiké 11. Több Ász használata esetén is hasonlóan lehet az értékét megválasztani.",
    "  Általában akkor tekintendő az Ász értéke 1-nek, ha a lapok összértéke az Ász 11-es értékével számolva meghaladná a 21-et.",
    " Király, Dáma, Bubi - 10",
    " Számozott lapok (2\226\128\14710) - A lapon lévő szám értéke",
    {
      "A játék menete"
    },
    {"Tét"},
    " A játékot meghatározott tétre játsszák.",
    " A játékosnak az osztás előtt meg kell tenni a tétet. Ha a játékos elveszti a játékot, akkor elveszíti a megtett tétet.",
    " Ha a játékos nyer, akkor a megtett tétet \226\128\147 speciális esetek kivételével \226\128\147 2:1 arányban kapja vissza.",
    {"Osztás"},
    " Az osztó a játékosnak oszt egy lapot, a színével felfelé, majd egyet saját magának is, szintén a színével felfelé.",
    " Ezután ismét oszt a játékosnak egy újabb lapot a színével felfelé, valamint saját magának is, de ezt már színével lefelé. ",
    " Ezt a lapot a játékos nem láthatja.",
    {"Lapkérés"},
    " A játékos az osztást követően lapot kérhet (Hit), megállhat (Stand), illetve speciális döntéseket hozhat (Double, Surrender).",
    " A játékosnak be kell fejeznie a játékot, az osztó csak ezután kérhet magának lapot. ",
    " Ha a játékos megállt, akkor kezdhet az osztó saját magának lapot osztani. ",
    " Az osztónak 16-nál kötelezően lapot kell kérnie, és 17-nél már kötelezően meg kell állnia. ",
    " Az osztó az Ász értékét nem tekintheti 1-nek, ha a lapok összértéke az Ász 11-es értékével számolva 17 és 21 közötti. ",
    " Csak akkor tekintheti 1-nek, ha a lapok összértéke az Ász 11-es értékével számolva meghaladná a 21-et."
  },
  [2] = {
    {
      "Végeredmény"
    },
    " Ha a játékos lapjainak összértéke közelebb van a 21-hez, mint az osztóé, akkor a játékos a tétet 2:1 arányban kapja meg.",
    " Ha az osztó lapjainak összértéke közelebb van a 21-hez, mint a játékosé, akkor a játékos elvesztette a tétet.",
    " Ha a játékos és az osztó lapjainak összértéke egyforma (Push), a megtett tétet visszakapja a játékos.",
    " Ha a játékos lapjainak összértéke a 21-et meghaladja (Bust), akkor elvesztette a tétet.",
    " Ha az osztó lapjainak összértéke a 21-et meghaladja (Bust), akkor a játékos a tétet 2:1 arányban kapja meg.",
    " Ha a játékos az első két lapjának összértéke 21, és az osztó nem 21-et ért el, akkor a tétet 3:2 arányban kapja meg.",
    "",
    "",
    {
      "Kifejezések"
    },
    " #7cc576Hit#ffffff: A lapkérésre használt kifejezés. ",
    " A játékos tetszőleges számú lapot kérhet, amíg a lapjainak összértéke meg nem haladja a 21-et.",
    "",
    " #7cc576Stay#ffffff: A megállásra használt kifejezés.",
    " A játékos nem kér több lapot, mert úgy ítéli meg, hogy megfelelő lapjai vannak a játék megnyerésére",
    "",
    " #7cc576Double#ffffff: Tétduplázásra használt kifejezés.",
    " A játékos a Double bemondása után már csak egy lapot kap, további lapot nem kérhet",
    "",
    " #7cc576Surrender#ffffff: A játék feladására használt kifejezés.",
    " Ha a játékosnak csak az osztás utáni két lapja van még meg és úgy ítéli meg, hogy a játékot nem tudja megnyerni,",
    " akkor ezzel a bemondással feladhatja a játékot és a tétje felét elveszti, a másik felét visszakapja.",
    " "
  }
}
function rotateAround(deg, x, y)
  local centerX = 0
  local centerY = 0
  
  local pointX = x
  local pointY = y
  
  local angle = math.rad(deg)

  local drawX = centerX + (pointX - centerX) * math.cos(angle) - (pointY - centerY) * math.sin(angle)
  local drawY = centerY + (pointX - centerX) * math.sin(angle) + (pointY - centerY) * math.cos(angle)
  
  return drawX, drawY
end
function thousandsStepper(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")
    if k == 0 then
      break
    end
  end
  return formatted
end
function getSlotCoins(player)
  return getElementData(player, "char.slotCoins") or 0
end
function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end
function table_eq(table1, table2)
  local avoid_loops = {}
  local function recurse(t1, t2)
    if type(t1) ~= type(t2) then
      return false
    end
    if type(t1) ~= "table" then
      return t1 == t2
    end
    if avoid_loops[t1] then
      return avoid_loops[t1] == t2
    end
    avoid_loops[t1] = t2
    local t2keys = {}
    local t2tablekeys = {}
    for k, _ in pairs(t2) do
      if type(k) == "table" then
        table.insert(t2tablekeys, k)
      end
      t2keys[k] = true
    end
    for k1, v1 in pairs(t1) do
      local v2 = t2[k1]
      if type(k1) == "table" then
        local ok = false
        for i, tk in ipairs(t2tablekeys) do
          if table_eq(k1, tk) and recurse(v1, t2[tk]) then
            table.remove(t2tablekeys, i)
            t2keys[tk] = nil
            ok = true
            break
          end
        end
        if not ok then
          return false
        end
      else
        if v2 == nil then
          return false
        end
        t2keys[k1] = nil
        if not recurse(v1, v2) then
          return false
        end
      end
    end
    if next(t2keys) then
      return false
    end
    return true
  end
  return recurse(table1, table2)
end
function getValueOf(hand)
  local total = 0
  local nbOfAces = 0
  for i = 1, #hand do
    if hand[i][1] == 13 then
      nbOfAces = nbOfAces + 1
    elseif hand[i][1] >= 9 then
      total = total + 10
    else
      total = total + tonumber(cardRanks[hand[i][1]])
    end
  end
  while nbOfAces ~= 0 do
    nbOfAces = nbOfAces - 1
    if total + 11 + nbOfAces <= 21 then
      total = total + 11
    else
      total = total + 1
    end
  end
  return total
end
