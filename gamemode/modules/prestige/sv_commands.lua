BaseWars:AddChatCommand("addprestige", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local prestige = tonumber(args[2])
	if not prestige then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	target:AddPrestige(prestige)
	target:AddPrestigePoint(prestige * BaseWars.Config.Prestige.Point)
	BaseWars:Notify(ply, "#command_addPrestige_add", NOTIFICATION_GENERIC, 5, BaseWars:FormatNumber(prestige), target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_addPrestige_addBy", NOTIFICATION_GENERIC, 5, target:Name(), BaseWars:FormatNumber(prestige))
	end
end, BaseWars:GetSuperAdminGroups())

-----------------------------------------------------------------------------

BaseWars:AddChatCommand("setprestige", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local prestige = tonumber(args[2])
	if not prestige then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	target:SetPrestige(prestige)
	target:SetPrestigePoint(prestige * BaseWars.Config.Prestige.Point)
	BaseWars:Notify(ply, "#command_setPrestige_set", NOTIFICATION_GENERIC, 5, target:Name(), BaseWars:FormatNumber(prestige))
	if ply != target then
		BaseWars:Notify(target, "#command_setPrestige_setBy", NOTIFICATION_GENERIC, 5, target:Name(), BaseWars:FormatNumber(prestige))
	end
end, BaseWars:GetSuperAdminGroups())