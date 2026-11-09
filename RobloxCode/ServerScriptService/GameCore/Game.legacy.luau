--[[
	Game Script
]]

--[[
	File Scoped Variables
]]

local Workspace = game:WaitForChild("Workspace")
local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local ServerScriptService = game:WaitForChild("ServerScriptService")
local SoundModule = require(ServerScriptService.GameCore.Basic.PlaySounds)
local PlayersModule = require(ServerScriptService.GameCore.Players.Players)
local GivePlayerModule = require(ServerScriptService.GameCore.Players.GivePlayer)
local MonstersModule = require(ServerScriptService.GameCore.Monsters.MonsterManager)

--[[
	Equip Players
]]

-- give all players starting tools
local function GiveAllPlayersStartingTools(gunType, availableBulletCount)
	-- get all player names
	local playerNames = PlayersModule.GetAllPlayerNames()
	
	-- for each player
	for i, playerName in pairs(playerNames) do
		-- give starter gun
		GivePlayerModule.GivePlayerSpecificGun(playerName, gunType, availableBulletCount)
		
		-- DEBUG
		print("Gave '" .. playerName .. "' a starter weapon!")
	end
end

--[[
	Run Game
]]

-- run the whole game
local function RunGame(MaxRounds)
	-- create round manager
	local roundManager = require(ServerScriptService.GameCore.Rounds.RoundManager:Clone())

	-- give each player the starter weapon
	GiveAllPlayersStartingTools("PlasmaRifle", 1000000)
	
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
			MonstersModule.SpawnZombie(Workspace.SpawnBrick.CFrame, roundManager.GetCurrentZombieType())
			roundManager.MarkZombieSpawned()
		end

		-- wait for all zombies to be defeated
		while roundManager.WaitForNextRound() do
			-- wait to check for all monsters being dead
			task.wait(5)
		end
	
		-- player passed round
		print("Congratulations! You Passed Round #" .. tostring(roundManager.RoundID) .. "!")
		roundManager.NextRound()
	end
	
	-- victory!
	print("Congratulations! You beat all rounds! Thanks for playing!")
end

-- kickstart game
local function KickstartGame()
	-- load all sounds
	SoundModule.LoadAllSounds()

	-- load all monsters
	MonstersModule.StartMonsterManager()

	-- setup damage remote events
	ReplicatedStorage.GameCore.Remotes.ShotFiredAtZombie.OnServerEvent:Connect(function(player, health_slot, expected_damage)
		-- do damage
		health_slot.Value -= expected_damage
	end)
	ReplicatedStorage.GameCore.Remotes.TagHumanoid.OnServerEvent:Connect(function(player, humanoid, name)
		humanoid:FindFirstChild("WhoShot").Value = name
	end)
	
	-- run game
	RunGame(4)
end

--[[
	Kickstart Game
]]

-- wait to start game
task.wait(3)

-- run game
KickstartGame()
