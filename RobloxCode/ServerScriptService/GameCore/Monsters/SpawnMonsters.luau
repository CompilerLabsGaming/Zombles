--[[
	Spawn Monsters
]]

-- module
local Module = {}

--[[
	Spawn Zombies
]]

-- calculate position from spawner
function Module.CalculateZombieTorsoSpawnCFrame(spawnerCframe)
	return spawnerCframe + Vector3.new(0, 5, 0)
end

-- spawn zombie
function Module.SpawnZombie(torsoPosition, zombieType)
	-- spawn zombie
	local zombie = game:GetService("ReplicatedStorage").Monsters.Zombie:Clone()
	zombie.Scripting.Values.ZombieType.Value = zombieType
	zombie.Scripting.Values.Activated.Value = true
	zombie.Parent = game.Workspace.Monsters
	zombie.Torso.CFrame = Module.CalculateZombieTorsoSpawnCFrame(torsoPosition)
	
	-- return handle
	return zombie
end

return Module
