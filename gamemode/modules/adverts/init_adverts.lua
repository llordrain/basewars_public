BaseWars:AddTranslation("adverts_collection", "fr", "La collection du serveur: <link:https://steamcommunity.com/sharedfiles/filedetails/?id=3226981857>")

BaseWars:AddTranslation("adverts_collection", "en", "The server's ollection: <link:https://steamcommunity.com/sharedfiles/filedetails/?id=3226981857>")

if SERVER then
    hook.Add("BaseWars:Initialize", "BaseWars:Adverts", function()
        -- BaseWars:AddAdvert(600, "#adverts_collection")
    end)
end