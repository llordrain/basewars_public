local printerUpgrades = {
    {
        id = "interval",
        icon = "interval",
        price = function(printer)
            return IsValid(printer) and printer:GetBaseUpgradePrice() * (printer:GetPrintIntervalLevel() + 1) or 0
        end,
        level = function(printer)
            return IsValid(printer) and printer:GetPrintIntervalLevel() or 0
        end
    },
    {
        id = "amount",
        icon = "amount",
        price = function(printer)
            return IsValid(printer) and printer:GetBaseUpgradePrice() * (printer:GetPrintAmountLevel() + 1) or 0
        end,
        level = function(printer)
            return IsValid(printer) and printer:GetPrintAmountLevel() or 0
        end
    },
    {
        id = "capacity",
        icon = "capacity",
        price = function(printer)
            return IsValid(printer) and printer:GetBaseUpgradePrice() * (printer:GetCapacityLevel() + 1) or 0
        end,
        level = function(printer)
            return IsValid(printer) and printer:GetCapacityLevel() or 0
        end
    },
    {
        id = "paperCapacity",
        icon = "paper",
        price = function(printer)
            return IsValid(printer) and printer:GetBaseUpgradePrice() * (printer:GetPaperCapacityLevel() + 1) or 0
        end,
        level = function(printer)
            return IsValid(printer) and printer:GetPaperCapacityLevel() or 0
        end
    },
    {
        id = "autoPaper",
        icon = "paper",
        price = function(printer)
            return IsValid(printer) and printer:GetBaseUpgradePrice() * 5 or 0
        end,
        level = function(printer)
            return IsValid(printer) and (printer:GetAutoPaper() == true and 1 or 0) or 0
        end
    }
}

local icons = {
    user = Material("basewars_materials/user.png", "smooth"),
    money = Material("basewars_materials/money.png", "smooth"),
    printer = Material("basewars_materials/f4/printer.png", "smooth"),
    upgrade = Material("basewars_materials/printer/upgrade.png", "smooth"),
    interval = Material("basewars_materials/printer/interval.png", "smooth"),
    amount = Material("basewars_materials/printer/amount.png", "smooth"),
    capacity = Material("basewars_materials/printer/capacity.png", "smooth"),
    paper = Material("basewars_materials/printer/paper.png", "smooth")
}

local elementTall = BaseWars.ScreenScale * 40
local buttonTall = BaseWars.ScreenScale * 36
local checkboxTall = BaseWars.ScreenScale * 28
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.localPlayer = LocalPlayer()
    self.printerEntity = self
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
        draw.SimpleText(self:GetPrinter().PrintName or "???", "BaseWars.24", h, h * .5, self.colors.text, 0, 1)

        local extra = BaseWars.ScreenScale * 300
        BaseWars:DrawRoundedBox(roundness, extra, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["money"], extra + bigMargin, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText(BaseWars:FormatMoney(self.localPlayer:GetMoney()), "BaseWars.24", extra + (h - bigMargin), h * .5, self.colors.text, 0, 1)

        local owner = self:GetPrinter():CPPIGetOwner()
        extra = extra * 2
        BaseWars:DrawRoundedBox(roundness, extra, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["user"], extra + bigMargin, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText((IsValid(owner) and owner:Name() or owner) or "Unknown/Disconnected", "BaseWars.24", extra + (h - bigMargin), h * .5, self.colors.text, 0, 1)
    end

    self.Frame.TopBar.Close = self.Frame.TopBar:Add("BaseWars.IconButton")
    self.Frame.TopBar.Close:Dock(RIGHT)
    self.Frame.TopBar.Close:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.TopBar.Close:SetColor(self.colors.contentBackground)
    self.Frame.TopBar.Close.DoClick = function(s)
        s:ButtonSound()
        self:Remove()
    end

    -- self.Frame.TopBar.PaperEmpty = self.Frame.TopBar:Add("DPanel")
    -- self.Frame.TopBar.PaperEmpty:SetWide(elementTall)
    -- self.Frame.TopBar.PaperEmpty:Dock(RIGHT)
    -- self.Frame.TopBar.PaperEmpty:DockMargin(0, bigMargin, bigMargin, bigMargin)
    -- self.Frame.TopBar.PaperEmpty.Paint = function(s,w,h)
    --     BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
    --     BaseWars:DrawMaterial(icons["paper"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, self.flashingColor)
    -- end

    -- self.Frame.TopBar.PrinterFull = self.Frame.TopBar:Add("DPanel")
    -- self.Frame.TopBar.PrinterFull:SetWide(elementTall)
    -- self.Frame.TopBar.PrinterFull:Dock(RIGHT)
    -- self.Frame.TopBar.PrinterFull:DockMargin(0, bigMargin, bigMargin, bigMargin)
    -- self.Frame.TopBar.PrinterFull.Paint = function(s,w,h)
    --     BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
    --     BaseWars:DrawMaterial(icons["money"], bigMargin, bigMargin, h - bigMargin * 2, h - bigMargin * 2, self.flashingColor)
    -- end

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
        draw.SimpleText(self.localPlayer:GetLang("printer_upgradeMenu") .. " - " .. self.localPlayer:GetLang("printer_upgrades", printerUpgrades[self.currentUpgrade].id .. "Name"), "BaseWars.20", h + bigMargin, h * .5, self.colors.text, 0, 1)
    end

    self.Frame.Content.SidePanel.SelectedUpgrade.Once = self.Frame.Content.SidePanel.SelectedUpgrade:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:SetTall(buttonTall)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:Dock(TOP)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.SelectedUpgrade.Once.Draw = function(s,w,h)
        local maxUpgrade = BaseWars.Config.PrinterMaxLevel[printerUpgrades[self.currentUpgrade].id] or 1
        local textToDraw = self.localPlayer:GetLang("printer_upgradeOnce")
        local upgradeCost, upgradeLevel = 0, 0

        if self.currentUpgrade == 5 and not BaseWars:IsVIP(self.localPlayer) then
            textToDraw = self.localPlayer:GetLang("printer_VIPOnly")
        end

        upgradeCost = printerUpgrades[self.currentUpgrade]["price"](self:GetPrinter())
        upgradeLevel = printerUpgrades[self.currentUpgrade]["level"](self:GetPrinter())

        if not self.localPlayer:CanAfford(upgradeCost) then
            textToDraw = self.localPlayer:GetLang("printer_tooExpensive")
        end

        if upgradeLevel >= maxUpgrade then
            textToDraw = self.localPlayer:GetLang("printer_maxed")
        end

        draw.SimpleText(textToDraw:format(BaseWars:FormatMoney(upgradeCost)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.SelectedUpgrade.Once.DoClick = function(s)
        if not IsValid(self:GetPrinter()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetPrinter():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Printer:BuyUpgrade")
            net.WriteEntity(self:GetPrinter())
            net.WriteUInt(self.currentUpgrade, 3)
            net.WriteBool(false)
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.SelectedUpgrade.Max = self.Frame.Content.SidePanel.SelectedUpgrade:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.SelectedUpgrade.Max:SetTall(buttonTall)
    self.Frame.Content.SidePanel.SelectedUpgrade.Max:Dock(TOP)
    self.Frame.Content.SidePanel.SelectedUpgrade.Max:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.SelectedUpgrade.Max:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.SelectedUpgrade.Max.Draw = function(s,w,h)
        local maxUpgrade = BaseWars.Config.PrinterMaxLevel[printerUpgrades[self.currentUpgrade].id] or 1

        local totalCost, totalUpgrade, currentLevel = 0, 0, 0
        local textToDraw = self.localPlayer:GetLang("printer_upgradeMax")
        local baseCost = IsValid(self:GetPrinter()) and self:GetPrinter():GetBaseUpgradePrice() or 0

        if self.currentUpgrade == 5 and not BaseWars:IsVIP(self.localPlayer) then
            draw.SimpleText(self.localPlayer:GetLang("printer_VIPOnly"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)

            return
        end

        currentLevel = printerUpgrades[self.currentUpgrade]["level"](self:GetPrinter())

        if currentLevel >= maxUpgrade then
            draw.SimpleText(self.localPlayer:GetLang("printer_maxed"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)

            return
        end

        if self.currentUpgrade == 5 then
            baseCost = printerUpgrades[5]["price"](self:GetPrinter())
        end

        for i = currentLevel + 1, maxUpgrade do -- +1 cause i dont need to pay for the upgrade i already have
            if not self.localPlayer:CanAfford(totalCost + baseCost * i) then
                break
            end

            totalCost = totalCost + baseCost * i
            totalUpgrade = totalUpgrade + 1
        end

        if totalUpgrade <= 0 then
            textToDraw = self.localPlayer:GetLang("printer_tooExpensive")
        end

        draw.SimpleText(textToDraw:format(totalUpgrade, BaseWars:FormatMoney(totalCost)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.SelectedUpgrade.Max.DoClick = function(s)
        if not IsValid(self:GetPrinter()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetPrinter():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Printer:BuyUpgrade")
            net.WriteEntity(self:GetPrinter())
            net.WriteUInt(self.currentUpgrade, 3)
            net.WriteBool(true)
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.SelectedUpgrade:CalculateTall()

    --[[-------------------------------------------------------------------------
        UPGRADE ONCE/MAX - END

        QUICK UPGRADE - START
    ---------------------------------------------------------------------------]]

    self.Frame.Content.SidePanel.QuickUpgrade = self.Frame.Content.SidePanel:Add("DPanel")
    self.Frame.Content.SidePanel.QuickUpgrade:Dock(TOP)
    self.Frame.Content.SidePanel.QuickUpgrade:DockMargin(0, bigMargin, 0, bigMargin)
    self.Frame.Content.SidePanel.QuickUpgrade.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
    end

    self.Frame.Content.SidePanel.QuickUpgrade.Title = self.Frame.Content.SidePanel.QuickUpgrade:Add("DPanel")
    self.Frame.Content.SidePanel.QuickUpgrade.Title:SetTall(elementTall)
    self.Frame.Content.SidePanel.QuickUpgrade.Title:Dock(TOP)
    self.Frame.Content.SidePanel.QuickUpgrade.Title:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.QuickUpgrade.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["upgrade"], bigMargin * 1, bigMargin * 1, h - bigMargin * 2, h - bigMargin * 2, self.colors.text)
        draw.SimpleText(self.localPlayer:GetLang("printer_quickUpgrade"), "BaseWars.20", h + bigMargin, h * .5, self.colors.text, 0, 1)
    end

    for k, v in ipairs(printerUpgrades) do
        local upg = self.Frame.Content.SidePanel.QuickUpgrade:Add("DPanel")
        upg:SetTall(checkboxTall)
        upg:Dock(TOP)
        upg:DockMargin(bigMargin, bigMargin, bigMargin, 0)
        upg.Paint = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", v.id .. "Name"), "BaseWars.18", h * 3 + margin, h * .5, self.colors.text, 0, 1)
        end

        upg.CheckBox = upg:Add("BaseWars.CheckBox")
        upg.CheckBox:SetWide(upg:GetTall() * 3)
        upg.CheckBox:Dock(LEFT)
        upg.CheckBox:SetState((k == 1 or k == 2 or (k == 5 and BaseWars:IsVIP(self.localPlayer))) and true or false, true)
        upg.CheckBox.id = k
        upg.CheckBox.Toggle = function(s)
            if k == 5 and not BaseWars:IsVIP(self.localPlayer) then return end

            surface.PlaySound("basewars/button.wav")
            s:SetState(not s:GetState())

            s:OnToggle(s:GetState())
        end
    end

    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton = self.Frame.Content.SidePanel.QuickUpgrade:Add("BaseWars.Button2")
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton:SetTall(buttonTall)
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton:Dock(TOP)
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton:SetColor(self.colors.contentBackground, true)
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgradeMenu"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.QuickUpgrade.UpgradeButton.DoClick = function(s)
        if not IsValid(self:GetPrinter()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetPrinter():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        local upgrades = {}
        for k, v in ipairs(s:GetParent():GetChildren()) do
            if not v.CheckBox then continue end

            upgrades[v.CheckBox.id] = v.CheckBox:GetState()
        end

        if table.IsEmpty(upgrades) then
            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Printer:QuickUpgrade")
            net.WriteEntity(self:GetPrinter())
            net.WriteTable(upgrades)
            net.WriteBool(bypass)
        net.SendToServer()
    end

    self.Frame.Content.SidePanel.QuickUpgrade:CalculateTall()

    --[[-------------------------------------------------------------------------
        QUICK UPGRADE - END

        BUY PAPER - START
    ---------------------------------------------------------------------------]]

    self.Frame.Content.SidePanel.BuyPaper = self.Frame.Content.SidePanel:Add("DPanel")
    self.Frame.Content.SidePanel.BuyPaper:SetTall(elementTall + buttonTall + bigMargin * 3)
    self.Frame.Content.SidePanel.BuyPaper:Dock(TOP)
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
        local maxPaper = IsValid(self:GetPrinter()) and self:GetPrinter():GetMaxPaper() or 0
        local paper = IsValid(self:GetPrinter()) and self:GetPrinter():GetPaper() or 0
        local missingPaper = maxPaper - paper

        draw.SimpleText(self.localPlayer:GetLang("printer_buyPaperFor"):format(BaseWars:FormatNumber(missingPaper), BaseWars:FormatMoney(missingPaper * BaseWars.Config.PrinterPaperPrice)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.BuyPaper.BuyButton.DoClick = function(s)
        if not IsValid(self:GetPrinter()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetPrinter():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Printer:BuyPaperFromMenu")
            net.WriteEntity(self:GetPrinter())
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
        draw.SimpleText(self.localPlayer:GetLang("printer_takeMoneyButton"):format(BaseWars:FormatMoney(IsValid(self:GetPrinter()) and self:GetPrinter():GetMoney() or 0)), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Frame.Content.SidePanel.TakeMoney.TakeButton.DoClick = function(s)
        if not IsValid(self:GetPrinter()) then return end

        s:ButtonSound()

        local bypass = input.IsKeyDown(KEY_LSHIFT) and BaseWars:IsSuperAdmin(self.localPlayer)
        if not bypass and not BaseWars.Config.PrinterPublic and self:GetPrinter():CPPIGetOwner() != self.localPlayer then
            s:Disable(3, self.colors.notAllowed, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_notYours"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)

            return
        end

        if bypass then
            s:CustomTempDraw(3, self.colors.bypass, function(_,w,h)
                draw.SimpleText(self.localPlayer:GetLang("printer_superAdminBypass"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
            end)
        end

        net.Start("BaseWars:Printer:TakeMoneyMenu")
            net.WriteEntity(self:GetPrinter())
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

    for k, v in ipairs(printerUpgrades) do
        local upgrade = self.Frame.Content.Scroll:Add("DButton")
        upgrade:SetText("")
        upgrade:SetTall(elementTall + bigMargin * 2)
        upgrade:Dock(TOP)
        upgrade:DockMargin(0, 0, 0, bigMargin)
        upgrade._lerpColor = self.colors.contentBackground
        upgrade.Paint = function(s,w,h)
            local upgradeConfig = BaseWars.Config.PrinterMaxLevel
            local price, level, max = 0, 0, upgradeConfig[v.id] or 1 -- Default to 1 if not found
            local maxText = self.localPlayer:GetLang("printer_maxed")

            s._lerpColor = BaseWars:LerpColor(FrameTime() * 15, s._lerpColor, self.currentUpgrade == k and self.colors.accent or self.colors.contentBackground)

            -- Background
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)

            -- Icon
            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, elementTall, elementTall, s._lerpColor)
            BaseWars:DrawMaterial(icons[v.icon], bigMargin * 2, bigMargin * 2, elementTall - bigMargin * 2, elementTall - bigMargin * 2, self.colors.text)

            -- Name / Desc
            draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", v.id .. "Name"), "BaseWars.24", h, h * .5, self.colors.text, 0, 4)
            draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", v.id .. "Desc"), "BaseWars.18", h, h * .5, self.colors.darkText, 0, 2)

            price = printerUpgrades[k]["price"](self:GetPrinter())
            level = printerUpgrades[k]["level"](self:GetPrinter())

            -- Level
            draw.SimpleText(self.localPlayer:GetLang("printer_level"), "BaseWars.18", w - BaseWars.ScreenScale * 50, h * .5, self.colors.text, 1, 4)
            draw.SimpleText(level >= max and maxText or level .. "/" .. max, "BaseWars.16", w - BaseWars.ScreenScale * 50, h * .5, self.colors.darkText, 1, 0)

            -- Price
            draw.SimpleText(self.localPlayer:GetLang("printer_price"), "BaseWars.18", w - BaseWars.ScreenScale * 180, h * .5, self.colors.text, 1, 4)
            draw.SimpleText(level >= max and maxText or BaseWars:FormatMoney(price), "BaseWars.16", w - BaseWars.ScreenScale * 180, h * .5, self.colors.darkText, 1, 0)
        end
        upgrade.DoClick = function(s)
            if self.currentUpgrade == k then
                return
            end

            self.currentUpgrade = k

            surface.PlaySound("basewars/button.wav")
        end
    end

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:Think()
    if self.printerEntity != self and not IsValid(self.printerEntity) then
        self:Remove()
    end

    if gui.IsGameUIVisible() then
        gui.HideGameUI()
        self:Remove()
    end

    self.flashingColor = HSVToColor(0, math.abs(math.sin(CurTime() * 2)), 1)
end

function PANEL:SetPrinter(entity)
    self.printerEntity = entity
end

function PANEL:GetPrinter()
    return self.printerEntity
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.VGUI.PrinterUpgrade", PANEL, "EditablePanel")