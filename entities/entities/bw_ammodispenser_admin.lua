AddCSLuaFile()

ENT.Base = "bw_base_ammodispenser"
ENT.Type = "anim"
ENT.PrintName = "Ammo Dispenser Admin"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Dispensers"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.AmmoAmount = 2000
ENT.Cooldown = 0

ENT.PresetHealth = 2147483647

if SERVER then
	function ENT:Init()
		self.time = CurTime()

		self:SetUseType(CONTINUOUS_USE)
	end

	function ENT:Think()
		self:SetColor(HSVToColor(CurTime() % 6 * 60, 1, 1))
		self:NextThink(CurTime())
		return true
	end
end