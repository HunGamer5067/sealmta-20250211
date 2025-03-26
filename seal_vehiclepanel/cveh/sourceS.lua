addEvent("openTheDoor", true)
addEventHandler("openTheDoor", getRootElement(),
	function (door, occupants, affecteds, doorRatio)
		if isElement(source) then

			if doorRatio > 0 then
				setVehicleDoorOpenRatio(source, door, 0, 250)
			else
				setVehicleDoorOpenRatio(source, door, 1, 500)
			end

			triggerClientEvent(occupants, "playTheDoorSound", source, source, doorRatio, true)
			triggerClientEvent(affecteds, "playTheDoorSound", source, source, doorRatio, false)
		end
	end
)

addEvent("playWindowSound", true)
addEventHandler("playWindowSound", getRootElement(), 
  function(players)
  		if isElement(source) then
			local occupants = {}
			local affecteds = {}

			for i = 1, #players do
				local data = players[i]

				if isElement(data[1]) then
					if data[2] == "2d" then
						table.insert(occupants, data[1])
					elseif data[2] == "3d" then
						table.insert(affecteds, data[2])
					end
				end
			end
		end
  	end
)
