local PANEL = {}

function PANEL:Init()
	self.posLerp = 0
	self.colorLerp = nil
	self.backgroundColor = nil

	self:SetText("")
	self:SetFont("BaseWars.14")
	self:SetState(true, true)
end

function PANEL:SetState(bool, changeColor)
	self._state = bool

	if changeColor then
		self.colorLerp = bool and BaseWars:GetTheme("checkbox_on") or BaseWars:GetTheme("checkbox_off")
	end
end

function PANEL:GetState()
	return self._state
end

function PANEL:Toggle()
	surface.PlaySound("basewars/button.wav")
	self:SetState(not self:GetState())

	self:OnToggle(self:GetState())
end

function PANEL:OnToggle(state)
end

function PANEL:SetBackgroundColor(color)
	self.backgroundColor = color
end

function PANEL:Paint(w,h)
	local ply = LocalPlayer()
	local lerpFrac = FrameTime() * 15
	local state = self:GetState()

	self.posLerp = Lerp(lerpFrac, self.posLerp, state and w * .5 or 0)
	self.colorLerp = BaseWars:LerpColor(lerpFrac, self.colorLerp, state and BaseWars:GetTheme("checkbox_on") or BaseWars:GetTheme("checkbox_off"))

	BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.backgroundColor or BaseWars:GetTheme("checkbox"))

	draw.SimpleText(ply:GetLang("checkbox_" .. (state and "on" or "off")), self:GetFont(), state and w * .25 or w * .75, h * .5, BaseWars:GetTheme("checkbox_darkText"), 1, 1)

	BaseWars:DrawRoundedBox(4, self.posLerp, 0, w * .5, h, self.colorLerp)
end

vgui.Register("BaseWars.CheckBox", PANEL, "DButton")