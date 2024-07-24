include("shared.lua")

function ENT:Draw()
	local ply = LocalPlayer()

	if ply:GetPos():Distance(self:GetPos()) <= BaseWars.Config.EntityRenderDistance then
		self:DrawModel()
	end
end