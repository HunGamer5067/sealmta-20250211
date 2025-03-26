screenX, screenY = guiGetScreenSize()

-- the efect settings
local colorizePed = {50 / 255, 179 / 255, 239 / 255, 1} -- rgba colors 
local specularPower = 1.3
local effectMaxDistance = 10
local isPostAura = true

-- don't touch
local scx, scy = guiGetScreenSize ()
local effectOn = nil
local myRT = nil
local myShader = nil
local isMRTEnabled = false
local outlineEffect = {}
local PWTimerUpdate = 110

-----------------------------------------------------------------------------------
-- enable/disable
-----------------------------------------------------------------------------------
function enableOutline(isMRT)
end

function disableOutline()
end


-----------------------------------------------------------------------------------
-- create/destroy per player
-----------------------------------------------------------------------------------
function createElementOutlineEffect(element, isMRT)
end

function destroyElementOutlineEffect(element)
end


-----------------------------------------------------------------------------------
-- onClientPreRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientPreRender", root,
    function()
    end
, true, "high" )


-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientHUDRender", root,
    function()
    end
)
--[[]]
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
	end
)

--------------------------------
-- Switch effect on or off
--------------------------------
function switchOutline(pwOn, isMRT)
end

addEvent("switchOutline", true)
addEventHandler("switchOutline", resourceRoot, switchOutline)