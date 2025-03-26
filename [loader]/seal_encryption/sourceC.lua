local modelList = {
    -- ["1.dff"] = {
    --     model = 3985,
    --     txd = "files/1.txd",
    --     col = "files/1.col",
    --     alphaTransparency = false,
    --     filteringEnabled = false,
    -- },
    ["530i-pd.dff"] = {
        model = 596,
        txd = "files/530i-pd.txd",
    },
    ["560.dff"] = {
        model = 529,
        txd = "files/560.txd",
    },
    ["a4allroad.dff"] = {
        model = 467,
        txd = "files/a4allroad.txd",
    },
    ["a45.dff"] = {
        model = 598,
        txd = "files/a45.txd",
    },
    ["block.dff"] = {
        model = 3272,
        txd = "files/block.txd",
    },
    ["brabuscls.dff"] = {
        model = 580,
        txd = "files/brabuscls.txd",
    },
    ["brabuse.dff"] = {
        model = 550,
        txd = "files/brabuse.txd",
    },
    ["brabusp.dff"] = {
        model = 602,
        txd = "files/brabusp.txd",
    },
    ["brabusshop.dff"] = {
        model = 5726,
        txd = "files/brabusshop.txd",
        col = "files/brabusshop.col",
        alphaTransparency = true,
    },
    ["c63.dff"] = {
        model = 526,
        txd = "files/c63.txd",
    },
    ["casino.dff"] = {
        model = 4101,
        txd = "files/casino.txd",
        col = "files/casino.col",
    },
    ["casino_road1.dff"] = {
        model = 4168,
    },
    ["casino_road2.dff"] = {
        model = 6128,
    },
    ["e90.dff"] = {
        model = 426,
        txd = "files/e90.txd",
    },
    ["ut1.dff"] = {
        model = 4807,
        txd = "files/ekszer_alap.txd",
        col = "files/ut1.col",
    },
    ["ut2.dff"] = {
        model = 4846,
        txd = "files/ekszer_alap.txd",
        col = "files/ut2.col",
    },
    ["f90dmg.dff"] = {
        model = 507,
        txd = "files/f90dmg.txd",
    },
    ["g60dmg.dff"] = {
        model = 551,
        txd = "files/g60dmg.txd",
    },
    ["hatar.dff"] = {
        model = 17281,
        txd = "files/hatar.txd",
        col = "files/hatar.col",
    },
    ["m3cs.dff"] = {
        model = 585,
        txd = "files/m3cs.txd",
    },
    ["m4.dff"] = {
        model = 527,
        txd = "files/m4.txd",
    },
    ["m6.dff"] = {
        model = 517,
        txd = "files/m6.txd",
    },
    ["mustang.dff"] = {
        model = 587,
        txd = "files/mustang.txd",
    },
    ["pirate_chest.dff"] = {
        model = 8397,
        txd = "files/pirate_chest.txd",
    },
    ["pirate_chest_lock.dff"] = {
        model = 8396,
        txd = "files/pirate_chest.txd",
    },
    ["pirate_chest_top.dff"] = {
        model = 8394,
        txd = "files/pirate_chest.txd",
    },
    ["plugseal_charger.dff"] = {
        model = 7459,
        txd = "files/plugseal_charger.txd",
        col = "files/plugseal_charger.col"
    },
    ["plugseal_pistol.dff"] = {
        model = 327,
        txd = "files/plugseal_charger.txd",
    },
    ["rocket.dff"] = {
        model = 566,
        txd = "files/rocket.txd",
    },
    ["roulette_table.dff"] = {
        model = 8620,
        txd = "files/roulette.txd",
        col = "files/roulette_table.col",
    },
    ["rs6c6.dff"] = {
        model = 421,
        txd = "files/rs6c6.txd",
    },
    ["taycan.dff"] = {
        model = 560,
        txd = "files/taycan.txd",
    },
    ["x7.dff"] = {
        model = 489,
        txd = "files/x7.txd",
    },
    ["m5p.dff"] = {
        model = 547,
        txd = "files/m5p.txd",
    },
    -- ["rs6c8.dff"] = {
    --     model = 404,
    --     txd = "files/rs6c8.txd",
    -- },
}

addEvent("receiveProtectedFile", true)
addEventHandler("receiveProtectedFile", getRootElement(), function(protectedFile, decodeKey, decodeIvKey)
    if decodeKey and decodeIvKey then
        if not modelList[protectedFile] then
            return
        end

        if fileExists("encrypted/" .. protectedFile .. ".seal") then
            local file = fileOpen("encrypted/" .. protectedFile .. ".seal")
            
            if file then
                local fileSize = fileGetSize(file)
                local fileData = fileRead(file, fileSize)
                fileClose(file)
               
                if fileData then
                    local decodeIvKey = decodeString("base64", decodeIvKey)

                    decodeString("aes128", fileData, {key = decodeKey, iv = decodeIvKey}, function(decodedData)
                        local model = modelList[protectedFile].model

                        if modelList[protectedFile].txd then
                            local txd = engineLoadTXD(modelList[protectedFile].txd, modelList[protectedFile].filteringEnabled)
                            engineImportTXD(txd, model)
                        end

                        local dff = engineLoadDFF(decodedData)
                        engineReplaceModel(dff, model, modelList[protectedFile].alphaTransparency)

                        if modelList[protectedFile].col then
                            local col = engineLoadCOL(modelList[protectedFile].col)
                            engineReplaceCOL(col, model)
                        end

                        col = nil
                        dff = nil
                        txd = nil
                        decodedData = nil
                        collectgarbage("collect")
                    end)

                    decodeIvKey = nil
                    collectgarbage("collect")
                end
            end
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for protectedFile in pairs(modelList) do
        triggerServerEvent("requestProtectedFile", resourceRoot, protectedFile)
    end

    -- Kaszinó épület és út eltávolítása
    removeWorldModel(6128, 9999, 1207.46, -1712.20, 12.6641)
    removeWorldModel(4168, 9999, 1217.45, -1852.27, 12.4766)
    removeWorldModel(4101, 9999, 1224.70, -1782.20, 29.8984)
    removeWorldModel(4105, 9999, 1224.70, -1782.20, 29.8984)

    local casinoRoad = createBuilding(6128, 1207.46, -1712.20, 12.6641, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    setElementDoubleSided(casinoRoad, true)

    local casinoRoad = createBuilding(4168, 1217.45, -1852.27, 12.4766, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    setElementDoubleSided(casinoRoad, true)

    local casinoBuilding = createBuilding(4101, 1224.70, -1782.20, 29.8984, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    engineSetModelLODDistance(4101, 200)
    setElementDoubleSided(casinoBuilding, true)

    -- Brabus bolt
    removeWorldModel(5726, 9999, 1238.91, -1164.95, 26.8984)

    local brabusShop = createBuilding(5726, 1238.91, -1164.95, 26.8984, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    setElementDoubleSided(brabusShop, true)
end)