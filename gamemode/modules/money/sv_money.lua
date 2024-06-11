local PLAYER = FindMetaTable("Player")

function PLAYER:SetMoney(num, saveToSQL)
	if not self.basewarsProfileID then return end

	num = math.floor(tonumber(num))

	self:SetNWFloat("BaseWars.Money", num)

	if not saveToSQL then
		MySQLite.query(Format("UPDATE basewars_player SET money = %s WHERE player_id64 = %s and profile_id = %s", MySQLite.SQLStr(num), self:SteamID64(), self.basewarsProfileID), function() end, BaseWarsSQLError)
	end
end

function PLAYER:AddMoney(num, skip_basewars_stats)
	num = math.floor(tonumber(num))

	if num <= 0 then
		return
	end

	self:SetMoney(self:GetMoney() + num)

	if not skip_basewars_stats then
		MySQLite.query(Format("UPDATE basewars_player_stats SET money_taken = CAST(money_taken AS DECIMAL) + %s WHERE player_id64 = %s", num, self:SteamID64()), function() end, BaseWarsSQLError)
	end
end
PLAYER.GiveMoney = PLAYER.AddMoney

function PLAYER:TakeMoney(amount)
	if self:GetMoney() - amount < 0 then return end
	self:SetMoney(self:GetMoney() - amount)
end