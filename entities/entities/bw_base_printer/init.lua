AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("BaseWars:Printer:OpenUpgradeMenu")
util.AddNetworkString("BaseWars:Printer:BuyUpgrade")
util.AddNetworkString("BaseWars:Printer:BuyPaperFromMenu")
util.AddNetworkString("BaseWars:Printer:QuickUpgrade")
util.AddNetworkString("BaseWars:Printer:TakeMoneyMenu")

local function calculateUpgradeCount(ply, BaseUpgradePrice, currentLevel, isMax, maxUpgradeCount)
	local upgradeCount = 0
	local totalPrice = 0
	for i = currentLevel + 1, isMax and maxUpgradeCount or currentLevel + 1 do
		if not ply:CanAfford(totalPrice + BaseUpgradePrice * i) then
			break
		end

		totalPrice = totalPrice + BaseUpgradePrice * i
		upgradeCount = upgradeCount + 1
	end

	return upgradeCount, totalPrice
end

local function takeMoneyAndLog(ply, upgrade, upgradeCount, totalPrice, printer)
	printer:SetCurrentValue(printer:GetCurrentValue() + totalPrice)

	ply:TakeMoney(totalPrice)
	BaseWars:Notify(ply, "#printer_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("printer_upgrades", upgrade .. "Name"), upgradeCount, BaseWars:FormatMoney(totalPrice))

	hook.Run("BaseWars:PlayerUpgradePrinter", ply, printer, upgrade, upgradeCount, totalPrice)
end

function ENT:Init()
	-- Float
	self:SetMoney(0)
	self:SetCapacity(self.Capacity)

	self:SetPrintAmount(self.PrintAmount)
	self:SetPrintInterval(self.PrintInterval)

	self:SetBaseUpgradePrice(5)

	-- Int
	self:SetMaxEnergy(500) -- From bw_base_electronics
	self:SetEnergy(self:GetMaxEnergy()) -- From bw_base_electronics

	self:SetMaxPaper(self.BasePaper)
	self:SetPaper(self:GetMaxPaper())

	self:SetPrintAmountLevel(0)
	self:SetPrintIntervalLevel(0)
	self:SetCapacityLevel(0)
	self:SetPaperCapacityLevel(0)

	-- Bool
	self:SetAutoPaper(false)

	-- Entity
	self:SetBank(NULL)

	self.WithdrawTime = 0
	self.LastPrintTime = 0
end

function ENT:PrintMoney()
	local money = self:GetMoney()
	local capacity = self:GetCapacity()
	local paper = self:GetPaper()

	if money >= capacity then
		return
	end

	if paper <= 0 then
		return
	end

	local printed = self:GetPrintAmount()
	local bank = self:GetBank()

	if IsValid(bank) and bank:InRange(self) then
		local bankMoney = bank:GetMoney()
		local bankCapacity = bank:GetCapacity()

		if bankMoney >= bankCapacity then
			self:AddMoney(printed)
		else
			if bankMoney + printed > bankCapacity then
				local excess = printed - (bankCapacity - bankMoney)

				if excess > 0 then
					self:AddMoney(excess)
				end
			end

			bank:AddMoney(printed)
		end
	else
		self:AddMoney(printed)
	end

	self:SetPaper(paper - 1)
end

function ENT:AddMoney(money)
	self:SetMoney(math.Clamp(self:GetMoney() + money, 0, self:GetCapacity()))
end

function ENT:WithdrawMoney(ply, adminBypass)
	if not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply and not (adminBypass and BaseWars:IsSuperAdmin(ply)) then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)

		return
	end

	-- Prevents player from withdrawing for no reason and create a shitload of logs if you have a logging addon :]
	if self.WithdrawTime >= CurTime() then
		return
	end

	self.WithdrawTime = CurTime() + .5

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
	if not ply:IsPlayer() then
		return
	end

	if self:OnBuyPaper(ply) then
		self:RefillPaper(ply)

		return
	end

	if self:OnUpgrade(ply) then
		net.Start("BaseWars:Printer:OpenUpgradeMenu")
			net.WriteEntity(self)
		net.Send(ply)

		return
	end

	self:WithdrawMoney(ply)
end

function ENT:Upgrade(ply, upgrade, max, hideMaxUpgradeNotif)
	if not IsValid(ply) or not ply:IsPlayer() then
		return
	end

	local BaseUpgradePrice = self:GetBaseUpgradePrice()

	if upgrade == "interval" then
		local currentLevel = self:GetPrintIntervalLevel()
		local maxUpgradeCount = BaseWars.Config.PrinterMaxLevel[upgrade]

		if self:GetPrintIntervalLevel() >= BaseWars.Config.PrinterMaxLevel[upgrade] then
			if not hideMaxUpgradeNotif then
				BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
			end

			return
		end

		local upgradeCount, totalPrice = calculateUpgradeCount(ply, BaseUpgradePrice, currentLevel, max, maxUpgradeCount)
		if upgradeCount == 0 then
			return
		end

		local finalLevel = currentLevel + upgradeCount

		self:SetPrintIntervalLevel(finalLevel)
		self:SetPrintInterval(1 - upgradeCount * .05)

		takeMoneyAndLog(ply, upgrade, upgradeCount, totalPrice, self)
	end

	if upgrade == "amount" then
		local currentLevel = self:GetPrintAmountLevel()
		local maxUpgradeCount = BaseWars.Config.PrinterMaxLevel[upgrade]

		if self:GetPrintAmountLevel() >= BaseWars.Config.PrinterMaxLevel[upgrade] then
			if not hideMaxUpgradeNotif then
				BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
			end

			return
		end

		local upgradeCount, totalPrice = calculateUpgradeCount(ply, BaseUpgradePrice, currentLevel, max, maxUpgradeCount)
		if upgradeCount == 0 then
			return
		end

		local finalLevel = currentLevel + upgradeCount

		self:SetPrintAmountLevel(finalLevel)
		self:SetPrintAmount(self.PrintAmount * (finalLevel + 1) ^ 1.45)

		takeMoneyAndLog(ply, upgrade, upgradeCount, totalPrice, self)
	end

	if upgrade == "capacity" then
		local currentLevel = self:GetCapacityLevel()
		local maxUpgradeCount = BaseWars.Config.PrinterMaxLevel[upgrade]

		if self:GetCapacityLevel() >= BaseWars.Config.PrinterMaxLevel[upgrade] then
			if not hideMaxUpgradeNotif then
				BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
			end

			return
		end

		local upgradeCount, totalPrice = calculateUpgradeCount(ply, BaseUpgradePrice, currentLevel, max, maxUpgradeCount)
		if upgradeCount == 0 then
			return
		end

		local finalLevel = currentLevel + upgradeCount

		self:SetCapacityLevel(finalLevel)
		self:SetCapacity(self.Capacity * (finalLevel * 6))

		takeMoneyAndLog(ply, upgrade, upgradeCount, totalPrice, self)
	end

	if upgrade == "paperCapacity" then
		local currentLevel = self:GetPaperCapacityLevel()
		local maxUpgradeCount = BaseWars.Config.PrinterMaxLevel[upgrade]

		if self:GetPaperCapacityLevel() >= BaseWars.Config.PrinterMaxLevel[upgrade] then
			if not hideMaxUpgradeNotif then
				BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
			end

			return
		end

		local upgradeCount, totalPrice = calculateUpgradeCount(ply, BaseUpgradePrice, currentLevel, max, maxUpgradeCount)
		if upgradeCount == 0 then
			return
		end

		local finalLevel = currentLevel + upgradeCount

		self:SetPaperCapacityLevel(finalLevel)
		self:SetMaxPaper(self.BasePaper + finalLevel * 1000)

		takeMoneyAndLog(ply, upgrade, upgradeCount, totalPrice, self)
	end

	if upgrade == "autoPaper" then
		if self:GetAutoPaper() then
			if not hideMaxUpgradeNotif then
				BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
			end

			return
		end

		local upgradePrice = BaseUpgradePrice * 5

		if not ply:CanAfford(upgradePrice) then
			return
		end

		self:SetAutoPaper(true)

		takeMoneyAndLog(ply, upgrade, 1, upgradePrice, self)
	end
end

function ENT:RefillPaper(ply, adminBypass)
	if not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply and not (adminBypass and BaseWars:IsSuperAdmin(ply)) then
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
	local owner = self:CPPIGetOwner()

	self:NextThink(CurTime())

	-- The printer stops working if the it has no owner
	-- if not IsValid(owner) then
	-- 	return
	-- end

	-- Should proly redo this?
	if self:BadlyDamaged() and math.random(0, 10) == 0 then
		self:Spark()

		return
	end

	if CurTime() >= self.LastPrintTime then
		if self:GetAutoPaper() and self:GetPaper() <= 0 and IsValid(owner) then
			self:RefillPaper(owner)
		end

		local money = self:GetMoney()
		local bank = self:GetBank()
		if IsValid(bank) and bank:InRange(self) then
			local bankMoney = bank:GetMoney()
			local bankCapacity = bank:GetCapacity()
			local roomLeft = bankCapacity - bankMoney

			if roomLeft > 0 then
				if money > roomLeft then
					local excess = money - roomLeft

					self:SetMoney(excess)
					bank:AddMoney(money - excess)
				else
					self:SetMoney(0)
					bank:AddMoney(money)
				end
			end
		end

		self:PrintMoney()

		self.LastPrintTime = CurTime() + self:GetPrintInterval()
	end

	return true
end

local upgradeIndex = {
	"interval",
	"amount",
	"capacity",
	"paperCapacity",
	"autoPaper",
}
net.Receive("BaseWars:Printer:BuyUpgrade", function(len, ply)
	local printer = net.ReadEntity()
	local upgradeID = net.ReadUInt(3)
	local max = net.ReadBool()
	local adminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	if not BaseWars.Config.PrinterPublic and printer:CPPIGetOwner() != ply and not (adminBypass and BaseWars:IsSuperAdmin(ply)) then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)

		return
	end

	printer:Upgrade(ply, upgradeIndex[upgradeID], max)
end)

net.Receive("BaseWars:Printer:QuickUpgrade", function(len, ply)
	local printer = net.ReadEntity()
	local upgrades = net.ReadTable()
	local adminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	if not BaseWars.Config.PrinterPublic and printer:CPPIGetOwner() != ply and not (adminBypass and BaseWars:IsSuperAdmin(ply)) then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)

		return
	end

	for i, _ in ipairs(upgrades) do
		if not upgrades[i] then
			continue
		end

		printer:Upgrade(ply, upgradeIndex[i], true, true)
	end
end)

net.Receive("BaseWars:Printer:BuyPaperFromMenu", function(len, ply)
	local printer = net.ReadEntity()
	local adminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	printer:RefillPaper(ply, adminBypass)
end)

net.Receive("BaseWars:Printer:TakeMoneyMenu", function(len, ply)
	local printer = net.ReadEntity()
	local adminBypass = net.ReadBool()

	if not IsValid(printer) or not printer.IsPrinter then
		return
	end

	printer:WithdrawMoney(ply, adminBypass)
end)