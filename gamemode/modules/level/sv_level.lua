local PLAYER = FindMetaTable("Player")

function PLAYER:SetLevel(num, saveToSQL)
	if not self.basewarsProfileID then return end

	num = math.Clamp(math.floor(tonumber(num)), 0, 2147483647)
	self:SetNWInt("BaseWars.Level", math.Clamp(num, 1, BaseWars.Config.MaxLevel))

	if not saveToSQL then
		MySQLite.query(([[UPDATE basewars_player SET level = %s WHERE player_id64 = %s and profile_id = %s]]):format(num, self:SteamID64(), self.basewarsProfileID), function() end, BaseWarsSQLError)
	end
end

function PLAYER:AddLevel(amount)
	local old = self:GetLevel()
	local new = math.Clamp(old + amount, 1, BaseWars.Config.MaxLevel)
	local got = new - old
	self:SetLevel(new)

	hook.Run("PlayerGainLevel", self, old, new, got)
end

function PLAYER:SetXP(num, saveToSQL)
	if not self.basewarsProfileID then return end

	num = math.floor(tonumber(num))
	self:SetNWFloat("BaseWars.XP", num)

	if not saveToSQL then
		MySQLite.query(([[UPDATE basewars_player SET xp = %s WHERE player_id64 = %s AND profile_id = %s]]):format(MySQLite.SQLStr(num), self:SteamID64(), self.basewarsProfileID), function() end, BaseWarsSQLError)
	end
end

function PLAYER:AddXP(num, skip_basewars_stats)
	num = math.floor(tonumber(num))

	if num <= 0 then
		return
	end

	local XP = self:GetXP() + num
	local currentLevel = self:GetLevel()
	local levelToGive = 0

	if not skip_basewars_stats then
		MySQLite.query(Format("UPDATE basewars_player_stats SET xp_received = CAST(xp_received AS DECIMAL) + %s WHERE player_id64 = %s", num, self:SteamID64()), function() end, BaseWarsSQLError)
	end

	if currentLevel >= BaseWars.Config.MaxLevel then
		self:SetXP(XP)

		if BaseWars.Config.Prestige.Enable and self:GetBaseWarsConfig("autoPrestige") and self:CanPrestige() then
			self:Prestige()
		end

		return
	end

	local sysTime = SysTime()
	local nextLevelXP = 0
	while true do
		local takeToLong = SysTime() > sysTime + 5
		nextLevelXP = BaseWars:GetLevelXP(currentLevel + levelToGive)

		if currentLevel + levelToGive >= BaseWars.Config.MaxLevel or XP < nextLevelXP or takeToLong then
			self:AddLevel(levelToGive)
			self:SetXP(XP)

			if BaseWars.Config.Prestige.Enable and self:GetBaseWarsConfig("autoPrestige") then
				self:Prestige()
			end

			if takeToLong then
				BaseWars:NotifyAll("#levels_takeToLong", NOTIFICATION_WARNING, 15, self:Name())
			end

			break
		else
			XP = XP - nextLevelXP
			levelToGive = levelToGive + 1
		end
	end
end