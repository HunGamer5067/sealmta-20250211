addEvent("changeCurrentCCTV", true)
function changeCurrentCCTV(camera)
    triggerClientEvent(client, "changeCurrentCCTV", client, camera)
end
addEventHandler("changeCurrentCCTV", root, changeCurrentCCTV)

addEvent("syncCCTVRotation", true)
function syncCCTVRotation(camera, rx, ry, rz)
    triggerClientEvent("syncCCTVRotation", client, camera, rx, ry, rz)
end
addEventHandler("syncCCTVRotation", root, syncCCTVRotation)

addEvent("syncCameraDimension", true)
function syncCameraDimension(camera, rx, ry, rz)
end
addEventHandler("syncCameraDimension", root, syncCameraDimension)

addEvent("syncCCTVDamage", true)
function syncCCTVDamage(camera)
    triggerClientEvent("syncCCTVDamage", client, camera, true)
end
addEventHandler("syncCCTVDamage", root, syncCCTVDamage)