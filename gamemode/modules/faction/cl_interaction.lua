local factionInteraction = {}
function BaseWars:AddFactionInteraction(name, size, func)
	table.insert(factionInteraction, {
		name = name,
		size = size,
		func = func
	})
end

function BaseWars:GetFactionInteraction()
	return factionInteraction
end

local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

--[[-------------------------------------------------------------------------
	Create Faction
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_createFaction", buttonSize * 6 + bigMargin * 3 + margin * 3, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		darkText = BaseWars:GetTheme("bwm_darkText"),
		background = BaseWars:GetTheme("bwm_background"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Name = parent:Add("BaseWars.TextEntry")
	parent.Name:Dock(TOP)
	parent.Name:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	parent.Name:SetTall(buttonSize)
	parent.Name:SetColor(theme.background)
	parent.Name:SetTextColor(theme.text)
	parent.Name:SetFont("BaseWars.18")
	parent.Name:SetPlaceHolder(localPlayer:GetLang("faction_factionName"))
	parent.Name:SetPlaceHolderColor(theme.darkText)
	parent.Name:RequestFocus()
	parent.Name.OnChange = function(s, text)
		if string.find(text, "{") or string.find(text, "}") then
			text = string.Replace(text, "{", "")
			text = string.Replace(text, "}", "")

			s:SetText(text)
		end
	end

	parent.Password = parent:Add("BaseWars.TextEntry")
	parent.Password:Dock(TOP)
	parent.Password:DockMargin(bigMargin, margin, bigMargin, 0)
	parent.Password:SetTall(buttonSize)
	parent.Password:SetColor(theme.background)
	parent.Password:SetTextColor(theme.text)
	parent.Password:SetFont("BaseWars.18")
	parent.Password:SetPlaceHolder(localPlayer:GetLang("faction_password"))
	parent.Password:SetPlaceHolderColor(theme.darkText)

	parent.ColorPicker = parent:Add("BaseWars.ColorPicker")
	parent.ColorPicker:Dock(TOP)
	parent.ColorPicker:DockMargin(bigMargin, margin, bigMargin, 0)
	parent.ColorPicker:SetTall(buttonSize * 3 + margin * 2)

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, margin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_createFaction"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		if localPlayer:InRaid() then
			BaseWars:Notify("#faction_inRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		local name = string.Trim(parent.Name:GetText())
		local password = string.Trim(parent.Password:GetText())

		if localPlayer:InFaction() then
			BaseWars:Notify("#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_nameTaken", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if string.len(name) < 3 then
			BaseWars:Notify("#faction_nameTooShort", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if string.len(name) > 32 then
			BaseWars:Notify("#faction_nameTooLong", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		local goodName = true
		for k, v in pairs(BaseWars.LANG) do
			if k == "Currency" then continue end

			if name == v.faction_noFaction then
				goodName = false

				break
			end
		end

		if not goodName then
			BaseWars:Notify("#faction_nameBlocked", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:CreateFaction(name, password, parent.ColorPicker:GetColor())
	end
end)

--[[-------------------------------------------------------------------------
	Join Faction
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_joinFaction", buttonSize * 3 + bigMargin * 2 + margin * 2, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		darkText = BaseWars:GetTheme("bwm_darkText"),
		background = BaseWars:GetTheme("bwm_background"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Name = parent:Add("BaseWars.TextEntry")
	parent.Name:Dock(TOP)
	parent.Name:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	parent.Name:SetTall(buttonSize)
	parent.Name:SetColor(theme.background)
	parent.Name:SetTextColor(theme.text)
	parent.Name:SetFont("BaseWars.18")
	parent.Name:SetPlaceHolder(localPlayer:GetLang("faction_factionName"))
	parent.Name:SetPlaceHolderColor(theme.darkText)
	parent.Name:RequestFocus()
	if parent.selectedPlayer:InFaction() then
		parent.Name:SetText(parent.selectedPlayer:GetFaction())
	end

	parent.Password = parent:Add("BaseWars.TextEntry")
	parent.Password:Dock(TOP)
	parent.Password:DockMargin(bigMargin, margin, bigMargin, 0)
	parent.Password:SetTall(buttonSize)
	parent.Password:SetColor(theme.background)
	parent.Password:SetTextColor(theme.text)
	parent.Password:SetFont("BaseWars.18")
	parent.Password:SetPlaceHolder(localPlayer:GetLang("faction_password"))
	parent.Password:SetPlaceHolderColor(theme.darkText)

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, margin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_join"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		if localPlayer:InRaid() then
			BaseWars:Notify("#faction_inRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		local name = string.Trim(parent.Name:GetText())
		local password = string.Trim(parent.Password:GetText())

		if localPlayer:InFaction() then
			BaseWars:Notify("#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if parent.selectedPlayer:InRaid() then
			BaseWars:Notify("#faction_cantJoinDuringRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if table.Count(BaseWars:GetFactionMembers(name, true)) >= BaseWars.Config.FactionLimit then
			BaseWars:Notify("#faction_reachMemberLimit", NOTIFICATION_ERROR, 5, BaseWars.Config.FactionLimit)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:JoinFaction(name, password)
	end
end)

--[[-------------------------------------------------------------------------
	Quit Faction
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_quitFaction", buttonSize + bigMargin * 2, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_quit"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		local name = localPlayer:GetFaction()

		if localPlayer:InRaid() then
			BaseWars:Notify("#faction_inRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not localPlayer:InFaction() then
			BaseWars:Notify("#faction_notInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:QuitFaction()
	end
end)

--[[-------------------------------------------------------------------------
	Change Faction Password
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_changePassword", buttonSize * 2 + bigMargin * 2 + margin, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		darkText = BaseWars:GetTheme("bwm_darkText"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		background = BaseWars:GetTheme("bwm_background"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Password = parent:Add("BaseWars.TextEntry")
	parent.Password:Dock(TOP)
	parent.Password:DockMargin(bigMargin, bigMargin, bigMargin, 0)
	parent.Password:SetTall(buttonSize)
	parent.Password:SetColor(theme.background)
	parent.Password:SetTextColor(theme.text)
	parent.Password:SetFont("BaseWars.18")
	parent.Password:SetPlaceHolder(localPlayer:GetLang("faction_password"))
	parent.Password:SetPlaceHolderColor(theme.darkText)
	parent.Password:RequestFocus()

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, margin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_change"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		local name = localPlayer:GetFaction()

		if not localPlayer:InFaction() then
			BaseWars:Notify("#faction_alreadyInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if BaseWars:GetFactionLeader(name) != localPlayer then
			BaseWars:Notify("#faction_notLeader", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:ChangeFactionPassword(parent.Password:GetText())
	end
end)

--[[-------------------------------------------------------------------------
	Kick Faction Member
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_kickMember", buttonSize + bigMargin * 2, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_kick"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		local name = localPlayer:GetFaction()

		if localPlayer:InRaid() then
			BaseWars:Notify("#faction_inRaid", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not localPlayer:InFaction() then
			BaseWars:Notify("#faction_notInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if localPlayer == parent.selectedPlayer then
			BaseWars:Notify("#faction_cantDoToYourself", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not localPlayer:HasSameFaction(parent.selectedPlayer) then
			BaseWars:Notify("#faction_differentFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if BaseWars:GetFactionLeader(name) != localPlayer then
			BaseWars:Notify("#faction_notLeader", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not table.HasValue(BaseWars:GetFactionMembers(name), parent.selectedPlayer) then
			BaseWars:Notify("#faction_notMemberOfYourFaction", NOTIFICATION_ERROR, 5, parent.selectedPlayer:Name())
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:KickPlayerFromFaction(parent.selectedPlayer)
	end
end)

--[[-------------------------------------------------------------------------
	Promote Faction Leader
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_promoteLeader", buttonSize + bigMargin * 2, function(parent)
	local localPlayer = LocalPlayer()
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled"),
        green = BaseWars:GetTheme("button_green")
	}

	parent.Button = parent:Add("BaseWars.Button2")
	parent.Button:Dock(BOTTOM)
	parent.Button:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	parent.Button:SetTall(buttonSize)
	parent.Button:SetColor(theme.contentBackground, true)
	parent.Button.Draw = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_promote"), "BaseWars.20", w * .5, h * .5, theme.text, 1, 1)
	end
	parent.Button.DoClick = function(s)
		local name = localPlayer:GetFaction()

		if not localPlayer:InFaction() then
			BaseWars:Notify("#faction_notInFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if localPlayer == parent.selectedPlayer then
			BaseWars:Notify("#faction_cantDoToYourself", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if not localPlayer:HasSameFaction(parent.selectedPlayer) then
			BaseWars:Notify("#faction_differentFaction", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		if BaseWars:GetFactionLeader(name) != localPlayer then
			BaseWars:Notify("#faction_notLeader", NOTIFICATION_ERROR, 5)
			s:Disable(1.5, theme.disabled, s.Draw)

			return
		end

		s:ButtonSound()
		s:CustomTempDraw(1.5, theme.green, s.Draw)

		localPlayer:TransferFactionLeadership(parent.selectedPlayer)
	end
end)

--[[-------------------------------------------------------------------------
	Promote Faction Leader
---------------------------------------------------------------------------]]
BaseWars:AddFactionInteraction("faction_frendlyFire", buttonSize + bigMargin * 2, function(parent)
	local localPlayer = LocalPlayer()
	local name = localPlayer:GetFaction()
	local bool = localPlayer:InFaction() and BaseWars:GetFactions(name).ff or false
	local theme = {
		text = BaseWars:GetTheme("bwm_text"),
		contentBackground = BaseWars:GetTheme("bwm_contentBackground"),
		disabled = BaseWars:GetTheme("button_disabled")
	}

	parent.BackPanel = parent:Add("DPanel")
	parent.BackPanel:Dock(BOTTOM)
	parent.BackPanel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	parent.BackPanel:SetTall(buttonSize)
	parent.BackPanel.Paint = function(s,w,h)
		draw.SimpleText(localPlayer:GetLang("faction_frendlyFire"), "BaseWars.18", bigMargin, h * .5, BaseWars:GetTheme("bwn_text"), 0, 1)
	end

	parent.BackPanel.Toggle = parent.BackPanel:Add("BaseWars.CheckBox")
	parent.BackPanel.Toggle:Dock(RIGHT)
	parent.BackPanel.Toggle:DockMargin(0, margin, 0, margin)
	parent.BackPanel.Toggle:SetWide(BaseWars.ScreenScale * 80)
	parent.BackPanel.Toggle:SetState(bool)
	parent.BackPanel.Toggle.time = 0
	parent.BackPanel.Toggle.Toggle = function(s)
		if localPlayer:InRaid() then
			BaseWars:Notify("#faction_inRaid", NOTIFICATION_ERROR, 5)

			return
		end

		if not localPlayer:InFaction() then
			BaseWars:Notify("#faction_notInFaction", NOTIFICATION_ERROR, 5)

			return
		end

		if not BaseWars:FactionExists(name) then
			BaseWars:Notify("#faction_dontExist", NOTIFICATION_ERROR, 5, name)

			return
		end

		if BaseWars:GetFactionLeader(name) != localPlayer then
			BaseWars:Notify("#faction_notLeader", NOTIFICATION_ERROR, 5)

			return
		end

		if CurTime() < s.time then
			return
		end

		surface.PlaySound("bw_button.wav")
		s:SetState(not s:GetState())

		localPlayer:ChangeFactionFriendlyFire(s:GetState())

		s.time = CurTime() + .5
	end
end)