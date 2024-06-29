BaseWars:AddChatCommand("bounty", function(ply, args)
	if BaseWars.Config.MaxBounty < 0 then
		BaseWars:Notify(ply, "#commands_deactivated", NOTIFICATION_ERROR, 5)
		return
	end

	local target = args[1] and BaseWars:FindPlayer(args[1]) or ply
	local amount = math.Clamp(tonumber(args[2]) or 0, 0, ply:GetMoney())

	net.Start("BaseWars:Bounty")
		net.WriteEntity(target)
		net.WriteDouble(amount)
	net.Send(ply)
end)

BaseWars:AddChatCommand("forcebounty", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local money = tonumber(args[2])
	if not money then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	if money > ply:GetMoney() then
		money = ply:GetMoney()
	end

	hook.Run("BaseWars:Bounty:SetOnPlayer", ply, target, target:GetBounty(), money)

	ply:TakeMoney(money)
	target:SetBounty(money, true)
	BaseWars:NotifyAll("#bounty_placedOn", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatMoney(money), target:Name())
end, BaseWars:GetSuperAdminGroups())