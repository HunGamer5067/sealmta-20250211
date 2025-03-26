local txdList = {
    {"barrio1_lae2", 17508},
    {"furniture_lae2", 17503}
}
local dffList = {
    {"BlockK_LAe2", 17508},
    {"cluckinbell1_lae", 17534},
    {"furniture_lae", 17503}
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    for i = 1, #txdList do
        local txd = engineLoadTXD("files/" .. txdList[i][1] .. ".txd")
        if txd then
            iprint("asd")
            engineImportTXD(txd, txdList[i][2])
        end
    end
    for i = 1, #dffList do
        local dff = engineLoadDFF("files/" .. dffList[i][1] .. ".dff")
        if dff then
            iprint("asd")
            engineReplaceModel(dff, dffList[i][2])
        end
    end
end)