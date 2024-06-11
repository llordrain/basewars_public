AddCSLuaFile()

SWEP.PrintName = "C4"
SWEP.Author = "llordrain"
SWEP.Slot 	= 5
SWEP.SlotPos = 3
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.ViewModelFOV = 54
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
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local tr = util.TraceLine({
	start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 128,
		filter = self:GetOwner()
	})

	if not tr.Hit then
		return
	end

	local ent = tr.Entity
	if not ent:IsPlayer() and not ent:IsNPC() then
		local c4 = ents.Create("bw_explosive_c4")
		local pos = tr.HitPos + tr.HitNormal * 2
		local ang = tr.HitNormal:Angle()

		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), 180)

		c4:SetPos(pos)
		c4:SetAngles(ang)
		c4:Spawn()
		c4:Activate()
		c4:CPPISetOwner(self:GetOwner())
		c4:PlantOn(not ent:IsWorld() and ent)

		self:GetOwner():StripWeapon(self:GetClass())
	end

	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
end