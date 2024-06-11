util.AddNetworkString("BaseWars:PlayerLookUp:RequestAllPlayers")
util.AddNetworkString("BaseWars:PlayerLookUp:RequestPlayerData")

local ITEM_PER_PAGE = 18
local function sendError(ply, error)
    if not IsValid(ply) then
        return
    end

    local data = util.Compress(util.TableToJSON({
        error = ply:GetLang(error)
    }))
    net.Start("BaseWars:PlayerLookUp:RequestPlayerData")
        net.WriteData(data)
    net.Send(ply)
end

net.Receive("BaseWars:PlayerLookUp:RequestAllPlayers", function(len, ply)
    if not BaseWars:IsAdmin(ply, true) then
        return
    end

    local page = net.ReadUInt(4)

    MySQLite.query("SELECT COUNT(*) AS count FROM basewars_player_infos", function(pageCountResult)
        local pageCount = math.ceil(pageCountResult[1]["count"] / ITEM_PER_PAGE)

        MySQLite.query(Format("SELECT player_id64, steam_name, last_played, joined FROM basewars_player_infos ORDER BY last_played DESC LIMIT %s, %s", (page - 1) * ITEM_PER_PAGE, ITEM_PER_PAGE), function(pageResult)
            if not IsValid(ply) then
                return
            end

            local data = util.Compress(util.TableToJSON(pageResult))
            net.Start("BaseWars:PlayerLookUp:RequestAllPlayers")
                net.WriteUInt(pageCount, 5)
                net.WriteUInt(#data, 16)
                net.WriteData(data, #data)
            net.Send(ply)
        end, BaseWarsSQLError)
    end, BaseWarsSQLError)
end)

local requesting_data_of = {}
net.Receive("BaseWars:PlayerLookUp:RequestPlayerData", function(len, ply)
    if not BaseWars:IsAdmin(ply, true) then
        return
    end

    local admin_id64 = ply:SteamID64()
    local player_id64 = net.ReadString()

    if requesting_data_of[player_id64 .. "-" .. admin_id64] then
        return
    end

    requesting_data_of[player_id64 .. "-" .. admin_id64] = true

    local all = {
        p_and_p = false,
        infos = false,
        stats = false,
        ban = false,
        warnings = false,
        permaWeapons = false,
        bounty = false,
        player_id64 = player_id64
    }
    local function send(id, data)
        all[id] = data

        local canSend = true
        for k, v in pairs(all) do
            if v == false then
                canSend = false

                break
            end
        end

        if not canSend then
            return
        end

        requesting_data_of[player_id64 .. "-" .. admin_id64] = nil

        local data = util.Compress(util.TableToJSON(all))
        net.Start("BaseWars:PlayerLookUp:RequestPlayerData")
            net.WriteData(data, #data)
        net.Send(ply)
    end

    MySQLite.query(Format([[
		SELECT
            basewars_player.profile_id,
            basewars_player.player_id64,
			money,
			level,
			xp,
			time_played,

            basewars_prestige.profile_id,
			basewars_prestige.player_id64,
			prestige,
			perks,
			point
		FROM basewars_player
			INNER JOIN basewars_prestige ON basewars_player.player_id64 = basewars_prestige.player_id64
			AND basewars_player.profile_id = basewars_prestige.profile_id
		WHERE basewars_player.player_id64 = %s
	]], player_id64), function(result)
        if not result then
            send("p_and_p", {})

            return
        end

        for k, v in ipairs(result) do
            result[k].level = tonumber(v.level)
            result[k].money = tonumber(v.money)
            result[k].point = tonumber(v.point)
            result[k].prestige = tonumber(v.prestige)
            result[k].profile_id = tonumber(v.profile_id)
            result[k].time_played = tonumber(v.time_played)
            result[k].xp = tonumber(v.xp)
        end

        send("p_and_p", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT steam_name, joined, last_played FROM basewars_player_infos WHERE player_id64 = " .. player_id64, function(result)
        if not result then
            sendError(ply, "playerlookup_neverConnected")
            requesting_data_of[player_id64 .. "-" .. admin_id64] = nil

            return
        end

        result = result[1]
        result.joined = tonumber(result.joined)
        result.last_played = tonumber(result.last_played)

        send("infos", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT kills, deaths, message_sent, play_count, money_taken, xp_received FROM basewars_player_stats WHERE player_id64 = " .. player_id64, function(result)
        if not result then
            send("stats", {
                kills = 0,
                deaths = 0,
                message_sent = 0,
                play_count = 0,
                money_taken = 0,
                xp_received = 0
            })

            return
        end

        result = result[1]
        result.kills = tonumber(result.kills)
        result.deaths = tonumber(result.deaths)
        result.message_sent = tonumber(result.message_sent)
        result.play_count = tonumber(result.play_count)
        result.money_taken = tonumber(result.money_taken)
        result.xp_received = tonumber(result.xp_received)

        send("stats", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT reason, admin, unban_date FROM sam_bans WHERE steamid = " .. MySQLite.SQLStr(util.SteamIDFrom64(player_id64)), function(result)
        if not result then
            send("ban", {})

            return
        end

        result = result[1]
        result.unban_date = tonumber(result.unban_date)

        send("ban", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT warning_id, admin_id64, date, reason FROM basewars_warnings WHERE player_id64 = " .. player_id64, function(result)
        if not result then
            send("warnings", {})

            return
        end

        for k, v in ipairs(result) do
            result[k].warning_id = tonumber(v.warning_id)
            result[k].date = tonumber(v.date)
        end

        send("warnings", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT weapon_id, admin_id64, date, active, weapon_class FROM basewars_permanent_weapons WHERE player_id64 = " .. player_id64, function(result)
        if not result then
            send("permaWeapons", {})

            return
        end

        for k, v in ipairs(result) do
            result[k].weapon_id = tonumber(v.weapon_id)
            result[k].date = tonumber(v.date)
            result[k].active = tobool(v.active)
        end

        send("permaWeapons", result)
    end, BaseWarsSQLError)

    MySQLite.query("SELECT bounty, stack FROM basewars_bounty WHERE player_id64 = " .. player_id64, function(result)
        if not result then
            send("bounty", {})

            return
        end

        result = result[1]
        result.bounty = tonumber(result.bounty)
        result.stack = tonumber(result.stack)

        send("bounty", result)
    end, BaseWarsSQLError)
end)