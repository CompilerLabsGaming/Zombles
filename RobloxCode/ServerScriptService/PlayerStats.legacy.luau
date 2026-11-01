--[[
	Player stats script
]]

--[[
	Globals
]]

local GLOBAL__player_service = game:GetService("Players")

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
GLOBAL__player_service.PlayerAdded:Connect(PLAYER__joined)
