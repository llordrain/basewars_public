local thisPanel

local elementTall = BaseWars.ScreenScale * 56
local buttonTall, buttonWide = BaseWars.ScreenScale * 36, BaseWars.ScreenScale * 150
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local PANEL = {}
function PANEL:Init()
    self.localPlayer = LocalPlayer()
    self.colors = {
        text = GetBaseWarsTheme("am_text"),
        contentBackground = GetBaseWarsTheme("am_contentBackground"),
		disabled = GetBaseWarsTheme("button_disabled"),
        green = GetBaseWarsTheme("button_green")
    }

    thisPanel = self

    self.Scroll = self:Add("DScrollPanel")
    self.Scroll:Dock(FILL)
    self.Scroll:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.Scroll:GetVBar():SetWide(0)

    self:Build()
end

function PANEL:Build()
    self.Scroll:GetCanvas():Clear()

    for factionName, factionData in SortedPairsByMemberValue(BaseWars:GetFactions(), "id") do
        local membersCount = table.Count(factionData.members)
        local tall = elementTall * 4 + margin * 3

        if membersCount > 0 then
            tall = tall + (elementTall + margin) * (membersCount + 1)
        end

        local faction = self.Scroll:Add("DPanel")
        faction:Dock(TOP)
        faction:DockMargin(0, 0, 0, margin)
        faction:SetTall(tall)
        faction.Paint = nil

        faction.Name = faction:Add("DPanel")
        faction.Name:Dock(TOP)
        faction.Name:SetTall(elementTall)
        faction.Name.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

            draw.SimpleText(factionName .. " [" .. factionData.id .. "]", "BaseWars.24", h * .25, h * .5, factionData.color, 0, 1)
        end

        faction.Name.Disband = faction.Name:Add("BaseWars.Button")
        faction.Name.Disband:Dock(RIGHT)
        faction.Name.Disband:DockMargin(0, bigMargin, bigMargin, bigMargin)
        faction.Name.Disband:SetWide(buttonWide)
        faction.Name.Disband:SetColor(self.colors.contentBackground, true)
        faction.Name.Disband.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("adminmenu_disband"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
        end
        faction.Name.Disband.DoClick = function(s)
            s:ButtonSound()

            net.Start("BaseWars:Factions:Admin:Disband")
                net.WriteString(factionName)
            net.SendToServer()
        end

        faction.Leader = faction:Add("DPanel")
        faction.Leader:Dock(TOP)
        faction.Leader:DockMargin(bigMargin * 10, margin, 0, 0)
        faction.Leader:SetTall(elementTall)
        faction.Leader.Paint = function(s,w,h)
            local leader = factionData.leader

            if IsValid(leader) then
                BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)
                draw.SimpleText(Format(self.localPlayer:GetLang("adminmenu_factionLeader"), leader:Name()), "BaseWars.24", h * .25, h * .5, self.colors.text, 0, 1)
            end
        end

        if membersCount > 0 then
            faction.Leader.TransferLeadership = faction.Leader:Add("BaseWars.Button")
            faction.Leader.TransferLeadership:Dock(RIGHT)
            faction.Leader.TransferLeadership:DockMargin(0, bigMargin, bigMargin, bigMargin)
            faction.Leader.TransferLeadership:SetWide(buttonWide)
            faction.Leader.TransferLeadership:SetColor(self.colors.contentBackground, true)
            faction.Leader.TransferLeadership.Draw = function(s,w,h)
                draw.SimpleText(self.localPlayer:GetLang("adminmenu_changeLeader"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
            end
            faction.Leader.TransferLeadership.DoClick = function(s)
                s:ButtonSound()

                local x, y = s:LocalToScreen()
                local _, h = s:GetSize()

                local dropDown = BaseWars:DropdownPopup(x, y + h + margin)
                for _, ply in ipairs(factionData.members) do
                    if not IsValid(ply) then continue end
                    if ply == factionData.leader then continue end

                    dropDown:AddChoice(ply:Name(), function()
                        net.Start("BaseWars:Factions:Admin:ChangeLeader")
                            net.WriteString(factionName)
                            net.WriteEntity(factionData.leader)
                            net.WriteEntity(ply)
                        net.SendToServer()
                    end)
                end
            end
        end

        faction.FriendlyFire = faction:Add("DPanel")
        faction.FriendlyFire:Dock(TOP)
        faction.FriendlyFire:DockMargin(bigMargin * 10, margin, 0, 0)
        faction.FriendlyFire:SetTall(elementTall)
        faction.FriendlyFire.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)
            draw.SimpleText(Format(self.localPlayer:GetLang("faction_changedFrendlyFire"), factionData.ff and self.localPlayer:GetLang("yes") or self.localPlayer:GetLang("no")), "BaseWars.24", h * .25, h * .5, self.colors.text, 0, 1)
        end

        faction.FriendlyFire.Toggle = faction.FriendlyFire:Add("BaseWars.CheckBox")
        faction.FriendlyFire.Toggle:Dock(RIGHT)
        faction.FriendlyFire.Toggle:DockMargin(0, bigMargin * 1.3, bigMargin, bigMargin * 1.3)
        faction.FriendlyFire.Toggle:SetWide(BaseWars.ScreenScale * 80)
        faction.FriendlyFire.Toggle:SetState(factionData.ff)
        faction.FriendlyFire.Toggle.clicked = false
        faction.FriendlyFire.Toggle.Toggle = function(s)
            if s.clicked then
                return
            end

            s.clicked = true
            s:SetState(not s:GetState())

            surface.PlaySound("bw_button.wav")

            net.Start("BaseWars:Factions:Admin:ToggleFriendlyFire")
                net.WriteString(factionName)
                net.WriteBool(s:GetState())
            net.SendToServer()
        end

        faction.Immunity = faction:Add("DPanel")
        faction.Immunity:Dock(TOP)
        faction.Immunity:DockMargin(bigMargin * 10, margin, 0, 0)
        faction.Immunity:SetTall(elementTall)
        faction.Immunity.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)

            local time = factionData.immunity - CurTime() <= 0 and self.localPlayer:GetLang("none") or BaseWars:FormatTime2(factionData.immunity - CurTime(), self.localPlayer)

            draw.SimpleText(Format(self.localPlayer:GetLang("adminmenu_factionImmunity"), time), "BaseWars.24", h * .25, h * .5, self.colors.text, 0, 1)
        end

        faction.Immunity.Reset = faction.Immunity:Add("BaseWars.Button")
        faction.Immunity.Reset:Dock(RIGHT)
        faction.Immunity.Reset:DockMargin(0, bigMargin, bigMargin, bigMargin)
        faction.Immunity.Reset:SetWide(buttonWide)
        faction.Immunity.Reset:SetColor(self.colors.contentBackground, true)
        faction.Immunity.Reset.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("adminmenu_reset"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
        end
        faction.Immunity.Reset.DoClick = function(s)
            if factionData.immunity - CurTime() <= 0 then
                s:Disable(1.5, self.colors.disabled, s.Draw)

                return
            end

            s:ButtonSound()
            s:CustomTempDraw(1.5, self.colors.green, s.Draw)

            net.Start("BaseWars:Factions:Admin:ResetImmunity")
                net.WriteString(factionName)
            net.SendToServer()
        end

        if membersCount <= 0 then
            continue
        end

        faction.Members = faction:Add("DPanel")
        faction.Members:Dock(TOP)
        faction.Members:DockMargin(bigMargin * 10, margin, 0, 0)
        faction.Members:SetTall(elementTall)
        faction.Members.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)

            draw.SimpleText(self.localPlayer:GetLang("adminmenu_factionMembers"), "BaseWars.24", h * .25, h * .5, self.colors.text, 0, 1)
        end

        for _, ply in ipairs(factionData.members) do
            local playerPanel = faction:Add("DPanel")
            playerPanel:Dock(TOP)
            playerPanel:DockMargin(bigMargin * 20, margin, 0, 0)
            playerPanel:SetTall(elementTall)
            playerPanel.Paint = function(s,w,h)
                if not IsValid(ply) then return end

                BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.contentBackground)

                draw.SimpleText(ply:Name(), "BaseWars.24", h * .25, h * .5, self.colors.text, 0, 1)
            end

            playerPanel.Kick = playerPanel:Add("BaseWars.Button")
            playerPanel.Kick:Dock(RIGHT)
            playerPanel.Kick:DockMargin(0, bigMargin, bigMargin, bigMargin)
            playerPanel.Kick:SetWide(buttonWide)
            playerPanel.Kick:SetColor(self.colors.contentBackground, true)
            playerPanel.Kick.Draw = function(s,w,h)
                draw.SimpleText(self.localPlayer:GetLang("adminmenu_kick"), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
            end
            playerPanel.Kick.DoClick = function(s)
                s:ButtonSound()

                net.Start("BaseWars:Factions:Admin:KickMember")
                    net.WriteString(factionName)
                    net.WriteEntity(ply)
                net.SendToServer()
            end
        end
    end
end

function PANEL:Paint()
end

vgui.Register("BaseWars.AdminMenu.Factions", PANEL, "DPanel")

function BaseWars:UpdateAdminMenuFactions()
    if IsValid(thisPanel) then
        thisPanel:Build()
    end
end