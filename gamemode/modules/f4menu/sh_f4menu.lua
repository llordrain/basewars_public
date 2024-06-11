local PLAYER = FindMetaTable("Player")

function PLAYER:GetPrinterCap()
    local limit = BaseWars.Config.PrinterCap[self:GetUserGroup()] or BaseWars.Config.PrinterCap["default"]
    limit = limit + hook.Run("BaseWars:PrinterCap", self) or 0

    return limit
end

local function hasPrinterCap(ply)
    local allPrinters = ents.FindByClass("bw_printer_*")
    table.Merge(allPrinters, ents.FindByClass("bw_base_printer"))

    local count = 0
    for k, v in pairs(allPrinters) do
        if v:CPPIGetOwner() == ply then
            count = count + 1
        end
    end

    return count >= ply:GetPrinterCap()
end

function PLAYER:CanBuy(entityID)
    if not entityID or type(entityID) != "string" then return false, "no id" end

    local itemObject = BaseWars:GetBaseWarsEntity(entityID)
    if not itemObject then
        return false, "no data"
    end

    local entityClass = itemObject:GetClass()
    local isBomb = string.find(entityClass, "bw_explosive") or string.find(entityClass, "bw_weapon_c4")

    if not self:InRaid() and isBomb then
        return false, self:GetLang("bws_cantBuyBomb")
    end

    if self:InRaid() and not (isBomb or itemObject:IsWeapon()) then
        return false, self:GetLang("bws_cantBuyDuringRaid")
    end

    local isPrinter = string.find(entityClass, "bw_printer") or string.find(entityClass, "bw_base_printer")
    if isPrinter and hasPrinterCap(self) then
        return false, self:GetLang("bws_printerCap")
    end

    local rankCheck, forWho = itemObject:GetRankCheck()(self)
    if not rankCheck then
        return false, Format(self:GetLang("bws_forWho"), forWho)
    end

    if BaseWars.Config.Prestige.Enable and not self:HasPrestige(itemObject:GetPrestige()) then
        return false, self:GetLang("bws_lowPrestige")
    end

    if not self:CanAfford(itemObject:GetPrice()) then
        return false, self:GetLang("bws_tooExpensive")
    end

    if not self:HasLevel(itemObject:GetLevel()) then
        return false, self:GetLang("bws_lowLevel")
    end

    local class, count = itemObject:IsWeapon() and "bw_weapon" or itemObject:GetClass(), 0
    for k, v in ents.Iterator() do
        if not IsValid(v) then continue end
        if not v:IsClass(class) then continue end
        if v:CPPIGetOwner() != self then continue end

        count = count + 1
    end

    if count >= itemObject:GetMax() then
        return false, self:GetLang("bws_reachLimit")
    end

    if SERVER then
        local cooldown = self.basewarsShopCooldowns[entityClass]
        if itemObject:GetCooldown() > 0 and CurTime() < cooldown then
            return false, Format(self:GetLang("#bws_slowDown"), CurTime() - cooldown)
        end
    end

    return true, Format(self:GetLang("bws_buyConfirm"), itemObject:GetName(), BaseWars:FormatMoney(itemObject:GetPrice()))
end