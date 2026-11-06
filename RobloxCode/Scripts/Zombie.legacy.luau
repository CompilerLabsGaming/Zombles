--[[
	Zombie Script
]]

--[[
	File Scoped Variables
]]

-- last attack
local last_prickle = 0

-- modules
local sound_module = require(game:WaitForChild("ServerScriptService").GameCore.Basic.PlaySounds)
local player_module = require(game:WaitForChild("ServerScriptService").GameCore.Players.Players)

--[[
	Wrapper Functions
]]

local function GET__scripting_folder()
	return script.Parent.Parent
end

local function GET__model()
	return script.Parent.Parent.Parent
end

local function GET__activated()
	return GET__scripting_folder().Values.Activated.Value
end

local function GET__left_arm()
	return GET__model().LeftArm
end

local function GET__right_arm()
	return GET__model().RightArm
end

local function GET__left_leg()
	return GET__model().LeftLeg
end

local function GET__right_leg()
	return GET__model().RightLeg
end

local function GET__torso()
	return GET__model().Torso
end

local function GET__head()
	return GET__model().Head
end

local function GET__humanoid()
	return GET__model().Humanoid
end

local function GET__health()
	return GET__scripting_folder().Values.Health.Value
end

local function GET__damage_dealt()
	return GET__scripting_folder().Values.DamageDealt.Value
end

local function GET__damage_rate()
	return GET__scripting_folder().Values.DamageRate.Value
end

local function GET__zombie_type()
	return GET__scripting_folder().Values.ZombieType.Value
end

local function GET__worth()
	return GET__scripting_folder().Values.Worth.Value
end

local function GET__is_zombie()
	return GET__model().IsZombie.Value
end

local function SET__activated(activated)
	GET__scripting_folder().Values.Activated.Value = activated
end

local function SET__health(value)
	GET__scripting_folder().Values.Health.Value = value
end

local function SET__damage_dealt(damage)
	GET__scripting_folder().Values.DamageDealt.Value = damage
end

local function SET__damage_rate(seconds)
	GET__scripting_folder().Values.DamageRate.Value = seconds
end

local function SET__display_name(new_name)
	GET__model().Humanoid.DisplayName = new_name
end

local function SET__head_fire(enabled)
	GET__model().Head.Fire.Enabled = enabled
end

local function SET__face(asset_ID)
	GET__model().Head.Decal.Texture = asset_ID
end

local function SET__worth(worth)
	GET__scripting_folder().Values.Worth.Value = worth
end

--[[
	Deal Damage
]]

-- check if enough time has passed so that the zombie can deal damage
local function CALCULATE__can_damage()
	return os.time() - last_prickle > GET__damage_rate()
end

-- try to deal damage
local function DO__prickle(partTouching)
	local humanoid = partTouching.Parent:FindFirstChildWhichIsA("Humanoid")
	
	-- check if humanoid exists
	if GET__activated() and humanoid and CALCULATE__can_damage() and humanoid:FindFirstChild("IsZombie") == nil then
		-- deal damage
		humanoid.Health -= GET__damage_dealt()
		
		-- reset timer
		last_prickle = os.time()
	end
end

-- do jeff damage
local function DO__jeff_prickle(partTouching)
	local humanoid = partTouching.Parent:FindFirstChildWhichIsA("Humanoid")
	local player = game:GetService("Players"):GetPlayerFromCharacter(partTouching.Parent)

	-- check if humanoid exists
	if GET__activated() and humanoid and CALCULATE__can_damage() and humanoid:FindFirstChild("IsZombie") == nil and GET__zombie_type() == "jeff" then
		-- deal damage
		humanoid.Health -= GET__damage_dealt()

		-- reset timer
		last_prickle = os.time()
		
		-- jeff's power awakens
		-- open guis
		local player_gui = player:WaitForChild("PlayerGui")
		local screen_gui = Instance.new("ScreenGui", player_gui)
		local image_gui = Instance.new("ImageLabel", screen_gui)
		local image_gui_2 = Instance.new("ImageLabel", screen_gui)
		
		-- setup first image
		image_gui.Size = UDim2.new(1, 0, 1, 0)
		image_gui.Position = UDim2.new(0, 0, 0, 0)
		image_gui.Image = "rbxassetid://141447418"
		image_gui.ImageTransparency = 0
		image_gui.BackgroundTransparency = 1
		
		-- play death sound
		--sound_module.PLAY__sound("omaewa")
		
		-- wait to display glowing eyes
		wait(4)
		
		-- setup second image
		image_gui_2.Size = UDim2.new(1, 0, 1, 0)
		image_gui_2.Position = UDim2.new(0, 0, 0, 0)
		image_gui_2.Image = "rbxassetid://368111294"
		image_gui_2.ImageTransparency = 0
		image_gui_2.BackgroundTransparency = 1
		
		-- kill player
		humanoid.Health = 0
	end
end

--[[
	Take Damage
]]

local function DO__death()
	-- DEBUG
	print("Zombie Died!")
	
	-- give money
	player_module.GivePlayerMoney(GET__humanoid().WhoShot.Value, GET__worth())
	
	-- deactivate zombie
	SET__activated(false)
	
	-- break joints
	for index, joint in ipairs(GET__torso():GetJoints()) do
		joint:Destroy()
	end
	
	-- fade parts out
	for transparency = 0, 1, 0.1 do
		-- fade parts
		for index, part in ipairs(GET__model():GetDescendants()) do
			-- check for part
			if part:IsA("BasePart") then
				-- fade
				part.Transparency = transparency
			end
		end
		
		-- wait
		wait(0.2)
	end
	
	-- disappear
	GET__model():Destroy()
end

local function CHECK__alive()
	return (GET__health() > 0)
end

--[[
	Configure Zombie
]]

-- setup zombie clothing decoration
local function CONFIGURE__change_cloths__zombie(shirtColor, pantsColor, skinColor)
	-- setup part colors
	GET__torso().Color = shirtColor
	GET__head().Color = skinColor
	GET__left_arm().Color = skinColor
	GET__right_arm().Color = skinColor
	GET__left_leg().Color = pantsColor
	GET__right_leg().Color = pantsColor
end

-- setup head fire
local function CONFIGURE__change_enabled__head_fire(enabled)
	SET__head_fire(enabled)
end

-- configure damage
local function CONFIGURE__configure__damage(damage_dealt, damage_rate)
	-- setup damage
	SET__damage_dealt(damage_dealt)
	SET__damage_rate(damage_rate)
end

-- configure zombie
function CONFIGURE__zombie(zombie_type)
	-- get zombie_module
	-- get options
	local replicated_storage = game:GetService("ReplicatedStorage")
	local zombie_module = require(game:GetService("ServerScriptService").GameCore.Monsters.Zombies.ZombieConfiguration)
	local string_module = require(game:GetService("ServerScriptService").GameCore.Basic.Strings)
	
	-- configure damage
	CONFIGURE__configure__damage(zombie_module.zombie_styles[zombie_type].damage.dealt, zombie_module.zombie_styles[zombie_type].damage.rate)
	
	-- configure health
	SET__health(zombie_module.zombie_styles[zombie_type].max_health)
	
	-- dress zombie
	CONFIGURE__change_cloths__zombie(zombie_module.zombie_styles[zombie_type].colors.shirt, zombie_module.zombie_styles[zombie_type].colors.pants, zombie_module.zombie_styles[zombie_type].colors.skin)
	
	-- configure decoration
	SET__display_name(zombie_module.zombie_styles[zombie_type].display_name)
	GET__humanoid().NameDisplayDistance = 0
	CONFIGURE__change_enabled__head_fire(string_module.list_has_string(zombie_module.zombie_styles[zombie_type].decoration, "fire"))
	SET__face(zombie_module.zombie_styles[zombie_type].face)
	
	-- configure worth
	SET__worth(zombie_module.zombie_styles[zombie_type].worth)
end

--[[
	Start Zombie
]]

-- zombie main
local function RUN__zombie(zombie_type)
	-- setup humanoid variable
	local humanoid = GET__humanoid()

	-- setup damage
	GET__left_arm().Touched:Connect(DO__prickle)
	GET__right_arm().Touched:Connect(DO__prickle)
	GET__left_arm().Touched:Connect(DO__jeff_prickle)
	GET__right_arm().Touched:Connect(DO__jeff_prickle)

	-- configure zombie
	CONFIGURE__zombie(zombie_type)
	
	-- while zombie is alive
	while CHECK__alive() == true do
		-- stall while not active
		while CHECK__alive() == true and GET__activated() == false do
			-- wait
			wait(5)
		end
		
		-- make zombie walk
		while CHECK__alive() == true and GET__activated() == true do
			-- make zombie walk
			local player_positions = player_module.GetPlayersByClosestToPoint(GET__torso().Position + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10)))
			humanoid:MoveTo(player_positions[1].position)
			
			-- sleep
			wait(1)
		end
		
		-- general wait
		wait(0.5)
	end
	
	-- zombie is dead
	DO__death()
end

-- run zombie
RUN__zombie(GET__zombie_type())
