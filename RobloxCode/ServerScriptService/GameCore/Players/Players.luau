local Module = {}

-- players service
local PlayersService = game:GetService("Players")

-- get list of all player name's
function Module.GetAllPlayerNames()
	-- setup list
	local list = {}
	
	-- for each player
	for i, player in pairs(PlayersService:GetPlayers()) do
		-- get name and append it
		table.insert(list, player.Character.Name)
	end
	
	return list
end

-- get player from touch
function Module.GetPlayerFromTouch(hit)
	-- get model
	local character = hit.Parent
	
	-- check humanoid
	if character and character:FindFirstChild("Humanoid") then
		-- return humanoid or nil
		return PlayersService:GetPlayerFromCharacter(character)
	end
	
	return nil
end

-- make a list of all players in order of closest to farthest
function Module.GetPlayersByClosestToPoint(point)
	-- setup output
	local output = {}
	
	-- get all player distances
	-- for each player
	for i, player in pairs(PlayersService:GetPlayers()) do
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
function Module.CheckPlayerIsTouchingPart(main_part, humanoid_part)
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
function Module.GivePlayerMoney(playerName, amount)
	-- get player
	local player = PlayersService:FindFirstChild(playerName)
	
	-- DEBUG
	print("Giving " .. playerName .. " $" .. amount .. "!")
	
	-- if valid
	if player then
		-- give money
		player.leaderstats.Cash.Value += amount
	end
end

return Module
