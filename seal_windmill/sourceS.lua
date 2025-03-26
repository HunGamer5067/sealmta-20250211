local speeds = {}
for i = 1, 15 do
    speeds[i] = math.random(500, 1500)
end

addEvent("requestWindMillVelocity", true)
addEventHandler("requestWindMillVelocity", getRootElement(), function()
    triggerClientEvent("gotWindMillVelocity", source, 15)
end)