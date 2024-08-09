local buyIcon = Material("basewars_materials/notification/purchase.png", "smooth")

local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.w, self.h = self:GetParent():GetSize()
	local ply = LocalPlayer()

	self.SidePanel = self:Add("DPanel")
	self.SidePanel:Dock(RIGHT)
	self.SidePanel:DockMargin(0, bigMargin, bigMargin, bigMargin)
	self.SidePanel:SetWide(BaseWars.ScreenScale * 300)
	self.SidePanel.Paint = nil

	self.SidePanel.Infos = self.SidePanel:Add("DPanel")
	self.SidePanel.Infos:Dock(TOP)
	self.SidePanel.Infos:SetTall(BaseWars.ScreenScale * 300)
	self.SidePanel.Infos:InvalidateParent(true)
	self.SidePanel.Infos.plyLevel = 0
	self.SidePanel.Infos.Paint = function(s,w,h)
		local percent = 0
		local levelForPrestige = BaseWars.Config.Prestige.BaseLevel + (ply:GetPrestige() * BaseWars.Config.Prestige.MoreLevel)

		s.plyLevel = Lerp(FrameTime() * 15, s.plyLevel, ply:GetLevel())
		percent = s.plyLevel / levelForPrestige

		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))

		local x, y = w * .5, w * .5
		BaseWars:DrawCircle(x, y, w * .35, 360, 0, 360, BaseWars:GetTheme("bwm_contentBackground2"))
		BaseWars:DrawCircle(x, y, w * .35, 360, 0, 360 * math.Clamp(percent, 0, 1), BaseWars:GetTheme("gen_accent"))
		BaseWars:DrawCircle(x, y, w * .32, 360, 0, 360, BaseWars:GetTheme("bwm_contentBackground"))

		draw.SimpleText(string.Comma(math.Round(percent * 100, 2)) .. "%", "BaseWars.30", w * .5, y, BaseWars:GetTheme("bwm_text"), 1, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(BaseWars:FormatNumber(s.plyLevel, true) .. "/" .. BaseWars:FormatNumber(levelForPrestige, true), "BaseWars.20", w * .5, y, BaseWars:GetTheme("bwm_darkText"), 1, TEXT_ALIGN_TOP)
	end

	self.SidePanel.DoPrestige = self.SidePanel:Add("DPanel")
	self.SidePanel.DoPrestige:Dock(BOTTOM)
	self.SidePanel.DoPrestige:SetTall(buttonSize + bigMargin * 2)
	self.SidePanel.DoPrestige.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end

	self.SidePanel.DoPrestige.Button = self.SidePanel.DoPrestige:Add("OLD.BaseWars.Button")
	self.SidePanel.DoPrestige.Button:Dock(FILL)
	self.SidePanel.DoPrestige.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.SidePanel.DoPrestige.Button:DrawSide(true, true)
	self.SidePanel.DoPrestige.Button.Draw = function(s,w,h)
		draw.SimpleText(ply:GetLang("prestige_doPrestige"):format(BaseWars:FormatNumber(ply:GetPrestige() + 1)), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end
	self.SidePanel.DoPrestige.Button.DoClick = function(s)
		if not ply:CanPrestige() then return end
		s:ButtonSound()

		net.Start("BaseWars:Prestige")
		net.SendToServer()
	end

	self.SidePanel.ResetPrestigePoint = self.SidePanel:Add("Panel")
	self.SidePanel.ResetPrestigePoint:Dock(BOTTOM)
	self.SidePanel.ResetPrestigePoint:DockMargin(0, 0, 0, bigMargin)
	self.SidePanel.ResetPrestigePoint:SetTall(buttonSize + bigMargin * 2)
	self.SidePanel.ResetPrestigePoint.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
	end

	self.SidePanel.ResetPrestigePoint.Button = self.SidePanel.ResetPrestigePoint:Add("OLD.BaseWars.Button")
	self.SidePanel.ResetPrestigePoint.Button:Dock(FILL)
	self.SidePanel.ResetPrestigePoint.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.SidePanel.ResetPrestigePoint.Button:DrawSide(true, true)
	self.SidePanel.ResetPrestigePoint.Button.Draw = function(s,w,h)
		draw.SimpleText(ply:GetLang("prestige_resetPoint"):format(BaseWars:FormatMoney(BaseWars.Config.Prestige.ResetPrice * ply:GetPrestigePointSpent(), true)), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end
	self.SidePanel.ResetPrestigePoint.Button.DoClick = function(s)
		if ply:GetPrestigePointSpent() <= 0 then return end

		s:ButtonSound()

		net.Start("BaseWars:Prestige.ResetPoint")
		net.SendToServer()
	end

	self.SidePanel.PrestigePoint = self.SidePanel:Add("DPanel")
	self.SidePanel.PrestigePoint:Dock(BOTTOM)
	self.SidePanel.PrestigePoint:DockMargin(0, 0, 0, bigMargin)
	self.SidePanel.PrestigePoint:SetTall(BaseWars.ScreenScale * 40)
	self.SidePanel.PrestigePoint.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))
		draw.SimpleText(ply:GetLang("prestige_prestigePoint"):format(BaseWars:FormatNumber(ply:GetPrestigePoint())), "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("bwm_text"), 1, 1)
	end

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Scroll:PaintScrollBar("bwm")

	for k, v in SortedPairsByMemberValue(BaseWars:GetPrestigePerk(), "cost") do
		local perk = self.Scroll:Add("DPanel")
		perk:Dock(TOP)
		perk:DockMargin(0, 0, margin, margin)
		perk:SetTall(BaseWars.ScreenScale * 56)
		perk.Paint = function(s,w,h)
			BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))

			draw.SimpleText(ply:GetLang("prestige_perks", k .. "Name"), "BaseWars.22", bigMargin, h * .5, BaseWars:GetTheme("bwm_text"), 0, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(ply:GetLang("prestige_perks", k .. "Desc"), "BaseWars.18", bigMargin, h * .5, BaseWars:GetTheme("bwm_darkText"), 0, TEXT_ALIGN_TOP)

			draw.SimpleText(ply:GetLang("prestige_price"), "BaseWars.18", w - BaseWars.ScreenScale * 90, h * .5, BaseWars:GetTheme("bwm_text"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(v.cost, "BaseWars.18", w - BaseWars.ScreenScale * 85, h * .5, BaseWars:GetTheme("bwm_darkText"), 0, TEXT_ALIGN_BOTTOM)

			draw.SimpleText(ply:GetLang("prestige_level"), "BaseWars.18", w - BaseWars.ScreenScale * 90, h * .5, BaseWars:GetTheme("bwm_text"), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText(ply:GetPrestigePerk(k) .. "/" .. v.max, "BaseWars.18", w - BaseWars.ScreenScale * 85, h * .5, BaseWars:GetTheme("bwm_darkText"), 0, TEXT_ALIGN_TOP)
		end

		perk.Buy = perk:Add("DButton")
		perk.Buy:SetText("")
		perk.Buy:Dock(RIGHT)
		perk.Buy:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
		perk.Buy:SetWide(perk:GetTall())
		perk.Buy.color = BaseWars:GetTheme("bwm_darkText")
		perk.Buy.Paint = function(s,w,h)
			s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and BaseWars:GetTheme("gen_accent") or BaseWars:GetTheme("bwm_darkText"))

			BaseWars:DrawMaterial(buyIcon, w - h * .5, h * .5, h * .7, h * .7, s.color, 0)
		end
		perk.Buy.DoClick = function(s)
			local text
			if ply:GetPrestigePerk(k) >= v.max then
				text = ply:GetLang("prestige_maxPerk")
			elseif v.cost > ply:GetPrestigePoint() then
				text = ply:GetLang("prestige_notEnoughPoint"):format(v.cost)
			end

			if text then
				BaseWars:Notify(text, NOTIFICATION_ERROR, 5)
				return
			end

			surface.PlaySound("basewars/button.wav")

			net.Start("BaseWars:Prestige.BuyPerk")
				net.WriteString(k)
			net.SendToServer()
		end
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Prestige", PANEL, "DPanel")