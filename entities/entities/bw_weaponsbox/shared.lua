ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.PrintName = "Weapons Box"
ENT.Model = "models/props_c17/suitcase001a.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "WeaponCount")
end