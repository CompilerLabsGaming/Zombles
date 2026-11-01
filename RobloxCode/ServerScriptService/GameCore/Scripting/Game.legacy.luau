--[[
	Game Script
]]

--[[
	File Scoped Variables
]]

local replicated_storage = game:WaitForChild("ReplicatedStorage")
local server_script_storage = game:WaitForChild("ServerScriptService")
local players_module = require(server_script_storage.GameCore.Scripting.Libraries.Players)
local give_player_module = require(server_script_storage.GameCore.Scripting.Libraries.GivePlayer)
local spawning_module = require(server_script_storage.GameCore.Scripting.Libraries.SpawningGameObjects)
local RoundInformation = require(server_script_storage.GameCore.Scripting.States.GameStates)

--[[
	Getters & Setters
]]

local function GET__round_number()
	return RoundInformation.GetCurrentRoundID()
end

local function CHANGE__NextRound(round_number)
	RoundInformation.NextRound()
end

--[[
	Run Game
]]

-- run one round
local function RUN__round(round_number)
	-- player passed round
	print("Starting Round #" .. tostring(round_number) .. ".")
	
	-- calculate zombie count
	local zombie_count = round_number * 4
	
	-- spawn zombies
	while zombie_count > 0 do
		-- spawn zombie
		spawning_module.SPAWN__zombie(game:GetService("Workspace").SpawnBrick.CFrame, RoundInformation.GetCurrentZombieType())
		
		-- next zombie
		zombie_count -= 1
		task.wait(1)
	end
	
	-- wait for all of them to be killed
	while #game.Workspace.Monsters:GetChildren() > 0 do
		-- delay
		task.wait(5)
	end
	
	-- player passed round
	print("Congratulations! You Passed Round #" .. tostring(round_number) .. "!")
end

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

-- run the whole game
local function RUN__game__specific_map(round_count)
	-- wait to give weapons
	task.wait(1)
	
	-- give each player the starter weapon
	GIVE__all_players_starting_tools("plasma_rifle", 1000000)
	
	-- wait to start rounds
	task.wait(5)

	-- run rounds
	for roundID = 1, round_count, 1 do
		-- run round
		RUN__round(roundID)
		
		-- intermission
		task.wait(1)
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
	
	-- create collision groups for zombie doors
	
	-- setup atmosphere
	--game:WaitForChild("Lighting").FogEnd = 1000
	--sound_module.PLAY__sound("song__frozen_glow")

	-- build map
	RUN__game__specific_map(1)
end

--[[
	Kickstart Game
]]

-- wait to start game
task.wait(3)

-- run game
RUN__game()
