local dashboardLinks = {}
function BaseWars:AddDashboardLink(name, icon, url)
    table.insert(dashboardLinks, {
        name = name,
        icon = Material(icon, "smooth"),
        url = url
    })
end

function BaseWars:GetDsahboardLinks()
    return dashboardLinks
end

local icons = {
    ["loading"] = {
        icon = Material("basewars_materials/loading.png", "smooth"),
        size = BaseWars.ScreenScale * 150
    },
    ["copy"] = {
        icon = Material("basewars_materials/copy.png", "smooth"),
        size = BaseWars.ScreenScale * 20
    },
    ["execute_command"] = {
        icon = Material("basewars_materials/execute_command.png", "smooth"),
        size = BaseWars.ScreenScale * 20
    }
}
local bounties
local thisPanel

local commandTall = BaseWars.ScreenScale * 50
local elementTall = BaseWars.ScreenScale * 40
local rowTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin =  BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.w, self.h = self:GetParent():GetSize()
    self.localPlayer = LocalPlayer()
    self.colors = {
        accent = BaseWars:GetTheme("gen_accent"),
        text = BaseWars:GetTheme("bwm_text"),
        darkText = BaseWars:GetTheme("bwm_darkText"),
        contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
        contentBackground2 = BaseWars:GetTheme("bwm_contentBackground2")
    }

    thisPanel = self

    local commandPrefix = BaseWars.Config.ChatCommandPrefix
    local showAllcommands = self.localPlayer:GetBaseWarsConfig("showAllCommands")
    local halfWide = (self.w - bigMargin * 3) * .5
    local halfTall = (self.h - bigMargin * 3) * .5

    self.Left = self:Add("DPanel")
    self.Left:Dock(LEFT)
    self.Left:DockMargin(bigMargin, bigMargin, 0, bigMargin)
    self.Left:SetWide(halfWide)
    self.Left.Paint = nil

    self.Left.StaffOnline = self.Left:Add("DPanel")
    self.Left.StaffOnline:Dock(TOP)
    self.Left.StaffOnline:SetTall(halfTall)
    self.Left.StaffOnline.Paint = nil

    self.Left.StaffOnline.Title = self.Left.StaffOnline:Add("DPanel")
    self.Left.StaffOnline.Title:Dock(TOP)
    self.Left.StaffOnline.Title:SetTall(elementTall)
    self.Left.StaffOnline.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(self.localPlayer:GetLang("dashboard_staffOnline"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Left.StaffOnline.Scroll = self.Left.StaffOnline:Add("DScrollPanel")
    self.Left.StaffOnline.Scroll:Dock(FILL)
    self.Left.StaffOnline.Scroll:DockMargin(0, bigMargin, 0, 0)
    self.Left.StaffOnline.Scroll:GetVBar():SetWide(0)
    self.Left.StaffOnline.Scroll.Paint = function(s,w,h)
        if s:GetCanvas():ChildCount() == 0 then
            draw.SimpleText(self.localPlayer:GetLang("dashboard_noStaffOnline"), "BaseWars.30", w * .5, h * .5, self.colors.text, 1, 1)
        end
    end

    for k, ply in player.Iterator() do
        if not BaseWars:IsAdmin(ply) then continue end

        local staff = self.Left.StaffOnline.Scroll:Add("DPanel")
        staff:Dock(TOP)
        staff:DockMargin(0, 0, 0, margin)
        staff:SetTall(rowTall)
        staff.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)
            draw.SimpleText(ply:Name() or "", "BaseWars.20", bigMargin, h * .5, self.colors.text, 0, 1)
            draw.SimpleText(ply:GetUserGroup() or "", "BaseWars.20", w - bigMargin, h * .5, self.colors.darkText, TEXT_ALIGN_RIGHT, 1)
        end
        staff.Think = function(s)
            if not IsValid(ply) then
                s:Remove()
            end
        end
    end

    self.Left.Bounties = self.Left:Add("DPanel")
    self.Left.Bounties:Dock(BOTTOM)
    self.Left.Bounties:SetTall(halfTall)
    self.Left.Bounties.Paint = nil

    self.Left.Bounties.Title = self.Left.Bounties:Add("DPanel")
    self.Left.Bounties.Title:Dock(TOP)
    self.Left.Bounties.Title:SetTall(elementTall)
    self.Left.Bounties.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(self.localPlayer:GetLang("dashboard_bounties"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Left.Bounties.Scroll = self.Left.Bounties:Add("DScrollPanel")
    self.Left.Bounties.Scroll:Dock(FILL)
    self.Left.Bounties.Scroll:DockMargin(0, bigMargin, 0, 0)
    self.Left.Bounties.Scroll:GetVBar():SetWide(0)
    self.Left.Bounties.Scroll.Paint = function(s,w,h)
        if not s.hasData then
            BaseWars:DrawMaterial(icons["loading"].icon, w * .5, h * .5, icons["loading"].size, icons["loading"].size, self.colors.accent, -CurTime() * 540 % 360)
        else
            if #bounties == 0 then
                draw.SimpleText(self.localPlayer:GetLang("dashboard_noBounties"), "BaseWars.30", w * .5, h * .5, self.colors.text, 1, 1)
            end
        end
    end

    self.Right = self:Add("DPanel")
    self.Right:Dock(RIGHT)
    self.Right:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Right:SetWide(halfWide)
    self.Right.Paint = nil

    self.Right.Title = self.Right:Add("DPanel")
    self.Right.Title:Dock(TOP)
    self.Right.Title:DockMargin(0, 0, 0, bigMargin)
    self.Right.Title:SetTall(elementTall)
    self.Right.Title.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
        draw.SimpleText(self.localPlayer:GetLang("dashboard_AllCommands"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    self.Right.Scroll = self.Right:Add("DScrollPanel")
    self.Right.Scroll:Dock(FILL)
    self.Right.Scroll:PaintScrollBar("bwm")

    local isSuperAdmin = BaseWars:IsSuperAdmin(self.localPlayer)
    for k, v in SortedPairs(BaseWars:GetChatCommands()) do
        local access = v.rank or true
        if istable(v.rank) then
            access = v.rank[self.localPlayer:GetUserGroup()] != nil or isSuperAdmin
        end

        if not showAllcommands and access == false then
            continue
        end

        local hasArgs = v.args != nil and #v.args > 0
        local commandArgs = hasArgs and " " .. table.concat(v.args, " ") or ""

        local command = self.Right.Scroll:Add("DPanel")
        command:Dock(TOP)
        command:DockMargin(0, 0, margin, margin)
        command:SetTall(commandTall)
        command.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors[access and "contentBackground" or "contentBackground2"])

            draw.SimpleText(commandPrefix .. k .. commandArgs .. " ", "BaseWars.18", bigMargin, h * .5, self.colors.text, 0, 4)
            draw.SimpleText(v.desc[1] == "#" and self.localPlayer:GetLang(string.sub(v.desc, 2)) or v.desc, "BaseWars.16", bigMargin, h * .5, self.colors.darkText)
        end

        if hasArgs and access then
            command.Copy = command:Add("DButton")
            command.Copy:SetText("")
            command.Copy:Dock(RIGHT)
            command.Copy:DockMargin(0, bigMargin, bigMargin, bigMargin)
            command.Copy:SetWide(command:GetTall() - bigMargin * 2)
            command.Copy.Paint = function(s,w,h)
                BaseWars:DrawMaterial(icons["copy"].icon, w - h * .5, h * .5, icons["copy"].size, icons["copy"].size, self.colors.text, 0)
            end
            command.Copy.DoClick = function(s)
                surface.PlaySound("bw_button.wav")

                SetClipboardText(commandPrefix .. k .. commandArgs)
                BaseWars:Notify("#dashboard_copiedCommand", NOTIFICATION_GENERIC, 5)
            end
            command.Copy.DoRightClick = function(s)
                surface.PlaySound("bw_button.wav")

                SetClipboardText(commandPrefix .. k)
                BaseWars:Notify("#dashboard_copiedCommand", NOTIFICATION_GENERIC, 5)
            end
        end

        if not hasArgs and access then
            command.ExecuteCommand = command:Add("DButton")
            command.ExecuteCommand:SetText("")
            command.ExecuteCommand:Dock(RIGHT)
            command.ExecuteCommand:DockMargin(0, bigMargin, bigMargin, bigMargin)
            command.ExecuteCommand:SetWide(command:GetTall() - bigMargin * 2)
            command.ExecuteCommand.Paint = function(s,w,h)
                BaseWars:DrawMaterial(icons["execute_command"].icon, w - h * .5, h * .5, icons["execute_command"].size, icons["execute_command"].size, self.colors.text, 0)
            end
            command.ExecuteCommand.DoClick = function(s)
                surface.PlaySound("bw_button.wav")

                RunConsoleCommand("say", commandPrefix .. k)
                BaseWars:Notify("#dashboard_commandExecuted", NOTIFICATION_GENERIC, 5, commandPrefix .. k)
            end
        end
    end

    if bounties then
        self:BuildBounties(bounties)
    else
        net.Start("BaseWars:Dashboard:SendBountiesToClients")
        net.SendToServer()
    end
end

function PANEL:BuildBounties(data)
    self.Left.Bounties.Scroll:Clear()

    self.Left.Bounties.Scroll.hasData = true
    for k, v in ipairs(data) do
        local textColor = BaseWars:GetTheme(k == 1 and "leaderboard_top1" or k == 2 and "leaderboard_top2" or k == 3 and "leaderboard_top3" or "bwm_darkText")
        local bountyText = BaseWars:FormatMoney(v.bounty)

        BaseWars:RequestSteamName(v.player_id64)

        local bounty = self.Left.Bounties.Scroll:Add("DPanel")
        bounty:Dock(TOP)
        bounty:DockMargin(0, 0, 0, margin)
        bounty:SetTall(BaseWars.ScreenScale * 40)
        bounty.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(4, 0, 0, w, h, BaseWars:GetTheme("bwm_contentBackground"))

            draw.SimpleText("#" .. k .. " - " .. BaseWars:GetSteamName(v.player_id64), "BaseWars.18", bigMargin, h * .5, textColor, 0, 1)
            draw.SimpleText(bountyText, "BaseWars.18", w - bigMargin, h * .5, textColor, TEXT_ALIGN_RIGHT, 1)
        end
    end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Dashboard", PANEL, "DPanel")

--[[-------------------------------------------------------------------------
    Networking
---------------------------------------------------------------------------]]

net.Receive("BaseWars:Dashboard:SendBountiesToClients", function(len)
    local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

    bounties = data

    if IsValid(thisPanel) then
        thisPanel:BuildBounties(data)
    end
end)