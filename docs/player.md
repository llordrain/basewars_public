# SHARED:

- `PLAYER:InSafeZone() -> Boolean`

- `PLAYER:GetAFKTime() -> Float`

- `PLAYER:IsAFK() -> Boolean`

- `PLAYER:HasRadar() -> Boolean`

- `PLAYER:GetSpawnProtectionTime() -> Float`

- `PLAYER:HasSpawnProtection() -> Boolean`

- `PLAYER:GetBounty() -> Float`

- `PLAYER:HasBounty() -> Boolean`

- `PLAYER:GetPrinterCap() -> Number`

- `PLAYER:CanBuy(BaseWarsEntityID : String) -> CanBuy : Boolean, Why : String`

- `PLAYER:GetFactionColor() -> Color`

- `PLAYER:HasSameFaction(TargetPlayer : Entity) -> Boolean`

- `PLAYER:InFaction() -> Boolean`

- `PLAYER:IsFactionLeader() -> Boolean`

- `PLAYER:GetLevel() -> Number`

- `PLAYER:GetXP() -> Number`

- `PLAYER:GetXPNextLevel() -> Number`

- `PLAYER:HasLevel(TargetLevel : Number) -> Boolean`

- `PLAYER:GetMoney() -> Boolean`

- `PLAYER:CanAfford(Amount : Number) -> Number`

- `PLAYER:GetPrestige() -> Number`

- `PLAYER:GetPrestigePoint() -> Number`

- `PLAYER:GetPrestigePerk(PerkID : String) -> Number`

- `PLAYER:CanPrestige(NoNotification : Boolean)`

- `PLAYER:HasPrestige(Prestige : Number) -> Number`

- `PLAYER:GetPrestigePointSpent() -> Number`

- `PLAYER:GetTimePlayed() -> Number`
<!--
- `PLAYER:IsGodmode() -> Boolean`

- `PLAYER:IsCloak() -> Boolean`

- `PLAYER:IsNocliping() -> Boolean` -->

- `PLAYER:GetBaseWarsConfig(Config : String) -> Any`

  - If **_Config_** is not a valid config, returns false.
  - If the player's config can't be found returns default value. (BaseWars.DefaultPlayerConfig[**_Config_**].value)

- `PLAYER:GetLang(Localization : String, SubLocalization : String | nil) -> String`

  - If a translation is not found, returns as plain text `"Localization"` or `"Localization.SubLocalization"` if **_SubLocalization_** is not nil

- `PLAYER:GetFaction(TargetPlayer : Entity | nil) -> String`
  - **_TargetPlayer_** is used for localization stuff, dont worry about that 🤫

# SERVER:

- `PLAYER:SetAFKTime(Time : Float)`

- `PLAYER:SetSafeZone(InSafeZone : Boolean)`

- `PLAYER:SetBounty(Bounty : Number, Cummulate : Boolean | nil)`

- `PLAYER:CreateFaction(Name : String, Password : String, Color : Color)`

- `PLAYER:JoinFaction(Name : String, Password : String)`

- `PLAYER:QuitFaction()`

- `PLAYER:ChangeFactionPassword(Password : String)`

- `PLAYER:KickPlayerFromFaction(TargetPlayer : Entity)`

- `PLAYER:TransferFactionLeadership(TargetPlayer : Entity)`

- `PLAYER:ChangeFactionFriendlyFire(Enable : Boolean)`

- `PLAYER:SetHasRadar(HasRadar : Boolean)`

- `PLAYER:SetSpawnProtection(Time : Float)`

- `PLAYER:AddLevel(Level : Number)`

- `PLAYER:AddXP(XP : Number, DontCountInStats : Boolean)`

- `PLAYER:AddMoney(Money : Number, DontCountInStats : Boolean)`

- `PLAYER:TakeMoney(Money : Number)`

- `PLAYER:AddPrestige(Prestige : Number)`

- `PLAYER:AddPrestigePoint(PrestigePoints : Number)`

- `PLAYER:SetPrestigePerk(PerkID : String, Level : Number)`

- `PLAYER:Prestige()`

- `PLAYER:SetRaidImmunity(Time : FLoat)`

- `PLAYER:GetRaidImmunity() -> Time : Float, InFaction : Boolean`

- `PLAYER:HasRaidImmunity() -> HasImmunity : Boolean, InFaction : Boolean`

- `PLAYER:InRaid() -> Boolean`

- `PLAYER:Ally(TargetPlayer : Entity) -> Boolean`

- `PLAYER:Enemy(TargetPlayer : Entity) -> Boolean`

- `PLAYER:SetTimePlayed(Time : Number)`

<!-- - `PLAYER:SetGodmode(Godmode : Boolean)`

- `PLAYER:SetCloak(Cloak : Boolean)` -->

- `PLAYER:SetBountySpawn(Bounty : Number)`

  - Set a bounty on a player without touching the database (The bounty isn't gonna be saved)

- `PLAYER:SetLevel(Level : Number, DontSave : Boolean | nil)`

  - **_DontSave_** should always be false or nil because unless you don't want your players data to be saved its useless to you

- `PLAYER:SetXP(XP : Number, DontSave : Boolean | nil)`

  - **_DontSave_** should always be false or nil because unless you don't want your players data to be saved its useless to you

- `PLAYER:SetMoney(Money : Number, DontSave : Boolean | nil)`

  - **_DontSave_** should always be false or nil because unless you don't want your players data to be saved its useless to you

- `PLAYER:SetPrestige(Prestige : Number, DontSave : Boolean | nil)`

  - **_DontSave_** should always be false or nil because unless you don't want your players data to be saved its useless to you

- `PLAYER:SetPrestigePoint(PrestigePoints : Number, DontSave : Boolean | nil)`

  - **_DontSave_** should always be false or nil because unless you don't want your players data to be saved its useless to you

- `PLAYER:PayDay()`

  - Calculates the money based on the config and gives it to the player

# CLIENT:

- `PLAYER:CreateFaction(Name : String, Password : String | nil, Color : Color | nil)`

- `PLAYER:JoinFaction(Name : String, Password : String)`

- `PLAYER:QuitFaction()`

- `PLAYER:ChangeFactionPassword(Password : String)`

- `PLAYER:KickPlayerFromFaction(TargetPlayer : Entity)`

- `PLAYER:TransferFactionLeadership(TargetPlayer : Entity)`

- `PLAYER:ChangeFactionFriendlyFire(Enable : Boolean)`
