AddCSLuaFile()

ENT.Base = "bw_base_electronics"
ENT.Type = "anim"
ENT.Author = "llordrain"
ENT.PrintName = "Radar"
ENT.Category = "BaseWars"
ENT.Spawnable = true
ENT.Model = "models/props_rooftop/roof_dish001.mdl"

if SERVER then
	function ENT:SetMinimap(ply, bool)
		if IsValid(ply) then
			ply:SetHasRadar(bool)
		end
	end

	function ENT:ThinkFuncBypass()
		local Owner = self:CPPIGetOwner()
		if Owner then
			self:SetMinimap(Owner, true)
		end
	end

	function ENT:OnRemove()
		local Owner = self:CPPIGetOwner()
		if Owner then
			self:SetMinimap(Owner, false)
		end
	end
end
