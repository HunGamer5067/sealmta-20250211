--
-- c_main.lua
--
-- shader settings in fx/ssao_dl_settings.txt

local isDebugMode = false

local scx, scy = guiGetScreenSize()
local renderTarget = {RTNormal = nil, isOn = false}
aoShader = {shader = nil, colorRT = nil, enabled = false}

function enableAO()
	if aoShader.enabled then return end
	if renderTarget.isOn then
		aoShader.shader, tec = dxCreateShader( "fx/primitive3D_ssao_dl.fx" )
		if aoShader.shader and renderTarget.RTNormal then
			dxSetShaderValue( aoShader.shader, "sRTNormal", renderTarget.RTNormal )
		end
	else
		aoShader.shader, tec = dxCreateShader( "fx/primitive3D_ssao.fx" )		
	end
	aoShader.colorRT = dxCreateRenderTarget(scx, scy, false)
	isAllValid = true

		isAllValid = aoShader.shader and aoShader.colorRT
		if isAllValid then
			dxSetShaderValue( aoShader.shader, "fViewportSize", scx, scy )
			dxSetShaderValue( aoShader.shader, "sPixelSize", 1 / scx, 1 / scy )
			dxSetShaderValue( aoShader.shader, "sAspectRatio", scx / scy )
			dxSetShaderValue( aoShader.shader, "sRTColor", aoShader.colorRT )
			if isDebugMode then
				dxSetShaderValue( aoShader.shader, "fBlend", 5, 6 )
			else
				dxSetShaderValue( aoShader.shader, "fBlend", 1, 3 )	
			end
		end
    aoShader.enabled = isAllValid
end

function disableAO()
	if not aoShader.enabled then return end
	aoShader.enabled = false
	destroyElement(aoShader.shader)
	aoShader.shader = nil
	destroyElement(aoShader.colorRT)
	aoShader.colorRT = nil
end

local trianglestrip_quad = {{-1, -1, 0, 0, 0}, {-1, 1, 0, 0, 1}, {1, -1, 0, 1, 0}, {1, 1, 0, 1, 1}}

local cPosX, cPosY, cPosZ = getCameraMatrix()
addEventHandler("onClientPreRender", root, function()
	if aoShader.enabled then
		dxSetRenderTarget(aoShader.colorRT)
		dxSetRenderTarget()
		dxDrawMaterialPrimitive3D( "trianglestrip", aoShader.shader, false, unpack( trianglestrip_quad ) )
	end
end, true, "high+8" )

addEventHandler ( "onClientResourceStart", resourceRoot, function()
	renderTarget.isOn = getElementData ( localPlayer, "dl_core.on", false )
	if renderTarget.isOn then 
		_, renderTarget.RTNormal = exports.dl_core:getRenderTargets()
		if renderTarget.RTNormal then
			renderTarget.isOn = true
		end
	end
	triggerEvent( "onClientSwitchDetail", resourceRoot, true )
end
)
addEvent( "switchdl_core", true )
addEventHandler( "switchdl_core", root, function(isOn) switchDREffect("dl_core", isOn) end)

