BaseWars:CreateCategory("Favorites", "basewars_materials/f4/favorite.png", 1)
local PRINTERS_CATEGORY = BaseWars:CreateCategory("Printers", "basewars_materials/f4/printer.png", 2)
local WEAPONS_CATEGORY = BaseWars:CreateCategory("Weapons", "basewars_materials/f4/weapon.png", 3)
local DEFENSES_CATEGORY = BaseWars:CreateCategory("Defenses", "basewars_materials/f4/defense.png", 4)
local RAID_CATEGORY = BaseWars:CreateCategory("Raid", "basewars_materials/f4/bomb.png", 5)
local FARMING_CATEGORY = BaseWars:CreateCategory("Farming", "basewars_materials/f4/farming.png", 6)
local MISC_CATEGORY = BaseWars:CreateCategory("Misc", "basewars_materials/f4/misc.png", 7)

local PRINTER_MODEL = "models/props_c17/consolebox01a.mdl"
local BANK_MODEL = "models/props_c17/consolebox01a.mdl"
local TURRET_MODEL = "models/combine_turrets/floor_turret.mdl"
local TESLA_MODEL = "models/props_c17/substation_transformer01d.mdl"
local MINE_MODEL = "models/props_combine/combine_mine01.mdl"
local IS_VIP_FUNCTION = function(ply) return BaseWars:IsVIP(ply), "VIP" end

--[[-------------------------------------------------------------------------
	PRINTERS & BANK
---------------------------------------------------------------------------]]
local PRINTER_TIER_1 = "1Printers Tier 1"
BaseWars:CreateEntity("bw_base_bank"):SetClass("bw_base_bank"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_1):SetName("Bank"):SetPrice(50000):SetMax(1):SetLevel(1):SetModel(BANK_MODEL):Finish()

-- PRINTER TIER 1
BaseWars:CreateEntity("bw_base_printer"):SetClass("bw_base_printer"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_1):SetName("Basic Printer"):SetPrice(2000):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_vip1"):SetClass("bw_printer_vip1"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_1):SetName("Printer VIP 1"):SetPrice(2001):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

-- PRINTER TIER 2
local PRINTER_TIER_2 = "2Printers Tier 2"
BaseWars:CreateEntity("bw_printer_copper"):SetClass("bw_printer_copper"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Copper Printer"):SetPrice(12500):SetLevel(3):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_silver"):SetClass("bw_printer_silver"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Silver Printer"):SetPrice(20000):SetLevel(7):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_gold"):SetClass("bw_printer_gold"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Gold Printer"):SetPrice(50000):SetLevel(9):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_platinum"):SetClass("bw_printer_platinum"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Platinum Printer"):SetPrice(75000):SetLevel(13):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_iridium"):SetClass("bw_printer_iridium"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Iridium Printer"):SetPrice(150000):SetLevel(17):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_uranium"):SetClass("bw_printer_uranium"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("Uranium Printer"):SetPrice(300000):SetLevel(21):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_vip2"):SetClass("bw_printer_vip2"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_2):SetName("VIP Printer 2"):SetPrice(300001):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

-- PRINTER TIER 3
local PRINTER_TIER_3 = "3Printers Tier 3"
BaseWars:CreateEntity("bw_printer_mobius"):SetClass("bw_printer_mobius"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Mobius Printer"):SetPrice(15000000):SetLevel(50):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_darkmatter"):SetClass("bw_printer_darkmatter"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Dark Matter Printer"):SetPrice(30000000):SetLevel(60):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_redmatter"):SetClass("bw_printer_redmatter"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Red Matter Printer"):SetPrice(45000000):SetLevel(70):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_monolith"):SetClass("bw_printer_monolith"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Monolith Printer"):SetPrice(60000000):SetLevel(80):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_quantum"):SetClass("bw_printer_quantum"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Quantum Printer"):SetPrice(85000000):SetLevel(90):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_quasar"):SetClass("bw_printer_quasar"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("Quasar Printer"):SetPrice(110000000):SetLevel(100):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_vip3"):SetClass("bw_printer_vip3"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_3):SetName("VIP Printer 3"):SetPrice(110000001):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

-- PRINTER TIER 4
local PRINTER_TIER_4 = "4Printers Tier 4"
BaseWars:CreateEntity("bw_printer_emerald"):SetClass("bw_printer_emerald"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Emerald Printer"):SetPrice(550000000):SetLevel(125):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_obsidian"):SetClass("bw_printer_obsidian"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Obsidian Printer"):SetPrice(1000000000):SetLevel(150):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_diamond"):SetClass("bw_printer_diamond"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Diamond Printer"):SetPrice(1300000000):SetLevel(175):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_tanzan"):SetClass("bw_printer_tanzan"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Tanzanite Printer"):SetPrice(1800000000):SetLevel(200):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_opal"):SetClass("bw_printer_opal"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Black Opal Printer"):SetPrice(2200000000):SetLevel(225):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_redberyl"):SetClass("bw_printer_redberyl"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("Red Beryl Printer"):SetPrice(2600000000):SetLevel(250):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_vip4"):SetClass("bw_printer_vip4"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_4):SetName("VIP Printer 4"):SetPrice(2600000001):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

-- PRINTER TIER 5
local PRINTER_TIER_5 = "5Printers Tier 5"
BaseWars:CreateEntity("bw_printer_galactic"):SetClass("bw_printer_galactic"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Galactic Printer"):SetPrice(20e9):SetLevel(300):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_cosmos"):SetClass("bw_printer_cosmos"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Cosmos Printer"):SetPrice(36e9):SetLevel(350):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_infinity"):SetClass("bw_printer_infinity"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Infinity Printer"):SetPrice(51e9):SetLevel(400):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_space"):SetClass("bw_printer_space"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Space Printer"):SetPrice(58e9):SetLevel(450):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_celest"):SetClass("bw_printer_celest"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Celest Printer"):SetPrice(64e9):SetLevel(500):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_orbital"):SetClass("bw_printer_orbital"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("Orbital Printer"):SetPrice(80e9):SetLevel(550):SetMax(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_vip5"):SetClass("bw_printer_vip5"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRINTER_TIER_5):SetName("VIP Printer 5"):SetPrice(80000000001):SetLevel(1):SetMax(4):SetModel(PRINTER_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

-- PRESTIGE PRINTERS
local PRESTIGE_PRINTERS = "6Prestige Printers"
BaseWars:CreateEntity("bw_printer_prestige1"):SetClass("bw_printer_prestige1"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 1"):SetPrice(4000):SetLevel(5):SetMax(8):SetPrestige(1):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige2"):SetClass("bw_printer_prestige2"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 2"):SetPrice(500000):SetLevel(15):SetMax(8):SetPrestige(2):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige3"):SetClass("bw_printer_prestige3"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 3"):SetPrice(140000000):SetLevel(70):SetMax(8):SetPrestige(3):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige4"):SetClass("bw_printer_prestige4"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 4"):SetPrice(32e8):SetLevel(170):SetMax(8):SetPrestige(4):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige5"):SetClass("bw_printer_prestige5"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 5"):SetPrice(95e9):SetLevel(350):SetMax(8):SetPrestige(5):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige6"):SetClass("bw_printer_prestige6"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 6"):SetPrice(20e12):SetLevel(30e3):SetMax(8):SetPrestige(10):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige7"):SetClass("bw_printer_prestige7"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 7"):SetPrice(65e12):SetLevel(100e3):SetMax(8):SetPrestige(20):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige8"):SetClass("bw_printer_prestige8"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 8"):SetPrice(140e12):SetLevel(250e3):SetMax(8):SetPrestige(30):SetModel(PRINTER_MODEL):Finish()
BaseWars:CreateEntity("bw_printer_prestige9"):SetClass("bw_printer_prestige9"):SetCategory(PRINTERS_CATEGORY):SetSubCategory(PRESTIGE_PRINTERS):SetName("Prestige Printer 9"):SetPrice(15e15):SetLevel(5e6):SetMax(999):SetPrestige(50):SetModel(PRINTER_MODEL):Finish()

--[[-------------------------------------------------------------------------
	DEFENSES
---------------------------------------------------------------------------]]
local DEFENSE_TIER_1 = "1Defenses Tier 1"
BaseWars:CreateEntity("bw_mine"):SetClass("bw_mine"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_1):SetName("Mine"):SetPrice(40000):SetLevel(9):SetMax(3):SetModel(MINE_MODEL):Finish()
BaseWars:CreateEntity("bw_turret_ballistic"):SetClass("bw_turret_ballistic"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_1):SetName("Ballistic Turret"):SetPrice(85000):SetLevel(15):SetMax(2):SetModel(TURRET_MODEL):Finish()
BaseWars:CreateEntity("bw_turret_laser"):SetClass("bw_turret_laser"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_1):SetName("Laser Turret"):SetPrice(120000):SetLevel(15):SetMax(2):SetModel(TURRET_MODEL):Finish()
BaseWars:CreateEntity("bw_base_tesla"):SetClass("bw_base_tesla"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_1):SetName("Tesla"):SetPrice(65000000):SetLevel(20):SetMax(1):SetModel(TESLA_MODEL):Finish()

local DEFENSE_TIER_2 = "2Defenses Tier 2"
BaseWars:CreateEntity("bw_mine_speed"):SetClass("bw_mine_speed"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_2):SetName("Fast Mine"):SetPrice(80000):SetLevel(20):SetMax(2):SetModel(MINE_MODEL):Finish()
BaseWars:CreateEntity("bw_mine_power"):SetClass("bw_mine_power"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_2):SetName("Powerful Mine"):SetPrice(150000):SetLevel(25):SetMax(2):SetModel(MINE_MODEL):Finish()
BaseWars:CreateEntity("bw_mine_shock"):SetClass("bw_mine_shock"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_2):SetName("Shock Mine"):SetPrice(250000):SetLevel(30):SetMax(2):SetModel(MINE_MODEL):Finish()
BaseWars:CreateEntity("bw_turret_laser_rapid"):SetClass("bw_turret_laser_rapid"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_2):SetName("Rapid Laser Turret"):SetPrice(1100000):SetLevel(45):SetMax(1):SetModel(TURRET_MODEL):Finish()
BaseWars:CreateEntity("bw_tesla_rapid"):SetClass("bw_tesla_rapid"):SetCategory(DEFENSES_CATEGORY):SetSubCategory(DEFENSE_TIER_2):SetName("Rapid Tesla"):SetPrice(230000000):SetLevel(65):SetMax(1):SetModel(TESLA_MODEL):SetRankCheck(IS_VIP_FUNCTION):Finish()

--[[-------------------------------------------------------------------------
	RAIDS
---------------------------------------------------------------------------]]
local RAIDS_TOOLS = "Tools"
BaseWars:CreateEntity("bw_heal_gun"):SetClass("bw_heal_gun"):SetCategory(RAID_CATEGORY):SetSubCategory(RAIDS_TOOLS):SetName("Heal Gun"):SetPrice(3500000):SetLevel(45):SetMax(5):SetModel("models/weapons/w_Physics.mdl"):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("bw_blowtorch"):SetClass("bw_blowtorch"):SetCategory(RAID_CATEGORY):SetSubCategory(RAIDS_TOOLS):SetName("Blow Torch"):SetPrice(40000):SetLevel(9):SetMax(5):SetModel("models/weapons/w_irifle.mdl"):SetIsWeapon(true):Finish()

local RAIDS_EXPLOSIVES = "Explosives"
BaseWars:CreateEntity("bw_weapon_c4"):SetClass("bw_weapon_c4"):SetCategory(RAID_CATEGORY):SetSubCategory(RAIDS_EXPLOSIVES):SetName("C4"):SetPrice(5500000):SetLevel(30):SetMax(1):SetModel("models/weapons/w_c4.mdl"):SetCooldown(5):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("bw_explosive_bigbomb"):SetClass("bw_explosive_bigbomb"):SetCategory(RAID_CATEGORY):SetSubCategory(RAIDS_EXPLOSIVES):SetName("Big Bomb"):SetPrice(500000000):SetLevel(45):SetMax(1):SetModel("models/props_c17/oildrum001.mdl"):Finish()
BaseWars:CreateEntity("bw_explosive_nuke"):SetClass("bw_explosive_nuke"):SetCategory(RAID_CATEGORY):SetSubCategory(RAIDS_EXPLOSIVES):SetName("Nuke"):SetPrice(25e12):SetLevel(125):SetMax(1):SetModel("models/props_phx/mk-82.mdl"):Finish()

--[[-------------------------------------------------------------------------
	MISC
---------------------------------------------------------------------------]]
local DISPENSER_TIER_1 = "1Dispensers Tier 1"
BaseWars:CreateEntity("bw_base_armordispenser"):SetClass("bw_base_armordispenser"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_1):SetName("Armor Dispenser"):SetPrice(35000):SetLevel(20):SetMax(2):SetModel("models/props_blackmesa/hev_charger_clean.mdl"):Finish()
BaseWars:CreateEntity("bw_base_healthdispenser"):SetClass("bw_base_healthdispenser"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_1):SetName("Health Dispenser"):SetPrice(50000):SetLevel(15):SetMax(2):SetModel("models/props_blackmesa/health_charger_clean.mdl"):Finish()
BaseWars:CreateEntity("bw_base_ammodispenser"):SetClass("bw_base_ammodispenser"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_1):SetName("Ammo Dispenser"):SetPrice(65000):SetLevel(25):SetMax(2):SetModel("models/codvanguard/other/supplybox.mdl"):Finish()

local DISPENSER_TIER_2 = "2Dispensers Tier 2"
BaseWars:CreateEntity("bw_armordispenser_v2"):SetClass("bw_armordispenser_v2"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_2):SetName("Armor Dispenser V2"):SetPrice(20000000):SetLevel(110):SetMax(2):SetModel("models/props_blackmesa/hev_charger_clean.mdl"):Finish()
BaseWars:CreateEntity("bw_healthdispenser_v2"):SetClass("bw_healthdispenser_v2"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_2):SetName("Health Dispenser V2"):SetPrice(25000000):SetLevel(80):SetMax(2):SetModel("models/props_blackmesa/health_charger_clean.mdl"):Finish()
BaseWars:CreateEntity("bw_ammodispenser_v2"):SetClass("bw_ammodispenser_v2"):SetCategory(MISC_CATEGORY):SetSubCategory(DISPENSER_TIER_2):SetName("Ammo Dispenser V2"):SetPrice(30000000):SetLevel(125):SetMax(2):SetModel("models/codvanguard/other/supplybox.mdl"):Finish()

local KITS = "3Kits"
BaseWars:CreateEntity("bw_base_armorkit"):SetClass("bw_base_armorkit"):SetCategory(MISC_CATEGORY):SetSubCategory(KITS):SetName("Armor Kit"):SetPrice(50000):SetLevel(25):SetMax(10):SetModel("models/codmw2022/other/armorbox.mdl"):Finish()
BaseWars:CreateEntity("bw_advance_armorkit"):SetClass("bw_advance_armorkit"):SetCategory(MISC_CATEGORY):SetSubCategory(KITS):SetName("Advanced Armor Kit"):SetPrice(500000):SetLevel(80):SetMax(10):SetModel("models/codmw2022/other/armorbox.mdl"):Finish()
BaseWars:CreateEntity("bw_repairkit"):SetClass("bw_repairkit"):SetCategory(MISC_CATEGORY):SetSubCategory(KITS):SetName("Repair Kit"):SetPrice(25000):SetLevel(20):SetMax(10):SetModel("models/Items/car_battery01.mdl"):Finish()

local STRUCTURES = "4Structures"
BaseWars:CreateEntity("bw_spawnpoint"):SetClass("bw_spawnpoint"):SetCategory(MISC_CATEGORY):SetSubCategory(STRUCTURES):SetName("Spawn Point"):SetPrice(25000):SetLevel(1):SetMax(3):SetModel("models/props_trainstation/trainstation_clock001.mdl"):SetCustomSpawn(true):Finish()
BaseWars:CreateEntity("bw_radar"):SetClass("bw_radar"):SetCategory(MISC_CATEGORY):SetSubCategory(STRUCTURES):SetName("Radar"):SetPrice(25000000):SetLevel(35):SetMax(1):SetModel("models/props_rooftop/roof_dish001.mdl"):Finish()

BaseWars:CreateEntity("mediaplayer_tv"):SetClass("mediaplayer_tv"):SetCategory(MISC_CATEGORY):SetSubCategory("TV"):SetName("TV"):SetPrice(50000):SetLevel(1):SetMax(1):SetModel("models/gmod_tower/suitetv_large.mdl"):Finish()

-- local VEHICLES = "Vehicles"
-- BaseWars:CreateEntity("IDK"):SetClass("IDK"):SetCategory(MISC_CATEGORY):SetSubCategory(VEHICLES):SetName("Golf Cart"):SetPrice(2000000000):SetLevel(1000):SetMax(1):SetModel(""):SetVehicleName("golfcart_sgm"):Finish()

--[[-------------------------------------------------------------------------
	WEAPONS
---------------------------------------------------------------------------]]
local ZEROS_FIRECRACKER = "1Zero's FireCracker"
BaseWars:CreateEntity("zcm_crackermachine"):SetClass("zcm_crackermachine"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Machine"):SetPrice(250000000):SetLevel(220):SetMax(1):SetModel("models/zerochain/props_crackermaker/zcm_base.mdl"):Finish()
BaseWars:CreateEntity("zcm_box"):SetClass("zcm_box"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Box"):SetPrice(20000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_box.mdl"):Finish()
BaseWars:CreateEntity("zcm_blackpowder"):SetClass("zcm_blackpowder"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Black Powder"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_blackpowder.mdl"):Finish()
BaseWars:CreateEntity("zcm_paperroll"):SetClass("zcm_paperroll"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Paper Roll"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_paper.mdl"):Finish()

local CIGARETTE = "2Cigarette"
BaseWars:CreateEntity("cf_cigarette_machine"):SetClass("cf_cigarette_machine"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Machine"):SetPrice(350e6):SetLevel(250):SetMax(1):SetModel("models/cigarette_factory/cf_machine.mdl"):SetPrestige(5):Finish()
BaseWars:CreateEntity("cf_engine_upgrade"):SetClass("cf_engine_upgrade"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Machine Upgrade"):SetPrice(200e6):SetLevel(250):SetMax(1):SetModel("models/maxofs2d/thruster_propeller.mdl"):SetPrestige(5):Finish()
BaseWars:CreateEntity("cf_storage_upgrade"):SetClass("cf_storage_upgrade"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Storage Upgrade"):SetPrice(150e6):SetLevel(250):SetMax(1):SetModel("models/thrusters/jetpack.mdl"):SetPrestige(5):Finish()
BaseWars:CreateEntity("cf_delievery_box"):SetClass("cf_delievery_box"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Box"):SetPrice(100e6):SetLevel(250):SetMax(2):SetModel("models/props_junk/cardboard_box003a.mdl"):SetPrestige(5):Finish()
BaseWars:CreateEntity("cf_roll_paper"):SetClass("cf_roll_paper"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Paper"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_rollpaper.mdl"):SetPrestige(5):Finish()
BaseWars:CreateEntity("cf_tobacco_pack"):SetClass("cf_tobacco_pack"):SetCategory(FARMING_CATEGORY):SetSubCategory(CIGARETTE):SetName("Tobacco"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_tobacco_pack.mdl"):SetPrestige(5):Finish()

local ZEROS_OILRUSH = "3Zero's Oilrush"
BaseWars:CreateEntity("zrush_machinecrate"):SetClass("zrush_machinecrate"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_OILRUSH):SetName("Oil Mahine Crate"):SetPrice(1000000):SetLevel(2000):SetMax(4):SetModel("models/zerochain/props_oilrush/zor_machinecrate.mdl"):Finish()
BaseWars:CreateEntity("zrush_barrel"):SetClass("zrush_barrel"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_OILRUSH):SetName("Oil Barrel"):SetPrice(400000000):SetLevel(2000):SetMax(10):SetModel("models/zerochain/props_oilrush/zor_barrel.mdl"):Finish()
BaseWars:CreateEntity("zrush_drillpipe_holder"):SetClass("zrush_drillpipe_holder"):SetCategory(FARMING_CATEGORY):SetSubCategory(ZEROS_OILRUSH):SetName("Oil Drill Pipe"):SetPrice(400000000):SetLevel(2000):SetMax(5):SetModel("models/zerochain/props_oilrush/zor_drillpipe_holder.mdl"):Finish()

local BITMIER = "4Bitminer 2"
BaseWars:CreateEntity("bm2_bitminer_rack"):SetClass("bm2_bitminer_rack"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Bitminer Rack"):SetPrice(25e11):SetLevel(5500):SetMax(1):SetModel("models/bitminers2/bitminer_rack.mdl"):SetPrestige(1):Finish()
BaseWars:CreateEntity("bm2_generator"):SetClass("bm2_generator"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Generator"):SetPrice(400e9):SetLevel(5500):SetMax(1):SetModel("models/bitminers2/generator.mdl"):SetPrestige(1):Finish()
BaseWars:CreateEntity("bm2_fuel"):SetClass("bm2_fuel"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Fuel"):SetPrice(20e9):SetLevel(5500):SetMax(5):SetModel("models/props_junk/gascan001a.mdl"):SetPrestige(1):Finish()
BaseWars:CreateEntity("bm2_extra_fuel_tank"):SetClass("bm2_extra_fuel_tank"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Fuel Tank"):SetPrice(7505e9):SetLevel(5500):SetMax(1):SetModel("models/bitminers2/bm2_extra_fueltank.mdl"):SetPrestige(1):SetRankCheck(IS_VIP_FUNCTION):Finish()
BaseWars:CreateEntity("bm2_extra_fuel_line"):SetClass("bm2_extra_fuel_line"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Fuel Line"):SetPrice(50e9):SetLevel(5500):SetMax(1):SetModel("models/bitminers2/bm2_extra_fuel_plug.mdl"):SetPrestige(1):SetRankCheck(IS_VIP_FUNCTION):Finish()
BaseWars:CreateEntity("bm2_large_fuel"):SetClass("bm2_large_fuel"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Large Fuel"):SetPrice(50e9):SetLevel(5500):SetMax(5):SetModel("models/props/de_train/barrel.mdl"):SetPrestige(1):SetRankCheck(IS_VIP_FUNCTION):Finish()
BaseWars:CreateEntity("bm2_bitminer_server"):SetClass("bm2_bitminer_server"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Bitminer Server"):SetPrice(300e9):SetLevel(5500):SetMax(8):SetModel("models/bitminers2/bitminer_2.mdl"):SetPrestige(1):Finish()
BaseWars:CreateEntity("bm2_power_lead"):SetClass("bm2_power_lead"):SetCategory(FARMING_CATEGORY):SetSubCategory(BITMIER):SetName("Power Lead"):SetPrice(25e9):SetLevel(5500):SetMax(1):SetModel("models/bitminers2/bitminer_plug_2.mdl"):SetPrestige(1):Finish()

local METH_LAB = "5Zero's Methlab"
BaseWars:CreateEntity("zmlab_frezzer"):SetClass("zmlab_frezzer"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Freezer"):SetPrice(10e12):SetLevel(10000):SetMax(1):SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl"):SetPrestige(3):Finish()
BaseWars:CreateEntity("zmlab_combiner"):SetClass("zmlab_combiner"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Combiner"):SetPrice(10e12):SetLevel(10000):SetMax(1):SetModel("models/zerochain/zmlab/zmlab_combiner.mdl"):SetPrestige(3):Finish()
BaseWars:CreateEntity("zmlab_filter"):SetClass("zmlab_filter"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Filter"):SetPrice(3e12):SetLevel(10000):SetMax(2):SetModel("models/zerochain/zmlab/zmlab_filter.mdl"):SetPrestige(3):Finish()
BaseWars:CreateEntity("zmlab_collectcrate"):SetClass("zmlab_collectcrate"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Transport Crate"):SetPrice(500e9):SetLevel(10000):SetMax(2):SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl"):SetPrestige(3):Finish()
BaseWars:CreateEntity("zmlab_aluminium"):SetClass("zmlab_aluminium"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Aluminium"):SetPrice(400e9):SetLevel(10000):SetMax(10):SetModel("models/zerochain/zmlab/zmlab_aluminiumbox.mdl"):SetPrestige(3):Finish()
BaseWars:CreateEntity("zmlab_methylamin"):SetClass("zmlab_methylamin"):SetCategory(FARMING_CATEGORY):SetSubCategory(METH_LAB):SetName("Methylamin"):SetPrice(400e9):SetLevel(10000):SetMax(10):SetModel("models/zerochain/zmlab/zmlab_methylamin.mdl"):SetPrestige(3):Finish()

--[[-------------------------------------------------------------------------
	WEAPONS
---------------------------------------------------------------------------]]
-- local GRENADES = "8Grenades"
-- BaseWars:CreateEntity("bw_grenade_gas"):SetClass("bw_grenade_gas"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(GRENADES):SetName("Gas Grenade"):SetPrice(150000000):SetLevel(500):SetMax(5):SetModel("models/props_rooftop/roof_dish001.mdl"):SetPrestige(5):SetIsWeapon(true):Finish()

local PISTOLS = "1Pistols"
BaseWars:CreateEntity("m9k_colt1911"):SetClass("m9k_colt1911"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("Colt 1911"):SetModel("models/weapons/s_dmgf_co1911.mdl"):SetPrice(20000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_hk45"):SetClass("m9k_hk45"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("HK45C"):SetModel("models/weapons/w_hk45c.mdl"):SetPrice(15000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_usp"):SetClass("m9k_usp"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("HK USP"):SetModel("models/weapons/w_pist_fokkususp.mdl"):SetPrice(30000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m92beretta"):SetClass("m9k_m92beretta"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("M92 Beretta"):SetModel("models/weapons/w_beretta_m92.mdl"):SetPrice(25000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_luger"):SetClass("m9k_luger"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("P08 Luger"):SetModel("models/weapons/w_luger_p08.mdl"):SetPrice(10000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_glock"):SetClass("m9k_glock"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("Glock 18"):SetModel("models/weapons/w_dmg_glock.mdl"):SetPrice(40000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_coltpython"):SetClass("m9k_coltpython"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("Colt Python"):SetModel("models/weapons/w_colt_python.mdl"):SetPrice(35000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_ragingbull"):SetClass("m9k_ragingbull"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("Raging Bull"):SetModel("models/weapons/w_taurus_raging_bull.mdl"):SetPrice(45000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_deagle"):SetClass("m9k_deagle"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(PISTOLS):SetName("Desert Eagle"):SetModel("models/weapons/w_tcom_deagle.mdl"):SetPrice(50000):SetMax(5):SetLevel(20):SetIsWeapon(true):Finish()

local SNIPER_RIFLES = "2Sniper Rifles"
BaseWars:CreateEntity("m9k_contender"):SetClass("m9k_contender"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("Thompson Contender G2"):SetModel("models/weapons/w_g2_contender.mdl"):SetPrice(800000):SetLevel(90):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_sl8"):SetClass("m9k_sl8"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("HK SL8"):SetModel("models/weapons/w_hk_sl8.mdl"):SetPrice(850000):SetLevel(90):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_remington7615p"):SetClass("m9k_remington7615p"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("Remington 7615P"):SetModel("models/weapons/w_remington_7615p.mdl"):SetPrice(900000):SetLevel(90):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m24"):SetClass("m9k_m24"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("M24"):SetModel("models/weapons/w_snip_m24_6.mdl"):SetPrice(950000):SetLevel(90):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m98b"):SetClass("m9k_m98b"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("Barret M98B"):SetModel("models/weapons/w_barrett_m98b.mdl"):SetPrice(1000000):SetLevel(100):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_intervention"):SetClass("m9k_intervention"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SNIPER_RIFLES):SetName("Intervention"):SetModel("models/weapons/w_snip_int.mdl"):SetPrice(1500000):SetLevel(100):SetIsWeapon(true):Finish()

local SMG = "3SMG"
BaseWars:CreateEntity("m9k_tec9"):SetClass("m9k_tec9"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("TEC 9"):SetModel("models/weapons/w_intratec_tec9.mdl"):SetPrice(60000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_uzi"):SetClass("m9k_uzi"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("UZI"):SetModel("models/weapons/w_uzi_imi.mdl"):SetPrice(65000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_mp5"):SetClass("m9k_mp5"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("HK MP5"):SetModel("models/weapons/w_hk_mp5.mdl"):SetPrice(70000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_mp5sd"):SetClass("m9k_mp5sd"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("MP5SD"):SetModel("models/weapons/w_hk_mp5sd.mdl"):SetPrice(75000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_bizonp19"):SetClass("m9k_bizonp19"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("Bizon PP19"):SetModel("models/weapons/w_pp19_bizon.mdl"):SetPrice(80000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_vector"):SetClass("m9k_vector"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("Vector"):SetModel("models/weapons/w_kriss_vector.mdl"):SetPrice(90000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_ump45"):SetClass("m9k_ump45"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("HK UMP45"):SetModel("models/weapons/w_hk_ump45.mdl"):SetPrice(85000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_smgp90"):SetClass("m9k_smgp90"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("P90"):SetModel("models/weapons/w_fn_p90.mdl"):SetPrice(95000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()
-- BaseWars:CreateEntity("m9k_honeybadger"):SetClass("m9k_honeybadger"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SMG):SetName("Honey Badger"):SetModel("models/weapons/w_aac_honeybadger.mdl"):SetPrice(100000):SetMax(5):SetLevel(40):SetIsWeapon(true):Finish()

local ASSAULT_RIFLES = "4Assault Rifles"
BaseWars:CreateEntity("m9k_g36"):SetClass("m9k_g36"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("G36"):SetModel("models/weapons/w_hk_g36c.mdl"):SetPrice(200000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_famas"):SetClass("m9k_famas"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("FAMAS"):SetModel("models/weapons/w_tct_famas.mdl"):SetPrice(250000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_ak47"):SetClass("m9k_ak47"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("AK-47"):SetModel("models/weapons/w_ak47_m9k.mdl"):SetPrice(300000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_ak74"):SetClass("m9k_ak74"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("AK-74"):SetModel("models/weapons/w_ak47_m9k.mdl"):SetPrice(350000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_acr"):SetClass("m9k_acr"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("ACR"):SetModel("models/weapons/w_masada_acr.mdl"):SetPrice(400000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_fal"):SetClass("m9k_fal"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("FN FAL"):SetModel("models/weapons/w_fn_fal.mdl"):SetPrice(450000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m416"):SetClass("m9k_m416"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("HK416"):SetModel("models/weapons/w_hk_416.mdl"):SetPrice(500000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m16a4"):SetClass("m9k_m16a4"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("M16A4"):SetModel("models/weapons/w_dmg_m16ag.mdl"):SetPrice(550000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m16a4_acog"):SetClass("m9k_m16a4_acog"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("M16A4 ACOG"):SetModel("models/weapons/w_dmg_m16ag.mdl"):SetPrice(600000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_scar"):SetClass("m9k_scar"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("SCAR"):SetModel("models/weapons/w_fn_scar_h.mdl"):SetPrice(650000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_tar21"):SetClass("m9k_tar21"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(ASSAULT_RIFLES):SetName("TAR 21"):SetModel("models/weapons/w_imi_tar21.mdl"):SetPrice(700000):SetMax(5):SetLevel(60):SetIsWeapon(true):Finish()

local SHOTGUNS = "5Shotguns"
BaseWars:CreateEntity("m9k_ithacam37"):SetClass("m9k_ithacam37"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("Ithaca M37"):SetModel("models/weapons/w_ithaca_m37.mdl"):SetPrice(2000000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_m3"):SetClass("m9k_m3"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("M3"):SetModel("models/weapons/w_benelli_m3.mdl"):SetPrice(2500000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_mossberg590"):SetClass("m9k_mossberg590"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("Mossberg 590"):SetModel("models/weapons/w_mossberg_590.mdl"):SetPrice(3000000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_remington870"):SetClass("m9k_remington870"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("Remington 870"):SetModel("models/weapons/w_remington_870_tact.mdl"):SetPrice(3500000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_1897winchester"):SetClass("m9k_1897winchester"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("Winchester 1897"):SetModel("models/weapons/w_winchester_1897_trench.mdl"):SetPrice(4000000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()
BaseWars:CreateEntity("m9k_1887winchester"):SetClass("m9k_1887winchester"):SetCategory(WEAPONS_CATEGORY):SetSubCategory(SHOTGUNS):SetName("Winchester 1887"):SetModel("models/weapons/w_winchester_1887.mdl"):SetPrice(4500000):SetMax(5):SetLevel(120):SetIsWeapon(true):Finish()

--[[-------------------------------------------------------------------------
	EXTRA PRESTIGE 25
---------------------------------------------------------------------------]]
local PRESTIGE_EXTRA_1_CATEGORY = BaseWars:CreateCategory("25th Prestige Extra", "basewars_materials/f4/prestige.png", 8, function(ply)
	if BaseWars.Config.Prestige.Enable then
		return ply:GetPrestige() >= 25
	end

	return true
end)

local ZEROS_FIRECRACKER = "1Zero's FireCracker"
BaseWars:CreateEntity("zcm_crackermachine2"):SetClass("zcm_crackermachine"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Machine"):SetPrice(250000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_base.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zcm_box2"):SetClass("zcm_box"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Box"):SetPrice(20000000):SetLevel(220):SetMax(4):SetModel("models/zerochain/props_crackermaker/zcm_box.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zcm_blackpowder2"):SetClass("zcm_blackpowder"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Black Powder"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_blackpowder.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zcm_paperroll2"):SetClass("zcm_paperroll"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Paper Roll"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_paper.mdl"):SetPrestige(25):Finish()

local CIGARETTE = "2Cigarette"
BaseWars:CreateEntity("cf_cigarette_machine2"):SetClass("cf_cigarette_machine"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Machine"):SetPrice(350e6):SetLevel(250):SetMax(2):SetModel("models/cigarette_factory/cf_machine.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("cf_engine_upgrade2"):SetClass("cf_engine_upgrade"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Machine Upgrade"):SetPrice(200e6):SetLevel(250):SetMax(2):SetModel("models/maxofs2d/thruster_propeller.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("cf_storage_upgrade2"):SetClass("cf_storage_upgrade"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Storage Upgrade"):SetPrice(150e6):SetLevel(250):SetMax(2):SetModel("models/thrusters/jetpack.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("cf_delievery_box2"):SetClass("cf_delievery_box"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Box"):SetPrice(100e6):SetLevel(250):SetMax(4):SetModel("models/props_junk/cardboard_box003a.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("cf_roll_paper2"):SetClass("cf_roll_paper"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Paper"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_rollpaper.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("cf_tobacco_pack2"):SetClass("cf_tobacco_pack"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(CIGARETTE):SetName("Tobacco"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_tobacco_pack.mdl"):SetPrestige(25):Finish()

local METH_LAB = "3Zero's Methlab"
BaseWars:CreateEntity("zmlab_frezzer2"):SetClass("zmlab_frezzer"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Freezer"):SetPrice(10e12):SetLevel(10000):SetMax(2):SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zmlab_combiner2"):SetClass("zmlab_combiner"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Combiner"):SetPrice(10e12):SetLevel(10000):SetMax(2):SetModel("models/zerochain/zmlab/zmlab_combiner.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zmlab_filter2"):SetClass("zmlab_filter"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Filter"):SetPrice(3e12):SetLevel(10000):SetMax(4):SetModel("models/zerochain/zmlab/zmlab_filter.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zmlab_collectcrate2"):SetClass("zmlab_collectcrate"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Transport Crate"):SetPrice(500e9):SetLevel(10000):SetMax(4):SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zmlab_aluminium2"):SetClass("zmlab_aluminium"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Aluminium"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_aluminiumbox.mdl"):SetPrestige(25):Finish()
BaseWars:CreateEntity("zmlab_methylamin2"):SetClass("zmlab_methylamin"):SetCategory(PRESTIGE_EXTRA_1_CATEGORY):SetSubCategory(METH_LAB):SetName("Methylamin"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_methylamin.mdl"):SetPrestige(25):Finish()

--[[-------------------------------------------------------------------------
	EXTRA PRESTIGE 35
---------------------------------------------------------------------------]]
local PRESTIGE_EXTRA_2_CATEGORY = BaseWars:CreateCategory("35th Prestige Extra", "basewars_materials/f4/prestige.png", 9, function(ply)
	if BaseWars.Config.Prestige.Enable then
		return ply:GetPrestige() >= 35
	end

	return true
end)

local ZEROS_FIRECRACKER = "1Zero's FireCracker"
BaseWars:CreateEntity("zcm_crackermachine3"):SetClass("zcm_crackermachine"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Machine"):SetPrice(250000000):SetLevel(220):SetMax(3):SetModel("models/zerochain/props_crackermaker/zcm_base.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zcm_box3"):SetClass("zcm_box"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Box"):SetPrice(20000000):SetLevel(220):SetMax(6):SetModel("models/zerochain/props_crackermaker/zcm_box.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zcm_blackpowder3"):SetClass("zcm_blackpowder"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Black Powder"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_blackpowder.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zcm_paperroll3"):SetClass("zcm_paperroll"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Paper Roll"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_paper.mdl"):SetPrestige(35):Finish()

local CIGARETTE = "2Cigarette"
BaseWars:CreateEntity("cf_cigarette_machine3"):SetClass("cf_cigarette_machine"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Machine"):SetPrice(350e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_machine.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("cf_engine_upgrade3"):SetClass("cf_engine_upgrade"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Machine Upgrade"):SetPrice(200e6):SetLevel(250):SetMax(3):SetModel("models/maxofs2d/thruster_propeller.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("cf_storage_upgrade3"):SetClass("cf_storage_upgrade"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Storage Upgrade"):SetPrice(150e6):SetLevel(250):SetMax(3):SetModel("models/thrusters/jetpack.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("cf_delievery_box3"):SetClass("cf_delievery_box"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Box"):SetPrice(100e6):SetLevel(250):SetMax(6):SetModel("models/props_junk/cardboard_box003a.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("cf_roll_paper3"):SetClass("cf_roll_paper"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Paper"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_rollpaper.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("cf_tobacco_pack3"):SetClass("cf_tobacco_pack"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(CIGARETTE):SetName("Tobacco"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_tobacco_pack.mdl"):SetPrestige(35):Finish()

local METH_LAB = "3Zero's Methlab"
BaseWars:CreateEntity("zmlab_frezzer3"):SetClass("zmlab_frezzer"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Freezer"):SetPrice(10e12):SetLevel(10000):SetMax(3):SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zmlab_combiner3"):SetClass("zmlab_combiner"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Combiner"):SetPrice(10e12):SetLevel(10000):SetMax(3):SetModel("models/zerochain/zmlab/zmlab_combiner.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zmlab_filter3"):SetClass("zmlab_filter"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Filter"):SetPrice(3e12):SetLevel(10000):SetMax(6):SetModel("models/zerochain/zmlab/zmlab_filter.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zmlab_collectcrate3"):SetClass("zmlab_collectcrate"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Transport Crate"):SetPrice(500e9):SetLevel(10000):SetMax(6):SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zmlab_aluminium3"):SetClass("zmlab_aluminium"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Aluminium"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_aluminiumbox.mdl"):SetPrestige(35):Finish()
BaseWars:CreateEntity("zmlab_methylamin3"):SetClass("zmlab_methylamin"):SetCategory(PRESTIGE_EXTRA_2_CATEGORY):SetSubCategory(METH_LAB):SetName("Methylamin"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_methylamin.mdl"):SetPrestige(35):Finish()

--[[-------------------------------------------------------------------------
	EXTRA PRESTIGE 45
---------------------------------------------------------------------------]]
local PRESTIGE_EXTRA_3_CATEGORY = BaseWars:CreateCategory("45th Prestige Extra", "basewars_materials/f4/prestige.png", 10, function(ply)
	if BaseWars.Config.Prestige.Enable then
		return ply:GetPrestige() >= 45
	end

	return true
end)

local ZEROS_FIRECRACKER = "1Zero's FireCracker"
BaseWars:CreateEntity("zcm_crackermachine4"):SetClass("zcm_crackermachine"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Machine"):SetPrice(250000000):SetLevel(220):SetMax(4):SetModel("models/zerochain/props_crackermaker/zcm_base.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zcm_box4"):SetClass("zcm_box"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Box"):SetPrice(20000000):SetLevel(220):SetMax(8):SetModel("models/zerochain/props_crackermaker/zcm_box.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zcm_blackpowder4"):SetClass("zcm_blackpowder"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Black Powder"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_blackpowder.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zcm_paperroll4"):SetClass("zcm_paperroll"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Paper Roll"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_paper.mdl"):SetPrestige(45):Finish()

local CIGARETTE = "2Cigarette"
BaseWars:CreateEntity("cf_cigarette_machine4"):SetClass("cf_cigarette_machine"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Machine"):SetPrice(350e6):SetLevel(250):SetMax(4):SetModel("models/cigarette_factory/cf_machine.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("cf_engine_upgrade4"):SetClass("cf_engine_upgrade"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Machine Upgrade"):SetPrice(200e6):SetLevel(250):SetMax(4):SetModel("models/maxofs2d/thruster_propeller.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("cf_storage_upgrade4"):SetClass("cf_storage_upgrade"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Storage Upgrade"):SetPrice(150e6):SetLevel(250):SetMax(4):SetModel("models/thrusters/jetpack.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("cf_delievery_box4"):SetClass("cf_delievery_box"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Box"):SetPrice(100e6):SetLevel(250):SetMax(8):SetModel("models/props_junk/cardboard_box003a.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("cf_roll_paper4"):SetClass("cf_roll_paper"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Paper"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_rollpaper.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("cf_tobacco_pack4"):SetClass("cf_tobacco_pack"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(CIGARETTE):SetName("Tobacco"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_tobacco_pack.mdl"):SetPrestige(45):Finish()

local METH_LAB = "3Zero's Methlab"
BaseWars:CreateEntity("zmlab_frezzer4"):SetClass("zmlab_frezzer"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Freezer"):SetPrice(10e12):SetLevel(10000):SetMax(4):SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zmlab_combiner4"):SetClass("zmlab_combiner"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Combiner"):SetPrice(10e12):SetLevel(10000):SetMax(4):SetModel("models/zerochain/zmlab/zmlab_combiner.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zmlab_filter4"):SetClass("zmlab_filter"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Filter"):SetPrice(3e12):SetLevel(10000):SetMax(8):SetModel("models/zerochain/zmlab/zmlab_filter.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zmlab_collectcrate4"):SetClass("zmlab_collectcrate"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Transport Crate"):SetPrice(500e9):SetLevel(10000):SetMax(8):SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zmlab_aluminium4"):SetClass("zmlab_aluminium"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Aluminium"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_aluminiumbox.mdl"):SetPrestige(45):Finish()
BaseWars:CreateEntity("zmlab_methylamin4"):SetClass("zmlab_methylamin"):SetCategory(PRESTIGE_EXTRA_3_CATEGORY):SetSubCategory(METH_LAB):SetName("Methylamin"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_methylamin.mdl"):SetPrestige(45):Finish()

--[[-------------------------------------------------------------------------
	EXTRA PRESTIGE 50
---------------------------------------------------------------------------]]
local PRESTIGE_EXTRA_4_CATEGORY = BaseWars:CreateCategory("50th Prestige Extra", "basewars_materials/f4/prestige.png", 11, function(ply)
	if BaseWars.Config.Prestige.Enable then
		return ply:GetPrestige() >= 50
	end

	return true
end)

local ZEROS_FIRECRACKER = "1Zero's FireCracker"
BaseWars:CreateEntity("zcm_crackermachine5"):SetClass("zcm_crackermachine"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Machine"):SetPrice(250000000):SetLevel(220):SetMax(10):SetModel("models/zerochain/props_crackermaker/zcm_base.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zcm_box5"):SetClass("zcm_box"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Fire Cracker Box"):SetPrice(20000000):SetLevel(220):SetMax(20):SetModel("models/zerochain/props_crackermaker/zcm_box.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zcm_blackpowder5"):SetClass("zcm_blackpowder"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Black Powder"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_blackpowder.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zcm_paperroll5"):SetClass("zcm_paperroll"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(ZEROS_FIRECRACKER):SetName("Paper Roll"):SetPrice(5000000):SetLevel(220):SetMax(2):SetModel("models/zerochain/props_crackermaker/zcm_paper.mdl"):SetPrestige(50):Finish()

local CIGARETTE = "2Cigarette"
BaseWars:CreateEntity("cf_cigarette_machine5"):SetClass("cf_cigarette_machine"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Machine"):SetPrice(350e6):SetLevel(250):SetMax(10):SetModel("models/cigarette_factory/cf_machine.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("cf_engine_upgrade5"):SetClass("cf_engine_upgrade"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Machine Upgrade"):SetPrice(200e6):SetLevel(250):SetMax(10):SetModel("models/maxofs2d/thruster_propeller.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("cf_storage_upgrade5"):SetClass("cf_storage_upgrade"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Storage Upgrade"):SetPrice(150e6):SetLevel(250):SetMax(10):SetModel("models/thrusters/jetpack.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("cf_delievery_box5"):SetClass("cf_delievery_box"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Cigarette Box"):SetPrice(100e6):SetLevel(250):SetMax(20):SetModel("models/props_junk/cardboard_box003a.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("cf_roll_paper5"):SetClass("cf_roll_paper"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Paper"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_rollpaper.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("cf_tobacco_pack5"):SetClass("cf_tobacco_pack"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(CIGARETTE):SetName("Tobacco"):SetPrice(50e6):SetLevel(250):SetMax(3):SetModel("models/cigarette_factory/cf_tobacco_pack.mdl"):SetPrestige(50):Finish()

local METH_LAB = "3Zero's Methlab"
BaseWars:CreateEntity("zmlab_frezzer5"):SetClass("zmlab_frezzer"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Freezer"):SetPrice(10e12):SetLevel(10000):SetMax(10):SetModel("models/zerochain/zmlab/zmlab_frezzer.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zmlab_combiner5"):SetClass("zmlab_combiner"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Combiner"):SetPrice(10e12):SetLevel(10000):SetMax(10):SetModel("models/zerochain/zmlab/zmlab_combiner.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zmlab_filter5"):SetClass("zmlab_filter"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Filter"):SetPrice(3e12):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_filter.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zmlab_collectcrate5"):SetClass("zmlab_collectcrate"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Transport Crate"):SetPrice(500e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_transportcrate.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zmlab_aluminium5"):SetClass("zmlab_aluminium"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Aluminium"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_aluminiumbox.mdl"):SetPrestige(50):Finish()
BaseWars:CreateEntity("zmlab_methylamin5"):SetClass("zmlab_methylamin"):SetCategory(PRESTIGE_EXTRA_4_CATEGORY):SetSubCategory(METH_LAB):SetName("Methylamin"):SetPrice(400e9):SetLevel(10000):SetMax(20):SetModel("models/zerochain/zmlab/zmlab_methylamin.mdl"):SetPrestige(50):Finish()