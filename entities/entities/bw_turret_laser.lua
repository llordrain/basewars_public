AddCSLuaFile()

ENT.Base = "bw_base_turret"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Defense"
ENT.Spawnable = true
ENT.PrintName = "Laser Turret"
ENT.Model = "models/Combine_turrets/Floor_turret.mdl"

ENT.Damage = 80
ENT.Range = 1250
ENT.ShootingDelay = 3
ENT.Spread = 2

ENT.Sounds = Sound("npc/strider/fire.wav")

if SERVER then
	function ENT:GetBulletInfo(target, pos)
		local bullet = {
			Attacker = self:CPPIGetOwner(),
			Num = 1,
			Damage = self.Damage,
			Force = 15,
			TracerName = "ToolTracer",
			Spread = Vector(self.Spread, self.Spread, 0),
			Src = self.EyePosOffset,
			Dir = pos - self.EyePosOffset
		}

		return bullet
	end
end
