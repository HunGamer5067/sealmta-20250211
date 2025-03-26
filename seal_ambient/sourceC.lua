local soundsDay = {}
local soundsNight = {}
local soundsForest = {
	{-548.138671875, -105.306640625, 68.592590332031},
	{948.939453125, 4.59375, 90.130279541016},
	{215.064453125, -548.9580078125, 53.096832275391},
	{-2679.802734375, 2730.109375, 108.22838592529},
	{-1735.2744140625, 2555.578125, 104.81846618652},
	{-799.1416015625, 1104.6669921875, 45.144161224365},
	{-1455.6630859375, 1764.9912109375, 43.23722076416},
	{7299.966796875, 171.154296875, 113.75877380371},
	{7399.6416015625, -568.1650390625, 82.050048828125}
}

function processSounds()
	local currentHour, currentMinute = getTime()
	local currentTime = currentHour + currentMinute / 60

	local currentNightTime = 0

	if currentTime >= 19 then
		currentNightTime = math.min(1, (currentTime - 19) / 4)
	end

	if currentTime >= 7.5 then
		currentNightTime = 1 - math.min(1, math.max(0, (currentTime - 5) / 2.5))
	end

	for i = 1, #soundsForest do
		local forest = soundsForest[i]

		if forest then
			if currentNightTime < 1 then
				if not isElement(soundsDay[i]) then
					soundsDay[i] = playSound3D("files/sounds/forestday.wav", forest[1], forest[2], forest[3] + 20, true)

					if soundsDay[i] and isElement(soundsDay[i]) then
						setSoundMaxDistance(soundsDay[i], 1200)
					end
				end

				if soundsDay[i] and isElement(soundsDay[i]) then
					setSoundVolume(soundsDay[i], 1 - currentNightTime)
				end
			else
				if soundsDay[i] and isElement(soundsDay[i]) then
					destroyElement(soundsDay[i])
				end
				soundsDay[i] = nil
			end

			if currentNightTime > 0 then
				if not isElement(soundsNight[i]) then
					soundsNight[i] = playSound3D("files/sounds/forestnight.wav", forest[1], forest[2], forest[3] + 20, true)

					if soundsNight[i] and isElement(soundsNight[i]) then
						setSoundMaxDistance(soundsNight[i], 1200)
					end
				end

				if soundsNight[i] and isElement(soundsNight[i]) then
					setSoundVolume(soundsNight[i], currentNightTime * 1.75)
				end
			else
				if soundsNight[i] and isElement(soundsNight[i]) then
					destroyElement(soundsNight[i])
				end
				soundsNight[i] = nil
			end
		end
	end
end
processSounds()
setTimer(processSounds, 10000, 0)