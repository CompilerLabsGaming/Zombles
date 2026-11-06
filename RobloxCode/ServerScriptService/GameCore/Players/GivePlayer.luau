local Module = {}

--[[
	Dependencies
]]

-- module constants
local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local ServerScriptService = game:WaitForChild("ServerScriptService")
local PlayersModule = require(ServerScriptService.GameCore.Players.Players)
local PlayersService = game:GetService("Players")

--[[
	Give Tool(s)
]]
-- give a player a tool
function Module.GivePlayerTool(playerName, tool)
	-- get player
	local player = PlayersService:FindFirstChild(playerName)

	-- if valid
	if player then
		-- give tool
		tool.Parent = player.Backpack
	end
end

-- give all players starting tools
function Module.GiveAllPlayersAtool(tool)
	-- get all player names
	local playerNames = PlayersModule.GetAllPlayerNames()

	-- for each player
	for i, playerName in pairs(playerNames) do
		-- give tool
		Module.GivePlayerTool(playerName, tool)

		-- DEBUG
		print("Gave '" .. playerName .. "' a starter weapon!")
	end
end

--[[
	Give Player Gun
]]

-- give a player a specific gun
function Module.GivePlayerSpecificGun(playerName, gunType, availableBulletCount)
	-- create gun
	local gun = ReplicatedStorage.Weapons.LaserGun:Clone()

	-- configure gun
	gun.Scripting.Values.GunType.Value = gunType
	gun.Scripting.Values.BulletsInTotal.Value = availableBulletCount

	-- give gun
	Module.GivePlayerTool(playerName, gun)
end

return Module
