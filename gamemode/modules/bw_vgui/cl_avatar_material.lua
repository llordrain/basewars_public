--[[
    MIT License

    Copyright (c) 2021 William Venner

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

local getAvatarMaterial = include("basewars/gamemode/libraries/material-avatar.lua")
local roundness = BaseWars.ScreenScale * 5

local PANEL = {}
function PANEL:Init()
	self.m_Material = Material("vgui/avatar_default")
end

function PANEL:SetPlayer(ply)
	if ply:IsBot() then return end
	self.m_SteamID64 = ply:SteamID64()
	self:Download()
end

function PANEL:SetSteamID64(steamid64)
	self.m_SteamID64 = steamid64
	if steamid64 then
		self:Download()
	end
end

function PANEL:GetPlayer()
	if self.m_SteamID64 == nil then
		return NULL
	else
		-- This is slow. Don't call it every frame.
		return player.GetBySteamID64(self.m_SteamID64)
	end
end

function PANEL:GetMaterial()
	return self.m_Material
end

function PANEL:GetSteamID64()
	return self.m_SteamID64
end

function PANEL:Download()
	assert(self.m_SteamID64 ~= nil, "Tried to download the avatar image of a nil SteamID64!")
	getAvatarMaterial(self.m_SteamID64, function(mat)
		if not IsValid(self) then return end -- The panel could've been destroyed before it could download the avatar image.
		self.m_Material = mat
	end)
end

function PANEL:Paint(w, h)
    BaseWars:DrawStencil(function()
		BaseWars:DrawRoundedBox(roundness, 0, 0, w, h, color_white)
	end, function()
		surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(self.m_Material)
        surface.DrawTexturedRect(0, 0, w, h)
	end)

	-- surface.SetDrawColor(255, 255, 255)
	-- surface.SetMaterial(self.m_Material)
	-- surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("AvatarMaterial", PANEL, "Panel")