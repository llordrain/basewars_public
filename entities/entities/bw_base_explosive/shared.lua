ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Explosive"
ENT.PrintName = "Generic Explosive"
ENT.Model = "models/weapons/w_c4_planted.mdl"

ENT.IsExplosive = true

ENT.ExplodeTime = 20
ENT.ExplosionRadius = 200
ENT.Damages = 400
ENT.Defuse = 5

ENT.Cluster = ""
ENT.ClusterAmount = 0

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Counter")
	self:NetworkVar("Int", 1, "DefuseTick")

	self:NetworkVar("Bool", 0, "Armed")
	self:NetworkVar("Bool", 1, "Defused")
	self:NetworkVar("Bool", 2, "CoutingDown")
end

function ENT:GetDefusing()
	return self:GetDefuseTick() > 0 or false
end