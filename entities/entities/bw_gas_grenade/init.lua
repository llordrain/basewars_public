AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self.Curtime = CurTime()

	self:SetModel(self.Model)
	self:SetMaterial("models/dav0r/hoverball")
	self:SetColor(self.Color)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:PhysWake()
end

function ENT:PhysicsCollide(data, physobj)
	self:EmitSound("physics/metal/weapon_impact_soft" .. (math.random(1, 2)) .. ".wav", 200, 100, 1)
end

function ENT:SpewGas()
	if self.Exploded then return end
	self.Exploded = true

	self:SetMoveType(MOVETYPE_NONE)
	self:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 72, 100)
	self:EmitSound("weapons/ar2/ar2_altfire.wav", 72, 100)

	local gas = EffectData()
	gas:SetOrigin(self:GetPos())
	util.Effect("gasnade_gas", gas)
end

function ENT:Think()
	if CLIENT then return end
	if CurTime() > self.Curtime + 2 then
		if not IsValid(self:GetOwner()) then
			self:Remove()
			return
		end

		self:SpewGas()

		for k, v in next, ents.FindInSphere(self:GetPos(), 170) do
			if not v:IsPlayer() or not v:Alive() then continue end

			local damage = DamageInfo()
			damage:SetDamage(5)
			damage:SetDamageType(DMG_RADIATION)
			damage:SetAttacker(self:GetOwner())
			damage:SetInflictor(self)

			v:TakeDamageInfo(damage)
			v:ScreenFade(SCREENFADE.IN, Color(20, 200, 20, 100), 0.25, 0)
		end
	end

	if CurTime() > self.Curtime + 17 then
		if not IsValid(self) then
			return
		end

		self:Remove()
	end
end