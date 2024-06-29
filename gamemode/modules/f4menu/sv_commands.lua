BaseWars:AddChatCommand("shop", function(ply, args)
	ply:SendLua("GAMEMODE:ShowSpare2()")
end)

BaseWars:AddConsoleCommand("spawnent", function(ply, args, agrStr)
	if not IsValid(ply) then return end

	local class = args[1]
	if not class then
		return
	end

	local entityExist = scripted_ents.Get(class)
	if not entityExist then
		return
	end

	local entity = ents.Create(class)
	entity:SetPos(ply:GetEyeTrace().HitPos)
	entity:Spawn()

	if entity.CPPISetOwner then
		entity:CPPISetOwner(ply)
	end

	BaseWars:Notify(ply, "Spawned " .. BaseWars:GetValidName(entity), NOTIFICATION_GENERIC, 5)
end, false, BaseWars:GetSuperAdminGroups())