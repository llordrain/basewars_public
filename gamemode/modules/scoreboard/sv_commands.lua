BaseWars:AddChatCommand("god", function(ply, args)
	local target = BaseWars:FindPlayer(args[1])
	if IsValid(target) then
		target:SetGodmode(not target:IsGodmode())
		BaseWars:Notify(target, target:IsGodmode() and "#command_god" or "#command_ungod", NOTIFICATION_ADMIN, 5)
	else
		ply:SetGodmode(not ply:IsGodmode())
		BaseWars:Notify(ply, ply:IsGodmode() and "#command_god" or "#command_ungod", NOTIFICATION_ADMIN, 5)
	end
end, BaseWars:GetAdminGroups(true))

-----------------------------------------------------------------------------

BaseWars:AddChatCommand("cloak", function(ply, args)
	local target = BaseWars:FindPlayer(args[1])
	if IsValid(target) then
		target:SetCloak(not target:IsCloak())
		BaseWars:Notify(target, target:IsCloak() and "#command_cloak" or "#command_uncloak", NOTIFICATION_ADMIN, 5)
	else
		ply:SetCloak(not ply:IsCloak())
		BaseWars:Notify(ply, ply:IsCloak() and "#command_cloak" or "#command_uncloak", NOTIFICATION_ADMIN, 5)
	end
end, BaseWars:GetAdminGroups(true))

-----------------------------------------------------------------------------

BaseWars:AddConsoleCommand("bw_god", function(ply, args, agrStr)
	if not IsValid(ply) then return end

	local target = BaseWars:FindPlayer(args[1])
	if IsValid(target) then
		target:SetGodmode(not target:IsGodmode())
		BaseWars:Notify(target, target:IsGodmode() and "#command_god" or "#command_ungod", NOTIFICATION_ADMIN, 5)
	else
		ply:SetGodmode(not ply:IsGodmode())
		BaseWars:Notify(ply, ply:IsGodmode() and "#command_god" or "#command_ungod", NOTIFICATION_ADMIN, 5)
	end
end, false, BaseWars:GetAdminGroups(true))
-----------------------------------------------------------------------------

BaseWars:AddConsoleCommand("bw_cloak", function(ply, args, agrStr)
	if not IsValid(ply) then return end

	local target = BaseWars:FindPlayer(args[1])
	if IsValid(target) then
		target:SetCloak(not target:IsCloak())
		BaseWars:Notify(target, target:IsCloak() and "#command_cloak" or "#command_uncloak", NOTIFICATION_ADMIN, 5)
	else
		ply:SetCloak(not ply:IsCloak())
		BaseWars:Notify(ply, ply:IsCloak() and "#command_cloak" or "#command_uncloak", NOTIFICATION_ADMIN, 5)
	end
end, false, BaseWars:GetAdminGroups(true))