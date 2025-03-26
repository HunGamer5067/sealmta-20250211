local messages = {
	{"Figyelj az éhség szintedre mert ha túl alacsony akkor a HP-d is csökkeni fog."},
	{"Az adminok listáját a dashboardban az 'adminok' fülben tekintheted meg."},
	{"A Prémium Panelt az 'F7' gomb lenyomásával nyithatod meg."},
	{"Bugot találtál? Jelezd egy adminisztrátornak, vagy a Discord szerverünkön! (discord.gg/SealMTA)"},
	{"Discord szerverünk: discord.gg/SealMTA"},
	{"Támogatni szeretnéd a szervert? Keresd fel a tulajdonost Discord szerverünkön! (discord.gg/SealMTA)"},
	{"Frakció igényléssel kapcsolatos információk: discord.gg/SealMTA"},
	{"Munkát felvenni/leadni a városházán tudsz."},
	{"A járműved ablakát 'F4' gomb lenyomásával tudod lehúzni/felhúzni."},	
	--{"Ki szeretnéd kapcsolni az időbélyeget a chaten? Használd a /togdate parancsot!"},	
}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setTimer(doMsg, 1000 * 60 * 60, 0)
		doMsg()
	end
)

local doTips = true

addCommandHandler("togtips",
	function ()
		if doTips then
			doTips = false
			outputChatBox("#4adfbf[SealMTA]: #ffffffKikapcsoltad a tippeket.", 255, 255, 255, true)
		else
			doTips = true
			outputChatBox("#4adfbf[SealMTA]: #ffffffBekapcsoltad a tippeket.", 255, 255, 255, true)
		end
	end)

function doMsg()
	if doTips then
		local message = messages[math.random(1, #messages)][1]
		if message then
			outputChatBox("#4adfbf[SealMTA - Segítség]: #ffffff" .. message, 255, 255, 255, true)
		end
	end
end

function doMsgDC()
	--outputChatBox("#4adfbf[SealMTA - Segítség]: #ffffff" .. "Discord szerverünk: https://discord.gg/BHs8G2ZPB4", 255, 255, 255, true)
end
addCommandHandler("dc", doMsgDC)
addCommandHandler("discord", doMsgDC)