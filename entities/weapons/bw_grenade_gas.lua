AddCSLuaFile()

SWEP.PrintName = "Gas grenade"
SWEP.Author = "llordrain"
SWEP.Spawnable = true
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/v_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"
SWEP.Slot = 4
SWEP.SlotPos = 2
SWEP.Weight = 420
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = true
SWEP.Base = "weapon_base"
SWEP.Category = "BaseWars"

SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Ammo = "grenade"
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetHoldType("grenade")

	if SERVER then
		self:SetMaterial("models/dav0r/hoverball")
	end
end

function SWEP:OwnerChanged()
	local ply = self:GetOwner()

	if IsValid(ply) and ply:IsPlayer() and SERVER then
		ply:GiveAmmo(2, "Grenade", true)
	end
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then return end

	self:SetNextPrimaryFire(CurTime() + 2.5)
	self:SetNextSecondaryFire(CurTime() + 2.5)
	self:SendWeaponAnim(ACT_VM_PULLPIN)
	self:TakePrimaryAmmo(1)

	if SERVER then
		timer.Simple(0.5, function()
			if self:IsValid() then
				self:SendWeaponAnim(ACT_VM_THROW)

				local ply = self:GetOwner()

				local gas_grenade = ents.Create("bw_gas_grenade")
				gas_grenade:SetPos(ply:GetShootPos() + Vector(0, 0, -9))
				gas_grenade:SetAngles(ply:GetAimVector():Angle())
				gas_grenade:SetPhysicsAttacker(ply)
				gas_grenade:SetOwner(ply)
				gas_grenade:Spawn()
				gas_grenade.Owner = ply

				gas_grenade:GetPhysicsObject():ApplyForceCenter(ply:GetAimVector() * math.random(3000, 4000) + Vector(0, 0, math.random(100, 150)))
				ply:EmitSound("weapons/ar2/ar2_reload_rotate.wav", 40, 100)

				timer.Simple(0.5,function()
					if self:IsValid() then
						self:SendWeaponAnim(ACT_VM_DRAW)
						self:Reload()
					end
				end)
			end
		end)
	end
end

function SWEP:SecondaryAttack()
	if self:Clip1() <= 0 then return end

	self:SetNextPrimaryFire(CurTime() + 2.5)
	self:SetNextSecondaryFire(CurTime() + 2.5)
	self:SendWeaponAnim(ACT_VM_PULLPIN)
	self:TakePrimaryAmmo(1)

	if SERVER then
		timer.Simple(0.5, function()
			if self:IsValid() then
				self:SendWeaponAnim(ACT_VM_THROW)

				local ply = self:GetOwner()

				local gas_grenade = ents.Create("bw_gas_grenade")
				gas_grenade:SetPos(ply:GetShootPos() + Vector(0, 0, -9))
				gas_grenade:SetAngles(ply:GetAimVector():Angle())
				gas_grenade:SetPhysicsAttacker(ply)
				gas_grenade:SetOwner(ply)
				gas_grenade:Spawn()
				gas_grenade.Owner = ply

				gas_grenade:GetPhysicsObject():ApplyForceCenter(ply:GetAimVector() * math.random(500, 1000) + Vector(0, 0, math.random(100, 150)))
				ply:EmitSound("weapons/ar2/ar2_reload_rotate.wav", 40, 100)

				timer.Simple(0.5,function()
					if self:IsValid() then
						self:SendWeaponAnim(ACT_VM_DRAW)
						self:Reload()
					end
				end)
			end
		end)
	end
end

function SWEP:Holster()
	if SERVER then
		self:SetMaterial("")
	end

	return true
end

function SWEP:PreDrawViewModel(vm)
	Material("models/dav0r/hoverball"):SetVector("$color2", Vector(0.1, 1, 0.1))
end

function SWEP:PostDrawViewModel(vm)
	Material("models/dav0r/hoverball"):SetVector("$color2", Vector(1, 1, 1))
end