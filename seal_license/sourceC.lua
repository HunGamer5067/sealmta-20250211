local screenX, screenY = guiGetScreenSize()

local sx, sy = 516, 316
local x = screenX / 2 - sx / 2
local y = screenY / 2 - sy / 2

local photoStart = false
local photoSource = false
local photoShader = false
local photoShaderSource = " texture sBaseTexture; float blur = 0; float Contrast = 0; float Saturation = 1; const float3 lumCoeff = float3(0.2125, 0.7154, 0.0721); sampler Samp = sampler_state { Texture = (sBaseTexture); AddressU = MIRROR; AddressV = MIRROR; }; float4 PixelShaderFunction(float2 uv : TEXCOORD) : COLOR { float4 outputColor = tex2D(Samp, uv); if(blur > 0) { for (float i = 1; i < 3; i++) { outputColor += tex2D(Samp, float2(uv.x, uv.y + (i * blur))); outputColor += tex2D(Samp, float2(uv.x, uv.y - (i * blur))); outputColor += tex2D(Samp, float2(uv.x - (i * blur), uv.y)); outputColor += tex2D(Samp, float2(uv.x + (i * blur), uv.y)); } outputColor /= 9; } outputColor.rgb = (outputColor.rgb - 0.5) *(Contrast + 1.0) + 0.5; float3 intensity = float(dot(outputColor.rgb, lumCoeff)); outputColor.rgb = lerp(intensity, outputColor.rgb, Saturation ); return outputColor; } technique movie { pass P0 { PixelShader = compile ps_2_0 PixelShaderFunction(); } } technique fallback { pass P0 { } } "
local photoX, photoY, photoZ
local photoSent = false
local photoUpdated = false

local officePedPoses = {
	{12, "Judith Smith", 1507.4544677734, -1801.28125, 17.54686164856, 0},
	{150, "Sunshine Walker", 1499.5498046875, -1801.146484375, 17.54686164856, 270},
	{40, "Monica Degucci", 1513.6904296875, -1796.7919921875, 17.54686164856, 90},
	{76, "Maria Weaver", 1513.6904296875, -1801.072265625, 17.54686164856, 90},
	{148, "Joyce Rudement", 1513.69140625, -1805.349609375, 17.54686164856, 90}
}

local officePeds = {}
local officeButtons = {}

local licenseBackground = false
local waitingForLicenseOffice = false

for i = 1, #officePedPoses do
    local ped = createPed(officePedPoses[i][1], officePedPoses[i][3], officePedPoses[i][4], officePedPoses[i][5], officePedPoses[i][6])
    setElementData(ped, "visibleName", officePedPoses[i][2])
    setElementData(ped, "pedNameType", "Ügyintéző")
    setElementFrozen(ped, true)
    setElementData(ped, "invulnerable", true)

    if officePedPoses[i][7] then
        setElementInterior(ped, officePedPoses[i][7])
    end

    if officePedPoses[i][8] then
        setElementDimension(ped, officePedPoses[i][8])
    end

    officePeds[ped] = true
end

addEvent("endLicensePhotoMode", true)
addEventHandler("endLicensePhotoMode", resourceRoot,
    function()
        if isElement(photoSource) then
            destroyElement(photoSource)
        end

        if isElement(photoShader) then
            destroyElement(photoShader)
        end

        photoSource = false
        photoShader = false
        photoStart = false

        if photoX then
            setElementPosition(localPlayer, photoX, photoY, photoZ)
            setCameraTarget(localPlayer)
        end

        waitingForLicenseOffice = false
        photoX, photoY, photoZ = nil, nil, nil

        exports.seal_hud:showHUD()

        removeEventHandler("onClientRender", getRootElement(), renderLicensePhoto)
    end
)

function renderLicensePhoto()
    setElementPosition(localPlayer, 1515.3582763672, -1803.07421875, 17.54686164856)
    setElementRotation(localPlayer, 0, 0, 90, "default", true)

    local delta = getTickCount() - photoStart
    local x, y, z = getPedBonePosition(localPlayer, 8)

    if delta < 300 then
        setCameraMatrix(x - 0.65 * (1.5 - 0.5 * (delta / 300)), y, z, x, y, z)
        dxSetShaderValue(photoShader, "blur", 0.0035 + 0.025 * (1 - delta / 300))
    else
        setCameraMatrix(x - 0.65, y, z, x, y, z)

        if 500 < delta then
            dxSetShaderValue(photoShader, "blur", 0)
        else
            dxSetShaderValue(photoShader, "blur", 0.0035 * (1 - (delta - 400) / 100))
        end
    end

    dxDrawImage(0, 0, screenX, screenY, photoShader)

    if 800 < delta and delta < 1000 and photoUpdated then
        local a = 1 - math.min(1, (delta - 800) / 75)
        dxSetShaderValue(photoShader, "Contrast", -0.25)
        dxSetShaderValue(photoShader, "Saturation", 0)
        dxSetShaderValue(photoShader, "blur", 0)
        dxDrawRectangle(0, 0, screenX, screenY, tocolor(255, 255, 255, 255 * a))
    elseif 1000 < delta and not photoSent and photoUpdated then
        dxSetShaderValue(photoShader, "Contrast", -0.25)
        dxSetShaderValue(photoShader, "Saturation", 0)
        dxSetShaderValue(photoShader, "blur", 0)

        local rt = dxCreateRenderTarget(202, 206)

        if isElement(rt) then
            dxSetRenderTarget(rt, true)

            local w = 206 / screenY * screenX

            dxDrawImage(101 - w / 2, 0, w, 206, photoShader)
            dxSetRenderTarget()

            local pixels = dxGetTexturePixels(rt)
            pixels = dxConvertPixels(pixels, "jpeg")
            triggerLatentServerEvent("sendLicensePhoto", resourceRoot, pixels)

            pixels = nil
            collectgarbage("collect")
            destroyElement(rt)
        end

        photoSent = true
    elseif not photoSent then
        setTime(12, 0)
        dxUpdateScreenSource(photoSource)
        photoUpdated = true
    end

    dxDrawRectangle(0, 0, (screenX - screenY) / 2, screenY, tocolor(0, 0, 0))
    dxDrawRectangle(screenX - (screenX - screenY) / 2, 0, (screenX - screenY) / 2, screenY, tocolor(0, 0, 0))
end

addEvent("closeLicenseOfficeWindow", false)
addEventHandler("closeLicenseOfficeWindow", getRootElement(),
    function()
        if exports.seal_gui:isGuiElementValid(licenseBackground) then
            exports.seal_gui:deleteGuiElement(licenseBackground)
        end

        licenseBackground = false
        officeButtons = {}
    end
)

addEvent("licenseOfficeButton", false)
addEventHandler("licenseOfficeButton", getRootElement(),
    function(button, state, absoluteX, absoluteY, el)
        for i = 1, #officeButtons do
            if officeButtons[i] and officeButtons[i][1] == el then

                local hasID = exports.seal_items:playerHasItem(65)
                local hasDL = exports.seal_items:playerHasItem(68)
                local hasWP = exports.seal_items:playerHasItem(75)
                local hasFS = exports.seal_items:playerHasItem(66)

                if hasID and officeButtons[i][2] == "id" then
                    exports.seal_gui:showInfobox("e", "Már van személyazonosító igazolványod.")
                    return
                end

                if hasDL and officeButtons[i][2] == "dl" then
                    exports.seal_gui:showInfobox("e", "Már van vezetői engedélyed.")
                    return
                end

                if hasWP and officeButtons[i][2] == "wp" then
                    exports.seal_gui:showInfobox("e", "Már van fegyverviselési engedélyed.")
                    return
                end

                if hasFS and officeButtons[i][2] == "fs" then
                    local playerMoney = getElementData(localPlayer, "char.Money")

                    if playerMoney <= 50000 then
                        exports.seal_gui:showInfobox("e", "Nincs elég pénzed a horgászengedély kiváltásához.")
                        return
                    end
                    
                    exports.seal_gui:showInfobox("e", "Már van horgászengedélyed.")
                    return
                end

                if officeButtons[i][2] == "wp" then
                    local playerMoney = getElementData(localPlayer, "char.Money")

                    if playerMoney <= 1000000 then
                        exports.seal_gui:showInfobox("e", "Nincs elég pénzed a fegyverviselési engedély kiváltásához.")
                        return
                    end
                end

                if exports.seal_gui:isGuiElementValid(licenseBackground) then
                    exports.seal_gui:deleteGuiElement(licenseBackground)
                end

                triggerServerEvent("licenseOfficeRequest", resourceRoot, officeButtons[i][2])

                waitingForLicenseOffice = true
                licenseBackground = false

                officeButtons = {}
            end
        end
    end
)

addEvent("licenseOfficeResponse", true)
addEventHandler("licenseOfficeResponse", resourceRoot,
    function(photo)
        waitingForLicenseOffice = false

        if photo then
            photoX, photoY, photoZ = getElementPosition(localPlayer)

            if isElement(photoSource) then
                destroyElement(photoSource)
            end

            if isElement(photoShader) then
                destroyElement(photoShader)
            end

            photoSent = false
            photoUpdated = false
            photoStart = getTickCount()

            playSound("files/photo.wav")
            exports.seal_hud:hideHUD()

            photoSource = dxCreateScreenSource(screenX, screenY)
            photoShader = dxCreateShader(photoShaderSource)

            dxSetShaderValue(photoShader, "sBaseTexture", photoSource)
            addEventHandler("onClientRender", root, renderLicensePhoto, true, "low-999999999")
        end
    end
)

local licenseButtonCaptions = {
    {"Személyazonosító igazolvány", "id"},
    {"Vezetői engedély", "dl"},
    {"Fegyverviselési engedély (1 000 000 $)", "wp"},
    {"Horgászengedély (50 000 $)", "fs"},
}

addEventHandler("onClientClick", getRootElement(),
    function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
        if state == "down" and officePeds[clickedElement] then
            if waitingForLicenseOffice then
                return
            end

            if licenseBackground then
                return
            end

            local elementPosX, elementPosY, elementPosZ = getElementPosition(clickedElement)
            local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

            if getDistanceBetweenPoints3D(elementPosX, elementPosY, elementPosZ, playerPosX, playerPosY, playerPosZ) <= 3 then
                if exports.seal_gui:isGuiElementValid(licenseBackground) then
                    exports.seal_gui:deleteGuiElement(licenseBackground)
                end

                local licenseSizeW = 350
                local licenseSizeH = 168 --210

                licenseBackground = exports.seal_gui:createGuiElement("window", screenX / 2 - licenseSizeW / 2, screenY / 2 - licenseSizeH / 2, licenseSizeW, licenseSizeH)
                exports.seal_gui:setWindowTitle(licenseBackground, "13/Ubuntu-R.ttf", "Okmányiroda")
                exports.seal_gui:setWindowCloseButton(licenseBackground, "closeLicenseOfficeWindow")
                exports.seal_gui:setWindowElementMaxDistance(licenseBackground, clickedElement, 3, "closeLicenseOfficeWindow")

                for i = 1, #licenseButtonCaptions do
                    local buttonSizeW = licenseSizeW - 12
                    local buttonSizeH = 36

                    local buttonPosX = 6
                    local buttonPosY = 42 * i

                    local button = exports.seal_gui:createGuiElement("button", buttonPosX, buttonPosY, buttonSizeW, buttonSizeH, licenseBackground)
                    exports.seal_gui:setGuiBackground(button, "solid", "primary")
                    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, false, true)
                    exports.seal_gui:setButtonFont(button, "12/Ubuntu-R.ttf")
                    exports.seal_gui:setButtonText(button, licenseButtonCaptions[i][1])
                    exports.seal_gui:setClickEvent(button, "licenseOfficeButton")
                    officeButtons[i] = {button, licenseButtonCaptions[i][2]}
                end
            end
        end
    end, true, "high+999999999"
)

local gotLicenseData = false
local loadingLicenseType = false
local loadingLicenseId = false

local licensePic = false

function showLicense(licenseType, characterName, characterId, license)
    if not gotLicenseData then
        local licenseData = split(license, "_")
        loadingLicenseId = tonumber(licenseData[1])
        loadingLicenseType = licenseData[2]

        if licenseType == "id" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy személyazonosító igazolványt.")
        end

        triggerServerEvent("loadLicenseData", resourceRoot, characterName, characterId, license)
    elseif not loadingLicenseType then

    end
end

function showLicense(licenseType, characterName, characterId, license)
    if gotLicenseData then
        local licenseDatas = split(license, "_")

        gotLicenseData = false
        loadingLicenseType = licenseType
        loadingLicenseId = tonumber(licenseDatas[1])

        triggerServerEvent("loadLicenseData", resourceRoot, characterName, characterId, license)

        if licenseType == "id" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy személyazonosító igazolványt.")
        elseif licenseType == "dl" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy vezetői engedélyt.")
        elseif licenseType == "wp" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy fegyverengedélyt.")
        elseif licenseType == "fs" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy horgászengedélyt.")
        end
    elseif not loadingLicenseType then
        deleteLicenseStuff()

        local licenseDatas = split(license, "_")

        gotLicenseData = false
        loadingLicenseType = licenseType
        loadingLicenseId = tonumber(licenseDatas[1])

        triggerServerEvent("loadLicenseData", resourceRoot, characterName, characterId, license)

        addEventHandler("onClientRender", getRootElement(), renderLicense)

        if licenseType == "id" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy személyazonosító igazolványt.")
        elseif licenseType == "dl" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy vezetői engedélyt.")
        elseif licenseType == "wp" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy fegyverengedélyt.")
        elseif licenseType == "fs" then
            exports.seal_chat:localActionC(localPlayer, "elővett egy horgászengedélyt.")
        end
    end
end

function hideLicense(licenseType)
    deleteLicenseStuff()

    loadingLicenseType = false
    loadingLicenseId = false
    gotLicenseData = false

    removeEventHandler("onClientRender", getRootElement(), renderLicense)

    if licenseType == "id" then
        exports.seal_chat:localActionC(localPlayer, "elrakott egy személyazonosító igazolványt.")
    elseif licenseType == "dl" then
        exports.seal_chat:localActionC(localPlayer, "elrakott egy vezetői engedélyt.")
    elseif licenseType == "wp" then
        exports.seal_chat:localActionC(localPlayer, "elrakott egy fegyverengedélyt.")
    elseif licenseType == "fs" then
        exports.seal_chat:localActionC(localPlayer, "elrakott egy horgászengedélyt.")
    end
end

function deleteLicenseStuff()
    if isElement(lunabar) then
      destroyElement(lunabar)
    end

    lunabar = nil

    if isElement(ticketFont) then
      destroyElement(ticketFont)
    end

    ticketFont = nil
    
    if isElement(licensePic) then
      destroyElement(licensePic)
    end

    licensePic = nil
end

addEvent("gotLicenseData", true)
addEventHandler("gotLicenseData", resourceRoot,
    function (picture, data)
        if data and data.licenseType == loadingLicenseType and data.id == loadingLicenseId then
            if not isElement(lunabar) then
                lunabar = dxCreateFont("files/lunabar.ttf", 34, false, "antialiased")
            end

            if not isElement(ticketFont) then
                ticketFont = dxCreateFont("files/IckyticketMono-nKpJ.ttf", 25, false, "antialiased")
            end

            if isElement(licensePic) then
                destroyElement(licensePic)
            end

            data.created = formatDate("Y.m.d", "'", data.created)
            data.expire = formatDate("Y.m.d", "'", data.expire + (1000 * 24 * 60 * 2))

            if picture then
                licensePic = dxCreateTexture(dxConvertPixels(picture, "jpeg"))
            else
                licensePic = false
            end

            gotLicenseData = data
        elseif loadingLicenseType then
            deleteLicenseStuff()

            loadingLicenseType = false
            loadingLicenseId = false
            gotLicenseData = false

            removeEventHandler("onClientRender", getRootElement(), renderLicense)
        end

        picture = nil
        collectgarbage("collect")
    end
)

local loaderIcon = false
local faTicks = false

local function refreshLoaderIcon()
    local res = getResourceFromName("seal_gui")

    if res and getResourceState(res) == "running" then
        loaderIcon = exports.seal_gui:getFaIconFilename("circle-notch", 64)
        faTicks = exports.seal_gui:getFaTicks()
    end
end

addEventHandler("onGuiRefreshColors", getRootElement(), refreshLoaderIcon)
addEventHandler("onClientResourceStart", getResourceRootElement(), refreshLoaderIcon)

addEventHandler("refreshFaTicks", getRootElement(),
    function()
        faTicks = exports.seal_gui:getFaTicks()
    end
)

function renderLicense()
    local tex = "files/" .. (loadingLicenseType or gotLicenseData.licenseType) .. ".dds"
    local lamin = "files/lamin.dds"

    if gotLicenseData then
        if tex then
            dxDrawImage(x, y, sx, sy, tex)
        end

        if gotLicenseData.licenseType == "fs" then
            dxDrawText(gotLicenseData.id, x + 60 + 10, y + 40 + 5, 0, 0, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "top")
            dxDrawText(gotLicenseData.name, x + 102, y + 118 - 1, 0, y + 118 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.created, x + 157, y + 142 - 1, 0, y + 142 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.expire, x + 152, y + 166 - 1, 0, y + 166 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.name, x + 225, y + 242, x + 225, y + 242, tocolor(50, 27, 149, 255), 0.5, lunabar, "center", "center")
        elseif gotLicenseData.licenseType == "wp" then
            dxDrawImage(x + 73, y + 106, 101, 103, licensePic)
            dxDrawText(gotLicenseData.name, x + 214, y + 114 - 1, 0, y + 114 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.id, x + 248, y + 138 - 1, 0, y + 138 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.created, x + 268, y + 162 - 1, 0, y + 162 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.expire, x + 264, y + 186 - 1, 0, y + 186 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText("9 mm / .45 ACP", x + 234, y + 210 - 1, 0, y + 210 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.name, x + 120, y + 242, 0, y + 242, tocolor(0, 0, 0, 255), 0.5, lunabar, "left", "center")
        else
            dxDrawImage(x + 73, y + 106, 101, 103, licensePic)
            dxDrawText(gotLicenseData.name, x + 214, y + 114 - 1, 0, y + 114 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.id, x + 248, y + 143 - 1, 0, y + 143 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.created, x + 268, y + 172 - 1, 0, y + 172 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.expire, x + 264, y + 200 - 1, 0, y + 200 - 1, tocolor(0, 0, 0, 255), 0.5, ticketFont, "left", "center")
            dxDrawText(gotLicenseData.name, x + 120, y + 242, 0, y + 242, tocolor(0, 0, 0, 255), 0.5, lunabar, "left", "center")
        end

        if lamin then
            dxDrawImage(x, y, sx, sy, lamin)
        end
    else
        dxDrawImage(x, y, sx, sy, "files/" .. loadingLicenseType .. "blur.dds")
        dxDrawImage(x + sx / 2 - 32, y + sy / 2 - 32, 64, 64, ":seal_gui/" .. loaderIcon .. faTicks[loaderIcon], getTickCount() / 5 % 360)
    end
end

local weekDays = {"Vasárnap", "Hétfő", "Kedd", "Szerda", "Csütörtök", "Péntek", "Szombat"}

function formatDate(format, escaper, timestamp)
    escaper = escaper or "'"
    escaper = string.sub(escaper, 1, 1)

    local time = getRealTime(timestamp)
    local formattedDate = ""
    local escaped = false

    time.year = time.year + 1900
    time.month = time.month + 1
    
    local datetime = {
        d = string.format("%02d", time.monthday),
        h = string.format("%02d", time.hour),
        i = string.format("%02d", time.minute),
        m = string.format("%02d", time.month),
        s = string.format("%02d", time.second),
        w = string.sub(weekDays[time.weekday + 1], 1, 2),
        W = weekDays[time.weekday + 1],
        y = string.sub(tostring(time.year), -2),
        Y = time.year
    }
    
    for char in string.gmatch(format, ".") do
        if char == escaper then
            escaped = not escaped
        else
            formattedDate = formattedDate .. (not escaped and datetime[char] or char)
        end
    end
    
    return formattedDate
end