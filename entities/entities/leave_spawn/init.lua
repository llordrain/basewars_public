AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

ENT.A = Vector(-2910, 6310, -5)
ENT.B = Vector(-3255, 6045, 430)

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBoundsWS(self.A, self.B)
end

function ENT:StartTouch(ent)
    if IsValid(ent) and ent:IsPlayer() then
        ent:SetPos(Vector(math.Rand(4930, 4640), math.Rand(-2080, -1755), -350))
        ent:SetEyeAngles(Angle(0, 90, 0))
    end
end

function ENT:EndTouch(ent)
    if IsValid(ent) and ent:IsPlayer() then
        hook.Run("BaseWars:PlayerLeaveSafeZone", ent)
    end
end

function ENT:Touch(ent)
end

hook.Add("InitPostEntity", "BaseWars:LeaveSpawn", function()
    local leaveSpawn = ents.Create("leave_spawn")
    leaveSpawn:Spawn()
end)