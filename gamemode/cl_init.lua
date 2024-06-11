include("shared.lua")

include("lang.lua")
include("themes.lua")

include("config/default_config.lua")

include("libraries/cami.lua")
include("libraries/cppi.lua")

include("player_class/player_basewars.lua")

BaseWars:LoadModules(function()
    BaseWars.Config = BaseWars.DefaultConfig -- Temporary while the client request the real config from the server
end)

include("config/entities.lua")

hook.Run("BaseWars:Initialize")