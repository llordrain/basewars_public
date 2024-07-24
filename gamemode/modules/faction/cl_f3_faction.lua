BaseWars:CreateFont("BaseWars.F3Faction.Separator", BaseWars.ScreenScale * 26, 5000)

local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.localPlayer = LocalPlayer()
	self.selectedPlayer = self.localPlayer
	self.selectedAction = 0
	self.allPlayers = {}

	self.PlayerList = self:Add("DScrollPanel")
	self.PlayerList:Dock(FILL)
	self.PlayerList:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.PlayerList:GetVBar():SetWide(0)

	self.SidePanel = self:Add("DPanel")
	self.SidePanel:Dock(RIGHT)
	self.SidePanel:DockMargin(0, bigMargin, bigMargin, bigMargin)
	self.SidePanel:SetWide(BaseWars.ScreenScale * 300)
	self.SidePanel.Paint = nil

	self.SidePanel.Player = self.SidePanel:Add("DPanel")
	self.SidePanel.Player:Dock(TOP)
	self.SidePanel.Player:SetTall(BaseWars.ScreenScale * 270)
	self.SidePanel.Player:InvalidateParent(true)
	self.SidePanel.Player.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
		draw.SimpleText(self.selectedPlayer:Name(), "BaseWars.22", w * .5, h - BaseWars.ScreenScale * 50, BaseWars:GetTheme("bwm_text"), 1, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.selectedPlayer:GetFaction(self.localPlayer), "BaseWars.20", w * .5, h - BaseWars.ScreenScale * 30, self.selectedPlayer:GetFactionColor(), 1, TEXT_ALIGN_BOTTOM)
	end

	self.SidePanel.Player.Avatar = self.SidePanel.Player:Add("AvatarMaterial")
	self.SidePanel.Player.Avatar:SetSize(BaseWars.ScreenScale * 150, BaseWars.ScreenScale * 150)
	self.SidePanel.Player.Avatar:SetPos((self.SidePanel.Player:GetWide() - self.SidePanel.Player.Avatar:GetWide()) * .5, bigMargin * 3)
	self.SidePanel.Player.Avatar:SetPlayer(self.selectedPlayer)

	self.SidePanel.Interfactions = self.SidePanel:Add("DPanel")
	self.SidePanel.Interfactions:Dock(FILL)
	self.SidePanel.Interfactions:DockMargin(0, bigMargin, 0, bigMargin)
	self.SidePanel.Interfactions.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end

	self.SidePanel.Interfactions.Scroll = self.SidePanel.Interfactions:Add("DScrollPanel")
	self.SidePanel.Interfactions.Scroll:Dock(FILL)
	self.SidePanel.Interfactions.Scroll:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.SidePanel.Interfactions.Scroll:GetVBar():SetWide(0)

	for k, v in ipairs(BaseWars:GetFactionInteraction()) do
		local interaction = self.SidePanel.Interfactions.Scroll:Add("OLD.BaseWars.Button")
		interaction:Dock(TOP)
		interaction:DockMargin(0, 0, 0, margin)
		interaction:SetTall(BaseWars.ScreenScale * 36)
		interaction:DrawSide(true, true)
		interaction.Draw = function(s,w,h)
			draw.SimpleText(self.localPlayer:GetLang(v.name), "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
		end
		interaction.DoClick = function(s)
			if k == self.selectedAction then return end
			if self.SidePanel.Action.resizing then return end

			s:ButtonSound()

			self.selectedAction = k
			self:ChangeInteraction(k)
		end
	end

	self.SidePanel.Action = self.SidePanel:Add("DPanel")
	self.SidePanel.Action:Dock(BOTTOM)
	self.SidePanel.Action:SetTall(0)
	self.SidePanel.Action:InvalidateParent(true)
	self.SidePanel.Action.resizing = false
	self.SidePanel.Action.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end
	self.SidePanel.Action.Think = function(s)
		s.selectedPlayer = self.selectedPlayer
	end

	-- self:ChangeInteraction(1, true)
end

function PANEL:ChangeInteraction(id, instant)
	local action = BaseWars:GetFactionInteraction()[id]
	if not action then return end
	if not IsValid(self.SidePanel.Action) then return end

	if self.SidePanel.Action:GetTall() == math.floor(action.size) then instant = true end

	if instant then
		self.SidePanel.Action:SetTall(action.size)

		for k, v in pairs(self.SidePanel.Action:GetChildren()) do
			if IsValid(v) then
				v:Remove()
			end
		end

		action.func(self.SidePanel.Action)
	else
		self.SidePanel.Action.resizing = true
		self.SidePanel.Action:SizeTo(self.SidePanel.Action:GetWide(), action.size, .2, 0, -1, function()
			self.SidePanel.Action.resizing = false

			for k, v in pairs(self.SidePanel.Action:GetChildren()) do
				if IsValid(v) then
					v:Remove()
				end
			end

			action.func(self.SidePanel.Action)
		end)
	end
end

function PANEL:Think()
	self.lerpFrac = FrameTime() * 15
	self.accentColor = BaseWars:GetTheme("gen_accent")

	if not IsValid(self.selectedPlayer) then
		self.selectedPlayer = self.localPlayer

		if IsValid(self.SidePanel.Player.Avatar) then
			self.SidePanel.Player.Avatar:SetPlayer(ply, 256)
		end
	end

	for _, ply in player.Iterator() do
		if not self.allPlayers[ply] then
			self.allPlayers[ply] = true
			self:AddPlayer(ply)
		end
	end
end

function PANEL:AddPlayer(ply)
	local playerPanel = self.PlayerList:Add("OLD.BaseWars.Button")
	playerPanel:Dock(TOP)
	playerPanel:DockMargin(0, 0, 0, margin)
	playerPanel:DrawSide(true, true)
	playerPanel.Draw = function(s,w,h)
		local textColor = BaseWars:GetTheme("bwm_text")

		draw.SimpleText(ply:Name(), "BaseWars.22", w * .25, h * .5, textColor, 1, 1)
		draw.SimpleText(ply:GetFaction(self.localPlayer), "BaseWars.22", w * .75, h * .5, ply:GetFactionColor(), 1, 1)
		draw.SimpleText("|", "BaseWars.F3Faction.Separator", w * .5, h * .44, textColor, 1, 1)
	end
	playerPanel.LerpFunc = function(s)
		return s:IsHovered() or self.selectedPlayer == ply
	end
	playerPanel.DoClick = function(s)
		if self.selectedPlayer == ply then return end

		s:ButtonSound()

		self.selectedPlayer = ply

		if IsValid(self.SidePanel.Player.Avatar) then
			self.SidePanel.Player.Avatar:SetPlayer(ply, 256)
		end
	end
	playerPanel.Tick = function(s)
		if not IsValid(ply) then
			s:Remove()
		end
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Faction", PANEL, "DPanel")