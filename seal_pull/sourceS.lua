addEvent("togDriveby", true)
addEventHandler("togDriveby", getRootElement(),
    function(state)
        if client and client == source then
            setPedDoingGangDriveby(source, state)
        end
    end
)