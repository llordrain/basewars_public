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

function AddTheme(id, theme)
	if not id then return end
	if not theme then return end
	if theme.themeName == nil then return end

	BaseWars.Themes[id] = theme
	BaseWars.ThemeList[id] = theme.themeName
	BaseWars.DefaultPlayerConfig["theme"].choices = BaseWars.ThemeList
end

function PLAYER:GetBaseWarsConfig(config)
	if not self.basewarsConfig then
		return BaseWars.DefaultPlayerConfig[config].value or false
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