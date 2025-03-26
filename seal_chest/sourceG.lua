goldItems = {
	[363] = true,
	[326] = true,
	[306] = true,
	[313] = true,
	[167] = true,
}

chestData = {
	[51] = 110,
	[52] = 110,
	[53] = 110,
	[373] = 110,

	[303] = 80,
	[302] = 80,
	[304] = 80,
	[305] = 80,

	[54] = 50,
	[55] = 50,
	[56] = 50,
	[57] = 50,
	[58] = 50,
	[59] = 50,
	[60] = 50,
	[61] = 50,
	[62] = 50,
	[63] = 50,
	[76] = 50,
	
	[363] = 15,

	[326] = 3,
	[306] = 3,
	[313] = 3,

	[167] = 1,
}

chestSum = 0

chestModel = {}
chestModel[443] = 8397

fakeDiv = {}
fakeDiv[436] = 100
fakeDiv[437] = 125
fakeDiv[442] = 125

for key, probability in pairs(chestData) do
    chestSum = chestSum + probability
end

fakeDiv = 100
fakeSantaSum = 0

for key, probability in pairs(chestData) do
    fakeSantaSum = fakeSantaSum + math.ceil(probability / fakeDiv)
end

function chooseRandomItem()
    local random = math.random(chestSum)
    local sum = 0
    for key, probability in pairs(chestData) do
        sum = sum + probability

        if random <= sum then
            return key
        end
    end

    return false
end

function chooseFakeItem()
    local random = math.random(fakeSantaSum)
    local sum = 0

    for key, probability in pairs(chestData) do
        prob = math.ceil(probability / fakeDiv)
        sum = sum + prob

        if random <= sum then
            return key
        end
    end

    return false
end
