local streamedVehicles = {}
local transactions = {}
local hideHudTick = 0
local charset = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
local charsetEx = {}
for i = 1, #charset do
	charsetEx[charset[i]] = i
end
local hudMoving = true
local pressingHudKey = false
local plateTex = dxCreateTexture("files/plate.png", "dxt5")
local charsetTex = dxCreateTexture("files/charset.dds", "dxt5")

local zeroWidth = 0
local dollarWidth = 0
local lastMoney = 0
local lastMoneyTick = 0

renderData = {}
renderData.hudDisableNumber = 0
renderData.lastBarValue = {}
renderData.interpolationStartValue = {}
renderData.barInterpolation = {}
renderData.scrollX = 0

local hudState = true

function reMap(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

screenX, screenY = guiGetScreenSize()
responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end


function getHudCursorPos()
	if pressingHudKey then
		return getCursorPosition()
	else
		return false
	end
end

addCommandHandler("lodfix", function()
	engineStreamingFreeUpMemory(314572800)
end)
addCommandHandler("fixlod", function()
	engineStreamingFreeUpMemory(314572800)
end)

function loadFonts()
	Rubik = exports.seal_core:loadFont("BebasNeueRegular.otf", (12), false, "proof")
	RubikB = exports.seal_core:loadFont("BebasNeueRegular.otf", (24), false, "proof")
	Rubik2 = exports.seal_core:loadFont("BebasNeueRegular.otf", (30), false, "proof")
	RubikB2 = exports.seal_core:loadFont("BebasNeueRegular.otf", (12), false, "proof")
	RubikS = exports.seal_core:loadFont("BebasNeueRegular.otf", (10), false, "proof")
	RubikC = exports.seal_core:loadFont("BebasNeueRegular.otf", (15), false, "proof")
	moneyFont = exports.seal_core:loadFont("BebasNeueRegular.otf", (30), false, "proof")
	strongFont = exports.seal_core:loadFont("BebasNeueRegular.otf", (40), false, "proof")
	strongFont2 = exports.seal_core:loadFont("BebasNeueRegular.otf", (48), false, "proof")
	Rubik14 = exports.seal_core:loadFont("BebasNeueRegular.otf", (14), false, "proof")
	Rubik20 = exports.seal_core:loadFont("BebasNeueRegular.otf", (40), false, "proof")
	Rubik16 = exports.seal_core:loadFont("BebasNeueRegular.otf", (16), false, "proof")
	Rubik25 = exports.seal_core:loadFont("BebasNeueRegular.otf", (25), false, "proof")
	
	RobotoA = dxCreateFont("files/fonts/Roboto.ttf", (12), false, "antialiased")
	RobotoS = dxCreateFont("files/fonts/Roboto.ttf", (10), false, "antialiased")
	RobotoBB = dxCreateFont("files/fonts/RobotoB.ttf", (12), false, "antialiased")
	RobotoBJo = dxCreateFont("files/fonts/RobotoB.ttf", (24), false, "antialiased")

	BebasNeue14 = exports.seal_core:loadFont("BebasNeueRegular.otf", 14, false, "proof")
	BebasNeue15 = exports.seal_core:loadFont("BebasNeueRegular.otf", 15, false, "proof")
	BebasNeue16 = exports.seal_core:loadFont("BebasNeueRegular.otf", 16, false, "proof")

	Roboto = Rubik
	Roboto2 = exports.seal_core:loadFont("BebasNeueRegular.otf", (15), false, "proof")
	RobotoB = RubikB
	RobotoB2 = exports.seal_core:loadFont("BebasNeueRegular.otf", (45), false, "proof")
	BrushScriptStd = Rubik2
	RobotoBSmol = Rubik
	gtaFont = dxCreateFont("files/fonts/gtaFont2.ttf", 21, false, "proof")
	BITSU = Rubik14
	SpeedoBitsu = exports.seal_core:loadFont("BebasNeueRegular.otf", (55), false, "proof")
	SpeedoBitsu2 = Rubik16
end

loadFonts()

addEventHandler("onAssetsLoaded", getRootElement(),
	function ()
		loadFonts()
	end
)


local roundtexture = dxCreateTexture("files/images/round.png", "argb", true, "clamp")

function dxDrawRoundedRectangle(x, y, sx, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y, 5, 5, roundtexture, 0, 0, 0, color, postGUI)
	dxDrawRectangle(x, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y + sy - 5, 5, 5, roundtexture, 270, 0, 0, color, postGUI)
	dxDrawRectangle(x + 5, y, sx - 5 * 2, sy, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y, 5, 5, roundtexture, 90, 0, 0, color, postGUI)
	dxDrawRectangle(x + sx - 5, y + 5, 5, sy - 5 * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x + sx - 5, y + sy - 5, 5, 5, roundtexture, 180, 0, 0, color, postGUI)
end

function dxDrawSeeBar2(x, y, sx, sy, margin, progresscolor, progresscolor2, value, value2, key, key2, bgcolor, bordercolor)
	sx, sy = math.ceil(sx), math.ceil(sy)

	if value > 100 then
		value = 100
	end

	local lerpval = false

	if key then
		if renderData.lastBarValue[key] then
			if renderData.lastBarValue[key] ~= value then
				renderData.barInterpolation[key] = getTickCount()
				renderData.interpolationStartValue[key] = renderData.lastBarValue[key]
				renderData.lastBarValue[key] = value
			end
		else
			renderData.lastBarValue[key] = value
		end

		if renderData.barInterpolation[key] then
			lerpval = interpolateBetween(renderData.interpolationStartValue[key], 0, 0, value, 0, 0, (getTickCount() - renderData.barInterpolation[key]) / 250, "Linear")
		end
	end

	if lerpval then
		value = lerpval
	end

	local lerpval2 = false

	if key2 then
		if renderData.lastBarValue[key2] then
			if renderData.lastBarValue[key2] ~= value2 then
				renderData.barInterpolation[key2] = getTickCount()
				renderData.interpolationStartValue[key2] = renderData.lastBarValue[key2]
				renderData.lastBarValue[key2] = value2
			end
		else
			renderData.lastBarValue[key2] = value2
		end

		if renderData.barInterpolation[key2] then
			lerpval2 = interpolateBetween(renderData.interpolationStartValue[key2], 0, 0, value2, 0, 0, (getTickCount() - renderData.barInterpolation[key2]) / 250, "Linear")
		end
	end

	if lerpval2 then
		value2 = lerpval2
	end

	bordercolor = bordercolor or tocolor(0, 0, 0, 200)

	value = value / 2
	value2 = value2 / 2

	dxDrawRectangle(x , y , sx, sy, bgcolor or tocolor(0, 0, 0, 155)) -- háttér
	dxDrawRectangle(x , y , (sx) * (value / 100), sy, progresscolor) -- állapot 1
	dxDrawRectangle(x + margin + (sx) * 0.5, y , (sx) * (value2 / 100), sy, progresscolor2) -- állapot 2
	dxDrawRectangle(x + margin + (sx) * 0.5 - 1, y , 2, sy, tocolor(0, 0, 0, 200)) -- elválasztó
end

function dxDrawSeeBar(x, y, sx, sy, margin, colorOfProgress, value, key, bgcolor, bordercolor)
	sx, sy = math.ceil(sx), math.ceil(sy)

	if value > 100 then
		value = 100
	end

	local interpolatedValue = false

	if key then
		if renderData.lastBarValue[key] then
			if renderData.lastBarValue[key] ~= value then
				renderData.barInterpolation[key] = getTickCount()
				renderData.interpolationStartValue[key] = renderData.lastBarValue[key]
				renderData.lastBarValue[key] = value
			end
		else
			renderData.lastBarValue[key] = value
		end

		if renderData.barInterpolation[key] then
			interpolatedValue = interpolateBetween(renderData.interpolationStartValue[key], 0, 0, value, 0, 0, (getTickCount() - renderData.barInterpolation[key]) / 250, "Linear")
		end
	end

	if interpolatedValue then
		value = interpolatedValue
	end

	bordercolor = bordercolor or tocolor(0, 0, 0, 200)

	dxDrawRectangle(x, y, sx, sy, bgcolor or tocolor(0, 0, 0, 180)) -- háttér
	dxDrawRectangle(x, y, (sx) * (value / 100), sy, colorOfProgress) -- állapot
end

function dxDrawHudBar(x, y, w, h, color, value, key, devided)
    if x and y and w and h and color and key then
        local now = getTickCount()
        local barValue = value
        local newBarValue = false

        if key then
            if renderData.lastBarValue[key] then
                if renderData.lastBarValue[key] ~= barValue then
                    renderData.barInterpolation[key] = getTickCount()
                    renderData.interpolationStartValue[key] = renderData.lastBarValue[key]
                    renderData.lastBarValue[key] = barValue
                end
            else
                renderData.lastBarValue[key] = barValue
            end
    
            if renderData.barInterpolation[key] then
                newBarValue = interpolateBetween(renderData.interpolationStartValue[key], 0, 0, barValue, 0, 0, (now - renderData.barInterpolation[key]) / 250, "Linear")
            end
        end
    
        if newBarValue then
            barValue = newBarValue
        end

		if not devided then
        	dxDrawRectangle(x, y, w * barValue / 100, h, color)
		else
        	dxDrawRectangle(x, y, w * barValue, h, color)
		end
    end
end

local bordercolor = tocolor(0, 0, 0, 200)

function dxDrawImageSectionBorder(x, y, w, h, ux, uy, uw, uh, image, r, rx, ry, color, postGUI)
	dxDrawImageSection(x - 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x - 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x + 1, y - 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x + 1, y + 1, w, h, ux, uy, uw, uh, image, r, ry, rz, bordercolor, postGUI)
	dxDrawImageSection(x, y, w, h, ux, uy, uw, uh, image, r, ry, rz, color, postGUI)
end

renderData.browserX, renderData.browserY = 128, 256
iconSize = 32
iconList = {
  "heart",
  "shield",
  "cutlery",
  "arrows-alt",
  "refresh",
  "bolt",
  "life-ring"
}
iconSizes = {
  (14),
  (14),
  (14),
  (20),
  (48),
  (14),
  (14)
}
iconPOTSizes = {
  32,
  32,
  32,
  32,
  64,
  32,
  32
}

local nextMoneySound = 0

local currentWeaponDbID = false
local fireDisabled = false
local weaponItems = {}
local lastFireTick = {}
local overheated = {}
local currentHeat = {}
local heatIncreaseValue = {
	[22] = 7.5,
	[23] = 7.5,
	[24] = 16,
	[25] = 19,
	[26] = 16.25,
	[27] = 13.75,
	[28] = 3,
	[29] = 3,
	[30] = 3,
	[31] = 2.5,
	[32] = 4,
	[33] = 10,
	[34] = 10
}
local heatDecreaseValue = {
	[22] = 0.0098039215686275,
	[23] = 0.011764705882353,
	[24] = 0.007843137254902,
	[25] = 0.0049019607843137,
	[26] = 0.0073529411764706,
	[27] = 0.007843137254902,
	[28] = 0.0088235294117647,
	[29] = 0.011764705882353,
	[30] = 0.0098039215686275,
	[31] = 0.0093137254901961,
	[32] = 0.0088235294117647,
	[33] = 0.0088235294117647,
	[34] = 0.0088235294117647
}

local injureLeftFoot = false
local injureRightFoot = false
local injureLeftArm = false
local injureRightArm = false

local licenseExpire = {}

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "vehicle" then
			licenseExpire[source] = getElementData(source, " ")
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldVal)
		if dataName == "licenseExpire" then
			if isElementStreamedIn(source) then
				licenseExpire[source] = getElementData(source, "licenseExpire")
			end
		end
	end
)

addEventHandler("onClientElementDataChange", localPlayer,
	function (dataName, oldVal)
		if dataName == "loggedIn" then
			if getElementData(localPlayer, "loggedIn") then
				renderData.loggedIn = true
				renderData.currentMoney = getElementData(localPlayer, "char.Money") or 0
				renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0

				UbuntuR = exports.seal_gui:getFont("10/Ubuntu-R.ttf")
				bebasNeueLight = exports.seal_gui:getFont("6/BebasNeueLight.otf")
			end
		end

		if dataName == "char.injureLeftFoot" then
			injureLeftFoot = getElementData(localPlayer, "char.injureLeftFoot")
		end

		if dataName == "char.injureRightFoot" then
			injureRightFoot = getElementData(localPlayer, "char.injureRightFoot")
		end

		if dataName == "char.injureLeftArm" then
			injureLeftArm = getElementData(localPlayer, "char.injureLeftArm")
		end

		if dataName == "char.injureRightArm" then
			injureRightArm = getElementData(localPlayer, "char.injureRightArm")
		end

		if dataName == "char.Hunger" then
			renderData.currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		end

		if dataName == "char.Thirst" then
			renderData.currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		end

		if dataName == "bloodLevel" then
			renderData.bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
		end

		if dataName == "drugHunger" then
			renderData.drugHunger = getElementData(localPlayer, "drugHunger") or 0
		end

		if dataName == "tazerState" then
			renderData.tazerState = getElementData(localPlayer, "tazerState")
		end

		if dataName == "tazerReloadNeeded" then
			renderData.tazerReloadNeeded = getElementData(localPlayer, "tazerReloadNeeded")
		end

		if dataName == "char.slotCoins" then
			renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0
		end

		if dataName == "char.Money" then
			renderData.currentMoney = getElementData(localPlayer, "char.Money")

			local old = storedMoney or 0
			storedMoney = tonumber(getElementData(localPlayer, "char.Money")) or 0

			if renderData.inTrash.money then
				money = storedMoney
			else
				local d = storedMoney - (tonumber(old) or 0)
				if 0 < math.abs(d) then
					if not transactions[1] then
						if 0 < d then
					  		playSound("files/sounds/money.mp3")
						else
					  		playSound("files/sounds/money2.mp3")
						end
				  	end

				  	if not renderData.inTrash.money then
						local time = utf8.len(tostring(d)) * 2000
						time = time - 18000

						if time < 1000 then
					 		time = 1000
						end

						table.insert(transactions, {getTickCount(), d, money, storedMoney, time})
				  	else
						money = storedMoney
				  	end
				end
			end
		end

		if dataName == "currentWeaponDbID" then
			currentWeaponDbID = getElementData(localPlayer, "currentWeaponDbID")[1]
			weaponItems[currentWeaponDbID] = getElementData(localPlayer, "currentWeaponDbID")[2]

			if not overheated[currentWeaponDbID] and fireDisabled then
				fireDisabled = false
				exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
			end
		end

		if dataName == "char.Name" then
			renderData.characterName = getElementData(localPlayer, dataName)
		end

		if dataName == "playerID" then
			renderData.playerID = getElementData(localPlayer, dataName)
		end

		if dataName == "char.playedMinutes" then
			renderData.playedMinutes = getElementData(localPlayer, dataName) or 0
			renderData.currentLevel = exports.seal_core:getLevel(false, renderData.playedMinutes)
		end
	end)

addEventHandler("onClientRestore", root, 
	function ()
		for k, v in pairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				local plateText = getVehiclePlateText(v)
				local letters = {}
		
				local plateTextCharset = {}
				for i = 1, 8 do
					if utfLen(plateText) >= i then
						plateTextCharset[i] = string.lower(utfSub(plateText, i, i))
					end
				end
		
				for i = 1, #plateTextCharset do
					if charsetEx[plateTextCharset[i]] then
						local textIndex = charsetEx[plateTextCharset[i]]
						local x = ((textIndex % 4) - 1) * 32
						local y = math.floor(textIndex/4) * 64
						if textIndex % 4 == 0 then
							y = (math.floor(textIndex/4) * 64) - 64
						end
						letters[i] = {x, y}
					end
				end

				streamedVehicles[v] = letters
			end
		end
	end
)

local faTicks = {}
local gradientTick = {}

addEventHandler("refreshFaTicks", getRootElement(), function()
	faTicks = exports.seal_gui:getFaTicks()
end)

addEventHandler("refreshGradientTick", getRootElement(), function()
	gradientTick = exports.seal_gui:getGradientTick()
end)

local guiRefreshColors = function()
	local res = getResourceFromName("seal_gui")
	if res and getResourceState(res) == "running" then
		bloodColor = exports.seal_gui:getColorCode("red")
		hudWhite = exports.seal_gui:getColorCodeToColor("hudwhite")

		grey1 = exports.seal_gui:getColorCode("grey1")
		grey2 = exports.seal_gui:getColorCode("grey2")

		blue = exports.seal_gui:getColorCode("blue")

		moneyHex = exports.seal_gui:getColorCodeHex("primary")
		moneyMinusHex = exports.seal_gui:getColorCodeHex("red")

		fpsGreen = exports.seal_gui:getColorCodeToColor("primary")
		fpsLightGrey = exports.seal_gui:getColorCodeToColor("lightgrey")
		fpsGrey = bitReplace(exports.seal_gui:getColorCodeToColor("grey1"), 174, 24, 8)
		fpsYellow = exports.seal_gui:getColorCodeToColor("yellow")
		fpsRed = exports.seal_gui:getColorCodeToColor("red")
		fpsOrange = exports.seal_gui:getColorCodeToColor("orange")

		barColors = {
			bitReplace(exports.seal_gui:getColorCodeToColor("grey1"), 174, 24, 8),
			exports.seal_gui:getColorCodeToColor("primary"),
			exports.seal_gui:getColorCodeToColor("blue"),
			exports.seal_gui:getColorCodeToColor("yellow"),
			exports.seal_gui:getColorCodeToColor("blue-second"),
			exports.seal_gui:getColorCode("hudwhite"),
		}
	  
		hpBloodGradient = exports.seal_gui:getGradient3Filename(350, 2, bloodColor, exports.seal_gui:getColorCode("primary"))

		fpsFont = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		fpsFontScale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")
		fpsFontH = exports.seal_gui:getFontHeight("15/BebasNeueBold.otf")

		radarFont = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		radarFontScale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")

		locationFont = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		locationFontScale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")

		gpuFont = exports.seal_gui:getFont("11/Ubuntu-L.ttf")
		gpuFontH = exports.seal_gui:getFontHeight("11/Ubuntu-L.ttf")

		moneyWidgetFont = exports.seal_gui:getFont("22/BebasNeueBold.otf")
		moneyWidgetFontScale = exports.seal_gui:getFontScale("22/BebasNeueBold.otf")

		dataFont = exports.seal_gui:getFont("15/BebasNeueBold.otf")
		dataFontScale = exports.seal_gui:getFontScale("15/BebasNeueBold.otf")

		UbuntuR = exports.seal_gui:getFont("10/Ubuntu-R.ttf")
		bebasNeueLight = exports.seal_gui:getFont("6/BebasNeueLight.otf")

		faTicks = exports.seal_gui:getFaTicks()
		gradientTick = exports.seal_gui:getGradientTick()
	end
end
addEventHandler("onGuiRefreshColors", getRootElement(), guiRefreshColors)
addEventHandler("onClientResourceStart", getResourceRootElement(), guiRefreshColors)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		if screenX < 1024 then
			triggerServerEvent("kickPlayerCuzScreenSize", localPlayer)
		end

		storedMoney = getElementData(localPlayer, "char.Money") or 0
		money = getElementData(localPlayer, "char.Money") or 0
	
		for k, v in pairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				local plateText = getVehiclePlateText(v)
				local letters = {}
		
				local plateTextCharset = {}
				for i = 1, 8 do
					if utfLen(plateText) >= i then
						plateTextCharset[i] = string.lower(utfSub(plateText, i, i))
					end
				end
		
				for i = 1, #plateTextCharset do
					if charsetEx[plateTextCharset[i]] then
						local textIndex = charsetEx[plateTextCharset[i]]
						local x = ((textIndex % 4) - 1) * 32
						local y = math.floor(textIndex/4) * 64
						if textIndex % 4 == 0 then
							y = (math.floor(textIndex/4) * 64) - 64
						end
						letters[i] = {x, y}
					end
				end

				streamedVehicles[v] = letters
			end
		end

		for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
			licenseExpire[v] = getElementData(v, "licenseExpire") or false
		end

		for k, v in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				local plateText = getVehiclePlateText(v)
				local letters = {}

				local plateTextCharset = {}
				for i = 1, 8 do
					if utfLen(plateText) >= i then
						plateTextCharset[i] = string.lower(utfSub(plateText, i, i))
					end
				end

				for i = 1, #plateTextCharset do
					if charsetEx[plateTextCharset[i]] then
						local textIndex = charsetEx[plateTextCharset[i]]
						local x = ((textIndex % 4) - 1) * 32
						local y = math.floor(textIndex/4) * 64
						if textIndex % 4 == 0 then
							y = (math.floor(textIndex/4) * 64) - 64
						end
						letters[i] = {x, y}
					end
				end
				streamedVehicles[v] = letters
			end
		end

		guiSetInputMode("no_binds_when_editing")
		resetHudElement("all")

		renderData.loggedIn = getElementData(localPlayer, "loggedIn")
		renderData.currentMoney = getElementData(localPlayer, "char.Money") or 0
		renderData.currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		renderData.currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		renderData.currentSlotcoin = getElementData(localPlayer, "char.slotCoins") or 0
		renderData.characterName = getElementData(localPlayer, "char.Name")
		renderData.playerID = getElementData(localPlayer, "playerID") or 0
		renderData.playedMinutes = getElementData(localPlayer, "char.playedMinutes") or 0
		renderData.currentLevel = exports.seal_core:getLevel(false, renderData.playedMinutes)
		renderData.bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
		renderData.drugHunger = getElementData(localPlayer, "drugHunger") or 0
		renderData.tazerState = getElementData(localPlayer, "tazerState")
		renderData.tazerReloadNeeded = getElementData(localPlayer, "tazerReloadNeeded")

		local currentWeapon = getElementData(localPlayer, "currentWeaponDbID")
		
		if getElementData(localPlayer, "currentWeaponDbID") then
			currentWeaponDbID = currentWeapon[1]
			weaponItems[currentWeaponDbID] = currentWeapon[2]
		end

		injureLeftFoot = getElementData(localPlayer, "char.injureLeftFoot")
		injureRightFoot = getElementData(localPlayer, "char.injureRightFoot")
		injureLeftArm = getElementData(localPlayer, "char.injureLeftArm")
		injureRightArm = getElementData(localPlayer, "char.injureRightArm")
		
		bindKey("r", "down", "reloadmyweapon")

		loadPositions()

		setPlayerHudComponentVisible("all", true)
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		loadHUD()
	end)

addEventHandler("onClientResourceStop", getResourceRootElement(),
 	function()
		if isElement(Roboto) then
		  destroyElement(Roboto)
		end
		if isElement(RobotoB) then
		  destroyElement(RobotoB)
		end
		if isElement(BrushScriptStd) then
		  destroyElement(BrushScriptStd)
		end
		saveHUD()
	end
)

local lastReloadTime = 0
local blockedTasks = {
	TASK_SIMPLE_IN_AIR = true,
	TASK_SIMPLE_JUMP = true,
	TASK_SIMPLE_LAND = true,
	TASK_SIMPLE_GO_TO_POINT = true,
	TASK_SIMPLE_NAMED_ANIM = true,
	TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE = true,
	TASK_SIMPLE_CAR_GET_IN = true,
	TASK_SIMPLE_CLIMB = true,
	TASK_SIMPLE_SWIM = true,
	TASK_SIMPLE_HIT_HEAD = true,
	TASK_SIMPLE_FALL = true,
	TASK_SIMPLE_GET_UP = true
}

addCommandHandler("reloadmyweapon",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			if getPedTask(localPlayer, "secondary", 0) ~= "TASK_SIMPLE_USE_GUN" then
				if not blockedTasks[getPedSimplestTask(localPlayer)] then
					if getTickCount() - lastReloadTime >= 500 then
						triggerServerEvent("reloadPlayerWeapon", localPlayer)
						lastReloadTime = getTickCount()

						if getElementData(localPlayer, "tazerReloadNeeded") then
							exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
							setElementData(localPlayer, "tazerReloadNeeded", false)
						end
					end
				end
			end
		end
	end)

renderData.moving = {}
renderData.resizing = false
renderData.selectedHUD = {}
renderData.move = {}
renderData.pos = {}
renderData.inTrash = {}
renderData.resizable = {}
renderData.size = {}
renderData.resizingLimitMin = {}
renderData.resizingLimitMax = {}
renderData.placeholder = {}

function resetHudElement(element, toTrash)
	renderData.moving = {}
	renderData.resizing = false
	renderData.selectedHUD = {}

	if element == "bars" or element == "all" then
		if not toTrash then
			renderData.pos.barsX, renderData.pos.barsY = screenX - 316, 48
			renderData.inTrash.bars = false
			renderData.resizable.bars = false
			--renderData.resizingLimitMin.barsX, renderData.resizingLimitMax.barsX, renderData.resizingLimitMin.barsY, renderData.resizingLimitMax.barsY = 100, 350, 40, 128
		end

		renderData.size.barsX, renderData.size.barsY = 300, 44
	end

	if element == "minimap" or element == "all" then
		if not toTrash then
			renderData.inTrash.minimap = false
			renderData.resizingLimitMin.minimapX, renderData.resizingLimitMin.minimapY = (200), (110)
			renderData.resizingLimitMax.minimapX, renderData.resizingLimitMax.minimapY = (625), (495)
			renderData.resizable.minimap = true
			renderData.pos.minimapX, renderData.pos.minimapY = (12), screenY - (240) - (12)
			renderData.placeholder.minimap = "MINIMAP"
		end

		renderData.size.minimapX, renderData.size.minimapY = (320), (240)
	end


	--[[
	if element == "stamina" or element == "all" then
		if not toTrash then
			renderData.inTrash.stamina = false
			renderData.pos.staminaX, renderData.pos.staminaY = screenX - (250) - math.ceil((12)), math.ceil((12) + (12) * 3 + (7) * 3)
			renderData.resizable.stamina = true
			renderData.resizingLimitMin.staminaX, renderData.resizingLimitMax.staminaX, renderData.resizingLimitMin.staminaY, renderData.resizingLimitMax.staminaY = (50), (400), (12), (12)
		end

		renderData.size.staminaX, renderData.size.staminaY = (250), (12)
	end
	]]


	if (element == "phone" or element == "all") and not toTrash then
		renderData.inTrash.phone = false
		renderData.pos.phoneX, renderData.pos.phoneY = screenX - resp(250) - math.ceil(resp(12)), math.ceil(resp(12)) + resp(12) * 3 + 21 + resp(32.5) + resp(192)
		renderData.placeholder.phone = "TELEFON"
	end

	if element == "bone" or element == "all" then
		if not toTrash then
			renderData.inTrash.bone = false
			renderData.pos.boneX, renderData.pos.boneY = screenX - (305) - math.ceil((12)) - (23), (14.5) + (21)
		end
	end

	if element == "money" or element == "all" then
		if not toTrash then
			renderData.pos.moneyX, renderData.pos.moneyY = screenX - 166, 92
			renderData.inTrash.money = false
			renderData.resizingLimitMin.moneyX, renderData.resizingLimitMax.moneyX, renderData.resizingLimitMin.moneyY, renderData.resizingLimitMax.moneyY = 128, 350, 0, 0
			renderData.resizable.money = false
		end

		renderData.size.moneyX, renderData.size.moneyY = 150, 48
	end

	if element == "infobox" or element == "all" then
		if not toTrash then
			renderData.inTrash.infobox = false
			renderData.pos.infoboxX, renderData.pos.infoboxY = screenX / 2 - (256), (10)
			renderData.placeholder.infobox = "INFOBOX"
		end
	end

	if element == "kickbox" or element == "all" then
		if not toTrash then
			renderData.inTrash.kickbox = false
			renderData.pos.kickboxX, renderData.pos.kickboxY = (12), screenY - (225) - (17) - (45) * 5
			renderData.placeholder.kickbox = "KICK/BAN"
		end
	end

	if element == "oocchat" or element == "all" then
		if not toTrash then
			renderData.inTrash.oocchat = false
			renderData.pos.oocchatX, renderData.pos.oocchatY = (30), (getChatboxLayout().chat_scale[2] * getChatboxLayout().chat_lines) + 16 + 15 * getChatboxLayout().chat_lines + 5
			renderData.resizable.oocchat = true
			renderData.resizingLimitMin.oocchatX, renderData.resizingLimitMax.oocchatX, renderData.resizingLimitMin.oocchatY, renderData.resizingLimitMax.oocchatY = (300), (1000), (200), (600)
		end

		renderData.size.oocchatX, renderData.size.oocchatY = (400), (200)
	end
	--[[
	if (element == "phone" or element == "all") and not toTrash then
		renderData.inTrash.phone = false
		renderData.pos.phoneX, renderData.pos.phoneY = screenX - (250) - math.ceil((12)), math.ceil((12)) + (12) * 3 + 21 + (32.5) + (192)
		renderData.placeholder.phone = "TELEFON"
	end
	]]
	if element == "actionbar" or element == "all" then
		if not toTrash then
			renderData.inTrash.actionbar = false
			renderData.pos.actionbarX, renderData.pos.actionbarY = screenX / 2 - 237 / 2, screenY - 48
		end
	end

	if element == "slotcoin" or element == "all" then
		if not toTrash then
			renderData.inTrash.slotcoin = true
			renderData.pos.slotcoinX, renderData.pos.slotcoinY = 0, 0
			renderData.resizingLimitMin.slotcoinX, renderData.resizingLimitMax.slotcoinX, renderData.resizingLimitMin.slotcoinY, renderData.resizingLimitMax.slotcoinY = 100, 350, 0, 0
			renderData.resizable.slotcoin = false
		end

		renderData.size.slotcoinX, renderData.size.slotcoinY = 192, 0
	end

	if (element == "weapons" or element == "all") and not toTrash then
		renderData.inTrash.weapons = false
		renderData.pos.weaponsX, renderData.pos.weaponsY = screenX - 250 - 12, 17 + 12 * 3 + 21 + 65
	end

	if (element == "fps" or element == "all") and not toTrash then
		renderData.pos.fpsX, renderData.pos.fpsY = screenX / 2, screenY / 2
		renderData.size.fpsX, renderData.size.fpsY = 75, 32
		renderData.resizingLimitMin.fpsX, renderData.resizingLimitMax.fpsX, renderData.resizingLimitMin.fpsY, renderData.resizingLimitMax.fpsY = 75, 128, 0, 0
		renderData.resizable.fps = false
		renderData.inTrash.fps = true
	end

	if (element == "clock" or element == "all") and not toTrash then
		renderData.pos.clockX, renderData.pos.clockY = screenX / 2, screenY / 2
		renderData.size.clockX, renderData.size.clockY = 75, 32
		renderData.resizingLimitMin.clockX, renderData.resizingLimitMax.clockX, renderData.resizingLimitMin.clockY, renderData.resizingLimitMax.clockY = 75, 128, 0, 0
		renderData.resizable.clock = false
		renderData.inTrash.clock = true
	end

	if (element == "vstats" or element == "all") and not toTrash then
		renderData.pos.vstatsX, renderData.pos.vstatsY = screenX / 2 - 150, screenY / 2 - 500
		renderData.size.vstatsX, renderData.size.vstatsY = 300, 100
		renderData.inTrash.vstats = true
	end

	if (element == "ping" or element == "all") and not toTrash then
		renderData.pos.pingX, renderData.pos.pingY = screenX / 2, screenY / 2
		renderData.size.pingX, renderData.size.pingY = 75, 32
		renderData.resizingLimitMin.pingX, renderData.resizingLimitMax.pingX, renderData.resizingLimitMin.pingY, renderData.resizingLimitMax.pingY = 75, 128, 0, 0
		renderData.resizable.ping = false
		renderData.inTrash.ping = true
	end

	if (element == "stats" or element == "all") and not toTrash then
		if not toTrash then
			renderData.inTrash.stats = false
			renderData.pos.statsX, renderData.pos.statsY = screenX - 316, 16
			renderData.resizingLimitMin.statsX, renderData.resizingLimitMax.statsX, renderData.resizingLimitMin.statsY, renderData.resizingLimitMax.statsY = 128, 350, 0, 0
			renderData.resizable.stats = false
		end

		renderData.size.statsX, renderData.size.statsY = 300, 32
	end



	if (element == "speedo" or element == "all") and not toTrash then
		renderData.inTrash.speedo = false
		renderData.pos.speedoX, renderData.pos.speedoY = screenX - 6 - 255, screenY - 6 - 253
		renderData.placeholder.speedo = "KILÓMÉTERÓRA"
	end

	-- if (element == "turbo" or element == "all") and not toTrash then
	-- 	renderData.inTrash.turbo = false
	-- 	renderData.pos.turboX, renderData.pos.turboY = screenX - 6 - 320 - 6 - 230, screenY - 206
	-- 	renderData.placeholder.turbo = "TURBO"
	-- 	renderData.size.turboX, renderData.size.turboY = 200, 200
	-- end
end

function resetHudElements()
	resetHudElement("all")
end
addCommandHandler("resethud", resetHudElements)

render = {}
hudrender = {}

local hudElements = {
	"chat",
	"oocchat",
	"phone",
	"bars",
	--"stamina",
	"money",
	"infobox",
	"kickbox",
	"actionbar",
	"slotcoin",
	"weapons",
	"fps",
	"clock",
	"vstats",
	"ping",
	"stats",
	"minimap",
	"speedo",
	-- "turbo",
	--"speedoicon",
	--"fuel",
	--"carname",
	"bone",
	"traffi"
}
local lastActionBarX = 9999
local lastActionBarY = 9999
local actionBarState = true

function processActionBarShowHide(state)
	if actionBarState ~= state then
		actionBarState = state
		exports.seal_items:processActionBarShowHide(state)
	end
end

render.actionbar = function (x, y)
	local sx, sy = 240, 46

	dxDrawRectangle(x - 3, y - 3, 237, 42, tocolor(22, 22, 22, 210))

	if lastActionBarX ~= x or lastActionBarY ~= y then
		lastActionBarX = x
		lastActionBarY = y
		exports.seal_items:changeItemStartPos(x, y)
	end

	return true
end

addEvent("requestChangeItemStartPos", true)
addEventHandler("requestChangeItemStartPos", localPlayer,
	function()
		lastActionBarX, lastActionBarY = 9999, 9999
	end)

render.bone = function (x, y)
	x, y = math.floor(x), math.floor(y)

	if injureRightArm or injureLeftArm or injureRightFoot or injureLeftFoot then
		dxDrawImage(x, y, (18), (46), "files/images/bone.png", 0, 0, 0, tocolor(0, 0, 0, 200))

		if injureRightArm then
			dxDrawImage(x, y, (18), (46), "files/images/injureRightArm.png", 0, 0, 0)
		end

		if injureLeftArm then
			dxDrawImage(x, y, (18), (46), "files/images/injureLeftArm.png", 0, 0, 0)
		end

		if injureRightFoot then
			dxDrawImage(x, y, (18), (46), "files/images/injureRightFoot.png", 0, 0, 0)
		end

		if injureLeftFoot then
			dxDrawImage(x, y, (18), (46), "files/images/injureLeftFoot.png", 0, 0, 0)
		end
	end
end

local traffiRadarState = false
local traffiColShape = false
local traffiArrowsTexture = false
local radarInterpolation = 0
local radarSoundPlayed = false
local radarSoundEnabled = true

addEventHandler("onClientColShapeHit", getRootElement(),
	function (hitElement)
		if hitElement == getPedOccupiedVehicle(localPlayer) then
			if traffiRadarState and not traffiColShape then
				if isElement(source) then
					if getElementData(source, "bigSpeedCam") then
						traffiColShape = source
						traffiArrowsTexture = dxCreateTexture("files/images/traf1.png")
						dxSetTextureEdge(traffiArrowsTexture, "border", tocolor(0, 0, 0, 0))
					end
				end
			end
		end
	end)

addEventHandler("onClientColShapeLeave", getRootElement(),
	function (leaveElement)
		if leaveElement == getPedOccupiedVehicle(localPlayer) then
			if source == traffiColShape then
				traffiColShape = false

				if isElement(traffiArrowsTexture) then
					destroyElement(traffiArrowsTexture)
				end

				traffiArrowsTexture = nil
			end
		end
	end)

addCommandHandler("mutetraffi",
	function ()
		if radarSoundEnabled then
			outputChatBox("#4adfbf[SeeMTA - Traffipax radar]: #ffffffSikeresen kikapcsoltad a radar hangját.", 255, 255, 255, true)
			radarSoundEnabled = false
		else
			outputChatBox("#4adfbf[SeeMTA - Traffipax radar]: #ffffffSikeresen bekapcsoltad a radar hangját.", 255, 255, 255, true)
			radarSoundEnabled = true
		end
	end)

render.traffi = function (x, y)
	local currVeh = getPedOccupiedVehicle(localPlayer)

	if not currVeh then
		traffiRadarState = "nodata"

		if isElement(traffiArrowsTexture) then
			destroyElement(traffiArrowsTexture)
		end

		traffiArrowsTexture = nil
	elseif traffiRadarState == "nodata" then
		traffiRadarState = getElementData(currVeh, "traffipaxRadarInVehicle")
	end

	if currVeh and traffiRadarState then
		if traffiColShape and not isElement(traffiColShape) then
			traffiColShape = false
		end
		x, y = math.floor(x), math.floor(y)
		sx, sy = (274), (45)

		bordercolor = bordercolor or tocolor(0, 0, 0, 200)

		dxDrawRectangle(x, y, sx, 2, bordercolor)
		dxDrawRectangle(x, y + sy - 2, sx, 2, bordercolor)
		dxDrawRectangle(x, y + 2, 2, sy - 4, bordercolor)
		dxDrawRectangle(x + sx - 2, y + 2, 2, sy - 4, bordercolor)

		dxDrawRectangle(x, y, sx, sy, tocolor(0, 0, 0, 150))

		local diffZ = 0
		local dist = 0

		if traffiColShape then
			local vehX, vehY, vehZ = getElementPosition(currVeh)
			local colX, colY, colZ = getElementPosition(traffiColShape)
			
			dist = getDistanceBetweenPoints2D(vehX, vehY, colX, colY)

			if dist < 45 then
				dist = 45
			end

			diffZ = math.abs(vehZ - colZ)
		end

		if not traffiColShape or diffZ >= 10 then
			dxDrawImage(x, y, sx, sy, "files/images/traf1.png", 0, 0, 0, tocolor(50, 50, 50, 200))
			dxDrawImage(x, y, sx, sy, "files/images/traf2.png", 0, 0, 0, tocolor(50, 50, 50, 200))
			dxDrawText(math.floor(getVehicleSpeed(currVeh)) .. "KM/H", x, y + (34), x + sx, y + sy - (5), tocolor(50, 50, 50, 200), 0.75, Roboto, "center", "center")
		else
			local elapsedTime = getTickCount() - radarInterpolation
			local progress = elapsedTime / (750 * (dist / 175))

			if progress > 0.1 then
				radarSoundPlayed = false
			end

			if progress >= 1 then
				radarInterpolation = getTickCount()

				if not radarSoundPlayed then
					if radarSoundEnabled then
						playSound("files/sounds/traffi.mp3")
					end

					radarSoundPlayed = true
				end
			end

			dxDrawImage(x, y, sx, sy, "files/images/traf1.png", 0, 0, 0, tocolor(50, 50, 50, 200))
			dxDrawImage(x, y, sx, sy, "files/images/traf2.png", 0, 0, 0, tocolor(215, 89, 89, 200))
			
			local x2 = x + sx / 2 - (sx / 2 + (40)) * progress

			dxDrawImageSection(x2, y, (40), sy, 137 - 177 * progress, 0, 40, 45, traffiArrowsTexture, 0, 0, 0, tocolor(74, 223, 191, 200))
			dxDrawImageSection(x2, y, (40), sy, 137 - 177 * progress, 0, 40, 45, traffiArrowsTexture, 180, (sx / 2 + 40) * progress - 20, 0, tocolor(74, 223, 191, 200))
			
			dxDrawText(math.floor(getVehicleSpeed(currVeh)) .. "KM/H", x, y + (34), x + sx, y + sy - (5), tocolor(215, 89, 89, 200), 0.75, Roboto, "center", "center")
		end

		return true
	else
		return false
	end
end

render.bars = function(x, y)
	local w, h = renderData.size.barsX, math.floor((renderData.size.barsY - 16) / 3)

	if w and h then
		local health = math.floor(getElementHealth(localPlayer))
		local armor = math.floor(getPedArmor(localPlayer))
		local oxygen = getPedOxygenLevel(localPlayer) / 1000
		local stamina = getStamina()
		
		dxDrawRectangle(x, y, w, h, barColors[1])
		dxDrawRectangle(x, y + h + 8, w, h, barColors[1])
		dxDrawRectangle(x, y + (h + 8) * 2, w, h, barColors[1])

		if health < 20 then
			dxDrawHudBar(x, y, w / 2, h, tocolor(bloodColor[1], bloodColor[2], bloodColor[3]), health, "health")
		else
			dxDrawHudBar(x, y, w / 2, h, barColors[2], health, "health")

			if renderData.bloodLevel < 100 then
				local pulse = getTickCount() % 2000 / 1000

				if 1 < pulse then
					pulse = 2 - pulse
			  	end

			  	pulse = getEasingValue(pulse, "InOutQuad")
			  	dxDrawImage(x, y, math.floor(w / 2 * health / 100), h, ":seal_gui/" .. hpBloodGradient .. "." .. gradientTick[hpBloodGradient], 0, 0, 0, tocolor(255, 255, 255, 255 * (0.75 + 0.25 * pulse)))
			end
		end

		dxDrawImage(x - 25, y - 2, 14, 14, "files/hp.png", 0, 0, 0, tocolor(50, 186, 157, 255))
		dxDrawImage(x - 25, y + 15, 14, 14, "files/hunger.png", 0, 0, 0, tocolor(243, 214, 90, 255))
		dxDrawImage(x - 25, y + 32, 14, 14, "files/stamina.png", 0, 0, 0, tocolor(255, 255, 255, 255))

		dxDrawHudBar(x + w / 2, y, w / 2, h, barColors[3], armor, "armor")
		dxDrawHudBar(x, y + h + 8, w / 2, h, barColors[4], renderData.currentHunger, "hunger")
		dxDrawHudBar(x + w / 2, y + h + 8, w / 2, h, barColors[5], renderData.currentThirst, "thirst")

		local r, g, b = barColors[6][1], barColors[6][2], barColors[6][3]
		if stamina < 50 then
			r = r * (0.6 + stamina / 50 * 0.4)
			g = g * (0.6 + stamina / 50 * 0.4)
			b = b * (0.6 + stamina / 50 * 0.4)
		end

		if oxygen < 1 then
			dxDrawHudBar(x, y + (h + 8) * 2, w,  h, barColors[5], math.max(0, oxygen), "oxygen", true)
		else
			dxDrawHudBar(x, y + (h + 8) * 2, w, h, tocolor(r, g, b), math.max(0, stamina / 100), "stamina", true)
		end
	end
end

render.money = function (x, y)
	local text = ""

	local zeroWidth = exports.seal_gui:getTextWidthFont("0", "22/BebasNeueBold.otf")
	local dollarWidth = exports.seal_gui:getTextWidthFont(" $", "22/BebasNeueBold.otf")
	local moneyZeros = math.floor((renderData.size.moneyX - dollarWidth) / zeroWidth + 0.5)

	if transactions and transactions[1] then
		prog = math.min((getTickCount() - transactions[1][1]) / transactions[1][5], 1)
		money = math.floor(transactions[1][3] + (transactions[1][4] - transactions[1][3]) * prog)

		if lastMoney ~= money then
		  lastMoney = money

		  	if getTickCount() - lastMoneyTick > 30 then
				lastMoneyTick = getTickCount()
				playSound("files/sounds/moneycount.mp3")
		  	end
		end
	end

	local negative = money < 0
	local val = tostring(math.min(money, math.pow(10, moneyZeros) - 1))

	if negative then
		x = x + zeroWidth * (moneyZeros - utf8.len(val))
	else
		for k = 1, moneyZeros - utf8.len(val) do
			dxDrawText("0", x, y, x + zeroWidth, y + renderData.size.moneyY, hudWhite, moneyWidgetFontScale, moneyWidgetFont, "center", "center", false, false, false, true)
		  	x = x + zeroWidth
		end
	end

	local col = moneyHex
	if negative then
		col = moneyMinusHex
	end

	for k = 1, utf8.len(val) do
		dxDrawText(col .. utf8.sub(val, k, k), x, y, x + zeroWidth, y + renderData.size.moneyY, hudWhite, moneyWidgetFontScale, moneyWidgetFont, "center", "center", false, false, false, true)
		x = x + zeroWidth
	end
	dxDrawText(col .. " $", x, y, x + zeroWidth, y + renderData.size.moneyY, hudWhite, moneyWidgetFontScale, moneyWidgetFont, "center", "center", false, false, false, true)

	if transactions[1] then
		if getTickCount() - transactions[1][1] >= transactions[1][5] then
		  	money = transactions[1][4]
		  	table.remove(transactions, 1)

		  	if transactions[1] then
				if 0 < transactions[1][2] then
			  		playSound("files/sounds/money.mp3")
				else
			  		playSound("files/sounds/money2.mp3")
				end
				
				transactions[1][1] = getTickCount()
				transactions[1][3] = money
		  	end
		else
		  	local prog = math.min((getTickCount() - transactions[1][1]) / transactions[1][5], 1)
		  	local y2 = renderData.size.moneyY + 5
		  	local a = 255 - prog * 255

		  	dxDrawText((0 < transactions[1][2] and moneyHex or moneyMinusHex) ..  (0 < transactions[1][2] and "+" or "") .. transactions[1][2] .. " $",  x - renderData.size.moneyX, y + y2, x + renderData.size.moneyX, y + y2 + 16,  bitReplace(hudWhite, math.min(255, a * 1.5), 24, 8),  moneyWidgetFontScale * 0.9,  moneyWidgetFont,  "left", "center",  false,  false,  true,  true)
		end
	end
end



render.slotcoin = function (x, y)
	local currentVal = renderData.currentSlotcoin
	local str = ""
	local textWidth = 0

	if tonumber(renderData.currentSlotcoin) < 0 then
		textWidth = dxGetTextWidth("- " .. renderData.currentSlotcoin .. " SC", 1, gtaFont)
	else
		textWidth = dxGetTextWidth(renderData.currentSlotcoin .. " SC", 1, gtaFont)
	end

	renderData.resizingLimitMin.slotcoinX = textWidth

	if renderData.resizingLimitMin.slotcoinX < 100 then
		renderData.resizingLimitMin.slotcoinX = 100
	end

	if renderData.size.slotcoinX < renderData.resizingLimitMin.slotcoinX then
		renderData.size.slotcoinX = renderData.resizingLimitMin.slotcoinX
	end

	for i = 1, math.floor((renderData.size.slotcoinX - textWidth) / dxGetTextWidth("0", 1, gtaFont)) + string.len(renderData.currentSlotcoin) - utfLen(currentVal) do
		str = str .. "0"
	end

	if tonumber(currentVal) < 0 then
		currentVal = "#f55151" .. math.abs(currentVal)
	elseif tonumber(currentVal) > 0 then
		currentVal = "#32b2ee" .. math.abs(currentVal)
	else
		currentVal = 0
	end

	str = str .. currentVal

	if tonumber(renderData.currentSlotcoin) < 0 then
		str = "- " .. str
	end

	str = str .. "#eaeaea"

	dxDrawBorderText(str .. " SC", x, y, x + renderData.size.slotcoinX, y + (65), tocolor(255, 255, 255), 1, gtaFont, "right", "center", false, false, false, true)
end

addEvent("weaponOverheatSound", true)
addEventHandler("weaponOverheatSound", getRootElement(),
	function ()
		if source ~= localPlayer then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			local soundElement = playSound3D("files/sounds/overheat.mp3", x, y, z)

			if isElement(soundElement) then
				setElementInterior(soundElement, int)
				setElementDimension(soundElement, dim)
				attachElements(soundElement, source)
			end
		end
	end)

addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function (weaponId)
		if heatIncreaseValue[weaponId] and currentWeaponDbID and not getElementData(localPlayer, "tazerState") then
			if not currentHeat[currentWeaponDbID] then
				currentHeat[currentWeaponDbID] = 0
			end
			
			currentHeat[currentWeaponDbID] = currentHeat[currentWeaponDbID] + heatIncreaseValue[weaponId]
			
			if currentHeat[currentWeaponDbID] >= 100 then
				currentHeat[currentWeaponDbID] = 100
				
				if not fireDisabled then
					triggerServerEvent("weaponOverheat", localPlayer, getElementsByType("player", getRootElement(), true), currentWeaponDbID)
					playSound("files/sounds/overheat.mp3")
					
					fireDisabled = true
					exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, false)
				
					overheated[currentWeaponDbID] = true
					showInfobox("w", "Túlmelegedett a fegyvered!")

					exports.seal_chat:sendLocalDoC(localPlayer, "Túlmelegedett a fegyvere.")
				end
			end
			
			lastFireTick[currentWeaponDbID] = getTickCount()
		end
	end)

addEventHandler("onClientPreRender", getRootElement(),
	function (timeSlice)
		for k, v in pairs(lastFireTick) do
			if getTickCount() - v >= 500 then
				if currentHeat[k] >= 75 then
					currentHeat[k] = currentHeat[k] - (heatDecreaseValue[weaponItems[k]] or 0.015) * 0.5 * timeSlice
				else
					currentHeat[k] = currentHeat[k] - (heatDecreaseValue[weaponItems[k]] or 0.015) * timeSlice
				end
				
				if overheated[k] and currentWeaponDbID == k and not fireDisabled then
					fireDisabled = true
					exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, false)
				end
				
				if currentHeat[k] < 75 and currentWeaponDbID == k and fireDisabled then
					fireDisabled = false
					overheated[k] = false
					exports.seal_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
				end
				
				if currentHeat[k] < 0 then
					currentHeat[k] = 0
					lastFireTick[k] = nil
				end
			end
		end
	end)


	render.weapons = function (x, y)
		local weap = getPedWeapon(localPlayer)
	
		if weap ~= 0 then
			if renderData.tazerState then
				--dxDrawImage(x, y, (256), (128), "files/images/weapons/tazer.png")
		
				if renderData.tazerReloadNeeded then
					dxDrawBorderText("--", x, y + (54), x + (250), y + (54) + (65), tocolor(255, 255, 255), 1, gtaFont, "right", "center")
				else
					dxDrawBorderText("OK", x, y + (54), x + (250), y + (54) + (65), tocolor(255, 255, 255), 1, gtaFont, "right", "center")
				end
			else
				if getElementData(localPlayer,"hudWeaponImage") == "basis" then
					--dxDrawImage(x, y, (258), (78), "files/images/weapons/basis/" .. weap .. ".png")
				else
					--dxDrawImage(x, y, (256), (128), "files/images/weapons/basis/" .. weap .. ".png")
				end
		
				if heatIncreaseValue[weap] or weap == 41 then
					dxDrawBorderText(getPedAmmoInClip(localPlayer) .. " #eaeaea| " .. getPedTotalAmmo(localPlayer) - 1, x, y + (74), x + (250), y + (74) + (65), tocolor(255, 255, 255), 1, gtaFont, "right", "center", false, false, false, true)
					
					if heatIncreaseValue[weap] then
						dxDrawSeeBar(x + (125), y + (129), (125), (12), 2, tocolor(215, 89, 89, 200), currentHeat[currentWeaponDbID] or 0, "weaponHeat")
					end
				end
			end
		end
	end

renderData.countedFrames = 0

render.fps = function (x, y)
	if renderData.fps then
		if renderData.fps < 10 and 5 <= renderData.fps then
			dxDrawText(renderData.fps .. " FPS", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsOrange, fpsFontScale, fpsFont, "center", "center")
		elseif renderData.fps < 20 and 10 <= renderData.fps then
			dxDrawText(renderData.fps .. " FPS", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsYellow, fpsFontScale, fpsFont, "center", "center")
		elseif 20 <= renderData.fps then
			dxDrawText(renderData.fps .. " FPS", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsGreen, fpsFontScale, fpsFont, "center", "center")
		else
			dxDrawText(renderData.fps .. " FPS", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsRed, fpsFontScale, fpsFont, "center", "center")
		end
	else
		dxDrawText("FAILED TO CALCULATE FPS", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsRed, fpsFontScale, fpsFont, "center", "center")
	end
end

render.ping = function (x, y)
	local ping = getPlayerPing(localPlayer)

	if ping > 50 and ping < 125 then
		dxDrawText(ping .. " ms", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsOrange, fpsFontScale, fpsFont, "center", "center", false, false, false, true)
	elseif ping < 50 then
		dxDrawText(ping .. " ms", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsGreen, fpsFontScale, fpsFont, "center", "center", false, false, false, true)
	else
		dxDrawText(ping .. " ms", x, y, x + renderData.size.fpsX, y + renderData.size.fpsY, fpsRed, fpsFontScale, fpsFont, "center", "center", false, false, false, true)
	end
end

render.stats = function (x, y)
	local rt = getRealTime()

	if utf8.len(rt.hour) < 2 then
		rt.hour = 0 .. rt.hour
	end

	if 2 > utf8.len(rt.minute) then
		rt.minute = 0 .. rt.minute
	end

	dxDrawText(rt.hour .. ":" .. rt.minute, x, y, x + renderData.size.statsX, y + renderData.size.statsY, hudWhite, dataFontScale, dataFont, "left", "center")
	dxDrawText((renderData.characterName:gsub("_", " ") or "") .. " (" .. (renderData.playerID or 0) .. ") | LVL " .. renderData.currentLevel, x, y, x + renderData.size.statsX, y + renderData.size.statsY, hudWhite, dataFontScale, dataFont, "right", "center")
end

render.clock = function (x, y)
	local rt = getRealTime()

	if utf8.len(rt.hour) < 2 then
	  rt.hour = 0 .. rt.hour
	end

	if 2 > utf8.len(rt.minute) then
	  rt.minute = 0 .. rt.minute
	end
	dxDrawText(rt.hour .. ":" .. rt.minute, x, y, x + renderData.size.clockX, y + renderData.size.clockY, hudWhite, dataFontScale, dataFont, "center", "center")
end

render.vstats = function (x, y)
	local dx = dxGetStatus()
	local status = dxGetStatus()
	local color = "16"

	if status.Setting32BitColor then
		color = "32"
	end

	local y2 = y + renderData.size.vstatsY / 2 - (gpuFontH + fpsFontH * 3) / 2
	local text = "vram: " .. status.VideoCardRAM - status.VideoMemoryFreeForMTA .. "/" .. status.VideoCardRAM .. "mb, font: " .. status.VideoMemoryUsedByFonts .. [[
mb,
textures: ]] .. status.VideoMemoryUsedByTextures .. "mb, rtarget: " .. status.VideoMemoryUsedByRenderTargets .. [[
mb,
ratio: ]] .. status.SettingAspectRatio .. ", size: " .. screenX .. "x" .. screenY .. "x" .. color
	
	dxDrawText(status.VideoCardName, x, y2, x + renderData.size.vstatsX, 0, fpsGreen, fpsFontScale, fpsFont, "left", "top")
	dxDrawText(text, x, y2 + fpsFontH, x + renderData.size.vstatsX, 0, fpsLightGrey, fpsFontScale, gpuFont, "left", "top")
end

function setChatType(typ)
	renderData.chatType = typ

	if renderData.chatType == -1 then
		showChat(false)
	elseif renderData.chatType == 0 then
		if renderData.hudDisableNumber < 1 then
			showChat(true)
		else
			showChat(false)
		end
	elseif renderData.chatType == 1 then
		showChat(false)
	end
end

function toggleChat()
	if renderData.chatType == 1 then
		renderData.chatType = 0

		if renderData.hudDisableNumber < 1 then
			showChat(true)
		else
			showChat(false)
		end

		return 0
	elseif renderData.chatType == 0 then
		renderData.chatType = -1
		return -1
	elseif renderData.chatType == -1 then
		renderData.chatType = 1
		return 1
	end
end

function getChatType()
	return renderData.chatType
end

local flickerStrength = 0

addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		if renderData.hudDisableNumber < 1 then
			if pressingHudKey then
				if not renderData.screenSrc then
					renderData.screenSrc = dxCreateScreenSource(screenX, screenY)
					renderData.urmasound = playSound("files/sounds/urmasound.mp3", true)
					renderData.screenShader = dxCreateShader("files/shaders/monochrome.fx")

					--dxSetShaderValue(renderData.screenShader, "screenSource", renderData.screenSrc)
					--dxSetShaderValue(renderData.screenShader, "alpha", 1)
					dxSetShaderValue(renderData.screenShader, "UVSize", screenX, screenY)
        			dxSetShaderValue(renderData.screenShader, "screenSource", renderData.screenSrc)
				end
				
				dxUpdateScreenSource(renderData.screenSrc)

				if renderData.screenShader then
					dxDrawImage(0, 0, screenX, screenY, renderData.screenShader, 0, 0, 0, tocolor(150, 150, 255))
				else
					dxDrawImage(0, 0, screenX, screenY, renderData.screenSrc, 0, 0, 0, tocolor(150, 150, 255))
				end

				dxDrawBorderText("Hud szerkesztés", 0, 0, screenX, screenY, tocolor(255, 255, 255, 200), 1, UbuntuR, "center", "center")
			else
				if renderData.screenShader then
					destroyElement(renderData.screenShader)
				end
				renderData.screenShader = nil

				if renderData.screenSrc then
					destroyElement(renderData.screenSrc)
				end
				renderData.screenSrc = nil

				if renderData.urmasound then
					destroyElement(renderData.urmasound)
				end
				renderData.urmasound = nil
			end

			local cx, cy = getHudCursorPos()

			if tonumber(cx) then
				cx, cy = cx * screenX, cy * screenY

				if (cy < 1 or renderData.showTrashTray) and #renderData.moving < 1 and not renderData.resizing then
					dxDrawRectangle(0, 0, screenX, (225), tocolor(0, 0, 0, 150))
					renderData.showTrashTray = true
				end

				if cy > (225) and renderData.showTrashTray then
					renderData.showTrashTray = false
				end
			elseif renderData.showTrashTray then
				renderData.showTrashTray = false
			end
		else
			local elapsedTime = (getTickCount() - hideHudTick)
			local duration = 1000
			if elapsedTime <= duration then
				for i = 1, #hudElements do
					local hud = hudElements[i]

					if hud and renderData.move[hud] then
						if not renderData.inTrash[hud] then
							local rendering = render[hud]

							if rendering and renderData.pos[hud .. "X"] and renderData.pos[hud .. "Y"] then
								local x, y = 0, 0

                                x, y = processColorSwitchEffect("moveHud", x, y, 0, 0, 20, "Linear") 
								local x, y = renderData.pos[hud .. "X"] + x, renderData.pos[hud .. "Y"] + y
								local x2, y2 = 0, 0

								if renderData.pos[hud .. "X"] <= screenX/2 then
									x2 = interpolateBetween(renderData.pos[hud .. "X"], 0, 0, renderData.pos[hud .. "X"] - screenX, 0, 0, elapsedTime/duration, "InOutQuad")
								elseif renderData.pos[hud .. "X"] >= screenX/2 then
									x2 = interpolateBetween(renderData.pos[hud .. "X"], 0, 0, renderData.pos[hud .. "X"] + screenX, 0, 0, elapsedTime/duration, "InOutQuad")
								end
								
								if renderData.pos[hud .. "Y"] <= screenY/2 then
									y2 = interpolateBetween(renderData.pos[hud .. "Y"], 0, 0, renderData.pos[hud .. "Y"] - screenY, 0, 0, elapsedTime/duration, "InOutQuad")
								elseif renderData.pos[hud .. "Y"] >= screenY/2 then
									y2 = interpolateBetween(renderData.pos[hud .. "Y"], 0, 0, renderData.pos[hud .. "Y"] + screenY, 0, 0, elapsedTime/duration, "InOutQuad")
								end
								x2 = x2 - renderData.pos[hud .. "X"]
								y2 = y2 - renderData.pos[hud .. "Y"]

								rendering = rendering(x + x2, y + y2)

								if hud == "actionbar" then
									processActionBarShowHide(rendering)
								end
							end
						else
							if hud == "actionbar" and not renderData.showTrashTray then
								processActionBarShowHide(false)
							end
						end
					end
				end
			end
		end
	end)

function spairs(t, order)
	local keys = {}

	for k in pairs(t) do
		keys[#keys + 1] = k
	end

	if order then
		table.sort(keys, function (a, b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	local i = 0

	return function ()
		i = i + 1

		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

spairs(hudElements)

function setPokerMode(state)
	renderData.pokerChat = state

	if state then
		renderData.oldTalk = getElementData(localPlayer, "talkingAnim")
		setElementData(localPlayer, "talkingAnim", -1)
	else
		setElementData(localPlayer, "talkingAnim", renderData.oldTalk)
	end
end

contacts = {}
callHistory = {}
missedCalls = 0
allNewMessages = 0
messages = {}
messageNumbers = {}
newMessages = {}
currentWallpaper = 1
currentRingtone = 1
currentNotisound = 1
isSoundOn = 1
isVibrateOn = 1
isAdsOn = 1
isAdNumberOn = 1
isNionAdsOn = 0
isNionAdNumberOn = 1

function loadPositions()
	local RootNode = xmlLoadFile("hud.xml")
	if RootNode then
	  local nodes = xmlNodeGetChildren(xmlFindChild(RootNode, "phoneContacts", 0))
	  for i = 1, #nodes do
		node = nodes[i]
		contacts[i] = {}
		contacts[i][1] = xmlNodeGetAttribute(node, "name")
		contacts[i][2] = tonumber(xmlNodeGetValue(node))
	  end
	  local nodes = xmlNodeGetChildren(xmlFindChild(RootNode, "callHistory", 0))
	  for i = 1, #nodes do
		node = nodes[i]
		callHistory[i] = {}
		callHistory[i][2] = xmlNodeGetAttribute(node, "type")
		callHistory[i][1] = tonumber(xmlNodeGetValue(node))
	  end
	  local nodes = xmlNodeGetChildren(xmlFindChild(RootNode, "newMessages", 0))
	  local node = false
	  for i = 1, #nodes do
		node = nodes[i]
		local by = tonumber(xmlNodeGetAttribute(node, "by"))
		newMessages[by] = tonumber(xmlNodeGetValue(node))
	  end
	  node = xmlFindChild(RootNode, "missedCalls", 0)
	  missedCalls = tonumber(xmlNodeGetValue(node)) or 0
	  node = xmlFindChild(RootNode, "allNewMessages", 0)
	  allNewMessages = tonumber(xmlNodeGetValue(node)) or 0
	  node = xmlFindChild(RootNode, "currentWallpaper", 0)
	  currentWallpaper = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "currentRingtone", 0)
	  currentRingtone = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "currentNotisound", 0)
	  currentNotisound = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isSoundOn", 0)
	  isSoundOn = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isVibrateOn", 0)
	  isVibrateOn = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isAdsOn", 0)
	  isAdsOn = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isAdNumberOn", 0)
	  isAdNumberOn = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isNionAdsOn", 0)
	  isNionAdsOn = tonumber(xmlNodeGetValue(node)) or 1
	  node = xmlFindChild(RootNode, "isNionAdNumberOn", 0)
	  isNionAdNumberOn = tonumber(xmlNodeGetValue(node)) or 1
	  local nodes = xmlNodeGetChildren(xmlFindChild(RootNode, "messages", 0))
	  for i = 1, #nodes do
		node = nodes[i]
		local by = tonumber(xmlNodeGetAttribute(node, "by"))
		if not messages[by] then
		  messages[by] = {}
		  table.insert(messageNumbers, by)
		end
		local err = false
		if xmlNodeGetAttribute(node, "error") == "true" then
		  err = true
		end
		table.insert(messages[by], {
		  xmlNodeGetValue(node),
		  xmlNodeGetAttribute(node, "side"),
		  err
		})
	  end
	  xmlUnloadFile(RootNode)
	end
end

function savePositions()
  local RootNode = xmlCreateFile("hud.xml", "logindatas")
  local NewRoot = false
  NewRoot = xmlCreateChild(RootNode, "phoneContacts")
  for k = 1, #contacts do
    if contacts[k] then
      local NewNode = xmlCreateChild(NewRoot, "contact")
      xmlNodeSetValue(NewNode, contacts[k][2])
      xmlNodeSetAttribute(NewNode, "name", contacts[k][1])
    end
  end
  NewRoot = xmlCreateChild(RootNode, "callHistory")
  for k = 1, #callHistory do
    if callHistory[k] then
      local NewNode = xmlCreateChild(NewRoot, "history")
      xmlNodeSetValue(NewNode, callHistory[k][1])
      xmlNodeSetAttribute(NewNode, "type", callHistory[k][2])
    end
  end
  NewRoot = xmlCreateChild(RootNode, "missedCalls")
  xmlNodeSetValue(NewRoot, missedCalls)
  NewRoot = xmlCreateChild(RootNode, "allNewMessages")
  xmlNodeSetValue(NewRoot, allNewMessages)
  NewRoot = xmlCreateChild(RootNode, "currentWallpaper")
  xmlNodeSetValue(NewRoot, currentWallpaper)
  NewRoot = xmlCreateChild(RootNode, "currentRingtone")
  xmlNodeSetValue(NewRoot, currentRingtone)
  NewRoot = xmlCreateChild(RootNode, "currentNotisound")
  xmlNodeSetValue(NewRoot, currentNotisound)
  NewRoot = xmlCreateChild(RootNode, "isSoundOn")
  xmlNodeSetValue(NewRoot, isSoundOn)
  NewRoot = xmlCreateChild(RootNode, "isVibrateOn")
  xmlNodeSetValue(NewRoot, isVibrateOn)
  NewRoot = xmlCreateChild(RootNode, "isAdsOn")
  xmlNodeSetValue(NewRoot, isAdsOn)
  NewRoot = xmlCreateChild(RootNode, "isAdNumberOn")
  xmlNodeSetValue(NewRoot, isAdNumberOn)
  NewRoot = xmlCreateChild(RootNode, "isNionAdsOn")
  xmlNodeSetValue(NewRoot, isNionAdsOn)
  NewRoot = xmlCreateChild(RootNode, "isNionAdNumberOn")
  xmlNodeSetValue(NewRoot, isNionAdNumberOn)
  NewRoot = xmlCreateChild(RootNode, "messages")
  for k, v in pairs(messages) do
    local by = k
    for k = 1, #v do
      local NewNode = xmlCreateChild(NewRoot, "sms")
      xmlNodeSetValue(NewNode, v[k][1])
      xmlNodeSetAttribute(NewNode, "by", by)
      xmlNodeSetAttribute(NewNode, "side", v[k][2])
      xmlNodeSetAttribute(NewNode, "error", tostring(v[k][3]))
    end
  end
  NewRoot = xmlCreateChild(RootNode, "newMessages")
  for k, v in pairs(newMessages) do
    local NewNode = xmlCreateChild(NewRoot, "newmessage")
    xmlNodeSetValue(NewNode, v)
    xmlNodeSetAttribute(NewNode, "by", k)
  end
  xmlSaveFile(RootNode)
  xmlUnloadFile(RootNode)
end
addEventHandler("onClientResourceStop", getRootElement(), savePositions)

addEventHandler("onClientHUDRender", getRootElement(),
	function ()
		if renderData.hudDisableNumber < 1 then
			if renderData.loggedIn then
				local now = getTickCount()

				if isCursorShowing() then
					pressingHudKey = getKeyState("lctrl")
				elseif pressingHudKey then
					pressingHudKey = false
				end

				renderData.countedFrames = renderData.countedFrames + 1

				if not renderData.lastFPSReset then
					renderData.lastFPSReset = now
				end

				if now - renderData.lastFPSReset >= 1000 then
					renderData.fps = renderData.countedFrames
					renderData.countedFrames = 0
					renderData.lastFPSReset = now
				end

				local cx, cy = getHudCursorPos()

				if tonumber(cx) then
					cx = cx * screenX
					cy = cy * screenY

					if renderData.resizing then
						local hud = renderData.resizing[1]

						renderData.size[hud .. "X"] = renderData.resizing[4] + (cx - renderData.resizing[2])
						renderData.size[hud .. "Y"] = renderData.resizing[5] + (cy - renderData.resizing[3])

						if renderData.size[hud .. "X"] >= renderData.resizingLimitMax[hud .. "X"] then
							renderData.size[hud .. "X"] = renderData.resizingLimitMax[hud .. "X"]
						end

						if renderData.size[hud .. "Y"] >= renderData.resizingLimitMax[hud .. "Y"] then
							renderData.size[hud .. "Y"] = renderData.resizingLimitMax[hud .. "Y"]
						end

						if renderData.size[hud .. "X"] <= renderData.resizingLimitMin[hud .. "X"] then
							renderData.size[hud .. "X"] = renderData.resizingLimitMin[hud .. "X"]
						end

						if renderData.size[hud .. "Y"] <= renderData.resizingLimitMin[hud .. "Y"] then
							renderData.size[hud .. "Y"] = renderData.resizingLimitMin[hud .. "Y"]
						end

						renderData.moving = {}
					end

					if renderData.select then
						dxDrawRectangle(renderData.select[1], renderData.select[2], cx - renderData.select[1], cy - renderData.select[2], tocolor(74, 223, 191, 150))
					elseif renderData.moving then
						for i = 1, #renderData.moving do
							if not renderData.moving[i][4] or not renderData.moving[i][5] then
								renderData.moving[i][4] = renderData.pos[renderData.moving[i][1] .. "X"]
								renderData.moving[i][5] = renderData.pos[renderData.moving[i][1] .. "Y"]
							else
								renderData.pos[renderData.moving[i][1] .. "X"] = renderData.moving[i][4] + (cx - renderData.moving[i][2])
								renderData.pos[renderData.moving[i][1] .. "Y"] = renderData.moving[i][5] + (cy - renderData.moving[i][3])
							end
						end
					end
				else
					renderData.moving = {}
					renderData.resizing = false
					renderData.selectedHUD = {}
				end

				if renderData.showTrashTray then
					local x = 50 - renderData.scrollX
					local y = (225) / 2

					for k, v in pairs(renderData.inTrash) do
						if v then
							local rendering = render[k]

							if rendering then
								rendering = rendering(x, y - (renderData.move[k][4] - renderData.move[k][2]) / 2)

								if k == "actionbar" then
									processActionBarShowHide(rendering)
								end

								if not rendering and renderData.placeholder[k] and isCursorShowing() and pressingHudKey then
									dxDrawBorderText(renderData.placeholder[k], renderData.move[k][1], renderData.move[k][2], renderData.move[k][3], renderData.move[k][4], tocolor(255, 255, 255), 0.7, UbuntuR, "center", "center")
								end
							end

							renderData.pos[k .. "X"] = x
							renderData.pos[k .. "Y"] = y - (renderData.move[k][4] - renderData.move[k][2]) / 2

							x = x + 50 + (renderData.move[k][3] - renderData.move[k][1])
						end
					end

					if cx and cy then
						dxDrawRectangle(0, 0, (50), (225), tocolor(0, 0, 0, 00))
						dxDrawRectangle(screenX - (50), 0, (50), (225), tocolor(0, 0, 0, 00))
						
						if cx >= 0 and cx <= (50) and cy >= 0 and cy <= (225) then
							dxDrawRectangle(0, 0, (50), (225), tocolor(0, 0, 0, 00))

							if getKeyState("mouse1") and renderData.scrollX > 0 then
								renderData.scrollX = renderData.scrollX - 5
							end

							dxDrawImage(0 + (50) / 2 - (32) / 2, 0 + (225) / 2 - (32) / 2, (32), (32), "files/images/a.png", 0, 0, 0)
						else
							dxDrawImage(0 + (50) / 2 - (26) / 2, 0 + (225) / 2 - (26) / 2, (26), (26), "files/images/a.png", 0, 0, 0)
						end
						
						if cx >= screenX - (50) and cx <= screenX and cy >= 0 and cy <= (225) then
							dxDrawRectangle(screenX - (50), 0, (50), (225), tocolor(0, 0, 0, 00))

							if getKeyState("mouse1") then
								renderData.scrollX = renderData.scrollX + 5
							end

							dxDrawImage(screenX - (50) + (50) / 2 - (32) / 2, 0 + (225) / 2 - (32) / 2, (32), (32), "files/images/a.png", 180, 0, 0)
						else
							dxDrawImage(screenX - (50) + (50) / 2 - (26) / 2, 0 + (225) / 2 - (26) / 2, (26), (26), "files/images/a.png", 180, 0, 0)
						end
					end
				end

				if renderData.pokerChat then
					showChat(true)
				elseif renderData.chatType == 1 or renderData.chatType == -1 then
					showChat(false)
				elseif renderData.chatType == 0 then
					showChat(true)
				end


				renderData.move.bars = {
					renderData.pos.barsX,
					renderData.pos.barsY,
					renderData.pos.barsX + renderData.size.barsX,
					renderData.pos.barsY + renderData.size.barsY
				}
				--[[
				renderData.move.stamina = {
					renderData.pos.staminaX - 5,
					renderData.pos.staminaY - 5,
					renderData.pos.staminaX + renderData.size.staminaX + 5,
					renderData.pos.staminaY + renderData.size.staminaY + 5
				}
				]]
				renderData.move.money = {
					renderData.pos.moneyX,
					renderData.pos.moneyY,
					renderData.pos.moneyX + 150,
					renderData.pos.moneyY + 48
				}
				renderData.move.infobox = {
					renderData.pos.infoboxX,
					renderData.pos.infoboxY,
					renderData.pos.infoboxX + (512),
					renderData.pos.infoboxY + (32)
				}
				renderData.move.kickbox = {
					renderData.pos.kickboxX - 5,
					renderData.pos.kickboxY - 5,
					renderData.pos.kickboxX + (320) + 5,
					renderData.pos.kickboxY + (45) * 5 + 5
				}
				renderData.move.actionbar = {
					renderData.pos.actionbarX - 10,
					renderData.pos.actionbarY - 10,
					renderData.pos.actionbarX + 237,
					renderData.pos.actionbarY + 42
				}
				renderData.move.slotcoin = {
					renderData.pos.slotcoinX - (5),
					renderData.pos.slotcoinY + (20),
					renderData.pos.slotcoinX + renderData.size.slotcoinX + (5),
					renderData.pos.slotcoinY + (50)
				}
				renderData.move.weapons = {
					renderData.pos.weaponsX,
					renderData.pos.weaponsY + (15),
					renderData.pos.weaponsX + (250) + (5),
					renderData.pos.weaponsY + (74) + (65) + (8)
				}
				renderData.move.fps = {
					renderData.pos.fpsX,
					renderData.pos.fpsY,
					renderData.pos.fpsX + 75,
					renderData.pos.fpsY + 32
				}
				renderData.move.clock = {
					renderData.pos.clockX,
					renderData.pos.clockY,
					renderData.pos.clockX + 75,
					renderData.pos.clockY + 32
				}
				renderData.move.vstats = {
					renderData.pos.vstatsX,
					renderData.pos.vstatsY,
					renderData.pos.vstatsX + 300,
					renderData.pos.vstatsY + 100
				}
				renderData.move.ping = {
					renderData.pos.pingX,
					renderData.pos.pingY,
					renderData.pos.pingX + 75,
					renderData.pos.pingY + 32
				}

				renderData.move.stats = {
					renderData.pos.statsX,
					renderData.pos.statsY,
					renderData.pos.statsX + 300,
					renderData.pos.statsY + 32
				}
				renderData.move.speedo = {
					renderData.pos.speedoX,
					renderData.pos.speedoY,
					renderData.pos.speedoX + 255,
					renderData.pos.speedoY + 253
				}
				-- renderData.move.turbo = {
				-- 	renderData.pos.turboX,
				-- 	renderData.pos.turboY,
				-- 	renderData.pos.turboX + 200,
				-- 	renderData.pos.turboY + 200
				-- }
				--[[
				renderData.move.carname = {
					renderData.pos.carnameX,
					renderData.pos.carnameY,
					renderData.pos.carnameX + (256),
					renderData.pos.carnameY + (34)
				}
				]]
				--[[
				renderData.move.fuel = {
					renderData.pos.fuelX + (74),
					renderData.pos.fuelY + (74),
					renderData.pos.fuelX + (256) - (74),
					renderData.pos.fuelY + (256) - (74)
				}
				]]
				--[[
				renderData.move.speedoicon = {
					renderData.pos.speedoiconX,
					renderData.pos.speedoiconY,
					renderData.pos.speedoiconX + (100),
					renderData.pos.speedoiconY + (32)
				}
				]]
				renderData.move.bone = {
					renderData.pos.boneX - 5,
					renderData.pos.boneY - 5,
					renderData.pos.boneX + (18) + 5,
					renderData.pos.boneY + (46) + 5
				}
				renderData.move.oocchat = {
					renderData.pos.oocchatX - 5,
					renderData.pos.oocchatY - 5,
					renderData.pos.oocchatX + renderData.size.oocchatX + 5,
					renderData.pos.oocchatY + renderData.size.oocchatY + 5
				}

				
				renderData.move.phone = {
					renderData.pos.phoneX - 5,
					renderData.pos.phoneY - 5,
					renderData.pos.phoneX + (240) + 5,
					renderData.pos.phoneY + (480) + 5
				}
			

				renderData.move.traffi = {
					(renderData.pos.traffiX or 0) - 5,
					(renderData.pos.traffiY or 0) - 5,
					(renderData.pos.traffiX or 0) + (274) + 5,
					(renderData.pos.traffiY or 0) + (45) + 5
				}
				renderData.move.minimap = {
					renderData.pos.minimapX - 5,
					renderData.pos.minimapY - 5,
					renderData.pos.minimapX + renderData.size.minimapX + 5,
					renderData.pos.minimapY + renderData.size.minimapY + 5
				}

				for i = 1, #renderData.selectedHUD do
					local k = renderData.selectedHUD[i]

					dxDrawRectangle(renderData.move[k][1] - 4, renderData.move[k][2] - 4, renderData.move[k][3] - renderData.move[k][1] + 8, renderData.move[k][4] - renderData.move[k][2] + 8, tocolor(74, 223, 191, 75))
					
					if #renderData.selectedHUD < 2 and renderData.resizable[k] then
						local x = renderData.move[k][3] - (20) / 2
						local y = renderData.move[k][4] - (20) / 2

						dxDrawImage(math.floor(renderData.move[k][3]) - 16, math.floor(renderData.move[k][4]) - 16, (32), (32), "files/images/arrows-alt.png", 0, 0, 0, tocolor(194, 194, 194))

						renderData.resizePosition = {x, y, x + (20), y + (20)}
					end
				end

				local elapsedTime = (getTickCount() - hideHudTick)
				local duration = 1000
				for i = 1, #hudElements do
					local hud = hudElements[i]

					if hud and renderData.move[hud] and hudState then
						if not renderData.inTrash[hud] then
							local rendering = render[hud]

							if rendering and renderData.pos[hud .. "X"] and renderData.pos[hud .. "Y"] then
								local x, y = 0, 0

								x, y = processColorSwitchEffect("moveHud", x, y, 0, 0, 20, "Linear") 
								local x, y = (renderData.pos[hud .. "X"] or 0) + x, (renderData.pos[hud .. "Y"] or 0) + y
								local x2, y2 = 0, 0

								if elapsedTime <= duration then
									if renderData.pos[hud .. "X"] <= screenX/2 then
										x2 = interpolateBetween(renderData.pos[hud .. "X"] - screenX, 0, 0, renderData.pos[hud .. "X"], 0, 0, elapsedTime/duration, "InOutQuad")
									elseif renderData.pos[hud .. "X"] >= screenX/2 then
										x2 = interpolateBetween(renderData.pos[hud .. "X"] + screenX, 0, 0, renderData.pos[hud .. "X"], 0, 0, elapsedTime/duration, "InOutQuad")
									end
									
									if renderData.pos[hud .. "Y"] <= screenY/2 then
										y2 = interpolateBetween(renderData.pos[hud .. "Y"] - screenY, 0, 0, renderData.pos[hud .. "Y"], 0, 0, elapsedTime/duration, "InOutQuad")
									elseif renderData.pos[hud .. "Y"] >= screenY/2 then
										y2 = interpolateBetween(renderData.pos[hud .. "Y"] + screenY, 0, 0, renderData.pos[hud .. "Y"], 0, 0, elapsedTime/duration, "InOutQuad")
									end
									x2 = x2 - renderData.pos[hud .. "X"]
									y2 = y2 - renderData.pos[hud .. "Y"]
								end

								rendering = rendering(x + x2, y + y2)
								
								if hud == "actionbar" then
									processActionBarShowHide(rendering)
								end

								if not rendering and renderData.placeholder[hud] and isCursorShowing() and pressingHudKey then
									dxDrawBorderText(renderData.placeholder[hud], renderData.move[hud][1], renderData.move[hud][2], renderData.move[hud][3], renderData.move[hud][4], tocolor(255, 255, 255), 0.7, UbuntuR, "center", "center")
								end
							end
						else
							if hud == "actionbar" and not renderData.showTrashTray then
								processActionBarShowHide(false)
							end
						end
					end
				end

				if cx and cy and #renderData.moving > 0 then
					local trashColor = tocolor(255, 255, 255)
					local trashRotX = 0

					if cx >= screenX / 2 - (32) - (32) and cx <= screenX / 2 + (32) - (32) and cy >= (32) and cy <= (32) + (64) then
						renderData.trashGetInverse = false

						if not renderData.trashGetRedStart then
							renderData.trashGetRedStart = now
						else
							local elapsedTime = now - renderData.trashGetRedStart
							local progress = elapsedTime / 250

							local r, g, b = interpolateBetween(255, 255, 255, 215, 89, 89, progress, "Linear")
							local rotation = interpolateBetween(0, 0, 0, -35, 0, 0, progress, "Linear")

							trashRotX = rotation
							trashColor = tocolor(r, g, b)
						end
					elseif renderData.trashGetRedStart then
						renderData.trashGetRedStart = false

						if not renderData.trashGetInverse then
							renderData.trashGetInverse = now
						end
					end

					if renderData.trashGetInverse then
						local elapsedTime = now - renderData.trashGetInverse
						local progress = elapsedTime / 250

						local r, g, b = interpolateBetween(215, 89, 89, 255, 255, 255, progress, "Linear")
						local rotation = interpolateBetween(-35, 0, 0, 0, 0, 0, progress, "Linear")

						trashRotX = rotation
						trashColor = tocolor(r, g, b)
					end

					dxDrawImage(screenX / 2 - (64), (32), (64), (64), "files/images/trashbody.png", 0, 0, 0, trashColor)
					dxDrawImage(screenX / 2 - (64), (32), (64), (64), "files/images/trashtop.png", trashRotX, -32, -10, trashColor)

					local refreshColor = tocolor(255, 255, 255)
					local refreshRotX = 0

					if cx >= screenX / 2 - (32) + (32) and cx <= screenX / 2 + (32) + (32) and cy >= (32) and cy <= (32) + (64) then
						renderData.refreshGetInverse = false

						if not renderData.refreshGetRedStart then
							renderData.refreshGetRedStart = now
						else
							local elapsedTime = now - renderData.refreshGetRedStart
							local progress = elapsedTime / 250

							local r, g, b = interpolateBetween(255, 255, 255, 89, 142, 215, progress, "Linear")
							local rotation = interpolateBetween(0, 0, 0, 180, 0, 0, progress, "Linear")

							refreshRotX = rotation
							refreshColor = tocolor(r, g, b)
						end
					elseif renderData.refreshGetRedStart then
						renderData.refreshGetRedStart = false

						if not renderData.refreshGetInverse then
							renderData.refreshGetInverse = now
						end
					end

					if renderData.refreshGetInverse then
						local elapsedTime = now - renderData.refreshGetInverse
						local progress = elapsedTime / 250

						local r, g, b = interpolateBetween(89, 142, 215, 255, 255, 255, progress, "Linear")
						local rotation = interpolateBetween(180, 0, 0, 0, 0, 0, progress, "Linear")

						refreshRotX = rotation
						refreshColor = tocolor(r, g, b)
					end

					dxDrawImage(screenX / 2 - (32) + (32), (32), (64), (64), "files/images/refresh.png", refreshRotX, 0, 0, refreshColor)
				end

				if renderData.showNumberPlates then
					local currentVehicle = getPedOccupiedVehicle(localPlayer)
					for vehicleElement, letters in pairs(streamedVehicles) do
						if not isElement(vehicleElement) then
							streamedVehicles[vehicleElement] = nil
							return
						end
						if currentVehicle ~= vehicleElement then
							local vehX, vehY, vehZ = getElementPosition(vehicleElement)
							local x, y = getScreenFromWorldPosition(vehX, vehY, vehZ + 1.2)

							if x and y then
								local camX, camY, camZ = getCameraMatrix()
								local dist = getDistanceBetweenPoints3D(vehX, vehY, vehZ, camX, camY, camZ)

								if dist < 50 and isLineOfSightClear(vehX, vehY, vehZ + 1, camX, camY, camZ, true, true, false, true, false, true, true, vehicleElement) then
									local scale = 0.5 - dist / 100
									local alpha = 1 - dist / 50

									if alpha > 0 then
										local sx = (256) * scale
										local sy = (128) * scale

										x = x - sx / 2
										y = y - sy / 2

										dxDrawImage(x, y, sx, sy, plateTex, 0, 0, 0, tocolor(255, 255, 255, 220 * alpha))

										for i = 1, #letters do
											if letters[i] then
												dxDrawImageSection(x + reMap(i, 1, 9, 10, 256 - 10)*scale, y + 40*scale, 27*scale, 64*scale, letters[i][1], letters[i][2], 32, 64, charsetTex, 0, 0, 0, tocolor(10, 19, 36, 255 * alpha))
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		chatRenderedOut = false
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		local plateText = getVehiclePlateText(source)
		local letters = {}

		local plateTextCharset = {}
		for i = 1, 8 do
			if utfLen(plateText) >= i then
				plateTextCharset[i] = string.lower(utfSub(plateText, i, i))
			end
		end

		for i = 1, #plateTextCharset do
			if charsetEx[plateTextCharset[i]] then
				local textIndex = charsetEx[plateTextCharset[i]]
				local x = ((textIndex % 4) - 1) * 32
				local y = math.floor(textIndex/4) * 64
				if textIndex % 4 == 0 then
					y = (math.floor(textIndex/4) * 64) - 64
				end
				letters[i] = {x, y}
			end
		end
		streamedVehicles[source] = letters
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		streamedVehicles[source] = nil
	end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		streamedVehicles[source] = nil
	end
end)

function isLeapYear(year)
    if year then
        year = math.floor(year)
    else
        year = getRealTime().year + 1900
    end

    return (year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0
end

function getTimestamp(year, month, day, hour, minute, second)
    local datetime = getRealTime()
    
    year = year or datetime.year + 1900
    month = month or datetime.month + 1
    day = day or datetime.monthday

    hour = hour or datetime.hour
    minute = minute or datetime.minute
    second = second or datetime.second

    local timestamp = 0

    for i = 1970, year - 1 do
        if isLeapYear(i) then
            timestamp = timestamp + 31622400
        else
            timestamp = timestamp + 31536000
        end
    end

    local monthseconds = {2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400}

    for i = 1, month - 1 do
        if isLeapYear(year) and i == 2 then
            timestamp = timestamp + 2505600
        else
            timestamp = timestamp + monthseconds[i]
        end
    end

    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    timestamp = timestamp - 3600 --GMT+1 compensation

    if datetime.isdst then
        timestamp = timestamp - 3600
    end

    return timestamp
end

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if key == "F10" and press then
			if renderData.hudDisableNumber < 1 then
				renderData.showNumberPlates = not renderData.showNumberPlates
			end
		end
	end)

addEventHandler("onClientClick", getRootElement(),
	function (button, state)
		if renderData.loggedIn and pressingHudKey and renderData.hudDisableNumber < 1 then
			if button == "left" and state == "down" then
				local cx, cy = getHudCursorPos()

				if tonumber(cx) then
					cx = cx * screenX
					cy = cy * screenY

					local resize = false

					if renderData.resizePosition and cx >= renderData.resizePosition[1] and cy >= renderData.resizePosition[2] and cx <= renderData.resizePosition[3] and cy <= renderData.resizePosition[4] then
						resize = {renderData.selectedHUD[1], cx, cy, renderData.size[renderData.selectedHUD[1] .. "X"], renderData.size[renderData.selectedHUD[1] .. "Y"]}
						renderData.resizing = resize
					end

					if cx >= 0 and not (cx >= 0 and cx <= (50) and cy >= 0 and cy <= (225) or cx >= screenX - (50) and cx <= screenX and cy >= 0 and cy <= (225)) then
						local movedhud = false

						for k, v in pairs(renderData.move) do
							if (not renderData.inTrash[k] or renderData.showTrashTray) and (renderData.showTrashTray and renderData.inTrash[k] or not renderData.showTrashTray) and cx >= v[1] and cy >= v[2] and cx <= v[3] and cy <= v[4] then
								renderData.showTrashTray = false
								renderData.inTrash[k] = false
								movedhud = k
								break
							end
						end

						local selected = false

						for i = 1, #renderData.selectedHUD do
							if renderData.selectedHUD[i] == movedhud then
								selected = true
								break
							end
						end

						if not selected then
							renderData.selectedHUD = {}

							if movedhud then
								table.insert(renderData.selectedHUD, movedhud)

								renderData.inTrash[movedhud] = false
								renderData.showTrashTray = false
							end
						end

						if #renderData.selectedHUD >= 1 and movedhud then
							for i = 1, #renderData.selectedHUD do
								table.insert(renderData.moving, {renderData.selectedHUD[i], cx, cy, false, false})
							end
						else
							if not renderData.showTrashTray then
								renderData.select = {cx, cy}
							end

							renderData.selectedHUD = {}
						end
					end
				end
			elseif button == "left" and state == "up" then
				if not renderData.showTrashTray then
					renderData.moving = {}
					renderData.resizing = false

					local cx, cy = getHudCursorPos()

					if tonumber(cx) then
						cx = cx * screenX
						cy = cy * screenY

						if cx >= screenX / 2 - (32) - (32) and cx <= screenX / 2 + (32) - (32) and cy >= (32) and cy <= (32) + (64) then
							for k, v in pairs(renderData.selectedHUD) do
								renderData.inTrash[v] = true
								resetHudElement(v, true)
							end

							renderData.trashGetInverse = false
							renderData.trashGetRedStart = false

							renderData.moving = {}
							renderData.resizing = false
							renderData.selectedHUD = {}
						end

						if cx >= screenX / 2 - (32) + (32) and cx <= screenX / 2 + (32) + (32) and cy >= (32) and cy <= (32) + (64) then
							for k, v in pairs(renderData.selectedHUD) do
								resetHudElement(v)
							end

							renderData.refreshGetInverse = false
							renderData.refreshGetRedStart = false

							renderData.moving = {}
							renderData.resizing = false
							renderData.selectedHUD = {}
						end

						if renderData.select then
							if math.floor(math.abs(cx - renderData.select[1]) + math.abs(cy - renderData.select[2])) > 2 then
								local minX = math.min(cx, renderData.select[1])
								local minY = math.min(cy, renderData.select[2])
								local maxX = math.max(cx, renderData.select[1])
								local maxY = math.max(cy, renderData.select[2])

								if renderData.select then
									for k, v in pairs(renderData.move) do
										if not renderData.inTrash[k] and minX < v[3] and maxX > v[1] and minY < v[4] and maxY > v[2] then
											table.insert(renderData.selectedHUD, k)
										end
									end
								end
							end

							renderData.select = false
						end
					end
				end
			end
		end
	end)

function hideHUD()
	if renderData.hudDisableNumber < 1 then
		hideHudTick = getTickCount()
	end
	renderData.hudDisableNumber = renderData.hudDisableNumber + 1
	processActionBarShowHide(false)
	showChat(false)
end

function showHUD()
	renderData.hudDisableNumber = renderData.hudDisableNumber - 1

	if renderData.hudDisableNumber < 0 then
		renderData.hudDisableNumber = 0
	end
	if renderData.hudDisableNumber == 0 then
		hideHudTick = getTickCount()
		showChat(true)
	end
end

addCommandHandler("toghud",
	function ()
		if renderData.loggedIn then
			hudState = not hudState

			if hudState then
				showHUD()
			else
				hideHUD()
			end
		end
	end)

local walkingStyles = {
	[118] = true,
	[119] = true,
	[120] = true,
	[121] = true,
	[122] = true,
	[123] = true,
	[124] = true,
	[125] = true,
	[126] = true,
	[127] = true,
	[129] = true,
	[130] = true,
	[131] = true,
	[132] = true,
	[133] = true,
	[134] = true,
	[135] = true,
	[136] = true,
	[137] = true
}

local fightingStyles = {
	[4] = true,
	[5] = true,
	[6] = true
}

function saveHUD()
	if renderData.loggedIn then
		if fileExists("hud.data") then
			fileDelete("hud.data")
		end

		local savedata = {
			pos = {},
			size = {},
			trash = {},
			settings = {}
		}

		for k, v in pairs(renderData.pos) do
			savedata.pos[k] = v
		end

		for k, v in pairs(renderData.size) do
			savedata.size[k] = v
		end

		for k, v in pairs(renderData.inTrash) do
			if v then
				savedata.trash[k] = "true"
			else
				savedata.trash[k] = "false"
			end
		end

		savedata.settings.screenRes = screenX .. "x" .. screenY
		savedata.settings.showNumberPlates = renderData.showNumberPlates

		local walkingstyle = getPedWalkingStyle(localPlayer)
		local fightingstyle = getPedFightingStyle(localPlayer)

		if not walkingStyles[walkingstyle] then
			walkingstyle = 118
		end

		if not fightingStyles[fightingstyle] then
			fightingstyle = 4
		end

		savedata.settings.walkingStyle = walkingstyle
		savedata.settings.fightingStyle = fightingstyle

		savedata.settings.state3DBlip = state3DBlip
		savedata.settings.stateMarksBlip = stateMarksBlip

		--[[
		savedata.settings.contacts = {}

		for k = 1, #contacts do
		    if contacts[k] then
		    	savedata.settings.contacts[k] = {}
		      	savedata.settings.contacts[k] = {num  = contacts[k][2], name = contacts[k][1]} 
		    end
		end

		savedata.settings.callHistory = {}

		for k = 1, #callHistory do
		    if callHistory[k] then
		    	savedata.settings.callHistory[k] = {}
		      	savedata.settings.callHistory[k] = {type  = callHistory[k][2], num = callHistory[k][1]} 
		    end
		end

		savedata.settings.messages = {}

		for k, v in pairs(messages) do
			for i = 1, #v do
			    if v[i] then
			    	savedata.settings.messages[k] = {}
			      	savedata.settings.messages[k] = {num  = v[i][1], side = v[i][2], error = v[i][3], by = k} 

			    end
			end
		end

		savedata.settings.missedCalls = missedCalls or 0
		savedata.settings.allNewMessages = allNewMessages or 0
		savedata.settings.currentWallpaper = currentWallpaper or 1
		savedata.settings.currentRingtone = currentRingtone or 1
		savedata.settings.currentNotisound = currentNotisound or 1
		savedata.settings.isSoundOn = isSoundOn or 1
		--savedata.settings.isAdsOn = isAdsOn or 1
		savedata.settings.isAdNumberOn = isAdNumberOn or 1
		]]
		savedata.settings.hudMoving = (hudMoving and 1) or 0
		
		local savefile = fileCreate("hud.data")
		fileWrite(savefile, encodeString("tea", toJSON(savedata, true), {key = "__DATAFILE__"}))
		fileClose(savefile)

		if fileExists("markers.pos") then
			fileDelete("markers.pos")
		end
		
		local markersfile = fileCreate("markers.pos")

		for i = 1, #createdBlips do
			local v = createdBlips[i]

			if v and v.blipId == "minimap/newblips/markblip.png" then
				fileWrite(markersfile, v.blipPosX .. "," .. v.blipPosY, "/")
			end
		end

		fileClose(markersfile)
	end
end

function loadHUD()
	if fileExists("hud.data") then
		local savefile = fileOpen("hud.data")

		if savefile then
			local savedata = fileRead(savefile, fileGetSize(savefile))

			if savedata then
				savedata = fromJSON(decodeString("tea", savedata, {key = "__DATAFILE__"}))
			end

			fileClose(savefile)

			if savedata then
				resetHudElement("all")

				for k, v in pairs(savedata.pos) do
					renderData.pos[k] = tonumber(v)
				end

				for k, v in pairs(savedata.size) do
					renderData.size[k] = tonumber(v)
				end

				for k, v in pairs(savedata.trash) do
					if v == "true" then
						renderData.inTrash[k] = true
					else
						renderData.inTrash[k] = false
					end
				end

				if savedata.settings.screenRes then
					local res = split(savedata.settings.screenRes, "x")

					if res[1] and res[2] and (tonumber(res[1]) ~= screenX or tonumber(res[2]) ~= screenY) then
						resetHudElement("all")
						outputChatBox("#d75959[SeeMTA - HUD]: #ffffffÚj képernyőfelbontás észlelve. A HUD visszaállításra került az alapértelmezett állapotába!", 255, 255, 255, true)
						saveHUD()
					end
				end

				renderData.showNumberPlates = savedata.settings.showNumberPlates
				hudMoving = savedata.settings.hudMoving == 1

				--[[
				missedCalls = savedata.settings.missedCalls or 0
				allNewMessages = savedata.settings.allNewMessages or 0
				currentWallpaper = savedata.settings.currentWallpaper or 1
				currentRingtone = savedata.settings.currentRingtone or 1
				currentNotisound = savedata.settings.currentNotisound or 1
				isSoundOn = savedata.settings.isSoundOn or 1
				--isAdsOn = savedata.settings.isAdsOn or 1
				isAdNumberOn = savedata.settings.isAdNumberOn or 1
				--isNionAdsOn = savedata.settings.isAdsOn or 1
				isNionAdNumberOn = savedata.settings.isAdNumberOn or 1
				hudMoving = savedata.settings.hudMoving == 1

				for k = 1, #savedata.settings.contacts do
				   contacts[k] = {}

				   contacts[k][1] = savedata.settings.contacts[k].name
				   contacts[k][2] = savedata.settings.contacts[k].num
				end

				for k = 1, #savedata.settings.callHistory do
				   callHistory[k] = {}

				   callHistory[k][1] = savedata.settings.callHistory[k].num
				   callHistory[k][2] = savedata.settings.callHistory[k].type
				end

				for k = 1, #savedata.settings.messages do
				    if not messages[tonumber(savedata.settings.messages[k].by)] then
				    	messages[tonumber(savedata.settings.messages[k].by)] = {}
				    	table.insert(messageNumbers, tonumber(savedata.settings.messages[k].by))
				    end

				    table.insert(messages[tonumber(savedata.settings.messages[k].by)], {savedata.settings.messages[k].num, savedata.settings.messages[k].side, true})
				end]]

				local walkingstyle = savedata.settings.walkingStyle
				local fightingstyle = savedata.settings.fightingStyle

				if not tonumber(walkingstyle) or not walkingStyles[walkingstyle] then
					walkingstyle = 118
				end

				if not tonumber(fightingstyle) or not fightingStyles[fightingstyle] then
					fightingstyle = 4
				end

				--triggerServerEvent("setPedWalkingStyle", localPlayer, walkingstyle)
				--triggerServerEvent("setPedFightingStyle", localPlayer, fightingstyle)

				state3DBlip = savedata.settings.state3DBlip
				stateMarksBlip = savedata.settings.stateMarksBlip

				if state3DBlip then
					addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
				end

				if fileExists("markers.pos") then
					local markersfile = fileOpen("markers.pos")
					
					if markersfile then
						local buffer = ""
						
						while not fileIsEOF(markersfile) do
							buffer = buffer .. fileRead(markersfile, 500)
						end
						
						fileClose(markersfile)
						
						if buffer then
							local markers = split(buffer, "/")
							
							for i = 1, #markers do
								if markers[i] then
									local pos = split(markers[i], ",")

									if pos[1] and pos[2] then
										table.insert(createdBlips, {
											blipPosX = tonumber(pos[1]),
											blipPosY = tonumber(pos[2]),
											blipPosZ = 0,
											blipId = "minimap/newblips/markblip.png",
											farShow = true,
											renderDistance = 9999,
											iconSize = 18,
											blipColor = tocolor(255, 255, 255)
										})

										if markBlips then
											table.insert(markBlips, #createdBlips)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local loadingStarted = false
local loadingStartTime = false
local loadingLogoGetStart = false
local loadingLogoGetInverse = false
local loadingTime = false
local currLoadingText = false
local loadingTexts = false
local logoMoveDifferenceX, logoMoveDifferenceY = 0, 0
local loadingSound = false
local loadingBackground = false

function showTheLoadScreen(loadTime, texts)
	local now = getTickCount()

	currLoadingText = 1
	loadingTexts = {}

	for i = 1, #texts do
		loadingTexts[i] = {
			texts[i],
			now + loadTime / #texts * (i - 1),
			now + loadTime / #texts * i
		}
	end

	loadingStarted = true
	loadingLogoGetStart = now + 750
	loadingLogoGetInverse = false
	loadingTime = loadTime
	loadingStartTime = now
	logoMoveDifferenceX, logoMoveDifferenceY = 0, 0

	if isElement(loadingSound) then
		destroyElement(loadingSound)
	end

	loadingSound = playSound("files/sounds/loading.mp3")
	loadingBackground = math.random(1, 6)

	addEventHandler("onClientRender", getRootElement(), renderTheLoadingScreen, true, "low")
end

addCommandHandler("loadingtest",
 	function()
 		showTheLoadScreen(math.floor(10000, 15000), {"Adatok betöltése...", "Szinkronizációk folyamatban...", "Belépés Las Venturasba..."})
	end
)

function renderTheLoadingScreen()
	if loadingStarted then
		local now = getTickCount()
		local progress = (now - loadingStartTime) / loadingTime

		dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0))
		dxDrawImage(0, 0, screenX * (1 + progress / 4), screenY * (1 + progress / 4), "files/" .. loadingBackground .. ".png")

		if loadingLogoGetStart then
			local progress = (now - loadingLogoGetStart) / 400

			if progress < 0 then
				progress = 0
			end

			if progress >= 1 then
				loadingLogoGetInverse = now + 1000
				loadingLogoGetStart = false
			end

			logoMoveDifferenceX, logoMoveDifferenceY = interpolateBetween((27), (13), 0, 0, 0, 0, progress, "OutQuad")
		end

		if loadingLogoGetInverse then
			local progress = (now - loadingLogoGetInverse) / 400

			if progress < 0 then
				progress = 0
			end

			if progress >= 1 then
				loadingLogoGetStart = now + 2500
				loadingLogoGetInverse = false
			end

			logoMoveDifferenceX, logoMoveDifferenceY = interpolateBetween(0, 0, 0, (27), (13), 0, progress, "OutQuad")
		end

		local logoSize = (128)
		local x = screenX / 2 - logoSize / 2
		local y = screenY / 2 - logoSize / 2

		
		--dxDrawImage(x + logoMoveDifferenceX, y + logoMoveDifferenceY, logoSize, logoSize, "infobox/strawu.png")
		--dxDrawImage(x - logoMoveDifferenceX, y + logoMoveDifferenceY, logoSize, logoSize, "infobox/strawd.png")
		--dxDrawImage(x, y, logoSize, logoSize, "infobox/logo1.png")

		--dxDrawImage(screenX / 2 - (600) / 2 - logoMoveDifferenceX, screenY / 2 - (350) + logoMoveDifferenceY, 600, 600, "infobox/logo2.png", 0, 0, 0, tocolor(255, 255, 255, 255))
   	 	--dxDrawImage(screenX / 2 - (600) / 2 + logoMoveDifferenceX, screenY / 2 - (350) + logoMoveDifferenceY, 600, 600, "infobox/logo3.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    	--dxDrawImage(screenX / 2 - (128) / 2, screenY / 2 - (128), (128), (128), "infobox/logo1.png", 0, 0, 0, tocolor(255, 255, 255, 255))

		if loadingTexts[currLoadingText] then
			if now > loadingTexts[currLoadingText][3] then
				if loadingTexts[currLoadingText + 1] then
					currLoadingText = currLoadingText + 1
				end
			end

			local timediff = loadingTexts[currLoadingText][3] - loadingTexts[currLoadingText][2]
			local progress = loadingTexts[currLoadingText][2] + timediff / 2
			local alpha = 255

			if now >= progress then
				alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (now - progress) / timediff * 2, "Linear")
			else
				alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (now - loadingTexts[currLoadingText][2]) / timediff * 2, "Linear")
			end

			dxDrawText(loadingTexts[currLoadingText][1], x, y, x + logoSize, y + logoSize, tocolor(200, 200, 200, alpha), 1, Roboto, "center", "center")
		end

		if progress >= 1 then
			loadingStarted = false

			if isElement(loadingSound) then
				destroyElement(loadingSound)
			end

			removeEventHandler("onClientRender", getRootElement(), renderTheLoadingScreen)
		end

		dxDrawText("Betöltés...", 0, 0, screenX - (32) - 2, screenY - (32) - 2, tocolor(255, 255, 255), 0.8, Roboto, "right", "bottom")

		local progress = interpolateBetween(0, 0, 0, 100, 0, 0, progress, "Linear")

		dxDrawSeeBar((32), screenY - (32), screenX - (64), 8, 0, tocolor(255, 255, 255), progress, false, tocolor(100, 100, 100))
	end
end



addCommandHandler("reloadmyweapon",
	function ()
		if getElementData(localPlayer, "loggedIn") then
			if getPedTask(localPlayer, "secondary", 0) ~= "TASK_SIMPLE_USE_GUN" then
				if not blockedTasks[getPedSimplestTask(localPlayer)] then
					if getTickCount() - lastReloadTime >= 500 then
						triggerServerEvent("reloadPlayerWeapon", localPlayer)
						lastReloadTime = getTickCount()

						if getElementData(localPlayer, "tazerReloadNeeded") then
							exports.wm_controls:toggleControl({"fire", "vehicle_fire", "action"}, true)
							setElementData(localPlayer, "tazerReloadNeeded", false)
						end
					end
				end
			end
		end
	end)

	colorSwitch = {}
	startingColors = {}
	function processColorSwitchEffect(key, r, g, b, a, effectDuration, effectEasingType)
		local effectData = colorSwitch[key] or {}
	
		r = tonumber(r) or 255
		g = tonumber(g) or 255
		b = tonumber(b) or 255
		a = tonumber(a) or 255
	
		local hexCode = string.format("%x", 0x01000000 * a + 0x010000 * r + 0x0100 * g + b)
	
		if not effectData[1] then
			effectData = {r, g, b, a, hexCode}
		end
	
		effectDuration = tonumber(effectDuration) or 500
	
		if effectData[5] ~= hexCode then
			startingColors[key] = {unpack(effectData)}
			effectData[5] = hexCode
			effectData[6] = getTickCount()
		end
	
		if effectData[6] then
			local linearValue = math.min(1, (getTickCount() - effectData[6]) / (tonumber(effectDuration) or 500))
			local easingValue = getEasingValue(linearValue, effectEasingType or "Linear")
	
			local r2, g2, b2 = interpolateBetween(startingColors[key][1], startingColors[key][2], startingColors[key][3], r, g, b, linearValue, "Linear")
			local a2 = interpolateBetween(startingColors[key][4], 0, 0, a, 0, 0, linearValue, "Linear")
			effectData[1] = r2
			effectData[2] = g2
			effectData[3] = b2
			effectData[4] = a2
	
			if linearValue >= 1 then
				effectData[6] = nil
			end
		end
	
		colorSwitch[key] = effectData
	
		return effectData[1], effectData[2], effectData[3], effectData[4]
	end

function toggleHudMoving(state)
	hudMoving = not state
end

local bordercolor = tocolor(0, 0, 0)

function dxDrawBorderText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded)
	local text2 = string.gsub(text, "#......", "")
	dxDrawText(text2, x - 1, y - 1, w - 1, h - 1, bordercolor, scale, font, alignX, alignY, clip, wordBreak, postGUI, false, true)
	dxDrawText(text2, x - 1, y + 1, w - 1, h + 1, bordercolor, scale, font, alignX, alignY, clip, wordBreak, postGUI, false, true)
	dxDrawText(text2, x + 1, y - 1, w + 1, h - 1, bordercolor, scale, font, alignX, alignY, clip, wordBreak, postGUI, false, true)
	dxDrawText(text2, x + 1, y + 1, w + 1, h + 1, bordercolor, scale, font, alignX, alignY, clip, wordBreak, postGUI, false, true)
	dxDrawText(text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true)
end