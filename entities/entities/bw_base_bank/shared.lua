ENT.Base = "bw_base_electronics"
ENT.PrintName = "Bank"
ENT.Author = "llordrain"
ENT.Category = "BaseWars"
ENT.Spawnable = true
ENT.Model = "models/props_c17/consolebox01a.mdl"

ENT.IsBank = true
ENT.PresetHealth = 300
ENT.Color = Color(0, 0, 0)
ENT.SubColor = Color(60, 60, 60)
ENT.TextColor = Color(255, 255, 255)

function ENT:SetupNetWork()
	self:NetworkVar("Float", 0, "Money")
	self:NetworkVar("Float", 1, "Capacity")
	self:NetworkVar("Float", 2, "Printing")
	self:NetworkVar("Float", 3, "CapacityCost")
	self:NetworkVar("Float", 4, "HealthCost")

	self:NetworkVar("Int", 0, "PrinterCount")
	self:NetworkVar("Int", 1, "CapacityLevel")
	self:NetworkVar("Int", 2, "HealthLevel")

	self:NetworkVar("Bool", 0, "Refund")
end

function ENT:OnUpgrade(ply)
	local trace = ply:GetEyeTrace()
	if trace.Entity != self then return false end
	local pos = self:WorldToLocal(trace.HitPos)

	if pos.y >= -14.61 and pos.y <= 15.12 and pos.x >= 7.91 and pos.x <= 13.88 then
		return true
	end

	return false
end