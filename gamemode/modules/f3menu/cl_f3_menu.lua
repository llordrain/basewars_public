local devMode = false
local closeIcon = Material("basewars_materials/close.png", "smooth")

local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.tabs = BaseWars:GetBaseWarsMenuTabs()
	local ply = LocalPlayer()

	if ply.F3SavedPanel and not self.tabs[ply.F3SavedPanel] then
		ply.F3SavedPanel = 1
	end

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)

	--[[-------------------------------------------------------------------
		FRAME
	---------------------------------------------------------------------]]

	self.Frame = self:Add("DPanel")
	self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
	self.Frame:Center()
	self.Frame.Paint = nil

	self.Frame.Topbar = self.Frame:Add("DPanel")
	self.Frame.Topbar:Dock(TOP)
	self.Frame.Topbar:SetTall(BaseWars.ScreenScale * 40)
	self.Frame.Topbar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("bwm_titleBar"), true, true, false, false)
		draw.SimpleText("- BaseWars Menu -", "BaseWars.26", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	--[[-------------------------------------------------------------------
		NAVIGATION
	---------------------------------------------------------------------]]

	self.Frame.Sidebar = self.Frame:Add("DPanel")
	self.Frame.Sidebar:Dock(LEFT)
	self.Frame.Sidebar:SetWide(BaseWars.ScreenScale * 220)
	self.Frame.Sidebar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("bwm_background"), false, false, true, false)
	end

	self.Frame.Sidebar.Player = self.Frame.Sidebar:Add("DPanel")
	self.Frame.Sidebar.Player:Dock(TOP)
	self.Frame.Sidebar.Player:SetTall(BaseWars.ScreenScale * 70)
	self.Frame.Sidebar.Player.Paint = function(s,w,h)
		local plyName = ply:Name()
		local plyFaction = ply:GetFaction()
		local plyFactionColor = ply:GetFactionColor()

		draw.SimpleText(plyName, "BaseWars.20", h, h * .5 + 1, BaseWars:GetTheme("bwm_text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(plyFaction, "BaseWars.18", h, h * .5 - 1, plyFactionColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.Frame.Sidebar.Player = self.Frame.Sidebar.Player:Add("AvatarMaterial")
	self.Frame.Sidebar.Player:SetPos(bigMargin, bigMargin)
	self.Frame.Sidebar.Player:SetSize(BaseWars.ScreenScale * 50, BaseWars.ScreenScale * 50)
	self.Frame.Sidebar.Player:SetPlayer(ply)

	self.Frame.Sidebar.Scroll = self.Frame.Sidebar:Add("DScrollPanel")
	self.Frame.Sidebar.Scroll:GetVBar():SetWide(0)
	self.Frame.Sidebar.Scroll:Dock(FILL)

	self.Frame.Sidebar.Close = self.Frame.Sidebar:Add("OLD.BaseWars.Button")
	self.Frame.Sidebar.Close:Dock(BOTTOM)
	self.Frame.Sidebar.Close:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Frame.Sidebar.Close.Draw = function(s,w,h)
		local textColor = BaseWars:GetTheme("bwm_text")

		BaseWars:DrawMaterial(closeIcon, bigMargin * 1.5, bigMargin, h - bigMargin * 2, h - bigMargin * 2, textColor)
		draw.SimpleText(ply:GetLang("close"), "BaseWars.20", h * 1.1, h * .5, textColor, 0, 1)
	end
	self.Frame.Sidebar.Close.DoClick = function(s)
		s:ButtonSound()
		BaseWars:CloseF3Menu()
	end

	self.CurrentPanel = ply.F3SavedPanel or 1
	for k, v in SortedPairsByMemberValue(self.tabs, "order") do
		local tabName = v.name[1] == "#" and ply:GetLang(string.sub(v.name, 2)) or v.name

		local NavButton = self.Frame.Sidebar.Scroll:Add("OLD.BaseWars.Button")
		NavButton:Dock(TOP)
		NavButton:DockMargin(bigMargin, margin, bigMargin, 0)
		NavButton.Draw = function(s,w,h)
			local textColor = BaseWars:GetTheme("bwm_text")

			BaseWars:DrawMaterial(v.icon, bigMargin * 1.5, bigMargin, h - bigMargin * 2, h - bigMargin * 2, textColor)
			draw.SimpleText(tabName, "BaseWars.20", h * 1.1, h * .5, textColor, 0, 1)
		end
		NavButton.LerpFunc = function(s)
			return s:IsHovered() or self.CurrentPanel == k
		end
		NavButton.DoClick = function(s)
			if self.CurrentPanel == k and not devMode then return end
			if IsValid(self.Frame.Body.OldContentPanel) then return end

			s:ButtonSound()

			ply.F3SavedPanel = k
			self.CurrentPanel = k
			if v.panel then
				self:Build(v.panel, true)
			end
		end
		NavButton.Tick = function(s)
			if v.name == "bwm_faction" then
				s:SetAccentColor(ply:GetFactionColor())
			end

			if v.name == "bwm_prestige" and not BaseWars.Config.Prestige.Enable then
				s:Remove()
			end
		end
	end

	--[[-------------------------------------------------------------------
		BODY
	---------------------------------------------------------------------]]

	self.Frame.Body = self.Frame:Add("DPanel")
	self.Frame.Body:Dock(FILL)
	self.Frame.Body:InvalidateParent(true)
	self.Frame.Body.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("bwm_background"), false, false, false, true)
	end

	if #self.tabs > 0 then
		self:Build(self.tabs[ply.F3SavedPanel or 1].panel)
	end

	BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:OnKeyCodePressed(key)
	if input.LookupKeyBinding(key) == "gm_showspare1" then
		BaseWars:CloseF3Menu()
	end
end

function PANEL:Build(panelName, replacePanel)
	if not IsValid(self.Frame.Body) then return end
	if not panelName then return end

	local transisionDuration = devMode and 0 or .25

	if replacePanel then
		self.Frame.Body.OldContentPanel = self.Frame.Body.ContentPanel
		self.Frame.Body.OldContentPanel:AlphaTo(0, transisionDuration, 0, function()
			if IsValid(self.Frame.Body.OldContentPanel) then
				self.Frame.Body.OldContentPanel:Remove()
			end
		end)
	end

	self.Frame.Body.ContentPanel = self.Frame.Body:Add(panelName)
	self.Frame.Body.ContentPanel:SetAlpha(0)
	self.Frame.Body.ContentPanel:AlphaTo(255, transisionDuration, 0, function() end)
	self.Frame.Body.ContentPanel:Dock(FILL)
end

function PANEL:Think()
	self.accentColor = BaseWars:GetTheme("gen_accent")
end

function PANEL:Paint(w, h)
end

vgui.Register("BaseWars.F3Menu", PANEL, "DFrame")