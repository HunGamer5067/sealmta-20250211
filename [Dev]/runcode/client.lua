me = localPlayer
--outputChatBoxR("#4adfbf[SealMTA] #ffffffCommand results: #d75959".. resultsString)
local function runString (commandstring)
	outputChatBoxR("#4adfbf[SealMTA] #ffffffExecuting client-side command: #d75959"..commandstring)
	--outputChatBoxR("Executing client-side command: "..commandstring)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBoxR("#4adfbf[SealMTA] #ffffffError: #d75959".. errorMsg)
		--outputChatBoxR("Error: "..errorMsg)
		return
	end
	--Finally, lets execute our function
	local results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBoxR("#4adfbf[SealMTA] #ffffffError: #d75959".. results[2])
		--outputChatBoxR("Error: "..results[2])
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
		outputChatBoxR("#4adfbf[SealMTA] #ffffffCommand results: #d75959".. resultsString)
		--outputChatBoxR("Command results: " ..resultsString)
		return
	end
	outputChatBoxR("#4adfbf[SealMTA] #ffffffCommand executed!")
	--outputChatBoxR("Command executed!")
end
--outputChatBox("#4adfbf[SealMTA] #ffffffCommand results: #d75959"..resultsString, outputTo, 255, 255, 255, true)
addEvent("doCrun", true)
addEventHandler("doCrun", root, runString)
