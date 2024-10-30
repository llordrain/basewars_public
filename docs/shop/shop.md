# Add a category

```lua
BaseWars:CreateCategory(CategoryName : String, IconPath : String, Order : Float | nil) -> CategoryName : String
```

### Usage:

```lua
local myCategory = BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)
```

# Add an item

```lua
BaseWars:CreateEntity(EntityID : String) -> EntityObject : Table
```

### Usage:

```lua
local myCategory = BaseWars:CreateCategory("My Category Name", "my_icon.png", 5)
local fogCube = BaseWars:CreateEntity("edit_fog")
fogCube:SetClass("edit_fog")
fogCube:SetCategory(myCategory)
fogCube:SetPrice(1e6)
fogCube:SetLevel(500)
fogCube:SetLimit(5)
fogCube:Finish()

BaseWars:CreateCategory("My Category Name 2", "my_icon.png", 5.5)
BaseWars:CreateEntity("edit_fog2"):SetClass("edit_fog"):SetCategory("My Category Name 2"):SetPrice(1e6):SetLevel(500):SetLimit(5):Finish()
```

## Methods that can be used with `BaseWars:CreateEntity()`

| Method(Args Type)       | Returns  |                                    Default                                    |
| :---------------------- | :------: | :---------------------------------------------------------------------------: |
| Finish()                |    --    |                                      --                                       |
| SetClass(String)        |  _self_  |                                "prop_physics"                                 |
| SetName(String)         |  _self_  |                                "Default Name"                                 |
| SetCategory(String)     |  _self_  |                              "Default Category"                               |
| SetSubCategory(String)  |  _self_  |                             "Default Subcategory"                             |
| SetPrice(Number)        |  _self_  |                                     10000                                     |
| SetMax(Number)          |  _self_  |                            _Default Limit Config_                             |
| SetPrestige(Number)     |  _self_  |                                       0                                       |
| SetLevel(Number)        |  _self_  |                                       1                                       |
| SetCustomSpawn(Boolean) |  _self_  |                                     false                                     |
| SetIsDrug(Boolean)      |  _self_  |                                     false                                     |
| SetIsWeapon(Boolean)    |  _self_  |                                     false                                     |
| SetVehicleName(String)  |  _self_  |                                   false (?)                                   |
| SetModel(String)        |  _self_  |                                  "error.mdl"                                  |
| SetRankCheck(Function)  |  _self_  | [defaultTrueFunc()](../../gamemode/modules/base/sh_baeswars_entities.lua#L17) |
| SetCooldown(Number)     |  _self_  |                                       0                                       |
| GetID()                 |  String  |                                      --                                       |
| GetClass()              |  String  |                                      --                                       |
| GetName()               |  String  |                                      --                                       |
| GetCategory()           |  String  |                                      --                                       |
| GetSubCategory()        |  String  |                                      --                                       |
| GetPrice()              |  Number  |                                      --                                       |
| GetMax()                |  Number  |                                      --                                       |
| GetPrestige()           |  Number  |                                      --                                       |
| GetLevel()              |  Number  |                                      --                                       |
| GetCustomSpawn()        | Boolean  |                                      --                                       |
| IsDrug()                | Boolean  |                                      --                                       |
| IsWeapon()              | Boolean  |                                      --                                       |
| GetVehicleName()        |  String  |                                      --                                       |
| GetModel()              |  String  |                                      --                                       |
| GetRankCheck()          | Function |                                      --                                       |
| GetCooldown()           |  Number  |                                      --                                       |
