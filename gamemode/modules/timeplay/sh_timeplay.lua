local PLAYER = FindMetaTable("Player")

function PLAYER:GetTimePlayed()
	return tonumber(self:GetNWFloat("BaseWars.TimePlayed"))
end