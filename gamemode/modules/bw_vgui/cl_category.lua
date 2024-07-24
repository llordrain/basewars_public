local PANEL = {}

AccessorFunc(PANEL, "m_bSizeExpanded",	"Expanded", FORCE_BOOL)
AccessorFunc(PANEL, "m_fAnimTime",	"AnimTime")
AccessorFunc(PANEL, "m_iPadding",	"Padding")
AccessorFunc(PANEL, "m_name", "Name")
AccessorFunc(PANEL, "m_color", "Color")
AccessorFunc(PANEL, "m_textColor", "TextColor")

function PANEL:Init()
	self:SetName("Place Holder")
	self:SetExpanded(true)
	self:SetColor(Color(128, 0, 0))
	self:SetTextColor(color_white)

	self.Top = self:Add("DButton")
	self.Top:Dock(TOP)
	self.Top:SetTall(BaseWars:SS(36))
	self.Top:SetText("")
	self.Top.Paint = function(s, w, h)
		BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self:GetColor(), true, true, not self:GetExpanded(), not self:GetExpanded())

		draw.SimpleText(self:GetName(), "BaseWars.20", h * .25, h * .45, self:GetTextColor(), 0, 1)
	end
	self.Top.DoClick = function(s)
		self:Toggle()
	end

	self:SetAnimTime(.15)
	self.animSlide = Derma_Anim("Anim", self, self.AnimSlide)

	self:DockMargin(0, 0, BaseWars:SS(5), BaseWars:SS(10))
end

function PANEL:Think()
	self.animSlide:Run()
	self:Tick()
end

function PANEL:Tick()
end

function PANEL:Paint(w, h)
end

function PANEL:SetContents(pContents)
	self.Contents = pContents
	self.Contents:SetParent(self)
	self.Contents:Dock(FILL)

	if not self:GetExpanded() then
		self.OldHeight = self:GetTall()
	elseif self:GetExpanded() and IsValid(self.Contents) and self.Contents:GetTall() < 1 then
		self.Contents:SizeToChildren(false, true)
		self.OldHeight = self.Contents:GetTall()
		self:SetTall(self.OldHeight)
	end

	self:InvalidateLayout(true)
end

function PANEL:SetExpanded(expanded)
	self.m_bSizeExpanded = tobool(expanded)

	if not self:GetExpanded() then
		if not self.animSlide.Finished and self.OldHeight then return end
		self.OldHeight = self:GetTall()
	end
end

function PANEL:Toggle()
	self:SetExpanded(not self:GetExpanded())

	self.animSlide:Start(self:GetAnimTime(), {From = self:GetTall()})

	self:InvalidateLayout(true)
	self:GetParent():InvalidateLayout()
	self:GetParent():GetParent():InvalidateLayout()

	self:OnToggle(self:GetExpanded())
end

function PANEL:OnToggle(expanded)
end

function PANEL:PerformLayout()
	if IsValid(self.Contents) then
		if self:GetExpanded() then
			self.Contents:InvalidateLayout(true)
			self.Contents:SetVisible(true)
		else
			self.Contents:SetVisible(false)
		end
	end

	if self:GetExpanded() then
		if IsValid(self.Contents) and #self.Contents:GetChildren() > 0 then self.Contents:SizeToChildren(false, true) end
		self:SizeToChildren(false, true)
	else
		if IsValid(self.Contents) and not self.OldHeight then self.OldHeight = self.Contents:GetTall() end
		self:SetTall(self.Top:GetTall())
	end

	self.animSlide:Run()
end
function PANEL:AnimSlide(anim, delta, data)
	self:InvalidateLayout()
	self:InvalidateParent()

	if anim.Started then
		if not IsValid(self.Contents) and (self.OldHeight or 0) < self.Top:GetTall() then
			-- We are not using self.Contents and our designated height is less
			-- than the header size, something is clearly wrong, try to rectify
			self.OldHeight = 0
			for id, pnl in pairs(self:GetChildren()) do
				self.OldHeight = self.OldHeight + pnl:GetTall()
			end
		end

		if self:GetExpanded() then
			data.To = math.max(self.OldHeight, self:GetTall())
		else
			data.To = self:GetTall()
		end
	end

	if IsValid(self.Contents) then self.Contents:SetVisible(true) end

	self:SetTall(Lerp(delta, data.From, data.To))
end

vgui.Register("BaseWars.Category", PANEL, "Panel")