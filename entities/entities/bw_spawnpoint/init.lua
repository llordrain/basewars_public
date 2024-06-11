AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString("BaseWars:SetSpawnpointName")

local names = {
	"Alpha",
	"Bravo",
	"Charlie",
	"Delta",
	"Echo",
	"Foxtrot",
	"Golf",
	"Hotel",
	"India",
	"Juliett",
	"Kilo",
	"Lima",
	"Mike",
	"November",
	"Oscar",
	"Papa",
	"Quebec",
	"Romeo",
	"Sierra",
	"Tango",
	"Uniform",
	"Victor",
	"Whiskey",
	"X-ray",
	"Yankee",
	"Zulu",
}

function ENT:SpawnFunction(ply, tr)
	local plyPos = ply:GetPos()

	local ent = ents.Create("bw_spawnpoint")
	ent:CPPISetOwner(ply)
	ent:SetPos(plyPos)
	ent:Spawn()
	ent:Activate()

	ply:SetPos(plyPos + Vector(0, 0, 10))

	return ent
end

function ENT:Init()
	self:SetAngles(Angle(-90, 0, 0))
	self:SetCName(table.Random(names))
	self:SetDefaultName(true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:EnableMotion(false)
	end
end

function ENT:Use(ply)
	if not IsValid(ply) then return end
	if self:CPPIGetOwner() != ply then
		BaseWars:Notify(ply, "#spawnpoint_notyours", NOTIFICATION_ERROR, 5)
		return
	end

	net.Start("BaseWars:SetSpawnpointName")
		net.WriteEntity(self)
	net.Send(ply)
end

net.Receive("BaseWars:SetSpawnpointName", function(len, ply)
	local name = net.ReadString()
	local spawnpoint = net.ReadEntity()

	if IsValid(spawnpoint) then
		local oldName = spawnpoint:GetCName()

		spawnpoint:SetCName(name)
		spawnpoint:SetDefaultName(false)

		hook.Run("BaseWars:PlayerRenameSpawnpoint", ply, spawnpoint, oldName, name)
	end
end)