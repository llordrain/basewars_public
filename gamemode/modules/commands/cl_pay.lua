local closeIcon = Material("basewars_materials/close.png", "smooth")
local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
    local ply = LocalPlayer()
    self.startTime = SysTime()
    self.selectedPlayer = ply

    self:SetSize(BaseWars.ScreenScale * 600, BaseWars.ScreenScale * 120 + buttonSize + bigMargin * 5 + margin)
    self:Center()
    self:MakePopup()
    self:SetKeyboardInputEnabled(true)

    self.Title = self:Add("DPanel")
    self.Title:Dock(TOP)
    self.Title:SetTall(BaseWars.ScreenScale * 40)
    self.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBoxEx(6, 0, 0, w, h, BaseWars:GetTheme("pay_titleBar"), true, true)
        draw.SimpleText(string.upper(ply:GetLang("pay_title")), "BaseWars.24", w * .5, h * .5, BaseWars:GetTheme("pay_text"), 1, 1)
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
        draw.SimpleText(ply:GetLang("choosePlayer"), "BaseWars.20", bigMargin, h * .5, BaseWars:GetTheme("pay_text"), 0, 1)
        draw.SimpleText(self.selectedPlayer:Name(), "BaseWars.20", w - bigMargin, h * .5, BaseWars:GetTheme("pay_text"), 2, 1)
    end
    self.MiddlePanel.player.DoClick = function(s)
        s:ButtonSound()

        local x, y = s:LocalToScreen()
        local _, h = s:GetSize()

        local panel = BaseWars:DropdownPopup(x, y + h + margin)
        for k, v in player.Iterator() do
            if not IsValid(v) then continue end
            if self.selectedPlayer == v or v == ply then continue end
            if v:IsBot() then continue end

            panel:AddChoice(v:Name(), function()
                self.selectedPlayer = v
            end)
        end
    end

    self.MiddlePanel.Amount = self.MiddlePanel:Add("BaseWars.TextEntry")
    self.MiddlePanel.Amount:Dock(BOTTOM)
    self.MiddlePanel.Amount:SetTall(BaseWars.ScreenScale * 40)
    self.MiddlePanel.Amount:SetColor(BaseWars:GetTheme("pay_contentBackground"))
    self.MiddlePanel.Amount:SetTextColor(BaseWars:GetTheme("pay_text"))
    self.MiddlePanel.Amount:SetFont("BaseWars.18")
    self.MiddlePanel.Amount:SetPlaceHolder(ply:GetLang("amount"))
    self.MiddlePanel.Amount:SetPlaceHolderColor(BaseWars:GetTheme("pay_darkText"))
    self.MiddlePanel.Amount:SetNumeric(true)
    self.MiddlePanel.Amount:RequestFocus()
    self.MiddlePanel.Amount.OnChange = function(s, text)
        local num = tonumber(text) or 0

        local max = ply:GetMoney()
        if BaseWars.Config.MaxPay > 0 then
            max = BaseWars.Config.MaxPay
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
        BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("pay_contentBackground"))
    end

    self.Pay = self.BottomPanel:Add("OLD.BaseWars.Button")
    self.Pay:Dock(FILL)
    self.Pay:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Pay:DrawSide(true, true)
    self.Pay.Draw = function(s,w,h)
        local amount = tonumber(self.MiddlePanel.Amount:GetText()) or 0
        if amount < 0 then
            amount = 0
        end

        draw.SimpleText(LocalPlayer():GetLang("pay_giveTo"):format(BaseWars:FormatMoney(amount), self.selectedPlayer:Name()), "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("pay_text"), 1, 1)
    end
    self.Pay.DoClick = function(s)
        local amount = tonumber(self.MiddlePanel.Amount:GetText()) or 0
        if amount <= 0 then return end

        s:ButtonSound()

        net.Start("BaseWars:Pay")
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
        BaseWars:DrawMaterial(closeIcon, (w - h * .5) * .5, bigMargin, h * .5, h * .5, BaseWars:GetTheme("pay_text"))
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
    if not (self.selectedPlayer and self.selectedPlayer:IsPlayer()) then
        self.selectedPlayer = LocalPlayer()
    end
end

function PANEL:SetAmount(amount)
    self.MiddlePanel.Amount:SetText(amount)
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.Pay", PANEL, "EditablePanel")

net.Receive("BaseWars:Pay", function(len)
    local target = net.ReadEntity()
    local amount = net.ReadDouble()

    if BaseWars.Config.MaxPay > 0 then
        amount = math.min(BaseWars.Config.MaxPay, amount)
    end

    local payPanel = vgui.Create("BaseWars.Pay")
    payPanel:SetPlayer(target)
    payPanel:SetAmount(amount)
end)