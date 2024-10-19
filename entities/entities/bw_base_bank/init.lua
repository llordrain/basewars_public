util.AddNetworkString("BaseWars:Bank:OpenUpgradeMenu")
util.AddNetworkString("BaseWars:Bank:BuyUpgrade")
util.AddNetworkString("BaseWars:Bank:BuyPaper")
util.AddNetworkString("BaseWars:Bank:TakeMoney")

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Init()
	self:SetMoney(0)
	self:SetCapacity(100000)

	self:SetBaseUpgradePrice(1000)

	self:SetPrintAmount(0)
	self:SetPrinterCount(0)

	self:SetCapacityLevel(0)
	self:SetHealthLevel(0)

	self.WithdrawTime = 0
	self.InterestTime = CurTime() + 60 * 15
	self.WaitScan = 0
end

function ENT:WithdrawMoney(ply, adminBypass)
	if not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply and not (adminBypass and BaseWars:IsSuperAdmin(ply)) then
		BaseWars:Notify(ply, "#bank_notYours", NOTIFICATION_ERROR, 5)

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

	hook.Run("BaseWars:PlayerTakeMoneyInBank", ply, self, money, xp)
end

function ENT:Use(ply)
	if not ply:IsPlayer() then
		return
	end

	if self:OnUpgrade(ply) then
		net.Start("BaseWars:Bank:OpenUpgradeMenu")
			net.WriteEntity(self)
		net.Send(ply)

		return
	end

	self:WithdrawMoney(ply)
end

function ENT:Upgrade(ply, upgrade)
	if upgrade == "capacity" then
		if self:GetCapacityLevel() >= BaseWars.Config.BankMaxLevel["capacity"] then
			BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)

			return
		end

		local upgradeLevel = self:GetCapacityLevel()
		local upgradePrice = self:GetBaseUpgradePrice() * .2 * 10 ^ upgradeLevel

		if not ply:CanAfford(upgradePrice) then
			return
		end

		self:SetCapacityLevel(upgradeLevel + 1)
		self:SetCapacity(self:GetCapacity() * 10)
		self:SetCurrentValue(self:GetCurrentValue() + upgradePrice)

		ply:TakeMoney(upgradePrice)
		BaseWars:Notify(ply, "#bank_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("bank_upgrades", upgrade .. "Name"), BaseWars:FormatMoney(upgradePrice))

		hook.Run("BaseWars:PlayerUpgradeBank", ply, self, upgrade, upgradePrice)
	end

	if upgrade == "health" then
		if self:GetHealthLevel() >= BaseWars.Config.BankMaxLevel["health"] then
			BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)

			return
		end

		local upgradeLevel = self:GetHealthLevel()
		local upgradePrice = self:GetBaseUpgradePrice() * 10 ^ upgradeLevel

		if not ply:CanAfford(upgradePrice) then
			return
		end

		self:SetHealthLevel(upgradeLevel + 1)
		self:SetCurrentValue(self:GetCurrentValue() + upgradePrice)

		local oldHealth = self:GetMaxHealth()
		self:SetMaxHealth(self.PresetHealth * (self:GetHealthLevel() + 1) ^ 2.2)
		if self:Health() == oldHealth then
			self:SetHealth(self:GetMaxHealth())
		end

		ply:TakeMoney(upgradePrice)
		BaseWars:Notify(ply, "#bank_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("bank_upgrades", upgrade .. "Name"), BaseWars:FormatMoney(upgradePrice))

		hook.Run("BaseWars:PlayerUpgradeBank", ply, self, upgrade, upgradePrice)
	end
end

function ENT:Scan()
	local owner = self:CPPIGetOwner()

	if not IsValid(owner) then
		return
	end

	local oldPrinterCount = self:GetPrinterCount()

	local printAmount = 0
	local printerCount = 0
	for _, v in ipairs(ents.GetAll()) do
		if not IsValid(v) then continue end
		if not v.IsPrinter then continue end
		if v:CPPIGetOwner() != owner then continue end

		printAmount = printAmount + v:GetPrintAmount() / v:GetPrintInterval()
		printerCount = printerCount + 1

		v:SetBank(self)
	end

	self:SetPrintAmount(printAmount)
	self:SetPrinterCount(printerCount)

	-- if oldPrinterCount < printerCount then
	-- 	self:SyncPrinters()
	-- end
end

function ENT:SyncPrinters()
	local owner = self:CPPIGetOwner()

	for _, v in ipairs(ents.GetAll()) do
		if not IsValid(v) then continue end
		if not v.IsPrinter then continue end
		if v:CPPIGetOwner() != owner then continue end

		v.LastPrintTime = CurTime() + 1
	end
end

function ENT:AddMoney(money)
	self:SetMoney(math.Clamp(self:GetMoney() + money, 0, self:GetCapacity()))
end

function ENT:InRange(printer)
	if BaseWars.Config.BankRadius > 0 then
		return self:GetPos():Distance(printer:GetPos()) <= BaseWars.Config.BankRadius
	end

	return true
end

function ENT:ThinkFunc()
	if self:BadlyDamaged() and math.random(0, 10) == 0 then
		self:Spark()

		return
	end

	local owner = self:CPPIGetOwner()

	if IsValid(owner) and owner:GetPrestigePerk("bankInterest") > 0 and CurTime() >= self.InterestTime then
		local bankMoney = self:GetMoney()

		if bankMoney > 0 then
			owner:AddMoney(bankMoney * .1)
			BaseWars:Notify(owner, "#prestige_bankInterest", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(bankMoney * .1))
		end

		self.InterestTime = CurTime() + 60 * 15
	end

	if CurTime() >= self.WaitScan then
		self:Scan(self:CPPIGetOwner())

		self.WaitScan = CurTime() + 1
	end
end

net.Receive("BaseWars:Bank:BuyUpgrade", function(len, ply)
	local bank = net.ReadEntity()
	local upgradeID = net.ReadUInt(2)
	local superAdminBypass = net.ReadBool()

	if not IsValid(bank) or not bank.IsBank then
		return
	end

	if not (superAdminBypass and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and bank:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	bank:Upgrade(ply, upgradeID == 1 and "capacity" or "health")
end)

net.Receive("BaseWars:Bank:BuyPaper", function(len, ply)
	local printers = net.ReadTable()
	local superAdminBypass = net.ReadBool()

	if superAdminBypass and not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

	for k, v in ipairs(printers) do
		if not IsValid(v) then continue end
		if not v.IsPrinter then continue end
		if not BaseWars.Config.PrinterPublic and v:CPPIGetOwner() != ply then continue end

		v:RefillPaper(ply, superAdminBypass)
	end
end)

net.Receive("BaseWars:Bank:TakeMoney", function(len, ply)
	local bank = net.ReadEntity()
	local superAdminBypass = net.ReadBool()

	if not IsValid(bank) or not bank.IsBank then
		return
	end

	bank:WithdrawMoney(ply, superAdminBypass)
end)