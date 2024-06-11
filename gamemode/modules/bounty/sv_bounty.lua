util.AddNetworkString("BaseWars:Bounty")
local PLAYER = FindMetaTable("Player")

function PLAYER:SetBountySpawn(num)
    num = math.floor(tonumber(num))
    self:SetNWFloat("BaseWars.Bounty", num)
end

function PLAYER:SetBounty(num, cummulate)
    num = math.floor(tonumber(num))

    if self:HasBounty() and cummulate then
        num = num + self:GetBounty()
    end

    self:SetNWFloat("BaseWars.Bounty", num)

    if num <= 0 then
        MySQLite.query(([[DELETE FROM basewars_bounty WHERE player_id64 = %s]]):format(self:SteamID64()), function()
            hook.Run("BaseWars:Bounty:RemoveBounty", self)
        end, BaseWarsSQLError)
    else
        MySQLite.query(([[SELECT * FROM basewars_bounty WHERE player_id64 = %s]]):format(self:SteamID64()), function(result)
            if result then
                MySQLite.query(([[UPDATE basewars_bounty SET bounty = %s, stack = stack + 1 WHERE player_id64 = %s]]):format(num, self:SteamID64()), function()
                    hook.Run("BaseWars:Bounty:PostSetBounty", self, num)
                end, BaseWarsSQLError)
            else
                MySQLite.query(([[INSERT INTO basewars_bounty (player_id64, bounty, stack) VALUES (%s, %s, 1)]]):format(self:SteamID64(), num), function()
                    hook.Run("BaseWars:Bounty:PostSetBounty", self, num)
                end, BaseWarsSQLError)
            end
        end, BaseWarsSQLError)
    end
end

net.Receive("BaseWars:Bounty", function(len, ply)
    local target = net.ReadEntity()
    local amount = net.ReadDouble()

    if amount < 0 or BaseWars.Config.MaxBounty < 0 then return end

    local money = ply:GetMoney()
    if amount > money then
        amount = money
    end

    if BaseWars.Config.MaxBounty > 0 then
        amount = math.min(amount, BaseWars.Config.MaxBounty)
    end

    if ply:CanAfford(amount) and (IsValid(target) and target:IsPlayer()) then
        ply:TakeMoney(amount)

        hook.Run("BaseWars:Bounty:SetOnPlayer", ply, target, target:GetBounty(), amount)

        target:SetBounty(amount, true)
        BaseWars:NotifyAll("#bounty_placedOn", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatMoney(amount), target:Name())
    end
end)

hook.Add("DoPlayerDeath", "BaseWars:Bounty", function(ply, attacker, dmginfo)
    if (IsValid(attacker) and attacker:IsPlayer()) and attacker != ply and ply:HasBounty() then
        local bounty = ply:GetBounty()
        attacker:GiveMoney(bounty)
        ply:SetBounty(0)

        hook.Run("BaseWars:Bounty:ClaimBounty", ply, attacker, bounty)

        BaseWars:NotifyAll("#bounty_receivedBounty", ONTIFICATION_GENERIC, 5, attacker:Name(), BaseWars:FormatMoney(bounty), ply:Name())
    end
end)

hook.Add("PlayerInitialSpawn", "BaseWars:Bounty", function(ply)
    MySQLite.query(([[SELECT * FROM basewars_bounty WHERE player_id64 = %s]]):format(ply:SteamID64()), function(result)
        if not IsValid(ply) then return end

        if result then
            result = result[1]

            ply:SetBountySpawn(tonumber(result.bounty))
        end
    end, BaseWarsSQLError)
end)