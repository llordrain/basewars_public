local PLAYER = FindMetaTable("Player")
local levelPower = 1.3

function PLAYER:GetLevel()
	return self:GetNWInt("BaseWars.Level", 0)
end

function PLAYER:GetXP()
	return self:GetNWFloat("BaseWars.XP", 0)
end

function PLAYER:GetXPNextLevel()
	return math.floor(100 * self:GetLevel() ^ levelPower)
end

function PLAYER:HasLevel(level)
	return self:GetLevel() >= level
end

function BaseWars:GetLevelXP(level)
	return math.floor(100 * level ^ levelPower)
end

function BaseWars:CalculateXPFromMultiplier(num)
	return num * .004
end

function BaseWars:CalculatePlayerXP(ply, xp)
	if not IsValid(ply) then
		return 0
	end

	if not BaseWars.Config.Prestige.Enable then
		return xp
	end

	return xp * (1 + ply:GetPrestigePerk("moreXP") * .05)
end