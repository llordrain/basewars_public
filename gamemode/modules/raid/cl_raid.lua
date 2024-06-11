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
	MARK: Global Functions
---------------------------------------------------------------------------]]
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
	MARK: Nets
---------------------------------------------------------------------------]]
net.Receive("BaseWars:Raid:SendRaidDataToClient", function(len)
	local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

	local attackers = {}
	for k, v in ipairs(data.attacker.players) do
		attackers[BaseWars:FindPlayer(v)] = true
	end
	data.attacker.players = attackers

	local defenders = {}
	for k, v in ipairs(data.defender.players) do
		defenders[BaseWars:FindPlayer(v)] = true
	end
	data.defender.players = defenders

	raidData = data
end)