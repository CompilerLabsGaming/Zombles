--[[
	Gun Script
]]

--[[
	Modules & Services
]]

-- services
local ReplicatedStorage = game:WaitForChild("ReplicatedStorage")
local ServerScriptService = game:WaitForChild("ServerScriptService")
local UserInputService = game:WaitForChild("UserInputService")

-- modules
local GunModule = require(ServerScriptService.GameCore.Weapons.LaserGun)
local SoundModule = require(ServerScriptService.GameCore.Basic.PlaySounds)
local ZombieModule = require(ServerScriptService.GameCore.Monsters.Zombies.ZombieConfiguration)

-- remote events
local DamageEvent = ReplicatedStorage.GameCore.Remotes.ShotFiredAtZombie
local TagHumanoidEvent = ReplicatedStorage.GameCore.Remotes.TagHumanoid

--[[
	Wrappers
]]

-- get camera
local function GET__player_camera()
	return workspace.CurrentCamera
end

-- get tool
local function GET__tool()
	return script.Parent.Parent.Parent
end

-- get power meter
local function GET__power_meter()
	return GET__tool().Parts.PowerMeter
end

-- get scripting folder
local function GET__scripting_folder()
	return GET__tool().Scripting
end

-- get trigger pressed
local function GET__trigger_pressed()
	return GET__tool().Scripting.Values.TriggerPressed.Value
end

-- get bullet count
local function GET__bullets_in_total()
	return GET__scripting_folder().Values.BulletsInTotal.Value
end

-- get bullet count for current clip
local function GET__bullets_in_current_clip()
	return GET__scripting_folder().Values.BulletsInCurrentClip.Value
end

-- set trigger pressed
local function SET__trigger_pressed(value)
	GET__tool().Scripting.Values.TriggerPressed.Value = value
end

-- set bullet count
local function SET__bullets_in_total(value)
	GET__scripting_folder().Values.BulletsInTotal.Value = value
end

-- set bullet count
local function SET__bullets_in_current_clip(value)
	GET__scripting_folder().Values.BulletsInCurrentClip.Value = value
end

--[[
	Fire Ray Cast
]]

-- calculate hit point
local function CALCULATE__shot_hit_position()
	-- calculate part hit
	local mouse_position = UserInputService:GetMouseLocation()
	local ray = GET__player_camera():ViewportPointToRay(mouse_position.X, mouse_position.Y, 2)
	local length = 100
	local direction = ray.Direction * length
	local ray_cast_parameters = RaycastParams.new()
	local result = workspace:Raycast(ray.Origin, direction, ray_cast_parameters)

	-- output
	return result
end

--[[
	Fire Mechanics
]]

-- fire one shot
local function DO__fire_one_shot()
	-- get current gun configuration
	local configuration = GunModule.Configurations[GET__scripting_folder().Values.GunType.Value]
	
	-- detect if need reload
	-- fire gun
	if GET__bullets_in_current_clip() > 0 then
		-- play firing sound
		SoundModule.PlaySound_DefaultSettings(configuration.Firing.FiringSound)
		
		-- subtract bullet count
		SET__bullets_in_current_clip(GET__bullets_in_current_clip() - 1)
		
		-- calculate point of hit from gun
		local ray = CALCULATE__shot_hit_position()

		-- check ray hit
		if ray then
			-- get hit part
			local hit_part = ray.Instance

			-- if part exists
			if hit_part:IsA("BasePart") then
				-- get humanoid
				local humanoid = hit_part.Parent:FindFirstChild("Humanoid")
				
				-- check if is zombie
				if humanoid and humanoid:FindFirstChild("IsZombie") then
					-- deal damage
					DamageEvent:FireServer(hit_part.Parent:FindFirstChild("Scripting").Values.Health, configuration.firing.damage_dealt, humanoid.Parent.Scripting.Values.Worth.Value)
					
					-- tag zombie
					TagHumanoidEvent:FireServer(humanoid, game.Players.LocalPlayer.Name)
				end
			end
		end
		
		-- return should not reload
		return false
	-- no bullets in clip, reload needed
	else
		-- play reload sound
		SoundModule.PlaySound(configuration.Firing.ReloadSound, SoundModule.MasterVolume, configuration.Firing.ReloadTime, true)
		
		-- return should reload
		return true
	end
end

--[[
	Run Gun
]]

-- calculate power meter color change
local function CALCULATE__power_meter_drop(base_color: Color3, normalized_power_value: number): Color3
	return Color3.fromRGB(0, 0, 0):Lerp(base_color, normalized_power_value ^ 0.3)
end

-- main
local function RUN__gun()
	-- get current gun configuration
	local configuration = GunModule.Configurations[GET__scripting_folder().Values.GunType.Value]
	
	-- build gun model
	ReplicatedStorage.GameCore.RemoteEvents.BuildWeapon:FireServer(GET__tool(), configuration)
	
	-- setup lowest power color
	local depletion_color = Color3.fromRGB(0, 0 ,0) --Color3.fromRGB(configuration.appearance.power_color.r / 5, configuration.appearance.power_color.g / 5, configuration.appearance.power_color.b / 5)
	
	-- setup name
	GET__tool().Name = configuration.appearance.name
	
	-- setup activation & deactivation
	GET__tool().Activated:Connect(function()
		SET__trigger_pressed(true)
	end)
	GET__tool().Deactivated:Connect(function()
		SET__trigger_pressed(false)
	end)
	
	-- ready clip
	SET__bullets_in_current_clip(configuration.firing.shots_per_clip)
	
	-- run gun loop
	local RunService = game:WaitForChild("RunService")
	while RunService.RenderStepped:Wait() do
		-- while trigger pressed
		while GET__trigger_pressed() do
			-- shoot
			local should_reload = DO__fire_one_shot()
			
			-- do waiting
			if should_reload == false then
				-- decrease power meter
				GET__power_meter().Color = CALCULATE__power_meter_drop(configuration.appearance.power_color, GET__bullets_in_current_clip() / configuration.firing.shots_per_clip)
				
				-- wait for fire rate
				task.wait(configuration.firing.shot_rate)
			else
				-- gradually recharge power meter
				for recharge_amount = 0, configuration.firing.shots_per_clip, 1 do
					-- reload one power / bullet
					SET__bullets_in_current_clip(recharge_amount + 1)
					
					-- change power meter
					GET__power_meter().Color = depletion_color:Lerp(configuration.appearance.power_color, (1.0 / (configuration.firing.shots_per_clip)) * (GET__bullets_in_current_clip() - 1))

					-- wait for reload time
					task.wait(configuration.firing.reload_time / configuration.firing.shots_per_clip)
				end
			end
		end
	end
end

-- wait for loading
task.wait(2)

-- run
--RUN__gun()
