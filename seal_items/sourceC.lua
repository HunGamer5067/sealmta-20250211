screenX, screenY = guiGetScreenSize()

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end


myriadpro = dxCreateFont("files/fonts/myriadpro.ttf", respc(18), false, "proof")

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		engineImportTXD(engineLoadTXD("files/taxi.txd", 1313), 1313)
		engineReplaceModel(engineLoadDFF("files/taxi.dff", 1313), 1313)
		engineImportTXD(engineLoadTXD("files/villogo.txd", 1314), 1314)
		engineReplaceModel(engineLoadDFF("files/villogo.dff", 1314), 1314)
		engineImportTXD(engineLoadTXD("files/lvmsbag.txd", 9006), 9006)
		engineReplaceModel(engineLoadDFF("files/lvmsbag.dff", 9006), 9006)
		engineImportTXD(engineLoadTXD("files/flex.txd", 1636), 1636)
		engineReplaceModel(engineLoadDFF("files/flex.dff", 1636), 1636)
	end
)

function showTooltip(x, y, text, subText, showItem)
	text = tostring(text)
	subText = subText and tostring(subText)

	if text == subText then
		subText = nil
	end

	local textW = dxGetTextWidth(text, 1, "clear", true) + resp(20)
	
	if subText then
		textW = math.max(textW, dxGetTextWidth(subText, 1, "clear", true) + resp(20))
		text = "#4adfbf" .. text .. "\n#ffffff" .. subText
	end

	local sy = resp(30)

	if subText then
		local _, lines = string.gsub(subText, "\n", "")
		
		sy = sy + resp(12) * (lines + 1)
	end

	local drawnOnTop = true

	if showItem then
		x = math.floor(x - textW / 2)
		drawnOnTop = false
	else
		x = math.max(0, math.min(screenX - textW, x))
		y = math.max(0, math.min(screenY - sy, y))
	end

	dxDrawRectangle(x, y, textW, sy, tocolor(0, 0, 0, 190), drawnOnTop)
	dxDrawText(text, x, y, x + textW, y + sy, tocolor(255, 255, 255), 0.5, myriadpro, "center", "center", false, false, drawnOnTop, true)
end

addEvent("setPlayerAlpha", true)
addEventHandler("setPlayerAlpha", resourceRoot, function(player)
	setElementAlpha(player, 120)
	setElementData(player, "invulnerable", true)
	if player == localPlayer then
		exports.seal_controls:toggleControl({"aim_weapon", "fire", "vehicle_fire", "vehicle_secondary_fire"}, false)
	end

	setElementData(player, "healTimer", true)

	setTimer(function(player)
		setElementData(player, "healTimer", false)
		setElementAlpha(player, 255)
		setElementData(player, "invulnerable", false)
		if player == localPlayer then
			exports.seal_controls:toggleControl({"aim_weapon", "fire", "vehicle_fire", "vehicle_secondary_fire"}, true)
		end
	end, 5000, 1, player)
end)

local screenX, screenY = guiGetScreenSize()
local width, height = 750, 475
local posX, posY = screenX / 2 - width / 2, screenY / 2 - height / 2

local isRendering = false

function renderWeaponshipMap()
	if isRendering then
    	dxDrawImage(posX, posY, width, height, "files/weaponship.png", 0, 0, 0)
	end
end
addEventHandler("onClientRender", root, renderWeaponshipMap)

addEvent("renderWsMap", true)
addEventHandler("renderWsMap", resourceRoot,
    function(state)
        isRendering = state
    end
)

addEvent("sendSound", true)
addEventHandler("sendSound", localPlayer,
	function()
		local sound = playSound("files/openclose.mp3", false)
	end
)