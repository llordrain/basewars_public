
AddCSLuaFile()
DEFINE_BASECLASS("player_sandbox")

local PLAYER = {}

PLAYER.DisplayName			= "BaseWars Class"

PLAYER.SlowWalkSpeed		= 200
PLAYER.WalkSpeed			= 0		    -- Set in PLAYER:Init()
PLAYER.RunSpeed				= 0		    -- Set in PLAYER:Init()
PLAYER.CrouchedWalkSpeed	= 0.3
PLAYER.DuckSpeed			= 0.3
PLAYER.UnDuckSpeed			= 0.3
PLAYER.JumpPower			= 200
PLAYER.CanUseFlashlight		= true
PLAYER.MaxHealth			= 0		    -- Set in PLAYER:Init()
PLAYER.MaxArmor				= 0		    -- Set in PLAYER:Init()
PLAYER.StartHealth			= 0		    -- Set in PLAYER:Init()
PLAYER.StartArmor			= 0			-- Set in PLAYER:Init()
PLAYER.DropWeaponOnDie		= false
PLAYER.TeammateNoCollide	= false
PLAYER.AvoidPlayers			= false
PLAYER.UseVMHands			= true

function PLAYER:SetupDataTables()
    BaseClass.SetupDataTables(self)
end

function PLAYER:Init()
    self.MaxHealth = BaseWars.Config.DefaultHealth
    self.StartHealth = self.MaxHealth

    self.MaxArmor = BaseWars.Config.DefaultArmor
    self.StartArmor = 0

    self.WalkSpeed = BaseWars.Config.WalkSpeed
    self.RunSpeed = BaseWars.Config.RunSpeed
end

local defaultVector = Vector(0.001, 0.001, 0.001)
function PLAYER:Spawn()
    local weaponColor = Vector(self.Player:GetInfo("cl_weaponcolor"))
    if weaponColor:Length() < 0.001 then
        weaponColor = defaultVector
    end

    self.Player:SetWeaponColor(weaponColor)
end

function PLAYER:Loadout()
    self.Player:RemoveAllAmmo()

    -- Suck my balls convars
    if BaseWars.Config.SBoxWeaps then
        self.Player:GiveAmmo(256, "Pistol", true)
        self.Player:GiveAmmo(256, "SMG1", true)
        self.Player:GiveAmmo(5, "grenade", true)
        self.Player:GiveAmmo(64, "Buckshot", true)
        self.Player:GiveAmmo(32, "357", true)
        self.Player:GiveAmmo(32, "XBowBolt", true)
        self.Player:GiveAmmo(6, "AR2AltFire", true)
        self.Player:GiveAmmo(100, "AR2", true)

        self.Player:Give("weapon_crowbar")
        self.Player:Give("weapon_pistol")
        self.Player:Give("weapon_smg1")
        self.Player:Give("weapon_frag")
        self.Player:Give("weapon_physcannon")
        self.Player:Give("weapon_crossbow")
        self.Player:Give("weapon_shotgun")
        self.Player:Give("weapon_357")
        self.Player:Give("weapon_rpg")
        self.Player:Give("weapon_ar2")
    end

    self.Player:Give("gmod_tool")
    self.Player:Give("gmod_camera")
    self.Player:Give("weapon_physgun")

    for k, v in pairs(BaseWars.Config.SpawnWeaps) do
        self.Player:Give(v)
    end

    self.Player:SelectWeapon("hands")
end

local defaultModels = {
    "models/player/Group01/Female_01.mdl",
    "models/player/Group01/Female_02.mdl",
    "models/player/Group01/Female_03.mdl",
    "models/player/Group01/Female_04.mdl",
    "models/player/Group01/Female_06.mdl",
    "models/player/group01/male_01.mdl",
    "models/player/Group01/Male_02.mdl",
    "models/player/Group01/male_03.mdl",
    "models/player/Group01/Male_04.mdl",
    "models/player/Group01/Male_05.mdl",
    "models/player/Group01/Male_06.mdl",
    "models/player/Group01/Male_07.mdl",
    "models/player/Group01/Male_08.mdl",
    "models/player/Group01/Male_09.mdl"
}
function PLAYER:SetModel()
    self.Player:SetModel(defaultModels[math.random(#defaultModels)])
end

function PLAYER:Death(inflictor, attacker)
    BaseClass.Death(self, inflictor, attacker)
end

function PLAYER:CalcView(view)
    BaseClass.CalcView(self, view)
end

function PLAYER:CreateMove(cmd)
    BaseClass.CreateMove(self, cmd)
end

function PLAYER:ShouldDrawLocal()
    BaseClass.ShouldDrawLocal(self)
end

function PLAYER:StartMove(cmd, mv)
    BaseClass.StartMove(self, cmd, mv)
end

function PLAYER:Move(mv)
    BaseClass.Move(self, mv)
end

function PLAYER:FinishMove(mv)
    BaseClass.FinishMove(self, mv)
end

function PLAYER:ViewModelChanged(vm, old, new)
    BaseClass.ViewModelChanged(self, vm, old, new)
end

function PLAYER:PreDrawViewModel(vm, weapon)
    BaseClass.PreDrawViewModel(self, vm, weapon)
end

function PLAYER:PostDrawViewModel(vm, weapon)
    BaseClass.PostDrawViewModel(self, vm, weapon)
end

function PLAYER:GetHandsModel()
    return player_manager.TranslatePlayerHands(player_manager.TranslateToPlayerModelName(self.Player:GetModel()))
end

player_manager.RegisterClass("player_basewars", PLAYER, "player_sandbox")
