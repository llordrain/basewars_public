AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

local PLAYER = FindMetaTable("Player")

ENT.A = Vector(-4150, 6720, -200)
ENT.B = Vector(-2900, 4950, 500)

function ENT:Initialize()
    self:SetSolid(SOLID_BBOX)
    self:SetCollisionBoundsWS(self.A, self.B)

    BaseWars:Log("Safe Zone Created!")
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

function PLAYER:SetSafeZone(bool)
    self:SetNWBool("BaseWars.SafeZone", bool or false)
end

hook.Add("InitPostEntity", "BaseWars:SafeZone", function()
    local safeZone = ents.Create("safe_zone")
    safeZone:Spawn()
end)