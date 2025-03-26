local channelsLoop = {}
local channels = {
    -- MANAGMENT
    ["connect-disconnect"] = {
        "https://discord.com/api/webhooks/1229871376274559147/vXxX33h5Cnc4yDhDEZl9sZQYsCXBg0fdoGlhVq-bPiS7YBl81kcVwSGZD1UMYYpt2Jud",
        "https://discord.com/api/webhooks/1229871378921164831/BVObJ0BAqaTN3aUidCMBNeR_i3aK0eFs7sSkUBz3KCZsMmiXcZ0x1psPNpBV76raR_E7",
        "https://discord.com/api/webhooks/1229871393689047062/yhQ1tFjCEH0z-iibtg1AvAvOLMaduly3RPK6roeiz7o9jzBgLnuubTyuO3jslQgKwfo2"
    },
    ["discord-uid"] = {
        "https://discord.com/api/webhooks/1229871675877621780/qDSJ1ztc1OLDHWiLGSapZCzx0-pOhT_bmAeQd2ZJ_kuS9d_csqblPrA-XARwkjlhhLNg",
        "https://discord.com/api/webhooks/1229871684954095666/aSL3Sy66HVp-_5FITcoat6yOQwMt_Ca-wIYdQuq3HFcvJ_u3aWLFzpz7MvLgr_La1REs",
        "https://discord.com/api/webhooks/1229871685554143302/aasZMl3MoZF6YtJAVGS0Vzfl4cqF-1-zIqVuDrSay_NXZ0fhn5F1mgV54IzbuQrQF1ts"
    },
    
    -- ADMIN
    ["connect-disconnect-admin"] = {
        "https://discord.com/api/webhooks/1229871921059987496/sNBXesQPmtzWpgb-Nxt7ipdITIEwBg0zMl1UaYd55cah-DHPieWQIizdqCyEDwtNgK43",
        "https://discord.com/api/webhooks/1229871924142673940/PiDySh4sAlUhlFWNzzb_AYob10MszxkeIdk5fZhOCIBmLm0QUpZhiilAKUwgR1GSWXc5",
        "https://discord.com/api/webhooks/1229871933923917896/GMl03MFqVmHswhQzzEEJf3xLfKe3XE8fAtpgaJCPufZvzQflTblEIC2pqU1nLP7WKfU5"
    },

    -- EXTRA
}

local function webhookCallback()
    return true
end

function sendWebhook(channel, content)
    if not channelsLoop[channel] then
        channelsLoop[channel] = 0
    end
    channelsLoop[channel] = channelsLoop[channel] + 1
    if channelsLoop[channel] > #channels[channel] then
        channelsLoop[channel] = 1
    end
    
    fetchRemote(channels[channel][channelsLoop[channel]], {formFields = {content = content}}, webhookCallback)
end 