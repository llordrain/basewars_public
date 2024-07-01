local BASEWARS_FOLDER = "basewars"
local CONFIG_PATH = BASEWARS_FOLDER .. "/basewars_config.json"

util.AddNetworkString("BaseWars:GamemodeConfigModified")
util.AddNetworkString("BaseWars:SendGamemodeConfigToClient")

resource.AddWorkshop("2905302365")

do
    local BASEWARS_ICONS_PATH = "materials/basewars_materials"
    local ECHAT_ICONS_PATH = "materials/echat/emoji"

    local emojiCount = 0
    local emojis, _ = file.Find("gamemodes/basewars/content/" .. ECHAT_ICONS_PATH .. "/*", "GAME")
    for k, v in ipairs(emojis) do
        emojiCount = emojiCount + 1
        resource.AddFile(ECHAT_ICONS_PATH .. "/" .. v)
    end

    local count = 0
    local function addBaseWarsIcon(path)
        local icons, folders = file.Find("gamemodes/basewars/content/" .. BASEWARS_ICONS_PATH .. path .. "*", "GAME")
        for k, v in ipairs(icons) do
            count = count + 1
            resource.AddFile(BASEWARS_ICONS_PATH .. "/" .. v)
        end

        for k, v in ipairs(folders) do
            addBaseWarsIcon(path .. v .. "/")
        end
    end

    addBaseWarsIcon("/")

    resource.AddFile("resource/KodeMono Medium.ttf")
    resource.AddFile("resource/Montserrat Medium.ttf")

    resource.AddFile("sound/bw_button.wav")
    resource.AddFile("sound/bw_notification.wav")

    hook.Add("BaseWars:Initialize", "BaseWars:AddResources", function()
        BaseWars:ServerLog(count .. " BaseWars icons")
        BaseWars:ServerLog(emojiCount .. " custom EChat emojis")
    end)
end

AddCSLuaFile("shared.lua")
include("shared.lua")

AddCSLuaFile("lang.lua")
AddCSLuaFile("themes.lua")

AddCSLuaFile("config/default_config.lua")
AddCSLuaFile("config/entities.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("libraries/cami.lua")
AddCSLuaFile("libraries/cppi.lua")
AddCSLuaFile("libraries/material-avatar.lua")

include("config/MySQL.lua")

include("libraries/mysql.lua")
include("libraries/cami.lua")
include("libraries/cppi.lua")

include("player_class/player_basewars.lua")

include("lang.lua")
include("config/default_config.lua")

BaseWars:LoadModules(function()
    if not file.IsDir(BASEWARS_FOLDER .. "/", "DATA") then
        file.CreateDir(BASEWARS_FOLDER .. "/")
    end

    local defaultConfig, config = BaseWars.DefaultConfig, BaseWars.DefaultConfig
    if not file.Exists(CONFIG_PATH, "DATA") then
        file.Write(CONFIG_PATH, util.TableToJSON(defaultConfig, true))
    else
        config = util.JSONToTable(file.Read(CONFIG_PATH, "DATA"))

        -- TODO: Redo that shit
        -- Lookup for missing configs
        for k, v in pairs(defaultConfig) do
            if config[k] == nil then
                config[k] = v
            end
        end

        for k, v in pairs(config) do
            if defaultConfig[k] == nil then
                config[k] = nil
            end
        end
    end

    BaseWars.Config = config
end)

include("config/entities.lua")

MySQLite.initialize()

hook.Run("BaseWars:Initialize")