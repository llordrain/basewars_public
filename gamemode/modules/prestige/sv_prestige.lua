util.AddNetworkString("BaseWars:Prestige")
util.AddNetworkString("BaseWars:Prestige.BuyPerk")
util.AddNetworkString("BaseWars:Prestige.ResetPoint")

local PLAYER = FindMetaTable("Player")

function PLAYER:SetPrestige(num, saveToSQL)
	if not self.basewarsProfileID then return end

	num = math.Clamp(math.floor(tonumber(num)), 0, 2147483647)
	self:SetNWInt("BaseWars.Prestige", num)

	if not saveToSQL then
		MySQLite.query(("UPDATE basewars_prestige SET prestige = %s WHERE player_id64 = %s and profile_id = %s"):format(num, self:SteamID64(), self.basewarsProfileID))
	end
end

function PLAYER:AddPrestige(num)
	self:SetPrestige(self:GetPrestige() + num)
end

function PLAYER:SetPrestigePoint(num, saveToSQL)
	if not self.basewarsProfileID then return end

	num = math.Clamp(math.floor(tonumber(num)), 0, 2147483647)
	self:SetNWInt("BaseWars.PrestigePoint", num)

	if not saveToSQL then
		MySQLite.query(("UPDATE basewars_prestige SET point = %s WHERE player_id64 = %s and profile_id = %s"):format(num, self:SteamID64(), self.basewarsProfileID))
	end
end

function PLAYER:AddPrestigePoint(num)
	self:SetPrestigePoint(self:GetPrestigePoint() + num)
end

function PLAYER:SetPrestigePerk(perkID, num)
	num = math.Clamp(math.floor(tonumber(num)), 0, 2147483647)

	self:SetNWInt("BaseWars.PrestigePerk." .. perkID, num)
end

function PLAYER:Prestige()
	if not BaseWars.Config.Prestige.Enable then return end
	if not self:CanPrestige() then return end

	for k, v in ents.Iterator() do
		if not IsValid(v) then continue end
		if v:CPPIGetOwner() != self then continue end

		if not BaseWars.Config.Prestige.RemoveProps and v:IsClass("prop_physics") then continue end

		if v.IsBank or v.IsPrinter then
			v:SetRefund(false)
		end

		SafeRemoveEntity(v)
	end

	self:AddPrestige(1)
	self:AddPrestigePoint(BaseWars.Config.Prestige.Point)
	self:SetMoney(BaseWars.Config.StartMoney)
	self:SetLevel(1)
	self:SetXP(0)

	if zrush then
		self.zrush_INV_FuelBarrels = {}
	end

	if zcm then
		self:SetNWInt("zcm_firework", 0)
	end

	if zrmine then
		self:zrms_ResetMetalBars()
	end

	if zmlab then
		self.zmlab_meth = 0
	end

	if self.cfCigsAmount then
		self.cfCigsAmount = 0
	end

	hook.Run("BaseWars:Prestige:OnPlayerPrestige", self, self:GetPrestige() - 1, self:GetPrestige())

	for k, v in player.Iterator() do
		BaseWars:Notify(v, "#prestige_playerPrestiged", NOTIFICATION_PRESTIGE, 5, self:Name(), self:GetPrestige())
	end
end

net.Receive("BaseWars:Prestige", function(len, ply)
	ply:Prestige()
end)

net.Receive("BaseWars:Prestige.BuyPerk", function(len, ply)
	if not BaseWars.Config.Prestige.Enable then return end
	local perkID = net.ReadString()
	if not perkID then return end

	local point = ply:GetPrestigePoint()
	local level = ply:GetPrestigePerk(perkID)
	local perk = BaseWars:GetPrestigePerk()[perkID]

	if level >= perk.max then BaseWars:Notify(ply, "#prestige_maxPerk", NOTIFICATION_ERROR, 5)
		return
	end

	if point < perk.cost then BaseWars:Notify(ply, "#prestige_notEnoughPoint", NOTIFICATION_ERROR, 5, perk.cost)
		return
	end

	ply:SetPrestigePoint(point - perk.cost)
	ply:SetPrestigePerk(perkID, level + 1)

	hook.Run("BaseWars:Prestige:onPlayerBuyPerk", ply, perkID, perk.cost, level + 1)

	local perks = ""
	for k, v in pairs(BaseWars:GetPrestigePerk()) do
		local perkLevel = ply:GetPrestigePerk(k)

		perks = perks .. k .. ":" .. perkLevel .. ";"
	end
	perks = string.sub(perks, 1, #perks - 1)
	MySQLite.query(("UPDATE basewars_prestige SET perks = %s WHERE player_id64 = %s and profile_id = %s"):format(MySQLite.SQLStr(perks), ply:SteamID64(), ply.basewarsProfileID))

	BaseWars:Notify(ply, "#prestige_buyPerkNotif", NOTIFICATION_PURCHASE, 5, ply:GetLang("prestige_perks", perkID .. "Name"))
end)

net.Receive("BaseWars:Prestige.ResetPoint", function(len, ply)
	if not BaseWars.Config.Prestige.Enable then return end

	local point = ply:GetPrestige() * BaseWars.Config.Prestige.Point - ply:GetPrestigePoint()
	local price = BaseWars.Config.Prestige.ResetPrice * point

	if not ply:CanAfford(price) then
		BaseWars:Notify(ply, "#prestige_tooExpensive", NOTIFICATION_ERROR, 5)
		return
	end

	ply:TakeMoney(price)
	ply:SetPrestigePoint(ply:GetPrestige() * BaseWars.Config.Prestige.Point)

	hook.Run("BaseWars:Prestige:ResetPrestigePoint", ply, price)

	local perks = ""
	for k, v in pairs(BaseWars:GetPrestigePerk()) do
		ply:SetPrestigePerk(k, 0)
		perks = perks .. k .. ":0;"
	end
	perks = string.sub(perks, 1, #perks - 1)
	MySQLite.query(("UPDATE basewars_prestige SET perks = %s WHERE player_id64 = %s and profile_id = %s"):format(MySQLite.SQLStr(perks), ply:SteamID64(), ply.basewarsProfileID))

	hook.Run("BaseWars:ResetPrestigePerk", ply)

	BaseWars:Notify(ply, "#resetpointfor", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(price))
end)

hook.Add("BaseWars:Prestige:onPlayerBuyPerk", "BaseWars:Prestige", function(ply, perkID, price, level)
	if perkID == "playerHealth" then
		local health = BaseWars.Config.DefaultHealth + (hook.Run("BaseWars:PlayerSpawn:Health", ply) or 0)

		ply:SetMaxHealth(health)
		ply:SetHealth(ply:GetMaxHealth())
	end

	if perkID == "playerArmor" then
		local armor = 100 + (hook.Run("BaseWars:PlayerSpawn:Armor", ply) or 0)

		ply:SetMaxArmor(armor)
		ply:SetArmor(math.Clamp(ply:Armor(), 0, ply:GetMaxArmor()))
	end

	if perkID == "playerSpeed" then
		local walkSpeed = BaseWars.Config.WalkSpeed * (hook.Run("BaseWars:PlayerSpawn:WalkSpeed", ply) or 1)
		local runSpeed = BaseWars.Config.RunSpeed * (hook.Run("BaseWars:PlayerSpawn:WalkSpeed", ply) or 1)

		ply:SetWalkSpeed(walkSpeed)
		ply:SetRunSpeed(runSpeed)
	end

	if perkID == "moreMoneyDefault" then
		ply:AddMoney(95000)
	end
end)

hook.Add("BaseWars:ResetPrestigePerk", "BaseWars:Prestige", function(ply)
	ply:SetMaxHealth(BaseWars.Config.DefaultHealth)
	ply:SetHealth(ply:GetMaxHealth())

	ply:SetMaxArmor(100)
	ply:SetArmor(math.Clamp(ply:Armor(), 0, ply:GetMaxArmor()))

	ply:SetWalkSpeed(BaseWars.Config.WalkSpeed)
	ply:SetRunSpeed(BaseWars.Config.RunSpeed)
end)