local margin = BaseWars.ScreenScale * 5

local PANEL = {}

AccessorFunc(PANEL, "_roundness", "Roundness", FORCE_NUMBER)
AccessorFunc(PANEL, "_placeHolder", "PlaceHolder", FORCE_STRING)
AccessorFunc(PANEL, "_placeHolderColor", "PlaceHolderColor")
AccessorFunc(PANEL, "_backColor", "Color")

function PANEL:Init()
	self:SetRoundness(4)
	self:SetPlaceHolder("Place Holder")
	self:SetPlaceHolderColor(color_white)
	self:SetColor(Color(200, 100, 0))

	self.TextEntry = self:Add("DTextEntry")
	self.TextEntry:Dock(FILL)
	self.TextEntry:DockMargin(margin, 0, margin, 0)
	self.TextEntry:SetTextColor(Color(0, 0, 0, 0))
	self.TextEntry:SetDrawLanguageID(false)
	self.TextEntry.Paint = function(s, w, h)
		s:DrawTextEntryText(s:GetTextColor(), s:GetHighlightColor(), color_white)

		if (#s:GetText() == 0) then
			draw.SimpleText(self:GetPlaceHolder() or "", s:GetFont(), 2, h / 2, self:GetPlaceHolderColor(), 0, 1)
		end
	end
	self.TextEntry.OnChange = function(s)
		self:OnChange(s:GetText())
	end
	self.TextEntry.OnEnter = function(s)
		self:OnEnter()
	end

	self:SetFont("BaseWars.18")
end

function PANEL:RequestFocus()
	self.TextEntry:RequestFocus()
end

function PANEL:SetTextColor(color)
	self.TextEntry:SetTextColor(color)
end

function PANEL:GetTextColor()
	return self.TextEntry:GetTextColor()
end

function PANEL:SetMultiline(bool)
	self.TextEntry:SetMultiline(bool)
end

function PANEL:SetFont(font)
	self.TextEntry:SetFont(font)
end

function PANEL:GetText()
	return self.TextEntry:GetText()
end

function PANEL:SetNumeric(bool)
	self.TextEntry:SetNumeric(bool)
end

function PANEL:SetText(text)
	self.TextEntry:SetText(text)
end

function PANEL:OnMousePressed()
	self.TextEntry:RequestFocus()
end

function PANEL:OnChange(text)
end

function PANEL:OnEnter()
end

function PANEL:Paint(w, h)
	BaseWars:DrawRoundedBox(self:GetRoundness(), 0, 0, w, h, self:GetColor())
end

vgui.Register("BaseWars.TextEntry", PANEL)

--[[-------------------------------------------------------------------------
	MARK: NUMBERS ONLY
---------------------------------------------------------------------------]]

local PANEL = {}

AccessorFunc(PANEL, "_roundness", "Roundness", FORCE_NUMBER)
AccessorFunc(PANEL, "_placeHolder", "PlaceHolder", FORCE_STRING)
AccessorFunc(PANEL, "_placeHolderColor", "PlaceHolderColor")
AccessorFunc(PANEL, "_backColor", "Color")

function PANEL:Init()
	self:SetRoundness(4)
	self:SetPlaceHolder("Place Holder")
	self:SetPlaceHolderColor(color_white)
	self:SetColor(Color(200, 100, 0))

	self.TextEntry = self:Add("DTextEntry")
	self.TextEntry:Dock(FILL)
	self.TextEntry:DockMargin(margin, 0, margin, 0)
	self.TextEntry:SetTextColor(Color(0, 0, 0, 0))
	self.TextEntry:SetDrawLanguageID(false)
	self.TextEntry.Paint = function(s, w, h)
		s:DrawTextEntryText(s:GetTextColor(), s:GetHighlightColor(), color_white)

		if (#s:GetText() == 0) then
			draw.SimpleText(self:GetPlaceHolder() or "", s:GetFont(), 2, h / 2, self:GetPlaceHolderColor(), 0, 1)
		end
	end
	self.TextEntry.OnChange = function(s)
		self:OnChange(s:GetText())
	end
	self.TextEntry.OnEnter = function(s)
		self:OnEnter()
	end

	self:SetFont("BaseWars.18")
end

function PANEL:RequestFocus()
	self.TextEntry:RequestFocus()
end

function PANEL:SetTextColor(color)
	self.TextEntry:SetTextColor(color)
end

function PANEL:GetTextColor()
	return self.TextEntry:GetTextColor()
end

function PANEL:SetMultiline(bool)
	self.TextEntry:SetMultiline(bool)
end

function PANEL:SetFont(font)
	self.TextEntry:SetFont(font)
end

function PANEL:GetText()
	return self.TextEntry:GetText()
end

function PANEL:SetNumeric(bool)
	self.TextEntry:SetNumeric(bool)
end

function PANEL:SetText(text)
	self.TextEntry:SetText(text)
end

function PANEL:OnMousePressed()
	self.TextEntry:RequestFocus()
end

function PANEL:OnChange(text)
end

function PANEL:OnEnter()
end

function PANEL:Paint(w, h)
	BaseWars:DrawRoundedBox(self:GetRoundness(), 0, 0, w, h, self:GetColor())
end

vgui.Register("BaseWars.TextEntry.Numbers", PANEL)