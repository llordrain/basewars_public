util.AddNetworkString("BaseWars:Leaderboard:SendToClients")

local function requestLeaderboardData(func)
    local allData = {
        time_played = false,
        money = false,
        level = false,
        kills = false,
        deaths = false,
        message_sent = false,
        money_received = false,
        xp_received = false,
        session_count = false,
        kd = false
    }

    if BaseWars.Config.Prestige.Enable then
        allData["prestige"] = false
    end

    local function addDataFromResult(what, data)
        allData[what] = data

        for k, v in pairs(allData) do
            if v == false then
                return
            end
        end

        if isfunction(func) then
            func(allData)
        end
    end

    -- MARK: Time Played
    MySQLite.query([[
        WITH RankedPlayers AS (
            SELECT
                player_id64,
                time_played,
                ROW_NUMBER() OVER (PARTITION BY player_id64 ORDER BY time_played DESC, player_id64 ASC) AS rn
            FROM basewars_player
        )
        SELECT
            player_id64,
            time_played
        FROM RankedPlayers
        WHERE rn = 1
        ORDER BY time_played DESC
        LIMIT 30
    ]], function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                time_played = tonumber(v.time_played)
            }
        end

        addDataFromResult("time_played", result)
    end, BaseWarsSQLError)

    -- MARK: Money
    MySQLite.query([[
        WITH RankedPlayers AS (
            SELECT
                player_id64,
                CAST(money AS DECIMAL) AS money_number,
                ROW_NUMBER() OVER (PARTITION BY player_id64 ORDER BY CAST(money AS DECIMAL) DESC, player_id64 ASC) AS rn
            FROM basewars_player
        )
        SELECT
            player_id64,
            money_number
        FROM RankedPlayers
        WHERE rn = 1
        ORDER BY money_number DESC
        LIMIT 30
    ]], function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                money = tonumber(v.money_number),
            }
        end

        addDataFromResult("money", result)
    end, BaseWarsSQLError)

    -- MARK: Prestige
    if BaseWars.Config.Prestige.Enable then
        MySQLite.query([[
            WITH RankedPlayers AS (
                SELECT
                    player_id64,
                    prestige,
                    ROW_NUMBER() OVER (PARTITION BY player_id64 ORDER BY prestige DESC, player_id64 ASC) AS rn
                FROM basewars_prestige
            )
            SELECT
                player_id64,
                prestige
            FROM RankedPlayers
            WHERE rn = 1
            ORDER BY prestige DESC
            LIMIT 30
        ]], function(result)
            result = result or {}

            for k, v in ipairs(result) do
                result[k] = {
                    player_id64 = v.player_id64,
                    prestige = tonumber(v.prestige)
                }
            end

            addDataFromResult("prestige", result)
        end, BaseWarsSQLError)
    end

    -- MARK: Level
    MySQLite.query([[
        WITH RankedPlayers AS (
            SELECT
                player_id64,
                level,
                ROW_NUMBER() OVER (PARTITION BY player_id64 ORDER BY level DESC, player_id64 ASC) AS rn
            FROM basewars_player
        )
        SELECT
            player_id64,
            level
        FROM RankedPlayers
        WHERE rn = 1
        ORDER BY level DESC
        LIMIT 30
    ]], function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                level = tonumber(v.level)
            }
        end

        addDataFromResult("level", result)
    end, BaseWarsSQLError)

    -- MARK: kills
    MySQLite.query("SELECT player_id64, kills FROM basewars_player_stats ORDER BY kills DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                kills = tonumber(v.kills)
            }
        end

        addDataFromResult("kills", result)
    end, BaseWarsSQLError)

    -- MARK: deaths
    MySQLite.query("SELECT player_id64, deaths FROM basewars_player_stats ORDER BY deaths DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                deaths = tonumber(v.deaths)
            }
        end

        addDataFromResult("deaths", result)
    end, BaseWarsSQLError)

    -- MARK: message_sent
    MySQLite.query("SELECT player_id64, message_sent FROM basewars_player_stats ORDER BY message_sent DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                message_sent = tonumber(v.message_sent)
            }
        end

        addDataFromResult("message_sent", result)
    end, BaseWarsSQLError)

    -- MARK: money_received
    MySQLite.query("SELECT player_id64, CAST(money_taken AS DECIMAL) AS money_number FROM basewars_player_stats ORDER BY money_number DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                money_number = tonumber(v.money_number)
            }
        end

        addDataFromResult("money_received", result)
    end, BaseWarsSQLError)

    -- MARK: xp_received
    MySQLite.query("SELECT player_id64, CAST(xp_received AS DECIMAL) AS xp_number FROM basewars_player_stats ORDER BY xp_number DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                xp_number = tonumber(v.xp_number)
            }
        end

        addDataFromResult("xp_received", result)
    end, BaseWarsSQLError)

    -- MARK: session_count
    MySQLite.query("SELECT player_id64, play_count FROM basewars_player_stats ORDER BY play_count DESC, player_id64 ASC LIMIT 30", function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                play_count = tonumber(v.play_count)
            }
        end

        addDataFromResult("session_count", result)
    end, BaseWarsSQLError)

    -- MARK: KD Ratio
    MySQLite.query([[
        SELECT player_id64,
            CASE
                WHEN deaths = 0 THEN kills
                ELSE kills / CAST(deaths AS FLOAT)
            END AS kd
        FROM basewars_player_stats
        ORDER BY kd DESC
        LIMIT 30
    ]], function(result)
        result = result or {}

        for k, v in ipairs(result) do
            result[k] = {
                player_id64 = v.player_id64,
                kd = math.Round(v.kd, 2)
            }
        end

        addDataFromResult("kd", result)
    end, BaseWarsSQLError)
end

-- Updated every 60 secs
timer.Create("BaseWars.Leaderboard.SQL", 60, 0, function()
    requestLeaderboardData(function(data)
        local compressed = util.Compress(util.TableToJSON(data))

        net.Start("BaseWars:Leaderboard:SendToClients")
            net.WriteData(compressed, #compressed)
        net.Broadcast()

        if BaseWars.Config.Debug.Gamemode then
            BaseWars:ServerLog("Updating Leaderboard Data")
        end
    end)
end)

net.Receive("BaseWars:Leaderboard:SendToClients", function(len, ply)
    requestLeaderboardData(function(data)
        local compressed = util.Compress(util.TableToJSON(data))

        net.Start("BaseWars:Leaderboard:SendToClients")
            net.WriteData(compressed, #compressed)
        net.Send(ply)

        if BaseWars.Config.Debug.Gamemode then
            BaseWars:ServerLog(ply:Name() .. " is requesting leaderboard data for the first time")
        end
    end)
end)

BaseWars:AddConsoleCommand("bw_update_leaderboard", function(ply, args)
    requestLeaderboardData(function(data)
        local compressed = util.Compress(util.TableToJSON(data))

        net.Start("BaseWars:Leaderboard:SendToClients")
            net.WriteData(compressed, #compressed)
        net.Broadcast()

        if BaseWars.Config.Debug.Gamemode then
            BaseWars:ServerLog("Updating Leaderboard Data")
        end
    end)
end, false, BaseWars:GetSuperAminGroups())