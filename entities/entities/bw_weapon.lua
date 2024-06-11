AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "BaseWars Spawned Weapon"
ENT.Author = "llordrain"
ENT.Model = "models/weapons/w_smg1.mdl"

ENT.Weapon = "weapon_smg1"

if CLIENT then return end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysWake()
	self:Activate()
	self:SetUseType(SIMPLE_USE)
end

function ENT:SetClass(class)
	self.Weapon = class

	local model = "models/weapons/w_smg1.mdl"
	if BaseWars.HL2Weapons[class] then
		model = BaseWars.HL2Weapons[class].model or "models/weapons/w_smg1.mdl"
	else
		model = weapons.Get(class).WorldModel or "models/weapons/w_smg1.mdl"
	end

	self:SetModel(model)
end

function ENT:Use(ply)
	ply:Give(self.Weapon)
	ply:SelectWeapon(self.Weapon)

	self:Remove()
end
