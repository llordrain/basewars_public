local basewarsChatCommand = {}
local basewarsConsoleCommand = {}

function BaseWars:AddChatCommand(command, func, rank)
    if not command or not func then return end

    if istable(command) then
        for k, v in pairs(command) do
            basewarsChatCommand[string.lower(v)] = {
                func = func,
                rank = rank
            }
        end
    else
        basewarsChatCommand[string.lower(command)] = {
            func = func,
            rank = rank
        }
    end
end

function BaseWars:AddConsoleCommand(command, func, consoleOnly, rank)
    if not command or not func then return end

    consoleOnly = consoleOnly or false

    basewarsConsoleCommand[string.lower(command)] = {
        consoleOnly = consoleOnly,
        rank = rank
    }

    concommand.Add(command, function(ply, cmd, args, argStr)
        if ply:IsPlayer() then
            if consoleOnly then
                return
            end

            if rank and not (rank[ply:GetUserGroup()] or BaseWars:IsSuperAdmin(ply)) then
                return
            end
        end


        func(ply, args, argStr)

        hook.Run("BaseWars:ConsoleCommand", ply, cmd, args, argStr)
    end)
end

function BaseWars:GetChatCommands(command)
    if command then
        return basewarsChatCommand[command]
    end

    return basewarsChatCommand --table.Copy(basewarsChatCommand)
end

function BaseWars:GetConsoleCommands(command)
    if command then
        return basewarsConsoleCommand[command]
    end

    return basewarsConsoleCommand --table.Copy(basewarsConsoleCommand)
end