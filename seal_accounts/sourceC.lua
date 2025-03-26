local screenX, screenY = guiGetScreenSize()

function checkAnticheatResource()
    local res = getResourceFromName("seal_anticheat")
    if res and getResourceState(res) ~= "running" then
        triggerServerEvent("reportAnticheatRunningState", localPlayer)
    end
end
setTimer(checkAnticheatResource, 5000, 0)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "loggedIn") then
        return
    end

    setTimer(function()
        triggerServerEvent("checkPlayerBanState", localPlayer)
        refreshGui()
    end, 500, 1)
end)

function refreshGui()
    imageMaugli = exports.seal_gui:getFaIconFilename("user", 24)
end

local gotBanState = false

addEvent("receiveBanState", true)
addEventHandler("receiveBanState", getRootElement(), function(data)
    if not gotBanState then
        gotBanState = true
        deleteLoginPanel()

        if data.deactivated == "No" then
            createBanPanel(data)
        else
            if getElementData(localPlayer, "loggedIn") then
                return
            end

            createLoginPanel()

            setElementPosition(localPlayer, 0, 0, 1500)
            setElementFrozen(localPlayer, true)
        end
    end
end)
 
local loginBackground = false
local loginLogo = false
local loginImage = false
local loginButton = false
local loginUsernameInput = false
local loginPasswordInput = false
local loginRememberCheckbox = false

function createLoginPanel()
    deleteLoginPanel()
    showChat(false)
    showCursor(true)

    setCameraMatrix(1440.1101074219, -1597.8969726562, 44.114616394043, 1501.1199951172, -1674.7985839844, 25.037271499634)

    loginImage = exports.seal_gui:createGuiElement("image", 0, 0, screenX, screenY)
    exports.seal_gui:setImageFile(loginImage, ":seal_accounts/files/gradient.png")
    exports.seal_gui:setImageColor(loginImage, "grey4")

    loginLogo = exports.seal_gui:createGuiElement("image", screenX / 2 - 64, screenY / 2 - 300, 128, 128, loginImage)
    exports.seal_gui:setImageFile(loginLogo, ":seal_accounts/files/logo.png")
    exports.seal_gui:setImageColor(loginLogo, "primary")

    local label = exports.seal_gui:createGuiElement("label", 0, screenY / 2 - (325 / 2), screenX, 48, loginImage)
    exports.seal_gui:setLabelText(label, "S E A L M T A")
    exports.seal_gui:setLabelFont(label, "27/Ubuntu-L.ttf")
    local label = exports.seal_gui:createGuiElement("label", 0, exports.seal_gui:getGuiPosition("last", "y") + exports.seal_gui:getGuiSize("last", "y"), screenX, 24, loginImage)
    exports.seal_gui:setLabelText(label, "Üdvözlünk a szerveren " .. getPlayerName(localPlayer):gsub("_", " ") .. "!")
    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(label, "primary")

    loginUsernameInput = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (123 / 2), 300, false, loginImage)
    exports.seal_gui:setInputPlaceholder(loginUsernameInput, "Felhasználónév")
    exports.seal_gui:setInputIcon(loginUsernameInput, "user")
    exports.seal_gui:setInputMaxLength(loginUsernameInput, 24)

    loginPasswordInput = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (123 / 2) + 46, 300, false, loginImage)
    exports.seal_gui:setInputPlaceholder(loginPasswordInput, "Jelszó")
    exports.seal_gui:setInputIcon(loginPasswordInput, "lock")
    exports.seal_gui:setInputPassword(loginPasswordInput, true)

    loginRememberCheckbox = exports.seal_gui:createGuiElement("checkbox", screenX / 2 - 150, screenY / 2 - (115 / 2) + 86, 28, 28, loginImage)
    exports.seal_gui:setCheckboxText(loginRememberCheckbox, "Jegyezzen meg")
    exports.seal_gui:setCheckboxColor(loginRememberCheckbox, "midgrey", "grey2", "primary", "midgrey")

    loginButton = exports.seal_gui:createGuiElement("button", screenX / 2 - 150, screenY / 2 - (100 / 2) + 114, 300, false, loginImage)
    exports.seal_gui:setButtonText(loginButton, "Bejelentkezés")
    exports.seal_gui:setButtonFont(loginButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setGuiBackground(loginButton, "solid", "primary")
    exports.seal_gui:setGuiHover(loginButton, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickEvent(loginButton, "loginButtonClick", true)

    registerButton = exports.seal_gui:createGuiElement("button", screenX / 2 - 150, screenY / 2 - (100 / 2) + 160, 300, false, loginImage)
    exports.seal_gui:setButtonText(registerButton, "Regisztráció")
    exports.seal_gui:setButtonFont(registerButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setGuiBackground(registerButton, "solid", "red")
    exports.seal_gui:setGuiHover(registerButton, "gradient", {"red", "red-second"}, false, true)
    exports.seal_gui:setClickEvent(registerButton, "tryRegistration", true)

    loadLoginFiles()
end

function createBanPanel(data)

    showChat(false)
    showCursor(true)

    setCameraMatrix(1440.1101074219, -1597.8969726562, 44.114616394043, 1501.1199951172, -1674.7985839844, 25.037271499634)

    local screenX, screenY = guiGetScreenSize()
    
    local expiryDate = data.expireTimestamp and tonumber(data.expireTimestamp) and os.date("%Y-%m-%d %H:%M:%S", tonumber(data.expireTimestamp)) or "Soha"

    -- Háttér
    local banPanel = exports.seal_gui:createGuiElement("image", 0, 0, screenX, screenY)
    exports.seal_gui:setImageFile(banPanel, ":seal_accounts/files/gradient.png")
    exports.seal_gui:setImageColor(banPanel, "grey4")
    
    -- Logó
    local banLogo = exports.seal_gui:createGuiElement("image", screenX / 2 - 64, screenY / 2 - 250, 128, 128, banPanel)
    exports.seal_gui:setImageFile(banLogo, ":seal_accounts/files/logo.png")
    exports.seal_gui:setImageColor(banLogo, "red")
    
    -- Cím
    local titleLabel = exports.seal_gui:createGuiElement("label", 0, screenY / 2 - 120, screenX, 48, banPanel)
    exports.seal_gui:setLabelText(titleLabel, "Fiókod ki lett tiltva!")
    exports.seal_gui:setLabelFont(titleLabel, "27/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(titleLabel, "red")
    
    -- Kitiltási információk
    local reasonLabel = exports.seal_gui:createGuiElement("label", 0, screenY / 2 - 60, screenX, 24, banPanel)
    exports.seal_gui:setLabelText(reasonLabel, "Indok: " .. (data.banReason or "Nincs megadva"))
    exports.seal_gui:setLabelFont(reasonLabel, "14/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(reasonLabel, "primary")
    
    local adminLabel = exports.seal_gui:createGuiElement("label", 0, screenY / 2 - 30, screenX, 24, banPanel)
    exports.seal_gui:setLabelText(adminLabel, "Admin: " .. (data.adminName or "Ismeretlen"))
    exports.seal_gui:setLabelFont(adminLabel, "14/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(adminLabel, "primary")
    
    local timeLabel = exports.seal_gui:createGuiElement("label", 0, screenY / 2, screenX, 24, banPanel)
    exports.seal_gui:setLabelText(timeLabel, "Lejárat: " .. (expiryDate or "Soha"))
    exports.seal_gui:setLabelFont(timeLabel, "14/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(timeLabel, "primary")

    -- Kilépés gomb
    local exitButton = exports.seal_gui:createGuiElement("button", screenX / 2 - 100, screenY / 2 + 50, 200, false, banPanel)
    exports.seal_gui:setButtonText(exitButton, "Kilépés")
    exports.seal_gui:setButtonFont(exitButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setGuiBackground(exitButton, "solid", "red")
    exports.seal_gui:setGuiHover(exitButton, "gradient", {"red", "red-second"}, false, true)
    exports.seal_gui:setClickEvent(exitButton, "onPlayerExit", true)
end

addEvent("onPlayerExit", true)
addEventHandler("onPlayerExit", root, function()
    triggerServerEvent("playerLeaveInBan", localPlayer)
end)

function deleteBanPanel()
    if exports.seal_gui:isGuiElementValid(banPanel) then
        exports.seal_gui:deleteGuiElement(banPanel)
    end
end

function deleteLoginPanel()
    if exports.seal_gui:isGuiElementValid(loginImage) then
        exports.seal_gui:deleteGuiElement(loginImage)
    end

    loginImage = false
    loginButton = false
    loginUsernameInput = false
    loginPasswordInput = false
    loginRememberCheckbox = false
end

addEvent("loginButtonClick", true)
addEventHandler("loginButtonClick", getRootElement(), function()
    local username = exports.seal_gui:getInputValue(loginUsernameInput) or ""
    local password = exports.seal_gui:getInputValue(loginPasswordInput) or ""

    if utf8.len(username) > 0 and utf8.len(password) > 0 then
        if exports.seal_gui:isCheckboxChecked(loginRememberCheckbox) then
            local username = exports.seal_gui:getInputValue(loginUsernameInput) or ""
            local password = exports.seal_gui:getInputValue(loginPasswordInput) or ""
            saveLoginFiles(username, password)
        else
            saveLoginFiles()
        end

        triggerServerEvent("tryLogin", localPlayer, username, password)
    else
        exports.seal_gui:showInfobox("e", "Add meg a felhasználóneved és jelszavad!")
    end
end)

addEvent("loginResponse", true)
addEventHandler("loginResponse", getRootElement(), function(haveCharacter, data)
    local time = math.random(4000, 7000)
    exports.seal_gui:showLoadingScreen(time)
    if haveCharacter then
        setTimer(deleteLoginPanel, 500, 1)
        setTimer(createCharacterSelect, time - 250, 1, data)
    else
        setTimer(deleteLoginPanel, 500, 1)
        setTimer(createCharacterCreate, time - 250, 1)
    end
end)

local pedElement = false
local genderButtons = {}
local selectedGender = "male"

local availableMaleSkins = {1, 2}
local availableFemaleSkins = {200, 201}
local skins = availableMaleSkins

local selectorButtons = {}
local selectedSkin = 1
local currentSkin = availableMaleSkins[selectedSkin]

function createCharacterCreate()
    exports.seal_gui:showInfobox("i", "Nincs még karaktered, kérlek hozz létre egyet most.")

    local res = getResourceFromName("seal_binco")
    if getResourceState(res) == "running" then
        availableMaleSkins = exports.seal_binco:getSkinsByType("Férfi")
        availableFemaleSkins = exports.seal_binco:getSkinsByType("Női")
        skins = availableMaleSkins
    end

    if exports.seal_gui:isGuiElementValid(characterCreatorImage) then
        exports.seal_gui:deleteGuiElement(characterCreatorImage)
    end

    datas = {}
    datas.creatorButtons = {}
    datas.genderButtons = {}

    characterCreatorImage = exports.seal_gui:createGuiElement("image", 0, 0, screenX, screenY)
    exports.seal_gui:setImageFile(characterCreatorImage, ":seal_accounts/files/gradient.png")
    exports.seal_gui:setImageColor(characterCreatorImage, "grey3")

    nameInput = exports.seal_gui:createGuiElement("input", 12, screenY / 2 - 198, 300, 40, characterCreatorImage)
    exports.seal_gui:setInputMaxLength(nameInput, 64)
    exports.seal_gui:setInputPlaceholder(nameInput, "Karakter Név")
    exports.seal_gui:setInputPasteDisabled(nameInput, true)
    exports.seal_gui:setInputIcon(nameInput, "signature")
    exports.seal_gui:setInputFont(nameInput, "13/Ubuntu-R.ttf")

    ageInput = exports.seal_gui:createGuiElement("input", 12, screenY / 2 - 198 + 46, 300, 40, characterCreatorImage)
    exports.seal_gui:setInputMaxLength(ageInput, 3)
    exports.seal_gui:setInputPlaceholder(ageInput, "Kor")
    exports.seal_gui:setInputPasteDisabled(ageInput, true)
    exports.seal_gui:setInputNumberOnly(ageInput, true)
    exports.seal_gui:setInputIcon(ageInput, "birthday-cake")
    exports.seal_gui:setInputFont(ageInput, "13/Ubuntu-R.ttf")

    weightInput = exports.seal_gui:createGuiElement("input", 12, screenY / 2 - 198 + 92, 300, 40, characterCreatorImage)
    exports.seal_gui:setInputMaxLength(weightInput, 3)
    exports.seal_gui:setInputPlaceholder(weightInput, "Súly")
    exports.seal_gui:setInputPasteDisabled(weightInput, true)
    exports.seal_gui:setInputNumberOnly(weightInput, true)
    exports.seal_gui:setInputIcon(weightInput, "weight")
    exports.seal_gui:setInputFont(weightInput, "13/Ubuntu-R.ttf")

    heightInput = exports.seal_gui:createGuiElement("input", 12, screenY / 2 - 198 + 138, 300, 40, characterCreatorImage)
    exports.seal_gui:setInputMaxLength(heightInput, 3)
    exports.seal_gui:setInputPlaceholder(heightInput, "Magasság")
    exports.seal_gui:setInputPasteDisabled(heightInput, true)
    exports.seal_gui:setInputNumberOnly(heightInput, true)
    exports.seal_gui:setInputIcon(heightInput, "arrows-v")
    exports.seal_gui:setInputFont(heightInput, "13/Ubuntu-R.ttf")

    descriptionInput = exports.seal_gui:createGuiElement("input", 12, screenY / 2 - 198 + 184, 300, 120, characterCreatorImage)
    exports.seal_gui:setInputMaxLength(descriptionInput, 128)
    exports.seal_gui:setInputPlaceholder(descriptionInput, "Rövid karakter leírás")
    exports.seal_gui:setInputFont(descriptionInput, "13/Ubuntu-R.ttf")
    exports.seal_gui:setInputMultiline(descriptionInput, true)

    local button = exports.seal_gui:createGuiElement("button", 12, screenY / 2 - 198 + 310, 300, 40, characterCreatorImage)
    exports.seal_gui:setGuiBackground(button, "gradient", {"primary", "secondary"})
    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickSound(button, "selectdone")
    exports.seal_gui:setClickEvent(button, "selectGender")
    exports.seal_gui:setButtonText(button, "Férfi")
    exports.seal_gui:setButtonFont(button, "13/Ubuntu-R.ttf")

    local button2 = exports.seal_gui:createGuiElement("button", 12, screenY / 2 - 198 + 356, 300, 40, characterCreatorImage)
    exports.seal_gui:setGuiBackground(button2, "solid", "red")
    exports.seal_gui:setGuiHover(button2, "gradient", {"red", "red-second"}, false, true)
    exports.seal_gui:setClickSound(button2, "selectdone")
    exports.seal_gui:setClickEvent(button2, "selectGender")
    exports.seal_gui:setButtonText(button2, "Nő")
    exports.seal_gui:setButtonFont(button2, "13/Ubuntu-R.ttf")

    datas.genderButtons[button] = {"male", button, button2}
    datas.genderButtons[button2] = {"female", button2, button}

    local button = exports.seal_gui:createGuiElement("button", screenX / 2 - 20 - 145, screenY / 2 - 20, 40, 40, characterCreatorImage)
    exports.seal_gui:setGuiBackground(button, "solid", "primary")
    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickSound(button, "selectdone")
    exports.seal_gui:setClickEvent(button, "selectSkin")
    exports.seal_gui:setButtonText(button, "<")
    exports.seal_gui:setButtonFont(button, "13/Ubuntu-R.ttf")

    local button2 = exports.seal_gui:createGuiElement("button", screenX / 2 - 20 + 145, screenY / 2 - 20, 40, 40, characterCreatorImage)
    exports.seal_gui:setGuiBackground(button2, "solid", "primary")
    exports.seal_gui:setGuiHover(button2, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickSound(button2, "selectdone")
    exports.seal_gui:setClickEvent(button2, "selectSkin")
    exports.seal_gui:setButtonText(button2, ">")
    exports.seal_gui:setButtonFont(button2, "13/Ubuntu-R.ttf")
    
    datas.creatorButtons[button] = {"prev", button}
    datas.creatorButtons[button2] = {"next", button2}

    local button = exports.seal_gui:createGuiElement("button", screenX / 2 - 150, screenY - 46, 300, 40, characterCreatorImage)
    exports.seal_gui:setGuiBackground(button, "solid", "primary")
    exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickSound(button, "selectdone")
    exports.seal_gui:setClickEvent(button, "tryToCreateCharacter")
    exports.seal_gui:setButtonText(button, "Karakter elkészítése")
    exports.seal_gui:setButtonFont(button, "13/Ubuntu-R.ttf")

    local camX, camY, camZ = getCameraMatrix()
    pedElement = createPed(currentSkin, camX, camY, camZ)
    
    myObject = exports.seal_op:createObjectPreview(pedElement, 0, 0, 0, 0.5, 0.5, 1, 1, true, true, true)
    guiWindow = guiCreateWindow(screenX / 2 - 250, screenY / 2 - 250, 500, 500, "Skin Selector", false, false)
    guiSetAlpha(guiWindow, 0)
    
    local projPosX, projPosY = guiGetPosition(guiWindow, true)
    local projSizeX, projSizeY = guiGetSize(guiWindow, true)    
    exports.seal_op:setProjection(myObject, projPosX, projPosY, projSizeX, projSizeY, true, true)
    exports.seal_op:setRotation(myObject, 0, 0, 180)
end

addEvent("selectGender", true)
addEventHandler("selectGender", root,
    function (button, state, absoluteX, absoluteY, el)
        if exports.seal_gui:isGuiElementValid(el) then
            if button == "left" and state == "down" then
                if datas.genderButtons[el] then
                    skins = nil
                    collectgarbage("collect")
                    
                    if datas.genderButtons[el][1] == "male" then
                        selectedGender = "male"
                        selectedSkin = 1
                        currentSkin = availableMaleSkins[selectedSkin][1]
                        skins = availableMaleSkins

                        if exports.seal_gui:isGuiElementValid(datas.genderButtons[el][2]) then
                            exports.seal_gui:setGuiBackground(datas.genderButtons[el][2], "gradient", {"primary", "secondary"})
                        end

                        if exports.seal_gui:isGuiElementValid(datas.genderButtons[el][3]) then
                            exports.seal_gui:setGuiBackground(datas.genderButtons[el][3], "solid", "red")
                        end

                        if isElement(pedElement) then
                            setElementModel(pedElement, currentSkin)
                        end
                    end

                    if datas.genderButtons[el][1] == "female" then
                        selectedGender = "female"
                        selectedSkin = 1
                        currentSkin = availableFemaleSkins[selectedSkin][1]
                        skins = availableFemaleSkins

                        if exports.seal_gui:isGuiElementValid(datas.genderButtons[el][2]) then
                            exports.seal_gui:setGuiBackground(datas.genderButtons[el][2], "gradient", {"red", "red-second"})
                        end

                        if exports.seal_gui:isGuiElementValid(datas.genderButtons[el][3]) then
                            exports.seal_gui:setGuiBackground(datas.genderButtons[el][3], "solid", "primary")
                        end

                        if isElement(pedElement) then
                            setElementModel(pedElement, currentSkin)
                        end
                    end
                end
            end
        end
    end
)

addEvent("selectSkin", true)
addEventHandler("selectSkin", root,
    function (button, state, absoluteX, absoluteY, el)
        if exports.seal_gui:isGuiElementValid(el) then
            if button == "left" and state == "down" then
                if datas and datas.creatorButtons and datas.creatorButtons[el] then

                    if datas.creatorButtons[el][1] == "prev" or datas.creatorButtons[el][1] == "next" then
                        if datas.creatorButtons[el][1] == "prev" then
                            selectedSkin = selectedSkin - 1 
                        else
                            selectedSkin = selectedSkin + 1
                        end
                        
                        if not skins[selectedSkin] then
                            selectedSkin = 1
                        end

                        if skins[selectedSkin] then
                            currentSkin = skins[selectedSkin][1]

                            if isElement(pedElement) then
                                setElementModel(pedElement, currentSkin)
                            end
                        end
                    end
                end
            end
        end
    end
)

addEvent("tryToCreateCharacter", true)
addEventHandler("tryToCreateCharacter", root,
    function (button, state, absoluteX, absoluteY, el)
        if exports.seal_gui:isGuiElementValid(el) then
            if button == "left" and state == "down" then
                local characterName = exports.seal_gui:getInputValue(nameInput) or ""
                local sections = split(characterName, " ")
                
                if not (utf8.len(characterName) >= 6 and utf8.len(characterName) <= 64) then
                    exports.seal_gui:showInfobox("e", "A karakter neve nem lehet rövidebb mint 6 karakter, hosszabb mint 64 karakter.")
                    return
                end

                if utf8.match(characterName:gsub(" ", "_"), "[^a-zA-Z_]") then
                    exports.seal_gui:showInfobox("e", "A név csak ékezet nélküli betűket tartalmazhat!")
                    return
                end

                if #sections >= 2 and #sections <= 3 then
                    local characterAge = exports.seal_gui:getInputValue(ageInput) or 0

                    if tonumber(characterAge) then
                        if tonumber(characterAge) >= 18 and tonumber(characterAge) <= 100 then
                            local characterWeight = exports.seal_gui:getInputValue(weightInput) or 0

                            if tonumber(characterWeight) then
                                if tonumber(characterWeight) >= 40 and tonumber(characterWeight) <= 180 then
                                    local characterHeight = exports.seal_gui:getInputValue(heightInput) or 0

                                    if tonumber(characterHeight) then
                                        if tonumber(characterHeight) >= 110 and tonumber(characterHeight) <= 220 then
                                            local characterDescription = exports.seal_gui:getInputValue(descriptionInput) or ""

                                            if utf8.len(characterDescription) >= 32 and utf8.len(characterDescription) <= 128 then
                                                if not selectedGender then
                                                    exports.seal_gui:showInfobox("e", "A regisztráció folytatásához válassz nemet.")
                                                    return
                                                end

                                                triggerServerEvent("tryCharacterCreation", resourceRoot, characterName, tonumber(characterAge), tonumber(characterWeight), tonumber(characterHeight), characterDescription, selectedGender, currentSkin)
                                            else
                                                exports.seal_gui:showInfobox("e", "A karakter leírása nem lehet rövidebb mint 32 karakter, hosszabb mint 128 karakter.")
                                            end
                                        else
                                            exports.seal_gui:showInfobox("e", "Minimum 110 cm, de maximum 220 cm lehet a karaktered.")
                                        end
                                    else
                                        exports.seal_gui:showInfobox("e", "Nem megfelelő karakter magasság.")
                                    end
                                else
                                    exports.seal_gui:showInfobox("e", "Minimum 40 kg, de maximum 180 kg lehet a karaktered.")
                                end
                            else
                                exports.seal_gui:showInfobox("e", "Nem megfelelő karakter súly.")
                            end
                        else
                            exports.seal_gui:showInfobox("e", "Minimum 18 éves, de maximum 100 éves lehet a karaktered.")
                        end
                    else
                        exports.seal_gui:showInfobox("e", "Nem megfelelő karakter kor.")
                    end
                else
                    exports.seal_gui:showInfobox("e", "Nem megfelelő karakter név.")
                end
            end
        end
    end
)

addEvent("successCharCreation", true)
addEventHandler("successCharCreation", getRootElement(), function()
    exports.seal_gui:showLoadingScreen(2500)
    setTimer(deleteCharacterCreator, 500, 1)
    setTimer(createLoginPanel, 2250, 1)

    if isElement(pedElement) then
        destroyElement(pedElement)
    end
end)

function deleteCharacterCreator()
    if exports.seal_gui:isGuiElementValid(characterCreatorImage) then
        exports.seal_gui:deleteGuiElement(characterCreatorImage)
    end

    datas = {}
    datas.creatorButtons = {}
    datas.genderButtons = {}
end

function createCharacterSelect(data)
    if exports.seal_gui:isGuiElementValid(characterSelectImage) then
        exports.seal_gui:deleteGuiElement(characterSelectImage)
    end

    datas = {}
    datas.characters = data
    datas.selectorButtons = {}

    characterSelectImage = exports.seal_gui:createGuiElement("image", 0, 0, screenX, screenY)
    exports.seal_gui:setImageFile(characterSelectImage, ":seal_accounts/files/gradient2.png")
    exports.seal_gui:setImageColor(characterSelectImage, "grey3")

    local totalWidth = 326 * #datas.characters

    for i = 1, #datas.characters do
        local rect = exports.seal_gui:createGuiElement("rectangle", screenX / 2 - totalWidth / 2 + 326 * (i - 1), screenY / 2 - 258 / 2, 320, 258, characterSelectImage)
        exports.seal_gui:setGuiBackground(rect, "solid", "grey1")

        local line = exports.seal_gui:createGuiElement("rectangle", 16, 42, 288, 2, rect)
        exports.seal_gui:setGuiBackground(line, "solid", "grey3")

        if datas.characters[i] then
            local image = exports.seal_gui:createGuiElement("image", 12, 9, 24, 24, rect)
            exports.seal_gui:setImageFile(image, imageMaugli)

            local label = exports.seal_gui:createGuiElement("label", 40, 9, 288, 24, rect)
            exports.seal_gui:setLabelText(label, datas.characters[i].name:gsub("_", " "))
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-B.ttf")
	        exports.seal_gui:setLabelAlignment(label, "left", "center")

            -- characterid
            local width = exports.seal_gui:getTextWidthFont("Karakter ID", "11/Ubuntu-L.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 16, 60, width, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width, 24, rectangle)
            exports.seal_gui:setLabelText(label, "Karakter ID")

            local width2 = exports.seal_gui:getTextWidthFont(datas.characters[i].characterId, "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 24 + width, 60, width2, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "blue")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width2, 24, rectangle)
            exports.seal_gui:setLabelText(label, datas.characters[i].characterId)
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            -- playedminutes & level
            local width = exports.seal_gui:getTextWidthFont("Játszott percek", "11/Ubuntu-L.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 16, 93, width, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width, 24, rectangle)
            exports.seal_gui:setLabelText(label, "Játszott percek")

            local width2 = exports.seal_gui:getTextWidthFont(datas.characters[i].playedMinutes, "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 24 + width, 93, width2, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "blue")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width2, 24, rectangle)
            exports.seal_gui:setLabelText(label, datas.characters[i].playedMinutes)
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            local width3 = exports.seal_gui:getTextWidthFont("LVL " .. exports.seal_core:getLevel(false, datas.characters[i].playedMinutes), "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 30 + width + width2, 93, width3, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "gradient", {"blue", "blue-second"})

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width3, 24, rectangle)
            exports.seal_gui:setLabelText(label, "LVL " .. exports.seal_core:getLevel(false, datas.characters[i].playedMinutes))
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            -- money 
            local width = exports.seal_gui:getTextWidthFont("Készpénz", "11/Ubuntu-L.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 16, 126, width, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width, 24, rectangle)
            exports.seal_gui:setLabelText(label, "Készpénz")

            local width2 = exports.seal_gui:getTextWidthFont(datas.characters[i].money .. " $", "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 24 + width, 126, width2, 24, rect)

            if datas.characters[i].money >= 0 then
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"green", "green-second"})
            else
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"red", "red-second"})
            end

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width2, 24, rectangle)
            exports.seal_gui:setLabelText(label, datas.characters[i].money .. " $")
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            -- bankmoney 
            local width = exports.seal_gui:getTextWidthFont("Bankszámla", "11/Ubuntu-L.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 16, 159, width, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width, 24, rectangle)
            exports.seal_gui:setLabelText(label, "Bankszámla")

            local width2 = exports.seal_gui:getTextWidthFont(datas.characters[i].bankMoney .. " $", "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 24 + width, 159, width2, 24, rect)

            if datas.characters[i].bankMoney >= 0 then
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"green", "green-second"})
            else
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"red", "red-second"})
            end

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width2, 24, rectangle)
            exports.seal_gui:setLabelText(label, datas.characters[i].bankMoney .. " $")
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            -- slotcoins 
            local width = exports.seal_gui:getTextWidthFont("SlotCoins", "11/Ubuntu-L.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 16, 192, width, 24, rect)
            exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width, 24, rectangle)
            exports.seal_gui:setLabelText(label, "SlotCoins")

            local width2 = exports.seal_gui:getTextWidthFont(datas.characters[i].slotCoins .. " SC", "11/Ubuntu-R.ttf", 1) + 12
            local rectangle = exports.seal_gui:createGuiElement("rectangle", 24 + width, 192, width2, 24, rect)

            if datas.characters[i].slotCoins >= 0 then
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"orange", "orange-second"})
            else
                exports.seal_gui:setGuiBackground(rectangle, "gradient", {"red", "red-second"})
            end

            local label = exports.seal_gui:createGuiElement("label", 0, 0, width2, 24, rectangle)
            exports.seal_gui:setLabelText(label, datas.characters[i].slotCoins .. " SC")
            exports.seal_gui:setLabelFont(label, "11/Ubuntu-R.ttf")

            local button = exports.seal_gui:createGuiElement("button", 16, 225, 288, 24, rect)
            exports.seal_gui:setButtonText(button, "Kiválasztás")
            exports.seal_gui:setButtonFont(button, "13/BebasNeueBold.otf")
            exports.seal_gui:setGuiBackground(button, "solid", "primary")
            exports.seal_gui:setGuiHover(button, "gradient", {"primary", "secondary"}, false, true)
            exports.seal_gui:setClickEvent(button, "selectCharacter", true)
            datas.selectorButtons[button] = i
        end
    end
end

function deleteCharacterSelect()
    if exports.seal_gui:isGuiElementValid(characterSelectImage) then
        exports.seal_gui:deleteGuiElement(characterSelectImage)
    end

    datas = {}
end

addEvent("selectCharacter", true)
addEventHandler("selectCharacter", getRootElement(), function(button, state, absX, absY, el)
    if exports.seal_gui:isGuiElementValid(el) then
        if datas.selectorButtons[el] then
            triggerServerEvent("selectCharacter", localPlayer, datas.characters[datas.selectorButtons[el]].characterId)
        end
    end
end)

local cameraInterpolation = {}
addEvent("characterSelected", true)
addEventHandler("characterSelected", getRootElement(), function(px, py, pz, rz)
    setTimer(deleteCharacterSelect, 500, 1)
    exports.seal_gui:showLoadingScreen(2500)

    startSmoothCamera()
end)

addEvent("tryRegistration", true)
addEventHandler("tryRegistration", getRootElement(), function()
    triggerServerEvent("tryRegistration", localPlayer)
end)

addEvent("registrationResponse", true)
addEventHandler("registrationResponse", getRootElement(), function()
    deleteLoginPanel()
    createRegisterPanel()
end)

local cameraRendering = false

local defaultCameraX, defaultCameraY, defaultCameraZ
local defaultCameraLX, defaultCameraLY, defaultCameraLZ

local cameraFallTick = false
local cameraFallEndTime = 5000
local cameraFallX, cameraFallY, cameraFallZ

local cameraNormalizeTick = false
local cameraNormalizeEndTime = 2500
local cameraNormalizeX, cameraNormalizeY, cameraNormalizeZ
local cameraNormalizeLX, cameraNormalizeLY, cameraNormalizeLZ

local cameraPositionX, cameraPositionY, cameraPositionZ
local cameraStopingAtX, cameraStopingAtY, cameraStopingAtZ
local cameraLookingX, cameraLookingY, cameraLookingZ

function showInfo(type, msg)
    exports.seal_gui:showInfobox(type, msg)
end

function startSmoothCamera()
    setCameraTarget(localPlayer)
    setTimer(
        function ()
    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local cameraX, cameraY, cameraZ,
          cameraLX, cameraLY, cameraLZ = getCameraMatrix()

    if playerX and playerY and playerZ then
        defaultCameraX, defaultCameraY, defaultCameraZ,
        defaultCameraLX, defaultCameraLY, defaultCameraLZ = cameraX, cameraY, cameraZ, cameraLX, cameraLY , cameraLZ 

        cameraPositionX, cameraPositionY, cameraPositionZ = playerX, playerY, playerZ + 80
        cameraStopingAtX, cameraStopingAtY, cameraStopingAtZ = playerX, playerY, playerZ + 5
        cameraLookingX, cameraLookingY, cameraLookingZ = playerX + 0.1, playerY + 0.1, playerZ

        if cameraPositionZ and cameraStopingAtZ and cameraLookingZ then
            if not cameraRendering then
                cameraRendering = true
            end

            if not cameraFallTick then
                cameraFallTick = getTickCount()
            end

            addEventHandler("onClientRender", root, renderSmoothCamera)
        end
    end            
        end, 2000, 1
    )

end

function renderSmoothCamera()
    if cameraRendering then
        local currentTime = getTickCount()

        if cameraFallTick then
            local elapsedTime = (currentTime - cameraFallTick) / cameraFallEndTime

            if elapsedTime then
                cameraFallX, cameraFallY, cameraFallZ = interpolateBetween(cameraPositionX, cameraPositionY, cameraPositionZ, cameraStopingAtX, cameraStopingAtY, cameraStopingAtZ, elapsedTime, "InOutQuad")

                if elapsedTime >= 1 then
                    if cameraFallTick then
                        cameraFallTick = false
                    end

                    if not cameraNormalizeTick then
                        cameraNormalizeTick = getTickCount()
                    end
                end
            end
        end

        if cameraNormalizeTick then
            local elapsedTime = (currentTime - cameraNormalizeTick) / cameraNormalizeEndTime

            if elapsedTime then
                cameraNormalizeX, cameraNormalizeY, cameraNormalizeZ = interpolateBetween(cameraFallX, cameraFallY, cameraFallZ, defaultCameraX, defaultCameraY, defaultCameraZ, elapsedTime, "InOutQuad")
                cameraNormalizeLX, cameraNormalizeLY, cameraNormalizeLZ = interpolateBetween(cameraLookingX, cameraLookingY, cameraLookingZ, defaultCameraLX, defaultCameraLY, defaultCameraLZ, elapsedTime, "InOutQuad")
            
                if elapsedTime >= 1 then
                    setCameraTarget(localPlayer)

                    cameraRendering = false

                    defaultCameraX, defaultCameraY, defaultCameraZ = false, false, false
                    defaultCameraLX, defaultCameraLY, defaultCameraLZ = false, false, false

                    cameraFallTick = false
                    cameraFallX, cameraFallY, cameraFallZ = false, false, false

                    cameraNormalizeTick = false
                    cameraNormalizeX, cameraNormalizeY, cameraNormalizeZ = false, false, false
                    cameraNormalizeLX, cameraNormalizeLY, cameraNormalizeLZ = false, false, false

                    cameraPositionX, cameraPositionY, cameraPositionZ = false, false, false
                    cameraStopingAtX, cameraStopingAtY, cameraStopingAtZ = false, false, false
                    cameraLookingX, cameraLookingY, cameraLookingZ = false, false, false

                    showCursor(false)
                    showChat(true)

                    triggerServerEvent("successfullyLoggedIn", localPlayer)
                    exports.seal_clothesshop:initClothes()

                    removeEventHandler("onClientRender", root, renderSmoothCamera)
                end
            end
        end

        if cameraFallTick and cameraFallX and cameraFallY and cameraFallZ then
            setCameraMatrix(cameraFallX, cameraFallY, cameraFallZ, cameraLookingX, cameraLookingY, cameraLookingZ)
        elseif cameraNormalizeTick and cameraNormalizeX and cameraNormalizeY and cameraNormalizeZ then
            setCameraMatrix(cameraNormalizeX, cameraNormalizeY, cameraNormalizeZ, cameraNormalizeLX, cameraNormalizeLY, cameraNormalizeLZ)
        end
    end
end


local registerLogo = false
local registerImage = false
local registerButton = false
local registerUsername = false
local registerPassword = false
local registerPassword2 = false
local registerEmail = false
local registerEmail2 = false
local registerButton = false

function createRegisterPanel()
    deleteRegisterPanel()
    showChat(false)
    showCursor(true)

    setCameraMatrix(1440.1101074219, -1597.8969726562, 44.114616394043, 1501.1199951172, -1674.7985839844, 25.037271499634)

    registerImage = exports.seal_gui:createGuiElement("image", 0, 0, screenX, screenY)
    exports.seal_gui:setImageFile(registerImage, ":seal_accounts/files/gradient.png")
    exports.seal_gui:setImageColor(registerImage, "grey4")

    registerLogo = exports.seal_gui:createGuiElement("image", screenX / 2 - 64, screenY / 2 - 386, 128, 128, registerImage)
    exports.seal_gui:setImageFile(registerLogo, ":seal_accounts/files/logo.png")
    exports.seal_gui:setImageColor(registerLogo, "primary")

    local label = exports.seal_gui:createGuiElement("label", 0, screenY / 2 - (470 / 2), screenX, 48, registerImage)
    exports.seal_gui:setLabelText(label, "S E A L M T A")
    exports.seal_gui:setLabelFont(label, "27/Ubuntu-L.ttf")
    local label = exports.seal_gui:createGuiElement("label", 0, exports.seal_gui:getGuiPosition("last", "y") + exports.seal_gui:getGuiSize("last", "y"), screenX, 24, registerImage)
    exports.seal_gui:setLabelText(label, "Sok sikert a regisztrációhoz " .. getPlayerName(localPlayer):gsub("_", " ") .. "!")
    exports.seal_gui:setLabelFont(label, "12/Ubuntu-L.ttf")
    exports.seal_gui:setLabelColor(label, "primary")

    registerUsername = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (268 / 2), 300, false, registerImage)
    exports.seal_gui:setInputPlaceholder(registerUsername, "Felhasználónév")
    exports.seal_gui:setInputIcon(registerUsername, "user")
    exports.seal_gui:setInputMaxLength(registerUsername, 24)

    registerPassword = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (268 / 2) + 46, 300, false, registerImage)
    exports.seal_gui:setInputPlaceholder(registerPassword, "Jelszó")
    exports.seal_gui:setInputIcon(registerPassword, "lock")
    exports.seal_gui:setInputPassword(registerPassword, true)

    registerPassword2 = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (268 / 2) + 92, 300, false, registerImage)
    exports.seal_gui:setInputPlaceholder(registerPassword2, "Jelszó újra")
    exports.seal_gui:setInputIcon(registerPassword2, "lock")
    exports.seal_gui:setInputPassword(registerPassword2, true)

    registerEmail = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (268 / 2) + 138, 300, false, registerImage)
    exports.seal_gui:setInputPlaceholder(registerEmail, "Létező e-mail cím")
    exports.seal_gui:setInputIcon(registerEmail, "envelope-square")

    registerEmail2 = exports.seal_gui:createGuiElement("input", screenX / 2 - 150, screenY / 2 - (268 / 2) + 184, 300, false, registerImage)
    exports.seal_gui:setInputPlaceholder(registerEmail2, "Létező e-mail cím újra")
    exports.seal_gui:setInputIcon(registerEmail2, "envelope-square")

    registerButton = exports.seal_gui:createGuiElement("button", screenX / 2 - 150, screenY / 2 - (268 / 2) + 230, 300, false, registerImage)
    exports.seal_gui:setButtonText(registerButton, "Regisztráció")
    exports.seal_gui:setButtonFont(loginButton, "17/BebasNeueBold.otf")
    exports.seal_gui:setGuiBackground(registerButton, "solid", "primary")
    exports.seal_gui:setGuiHover(registerButton, "gradient", {"primary", "secondary"}, false, true)
    exports.seal_gui:setClickEvent(registerButton, "registerButtonClick", true)
end

function deleteRegisterPanel()
    if exports.seal_gui:isGuiElementValid(registerImage) then
        exports.seal_gui:deleteGuiElement(registerImage)
    end

    registerImage = false
    registerButton = false
    registerUsername = false
    registerPassword = false
    registerPassword2 = false
    registerEmail = false
    registerEmail2 = false
    registerButton = false
end

addEvent("registerButtonClick", true)
addEventHandler("registerButtonClick", getRootElement(), function()
    local username = exports.seal_gui:getInputValue(registerUsername) or ""
    local password = exports.seal_gui:getInputValue(registerPassword) or ""
    local email = exports.seal_gui:getInputValue(registerEmail) or ""

    if utf8.len(username) < 1 or utf8.len(password) < 1 or utf8.len(email) < 1 or utf8.len(exports.seal_gui:getInputValue(registerPassword2)) < 1 or utf8.len(exports.seal_gui:getInputValue(registerEmail2)) < 1 then
        exports.seal_gui:showInfobox("e", "Minden mezőt ki kell töltened!")
        return
    elseif utf8.len(username) < 4 then
        exports.seal_gui:showInfobox("e", "A megadott felhasználónév túl rövid! (Minimum 4 karakter!)")
        return
    elseif utf8.len(username) > 24 then
        exports.seal_gui:showInfobox("e", "A megadott felhasználónév túl hosszú! (Maximum 24 karakter!)")
        return
    elseif utf8.len(password) < 6 then
        exports.seal_gui:showInfobox("e", "A megadott jelszó túl rövid! (Minimum 6 karakter!)")
        return
    elseif not (utf8.match(password, "[a-z]") and utf8.match(password, "[A-Z]")) or not utf8.match(password, "[0-9]") then
        exports.seal_gui:showInfobox("e", "A megadott jelszónak tartalmaznia kell számot, valamint kis- és nagybetűt is!")
        return
    elseif utf8.match(username, "[^a-zA-Z0-9_%.%-%,]") then
        exports.seal_gui:showInfobox("e", "A megadott felhasználónév nem megfelelő formátumú!")
        return
    elseif not utf8.match(email, "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?") then
        exports.seal_gui:showInfobox("e", "A megadott e-mail cím nem megfelelő formátumú!")
        return
    elseif password ~= exports.seal_gui:getInputValue(registerPassword2) then
        exports.seal_gui:showInfobox("e", "A megadott jelszavak nem egyeznek meg!")
        return
    elseif email ~= exports.seal_gui:getInputValue(registerEmail2) then
        exports.seal_gui:showInfobox("e", "A megadott e-mail címek nem egyeznek meg!")
        return
    end

    triggerServerEvent("tryEndRegistration", localPlayer, username, password, email)
end)

addEvent("registrationEndResponse", true)
addEventHandler("registrationEndResponse", getRootElement(), function()
    deleteRegisterPanel()
    createLoginPanel()
    exports.seal_gui:showInfobox("s", "Sikeres regisztráció! Mostmár bejelentkezhetsz!")
end)

function saveLoginFiles(username, password)
    if fileExists("@loginremember.insight") then
        fileDelete("@loginremember.insight")
    end

    if username and password then
        local file = fileCreate("@loginremember.insight")

        if file then
            fileWrite(file, username .. "\n" .. password)
            fileClose(file)
        end
    end
end

function loadLoginFiles()
    if fileExists("@loginremember.insight") then
        local file = fileOpen("@loginremember.insight")

        if file then
            local data = fileRead(file, fileGetSize(file))
            data = split(data, "\n")

            exports.seal_gui:setInputValue(loginUsernameInput, data[1] or "")
            exports.seal_gui:setInputValue(loginPasswordInput, data[2] or "")
            exports.seal_gui:setCheckboxChecked(loginRememberCheckbox, true)
            
            fileClose(file)
        end
    end
end

function getPositionOffset(x, y, z, rx, ry, rz, offX, offY, offZ)
    rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
    local m = {}
    m[1] = {}
    m[1][1] = math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry)
    m[1][2] = math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry)
    m[1][3] = -math.cos(rx) * math.sin(ry)
    m[1][4] = 1
    m[2] = {}
    m[2][1] = -math.cos(rx) * math.sin(rz)
    m[2][2] = math.cos(rz) * math.cos(rx)
    m[2][3] = math.sin(rx)
    m[2][4] = 1
    m[3] = {}
    m[3][1] = math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx)
    m[3][2] = math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx)
    m[3][3] = math.cos(rx) * math.cos(ry)
    m[3][4] = 1
    m[4] = {}
    m[4][1], m[4][2], m[4][3] = x, y, z
    m[4][4] = 1
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end


local hungerWarningNoti = false
local hungerWarningNoti2 = false
local thirstWarningNoti = false
local thirstWarningNoti2 = false

setTimer(
	function ()
		if (getElementData(localPlayer, "acc.adminJail") or 0) ~= 0 then
			return
		end
	
		if (getElementData(localPlayer, "adminDuty") or 0) ~= 1 then
			return
		end

		if getElementData(localPlayer, "isPlayerDeath") then
			return
		end

		if getElementHealth(localPlayer) > 20 then
			local bulletDamages = getElementData(localPlayer, "bulletDamages") or {}
			local bloodLevel = getElementData(localPlayer, "bloodLevel") or 100
			local bloodLoss = 0

			for data, amount in pairs(bulletDamages) do
				local typ = gettok(data, 1, ";")

				if typ == "stitch-cut" then
				elseif typ == "stitch-hole" then
				elseif typ == "punch" then
				elseif typ == "hole" then
					bloodLoss = bloodLoss + math.random(7, 20) / 10
				elseif typ == "cut" then
					bloodLoss = bloodLoss + math.random(7, 20) / 10
				else
					local weapon = tonumber(typ)

					if weapon >= 25 and weapon <= 27 then
						bloodLoss = bloodLoss + math.random(7, 20) / 10
					else
						bloodLoss = bloodLoss + math.random(7, 20) / 10
					end
				end
			end

			if getElementData(localPlayer, "usingBandage") then
				bloodLoss = bloodLoss * 0.6
			end

			if bloodLoss > 0 then
				bloodLevel = bloodLevel - bloodLoss

				if bloodLevel <= 0 then
					--triggerServerEvent("customKillMessage", localPlayer, "elvérzett")
					setElementData(localPlayer, "customDeath", "elvérzett")
					setElementHealth(localPlayer, 0)
					bloodLevel = 0
				end

				setElementData(localPlayer, "bloodLevel", bloodLevel)
			elseif bloodLevel < 100 then
				setElementData(localPlayer, "bloodLevel", 100)
				setElementData(localPlayer, "usingBandage", false)
			end
		end
	end,
10000, 0)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getElementData(localPlayer, "loggedIn") then
        minuteTimer = setTimer(processMinuteTimer, 60000, 0)
    end
end)

function processMinuteTimer()
	if (getElementData(localPlayer, "acc.adminJail") or 0) >= 1 then
		return
	end

	local lastRespawn = getElementData(localPlayer, "lastRespawn") or 0

	if lastRespawn > 0 then
		setElementData(localPlayer, "lastRespawn", lastRespawn - 1)
	end

	local adminDuty = getElementData(localPlayer, "adminDuty") or 0

	if adminDuty == 0 then
		-- ** Éhség
		local drugHunger = getElementData(localPlayer, "drugHunger")
		local currentHunger = getElementData(localPlayer, "char.Hunger") or 100
		local hungerLoss = math.random(10, 20) / 100

		if drugHunger then
			drugHunger[1] = drugHunger - 1

			if drugHunger[1] <= 0 then
				drugHunger = false
			end

			setElementData(localPlayer, "drugHunger", drugHunger)
		end

		if drugHunger then
			hungerLoss = hungerLoss * drugHunger[2]
		end

		if currentHunger - hungerLoss >= 0 then
			currentHunger = currentHunger - hungerLoss
			setElementData(localPlayer, "char.Hunger", currentHunger)
		else
			currentHunger = 0
			setElementData(localPlayer, "char.Hunger", 0)
		end
		
		if not hungerWarningNoti then
			if currentHunger < 40 then
				hungerWarningNoti = true
				outputChatBox("#4adfbf[SealMTA]:#ffffff Kezdesz éhes lenni, menj és #4adfbfegyél #ffffffvalamit.", 255, 255, 255, true)
				--exports.seal_hud:showInfobox("w", "Éhségszinted alacsony, részletek a chatboxban.")
			end
		elseif currentHunger >= 40 then
			hungerWarningNoti = false
		end
		
		if not hungerWarningNoti2 then
			if currentHunger <= 20 then
				hungerWarningNoti2 = true
				outputChatBox("#4adfbf[SealMTA]:#ffffff Olyan #4adfbféhes vagy, #ffffffhogy ez már hatással van az egészségedre is. Menj és #4adfbfegyél #ffffffvalamit.", 255, 255, 255, true)
				--exports.seal_hud:showInfobox("w", "Éhségszinted túl alacsony, részletek a chatboxban.")
			end
		elseif currentHunger > 20 then
			hungerWarningNoti2 = false
		end
		
		-- ** Szomjúság
		local currentThirst = getElementData(localPlayer, "char.Thirst") or 100
		local thirstLoss = math.random(20, 30) / 100

		if drugHunger then
			thirstLoss = thirstLoss * drugHunger[2]
		end
		
		if currentThirst - thirstLoss >= 0 then
			currentThirst = currentThirst - thirstLoss
			setElementData(localPlayer, "char.Thirst", currentThirst)
		else
			currentThirst = 0
			setElementData(localPlayer, "char.Thirst", 0)
		end
		
		if not thirstWarningNoti then
			if currentThirst < 40 then
				thirstWarningNoti = true
				outputChatBox("#4adfbf[SealMTA]:#ffffff Kezdesz szomjas lenni, menj és #4adfbfigyál #ffffffvalamit.", 255, 255, 255, true)
				--exports.seal_hud:showInfobox("w", "Szomjúságszinted alacsony, részletek a chatboxban.")
			end
		elseif currentThirst >= 40 then
			thirstWarningNoti = false
		end
		
		if not thirstWarningNoti2 then
			if currentThirst <= 20 then
				thirstWarningNoti2 = true
				outputChatBox("#4adfbf[SealMTA]:#ffffff Olyan #4adfbfszomjas vagy, #ffffffhogy ez már hatással van az egészségedre is. Menj és #4adfbfigyál #ffffffvalamit.", 255, 255, 255, true)
			end
		elseif currentThirst > 20 then
			thirstWarningNoti2 = false
		end
		
		-- ** Életerő csökkentése
		if currentHunger <= 20 then
			if getElementHealth(localPlayer) - 3 >= 0 then
				setElementData(localPlayer, "customDeath", "éhenhalt")
				setElementHealth(localPlayer, 0)
			else
				setElementHealth(localPlayer, getElementHealth(localPlayer) - 3)
			end
		end

		if currentThirst <= 20 then
			if getElementHealth(localPlayer) - 5 >= 0 then
				setElementData(localPlayer, "customDeath", "szomjanhalt")
				setElementHealth(localPlayer, 0)
			else
				setElementHealth(localPlayer, getElementHealth(localPlayer) - 5)
			end
		end
	end
	
	local playedMinutes = getElementData(localPlayer, "char.playedMinutes") or 0

	if playedMinutes then
		setElementData(localPlayer, "char.playedMinutes", playedMinutes + 1)
	end
	
	local paintOnPlayerTime = getElementData(localPlayer, "paintOnPlayerTime") or 0

	if paintOnPlayerTime > 0 then
		if playedMinutes + 1 - paintOnPlayerTime > 180 then
			setElementData(localPlayer, "paintVisibleOnPlayer", false)
		else
			setElementData(localPlayer, "paintVisibleOnPlayer", true)
		end
	end
end

local function doCapitalizing( substring )
    -- Upper the first character and leave the rest as they are
    return substring:sub( 1, 1 ):upper( ) .. substring:sub( 2 )
end

function capitalize( text )
    -- Sanity check
    assert( type( text ) == "string", "Bad argument 1 @ capitalize [String expected, got " .. type( text ) .. "]")

    -- We don't care about the number of words, so return only the first result string.gsub provides
    return ( { string.gsub( text, "%a+", doCapitalizing ) } )[1]
end

addEventHandler("onClientElementDataChange", getRootElement(),
    function(dataName, oldValue, newValue)
        if source == localPlayer then
            if dataName == "loggedIn" then
                if newValue then
                    if isTimer(minuteTimer) then
                        killTimer(minuteTimer)
                    end

                    minuteTimer = setTimer(processMinuteTimer, 60000, 0)
                end

                if not newValue then
                    if isTimer(minuteTimer) then
                        killTimer(minuteTimer)
                    end
                end
            end

            if dataName == "afk" then
                if newValue then
                    if isTimer(minuteTimer) then
                        killTimer(minuteTimer)
                    end
                end

                if not newValue then
                    minuteTimer = setTimer(processMinuteTimer, 60000, 0)
                end
            end 
        end
    end
)