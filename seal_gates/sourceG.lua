availableGates = {}
prisonGates = {
	[66] = true,
	[40] = true,
	[41] = true,
	[63] = true,
	[67] = true,
}

function getPrisonGateIDs()
	return prisonGates
end

function getGateDetails(gateID)
	return availableGates[gateID]
end