local PLAYER = FindMetaTable("Player")

function PLAYER:GetFaction(ply)
	if self:InFaction() then
		return team.GetName(self:Team())
	end

	if ply and ply:IsPlayer() then
		return ply:GetLang("faction_noFaction")
	end

	return self:GetLang("faction_noFaction")
end


function PLAYER:GetFactionColor()
	return team.GetColor(self:Team())
end

function PLAYER:HasSameFaction(ply)
	if not self:InFaction() then
		return false
	end

	if not ply:InFaction() then
		return false
	end

	if not ply or not ply:IsPlayer() then
		return false
	end

	if not ply:InFaction() then
		return false
	end

	return self:GetFaction() == ply:GetFaction()
end

function PLAYER:InFaction()
	return self:Team() > 1
end

function PLAYER:IsFactionLeader()
	if not self:InFaction() then
		return false
	end

	local factionData = BaseWars:GetFactions(self:GetFaction())
	if not factionData then
		return false
	end

	return factionData.leader == self
end

function BaseWars:FactionExists(name)
	return BaseWars:GetFactions(name) != nil
end