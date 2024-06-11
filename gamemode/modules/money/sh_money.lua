local PLAYER = FindMetaTable("Player")

function PLAYER:GetMoney()
	return self:GetNWFloat("BaseWars.Money", 0)
end

function PLAYER:CanAfford(amount)
	return self:GetMoney() >= amount
end