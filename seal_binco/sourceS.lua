addEvent("bincoBuy", true)
addEventHandler("bincoBuy", getRootElement(),
	function (buyPrice, skinId)
		if isElement(source) and client and client == source then
			if buyPrice and skinId then
				if exports.seal_core:takeMoneyEx(client, buyPrice, "bincoBuy") then
					setElementModel(client, skinId);
					setElementData(client, "char.Skin", skinId);
					triggerClientEvent(client, "bincoBuy", client, skinId);
				else
					exports.seal_accounts:showInfo(client, "e", "Nincs elég pénzed!");
				end
			end
		end
	end
)

addEvent("setPlayerDimensionForBinco", true)
addEventHandler("setPlayerDimensionForBinco", getRootElement(),
	function(dimension)
		if isElement(source) and client and client == source then
			if dimension then
				setElementDimension(source, dimension)
			end
		end
	end
)