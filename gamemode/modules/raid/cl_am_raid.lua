local buttonTall, buttonWide = BaseWars.ScreenScale * 36, BaseWars.ScreenScale * 150
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.localPlayer =LocalPlayer()
    self.colors = {
        text = GetBaseWarsTheme("am_text"),
        contentBackground = GetBaseWarsTheme("am_contentBackground"),
		disabled = GetBaseWarsTheme("button_disabled"),
        green = GetBaseWarsTheme("button_green")
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

    self.TopBar.Reset = self.TopBar:Add("BaseWars.Button")
    self.TopBar.Reset:Dock(RIGHT)
    self.TopBar.Reset:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.TopBar.Reset:SetWide(buttonWide)
    self.TopBar.Reset:SetColor(self.colors.contentBackground, true)
    self.TopBar.Reset.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("reset"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.TopBar.Reset.DoClick = function(s)
        if BaseWars:GetGlobalImmunity() <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:ButtonSound()
        s:CustomTempDraw(1.5, self.colors.green, s.Draw)

        net.Start("BaseWars:Raid:ResetGlobalImmunity")
        net.SendToServer()
    end

    self.Scroll = self:Add("DScrollPanel")
    self.Scroll:Dock(FILL)
    self.Scroll:DockMargin(bigMargin, 0, bigMargin, bigMargin)
    self.Scroll:GetVBar():SetWide(0)

    for _, ply in player.Iterator() do
        local playerPanel = self.Scroll:Add("DPanel")
        playerPanel:Dock(TOP)
        playerPanel:DockMargin(0, 0, 0, margin)
        playerPanel:SetTall(buttonTall + bigMargin * 2)
        playerPanel.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

            local time = ply:GetRaidImmunity()

            draw.SimpleText(Format(self.localPlayer:GetLang("raids_playerImmunityAdmin"), ply:Name(), time > 0 and BaseWars:FormatTime2(time) or self.localPlayer:GetLang("none")), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
        end

        playerPanel.Reset = playerPanel:Add("BaseWars.Button")
        playerPanel.Reset:Dock(RIGHT)
        playerPanel.Reset:DockMargin(0, bigMargin, bigMargin, bigMargin)
        playerPanel.Reset:SetWide(buttonWide)
        playerPanel.Reset:SetColor(self.colors.contentBackground, true)
        playerPanel.Reset.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("reset"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
        end
        playerPanel.Reset.DoClick = function(s)
            if ply:GetRaidImmunity() <= 0 then
                s:Disable(1.5, self.colors.disabled, s.Draw)

                return
            end

            s:ButtonSound()
            s:CustomTempDraw(1.5, self.colors.green, s.Draw)

            net.Start("BaseWars:Raid:ResetPlayerImmunity")
                net.WriteString(ply:SteamID64())
            net.SendToServer()
        end
    end
end

function PANEL:Paint()
end

vgui.Register("BaseWars.AdminMenu.Raids", PANEL, "DPanel")