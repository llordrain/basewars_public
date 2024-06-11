ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.PrintName = "Base Entity"
ENT.Model = "models/props_interiors/pot02a.mdl"
ENT.IsBaseWarsEntity = true

function ENT:BadlyDamaged()
	return self:Health() <= (self:GetMaxHealth() * .05)
end