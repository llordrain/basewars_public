ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Explosive"
ENT.PrintName = "Generic Mine"
--ENT.Spawnable = true
ENT.Model = "models/props_combine/combine_mine01.mdl"

ENT.TriggerSound = Sound("npc/roller/mine/rmine_tossed1.wav")
ENT.ArmSound = Sound("npc/roller/mine/rmine_predetonate.wav")

ENT.IsMine = true

ENT.ExplodeRadius = 70
ENT.DetectRange = 100
ENT.PresetHealth = 100
ENT.TriggerDelay = 1

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Armed")
	self:NetworkVar("Bool", 1, "Triggered")
end