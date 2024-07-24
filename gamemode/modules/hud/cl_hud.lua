--[[-------------------------------------------------------------------------
	Hide HL2 HUD elements
---------------------------------------------------------------------------]]
local HideElements = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudDamageIndicator"]	= true,
}

function GM:HUDShouldDraw(element)
	if HideElements[element] then
		return false
	end

	return self.BaseClass:HUDShouldDraw(element)
end

function GM:HUDDrawTargetID()
	return false
end

--[[-------------------------------------------------------------------------
	Utils & Icons
---------------------------------------------------------------------------]]
local bigMargin = BaseWars.ScreenScale * 10
local margin = BaseWars.ScreenScale * 5
local screenWitdh, screenHeight = ScreenWitdh(), ScreenHeight()
local stringComma = string.Comma

local ARMED_COLOR, UNARMED_COLOR = Color(255, 0, 0), Color(0, 255, 0)

local icons = {
	noclip = Material("basewars_materials/hud/noclip.png", "smooth"),
	cloak = Material("basewars_materials/hud/cloak.png", "smooth"),
	spawn_protection = Material("basewars_materials/hud/spawn_protection.png", "smooth"),
	radar_player = Material("basewars_materials/hud/radar_player.png", "smooth")
}

local HL2Weapons = {
	["weapon_bugbait"] = true,
	["weapon_357"] = true,
	["weapon_pistol"] = true,
	["weapon_crossbow"] = true,
	["weapon_crowbar"] = true,
	["weapon_frag"] = true,
	["weapon_ar2"] = true,
	["weapon_rpg"] = true,
	["weapon_slam"] = true,
	["weapon_shotgun"] = true,
	["weapon_smg1"] = true,
	["weapon_stunstick"] = true
}

local function drawShadowText(text, font, x, y, xAlign, yAlign, color)
	draw.SimpleText(text, font, x + 1, y + 1, GetBaseWarsTheme("hud_black"), xAlign, yAlign)
	draw.SimpleText(text, font, x, y, color or GetBaseWarsTheme("hud_white"), xAlign, yAlign)
end

local function miniMapGetVector(ply)
	local pos = ply:GetPos()
	local x, y = pos.x, pos.y

	return Vector(x, y, 0)
end

local function miniMapGetDist(p1, p2)
	local vec1 = miniMapGetVector(p1)
	local vec2 = miniMapGetVector(p2)

	return vec1:Distance(vec2)
end

local function miniMapGetAngle(p1, p2)
	local eyeAngles = p1:EyeAngles()
	local p1Pos = p1:GetPos()
	local p2Pos = p2:GetPos()
	local PosAng = (p1Pos - p2Pos):Angle().y

	return math.AngleDifference(eyeAngles.y - 180, PosAng)
end

local function miniMapGetPos(dist, ang)
	local radCalculated = math.rad(ang + 180)
	local radius = math.Clamp(dist, 0, BaseWars.ScreenScale * 60 * 10) * 0.1
	local posx = -math.sin(-radCalculated) * radius
	local posy = math.cos(radCalculated) * -radius

	return posx, posy
end

--[[-------------------------------------------------------------------------
	HUD Elements
---------------------------------------------------------------------------]]
local timeWide, extraMargin, baseWide = BaseWars.ScreenScale * 110, BaseWars.ScreenScale * 10, BaseWars.ScreenScale * 300
local barTall = BaseWars.ScreenScale * 45
function DrawRaidHUD()
	if not BaseWars:RaidGoingOn() then return end

	local raidTime = BaseWars:FormatTime(BaseWars:GetRaidTime())
	local participants = BaseWars:GetRaidParticipant()

	local attackerW, _ = BaseWars:GetTextSize(participants.attacker.name, "BaseWars.22")
	local defenderW, _ = BaseWars:GetTextSize(participants.defender.name, "BaseWars.22")
	local barWide = math.max(attackerW + extraMargin * 2, defenderW + extraMargin * 2, baseWide)

	BaseWars:DrawRoundedBox(4, (screenWitdh - timeWide) * .5, bigMargin * 2, timeWide, barTall, GetBaseWarsTheme("raid_time"))
	draw.SimpleText(raidTime, "BaseWars.28", screenWitdh * .5, bigMargin * 2 + barTall * .55, GetBaseWarsTheme("raid_text"), 1, 1)

	BaseWars:DrawRoundedBox(4, (screenWitdh - timeWide) * .5 - barWide - margin, bigMargin * 2, barWide, barTall, GetBaseWarsTheme("raid_background"))
	draw.SimpleText(participants.attacker.name, "BaseWars.26", (screenWitdh - timeWide) * .5 - barWide * .5 - margin, bigMargin * 2 + barTall * .48, GetBaseWarsTheme("raid_text"), 1, 1)

	BaseWars:DrawRoundedBox(4, screenWitdh * .5 + timeWide * .5 + margin, bigMargin * 2, barWide, barTall, GetBaseWarsTheme("raid_background"))
	draw.SimpleText(participants.defender.name, "BaseWars.26", screenWitdh * .5 + timeWide * .5 + margin + barWide * .5, bigMargin * 2 + barTall * .48, GetBaseWarsTheme("raid_text"), 1, 1)
end

function DrawExplosiveCounters()
	local ply = LocalPlayer()
	local ticks = math.ceil(1 / engine.TickInterval())
	local barW, barH = BaseWars.ScreenScale * 200, BaseWars.ScreenScale * 40

	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 1500)) do
		if not IsValid(v) then continue end
		if not v.IsExplosive then continue end
		if v:GetDefused() then continue end

		local Pos  = v:GetPos()
		Pos = Pos:ToScreen()

		if v:GetArmed() then
			draw.SimpleText(BaseWars:FormatTime(math.ceil(v:GetCounter())), "BaseWars.20", Pos.x, Pos.y - bigMargin, GetBaseWarsTheme("explosive_text"), 1, 4)

			if v:GetDefusing() then
				BaseWars:DrawRoundedBox(4, Pos.x - barW * .5, Pos.y, barW, barH, GetBaseWarsTheme("explosive_background"))
				BaseWars:DrawRoundedBox(4, Pos.x - barW * .5 + margin, Pos.y + margin, (barW - margin * 2) * math.Clamp(v:GetDefuseTick() / (v.Defuse * ticks), 0, 1), barH - margin * 2, GetBaseWarsTheme("explosive_bar"))
				draw.SimpleText(BaseWars:FormatTime(v:GetDefuseTick() / ticks), "BaseWars.20", Pos.x, Pos.y + barH * .5, GetBaseWarsTheme("explosive_text"), 1, 1)
			end
		end
	end
end

local hudLerps = {
	Armor = 0,
	Health = 0,
	XP = 0,
	Ammo = 0,
	Props = 0,
	EntityHealth = 0,
	EntityEnergy = 0
}
function BaseWarsHUD(ply)
	local lerpFrac = FrameTime() * 16

	-- Health, Armor, Money, Faction
	local plyHealth = ply:Health()
	local plyMaxHealth = ply:GetMaxHealth()
	local plyArmor = ply:Armor()
	local plyMaxArmor = ply:GetMaxArmor()
	local plyMoney = ply:GetMoney()
	local plyFaction = ply:GetFaction()
	local plyFactionColor = ply:GetFactionColor()
	local plyName = ply:Name()
	local plyTimePlayed = ply:GetTimePlayed()
	local plyNameW, _ = BaseWars:GetTextSize(plyName, "BaseWars.20")

	local armorBarSize = BaseWars.ScreenScale * 250
	local healthBarSize = BaseWars.ScreenScale * 290

	hudLerps.Armor = Lerp(lerpFrac, hudLerps.Armor, math.Clamp(plyArmor / plyMaxArmor, 0, 1))
	hudLerps.Health = Lerp(lerpFrac, hudLerps.Health, math.Clamp(plyHealth / plyMaxHealth, 0, 1))

	-- Player Name / Faction
	drawShadowText(plyName .. " / ", "BaseWars.20", BaseWars.ScreenScale * 140, screenHeight - BaseWars.ScreenScale * 140, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	drawShadowText(plyFaction, "BaseWars.20", plyNameW + BaseWars.ScreenScale * 155, screenHeight - BaseWars.ScreenScale * 140, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, plyFactionColor)

	-- Armor
	surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
	draw.NoTexture()
	surface.DrawPoly({
			{
				x = BaseWars.ScreenScale * 130,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = armorBarSize + BaseWars.ScreenScale * 120,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = armorBarSize + BaseWars.ScreenScale * 130,
				y = screenHeight - BaseWars.ScreenScale * 100
			},
			{
				x = BaseWars.ScreenScale * 138,
				y = screenHeight - BaseWars.ScreenScale * 100
			}
		})
	BaseWars:DrawStencil(function()
		surface.DrawPoly({
			{
				x = BaseWars.ScreenScale * 130,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = armorBarSize * hudLerps.Armor + BaseWars.ScreenScale * 120,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = armorBarSize * hudLerps.Armor + BaseWars.ScreenScale * 130,
				y = screenHeight - BaseWars.ScreenScale * 100
			},
			{
				x = BaseWars.ScreenScale * 138,
				y = screenHeight - BaseWars.ScreenScale * 100
			}
		})
	end, function()
		BaseWars:SimpleLinearGradient(BaseWars.ScreenScale * 120, screenHeight - BaseWars.ScreenScale * 120, armorBarSize + BaseWars.ScreenScale * 10, BaseWars.ScreenScale * 20, GetBaseWarsTheme("hud_barArmor1"), GetBaseWarsTheme("hud_barArmor2"), true)
	end)
	draw.SimpleText(stringComma(plyArmor), "BaseWars.20", armorBarSize + BaseWars.ScreenScale * 115, screenHeight - BaseWars.ScreenScale * 111, color_white, 2, 1)

	-- Health
	surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
	draw.NoTexture()
	surface.DrawPoly({
		{
			x = BaseWars.ScreenScale * 139,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = healthBarSize + BaseWars.ScreenScale * 139,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = healthBarSize + BaseWars.ScreenScale * 129,
			y = screenHeight - BaseWars.ScreenScale * 75
		},
		{
			x = BaseWars.ScreenScale * 135,
			y = screenHeight - BaseWars.ScreenScale * 75
		}
	})
	BaseWars:DrawStencil(function()
		surface.DrawPoly({
			{
				x = BaseWars.ScreenScale * 139,
				y = screenHeight - BaseWars.ScreenScale * 95
			},
			{
				x = healthBarSize * hudLerps.Health + BaseWars.ScreenScale * 139,
				y = screenHeight - BaseWars.ScreenScale * 95
			},
			{
				x = healthBarSize * hudLerps.Health + BaseWars.ScreenScale * 129,
				y = screenHeight - BaseWars.ScreenScale * 75
			},
			{
				x = BaseWars.ScreenScale * 135,
				y = screenHeight - BaseWars.ScreenScale * 75
			}
		})
	end, function()
		BaseWars:SimpleLinearGradient(BaseWars.ScreenScale * 135, screenHeight - BaseWars.ScreenScale * 95, healthBarSize + BaseWars.ScreenScale * 10, BaseWars.ScreenScale * 20, GetBaseWarsTheme("hud_barHP1"), GetBaseWarsTheme("hud_barHP2"), true)
	end)
	draw.SimpleText(stringComma(plyHealth), "BaseWars.20", healthBarSize + BaseWars.ScreenScale * 125, screenHeight - BaseWars.ScreenScale * 86, color_white, 2, 1)

	-- Money
	drawShadowText(BaseWars:FormatMoney(plyMoney), "BaseWars.20", BaseWars.ScreenScale * 140, screenHeight - BaseWars.ScreenScale * 75)

	-- Time Played
	drawShadowText(BaseWars:FormatTime2(plyTimePlayed, ply), "BaseWars.20", BaseWars.ScreenScale * 140, screenHeight - BaseWars.ScreenScale * 55)

	-- AFK
	local afkTime = BaseWars:FormatTime2(math.ceil(CurTime() - ply:GetAFKTime()))

	if ply:IsAFK() then
		drawShadowText(ply:GetLang("hud_afkFor"):format(afkTime), "BaseWars.40", screenWitdh * .5, screenHeight * .35, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Spawn Protection - Godmode / Noclip / Cloak
	local spIconSize = 50
	local spTime = math.ceil(ply:GetSpawnProtectionTime() - CurTime())

	if ply:HasSpawnProtection() then
		BaseWars:DrawMaterial(icons["spawn_protection"], screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 120, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
		drawShadowText(spTime, "BaseWars.20", screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 122, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		drawShadowText(ply:GetLang("hud_spawnprotection"), "BaseWars.20", screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 90, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	else
		if ply:InSafeZone() then
			BaseWars:DrawMaterial(icons["spawn_protection"], screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 120, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
			drawShadowText(ply:GetLang("hud_spawnprotection"), "BaseWars.20", screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 90, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if ply:IsGodmode() then
			BaseWars:DrawMaterial(icons["spawn_protection"], screenWitdh * .5, screenHeight - BaseWars.ScreenScale * 120, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
		end
	end

	if ply:IsCloak() then
		BaseWars:DrawMaterial(icons["cloak"], screenWitdh * .5 + BaseWars.ScreenScale * 60, screenHeight - BaseWars.ScreenScale * 120, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
	end

	if ply:IsNocliping() then
		BaseWars:DrawMaterial(icons["noclip"], screenWitdh * .5 - BaseWars.ScreenScale * 60, screenHeight - BaseWars.ScreenScale * 120, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
	end

	-- Level & XP
	local plyLevel = ply:GetLevel()
	local plyXP = ply:GetXP()
	local plyXPForNextLevel = ply:GetXPNextLevel()

	local xpBarWidth, xpBarHeight = BaseWars.ScreenScale * 500, BaseWars.ScreenScale * 5

	hudLerps.XP = Lerp(lerpFrac, hudLerps.XP, math.Clamp(plyXP / plyXPForNextLevel, 0, 1))

	BaseWars:DrawRoundedBox(4, (screenWitdh - xpBarWidth) * .5, screenHeight - xpBarHeight * 4, xpBarWidth, xpBarHeight, GetBaseWarsTheme("hud_barBackground"))
	BaseWars:DrawRoundedBox(4, (screenWitdh - xpBarWidth) * .5, screenHeight - xpBarHeight * 4, xpBarWidth * hudLerps.XP, xpBarHeight, GetBaseWarsTheme("hud_xpBar2"))

	drawShadowText(BaseWars:FormatNumber(plyXP, true), "BaseWars.20", (screenWitdh - xpBarWidth) * .5, screenHeight - xpBarHeight * 4, TEXT_ALIGN_LEF, TEXT_ALIGN_BOTTOM)
	drawShadowText(BaseWars:FormatNumber(plyXPForNextLevel, true), "BaseWars.20", (screenWitdh + xpBarWidth) * .5, screenHeight - xpBarHeight * 4, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	drawShadowText(LocalPlayer():GetLang("hud_level") .. stringComma(plyLevel), "BaseWars.20", screenWitdh * .5, screenHeight - xpBarHeight * 4, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	-- Entity Name, Entity Health, Entity Power
	local targetEntity = ply:GetEyeTrace().Entity
	if IsValid(targetEntity) and ply:GetPos():Distance(targetEntity:GetPos()) <= 200 and targetEntity:GetMaxHealth() > 0 and not string.find(targetEntity:GetClass(), "door") and not string.find(targetEntity:GetClass(), "func") and not targetEntity:IsClass("prop_dynamic") and not targetEntity:IsPlayer() then
		local entityHPBar = BaseWars.ScreenScale * 300
		local entityHealth = targetEntity:Health()
		local entityMaxHealth = targetEntity:GetMaxHealth()
		local entityOwner = "???"
		local entityName = ((targetEntity.PrintName or (targetEntity.GetName and targetEntity:GetName()) or (targetEntity.Nick and targetEntity:Nick()) or targetEntity:GetClass()):Trim()) or "??? (" .. entityName:GetClass() .. ")"
		if entityName == "prop_physics" then entityName = "Prop" end
		if IsValid(targetEntity:CPPIGetOwner()) then entityOwner = targetEntity:CPPIGetOwner():Name() end

		hudLerps.EntityHealth = Lerp(lerpFrac, hudLerps.EntityHealth, math.Clamp(entityHealth / entityMaxHealth, 0, 1))

		drawShadowText(entityName .. " - " .. entityOwner, "BaseWars.20", screenWitdh * .5, screenHeight * .6 - BaseWars.ScreenScale * 2, 1, TEXT_ALIGN_BOTTOM)

		surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
		draw.NoTexture()
		surface.DrawPoly({
			{
				x = (screenWitdh - entityHPBar) * .5,
				y = screenHeight * .6
			},
			{
				x = (screenWitdh + entityHPBar) * .5,
				y = screenHeight * .6
			},
			{
				x = (screenWitdh + entityHPBar) * .5 - BaseWars.ScreenScale * 10,
				y = screenHeight * .6 + BaseWars.ScreenScale * 20
			},
			{
				x = (screenWitdh - entityHPBar) * .5 + BaseWars.ScreenScale * 10,
				y = screenHeight * .6 + BaseWars.ScreenScale * 20
			}
		})
		BaseWars:DrawStencil(function()
		surface.DrawPoly({
			{
				x = (screenWitdh - entityHPBar) * .5,
				y = screenHeight * .6
			},
			{
				x = (screenWitdh + entityHPBar) * .5,
				y = screenHeight * .6
			},
			{
				x = (screenWitdh + entityHPBar) * .5 - BaseWars.ScreenScale * 10,
				y = screenHeight * .6 + BaseWars.ScreenScale * 20
			},
			{
				x = (screenWitdh - entityHPBar) * .5 + BaseWars.ScreenScale * 10,
				y = screenHeight * .6 + BaseWars.ScreenScale * 20
			}
		})
		end, function()
			BaseWars:LinearGradient((screenWitdh - entityHPBar) * .5 + (entityHPBar * .5 * (1 - hudLerps.EntityHealth)), screenHeight * .6, entityHPBar - (entityHPBar * (1 - hudLerps.EntityHealth)), BaseWars.ScreenScale * 20, {{offset = 0, color = GetBaseWarsTheme("hud_barHP2")}, {offset = .5, color = GetBaseWarsTheme("hud_barHP1")}, {offset = 1, color = GetBaseWarsTheme("hud_barHP2")}}, true)
		end)
		draw.SimpleText(stringComma(entityHealth), "BaseWars.20", screenWitdh * .5, screenHeight * .6 + BaseWars.ScreenScale * 9, GetBaseWarsTheme("hud_white"), 1, 1)

		-- if targetEntity.IsElectronic then
		-- 	local entityEnergyBar = BaseWars.ScreenScale * 275
		-- 	local entityEnergy = targetEntity:GetEnergy()
		-- 	local entityMaxEnergy = targetEntity:GetMaxEnergy()

		-- 	hudLerps.EntityEnergy = Lerp(lerpFrac, hudLerps.EntityEnergy, math.Clamp(entityEnergy / entityMaxEnergy, 0, 1))

		-- 	surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
		-- 	draw.NoTexture()
		-- 	surface.DrawPoly({
		-- 		{
		-- 			x = (screenWitdh - entityEnergyBar) * .5,
		-- 			y = screenHeight * .628
		-- 		},
		-- 		{
		-- 			x = (screenWitdh + entityEnergyBar) * .5,
		-- 			y = screenHeight * .628
		-- 		},
		-- 		{
		-- 			x = (screenWitdh + entityEnergyBar) * .5 - BaseWars.ScreenScale * 10,
		-- 			y = screenHeight * .628 + BaseWars.ScreenScale * 20
		-- 		},
		-- 		{
		-- 			x = (screenWitdh - entityEnergyBar) * .5 + BaseWars.ScreenScale * 10,
		-- 			y = screenHeight * .628 + BaseWars.ScreenScale * 20
		-- 		}
		-- 	})
		-- 	BaseWars:DrawStencil(function()
		-- 		surface.DrawPoly({
		-- 			{
		-- 				x = (screenWitdh - entityEnergyBar) * .5,
		-- 				y = screenHeight * .628
		-- 			},
		-- 			{
		-- 				x = (screenWitdh + entityEnergyBar) * .5,
		-- 				y = screenHeight * .628
		-- 			},
		-- 			{
		-- 				x = (screenWitdh + entityEnergyBar) * .5 - BaseWars.ScreenScale * 10,
		-- 				y = screenHeight * .628 + BaseWars.ScreenScale * 20
		-- 			},
		-- 			{
		-- 				x = (screenWitdh - entityEnergyBar) * .5 + BaseWars.ScreenScale * 10,
		-- 				y = screenHeight * .628 + BaseWars.ScreenScale * 20
		-- 			}
		-- 		})
		-- 	end, function()
		-- 		BaseWars:LinearGradient((screenWitdh - entityEnergyBar) * .5 + (entityEnergyBar * .5 * (1 - hudLerps.EntityHealth)), screenHeight * .628, entityEnergyBar - (entityEnergyBar * (1 - hudLerps.EntityHealth)), BaseWars.ScreenScale * 20, {{offset = 0, color = GetBaseWarsTheme("hud_barEnergy2")}, {offset = .5, color = GetBaseWarsTheme("hud_barEnergy1")}, {offset = 1, color = GetBaseWarsTheme("hud_barEnergy2")}}, true)
		-- 	end)
		-- 	draw.SimpleText(stringComma(entityEnergy), "BaseWars.20", screenWitdh * .5, screenHeight * .628 + BaseWars.ScreenScale * 9, GetBaseWarsTheme("hud_white"), 1, 1)
		-- end
	end

	-- Ammo, Weapon, Props
	local weap = ply:GetActiveWeapon()
	local plyPropsCount = ply:GetCount("props")
	local serverMaxProps = cvars.Number( "sbox_maxprops" )

	local propsBarSize = BaseWars.ScreenScale * 290

	hudLerps.Props = Lerp(lerpFrac, hudLerps.Props, math.Clamp(plyPropsCount / serverMaxProps, 0, 1))
	if IsValid(weap) then
		local weaponHasAmmo = (weap.DrawAmmo and weap:Clip1() > -1) or HL2Weapons[weap:GetClass()]

		local weaponClip = weap:Clip1()
		local weaponMaxClip = weap:GetMaxClip1()
		local weaponReserveAmmo = ply:GetAmmoCount(weap:GetPrimaryAmmoType())
		local weaponName = weap:GetPrintName()

		local ammoBarSize = BaseWars.ScreenScale * 250

		hudLerps.Ammo = Lerp(lerpFrac, hudLerps.Ammo, math.Clamp(not weaponHasAmmo and 1 or weaponClip / weaponMaxClip, 0, 1))

		-- Weapon Name
		drawShadowText(weaponName, "BaseWars.20", screenWitdh - BaseWars.ScreenScale * 150, screenHeight - BaseWars.ScreenScale * 140, 2)

		-- Ammo
		surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
		draw.NoTexture()
		surface.DrawPoly({
			{
				x = screenWitdh - ammoBarSize - BaseWars.ScreenScale * 138,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = screenWitdh - BaseWars.ScreenScale * 138,
				y = screenHeight - BaseWars.ScreenScale * 120
			},
			{
				x = screenWitdh - BaseWars.ScreenScale * 148,
				y = screenHeight - BaseWars.ScreenScale * 100
			},
			{
				x = screenWitdh - ammoBarSize - BaseWars.ScreenScale * 148,
				y = screenHeight - BaseWars.ScreenScale * 100
			}
		})

		BaseWars:DrawStencil(function()
			surface.DrawPoly({
				{
					x = screenWitdh - (ammoBarSize * hudLerps.Ammo + BaseWars.ScreenScale * 138),
					y = screenHeight - BaseWars.ScreenScale * 120
				},
				{
					x = screenWitdh - BaseWars.ScreenScale * 138,
					y = screenHeight - BaseWars.ScreenScale * 120
				},
				{
					x = screenWitdh - BaseWars.ScreenScale * 148,
					y = screenHeight - BaseWars.ScreenScale * 100
				},
				{
					x = screenWitdh - (ammoBarSize * hudLerps.Ammo + BaseWars.ScreenScale * 148),
					y = screenHeight - BaseWars.ScreenScale * 100
				}
			})
		end, function()
			BaseWars:SimpleLinearGradient(screenWitdh - ammoBarSize - BaseWars.ScreenScale * 148, screenHeight - BaseWars.ScreenScale * 120, ammoBarSize + BaseWars.ScreenScale * 10, BaseWars.ScreenScale * 20, GetBaseWarsTheme("hud_barAmmo1"), GetBaseWarsTheme("hud_barAmmo2"), true)
		end)
		draw.SimpleText(not weaponHasAmmo and "--" or stringComma(weaponClip) .. "/" .. stringComma(weaponMaxClip) .. " [" .. stringComma(weaponReserveAmmo) .. "]", "BaseWars.20", screenWitdh - ammoBarSize - BaseWars.ScreenScale * 135, screenHeight - BaseWars.ScreenScale * 111, color_white, 0, 1)
	end

	-- Props
	surface.SetDrawColor(GetBaseWarsTheme("hud_barBackground"))
	draw.NoTexture()
	surface.DrawPoly({
		{
			x = screenWitdh - propsBarSize - BaseWars.ScreenScale * 139,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = screenWitdh - BaseWars.ScreenScale * 148,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = screenWitdh - BaseWars.ScreenScale * 146,
			y = screenHeight - BaseWars.ScreenScale * 75
		},
		{
			x = screenWitdh - propsBarSize - BaseWars.ScreenScale * 129,
			y = screenHeight - BaseWars.ScreenScale * 75
		}
	})
	BaseWars:DrawStencil(function()
	surface.DrawPoly({
		{
			x = screenWitdh - (propsBarSize * hudLerps.Props) - BaseWars.ScreenScale * 139,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = screenWitdh - BaseWars.ScreenScale * 148,
			y = screenHeight - BaseWars.ScreenScale * 95
		},
		{
			x = screenWitdh - BaseWars.ScreenScale * 146,
			y = screenHeight - BaseWars.ScreenScale * 75
		},
		{
			x = screenWitdh - (propsBarSize * hudLerps.Props) - BaseWars.ScreenScale * 129,
			y = screenHeight - BaseWars.ScreenScale * 75
		}
	})
	end, function()
		BaseWars:SimpleLinearGradient(screenWitdh - propsBarSize - BaseWars.ScreenScale * 139, screenHeight - BaseWars.ScreenScale * 95, propsBarSize + BaseWars.ScreenScale * 10, BaseWars.ScreenScale * 20, GetBaseWarsTheme("hud_barProps1"), GetBaseWarsTheme("hud_barProps2"), true)
	end)
	draw.SimpleText(plyPropsCount .. "/" .. stringComma(serverMaxProps), "BaseWars.20", screenWitdh - propsBarSize - BaseWars.ScreenScale * 125, screenHeight - BaseWars.ScreenScale * 86, color_white, 0, 1)

	-- Minimap (Radar)
	local iconSize = BaseWars.ScreenScale * 8
	local minimapSize = BaseWars.ScreenScale * 60
	local minimapX, minimapY = screenWitdh - minimapSize * 1.5, screenHeight - minimapSize * 1.5

	BaseWars:DrawCircle(minimapX, minimapY, minimapSize, 360, 0, 360, GetBaseWarsTheme("hud_minimap"))

	if ply:HasRadar() then
		for _, target in pairs(ents.FindInSphere(ply:GetPos(), minimapSize * 10)) do
			if not IsValid(target) then continue end
			if not target:IsPlayer() then continue end
			if not target:Alive() then continue end
			if ply == target then continue end
			if target:IsCloak() then continue end

			local dist = miniMapGetDist(ply, target)
			local ang = miniMapGetAngle(ply, target)
			local posx, posy = miniMapGetPos(dist, ang)
			local color = "hud_minimapAll"
			if target:InFaction() and target:HasSameFaction(ply) then
				color = "hud_minimapAlly"
			elseif ply:Enemy(target) then
				color = "hud_minimapEnemy"
			elseif target:HasSpawnProtection() then
				color = "hud_minimapSpawnProtection"
			end

			BaseWars:DrawMaterial(icons["radar_player"], minimapX - posx, minimapY - posy, iconSize, iconSize, GetBaseWarsTheme(color), -math.AngleDifference(ply:EyeAngles().y, target:EyeAngles().y))
		end

		BaseWars:DrawMaterial(icons["radar_player"], minimapX, minimapY, iconSize, iconSize, GetBaseWarsTheme("hud_minimapYou"), 0)
	end
end

--[[-------------------------------------------------------------------------
	Avatar & Minimap (Radar)
---------------------------------------------------------------------------]]
local AVATAR = {}
function AVATAR:Init()
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetPaintedManually(true)

	if IsValid(LocalPlayer()) then
		self:SetSteamID(LocalPlayer():SteamID64())
	end
end

function AVATAR:SetPlayer(ply, size)
	self.Avatar:SetPlayer(ply, size)
end

function AVATAR:SetSteamID(sid64, size)
	self.Avatar:SetSteamID(sid64, size)
end

function AVATAR:PerformLayout(w,h)
	local H = self:GetTall()

	self.Avatar:SetPos(0, H - h)
	self.Avatar:SetSize(self:GetWide(), h)
end

function AVATAR:Paint(w,h)
	local ShowBaseWarsHUD = hook.Run("HUDShouldDraw", "BaseWarsBaseWarsHUD")
	local ply = LocalPlayer()

	if ShowBaseWarsHUD == false then return end
	if not ply:GetBaseWarsConfig("showHUD") then return end
	if not IsValid(ply) then return end
	if IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():IsClass("gmod_camera") then return end

	BaseWars:DrawStencil(function()
		BaseWars:DrawCircle(w * .5, h * .5, h * .5, 360, 0, 360, color_white)
	end, function()
		self.Avatar:PaintManual()
	end)
end

vgui.Register("BaseWarsVGUI.HUDAvatar", AVATAR, "DPanel")

hook.Add("InitPostEntity", "BaseWars:HUD:Avatar", function()
	ProfilePicture = GetHUDPanel():Add("BaseWarsVGUI.HUDAvatar")
	ProfilePicture:SetSize(BaseWars.ScreenScale * 120, BaseWars.ScreenScale * 120)
	ProfilePicture:SetPos(BaseWars.ScreenScale * 20, screenHeight - BaseWars.ScreenScale * (120 + 30))
	ProfilePicture:SetSteamID(LocalPlayer():SteamID64(), 128)
	ProfilePicture:InvalidateLayout()
end)

function BaseWars:SetHUDAvatar(steamID64)
	if not IsValid(ProfilePicture) then return end

	ProfilePicture:SetSteamID(steamID64, 128)
end

--[[-------------------------------------------------------------------------
	Above Player Information
---------------------------------------------------------------------------]]
-- target:Crouching() pour baiser le text

hook.Add("PostDrawTranslucentRenderables", "BaseWars:AbovePlayerInformation", function()
	cam.IgnoreZ(true)
		local ply = LocalPlayer()
		local plyEyePos = ply:EyePos()
		local aimVec = ply:GetAimVector()
		local plyEyeAngle = ply:EyeAngles()
		local maxViewDistance = 400
		local spIconSize = 80

		for _, target in player.Iterator() do
			if not IsValid(target) then continue end
			if target:GetRenderMode() == RENDERMODE_TRANSALPHA then continue end
			if target:GetPos():Distance(plyEyePos) >= maxViewDistance and not (ply:GetEyeTrace().Entity == target or target:HasSpawnProtection()) then continue end

			if target == ply then continue end
			if not target:Alive() then continue end
			if target:IsDormant() then continue end
			if target:GetColor().a < 100 then continue end
			if target:IsCloak() then continue end

			local inVehicle = target:InVehicle()
			local targetEyePos = target:EyePos()
			local targetHOffset = 0
			local plyFactionColor = target:GetFactionColor()
			local spTime = math.ceil(target:GetSpawnProtectionTime() - CurTime())
			local afkTime = BaseWars:FormatTime2(math.ceil(CurTime() - target:GetAFKTime()))

			if not inVehicle then
				targetHOffset = targetEyePos.z - target:GetPos().z
			end

			local PlayerPosition = targetEyePos - plyEyePos
			local unitPos = PlayerPosition:GetNormalized()
			if unitPos:Dot(aimVec) > 0.35 then
				local fetchTrace = util.QuickTrace(plyEyePos, PlayerPosition, ply)

				if fetchTrace.Hit and fetchTrace.Entity != target then
					continue
				end

				cam.Start3D2D(Vector(targetEyePos.x, targetEyePos.y,target:GetPos().z) + (inVehicle and Vector(0,0,60) or Vector(0,0,math.max(targetHOffset + 18, 55))),ply:InVehicle() and Angle(0,ply:GetVehicle():GetAngles().y + plyEyeAngle.y - 90,90) or Angle(0,plyEyeAngle.y - 90,90),0.1)
					drawShadowText(target:Name(), "BaseWars.65", 0, 0, 1, 0, plyFactionColor)

					if target:InSafeZone() then
						BaseWars:DrawMaterial(icons["spawn_protection"], 0, -30, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
					else
						if target:HasSpawnProtection() then
							BaseWars:DrawMaterial(icons["spawn_protection"], 0, -30, spIconSize, spIconSize, GetBaseWarsTheme("hud_white"), 0)
							drawShadowText(spTime, "BaseWars.30", 0, -35, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end
					end

					if target:IsAFK() then
						drawShadowText(ply:GetLang("hud_afkFor"):format(afkTime), "BaseWars.40", 0, (target:IsGodmode() or target:InSafeZone()) and -120 or -15, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				cam.End3D2D()
			end
		end
	cam.IgnoreZ(false)
end)

--[[-------------------------------------------------------------------------
	Draw the HUD yk...
---------------------------------------------------------------------------]]
function GM:HUDPaint()
	local ply = LocalPlayer()

	if not ply:GetBaseWarsConfig("showHUD") then
		return
	end

	if hook.Run("HUDShouldDraw", "BaseWarsBaseWarsHUD") then
		BaseWarsHUD(ply)
	end

	if hook.Run("HUDShouldDraw", "BaseWarsRaidHUD") then
		DrawRaidHUD(ply)
	end

	if hook.Run("HUDShouldDraw", "BaseWarsExplosiveHUD") then
		DrawExplosiveCounters(ply)
	end

	if hook.Run("HUDShouldDraw", "BaseWarsNotifications") then
		DrawBaseWarsNotifications()
	end

	self.BaseClass:HUDPaint()
end