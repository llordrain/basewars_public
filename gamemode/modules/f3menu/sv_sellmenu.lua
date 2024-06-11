util.AddNetworkString("BaseWars:SellEntities")
util.AddNetworkString("BaseWars:SellAll")

net.Receive("BaseWars:SellEntities", function(len, ply)
	if ply:InRaid() then
		BaseWars:Notify(ply, "#sellmenu_sellDuringRaid", NOTIFICATION_ERROR, 5)
		return
	end

	local totalEntities = 0
	local totalValue = 0

	for k, v in pairs(net.ReadTable()) do
		if not v:ValidToSell(ply) then continue end

		local entValue = v:GetCurrentValue()

		totalEntities = totalEntities + 1
		totalValue = totalValue + entValue

		hook.Run("BaseWars:PreSellEntity", ply, v, entValue)

		SafeRemoveEntity(v)
	end

	totalValue = totalValue * BaseWars.Config.BackMoney

	ply:AddMoney(totalValue)
	BaseWars:Notify(ply, "#sellmenu_sell", NOTIFICATION_SELL, 5, totalEntities, BaseWars:FormatMoney(totalValue))
end)

net.Receive("BaseWars:SellAll", function(len, ply)
	if ply:InRaid() then
		BaseWars:Notify(ply, "#sellmenu_sellDuringRaid", NOTIFICATION_ERROR, 5)
		return
	end

	local totalEntities = 0
	local totalValue = 0

	for k, v in ents.Iterator() do
		if not v:ValidToSell(ply) then continue end

		local entValue = v:GetCurrentValue()

		if v.IsBank then
			entValue = entValue + v:GetMoney()
		end

		if v.IsPrinter then
			entValue = entValue + v:GetMoney()
		end

		totalEntities = totalEntities + 1
		totalValue = totalValue + entValue

		hook.Run("BaseWars:PreSellEntity", ply, v, entValue)

		SafeRemoveEntity(v)
	end

	totalValue = totalValue * BaseWars.Config.BackMoney

	ply:AddMoney(totalValue)
	BaseWars:Notify(ply, "#sellmenu_sell", NOTIFICATION_SELL, 5, totalEntities, BaseWars:FormatMoney(totalValue))
end)