local icons = {
	close = Material("basewars_materials/close.png", "smooth"),
	copy = Material("basewars_materials/copy.png", "smooth"),
	favorite = Material("basewars_materials/f4/favorite.png", "smooth")
}
local cardH = BaseWars.ScreenScale * 80
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.localPlayer = LocalPlayer()

	if self.localPlayer.F4SavedPanel then
		self.localPlayer.F4SavedPanel = math.Clamp(self.localPlayer.F4SavedPanel, 1, table.Count(BaseWars:GetShopList()))
	end

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)

	--[[-------------------------------------------------------------------
		FRAME
	---------------------------------------------------------------------]]

	self.Frame = self:Add("DPanel")
	self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
	self.Frame:Center()
	self.Frame.Paint = nil

	self.Frame.Topbar = self.Frame:Add("DPanel")
	self.Frame.Topbar:Dock(TOP)
	self.Frame.Topbar:SetTall(BaseWars.ScreenScale * 40)
	self.Frame.Topbar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, GetBaseWarsTheme("bws_titleBar"), true, true, false, false)
		draw.SimpleText("- BaseWars Shop -", "BaseWars.26", w * .5, h * .5, color_white, 1, 1)
	end

	--[[-------------------------------------------------------------------
		NAVIGATION
	---------------------------------------------------------------------]]

	self.Frame.Sidebar = self.Frame:Add("DPanel")
	self.Frame.Sidebar:Dock(LEFT)
	self.Frame.Sidebar:SetWide(BaseWars.ScreenScale * 220)
	self.Frame.Sidebar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, GetBaseWarsTheme("bws_background"), false, false, true, false)
	end

	self.Frame.Sidebar.Player = self.Frame.Sidebar:Add("DPanel")
	self.Frame.Sidebar.Player:Dock(TOP)
	self.Frame.Sidebar.Player:SetTall(BaseWars.ScreenScale * 70)
	self.Frame.Sidebar.Player.Paint = function(s,w,h)
		local plyName = self.localPlayer:Name()
		local plyMoney = BaseWars:FormatMoney(self.localPlayer:GetMoney())

		draw.SimpleText(plyName, "BaseWars.20", h, h * .5 + 1, GetBaseWarsTheme("bws_text"), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(plyMoney, "BaseWars.18", h, h * .5 - 1, GetBaseWarsTheme("bws_darkText"), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	self.Frame.Sidebar.Player = self.Frame.Sidebar.Player:Add("AvatarMaterial")
	self.Frame.Sidebar.Player:SetPos(bigMargin, bigMargin)
	self.Frame.Sidebar.Player:SetSize(BaseWars.ScreenScale * 50, BaseWars.ScreenScale * 50)
	self.Frame.Sidebar.Player:SetPlayer(self.localPlayer)

	self.Frame.Sidebar.Scroll = self.Frame.Sidebar:Add("DScrollPanel")
	self.Frame.Sidebar.Scroll:GetVBar():SetWide(0)
	self.Frame.Sidebar.Scroll:Dock(FILL)

	self.Frame.Sidebar.Close = self.Frame.Sidebar:Add("OLD.BaseWars.Button")
	self.Frame.Sidebar.Close:Dock(BOTTOM)
	self.Frame.Sidebar.Close:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Frame.Sidebar.Close.Draw = function(s,w,h)
		local textColor = GetBaseWarsTheme("bws_text")

		BaseWars:DrawMaterial(icons["close"], bigMargin * 1.5, bigMargin, h - bigMargin * 2, h - bigMargin * 2, textColor)
		draw.SimpleText(self.localPlayer:GetLang("close"), "BaseWars.20", h * 1.1, h * .5, textColor, 0, 1)
	end
	self.Frame.Sidebar.Close.DoClick = function(s)
		s:ButtonSound()
		BaseWars:CloseF4Menu()
	end

	self.CurrentPanel = self.localPlayer.F4SavedPanel or 1
	for k, v in ipairs(BaseWars:GetShopList()) do
		if v.lockUntil and not v.lockUntil(self.localPlayer) then
			continue
		end

		local NavButton = self.Frame.Sidebar.Scroll:Add("OLD.BaseWars.Button")
		NavButton:Dock(TOP)
		NavButton:DockMargin(bigMargin, margin, bigMargin, 0)
		NavButton:SetAccentColor(v.color)
		NavButton.Draw = function(s,w,h)
			local textColor = GetBaseWarsTheme("bws_text")

			BaseWars:DrawMaterial(v.icon, bigMargin * 1.5, bigMargin, h - bigMargin * 2, h - bigMargin * 2, textColor)
			draw.SimpleText(v.name, "BaseWars.20", h * 1.1, h * .5, textColor, 0, 1)
		end
		NavButton.LerpFunc = function(s)
			return s:IsHovered() or self.CurrentPanel == k
		end
		NavButton.DoClick = function(s)
			if self.CurrentPanel == k then return end
			if IsValid(self.Frame.Body.OldContentPanel) then return end

			surface.PlaySound("bw_button.wav")

			self.localPlayer.F4SavedPanel = k
			self.CurrentPanel = k

			if k == 1 then
				self:BuildFavorites()
			else
				self:Build(v.subCategories, true)
			end
		end
	end

	--[[-------------------------------------------------------------------
		BODY
	---------------------------------------------------------------------]]

	self.Frame.Body = self.Frame:Add("DPanel")
	self.Frame.Body:Dock(FILL)
	self.Frame.Body:InvalidateParent(true)
	self.Frame.Body.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(4, 0, 0, w, h, GetBaseWarsTheme("bws_background"), false, false, false, true)
	end

	for k, v in ipairs(BaseWars:GetShopList()) do
		if self.CurrentPanel == 1 then
			self:BuildFavorites()

			break
		end

		if self.CurrentPanel == k then
			self:Build(v.subCategories)

			break
		end
	end

	BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:OnKeyCodePressed(key)
	if input.LookupKeyBinding(key) == "gm_showspare2" then
		BaseWars:CloseF4Menu()
	end
end

function PANEL:BuildFavorites()
	if not IsValid(self.Frame.Body) then return end

	local transisionDuration = .25

	if IsValid(self.Frame.Body.ContentPanel) then
		self.Frame.Body.OldContentPanel = self.Frame.Body.ContentPanel
		self.Frame.Body.OldContentPanel:AlphaTo(0, transisionDuration, 0, function()
			if IsValid(self.Frame.Body.OldContentPanel) then
				self.Frame.Body.OldContentPanel:Remove()
			end
		end)
	end

	self.Frame.Body.ContentPanel = self.Frame.Body:Add("DScrollPanel")
	self.Frame.Body.ContentPanel:Dock(FILL)
	self.Frame.Body.ContentPanel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Frame.Body.ContentPanel:SetAlpha(0)
	self.Frame.Body.ContentPanel:AlphaTo(255, transisionDuration, 0, function() end)
	self.Frame.Body.ContentPanel:GetVBar():SetWide(bigMargin)
	self.Frame.Body.ContentPanel:PaintScrollBar("bws")
	self.Frame.Body.ContentPanel.Paint = function(s,w,h)
		if #s:GetCanvas():GetChildren() == 0 then
			draw.SimpleText(self.localPlayer:GetLang("bws_nothingToBuy"), "BaseWars.30", w * .5, h * .5, GetBaseWarsTheme("bws_text"), 1, 1)
		end
	end

	local data = {}
	for k, v in ipairs(BaseWars:GetFavorites()) do
		local itemObject = BaseWars:GetBaseWarsEntity(v)
		if not itemObject then
			-- BaseWars:RemoveFavorite(v)

			continue
		end

		local subCategory = itemObject:GetSubCategory()
		if not data[subCategory] then
			data[subCategory] = {}
		end

		table.insert(data[subCategory], v)
	end

	local cardW = (self.Frame.Body:GetWide() - bigMargin * 3 - margin * 3) / 3

	for categoryName, categoryData in SortedPairs(data) do
		local first = categoryName[1]
		if tonumber(first) then
			categoryName = string.sub(categoryName, 2)
		end

		local category = self.Frame.Body.ContentPanel:Add("BaseWars.Cagory")
		category:Dock(TOP)
		category:SetName(categoryName)

		local Layout = vgui.Create("DIconLayout")
		Layout:DockMargin(0, margin, 0, 0)
		Layout:SetSpaceX(margin)
		Layout:SetSpaceY(margin)

		for _, entityID in ipairs(categoryData) do
			local itemObject = BaseWars:GetBaseWarsEntity(entityID)
			if not itemObject then continue end -- ???

			local canBuy, cantBuyReason = self.localPlayer:CanBuy(entityID)
			if self.localPlayer:GetBaseWarsConfig("hideNonBuyable") and not canBuy then continue end

			local item = Layout:Add("DButton")
			item:SetText("")
			item:SetSize(cardW, cardH)
			item.canBuy = canBuy
			item.cantBuyReason = cantBuyReason
			item.time = 0
			item.lerpColor = item.canBuy and GetBaseWarsTheme("bws_contentBackground") or GetBaseWarsTheme("bws_cantBuy")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, item.canBuy and GetBaseWarsTheme("bws_contentBackground") or GetBaseWarsTheme("bws_cantBuy"))

				BaseWars:DrawRoundedBox(8, 0, 0, w, h, s.lerpColor)
			end
			item.DoClick = function(s)
				if self.localPlayer:GetBaseWarsConfig("showBuyPopup") then
					surface.PlaySound("bw_button.wav")
					local popup = vgui.Create("BaseWars.Popup.Shop")
					popup:SetEntityID(entityID)

					return
				end

				if s.canBuy then
					surface.PlaySound("bw_button.wav")
					RunConsoleCommand("basewarsbuy", entityID)

					if self.localPlayer:GetBaseWarsConfig("closeOnBuy") then
						BaseWars:CloseF4Menu()
					end

					return
				end

				BaseWars:Notify(s.cantBuyReason, NOTIFICATION_ERROR, 5)
			end
			item.Think = function(s)
				if CurTime() >= s.time then
					s.canBuy, s.cantBuyReason = self.localPlayer:CanBuy(entityID)
					s.time = CurTime() + .5

					if IsValid(item.Buttons.Favorite) then
						item.Buttons.Favorite:SetColor(s.lerpColor)
					end

					if IsValid(item.Buttons.Copy) then
						item.Buttons.Copy:SetColor(s.lerpColor)
					end
				end
			end

			item.Infos = item:Add("DPanel")
			item.Infos:SetMouseInputEnabled(false)
			item.Infos:Dock(FILL)
			item.Infos:DockMargin(margin, margin, margin, margin)
			item.Infos.Paint = function(s,w,h)
				draw.SimpleText(itemObject:GetName(), "BaseWars.20", w * .5, bigMargin, GetBaseWarsTheme("bws_text"), 1, 1)

				-- if not item.canBuy then
				-- 	draw.SimpleText(item.cantBuyReason, "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

				-- 	return
				-- end

				local bool, rank = itemObject:GetRankCheck()(self.localPlayer)
				if not bool then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantVIP"):format(rank), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if BaseWars.Config.Prestige.Enable and not self.localPlayer:HasPrestige(itemObject:GetPrestige()) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantPrestige"):format(BaseWars:FormatNumber(itemObject:GetPrestige())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if not self.localPlayer:InRaid() and (string.find(itemObject:GetClass(), "bw_explosive") or string.find(itemObject:GetClass(), "bw_weapon_c4")) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantRaid"), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if self.localPlayer:GetLevel() < itemObject:GetLevel() then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantLevel"):format(BaseWars:FormatNumber(itemObject:GetLevel())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if not self.localPlayer:CanAfford(itemObject:GetPrice()) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantMoney"):format(BaseWars:FormatMoney(itemObject:GetPrice())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				draw.SimpleText(BaseWars:FormatMoney(itemObject:GetPrice()), "BaseWars.18", w * .5, BaseWars.ScreenScale * 30, GetBaseWarsTheme("bws_darkText"), 1, 1)
				draw.SimpleText(self.localPlayer:GetLang("bws_level"):format(BaseWars:FormatNumber(itemObject:GetLevel())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)
				draw.SimpleText(self.localPlayer:GetLang("bws_limit"):format(BaseWars:FormatNumber(itemObject:GetMax())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 60, GetBaseWarsTheme("bws_darkText"), 1, 1)
			end

			item.Model = item:Add("SpawnIcon")
			item.Model:Dock(LEFT)
			item.Model:DockMargin(bigMargin, bigMargin, 0, bigMargin)
			item.Model:SetWide(item:GetTall() - margin * 2)
			item.Model:SetMouseInputEnabled(false)
			item.Model:SetModel(itemObject:GetModel())

			item.Buttons = item:Add("DPanel")
			item.Buttons:Dock(RIGHT)
			item.Buttons:DockMargin(0, margin, margin, margin)
			item.Buttons:SetWide(cardH * .5 - margin)
			item.Buttons.Paint = nil

			item.Buttons.Favorite = item.Buttons:Add("BaseWars.Button")
			item.Buttons.Favorite:Dock(TOP)
			item.Buttons.Favorite:SetTall((cardH - margin * 3) * .5)
			item.Buttons.Favorite:SetColor(item.lerpColor, true)
			item.Buttons.Favorite.LerpFunc = function(s)
				return s:IsHovered() or BaseWars:IsFavorite(entityID)
			end
			item.Buttons.Favorite.Draw = function(s,w,h)
				BaseWars:DrawMaterial(icons["favorite"], w * .5, h * .5, h * .65, h * .65, color_white, 0)
			end
			item.Buttons.Favorite.DoClick = function(s)
				s:ButtonSound()

				BaseWars:RemoveFavorite(entityID)
				item:Remove()
			end

			item.Buttons.Copy = item.Buttons:Add("BaseWars.Button")
			item.Buttons.Copy:Dock(BOTTOM)
			item.Buttons.Copy:SetTall((cardH - margin * 3) * .5)
			item.Buttons.Copy:SetColor(item.lerpColor, true)
			item.Buttons.Copy.Draw = function(s,w,h)
				BaseWars:DrawMaterial(icons["copy"], w * .5, h * .5, h * .65, h * .65, color_white, 0)
			end
			item.Buttons.Copy.DoClick = function(s)
				s:ButtonSound()

				SetClipboardText("bind \"KEY\" \"basewarsbuy " .. entityID .. "\"")
				BaseWars:Notify("#bws_copyBind", NOTIFICATION_GENERIC, 5, itemObject:GetName())
			end
		end

		category:SetContents(Layout)
		Layout.Think = function(s)
			if s:ChildCount() <= 0 then
				category:Remove()
			end
		end

		if self.localPlayer:GetBaseWarsConfig("hideEmptyCategories") and #Layout:GetChildren() <= 0 then
			category:Remove()
		end
	end
end

function PANEL:Build(data, replacePanel)
	if not IsValid(self.Frame.Body) then return end
	if not data then return end

	local transisionDuration = .25

	if replacePanel then
		self.Frame.Body.OldContentPanel = self.Frame.Body.ContentPanel
		self.Frame.Body.OldContentPanel:AlphaTo(0, transisionDuration, 0, function()
			if IsValid(self.Frame.Body.OldContentPanel) then
				self.Frame.Body.OldContentPanel:Remove()
			end
		end)
	end

	self.Frame.Body.ContentPanel = self.Frame.Body:Add("DScrollPanel")
	self.Frame.Body.ContentPanel:Dock(FILL)
	self.Frame.Body.ContentPanel:DockMargin(bigMargin, bigMargin, bigMargin, bigMargin)
	self.Frame.Body.ContentPanel:SetAlpha(0)
	self.Frame.Body.ContentPanel:AlphaTo(255, transisionDuration, 0, function() end)
	self.Frame.Body.ContentPanel:GetVBar():SetWide(bigMargin)
	self.Frame.Body.ContentPanel:PaintScrollBar("bws")
	self.Frame.Body.ContentPanel.Paint = function(s,w,h)
		if #s:GetCanvas():GetChildren() == 0 then
			draw.SimpleText(self.localPlayer:GetLang("bws_nothingToBuy"), "BaseWars.30", w * .5, h * .5, GetBaseWarsTheme("bws_text"), 1, 1)
		end
	end

	local cardW = (self.Frame.Body:GetWide() - bigMargin * 3 - margin * 3) / 3

	for categoryName, categoryData in SortedPairs(data) do
		local first = categoryName[1]
		if tonumber(first) then
			categoryName = string.sub(categoryName, 2)
		end

		local category = self.Frame.Body.ContentPanel:Add("BaseWars.Cagory")
		category:Dock(TOP)
		category:SetName(categoryName)

		local Layout = vgui.Create("DIconLayout")
		Layout:DockMargin(0, margin, 0, 0)
		Layout:SetSpaceX(margin)
		Layout:SetSpaceY(margin)

		for _, entityID in ipairs(categoryData) do
			local itemObject = BaseWars:GetBaseWarsEntity(entityID)
			if not itemObject then continue end -- ???

			local canBuy, cantBuyReason = self.localPlayer:CanBuy(entityID)
			if self.localPlayer:GetBaseWarsConfig("hideNonBuyable") and not canBuy then continue end

			local item = Layout:Add("DButton")
			item:SetText("")
			item:SetSize(cardW, cardH)
			item.canBuy = canBuy
			item.cantBuyReason = cantBuyReason
			item.time = 0
			item.lerpColor = item.canBuy and GetBaseWarsTheme("bws_contentBackground") or GetBaseWarsTheme("bws_cantBuy")
			item.Paint = function(s,w,h)
				s.lerpColor = BaseWars:LerpColor(FrameTime() * 15, s.lerpColor, item.canBuy and GetBaseWarsTheme("bws_contentBackground") or GetBaseWarsTheme("bws_cantBuy"))

				BaseWars:DrawRoundedBox(8, 0, 0, w, h, s.lerpColor)
			end
			item.DoClick = function(s)
				if self.localPlayer:GetBaseWarsConfig("showBuyPopup") then
					surface.PlaySound("bw_button.wav")
					local popup = vgui.Create("BaseWars.Popup.Shop")
					popup:SetEntityID(entityID)

					return
				end

				if s.canBuy then
					surface.PlaySound("bw_button.wav")
					RunConsoleCommand("basewarsbuy", entityID)

					if self.localPlayer:GetBaseWarsConfig("closeOnBuy") then
						BaseWars:CloseF4Menu()
					end

					return
				end

				BaseWars:Notify(s.cantBuyReason, NOTIFICATION_ERROR, 5)
			end
			item.Think = function(s)
				if CurTime() >= s.time then
					s.canBuy, s.cantBuyReason = self.localPlayer:CanBuy(entityID)
					s.time = CurTime() + .5

					if IsValid(item.Buttons.Favorite) then
						item.Buttons.Favorite:SetColor(s.lerpColor)
					end

					if IsValid(item.Buttons.Copy) then
						item.Buttons.Copy:SetColor(s.lerpColor)
					end
				end
			end

			item.Infos = item:Add("DPanel")
			item.Infos:SetMouseInputEnabled(false)
			item.Infos:Dock(FILL)
			item.Infos:DockMargin(margin, margin, margin, margin)
			item.Infos.Paint = function(s,w,h)
				draw.SimpleText(itemObject:GetName(), "BaseWars.20", w * .5, bigMargin, GetBaseWarsTheme("bws_text"), 1, 1)

				-- if not item.canBuy then
				-- 	draw.SimpleText(item.cantBuyReason, "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

				-- 	return
				-- end

				local bool, rank = itemObject:GetRankCheck()(self.localPlayer)
				if not bool then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantVIP"):format(rank), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if BaseWars.Config.Prestige.Enable and not self.localPlayer:HasPrestige(itemObject:GetPrestige()) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantPrestige"):format(BaseWars:FormatNumber(itemObject:GetPrestige())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if not self.localPlayer:InRaid() and (string.find(itemObject:GetClass(), "bw_explosive") or string.find(itemObject:GetClass(), "bw_weapon_c4")) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantRaid"), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if self.localPlayer:GetLevel() < itemObject:GetLevel() then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantLevel"):format(BaseWars:FormatNumber(itemObject:GetLevel())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				if not self.localPlayer:CanAfford(itemObject:GetPrice()) then
					draw.SimpleText(self.localPlayer:GetLang("bws_cantMoney"):format(BaseWars:FormatMoney(itemObject:GetPrice())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)

					return
				end

				draw.SimpleText(BaseWars:FormatMoney(itemObject:GetPrice()), "BaseWars.18", w * .5, BaseWars.ScreenScale * 30, GetBaseWarsTheme("bws_darkText"), 1, 1)
				draw.SimpleText(self.localPlayer:GetLang("bws_level"):format(BaseWars:FormatNumber(itemObject:GetLevel())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 45, GetBaseWarsTheme("bws_darkText"), 1, 1)
				draw.SimpleText(self.localPlayer:GetLang("bws_limit"):format(BaseWars:FormatNumber(itemObject:GetMax())), "BaseWars.18", w * .5, BaseWars.ScreenScale * 60, GetBaseWarsTheme("bws_darkText"), 1, 1)
			end

			item.Model = item:Add("SpawnIcon")
			item.Model:Dock(LEFT)
			item.Model:DockMargin(bigMargin, bigMargin, 0, bigMargin)
			item.Model:SetWide(item:GetTall() - margin * 2)
			item.Model:SetMouseInputEnabled(false)
			item.Model:SetModel(itemObject:GetModel())

			item.Buttons = item:Add("DPanel")
			item.Buttons:Dock(RIGHT)
			item.Buttons:DockMargin(0, margin, margin, margin)
			item.Buttons:SetWide(cardH * .5 - margin)
			item.Buttons.Paint = nil

			item.Buttons.Favorite = item.Buttons:Add("BaseWars.Button")
			item.Buttons.Favorite:Dock(TOP)
			item.Buttons.Favorite:SetTall((cardH - margin * 3) * .5)
			item.Buttons.Favorite:SetColor(item.lerpColor, true)
			item.Buttons.Favorite.LerpFunc = function(s)
				return s:IsHovered() or BaseWars:IsFavorite(entityID)
			end
			item.Buttons.Favorite.Draw = function(s,w,h)
				BaseWars:DrawMaterial(icons["favorite"], w * .5, h * .5, h * .65, h * .65, color_white, 0)
			end
			item.Buttons.Favorite.DoClick = function(s)
				s:ButtonSound()

				BaseWars[(BaseWars:IsFavorite(entityID) and "Remove" or "Add") .. "Favorite"](BaseWars, entityID)
			end

			item.Buttons.Copy = item.Buttons:Add("BaseWars.Button")
			item.Buttons.Copy:Dock(BOTTOM)
			item.Buttons.Copy:SetTall((cardH - margin * 3) * .5)
			item.Buttons.Copy:SetColor(item.lerpColor, true)
			item.Buttons.Copy.Draw = function(s,w,h)
				BaseWars:DrawMaterial(icons["copy"], w * .5, h * .5, h * .65, h * .65, color_white, 0)
			end
			item.Buttons.Copy.DoClick = function(s)
				s:ButtonSound()

				SetClipboardText("bind \"KEY\" \"basewarsbuy " .. entityID .. "\"")
				BaseWars:Notify("#bws_copyBind", NOTIFICATION_GENERIC, 5, itemObject:GetName())
			end
		end

		category:SetContents(Layout)

		if self.localPlayer:GetBaseWarsConfig("hideEmptyCategories") and #Layout:GetChildren() <= 0 then
			category:Remove()
		end
	end
end

function PANEL:Paint(w, h)
end

vgui.Register("BaseWars.F4Menu", PANEL, "DFrame")