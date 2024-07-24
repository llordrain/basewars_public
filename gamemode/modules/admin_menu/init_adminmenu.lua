if CLIENT then
    hook.Add("BaseWars:Initialize", "BaseWars:AdminMenu", function()
        BaseWars:AddAdminMenuTab("#bwm_faction", "basewars_materials/f3/faction.png", "BaseWars.AdminMenu.Factions", 1)
        BaseWars:AddAdminMenuTab("#bwm_raid", "basewars_materials/f3/raid.png", "BaseWars.AdminMenu.Raids", 2)
        BaseWars:AddAdminMenuTab("#adminmenu_playerLookup", "basewars_materials/user.png", "BaseWars.AdminMenu.PlayerLookUp", 3)
        -- BaseWars:AddAdminMenuTab("#bwm_config", "basewars_materials/f3/settings.png", "BaseWars.AdminMenu.GamemodeConfig", 9999)
    end)
end