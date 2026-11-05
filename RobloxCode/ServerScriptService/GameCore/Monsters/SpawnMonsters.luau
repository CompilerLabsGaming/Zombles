--[[
	Spawn Monsters
]]

-- module
local module = {}

--[[
	Spawn Zombies
]]

-- calculate position from spawner
local function CALCULATE__zombie_torso_cframe_spawn_point(spawner_head_cframe)
	return spawner_head_cframe + Vector3.new(0, 5, 0)
end

-- spawn zombie
function module.SPAWN__zombie(torso_position, zombie_type)
	-- spawn zombie
	local zombie = game:GetService("ReplicatedStorage").Monsters.Zombie:Clone()
	zombie.Scripting.Values.ZombieType.Value = zombie_type
	zombie.Scripting.Values.Activated.Value = true
	zombie.Parent = game.Workspace.Monsters
	zombie.Torso.CFrame = CALCULATE__zombie_torso_cframe_spawn_point(torso_position)
	
	-- return handle
	return zombie
end

return module
