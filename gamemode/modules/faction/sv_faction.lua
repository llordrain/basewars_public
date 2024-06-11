local PLAYER = FindMetaTable("Player")
local FactionID = 2
local Factions = {}

util.AddNetworkString("BaseWars:Factions:Player:JoinServer") -- Sync all the factions with player that joins the server
util.AddNetworkString("BaseWars:Factions:Player:UpdateServer") -- Send everything to players when updating factions (Player join or quit or something else like that)
util.AddNetworkString("BaseWars:Factions:Player:UpdateServer:Single") -- Same as "BaseWars:Factions:Player:UpdateServer" but for a single faction instead of all of them

util.AddNetworkString("BaseWars:Factions:Player:CreateFaction")
util.AddNetworkString("BaseWars:Factions:Player:JoinFaction")
util.AddNetworkString("BaseWars:Factions:Player:QuiFaction")
util.AddNetworkString("BaseWars:Factions:Player:ChangePassword")
util.AddNetworkString("BaseWars:Factions:Player:KickPlayer")
util.AddNetworkString("BaseWars:Factions:Player:TransferLeadership")
util.AddNetworkString("BaseWars:Factions:Player:ToggleFriendlyFire")

util.AddNetworkString("BaseWars:Factions:Admin:Disband")
util.AddNetworkString("BaseWars:Factions:Admin:ChangeLeader")
util.AddNetworkString("BaseWars:Factions:Admin:ToggleFriendlyFire")
util.AddNetworkString("BaseWars:Factions:Admin:ResetImmunity")
util.AddNetworkString("BaseWars:Factions:Admin:KickMember")

--[[-------------------------------------------------------------------------
	Lua Refresh
---------------------------------------------------------------------------]]
hook.Add("BaseWars:Initialize", "BaseWars:Faction:GamemodeReloaded", function()
	BaseWars:ResetAllFactions()
end)

--[[-------------------------------------------------------------------------
	MARK: Local Functions
---------------------------------------------------------------------------]]
local function setupFaction(leader, name, password, color)
	team.SetUp(FactionID, name, color)

	Factions[name] = {
		id = FactionID,
		leader = leader,
		password = password,
		color = color,
		immunity = CurTime(),
		ff = false,
		members = {}
	}

	local factionData = table.Copy(Factions[name])
	factionData.leader = factionData.leader:SteamID64()
	factionData.name = name
	factionData.password = nil

	factionData = util.Compress(util.TableToJSON(factionData))
	net.Start("BaseWars:Factions:Player:CreateFaction")
		net.WriteData(factionData, #factionData)
	net.Broadcast()

	leader:SetTeam(FactionID)

	BaseWars:UpdateFactions(name)
	BaseWars:Notify(leader, "#faction_createdFaction", NOTIFICATION_FACTION, 5, name)

	hook.Run("BaseWars:Factions:CreateFaction", leader, FactionID, name, password)

	FactionID = FactionID + 1
end

--[[-------------------------------------------------------------------------
	MARK: Global Functions
---------------------------------------------------------------------------]]
function BaseWars:ResetAllFactions()
	for k, v in player.Iterator() do
		v:SetTeam(1)
	end

	self:UpdateFactions()
end

function BaseWars:GetFactions(name)
	if name then
		return Factions[name]
	end

	return Factions
end

function BaseWars:GetFactionID(name)
	local data = self:GetFactions(name)

	return data and data.id or -1
end

function BaseWars:GetFactionLeader(name)
	local data = self:GetFactions(name)

	return data and data.leader or NULL
end

function BaseWars:GetFactionPassword(name)
	local data = self:GetFactions(name)

	return data and data.password or ""
end

function BaseWars:GetFactionImmunity(name)
	local data = self:GetFactions(name)

	return data and data.immunity or 0
end

function BaseWars:GetFactionFriendlyFire(name)
	local data = self:GetFactions(name)

	return data and data.ff or false
end

function BaseWars:GetFactionMembers(name, includeLeader)
	local data = self:GetFactions(name)

	if not data then
		return
	end

	local members = {}
	for k, v in ipairs(data.members) do
		if not IsValid(v) then continue end

		table.insert(members, v)
	end

	if includeLeader then
		table.insert(members, 1, data.leader)
	end

	return members
end

function BaseWars:AddFactionMember(name, ply)
	if not self:GetFactions(name) then
		return
	end

	if not IsValid(ply) then
		return
	end

	local members = {}
	for k, v in ipairs(self:GetFactionMembers(name)) do
		table.insert(members, v)
	end

	table.insert(members, ply)

	ply:SetTeam(self:GetFactionID(name))
	Factions[name]["members"] = members

	self:UpdateFactions(name)
end

function BaseWars:RemoveFactionMember(name, ply)
	if not self:GetFactions(name) then
		return
	end

	if not IsValid(ply) then
		return
	end

	local members = {}
	for k, v in ipairs(self:GetFactionMembers(name)) do
		if v == ply then continue end

		table.insert(members, v)
	end

	ply:SetTeam(1)
	Factions[name]["members"] = members

	self:UpdateFactions(name)
end

function BaseWars:SetFactionImmunity(name, time)
	if not self:GetFactions(name) then
		return
	end

	Factions[name]["immunity"] = time

	BaseWars:UpdateFactions(name)
end

function BaseWars:UpdateFactions(name)
	local data = {}

	if name then
		local factionData = self:GetFactions(name)

		local data = {
			name = name,
			id = factionData.id,
			leader = factionData.leader:SteamID64(),
			color = factionData.color,
			immunity = factionData.immunity,
			ff = factionData.ff,
			members = {}
		}

		for k,v in ipairs(factionData.members) do
			table.insert(data.members, v:SteamID64())
		end

		data = util.Compress(util.TableToJSON(data))
		net.Start("BaseWars:Factions:Player:UpdateServer:Single")
			net.WriteData(data, #data)
		net.Broadcast()
	else
		for name, factionData in pairs(Factions) do
			local faction = {
				name = name,
				id = factionData.id,
				leader = factionData.leader:SteamID64(),
				color = factionData.color,
				immunity = factionData.immunity,
				ff = factionData.ff,
				members = {}
			}

			for k, v in ipairs(factionData.members) do
				table.insert(faction.members, v:SteamID64())
			end

			table.insert(data, faction)
		end

		local data = util.Compress(util.TableToJSON(data))
		net.Start("BaseWars:Factions:Player:UpdateServer")
			net.WriteData(data, #data)
		net.Broadcast()
	end
end

--[[-------------------------------------------------------------------------
	MARK: Player Functions
---------------------------------------------------------------------------]]
function PLAYER:CreateFaction(name, password, color)
	if not name or not password or not color then
		return
	end

	password = string.Trim(password)

	if self:InRaid() then
		BaseWars:Notify(self, "#faction_inRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if self:InFaction() then
		BaseWars:Notify(self, "#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_nameTaken", NOTIFICATION_ERROR, 5, name)

		return
	end

	if string.len(name) < 3 then
		BaseWars:Notify(self, "#faction_nameTooShort", NOTIFICATION_ERROR, 5)

		return
	end

	if string.len(name) > 32 then
		BaseWars:Notify(self, "#faction_nameTooLong", NOTIFICATION_ERROR, 5)

		return
	end

	local goodName = true
	for k, v in pairs(BaseWars.LANG) do
		if k == "Currency" then continue end

		if name == v.faction_noFaction then
			goodName = false

			break
		end
	end

	if not goodName then
		BaseWars:Notify(self, "#faction_nameBlocked", NOTIFICATION_ERROR, 5, name)

		return
	end

	if string.len(password) > 32 then
		BaseWars:Notify(self, "#faction_passwordTooLong", NOTIFICATION_ERROR, 5)

		return
	end

	setupFaction(self, name, password, color)
end

function PLAYER:JoinFaction(name, password)
	if not name or not password then
		return
	end

	name = string.Trim(name)
	password = string.Trim(password)

	if self:InRaid() then
		BaseWars:Notify(self, "#faction_inRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if self:InFaction() then
		BaseWars:Notify(self, "#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	local factionLeader = BaseWars:GetFactionLeader(name)
	if factionLeader:InRaid() then
		BaseWars:Notify(self, "#faction_cantJoinDuringRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if table.Count(BaseWars:GetFactionMembers(name, true)) >= BaseWars.Config.FactionLimit then
		BaseWars:Notify(self, "#faction_reachMemberLimit", NOTIFICATION_ERROR, 5, BaseWars.Config.FactionLimit)

		return
	end

	if BaseWars:GetFactionPassword(name) != password then
		BaseWars:Notify(self, "#faction_wrongPassword", NOTIFICATION_ERROR, 5)

		return
	end

	BaseWars:AddFactionMember(name, self)
	BaseWars:Notify(self, "#faction_playerJoinFaction", NOTIFICATION_FACTION, 5, name)
	BaseWars:Notify(factionLeader, "#faction_playerJoinYourFaction", NOTIFICATION_FACTION, 5, self:Name())

	hook.Run("BaseWars:Factions:JoinFaction", self, name)
end

function PLAYER:QuitFaction()
	local name = self:GetFaction()

	if self:InRaid() then
		BaseWars:Notify(self, "#faction_inRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if not self:InFaction() then
		BaseWars:Notify(self, "#faction_notInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	if BaseWars:GetFactionLeader(name) == self then
		local members = BaseWars:GetFactionMembers(name)

		for k, v in ipairs(members) do
			v:SetTeam(1)

			BaseWars:Notify(v, "#faction_kickDisband", NOTIFICATION_FACTION, 5)
		end

		Factions[name] = nil
		self:SetTeam(1)

		BaseWars:UpdateFactions()
		BaseWars:Notify(self, "#faction_disband", NOTIFICATION_FACTION, 5)
	else
		self:SetTeam(1)

		BaseWars:RemoveFactionMember(name, self)
		BaseWars:Notify(self, "#faction_disband", NOTIFICATION_FACTION, 5)
	end

	hook.Run("BaseWars:Factions:QuitFaction", self, name)
end

function PLAYER:ChangeFactionPassword(password)
	local name = self:GetFaction()

	if not self:InFaction() then
		BaseWars:Notify(self, "#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	if BaseWars:GetFactionLeader(name) != self then
		BaseWars:Notify(self, "#faction_notLeader", NOTIFICATION_ERROR, 5)

		return
	end

	local oldpassword = BaseWars:GetFactionPassword(name)
	Factions[name]["password"] = password

	BaseWars:UpdateFactions(name)
	BaseWars:Notify(self, "#faction_passwordChanged", NOTIFICATION_FACTION, 5, oldpassword, password)

	hook.Run("BaseWars:Factions:ChangePassword", self, oldpassword, password)
end

function PLAYER:KickPlayerFromFaction(ply)
	local name = self:GetFaction()

	if not ply or not IsValid(ply) then
		return
	end

	if self:InRaid() then
		BaseWars:Notify(self, "#faction_inRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if not self:InFaction() then
		BaseWars:Notify(self, "#faction_notInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	if self == ply then
		BaseWars:Notify(self, "#faction_cantDoToYourself", NOTIFICATION_ERROR, 5)

		return
	end

	if not self:HasSameFaction(ply) then
		BaseWars:Notify(self, "#faction_differentFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if BaseWars:GetFactionLeader(name) != self then
		BaseWars:Notify(self, "#faction_notLeader", NOTIFICATION_ERROR, 5)

		return
	end

	if not table.HasValue(BaseWars:GetFactionMembers(name), ply) then
		BaseWars:Notify(self, "#faction_notMemberOfYourFaction", NOTIFICATION_ERROR, 5, ply:Name())

		return
	end

	BaseWars:RemoveFactionMember(name, ply)
	BaseWars:Notify(self, "#faction_kickedPlayer", NOTIFICATION_FACTION, 5, ply:Name())
	BaseWars:Notify(ply, "#faction_kicked", NOTIFICATION_FACTION, 5)

	hook.Run("BaseWars:Factions:KickMember", self, ply)
end

function PLAYER:TransferFactionLeadership(ply)
	local name = self:GetFaction()

	if not ply or not IsValid(ply) then
		return
	end

	name = string.Trim(name)

	if not self:InFaction() then
		BaseWars:Notify(self, "#faction_notInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	if self == ply then
		BaseWars:Notify(self, "#faction_cantDoToYourself", NOTIFICATION_ERROR, 5)

		return
	end

	if not self:HasSameFaction(ply) then
		BaseWars:Notify(self, "#faction_differentFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if BaseWars:GetFactionLeader(name) != self then
		BaseWars:Notify(self, "#faction_notLeader", NOTIFICATION_ERROR, 5)

		return
	end

	Factions[name]["leader"] = ply

	table.insert(Factions[name]["members"], self)
	for k, v in ipairs(BaseWars:GetFactionMembers(name)) do
		if v == ply then
			table.remove(Factions[name]["members"], k)

			break
		end
	end

	BaseWars:UpdateFactions(name)
	BaseWars:Notify(self, "#faction_promotedLeader", NOTIFICATION_ERROR, 5, ply:Name())
	BaseWars:Notify(ply, "#faction_becameLeader", NOTIFICATION_ERROR, 5)

	hook.Run("BaseWars:Factions:PromoteLeader", self, ply)
end

function PLAYER:ChangeFactionFriendlyFire(bool)
	local name = self:GetFaction()

	if bool == nil then
		return
	end

	if self:InRaid() then
		BaseWars:Notify(self, "#faction_inRaid", NOTIFICATION_ERROR, 5)

		return
	end

	if not self:InFaction() then
		BaseWars:Notify(self, "#faction_notInFaction", NOTIFICATION_ERROR, 5)

		return
	end

	if not BaseWars:FactionExists(name) then
		BaseWars:Notify(self, "#faction_dontExist", NOTIFICATION_ERROR, 5, name)

		return
	end

	if BaseWars:GetFactionLeader(name) != self then
		BaseWars:Notify(self, "#faction_notLeader", NOTIFICATION_ERROR, 5)

		return
	end

	Factions[name]["ff"] = bool

	for k, v in ipairs(BaseWars:GetFactionMembers(name, true)) do
		BaseWars:Notify(v, "#faction_changedFrendlyFire", NOTIFICATION_FACTION, 5, bool and v:GetLang("yes") or v:GetLang("no"))
	end

	BaseWars:UpdateFactions(name)
end

--[[-------------------------------------------------------------------------
	MARK: Nets Player
---------------------------------------------------------------------------]]
net.Receive("BaseWars:Factions:Player:CreateFaction", function(len, ply)
	if not IsValid(ply) then return end

	local name = net.ReadString()
	local password = net.ReadString()
	local color = net.ReadColor()

	ply:CreateFaction(name, password, color)
end)

net.Receive("BaseWars:Factions:Player:JoinFaction", function(len, ply)
	if not IsValid(ply) then return end

	local name = net.ReadString()
	local password = net.ReadString()

	ply:JoinFaction(name, password)
end)

net.Receive("BaseWars:Factions:Player:QuiFaction", function(len, ply)
	if not IsValid(ply) then return end

	ply:QuitFaction()
end)

net.Receive("BaseWars:Factions:Player:ChangePassword", function(len, ply)
	if not IsValid(ply) then return end

	local password = net.ReadString()

	ply:ChangeFactionPassword(password)
end)

net.Receive("BaseWars:Factions:Player:KickPlayer", function(len, ply)
	if not IsValid(ply) then return end

	local target = net.ReadEntity()

	ply:KickPlayerFromFaction(target)
end)

net.Receive("BaseWars:Factions:Player:TransferLeadership", function(len, ply)
	if not IsValid(ply) then return end

	local target = net.ReadEntity()

	ply:TransferFactionLeadership(target)
end)

net.Receive("BaseWars:Factions:Player:ToggleFriendlyFire", function(len, ply)
	if not IsValid(ply) then return end

	local bool = net.ReadBool()

	ply:ChangeFactionFriendlyFire(bool)
end)

--[[-------------------------------------------------------------------------
	MARK: Nets Admin
---------------------------------------------------------------------------]]
net.Receive("BaseWars:Factions:Admin:Disband", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local name = net.ReadString()

	if not BaseWars:FactionExists(name) then
		return
	end

	local members = BaseWars:GetFactionMembers(name, true)
	for k, ply in ipairs(members) do
		ply:SetTeam(1)
		BaseWars:Notify(ply, "#faction_kickDisband", NOTIFICATION_FACTION, 5)
	end

	Factions[name] = nil

	BaseWars:UpdateFactions()
	BaseWars:Notify(ply, "#adminmenu_doDisband", NOTIFICATION_FACTION, 5, name)

	hook.Run("BaseWars:Factions:Admin:Disband", ply, name)
end)

net.Receive("BaseWars:Factions:Admin:ChangeLeader", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local name = net.ReadString()
	local leader = net.ReadEntity()
	local newLeader = net.ReadEntity()

	if not BaseWars:FactionExists(name) then
		return
	end

	if not IsValid(leader) or not IsValid(newLeader) then
		return
	end

	if not leader:HasSameFaction(newLeader) then
		return
	end

	Factions[name]["leader"] = newLeader

	for k, v in ipairs(BaseWars:GetFactionMembers(name)) do
		if v == newLeader then
			table.remove(Factions[name]["members"], k)

			break
		end
	end

	BaseWars:AddFactionMember(name, leader)

	BaseWars:Notify(leader, "#adminmenu_noLongerLeader", NOTIFICATION_FACTION, 5)
	BaseWars:Notify(newLeader, "#faction_becameLeader", NOTIFICATION_FACTION, 5)
	BaseWars:Notify(ply, "#adminmenu_changedLeader", NOTIFICATION_FACTION, 5, newLeader:Name(), name)

	hook.Run("BaseWars:Factions:Admin:ReplaceLeader", ply, leader, newLeader, name)
end)

net.Receive("BaseWars:Factions:Admin:ToggleFriendlyFire", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local name = net.ReadString()
	local bool = net.ReadBool()

	if not BaseWars:FactionExists(name) then
		return
	end

	Factions[name]["ff"] = bool

	BaseWars:UpdateFactions(name)

	for k, v in ipairs(BaseWars:GetFactionMembers(name, true)) do
		BaseWars:Notify(v, "#faction_changedFrendlyFire", NOTIFICATION_FACTION, 5, bool and v:GetLang("yes") or v:GetLang("no"))
	end

	BaseWars:Notify(ply, "#faction_changedFrendlyFireAdmin", NOTIFICATION_FACTION, 5, name, bool and ply:GetLang("yes") or ply:GetLang("no"))
end)

net.Receive("BaseWars:Factions:Admin:ResetImmunity", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local name = net.ReadString()

	if not BaseWars:FactionExists(name) then
		return
	end

	BaseWars:SetFactionImmunity(name, 0)
	BaseWars:UpdateFactions(name)

	for k, v in ipairs(BaseWars:GetFactionMembers(name, true)) do
		BaseWars:Notify(v, "#adminmenu_immunityReset", NOTIFICATION_FACTION, 5)
	end

	BaseWars:Notify(ply, "#adminmenu_doResetImmunity", NOTIFICATION_FACTION, 5, name)

	hook.Run("BaseWars:Factions:Admin:ResetImmunity", ply, name)
end)

net.Receive("BaseWars:Factions:Admin:KickMember", function(len, ply)
	if not BaseWars:IsAdmin(ply, true) then
		return
	end

	local name = net.ReadString()
	local target = net.ReadEntity()

	if not BaseWars:FactionExists(name) then
		return
	end

	if not IsValid(target) then
		return
	end

	BaseWars:RemoveFactionMember(name, target)
	BaseWars:Notify(ply, "#adminmenu_kicked", NOTIFICATION_FACTION, 5, target:Name())

	hook.Run("BaseWars:Factions:Admin:KickMember", ply, target, name)
end)

--[[-------------------------------------------------------------------------
	MARK: Hooks
---------------------------------------------------------------------------]]
hook.Add("BaseWars:SendNetToClient", "BaseWars:FactionConnect", function(ply)
	local data = {}

	for name, factionData in pairs(Factions) do
		local faction = {
			name = name,
			id = factionData.id,
			leader = factionData.leader:SteamID64(),
			color = factionData.color,
			immunity = factionData.immunity,
			ff = factionData.ff,
			members = {}
		}

		for k, v in ipairs(factionData.members) do
			table.insert(faction.members, v:SteamID64())
		end

		table.insert(data, faction)
	end

	local data = util.Compress(util.TableToJSON(data))
	net.Start("BaseWars:Factions:Player:JoinServer")
		net.WriteData(data, #data)
	net.Send(ply)
end)

hook.Add("PlayerDisconnected", "BaseWars:Factions", function(ply)
	if not ply:InFaction() then return end

	local name = ply:GetFaction()
	if not BaseWars:FactionExists(name) then
		return
	end

	if BaseWars:GetFactionLeader(name) == ply then
		for k, v in ipairs(BaseWars:GetFactionMembers(name)) do
			v:SetTeam(1)

			BaseWars:Notify(v, "#faction_leaderDisconnected", NOTIFICATION_FACTION, 5)
		end

		Factions[name] = nil

		BaseWars:UpdateFactions()
	else
		BaseWars:RemoveFactionMember(name, ply)
	end
end)