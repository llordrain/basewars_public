local gray = Color(150, 150, 150)
net.Receive("BaseWars:Adverts:SendToClients", function()
    local ply = LocalPlayer()

    local message = net.ReadString()

    if message[1] == "#" then
        message = ply:GetLang(string.sub(message, 2))
    end

    chat.AddText(color_white, "[Advert]", gray, " » ", color_white, message)
end)