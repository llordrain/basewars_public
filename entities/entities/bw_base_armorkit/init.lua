AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()
	self:Activate()
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if not IsValid(ent) then return end
	if ent.HasArmorKit then return end

	if ent.IsElectronic or ent.DestroyableProp then
		ent.HasArmorKit = true

		ent:SetMaxHealth(ent:GetMaxHealth() * self.HealthMultiplier)
		ent:SetHealth(ent:GetMaxHealth())

		self:Remove()
	end
end