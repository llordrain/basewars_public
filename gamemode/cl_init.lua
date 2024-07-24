local function addBaseWarsResource(path)
    local icons, folders = file.Find("materials/basewars_materials" .. path .. "*", "GAME")
    for k, v in ipairs(icons) do
        local index = path .. v

        BaseWars.Icons[string.sub(index, 2, #index - 4)] = Material("basewars_materials" .. path .. v, "smooth")
    end

    for k, v in ipairs(folders) do
        addBaseWarsResource(path .. v .. "/")
    end
end

include("shared.lua")

include("lang.lua")
include("themes.lua")

include("config/default_config.lua")

include("libraries/cami.lua")
include("libraries/cppi.lua")

include("player_class/player_basewars.lua")

BaseWars:LoadModules(function()
    BaseWars.Config = BaseWars.DefaultConfig -- Temporary while the client requests the real config from the server

    BaseWars.Icons = {}
    addBaseWarsResource("/")
end)

include("config/entities.lua")

hook.Run("BaseWars:Initialize")