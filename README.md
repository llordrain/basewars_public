> [!IMPORTANT]
> There's a lot of stuff in the gamemode that i haven't touched in years (So they're probable shit) and i'm also not consistent at all

# Configuration of the gamemode

The basic configuration is made in game.

The MySQL config is in [config/MySQL.lua](gamemode/config/MySQL.lua)

The Shoplist (F4) config is in [config/entities.lua](gamemode/config/entities.lua)

---

# Do stuff with the shoplist

Add an entity in the shoplist you need to use the function `BaseWars:CreateEntity(String entityID)`.

Add a category in the shoplist you need to use the function `BaseWars:CreateCategory(String name, String iconPath, Number order)`

## Exemple usage:

```lua
-- Version 1
local myCategory = BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)

-- Version 2
BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)

-- Version 3 (The third argument is optional)
BaseWars:CreateCategory("My Category Name", "my_icon.png")
```

```lua
-- Version 1
local fogCube = BaseWars:CreateEntity("edit_fog")
fogCube:SetClass("edit_fog")
fogCube:SetCategory(myCategory)
fogCube:SetPrice(1e6)
fogCube:SetLevel(500)
fogCube:SetLimit(5)
fogCube:Finish()

-- Version 2
BaseWars:CreateEntity("edit_fog"):SetClass("edit_fog"):SetCategory("My Category Name"):SetPrice(1e6):SetLevel(500):SetLimit(5):Finish()

-- Version 3 (This will not work because :Finish() hasn't been called)
BaseWars:CreateEntity("edit_fog"):SetClass("edit_fog"):SetCategory("My Category Name"):SetPrice(1e6):SetLevel(500):SetLimit(5)
```

| Function       | Argument Type | Returns Value Type |
| :------------- | :-----------: | :----------------: |
| SetClass       |    String     |       _self_       |
| SetName        |    String     |       _self_       |
| SetCategory    |    String     |       _self_       |
| SetSubCategory |    String     |       _self_       |
| SetPrice       |    Number     |       _self_       |
| SetMax         |    Number     |       _self_       |
| SetPrestige    |    Number     |       _self_       |
| SetLevel       |    Number     |       _self_       |
| SetCustomSpawn |    Boolean    |       _self_       |
| SetIsDrug      |    Boolean    |       _self_       |
| SetIsWeapon    |    Boolean    |       _self_       |
| SetVehicleName |    String     |       _self_       |
| SetModel       |    String     |       _self_       |
| SetRankCheck   |   Function    |       _self_       |
| SetCooldown    |    Number     |       _self_       |
| GetID          |       -       |       String       |
| GetClass       |       -       |       String       |
| GetName        |       -       |       String       |
| GetCategory    |       -       |       String       |
| GetSubCategory |       -       |       String       |
| GetPrice       |       -       |       Number       |
| GetMax         |       -       |       Number       |
| GetPrestige    |       -       |       Number       |
| GetLevel       |       -       |       Number       |
| GetCustomSpawn |       -       |      Boolean       |
| IsDrug         |       -       |      Boolean       |
| IsWeapon       |       -       |      Boolean       |
| GetVehicleName |       -       |       String       |
| GetModel       |       -       |       String       |
| GetRankCheck   |       -       |      Function      |
| GetCooldown    |       -       |       Number       |
| Finish         |       -       |       _self_       |

---

# Create Your Own Module

# Hooks

## Server:

- `PostDatabaseInitialized`
- `BaseWars:InitializeDatabase`
- `BaseWars:PlayerUpgradeBank`
  - **_String_** » Player
  - **_String_** » Bank
  - **_Number_** » Money Taken
  - **_Number_** » XP Received
- `BaseWars:PlayerUpgradeBank`
  - **_String_** » Player
  - **_String_** » Bank
  - **_String_** » Upgrade Name
  - **_Number_** » Upgrade Cost
- `BaseWars:PlayerTakeMoneyInPrinter`
  - **_String_** » Player
  - **_String_** » Bank
  - **_Number_** » Money Taken
  - **_Number_** » XP Received
- `BaseWars:PlayerUpgradePrinter`
  - **_String_** » Player
  - **_String_** » Bank
  - **_String_** » Upgrade Name
  - **_Number_** » Upgrade Count
  - **_Number_** » Upgrade Cost
- `BaseWars:PlayerBuyPrinterPaper`
  - **_String_** » Player
  - **_String_** » Bank
  - **_Number_** » Paper Count
  - **_Number_** » Money Paid
- `BaseWars:PlayerRenameSpawnpoint`
  - **_String_** » Player
  - **_String_** » Spawnpoint
  - **_String_** » Old Name
  - **_String_** » New Name
- `BaseWars:PlayerPickWeaponBox`
  - **_String_** » Player
  - **_Table_** » Weapons Data
- `BaseWars:PlayerDestroyEntity`
  - **_String_** » Destroyed Entity
  - **_String_** » Entity Owner
  - **_String_** » Attacker
  - **_String_** | **_nil_** » Inflictor
  - **_number_** » Entity Value
- `BaseWars:ConfigurationModified`
  - **_Table_** » Old Config
  - **_Table_** » New Config
- `BaseWars:PreConfigurationModified`
  - **_Table_** » Old Config
  - **_Table_** » New Config
- `BaseWars:ConsoleCommand`
  - **_String_** » Player
  - **_String_** » Command
  - **_Table_** » Command arguments
  - **_String_** » Command arguments concatenated
- `BaseWars:SQLError`
  - **_String_** » Error
  - **_String_** » Query
- `BaseWars:ChatCommand`
  - **_String_** » Player
  - **_String_** » Command
  - **_Table_** » Command arguments
  - **_String_** » Whole message
  - **_String_** » Whole message but in all lower case
- `BaseWars:PostSetPropHealth`
  - **_String_** » Player
  - **_String_** » Prop
- `BaseWars:SendNetToClient`
  - **_String_** » Player
- `BaseWars:Pay`
  - **_String_** » Player
  - **_String_** » Target
  - **_Number_** » Money Given
- `BaseWars:PreSellEntity`
  - **_String_** » Player
  - **_String_** » Entity to sell
  - **_String_** » Entity Value
- `BaseWars:BuyWeapon`
  - **_String_** » Player
  - **_String_** » EntityID
- `BaseWars:BuyVehicle`
  - **_String_** » Player
  - **_String_** » EntityID
  - **_String_** » Vehicle Class (I think)
- `BaseWars:BuyEntity`
  - **_String_** » Player
  - **_String_** » The actual entity
  - **_String_** » EntityID
- `BaseWars:Factions:CreateFaction`
  - **_String_** » Player
  - **_Number_** » Faction ID
  - **_String_** » Faction name
  - **_String_** » Faction password
- `BaseWars:Factions:JoinFaction`
  - **_String_** » Player
  - **_String_** » Faction name
- `BaseWars:Factions:QuitFaction`
  - **_String_** » Player
  - **_String_** » Faction name
- `BaseWars:Factions:ChangePassword`
  - **_String_** » Player
  - **_String_** » Old password
  - **_String_** » New password
- `BaseWars:Factions:KickMember`
  - **_String_** » Player
  - **_String_** » Target
- `BaseWars:Factions:PromoteLeader`
  - **_String_** » Player
  - **_String_** » Target
- `BaseWars:Factions:Admin:Disband`
  - **_String_** » Admin
  - **_String_** » Faction name
- `BaseWars:Factions:Admin:ReplaceLeader`
  - **_String_** » Admin
  - **_String_** » Old leader
  - **_String_** » New leader
  - **_String_** » Faction name
- `BaseWars:Factions:Admin:ResetImmunity`
  - **_String_** » Admin
  - **_String_** » Faction name
- `BaseWars:Factions:Admin:KickMember`
  - **_String_** » Admin
  - **_String_** » Target
  - **_String_** » Faction name
- `BaseWars:Prestige:OnPlayerPrestige`
  - **_String_** » Player
  - **_Number_** » Player prestige - 1
  - **_Number_** » Player prestige
- `BaseWars:Prestige:onPlayerBuyPerk`
  - **_String_** » Player
  - **_string_** » Perk ID
  - **_Number_** » Perk price
  - **_Number_** » Perk level
- `BaseWars:Prestige:ResetPrestigePoint`
  - **_String_** » Player
  - **_Number_** » Price
- `BaseWars:ResetPrestigePerk` (Duplicate?)
  - **_String_** » Player
- `BaseWars:PostPlayerChoseProfile`
  - **_String_** » Player
  - **_Number_** » Profile ID
- `BaseWars:PostPlayerCreateProfile`
  - **_String_** » Player
  - **_Number_** » Profile ID
  - **_Table_** » Profiles Data
- `BaseWars:PlayerChoseProfile`
  - **_String_** » Player
  - **_Number_** » Profile ID
- `BaseWars:PlayerCreateProfile`
  - **_String_** » Player
  - **_Number_** » Profile ID
  - **_Table_** » Profiles Data
- `BaseWars:RaidStarted`
  - **_String_** » Player
  - **_Number_** » Raid type
  - **_Table_** » Attackers Data
  - **_Table_** » Defenders Data
- `BaseWars:RaidStopped`
  - **_String_** » Reason
  - **_String_** | **_nil_** » Player that stopped the raid

<!-- - `BaseWars:Bounty:RemoveBounty` -->
  <!-- - **_String_** » Player -->
<!-- - `BaseWars:Bounty:PostSetBounty` -->
  <!-- - **_String_** » Player -->
  <!-- - **_Number_** » Bounty -->
<!-- - `BaseWars:Bounty:SetOnPlayer` -->
  <!-- - **_String_** » Player -->
  <!-- - **_String_** » Target -->
  <!-- - **_Number_** » Total Bounty -->
  <!-- - **_Number_** » Added to target bounty -->
<!-- - `BaseWars:Bounty:ClaimBounty` -->
  <!-- - **_String_** » Player -->
  <!-- - **_String_** » Attacker -->
  <!-- - **_Number_** » The Bounty -->

## Client:

- `BaseWars:ConfigurationModified`
  - **_String_** Admin
  - **_Table_** » Old Config
  - **_Table_** » New Config
- `BaseWars:PreConfigurationModified`
  - **_String_** Admin
  - **_Table_** » Old Config
  - **_Table_** » New Config

## Shared:

- `BaseWars:Initialize`

# Function

## Server:

<!-- - `BaseWars:BaseWars:SQLLogs(...)`
  - Argument
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:BaseWars:SQLLogs("Hello, world")
  ``` -->

## Client:

## Shared:

<!-- - `BaseWars:GetModules()`
- `BaseWars:OpenAdminMenu()`
- `BaseWars:CloseAdminMenu()`
- `BaseWars:GetAdminMenuPanel()`
- `BaseWars:GetAdminMenuTabs()`
- `BaseWars:AddLanguage(languageCode, languageName)`
  - Arguments:
    - languageCode » **_String_**
    - languageName » **_String_**
  - How to use »
  ```lua
  BaseWars:AddLanguage("fr", "Français")
  ```
- `BaseWars:AddTranslation(key, languageCode, text)`
  - Arguments
    - key » **_String_**
    - languageCode » **_String_**
    - text » **_String_**
  - How to use »
  ```lua
  BaseWars:AddTranslation("bwm_warnings", "fr", "Avertissements")
  BaseWars:AddTranslation("bwm_warnings", "en", "Warnings")
  ```
- `BaseWars:LanguageExists(languageCode)`
  - Argument
    - languageCode » **_String_**
  - How to use »
  ```lua
  BaseWars:LanguageExists("fr")
  ```
- `BaseWars:GetLanguage(languageCode)`
  - Argument
    - languageCode » **_String_**
  - How to use »
  ```lua
  BaseWars:GetLanguage("fr") -- returns the French language (of the language code isn't valid, returns all languages)
  BaseWars:GetLanguage() -- returns all the lauguages
  ```
- `BaseWars:Log(...)`
  - Argument
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:Log("Hello, World")
  ```
- `BaseWars:Warning(...)`
  - Argument
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:Warning("Hello, world")
  ```
- `BaseWars:ServerLog(...)`
  - Argument
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:ServerLog("Hello, world")
  ```
- `BaseWars:AddDefaultConfig(String configKey, String configType, String config, String configTranslation)`

  - Argument
    - configKey » **_String_**
    - configType » **_Number_**
    - config » **_Table_**
    - configTranslation » **_Table_**
  - How to use »

  ```lua
  BaseWars:AddDefaultConfig("Exemple", nil, false, {
    ["fr"] = {
        name = "Exemple Nom",
        desc = "Exemple Description"
    },
    ["en"] = {
        name = "Exemple Name",
        desc = "Exemple Description"
    }
  })

  BaseWars:AddDefaultConfig("Exemple", BWCONFIGTYPE_KEYVALUE, {
    exemple1 = 69
    exemple2 = "femboy"
  }, {
    ["fr"] = {
        name = "Exemple Nom",
        desc = "Exemple Description"
        extra = {
            exemple1 = {
                name = "exemple1 nom",
                desc = "exemple1 desc"
            },
            exemple2 = {
                name = "exemple2 nom",
                desc = "exemple2 desc"
            }
        }
    },
    ["en"] = {
        name = "Exemple Name",
        desc = "Exemple Description"
        extra = {
            exemple1 = {
                name = "exemple1 name",
                desc = "exemple1 desc"
            },
            exemple2 = {
                name = "exemple2 name",
                desc = "exemple2 desc"
            }
        }
    }
  })
  ```

- `BaseWars:AddAdminMenuTab(name, iconPath, panelClass, order)`

  - Argument
    - name » **_String_**
    - iconPath » **_String_**
    - panelClass » **_String_**
    - order » **_Number_**
  - How to use »

  ```lua
  BaseWars:AddAdminMenuTab("Femboy", "basewars_materials/f3/faction.png", "DPanel", 69)

  -- Or

  BaseWars:AddTranslation("adminmenu_femboy", "fr", "Admin Menu Femboy")
  BaseWars:AddTranslation("adminmenu_femboy", "en", "Admin Menu Femboy")
  BaseWars:AddAdminMenuTab("#adminmenu_femboy", "basewars_materials/f3/faction.png", "DPanel", 69)
  ```

- `BaseWars:AddAdvert(seconds, message)`
  - Argument
    - seconds » **_Number_**
    - message » **_String_**
  - How to use »
  ```lua
  BaseWars:AddAdvert(600, "Hello every 10 mins")
  ``` -->

# PLAYER Functions

## Server:

## Client:

## Shared:

# ENTITY Functions

## Server:

## Client:

## Shared:
