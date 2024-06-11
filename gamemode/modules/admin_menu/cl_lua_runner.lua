local buttonTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.localPlayer = LocalPlayer()
    self.colors = {
        text = GetBaseWarsTheme("am_text"),
        contentBackground = GetBaseWarsTheme("am_contentBackground")
    }


    self.Lua = self:Add("BaseWars.TextEntry")
    self.Lua:Dock(FILL)
    self.Lua:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Lua:SetColor(self.colors.contentBackground)
    self.Lua:SetTextColor(self.colors.text)
    self.Lua:SetFont("BaseWars.18")
    self.Lua:SetPlaceHolder("")
    self.Lua:SetMultiline(true)

    self.Bottom = self:Add("DPanel")
    self.Bottom:Dock(BOTTOM)
    self.Bottom:DockMargin(bigMargin, 0, bigMargin, bigMargin)
    self.Bottom:SetTall(buttonTall + bigMargin * 2)
    self.Bottom.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
    end

    self.Bottom.Execute = self.Bottom:Add("BaseWars.Button")
    self.Bottom.Execute:Dock(FILL)
    self.Bottom.Execute:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Bottom.Execute:SetColor(self.colors.contentBackground, true)
    self.Bottom.Execute.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("luarunner_execute"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.Bottom.Execute.DoClick = function(s)
        s:ButtonSound()

        local data = util.Compress(util.TableToJSON({
            lua = self.Lua:GetText()
        }))

        net.Start("BaseWars:LuaRunner")
            net.WriteData(data, #data)
        net.SendToServer()
    end
end

function PANEL:Paint()
end

vgui.Register("BaseWars.AdminMenu.LuaRunner", PANEL, "DPanel")

net.Receive("BaseWars:LuaRunner", function(len)
    local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))["error"]
    local localPlayer = LocalPlayer()

    local textW, _ = BaseWars:GetTextSize(data, "BaseWars.20")

    errorPopup = vgui.Create("BaseWars.Popup")
    errorPopup:SetTitle("Lua Error")
    errorPopup:SetText(data)
    errorPopup.Frame:SetWide(textW + bigMargin * 6)
    errorPopup:SetConfirm(localPlayer:GetLang("close"), function()
        errorPopup:Remove()
    end)
    errorPopup:SetCancel(localPlayer:GetLang("close"), function()
        errorPopup:Remove()
    end)
end)