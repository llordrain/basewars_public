local bankUpgrades = {
    {
        id = "capacity",
        icon = "capacity",
        price = function(bank)
            return IsValid(bank) and bank:GetCapacityCost() or 0
        end,
        level = function(bank)
            return IsValid(bank) and bank:GetCapacityLevel() or 0
        end
    },
    {
        id = "health",
        icon = "health",
        price = function(bank)
            return IsValid(bank) and bank:GetHealthCost() or 0
        end,
        level = function(bank)
            return IsValid(bank) and bank:GetHealthLevel() or 0
        end
    }
}

local icons = {
    user = Material("basewars_materials/user.png", "smooth"),
    money = Material("basewars_materials/money.png", "smooth"),
    printer = Material("basewars_materials/f4/printer.png", "smooth"),
    upgrade = Material("basewars_materials/printer/upgrade.png", "smooth"),
    paper = Material("basewars_materials/printer/paper.png", "smooth"),
    capacity = Material("basewars_materials/printer/capacity.png", "smooth"),
    health = Material("basewars_materials/printer/health.png", "smooth"),
}

local elementTall = BaseWars.ScreenScale * 40
local buttonTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.localPlayer = LocalPlayer()
    self.bankEntity = self
    self.currentUpgrade = 1
    self.colors = {
        background = BaseWars:GetTheme("printer_background"),
        contentBackground = BaseWars:GetTheme("printer_contentBackground"),
        text = BaseWars:GetTheme("printer_text"),
        darkText = BaseWars:GetTheme("printer_darkText"),
        accent = BaseWars:GetTheme("gen_accent"),
        notAllowed = BaseWars:GetTheme("button_disabled"),
        bypass = BaseWars:GetTheme("printer_bypass"),
    }

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Frame = self:Add("DPanel")
    self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
    self.Frame:Center()
    self.Frame.Paint = nil

    self.Frame.TopBar = self.Frame:Add("DPanel")
    self.Frame.TopBar:Dock(TOP)
    self.Frame.TopBar:DockMargin(0, 0, 0, bigMargin * 5)
    self.Frame.TopBar:SetTall(elementTall + bigMargin * 2)
    self.Frame.TopBar.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)

        local boxSize = elementTall
        local iconSize = elementTall - bigMargin * 2

        BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["printer"], bigMargin * 2, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText(self.localPlayer:GetLang("bank_connectedMenu"):format(IsValid(self:GetBank()) and self:GetBank():GetPrinterCount() or 0), "BaseWars.24", h, h * .5, self.colors.text, 0, 1)

        local extra = BaseWars.ScreenScale * 320
        BaseWars:DrawRoundedBox(roundness, extra, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["money"], extra + bigMargin, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText(BaseWars:FormatMoney(self.localPlayer:GetMoney()), "BaseWars.24", extra + (h - bigMargin), h * .5, self.colors.text, 0, 1)

        local owner = self:GetBank():CPPIGetOwner()
        extra = extra * 2
        BaseWars:DrawRoundedBox(roundness, extra, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["user"], extra + bigMargin, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText((IsValid(owner) and owner:Name() or owner) or "Unknown/Disconnected", "BaseWars.24", extra + (h - bigMargin), h * .5, self.colors.text, 0, 1)

        extra = extra * 1.5
        BaseWars:DrawRoundedBox(roundness, extra, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["capacity"], extra + bigMargin, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText(IsValid(self:GetBank()) and BaseWars:FormatMoney(self:GetBank():GetCapacity()) or "???", "BaseWars.24", extra + (h - bigMargin), h * .5, self.colors.text, 0, 1)
    end

    self.Frame.TopBar.Close = self.Frame.TopBar:Add("BaseWars.IconButton")
    self.Frame.TopBar.Close:Dock(RIGHT)
    self.Frame.TopBar.Close:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.TopBar.Close:SetColor(self.colors.contentBackground)
    self.Frame.TopBar.Close.DoClick = function(s)
        s:ButtonSound()
        self:Remove()
    end

    self.Frame.Content = self.Frame:Add("DPanel")
    self.Frame.Content:Dock(FILL)
    self.Frame.Content.Paint = nil

    self.Frame.Content.SidePanel = self.Frame.Content:Add("DScrollPanel")
    self.Frame.Content.SidePanel:SetWide(BaseWars.ScreenScale * 300)
    self.Frame.Content.SidePanel:Dock(RIGHT)
    self.Frame.Content.SidePanel:DockMargin(bigMargin * 5, 0, 0, 0)
    self.Frame.Content.SidePanel:GetVBar():SetWide(0)

    --[[-------------------------------------------------------------------------
        UPGRADE ONCE/MAX - START
    ---------------------------------------------------------------------------]]

    self.Frame.Content.SidePanel.SelectedUpgrade = self.Frame.Content.SidePanel:Add("DPanel")
    self.Frame.Content.SidePanel.SelectedUpgrade:SetTall(buttonTall * 2 + elementTall + bigMargin * 4)
    self.Frame.Content.SidePanel.SelectedUpgrade:Dock(TOP)
    self.Frame.Content.SidePanel.SelectedUpgrade.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Content.SidePanel.SelectedUpgrade.Title = self.Frame.Content.SidePanel.SelectedUpgrade:Add("DPanel")
    self.Frame.Content.SidePanel.SelectedUpgrade.Title:SetTall(elementTall)
    self.Frame.Content.SidePanel.SelectedUpgrade.Title:Dock(TOP)
    self.Frame.Content.SidePanel.SelectedUpgrade.Title:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.SelectedUpgrade.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["upgrade"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, self.colors.text)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgradeMenu") .. " - " .. self.localPlayer:GetLang("bank_upgrades", bankUpgrades[self.currentUpgrade].id .. "Name"), "BaseWars.20", h + bigMargin, h * .5, self.colors.text, 0, 1)
    end

    self.Frame.Content.SidePanel.SelectedUpgrade.Once = self.Frame.Content.SidePanel.SelectedUpgrade:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:SetTall(buttonTall)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:Dock(TOP)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once.Draw = function(s,w,h)
        local maxUpgrade = BaseWars.Config.BankMaxLevel[bankUpgrades[self.currentUpgrade].id] or 1
        local textToDraw = self.localPlayer:GetLang("printer_upgradeOnce")
        local upgradeCost, upgradeLevel = bankUpgrades[self.currentUpgrade]["price"](self:GetBank()), bankUpgrades[self.currentUpgrade]["level"](self:GetBank())
        local realCost = upgradeCost * 10 ^ upgradeLevel

        if not self.localPlayer:CanAfford(realCost) then
            textToDraw = self.localPlayer:GetLang("printer_tooExpensive")
        end

        if upgradeLevel >= maxUpgrade then
            textToDraw = self.localPlayer:GetLang("printer_maxed")
        end

        draw.SimpleText(textToDraw:format(BaseWars:FormatMoney(realCost)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.SelectedUpgrade.Once.DoClick = function(s)
        if not IsValid(self:GetBank()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetBank():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("bank_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Bank:BuyUpgrade")
            net.WriteEntity(self:GetBank())
            net.WriteUInt(self.currentUpgrade, 2)
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.SelectedUpgrade:CalculateTall()

    --[[-------------------------------------------------------------------------
        UPGRADE ONCE/MAX - END

        BUY PAPER - START
    ---------------------------------------------------------------------------]]

    self.Frame.Content.SidePanel.BuyPaper = self.Frame.Content.SidePanel:Add("DPanel")
    self.Frame.Content.SidePanel.BuyPaper:SetTall(elementTall + buttonTall + bigMargin * 3)
    self.Frame.Content.SidePanel.BuyPaper:Dock(TOP)
    self.Frame.Content.SidePanel.BuyPaper:DockMargin(0, bigMargin, 0, 0)
    self.Frame.Content.SidePanel.BuyPaper.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Content.SidePanel.BuyPaper.Title = self.Frame.Content.SidePanel.BuyPaper:Add("DPanel")
    self.Frame.Content.SidePanel.BuyPaper.Title:SetTall(elementTall)
    self.Frame.Content.SidePanel.BuyPaper.Title:Dock(TOP)
    self.Frame.Content.SidePanel.BuyPaper.Title:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.BuyPaper.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["paper"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, self.colors.text)
        draw.SimpleText(self.localPlayer:GetLang("printer_buyPaperMenu"), "BaseWars.20", h + bigMargin, h * .5, self.colors.text, 0, 1)
    end

    self.Frame.Content.SidePanel.BuyPaper.BuyButton = self.Frame.Content.SidePanel.BuyPaper:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.BuyPaper.BuyButton:SetTall(buttonTall)
    self.Frame.Content.SidePanel.BuyPaper.BuyButton:Dock(TOP)
    self.Frame.Content.SidePanel.BuyPaper.BuyButton:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.BuyPaper.BuyButton:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.BuyPaper.BuyButton.Draw = function(s,w,h)
        local totalPaper = 0

        for k, v in ents.Iterator() do
            if not IsValid(v) then continue end
            if not v.IsPrinter then continue end
            if v:CPPIGetOwner() != self:GetBank():CPPIGetOwner() then continue end
            if not v:GetConnectedToBank() then continue end

            local maxPaper = v:GetMaxPaper() or 0
            local paper = v:GetPaper() or 0
            totalPaper = totalPaper + (maxPaper - paper)
        end

        draw.SimpleText(self.localPlayer:GetLang("printer_buyPaperFor"):format(BaseWars:FormatNumber(totalPaper), BaseWars:FormatMoney(totalPaper * BaseWars.Config.PrinterPaperPrice)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.BuyPaper.BuyButton.DoClick = function(s)
        if not IsValid(self:GetBank()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetBank():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("bank_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        local printers = {}
        for k, v in ents.Iterator() do
            if not IsValid(v) then continue end
            if not v.IsPrinter then continue end
            if v:CPPIGetOwner() != self:GetBank():CPPIGetOwner() then continue end
            if not v:GetConnectedToBank() then continue end

            table.insert(printers, v)
        end

        net.Start("BaseWars:Bank:BuyPaper")
            net.WriteTable(printers)
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.BuyPaper:CalculateTall()

    --[[-------------------------------------------------------------------------
        BUY PAPER - END

        TAKE MONEY - START
    ---------------------------------------------------------------------------]]

    self.Frame.Content.SidePanel.TakeMoney = self.Frame.Content.SidePanel:Add("DPanel")
    self.Frame.Content.SidePanel.TakeMoney:Dock(TOP)
    self.Frame.Content.SidePanel.TakeMoney:DockMargin(0, bigMargin, 0, 0)
    self.Frame.Content.SidePanel.TakeMoney.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Content.SidePanel.TakeMoney.Title = self.Frame.Content.SidePanel.TakeMoney:Add("DPanel")
    self.Frame.Content.SidePanel.TakeMoney.Title:SetTall(elementTall)
    self.Frame.Content.SidePanel.TakeMoney.Title:Dock(TOP)
    self.Frame.Content.SidePanel.TakeMoney.Title:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.TakeMoney.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["money"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, self.colors.text)
        draw.SimpleText(self.localPlayer:GetLang("printer_takeMoney"), "BaseWars.20", h + bigMargin, h * .5, self.colors.text, 0, 1)
    end

    self.Frame.Content.SidePanel.TakeMoney.TakeButton = self.Frame.Content.SidePanel.TakeMoney:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.TakeMoney.TakeButton:SetTall(buttonTall)
    self.Frame.Content.SidePanel.TakeMoney.TakeButton:Dock(TOP)
    self.Frame.Content.SidePanel.TakeMoney.TakeButton:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.TakeMoney.TakeButton:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.TakeMoney.TakeButton.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_takeMoneyButton"):format(BaseWars:FormatMoney(IsValid(self:GetBank()) and self:GetBank():GetMoney() or 0)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.TakeMoney.TakeButton.DoClick = function(s)
        if not IsValid(self:GetBank()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetBank():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("bank_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Bank:TakeMoney")
            net.WriteEntity(self:GetBank())
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.TakeMoney:CalculateTall()

    --[[-------------------------------------------------------------------------
        TAKE MONEY - END

        PRINTER UPGRADE SCROLL PANEL
    ---------------------------------------------------------------------------]]

    self.Frame.Content.Scroll = self.Frame.Content:Add("DScrollPanel")
    self.Frame.Content.Scroll:Dock(FILL)
    self.Frame.Content.Scroll:GetVBar():SetWide(0)

    for k, v in ipairs(bankUpgrades) do
        local upgrade = self.Frame.Content.Scroll:Add("DButton")
        upgrade:SetText("")
        upgrade:SetTall(elementTall + bigMargin * 2)
        upgrade:Dock(TOP)
        upgrade:DockMargin(0, 0, 0, bigMargin)
        upgrade._lerpColor = self.colors.contentBackground
        upgrade.Paint = function(s,w,h)
            local upgradeConfig = BaseWars.Config.BankMaxLevel
            local price, level, max = 0, 0, upgradeConfig[v.id] or 1 -- Default to 1 if not found
            local maxText = self.localPlayer:GetLang("printer_maxed")

            s._lerpColor = BaseWars:LerpColor(FrameTime() * 15, s._lerpColor, self.currentUpgrade == k and self.colors.accent or self.colors.contentBackground)

            -- Background
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)

            -- Icon
            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, elementTall, elementTall, s._lerpColor)
            BaseWars:DrawMaterial(icons[v.icon], bigMargin * 2, bigMargin * 2, elementTall - bigMargin * 2, elementTall - bigMargin * 2, self.colors.text)

            -- Name / Desc
            draw.SimpleText(self.localPlayer:GetLang("bank_upgrades", v.id .. "Name"), "BaseWars.24", h, h * .5, self.colors.text, 0, 4)
            draw.SimpleText(self.localPlayer:GetLang("bank_upgrades", v.id .. "Desc"), "BaseWars.18", h, h * .5, self.colors.darkText, 0, 2)

            price = bankUpgrades[k]["price"](self:GetBank())
            level = bankUpgrades[k]["level"](self:GetBank())

            -- Level
            draw.SimpleText(self.localPlayer:GetLang("printer_level"), "BaseWars.18", w - BaseWars.ScreenScale * 50, h * .5, self.colors.text, 1, 4)
            draw.SimpleText(level >= max and maxText or level .. "/" .. max, "BaseWars.16", w - BaseWars.ScreenScale * 50, h * .5, self.colors.darkText, 1, 0)

            -- Price
            draw.SimpleText(self.localPlayer:GetLang("printer_price"), "BaseWars.18", w - BaseWars.ScreenScale * 180, h * .5, self.colors.text, 1, 4)
            draw.SimpleText(level >= max and maxText or BaseWars:FormatMoney(price * 10 ^ level), "BaseWars.16", w - BaseWars.ScreenScale * 180, h * .5, self.colors.darkText, 1, 0)
        end
        upgrade.DoClick = function(s)
            if self.currentUpgrade == k then
                return
            end

            self.currentUpgrade = k

            surface.PlaySound("bw_button.wav")
        end
    end

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:Think()
    if self.bankEntity != self and not IsValid(self.bankEntity) then
        self:Remove()
    end

    if gui.IsGameUIVisible() then
        gui.HideGameUI()
        self:Remove()
    end
end

function PANEL:SetBank(entity)
    self.bankEntity = entity
end

function PANEL:GetBank()
    return self.bankEntity
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.VGUI.BankUpgrade", PANEL, "EditablePanel")