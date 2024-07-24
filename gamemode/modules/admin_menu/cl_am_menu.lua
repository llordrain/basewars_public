local devMode = true
local black = Color(0, 0, 0, 230)
local closeIcon = Material("basewars_materials/close.png", "smooth")

local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local PANEL = {}
function PANEL:Init()
	self.tabs = {}

	for k, v in SortedPairsByMemberValue(BaseWars:GetAdminMenuTabs(), "order") do
		table.insert(self.tabs, v)
	end

	self.localPlayer = LocalPlayer()

	if self.localPlayer.AdminMenuSavedPanel and not self.tabs[self.localPlayer.AdminMenuSavedPanel] then
		self.localPlayer.AdminMenuSavedPanel = 1
	end

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)

	self.Frame = self:Add("DPanel")
	self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
	self.Frame:Center()
	self.Frame.Paint = nil

	self.Frame.Topbar = self.Frame:Add("DPanel")
	self.Frame.Topbar:Dock(TOP)
	self.Frame.Topbar:SetTall(BaseWars.ScreenScale * 40)
	self.Frame.Topbar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("am_titleBar"), true, true, false, false)
		draw.SimpleText("- Admin Menu -", "BaseWars.26", w * .5, h * .5, BaseWars:GetTheme("am_text"), 1, 1)
	end

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
		draw.SimpleText(self.localPlayer:Name(), "BaseWars.20", h, h * .5 + 1, BaseWars:GetTheme("am_text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(self.localPlayer:GetUserGroup(), "BaseWars.18", h, h * .5 - 1, BaseWars:GetTheme("am_darkText"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.Frame.Sidebar.Player = self.Frame.Sidebar.Player:Add("AvatarMaterial")
	self.Frame.Sidebar.Player:SetPos(bigMargin, bigMargin)
	self.Frame.Sidebar.Player:SetSize(BaseWars.ScreenScale * 50, BaseWars.ScreenScale * 50)
	self.Frame.Sidebar.Player:SetPlayer(self.localPlayer, 256)

	self.Frame.Sidebar.Scroll = self.Frame.Sidebar:Add("DScrollPanel")
	self.Frame.Sidebar.Scroll:GetVBar():SetWide(0)
	self.Frame.Sidebar.Scroll:Dock(FILL)

	self.Frame.Sidebar.Close = self.Frame.Sidebar:Add("OLD.BaseWars.Button")
	self.Frame.Sidebar.Close:Dock(BOTTOM)
	self.Frame.Sidebar.Close:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Frame.Sidebar.Close.Draw = function(s,w,h)
		local textColor = BaseWars:GetTheme("am_text")

		BaseWars:DrawMaterial(closeIcon, bigMargin * 1.5, bigMargin, h - bigMargin * 2, h - bigMargin * 2, textColor)
		draw.SimpleText(self.localPlayer:GetLang("close"), "BaseWars.20", h * 1.1, h * .5, textColor, 0, 1)
	end
	self.Frame.Sidebar.Close.DoClick = function(s)
		s:ButtonSound()
		BaseWars:CloseAdminMenu()
	end

	self.CurrentPanel = self.localPlayer.AdminMenuSavedPanel or 1
	for k, v in SortedPairsByMemberValue(self.tabs, "order") do
		if v.name == "Lua" and not BaseWars:IsSuperAdmin(self.localPlayer) then continue end

		local tabName = v.name[1] == "#" and self.localPlayer:GetLang(string.sub(v.name, 2)) or v.name

		local NavButton = self.Frame.Sidebar.Scroll:Add("OLD.BaseWars.Button")
		NavButton:Dock(TOP)
		NavButton:DockMargin(bigMargin, margin, bigMargin, 0)
		NavButton:SetAccentColor(v.color)
		NavButton.Draw = function(s,w,h)
			local textColor = BaseWars:GetTheme("am_text")

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

			self.localPlayer.AdminMenuSavedPanel = k
			self.CurrentPanel = k
			if v.panel then
				self:Build(v.panel, true)
			end
		end
	end

	self.Frame.Body = self.Frame:Add("DPanel")
	self.Frame.Body:Dock(FILL)
	self.Frame.Body:InvalidateParent(true)
	self.Frame.Body.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("am_background"), false, false, false, true)
	end

	if #self.tabs > 0 then
		self:Build(self.tabs[self.localPlayer.AdminMenuSavedPanel or 1].panel)
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

function PANEL:OnKeyCodePressed(key)
	if input.LookupKeyBinding(key) == "bw_adminmenu" then
		BaseWars:CloseAdminMenu()
	end
end

function PANEL:Paint(w,h)
	BaseWars:DrawRoundedBox(0, 0, 0, w, h, black)

	if LocalPlayer():GetBaseWarsConfig("bluredBackground") then
		BaseWars:DrawBlur(self, 4)
	end
end

function PANEL:Think()
	if not BaseWars:IsAdmin(self.localPlayer, true) then
		self:Remove()
	end
end

vgui.Register("BaseWars.AdminMenu", PANEL, "DFrame")

net.Receive("BaseWars:OpenAdminMenu", function()
	BaseWars:OpenAdminMenu()
end)