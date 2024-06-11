util.AddNetworkString("BaseWars:Raid:SendRaidDataToClient")
util.AddNetworkString("BaseWars:Raid:StartRaid")
util.AddNetworkString("BaseWars:Raid:StopRaid")
util.AddNetworkString("BaseWars:Raid:ResetGlobalImmunity")
util.AddNetworkString("BaseWars:Raid:ResetPlayerImmunity")

local PLAYER = FindMetaTable("Player")
local raidData = {
	raidType = RAIDTYPE_NONE,
	time = 0,
	globalImmunity = 0,
	attacker = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	},
	defender = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	}
}

--[[-------------------------------------------------------------------------
	MARK: PLAYER Functions
---------------------------------------------------------------------------]]
function PLAYER:SetRaidImmunity(time)
	self:SetNWFloat("BaseWars.RaidImmunity", time or 0)
end

function PLAYER:GetRaidImmunity()
	if self:InFaction() then
		return math.max(0, math.ceil(BaseWars:GetFactionImmunity() - CurTime())), true
	end

	return math.max(0, math.ceil(self:GetNWFloat("BaseWars.RaidImmunity", 0) - CurTime())), false
end

function PLAYER:HasRaidImmunity()
	local time, bool = self:GetRaidImmunity()
	return time > 0, bool
end

function PLAYER:InRaid()
	if not BaseWars:RaidGoingOn() then
		return false
	end

	return raidData.attacker.players[self] != nil or raidData.defender.players[self] != nil
end

function PLAYER:Ally(ply)
	return self:InFaction() and self:HasSameFaction(ply)
end

function PLAYER:Enemy(ply)
	if not BaseWars:RaidGoingOn() then
		return false
	end

	if raidData.attacker.players[self] and raidData.defender.players[ply] then
		return true
	end

	if raidData.attacker.players[ply] and raidData.defender.players[self] then
		return true
	end

	return false
end

--[[-------------------------------------------------------------------------
	MARK: Global Functions
---------------------------------------------------------------------------]]
function BaseWars:SendRaidData()
	local data = table.Copy(raidData)

	local attackers = {}
	for ply, _ in pairs(data.attacker.players) do
		if not IsValid(ply) then continue end

		table.insert(attackers, ply:SteamID64())
	end
	data.attacker.players = attackers

	local defenders = {}
	for ply, _ in pairs(data.defender.players) do
		if not IsValid(ply) then continue end

		table.insert(defenders, ply:SteamID64())
	end
	data.defender.players = defenders

	data = util.Compress(util.TableToJSON(data))
	net.Start("BaseWars:Raid:SendRaidDataToClient")
		net.WriteData(data, #data)
	net.Broadcast()
end

function BaseWars:StartRaid(ply, target)
	if not IsValid(ply) or not IsValid(target) then
		return -- ???
	end

	if BaseWars:RaidGoingOn() then
		BaseWars:Notify(ply, "#raids_raidAlreadyGoingOn", NOTIFICATION_ERROR, 5)

		return
	end

	if BaseWars:HasGlobalImmunity() then
		BaseWars:Notify(ply, "#raids_globalImmunity", NOTIFICATION_ERROR, 5, BaseWars:FormatTime2(BaseWars:GetGlobalImmunity(), ply))

		return
	end

	if ply == target then
		BaseWars:Notify(ply, "#raids_raidYourself", NOTIFICATION_ERROR, 5)

		return
	end

	if ply:InFaction() and not target:InFaction() then
		BaseWars:Notify(ply, "#raids_raidSoloWhileInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not ply:InFaction() and target:InFaction() then
		BaseWars:Notify(ply, "#raids_raidFactionWhileSolo", NOTIFICATION_ERROR, 5)

		return
	end

	if ply:InFaction() and ply:HasSameFaction(target) then
		BaseWars:Notify(ply, "#raids_raidFactionMate", NOTIFICATION_ERROR, 5)

		return
	end

	local raidType = ply:InFaction() and RAIDTYPE_FACTION or RAIDTYPE_SOLO
	local attackerData = {
		name = raidType == RAIDTYPE_FACTION and ply:GetFaction() or ply:Name(),
		members = BaseWars:GetFactionMembers(ply:GetFaction(), true),
		level = ply:GetLevel(),
		players = {
			[ply] = true
		}
	}
	local defenderData = {
		name = raidType == RAIDTYPE_FACTION and target:GetFaction() or target:Name(),
		members = BaseWars:GetFactionMembers(target:GetFaction(), true),
		level = target:GetLevel(),
		players = {
			[target] = true
		}
	}

	local immunityBool, factionBool = target:HasRaidImmunity()
	local immunityTime = target:GetRaidImmunity()
	if immunityBool then
		BaseWars:Notify(ply, factionBool and "#raids_factionImmunity" or "#raids_playerImmunity", NOTIFICATION_ERROR, 5, defenderData.name, BaseWars:FormatTime2(immunityTime))

		return
	end

	if raidType == RAIDTYPE_FACTION then
		attackerData.level = 0
		attackerData.players = {}
		for k, v in ipairs(attackerData.members) do
			if not IsValid(v) then continue end

			attackerData.level = attackerData.level + v:GetLevel()
			attackerData.players[v] = true
		end
		attackerData.level = math.ceil(attackerData.level / #attackerData.members)

		defenderData.level = 0
		defenderData.players = {}
		for k, v in ipairs(defenderData.members) do
			if not IsValid(v) then continue end

			defenderData.level = defenderData.level + v:GetLevel()
			defenderData.players[v] = true
		end
		defenderData.level = math.ceil(defenderData.level / #defenderData.members)
	end

	local minimumLevel = BaseWars.Config.Raids.minimumLevel
	if attackerData.level < minimumLevel then
		BaseWars:Notify(ply, "#raids_yourLevelTooLow", NOTIFICATION_ERROR, 5, BaseWars:FormatNumber(minimumLevel - attackerData.level))

		return
	end

	if defenderData.level < minimumLevel then
		BaseWars:Notify(ply, "#raids_opponentLevelTooLow", NOTIFICATION_ERROR, 5, BaseWars:FormatNumber(minimumLevel - defenderData.level))

		return
	end

	for attacker, _ in pairs(attackerData.players) do
		if not IsValid(attacker) then continue end

		if attacker:IsGodmode() then
			attacker:SetGodmode(false)
			BaseWars:Notify(attacker, "#command_ungod", NOTIFICATION_ADMIN, 5)
		end

		if attacker:IsCloak() then
			attacker:SetCloak(false)
			BaseWars:Notify(attacker, "#command_uncloak", NOTIFICATION_ADMIN, 5)
		end
	end

	for defender, _ in pairs(defenderData.players) do
		if not IsValid(defender) then continue end

		if defender:IsGodmode() then
			defender:SetGodmode(false)
			BaseWars:Notify(defender, "#command_ungod", NOTIFICATION_ADMIN, 5)
		end

		if defender:IsCloak() then
			defender:SetCloak(false)
			BaseWars:Notify(defender, "#command_uncloak", NOTIFICATION_ADMIN, 5)
		end
	end

	raidData.raidType = raidType
	raidData.time = CurTime() + BaseWars.Config.Raids.duration
	raidData.attacker = {
		name = attackerData.name,
		players = attackerData.players,
		destroyed = 0,
		totalValue = 0
	}
	raidData.defender = {
		name = defenderData.name,
		players = defenderData.players,
		destroyed = 0,
		totalValue = 0
	}

	BaseWars:SendRaidData()
	BaseWars:NotifyAll("#raids_raidStarted", NOTIFICATION_RAID, 15, attackerData.name, defenderData.name, ply:Name())

	hook.Run("BaseWars:RaidStarted", ply, raidType, raidData.attacker, raidData.defender)
end

function BaseWars:StopRaid(ply)
	if not IsValid(ply) then
		return
	end

	if not BaseWars:RaidGoingOn() then
		BaseWars:Notify(ply, "#raids_stopRaidWhenNoRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if not ply:InRaid() then
		BaseWars:Notify(ply, "#raids_stopRaidWhenNotInRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if not raidData.attacker.players[ply] then
		BaseWars:Notify(ply, "#raids_stopRaidWhenNotAttacker", NOTIFICATION_ERROR, 5)

		return
	end

	if raidData.raidType == RAIDTYPE_FACTION then
		if BaseWars:GetFactionLeader(ply:GetFaction()) != ply then
			BaseWars:Notify(ply, "#raids_stopRaidWhenNotLeader", NOTIFICATION_ERROR, 5)

			return
		end
	end

	local raidImmunityTime = CurTime() + BaseWars.Config.Raids.immunity
	for raidPlayer, _ in pairs(raidData.defender.players) do
		if not IsValid(raidPlayer) then continue end

		raidPlayer:SetRaidImmunity(raidImmunityTime)
	end

	if raidData.raidType == RAIDTYPE_FACTION then
		BaseWars:SetFactionImmunity(raidData.defender.name, raidImmunityTime)
	end

	raidData.raidType = RAIDTYPE_NONE
	raidData.time = 0
	raidData.globalImmunity = CurTime() + BaseWars.Config.Raids.globalImmunity
	raidData.attacker = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	}
	raidData.defender = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	}

	BaseWars:SendRaidData()
	BaseWars:NotifyAll("#raids_raidStopped", NOTIFICATION_RAID, 15, ply:Name())

	for _, ent in ents.Iterator() do
		if not string.find(ent:GetClass(), "bw_explosive") then continue end

		SafeRemoveEntity(ent)
	end

	hook.Run("BaseWars:RaidStopped", Format(BaseWars:GetLang("raids_raidStopped"), ply:Name()), ply)
end

function BaseWars:CancelRaid(reason, ...)
	if not BaseWars:RaidGoingOn() then
		return
	end

	local raidImmunityTime = CurTime() + BaseWars.Config.Raids.immunity
	for raidPlayer, _ in pairs(raidData.defender.players) do
		if not IsValid(raidPlayer) then continue end

		raidPlayer:SetRaidImmunity(raidImmunityTime)
	end

	if raidData.raidType == RAIDTYPE_FACTION then
		BaseWars:SetFactionImmunity(raidData.defender.name, raidImmunityTime)
	end

	raidData.raidType = RAIDTYPE_NONE
	raidData.time = 0
	raidData.globalImmunity = CurTime() + BaseWars.Config.Raids.globalImmunity
	raidData.attacker = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	}
	raidData.defender = {
		name = "none",
		players = {},
		destroyed = 0,
		totalValue = 0
	}

	BaseWars:SendRaidData()
	BaseWars:NotifyAll(reason, NOTIFICATION_RAID, 15, ...)

	for _, ent in ents.Iterator() do
		if not string.find(ent:GetClass(), "bw_explosive") then continue end

		SafeRemoveEntity(ent)
	end

	reason = reason[1] == "#" and Format(BaseWars:GetLang(string.sub(reason, 2)), ...) or reason

	hook.Run("BaseWars:RaidStopped", reason)
end

function BaseWars:GetRaidAttacker()
	return table.Copy(raidData.attacker)
end

function BaseWars:GetRaidDefender()
	return table.Copy(raidData.defender)
end

function BaseWars:GetRaidParticipant()
	return table.Copy({
		attacker = raidData.attacker,
		defender = raidData.defender
	})
end

function BaseWars:GetRaidTime()
	return math.max(0, math.ceil(raidData.time - CurTime()))
end

function BaseWars:RaidGoingOn()
	return raidData.raidType != RAIDTYPE_NONE
end

function BaseWars:GetRaidType()
	return raidData.raidType
end

function BaseWars:GetGlobalImmunity()
	return math.max(0, math.ceil(raidData.globalImmunity - CurTime()))
end

function BaseWars:HasGlobalImmunity()
	return self:GetGlobalImmunity() > 0
end

--[[-------------------------------------------------------------------------
	MARK: Hooks
---------------------------------------------------------------------------]]
hook.Add("BaseWars:SendNetToClient", "BaseWars:Raids", function(ply)
    BaseWars:SendRaidData()
	ply:SetRaidImmunity(0)
end)

hook.Add("PlayerDisconnected", "BaseWars:Raids", function(ply)
	if not BaseWars.DefaultConfig.Raids.cancelOnDisconnect then return end
	if not BaseWars:RaidGoingOn() then return end

	if ply:InRaid() then
		BaseWars:CancelRaid("#raids_cancelWhenPlayerDisconnect", ply:Name())
	end
end)

hook.Add("Think", "BaseWars:Raids", function()
	if not BaseWars:RaidGoingOn() then return end

	if BaseWars:GetRaidTime() <= 0 then
		BaseWars:CancelRaid("#raids_finished")
	end
end)

-- Lua Refresh
hook.Add("BaseWars:Initialize", "BaseWars:Raids", function()
	BaseWars:SendRaidData()

	for _, ply in player.Iterator() do
		ply:SetRaidImmunity(0)
	end
end)

--[[-------------------------------------------------------------------------
	MARK: Nets
---------------------------------------------------------------------------]]
net.Receive("BaseWars:Raid:StartRaid", function(len, ply)
	local target = net.ReadEntity()

	if not IsValid(target) then
		return
	end

	BaseWars:StartRaid(ply, target)
end)

net.Receive("BaseWars:Raid:StopRaid", function(len, ply)
	BaseWars:StopRaid(ply)
end)

net.Receive("BaseWars:Raid:ResetGlobalImmunity", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	raidData.globalImmunity = 0

	BaseWars:SendRaidData()
	BaseWars:NotifyAll("#raids_resetGlobalImmunity", NOTIFICATION_RAID, 8)
end)

net.Receive("BaseWars:Raid:ResetPlayerImmunity", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local target = BaseWars:FindPlayer(net.ReadString())
	if not IsValid(target) then
		return
	end

	target:SetRaidImmunity(0)
	BaseWars:Notify(target, "#raids_yourImmunity", NOTIFICATION_RAID, 8)
	BaseWars:Notify(ply, "#raids_youResetPlayerImmunity", NOTIFICATION_RAID, 8, target:Name())
end)