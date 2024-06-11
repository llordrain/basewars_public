function BaseWars:RemoveSpawnMenuTabs()
	local toRemove = {
		["#spawnmenu.category.saves"] = true,
		["#spawnmenu.category.dupes"] = true,
		["#spawnmenu.category.postprocess"] = true,
		["#spawnmenu.category.your_spawnlists"] = true,
		["#spawnmenu.category.addon_spawnlists"] = true,
		["#spawnmenu.content_tab"] = true
	}

	if BaseWars:IsAdmin(LocalPlayer(), true) and BaseWars.Config.AdminsSpawnProps then
		toRemove["#spawnmenu.content_tab"] = nil
	end

	if not BaseWars:IsSuperAdmin(LocalPlayer()) then
		toRemove["#spawnmenu.category.vehicles"] = true
		toRemove["#spawnmenu.category.weapons"] = true
		toRemove["#spawnmenu.category.npcs"] = true
		toRemove["#spawnmenu.category.entities"] = true
	else
		if BaseWars.Config.SuperAdminSpawnProps then
			toRemove["#spawnmenu.content_tab"] = nil
		end
	end

	local i = 1
	for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
		if toRemove[v.Name] then
			g_SpawnMenu.CreateMenu.tabScroller.Panels[i] = nil
			g_SpawnMenu.CreateMenu.Items[k] = nil
			v.Tab:Remove()
		end

		i = i + 1
	end
end

spawnmenu.Reload = spawnmenu.Reload or concommand.GetTable()["spawnmenu_reload"]
concommand.Add("spawnmenu_reload", function(...)
	spawnmenu.Reload(...)
	BaseWars:RemoveSpawnMenuTabs()

	spawnmenu.SwitchCreationTab("Props")
	BaseWars:Notify("#spawnmenu_reloaded", NOTIFICATION_WARNING, 10)
end)

hook.Add("InitPostEntity", "BaseWars:SpawnMenu", function()
	spawnmenu.AddCreationTab("Props", function()
		local Frame = vgui.Create("DScrollPanel")
		Frame:Dock(FILL)

		local ILayout = Frame:Add("DIconLayout")
		ILayout:Dock(FILL)

		for k, v in pairs(BaseWars.Config.WhitelistProps) do
			local prop = ILayout:Add("SpawnIcon")
			prop:SetModel(v)
			prop.DoClick = function(s)
				surface.PlaySound("bw_button.wav")
				LocalPlayer():ConCommand("gm_spawn " .. s:GetModelName())
			end
		end

		return Frame
	end, "icon16/box.png", 1)

	RunConsoleCommand("spawnmenu_reload")
end)