function BaseWars:OpenAdminMenu()
    local F3 = BaseWars:GetF3MenuPanel()
    if IsValid(F3) then
        F3:Remove()
        BaseWars:CloseF3Menu()
    end

    local F4 = BaseWars:GetF4MenuPanel()
    if IsValid(F4) then
        F4:Remove()
        BaseWars:CloseF4Menu()
    end

    if not IsValid(BaseWarsAdminMenu) then
        BaseWarsAdminMenu = vgui.Create("BaseWars.AdminMenu", nil, "BaseWars Admin Menu")
    end
end

function BaseWars:CloseAdminMenu()
    if IsValid(BaseWarsAdminMenu) then
        BaseWarsAdminMenu:Remove()
    end
end

function BaseWars:GetAdminMenuPanel()
    return BaseWarsAdminMenu
end

local adminMenuTabs = {}
function BaseWars:AddAdminMenuTab(name, icon, panel, order)
    if not name or not icon or not panel then return end

    table.insert(adminMenuTabs, {
        name = name,
        icon = Material(icon, "smooth"),
        panel = panel,
        order = order or 50
    })
end

function BaseWars:GetAdminMenuTabs()
    return adminMenuTabs
end