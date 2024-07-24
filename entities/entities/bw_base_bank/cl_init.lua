include("shared.lua")

BaseWars:CreateFont("BaseWars.Bank.Name", 30, 500)
BaseWars:CreateFont("BaseWars.Bank.Info", 18, 500)
BaseWars:CreateFont("BaseWars.Bank.Bottom", 22, 500)

function ENT:Initialize()
    self.upgrades = 30
    self.moneyBar = 0
end

local upgIcon = Material("basewars_materials/printer/upgrade.png", "smooth")

function ENT:Draw()
    self:DrawModel()
    local ply = LocalPlayer()

    if ply:GetPos():Distance(self:GetPos()) > BaseWars.Config.EntityRenderDistance then
        return
    end

    local pos = self:GetPos()
    local angle = self:GetAngles()

    pos = pos + angle:Up() * 10.7
    pos = pos + angle:Forward() * -16.35
    pos = pos + angle:Right() * 15.16

    angle:RotateAroundAxis(angle:Up(), 90)

    cam.Start3D2D(pos, angle, .1)
        local money = self:GetMoney()
        local capacity = self:GetCapacity()

        local w, h = 307, 307
        local textColor = money >= capacity and HSVToColor(0, math.abs(math.sin(CurTime() * 2)), 1) or self.TextColor
        local lerpFrac = FrameTime() * 15

        -- Printer Name
        BaseWars:DrawRoundedBox(3, 5, 5, w - 5 * 2, 36, self.Color)
        draw.SimpleText(self.PrintName, "BaseWars.Bank.Name", w * .5, 23, textColor, 1, 1)

        -- Lerps
        self.upgrades = Lerp(lerpFrac, self.upgrades, self:OnUpgrade(ply) and 255 or 30)

        -- Printer Infos
        BaseWars:DrawRoundedBox(3, 5, 46, w - 10, h - 116, self.Color)

        if self:GetPrinterCount() == 0 then
            draw.SimpleText(ply:GetLang("printer_noPrinterConnected"), "BaseWars.Printer.Info", w * .5, 141, textColor, 1, 1)
        else
            local printAmont = self:GetPrinting()
            local time = (capacity - money) / printAmont
            time = time == 0 and ply:GetLang("printer_bank_full") or printAmont == 0 and ply:GetLang("printer_printOutOfPaper") or ply:GetLang("printer_time"):format(BaseWars:FormatTime2(time, ply))

            -- Lerp
            self.moneyBar = Lerp(lerpFrac, self.moneyBar, math.Clamp(money / capacity, 0, 1))

            -- Bank Infos
            BaseWars:DrawRoundedBox(2, 10, 51, w - 20, 20, self.SubColor)
            BaseWars:DrawRoundedBox(2, 10, 51, (w - 20) * self.moneyBar, 20, textColor)
            draw.SimpleText(BaseWars:FormatMoney(money) .. " / " .. BaseWars:FormatMoney(capacity), "BaseWars.Printer.Info", w * .5, 76, textColor, 1)
            draw.SimpleText("+ " .. BaseWars:FormatMoney(printAmont) .. "/s", "BaseWars.Printer.Info", w * .5, 151, textColor, 1, TEXT_ALIGN_BOTTOM)
            draw.SimpleText(time, "BaseWars.Printer.Info", w * .5, 151, textColor, 1)

            draw.SimpleText(ply:GetLang("printer_xp"):format(BaseWars:FormatNumber(BaseWars:CalculatePlayerXP(self:CPPIGetOwner(), BaseWars:CalculateXPFromMultiplier(money) * BaseWars.Config.XPMult))), "BaseWars.Printer.Info", w * .5, h - 76, textColor, 1, TEXT_ALIGN_BOTTOM)
        end

        -- Upgrade button
        local textW = BaseWars:GetTextSize(ply:GetLang("printer_upgrade"), "BaseWars.Bank.Bottom")

        BaseWars:DrawRoundedBox(3, 5, h - 65, w - 10, 60, self.Color)
        BaseWars:DrawMaterial(upgIcon, (w - textW) * .5 - 25, 255, 30, 30, ColorAlpha(textColor, self.upgrades))
        draw.SimpleText(ply:GetLang("printer_upgrade"), "BaseWars.Bank.Bottom", (w - textW) * .5 + 15, h - 48, ColorAlpha(textColor, self.upgrades), 0)
    cam.End3D2D()
end

net.Receive("BaseWars:Bank:OpenUpgradeMenu", function()
    local bank = net.ReadEntity()

    if IsValid(BankUpgradePanel) then
        BankUpgradePanel:Remove()
    end

    BankUpgradePanel = vgui.Create("BaseWars.VGUI.BankUpgrade")
    BankUpgradePanel:SetBank(bank)
end)