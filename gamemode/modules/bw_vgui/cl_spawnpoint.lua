local closeIcon = Material("basewars_materials/close.png", "smooth")
local buttonSize = BaseWars.ScreenScale * 36
local margin = BaseWars.ScreenScale * 5
local bigMargin = BaseWars.ScreenScale * 10

local NAME  = {}
function NAME:Init()
    self:SetSize(BaseWars.ScreenScale * 600, BaseWars.ScreenScale * 40 + buttonSize * 2 + bigMargin * 6)
    self:Center()
    self:MakePopup()
    local ply = LocalPlayer()

    self.startTime = SysTime()

    self.Topbar = self:Add("DPanel")
    self.Topbar:Dock(TOP)
    self.Topbar:SetTall(BaseWars.ScreenScale * 40)
    self.Topbar.Paint = function(s,w,h)
        BaseWars:DrawRoundedBoxEx(6, 0, 0, w, h, BaseWars:GetTheme("spawnpoint_titleBar"), true, true)
        draw.SimpleText("- " .. ply:GetLang("spawnpoint_nametitle") .. " -", "BaseWars.22", w * .5, h * .5, BaseWars:GetTheme("spawnpoint_text"), 1, 1)
    end

    self.Topbar.Close = self.Topbar:Add("DButton")
    self.Topbar.Close:SetText("")
    self.Topbar.Close:Dock(RIGHT)
    self.Topbar.Close:SetWide(self.Topbar:GetTall())
    self.Topbar.Close.color = BaseWars:GetTheme("spawnpoint_darkText")
    self.Topbar.Close.Paint = function(s,w,h)
        s.color = BaseWars:LerpColor(FrameTime() * 12, s.color, s:IsHovered() and BaseWars:GetTheme("spawnpoint_text") or BaseWars:GetTheme("spawnpoint_darkText"))

        BaseWars:DrawMaterial(closeIcon, margin * 2, margin * 2, w - margin * 4, h - margin * 4, s.color)
    end
    self.Topbar.Close.DoClick = function(s)
        surface.PlaySound("bw_button.wav")
        self:Remove()
    end

    self.Name = self:Add("BaseWars.TextEntry")
    self.Name:Dock(FILL)
    self.Name:DockMargin(bigMargin, bigMargin, bigMargin, 0)
    self.Name:SetTall(buttonSize)
    self.Name:SetColor(BaseWars:GetTheme("spawnpoint_contentBackground"))
    self.Name:SetTextColor(BaseWars:GetTheme("spawnpoint_text"))
    self.Name:SetFont("BaseWars.18")
    self.Name:SetPlaceHolder(LocalPlayer():GetLang("spawnpoint_name"))
    self.Name:SetPlaceHolderColor(BaseWars:GetTheme("spawnpoint_darkText"))
    self.Name:RequestFocus()
    self.Name.OnEnter = function(s)
        local name = string.Trim(s:GetText())

        if string.len(name) < 3 or string.len(name) > 32 then return end

        if IsValid(self._entity) then
            net.Start("BaseWars:SetSpawnpointName")
                net.WriteString(name)
                net.WriteEntity(self._entity)
            net.SendToServer()
        end

        self:Remove()
    end

    self.Button = self:Add("DPanel")
    self.Button:Dock(BOTTOM)
    self.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Button:SetTall(buttonSize + bigMargin * 2)
    self.Button.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("spawnpoint_contentBackground"))
    end

    self.Button.SetName = self.Button:Add("OLD.BaseWars.Button")
    self.Button.SetName:Dock(TOP)
    self.Button.SetName:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Button.SetName:SetTall(buttonSize)
    self.Button.SetName:DrawSide(true, true)
    self.Button.SetName.Draw = function(s,w,h)
        local name = string.Trim(self.Name:GetText())
        local text = LocalPlayer():GetLang("spawnpoint_setname"):format(name)

        if string.len(name) < 3 then
            text = ply:GetLang("spawnpoint_tooshort")
        elseif string.len(name) > 32 then
            text = ply:GetLang("spawnpoint_toolong")
        end

        draw.SimpleText(text, "BaseWars.18", w * .5, h * .5, BaseWars:GetTheme("spawnpoint_text"), 1, 1)
    end
    self.Button.SetName.DoClick = function(s)
        local name = string.Trim(self.Name:GetText())

        if string.len(name) < 3 or string.len(name) > 32 then return end

        s:ButtonSound()

        if IsValid(self._entity) then
            net.Start("BaseWars:SetSpawnpointName")
                net.WriteString(name)
                net.WriteEntity(self._entity)
            net.SendToServer()
        end

        self:Remove()
    end

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function NAME:SetSpawnpoint(ent)
    self._entity = ent

    self.Name:SetText(self._entity:GetCName())
end

function NAME:Paint(w,h)
end

vgui.Register("BaseWars.VGUI.Spawnpoint.Name", NAME, "EditablePanel")

------------------------------------------------------------------------------------------------

local SPAWN  = {}
function SPAWN:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.startTime = SysTime()

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function SPAWN:CreateFrame()
    local buttonTall = BaseWars.ScreenScale * 40
    local tall = math.Clamp(self:GetSpawnpoints(true), 1, 14) * (buttonTall + margin) - margin

    self.Frame = self:Add("DScrollPanel")
    self.Frame:SetSize(ScreenWitdh() * .3, tall)
    self.Frame:Center()
    self.Frame:GetVBar():SetWide(0)
    self.Frame.Paint = nil

    for k, v in ipairs(self:GetSpawnpoints()) do
        local spawnpoint = self.Frame:Add("DButton")
        spawnpoint:SetText("")
        spawnpoint:Dock(TOP)
        spawnpoint:SetTall(buttonTall)
        spawnpoint:DockMargin(0, 0, 0, margin)
        spawnpoint.lerp = 0
        spawnpoint.Paint = function(s,w,h)
            local color = BaseWars:GetTheme("gen_accent")
            s.lerp = Lerp(FrameTime() * 16, s.lerp, s:IsHovered() and 1 or 0)

            BaseWars:DrawRoundedBox(4, 0, 0, w, h, ColorAlpha(color, color.a * s.lerp))
            draw.SimpleText(v:GetCName(), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("spawnpoint_text"), 1, 1)
        end
        spawnpoint.DoClick = function(s)
            surface.PlaySound("bw_button.wav")

            net.Start("BaseWars:OpenSpawnpointMenu")
                net.WriteEntity(v)
            net.SendToServer()

            self:Remove()
        end
        spawnpoint.Think = function(s)
            if not IsValid(v) then
                s:Remove()
            end
        end
    end

    self.SpawnAtWorld = self:Add("DButton")
    self.SpawnAtWorld:SetText("")
    self.SpawnAtWorld:SetSize(ScreenWitdh() * .3, BaseWars.ScreenScale * 40)
    self.SpawnAtWorld:SetPos((self:GetWide() - self.SpawnAtWorld:GetWide()) * .5, self:GetTall() - BaseWars.ScreenScale * 90)
    self.SpawnAtWorld.lerp = 0
    self.SpawnAtWorld.Paint = function(s,w,h)
        local color = BaseWars:GetTheme("spawnpoint_spawn")
        s.lerp = Lerp(FrameTime() * 16, s.lerp, s:IsHovered() and 1 or 0)

        BaseWars:DrawRoundedBox(4, 0, 0, w, h, ColorAlpha(color, color.a * s.lerp))
        draw.SimpleText(LocalPlayer():GetLang("spawnpoint_spawnatworld"), "BaseWars.20", w * .5, h * .5, BaseWars:GetTheme("spawnpoint_text"), 1, 1)
    end
    self.SpawnAtWorld.DoClick = function(s)
        surface.PlaySound("bw_button.wav")

        net.Start("BaseWars:OpenSpawnpointMenu")
        net.SendToServer()

        self:Remove()
    end
    self.SpawnAtWorld.DoRightClick = function(s)
        if BaseWars:IsAdmin(LocalPlayer(), true) then
            RunConsoleCommand("say", "/respawn " .. LocalPlayer():SteamID64())
            self:Remove()
        end
    end
end

function SPAWN:SetSpawnpoints(tbl)
    self.spawnPoints = tbl

    self:CreateFrame()
end

function SPAWN:GetSpawnpoints(count)
    if count then
        return table.Count(self.spawnPoints)
    end

    return self.spawnPoints
end

function SPAWN:Think()
    if LocalPlayer():Alive() then
        self:Remove()
    end
end

function SPAWN:Paint(w,h)
    draw.SimpleText("- " .. LocalPlayer():GetLang("spawnpoint_chose") .. " -", "BaseWars.36", w * .5, BaseWars.ScreenScale * 40, BaseWars:GetTheme("spawnpoint_text"), 1, 1)
end

vgui.Register("BaseWars.VGUI.Spawnpoint.Spawn", SPAWN, "EditablePanel")

net.Receive("BaseWars:OpenSpawnpointMenu", function(len)
    basewarsRespawnMenu = vgui.Create("BaseWars.VGUI.Spawnpoint.Spawn")
    basewarsRespawnMenu:SetSpawnpoints(net.ReadTable())
end)

function BaseWars:IsRespawnMenuOpen()
    return IsValid(basewarsRespawnMenu)
end

function BaseWars:GetRespawMenu()
    return basewarsRespawnMenu
end