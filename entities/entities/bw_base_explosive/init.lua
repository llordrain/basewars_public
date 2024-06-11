AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local disarmedSound = Sound("weapons/c4/c4_disarm.wav")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetUseType(CONTINUOUS_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)

	self:PhysWake()

	self:SetCounter(self.ExplodeTime)
	self:SetDefuseTick(0)

	self:SetArmed(false)
	self:SetDefused(false)
	self:SetCoutingDown(false)

	self.Time = CurTime()
	self.used = 0
end

function ENT:Defused()
	self:SetDefused(true)
	self:SetArmed(false)
	self:SetCoutingDown(false)
	self:MakeDisapear()
	self:EmitSound(disarmedSound)

	self:OnDefused()
end

function ENT:OnDefused()
end

function ENT:MakeDisapear()
	local a = self:GetColor().a
	a = a - 5

	if a <= 0 then
		SafeRemoveEntity(self)
		return
	end

	self:SetColor(ColorAlpha(self:GetColor(), a))
	timer.Simple(.01, function()
		if IsValid(self) then
			self:MakeDisapear()
		end
	end)
end

function ENT:PlantOn(ent)
	self:SetMoveType(MOVETYPE_NONE)
	self:EmitSound(Sound("weapons/c4/c4_plant.wav"))
	self:Plant()
end

function ENT:Explode()
	local bombOwner = self:CPPIGetOwner()



	if not bombOwner or not bombOwner:InRaid() then
		self:Defused()
		return
	end

	for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.ExplosionRadius)) do
		if not IsValid(v) then
			continue
		end

		if v:IsClass("prop_physics") then
			continue
		end

		if BaseWars.Config.BombsOpenDoors and string.find(v:GetClass(), "door") then
			v:Fire("unlock")
			v:Fire("open")
		end

		if v:GetMaxHealth() <= 0 then
			continue
		end

		local isPlayer = v:IsPlayer()
		if isPlayer and (v:IsGodmode() or not v:InRaid()) then
			continue
		end

		local entityOwner = v:CPPIGetOwner()
		if not isPlayer then
			if not IsValid(entityOwner) then
				continue
			end

			if not bombOwner:Enemy(entityOwner) then
				continue
			end
		end

		local mult = 1 - (self:GetPos():Distance(v:GetPos()) / self.ExplosionRadius)
		local damages = self.Damages * mult

		local damageInfo = DamageInfo()
		damageInfo:SetAttacker(bombOwner)
		damageInfo:SetInflictor(self)
		damageInfo:SetDamageType(DMG_BLAST)
		damageInfo:SetDamage(damages)

		v:TakeDamageInfo(damageInfo)
	end

	self:ExplosionEffect()

	if isstring(self.Cluster) and string.len(self.Cluster) > 0 then
		for i = 1, ClusterAmount do
			local cluster = ents.Create(self.Cluster)
			cluster:SetPos(self:GetPos() + Vector(math.random(-90, 90), math.random(-90, 90), 32))
			cluster:Spawn()
			cluster:Activate()
			cluster:SetAngles(AngleRand())

			local phys = cluster:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddVelocity(Vector(math.random(-7000, 7000), math.random(-7000, 7000), 4000))
			end

			constraint.NoCollide(cluster, self, 0, 0)
		end
	end

	SafeRemoveEntity(self)
end

function ENT:ExplosionEffect()
	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	util.Effect("Explosion", effect)

	self:EmitSound("weapons/hegrenade/explode5.wav")
end

function ENT:Plant()
	self:SetMoveType(MOVETYPE_NONE)
	self:EmitSound(Sound("weapons/c4/c4_plant.wav"))
	self:SetArmed(true)
	self:SetCoutingDown(true)

	self:OnPlant()
end

function ENT:OnPlant()
end

function ENT:Use(ply, caller, useType, value)
	if not (IsValid(ply) and ply:IsPlayer()) then return end

	local traceEntity = ply:GetEyeTrace().Entity
	if self:GetArmed() then
		if IsValid(traceEntity) then
			if traceEntity == self then
				self:SetDefuseTick(self:GetDefuseTick() + 1)
				self.used = 3
			end
		else
			self:SetDefuseTick(0)
		end
	else
		self:Plant()
	end
end

function ENT:Think()
	if not IsValid(self:CPPIGetOwner()) then
		self:Remove()
	end

	if self:GetArmed() and self:GetCoutingDown() then

		if self:GetCounter() <= 0 then
			self:SetCoutingDown(false)
			self:Explode()
		else
			if self.Time + 1 <= CurTime() then
				self:SetCounter(self:GetCounter() - 1)
				self.Time = CurTime()
			end
		end

		if self.used <= 0 then
			self:SetDefuseTick(0)
		else
			self.used = self.used - 1
		end

		if self:GetDefuseTick() >= self.Defuse * math.ceil(1 / engine.TickInterval()) and not self:GetDefused() then
			self:Defused()
		end
	end

	self:NextThink(CurTime() + .05)
	return true
end