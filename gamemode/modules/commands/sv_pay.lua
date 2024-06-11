util.AddNetworkString("BaseWars:Pay")

net.Receive("BaseWars:Pay", function(len, ply)
	local target = net.ReadEntity()
	local amount = net.ReadDouble()

	if amount < 0 or BaseWars.Config.MaxPay < 0 then return end

	if amount > ply:GetMoney() then
		amount = ply:GetMoney()
	end

	if BaseWars.Config.MaxPay > 0 then
		amount = math.min(amount, BaseWars.Config.MaxPay)
	end

	if ply:CanAfford(amount) and (IsValid(target) and target:IsPlayer()) then
		ply:TakeMoney(amount)
		target:GiveMoney(amount)

		hook.Run("BaseWars:Pay", ply, target, amount)

		BaseWars:Notify(ply, "#pay_payedPlayer", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(amount), target:Name())
		BaseWars:Notify(target, "#pay_payedBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatMoney(amount))
	end
end)

BaseWars:AddChatCommand("pay", function(ply, args)
	if BaseWars.Config.MaxPay < 0 then
		BaseWars:Notify(ply, "#commands_deactivated", NOTIFICATION_ERROR, 5)
		return
	end

	local target = args[1] and BaseWars:FindPlayer(args[1]) or ply
	local amount = math.Clamp(tonumber(args[2]) or 0, 0, ply:GetMoney())

	if player.GetCount() == 1 or target == ply then
		BaseWars:Notify(ply, "#pay_noOneToPay", NOTIFICATION_ERROR, 5)
		return
	end

	if target:IsBot() then
		BaseWars:Notify(ply, "#pay_cantPayBot", NOTIFICATION_ERROR, 5)
		return
	end

	net.Start("BaseWars:Pay")
		net.WriteEntity(target)
		net.WriteDouble(amount)
	net.Send(ply)
end)