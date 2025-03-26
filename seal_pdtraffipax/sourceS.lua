addEvent("syncSpeedCameras", true)
addEventHandler("syncSpeedCameras", getRootElement(),
    function(sourcePlayer, posX, posY, posZ, rotZ)
        if posX and posY and posZ and rotZ then
            local traffiObject = createObject(951, posX, posY, posZ - 1, 0, 0, rotZ)
            setElementData(traffiObject, "isCustomSpeedCam", true)

            setElementData(traffiObject, "player", sourcePlayer)
            
            local traffiCol = createColSphere(posX, posY, posZ, 0.5)
            attachElements(traffiCol, traffiObject, 0, - 0.85, 1)
            setElementData(traffiCol, "speedCamera", traffiObject)

            setElementData(traffiObject, "speedCameraCol", traffiCol)

            exports.seal_chat:localAction(sourcePlayer, "lerak egy lerakható traffipaxot.")
        end
    end
)

addEvent("removeCamera", true)
addEventHandler("removeCamera", getRootElement(),
    function(sourcePlayer, sourceSpeedCam)
        if sourceSpeedCam and isElement(sourceSpeedCam) then
            local speedCamCol = getElementData(sourceSpeedCam, "speedCameraCol")

            if speedCamCol and isElement(speedCamCol) then 
                destroyElement(speedCamCol)
            end

            exports.seal_chat:localAction(sourcePlayer, "felvesz egy lerakható traffipaxot.")
            destroyElement(sourceSpeedCam)
        end
    end
)

addEvent("speedCameraFine", true)
addEventHandler("speedCameraFine", getRootElement(),
    function(vehController, vehSpeed, speedLimit, occupantCount)
        if occupantCount and occupantCount > 1 then
            beltPayTax = occupantCount * 1.5
        end

        if vehController and vehSpeed and speedLimit then
            local speedTicket = math.ceil((math.floor(vehSpeed * 10) / 10 - speedLimit) * 5) * 5
            speedTicket = speedTicket
            if speedTicket > 0 then

                if speedTicket > 25000 then
                    speedTicket = 25000
                end
                
                setElementData(vehController, serverDatas.money, getElementData(vehController, serverDatas.money) - speedTicket)
                
                local policeGroupBalance = exports.seal_groups:getGroupBalance(1)

                if policeGroupBalance then
                    exports.seal_groups:setGroupBalance(1, policeGroupBalance + speedTicket)
                end

                if beltPayTax then
                    triggerClientEvent(vehController, "speedAlertFromServer", vehController, vehSpeed, speedLimit, formatNumber(speedTicket), occupantCount)
                    setElementData(vehController, serverDatas.money, getElementData(vehController, serverDatas.money) - beltPayTax)
                else
                    triggerClientEvent(vehController, "speedAlertFromServer", vehController, vehSpeed, speedLimit, formatNumber(speedTicket))
                end
            end
        end
    end
)


function formatNumber(amount) 
    local formatted = amount 
    while true do   
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
      if (k==0) then 
        break 
      end 
    end 
    return formatted 
  end 

  function getVehicleSpeed(vehicle)
	if isElement(vehicle) then
		local vx, vy, vz = getElementVelocity(vehicle)
		return math.floor(math.sqrt(vx*vx + vy*vy + vz*vz) * 187.5)
	end
end