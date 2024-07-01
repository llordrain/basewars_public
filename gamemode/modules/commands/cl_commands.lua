--[[-------------------------------------------------------------------------
	Refund All
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_refundall", "fr", "Rembourser tout les joueurs connectées")
BaseWars:AddTranslation("EChatCommand_refundall", "en", "Refund all connected players")
BaseWars:AddChatCommand("refundall", BaseWars:GetSuperAdminGroups(), "#EChatCommand_refundall")

--[[-------------------------------------------------------------------------
	Refund Single Player
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_refund", "fr", "Rembourser un joueur")
BaseWars:AddTranslation("EChatCommand_refund", "en", "Refund a player")
BaseWars:AddChatCommand("refund", BaseWars:GetSuperAdminGroups(), "#EChatCommand_refund", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Spawn Bots
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_spawnbot", "fr", "Ajouter des bots")
BaseWars:AddTranslation("EChatCommand_spawnbot", "en", "Add bots")
BaseWars:AddChatCommand("spawnbot", BaseWars:GetSuperAdminGroups(), "#EChatCommand_spawnbot", {
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Kick Bots
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_kickbot", "fr", "Retirer tout les bots")
BaseWars:AddTranslation("EChatCommand_kickbot", "en", "Kick all bots")
BaseWars:AddChatCommand("kickbot", BaseWars:GetSuperAdminGroups(), "#EChatCommand_kickbot")

--[[-------------------------------------------------------------------------
	Player Value
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_playervalue", "fr", "Voir la valeur de toutes les entités d'un joueur")
BaseWars:AddTranslation("EChatCommand_playervalue", "en", "See the value of all the entities of a player")
BaseWars:AddChatCommand("playervalue", BaseWars:GetAdminGroups(true), "#EChatCommand_playervalue", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Drop Weapon
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_dropweapon", "fr", "Jeter une arme au sol")
BaseWars:AddTranslation("EChatCommand_dropweapon", "en", "Drop a weapon on the ground")
BaseWars:AddChatCommand({"drop", "dropweapon", "weapondrop"}, nil, "#EChatCommand_dropweapon")

--[[-------------------------------------------------------------------------
	Reload Themes
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_reloadthemes", "fr", "Recharger vos thèmes")
BaseWars:AddTranslation("EChatCommand_reloadthemes", "en", "Reload your themes")
BaseWars:AddChatCommand("reloadthemes", nil, "#EChatCommand_reloadthemes")

--[[-------------------------------------------------------------------------
	Respawn
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_respawn", "fr", "Réapparaître un joueur")
BaseWars:AddTranslation("EChatCommand_respawn", "en", "respawn a player")
BaseWars:AddChatCommand("respawn", BaseWars:GetAdminGroups(true), "#EChatCommand_respawn", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Reset Player
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_resetplayer", "fr", "Supprimer tout les profils d'une joueur")
BaseWars:AddTranslation("EChatCommand_resetplayer", "en", "Delete all profiles of a player")
BaseWars:AddChatCommand("resetplayer", BaseWars:GetSuperAdminGroups(), "#EChatCommand_resetplayer", {
	"<SteamID64>"
})

BaseWars:AddTranslation("EChatCommand_deleteplayer", "fr", "Supprimer toutes les données d'un joueur")
BaseWars:AddTranslation("EChatCommand_deleteplayer", "en", "Delete all data of a player")
BaseWars:AddChatCommand("deleteplayer", BaseWars:GetSuperAdminGroups(), "#EChatCommand_deleteplayer", {
	"<SteamID64>"
})

--[[-------------------------------------------------------------------------
	Max printers
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_max", "fr", "Maxer une imprimante")
BaseWars:AddTranslation("EChatCommand_max", "en", "Max a printer")
BaseWars:AddChatCommand("max", nil, "#EChatCommand_max", {
	"<true/false>"
})

--[[-------------------------------------------------------------------------
	Open printer's upgrade menu
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_upgrade", "fr", "Améliorer une imprimante")
BaseWars:AddTranslation("EChatCommand_upgrade", "en", "Upgrade a printer")
BaseWars:AddChatCommand({"upg", "upgrade"}, nil, "#EChatCommand_upgrade")

--[[-------------------------------------------------------------------------
	Set Entity Owner
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_setowner", "fr", "Change le owner d'une entitée")
BaseWars:AddTranslation("EChatCommand_setowner", "en", "Change the entity owner")
BaseWars:AddChatCommand("setowner", BaseWars:GetSuperAdminGroups(), "#EChatCommand_setowner", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Get Entity Class
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_getowner", "fr", "Mettre dans la console la class de l'entitée que vous regardez")
BaseWars:AddTranslation("EChatCommand_getowner", "en", "Print in the console the class of the entity you're looking at")
BaseWars:AddChatCommand("getclass", BaseWars:GetSuperAdminGroups(), "#EChatCommand_getowner")

--[[-------------------------------------------------------------------------
	Admin Chat
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_adminchat", "fr", "Utiliser le chat admin")
BaseWars:AddTranslation("EChatCommand_adminchat", "en", "Use the admin chat")
BaseWars:AddChatCommand({"ac", "adminchat"}, BaseWars:GetAdminGroups(true), "#EChatCommand_adminchat", {
	"<message>"
})

--[[-------------------------------------------------------------------------
	PayDay
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_paydaytime", "fr", "Temps avant prochaine paye")
BaseWars:AddTranslation("EChatCommand_paydaytime", "en", "Time until next payday")
BaseWars:AddChatCommand("paydaytime", nil, "#EChatCommand_paydaytime")

--[[-------------------------------------------------------------------------
	Profile Selector
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_profile", "fr", "Changer de profil")
BaseWars:AddTranslation("EChatCommand_profile", "en", "Change profile")
BaseWars:AddChatCommand("profile", nil, "#EChatCommand_profile")

--[[-------------------------------------------------------------------------
	Lock / Unlock doors
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_lock", "fr", "Verrouiller la porte que vous regardez")
BaseWars:AddTranslation("EChatCommand_lock", "en", "Lock the door you're looking at")
BaseWars:AddChatCommand("lock", BaseWars:GetAdminGroups(true), "#EChatCommand_lock")

BaseWars:AddTranslation("EChatCommand_lockall", "fr", "Verrouiller toutes les portes")
BaseWars:AddTranslation("EChatCommand_lockall", "en", "Lock all doors")
BaseWars:AddChatCommand("lockall", BaseWars:GetAdminGroups(true), "#EChatCommand_lockall")

BaseWars:AddTranslation("EChatCommand_unlock", "fr", "Déverrouiller la porte que vous regardez")
BaseWars:AddTranslation("EChatCommand_unlock", "en", "Unlock the door you're looking at")
BaseWars:AddChatCommand("unlock", BaseWars:GetAdminGroups(true), "#EChatCommand_unlock")

BaseWars:AddTranslation("EChatCommand_unlockal", "fr", "Déverrouiller toutes les portes")
BaseWars:AddTranslation("EChatCommand_unlockal", "en", "Unlock all doors")
BaseWars:AddChatCommand("unlockall", BaseWars:GetAdminGroups(true), "#EChatCommand_unlockal")

--[[-------------------------------------------------------------------------
	Fuck fire
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_stopfire", "fr", "Stopper le feu?")
BaseWars:AddTranslation("EChatCommand_stopfire", "en", "Stop fire?")
BaseWars:AddChatCommand("stopfire", BaseWars:GetAdminGroups(true), "#EChatCommand_stopfire")

--[[-------------------------------------------------------------------------
	Find Entities (Of a player)
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_findentsof", "fr", "Mettre en surbrillance les entitées d'un joueur")
BaseWars:AddTranslation("EChatCommand_findentsof", "en", "Highlight the entities of a player")
BaseWars:AddChatCommand("findentsof", BaseWars:GetAdminGroups(true), "#EChatCommand_findentsof")

--[[-------------------------------------------------------------------------
	Admin Menu
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_admin", "fr", "Ouvrir le menu admin")
BaseWars:AddTranslation("EChatCommand_admin", "en", "Open the admin menu")
BaseWars:AddChatCommand("admin", BaseWars:GetAdminGroups(true), "#EChatCommand_admin")

--[[-------------------------------------------------------------------------
	Bounty
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_bounty", "fr", "Mettre une prime sur un joueur")
BaseWars:AddTranslation("EChatCommand_bounty", "en", "Put a bounty on a player")
BaseWars:AddChatCommand("bounty", nil, "#EChatCommand_bounty", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Force Bounty
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_forcebounty", "fr", "Mettre une prime sur un joueur (ADMIN)")
BaseWars:AddTranslation("EChatCommand_forcebounty", "en", "Put a bounty on a player (ADMIN)")
BaseWars:AddChatCommand("forcebounty", BaseWars:GetSuperAdminGroups(), "#EChatCommand_forcebounty", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Message
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_message", "fr", "Enboyer un message privé a un joueur")
BaseWars:AddTranslation("EChatCommand_message", "en", "Send a private message to a player")
BaseWars:AddChatCommand({"msg", "message"}, nil, "#EChatCommand_message", {
	"<player>",
	"<message>"
})

--[[-------------------------------------------------------------------------
	Pay
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_pay", "fr", "Donner de l'argent a un joueur")
BaseWars:AddTranslation("EChatCommand_pay", "en", "Give a player money")
BaseWars:AddChatCommand("pay", nil, "#EChatCommand_pay", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Dashboard
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_dashbaord", "fr", "Ouvrir le dashbaord")
BaseWars:AddTranslation("EChatCommand_dashbaord", "en", "Open the dashbaord")
BaseWars:AddChatCommand({"dashboard"}, nil, "#EChatCommand_dashbaord")

--[[-------------------------------------------------------------------------
	Leaderboard
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_leaderboard", "fr", "Ouvrir l'onglet leaderboard")
BaseWars:AddTranslation("EChatCommand_leaderboard", "en", "Open the leaderboard tab")
BaseWars:AddChatCommand("leaderboard", nil, "#EChatCommand_leaderboard")

--[[-------------------------------------------------------------------------
	Faction
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_faction", "fr", "Ouvrir l'onglet faction")
BaseWars:AddTranslation("EChatCommand_faction", "en", "Open the faction tab")
BaseWars:AddChatCommand("faction", nil, "#EChatCommand_faction")

--[[-------------------------------------------------------------------------
	Raid
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_raid", "fr", "Ouvrir l'onglet raid")
BaseWars:AddTranslation("EChatCommand_raid", "en", "Open the raid tab")
BaseWars:AddChatCommand("raid", nil, "#EChatCommand_raid")

--[[-------------------------------------------------------------------------
	Sell
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_sell", "fr", "Ouvrir l'onglet vente")
BaseWars:AddTranslation("EChatCommand_sell", "en", "Open the sell tab")
BaseWars:AddChatCommand("sell", nil, "#EChatCommand_sell")

--[[-------------------------------------------------------------------------
	Permanent Weapons
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_permanentweapon", "fr", "Ouvrir l'onglet permanent weapons")
BaseWars:AddTranslation("EChatCommand_permanentweapon", "en", "Open the permanent weapons tab")
BaseWars:AddChatCommand({"permanentweapon", "pw"}, nil, "#EChatCommand_permanentweapon")

--[[-------------------------------------------------------------------------
	Prestige
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_prestige", "fr", "Ouvrir l'onglet prestiges")
BaseWars:AddTranslation("EChatCommand_prestige", "en", "Open the prestige tab")
BaseWars:AddChatCommand("prestige", nil, "#EChatCommand_prestige")

--[[-------------------------------------------------------------------------
	Config
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_config", "fr", "Ouvrir l'onglet config")
BaseWars:AddTranslation("EChatCommand_config", "en", "Open the config tab")
BaseWars:AddChatCommand("config", nil, "#EChatCommand_config")

--[[-------------------------------------------------------------------------
	Shop
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_shop", "fr", "Ouvrir l'onglet shop")
BaseWars:AddTranslation("EChatCommand_shop", "en", "Open the shop tab")
BaseWars:AddChatCommand("shop", nil, "#EChatCommand_shop")

--[[-------------------------------------------------------------------------
	Level Manipulation
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_setlevel", "fr", "Changer le niveau d'un joueur")
BaseWars:AddTranslation("EChatCommand_setlevel", "en", "Set a player level")
BaseWars:AddChatCommand("setlevel", BaseWars:GetSuperAdminGroups(), "#EChatCommand_setlevel", {
	"<player>",
	"<amount>"
})

BaseWars:AddTranslation("EChatCommand_addlevel", "fr", "Ajouter des niveaux a un joueur")
BaseWars:AddTranslation("EChatCommand_addlevel", "en", "Give levels to a player")
BaseWars:AddChatCommand("addlevel", BaseWars:GetSuperAdminGroups(), "#EChatCommand_addlevel", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	XP Manipulation
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_setxp", "fr", "Changer l'xp d'un joueur")
BaseWars:AddTranslation("EChatCommand_setxp", "en", "Set a player xp")
BaseWars:AddChatCommand("setxp", BaseWars:GetSuperAdminGroups(), "#EChatCommand_setxp", {
	"<player>",
	"<amount>"
})

BaseWars:AddTranslation("EChatCommand_addxp", "fr", "Ajouter de l'xp a un joueur")
BaseWars:AddTranslation("EChatCommand_addxp", "en", "Give xp to a player")
BaseWars:AddChatCommand("addxp", BaseWars:GetSuperAdminGroups(), "#EChatCommand_addxp", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Money Manipulation
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_setmoney", "fr", "Changer l'argent d'un joueur")
BaseWars:AddTranslation("EChatCommand_setmoney", "en", "Set a player money")
BaseWars:AddChatCommand("setmoney", BaseWars:GetSuperAdminGroups(), "#EChatCommand_setmoney", {
	"<player>",
	"<amount>"
})

BaseWars:AddTranslation("EChatCommand_addmoney", "fr", "Ajouter de l'argent joueur")
BaseWars:AddTranslation("EChatCommand_addmoney", "en", "Give money to a player")
BaseWars:AddChatCommand("addmoney", BaseWars:GetSuperAdminGroups(), "#EChatCommand_addmoney", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	Prestige Manipulation
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_setprestige", "fr", "Changer le prestige d'un joueur")
BaseWars:AddTranslation("EChatCommand_setprestige", "en", "Set a player prestige")
BaseWars:AddChatCommand("setprestige", BaseWars:GetSuperAdminGroups(), "#EChatCommand_setprestige", {
	"<player>",
	"<amount>"
})

BaseWars:AddTranslation("EChatCommand_addprestige", "fr", "Ajouter des prestiges à un joueur")
BaseWars:AddTranslation("EChatCommand_addprestige", "en", "Give prestigse to a player")
BaseWars:AddChatCommand("addprestige", BaseWars:GetSuperAdminGroups(), "#EChatCommand_addprestige", {
	"<player>",
	"<amount>"
})

--[[-------------------------------------------------------------------------
	God
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_god", "fr", "Basculer le god mode")
BaseWars:AddTranslation("EChatCommand_god", "en", "Toggle god mode")
BaseWars:AddChatCommand("god", BaseWars:GetAdminGroups(true), "#EChatCommand_god", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Cloak
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_cloak", "fr", "Basculer le cloak mode")
BaseWars:AddTranslation("EChatCommand_cloak", "en", "Toggle cloak mode")
BaseWars:AddChatCommand("cloak", BaseWars:GetAdminGroups(true), "#EChatCommand_cloak", {
	"<player>"
})

--[[-------------------------------------------------------------------------
	Live Logs
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_livelogs", "fr", "Ouvrir/Fermer les log live")
BaseWars:AddTranslation("EChatCommand_livelogs", "en", "Open/Close livelogs")
BaseWars:AddChatCommand("livelogs", BaseWars:GetAdminGroups(true), "#EChatCommand_livelogs")

--[[-------------------------------------------------------------------------
	Cancel Raid
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_cancelraid", "fr", "Arreter un raid de force")
BaseWars:AddTranslation("EChatCommand_cancelraid", "en", "Force stop a raid")
BaseWars:AddChatCommand("cancelraid", BaseWars:GetAdminGroups(true), "#EChatCommand_cancelraid")

--[[-------------------------------------------------------------------------
	Clear Notif
---------------------------------------------------------------------------]]
BaseWars:AddTranslation("EChatCommand_clearnotif", "fr", "Supprimer toutes les notifications")
BaseWars:AddTranslation("EChatCommand_clearnotif", "en", "Clear all your notifications")
BaseWars:AddChatCommand("clearnotif", nil, "#EChatCommand_clearnotif")

-- CONSOLE COMMAND
-- CONSOLE COMMAND
-- CONSOLE COMMAND

--[[-------------------------------------------------------------------------
	Run lua on client
---------------------------------------------------------------------------]]
concommand.Add("luarun_cl", function(ply, cmd, args, agrStr)
	if ply:IsPlayer() and not BaseWars:IsSuperAdmin(ply) then return end

	BaseWars:Log("LUA RUN - START")
	local startRun = SysTime()
	RunString(agrStr, "luarun_cl [from: " .. (ply:IsPlayer() and ply:Name() or "???") .. "]")
	local endRun = SysTime()
	BaseWars:Log("LUA RUN - END")
	BaseWars:Log(Format("You ran \"" .. agrStr .. "\" in %.7f sec", endRun - startRun))
end)

--[[-------------------------------------------------------------------------
	Calculate XP
---------------------------------------------------------------------------]]
concommand.Add("calculatexp", function(ply, cmd, args, argStr)
	if not args[1] then
		BaseWars:Warning("Invalid argument")
		return
	end

	local targetLevel = tonumber(args[1])
	local beginLevel = tonumber(args[2]) or 1
	local marker = 1000
	local xp = 0

	if targetLevel < 100000000 then
		marker = 100000
	end

	if targetLevel > 100000000 then
		marker = 20000000
	end

	local startCalculating = SysTime()
	for i = beginLevel, targetLevel do
		xp = xp + BaseWars:GetLevelXP(i)

		if i % marker == 0 then
			BaseWars:Log(string.Comma(i) .. " [" .. math.Round(i / targetLevel * 100, 3) .. "%]")
		end
	end
	local endCalculating = SysTime()

	local time = endCalculating - startCalculating
	if time >= 100 then
		time = BaseWars:FormatTime2(time)
	else
		time = string.sub(time, 1, string.len(math.floor(time)) + 7)
	end

	BaseWars:Log("You need " .. BaseWars:FormatNumber(xp) .. " xp to be level " .. BaseWars:FormatNumber(targetLevel))
	BaseWars:Log("Took " .. time .. " secs to calculate!")
end)