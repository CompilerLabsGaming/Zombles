--[[
	Modules
]]

local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local ServerScriptService = game:WaitForChild("ServerScriptService")
local GunModule = require(ServerScriptService.GameCore.Weapons.LaserGun)

--[[
	Gun Building Data
]]

-- weld part to handle
local function WELD__gun_part_to_handle(handle, part)
	-- create weld
	local weld = Instance.new("WeldConstraint")

	-- setup parts to weld
	weld.Part0 = handle
	weld.Part1 = part

	-- set parent
	weld.Parent = part

	return
end

-- build the gun
function BUILD__gun(tool, configuration)
	-- clear all parts of previous weapon
	tool.Parts:ClearAllChildren()
	
	-- build parts
	for index, part_data in configuration.appearance.parts do
		-- build part
		local part = Instance.new("Part")
		part.Name = part_data.part_name
		part.Shape = part_data.part_shape
		part.CFrame = tool.Handle.CFrame * CFrame.new(part_data.positional_offset) * CFrame.Angles(part_data.rotation.X, part_data.rotation.Y, part_data.rotation.Z)
		part.Material = part_data.material
		part.Size = part_data.size
		part.Color = part_data.color
		part.Parent = tool.Parts
		part.Anchored = false
		part.CanCollide = false
		
		-- clear part faces
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth

		-- weld part to handle
		WELD__gun_part_to_handle(tool.Handle, part)
	end
end

-- bind remote event
--[[ReplicatedStorage.GameCore.Remotes.BuildWeapon.OnServerEvent:Connect(function(player, tool, configuration)
	BUILD__gun(tool, configuration)
end)]]
