local getZoneNameEx = getZoneName

function getZoneName(x, y, z, cities)
	local zone = getZoneNameEx(x, y, z, cities)

	if zone == "Greenglass College" then
		return "Las Venturas City Hall"
	end

	return zone
end

local screenSource = dxCreateScreenSource(screenX, screenY)

local radarTexture = dxCreateTexture("minimap/radar.png", "dxt3")
local radarTexture2 = dxCreateTexture("minimap/radar.png", "dxt3")

dxSetTextureEdge(radarTexture, "border", tocolor(110, 158, 205, 0))
dxSetTextureEdge(radarTexture2, "border", tocolor(110, 158, 205, 0))

local radarTextureSize = 3072
local mapScaleFactor = 6000 / radarTextureSize
local mapUnit = radarTextureSize / 6000

local minimapWidth = respc(320)
local minimapHeight = respc(225)
local minimapX = 0
local minimapY = 0

local rtsize = math.ceil((minimapWidth + minimapHeight) * 1)
local renderTarget = dxCreateRenderTarget(rtsize, rtsize, true)
local zoomval = 0.5
local zoom = zoomval

local targetZoom = zoom

local defaultBlips = {
	{2242.53125000000, -1676.121582031, 21.031250000000, "minimap/newblips/binco.png"},
	{1926.1101074219, -1793.5054931641, 25.6015625, "minimap/newblips/fuel.png"},
	{997.56219482422, -919.462890625, 65.6015625, "minimap/newblips/fuel.png"},
	{1041.5549316406, -909.55316162109, 65.6015625, "minimap/newblips/tuning.png"},
	{1041.5549316406, -909.55316162109, 65.6015625, "minimap/newblips/shop_h.png"},
	{1238.8651123047, -1749.3966064453, 65.6015625, "minimap/newblips/cblip.png"},
	{1161.4174804688, -1321.0888671875, 37.501564025879, "minimap/newblips/korhaz.png"},
	{1563.8491210938, -1676.39453125, 48.501564025879, "minimap/newblips/pd.png"},
	{-2056.2399902344, -2462.4694824219, 38.00159072876, "minimap/newblips/fisherman.png"},
	{2132.451171875, -1152.2276611328, 31.00159072876, "minimap/newblips/carshop.png"},
	{1237.3883056641, -1166.96875, 34.501598358154, "minimap/newblips/carshop.png"},
	{1799.9488525391, -2062.7111816406, 24.501602172852, "minimap/newblips/impound.png"},
	{1783.2127685547, -1915.6734619141, 24.501602172852, "minimap/newblips/autosiskola.png"},
	{1204.2994384766, -1825.6458740234, 13.425382614136, "minimap/newblips/charger.png", 22, false, 9999, tocolor(49, 154, 215)},
	{1936.5513916016, -1809.9202880859, 13.3828125, "minimap/newblips/charger.png", 22, false, 9999, tocolor(49, 154, 215)},
	{1008.0865478516, -896.12103271484, 42.165958404541, "minimap/newblips/charger.png", 22, false, 9999, tocolor(49, 154, 215)},
}

local blipNames = {
	["minimap/newblips/versenypalya.png"] = "Versenypálya",
	["minimap/newblips/club.png"] = "Alhambra Club",
	["minimap/newblips/shop_h.png"] = "Hobby bolt",
	["minimap/newblips/carshop.png"] = "Autókereskedés",
	["minimap/newblips/bank.png"] = "Bank",
	["minimap/newblips/autosiskola.png"] = "Taxis munka",
	["minimap/newblips/tuning.png"] = "Tuning",
	["minimap/newblips/korhaz.png"] = "Kórház",
	["minimap/newblips/pd.png"] = "Rendőrség",
	["minimap/newblips/cb.png"] = "Cluckin' Bell",
	["minimap/newblips/vh.png"] = "Városháza",
	["minimap/newblips/szerelo.png"] = "Szerelőtelep",
	["minimap/newblips/banya.png"] = "Bánya",
	["minimap/newblips/gyar.png"] = "Gyár",
	["minimap/newblips/repter.png"] = "Reptér",
	["minimap/newblips/fuel.png"] = "Benzinkút",
	["minimap/newblips/hatar.png"] = "Határátkelőhely",
	["minimap/newblips/templom.png"] = "Templom",
	["minimap/newblips/loter.png"] = "Fegyverbolt & Lőtér",
	["minimap/newblips/hunting.png"] = "Vadászat",
	["minimap/newblips/favago.png"] = "Fatelep",
	["minimap/newblips/kikoto.png"] = "Kikötő",
	["minimap/newblips/kocsma.png"] = "Kocsma",
	["minimap/newblips/burger.png"] = "Burger Shot",
	["minimap/newblips/binco.png"] = "Ruhabolt",
	["minimap/newblips/fisherman.png"] = "Horgászbolt",
	["minimap/newblips/hunting2.png"] = "Vadász",
	["minimap/newblips/change.png"] = "Pénzváltó",
	["minimap/newblips/junkyard.png"] = "Roncstelep",
	["minimap/newblips/lottoblip.png"] = "Lottózó",
	["minimap/newblips/boat.png"] = "Hajóbolt",
	["minimap/newblips/cblip.png"] = "Kaszinó",
	["minimap/newblips/crab.png"] = "Rákászat",
	["minimap/newblips/szerelo_boat.png"] = "Szerelőtelep (hajó)",
	["minimap/newblips/szerelo_heli.png"] = "Szerelőtelep (helikopter)",
	["minimap/newblips/motel.png"] = "Motel",
	["minimap/newblips/sheriffblip.png"] = "Sheriffség",
	["minimap/newblips/kosar.png"] = "Streetball pálya",
	["minimap/newblips/markblip.png"] = "Kijelölt pont (Kattints a törléshez)",
	["minimap/newblips/north.png"] = "Észak",
	["minimap/newblips/impound.png"] = "Parkolási felügyelet",
	["minimap/newblips/lifeguard.png"] = "Vízimentő",
	["minimap/newblips/charger.png"] = "Töltőállomás"
}

createdBlips = {}
local blipTooltipText = {}
local farBlips = {}
local jobBlips = {}

state3DBlip = true
stateMarksBlip = true

function delJobBlips()
	for k = 1, #jobBlips do
		local v = jobBlips[k]

		if v then
			createdBlips[v] = nil
		end
	end

	local temp = {}

	for k = 1, #createdBlips do
		local v = createdBlips[k]

		if v then
			table.insert(temp, v)
		end
	end

	createdBlips = temp
	jobBlips = {}
	temp = nil
end

function addJobBlips(data)
	for k = 1, #data do
		if data[k] then
			table.insert(createdBlips, {
				blipPosX = data[1],
				blipPosY = data[2],
				blipPosZ = data[3],
				blipId = data[4],
				farShow = data[6],
				renderDistance = 9999,
				iconSize = data[5] or 48,
				blipColor = data[7] or tocolor(255, 255, 255)
			})
			table.insert(jobBlips, #createdBlips)
		end
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		for k, v in ipairs(getElementsByType("blip")) do
			blipTooltipText[v] = getElementData(v, "blipTooltipText")
		end

		for k, v in ipairs(defaultBlips) do
			v[5] = v[5] or 22
			v[6] = v[6] or false
			v[7] = v[7] or 9999
			v[8] = v[8] or tocolor(255, 255, 255)

			table.insert(createdBlips, {
				blipPosX = v[1],
				blipPosY = v[2],
				blipPosZ = v[3],
				blipId = v[4],
				iconSize = v[5],
				farShow = v[6],
				renderDistance = v[7],
				blipColor = v[8]
			})
		end
	end)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if getElementType(source) == "blip" then
			if dataName == "blipTooltipText" then
				blipTooltipText[source] = getElementData(source, "blipTooltipText")
			end
		end
	end)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if getElementType(source) == "blip" then
			blipTooltipText[source] = nil
		end
	end)

local damageStart = false

addEventHandler("onClientPlayerDamage", localPlayer,
	function ()
		damageStart = getTickCount()
	end)

local lastCrz = 0
local crzRad = 0
local crzSin = 0
local crzCos = 0

function renderBlip(icon, x1, y1, x2, y2, sx, sy, color, farshow, cameraRot, blipNum)
	if icon == "files/images/blips/markblip.png" and not stateMarksBlip then
		return
	end

	local x = 0 + rtsize / 2 + (remapTheFirstWay(x2) - remapTheFirstWay(x1)) * zoom
	local y = 0 + rtsize / 2 - (remapTheFirstWay(y2) - remapTheFirstWay(y1)) * zoom

	if not farshow and (x > rtsize or x < 0 or y > rtsize or y < 0) then
		return
	end

	local rendering = true

	if farshow then
		if icon == 0 then
			sx = sx / 1.5
			sy = sy / 1.5
		end

		if x > rtsize then
			x = rtsize
		elseif x < 0 then
			x = 0
		end

		if y > rtsize then
			y = rtsize
		elseif y < 0 then
			y = 0
		end

		local middleSize = rtsize / 2
		local angle = crzRad
		local x2 = middleSize + (x - middleSize) * crzCos - (y - middleSize) * crzSin
		local y2 = middleSize + (x - middleSize) * crzSin + (y - middleSize) * crzCos

		x2 = x2 + minimapX - rtsize / 2 + (minimapWidth - sx) / 2
		y2 = y2 + minimapY - rtsize / 2 + (minimapHeight - sy) / 2

		farBlips[blipNum] = nil

		if x2 < minimapX then
			rendering = false
			x2 = minimapX
		elseif x2 > minimapX + minimapWidth - sx then
			rendering = false
			x2 = minimapX + minimapWidth - sx
		end

		if y2 < minimapY then
			rendering = false
			y2 = minimapY
		elseif y2 > minimapY + minimapHeight - 30 - sy then
			rendering = false
			y2 = minimapY + minimapHeight - 30 - sy
		end

		if not rendering then
			farBlips[blipNum] = {x2, y2, sx, sy, icon, color}
		end
	end

	if rendering then
		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, 360 - cameraRot, 0, 0, color)
	end
end

function remapTheFirstWay(x)
	return (-x + 3000) / mapScaleFactor
end

function remapTheSecondWay(x)
	return (x + 3000) / mapScaleFactor
end

local lostSignalStart = false
local lostSignalDirection = false

render.minimap = function (x, y)
	if renderData.showTrashTray and not renderData.inTrash["minimap"] and smoothMove then
		return
	end
	if renderData.showTrashTray and renderData.inTrash["minimap"] and  smoothMove < resp(224) then
		return
	end
	minimapWidth, minimapHeight = tonumber(renderData.size.minimapX), tonumber(renderData.size.minimapY)

	local newRTsize = math.ceil((minimapWidth + minimapHeight) * 0.85)

	if math.abs(newRTsize - rtsize) > 10 then
		rtsize = newRTsize

		if isElement(renderTarget) then
			destroyElement(renderTarget)
		end

		renderTarget = dxCreateRenderTarget(rtsize, rtsize, true)
	end

	minimapX, minimapY = tonumber(x), tonumber(y)

	-- ** Zoom
	if getKeyState("num_add") and zoomval < 1.2 then
		zoomval = zoomval + 0.01
	elseif getKeyState("num_sub") and zoomval > 0.31 then
		zoomval = zoomval - 0.01
	end

	zoom = zoomval

	local pedveh = getPedOccupiedVehicle(localPlayer)

	if isElement(pedveh) then
		local velx, vely, velz = getElementVelocity(pedveh)
		local actualspeed = math.sqrt(velx * velx + vely * vely + velz * velz) * 180 / 1300

		if actualspeed >= 0.3 then
			actualspeed = 0.3
		end

		zoom = zoom - actualspeed
	end

	-- ** Map
	local px, py, pz = getElementPosition(localPlayer)
	local _, _, prz = getElementRotation(localPlayer)
	local dim = getElementDimension(localPlayer)

	if dim == 0 or dim == 987 then
		local crx, cry, crz = getElementRotation(getCamera())

		if crz ~= lastCrz then
			lastCrz = crz

			crzRad = math.rad(crz)
			crzSin = math.sin(crzRad)
			crzCos = math.cos(crzRad)
		end

		farBlips = {}

		dxUpdateScreenSource(screenSource, true)

		dxSetRenderTarget(renderTarget, true)
		dxSetBlendMode("modulate_add")

		dxDrawImageSection(0, 0, rtsize, rtsize, remapTheSecondWay(px) - rtsize / zoom / 2, remapTheFirstWay(py) - rtsize / zoom / 2, rtsize / zoom, rtsize / zoom, radarTexture)

		-- ** Blipek
		local blipCount = 0

		for k = 1, #createdBlips do
			local v = createdBlips[k]

			if v then
				blipCount = blipCount + 1

				renderBlip(v.blipId, v.blipPosX, v.blipPosY, px, py, v.iconSize, v.iconSize, v.blipColor, v.farShow, crz, blipCount)
			end
		end

		local blips = getElementsByType("blip")

		for k = 1, #blips do
			local v = blips[k]

			if v then
				local bx, by = getElementPosition(v)
				local color = tocolor(getBlipColor(v))

				blipCount = blipCount + 1

				if getBlipIcon(v) == 1 then
					renderBlip("minimap/newblips/munkajarmu.png", bx, by, px, py, 18, 15, tocolor(255, 255, 255), true, crz, blipCount)
				elseif getBlipIcon(v) == 2 then
					renderBlip("minimap/newblips/shop_h.png", bx, by, px, py, 14.5, 14.5, tocolor(255, 255, 255), true, crz, blipCount)
				else
					renderBlip("minimap/newblips/target.png", bx, by, px, py, 14.5, 14.5, color, true, crz, blipCount)
				end
			end
		end

		dxSetBlendMode("blend")
		dxSetRenderTarget()

		-- ** Térkép
		dxDrawRectangle(x, y, minimapWidth, minimapHeight, tocolor(26, 27, 31, 160))
		dxDrawImage(x - rtsize / 2 + minimapWidth / 2, y - rtsize / 2 + minimapHeight / 2, rtsize, rtsize, renderTarget, crz)

		--[[
		-- ** Távoli blipek
		for k, v in pairs(farBlips) do
			dxDrawImage(v[1], v[2], v[3], v[4], v[5], 0, 0, 0, v[6])
		end]]
		-- ** Pozíciónk
		local arrowsize = 60 / (4 - zoom) + 3
		dxDrawImage(x + (minimapWidth - arrowsize) / 2, y + (minimapHeight - arrowsize) / 2, arrowsize, arrowsize, "minimap/files/arrow.png", crz + math.abs(360 - prz))

		-- ** Rendertarget kitakarása a képernyőforrással
		local margin = respc(rtsize * 0.75)
		dxDrawImageSection(x - margin, y - margin, minimapWidth + margin * 2, margin, x - margin, y - margin, minimapWidth + margin * 2, margin, screenSource) -- felsó
		dxDrawImageSection(x - margin, y + minimapHeight, minimapWidth + margin * 2, margin, x - margin, y + minimapHeight, minimapWidth + margin * 2, margin, screenSource) -- alsó
		dxDrawImageSection(x - margin, y, margin, minimapHeight, x - margin, y, margin, minimapHeight, screenSource) -- bal
		dxDrawImageSection(x + minimapWidth, y, margin, minimapHeight, x + minimapWidth, y, margin, minimapHeight, screenSource) -- jobb
		
		-- dxDrawRectangle(x - 5, y - 5, 5, minimapHeight + 10, tocolor(26, 27, 31, 160))
        -- dxDrawRectangle(x, y - 5, minimapWidth, 5, tocolor(26, 27, 31, 160))
        -- dxDrawRectangle(x + minimapWidth, y - 5, 5, minimapHeight + 10, tocolor(26, 27, 31, 160))
        -- dxDrawRectangle(x, y + minimapHeight, minimapWidth, 5, tocolor(26, 27, 31, 160))

		dxDrawRectangle(x, y + minimapHeight - 30, minimapWidth, 30, tocolor(35, 39, 42, 160))
        dxDrawImage(x, y + minimapHeight - 27, 24, 24, "minimap/files/pin.png", 0, 0, 0, tocolor(243, 90, 90, 255))

        local currentZoneName = getZoneName(px, py, 0, true)
        dxDrawText(currentZoneName, x + 25, y + minimapHeight - 30, x + 25 + minimapWidth, y + minimapHeight - 30 + 30, tocolor(255, 255, 255, 255), locationFontScale, locationFont, "left", "center")
	end
end

local bigRadarState = false

local bigmapWidth = screenX - 60 
local bigmapHeight = screenY - 60 
local bigmapX = 30
local bigmapY = 30

local zoom = 0.5

local cursorX, cursorY = -1, -1
local lastCursorPos = false
local cursorMoveDiff = false

local mapMoveDiff = false
local lastMapMovePos = false
local mapIsMoving = false

local lastMapPosX, lastMapPosY = 0, 0
local mapMovedX, mapMovedY = 0, 0

local hoverBlip = false
local hoverMarkBlip = false
local hoverMarksButton = false
local hoverMarksRemove = false
local hover3DBlip = false

function render3DBlips()
	if getElementDimension(localPlayer) == 0 then
		local px, py, pz = getElementPosition(localPlayer)

		if pz < 10000 then
			local blips = getElementsByType("blip")

			for i = 1, #blips do
				local v = blips[i]

				if v then
					if getElementAttachedTo(v) ~= localPlayer then
						local bx, by, bz = getElementPosition(v)
						local sx, sy = getScreenFromWorldPosition(bx, by, bz)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, bx, by, bz)
							local tooltip = ""

							if blipTooltipText[v] then
								tooltip = blipTooltipText[v]
							end

							dxDrawText(math.floor(dist) .. " m\n" .. tooltip, sx + 1, sy + 1 + 7.5 + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m#e0e0e0\n" .. tooltip, sx, sy + 7.5 + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top", false, false, false, true)

							local icon = "target"
							local color = tocolor(getBlipColor(v))

							if getBlipIcon(v) == 1 then
								icon = "munkajarmu"
								color = tocolor(255, 255, 255)
							elseif getBlipIcon(v) == 2 then
								icon = "shop_h"
								color = tocolor(255, 255, 255)
							end

							dxDrawImage(sx - 9, sy - 7.5, 18, 15, "minimap/newblips/" .. icon .. ".png", 0, 0, 0, color)
						end
					end
				end
			end

			for i = 1, #createdBlips do
				local v = createdBlips[i]

				if v then
					if v.blipId == "minimap/newblips/markblip.png" and stateMarksBlip then
						local z = getGroundPosition(v.blipPosX, v.blipPosY, 400) + 3
						local sx, sy = getScreenFromWorldPosition(v.blipPosX, v.blipPosY, z)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, v.blipPosX, v.blipPosY, z)
							local size = v.iconSize / 2

							dxDrawText(math.floor(dist) .. " m\nKijelölt pont", sx + 1, sy + 1 + size + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m#e0e0e0\nKijelölt pont", sx, sy + size + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top", false, false, false, true)

							dxDrawImage(sx - size, sy - size, v.iconSize, v.iconSize, "minimap/newblips/markblip2.png", 0, 0, 0, tocolor(255, 255, 255, 200))
						end
					end

					if string.find(v.blipId, "jobblips") then
						local z = getGroundPosition(v.blipPosX, v.blipPosY, 400) + 3
						local sx, sy = getScreenFromWorldPosition(v.blipPosX, v.blipPosY, z)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(px, py, pz, v.blipPosX, v.blipPosY, z)
							local size = v.iconSize / 2

							dxDrawText(math.floor(dist) .. " m", sx + 1, sy + 1 + size + respc(4), sx, 0, tocolor(0, 0, 0, 255), 0.75, Roboto, "center", "top")
							dxDrawText(math.floor(dist) .. " m", sx, sy + size + respc(4), sx, 0, tocolor(255, 255, 255), 0.75, Roboto, "center", "top")

							dxDrawImage(sx - size, sy - size, v.iconSize, v.iconSize, v.blipId, 0, 0, 0, tocolor(255, 255, 255, 200))
						end
					end
				end
			end
		end
	end
end

function renderBigBlip(icon, x1, y1, x2, y2, sx, sy, color, maxdist, tooltip, id, element)
	if icon == "minimap/newblips/markblip.png" and not stateMarksBlip then
		return
	end

	if maxdist and getDistanceBetweenPoints2D(x2, y2, x1, y1) > maxdist then
		return
	end

	local x = bigmapX + bigmapWidth / 2 + (remapTheFirstWay(x2) - remapTheFirstWay(x1)) * zoom
	local y = bigmapY + bigmapHeight / 2 - (remapTheFirstWay(y2) - remapTheFirstWay(y1)) * zoom

	sx = (sx / (4 - zoom) + 3) * 2.25
	sy = (sy / (4 - zoom) + 3) * 2.25

	if x < bigmapX + sx / 2 then
		x = bigmapX + sx / 2
	elseif x > bigmapX + bigmapWidth - sx / 2 then
		x = bigmapX + bigmapWidth - sx / 2
	end

	if y < bigmapY + sy / 2 then
		y = bigmapY + sy / 2
	elseif y > bigmapY + bigmapHeight - respc(30) - sy / 2 then
		y = bigmapY + bigmapHeight - respc(30) - sy / 2
	end

	if cursorX and cursorY then
		if not hoverBlip then
			if cursorX >= x - sx / 2 and cursorY >= y - sy / 2 and cursorX <= x + sx / 2 and cursorY <= y + sy / 2 then
				hoverYardText = getDistanceBetweenPoints2D(x1, y1, getElementPosition(localPlayer))

				if isElement(element) and getElementType(element) == "player" then
					hoverBlip = element
					--hoverBlipDatas = element
				elseif tooltip then
					hoverBlip = tooltip
					--hoverBlipDatas = hoverBlip
				elseif blipNames[icon] then
					hoverBlip = blipNames[icon]
					--hoverBlipDatas = maxdist
					--print(maxdist)
				end

				if icon == "minimap/newblips/markblip.png" then
					hoverMarkBlip = id
					--hoverBlipDatas = id
				end

			end
		end
	end

	if icon == "minimap/files/arrow.png" then
		local _, _, prz = getElementRotation(localPlayer)

		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, math.abs(360 - prz))
	else
		dxDrawImage(x - sx / 2, y - sy / 2, sx, sy, icon, 0, 0, 0, color)
	end
end

function renderTheBigmap()
	buttonsC = {}

	local px, py, pz = getElementPosition(localPlayer)
	local _, _, prz = getElementRotation(localPlayer)
	local dim = getElementDimension(localPlayer)

	hover3DBlip = false
	hoverMarkBlip = false
	hoverMarksButton = false
	hoverMarksRemove = false

	if dim == 0 or dim == 987 then
		-- ** Térkép mozgatása
		cursorX, cursorY = getCursorPosition()

		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenX, cursorY * screenY

			if getKeyState("mouse1") then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end

				if not cursorMoveDiff then
					cursorMoveDiff = {0, 0}
				end

				cursorMoveDiff = {
					cursorMoveDiff[1] + cursorX - lastCursorPos[1],
					cursorMoveDiff[2] + cursorY - lastCursorPos[2]
				}

				if not lastMapMovePos then
					if not mapMoveDiff then
						lastMapMovePos = {0, 0}
					else
						lastMapMovePos = {mapMoveDiff[1], mapMoveDiff[2]}
					end
				end

				if not mapMoveDiff then
					if math.abs(cursorMoveDiff[1]) >= 3 or math.abs(cursorMoveDiff[2]) >= 3 then
						mapMoveDiff = {
							lastMapMovePos[1] - cursorMoveDiff[1] / zoom / mapUnit,
							lastMapMovePos[2] + cursorMoveDiff[2] / zoom / mapUnit
						}
						mapIsMoving = true
					end
				elseif cursorMoveDiff[1] ~= 0 or cursorMoveDiff[2] ~= 0 then
					mapMoveDiff = {
						lastMapMovePos[1] - cursorMoveDiff[1] / zoom / mapUnit,
						lastMapMovePos[2] + cursorMoveDiff[2] / zoom / mapUnit
					}
					mapIsMoving = true
				end

				lastCursorPos = {cursorX, cursorY}
			else
				if mapMoveDiff then
					lastMapMovePos = {mapMoveDiff[1], mapMoveDiff[2]}
				end

				lastCursorPos = false
				cursorMoveDiff = false
			end
		end

		mapMovedX, mapMovedY = lastMapPosX, lastMapPosY

		if mapMoveDiff then
			mapMovedX = mapMovedX + mapMoveDiff[1]
			mapMovedY = mapMovedY + mapMoveDiff[2]
		else
			mapMovedX, mapMovedY = px, py
			lastMapPosX, lastMapPosY = mapMovedX, mapMovedY
		end
		local mapPlayerPosX = remapTheSecondWay(mapMovedX) - bigmapWidth / zoom / 2
		local mapPlayerPosY = remapTheFirstWay(mapMovedY) - bigmapHeight / zoom / 2

		dxDrawRectangle(bigmapX - 5, bigmapX - 5, bigmapWidth + 10, bigmapHeight + 10, tocolor(0, 0, 0, 125)) -- F11 keret
		dxDrawImage(bigmapX, bigmapY, bigmapWidth, bigmapHeight, "files/images/vin.png")
		dxDrawImageSection(bigmapX, bigmapY, bigmapWidth, bigmapHeight, mapPlayerPosX, mapPlayerPosY, bigmapWidth / zoom, bigmapHeight / zoom, radarTexture2, 0, 0, 0, tocolor(255, 255, 255))

		-- ** Blipek
		local blipCount = 0

		for k = 1, #createdBlips do
			local v = createdBlips[k]

			if v then
				blipCount = blipCount + 1

				renderBigBlip(v.blipId, v.blipPosX, v.blipPosY, mapMovedX, mapMovedY, v.iconSize, v.iconSize, v.blipColor, v.renderDistance or 9999, v.tooltip, blipCount)
			end
		end

		local blips = getElementsByType("blip")

		for k = 1, #blips do
			local v = blips[k]

			if v then
				local bx, by = getElementPosition(v)
				local renderDistance = getBlipVisibleDistance(v)
				local color = tocolor(getBlipColor(v))

				blipCount = blipCount + 1

				if getBlipIcon(v) == 1 then
					renderBigBlip("minimap/newblips/munkajarmu.png", bx, by, mapMovedX, mapMovedY, 18, 15, tocolor(255, 255, 255), renderDistance, blipTooltipText[v], blipCount, v)
				elseif getBlipIcon(v) == 2 then
					renderBigBlip("minimap/newblips/shop_h.png", bx, by, mapMovedX, mapMovedY, 14.5, 14.5, tocolor(255, 255, 255), renderDistance, blipTooltipText[v], blipCount, v)
				else
					renderBigBlip("minimap/newblips/target.png", bx, by, mapMovedX, mapMovedY, 14.5, 14.5, color, renderDistance, blipTooltipText[v], blipCount, v)
				end
			end
		end

		-- ** Pozíciónk
		dxDrawImage(bigmapX, bigmapY, bigmapWidth, bigmapHeight, "files/images/vin.png")

		renderBigBlip("minimap/files/arrow.png", px, py, mapMovedX, mapMovedY, 20, 20)

		if mapMoveDiff then
			renderBigBlip("minimap/newblips/cross.png", mapMovedX, mapMovedY, mapMovedX, mapMovedY, 128, 128)
		end

		dxDrawRectangle(bigmapX, bigmapY + bigmapHeight - respc(30), bigmapWidth, respc(30), tocolor(0, 0, 0, 200))

		if tonumber(cursorX) then
			local zx = reMap((cursorX - bigmapX) / zoom + mapPlayerPosX, 0, radarTextureSize, -3000, 3000)
			local zy = reMap((cursorY - bigmapY) / zoom + mapPlayerPosY, 0, radarTextureSize, 3000, -3000)

			-- Cursor zóna
			dxDrawText(getZoneName(zx, zy, 0), bigmapX + respc(10), bigmapX + bigmapHeight - respc(30), bigmapX + bigmapY, bigmapX + bigmapHeight, tocolor(255, 255, 255), 0.5, BrushScriptStd, "left", "center")

			if hoverBlip then -- kijelölt blip
				local tooltipWidth = dxGetTextWidth(hoverBlip, 0.75, Roboto) + respc(10)
				dxDrawRectangle(cursorX + respc(12.5), cursorY, tooltipWidth, respc(35), tocolor(25, 25, 25, 190))
				if hoverYardText then
					dxDrawText(hoverBlip .." \n ".. math.floor(hoverYardText) .. " m", cursorX + respc(12.5), cursorY, cursorX + tooltipWidth + respc(12.5), cursorY + respc(35), tocolor(255, 255, 255, 255), 0.75, Roboto, "center", "center")
				end
			end
		else -- player zóna
			dxDrawText(getZoneName(px, py, pz), bigmapX + respc(10), bigmapX + bigmapHeight - respc(30), bigmapX + bigmapWidth, bigmapX + bigmapHeight, tocolor(255, 255, 255), 0.5, BrushScriptStd, "left", "center")
		end

		dxDrawRectangle(bigmapX - 2, bigmapY - 2, bigmapWidth + 2 * 2, 2, (tocolor(0, 0, 0, 200)))
		dxDrawRectangle(bigmapX - 2, bigmapY + bigmapHeight, bigmapWidth + 2 * 2, 2, (tocolor(0, 0, 0, 200)))
		dxDrawRectangle(bigmapX - 2, bigmapY, 2, bigmapHeight, (tocolor(0, 0, 0, 200)))
		dxDrawRectangle(bigmapX + bigmapWidth, bigmapY, 2, bigmapHeight, (tocolor(0, 0, 0, 200)))

		if hoverBlip then
			hoverBlip = false
		end

		-- ** 3D blipek
		dxDrawText("3D blipek  ", bigmapX, bigmapY + bigmapHeight - respc(30), bigmapX + bigmapWidth - respc(30), bigmapY + bigmapHeight, tocolor(255, 255, 255), 0.75, Roboto, "right", "center")

		if state3DBlip then
			dxDrawImage(bigmapX + bigmapWidth - respc(30), bigmapY + bigmapHeight - respc(30), respc(30), respc(30), "files/images/tick_on.png")
		else
			dxDrawImage(bigmapX + bigmapWidth - respc(30), bigmapY + bigmapHeight - respc(30), respc(30), respc(30), "files/images/tick.png")
		end

		if tonumber(cursorX) and cursorX >= bigmapX + bigmapWidth - respc(30) - dxGetTextWidth("  3D blipek  ", 0.75, Roboto) and cursorX <= bigmapX + bigmapWidth and cursorY >= bigmapY + bigmapHeight - respc(30) and cursorY <= bigmapY + bigmapHeight then
			hover3DBlip = true
		end

		-- ** Jelölések be/ki
		local totalWidth = respc(30) * 2 + dxGetTextWidth("3D blipek", 0.75, Roboto)

		dxDrawText("Jelölések  ", bigmapX, bigmapY + bigmapHeight - respc(30), bigmapX + bigmapWidth - totalWidth, bigmapY + bigmapHeight, tocolor(255, 255, 255), 0.75, Roboto, "right", "center")

		if stateMarksBlip then
			dxDrawImage(bigmapX + bigmapWidth - totalWidth, bigmapY + bigmapHeight - respc(30), respc(30), respc(30), "files/images/tick_on.png")
		else
			dxDrawImage(bigmapX + bigmapWidth - totalWidth, bigmapY + bigmapHeight - respc(30), respc(30), respc(30), "files/images/tick.png")
		end

		if tonumber(cursorX) and cursorX >= bigmapX + bigmapWidth - totalWidth - dxGetTextWidth("  Jelölések  ", 0.75, Roboto) and cursorX <= bigmapX + bigmapWidth - totalWidth and cursorY >= bigmapY + bigmapHeight - respc(30) and cursorY <= bigmapY + bigmapHeight then
			hoverMarksButton = true
		end
		
		if mapMoveDiff then
			dxDrawText("A nézet visszaállításához nyomd meg a 'SPACE' gombot.", bigmapX, bigmapY + bigmapHeight - respc(30), bigmapX + bigmapWidth, bigmapY + bigmapHeight, tocolor(255, 255, 255), 1, Roboto, "center", "center")
			if getKeyState("space") then
				mapMoveDiff = false
				lastMapMovePos = false
			end
		end
		activeButtonC = false
	else
		renderMinimapExport(bigmapX, bigmapY, bigmapWidth, bigmapHeight)
	end

	local cx, cy = getCursorPosition()

	if tonumber(cx) and tonumber(cy) then
		cx = cx * screenX
		cy = cy * screenY

		activeButtonC = false

		if not buttonsC then
			return
		end
		for k,v in pairs(buttonsC) do
			if cx >= v[1] and cy >= v[2] and cx <= v[1] + v[3] and cy <= v[2] + v[4] then
				activeButtonC = k
				break
			end
		end
	else
		activeButtonC = false
	end
end

function bigmapClickHandler(button, state, absX, absY)
	if not bigRadarState then
		return
	end

	if activeButtonC == "stateMarksRemove" then
		if state == "up" then
			for i = #createdBlips, 1, -1 do
				if createdBlips[i].blipId == "minimap/newblips/markblip.png" then
					table.remove(createdBlips, i)
				end
			end
		end

		return
	end

	if hover3DBlip then
		if state == "up" then
			state3DBlip = not state3DBlip

			if state3DBlip then
				addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
			else
				removeEventHandler("onClientHUDRender", getRootElement(), render3DBlips)
			end
		end

		return
	end

	if state == "up" and mapIsMoving then
		mapIsMoving = false
		return
	end

	if state == "up" and button == "right" and stateMarksBlip and not activeButtonC then
		if absX >= bigmapX and absY >= bigmapY and absX <= bigmapX + bigmapWidth and absY <= bigmapY + bigmapHeight then
			if hoverMarkBlip then
				table.remove(createdBlips, hoverMarkBlip)
			else
				local tx = reMap((absX - bigmapX) / zoom + (remapTheSecondWay(mapMovedX) - bigmapWidth / zoom / 2), 0, radarTextureSize, -3000, 3000)
				local ty = reMap((absY - bigmapY) / zoom + (remapTheFirstWay(mapMovedY) - bigmapHeight / zoom / 2), 0, radarTextureSize, 3000, -3000)
				local tz = getGroundPosition(tx, ty, 400) + 3

				table.insert(createdBlips, {
					blipPosX = tx,
					blipPosY = ty,
					blipPosZ = tz,
					blipId = "minimap/newblips/markblip.png",
					farShow = true,
					renderDistance = 9999,
					iconSize = 18,
					blipColor = tocolor(255, 255, 255)
				})
			end
		end
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, state)
		if key == "F11" then
			if state and renderData.loggedIn then
				bigRadarState = not bigRadarState

				if bigRadarState then
					hideHUD()

					addEventHandler("onClientHUDRender", getRootElement(), renderTheBigmap)
					addEventHandler("onClientClick", getRootElement(), bigmapClickHandler)
					addEventHandler("onClientPreRender", getRootElement(), bigmapZoomHandler)

					playSound("minimap/files/f11radaropen.mp3")
				else
					playSound("minimap/files/f11radarclose.mp3")

					removeEventHandler("onClientHUDRender", getRootElement(), renderTheBigmap)
					removeEventHandler("onClientClick", getRootElement(), bigmapClickHandler)
					removeEventHandler("onClientPreRender", getRootElement(), bigmapZoomHandler)

					showHUD()
				end

				setElementData(localPlayer, "bigRadarState", bigRadarState, false)
			end

			cancelEvent()
		elseif key == "mouse_wheel_up" and bigRadarState then
			if targetZoom + 0.1 <= 3.1 then
				targetZoom = targetZoom + 0.1
			end
		elseif key == "mouse_wheel_down" and bigRadarState then
			if targetZoom - 0.1 >= 0.1 then
				targetZoom = targetZoom - 0.1
			end
		end
	end
)

function bigmapZoomHandler(timeSlice)
	zoom = zoom + (targetZoom - zoom) * timeSlice * 0.01
end

local zoneLineHeight = respc(30)
local minimapRenderSize = 400
min, max, cos, sin, rad, deg, atan2 = math.min, math.max, math.cos, math.sin, math.rad, math.deg, math.atan2
sqrt, abs, floor, ceil, random = math.sqrt, math.abs, math.floor, math.ceil, math.random
gsub = string.gsub

minimapRenderSize = 400
minimapRenderHalfSize = minimapRenderSize * 0.5
if isElement(minimapRender) then
	destroyElement(minimapRender)
end
minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize, true)

function renderMinimapExport(x, y, w, h)
	minimapWidth = w
	minimapHeight = h

	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end

	minimapCenterX = minimapPosX + minimapWidth / 2
	minimapCenterY = minimapPosY + minimapHeight / 2

	dxUpdateScreenSource(screenSource, true)

	minimapZoom = 0.4

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
	local cameraRotation = deg(atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90
	local crx, cry, crz = getElementRotation(getCamera())

	local minimapRenderSizeOffset = respc(minimapRenderSize * 0.75)

	farshowBlips = {}
	farshowBlipsData = {}

	if playerDimension == 0 or playerDimension == 65000 or playerDimension == 33333 then
		local remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		local farBlips = {}
		local farBlipsCount = 10000
		local manualBlipsCount = 1
		local defaultBlipsCount = 1

		dxSetRenderTarget(minimapRender)
		dxDrawImageSection(0, 0, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, radarTexture)

		for i = 1, #createdBlips do
			if createdBlips[i] then
				if createdBlips[i].farShow then
					farBlips[farBlipsCount + manualBlipsCount] = createdBlips[i].icon
				end
				manualBlipsCount = manualBlipsCount + 1
				--renderBlip2(createdBlips[i].blipId, createdBlips[i].blipPosX, createdBlips[i].blipPosY, remapPlayerPosX, remapPlayerPosY, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].blipColor, createdBlips[i].farShow, crz, manualBlipsCount)
			end
		end

		dxSetRenderTarget()
		dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, minimapRender)


	end

	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
	dxDrawImageSection(minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)

	local textWidth = dxGetTextWidth(getZoneName(playerPosX, playerPosY, playerPosZ), 0.7, Roboto) + 14
	local centerText = (minimapCenterX) - (textWidth /2)
	dxDrawRectangle(centerText, minimapPosY + minimapHeight - 25, textWidth, 18, tocolor(0, 0, 0, 180))
	dxDrawText(getZoneName(playerPosX, playerPosY, playerPosZ), centerText, minimapPosY + minimapHeight - 25, textWidth + centerText, 18 + minimapPosY + minimapHeight - 25, tocolor(255, 255, 255, 255), 0.75, Roboto, "center", "center", false, false, false, true)
	
	if playerDimension == 0 then
		local playerArrowSize = 60 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		local _, _, playerRotation = getElementRotation(localPlayer)

		dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "minimap/files/arrow.png", abs(360 - playerRotation))
	else
		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(0, 0, 0))

		if not lostSignalStartTick then
			lostSignalStartTick = getTickCount()
		end

		local fadeAlpha = 255
		if not lostSignalFadeIn then
			fadeAlpha = 255
		else
			fadeAlpha = 0
		end

		local lostSignalTick = (getTickCount() - lostSignalStartTick) / 1500
		if lostSignalTick > 1 then
			lostSignalStartTick = getTickCount()
			lostSignalFadeIn = not lostSignalFadeIn
		end

		dxDrawImage(minimapPosX + minimapWidth - 64, minimapPosY, 64, 16, "minimap/files/nosignalszoveg.png")
	end

	if damageEffectStart then
		if tonumber(damageEffectStart) then
			if getTickCount() - damageEffectStart >= 1000 then
				damageEffectStart = false
				return
			end
		else
			damageEffectStart = false
			return
		end

		local effectProgress = (getTickCount() - damageEffectStart) / 500
		if effectProgress > 1 then
			damageEffectStart = false
			return
		end

		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(255, 0, 0, interpolateBetween(150, 0, 0, 0, 0, 0, effectProgress, "Linear")))
	end
end

function renderBlip2(icon, blipX, blipY, playerPosX, playerPosY, blipWidth, blipHeight, blipColor, farShow, blipTableId)
	local blipPosX = minimapRenderHalfSize + (playerPosX - remapTheFirstWay(blipX)) * zoom
	local blipPosY = minimapRenderHalfSize - (playerPosY - remapTheFirstWay(blipY)) * zoom

	if not farShow and (blipPosX > minimapRenderSize or 0 > blipPosX or blipPosY > minimapRenderSize or 0 > blipPosY) then
		return
	end

	
	minimapPosX = 1024
	minimapPosY = 1024


	local blipIsVisible = true
	if farShow then
		if blipPosX > minimapRenderSize then
			blipPosX = minimapRenderSize
		end
		if blipPosX < 0 then
			blipPosX = 0
		end
		if blipPosY > minimapRenderSize then
			blipPosY = minimapRenderSize
		end
		if blipPosY < 0 then
			blipPosY = 0
		end

		local blipScreenPosX = minimapPosX - minimapRenderHalfSize + minimapWidth / 2 + (minimapRenderHalfSize * (blipPosX - minimapRenderHalfSize)  * (blipPosY - minimapRenderHalfSize) - blipWidth / 2)
		local blipScreenPosY = minimapPosY - minimapRenderHalfSize + minimapHeight / 2 + (minimapRenderHalfSize * (blipPosX - minimapRenderHalfSize) * (blipPosY - minimapRenderHalfSize) - blipHeight / 2)

		farshowBlips[blipTableId] = nil

		if blipScreenPosX < minimapPosX or blipScreenPosX > minimapPosX + minimapWidth - blipWidth then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if blipScreenPosY < minimapPosY or blipScreenPosY > minimapPosY + minimapHeight - zoneLineHeight - blipHeight then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if farshowBlips[blipTableId] then
			farshowBlipsData[blipTableId] = {
				posX = max(minimapPosX, min(minimapPosX + minimapWidth - blipWidth, blipScreenPosX)),
				posY = max(minimapPosY, min(minimapPosY + minimapHeight - zoneLineHeight - blipHeight, blipScreenPosY)),
				icon = icon,
				iconWidth = blipWidth,
				iconHeight = blipHeight,
				color = blipColor
			}
		end
	end

	if blipIsVisible then
		dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "" .. icon, 0, 0, blipColor)
	end
end

