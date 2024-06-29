local PANEL = FindMetaTable("Panel")

function BaseWars:DrawMaterial(mat, x, y, w, h, color, ang)
	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(mat)

	if ang then
		surface.DrawTexturedRectRotated(x, y, w, h, ang)
	else
		surface.DrawTexturedRect(x, y, w, h)
	end
end

function BaseWars:DrawStencil(shape, paint)
	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_ZERO)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(1)

	shape()

	render.SetStencilFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(1)

	paint()

	render.SetStencilEnable(false)
	render.ClearStencil()
end

-- TDLib https://github.com/Threebow/tdlib/blob/master/tdlib.lua#L39
function BaseWars:DrawArc(x, y, ang, p, rad, color, seg)
	seg = seg or 80
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {x = x, y = y})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
	end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	draw.NoTexture()
	surface.DrawPoly(circle)
end

-- Threebow Lib
function BaseWars:DrawRoundedBoxEx(radius, x, y, w, h, col, tl, tr, bl, br)
	-- Validate input
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	radius = math.Clamp(math.floor(radius), 0, math.min(h / 2, w / 2))

	if radius == 0 then
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, w, h)
		return
	end

	-- Draw all rects required
	surface.SetDrawColor(col)
	surface.DrawRect(x + radius, y, w - radius * 2, radius)
	surface.DrawRect(x, y + radius, w, h-radius * 2)
	surface.DrawRect(x + radius, y + h - radius, w - radius * 2, radius)

	-- Draw the four corner arcs
	if tl then
		BaseWars:DrawArc(x + radius, y + radius, 270, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, radius, radius)
	end

	if tr then
		BaseWars:DrawArc(x + w - radius, y + radius, 0, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x + w - radius, y, radius, radius)
	end

	if bl then
		BaseWars:DrawArc(x + radius, y + h - radius, 180, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y + h - radius, radius, radius)
	end

	if br then
		BaseWars:DrawArc(x + w - radius, y + h - radius, 90, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x + w - radius, y + h - radius, radius, radius)
	end
end

function BaseWars:DrawRoundedBox(radius, x, y, w, h, col)
	self:DrawRoundedBoxEx(radius, x, y, w, h, col, true, true, true, true)
end

local blurMaterial = Material("pp/blurscreen")
function BaseWars:DrawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurMaterial)

	for i = 1, amount do
		blurMaterial:SetFloat("$blur", (i / 3) * (amount or 3))
		blurMaterial:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function BaseWars:DrawCircle(x, y, radius, vertices, angle, v, color)
	local circle = {}

	table.insert(circle, {x = x, y = y})

	for i = 0, vertices do
		local a = math.rad((i / vertices) * -v - angle)
		table.insert(circle, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius})
	end

	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(circle)
end

function BaseWars:GetTextSize(text, font)
	if not font or not text then return end

	surface.SetFont(font)
	return surface.GetTextSize(text)
end

-- https://github.com/Bo98/garrysmod-util/blob/master/lua/autorun/client/gradient.lua
-- Gradient helper functions
-- By Bo Anderson
-- Licensed under Mozilla Public License v2.0

local mat_white = Material("vgui/white")
function BaseWars:SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)
	self:LinearGradient(x, y, w, h, { {offset = 0, color = startColor}, {offset = 1, color = endColor} }, horizontal)
end

function BaseWars:LinearGradient(x, y, w, h, stops, horizontal)
	if #stops == 0 then
		return
	end

	if #stops == 1 then
		surface.SetDrawColor(stops[1].color)
		surface.DrawRect(x, y, w, h)
		return
	end

	table.SortByMember(stops, "offset", true)

	render.SetMaterial(mat_white)
	mesh.Begin(MATERIAL_QUADS, #stops - 1)
	for i = 1, #stops - 1 do
		local offset1 = math.Clamp(stops[i].offset, 0, 1)
		local offset2 = math.Clamp(stops[i + 1].offset, 0, 1)
		if offset1 == offset2 then continue end

		local deltaX1, deltaY1, deltaX2, deltaY2

		local color1 = stops[i].color
		local color2 = stops[i + 1].color

		local r1, g1, b1, a1 = color1.r, color1.g, color1.b, color1.a
		local r2, g2, b2, a2
		local r3, g3, b3, a3 = color2.r, color2.g, color2.b, color2.a
		local r4, g4, b4, a4

		if horizontal then
			r2, g2, b2, a2 = r3, g3, b3, a3
			r4, g4, b4, a4 = r1, g1, b1, a1
			deltaX1 = offset1 * w
			deltaY1 = 0
			deltaX2 = offset2 * w
			deltaY2 = h
		else
			r2, g2, b2, a2 = r1, g1, b1, a1
			r4, g4, b4, a4 = r3, g3, b3, a3
			deltaX1 = 0
			deltaY1 = offset1 * h
			deltaX2 = w
			deltaY2 = offset2 * h
		end

		mesh.Color(r1, g1, b1, a1)
		mesh.Position(Vector(x + deltaX1, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r2, g2, b2, a2)
		mesh.Position(Vector(x + deltaX2, y + deltaY1))
		mesh.AdvanceVertex()

		mesh.Color(r3, g3, b3, a3)
		mesh.Position(Vector(x + deltaX2, y + deltaY2))
		mesh.AdvanceVertex()

		mesh.Color(r4, g4, b4, a4)
		mesh.Position(Vector(x + deltaX1, y + deltaY2))
		mesh.AdvanceVertex()
	end
	mesh.End()
end

function BaseWars:LerpColor(frac, from, to)
	return Color(
		Lerp(frac, from.r, to.r),
		Lerp(frac, from.g, to.g),
		Lerp(frac, from.b, to.b),
		Lerp(frac, from.a, to.a)
	)
end

function BaseWars:ReloadCustomTheme()
	local themes, _ = file.Find("basewars/themes/*.json", "DATA")
	for k, v in pairs(themes) do
		local json = file.Read("basewars/themes/" .. v, "DATA")
		local theme = util.JSONToTable(json)
		local id = string.sub(v, 1, #v - 5)

		if BaseWars.DefaultTheme[id] then
			continue
		end

		if not theme.themeName then
			continue
		end

		for colorID, color in pairs(theme) do
			if not isnumber(color.r) or not isnumber(color.g) or not isnumber(color.b) or not isnumber(color.a) then
				continue
			end

			theme[colorID] = Color(color.r, color.g, color.b, color.a)
		end

		AddTheme(id, theme)

		BaseWars:Log("Added theme: " .. theme.themeName)
	end
end

function BaseWars:CreateDefaultTheme()
	for themeID, theme in pairs(BaseWars.Themes) do
		local temp = {}
		for id, color in pairs(theme) do
			temp[id] = color
		end

		file.Write("basewars/themes/" .. themeID .. ".json", util.TableToJSON(temp, true))
	end

	BaseWars:Log("Created default theme")
end

function BaseWars:CreateFont(name, size, weight, extra)
	if not name or not size then return end
	weight = weight or 500

	fontData = {
		font = "Montserrat Medium",
		size = size,
		weight = weight,
		extended = true,
	}

	fontDataMono = {
		font = "Kode Mono Medium",
		size = size,
		weight = weight,
		extended = true,
	}

	if extra and istable(extra) then
		table.Merge(fontData, extra)
		table.Merge(fontDataMono, extra)
	end

	surface.CreateFont(name, fontData)
	surface.CreateFont(name .. ".Mono", fontDataMono)
end

local WEIGHT = 500
BaseWars:CreateFont("BaseWars.14", BaseWars.ScreenScale * 14, WEIGHT)
BaseWars:CreateFont("BaseWars.16", BaseWars.ScreenScale * 16, WEIGHT)
BaseWars:CreateFont("BaseWars.18", BaseWars.ScreenScale * 18, WEIGHT)
BaseWars:CreateFont("BaseWars.20", BaseWars.ScreenScale * 20, WEIGHT)
BaseWars:CreateFont("BaseWars.22", BaseWars.ScreenScale * 22, WEIGHT)
BaseWars:CreateFont("BaseWars.24", BaseWars.ScreenScale * 24, WEIGHT)
BaseWars:CreateFont("BaseWars.26", BaseWars.ScreenScale * 26, WEIGHT)
BaseWars:CreateFont("BaseWars.28", BaseWars.ScreenScale * 28, WEIGHT)
BaseWars:CreateFont("BaseWars.30", BaseWars.ScreenScale * 30, WEIGHT)
BaseWars:CreateFont("BaseWars.36", BaseWars.ScreenScale * 36, WEIGHT)
BaseWars:CreateFont("BaseWars.40", BaseWars.ScreenScale * 40, WEIGHT)
BaseWars:CreateFont("BaseWars.60", BaseWars.ScreenScale * 60, WEIGHT)
BaseWars:CreateFont("BaseWars.65", BaseWars.ScreenScale * 65, WEIGHT)

-- Disgusting but works for now
function BaseWars:EaseInBlurBackground(panel, blurIntensity, timeInSeconds, color, alpha)
	blurIntensity = math.max(blurIntensity, 0)
	color = color or GetBaseWarsTheme("gen_background")
	alpha = alpha or 230

	panel.blurTime = SysTime() + timeInSeconds

	local oldPaint = panel.Paint
	panel.Paint = function(s,w,h)
		local blur = s.blurTime - SysTime()
		blur = timeInSeconds >= 1 and blur / timeInSeconds or blur * timeInSeconds
		blur = math.min(1 - blur, 1)

		BaseWars:DrawRoundedBox(0, 0, 0, w, h, ColorAlpha(color, alpha * blur))

		if LocalPlayer():GetBaseWarsConfig("bluredBackground") and blurIntensity > 0 then
			BaseWars:DrawBlur(s, blurIntensity * blur)
		end

		oldPaint(s,w,h)
	end
end

-- ???
function PANEL:CalculateTall()
	local tall = (BaseWars.ScreenScale * 10) * (self:ChildCount() + 1) -- BaseWars.ScreenScale * 10 » bigMargin

	for k, v in ipairs(self:GetChildren()) do
		if not IsValid(v) then continue end

		tall = tall + v:GetTall()
	end

	self:SetTall(tall)
end