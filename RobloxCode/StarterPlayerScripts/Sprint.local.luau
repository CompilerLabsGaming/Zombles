--[[
	Sprint Script
]]

-- setup libraries & services
local user_input_service = game:GetService("UserInputService")

-- get humanoid & wait to activate script once player loads in
local players = game:GetService("Players")
local humanoid = players.LocalPlayer.CharacterAdded:Wait():WaitForChild("Humanoid")

-- setup controls
user_input_service.InputBegan:Connect(function(input, game_processed)
	if not game_processed and (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) then
		if humanoid then
			humanoid.WalkSpeed = 32
		end
	end
end)
user_input_service.InputEnded:Connect(function(input, game_processed)
	if not game_processed and (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) then
		if humanoid then
			humanoid.WalkSpeed = 16
		end
	end
end)
