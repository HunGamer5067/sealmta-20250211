addEvent("policeMessageFromServer", true)
addEventHandler("policeMessageFromServer", getRootElement(), function(message)
	if exports.seal_groups:isPlayerInGroup(localPlayer, {1, 2, 4, 8}) then
		outputChatBox(message, 255, 255, 255, true)
	end
end)

addEvent("handlepoliceBlip", true)
addEventHandler("handlepoliceBlip", getRootElement(),
	function (sourceElement, callID)
		if isElement(blipElement) then
			destroyElement(blipElement)
		end

		if isElement(markerElement) then
			destroyElement(markerElement)
		end

		if isElement(sourceElement) then
			blipElement = createBlip(0, 0, 0, 0, 2, 50, 179, 239)

			if isElement(blipElement) then
				attachElements(blipElement, sourceElement)
				setElementData(blipElement, "blipTooltipText", "Ügyfél")
			end

			markerElement = createMarker(0, 0, 0, "checkpoint", 4, 50, 179, 239)

			if isElement(markerElement) then
				attachElements(markerElement, sourceElement)
			end

			currentcallID = callID
		end
	end
)

addEventHandler("onClientMarkerHit", getRootElement(),
	function (hitElement)
		if hitElement == localPlayer then
			if source == markerElement then
				if isElement(blipElement) then
					destroyElement(blipElement)
				end

				if isElement(markerElement) then
					destroyElement(markerElement)
				end

				triggerServerEvent("endThepolice", localPlayer, currentcallID)
			end
		end
	end
)

addEvent("radioSoundForpolice", true)
addEventHandler("radioSoundForpolice", getRootElement(),
	function ()
		if exports.seal_groups:isPlayerInGroup(localPlayer, {1, 2, 4, 8}) then
			playSoundFrontEnd(47)
			setTimer(playSoundFrontEnd, 700, 1, 48)
			setTimer(playSoundFrontEnd, 800, 1, 48)
		end
	end
)

function policeMessage(message)
	outputChatBox("#4adfbf[SealMTA - Rendőrség]:#FFFFFF " .. message, 255, 255, 255, true)
end