local connection = false

addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		connection = exports.seal_database:getConnection()
	end
)

addEventHandler("onDatabaseConnected", getRootElement(),
	function (db)
		if client then
			banPlayer(client, true, false, true, "Anticheat", "AC #1")
            return
		end
		connection = db
	end
)

function addLogEntry(logType, datas)
	if logType and datas and type(datas) == "table" then
		local columns = {}
		local values = {}
		local params = {}

		for k, v in pairs(datas) do
			table.insert(columns, k)
			table.insert(values, "?")
			table.insert(params, v)
		end

		if not connection then
			return
		end
		
		if logType ~= "economy" and logType ~= "command" and logType ~= "vehicle" then
			local webhookMessage = "**OTHER LOG**```\n"
			webhookMessage = webhookMessage .. "logType: " .. logType .. "\n"
			
			for k, v in pairs(datas) do
				webhookMessage = webhookMessage .. k .. ": " .. v .. "\n"
			end
			webhookMessage = webhookMessage .. "```"

			sendWebhookMessage("other", webhookMessage)
		end
		
		dbExec(connection, "INSERT INTO `??` (" .. table.concat(columns, ",") .. ") VALUES (" .. table.concat(values, ",") .. ")", "log_" .. logType, unpack(params))
	end
end

function logAnticheatHook(action, message)
    local data = {
        content = "",
        username = "AntiCheat",
        embeds = {
            {
                title = action,
                description = message,
                footer = {
                    text = "Anticheat",
                }
            }
        }
    }

    local jsonData = toJSON(data)
          jsonData = string.sub(jsonData, 3, #jsonData - 2)

    local sendOptions = {
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = jsonData,
    }

    fetchRemote ( "https://discord.com/api/webhooks/1326289178241142837/3CAEPUipVOrX2hwcUqKLpXHBHmD9EB7MyrxjtIwgstVYKG9hnEbRb17FxTv6zoMnbo-7", sendOptions, call )
end

function call()

end

function logEconomy(thePlayer, typ, amount)
	addLogEntry("economy", {
		characterId = getElementData(thePlayer, "char.ID"),
		economyType = typ,
		managedAmount = amount
	})

	local webhookMessage = "**ECONOMY LOG**```\n"
	webhookMessage = webhookMessage .. "Karakter Id: " .. getElementData(thePlayer, "char.ID") .. "\n"
	webhookMessage = webhookMessage .. "Account Id:" .. getElementData(thePlayer, "char.accID") .. "\n"
	webhookMessage = webhookMessage .. "Serial: " .. getPlayerSerial(thePlayer) .. "\n"
	webhookMessage = webhookMessage .. "Ip: " .. getPlayerIP(thePlayer) .. "\n"
	webhookMessage = webhookMessage .. "Type : " .. typ .. "\n"
	webhookMessage = webhookMessage .. "Amount: " .. amount .. "```"
	sendWebhookMessage("economy", webhookMessage)
end

function logCommand(thePlayer, commandName, arguments)
	if isElement(thePlayer) then
		addLogEntry("command", {
			characterId = getElementData(thePlayer, "char.ID"),
			accountId = getElementData(thePlayer, "char.accID"),
			mtaSerial = getPlayerSerial(thePlayer),
			ipAddress = getPlayerIP(thePlayer),
			command = commandName,
			arguments = table.concat(arguments, " | ")
		})

		local webhookMessage = "**COMMAND LOG**```\n"
		webhookMessage = webhookMessage .. "Karakter Id: " .. getElementData(thePlayer, "char.ID") .. "\n"
		webhookMessage = webhookMessage .. "Account Id:" .. getElementData(thePlayer, "char.accID") .. "\n"
		webhookMessage = webhookMessage .. "Serial: " .. getPlayerSerial(thePlayer) .. "\n"
		webhookMessage = webhookMessage .. "Ip: " .. getPlayerIP(thePlayer) .. "\n"
		webhookMessage = webhookMessage .. "Command: " .. commandName .. "\n"
		webhookMessage = webhookMessage .. "Arguments: " .. table.concat(arguments, " | ") .. "```"
		sendWebhookMessage("command", webhookMessage)
	end
end

function logVehicle(thePlayer, theVehicle, commandName, arguments)
	local vehicleId = getElementData(theVehicle, "vehicle.dbID")

	if vehicleId then
		addLogEntry("vehicle", {
			vehicleId = vehicleId,
			characterId = getElementData(thePlayer, "char.ID"),
			accountId = getElementData(thePlayer, "char.accID"),
			command = commandName,
			arguments = table.concat(arguments, " | ")
		})

		local webhookMessage = "**VEHICLE LOG**```\n"
		webhookMessage = webhookMessage .. "Karakter Id: " .. getElementData(thePlayer, "char.ID") .. "\n"
		webhookMessage = webhookMessage .. "Account Id:" .. getElementData(thePlayer, "char.accID") .. "\n"
		webhookMessage = webhookMessage .. "Serial: " .. getPlayerSerial(thePlayer) .. "\n"
		webhookMessage = webhookMessage .. "Ip: " .. getPlayerIP(thePlayer) .. "\n"
		webhookMessage = webhookMessage .. "Command: " .. commandName .. "\n"
		webhookMessage = webhookMessage .. "Jármű id: " .. vehicleId .. "\n"
		webhookMessage = webhookMessage .. "Arguments: " .. table.concat(arguments, " | ") .. "```"
		sendWebhookMessage("vehicle", webhookMessage)
	end
end

local webhookTypes = {
	["economy"] = "https://discord.com/api/webhooks/1326289298919522384/hQSktYsd6tTmchZCBFvp3fzUxyJYSWuAdtH5RCbQqOoSXYu_iywevH-6gyL3a9Lvplfh",
	["command"] = "https://discord.com/api/webhooks/1326289385917911082/TbRK2aJroBPdNXo2QCoPkf0U6vQFP6R4pKJrTBe3Z2qZgK8KATKVg3TsjpjtqEwypydV",
	["vehicle"] = "https://discord.com/api/webhooks/1326289443543580763/emCvodP081dD8RkJHAV55mlgmJHJCBafqzl3k2qIj7aJShBxs-biL6SLa2ubJ5zkfKn5",
	["other"] = "https://discord.com/api/webhooks/1326289500703555695/NAlvYvXaI2Yl-JoCBzR_wQ8d65X559FYEGoKRHuwWyam7UKx9D6P6sLW51IG_JL27BbM"
}

local function webhookCallBack()
	return true
end

function sendWebhookMessage(type, message)
	if webhookTypes[type] then
		sendOptions = {
			formFields = {
				content= "" .. message .. ""
			},
		}

		fetchRemote(webhookTypes[type], sendOptions, webhookCallBack)
	else
		iprint("ilyen webhook nem létezik")
	end
end