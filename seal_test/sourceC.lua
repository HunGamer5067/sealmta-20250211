local type = "object"

addCommandHandler("testObjects", 
    function(_, type2)
        state = not state
        type = type2 or "object"
        outputChatBox(type)
    end
)

addEventHandler("onClientRender", getRootElement(),
    function()
        if not state then return end
        for k, v in pairs(getElementsByType(type), getRootElement(), true) do
            local x, y = getScreenFromWorldPosition(unpack({getElementPosition(v)}))
            if x and y then
                dxDrawText(getElementModel(v) or "NIL", x, y)
            end
        end
    end
)