util.AddNetworkString("BaseWars:Dashboard:SendBountiesToClients")

local function selectAndSendToClients(ply)
    MySQLite.query("SELECT player_id64, CAST(bounty AS DECIMAL) AS bounty FROM basewars_bounty ORDER BY bounty DESC LIMIT 30", function(result)
        result = result or {}

        local compressed = util.Compress(util.TableToJSON(result))
        net.Start("BaseWars:Dashboard:SendBountiesToClients")
            net.WriteData(compressed, #compressed)
        net[IsValid(ply) and "Send" or "Broadcast"](ply)
    end, BaseWarsSQLError)
end

net.Receive("BaseWars:Dashboard:SendBountiesToClients", function(len, ply)
    selectAndSendToClients(ply)
end)

hook.Add("BaseWars:Bounty:PostSetBounty", "BaseWars:DashboardBounties", function()
    selectAndSendToClients()
end)

hook.Add("BaseWars:Bounty:RemoveBounty", "BaseWars:DashboardBounties", function()
    selectAndSendToClients()
end)