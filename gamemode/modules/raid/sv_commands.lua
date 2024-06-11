BaseWars:AddChatCommand("cancelraid", function(ply, args)
	if not BaseWars:RaidGoingOn() then
		BaseWars:Notify(ply, "#command_raid_noRaid", NOTIFICATION_GENERIC, 5)
		return
	end

	BaseWars:CancelRaid("#raids_canceledByAdmin")
end, BaseWars:GetAdminGroups(true))