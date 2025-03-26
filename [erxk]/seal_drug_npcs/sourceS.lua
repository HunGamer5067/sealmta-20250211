local csovesContainer = {}
local csovesPositions = {
    -- ** X, Y, Z, ROT, INT, DIM, SKINID
    {2501.7006835938, -1455.0771484375, 23.976417541504, 180, 0, 0, 200},
    {2414.1787109375, -1394.9598388672, 24.367755889893, 134, 0, 0, 200},
    {2511.8420410156, -1682.7159423828, 13.463489532471, 44, 0, 0, 200},
    {1971.0009765625, -1779.4615478516, 13.546875, 90, 0, 0, 200},
    {1722.2536621094, -1721.8843994141, 13.550979614258, 177, 0, 0, 200},
    {1474.2269287109, -1722.6320800781, 13.560787200928, 180, 0, 0, 200},
    {1348.3702392578, -1759.0671386719, 13.515581130981, 356, 0, 0, 200},
    {1298.7562255859, -1385.4968261719, 13.535099029541, 180, 0, 0, 200},
    {1205.7845458984, -1159.2252197266, 23.605627059937, 0, 0, 0, 200},
    {1120.1971435547, -922.48114013672, 43.390625, 128, 0, 0, 200},
    {1031.5799560547, -919.52282714844, 42.122947692871, 100, 0, 0, 200},
    {-72.648361206055, -1595.8862304688, 2.6171875, 301, 0, 0, 200},
    {361.69216918945, -1802.0074462891, 4.8017525672913, 357, 0, 0, 200},
    
}

local csovesLastCsoves = false
local csovesInTheSameTime = 5
local csovesSellables = {
    --[ID] = {Item név amit kér, Item ár amit kap a játékos / db, valós itemid az inventoryba}
    [1] = {"Szárított marihuana", 2500, 232},
    [2] = {"Füves cigaretta", 500, 302},
    [3] = {"Kokain", 1000, 303},
    [4] = {"Heroinos fecskendő", 3500, 304},
    [5] = {"Parazeldum por", 3500, 305}
}

addEventHandler("onResourceStart", resourceRoot,
    function ()
        for i = 1, csovesInTheSameTime do
            repeat
                print("asd")
                csovesRandom = math.random(#csovesPositions)

                if csovesRandom and not csovesContainer[csovesRandom] then
                    createCsoves(csovesRandom)
                end
            until csovesContainer[csovesRandom]
        end
    end
)

addEventHandler("onElementColShapeHit", root,
    function (colshapeElement, matchingDimension)
        if matchingDimension then
            local elementType = getElementType(source)

            if elementType == "player" then
                local isCsovesCol = getElementData(colshapeElement, "csovesElement")

                if isCsovesCol then
                    local csovesColId = getElementData(colshapeElement, "csovesIdentity")

                    if csovesColId and csovesContainer[csovesColId] then
                        local csovesPed = csovesContainer[csovesColId].pedElement

                        if csovesPed then
                            local drugNameId = getElementData(csovesPed, "csovesDrug")
                            local drugAmount = getElementData(csovesPed, "csovesAmount")

                            if drugNameId and drugAmount then
                                local drugName = csovesSellables[drugNameId][1]
                                local drugPrice = csovesSellables[drugNameId][2] * drugAmount

                                if drugName and drugPrice then
                                    outputChatBox("Hajléktalan: Figyeje' ide, ha most adsz " .. drugAmount .. " darab " .. drugName .. "-t akko' kapsz érte most " .. drugPrice .. "$-t.", source, 255, 255, 255, true)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
)

addEvent("csovesCheckReceivedItems", true)
addEventHandler("csovesCheckReceivedItems", root,
    function (csovesIdentity, movedItem)
        if client and client ~= source then
            return
        end

        if not movedItem then
            return
        end

        if csovesIdentity then
            local csovesPed = csovesContainer[csovesIdentity].pedElement

            if csovesPed then
                local drugNameId = getElementData(csovesPed, "csovesDrug")
                local drugAmount = getElementData(csovesPed, "csovesAmount")

                if drugNameId and drugAmount then
                    local drugPrice = csovesSellables[drugNameId][2] * drugAmount
                    local drugValidItem = csovesSellables[drugNameId][3]

                    if drugAmount then
                        if movedItem.itemId ~= drugValidItem then
                            -- ** Nem valid item, nem ezt kérte a ped
                            print("NOT VALID ITEM #1")
                            return
                        end

                        if movedItem.amount < drugAmount then
                            -- ** Nem jó az item mennyisége, túl keveset kapott a ped
                            print("AMOUNT #1")
                            return
                        end

                        if not exports.seal_items:hasItemWithData(client, drugValidItem, movedItem.dbID, "dbID") then
                            -- ** Kliensen létezett az item, szerveren már nem potenciális csalás gyanúja
                            print("POTCHEAT #1")
                            return
                        end

                        if not exports.seal_items:hasItem(client, drugValidItem, drugAmount) then
                            -- ** Nincs ilyen iteme vagy nem a megfelelő mennyiségben
                            print("POTCHEAT #2")
                            return
                        end

                        local moneyCurrent = getElementData(client, "char.Money") or 0
                        local moneyDrug = drugPrice

                        if moneyCurrent and moneyDrug then
                            setElementData(client, "char.Money", moneyCurrent + (moneyDrug))
                        end

                        exports.seal_items:takeItem(client, "dbID", movedItem.dbID, drugAmount)

                        outputChatBox("Hajléktalan: Kösz szépen bratyesz én innét léptem is mielőtt meglátnak a kopók.", client, 255, 255, 255, true)
                        outputChatBox("#4adfbf[SealMTA]#FFFFFF: Sikeresen eladtad a kiválasztott tárgyat a csövesnek. " .. "(" .. drugPrice .. "$ | " .. drugAmount .. "db)", client, 255, 255, 255, true)

                        destroyCsoves(csovesIdentity, true)
                    end
                end
            end
        end
    end
)

function destroyCsoves(csovesIdentity, csovesMakeNew)
    if csovesIdentity then
        local csovesData = csovesContainer[csovesIdentity]

        if csovesData then
            if csovesData.pedElement and isElement(csovesData.pedElement) then
                destroyElement(csovesData.pedElement)
            end

            if csovesData.colElement and isElement(csovesData.colElement) then
                destroyElement(csovesData.colElement)
            end

            if csovesContainer[csovesIdentity] then
                csovesContainer[csovesIdentity] = nil
            end
            csovesLastCsoves = csovesIdentity
        end
    end

    if csovesMakeNew then
        repeat
            csovesRandom = math.random(#csovesPositions)

            if csovesRandom and (not csovesContainer[csovesRandom] and csovesRandom ~= csovesLastCsoves) then
                createCsoves(csovesRandom)
            end
        until csovesContainer[csovesRandom] and csovesRandom ~= csovesLastCsoves
    end
end

function createCsoves(randomCsoves)
    local csovesData = csovesPositions[randomCsoves]

    if csovesData then
        local csovesX, csovesY, csovesZ = csovesData[1], csovesData[2], csovesData[3]

        if csovesX and csovesY and csovesZ then
            local csovesRot = csovesData[4]

            if csovesRot then
                local csovesInt = csovesData[5]
                local csovesDim = csovesData[6]

                if csovesInt and csovesDim then
                    local csovesSkin = csovesData[7]

                    if csovesSkin then
                        local csovesPed = createPed(csovesSkin, csovesX, csovesY, csovesZ)
                        local csovesCol = createColSphere(csovesX, csovesY, csovesZ, 2)

                        if csovesPed and csovesCol then
                            local csovesDrugName = math.random(#csovesSellables)
                            local csovesDrugAmount = math.random(1, 15)

                            if csovesDrugName and csovesDrugAmount then
                                setElementData(csovesPed, "csovesElement", true)
                                setElementData(csovesPed, "csovesIdentity", randomCsoves)
                                setElementData(csovesPed, "visibleName", "Hajléktalan")
                                setElementData(csovesPed, "pedNameType", "Drog")

                                setElementData(csovesPed, "csovesDrug", csovesDrugName)
                                setElementData(csovesPed, "csovesAmount", csovesDrugAmount)
                            end

                            setElementData(csovesCol, "csovesElement", true)
                            setElementData(csovesCol, "csovesIdentity", randomCsoves)

                            setElementRotation(csovesPed, 0, 0, csovesRot)
                            setElementInterior(csovesPed, csovesInt)
                            setElementDimension(csovesPed, csovesDim)
                            setElementFrozen(csovesPed, true)
                            setTimer(
                                function()
                                    setPedAnimation(csovesPed, "CRACK", "crckidle1")
                                end, 1000, 1)

                            if not csovesContainer[randomCsoves] then
                                csovesContainer[randomCsoves] = {
                                    pedElement = csovesPed,
                                    colElement = csovesCol
                                }
                            end
                        end
                    end
                end
            end
        end
    end
end