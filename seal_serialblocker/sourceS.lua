enabledSerials = {
    --["0EB993DA466366F4F7A9DE8AD585B391"] = true,
    ["C2B0917DC563370C91078DDE8C7F3DB4"] = true,
    --["F45E1565719BE0F6425C5CE6C2D30BE3"] = true,
}

kickReasons = {
    "...",
    "mizoo"
}

blockedSerials = {
    ["9B72B77D1FD9B4D05F564E5EB962D6B3"] = true, -- tarcseh [1]
    ["9557AA58D547DA12455253A209E88CB3"] = true, -- tarcseh [2]
    ["724E91AF3AF7CE4D4EA9E4DCB669AFB4"] = true, -- tarcseh [3]
    ["16CD7EB5565BDEDE81DDEB0C05363134"] = true, -- tarcseh [4]
}



addEventHandler("onPlayerJoin", root,
    function()
        if blockedSerials[getPlayerSerial(source)] then
            kickReasonsD = kickReasons[math.random(1, #kickReasons)]
            for k, v in pairs(getElementsByType("player")) do
                if enabledSerials[getPlayerSerial(v)] then
                    outputChatBox("Egy Serial Blockeres megpróbált csatlakozni.", v, 255, 255, 255, true)
                    outputChatBox(kickReasonsD, v)
                end
            end
            kickPlayer(source, kickReasonsD)
        end
    end
)