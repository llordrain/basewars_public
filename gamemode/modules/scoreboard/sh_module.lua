local PLAYER = FindMetaTable("Player")

function PLAYER:IsGodmode()
    return self:GetNWBool("BaseWars.Godmode", false)
end

function PLAYER:IsCloak()
    return self:GetNWBool("BaseWars.Cloak", false)
end

function PLAYER:IsNocliping()
    return self:GetMoveType() == MOVETYPE_NOCLIP
end