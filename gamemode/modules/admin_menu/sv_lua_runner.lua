util.AddNetworkString("BaseWars:LuaRunner")

net.Receive("BaseWars:LuaRunner", function(len, ply)
    if not BaseWars:IsSuperAdmin(ply) then
        return
    end

    local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))["lua"]
    local runStringError = RunString(data, Format("Lua runner by %s [%s]", ply:Name(), ply:SteamID64()), false)

    if runStringError != nil then
        local data = util.Compress(util.TableToJSON({
            error = runStringError
        }))

        net.Start("BaseWars:LuaRunner")
            net.WriteData(data, #data)
        net.Send(ply)
    end
end)