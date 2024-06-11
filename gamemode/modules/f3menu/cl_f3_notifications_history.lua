local notifTall = BaseWars.ScreenScale * 40
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
	self.w, self.h = self:GetParent():GetSize()

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Scroll:PaintScrollBar("bwm")

	for _, notifData in ipairs(BaseWars:GetNotificationsHistory()) do
		local notif = self.Scroll:Add("DPanel")
		notif:Dock(TOP)
		notif:DockMargin(0, 0, margin, margin)
		notif:SetTall(notifTall)
		notif.Paint = function(s,w,h)
			BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, notifData.col1)
			BaseWars:DrawRoundedBoxEx(roundness, 0, 0, h, h, notifData.col2, true, false, true, false)
			BaseWars:DrawMaterial(notifData.icon, bigMargin, bigMargin, h * .5, h * .5, color_white)

			draw.SimpleText(notifData.text, "BaseWars.22", h + bigMargin, h * .5, color_white, 0, 1)
		end
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.NotificationsHistory", PANEL, "DPanel")