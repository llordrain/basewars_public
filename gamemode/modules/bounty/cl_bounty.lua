local closeIcon = Material("basewars_materials/close.png", "smooth")
local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
    local ply = LocalPlayer()
    self.selectedPlayer = ply
    self.startTime = SysTime()

    self:SetSize(BaseWars.ScreenScale * 600, BaseWars.ScreenScale * 120 + buttonSize + bigMargin * 5 + margin)
    self:Center()
    self:MakePopup()
    self:SetKeyboardInputEnabled(true)

    self.Title = self:Add("DPanel")
    self.Title:Dock(TOP)
    self.Title:SetTall(BaseWars.ScreenScale * 40)
    self.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBoxEx(6, 0, 0, w, h, GetBaseWarsTheme("bounty_titleBar"), true, true)
        draw.SimpleText(string.upper(ply:GetLang("bounty_title")), "BaseWars.24", w * .5, h * .5, GetBaseWarsTheme("bounty_text"), 1, 1)
    end

    self.MiddlePanel = self:Add("DPanel")
    self.MiddlePanel:Dock(FILL)
    self.MiddlePanel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.MiddlePanel.Paint = nil

    self.MiddlePanel.player = self.MiddlePanel:Add("OLD.BaseWars.Button")
    self.MiddlePanel.player:SetTall(BaseWars.ScreenScale * 40)
    self.MiddlePanel.player:Dock(TOP)
    self.MiddlePanel.player:DockMargin(0, 0, 0, margin)
    self.MiddlePanel.player:DrawSide(true, true)
    self.MiddlePanel.player.Draw = function(s,w,h)
        draw.SimpleText(ply:GetLang("choosePlayer"), "BaseWars.20", bigMargin, h * .5, GetBaseWarsTheme("bounty_text"), 0, 1)
        draw.SimpleText(self.selectedPlayer:Name(), "BaseWars.20", w - bigMargin, h * .5, GetBaseWarsTheme("bounty_text"), 2, 1)
    end
    self.MiddlePanel.player.DoClick = function(s)
        s:ButtonSound()

        local _, y = s:LocalToScreen()
        local _, h = s:GetSize()

        local panel = BaseWars:DropdownPopup(gui.MouseX(), y + h + margin)
        for k, v in player.Iterator() do
            if not IsValid(v) then continue end
            if self.selectedPlayer == v then continue end

            panel:AddChoice(v:Name(), function()
                self.selectedPlayer = v
            end)
        end
    end

    self.MiddlePanel.Amount = self.MiddlePanel:Add("BaseWars.TextEntry")
    self.MiddlePanel.Amount:Dock(BOTTOM)
    self.MiddlePanel.Amount:SetTall(BaseWars.ScreenScale * 40)
    self.MiddlePanel.Amount:SetColor(GetBaseWarsTheme("bounty_contentBackground"))
    self.MiddlePanel.Amount:SetTextColor(GetBaseWarsTheme("bounty_text"))
    self.MiddlePanel.Amount:SetFont("BaseWars.18")
    self.MiddlePanel.Amount:SetPlaceHolder(ply:GetLang("amount"))
    self.MiddlePanel.Amount:SetPlaceHolderColor(GetBaseWarsTheme("bounty_darkText"))
    self.MiddlePanel.Amount:SetNumeric(true)
    self.MiddlePanel.Amount:RequestFocus()
    self.MiddlePanel.Amount.OnChange = function(s, text)
        local num = tonumber(text) or 0

        local max = ply:GetMoney()
        if BaseWars.Config.MaxBounty > 0 then
            max = BaseWars.Config.MaxBounty
        end

        if num < 0 or num > max then
            s:SetText(math.Clamp(num, 0, max))
        end
    end

    self.BottomPanel = self:Add("DPanel")
    self.BottomPanel:Dock(BOTTOM)
    self.BottomPanel:DockMargin(bigMargin, 0, bigMargin, bigMargin)
    self.BottomPanel:SetTall(buttonSize + bigMargin * 2)
    self.BottomPanel.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("bounty_contentBackground"))
    end

    self.PlaceBounty = self.BottomPanel:Add("OLD.BaseWars.Button")
    self.PlaceBounty:Dock(FILL)
    self.PlaceBounty:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.PlaceBounty:DrawSide(true, true)
    self.PlaceBounty.Draw = function(s,w,h)
        local amount = tonumber(self.MiddlePanel.Amount:GetText()) or 0

        draw.SimpleText(ply:GetLang("bounty_placeBounty"):format(BaseWars:FormatMoney(amount, true), self.selectedPlayer:Name()), "BaseWars.18", w * .5, h * .5, GetBaseWarsTheme("bounty_text"), 1, 1)
    end
    self.PlaceBounty.DoClick = function(s)
        local amount = tonumber(self.MiddlePanel.Amount:GetText()) or 0
        if amount <= 0 then return end

        s:ButtonSound()

        net.Start("BaseWars:Bounty")
            net.WriteEntity(self.selectedPlayer)
            net.WriteDouble(amount)
        net.SendToServer()

        self:Remove()
    end

    self.Close = self.BottomPanel:Add("OLD.BaseWars.Button")
    self.Close:Dock(RIGHT)
    self.Close:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Close:SetWide(BaseWars.ScreenScale * 50)
    self.Close:DrawSide(true, true)
    self.Close.Draw = function(s,w,h)
        BaseWars:DrawMaterial(closeIcon, (w - h * .5) * .5, bigMargin, h * .5, h * .5, GetBaseWarsTheme("bounty_text"))
    end
    self.Close.DoClick = function(s)
        s:ButtonSound()
        self:Remove()
    end

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:SetPlayer(ply)
    self.selectedPlayer = ply
end

function PANEL:Think()
    if not IsValid(self.selectedPlayer) then
        self.selectedPlayer = ply
    end
end

function PANEL:SetAmount(amount)
    self.MiddlePanel.Amount:SetText(amount)
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.Bounty", PANEL, "EditablePanel")

net.Receive("BaseWars:Bounty", function(len)
    local target = net.ReadEntity()
    local amount = net.ReadDouble()

    if BaseWars.Config.MaxBounty > 0 then
        amount = math.min(BaseWars.Config.MaxBounty, amount)
    end

    bountyPanel = vgui.Create("BaseWars.Bounty")
    bountyPanel:SetPlayer(target)
    bountyPanel:SetAmount(amount)
end)