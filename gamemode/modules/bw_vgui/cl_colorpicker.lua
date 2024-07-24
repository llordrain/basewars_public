local textEntrySize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
    self._color = Color(math.Rand(0, 255), math.Rand(0, 255), math.Rand(0, 255))

    self.HSV = self:Add("DColorCube")
    self.HSV:Dock(FILL)
    self.HSV.OnUserChanged = function(ctrl, color)
        self:UpdateColor(color)
    end

    self.RGBEntry = self:Add("DPanel")
    self.RGBEntry:Dock(RIGHT)
    self.RGBEntry:DockMargin(bigMargin, 0, 0, 0)
    self.RGBEntry:SetWide(BaseWars.ScreenScale * 80)
    self.RGBEntry.Paint = nil

    self.R = self.RGBEntry:Add("BaseWars.TextEntry")
    self.R:Dock(TOP)
    self.R:DockMargin(0, 0, 0, margin)
    self.R:SetTall(textEntrySize)
    self.R:SetColor(BaseWars:GetTheme("bwm_background"))
    self.R:SetTextColor(BaseWars:GetTheme("colorpicker_r"))
    self.R:SetFont("BaseWars.18")
    self.R:SetPlaceHolder("R")
    self.R:SetPlaceHolderColor(BaseWars:GetTheme("bwm_darkText"))
    self.R:SetNumeric(true)
    self.R.OnChange = function(s, text)
        local r = tonumber(text) or 0

        if r < 0 or r > 255 then
            s:SetText(math.Clamp(r, 0, 255))
        end

        self:UpdateColor(Color(r, self._color.g, self._color.b), true)
    end

    self.G = self.RGBEntry:Add("BaseWars.TextEntry")
    self.G:Dock(TOP)
    self.G:DockMargin(0, 0, 0, margin)
    self.G:SetTall(textEntrySize)
    self.G:SetColor(BaseWars:GetTheme("bwm_background"))
    self.G:SetTextColor(BaseWars:GetTheme("colorpicker_g"))
    self.G:SetFont("BaseWars.18")
    self.G:SetPlaceHolder("G")
    self.G:SetPlaceHolderColor(BaseWars:GetTheme("bwm_darkText"))
    self.G:SetNumeric(true)
    self.G.OnChange = function(s, text)
        local g = tonumber(text) or 0

        if g < 0 or g > 255 then
            s:SetText(math.Clamp(g, 0, 255))
        end

        self:UpdateColor(Color(self._color.r, g, self._color.b), true)
    end

    self.B = self.RGBEntry:Add("BaseWars.TextEntry")
    self.B:Dock(TOP)
    self.B:SetTall(textEntrySize)
    self.B:SetColor(BaseWars:GetTheme("bwm_background"))
    self.B:SetTextColor(BaseWars:GetTheme("colorpicker_b"))
    self.B:SetFont("BaseWars.18")
    self.B:SetPlaceHolder("B")
    self.B:SetPlaceHolderColor(BaseWars:GetTheme("bwm_darkText"))
    self.B:SetNumeric(true)
    self.B.OnChange = function(s, text)
        local b = tonumber(text) or 0

        if b < 0 or b > 255 then
            s:SetText(math.Clamp(b, 0, 255))
        end

        self:UpdateColor(Color(self._color.r, self._color.g, b), true)
    end

    self.RGB = self:Add("DRGBPicker")
    self.RGB:Dock(RIGHT)
    self.RGB:DockMargin(bigMargin, 0, 0, 0)
    self.RGB:SetWide(BaseWars.ScreenScale * 30)
    self.RGB.OnChange = function(ctrl, color)
        self.HSV:SetBaseRGB(color)
        self.HSV:TranslateValues()

        self:UpdateColor(self._color)
    end

    self:UpdateColor(self._color)
end

function PANEL:UpdateColor(color, fromTextEntry)
    self._color = Color(color.r, color.g, color.b)

    self.HSV:SetBaseRGB(self._color)

    if not fromTextEntry then
        self.R:SetText(math.floor(self._color.r))
        self.G:SetText(math.floor(self._color.g))
        self.B:SetText(math.floor(self._color.b))
    end
end

function PANEL:GetColor()
    return Color(self._color.r, self._color.g, self._color.b)
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.ColorPicker", PANEL, "DPanel")