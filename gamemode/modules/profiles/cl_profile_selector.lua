local icons = {
    plus = Material("materials/basewars_materials/plus.png", "smooth"),
    loading = Material("basewars_materials/loading.png", "smooth"),
    leave = Material("basewars_materials/leave.png", "smooth"),
    user = Material("basewars_materials/user.png", "smooth"),
    money = Material("basewars_materials/money.png", "smooth"),
    level = Material("basewars_materials/profile_selector/level.png", "smooth"),
    xp = Material("basewars_materials/profile_selector/xp.png", "smooth"),
    time_play = Material("basewars_materials/profile_selector/time_play.png", "smooth"),
    prestige = Material("basewars_materials/f3/prestige.png", "smooth"),
}

local profileSize = BaseWars.ScreenScale * 300
local plusIconSize = BaseWars.ScreenScale * 100
local elementTall = BaseWars.ScreenScale * 40
local bigMargin = BaseWars.ScreenScale * 10
local roundness = BaseWars.ScreenScale * 4
local profilePanelTall = elementTall * 6 + bigMargin * 7

local PANEL = {}
local boxSize = elementTall
local iconSize = elementTall - bigMargin * 2
function PANEL:Init()
    self.localPlayer = LocalPlayer()
    self.chosen = false
    self.profileID = self.localPlayer.basewarsProfileID
    self.localPlayer.basewarsProfileID = nil
    self.colors = {
        background = BaseWars:GetTheme("profileSelector_background"),
        contentBackground = BaseWars:GetTheme("profileSelector_contentBackground"),
        text = BaseWars:GetTheme("profileSelector_text"),
        darkText = BaseWars:GetTheme("profileSelector_darkText"),
        accent = BaseWars:GetTheme("gen_accent"),
    }

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.Frame = self:Add("DPanel")
    self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
    self.Frame:Center()
    self.Frame.Paint = nil
    self.Frame.Clear = function(s)
        for k, v in ipairs(s:GetChildren()) do
            if IsValid(self.Frame.TopBar) and v == self.Frame.TopBar then
                continue
            end

            v:Remove()
        end
    end

    self.Frame.TopBar = self.Frame:Add("DPanel")
    self.Frame.TopBar:Dock(TOP)
    self.Frame.TopBar:DockMargin(0, 0, 0, bigMargin * 5)
    self.Frame.TopBar:SetTall(elementTall + bigMargin * 2)
    self.Frame.TopBar.Paint = function(s,w,h)
        BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)

        BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["user"], bigMargin * 2, bigMargin * 2, iconSize, iconSize, self.colors.text)
        draw.SimpleText(self.localPlayer:Name(), "BaseWars.24", h, h * .5, self.colors.text, 0, 1)
    end

    self.Frame.TopBar.Leave = self.Frame.TopBar:Add("BaseWars.IconButton")
    self.Frame.TopBar.Leave:Dock(RIGHT)
    self.Frame.TopBar.Leave:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.TopBar.Leave:SetColor(self.colors.contentBackground)
    self.Frame.TopBar.Leave:SetIcon(icons["leave"])
    self.Frame.TopBar.Leave.DoClick = function(s)
        s:ButtonSound()
        RunConsoleCommand("disconnect")
    end

    self.Frame.TopBar.Close = self.Frame.TopBar:Add("BaseWars.IconButton")
    self.Frame.TopBar.Close:Dock(RIGHT)
    self.Frame.TopBar.Close:DockMargin(0, bigMargin, bigMargin, bigMargin)
    self.Frame.TopBar.Close:SetColor(self.colors.contentBackground)
    self.Frame.TopBar.Close.DoClick = function(s)
        s:ButtonSound()
        self.localPlayer.basewarsProfileID = self.profileID
        self:Remove()

        net.Start("BaseWars:CancelProfileSelection")
        net.SendToServer()
    end

    if self.profileID != nil then
        self.Frame.TopBar.Leave:Hide()
    else
        self.Frame.TopBar.Close:Hide()
    end

    self:WaitForSomething("profileSelector_waitingForData", "BaseWars.26")

    BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:Build(data)
    self.profilesData = data

    self.Frame:Clear()

    local ContentProfilesCount = math.Clamp(#data + 1, 1, BaseWars.Config.MaxProfiles)
    self.Frame.Content = self.Frame:Add("DPanel")
    self.Frame.Content:SetSize(profileSize * ContentProfilesCount + (bigMargin * 5) * (ContentProfilesCount - 1), self.Frame:GetTall() - elementTall - bigMargin * 5)
    self.Frame.Content:SetPos((self.Frame:GetWide() - self.Frame.Content:GetWide()) * .5, elementTall + bigMargin * 5)
    self.Frame.Content.Paint = nil

    local posX, posY = profileSize + bigMargin * 5, (self.Frame.Content:GetTall() - profilePanelTall) * .5

    for k, v in ipairs(data) do
        local profilePanel = self.Frame.Content:Add("DButton")
        profilePanel:SetText("")
        profilePanel:SetSize(profileSize, profilePanelTall)
        profilePanel:SetPos(posX * (k - 1), posY)
        profilePanel.color = self.colors.text
        profilePanel.Paint = function(s,w,h)
            s.color = BaseWars:LerpColor(self.LERP_FRAC, s.color, s:IsHovered() and self.colors.accent or self.colors.text)

            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["user"], bigMargin * 2, bigMargin * 2, iconSize, iconSize, s.color)
            draw.SimpleText(self.localPlayer:GetLang("profileSelector_profileNumber"):format(k), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin, self.colors.text, 0, 1)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 2 + elementTall, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["money"], bigMargin * 2, bigMargin * 3 + elementTall, iconSize, iconSize, s.color)
            draw.SimpleText(BaseWars:FormatMoney(v.money), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 2 + elementTall, self.colors.text, 0, 1)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 3 + elementTall * 2, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["level"], bigMargin * 2, bigMargin * 4 + elementTall * 2, iconSize, iconSize, s.color)
            draw.SimpleText(BaseWars:FormatNumber(v.level), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 3 + elementTall * 2, self.colors.text, 0, 1)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 4 + elementTall * 3, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["xp"], bigMargin * 2, bigMargin * 5 + elementTall * 3, iconSize, iconSize, s.color)
            draw.SimpleText(BaseWars:FormatNumber(v.xp), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 4 + elementTall * 3, self.colors.text, 0, 1)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 5 + elementTall * 4, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["time_play"], bigMargin * 2, bigMargin * 6 + elementTall * 4, iconSize, iconSize, s.color)
            draw.SimpleText(BaseWars:FormatTime2(v.time_played), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 5 + elementTall * 4, self.colors.text, 0, 1)

            BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin * 6 + elementTall * 5, boxSize, boxSize, self.colors.contentBackground)
            BaseWars:DrawMaterial(icons["prestige"], bigMargin * 2, bigMargin * 7 + elementTall * 5, iconSize, iconSize, s.color)
            draw.SimpleText(BaseWars:FormatNumber(v.prestige), "BaseWars.24", boxSize + bigMargin * 2, boxSize * .5 + bigMargin * 6 + elementTall * 5, self.colors.text, 0, 1)
        end
        profilePanel.DoClick = function(s)
            if self.chosen then return end

            surface.PlaySound("basewars/button.wav")
            self.chosen = true

            self:WaitForSomething("profileSelector_applyingProfile", "BaseWars.26", true)

            net.Start("BaseWars:PlayerChoseProfile")
                net.WriteUInt(k, 2)
            net.SendToServer()
        end
    end

    if #data < BaseWars.Config.MaxProfiles then
        local createProfile = self.Frame.Content:Add("DButton")
        createProfile:SetText("")
        createProfile:SetSize(profileSize, profilePanelTall)
        createProfile:SetPos(posX * (ContentProfilesCount - 1), posY)
        createProfile.color = self.colors.darkText
        createProfile.Paint = function(s,w,h)
            s.color = BaseWars:LerpColor(self.LERP_FRAC, s.color, s:IsHovered() and self.colors.accent or self.colors.darkText)

            BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, self.colors.background)
            BaseWars:DrawMaterial(icons["plus"], w * .5, h * .5, plusIconSize, plusIconSize, s.color, 0)
        end
        createProfile.DoClick = function(s)
            if self.chosen then return end

            surface.PlaySound("basewars/button.wav")
            self.chosen = true

            self:WaitForSomething("profileSelector_creatingProfile", "BaseWars.26")

            net.Start("BaseWars:CreatePlayerProfile")
            net.SendToServer()
        end
    end
end

function PANEL:Think()
    self.loadingAngle = -CurTime() * 540 % 360
    self.LERP_FRAC = FrameTime() * 15

    if not self.profilesData or not self.profileID then return end

    local removeCloseButton = true
    for k, v in ipairs(self.profilesData) do
        if v.profile_id == self.profileID then
            removeCloseButton = false
            break
        end
    end

    if removeCloseButton then
        self.profileID = nil

        if #self.profilesData < 1 then
            self.Frame.TopBar.Close:Remove()
            self.Frame.TopBar.Leave:Show()
        end
    end
end

function PANEL:WaitForSomething(text, font, removeWhenProfileIdValid)
    text = self.localPlayer:GetLang(text), font

    local textW, _ = BaseWars:GetTextSize(text, font)

    self.Frame:Clear()
    if IsValid(self.Frame.TopBar.Close) then
        self.Frame.TopBar.Close:Remove()
    end

    self.Frame.Wait = self.Frame:Add("DPanel")
    self.Frame.Wait:SetSize(textW + elementTall + bigMargin * 3, elementTall + bigMargin * 2)
    self.Frame.Wait:Center()
    self.Frame.Wait.Paint = function(waitingSelf,w,h)
        BaseWars:DrawRoundedBox(4, 0, 0, w, h, self.colors.background)

        BaseWars:DrawRoundedBox(roundness, bigMargin, bigMargin, boxSize, boxSize, self.colors.contentBackground)
        BaseWars:DrawMaterial(icons["loading"], h * .5, h * .5, iconSize * 1.2, iconSize * 1.2, self.colors.accent, self.loadingAngle)
        draw.SimpleText(text, font, h, h * .5, self.colors.text, 0, 1)
    end
end

function PANEL:Paint(w, h)
end

vgui.Register("BaseWars.Profiles", PANEL, "EditablePanel")