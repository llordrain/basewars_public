BaseWars:AddConsoleCommand("bw_show_profile_selector", function(ply)
	if not IsValid(ply) then return end
	if ply:InRaid() then return end

	-- if CurTime() < (ply.profileChangeTime or 0) then
	-- 	BaseWars:Notify(ply, "#profileSelector_wait", NOTIFICATION_ERROR, 5, math.ceil(ply.profileChangeTime - CurTime()))
	-- 	return
	-- end

	ply.oldBasewarsProfileID = ply.basewarsProfileID
	ply.basewarsProfileID = nil

	BaseWars:PlayerRequestProfilesData(ply)
end, false)

BaseWars:AddConsoleCommand("bw_delete_profile", function(ply, args)
	local profileID = tonumber(args[1])
	if not profileID then
		BaseWars:Warning("Missing Argument")
		return
	end

	MySQLite.query("SELECT * FROM basewars_player WHERE profile_id = " .. profileID, function(result)
		if not result then
			BaseWars:Warning("Profile #" .. profileID .. " doesn't exists")
			return
		end

		MySQLite.query("DELETE FROM basewars_player WHERE profile_id = " .. profileID, function()
			BaseWars:Log("Successfully deleted profile in basewars_player")

			for k, v in ipairs(player.GetHumans()) do
				if result[1].player_id64 == v:SteamID64() and (not v.basewarsProfileID or v.basewarsProfileID == profileID) then
					v.oldBasewarsProfileID = nil
					v.basewarsProfileID = nil

					BaseWars:PlayerRequestProfilesData(v)

					break
				end
			end
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_prestige WHERE profile_id = " .. profileID, function()
			BaseWars:Log("Successfully deleted profile in basewars_prestige")
		end, BaseWarsSQLError)
	end, BaseWarsSQLError)
end, true)

local profileColor = Color(255, 136, 0)
BaseWars:AddConsoleCommand("bw_show_profiles", function(ply, args)
	local target = args[1]
	if not target then
		BaseWars:Warning("Player Not Found")
		return
	end

	MySQLite.query("SELECT * FROM basewars_player WHERE player_id64 = " .. target, function(basewarsResult)
		basewarsResult = basewarsResult or {}

		for index, pData in ipairs(basewarsResult) do
			for k, v in pairs(pData) do
				if k == "xp" then
					basewarsResult[index].xp = v == "inf" and math.huge or tonumber(v)
				end

				if k == "money" then
					basewarsResult[index].money = v == "inf" and math.huge or tonumber(v)
				end
			end
		end

		MySQLite.query("SELECT * FROM basewars_prestige WHERE player_id64 = " .. target, function(prestigeResult)
			prestigeResult = prestigeResult or {}

			for k, v in ipairs(prestigeResult) do
				for i, j in pairs(basewarsResult) do
					if v.profile_id == j.profile_id then
						basewarsResult[i].perks = v.perks
						basewarsResult[i].prestige = v.prestige
						basewarsResult[i].point = v.point
					end
				end
			end

			BaseWars:RequestSteamName(target, function(targetName)
				MsgC(profileColor, "Profiles of " .. targetName, "\n")
				for k, v in ipairs(basewarsResult) do
					local title = "----------[Profile #" .. k .. "]----------"
					local len = #title

					MsgC(profileColor, title, "\n")
					MsgC(profileColor, "Money: ", color_white, BaseWars:FormatMoney(v.money), "\n")
					MsgC(profileColor, "Level: ", color_white, BaseWars:FormatNumber(v.level), "\n")
					MsgC(profileColor, "XP: ", color_white, BaseWars:FormatNumber(v.xp), "\n")
					MsgC(profileColor, "Time Played: ", color_white, BaseWars:FormatTime2(v.time_played), "\n")
					MsgC(profileColor, "Prestige: ", color_white, BaseWars:FormatNumber(v.prestige), "\n")
					MsgC(profileColor, "ProfileID: ", color_white, string.Comma(v.profile_id), "\n")

					if k == #basewarsResult then
						MsgC(profileColor, string.rep("-", len), "\n")
					end
				end
			end)
		end, BaseWarsSQLError)
	end, BaseWarsSQLError)
end, true)