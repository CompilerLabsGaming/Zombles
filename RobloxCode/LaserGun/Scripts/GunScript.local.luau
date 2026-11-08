--[[
	Gun Script (LocalScript inside the Tool)
	Handles input, aiming, effects and the ammo display.
	The server (GenerateGun_server) decides what actually hits and how much damage it does.
]]

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local tool = script:FindFirstAncestorOfClass("Tool")

--[[
	Modules & Remotes
	Clients cannot see ServerScriptService, so these modules must live in ReplicatedStorage.
]]

local GameCore = ReplicatedStorage:WaitForChild("GameCore")
local GunModule = require(GameCore:WaitForChild("Weapons"):WaitForChild("LaserGun"))
local SoundModule = require(GameCore:WaitForChild("Basic"):WaitForChild("PlaySounds"))

local Remotes = GameCore:WaitForChild("Remotes")
local BuildWeapon = Remotes:WaitForChild("BuildWeapon")
local FireWeapon = Remotes:WaitForChild("FireWeapon")
local ReloadWeapon = Remotes:WaitForChild("ReloadWeapon")

--[[
	Gun data
]]

local values = tool:WaitForChild("Scripting"):WaitForChild("Values")
local clip_value = values:WaitForChild("BulletsInCurrentClip") -- local-only, handy for a HUD script
local configuration = GunModule.Configurations[values:WaitForChild("GunType").Value]
local firing = configuration.firing

-- ask the server to build the model, then wait until it says it's done
BuildWeapon:FireServer(tool)
if not tool:GetAttribute("Built") then
	tool:GetAttributeChangedSignal("Built"):Wait()
end

local parts = tool:WaitForChild("Parts")
local power_meter = parts:WaitForChild("PowerMeter")
local muzzle = parts:FindFirstChild("Muzzle") or tool:WaitForChild("Handle") -- name a part "Muzzle" for beam origin

--[[
	Visuals
]]

local function update_power_meter()
	local ratio = clip_value.Value / firing.shots_per_clip
	power_meter.Color = Color3.new(0, 0, 0):Lerp(configuration.appearance.power_color, ratio ^ 0.3)
end

-- simple local laser beam (other players won't see this one; see notes)
local function draw_laser(origin: Vector3, target: Vector3)
	local distance = (target - origin).Magnitude
	if distance < 0.1 then
		return
	end

	local beam = Instance.new("Part")
	beam.Anchored = true
	beam.CanCollide = false
	beam.CanTouch = false
	beam.CanQuery = false
	beam.Material = Enum.Material.Neon
	beam.Color = configuration.appearance.power_color
	beam.Size = Vector3.new(0.15, 0.15, distance)
	beam.CFrame = CFrame.lookAt(origin, target) * CFrame.new(0, 0, -distance / 2)
	beam.Parent = workspace
	Debris:AddItem(beam, 0.08)
end

--[[
	Aiming
]]

-- cast from the camera through the mouse, ignoring our own character (and so the gun)
local function get_aim()
	local camera = workspace.CurrentCamera
	local mouse = UserInputService:GetMouseLocation()
	local ray = camera:ViewportPointToRay(mouse.X, mouse.Y)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { player.Character }

	local direction = ray.Direction * (firing.range or 100)
	local result = workspace:Raycast(ray.Origin, direction, params)
	local hit_position = if result then result.Position else ray.Origin + direction

	return result, hit_position
end

--[[
	Firing & reloading
]]

local function fire_one_shot()
	SoundModule.PlaySound_DefaultSettings(firing.firing_sound)

	clip_value.Value -= 1
	update_power_meter()

	local result, hit_position = get_aim()
	draw_laser(muzzle.Position, hit_position)

	-- the server works out whether this hit a zombie and how much damage it does
	FireWeapon:FireServer(tool, hit_position, if result then result.Instance else nil)
end

local function reload()
	SoundModule.PlaySound(firing.reload_sound, SoundModule.MasterVolume, firing.reload_time, true)
	ReloadWeapon:FireServer(tool)

	-- gradually recharge the power meter, one shot at a time
	local step = firing.reload_time / firing.shots_per_clip
	for shots = 1, firing.shots_per_clip do
		task.wait(step)
		clip_value.Value = shots
		update_power_meter()
	end
end

local trigger_held = false
local loop_running = false

local function trigger_loop()
	if loop_running then
		return
	end
	loop_running = true

	while trigger_held do
		if clip_value.Value > 0 then
			fire_one_shot()
			task.wait(firing.shot_rate)
		else
			reload()
		end
	end

	loop_running = false
end

--[[
	Setup
]]

clip_value.Value = firing.shots_per_clip
update_power_meter()

tool.Activated:Connect(function()
	trigger_held = true
	task.spawn(trigger_loop)
end)

tool.Deactivated:Connect(function()
	trigger_held = false
end)

-- make sure the gun doesn't keep firing if it's put away while the button is held
tool.Unequipped:Connect(function()
	trigger_held = false
end)
