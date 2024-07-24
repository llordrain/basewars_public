function BaseWars:OpenF4Menu()
	local F3 = BaseWars:GetF3MenuPanel()
	if IsValid(F3) then
		F3:Remove()
		BaseWars:CloseF3Menu()
	end

	local AM = BaseWars:GetAdminMenuPanel()
	if IsValid(AM) then
		AM:CloseAdminMenu()
	end

	if not IsValid(F4Menu) then
		F4Menu = vgui.Create("BaseWars.F4Menu", nil, "BaseWars Shop")
	end
end

function BaseWars:CloseF4Menu()
	if IsValid(F4Menu) then
		F4Menu:Remove()
	end
end

function BaseWars:GetF4MenuPanel()
	return F4Menu
end

function BaseWars:GetFavorites()
	return LocalPlayer().basewarsFavorites or {}
end

function BaseWars:AddFavorite(entityID)
	table.insert(LocalPlayer().basewarsFavorites, entityID)

	file.Write("basewars/" .. self.serverAddress .. "/favorites.json", util.TableToJSON(LocalPlayer().basewarsFavorites))

	BaseWars:Notify("#bws_addFavorite", NOTIFICATION_GENERIC, 5, BaseWars:GetBaseWarsEntity(entityID):GetName())
end

function BaseWars:RemoveFavorite(entityID)
	table.RemoveByValue(LocalPlayer().basewarsFavorites, entityID)

	file.Write("basewars/" .. self.serverAddress .. "/favorites.json", util.TableToJSON(LocalPlayer().basewarsFavorites))

	BaseWars:Notify("#bws_removeFavorite", NOTIFICATION_GENERIC, 5, BaseWars:GetBaseWarsEntity(entityID):GetName())
end

function BaseWars:IsFavorite(entityID)
	for k, v in ipairs(self:GetFavorites()) do
		if v == entityID then
			return true
		end
	end

	return false
end