AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("BaseWars:Printer:OpenUpgradeMenu")
util.AddNetworkString("BaseWars:Printer:BuyUpgrade")
util.AddNetworkString("BaseWars:Printer:BuyPaperFromMenu")
util.AddNetworkString("BaseWars:Printer:QuickUpgrade")
util.AddNetworkString("BaseWars:Printer:TakeMoneyMenu")

function ENT:Init()
	self:SetMaxEnergy(500)
	self:SetEnergy(self:GetMaxEnergy())

	self:SetMoney(0)
	self:SetCapacity(self.Capacity)
	self:SetPrintAmount(self.PrintAmount)
	self:SetPrintInterval(self.PrintInterval)
	self:SetupPrinterCost(1000)
	self:SetConnectedToBank(false)

	self:SetMaxPaper(5000)
	self:SetPaper(self:GetMaxPaper())

	self:SetPILevel(0)
	self:SetPALevel(0)
	self:SetCLevel(0)
	self:SetPCLevel(0)
	self:SetAutoPaper(false)

	self:SetRefund(true)

	self.BasePaper = 5000
	self.PrintTime = CurTime()
	self.Withdraw = CurTime()
	self.TakeMoney = CurTime()
end

function ENT:SetupPrinterCost(amount)
	self:SetPACost(amount)
	self:SetPICost(amount)
	self:SetPCCost(amount)
	self:SetCapacityCost(amount)
	self:SetAutoPaperCost(amount * 5)
	self:SetBaseCost(amount)
end

function ENT:PrintMoney()
	if not IsValid(self:CPPIGetOwner()) then return end
	if self:GetMoney() >= self:GetCapacity() then return end
	if self:GetPaper() <= 0 then return end

	local printed = self:GetPrintAmount()
	local added = math.Clamp(self:GetMoney() + printed, 0, self:GetCapacity())

	self:SetMoney(added)
	self:SetPaper(self:GetPaper() - 1)
end

function ENT:WithdrawMoney(ply, bypassPrivate)
	if not (bypassPrivate and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	if CurTime() < self.Withdraw + .5 then return end
	self.Withdraw = CurTime()

	local money = self:GetMoney()
	local xp = math.floor(BaseWars:CalculatePlayerXP(ply, BaseWars:CalculateXPFromMultiplier(money) * BaseWars.Config.XPMult))

	if money <= 0 then
		return
	end

	ply:AddMoney(money)
	ply:AddXP(xp)
	self:SetMoney(0)

	hook.Run("BaseWars:PlayerTakeMoneyInPrinter", ply, self, money, xp)
end

function ENT:Use(ply)
	if not (ply and ply:IsPlayer()) then return end

	if self:OnBuyPaper(ply) then
		self:RefillPaper(ply)
	elseif self:OnUpgrade(ply) then
		net.Start("BaseWars:Printer:OpenUpgradeMenu")
			net.WriteEntity(self)
		net.Send(ply)
	else
		self:WithdrawMoney(ply)
	end
end

function ENT:OnRemove()
	if not self:GetRefund() then return end

	local selfOwner = self:CPPIGetOwner()
	if IsValid(selfOwner) then
		self:WithdrawMoney(selfOwner)
	end
end

function ENT:UpgradeInterval(ply, max)
	if self:GetPILevel() >= BaseWars.Config.PrinterMaxLevel["interval"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	local levelToGo = max and BaseWars.Config.PrinterMaxLevel["interval"] - self:GetPILevel() or 1
	local baseCost = self:GetBaseCost()
	local totalCost = 0
	local level = self:GetPILevel()
	local upgrades = 0

	while upgrades < levelToGo do
		if level + upgrades >= BaseWars.Config.PrinterMaxLevel["interval"] then
			break
		end

		if not ply:CanAfford(baseCost * (level + upgrades + 1)) then
			break
		end

		upgrades = upgrades + 1

		totalCost = totalCost + baseCost * (level + upgrades)

		self:SetPILevel(level + upgrades)
		self:SetPrintInterval(self:GetPrintInterval() - .05)

		ply:TakeMoney(baseCost * (level + upgrades))
		self:SetPICost(baseCost * (level + upgrades + 1))

		self:SetCurrentValue(self:GetCurrentValue() + baseCost * (level + upgrades))
	end

	if upgrades == 0 then
		return
	end

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, self, "interval", upgrades, totalCost)

	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", "intervalName"), upgrades, BaseWars:FormatMoney(totalCost))
end

function ENT:UpgradeAmount(ply, max)
	if self:GetPALevel() >= BaseWars.Config.PrinterMaxLevel["amount"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	local levelToGo = max and BaseWars.Config.PrinterMaxLevel["amount"] - self:GetPALevel() or 1
	local baseCost = self:GetBaseCost()
	local totalCost = 0
	local level = self:GetPALevel()
	local upgrades = 0

	while upgrades < levelToGo do
		if level + upgrades >= BaseWars.Config.PrinterMaxLevel["amount"] then
			break
		end

		if not ply:CanAfford(baseCost * (level + upgrades + 1)) then
			break
		end

		upgrades = upgrades + 1

		totalCost = totalCost + baseCost * (level + upgrades)

		self:SetPALevel(level + upgrades)
		self:SetPrintAmount(self.PrintAmount * ((level + upgrades) + 1) ^ 1.6)

		ply:TakeMoney(baseCost * (level + upgrades))
		self:SetPACost(baseCost * (level + upgrades + 1))

		self:SetCurrentValue(self:GetCurrentValue() + baseCost * (level + upgrades))
	end

	if upgrades == 0 then
		return
	end

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, self, "amount", upgrades, totalCost)

	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", "amountName"), upgrades, BaseWars:FormatMoney(totalCost))
end

function ENT:UpgradeCapacity(ply, max)
	if self:GetCLevel() >= BaseWars.Config.PrinterMaxLevel["capacity"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	local levelToGo = max and BaseWars.Config.PrinterMaxLevel["capacity"] - self:GetCLevel() or 1
	local baseCost = self:GetBaseCost()
	local totalCost = 0
	local level = self:GetCLevel()
	local upgrades = 0

	while upgrades < levelToGo do
		if level + upgrades >= BaseWars.Config.PrinterMaxLevel["capacity"] then
			break
		end

		if not ply:CanAfford(baseCost * (level + upgrades + 1)) then
			break
		end

		upgrades = upgrades + 1

		totalCost = totalCost + baseCost * (level + upgrades)

		self:SetCLevel(level + upgrades)
		self:SetCapacity(self.Capacity * ((level + upgrades) * 4))

		ply:TakeMoney(baseCost * (level + upgrades))
		self:SetCapacityCost(baseCost * (level + upgrades + 1))

		self:SetCurrentValue(self:GetCurrentValue() + baseCost * (level + upgrades))
	end

	if upgrades == 0 then
		return
	end

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, self, "capacity", upgrades, totalCost)

	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", "capacityName"), upgrades, BaseWars:FormatMoney(totalCost))
end

function ENT:UpgradePaperCapacity(ply, max)
	if self:GetPCLevel() >= BaseWars.Config.PrinterMaxLevel["paperCapacity"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	local levelToGo = max and BaseWars.Config.PrinterMaxLevel["paperCapacity"] - self:GetPCLevel() or 1
	local baseCost = self:GetBaseCost()
	local totalCost = 0
	local level = self:GetPCLevel()
	local upgrades = 0

	while upgrades < levelToGo do
		if level + upgrades >= BaseWars.Config.PrinterMaxLevel["paperCapacity"] then
			break
		end

		if not ply:CanAfford(baseCost * (level + upgrades + 1)) then
			break
		end

		upgrades = upgrades + 1

		totalCost = totalCost + baseCost * (level + upgrades)

		self:SetPCLevel(level + upgrades)
		self:SetMaxPaper(self.BasePaper + (level + upgrades) * 1000)

		ply:TakeMoney(baseCost * (level + upgrades))
		self:SetPCCost(baseCost * (level + upgrades + 1))

		self:SetCurrentValue(self:GetCurrentValue() + baseCost * (level + upgrades))
	end

	if upgrades == 0 then
		return
	end

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, self, "paperCapacity", upgrades, totalCost)

	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", "paperCapacityName"), upgrades, BaseWars:FormatMoney(totalCost))
end

function ENT:UpgradeAutoPaper(ply, max)
	if not BaseWars:IsVIP(ply) then
		BaseWars:Notify(ply, "#printer_VIPOnly", NOTIFICATION_ERROR, 5)
		return
	end

	if self:GetAutoPaper() then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	local cost = self:GetAutoPaperCost()
	if not ply:CanAfford(cost) then
		BaseWars:Notify(ply, "#printer_cantAffordUpgrade", NOTIFICATION_ERROR, 5)
		return
	end

	self:SetAutoPaper(true)
	ply:TakeMoney(cost)
	self:SetCurrentValue(self:GetCurrentValue() + cost)

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, self, "autoPaper", 1, cost)

	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", "autoPaperName"), "1", BaseWars:FormatMoney(cost))
end

function ENT:RefillPaper(ply, bypassPrivate)
	if not (bypassPrivate and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	local paperNeeded = self:GetMaxPaper() - self:GetPaper()
	if paperNeeded == 0 then return end

	local paperPrice = BaseWars.Config.PrinterPaperPrice

	local toBuy = 0
	local price = 0
	for i = 1, paperNeeded do
		if not ply:CanAfford(price + paperPrice) then break end

		toBuy = toBuy + 1
		price = price + paperPrice
	end

	if toBuy > 0 then
		self:SetPaper(self:GetPaper() + toBuy)
		ply:TakeMoney(price)

		hook.Run("BaseWars:PlayerBuyPrinterPaper", ply, self, toBuy, price)

		BaseWars:Notify(ply, "Vous avez acheté " .. BaseWars:FormatNumber(toBuy) .. " papier pour " .. BaseWars:FormatMoney(price) .. ".", NOTIFICATION_PURCHASE, 5)
	end
end

function ENT:Think()
	self:NextThink(CurTime())

	if not IsValid(self:CPPIGetOwner()) then return end
	if self:BadlyDamaged() and math.random(0, 10) == 0 then
		self:Spark()
		return
	end

	if CurTime() >= self.PrintTime then
		if self:GetAutoPaper() and self:GetPaper() <= 0 then
			self:RefillPaper(self:CPPIGetOwner())
		end

		self:PrintMoney()
		self.PrintTime = CurTime() + self:GetPrintInterval()
	end

	return true
end

net.Receive("BaseWars:Printer:BuyUpgrade", function(len, ply)
	local printer = net.ReadEntity()
	local upgradeID = net.ReadUInt(3)
	local max = net.ReadBool()
	local superAdminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	if not (superAdminBypass and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and printer:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	if upgradeID == 1 then
		printer:UpgradeInterval(ply, max)
	elseif upgradeID == 2 then
		printer:UpgradeAmount(ply, max)
	elseif upgradeID == 3 then
		printer:UpgradeCapacity(ply, max)
	elseif upgradeID == 4 then
		printer:UpgradePaperCapacity(ply, max)
	elseif upgradeID == 5 then
		printer:UpgradeAutoPaper(ply)
	end
end)

net.Receive("BaseWars:Printer:QuickUpgrade", function(len, ply)
	local printer = net.ReadEntity()
	local upgrades = net.ReadTable()
	local superAdminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	if not (superAdminBypass and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and printer:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	if upgrades[1] and printer:GetPILevel() < BaseWars.Config.PrinterMaxLevel["interval"] then
		printer:UpgradeInterval(ply, true)
	end

	if upgrades[2] and printer:GetPALevel() < BaseWars.Config.PrinterMaxLevel["amount"] then
		printer:UpgradeAmount(ply, true)
	end

	if upgrades[3] and printer:GetCLevel() < BaseWars.Config.PrinterMaxLevel["capacity"] then
		printer:UpgradeCapacity(ply, true)
	end

	if upgrades[4] and printer:GetPCLevel() < BaseWars.Config.PrinterMaxLevel["paperCapacity"] then
		printer:UpgradePaperCapacity(ply, true)
	end

	if upgrades[5] and not printer:GetAutoPaper() then
		printer:UpgradeAutoPaper(ply)
	end
end)

net.Receive("BaseWars:Printer:BuyPaperFromMenu", function(len, ply)
	local printer = net.ReadEntity()
	local superAdminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	printer:RefillPaper(ply, superAdminBypass)
end)

net.Receive("BaseWars:Printer:TakeMoneyMenu", function(len, ply)
	local printer = net.ReadEntity()
	local superAdminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	printer:WithdrawMoney(ply, superAdminBypass)
end)