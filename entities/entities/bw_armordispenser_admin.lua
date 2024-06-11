AddCSLuaFile()

ENT.Base = "bw_base_armordispenser"
ENT.Type = "anim"
ENT.PrintName = "Armor Dispenser Admin"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Dispensers"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.ArmorAmount = 5000
ENT.Extra = 2000000000
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