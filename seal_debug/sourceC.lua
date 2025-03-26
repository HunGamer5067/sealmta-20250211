local screenX, screenY = guiGetScreenSize()

local font = false
local fontH = 12
local fontScale = 1

local debugStringMessages = {}
local debugState = false

local debugWidgetPos = {screenX / 2 - 400, screenY - 400}
local debugWidgetSize = {800, 320}

local lines = 20
local deltaValues = {}
local delta = d

function preRenderDebug(d)
    delta = d
    table.insert(deltaValues, 1, d)

    for i = #deltaValues, 100, -1 do
        table.remove(deltaValues, i)
    end
end

function renderDebug()
    local x, y = debugWidgetPos[1], debugWidgetPos[2]

    if not isElement(font) then
        font = exports.seal_gui:getFont("11/Ubuntu-L.ttf")
        fontH = exports.seal_gui:getFontHeight("11/Ubuntu-L.ttf")
        fontScale = exports.seal_gui:getFontScale("11/Ubuntu-L.ttf")
        lines = math.floor(debugWidgetSize[2] / fontH + 0.5) - 1
        return
    end

    y = y + lines * fontH

    local status = dxGetStatus()
    local text = "Font: " .. status.VideoMemoryUsedByFonts .. " MB, Texture: " .. status.VideoMemoryUsedByTextures .. " MB, RT:" .. status.VideoMemoryUsedByRenderTargets .. " MB, D: " .. string.format("%.2f", delta or 0) .. " ms (" .. math.floor(1000 / (delta or 1) + 0.5) .. " FPS)"
  
    dxDrawBorderText(text, x, y, 0, 0, tocolor(255, 255, 255), fontScale, font, "left", "top", false, false, false, true)

    local w = dxGetTextWidth(text, fontScale, font)
    local ly = false
    local lx = x + w

    for i = 1, #deltaValues do
        local d = deltaValues[i]
        local y = y + fontH * (1 - 1000 / d / 75)
        local s = d / 13
        dxDrawLine(lx, ly or y, lx + s, y)
        lx = lx + s
        ly = y
    end

    y = y - fontH

    for i = 1, lines do
        if debugStringMessages[i] then
            dxDrawBorderText(debugStringMessages[i][1] .. "x " .. debugStringMessages[i][2], x, y, 0, 0, tocolor(255, 255, 255), fontScale, font, "left", "top", false, false, false, true)
            y = y - fontH
        end
    end
end

addCommandHandler("debug",
	function ()
		if getElementData(localPlayer, "acc.adminLevel") >= 7 then

            if debugState then
                removeEventHandler("onClientRender", getRootElement(), renderDebug)
                removeEventHandler("onClientPreRender", getRootElement(), preRenderDebug)
            else
                addEventHandler("onClientRender", getRootElement(), renderDebug, true, "low-999999999999999999")
                addEventHandler("onClientPreRender", getRootElement(), preRenderDebug)

                font = exports.seal_gui:getFont("11/Ubuntu-L.ttf")
                fontH = exports.seal_gui:getFontHeight("11/Ubuntu-L.ttf")
                fontScale = exports.seal_gui:getFontScale("11/Ubuntu-L.ttf")

                lines = math.floor(debugWidgetSize[2] / fontH + 0.5) - 1
            end

            debugState = not debugState
            outputChatBox(inspect(debugState))
		end
	end
)

function dxDrawBorderText(t, x, y, x2, y2, c, s, f, a1, a2, m1, m2, m3, m4)
    local t2 = utf8.gsub(t, "#%x%x%x%x%x%x", "")
    dxDrawText(t2, x + 1, y + 1, x2 + 1, y2 + 1, tocolor(0, 0, 0, 200), s, f, a1, a2, m1, m2, m3, m4, true)
    dxDrawText(t, x, y, x2, y2, c, s, f, a1, a2, m1, m2, m3, m4, true)
end

addCommandHandler("cd",
    function()
        debugStringMessages = {}
        addDebugLine("astral debug init")
    end
)

function addDebugLine(msg)
    if debugState then
        for i = 1, #debugStringMessages do
            if debugStringMessages[i][2] == msg then
                debugStringMessages[i] = {
                    debugStringMessages[i][1] + 1,
                    debugStringMessages[i][2]
                }

                return
            end
        end

        local tmp = {}

        for i = 1, 500 do
            if debugStringMessages[i] then
                tmp[i + 1] = debugStringMessages[i]
            end
        end

        tmp[1] = {1, msg}
        debugStringMessages = {}

        for i = 1, #tmp do
            debugStringMessages[i] = tmp[i]
        end
    end
end
addEvent("addDebugLine", true)
addEventHandler("addDebugLine", resourceRoot, addDebugLine)

addEventHandler("onClientDebugMessage", getRootElement(),
    function(message, level, file, line)
        if debugState then
            if level == 1 then
                level = "#d75959[ERROR] "
            elseif level == 2 then
                level = "#FF9600[WARNING] "
            else
                level = "#7cc576[INFO] "
            end

            if file and line then
                addDebugLine(level .. file .. ":" .. line .. ", " .. message)
            else
                addDebugLine(level .. message)
            end
        end
    end
)

addDebugLine("astral debug init")