local connection = false
local firstLoad = false
local cupons = {}

addEventHandler("onDatabaseConnected", getRootElement(),
	function(db)
		if client then
			banPlayer(client, true, false, true, "Anticheat", "AC #1")
            return
		end
		connection = db
	end
)

addEventHandler("onResourceStart", root,
    function()
        connection = exports.seal_database:getConnection()

        dbQuery(loadCupons, connection, "SELECT * FROM cupons")
    end
)

function loadCupons(qh)
    cupons = {}
    local result = dbPoll(qh, 0)

    if result then
        for k, v in pairs(result) do
            table.insert(cupons, {cuponID = v.dbID, cuponCode = v.code, cuponAmount = tonumber(v.amount), cuponType = v.type, cuponTypeAmount = tonumber(v.typeAmount), itemCount = v.itemCount, cuponActivatedBy = fromJSON(v.activatedBy) or {}, daily = v.daily})
        end
    end
end

addCommandHandler("kuponok",
    function(sourcePlayer, commandName)
        if getElementData(sourcePlayer, "acc.adminLevel") >= 6 then
            outputChatBox("#4adfbf[SealMTA]: #ffffffElérhető kuponok a szerveren:", sourcePlayer, 255, 255, 255, true)

            for k, v in pairs(cupons) do
                local usedAmount = #v.cuponActivatedBy + v.cuponAmount
                if usedAmount ~= #v.cuponActivatedBy then
                    local cuponTypeText = ""

                    if v.cuponType == 1 then
                        cuponTypeText = " PP"
                    elseif v.cuponType == 2 then
                        cuponTypeText = " Tárgy (ID)"
                    elseif v.cuponType == 3 then
                        cuponTypeText = " Jármű (ID)"
                    end

                    outputChatBox("         Id: #4adfbf " .. v.cuponID .. " #ffffff| Kupon: #4adfbf" .. v.cuponCode .. " #ffffff| Érték: #4adfbf " .. v.cuponTypeAmount .. cuponTypeText .. " #ffffff| Felhasználták: #4adfbf " .. #v.cuponActivatedBy .. "#ffffff/#4adfbf" .. usedAmount, sourcePlayer, 255, 255, 255, true)
                end
            end
        end
    end
)

local enabledSerials = {
    ["0EB993DA466366F4F7A9DE8AD585B391"] = true, -- erxk
    ["D90DAD1A3C9C3F779CA43AFFD9CF44A2"] = true, -- balage
    ["F3C797821A9E2E392AEDEDE582526884"] = true, -- marci
}

addCommandHandler("kupon",
    function(sourcePlayer, commandName, cuponCode)
        if not getElementData(sourcePlayer, "loggedIn") then
            return
        end
        local foundCupon = false
        for k, v in pairs(cupons) do
            if v.cuponCode == cuponCode then
                foundCupon = v
            end
        end
        if cuponCode then
            v = foundCupon
            local alreadyUsed = false
            if not foundCupon then
                outputChatBox("#d75959[Kupon]: #ffffffNincs ilyen kód!", sourcePlayer, 255, 255, 255, true)
                return
            end
            for k, v in pairs(v.cuponActivatedBy) do
                if tonumber(v) == getElementData(sourcePlayer, "char.accID") then
                    alreadyUsed = true
                    break
                end
            end
            if alreadyUsed then
                outputChatBox("#d75959[Kupon]: #ffffffTe már felhasználtad ezt a kódot!", sourcePlayer, 255, 255, 255, true)
                return
            end
            
            if v.cuponAmount > 0 then
                --local cuponReward = v.cuponTypeAmount
                if v.cuponType == 1 then
                    cuponReward = v.cuponTypeAmount.." PP"
                    setElementData(sourcePlayer, "acc.premiumPoints", getElementData(sourcePlayer, "acc.premiumPoints") + v.cuponTypeAmount)
                    local newPP, accID = getElementData(sourcePlayer, "acc.premiumPoints"), getElementData(sourcePlayer, "char.accID")
                    dbExec(connection, "UPDATE accounts SET premiumPoints = ? WHERE accountId = ?", newPP, getElementData(sourcePlayer, "char.accID"))
                elseif v.cuponType == 2 then
                    cuponReward = exports.seal_items:getItemName(v.cuponTypeAmount)
                    exports.seal_items:giveItem(sourcePlayer, v.cuponTypeAmount, v.itemCount or 1)
                elseif v.cuponType == 3 then
                    cuponReward = exports.seal_items:getItemName(exports.seal_vehiclenames:getCustomVehicleName(v.cuponTypeAmount))
                    local x, y, z = getElementPosition(sourcePlayer)
                    exports.seal_vehicles:createPermVehicle({
                        modelId = v.cuponTypeAmount,
                        color1 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
                        color2 = string.format("#%.2X%.2X%.2X", 200, 200, 200),
                        targetPlayer = sourcePlayer,
                        posX = x,
                        posY = y,
                        posZ = z,
                        rotX = 0,
                        rotY = 0,
                        rotZ = getPedRotation(sourcePlayer),
                        interior = getElementInterior(sourcePlayer),
                        dimension = getElementDimension(sourcePlayer)
                    })
                end
                table.insert(v.cuponActivatedBy, getElementData(sourcePlayer, "char.accID"))
                v.cuponAmount = v.cuponAmount - 1
                dbExec(connection, "UPDATE cupons SET amount = ?, activatedBy = ? WHERE dbID = ?", v.cuponAmount, toJSON(v.cuponActivatedBy), v.cuponID)
                exports.seal_anticheat:sendDiscordMessage("**"..getPlayerName(sourcePlayer):gsub("_", " ").."** felhasznált egy kupont! **("..cuponReward..")**", "moneylog")
                messageToAdmins("#4adfbf[SealMTA] #4adfbf"..getPlayerName(sourcePlayer):gsub("_", " ").." #fffffffelhasznált egy kupont!")
                outputChatBox("#4adfbf[Kupon]: #ffffffSikeresen felhasználtad a kódot! #4adfbf("..cuponReward..")", sourcePlayer, 255, 255, 255, true)
            else
                outputChatBox("#d75959[Kupon]: #ffffffElfogyott!", sourcePlayer, 255, 255, 255, true)
            end
        else
            outputChatBox("#d75959[Használat]: #ffffff/"..commandName.." [Kód]", sourcePlayer, 255, 255, 255, true)
        end
    end
)

addCommandHandler("createkupon",
    function(sourcePlayer, commandName, code, amount, type, typeAmount, itemAmount)
        if enabledSerials[getPlayerSerial(sourcePlayer)] and getElementData(sourcePlayer, "loggedIn") then
            if typeAmount then
                if tonumber(amount) and tonumber(type) and tonumber(typeAmount) and tonumber(type) <= 3 then
                    if itemAmount then
                        itemAmount = tonumber(itemAmount)
                        itemAmount = math.floor(itemAmount)
                        itemAmount = itemAmount or 1
                    else
                        itemAmount = 1
                    end

                    for k, v in pairs(cupons) do
                        if v.cuponCode == code then
                            outputChatBox("#d75959[Kupon]: #ffffffIlyen azonosítóval már létezik kupon!", sourcePlayer, 255, 255, 255, true)
                            return
                        end
                    end
                    if code == "0" then
                        code = sha256((math.random(1, 100000)/1000)*getTickCount()/1002)
                        code = utfSub(code, 1, 8)
                    end
                    dbExec(connection, "INSERT INTO cupons (code, amount, type, typeAmount, itemCount, activatedBy) VALUES (?,?,?,?,?,?)", code, amount, type, typeAmount, itemAmount, toJSON({}))
                    messageToAdmins("#4adfbf[SealMTA] #ffffff"..getPlayerName(sourcePlayer):gsub("_", " ").." létrehozott egy kupont! #4adfbf("..code..", "..amount..", "..type..", "..typeAmount..")")
                    exports.seal_anticheat:sendDiscordMessage("**"..getPlayerName(sourcePlayer):gsub("_", " ").."** létrehozott egy kupont! **("..code..", "..amount..", "..type..", "..typeAmount..")**", "kupon")
                    outputChatBox("#4adfbf[Kupon]: #ffffffSikeresen létrehoztad a kupont! #4adfbf("..code..")", sourcePlayer, 255, 255, 255, true)
                    dbQuery(loadCupons, connection, "SELECT * FROM cupons")
                end
            else
                outputChatBox("#d75959[Használat]: #ffffff/"..commandName.." [Kód (0 = random)] [Mennyiség] [Típus (1 = PP, 2 = Item, 3 = Jármű)] [Mennyiség (PP mennyiség, ItemID, ModellID)] [Ha item akkor mennyiség]", sourcePlayer, 255, 255, 255, true)
            end
        end
    end
)

addCommandHandler("deletekupon",
    function(sourcePlayer, commandName, cuponCode)
        if enabledSerials[getPlayerSerial(sourcePlayer)] and getElementData(sourcePlayer, "loggedIn") then
            if not cuponCode then
                outputChatBox("[Használat]: #ffffff/" .. commandName .. " [Kuponkód]", sourcePlayer, 255, 150, 0, true)
            else
                if cuponCode then
                    dbQuery(
                        function(qh)
                            local result = dbPoll(qh, 0)

                            if #result > 0 then
                                local cuponDelete = dbExec(connection, "DELETE from cupons WHERE code = ?", cuponCode)

                                if cuponDelete then
                                    dbQuery(loadCupons, connection, "SELECT * FROM cupons")
                                    outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen törölted a #4adfbf" .. cuponCode .. " #ffffffnévvel rendelkező kupont!", sourcePlayer, 255, 255, 255, true)
                                end
                            else
                                outputChatBox("#d75959[SealMTA]: #ffffffIlyen azonosítóval nem létezik kupon!", sourcePlayer, 255, 255, 255, true)
                            end

                        end, connection, "SELECT * from cupons WHERE code = ?", cuponCode
                    )
                end
            end
        end
    end
)

function messageToAdmins(msg)
    for i,v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "loggedIn") then 
            if getElementData(v, "acc.adminLevel")>=6 then
                 
                outputChatBox(msg, v, 255, 255, 255, true)
            end
        end
    end
end

local allowed = { { 48, 57 }, { 65, 90 }, { 97, 122 } } -- numbers/lowercase chars/uppercase chars

function generateString ( len )
    
    if tonumber ( len ) then
        math.randomseed ( getTickCount () )

        local str = ""
        for i = 1, len do
            local charlist = allowed[math.random ( 1, 3 )]
            str = str .. string.char ( math.random ( charlist[1], charlist[2] ) )
        end

        return str
    end
    
    return false
    
end