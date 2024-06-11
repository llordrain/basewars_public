AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBoundsWS(BaseWars.Config.SpawnSafeZone.PointA, BaseWars.Config.SpawnSafeZone.PointB)

    BaseWars:ServerLog("Safe Zone Created!")
end

function ENT:StartTouch(ent)
    if IsValid(ent) and ent:IsPlayer() then
        ent:SetSafeZone(true)
    end
end

function ENT:EndTouch(ent)
    if IsValid(ent) and ent:IsPlayer() then
        ent:SetSafeZone(false)
    end
end

function ENT:Touch(ent)
    if IsValid(ent) and ent:IsPlayer() and not ent:InSafeZone() then
        ent:SetSafeZone(true)
    end
end