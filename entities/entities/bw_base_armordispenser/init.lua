AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Init()
	self.time = CurTime()

	self:SetUseType(CONTINUOUS_USE)
end

function ENT:Use(ply)
	if not IsValid(ply) then return end
	if self.time + (self.Cooldown or BaseWars.Config.DispenserCooldown) > CurTime() then return end

	self.time = CurTime()

	ply:SetArmor(math.Clamp(ply:Armor() + self.ArmorAmount, 0, ply:GetMaxArmor() + self.Extra))

	self:EmitSound(self.Sound, 100, 60)
end