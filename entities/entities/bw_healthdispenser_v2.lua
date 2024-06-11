AddCSLuaFile()

ENT.Base = "bw_base_healthdispenser"
ENT.Type = "anim"
ENT.PrintName = "Health Dispenser V2"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Dispensers"
ENT.Spawnable = true

ENT.HPAmount = 50
ENT.Extra = 50

if SERVER then
	function ENT:Init()
		self.time = CurTime()

		self:SetColor(Color(100, 100 ,255))

		self:SetUseType(CONTINUOUS_USE)
	end
end