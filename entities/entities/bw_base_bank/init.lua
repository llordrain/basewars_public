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
	self:SetPrinting(0)

	self:SetCapacityCost(20000)
	self:SetHealthCost(self:GetCapacityCost() * 8)

	self:SetCapacityLevel(0)
	self:SetHealthLevel(0)
	self:SetPrinterCount(0)

	self:SetRefund(true)

	self.Printers = {}

	self.InterestTime = CurTime()
	self.WaitScan = CurTime()
	self.Time = CurTime()

	self:Scan(self:CPPIGetOwner())
end

function ENT:WithdrawMoney(ply, bypassPrivate)
	if not (bypassPrivate and BaseWars:IsSuperAdmin(ply)) and not BaseWars.Config.PrinterPublic and self:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#printer_notYours", NOTIFICATION_ERROR, 5)
		return
	end

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
	if not (ply and ply:IsPlayer()) then return end

	if self:OnUpgrade(ply) then
		net.Start("BaseWars:Bank:OpenUpgradeMenu")
			net.WriteEntity(self)
		net.Send(ply)
	else
		self:WithdrawMoney(ply)
	end
end

function ENT:UpgradeCapacity(ply)
	if self:GetCapacityLevel() >= BaseWars.Config.BankMaxLevel["capacity"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	if self:GetCapacityLevel() >= BaseWars.Config.BankMaxLevel["capacity"] then
		return
	end

	local level = self:GetCapacityLevel()
	local realCost = self:GetCapacityCost() * 10 ^ self:GetCapacityLevel()
	if not ply:CanAfford(realCost) then
		return
	end

	ply:TakeMoney(realCost)
	self:SetCapacityLevel(level + 1)
	self:SetCapacity(self:GetCapacity() * 10)
	self:SetCurrentValue(self:GetCurrentValue() + realCost)

	hook.Run("BaseWars:PlayerUpgradeBank", ply, self, "capacity", realCost)

	BaseWars:Notify(ply, "#bank_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("bank_upgrades", "capacityName"), BaseWars:FormatMoney(realCost))
end

function ENT:UpgradeHealth(ply)
	if self:GetHealthLevel() >= BaseWars.Config.BankMaxLevel["health"] then
		BaseWars:Notify(ply, "#printer_maxupgrade", NOTIFICATION_ERROR, 5)
		return
	end

	if self:GetHealthLevel() >= BaseWars.Config.BankMaxLevel["health"] then
		return
	end

	local level = self:GetHealthLevel()
	local realCost = self:GetHealthCost() * 10 ^ self:GetHealthLevel()
	if not ply:CanAfford(realCost) then
		return
	end

	ply:TakeMoney(realCost)
	self:SetHealthLevel(level + 1)
	self:SetCurrentValue(self:GetCurrentValue() + realCost)

	local oldHealth = self:GetMaxHealth()
	self:SetMaxHealth(self.PresetHealth * (self:GetHealthLevel() + 1) ^ 2.2)
	if self:Health() == oldHealth then
		self:SetHealth(self:GetMaxHealth())
	end

	hook.Run("BaseWars:PlayerUpgradeBank", ply, self, "health", realCost)

	BaseWars:Notify(ply, "#bank_buyupgrade", NOTIFICATION_PURCHASE, 5, ply:GetLang("bank_upgrades", "healthName"), BaseWars:FormatMoney(realCost))
end

function ENT:Scan(ply)
	if not IsValid(ply) then return end
	self:SetPrinting(0)

	local entities = {}
	local entitiesFound = ents.FindByClass("bw_*")
	for k, v in pairs(entitiesFound) do
		if not IsValid(v) then continue end
		if not v.IsPrinter then continue end
		if not v.CPPIGetOwner then continue end
		if v:CPPIGetOwner() != self:CPPIGetOwner() then continue end
		if not self:InRange(v) then continue end

		if v:GetPaper() > 0 then
			self:SetPrinting(self:GetPrinting() + v:GetPrintAmount() / v:GetPrintInterval())
		end

		v:SetConnectedToBank(true)

		table.insert(entities, v)
	end

	self.Printers = entities
	self:SetPrinterCount(table.Count(entities))
end

function ENT:OnRemove()
	if not self:GetRefund() then return end

	local selfOwner = self:CPPIGetOwner()
	if IsValid(selfOwner) then
		self:WithdrawMoney(selfOwner)
	end
end

function ENT:InRange(printer)
	if BaseWars.Config.BankRadius > 0 then
		return self:GetPos():Distance(printer:GetPos()) <= BaseWars.Config.BankRadius
	end

	return true
end

function ENT:ThinkFunc()
	if self:BadlyDamaged() then return end

	local owner = self:CPPIGetOwner()

	if IsValid(owner) and owner:GetPrestigePerk("bankInterest") > 0 and CurTime() >= self.InterestTime then
		local bankMoney = self:GetMoney()

		if bankMoney > 0 then
			owner:AddMoney(bankMoney * .1)
			BaseWars:Notify(owner, "#prestige_bankInterest", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(bankMoney * .1))
		end

		self.InterestTime = CurTime() + 60 * 15
	end

	if CurTime() >= self.Time and self:GetMoney() < self:GetCapacity() then
		for k, v in pairs(self.Printers) do
			if not IsValid(v) then continue end
			if v:BadlyDamaged() then continue end

			local money = v:GetMoney()
			local max = self:GetCapacity() - self:GetMoney()
			if money >= max then
				v:SetMoney(money - max)
				money = max
			else
				v:SetMoney(0)
			end

			self:SetMoney(self:GetMoney() + money)
		end

		self.Time = CurTime() + .25
	end

	if CurTime() >= self.WaitScan then
		self:Scan(self:CPPIGetOwner())
		self.WaitScan = CurTime() + 2
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

	if upgradeID == 1 then
		bank:UpgradeCapacity(ply)
	elseif upgradeID == 2 then
		bank:UpgradeHealth(ply)
	end
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