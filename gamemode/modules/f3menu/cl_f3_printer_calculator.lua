local icons = {
    plus = Material("basewars_materials/plus.png", "smooth"),
    minus = Material("basewars_materials/minus.png", "smooth"),
    back = Material("basewars_materials/back.png", "smooth")
}

local elementTall = BaseWars.ScreenScale * 40
local buttonTall = BaseWars.ScreenScale * 36
local iconSize = BaseWars.ScreenScale * 14
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.w, self.h = self:GetParent():GetSize()
    self.selected = "none"
    self.selectedName = "???"

    self.baseProduction = 0
    self.basePrice = 0
    self.basePrice2 = 0

    self.production = 0
    self.price = 0

    self.localPlayer = LocalPlayer()
    self.colors = {
        text = GetBaseWarsTheme("bwm_text"),
        darkText = GetBaseWarsTheme("bwm_darkText"),
        contentBackground = GetBaseWarsTheme("bwm_contentBackground"),
        contentBackground2 = GetBaseWarsTheme("bwm_contentBackground2"),
        disabled = GetBaseWarsTheme("button_disabled"),
        green = GetBaseWarsTheme("button_green")
    }

    self:BuildSelector()
end

function PANEL:BuildSelector()
    self:Clear()

    self.BackPanel = self:Add("DPanel")
    self.BackPanel:SetSize(BaseWars.ScreenScale * 400, BaseWars.ScreenScale * 310 + buttonTall * 2 + bigMargin * 5)
    self.BackPanel:SetPos((self.w - self.BackPanel:GetWide()) * .5, (self.h - self.BackPanel:GetTall()) * .5)
    self.BackPanel.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, buttonTall + bigMargin * 2, self.colors.contentBackground)
        BaseWars:DrawRoundedBox(roundness, 0, buttonTall + bigMargin * 3, w, buttonTall + bigMargin * 2, self.colors.contentBackground)
        BaseWars:DrawRoundedBox(roundness, 0, buttonTall * 2 + bigMargin * 6, w, h - buttonTall * 2 - bigMargin * 6, self.colors.contentBackground)
    end

    self.BackPanel.Select = self.BackPanel:Add("BaseWars.Button")
    self.BackPanel.Select:Dock(TOP)
    self.BackPanel.Select:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.BackPanel.Select:SetTall(buttonTall)
    self.BackPanel.Select:SetColor(self.colors.contentBackground, true)
    self.BackPanel.Select.Draw = function(s,w,h)
        draw.SimpleText(self.selected == "none" and self.localPlayer:GetLang("calculator_selectPrinter") or self.selectedName, "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.BackPanel.Select.DoClick = function(s)
        if self.selected == "none" then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:ButtonSound()

        self:BuildPrinter(self.selected)
    end

    self.BackPanel.Search = self.BackPanel:Add("BaseWars.TextEntry")
	self.BackPanel.Search:Dock(TOP)
	self.BackPanel.Search:DockMargin(bigMargin, bigMargin * 2, bigMargin, bigMargin)
	self.BackPanel.Search:SetTall(buttonTall)
    self.BackPanel.Search:SetColor(self.colors.contentBackground2)
    self.BackPanel.Search:SetTextColor(self.colors.text)
    self.BackPanel.Search:SetFont("BaseWars.18")
    self.BackPanel.Search:SetPlaceHolder(self.localPlayer:GetLang("search"))
    self.BackPanel.Search:SetPlaceHolderColor(self.colors.darkText)
    -- self.BackPanel.Search:RequestFocus()
    self.BackPanel.Search.OnChange = function(s, text)
        if not IsValid(self.BackPanel.Scroll) then
            return
        end

        text = string.Trim(text)

        self:BuildPrinterList(text)
    end

    self.BackPanel.Scroll = self.BackPanel:Add("DScrollPanel")
    self.BackPanel.Scroll:Dock(FILL)
    self.BackPanel.Scroll:DockMargin(bigMargin, bigMargin * 2, bigMargin, bigMargin)
    self.BackPanel.Scroll:PaintScrollBar("bwm")

    self:BuildPrinterList()
end

function PANEL:BuildPrinterList(filter)
    filter = string.lower(filter or "")

    self.BackPanel.Scroll:GetCanvas():Clear()

    local printers = {}
    for k, v in pairs(BaseWars:GetBaseWarsEntity()) do
        if not (string.find(v:GetClass(), "bw_printer_*") or v:GetClass() ==  "bw_base_printer") then continue end

        table.insert(printers, {
            id = k,
            class = v:GetClass(),
            price = v:GetPrice()
        })
    end

    for k, v in SortedPairsByMemberValue(printers, "price") do
        if not BaseWars:GetBaseWarsEntity(v.id) then
            return
        end

        local printerEntity = scripted_ents.Get(v.class)
        if not printerEntity then
            continue
        end

        local printerName = printerEntity.PrintName or "What the fuck"
        if filter != "" and not string.find(string.lower(printerName), filter) then
            continue
        end

        local printer = self.BackPanel.Scroll:Add("BaseWars.Button")
        printer:Dock(TOP)
        printer:DockMargin(0, 0, margin, 0)
        printer:SetTall(buttonTall)
        printer:SetColor(self.colors.contentBackground, true)
        printer.Draw = function(s,w,h)
            draw.SimpleText(printerName, "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
        end
        printer.LerpFunc = function(s)
            return s:IsHovered() or self.selected == v.id
        end
        printer.DoClick = function(s)
            if self.selected == v.id then

                return
            end

            s:ButtonSound()

            self.selected = v.id
            self.selectedName = printerName

            self.baseProduction = printerEntity.PrintAmount
            self.basePrice = v.price
            self.basePrice2 = v.price

            self.production = 0
            self.price = 0
        end
    end
end

function PANEL:BuildPrinter(id)
    self:Clear()

    self.TopBar = self:Add("DPanel")
    self.TopBar:Dock(TOP)
    self.TopBar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.TopBar:SetTall(buttonTall + bigMargin * 2)
    self.TopBar.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
        BaseWars:DrawRoundedBox(roundness, h + bigMargin, 0, w - h - bigMargin, h, self.colors.contentBackground)

        draw.SimpleText(self.selectedName, "BaseWars.24", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.TopBar.BackButton = self.TopBar:Add("BaseWars.Button")
    self.TopBar.BackButton:Dock(LEFT)
    self.TopBar.BackButton:DockMargin(bigMargin, bigMargin, 0, bigMargin)
    self.TopBar.BackButton:SetWide(buttonTall)
    self.TopBar.BackButton:SetColor(self.colors.contentBackground, true)
    self.TopBar.BackButton.Draw = function(s,w,h)

        BaseWars:DrawMaterial(icons["back"], h * .5, h * .5, h * .65, h * .65, self.colors.text, 0)
    end
    self.TopBar.BackButton.DoClick = function(s)
        s:ButtonSound()

        self:BuildSelector()
    end

    self.Middle = self:Add("DPanel")
    self.Middle:Dock(FILL)
    self.Middle:DockMargin(bigMargin, 0, bigMargin, 0)
    self.Middle.Paint = nil

    local middleWide = (self.w - bigMargin * 3) * .5
    self.Middle.Left = self.Middle:Add("DPanel")
    self.Middle.Left:Dock(LEFT)
    self.Middle.Left:SetWide(middleWide)
    self.Middle.Left.Paint = nil

    local leftUpgradesWide, leftUpgradesTall = BaseWars.ScreenScale * 350, elementTall * 6 + bigMargin * 3 + margin * 4
    self.Middle.Left.Upgrades = self.Middle.Left:Add("DPanel")
    self.Middle.Left.Upgrades:SetSize(leftUpgradesWide, leftUpgradesTall)
    self.Middle.Left.Upgrades:SetPos((middleWide - leftUpgradesWide) * .5, (self.h - elementTall * 2 - bigMargin * 7 - leftUpgradesTall) * .5)
    self.Middle.Left.Upgrades.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, elementTall + bigMargin, w, h - elementTall - bigMargin, self.colors.contentBackground)
    end

    self.Middle.Left.Upgrades.Title = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.Title:Dock(TOP)
    self.Middle.Left.Upgrades.Title:DockMargin(0, 0, 0, bigMargin)
    self.Middle.Left.Upgrades.Title:SetTall(elementTall)
    self.Middle.Left.Upgrades.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(self.localPlayer:GetLang("calculator_printerUpgrades"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    --[[-------------------------------------------------------------------------
        MARK: Printer Upgrades
    ---------------------------------------------------------------------------]]

    -- AutoPaper
    self.Middle.Left.Upgrades.AutoPaper = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.AutoPaper:Dock(BOTTOM)
    self.Middle.Left.Upgrades.AutoPaper:DockMargin(bigMargin, margin, bigMargin, bigMargin)
    self.Middle.Left.Upgrades.AutoPaper:SetTall(elementTall)
    self.Middle.Left.Upgrades.AutoPaper.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", "autoPaperName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Left.Upgrades.AutoPaper.Toggle = self.Middle.Left.Upgrades.AutoPaper:Add("BaseWars.CheckBox")
    self.Middle.Left.Upgrades.AutoPaper.Toggle:Dock(RIGHT)
    self.Middle.Left.Upgrades.AutoPaper.Toggle:DockMargin(0, margin, margin, margin)
    self.Middle.Left.Upgrades.AutoPaper.Toggle:SetWide(BaseWars.ScreenScale * 80)
    self.Middle.Left.Upgrades.AutoPaper.Toggle:SetState(false, true)

    -- MARK: Paper Capacity
    self.Middle.Left.Upgrades.PaperCapacity = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.PaperCapacity:Dock(BOTTOM)
    self.Middle.Left.Upgrades.PaperCapacity:DockMargin(bigMargin, margin, bigMargin, 0)
    self.Middle.Left.Upgrades.PaperCapacity:SetTall(elementTall)
    self.Middle.Left.Upgrades.PaperCapacity.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", "paperCapacityName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Left.Upgrades.PaperCapacity.Plus = self.Middle.Left.Upgrades.PaperCapacity:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.PaperCapacity.Plus:Dock(RIGHT)
    self.Middle.Left.Upgrades.PaperCapacity.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Left.Upgrades.PaperCapacity.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.PaperCapacity.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.PaperCapacity.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.PaperCapacity.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.PaperCapacity.TextEntry:GetText())

        if num >= BaseWars.Config.PrinterMaxLevel.paperCapacity then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetText(BaseWars.Config.PrinterMaxLevel.paperCapacity)

            return
        end

        self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetText(num + 1)
    end

    self.Middle.Left.Upgrades.PaperCapacity.TextEntry = self.Middle.Left.Upgrades.PaperCapacity:Add("BaseWars.TextEntry")
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:Dock(RIGHT)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetFont("BaseWars.16")
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetPlaceHolder("0 - " .. BaseWars.Config.PrinterMaxLevel.paperCapacity)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetText("0")
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetNumeric(true)
    self.Middle.Left.Upgrades.PaperCapacity.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > BaseWars.Config.PrinterMaxLevel.paperCapacity then
            s:SetText(BaseWars.Config.PrinterMaxLevel.paperCapacity)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Left.Upgrades.PaperCapacity.Minus = self.Middle.Left.Upgrades.PaperCapacity:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.PaperCapacity.Minus:Dock(RIGHT)
    self.Middle.Left.Upgrades.PaperCapacity.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Left.Upgrades.PaperCapacity.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.PaperCapacity.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.PaperCapacity.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.PaperCapacity.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.PaperCapacity.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetText(0)

            return
        end

        self.Middle.Left.Upgrades.PaperCapacity.TextEntry:SetText(num - 1)
    end

    -- MARK: Capacity
    self.Middle.Left.Upgrades.Capacity = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.Capacity:Dock(BOTTOM)
    self.Middle.Left.Upgrades.Capacity:DockMargin(bigMargin, margin, bigMargin, 0)
    self.Middle.Left.Upgrades.Capacity:SetTall(elementTall)
    self.Middle.Left.Upgrades.Capacity.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", "capacityName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Left.Upgrades.Capacity.Plus = self.Middle.Left.Upgrades.Capacity:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Capacity.Plus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Capacity.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Left.Upgrades.Capacity.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Capacity.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Capacity.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Capacity.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Capacity.TextEntry:GetText())

        if num >= BaseWars.Config.PrinterMaxLevel.capacity then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Capacity.TextEntry:SetText(BaseWars.Config.PrinterMaxLevel.capacity)

            return
        end

        self.Middle.Left.Upgrades.Capacity.TextEntry:SetText(num + 1)
    end

    self.Middle.Left.Upgrades.Capacity.TextEntry = self.Middle.Left.Upgrades.Capacity:Add("BaseWars.TextEntry")
    self.Middle.Left.Upgrades.Capacity.TextEntry:Dock(RIGHT)
    self.Middle.Left.Upgrades.Capacity.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetFont("BaseWars.16")
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetPlaceHolder("0 - " .. BaseWars.Config.PrinterMaxLevel.capacity)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetText("0")
    self.Middle.Left.Upgrades.Capacity.TextEntry:SetNumeric(true)
    self.Middle.Left.Upgrades.Capacity.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > BaseWars.Config.PrinterMaxLevel.capacity then
            s:SetText(BaseWars.Config.PrinterMaxLevel.capacity)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Left.Upgrades.Capacity.Minus = self.Middle.Left.Upgrades.Capacity:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Capacity.Minus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Capacity.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Left.Upgrades.Capacity.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Capacity.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Capacity.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Capacity.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Capacity.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Capacity.TextEntry:SetText(0)

            return
        end

        self.Middle.Left.Upgrades.Capacity.TextEntry:SetText(num - 1)
    end

    -- MARK: Value
    self.Middle.Left.Upgrades.Value = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.Value:Dock(BOTTOM)
    self.Middle.Left.Upgrades.Value:DockMargin(bigMargin, margin, bigMargin, 0)
    self.Middle.Left.Upgrades.Value:SetTall(elementTall)
    self.Middle.Left.Upgrades.Value.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", "amountName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Left.Upgrades.Value.Plus = self.Middle.Left.Upgrades.Value:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Value.Plus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Value.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Left.Upgrades.Value.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Value.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Value.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Value.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Value.TextEntry:GetText())

        if num >= BaseWars.Config.PrinterMaxLevel.amount then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Value.TextEntry:SetText(BaseWars.Config.PrinterMaxLevel.amount)

            return
        end

        self.Middle.Left.Upgrades.Value.TextEntry:SetText(num + 1)
    end

    self.Middle.Left.Upgrades.Value.TextEntry = self.Middle.Left.Upgrades.Value:Add("BaseWars.TextEntry")
    self.Middle.Left.Upgrades.Value.TextEntry:Dock(RIGHT)
    self.Middle.Left.Upgrades.Value.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Left.Upgrades.Value.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Left.Upgrades.Value.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Left.Upgrades.Value.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Left.Upgrades.Value.TextEntry:SetFont("BaseWars.16")
    self.Middle.Left.Upgrades.Value.TextEntry:SetPlaceHolder("0 - " .. BaseWars.Config.PrinterMaxLevel.amount)
    self.Middle.Left.Upgrades.Value.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Left.Upgrades.Value.TextEntry:SetText("0")
    self.Middle.Left.Upgrades.Value.TextEntry:SetNumeric(true)
    self.Middle.Left.Upgrades.Value.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > BaseWars.Config.PrinterMaxLevel.amount then
            s:SetText(BaseWars.Config.PrinterMaxLevel.amount)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Left.Upgrades.Value.Minus = self.Middle.Left.Upgrades.Value:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Value.Minus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Value.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Left.Upgrades.Value.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Value.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Value.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Value.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Value.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Value.TextEntry:SetText(0)

            return
        end

        self.Middle.Left.Upgrades.Value.TextEntry:SetText(num - 1)
    end

    -- MARK: Speed
    self.Middle.Left.Upgrades.Speed = self.Middle.Left.Upgrades:Add("DPanel")
    self.Middle.Left.Upgrades.Speed:Dock(BOTTOM)
    self.Middle.Left.Upgrades.Speed:DockMargin(bigMargin, margin, bigMargin, 0)
    self.Middle.Left.Upgrades.Speed:SetTall(elementTall)
    self.Middle.Left.Upgrades.Speed.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("printer_upgrades", "intervalName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Left.Upgrades.Speed.Plus = self.Middle.Left.Upgrades.Speed:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Speed.Plus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Speed.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Left.Upgrades.Speed.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Speed.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Speed.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Speed.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Speed.TextEntry:GetText())

        if num >= BaseWars.Config.PrinterMaxLevel.interval then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Speed.TextEntry:SetText(BaseWars.Config.PrinterMaxLevel.interval)

            return
        end

        self.Middle.Left.Upgrades.Speed.TextEntry:SetText(num + 1)
    end

    self.Middle.Left.Upgrades.Speed.TextEntry = self.Middle.Left.Upgrades.Speed:Add("BaseWars.TextEntry")
    self.Middle.Left.Upgrades.Speed.TextEntry:Dock(RIGHT)
    self.Middle.Left.Upgrades.Speed.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetFont("BaseWars.16")
    self.Middle.Left.Upgrades.Speed.TextEntry:SetPlaceHolder("0 - " .. BaseWars.Config.PrinterMaxLevel.interval)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Left.Upgrades.Speed.TextEntry:SetText("0")
    self.Middle.Left.Upgrades.Speed.TextEntry:SetNumeric(true)
    self.Middle.Left.Upgrades.Speed.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > BaseWars.Config.PrinterMaxLevel.interval then
            s:SetText(BaseWars.Config.PrinterMaxLevel.interval)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Left.Upgrades.Speed.Minus = self.Middle.Left.Upgrades.Speed:Add("BaseWars.Button")
    self.Middle.Left.Upgrades.Speed.Minus:Dock(RIGHT)
    self.Middle.Left.Upgrades.Speed.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Left.Upgrades.Speed.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Left.Upgrades.Speed.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Left.Upgrades.Speed.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Left.Upgrades.Speed.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Left.Upgrades.Speed.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Left.Upgrades.Speed.TextEntry:SetText(0)

            return
        end

        self.Middle.Left.Upgrades.Speed.TextEntry:SetText(num - 1)
    end

    --[[-------------------------------------------------------------------------
        MARK: Printer Upgrades
    ---------------------------------------------------------------------------]]

    self.Middle.Right = self.Middle:Add("DPanel")
    self.Middle.Right:Dock(RIGHT)
    self.Middle.Right:SetWide(middleWide)
    self.Middle.Right.Paint = nil

    local leftUpgradesWide, leftUpgradesTall = BaseWars.ScreenScale * 350, elementTall * 3 + bigMargin * 3 + margin
    self.Middle.Right.Upgrades = self.Middle.Right:Add("DPanel")
    self.Middle.Right.Upgrades:SetSize(leftUpgradesWide, leftUpgradesTall)
    self.Middle.Right.Upgrades:SetPos((middleWide - leftUpgradesWide) * .5, (self.h - elementTall * 2 - bigMargin * 7 - leftUpgradesTall) * .5)
    self.Middle.Right.Upgrades.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, elementTall + bigMargin, w, h - elementTall - bigMargin, self.colors.contentBackground)
    end

    self.Middle.Right.Upgrades.Title = self.Middle.Right.Upgrades:Add("DPanel")
    self.Middle.Right.Upgrades.Title:Dock(TOP)
    self.Middle.Right.Upgrades.Title:DockMargin(0, 0, 0, bigMargin)
    self.Middle.Right.Upgrades.Title:SetTall(elementTall)
    self.Middle.Right.Upgrades.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(self.localPlayer:GetLang("calculator_prestigeUpgrades"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    --[[-------------------------------------------------------------------------
        MARK: Prestige Upgrades
    ---------------------------------------------------------------------------]]
    -- MARK: Speed
    self.Middle.Right.Upgrades.Speed = self.Middle.Right.Upgrades:Add("DPanel")
    self.Middle.Right.Upgrades.Speed:Dock(BOTTOM)
    self.Middle.Right.Upgrades.Speed:DockMargin(bigMargin, margin, bigMargin, bigMargin)
    self.Middle.Right.Upgrades.Speed:SetTall(elementTall)
    self.Middle.Right.Upgrades.Speed.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("prestige_perks", "printerSpeedName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Right.Upgrades.Speed.Plus = self.Middle.Right.Upgrades.Speed:Add("BaseWars.Button")
    self.Middle.Right.Upgrades.Speed.Plus:Dock(RIGHT)
    self.Middle.Right.Upgrades.Speed.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Right.Upgrades.Speed.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Right.Upgrades.Speed.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Right.Upgrades.Speed.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Right.Upgrades.Speed.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Right.Upgrades.Speed.TextEntry:GetText())

        if num >= 4 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Right.Upgrades.Speed.TextEntry:SetText(4)

            return
        end

        self.Middle.Right.Upgrades.Speed.TextEntry:SetText(num + 1)
    end

    self.Middle.Right.Upgrades.Speed.TextEntry = self.Middle.Right.Upgrades.Speed:Add("BaseWars.TextEntry")
    self.Middle.Right.Upgrades.Speed.TextEntry:Dock(RIGHT)
    self.Middle.Right.Upgrades.Speed.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetFont("BaseWars.16")
    self.Middle.Right.Upgrades.Speed.TextEntry:SetPlaceHolder("0 - " .. 4)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Right.Upgrades.Speed.TextEntry:SetText("0")
    self.Middle.Right.Upgrades.Speed.TextEntry:SetNumeric(true)
    self.Middle.Right.Upgrades.Speed.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > 4 then
            s:SetText(4)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Right.Upgrades.Speed.Minus = self.Middle.Right.Upgrades.Speed:Add("BaseWars.Button")
    self.Middle.Right.Upgrades.Speed.Minus:Dock(RIGHT)
    self.Middle.Right.Upgrades.Speed.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Right.Upgrades.Speed.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Right.Upgrades.Speed.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Right.Upgrades.Speed.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Right.Upgrades.Speed.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Right.Upgrades.Speed.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Right.Upgrades.Speed.TextEntry:SetText(0)

            return
        end

        self.Middle.Right.Upgrades.Speed.TextEntry:SetText(num - 1)
    end

    -- MARK: Update Cost
    self.Middle.Right.Upgrades.UpgradeCost = self.Middle.Right.Upgrades:Add("DPanel")
    self.Middle.Right.Upgrades.UpgradeCost:Dock(BOTTOM)
    self.Middle.Right.Upgrades.UpgradeCost:DockMargin(bigMargin, margin, bigMargin, 0)
    self.Middle.Right.Upgrades.UpgradeCost:SetTall(elementTall)
    self.Middle.Right.Upgrades.UpgradeCost.Paint = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("prestige_perks", "printerUpgradeCostName"), "BaseWars.20", h * .25, h * .5, self.colors.text, 0, 1)
    end

    self.Middle.Right.Upgrades.UpgradeCost.Plus = self.Middle.Right.Upgrades.UpgradeCost:Add("BaseWars.Button")
    self.Middle.Right.Upgrades.UpgradeCost.Plus:Dock(RIGHT)
    self.Middle.Right.Upgrades.UpgradeCost.Plus:DockMargin(0, margin, margin, margin)
    self.Middle.Right.Upgrades.UpgradeCost.Plus:SetWide(elementTall - bigMargin)
    self.Middle.Right.Upgrades.UpgradeCost.Plus:SetColor(self.colors.contentBackground, true)
    self.Middle.Right.Upgrades.UpgradeCost.Plus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["plus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Right.Upgrades.UpgradeCost.Plus.DoClick = function(s)
        local num = tonumber(self.Middle.Right.Upgrades.UpgradeCost.TextEntry:GetText())

        if num >= 5 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetText(5)

            return
        end

        self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetText(num + 1)
    end

    self.Middle.Right.Upgrades.UpgradeCost.TextEntry = self.Middle.Right.Upgrades.UpgradeCost:Add("BaseWars.TextEntry")
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:Dock(RIGHT)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:DockMargin(margin, margin, margin, margin)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetWide(elementTall * 1.5 - bigMargin)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetColor(self.colors.contentBackground2)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetTextColor(self.colors.text)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetFont("BaseWars.16")
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetPlaceHolder("0 - " .. 5)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetPlaceHolderColor(self.colors.darkText)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetText("0")
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetNumeric(true)
    self.Middle.Right.Upgrades.UpgradeCost.TextEntry.OnChange = function(s, text)
        local num = tonumber(text)

        if not num then
            s:SetText(0)

            return
        end

        if num < 0 then
            s:SetText(0)
        end

        if num > 5 then
            s:SetText(5)
        end

        if string.find(text, "%.") then
            s:SetText(math.floor(num))
        end
    end

    self.Middle.Right.Upgrades.UpgradeCost.Minus = self.Middle.Right.Upgrades.UpgradeCost:Add("BaseWars.Button")
    self.Middle.Right.Upgrades.UpgradeCost.Minus:Dock(RIGHT)
    self.Middle.Right.Upgrades.UpgradeCost.Minus:DockMargin(0, margin, 0, margin)
    self.Middle.Right.Upgrades.UpgradeCost.Minus:SetWide(elementTall - bigMargin)
    self.Middle.Right.Upgrades.UpgradeCost.Minus:SetColor(self.colors.contentBackground, true)
    self.Middle.Right.Upgrades.UpgradeCost.Minus.Draw = function(s,w,h)
        BaseWars:DrawMaterial(icons["minus"], h * .5, h * .5, iconSize, iconSize, self.colors.text, 0)
    end
    self.Middle.Right.Upgrades.UpgradeCost.Minus.DoClick = function(s)
        local num = tonumber(self.Middle.Right.Upgrades.UpgradeCost.TextEntry:GetText())

        if num <= 0 then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        if input.IsKeyDown(KEY_LSHIFT) then
            self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetText(0)

            return
        end

        self.Middle.Right.Upgrades.UpgradeCost.TextEntry:SetText(num - 1)
    end
    --[[-------------------------------------------------------------------------
        MARK: Prestige Upgrades
    ---------------------------------------------------------------------------]]

    local wide = (self.w - bigMargin * 3) * .4
    self.BottomBar = self:Add("DPanel")
    self.BottomBar:Dock(BOTTOM)
    self.BottomBar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.BottomBar:SetTall(buttonTall + bigMargin * 2)
    self.BottomBar.Paint = function(s,w,h)

        BaseWars:DrawRoundedBox(roundness, 0, 0, wide, h, self.colors.contentBackground)
        draw.SimpleText(Format(self.localPlayer:GetLang("calculator_priceToUpgrade"), BaseWars:FormatMoney(self.price)), "BaseWars.20", wide * .5, h * .5, self.colors.text, 1, 1)

        BaseWars:DrawRoundedBox(roundness, wide + bigMargin, 0, w - wide * 2 - bigMargin * 2, h, self.colors.contentBackground)

        BaseWars:DrawRoundedBox(roundness, w - wide, 0, wide, h, self.colors.contentBackground)
        draw.SimpleText(Format(self.localPlayer:GetLang("calculator_printerProduction"), BaseWars:FormatMoney(self.production)), "BaseWars.20", w - wide * .5, h * .5, self.colors.text, 1, 1)
    end

    self.BottomBar.Calculate = self.BottomBar:Add("BaseWars.Button")
    self.BottomBar.Calculate:SetSize((self.w - bigMargin * 2) - wide * 2 - bigMargin * 4, buttonTall)
    self.BottomBar.Calculate:SetPos(wide + bigMargin * 2, bigMargin)
    self.BottomBar.Calculate:SetColor(self.colors.contentBackground, true)
    self.BottomBar.Calculate.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("calculator_calculate"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.BottomBar.Calculate.DoClick = function(s)
        s:ButtonSound()

        local speedLevel = tonumber(self.Middle.Left.Upgrades.Speed.TextEntry:GetText())
        local valueLevel = tonumber(self.Middle.Left.Upgrades.Value.TextEntry:GetText())
        local capacityLevel = tonumber(self.Middle.Left.Upgrades.Capacity.TextEntry:GetText())
        local paperCapacityLevel = tonumber(self.Middle.Left.Upgrades.PaperCapacity.TextEntry:GetText())
        local autoPaper = self.Middle.Left.Upgrades.AutoPaper.Toggle:GetState()
        local prestigeSpeedLevel = tonumber(self.Middle.Right.Upgrades.Speed.TextEntry:GetText())
        local upgradeCostLevel = tonumber(self.Middle.Right.Upgrades.UpgradeCost.TextEntry:GetText())

        self:Calculate(speedLevel, valueLevel, capacityLevel, paperCapacityLevel, autoPaper, prestigeSpeedLevel, upgradeCostLevel)
        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
    end
end

function PANEL:Calculate(speedLevel, valueLevel, capacityLevel, paperCapacityLevel, autoPaper, prestigeSpeedLevel, upgradeCostLevel)
    self.production = 0
    self.price = 0

    if upgradeCostLevel > 0 then
        self.basePrice = self.basePrice2 * (1 - upgradeCostLevel * .05)
    end

    if speedLevel > 0 then
        for i = 1, speedLevel do
            self.price = self.price + self.basePrice * i
        end
    end

    if valueLevel > 0 then
        for i = 1, valueLevel do
            self.price = self.price + self.basePrice * i
        end

        self.production = self.baseProduction * (valueLevel + 1) ^ 1.6
    end

    if capacityLevel > 0 then
        for i = 1, capacityLevel do
            self.price = self.price + self.basePrice * i
        end
    end

    if paperCapacityLevel > 0 then
        for i = 1, paperCapacityLevel do
            self.price = self.price + self.basePrice * i
        end
    end

    if autoPaper then
        self.price = self.price + self.basePrice * 5
    end

    local speed = speedLevel + prestigeSpeedLevel
    if speed > 0 then
        self.production = self.production / (1 - speed * .05)
    end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Calculator", PANEL, "DPanel")