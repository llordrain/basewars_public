AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Init()
end

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	self:PhysWake()

	self:SetHealth(self.PresetHealth or 100)
	self:SetMaxHealth(self:Health())

	self:Init()
end

function ENT:OnTakeDamage(damageInfo)
	BaseWars:EntityTakeDamage(self, damageInfo, function()
		self:Explode()
	end)
end

function ENT:Explode()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
		if not v:IsPlayer() then continue end
		local dist = (300 - self:GetPos():Distance(v:GetPos())) * .01
		local damages = DamageInfo()
		damages:SetDamage(5 * dist)
		damages:SetInflictor(self)
		damages:SetAttacker(self:CPPIGetOwner())
		v:TakeDamageInfo(damages)
	end

	SafeRemoveEntity(self)
end

function ENT:Spark()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin(vPoint)
	util.Effect("ManhackSparks", effectdata)
	self:EmitSound("DoSpark")
end