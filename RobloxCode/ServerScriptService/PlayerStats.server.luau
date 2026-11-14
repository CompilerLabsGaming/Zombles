--[[
	Player stats script
]]

--[[
	Globals
]]

local PlayerService = game:GetService("Players")

--[[
	Player Joined Game
]]

-- add leaderboard stats when players join
local function PLAYER__joined(player)
	-- create leaderboard folder
	local leaderstats = Instance.new("Folder")
	
	-- add stats to player and add player to leaderboard
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	-- add money to stats
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 0
	cash.Parent = leaderstats
end

-- set leaderstats to be added when players join
PlayerService.PlayerAdded:Connect(PLAYER__joined)
