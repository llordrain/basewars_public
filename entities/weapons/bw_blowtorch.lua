AddCSLuaFile()

SWEP.PrintName = "Blowtorch"
SWEP.Author = "llordrain"
SWEP.Spawnable = true
SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
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
SWEP.Range = 80
SWEP.Sounds = {
	"ambient/energy/spark1.wav",
	"ambient/energy/spark2.wav",
	"ambient/energy/spark3.wav",
	"ambient/energy/spark4.wav",
	"ambient/energy/spark5.wav",
	"ambient/energy/spark6.wav"
}

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
	if not BaseWars:RaidGoingOn() then return false end

	local ply = self:GetOwner()
	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * self.Range,
		filter = ply
	})

	local ent = tr.Entity
	if not IsValid(ent) or not ent:IsClass("prop_physics") then
		return
	end

	local entityOwner = ent:CPPIGetOwner()
	if not ((IsValid(ply) and ply:IsPlayer()) and (IsValid(entityOwner) and entityOwner:IsPlayer())) then
		return
	end

	if entityOwner == ply or not entityOwner:Enemy(ply) then
		return
	end

	self:ShootEffects()
	if SERVER and IsFirstTimePredicted() then
		ent:SetHealth(ent:Health() - math.Rand(25, 40))

		if ent:Health() <= 0 then
			ent:Remove()
		end

		ply:EmitSound(table.Random(self.Sounds), 60)
	end

	self:SetNextPrimaryFire(CurTime() + 0.2)
end