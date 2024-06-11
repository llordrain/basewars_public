AddCSLuaFile()

ENT.Base = "bw_base_ammodispenser"
ENT.Type = "anim"
ENT.PrintName = "Ammo Dispenser V2"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Dispensers"
ENT.Spawnable = true

ENT.AmmoAmount = 150

if SERVER then
	function ENT:Init()
		self.time = CurTime()

		self:SetColor(Color(100, 100 ,255))
		self:SetUseType(CONTINUOUS_USE)
	end
end