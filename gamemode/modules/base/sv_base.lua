local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

util.AddNetworkString("BaseWars:ShowSpare")

function GM:DatabaseInitialized()
	BaseWars:initDatabase()
	BaseWars:ServerLog("Successfully connected to the database.")

	hook.Run("PostDatabaseInitialized")
end

function GM:ShowSpare2(ply)
	net.Start("BaseWars:ShowSpare")
		net.WriteBit(0)
	net.Send(ply)
end

function GM:ShowSpare1(ply)
	net.Start("BaseWars:ShowSpare")
		net.WriteBit(1)
	net.Send(ply)
end

function GM:EntityTakeDamage(ent, dmg)
	local att = dmg:GetAttacker()

	if ent:IsPlayer() and not ent:IsBot() and not ent.basewarsProfileID then
		return true
	end

	if att:IsPlayer() and (att:InSafeZone() or att:HasSpawnProtection()) then
		return true
	end

	if ent:IsPlayer() and (ent:InSafeZone() or ent:HasSpawnProtection()) then
		return true
	end

	if ent:IsPlayer() and ent:IsGodmode() then
		return true
	end

	if BaseWars.Config.Prestige.Enable and att:IsPlayer() then
		dmg:ScaleDamage(1 + (.05 * att:GetPrestigePerk("damage")))
	end

	if ent:IsClass("func_breakable") or ent:IsClass("func_button") then
		return false
	end

	if ent:IsPlayer() and att:IsPlayer() then
		if ent:InFaction() and ent:HasSameFaction(att) then
			if ent:InRaid() then
				return dmg:GetDamageType() != DMG_BLAST
			end

			return not BaseWars:GetFactions()[ent:GetFaction()].ff
		end

		if not BaseWars.Config.Raids.shootPeopleInRaid and (ent:InRaid() and not att:InRaid()) then
			BaseWars:Notify(att, "#raids_cantShootPersonInRaid", NOTIFICATION_WARNING, 8)

			return true
		end

		return false
	end

	local entityOwner = ent:CPPIGetOwner()
	if att:IsPlayer() and not ent:IsPlayer() then
		if not IsValid(entityOwner) or ent:GetMaxHealth() <= 0 then return true end

		if ent:IsClass("prop_physics") then
			if BaseWars:RaidGoingOn() and entityOwner:Enemy(att) then
				ent:SetHealth(ent:Health() - dmg:GetDamage())
			else
				if entityOwner == att and att:GetBaseWarsConfig("damageOwnEntities") then
					ent:SetHealth(ent:Health() - dmg:GetDamage())
				end
			end

			if ent:Health() <= 0 then
				SafeRemoveEntity(ent)
			end
		else
			if BaseWars:RaidGoingOn() then
				return not entityOwner:Enemy(att)
			else
				if entityOwner == att then
					return not att:GetBaseWarsConfig("damageOwnEntities")
				end
			end
		end
	end

	self.BaseClass:EntityTakeDamage(ent, dmg)
end

function GM:PostCleanupMap()
	BaseWars:UnLockAllDoors()

	local safeZone = ents.Create("safe_zone")
	safeZone:Spawn()

	local leaveSpawn = ents.Create("leave_spawn")
	leaveSpawn:Spawn()

	BaseWars:RemoveAllProps()
end

function GM:InitPostEntity()
	BaseWars:UnLockAllDoors()
	BaseWars:RemoveAllProps()

	RunConsoleCommand("sbox_weapons", "0") -- player_class/player_basewars.lua @ line #55
end

function GM:ShutDown()
	if BaseWars.Config.ShutdownRefund then
		BaseWars:RefundAll()
		BaseWars:ServerLog("Refunded everyone!")
	end
end

local function BlockInteraction(ply, ent, bool)
	if not IsValid(ent) then return false end
	if ply:InRaid() then return false end

	local Blacked = BaseWars.Config.PhysgunPickupBlocked
	local Class = ent:GetClass()

	if ((ent.IsExplosive or ent.IsMine) and ent:GetArmed() and not BaseWars.Config.PhysGunExplosive) or string.find(Class, "func") or string.find(Class, "door") or Blacked[Class] then return false end

	local Owner = ent:CPPIGetOwner()

	return (BaseWars:IsAdmin(ply, true) or (IsValid(Owner) and Owner:IsPlayer() and Owner == ply)) or (bool or true)
end

function GM:PhysgunPickup(ply, ent)
	local bool = self.BaseClass:PhysgunPickup(ply, ent)

	if ent:IsPlayer() then
		return BaseWars:IsAdmin(ply, true)
	end

	return BlockInteraction(ply, ent, bool)
end

function GM:OnPhysgunReload(physgun, ply)
	if not BaseWars:IsSuperAdmin(ply) then
		BaseWars:Notify(ply, "#notAllowed", NOTIFICATION_ERROR, 5)
		return false
	end

	return true
end

function GM:CanProperty(ply, prop, ent)
	local bool = self.BaseClass:CanProperty(ply, prop, ent)
	local Admin = BaseWars:IsAdmin(ply, true)
	local Class = ent:GetClass()

	if prop == "persist" then return false end
	if prop == "ignite" then return false end
	if prop == "extinguish" then return Admin end
	if prop == "remover" and string.find(Class, "bw_") then return Admin end

	return BlockInteraction(ply, ent, bool)
end

function GM:GravGunPunt(ply, ent)
	return BaseWars.Config.AllowPunt
end

function ENTITY:SetCurrentValue(amount)
	self:SetNWFloat("CurrentValue", amount or 0)
end

hook.Add("BaseWars:ConfigurationModified", "BaseWars:Base", function(admin, oldConfig, newConfig)
	for _, ply in player.Iterator() do
		local extra = ply:Health() - oldConfig.DefaultHealth

		ply:SetMaxHealth(newConfig.DefaultHealth)

		if extra >= 0 then
			ply:SetHealth(ply:GetMaxHealth() + math.max(extra, 0))
		end
	end
end)

hook.Add("BaseWars:PreConfigurationModified", "BaseWars:Base", function(ply, oldConfig, newConfig)
	-- I need this table in a specific way or BaseWars:FormatNumber() won't work correctly
	local tempFormatNumber = {}
	for k, v in SortedPairs(newConfig.FormatNumber, false) do
		table.insert(tempFormatNumber, v)
	end
	BaseWars.Config.FormatNumber = tempFormatNumber
end)

net.Receive("BaseWars:GamemodeConfigModified", function(len, ply)
	BaseWars:SaveConfig(ply, util.JSONToTable(util.Decompress(net.ReadData(len / 8)), false, false))
end)

local function sendFunc(ply)
	local compressed = util.Compress(util.TableToJSON(BaseWars.Config))
	net.Start("BaseWars:SendGamemodeConfigToClient")
		net.WriteData(compressed, #compressed)
	net.Send(ply)
end

hook.Add("BaseWars:SendNetToClient", "BaseWars:GamemodeConfigToClient", function(ply)
	sendFunc(ply)

	net.Receive("BaseWars:SendGamemodeConfigToClient", function(len, netPly)
		sendFunc(netPly) -- Lua Refresh
	end)
end)