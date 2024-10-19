ENT.Base = "bw_base_electronics"
ENT.PrintName = "Basic Printer"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Printers"
ENT.Spawnable = true
ENT.Model = "models/props_c17/consolebox01a.mdl"

ENT.IsPrinter = true
ENT.PresetHealth = 150
ENT.BasePaper = 5000

ENT.Capacity = 10000
ENT.UpgradeCost = 1000
ENT.PrintInterval = 1
ENT.PrintAmount = 8

ENT.Color = Color(40, 40, 40)
ENT.SubColor = Color(60, 60, 60)
ENT.TextColor = Color(255, 255, 255)

function ENT:SetupNetWork()
	self:NetworkVar("Float", 0, "Money")
	self:NetworkVar("Float", 1, "Capacity")

	self:NetworkVar("Float", 2, "PrintAmount")
	self:NetworkVar("Float", 3, "PrintInterval")

	self:NetworkVar("Float", 4, "BaseUpgradePrice")

	self:NetworkVar("Int", 0, "Paper")
	self:NetworkVar("Int", 1, "MaxPaper")

	self:NetworkVar("Int", 2, "PrintAmountLevel")
	self:NetworkVar("Int", 3, "PrintIntervalLevel")
	self:NetworkVar("Int", 4, "CapacityLevel")
	self:NetworkVar("Int", 5, "PaperCapacityLevel")

	self:NetworkVar("Bool", 0, "AutoPaper")

	self:NetworkVar("Entity", 0, "Bank")
end

function ENT:OnUpgrade(ply)
	local trace = ply:GetEyeTrace()
	if trace.Entity != self then return false end
	local pos = self:WorldToLocal(trace.HitPos)

	return pos.y >= -14.61 and pos.y <= .01 and pos.x >= 7.91 and pos.x <= 13.88
end

function ENT:OnBuyPaper(ply)
	local trace = ply:GetEyeTrace()
	if trace.Entity != self then return false end
	local pos = self:WorldToLocal(trace.HitPos)

	return pos.y >= .46 and pos.y <= 15.12 and pos.x >= 7.95 and pos.x <= 13.9
end

function ENT:GetUpgradeCost(upgrade, level)
	return 0
end