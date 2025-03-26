addEventHandler("onClientResourceStart", resourceRoot, function()



col=engineLoadCOL("ebeachap3_lae2.col")
engineReplaceCOL(col, 17560)

txd=engineLoadTXD("ebeachap3_lae2.txd")
engineImportTXD(txd, 17560) --ID de objeto a sustituir

dff=engineLoadDFF("ebeachap3_lae2.dff")
engineReplaceModel(dff, 17560, true)

engineSetModelLODDistance(17560, 700)



end)
