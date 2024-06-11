local PLAYER = FindMetaTable("Player")

function PLAYER:GetBounty()
    return self:GetNWFloat("BaseWars.Bounty", 0)
end

function PLAYER:HasBounty()
    return self:GetBounty() > 0
end