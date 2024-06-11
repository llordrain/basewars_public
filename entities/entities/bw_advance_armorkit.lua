AddCSLuaFile()

ENT.Base 		= "bw_base_armorkit"
ENT.Type 		= "anim"
ENT.PrintName 	= "Kit d'armure avancé"
ENT.Category = "BaseWars - Kits"
ENT.Spawnable = true

ENT.HealthMultiplier = 3

if SERVER then
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)

        self:PhysWake()
        self:Activate()

        self:SetColor(Color(50, 50 ,150))
        self:SetModelScale(1.3, .00001)
    end
end