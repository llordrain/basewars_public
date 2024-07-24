local PLAYER = FindMetaTable("Player")

BaseWars.DefaultPlayerConfig = {
	["autoSellOnLeave"] = {
		value = false,
		type = "boolean",
		server  = true,
	},
	["bluredBackground"] = {
		value = true,
		type = "boolean",
	},
	["damageOwnEntities"] = {
		value = false,
		type = "boolean",
		server  = true,
	},
	["seeOtherPrinter"] = {
		value = true,
		type = "boolean",
	},
	["seeYourPrinter"] = {
		value = true,
		type = "boolean",
	},
	["showBuyPopup"] = {
		value = true,
		type = "boolean",
	},
	["closeOnBuy"] = {
		value = false,
		type = "boolean",
	},
	["hideNonBuyable"] = {
		value = false,
		type = "boolean",
	},
	["hideEmptyCategories"] = {
		value = true,
		type = "boolean",
	},
	["autoPrestige"] = {
		value = false,
		type = "boolean",
		server  = true,
	},
	["showHUD"] = {
		value = true,
		type = "boolean",
	},
	["showAdverts"] = {
		value = true,
		type = "boolean",
		server  = true,
	},
	["formatTimeDays"] = {
		value = true,
		type = "boolean"
	},
	["factionHighlight"] = {
		value = true,
		type = "boolean"
	},
	["showAllCommands"] = {
		value = true,
		type = "boolean"
	},
	["F4Tab"] = {
		value = -1,
		type = "number",
		choices = {} -- Set in base/sh_baeswars_entities.lua at the bottom in the "BaseWars:Initialize" hook
	},
	-- ["F3Tab"] = {
	-- 	value = -1,
	-- 	type = "number",
	-- 	choices = {}
	-- },
	["language"] = {
		value = BaseWars.Config.DefaultLanguage,
		type = "string",
		choices = BaseWars.AllLang,
		server  = true,
	},
	["theme"] = {
		value = "default",
		type = "string",
		choices = BaseWars.ThemeList
	},
}

function PLAYER:GetBaseWarsConfig(config)
	if not BaseWars.DefaultPlayerConfig[config] then
		return false
	end

	if not self.basewarsConfig then
		return BaseWars.DefaultPlayerConfig[config].value
	end

	return self.basewarsConfig[config]
end

function PLAYER:GetLang(str, subStr)
	local  playerLanguage = BaseWars.LANG[self:GetBaseWarsConfig("language")]
	if not playerLanguage then
		playerLanguage = BaseWars.LANG[BaseWars.Config.DefaultLanguage]
	end

	if not str then
		return "???"
	end

	local translation = playerLanguage[str]
	if subStr then
		local subTranslation = translation and translation[subStr] or nil

		if not subTranslation then
			return "\"" .. str .. "." .. subStr .. "\""
		end

		return subTranslation
	end

	if not translation then
		return "\"" .. str .. "\""
	end

	return translation
end

if CLIENT then
	local function addTheme(id, theme)
		if not id then return end
		if not theme then return end
		if theme.themeName == nil then return end

		BaseWars.Themes[id] = theme
		BaseWars.ThemeList[id] = theme.themeName
		BaseWars.DefaultPlayerConfig["theme"].choices = BaseWars.ThemeList
	end

	local DEFAULT_COLOR = Color(math.random(255), math.random(255), math.random(255))
	function BaseWars:GetTheme(str)
		local themeData = BaseWars.Themes[LocalPlayer():GetBaseWarsConfig("theme")]

		if not BaseWars.Themes["default"][str] then
			return DEFAULT_COLOR
		end

		if not themeData then
			return BaseWars.Themes["default"][str]
		end

		if not themeData[str] then
			return DEFAULT_COLOR
		end

		return themeData[str]
	end

	function BaseWars:SetPlayerConfig(config, value)
		local playerConfig = LocalPlayer().basewarsConfig

		if playerConfig[config] == nil or playerConfig[config] == value then
			return
		end

		playerConfig[config] = value

		self:SavePlayerConfig(playerConfig, config)
	end

	function BaseWars:SendPlayerConfigToServer()
		local configForServer = {}

		for k, v in pairs(BaseWars.DefaultPlayerConfig) do
			if v.server then
				configForServer[k] = LocalPlayer().basewarsConfig[k]
			end
		end

		local data = util.Compress(util.TableToJSON(configForServer))
		net.Start("BaseWars:SendPlayerConfig")
			net.WriteData(data, #data)
		net.SendToServer()
	end

	function BaseWars:SavePlayerConfig(player_config)
		file.Write("basewars/" .. self.serverAddress .. "/player_config.json", util.TableToJSON(player_config or LocalPlayer().basewarsConfig, true))

		self:SendPlayerConfigToServer()
	end

	function BaseWars:CreateDefaultTheme()
		for themeID, theme in pairs(BaseWars.Themes) do
			local temp = {}
			for id, color in pairs(theme) do
				temp[id] = color
			end

			file.Write("basewars/" .. self.serverAddress .. "/themes/" .. themeID .. ".json", util.TableToJSON(temp, true))
		end

		self:Log("Created default theme")
	end

	function BaseWars:ReloadCustomTheme()
		local themes, _ = file.Find("basewars/" .. self.serverAddress .. "/themes/*.json", "DATA")
		for k, v in pairs(themes) do
			local theme = util.JSONToTable(file.Read("basewars/" .. self.serverAddress .. "/themes/" .. v, "DATA"))
			local id = string.sub(v, 1, #v - 5)

			if BaseWars.DefaultTheme[id] then
				continue
			end

			if not theme.themeName then
				continue
			end

			for colorID, color in pairs(theme) do
				if not isnumber(color.r) or not isnumber(color.g) or not isnumber(color.b) or not isnumber(color.a) then
					continue
				end

				theme[colorID] = Color(color.r, color.g, color.b, color.a)
			end

			addTheme(id, theme)

			BaseWars:Log("Added theme: " .. theme.themeName)
		end
	end

	function BaseWars:CheckDataFolder()
		self.serverAddress = string.Replace(game.GetIPAddress(), ":", "_")

		-- Clear everything if finds old config file
		if file.Exists("basewars/basewars_config.json", "DATA") then
			file.Delete("basewars/basewars_config.json", "DATA")
			file.Delete("basewars/favorites.json", "DATA")

			for _, v in ipairs(file.Find("basewars/themes/*", "DATA")) do
				file.Delete("basewars/themes/" .. v)
			end

			file.Delete("basewars/themes")
		end

		local PATH = "basewars/" .. self.serverAddress
		if not file.IsDir(PATH, "DATA") then
			file.CreateDir(PATH .. "/themes")
		end

		local server_infos = "Server Name » " .. GetHostName() .. "\n"
		server_infos = server_infos .. "Server Map » " .. game.GetMap() .. "\n"
		server_infos = server_infos .. "\n\nLast Updated » " .. os.date("%H:%M:%S - %d/%m/%Y")
		file.Write(PATH .. "/server_infos.txt", server_infos)

		-- Create default themes
		self:CreateDefaultTheme()

		-- Reload Custom themes
		self:ReloadCustomTheme()

		-- Check for player config
		if file.Exists(PATH .. "/player_config.json", "DATA") then
			local player_config = util.JSONToTable(file.Read(PATH .. "/player_config.json", "DATA"))
			local save = false

			for k, v in pairs(self.DefaultPlayerConfig) do
				if player_config[k] == nil then
					player_config[k] = v.value
					save = true
				end
			end

			for k, v in pairs(player_config) do
				if self.DefaultPlayerConfig[k] == nil then
					player_config[k] = nil
					save = true
				else
					if type(v) != self.DefaultPlayerConfig[k].type then
						player_config[k] = self.DefaultPlayerConfig[k].value
						save = true
					end
				end
			end

			LocalPlayer().basewarsConfig = player_config

			if save then
				self:SavePlayerConfig(player_config)
			else
				self:SendPlayerConfigToServer()
			end
		else
			local temp = {}
			for k, v in pairs(self.DefaultPlayerConfig) do
				temp[k] = v.value
			end

			LocalPlayer().basewarsConfig = temp

			self:SavePlayerConfig(temp)
		end

		-- Check favorites
		if file.Exists(PATH .. "/favorites.json", "DATA") then
			LocalPlayer().basewarsFavorites = util.JSONToTable(file.Read(PATH .. "/favorites.json", "DATA"))
		else
			file.Write(PATH .. "/favorites.json", "[]") -- util.TableToJSON({})

			LocalPlayer().basewarsFavorites = {}
		end
	end
else
	util.AddNetworkString("BaseWars:SendPlayerConfig")

	net.Receive("BaseWars:SendPlayerConfig", function(len, ply)
		ply.basewarsConfig = util.JSONToTable(util.Decompress(net.ReadData(len / 8)))
	end)
end