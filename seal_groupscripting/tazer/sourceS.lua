addEvent("onTazerShoot", true)
addEventHandler("onTazerShoot", getRootElement(),
	function (targetPlayer, bodypart)
		if isElement(source) and isElement(targetPlayer) then
			local tazed = getElementData(targetPlayer, "tazed")

			if not tazed then
				local targetPlayerPos = {getElementPosition(targetPlayer)}
				local sourcePlayerPos = {getElementPosition(source)}
				local distance = getDistanceBetweenPoints3D(targetPlayerPos[1], targetPlayerPos[2], targetPlayerPos[3], sourcePlayerPos[1], sourcePlayerPos[2], sourcePlayerPos[3])
				
				if distance > 15 then
					return
				end

				if not exports.seal_items:hasItem(source, 15) then
					return
				end

				if isPedInVehicle(targetPlayer) then
					return
				end

				exports.seal_controls:toggleControl(targetPlayer, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, false)
				
				local block, anim = "ped", "FLOOR_hit_f"
				if bodypart == 9 then
					block, anim = "ped", "KO_shot_face"
				elseif bodypart == 8 then
					block, anim = "CRACK", "crckdeth2"
				elseif bodypart == 7 then
					block, anim = "CRACK", "crckdeth2"
				elseif bodypart == 6 then
					block, anim = "CRACK", "crckdeth2"
				elseif bodypart == 5 then
					block, anim = "CRACK", "crckdeth2"
				elseif bodypart == 4 then
					block, anim = "CRACK", "crckdeth3"
				elseif bodypart == 3 then
					block, anim = "ped", "KO_shot_stom"
				elseif bodypart == 2 then
					block, anim = "CRACK", "crckdeth2"
				elseif bodypart == 1 then
					block, anim = "CRACK", "crckdeth2"
				end

				setPedAnimation(targetPlayer, block, anim, -1, false, false, true)
				setElementData(targetPlayer, "tazed", true)
				fadeCamera(targetPlayer, false, 1, 255, 255, 255)

				setTimer(
					function(player)
						if isElement(player) then
							setPedAnimation(player, "FAT", "idle_tired", -1, true, false, false)
							fadeCamera(player, true, 1, 255, 255, 255)

							setTimer(
								function(player)
									if isElement(player) then
										exports.seal_controls:toggleControl(player, {"forwards", "backwards", "left", "right", "jump", "crouch", "aim_weapon", "fire", "enter_exit", "enter_passenger"}, true)
										setPedAnimation(player, false)
										--setCameraMatrix()
										setElementData(player, "tazed", false)
									end
								end,
							10000, 1, player)
						end
					end,
				20000, 1, targetPlayer)

				triggerClientEvent(targetPlayer, "playTazerSound", targetPlayer)

				local targetName = getElementData(targetPlayer, "visibleName"):gsub("_", " ")
				local playerName = getElementData(source, "visibleName"):gsub("_", " ")

				outputChatBox("#4adfbf[SealMTA]: #ffffffSikeresen lesokkoltad a kiválasztott játékost! #4adfbf(" .. targetName .. ")", source, 255, 255, 255, true)
				outputChatBox("#4adfbf[SealMTA]: #4adfbf" .. playerName .. " #fffffflesokkolt téged!", targetPlayer, 255, 255, 255, true)

				exports.seal_chat:localAction(source, "lesokkolt valakit. ((" .. targetName .. "))")
			end
		end
	end
)