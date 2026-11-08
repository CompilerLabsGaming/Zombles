--[[
	GenerateGun (server Script, put in ServerScriptService)
	Replaces GenerateGun_legacy.

	- Builds the gun model from the config (the client only says WHICH tool)
	- Is the authority for ammo, fire rate, range and damage
]]

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- the LaserGun config module must live in ReplicatedStorage so the client can require it too
local GameCore = ReplicatedStorage:WaitForChild("GameCore")
local GunModule = require(GameCore:WaitForChild("Weapons"):WaitForChild("LaserGun"))
local Remotes = GameCore:WaitForChild("Remotes")

--[[
	Settings
]]

local DEFAULT_RANGE = 100          -- studs, used if firing.range is not in the config
local RANGE_TOLERANCE = 10         -- extra studs allowed for latency
local HIT_TOLERANCE = 12           -- how far a zombie may have moved since the client saw it
local SHOT_RATE_TOLERANCE = 0.8    -- accept shots a bit faster than shot_rate (network jitter)
local RELOAD_TOLERANCE = 0.25      -- seconds of slack on reload timing

--[[
	Remotes (created here if they don't exist yet)
]]

local function get_remote(name)
	local remote = Remotes:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = Remotes
	end
	return remote
end

local BuildWeapon = get_remote("BuildWeapon")
local FireWeapon = get_remote("FireWeapon")
local ReloadWeapon = get_remote("ReloadWeapon")

--[[
	Helpers
]]

-- per-tool server-side state (weak keys so destroyed tools get cleaned up)
local gun_state = setmetatable({}, { __mode = "k" })

-- returns the tool only if it really is a tool belonging to this player
local function get_owned_tool(player, tool, must_be_equipped)
	if typeof(tool) ~= "Instance" or not tool:IsA("Tool") then
		return nil
	end

	local character = player.Character
	if character and tool.Parent == character then
		return tool
	end

	if not must_be_equipped and tool.Parent == player.Backpack then
		return tool
	end

	return nil
end

-- the server reads the gun type itself, never trusting a config sent by the client
local function get_configuration(tool)
	local scripting = tool:FindFirstChild("Scripting")
	local values = scripting and scripting:FindFirstChild("Values")
	local gun_type = values and values:FindFirstChild("GunType")
	if not gun_type then
		return nil
	end
	return GunModule.Configurations[gun_type.Value]
end

local function get_state(tool, firing)
	local state = gun_state[tool]
	if not state then
		state = {
			clip = firing.shots_per_clip,
			last_shot = 0,
			reload_done_at = 0,
		}
		gun_state[tool] = state
	end
	return state
end

--[[
	Building
]]

local function build_gun(tool, configuration)
	local handle = tool:FindFirstChild("Handle")
	local parts_folder = tool:FindFirstChild("Parts")
	if not handle or not parts_folder then
		return
	end

	parts_folder:ClearAllChildren()

	for _, part_data in configuration.appearance.parts do
		local part = Instance.new("Part")
		part.Name = part_data.part_name
		part.Shape = part_data.part_shape
		part.Material = part_data.material
		part.Size = part_data.size
		part.Color = part_data.color
		part.TopSurface = Enum.SurfaceType.Smooth
		part.BottomSurface = Enum.SurfaceType.Smooth

		part.Anchored = false
		part.CanCollide = false
		part.CanTouch = false
		part.CanQuery = false -- shots pass through the gun itself
		part.Massless = true  -- don't weigh down the character

		-- rotation is in RADIANS here (CFrame.Angles); wrap in math.rad() if your config uses degrees
		part.CFrame = handle.CFrame
			* CFrame.new(part_data.positional_offset)
			* CFrame.Angles(part_data.rotation.X, part_data.rotation.Y, part_data.rotation.Z)
		part.Parent = parts_folder

		-- weld after parenting so the weld captures the correct offset
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = handle
		weld.Part1 = part
		weld.Parent = part
	end

	tool.Name = configuration.appearance.name
	tool:SetAttribute("Built", true) -- the client waits for this before touching tool.Parts
end

BuildWeapon.OnServerEvent:Connect(function(player, tool)
	tool = get_owned_tool(player, tool, false)
	if not tool or tool:GetAttribute("Built") then
		return
	end

	local configuration = get_configuration(tool)
	if configuration then
		build_gun(tool, configuration)
	end
end)

--[[
	Damage
	Fold whatever your old ShotFiredAtZombie / TagHumanoid server handlers did into here
	(death handling, awarding the zombie's Worth, etc.). The client no longer sends damage or worth.
]]

local function damage_zombie(player, zombie, amount)
	local scripting = zombie:FindFirstChild("Scripting")
	local values = scripting and scripting:FindFirstChild("Values")
	local health = values and values:FindFirstChild("Health")
	local humanoid = zombie:FindFirstChildOfClass("Humanoid")
	if not health or not humanoid then
		return
	end

	-- tag the zombie so kills are credited to the shooter (uses the real Player, not a client-sent name)
	local tag = humanoid:FindFirstChild("creator")
	if not tag then
		tag = Instance.new("ObjectValue")
		tag.Name = "creator"
		tag.Parent = humanoid
		Debris:AddItem(tag, 3)
	end
	tag.Value = player

	health.Value -= amount
end

--[[
	Firing
]]

FireWeapon.OnServerEvent:Connect(function(player, tool, hit_position, hit_instance)
	-- validate everything the client sent
	if typeof(hit_position) ~= "Vector3" then
		return
	end

	tool = get_owned_tool(player, tool, true) -- must be equipped
	if not tool then
		return
	end

	local configuration = get_configuration(tool)
	if not configuration then
		return
	end

	local firing = configuration.firing
	local state = get_state(tool, firing)
	local now = os.clock()

	-- ammo / timing
	if now < state.reload_done_at - RELOAD_TOLERANCE then
		return
	end
	if state.clip <= 0 then
		return
	end
	if now - state.last_shot < firing.shot_rate * SHOT_RATE_TOLERANCE then
		return
	end

	-- range (written as "not <=" so NaN positions are rejected too)
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local max_distance = (firing.range or DEFAULT_RANGE) + RANGE_TOLERANCE
	if not ((hit_position - root.Position).Magnitude <= max_distance) then
		return
	end

	-- the shot is legal: spend ammo
	state.last_shot = now
	state.clip -= 1

	-- did it hit a zombie?
	if typeof(hit_instance) ~= "Instance" or not hit_instance:IsA("BasePart") or not hit_instance:IsDescendantOf(workspace) then
		return
	end

	local zombie = hit_instance:FindFirstAncestorOfClass("Model")
	local humanoid = zombie and zombie:FindFirstChildOfClass("Humanoid")
	if not humanoid or not humanoid:FindFirstChild("IsZombie") then
		return
	end

	-- the claimed hit point must actually be near that zombie
	local zombie_root = zombie.PrimaryPart or zombie:FindFirstChild("HumanoidRootPart")
	if not zombie_root or not ((zombie_root.Position - hit_position).Magnitude <= HIT_TOLERANCE) then
		return
	end

	damage_zombie(player, zombie, firing.damage_dealt)
end)

ReloadWeapon.OnServerEvent:Connect(function(player, tool)
	tool = get_owned_tool(player, tool, true)
	if not tool then
		return
	end

	local configuration = get_configuration(tool)
	if not configuration then
		return
	end

	local firing = configuration.firing
	local state = get_state(tool, firing)
	local now = os.clock()

	-- already reloading, or nothing to reload
	if now < state.reload_done_at or state.clip >= firing.shots_per_clip then
		return
	end

	state.clip = firing.shots_per_clip
	state.reload_done_at = now + firing.reload_time
end)
