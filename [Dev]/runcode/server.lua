local rootElement = getRootElement()
local codeSerials = {
	["D90DAD1A3C9C3F779CA43AFFD9CF44A2"] = true, -- balage
	["C2B0917DC563370C91078DDE8C7F3DB4"] = true, -- tyreek
	["F3C797821A9E2E392AEDEDE582526884"] = true, -- mali
	["8E76D1DAEAD47436DF504013924014A2"] = true, -- kicsidzs
	["A342FDE28A12811DBBCB50CD14092643"] = true, -- erik
}

function runString (commandstring, outputTo, source)
	me = source
	local sourceName = source and getPlayerName(source):gsub("_", " ") or "Console"


	--#d75959
	--5ec1e6
	outputChatBox("#4adfbf[SealMTA] #ffffff"..sourceName.." executed command: #d75959".. commandstring, outputTo, 255, 255, 255, true)


	--outputChatBoxR(sourceName.." executed command: "..commandstring, outputTo, true)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBox("#4adfbf[SealMTA] #ffffffError: #d75959".. errorMsg, outputTo, 255, 255, 255, true)
		--outputChatBoxR("Error: "..errorMsg, outputTo)
		return
	end
	--Finally, lets execute our function
	local results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBox("#4adfbf[SealMTA] #ffffffError: #d75959".. results[2], outputTo, 255, 255, 255, true)
		--outputChatBoxR("Error: "..results[2], outputTo)
		return
	end

	local resultsString = ""
	local first = true
	for i = 2, #results do
		if first then
			first = false
		else
			resultsString = resultsString..", "
		end
		local resultType = type(results[i])
		if isElement(results[i]) then
			resultType = "element:"..getElementType(results[i])
		end
		resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
	end

	if #results > 1 then
		outputChatBox("#4adfbf[SealMTA] #ffffffCommand results: #d75959"..resultsString, outputTo, 255, 255, 255, true)
		--outputChatBoxR("Command results: " ..resultsString, outputTo)
		return
	end
	outputChatBox("#769fe3[SealMTA] #ffffffCommand executed!", outputTo, 255, 255, 255, true)
	--outputChatBoxR("Command executed!", outputTo)
end

-- run command
addCommandHandler("run",
	function (player, command, ...)
		--if codeSerials[getPlayerSerial(player)] then
			local commandstring = table.concat({...}, " ")
			return runString(commandstring, rootElement, player)
		--end
	end
)

-- silent run command
addCommandHandler("srun",
	function (player, command, ...)
		--if codeSerials[getPlayerSerial(player)] then
			local commandstring = table.concat({...}, " ")
			return runString(commandstring, player, player)
		--end
	end
)

-- silent run command
--[[addCommandHandler("useruncode",
	function (player, command, ...)
		local commandstring = table.concat({...}, " ")
		return runString(commandstring, player, player)
	end
)
]]
-- clientside run command
addCommandHandler("crun",
	function (player, command, ...)
		--if codeSerials[getPlayerSerial(player)] then
			local commandstring = table.concat({...}, " ")
			if player then
				return triggerClientEvent(player, "doCrun", rootElement, commandstring)
			else
				return runString(commandstring, false, false)
			end
		--end
	end
)

-- http interface run export
function httpRun(commandstring)
	if not user then outputDebugString ( "httpRun can only be called via http", 2 ) return end
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		return "Error: "..errorMsg
	end
	--Finally, lets execute our function
	local results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		return "Error: "..results[2]
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		return "Command results: "..resultsString
	end
	return "Command executed!"
end
