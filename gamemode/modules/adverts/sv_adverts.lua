util.AddNetworkString("BaseWars:Adverts:SendToClients")

local adverts = {}
function BaseWars:AddAdvert(time, message)
    if not (time and tonumber(time)) or not message then return end

    table.insert(adverts, {
        message = message,
        time = time,
        last = 0
    })
end

hook.Add("Think", "BaseWars:Adverts", function()
    if #adverts <= 0 then return end

    local players = {}
    for k, v in ipairs(player.GetHumans()) do
        if not v:GetBaseWarsConfig("showAdverts") then continue end

        table.insert(players, v)
    end

    for k, v in ipairs(adverts) do
        if CurTime() < v.last then continue end

        net.Start("BaseWars:Adverts:SendToClients")
            net.WriteString(v.message)
        net.Send(players)

        v.last = CurTime() + v.time
    end
end)