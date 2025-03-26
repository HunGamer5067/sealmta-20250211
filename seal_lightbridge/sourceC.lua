addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local txdData = engineLoadTXD("files/fenyhid.txd")
        if txdData then
            engineImportTXD(txdData, 5545)
            local dffData = engineLoadDFF("files/fenyhid.dff")
            if dffData then
                engineReplaceModel(dffData, 5545)
            end
        end
    end
)