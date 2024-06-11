local PLAYER =  FindMetaTable("Player")

function PLAYER:GetPrestige()
	return self:GetNWInt("BaseWars.Prestige", 0)
end

function PLAYER:GetPrestigePoint()
	return self:GetNWInt("BaseWars.PrestigePoint", 0)
end

function PLAYER:GetPrestigePerk(perkid)
	return self:GetNWInt("BaseWars.PrestigePerk." .. perkid, 0)
end

function PLAYER:CanPrestige(notShow)
	if self:InRaid() then
		if CLIENT and not notShow then
			BaseWars:Notify("#prestige_duringRaid", NOTIFICATION_ERROR, 5)
		else
			BaseWars:Notify(self, "#prestige_duringRaid", NOTIFICATION_ERROR, 5)
		end

		return false
	end

	return self:GetLevel() >= BaseWars.Config.Prestige.BaseLevel + (self:GetPrestige() * BaseWars.Config.Prestige.MoreLevel)
end

function PLAYER:HasPrestige(num)
	return self:GetPrestige() >= num
end

function PLAYER:GetPrestigePointSpent()
	local pointSpent = 0

	for k, v in pairs(BaseWars:GetPrestigePerk()) do
		pointSpent = pointSpent + self:GetPrestigePerk(k) * v.cost
	end

	return pointSpent
end

local prestigePerks = {}
function BaseWars:AddPrestigPerk(id, level, cost, func)
	func = func or function() end

	prestigePerks[id] = {
		max = level,
		cost = cost,
		func = func
	}
end

function BaseWars:GetPrestigePerk()
	return table.Copy(prestigePerks)
end

function BaseWars:ExecutePrestigePerkFunc()
	if BaseWars.Config.Prestige.Enable then
		for k, v in pairs(prestigePerks) do
			v.func()
		end
	end
end