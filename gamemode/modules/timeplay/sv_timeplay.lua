local PLAYER = FindMetaTable("Player")

function PLAYER:SetTimePlayed(num)
    self:SetNWFloat("BaseWars.TimePlayed", num)
end

timer.Create("BaseWars.SaveTimePlayed", 30, 0, function()
    for k, v in player.Iterator() do
        if not v.basewarsProfileID then continue end
        MySQLite.query(([[UPDATE basewars_player SET time_played = %s WHERE player_id64 = %s and profile_id = %s]]):format(v:GetTimePlayed(), v:SteamID64(), v.basewarsProfileID), function() end, BaseWarsSQLError)
    end
end)