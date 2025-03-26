local chatPosX = 0
local chatPosY = 0
local chatMove = true

local chatWidth = false
local chatHeight = false
local chatResize = true

local inputHeight = 20

local oocChatPosX = 0
local oocChatPosY = 0
local oocChatMove = true

local oocChatWidth = false
local oocChatHeight = false
local oocChatResize = true

local oocChatVisible = true

local inputActive = false
local inputValue = ""
local canUseInput = false
local activeChatType = false

local chatMaxMessage = 55
local chatMessageNum = 0
local sentMessages = {}
local lastSentMessage = ""
local selectedMessage = 0

local oocChatMaxMessage = 10
local oocChatMessageNum = 0
local oocChatMessages = {}



addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		showChat(true)
	end)

function toggleChatInput(state)
	canUseInput = false
	
	if state then
		guiSetInputEnabled(true)
		showCursor(true)
		
		inputValue = ""
		lastSentMessage = inputValue
		selectedMessage = 0
		inputActive = true
		
		if activeChatType == "ooc" then
			oocChatInputSwitched()
		else
			chatInputSwitched()
		end
	else
		inputValue = ""
		lastSentMessage = inputValue
		inputActive = false
		
		if activeChatType == "ooc" then
			oocChatInputSwitched()
		else
			chatInputSwitched()
		end
		activeChatType = false
		
		guiSetInputEnabled(false)
		showCursor(false)
	end
	
	setElementData(localPlayer, "typing", inputActive or isChatBoxInputActive())
end

bindKey("t", "down",
	function ()
		if renderData.chatType == 1 and chatLoaded and not renderData.inTrash.chat then
			if not inputActive then
				activeChatType = "normal"
				toggleChatInput(true)
			end
		end
		
		setElementData(localPlayer, "typing", inputActive or isChatBoxInputActive())
	end)

bindKey("y", "down", "chatbox", "Rádió")
bindKey("y", "down",
	function ()
		if renderData.chatType == 1 and chatLoaded and not renderData.inTrash.chat then
			if not inputActive then
				activeChatType = "radio"
				toggleChatInput(true)
			end
		end
		
		setElementData(localPlayer, "typing", inputActive or isChatBoxInputActive())
	end)

addCommandHandler("Rádió",
	function (commandName, ...)
		if getElementData(localPlayer, "loggedIn") then
			local message = table.concat({...}, " ")
			
			if utf8.len(message) > 0 then
				local message2 = utf8.gsub(message, " ", "") or 0
	
				if utf8.len(message2) > 0 then
					triggerServerEvent("executeCommand", localPlayer, "r", message)
				end
			end
		end
	end)

bindKey("b", "down",
	function ()
		if renderData.chatType == 1 and chatLoaded and not renderData.inTrash.oocchat then
			if not inputActive then
				activeChatType = "ooc"
				toggleChatInput(true)
			end
		end
		
		setElementData(localPlayer, "typing", inputActive or isChatBoxInputActive())
	end)

function clearChatFunction()
	clearChatBox()
	chatMessageNum = 0
end
addCommandHandler("clearchat", clearChatFunction)
addCommandHandler("cc", clearChatFunction)

function clearOOCChatFunction()
	oocChatMessageNum = 0
	oocChatMessages = {}
end
addCommandHandler("clearooc", clearOOCChatFunction)
addCommandHandler("co", clearOOCChatFunction)

addEventHandler("onClientCharacter", getRootElement(),
	function (character)
		if renderData.chatType == 1 and inputActive then
			if utf8.len(inputValue) < 128 then
				if canUseInput then
					inputValue = inputValue .. character
					refreshChatInputText()
				end

				canUseInput = true
			end
		end
	end)

local repeatStartTimer = false
local repeatTimer = false

local function subFakeInputText()
	inputValue = utf8.sub(inputValue, 1, -2)
	refreshChatInputText()
end

local function sendMessage(message)
	if utf8.len(message) >= 1 then
		message = utf8.gsub(message, "#%x%x%x%x%x%x", "")

		if utf8.find(utf8.sub(message, 1, 1), "/") then
			local parts = split(message, " ")
			local command = utf8.gsub(parts[1], "/", "")

			table.remove(parts, 1)

			local args = table.concat(parts, " ")

			if not executeCommandHandler(command, args) then
				triggerServerEvent("executeCommand", localPlayer, command, args)
			end
		else
			if activeChatType == "radio" then
				triggerServerEvent("executeCommand", localPlayer, "r", message)
			elseif activeChatType == "ooc" then
				executeCommandHandler("b", message)
			else
				executeCommandHandler("say", message)
			end
		end

		table.insert(sentMessages, message)
		selectedMessage = 0
	end

	toggleChatInput(false)
end

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if renderData.chatType == 1 then
			if inputActive then
				if press then
					if key == "enter" or key == "num_enter" then
						cancelEvent()
						sendMessage(inputValue)
					elseif key == "backspace" then
						if utf8.len(inputValue) ~= 0 then
							inputValue = utf8.sub(inputValue, 1, -2)
							refreshChatInputText()

							repeatStartTimer = setTimer(
								function ()
									subFakeInputText()
									repeatTimer = setTimer(subFakeInputText, 50, 0)
								end,
							500, 1)
						end
					elseif key == "escape" then
						cancelEvent()
						toggleChatInput(false)
					elseif key == "arrow_u" then
						if sentMessages[selectedMessage + 1] or selectedMessage + 1 == 0 then
							selectedMessage = selectedMessage + 1
							
							if selectedMessage == 0 then
								inputValue = lastSentMessage
								refreshChatInputText()
							else
								inputValue = sentMessages[selectedMessage]
								refreshChatInputText()
							end
						end
					elseif key == "arrow_d" then
						if sentMessages[selectedMessage - 1] or selectedMessage - 1 == 0 then
							selectedMessage = selectedMessage - 1
							
							if selectedMessage == 0 then
								inputValue = lastSentMessage
								refreshChatInputText()
							else
								inputValue = sentMessages[selectedMessage]
								refreshChatInputText()
							end
						end
					end
				else
					if key == "backspace" then
						if isTimer(repeatStartTimer) then
							killTimer(repeatStartTimer)
						end
						
						if isTimer(repeatTimer) then
							killTimer(repeatTimer)
						end
					end
				end
			end
		end
	end)

chatRenderedOut = false

render.oocchat = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["oocchat"] and smoothMove then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["oocchat"] and  smoothMove < resp(224) then
		return
	end

	if isChatVisible() and oocChatVisible then
		dxDrawText("OOC Chat (eltüntetéshez /tog ooc)", x + 1, y + 1, 0, 0, tocolor(0, 0, 0), 1, "default-bold", "left", "top")
		dxDrawText("OOC Chat (eltüntetéshez /tog ooc)", x, y, 0, 0, tocolor(205, 205, 205), 1, "default-bold", "left", "top")

		for i = 1, #oocChatMessages do
			local v = oocChatMessages[i]

			dxDrawText(v[1], x + 1, y + (oocChatMessageNum + 1) * 15 - i * 15 + 1, 0, 0, tocolor(0, 0, 0), 1, "default-bold", "left", "top")
			dxDrawText(v[1], x, y + (oocChatMessageNum + 1) * 15 - i * 15, 0, 0, v[2], 1, "default-bold", "left", "top")
		end

		return true
	end

	return false
end

addEventHandler("onClientChatMessage", getRootElement(),
	function (msg, r, g, b)
		if r == 255 and g == 150 and b == 255 then
			return
		end
		
		local formatted = false

		if utf8.find(msg, "\n") then
			local lines = split(msg, "\n")

			for i = 1, #lines do
				outputChatBox(lines[i], 255, 255, 255, true)
			end

			return
		end

		chatMessageNum = chatMessageNum + 1
		
		if chatMessageNum > chatMaxMessage then
			chatMessageNum = chatMaxMessage
		end
	end, true, "high+99999")

addEvent("onClientRecieveOOCMessage", true)
addEventHandler("onClientRecieveOOCMessage", getRootElement(),
	function (msg, sender, spectated)
		oocChatMessageNum = oocChatMessageNum + 1

		if oocChatMessageNum > oocChatMaxMessage then
			oocChatMessageNum = oocChatMaxMessage
		end

		if #oocChatMessages >= oocChatMaxMessage then
			table.remove(oocChatMessages, oocChatMaxMessage)
		end

		local col = false

		if sender:find("#%x%x%x%x%x%x") then
			col = sender:match("#%x%x%x%x%x%x")
		end

		sender = sender:gsub("#%x%x%x%x%x%x", "")

		if spectated then
			sender = "[>o<] " .. sender
		end

		table.insert(oocChatMessages, 1, {sender .. ": (( " .. msg .. " ))", tocolor(hex2rgb(col))})
		
		outputConsole(sender .. ": (( " .. msg .. " ))")
	end)

function hex2rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

addCommandHandler("tog",
	function (commandName, str)
		if str == "ooc" or str == "OOC" then
			oocchatVisible = not oocchatVisible
		end
	end)

function getChatFontBackgroundAlpha()
	return renderData.chatFontBGAlpha
end

function getChatFontSize()
	return renderData.chatFontSize or 100
end