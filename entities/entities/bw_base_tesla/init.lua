AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Init()
	self:SetMaterial(self.Material)

	self.time = CurTime()
end

function ENT:ThinkFunc()
	local owner = self:CPPIGetOwner()

	if self.time + self.Delay <= CurTime() then
		for k, ply in pairs(ents.FindInSphere(self:GetPos(), self.Radius)) do
			if not ply:IsPlayer() then continue end
			if ply:HasGodMode() or not ply:Enemy(owner) or not ply:Alive() then continue end

			local damage = DamageInfo()
			damage:SetDamage(self.Damage)
			damage:SetDamageType(DMG_SHOCK)
			damage:SetAttacker(self:CPPIGetOwner())
			damage:SetInflictor(self)
			ply:TakeDamageInfo(damage)

			ply:ScreenFade(SCREENFADE.IN, self.Color, 0.5, 0)

			local effect = EffectData()
			effect:SetStart(self:GetPos())
			effect:SetOrigin(self:GetPos())
			effect:SetScale(1)
			util.Effect("cball_explode", effect)

			self:EmitSound(self.Sound, 100, 70)
		end

		self.time = CurTime()
	end
end