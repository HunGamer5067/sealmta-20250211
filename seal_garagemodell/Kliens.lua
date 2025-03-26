addEventHandler("onClientResourceStart", root,
	function ()
		engineSetAsynchronousLoading(true, true)
		setOcclusionsEnabled(false)

		removeWorldModel(5681 ,10000, 0, 0, 0) -- Autómosó délin
		removeWorldModel(1676, 10000, 0, 0, 0) -- Felrobbantható benyakút
		removeWorldModel(14797, 2000, 618.66900634766, -118.34663391113, 999.3671875, 3) -- Kis Garázs Model Hiba
	end
)

addEventHandler("onClientElementDimensionChange", localPlayer,
	function ()
		engineSetAsynchronousLoading(true, true)
		setOcclusionsEnabled(false)

		removeWorldModel(5681 ,10000, 0, 0, 0) -- Autómosó délin
		removeWorldModel(1676, 10000, 0, 0, 0) -- Felrobbantható benyakút
		removeWorldModel(14797, 2000, 618.66900634766, -118.34663391113, 999.3671875, getElementInterior(localPlayer)) -- Kis Garázs Model Hiba
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function ()
		loadMod("small", 14798) -- Kis garázs
		loadMod("med", 14776) -- Közepes garázs
		loadMod("big", 14795) -- Nagy garázs
		loadMod("letter", 8583) -- Nagy garázs
		loadMod("elfmodel", 1669) -- Nagy garázs
	end
)

function loadMod(f, m, isLod)
	local txdFile = "models/" .. f .. ".txd"
	local dffFile = "models/" .. f .. ".dff"
	local colFile = "models/" .. f .. ".col"

	if fileExists(txdFile) then
		local txd = EngineTXD(txdFile)
		if txd then
			txd:import(m)
		end
	end

	if fileExists(dffFile) then
		local dff = EngineDFF(dffFile,m)
		if dff then
			dff:replace(m)
		end
	end

	if not isLod then
		if fileExists(colFile) then
			local col = EngineCOL(colFile)
			if col then
				col:replace(m)
			end
		end
	end
end