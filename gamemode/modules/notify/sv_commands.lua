util.AddNetworkString("BaseWars:Notif:ClearNotifs")

BaseWars:AddChatCommand("clearnotif", function(ply)
    net.Start("BaseWars:Notif:ClearNotifs")
    net.Send(ply)
end)