local shopList = {}
local categoryList = {}
local entityList = {}

local META = {}
META.__index = META

function META:__newindex(k, v)
	if self.locked then
		BaseWars:Warning("You are not allowed to add values to a locked entity (key » " .. tostring(k) .. ", value » " .. tostring(v) .. ")")
		return
	end

	rawset(self, k, v)
end

local function defaultTrueFunc() return true end
function META:__call(id)
	self.id = id
	self.data = {
		class = "prop_physics",
		name = "Default Name",
		category = "Default Category",
		subCategory = "Default Subcategory",
		price = 10000,
		max = BaseWars.Config.DefaultLimit,
		prestige = 0,
		level = 1,
		customSpawn = false,
		isDrug = false,
		vehicleName = false,
		model = "error.mdl",
		rankCheck = defaultTrueFunc,
		isWeapon = false,
		cooldown = 0
	}

	entityList[id] = true -- Placeholder until META:Finish() is called

	return self
end

function META:__tostring()
	-- return "BaseWars Entity » " .. self.id .. " [Class » " .. self.data.class .. "][Category » " .. self.data.category .. "][Sub-Category » " .. self.data.subCategory .. "]"
	return "BaseWars Entity » " .. self.id .. " [Class » " .. self.data.class .. "]"
end

function META:SetClass(class)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (class for \"" .. self.id .. "\")")
		return
	end

	class = string.Trim(class)

	if not class or class == "" then
		BaseWars:Warning("Missing class for entity \"" .. self.id .. "\"")
		return self
	end

	self.data.class = class

	return self
end

function META:SetName(name)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (name for \"" .. self.id .. "\")")
		return
	end

	name = string.Trim(name)

	if not name or name == "" then
		BaseWars:Warning("Missing name for entity \"" .. self.id .. "\"")
		return self
	end

	self.data.name = name

	return self
end

function META:SetCategory(category)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (category for \"" .. self.id .. "\")")
		return
	end

	category = string.Trim(category)

	if not category or category == "" then
		BaseWars:Warning("Missing category for entity \"" .. self.id .. "\"")
		return self
	end

	self.data.category = category

	return self
end

function META:SetSubCategory(subCategory)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (sub-category for \"" .. self.id .. "\")")
		return
	end

	subCategory = string.Trim(subCategory)

	if not subCategory or subCategory == "" then
		BaseWars:Warning("Missing sub-category for entity \"" .. self.id .. "\"")
		return self
	end

	self.data.subCategory = subCategory

	return self
end

function META:SetPrice(price)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (price for \"" .. self.id .. "\")")
		return
	end

	price = tonumber(price)

	if not price then
		BaseWars:Warning("Missing price for entity \"" .. self.id .. "\"")
		return self
	end

	if price < 0 then
		BaseWars:Warning("Price for \"" .. self.id .. "\" cannot be negative")
		return self
	end

	self.data.price = price

	return self
end

function META:SetMax(max)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (max for \"" .. self.id .. "\")")
		return
	end

	max = tonumber(max)

	if not max then
		BaseWars:Warning("Missing max for entity \"" .. self.id .. "\"")
		return self
	end

	if max < 0 then
		BaseWars:Warning("Max for \"" .. self.id .. "\" cannot be negative")
		return self
	end

	self.data.max = max

	return self
end

function META:SetPrestige(prestige)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (prestige for \"" .. self.id .. "\")")
		return
	end

	if not BaseWars.Config.Prestige.Enable then
		local infos = debug.getinfo(2)
		ErrorNoHalt("You are trying to set a prestige requirement for \"" .. self.id .. "\" but the prestige modlue is disabled » " .. infos.short_src .. " @ line #" .. infos.currentline .. "\n")
	end

	prestige = tonumber(prestige)

	if not prestige then
		BaseWars:Warning("Missing prestige for entity \"" .. self.id .. "\"")
		return self
	end

	if prestige < 0 then
		BaseWars:Warning("Prestige for \"" .. self.id .. "\" cannot be negative")
		return self
	end

	self.data.prestige = prestige

	return self
end

function META:SetLevel(level)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (level for \"" .. self.id .. "\")")
		return
	end

	level = tonumber(level)

	if not level then
		BaseWars:Warning("Missing level for entity \"" .. self.id .. "\"")
		return self
	end

	if level < 0 then
		BaseWars:Warning("Level for \"" .. self.id .. "\" cannot be negative")
		return self
	end

	self.data.level = math.Clamp(level, 1, BaseWars.Config.MaxLevel)

	return self
end

function META:SetCustomSpawn(bool)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (custom spawn func for \"" .. self.id .. "\")")
		return
	end

	bool = tobool(bool)

	self.data.customSpawn = bool

	return self
end

function META:SetIsDrug(bool)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (is drug for \"" .. self.id .. "\")")
		return
	end

	bool = tobool(bool)

	self.data.isDrug = bool

	return self
end

function META:SetIsWeapon(bool)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (is weapon for \"" .. self.id .. "\")")
		return
	end

	bool = tobool(bool)

	self.data.isWeapon = bool

	return self
end

function META:SetVehicleName(name)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (vehicle name for \"" .. self.id .. "\")")
		return
	end

	name = string.Trim(name) or false

	self.data.vehicleName = name

	return self
end

function META:SetModel(model)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (model for \"" .. self.id .. "\")")
		return
	end

	model = string.Trim(model or "")

	if not model or model == "" then
		BaseWars:Warning("Missing model for entity \"" .. self.id .. "\"")
		return self
	end

	self.data.model = model

	return self
end

function META:SetRankCheck(func)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (rank-check function for \"" .. self.id .. "\")")
		return
	end

	if not isfunction(func) then
		BaseWars:Warning("Missing rank-check function for \"" .. self.id .. "\", expected function got " .. type(func))
		return self
	end

	self.data.rankCheck = func

	return self
end

function META:SetCooldown(cooldown)
	if self.locked then
		BaseWars:Warning("You are not allowed to change values to a locked entity (cooldown for \"" .. self.id .. "\")")
		return
	end

	cooldown = tonumber(cooldown)

	if not cooldown then
		BaseWars:Warning("Missing cooldown for entity \"" .. self.id .. "\"")
		return self
	end

	if cooldown < 0 then
		BaseWars:Warning("Cooldown for \"" .. self.id .. "\" cannot be negative")
		return self
	end

	self.data.cooldown = cooldown

	return self
end

function META:GetID()
	return self.id
end

function META:GetClass()
	return self.data.class
end

function META:GetName()
	return self.data.name
end

function META:GetCategory()
	return self.data.category
end

function META:GetSubCategory()
	return self.data.subCategory
end

function META:GetPrice()
	return self.data.price
end

function META:GetMax()
	return self.data.max
end

function META:GetPrestige()
	return self.data.prestige
end

function META:GetLevel()
	return self.data.level
end

function META:GetCustomSpawn()
	return self.data.customSpawn
end

function META:IsDrug()
	return self.data.isDrug
end

function META:IsWeapon()
	return self.data.isWeapon
end

function META:GetVehicleName()
	return self.data.vehicleName
end

function META:GetModel()
	return self.data.model
end

function META:GetRankCheck(ply)
	return self.data.rankCheck
end

function META:GetCooldown()
	return self.data.cooldown
end

--[[
Could be better...
function META:Print()
	print(Format("Entity ID » %s:\n\tclass » %s\n\tname » %s\n\tcategory » %s\n\tsubCategory » %s\n\tprice » %s\n\tmax » %s\n\tprestige » %s\n\tlevel » %s\n\tcustomSpawn » %s\n\tisDrug » %s\n\tvehicleName » %s\n\tmodel » %s\n\trankCheck » %s\n\tisWeapon » %s\n\tcooldown » %s", self.id, self.data.class, self.data.name, self.data.category, self.data.subCategory, self.data.price, self.data.max, self.data.prestige, self.data.level, self.data.customSpawn, self.data.isDrug, self.data.vehicleName, self.data.model, self.data.rankCheck != defaultTrueFunc, self.data.isWeapon, self.data.cooldown))
end
]]

function META:Finish()
	entityList[self.id] = self
	self.locked = true

	return self
end

local iLoveCocks, analIsFun = "Default, Not For Use", function() return false end
local invalid_id = setmetatable({}, META)("invalid_id"):SetName(iLoveCocks):SetCategory(iLoveCocks):SetSubCategory(iLoveCocks):SetRankCheck(analIsFun):Finish()
local duplicate_id = setmetatable({}, META)("duplicate_id"):SetName(iLoveCocks):SetCategory(iLoveCocks):SetSubCategory(iLoveCocks):SetRankCheck(analIsFun):Finish()

function BaseWars:CreateEntity(id)
	id = string.Trim(id or "")

	if id == "" then
		local infos = debug.getinfo(2)
		ErrorNoHalt("Invalid Entity ID » " .. infos.short_src .. " @ line #" .. infos.currentline .. "\n")

		return invalid_id
	end

	if entityList[id] then
		local infos = debug.getinfo(2)
		ErrorNoHalt("Duplicate Entity ID \"" .. id .. "\" » " .. infos.short_src .. " @ line #" .. infos.currentline .. "\n")

		return duplicate_id
	end

	return setmetatable({}, META)(id)
end

function BaseWars:CreateCategory(name, icon, order)
	name = string.Trim(name or "")
	icon = string.Trim(icon or "")
	order = tonumber(order) or 50

	local debugInfos = debug.getinfo(2)
	local d_source, d_line = debugInfos.short_src, debugInfos.currentline

	if name == "" then
		ErrorNoHalt("Invalid Category Name » " .. d_source .. " @ line #" .. d_line .. "\n")

		return "Invalid Category Name"
	end

	if icon == "" then
		ErrorNoHalt("Invalid Category Icon » " .. d_source .. " @ line #" .. d_line .. "\n")

		return "Invalid Category Icon"
	end

	categoryList[name] = {
		icon = Material(icon, "smooth"),
		order = order,
	}

	return name
end

function BaseWars:CreateShopList()
	shopList = {}

	local categoryID = {}
	for k, v in SortedPairsByMemberValue(categoryList, "order") do
		table.insert(shopList, {
			name = k,
			icon = v.icon,
			subCategories = {}
		})

		categoryID[k] = table.Count(categoryID) + 1
	end

	local unsorted = {}
	for entity_id, entity in pairs(entityList) do
		if entity_id == "invalid_id" or entity_id == "duplicate_id" then continue end

		if entity == true then
			BaseWars:Warning("Please, call :Finish() on entity \"" .. entity_id .. "\"")

			continue
		end

		local category = entity:GetCategory()
		if not categoryList[category] then
			BaseWars:Warning("Category \"" .. category .. "\" is invalid for entity \"" .. entity_id .. "\"")

			continue
		end

		local subCategory = entity:GetSubCategory()
		if not shopList[categoryID[category]]["subCategories"][subCategory] then
			shopList[categoryID[category]]["subCategories"][subCategory] = {}
		end

		if not unsorted[category] then
			unsorted[category] = {}
		end

		if not unsorted[category][subCategory] then
			unsorted[category][subCategory] = {}
		end

		table.insert(unsorted[category][subCategory], {
			price = entity:GetPrice(),
			entity_id = entity_id
		})
	end

	for category, subCategories in pairs(unsorted) do
		for subCategory, entitiesData in pairs(subCategories) do
			for _, entityData in SortedPairsByMemberValue(entitiesData, "price") do
				table.insert(shopList[categoryID[category]]["subCategories"][subCategory], entityData.entity_id)
			end
		end
	end
end

function BaseWars:GetBaseWarsEntity(id)
	if id then
		return entityList[id]
	end

	return entityList
end

function BaseWars:GetBaseWarsCategory(name)
	if name then
		return categoryList[name]
	end

	return categoryList
end

function BaseWars:GetShopList()
	return shopList
end

hook.Add("BaseWars:Initialize", "BaseWars:CreateShopList", function()
	BaseWars:CreateShopList()

	local choices = {
		[-1] = "#last"
	}

	for k, v in ipairs(BaseWars:GetShopList()) do
		choices[k] = v.name
	end

	BaseWars.DefaultPlayerConfig["F4Tab"].choices = choices
end)