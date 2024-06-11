AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	if not IsValid(ent) then
		return
	end

	if ent:GetMaxHealth() <= 0 or ent:Health() >= ent:GetMaxHealth() then
		return
	end

	ent:SetHealth(ent:GetMaxHealth())
	SafeRemoveEntity(self)
end