local loading = Material("basewars_materials/loading.png", "smooth")
local arrow = Material("basewars_materials/arrow.png", "smooth")
local loadingSize = BaseWars.ScreenScale * 150
local arrowSize = BaseWars.ScreenScale * 16
local leaderboardData
local thisPanel
local leftDisplay, rightDisplay = "time_played", "money"

local options = {
    "time_played",
    "money",
    "prestige",
    "level",
    "kills",
    "deaths",
    "message_sent",
    "money_received",
    "xp_received",
    "session_count",
    "kd"
}

local elementTall = BaseWars.ScreenScale * 40
local rowTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin =  BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.w, self.h = self:GetParent():GetSize()
    self.localPlayer = LocalPlayer()
    self.rowWide = (self.w - bigMargin * 3 - margin * 2 - rowTall * 2) * .5
    self.colors = {
        text = BaseWars:GetTheme("bwm_text"),
        darkText = BaseWars:GetTheme("bwm_darkText"),
        top1 = BaseWars:GetTheme("leaderboard_top1"),
        top2 = BaseWars:GetTheme("leaderboard_top2"),
        top3 = BaseWars:GetTheme("leaderboard_top3"),
        accent = BaseWars:GetTheme("gen_accent"),
        contentBackground = BaseWars:GetTheme("bwm_contentBackground")
    }

    thisPanel = self

    -- MARK: Left
    self.LeftPanel = self:Add("DPanel")
    self.LeftPanel:Dock(LEFT)
    self.LeftPanel:DockMargin(bigMargin, bigMargin, 0, bigMargin)
    self.LeftPanel:SetWide((self.w - bigMargin * 3) * .5)
    self.LeftPanel.Paint = function(s,w,h)
        if not leaderboardData then
            BaseWars:DrawMaterial(loading, w * .5, h * .5, loadingSize, loadingSize, self.colors.accent, self.loadingAngle)
        end
    end

    self.LeftPanel.Scroll = self.LeftPanel:Add("DScrollPanel")
    self.LeftPanel.Scroll:Dock(FILL)
    self.LeftPanel.Scroll:GetVBar():SetWide(0)
    self.LeftPanel.Scroll.Paint = self.LeftPanel.Paint

    -- MARK: Right
    self.RightPanel = self:Add("DPanel")
    self.RightPanel:Dock(RIGHT)
    self.RightPanel:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.RightPanel:SetWide((self.w - bigMargin * 3) * .5)
    self.RightPanel.Paint = function(s,w,h)
        if not leaderboardData then
            BaseWars:DrawMaterial(loading, w * .5, h * .5, loadingSize, loadingSize, self.colors.accent, self.loadingAngle)
        end
    end

    self.RightPanel.Scroll = self.RightPanel:Add("DScrollPanel")
    self.RightPanel.Scroll:Dock(FILL)
    self.RightPanel.Scroll:GetVBar():SetWide(0)

    if leaderboardData then
        self:Build()
    else
        net.Start("BaseWars:Leaderboard:SendToClients")
        net.SendToServer()
    end
end

function PANEL:GetValue(what, data)
    if what == "time_played" then
        return BaseWars:FormatTime2(data.time_played, self.localPlayer)
    end

    if what == "money" then
        return BaseWars:FormatMoney(data.money)
    end

    if what == "prestige" then
        return BaseWars:FormatNumber(data.prestige)
    end

    if what == "level" then
        return string.Comma(data.level)
    end

    if what == "kills" then
        return string.Comma(data.kills)
    end

    if what == "deaths" then
        return string.Comma(data.deaths)
    end

    if what == "message_sent" then
        return string.Comma(data.message_sent)
    end

    if what == "money_received" then
        return BaseWars:FormatMoney(data.money_number)
    end

    if what == "xp_received" then
        return BaseWars:FormatNumber(data.xp_number)
    end

    if what == "session_count" then
        return string.Comma(data.play_count)
    end

    if what == "kd" then
        return data.kd
    end

    return "nuh huh"
end

function PANEL:BuildLeft(what)
    leftDisplay = what
    self.LeftPanel.Scroll:GetCanvas():Clear()

    if not self.LeftPanel.Topbar then
        self.LeftPanel.Topbar = self.LeftPanel:Add("DButton")
        self.LeftPanel.Topbar:SetText("")
        self.LeftPanel.Topbar:Dock(TOP)
        self.LeftPanel.Topbar:DockMargin(0, 0, 0, bigMargin)
        self.LeftPanel.Topbar:SetTall(elementTall)
        self.LeftPanel.Topbar.Paint = function(s,w,h)
            s.angle = Lerp(FrameTime() * 20, s.angle or -90, (IsValid(self.dropDown) and self.dropDown.side == "left") and 0 or -90)

            BaseWars:DrawRoundedBox(roundness, 0, 0, w, elementTall, self.colors.contentBackground)
            BaseWars:DrawMaterial(arrow, w - h * .5, h * .5, arrowSize, arrowSize, self.colors.text, s.angle)

            draw.SimpleText(self.localPlayer:GetLang("leaderboard_title", leftDisplay), "BaseWars.24", w * .5, h * .5, self.colors.text, 1, 1)
        end
        self.LeftPanel.Topbar.DoClick = function(s)
            surface.PlaySound("basewars/button.wav")

            local _, y = s:LocalToScreen()
            local _, h = s:GetSize()
            local mouseX = gui.MouseX()

            self.dropDown = BaseWars:DropdownPopup(mouseX, y + h + margin)
            self.dropDown.side = "left"
            for k, id in ipairs(options) do
                if leftDisplay == id or rightDisplay == id then continue end

                self.dropDown:AddChoice(self.localPlayer:GetLang("leaderboard_title", id), function()
                    if IsValid(self) then
                        self:BuildLeft(id)
                    end
                end)
            end
        end
    end

    for k, v in ipairs(leaderboardData[what]) do
        BaseWars:RequestSteamName(v.player_id64)

        local color = k <= 3 and self.colors["top" .. k] or self.colors.darkText

        local row = self.LeftPanel.Scroll:Add("DPanel")
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, margin)
        row:SetTall(rowTall)
        row.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
            draw.SimpleText("#" .. k, "BaseWars.18", h * .5, h * .5, color, 1, 1)

            BaseWars:DrawRoundedBox(roundness, h + margin, 0, self.rowWide, h, self.colors.contentBackground)
            draw.SimpleText(BaseWars:GetSteamName(v.player_id64), "BaseWars.18", h + margin + bigMargin, h * .5, color, 0, 1)
            draw.SimpleText(self:GetValue(what, v), "BaseWars.18", w - bigMargin, h * .5, color, 2, 1)
        end
    end
end

function PANEL:BuildRight(what)
    rightDisplay = what
    self.RightPanel.Scroll:GetCanvas():Clear()

    if not self.RightPanel.Topbar then
        self.RightPanel.Topbar = self.RightPanel:Add("DButton")
        self.RightPanel.Topbar:SetText("")
        self.RightPanel.Topbar:Dock(TOP)
        self.RightPanel.Topbar:DockMargin(0, 0, 0, bigMargin)
        self.RightPanel.Topbar:SetTall(elementTall)
        self.RightPanel.Topbar.Paint = function(s,w,h)
            s.angle = Lerp(FrameTime() * 20, s.angle or -90, (IsValid(self.dropDown) and self.dropDown.side == "right" ) and 0 or -90)

            BaseWars:DrawRoundedBox(roundness, 0, 0, w, elementTall, self.colors.contentBackground)
            BaseWars:DrawMaterial(arrow, w - h * .5, h * .5, arrowSize, arrowSize, self.colors.text, s.angle)

            draw.SimpleText(self.localPlayer:GetLang("leaderboard_title", rightDisplay), "BaseWars.24", w * .5, h * .5, self.colors.text, 1, 1)
        end
        self.RightPanel.Topbar.DoClick = function(s)
            surface.PlaySound("basewars/button.wav")

            local _, y = s:LocalToScreen()
            local _, h = s:GetSize()
            local mouseX = gui.MouseX()

            self.dropDown = BaseWars:DropdownPopup(mouseX, y + h + margin)
            self.dropDown.side = "right"
            for k, id in ipairs(options) do
                if leftDisplay == id or rightDisplay == id then continue end
                if id == "prestige" and not BaseWars.Config.Prestige.Enable then continue end

                self.dropDown:AddChoice(self.localPlayer:GetLang("leaderboard_title", id), function()
                    if IsValid(self) then
                        self:BuildRight(id)
                    end
                end)
            end
        end
    end

    for k, v in ipairs(leaderboardData[what]) do
        BaseWars:RequestSteamName(v.player_id64)

        local color = k <= 3 and self.colors["top" .. k] or self.colors.darkText

        local row = self.RightPanel.Scroll:Add("DPanel")
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, margin)
        row:SetTall(rowTall)
        row.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
            draw.SimpleText("#" .. k, "BaseWars.18", h * .5, h * .5, color, 1, 1)

            BaseWars:DrawRoundedBox(roundness, h + margin, 0, self.rowWide, h, self.colors.contentBackground)
            draw.SimpleText(BaseWars:GetSteamName(v.player_id64), "BaseWars.18", h + margin + bigMargin, h * .5, color, 0, 1)
            draw.SimpleText(self:GetValue(what, v), "BaseWars.18", w - bigMargin, h * .5, color, 2, 1)
        end
    end
end

function PANEL:Build(left, right)
    if not left and not right then
        left, right = leftDisplay, rightDisplay
    end

    if left then
        self:BuildLeft(left)
    end

    if right then
        self:BuildRight(right)
    end
end

function PANEL:Paint(w,h)
    self.loadingAngle = -CurTime() * 540 % 360
end

vgui.Register("BaseWars.F3Menu.Leaderboard", PANEL, "DPanel")

net.Receive("BaseWars:Leaderboard:SendToClients", function(len)
    local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

    leaderboardData = data
    if IsValid(thisPanel) then
        thisPanel:Build()
    end
end)