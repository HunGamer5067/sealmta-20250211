local connection = exports.seal_database:getConnection()

local blackjackTables = {}
local tablePositions = {}

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		dbQuery(
			function (qh)
				local result = dbPoll(qh, 0)

				if result then
					for k, v in pairs(result) do
						loadBlackjack(v.id, v)
					end
				end
			end,
		connection, "SELECT * FROM blackjack")
	end
)

addEvent("requestSSC", true)
addEventHandler("requestSSC", root, function()
    -- Ellenőrizzük, hogy a forrás egy játékos
    if not client or getElementType(client) ~= "player" then
        outputDebugString("requestSSC: Az eventet csak játékos hívhatja meg.", 2)
        return
    end

    -- Lekérjük az "char.slotCoins" értékét az element data-ból
    local slotCoins = getElementData(client, "char.slotCoins") or 0

    -- Visszaküldjük az értéket a kliensnek
    triggerClientEvent(client, "receiveSSC", resourceRoot, slotCoins)
end)

addCommandHandler("createblackjack",
    function(clientPlayer, commandName, minDeposit, maxDeposit)
        if getElementData(clientPlayer, "acc.adminLevel") > 6 then
            local minDeposit = tonumber(minDeposit) or 0
            local maxDeposit = tonumber(maxDeposit) or 0

            if minDeposit > 0 and maxDeposit > minDeposit then
                local posX, posY, posZ = getElementPosition(clientPlayer)
                local _, _, playerRot = getElementRotation(clientPlayer)
                local playerInt, playerDim = getElementInterior(clientPlayer), getElementDimension(clientPlayer)

                -- Adatok beszúrása az adatbázisba
                dbExec(
                    connection,
                    "INSERT INTO blackjack (x, y, z, rz, interior, dimension, minEntry, maxEntry) VALUES (?,?,?,?,?,?,?,?)",
                    posX, posY, posZ, playerRot, playerInt, playerDim, minDeposit, maxDeposit
                )

                -- Az új blackjack adatok lekérdezése
                dbQuery(
                    function(qh)
                        local result = dbPoll(qh, 0)

                        if result and result[1] then
                            local blackjackData = result[1]
                            loadBlackjack(blackjackData.id, blackjackData, true)

                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "success", "Blackjack sikeresen létrehozva! ID: " .. blackjackData.id)
                        else
                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "error", "Hiba történt a blackjack létrehozása során.")
                        end
                    end,
                    connection,
                    "SELECT * FROM blackjack WHERE id = LAST_INSERT_ID()"
                )
            else
                exports.seal_hud:showInfobox(clientPlayer, "error", "Helytelen minimum vagy maximum érték!")
            end
        else
            exports.seal_hud:showInfobox(clientPlayer, "error", "Nincs jogosultságod a blackjack létrehozására!")
        end
    end
)

function loadBlackjack(id, data, sync)
	local obj = createObject(2188, data.x, data.y, data.z, 0, 0, data.rz)

	setElementInterior(obj, data.interior)
	setElementDimension(obj, data.dimension)

	local x, y = rotateAround(data.rz, 0, 0.35)
	local ped = createPed(171, data.x + x, data.y + y, data.z, data.rz + 180)

	setElementInterior(ped, data.interior)
	setElementDimension(ped, data.dimension)
	setElementFrozen(ped, true)
	setElementData(ped, "invulnerable", true)
	setElementData(ped, "visibleName", "Dealer")

	tablePositions[id] = {data.x, data.y, data.z, data.rz, data.interior, data.dimension, data.minEntry, data.maxEntry}

	blackjackTables[id] = data
	blackjackTables[id].element = obj
	blackjackTables[id].dealer = ped
	blackjackTables[id].credit = 0
	blackjackTables[id].deckCards = {}
	blackjackTables[id].data = {
		tableId = id,
		player = {
			cards = {},
			element = false
		},
		gameState = 0,
		suspended = true,
		object = obj,
		positions = {data.x, data.y, data.z, data.rz},
		minEntry = data.minEntry,
		maxEntry = data.maxEntry,
		dealerCard = {},
		cards = {}
	}

	setElementData(obj, "blackjack.data", blackjackTables[id].data)

	if sync then
		triggerClientEvent("getBlackjackTables", resourceRoot, blackjackTables)
	end
end

addEvent("quitBlackjack", true)
function quitBlackjack(tableId)
    if tableId then
        local blackjackTable = blackjackTables[tableId]

        if blackjackTable then
            local playerX, playerY, playerZ = getElementPosition(client)
            local targetX, targetY, targetZ, targetRot = unpack(blackjackTable.data.positions)
            local x, y = rotateAround(targetRot, 0, -1.65)

            blackjackTable.data.player = {
                element = false,
                cards =  {}
            }
            blackjackTable.data.cards = {}
            --blackjackTable.credit = 0
            setElementData(client, "playerUsingBlackjack", false)
            setElementData(client, "blackjack.data", false)
        end
    end
end
addEventHandler("quitBlackjack", root, quitBlackjack)

addEvent("tryToSitBlackJack", true)
addEventHandler("tryToSitBlackJack", getRootElement(),
	function(tableId)
		if tableId then
			local blackjackTable = blackjackTables[tableId]

			if blackjackTable then
				local playerX, playerY, playerZ = getElementPosition(client)
				local targetX, targetY, targetZ, targetRot = unpack(blackjackTable.data.positions)
				local x, y = rotateAround(targetRot, 0, -1.65)

				setElementPosition(client, targetX + x, targetY + y, playerZ)

				blackjackTable.data.player = {
					element = client,
					cards =  {}
				}
				blackjackTable.data.cards = {}
				--blackjackTable.credit = 0
				setElementData(client, "playerUsingBlackjack", tableId)
				setElementData(client, "blackjack.data", blackjackTable.data)

				triggerClientEvent(client, "onOpenBlackjack", client, blackjackTable.data)
			end
		end
	end
)

addEventHandler("onElementDataChange", getRootElement(),
	function(elementData, oldValue, newValue)
		if elementData == "char.slotCoins" then
			triggerClientEvent(source, "refreshSSC", source, getElementData(source, "char.slotCoins"))
		end
	end
)

addEvent("blackJackHandler", true)
addEventHandler("blackJackHandler", getRootElement(),
	function(action, credit)
		if isElement(client) then
			local tableId = getElementData(client, "playerUsingBlackjack")

			if tableId then
				local blackjackTable = blackjackTables[tableId]
				local currentBalance = 20000

				if blackjackTable then
					local currentPlayer = blackjackTable.data.player.element
					local currentBalance = 10000

					if action == "pot" then
						if currentBalance >= credit then
							blackjackTable.data.player.element = client
							triggerClientEvent(client, "addBlackjackChat", client, "A játék elkezdődött.")
                            setElementData(client, "char.slotCoins", getElementData(currentPlayer, "char.slotCoins") - credit)
                            triggerClientEvent(currentPlayer, "refreshSSC", currentPlayer, getElementData(currentPlayer, "char.slotCoins"))
							createDeck(tableId)

							blackjackTable.data.gameState = 1

							blackjackTable.data.player.cards = giveCards(blackjackTable.deckCards, 2)
							blackjackTable.data.cards = giveCards(blackjackTable.deckCards, 2)
							blackjackTable.data.suspended = false
                            blackjackTable.credit = credit

							setElementData(blackjackTable.data.object, "blackjack.data", blackjackTable.data)
						end
					elseif action == "hit" then
						if not blackjackTable.data.suspended then
							if #blackjackTable.data.player.cards >= 2 then
								table.insert(blackjackTable.data.player.cards, giveCards(blackjackTable.deckCards, 1)[1])

								setPedAnimation(blackjackTable.dealer, "CASINO", "dealone", 800, false, false, false, false)

								if getValueOf(blackjackTable.data.player.cards) > 21 then
									blackjackTable.data.suspended = true
									setTimer(gameLoop, 1000, 1, tableId, "bust")
								end

								setElementData(blackjackTable.element, "blackjack.data", blackjackTable.data)
							end
						end
					elseif action == "stay" then
						if blackjackTable.data.gameState == 1 then
							triggerClientEvent(client, "addBlackjackChat", client, "#ffffffA bank megfordítja a második kártyát.")
						end

						blackjackTable.data.suspended = true
						blackjackTable.data.gameState = 2

						setTimer(gameLoop, 1000, 1, tableId, "newcard")
						setElementData(blackjackTable.element, "blackjack.data", blackjackTable.data)
					elseif action == "double" then
						if #blackjackTable.data.player.cards == 2 then
							blackjackTable.data.suspended = false

							if currentBalance - blackjackTable.credit >= 0 then
								triggerClientEvent(client, "addBlackjackChat", client, "#ffffff" .. getElementData(client, "visibleName"):gsub("_", " ") .. ": Double!")

								if blackjackTable.data.gameState == 1 then
									triggerClientEvent(client, "addBlackjackChat", client, "#ffffffA bank megfordítja a második kártyát.")
									blackjackTable.data.gameState = 2
								end

								blackjackTable.credit = blackjackTable.credit * 2
								blackjackTable.data.suspended = true

								--setElementData(client, "char.slotCoins", currentBalance - blackjackTable.credit)
                                triggerClientEvent(currentPlayer, "refreshSSC", currentPlayer, getElementData(currentPlayer, "char.slotCoins"))
								setPedAnimation(blackjackTable.dealer, "CASINO", "dealone", 800, false, false, false, false)
								
								table.insert(blackjackTable.data.player.cards, giveCards(blackjackTable.deckCards, 1)[1])

								if getValueOf(blackjackTable.data.player.cards) > 21 then
									setTimer(gameLoop, 1000, 1, tableId, "bust")
								else
									setTimer(gameLoop, 1000, 1, tableId, "newcard")
								end
							else
								triggerClientEvent(client, "addBlackjackChat", client, "#d75959Nem rendelkezel elég SSCvel a duplázáshoz!")
							end

							setElementData(blackjackTable.element, "blackjack.data", blackjackTable.data)
						end
					end
				end
			end

			triggerClientEvent(client, "getBlackjackTables", client, tablePositions)
		end
	end
)

addCommandHandler("deleteblackjack",
    function(clientPlayer, commandName, blackjackID)
        if getElementData(clientPlayer, "acc.adminLevel") > 6 then
            local blackjackID = tonumber(blackjackID)

            if blackjackID then
                -- Ellenőrizzük, hogy létezik-e a blackjack ID
                dbQuery(
                    function(qh)
                        local result = dbPoll(qh, 0)

                        if result and result[1] then
                            -- Töröljük az adatbázisból
                            dbExec(
                                connection,
                                "DELETE FROM blackjack WHERE id = ?",
                                blackjackID
                            )

                            -- Töröljük az objektumot és a dealer pedet
                            if blackjackTables[blackjackID] then
                                local blackjackData = blackjackTables[blackjackID]
                                if isElement(blackjackData.element) then
                                    destroyElement(blackjackData.element)
                                end
                                if isElement(blackjackData.dealer) then
                                    destroyElement(blackjackData.dealer)
                                end
                                blackjackTables[blackjackID] = nil
                            end

                            triggerClientEvent("onBlackjackDeleted", resourceRoot, blackjackID)

                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "success", "Blackjack sikeresen törölve! ID: " .. blackjackID)
                        else
                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "error", "Nem található blackjack ezzel az ID-vel.")
                        end
                    end,
                    connection,
                    "SELECT id FROM blackjack WHERE id = ?",
                    blackjackID
                )
            else
                exports.seal_hud:showInfobox(clientPlayer, "error", "Érvénytelen ID formátum!")
            end
        else
            exports.seal_hud:showInfobox(clientPlayer, "error", "Nincs jogosultságod a blackjack törlésére!")
        end
    end
)


function gameLoop(tableId, state)
	local blackjackTable = blackjackTables[tableId]

	if blackjackTable then
		local currentPlayer = blackjackTable.data.player.element

		blackjackTable.data.gameState = blackjackTable.data.gameState + 1
		if isElement(currentPlayer) then
			local dealerHand = getValueOf(blackjackTable.data.cards)
			local playerHand = getValueOf(blackjackTable.data.player.cards)

			if state == "newcard" then
				if dealerHand > 21 and playerHand <= 21 then
					return gameLoop(tableId, "win")
				elseif playerHand == 21 and dealerHand ~= 21 and #blackjackTable.data.player.cards == 2 then
					return gameLoop(tableId, "blackjack")
				elseif dealerHand < 17 then
					triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffBank lapot kér.")

					table.insert(blackjackTable.data.cards, giveCards(blackjackTable.deckCards, 1)[1])

					setElementData(blackjackTable.data.object, "blackjack.data", blackjackTable.data)
					setPedAnimation(blackjackTable.dealer, "CASINO", "dealone", 800, false, false, false, false)

					return setTimer(gameLoop, 1000, 1, tableId, "newcard")
				elseif playerHand > dealerHand and playerHand <= 21 then
					return gameLoop(tableId, "win")
				elseif playerHand > 21 then
					return gameLoop(tableId, "loses")
				elseif playerHand == dealerHand then
					return gameLoop(tableId, "push")
				elseif dealerHand > playerHand then
					return gameLoop(tableId, "loses")
				end
			else
				local win = 0

				triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffJáték vége.")
                local x, y, z = getElementPosition(currentPlayer)
                local int = getElementInterior(currentPlayer)
                local dim = getElementDimension(currentPlayer)
				
				if x and y and z and int and dim then
					if state == "push" then
						win = blackjackTable.credit
						triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffPush! Visszakapod a tétet.")
						triggerClientEvent("playBlackjackSound", resourceRoot, x, y, z, int, dim, tableId, "push")
					elseif state == "bust" then
						triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#d75959Vesztettél! (Bust)")
						triggerClientEvent("playBlackjackSound", resourceRoot, x, y, z, int, dim, tableId, "dealerwin")
					elseif state == "loses" then
						triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffVesztettél #d75959" .. blackjackTable.credit .. " #ffffffSSC-t!")
						triggerClientEvent("playBlackjackSound", resourceRoot, x, y, z, int, dim, tableId, "dealerwin")
					elseif state == "win" then
						win = blackjackTable.credit * 2
						triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffNyertél #7cc576" .. blackjackTable.credit .. " #ffffffSSC-t!")
						triggerClientEvent("playBlackjackSound", resourceRoot, x, y, z, int, dim, tableId, "win")
					elseif state == "blackjack" then
						win = math.floor(blackjackTable.credit * 2.5)
						triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffNyertél #7cc576" .. math.floor(blackjackTable.credit * 1.5) .. " #ffffffSSC-t! (Blackjack)")
						triggerClientEvent("playBlackjackSound", resourceRoot, x, y, z, int, dim, tableId, "blackjack")
					end
				end

				setElementData(currentPlayer, "char.slotCoins", (getElementData(currentPlayer, "char.slotCoins") or 0) + win)

				if win ~= blackjackTable.credit then
					if win > blackjackTable.credit then
						setPedAnimation(currentPlayer, "CASINO", "slot_win_out", -1, false, false, false, false)
						setElementData(currentPlayer, "playerIcons", {"plus", win})
					else
						setPedAnimation(currentPlayer, "CASINO", "cards_lose", -1, false, false, false, false)
						setElementData(currentPlayer, "playerIcons", {"minus", blackjackTable.credit})
					end

					setTimer(setPedAnimation, 2000, 1, currentPlayer, "CASINO", "cards_loop", -1, true, false, false, false)
				end

				triggerClientEvent(currentPlayer, "addBlackjackChat", currentPlayer, "#ffffffÚj kör kezdéséig #7cc5765 másodperc!")
                triggerClientEvent(currentPlayer, "refreshSSC", currentPlayer, getElementData(currentPlayer, "char.slotCoins"))
				setTimer(resetTable, 5000, 1, tableId, true)
			end
		end
	end
end

function resetTable(tableId, newround)
	local blackjackTable = blackjackTables[tableId]

	if blackjackTable then
		local currentPlayer = blackjackTable.data.player.element

		if newround then
			if isElement(currentPlayer) then
				local currentBalance = getElementData(currentPlayer, "char.slotCoins") or 0

				if currentBalance < blackjackTable.minEntry then
					exports.seal_hud:showInfobox(currentPlayer, "e", "Nem volt elég Slot Coinod a folytatáshoz!")
					currentPlayer = nil
				end
			end
		end

		if newround then
			blackjackTable.data.player.element = currentPlayer
		else
			blackjackTable.data.player.element = false
		end

		blackjackTable.data.gameState = 0
		blackjackTable.data.player.cards = {}
		blackjackTable.data.cards = {}
		blackjackTable.data.suspended = false
		blackjackTable.credit = 0

		setElementData(blackjackTable.data.object, "blackjack.data", blackjackTable.data)
	end
end

addEvent("requestBlackjackTables", true)
addEventHandler("requestBlackjackTables", getRootElement(),
	function()
		triggerClientEvent(client, "getBlackjackTables", client, tablePositions)
	end
)

function giveCards(deck, amount)
	local cards = {}

	for i = 1, amount do
		cards[i] = table.remove(deck)
	end

	return cards
end

function shuffleDeck(deck)
	for i = #deck, 2, -1 do
		local j = math.random(i)
		deck[i], deck[j] = deck[j], deck[i]
	end
end

function createDeck(tableId)
	blackjackTables[tableId].deckCards = {}

	for i = 1, #cardRanks do
		for j = 1, 4 do
			table.insert(blackjackTables[tableId].deckCards, {i, j})
		end
	end

	for i = 1, 3 do
		shuffleDeck(blackjackTables[tableId].deckCards)
	end
end

addCommandHandler("nearbyblackjack",
    function(clientPlayer, commandName, range)
        -- Only allow admins to use this command
        if getElementData(clientPlayer, "acc.adminLevel") > 6 then
            local range = tonumber(range) or 10 -- Default range is 10 if not specified

            if range > 0 then
                local posX, posY, posZ = getElementPosition(clientPlayer)
                local playerInt, playerDim = getElementInterior(clientPlayer), getElementDimension(clientPlayer)

                -- Query the database to find nearby blackjack tables within the specified range
                dbQuery(
                    function(qh)
                        local result = dbPoll(qh, 0)

                        if result and #result > 0 then
                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "success", "Közeli blackjack asztalok:")
                            for _, row in ipairs(result) do
                                local distance = getDistanceBetweenPoints3D(posX, posY, posZ, row.x, row.y, row.z)
                                triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "info", 
                                    string.format("ID: %d | Távolság: %.2f | Min: %d | Max: %d", row.id, distance, row.minEntry, row.maxEntry)
                                )
                            end
                        else
                            triggerClientEvent(clientPlayer, "showInfobox", clientPlayer, "error", "Nincs blackjack asztal a közelben.")
                        end
                    end,
                    connection,
                    "SELECT id, x, y, z, minEntry, maxEntry FROM blackjack WHERE interior = ? AND dimension = ?",
                    playerInt, playerDim
                )
            else
                exports.seal_hud:showInfobox(clientPlayer, "error", "Helytelen távolság érték!")
            end
        else
            exports.seal_hud:showInfobox(clientPlayer, "error", "Nincs jogosultságod a blackjack asztalok listázására!")
        end
    end
)