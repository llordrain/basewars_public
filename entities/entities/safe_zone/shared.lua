ENT.Base = "base_brush"
ENT.Type = "brush"

local PLAYER = FindMetaTable("Player")

function PLAYER:InSafeZone()
    return self:GetNWBool("BaseWars.SafeZone", false)
end