# Configuration of the gamemode

The basic configuration is made in game.

The MySQL config is in [config/MySQL.lua](gamemode/config/MySQL.lua)

The Shoplist (F4) config is in [config/entities.lua](gamemode/config/entities.lua)

---

# Do stuff with the shoplist

To add a category _(A tab)_ in the shoplist you need to call the function `BaseWars:CreateCategory()`, this function has 3 arguments and returns the first argument to make it easier to use:

1. **String** » The name of the category
2. **String** » The path of the icon of the cateogry, must end in `.png` or `.jpg`
3. **Number** » The order of the category in which it will be displayed in the shoplist menu

**Exemple usage**:

```lua
local myCategory = BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)
```

**or**

```lua
BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)
```

---

To add an entity in the shoplist you need to call the function `BaseWars:CreateEntity()` and give it a unique id as its first and only argument _(the id can be the entity class)_. This function return the entity itself that you can use as a variable but you can also chain the sub-function directly onto it.

## Here's a list of the the sub-functions:

| Function       | Argument Type | Returns Value Type |
| :------------- | :-----------: | :----------------: |
| SetClass       |    String     |         -          |
| SetName        |    String     |         -          |
| SetCategory    |    String     |         -          |
| SetSubCategory |    String     |         -          |
| SetPrice       |    Number     |         -          |
| SetMax         |    Number     |         -          |
| SetPrestige    |    Number     |         -          |
| SetLevel       |    Number     |         -          |
| SetCustomSpawn |    Boolean    |         -          |
| SetIsDrug      |    Boolean    |         -          |
| SetIsWeapon    |    Boolean    |         -          |
| SetVehicleName |    String     |         -          |
| SetModel       |    String     |         -          |
| SetRankCheck   |   Function    |         -          |
| SetCooldown    |    Number     |         -          |
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
| Finish         |       -       |         -          |

**Exemple usage**:

```lua
local fogCube = BaseWars:CreateEntity("edit_fog")
fogCube:SetClass("edit_fog")
fogCube:SetCategory(myCategory)
fogCube:SetPrice(1e6)
fogCube:SetLevel(500)
fogCube:SetLimit(5)
fogCube:Finish()
```

**or**

```lua
BaseWars:CreateEntity("edit_fog"):SetClass("edit_fog"):SetCategory("My Category Name"):SetPrice(1e6):SetLevel(500):SetLimit(5):Finish()
```

---

> [!IMPORTANT]
> Finish() **MUST** be called on an entity otherwise it will not appear in the shoplist and will give you an error in the console

---

# Create Your Own Module

# Hooks

## Server:

## Client:

## Shared:

# Function

## Server:

## Client:

## Shared:

# PLAYER Functions

## Server:

## Client:

## Shared:

# ENTITY Functions

## Server:

## Client:

## Shared:
