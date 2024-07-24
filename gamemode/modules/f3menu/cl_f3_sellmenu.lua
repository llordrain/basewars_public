local buttonSize = BaseWars.ScreenScale * 36
local entityW, entityH = BaseWars.ScreenScale * 176, BaseWars.ScreenScale * 176
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.w, self.h = self:GetParent():GetSize()
	self.localPlayer = LocalPlayer()
	self.refreshing = false
	self.lastRefreshed = 0
	self.selectedAmount = 0
	self.selectedValue = 0
	self.totalAmount = 0
	self.totalValue = 0

	self.Topbar = self:Add("DPanel")
	self.Topbar:Dock(TOP)
	self.Topbar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Topbar:SetTall(BaseWars.ScreenScale * 40)
	self.Topbar.Paint = nil

	self.Topbar.All = self.Topbar:Add("DPanel")
	self.Topbar.All:Dock(LEFT)
	self.Topbar.All:SetWide((self.w - bigMargin * 3) * .5)
	self.Topbar.All.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
		draw.SimpleText(self.localPlayer:GetLang("sellmenu_allEntities"), "BaseWars.24", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	self.Topbar.Selected = self.Topbar:Add("DPanel")
	self.Topbar.Selected:Dock(RIGHT)
	self.Topbar.Selected:SetWide((self.w - bigMargin * 3) * .5)
	self.Topbar.Selected.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
		draw.SimpleText(self.localPlayer:GetLang("sellmenu_selectedEntities"), "BaseWars.24", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	self.ButtonsPanel = self:Add("DPanel")
	self.ButtonsPanel:Dock(BOTTOM)
	self.ButtonsPanel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.ButtonsPanel:SetTall(buttonSize + bigMargin * 2)
	self.ButtonsPanel.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end

	self.ButtonsPanel.All = self.ButtonsPanel:Add("OLD.BaseWars.Button")
	self.ButtonsPanel.All:Dock(LEFT)
	self.ButtonsPanel.All:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.ButtonsPanel.All:SetWide((self.w - bigMargin * 5) * .5)
	self.ButtonsPanel.All:DrawSide(true, true)
	self.ButtonsPanel.All.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("sellmenu_sellallfor"):format(BaseWars:FormatMoney(self.totalValue * BaseWars.Config.BackMoney)), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end
	self.ButtonsPanel.All.DoClick = function(s)
		local t = 0
		for _, v in ents.Iterator() do
			if not v:ValidToSell(LocalPlayer()) then continue end

			t = t + 1
		end

		if t <= 0 then
			return
		end

		s:ButtonSound()

		self.sellAllPopup = vgui.Create("BaseWars.Popup")
		self.sellAllPopup:SetTitle("#sellmenu_sellTitle")
		self.sellAllPopup:SetText("#sellmenu_sellallText", self.totalAmount, BaseWars:FormatMoney(self.totalValue * BaseWars.Config.BackMoney))
		self.sellAllPopup:SetConfirm(self.localPlayer:GetLang("sellmenu_sellButton"), function()
			net.Start("BaseWars:SellAll")
			net.SendToServer()
		end)
		self.sellAllPopup.Think = function(thinkSelf)
			if not IsValid(self) then
				thinkSelf:Remove()
			end
		end
	end

	self.ButtonsPanel.Selected = self.ButtonsPanel:Add("OLD.BaseWars.Button")
	self.ButtonsPanel.Selected:Dock(RIGHT)
	self.ButtonsPanel.Selected:DockMargin(0, bigMargin, bigMargin, bigMargin)
	self.ButtonsPanel.Selected:SetWide((self.w - bigMargin * 5) * .5)
	self.ButtonsPanel.Selected:DrawSide(true, true)
	self.ButtonsPanel.Selected.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("sellmenu_sellselectedfor"):format(BaseWars:FormatMoney(self.selectedValue * BaseWars.Config.BackMoney)), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end
	self.ButtonsPanel.Selected.DoClick = function(s)
		if not IsValid(self.SelectedEntities.Layout) then return end

		local t = {}
		for _, v in pairs(self.SelectedEntities.Layout:GetChildren()) do
			local entity = v.entity

			if not IsValid(entity) then continue end

			table.insert(t, entity)
		end

		if #t <= 0 then
			return
		end

		s:ButtonSound()

		net.Start("BaseWars:SellEntities")
			net.WriteTable(t)
		net.SendToServer()
	end

	self.AllEntities = self:Add("DScrollPanel")
	self.AllEntities:Dock(LEFT)
	self.AllEntities:SetWide((self.w - bigMargin * 3) * .5)
	self.AllEntities:DockMargin(bigMargin, 0, bigMargin, 0)
	self.AllEntities:PaintScrollBar("bwm")

	self.AllEntities.Layout = self.AllEntities:Add("DIconLayout")
	self.AllEntities.Layout:Dock(TOP)
	self.AllEntities.Layout:SetTall(self.h)
	self.AllEntities.Layout:SetSpaceX(margin)
	self.AllEntities.Layout:SetSpaceY(margin)

	self.SelectedEntities = self:Add("DScrollPanel")
	self.SelectedEntities:Dock(RIGHT)
	self.SelectedEntities:SetWide((self.w - bigMargin * 3) * .5)
	self.SelectedEntities:DockMargin(bigMargin, 0, bigMargin, 0)
	self.SelectedEntities:PaintScrollBar("bwm")

	self.SelectedEntities.Layout = self.SelectedEntities:Add("DIconLayout")
	self.SelectedEntities.Layout:Dock(TOP)
	self.SelectedEntities.Layout:SetTall(self.h)
	self.SelectedEntities.Layout:SetSpaceX(margin)
	self.SelectedEntities.Layout:SetSpaceY(margin)

	for _, v in ents.Iterator() do
		if not v:ValidToSell(self.localPlayer) then continue end

		self:RemoveEntity(v, true)

		self.totalAmount = self.totalAmount + 1
		self.totalValue = self.totalValue + v:GetCurrentValue()
	end
end

function PANEL:AddEntity(entity)
	local entityPanel = self.SelectedEntities.Layout:Add("DButton")
	entityPanel.entity = entity
	entityPanel:SetText("")
	entityPanel:SetSize(entityW, entityH)
	entityPanel.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end
	entityPanel.Think = function(s)
		if not IsValid(s.entity) then
			s:Remove()
			self:Refresh()
		end
	end
	entityPanel.DoClick = function(s)
		surface.PlaySound("bw_button.wav")
		self:RemoveEntity(entity)
		s:Remove()
	end

	entityPanel.Model = entityPanel:Add("DModelPanel")
	entityPanel.Model:SetMouseInputEnabled(false)
	entityPanel.Model.LayoutEntity = function() end
	entityPanel.Model:Dock(FILL)
	entityPanel.Model:SetModel(entity:GetModel() or "error.mdl")
	if IsValid(entityPanel.Model.Entity) then
		local mn, mx = entityPanel.Model.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		entityPanel.Model:SetFOV(60)
		entityPanel.Model:SetCamPos(Vector(size, size, size))
		entityPanel.Model:SetLookAt((mn + mx) * 0.5)
	end

	entityPanel.EntityName = entityPanel:Add("DPanel")
	entityPanel.EntityName:SetMouseInputEnabled(false)
	entityPanel.EntityName:SetTall(BaseWars.ScreenScale * 30)
	entityPanel.EntityName:SetText("")
	entityPanel.EntityName:Dock(BOTTOM)
	entityPanel.EntityName.Paint = function(s,w,h)
		local name = BaseWars:GetValidName(entity)

		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground2"), false, false, true, true)
		draw.SimpleText(name, "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	self:OnAddEntity(entity)
end

function PANEL:RemoveEntity(entity, ignoreCouting)
	local entityPanel = self.AllEntities.Layout:Add("DButton")
	entityPanel.entity = entity
	entityPanel:SetText("")
	entityPanel:SetSize(entityW, entityH)
	entityPanel.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end
	entityPanel.Think = function(s)
		if not IsValid(s.entity) then
			s:Remove()
			self:Refresh()
		end
	end
	entityPanel.DoClick = function(s)
		surface.PlaySound("bw_button.wav")
		self:AddEntity(entity)
		s:Remove()
	end

	entityPanel.Model = entityPanel:Add("DModelPanel")
	entityPanel.Model:SetMouseInputEnabled(false)
	entityPanel.Model.LayoutEntity = function() end
	entityPanel.Model:Dock(FILL)
	entityPanel.Model:SetModel(entity:GetModel() or "error.mdl")
	if IsValid(entityPanel.Model.Entity) then
		local mn, mx = entityPanel.Model.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		entityPanel.Model:SetFOV(60)
		entityPanel.Model:SetCamPos(Vector(size, size, size))
		entityPanel.Model:SetLookAt((mn + mx) * 0.5)
	end

	entityPanel.EntityName = entityPanel:Add("DPanel")
	entityPanel.EntityName:SetMouseInputEnabled(false)
	entityPanel.EntityName:SetTall(BaseWars.ScreenScale * 30)
	entityPanel.EntityName:SetText("")
	entityPanel.EntityName:Dock(BOTTOM)
	entityPanel.EntityName.Paint = function(s,w,h)
		local name = BaseWars:GetValidName(entity)

		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground2"), false, false, true, true)
		draw.SimpleText(name, "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	if not ignoreCouting then
		self:OnRemoveEntity(entity)
	end
end

function PANEL:OnRemoveEntity(entity)
	self.selectedAmount = self.selectedAmount - 1
	self.selectedValue = self.selectedValue - entity:GetCurrentValue()
end

function PANEL:OnAddEntity(entity)
	self.selectedAmount = self.selectedAmount + 1
	self.selectedValue = self.selectedValue + entity:GetCurrentValue()
end

function PANEL:Think()
	if self.refreshing and self.lastRefreshed + .2 <= CurTime() then
		self.lastRefreshed = CurTime()
	end
end

function PANEL:Refresh()
	if self.refreshing then return end
	self.refreshing = true

	self.selectedAmount = 0
	self.selectedValue = 0
	self.totalAmount = 0
	self.totalValue = 0

	for k, v in ents.Iterator() do
		if not v:ValidToSell(LocalPlayer()) then continue end

		self.totalAmount = self.totalAmount + 1
		self.totalValue = self.totalValue + v:GetCurrentValue()
	end

	for k, v in pairs(self.SelectedEntities.Layout:GetChildren()) do
		local entity = v.entity

		if not IsValid(entity) then continue end

		self.selectedAmount = self.selectedAmount + 1
		self.selectedValue = self.selectedValue + entity:GetCurrentValue()
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.SellMenu", PANEL, "DPanel")