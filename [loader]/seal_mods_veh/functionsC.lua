local vehicleSettings = {}
local vehicleMods = {
    {
        model = 579,
        files = "huntley",
    },
    {
        model = 540,
        files = "vincent",
    },
    {
        model = 589,
        files = "club",
    },
    {
        model = 458,
        files = "solair",
    },
    {
        model = 582,
        files = "newsvan",
    },
    {
        model = 416,
        files = "ambulan",
    },
    {
        model = 554,
        files = "ram",
    },
    {
        model = 545,
        files = "rolls1",
    },
    {
        model = 505,
        files = "rolls2",
    },
    {
        model = 558,
        files = "peugeot",
    },
    {
        model = 516,
        files = "bmwi4",
    },
    {
        model = 561,
        files = "model_s",
    },
    {
        model = 445,
        files = "admiral",
    },
    {
        model = 405,
        files = "sentinel",
    },
    {
        model = 400,
        files = "landstalker",
    },
    {
        model = 549,
        files = "tampa",
    },
    {
        model = 466,
        files = "glendale",
    },
    {
        model = 492,
        files = "greenwood",
    },
    {
        model = 420,
        files = "taxi",
    },
    {
        model = 541,
        files = "bullet",
    },
    {
        model = 546,
        files = "intruder",
    },
    {
        model = 506,
        files = "supergt",
    },
    {
        model = 479,
        files = "regina",
    },
    {
        model = 604,
        files = "glendaleshit",
    },
}

function loadVehicle(index)
    if vehicleMods[index] then
        local filePath = vehicleMods[index].files

        if fileExists("vehs/" .. filePath .. ".txd") then
            local txdFile = engineLoadTXD("vehs/" .. filePath .. ".txd", true)

            if txdFile then
                engineImportTXD(txdFile, vehicleMods[index].model)
            end

            txdFile = nil
            collectgarbage("collect")
        end

        if fileExists("vehs/" .. filePath .. ".dff") then
            local dffFile = engineLoadDFF("vehs/" .. filePath .. ".dff", vehicleMods[index].model)

            if dffFile then
                engineReplaceModel(dffFile, vehicleMods[index].model)
            end

            dffFile = nil
            collectgarbage("collect")
        end

        vehicleSettings[index].disabled = false
    end
end

function unLoadVehicle(index)
    if vehicleMods[index] then
        if vehicleSettings[index].disabled then
            return
        end

        engineRestoreModel(vehicleMods[index].model)
        vehicleSettings[index].disabled = true
    end
end

addEventHandler("onClientResourceStart", getRootElement(), function(startedResource)
    if startedResource == getThisResource() then
        if fileExists("settings.json") then
            local file = fileOpen("settings.json")
            local fileContent = fileRead(file, fileGetSize(file))
            fileClose(file)

            vehicleSettings = fromJSON(fileContent)

            fileContent = nil
            collectgarbage("collect")
        end

        for vehicleIndex in pairs(vehicleMods) do
            if not vehicleSettings[vehicleIndex] then
                vehicleSettings[vehicleIndex] = {}
                vehicleSettings[vehicleIndex].disabled = false
            end

            if not vehicleSettings[vehicleIndex].disabled then
                loadVehicle(vehicleIndex)
            end
        end
    end
end)

local function saveSettings()
    if fileExists("settings.json") then
        fileDelete("settings.json")
    end
    
    local file = fileCreate("settings.json")
    fileWrite(file, toJSON(vehicleSettings))
    fileClose(file)
end

addEventHandler("onClientResourceStop", getRootElement(), function(stoppedResource)
    if stoppedResource == getThisResource() then
        saveSettings()
    end
end)

local screenX, screenY = guiGetScreenSize()

local vehicleListWidth = 600
local vehicleListHeight = 440

local vehicleListPosX = (screenX - vehicleListWidth) / 2
local vehicleListPosY = (screenY - vehicleListHeight) / 2

local vehicleListGui = false
local vehicleListScroll = 0
local vehicleListDraw = 11
local vehicleListLastClick = false

local vehicleListLabels = {}
local vehicleListChecks = {}

local vehicleListButton = false
local vehicleListText = false

function createVehicleList()
    vehicleListGui = exports.seal_gui:createGuiElement("window", vehicleListPosX, vehicleListPosY, vehicleListWidth, vehicleListHeight)
    exports.seal_gui:setWindowTitle(vehicleListGui, "15/BebasNeueRegular.otf", "SealMTA - Modpanel")
    exports.seal_gui:setWindowCloseButton(vehicleListGui, "closeModPanelGui")

    local rectangle = exports.seal_gui:createGuiElement("rectangle", 0, vehicleListHeight - 48, vehicleListWidth, 48, vehicleListGui)
    exports.seal_gui:setGuiBackground(rectangle, "solid", "grey1")

    local rectangle = exports.seal_gui:createGuiElement("rectangle", 0, vehicleListHeight - 48, vehicleListWidth, 1, vehicleListGui)
    exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

    vehicleListText = exports.seal_gui:createGuiElement("label", 6, vehicleListHeight - 42, vehicleListWidth, 34, vehicleListGui)
    exports.seal_gui:setLabelAlignment(vehicleListText, "left", "center")
    exports.seal_gui:setLabelFont(vehicleListText, "15/BebasNeueRegular.otf")

    vehicleListButton = exports.seal_gui:createGuiElement("button", vehicleListWidth - 186, vehicleListHeight - 36, 180, 25, vehicleListGui)
    exports.seal_gui:setButtonFont(vehicleListButton, "13/BebasNeueRegular.otf")
    exports.seal_gui:setClickEvent(vehicleListButton, "tryToClickModsButton")

    for i = 1, vehicleListDraw do
        local vehicleOneWidth = vehicleListWidth
        local vehicleOneHeight = (vehicleListHeight - 84) / vehicleListDraw

        local vehicleOnePosX = 0
        local vehicleOnePosY = 35 + (vehicleOneHeight * (i - 1))

        local rectangle = exports.seal_gui:createGuiElement("rectangle", vehicleOnePosX, vehicleOnePosY, vehicleOneWidth, 1, vehicleListGui)
        exports.seal_gui:setGuiBackground(rectangle, "solid", "grey1")

        local rectangle = exports.seal_gui:createGuiElement("rectangle", vehicleOnePosX, vehicleOnePosY + 1, vehicleOneWidth, 1, vehicleListGui)
        exports.seal_gui:setGuiBackground(rectangle, "solid", "grey3")

        local label = exports.seal_gui:createGuiElement("label", vehicleOnePosX + 6, vehicleOnePosY + 1, vehicleOneWidth, vehicleOneHeight, vehicleListGui)
        exports.seal_gui:setLabelAlignment(label, "left", "center")
        vehicleListLabels[i] = label

        local check = exports.seal_gui:createGuiElement("checkbox", vehicleOnePosX + vehicleOneWidth - vehicleOneHeight + 5, vehicleOnePosY + 4, vehicleOneHeight - 6, vehicleOneHeight - 6, vehicleListGui)
        exports.seal_gui:setCheckboxColor(check, "midgrey", "grey2", "primary", "#ffffff")
        exports.seal_gui:setClickEvent(check, "toggleVehicleMod")
        vehicleListChecks[i] = check
    end

    refreshVehicleList()
    addEventHandler("onClientKey", getRootElement(), scrollVehicleList)
end

function refreshVehicleList()
    for i = 1, vehicleListDraw do
        local vehicleIndex = i + vehicleListScroll

        if vehicleMods[vehicleIndex] then
            local vehicleName = exports.seal_vehiclenames:getCustomVehicleName(vehicleMods[vehicleIndex].model)
            local vehicleModState = vehicleSettings[vehicleIndex] and vehicleSettings[vehicleIndex].disabled

            exports.seal_gui:setCheckboxChecked(vehicleListChecks[i], not vehicleModState)
            exports.seal_gui:setGuiRenderDisabled(vehicleListChecks[i], false)

            exports.seal_gui:setLabelText(vehicleListLabels[i], vehicleName)
            exports.seal_gui:setGuiRenderDisabled(vehicleListLabels[i], false)
        else
            exports.seal_gui:setGuiRenderDisabled(vehicleListChecks[i], true)
            exports.seal_gui:setGuiRenderDisabled(vehicleListLabels[i], true)
        end
    end

    local disableCount = 0

    for i = 1, #vehicleMods do
        if vehicleSettings[i] and vehicleSettings[i].disabled then
            disableCount = disableCount + 1
        end
    end

    if disableCount == #vehicleMods then
        exports.seal_gui:setGuiBackground(vehicleListButton, "solid", "primary")
        exports.seal_gui:setGuiHover(vehicleListButton, "gradient", {"primary", "secondary"}, false, true)
        exports.seal_gui:setButtonText(vehicleListButton, "Összes mod bekapcsolása")
    else
        exports.seal_gui:setGuiBackground(vehicleListButton, "solid", "red")
        exports.seal_gui:setGuiHover(vehicleListButton, "gradient", {"red", "red-second"}, false, true)
        exports.seal_gui:setButtonText(vehicleListButton, "Összes mod kikapcsolása")
    end

    exports.seal_gui:setLabelText(vehicleListText, "Kikapcsolt modok: [color=primary]" .. disableCount .. "/" .. #vehicleMods)
end

function scrollVehicleList(key, state)
    if vehicleListGui then
        if key == "mouse_wheel_down" then
            if vehicleListScroll < #vehicleMods - vehicleListDraw then
                vehicleListScroll = vehicleListScroll + 1
            end

            refreshVehicleList()
        elseif key == "mouse_wheel_up" then
            vehicleListScroll = math.max(vehicleListScroll - 1, 0)
            refreshVehicleList()
        end
    end
end

addEvent("closeModPanelGui", true)
addEventHandler("closeModPanelGui", getRootElement(), function()
    if vehicleListGui then
        exports.seal_gui:deleteGuiElement(vehicleListGui)
    end

    vehicleListGui = false
    vehicleListScroll = 0
    
    vehicleListLabels = {}
    vehicleListChecks = {}
    
    vehicleListButton = false
    vehicleListText = false

    removeEventHandler("onClientKey", getRootElement(), scrollVehicleList)
end)

addEvent("tryToClickModsButton", true)
addEventHandler("tryToClickModsButton", getRootElement(), function(button, state, absX, absY, el)
    if el == vehicleListButton then
        local disableCount = 0

        for i, v in ipairs(vehicleMods) do
            if vehicleSettings and vehicleSettings[i] and vehicleSettings[i].disabled then
                disableCount = disableCount + 1
            end
        end
        
        local modsAction = (disableCount == #vehicleMods) and loadVehicle or unLoadVehicle
        for i = 1, #vehicleMods do
            modsAction(i)
        end
        
        refreshVehicleList()
    end
end)

addEvent("toggleVehicleMod", true)
addEventHandler("toggleVehicleMod", getRootElement(), function(button, state, absX, absY, el)
    if vehicleListLastClick and (getTickCount() - vehicleListLastClick) < 1000 then
        exports.seal_gui:setCheckboxChecked(el, not exports.seal_gui:isCheckboxChecked(el))
        exports.seal_gui:showInfobox("e", "Várj 1 másodpercet a következő interakcióhoz!")
        return
    end
    vehicleListLastClick = getTickCount()

    for i = 1, vehicleListDraw do
        if el == vehicleListChecks[i] then
            local vehicleIndex = i + vehicleListScroll

            if vehicleMods[vehicleIndex] then                
                if vehicleSettings and vehicleSettings[vehicleIndex] and vehicleSettings[vehicleIndex].disabled then
                    loadVehicle(vehicleIndex)
                else
                    unLoadVehicle(vehicleIndex)
                end

                refreshVehicleList()
                break
            end
        end
    end
end)

addCommandHandler("modpanel", function()
    local loggedIn = getElementData(localPlayer, "loggedIn")
    local canUseModPanel = not vehicleListGui and loggedIn

    if canUseModPanel then
        createVehicleList()
    end
end)