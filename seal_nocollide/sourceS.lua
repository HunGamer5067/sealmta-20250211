function setElementCollisionsEnabled(el, state, timer, timerState)
    triggerClientEvent(getRootElement(), "setElementCollisionsEnabled", el, el, state, false)
    if timer then
        setTimer(setElementCollisionsEnabled, timer, 1, el, timerState)
    end
end
addEvent("setElementCollisionsEnabled", true)
addEventHandler("setElementCollisionsEnabled", getRootElement(),
    function(el, state)
        triggerClientEvent(getRootElement(), "setElementCollisionsEnabled", el, el, state, false)
    end
)