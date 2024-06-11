BaseWars:AddDefaultConfig("Prestige", BWCONFIGTYPE_KEYVALUE, {
    Enable = true,
    BaseLevel = 10000,
    MoreLevel = 5000,
    Point = 2,
    ResetPrice = 1e12,
    RemoveProps = false,
}, {
    ["fr"] = {
        name = "Prestige",
        desc = "Information par rapport au module de prestige.",
        extra = {
            Enable = {
                name = "Prestige",
                desc = "Activer/Désactiver le module de prestige.",
            },
            BaseLevel = {
                name = "Niveau.",
                desc = "Le niveau de base pour prestige.",
            },
            MoreLevel = {
                name = "Extra Niveau",
                desc = "La quantitée de niveau qu'il faut en plus par prestige. [BaseLevel + (MoreLevel * PrestigeDuJoueur)]",
            },
            Point = {
                name = "Point Prestige",
                desc = "Combien de point prestige UN SEUL prestige donne.",
            },
            ResetPrice = {
                name = "Réinitialiser Les Point",
                desc = "Le prix pour réinitialiser UN SEUL point prestige. [ResetPrice * PointDuJoueur]",
            },
            RemoveProps = {
                name = "Retirer les props",
                desc = "Retirer tout les props du joueur quand il prestige",
            }
        }
    },
    ["en"] = {
        name = "Prestige",
        desc = "Configuration the prestige module.",
        extra = {
            Enable = {
                name = "Prestige",
                desc = "Enable/Disable the prestige module.",
            },
            BaseLevel = {
                name = "Base Level",
                desc = "The base level for prestige.",
            },
            MoreLevel = {
                name = "Extra Levels",
                desc = "The number of additional levels required per prestige. [BaseLevel + (MoreLevel * Player's Prestige)]",
            },
            Point = {
                name = "Prestige Points",
                desc = "How many prestige points a SINGLE prestige gives.",
            },
            ResetPrice = {
                name = "Reset Points Price",
                desc = "The price to reset a SINGLE prestige point. [ResetPrice * Player's Points]",
            },
            RemoveProps = {
                name = "Remove Props",
                desc = "When a player prestige, remove all their props",
            }
        }
    }
})

-- FR
BaseWars:AddTranslation("prestige_progression", "fr", "PROGRESSION DU PRESTIGE")
BaseWars:AddTranslation("prestige_duringRaid", "fr", "Vous ne pouvez pas prestige durant un raid")
BaseWars:AddTranslation("prestige_doPrestige", "fr", "Passer prestige %s")
BaseWars:AddTranslation("prestige_prestigePoint", "fr", "Vous avez %s points disponible")
BaseWars:AddTranslation("prestige_tooExpensive", "fr", "Vous ne pouvez pas vous permettre cela")
BaseWars:AddTranslation("prestige_buyPerkNotif", "fr", "Vous avez acheté un niveau de compétence «%s»")
BaseWars:AddTranslation("prestige_playerPrestiged", "fr", "%s est passé prestige %s")
BaseWars:AddTranslation("prestige_buyPerk", "fr", "Acheter pour %s points")
BaseWars:AddTranslation("prestige_maxPerk", "fr", "Niveau de compétence maximum atteint")
BaseWars:AddTranslation("prestige_notEnoughPoint", "fr", "Pas assez de points (%s)")
BaseWars:AddTranslation("prestige_resetPoint", "fr", "Réinitialiser vos points pour %s")
BaseWars:AddTranslation("prestige_level", "fr", "Niveau:")
BaseWars:AddTranslation("prestige_bankInterest", "fr", "Vous avez reçu %s en intérêt de votre banque")
BaseWars:AddTranslation("prestige_price", "fr", "Prix:")
BaseWars:AddTranslation("prestige_perks", "fr", {
    playerHealthName = "Vie",
    playerHealthDesc = "Vous rajoute 10 PV par niveau de compétence.",
    playerArmorName = "Armure",
    playerArmorDesc = "Vous rajoute 10 d'armure par niveau de compétence.",
    playerSpeedName = "Vitesse",
    playerSpeedDesc = "Vous rend 5% plus vite par niveau de compétence.",
    printerUpgradeCostName = "Coût d'amélioration",
    printerUpgradeCostDesc = "Réduit le coût d'amélioration des printer de 5% par niveau de compétence.",
    moreXPName = "XP Augmenté",
    moreXPDesc = "Vous donne 5% plus d'XP par niveau de compétence.",
    playerDamageName = "Dégât Augmenté",
    playerDamageDesc = "Vous ferrez 10% plus de dégât par niveau de compétence.",
    morePrinterName = "Plus de printer",
    morePrinterDesc = "Vous donne la possibilité de faire apparaitre un printer de plus par niveau de compétence.",
    moreMoneyDefaultName = "Argent de prestige",
    moreMoneyDefaultDesc = "Vous donne " .. BaseWars.LANG.Currency .. "20,000 par niveau de compétence de plus quand vous passez un prestige.",
    propHealthName = "Vie des props",
    propHealthDesc = "Vos props auront 50 PV de plus par niveau de compétence.",
    bankInterestName = "intérêt sur la banque",
    bankInterestDesc = "Votre banque vous donne 10% de l'argent qu'elle contient toutes les 15 minutes",
    printerSpeedName = "Imprimantes Rapide",
    printerSpeedDesc = "Vos imprimantes produise 0.05 seconde plus vite par niveau de compétence",
    entityHealthName = "Vie des entitées",
    entityHealthDesc = "Vos entitées auront 250 PV de plus par niveau de compétence",
})

-- EN
BaseWars:AddTranslation("prestige_progression", "en", "PRESTIGE PROGRESSION")
BaseWars:AddTranslation("prestige_duringRaid", "en", "You cannot prestige during a raid")
BaseWars:AddTranslation("prestige_doPrestige", "en", "Prestige %s")
BaseWars:AddTranslation("prestige_prestigePoint", "en", "You have %s points available")
BaseWars:AddTranslation("prestige_tooExpensive", "en", "You cannot afford this")
BaseWars:AddTranslation("prestige_buyPerkNotif", "en", "You bought a \"%s\" skill level")
BaseWars:AddTranslation("prestige_playerPrestiged", "en", "%s is now prestige %s")
BaseWars:AddTranslation("prestige_buyPerk", "en", "Buy for %s points")
BaseWars:AddTranslation("prestige_maxPerk", "en", "Maximum perk level reached")
BaseWars:AddTranslation("prestige_notEnoughPoint", "en", "Not enough points (%s)")
BaseWars:AddTranslation("prestige_resetPoint", "en", "Reset your points for %s")
BaseWars:AddTranslation("prestige_level", "en", "Level:")
BaseWars:AddTranslation("prestige_price", "en", "Price:")
BaseWars:AddTranslation("prestige_bankInterest", "en", "You received %s in interest from your bank")
BaseWars:AddTranslation("prestige_perks", "en", {
    playerHealthName = "Health",
    playerHealthDesc = "Adds 10 HP per skill level.",
    playerArmorName = "Armor",
    playerArmorDesc = "Adds 10 armor per skill level.",
    playerSpeedName = "Speed",
    playerSpeedDesc = "Makes you 5% faster per skill level.",
    printerUpgradeCostName = "Upgrade Cost",
    printerUpgradeCostDesc = "Reduces the cost of printer upgrades by 5% per skill level.",
    moreXPName = "Increased XP",
    moreXPDesc = "Gives you 5% more XP per skill level.",
    playerDamageName = "Increased Damage",
    playerDamageDesc = "Deals 10% more damage per skill level.",
    morePrinterName = "More Printers",
    morePrinterDesc = "Allows you to spawn one more printer per skill level.",
    moreMoneyDefaultName = "Prestige Money",
    moreMoneyDefaultDesc = "Gives you " .. BaseWars.LANG.Currency .. "95,000 more per skill level when you prestige.",
    propHealthName = "Props Health",
    propHealthDesc = "Adds 50 HP per skill level to your props.",
    bankInterestName = "Bank Interest",
    bankInterestDesc = "Your bank gives you 10% of its money every 15 minutes",
    printerSpeedName = "Fast Printers",
    printerSpeedDesc = "Your printers make money 0.05 second faster per skill level",
    entityHealthName = "Entities Health",
    entityHealthDesc = "Adds 250 HP per skill level to your entities",
})

hook.Add("BaseWars:Initialize", "BaseWars:Prestige", function()
    BaseWars:AddPrestigPerk("playerHealth", 5, 1, function()
        if not SERVER then return end

        local function func(ply)
            local extra = ply:GetPrestigePerk("playerHealth") * 10

            timer.Simple(0, function()
                ply:SetMaxHealth(ply:GetMaxHealth() + extra)
                ply:SetHealth(ply:GetMaxHealth())
            end)
        end

        hook.Add("PlayerSpawn", "BaseWars:Prestige:Health", func)
        hook.Add("BaseWars:Prestige:RestorePlayerData", "BaseWars:Prestige:Health", func)
    end)

    BaseWars:AddPrestigPerk("playerArmor", 5, 1, function()
        if not SERVER then return end

        local function func(ply)
            local extra = ply:GetPrestigePerk("playerArmor") * 10

            timer.Simple(0, function()
                ply:SetMaxArmor(ply:GetMaxArmor() + extra)
            end)
        end

        hook.Add("PlayerSpawn", "BaseWars:Prestige:Armor", func)
        hook.Add("BaseWars:Prestige:RestorePlayerData", "BaseWars:Prestige:Armor", func)
    end)

    BaseWars:AddPrestigPerk("playerSpeed", 5, 1, function()
        if not SERVER then return end

        local function func(ply)
            local walkSpeed = 1 + ply:GetPrestigePerk("playerSpeed") * .05
            local runSpeed = 1 + ply:GetPrestigePerk("playerSpeed") * .05

            timer.Simple(0, function()
                ply:SetWalkSpeed(ply:GetWalkSpeed() * walkSpeed)
                ply:SetRunSpeed(ply:GetRunSpeed() * runSpeed)
            end)
        end

        hook.Add("PlayerSpawn", "BaseWars:Prestige:WalkSpeed", func)
        hook.Add("BaseWars:Prestige:RestorePlayerData", "BaseWars:Prestige:WalkSpeed", func)
    end)

    BaseWars:AddPrestigPerk("printerUpgradeCost", 5, 2, function()
        if not SERVER then return end

        hook.Add("BaseWars:BuyEntity", "BaseWars:Prestige:printerUpgradeCost", function(ply, entity, entityID)
            local multiplier = 1 - .05 * ply:GetPrestigePerk("printerUpgradeCost")

            if entity.IsPrinter then
                entity:SetupPrinterCost(BaseWars:GetBaseWarsEntity(entityID):GetPrice() * multiplier)
            end

            if entity.IsBank then
                entity:SetCapacityCost(20000 * multiplier)
                entity:SetHealthCost(entity:GetCapacityCost() * 8)
            end
        end)
    end)

    BaseWars:AddPrestigPerk("moreXP", 5, 2, function()
        if not SERVER then return end

        hook.Add("BaseWars:PlayerGainXP", "BaseWars:Prestige", function(ply)
            return 1 + ply:GetPrestigePerk("moreXP") * .05
        end)
    end)

    BaseWars:AddPrestigPerk("playerDamage", 3, 2, function()
        if not SERVER then return end

        hook.Add("EntityTakeDamage", "BaseWars:Prestige", function(ent, dmg)
            local att = dmg:GetAttacker()
            if att:IsPlayer() then
                local multiplier = 1 + att:GetPrestigePerk("playerDamage") * .1
                dmg:ScaleDamage(multiplier)
            end
        end)
    end)

    BaseWars:AddPrestigPerk("morePrinter", 4, 2, function()
        hook.Add("BaseWars:PrinterCap", "BaseWars:Prestige", function(ply)
            return ply:GetPrestigePerk("morePrinter")
        end)
    end)

    BaseWars:AddPrestigPerk("moreMoneyDefault", 4, 2, function()
        if not SERVER then return end

        hook.Add("BaseWars:Prestige:OnPlayerPrestige", "BaseWars:Prestige", function(ply)
            local money = BaseWars.Config.StartMoney + ply:GetPrestigePerk("moreMoneyDefault") * 95000

            ply:SetMoney(money)
        end)
    end)

    BaseWars:AddPrestigPerk("propHealth", 4, 2, function()
        if not SERVER then return end

        hook.Add("BaseWars:PostSetPropHealth", "BaseWars:Prestige", function(ply, prop)
            local extra = 50 * ply:GetPrestigePerk("propHealth")

            prop:SetMaxHealth(prop:GetMaxHealth() + extra)
            prop:SetHealth(prop:GetMaxHealth())
        end)
    end)

    BaseWars:AddPrestigPerk("printerSpeed", 4, 4, function()
        if not SERVER then return end

        hook.Add("BaseWars:BuyEntity", "BaseWars:Prestige:printerSpeed", function(ply, entity, entityID)
            local level = ply:GetPrestigePerk("printerSpeed")

            if entity.IsPrinter then
                entity:SetPrintInterval(entity:GetPrintInterval() - .05 * level)
            end
        end)
    end)

    BaseWars:AddPrestigPerk("entityHealth", 3, 2, function()
        if not SERVER then return end

        hook.Add("BaseWars:BuyEntity", "BaseWars:Prestige:entityHealth", function(ply, entity, entityID)
            local extra = 250 * ply:GetPrestigePerk("entityHealth")
            local entityHealth = entity:GetMaxHealth()

            entity.PresetHealth = entityHealth + extra
            entity:SetMaxHealth(entityHealth + extra)
            entity:SetHealth(entity:GetMaxHealth())
        end)
    end)

    BaseWars:AddPrestigPerk("bankInterest", 1, 5, function() end)

    -- DO NOT TOUCH, MUST BE AFTER ALL BaseWars:AddPrestigPerk()
    if BaseWars.Config.Prestige.Enable then
        BaseWars:ExecutePrestigePerkFunc()
    end
end)