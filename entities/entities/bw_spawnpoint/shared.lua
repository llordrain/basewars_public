ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.Category = "BaseWars"
ENT.PrintName = "Spawnpoint"
ENT.Spawnable = true
ENT.Model = "models/props_trainstation/trainstation_clock001.mdl"

function ENT:SetupNetWork()
	self:NetworkVar("String", 0, "CName")

	self:NetworkVar("Bool", 0, "DefaultName")
end

ENT.PresetHealth = 1500