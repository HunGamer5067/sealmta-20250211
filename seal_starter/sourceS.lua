local highPriority = {
    "seal_gui",
    "seal_database",
    "seal_anticheat",
    "seal_core",
    "seal_mall",
}
local highPriorityEx = {}

local lowPriority = {
    "seal_accounts",
    "seal_hud",
    "seal_dashboard",
    "seal_clothesshop",
    "seal_playerclick",
    "seal_groups",
    "seal_groupscripting",
    "seal_dlssao",
    "seal_dashboard",
    "seal_map_loader",
    "seal_carshop",
    "seal_ev",
    "seal_fishing",
    "seal_job_post",
    "seal_jewelry",
    "seal_license",
}
local lowPriorityEx = {}

addEventHandler("onResourceStart", resourceRoot, function()
    local sortedResources = {}

    for k, v in pairs(highPriority) do
        local res = getResourceFromName(v)

        if res then
            highPriorityEx[v] = true
            table.insert(sortedResources, res)
        end
    end
    
    for k, v in pairs(lowPriority) do
        local res = getResourceFromName(v)

        if res then
            lowPriorityEx[v] = true
        end
    end

    local resources = getResources()
    for i = 1, #resources do
        local res = resources[i]
        local resName = getResourceName(res)

        if not highPriorityEx[resName] and not lowPriorityEx[resName] and resName ~= "seal_starter" then
            table.insert(sortedResources, res)
        end
    end

    for k, v in pairs(lowPriority) do
        local res = getResourceFromName(v)

        if res then
            table.insert(sortedResources, res)
        end
    end

    for i = 1, #sortedResources do
        local res = sortedResources[i]
        local resName = getResourceName(res)
        local metaFile = xmlLoadFile(":" .. resName .. "/meta.xml")

        if metaFile then
            local dpg = xmlFindChild(metaFile, "download_priority_group", 0)
            local dpgValue = 0 - i

            if not dpg then
                dpg = xmlCreateChild(metaFile, "download_priority_group")
            end

            xmlNodeSetValue(dpg, tostring(dpgValue))
            xmlSaveFile(metaFile)
            xmlUnloadFile(metaFile)
        end
    end

    for i = 1, #sortedResources do
        local res = sortedResources[i]
        local resName = getResourceName(res)

        if utfSub(resName, 1, 5) == "seal_" then
            startResource(res, true)
        end
    end

    stopResource(getThisResource())
end)