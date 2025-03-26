addCommandHandler("durr", function(client, command, target)
    local p = exports.seal_core:findPlayer(client, target)

    iprint(p)
    if not p then
        return
    end
    iprint(p)
    triggerClientEvent(p, "onClientPlayerDurr", p)
end)
iprint("a")