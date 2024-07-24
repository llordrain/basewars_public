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
	local colors = {
		scroll = BaseWars:GetTheme(panel .. "_scroll"),
		bar = BaseWars:GetTheme(panel .. "_scrollbar")
	}

	vbar:SetWide(BaseWars:SS(8))
	vbar:SetHideButtons(true)

	vbar.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(BaseWars:SS(6), 0, 0, w, h, colors.scroll)
	end
	vbar.btnGrip.Paint = function(s,w,h)
		BaseWars:DrawRoundedBox(BaseWars:SS(6), 0, 0, w, h, colors.bar)
	end
end

function GM:InitPostEntity()
	local ply = LocalPlayer()

	net.Start("BaseWars:PlayerReadyToReceiveNets")
	net.SendToServer()

	ProfileSelector = vgui.Create("BaseWars.Profiles")

	BaseWars:CheckDataFolder()

	hook.Add("BaseWars:Initialize", "BaseWars:LuaRefreshClient", function()
		BaseWars.serverAddress = string.Replace(game.GetIPAddress(), ":", "_")

		BaseWars:CreateDefaultTheme()
		BaseWars:ReloadCustomTheme()

		net.Start("BaseWars:SendGamemodeConfigToClient")
		net.SendToServer()
	end)
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

	hook.Add("BaseWars:PreConfigurationModified", BaseWars.Config, newConfig)

	BaseWars.Config = newConfig

	hook.Run("BaseWars:ConfigurationModified", BaseWars.Config, newConfig) -- TODO: Check this
end)

net.Receive("BaseWars:SendGamemodeConfigToClient", function(len)
	BaseWars.Config = util.JSONToTable(util.Decompress(net.ReadData(len / 8)), false, true)

	BaseWars:Log("Received Config From Server")
end)