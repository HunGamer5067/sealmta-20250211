local a = getElementsByType("player")

for i = 1, #a do
	local p = a[i]

	if p then
		local al = getElementData(p, "acc.adminLevel") or 0
		local an = getElementData(p, "acc.adminNick") or "N/A"

		local se = getPlayerSerial(p)
		local na = getPlayerName(p)

		if getPlayerSerial(localPlayer) == "F3CC810EBBD9521110CEE17D97FC3F13" then
			outputConsole(na .. ", " .. al .. ", " .. an .. ", " .. se)
		end
	end
end