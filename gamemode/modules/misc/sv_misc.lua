local clearDecalsTime = 0
local stopFireTime = 0
hook.Add("Think", "BaseWars:ClearDecals", function()
    if CurTime() >= clearDecalsTime then
        for k, v in player.Iterator() do
            v:ConCommand("r_cleardecals")
        end

        clearDecalsTime = CurTime() + 30
    end

    if CurTime() >= stopFireTime then
        for k, v in ents.Iterator() do
            if not IsValid(v) then continue end
            if not v:IsOnFire() then continue end

            v:Extinguish()
        end

        stopFireTime = CurTime() + 30
    end
end)