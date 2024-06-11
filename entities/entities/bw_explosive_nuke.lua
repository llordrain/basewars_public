AddCSLuaFile()

ENT.Base = "bw_base_explosive"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Explosive"
ENT.PrintName = "Nuke"
ENT.Spawnable = true
ENT.Model = "models/props_phx/mk-82.mdl"

ENT.ExplodeTime = 120
ENT.ExplosionRadius = 1200
ENT.Damages = 6000
ENT.Defuse = 50

if SERVER then
	function ENT:ExplosionEffect()
		local pos = self:GetPos()
		ParticleEffect("explosion_huge_b", pos + Vector(0, 0, 32), Angle())
		ParticleEffect("explosion_huge_c", pos + Vector(0, 0, 32), Angle())
		ParticleEffect("explosion_huge_c", pos + Vector(0, 0, 32), Angle())
		ParticleEffect("explosion_huge_g", pos + Vector(0, 0, 32), Angle())
		ParticleEffect("explosion_huge_f", pos + Vector(0, 0, 32), Angle())
		ParticleEffect("hightower_explosion", pos + Vector(0, 0, 10), Angle())
		ParticleEffect("mvm_hatch_destroy", pos + Vector(0, 0, 32), Angle())

		for _, ply in pairs(ents.FindInSphere(self:GetPos(), self.ExplosionRadius)) do
			if not IsValid(ply) then continue end
			if not ply:IsPlayer() then continue end
			if ply:IsGodmode() or not ply:InRaid() then continue end

			ply:ScreenFade(SCREENFADE.OUT, color_white, 0.2, 2)
			ply:EmitSound("ambient/explosions/explode_5.wav", 140, 50, 1)
			ply:EmitSound("ambient/explosions/explode_4.wav", 140, 50, 1)
			ply:SetDSP(37)
		end
	end
end