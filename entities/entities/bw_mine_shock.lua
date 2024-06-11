AddCSLuaFile()

ENT.Base = "bw_base_mines"
ENT.Author = "llordrain"
ENT.Category = "BaseWars - Explosive"
ENT.PrintName = "Shock Mine"
ENT.Spawnable = true

ENT.TriggerSound = Sound("npc/roller/mine/rmine_shockvehicle2.wav")

ENT.ExplodeRadius = 20
ENT.DetectRange = 220
ENT.TriggerDelay = 0.2
ENT.ShockRange = 500
ENT.ShockAmt = 200

local function stun(ply, dur)
	dur = math.Clamp(dur, 0, 70)

	ply:ConCommand("pp_motionblur 1")
	ply:ConCommand("pp_motionblur_addalpha 0.1")
	ply:ConCommand("pp_motionblur_delay 0.035")
	ply:ConCommand("pp_motionblur_drawalpha " .. math.Clamp(dur * 0.025, 0, 1))

	timer.Simple(dur * .15, function()
		ply:ConCommand("pp_motionblur 0")
	end)
end

function ENT:Trigger()
	self:SetTriggered(true)
	self:EmitSound(self.TriggerSound)

	timer.Simple(self.TriggerDelay, function()
		if IsValid(self) then
			for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.ShockRange)) do
				if v:IsPlayer() then
					stun(v, self.ShockAmt * (self.ShockRange / self:GetPos():Distance(v:GetPos())))
				end
			end

			self:Explode()
		end
	end)
end
