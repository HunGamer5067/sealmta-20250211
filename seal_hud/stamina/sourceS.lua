addEvent("tiredAnim", true)
addEventHandler("tiredAnim", getRootElement(), function(state)
    if state then
        setPedAnimation(client, "fat", "idle_tired", -1, true, false, true)
    elseif not state then
        setPedAnimation(client)
    end
end)