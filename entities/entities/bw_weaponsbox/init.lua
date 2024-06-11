AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)

	self:PhysWake()

	timer.Simple(BaseWars.Config.WeaponBoxRemoveTime, function()
		if IsValid(self) then self:Remove() end
	end)

	self.Weapons = {}
end

function ENT:Use(activator, caller, usetype, value)
	if activator and activator:IsPlayer() then
		if self.Weapons and #self.Weapons > 0 then
			for k, v in pairs(self.Weapons) do
				activator:Give(v)
			end
		end

		hook.Run("BaseWars:PlayerPickWeaponBox", activator, self.Weapons)
		self:Remove()
	end
end