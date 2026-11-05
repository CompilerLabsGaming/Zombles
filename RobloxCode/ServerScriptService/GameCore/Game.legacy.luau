--[[
	Game Script
]]

--[[
	File Scoped Variables
]]

local replicated_storage = game:WaitForChild("ReplicatedStorage")
local ServerScriptService = game:WaitForChild("ServerScriptService")
local players_module = require(ServerScriptService.GameCore.Players.Players)
local give_player_module = require(ServerScriptService.GameCore.Players.GivePlayer)
local spawning_module = require(ServerScriptService.GameCore.Monsters.SpawnMonsters)

--[[
	Equip Players
]]

-- give all players starting tools
local function GIVE__all_players_starting_tools(gun_type, available_bullet_count)
	-- get all player names
	local player_names = players_module.get_all_player_names()
	
	-- for each player
	for i, player_name in pairs(player_names) do
		-- give starter gun
		give_player_module.give_player_specific_gun(player_name, gun_type, available_bullet_count)
		
		-- DEBUG
		print("Gave '" .. player_name .. "' a starter weapon!")
	end
end

--[[
	Run Game
]]

--[[-- run one round
local function RUN__Round(RoundID)
	-- player passed round
	print("Starting Round #" .. tostring(RoundID) .. ".")
	
	-- calculate zombie count
	Game = RoundID * 4
	
	-- spawn zombies
	while NeededZombieCount > 0 do
		-- spawn zombie
		spawning_module.SPAWN__zombie(game:GetService("Workspace").SpawnBrick.CFrame, roundManager.GetCurrentZombieType())
		
		-- next zombie
		NeededZombieCount -= 1
		task.wait(1)
	end
	
	-- wait for all of them to be killed
	while #game.Workspace.Monsters:GetChildren() > 0 do
		-- delay
		task.wait(5)
	end
	
	-- player passed round
	print("Congratulations! You Passed Round #" .. tostring(RoundID) .. "!")
end]]

-- run the whole game
local function RUN__Game__SpecificMap(MaxRounds)
	-- create round manager
	local roundManager = require(ServerScriptService.GameCore.Rounds.RoundManager:Clone())

	-- give each player the starter weapon
	GIVE__all_players_starting_tools("plasma_rifle", 1000000)
	
	-- wait to start rounds
	task.wait(5)

	-- set round count & init values
	roundManager.StartGame(2)

	-- run rounds
	while roundManager.RunningRounds() do
		-- run round
		-- start round
		roundManager.StartRound()

		-- spawn all zombies
		while roundManager.MonstersLeftToSpawn > 0 do
			-- intermission
			task.wait(1)

			-- spawn zombie
			spawning_module.SPAWN__zombie(game:GetService("Workspace").SpawnBrick.CFrame, roundManager.GetCurrentZombieType())
			roundManager.MarkZombieSpawned()
		end

		-- wait for all zombies to be defeated
		while roundManager.WaitForNextRound() do
			-- wait for all monsters to die
			task.wait(5)
		end
	
		-- player passed round
		print("Congratulations! You Passed Round #" .. tostring(roundManager.RoundID) .. "!")
		roundManager.NextRound()
	end
	
	-- victory!
	print("Congratulations! You beat all rounds! Thanks for playing!")
end

-- run game
local function RUN__game()
	-- setup damage remote events
	replicated_storage.GameCore.RemoteEvents.ShotFiredAtZombie.OnServerEvent:Connect(function(player, health_slot, expected_damage)
		-- do damage
		health_slot.Value -= expected_damage
	end)
	replicated_storage.GameCore.RemoteEvents.TagHumanoid.OnServerEvent:Connect(function(player, humanoid, name)
		humanoid:FindFirstChild("WhoShot").Value = name
	end)
	
	-- create remote event that 
	
	-- create collision groups for zombie doors
	
	-- setup atmosphere
	--game:WaitForChild("Lighting").FogEnd = 1000
	--sound_module.PLAY__sound("song__frozen_glow")

	-- build map
	RUN__Game__SpecificMap(4)
end

--[[
	Kickstart Game
]]

-- wait to start game
task.wait(3)

-- run game
RUN__game()
