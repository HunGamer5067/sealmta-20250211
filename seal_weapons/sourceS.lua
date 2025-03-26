addEventHandler("onResourceStart", resourceRoot, function()
    for i = 1, #realWeaponContainer do
        local weapon = realWeaponContainer[i]
        
        --
    end
end)

addEvent("giveCustomWeapon", true)
addEventHandler("giveCustomWeapon", getRootElement(), function(player, weapon, ammo, skin, itemId)
    if not client and isElement(player) and weapon then
        setElementData(player, "equippedCustomWeapon", weapon)
        setElementData(player, "equippedCustomWeaponId", itemId)

        takeAllWeapons(player)
        giveWeapon(player, customWeaponContainer[weapon].realWeaponId, ammo + 1, true)

        if not getPedOccupiedVehicle(player) then
            setPedAnimation(player, "colt45", "sawnoff_reload", 500, false, false, false, false)
        end
        triggerClientEvent(getRootElement(), "giveCustomWeapon", player, player, weapon, skin)
    end
end)

addEvent("syncWeaponShotSound", true)
addEventHandler("syncWeaponShotSound", resourceRoot, function()
    local equippedCustomWeapon = getElementData(client, "equippedCustomWeapon")

    if equippedCustomWeapon then
        local x, y, z = getElementPosition(client)

        triggerClientEvent(getRootElement(), "syncWeaponShotSound", resourceRoot, client, equippedCustomWeapon, x, y, z)
    end
end)

addEvent("syncCustomWeaponTake", true)
addEventHandler("syncCustomWeaponTake", resourceRoot, function()
    setElementData(client, "equippedCustomWeapon", false)
    setElementData(client, "equippedCustomWeaponId", false)
end)

addEvent("viperaInjure", true)
addEventHandler("viperaInjure", resourceRoot, function()
    local bones = {"char.injureLeftArm", "char.injureRightArm", "char.injureLeftFoot", "char.injureRightFoot"}
    setElementData(client, bones[math.random(1, #bones)], true)
end)