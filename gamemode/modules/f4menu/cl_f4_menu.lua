local TRANSITION_DURATION = .2

local PANEL = {}
function PANEL:Init()
	self.localPlayer = LocalPlayer()
	self.CurrentPanel = self.localPlayer:GetBaseWarsConfig("F4Tab")

	if self.CurrentPanel == -1 then
		self.CurrentPanel = self.localPlayer.F4Tab or 1
	end

	self.colors = {
		accent = BaseWars:GetTheme("accent"),
		text = BaseWars:GetTheme("shop_text"),
		darkText = BaseWars:GetTheme("shop_darkText"),
		titlebar = BaseWars:GetTheme("shop_titlebar"),
		sidebar = BaseWars:GetTheme("shop_sidebar"),
		body = BaseWars:GetTheme("shop_body"),
		category = BaseWars:GetTheme("shop_category"),
		card = BaseWars:GetTheme("shop_card"),
		cardBack = BaseWars:GetTheme("shop_cardBack"),
	}

	self.translate = {
		title = self.localPlayer:GetLang("shop_title"),
		close = self.localPlayer:GetLang("close"),
		favorites = self.localPlayer:GetLang("favorites"),
		lvl = self.localPlayer:GetLang("hud_level"),
		max = self.localPlayer:GetLang("bws_limit"),
		prestige = self.localPlayer:GetLang("bws_prestige"),
	}

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:MakePopup()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)

	--[[-------------------------------------------------------------------
		Frame
	---------------------------------------------------------------------]]
	self.Frame = self:Add("DPanel")
	self.Frame:SetSize(ScreenWitdh() * .85, ScreenHeight() * .85)
	self.Frame:Center()
	self.Frame.Paint = nil

	self.Frame.Topbar = self.Frame:Add("DPanel")
	self.Frame.Topbar:Dock(TOP)
	self.Frame.Topbar:SetTall(BaseWars:SS(36))
	self.Frame.Topbar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self.colors.titlebar, true, true)
		draw.SimpleText(self.translate.title, "BaseWars.20", w * .5, h * .5, self.colors.text, 1, 1)
	end

	--[[-------------------------------------------------------------------
		Frame » Sidebar
	---------------------------------------------------------------------]]
	self.Frame.Sidebar = self.Frame:Add("DPanel")
	self.Frame.Sidebar:Dock(LEFT)
	self.Frame.Sidebar:SetWide(BaseWars:SS(220))
	self.Frame.Sidebar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self.colors.sidebar, false, false, true)
	end

	--[[-------------------------------------------------------------------
		Frame » Sidebar » Player Infos
	---------------------------------------------------------------------]]
	self.Frame.Sidebar.Player = self.Frame.Sidebar:Add("DPanel")
	self.Frame.Sidebar.Player:Dock(TOP)
	self.Frame.Sidebar.Player:SetTall(BaseWars:SS(70))
	self.Frame.Sidebar.Player.Paint = function(s,w,h)
		draw.SimpleText(self.localPlayer:Name(), "BaseWars.20", h - BaseWars:SS(5), h * .5 + 1, self.colors.text, 0, 4)
		draw.SimpleText(BaseWars:FormatMoney(self.localPlayer:GetMoney()), "BaseWars.18", h - BaseWars:SS(5), h * .5 - 1, self.colors.darkText)
	end

	--[[-------------------------------------------------------------------
		Frame » Sidebar » Player Infos » Player Avatar
	---------------------------------------------------------------------]]
	self.Frame.Sidebar.Player = self.Frame.Sidebar.Player:Add("AvatarMaterial")
	self.Frame.Sidebar.Player:SetPos(BaseWars:SS(10), BaseWars:SS(10))
	self.Frame.Sidebar.Player:SetSize(BaseWars:SS(50), BaseWars:SS(50))
	self.Frame.Sidebar.Player:SetPlayer(self.localPlayer)

	--[[-------------------------------------------------------------------
		Frame » Sidebar » Scroll
	---------------------------------------------------------------------]]
	self.Frame.Sidebar.Scroll = self.Frame.Sidebar:Add("DScrollPanel")
	self.Frame.Sidebar.Scroll:GetVBar():SetWide(0)
	self.Frame.Sidebar.Scroll:Dock(FILL)
	self.Frame.Sidebar.Scroll:DockMargin(BaseWars:SS(10), 0, BaseWars:SS(10), BaseWars:SS(10))

	for k, v in ipairs(BaseWars:GetShopList()) do
		local tab = self.Frame.Sidebar.Scroll:Add("BaseWars.Button")
		tab:Dock(TOP)
		tab:DockMargin(0, 0, 0, BaseWars:SS(5))
		tab.Draw = function(s,w,h)
			BaseWars:DrawMaterial(v.icon, h * .5, h * .5, h - BaseWars:SS(18), h - BaseWars:SS(18), self.colors.text, 0)

			draw.SimpleText(v.name, "BaseWars.20", h, h * .5, self.colors.text, 0, 1)
		end
		tab.LerpFunc = function(s)
			return self.CurrentPanel == k
		end
		tab.DoClick = function(s)
			if self.CurrentPanel == k then
				return
			end

			s:ButtonSound()

			self.localPlayer.F4Tab = k
			self.CurrentPanel = k
			self:Build(v.subCategories, true)
		end
	end

	self.Frame.Sidebar.Close = self.Frame.Sidebar:Add("BaseWars.Button")
	self.Frame.Sidebar.Close:Dock(BOTTOM)
	self.Frame.Sidebar.Close:DockMargin(BaseWars:SS(10), 0, BaseWars:SS(10), BaseWars:SS(10))
	self.Frame.Sidebar.Close.Draw = function(s,w,h)
		BaseWars:DrawMaterial(BaseWars.Icons["close"], h * .5, h * .5, h - BaseWars:SS(18), h - BaseWars:SS(18), self.colors.text, 0)

		draw.SimpleText(self.translate.close, "BaseWars.20", h, h * .5, self.colors.text, 0, 1)
	end
	self.Frame.Sidebar.Close.LerpFunc = function(s)
		return s:IsHovered() and input.IsMouseDown(MOUSE_LEFT)
	end
	self.Frame.Sidebar.Close.DoClick = function(s)
		s:ButtonSound()

		BaseWars:CloseF4Menu()
	end

	--[[-------------------------------------------------------------------
		BODY
	---------------------------------------------------------------------]]
	self.Frame.Body = self.Frame:Add("DPanel")
	self.Frame.Body:Dock(FILL)
	self.Frame.Body:InvalidateParent(true)
	self.Frame.Body.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self.colors.body, false, false, false, true)
	end

	self.cardWide = (self.Frame.Body:GetWide() - BaseWars:SS(20 + 10 + 10 + 8 + 5)) / 3

	if BaseWars:GetShopList()[self.CurrentPanel] != nil then
		self:Build(BaseWars:GetShopList()[self.CurrentPanel].subCategories)
	end

	BaseWars:EaseInBlurBackground(self, 3, .9)
end

function PANEL:OnKeyCodePressed(key)
	if input.LookupKeyBinding(key) == "gm_showspare2" then
		BaseWars:CloseF4Menu()
	end
end

function PANEL:Build(data, replacePanel)
	if replacePanel and IsValid(self.Frame.Body.Content) then
		self.Frame.Body.OldContent = self.Frame.Body.Content
		self.Frame.Body.OldContent:AlphaTo(0, TRANSITION_DURATION, 0, function()
			if IsValid(self.Frame.Body.OldContent) then
				self.Frame.Body.OldContent:Remove()
			end
		end)
	end

	self.Frame.Body.Content = self.Frame.Body:Add("DScrollPanel")
	self.Frame.Body.Content:Dock(FILL)
	self.Frame.Body.Content:DockMargin(BaseWars:SS(10), BaseWars:SS(10), BaseWars:SS(10), BaseWars:SS(10))
	self.Frame.Body.Content:SetAlpha(0)
	self.Frame.Body.Content:AlphaTo(255, TRANSITION_DURATION, 0)
	self.Frame.Body.Content:PaintScrollBar("shop")
	self.Frame.Body.Content.Paint = function(s,w,h)
		if #s:GetCanvas():GetChildren() == 0 then
			draw.SimpleText(self.localPlayer:GetLang("shop_nothingToBuy"), "BaseWars.30", w * .5, h * .5, self.colors.text, 1, 1)
		end
	end

	--[[-------------------------------------------------------------------
		Favorites
	---------------------------------------------------------------------]]
	local favoritesTemp = {}
	self.favoritesCategory = self.Frame.Body.Content:Add("BaseWars.Category")
	self.favoritesCategory:Dock(TOP)
	self.favoritesCategory:SetName(self.translate.favorites)
	self.favoritesCategory:SetColor(self.colors.category)
	self.favoritesCategory:SetTextColor(self.colors.text)

	local catContent = vgui.Create("DPanel")
	catContent:DockPadding(BaseWars:SS(5), BaseWars:SS(5), BaseWars:SS(5), BaseWars:SS(5))
	catContent.Paint = function(s,w,h)
		BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self.colors.cardBack, false, false, true, true)
	end

	self.favoritesCatContent = catContent:Add("DIconLayout")
	self.favoritesCatContent:Dock(TOP)
	self.favoritesCatContent:SetTall(self.h)
	self.favoritesCatContent:SetSpaceX(BaseWars:SS(5))
	self.favoritesCatContent:SetSpaceY(BaseWars:SS(5))
	self.favoritesCategory:SetContents(catContent)
	--[[-------------------------------------------------------------------
		Favorites
	---------------------------------------------------------------------]]

	for categoryName, categoryData in SortedPairs(data) do
		local first = categoryName[1]
		if tonumber(first) then
			categoryName = string.sub(categoryName, 2)
		end

		--[[-------------------------------------------------------------------
			Category
		---------------------------------------------------------------------]]
		local category = self.Frame.Body.Content:Add("BaseWars.Category")
		category:Dock(TOP)
		category:SetName(categoryName)
		category:SetColor(self.colors.category)
		category:SetTextColor(self.colors.text)

		--[[-------------------------------------------------------------------
			Category » Content
		---------------------------------------------------------------------]]
		local catContent = vgui.Create("DPanel")
		catContent:DockPadding(BaseWars:SS(5), BaseWars:SS(5), BaseWars:SS(5), BaseWars:SS(5))
		catContent.Paint = function(s,w,h)
			BaseWars:DrawRoundedBoxEx(BaseWars:SS(6), 0, 0, w, h, self.colors.cardBack, false, false, true, true)
		end

		--[[-------------------------------------------------------------------
			Category » Content Layout
		---------------------------------------------------------------------]]
		catContent.layout = catContent:Add("DIconLayout")
		catContent.layout:Dock(TOP)
		catContent.layout:SetTall(self.h)
		catContent.layout:SetSpaceX(BaseWars:SS(5))
		catContent.layout:SetSpaceY(BaseWars:SS(5))
		category:SetContents(catContent)

		for _, entID in ipairs(categoryData) do
			local entObj = BaseWars:GetBaseWarsEntity(entID)
			if not entObj then
				continue
			end

			local canBuy = self.localPlayer:CanBuy(entID)
			if self.localPlayer:GetBaseWarsConfig("hideNonBuyable") and not canBuy then
				continue
			end

			local isFavorite = BaseWars:IsFavorite(entID)
			if isFavorite then
				table.insert(favoritesTemp, {
					entObj = entObj,
					price = entObj:GetPrice()
				})
			end

			self:AddItemCard(entID, entObj, catContent.layout, isFavorite)
		end

		if self.localPlayer:GetBaseWarsConfig("hideEmptyCategories") and #catContent.layout:GetChildren() <= 0 then
			category:Remove()
		end
	end

	--[[-------------------------------------------------------------------
		Make favorites table then build
	---------------------------------------------------------------------]]
	local favorites = {}
	for _, v in SortedPairsByMemberValue(favoritesTemp, "price") do
		table.insert(favorites, v.entObj)
	end

	for _, entObj in ipairs(favorites) do
		self:AddItemCard(entObj:GetID(), entObj, self.favoritesCatContent, true)
	end
end

function PANEL:AddItemCard(entID, entObj, parent, isFavorite)
	local formatted = {
		price = BaseWars:FormatMoney(entObj:GetPrice()),
		level = BaseWars:FormatNumber(entObj:GetLevel()),
		max = Format(self.translate.max, entObj:GetMax()),
		prestige = Format(self.translate.prestige, entObj:GetPrestige())
	}

	local _, rank = entObj:GetRankCheck()() -- entObj:GetRankCheck() returns a function which returns a boolean and a string

	--[[-------------------------------------------------------------------
		Entity Card
	---------------------------------------------------------------------]]
	local item = parent:Add("DButton")
	item:SetText("")
	item:SetSize(self.cardWide, BaseWars:SS(70))
	item.id = entID
	item.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(8, 0, 0, w, h, self.colors.card)

		-- Box behind model
		BaseWars:DrawRoundedBox(BaseWars:SS(6), BaseWars:SS(5), BaseWars:SS(5), h - BaseWars:SS(10), h - BaseWars:SS(10), self.colors.cardBack)

		-- Entity Name
		draw.SimpleText(entObj:GetName(), "BaseWars.20", h, h * .5 - BaseWars:SS(8), self.colors.text, 0, 4)

		-- Price | Level
		draw.SimpleText(formatted.price .. " | " .. self.translate.lvl .. formatted.level, "BaseWars.16", h, h * .5, self.colors.darkText, 0, 1)

		local line2 = formatted.max
		if BaseWars.Config.Prestige.Enable and entObj:GetPrestige() > 0 then
			line2 = line2 .. " | " .. formatted.prestige
		end

		if rank != nil then
			line2 = line2 .. " | " .. rank
		end

		-- Limit | Prestige? | rank?
		draw.SimpleText(line2, "BaseWars.16", h, h * .5 + BaseWars:SS(8), self.colors.darkText)
	end
	item.DoClick = function(s)
		if self.localPlayer:GetBaseWarsConfig("showBuyPopup") then
			surface.PlaySound("basewars/button.wav")

			local popup = vgui.Create("BaseWars.Popup.Shop")
			popup:SetEntityID(entID)

			return
		end

		local canBuy, reason = self.localPlayer:CanBuy(entID)
		if canBuy then
			surface.PlaySound("basewars/button.wav")
			RunConsoleCommand("basewarsbuy", entID)

			if self.localPlayer:GetBaseWarsConfig("closeOnBuy") then
				BaseWars:CloseF4Menu()
			end

			return
		end

		BaseWars:Notify(reason, NOTIFICATION_ERROR, 5)
	end

	--[[-------------------------------------------------------------------
		Entity Card » Model
	---------------------------------------------------------------------]]
	item.Model = item:Add("SpawnIcon")
	item.Model:Dock(LEFT)
	item.Model:DockMargin(BaseWars:SS(10), BaseWars:SS(10), 0, BaseWars:SS(10))
	item.Model:SetWide(BaseWars:SS(50))
	item.Model:SetMouseInputEnabled(false)
	item.Model:SetModel(entObj:GetModel())

	--[[-------------------------------------------------------------------
		Entity Card » (Un)Favorite Button
	---------------------------------------------------------------------]]
	item.Favorite = item:Add("DButton")
	item.Favorite:SetText("")
	item.Favorite:Dock(RIGHT)
	item.Favorite:DockMargin(0, BaseWars:SS(15), BaseWars:SS(15), BaseWars:SS(15))
	item.Favorite:SetWide(BaseWars:SS(40))
	item.Favorite.isFavorited = isFavorite
	item.Favorite.Paint = function(s,w,h)
		s.isFavorited = BaseWars:IsFavorite(entID)

		BaseWars:DrawMaterial(BaseWars.Icons["f4/favorite" .. (s.isFavorited and "2" or "1")], w * .5, h * .5, BaseWars:SS(28), BaseWars:SS(28), self.colors[s.isFavorited and "accent" or "text"], 0)
	end
	item.Favorite.DoClick = function(s)
		surface.PlaySound("basewars/button.wav")

		if s.isFavorited then
			for k, v in ipairs(self.favoritesCatContent:GetChildren()) do
				if v.id == entID then
					v:Remove()

					break
				end
			end

			BaseWars:RemoveFavorite(entID)
		else
			self:AddItemCard(entID, entObj, self.favoritesCatContent, true)

			BaseWars:AddFavorite(entID)
		end

		timer.Simple(0, function()
			self.favoritesCategory:InvalidateLayout()
		end)
	end
end

function PANEL:Paint(w, h)
end

vgui.Register("BaseWars.F4Menu", PANEL, "DFrame")