local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local PANEL = {}

AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetFont("BaseWars.20")

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Scroll:GetVBar():SetWide(0)

	self.choices = {}
end

function PANEL:Paint(w,h)
	BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("combobox_background"))
end

function PANEL:AddChoice(text, func)
	if not text or not func then return end

	local choice = self.Scroll:Add("OLD.BaseWars.Button")
	choice:Dock(TOP)
	choice:DockMargin(0, 0, 0, margin)
	choice:SetTall(buttonSize)
	choice:DrawSide(true, true)
	choice.Draw = function(s,w,h)
		draw.SimpleText(text, self:GetFont(), w * .5, h * .5, BaseWars:GetTheme("combobox_text"), 1, 1)
	end
	choice.DoClick = function(s)
		s:ButtonSound()

		func()

		self:Remove()
	end

	table.insert(self.choices, {
		text = text,
		func = func
	})

	self:InvalidateLayout()
end

function PANEL:OnFocusChanged(bool)
	if not IsValid(self) then return end
	if bool then return end

	self:Remove()
end

function PANEL:PerformLayout()
	local w = 0
	for k, v in pairs(self.choices) do
		local textW, _ = BaseWars:GetTextSize(v.text, self:GetFont())

		if textW > w then
			w = textW
		end
	end

	local allTall = #self.choices * buttonSize + bigMargin * 2 + (#self.choices - 1) * margin
	local realTall = math.min(allTall, 8 * buttonSize + bigMargin * 2 + 7 * margin)

	self:SetSize(math.max(w + bigMargin * 4, buttonSize * 5), realTall)
end

function PANEL:Think()
	local w, h = self:GetSize()
	local x, y = self:GetPos()
	x = math.Clamp(x, margin, ScrW() - w - margin)
	y = math.Clamp(y, margin, ScrH() - h - margin)

	self:SetPos(x, y)
end

vgui.Register("BaseWars.DropDownPopup", PANEL, "EditablePanel")

function BaseWars:DropdownPopup(x, y)
	local panel = vgui.Create("BaseWars.DropDownPopup")
	panel:SetDrawOnTop(true)
	panel:SetMouseInputEnabled(true)
	panel:SetPos(x, y)
	panel:MakePopup()

	return panel
end