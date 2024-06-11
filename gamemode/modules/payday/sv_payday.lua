local PLAYER = FindMetaTable("Player")

function PLAYER:PayDay()
	if not BaseWars.Config.PayDay.AFKPayday and self:IsAFK() then
		BaseWars:Notify(self, "#paydayAFK", NOTIFICATION_GENERIC, 5)
		return
	end

	local money = self:GetMoney()
	if BaseWars:IsVIP(self) then
		money = money * BaseWars.Config.PayDay.VIP
	else
		money = money * BaseWars.Config.PayDay.Default
	end

	self:AddMoney(money)
	BaseWars:Notify(self, "#payday", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(money))
end

timer.Create("BaseWars.PayDay", BaseWars.Config.PayDay.Time, 0, function()
	for k, v in player.Iterator() do
		if v:GetMoney() > 1e35 then
			continue
		end

		v:PayDay()
	end
end)

hook.Add("BaseWars:ConfigurationModified", "BaseWars:PayDay", function(_, _, config)
	timer.Adjust("BaseWars.PayDay", config.PayDay.Time)
end)