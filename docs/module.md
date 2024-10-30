# Stop-by-step

1. Create a folder in `gamemode/modules`
2. Inside that folder create a `module.lua` file
3. Inside `module.lua` copy-paste the code down below

```lua
return {
    author = "llordrain",
    version = "1.0.0",
    name =  "Module Name",
    desc = "Module Description",
    enable = true,
}
```

### IF ANY OF THESE ARE MISSING, YOUR MODULE WILL NOT BE LOADED

`author` » You

`version` » the version of your module

`name` » The name of your module

`desc` » The description of your module

`enable` » Enable/Disable your module. If disabled, your module will not be loaded at all (By that i mean that BaseWars:LoadModules() will ignore it as if it didn't exists)

# Files Types:

- SHARED

  - sh\_\*.lua
  - init\_\*.lua

- CLIENT

  - cl\_\*.lua

- SERVER
  - sv\_\*.lua
  - db\_\*.lua

# Loading Order

- SERVER

  - **init\_\*.lua**
  - (In Console) Initialized modules count
  - (Base Module) **sh\_\*.lua**
  - (Base Module) **sv\_\*.lua**
  - (In Console) Base Module Loaded
  - **sh\_\*.lua**
  - **sv\_\*.lua**
  - **db\_\*.lua**
  - (In Console) Chat commands count
  - (In Console) Console commands count
  - (In Console) Loaded X modules (X files) in X secs

- CLIENT

  - **init\_\*.lua**
  - (In Console) Initialized modules count
  - (Base Module) **sh\_\*.lua**
  - (Base Module) **cl\_\*.lua**
  - (In Console) Base Module Loaded
  - **sh\_\*.lua**
  - **cl\_\*.lua**
  - (In Console) Chat commands count
  - (In Console) Loaded X modules (X files) in X secs
