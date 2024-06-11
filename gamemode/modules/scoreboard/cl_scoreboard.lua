function GM:ScoreboardHide()
	ScoreboardFrame:Remove()

	-- if IsValid(ScoreboardFrame) then
	-- 	ScoreboardFrame:Hide()
	-- end
end

function GM:ScoreboardShow()
	if not IsValid(ScoreboardFrame) then
		ScoreboardFrame = vgui.Create("BaseWars.Scoreboard")
	end

	-- if IsValid(ScoreboardFrame) then
	-- 	ScoreboardFrame:Show()
	-- 	ScoreboardFrame.startTime = SysTime()
	-- else
	-- 	ScoreboardFrame = vgui.Create("BaseWars.Scoreboard")
	-- end
end

local icons = {
	god = Material("materials/basewars_materials/hud/spawn_protection.png", "smooth"),
	cloak = Material("materials/basewars_materials/hud/cloak.png", "smooth"),
	faction_leader = Material("materials/basewars_materials/scoreboard/faction_leader.png", "smooth"),
	user = Material("materials/basewars_materials/user.png", "smooth"),
	vip = Material("materials/basewars_materials/scoreboard/vip.png", "smooth"),
	admin = Material("materials/basewars_materials/scoreboard/admin.png", "smooth"),
}

local infosPos = {
	name = BaseWars.ScreenScale * 40,
	level = BaseWars.ScreenScale * 400,
	prestige = BaseWars.ScreenScale * 550,
	deaths = BaseWars.ScreenScale * 150,
	kills = BaseWars.ScreenScale * 300,
}

local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local PANEL = {}
function PANEL:Init()
	self.startTime = SysTime()
	self.localPlayer = LocalPlayer()
	self.allPlayers = {}
	self.factions = {}

	self:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
	self:Center()
	self:MakePopup()

	self.Title = self:Add("DPanel")
	self.Title:Dock(TOP)
	self.Title:SetTall(BaseWars.ScreenScale * 60)
	self.Title.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, GetBaseWarsTheme("scoreboard_titleBar"), true, true, false, false)
		draw.SimpleText(GetHostName(), "BaseWars.36", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)

		-- Player Count
		BaseWars:DrawMaterial(icons["user"], h * .5, h * .5, BaseWars.ScreenScale * 20, BaseWars.ScreenScale * 20, GetBaseWarsTheme("scoreboard_text"), 0)
		draw.SimpleText(player.GetCount(), "BaseWars.20", h * .8, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end

	self.Body = self:Add("DPanel")
	self.Body:Dock(FILL)
	self.Body:InvalidateParent(true)
	self.Body.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, GetBaseWarsTheme("scoreboard_background"), false, false, true, true)
	end

	self:CreatePlayerList()
	BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:CreatePlayerList()
	self:ClearBody()

	self.allPlayers = {}
	self.factions = {}

	self.Body.TopBar = self.Body:Add("DPanel")
	self.Body.TopBar:Dock(TOP)
	self.Body.TopBar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Body.TopBar:SetTall(BaseWars.ScreenScale * 40)
	self.Body.TopBar.Paint = function(s,w,h)
		local textColor, font = GetBaseWarsTheme("scoreboard_text"), "BaseWars.20"

		BaseWars:DrawMaterial(icons["user"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, GetBaseWarsTheme("scoreboard_text"))

		draw.SimpleText(self.localPlayer:GetLang("scoreboard", "name"), font, infosPos["name"], h * .5, textColor, 0, 1)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard", "level"), font, infosPos["level"], h * .5, textColor, 0, 1)
		if BaseWars.Config.Prestige.Enable then
			draw.SimpleText(self.localPlayer:GetLang("scoreboard", "prestige"), font, infosPos["prestige"], h * .5, textColor, 0, 1)
		end
		draw.SimpleText(self.localPlayer:GetLang("scoreboard", "deaths"), font, w - infosPos["deaths"], h * .5, textColor, 2, 1)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard", "kills"), font, w - infosPos["kills"], h * .5, textColor, 2, 1)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard", "ping"), font, w - bigMargin, h * .5, textColor, 2, 1)
	end

	self.Body.PlayersList = self.Body:Add("DScrollPanel")
	self.Body.PlayersList:Dock(FILL)
	self.Body.PlayersList:DockMargin(bigMargin, 0, bigMargin, bigMargin)
	self.Body.PlayersList:PaintScrollBar("scoreboard")
end

function PANEL:ClearBody()
	for k, v in pairs(self.Body:GetChildren()) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function PANEL:Think()
	for _, ply in player.Iterator() do
		if self.allPlayers[ply] == nil then
			self:AddPlayer(ply)
		end
	end
end

function PANEL:AddPlayer(ply)
	local plyFaction = ply:GetFaction(self.localPlayer)
	local plyFactionColor = ply:GetFactionColor(self.localPlayer)
	local IsFactionLeader = ply:IsFactionLeader()

	if not self.factions[plyFaction] then
		local factionCat = self.Body.PlayersList:Add("BaseWars.Cagory")
		factionCat:Dock(TOP)
		factionCat:SetName(plyFaction)
		factionCat:SetAccentColor(plyFactionColor)
		factionCat:SetTextColor(plyFactionColor)
		factionCat:SetColor(GetBaseWarsTheme("scoreboard_categoryBar"))
		factionCat.Tick = function(s)
			if #s:GetChildren() <= 1 then
				s:Remove()

				if plyFaction != self.localPlayer:GetLang("faction_noFaction") then
					self.factions[plyFaction] = nil
				end
			end
		end

		self.factions[plyFaction] = factionCat
	end

	local cat = self.factions[plyFaction]
	local playerPanel = cat:Add("DButton")
	playerPanel:SetText("")
	playerPanel:SetTall(BaseWars.ScreenScale * 40)
	playerPanel:Dock(TOP)
	playerPanel:DockMargin(0, margin, 0, 0)
	playerPanel.lerpColor = GetBaseWarsTheme("scoreboard_contentBackground")
	playerPanel.Paint = function(s,w,h)
		s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, s:IsHovered() and GetBaseWarsTheme("scoreboard_contentBackground2") or GetBaseWarsTheme("scoreboard_contentBackground"))

		if not IsValid(ply) then
			return
		end

		BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)

		local textColor, font = GetBaseWarsTheme("scoreboard_text"), "BaseWars.20"
		local ping = ply:Ping()
		local nameW, _ = BaseWars:GetTextSize(ply:Name(), font)
		local iconSize = h - bigMargin * 2

		local userGroup = "user"
		if BaseWars:IsAdmin(ply) then
			userGroup = "admin"
		elseif BaseWars:IsVIP(ply) then
			userGroup = "vip"
		end

		BaseWars:DrawMaterial(icons[userGroup], bigMargin, bigMargin, iconSize, iconSize, GetBaseWarsTheme("scoreboard_text"))

		if IsFactionLeader then
			BaseWars:DrawMaterial(icons["faction_leader"], h + nameW + bigMargin, bigMargin, iconSize, iconSize, plyFactionColor)
		end

		if BaseWars:IsAdmin(self.localPlayer, true) then
			if ply:IsGodmode() or ply:HasSpawnProtection() or ply:InSafeZone() then
				BaseWars:DrawMaterial(icons["god"], infosPos["level"] - bigMargin - iconSize * 2, bigMargin, iconSize, iconSize, (ply:HasSpawnProtection() or ply:InSafeZone()) and HSVToColor(0, math.abs(math.sin(CurTime() * 2)), 1) or textColor)
			end

			if ply:IsCloak() then
				BaseWars:DrawMaterial(icons["cloak"], infosPos["level"] - margin - bigMargin * 2 - iconSize * 3, bigMargin, iconSize, iconSize, textColor)
			end
		end

		draw.SimpleText(ply:Name(), font, infosPos["name"], h * .5, plyFactionColor, 0, 1)
		draw.SimpleText(BaseWars:FormatNumber(ply:GetLevel()), font, infosPos["level"], h * .5, textColor, 0, 1)
		if BaseWars.Config.Prestige.Enable then
			draw.SimpleText(BaseWars:FormatNumber(ply:GetPrestige()), font, infosPos["prestige"], h * .5, textColor, 0, 1)
		end
		draw.SimpleText(string.Comma(ply:Deaths()), font, w - infosPos["deaths"], h * .5, textColor, 2, 1)
		draw.SimpleText(string.Comma(ply:Frags()), font, w - infosPos["kills"], h * .5, textColor, 2, 1)
		draw.SimpleText(ping > 0 and string.Comma(ping) or "!", ping > 0 and font or "BaseWars.26", w - bigMargin, h * .5, ping > 0 and textColor or GetBaseWarsTheme("scoreboard_noPing"), 2, 1)
	end
	playerPanel.DoClick = function(s)
		if BaseWars:IsAdmin(self.localPlayer, true) then
			surface.PlaySound("bw_button.wav")
			self:PlayerPanel(ply)
		else
			SetClipboardText(ply:SteamID())
			BaseWars:Notify("#scoreboard_steamidCopied", NOTIFICATION_GENERIC, 5, ply:Name())
		end
	end
	playerPanel.Think = function(s)
		if not IsValid(ply) then
			s:Remove()
			return
		end

		if ply:GetFaction(self.localPlayer) != plyFaction then
			self.allPlayers[ply] = nil
			s:Remove()
		end
	end

	self.allPlayers[ply] = playerPanel
end

function PANEL:PlayerPanel(ply)
	self:ClearBody()

	self.PlayerInfos = self.Body:Add("DPanel")
	self.PlayerInfos:Dock(TOP)
	self.PlayerInfos:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.PlayerInfos:SetTall(BaseWars.ScreenScale * 250)
	self.PlayerInfos.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("scoreboard_contentBackground"))
	end

	self.PlayerInfos.Avatar = self.PlayerInfos:Add("AvatarMaterial")
	self.PlayerInfos.Avatar:Dock(LEFT)
	self.PlayerInfos.Avatar:DockMargin(bigMargin * 2, bigMargin * 2, bigMargin * 2, bigMargin * 2)
	self.PlayerInfos.Avatar:SetWide(self.PlayerInfos:GetTall() - bigMargin * 4)
	self.PlayerInfos.Avatar:SetPlayer(ply)

	self.PlayerInfos.Infos = self.PlayerInfos:Add("DPanel")
	self.PlayerInfos.Infos:Dock(FILL)
	self.PlayerInfos.Infos:DockMargin(0, bigMargin, bigMargin, bigMargin)
	self.PlayerInfos.Infos.Paint = function(s,w,h)
		-- RIGHT SIDE
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_rank"):format(ply:GetUserGroup()), "BaseWars.20", bigMargin, margin, GetBaseWarsTheme("scoreboard_darkText"))
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_faction"):format(ply:GetFaction()), "BaseWars.20", bigMargin, BaseWars.ScreenScale * 25, GetBaseWarsTheme("scoreboard_darkText"))
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_factionLeader"):format(ply:IsFactionLeader() and self.localPlayer:GetLang("yes") or self.localPlayer:GetLang("no")), "BaseWars.20", bigMargin, BaseWars.ScreenScale * 45, GetBaseWarsTheme("scoreboard_darkText"))
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_hp"):format(string.Comma(ply:Health()), string.Comma(ply:GetMaxHealth())), "BaseWars.20", bigMargin, BaseWars.ScreenScale * 65, GetBaseWarsTheme("scoreboard_darkText"))
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_armor"):format(string.Comma(ply:Armor()), string.Comma(ply:GetMaxArmor())), "BaseWars.20", bigMargin, BaseWars.ScreenScale * 85, GetBaseWarsTheme("scoreboard_darkText"))

		if BaseWars.Config.Prestige.Enable then
			draw.SimpleText(self.localPlayer:GetLang("scoreboard_prestige"):format(BaseWars:FormatNumber(ply:GetPrestige())), "BaseWars.20", bigMargin, h - BaseWars.ScreenScale * 85, GetBaseWarsTheme("scoreboard_darkText"), 0, TEXT_ALIGN_BOTTOM)
		end

		draw.SimpleText(self.localPlayer:GetLang("scoreboard_money"):format(BaseWars:FormatMoney(ply:GetMoney())), "BaseWars.20", bigMargin, h - BaseWars.ScreenScale * 65, GetBaseWarsTheme("scoreboard_darkText"), 0, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_level"):format(BaseWars:FormatNumber(ply:GetLevel())), "BaseWars.20", bigMargin, h - BaseWars.ScreenScale * 45, GetBaseWarsTheme("scoreboard_darkText"), 0, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_xp"):format(BaseWars:FormatNumber(ply:GetXP(), true), BaseWars:FormatNumber(ply:GetXPNextLevel(), true)), "BaseWars.20", bigMargin, h - BaseWars.ScreenScale * 25, GetBaseWarsTheme("scoreboard_darkText"), 0, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_timeplay"):format(BaseWars:FormatTime2(ply:GetTimePlayed(), self.localPlayer)), "BaseWars.20", bigMargin, h - margin, GetBaseWarsTheme("scoreboard_darkText"), 0, TEXT_ALIGN_BOTTOM)

		-- LEFT SIDE
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_kd"):format(ply:Frags(), ply:Deaths(), math.Round(math.max(math.min(1, ply:Frags()), ply:Frags()) / math.max(math.min(1, ply:Deaths()), ply:Deaths()), 2)), "BaseWars.20", w, margin, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_ping"):format(ply:Ping()), "BaseWars.20", w, BaseWars.ScreenScale * 25, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_bounty"):format(BaseWars:FormatMoney(ply:GetBounty())), "BaseWars.20", w, BaseWars.ScreenScale * 45, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_afk"):format(ply:IsAFK() and BaseWars:FormatTime2(math.ceil(CurTime() - ply:GetAFKTime())) or ply:GetLang("no")), "BaseWars.20", w, BaseWars.ScreenScale * 65, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_god"):format(ply:IsGodmode() and self.localPlayer:GetLang("yes") or self.localPlayer:GetLang("no")), "BaseWars.20", w, BaseWars.ScreenScale * 85, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_cloak"):format(ply:IsCloak() and self.localPlayer:GetLang("yes") or self.localPlayer:GetLang("no")), "BaseWars.20", w, BaseWars.ScreenScale * 105, GetBaseWarsTheme("scoreboard_darkText"), TEXT_ALIGN_RIGHT)
	end

	self.PlayerInfos.QuickActions = self.PlayerInfos:Add("DPanel")
	self.PlayerInfos.QuickActions:Dock(RIGHT)
	self.PlayerInfos.QuickActions:DockMargin(bigMargin, 0, 0, 0)
	self.PlayerInfos.QuickActions:SetWide(BaseWars.ScreenScale * 400)
	self.PlayerInfos.QuickActions.Paint = nil

	self.PlayerInfos.QuickActions.SteamID = self.PlayerInfos.QuickActions:Add("OLD.BaseWars.Button")
	self.PlayerInfos.QuickActions.SteamID:Dock(TOP)
	self.PlayerInfos.QuickActions.SteamID:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	self.PlayerInfos.QuickActions.SteamID:SetTall(buttonSize)
	self.PlayerInfos.QuickActions.SteamID:DrawSide(true, true)
	self.PlayerInfos.QuickActions.SteamID.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_steamid"):format(ply:SteamID()), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end
	self.PlayerInfos.QuickActions.SteamID.DoClick = function(s)
		s:ButtonSound()
		SetClipboardText(ply:SteamID())
		BaseWars:Notify("#scoreboard_steamidCopied", NOTIFICATION_GENERIC, 5, ply:Name())
	end

	self.PlayerInfos.QuickActions.SteamID64 = self.PlayerInfos.QuickActions:Add("OLD.BaseWars.Button")
	self.PlayerInfos.QuickActions.SteamID64:Dock(TOP)
	self.PlayerInfos.QuickActions.SteamID64:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	self.PlayerInfos.QuickActions.SteamID64:SetTall(buttonSize)
	self.PlayerInfos.QuickActions.SteamID64:DrawSide(true, true)
	self.PlayerInfos.QuickActions.SteamID64.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_steamid64"):format(ply:SteamID64()), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end
	self.PlayerInfos.QuickActions.SteamID64.DoClick = function(s)
		s:ButtonSound()
		SetClipboardText(ply:SteamID64())
		BaseWars:Notify("#scoreboard_steamid64Copied", NOTIFICATION_GENERIC, 5, ply:Name())
	end

	self.PlayerInfos.QuickActions.Name = self.PlayerInfos.QuickActions:Add("OLD.BaseWars.Button")
	self.PlayerInfos.QuickActions.Name:Dock(TOP)
	self.PlayerInfos.QuickActions.Name:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	self.PlayerInfos.QuickActions.Name:SetTall(buttonSize)
	self.PlayerInfos.QuickActions.Name:DrawSide(true, true)
	self.PlayerInfos.QuickActions.Name.Draw = function(s,w,h)
		draw.SimpleText(ply:Name(), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end
	self.PlayerInfos.QuickActions.Name.DoClick = function(s)
		s:ButtonSound()
		SetClipboardText(ply:Name())
		BaseWars:Notify("#scoreboard_nameCopied", NOTIFICATION_GENERIC, 5, ply:Name())
	end

	self.PlayerInfos.QuickActions.Profile = self.PlayerInfos.QuickActions:Add("OLD.BaseWars.Button")
	self.PlayerInfos.QuickActions.Profile:Dock(TOP)
	self.PlayerInfos.QuickActions.Profile:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	self.PlayerInfos.QuickActions.Profile:SetTall(buttonSize)
	self.PlayerInfos.QuickActions.Profile:DrawSide(true, true)
	self.PlayerInfos.QuickActions.Profile.Draw = function(s,w,h)
		draw.SimpleText("Steam Profile", "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end
	self.PlayerInfos.QuickActions.Profile.DoClick = function(s)
		s:ButtonSound()
		gui.OpenURL("http://steamcommunity.com/profiles/" .. ply:SteamID64())
	end

	self.PlayerAction = self.Body:Add("DPanel")
	self.PlayerAction:Dock(FILL)
	self.PlayerAction:DockMargin(bigMargin, 0, bigMargin, bigMargin)
	self.PlayerAction.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("scoreboard_contentBackground"))
	end

	self.GoBack = self.Title:Add("OLD.BaseWars.Button")
	self.GoBack:Dock(LEFT)
	self.GoBack:DockMargin(bigMargin, bigMargin, 0, bigMargin)
	self.GoBack:SetWide(BaseWars.ScreenScale * 150)
	self.GoBack:DrawSide(true, true)
	self.GoBack.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("scoreboard_goBack"), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("scoreboard_text"), 1, 1)
	end
	self.GoBack.DoClick = function(s)
		s:ButtonSound()
		self:CreatePlayerList()
		s:Remove()
	end

	self.PlayerInfos.Think = function(s)
		if not IsValid(ply) then
			self:CreatePlayerList()
			self.GoBack:Remove()
		end
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.Scoreboard", PANEL, "DPanel")