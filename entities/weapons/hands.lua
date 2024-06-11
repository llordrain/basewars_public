AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.PrintName = "Hands"

SWEP.Slot = 0
SWEP.SlotPos = 3
SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 90
SWEP.Category = "BaseWars"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:ShouldDrawViewModel()
	return false
end

function SWEP:Deploy()
	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end
