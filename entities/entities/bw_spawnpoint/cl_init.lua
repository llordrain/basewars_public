include("shared.lua")

BaseWars:CreateFont("BaseWars.Spawnpoint", 80, 500)

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) <= 500 and self:CPPIGetOwner() == LocalPlayer() then
		cam.Start3D2D(self:LocalToWorld(Vector(20, 0, 0)), Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
			local bind = input.LookupBinding("+use", true)
			if not bind then bind = "???" end

			draw.SimpleText(LocalPlayer():GetLang("spawnpoint_howto"):format(bind:upper()), "BaseWars.Spawnpoint", 0, 0, color_white, 1, 1)
			draw.SimpleText(LocalPlayer():GetLang("spawnpoint_currentname"):format(self:GetCName()), "BaseWars.Spawnpoint", 0, 60, color_white, 1, 1)
		cam.End3D2D()
	end
end

net.Receive("BaseWars:SetSpawnpointName", function(len)
	local spawnpointName = vgui.Create("BaseWars.VGUI.Spawnpoint.Name")
	spawnpointName:SetSpawnpoint(net.ReadEntity())
end)