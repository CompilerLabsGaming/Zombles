--[[
    Instantiate Parts
]]

-- module
local Module = {}

-- default values
Module.BlankPartColor = Color3.new(0, 0, 0)
Module.BlankRotation = Vector3.new(0, 0, 0)
Module.BlankPivot = CFrame.new()

-- create part
function Module.CreatePart(parent: Instance, partName: string, partShape: Enum.PartType, material: Enum.Material, canCollide: boolean, position: Vector3, pivotOffset: CFrame, rotation: Vector3, size: Vector3, color: Color3)
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

-- create motor6D joint
function Module.CreateJoint(parent, part0, part1, offset: CFrame)
    local joint = Instance.new("Motor6D", parent)
    joint.Name = part0.Name .. "_" .. part1.Name .. "_Joint"

    -- create joint
    joint.Part0 = part0
    joint.Part1 = part1
    joint.C0 = part0.CFrame
    joint.C1 = part1.CFrame
end

return Module
