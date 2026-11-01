local module = {}

--[[
	Dependencies
]]

-- module constants
local replicated_storage = game:WaitForChild("ReplicatedStorage")
local server_script_service = game:WaitForChild("ServerScriptService")
local players_module = require(server_script_service.GameCore.Scripting.Libraries.Players)
local players_service = game:GetService("Players")

--[[
	Give Tool(s)
]]
-- give a player a tool
function module.give_player_tool(player_name, tool)
	-- get player
	local player = players_service:FindFirstChild(player_name)

	-- if valid
	if player then
		-- give tool
		tool.Parent = player.Backpack
	end
end

-- give all players starting tools
function module.GIVE__all_players_tool(tool)
	-- get all player names
	local player_names = players_module.get_all_player_names()

	-- for each player
	for i, player_name in pairs(player_names) do
		-- give tool
		module.give_player_tool(player_name, tool)

		-- DEBUG
		print("Gave '" .. player_name .. "' a starter weapon!")
	end
end

--[[
	Give Player Gun
]]

-- give a player a specific gun
function module.give_player_specific_gun(player_name, gun_type, available_bullet_count)
	-- create gun
	local gun = replicated_storage.Weapons.LaserGun:Clone()

	-- configure gun
	gun.Scripting.Values.GunType.Value = gun_type
	gun.Scripting.Values.BulletsInTotal.Value = available_bullet_count

	-- give gun
	module.give_player_tool(player_name, gun)
end

return module
