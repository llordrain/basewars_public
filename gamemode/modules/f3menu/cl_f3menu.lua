function BaseWars:OpenF3Menu()
	if IsValid(BaseWars:GetF3MenuPanel()) then
		return
	end

	local F4 = BaseWars:GetF4MenuPanel()
	if IsValid(F4) then
		F4:Remove()
		BaseWars:CloseF4Menu()
	end

	local AM = BaseWars:GetAdminMenuPanel()
	if IsValid(AM) then
		AM:CloseAdminMenu()
	end

	F3Menu = vgui.Create("BaseWars.F3Menu", nil, "BaseWars Menu")
end

function BaseWars:CloseF3Menu()
	if IsValid(F3Menu) then
		F3Menu:Remove()
	end
end

function BaseWars:GetF3MenuPanel()
	return F3Menu
end

local NavigationButtons = {}
function BaseWars:AddBaseWarsMenuTab(name, icon, panel, order)
	if not name or not icon or not panel then return end

	table.insert(NavigationButtons, {
		name = name,
		translate = translate,
		icon = Material(icon, "smooth"),
		panel = panel,
		order = order or 50
	})

	table.SortByMember(NavigationButtons, "order", true)
end

function BaseWars:GetBaseWarsMenuTabs()
	return table.Copy(NavigationButtons)
end
