local trash = Material("basewars_materials/trash.png", "smooth")
local plus = Material("basewars_materials/plus.png", "smooth")

local buttonSize = BaseWars.ScreenScale * 36
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local PANEL = {}
function PANEL:Init()
	self.w, self.h = self:GetParent():GetSize()
	self.localPlayer = LocalPlayer()
	self.configPanel = "player"
	self.config = table.Copy(BaseWars.Config)
	self.somethingChanged = false

	if BaseWars:IsSuperAdmin(self.localPlayer) then
		self.Topbar = self:Add("DPanel")
		self.Topbar:Dock(TOP)
		self.Topbar:DockMargin(bigMargin, bigMargin, bigMargin, 0)
		self.Topbar:SetTall(buttonSize + bigMargin * 2)
		self.Topbar.Paint = function(s,w,h)
			BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("bwm_contentBackground"))
		end
		self.Topbar.Think = function(s)
			if not BaseWars:IsSuperAdmin(self.localPlayer) then
				s:Remove()
			end
		end

		self.Topbar.PlayerConfig = self.Topbar:Add("OLD.BaseWars.Button")
		self.Topbar.PlayerConfig:Dock(LEFT)
		self.Topbar.PlayerConfig:DockMargin(bigMargin, bigMargin, 0, bigMargin)
		self.Topbar.PlayerConfig:SetWide((self.w - bigMargin * 5) * .5)
		self.Topbar.PlayerConfig:DrawSide(true, true)
		self.Topbar.PlayerConfig.Draw = function(s,w,h)
			draw.SimpleText(self.localPlayer:GetLang("config_playerConfig"), "BaseWars.24", w * .5, h * .5, GetBaseWarsTheme("bwm_text"), 1, 1)
		end
		self.Topbar.PlayerConfig.DoClick = function(s)
			if self.configPanel == "player" then return end

			s:ButtonSound()
			self:Build("player")
		end

		self.Topbar.GamemodeConfig = self.Topbar:Add("OLD.BaseWars.Button")
		self.Topbar.GamemodeConfig:Dock(RIGHT)
		self.Topbar.GamemodeConfig:DockMargin(0, bigMargin, bigMargin, bigMargin)
		self.Topbar.GamemodeConfig:SetWide((self.w - bigMargin * 5) * .5)
		self.Topbar.GamemodeConfig:DrawSide(true, true)
		self.Topbar.GamemodeConfig.Draw = function(s,w,h)
			draw.SimpleText(self.localPlayer:GetLang("config_gamemodeConfig"), "BaseWars.24", w * .5, h * .5, GetBaseWarsTheme("bwm_text"), 1, 1)
		end
		self.Topbar.GamemodeConfig.DoClick = function(s)
			if self.configPanel == "gamemode" then return end

			s:ButtonSound()
			self:Build("gamemode")
		end
	end

	self.Content = self:Add("DScrollPanel")
	self.Content:Dock(FILL)
	self.Content:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Content:PaintScrollBar("bwm")

	self:Build("player")
end

function PANEL:Think()
	if not BaseWars:IsSuperAdmin(self.localPlayer) and self.configPanel == "gamemode" then
		self:Build("player")
	end
end

function PANEL:Build(config, filter)
	for _, v in ipairs(self.Content:GetCanvas():GetChildren()) do
		v:Remove()
	end

	if config == "gamemode" and BaseWars:IsSuperAdmin(self.localPlayer) then
		self.configPanel = "gamemode"

		if not IsValid(self.Top) then
			self.Top = self:Add("DPanel")
			self.Top:Dock(TOP)
			self.Top:DockMargin(bigMargin, bigMargin, bigMargin, 0)
			self.Top:SetTall(buttonSize + bigMargin * 2)
			self.Top.Paint = function(s,w,h)
				BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("bwm_contentBackground"))
			end
			self.Top.Think = function(s)
				if not BaseWars:IsSuperAdmin(self.localPlayer) or self.configPanel == "player" then
					s:Remove()
				end
			end

			self.Top.Filter = self.Top:Add("BaseWars.TextEntry")
			self.Top.Filter:Dock(FILL)
			self.Top.Filter:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
			self.Top.Filter:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
			self.Top.Filter:SetTextColor(GetBaseWarsTheme("bwm_text"))
			self.Top.Filter:SetFont("BaseWars.18")
			self.Top.Filter:SetPlaceHolder(self.localPlayer:GetLang("search"))
			self.Top.Filter:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
			self.Top.Filter:RequestFocus()
			self.Top.Filter.OnChange = function(s,text)
				self:Build("gamemode", text)
			end
		end

		if not IsValid(self.Bottom) then
			self.Bottom = self:Add("DPanel")
			self.Bottom:Dock(BOTTOM)
			self.Bottom:DockMargin(bigMargin, 0, bigMargin, bigMargin)
			self.Bottom:SetTall(buttonSize + bigMargin * 2)
			self.Bottom.Paint = function(s,w,h)
				BaseWars:DrawRoundedBox(4, 0, 0, w, h, GetBaseWarsTheme("bwm_contentBackground"))
			end
			self.Bottom.Think = function(s)
				if not BaseWars:IsSuperAdmin(self.localPlayer) or self.configPanel == "player" then
					s:Remove()
				end
			end

			self.SaveConfig = self.Bottom:Add("OLD.BaseWars.Button")
			self.SaveConfig:Dock(LEFT)
			self.SaveConfig:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
			self.SaveConfig:SetWide((self.w - bigMargin * 5) * .5)
			self.SaveConfig:DrawSide(true, true)
			self.SaveConfig.Draw = function(s,w,h)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_saveConfig"), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("bwm_text"), 1, 1)
			end
			self.SaveConfig.DoClick = function(s)
				if not self.somethingChanged then return end
				if not BaseWars:IsSuperAdmin(self.localPlayer) then return end

				s:ButtonSound()

				local compressed = util.Compress(util.TableToJSON(self.config))
				net.Start("BaseWars:GamemodeConfigModified")
					net.WriteData(compressed, #compressed)
				net.SendToServer()
			end

			self.ResetConfig = self.Bottom:Add("OLD.BaseWars.Button")
			self.ResetConfig:Dock(RIGHT)
			self.ResetConfig:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
			self.ResetConfig:SetWide((self.w - bigMargin * 5) * .5)
			self.ResetConfig:DrawSide(true, true)
			self.ResetConfig.Draw = function(s,w,h)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_resetConfig"), "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("bwm_text"), 1, 1)
			end
			self.ResetConfig.DoClick = function(s)
				if not BaseWars:IsSuperAdmin(self.localPlayer) then
					return
				end

				s:ButtonSound()

				self.config = table.Copy(BaseWars.DefaultConfig)
				self.Top.Filter:SetText("")
				self:Build("gamemode")

				local compressed = util.Compress(util.TableToJSON(BaseWars.DefaultConfig))
				net.Start("BaseWars:GamemodeConfigModified")
					net.WriteData(compressed, #compressed)
				net.SendToServer()
			end
		end

		local configTyped = {}
		for k, v in SortedPairs(self.config) do
			configTyped[k] = {
				value = v,
				type = type(v)
			}
		end

		for k, v in SortedPairsByMemberValue(configTyped, "type") do
			local isTable = v.type == "table"

			if filter then
				filter = string.lower(filter)
				local name = string.lower(self.localPlayer:GetLang("gamemodeConfig_" .. k .. "Name"))
				local desc = string.lower(self.localPlayer:GetLang("gamemodeConfig_" .. k .. "Desc"))
				local configID = string.lower(k)

				if string.find(name .. ";" .. desc .. ";" .. configID, filter) == nil then
					continue
				end
			end

			local configPanel = self.Content:Add("DPanel")
			configPanel:Dock(TOP)
			configPanel:DockMargin(0, 0, margin, margin)
			configPanel:SetTall(buttonSize + bigMargin * 2)
			configPanel.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			configPanel.Paint = function(s,w,h)
				if not isTable then
					s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))
				end

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_" .. k .. "Name"), "BaseWars.22", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_" .. k .. "Desc"), "BaseWars.18", bigMargin, h * .5, GetBaseWarsTheme("bwm_darkText"), 0, TEXT_ALIGN_TOP)
			end

			if isTable then
				configPanel.SubPanel = self.Content:Add("DPanel")
				configPanel.SubPanel:Dock(TOP)
				configPanel.SubPanel:DockMargin(bigMargin * 8, 0, margin, margin)
				configPanel.SubPanel.Paint = nil

				self:BuildTable(k, configPanel, configPanel.SubPanel)
			else
				self:BuildAction(v.type, configPanel, v.value, self.config, k)
			end
		end
	else
		self.configPanel = "player"

		for k, v in SortedPairsByMemberValue(BaseWars.DefaultPlayerConfig, "type") do
			local configPanel = self.Content:Add("DPanel")
			configPanel:Dock(TOP)
			configPanel:DockMargin(0, 0, margin, margin)
			configPanel:SetTall(buttonSize + bigMargin * 2)
			configPanel.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			configPanel.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(self.localPlayer:GetLang("f3config", k .. "Name"), "BaseWars.22", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(self.localPlayer:GetLang("f3config", k .. "Desc"):format(input.LookupBinding("gm_showspare2") or "?"), "BaseWars.18", bigMargin, h * .5, GetBaseWarsTheme("bwm_darkText"), 0, TEXT_ALIGN_TOP)
			end

			if v.type == "boolean" then
				configPanel.Action = configPanel:Add("BaseWars.CheckBox")
				configPanel.Action:Dock(RIGHT)
				configPanel.Action:DockMargin(0, bigMargin * 1.5, bigMargin, bigMargin * 1.5)
				configPanel.Action:SetWide(BaseWars.ScreenScale * 80)
				configPanel.Action:SetState(self.localPlayer:GetBaseWarsConfig(k), true)
				configPanel.Action.OnToggle = function(s, state)
					SetBaseWarsConfig(k, state)
				end
			end

			if v.choices then
				configPanel.Action = configPanel:Add("OLD.BaseWars.Button")
				configPanel.Action:Dock(RIGHT)
				configPanel.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
				configPanel.Action:SetWide(BaseWars.ScreenScale * 150)
				configPanel.Action:DrawSide(true, true)
				configPanel.Action.value = self.localPlayer:GetBaseWarsConfig(k)
				configPanel.Action.Draw = function(s,w,h)
					draw.SimpleText(v.choices[s.value] or "???", "BaseWars.20", w * .5, h * .5, GetBaseWarsTheme("bwm_text"), 1, 1)
				end
				configPanel.Action.DoClick = function(s)
					if table.Count(v.choices) <= 1 then return end

					s:ButtonSound()

					local x, y = s:LocalToScreen()
					local _, h = s:GetSize()

					local dropDown = BaseWars:DropdownPopup(x, y + h + margin)
					for id, name in SortedPairs(v.choices) do
						if id == s.value then continue end

						dropDown:AddChoice(name, function()
							SetBaseWarsConfig(k, id)
							s.value = id
						end)
					end
				end
			end
		end
	end
end

function PANEL:BuildTable(key, parent, subParent)
	local tbl = self.config[key]
	local tblC = table.Count(tbl)

	if key == "PrinterCap" then
		if tblC <= 0 then
			subParent:SetTall(bigMargin)
		else
			subParent:SetTall((buttonSize + bigMargin * 2) * tblC + margin * (tblC - 1))
		end

		for k, v in SortedPairs(tbl) do
			local item = subParent:Add("DPanel")
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, margin)
			item:SetTall(buttonSize + bigMargin * 2)
			item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(k, "BaseWars.22", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, TEXT_ALIGN_CENTER)
			end

			self:BuildAction(type(v), item, v, self.config[key], k)

			item.RemoveItem = item:Add("DButton")
			item.RemoveItem:SetText("")
			item.RemoveItem:Dock(RIGHT)
			item.RemoveItem:DockMargin(0, bigMargin, bigMargin, bigMargin)
			item.RemoveItem:SetWide(item:GetTall() - bigMargin * 2)
			item.RemoveItem.color = GetBaseWarsTheme("bwm_darkText")
			item.RemoveItem.Paint = function(s,w,h)
				s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
				BaseWars:DrawMaterial(trash, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
			end
			item.RemoveItem.DoClick = function(s)
				surface.PlaySound("bw_button.wav")

				item:Remove()
				self.config[key][k] = nil
				self.somethingChanged = true

				subParent:Clear()
				self:BuildTable(key, parent, subParent)
			end
		end

		if IsValid(parent.Action) and IsValid(parent.UserGroup) or IsValid(parent.Number) then
			parent.UserGroup:SetText("")
			parent.Number:SetText("")
			return
		end

		parent.Action = parent:Add("DButton")
		parent.Action:SetText("")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(parent:GetTall() - bigMargin * 2)
		parent.Action.color = GetBaseWarsTheme("bwm_darkText")
		parent.Action.Paint = function(s,w,h)
			s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
			BaseWars:DrawMaterial(plus, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
		end
		parent.Action.DoClick = function(s)
			local userGroup = parent.UserGroup:GetText()
			local num = tonumber(parent.Number:GetText()) or 0

			if #userGroup <= 0 then
				return
			end

			if num < 1 then
				return
			end

			if self.config[key][userGroup] then
				return
			end

			surface.PlaySound("bw_button.wav")
			self.config[key][userGroup] = num
			self.somethingChanged = true

			subParent:Clear()
			self:BuildTable(key, parent, subParent)
		end

		parent.Number = parent:Add("BaseWars.TextEntry")
		parent.Number:Dock(RIGHT)
		parent.Number:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Number:SetWide(BaseWars.ScreenScale * 120)
		parent.Number:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.Number:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.Number:SetFont("BaseWars.18")
		parent.Number:SetPlaceHolder(self.localPlayer:GetLang("config_number"))
		parent.Number:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.Number:SetNumeric(true)

		parent.UserGroup = parent:Add("BaseWars.TextEntry")
		parent.UserGroup:Dock(RIGHT)
		parent.UserGroup:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.UserGroup:SetWide(BaseWars.ScreenScale * 120)
		parent.UserGroup:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.UserGroup:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.UserGroup:SetFont("BaseWars.18")
		parent.UserGroup:SetPlaceHolder(self.localPlayer:GetLang("gamemodeConfig_userGroup"))
		parent.UserGroup:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
	end

	if BaseWars.DefaultConfigType[key] == BWCONFIGTYPE_KEYVALUE then
		if tblC <= 0 then
			subParent:SetTall(bigMargin)
		else
			subParent:SetTall((buttonSize + bigMargin * 2) * tblC + margin * (tblC - 1))
		end

		for k, v in SortedPairs(tbl) do
			local item = subParent:Add("DPanel")
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, margin)
			item:SetTall(buttonSize + bigMargin * 2)
			item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_" .. key, k .. "Name"), "BaseWars.22", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(self.localPlayer:GetLang("gamemodeConfig_" .. key, k .. "Desc"), "BaseWars.18", bigMargin, h * .5, GetBaseWarsTheme("bwm_darkText"), 0, TEXT_ALIGN_TOP)
			end

			self:BuildAction(type(v), item, v, self.config[key], k)
		end
	end

	if key == "FormatNumber" then
		if tblC <= 0 then
			subParent:SetTall(bigMargin)
		else
			subParent:SetTall((buttonSize + bigMargin * 2) * tblC + margin * (tblC - 1))
		end

		for k, v in SortedPairs(tbl) do
			local item = subParent:Add("DPanel")
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, margin)
			item:SetTall(buttonSize + bigMargin * 2)
			item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(v[2] .. " [" .. v[3] .. "]", "BaseWars.20", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, 1)
			end

			item.RemoveItem = item:Add("DButton")
			item.RemoveItem:SetText("")
			item.RemoveItem:Dock(RIGHT)
			item.RemoveItem:DockMargin(0, bigMargin, bigMargin, bigMargin)
			item.RemoveItem:SetWide(item:GetTall() - bigMargin * 2)
			item.RemoveItem.color = GetBaseWarsTheme("bwm_darkText")
			item.RemoveItem.Paint = function(s,w,h)
				s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
				BaseWars:DrawMaterial(trash, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
			end
			item.RemoveItem.DoClick = function(s)
				surface.PlaySound("bw_button.wav")

				item:Remove()
				self.config[key][k] = nil
				self.somethingChanged = true

				subParent:Clear()
				self:BuildTable(key, parent, subParent)
			end
		end

		if IsValid(parent.Action) and IsValid(parent.Number) and IsValid(parent.Text) and IsValid(parent.ShortText) then
			parent.Number:SetText("")
			parent.Text:SetText("")
			parent.ShortText:SetText("")
			return
		end

		parent.Action = parent:Add("DButton")
		parent.Action:SetText("")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(parent:GetTall() - bigMargin * 2)
		parent.Action.color = GetBaseWarsTheme("bwm_darkText")
		parent.Action.Paint = function(s,w,h)
			s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
			BaseWars:DrawMaterial(plus, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
		end
		parent.Action.DoClick = function(s)
			local num = tonumber(parent.Number:GetText()) or 0
			local text = parent.Text:GetText()
			local short = parent.ShortText:GetText()

			if #text <= 0 or #short <= 0 or num <= 0 then
				return
			end

			local x = {}
			x[1] = num
			x[2] = text
			x[3] = short

			if table.HasValue(self.config[key], x) then
				return
			end

			surface.PlaySound("bw_button.wav")
			table.insert(self.config[key], x)
			self.somethingChanged = true

			subParent:Clear()
			self:BuildTable(key, parent, subParent)
		end

		parent.ShortText = parent:Add("BaseWars.TextEntry")
		parent.ShortText:Dock(RIGHT)
		parent.ShortText:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.ShortText:SetWide(BaseWars.ScreenScale * 60)
		parent.ShortText:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.ShortText:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.ShortText:SetFont("BaseWars.18")
		parent.ShortText:SetPlaceHolder(self.localPlayer:GetLang("gamemodeConfig_shortText"))
		parent.ShortText:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))

		parent.Text = parent:Add("BaseWars.TextEntry")
		parent.Text:Dock(RIGHT)
		parent.Text:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Text:SetWide(BaseWars.ScreenScale * 120)
		parent.Text:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.Text:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.Text:SetFont("BaseWars.18")
		parent.Text:SetPlaceHolder(self.localPlayer:GetLang("config_string"))
		parent.Text:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))

		parent.Number = parent:Add("BaseWars.TextEntry")
		parent.Number:Dock(RIGHT)
		parent.Number:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Number:SetWide(BaseWars.ScreenScale * 120)
		parent.Number:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.Number:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.Number:SetFont("BaseWars.18")
		parent.Number:SetPlaceHolder(self.localPlayer:GetLang("config_number"))
		parent.Number:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
	end

	if BaseWars.DefaultConfigType[key] == BWCONFIGTYPE_NOKEY then
		if tblC <= 0 then
			subParent:SetTall(bigMargin)
		else
			if key == "WhitelistProps" then
				subParent:SetTall((buttonSize * 2) * math.ceil(tblC / 13) + margin * (math.ceil(tblC / 13) - 1))
			else
				subParent:SetTall((buttonSize + bigMargin * 2) * tblC + margin * (tblC - 1))
			end
		end

		if key == "WhitelistProps" then
			subParent.layout = subParent:Add("DIconLayout")
			subParent.layout:Dock(FILL)
			subParent.layout:SetSpaceX(margin)
			subParent.layout:SetSpaceY(margin)

			for k, v in ipairs(tbl) do
				local item = subParent.layout:Add("DButton")
				item:SetSize(buttonSize * 2, buttonSize * 2)
				item:SetText("")
				item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
				item.Paint = function(s,w,h)
					s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

					BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				end
				item.DoClick = function(s)
					surface.PlaySound("bw_button.wav")

					s:Remove()
					self.config[key][k] = nil
					self.somethingChanged = true
				end

				item.Model = item:Add("DModelPanel")
				item.Model:SetMouseInputEnabled(false)
				item.Model.LayoutEntity = function() end
				item.Model:Dock(FILL)
				item.Model:SetModel(v or "error.mdl")
				if IsValid(item.Model.Entity) then
					local mn, mx = item.Model.Entity:GetRenderBounds()
					local size = 0
					size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
					size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
					size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
					item.Model:SetFOV(60)
					item.Model:SetCamPos(Vector(size, size, size))
					item.Model:SetLookAt((mn + mx) * 0.5)
				end
			end
		else
			for k, v in ipairs(tbl) do
				local text = v

				if key == "BanBypass" then
					BaseWars:RequestSteamName(v, function(name)
						text = text .. " (" .. name .. ")"
					end)
				end

				local item = subParent:Add("DPanel")
				item:Dock(TOP)
				item:DockMargin(0, 0, 0, margin)
				item:SetTall(buttonSize + bigMargin * 2)
				item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
				item.Paint = function(s,w,h)
					s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

					BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
					draw.SimpleText(text, "BaseWars.20", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, 1)
				end

				item.RemoveItem = item:Add("DButton")
				item.RemoveItem:SetText("")
				item.RemoveItem:Dock(RIGHT)
				item.RemoveItem:DockMargin(0, bigMargin, bigMargin, bigMargin)
				item.RemoveItem:SetWide(item:GetTall() - bigMargin * 2)
				item.RemoveItem.color = GetBaseWarsTheme("bwm_darkText")
				item.RemoveItem.Paint = function(s,w,h)
					s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
					BaseWars:DrawMaterial(trash, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
				end
				item.RemoveItem.DoClick = function(s)
					surface.PlaySound("bw_button.wav")

					item:Remove()
					table.RemoveByValue(self.config[key], v)
					self.somethingChanged = true

					subParent:Clear()
					self:BuildTable(key, parent, subParent)
				end
			end
		end

		if IsValid(parent.Action) and IsValid(parent.TextEntry) then
			parent.TextEntry:SetText("")
			return
		end

		parent.Action = parent:Add("DButton")
		parent.Action:SetText("")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(parent:GetTall() - bigMargin * 2)
		parent.Action.color = GetBaseWarsTheme("bwm_darkText")
		parent.Action.Paint = function(s,w,h)
			s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
			BaseWars:DrawMaterial(plus, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
		end
		parent.Action.DoClick = function(s)
			local text = parent.TextEntry:GetText()

			if #text <= 0 then
				return
			end

			if table.HasValue(self.config[key], text) then
				return
			end

			surface.PlaySound("bw_button.wav")
			table.insert(self.config[key], text)
			self.somethingChanged = true

			subParent:Clear()
			self:BuildTable(key, parent, subParent)
		end

		local placeHolder = ""
		if key == "SpawnWeaps" then
			placeHolder = "weaponClass"
		elseif key == "BanBypass" then
			placeHolder = "steamID64"
		else
			placeHolder = "model"
		end

		parent.TextEntry = parent:Add("BaseWars.TextEntry")
		parent.TextEntry:Dock(RIGHT)
		parent.TextEntry:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.TextEntry:SetWide(BaseWars.ScreenScale * 120)
		parent.TextEntry:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.TextEntry:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.TextEntry:SetFont("BaseWars.18")
		parent.TextEntry:SetPlaceHolder(self.localPlayer:GetLang("gamemodeConfig_" .. placeHolder))
		parent.TextEntry:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
	end

	if BaseWars.DefaultConfigType[key] == BWCONFIGTYPE_KEY then
		if tblC <= 0 then
			subParent:SetTall(bigMargin)
		else
			subParent:SetTall((buttonSize + bigMargin * 2) * tblC + margin * (tblC - 1))
		end

		for k, v in SortedPairs(tbl) do
			local item = subParent:Add("DPanel")
			item:Dock(TOP)
			item:DockMargin(0, 0, 0, margin)
			item:SetTall(buttonSize + bigMargin * 2)
			item.lerpColor = GetBaseWarsTheme("bwm_contentBackground")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, (s:IsHovered() or s:IsChildHovered()) and GetBaseWarsTheme("bwm_contentBackground2") or GetBaseWarsTheme("bwm_contentBackground"))

				BaseWars:DrawRoundedBox(4, 0, 0, w, h, s.lerpColor)
				draw.SimpleText(k, "BaseWars.20", bigMargin, h * .5, GetBaseWarsTheme("bwm_text"), 0, 1)
			end

			item.RemoveItem = item:Add("DButton")
			item.RemoveItem:SetText("")
			item.RemoveItem:Dock(RIGHT)
			item.RemoveItem:DockMargin(0, bigMargin, bigMargin, bigMargin)
			item.RemoveItem:SetWide(item:GetTall() - bigMargin * 2)
			item.RemoveItem.color = GetBaseWarsTheme("bwm_darkText")
			item.RemoveItem.Paint = function(s,w,h)
				s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
				BaseWars:DrawMaterial(trash, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
			end
			item.RemoveItem.DoClick = function(s)
				surface.PlaySound("bw_button.wav")

				item:Remove()
				self.config[key][k] = nil
				self.somethingChanged = true

				subParent:Clear()
				self:BuildTable(key, parent, subParent)
			end
		end

		if IsValid(parent.Action) and IsValid(parent.TextEntry) then
			parent.TextEntry:SetText("")
			return
		end

		parent.Action = parent:Add("DButton")
		parent.Action:SetText("")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(parent:GetTall() - bigMargin * 2)
		parent.Action.color = GetBaseWarsTheme("bwm_darkText")
		parent.Action.Paint = function(s,w,h)
			s.color = BaseWars:LerpColor(FrameTime() * 20, s.color, s:IsHovered() and GetBaseWarsTheme("gen_accent") or GetBaseWarsTheme("bwm_darkText"))
			BaseWars:DrawMaterial(plus, w * .5, h * .5, h - bigMargin * 1.5, h - bigMargin * 1.5, s.color, 0)
		end
		parent.Action.DoClick = function(s)
			local userGroup = parent.TextEntry:GetText()

			if #userGroup <= 0 then
				return
			end

			if self.config[key][userGroup] then
				return
			end

			surface.PlaySound("bw_button.wav")
			self.config[key][userGroup] = true
			self.somethingChanged = true

			subParent:Clear()
			self:BuildTable(key, parent, subParent)
		end

		local placeHolder = ""
		if key == "VIP" or key == "Admins" or key == "SuperAdmins" then
			placeHolder = "userGroup"
		elseif key == "WeaponDropBlacklist" then
			placeHolder = "weaponClass"
		elseif key == "CategoryBlackList" then
			placeHolder = "category"
		elseif key == "PhysgunPickupBlocked" then
			placeHolder = "entityClass"
		else
			placeHolder = "tool"
		end

		parent.TextEntry = parent:Add("BaseWars.TextEntry")
		parent.TextEntry:Dock(RIGHT)
		parent.TextEntry:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.TextEntry:SetWide(BaseWars.ScreenScale * 120)
		parent.TextEntry:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.TextEntry:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.TextEntry:SetFont("BaseWars.18")
		parent.TextEntry:SetPlaceHolder(self.localPlayer:GetLang("gamemodeConfig_" .. placeHolder))
		parent.TextEntry:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
	end
end

function PANEL:BuildAction(type, parent, defaultValue, tbl, key)
	if type == "boolean" then
		parent.Action = parent:Add("BaseWars.CheckBox")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin * 1.5, bigMargin, bigMargin * 1.5)
		parent.Action:SetWide(BaseWars.ScreenScale * 80)
		parent.Action:SetState(defaultValue, true)
		parent.Action.OnToggle = function(s, state)
			tbl[key] = state
			self.somethingChanged = true
		end
	end

	if type == "number" then
		parent.Action = parent:Add("BaseWars.TextEntry")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(BaseWars.ScreenScale * 120)
		parent.Action:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.Action:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.Action:SetFont("BaseWars.18")
		parent.Action:SetPlaceHolder(self.localPlayer:GetLang("config_number"))
		parent.Action:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.Action:SetNumeric(true)
		parent.Action:SetText(defaultValue)
		parent.Action.OnChange = function(s, text)
			local num = tonumber(text) or 0

			tbl[key] = num
			self.somethingChanged = true
		end
	end

	if type == "string" then
		parent.Action = parent:Add("BaseWars.TextEntry")
		parent.Action:Dock(RIGHT)
		parent.Action:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.Action:SetWide(BaseWars.ScreenScale * 120)
		parent.Action:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.Action:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.Action:SetFont("BaseWars.18")
		parent.Action:SetPlaceHolder(self.localPlayer:GetLang("config_string"))
		parent.Action:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.Action:SetText(defaultValue)
		parent.Action.OnChange = function(s, text)
			tbl[key] = text
			self.somethingChanged = true
		end
	end

	if type == "Vector" then
		parent.VectorZ = parent:Add("BaseWars.TextEntry")
		parent.VectorZ:Dock(RIGHT)
		parent.VectorZ:DockMargin(0, bigMargin, bigMargin, bigMargin)
		parent.VectorZ:SetWide(BaseWars.ScreenScale * 120)
		parent.VectorZ:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.VectorZ:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.VectorZ:SetFont("BaseWars.18")
		parent.VectorZ:SetPlaceHolder(self.localPlayer:GetLang("config_vector_z"))
		parent.VectorZ:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.VectorZ:SetNumeric(true)
		parent.VectorZ:SetText(defaultValue.z)
		parent.VectorZ.OnChange = function(s, text)
			local num = tonumber(text) or 0

			tbl[key].z = num
			self.somethingChanged = true
		end

		parent.VectorY = parent:Add("BaseWars.TextEntry")
		parent.VectorY:Dock(RIGHT)
		parent.VectorY:DockMargin(0, bigMargin, margin, bigMargin)
		parent.VectorY:SetWide(BaseWars.ScreenScale * 120)
		parent.VectorY:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.VectorY:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.VectorY:SetFont("BaseWars.18")
		parent.VectorY:SetPlaceHolder(self.localPlayer:GetLang("config_vector_y"))
		parent.VectorY:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.VectorY:SetNumeric(true)
		parent.VectorY:SetText(defaultValue.y)
		parent.VectorY.OnChange = function(s, text)
			local num = tonumber(text) or 0

			tbl[key].y = num
			self.somethingChanged = true
		end

		parent.VectorX = parent:Add("BaseWars.TextEntry")
		parent.VectorX:Dock(RIGHT)
		parent.VectorX:DockMargin(0, bigMargin, margin, bigMargin)
		parent.VectorX:SetWide(BaseWars.ScreenScale * 120)
		parent.VectorX:SetColor(GetBaseWarsTheme("bwm_contentBackground2"))
		parent.VectorX:SetTextColor(GetBaseWarsTheme("bwm_text"))
		parent.VectorX:SetFont("BaseWars.18")
		parent.VectorX:SetPlaceHolder(self.localPlayer:GetLang("config_vector_x"))
		parent.VectorX:SetPlaceHolderColor(GetBaseWarsTheme("bwm_darkText"))
		parent.VectorX:SetNumeric(true)
		parent.VectorX:SetText(defaultValue.x)
		parent.VectorX.OnChange = function(s, text)
			local num = tonumber(text) or 0

			tbl[key].x = num
			self.somethingChanged = true
		end
	end
end

function PANEL:Paint(w,h)
end

vgui.Register("BaseWars.F3Menu.Config", PANEL, "DPanel")