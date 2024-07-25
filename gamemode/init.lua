local BASEWARS_FOLDER = "basewars"
local CONFIG_PATH = BASEWARS_FOLDER .. "/basewars_config.json"

util.AddNetworkString("BaseWars:GamemodeConfigModified")
util.AddNetworkString("BaseWars:SendGamemodeConfigToClient")

do
    local count = 0
    local function addBaseWarsResource(path)
        local icons, folders = file.Find("gamemodes/basewars/content" .. path .. "*", "GAME")
        for k, v in ipairs(icons) do
            count = count + 1

            resource.AddFile(string.sub(path, 2) .. v)
        end

        for k, v in ipairs(folders) do
            if v == "echat" and not (file.Exists("autorun/echat_loader.lua", "LUA") and file.Exists("autorun/esc_loader.lua", "LUA")) then
                continue
            end

            addBaseWarsResource(path .. v .. "/")
        end
    end

    addBaseWarsResource("/")

    -- Workshop Addon
    resource.AddWorkshop("3265905462")

    hook.Add("BaseWars:Initialize", "BaseWars:AddResources", function()
        BaseWars:ServerLog(count .. " BaseWars icons")
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