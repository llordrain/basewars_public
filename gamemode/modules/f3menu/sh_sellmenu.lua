local ENTITY = FindMetaTable("Entity")

local BLClass = {
	["prop_physics"] = true,
	["Keypad"] = true,
	["Keypad_Wire"] = true,
	["sammyservers_textscreen"] = true,
	["physgun_beam"] = true,
	["gmod_hands"] = true,
	["zrush_burner"] = true,
	["zrush_drilltower"] = true,
	["zrush_pump"] = true,
	["zrush_refinery"] = true,
	["zrush_drillhole"] = true,
	["zrush_module"] = true,
	["zrms_minecart"] = true,
	["mg_attachment"] = true,
}

function ENTITY:GetCurrentValue()
	return tonumber(self:GetNWFloat("CurrentValue")) or 0
end

function ENTITY:ValidToSell(ply)
	if not ply:IsPlayer() then return false end
	if not IsValid(self) then return false end
	if not self.CPPIGetOwner or self:CPPIGetOwner() != ply then return false end
	if BLClass[self:GetClass()] then return false end
	if self:IsWeapon() or self:IsNPC() then return false end
	if string.find(string.lower(self:GetClass()), "c_") or string.find(string.lower(self:GetClass()), "gmod_") then return false end
	-- if self:GetCurrentValue() == 0 then return false end

	return true
end

function BaseWars:GetValidName(entity, logs)
	local name

	if not IsValid(entity) and entity:IsWorld() then
		name = "World"
	end

	if not IsValid(entity) then
		return "Unknown"
	end

	if entity:IsPlayer() then
		return entity:Name()
	end

	local tbl = entity:GetTable()
	name = (istable(tbl) and (tbl.PrintName or tbl.Name or tbl.name)) or (IsValid(entity) and entity:GetClass()) or notFound

	if not name then
		name = logs and "[CONSOLE/UNKNOWN]" or "Unknown"
	end

	if logs then
		return "{\"" .. name .. "\"}"
	else
		return name
	end
end