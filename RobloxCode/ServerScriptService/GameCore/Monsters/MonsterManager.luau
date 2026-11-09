--[[
    Monster Manager - Manages all monsters.
]]

-- module
local Module = {}

-- dependencies
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local ZombieConfigurationModule = ServerScriptService.GameCore.Monsters.Configurations.ZombieConfiguration

--[[
    Defaults
]]

local MonsterStorageLocation = game:GetService("ServerStorage").Monsters

--[[
    Part Generation
]]

-- default values
local BlankPartColor = Color3.new(0, 0, 0)
local BlankRotation = Vector3.new(0, 0, 0)
local BlankPivot = CFrame.new()

-- create part
local function CreatePart(parent: Instance, partName: string, partShape: Enum.PartType, material: Enum.Material, canCollide: boolean, position: Vector3, pivotOffset: CFrame, rotation: Vector3, size: Vector3, color: Color3)
	local output = Instance.new("Part", parent)
	
	-- setup values
	output.Name = partName
	output.Shape = partShape
	output.Material = material
    output.CanCollide = canCollide
    output.PivotOffset = pivotOffset
    output.Rotation = rotation
	output.Position = position
	output.Size = size
	output.Color = color

    -- set surfaces to default surfaces
    output.TopSurface = Enum.SurfaceType.Smooth
    output.BottomSurface = Enum.SurfaceType.Smooth

    return output
end

-- create torso
local function CreateTorso(parent, color, position)
    local size = Vector3.new(2, 2, 1)
    CreatePart(parent, "Torso", Enum.PartType.Block, Enum.Material.Plastic, true, position, CFrame.new(size.X / 2, size.Y / 2, size.Z / 2), BlankRotation, size, color)
end

-- create appendage
local function CreateAppendage(parent, name, color, canCollide, position, rotation)
    local size = Vector3.new(1, 2, 1)
    local pivotOffset = CFrame.new(size.X / 2, size.Y * (3 / 4), size.Z / 2)
    CreatePart(parent, name, Enum.PartType.Block, Enum.Material.Plastic, canCollide, position, pivotOffset, rotation, size, color)
end

-- create left leg
local function CreateLeftLeg(parent, color, position)
    CreateAppendage(parent, "LeftLeg", color, true, position + Vector3.new(0.5, 2, 0), BlankRotation)
end

-- create right leg
local function CreateRightLeg(parent, color, position)
    CreateAppendage(parent, "RightLeg", color, true, position + Vector3.new(-0.5, 2, 0), BlankRotation)
end

-- create left arm
local function CreateLeftArm(parent, color, position)
    CreateAppendage(parent, "LeftArm", color, false, position + Vector3.new(1.5, -1.5, -1.5), Vector3.new(-90, 0, 0))
end

-- create right arm
local function CreateRightArm(parent, color, position)
    CreateAppendage(parent, "RightArm", color, false, position + Vector3.new(-1.5, -1.5, -1.5), Vector3.new(-90, 0, 0))
end

-- create motor6D joint
local function CreateJoint(parent, part0, part1, offset: CFrame)
    local joint = Instance.new("Motor6D", parent)
    joint.Name = part0.Name .. "_" .. part1.Name .. "_Joint"

    -- create joint
    joint.Part0 = part0
    joint.Part1 = part1
    joint.C0 = part0.CFrame
    joint.C1 = part1.CFrame
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
    local head = CreatePart(parent, "Head", Enum.PartType.Block, Enum.Material.Plastic, false, position + Vector3.new(0, -1.5, 0), pivotOffset, BlankRotation, size, color)

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
    CreateJoint(model, model.Torso, model.LeftLeg, CFrame.new())
    CreateJoint(model, model.Torso, model.RightLeg, CFrame.new())
    CreateJoint(model, model.Torso, model.LeftArm, CFrame.new())
    CreateJoint(model, model.Torso, model.RightArm, CFrame.new())
    CreateJoint(model, model.Torso, model.Head, CFrame.new())

    -- create humanoid
    local humanoid = Instance.new("Humanoid", model)
    humanoid.DisplayName = typeName

    -- return model
    return model
end

-- create monsters
local function GenerateStoredMonsters()
    -- create monster database
    Module.Monsters = {}

    -- create default face
    local defaultFace = "rbxassetid://" .. tostring(7157327144)

    -- create zombies
    table.insert(Module.Monsters, BuildZombie("NULL", Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0), defaultFace))
    table.insert(Module.Monsters, BuildZombie("Noob", Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 255, 0), defaultFace))
end

--[[
    Spawn Monsters
]]

-- spawn zombie
function Module.SpawnZombie(torsoPosition, zombieType)
	-- spawn zombie
	local zombie = ServerStorage.Monsters[zombieType]:Clone()
	zombie.Parent = game.Workspace.Monsters
	zombie.Torso.CFrame = torsoPosition + Vector3.new(0, 5, 0)
	
	-- return handle
	return zombie
end

-- spawn all unique zombie types
function Module.Debug_SpawnAllZombieTypes(torsoPosition)
    for index, zombie in pairs(Module.Monsters) do
        Module.SpawnZombie(torsoPosition, zombie.Name)
    end
end

--[[
    Basic Management Functionality
]]

-- start monster manager
function Module.StartMonsterManager()
    -- generate monsters
    GenerateStoredMonsters()
end

return Module
