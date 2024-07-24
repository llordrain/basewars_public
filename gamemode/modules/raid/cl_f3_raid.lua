local buttonTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
	self.w, self.h = self:GetParent():GetSize()
	self.localPlayer = LocalPlayer()
	self.selectedPlayer = self.localPlayer
	self.colors = {
        text = BaseWars:GetTheme("bwm_text"),
        contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
        disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
    }

	self.TopBar = self:Add("DPanel")
    self.TopBar:Dock(TOP)
    self.TopBar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.TopBar:SetTall(buttonTall + bigMargin * 2)
    self.TopBar.Paint = function(s,w,h)
        local time = BaseWars:GetGlobalImmunity()

        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
        draw.SimpleText(Format(self.localPlayer:GetLang("raids_globalImmunity"), time > 0 and BaseWars:FormatTime2(time) or self.localPlayer:GetLang("none")), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(bigMargin, 0, bigMargin, bigMargin)
	self.Scroll:GetVBar():SetWide(0)

	for _, ply in player.Iterator() do
		if ply == self.localPlayer then continue end

		local playerPanel = self.Scroll:Add("OLD.BaseWars.Button")
		playerPanel:Dock(TOP)
		playerPanel:DockMargin(0, 0, 0, margin)
		playerPanel:DrawSide(true, true)
		playerPanel.Draw = function(s,w,h)
			draw.SimpleText(ply:Name(), "BaseWars.22", w * .25, h * .5, self.colors.text, 1, 1)
			draw.SimpleText(ply:GetFaction(self.localPlayer), "BaseWars.22", w * .75, h * .5, ply:GetFactionColor(), 1, 1)
			draw.SimpleText("|", "BaseWars.26", w * .5, h * .44, self.colors.text, 1, 1)
		end
		playerPanel.LerpFunc = function(s)
			return s:IsHovered() or self.selectedPlayer == ply
		end
		playerPanel.DoClick = function(s)
			if self.selectedPlayer == ply then
				return
			end

			s:ButtonSound()

			self.selectedPlayer = ply
		end
		playerPanel.Tick = function(s)
			if not IsValid(ply) then
				s:Remove()
			end
		end
	end

	self.BottomBar = self:Add("DPanel")
	self.BottomBar:Dock(BOTTOM)
	self.BottomBar:SetTall(buttonTall + bigMargin * 2)
	self.BottomBar:DockMargin(bigMargin, 0, bigMargin, bigMargin)
	self.BottomBar:InvalidateParent(true)
	self.BottomBar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)
	end

	local wide = (self.w - bigMargin * 4 - margin) * .5

	self.BottomBar.StartRaid = self.BottomBar:Add("BaseWars.Button2")
	self.BottomBar.StartRaid:Dock(LEFT)
	self.BottomBar.StartRaid:DockMargin(bigMargin, bigMargin, 0, bigMargin)
	self.BottomBar.StartRaid:SetWide(wide)
	self.BottomBar.StartRaid:SetColor(self.colors.contentBackground, true)
	self.BottomBar.StartRaid.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("raids_buttons", "start"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
	end
	self.BottomBar.StartRaid.DoClick = function(s)
		if not IsValid(self.selectedPlayer) then
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if BaseWars:RaidGoingOn() then
			BaseWars:Notify("#raids_raidAlreadyGoingOn", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if BaseWars:HasGlobalImmunity() then
			BaseWars:Notify("#raids_globalImmunity", NOTIFICATION_ERROR, 5, BaseWars:FormatTime2(BaseWars:GetGlobalImmunity(), self.localPlayer))
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if self.selectedPlayer == self.localPlayer then
			BaseWars:Notify("#raids_raidYourself", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if self.localPlayer:InFaction() and not self.selectedPlayer:InFaction() then
			BaseWars:Notify("#raids_raidSoloWhileInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if not self.localPlayer:InFaction() and self.selectedPlayer:InFaction() then
			BaseWars:Notify("#raids_raidFactionWhileSolo", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if self.localPlayer:InFaction() and self.localPlayer:HasSameFaction(self.selectedPlayer) then
			BaseWars:Notify("#raids_raidFactionMate", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		local immunityBool = self.selectedPlayer:HasRaidImmunity()
		if immunityBool then
			BaseWars:Notify("#raids_playerImmunity", NOTIFICATION_ERROR, 5, self.selectedPlayer:Name())
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, self.colors.green, s.Draw)

		net.Start("BaseWars:Raid:StartRaid")
			net.WriteEntity(self.selectedPlayer)
		net.SendToServer()
	end

	self.BottomBar.StopRaid = self.BottomBar:Add("BaseWars.Button2")
	self.BottomBar.StopRaid:Dock(RIGHT)
	self.BottomBar.StopRaid:DockMargin(0, bigMargin, bigMargin, bigMargin)
	self.BottomBar.StopRaid:SetWide(wide)
	self.BottomBar.StopRaid:SetColor(self.colors.contentBackground, true)
	self.BottomBar.StopRaid.Draw = function(s,w,h)
		draw.SimpleText(self.localPlayer:GetLang("raids_buttons", "stop"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
	end
	self.BottomBar.StopRaid.DoClick = function(s)
		if not BaseWars:RaidGoingOn() then
			BaseWars:Notify("#raids_stopRaidWhenNoRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if not self.localPlayer:InRaid() then
			BaseWars:Notify("#raids_stopRaidWhenNotInRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		local participants = BaseWars:GetRaidParticipant()
		if not participants.attacker.players[self.localPlayer] then
			BaseWars:Notify("#raids_stopRaidWhenNotAttacker", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, self.colors.disabled, s.Draw)

			return
		end

		if BaseWars:GetRaidType() == RAIDTYPE_FACTION then
			if BaseWars:GetFactionLeader(self.localPlayer:GetFaction()) != self.localPlayer then
				BaseWars:Notify("#raids_stopRaidWhenNotLeader", NOTIFICATION_ERROR, 5)
				s:Disable(1.5, self.colors.disabled, s.Draw)

				return
			end
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, self.colors.green, s.Draw)

		net.Start("BaseWars:Raid:StopRaid")
		net.SendToServer()
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Raid", PANEL, "DPanel")