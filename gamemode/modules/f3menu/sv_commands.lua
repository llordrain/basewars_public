util.AddNetworkString("BaseWars:OpenBaseWarsMenuOn")

local function netSend(tabName, ply)
	net.Start("BaseWars:OpenBaseWarsMenuOn")
		net.WriteString(tabName)
	net.Send(ply)
end

BaseWars:AddChatCommand({"dashboard"}, function(ply, args)
	netSend("bwm_dashboard", ply)
end)

BaseWars:AddChatCommand("leaderboard", function(ply, args)
	netSend("bwm_leaderboard", ply)
end)

BaseWars:AddChatCommand("faction", function(ply, args)
	netSend("bwm_faction", ply)
end)

BaseWars:AddChatCommand("raid", function(ply, args)
	netSend("bwm_raid", ply)
end)

BaseWars:AddChatCommand("sell", function(ply, args)
	netSend("bwm_sellmenu", ply)
end)

BaseWars:AddChatCommand("prestige", function(ply, args)
	netSend("bwm_prestige", ply)
end)

BaseWars:AddChatCommand("config", function(ply, args)
	netSend("bwm_config", ply)
end)