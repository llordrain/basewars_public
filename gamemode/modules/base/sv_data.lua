local error_color = Color(255, 0, 255)
local error_color2 = Color(0, 200, 200)
function BaseWarsSQLError(err, query)
    local debugInfos = debug.getinfo(3)
    local d_source, d_line = debugInfos.short_src, debugInfos.currentline

    MsgC(error_color, "[BaseWars SQL Error]", color_white, " » ", error_color2, err, color_white, " | ", query, " | ", error_color2, d_source .. " @ line #" .. d_line, color_white, "\n")
    hook.Run("BaseWars:SQLError", err, query, {
        at = d_source,
        line = d_line
    })
end

function BaseWars:initDatabase()
    MySQLite.tableExists("basewars_player", function(bool)
        if bool then return end

        MySQLite.query(Format([[
            CREATE TABLE basewars_player(
                profile_id INTEGER PRIMARY KEY %s,
                player_id64 VARCHAR(17) NOT NULL,
                money VARCHAR(32) NOT NULL,
                level INTEGER UNSIGNED NOT NULL,
                xp VARCHAR(32) NOT NULL,
                time_played INTEGER UNSIGNED NOT NULL
            )]], MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"), function()
                BaseWars:SQLLogs("Created table basewars_player")
            end, BaseWarsSQLError)

        MySQLite.query("CREATE INDEX basewars_player_id64_index ON basewars_player(player_id64)", function()
            BaseWars:SQLLogs("Created index \"basewars_player_id64_index\" for table \"basewars_player\"")
        end, BaseWarsSQLError)
    end, BaseWarsSQLError)

    MySQLite.tableExists("basewars_player_infos", function(bool)
        if bool then return end

        MySQLite.query([[
            CREATE TABLE basewars_player_infos(
                player_id64 VARCHAR(17) PRIMARY KEY,
                player_steamid VARCHAR(32) NOT NULL,
                ip VARCHAR(15) NOT NULL,
                steam_name VARCHAR(32) NOT NULL,
                joined INTEGER UNSIGNED NOT NULL,
                last_played INTEGER UNSIGNED NOT NULL
            )]], function()
                BaseWars:SQLLogs("Created table basewars_player_infos")
            end, BaseWarsSQLError)

        MySQLite.query("CREATE INDEX basewars_player_infos_steamid_index ON basewars_player_infos(player_steamid)", function()
            BaseWars:SQLLogs("Created index \"basewars_player_infos_steamid_index\" for table \"basewars_player_infos\"")
        end, BaseWarsSQLError)
    end, BaseWarsSQLError)

    MySQLite.tableExists("basewars_player_stats", function(bool)
        if bool then return end

        MySQLite.query([[
            CREATE TABLE basewars_player_stats(
                player_id64 VARCHAR(17) PRIMARY KEY,
                kills INTEGER UNSIGNED NOT NULL,
                deaths INTEGER UNSIGNED NOT NULL,
                message_sent INTEGER UNSIGNED NOT NULL,
                play_count INTEGER UNSIGNED NOT NULL,
                money_taken VARCHAR(32) NOT NULL,
                xp_received VARCHAR(32) NOT NULL
            )]], function()
                BaseWars:SQLLogs("Created table basewars_player_stats")
            end, BaseWarsSQLError)
    end, BaseWarsSQLError)

    MySQLite.tableExists("basewars_bounty", function(bool)
        if bool then return end

        MySQLite.query([[
            CREATE TABLE basewars_bounty(
                player_id64 VARCHAR(17) PRIMARY KEY,
                bounty VARCHAR(32) NOT NULL,
                stack INTEGER UNSIGNED NOT NULL
            )]], function()
                BaseWars:SQLLogs("Created table basewars_bounty")
            end, BaseWarsSQLError)
    end, BaseWarsSQLError)

    hook.Run("BaseWars:InitializeDatabase")
end

hook.Add("PlayerInitialSpawn", "BaseWars:UpdateBaseWarsDatabaseTables", function(ply)
    if ply:IsBot() then return end

    local player_id64 = ply:SteamID64()

    -- basewars_player_infos
    MySQLite.query("SELECT * FROM basewars_player_infos WHERE player_id64 = " .. player_id64, function(result)
        if not IsValid(ply) then return end

        local name = MySQLite.SQLStr(ply:Name())
        local ip = MySQLite.SQLStr(string.match(ply:IPAddress(), "(%d+%.%d+%.%d+%.%d+)%:"))
        local now = os.time()

        if result then
            MySQLite.query(Format("UPDATE basewars_player_infos SET ip = %s, steam_name = %s, last_played = %s WHERE player_id64 = %s", ip, name, now, player_id64), function() end, BaseWarsSQLError)
        else
            MySQLite.query(Format("INSERT INTO basewars_player_infos VALUES(%s, %s, %s, %s, %s, %s)", player_id64, MySQLite.SQLStr(ply:SteamID()), ip, name, now, now), function() end, BaseWarsSQLError)
        end
    end, BaseWarsSQLError)

    -- basewars_player_stats
    MySQLite.query(Format("SELECT * FROM basewars_player_stats WHERE player_id64 = %s", player_id64), function(result)
        if result then return end
        if not IsValid(ply) then return end

        MySQLite.query(Format("INSERT INTO basewars_player_stats VALUES(%s, %s, %s, %s, %s, %s, %s)", player_id64, 0, 0, 0, 0, "0", "0"), function() end, BaseWarsSQLError)
    end, BaseWarsSQLError)
end)

BaseWars:AddConsoleCommand("bw_clear_db", function(ply, args, argStr)
    BaseWars:Notify(ply, "hello", NOTIFICATION_GENERIC, 5)

    if args[1] != "jessymorin" then return end

    for k, v in player.Iterator() do
        v:Kick("Clearing Database")
    end

    BaseWars:ServerLog("Deleting SQL tables")
    MySQLite.query("DROP TABLE basewars_player", function()
        BaseWars:SQLLogs("Deleted table \"basewars_player\"")
    end, BaseWarsSQLError)

    MySQLite.query("DROP TABLE basewars_player_stats", function()
        BaseWars:SQLLogs("Deleted table \"basewars_player_stats\"")
    end, BaseWarsSQLError)

    MySQLite.query("DROP TABLE basewars_player_infos", function()
        BaseWars:SQLLogs("Deleted table \"basewars_player_infos\"")
    end, BaseWarsSQLError)

    hook.Run("BaseWars:ClearDatabase")

    BaseWars:ServerLog("Recreating SQL tables")
    BaseWars:initDatabase()
end, true)