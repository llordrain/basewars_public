util.AddNetworkString("BaseWars:SendPlayerConfig")
util.AddNetworkString("BaseWars:OpenSpawnpointMenu")
util.AddNetworkString("BaseWars:PlayerReadyToReceiveNets")

--[[-------------------------------------------------------------------------
	MARK: PLAYER Functions
---------------------------------------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:SetAFKTime(time)
	self:SetNWFloat("BaseWar.AFKTime", time or 0)
end

function PLAYER:SetSafeZone(bool)
    self:SetNWBool("BaseWars.SafeZone", bool or false)
end

--[[-------------------------------------------------------------------------
	MARK: Local Functions
---------------------------------------------------------------------------]]
local function LimitReachedProcess(ply, str)
	if not IsValid(ply) then
		return true
	end

	return ply:CheckLimit(str)
end

--[[-------------------------------------------------------------------------
	MARK: GM:CanPlayerUnfreeze()
---------------------------------------------------------------------------]]
function GM:CanPlayerUnfreeze(ply, ent, phys)
	BaseWars:Warning(ply, ent, phys)

	if ply:InRaid() then
		return false
	end

	if (ent.IsExplosive or ent.IsMine) and ent:GetArmed() and not BaseWars.Config.PhysGunExplosive then
		return false
	end

	local entityClass = ent:GetClass()
	if BaseWars.Config.PhysgunPickupBlocked[entityClass] or string.find(entityClass, "func") or string.find(entityClass, "door") then
		return false
	end

	local entityOwner = ent:CPPIGetOwner()
	if entityOwner != ply then
		return BaseWars:IsAdmin(ply, true)
	end

	return true
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerSay()
---------------------------------------------------------------------------]]
function GM:PlayerSay(ply, text, teamonly)
	text = string.Trim(text) or ""

	local lower = string.lower(text)
	local found = string.find(lower, " ")
	local commandPrefix = BaseWars.Config.ChatCommandPrefix

	if lower[1] == "!" then
		local mistakeCommand = string.sub(lower, 2, found and found - 1 or #lower)

		if BaseWars:GetChatCommands(mistakeCommand) then
			BaseWars:ChatNotify(ply, "#commands_wrongPrefix", commandPrefix .. mistakeCommand)
			return ""
		end
	end

	if string.Left(lower, #commandPrefix) == commandPrefix then
		local command = string.sub(lower, 2, found and found - 1 or #lower)
		local commandData = BaseWars:GetChatCommands(command)

		if not commandData then
			BaseWars:ChatNotify(ply, "#commands_commandDontExist", commandPrefix .. command)
			return ""
		end

		if commandData.rank and not (commandData.rank[ply:GetUserGroup()] or BaseWars:IsSuperAdmin(ply)) then
			return text
		end

		if isfunction(commandData.func) then
			local b = string.sub(text, #command + #commandPrefix + 2)
			local args = #text == #command + 1 and {} or string.Explode(" ", b)

			commandData.func(ply, args)
			hook.Run("BaseWars:ChatCommand", ply, command, args, text, lower)
		else
			BaseWars:Warning("No func for chat command: " .. tostring(command))
		end

		return ""
	end

	MySQLite.query("UPDATE basewars_player_stats SET message_sent = message_sent + 1 WHERE player_id64 = " .. ply:SteamID64(), function() end, BaseWarsSQLError)

	return text
end

--[[-------------------------------------------------------------------------
    MARK: Player SPawning

	GM:PlayerSpawn()
	GM:PlayerInitialSpawn()
---------------------------------------------------------------------------]]
function GM:PlayerInitialSpawn(ply)
	MySQLite.query(Format("UPDATE basewars_player_stats SET play_count = play_count + 1 WHERE player_id64 = %s", ply:SteamID64()), function() end, BaseWarsSQLError)

	ply:SetTeam(1)
	ply:SetAFKTime(CurTime())

	ply.basewarsShopCooldowns = {}
	for k, v in pairs(BaseWars:GetBaseWarsEntity()) do
		ply.basewarsShopCooldowns[k] = 0
	end

	timer.Create("BaseWars.TimePlay." .. ply:SteamID64(), 1, 0, function()
		if not (IsValid(ply) and ply:IsPlayer()) or not ply.basewarsProfileID then return end
		ply:SetTimePlayed(ply:GetTimePlayed() + 1)
	end)
end

function GM:PlayerSpawn(ply, transition)
	ply:UnSpectate()

	player_manager.SetPlayerClass(ply, "player_basewars")

	player_manager.OnPlayerSpawn(ply, transiton)
	player_manager.RunClass(ply, "Spawn")

	if not transiton then
		hook.Call("PlayerLoadout", GAMEMODE, ply)
	end

	hook.Call("PlayerSetModel", GAMEMODE, ply)

	ply:SetupHands()

	----

	ply:SetPos(Vector(math.Rand(-4080, -3950), math.Rand(6650, 5000), 95))
	ply:SetEyeAngles(Angle(0, 0, 0))

	if BaseWars.Config.SpawnProtection > -1 and not (BaseWars:RaidGoingOn() and ply:InRaid()) then
		ply:SetSpawnProtection(CurTime() + BaseWars.Config.SpawnProtection)
	end

	ply.checkSpawnMenu = false

	if ply:IsCloak() then
		ply:SetNoDraw(true)
	end
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerDisconnected()
---------------------------------------------------------------------------]]
function GM:PlayerDisconnected(ply)
	if not ply:IsBot() and ply:GetBaseWarsConfig("autoSellOnLeave") then
		local total = 0
		for k, v in ents.Iterator() do
			if not v:ValidToSell(ply) then continue end

			total = total + v:GetCurrentValue() * BaseWars.Config.BackMoney

			SafeRemoveEntity(v)
		end

		ply:AddMoney(total)
	end
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerSetModel()
---------------------------------------------------------------------------]]
function GM:PlayerSetModel(ply)
	self.BaseClass:PlayerSetModel(ply)
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerSetHandsModel()
---------------------------------------------------------------------------]]
function GM:PlayerSetHandsModel(ply, ent)
	self.BaseClass:PlayerSetHandsModel(ply, ent)
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerLoadout()
---------------------------------------------------------------------------]]
function GM:PlayerLoadout(ply)
	self.BaseClass:PlayerLoadout(ply)
end

--[[-------------------------------------------------------------------------
	MARK: Ragdolls

	GM:PlayerSpawnRagdoll()
	GM:PlayerSpawnedRagdoll()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnRagdoll(ply, model)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "ragdolls")
end

function GM:PlayerSpawnedRagdoll(ply, model, ent)
	ply:AddCount("ragdolls", ent)
end

--[[-------------------------------------------------------------------------
	MARK: Props

	GM:PlayerSpawnProp()
	GM:PlayerSpawnedProp()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnProp(ply, model)
	if not ply.basewarsProfileID then
		return
	end

	if ply:InSafeZone() then
		BaseWars:Notify(ply, "#safeZone_spawnProp", NOTIFICATION_ERROR, 5)
		return false
	end

	if ply:InRaid() then
		BaseWars:Notify(ply, "#raid_spawnProp", NOTIFICATION_ERROR, 5)
		return
	end

	if not table.HasValue(BaseWars.Config.WhitelistProps, model) then
		if BaseWars:IsAdmin(ply, true) and BaseWars.Config.AdminsSpawnProps then
			return true
		end

		if BaseWars:IsSuperAdmin(ply) and BaseWars.Config.SuperAdminSpawnProps then
			return true
		end

		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "props")
end

function GM:PlayerSpawnedProp(ply, model, ent)
	ply:AddCount("props", ent)

	local propPhys = ent:GetPhysicsObject()
	local propHP = math.Clamp(IsValid(propPhys) and propPhys:GetMass() * 2 or 1, BaseWars.Config.MinPropHP, BaseWars.Config.MaxPropHP)
	ent:SetMaxHealth(propHP)
	ent:SetHealth(ent:GetMaxHealth())
	ent.Raidable = true
	ent.DestroyableProp = true

	hook.Run("BaseWars:PostSetPropHealth", ply, ent)
end

--[[-------------------------------------------------------------------------
	MARK: Effects

	GM:PlayerSpawnEffect()
	GM:PlayerSpawnedEffect()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnEffect(ply, model)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "effects")
end

function GM:PlayerSpawnedEffect(ply, model, ent)
	ply:AddCount("effects", ent)
end

--[[-------------------------------------------------------------------------
	MARK: Vehicles

	GM:PlayerSpawnVehicle()
	GM:PlayerSpawnedVehicle()
	GM:PlayerEnteredVehicle()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnVehicle(ply, model, class, info)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "vehicles")
end

function GM:PlayerSpawnedVehicle(ply, ent)
	ply:AddCount("vehicles", ent)
end

function GM:PlayerEnteredVehicle(ply, vehicle, role)
	ply:SendHint("VehicleView", 2)
end

--[[-------------------------------------------------------------------------
	MARK: NPCs

	GM:PlayerSpawnNPC()
	GM:PlayerSpawnedNPC()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnNPC(ply, type, weapon)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "npcs")
end

function GM:PlayerSpawnedNPC(ply, ent)
	ply:AddCount("npcs", ent)
end

--[[-------------------------------------------------------------------------
	MARK: SENTs

	GM:PlayerSpawnSENT()
	GM:PlayerSpawnedSENT()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnSENT(ply, sent)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "sents")
end

function GM:PlayerSpawnedSENT(ply, ent)
	ply:AddCount("sents", ent)
end

--[[-------------------------------------------------------------------------
	MARK: SWEPs

	GM:PlayerSpawnSWEP()
	GM:PlayerSpawnedSWEP()
	GM:PlayerGiveSWEP()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnSWEP(ply, class, info)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return LimitReachedProcess(ply, "sents")
end

function GM:PlayerSpawnedSWEP(ply, ent)
	ply:AddCount("sents", ent)
end

function GM:PlayerGiveSWEP(ply, class, info)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return true
end

--[[-------------------------------------------------------------------------
	MARK: GM:PlayerSpawnObject()
---------------------------------------------------------------------------]]
function GM:PlayerSpawnObject(ply)
	return true
end

--[[-------------------------------------------------------------------------
    MARK: GM:PlayerDeathSound()
	Whoever ideas it was to add this, from the bottom of my heart, kys :]
---------------------------------------------------------------------------]]
function GM:PlayerDeathSound(ply)
	return true
end

--[[-------------------------------------------------------------------------
	MARK: GM:GetFallDamage()
---------------------------------------------------------------------------]]
function GM:GetFallDamage(ply, speed)
	return (speed - 526.5) * 0.225
end

--[[-------------------------------------------------------------------------
	MARK: GM:PlayerNoClip()
---------------------------------------------------------------------------]]
function GM:PlayerNoClip(ply, want)
	if want then
		return BaseWars:IsAdmin(ply, true) and not ply:InRaid() -- Prenvent noclip from admins that are in a raid cuz fuck 'em
	end

	return true -- allow disabling noclip no matter who or what
end

--[[-------------------------------------------------------------------------
	MARK: GM:CanTool()
---------------------------------------------------------------------------]]
function GM:CanTool(ply, trace, tool)
	local Admin = BaseWars:IsAdmin(ply, true)

	local ent = trace.Entity
	if ent == game.GetWorld() and BaseWars.Config.BlockedTools[tool] != nil then return Admin end

	if BaseWars.Config.BlockedTools[tool] then return Admin end
	if string.find(ent:GetClass(), "bw_") then return Admin end

	return true
end

--[[-------------------------------------------------------------------------
	MARK: GM:CanDrive()
---------------------------------------------------------------------------]]
function GM:CanDrive(ply, ent)
	return BaseWars:IsSuperAdmin(ply)
end

--[[-------------------------------------------------------------------------
	MARK: GM:DoPlayerDeath
---------------------------------------------------------------------------]]
local defaultWeapons = {
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["weapon_physgun"] = true,
	["weapon_physcannon"] = true,
	["hands"] = true
}
function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	ply:AddDeaths(1)

	MySQLite.query(Format("UPDATE basewars_player_stats SET deaths = deaths + 1 WHERE player_id64 = %s", ply:SteamID64()), function() end, BaseWarsSQLError)

	if attacker:IsPlayer() and attacker != ply then
		MySQLite.query(Format("UPDATE basewars_player_stats SET kills = kills + 1 WHERE player_id64 = %s", attacker:SteamID64()), function() end, BaseWarsSQLError)
	end

	local tempWeapon = {}
	for k, v in ipairs(ply:GetWeapons()) do
		local class = v:GetClass()

		if defaultWeapons[class] then
			continue
		end

		table.insert(tempWeapon, class)
	end

	ply.oldWeapons = tempWeapon

	if (IsValid(attacker) and attacker:IsPlayer()) and attacker != ply then
		attacker:AddFrags(1)
	end
end

--[[-------------------------------------------------------------------------
	MARK: GM:PlayerDeath()
---------------------------------------------------------------------------]]
function GM:PlayerDeath(ply, inflictor, attacker)
	ply.DeathTime = CurTime()

	if IsValid(attacker) and attacker:IsClass("trigger_hurt") then
		attacker = ply
	end

	if IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver()) then
		attacker = attacker:GetDriver()
	end

	if not IsValid(inflictor) and IsValid(attacker) then
		inflictor = attacker
	end

	if IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC()) then
		inflictor = inflictor:GetActiveWeapon()
		if not IsValid(inflictor) then
			inflictor = attacker
		end
	end

	player_manager.RunClass(ply, "Death", inflictor, attacker)

	if attacker == ply then
		net.Start("PlayerKilledSelf")
			net.WriteEntity(ply)
		net.Broadcast()

		return
	end

	if attacker:IsPlayer() then
		net.Start("PlayerKilledByPlayer")
			net.WriteEntity(ply)
			net.WriteString(inflictor:GetClass())
			net.WriteEntity(attacker)
		net.Broadcast()

		return
	end

	net.Start("PlayerKilled")
		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteString(attacker:GetClass())
	net.Broadcast()
end

--[[-------------------------------------------------------------------------
	MARK: GM:PostPlayerDeath()
---------------------------------------------------------------------------]]
function GM:PostPlayerDeath(ply)
	local PlayerWeapons = {}
	for k, weap in pairs(ply:GetWeapons()) do
		if not IsValid(weap) then continue end

		local Class = weap:GetClass()

		if BaseWars.Config.WeaponDropBlacklist and not istable(WeaponDropBlacklist) and BaseWars.Config.WeaponDropBlacklist[Class] then continue end
		if weap.Category and BaseWars.Config.CategoryBlackList[weap.Category] then continue end

		table.insert(PlayerWeapons, Class)
	end

	if #PlayerWeapons > 0 then
		local Box = ents.Create("bw_weaponsbox")
		Box:SetPos(ply:GetPos())
		Box:SetWeaponCount(#PlayerWeapons)
		Box:Spawn()
		Box.Weapons = PlayerWeapons

		ply.weaponBox = Box
	end
end

--[[-------------------------------------------------------------------------
	MARK: GM:PlayerDeathThink()
---------------------------------------------------------------------------]]
function GM:PlayerDeathThink(ply)
	if not ply.checkSpawnMenu then
		timer.Simple(BaseWars.Config.RespawnTime, function()
			if not IsValid(ply) then return end

			if ply:Alive() then
				return
			end

			local spawnPoints = {}
			for k, v in ents.Iterator() do
				if not v:IsClass("bw_spawnpoint") then continue end
				if v:CPPIGetOwner() != ply then continue end

				table.insert(spawnPoints, v)
			end

			if #spawnPoints <= 0 then
				ply:Spawn()
			else
				net.Start("BaseWars:OpenSpawnpointMenu")
					net.WriteTable(spawnPoints)
				net.Send(ply)
			end
		end)

		ply.checkSpawnMenu = true
	end
end

--[[-------------------------------------------------------------------------
    MARK: Hooks and Game Events
---------------------------------------------------------------------------]]
gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "BaseWars:player_disconnect", function(data)
	local steamid64 = util.SteamIDTo64(data.networkid)

	timer.Remove("BaseWars.TimePlay." .. steamid64)
	MySQLite.query(([[UPDATE basewars_player_infos SET last_played = %s WHERE player_id64 = %s]]):format(os.time(), steamid64))

	local count = 0
	for k, v in player.Iterator() do
		if v:SteamID() == data.networkid then
			continue
		end

		count = count + 1
	end
end)

hook.Add("PlayerButtonDown", "BaseWars:AFK", function(ply, key)
	ply:SetAFKTime(CurTime())
end)

net.Receive("BaseWars:SendPlayerConfig", function(len, ply)
	ply.basewarsConfig = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))
end)

net.Receive("BaseWars:PlayerReadyToReceiveNets", function(len, ply)
	if IsValid(ply) then
		hook.Run("BaseWars:SendNetToClient", ply)
	end
end)

net.Receive("BaseWars:OpenSpawnpointMenu", function(len, ply)
	local spawnpoint = net.ReadEntity()

	ply:Spawn()
	if IsValid(spawnpoint) then
		ply:SetPos(spawnpoint:GetPos() + Vector(0, 0, 5))
	else
		ply:SetPos(Vector(math.Rand(-4080, -3950), math.Rand(6650, 5000), 95))
	end
	ply:SetEyeAngles(Angle(0, 90, 0))
end)