local icons = {
    back = Material("basewars_materials/back.png", "smooth"),
    loading = Material("basewars_materials/loading.png", "smooth"),
    user = Material("basewars_materials/user.png", "smooth"),
    money = Material("basewars_materials/money.png", "smooth"),
    level = Material("basewars_materials/profile_selector/level.png", "smooth"),
    xp = Material("basewars_materials/profile_selector/xp.png", "smooth"),
    time_play = Material("basewars_materials/profile_selector/time_play.png", "smooth"),
    prestige = Material("basewars_materials/f3/prestige.png", "smooth")
}

local thisPanel

local loadingSize = BaseWars.ScreenScale * 180
local elementTall = BaseWars.ScreenScale * 40
local buttonTall = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local roundness = BaseWars.ScreenScale * 4

local boxSize = elementTall
local iconSize = elementTall - bigMargin * 2

local PANEL = {}
function PANEL:Init()
    self.w, self.h = self:GetParent():GetSize()

    self.localPlayer = LocalPlayer()

    self.canRequest = true
    self.activePanel = "all"
    self.page = 1
    self.pageCount = 1
    self.selectedPlayer = ""

    self.colors = {
        accent = GetBaseWarsTheme("gen_accent"),
        text = GetBaseWarsTheme("am_text"),
        darkText = GetBaseWarsTheme("am_darkText"),
        contentBackground = GetBaseWarsTheme("am_contentBackground"),
        background = GetBaseWarsTheme("am_background"),
        disabled = GetBaseWarsTheme("button_disabled"),
        green = GetBaseWarsTheme("button_green")
    }

    thisPanel = self

    self.TopBar = self:Add("DPanel")
    self.TopBar:Dock(TOP)
    self.TopBar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.TopBar:SetTall(buttonTall + bigMargin * 2)
    self.TopBar.Paint = function(s,w,h)
        if IsValid(s.BackButton) then
            BaseWars:DrawRoundedBox(roundness, 0, 0, h, h, self.colors.contentBackground)
            BaseWars:DrawRoundedBox(roundness, h + bigMargin, 0, w - h - bigMargin, h, self.colors.contentBackground)
        else
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)
        end
    end

    self.TopBar.SearchEntry = self.TopBar:Add("BaseWars.TextEntry")
    self.TopBar.SearchEntry:Dock(FILL)
    self.TopBar.SearchEntry:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
    self.TopBar.SearchEntry:SetFont("BaseWars.18")
    self.TopBar.SearchEntry:SetColor(self.colors.contentBackground)
    self.TopBar.SearchEntry:SetTextColor(self.colors.text)
    self.TopBar.SearchEntry:SetPlaceHolderColor(self.colors.darkText)
    self.TopBar.SearchEntry:SetPlaceHolder(self.localPlayer:GetLang("playerlookup_search"))

    self.TopBar.SearchButton = self.TopBar:Add("BaseWars.Button2")
    self.TopBar.SearchButton:Dock(RIGHT)
    self.TopBar.SearchButton:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.TopBar.SearchButton:SetWide(BaseWars.ScreenScale * 150)
    self.TopBar.SearchButton:SetColor(self.colors.contentBackground, true)
    self.TopBar.SearchButton.Draw = function(s,w,h)
        draw.SimpleText(self.localPlayer:GetLang("search"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
    end
    self.TopBar.SearchButton.DoClick = function(s)
        if not self.canRequest then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        local text = BaseWars:GetSteamID64(self.TopBar.SearchEntry:GetText())
        if text == "none" then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        if self.selectedPlayer == text then
            s:Disable(1.5, self.colors.disabled, s.Draw)

            return
        end

        self.canRequest = false
        self.TopBar.SearchEntry:SetText("")

        s:CustomTempDraw(1.5, self.colors.green, s.Draw)
        s:ButtonSound()

        self:RequestPlayerData(text)
    end

    self.Content = self:Add("DPanel")
    self.Content:Dock(FILL)
    self.Content:DockMargin(bigMargin, 0, bigMargin, bigMargin)
    self.Content.Paint = nil

    self:RequestAllPlayers(self.page)
end

function PANEL:RequestAllPlayers(page)
    self.activePanel = "all"

    self.Content:Clear()

    self.Content.Loading = self.Content:Add("DPanel")
    self.Content.Loading:SetSize(loadingSize, loadingSize)
    self.Content.Loading:SetPos((self.w - loadingSize) * .5, (self.h - loadingSize) * .5)
    self.Content.Loading.Paint = function(s,w,h)
        BaseWars:DrawMaterial(icons["loading"], w * .5, h * .5, loadingSize, loadingSize, self.colors.accent, -CurTime() * 540 % 360)
    end

    net.Start("BaseWars:PlayerLookUp:RequestAllPlayers")
        net.WriteUInt(page, 4)
    net.SendToServer()
end

function PANEL:BuildAllPlayers(data)
    if self.activePanel != "all" then
        return
    end

    self.Content:Clear()
    self.canRequest = true
    self.selectedPlayer = ""

    if IsValid(self.TopBar.BackButton) then
        self.TopBar.BackButton:Remove()
    end

    self.Content.Layout = self.Content:Add("DIconLayout")
    self.Content.Layout:Dock(FILL)
    self.Content.Layout:DockMargin(0, 0, 0, bigMargin)
    self.Content.Layout:SetSpaceX(margin)
    self.Content.Layout:SetSpaceY(margin)
    self.Content.Layout.Paint = nil

    local playerWide = (self.w - bigMargin * 2 - margin * 4) / 3
    local playerTall = (self.h - bigMargin * 8 - margin * 4 - buttonTall * 2) / 6
    for _, playerData in ipairs(data) do
        local playerPanel = self.Content.Layout:Add("BaseWars.Button2")
        playerPanel:SetSize(playerWide, playerTall)
        playerPanel:SetColor(self.colors.contentBackground, true)
        playerPanel.Draw = nil
        playerPanel.LerpFunc = function() return false end
        playerPanel.DoClick = function(s)
            if not self.canRequest or self.selectedPlayer == playerData.player_id64 then
                return
            end

            s:ButtonSound()

            self.canRequest = false
            self:RequestPlayerData(playerData.player_id64)
        end

        playerPanel.Avatar = playerPanel:Add("AvatarMaterial")
        playerPanel.Avatar:Dock(LEFT)
        playerPanel.Avatar:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
        playerPanel.Avatar:SetWide(playerTall - bigMargin * 2)
        playerPanel.Avatar:SetSteamID64(playerData.player_id64)
        playerPanel.Avatar:SetMouseInputEnabled(false)

        local isConnected = BaseWars:FindPlayer(playerData.player_id64)
        local now, lastSeenDate, joinedDate = self.localPlayer:GetLang("now"), os.date("%d/%m/%Y", playerData.last_played), os.date("%d/%m/%Y", playerData.joined)
        playerPanel.Infos = playerPanel:Add("DPanel")
        playerPanel.Infos:Dock(FILL)
        playerPanel.Infos:DockMargin(0, bigMargin, bigMargin, bigMargin)
        playerPanel.Infos:SetMouseInputEnabled(false)
        playerPanel.Infos.Paint = function(s,w,h)
            draw.SimpleText(playerData.steam_name, "BaseWars.20", w * .5, margin, isConnected and self.colors.green or self.colors.disabled, 1)

            local lastSeen = now
            local time = os.time() - playerData.last_played
            if not isConnected then
                lastSeen = time > 86400 and lastSeenDate or BaseWars:FormatTime2(time)
            end

            draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_lastSeen"), lastSeen), "BaseWars.18", w * .5, h * .4, self.colors.darkText, 1)
            draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_joined"), joinedDate), "BaseWars.18", w * .5, h * .62, self.colors.darkText, 1)
        end
    end

    self.Content.BottomBar = self.Content:Add("DPanel")
    self.Content.BottomBar:Dock(BOTTOM)
    self.Content.BottomBar:SetTall(buttonTall + bigMargin * 2)
    self.Content.BottomBar.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_page"), self.page, self.pageCount), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    if self.page > 1 then
        self.Content.BottomBar.PageLeft = self.Content.BottomBar:Add("BaseWars.Button2")
        self.Content.BottomBar.PageLeft:Dock(LEFT)
        self.Content.BottomBar.PageLeft:DockMargin(bigMargin, bigMargin, 0, bigMargin)
        self.Content.BottomBar.PageLeft:SetWide(BaseWars.ScreenScale * 200)
        self.Content.BottomBar.PageLeft:SetColor(self.colors.contentBackground, true)
        self.Content.BottomBar.PageLeft.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("playerlookup_prevPage"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
        end
        self.Content.BottomBar.PageLeft.DoClick = function(s)
            if not self.canRequest or self.page - 1 <= 0 then
                s:Disable(1.5, self.colors.disabled, s.Draw)

                return
            end

            s:ButtonSound()

            self.page = self.page - 1
            self.canRequest = false

            self:RequestAllPlayers(self.page)
        end
    end

    if self.page < self.pageCount then
        self.Content.BottomBar.PageRight = self.Content.BottomBar:Add("BaseWars.Button2")
        self.Content.BottomBar.PageRight:Dock(RIGHT)
        self.Content.BottomBar.PageRight:DockMargin(0, bigMargin, bigMargin, bigMargin)
        self.Content.BottomBar.PageRight:SetWide(BaseWars.ScreenScale * 200)
        self.Content.BottomBar.PageRight:SetColor(self.colors.contentBackground, true)
        self.Content.BottomBar.PageRight.Draw = function(s,w,h)
            draw.SimpleText(self.localPlayer:GetLang("playerlookup_nextPage"), "BaseWars.18", w * .5, h * .5, self.colors.text, 1, 1)
        end
        self.Content.BottomBar.PageRight.DoClick = function(s)
            if not self.canRequest or self.page + 1 > self.pageCount then
                s:Disable(1.5, self.colors.disabled, s.Draw)

                return
            end

            s:ButtonSound()

            self.page = self.page + 1
            self.canRequest = false

            self:RequestAllPlayers(self.page)
        end
    end
end

function PANEL:RequestPlayerData(player_id64)
    self.activePanel = "search"

    self.Content:Clear()

    self.Content.Loading = self.Content:Add("DPanel")
    self.Content.Loading:SetSize(loadingSize, loadingSize)
    self.Content.Loading:SetPos((self.w - loadingSize) * .5, (self.h - loadingSize) * .5)
    self.Content.Loading.Paint = function(s,w,h)
        BaseWars:DrawMaterial(icons["loading"], w * .5, h * .5, loadingSize, loadingSize, self.colors.accent, -CurTime() * 540 % 360)
    end

    net.Start("BaseWars:PlayerLookUp:RequestPlayerData")
        net.WriteString(player_id64)
    net.SendToServer()
end

function PANEL:BuildPlayerData(data)
    if self.activePanel != "search" then
        return
    end

    local isConnected = BaseWars:FindPlayer(data.player_id64)

    self.Content:Clear()
    self.canRequest = true
    self.selectedPlayer = data.player_id64
    self.TopBar.SearchEntry:SetText(data.player_id64)

    if not IsValid(self.TopBar.BackButton) then
        self.TopBar.BackButton = self.TopBar:Add("BaseWars.Button2")
        self.TopBar.BackButton:Dock(LEFT)
        self.TopBar.BackButton:DockMargin(bigMargin, bigMargin, bigMargin * 2, bigMargin)
        self.TopBar.BackButton:SetWide(buttonTall)
        self.TopBar.BackButton:SetColor(self.colors.contentBackground, true)
        self.TopBar.BackButton.Draw = function(s,w,h)

            BaseWars:DrawMaterial(icons["back"], h * .5, h * .5, h * .65, h * .65, self.colors.text, 0)
        end
        self.TopBar.BackButton.DoClick = function(s)
            s:ButtonSound()

            self.page = 1
            self:RequestAllPlayers(self.page)
            self.TopBar.SearchEntry:SetText("")
        end
    end

    self.Content.Scroll = self.Content:Add("DScrollPanel")
    self.Content.Scroll:Dock(FILL)
    self.Content.Scroll:PaintScrollBar("am")
    self.Content.Scroll:GetVBar():SetWide(bigMargin)
    self.Content.Scroll.time = 0
    self.Content.Scroll.Paint = nil
    self.Content.Scroll.Think = function(s)
        if CurTime() >= s.time then
            isConnected = BaseWars:FindPlayer(data.player_id64)
            s.time = CurTime() + 5
        end
    end

    -- TODO: Ban
    -- if not table.IsEmpty(data.ban) then
    --     if data.ban.admin != "Console" then
    --         data.ban.admin = BaseWars:GetSteamID64(data.ban.admin)

    --         BaseWars:RequestSteamName(data.ban.admin)
    --     end

    --     local banPanel = self.Content.Scroll:Add("DPanel")
    --     banPanel:Dock(TOP)
    --     banPanel:DockMargin(0, 0, 0, bigMargin)
    --     banPanel:SetTall(BaseWars.ScreenScale * 80)
    --     banPanel.Paint = function(s,w,h)
    --         BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

    --         draw.SimpleText("Banned By: " .. (data.ban.admin == "Console" and "Console" or BaseWars:GetSteamName(data.ban.admin)), "BaseWars.18", h * .5, h * .5, self.colors.text, 0, 4)
    --     end
    -- end

    if not table.IsEmpty(data.bounty) then
        local bountyPanel = self.Content.Scroll:Add("DPanel")
        bountyPanel:Dock(TOP)
        bountyPanel:DockMargin(0, 0, 0, bigMargin)
        bountyPanel:SetTall(elementTall)
        bountyPanel.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

            draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_bounty"), BaseWars:FormatMoney(data.bounty.bounty), data.bounty.stack), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
        end
    end

    local infosPanel = self.Content.Scroll:Add("DPanel")
    infosPanel:Dock(TOP)
    infosPanel:DockMargin(0, 0, 0, margin)
    infosPanel:SetTall(elementTall)
    infosPanel.Paint = nil

    local third = (self.w - bigMargin * 2 - margin * 2) / 3
    local now, lastSeenDate, joinedDate = self.localPlayer:GetLang("now"), os.date("%d/%m/%Y", data.infos.last_played), os.date("%d/%m/%Y", data.infos.joined)
    infosPanel.Joined = infosPanel:Add("DPanel")
    infosPanel.Joined:Dock(LEFT)
    infosPanel.Joined:DockMargin(0, 0, margin, 0)
    infosPanel.Joined:SetWide(third)
    infosPanel.Joined.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_joined"), joinedDate), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    infosPanel.PlayerName = infosPanel:Add("DPanel")
    infosPanel.PlayerName:Dock(LEFT)
    infosPanel.PlayerName:DockMargin(0, 0, margin, 0)
    infosPanel.PlayerName:SetWide(third)
    infosPanel.PlayerName.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(data.infos.steam_name, "BaseWars.20", w * .5, h * .5, isConnected and self.colors.green or self.colors.disabled, 1, 1)
    end

    infosPanel.LastSeen = infosPanel:Add("DPanel")
    infosPanel.LastSeen:Dock(RIGHT)
    infosPanel.LastSeen:SetWide(third)
    infosPanel.LastSeen.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        local lastSeen = now
        local time = os.time() - data.infos.last_played
        if not isConnected then
            lastSeen = time > 86400 and lastSeenDate or BaseWars:FormatTime2(time)
        end

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_lastSeen"), lastSeen), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    local backProfiles = self.Content.Scroll:Add("DPanel")
    backProfiles:Dock(TOP)
    backProfiles:DockMargin(0, 0, 0, margin)
    backProfiles:SetTall(elementTall * 6 + bigMargin * 7)
    backProfiles.Paint = nil

    for i = 1, 3 do
        local profile = backProfiles:Add("DPanel")
        profile:Dock(LEFT)
        profile:DockMargin(0, 0, margin, 0)
        profile:SetWide(third)
        profile.Paint = function(s,w,h)
            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

            if data.p_and_p[i] == nil then
                draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_noProfileData"), i), "BaseWars.22", w * .5, h * .5, self.colors.text, 1, 1)
            end

            if data.p_and_p[i] != nil then
                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["user"], bigMargin * 2, bigMargin * 2, iconSize, iconSize, self.colors.text)
                draw.SimpleText(self.localPlayer:GetLang("profileSelector_profileNumber"):format(data.p_and_p[i].profile_id), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin, self.colors.text, 0, 1)

                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 2 + elementTall, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["money"], bigMargin * 2, bigMargin * 3 + elementTall, iconSize, iconSize, self.colors.text)
                draw.SimpleText(BaseWars:FormatMoney(data.p_and_p[i].money), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 2 + elementTall, self.colors.text, 0, 1)

                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 3 + elementTall * 2, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["level"], bigMargin * 2, bigMargin * 4 + elementTall * 2, iconSize, iconSize, self.colors.text)
                draw.SimpleText(BaseWars:FormatNumber(data.p_and_p[i].level), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 3 + elementTall * 2, self.colors.text, 0, 1)

                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 4 + elementTall * 3, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["xp"], bigMargin * 2, bigMargin * 5 + elementTall * 3, iconSize, iconSize, self.colors.text)
                draw.SimpleText(BaseWars:FormatNumber(data.p_and_p[i].xp), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 4 + elementTall * 3, self.colors.text, 0, 1)

                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 5 + elementTall * 4, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["time_play"], bigMargin * 2, bigMargin * 6 + elementTall * 4, iconSize, iconSize, self.colors.text)
                draw.SimpleText(BaseWars:FormatTime2(data.p_and_p[i].time_played, self.localPlayer), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 5 + elementTall * 4, self.colors.text, 0, 1)

                BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 6 + elementTall * 5, boxSize, boxSize, self.colors.background)
                BaseWars:DrawMaterial(icons["prestige"], bigMargin * 2, bigMargin * 7 + elementTall * 5, iconSize, iconSize, self.colors.text)
                draw.SimpleText(BaseWars:FormatNumber(data.p_and_p[i].prestige), "BaseWars.22", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 6 + elementTall * 5, self.colors.text, 0, 1)
            end
        end
    end

    local statsPanel = self.Content.Scroll:Add("DPanel")
    statsPanel:Dock(TOP)
    statsPanel:DockMargin(0, 0, 0, margin)
    statsPanel:SetTall(elementTall * 2 + margin)
    statsPanel.Paint = nil

    statsPanel.Left = statsPanel:Add("DPanel")
    statsPanel.Left:Dock(LEFT)
    statsPanel.Left:SetWide(third)
    statsPanel.Left.Paint = nil

    statsPanel.Left.Kills = statsPanel.Left:Add("DPanel")
    statsPanel.Left.Kills:Dock(TOP)
    statsPanel.Left.Kills:DockMargin(0, 0, 0, margin)
    statsPanel.Left.Kills:SetTall(elementTall)
    statsPanel.Left.Kills.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_kills"), string.Comma(data.stats.kills)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    statsPanel.Left.Deaths = statsPanel.Left:Add("DPanel")
    statsPanel.Left.Deaths:Dock(TOP)
    statsPanel.Left.Deaths:SetTall(elementTall)
    statsPanel.Left.Deaths.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_deaths"), string.Comma(data.stats.deaths)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    statsPanel.Middle = statsPanel:Add("DPanel")
    statsPanel.Middle:Dock(LEFT)
    statsPanel.Middle:DockMargin(margin, 0, 0, 0)
    statsPanel.Middle:SetWide(third)
    statsPanel.Middle.Paint = nil

    statsPanel.Middle.MessageSent = statsPanel.Middle:Add("DPanel")
    statsPanel.Middle.MessageSent:Dock(TOP)
    statsPanel.Middle.MessageSent:DockMargin(0, 0, 0, margin)
    statsPanel.Middle.MessageSent:SetTall(elementTall)
    statsPanel.Middle.MessageSent.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_messageSent"), string.Comma(data.stats.message_sent)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    statsPanel.Middle.PlayCount = statsPanel.Middle:Add("DPanel")
    statsPanel.Middle.PlayCount:Dock(TOP)
    statsPanel.Middle.PlayCount:SetTall(elementTall)
    statsPanel.Middle.PlayCount.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_playCount"), string.Comma(data.stats.play_count)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    statsPanel.Right = statsPanel:Add("DPanel")
    statsPanel.Right:Dock(RIGHT)
    statsPanel.Right:SetWide(third)
    statsPanel.Right.Paint = nil

    statsPanel.Right.MessageSent = statsPanel.Right:Add("DPanel")
    statsPanel.Right.MessageSent:Dock(TOP)
    statsPanel.Right.MessageSent:DockMargin(0, 0, 0, margin)
    statsPanel.Right.MessageSent:SetTall(elementTall)
    statsPanel.Right.MessageSent.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_moneyTaken"), BaseWars:FormatMoney(data.stats.money_taken)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    statsPanel.Right.PlayCount = statsPanel.Right:Add("DPanel")
    statsPanel.Right.PlayCount:Dock(TOP)
    statsPanel.Right.PlayCount:SetTall(elementTall)
    statsPanel.Right.PlayCount.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.contentBackground)

        draw.SimpleText(Format(self.localPlayer:GetLang("playerlookup_xpReceived"), BaseWars:FormatNumber(data.stats.xp_received)), "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
    end

    -- TODO: Warnings
    -- TODO: Perma Weapons
end

function PANEL:Paint()
end

vgui.Register("BaseWars.AdminMenu.PlayerLookUp", PANEL, "DPanel")

net.Receive("BaseWars:PlayerLookUp:RequestAllPlayers", function(len)
    local pageCount = net.ReadUInt(5)
    local bytes = net.ReadUInt(16)
    local data = util.JSONToTable(util.Decompress(net.ReadData(bytes)))

    if IsValid(thisPanel) then
        thisPanel.pageCount = pageCount
        thisPanel:BuildAllPlayers(data)
    end
end)

net.Receive("BaseWars:PlayerLookUp:RequestPlayerData", function(len)
    local data = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))

    if data.error then
        local localPlayer = LocalPlayer()

        errorPopup = vgui.Create("BaseWars.Popup")
        errorPopup:SetTitle("#error")
        errorPopup:SetText(data.error)
        errorPopup:SetConfirm(localPlayer:GetLang("close"), function()
            errorPopup:Remove()
        end)
        errorPopup:SetCancel(localPlayer:GetLang("close"), function()
            errorPopup:Remove()
        end)

        if IsValid(thisPanel) then
            thisPanel.canRequest = true
            thisPanel:RequestAllPlayers(thisPanel.page)
        end

        return
    end

    if IsValid(thisPanel) then
        thisPanel:BuildPlayerData(data)
    end
end)