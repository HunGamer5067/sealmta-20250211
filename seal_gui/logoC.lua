local insightlangStatImgHand = false
local insightlangStaticImage = {}
local insightlangStaticImageToc = {}
local insightlangStaticImageUsed = {}
local insightlangStaticImageDel = {}
local processinsightlangStaticImage = {}
insightlangStaticImageToc[0] = true
local insightlangStatImgPre
function insightlangStatImgPre()
	local now = getTickCount()
	if insightlangStaticImageUsed[0] then
		insightlangStaticImageUsed[0] = false
		insightlangStaticImageDel[0] = false
	elseif insightlangStaticImage[0] then
		if insightlangStaticImageDel[0] then
			if now >= insightlangStaticImageDel[0] then
				if isElement(insightlangStaticImage[0]) then
					destroyElement(insightlangStaticImage[0])
				end
				insightlangStaticImage[0] = nil
				insightlangStaticImageDel[0] = false
				insightlangStaticImageToc[0] = true
				return
			end
		else
			insightlangStaticImageDel[0] = now + 5000
		end
	else
		insightlangStaticImageToc[0] = true
	end
	if insightlangStaticImageToc[0] then
		insightlangStatImgHand = false
		removeEventHandler("onClientPreRender", getRootElement(), insightlangStatImgPre)
	end
end
processinsightlangStaticImage[0] = function()
	if not isElement(insightlangStaticImage[0]) then
		insightlangStaticImageToc[0] = false
		insightlangStaticImage[0] = dxCreateTexture("logo/astral/4.dds", "argb", true)
	end
	if not insightlangStatImgHand then
		insightlangStatImgHand = true
		addEventHandler("onClientPreRender", getRootElement(), insightlangStatImgPre, true, "high+999999999")
	end
end
local insightlangDynImgHand = false
local insightlangDynImgLatCr = falselocal
insightlangDynImage = {}
local insightlangDynImageForm = {}
local insightlangDynImageMip = {}
local insightlangDynImageUsed = {}
local insightlangDynImageDel = {}
local insightlangDynImgPre
function insightlangDynImgPre()
	local now = getTickCount()
	insightlangDynImgLatCr = true
	local rem = true
	for k in pairs(insightlangDynImage) do
		rem = false
		if insightlangDynImageDel[k] then
			if now >= insightlangDynImageDel[k] then
				if isElement(insightlangDynImage[k]) then
					destroyElement(insightlangDynImage[k])
				end
				insightlangDynImage[k] = nil
				insightlangDynImageForm[k] = nil
				insightlangDynImageMip[k] = nil
				insightlangDynImageDel[k] = nil
				break
			end
		elseif not insightlangDynImageUsed[k] then
			insightlangDynImageDel[k] = now + 5000
		end
	end
	for k in pairs(insightlangDynImageUsed) do
		if not insightlangDynImage[k] and insightlangDynImgLatCr then
			insightlangDynImgLatCr = false
			insightlangDynImage[k] = dxCreateTexture(k, insightlangDynImageForm[k], insightlangDynImageMip[k])
		end
		insightlangDynImageUsed[k] = nil
		insightlangDynImageDel[k] = nil
		rem = false
	end
	if rem then
		removeEventHandler("onClientPreRender", getRootElement(), insightlangDynImgPre)
		insightlangDynImgHand = false
	end
end
local function dynamicImage(img, form, mip)
	if not insightlangDynImgHand then
		insightlangDynImgHand = true
		addEventHandler("onClientPreRender", getRootElement(), insightlangDynImgPre, true, "high+999999999")
	end
	if not insightlangDynImage[img] then
		insightlangDynImage[img] = dxCreateTexture(img, form, mip)
	end
	insightlangDynImageForm[img] = form
	insightlangDynImageUsed[img] = true
	return insightlangDynImage[img]
end
function playLogoAnimation(el, animType, animationTime)
	if tonumber(el) and guiElements[el] then
		if guiElements[el].type == "logo" then
			guiElements[el].logoAnimationType = animType
			if animType == "in" then
				guiElements[el].logoAnimations = {
					{
						now + animationTime * 0,
						animationTime
					},
					{
						now + animationTime * 1,
						animationTime
					},
					{
						now + animationTime * 2,
						animationTime
					},
					{
						now + animationTime * 3,
						animationTime
					},
					{
						now + animationTime * 4,
						animationTime * 3
					}
				}
			elseif animType == "out" then
				guiElements[el].logoAnimations = {
					{now, animationTime},
					{now, animationTime},
					{now, animationTime},
					{now, animationTime},
					{
						now,
						animationTime * 2
					}
				}
			elseif animType == "in-inv" then
				guiElements[el].logoAnimations = {
					{
						now + animationTime * 4,
						animationTime
					},
					{
						now + animationTime * 3,
						animationTime
					},
					{
						now + animationTime * 2,
						animationTime
					},
					{
						now + animationTime * 1,
						animationTime
					},
					{
						now + animationTime * 0,
						animationTime
					}
				}
			elseif animType == "hexa" then
				guiElements[el].logoAnimations = {
					{
						now + animationTime * 0,
						animationTime
					},
					false,
					false,
					false,
					false
				}
			elseif animType == "hexa2" then
				guiElements[el].logoAnimations = {
					{now, 0},
					{
						now + animationTime * 0,
						animationTime
					},
					{
						now + animationTime * 1,
						animationTime
					},
					{
						now + animationTime * 2,
						animationTime
					},
					{
						now + animationTime * 3,
						animationTime * 3
					}
				}
			end
		else
			throwGuiError("playLogoAnimation: guiElement it not logo")
		end
	else
		throwGuiError("playLogoAnimation: invalid guiElement")
	end
end
function setLogoAnimated(el, animated)
	if tonumber(el) and guiElements[el] then
		if guiElements[el].type == "logo" then
			guiElements[el].animatedLogo = animated
		else
			throwGuiError("setLogoAnimated: guiElement it not logo")
		end
	else
		throwGuiError("setLogoAnimated: invalid guiElement")
	end
end
function renderFunctions.logo(el)
	local fadeAlpha = 1
	local backgroundColor = guiElements[el].background or tocolor(255, 255, 255, 255)
	if guiElements[el].fadeIn then
		local progress = getEasingValue(math.min(1, (now - guiElements[el].fadeIn) / guiElements[el].fadeInTime), "InOutQuad")
		fadeAlpha = progress
		guiElements[el].faded = false
		if 1 <= progress then
			guiElements[el].fadeIn = false
		end
	end
	if guiElements[el].fadeOut then
		local progress = 1 - getEasingValue(math.min(1, (now - guiElements[el].fadeOut) / guiElements[el].fadeOutTime), "InOutQuad")
		fadeAlpha = progress
		if progress <= 0 then
			guiElements[el].fadeOut = false
			guiElements[el].faded = true
		end
	end
	if guiElements[el].animatedLogo then
		if guiElements[el].logoAnimations then
			for k = 1, 5 do
				if guiElements[el].logoAnimations[k] then
					local progress = 1
					if 0 < guiElements[el].logoAnimations[k][2] then
						progress = math.min(math.max((now - guiElements[el].logoAnimations[k][1]) / guiElements[el].logoAnimations[k][2], 0), 1)
					end
					local alpha = 0
					local scale = 1.2
					if guiElements[el].logoAnimationType == "in" or guiElements[el].logoAnimationType == "hexa" or guiElements[el].logoAnimationType == "hexa2" then
						alpha, scale = interpolateBetween(0, 1.2, 0, 255, 1, 0, progress, "OutQuad")
					elseif guiElements[el].logoAnimationType == "out" or guiElements[el].logoAnimationType == "in-inv" then
						alpha, scale = interpolateBetween(255, 1, 0, 0, 1.2, 0, progress, "OutQuad")
					end
					dxDrawImage(guiElements[el].x - guiElements[el].sx / 2 * scale, guiElements[el].y - guiElements[el].sy / 2 * scale, guiElements[el].sx * scale, guiElements[el].sy * scale, dynamicImage("logo/astral/" .. k - 1 .. ".dds"), 0, 0, 0, bitReplace(backgroundColor, bitExtract(backgroundColor, 24, 8) * (alpha/255) * fadeAlpha, 24, 8))
				end
			end
		end
	else
		insightlangStaticImageUsed[0] = true
		if insightlangStaticImageToc[0] then
			processinsightlangStaticImage[0]()
		end
		dxDrawImage(guiElements[el].x - guiElements[el].sx / 2, guiElements[el].y - guiElements[el].sy / 2, guiElements[el].sx, guiElements[el].sy, insightlangStaticImage[0], 0, 0, 0, bitReplace(backgroundColor, bitExtract(backgroundColor, 24, 8) * fadeAlpha, 24, 8))
	end
end
