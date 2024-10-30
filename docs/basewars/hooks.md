# Help

### The layout for hooks is the following:

- `HOOK_NAME` -> RETURN_VALUE : RETURN_TYPE

  - ARG : TYPE
  - ...

<!-- - `HUDShouldDraw` » Hide the default gamemode HUDs
  - BaseWarsBaseWarsHUD
  - BaseWarsBaseWarsHUD
  - BaseWarsRaidHUD
  - BaseWarsExplosiveHUD
  - BaseWarsNotifications -->

# Server:

- `PostDatabaseInitialized`

- `BaseWars:InitializeDatabase`

- `BaseWars:PlayerTakeMoneyInBank`

  - Player : Entity
  - Printer : Entity
  - Money : Number
  - XP : Number

- `BaseWars:PlayerUpgradeBank`

  - Player : Entity
  - Printer : Entity
  - Upgrade : String
  - UpgradePrice : Number

- `BaseWars:PlayerUpgradePrinter`

  - Player : Entity
  - Printer : Entity
  - Upgrade : String
  - UpgradeCount : Number
  - UpgradePrice : Number

- `BaseWars:PlayerTakeMoneyInPrinter`

  - Player : Entity
  - Printer : Entity
  - Money : Number
  - XP : Number

- `BaseWars:PlayerBuyPrinterPaper`

  - Player : Entity
  - Printer : Entity
  - PaperBought : Number
  - Price : Number

- `BaseWars:PlayerRenameSpawnpoint`

  - Player : Entity
  - Spawnpoint : Entity
  - OldName : String
  - NewName : String

- `BaseWars:PlayerPickWeaponBox`

  - Player : Entity
  - WeaponList : Table

- `BaseWars:PlayerDestroyEntity`

  - DamagedEntity : Entity
  - EntityOwner : Entity
  - Attacker : Entity
  - Inflicter : Entity
  - EntityValue : Number

- `BaseWars:PreConfigurationModified`

  - Admin : Entity
  - OldConfig : Table
  - NewConfig : Table

- `BaseWars:PreConfigurationModified`

  - Admin : Entity
  - OldConfig : Table
  - NewConfig : Table

- `BaseWars:ConsoleCommand`

  - Player : Entity
  - Command : String
  - Args : Table
  - ArgString : String

- `BaseWars:SQLError`

  - Error : String
  - Query : String
  - Where : Table -> { Source, Line }

- `BaseWars:ChatCommand`

  - Player : Entity
  - Command : String
  - Args : Table
  - Text : String
  - TextLowered : String

- `BaseWars:PostSetPropHealth`

  - Player : Entity
  - Prop : Entity

- `BaseWars:SendNetToClient`

  - Player : Ply | nil

- `BaseWars:Pay`

  - Player : Entity
  - Target : Entity
  - Money : Number

- `BaseWars:PreSellEntity`

  - Player : Entity
  - Entity : Entity
  - Value : Number

- `BaseWars:Prestige:PrinterCap` -> ExtraPrinterCap : Number

  - Player : Entity

- `BaseWars:BuyWeapon`

  - Player : Entity
  - BaseWarsEntityID : String

- `BaseWars:BuyVehicle`

  - Player : Entity
  - BaseWarsEntityID : String
  - Vehicle : Entity

- `BaseWars:BuyEntity`

  - Player : Entity
  - SpawnedEntity : Entity
  - BaseWarsEntityID : String

- `BaseWars:Factions:CreateFaction`

  - Leader : Entity
  - FactionID : Number
  - FactionName : String
  - Password : String

- `BaseWars:Factions:JoinFaction`

  - Player : Entity
  - FactionName : String

- `BaseWars:Factions:QuitFaction`

  - Player : Entity
  - FactionName : String

- `BaseWars:Factions:ChangePassword`

  - Player : Entity
  - OldPassword : String
  - NewPassword : String

- `BaseWars:Factions:KickMember`

  - Leader : Entity
  - KickedPlayer : Entity

- `BaseWars:Factions:PromoteLeader`

  - OldLeader : Player
  - NewLeader : Player

- `BaseWars:Factions:Admin:Disband`

  - Admin : Player
  - FactionName : String

- `BaseWars:Factions:Admin:ReplaceLeader`

  - Admin : Entity
  - OldLeader : Entity
  - NewLeader : Entity
  - FactionName : String

- `BaseWars:Factions:Admin:ResetImmunity`

  - Admin : Player
  - FactionName : String

- `BaseWars:Factions:Admin:KickMember`

  - Admin : Entity
  - KickedPlayer : Entity
    - FactionName : String

- `BaseWars:Prestige:OnPlayerPrestige`

  - Player : Entity
  - OldPrestige : Number
  - NewPrestige : Number

- `BaseWars:Prestige:onPlayerBuyPerk`

  - Player : Entity
  - PerkID : String
  - PerkPrice : Number
  - PerkLevel : Number

- `BaseWars:Prestige:ResetPrestigePoint`

  - Player : Entity
  - Price : Number

- `BaseWars:ResetPrestigePerk`

  - Player : Entity

- `BaseWars:PostPlayerChoseProfile`

  - Player : Entity
  - ProfileID : Number
  - ProfileData : Table

- `BaseWars:PostPlayerCreateProfile`

  - Player : Entity
  - ProfileID : Number

- `BaseWars:PlayerChoseProfile`

  - Player : Entity
  - ProfileID : Number
  - ProfileData : Table

- `BaseWars:PlayerCreateProfile`

  - Player : Entity
  - ProfileID : Number

- `BaseWars:PlayerChoseProfile`

  - Player : Entity
  - ProfileID : Number

- `BaseWars:RaidStarted`

  - Player : Entity
  - RaidType : Number
  - AttackersData : Table
  - DefendersData : Table

- `BaseWars:RaidStopped`
  - Reason : String
  - Player : Entity | nil

<!--
idk if they actually work??
BaseWars:PlayerSpawn:Health
BaseWars:PlayerSpawn:Armor
BaseWars:PlayerSpawn:WalkSpeed
BaseWars:PlayerSpawn:WalkSpeed

I'll update this shitty module one day

BaseWars:Bounty:RemoveBounty
BaseWars:Bounty:PostSetBounty
BaseWars:Bounty:PostSetBounty
BaseWars:Bounty:SetOnPlayer
BaseWars:Bounty:ClaimBounty

BaseWars:Bounty:SetOnPlayer
-->

# Client:

- `BaseWars:PreConfigurationModified`

  - OldConfig : Table
  - NewConfig : Table

- `BaseWars:PreConfigurationModified`

  - OldConfig : Table
  - NewConfig : Table

# Shared:

- `BaseWars:Initialize`
