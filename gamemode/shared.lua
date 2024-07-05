GM.Name = "BaseWars"
GM.Author = "llordrain"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Version = "1.0.0"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

BaseWars = {}
BaseWars.Config = {}
BaseWars.LANG = {}

--[[-------------------------------------------------------------------------
	MARK: Global Constants
---------------------------------------------------------------------------]]
BASEWARS_MAX_U32 = 0x100000000 -- 2 ^ 32 | 4,294,967,296
BASEWARS_MAX_I32 = 0x7FFFFFFF -- 2 ^ 31 - 1 | 2,147,483,647

--[[-------------------------------------------------------------------------
	MARK: Constants
---------------------------------------------------------------------------]]
local BASEWARS_ROOT = GM.FolderName .. "/gamemode/modules"
local BASEWARS_BASE_MODULE = GM.FolderName .. "/gamemode/modules/base"
local LOG_COLOR = SERVER and Color(0, 200, 50) or Color(50, 230, 230)
local WARNING_COLOR = Color(255, 0, 0)
local SERVER_LOG_COLOR = Color(255, 255, 0)
local MYSQL_COLOR = Color(50, 230, 230)
local PRINT_FILES_COLOR = Color(255, 0, 255)
local FORCE_ENABLE = {
	["admin_menu"] = true,
	["bounty"] = true,
	["bw_vgui"] = true,
	["commands"] = true,
	["f3menu"] = true,
	["f4menu"] = true,
	["faction"] = true,
	["level"] = true,
	["money"] = true,
	["notify"] = true,
	["payday"] = true,
	["prestige"] = true,
	["profiles"] = true,
	["raid"] = true,
	["spawnmenu"] = true,
	["timeplay"] = true,
}

--[[-------------------------------------------------------------------------
	MARK: Global Functions
---------------------------------------------------------------------------]]
local modulesData = {}
function BaseWars:GetModules()
	return table.Copy(modulesData)
end

--[[-------------------------------------------------------------------------
	MARK: Local Functions
---------------------------------------------------------------------------]]
local function checkModule(moduleID, moduleData)
	if not moduleData then
		return false, "No module data at all for module \"" .. moduleID .. "\""
	end

	local errorMessage = "Error in module.lua for module \"" .. moduleID .. "\" %s"
	if not moduleData.author then
		return false, Format(errorMessage, "missing author")
	end

	if not moduleData.version then
		return false, Format(errorMessage, "missing version")
	end

	if not moduleData.name then
		return false, Format(errorMessage, "missing name")
	end

	if not moduleData.desc then
		return false, Format(errorMessage, "missing description")
	end

	if moduleData.enable == nil then
		return false, Format(errorMessage, "missing \"enable\" field")
	end

	return true, "Hello :]"
end

local function argsToString(...)
	local args = {...}
	local text = ""

	for k, v in ipairs(args) do
		text = text .. tostring(v) .. (k == #args and "" or "\t")
	end

	return string.Trim(text)
end

--[[-------------------------------------------------------------------------
	MARK: Printing Functions
---------------------------------------------------------------------------]]
function BaseWars:Log(...)
	MsgC(LOG_COLOR, "[BaseWars]", color_white, " » ", LOG_COLOR, argsToString(...), "\n")
end

function BaseWars:Warning(...)
	MsgC(WARNING_COLOR, "[BaseWars Warning]", color_white, " » ", WARNING_COLOR, argsToString(...), "\n")
end

function BaseWars:ServerLog(...)
	MsgC(SERVER_LOG_COLOR, "[BaseWars Server Log]", color_white, " » ", SERVER_LOG_COLOR, argsToString(...), "\n")
end

function BaseWars:PrintFiles(what, path)
	MsgC(PRINT_FILES_COLOR, "[" .. what .. "]", color_white, " » ", PRINT_FILES_COLOR, path, "\n")
end

if SERVER then
	function BaseWars:SQLLogs(...)
		MsgC(MYSQL_COLOR, "[BaseWars MySQL]", color_white, " » ", MYSQL_COLOR, argsToString(...), "\n")
	end
end

--[[-------------------------------------------------------------------------
	MARK: Including Files Functions
---------------------------------------------------------------------------]]
local function includeShared(path)
	if SERVER then
		AddCSLuaFile(path)
	end

	include(path)
end

local function includeServer(path)
	if CLIENT then return end

	include(path)
end

local function IncludeClient(path)
	if SERVER then
		AddCSLuaFile(path)
	else
		include(path)
	end
end

local allFiles = {}
allFiles["base"] = {}

allFiles["init"] = {}
allFiles["shared"] = {}
allFiles["base"]["shared"] = {}

if SERVER then
	allFiles["server"] = {}
	allFiles["base"]["server"] = {}
	allFiles["database"] = {}
end

allFiles["client"] = {}
allFiles["base"]["client"] = {}

local moduleCount = 0
local fileCount = 0
function BaseWars:LoadModules(afterInitFunc)
	local startLoadModules = SysTime()
	local _, modules = file.Find(BASEWARS_ROOT .. "/*", "LUA")
	for _, moduleName in ipairs(modules) do
		if moduleName == "base" then
			local moduleFiles, _ = file.Find(BASEWARS_BASE_MODULE .. "/*.lua", "LUA")

			for _, moduleFile in ipairs(moduleFiles) do
				local filePath = BASEWARS_ROOT .. "/" .. moduleName .. "/" .. moduleFile

				if string.Left(moduleFile, 3) == "sh_" then
					table.insert(allFiles["base"]["shared"], filePath)
				end

				if SERVER and string.Left(moduleFile, 3) == "sv_" then
					table.insert(allFiles["base"]["server"], filePath)
				end

				if string.Left(moduleFile, 3) == "cl_" then
					table.insert(allFiles["base"]["client"], filePath)
				end
			end

			continue -- "base" module is loaded separately
		end

		local moduleDotLua = BASEWARS_ROOT .. "/" .. moduleName .. "/module.lua"
		if not file.Exists(moduleDotLua, "LUA") then
			BaseWars:Warning("No module.lua file found for module \"" .. moduleName .. "\", ignoring")
			continue
		end

		if SERVER then
			AddCSLuaFile(moduleDotLua)
		end

		modulesData[moduleName], moduleKey = include(moduleDotLua)
		moduleKey = string.Trim(moduleKey or "none")

		modulesData[moduleName]["id"] = moduleName
		modulesData[moduleName]["key"] = moduleKey

		local bool, errorMessage = checkModule(moduleName, modulesData[moduleName])
		if not bool then
			BaseWars:Warning(errorMessage)
			continue
		end

		if moduleKey != "" and moduleKey != "none" then
			if BaseWars[moduleKey] then
				BaseWars:Warning("Module key \"" .. moduleKey .. "\" is already used, ignoring module key for module \"" .. moduleName .. "\"")
			else
				BaseWars[moduleKey] = {}

				BaseWars[moduleKey]["GetModuleData"] = function(moduleSelf)
					return modulesData[moduleName]
				end

				if SERVER then
					BaseWars:Log("Created table \"BaseWars." .. moduleKey .. "\" & function \"BaseWars." .. moduleKey .. ":GetModuleData()\" for module \"" .. moduleName .. "\"")
				end
			end
		end

		if FORCE_ENABLE[moduleName] and not modulesData[moduleName]["enable"] then
			modulesData[moduleName]["enable"] = true
			BaseWars:Warning("The gamemode forcefully enabled the module \"" .. moduleName .. "\". This module cannot be disabled, please change the \"enable\" field in modules/" .. moduleName .. "/module.lua to \"true\" to not see this message again")
		end

		if not modulesData[moduleName]["enable"] then
			if SERVER then
				BaseWars:ServerLog("Module \"" .. moduleName .. "\" is disabled, ignoring")
			end

			continue
		end

		local moduleFiles, _ = file.Find(BASEWARS_ROOT .. "/" .. moduleName .. "/*.lua", "LUA")
		if not moduleFiles or #moduleFiles <= 1 then
			if SERVER then
				BaseWars:Warning("No file found in module \"" .. moduleName .. "\"")
			end

			continue
		end

		moduleCount = moduleCount + 1
		fileCount = fileCount + (#moduleFiles - 1)
		modulesData[moduleName]["fileCount"] = #moduleFiles - 1

		local moduleInitFile = ""
		local moduleDBFile = ""
		for _, moduleFile in ipairs(moduleFiles) do
			local filePath = BASEWARS_ROOT .. "/" .. moduleName .. "/" .. moduleFile

			if string.Left(moduleFile, 5) == "init_" then
				if moduleInitFile != "" then
					BaseWars:Warning("Module \"" .. moduleName .. "\" already has an init file (" .. moduleFile .. "), ignoring \"" .. filePath .. "\"") -- Why would you need more than 1 init_*.lua file??
					continue
				end

				moduleInitFile = filePath
				table.insert(allFiles["init"], filePath)
			end

			local fileType = string.Left(moduleFile, 3)

			if fileType == "sh_" then
				table.insert(allFiles["shared"], filePath)
			end

			if SERVER then
				if fileType == "sv_" then
					table.insert(allFiles["server"], filePath)
				end

				if fileType == "db_" then
					if moduleDBFile != "" then
						BaseWars:Warning("Module \"" .. moduleName .. "\" already has a database file (" .. moduleFile .. "), ignoring \"" .. filePath .. "\"") -- Why would you need more than 1 db_*.lua file??
						continue
					end

					moduleDBFile = filePath
					table.insert(allFiles["database"], filePath)
				end
			end

			if fileType == "cl_" then
				table.insert(allFiles["client"], filePath)
			end
		end
	end

	--[[-------------------------------------------------------------------------
		MARK: Inculding Files
	---------------------------------------------------------------------------]]
	local initCount = 0
	for _, filePath in ipairs(allFiles["init"]) do
		initCount = initCount + 1
		includeShared(filePath)
	end
	BaseWars:Log("Initialized " .. initCount .. " modules")

	if isfunction(afterInitFunc) then
		afterInitFunc()
	end

	-- BASE MODULE
	for _, filePath in ipairs(allFiles["base"]["shared"]) do
		includeShared(filePath)
	end

	if SERVER then
		for _, filePath in ipairs(allFiles["base"]["server"]) do
			includeServer(filePath)
		end
	end

	for _, filePath in ipairs(allFiles["base"]["client"]) do
		IncludeClient(filePath)
	end
	BaseWars:Log("Successfully loaded base module")
	-- BASE MODULE

	for _, filePath in ipairs(allFiles["shared"]) do
		includeShared(filePath)
	end

	if SERVER then
		for _, filePath in ipairs(allFiles["server"]) do
			includeServer(filePath)
		end

		for _, filePath in ipairs(allFiles["database"]) do
			includeServer(filePath)
		end
	end

	for _, filePath in ipairs(allFiles["client"]) do
		IncludeClient(filePath)
	end

	BaseWars:ServerLog("Registered " .. table.Count(BaseWars:GetChatCommands()) .. " chat commands")

	if SERVER then
		BaseWars:ServerLog("Registered " .. table.Count(BaseWars:GetConsoleCommands()) .. " console commands")
	end

	BaseWars:Log(Format("Successfully loaded " .. moduleCount .. " modules (" .. fileCount .. " Files) in %.5f sec.", SysTime() - startLoadModules))
end

--[[-------------------------------------------------------------------------
	MARK: Console Commands
---------------------------------------------------------------------------]]
if SERVER then
	concommand.Add("bw_print_files", function(ply, cmd, args, argStr)
		if ply:IsPlayer() then return end

		for k, v in ipairs(allFiles["init"]) do
			BaseWars:PrintFiles("Init", v)
		end

		-- BASE MODULE
		for k, v in ipairs(allFiles["base"]["shared"]) do
			BaseWars:PrintFiles("Base - Shared", v)
		end

		if SERVER then
			for k, v in ipairs(allFiles["base"]["server"]) do
				BaseWars:PrintFiles("Base - Server", v)
			end
		end

		for k, v in ipairs(allFiles["base"]["client"]) do
			BaseWars:PrintFiles("Base - Client", v)
		end
		-- BASE MODULE

		if SERVER then
			for k, v in ipairs(allFiles["server"]) do
				BaseWars:PrintFiles("Server", v)
			end

			for k, v in ipairs(allFiles["database"]) do
				BaseWars:PrintFiles("Database", v)
			end
		end

		for k, v in ipairs(allFiles["client"]) do
			BaseWars:PrintFiles("Client", v)
		end

		BaseWars:Log("Module Count: " .. moduleCount)
		BaseWars:Log("File Count: " .. fileCount)
	end)
end