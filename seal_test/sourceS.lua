addCommandHandler("statssss", function(sourcePlayer)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)

        local c = 0
        for k, v in pairs(result) do
            c = c + v.playedMinutes
        end
        iprint(c, c/#result)
    end, exports.seal_database:getConnection(), "SELECT * FROM characters")
end)