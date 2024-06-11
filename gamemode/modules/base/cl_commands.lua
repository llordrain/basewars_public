local basewarsChatCommand = {}
function BaseWars:AddChatCommand(command, rank, desc, args)
    if not command then return end

    if istable(command) then
        for k, v in pairs(command) do
            basewarsChatCommand[string.lower(v)] = {rank = rank, desc = desc or "#commands_NoDesc", args = args}
        end
    else
        basewarsChatCommand[string.lower(command)] = {rank = rank, desc = desc or "#commands_NoDesc", args = args}
    end
end

function BaseWars:GetChatCommands(cmd)
    if cmd then
        return basewarsChatCommand[cmd]
    end

    return table.Copy(basewarsChatCommand)
end