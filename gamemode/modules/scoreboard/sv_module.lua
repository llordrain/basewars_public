local PLAYER = FindMetaTable("Player")

function PLAYER:SetGodmode(bool)
    self:SetNWBool("BaseWars.Godmode", bool or false)
end

local cloak, uncloak = Color(0, 0, 0, 0), Color(255, 255, 255, 255)
function PLAYER:SetCloak(bool)
    bool = bool or false

    self:SetNoDraw(bool)
    self:SetColor(bool and cloak or uncloak)
    self:SetNWBool("BaseWars.Cloak", bool)

    local weaps = self:GetWeapons()
    for k, v in ipairs(weaps) do
        if IsValid(v) then
            v:SetNoDraw(bool)
            v:Fire("alpha", bool and 0 or 255)
        end
    end
end

hook.Add("Think", "BaseWars:Cloak", function()
    for _, ply in ipairs(player.GetHumans()) do
        local weapon = ply:GetActiveWeapon()
        local isCloak = ply:IsCloak()

        if IsValid(weapon) then
            weapon:SetNoDraw(isCloak)
            weapon:Fire("alpha", isCloak and 0 or 255)
        end
    end
end)