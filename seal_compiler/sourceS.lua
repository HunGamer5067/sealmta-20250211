local compileEnabled = 1
local debugLevel = 0
local obfuscateLevel = 3

function compileResource(resourceName)
    local resourceElement = getResourceFromName(resourceName)

    if resourceElement and resourceName then
        local metaPath = ":" .. resourceName .. "/meta.xml"
        local metaFile = xmlLoadFile(metaPath)

        if metaFile then
            local scriptIndex = 0
            local scriptNode = false

            repeat
                if scriptNode then
                    local scriptPath = xmlNodeGetAttribute(scriptNode, "src") or false
                    local scriptType = xmlNodeGetAttribute(scriptNode, "type") or "server"

                    if scriptPath and scriptType then
                        local compileScript = true

                        if string.find(string.lower(scriptPath), "luac") then
                            compileScript = false
                            outputDebugString("[COMPILER]: " .. resourceName .. "/" .. scriptPath .. " már levan védve!", 1)
                        end

                        if compileScript then
                            local fetchURL = string.format("https://luac.mtasa.com/?compile=%i&debug=%i&obfuscate=%i", compileEnabled, debugLevel, obfuscateLevel)
                            local scriptBuffer = loadScriptBuffer(resourceName, scriptPath)

                            if scriptBuffer then
                                if scriptNode then
                                    xmlNodeSetAttribute(scriptNode, "src", scriptPath .. "c")
                                end

                                fetchRemote(fetchURL, function(data, error, scriptNode)
                                    local compiledFile = fileCreate(":" .. resourceName .. "/" .. scriptPath .. "c")
                                    fileWrite(compiledFile, data)
                                    fileClose(compiledFile)

                                    outputDebugString("[COMPILER]: " .. resourceName .. "/" .. scriptPath .. " sikeresen levédve!", 3)
                                end, scriptBuffer, true, scriptNode)
                            end
                        end
                    end
                end

                scriptNode = xmlFindChild(metaFile, "script", scriptIndex)
                scriptIndex = scriptIndex + 1
            until not scriptNode

            xmlSaveFile(metaFile)
            xmlUnloadFile(metaFile)
        end
    end
end

function decompileResource(resourceName)
    local resourceElement = getResourceFromName(resourceName)

    if resourceElement and resourceName then
        local metaPath = ":" .. resourceName .. "/meta.xml"
        local metaFile = xmlLoadFile(metaPath)

        if metaFile then
            local scriptIndex = 0
            local scriptNode = false

            repeat
                if scriptNode then
                    local scriptPath = xmlNodeGetAttribute(scriptNode, "src") or false
                    local scriptType = xmlNodeGetAttribute(scriptNode, "type") or "server"

                    if scriptPath and scriptType then
                        local scriptFakePath = string.lower(scriptPath)
                        
                        if string.find(scriptFakePath, "luac") then
                            local scriptNewPath = string.gsub(scriptPath, "%.luac$", ".lua")

                            if fileExists(":" .. resourceName .. "/" .. scriptNewPath) then
                                fileDelete(":" .. resourceName .. "/" .. scriptPath)
                                
                                if scriptNode then
                                    xmlNodeSetAttribute(scriptNode, "src", scriptNewPath)
                                end

                                outputDebugString("[COMPILER]: " .. resourceName .. "/" .. scriptPath .. " sikeresen decompileolva!", 3)
                            else
                                outputDebugString("[COMPILER]: " .. resourceName .. "/" .. scriptNewPath .. " nem található!", 1)
                            end
                        end
                    end
                end

                scriptNode = xmlFindChild(metaFile, "script", scriptIndex)
                scriptIndex = scriptIndex + 1
            until not scriptNode

            xmlSaveFile(metaFile)
            xmlUnloadFile(metaFile)
        end
    end
end

function loadScriptBuffer(resourceName, scriptPath)
    local scriptPath = ":" .. resourceName .. "/" .. scriptPath
    
    if fileExists(scriptPath) then
        local scriptFile = fileOpen(scriptPath)
        local scriptBuffer = fileRead(scriptFile, fileGetSize(scriptFile))
        fileClose(scriptFile)
        
        return scriptBuffer
    end

    return false
end

function compileAllResource()
    for _, resource in ipairs(getResources()) do
        local resourceName = getResourceName(resource)

        if resourceName and resourceName ~= "seal_compiler" and resourceName ~= "seal_database" then
            compileResource(resourceName)
        end
    end
end

addCommandHandler("compile", function(playerElement, command, resourceName)
    if getElementData(playerElement, "acc.adminLevel") >= 8 then
        if resourceName then
            compileResource(resourceName)
        end
    end
end)

addCommandHandler("compileall", function(playerElement, command)
    if getElementData(playerElement, "acc.adminLevel") >= 8 then
        compileAllResource()
    end
end)

addCommandHandler("uncompile", function(playerElement, commandName, resourceName)
    if getElementData(playerElement, "acc.adminLevel") >= 8 then
        if resourceName then
            decompileResource(resourceName)
        end
    end
end)