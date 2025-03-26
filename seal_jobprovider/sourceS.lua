addEvent("changeJobState", true)
addEventHandler("changeJobState", getRootElement(),
	function(jobId)
		if isElement(source) and client and client == source then
			if tonumber(jobId) then
				setElementData(client, "char.Job", jobId)

				if jobId > 0 then
					exports.seal_gui:showInfobox(client, "s", "Sikeresen felvetted a munkát.")
				else
					exports.seal_gui:showInfobox(client, "s", "Sikeresen felmondtál a munkahelyeden.")
				end
			end
		end
	end
)