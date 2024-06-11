ENT.Base = "bw_base"
ENT.Type = "anim"
ENT.PrintName = "Base Electronics"
ENT.Author = "llordrain"
ENT.Model = "models/props_interiors/pot02a.mdl"
ENT.IsElectronic = true

function ENT:SetupNetWork()
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 30, "Energy")
	self:NetworkVar("Int", 31, "MaxEnergy")

	self:SetupNetWork()
end