local PANEL = FindMetaTable("Panel")
local scrw, scrh = ScrW(), ScrH()

function GM:Initialize()
end

function GM:ShowSpare2()
	BaseWars:OpenF4Menu()
end

function GM:ShowSpare1()
	BaseWars:OpenF3Menu()
end

function GM:ShowHelp()
end

function GM:ShowTeam()
end

function ScreenWitdh()
	return math.Clamp(scrw, 0, 3840)
end

function ScreenHeight()
	return math.Clamp(scrh, 0, 2160)
end

function ScreenScale(size)
	return size * (ScreenWitdh() / 640)
end

BaseWars.ScreenScale = ScreenScale(.4)
function GM:OnScreenSizeChanged()
	scrw, scrh = ScrW(), ScrH()

	BaseWars.ScreenScale = ScreenScale(.4)
end

function PANEL:PaintScrollBar(panel)
	if not panel then return end

	local vbar = self:GetVBar()

	vbar:SetWide(10)
	vbar:SetHideButtons(true)

	vbar.Paint = function(s,w,h)
		draw.RoundedBox(4, 0, 0, w, h, GetBaseWarsTheme(panel .. "_scroll"))
	end
	vbar.btnGrip.Paint = function(s,w,h)
		draw.RoundedBox(4, 0, 0, w, h, GetBaseWarsTheme(panel .. "_scrollbar"))
	end
end

local function playerConfigExists()
	if not file.IsDir("basewars", "DATA") then
		file.CreateDir("basewars/themes")
	end

	if not file.IsDir("basewars/themes", "DATA") then
		file.CreateDir("basewars/themes")
	end

	BaseWars:CreateDefaultTheme()

	if not file.Exists("basewars/basewars_config.json", "DATA") then
		local defaultConfig = table.Copy(BaseWars.DefaultPlayerConfig)

		for k, v in pairs(defaultConfig) do
			defaultConfig[k] = defaultConfig[k].value -- Reformat the table before saving in the player's game
		end

		-- https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
		local playerCountry = system.GetCountry()
		if playerCountry == "FR" or playerCountry == "BE" then
			defaultConfig["language"] =  "fr"
		end

		file.Write("basewars/basewars_config.json", util.TableToJSON(defaultConfig, true))
		return defaultConfig, false
	end

	local config = util.JSONToTable(file.Read("basewars/basewars_config.json", "DATA"))

	-- Checkup for missing configs
	local shouldSave = false
	if config then
		for k, v in pairs(BaseWars.DefaultPlayerConfig) do
			if config[k] == nil then
				config[k] = v.value
				shouldSave = true
			end
		end
	end

	--Checkup for config that are no longer used or in the wrong data type
	for k, v in pairs(config) do
		if BaseWars.DefaultPlayerConfig[k] == nil then
			config[k] = nil
			shouldSave = true
		else
			if type(v) != BaseWars.DefaultPlayerConfig[k].type then
				config[k] = BaseWars.DefaultPlayerConfig[k].value
				shouldSave = true
			end
		end
	end

	return config, shouldSave
end

function GM:InitPostEntity()
	local ply = LocalPlayer()

	net.Start("BaseWars:PlayerReadyToReceiveNets")
	net.SendToServer()

	ProfileSelector = vgui.Create("BaseWars.Profiles")

	local playerConfig, shouldSave = playerConfigExists()
	ply.basewarsConfig = playerConfig

	if shouldSave then
		SaveBaseWarsConfig(playerConfig)
	else
		SendPlayerConfigToServer(playerConfig)
	end

	BaseWars:ReloadCustomTheme()

	hook.Add("BaseWars:Initialize", "BaseWars:LuaRefreshClient", function()
		BaseWars:CreateDefaultTheme()
		BaseWars:ReloadCustomTheme()

		net.Start("BaseWars:SendGamemodeConfigToClient")
		net.SendToServer()
	end)
end

function SendPlayerConfigToServer()
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

function SetBaseWarsConfig(config, value)
	local playerConfig = GetPlayerConfig()

	if playerConfig[config] == nil or playerConfig[config] == value then
		return
	end

	playerConfig[config] = value

	SaveBaseWarsConfig(playerConfig, config)
end

function SaveBaseWarsConfig(config, newConfig)
	config = config or GetPlayerConfig()

	file.Write("basewars/basewars_config.json", util.TableToJSON(config, true))

	if newConfig and not BaseWars.DefaultPlayerConfig[newConfig].server then
		return
	end

	SendPlayerConfigToServer(config)
end

function GetPlayerConfig()
	return LocalPlayer().basewarsConfig
end

function GetBaseWarsTheme(str)
	local themeData = BaseWars.Themes[LocalPlayer():GetBaseWarsConfig("theme")]

	return themeData and themeData[str] or BaseWars.Themes["default"][str]
end

function GM:AddDeathNotice(attacker, attackerTeam, inflictor, victim, victimTeam)
	if inflictor == "suicide" then
		BaseWars:Notify("#deathNotice_suicide", NOTIFICATION_DEATHNOTICE, 5, victim)
	end

	if attacker != nil then
		if string.StartsWith(attacker, "#") then
			local ent = scripted_ents.Get(string.sub(attacker, 2))

			if inflictor == "worldspawn" then
				BaseWars:Notify("#deathNotice_fallDamage", NOTIFICATION_DEATHNOTICE, 5, victim)
			else
				local name = attacker or "???"
				if IsValid(ent) then
					name = BaseWars:GetValidName(ent)
				end
				BaseWars:Notify("#deathNotice_noAttacker", NOTIFICATION_DEATHNOTICE, 5, victim, "\"" .. name .. "\"" or "\"" .. string.sub(attacker, 2) .. "\"")
			end
		else
			local ent = scripted_ents.Get(inflictor)
			local weap = weapons.Get(inflictor)

			local name = ""
			if istable(ent) and ent.PrintName then
				name = ent.PrintName
			elseif istable(weap) and weap.PrintName then
				name = weap.PrintName
			else
				name = inflictor
			end

			BaseWars:Notify("#deathNotice_by", NOTIFICATION_DEATHNOTICE, 5, attacker, victim, "\"" .. name .. "\"")
		end
	end
end

function GM:PlayerFootstep(ply)
	return ply:Crouching() or ply:IsCloak()
end

hook.Add("BaseWars:Initialize", "BaseWars:RemoveMenus", function()
	timer.Simple(0, function()

		local F3 = BaseWars:GetF3MenuPanel()
		if IsValid(F3) then
			F3:Remove()
			BaseWars:OpenF3Menu()
		end

		local F4 = BaseWars:GetF4MenuPanel()
		if IsValid(F4) then
			F4:Remove()
			BaseWars:OpenF4Menu()
		end

		local AM = BaseWars:GetAdminMenuPanel()
		if IsValid(AM) then
			AM:Remove()
		end
	end)
end)

net.Receive("BaseWars:ShowSpare", function()
	GAMEMODE["ShowSpare" .. (net.ReadBit() == 0 and "2" or "1")]()
end)

hook.Add("BaseWars:ConfigurationModified", "BaseWars:Base", function(oldConfig, newConfig)
	local tempOld = {}
	for k, v in ipairs(oldConfig) do
		tempOld[v] = true
	end

	local tempNew = {}
	for k, v in ipairs(newConfig) do
		tempNew[v] = true
	end

	for k, _ in pairs(tempOld) do
		if not tempNew[k] then
			RunConsoleCommand("spawnmenu_reload")

			break
		end
	end

	for k, _ in pairs(tempNew) do
		if not tempOld[k] then
			RunConsoleCommand("spawnmenu_reload")

			break
		end
	end
end)

net.Receive("BaseWars:GamemodeConfigModified", function(len)
	local newConfig = util.JSONToTable(util.Decompress(net.ReadData(len / 8)), false, true)

	hook.Run("BaseWars:ConfigurationModified", BaseWars.Config, newConfig)

	BaseWars.Config = newConfig
end)

net.Receive("BaseWars:SendGamemodeConfigToClient", function(len)
	BaseWars.Config = util.JSONToTable(util.Decompress(net.ReadData(len / 8)), false, true)
	BaseWars:Log("Received Config From Server")
end)