addEvent("onBackFire",true)
addEventHandler("onBackFire",getRootElement(),
    function(player, test)
        if client and getPedOccupiedVehicle(client) then
            if isElement(source) and getElementType(source) == "vehicle" and getPedOccupiedVehicle(client) == source then
                if test then
                    local element = source

                    setTimer(
                        function()
                            triggerClientEvent(player, "onBackFire", element, test.sound, test.speed, test.consistence)
                        end, 120, (test.consistence * 10) + 1
                    )
                else
                    local customBackfire = getElementData(source, "vehicle.customBackfire") or false

                    if customBackfire then
                        triggerClientEvent(player, "onBackFire", source, customBackfire.sound, customBackfire.speed, customBackfire.consistence)
                    else
                        triggerClientEvent(player, "onBackFire", source)
                    end
                end
            end
        end
    end
)

addEvent("onDiesel",true)
addEventHandler("onDiesel",getRootElement(),
    function(player, test)
        if client and getPedOccupiedVehicle(client) then
            if isElement(source) and getElementType(source) == "vehicle" and getPedOccupiedVehicle(client) == source then
                triggerClientEvent(player, "onDiesel", source)
            end
        end
    end
)

addEvent("onLaunchControl", true)
addEventHandler("onLaunchControl", getRootElement(),
    function(player, test)
        if client and getPedOccupiedVehicle(client) then
            if isElement(source) and getElementType(source) == "vehicle" and getElementData(source, "extraBackFireTuning") and getPedOccupiedVehicle(client) == source then
                triggerClientEvent(player, "onLaunchControl", source)
            end
        end
    end
)