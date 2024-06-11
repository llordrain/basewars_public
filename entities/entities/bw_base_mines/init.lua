AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	self:PhysWake()

	self:SetMaxHealth(self.PresetHealth)
	self:SetHealth(self:GetMaxHealth())
	self:SetArmed(false)
	self:SetTriggered(false)
end

function ENT:Use(ply)
	if not (ply and ply:IsPlayer()) then return end

	if self:GetArmed() or self:GetTriggered() then return end

	self:SetArmed(true)
	self:EmitSound(self.ArmSound)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function ENT:Trigger()
	self:SetTriggered(true)
	self:EmitSound(self.TriggerSound)

	timer.Simple(self.TriggerDelay, function()
		if IsValid(self) then
			self:Explode()
		end
	end)
end

function ENT:Explode()
	util.BlastDamage(self, self, self:GetPos(), math.Clamp(self.ExplodeRadius, 0, 500), self.ExplodeRadius)
	SafeRemoveEntity(self)
end

function ENT:Think()
	if not self:GetArmed() or self:GetTriggered() then return end

	local owner = self:CPPIGetOwner()
	if not owner then return end

	for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.DetectRange)) do
		if v:IsPlayer() and v:Alive() and owner:Enemy(v) then
			self:Trigger()
			break
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self:GetTriggered() then return end

	local dmg = dmginfo:GetDamage()

	self:SetHealth(self:Health() - dmg)

	if self:Health() <= 0 then
		self:Trigger()
	end
end