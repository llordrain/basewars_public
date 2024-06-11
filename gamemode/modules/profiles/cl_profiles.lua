net.Receive("BaseWars:SendPlayerProfilesData", function(len)
	local json = util.Decompress(net.ReadData(len / 8))
	local data = util.JSONToTable(json)

	if IsValid(ProfileSelector) then
		ProfileSelector:Build(data)
	else
		ProfileSelector = vgui.Create("BaseWars.Profiles")
		ProfileSelector:Build(data)
	end
end)

net.Receive("BaseWars:PlayerChoseProfile", function(len, ply)
	LocalPlayer().basewarsProfileID = net.ReadUInt(31)

	if IsValid(ProfileSelector) then
		ProfileSelector:AlphaTo(0, .8, .25, function()
			ProfileSelector:Remove()
		end)
	end
end)