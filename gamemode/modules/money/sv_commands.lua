BaseWars:AddChatCommand("addmoney", function(ply, args)
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

	target:AddMoney(money, true)
	BaseWars:Notify(ply, "#command_addMoney_add", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(money), target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_addMoney_addBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatMoney(money))
	end
end, BaseWars:GetSuperAdminGroups())

-----------------------------------------------------------------------------

BaseWars:AddChatCommand("setmoney", function(ply, args)
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

	target:SetMoney(money)
	BaseWars:Notify(ply, "#command_setMoney_set", NOTIFICATION_GENERIC, 5, target:Name(), BaseWars:FormatMoney(money))
	if ply != target then
		BaseWars:Notify(target, "#command_setMoney_setBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatMoney(money))
	end
end, BaseWars:GetSuperAdminGroups())