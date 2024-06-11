--[[-------------------------------------------------------------------------
	Add/Set Level
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("addlevel", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local level = tonumber(args[2])
	if not level then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	local max = BaseWars.Config.MaxLevel
	if max > 0 and level > max  or target:GetLevel() + level > max then
		level = max
	end

	target:AddLevel(level)

	if target:GetXP() > target:GetXPNextLevel() then
		target:SetXP(0)
	end

	BaseWars:Notify(ply, "#command_addLevel_add", NOTIFICATION_ADMIN, 5, BaseWars:FormatNumber(level), target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_addLevel_addBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatNumber(level))
	end
end, BaseWars:GetSuperAminGroups())

-----------------------------------------------------------------------------

BaseWars:AddChatCommand("setlevel", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local level = tonumber(args[2])
	if not level then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	local max = BaseWars.Config.MaxLevel
	if max > 0 and level > max then
		level = max
	end

	target:SetLevel(level)
	BaseWars:Notify(ply, "#command_setLevel_set", NOTIFICATION_ADMIN, 5, target:Name(), BaseWars:FormatNumber(level))
	if ply != target then
		BaseWars:Notify(target, "#command_setLevel_setBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatNumber(level))
	end
end, BaseWars:GetSuperAminGroups())

--[[-------------------------------------------------------------------------
	Add/Set XP
---------------------------------------------------------------------------]]
BaseWars:AddChatCommand("addxp", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local xp = tonumber(args[2])
	if not xp then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	target:AddXP(xp, true)
	BaseWars:Notify(ply, "#command_addXP_add", NOTIFICATION_ADMIN, 5, BaseWars:FormatNumber(xp), target:Name())
	if ply != target then
		BaseWars:Notify(target, "#command_addXP_addBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatNumber(xp))
	end
end, BaseWars:GetSuperAminGroups())

-----------------------------------------------------------------------------

BaseWars:AddChatCommand("setxp", function(ply, args)
	if not args[2] then
		BaseWars:Notify(ply, "#invalidArguments", NOTIFICATION_ERROR, 5)
		return
	end

	local target = BaseWars:FindPlayer(args[1])
	if not target then
		BaseWars:Notify(ply, "#targetNotFound", NOTIFICATION_ERROR, 5)
		return
	end

	local xp = tonumber(args[2])
	if not xp then
		BaseWars:Notify(ply, "#invalidArgumentNumber", NOTIFICATION_ERROR, 5)
		return
	end

	target:SetXP(xp)
	BaseWars:Notify(ply, "#command_setXP_set", NOTIFICATION_ADMIN, 5, target:Name(), BaseWars:FormatNumber(xp))
	if ply != target then
		BaseWars:Notify(target, "#command_setXP_setBy", NOTIFICATION_GENERIC, 5, ply:Name(), BaseWars:FormatNumber(xp))
	end
end, BaseWars:GetSuperAminGroups())

BaseWars:AddConsoleCommand("calculatexp", function(ply, args, argStr)

	if not args[1] then
		BaseWars:Warning("Invalid argument")
		return
	end

	local targetLevel = tonumber(args[1])
	local beginLevel = tonumber(args[2]) or 1
	local xp = 0
	local t = SysTime() + 1
	local prev = 0

	if targetLevel <= 100000000 then
		marker = 100000
	end

	if targetLevel >= 100000000 then
		marker = 20000000
	end

	local startCalculating = SysTime()
	for i = beginLevel, targetLevel do
		xp = xp + BaseWars:GetLevelXP(i)

		if SysTime() >= t then
			BaseWars:Log(string.Comma(i) .. " [" .. math.Round(i / targetLevel * 100, 2) .. "% | +" .. string.Comma(i - prev) .. "]")
			t = SysTime() + 1
			prev = i
		end
	end
	local endCalculating = SysTime()

	local time = endCalculating - startCalculating
	if time >= 100 then
		time = BaseWars:FormatTime2(time)
	else
		time = string.sub(time, 1, string.len(math.floor(time)) + 7)
	end


	BaseWars:Log("You need " .. BaseWars:FormatNumber(xp) .. " xp to be level " .. BaseWars:FormatNumber(targetLevel))
	BaseWars:Log("Took " .. time .. " secs to calculate!")
end, false, BaseWars:IsSuperAdmin())