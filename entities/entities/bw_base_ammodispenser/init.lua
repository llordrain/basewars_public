AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Init()
	self.time = CurTime()

	self:SetUseType(CONTINUOUS_USE)
	self:Activate()
end

function ENT:Use(ply)
	if not IsValid(ply) then return end
	if self.time + (self.Cooldown or BaseWars.Config.DispenserCooldown) > CurTime() then return end

	self.time = CurTime()

	local weap = ply:GetActiveWeapon()

	if IsValid(weap) then
		local ammo1 = weap:GetPrimaryAmmoType()
		local ammo2 = weap:GetSecondaryAmmoType()

		if ammo1 then
			ply:GiveAmmo(self.AmmoAmount, ammo1)
			self:EmitSound(self.Sound, 100, 60)
		end

		if ammo2 then
			ply:GiveAmmo(self.AmmoAmount, ammo2)
		end
	end
end