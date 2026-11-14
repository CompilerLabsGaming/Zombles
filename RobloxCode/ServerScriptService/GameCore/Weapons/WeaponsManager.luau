--[[
    Weapons Module
]]

-- module
local Module = {
    StoredWeapons = {},
    InUseWeapons = {}
}

-- local imports
local ServerScriptService = game:WaitForChild("ServerScriptService")
local ServerStorage = game:WaitForChild("ServerStorage")
local PlayersModule = require(ServerScriptService.GameCore.Players.Players)
local InstantiationModule = require(ServerScriptService.GameCore.Instancers.Instantiation)

--[[
    Build Parts
]]

-- build roblox handle
local function BuildRobloxHandle(parent)
    local part = InstantiationModule.CreatePart(parent, "Handle", Enum.PartType.Ball, Enum.Material.Plastic, false, Vector3.new(0, 0, 0), InstantiationModule.BlankPivot, Vector3.new(0, 0, 0), Vector3.new(1, 1, 1), InstantiationModule.BlankPartColor)

    -- customize
    part.Transparency = 0.5

    return part
end

-- build barrel
local function BuildGunBarrel(parent, length, pivotOffset, color)
    return InstantiationModule.CreatePart(parent, "Barrel", Enum.PartType.Capsule, Enum.Material.Plastic, false, Vector3.new(0, 0, 0), pivotOffset, Vector3.new(-90, 0, 0), Vector3.new(0.25, 0.25, length), color)
end

--[[
    Build Gun Models
]]

-- build electric avenger
local function BuildGun_TheEddisonMK1(parent)
    -- create model
    local output = Instance.new("Tool", parent)
    output.Name = "The_Eddison_MKI"

    -- build gun parts
    local robloxHandle = BuildRobloxHandle(output)
    local barrel = BuildGunBarrel(output, 1.25, InstantiationModule.BlankPivot, InstantiationModule.BlankPartColor)

    -- weld gun together
    InstantiationModule.CreateJoint(robloxHandle, robloxHandle, barrel, CFrame.new())

    return output
end

--[[
    Plasma Gun
    -- gun damage is measured in watts
    -- tiers are (MKI, MKII, MKIII, etc)
    -- coolant affects how fast the gun can fire, but also it's shots before it needs to cool off
]]

-- calculate tier modifier
function Module.CalculatePlasmaGunTierModifier(tier)
    return 1.0 + (tier * 0.05)
end

-- calculate coolant modifier
function Module.CalculatePlasmaGunCoolantModifier(damage, coolant)
    return (damage * coolant)
end

-- calculate weapon damage
function Module.CalculatePlasmaGunDamage(watts, tier, coolant)
    return Module.CalculatePlasmaGunCoolantModifier(watts * Module.CalculatePlasmaGunTierModifier(tier), coolant)
end

-- create plasma gun stats
function Module.SpecifyPlasmaGunStats(watts, tier, coolant)
    return { watts, tier, coolant }
end

-- create plasma gun instance
function Module.OpenNewPlasmaGun(watts, tier, coolant, battery, plasmaColor)
    return
end

--[[
    Game Wide Weapons Management
]]

-- start weapons manager
function Module.GenerateAllWeapons()
    -- build all weapons
    table.insert(Module.StoredWeapons, BuildGun_TheEddisonMK1(ServerStorage.Weapons))
end

-- clone a specific weapon
function Module.CloneWeapon(spawnPosition, modelName)
    local weapon = ServerStorage.Weapons[modelName]:Clone()
    weapon.Parent = spawnPosition

    return weapon
end

-- kickstart manager
function Module.KickstartWeaponsManager()
    -- setup module variables
    Module.StoredWeapons = {}
    Module.InUseWeapons = {}

    -- create all weapons
    Module.GenerateAllWeapons()
end

-- give weapon
function Module.GiveWeapon(playerName, modelName)
    -- clone weapon
    local weapon = Module.CloneWeapon(game.Workspace.WeaponModels, modelName)

    -- activate weapon
    -- TODO, add weapon stats and owner to 'InUseWeapons={}' later

    -- give weapon to player
    PlayersModule.GivePlayerTool(playerName, weapon)

    return weapon
end

return Module
