--[[
    Monster Manager - Manages all monsters.
]]

-- module
local Module = {}

-- dependencies
local ServerStorage = game:GetService("ServerStorage")

--[[
    Basic Management Functionality
]]

-- create monster manager
function Module.OpenMonsterManager()
    -- create monster handler
    Module.Monsters = {}
    Module.Monsters.Zombies = {}
end

-- create monster skeletons (skeletons are the bare-bone monsters. no configuration, no AI, just templates to be replicated from ServerStorage)
local function GenerateMonsterSkeletons()
    
end

--[[
    Spawn Monsters
]]

-- spawn zombie
function Module.SpawnZombie(torsoPosition, zombieType)
	-- spawn zombie
	local zombie = ServerStorage.Monsters.Zombie:Clone()
	zombie.Scripting.Values.ZombieType.Value = zombieType
	zombie.Scripting.Values.Activated.Value = true
	zombie.Parent = game.Workspace.Monsters
	zombie.Torso.CFrame = torsoPosition + Vector3.new(0, 5, 0)
	
	-- return handle
	return zombie
end

return Module
