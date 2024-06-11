local gray = Color(150, 150, 150)
net.Receive("BaseWars:Adverts:SendToClients", function()
    local ply = LocalPlayer()

    local message = net.ReadString()

    if message[1] == "#" then
        message = ply:GetLang(string.sub(message, 2))
    end

    chat.AddText(color_white, ":advert0::advert1::advert2::advert3::advert4:", gray, " » ", color_white, message)
end)

BaseWars:AddChatCommand("collection", nil, "#open_collection")
BaseWars:AddChatCommand("discord", nil, "#open_discord")
BaseWars:AddChatCommand({"donate", "boutique"}, nil, "#open_store")