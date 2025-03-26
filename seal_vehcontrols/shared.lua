-- Configurações compartilhadas

config = {
    soundMaxDistance = 60,
    soundVolume = 0.5,
    keyToggleEngine = "j",
    keyToggleLock = "k",
    keyToggleLights = "l",
    defaultDelay = 500,
    soundProperties = {}
}

-- Definido apenas para fins de referência compartilhada
function setSoundProperties(properties)
    config.soundProperties = properties
end