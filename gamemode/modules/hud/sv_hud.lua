local PLAYER = FindMetaTable("Player")

function PLAYER:SetHasRadar(bool)
	self:SetNWBool("BaseWars.HasRadar", bool or false)
end

function PLAYER:SetSpawnProtection(time)
	self:SetNWFloat("BaseWars.SpawnImmun", time or 0)
end