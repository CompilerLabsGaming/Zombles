--[[
    Monster Manager - Manages all monsters.
]]

-- module
local Module = {}

-- dependencies
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local ZombieConfigurationModule = require(ServerScriptService.GameCore.Monsters.Configurations.ZombieConfiguration)
local InstantiationModule = require(ServerScriptService.GameCore.Instancers.Instantiation)

--[[
    Defaults
]]

-- monster data
local MonsterStorageLocation = game:GetService("ServerStorage").Monsters

--[[
    Part Generation
]]

-- create torso
local function CreateTorso(parent, color, position)
    local size = Vector3.new(2, 2, 1)
    InstantiationModule.CreatePart(parent, "Torso", Enum.PartType.Block, Enum.Material.Plastic, true, position, CFrame.new(size.X / 2, size.Y / 2, size.Z / 2), InstantiationModule.BlankRotation, size, color)
end

-- create appendage
local function CreateAppendage(parent, name, color, canCollide, position, rotation)
    local size = Vector3.new(1, 2, 1)
    local pivotOffset = CFrame.new(size.X / 2, size.Y * (3 / 4), size.Z / 2)
    InstantiationModule.CreatePart(parent, name, Enum.PartType.Block, Enum.Material.Plastic, canCollide, position, pivotOffset, rotation, size, color)
end

-- create left leg
local function CreateLeftLeg(parent, color, position)
    CreateAppendage(parent, "LeftLeg", color, true, position + Vector3.new(0.5, 2, 0), InstantiationModule.BlankRotation)
end

-- create right leg
local function CreateRightLeg(parent, color, position)
    CreateAppendage(parent, "RightLeg", color, true, position + Vector3.new(-0.5, 2, 0), InstantiationModule.BlankRotation)
end

-- create left arm
local function CreateLeftArm(parent, color, position)
    CreateAppendage(parent, "LeftArm", color, false, position + Vector3.new(1.5, -1.5, -1.5), Vector3.new(-90, 0, 0))
end

-- create right arm
local function CreateRightArm(parent, color, position)
    CreateAppendage(parent, "RightArm", color, false, position + Vector3.new(-1.5, -1.5, -1.5), Vector3.new(-90, 0, 0))
end

-- add head mesh
local function AddHeadMesh(parent, partName)
    -- create mesh
    local mesh = Instance.new("SpecialMesh", parent)

    -- setup mesh
    mesh.Name = partName
    mesh.MeshType = Enum.MeshType.Head
    mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
end

-- create head
local function CreateHead(parent, color, position, faceAssetID)
    -- create block
    local size = Vector3.new(2, 1, 1)
    local pivotOffset = CFrame.new(size.X / 2, size.Y / 2, size.Z / 2)
    local head = InstantiationModule.CreatePart(parent, "Head", Enum.PartType.Block, Enum.Material.Plastic, false, position + Vector3.new(0, -1.5, 0), pivotOffset, InstantiationModule.BlankRotation, size, color)

    -- add mesh
    AddHeadMesh(head, "HeadMesh")

    -- add face
    local faceDecal = Instance.new("Decal", head)
    faceDecal.Name = "FaceDecal"
    faceDecal.Face = Enum.NormalId.Front
    faceDecal.Texture = faceAssetID
end

-- create zombie
local function BuildZombie(typeName, shirtColor, pantsColor, skinColor, face)
    -- create model
    local model = Instance.new("Model", MonsterStorageLocation)
    model.Name = typeName

    -- create parts
    CreateTorso(model, shirtColor, Vector3.new(0, 2, 0))
    CreateLeftLeg(model, pantsColor, model.Torso.CFrame.Position)
    CreateRightLeg(model, pantsColor, model.Torso.CFrame.Position)
    CreateLeftArm(model, skinColor, model.Torso.CFrame.Position)
    CreateRightArm(model, skinColor, model.Torso.CFrame.Position)
    CreateHead(model, skinColor, model.Torso.CFrame.Position, face)

    -- create joints
    InstantiationModule.CreateJoint(model, model.Torso, model.LeftLeg, CFrame.new())
    InstantiationModule.CreateJoint(model, model.Torso, model.RightLeg, CFrame.new())
    InstantiationModule.CreateJoint(model, model.Torso, model.LeftArm, CFrame.new())
    InstantiationModule.CreateJoint(model, model.Torso, model.RightArm, CFrame.new())
    InstantiationModule.CreateJoint(model, model.Torso, model.Head, CFrame.new())

    -- create humanoid
    local humanoid = Instance.new("Humanoid", model)
    humanoid.DisplayName = typeName

    -- return model
    return model
end

-- create monsters
local function GenerateStoredMonsters()
    -- create monster database
    Module.StoredMonsters = {}

    -- create default face
    local defaultFace = "rbxassetid://" .. tostring(7157327144)

    -- create zombies
    table.insert(Module.StoredMonsters, BuildZombie("NULL", Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0), defaultFace))
    table.insert(Module.StoredMonsters, BuildZombie("Noob", Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), defaultFace))
end

--[[
    Clone Monsters
]]

-- clone monster
function Module.CloneMonster(torsoPosition, monsterName)
	-- spawn monster
	local monster = ServerStorage.Monsters[monsterName]:Clone()
	monster.Torso.CFrame = torsoPosition + Vector3.new(0, 5, 0)
	
	-- return handle
	return monster
end

--[[
    Basic Management Functionality
]]

-- monster table
Module.ActiveMonsters = {}

-- start monster manager
function Module.StartMonsterManager()
    -- generate prefab monsters
    GenerateStoredMonsters()

    -- reset active monster table
    Module.ActiveMonsters = {}
end

-- add one monster to the list
function Module.SpawnMonster(torsoPosition, monsterName)
    -- create model
    local monster = Module.CloneMonster(torsoPosition, monsterName)

    -- add monster to list of active monsters
    table.insert(Module.ActiveMonsters, monster)

    -- put in workspace
    monster.Parent = game.Workspace.Monsters
end

-- spawn all unique monster types
function Module.Debug_SpawnAllMonsterTypes(torsoPosition)
    for index, monster in pairs(Module.StoredMonsters) do
        Module.SpawnMonster(torsoPosition, monster.Name)
    end
end

-- run monsters
function Module.SimulateMonsters()
    -- move all monsters towards player(s)
    -- TODO
end

return Module
