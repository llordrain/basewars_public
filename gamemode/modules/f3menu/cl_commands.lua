net.Receive("BaseWars:OpenBaseWarsMenuOn", function()
    local tab = net.ReadString()

    local num = 1
    for k, v in ipairs(BaseWars:GetBaseWarsMenuTabs()) do
        if v.name == tab or v.name == "#" .. tab then
            num = k
            break
        end
    end

    LocalPlayer().F3SavedPanel = num

    local F3 = BaseWars:GetF3MenuPanel()
    if IsValid(F3) then
        BaseWars:CloseF3Menu()
    end

    BaseWars:OpenF3Menu()
end)