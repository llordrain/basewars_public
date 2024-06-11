function GM:PreCleanupMap()
	BaseWars:RefundAll()
end

function BaseWars:RefundAll()
	for k, ply in player.Iterator() do
		self:Refund(ply)
	end
end

function BaseWars:Refund(ply)
	local all = 0
	for k, v in pairs(ents.GetAll()) do
		if not IsValid(v) then continue end
		if not v.CPPIGetOwner then continue end
		if v:CPPIGetOwner() != ply then continue end

		all = all + v:GetCurrentValue()

		SafeRemoveEntity(v)
	end

	ply:AddMoney(all)
	BaseWars:Notify(ply, "#command_refund_refundPlayer", NOTIFICATION_WARNING, 10, BaseWars:FormatMoney(all))
	BaseWars:ServerLog("Refunded " .. BaseWars:FormatMoney(all) .. " to " .. ply:Name())
end

function BaseWars:UnLockAllDoors()
	for _, door in pairs(ents.FindByClass("*door*")) do
		door:Fire("unlock")
	end

	BaseWars:NotifyAll("#unlockalldoor", NOTIFICATION_WARNING, 5)
end

function BaseWars:RemoveAllProps()
	if not BaseWars.Config.RemoveProps then
		return
	end

	for k, v in pairs(ents.GetAll()) do
		if v:IsClass("prop_physics") then
			SafeRemoveEntity(v)
		end
	end
end

function BaseWars:EntityTakeDamage(ent, damageInfo, destroyFunc)
	local att = damageInfo:GetAttacker()
	local owner = ent:CPPIGetOwner()

	if owner == att and not owner:GetBaseWarsConfig("damageOwnEntities") then
		return
	end

	if BaseWars:RaidGoingOn() then
		if owner:IsPlayer() and att:IsPlayer() and not owner:Enemy(att) then
			return
		end
	else
		if owner != att then
			return
		end
	end

	ent:SetHealth(ent:Health() - damageInfo:GetDamage())

	if ent:Health() <= 0 then
		local currentValue = ent:GetCurrentValue()

		currentValue = math.floor(currentValue * BaseWars.Config.DestroyReturn)
		if att:IsPlayer() then
			att:GiveMoney(currentValue)
			BaseWars:Notify(att, "#raids_destroyEntity", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(currentValue), BaseWars:GetValidName(ent))
		end

		if owner:IsPlayer() and owner != att then
			owner:GiveMoney(currentValue)
			BaseWars:Notify(owner, "#raids_destroyEntity", NOTIFICATION_GENERIC, 5, BaseWars:FormatMoney(currentValue), BaseWars:GetValidName(ent))
		end

		hook.Run("BaseWars:PlayerDestroyEntity", ent, owner, att, damageInfo:GetInflictor(), currentValue)

		if isfunction(destroyFunc) then
			destroyFunc()
		end
	end
end

function BaseWars:SaveConfig(ply, config)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:BanPlayer(ply:SteamID64(), 0, "Probably hacking (Gamemode Config)", 0)
		return
	end

	local oldConfig = BaseWars.Config
	hook.Run("BaseWars:PreConfigurationModified", ply, oldConfig, config)

	file.Write("basewars/basewars_config.json", util.TableToJSON(config, true))
	BaseWars.Config = config

	hook.Run("BaseWars:ConfigurationModified", ply, oldConfig, config)

	local compressed = util.Compress(util.TableToJSON(config))
	net.Start("BaseWars:GamemodeConfigModified")
		net.WriteData(compressed, #compressed)
	net.Broadcast()

	if BaseWars.Config.NotifyAllWhenConfigModified then
		BaseWars:NotifyAll("#gamemodeConfig_updated", NOTIFICATION_ADMIN, 5)
	else
		BaseWars:Notify(ply, "#gamemodeConfig_updated", NOTIFICATION_ADMIN, 5)
	end
end