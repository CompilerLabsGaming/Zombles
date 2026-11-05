local module = {}

-- players service
local players_service = game:GetService("Players")

-- get list of all player name's
function module.get_all_player_names()
	-- setup list
	local list = {}
	
	-- for each player
	for i, player in pairs(players_service:GetPlayers()) do
		-- get name and append it
		table.insert(list, player.Character.Name)
	end
	
	return list
end

-- get player from touch
function module.get_player_from_touch(hit)
	-- get model
	local character = hit.Parent
	
	-- check humanoid
	if character and character:FindFirstChild("Humanoid") then
		-- return humanoid or nil
		return players_service:GetPlayerFromCharacter(character)
	end
end

-- make a list of all players in order of closest to farthest
function module.get_players_by_closest_to_point(point)
	-- setup output
	local output = {}
	
	-- get all player distances
	-- for each player
	for i, player in pairs(players_service:GetPlayers()) do
		-- get the character
		local character = player.Character
		
		-- if the character exists
		if character and character:FindFirstChild("HumanoidRootPart") then
			-- get the distance
			table.insert(output, { position = character.PrimaryPart.Position, magnitude = (character.PrimaryPart.Position - point).Magnitude })
		end
	end
	
	-- sort players by closest distance
	for i = 1, #output do
		for j = i, #output do
			if i ~= j and output[i].magnitude > output[j].magnitude then
				local placeholder = output[i]
				output[i] = output[j]
				output[j] = placeholder
			end
		end
	end
	
	return output
end

-- detect if a player (instead of a zombie) is touching a part
function module.check_player_is_touching_part(main_part, humanoid_part)
	-- get data
	local model = humanoid_part.Parent
	local humanoid = model:FindFirstChild("Humanoid")
	
	-- detect living entity
	if humanoid then
		-- check to see if it is a zombie
		if model.Name == "Zombie" then
			-- not a player
			return false
		end
		
		-- must be a player
		return true
	else
		return false
	end
end

-- give player money
function module.give_player_money(player_name, amount)
	-- get player
	local player = players_service:FindFirstChild(player_name)
	
	-- DEBUG
	print("Giving " .. player_name .. " $" .. amount .. "!")
	
	-- if valid
	if player then
		-- give money
		player.leaderstats.Cash.Value += amount
	end
end

return module
