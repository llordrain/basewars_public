> [!IMPORTANT]
> There's a lot of stuff in the gamemode that i haven't touched in years (So they're probable shit) and i'm also not consistent at all. Everything works with **UserGroups** for now

## [Workshop Addon Here](https://steamcommunity.com/sharedfiles/filedetails/?id=3265905462)

# Credits

Icons » [flaticon.com](https://www.flaticon.com/)

MySQLite » [By Falco Peijnenburg](https://github.com/FPtje/MySQLite)

Material Avatar » [By WilliamVenner](https://github.com/WilliamVenner/glua-material-avatar)

BaseWars:DrawArc() » [By Threebow](https://github.com/Threebow/tdlib)

# Configuration of the gamemode

The basic configuration is made in game.

The MySQL config is in [config/MySQL.lua](gamemode/config/MySQL.lua)

The Shoplist (F4) config is in [config/entities.lua](gamemode/config/entities.lua)

---

# Do stuff with the shoplist

To add an entity in the shoplist you need to use the function `BaseWars:CreateEntity(String entityID)`.

To add a category in the shoplist you need to use the function `BaseWars:CreateCategory(String name, String iconPath, Number order)`

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

- `BaseWars:BaseWars:SQLLogs(...)`
  - Argument Type
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:BaseWars:SQLLogs("Hello, world")
  ```

## Client:

- `BaseWars:CreateDefaultTheme()`
- `BaseWars:ReloadCustomTheme()`
- `BaseWars:OpenAdminMenu()`
- `BaseWars:CloseAdminMenu()`
- `BaseWars:GetAdminMenuPanel()`
  - Return value » **_Panel_** | **_nil_**
- `BaseWars:GetAdminMenuTabs()`
- Return value » **_Table_**

- `BaseWars:AddAdminMenuTab(name, iconPath, panelClass, order)`

  - Argument Type
    - name » **_String_**
    - iconPath » **_String_**
    - panelClass » **_String_**
    - order » **_Number_** | **_nil_**
  - How to use »

  ```lua
  BaseWars:AddAdminMenuTab("Femboy", "basewars_materials/f3/faction.png", "DPanel", 69)

  -- Or

  BaseWars:AddTranslation("adminmenu_femboy", "fr", "Admin Menu Femboy")
  BaseWars:AddTranslation("adminmenu_femboy", "en", "Admin Menu Femboy")
  BaseWars:AddAdminMenuTab("#adminmenu_femboy", "basewars_materials/f3/faction.png", "DPanel", 69)
  ```

- `BaseWars:AddChatCommand(command, rank, desc, args)`

  - Argument Type
    - command » **_String_**
    - rank » **_Table_** | **_nil_**
    - desc » **_String_** | **_nil_**
    - args » **_Table_** | **_nil_**
  - How to use »

  ```lua
  -- rank is optional, leave empty (nil) if everyone has access to this command
  -- desc is optional, will default to "#commands_NoDesc"
  -- args is optional, don't touch if your command has no arguments :]

  BaseWars:AddChatCommand("setcredit")

  -- Ranks
  BaseWars:AddChatCommand("setcredit", BaseWars:GetSuperAdminGroups())
  BaseWars:AddChatCommand("setcredit", {
    ["owner"] = true,
    ["superadmin"] = true,
  })

  -- Description
  BaseWars:AddChatCommand(command, nil, "Hello, this is a command description")
  BaseWars:AddChatCommand(command, nil, "Hello, this is a command description")

  -- Args
  BaseWars:AddChatCommand("setcredit", nil, nil, {
    "<player>",
    "amount",
  })
  ```

- `BaseWars:GetChatCommands(command)`

  - Argument Type
    - command » **_String_** | **_nil_**
  - How to use »

  ```lua
  BaseWars:GetChatCommands("setcredit") -- returns "setcredit" command
  BaseWars:GetChatCommands() -- returns all commands
  ```

- `BaseWars:DrawMaterial(mat, x, y, w, h, color, ang)`

  - Argument Type
    - mat » **_Material_**
    - x » **_Number_**
    - y » **_Number_**
    - w » **_Number_**
    - h » **_Number_**
    - color » **_Color_**
    - ang » **_Number_**
  - How to use »

  ```lua
  local mat = Material("basewars_materials/notification/purchase.png", "smooth")
  local color = Color(175, 50, 50)

  BaseWars:DrawMaterial(mat, 10, 10, 200, 200, color, -CurTime() * 540 % 360)
  ```

- `BaseWars:DrawStencil(shape, paint)`

  - Argument Type
    - shape » **_Function_**
    - paint » **_Function_**
  - How to use »

  ```lua
  -- If you don't know what is does you probably shoudn't use it anyway
  -- https://wiki.facepunch.com/gmod/render
  ```

- `BaseWars:DrawArc(x, y, ang, p, rad, color, seg)`
  - Argument Type
    - x » **_Number_**
    - y » **_Number_**
    - ang » **_Number_**
    - p » **_Number_**
    - rad » **_Number_**
    - color » **_Color_**
    - seg » **_Number_** | **_nil_**
  - How to use »
  ```lua
  -- No idea, its used in BaseWars:DrawRoundedBox() and BaseWars:DrawRoundedBoxEx()
  ```
- `BaseWars:DrawRoundedBoxEx(radius, x, y, w, h, col, tl, tr, bl, br)`

  - Argument Type
    - radius » **_Number_**
    - x » **_Number_**
    - y » **_Number_**
    - w » **_Number_**
    - h » **_Number_**
    - col » **_Color_**
    - tl » **_Boolean_**
    - tr » **_Boolean_**
    - bl » **_Boolean_**
    - br » **_Boolean_**
  - How to use »

  ```lua
  local color = Color(50, 175, 50)

  -- If radius is 0 tl, tr, bl and br is useless
  BaseWars:DrawRoundedBoxEx(5, 20, 20, 200, 80, color)

  -- If radius is greater than 0 tl, tr, bl, br define if a corner should be rounded
  -- tl » Top Left
  -- tr » Top Right
  -- bl » Bottom Left
  -- br » Bottom Right
  BaseWars:DrawRoundedBoxEx(5, 20, 20, 200, 80, color, true, true) -- Top left and right will be rounded by 5px, Bottom left and right won't be rounded
  ```

- `BaseWars:DrawRoundedBox(radius, x, y, w, h, col)`

  - Argument Type
    - radius » **_Number_**
    - x » **_Number_**
    - y » **_Number_**
    - w » **_Number_**
    - h » **_Number_**
    - col » **_Color_**
  - How to use »

  ```lua
  local color = Color(50, 175, 50)

  -- Same as BaseWars:DrawRoundedBoxEx() but tl, tr, bl, br is always "true"
  BaseWars:DrawRoundedBox(5, 20, 20, 200, 80, color)
  ```

- `BaseWars:DrawBlur(panel, amount)`

  - Argument Type
    - panel » **_Panel_**
    - amount » **_Number_**
  - How to use »

  ```lua
  BaseWars:DrawBlur(panel*, 3)
  ```

- `BaseWars:DrawCircle(x, y, radius, vertices, angle, v, color)`

  - Argument Type
    - a » **_a_**
  - How to use »

  ```lua
  local color = Color(50, 175, 50)

  BaseWars:DrawCircle(500, 500, 360, 360, 0, 360, color)
  ```

- `BaseWars:GetTextSize(text, font)`

  - Argument Type
    - text » **_String_**
    - font » **_String_**
  - How to use »

  ```lua
  local w, h = BaseWars:GetTextSize("Hello, World", "Basewars.18")
  ```

- `BaseWars:SimpleLinearGradient(x, y, w, h, startColor, endColor, horizontal)`

  - Argument Type
    - x » **_Number_**
    - y » **_Number_**
    - w » **_Number_**
    - h » **_Number_**
    - startColor » **_Color_**
    - endColor » **_Color_**
    - horizontal » **_Boolean_**
  - How to use »

  ```lua
  -- Sorry but for this one you'll have to figure it out bu yourself
  ```

- `BaseWars:LinearGradient(x, y, w, h, stops, horizontal)`

  - Argument Type
    - x » **_Number_**
    - y » **_Number_**
    - w » **_Number_**
    - h » **_Number_**
    - stops » **_Table_**
    - horizontal » **_Boolean_**
  - How to use »

  ```lua
  -- Sorry but for this one you'll have to figure it out bu yourself
  ```

- `BaseWars:LerpColor(frac, from, to)`

  - Argument Type
    - frac » **_Number_**
    - from » **_Color_**
    - to » **_Color_**
  - How to use »

  ```lua
  local from = Color(255, 0, 0)
  local to = Color(0, 255, 0)

  local color = BaseWars:LerpColor(FrameTime() * 16, from, to)
  ```

- `BaseWars:CreateFont(name, size, weight, extra)`

  - Argument Type
    - name » **_String_**
    - size » **_Number_**
    - weight » **_Number_**
    - extra » **_Table_** | **_nil_**
  - How to use »

  ```lua
  BaseWars:CreateFont("MyFont", 50, 500)

  BaseWars:CreateFont("MyFont:Outline", 50, 500, {
    outline = true,
  })
  ```

- `BaseWars:EaseInBlurBackground(panel, blurIntensity, timeInSeconds, color, alpha)`

  - Argument Type
    - panel » **_Panel_**
    - blurIntensity » **_Number_**
    - timeInSeconds » **_Number_**
    - color » **_Color_** | **_nil_**
    - alpha » **_Number_** | **_nil_**
  - How to use »

  ```lua
  -- Please dont use this, i made this in 10 mins and its dogshit
  ```

## Shared:

- `BaseWars:GetModules()`
- `BaseWars:AddLanguage(languageCode, languageName)`
  - Argument Types:
    - languageCode » **_String_**
    - languageName » **_String_**
  - How to use »
  ```lua
  BaseWars:AddLanguage("fr", "Français")
  ```
- `BaseWars:AddTranslation(key, languageCode, text)`
  - Argument Types
    - key » **_String_**
    - languageCode » **_String_**
    - text » **_String_**
  - How to use »
  ```lua
  BaseWars:AddTranslation("bwm_warnings", "fr", "Avertissements")
  BaseWars:AddTranslation("bwm_warnings", "en", "Warnings")
  ```
- `BaseWars:LanguageExists(languageCode)`
  - Argument Type
    - languageCode » **_String_**
  - How to use »
  ```lua
  BaseWars:LanguageExists("fr")
  ```
- `BaseWars:GetLanguage(languageCode)`
  - Argument Type
    - languageCode » **_String_** | **_nil_**
  - How to use »
  ```lua
  BaseWars:GetLanguage("fr") -- returns the French language
  BaseWars:GetLanguage() -- returns all the lauguages
  ```
- `BaseWars:Log(...)`
  - Argument Type
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:Log("Hello, World")
  ```
- `BaseWars:Warning(...)`
  - Argument Type
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:Warning("Hello, world")
  ```
- `BaseWars:ServerLog(...)`
  - Argument Type
    - ... » **_Any_**
  - How to use »
  ```lua
  BaseWars:ServerLog("Hello, world")
  ```
- `BaseWars:AddDefaultConfig(configKey, configType, config, configTranslation)`

  - Argument Type
    - configKey » **_String_**
    - configType » **_Number_** | **_nil_**
    - config » **_Table_**
    - configTranslation » **_Table_** | **_nil_**
  - How to use »

  ### [**Better exemple here**](gamemode/modules/prestige/init_prestige.lua)

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

- `BaseWars:AddAdvert(seconds, message)`
  - Argument Type
    - seconds » **_Number_**
    - message » **_String_**
  - How to use »
  ```lua
  BaseWars:AddAdvert(600, "Hello every 10 mins")
  ```

# PLAYER Functions

## Server:

## Client:

## Shared:

# ENTITY Functions

## Server:

## Client:

## Shared:

<!--
- ``
  - Argument Type
    - a » **_a_**
  - How to use »
  ```lua
  ```
-->
