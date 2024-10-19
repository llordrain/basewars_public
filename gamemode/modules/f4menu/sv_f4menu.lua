local function BuyBaseWarsItem(ply, entityID)
	if BASEWARS_SERVER_RESTARTING then return end

	local entityObject = BaseWars:GetBaseWarsEntity(entityID)

	if not entityObject then
		return
	end

	local canBuy, reason = ply:CanBuy(entityID)
	if not canBuy then
		BaseWars:Notify(ply, reason, NOTIFICATION_ERROR, 5)
		return
	end

	if ply:InSafeZone() then
		BaseWars:Notify(ply, "#safeZone_buy", NOTIFICATION_ERROR, 5)
		return
	end

	local entityClass = entityObject:GetClass()
	local entiyPrice = entityObject:GetPrice()
	local entityVehicleName = entityObject:GetVehicleName()

	local entityCooldown = entityObject:GetCooldown()
	if entityCooldown > 0 then
		if CurTime() < ply.basewarsShopCooldowns[entityClass] then
			BaseWars:Notify(ply, "#bws_slowDown", NOTIFICATION_ERROR, 5, math.ceil(ply.basewarsShopCooldowns[entityClass] - CurTime()))

			return
		end

		ply.basewarsShopCooldowns[entityClass] = CurTime() + entityCooldown
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 90
	trace.filter = ply
	local tr = util.TraceLine(trace)

	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	ply:TakeMoney(entiyPrice)

	if entityObject:IsWeapon() then
		if BaseWars.Config.GiveWeaponOnBuy then
			if ply:HasWeapon(entityClass) then
				local weaponData = weapons.Get(entityClass)
				if not weaponData then
					BaseWars:Warning("Weapon \'" .. entityClass .. "\" does not exists in the game somehow?")

					return
				end

				local primary = weaponData.Primary.Ammo
				if primary and isstring(primary) and primary != "" then
					local amount = weaponData.Primary.ClipSize or weaponData.Primary.DefaultClip or 20
					ply:GiveAmmo(amount * 2, primary)
				end

				local secondary = weaponData.Secondary.Ammo
				if secondary and isstring(secondary) and secondary != "" then
					local amount = weaponData.Secondary.ClipSize or weaponData.Secondary.DefaultClip or 20
					ply:GiveAmmo(amount * 2, secondary)
				end
			else
				ply:Give(entityClass)
				ply:SelectWeapon(entityClass)
			end
		else
			local weapon = ents.Create("bw_weapon")
			weapon:SetPos(tr.HitPos)
			weapon:Spawn()
			weapon:SetClass(entityClass)
			weapon:CPPISetOwner(ply)
		end

		hook.Run("BaseWars:BuyWeapon", ply, entityID)
		BaseWars:Notify(ply, "#bws_buyItem", NOTIFICATION_PURCHASE, 5, entityObject:GetName(), BaseWars:FormatMoney(entiyPrice))

		return
	end

	if entityVehicleName then
		local vehicleList = list.Get("Vehicles")
		if not vehicleList[entityVehicleName] then
			BaseWars:Warning("Invalid vehicle name for \"" .. entityVehicleName .. "\"")
			return
		end

		local vehicle = ents.Create(entityClass)
		vehicle.VehicleTable = vehicleList[entityVehicleName]
		for k, v in pairs(vehicleList[entityVehicleName].KeyValues) do
			vehicle:SetKeyValue(k, v)
		end
		vehicle:SetPos(tr.HitPos)
		vehicle:SetAngles(SpawnAng)
		vehicle:SetModel(vehicleList[entityVehicleName].Model)
		vehicle:Spawn()
		vehicle:Activate()
		vehicle:SetCurrentValue(entiyPrice)
		vehicle:CPPISetOwner(ply)
		vehicle.Raidable = true

		hook.Run("BaseWars:BuyVehicle", ply, entityID, vehicle)
		BaseWars:Notify(ply, "#bws_buyItem", NOTIFICATION_PURCHASE, 5, entityObject:GetName(), BaseWars:FormatMoney(entiyPrice))

		return
	end

	local entity = ents.Create(entityClass)
	if entityObject:GetCustomSpawn() then
		entity = entity:SpawnFunction(ply, tr)
	else
		entity:SetPos(tr.HitPos)
		entity:SetAngles(SpawnAng)
		entity:Spawn()
		entity:Activate()
	end

	entity:CPPISetOwner(ply)
	entity:SetCurrentValue(entiyPrice)
	entity.Raidable = true

	--[[-------------------------------------------------------------------------
		ADDONS SUPPORT
	---------------------------------------------------------------------------]]
	if zclib then
		zclib.Player.SetOwner(entity, ply)
	end

	if zrmine then
		entity:SetNWString("zrmine_Owner", ply:SteamID())
	end

	if zmlab then
		zmlab.f.SetOwner(entity, ply)
	end
	-- --[[-------------------------------------------------------------------------
	-- 	ADDONS SUPPORT
	-- ---------------------------------------------------------------------------]]

	if entity.IsPrinter or entity.IsBank then
		entity:SetBaseUpgradePrice(entiyPrice * .5)
	end

	hook.Run("BaseWars:BuyEntity", ply, entity, entityID)
	BaseWars:Notify(ply, "#bws_buyItem", NOTIFICATION_PURCHASE, 5, entityObject:GetName(), BaseWars:FormatMoney(entiyPrice))
end

BaseWars:AddConsoleCommand("basewarsbuy", function(ply, args, argStr)
	if not ply:IsPlayer() then return end

	BuyBaseWarsItem(ply, args[1])
end, false, nil, true)