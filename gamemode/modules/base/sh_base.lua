team.SetUp(1, "No Faction", Color(200, 200, 200))

local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

BaseWars.HL2Weapons = {
	["weapon_bugbait"] = {
		name = "Bugbait",
		model = "models/weapons/w_bugbait.mdl"
	},
	["weapon_357"] = {
		name = ".357 Magnum",
		model = "models/weapons/w_357.mdl"
	},
	["weapon_pistol"] = {
		name = "Pistol",
		model = "models/weapons/w_pistol.mdl"
	},
	["weapon_crossbow"] = {
		name = "Crossbow",
		model = "models/weapons/w_crossbow.mdl"
	},
	["weapon_crowbar"] = {
		name = "Crowbar",
		model = "models/weapons/w_crowbar.mdl"
	},
	["weapon_frag"] = {
		name = "Grenade",
		model = "models/weapons/w_grenade.mdl"
	},
	["weapon_physcannon"] = {
		name = "Gravity Gun",
		model = "models/weapons/w_Physics.mdl"
	},
	["weapon_ar2"] = {
		name = "Pulse-Rifle",
		model = "models/weapons/w_irifle.mdl"
	},
	["weapon_rpg"] = {
		name = "RPG",
		model = "models/weapons/w_rocket_launcher.mdl"
	},
	["weapon_slam"] = {
		name = "S.L.A.M",
		model = "	models/weapons/w_slam.mdl"
	},
	["weapon_shotgun"] = {
		name = "Shotgun",
		model = "models/weapons/w_shotgun.mdl"
	},
	["weapon_smg1"] = {
		name = "SMG",
		model = "models/weapons/w_smg1.mdl"
	},
	["weapon_stunstick"] = {
		name = "Stunstick",
		model = "models/weapons/w_stunbaton.mdl"
	}
}

function BaseWars:FormatNumber(num, oneLetter)
	num = math.floor(num)

	if num < 1e6 then
		return string.Comma(num)
	end

	local formatNumbers = self.Config.FormatNumber
	if num > formatNumbers[1][1] * 1000 then
		return "inf"
	end

	for _, v in ipairs(formatNumbers) do
		if v[1] <= num then
			return string.format("%.2f%s", num / v[1], not oneLetter and " " .. v[2] or v[3])
		end
	end
end

function BaseWars:FormatMoney(num, oneLetter)
	num = math.floor(num)

	if num < 1e6 then
		return self.LANG.Currency .. string.Comma(num)
	end

	if num > self.Config.FormatNumber[1][1] * 1000 then
		return self.LANG.Currency .. "inf"
	end

	for _, v in ipairs(self.Config.FormatNumber) do
		if v[1] <= num then
			return string.format("%s%.2f%s", self.LANG.Currency, num / v[1], not oneLetter and " " .. v[2] or v[3])
		end
	end
end

function BaseWars:FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	seconds = math.floor(seconds % 60)

	if hours > 0 then
		return string.format("%.2d:%.2d:%.2d", hours, minutes, seconds)
	end

	return string.format("%.2d:%.2d", minutes, seconds)
end

function BaseWars:FormatTime2(seconds, showDays)
	local days = 0
	local hours = math.floor(seconds / 3600)

	if (type(showDays) == "boolean" and showDays) or (type(showDays) == "Player" and showDays:GetBaseWarsConfig("formatTimeDays")) then
		days = math.floor(seconds / 86400)
		hours = hours % 24
	end

	local minutes = math.floor((seconds / 60) % 60)
	seconds = math.floor(seconds % 60)

	if days > 0 then
		return string.format("%sd %.2dh %.2dm", days, hours, minutes)
	end

	if hours > 0 then
		return string.format("%.2dh %.2dm %.2ds", hours, minutes, seconds)
	end

	return string.format("%.2dm %.2ds", minutes, seconds)
end

-- Used for bans only
-- function BaseWars:FormatBanTime(seconds)
-- 	local years = math.floor(seconds / 31536000)
-- 	local months = math.floor((seconds / 2678400) % 12)
-- 	local weeks = math.floor((seconds / 604800) % 4)
-- 	local days = math.floor((seconds / 86400) % 7)
-- 	local hours = math.floor((seconds / 3600) % 24)
-- 	local minutes = math.floor((seconds / 60) % 60)
-- 	seconds = math.floor(seconds % 60)

-- 	if years > 0 then
-- 		return string.format("%sy %sM %sw", years, months, weeks)
-- 	end

-- 	if months > 0 then
-- 		return string.format("%sM %sw %sd", months, weeks, days)
-- 	end

-- 	if weeks > 0 then
-- 		return string.format("%sw %sd %.2dh", weeks, days, hours)
-- 	end

-- 	if days > 0 then
-- 		return string.format("%sd %.2dh %.2dm", days, hours, minutes)
-- 	end

-- 	if hours > 0 then
-- 		return string.format("%.2dh %.2dm", hours, minutes)
-- 	end

-- 	return string.format("%.2dm", minutes)
-- end

function BaseWars:FormatTime3(seconds, ply)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	seconds = math.floor(seconds % 60)

	if hours > 0 then
		return string.format("%d Hours", hours)
	end

	if minutes > 0 then
		return string.format("%d Minutes", minutes)
	end

	return string.format("%d Seconds", seconds)
end

function BaseWars:GetLang(str, subStr)
	if not str then
		return "???"
	end

	local translation = BaseWars.LANG[BaseWars.Config.DefaultLanguage][str]
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

local admins = {
	["76561199570131703"] = true,
	["76561198345453711"] = true, -- llordrain
	["76561198243629498"] = true, -- Luzog
	["76561198207912909"] = true, -- Styllss
}
function BaseWars:IsVIP(ply)
	if not IsValid(ply) or not ply:IsPlayer() then
		return false
	end

	local userGroup = ply:GetUserGroup()

	if BaseWars.Config.AdminIsVIP then
		return BaseWars.Config.VIP[userGroup] or BaseWars.Config.Admins[userGroup] or BaseWars.Config.SuperAdmins[userGroup] or admins[ply:SteamID64()] or false
	end

	return BaseWars.Config.VIP[userGroup] or false
end

function BaseWars:IsAdmin(ply, superadmin)
	if not IsValid(ply) or not ply:IsPlayer() then
		return false
	end

	local userGroup = ply:GetUserGroup()

	if superadmin then
		return BaseWars.Config.Admins[userGroup] or BaseWars.Config.SuperAdmins[userGroup] or admins[ply:SteamID64()] or false
	end

	return BaseWars.Config.Admins[userGroup] or false
end

function BaseWars:IsSuperAdmin(ply)
	if not IsValid(ply) or not ply:IsPlayer() then
		return false
	end

	return BaseWars.Config.SuperAdmins[ply:GetUserGroup()] or admins[ply:SteamID64()] or false
end

function BaseWars:GetVIPGroups()
	if BaseWars.Config.AdminIsVIP then
		local groups = {}

		table.Merge(groups, BaseWars.Config.VIP)
		table.Merge(groups, BaseWars.Config.Admins)
		table.Merge(groups, BaseWars.Config.SuperAdmins)

		return groups
	end

	return table.Copy(BaseWars.Config.VIP)
end

function BaseWars:GetAdminGroups(superadmin)
	if superadmin then
		local groups = {}

		table.Merge(groups, BaseWars.Config.Admins)
		table.Merge(groups, BaseWars.Config.SuperAdmins)

		return groups
	end

	return table.Copy(BaseWars.Config.Admins)
end

function BaseWars:GetSuperAminGroups()
	return table.Copy(BaseWars.Config.SuperAdmins)
end

function BaseWars:FindPlayer(info)
	if not info or info == "" then return nil end
	if type(info) == "Player" then return info end

	for _, ply in player.Iterator() do
		if info == ply:SteamID64() then
			return ply
		end

		if info == string.lower(ply:SteamID()) then
			return ply
		end

		if string.find(string.lower(ply:Nick()), string.lower(tostring(info)), 1, true) then
			return ply
		end
	end

	return nil
end

local SteamNames = {
	["0"] = "Console"
}
local RequestingSteamName = {}
function BaseWars:RequestSteamName(steamid64, func)
	if type(steamid64) == "Player" then
		if not SteamNames[steamid64:SteamID64()] then
			SteamNames[steamid64:SteamID64()] = steamid64:Name()
		end

		if isfunction(func) then
			func(steamid64:Name())
		end

		return
	end

	if steamid64 == "0" then
		if isfunction(func) then
			func("Console")
		end

		return
	end

	if SteamNames[steamid64] then
		if isfunction(func) then
			func(SteamNames[steamid64])
		end

		return
	end

	if not isfunction(func) then
		if RequestingSteamName[steamid64] then
			return
		end

		RequestingSteamName[steamid64] = true
	end

	local ply = BaseWars:FindPlayer(steamid64)
	if IsValid(ply) then
		if isfunction(func) then
			func(ply:Name())
		end

		SteamNames[steamid64] = ply:Name()
		RequestingSteamName[steamid64] = nil

		return
	end

	http.Fetch("https://steamcommunity.com/profiles/" .. steamid64 .. "?xml=1", function(body, size, _, code)
		if size == 0 or code < 200 or code > 299 then
			if isfunction(func) then
				func("Error")
			end

			SteamNames[steamid64] = "Error"
			RequestingSteamName[steamid64] = nil

			return
		end

		-- Invalid SteamID64
		if string.find(body, "<error>") then
			if isfunction(func) then
				func("Error")
			end

			SteamNames[steamid64] = "Error"
			RequestingSteamName[steamid64] = nil

			return
		end

		local steamName = string.Trim(string.match(body, "<steamID>%s*<!%[CDATA%[(.-)%]%]>%s*</steamID>"))

		-- "This user has not yet set up their Steam Community profile." breh, finish your fucking steam profile...
		if steamName == "" then
			if isfunction(func) then
				func(steamid64)
			end

			SteamNames[steamid64] = steamid64
			RequestingSteamName[steamid64] = nil

			return
		end

		if isfunction(func) then
			func(steamName)
		end

		SteamNames[steamid64] = steamName
		RequestingSteamName[steamid64] = nil
	end, function()
		if isfunction(func) then
			func("Problem With Steam :[")
		end

		SteamNames[steamid64] = "Problem With Steam :["
		RequestingSteamName[steamid64] = nil

		BaseWars:Warning("Error fetch steam name of " .. steamid64 .. " (Steam is proly down)")
	end)
end

function BaseWars:GetSteamName(steamid64)
	return SteamNames[steamid64] or steamid64
end

concommand.Add("bw_reset_steamnames", function()
	SteamNames = {
		["0"] = "Console"
	}
end)

function ENTITY:IsClass(class)
	return self:GetClass() == class
end

function PLAYER:GetAFKTime()
	return self:GetNWFloat("BaseWar.AFKTime", CurTime())
end

function PLAYER:IsAFK()
	return CurTime() >= self:GetAFKTime() + BaseWars.Config.AFKTime
end

function PLAYER:HasRadar()
	return self:GetNWBool("BaseWars.HasRadar", false)
end

function PLAYER:GetSpawnProtectionTime()
	return self:GetNWFloat("BaseWars.SpawnImmun", 0)
end

function PLAYER:HasSpawnProtection()
	if BaseWars:RaidGoingOn() and self:InRaid() then
		return false
	end

	return CurTime() < self:GetSpawnProtectionTime()
end

function BaseWars:GetSteamID64(input)
	if not isstring(input) then return "none" end

	if tonumber(input) and #input == 17 then
		return input
	end

	local steamid = string.match(string.lower(input), "steam_0:[01]:%d+")
	if steamid then
		return util.SteamIDTo64(steamid)
	end

	return "none"
end