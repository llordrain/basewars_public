
local titleTall = BaseWars.ScreenScale * 50
local elementTall = BaseWars.ScreenScale * 40
local buttonTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local roundness = BaseWars.ScreenScale * 4

--[[-------------------------------------------------------------------------
    MARK: Default Popup
---------------------------------------------------------------------------]]

local POPUP = {}
function POPUP:Init()
    self.localPlayer = LocalPlayer()

    self.title = "Title"
    self.text = "text"

    self.confirmFunc = function() end
    self.confirmText = "Confirm Text"

    self.cancelFunc = function() end
    self.cancelText = self.localPlayer:GetLang("cancel")

    self.colors = {
        text = BaseWars:GetTheme("am_text"),
        darkText = BaseWars:GetTheme("am_darkText"),
        background = BaseWars:GetTheme("am_background"),
        contentBackground = BaseWars:GetTheme("am_contentBackground")
    }

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Frame = self:Add("DPanel")
    self.Frame:SetSize(BaseWars.ScreenScale * 500, titleTall + elementTall + buttonTall + bigMargin * 4)
    self.Frame:Center()
    self.Frame.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Title = self.Frame:Add("DPanel")
    self.Frame.Title:Dock(TOP)
    self.Frame.Title:SetTall(titleTall)
    self.Frame.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBoxEx(roundness, 0, 0, w, h, self.colors.contentBackground, true, true)

        draw.SimpleText(self.title, "BaseWars.24", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Frame.Text = self.Frame:Add("DPanel")
    self.Frame.Text:Dock(FILL)
    self.Frame.Text:DockMargin(0, bigMargin, 0, 0)
    self.Frame.Text.Paint = function(s,w,h)
        draw.SimpleText(self.text, "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Frame.Bottom = self.Frame:Add("DPanel")
    self.Frame.Bottom:Dock(BOTTOM)
    self.Frame.Bottom:SetTall(buttonTall + bigMargin * 2)
    self.Frame.Bottom.Paint = nil

    self.Frame.Bottom.Confirm = self.Frame.Bottom:Add("BaseWars.Button2")
    self.Frame.Bottom.Confirm:Dock(LEFT)
    self.Frame.Bottom.Confirm:DockMargin(bigMargin, bigMargin, 0, bigMargin)
    self.Frame.Bottom.Confirm:SetWide((self.Frame:GetWide() - bigMargin * 3) * .5)
    self.Frame.Bottom.Confirm:SetColor(self.colors.contentBackground, true)
    self.Frame.Bottom.Confirm.Draw = function(s,w,h)
        draw.SimpleText(self.confirmText, "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Bottom.Confirm.DoClick = function(s)
        s:ButtonSound()

        self.confirmFunc()
        self:Remove()
    end

    self.Frame.Bottom.Cancel = self.Frame.Bottom:Add("BaseWars.Button2")
    self.Frame.Bottom.Cancel:Dock(RIGHT)
    self.Frame.Bottom.Cancel:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.Bottom.Cancel:SetWide((self.Frame:GetWide() - bigMargin * 3) * .5)
    self.Frame.Bottom.Cancel:SetColor(self.colors.contentBackground, true)
    self.Frame.Bottom.Cancel.Draw = function(s,w,h)
        draw.SimpleText(self.cancelText, "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Bottom.Cancel.DoClick = function(s)
        s:ButtonSound()

        self.cancelFunc()
        self:Remove()
    end

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function POPUP:SetTitle(title, ...)
    if not isstring(title) then return end

    self.title = title[1] == "#" and Format(self.localPlayer:GetLang(string.sub(title, 2)), unpack({...})) or title
end

function POPUP:SetText(text, ...)
    if not isstring(text) then return end

    self.text = text[1] == "#" and Format(self.localPlayer:GetLang(string.sub(text, 2)), unpack({...})) or text
end

function POPUP:SetConfirm(text, func)
    if not isstring(text) or not isfunction(func) then return end

    self.confirmFunc = func
    self.confirmText = text
end

function POPUP:SetCancel(text, func)
    if not isstring(text) or not isfunction(func) then return end

    self.cancelFunc = func
    self.cancelText = text
end

function POPUP:OnMousePressed()
    self:Remove()
end

function POPUP:Paint(w,h)
end

vgui.Register("BaseWars.Popup", POPUP, "EditablePanel")

--[[-------------------------------------------------------------------------
    MARK: Shop Popup
---------------------------------------------------------------------------]]

local SHOP_POPUP = {}
function SHOP_POPUP:Init()
    self.localPlayer = LocalPlayer()

    self.title = "none"
    self.text = "none"

    self.colors = {
        text = BaseWars:GetTheme("am_text"),
        darkText = BaseWars:GetTheme("am_darkText"),
        background = BaseWars:GetTheme("am_background"),
        contentBackground = BaseWars:GetTheme("am_contentBackground")
    }

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Frame = self:Add("DPanel")
    self.Frame:SetSize(BaseWars.ScreenScale * 500, titleTall + elementTall + buttonTall + bigMargin * 4)
    self.Frame:Center()
    self.Frame.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Title = self.Frame:Add("DPanel")
    self.Frame.Title:Dock(TOP)
    self.Frame.Title:SetTall(titleTall)
    self.Frame.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBoxEx(roundness, 0, 0, w, h, self.colors.contentBackground, true, true)

        draw.SimpleText(self.title, "BaseWars.24", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Frame.Text = self.Frame:Add("DPanel")
    self.Frame.Text:Dock(FILL)
    self.Frame.Text:DockMargin(0, bigMargin, 0, 0)
    self.Frame.Text.Paint = function(s,w,h)
        draw.SimpleText(self.text, "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Frame.Bottom = self.Frame:Add("DPanel")
    self.Frame.Bottom:Dock(BOTTOM)
    self.Frame.Bottom:SetTall(buttonTall + bigMargin * 2)
    self.Frame.Bottom.Paint = nil

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function SHOP_POPUP:SetEntityID(entityID)
    if not BaseWars:GetBaseWarsEntity(entityID) then return end

    self.entityID = entityID

    local bool, why = LocalPlayer():CanBuy(entityID)
    local whyW, _ = BaseWars:GetTextSize(why, "BaseWars.20")

    self.title = self.localPlayer:GetLang(bool and "bws_confirmPurchase" or "bws_confirmError")
    self.text = why

    if whyW > self:GetWide() then
        self:SetWide(whyW + bigMargin * 6)
    end

    self:CreateButtons(bool)
end

function SHOP_POPUP:CreateButtons(bool)
    if not bool then
        self.Frame.Bottom.Cancel = self.Frame.Bottom:Add("BaseWars.Button2")
        self.Frame.Bottom.Cancel:Dock(FILL)
        self.Frame.Bottom.Cancel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
        self.Frame.Bottom.Cancel:SetColor(self.colors.contentBackground, true)
        self.Frame.Bottom.Cancel.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("bws_understand"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
        end
        self.Frame.Bottom.Cancel.DoClick = function(s)
            s:ButtonSound()

            self:Remove()
        end

        return
    end

    self.Frame.Bottom.Confirm = self.Frame.Bottom:Add("BaseWars.Button2")
    self.Frame.Bottom.Confirm:Dock(LEFT)
    self.Frame.Bottom.Confirm:DockMargin(bigMargin, bigMargin, 0, bigMargin)
    self.Frame.Bottom.Confirm:SetWide((self.Frame:GetWide() - bigMargin * 3) * .5)
    self.Frame.Bottom.Confirm:SetColor(self.colors.contentBackground, true)
    self.Frame.Bottom.Confirm.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("bws_confirm"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Bottom.Confirm.DoClick = function(s)
        s:ButtonSound()
        RunConsoleCommand("basewarsbuy", self.entityID)

        self:Remove()

        if LocalPlayer():GetBaseWarsConfig("closeOnBuy") then
            BaseWars:CloseF4Menu()
        end
    end

    self.Frame.Bottom.Cancel = self.Frame.Bottom:Add("BaseWars.Button2")
    self.Frame.Bottom.Cancel:Dock(RIGHT)
    self.Frame.Bottom.Cancel:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.Bottom.Cancel:SetWide((self.Frame:GetWide() - bigMargin * 3) * .5)
    self.Frame.Bottom.Cancel:SetColor(self.colors.contentBackground, true)
    self.Frame.Bottom.Cancel.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("bws_cancel"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Bottom.Cancel.DoClick = function(s)
        s:ButtonSound()

        self:Remove()
    end
end

function SHOP_POPUP:OnMousePressed()
    self:Remove()
end

function SHOP_POPUP:Paint(w,h)
end

vgui.Register("BaseWars.Popup.Shop", SHOP_POPUP, "EditablePanel")