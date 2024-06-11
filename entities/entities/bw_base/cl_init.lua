include("shared.lua")

function ENT:Draw()
	local ply = LocalPlayer()

	local spec = FSpectate and FSpectate:GetSpecEnt()
	if IsValid(spec) and spec:IsPlayer() then
		ply = spec
	end

	if ply:GetPos():Distance(self:GetPos()) <= BaseWars.Config.EntityRenderDistance then
		self:DrawModel()
	end
end