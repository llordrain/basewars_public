AddCSLuaFile()

SWEP.PrintName = "Heal Gun"
SWEP.Author = "llordrain"
SWEP.Spawnable = true
SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.Weight = 20
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"
SWEP.Category = "BaseWars"
SWEP.FiresUnderwater = true
SWEP.Sound = Sound("items/smallmedkit1.wav")
SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Spread = 0.25
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 0.01
SWEP.Primary.Force = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("smg")
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end

	local ply = self:GetOwner()
	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 512,
		filter = ply
	})

	local ent = tr.Entity
	if IsValid(ent) and ent.GetMaxHealth and ent:GetMaxHealth() > 1 and not ent:IsClass("prop_physics") then
		if ent:Health() >= ent:GetMaxHealth() then return end

		local entityArmor = ent.Armor and ent:Armor()

		local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = ply:GetShootPos()
		bullet.Dir = ply:GetAimVector()
		bullet.Spread = self.Primary.Spread
		bullet.Tracer = 1
		bullet.TracerName = "ToolTracer"
		bullet.Force = self.Primary.Force
		bullet.Damage = self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo

		ply:FireBullets(bullet)

		if SERVER then
			ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + math.Rand(20, 35)))
			if entityArmor then ent:SetArmor(entityArmor) end

			ply:EmitSound(self.Sound, 50, math.min(ent:Health() / ent:GetMaxHealth() * 100, 255, .5))
		end
	end

	self:SetNextPrimaryFire(CurTime() + .05)
end

function SWEP:SecondaryAttack()
	return
end
