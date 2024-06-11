local PLAYER = FindMetaTable("Player")
local Factions = {}

--[[-------------------------------------------------------------------------
	MARK: Global Functions
---------------------------------------------------------------------------]]
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

--[[-------------------------------------------------------------------------
	MARK: Player Function
---------------------------------------------------------------------------]]
function PLAYER:CreateFaction(name, password, color)
	name = string.Trim(name or "")

	if name == "" then
		return
	end

	password = string.Trim(password or "")
	color = ColorAlpha(color or HSVToColor(math.random(360), math.Rand(.6, 1), math.Rand(.6, 1)), 255)

	net.Start("BaseWars:Factions:Player:CreateFaction")
		net.WriteString(name)
		net.WriteString(password)
		net.WriteColor(color)
	net.SendToServer()
end

function PLAYER:JoinFaction(name, password)
	net.Start("BaseWars:Factions:Player:JoinFaction")
		net.WriteString(name)
		net.WriteString(password)
	net.SendToServer()
end

function PLAYER:QuitFaction()
	net.Start("BaseWars:Factions:Player:QuiFaction")
	net.SendToServer()
end

function PLAYER:ChangeFactionPassword(password)
	net.Start("BaseWars:Factions:Player:ChangePassword")
		net.WriteString(password)
	net.SendToServer()
end

function PLAYER:KickPlayerFromFaction(ply)
	net.Start("BaseWars:Factions:Player:KickPlayer")
		net.WriteEntity(ply)
	net.SendToServer()
end

function PLAYER:TransferFactionLeadership(ply)
	net.Start("BaseWars:Factions:Player:TransferLeadership")
		net.WriteEntity(ply)
	net.SendToServer()
end

function PLAYER:ChangeFactionFriendlyFire(bool)
	net.Start("BaseWars:Factions:Player:ToggleFriendlyFire")
		net.WriteBool(bool)
	net.SendToServer()
end

--[[-------------------------------------------------------------------------
	MARK: Nets
---------------------------------------------------------------------------]]
net.Receive("BaseWars:Factions:Player:CreateFaction", function(len)
	local factionData = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	local name = factionData.name
	local id = factionData.id
	local color = Color(factionData.color.r, factionData.color.g, factionData.color.b)

	team.SetUp(id, name, color)
	Factions[name] = {
		id = id,
		leader = factionData.leader,
		color = color,
		immunity = factionData.immunity,
		ff = factionData.ff,
		members = factionData.members
	}

	BaseWars:UpdateAdminMenuFactions()
end)

net.Receive("BaseWars:Factions:Player:JoinServer", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	Factions = {}

    for _, factionData in ipairs(data) do
		local name = factionData.name
		local id = factionData.id
		local color = Color(factionData.color.r, factionData.color.g, factionData.color.b)

		team.SetUp(id, name, color)

		local faction = {
			id = id,
			leader = BaseWars:FindPlayer(factionData.leader),
			color = color,
			immunity = factionData.immunity,
			ff = factionData.ff,
			members = {}
		}

		for k, v in ipairs(factionData.members) do
			local ply = BaseWars:FindPlayer(v)

			if not IsValid(ply) then
				continue
			end

			table.insert(faction.members, ply)
		end

		Factions[name] = faction
	end

	BaseWars:UpdateAdminMenuFactions()
end)

net.Receive("BaseWars:Factions:Player:UpdateServer", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	Factions = {}

    for _, factionData in ipairs(data) do
		local faction = {
			id = factionData.id,
			leader = BaseWars:FindPlayer(factionData.leader),
			color = Color(factionData.color.r, factionData.color.g, factionData.color.b),
			immunity = factionData.immunity,
			ff = factionData.ff,
			members = {}
		}

		for k, v in ipairs(factionData.members) do
			local ply = BaseWars:FindPlayer(v)

			if not IsValid(ply) then
				continue
			end

			table.insert(faction.members, ply)
		end

		Factions[factionData.name] = faction
	end

	BaseWars:UpdateAdminMenuFactions()
end)

net.Receive("BaseWars:Factions:Player:UpdateServer:Single", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	local faction = {
		id = data.id,
		leader = BaseWars:FindPlayer(data.leader),
		color = Color(data.color.r, data.color.g, data.color.b, 255),
		immunity = data.immunity,
		ff = data.ff,
		members = {}
	}

	for k, v in ipairs(data.members) do
		local ply = BaseWars:FindPlayer(v)

		if not IsValid(ply) then
			continue
		end

		table.insert(faction.members, ply)
	end

    Factions[data.name] = faction

	BaseWars:UpdateAdminMenuFactions()
end)

--[[-------------------------------------------------------------------------
	MARK: In Faction Highlight
---------------------------------------------------------------------------]]
hook.Add("PreDrawHalos", "AddStaffHalos", function()
	local ply = LocalPlayer()

	if not ply:GetBaseWarsConfig("factionHighlight") then return end
	if not ply:InFaction() then return end

	local factionMembers = {}
	for k, v in player.Iterator() do
		if v == ply then continue end

		if ply:HasSameFaction(v) then
			table.insert(factionMembers, v)
		end
	end

	halo.Add(factionMembers, ply:GetFactionColor(), 2, 2, 5, true, true)
end)