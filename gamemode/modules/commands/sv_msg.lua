util.AddNetworkString("BaseWars:Msg")

BaseWars:AddChatCommand({"msg", "message"}, function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local message = ""
	for k, v in pairs(args) do
		if v == args[1] then continue end

		message = message .. " " .. v
	end

	local plyMessage = {Color(200, 200, 200), "[", Color(255, 145, 0), "You", Color(200, 200, 200), " » ", Color(174, 18, 18), target:Name(), Color(200, 200, 200), "]", color_white, message}
	local targetMessage = {Color(200, 200, 200), "[", Color(174, 18, 18), ply:Name(), Color(200, 200, 200), " » ", Color(255, 145, 0), "You", Color(200, 200, 200), "]", color_white, message}

	net.Start("BaseWars:Msg")
		net.WriteTable(plyMessage)
	net.Send(ply)

	net.Start("BaseWars:Msg")
		net.WriteTable(targetMessage)
	net.Send(target)
end)